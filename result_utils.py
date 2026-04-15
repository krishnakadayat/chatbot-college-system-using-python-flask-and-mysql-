from db import get_db_connection

# Grade calculation
def calculate_grade(marks):
    if marks >= 90: return "A+", 4.0
    elif marks >= 80: return "A", 4.0
    elif marks >= 70: return "B+", 3.5
    elif marks >= 60: return "B", 3.0
    elif marks >= 50: return "C+", 2.5
    elif marks >= 40: return "C", 2.0
    else: return "F", 0.0

# Add a result
def add_result(student_id, subject, marks):
    grade, gpa = calculate_grade(marks)
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO results (student_id, subject, marks, grade, gpa)
        VALUES (%s, %s, %s, %s, %s)
    """, (student_id, subject, marks, grade, gpa))
    conn.commit()
    conn.close()
    return True

# Fetch all results
def fetch_results():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT r.*, s.name, s.roll_no
        FROM results r
        JOIN students s ON r.student_id = s.id
        ORDER BY r.id DESC
    """)
    results = cursor.fetchall()
    conn.close()
    return results

# Fetch analytics
def result_analytics():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT COUNT(*) AS total FROM results")
    total = cursor.fetchone()['total']
    cursor.execute("SELECT COUNT(*) AS passed FROM results WHERE marks >= 40")
    passed = cursor.fetchone()['passed']
    conn.close()
    pass_percent = round((passed / total) * 100, 2) if total else 0
    return total, passed, pass_percent

# Publish result
def publish_result(result_id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE results SET status='published' WHERE id=%s", (result_id,))
    conn.commit()
    conn.close()