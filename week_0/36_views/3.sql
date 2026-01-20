SELECT COUNT("id")
FROM views
WHERE
    "artist" = 'Hokusai'
    AND "english_title" LIKE '%Fuji%';