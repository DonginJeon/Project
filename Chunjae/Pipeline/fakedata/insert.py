import pandas as pd
from db.connector import DBconnector
from settings import DB_SETTINGS

def insert_fakedataframe(df: pd.DataFrame) -> bool:
    db_connector = DBconnector(**DB_SETTINGS["MYSQL"])

    with db_connector as connected:
        try:
            orm_conn = connected.orm_connect()
            df.to_sql(name = "fake", con = orm_conn, if_exists="append", index=False)
            return True
        
        except Exception as e:
            print(e)
            return False