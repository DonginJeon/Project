import json
import pymysql
import numpy as np

def lambda_handler(event, context):
    student_id = event['student_id']
    question_id = event['question_id']
    response = event['response']  # 1: 정답, 0: 오답

    conn_rds = pymysql.connect(
        host="irt-cat-db.cfsgom2iusui.ap-northeast-2.rds.amazonaws.com",
        user="admin",
        password="admin1234",
        db="irt_cat_db",
        port=3306
    )
    cursor_rds = conn_rds.cursor()

    conn_ec2 = pymysql.connect(
        host="54.180.248.114",
        user="root",
        password="1234",
        db="theta_db",
        port=3306
    )
    cursor_ec2 = conn_ec2.cursor()

    # 현재 θ 값 조회
    cursor_rds.execute("SELECT theta_value FROM student_theta WHERE student_id = %s", (student_id,))
    current_theta = cursor_rds.fetchone()[0]

    # 문제의 변별도(a), 난이도(b), 추측도(c) 조회
    cursor_rds.execute("SELECT discrimination, difficulty, guessing FROM question_bank WHERE question_id = %s", (question_id,))
    a, b, c = cursor_rds.fetchone()

    # 문제를 맞힐 확률 계산 (3PL 모델 사용)
    P_correct = c + (1 - c) / (1 + np.exp(-1.7 * a * (current_theta - b)))

    # 학습률 설정
    learning_rate = 0.1

    # θ 업데이트 로직
    if response == 1:  # 정답인 경우
        new_theta = current_theta + learning_rate * (1 - P_correct)
    else:  # 오답인 경우
        new_theta = current_theta - learning_rate * P_correct

    # 응답을 `student_responses` 테이블에 저장
    cursor_rds.execute("INSERT INTO student_responses (student_id, question_id, response) VALUES (%s, %s, %s)", (student_id, question_id, response))

    # θ 값 업데이트
    cursor_rds.execute("UPDATE student_theta SET theta_value = %s WHERE student_id = %s", (new_theta, student_id))
    cursor_ec2.execute("UPDATE student_theta SET theta_value = %s WHERE student_id = %s", (new_theta, student_id))

    conn_rds.commit()
    conn_rds.close()
    conn_ec2.commit()
    conn_ec2.close()

    return {
        "statusCode": 200,
        "body": json.dumps({"updated_theta": new_theta})
    }
