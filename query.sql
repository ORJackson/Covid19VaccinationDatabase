--POSITIVE COVID CASES TO CONTACT

CREATE OR REPLACE view covid_cases_to_contact AS 
SELECT citizens.nhs_number, citizens.first_name, citizens.last_name, 
citizens.phone_number, covid19_positive_cases.test_date
FROM citizens
INNER JOIN covid19_positive_cases
on citizens.nhs_number = covid19_positive_cases.nhs_number
WHERE covid19_positive_cases.contacted IS FALSE;


-- VACCINE PASSPORT

CREATE OR REPLACE view vaccine_passport_3138528565 (first_initial, last_name, num_vaccinations) AS
SELECT SUBSTRING (c.first_name, 1, 1), c.last_name, COUNT(c19v.nhs_number)
FROM citizens c
INNER JOIN covid19_vaccinations c19v
ON c.nhs_number = c19v.nhs_number
WHERE c19v.nhs_number = '3138528565';


-- ANOTHER VACCINE PASSPORT

CREATE OR REPLACE view vaccine_passport_6393471866 (first_initial, last_name, num_vaccinations) AS
SELECT SUBSTRING (c.first_name, 1, 1), c.last_name, COUNT(c19v.nhs_number)
FROM citizens c
INNER JOIN covid19_vaccinations c19v
ON c.nhs_number = c19v.nhs_number
WHERE c19v.nhs_number = '6393471866';


--TRACK AND TRACE

CREATE OR REPLACE view track_and_trace AS
SELECT visits.nhs_number, visits.datetime_enter, visits.datetime_exit, visits.location_id
FROM track_and_trace_location_visits visits
WHERE visits.nhs_number = '6393471866'
AND visits.datetime_enter BETWEEN (NOW() - INTERVAL 7 DAY) AND NOW();


-- VACCINE ROLLOUT SYSTEM
-- vaccine_priority_queue, unvaccinated_citizens, and vaccine_rollout will not be accessed by local government receptionists
-- only current_vaccine_priority_group


CREATE OR REPLACE view vaccine_priority_queue AS
SELECT citizens.nhs_number, citizens.age, citizens.first_name, citizens.last_name, citizens.city, citizens.phone_number,
CASE 
WHEN citizens.age > 79 THEN 1
    WHEN citizens.age > 74 THEN 2
    WHEN citizens.age > 69 THEN 3
    WHEN citizens.age > 64 THEN 4
    WHEN citizens.age > 59 THEN 5
    WHEN citizens.age > 54 THEN 6
    WHEN citizens.age > 49 THEN 7
    ELSE 8
    END as priority
FROM citizens;

CREATE OR REPLACE VIEW unvaccinated_citizens AS
SELECT priority.priority, priority.nhs_number
FROM vaccine_priority_queue priority LEFT JOIN covid19_vaccinations ON priority.nhs_number = covid19_vaccinations.nhs_number
WHERE covid19_vaccinations.nhs_number IS NULL;

CREATE OR REPLACE VIEW vaccine_rollout AS 
SELECT priority.nhs_number, priority.first_name, priority.last_name, priority.phone_number, priority.city, priority.priority
FROM unvaccinated_citizens JOIN vaccine_priority_queue priority ON priority.nhs_number = unvaccinated_citizens.nhs_number
ORDER BY priority;

-- ALL CURRENT BATCH TO BE VACCINATED:
-- This is the view that would be used by government receptionists

CREATE OR REPLACE VIEW current_vaccine_priority_group AS
SELECT nhs_number, first_name, last_name, phone_number, city
FROM vaccine_rollout
WHERE priority = (SELECT MIN(priority) FROM unvaccinated_citizens);
