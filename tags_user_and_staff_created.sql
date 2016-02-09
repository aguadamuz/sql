WITH staff AS
(
SELECT id, CASE WHEN RIGHT(email, 10) = 'change.org' THEN 1 ELSE 0 END AS staff,
first_name,
last_name,
email
FROM users
)
SELECT t.created_at::date, t.id, t.name, t.locale, t.user_id
--, s.staff, first_name, last_name, email
FROM tags t
JOIN staff s ON t.user_id = s.id
WHERE t.user_id IS NOT NULL
AND s.staff = 0
AND t.locale = 'en-US'
GROUP BY 1,2,3,4,5--,6,7,8,9
ORDER BY 1, 5 ASC
LIMIT 999;