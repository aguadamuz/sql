--event_ids
--individual
-- 2250276,
-- 1979300,
-- 2338911,
-- 3066091,
-- 4496600,
-- 5313554,
-- 5310182,
-- 297280,
-- 1076277

--systemic
-- 1937030,
-- 2329056,
-- 1902490,
-- 1834380,
-- 1899960,
-- 2730211,
-- 1236566,
-- 2920786,
-- 4562696,
-- 4200604,
-- 1249645

--Irrespective of how many users there are, how many signatures are collectively on that group of petitions?
--individual
-- SELECT SUM(total_signature_count) AS total_signature_count_individual
-- FROM events
-- WHERE id IN
-- (
-- 2250276,
-- 1979300,
-- 2338911,
-- 3066091,
-- 4496600,
-- 5313554,
-- 5310182,
-- 297280,
-- 1076277
-- )
-- LIMIT 1
-- ;

--Irrespective of how many users there are, how many signatures are collectively on that group of petitions?
--systemic
-- SELECT SUM(total_signature_count) AS total_signature_count_systemic
-- FROM events
-- WHERE id IN
-- (
-- 1937030,
-- 2329056,
-- 1902490,
-- 1834380,
-- 1899960,
-- 2730211,
-- 1236566,
-- 2920786,
-- 4562696,
-- 4200604,
-- 1249645
-- )
-- LIMIT 1
-- ;

--Irrespective of how many users there are, how many signatures are collectively on that group of petitions?
--systemic and individual
SELECT SUM(total_signature_count) AS total_signature_count_systemic_and_individual
FROM events
WHERE id IN
(
1937030,
2329056,
1902490,
1834380,
1899960,
2730211,
1236566,
2920786,
4562696,
4200604,
1249645,
2250276,
1979300,
2338911,
3066091,
4496600,
5313554,
5310182,
297280,
1076277
)
LIMIT 1
;

--How many unique users do those signatures represent?
-- SELECT COUNT(DISTINCT user_id) AS total_users_individual
-- FROM signatures_petitions
-- WHERE petition_id IN
-- (
-- 2250276,
-- 1979300,
-- 2338911,
-- 3066091,
-- 4496600,
-- 5313554,
-- 5310182,
-- 297280,
-- 1076277
-- )
-- AND user_id IS NOT NULL
-- LIMIT 1
-- ;

--How many unique users do those signatures represent?
-- SELECT COUNT(DISTINCT user_id) AS total_users_systemic
-- FROM signatures_petitions
-- WHERE petition_id::int IN
-- (
-- 1249645, 
-- 1937030,
-- 2329056,
-- 1902490,
-- 1834380,
-- 1899960,
-- 2730211,
-- 1236566,
-- 2920786,
-- 4562696,
-- 4200604
-- )
-- LIMIT 1
-- ;

--How many unique users do those signatures represent?
SELECT COUNT(DISTINCT user_id) AS total_users_systemic_and_individual
FROM signatures_petitions
WHERE petition_id::int IN
(
1937030,
2329056,
1902490,
1834380,
1899960,
2730211,
1236566,
2920786,
4562696,
4200604,
1249645,
2250276,
1979300,
2338911,
3066091,
4496600,
5313554,
5310182,
297280,
1076277
)
LIMIT 1
;


--How many of those unique users signed 1 petition?
--How many signed 2? 3? 4? More than 4?
WITH petition_count AS
(
SELECT user_id, COUNT(DISTINCT petition_id) AS count
FROM signatures_petitions
WHERE petition_id::int IN
(
1937030,
2329056,
1902490,
1834380,
1899960,
2730211,
1236566,
2920786,
4562696,
4200604,
1249645,
2250276,
1979300,
2338911,
3066091,
4496600,
5313554,
5310182,
297280,
1076277
)
GROUP BY 1
ORDER BY 2 DESC
)
SELECT count, COUNT(DISTINCT user_id)
FROM petition_count
GROUP BY 1
ORDER BY 1 ASC
LIMIT 9999;