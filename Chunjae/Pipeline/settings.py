import os
import dotenv


env_path = dotenv.find_dotenv()
dotenv.load_dotenv(env_path)

TEMP_PATH = "C:\\Users\\user\\Desktop\\Pipeline_빅데이터9기_전동인\\temp_storage"

DB_SETTINGS = {
    "POSTGRES": {
        'engine' : os.getenv("POSTGRES_ENGINE"),
        'orm_engine' : os.getenv("POSTGRES_ENGINE"),
        'host': os.getenv("POSTGRES_HOST"),
        'database': os.getenv("POSTGRES_DB"),
        'user': os.getenv("POSTGRES_USER"),
        'password': os.getenv("POSTGRES_PASSWORD"),
        'port': os.getenv("POSTGRES_PORT")
    },
    
    "KDT9": {
        'engine' : os.getenv("POSTGRES_ENGINE"),
        'orm_engine' : os.getenv("POSTGRES_ENGINE"),
        'host': os.getenv("POSTGRES_HOST"),
        'database': os.getenv("POSTGRES_DB_2"),
        'user': os.getenv("POSTGRES_USER"),
        'password': os.getenv("POSTGRES_PASSWORD"),
        'port': os.getenv("POSTGRES_PORT")
    },
    "MYSQL": {
        'engine': 'mysql',  # MySQL 엔진 이름으로 설정
        'orm_engine': 'mysql+mysqlconnector',  # SQLAlchemy용 MySQL 엔진
        'host': os.getenv('MYSQL_HOST'),
        'port': os.getenv('MYSQL_PORT'),
        'user': os.getenv('MYSQL_USER'),
        'password': os.getenv('MYSQL_PASSWORD'),
        'database': os.getenv('MYSQL_DATABASE')
    },
}