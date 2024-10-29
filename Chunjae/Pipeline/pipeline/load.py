import pandas as pd

def loader(db_connector, df, table_name):
    with db_connector as connected:
        try:
            orm_conn = connected.orm_conn
            df.to_sql(name=table_name, con=orm_conn, if_exists="append", index = False)
            return True

        except Exception as e:
            print(f"loader Error MSG: {e}")
            return False