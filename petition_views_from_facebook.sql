select sp.petition_id, count(sp.*) from share_petition sp join events e on sp.petition_id = e.id
where sp.created_at::date between '2016-01-01' and '2016-03-31'
and e.sponsored = 0
and sp.location = 'facebook'
and sp.country_code = 'US'
GROUP BY 1
ORDER BY 1 DESC
--and sp.context = 
limit 99;


select avg(count) from
(select petition_id, count(uuid) as count from
(select pv.petition_id, pv.created_at::date, pv.uuid, pv.user_id
from petition_view pv join events e on pv.petition_id = e.id
where pv.current_medium = 'facebook'
and pv.current_source in ('share_petition', 'share_update')
and pv.created_at::date between '2016-01-01' and '2016-03-31'
and e.sponsored = 0
and e.created_locale = 'en-US'
and e.status > 0
and e.deleted_at is null
and pv.country_code = 'US'
group by 1))
