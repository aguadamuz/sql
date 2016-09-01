
--petitons with a keyword
with petitions as
(
select e.id, e.created_locale, u.country, e.letter_body
from events e
join users u on e.user_id = u.id
where e.deleted_at is null
and e.created_locale = 'en-US'
and u.country = 'US'
and e.letter_body ilike '%elephant%'
)
--get all the tags on the petitons
select petition_id, listagg(name, ' | ') within group (order by name) AS tags
from
(
select p.id as petition_id, t.name
from petitions p
left join taggings tgs on p.id = tgs.taggable_id
left join tags t on tgs.tag_id = t.id
where t.locale = 'en-US'
order by 1 desc
)
group by 1
limit 999


