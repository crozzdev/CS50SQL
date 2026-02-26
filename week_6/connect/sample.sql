-- Insert users
INSERT INTO
    `users` (
        `id`,
        `first_name`,
        `last_name`,
        `username`,
        `password`
    )
VALUES (
        1,
        'Alan',
        'Garber',
        'alan',
        'password'
    );

INSERT INTO
    `users` (
        `id`,
        `first_name`,
        `last_name`,
        `username`,
        `password`
    )
VALUES (
        2,
        'Reid',
        'Hoffman',
        'reid',
        'password'
    );

-- Insert school: Harvard University
INSERT INTO
    `schools` (
        `id`,
        `name`,
        `type`,
        `location`,
        `foundation_year`
    )
VALUES (
        1,
        'Harvard University',
        'University',
        'Cambridge, Massachusetts',
        1636
    );

-- Insert company: LinkedIn
INSERT INTO
    `companies` (
        `id`,
        `name`,
        `industry`,
        `location`
    )
VALUES (
        1,
        'LinkedIn',
        'Technology',
        'Sunnyvale, California'
    );

-- Insert Alan Garber's education at Harvard (BA, 1973-1976)
INSERT INTO
    `students` (
        `user_id`,
        `school_id`,
        `start_date`,
        `end_date`,
        `degree`
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
    `employees` (
        `user_id`,
        `company_id`,
        `start_date`,
        `end_date`,
        `title`
    )
VALUES (
        2,
        1,
        '2003-01-01',
        '2007-02-01',
        'CEO and Chairman'
    );

-- Fix next AUTO_INCREMENT values after explicit id inserts
ALTER TABLE `users` AUTO_INCREMENT = 3;

ALTER TABLE `schools` AUTO_INCREMENT = 2;

ALTER TABLE `companies` AUTO_INCREMENT = 2;