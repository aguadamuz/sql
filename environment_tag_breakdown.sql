--i’m basically curious to see which environmental tags are the most popular in terms of signatures and petitions started.

WITH env_petitions AS
(
SELECT distinct e.id, tgs.tag_id, t.name, e.sponsored, e.created_locale, e.total_signature_count,
CASE WHEN e.organization_id IS NULL THEN 0 ELSE 1 END AS org,
CASE WHEN e.sponsored !=0 THEN 1 ELSE 0 END AS spon
FROM events e JOIN taggings tgs ON tgs.taggable_id = e.id JOIN tags t ON tgs.tag_id = t.id
WHERE e.status > 0
AND e.deleted_at IS NULL
AND e.created_locale = 'en-US'
AND e.created_at >= current_date - interval '365 days'
AND t.name IN
('environment',
'sustainability',
'outdoor recreation',
'conservation',
'climate change',
'pollution',
'parks',
'fossil fuels',
'fracking',
'mining',
'nuclear energy',
'clean energy',
'oceans',
'clean air',
'epa',
'arctic ocean',
'oil',
'water',
'deforestation',
'coral reefs',
'ancestral domain',
'garbage',
'typhoon')
AND e.total_signature_count >= 2
)
-- SELECT sponsored, count(distinct id)
-- FROM env_petitions
-- GROUP BY 1 ORDER BY 2 DESC
-- LIMIT 10;
--SELECT name, count(distinct id)
--FROM env_petitions
--GROUP BY 1 ORDER BY 2 DESC
--LIMIT 10;
SELECT SUM(org)
--name, count(distinct id), SUM(org), SUM(spon), SUM(total_signature_count)
FROM env_petitions
--GROUP BY 1 ORDER BY 2 DESC
LIMIT 999