UPDATE covid_deaths
SET
    population                             = NULLIF(population, ''),
    continent                              = NULLIF(continent, ''),
    total_cases                            = NULLIF(total_cases, ''),
    new_cases                              = NULLIF(new_cases, ''),
    new_cases_smoothed                     = NULLIF(new_cases_smoothed, ''),

    total_deaths                           = NULLIF(total_deaths, ''),
    new_deaths                             = NULLIF(new_deaths, ''),
    new_deaths_smoothed                    = NULLIF(new_deaths_smoothed, ''),

    total_cases_per_million                = NULLIF(total_cases_per_million, ''),
    new_cases_per_million                  = NULLIF(new_cases_per_million, ''),
    new_cases_smoothed_per_million         = NULLIF(new_cases_smoothed_per_million, ''),

    total_deaths_per_million               = NULLIF(total_deaths_per_million, ''),
    new_deaths_per_million                 = NULLIF(new_deaths_per_million, ''),
    new_deaths_smoothed_per_million        = NULLIF(new_deaths_smoothed_per_million, ''),

    reproduction_rate                      = NULLIF(reproduction_rate, ''),

    icu_patients                           = NULLIF(icu_patients, ''),
    icu_patients_per_million               = NULLIF(icu_patients_per_million, ''),

    hosp_patients                          = NULLIF(hosp_patients, ''),
    hosp_patients_per_million              = NULLIF(hosp_patients_per_million, ''),

    weekly_icu_admissions                  = NULLIF(weekly_icu_admissions, ''),
    weekly_icu_admissions_per_million      = NULLIF(weekly_icu_admissions_per_million, ''),

    weekly_hosp_admissions                 = NULLIF(weekly_hosp_admissions, ''),
    weekly_hosp_admissions_per_million     = NULLIF(weekly_hosp_admissions, '')

UPDATE covid_vaccinations
SET
    new_tests                              = NULLIF(new_tests, ''),
    total_tests                            = NULLIF(total_tests, ''),
    total_tests_per_thousand               = NULLIF(total_tests_per_thousand, ''),
    new_tests_per_thousand                 = NULLIF(new_tests_per_thousand, ''),
    new_tests_smoothed                     = NULLIF(new_tests_smoothed, ''),
    new_tests_smoothed_per_thousand        = NULLIF(new_tests_smoothed_per_thousand, ''),

    positive_rate                          = NULLIF(positive_rate, ''),
    tests_per_case                         = NULLIF(tests_per_case, ''),
    tests_units                            = NULLIF(tests_units, ''),

    total_vaccinations                     = NULLIF(total_vaccinations, ''),
    people_vaccinated                      = NULLIF(people_vaccinated, ''),
    people_fully_vaccinated                = NULLIF(people_fully_vaccinated, ''),
    new_vaccinations                       = NULLIF(new_vaccinations, ''),
    new_vaccinations_smoothed              = NULLIF(new_vaccinations_smoothed, ''),

    total_vaccinations_per_hundred         = NULLIF(total_vaccinations_per_hundred, ''),
    people_vaccinated_per_hundred          = NULLIF(people_vaccinated_per_hundred, ''),
    people_fully_vaccinated_per_hundred    = NULLIF(people_fully_vaccinated_per_hundred, ''),
    new_vaccinations_smoothed_per_million  = NULLIF(new_vaccinations_smoothed_per_million, ''),

    stringency_index                       = NULLIF(stringency_index, ''),
    population_density                     = NULLIF(population_density, ''),
    median_age                             = NULLIF(median_age, ''),
    aged_65_older                          = NULLIF(aged_65_older, ''),
    aged_70_older                          = NULLIF(aged_70_older, ''),

    gdp_per_capita                         = NULLIF(gdp_per_capita, ''),
    extreme_poverty                        = NULLIF(extreme_poverty, ''),
    cardiovasc_death_rate                  = NULLIF(cardiovasc_death_rate, ''),
    diabetes_prevalence                    = NULLIF(diabetes_prevalence, ''),
    female_smokers                         = NULLIF(female_smokers, ''),
    male_smokers                           = NULLIF(male_smokers, ''),

    handwashing_facilities                 = NULLIF(handwashing_facilities, ''),
    hospital_beds_per_thousand             = NULLIF(hospital_beds_per_thousand, ''),
    life_expectancy                        = NULLIF(life_expectancy, ''),
    human_development_index                = NULLIF(human_development_index, '')