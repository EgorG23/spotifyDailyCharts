CREATE TABLE IF NOT EXISTS spotify_daily_charts (
    rank INT NOT NULL CHECK (rank BETWEEN 1 AND 200),
    uri TEXT NOT NULL,
    track_name TEXT NOT NULL,
    artist_names TEXT NOT NULL,
    one_artist_name TEXT NOT NULL,
    source TEXT NOT NULL,
    previous_rank INT NOT NULL,
    peak_rank INT NOT NULL,
    days_on_chart INT NOT NULL,
    streams INT NOT NULL,
    chart_date TIMESTAMP WITH TIME ZONE NOT NULL,
    ingestion_time TIMESTAMP WITH TIME ZONE NOT NULL,
    source_file TEXT NOT NULL,

    PRIMARY KEY (track_name, one_artist_name, chart_date)
);
