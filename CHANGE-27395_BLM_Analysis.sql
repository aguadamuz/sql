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

WITH genders AS
(SELECT user_id, gender FROM olga.gender_global_jr UNION SELECT user_id, gender FROM olga.genderus_jr)
SELECT g.gender, COUNT(DISTINCT sp.petition_id) AS count
FROM signatures_petitions sp JOIN genders g ON sp.user_id = g.user_id
WHERE petition_id::int IN
(1937030,2329056,1902490,1834380,1899960,2730211,1236566,2920786,4562696,4200604,1249645,2250276,1979300,2338911,3066091,4496600,5313554,5310182,297280,1076277)
GROUP BY 1
HAVING COUNT(DISTINCT petition_id) > 2
LIMIT 99;

-- How many of these users are in each US state? 
-- How many are in each non-US country?
-- What's the gender breakdown of this audience?

How many petition signatures, total, have they generated?