SELECT users."username" from messages 
JOIN users on users."id" = messages."to_user_id"
GROUP BY messages."to_user_id"
ORDER BY COUNT(messages."to_user_id") DESC
LIMIT 1;