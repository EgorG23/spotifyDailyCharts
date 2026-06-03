CREATE OR REPLACE VIEW top_10_artists_in_last_7days AS
WITH days AS (
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
    FROM days
    WHERE day_n <= 7
)

SELECT
    s.one_artist_name,
    SUM(s.streams) AS total_streams,
    MIN(s.chart_date),
    MAX(s.chart_date)
FROM spotify_daily_charts s
JOIN last_7_days_data d
    ON s.chart_date = d.chart_date
GROUP BY s.one_artist_name
ORDER BY total_streams DESC
LIMIT 10;