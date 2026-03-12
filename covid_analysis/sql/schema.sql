DROP TABLE IF EXISTS covid_deaths;
DROP TABLE IF EXISTS covid_vaccinations;

CREATE TABLE covid_deaths (
    iso_code                               TEXT,
    continent                              TEXT,
    location                               TEXT,
    date                                   TEXT,

    population                             INTEGER,

    total_cases                            INTEGER,
    new_cases                              INTEGER,
    new_cases_smoothed                     REAL,

    total_deaths                           INTEGER,
    new_deaths                             INTEGER,
    new_deaths_smoothed                    REAL,

    total_cases_per_million                REAL,
    new_cases_per_million                  REAL,
    new_cases_smoothed_per_million         REAL,

    total_deaths_per_million               REAL,
    new_deaths_per_million                 REAL,
    new_deaths_smoothed_per_million        REAL,

    reproduction_rate                      REAL,

    icu_patients                           REAL,
    icu_patients_per_million               REAL,

    hosp_patients                          REAL,
    hosp_patients_per_million              REAL,

    weekly_icu_admissions                  REAL,
    weekly_icu_admissions_per_million      REAL,

    weekly_hosp_admissions                 REAL,
    weekly_hosp_admissions_per_million     REAL
);


CREATE TABLE covid_vaccinations (
    iso_code                               TEXT,
    continent                              TEXT,
    location                               TEXT,
    date                                   TEXT,

    new_tests                              INTEGER,
    total_tests                            INTEGER,
    total_tests_per_thousand               REAL,
    new_tests_per_thousand                 REAL,
    new_tests_smoothed                     REAL,
    new_tests_smoothed_per_thousand        REAL,

    positive_rate                          REAL,
    tests_per_case                         REAL,
    tests_units                            TEXT,

    total_vaccinations                     INTEGER,
    people_vaccinated                      INTEGER,
    people_fully_vaccinated                INTEGER,
    new_vaccinations                       INTEGER,
    new_vaccinations_smoothed              REAL,

    total_vaccinations_per_hundred         REAL,
    people_vaccinated_per_hundred          REAL,
    people_fully_vaccinated_per_hundred    REAL,
    new_vaccinations_smoothed_per_million  REAL,

    stringency_index                       REAL,
    population_density                     REAL,
    median_age                             REAL,
    aged_65_older                          REAL,
    aged_70_older                          REAL,

    gdp_per_capita                         REAL,
    extreme_poverty                        REAL,
    cardiovasc_death_rate                  REAL,
    diabetes_prevalence                    REAL,
    female_smokers                         REAL,
    male_smokers                           REAL,

    handwashing_facilities                 REAL,
    hospital_beds_per_thousand             REAL,
    life_expectancy                        REAL,
    human_development_index                REAL
);