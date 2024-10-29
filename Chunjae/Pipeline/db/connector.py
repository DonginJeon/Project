import psycopg2
import db.pgsql_query as postgresql_query
import db.mysql_query as mysql_query
import mysql.connector  # MySQL Connector 추가


from sqlalchemy import create_engine
from settings import DB_SETTINGS



class DBconnector:
    def __init__(self, engine, orm_engine, host, database, user, password, port):
        self.engine = engine
        self.orm_engine = orm_engine
        self.conn_params = dict(
            host=host,
            database=database,
            user=user,
            password=password,
            port=port
        )

        # 엔진에 따른 SQLAlchemy URL 구성
        if self.engine == 'mysql':
            self.orm_conn_params = f"mysql+mysqlconnector://{user}:{password}@{host}:{port}/{database}"
        elif self.engine == 'postgresql':
            self.orm_conn_params = f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{database}"
        else:
            raise ValueError("지원하지 않는 엔진입니다. 'mysql' 또는 'postgresql'을 사용하세요.")

        # ORM 연결 생성
        self.orm_connect()

        # 데이터베이스 엔진에 따라 연결 및 쿼리 설정
        if self.engine == 'postgresql':
            self.connect = self.postgres_connect()
            self.queries = postgresql_query.queries

        elif self.engine == 'mysql':
            self.connect = self.mysql_connect()
            self.queries = mysql_query.queries

    def __enter__(self):
        print("접속")
        return self
    
    def __exit__(self, exe_type, exe_value, traceback):
        self.conn.close()
        print("종료")

    def orm_connect(self):
        self.orm_conn = create_engine(self.orm_conn_params)
        return self.orm_conn

    def postgres_connect(self):
        self.conn = psycopg2.connect(**self.conn_params)
        return self
    
    def mysql_connect(self):
        self.conn = mysql.connector.connect(**self.conn_params)
        return self
    
    def get_query(self, table_name):
        _query = self.queries.get(table_name)
        return _query