import os

try:
    from data import question_data  
except ImportError:
    question_data = []

def add_sentences_from_input():
    while True:
        sentence = input("추가할 문장을 입력하세요 (종료하려면 'q' 입력): ")
        if sentence.lower() == 'q':
            break
        if sentence not in question_data:  
            question_data.append(sentence)
            print(f"문장 '{sentence}'이(가) 추가되었습니다.")
        else:
            print(f"문장 '{sentence}'은(는) 이미 존재합니다.")

def add_sentences_from_folder(folder_path):
    try:
        for filename in os.listdir(folder_path):
            if filename.endswith('.txt'):
                with open(os.path.join(folder_path, filename), 'r', encoding='utf-8') as file:
                    sentences = file.readlines()
                    for sentence in sentences:
                        sentence = sentence.strip()
                        if sentence not in question_data:  
                            question_data.append(sentence)
                    print(f"{filename}에서 문장들이 추가되었습니다.")
    except Exception as e:
        print(f"파일을 읽는 중 오류 발생: {e}")

def save_questions_to_file():
    with open('data.py', 'w', encoding='utf-8') as file:  
        file.write("question_data = [\n")
        for sentence in question_data:
            file.write(f'    "{sentence}",\n')
        file.write("]\n")

    print("질문 데이터가 data.py에 추가되었습니다.")

def main():
    method = input("질문 데이터를 추가할 방법을 선택하세요 (1: 직접 입력, 2: 폴더에서 추가): ")
    
    if method == '1':
        add_sentences_from_input()
    elif method == '2':
        folder_path = "./add_sentences/"
        add_sentences_from_folder(folder_path)
    else:
        print("잘못된 입력입니다.")
        return


    save_questions_to_file()

if __name__ == "__main__":
    main()
