SELECT "title", "air_date"
FROM episodes
WHERE
    air_date LIKE '____-12-__';

-- not using like

SELECT "title", "air_date"
FROM episodes
WHERE
    substr(air_date, 6, 2) = '12';