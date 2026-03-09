-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- Example queries for a personal finance application:

-- 1. Fetch all accounts for a user using their email
SELECT accounts."name" AS "Account", accounts."type" AS "Account Type",accounts."balance" ,currencies."code" AS "Account currency" ,banks."name" AS "Account Bank" FROM accounts
JOIN currencies ON currencies."id" = accounts."currency_id"
JOIN banks ON banks."id" = accounts."bank_id"
WHERE accounts."user_id" = (SELECT id FROM users WHERE "email" = 'juan@example.com')
ORDER BY "Account currency","Account";

-- 2. Fetch all expenses in certain dates for a user using their email, in this example juan and between jan and march 2026
SELECT transactions."title",transactions."description",transactions."amount", currencies."code" AS "currency", transactions."date"
FROM transactions
JOIN currencies ON currencies."id" = transactions."currency_id"
JOIN accounts on accounts."id" = transactions."account_id"
WHERE transactions."account_id" IN (
    SELECT id FROM accounts WHERE user_id = (
        SELECT id FROM users WHERE email = 'juan@example.com'
    )
)
AND transactions."date" BETWEEN '2026-01-01' AND '2026-03-31' AND transactions."type" = 'expense'
ORDER BY transactions."date" DESC;

-- 3. Fetch all transactions with a specific tag for a user using their email, in this example juan and the tag "Salary"
SELECT transactions."title",transactions."description",transactions."amount", currencies."code" AS "currency", transactions."date"
FROM transactions
JOIN currencies ON currencies."id" = transactions."currency_id"
JOIN accounts on accounts."id" = transactions."account_id"
JOIN transaction_tags ON transaction_tags."transaction_id" = transactions."id"
JOIN tags ON tags."id" = transaction_tags."tag_id"
WHERE transactions."account_id" IN (
    SELECT id FROM accounts WHERE user_id = (
        SELECT id FROM users WHERE email = 'juan@example.com'
    )
)
AND tags."name" = 'Salary'
ORDER BY transactions."date" DESC;

-- Add a new bank
INSERT INTO
    "banks" ("name", "country")
VALUES ('RappiPay España', 'Spain');

-- Add a new user
INSERT INTO
    "users" ("name", "email", "password")
VALUES (
        'Felipe',
        'felipe@example.com',
        'password3'
    );

-- Add a new account for a user

INSERT INTO
    "accounts" (
        "name",
        "type",
        "balance",
        "bank_id",
        "currency_id",
        "user_id"
    )
VALUES (
        'savings_Felipe',
        'savings',
        350000.00,
        4,
        2,
        3
    );

-- Add a new transaction for an account
INSERT INTO
    "transactions" (
        "title",
        "description",
        "amount",
        "date",
        "type",
        "account_id",
        "currency_id"
    )
VALUES (
        'Felipe salary',
        'Monthly salary from work',
        50000.00,
        '2024-06-01',
        'income',
        4,
        2
    );