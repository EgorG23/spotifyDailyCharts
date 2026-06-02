from logs.logger import setup_logger
from scripts.extract import extract
from scripts.load import load
from scripts.transform import transform

logger = setup_logger("piepline.py")


def pipeline():
    df = extract()
    df = transform(df)
    load(df)



pipeline()

logger.info("ETL закончил работу")
