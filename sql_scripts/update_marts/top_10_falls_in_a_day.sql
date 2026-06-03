CREATE OR REPLACE VIEW top_10_falls_in_a_day AS
WITH latest_day AS (
    SELECT MAX(chart_date) AS max_date
    FROM spotify_daily_charts
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
    track_name,
    artist_names,
    chart_date,
    previous_rank,
    rank,
    rank - previous_rank AS rank_drop
FROM deduplicated
WHERE previous_rank != -1 AND chart_date = (
    SELECT max_date
    FROM latest_day
    )
ORDER BY rank_drop DESC
LIMIT 10;