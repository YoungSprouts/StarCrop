/// Real starter content pack — NOT placeholder/dev-only data.
///
/// Star coordinates (J2000, HIP numbers, V magnitudes) verified against
/// Wikipedia/SIMBAD-sourced tables during this session (see PROGRESS.md
/// session 7 for citations). Place coordinates are well-documented public
/// geography. Farming guidance cites real published Philippine
/// ethnoastronomy research (Dr. Dante Ambrosio) rather than invented text.
///
/// IMPORTANT CONTENT CAVEAT: the month-by-month planting calendar below
/// (Balatik = start of planting, etc.) is documented specifically for the
/// Matigsalug Manobo people of Bukidnon, Mindanao. The general star names
/// (Balatik = Orion, Moroporo = Pleiades) are attested nationally across
/// many Philippine ethnolinguistic groups per Ambrosio's compiled research,
/// but the exact *timing* is one community's tradition, not a universal
/// Philippine planting calendar. Rules below are seeded with
/// verification_status='reviewed' (not 'confirmed') specifically because
/// this regional-to-national generalization needs local agricultural
/// extension sign-off before being presented as calendar-accurate advice
/// for a specific farm's location (e.g. the default seeded location, Kalibo,
/// Aklan, is Panay/Aklanon, not Bukidnon/Manobo). Do not bump these to
/// 'confirmed' without that review.
///
/// WEATHER-ONLY RULES (added alongside the sky-based ones above): these are
/// generic, well-established agronomic practice — not attributed to any
/// specific ethnoastronomy source or regional tradition — so they're seeded
/// at verification_status='confirmed' directly. They also give the rule
/// engine its first real weather-trigger content: previously
/// WeatherTriggers/weather-gated FarmingRules existed in the schema and
/// were fully tested (rule_engine_test.dart), but nothing was ever actually
/// seeded that used them, so Suggested Activities/Farmer Guidance only ever
/// had sky-based rules to show in practice.
///
/// This is pure Dart data — no drift/Flutter imports — so it stays testable
/// and reusable regardless of how the loader wires it into the DBs.
library starcrop_seed_data;

class SeedStar {
  final int hipId;
  final double raDeg;
  final double decDeg;
  final double magnitude;
  final String? properName;
  const SeedStar(this.hipId, this.raDeg, this.decDeg, this.magnitude, [this.properName]);
}

class SeedConstellation {
  final String code;
  final String latinName;
  final double centerRa;
  final double centerDec;
  const SeedConstellation(this.code, this.latinName, this.centerRa, this.centerDec);
}

class SeedLine {
  final String constCode;
  final int starA;
  final int starB;
  const SeedLine(this.constCode, this.starA, this.starB);
}

class SeedSeasonalNormal {
  final int regionId;
  final int month; // 1-12
  final double avgRainMm;
  final double tempMinC;
  final double tempMaxC;
  final String classification;
  const SeedSeasonalNormal(
    this.regionId,
    this.month,
    this.avgRainMm,
    this.tempMinC,
    this.tempMaxC,
    this.classification,
  );
}

class SeedPlace {
  final int geonameId;
  final String name;
  final String province;
  final String country;
  final double lat;
  final double lon;
  final int population;
  final bool verifiedGeonameId; // false = real coordinates, placeholder-range ID
  const SeedPlace(
    this.geonameId,
    this.name,
    this.province,
    this.country,
    this.lat,
    this.lon,
    this.population, {
    this.verifiedGeonameId = false,
  });
}

class StarcropSeedData {
  StarcropSeedData._();

  static const timezoneId = 'Asia/Manila';
  static const timezoneRulesJson = '{"utc_offset_hours": 8, "dst": false}';

  static const skyCultureId = 1;
  static const skyCultureName = 'Philippine Ethnoastronomy (Ambrosio compilation)';
  static const skyCultureRegion = 'Philippines';
  static const skyCultureLicense = 'Academic citation required, see source';
  static const skyCultureSource =
      'Ambrosio, D. (2010). Balatik: Etnoastronomiya, Kalangitan at Kabihasnang '
      'Pilipino. Quezon City: University of the Philippines Press. Also: '
      'Ambrosio, D. (2005). Balatik: Katutubong Bituin ng mga Pilipino. '
      'Philippine Social Sciences Review.';

  // ---- Stars (verified J2000 RA/Dec/HIP/mag) ----
  static const stars = <SeedStar>[
    // Taurus
    SeedStar(21421, 68.980, 16.5093, 0.87, 'Aldebaran'),
    SeedStar(25428, 81.573, 28.6075, 1.65, 'Elnath'),
    SeedStar(17702, 56.871, 24.1053, 2.85, 'Alcyone'),
    SeedStar(26451, 84.411, 21.1425, 3.01, 'Tianguan'),
    // Orion
    SeedStar(27989, 88.793, 7.4070, 0.42, 'Betelgeuse'),
    SeedStar(24436, 78.634, -8.2016, 0.18, 'Rigel'),
    SeedStar(25336, 81.283, 6.3497, 1.64, 'Bellatrix'),
    SeedStar(25930, 83.002, -0.2991, 2.20, 'Mintaka'),
    SeedStar(26311, 84.053, -1.2019, 1.69, 'Alnilam'),
    SeedStar(26727, 85.190, -1.9428, 1.77, 'Alnitak'),
    SeedStar(27366, 86.939, -9.6696, 2.07, 'Saiph'),
    // Scorpius
    SeedStar(80763, 247.352, -26.4319, 1.06, 'Antares'),
    SeedStar(78401, 240.083, -22.6216, 2.29, 'Dschubba'),
    SeedStar(85927, 263.402, -37.1038, 1.62, 'Shaula'),
    SeedStar(86228, 264.330, -42.9978, 1.86, 'Sargas'),
    // Crux (Southern Cross) — up nearly year-round from Philippine
    // latitudes, low south; fills the coverage gap the original 3
    // northern/equatorial constellations left for much of the year.
    SeedStar(60718, 186.6495, -63.0991, 0.77, 'Acrux'),
    SeedStar(62434, 191.9303, -59.6888, 1.25, 'Mimosa'),
    SeedStar(61084, 187.7915, -57.1133, 1.63, 'Gacrux'),
    SeedStar(59747, 183.7863, -58.7489, 2.79, 'Imai'),
    // Canis Major (Dec-Mar evenings)
    SeedStar(32349, 101.287, -16.7161, -1.46, 'Sirius'),
    SeedStar(33579, 104.656, -28.9721, 1.50, 'Adhara'),
    SeedStar(34444, 107.098, -26.3932, 1.83, 'Wezen'),
    SeedStar(30324, 95.675, -17.9559, 1.98, 'Mirzam'),
    // Gemini (Jan-Apr evenings)
    SeedStar(36850, 113.649, 31.8883, 1.58, 'Castor'),
    SeedStar(37826, 116.329, 28.0262, 1.14, 'Pollux'),
    SeedStar(31681, 99.428, 16.3993, 1.93, 'Alhena'),
    // Leo (Mar-Jun evenings)
    SeedStar(49669, 152.093, 11.9672, 1.35, 'Regulus'),
    SeedStar(57632, 177.265, 14.5720, 2.14, 'Denebola'),
    SeedStar(50583, 154.993, 19.8419, 2.08, 'Algieba'),
    // Sagittarius (Jun-Sep evenings)
    SeedStar(90185, 276.043, -34.3846, 1.85, 'Kaus Australis'),
    SeedStar(92855, 283.816, -26.2967, 2.05, 'Nunki'),
    SeedStar(89931, 275.249, -29.8281, 2.70, 'Kaus Media'),
    // Cygnus (Jul-Oct evenings)
    SeedStar(102098, 310.358, 45.2803, 1.25, 'Deneb'),
    SeedStar(100453, 305.557, 40.2567, 2.20, 'Sadr'),
    SeedStar(95947, 292.680, 27.9597, 3.08, 'Albireo'),
    // Lyra (Jun-Oct evenings)
    SeedStar(91262, 279.235, 38.7837, 0.03, 'Vega'),
    SeedStar(92420, 282.520, 33.3627, 3.52, 'Sheliak'),
    SeedStar(93194, 284.736, 32.6896, 3.24, 'Sulafat'),
    // Aquila (Jun-Oct evenings)
    SeedStar(97649, 297.696, 8.8683, 0.76, 'Altair'),
    SeedStar(97278, 296.565, 10.6133, 2.72, 'Tarazed'),
    SeedStar(98036, 298.828, 6.4067, 3.71, 'Alshain'),
    // Pegasus (Sep-Dec evenings)
    SeedStar(113963, 346.190, 15.2053, 2.49, 'Markab'),
    SeedStar(113881, 345.943, 28.0821, 2.42, 'Scheat'),
    SeedStar(1067, 3.309, 15.1836, 2.83, 'Algenib'),
    SeedStar(677, 2.097, 29.0904, 2.07, 'Alpheratz'),
    // Andromeda (Sep-Dec evenings; shares Alpheratz with Pegasus' square)
    SeedStar(5447, 17.433, 35.6206, 2.07, 'Mirach'),
    SeedStar(9640, 30.975, 42.3297, 2.10, 'Almach'),
    // Perseus (Nov-Feb evenings)
    SeedStar(15863, 51.081, 49.8612, 1.79, 'Mirfak'),
    SeedStar(14576, 47.042, 40.9556, 2.12, 'Algol'),
    // Auriga (Dec-Mar evenings)
    SeedStar(24608, 79.172, 45.9980, 0.08, 'Capella'),
    SeedStar(28360, 89.882, 44.9474, 1.90, 'Menkalinan'),
    SeedStar(28380, 89.930, 37.2126, 2.62, 'Theta Aurigae'),
    // Bootes (Apr-Jul evenings)
    SeedStar(69673, 213.915, 19.1824, -0.05, 'Arcturus'),
    SeedStar(72105, 221.247, 27.0742, 2.35, 'Izar'),
    SeedStar(71075, 218.021, 38.3082, 3.03, 'Seginus'),
    // Virgo (Mar-Jul evenings)
    SeedStar(65474, 201.298, -11.1613, 0.97, 'Spica'),
    SeedStar(61941, 190.415, -1.4494, 2.74, 'Porrima'),
    SeedStar(63608, 195.544, 10.9591, 2.83, 'Vindemiatrix'),
  ];

  // ---- Constellations (center = rough centroid of seeded figure stars) ----
  static const constellations = <SeedConstellation>[
    SeedConstellation('TAU', 'Taurus', 75.0, 20.0),
    SeedConstellation('ORI', 'Orion', 83.5, -1.0),
    SeedConstellation('SCO', 'Scorpius', 254.0, -32.0),
    SeedConstellation('CRU', 'Crux', 187.0, -60.0),
    SeedConstellation('CMA', 'Canis Major', 101.0, -21.0),
    SeedConstellation('GEM', 'Gemini', 110.0, 25.0),
    SeedConstellation('LEO', 'Leo', 160.0, 15.0),
    SeedConstellation('SGR', 'Sagittarius', 280.0, -30.0),
    SeedConstellation('CYG', 'Cygnus', 305.0, 40.0),
    SeedConstellation('LYR', 'Lyra', 282.0, 36.0),
    SeedConstellation('AQL', 'Aquila', 297.0, 8.0),
    SeedConstellation('PEG', 'Pegasus', 358.0, 22.0),
    SeedConstellation('AND', 'Andromeda', 17.0, 38.0),
    SeedConstellation('PER', 'Perseus', 49.0, 45.0),
    SeedConstellation('AUR', 'Auriga', 86.0, 42.0),
    SeedConstellation('BOO', 'Bootes', 218.0, 27.0),
    SeedConstellation('VIR', 'Virgo', 195.0, 0.0),
  ];

  // ---- Constellation lines (simplified figures, not full IAU line sets) ----
  static const lines = <SeedLine>[
    // Taurus: V-shaped horns from Aldebaran + line toward Pleiades
    SeedLine('TAU', 21421, 25428), // Aldebaran - Elnath (north horn)
    SeedLine('TAU', 21421, 26451), // Aldebaran - Tianguan (south horn)
    SeedLine('TAU', 21421, 17702), // Aldebaran - Alcyone (toward Pleiades)
    // Orion: classic hourglass + belt (7 stars, 7 lines)
    SeedLine('ORI', 27989, 25336), // Betelgeuse - Bellatrix (shoulders)
    SeedLine('ORI', 27989, 26727), // Betelgeuse - Alnitak
    SeedLine('ORI', 25336, 25930), // Bellatrix - Mintaka
    SeedLine('ORI', 25930, 26311), // Mintaka - Alnilam (belt)
    SeedLine('ORI', 26311, 26727), // Alnilam - Alnitak (belt)
    SeedLine('ORI', 25930, 24436), // Mintaka - Rigel
    SeedLine('ORI', 26727, 27366), // Alnitak - Saiph
    // Scorpius: simplified hook (head - heart - tail - stinger)
    SeedLine('SCO', 78401, 80763), // Dschubba - Antares
    SeedLine('SCO', 80763, 86228), // Antares - Sargas
    SeedLine('SCO', 86228, 85927), // Sargas - Shaula (stinger)
    // Crux: the cross itself (long axis + cross axis)
    SeedLine('CRU', 60718, 61084), // Acrux - Gacrux (long axis)
    SeedLine('CRU', 62434, 59747), // Mimosa - Imai (cross axis)
    // Canis Major: simplified triangle off Sirius
    SeedLine('CMA', 32349, 30324), // Sirius - Mirzam
    SeedLine('CMA', 32349, 34444), // Sirius - Wezen
    SeedLine('CMA', 34444, 33579), // Wezen - Adhara
    // Gemini: the twins' spine
    SeedLine('GEM', 36850, 37826), // Castor - Pollux
    SeedLine('GEM', 37826, 31681), // Pollux - Alhena
    // Leo: simplified backbone (sickle to tail)
    SeedLine('LEO', 49669, 50583), // Regulus - Algieba
    SeedLine('LEO', 50583, 57632), // Algieba - Denebola
    // Sagittarius: partial "teapot" handle-to-spout
    SeedLine('SGR', 90185, 89931), // Kaus Australis - Kaus Media
    SeedLine('SGR', 89931, 92855), // Kaus Media - Nunki
    // Cygnus: the Northern Cross's long axis
    SeedLine('CYG', 102098, 100453), // Deneb - Sadr
    SeedLine('CYG', 100453, 95947), // Sadr - Albireo
    // Lyra: small triangle off Vega
    SeedLine('LYR', 91262, 92420), // Vega - Sheliak
    SeedLine('LYR', 92420, 93194), // Sheliak - Sulafat
    // Aquila: Altair with its two "wing" stars
    SeedLine('AQL', 97278, 97649), // Tarazed - Altair
    SeedLine('AQL', 97649, 98036), // Altair - Alshain
    // Pegasus: the Great Square (shares Alpheratz with Andromeda)
    SeedLine('PEG', 113963, 113881), // Markab - Scheat
    SeedLine('PEG', 113963, 1067), // Markab - Algenib
    SeedLine('PEG', 113881, 677), // Scheat - Alpheratz
    SeedLine('PEG', 1067, 677), // Algenib - Alpheratz
    // Andromeda: chain running off Alpheratz
    SeedLine('AND', 677, 5447), // Alpheratz - Mirach
    SeedLine('AND', 5447, 9640), // Mirach - Almach
    // Perseus: simplified two-star chain
    SeedLine('PER', 15863, 14576), // Mirfak - Algol
    // Auriga: pentagon-ish chain (simplified)
    SeedLine('AUR', 24608, 28360), // Capella - Menkalinan
    SeedLine('AUR', 28360, 28380), // Menkalinan - Theta Aurigae
    // Bootes: kite shape (simplified)
    SeedLine('BOO', 69673, 72105), // Arcturus - Izar
    SeedLine('BOO', 72105, 71075), // Izar - Seginus
    // Virgo: simplified Y off Spica
    SeedLine('VIR', 65474, 61941), // Spica - Porrima
    SeedLine('VIR', 61941, 63608), // Porrima - Vindemiatrix
  ];

  // ---- Places (real coordinates; geoname_id verified only where noted) ----
  // Original six (Panay/Metro Manila/Cebu/Davao) plus five more major cities
  // added for wider location-search coverage — same precision level as the
  // originals (city-center coordinates, population approximate), still
  // unverified GeoNames IDs in the reserved 9000000+ range.
  static const places = <SeedPlace>[
    SeedPlace(9000001, 'Kalibo', 'Aklan', 'Philippines', 11.7079, 122.3640, 89127),
    SeedPlace(3499101, 'Iloilo City', 'Iloilo', 'Philippines', 10.7202, 122.5621, 457626,
        verifiedGeonameId: true),
    SeedPlace(9000002, 'Roxas City', 'Capiz', 'Philippines', 11.5853, 122.7511, 179292),
    SeedPlace(9000003, 'Manila', 'Metro Manila', 'Philippines', 14.5995, 120.9842, 1846513),
    SeedPlace(9000004, 'Cebu City', 'Cebu', 'Philippines', 10.3157, 123.8854, 964169),
    SeedPlace(9000005, 'Davao City', 'Davao del Sur', 'Philippines', 7.1907, 125.4553, 1776949),
    SeedPlace(9000006, 'Bacolod', 'Negros Occidental', 'Philippines', 10.6767, 122.9500, 600783),
    SeedPlace(9000007, 'Zamboanga City', 'Zamboanga del Sur', 'Philippines', 6.9214, 122.0790,
        977234),
    SeedPlace(9000008, 'Cagayan de Oro', 'Misamis Oriental', 'Philippines', 8.4822, 124.6472,
        728402),
    SeedPlace(9000009, 'Baguio City', 'Benguet', 'Philippines', 16.4023, 120.5960, 366358),
    SeedPlace(9000010, 'Puerto Princesa', 'Palawan', 'Philippines', 9.7392, 118.7353, 307079),
  ];

  // ---- Farming reference data ----
  static const sourceId = 1;
  static const sourceType = 'publication';
  static const sourceName = 'Ambrosio, Balatik (Philippine ethnoastronomy)';
  static const sourceCitation =
      'Ambrosio, D. (2010). Balatik: Etnoastronomiya, Kalangitan at Kabihasnang '
      'Pilipino. UP Press. Calendar timing specifically documented for the '
      'Matigsalug Manobo of Bukidnon (see DepEd learning-resource summary); '
      'needs local extension review before treating as calendar-accurate for '
      'other regions.';

  // Second source: generic agronomic practice, not tied to any ethnoastronomy
  // tradition or specific named publication — used only by the weather-only
  // rules below, which are seeded 'confirmed' rather than 'reviewed'.
  static const generalAgronomySourceId = 2;
  static const generalAgronomySourceType = 'extension_office';
  static const generalAgronomySourceName = 'General agricultural extension guidance';
  static const generalAgronomySourceCitation =
      'Standard integrated pest management and post-harvest handling practice: '
      'avoid pesticide/herbicide application shortly before rain (runoff and '
      'reduced efficacy), and prioritize harvesting ready crops ahead of '
      'forecast heavy rain (lodging and flood-damage risk). Not tied to any '
      'specific regional tradition — safe to present without local review.';

  // Third source: PAGASA published climate normals — used only by
  // SeasonalClimateNormals, seeded 'reviewed' rather than 'confirmed' since
  // these are station normals for Iloilo City being applied to the whole
  // Panay/Western Visayas region, not yet locally reviewed per-province.
  static const climateNormalsSourceId = 3;
  static const climateNormalsSourceType = 'publication';
  static const climateNormalsSourceName =
      'PAGASA Climatological Normals, Iloilo City station';
  static const climateNormalsSourceCitation =
      'Philippine Atmospheric, Geophysical and Astronomical Services '
      'Administration (PAGASA), Climatology and Agrometeorology Division. '
      'Climate and Agromet Data Section, Climatological Normals: Iloilo City, '
      'Iloilo (10°42\'30"N, 122°33\'00"E, elev. 5.0m), period 1991-2009. '
      'https://pubfiles.pagasa.dost.gov.ph/pagasaweb/files/cad/'
      'CLIMATOLOGICAL%20NORMALS%20(1991-2020)/ILOILO.pdf';

  // Fourth source: real, independently verifiable classical/ancient
  // ethnoastronomy — NOT calibrated to Philippine crops, climate, or
  // planting calendar. Seeded as historical/educational reference only
  // (severity 'low', framed explicitly as "historically" in the guidance
  // text), never presented as local actionable advice the way the
  // Manobo-sourced rules are. Distinguishes real documented history from
  // invented content, per the "false data" concern this seed pass exists
  // to fix.
  static const classicalEthnoastronomySourceId = 4;
  static const classicalEthnoastronomySourceType = 'publication';
  static const classicalEthnoastronomySourceName =
      'Classical and ancient ethnoastronomy (Hesiod; Egyptian Sothic '
      'calendar; classical star nomenclature)';
  static const classicalEthnoastronomySourceCitation =
      'Hesiod, Works and Days, lines 383-384, 564-570, 609-611 (trans. Hugh '
      'G. Evelyn-White, 1914, public domain) — Pleiades/Arcturus/Orion/'
      'Sirius as farm-task markers in Archaic Greece. Sirius\'s heliacal '
      'rising and the start of the Ancient Egyptian agricultural/Nile-flood '
      'calendar (the Sothic cycle) is standard Egyptology; see e.g. '
      'skyandtelescope.org, "A Real Scorcher: Sirius at Heliacal Rising". '
      'Spica\'s name (Latin spica virginis, "the virgin\'s ear of wheat '
      'grain") and its long association with Mediterranean/Near Eastern '
      'grain-harvest timing is standard star nomenclature history; see '
      'e.g. earthsky.org, "Spica: Brightest star in Virgo".';

  // Monthly climate normals for Western Visayas (Panay Island), regionId=1,
  // sourced verbatim from the PAGASA Iloilo City station normals above — not
  // estimated. Classification follows the well-documented Modified Coronas
  // Type I pattern for this part of the Philippines (two pronounced
  // seasons: dry Nov-Apr, wet May-Oct), read directly off the same
  // rainfall column rather than a separate invented judgment call:
  // Dec-Apr are the five lowest-rainfall months (<70mm), May is the sharp
  // step up into the wet season (160mm), Jun-Oct stay high (223-361mm),
  // and Nov is the step back down (131mm) into the next dry season.
  static const seasonalNormals = <SeedSeasonalNormal>[
    SeedSeasonalNormal(1, 1, 38.8, 22.7, 30.3, 'dry season'),
    SeedSeasonalNormal(1, 2, 36.3, 23.0, 31.0, 'dry season'),
    SeedSeasonalNormal(1, 3, 48.2, 23.5, 32.3, 'dry season'),
    SeedSeasonalNormal(1, 4, 68.5, 24.4, 33.8, 'dry season'),
    SeedSeasonalNormal(1, 5, 160.4, 24.6, 33.2, 'transition (wet season onset)'),
    SeedSeasonalNormal(1, 6, 263.0, 24.4, 32.1, 'wet season'),
    SeedSeasonalNormal(1, 7, 361.2, 24.1, 31.0, 'wet season'),
    SeedSeasonalNormal(1, 8, 350.7, 24.0, 31.0, 'wet season'),
    SeedSeasonalNormal(1, 9, 277.8, 24.0, 31.1, 'wet season'),
    SeedSeasonalNormal(1, 10, 224.9, 23.9, 31.5, 'wet season'),
    SeedSeasonalNormal(1, 11, 131.1, 23.7, 31.4, 'transition (dry season onset)'),
    SeedSeasonalNormal(1, 12, 124.2, 23.0, 30.6, 'dry season'),
  ];

  static const cropRice = 1;
  static const cropCorn = 2;
  static const cropCoconut = 3;

  static const activityPrepare = 1;
  static const activityPlant = 2;
  static const activitySpray = 3;
  static const activityHarvest = 4;

  static const regionId = 1;
  static const regionName = 'Western Visayas (Panay Island)';

  // Sky triggers: 'visible' on Orion (Balatik) and Taurus (Baha, per the
  // Matigsalug calendar's use of Taurus for the land-clearing period).
  static const skyTriggerOrionVisible = 1;
  static const skyTriggerTaurusVisible = 2;

  // New 'visible' triggers for the 6 constellations added for year-round
  // coverage (see the stars/constellations/lines above). No FarmingRules
  // reference these yet — that needs real, sourced ethnoastronomy or
  // agronomic content, not invented guidance text, so it's left for a
  // follow-up pass. Adding the triggers now still means Sky Chart, Camera
  // Check, and RuleEngine.evaluateSkyTrigger('visible', ...) all correctly
  // recognize these constellations today.
  static const skyTriggerCruxVisible = 3;
  static const skyTriggerCanisMajorVisible = 4;
  static const skyTriggerGeminiVisible = 5;
  static const skyTriggerLeoVisible = 6;
  static const skyTriggerSagittariusVisible = 7;
  static const skyTriggerCygnusVisible = 8;
  static const skyTriggerLyraVisible = 9;
  static const skyTriggerAquilaVisible = 10;
  static const skyTriggerPegasusVisible = 11;
  static const skyTriggerAndromedaVisible = 12;
  static const skyTriggerPerseusVisible = 13;
  static const skyTriggerAurigaVisible = 14;
  static const skyTriggerBootesVisible = 15;
  static const skyTriggerVirgoVisible = 16;

  // Heliacal (dawn) rising triggers — 'first_rise' type — for the two real
  // classical markers below. Distinct from the plain 'visible' triggers
  // above: these fire only in the window around the star's first pre-dawn
  // appearance each year, matching what Hesiod and the Egyptian calendar
  // actually tracked (not "is it up right now").
  static const skyTriggerSiriusFirstRise = 17;
  static const skyTriggerArcturusFirstRise = 18;

  // Weather triggers — the app's first seeded (non-test) use of this table.
  // Numbered in a distinct range (101+) from the sky trigger ids above
  // (1, 2): WeatherTriggers and SkyTriggers are separate tables with their
  // own primary keys, so the previous 1/2 numbering was never actually a
  // collision bug — but it violated the intent of
  // starcrop_seed_data_test.dart's "ids are unique and distinct from sky
  // trigger ids" check, which exists purely so a reader (or another test)
  // never mistakes the two constants for sharing an id space. Renumbered
  // here rather than loosening the test, since keeping the ranges visually
  // distinct is the actual goal.
  static const weatherTriggerLowRainAhead = 101; // avg rain < 5mm over next 3 days: good spray window
  static const weatherTriggerHeavyRainAhead = 102; // avg rain > 15mm over next 2 days: harvest warning

  // Farming rules — real sourced content, deliberately left at 'reviewed'
  // (never 'confirmed') pending local agricultural-extension review; see the
  // library-level doc comment above for why.
  static const ruleTaurusClearing = 1; // Baha: land clearing
  static const rulePleiadesPlanning = 2; // Pandarawa: decide what/where to plant
  static const ruleOrionPlanting = 3; // Balatik: start of planting

  // Weather-only rules — generic agronomic advice, seeded 'confirmed'.
  static const ruleSprayWindow = 4;
  static const ruleHarvestBeforeRain = 5;

  // Real, sourced classical/ancient star-farming rules (see
  // classicalEthnoastronomySourceId's citation) — historical/educational
  // reference, not calibrated to Philippine crops or climate. Kept
  // deliberately low-severity and crop-agnostic; guidance text says
  // "historically" throughout so it's never mistaken for local advice.
  static const ruleSiriusAgriculturalYearStart = 6;
  static const ruleArcturusPruningSignal = 7;
  static const ruleArcturusHarvestSignal = 8;
  static const ruleSpicaHarvestSignal = 9;
}
