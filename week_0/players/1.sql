-- Active: 1769046493419@@127.0.0.1@3306
SELECT
    "birth_city",
    "birth_state",
    "birth_country"
FROM players
WHERE
    "first_name" = 'Jackie'
    and "last_name" = 'Robinson';