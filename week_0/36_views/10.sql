SELECT "english_title", "artist" AS 'Japanese Artist'
FROM views
WHERE
    "artist" = 'Hokusai'
ORDER BY "contrast" DESC
LIMIT 1;