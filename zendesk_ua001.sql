--zendesk queries


--pull change.org user ids for the zendesk users based on their email address
WITH zendesk_users AS
(
SELECT ozu.email, ozu.id AS zendesk_id, u.id, u.first_name, u.last_name, datediff(year, u.birthday, current_date) AS age, u.country, u.locale
FROM olga.zendesk_users ozu JOIN users u ON ozu.email = u.email
)
SELECT DISTINCT zu.email, zu.zendesk_id, zu.id, zu.first_name, zu.last_name, zu.age, zu.country, u.locale
FROM zendesk_users zu
LIMIT 300000;




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