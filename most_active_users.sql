SELECT u.id, u. created_at, u.last_login, u.first_name, u.last_name, u.email, u.total_actions, u.total_recruits, COUNT(DISTINCT sp.petition_id) AS signature_count, COUNT(DISTINCT e.id) AS petitions_started
FROM users u
JOIN eligible_users eu on u.id = eu.id
LEFT JOIN signatures_petitions sp ON u.id = sp.user_id
LEFT JOIN events e ON u.id = e.user_id
WHERE u.country = 'CA'
AND u.city = 'Winnipeg'
GROUP BY 1,2,3,4,5,6,7,8
ORDER BY 7 DESC
LIMIT 500
;