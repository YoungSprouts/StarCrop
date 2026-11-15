import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:sensors_plus/sensors_plus.dart';

import '../data/user/user_db.dart';
import '../engine/ar_capability_checker.dart';
import '../engine/device_attitude.dart';

/// Bridges the one-time AR capability probe (real compass/accelerometer
/// events) with the remembered result in UserDb.DeviceProfiles.arSupported
/// — see the column's doc comment in user_db.dart for why this is cached
/// per-device rather than re-checked on every camera_check open.
///
/// Kept separate from ArCapabilityChecker (engine/) so the actual pass/fail
/// judgment stays plugin-free and unit-testable; this class only owns the
/// "listen to real sensors for a bit, then persist" side.
class ArCapabilityRepository {
  final UserDb userDb;
  ArCapabilityRepository(this.userDb);

  static const _probeWindow = Duration(milliseconds: 1500);

  /// Returns the remembered capability for [deviceId] if this device has
  /// already been probed; otherwise runs a short live probe and persists
  /// the result before returning it. Call this once, early, before deciding
  /// which camera_check UI to build (live AR overlay vs static
  /// draw-after-capture).
  Future<bool> resolveArSupport(String deviceId) async {
    final existing = await (userDb.select(userDb.deviceProfiles)
          ..where((t) => t.deviceId.equals(deviceId)))
        .getSingleOrNull();

    if (existing?.arSupported != null) {
      return existing!.arSupported!;
    }

    final supported = await _probe();
    await _persist(deviceId, supported);
    return supported;
  }

  /// Feeds the *same* raw accelerometer + magnetometer pair through the
  /// *same* DeviceAttitude.cameraPointing fusion the live overlay actually
  /// uses (camera_check_screen's _updateAttitude), and checks the derived
  /// azimuth/pitch for real variation.
  ///
  /// This used to check FlutterCompass's already-fused heading instead of
  /// the raw magnetometer stream — a different sensor pipeline than the one
  /// the live overlay depends on. That let a device whose OS-level compass
  /// worked fine (flutter_compass) but whose raw magnetometer never fired
  /// through sensors_plus (common — many Android magnetometers report
  /// stale/zero until a figure-8 calibration gesture, or aren't exposed the
  /// same way the platform's own compass API is) pass this probe, cache
  /// arSupported=true permanently, and then never actually draw anything:
  /// _lastMag would stay null forever on the real screen, _updateAttitude
  /// would keep bailing out, and the overlay's null-check in build() would
  /// never pass. Probing the exact pipeline the screen uses is the only way
  /// a "supported" result here is actually a promise the overlay will draw.
  Future<bool> _probe() async {
    final headingSamples = <double>[];
    final pitchSamples = <double>[];
    final completer = Completer<void>();

    List<double>? lastAccel;
    List<double>? lastMag;

    void deriveAndRecord() {
      final accel = lastAccel;
      final mag = lastMag;
      if (accel == null || mag == null) return;
      final attitude = DeviceAttitude.cameraPointing(gravity: accel, magnetic: mag);
      if (attitude == null) return;
      headingSamples.add(attitude.azimuthDeg);
      pitchSamples.add(attitude.altitudeDeg);
    }

    final accelSub = accelerometerEventStream().listen((event) {
      lastAccel = [event.x, event.y, event.z];
      deriveAndRecord();
    });
    final magSub = magnetometerEventStream().listen((event) {
      lastMag = [event.x, event.y, event.z];
      deriveAndRecord();
    });

    Timer(_probeWindow, () {
      if (!completer.isCompleted) completer.complete();
    });

    await completer.future;
    await accelSub.cancel();
    await magSub.cancel();

    return ArCapabilityChecker.isArCapable(
      headingSamples: headingSamples,
      pitchSamples: pitchSamples,
    );
  }

  /// Only ever writes [arSupported] — deviceId is the sole other field in
  /// the companion, so an existing row's model/fieldOfViewDeg/etc (written
  /// elsewhere, e.g. camera_check_screen) are left untouched on conflict.
  Future<void> _persist(String deviceId, bool supported) async {
    await userDb.into(userDb.deviceProfiles).insertOnConflictUpdate(
          DeviceProfilesCompanion.insert(
            deviceId: deviceId,
            arSupported: Value(supported),
          ),
        );
  }
}
