
--pull US eligible users
with us_eligible_users as
(
select distinct u.id as user_id
from users u
join eligible_users eu on u.id = eu.id
where u.country = 'US'
)
--pull all the petitions the users have signed
, users_petitions as
(
select su.user_id, su.petition_id
from signatures_users su
join us_eligible_users eue on su.user_id = eue.user_id
)
--tags on petitions
, tags_on_petitions as
(
select up.user_id, up.petition_id, count(distinct tgs.tag_id) as tag_count
from users_petitions up
left join taggings tgs on up.petition_id = tgs.taggable_id
group by 1,2
)
--untagged eligible US users
, untagged_users as
(
select tp.user_id, max(tp.tag_count)
from tags_on_petitions tp
group by 1
having max(tp.tag_count) = 0
)

-- select count(user_id)
-- from untagged_users
-- limit 2
-- ;
-- 

--untagged users with petition_ids
, untagged_petition_users as
(
select uu.user_id, tp.petition_id, tp.tag_count
from untagged_users uu
join tags_on_petitions tp on uu.user_id = tp.user_id
)
select up.petition_id, e.status, e.created_locale, 'http://www.change.org/p/' || up.petition_id as url, t.name, count(up.user_id)
from untagged_petition_users up
left join collage_tags ct on up.petition_id = ct.petition_id
left join tags t on ct.tag_id = t.id
join events e on up.petition_id = e.id
where e.deleted_at is null
and e.created_locale = 'en-US'
group by 1,2,3,4,5
order by 6 desc
limit 999999
;