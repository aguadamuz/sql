with pwt AS -- petitions with tags
(with staff AS --user table with ids tagged as staff or not staff

   (SELECT id,
           CASE WHEN RIGHT(email, 10) = 'change.org' THEN 1 ELSE 0 END AS staff
    FROM users)
 SELECT tgs.created_at::date AS date,
        tgs.taggable_id,
        tgs.tag_id,
        tgs.user_id,
        s.staff,
        t.name
 FROM taggings tgs
 JOIN tags t ON tgs.tag_id = t.id
 JOIN staff s ON tgs.user_id = s.id
 JOIN events e ON tgs.taggable_id = e.id
 WHERE tgs.user_id IS NOT NULL
   AND s.staff = 0
   AND e.created_locale = 'en-US'
   AND e.status = 1
   AND e.deleted_at IS NULL
 GROUP BY 1,
          2,
          3,
          4,
          5,
          6
 ORDER BY 1 ASC)
SELECT name,
       count(DISTINCT taggable_id) AS petition_count
FROM pwt
WHERE date >= CURRENT_DATE - interval '7 days'
GROUP BY 1
HAVING count(DISTINCT taggable_id) > 1
ORDER BY 2 DESC 
LIMIT {QUERY_LIMIT}