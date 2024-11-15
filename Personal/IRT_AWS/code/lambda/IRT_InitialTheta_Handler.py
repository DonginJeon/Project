import json
import pymysql

def lambda_handler(event, context):
    student_id = event['student_id']
    initial_theta = 0.0  # 초기 세타 값

    # RDS 및 EC2 DB 연결
    conn_rds = pymysql.connect(
        host="",
        user="",
        password="",
        db="",
        port=""
    )
    cursor_rds = conn_rds.cursor()

    conn_ec2 = pymysql.connect(
        host="",
        user="",
        password="",
        db="",
        port=3306
    )
    cursor_ec2 = conn_ec2.cursor()


    # 초기 세타 값 저장
    cursor_rds.execute("INSERT INTO student_theta (student_id, theta_value) VALUES (%s, %s)", (student_id, initial_theta))
    cursor_ec2.execute("INSERT INTO student_theta (student_id, theta_value) VALUES (%s, %s)", (student_id, initial_theta))

    conn_rds.commit()
    conn_rds.close()
    conn_ec2.commit()
    conn_ec2.close()

    return {
        "statusCode": 200,
        "body": json.dumps({"initial_theta": initial_theta})
    }
