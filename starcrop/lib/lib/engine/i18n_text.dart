import 'dart:convert';

/// `guidance_i18n` / `description_i18n` are described as "text per language".
/// The exact storage format isn't fixed yet, so this accepts both:
///   * a JSON object  {"en": "...", "fil": "..."}  -> picks [lang], then 'en',
///     then the first value;
///   * plain text -> returned unchanged.
/// If the seeding pass settles on a different format, change it here only.
String localizedText(String? raw, {String lang = 'en'}) {
  if (raw == null) return '';
  final s = raw.trim();
  if (s.startsWith('{')) {
    try {
      final decoded = jsonDecode(s);
      if (decoded is Map) {
        final v = decoded[lang] ??
            decoded['en'] ??
            (decoded.values.isEmpty ? null : decoded.values.first);
        if (v is String) return v;
      }
    } catch (_) {
      // fall through to raw text
    }
  }
  return raw;
}
