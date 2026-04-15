from flask import render_template, request, redirect, url_for, flash
from itsdangerous import URLSafeTimedSerializer
from werkzeug.security import generate_password_hash
from db import get_db_connection

# 🔐 Serializer (initialized from app.py)
serializer = None


# ---------------- INIT FUNCTION ----------------
def init_serializer(secret_key):
    global serializer
    serializer = URLSafeTimedSerializer(secret_key)


# ---------------- FORGOT PASSWORD ----------------
