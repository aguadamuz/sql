with a as
(select
taggable_id, listagg(created_by_staff_member, ' | ') within group (order by created_by_staff_member) AS staff_created_tag
from taggings
where taggable_id is not null
group by 1)
, b as
(select e.created_at::date, e.created_locale, e.id, e.total_signature_count, a.staff_created_tag
from events e left join a on e.id = a.taggable_id
where a.staff_created_tag not ilike '%1%' or a.staff_created_tag is null
and e.created_at >= current_date - interval '18 months'
order by total_signature_count desc)
select * from b 
where created_locale = 'en-AU'
and total_signature_count >= 250
order by total_signature_count desc
limit 1000000