import json
import pymysql
import numpy as np

# 3PL 문항 반응 함수
def irf_3pl(theta, a, b, c):
    return c + (1 - c) / (1 + np.exp(-1.7 * a * (theta - b)))

# θ 업데이트 함수
def update_theta(current_theta, response, a, b, c, learning_rate=0.1):
    P_correct = irf_3pl(current_theta, a, b, c)
    if response == 1:
        new_theta = current_theta + learning_rate * (1 - P_correct)
    else:
        new_theta = current_theta - learning_rate * P_correct
    return new_theta

# 문제 추천 함수
def recommend_question(new_theta, cursor):
    cursor.execute("""
        SELECT question_id, difficulty
        FROM question_bank
        ORDER BY 
            ABS(difficulty - %s) ASC,
            RAND()  -- 난이도가 같을 경우 무작위 선택
        LIMIT 1
    """, (new_theta,))
    next_question = cursor.fetchone()
    next_question_id = next_question[0]
    return next_question_id

# Lambda 핸들러
def lambda_handler(event, context):
    student_id = event['student_id']
    question_id = event['question_id']
    response = event['response']  # 1: 정답, 0: 오답

    # RDS DB 연결
    conn_rds = pymysql.connect(
        host="",
        user="",
        password="",
        db="",
        port= ""
    )
    cursor = conn_rds.cursor()

    # 현재 θ 값 조회
    cursor.execute("SELECT theta_value FROM student_theta WHERE student_id = %s", (student_id,))
    current_theta = cursor.fetchone()[0]

    # 문제의 변별도(a), 난이도(b), 추측도(c) 조회
    cursor.execute("SELECT discrimination, difficulty, guessing FROM question_bank WHERE question_id = %s", (question_id,))
    a, b, c = cursor.fetchone()

    # θ 업데이트
    new_theta = update_theta(current_theta, response, a, b, c)

    # 응답을 기록하고 θ 값을 업데이트
    cursor.execute("INSERT INTO student_responses (student_id, question_id, response) VALUES (%s, %s, %s)", (student_id, question_id, response))
    cursor.execute("UPDATE student_theta SET theta_value = %s WHERE student_id = %s", (new_theta, student_id))

    # 다음 문제 추천
    next_question_id = recommend_question(new_theta, cursor)

    # 데이터베이스 변경사항 커밋 및 연결 종료
    conn_rds.commit()
    conn_rds.close()

    # Lambda 함수 응답
    return {
        "statusCode": 200,
        "body": json.dumps({
            "updated_theta": new_theta,
            "next_question_id": next_question_id
        })
    }
