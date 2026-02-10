CREATE TABLE IF NOT EXISTS ingredients (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "unit" TEXT NOT NULL,
    "price_per_unit" NUMERIC NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS donuts (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "is_gluten_free" INTEGER NOT NULL CHECK ("is_gluten_free" IN (0, 1)),
    "price_per_donut" NUMERIC NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS customers (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS orders (
    "id" INTEGER,
    "customer_id" INTEGER,
    "order_number" INTEGER NOT NULL UNIQUE,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("customer_id") REFERENCES customers("id")
);

CREATE TABLE IF NOT EXISTS donut_order (
    "donut_id" INTEGER,
    "order_id" INTEGER,
    "quantity" NUMERIC NOT NULL CHECK ("quantity" > 0),
    PRIMARY KEY ("donut_id","order_id"),
    FOREIGN KEY ("donut_id") REFERENCES donuts("id"),
    FOREIGN KEY ("order_id") REFERENCES orders("id")
);

CREATE TABLE IF NOT EXISTS donut_ingredient (
    "donut_id" INTEGER,
    "ingredient_id" INTEGER,
    "quantity" INTEGER NOT NULL CHECK("quantity" > 0),
    PRIMARY KEY ("donut_id","ingredient_id"),
    FOREIGN KEY ("donut_id") REFERENCES donuts("id"),
    FOREIGN KEY ("ingredient_id") REFERENCES ingredients("id")
);