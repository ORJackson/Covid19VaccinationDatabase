CREATE TABLE citizens (
  nhs_number char(10) UNIQUE PRIMARY KEY NOT NULL,
  first_name varchar(255) NOT NULL,
  last_name varchar(255) NOT NULL,
  city varchar(255) NOT NULL,
  age int NOT NULL,
  phone_number varchar(255) NOT NULL
);

ALTER TABLE citizens ADD CONSTRAINT digiconstraint CHECK (nhs_number NOT LIKE '%[^0-9]%');

CREATE TABLE covid19_positive_cases (
  case_id int UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nhs_number char(10) NOT NULL,
  test_date date NOT NULL,
  contacted boolean NOT NULL
);

CREATE TABLE covid19_vaccinations (
  patient_vaccination_id int UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nhs_number char(10) NOT NULL,
  vaccination_date date NOT NULL,
  vaccine_received ENUM('Moderna', 'Pfizer', 'AstraZeneca', 'Johnson & Johnson') NOT NULL
);

CREATE TABLE track_and_trace_location_visits (
  visit_id int UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  nhs_number char(10) NOT NULL,
  location_id int NOT NULL,
  datetime_enter datetime NOT NULL,
  datetime_exit datetime NOT NULL
);

CREATE TABLE locations (
  location_id int UNIQUE PRIMARY KEY NOT NULL AUTO_INCREMENT,
  location_name varchar (255) NOT NULL,
  location_addresss_line_1 varchar (255) NOT NULL,
  location_postcode varchar (255) NOT NULL
);

ALTER TABLE covid19_positive_cases ADD FOREIGN KEY (nhs_number) REFERENCES citizens (nhs_number);

ALTER TABLE covid19_vaccinations ADD FOREIGN KEY (nhs_number) REFERENCES citizens (nhs_number);

ALTER TABLE track_and_trace_location_visits ADD FOREIGN KEY (nhs_number) REFERENCES citizens (nhs_number);

ALTER TABLE track_and_trace_location_visits ADD FOREIGN KEY (location_id) REFERENCES locations (location_id);

INSERT INTO locations(location_name, location_addresss_line_1, location_postcode)
VALUES
('Oreilly Irish Pub', '2 Welsh Street', 'SA1 5PH'),
('El Tapas Bar', '57 Spanish quarter', 'SA8 4FR'),
('Fish Restaraunt', '3 French Boulevard', 'SA4 5TX'),
('Swansea University Pub', '1 University Road', 'SA1 5PR');

INSERT INTO citizens(nhs_number, first_name, last_name, city, age, phone_number) 
VALUES
('8915419210', 'Ben', 'Flowers', 'London', '39', '07700900256'),
('3138528565', 'Abdul', 'Hatem', 'Oxford', '21', '07730443917'),
('9919636833', 'Eva', 'Smith', 'Swansea', '56', '07861901300'),
('3428056167', 'John', 'Williams', 'Cardiff', '66', '07908230181'),
('9998262227', 'Hannah', 'Miller', 'London', '31', '07024329603'),
('6393471866', 'Oliver', 'Garcia', 'Cardiff', '26', '07956730628'),
('4533211716', 'Sophie', 'Brown', 'Slough', '24', '07077580997'),
('3178722709', 'David', 'Nguyen', 'London', '34', '02079460494'),
('9988393171', 'Jennifer', 'Clarke', 'Edinburgh', '59', '07019013144'),
('3345411006', 'Michael', 'Sanchez', 'Manchester', '42', '01614960639'),
('8579819210', 'James', 'Tracey', 'London', '81', '02057984572'),
('5785416784', 'Dennis', 'Menace', 'Bangor', '74', '07400987556');

INSERT INTO track_and_trace_location_visits(nhs_number, location_id, datetime_enter, datetime_exit)
VALUES
('6393471866', '4', '2021-11-24 13:10:00', '2021-11-24 14:10:00'),
('6393471866', '2', '2021-11-25 16:45:00', '2021-11-24 18:30:00'),
('6393471866', '1', '2021-11-25 19:10:00', '2021-11-24 22:10:00'),
('6393471866', '3', '2021-11-26 12:01:00', '2021-11-24 14:30:00');

INSERT INTO covid19_positive_cases (nhs_number, test_date, contacted)
VALUES
('9919636833', DATE '2021-11-15', true),
('3178722709', DATE '2021-11-21', false),
('8915419210', DATE '2021-11-20', false),
('3138528565', DATE '2021-11-23', FALSE);

INSERT INTO covid19_vaccinations (nhs_number, vaccination_date, vaccine_received)
VALUES
('3138528565', DATE '2021-06-20', 'Moderna'),
('3138528565', DATE '2021-08-25', 'Moderna'),
('9919636833', DATE '2021-05-12', 'Pfizer'),
('9919636833', DATE '2021-07-15', 'AstraZeneca'),
('9998262227', DATE '2021-10-22', 'Moderna'),
('3178722709', DATE '2021-07-05', 'AstraZeneca'),
('3178722709', DATE '2021-09-09', 'AstraZeneca'),
('9988393171', DATE '2021-08-16', 'Pfizer'),
('9988393171', DATE '2021-10-20', 'Pfizer'),
('3178722709', DATE '2021-11-25', 'AstraZeneca'),
('8579819210', DATE '2021-11-26', 'Moderna');