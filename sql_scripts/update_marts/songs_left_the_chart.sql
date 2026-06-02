CREATE OR REPLACE VIEW songs_left_the_chart AS
WITH latest_days AS (
    SELECT
        MAX(chart_date) AS max_date,
        MAX(chart_date) - INTERVAL '1 day' AS pre_max_date
    FROM spotify_daily_charts
),

prev_last_day AS (
    SELECT *
    FROM spotify_daily_charts
    WHERE chart_date = (SELECT pre_max_date FROM latest_days)
),

last_day AS (
    SELECT *
    FROM spotify_daily_charts
    WHERE chart_date = (SELECT max_date FROM latest_days)
)

SELECT
    p.track_name,
    p.artist_names,
    p.chart_date,
    p.rank,
    p.streams
FROM prev_last_day p
LEFT JOIN last_day l
ON p.track_name = l.track_name
AND p.artist_names = l.artist_names
WHERE l.rank IS NULL;

