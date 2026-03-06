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