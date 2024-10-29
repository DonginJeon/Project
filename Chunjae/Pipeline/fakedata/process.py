import pandas as pd
import numpy as np


def create_fakedatamart(df: pd.DataFrame) -> pd.DataFrame:

    # 도시 컬럼
    df['city'] = df['residence'].str.split().str[0]
    # 생년월일 컬럼
    df['birthdate']
    # 나이 컬럼
    df['age'] = 2024 - df['birthdate'].str[:4].astype(int)
    # 혈액형 컬럼
    df['blood'] = df['blood_group'].str[:1]
    # 나이대 컬럼
    df["age_category"] = np.where(df["age"] >= 90, "90대 이상", (df["age"] // 10 * 10).astype(str) + "대")

    column_list = ["uuid", "name", "job", "sex", "blood", "city", "birthdate","age","age_category"]
    df_datamart = df[column_list]
    return df_datamart

