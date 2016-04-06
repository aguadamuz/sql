-- How many of these users are in each US state? 
--pull signers of 3 or more petitions
WITH signers AS
( 
SELECT user_id, COUNT(DISTINCT petition_id) AS count
FROM signatures_petitions
WHERE petition_id::int IN
(1937030,2329056,1902490,1834380,1899960,2730211,1236566,2920786,4562696,4200604,1249645,2250276,1979300,2338911,3066091,4496600,5313554,5310182,297280,1076277)
GROUP BY 1
HAVING COUNT(DISTINCT petition_id) > 2
)
-- How many of these users are in each US state? 
SELECT u.state, count(distinct s.user_id) AS count FROM users u JOIN signers s ON u.id = s.user_id  WHERE u.country = 'US' GROUP BY 1 ORDER BY 2 DESC LIMIT 99;


-- How many are in each non-US country?
WITH signers AS
( 
SELECT user_id, COUNT(DISTINCT petition_id) AS count
FROM signatures_petitions
WHERE petition_id::int IN
(1937030,2329056,1902490,1834380,1899960,2730211,1236566,2920786,4562696,4200604,1249645,2250276,1979300,2338911,3066091,4496600,5313554,5310182,297280,1076277)
GROUP BY 1
HAVING COUNT(DISTINCT petition_id) > 2
)
-- How many are in each non-US country?
SELECT u.country, count(distinct s.user_id) AS count FROM users u JOIN signers s ON u.id = s.user_id  WHERE u.country <> 'US' GROUP BY 1 ORDER BY 2 DESC LIMIT 99;

-- What's the gender breakdown of this audience?
--gender breakdown
WITH genders AS
(SELECT user_id, gender FROM olga.gender_global_jr UNION SELECT user_id, gender FROM olga.genderus_jr)
, signers AS
(SELECT su.user_id
FROM signatures_users su
WHERE petition_id::int IN
(1937030,2329056,1902490,1834380,1899960,2730211,1236566,2920786,4562696,4200604,1249645,2250276,1979300,2338911,3066091,4496600,5313554,5310182,297280,1076277)
GROUP BY 1
HAVING COUNT(DISTINCT petition_id) > 2)
SELECT g.gender, COUNT(DISTINCT s.user_id) FROM signers s LEFT JOIN genders g ON s.user_id = g.user_id
GROUP BY 1;

--How many petition signatures, total, have they generated?
WITH signers AS
( 
SELECT user_id, COUNT(DISTINCT petition_id) AS count
FROM signatures_petitions
WHERE petition_id::int IN
(1937030,2329056,1902490,1834380,1899960,2730211,1236566,2920786,4562696,4200604,1249645,2250276,1979300,2338911,3066091,4496600,5313554,5310182,297280,1076277)
GROUP BY 1
HAVING COUNT(DISTINCT petition_id) > 2
)
SELECT COUNT(su.user_id) FROM signatures_users su JOIN signers s ON su.user_id = s.user_id
LIMIT 1;


--If determinable, what is the breakdown of sources for these signatures (i.e., Action Alerts vs. social vs. share link vs... )
--Issue with the sign table so the numbers will not match up with the signatures_users tables
WITH signers AS
( 
SELECT user_id, COUNT(DISTINCT petition_id) AS count
FROM signatures_petitions
WHERE petition_id::int IN
(1937030,2329056,1902490,1834380,1899960,2730211,1236566,2920786,4562696,4200604,1249645,2250276,1979300,2338911,3066091,4496600,5313554,5310182,297280,1076277)
GROUP BY 1
HAVING COUNT(DISTINCT petition_id) > 2
)
SELECT s.current_source, 
COUNT(DISTINCT s.user_id)
FROM SIGN s JOIN signers sgn ON s.user_id = sgn.user_id GROUP BY 1 ORDER BY 2 DESC;


--How many have created petitions? 
WITH signers AS
( 
SELECT user_id, COUNT(DISTINCT petition_id) AS count
FROM signatures_petitions
WHERE petition_id::int IN
(1937030,2329056,1902490,1834380,1899960,2730211,1236566,2920786,4562696,4200604,1249645,2250276,1979300,2338911,3066091,4496600,5313554,5310182,297280,1076277)
GROUP BY 1
HAVING COUNT(DISTINCT petition_id) > 2
)
SELECT COUNT(DISTINCT e.user_id) FROM events e JOIN signers s ON e.user_id = s.user_id
LIMIT 1;

--How many have shared petitions?
WITH signers AS
( 
SELECT user_id, COUNT(DISTINCT petition_id) AS count
FROM signatures_petitions
WHERE petition_id::int IN
(1937030,2329056,1902490,1834380,1899960,2730211,1236566,2920786,4562696,4200604,1249645,2250276,1979300,2338911,3066091,4496600,5313554,5310182,297280,1076277)
GROUP BY 1
HAVING COUNT(DISTINCT petition_id) > 2
)
, sharers AS
(SELECT user_id FROM share_petition sp UNION SELECT user_id FROM share_update)
SELECT COUNT(DISTINCT s.user_id) FROM signers s JOIN sharers sh ON s.user_id = sh.user_id LIMIT 99;

--How many have left comments?
WITH signers AS
( 
SELECT user_id, COUNT(DISTINCT petition_id) AS count
FROM signatures_petitions
WHERE petition_id::int IN
(1937030,2329056,1902490,1834380,1899960,2730211,1236566,2920786,4562696,4200604,1249645,2250276,1979300,2338911,3066091,4496600,5313554,5310182,297280,1076277)
GROUP BY 1
HAVING COUNT(DISTINCT petition_id) > 2
)
SELECT COUNT(DISTINCT o.user_id) FROM opinions o JOIN signers s ON o.user_id = s.user_id;