--petition counts for August by country

select country, count(distinct id) as tagged_petition_count
from
(
select e.id, e.created_locale, u.country, tgs.user_id
from events e
join users u on e.user_id = u.id
join taggings tgs on e.id = tgs.taggable_id
where tgs.user_id = 359649872
and tgs.created_at >= current_date - interval '5 days'
)
group by 1
order by 2 desc