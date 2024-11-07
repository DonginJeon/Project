import json
import pymysql

def lambda_handler(event, context):
    student_id = event['student_id']

    # RDS 연결
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

    cursor_ec2.execute("SELECT theta_value FROM student_theta WHERE student_id = %s ORDER BY timestamp DESC LIMIT 1", (student_id,))
    final_theta = cursor_ec2.fetchone()[0]

    # 종료 조건 확인 (예: 응답 수가 10개 이상이면 종료)
    cursor_rds.execute("SELECT COUNT(*) FROM student_responses WHERE student_id = %s", (student_id,))
    response_count = cursor_rds.fetchone()[0]
    
    status = "검사 진행 중"
    if response_count >= 10:  # 종료 조건 충족 시
        status = "검사 종료"
        cursor_rds.execute("UPDATE student_theta SET theta_value = %s WHERE student_id = %s", (final_theta, student_id))
        conn_rds.commit()

    # 연결 종료
    conn_rds.close()
    conn_ec2.close()

    return {
        "statusCode": 200,
        "body": json.dumps({"status": status, "final_theta": final_theta if status == "검사 종료" else None})
    }
