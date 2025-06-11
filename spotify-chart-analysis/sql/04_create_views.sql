CREATE OR REPLACE VIEW vw_weekly_chart_turnover AS
WITH weekly_songs AS (
	SELECT DISTINCT week_start, spotify_id
	FROM spotify_daily 
	WHERE is_global = TRUE
), 
with_previous AS(
	SELECT
		ws1.week_start AS current_week,
		ws1.spotify_id,
		LAG(ws1.week_start) OVER (PARTITION BY ws1.spotify_id ORDER BY ws1.week_start) AS previous_week
	FROM weekly_songs AS ws1
),
joined AS (
	SELECT
		current_week,
		COUNT(CASE WHEN previous_week IS NULL THEN 1 END) AS new_songs,
		COUNT(*) AS total_songs
	FROM with_previous
	GROUP BY current_week
)
SELECT
	current_week,
	new_songs,
	total_songs,
	ROUND((new_songs::DECIMAL / total_songs) * 100, 2) AS turnover_rate_percent
FROM joined
ORDER BY current_week;

CREATE OR REPLACE VIEW longest_trending_songs AS
SELECT 
	spotify_id,
	song_name,
	first_appearance,
	last_appearance, 
	trend_duration,
	days_in_chart
FROM spotify_trend_duration
ORDER BY trend_duration DESC;

CREATE OR REPLACE VIEW top_avg_songs_by_country AS 
SELECT
	country,
	spotify_id,
	song_name,
	ROUND(AVG(daily_rank), 2) AS avg_daily_rank,
	COUNT(*) AS appearances
FROM spotify_daily
WHERE daily_rank IS NOT NULL
GROUP BY country, spotify_id, song_name
HAVING COUNT(*) > 3
ORDER BY country, avg_daily_rank ASC;

CREATE OR REPLACE VIEW vw_country_sync_score AS
WITH global_top10 AS (
	SELECT week_start, spotify_id
	FROM spotify_daily
	WHERE is_global = TRUE AND daily_rank <= 10
),
country_top10 AS (
	SELECT week_start, country, spotify_id
	FROM spotify_daily
	WHERE is_global = FALSE AND daily_rank <= 10
),
overlap AS (
	SELECT ct.country, ct.week_start, COUNT(*) AS overlap_count
	FROM country_top10 ct
	JOIN global_top10 gt
	ON ct.spotify_id = gt.spotify_id AND ct.week_start = gt.week_start
	GROUP BY ct.country, ct.week_start
),
total_weeks AS (
	SELECT country, COUNT(DISTINCT week_start) AS total_weeks
	FROM country_top10
	GROUP BY country
),
avg_overlap AS (
	SELECT country, AVG(overlap_count)::DECIMAL AS avg_weekly_overlap
	FROM overlap
	GROUP BY country
)
SELECT
	t.country,
	ROUND(a.avg_weekly_overlap, 2) AS avg_weekly_overlap,
	t.total_weeks,
	ROUND((a.avg_weekly_overlap / 10) * 100, 2) AS sync_score_percent
FROM avg_overlap a
JOIN total_weeks t ON a.country = t.country
ORDER BY sync_score_percent DESC;

CREATE OR REPLACE VIEW vw_repeat_appearance_ratio AS
WITH appearances AS (
	SELECT country, spotify_id, COUNT(DISTINCT week_start) AS weeks_on_chart
	FROM spotify_daily
	WHERE NOT is_global
	GROUP BY country, spotify_id
),
reentries AS (
	SELECT country, spotify_id
	FROM (
		SELECT country, spotify_id, week_start,
			LAG(week_start) OVER (PARTITION BY country, spotify_id ORDER BY week_start) AS prev_week
		FROM (
			SELECT DISTINCT country, spotify_id, week_start
			FROM spotify_daily
			WHERE NOT is_global
		) t
	) sub
	WHERE prev_week IS NOT NULL AND week_start - prev_week > INTERVAL '7 days'
),
repeat_counts AS (
	SELECT country, COUNT(DISTINCT spotify_id) AS repeat_songs
	FROM reentries
	GROUP BY country
),
total_counts AS (
	SELECT country, COUNT(DISTINCT spotify_id) AS total_songs
	FROM spotify_daily
	WHERE NOT is_global
	GROUP BY country
)
SELECT
	t.country,
	t.total_songs,
	COALESCE(r.repeat_songs, 0) AS repeat_songs,
	ROUND(COALESCE(r.repeat_songs, 0)::DECIMAL / t.total_songs * 100, 2) AS repeat_ratio_percent
FROM total_counts t
LEFT JOIN repeat_counts r ON t.country = r.country
ORDER BY repeat_ratio_percent DESC;

CREATE OR REPLACE VIEW vw_country_retention_score AS
SELECT
    d.country,
    COUNT(DISTINCT d.spotify_id) AS total_unique_songs,
    ROUND(AVG(t.trend_duration), 2) AS avg_days_on_chart
FROM spotify_trend_duration t
JOIN spotify_daily d
    ON t.spotify_id = d.spotify_id
GROUP BY d.country
ORDER BY avg_days_on_chart DESC;


