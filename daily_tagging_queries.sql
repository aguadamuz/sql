--Daily Tagging Checkup Queries

--pull all petition with < 5 tags - last 2 days
with a as
(
select taggable_id
from taggings tgs
where created_at between current_date - interval '2 days' and current_date
and user_id in (533019575, 532971977, 559513778, 559513694)
)
select tgs.taggable_id, count(distinct tgs.tag_id) as count
from taggings tgs join a on tgs.taggable_id = a.taggable_id
group by 1
having count(distinct tgs.tag_id) < 5


--frequency distribution over the last 7 days
select count, count(taggable_id) as frequency
from
(
with a as
(
select taggable_id
from taggings tgs
where created_at between current_date - interval '8 days' and current_date - interval '1 day'
and user_id in (533019575, 532971977)
)
select tgs.taggable_id, count(distinct tgs.tag_id) as count
from taggings tgs join a on tgs.taggable_id = a.taggable_id
group by 1
)
group by 1
order by 1

--avg tags per petitions for the last 7 days
select avg(count) from
(
with a as
(
select taggable_id, tag_id
from taggings tgs
where created_at between current_date - interval '8 days' and current_date - interval '1 day'
and user_id in (533019575, 532971977)
)
select tgs.taggable_id, count(distinct tgs.tag_id) as count
from taggings tgs join a on tgs.taggable_id = a.taggable_id
group by 1
)

--avg per tagger last 7 days

--avg tags per petitions for the last 7 days
--salina
select avg(count) from
(
with a as
(
select taggable_id, tag_id
from taggings tgs
where created_at between current_date - interval '8 days' and current_date - interval '1 day'
and user_id in (533019575)
)
select tgs.taggable_id, count(distinct tgs.tag_id) as count
from taggings tgs join a on tgs.taggable_id = a.taggable_id
group by 1
)

--avg tags per petitions for the last 7 days
--Carla
select avg(count) from
(
with a as
(
select taggable_id, tag_id
from taggings tgs
where created_at between current_date - interval '8 days' and current_date - interval '1 day'
and user_id in (532971977)
)
select tgs.taggable_id, count(distinct tgs.tag_id) as count
from taggings tgs join a on tgs.taggable_id = a.taggable_id
group by 1
)
