-- Active: 1769565269472@@127.0.0.1@3306
SELECT "year", ROUND(AVG("salary"), 2) AS "Average Salary"
FROM salaries
GROUP BY
    "year"
ORDER BY "year" DESC;