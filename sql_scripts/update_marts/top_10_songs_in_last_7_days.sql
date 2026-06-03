CREATE OR REPLACE VIEW top_10_songs_in_last_7days AS
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
),

deduplicated AS (
    SELECT DISTINCT ON (track_name, artist_names, chart_date)
        *
    FROM spotify_daily_charts
    ORDER BY
        track_name,
        artist_names,
        chart_date
)

SELECT
    s.track_name,
    s.artist_names,
    SUM(s.streams) AS total_streams,
    MIN(s.chart_date),
    MAX(s.chart_date)
FROM deduplicated s
JOIN last_7_days_data l
    ON s.chart_date = l.chart_date
GROUP BY s.track_name, s.artist_names
ORDER BY total_streams DESC
LIMIT 10;