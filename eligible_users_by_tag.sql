SELECT t.name,
       COUNT(DISTINCT(el.id)) AS eligible_users
FROM tags t
JOIN taggings ts ON t.id = ts.tag_id
JOIN signatures_petitions s ON s.petition_id = ts.taggable_id
JOIN eligible_users el ON el.id = s.user_id
WHERE s.country_code = 'US'
  AND t.locale = 'en-US'
GROUP BY t.name
HAVING COUNT(DISTINCT(el.id)) >= 1000
ORDER BY eligible_users DESC LIMIT {QUERY_LIMIT}