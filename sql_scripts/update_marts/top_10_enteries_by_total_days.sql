CREATE OR REPLACE VIEW top_10_entries_by_total_days AS
SELECT
    track_name,
    artist_names,
    MAX(days_on_chart) AS total_days
FROM spotify_daily_charts
GROUP BY track_name, artist_names
ORDER BY total_days DESC
LIMIT 10;