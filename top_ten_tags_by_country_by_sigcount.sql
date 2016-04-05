SELECT country_code, name, sigcount, rownum
FROM
(SELECT country_code, name, sigcount, ROW_NUMBER() OVER (PARTITION BY country_code ORDER BY sigcount DESC) AS rownum FROM
(SELECT
country_code, name, SUM(signature_count) AS sigcount FROM
(SELECT t.name, su.petition_id, su.country_code,
COUNT(DISTINCT su.user_id) AS signature_count
FROM signatures_users su JOIN events e ON e.id = su.petition_id JOIN taggings tgs ON su.petition_id = tgs.taggable_id JOIN tags t ON tgs.tag_id = t.id
WHERE su.created_at::DATE BETWEEN '2015-01-01' AND '2015-12-31'
AND e.deleted_at IS NULL
GROUP BY 1,2,3
HAVING COUNT(DISTINCT su.user_id) > 1)
GROUP BY 1,2
ORDER BY 3 DESC)
GROUP BY 1,2,3)
WHERE rownum <= 10