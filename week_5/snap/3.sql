SELECT messages."to_user_id" from messages 
JOIN users on users."id" = messages."from_user_id"
WHERE users."username" = 'creativewisdom377'
GROUP BY messages."to_user_id"
ORDER BY COUNT(messages."to_user_id") DESC
LIMIT 3;