from datetime import UTC, datetime
from pathlib import Path

import pandas as pd

from logs.logger import setup_logger

logger = setup_logger("extract.py")

BASE_DIR = Path(__file__).resolve().parent.parent
INPUT_DIR = BASE_DIR / "data/initial"


def extract():
    data = []

    for file in INPUT_DIR.glob("*.csv"):
        try:
            df = pd.read_csv(file)
        except Exception as e:
            logger.error(f"Ошибка чтения {file.stem}: {e}")
            raise

        if df.empty:
            logger.error(f"Нет данных в {file.stem}")
            raise ValueError("Данные не найдены")

        try:
            df["source_file"] = file.stem
            df["ingestion_time"] = datetime.now(UTC).isoformat()
            print(df.columns)
        except Exception as e:
            logger.error(f"Ошибка обработки в {file.stem}: {e}")
            raise

        try:
            data.append(df)
        except Exception as e:
            logger.error(f"Ошибка обработки в {file.stem}: {e}")
            raise

        logger.info(f"Данные успешно получены из {file.stem}")

    return pd.concat(data, ignore_index=True)
