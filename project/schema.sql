-- Represents the Banks linked to the accounts
CREATE TABLE "banks" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "country" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

-- Represents the currencies used in the accounts and transactions
CREATE TABLE "currencies" (
    "id" INTEGER,
    "code" TEXT NOT NULL UNIQUE,
    "symbol" TEXT NOT NULL UNIQUE,
    PRIMARY KEY ("id")
);

-- Represents the users in the application who own the accounts
CREATE TABLE "users" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

-- Represents the tags that can be linked to transactions
CREATE TABLE "tags" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    PRIMARY KEY ("id")
);

-- Represents the accounts that a user can own and want to keep track of
CREATE TABLE "accounts" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL CHECK (
        "type" IN (
            'savings',
            'checking',
            'credit card'
        )
    ),
    "balance" NUMERIC(10, 2) NOT NULL DEFAULT 0.0 CHECK ("balance" >= 0),
    "bank_id" INTEGER NOT NULL,
    "currency_id" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    UNIQUE ("name", "user_id"),
    PRIMARY KEY ("id"),
    FOREIGN KEY ("bank_id") REFERENCES "banks" ("id") FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id"),
    FOREIGN KEY ("user_id") REFERENCES "users" ("id")
);

-- Represents the transactions a user can make which are linked to certain account and currency
CREATE TABLE "transactions" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "amount" NUMERIC(10, 2) NOT NULL CHECK ("amount" > 0),
    "date" NUMERIC DEFAULT CURRENT_TIMESTAMP,
    "type" TEXT CHECK (
        "type" IN ('income', 'expense')
    ),
    "account_id" INTEGER NOT NULL,
    "currency_id" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("account_id") REFERENCES "accounts" ("id"),
    FOREIGN KEY ("currency_id") REFERENCES "currencies" ("id")
);

-- Represents the budgets a user can plan that is associated to an account
CREATE TABLE "budgets" (
    "id" INTEGER,
    "title" TEXT NOT NULL UNIQUE,
    "description" TEXT,
    "amount" NUMERIC(10, 2) NOT NULL CHECK ("amount" > 0),
    "start_date" NUMERIC DEFAULT CURRENT_TIMESTAMP,
    "end_date" NUMERIC CHECK ("end_date" > "start_date"),
    "account_id" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("account_id") REFERENCES "accounts" ("id")
);

-- Represents the conversion rates for the different currencies supported in the application
CREATE TABLE "conversion_rates" (
    "from_currency_id" INTEGER,
    "to_currency_id" INTEGER,
    "rate" NUMERIC(10, 6) NOT NULL CHECK ("rate" > 0),
    PRIMARY KEY (
        "from_currency_id",
        "to_currency_id"
    ),
    FOREIGN KEY ("from_currency_id") REFERENCES "currencies" ("id"),
    FOREIGN KEY ("to_currency_id") REFERENCES "currencies" ("id")
);

-- Represents the tags a transaction can have associated to

CREATE TABLE "transaction_tags" (
    "transaction_id" INTEGER,
    "tag_id" INTEGER,
    PRIMARY KEY ("transaction_id", "tag_id"),
    FOREIGN KEY ("transaction_id") REFERENCES "transactions" ("id"),
    FOREIGN KEY ("tag_id") REFERENCES "tags" ("id")
);

-- VIEW SECTION

-- View that shows all the accounts of all the users with their balance and the corresponding bank and currency
CREATE VIEW "all accounts and balance" AS 
SELECT users."name" AS "user name", accounts."name" AS "account name", accounts."balance",currencies."code" AS "account currency", accounts."type" AS "account type", banks."name" AS "bank" FROM users
JOIN accounts ON accounts."user_id" = users."id"
JOIN currencies ON accounts."currency_id" = currencies."id"
JOIN banks ON banks."id" = accounts."bank_id"
ORDER BY users."name";

-- View that shows all the transactions of all the users with the corresponding account, bank, currency and tags
CREATE VIEW "all transactions and tags" AS
SELECT transactions."title", transactions."description", transactions."amount", currencies."code" AS "currency",transactions."date", transactions."type", GROUP_CONCAT(tags."name", ', ') AS "Tags", accounts."name" AS "Account", accounts."type" AS "Account type" FROM transactions
JOIN currencies ON currencies."id" = transactions."currency_id"
LEFT JOIN transaction_tags ON transaction_tags."transaction_id" = transactions."id"
LEFT JOIN tags ON tags."id" = transaction_tags."tag_id"
JOIN accounts ON accounts."id" = transactions."account_id"
GROUP BY transactions."id"
ORDER BY  accounts."name", transactions."date";

-- Index section

-- This index optimizes the query that shows all the transactions of a user in a given period of time, a very common query in a financial tracking application
CREATE INDEX idx_transactions_account_date ON "transactions" ("account_id", "date");

-- This index optimizes the query that shows all the accounts of a user, which is one of the most common queries in the application
CREATE INDEX idx_accounts_user_id ON "accounts" ("user_id");

-- This index optimizes the query that shows the budgets of an account
CREATE INDEX idx_budgets_account_id ON "budgets" ("account_id");

-- This index optimizes the query that shows the transactions of a user with a given tag or tags, users will want to see all the transactions linked to a certain tag or combination of tags very often

CREATE INDEX idx_transaction_tags_tag_id ON "transaction_tags" ("tag_id");

-- TRIGGERS SECTION

-- Trigger that checks that is not possible to create budgets with values that exceed the account balance
CREATE TRIGGER check_budget_amount
BEFORE INSERT ON "budgets"
BEGIN
    SELECT RAISE(ABORT, 'Budget amount exceeds account balance')
    WHERE NEW.amount > (SELECT balance FROM accounts WHERE id = NEW.account_id);
END;

-- Trigger that updates account balance after an amount is inserted into a budget, budgets always have the same currency as the account they're linked to
CREATE TRIGGER update_balance_amount_insert_budget
AFTER INSERT ON "budgets"
BEGIN
    UPDATE "accounts"
    SET "balance" = "balance" - NEW."amount"  
    WHERE id = NEW."account_id";
END;

-- Trigger that updates account balance after an amount is updated in a budget
CREATE TRIGGER update_balance_amount_update_budget
AFTER UPDATE ON "budgets"
BEGIN
    UPDATE "accounts"
    SET "balance" = "balance" - (NEW."amount" - OLD."amount")   
    WHERE id = OLD."account_id";
END;

-- Trigger that updates account balance after a budget is deleted
CREATE TRIGGER update_balance_amount_deleted_budget
AFTER DELETE ON "budgets"
BEGIN
    UPDATE "accounts"
    SET "balance" = "balance" + OLD."amount"  
    WHERE id = OLD."account_id";
END;

-- Trigger that checks that is not possible to transactions to happen if the amount exceed the account balance
CREATE TRIGGER check_balance_amount
BEFORE INSERT ON "transactions"
BEGIN
    SELECT RAISE(ABORT, 'Transaction amount exceeds account balance')
    WHERE ((
        -- same currency
        NEW."currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = NEW."account_id")
        AND NEW."amount" > (SELECT "balance" FROM "accounts" WHERE "id" = NEW."account_id")
    ) OR (
        -- different currency
        NEW."currency_id" != (SELECT "currency_id" FROM "accounts" WHERE "id" = NEW."account_id")
        AND NEW."amount" * (
            SELECT "rate" FROM "conversion_rates"
            WHERE "from_currency_id" = NEW."currency_id"
            AND "to_currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = NEW."account_id")
        ) > (SELECT "balance" FROM "accounts" WHERE "id" = NEW."account_id")
    ) AND NEW."type" = 'expense');
END;

-- Trigger that updates balance in the account after a transaction happens and it's an income in the same currency
CREATE TRIGGER update_balance_amount_income_insert
AFTER INSERT ON "transactions"
BEGIN
    UPDATE "accounts"
    SET "balance" = "balance" + NEW."amount"  
    WHERE id = NEW."account_id" AND NEW."type" = 'income' AND NEW."currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = NEW."account_id");
END;

-- Trigger that updates balance in the account after a transaction happens and it's an expense in the same currency
CREATE TRIGGER update_balance_amount_expense_insert
AFTER INSERT ON "transactions"
BEGIN
    UPDATE "accounts"
    SET "balance" = "balance" - NEW."amount"  
    WHERE id = NEW."account_id" AND NEW."type" = 'expense' AND NEW."currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = NEW."account_id");
END;

-- Trigger that updates balance in the account after a transaction happens and it's an income in a differente currency than the account's
CREATE TRIGGER update_balance_amount_income_insert_different_currency
AFTER INSERT ON "transactions"
BEGIN
    UPDATE "accounts"
    SET "balance" = "balance" + NEW."amount" * (SELECT "rate" FROM "conversion_rates" WHERE "from_currency_id" = NEW."currency_id" AND "to_currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = NEW."account_id" ))  
    WHERE id = NEW."account_id" AND NEW."type" = 'income' AND NEW."currency_id" != (SELECT "currency_id" FROM "accounts" WHERE "id" = NEW."account_id" );
END;

-- Trigger that updates balance in the account after a transaction happens and it's an expense in a differente currency than the account's
CREATE TRIGGER update_balance_amount_expense_insert_different_currency
AFTER INSERT ON "transactions"
BEGIN
    UPDATE "accounts"
    SET "balance" = "balance" - NEW."amount" * (SELECT "rate" FROM "conversion_rates" WHERE "from_currency_id" = NEW."currency_id" AND "to_currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = NEW."account_id" ))  
    WHERE id = NEW."account_id" AND NEW."type" = 'expense' AND NEW."currency_id" != (SELECT "currency_id" FROM "accounts" WHERE "id" = NEW."account_id" );
END;

-- Trigger that updates balance in the account after a transaction is deleted and it's an income in the same currency
CREATE TRIGGER update_balance_amount_income_delete
AFTER DELETE ON "transactions"
BEGIN
    UPDATE "accounts"
    SET "balance" = "balance" - OLD."amount"  
    WHERE id = OLD."account_id" AND OLD."type" = 'income' AND OLD."currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = OLD."account_id");
END;

-- Trigger that updates balance in the account after a transaction is deleted and it's an income in different currency
CREATE TRIGGER update_balance_amount_income_delete_different_currency
AFTER DELETE ON "transactions"
BEGIN
    UPDATE "accounts"
    SET "balance" = "balance" - OLD."amount"  *  (SELECT "rate" FROM "conversion_rates" WHERE "from_currency_id" = OLD."currency_id" AND "to_currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = OLD."account_id" ))
    WHERE id = OLD."account_id" AND OLD."type" = 'income' AND OLD."currency_id" != (SELECT "currency_id" FROM "accounts" WHERE "id" = OLD."account_id");
END;

-- Trigger that updates balance in the account after a transaction is deleted and it's an expense in the same currency
CREATE TRIGGER update_balance_amount_expense_delete
AFTER DELETE ON "transactions"
BEGIN
    UPDATE "accounts"
    SET "balance" = "balance" + OLD."amount"
    WHERE id = OLD."account_id" AND OLD."type" = 'expense' AND OLD."currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = OLD."account_id");

END;

-- Trigger that updates balance in the account after a transaction is deleted and it's an expense in different currency
CREATE TRIGGER update_balance_amount_expense_delete_different_currency
AFTER DELETE ON "transactions"
BEGIN
    UPDATE "accounts"
    SET "balance" = "balance" + OLD."amount"  *  (SELECT "rate" FROM "conversion_rates" WHERE "from_currency_id" = OLD."currency_id" AND "to_currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = OLD."account_id" ))
    WHERE id = OLD."account_id" AND OLD."type" = 'expense' AND OLD."currency_id" != (SELECT "currency_id" FROM "accounts" WHERE "id" = OLD."account_id");

END;

-- Trigger check the possible situations where updating a Transaction either changing the amount, type or even currency

CREATE TRIGGER update_balance_on_transaction_update
AFTER UPDATE ON "transactions"
BEGIN
    UPDATE "accounts"
    SET "balance" = "balance"
        -- Step 1: fully reverse the OLD transaction
        + CASE
            WHEN OLD."type" = 'income' AND OLD."currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = OLD."account_id")
                THEN -OLD."amount"
            WHEN OLD."type" = 'income' AND OLD."currency_id" != (SELECT "currency_id" FROM "accounts" WHERE "id" = OLD."account_id")
                THEN -OLD."amount" * (SELECT "rate" FROM "conversion_rates" WHERE "from_currency_id" = OLD."currency_id" AND "to_currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = OLD."account_id"))
            WHEN OLD."type" = 'expense' AND OLD."currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = OLD."account_id")
                THEN +OLD."amount"
            WHEN OLD."type" = 'expense' AND OLD."currency_id" != (SELECT "currency_id" FROM "accounts" WHERE "id" = OLD."account_id")
                THEN +OLD."amount" * (SELECT "rate" FROM "conversion_rates" WHERE "from_currency_id" = OLD."currency_id" AND "to_currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = OLD."account_id"))
            ELSE 0
        END
       
        -- Step 2: apply the NEW transaction
        + CASE
            WHEN NEW."type" = 'income' AND NEW."currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = NEW."account_id")
                THEN +NEW."amount"
            WHEN NEW."type" = 'income' AND NEW."currency_id" != (SELECT "currency_id" FROM "accounts" WHERE "id" = NEW."account_id")
                THEN +NEW."amount" * (SELECT "rate" FROM "conversion_rates" WHERE "from_currency_id" = NEW."currency_id" AND "to_currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = NEW."account_id"))
            WHEN NEW."type" = 'expense' AND NEW."currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = NEW."account_id")
                THEN -NEW."amount"
            WHEN NEW."type" = 'expense' AND NEW."currency_id" != (SELECT "currency_id" FROM "accounts" WHERE "id" = NEW."account_id")
                THEN -NEW."amount" * (SELECT "rate" FROM "conversion_rates" WHERE "from_currency_id" = NEW."currency_id" AND "to_currency_id" = (SELECT "currency_id" FROM "accounts" WHERE "id" = NEW."account_id"))
            ELSE 0
        END
        
    WHERE "id" = OLD."account_id";

END;