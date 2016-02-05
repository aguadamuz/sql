--find the percentage of signers on a petition that are ineligible
WITH nfl_signers AS 
(
SELECT user_id, state_code, country_code
FROM signatures_petitions
WHERE petition_id = 5468586
GROUP BY 1,2,3
)
, eligible_nfl AS
(
SELECT distinct user_id,
CASE WHEN user_id IN (SELECT id FROM eligible_users) then 1 ELSE 0 END AS eu
FROM nfl_signers
)
SELECT
COUNT(DISTINCT user_id) AS total,
SUM(CASE WHEN eu = 1 THEN 1 ELSE 0 END) AS eligible,
SUM(CASE WHEN eu = 0 THEN 1 ELSE 0 END) AS ineligible,
SUM(CASE WHEN eu = 0 THEN 1 ELSE 0 END)/SUM(CASE WHEN eu = 1 THEN 1 ELSE 0 END)::real AS percent_ineligible
FROM eligible_nfl
LIMIT 1;
 
--Where are these eligible signers from?
WITH nfl_signers AS 
(
SELECT user_id, state_code, country_code
FROM signatures_petitions
WHERE petition_id = 5468586
GROUP BY 1,2,3
)
SELECT distinct state_code, count(distinct user_id) 
FROM nfl_signers
WHERE user_id IN (SELECT id FROM eligible_users)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 99;