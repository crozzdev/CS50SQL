-- =====================
-- USERS
-- =====================
INSERT INTO
    "users" ("name", "email", "password")
VALUES (
        'Juan',
        'juan@example.com',
        'password'
    ),
    (
        'Natalia',
        'nata@example.com',
        'password2'
    );

-- =====================
-- BANKS
-- =====================
INSERT INTO
    "banks" ("name", "country")
VALUES ('Davivienda', 'Colombia'),
    ('Bancolombia', 'Colombia'),
    (
        'Bank of America',
        'United States'
    );

-- =====================
-- CURRENCIES
-- =====================
INSERT INTO
    "currencies" ("code", "symbol")
VALUES ('USD', '$'),
    ('EUR', '€'),
    ('COP', 'Col$');
-- Col$ to avoid UNIQUE conflict with USD $

-- =====================
-- CONVERSION RATES (as of March 8, 2026)
-- =====================
INSERT INTO
    "conversion_rates" (
        "from_currency_id",
        "to_currency_id",
        "rate"
    )
VALUES
    -- USD conversions
    (1, 2, 0.850000), -- USD → EUR
    (1, 3, 3811.000000), -- USD → COP
    -- EUR conversions
    (2, 1, 1.176000), -- EUR → USD
    (2, 3, 4402.000000), -- EUR → COP
    -- COP conversions
    (3, 1, 0.000262), -- COP → USD
    (3, 2, 0.000227);
-- COP → EUR

-- =====================
-- TAGS
-- =====================
INSERT INTO
    "tags" ("name")
VALUES ('Food'),
    ('Entertainment'),
    ('Travel'),
    ('Debts'),
    ('Salary');

-- =====================
-- ACCOUNTS
-- =====================
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
        'savings_Juan',
        'savings',
        45000000.00,
        2,
        3,
        1
    ), -- Bancolombia, COP, Juan
    (
        'savings_nata',
        'savings',
        10000000.00,
        1,
        3,
        2
    ), -- Davivienda, COP, Natalia
    (
        'credit_card_Juan',
        'credit card',
        1000.00,
        3,
        1,
        1
    );
-- Bank of America, USD, Juan

-- =====================
-- TRANSACTIONS
-- =====================

-- Juan's transactions
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
VALUES
    -- January 2026: salary income into savings_Juan (COP)
    (
        'Salary January',
        'Monthly salary payment',
        9000000.00,
        '2026-01-31',
        'income',
        1,
        3
    ),
    -- February 2026: house loan expense from savings_Juan (COP)
    (
        'House Loan',
        'Monthly house loan payment',
        1000000.00,
        '2026-02-28',
        'expense',
        1,
        3
    ),
    -- March 2026: PS5 games expense on credit_card_Juan (USD)
    (
        'PS5 Games',
        'PlayStation games purchase',
        30.00,
        '2026-03-08',
        'expense',
        3,
        1
    );

-- Natalia's transactions
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
VALUES
    -- January 2026: salary income
    (
        'Salary January',
        'Monthly salary as medical resident',
        3500000.00,
        '2026-01-31',
        'income',
        2,
        3
    ),
    -- February 2026: grocery shopping
    (
        'Groceries',
        'Monthly grocery shopping at Exito',
        450000.00,
        '2026-02-15',
        'expense',
        2,
        3
    ),
    -- March 2026: travel booking
    (
        'Flight Booking',
        'Round trip flight for vacation',
        800000.00,
        '2026-03-01',
        'expense',
        2,
        3
    );

-- =====================
-- BUDGETS
-- =====================
INSERT INTO
    "budgets" (
        "title",
        "description",
        "amount",
        "start_date",
        "end_date",
        "account_id"
    )
VALUES
    -- Juan: house repair budget linked to savings_Juan
    (
        'House Repair',
        'Budget for home renovation expenses',
        1000000.00,
        '2026-03-01',
        '2026-06-30',
        1
    ),
    -- Natalia: medical residency budget linked to savings_nata
    (
        'Medical Residency',
        'Budget for medical residency program expenses',
        3000000.00,
        '2026-03-01',
        '2026-12-31',
        2
    ),
    -- Natalia: travel budget linked to savings_nata
    (
        'Travel Fund',
        'Budget for upcoming vacation travel',
        1000000.00,
        '2026-03-01',
        '2026-07-31',
        2
    );

-- =====================
-- TRANSACTION TAGS
-- =====================
INSERT INTO
    "transaction_tags" ("transaction_id", "tag_id")
VALUES
    -- Juan salary (id=1) → Salary(id=1)
    (1, 5),
    -- Juan house loan (id=2) → Debts (id=4)
    (2, 4),
    -- Juan PS5 games (id=3) → Entertainment (id=2)
    (3, 2),
    -- Natalia salary (id=4) → Salary(id=1)
    (4, 5),
    -- Natalia groceries (id=5) → Food (id=1)
    (5, 1),
    -- Natalia flight (id=6) → Travel (id=3)
    (6, 3);