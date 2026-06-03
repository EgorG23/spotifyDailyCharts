CREATE OR REPLACE VIEW top_new_songs_by_streams AS
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
    streams,
    rank
FROM deduplicated
WHERE previous_rank = -1 AND chart_date = (
    SELECT max_date
    FROM latest_day
    )
ORDER BY streams DESC
LIMIT 10;