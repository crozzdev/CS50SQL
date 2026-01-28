SELECT districts.name
FROM districts
    LEFT JOIN expenditures ON expenditures.district_id = districts.id
WHERE
    expenditures.pupils IS NOT NULL
ORDER BY expenditures.pupils ASC
LIMIT 1;