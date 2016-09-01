--causes on untagged AR petitions

select e.id, e.user_id, e.total_signature_count, e.change_id, u.country, c.name, count(distinct tgs.tag_id) as tag_count
from events e
left join taggings tgs on e.id = tgs.taggable_id
join users u on e.user_id = u.id
join changes c on e.change_id = c.id
where u.country = 'AR'
and e.total_signature_count >= 10
group by 1,2,3,4,5,6
having count(distinct tgs.tag_id) = 0
limit 9999999
;