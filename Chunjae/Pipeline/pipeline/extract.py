import pandas as pd

def extractor(db_connector, table_name):
    with db_connector as connected:
        try:
            _query = connected.get_query(table_name)
            con = connected.conn
            df = pd.read_sql(_query, con)
            return df
        except Exception as e:
            print(f"Extract MSG: {e}")
            return False