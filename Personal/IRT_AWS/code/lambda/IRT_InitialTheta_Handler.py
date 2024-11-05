import json
import pymysql

def lambda_handler(event, context):
    # 요청으로부터 학생 ID 수신
    student_id = event['student_id']
    initial_theta = 0.0  # 초기 θ 값 설정

    # MariaDB에 연결
    conn = pymysql.connect(
        host="YOUR_RDS_ENDPOINT",
        user="YOUR_USERNAME",
        password="YOUR_PASSWORD",
        db="IRT_Database",
        port=3306
    )
    cursor = conn.cursor()
    
    # 초기 θ 값을 `pre_info` 테이블에 저장
    cursor.execute("INSERT INTO pre_info (student_id, initial_theta) VALUES (%s, %s)", (student_id, initial_theta))
    # 초기 θ 값을 `student_theta` 테이블에도 저장하여 추후 업데이트에 사용
    cursor.execute("INSERT INTO student_theta (student_id, theta_value) VALUES (%s, %s)", (student_id, initial_theta))
    
    conn.commit()
    conn.close()

    return {
        "statusCode": 200,
        "body": json.dumps({"initial_theta": initial_theta})
    }
