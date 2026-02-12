-- Active: 1770862217527@@127.0.0.1@3306
UPDATE users
SET
    password = '982c0381c279d139fd221fce974916e7'
WHERE
    "id" = (
        SELECT id
        FROM users
        WHERE
            username = 'admin'
    );

DELETE FROM user_logs
WHERE
    "old_username" = 'admin'
    AND "type" = 'update';

INSERT INTO
    user_logs (
        old_username,
        new_username,
        type,
        old_password,
        new_password
    )
VALUES (
        'admin',
        'admin',
        'update',
        'e10adc3949ba59abbe56e057f20f883e',
        '44bf025d27eea66336e5c1133c3827f7'
    );