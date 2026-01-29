SELECT "first_name", "last_name"
FROM players
WHERE
    "id" IN (
        SELECT players."id"
        FROM
            players
            JOIN salaries ON salaries."player_id" = players."id"
            JOIN performances ON performances."player_id" = players."id"
            AND performances."year" = salaries."year"
        WHERE
            performances."H" > 0
            AND salaries."year" = 2001
        ORDER BY (
                salaries."salary" / performances."H"
            ) ASC, players."first_name" ASC, players."last_name" ASC
        LIMIT 10
    )
    AND "id" IN (
        SELECT players."id"
        FROM
            players
            JOIN salaries ON salaries."player_id" = players."id"
            JOIN performances ON performances."player_id" = players."id"
            AND performances."year" = salaries."year"
        WHERE
            performances."RBI" > 0
            AND salaries."year" = 2001
        ORDER BY (
                salaries."salary" / performances."RBI"
            ) ASC, players."first_name" ASC, players."last_name" ASC
        LIMIT 10
    )
ORDER BY players."last_name" ASC;