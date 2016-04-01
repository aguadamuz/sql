WITH last_petition_update AS
(SELECT petition_id, created_at::date FROM
(SELECT petition_id, created_at, RANK() OVER (PARTITION BY petition_id ORDER BY created_at DESC) FROM petition_updates ORDER BY 1)
WHERE rank = 1)
SELECT 'Hillary Clinton' AS keyword, COALESCE(e.title, e.ask) AS title, 'http://www.change.org/p/' || e.id AS url, e.total_signature_count, e.created_at::date, lpu.created_at::date AS last_updated, ct.name AS staffed
FROM events e LEFT JOIN staffed_petitions sp ON e.id = sp.petition_id LEFT JOIN campaign_teams ct ON sp.campaign_team_id = ct.id LEFT JOIN last_petition_update lpu ON e.id = lpu.petition_id
WHERE e.created_locale = 'en-US'
AND e.deleted_at IS NULL
AND e.status IN (1,3)
AND e.description ILIKE '%hillary clinton%'
ORDER BY e.total_signature_count DESC
LIMIT 500;

WITH last_petition_update AS
(SELECT petition_id, created_at::date FROM
(SELECT petition_id, created_at, RANK() OVER (PARTITION BY petition_id ORDER BY created_at DESC) FROM petition_updates ORDER BY 1)
WHERE rank = 1)
SELECT 'Bernie Sanders' AS keyword, COALESCE(e.title, e.ask) AS title, 'http://www.change.org/p/' || e.id AS url, e.total_signature_count, e.created_at::date, lpu.created_at::date AS last_updated, ct.name AS staffed
FROM events e LEFT JOIN staffed_petitions sp ON e.id = sp.petition_id LEFT JOIN campaign_teams ct ON sp.campaign_team_id = ct.id LEFT JOIN last_petition_update lpu ON e.id = lpu.petition_id
WHERE e.created_locale = 'en-US'
AND e.deleted_at IS NULL
AND e.status IN (1,3)
AND e.description ILIKE '%bernie sanders%'
ORDER BY e.total_signature_count DESC
LIMIT 500;

WITH last_petition_update AS
(SELECT petition_id, created_at::date FROM
(SELECT petition_id, created_at, RANK() OVER (PARTITION BY petition_id ORDER BY created_at DESC) FROM petition_updates ORDER BY 1)
WHERE rank = 1)
SELECT 'Ted Cruz' AS keyword, COALESCE(e.title, e.ask) AS title, 'http://www.change.org/p/' || e.id AS url, e.total_signature_count, e.created_at::date, lpu.created_at::date AS last_updated, ct.name AS staffed
FROM events e LEFT JOIN staffed_petitions sp ON e.id = sp.petition_id LEFT JOIN campaign_teams ct ON sp.campaign_team_id = ct.id LEFT JOIN last_petition_update lpu ON e.id = lpu.petition_id
WHERE e.created_locale = 'en-US'
AND e.deleted_at IS NULL
AND e.status IN (1,3)
AND e.description ILIKE '%ted cruz%'
ORDER BY e.total_signature_count DESC
LIMIT 500;

WITH last_petition_update AS
(SELECT petition_id, created_at::date FROM
(SELECT petition_id, created_at, RANK() OVER (PARTITION BY petition_id ORDER BY created_at DESC) FROM petition_updates ORDER BY 1)
WHERE rank = 1)
SELECT 'Donald Trump' AS keyword, COALESCE(e.title, e.ask) AS title, 'http://www.change.org/p/' || e.id AS url, e.total_signature_count, e.created_at::date, lpu.created_at::date AS last_updated, ct.name AS staffed
FROM events e LEFT JOIN staffed_petitions sp ON e.id = sp.petition_id LEFT JOIN campaign_teams ct ON sp.campaign_team_id = ct.id LEFT JOIN last_petition_update lpu ON e.id = lpu.petition_id
WHERE e.created_locale = 'en-US'
AND e.deleted_at IS NULL
AND e.status IN (1,3)
AND e.description ILIKE '%donald trump%'
ORDER BY e.total_signature_count DESC
LIMIT 500;

WITH last_petition_update AS
(SELECT petition_id, created_at::date FROM
(SELECT petition_id, created_at, RANK() OVER (PARTITION BY petition_id ORDER BY created_at DESC) FROM petition_updates ORDER BY 1)
WHERE rank = 1)
SELECT 'John Kasich' AS keyword, COALESCE(e.title, e.ask) AS title, 'http://www.change.org/p/' || e.id AS url, e.total_signature_count, e.created_at::date, lpu.created_at::date AS last_updated, ct.name AS staffed
FROM events e LEFT JOIN staffed_petitions sp ON e.id = sp.petition_id LEFT JOIN campaign_teams ct ON sp.campaign_team_id = ct.id LEFT JOIN last_petition_update lpu ON e.id = lpu.petition_id
WHERE e.created_locale = 'en-US'
AND e.deleted_at IS NULL
AND e.status IN (1,3)
AND e.description ILIKE '%john kasich%'
ORDER BY e.total_signature_count DESC
LIMIT 500;

WITH last_petition_update AS
(SELECT petition_id, created_at::date FROM
(SELECT petition_id, created_at, RANK() OVER (PARTITION BY petition_id ORDER BY created_at DESC) FROM petition_updates ORDER BY 1)
WHERE rank = 1)
SELECT 'Bill Clinton' AS keyword, COALESCE(e.title, e.ask) AS title, 'http://www.change.org/p/' || e.id AS url, e.total_signature_count, e.created_at::date, lpu.created_at::date AS last_updated, ct.name AS staffed
FROM events e LEFT JOIN staffed_petitions sp ON e.id = sp.petition_id LEFT JOIN campaign_teams ct ON sp.campaign_team_id = ct.id LEFT JOIN last_petition_update lpu ON e.id = lpu.petition_id
WHERE e.created_locale = 'en-US'
AND e.deleted_at IS NULL
AND e.status IN (1,3)
AND e.description ILIKE '%bill clinton%'
ORDER BY e.total_signature_count DESC
LIMIT 500;

WITH last_petition_update AS
(SELECT petition_id, created_at::date FROM
(SELECT petition_id, created_at, RANK() OVER (PARTITION BY petition_id ORDER BY created_at DESC) FROM petition_updates ORDER BY 1)
WHERE rank = 1)
SELECT 'Melania Trump' AS keyword, COALESCE(e.title, e.ask) AS title, 'http://www.change.org/p/' || e.id AS url, e.total_signature_count, e.created_at::date, lpu.created_at::date AS last_updated, ct.name AS staffed
FROM events e LEFT JOIN staffed_petitions sp ON e.id = sp.petition_id LEFT JOIN campaign_teams ct ON sp.campaign_team_id = ct.id LEFT JOIN last_petition_update lpu ON e.id = lpu.petition_id
WHERE e.created_locale = 'en-US'
AND e.deleted_at IS NULL
AND e.status IN (1,3)
AND e.description ILIKE '%melania trump%'
ORDER BY e.total_signature_count DESC
LIMIT 500;

WITH last_petition_update AS
(SELECT petition_id, created_at::date FROM
(SELECT petition_id, created_at, RANK() OVER (PARTITION BY petition_id ORDER BY created_at DESC) FROM petition_updates ORDER BY 1)
WHERE rank = 1)
SELECT 'Heidi Cruz' AS keyword, COALESCE(e.title, e.ask) AS title, 'http://www.change.org/p/' || e.id AS url, e.total_signature_count, e.created_at::date, lpu.created_at::date AS last_updated, ct.name AS staffed
FROM events e LEFT JOIN staffed_petitions sp ON e.id = sp.petition_id LEFT JOIN campaign_teams ct ON sp.campaign_team_id = ct.id LEFT JOIN last_petition_update lpu ON e.id = lpu.petition_id
WHERE e.created_locale = 'en-US'
AND e.deleted_at IS NULL
AND e.status IN (1,3)
AND e.description ILIKE '%heidi cruz%'
ORDER BY e.total_signature_count DESC
LIMIT 500;