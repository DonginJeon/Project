import time
from konlpy.tag import Okt
import random
import sqlite3
import os

okt = Okt()

class QuizBrain:
    def __init__(self, q_list, user_id):
        self.question_number = 0
        self.question_list = q_list
        self.score = 0
        self.user_id = user_id
        self.logs = []  
        self.incorrect_questions = []  # List to store incorrectly answered questions


        self.answer_variations = {
            '명사': ['명사', '명사입니다', '명사요', '명사이다', '명사임', '명사일걸요', '명사라고 생각합니다'],
            '동사': ['동사', '동사입니다', '동사요', '동사이다', '동사임', '동사일걸요', '동사라고 생각합니다'],
            '형용사': ['형용사', '형용사입니다', '형용사요', '형용사이다', '형용사임', '형용사일걸요', '형용사라고 생각합니다'],
            '부사': ['부사', '부사입니다', '부사요', '부사이다', '부사임', '부사일걸요', '부사라고 생각합니다'],
            '접속사': ['접속사', '접속사입니다', '접속사요', '접속사이다', '접속사임', '접속사일걸요', '접속사라고 생각합니다'],
            '대명사': ['대명사', '대명사입니다', '대명사요', '대명사이다', '대명사임', '대명사일걸요', '대명사라고 생각합니다'],
            '관형사': ['관형사', '관형사입니다', '관형사요', '관형사이다', '관형사임', '관형사일걸요', '관형사라고 생각합니다'],
            '전치사': ['전치사', '전치사입니다', '전치사요', '전치사이다', '전치사임', '전치사일걸요', '전치사라고 생각합니다'],
            '감탄사': ['감탄사', '감탄사입니다', '감탄사요', '감탄사이다', '감탄사임', '감탄사일걸요', '감탄사라고 생각합니다'],
            '조사': ['조사', '조사입니다', '조사요', '조사이다', '조사임', '조사일걸요', '조사라고 생각합니다'],
        }

        # 데이터베이스 연결
        self.db_path = 'quiz_logs.db'
        self.conn = sqlite3.connect(self.db_path)
        self.cursor = self.conn.cursor()

        # 데이터베이스 테이블 생성
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS quiz_logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT,
            question_text TEXT,
            user_answer TEXT,
            correct_answer TEXT,
            is_correct BOOLEAN,
            time_taken TEXT,
            score INTEGER,
            solved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        ''')

    def still_has_questions(self):
        return self.question_number < len(self.question_list)

    def next_question(self):
        self.question_number += 1

    def check_answer(self, user_answer, correct_answer, time_taken, question_text):
       
        acceptable_answers = self.answer_variations.get(correct_answer, [])

        is_correct = user_answer.lower() in (ans.lower() for ans in acceptable_answers)

        if is_correct:
            self.score += 1
            print("정답입니다.")
        else:
            print("오답입니다.")
            self.incorrect_questions.append({
                "question_text": question_text,
                "correct_answer": correct_answer,
            })

        print(f"올바른 정답은: {correct_answer}.")
        print(f"당신의 현재 점수는 : {self.score}/{self.question_number + 1}")
        print("\n")


        # 로그를 리스트에 추가
        self.logs.append((question_text, user_answer, correct_answer, is_correct, time_taken))

        # 10문제마다 DB에 저장
        if self.question_number % 10 == 0:
            self.save_logs_to_db()

    def save_logs_to_db(self):
        for log in self.logs:
            self.cursor.execute('''INSERT INTO quiz_logs (user_id, question_text, user_answer, correct_answer, is_correct, time_taken)
                                  VALUES (?, ?, ?, ?, ?, ?)''',
                                (self.user_id, *log))
        self.conn.commit()
        self.logs.clear()

    def close_connection(self):
        self.conn.close()
        print("데이터베이스 연결이 종료되었습니다.")

    def generate_grammar_questions(self, sentence):
        parsed_sentence = okt.pos(sentence)  

        questions = []

        for word, pos in parsed_sentence:
            if word == '이다':
                question = f"문장에서 '{word}'의 품사는 무엇일까요?"
                questions.append({"text": question, "answer": "동사", "original_sentence": sentence})
            elif word == '있었다':
                question = f"문장에서 '{word}'의 품사는 무엇일까요?"
                questions.append({"text": question, "answer": "동사", "original_sentence": sentence})
            elif word == '를':
                question = f"문장에서 '{word}'의 품사는 무엇일까요?"
                questions.append({"text": question, "answer": "조사", "original_sentence": sentence})
            elif word == '그':
                question = f"문장에서 '{word}'의 품사는 무엇일까요?"
                questions.append({"text": question, "answer": "대명사", "original_sentence": sentence})
            elif pos == 'Noun':
                question = f"문장에서 '{word}'의 품사는 무엇일까요?"
                questions.append({"text": question, "answer": "명사", "original_sentence": sentence})
            elif pos == 'Verb':
                question = f"문장에서 '{word}'의 품사는 무엇일까요?"
                questions.append({"text": question, "answer": "동사", "original_sentence": sentence})
            elif pos == 'Adjective':
                question = f"문장에서 '{word}'의 품사는 무엇일까요?"
                questions.append({"text": question, "answer": "형용사", "original_sentence": sentence})
            elif pos == 'Adverb':
                question = f"문장에서 '{word}'의 품사는 무엇일까요?"
                questions.append({"text": question, "answer": "부사", "original_sentence": sentence})
            elif pos == 'Conjunction':
                question = f"문장에서 '{word}'의 품사는 무엇일까요?"
                questions.append({"text": question, "answer": "접속사", "original_sentence": sentence})
            elif pos == 'Pronoun':
                question = f"문장에서 '{word}'의 품사는 무엇일까요?"
                questions.append({"text": question, "answer": "대명사", "original_sentence": sentence})
            elif pos == 'Determiner':
                question = f"문장에서 '{word}'의 품사는 무엇일까요?"
                questions.append({"text": question, "answer": "관형사", "original_sentence": sentence})
            elif pos == 'Preposition':
                question = f"문장에서 '{word}'의 품사는 무엇일까요?"
                questions.append({"text": question, "answer": "전치사", "original_sentence": sentence})
            elif pos == 'Interjection':
                question = f"문장에서 '{word}'의 품사는 무엇일까요?"
                questions.append({"text": question, "answer": "감탄사", "original_sentence": sentence})
            elif pos == 'Josa':  
                question = f"문장에서 '{word}'의 품사는 무엇일까요?"
                questions.append({"text": question, "answer": "조사", "original_sentence": sentence})

        if questions:
            return random.choice(questions)
        return None
