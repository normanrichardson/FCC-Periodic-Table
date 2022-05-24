
-- RENAME THE COLUMNS
ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;
ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;
ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;

-- SET COLUMN NULL CONSTRAINT
ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;
ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;

-- SET COLUMN UNIQUENESS CONSTRAINT
ALTER TABLE elements DROP CONSTRAINT IF EXISTS elements_name_key;
ALTER TABLE elements DROP CONSTRAINT IF EXISTS elements_symbol_key;
ALTER TABLE elements ADD UNIQUE(symbol);
ALTER TABLE elements ADD UNIQUE(name);

-- SET COLUMN NULL CONSTRAINT
ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;
ALTER TABLE elements ALTER COLUMN name SET NOT NULL;

-- SET atomic_number TO A FOREIGN KEY IN properties
ALTER TABLE properties DROP CONSTRAINT IF EXISTS properties_atomic_number_fkey;
ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number);

-- CREATE THE types TABLE FROM DISTINCT VALUES IN properties type COLUMN
CREATE TABLE types(
  type_id SERIAL PRIMARY KEY,
  type VARCHAR(30) UNIQUE NOT NULL);

INSERT INTO types(type) (
  SELECT DISTINCT(type) FROM properties
);

-- CREATE type_id COLUMN IN properties
ALTER TABLE properties DROP CONSTRAINT IF EXISTS properties_type_id_fkey;
ALTER TABLE properties DROP COLUMN IF EXISTS type_id;
ALTER TABLE properties ADD COLUMN type_id INT;
ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id);


-- ADD DATA TO properties type_id COLUMN BEFORE SETTING NULL CONSTRAINT ON COLUMN
UPDATE properties SET type_id = (
  SELECT type_id FROM types WHERE type=properties.type
);

-- NOW SET TO NULL CONSTRAINT
ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;

-- DELETE THE type COLUMN IN properties
ALTER TABLE properties DROP COLUMN IF EXISTS type;

-- UPDATE THE elements symbol SO THAT THE 1ST LETTER IS A CAPITAL LETTER
UPDATE elements
SET symbol = (
  SELECT
    CONCAT(UPPER(LEFT(a.symbol,1)),RIGHT(a.symbol,-1))
  FROM
    elements AS a
  WHERE
    a.symbol = elements.symbol
);

-- ALTER TYPE OF properties atomic_mass COLUMN TO DECIMAL AND MAP VALUES TO REAL NUMBERS
ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL USING atomic_mass::REAL;

-- ADD FLUORINE AND NEON
INSERT INTO elements(atomic_number, symbol, name) VALUES
  (9, 'F', 'Fluorine'),
  (10, 'Ne', 'Neon');

INSERT INTO properties (
  atomic_number,
  atomic_mass,
  melting_point_celsius,
  boiling_point_celsius,
  type_id
) VALUES
  (9, 18.998, -220, -188.1, 
    (
      SELECT type_id FROM types WHERE type='nonmetal'
    )
  ),
  (10, 20.18, -248.6, -246.1,
    (
      SELECT type_id FROM types WHERE type='nonmetal'
    )
  );

-- REMOVE atomic_number OF 1000
DELETE FROM  properties WHERE atomic_number = 1000;
DELETE FROM  elements WHERE atomic_number = 1000;
