SELECT ts.id, ts.tag_id, ts.taggable_id, taggable_type, ts.created_at, t.locale, t.name, 'http://www.change.org/p/' || ts.taggable_id AS url
FROM taggings ts
JOIN tags t ON ts.tag_id = t.id
JOIN events e ON ts.taggable_id = e.id
WHERE tag_id = 7623
LIMIT 999;



--lookup petitions associated with tag id
SELECT ts.id, ts.tag_id, t.name, taggable_id
FROM taggings ts JOIN tags t ON ts.tag_id = t.id
WHERE ts.tag_id = 4427
GROUP BY 1,2,3,4
LIMIT 99;


--the url can be used in the bulk tool located at https://www.change.org/admin/petitions/add_or_delete_tags
SELECT ts.id, ts.tag_id, t.name, taggable_id, 'http://www.change.org/p/' || taggable_id AS url
FROM taggings ts JOIN tags t ON ts.tag_id = t.id JOIN events e ON e.id = ts.taggable_id
WHERE ts.tag_id = 6462
AND e.deleted_at IS NULL
GROUP BY 1,2,3,4
LIMIT 99;