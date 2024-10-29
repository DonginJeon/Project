from datetime import datetime
from db.connector import DBconnector
from db.pgsql_query import queries
import db.pgsql_query as postgresql_query
from settings import DB_SETTINGS, TEMP_PATH
from pipeline.extract import extractor
from pipeline.transform import transformer
from pipeline.load import loader
from pipeline.remove import remover
import db.mysql_query as mysql_query
from db.mysql_query import queries


def controller(batch_date):
    # db_connector = DBconnector(**DB_SETTINGS["POSTGRES"])

    # for table_name in queries:
    #     pandas_df = extractor(db_connector, table_name)
    #     res = transformer(TEMP_PATH, batch_date, pandas_df, table_name)
    #     # print(res)
    #     if res is not None and not res.empty:
    #         db_connector = DBconnector(**DB_SETTINGS["POSTGRES"])
    #         loader(db_connector, pandas_df, table_name)

    #     remover(TEMP_PATH)

    table_list = list(mysql_query.queries.keys())

    for table_name in table_list:
        db_obj = DBconnector(**DB_SETTINGS["MYSQL"])

        pandas_df = extractor(db_obj, table_name)

        if len(pandas_df) > 0:

            res = transformer(TEMP_PATH, batch_date, pandas_df, table_name)

            if res is not None and not res.empty:
                db_connector = DBconnector(**DB_SETTINGS["MYSQL"])
                loader(db_connector, pandas_df, table_name)
                
                remover(TEMP_PATH)


if __name__ == "__main__":
    _date = datetime.now()
    batch_date = _date.strfttime('%Y%m%d')
    controller(batch_date)