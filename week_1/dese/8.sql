SELECT districts.name, expenditures.pupils
FROM districts
    LEFT JOIN expenditures ON expenditures.district_id = districts.id
WHERE
    expenditures.pupils IS NOT NULL;