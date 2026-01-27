-- Active: 1769445092887@@127.0.0.1@3306
-- *** The Lost Letter ***
-- I first need to confirm that the from and to addresses exist and the right name

-- I first check the from address
SELECT "id"
from "addresses"
WHERE
    "address" = '900 Somerville Avenue';

-- it exists, so I check now the to address. At first it wasn't showing up as "2 Finnegan Street" so I decided to use Like to find similars in the db. I found it with this query:
SELECT "id", "address"
FROM "addresses"
WHERE
    "address" LIKE '2 Finn%';

-- Turns out the right name was "2 Finnigan Street"

-- I can now know which is the package id of the letter:
SELECT "id"
FROM "packages"
WHERE
    "from_address_id" = (
        SELECT "id"
        FROM "addresses"
        WHERE
            "address" = '900 Somerville Avenue'
    )
    AND "to_address_id" = (
        SELECT "id"
        FROM "addresses"
        WHERE
            "address" = '2 Finnigan Street'
    );

-- We can now use the above to create the following nested query that will tell us the address and type of address where the package was dropped off at:

SELECT "address", "type"
FROM "addresses"
WHERE
    "id" = (
        SELECT "address_id"
        FROM "scans"
        WHERE
            "package_id" = (
                SELECT "id"
                FROM "packages"
                WHERE
                    "from_address_id" = (
                        SELECT "id"
                        FROM "addresses"
                        WHERE
                            "address" = '900 Somerville Avenue'
                    )
                    AND "to_address_id" = (
                        SELECT "id"
                        FROM "addresses"
                        WHERE
                            "address" = '2 Finnigan Street'
                    )
            )
            AND "action" = 'Drop'
    );

-- it seems the letter has arrived at the expected address :)

-- *** The Devious Delivery ***

-- The key thing is that we don't have a from address, so we can check which package doesn't have from address in the packages table, and the second clue is that its contents should be related to 'quack', like a rubber duck?

SELECT
    "id",
    "contents",
    "to_address_id"
FROM "packages"
WHERE
    "from_address_id" is NULL
    AND "contents" LIKE '%duck%';

-- Found it! It seems it has a duck debugger haha, so we can now use the above in the following nested query to check if the package has been delivered at the right address

SELECT "id", "address", "type"
FROM "addresses"
WHERE
    "id" = (
        SELECT "address_id"
        FROM "scans"
        WHERE
            "package_id" = (
                SELECT "id"
                FROM "packages"
                WHERE
                    "from_address_id" is NULL
                    AND "contents" LIKE '%duck%'
            )
            AND "action" = 'Drop'
    );

-- it seems it was delivered at the Police station which id is 348, but the intended to address was id 50 which is Sesame Street, so it seems our package was caught! :(
SELECT *
FROM "addresses"
WHERE
    "id" = (
        SELECT "to_address_id"
        FROM "packages"
        WHERE
            "from_address_id" is NULL
            AND "contents" LIKE '%duck%'
    );

-- *** The Forgotten Gift ***

-- using the from and to addresses we can get the package id of our poor grandparent

-- but let's first check that both addresses exist
SELECT "id", "address"
from "addresses"
WHERE
    "address" = '728 Maple Place'
    OR "address" = '109 Tileston Street';

-- both exist, yai! Let's now find the contents

SELECT "id", "contents"
FROM "packages"
WHERE
    "from_address_id" = (
        SELECT "id"
        FROM "addresses"
        WHERE
            "address" = '109 Tileston Street'
    )
    AND "to_address_id" = (
        SELECT "id"
        FROM "addresses"
        WHERE
            "address" = '728 Maple Place'
    );

-- the package has flowers, aww what a beautiful present!

-- Let's now check who (driver) has the package

SELECT *
FROM "scans"
WHERE
    "package_id" = (
        SELECT "id"
        FROM "packages"
        WHERE
            "from_address_id" = (
                SELECT "id"
                FROM "addresses"
                WHERE
                    "address" = '109 Tileston Street'
            )
            AND "to_address_id" = (
                SELECT "id"
                FROM "addresses"
                WHERE
                    "address" = '728 Maple Place'
            )
    );

-- We see that the package was picked again after it was dropped off. So let's check who was the driver that picked it up again

SELECT "name"
FROM "drivers"
WHERE
    "id" = (
        SELECT "driver_id"
        FROM "scans"
        WHERE
            "package_id" = (
                SELECT "id"
                FROM "packages"
                WHERE
                    "from_address_id" = (
                        SELECT "id"
                        FROM "addresses"
                        WHERE
                            "address" = '109 Tileston Street'
                    )
                    AND "to_address_id" = (
                        SELECT "id"
                        FROM "addresses"
                        WHERE
                            "address" = '728 Maple Place'
                    )
            )
            AND "action" = 'Pick'
        ORDER BY timestamp DESC
        LIMIT 1
    );
-- So the last driver was Mikel, lets now check where the package was dropped off at

SELECT "address", "type"
FROM "addresses"
WHERE
    "id" = (
        SELECT "address_id"
        FROM "scans"
        WHERE
            "package_id" = (
                SELECT "id"
                FROM "packages"
                WHERE
                    "from_address_id" = (
                        SELECT "id"
                        FROM "addresses"
                        WHERE
                            "address" = '109 Tileston Street'
                    )
                    AND "to_address_id" = (
                        SELECT "id"
                        FROM "addresses"
                        WHERE
                            "address" = '728 Maple Place'
                    )
            )
            AND "action" = 'Drop'
    );

-- it seems the package was dropped off at another address, it seems to be a warehouse