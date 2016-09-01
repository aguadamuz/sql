select date, year, url, id, title, country, created_locale, letter_body, target, expense
from 
(
--labeling petitions that mention the 25 largest pharma companies
--would use decision makers but they are all over the place
select e.created_at::date as date, datepart(year, e.created_at) as year, 'http://www.change.org/p/' || e.id as url, e.id, coalesce(e.title, e.ask) as title, u.country, e.created_locale, e.letter_body,
case when letter_body ILIKE '%Novartis%' then 'Novartis'
when letter_body ILIKE '%pfizer%' then 'Pfizer'
when letter_body ILIKE '%roche pharma%' then 'Roche'
when letter_body ILIKE '%sanofi%' then 'Sanofi'
when letter_body ILIKE '%merck%' then 'Merck'
when letter_body ILIKE '%johnson & johnson%' then 'Johnson & Johnson'
when letter_body ILIKE '%GlaxoSmithKline%' then 'GlaxoSmithKline'
when letter_body ILIKE '%AstraZeneca%' then 'AstraZeneca'
when letter_body ILIKE '%Gilead%' then 'Gilead'
when letter_body ILIKE '%Takeda%' then 'Takeda'
when letter_body ILIKE '%AbbVie%' then 'AbbVie'
when letter_body ILIKE '%Amgen%' then 'Amgen'
when letter_body ILIKE '%Teva%' then 'Teva'
when letter_body ILIKE '%Lilly%' then 'Lilly'
when letter_body ILIKE '%Bristol-Myers%' then 'Bristol-Myers'
when letter_body ILIKE '%bayer%' then 'Bayer'
when letter_body ILIKE '%Novo Nordisk%' then 'Novo Nordisk'
when letter_body ILIKE '%Astellas%' then 'Astellas'
when letter_body ILIKE '%Boehringer Ingelheim%' then 'Boehringer Ingelheim'
when letter_body ILIKE '%Actavis%' then 'Actavis'
when letter_body ILIKE '%Otsuka%' then 'Otsuka'
when letter_body ILIKE '%Daiichi Sankyo%' then 'Daiichi Sankyo'
when letter_body ILIKE '%biogen%' then 'Biogen'
when letter_body ILIKE '%baxter%' then 'Baxter'
when letter_body ILIKE '%merck%' then 'Merck'
else 'other' end as target,
--using keywords to determine if the petition is related to pharma costs
case when letter_body ILIKE '%price%' then 'cost'
when letter_body ILIKE '%cost%' then 'cost'
when letter_body ILIKE '%expens%' then 'cost'
when letter_body ILIKE '%afford%' then 'cost'
else 'other' end as expense
from events e
join users u on e.user_id = u.id
where letter_body ILIKE '%Novartis%'
or letter_body ILIKE '%pfizer%'
or letter_body ILIKE '%roche pharma%'
or letter_body ILIKE '%sanofi%'
or letter_body ILIKE '%merck%'
or letter_body ILIKE '%johnson & johnson%'
or letter_body ILIKE '%GlaxoSmithKline%'
or letter_body ILIKE '%AstraZeneca%'
or letter_body ILIKE '%Gilead%'
or letter_body ILIKE '%Takeda%'
or letter_body ILIKE '%AbbVie%'
or letter_body ILIKE '%Amgen%'
or letter_body ILIKE '%Teva Pharma%'
or letter_body ILIKE '%Eli Lilly%'
or letter_body ILIKE '%Bristol-Myers%'
or letter_body ILIKE '%bayer phar%'
or letter_body ILIKE '%Novo Nordisk%'
or letter_body ILIKE '%Astellas%'
or letter_body ILIKE '%Boehringer Ingelheim%'
or letter_body ILIKE '%Actavis%'
or letter_body ILIKE '%Otsuka%'
or letter_body ILIKE '%Daiichi Sankyo%'
or letter_body ILIKE '%biogen%'
or letter_body ILIKE '%baxter pharma%'
or letter_body ILIKE '%merck%'
)
where country = 'US'
and created_locale = 'en-US'
limit 2000;

-----------------------------------
--using the decisiom makers

select id, name, email, locale
from
(
select id, name, email, locale
from petition_targets
where name ILIKE '%Novartis%'
or name ILIKE '%pfizer%'
or name ILIKE '%roche pharma%'
or name ILIKE '%sanofi%'
or name ILIKE '% merck %'
or name ILIKE '%johnson & johnson%'
or name ILIKE '%GlaxoSmithKline%'
or name ILIKE '%AstraZeneca%'
or name ILIKE '%Gilead%'
or name ILIKE '%Takeda phar%'
or name ILIKE '%AbbVie%'
or name ILIKE '%Amgen%'
or name ILIKE '%Teva Pharma%'
or name ILIKE '%Eli Lilly%'
or name ILIKE '%Bristol-Myers%'
or name ILIKE '%bayer co%'
or name ILIKE '%Novo Nordisk%'
or name ILIKE '%Astellas%'
or name ILIKE '%Boehringer Ingelheim%'
or name ILIKE '%Actavis%'
or name ILIKE '%Otsuka pharm%'
or name ILIKE '%Daiichi Sankyo%'
or name ILIKE '%biogen%'
or name ILIKE '%baxter pharma%'
or name ILIKE '%merck %'
)
--where locale = 'en-US'
--and email is not null
limit 9999