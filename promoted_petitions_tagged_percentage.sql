--how many active en-US promoted petitions have tags
WITH tgp AS
(
SELECT COUNT(DISTINCT(v.petition_id)) as count
FROM tags t
JOIN taggings ts
ON t.id = ts.tag_id
JOIN victory_funds v
ON ts.taggable_id = v.petition_id
JOIN events e
ON ts.taggable_id = e.id
WHERE t.locale = 'en-US'
AND e.created_locale = 'en-US'
AND e.status = 1
AND e.deleted_at IS NULL
),
--how many active promoted en-US pettitions are there total
tp AS 
(
SELECT COUNT(DISTINCT(v.petition_id)) as count
FROM victory_funds v
JOIN events e
ON v.petition_id = e.id
WHERE e.created_locale = 'en-US'
AND e.status = 1
AND e.deleted_at IS NULL
AND e.total_signature_count >= 2
)
SELECT 
CAST(tgp.count AS REAL)/tp.count AS pct_promoted_tagged,
tgp.count AS tagged_promoted_petitions,
tp.count AS total_promoted_petitions
FROM tgp, tp
LIMIT {QUERY_LIMIT};