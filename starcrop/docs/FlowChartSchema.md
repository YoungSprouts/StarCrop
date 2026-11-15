# App Flow (Mermaid)

Split into four diagrams so each stays readable on GitHub. Table names in the boxes show what each step reads or writes, so this file lines up with `schema.md`.

## 1. App launch

What happens from the moment the user opens the app.

```mermaid
flowchart TD
    A["User opens the app"] ==> B["Load user_settings<br/>language, units, sky culture, region"]
    B ==> C{"Any saved_locations?"}
    C ==>|No| D["Ask for a location<br/>typed, or GPS if available"]
    D ==> E["Save to saved_locations<br/>link place_id to places"]
    E ==> G
    C ==>|Yes| F["Show home screen at once<br/>from sky_snapshot"]
    F ==> G["Sky engine computes the sky<br/>reads reference DB, location, clock"]
    G ==> H["Update sky_snapshot"]
    H ==> I{"Signal available?"}
    I ==>|Yes| J["Weather engine downloads forecast<br/>saves to weather_forecast_cache"]
    I ==>|No| K["Use last forecast and weather_log<br/>show forecast age, may be outdated"]
    J ==> L["Rule engine matches sky and forecast<br/>to farming_rules"]
    K ==> L
    L ==> M["Home screen shows guidance,<br/>activities, and weather"]
```

## 2. Screens

What the user can open from the home screen and what each one does.

```mermaid
flowchart TD
    H["Home screen"] ==>|Tap Sky chart| S1["Sky chart<br/>constellations and stars overhead"]
    H ==>|Tap Farmer guidance| S2["Farmer guidance<br/>guidance, severity, verification status, source"]
    H ==>|Tap Suggested activities| S3["Suggested activities<br/>plant, spray, harvest, prepare"]
    H ==>|Tap Upcoming weather| S4["Upcoming weather<br/>forecast kept for offline use"]
    H ==>|Tap Camera check| S5["Camera check<br/>see diagram 3"]

    S1 ==>|Tap a constellation| S1A["Show names for the chosen sky culture<br/>constellation_names, constellation_lines"]
    S2 ==>|Leave a note on a rule| S2A["Save to feedback<br/>rule_id, note"]
    S3 ==>|Log an activity| S3A["Save to farm_log<br/>crop_id, activity_id, notes"]
    S4 ==>|Add what you observed| S4A["Save to weather_log<br/>rain_mm, temp_c, notes"]
```

## 3. Camera check

The photo engine flow, from taking the photo to correcting the compass.

```mermaid
flowchart TD
    A["User taps Camera check"] ==> B["Take a photo of the night sky"]
    B ==> C["Save to photo_observations<br/>file_path, taken_at, location_id, exposure_ms, iso, device_id"]
    C ==> D["Read device_profiles<br/>field_of_view_deg, distortion_json, compass_error_deg"]
    D ==> E["Photo engine finds stars in the photo"]
    E ==> F["Compare with the sky predicted<br/>by the sky engine"]
    F ==> G{"How well do they match?"}
    G ==>|Good match| H["result: confirmed"]
    G ==>|Weak match| I["result: unclear"]
    G ==>|No match| J["result: failed"]
    H ==> K["Save to photo_results<br/>stars_detected, stars_matched, confidence,<br/>rotation_deg, shift_x_px, shift_y_px, result"]
    I ==> K
    J ==> K
    K ==> L["Update device_profiles<br/>compass_error_deg"]
    L ==> M["Show the result to the user"]
```

## 4. Content pack update

How new star, place, and farming data arrives without touching user data.

```mermaid
flowchart TD
    A["Content pack received<br/>file, SD card, or phone to phone"] ==> B{"Checksum and version OK?"}
    B ==>|No| C["Reject the pack<br/>keep the current data"]
    B ==>|Yes| D["Replace reference database<br/>and farming knowledge"]
    D ==> E["ref_data_version changes"]
    E ==> F["Wipe visibility_cache<br/>rebuilt on next launch"]
    F ==> G["User database left untouched"]
    G ==> H["Retired IDs stay in place,<br/>nothing is renumbered"]
```

## Notes on what comes from where

* Diagram 1 follows the drawio and `schema.md`: typed location or GPS, the instant home screen from `sky_snapshot`, and the online versus offline weather behaviour.
* The five screens in diagram 2 come from the drawio. The taps that lead to `feedback`, `farm_log`, and `weather_log` are inferred from those tables, because the drawio has no arrow from a screen to them. Confirm or remove them.
* Diagram 3 follows the photo engine box. The three result values come from `photo_results.result` in `schema.md`.
* Diagram 4 follows the content pack box and the ID rule at the bottom of `schema.md`. The step that rejects a bad pack is inferred from "versioned and checksummed".
* The drawio has no screen for `user_settings`, so settings are only loaded here and never edited.
