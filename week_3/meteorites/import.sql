CREATE TABLE meteorites_temp (
    "name" TEXT NOT NULL,
    "id" INTEGER,
    "nametype" TEXT,
    "class" TEXT,
    "mass" TEXT,
    "discovery" TEXT,
    "year" TEXT,
    "lat" TEXT,
    "long" TEXT
);

.import --csv --skip 1 meteorites.csv meteorites_temp

-- All meteorites with the nametype “Relict” are not included in the meteorites table

DELETE FROM meteorites_temp WHERE "nametype" = 'Relict';

-- All 0 values in the mass, lat, long, and year columns are replaced with NULLfor mass, lat, and long, and year

UPDATE meteorites_temp SET "mass" = NULL WHERE "mass" = '';

UPDATE meteorites_temp SET "lat" = NULL WHERE "lat" = '';

UPDATE meteorites_temp SET "long" = NULL WHERE "long" = '';

UPDATE meteorites_temp SET "year" = NULL WHERE "year" = '';

-- All columns with decimal values (e.g., 70.4777) should be rounded to the nearest hundredths place (e.g., 70.4777 becomes 70.48)

UPDATE meteorites_temp
SET
    "mass" = ROUND("mass", 2)
WHERE
    "mass" IS NOT NULL;

UPDATE meteorites_temp
SET
    "lat" = ROUND("lat", 2)
WHERE
    "lat" IS NOT NULL;

UPDATE meteorites_temp
SET
    "long" = ROUND("long", 2)
WHERE
    "long" IS NOT NULL;

-- The meteorites are sorted by year, oldest to newest, and then—if any two meteorites landed in the same year—by name, in alphabetical order.

-- You’ve updated the IDs of the meteorites from meteorites.csv, according to the order specified in #4

CREATE TABLE meteorites (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "class" TEXT NOT NULL,
    "mass" REAL,
    "discovery" TEXT CHECK (
        "discovery" IN ('Found', 'Fell')
    ),
    "year" INTEGER CHECK (
        "year" > 0
        OR "year" IS NULL
    ),
    "lat" REAL,
    "long" REAL,
    PRIMARY KEY ("id")
);

INSERT INTO
    meteorites (
        "name",
        "class",
        "mass",
        "discovery",
        "year",
        "lat",
        "long"
    )
SELECT "name", "class", "mass", "discovery", "year", "lat", "long"
FROM meteorites_temp
ORDER BY "year" ASC, "name" ASC;

DROP TABLE meteorites_temp;