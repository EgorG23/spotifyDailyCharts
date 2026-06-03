CREATE OR REPLACE FUNCTION get_artist_history(
    artist_input TEXT
)
RETURNS
TABLE (
    chart_date DATE,
    track_name TEXT,
    total_streams BIGINT
)
AS $$
BEGIN
    RETURN QUERY

    SELECT
        s.chart_date,
        s.track_name,
        SUM(s.streams)
    FROM spotify_daily_charts s
    WHERE s.one_artist_name = artist_input
    GROUP BY s.chart_date
    ORDER BY s.chart_date;

END;
$$ LANGUAGE plpgsql;