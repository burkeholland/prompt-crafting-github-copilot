CREATE TABLE vehicles (
    vin VARCHAR(255) PRIMARY KEY,
    county VARCHAR(255),
    city VARCHAR(255),
    state CHAR(2),
    postal_code VARCHAR(10),
    model_year INT,
    make VARCHAR(255),
    model VARCHAR(255),
    electric_vehicle_type VARCHAR(255),
    clean_alternative_fuel_vehicle_eligibility VARCHAR(255),
    electric_range INT,
    base_msrp INT,
    legislative_district INT,
    dol_vehicle_id BIGINT
);