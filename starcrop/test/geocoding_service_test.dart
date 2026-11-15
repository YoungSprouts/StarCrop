import 'package:starcrop/engine/geocoding_service.dart';
import 'package:test/test.dart';

void main() {
  group('parseReverseGeocodeLabel', () {
    test('prefers town + state over other address fields', () {
      final json = {
        'display_name': 'Kalibo, Aklan, Western Visayas, Philippines',
        'address': {
          'town': 'Kalibo',
          'state': 'Aklan',
          'country': 'Philippines',
        },
      };
      expect(parseReverseGeocodeLabel(json), 'Kalibo, Aklan');
    });

    test('falls back through locality keys in priority order', () {
      final json = {
        'address': {
          'suburb': 'Barangay Poblacion',
          'province': 'Iloilo',
        },
      };
      expect(parseReverseGeocodeLabel(json), 'Barangay Poblacion, Iloilo');
    });

    test('uses only locality when no province-level field is present', () {
      final json = {
        'address': {'city': 'Roxas City'},
      };
      expect(parseReverseGeocodeLabel(json), 'Roxas City');
    });

    test('falls back to display_name when address has no locality-shaped field', () {
      final json = {
        'display_name': 'Somewhere, Unknown Region',
        'address': {'country': 'Philippines'},
      };
      expect(parseReverseGeocodeLabel(json), 'Somewhere, Unknown Region');
    });

    test('returns null when there is no usable address at all', () {
      final json = <String, dynamic>{};
      expect(parseReverseGeocodeLabel(json), isNull);
    });

    test('ignores blank string fields rather than treating them as present', () {
      final json = {
        'display_name': 'Fallback Name',
        'address': {'town': '  ', 'state': ''},
      };
      expect(parseReverseGeocodeLabel(json), 'Fallback Name');
    });
  });
}
