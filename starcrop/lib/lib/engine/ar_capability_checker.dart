import 'dart:async';
/// Pure judgment logic for the one-time "can this device do a live AR
/// constellation overlay" probe (see ArCapabilityRepository for the
/// sensor-listening side). Takes whatever raw samples were collected during
/// a short probe window and decides pass/fail — no Flutter or plugin
/// imports here, so this stays testable with plain `dart test`, the same
/// way astro_engine.dart and rule_engine.dart are.
class ArCapabilityChecker {
  ArCapabilityChecker._();

  /// Minimum readings needed from each sensor within the probe window
  /// before that stream is trusted at all. A handful of samples over a
  /// ~1.5s window is enough to prove the sensor exists and the platform is
  /// actually delivering events — some emulators and a few stripped-down
  /// devices never fire a magnetometer callback at all, so an empty/short
  /// stream is a real "not supported" signal, not bad luck on timing.
  static const minSamples = 5;

  /// Decides whether the collected samples indicate a usable compass +
  /// accelerometer pair for live AR overlay. Both streams must clear
  /// [minSamples] and show real variation — a flat, repeating value (often
  /// a stubbed 0.0) is the common signature of a platform channel that
  /// answers but isn't backed by real hardware.
  static bool isArCapable({
    required List<double> headingSamples, // degrees, 0-360, from compass
    required List<double> pitchSamples, // degrees, accelerometer-derived tilt
  }) {
    if (headingSamples.length < minSamples) return false;
    if (pitchSamples.length < minSamples) return false;

    if (headingSamples.any((v) => v.isNaN || v.isInfinite)) return false;
    if (pitchSamples.any((v) => v.isNaN || v.isInfinite)) return false;

    if (_isDegenerate(headingSamples)) return false;
    if (_isDegenerate(pitchSamples)) return false;

    return true;
  }

  static bool _isDegenerate(List<double> samples) {
    final first = samples.first;
    return samples.every((v) => (v - first).abs() < 0.001);
  }
}
