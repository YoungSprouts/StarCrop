import 'dart:math' as math;

/// Derives "where is the phone's rear camera pointing" — azimuth + altitude,
/// same convention as AstroEngine (azimuth 0=N clockwise, altitude
/// 0=horizon/+90=straight up) — from raw accelerometer + magnetometer
/// vectors, both read at the same instant.
///
/// This is deliberately NOT the same computation as a flat "compass
/// heading" (which describes which way the top edge of a phone lying flat
/// on a table is pointing). This app expects the phone held up toward the
/// sky, camera facing away from the user — so what matters is the
/// direction the device's -Z axis (out the back camera) points, not its Y
/// axis. Skipping this distinction is the most common bug in "just use the
/// compass" AR-overlay attempts: the overlay works when the phone is flat
/// and drifts wildly the moment it's tilted up to actually look at the sky.
///
/// Uses the same construction as Android's SensorManager.getRotationMatrix
/// (East = magnetic x gravity, North = up x east, Up = normalized gravity),
/// then reads off where the camera's forward vector falls in that frame.
/// Pure math, no plugin/sensor imports, so this is unit-testable with
/// synthetic vectors the same way astro_engine.dart is.
class DeviceAttitude {
  DeviceAttitude._();

  /// [gravity] is the raw accelerometer reading (device frame) and
  /// [magnetic] the raw magnetometer reading (device frame), both taken at
  /// the same instant. Returns null if the vectors are degenerate — e.g.
  /// near-zero gravity, or gravity/magnetic nearly parallel (no unique
  /// "east" direction, which happens right at the magnetic poles or with a
  /// faulty magnetometer reading).
  static ({double azimuthDeg, double altitudeDeg})? cameraPointing({
    required List<double> gravity, // [ax, ay, az]
    required List<double> magnetic, // [mx, my, mz]
  }) {
    if (gravity.length != 3 || magnetic.length != 3) return null;

    final a = gravity;
    final m = magnetic;

    // East = magnetic x gravity (device frame), normalized.
    final hx = m[1] * a[2] - m[2] * a[1];
    final hy = m[2] * a[0] - m[0] * a[2];
    final hz = m[0] * a[1] - m[1] * a[0];
    final hNorm = math.sqrt(hx * hx + hy * hy + hz * hz);
    if (hNorm < 0.1) return null; // gravity/magnetic nearly parallel

    final ex = hx / hNorm, ey = hy / hNorm, ez = hz / hNorm;

    // Up = normalized gravity.
    final aNorm = math.sqrt(a[0] * a[0] + a[1] * a[1] + a[2] * a[2]);
    if (aNorm < 0.1) return null; // no usable gravity reading
    final ux = a[0] / aNorm, uy = a[1] / aNorm, uz = a[2] / aNorm;

    // North = up x east. Only the Up-component (z) of North is needed
    // below (to read off the camera forward vector's North component), so
    // only that one term of the cross product is computed.
    final nz = ux * ey - uy * ex;

    // Camera forward = device's local -Z axis. Its (East, North, Up)
    // components are the dot products of (0,0,-1) with each basis vector,
    // i.e. simply the negated Z-components of E, N, U.
    final forwardEast = -ez;
    final forwardNorth = -nz;
    final forwardUp = -uz;

    final azimuthDeg =
        (math.atan2(forwardEast, forwardNorth) * 180 / math.pi + 360) % 360;
    final altitudeDeg = math.asin(forwardUp.clamp(-1.0, 1.0)) * 180 / math.pi;

    return (azimuthDeg: azimuthDeg, altitudeDeg: altitudeDeg);
  }
}
