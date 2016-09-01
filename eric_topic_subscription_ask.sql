--From Eric's Email
--We are still trying to get a handle on addressable audience/market for a subscription / membership program.
--Top 10 cause/category areas in US for views/signs then...in these cause categories
--Number of new user signs by month for last 12 months.
--Number of Return user signatures by month for last 12 months.
--Number of total users who have signed 1, 2, 3, 4,---10 petitions within the cause cateogry by month over past 12 months.

--top ten topics by signature for the last 12 months
select name, count(user_id) as signature_count from
(
select t.name, sp.created_at, datepart(mm, sp.created_at), sp.petition_id, sp.user_id
from signatures_petitions sp
join taggings tgs on sp.petition_id = tgs.taggable_id
join tags t on tgs.tag_id = t.id
join events e on sp.petition_id = e.id
where sp.created_at >= current_date - interval '12 months'
and e.created_locale = 'en-US'
and t.name not in ('animal cruelty', 'animal welfare', 'animal rights', 'animal abuse', 'animal protection', 'dogs', 'wildlife', 'zoos', 'endangered species', 'anti-hunting', 'pets')
--the exclusions above overlap with 'animals' so I am manually excluding them
)
group by 1
order by 2 desc
LIMIT 20;

----------


--Number of total users who have signed 1, 2, 3, 4,---10 petitions within the cause cateogry by month over past 12 months
select name, year, month, petition_count, count(distinct user_id)
from
(
select year, month, name, user_id, count(distinct petition_id) as petition_count
from
(
select t.name, sp.user_id, sp.created_at, date_part(y, sp.created_at) as year, date_part(mm, sp.created_at) as month, sp.petition_id
from signatures_petitions sp
join taggings tgs on sp.petition_id = tgs.taggable_id
join tags t on tgs.tag_id = t.id
join events e on sp.petition_id = e.id
where e.created_locale = 'en-US'
and e.deleted_at is null
and sp.created_at >= current_date - interval '12 months'
and name in (
'animals',
'politics',
'criminal justice',
'health and safety',
'economic justice',
'human rights',
'environment',
'education',
'women',
'entertainment'
)
group by 1,2,3,4,5,6
)
group by 1,2,3,4
)
where petition_count <= 10
group by 1,2,3,4
order by 1,2,3,4 asc
;


--Top 10 cause/category areas in US for views/signs then...in these cause categories
--Number of new user signs by month for last 12 months.
--Number of Return user signatures by month for last 12 months.

--new users
with ranked_sigs as
(
select t.name, sp.user_id, sp.created_at, date_part(y, sp.created_at) as year, date_part(mm, sp.created_at) as month, sp.petition_id,
rank() over (partition by sp.user_id order by sp.created_at asc) as rank
from signatures_petitions sp
join taggings tgs on sp.petition_id = tgs.taggable_id
join tags t on tgs.tag_id = t.id
join events e on sp.petition_id = e.id
where e.created_locale = 'en-US'
and e.deleted_at is null
)
select name, year, month, count(user_id)
from ranked_sigs
where rank = 1
and created_at >= current_date - interval '12 months'
and name in (
'animals',
'politics',
'criminal justice',
'health and safety',
'economic justice',
'human rights',
'environment',
'education',
'women',
'entertainment')
group by 1,2,3
order by 1,2,3 asc
limit 9999
;

--returning users
with ranked_sigs as
(
select t.name, sp.user_id, sp.created_at, date_part(y, sp.created_at) as year, date_part(mm, sp.created_at) as month, sp.petition_id,
rank() over (partition by sp.user_id order by sp.created_at asc) as rank
from signatures_petitions sp
join taggings tgs on sp.petition_id = tgs.taggable_id
join tags t on tgs.tag_id = t.id
join events e on sp.petition_id = e.id
where e.created_locale = 'en-US'
and e.deleted_at is null
)
select name, year, month, count(user_id)
from ranked_sigs
where rank > 1
and created_at >= current_date - interval '12 months'
and name in (
'animals',
'politics',
'criminal justice',
'health and safety',
'economic justice',
'human rights',
'environment',
'education',
'women',
'entertainment')
group by 1,2,3
order by 1,2,3 asc
limit 9999
;