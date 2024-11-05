import json
import pymysql

def lambda_handler(event, context):
    # 요청으로부터 학생 ID 수신
    student_id = event['student_id']
    
    # MariaDB 연결
    conn = pymysql.connect(
        host="YOUR_RDS_ENDPOINT",
        user="YOUR_USERNAME",
        password="YOUR_PASSWORD",
        db="IRT_Database",
        port=3306
    )
    cursor = conn.cursor()
    
    # 현재 θ 값 조회
    cursor.execute("SELECT theta_value FROM student_theta WHERE student_id = %s", (student_id,))
    theta_value = cursor.fetchone()[0]
    
    # 현재 θ 값에 따라 난이도가 적합한 문제를 선택 (예: 난이도가 θ 값보다 크지 않은 문제 중 랜덤 선택)
    cursor.execute("SELECT question_id, question_content FROM question_bank WHERE difficulty <= %s ORDER BY RAND() LIMIT 1", (theta_value,))
    selected_question = cursor.fetchone()
    
    conn.close()

    return {
        "statusCode": 200,
        "body": json.dumps({
            "question_id": selected_question[0],
            "question_content": selected_question[1]
        })
    }
