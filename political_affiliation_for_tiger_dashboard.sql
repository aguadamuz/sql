--how many eligible US users are in the conservative table
select count(distinct ac.user_id)
from collage_trainer.affiliation_conservative ac
join users u on ac.user_id = u.id
join eligible_users eu on ac.user_id = eu.id
where u.country = 'US'
limit 1;

--how many eligible US users are in the conservative table
--with score
select ac.score, count(distinct ac.user_id)
from collage_trainer.affiliation_conservative ac
join users u on ac.user_id = u.id
join eligible_users eu on ac.user_id = eu.id
where u.country = 'US'
group by 1
limit 2;

--how many eligible US users are in the liberal table
select count(distinct al.user_id)
from collage_trainer.affiliation_liberal al
join users u on al.user_id = u.id
join eligible_users eu on al.user_id = eu.id
where u.country = 'US'
limit 1;

--how many eligible US users are in the liberal table
--with score
select al.score, count(distinct al.user_id)
from collage_trainer.affiliation_liberal al
join users u on al.user_id = u.id
join eligible_users eu on al.user_id = eu.id
where u.country = 'US'
group by 1
limit 2;

--get all eligible US users
select conservative_score, liberal_score, count(distinct user_id) from 
(with us_users as
(select distinct u.id as user_id from users u join eligible_users eu on u.id = eu.id where country = 'US')
select uu.user_id, ac.score as conservative_score, al.score as liberal_score from us_users uu
left join collage_trainer.affiliation_conservative ac on uu.user_id = ac.user_id 
left join collage_trainer.affiliation_liberal al on uu.user_id = al.user_id)
group by 1,2
order by 3 desc;