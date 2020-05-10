-- Table Definition ----------------------------------------------

CREATE TABLE project (
    id SERIAL PRIMARY KEY,
    name text,
    street text,
    district text,
    type text,
    coordinates point
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX project_pkey ON project(id int4_ops);
CREATE UNIQUE INDEX project_name_street_key ON project(name text_ops,street text_ops);
CREATE INDEX project_street_index ON project USING HASH (street text_ops);
CREATE INDEX project_district_index ON project USING HASH (district text_ops);
CREATE INDEX project_type_index ON project USING HASH (type text_ops);
CREATE INDEX project_coord_index ON project USING GIST (coordinates point_ops);


-- Table Definition ----------------------------------------------

CREATE TABLE rental (
    id SERIAL PRIMARY KEY,
    project_id integer REFERENCES project(id),
    area_sqm int4range,
    lease_date date NOT NULL,
    rent integer NOT NULL,
    bedroom_no smallint
);

-- Indices -------------------------------------------------------

CREATE UNIQUE INDEX rental_pkey ON rental(id int4_ops);
CREATE INDEX rental_rent_index ON rental(rent int4_ops);
CREATE INDEX rental_area_sqm_index ON rental(area_sqm range_ops);
CREATE INDEX rental_lease_date_index ON rental(lease_date date_ops);
CREATE INDEX rental_bedroom_no_index ON rental(bedroom_no int2_ops);
CREATE INDEX rental_project_id_index ON rental(project_id int4_ops);
