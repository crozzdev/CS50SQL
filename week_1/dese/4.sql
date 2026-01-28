SELECT "city", COUNT("name") as 'Total Public Schools'
FROM schools
WHERE
    "type" = 'Public School'
GROUP BY
    "city"
ORDER BY
    "Total Public Schools" DESC,
    "city" ASC
LIMIT 10;