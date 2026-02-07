CREATE TABLE IF NOT EXISTS users (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "username" TEXT UNIQUE NOT NULL,
    "password" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS schools (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "foundation_year" INTEGER NOT NULL, -- DATE CONSTRAINTS ARE NOT SUPPORTED IN SQLITE, SO WE USE INTEGER TO REPRESENT YEAR AND THIS IS MANAGED BY THE APPLICATION LAYER
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS companies (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "industry" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS students (
    "id" INTEGER,
    "user_id" INTEGER,
    "school_id" INTEGER,
    "start_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "end_date" NUMERIC, -- the student might still be studying at the school/university so end date can be NULL
    "degree" TEXT,
    CHECK (
        "end_date" IS NULL
        OR "end_date" >= "start_date"
        -- no negative durations
    ),
    PRIMARY KEY ("id"),
    FOREIGN KEY ("user_id") REFERENCES "users" ("id"),
    FOREIGN KEY ("school_id") REFERENCES "schools" ("id")
);

CREATE TABLE IF NOT EXISTS followings (
    "user1_id" INTEGER,
    "user2_id" INTEGER,
    PRIMARY KEY ("user1_id", "user2_id"),
    FOREIGN KEY ("user1_id") REFERENCES "users" ("id"),
    FOREIGN KEY ("user2_id") REFERENCES "users" ("id")
);

CREATE TABLE IF NOT EXISTS employees (
    "id" INTEGER,
    "user_id" INTEGER,
    "company_id" INTEGER,
    "start_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "end_date" NUMERIC, -- the user might still be working at the company so NULL is expected
    "title" TEXT NOT NULL,
    CHECK (
        "end_date" IS NULL
        OR "end_date" >= "start_date"
        -- no negative durations
    ),
    PRIMARY KEY ("id"),
    FOREIGN KEY ("user_id") REFERENCES "users" ("id"),
    FOREIGN KEY ("company_id") REFERENCES "companies" ("id")
);