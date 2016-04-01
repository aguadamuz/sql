--all queries are pulling for petitions with events.created_locale = en-US but not limiting the country of the signers

--checked with Adam and we decided to use collage tags
--average signatures by topic Q1 2016
--using collage tags (likely need to update the tag names to match tag taxonomy rather than topics)

--average number of signatures by chosen tags Q1
SELECT
name, AVG(signature_count)
FROM
(SELECT t.name, 
su.petition_id,
COUNT(DISTINCT su.user_id) AS signature_count
FROM signatures_users su JOIN events e ON e.id = su.petition_id JOIN taggings tgs ON su.petition_id = tgs.taggable_id JOIN tags t ON tgs.tag_id = t.id
WHERE su.created_at::DATE BETWEEN '2016-01-01' AND '2016-03-31'
AND e.deleted_at IS NULL
AND e.created_locale = 'en-US'
AND t.name IN ('animals', 'criminal justice', 'economic justice', 'environment', 'lgbt rights', 'health and safety', 'human trafficking', 'immigration', 'sustainability', 'women', 'sports', 'disability rights', 'food', 'technology')
GROUP BY 1,2
HAVING COUNT(DISTINCT su.user_id) > 1)
GROUP BY 1;

--average number of signatures across all petitions Q1
SELECT AVG(sigcount)
FROM
(SELECT e.id, COUNT(DISTINCT su.user_id) AS sigcount
FROM events e JOIN signatures_users su ON e.id = su.petition_id
WHERE e.total_signature_count >= 2
AND su.created_at::date >= '2016-01-01' AND su.created_at::date <= '2016-03-31'
AND e.created_locale = 'en-US'
AND e.deleted_at IS NULL
GROUP BY 1
HAVING COUNT(DISTINCT su.user_id) > 1);

--total # of signatures last 30 days across all petitions
SELECT
SUM(signature_count)
FROM
(SELECT
su.petition_id,
COUNT(DISTINCT su.user_id) AS signature_count
FROM signatures_users su JOIN events e ON e.id = su.petition_id
WHERE su.created_at >= current_date - interval '30 days'
AND e.deleted_at IS NULL
AND e.created_locale = 'en-US'
GROUP BY 1
HAVING COUNT(DISTINCT su.user_id) > 1);

--total # of signatures last 30 days by topic
SELECT
name, SUM(signature_count)
FROM
(SELECT t.name, 
su.petition_id,
COUNT(DISTINCT su.user_id) AS signature_count
FROM signatures_users su JOIN events e ON e.id = su.petition_id JOIN taggings tgs ON su.petition_id = tgs.taggable_id JOIN tags t ON tgs.tag_id = t.id
WHERE su.created_at >= current_date - interval '30 days'
AND e.deleted_at IS NULL
AND t.name IN ('animals', 'criminal justice', 'economic justice', 'environment', 'lgbt rights', 'health and safety', 'human trafficking', 'immigration', 'sustainability', 'women', 'sports', 'disability rights', 'food', 'technology')
GROUP BY 1,2
HAVING COUNT(DISTINCT su.user_id) > 1)
GROUP BY 1;