import random
from question_model import Question
from data import question_data
from quiz_brain import QuizBrain
from konlpy.tag import Okt
import os
from lyrics import lyrics_list  


from art import display_grammar_game


okt = Okt()


part_of_speech_mapping = {
    'Noun': '명사',
    'Verb': '동사',
    'Adjective': '형용사',
    'Adverb': '부사',
    'Josa': '조사',
    'Conjunction': '접속사',
    'Pronoun': '대명사',
    'Determiner': '관형사',
    'Preposition': '전치사',
    'Exclamation': '감탄사'
}

def display_separator():
    print("=" * 50)

def count_pos_in_lyrics(lyrics, target_pos):
    # Count occurrences of the target part of speech in the lyrics
    tagged_words = okt.pos(lyrics)
    # Count based on the mapped part of speech
    return sum(1 for _, pos in tagged_words if part_of_speech_mapping.get(pos) == target_pos)

def get_available_pos(lyrics):
    # Get a list of parts of speech that appear in the lyrics
    tagged_words = okt.pos(lyrics)
    # Map the POS tags to Korean names
    return set(part_of_speech_mapping.get(pos) for _, pos in tagged_words)

def ask_additional_questions(incorrect_answers):
    # Randomly select lyrics from the lyrics_list
    lyrics = random.choice(lyrics_list)

    print("\n노래 가사:")
    print(lyrics)

    # Get available parts of speech in the selected lyrics
    available_pos = get_available_pos(lyrics)

    # Filter to only those parts of speech that appear in the lyrics
    pos_counts = {pos: count_pos_in_lyrics(lyrics, pos) for pos in available_pos}

    # Filter to keep only parts of speech that appear at least once
    pos_counts = {pos: count for pos, count in pos_counts.items() if count > 0}

    for incorrect in incorrect_answers:
        if incorrect not in pos_counts:
            continue  # Skip to the next incorrect answer

        print(f"\n추가 학습: '{incorrect}'에 대한 문제를 내겠습니다.")

        # 정답을 가사에서 확인
        pos_count = pos_counts[incorrect]

        # 학생에게 입력을 받기
        while True:
            user_input = input(f"가사에서 '{incorrect}'의 개수를 입력하세요: ")
            try:
                user_answer = int(user_input)
                if user_answer == pos_count:
                    print("정답입니다! 잘했어요!")
                    return  
                else:
                    print(f"틀렸습니다. 다시 시도하세요.")
            except ValueError:
                print("숫자를 입력해 주세요.")

if __name__ == "__main__":

    # Display the title
    display_grammar_game()

    # Get user information
    name = input("학생 이름을 입력해주세요: ")
    grade = input("학생 학년을 입력해주세요: (숫자로 입력해주세요) ")
    user_id = name + " - " + grade + "학년"

    # Get difficulty level
    difficulty = input("난이도를 선택하세요 (1: 쉬움, 2: 어려움): ")

    # Prepare the questions
    question_bank = []
    sampled_questions = random.sample(question_data, 10)
    quiz = QuizBrain(question_bank, user_id)

    incorrect_answers = []  # List to store incorrect answers for final explanation

    for question in sampled_questions:
        question_info = quiz.generate_grammar_questions(question)
        if question_info:
            question_bank.append(Question(question_info["text"], question_info["answer"], question_info["original_sentence"]))

    for _ in range(len(quiz.question_list)):
        current_question = quiz.question_list[quiz.question_number]
        
        display_separator()
        print(f"\nQ{quiz.question_number + 1}: 문장: {current_question.original_sentence}")
        print(f"질문: {current_question.text}")

        correct_answer = current_question.answer
        incorrect_answers_pool = [pos for pos in part_of_speech_mapping.values() if pos != correct_answer]
        incorrect_answers = random.sample(incorrect_answers_pool, 4)

        # Combine and shuffle answers
        choices = [correct_answer] + incorrect_answers
        random.shuffle(choices)

        print("가능한 답변: ", ', '.join(choices))
        user_answer = input("품사를 입력하세요: ")

        # Check answer, store incorrect ones for explanation later
        if not quiz.check_answer(user_answer, current_question.answer, time_taken=0, question_text=current_question.text):
            incorrect_answers.append(correct_answer)
        quiz.next_question()

    if quiz.logs:
        quiz.save_logs_to_db()

    quiz.close_connection()

    display_separator()
    print("문제 풀이가 완료되었습니다")
    print(f"최종 점수: {quiz.score}/{quiz.question_number}")
    display_separator()

    
    additional_learning = input("추가 학습을 원하십니까? (예 : 1/아니오 : 0): ")
    if additional_learning.lower() in ['예', '1']:
        ask_additional_questions(incorrect_answers)
    else:
        print("추가 학습을 종료합니다.")
