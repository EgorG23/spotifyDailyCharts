from pathlib import Path

from logs.logger import setup_logger
from database import engine

logger = setup_logger("sql.py")


def run_sql_file(path):
    with open(path, "r") as f:
        sql = f.read()

    with engine.begin() as conn:
        conn.exec_driver_sql(sql)


def run_sql_create_script():
    BASE_DIR = Path(__file__).resolve().parent
    create_script_path = BASE_DIR / "sql_scripts/create_table.sql"
    run_sql_file(create_script_path)

    logger.info("Таблица успешно создана (проверена на существование)")
