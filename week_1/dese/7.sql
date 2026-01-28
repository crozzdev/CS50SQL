SELECT schools.name
FROM schools
    LEFT JOIN districts ON districts.id = schools.district_id
WHERE
    districts.name = 'Cambridge';