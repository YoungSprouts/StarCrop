# Data Schema (Mermaid)

Split into four diagrams so each stays readable on GitHub. Edit this file in the same commit as any database migration.

Cross-database links are by ID only (see the table at the bottom). Tables from another database appear here as small stubs.

## 1. Reference database (shipped, read-only)

```mermaid
erDiagram
    TIMEZONES ||--o{ PLACES : "timezone_id"
    CONSTELLATIONS ||--o{ CONSTELLATION_LINES : "const_code"
    STARS ||--o{ CONSTELLATION_LINES : "star_a and star_b"
    SKY_CULTURES ||--o{ CONSTELLATION_LINES : "culture_id"
    CONSTELLATIONS ||--o{ CONSTELLATION_NAMES : "const_code"
    SKY_CULTURES ||--o{ CONSTELLATION_NAMES : "culture_id"

    STARS {
        int hip_id PK "Hipparcos number"
        real ra_deg "J2000"
        real dec_deg "J2000"
        real magnitude
        real color_index
        string proper_name
    }
    CONSTELLATIONS {
        string code PK "IAU 3-letter"
        string latin_name
        real area_sq_deg
        real center_ra
        real center_dec
    }
    SKY_CULTURES {
        int culture_id PK
        string name
        string region
        string license
        string source
    }
    CONSTELLATION_LINES {
        int line_id PK
        string const_code FK
        int culture_id FK
        int star_a FK
        int star_b FK
    }
    CONSTELLATION_NAMES {
        int name_id PK
        string const_code FK
        int culture_id FK
        string language
        string local_name
        string pronunciation_note
    }
    TIMEZONES {
        string zone_id PK
        string rules_json "offsets and DST"
    }
    PLACES {
        int geoname_id PK "GeoNames ID"
        string name
        string alt_names
        string province
        string country
        real lat
        real lon
        string timezone_id FK
        int population
    }
```

Not stored, computed on the fly: altitude/azimuth, rise and set times, moon phase, sun position.

## 2. Farming knowledge (curated, read-only)

```mermaid
erDiagram
    FARMING_RULES }o--o| SKY_TRIGGERS : "sky_trigger_id"
    FARMING_RULES }o--o| WEATHER_TRIGGERS : "weather_trigger_id"
    FARMING_RULES }o--|| ACTIVITIES : "activity_id"
    FARMING_RULES }o--o| CROPS : "crop_id"
    FARMING_RULES }o--o| REGIONS : "region_id"
    FARMING_RULES }o--|| SOURCES : "source_id"
    SKY_TRIGGERS }o--o| CONSTELLATIONS : "const_code"

    CONSTELLATIONS {
        string code PK "stub, see diagram 1"
    }
    SKY_TRIGGERS {
        int trigger_id PK
        string trigger_type "visible, first_rise, last_set, sun_longitude, moon_phase, date_range"
        string const_code FK
        string params_json
    }
    WEATHER_TRIGGERS {
        int trigger_id PK
        string variable "rain, temp, wind, humidity"
        string operator
        real threshold
        int days_ahead
        int duration_days
    }
    FARMING_RULES {
        int rule_id PK
        int sky_trigger_id FK "optional"
        int weather_trigger_id FK "optional"
        int activity_id FK
        int crop_id FK "optional"
        int region_id FK "optional"
        int source_id FK
        string guidance_i18n "text per language"
        string severity
        string verification_status "draft, reviewed, confirmed"
    }
    ACTIVITIES {
        int activity_id PK
        string activity_type "plant, spray, harvest, prepare"
        string description_i18n
    }
    CROPS {
        int crop_id PK
        string name
        string local_names
        string category
    }
    REGIONS {
        int region_id PK
        string name
        real lat_min
        real lat_max
        real lon_min
        real lon_max
        string climate_zone
    }
    SOURCES {
        int source_id PK
        string source_type "farmer, extension_office, publication"
        string name
        string citation
        date source_date
    }
```

A rule may use a sky trigger, a weather trigger, or both (AND). At least one must be set.

## 3. User database (on device, writable)

Every table also carries `created_at`, `updated_at`, and `deleted` (omitted below for space). This keeps optional cloud sync possible later.

```mermaid
erDiagram
    SAVED_LOCATIONS ||--o{ WEATHER_LOG : "location_id"
    SAVED_LOCATIONS ||--o{ FARM_LOG : "location_id"
    SAVED_LOCATIONS ||--o{ PHOTO_OBSERVATIONS : "location_id"
    DEVICE_PROFILES ||--o{ PHOTO_OBSERVATIONS : "device_id"
    PHOTO_OBSERVATIONS ||--o| PHOTO_RESULTS : "obs_id"

    SAVED_LOCATIONS {
        uuid location_id PK
        string label
        real lat
        real lon
        int place_id "ref places.geoname_id"
        string timezone_id
    }
    WEATHER_LOG {
        uuid log_id PK
        uuid location_id FK
        date obs_date
        real rain_mm
        real temp_c
        string notes
    }
    FARM_LOG {
        uuid log_id PK
        uuid location_id FK
        date log_date
        int crop_id "ref crops.crop_id"
        int activity_id "ref activities.activity_id"
        string notes
    }
    PHOTO_OBSERVATIONS {
        uuid obs_id PK
        uuid location_id FK
        string device_id FK
        string file_path
        datetime taken_at
        int exposure_ms
        int iso
    }
    PHOTO_RESULTS {
        uuid obs_id PK, FK
        int stars_detected
        int stars_matched
        real confidence
        real rotation_deg
        real shift_x_px
        real shift_y_px
        string result "confirmed, unclear, failed"
    }
    DEVICE_PROFILES {
        string device_id PK
        string model
        real field_of_view_deg
        string distortion_json
        real compass_error_deg
    }
    FEEDBACK {
        uuid feedback_id PK
        int rule_id "ref farming_rules.rule_id"
        string note
    }
    USER_SETTINGS {
        string key PK
        string value "language, units, sky culture, region"
    }
```

## 4. Cache (disposable, safe to delete and rebuild)

```mermaid
erDiagram
    SAVED_LOCATIONS ||--o{ WEATHER_FORECAST_CACHE : "location_id"
    SAVED_LOCATIONS ||--o{ VISIBILITY_CACHE : "location_id"

    SAVED_LOCATIONS {
        uuid location_id PK "stub, see diagram 3"
    }
    WEATHER_FORECAST_CACHE {
        uuid location_id FK
        datetime fetched_at
        datetime valid_until
        string payload_json "daily and hourly forecast"
    }
    VISIBILITY_CACHE {
        uuid location_id FK
        date calc_date
        string visibility_json
        int ref_data_version "wipe when this changes"
    }
    SKY_SNAPSHOT {
        datetime computed_at
        string snapshot_json "last sky, for instant home screen"
    }
```

## Cross-database links (by ID, not enforced by foreign keys)

| From (user DB) | To (reference or farming DB) |
|---|---|
| `saved_locations.place_id` | `places.geoname_id` |
| `farm_log.crop_id` | `crops.crop_id` |
| `farm_log.activity_id` | `activities.activity_id` |
| `feedback.rule_id` | `farming_rules.rule_id` |

Because content packs replace the reference and farming databases, never delete or renumber IDs that the user database may point to. Retire them instead.
