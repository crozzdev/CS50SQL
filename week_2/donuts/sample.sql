-- Insert ingredients
INSERT INTO ingredients ("name", "unit", "price_per_unit")
VALUES ('Cocoa', 'pound', 5.00);

INSERT INTO ingredients ("name", "unit", "price_per_unit")
VALUES ('Sugar', 'pound', 2.00);

INSERT INTO ingredients ("name", "unit", "price_per_unit")
VALUES ('Flour', 'pound', 1.00);  -- Price not specified, using placeholder

INSERT INTO ingredients ("name", "unit", "price_per_unit")
VALUES ('Buttermilk', 'pound', 3.00);  -- Price not specified, using placeholder

INSERT INTO ingredients ("name", "unit", "price_per_unit")
VALUES ('Sprinkles', 'pound', 4.00);  -- Price not specified, using placeholder

-- Insert donuts
INSERT INTO donuts ("name", "is_gluten_free", "price_per_donut")
VALUES ('Belgian Dark Chocolate', 0, 4.00);

INSERT INTO donuts ("name", "is_gluten_free", "price_per_donut")
VALUES ('Back-To-School Sprinkles', 0, 4.00);

-- Link ingredients to Belgian Dark Chocolate donut
-- Assuming ingredient IDs: Cocoa=1, Sugar=2, Flour=3, Buttermilk=4, Sprinkles=5
-- Assuming donut ID: Belgian Dark Chocolate=1
INSERT INTO donut_ingredient ("donut_id", "ingredient_id", "quantity")
VALUES (1, 1, 1);  -- Belgian Dark Chocolate uses 1 unit of Cocoa

INSERT INTO donut_ingredient ("donut_id", "ingredient_id", "quantity")
VALUES (1, 3, 1);  -- Belgian Dark Chocolate uses 1 unit of Flour

INSERT INTO donut_ingredient ("donut_id", "ingredient_id", "quantity")
VALUES (1, 4, 1);  -- Belgian Dark Chocolate uses 1 unit of Buttermilk

INSERT INTO donut_ingredient ("donut_id", "ingredient_id", "quantity")
VALUES (1, 2, 1);  -- Belgian Dark Chocolate uses 1 unit of Sugar

-- Link ingredients to Back-To-School Sprinkles donut
-- Assuming donut ID: Back-To-School Sprinkles=2
INSERT INTO donut_ingredient ("donut_id", "ingredient_id", "quantity")
VALUES (2, 3, 1);  -- Back-To-School Sprinkles uses 1 unit of Flour

INSERT INTO donut_ingredient ("donut_id", "ingredient_id", "quantity")
VALUES (2, 4, 1);  -- Back-To-School Sprinkles uses 1 unit of Buttermilk

INSERT INTO donut_ingredient ("donut_id", "ingredient_id", "quantity")
VALUES (2, 2, 1);  -- Back-To-School Sprinkles uses 1 unit of Sugar

INSERT INTO donut_ingredient ("donut_id", "ingredient_id", "quantity")
VALUES (2, 5, 1);  -- Back-To-School Sprinkles uses 1 unit of Sprinkles

-- Insert customer
INSERT INTO customers ("first_name", "last_name")
VALUES ('Luis', 'Singh');

-- Insert order
-- Assuming customer ID: Luis Singh=1
INSERT INTO orders ("customer_id", "order_number")
VALUES (1, 1);

-- Link donuts to order
-- Assuming order ID=1, Belgian Dark Chocolate=1, Back-To-School Sprinkles=2
INSERT INTO donut_order ("donut_id", "order_id", "quantity")
VALUES (1, 1, 3);  -- 3 Belgian Dark Chocolate donuts

INSERT INTO donut_order ("donut_id", "order_id", "quantity")
VALUES (2, 1, 2);  -- 2 Back-To-School Sprinkles donuts