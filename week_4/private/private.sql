-- We first create the table with the triplets the detective left
DROP TABLE IF EXISTS triplets;

CREATE TABLE triplets (
    "id" INTEGER,
    "sentence_number" INTEGER,
    "character_number" INTEGER,
    "message_length" INTEGER,
    PRIMARY KEY ("id")
);

INSERT INTO
    triplets (
        "sentence_number",
        "character_number",
        "message_length"
    )
VALUES (14, 98, 4),
    (114, 3, 5),
    (618, 72, 9),
    (630, 7, 3),
    (932, 12, 5),
    (2230, 50, 7),
    (2346, 44, 10),
    (3041, 14, 5);

--- we now create a view that contains only the sentences that the triplet are referring to by using a CTE and then applying the substr function to get the hidden message in each sentence
DROP VIEW IF EXISTS "message";


CREATE VIEW "message" AS
WITH "target_sentences" AS(
    SELECT sentences."sentence",triplets."character_number",triplets."message_length" FROM sentences
JOIN triplets ON triplets."sentence_number" = sentences."id"

)
SELECT substr(
        "sentence", "character_number", "message_length"
    ) AS "phrase"
FROM "target_sentences";