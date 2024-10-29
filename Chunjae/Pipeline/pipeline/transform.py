# transformer(create_path + save_to_file) 함수
from datetime import datetime
import os



def create_path(temp_path, batch_date, table_name):
    _y = batch_date[:4]
    _m = batch_date[4:6]
    _d = batch_date[6:]

    _path = os.path.join(temp_path, table_name, f"yyyy={_y}",f"yyyy={_m}",f"yyyy={_d}")

    return _path

def save_to_file(df, path, table_name):
    if len(df) > 0:
        os.makedirs(path, mode= 777)
        save_path = os.path.join(path, f'{table_name}.csv')

        df.to_csv(save_path)
        return True
    
    else:
        print("EMPTY FILE")
        return False

def transformer(temp_path, batch_date, df, table_name):
    path = create_path(temp_path, batch_date,table_name)
    save_to_file(df, path, table_name)

    return df