-- Insert users
INSERT INTO
    users (
        "first_name",
        "last_name",
        "username",
        "password"
    )
VALUES (
        'Alan',
        'Garber',
        'alan',
        'password'
    );

INSERT INTO
    users (
        "first_name",
        "last_name",
        "username",
        "password"
    )
VALUES (
        'Reid',
        'Hoffman',
        'reid',
        'password'
    );

-- Insert school: Harvard University
INSERT INTO
    schools (
        "name",
        "type",
        "location",
        "foundation_year"
    )
VALUES (
        'Harvard University',
        'University',
        'Cambridge, Massachusetts',
        1636
    );

-- Insert company: LinkedIn
INSERT INTO
    companies (
        "name",
        "industry",
        "location"
    )
VALUES (
        'LinkedIn',
        'Technology',
        'Sunnyvale, California'
    );

-- Insert Alan Garber's education at Harvard (BA, 1973-1976)
INSERT INTO
    students (
        "user_id",
        "school_id",
        "start_date",
        "end_date",
        "degree"
    )
VALUES (
        1,
        1,
        '1973-09-01',
        '1976-06-01',
        'BA'
    );

-- Insert Reid Hoffman's employment at LinkedIn (CEO and Chairman, 2003-2007)
INSERT INTO
    employees (
        "user_id",
        "company_id",
        "start_date",
        "end_date",
        "title"
    )
VALUES (
        2,
        1,
        '2003-01-01',
        '2007-02-01',
        'CEO and Chairman'
    );