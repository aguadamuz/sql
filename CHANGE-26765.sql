WITH signers as 
(
with  first_sig as (
	select * from(
	select sp.created_at, sp.user_id, sp.petition_id, rank() over(partition by sp.user_id order by sp.created_at asc) as sign_time
	from signatures_petitions sp
	join users u on sp.user_id = u.id
	where u.country = 'US') a
	where sign_time = 1)

select fs.created_at, fs.user_id, fs.petition_id, fs.sign_time
FROM first_sig fs --JOIN email_recipients er ON fs.user_id = er.user_id
WHERE fs.petition_id NOT IN (4623766, 4604144)
AND fs.created_at::date BETWEEN '2015-10-13' AND '2015-11-10'
GROUP BY 1,2,3,4
), count as 
(SELECT s.user_id,
CASE WHEN s.user_id IN (SELECT DISTINCT e.user_id FROM events e) THEN 1 ELSE 0 END AS starter,
CASE WHEN s.user_id IN (SELECT DISTINCT shp.user_id FROM share_petition shp JOIN signers s ON shp.user_id = s.user_id AND shp.petition_id <> s.petition_id) THEN 1 ELSE 0 END AS sharer,
CASE WHEN s.user_id IN (SELECT DISTINCT u.id FROM users u WHERE total_actions > 1) THEN 1 ELSE 0 END AS multiple_actions,
CASE WHEN s.user_id IN (SELECT DISTINCT sp.user_id FROM signatures_petitions sp JOIN signers s ON sp.user_id = s.user_id AND sp.petition_id <> s.petition_id) THEN 1 ELSE 0 END AS signers
FROM signers s
)
SELECT count(distinct user_id), SUM(starter) AS starters, SUM(sharer) AS sharers, SUM(signers) AS signers, SUM(multiple_actions) AS multiple_actions
FROM count
;

--group B
WITH signers as 
(
with  first_sig as (
	select * from(
	select sp.created_at, sp.user_id, sp.petition_id, rank() over(partition by sp.user_id order by sp.created_at asc) as sign_time
	from signatures_petitions sp
	join users u on sp.user_id = u.id
	where u.country = 'US') a
	where sign_time = 1)

select fs.created_at, fs.user_id, fs.petition_id, fs.sign_time
FROM first_sig fs --JOIN email_recipients er ON fs.user_id = er.user_id
WHERE fs.petition_id NOT IN (5115534)
AND fs.created_at::date BETWEEN '2015-11-28' AND '2015-12-26'
GROUP BY 1,2,3,4
), count as 
(SELECT s.user_id,
CASE WHEN s.user_id IN (SELECT DISTINCT e.user_id FROM events e) THEN 1 ELSE 0 END AS starter,
CASE WHEN s.user_id IN (SELECT DISTINCT shp.user_id FROM share_petition shp JOIN signers s ON shp.user_id = s.user_id AND shp.petition_id <> s.petition_id) THEN 1 ELSE 0 END AS sharer,
CASE WHEN s.user_id IN (SELECT DISTINCT u.id FROM users u WHERE total_actions > 1) THEN 1 ELSE 0 END AS multiple_actions,
CASE WHEN s.user_id IN (SELECT DISTINCT sp.user_id FROM signatures_petitions sp JOIN signers s ON sp.user_id = s.user_id AND sp.petition_id <> s.petition_id) THEN 1 ELSE 0 END AS signers
FROM signers s
)
SELECT count(distinct user_id), SUM(starter) AS starters, SUM(sharer) AS sharers, SUM(signers) AS signers, SUM(multiple_actions) AS multiple_actions
FROM count
;