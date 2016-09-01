--eligible signers of petitions with no cause

with petitions_w_no_cause as
(
select sp.user_id, sp.petition_id, e.change_id, e.created_locale
from signatures_petitions sp
join events e on sp.petition_id = e.id
where e.change_id is null
)
--eligible signers of petitions started in Germany that do not have a cause
, causeless_signers as
(
select pc.user_id, pc.petition_id, pc.change_id, pc.created_locale, u.country
from petitions_w_no_cause pc
join eligible_users eu on pc.user_id = eu.id
join users u on pc.user_id = u.id
where u.country = 'DE'
)
select user_id
from causeless_signers
limit 999;