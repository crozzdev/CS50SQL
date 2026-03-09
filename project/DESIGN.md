# Design Document

By Juan David Toro Velez a.k.a @crozzdev

Video overview: <https://www.youtube.com/watch?v=utZkApeLwhw>

## Scope

In this section you should answer the following questions:

The purpose of this database is to represent transactions, budgets, and accounts for a personal finance application in multiple currencies. The database will allow users to track their income and expenses, set budgets or pockets, and manage their financial accounts. As such, included in the database's scope is:

- Transactions, including the amount, date, category, and associated account
- Budgets, including the amount, date range, and associated account
- Accounts, including the name, type, and balance
- Banks associated with accounts, including the bank name and country
- Currencies associated with accounts, including the currency code and symbol

Out of scope are elements like investment tracking, credit scores, and other non-core attributes.

## Functional Requirements

This database will support :

- CRUD operations for transactions, budgets, and accounts.
- Tracking all versions of transactions, including multiple transactions for the same account
- Adding multiple budgets to an account

At this iteration, the system will not support users creating sub-accounts, tracking investments or credit scores. Also the conversion rates for different currencies will be fixed and not updated in real time, as the focus of this database is on representing transactions, budgets, and accounts rather than providing real-time currency conversion. I am also only coverying only USD, EUR, and COP as the supported currencies, given that these are the most commonly used currencies among the target user base for this application.

## Representation

### Entities

In this section you should answer the following questions:

The database includes the following entities:

#### Users

The `users` table includes:

- `id`, which specifies the unique ID for the user as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `name`, which specifies the name of the user as `TEXT`.
- `email`, which specifies the email of the user as `TEXT`. A `UNIQUE` constraint ensures no two users have the same email.
- `password`, which specifies the password of the user as `TEXT`. In production, this should be stored as a hashed value for security reasons, but for the sake of simplicity in this design, it is stored as plain text.

#### Banks

The `banks` table includes:

- `id`, which specifies the unique ID for the bank as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `name`, which specifies the name of the bank as `TEXT`. This has the `UNIQUE` constraint so we avoid having two banks with the same name.
- `country`, which specifies the country of the bank as `TEXT`.

All the columns in the `banks` table are required and hence should have the `NOT NULL` constraint applied. No other constraints are necessary.

#### Currencies

The `currencies` table includes:

- `id`, which specifies the unique ID for the currency as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `code`, which specifies the currency code as `TEXT`, such as USD, EUR, COP. A `UNIQUE` constraint ensures no two currencies have the same code.
- `symbol`, which specifies the currency symbol as `TEXT`, such as $, €, or ₩. A `UNIQUE` constraint ensures no two currencies have the same symbol.

All the columns in the `currencies` table are required and hence should have the `NOT NULL` constraint applied. No other constraints are necessary.

#### Currency Conversion Rates

The `currency_conversion_rates` table serves as a junction table to associate currencies with their conversion rates:

- `from_currency_id`, which specifies the ID of the source currency as an `INTEGER`, with a `FOREIGN KEY` constraint referencing the `currencies` table to maintain referential integrity.
- `to_currency_id`, which specifies the ID of the target currency as an `INTEGER`, with a `FOREIGN KEY` constraint referencing the `currencies` table to maintain referential integrity
-(`from_currency_id`, `to_currency_id`), which specifies the IDs of the source and target currencies as `INTEGER`s, they serve as a composite `PRIMARY KEY` to ensure that there is only one conversion rate for each pair of currencies.
- `rate`, which specifies the conversion rate as a `NUMERIC (10, 6)`, given that conversion rates can involve decimal values. This also must no be less than or equal to zero, as indicated by the `CHECK (rate > 0)` constraint.

#### Tags

The `tags` table includes:

- `id`, which specifies the unique ID for the tag as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `name`, which specifies the name of the tag as `TEXT`. A `UNIQUE` constraint ensures no two tags have the same name. Also the `NOT NULL` constraint is applied to ensure that every tag has a name.

#### Transaction Tags

The `transaction_tags` table serves as a junction table to associate transactions with tags:

- `transaction_id`, which specifies the ID of the associated transaction as an `INTEGER`, with a `FOREIGN KEY` constraint referencing the `transactions` table to maintain referential integrity.
- `tag_id`, which specifies the ID of the associated tag as an `INTEGER`, with a `FOREIGN KEY` constraint referencing the `tags` table to maintain referential integrity.
- (`transaction_id`, `tag_id`), which specifies the IDs of the associated transaction and tag as `INTEGER`s, they serve as a composite `PRIMARY KEY` to ensure that each transaction can only be associated with a specific tag once.

#### Accounts

The `accounts` table includes:

- `id`, which specifies the unique ID for the account as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `name`, which specifies the name of the account as `TEXT`.
- `type`, which specifies the type of the account as `TEXT`, allowing for flexible categorization to indicate whether the account is a checking, savings, credit card. We check that the value of this column is either one of the previous values using the `CHECK (type IN ('savings', 'checking','credit card'))` constraint.
- `balance`, which specifies the balance of the account as a `NUMERIC (10, 2)`, given that account balances can involve decimal values. It must be greater than or equal to zero, as indicated by the `CHECK (balance >= 0)` constraint.
- `bank_id`, which specifies the ID of the associated bank as an `INTEGER`, with a `FOREIGN KEY` constraint referencing the `banks` table to maintain referential integrity.
- `currency_id`, which specifies the ID of the associated currency as an `INTEGER`, with a `FOREIGN KEY` constraint referencing the `currencies` table to maintain referential integrity.
- `user_id`, which specifies the ID of the associated user as an `INTEGER`, with a `FOREIGN KEY` constraint referencing the `users` table to maintain referential integrity.

All columns in the `accounts` table are required and hence should have the `NOT NULL` constraint applied where a `PRIMARY KEY` or `FOREIGN KEY` constraint is not. Other constraint needed is the `UNIQUE` at table level for `name` and `user_id` to ensure that a user cannot have two accounts with the same name.

#### Transactions

The `transactions` table includes:

- `id`, which specifies the unique ID for the transaction as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `title`, which specifies the title of the transaction as `TEXT`. This must not be null, as indicated by the `NOT NULL` constraint, to ensure that every transaction has a title.
- `description`, which specifies the description of the transaction as `TEXT`, allowing for a more detailed explanation of the transaction. This can be optional, as not every transaction may require a description, so it does not have the `NOT NULL` constraint applied.
- `amount`, which specifies the amount of the transaction as a `NUMERIC (10, 2)`, given that transactions can involve decimal values. It must be greater than zero, as indicated by the `CHECK (amount > 0)` constraint, to ensure that transactions have a positive amount.
- `date`, which specifies the date of the transaction as `NUMERIC`, given that SQLite can store timestamps as numeric values. The default value for the `date` attribute is the current timestamp, as denoted by `DEFAULT CURRENT_TIMESTAMP`.
- `type`, which specifies the type of the transaction as `TEXT`, allowing for flexible categorization to indicate whether the transaction is an income or an expense. We check that the value of this column is either 'income' or 'expense' using the `CHECK (type IN ('income', 'expense'))` constraint.
- `account_id`, which specifies the ID of the associated account as an `INTEGER`, with a `FOREIGN KEY` constraint referencing the `accounts` table to maintain referential integrity.
- `currency_id`, which specifies the ID of the associated currency as an `INTEGER`, with a `FOREIGN KEY` constraint referencing the `currencies` table to maintain referential integrity.

#### Budgets

The `budgets` table includes:

- `id`, which specifies the unique ID for the budget as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `title`, which specifies the title of the budget as `TEXT`.This must not be null, as indicated by the `NOT NULL` constraint, to ensure that every budget has a title and `UNIQUE` so we don't have more than one budget with the same name.
- `description`, which specifies the description of the budget as `TEXT`, allowing for a more detailed explanation of the budget. This can be optional, as not every budget may require a description, so it does not have the `NOT NULL` constraint applied.
- `amount`, which specifies the amount of the budget as a `NUMERIC (10, 2)`, given that budgets can involve decimal values.I also check that the amount is greater than zero using the `CHECK (amount > 0)` constraint, to ensure that budgets have a positive amount.
- `start_date`, which specifies the start date of the budget as `NUMERIC`, given that SQLite can store timestamps as numeric values. The default value for the `start_date` attribute is the current timestamp, as denoted by `DEFAULT CURRENT_TIMESTAMP`.
- `end_date`, which specifies the end date of the budget as `NUMERIC`, given that SQLite can store timestamps as numeric values. This cannot be null or less than the `start_date`, as indicated by the `NOT NULL` and `CHECK (end_date >= start_date)` constraints.
- `account_id`, which specifies the ID of the associated account as an `INTEGER`, with a `FOREIGN KEY` constraint referencing the `accounts` table to maintain referential integrity.

### Relationships

The below entity relationship diagram describes the relationships among the entities in the database.

![ER Diagram](CS50SQL_FinalProject_scheme.png)

As detailed by the diagram:

- A transaction belongs to one account, and an account can have many transactions.
- A transaction also belongs to one currency, and a currency can be associated with many transactions.
- A transaction can have many tags, and a tag can be associated with many transactions through the `transaction_tags` junction table.
- A budget also belongs to one account, and an account can have many budgets. The currency for the budget is determined by the account's currency.
- An account belongs to one bank, and a bank can have many accounts.
- An account also belongs to one currency, and a currency can be associated with many accounts.
- A currency conversion rate is defined for a pair of currencies, and each currency can have many conversion rates to other currencies through the `currency_conversion_rates` junction table.
- A transaction may be recorded in a currency different from its account's base currency. The conversion rate table is used to resolve the balance update. Budgets, however, are always denominated in the account's currency.
- Finally, a user can have many accounts, but an account belongs to only one user.

## Optimizations

To improve query performance for the most frequent access patterns in the
application, the following indexes are defined:

### `idx_transactions_account_date`

A composite index on `transactions (account_id, date)`. This is the most
important index in the schema, as the most frequent query pattern is
fetching transactions for a specific account filtered or sorted by date,
such as "show me all transactions for this account in the last 30 days".
The composite index serves both account-only lookups (using the leftmost
column) and account + date range lookups efficiently. This index also makes a standalone `account_id` index redundant, as SQLite can use the leftmost column of a composite index for single-column lookups.

### `idx_accounts_user_id`

An index on `accounts (user_id)`. Every time the application loads a user's
accounts — which happens on virtually every screen — this index is hit.
Without it, the database would scan all accounts to find those belonging to
a specific user.

### `idx_budgets_account_id`

An index on `budgets (account_id)`. Budget queries are always scoped to a
specific account, making this index essential for the budget tracking
feature.

### `idx_transaction_tags_tag_id`

An index on `transaction_tags (tag_id)`. The primary key on `transaction_tags`
already implicitly indexes `(transaction_id, tag_id)`, covering lookups in
the direction of "give me all tags for a transaction". This additional index
covers the opposite direction — "give me all transactions for a given tag"
— which is needed to support tag-based filtering of transactions. A
composite index was not used here because both query directions need to be
served independently.

### Indexes Deliberately Omitted

The following indexes were considered but intentionally left out:

- `transactions (currency_id)` — transactions are never queried by currency directly. Currency is resolved after fetching transactions by account.
- `accounts (bank_id)` — bank is a display attribute on accounts, not a
  filter criterion in typical application queries.
- `accounts (currency_id)` — same reasoning as bank; currency on an account is resolved at display time, not used to filter accounts.

## Limitations

- The current scheme does not support tracking of the balance of the account when creating budgets or transactions, which means that the balance of the account will not be updated when a new transaction or budget is created. For this, the proposed solution is to create triggers that update the balance of the account whenever a new transaction or budget is created, updated, or deleted. This would ensure that the balance of the account is always accurate and up-to-date.

- Implementing this database in a more robust RDBMS like PostgreSQL would allow for more complex constraints and data types, such as a dedicated date type for the `date`, `start_date`, and `end_date` attributes, which would improve data integrity and make it easier to perform date-related queries. Additionally, it would also implement the ACID properties more robustly, which would permit transactions to happen that solve the issue of keeping the account balance up to date when creating, updating, or deleting transactions and budgets.

- Finally, as already mentioned in the scope, the database does not support real-time currency conversion, which means that the conversion rates for different currencies will be fixed and not updated in real time. This is a limitation because currency conversion rates can fluctuate frequently, and having fixed rates may not accurately reflect the current value of transactions and budgets in different currencies. A potential solution to this limitation would be to integrate an external API in the application layer that provides real-time currency conversion rates, allowing the database to update the conversion rates automatically and ensure that the values of transactions and budgets are always accurate.

## Triggers

To maintain data integrity and keep account balances accurate automatically, the database implements a set of triggers grouped into three categories:
budget triggers, transaction validation, and transaction balance triggers.

### Budget Triggers

#### `check_budget_amount`

Fires **BEFORE INSERT** on `budgets`. Raises an abort error if the budget amount exceeds the current balance of the associated account. Since budgets
are always denominated in the account's currency, no currency conversion is needed.

#### `update_balance_amount_insert_budget`

Fires **AFTER INSERT** on `budgets`. Deducts the budget amount from the associated account's balance, reserving those funds for the budget.

#### `update_balance_amount_update_budget`

Fires **AFTER UPDATE** on `budgets`. Adjusts the account balance by the delta between the old and new budget amounts using the formula `balance - (NEW.amount - OLD.amount)`, ensuring only the difference is applied rather than reversing and reapplying the full amount.

#### `update_balance_amount_deleted_budget`

Fires **AFTER DELETE** on `budgets`. Restores the budget amount back to the associated account's balance, as the reserved funds are no longer committed.

### Transaction Triggers

#### `check_balance_amount`

Fires **BEFORE INSERT** on `transactions`. Only applies to expense transactions. Raises an abort error if the transaction amount would exceed the account's current balance. Handles both same-currency and different-currency cases — for the latter, it converts the transaction amount using the corresponding rate from the `conversion_rates` table before comparing against the balance.

#### `update_balance_amount_income_insert`

Fires **AFTER INSERT** on `transactions`. Applies to income transactions in the **same currency** as the account. Adds the transaction amount directly
to the account balance.

#### `update_balance_amount_expense_insert`

Fires **AFTER INSERT** on `transactions`. Applies to expense transactions in the **same currency** as the account. Deducts the transaction amount from
the account balance.

#### `update_balance_amount_income_insert_different_currency`

Fires **AFTER INSERT** on `transactions`. Applies to income transactions in a **different currency** than the account. Converts the transaction amount
using the rate from `conversion_rates` and adds the converted value to the account balance.

#### `update_balance_amount_expense_insert_different_currency`

Fires **AFTER INSERT** on `transactions`. Applies to expense transactions in a **different currency** than the account. Converts the transaction amount
using the rate from `conversion_rates` and deducts the converted value from the account balance.

#### `update_balance_amount_income_delete`

Fires **AFTER DELETE** on `transactions`. Reverses a previously recorded income in the **same currency** by deducting the amount from the account
balance.

#### `update_balance_amount_income_delete_different_currency`

Fires **AFTER DELETE** on `transactions`. Reverses a previously recorded income in a **different currency** by converting the amount and deducting
it from the account balance.

#### `update_balance_amount_expense_delete`

Fires **AFTER DELETE** on `transactions`. Reverses a previously recorded expense in the **same currency** by restoring the amount to the account
balance.

#### `update_balance_amount_expense_delete_different_currency`

Fires **AFTER DELETE** on `transactions`. Reverses a previously recorded expense in a **different currency** by converting the amount and restoring
it to the account balance.

#### `update_balance_on_transaction_update`

Fires **AFTER UPDATE** on `transactions`. This is the most comprehensive trigger, handling all possible update scenarios including changes to amount,
type (income/expense), and currency simultaneously. It applies a two-step
formula:

1. **Reverse the OLD transaction** — undoes the effect of the original transaction on the balance, accounting for its original type and currency.
2. **Apply the NEW transaction** — applies the updated transaction to the balance, accounting for its new type and currency.

Both steps use a `CASE` expression to handle same-currency and different-currency scenarios independently, with an `ELSE 0` fallback to prevent NULL propagation. This single trigger replaces what would otherwise require multiple triggers to cover every combination of field changes.

### Design Rationale

Encapsulating balance logic in triggers rather than the application layer provides two key guarantees. First, **consistency** — the balance is always updated correctly regardless of how or where a transaction or budget is created, whether through the application, a script, or direct SQL access.
Second, **atomicity** — the balance update executes within the same database transaction as the INSERT, UPDATE, or DELETE, so it is impossible for a transaction to be recorded without its corresponding balance adjustment.

An additional reason for choosing stored balance with triggers over a computed view is **validation performance**. Both the `check_budget_amount` and `check_balance_amount` triggers need to verify that the account has sufficient funds before allowing an INSERT. With a stored `balance` column this is a single, fast lookup against an indexed primary key. With a computed view, every validation would require aggregating the entire transaction history for that account on each INSERT, an operation that grows slower as the number of transactions increases. By storing the balance and keeping it synchronized through triggers, the database pays the synchronization cost once at write time and keeps all validations cheap and constant regardless of how large the transaction history becomes. This is the same reasoning behind how real-world banking systems maintain a running balance rather than recomputing it from the full ledger on every operation.
