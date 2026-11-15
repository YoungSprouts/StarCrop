import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import '../reference/reference_db.dart';
import '../farming/farming_db.dart';
import 'starcrop_seed_data.dart';

/// Loads the real starter content pack (StarcropSeedData) into both DBs,
/// but only if they're empty — never overwrites a real shipped asset or a
/// content pack the user has already loaded. Unlike a "dev seed", this is
/// meant to ship as the app's actual initial content, not scaffolding to
/// delete later — see StarcropSeedData's doc comment for the content
/// caveats (verification_status is deliberately 'reviewed', never
/// 'confirmed', pending agricultural-extension review, EXCEPT the
/// weather-only rules, which are generic agronomic practice and are
/// seeded 'confirmed' directly).
///
/// guidanceI18n / descriptionI18n are now seeded as real
/// {"en": "...", "fil": "...", "akl": "..."} JSON (via [_i18n] below)
/// rather than plain English strings — i18n_text.dart's localizedText()
/// only picks a language out of that JSON shape, so plain strings meant
/// the language switch in Settings had nothing to actually switch. NOTE:
/// this only affects a *fresh* seed — an install that already seeded the
/// old English-only strings won't get these updated automatically, since
/// seedIfEmpty() is a no-op once FarmingDb has any rows. Clearing the
/// app's data (or bumping schemaVersion with a migration that re-seeds)
/// is the only way to pick this up on an existing install.
///
/// CONFIDENCE CAVEAT: 'fil' (Filipino) is a well-documented national
/// language. 'akl' (Aklanon) is a low-resource regional language and these
/// translations are a best-effort draft only — matches this app's own
/// existing pattern of flagging regionally-specific content (see
/// StarcropSeedData's doc comment on the Manobo calendar) as needing local
/// review before being treated as calendar/language-accurate. Get an
/// actual Aklanon speaker to check these strings before shipping them as
/// authoritative, especially since the default seeded location (Kalibo,
/// Aklan) is exactly where a farmer would notice if they're wrong.
class StarcropSeedLoader {
  StarcropSeedLoader._();

  /// Encodes a guidance/description string as the
  /// `{"en":..., "fil":..., "akl":...}` JSON shape localizedText()
  /// understands. Built with jsonEncode rather than hand-written JSON so
  /// the literal double quotes several guidance strings already contain
  /// (e.g. `("Baha")`) get escaped correctly without relying on doing it
  /// by hand. [akl] is optional only so a string can be added for en/fil
  /// first and backfilled later; every call below currently supplies one.
  static String _i18n(String en, {String? fil, String? akl}) => jsonEncode({
        'en': en,
        if (fil != null) 'fil': fil,
        if (akl != null) 'akl': akl,
      });

  static Future<void> seedIfEmpty({
    required ReferenceDb reference,
    required FarmingDb farming,
  }) async {
    await _seedReferenceIfEmpty(reference);
    await _seedFarmingIfEmpty(farming);
  }

  static Future<void> _seedReferenceIfEmpty(ReferenceDb db) async {
    final existing = await db.select(db.stars).get();
    if (existing.isNotEmpty) return;

    await db.transaction(() async {
      await db.into(db.timezones).insert(
            TimezonesCompanion.insert(
              zoneId: StarcropSeedData.timezoneId,
              rulesJson: StarcropSeedData.timezoneRulesJson,
            ),
          );

      await db.into(db.skyCultures).insert(
            SkyCulturesCompanion.insert(
              cultureId: Value(StarcropSeedData.skyCultureId),
              name: StarcropSeedData.skyCultureName,
              region: const Value(StarcropSeedData.skyCultureRegion),
              license: const Value(StarcropSeedData.skyCultureLicense),
              source: const Value(StarcropSeedData.skyCultureSource),
            ),
          );

      for (final s in StarcropSeedData.stars) {
        await db.into(db.stars).insert(
              StarsCompanion.insert(
                hipId: Value(s.hipId),
                raDeg: s.raDeg,
                decDeg: s.decDeg,
                magnitude: s.magnitude,
                properName: Value(s.properName),
              ),
            );
      }

      for (final c in StarcropSeedData.constellations) {
        await db.into(db.constellations).insert(
              ConstellationsCompanion.insert(
                code: c.code,
                latinName: c.latinName,
                centerRa: Value(c.centerRa),
                centerDec: Value(c.centerDec),
              ),
            );
      }

      int lineId = 1;
      for (final l in StarcropSeedData.lines) {
        await db.into(db.constellationLines).insert(
              ConstellationLinesCompanion.insert(
                lineId: Value(lineId++),
                constCode: l.constCode,
                cultureId: StarcropSeedData.skyCultureId,
                starA: l.starA,
                starB: l.starB,
              ),
            );
      }

      // Loops over every place in StarcropSeedData.places — the five newly
      // added cities (Bacolod, Zamboanga City, Cagayan de Oro, Baguio City,
      // Puerto Princesa) are picked up automatically, no change needed here.
      for (final p in StarcropSeedData.places) {
        await db.into(db.places).insert(
              PlacesCompanion.insert(
                geonameId: Value(p.geonameId),
                name: p.name,
                province: Value(p.province),
                country: Value(p.country),
                lat: p.lat,
                lon: p.lon,
                timezoneId: StarcropSeedData.timezoneId,
                population: Value(p.population),
              ),
            );
      }
    });
  }

  static Future<void> _seedFarmingIfEmpty(FarmingDb db) async {
    final existing = await db.select(db.farmingRules).get();
    if (existing.isNotEmpty) return;

    await db.transaction(() async {
      await db.into(db.sources).insert(
            SourcesCompanion.insert(
              sourceId: Value(StarcropSeedData.sourceId),
              sourceType: StarcropSeedData.sourceType,
              name: StarcropSeedData.sourceName,
              citation: const Value(StarcropSeedData.sourceCitation),
            ),
          );

      await db.into(db.sources).insert(
            SourcesCompanion.insert(
              sourceId: Value(StarcropSeedData.generalAgronomySourceId),
              sourceType: StarcropSeedData.generalAgronomySourceType,
              name: StarcropSeedData.generalAgronomySourceName,
              citation: const Value(StarcropSeedData.generalAgronomySourceCitation),
            ),
          );

      // Third source: PAGASA published climate normals — backs the
      // SeasonalClimateNormals rows seeded below. Previously defined as a
      // constant (StarcropSeedData.climateNormalsSourceId) but never
      // actually inserted, so any row referencing it would have violated
      // its FK — fixed here.
      await db.into(db.sources).insert(
            SourcesCompanion.insert(
              sourceId: Value(StarcropSeedData.climateNormalsSourceId),
              sourceType: StarcropSeedData.climateNormalsSourceType,
              name: StarcropSeedData.climateNormalsSourceName,
              citation: const Value(StarcropSeedData.climateNormalsSourceCitation),
            ),
          );

      await db.into(db.sources).insert(
            SourcesCompanion.insert(
              sourceId: Value(StarcropSeedData.classicalEthnoastronomySourceId),
              sourceType: StarcropSeedData.classicalEthnoastronomySourceType,
              name: StarcropSeedData.classicalEthnoastronomySourceName,
              citation:
                  const Value(StarcropSeedData.classicalEthnoastronomySourceCitation),
            ),
          );

      await db.into(db.crops).insert(CropsCompanion.insert(
            cropId: Value(StarcropSeedData.cropRice),
            name: 'Rice',
            category: const Value('grain'),
          ));
      await db.into(db.crops).insert(CropsCompanion.insert(
            cropId: Value(StarcropSeedData.cropCorn),
            name: 'Corn',
            category: const Value('grain'),
          ));
      await db.into(db.crops).insert(CropsCompanion.insert(
            cropId: Value(StarcropSeedData.cropCoconut),
            name: 'Coconut',
            category: const Value('perennial'),
          ));

      await db.into(db.activities).insert(ActivitiesCompanion.insert(
            activityId: Value(StarcropSeedData.activityPrepare),
            activityType: 'prepare',
            descriptionI18n: _i18n(
              'Clear and prepare the field',
              fil: 'Linisin at ihanda ang bukid',
              akl: 'Linisa kag hanraa ang oma',
            ),
          ));
      await db.into(db.activities).insert(ActivitiesCompanion.insert(
            activityId: Value(StarcropSeedData.activityPlant),
            activityType: 'plant',
            descriptionI18n: _i18n(
              'Plant seeds or seedlings',
              fil: 'Magtanim ng binhi o punla',
              akl: 'Magtanom sang binhi ukon punla',
            ),
          ));
      await db.into(db.activities).insert(ActivitiesCompanion.insert(
            activityId: Value(StarcropSeedData.activitySpray),
            activityType: 'spray',
            descriptionI18n: _i18n(
              'Apply pest or weed treatment',
              fil: 'Maglagay ng gamot sa peste o damo',
              akl: 'Maglagay it bulong sa peste ukon hilamon',
            ),
          ));
      await db.into(db.activities).insert(ActivitiesCompanion.insert(
            activityId: Value(StarcropSeedData.activityHarvest),
            activityType: 'harvest',
            descriptionI18n: _i18n(
              'Harvest the crop',
              fil: 'Anihin ang tanim',
              akl: 'Anihon ang tanom',
            ),
          ));

      await db.into(db.regions).insert(RegionsCompanion.insert(
            regionId: Value(StarcropSeedData.regionId),
            name: StarcropSeedData.regionName,
            latMin: 9.5,
            latMax: 12.5,
            lonMin: 121.5,
            lonMax: 123.5,
            climateZone: const Value('tropical monsoon, Type III (Coronas)'),
          ));

      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerOrionVisible),
            triggerType: 'visible',
            constCode: const Value('ORI'),
          ));
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerTaurusVisible),
            triggerType: 'visible',
            constCode: const Value('TAU'),
          ));

      // Year-round coverage triggers (see StarcropSeedData's doc comment on
      // these ids) — no FarmingRules use them yet, but this makes them
      // available to the rule engine and lets Sky Chart / Camera Check
      // recognize these constellations as soon as the reference data loads.
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerCruxVisible),
            triggerType: 'visible',
            constCode: const Value('CRU'),
          ));
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerCanisMajorVisible),
            triggerType: 'visible',
            constCode: const Value('CMA'),
          ));
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerGeminiVisible),
            triggerType: 'visible',
            constCode: const Value('GEM'),
          ));
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerLeoVisible),
            triggerType: 'visible',
            constCode: const Value('LEO'),
          ));
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerSagittariusVisible),
            triggerType: 'visible',
            constCode: const Value('SGR'),
          ));
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerCygnusVisible),
            triggerType: 'visible',
            constCode: const Value('CYG'),
          ));
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerLyraVisible),
            triggerType: 'visible',
            constCode: const Value('LYR'),
          ));
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerAquilaVisible),
            triggerType: 'visible',
            constCode: const Value('AQL'),
          ));
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerPegasusVisible),
            triggerType: 'visible',
            constCode: const Value('PEG'),
          ));
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerAndromedaVisible),
            triggerType: 'visible',
            constCode: const Value('AND'),
          ));
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerPerseusVisible),
            triggerType: 'visible',
            constCode: const Value('PER'),
          ));
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerAurigaVisible),
            triggerType: 'visible',
            constCode: const Value('AUR'),
          ));
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerBootesVisible),
            triggerType: 'visible',
            constCode: const Value('BOO'),
          ));
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerVirgoVisible),
            triggerType: 'visible',
            constCode: const Value('VIR'),
          ));

      // Heliacal (dawn) rising triggers backing the two real historical
      // rules below.
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerSiriusFirstRise),
            triggerType: 'first_rise',
            constCode: const Value('CMA'),
          ));
      await db.into(db.skyTriggers).insert(SkyTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.skyTriggerArcturusFirstRise),
            triggerType: 'first_rise',
            constCode: const Value('BOO'),
          ));

      // Weather triggers — first production use of this table (previously
      // only exercised by rule_engine_test.dart's hand-built rows).
      await db.into(db.weatherTriggers).insert(WeatherTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.weatherTriggerLowRainAhead),
            variable: 'rain',
            operator: '<',
            threshold: 5.0,
            daysAhead: const Value(0),
            durationDays: const Value(3),
          ));
      await db.into(db.weatherTriggers).insert(WeatherTriggersCompanion.insert(
            triggerId: Value(StarcropSeedData.weatherTriggerHeavyRainAhead),
            variable: 'rain',
            operator: '>',
            threshold: 15.0,
            daysAhead: const Value(0),
            durationDays: const Value(2),
          ));

      // Baha (Taurus): traditionally the land-clearing period. Matigsalug
      // Manobo calendar; see StarcropSeedData's doc comment for the regional
      // caveat. General land prep, no specific crop.
      await db.into(db.farmingRules).insert(FarmingRulesCompanion.insert(
            ruleId: Value(StarcropSeedData.ruleTaurusClearing),
            skyTriggerId: const Value(StarcropSeedData.skyTriggerTaurusVisible),
            activityId: StarcropSeedData.activityPrepare,
            sourceId: StarcropSeedData.sourceId,
            guidanceI18n: _i18n(
              'In the Matigsalug Manobo tradition (Bukidnon), the appearance '
              'of this star group ("Baha") traditionally marks the start of '
              'clearing land for the new planting season. Verify against '
              'your local planting calendar before acting.',
              fil: 'Sa tradisyon ng mga Matigsalug Manobo (Bukidnon), ang '
                  'paglitaw ng grupong bituing ito ("Baha") ay karaniwang tanda '
                  'ng simula ng paglilinis ng lupa para sa bagong panahon ng '
                  'pagtatanim. Suriing muna ang lokal na kalendaryo ng '
                  'pagtatanim bago kumilos.',
              akl: 'Sa tradisyon it mga Matigsalug Manobo (Bukidnon), ang '
                  'pagpakita it grupo it mga bituon nga ini ("Baha") '
                  'kinaandan nga tanda it pagsugod it paglimpyo it duta para '
                  'sa bag-o nga panahon it pagtanom. Sigurad-a anay batok sa '
                  'lokal nga kalendaryo it pagtanom antes maghimo.',
            ),
            severity: const Value('low'),
            verificationStatus: const Value('reviewed'),
          ));

      // Pandarawa (Pleiades, grouped under Taurus in this schema): planning
      // what and where to plant.
      await db.into(db.farmingRules).insert(FarmingRulesCompanion.insert(
            ruleId: Value(StarcropSeedData.rulePleiadesPlanning),
            skyTriggerId: const Value(StarcropSeedData.skyTriggerTaurusVisible),
            activityId: StarcropSeedData.activityPrepare,
            cropId: const Value(StarcropSeedData.cropRice),
            sourceId: StarcropSeedData.sourceId,
            guidanceI18n: _i18n(
              'In several Philippine traditions, the Pleiades cluster '
              '("Pandarawa"/"Moroporo") rising alongside Taurus is used as '
              'the signal to plan what crop to plant and how much land to '
              'allocate, ahead of the Balatik (Orion) planting signal.',
              fil: 'Sa ilang tradisyong Pilipino, ginagamit ang pag-usbong ng '
                  'kumpol ng Pleiades ("Pandarawa"/"Moroporo") kasabay ng '
                  'Taurus bilang tanda upang planuhin kung anong pananim ang '
                  'itatanim at gaano karaming lupa ang ilalaan, bago dumating '
                  'ang senyales ng pagtatanim ng Balatik (Orion).',
              akl: 'Sa pila ka tradisyon it Pilipinas, ang pagbutwa it grupo '
                  'it bituon nga Pleiades ("Pandarawa"/"Moroporo") upod sa '
                  'Taurus ginagamit bilang tanda para planuhon kon ano nga '
                  'tanom kag pira ka duta ang igahin, antes it tanda it '
                  'pagtanom nga Balatik (Orion).',
            ),
            severity: const Value('low'),
            verificationStatus: const Value('reviewed'),
          ));

      // Balatik (Orion): start of planting, historically also setting traps
      // to protect new crops from wild pigs.
      await db.into(db.farmingRules).insert(FarmingRulesCompanion.insert(
            ruleId: Value(StarcropSeedData.ruleOrionPlanting),
            skyTriggerId: const Value(StarcropSeedData.skyTriggerOrionVisible),
            activityId: StarcropSeedData.activityPlant,
            cropId: const Value(StarcropSeedData.cropRice),
            sourceId: StarcropSeedData.sourceId,
            guidanceI18n: _i18n(
              'Balatik (Orion) is one of the most widely documented '
              'agricultural sky-markers across Philippine ethnolinguistic '
              'groups, traditionally signaling the start of the planting '
              'season. In the source Manobo calendar this is also when '
              'traps were set to protect new crops from wild pigs.',
              fil: 'Ang Balatik (Orion) ay isa sa pinakakilalang senyales sa '
                  'kalangitan na ginagamit sa pagsasaka ng iba\'t ibang '
                  'pangkat-etnolingguwistiko ng Pilipinas, na karaniwang '
                  'nagpapahiwatig ng simula ng panahon ng pagtatanim. Sa '
                  'orihinal na kalendaryo ng mga Manobo, ito rin ang panahon '
                  'kung kailan naglalagay ng bitag upang protektahan ang '
                  'bagong tanim laban sa mga baboy-ramo.',
              akl: 'Ang Balatik (Orion) isaea sa pinakakilaea nga tanda sa '
                  'langit para sa pagpanguma sa iba\'t ibang grupo it '
                  'Pilipinas, nga kinaandan nagatanda it pagsugod it panahon '
                  'it pagtanom. Sa orihinal nga kalendaryo it Manobo, ini '
                  'man ang panahon nga ginabutang ang lit-ag para '
                  'protektahan ang bag-o nga tanom batok sa ihalas nga '
                  'baboy.',
            ),
            severity: const Value('low'),
            verificationStatus: const Value('reviewed'),
          ));

      // Weather-only: good window to spray when little rain is expected —
      // applies to any crop, no sky condition required.
      await db.into(db.farmingRules).insert(FarmingRulesCompanion.insert(
            ruleId: Value(StarcropSeedData.ruleSprayWindow),
            weatherTriggerId: const Value(StarcropSeedData.weatherTriggerLowRainAhead),
            activityId: StarcropSeedData.activitySpray,
            sourceId: StarcropSeedData.generalAgronomySourceId,
            guidanceI18n: _i18n(
              'Rain is not expected in the next few days — a good window '
              'to apply pest or weed treatment without it being washed away '
              'before it can take effect.',
              fil: 'Walang inaasahang ulan sa susunod na ilang araw — '
                  'magandang pagkakataon upang maglagay ng gamot sa peste o '
                  'damo dahil hindi ito madadala ng ulan bago pa ito '
                  'magkabisa.',
              akl: 'Wara ginapaabot nga oran sa masunod nga pila ka adlaw — '
                  'maayo nga tiyempo para maglagay it bulong sa peste ukon '
                  'hilamon kay indi ini madala it oran antes ini '
                  'makaepekto.',
            ),
            severity: const Value('low'),
            verificationStatus: const Value('confirmed'),
          ));

      // Weather-only: warn to harvest ready crops before incoming heavy rain.
      await db.into(db.farmingRules).insert(FarmingRulesCompanion.insert(
            ruleId: Value(StarcropSeedData.ruleHarvestBeforeRain),
            weatherTriggerId: const Value(StarcropSeedData.weatherTriggerHeavyRainAhead),
            activityId: StarcropSeedData.activityHarvest,
            sourceId: StarcropSeedData.generalAgronomySourceId,
            guidanceI18n: _i18n(
              'Heavy rain is expected soon. If your crop is ready, consider '
              'harvesting now to reduce the risk of lodging or flood damage.',
              fil: 'Inaasahan ang malakas na ulan sa lalong madaling panahon. '
                  'Kung handa na ang iyong tanim, isaalang-alang ang pag-ani '
                  'na ngayon upang mabawasan ang panganib ng pagkatumba o '
                  'pinsala mula sa baha.',
              akl: 'Ginapaabot ang mabug-at nga oran sa madali nga panahon. '
                  'Kon handa na ang imo tanom, huna-hunaa nga anihon eon ini '
                  'agud mabawasan ang peligro it pagkatumba ukon kadaeman it '
                  'baha.',
            ),
            severity: const Value('high'),
            verificationStatus: const Value('confirmed'),
          ));

      // Real classical/ancient star-farming rules — see
      // classicalEthnoastronomySourceId's citation for sources. These are
      // historical/educational reference (different crops and climate than
      // the Manobo-sourced rules above), not calibrated Philippine
      // guidance — the word "historically" stays in every guidance string
      // for exactly that reason. Sky-only (no weather trigger, no crop),
      // severity 'low', and 'reviewed' rather than 'confirmed' since,
      // unlike the weather-only rules, these still make a claim about a
      // specific tradition's timing that deserves a second look before
      // being treated as calendar-accurate anywhere.
      await db.into(db.farmingRules).insert(FarmingRulesCompanion.insert(
            ruleId: Value(StarcropSeedData.ruleSiriusAgriculturalYearStart),
            skyTriggerId: const Value(StarcropSeedData.skyTriggerSiriusFirstRise),
            activityId: StarcropSeedData.activityPrepare,
            sourceId: StarcropSeedData.classicalEthnoastronomySourceId,
            guidanceI18n: _i18n(
              'The heliacal (pre-dawn) rising of Sirius, the brightest star '
              'in the sky, historically marked the start of the '
              'agricultural year in Ancient Egypt — it coincided with the '
              'annual Nile flood that renewed the farmland. Shown here as a '
              'historical reference, not a signal calibrated to your crop '
              'or climate.',
              fil: 'Ang paglitaw ng Sirius bago sumikat ang araw, ang '
                  'pinakamaliwanag na bituin sa langit, ay makasaysayang '
                  'tanda noon ng simula ng taon ng pagsasaka sa Sinaunang '
                  'Ehipto — kasabay ito ng taunang pagbaha ng Nile na '
                  'nagpapasariwa sa lupang taniman. Ipinapakita rito bilang '
                  'makasaysayang sanggunian lamang, hindi tanda na naaayon '
                  'sa iyong pananim o klima.',
            ),
            severity: const Value('low'),
            verificationStatus: const Value('reviewed'),
          ));

      await db.into(db.farmingRules).insert(FarmingRulesCompanion.insert(
            ruleId: Value(StarcropSeedData.ruleArcturusPruningSignal),
            skyTriggerId: const Value(StarcropSeedData.skyTriggerBootesVisible),
            activityId: StarcropSeedData.activityPrepare,
            sourceId: StarcropSeedData.classicalEthnoastronomySourceId,
            guidanceI18n: _i18n(
              'In Hesiod\'s "Works and Days" (Archaic Greece, ~700 BCE), '
              'Arcturus rising bright at dusk about sixty days after the '
              'winter solstice was historically the signal to prune the '
              'vines. Shown here as a historical reference, not a signal '
              'calibrated to your crop or climate.',
              fil: 'Sa "Works and Days" ni Hesiod (Sinaunang Gresya, mga '
                  '700 BCE), ang paglitaw ng Arcturus nang maliwanag sa '
                  'takipsilim, mga animnapung araw pagkatapos ng taglamig '
                  'na solstisyo, ay makasaysayang tanda noon upang putulan '
                  'ang mga baging ng ubas. Ipinapakita rito bilang '
                  'makasaysayang sanggunian lamang, hindi tanda na naaayon '
                  'sa iyong pananim o klima.',
            ),
            severity: const Value('low'),
            verificationStatus: const Value('reviewed'),
          ));

      await db.into(db.farmingRules).insert(FarmingRulesCompanion.insert(
            ruleId: Value(StarcropSeedData.ruleArcturusHarvestSignal),
            skyTriggerId: const Value(StarcropSeedData.skyTriggerArcturusFirstRise),
            activityId: StarcropSeedData.activityHarvest,
            sourceId: StarcropSeedData.classicalEthnoastronomySourceId,
            guidanceI18n: _i18n(
              'Also from Hesiod\'s "Works and Days": when Orion and Sirius '
              'reach midheaven at dawn and Arcturus rises with them '
              '(around September), it was historically the signal to '
              'harvest the grapes. Shown here as a historical reference, '
              'not a signal calibrated to your crop or climate.',
              fil: 'Mula rin sa "Works and Days" ni Hesiod: kapag ang '
                  'Orion at Sirius ay nasa gitna ng langit sa oras ng '
                  'bukang-liwayway at kasabay lumitaw ang Arcturus (mga '
                  'Setyembre), ito ay makasaysayang tanda noon upang anihin '
                  'ang ubas. Ipinapakita rito bilang makasaysayang '
                  'sanggunian lamang, hindi tanda na naaayon sa iyong '
                  'pananim o klima.',
            ),
            severity: const Value('low'),
            verificationStatus: const Value('reviewed'),
          ));

      await db.into(db.farmingRules).insert(FarmingRulesCompanion.insert(
            ruleId: Value(StarcropSeedData.ruleSpicaHarvestSignal),
            skyTriggerId: const Value(StarcropSeedData.skyTriggerVirgoVisible),
            activityId: StarcropSeedData.activityHarvest,
            sourceId: StarcropSeedData.classicalEthnoastronomySourceId,
            guidanceI18n: _i18n(
              'Spica, Virgo\'s brightest star, takes its name from the '
              'Latin "spica virginis" — the virgin\'s ear of wheat grain. '
              'Virgo was long depicted holding a sheaf of wheat, and the '
              'constellation\'s evening visibility was historically tied to '
              'grain-harvest timing across Mediterranean and Near Eastern '
              'tradition. Shown here as a historical reference, not a '
              'signal calibrated to your crop or climate.',
              fil: 'Ang Spica, ang pinakamaliwanag na bituin ng Virgo, ay '
                  'nagmula sa Latin na "spica virginis" — ang uhay ng '
                  'trigo ng birhen. Matagal nang inilalarawan ang Virgo na '
                  'may hawak na bigkis ng trigo, at ang paglitaw nito sa '
                  'gabi ay makasaysayang kaugnay ng oras ng pag-ani ng '
                  'butil sa tradisyon ng Mediteraneo at Gitnang Silangan. '
                  'Ipinapakita rito bilang makasaysayang sanggunian lamang, '
                  'hindi tanda na naaayon sa iyong pananim o klima.',
            ),
            severity: const Value('low'),
            verificationStatus: const Value('reviewed'),
          ));

      // Seasonal climate normals (offline seasonal outlook) — climatology,
      // not forecast. See offline_seasonal_outlook_plan.md and
      // SeasonalClimateNormals' doc comment in farming_db.dart. Seeded
      // 'reviewed' (not 'confirmed') per StarcropSeedData's doc comment:
      // these are PAGASA station normals for Iloilo City applied to the
      // whole Panay/Western Visayas region, pending per-province local
      // review. This loop was previously missing entirely, so the table
      // stayed empty even though the data and schema both existed.
      for (final n in StarcropSeedData.seasonalNormals) {
        await db.into(db.seasonalClimateNormals).insert(
              SeasonalClimateNormalsCompanion.insert(
                regionId: n.regionId,
                month: n.month,
                avgRainMm: n.avgRainMm,
                tempMinC: n.tempMinC,
                tempMaxC: n.tempMaxC,
                classification: n.classification,
                sourceId: StarcropSeedData.climateNormalsSourceId,
                verificationStatus: const Value('reviewed'),
              ),
            );
      }
    });
  }
}
