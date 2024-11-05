import json
import pymysql

def lambda_handler(event, context):
    # 요청으로부터 학생 ID 수신
    student_id = event['student_id']
    
    # MariaDB에 연결
    conn = pymysql.connect(
        host="YOUR_RDS_ENDPOINT",
        user="YOUR_USERNAME",
        password="YOUR_PASSWORD",
        db="IRT_Database",
        port=3306
    )
    cursor = conn.cursor()
    
    # 응답 횟수 조회
    cursor.execute("SELECT COUNT(*) FROM student_responses WHERE student_id = %s", (student_id,))
    response_count = cursor.fetchone()[0]
    
    # θ 값 조회
    cursor.execute("SELECT theta_value FROM student_theta WHERE student_id = %s", (student_id,))
    current_theta = cursor.fetchone()[0]
    
    # 종료 조건 체크 (예: 응답 수가 10 이상이거나 θ 값이 특정 기준에 도달했는지)
    if response_count >= 10 or abs(current_theta) >= 2.5:
        status = "검사 종료"
        final_theta = current_theta
    else:
        status = "검사 진행 중"
        final_theta = None
    
    conn.close()

    # 종료 상태에 따른 응답
    if status == "검사 종료":
        return {
            "statusCode": 200,
            "body": json.dumps({
                "status": status,
                "final_theta": final_theta
            })
        }
    else:
        return {
            "statusCode": 200,
            "body": json.dumps({
                "status": status
            })
        }
