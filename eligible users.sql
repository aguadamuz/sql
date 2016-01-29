WITH eu AS -- eligible users
(
SELECT t.id, t.name, COUNT(DISTINCT(el.id)) n
FROM tags t
JOIN taggings ts ON t.id = ts.tag_id
JOIN signatures_petitions s ON s.petition_id = ts.taggable_id
JOIN eligible_users el ON el.id = s.user_id
WHERE s.country_code = 'US'
AND t.locale = 'en-US'
GROUP BY 1,2
)
SELECT t.id, t.name, t.slug, t.taggings_count, eu.n AS eligible_users
FROM tags t
LEFT JOIN eu ON t.id = eu.id
WHERE t.locale = 'en-US'
GROUP BY 1,2,3,4,5
ORDER BY 4 DESC
LIMIT 5000;
