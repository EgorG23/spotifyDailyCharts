import pandas as pd
from logs.logger import setup_logger
logger = setup_logger("transform.py")


def transform(df: pd.DataFrame) -> pd.DataFrame:

    if df.empty:
        raise ValueError("Empty dataset")

    df = df.drop_duplicates()

    df["chart_date"] = (df["source_file"].str.extract(r"(\d{4}-\d{2}-\d{2})")[0])
    df["chart_date"] = pd.to_datetime(df["chart_date"]).dt.date

    df["rank"] = df["rank"].astype(int)
    df["uri"] = df["uri"].astype(str)
    df["track_name"] = df["track_name"].astype(str)
    df["source"] = df["source"].astype(str)
    df["peak_rank"] = df["peak_rank"].astype(int)
    df["previous_rank"] = df["previous_rank"].astype(int)
    df["days_on_chart"] = df["days_on_chart"].astype(int)
    df["streams"] = df["streams"].astype(int)

    df["artist_names"] = df["artist_names"].str.replace("Tyler, The Creator", "Tyler The Creator")

    df["one_artist_name"] = df["artist_names"].str.split(", ")
    df = df.explode("one_artist_name")
    df["one_artist_name"] = df["one_artist_name"].astype(str)

    return df
