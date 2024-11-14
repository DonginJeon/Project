import json
import pymysql
import numpy as np
from scipy.optimize import minimize

def irf_3pl(theta, a, b, c):
    """3PL 모델의 문항 반응 함수."""
    return c + (1 - c) / (1 + np.exp(-1.7 * a * (theta - b)))

def estimate_theta_3PL(response_matrix, a_list, b_list, c_list):
    """여러 문항을 사용하여 각 학생의 θ 값을 추정 (E-step)."""
    n_persons = response_matrix.shape[0]  # 학생 수
    thetas = np.zeros(n_persons)
    
    for j in range(n_persons):
        responses = response_matrix[j, :]
        
        def theta_log_likelihood_3PL(theta):
            p = irf_3pl(theta, a_list, b_list, c_list)
            p = np.clip(p, 1e-10, 1 - 1e-10)  # 수치 안정성 확보
            likelihood = np.sum(responses * np.log(p) + (1 - responses) * np.log(1 - p))
            return -likelihood

        result = minimize(theta_log_likelihood_3PL, 0, bounds=[(-3, 3)])
        thetas[j] = result.x[0]
    
    return thetas

def lambda_handler(event, context):
    student_id = event['student_id']
    question_ids = event['question_ids']  # 여러 문항 ID 리스트
    responses = event['responses']        # 각 문항에 대한 응답 리스트 (1: 정답, 0: 오답)

    # 데이터베이스 연결 설정
    conn_rds = pymysql.connect(
        host="",
        user="",
        password="",
        db="",
        port=3306
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

    # 학생의 현재 θ 값 조회
    cursor_rds.execute("SELECT theta_value FROM student_theta WHERE student_id = %s", (student_id,))
    current_theta = cursor_rds.fetchone()[0]

    # 여러 문항의 변별도(a), 난이도(b), 추측도(c) 값 조회
    a_list, b_list, c_list = [], [], []
    for question_id in question_ids:
        cursor_rds.execute("SELECT discrimination, difficulty, guessing FROM question_bank WHERE question_id = %s", (question_id,))
        a, b, c = cursor_rds.fetchone()
        a_list.append(a)
        b_list.append(b)
        c_list.append(c)

    # 응답 행렬 구성 (단일 학생에 대한 여러 문항 응답)
    response_matrix = np.array([responses])  # 2D 배열 형태로 변환

    # 새로운 θ 값 추정 (E-step 사용)
    new_theta = estimate_theta_3PL(response_matrix, a_list, b_list, c_list)[0]

    # 응답을 `student_responses` 테이블에 저장
    for question_id, response in zip(question_ids, responses):
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
