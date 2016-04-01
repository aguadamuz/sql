--initial attempt at bucketing users in political leaning bins
SELECT leaning, COUNT(DISTINCT id) FROM
(
SELECT id,
CASE WHEN conservative > progressive THEN 'conservative' WHEN progressive > conservative THEN 'progressive' ELSE 'neutral' END AS leaning
FROM 
(
SELECT 
u.id, CASE WHEN ac.score IS NULL THEN 0 ELSE ac.score END AS conservative, CASE WHEN al.score IS NULL THEN 0 ELSE al.score END AS progressive
FROM users u JOIN eligible_users eu ON u.id = eu.id
LEFT JOIN collage_trainer.affiliation_conservative ac ON u.id = ac.user_id
LEFT JOIN collage_trainer.affiliation_liberal al ON u.id = al.user_id
WHERE u.country = 'US'
))
GROUP BY 1
LIMIT 3;


--Andrew Weiss [9:42 PM] 
--I've followed 2 models here. At first, I classified users as republican if the republican classifier showed anything, regardless of the democrat classification. Then I tried rep > 0, dem is null, which is what I've been using to generate the email lists for the change-politics group, more recently. Personally, as Vijay points out, we do have a lot more dem than rep, so I like the former model. We can use rep = 2, dem < 2 or null as a rep. I'd suggest counting with the different models, and see how many reps there are, and if we are getting enough.



SELECT leaning, COUNT(DISTINCT id) FROM
(
SELECT id,
CASE WHEN conservative > 0 AND progressive = 0 THEN 'conservative' WHEN progressive > 0 AND conservative = 0 THEN 'progressive' ELSE 'neutral' END AS leaning
FROM 
(
SELECT 
u.id, CASE WHEN ac.score IS NULL THEN 0 ELSE ac.score END AS conservative, CASE WHEN al.score IS NULL THEN 0 ELSE al.score END AS progressive
FROM users u JOIN eligible_users eu ON u.id = eu.id
LEFT JOIN collage_trainer.affiliation_conservative ac ON u.id = ac.user_id
LEFT JOIN collage_trainer.affiliation_liberal al ON u.id = al.user_id
WHERE u.country = 'US'
))
GROUP BY 1
LIMIT 3;







--leaning > 0 AND > opposite leaning
SELECT leaning, COUNT(DISTINCT id) FROM
(
SELECT id,
CASE WHEN conservative > 0 AND conservative > progressive THEN 'conservative' WHEN progressive > 0 AND progressive > conservative THEN 'progressive' ELSE 'neutral' END AS leaning
FROM 
(
SELECT 
u.id, CASE WHEN ac.score IS NULL THEN 0 ELSE ac.score END AS conservative, CASE WHEN al.score IS NULL THEN 0 ELSE al.score END AS progressive
FROM users u JOIN eligible_users eu ON u.id = eu.id
LEFT JOIN collage_trainer.affiliation_conservative ac ON u.id = ac.user_id
LEFT JOIN collage_trainer.affiliation_liberal al ON u.id = al.user_id
WHERE u.country = 'US'
))
GROUP BY 1
LIMIT 3;



SELECT description, COUNT(DISTINCT id) FROM
(
SELECT 
u.id, 
CASE WHEN ac.score IS NULL AND al.score IS NULL THEN 'neutral'
WHEN ac.score IS NULL AND al.score = 1 THEN 'weak progressive'
WHEN ac.score IS NULL AND al.score = 2 THEN 'strong progressive'
WHEN ac.score = 1 AND al.score IS NULL THEN 'weak conservative'
WHEN ac.score = 2 AND al.score IS NULL THEN 'strong conservative'
WHEN ac.score = 2 AND al.score = 2 THEN 'strong conservative and strong progressive'
WHEN ac.score = 2 AND al.score = 1 THEN 'strong conservative and weak progressive'
WHEN ac.score = 1 AND al.score = 1 THEN 'weak conservative and weak progressive'
WHEN ac.score = 1 AND al.score = 2 THEN 'weak conservative and strong progressive' ELSE 'neutral' END AS description
FROM users u JOIN eligible_users eu ON u.id = eu.id
LEFT JOIN collage_trainer.affiliation_conservative ac ON u.id = ac.user_id
LEFT JOIN collage_trainer.affiliation_liberal al ON u.id = al.user_id
WHERE u.country = 'US'
)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 99;
