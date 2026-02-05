-- Insert passenger: Amelia Earhart, 39 years old
INSERT INTO
    passengers (
        "first_name",
        "last_name",
        "age"
    )
VALUES ('Amelia', 'Earhart', 39);

-- Insert concourses (if not already present)
INSERT INTO concourses ("code") VALUES ('A');

INSERT INTO concourses ("code") VALUES ('B');

INSERT INTO concourses ("code") VALUES ('C');

INSERT INTO concourses ("code") VALUES ('D');

INSERT INTO concourses ("code") VALUES ('E');

INSERT INTO concourses ("code") VALUES ('F');

INSERT INTO concourses ("code") VALUES ('T');

-- Insert airports: ATL and BOS
INSERT INTO airports ("code") VALUES ('ATL');

INSERT INTO airports ("code") VALUES ('BOS');

-- Insert airline: Delta
INSERT INTO airlines ("name") VALUES ('Delta');

-- Link Delta to concourses A, B, C, D, and T
INSERT INTO
    airlines_concourses ("airline_id", "concourse_id")
VALUES (1, 1), -- Delta (id=1) operates in Concourse A (id=1)
    (1, 2), -- Delta operates in Concourse B (id=2)
    (1, 3), -- Delta operates in Concourse C (id=3)
    (1, 4), -- Delta operates in Concourse D (id=4)
    (1, 7);
-- Delta operates in Concourse T (id=7)

-- Insert flight: Delta Flight 300
-- Departure: August 3rd, 2023 at 6:46 PM → '2023-08-03 18:46:00'
-- Arrival: August 3rd, 2023 at 9:09 PM → '2023-08-03 21:09:00'
INSERT INTO
    flights (
        "airline_id",
        "airport_from_id",
        "airport_to_id",
        "flight_number",
        "departure_timestamp",
        "arrival_timestamp"
    )
VALUES (
        1,
        1,
        2,
        300,
        '2023-08-03 18:46:00',
        '2023-08-03 21:09:00'
    );

-- Insert check-in: Amelia Earhart for Delta Flight 300
-- Check-in time: August 3rd, 2023 at 3:03 PM → '2023-08-03 15:03:00'
INSERT INTO
    checkins (
        "passenger_id",
        "flight_id",
        "timestamp"
    )
VALUES (1, 1, '2023-08-03 15:03:00');