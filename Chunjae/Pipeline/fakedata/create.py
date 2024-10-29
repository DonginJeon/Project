from faker import Faker
import pandas as pd
import shortuuid

def create_fakedataframe(count: int) -> pd.DataFrame:
    fake_data_list = [create_fakeuser() for _ in range(count)]  # 함수 호출 추가
    return pd.DataFrame(fake_data_list)

def create_fakeuser() -> dict:
    fake = Faker("ko_KR")
    fake_profile = fake.profile()
    key_list = ["name", "ssn", "job", "residence", "blood_group", "sex", "birthdate"]

    fake_dict = {}

    for key in key_list:
        fake_dict[key] = fake_profile[key]
    
    fake_dict["uuid"] = shortuuid.uuid()
    fake_dict["birthdate"] = fake_dict["birthdate"].strftime("%Y%m%d")

    return fake_dict
    