CREATE OR REPLACE VIEW top_10_entries_by_total_days AS
WITH deduplicated AS (
    SELECT DISTINCT ON (track_name, artist_names, chart_date)
        *
    FROM spotify_daily_charts
    ORDER BY
        track_name,
        artist_names,
        chart_date
)

SELECT
    track_name,
    artist_names,
    MAX(days_on_chart) AS total_days,
    MAX(chart_date) AS last_record
FROM deduplicated
GROUP BY track_name, artist_names
ORDER BY total_days DESC
LIMIT 10;