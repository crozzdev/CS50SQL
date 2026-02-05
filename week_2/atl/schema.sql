CREATE TABLE passengers (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "age" INTEGER NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE concourses (
    "id" INTEGER,
    "code" TEXT NOT NULL UNIQUE CHECK (
        "code" IN (
            'A',
            'B',
            'C',
            'D',
            'E',
            'F',
            'T'
        )
    ),
    PRIMARY KEY ("id")
);

CREATE TABLE airports (
    "id" INTEGER,
    "code" TEXT NOT NULL UNIQUE,
    PRIMARY KEY ("id")
);

CREATE TABLE airlines (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    PRIMARY KEY ("id")
);

CREATE TABLE airlines_concourses (
    "airline_id" INTEGER,
    "concourse_id" INTEGER,
    PRIMARY KEY ("airline_id", "concourse_id"),
    FOREIGN KEY ("airline_id") REFERENCES "airlines" ("id"),
    FOREIGN KEY ("concourse_id") REFERENCES "concourses" ("id")
);

CREATE TABLE flights (
    "id" INTEGER,
    "airline_id" INTEGER,
    "airport_from_id" INTEGER,
    "airport_to_id" INTEGER,
    "flight_number" INTEGER NOT NULL,
    "departure_timestamp" NUMERIC NOT NULL,
    "arrival_timestamp" NUMERIC NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("airline_id") REFERENCES "airlines" ("id"),
    FOREIGN KEY ("airport_from_id") REFERENCES "airports" ("id"),
    FOREIGN KEY ("airport_to_id") REFERENCES "airports" ("id")
);

CREATE TABLE checkins (
    "id" INTEGER,
    "passenger_id" INTEGER,
    "flight_id" INTEGER,
    "timestamp" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("passenger_id") REFERENCES "passengers" ("id"),
    FOREIGN KEY ("flight_id") REFERENCES "flights" ("id")
);