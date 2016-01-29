--zendesk queries


--pull change.org user ids for the zendesk users based on their email address
--pull change.org user ids for the zendesk users based on their email address
--pull change.org user ids for the zendesk users based on their email address
WITH ua_users AS
(
WITH zendesk_users AS
(
SELECT ozu.email, ozu.id AS zendesk_id, u.id, u.first_name, u.last_name, datediff(year, u.birthday, current_date) AS age, u.country, u.locale
FROM olga.zendesk_users ozu JOIN users u ON ozu.email = u.email
)
SELECT DISTINCT zu.email, zu.zendesk_id, zu.id, zu.first_name, zu.last_name, zu.age, zu.country, zu.locale
FROM zendesk_users zu
)
SELECT uau.email, uau.zendesk_id, uau.id, uau.first_name, uau.last_name, uau.age, uau.country, uau.locale, count(distinct ozt.nice_id)
FROM ua_users uau
JOIN olga.zendesk_tickets ozt ON uau.zendesk_id = ozt.requester_id
GROUP BY 1,2,3,4,5,6,7,8
ORDER BY 9 DESC
LIMIT 999;




SELECT * 
FROM olga.zendesk_tickets
LIMIT 9999;

SELECT * 
FROM olga.zendesk_tickets ozt
JOIN olga.zendesk_users ozu
ON ozt.requester_id = ozu.id
LIMIT 9999;

SELECT * FROM olga.zendesk_users LIMIT 99;


SELECT created_at::date, COUNT(DISTINCT id) from olga.zendesk_users
WHERE email = ''
GROUP BY 1
ORDER BY 1 DESC
LIMIT 9999;

SELECT COUNT(DISTINCT id) from olga.zendesk_users
WHERE email = ''
LIMIT 99;

SELECT COUNT(DISTINCT id) from olga.zendesk_users
WHERE email != ''
LIMIT 99;