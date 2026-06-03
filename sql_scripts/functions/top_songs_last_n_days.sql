CREATE OR REPLACE FUNCTION top_songs_last_n_days(n INT)
RETURNS TABLE (
    track_name TEXT,
    artist_names TEXT,
    total_streams BIGINT
)
LANGUAGE SQL
AS $$
WITH latest_day AS (
    SELECT MAX(chart_date) AS max_date
    FROM spotify_daily_charts
),

deduplicated AS (
    SELECT DISTINCT ON (track_name, artist_names, chart_date)
        track_name,
        artist_names,
        chart_date,
        streams
    FROM spotify_daily_charts
    ORDER BY
        track_name,
        artist_names,
        chart_date
)

SELECT
    s.track_name,
    s.artist_names,
    SUM(s.streams) AS total_streams
FROM deduplicated s
JOIN latest_day ld
    ON s.chart_date >= ld.max_date - (n - 1)
GROUP BY
    s.track_name,
    s.artist_names
ORDER BY
    total_streams DESC
LIMIT 10;
$$;