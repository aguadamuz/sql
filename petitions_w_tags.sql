select id, listagg(name, ' | ') within group (order by name) AS tags
from
(
select e.id, t.name
from events e
left join collage_tags ct
on e.id = ct.petition_id
left join tags t on ct.tag_id = t.id
where e.id in
(
8019884,
8016245,
7951676,
8019476,
8019491,
7905506,
8018423,
7970060,
7958075
))
group by 1