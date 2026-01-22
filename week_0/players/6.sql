SELECT
    "first_name",
    "last_name",
    "debut"
FROM players
WHERE
    "birth_city" = 'Pittsburgh'
    AND "birth_state" = 'PA'
    AND "birth_country" = 'USA'
ORDER BY
    "debut" DESC,
    "first_name",
    "last_name";