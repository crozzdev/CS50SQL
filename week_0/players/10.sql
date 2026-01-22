SELECT
    "first_name" AS 'Nombre',
    "last_name" AS 'Apellido',
    "height" AS 'Altura en pies'
FROM players
WHERE
    "birth_country" = 'USA'
ORDER BY "height" DESC
LIMIT 5;