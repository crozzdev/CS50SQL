# Design Document

By Juan David Toro Velez a.k.a @crozzdev

Video overview: <URL HERE>

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

At this iteration, the system will not support users creating sub-accounts, tracking investments or credit scores. Also the conversion rates for different currencies will be fixed and not updated in real time, as the focus of this database is on representing transactions, budgets, and accounts rather than providing real-time currency conversion. I am also only coverying USD, EUR, and COP as the supported currencies, given that these are the most commonly used currencies among the target user base for this application.

## Representation

### Entities

In this section you should answer the following questions:

The database includes the following entities:

#### Banks

The `banks` table includes:

- `id`, which specifies the unique ID for the bank as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `name`, which specifies the name of the bank as `TEXT`.
- `country`, which specifies the country of the bank as `TEXT`.

#### Currencies

The `currencies` table includes:

- `id`, which specifies the unique ID for the currency as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `code`, which specifies the currency code as `TEXT`, such as USD, EUR, COP. A `UNIQUE` constraint ensures no two currencies have the same code.
- `symbol`, which specifies the currency symbol as `TEXT`, such as $, €, or ₩. A UNIQUE constraint ensures no two currencies have the same symbol.

#### Currency Conversion Rates

The `currency_conversion_rates` table includes:

- `id`, which specifies the unique ID for the currency conversion rate as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `from_currency_id`, which specifies the ID of the source currency as an `INTEGER`,with a `FOREIGN KEY` constraint referencing the `currencies` table to maintain referential integrity.
- `to_currency_id`, which specifies the ID of the target currency as an `INTEGER`,with a `FOREIGN KEY` constraint referencing the `currencies` table to maintain referential integrity.
- `rate`, which specifies the conversion rate as a `NUMERIC (10, 2)`, given that conversion rates can involve decimal values.

#### Accounts

The `accounts` table includes:

- `id`, which specifies the unique ID for the account as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `name`, which specifies the name of the account as `TEXT`.
- `type`, which specifies the type of the account as `TEXT`, allowing for flexible categorization to indicate whether the account is a checking, savings, credit card, etc.
- `balance`, which specifies the balance of the account as a `NUMERIC (10, 2)`, given that account balances can involve decimal values. It must be greater than or equal to zero, as indicated by the `CHECK (balance >= 0)` constraint.
- `bank_id`, which specifies the ID of the associated bank as an `INTEGER`, with a `FOREIGN KEY` constraint referencing the `banks` table to maintain referential integrity.

#### Transactions

The `transactions` table includes:

- `id`, which specifies the unique ID for the transaction as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `title`, which specifies the title of the transaction as `TEXT`.
- `description`, which specifies the description of the transaction as `TEXT`, allowing for a more detailed explanation of the transaction.
- `amount`, which specifies the amount of the transaction as a `NUMERIC (10, 2)`, given that transactions can involve decimal values.
- `date`, which specifies the date of the transaction as `TEXT`, given that SQLite does not have a dedicated date type and `TEXT` can be used to store date strings in a consistent format.
- `type`, which specifies the type of the transaction as `TEXT`, allowing for flexible categorization to indicate whether the transaction is an income or an expense.
- `tags`, which specifies the tags associated with the transaction as `TEXT`, allowing for flexible categorization and filtering of transactions based on user-defined tags.
- `account_id`, which specifies the ID of the associated account as an `INTEGER`, with a `FOREIGN KEY` constraint referencing the `accounts` table to maintain referential integrity.
- `currency_id`, which specifies the ID of the associated currency as an `INTEGER`, with a `FOREIGN KEY` constraint referencing the `currencies` table to maintain referential integrity.

#### Budgets

The `budgets` table includes:

- `id`, which specifies the unique ID for the budget as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
- `title`, which specifies the title of the budget as `TEXT`.
- `description`, which specifies the description of the budget as `TEXT`, allowing for a more detailed explanation of the budget.
- `amount`, which specifies the amount of the budget as a `NUMERIC (10, 2)`, given that budgets can involve decimal values.
- `start_date`, which specifies the start date of the budget as `NUMERIC`, given that SQLite can store timestamps as numeric values. The default value for the `start_date` attribute is the current timestamp, as denoted by `DEFAULT CURRENT_TIMESTAMP`.
- `end_date`, which specifies the end date of the budget as `NUMERIC`, given that SQLite can store timestamps as numeric values. This cannot be null or less than the `start_date`, as indicated by the `NOT NULL` and `CHECK (end_date >= start_date)` constraints.
- `account_id`, which specifies the ID of the associated account as an `INTEGER`, with a `FOREIGN KEY` constraint referencing the `accounts` table to maintain referential integrity.

### Relationships

In this section you should include your entity relationship diagram and describe the relationships between the entities in your database.

## Optimizations

In this section you should answer the following questions:

- Which optimizations (e.g., indexes, views) did you create? Why?

## Limitations

In this section you should answer the following questions:

- The current scheme does not support tracking of the balance of the account when creating budgets or transactions, which means that the balance of the account will not be updated when a new transaction or budget is created. For this, the proposed solution is to create triggers that update the balance of the account whenever a new transaction or budget is created, updated, or deleted. This would ensure that the balance of the account is always accurate and up-to-date.

- Implementing this database in a more robust RDBMS like PostgreSQL would allow for more complex constraints and data types, such as a dedicated date type for the `date`, `start_date`, and `end_date` attributes, which would improve data integrity and make it easier to perform date-related queries. Additionally, it would also implement the ACID properties more robustly, which would permit transactions to happen that solve the issue of keeping the account balance up to date when creating, updating, or deleting transactions and budgets.

- Finally, as already mentioned in the scope, the database does not support real-time currency conversion, which means that the conversion rates for different currencies will be fixed and not updated in real time. This is a limitation because currency conversion rates can fluctuate frequently, and having fixed rates may not accurately reflect the current value of transactions and budgets in different currencies. A potential solution to this limitation would be to integrate an external API in the application layer that provides real-time currency conversion rates, allowing the database to update the conversion rates automatically and ensure that the values of transactions and budgets are always accurate.
