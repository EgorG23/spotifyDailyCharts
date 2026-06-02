import os
from io import StringIO

from logs.logger import setup_logger
from database import engine
from scripts.update_marts import update_marts
from sql import run_sql_create_script

logger = setup_logger("load.py")

TABLE_NAME = os.getenv("MAIN_TABLE_TITLE")


def load(df):
    run_sql_create_script()
    logger.info("Таблица проверена/создана")

    if df.empty:
        logger.warning("Пустой DataFrame — загрузка пропущена")
        return

    logger.info(f"Загрузка {len(df)} строк в {TABLE_NAME}")

    with engine.begin() as conn:
        copy_df(conn, df, TABLE_NAME)
        update_marts(conn)

    logger.info("Загрузка завершена")


def copy_df(conn, df, table):
    buffer = StringIO()

    columns = [
        "rank",
        "uri",
        "track_name",
        "artist_names",
        "one_artist_name",
        "source",
        "previous_rank",
        "peak_rank",
        "days_on_chart",
        "streams",
        "chart_date",
        "ingestion_time",
        "source_file"
    ]

    df = df[columns]

    df.to_csv(buffer, index=False, header=True)
    buffer.seek(0)

    sql = f"""
        COPY {table}
        FROM STDIN
        WITH (
            FORMAT CSV,
            HEADER TRUE
        )
    """

    with conn.connection.cursor() as cur:
        cur.copy_expert(sql, buffer)