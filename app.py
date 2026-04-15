from flask import Flask, render_template, request, redirect, url_for, session, flash
from chatbot_utils import process_user_message  # ✅ This is the key
from result_utils import add_result, fetch_results, result_analytics, publish_result # for result
from db import get_db_connection  # Your DB connection function
import mysql.connector
import re
from werkzeug.security import generate_password_hash
import nltk
import string
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from flask import Response

#for resetpassword

from flask_mail import Mail, Message
import random
from datetime import datetime, timedelta


def analyze_college_question(message):
    msg = message.lower()

    for item in college_qa:
        keywords = item["question"].split()
        match_count = 0

        for word in keywords:
            if word in msg:
                match_count += 1

        if match_count >= 2:
            return item["answer"]

    return None


def calculate_grade(marks):
    if marks >= 80: return "A", 4.0
    elif marks >= 70: return "B+", 3.6
    elif marks >= 60: return "B", 3.2
    elif marks >= 50: return "C+", 2.8
    elif marks >= 40: return "C", 2.4
    else: return "F", 0.0


COLLEGE_INFO = {
    "name": "Far Western College",
    "location": "Dhangadhi, Kailali",
    "contact": "091-123456, info@fwcollege.edu.np",
    "timing": "Sunday to Friday, 6:30 AM – 5:00 PM",
    "admission": "Admission is open. You can apply online or visit the college.",
    "courses": "BSc CSIT, BCA, BIM, BBM",
    "fee": "Fee depends on course. Please contact administration for details.",
    "scholarship": "Scholarships are available for deserving and needy students."
}

def analyze_college_question(msg):
    msg = msg.lower()

    if any(w in msg for w in ['course', 'program', 'study']):
        return COLLEGE_INFO['courses']
    if any(w in msg for w in ['fee', 'cost', 'price']):
        return COLLEGE_INFO['fee']
    if any(w in msg for w in ['admission', 'apply', 'join']):
        return COLLEGE_INFO['admission']
    if any(w in msg for w in ['location', 'address', 'where']):
        return COLLEGE_INFO['location']
    if any(w in msg for w in ['contact', 'phone', 'email']):
        return COLLEGE_INFO['contact']
    if any(w in msg for w in ['time', 'open', 'office']):
        return COLLEGE_INFO['timing']
    if any(w in msg for w in ['scholarship', 'discount']):
        return COLLEGE_INFO['scholarship']

    return None



app = Flask(__name__)
app.secret_key = 'mero_secret_key'  # Session को लागि गोप्य key

#for secure email
EMAIL_REGEX = r'^[A-Za-z][A-Za-z0-9._%+-]*@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'

'''# Database Connection Function
def get_db_connection():
    conn = mysql.connector.connect(
        host='localhost',
        user='root',        # आफ्नो MySQL username राख्नुहोस
        password='',        # आफ्नो MySQL password राख्नुहोस
        database='college_db'
    )
    return conn'''
# -------------------- Home Page --------------------
@app.route('/')
def home():
    return render_template('home.html')  # This loads first

# -------------------- Login Page --------------------
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM users WHERE username=%s AND password=%s", (username, password))
        user = cursor.fetchone()
        cursor.close()
        conn.close()

        if user:
            session['loggedin'] = True
            session['user_id'] = user['id']   # ✅ FIX HERE
            session['username'] = user['username']
            return redirect(url_for('user_home'))
        else:
            flash('Username वा Password मिलेन!', 'danger')
            
    return render_template('login.html')

# -------------------- Register Page --------------------
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email'].strip().lower()
        password = request.form['password']

        # ✅ Email validation
        if not re.match(EMAIL_REGEX, email):
            flash("Email अक्षरबाट सुरु हुनुपर्छ र valid हुनुपर्छ!", "danger")
            return redirect('/register')

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "INSERT INTO users (username, email, password) VALUES (%s, %s, %s)",
            (username, email, password)
        )

        conn.commit()
        conn.close()

        flash('Register सफलतापूर्वक थपियो!', 'success')
        return redirect(url_for('login'))

    return render_template('register.html', action='register')

#for password reset
# -------------------- MAIL CONFIG --------------------
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = 'krishnakadayat112@gmail.com'
app.config['MAIL_PASSWORD'] = 'vtpe vjmj itcb rfls'  # App password

mail = Mail(app)

# -------------------- ROUTE 1: FORGOT PASSWORD --------------------
@app.route('/forgot-password', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'POST':
        email = request.form['email']

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM users WHERE email=%s", (email,))
        user = cursor.fetchone()

        if user:
            otp = str(random.randint(100000, 999999))
            expiry = datetime.now() + timedelta(minutes=5)

            cursor.execute("""
                UPDATE users SET otp=%s, otp_expiry=%s WHERE email=%s
            """, (otp, expiry, email))
            conn.commit()

            # Send OTP Email
            msg = Message("Password Reset OTP",
                          sender=app.config['MAIL_USERNAME'],
                          recipients=[email])
            msg.body = f"Your OTP is: {otp}"
            mail.send(msg)

            conn.close()
            session['reset_email'] = email
            return redirect('/verify-otp')
        else:
            return "Email not found"
    return render_template('forget_password.html')


# -------------------- ROUTE 2: VERIFY OTP --------------------
@app.route('/verify-otp', methods=['GET', 'POST'])
def verify_otp():
    if request.method == 'POST':
        user_otp = request.form['otp']
        email = session.get('reset_email')

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT otp, otp_expiry FROM users WHERE email=%s", (email,))
        user = cursor.fetchone()

        if user:
            if user_otp == user['otp'] and datetime.now() <= user['otp_expiry']:
                return redirect('/reset-password')
            else:
                return "Invalid or expired OTP"

        conn.close()
    return render_template('verify_otp.html')


# -------------------- ROUTE 3: RESET PASSWORD --------------------
@app.route('/reset-password', methods=['GET', 'POST'])
def reset_password():
    if request.method == 'POST':
        new_password = request.form['password']
        email = session.get('reset_email')

        hashed_password = generate_password_hash(new_password)

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            UPDATE users 
            SET password=%s, otp=NULL, otp_expiry=NULL 
            WHERE email=%s
        """, (hashed_password, email))
        conn.commit()
        conn.close()

        session.pop('reset_email', None)
        return "Password updated successfully ✅"

    return render_template('reset_password.html')




# 2. Dashboard (Enquiry List) - Read Operation
@app.route('/dashboard')
def dashboard():
    if 'loggedin' not in session:
        return redirect(url_for('login'))
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM enquiries ORDER BY id DESC")
    enquiries = cursor.fetchall()
    cursor.close()
    conn.close()
    
    return render_template('dashboard.html', enquiries=enquiries)

# 3. Add Enquiry - Create Operation
@app.route('/add', methods=['GET', 'POST'])
def add_enquiry():
    if 'loggedin' not in session: return redirect(url_for('login'))

    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        phone = request.form['phone']
        course = request.form['course']
        message = request.form['message']

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO enquiries (name, email, phone, course, message) VALUES (%s, %s, %s, %s, %s)", 
                       (name, email, phone, course, message))
        conn.commit()
        conn.close()
        flash('Enquiry सफलतापूर्वक थपियो!', 'success')
        return redirect(url_for('dashboard'))

    return render_template('add_edit.html', action='Add')

# 4. Edit Enquiry - Update Operation
@app.route('/edit/<int:id>', methods=['GET', 'POST'])
def edit_enquiry(id):
    if 'loggedin' not in session: return redirect(url_for('login'))
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        phone = request.form['phone']
        course = request.form['course']
        message = request.form['message']
        
        cursor.execute("UPDATE enquiries SET name=%s, email=%s, phone=%s, course=%s, message=%s WHERE id=%s",
                       (name, email, phone, course, message, id))
        conn.commit()
        conn.close()
        flash('Enquiry अपडेट भयो!', 'success')
        return redirect(url_for('dashboard'))
    
    cursor.execute("SELECT * FROM enquiries WHERE id=%s", (id,))
    enquiry = cursor.fetchone()
    conn.close()
    return render_template('add_edit.html', action='Edit', enquiry=enquiry)

# 5. Delete Enquiry - Delete Operation
@app.route('/delete/<int:id>')
def delete_enquiry(id):
    if 'loggedin' not in session: return redirect(url_for('login'))
    
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM enquiries WHERE id=%s", (id,))
    conn.commit()
    conn.close()
    flash('Enquiry हटाइयो!', 'warning')
    return redirect(url_for('dashboard'))

# Logout
@app.route('/logout')
def logout():
    session.pop('loggedin', None)
    return redirect(url_for('home'))

#for the search function
@app.route('/search', methods=['GET'])
def search():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    search_query = request.args.get('search', '').strip()

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if search_query != "":
        cursor.execute("""
            SELECT * FROM enquiries
            WHERE name LIKE %s
               OR email LIKE %s
               OR phone LIKE %s
               OR course LIKE %s
            ORDER BY id DESC
        """, (
            f"%{search_query}%",
            f"%{search_query}%",
            f"%{search_query}%",
            f"%{search_query}%"
        ))
    else:
        cursor.execute("SELECT * FROM enquiries ORDER BY id DESC")

    enquiries = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template(
        'search.html',
        enquiries=enquiries,
        search_query=search_query
    )

# for chatbot function
def preprocess(text):
    text = text.lower()
    text = "".join([c for c in text if c not in string.punctuation])
    return text

#for qa table and greeting
def get_answer_from_db(user_message):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT question, answer 
        FROM qa_table
        WHERE question LIKE %s
    """, ("%" + user_message + "%",))

    result = cursor.fetchone()
    conn.close()

    if result:
        return result["answer"]

    return None


@app.route("/chatbot", methods=["GET", "POST"])
def chatbot():
    if "loggedin" not in session:
        return redirect(url_for("login"))

    # Initialize session
    if "chat_started" not in session:
        session["chat_messages"] = [{
            "user": None,
            "bot": "Hello 👋 I'm your college assistant bot. How can I help you today?"
        }]
        session["chat_started"] = True
        session.modified = True

    if request.method == "POST":
        user_msg = request.form.get("message", "").strip()

        if user_msg:
            process_user_message(user_msg)  # Call secondary file function

    return render_template("chatbot.html", chats=session["chat_messages"])

    
@app.route('/chat-history')
def chat_history():
    # 🔹 Ensure user is logged in
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    try:
        # 🔹 Connect to database
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # 🔹 Fetch all chat messages (latest first)
        cursor.execute("""
            SELECT id, user_message, bot_response, created_at
            FROM chat_history
            ORDER BY created_at DESC
        """)
        chats = cursor.fetchall()

        conn.close()
    except Exception as e:
        print("Error fetching chat history:", e)
        chats = []

    # 🔹 Render template with chats
    return render_template('chat_history.html', chats=chats)

#for feedback
@app.route('/feedback', methods=['GET', 'POST'])
def feedback():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        message = request.form['message']

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO feedback (name, email, message) VALUES (%s, %s, %s)",
            (name, email, message)
        )
        conn.commit()
        conn.close()

        flash('Feedback submitted successfully!', 'success')
        return redirect(url_for('feedback'))

    return render_template('feedback.html')



@app.route('/academic/dashboard')
def academic_dashboard():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT COUNT(*) AS total FROM enquiries")
    total_students = cursor.fetchone()['total']

    cursor.execute("SELECT COUNT(*) AS total FROM enquiries")
    total_courses = 4  # static for now

    conn.close()

    return render_template(
        'academic/dashboard.html',
        total_students=total_students,
        total_courses=total_courses,
        current_semester="2025-2029",
        pending_fees=0
    )


@app.route('/academic/students')
def students():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM students ORDER BY roll_no ASC")
    students = cursor.fetchall()
    conn.close()

    return render_template('academic/students.html', students=students)



@app.route('/academic/courses')
def courses():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM coursess ORDER BY name")
    courses = cursor.fetchall()

    conn.close()

    return render_template('academic/courses.html', coursess=courses)


@app.route('/academic/attendance')
def attendance():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    return render_template('academic/attendance.html')

@app.route('/add-attendance', methods=['GET', 'POST'])
def add_attendance():
    conn = get_db_connection()
    cursor = conn.cursor()

    # Get all students for the dropdown
    cursor.execute("SELECT id, name FROM students")
    students = cursor.fetchall()  # [(1, 'Ram'), (2, 'Sita'), ...]

    if request.method == 'POST':
        student_id = request.form['student_id']  # HTML form should have name="student_id"
        date = request.form['date']
        status = request.form['status']

        cursor.execute("""
            INSERT INTO attendance (student_id, date, status)
            VALUES (%s, %s, %s)
        """, (student_id, date, status))

        conn.commit()
        conn.close()

        flash("Attendance record added successfully!", "success")
        return redirect(url_for('attendance'))

    conn.close()
    return render_template('academic/add_attendance.html', students=students)

@app.route('/academic/results')
def results():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    return render_template('academic/results.html')

@app.route('/academic/fees')
def fees():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM fees ORDER BY id DESC")
    fees = cursor.fetchall()
    conn.close()

    return render_template('academic/fees.html', fees=fees)


@app.route('/academic/notices')
def notices():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    return render_template('academic/notices.html')

@app.route('/academic/profile')
def profile():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    # Example user data (later from DB)
    user_data = {
        "username": session.get('username'),
        "role": "Admin",
        "email": "admin@college.edu.np"
    }

    return render_template('academic/profile.html', user=user_data)

@app.route('/academic/add_student', methods=['GET', 'POST'])
def add_student():
    # Optional: check login
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    if request.method == 'POST':
        roll_no = request.form['roll_no'].strip()
        name = request.form['name'].strip()
        course = request.form['course'].strip()
        semester = request.form['semester'].strip()
        status = request.form['status'].strip()

        # Basic validation
        if not roll_no or not name or not course or not semester or not status:
            flash("All fields are required!", "danger")
            return redirect(url_for('add_student'))

        # Connect to MySQL
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Check duplicate roll_no
        cursor.execute("SELECT * FROM students WHERE roll_no = %s", (roll_no,))
        existing = cursor.fetchone()
        if existing:
            flash("Roll number already exists!", "warning")
            conn.close()
            return redirect(url_for('add_student'))

        # Insert student
        cursor.execute(
            "INSERT INTO students (roll_no, name, course, semester, status) VALUES (%s, %s, %s, %s, %s)",
            (roll_no, name, course, semester, status)
        )
        conn.commit()
        conn.close()
        flash(f"Student {name} सफलतापूर्वक थपियो!", "success")
        return redirect(url_for('students'))

    # GET request → show form
    return render_template('academic/add_student.html', action='Add', students=None)

@app.route('/academic/add_fee', methods=['GET', 'POST'])
def add_fee():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    if request.method == 'POST':
        roll_no = request.form['roll_no']
        name = request.form['name']
        course = request.form['course']
        semester = request.form['semester']
        amount = request.form['amount']
        status = request.form['status']

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO fees (roll_no, name, course, semester, amount, status) "
            "VALUES (%s, %s, %s, %s, %s, %s)",
            (roll_no, name, course, semester, amount, status)
        )
        conn.commit()
        conn.close()

        flash("Fee added successfully!", "success")
        return redirect(url_for('fees'))

    return render_template('academic/add_fee.html')


@app.route('/academic/edit_fee/<int:fee_id>', methods=['GET', 'POST'])
def edit_fee(fee_id):
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        amount = request.form['amount']
        status = request.form['status']

        cursor.execute(
            "UPDATE fees SET amount=%s, status=%s WHERE id=%s",
            (amount, status, fee_id)
        )
        conn.commit()
        conn.close()

        flash("Fee updated successfully!", "success")
        return redirect(url_for('fees'))

    cursor.execute("SELECT * FROM fees WHERE id=%s", (fee_id,))
    fee = cursor.fetchone()
    conn.close()

    return render_template('academic/edit_fee.html', fee=fee)

@app.route('/academic/delete_fee/<int:fee_id>')
def delete_fee(fee_id):
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM fees WHERE id=%s", (fee_id,))
    conn.commit()
    conn.close()

    flash("Fee deleted successfully!", "danger")
    return redirect(url_for('fees'))

@app.route('/academic/attendance')
def academic_attendance():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    cursor.execute("""
        SELECT 
            s.name AS student,
            sub.name AS subject,
            ROUND(
                (SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) 
                / COUNT(a.id)) * 100, 2
            ) AS percent
        FROM attendance a
        JOIN students s ON s.id = a.student_id
        JOIN subjects sub ON sub.id = a.subject_id
        GROUP BY a.student_id, a.subject_id
        ORDER BY s.name
    """)

    attendance = cursor.fetchall()

    return render_template(
        'academic/attendance.html',
        attendance=attendance
    )


@app.route('/notices/add', methods=['GET','POST'])
def add_notice():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    if request.method == 'POST':
        title = request.form['title']
        message = request.form['message']
        category = request.form['category']
        priority = request.form['priority']

        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO notices (title, message, category, priority)
            VALUES (%s,%s,%s,%s)
        """,(title,message,category,priority))
        conn.commit()
        conn.close()

        flash("Notice added successfully!", "success")
        return redirect(url_for('view_notices'))

    return render_template('notices/add.html')

@app.route('/notices')
def view_notices():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM notices ORDER BY created_at DESC")
    notices = cursor.fetchall()
    conn.close()

    return render_template('notices/list.html', notices=notices)

@app.route('/notices/edit/<int:id>', methods=['GET','POST'])
def edit_notice(id):
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        cursor.execute("""
            UPDATE notices
            SET title=%s, message=%s, category=%s, priority=%s
            WHERE id=%s
        """,(
            request.form['title'],
            request.form['message'],
            request.form['category'],
            request.form['priority'],
            id
        ))
        conn.commit()
        conn.close()
        flash("Notice updated!", "success")
        return redirect(url_for('view_notices'))

    cursor.execute("SELECT * FROM notices WHERE id=%s",(id,))
    notice = cursor.fetchone()
    conn.close()

    return render_template('notices/edit.html', notice=notice)

@app.route('/notices/delete/<int:id>')
def delete_notice(id):
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM notices WHERE id=%s",(id,))
    conn.commit()
    conn.close()

    flash("Notice deleted!", "warning")
    return redirect(url_for('view_notices'))

@app.route('/notices/publish/<int:id>')
def publish_notice(id):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE notices SET status='published' WHERE id=%s",(id,))
    conn.commit()
    conn.close()
    return redirect(url_for('view_notices'))

@app.route('/notice-board')
def notice_board():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT * FROM notices
        WHERE status='published'
        ORDER BY created_at DESC
    """)
    notices = cursor.fetchall()
    conn.close()

    return render_template('notices/board.html', notices=notices)

@app.route('/user/home')
def user_home():
    if 'loggedin' not in session:
        return redirect(url_for('login'))
    return render_template('user/home.html')


@app.route('/user/notices')
def user_notices():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM notices ORDER BY id DESC")
    notices = cursor.fetchall()
    conn.close()

    return render_template('user/notices.html', notices=notices)


@app.route('/user/results')
def user_results():
    # 🔐 Login check
    if 'loggedin' not in session:
        flash("कृपया पहिले login गर्नुहोस्!", "warning")
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # ✅ सबै students को results fetch
    cursor.execute("""
        SELECT 
            r.student_id,
            s.name AS student_name,
            r.subject,
            r.marks,
            r.grade,
            r.gpa,
            r.status
        FROM results r
        JOIN students s ON r.student_id = s.id
        ORDER BY r.id DESC
    """)

    results = cursor.fetchall()  # सबै rows fetch

    cursor.close()
    conn.close()

    return render_template('user/results.html', results=results)


@app.route('/user/courses')
def user_courses():
    courses = ["BSc CSIT", "BCA", "BIM", "BBM"]
    return render_template('user/courses.html', courses=courses)


# -------------------- User Attendance --------------------
@app.route('/user/attendance')
def user_attendance():
    # 🔐 Login check
    if 'loggedin' not in session:
        flash("कृपया पहिले login गर्नुहोस्!", "warning")
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # सबै attendance rows fetch
    cursor.execute("""
        SELECT a.id, a.student_id, s.name AS student_name,
               a.date, a.status, a.subject_id
        FROM attendance a
        LEFT JOIN students s ON a.student_id = s.id
        ORDER BY a.id ASC
    """)

    records = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('user/attendance.html', records=records)


@app.route('/user/students')
def user_students():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM students ORDER BY id DESC")
    students = cursor.fetchall()

    cursor.execute("SELECT COUNT(*) AS total FROM students")
    total_students = cursor.fetchone()['total']

    conn.close()

    return render_template(
        'user/students.html',
        students=students,
        total_students=total_students
    )

@app.route('/manage-chat-history')
def manage_chat_history():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    username = request.args.get('username')
    date = request.args.get('date')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    query = "SELECT * FROM chat_history WHERE 1=1"
    values = []

    # Search by username
    if username:
        query += " AND username LIKE %s"
        values.append(f"%{username}%")

    # Filter by date
    if date:
        query += " AND DATE(created_at) = %s"
        values.append(date)

    query += " ORDER BY created_at DESC"

    cursor.execute(query, values)
    chats = cursor.fetchall()

    conn.close()

    return render_template(
        'manage_chat_history.html',
        chats=chats
    )


#for download
@app.route('/download-chat-history')
def download_chat_history():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    username = request.args.get('username')
    date = request.args.get('date')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    query = "SELECT * FROM chat_history WHERE 1=1"
    values = []

    if username:
        query += " AND username LIKE %s"
        values.append(f"%{username}%")

    if date:
        query += " AND DATE(created_at) = %s"
        values.append(date)

    query += " ORDER BY created_at DESC"

    cursor.execute(query, values)
    chats = cursor.fetchall()
    conn.close()

    def generate():
        yield "Username,User Message,Bot Reply,Date & Time\n"
        for chat in chats:
            yield f'"{chat["username"]}","{chat["user_message"]}","{chat["bot_reply"]}","{chat["created_at"]}"\n'

    return Response(
        generate(),
        mimetype="text/csv",
        headers={"Content-Disposition": "attachment;filename=chat_history.csv"}
    )

#for admoin login
@app.route("/admin_login", methods=["GET", "POST"])
def admin_login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        if username == "admin" and password == "password":
            session["admin"] = True
            return redirect(url_for("academic_dashboard"))
        else:
            flash("Invalid Credentials", "danger")

    return render_template("admin_login.html")

@app.route("/admin_logout")
def admin_logout():
    session.pop("admin", None)
    flash("Logged out successfully!", "info")
    return redirect(url_for("user_home"))

# ---------------- Add Result ----------------
@app.route('/results/add', methods=['GET', 'POST'])
def add_result_route():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    if request.method == 'POST':
        student_id = request.form['student_id']
        subject = request.form['subject']
        marks = int(request.form['marks'])
        add_result(student_id, subject, marks)
        flash("Result added successfully!", "success")
        return redirect(url_for('view_results'))
    
    return render_template('results/add.html')


# ---------------- View Results ----------------
@app.route('/results')
def view_results():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    results = fetch_results()
    return render_template('results/list.html', results=results)


# ---------------- Publish Result ----------------
@app.route('/results/publish/<int:id>')
def publish_result_route(id):
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    publish_result(id)
    flash("Result published successfully!", "success")
    return redirect(url_for('view_results'))


# ---------------- Result Analytics ----------------
@app.route('/results/analytics')
def analytics():
    if 'loggedin' not in session:
        return redirect(url_for('login'))

    total, passed, pass_percent = result_analytics()
    return render_template(
        'results/analytics.html',
        total=total,
        passed=passed,
        pass_percent=pass_percent
    )



if __name__ == '__main__':
    app.run(debug=True)