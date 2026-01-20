SELECT COUNT("id")
FROM views
WHERE
    "artist" = 'Hiroshige'
    AND "english_title" LIKE '%Eastern Capital%';