CREATE OR REPLACE VIEW top_10_songs_in_last_7days AS
WITH last_7_days AS (
    SELECT
        chart_date,
        ROW_NUMBER() OVER (ORDER BY chart_date DESC) AS day_n
    FROM (
        SELECT DISTINCT chart_date
        FROM spotify_daily_charts
    ) d
),
last_7_days_data AS (
    SELECT chart_date
    FROM last_7_days
    WHERE day_n <= 7
)
SELECT
    s.track_name,
    s.artist_names,
    SUM(s.streams) AS total_streams
FROM spotify_daily_charts s
JOIN last_7_days l
    ON s.chart_date = l.chart_date
GROUP BY s.track_name, s.artist_names
ORDER BY total_streams DESC
LIMIT 10;