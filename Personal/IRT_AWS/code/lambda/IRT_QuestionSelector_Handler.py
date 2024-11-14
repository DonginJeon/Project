import json
import pymysql

def lambda_handler(event, context):
    student_id = event['student_id']

    # EC2 DB 연결
    conn = pymysql.connect(
        host="",
        user="",
        password="",
        db="",
        port=3306
    )
    cursor = conn.cursor()

    cursor.execute("SELECT theta_value FROM student_theta WHERE student_id = %s ORDER BY timestamp DESC LIMIT 1", (student_id,))
    theta_value = cursor.fetchone()[0]

    selected_question = "문제 예시"  # 실제 로직은 theta_value에 따라 구현

    conn.close()
    return {
        "statusCode": 200,
        "body": json.dumps({"selected_question": selected_question})
    }


