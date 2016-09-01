select round(conservative_1 * 100, 2) as conservative_1, round(conservative_2 * 100, 2) as conservative_2, ROUND(liberal_1 * 100, 2) as liberal_1, round(liberal_2 * 100, 2) as liberal_2, round((1 - (conservative_1 + conservative_2 + liberal_1 + liberal_2)) * 100, 2) as other
from
(
select count(distinct(case when conservative_score = 1 then user_id end))::float/count(distinct user_id) as conservative_1,
count(distinct(case when conservative_score = 2 then user_id end))::float/count(distinct user_id) as conservative_2,
count(distinct(case when liberal_score = 1 then user_id end))::float/count(distinct user_id) as liberal_1,
count(distinct(case when liberal_score = 2 then user_id end))::float/count(distinct user_id) as liberal_2
from
(
--incorporating political affiliation data to current pacing query
select distinct s.user_id, ac.score as conservative_score, al.score as liberal_score 
from signatures_users s
left join collage_trainer.affiliation_liberal al
on s.user_id = al.user_id
left join collage_trainer.affiliation_conservative ac
on s.user_id = ac.user_id
where s.signup_context ilike '%actionalert%'
and s.country_code = 'US'
))
;
