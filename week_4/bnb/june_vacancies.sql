CREATE VIEW "june_vacancies" AS
SELECT listings."id", listings."property_type", listings."host_name", COUNT(availabilities."id") AS "days_vacant"
FROM listings
    JOIN availabilities ON availabilities."listing_id" = listings."id"
WHERE
    availabilities."date" LIKE '2023-06-%'
    AND availabilities."available" = 'TRUE'
GROUP BY
    listings."id";