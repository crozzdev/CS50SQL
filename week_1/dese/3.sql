SELECT
    AVG(
        expenditures.per_pupil_expenditure
    ) AS "Average District Per-Pupil Expenditure"
FROM expenditures
    LEFT JOIN districts ON expenditures.district_id = districts.id