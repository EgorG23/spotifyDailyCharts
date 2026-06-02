CREATE OR REPLACE VIEW top_10_songs_history_for_7_days AS
WITH latest_day AS (
    SELECT MAX(chart_date) AS max_date
    FROM spotify_daily_charts
),

top10ofLastWeek AS (
    SELECT
        track_name,
        artist_names
    FROM spotify_daily_charts
    WHERE chart_date = (SELECT max_date FROM latest_day)
    ORDER BY rank
    LIMIT 10
)

SELECT
    s.track_name,
    s.artist_names,
    s.chart_date,
    s.rank,
    s.streams
FROM spotify_daily_charts s
JOIN top10ofLastWeek t
    ON s.track_name = t.track_name
    AND s.artist_names = t.artist_names
WHERE s.chart_date >= (SELECT max_date FROM latest_day) - INTERVAL '6 days'
ORDER BY s.track_name, s.artist_names, s.chart_date;