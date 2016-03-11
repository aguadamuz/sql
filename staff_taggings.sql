--taggings placed by staff
WITH change_users AS (SELECT id, first_name, last_name FROM users WHERE right(email, 11) = '@change.org')
SELECT tgs.taggable_id, tgs.user_id, tgs.approved, tgs.created_by_staff_member, cu.first_name, cu.last_name
FROM taggings tgs JOIN change_users cu ON tgs.user_id = cu.id
LIMIT 999


--850 hours of work
--would need to expand the work by 3X
--~5K per month
--closer to 15K tasks per month
--can we expand it out
--50K petitions

--5-10 examples for training materials