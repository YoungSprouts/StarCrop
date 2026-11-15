import 'package:starcrop/engine/ar_capability_checker.dart';
import 'package:test/test.dart';

void main() {
  group('ArCapabilityChecker.isArCapable', () {
    test('true when both streams produced varied, real-looking samples', () {
      expect(
        ArCapabilityChecker.isArCapable(
          headingSamples: [10.0, 12.5, 11.0, 13.2, 12.8, 11.9],
          pitchSamples: [2.0, 2.3, 1.9, 2.1, 2.4, 2.0],
        ),
        isTrue,
      );
    });

    test('false when too few heading samples arrived (compass missing)', () {
      expect(
        ArCapabilityChecker.isArCapable(
          headingSamples: [10.0, 11.0],
          pitchSamples: [2.0, 2.3, 1.9, 2.1, 2.4, 2.0],
        ),
        isFalse,
      );
    });

    test('false when too few pitch samples arrived (accelerometer missing)', () {
      expect(
        ArCapabilityChecker.isArCapable(
          headingSamples: [10.0, 12.5, 11.0, 13.2, 12.8, 11.9],
          pitchSamples: [2.0],
        ),
        isFalse,
      );
    });

    test('false when heading samples are a flat stub value', () {
      expect(
        ArCapabilityChecker.isArCapable(
          headingSamples: List.filled(10, 0.0),
          pitchSamples: [2.0, 2.3, 1.9, 2.1, 2.4, 2.0],
        ),
        isFalse,
      );
    });

    test('false when pitch samples are a flat stub value', () {
      expect(
        ArCapabilityChecker.isArCapable(
          headingSamples: [10.0, 12.5, 11.0, 13.2, 12.8, 11.9],
          pitchSamples: List.filled(10, 0.0),
        ),
        isFalse,
      );
    });

    test('false on NaN or infinite samples in either stream', () {
      expect(
        ArCapabilityChecker.isArCapable(
          headingSamples: [10.0, double.nan, 11.0, 13.2, 12.8, 11.9],
          pitchSamples: [2.0, 2.3, 1.9, 2.1, 2.4, 2.0],
        ),
        isFalse,
      );
      expect(
        ArCapabilityChecker.isArCapable(
          headingSamples: [10.0, 12.5, 11.0, 13.2, 12.8, 11.9],
          pitchSamples: [2.0, double.infinity, 1.9, 2.1, 2.4, 2.0],
        ),
        isFalse,
      );
    });

    test('exactly minSamples readings is enough (boundary)', () {
      expect(
        ArCapabilityChecker.isArCapable(
          headingSamples: [10.0, 12.5, 11.0, 13.2, 12.8],
          pitchSamples: [2.0, 2.3, 1.9, 2.1, 2.4],
        ),
        isTrue,
      );
    });
  });
}
