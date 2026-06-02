from pathlib import Path

from logs.logger import setup_logger

BASE_DIR = Path(__file__).resolve().parent.parent
SCRIPTS_DIR = BASE_DIR / "sql_scripts/update_marts"

logger = setup_logger("update_marts.py")


def update_marts(conn):
    sql_files = sorted(SCRIPTS_DIR.glob("*.sql"))

    for sql_file in sql_files:
        with open(sql_file, "r", encoding="utf-8") as f:
            query = f.read()

        conn.exec_driver_sql(query)

        logger.info(f"Выполнен {sql_file.name}")