# 🤖 AI-Powered Chatbot (Flask + NLP)

## 📌 Project Overview

This project is an intelligent chatbot system built using Flask and Natural Language Processing (NLP).  
It is designed to simulate human-like conversation and provide accurate answers to user queries related to a university system.

The chatbot supports semantic understanding, multi-sentence input, and context-aware responses.

---

## 🧠 Core Concept

The chatbot combines:

- Rule-Based System (for quick responses)
- NLP Processing (for understanding user intent)
- Semantic Search (for intelligent matching)
- Context Memory (for conversation flow)

It behaves like a real assistant instead of a basic FAQ bot.

---

## ⚙️ How It Works

1. User sends a message
2. Text is cleaned and corrected (spell check)
3. Input is split into multiple sentences
4. System checks:
   - Rule-based answers
   - Smart intent detection
   - Semantic similarity using embeddings
5. Best response is selected
6. Chat is stored in session + database

---

## 🔥 Key Features

- ✅ Multi-sentence understanding  
- ✅ Smart intent detection (hello, help, thanks, etc.)  
- ✅ Semantic search using Sentence Transformers  
- ✅ Spell correction system  
- ✅ Context-based reply (remembers topic)  
- ✅ Real-time chat interface  
- ✅ Chat history storage (MySQL)  
- ✅ Error handling and fallback system  

🔥 NLP TECH STACK USED
NLTK (tokenization, stopwords)
SpellChecker (text correction)
SentenceTransformers (semantic understanding)
Cosine Similarity (matching logic)
Regex (text cleaning)
