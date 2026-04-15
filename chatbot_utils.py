from flask import session
from db import get_db_connection
import nltk
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
from sentence_transformers import SentenceTransformer, util
from spellchecker import SpellChecker
import warnings
import os
import re

# ------------------- Suppress Warnings -------------------
warnings.filterwarnings("ignore")
from transformers import logging as hf_logging
hf_logging.set_verbosity_error()

# ------------------- Spell Checker -------------------
spell = SpellChecker(distance=2)

# ------------------- NLTK Setup -------------------
try:
    nltk.data.find('tokenizers/punkt')
except LookupError:
    nltk.download('punkt')

try:
    nltk.data.find('corpora/stopwords')
except LookupError:
    nltk.download('stopwords')

STOP_WORDS = set(stopwords.words('english'))

# ------------------- MULTI QUESTION SPLITTER -------------------
def split_questions(text: str):
    text = text.strip()
    text = text.replace("?", " ? ")

    parts = re.split(r'\?| and | तथा |,', text)

    cleaned = []
    for p in parts:
        p = p.strip()
        if len(p) > 2:
            cleaned.append(p)

    return cleaned if cleaned else [text]

# ------------------- TEXT CORRECTION -------------------
def correct_text(text: str) -> str:
    corrected = []
    for word in text.split():
        if word.isalpha():
            corrected_word = spell.correction(word)
            corrected.append(corrected_word if corrected_word else word)
        else:
            corrected.append(word)
    return " ".join(corrected)

# ------------------- TEXT CLEANING -------------------
def clean_text(text: str) -> str:
    text = text.lower()
    text = correct_text(text)
    text = re.sub(r'[^\w\s]', '', text)

    try:
        tokens = word_tokenize(text)
    except Exception:
        tokens = text.split()

    tokens = [w for w in tokens if w.isalnum() and w not in STOP_WORDS]
    return " ".join(tokens)

# ------------------- LOAD QA FROM DB -------------------
def load_qa():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT question, answer FROM qa_table")
        rows = cursor.fetchall()
        conn.close()

        questions = [clean_text(r["question"]) for r in rows if r.get("question")]
        answers = [r["answer"] for r in rows if r.get("answer")]

        return questions, answers

    except Exception as e:
        print("Error loading QA:", e)
        return [], []

# ------------------- INITIALIZE -------------------
QUESTIONS, ANSWERS = load_qa()

# ------------------- MODEL (lazy load fix) -------------------
model = None
question_embeddings = None

def get_model():
    global model
    if model is None:
        model = SentenceTransformer('all-MiniLM-L6-v2')
    return model

def get_embeddings():
    global question_embeddings
    if question_embeddings is None and QUESTIONS:
        m = get_model()
        question_embeddings = m.encode(
            QUESTIONS,
            convert_to_tensor=True,
            normalize_embeddings=True
        )
    return question_embeddings

# ------------------- NLP BOT RESPONSE -------------------
def nlp_bot_response(user_input: str) -> str:
    if not user_input or not user_input.strip():
        return "Please ask something about the university."

    embeddings = get_embeddings()

    if not QUESTIONS or embeddings is None:
        return None

    try:
        responses = []
        seen_answers = set()
        m = get_model()

        questions = split_questions(user_input)

        for q in questions:
            cleaned_input = clean_text(q)

            embedding = m.encode(
                cleaned_input,
                convert_to_tensor=True,
                normalize_embeddings=True
            )

            cosine_scores = util.cos_sim(embedding, embeddings)
            scores = cosine_scores[0].cpu().numpy()

            if len(scores) == 0:
                continue

            best_idx = scores.argmax()
            best_score = float(scores[best_idx])

            answer = ANSWERS[best_idx]

            if answer in seen_answers:
                continue

            if best_score >= 0.78:
                responses.append(answer)
                seen_answers.add(answer)

            elif best_score >= 0.65:
                responses.append("👉 " + answer)
                seen_answers.add(answer)

            elif best_score >= 0.50:
                responses.append(f"Did you mean:\n👉 {answer}")
                seen_answers.add(answer)

        return "\n\n".join(responses) if responses else None

    except Exception as e:
        print("NLP error:", e)
        return None

# ------------------- MAIN CHATBOT FUNCTION -------------------
def process_user_message(user_msg: str) -> str:
    msg = re.sub(r'\s+', ' ', user_msg.lower().strip())

    response = None

    # ---------- CONTEXT ----------
    last_topic = session.get("last_topic")

    if "csit" in msg:
        session["last_topic"] = "csit"

    elif "fee" in msg and last_topic == "csit":
        response = "CSIT fee is approximately Rs. 80,000 per year."

    # ---------- RULE BASED ----------
    elif msg in ["hi", "hello", "hey"]:
        response = "Hello 👋 How can I help you today?"

    elif msg in ["bye", "goodbye", "see you"]:
        response = "Goodbye 😊 Have a great day!"

    elif "contact" in msg or "phone" in msg or "number" in msg:
        response = "You can contact us at 0000000000."

    elif "location" in msg or "address" in msg or "place" in msg:
        response = "You can find Mahendranagar, Kanchanpur."

    elif "program" in msg or "course" in msg:
        response = ("We offer undergraduate programs in Computer Science, "
                    "Business, and Arts, as well as postgraduate programs "
                    "in Science and Management.")

    elif "eligibility" in msg:
        response = ("Undergraduate: 10+2 pass with minimum 50% marks. "
                    "Postgraduate: Bachelor's degree in relevant field.")

    elif "admission" in msg:
        response = ("Admissions are open from June to August. "
                    "Apply online or visit the admission office.")

    elif "fee" in msg or "fees" in msg:
        response = ("Undergraduate fee: Rs. 80,000 per year. "
                    "Postgraduate fee: Rs. 120,000 per year.")

    elif "department" in msg:
        response = ("Departments: Computer Science, Management, "
                    "Humanities, Science, and Education.")

    elif "teacher" in msg or "faculty" in msg or "lecturer" in msg:
        response = ("Our faculty members are highly qualified with "
                    "Master's and PhD degrees.")

    elif "student record" in msg or "student data" in msg:
        response = ("Student records include academic performance, "
                    "attendance, and exam results. Contact administration.")

    elif "result" in msg:
        response = "Exam results are published on the official website."

    elif "attendance" in msg:
        response = "Minimum 75% attendance is required for exams."

    elif "facility" in msg or "campus" in msg:
        response = ("Campus facilities include library, computer labs, "
                    "sports complex, hostel, and free Wi-Fi.")

    elif "scholarship" in msg or "financial aid" in msg:
        response = ("Merit-based and need-based scholarships are available. "
                    "Apply via scholarship office.")

    # ---------- NLP FALLBACK ----------
    else:
        response = nlp_bot_response(user_msg)

        if response is None:
            response = ("Sorry, I couldn't find an answer. "
                        "Please ask about admission, programs, eligibility, "
                        "fees, facilities, or scholarship.")

    # ------------------- SESSION SAFE FIX -------------------
    if "chat_messages" not in session:
        session["chat_messages"] = []

    session["chat_messages"].append({
        "user": user_msg,
        "bot": response
    })

    if len(session["chat_messages"]) > 20:
        session["chat_messages"].pop(0)

    session.modified = True

    # ------------------- DATABASE (USER SAFE FIX) -------------------
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "INSERT INTO chat_history (user_id, user_message, bot_reply) VALUES (%s, %s, %s)",
            (session.get("user_id"), user_msg, response)
        )

        conn.commit()

    except Exception as e:
        print("Error saving chat to DB:", e)

    finally:
        try:
            cursor.close()
            conn.close()
        except:
            pass

    return response

# ------------------- DELETE FUNCTIONS -------------------
def delete_chat_message_from_session(index: int) -> str:
    if "chat_messages" in session and 0 <= index < len(session["chat_messages"]):
        removed = session["chat_messages"].pop(index)
        session.modified = True
        return f"Deleted message: {removed['user']}"
    return "No message found to delete."


def delete_chat_message_from_db(message_id: int) -> str:
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "DELETE FROM chat_history WHERE id = %s AND user_id = %s",
            (message_id, session.get("user_id"))
        )

        conn.commit()

        if cursor.rowcount > 0:
            return f"Message with ID {message_id} deleted from database."
        else:
            return "Message not found in database."

    except Exception as e:
        return f"Error deleting message: {e}"

    finally:
        try:
            cursor.close()
            conn.close()
        except:
            pass


def delete_chat_message(index: int, message_id: int = None) -> str:
    msg_session = delete_chat_message_from_session(index)
    msg_db = ""

    if message_id is not None:
        msg_db = delete_chat_message_from_db(message_id)

    return msg_session + (" " + msg_db if msg_db else "")
