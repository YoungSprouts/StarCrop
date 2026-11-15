import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:uuid/uuid.dart';

import '../../data/user/user_db.dart';
import '../../data/cache/cache_db.dart';
import '../../repository/sky_repository.dart';
import '../../repository/sky_models.dart';
import '../../repository/sky_snapshot.dart' as snap;
import '../../repository/ar_capability_repository.dart';
import '../../engine/sky_position_confirmation.dart';
import '../../engine/astro_engine.dart';
import '../../engine/aim_lock_detector.dart';
import '../../engine/constellation_figure_layout.dart';
import '../../engine/device_attitude.dart';
import '../theme/app_theme.dart';
import '../theme/app_assets.dart';
import '../widgets/identified_constellation_overlay.dart';
import 'suggested_activities_screen.dart';
import 'sky_chart_screen.dart';

/// Live camera view that identifies which constellation the phone is aimed
/// at (compass + accelerometer, fused by DeviceAttitude, compared against
/// where AstroEngine predicts each constellation's center to be) and then
/// reveals it.
///
/// Flow:
///   1. A reticle sits at screen center, white.
///   2. When the aim is within AimLockDetector's tolerance of a visible
///      constellation, the reticle turns green.
///   3. Once that aim holds steady for a short moment (so a shaky hand
///      doesn't flicker it), the reticle fades out and the constellation is
///      *identified*: its star dots spread out from the center into the
///      constellation figure, the lines draw in, and its name fades in.
///   4. Drifting the aim away resets back to the reticle.
///
/// Once a constellation is identified, its figure is laid out on its own
/// (ConstellationFigureLayout) — it is NOT projected through the camera's
/// field of view, so it doesn't depend on FOV, heading, or pitch to be
/// drawn. Those only decide *which* constellation is being aimed at.
///
/// Tapping the shutter still saves a photo (a record for the farmer, and
/// what Constellation Detail redraws the figure on top of later) and
/// confirms the sky position from the sensor reading + predicted stars —
/// never from the photo's pixels. Devices whose compass/accelerometer aren't
/// producing usable data at all (see ArCapabilityRepository) can't do any of
/// this — for those, the screen says so plainly. Uses a device_id of
/// 'default' since this app has no login/device-registration flow.
///
/// NOTE: the old 'ar_overlay_mode' setting ('always' vs 'reveal') is no
/// longer read here — the always-on whole-sky FOV drawing was removed.
class CameraCheckScreen extends StatefulWidget {
  const CameraCheckScreen({super.key});

  @override
  State<CameraCheckScreen> createState() => _CameraCheckScreenState();
}

class _CameraCheckScreenState extends State<CameraCheckScreen> {
  CameraController? _controller;
  bool _initializing = true;
  bool _processing = false;
  String? _error;
  PositionConfirmationResult? _result;

  // Live AR state. Null _arSupported = capability not resolved yet (or no
  // saved location to project against); true/false once resolved. See
  // ArCapabilityRepository for why this is a one-time-per-device check
  // rather than something re-probed on every screen open.
  bool? _arSupported;
  List<ObservedLine> _arLines = const [];
  List<ObservedConstellation> _visibleConstellations = const [];
  StreamSubscription<AccelerometerEvent>? _accelSub;
  StreamSubscription<MagnetometerEvent>? _magSub;
  List<double>? _lastAccel;
  List<double>? _lastMag;
  double? _liveAzimuthDeg;
  double? _livePitchDeg;

  // Aiming state. _aimedConstCode is whatever's within AimLockDetector's
  // tight tolerance *right now* (updated every sensor sample, drives the
  // reticle's color); _lockedConstCode is only set once the same code has
  // held for _lockHoldDuration (drives the actual reveal). _aimStartedAt
  // tracks how long the current _aimedConstCode has been continuously true,
  // as a plain field — no rebuild needed for it on its own.
  String? _aimedConstCode;
  DateTime? _aimStartedAt;
  String? _lockedConstCode;
  String? _lockedConstName;
  ConstellationFigure? _lockedFigure;
  static const _lockHoldDuration = Duration(milliseconds: 550);

  // The on-screen size the camera preview is drawn into — captured from the
  // LayoutBuilder in build() so _captureAndMatch can run the same
  // star-in-frame check against the size the farmer was just looking at,
  // rather than guessing at a screen size.
  Size? _overlaySize;

  // Whatever was just captured (see _captureAndMatch) — consumed by
  // _ResultOverlay. The figure is the identified constellation's standalone
  // shape (null if nothing was identified); it's drawn on the photo with no
  // FOV/heading/pitch involved.
  String? _lastCapturedPath;
  ConstellationFigure? _lastCaptureFigure;
  String? _lastCaptureConstCode;
  String? _lastCaptureConstName;
  // Shown in the result card: where and when this capture happened.
  String? _lastCaptureLocationLabel;
  DateTime? _lastCaptureTime;

  static const _defaultFovDeg = 60.0; // typical phone rear-camera horizontal FOV; refine per-device later

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initAr();
  }

  /// Resolves this device's AR capability (cached after the first probe —
  /// see ArCapabilityRepository), and if supported, loads the predicted
  /// constellation lines/centers for the farmer's saved location and
  /// starts listening to the sensors that drive aiming. Runs concurrently
  /// with _initCamera() rather than after it, so neither one waits on the
  /// other.
  Future<void> _initAr() async {
    final userDb = context.read<UserDb>();
    final loc = await userDb.activeLocation();
    if (loc == null) return; // no saved location -- nothing to aim against yet

    final arCapability = context.read<ArCapabilityRepository>();
    final supported = await arCapability.resolveArSupport('default');
    if (!mounted) return;

    if (!supported) {
      setState(() => _arSupported = false);
      return; // this device has no working compass/accelerometer pair
    }

    final skyRepo = context.read<SkyRepository>();
    final now = DateTime.now().toUtc();
    final lines = await skyRepo.constellationLinesAbove(
      latDeg: loc.lat,
      lonDeg: loc.lon,
      utc: now,
    );
    final constellations = await skyRepo.constellationsAbove(
      latDeg: loc.lat,
      lonDeg: loc.lon,
      utc: now,
      minAltitudeDeg: 0,
    );
    if (!mounted) return;

    setState(() {
      _arSupported = true;
      _arLines = lines;
      _visibleConstellations = constellations;
    });

    _accelSub = accelerometerEventStream().listen((event) {
      _lastAccel = [event.x, event.y, event.z];
      _updateAttitude();
    });
    _magSub = magnetometerEventStream().listen((event) {
      _lastMag = [event.x, event.y, event.z];
      _updateAttitude();
    });
  }

  /// Recomputes the camera's pointing direction from whichever accelerometer
  /// and magnetometer samples have arrived so far, then smooths it into the
  /// displayed heading/pitch. Sensor events arrive independently and much
  /// faster than a person can usefully perceive, so each new sample is
  /// blended a fraction of the way toward the raw reading rather than
  /// snapping straight to it -- a farmer's hand isn't perfectly steady. This
  /// same smoothed reading is also what _captureAndMatch treats as "the"
  /// pointing direction, and what feeds the aim lock below.
  void _updateAttitude() {
    final accel = _lastAccel;
    final mag = _lastMag;
    if (accel == null || mag == null) return;

    final attitude = DeviceAttitude.cameraPointing(gravity: accel, magnetic: mag);
    if (attitude == null || !mounted) return;

    final newHeading = _liveAzimuthDeg == null
        ? attitude.azimuthDeg
        : _lerpAngleDeg(_liveAzimuthDeg!, attitude.azimuthDeg, 0.2);
    final newPitch = _livePitchDeg == null
        ? attitude.altitudeDeg
        : _livePitchDeg! + (attitude.altitudeDeg - _livePitchDeg!) * 0.2;

    setState(() {
      _liveAzimuthDeg = newHeading;
      _livePitchDeg = newPitch;
    });

    _updateAimLock(newHeading, newPitch);
  }

  /// Tracks whether the current pointing direction is holding steady on the
  /// same constellation long enough to identify it. Called on every sensor
  /// sample, so this stays cheap — no DB access happens here; the figure is
  /// built from lines already loaded in _initAr.
  void _updateAimLock(double headingDeg, double pitchDeg) {
    final code = AimLockDetector.lockedConstellationCode(
      visible: _visibleConstellations,
      headingDeg: headingDeg,
      pitchDeg: pitchDeg,
    );

    if (code != _aimedConstCode) {
      _aimedConstCode = code;
      _aimStartedAt = code == null ? null : DateTime.now();
      if (code == null && _lockedConstCode != null) {
        // Aim drifted off whatever was identified -- back to the reticle.
        setState(() {
          _lockedConstCode = null;
          _lockedConstName = null;
          _lockedFigure = null;
        });
      } else if (mounted) {
        setState(() {}); // just to repaint the reticle's color
      }
      return;
    }

    if (code == null || _lockedConstCode == code) return; // nothing new to do

    final startedAt = _aimStartedAt;
    if (startedAt != null && DateTime.now().difference(startedAt) >= _lockHoldDuration) {
      _identify(code);
    }
  }

  /// Marks [code] as identified: builds its standalone figure from the
  /// already-loaded lines and looks up its name from the already-loaded
  /// constellation list. Synchronous — no DB round trip — so the figure and
  /// its name appear together the instant the lock completes.
  void _identify(String code) {
    if (!mounted) return;

    final figure = ConstellationFigureLayout.fromLines(
      _arLines.where((l) => l.constCode == code).toList(),
    );
    if (figure.isEmpty) return; // no usable lines seeded for this one

    final matches = _visibleConstellations.where((c) => c.code == code);
    final name = matches.isEmpty ? code : matches.first.latinName;

    setState(() {
      _lockedConstCode = code;
      _lockedConstName = name;
      _lockedFigure = figure;
    });
  }

  /// Blends [from] toward [to] by fraction [t], wrapping correctly across
  /// the 0/360 seam (plain linear interpolation would swing the long way
  /// around whenever heading crosses due north).
  double _lerpAngleDeg(double from, double to, double t) {
    double delta = (to - from) % 360;
    if (delta > 180) delta -= 360;
    if (delta < -180) delta += 360;
    return (from + delta * t) % 360;
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception('No camera found on this device.');
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(back, ResolutionPreset.medium, enableAudio: false);
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _controller = controller;
        _initializing = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _initializing = false;
      });
    }
  }

  /// Takes the photo (kept purely as a visual record for the farmer, and
  /// for Constellation Detail to redraw the overlay on top of later) and
  /// confirms the sky position from the live sensor reading + predicted
  /// star positions — never from the photo's pixels. If this device's
  /// compass/accelerometer pair isn't producing usable data, this refuses
  /// up front with a plain explanation instead of attempting anything.
  Future<void> _captureAndMatch() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _processing) return;

    if (_arSupported != true || _liveAzimuthDeg == null || _livePitchDeg == null) {
      setState(() {
        _error = _arSupported == false
            ? "This device's compass isn't giving a stable reading, so live "
                "sky detection isn't available here."
            : 'Still finding your compass reading — hold the phone steady '
                'and try again in a moment.';
      });
      return;
    }

    setState(() {
      _processing = true;
      _result = null;
      _error = null;
    });

    // Freeze the reading at the moment of capture -- exactly what the
    // farmer saw a moment ago, not whatever the sensors happen to read once
    // the async work below finishes.
    final headingDeg = _liveAzimuthDeg!;
    final pitchDeg = _livePitchDeg!;
    final size = _overlaySize;
    final capturedAt = DateTime.now();

    try {
      final file = await controller.takePicture();

      final userDb = context.read<UserDb>();
      final loc = await userDb.activeLocation();
      if (loc == null) throw Exception('Set your farm location first.');

      final now = DateTime.now().toUtc();
      final skyRepo = context.read<SkyRepository>();
      final predicted = await skyRepo.starsAbove(
        latDeg: loc.lat,
        lonDeg: loc.lon,
        utc: now,
        minAltitudeDeg: 20, // ignore near-horizon stars, most affected by haze/obstruction
        maxMagnitude: 3.0, // naked-eye-bright stars only
      );

      final confirmation = SkyPositionConfirmation.confirmationFor(
        predicted: predicted,
        headingDeg: headingDeg,
        pitchDeg: pitchDeg,
        fovDeg: _defaultFovDeg,
        screenWidth: size?.width ?? 1080,
        screenHeight: size?.height ?? 1920,
      );

      // Identifies *which* constellation is roughly centered in the frame,
      // purely from the pointing direction against the seeded Hipparcos/
      // constellation-center data (SkyRepository.nearestConstellationCode)
      // -- never from the photo's pixels. If the live aim lock already
      // identified one, that wins. "No match found" should mean exactly one
      // thing: no seeded constellation is anywhere near where the phone is
      // pointed.
      final matchedConstCode = _lockedConstCode ??
          await skyRepo.nearestConstellationCode(
            latDeg: loc.lat,
            lonDeg: loc.lon,
            utc: now,
            headingDeg: headingDeg,
            pitchDeg: pitchDeg,
          );

      // 'failed' (shown to the farmer as "No match found") only means no
      // constellation was found near the pointing direction at all. If one
      // *was* found, still surface the in-frame star confidence as
      // 'confirmed' vs 'unclear' rather than flattening every successful
      // location match into an identical label.
      final positionResult = matchedConstCode == null
          ? 'failed'
          : (confirmation.result == 'failed' ? 'unclear' : confirmation.result);

      final displayResult = PositionConfirmationResult(
        starsInFrame: confirmation.starsInFrame,
        totalPredicted: confirmation.totalPredicted,
        confidence: confirmation.confidence,
        result: positionResult,
        headingDeg: confirmation.headingDeg,
        pitchDeg: confirmation.pitchDeg,
      );

      // Ensure a device profile row exists (id 'default' — no multi-device tracking).
      await userDb.into(userDb.deviceProfiles).insertOnConflictUpdate(
            DeviceProfilesCompanion.insert(
              deviceId: 'default',
              model: const Value('unknown'),
              fieldOfViewDeg: Value(_defaultFovDeg),
            ),
          );

      final obsId = const Uuid().v4();
      await userDb.into(userDb.photoObservations).insert(
            PhotoObservationsCompanion.insert(
              obsId: obsId,
              locationId: loc.locationId,
              deviceId: 'default',
              filePath: file.path,
              takenAt: capturedAt,
            ),
          );
      await userDb.into(userDb.photoResults).insert(
            PhotoResultsCompanion.insert(
              obsId: obsId,
              starsDetected: Value(confirmation.totalPredicted),
              starsMatched: Value(confirmation.starsInFrame.length),
              confidence: Value(confirmation.confidence),
              rotationDeg: const Value(0.0), // not applicable — pointing is sensor-derived, not recovered from pixels
              shiftXPx: const Value(0.0),
              shiftYPx: const Value(0.0),
              result: Value(positionResult),
              recoveredHeadingDeg: Value(headingDeg),
              recoveredPitchDeg: Value(pitchDeg),
              matchedConstCode: Value(matchedConstCode),
            ),
          );

      // Name of the identified constellation for the result card: from the
      // already-loaded visible list when possible, else a plain lookup.
      String? matchedName;
      if (matchedConstCode != null) {
        final known = _visibleConstellations.where((c) => c.code == matchedConstCode);
        matchedName = known.isNotEmpty
            ? known.first.latinName
            : await skyRepo.constellationLatinName(matchedConstCode);
      }

      // Standalone figure of the identified constellation for the result
      // card's photo, built from the lines already loaded for aiming (only
      // the shape is needed, so no fresh query).
      ConstellationFigure? capturedFigure;
      if (matchedConstCode != null) {
        final f = ConstellationFigureLayout.fromLines(
          _arLines.where((l) => l.constCode == matchedConstCode).toList(),
        );
        if (!f.isEmpty) capturedFigure = f;
      }

      // Refresh Sky Chart's cached "what's up right now" summary
      // (CacheDb.SkySnapshot) with this capture's own reading, so Home's
      // preview card and Sky Chart both pick up the just-identified
      // constellation immediately. Best-effort: a failure here should never
      // block the result the farmer is already looking at.
      if (mounted) {
        final cacheDb = context.read<CacheDb>();
        final constellationsNow = await skyRepo.constellationsAbove(
          latDeg: loc.lat,
          lonDeg: loc.lon,
          utc: now,
          minAltitudeDeg: 0,
        );
        await snap.saveSkySnapshot(
          cacheDb: cacheDb,
          constellations: constellationsNow,
          moonPhase: AstroEngine.moonPhase(now),
        );
      }

      if (!mounted) return;
      setState(() {
        _result = displayResult;
        _lastCapturedPath = file.path;
        _lastCaptureFigure = capturedFigure;
        _lastCaptureConstCode = matchedConstCode;
        _lastCaptureConstName = matchedName;
        _lastCaptureLocationLabel = loc.label;
        _lastCaptureTime = capturedAt;
      });
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  /// Result-card shortcut: closes the card, then opens Suggested Activities,
  /// which recomputes today's guidance from the current sky/weather on open.
  void _openActivities() {
    setState(() => _result = null);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SuggestedActivitiesScreen()),
    );
  }

  /// Result-card shortcut: closes the card, then opens Sky Chart with the
  /// identified constellation already selected.
  void _openSkyChart() {
    final code = _lastCaptureConstCode;
    setState(() => _result = null);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SkyChartScreen(initialConstCode: code)),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _accelSub?.cancel();
    _magSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppColors.forestGreen,
        title: const Text('Camera Check'),
        leading: IconButton(
          icon: Image.asset(AppIcons.chevronLeftWhite, width: 18, height: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: _initializing
          ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
          : _error != null && _controller == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(_error!, style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    // Captured (not via setState -- purely a read for the
                    // next capture, doesn't need to trigger a rebuild) so
                    // _captureAndMatch checks stars against the exact size
                    // the preview is actually being drawn into.
                    _overlaySize = Size(constraints.maxWidth, constraints.maxHeight);

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        if (_controller != null) CameraPreview(_controller!),

                        // Reticle while nothing is identified, fading out
                        // the instant an identification completes. Turns
                        // green as soon as the aim is close enough.
                        if (_arSupported == true)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: _lockedConstCode == null ? 1.0 : 0.0,
                                child: Center(
                                  child: _AimReticle(aimed: _aimedConstCode != null),
                                ),
                              ),
                            ),
                          ),

                        // Identified constellation: dots spread out from the
                        // center into the figure, lines draw in, name fades
                        // in. Keyed by code so a different constellation
                        // replays the animation. No FOV/heading/pitch used.
                        if (_lockedConstCode != null && _lockedFigure != null)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: IdentifiedConstellationOverlay(
                                key: ValueKey(_lockedConstCode),
                                figure: _lockedFigure!,
                                name: _lockedConstName,
                              ),
                            ),
                          ),

                        if (_arSupported == false)
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "This device's compass isn't reporting stable "
                                "data, so live sky detection isn't available "
                                "on it.",
                                style: TextStyle(color: Colors.white, fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        // Result card fades in and out (AnimatedSwitcher keeps
                        // the old card on screen while it fades away).
                        Positioned.fill(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: _result != null
                                ? _ResultOverlay(
                                    key: const ValueKey('result'),
                                    result: _result!,
                                    onDismiss: () => setState(() => _result = null),
                                    filePath: _lastCapturedPath,
                                    figure: _lastCaptureFigure,
                                    constName: _lastCaptureConstName,
                                    locationLabel: _lastCaptureLocationLabel,
                                    capturedAt: _lastCaptureTime,
                                    onOpenActivities: _openActivities,
                                    onOpenSkyChart: _openSkyChart,
                                  )
                                : const SizedBox.shrink(key: ValueKey('no-result')),
                          ),
                        ),
                        if (_error != null && _result == null)
                          Positioned(
                            top: 20,
                            left: 20,
                            right: 20,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(_error!, style: const TextStyle(color: Colors.white)),
                            ),
                          ),
                        Positioned(
                          // Sits above the device's gesture bar / nav
                          // buttons, whatever their height.
                          bottom: 16 + MediaQuery.paddingOf(context).bottom,
                          left: 0,
                          right: 0,
                          child: Center(
                            // Vanishes while the result card is up and fades
                            // back once it's dismissed. IgnorePointer stops
                            // taps on the invisible button.
                            child: IgnorePointer(
                              ignoring: _result != null,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                opacity: _result == null ? 1.0 : 0.0,
                                child: _ShutterButton(
                                  processing: _processing,
                                  onTap: _captureAndMatch,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}

/// Camera Check's shutter: white disc, gold ring, dark green camera icon.
/// Sized from the screen's shorter side (clamped) so it stays comfortably
/// tappable on a small phone and doesn't look tiny on a tablet.
class _ShutterButton extends StatelessWidget {
  final bool processing;
  final VoidCallback onTap;
  const _ShutterButton({required this.processing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    // ~76px on a typical phone; never below 64 (easy to tap) or above 80.
    final size = (shortest * 0.19).clamp(64.0, 80.0);

    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(side: BorderSide(color: AppColors.gold, width: 3)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: processing ? null : onTap,
          child: Center(
            child: processing
                ? SizedBox(
                    width: size * 0.34,
                    height: size * 0.34,
                    child: const CircularProgressIndicator(strokeWidth: 3),
                  )
                : Image.asset(AppIcons.cameraDark, width: size * 0.42, height: size * 0.42),
          ),
        ),
      ),
    );
  }
}

/// The center reticle shown before a constellation is identified.
/// White/translucent by default; fills soft green the instant the aim is
/// within AimLockDetector's tolerance, even before the hold duration that
/// actually triggers the identification — so the farmer gets immediate
/// feedback that they're close, not just a binary "found it".
class _AimReticle extends StatelessWidget {
  final bool aimed;
  const _AimReticle({required this.aimed});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: aimed ? AppColors.sageGreen : Colors.white.withValues(alpha: 0.85),
          width: 3,
        ),
        color: aimed ? AppColors.sageGreen.withValues(alpha: 0.18) : Colors.transparent,
      ),
    );
  }
}

class _ResultOverlay extends StatelessWidget {
  final PositionConfirmationResult result;
  final VoidCallback onDismiss;
  final String? filePath;
  final ConstellationFigure? figure;

  /// Name of the identified constellation, or null if none was found.
  final String? constName;

  /// Label of the saved farm location and the moment of capture — both come
  /// from the actual capture, never hardcoded.
  final String? locationLabel;
  final DateTime? capturedAt;
  final VoidCallback onOpenActivities;
  final VoidCallback onOpenSkyChart;

  const _ResultOverlay({
    super.key,
    required this.result,
    required this.onDismiss,
    required this.onOpenActivities,
    required this.onOpenSkyChart,
    this.filePath,
    this.figure,
    this.constName,
    this.locationLabel,
    this.capturedAt,
  });

  bool get _hasPhoto => filePath != null;

  @override
  Widget build(BuildContext context) {
    final isConfirmed = result.result == 'confirmed';
    final isUnclear = result.result == 'unclear';
    final color = isConfirmed
        ? AppColors.sageGreen
        : isUnclear
            ? AppColors.badgeGold
            : const Color(0xFFC0453A);
    final label = isConfirmed ? 'Sky confirmed' : (isUnclear ? 'Not quite sure' : 'No match found');

    // Only offer the follow-up links when a constellation was identified.
    final name = constName;
    final hasName = name != null && name.isNotEmpty;

    final at = capturedAt;
    final heading = result.headingDeg;
    final pitch = result.pitchDeg;

    return Container(
      color: Colors.black.withValues(alpha: 0.75),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The captured photo with the identified constellation drawn
                // on it as a finished, static figure (no animation, no name —
                // the name is shown by the card itself, just below).
                if (_hasPhoto)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(File(filePath!), fit: BoxFit.cover),
                          if (figure != null)
                            IdentifiedConstellationOverlay(
                              figure: figure!,
                              animate: false,
                            ),
                        ],
                      ),
                    ),
                  )
                else if (isConfirmed)
                  Image.asset(AppIcons.verified, width: 48, height: 48)
                else
                  Icon(Icons.help_outline, size: 48, color: color),
                const SizedBox(height: 12),
                Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: color)),
                if (hasName) ...[
                  const SizedBox(height: 4),
                  Text(
                    isConfirmed ? name : 'Possibly $name',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: AppColors.forestGreen,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                // Capture details, all taken from this specific capture.
                _InfoRow(
                  label: 'Direction',
                  value: '${heading.round() % 360}\u00B0 ${_compassPoint(heading)}',
                ),
                _InfoRow(
                  label: 'Height',
                  value: '${pitch.round()}\u00B0 above horizon',
                ),
                _InfoRow(label: 'Location', value: locationLabel ?? 'Unknown'),
                _InfoRow(label: 'Date', value: at == null ? '-' : _formatDate(at)),
                _InfoRow(label: 'Time', value: at == null ? '-' : _formatTime(at)),
                if (hasName) ...[
                  const SizedBox(height: 14),
                  Text(
                    "Check Suggested Activities for today's updated guidance, "
                    'and Sky Chart to learn more about $name.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, height: 1.35, color: AppColors.forestGreen),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onOpenActivities,
                      child: const Text('Suggested Activities'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onOpenSkyChart,
                      child: const Text('Learn more in Sky Chart'),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextButton(onPressed: onDismiss, child: const Text('Try again')),
                ] else ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: onDismiss, child: const Text('Try again')),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One "Label: value" line in the result card.
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontSize: 13, color: AppColors.gray)),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.forestGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const _captureMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// 8-point compass name for an azimuth (0 = N, 90 = E, clockwise).
String _compassPoint(double deg) {
  const points = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
  return points[((deg % 360) / 45).round() % 8];
}

/// "Sep 28, 2026" (no intl dependency, matching format_utils.dart).
String _formatDate(DateTime t) => '${_captureMonths[t.month - 1]} ${t.day}, ${t.year}';

/// "3:05 PM" in the device's local time.
String _formatTime(DateTime t) {
  final l = t.toLocal();
  final h = l.hour % 12 == 0 ? 12 : l.hour % 12;
  final m = l.minute.toString().padLeft(2, '0');
  return '$h:$m ${l.hour < 12 ? 'AM' : 'PM'}';
}
