--ben_lowe_french_other_petitions_signed

--pull eligible french users who have signed a petiton in the last 60 days
SELECT COUNT(DISTINCT u.id)
FROM users u 
JOIN eligible_users eu ON u.id = eu.id
JOIN signatures_users su ON u.id = su.user_id
WHERE u.country = 'FR'
--AND su.petition_id = 5022830
AND su.created_at >= current_date - INTERVAL '60 days'


--Sauvage signers who signed other things
--distribution by number of petitions signed
WITH signers AS
(
SELECT DISTINCT su.user_id
FROM signatures_users su
JOIN users u ON su.user_id = u.id
WHERE su.petition_id = 5022830
AND u.country = 'FR'
), sign_count AS
(
SELECT su.user_id, count(distinct su.petition_id)
FROM signatures_users su
JOIN signers s ON su.user_id = s.user_id
GROUP BY 1
)
SELECT count AS num_petitions_signed, count(distinct user_id) num_users
FROM sign_count
GROUP BY 1
ORDER BY 1 ASC
--WHERE count = 1
LIMIT 999;

--Sauvage signers (excluding AA clickthroughs) who signed other things
--distribution by number of petitions signed
WITH signers AS
(
SELECT DISTINCT u.id AS user_id
FROM users u 
JOIN eligible_users eu ON u.id = eu.id
JOIN signatures_users su ON u.id = su.user_id
WHERE u.country = 'FR'
AND su.petition_id = 5022830
AND u.id NOT IN 
(SELECT distinct aaue.user_id--, aar.event_id 
FROM action_alert_user_events aaue
JOIN action_alert_records aar on aaue.action_alert_record_id = aar.id
WHERE aar.event_id = 5022830
AND aaue.event = 'view')
), sign_count AS
(
SELECT su.user_id, count(distinct su.petition_id)
FROM signatures_users su
JOIN signers s ON su.user_id = s.user_id
WHERE 
GROUP BY 1
)
SELECT count AS num_petitions_signed, count(distinct user_id) num_users
FROM sign_count
GROUP BY 1
ORDER BY 1 ASC
--WHERE count = 1
LIMIT 999;


--all French users who have signed anything in the past 60 days
--distribution by number of petitions signed
WITH signers AS
(
SELECT DISTINCT u.id AS user_id
FROM users u 
JOIN eligible_users eu ON u.id = eu.id
JOIN signatures_users su ON u.id = su.user_id
WHERE u.country = 'FR'
--AND su.petition_id = 5022830
AND su.created_at >= current_date - INTERVAL '60 days'
), sign_count AS
(
SELECT su.user_id, count(distinct su.petition_id)
FROM signatures_users su
JOIN signers s ON su.user_id = s.user_id
GROUP BY 1
)
SELECT count AS num_petitions_signed, count(distinct user_id) num_users
FROM sign_count
GROUP BY 1
ORDER BY 1 ASC
--WHERE count = 1
LIMIT 999;


--number of eligible users that signed a specific set of petitons
SELECT su.petition_id, COUNT(DISTINCT u.id)
FROM users u 
JOIN eligible_users eu ON u.id = eu.id
JOIN signatures_users su ON u.id = su.user_id
WHERE u.country = 'FR'
AND su.petition_id IN
(
'5428626',
'5049166',
'3506237',
'3836228',
'4878918',
'4761258',
'5451626',
'3627432',
'1406138',
'4774514',
'3242021',
'1706705',
'5592522',
'4856606',
'4504943',
'4141072',
'1422445',
'3353621',
'3960308',
'2891086',
'5417994',
'4368306',
'3757308',
'3466665',
'5051274',
'4363653',
'3396433',
'2080394',
'3389193',
'3690431',
'4844002',
'2224319',
'5019370',
'4144648',
'5204090',
'2991491',
'2040910',
'3308356',
'2866526',
'1384730',
'1487208',
'1934780',
'1788785',
'4322944',
'4381875',
'5075650',
'4954790',
'4892182',
'1524300',
'3716043',
'2004435',
'4666458',
'1489194',
'5221954',
'5140562',
'3869696',
'3092486',
'1329916',
'3850724',
'5149246',
'4381977',
'4221904',
'1720730',
'1307617',
'5043094',
'2008785',
'1748105',
'3200041',
'1479714',
'2600751',
'4962230',
'2952126',
'2382286',
'3408933',
'4824222',
'1854375',
'1786545',
'5255158',
'3907264',
'2350686',
'1851295',
'1818625',
'5736798',
'3854828',
'5246010',
'2097929',
'5088454',
'2211649',
'1067062',
'2856481',
'3828140',
'1874635',
'1336735',
'2763131',
'4702230',
'2345921',
'2752226',
'1031881',
'1407323',
'1621565',
'2963241',
'1312708',
'2189064',
'2722146',
'1802455',
'2062780',
'4359603',
'1488199',
'3354677',
'2307396',
'2024665',
'5743654',
'3190751',
'3462937',
'4625150',
'1184125',
'1131975',
'1206998',
'2124549',
'1468428',
'3598499',
'2118329',
'1450884',
'4639190',
'831754',
'1647830',
'1020689',
'3739243',
'918163',
'2260751',
'3598363',
'763030',
'1958915',
'1186936',
'1208619',
'1288375',
'2783941',
'5429514',
'1102739',
'3365265',
'5521022',
'1488021',
'3837564',
'1726240',
'1297989',
'953346',
'4042848',
'1501074',
'2222144',
'3710951',
'2309736',
'1209766',
'1752440',
'1445737',
'2032610',
'1482823',
'2123559',
'1019887',
'2999376',
'2324306',
'1056727',
'4842826',
'5451326',
'1480459',
'2888041',
'1508911',
'5076854',
'1782930',
'2369336',
'1209657',
'1432374',
'2810881',
'3448653',
'1280592',
'3979536',
'1475372',
'3054971',
'4628906',
'1479697',
'5139506',
'1107117',
'5148146',
'2729066',
'5152934',
'2722056',
'1264134',
'1396148',
'1312621',
'2505191',
'3102056',
'4223404',
'3104526',
'1307618',
'587326',
'3856876',
'2252051',
'2851746',
'1047895',
'5135962',
'1254783',
'4196104',
'1048680',
'3373769',
'1296235',
'3492881',
'5439730',
'2315321',
'965900',
'1622600',
'3852896',
'3358893',
'2783861',
'1399482',
'1815525',
'1313930',
'1410125',
'1317868',
'1455672',
'233523',
'2341711',
'1341077',
'1399925',
'1496541',
'3558026',
'829618',
'4465712',
'127010',
'967005',
'2308676',
'2108499',
'1374142',
'3611600',
'3654344',
'2382106',
'2040390',
'1431869',
'5774542',
'1540375',
'1156710',
'1099454',
'1007054',
'1052541',
'2175919',
'1284752',
'2083324',
'1336141',
'1298219',
'3922988',
'561434',
'2135724',
'5486234',
'5248742',
'3960044',
'75129',
'1740380',
'1651775',
'559174',
'934247',
'5332090',
'4122348',
'1506014',
'614965',
'419367',
'1291624',
'2472301',
'5050242',
'3842084',
'1722250',
'650615',
'1019443',
'805700',
'4288072',
'2172354',
'4969198',
'3789800',
'1336187')
GROUP BY 1
;


SELECT *
FROM signatures_users
LIMIT 99;


--french signers who signed the target petition (but did not clickthrough on an AA send)
-----with total eligible users by petition
WITH grouped_tags AS
(
WITH ewt AS --events with tags
(
SELECT e.id, e.created_locale, t.name FROM events e
JOIN taggings tgs ON e.id = tgs.taggable_id
JOIN tags t ON tgs.tag_id = t.id
WHERE status > 0
--AND created_locale = 'en-US'
AND deleted_at IS NULL
)
SELECT id, created_locale, listagg(name, ' | ') within group (order by name) AS tags
FROM ewt
GROUP BY 1,2
)
, signers AS
(
SELECT DISTINCT u.id AS user_id
FROM users u 
JOIN eligible_users eu ON u.id = eu.id
JOIN signatures_users su ON u.id = su.user_id
WHERE u.country = 'FR'
AND su.petition_id = 5022830
AND u.id NOT IN 
(SELECT distinct aaue.user_id--, aar.event_id 
FROM action_alert_user_events aaue
JOIN action_alert_records aar on aaue.action_alert_record_id = aar.id
WHERE aar.event_id = 5022830
AND aaue.event = 'view')

--AND su.created_at >= current_date - INTERVAL '60 days'
),
petitions AS
(
SELECT sp.petition_id, count(distinct(s.user_id))
FROM signatures_petitions sp
JOIN signers s on s.user_id = sp.user_id
--WHERE petition_id != 4384233
GROUP BY 1
ORDER BY 2 DESC
), event AS
(
SELECT p.petition_id, COALESCE(e.title, e.ask) AS title, 'http://www.change.org/p/' || CAST(p.petition_id AS TEXT) AS url, p.count
FROM petitions p
JOIN events e ON e.id = p.petition_id
ORDER BY 4 DESC
)
, total_eligible_users_by_petition AS
(
SELECT sp.petition_id, count(distinct(sp.user_id)) AS count
FROM signatures_petitions sp
JOIN petitions p ON sp.petition_id = p.petition_id
--JOIN signers s on s.user_id = sp.user_id
--WHERE petition_id != 4384233
--WHERE sp.country_code = 'US'
GROUP BY 1
ORDER BY 2 DESC
)
SELECT e.petition_id, e.title, e.url, e.count AS eligible_signers_of_target_petition, teup.count AS total_eligible_users_on_petition, gt.tags
FROM event e
LEFT JOIN grouped_tags gt ON e.petition_id = gt.id
LEFT JOIN total_eligible_users_by_petition teup ON e.petition_id = teup.petition_id
ORDER BY 4 DESC
LIMIT 500;
