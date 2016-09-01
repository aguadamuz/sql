select distinct date, year, url, id, title, country, created_locale, description, target, expense, total_signature_count
from 
(
--labeling petitions that mention the 25 largest pharma companies
--would use decision makers but results did not appear very different
select e.created_at::date as date, datepart(year, e.created_at) as year, 'http://www.change.org/p/' || e.id as url, e.id, coalesce(e.title, e.ask) as title, u.country, e.created_locale, e.description, e.total_signature_count,
case when description ILIKE '%Novartis%' then 'Novartis'
when description ILIKE '%pfizer%' then 'Pfizer'
when description ILIKE '%roche pharma%' then 'Roche'
when description ILIKE '%sanofi%' then 'Sanofi'
when description ILIKE '%merck%' then 'Merck'
when description ILIKE '%johnson & johnson%' then 'Johnson & Johnson'
when description ILIKE '%GlaxoSmithKline%' then 'GlaxoSmithKline'
when description ILIKE '%AstraZeneca%' then 'AstraZeneca'
when description ILIKE '%Gilead%' then 'Gilead'
when description ILIKE '%Takeda%' then 'Takeda'
when description ILIKE '%AbbVie%' then 'AbbVie'
when description ILIKE '%Amgen%' then 'Amgen'
when description ILIKE '%Teva%' then 'Teva'
when description ILIKE '%Lilly%' then 'Lilly'
when description ILIKE '%Bristol-Myers%' then 'Bristol-Myers'
when description ILIKE '%bayer%' then 'Bayer'
when description ILIKE '%Novo Nordisk%' then 'Novo Nordisk'
when description ILIKE '%Astellas%' then 'Astellas'
when description ILIKE '%Boehringer Ingelheim%' then 'Boehringer Ingelheim'
when description ILIKE '%Actavis%' then 'Actavis'
when description ILIKE '%Otsuka%' then 'Otsuka'
when description ILIKE '%Daiichi Sankyo%' then 'Daiichi Sankyo'
when description ILIKE '%biogen%' then 'Biogen'
when description ILIKE '%baxter%' then 'Baxter'
when description ILIKE '%merck%' then 'Merck'
when description ILIKE '%turing pharm%' then 'Turing'
else 'other' end as target,
--using keywords to determine if the petition is related to pharma costs
case when description ILIKE '%price%' then 'cost'
when description ILIKE '%cost%' then 'cost'
when description ILIKE '%expens%' then 'cost'
when description ILIKE '%afford%' then 'cost'
else 'other' end as expense
from events e
join users u on e.user_id = u.id
where description ILIKE '%Novartis%'
or description ILIKE '%pfizer%'
or description ILIKE '%roche pharma%'
or description ILIKE '%sanofi%'
or description ILIKE '%merck%'
or description ILIKE '%johnson & johnson%'
or description ILIKE '%GlaxoSmithKline%'
or description ILIKE '%AstraZeneca%'
or description ILIKE '%Gilead%'
or description ILIKE '%Takeda%'
or description ILIKE '%AbbVie%'
or description ILIKE '%Amgen%'
or description ILIKE '%Teva Pharma%'
or description ILIKE '%Eli Lilly%'
or description ILIKE '%Bristol-Myers%'
or description ILIKE '%bayer phar%'
or description ILIKE '%Novo Nordisk%'
or description ILIKE '%Astellas%'
or description ILIKE '%Boehringer Ingelheim%'
or description ILIKE '%Actavis%'
or description ILIKE '%Otsuka%'
or description ILIKE '%Daiichi Sankyo%'
or description ILIKE '%biogen%'
or description ILIKE '%baxter pharma%'
or description ILIKE '%merck%'
or description ILIKE '%turing pharm%'

)
where country = 'US'
and created_locale = 'en-US'
order by target
limit 2000;


with b as
(
with a as
(
select id, title, description, total_signature_count, created_locale, user_id, status, deleted_at
from
(
select id, title, description, total_signature_count, created_locale, user_id, status, deleted_at
from
(
select id, title, description, total_signature_count, created_locale, user_id, status, deleted_at
from events
where description ilike '%pharmaceut%'
order by created_at desc
)
where description ilike '%cost%'
or description ilike '%afford%'
or description ilike '%expense%'
or description ilike '%price%'
)
where created_locale = 'en-US'
)
select a.id, a.title, a.description, a.total_signature_count, a.created_locale, u.country, a.status,
case when a.description ILIKE '%Novartis%' then 'Novartis'
when a.description ILIKE '%pfizer%' then 'Pfizer'
when a.description ILIKE '%roche pharma%' then 'Roche'
when a.description ILIKE '%sanofi%' then 'Sanofi'
when a.description ILIKE '%merck%' then 'Merck'
when a.description ILIKE '%johnson & johnson%' then 'Johnson & Johnson'
when a.description ILIKE '%GlaxoSmithKline%' then 'GlaxoSmithKline'
when a.description ILIKE '%AstraZeneca%' then 'AstraZeneca'
when a.description ILIKE '%Gilead%' then 'Gilead'
when a.description ILIKE '%Takeda%' then 'Takeda'
when a.description ILIKE '%AbbVie%' then 'AbbVie'
when a.description ILIKE '%Amgen%' then 'Amgen'
when a.description ILIKE '%Teva%' then 'Teva'
when a.description ILIKE '%Lilly%' then 'Lilly'
when a.description ILIKE '%Bristol-Myers%' then 'Bristol-Myers'
when a.description ILIKE '%bayer%' then 'Bayer'
when a.description ILIKE '%Novo Nordisk%' then 'Novo Nordisk'
when a.description ILIKE '%Astellas%' then 'Astellas'
when a.description ILIKE '%Boehringer Ingelheim%' then 'Boehringer Ingelheim'
when a.description ILIKE '%Actavis%' then 'Actavis'
when a.description ILIKE '%Otsuka%' then 'Otsuka'
when a.description ILIKE '%Daiichi Sankyo%' then 'Daiichi Sankyo'
when a.description ILIKE '%biogen%' then 'Biogen'
when a.description ILIKE '%baxter%' then 'Baxter'
when a.description ILIKE '%merck%' then 'Merck'
when a.description ILIKE '%turing pharm%' then 'Turing'
else 'other' end as target
from a
join users u on a.user_id = u.id
where u.country = 'US'
and a.deleted_at is null
)
select distinct b.id, b.title, b.description, b.total_signature_count, b.created_locale, b.country, b.status, b.target, pt.name
from b
join petitions_petition_targets ppt on b.id = ppt.petition_id
join petition_targets pt on ppt.petition_target_id = pt.id
order by b.id
