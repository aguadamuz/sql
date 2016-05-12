--total number of US and non-US signatures on all enviro petitions with an org ID (sponsored and organic). This possible?

--select * from signatures_petitions sp limit 999;

select count(sp.user_id)--e.id, sp.user_id, sp.country_code, t.name 
from events e join taggings tgs on e.id = tgs.taggable_id join tags t on tgs.tag_id = t.id join signatures_petitions sp on e.id = sp.petition_id
where t.name = 'environment'
and e.organization_id is not null
and e.created_locale = 'en-US'
and sp.country_code != 'US'
and sp.created_at >= current_date - interval '365 days'
limit 999;

--select * from changes where name ilike 'environment'
--id = 12

select count(sp.user_id)--e.id, sp.user_id, sp.country_code, t.name 
from events e join signatures_petitions sp on e.id = sp.petition_id
--join taggings tgs on e.id = tgs.taggable_id join tags t on tgs.tag_id = t.id join signatures_petitions sp on e.id = sp.petition_id
where --t.name = 'environment'
e.organization_id is not null
and e.created_locale != 'en-US'
and sp.country_code != 'US'
and e.change_id = 12
and sp.created_at >= current_date - interval '365 days'
limit 999;
