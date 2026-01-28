SELECT
    "city",
    COUNT("name") as "Total Public Schools"
FROM schools
WHERE
    "type" = 'Public School'
GROUP BY
    "city"
HAVING
    "Total Public Schools" <= 3
ORDER BY
    "Total Public Schools" DESC,
    "city" ASC;