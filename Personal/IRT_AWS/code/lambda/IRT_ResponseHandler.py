import json
import pymysql
import numpy as np

def lambda_handler(event, context):
    # 요청으로부터 데이터 수신
    student_id = event['student_id']
    question_id = event['question_id']
    response = event['response']  # 1: 정답, 0: 오답
    
    # MariaDB에 연결
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
    current_theta = cursor.fetchone()[0]
    
    # 문제의 변별도(a), 난이도(b), 추측도(c) 조회
    cursor.execute("SELECT discrimination, difficulty, guessing FROM question_bank WHERE question_id = %s", (question_id,))
    a, b, c = cursor.fetchone()
    
    # 문제를 맞힐 확률 계산 (3PL 모델 사용)
    P_correct = c + (1 - c) / (1 + np.exp(-1.7 * a * (current_theta - b)))
    
    # 학습률 설정 (예: 0.1)
    learning_rate = 0.1
    
    # θ 업데이트 로직
    if response == 1:  # 정답인 경우
        new_theta = current_theta + learning_rate * (1 - P_correct)
    else:  # 오답인 경우
        new_theta = current_theta - learning_rate * P_correct
    
    # 응답을 `student_responses` 테이블에 저장
    cursor.execute("INSERT INTO student_responses (student_id, question_id, response) VALUES (%s, %s, %s)", (student_id, question_id, response))
    
    # θ 값 업데이트
    cursor.execute("UPDATE student_theta SET theta_value = %s WHERE student_id = %s", (new_theta, student_id))
    conn.commit()
    conn.close()

    return {
        "statusCode": 200,
        "body": json.dumps({"updated_theta": new_theta})
    }
