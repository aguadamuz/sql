WITH es_users AS
(
SELECT id, created_at::date, country
FROM users
WHERE country = 'ES'
AND created_at::date >= '2013-01-01'
AND created_at::date <= '2015-12-31'
GROUP BY 1,2,3
)
, es_signatures AS
(
--petitions signed by the es_users
SELECT su.petition_id, su.user_id, su.created_at::date, esu.created_at AS user_created_at, esu.country AS user_country
FROM signatures_users su
JOIN es_users esu ON su.user_id = esu.id
GROUP BY 1,2,3,4,5
)
, causes AS
(
--add cause names using events.change_id
SELECT ess.petition_id, ess.user_id, ess.created_at AS petition_created_at, ess.user_created_at, ess.user_country, e.change_id, c.name
FROM es_signatures ess
JOIN events e ON ess.petition_id = e.id
JOIN changes c ON e.change_id = c.id
GROUP BY 1,2,3,4,5,6,7
)
SELECT DATE_PART(year, c.user_created_at) AS user_created_at, c.user_country, c.name, COUNT(DISTINCT c.user_id)
FROM causes c
GROUP BY 1,2,3
ORDER BY 1 ASC, 4 DESC
LIMIT 999


SELECT created_date, country, cause, n
FROM (
	SELECT
	DATE_PART(year, u.created_at) AS created_date
	, u.country AS country
	, RANK() OVER (PARTITION BY u.country ORDER BY COUNT(1) DESC) AS r
	, c.name AS cause
	, COUNT(distinct(u.id)) AS n
	FROM users u
	JOIN signatures_users su ON u.id = su.user_id
	JOIN events e ON e.id = su.petition_id
	JOIN changes c ON c.id = e.change_id
	WHERE u.created_at >= '2013-01-01'
	AND u.created_at <= '2015-12-31'
	AND u.country IN  ('ES', 'FR', 'IT')
	GROUP BY created_date, country, cause
)
WHERE r < 50
ORDER BY 2 ASC,1 ASC, 4 DESC;
