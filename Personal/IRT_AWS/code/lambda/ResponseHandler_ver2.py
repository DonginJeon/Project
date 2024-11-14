import json
import pymysql
import numpy as np
from scipy.optimize import minimize

# 3PL 문항 반응 함수
def irf_3pl(theta, a, b, c):
    return c + (1 - c) / (1 + np.exp(-1.7 * a * (theta - b)))

# 로그우도 함수 (Log-Likelihood)
def log_likelihood_3PL(params, responses, theta):
    a, b, c = params
    p = irf_3pl(theta, a, b, c)
    p = np.clip(p, 1e-10, 1 - 1e-10)  # 수치 안정성을 위한 클리핑
    likelihood = np.sum(responses * np.log(p) + (1 - responses) * np.log(1 - p))
    return -likelihood  # 최소화 문제로 변환

# E-step: 능력값 추정 (여러 문항을 사용)
def estimate_theta_3PL(response_matrix, a_list, b_list, c_list):
    n_items = response_matrix.shape[1]  # 문항 수
    n_persons = response_matrix.shape[0]  # 피험자 수
    thetas = np.zeros(n_persons)
    
    for j in range(n_persons):
        responses = response_matrix[j, :]
        
        # 각 문항의 문항 모수를 적용하여 우도 함수 정의
        def theta_log_likelihood_3PL(theta):
            log_likelihood = 0
            for i in range(n_items):
                p = irf_3pl(theta, a_list[i], b_list[i], c_list[i])
                p = np.clip(p, 1e-10, 1 - 1e-10)  # 수치 안정성을 위한 클리핑
                log_likelihood += responses[i] * np.log(p) + (1 - responses[i]) * np.log(1 - p)
            return -log_likelihood

        # 최적화를 통해 theta 값을 추정
        result = minimize(theta_log_likelihood_3PL, 0, bounds=[(-3, 3)])
        thetas[j] = result.x[0]
    
    return thetas

# 다음 문제 추천 함수 (3PL 모수 고려)
def recommend_question(new_theta, cursor, student_id):
    cursor.execute("""
        SELECT question_id, discrimination, difficulty, guessing
        FROM question_bank
        WHERE question_id NOT IN (
            SELECT question_id FROM student_responses WHERE student_id = %s
        )
    """, (student_id,))
    
    questions = cursor.fetchall()
    best_question_id = None
    best_fit_score = -np.inf

    # 각 문항에 대해 적합도를 계산하여 가장 적합한 문항을 선택
    for question_id, a, b, c in questions:
        fit_score = irf_3pl(new_theta, a, b, c)
        
        if fit_score > best_fit_score:
            best_fit_score = fit_score
            best_question_id = question_id

    return best_question_id

# Lambda 핸들러 함수
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
        port=3306
    )
    cursor_rds = conn_rds.cursor()

    # EC2 DB 연결
    conn_ec2 = pymysql.connect(
        host="",
        user="",
        password="",
        database="",
        port=3306
    )
    cursor_ec2 = conn_ec2.cursor()

    # 학생의 기존 응답 기록 및 문항 파라미터 가져오기 (EC2에서 조회)
    cursor_ec2.execute("SELECT question_id, response FROM student_responses WHERE student_id = %s", (student_id,))
    responses_data = cursor_ec2.fetchall()
    
    # 학생이 응답한 문항 리스트와 응답값 배열을 생성
    question_ids = [row[0] for row in responses_data]
    response_values = [row[1] for row in responses_data]

    # 문항 파라미터 (a, b, c) 가져오기 (EC2에서 조회)
    a_list, b_list, c_list = [], [], []
    for q_id in question_ids:
        cursor_ec2.execute("SELECT discrimination, difficulty, guessing FROM question_bank WHERE question_id = %s", (q_id,))
        a, b, c = cursor_ec2.fetchone()
        a_list.append(a)
        b_list.append(b)
        c_list.append(c)

    # 기존 응답 데이터를 행렬로 변환
    response_matrix = np.array([response_values])

    # θ 업데이트
    new_theta = estimate_theta_3PL(response_matrix, a_list, b_list, c_list)[0]

    # 응답 기록을 EC2에 저장
    cursor_ec2.execute(
        "INSERT INTO student_responses (student_id, question_id, response) VALUES (%s, %s, %s)", 
        (student_id, question_id, response)
    )

    # θ 이력을 RDS에 저장
    cursor_rds.execute(
        "INSERT INTO student_theta_history (student_id, question_id, theta_value) VALUES (%s, %s, %s)", 
        (student_id, question_id, new_theta)
    )
    
    # 현재 θ 값을 RDS에 업데이트
    cursor_rds.execute(
        "UPDATE student_theta SET theta_value = %s WHERE student_id = %s", 
        (new_theta, student_id)
    )

    # 다음 문제 추천 (EC2에서 문제 데이터 조회)
    next_question_id = recommend_question(new_theta, cursor_ec2, student_id)

    # 변경사항 커밋 및 연결 종료
    conn_rds.commit()
    conn_ec2.commit()
    conn_rds.close()
    conn_ec2.close()

    return {
        "statusCode": 200,
        "body": json.dumps({
            "updated_theta": new_theta,
            "next_question_id": next_question_id
        })
    }
