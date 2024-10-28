from flask import Flask, render_template, request, jsonify
from transformers import ElectraTokenizer, ElectraForSequenceClassification, pipeline
import torch
import torch.nn as nn

app = Flask(__name__)

# Load KoELECTRA tokenizer and model
tokenizer = ElectraTokenizer.from_pretrained("./emotion_detection_model")
model = ElectraForSequenceClassification.from_pretrained(
    "./emotion_detection_model")

# LLM model for positive/negative binary classification
emotion_classifier_llm = pipeline(
    "sentiment-analysis",
    model="nlptown/bert-base-multilingual-uncased-sentiment")

# Global variables to track conversation
conversation_count = 0
conversation_history = []
emotion_history = []


# Function for KoELECTRA emotion prediction
def predict_emotion_koelectra(input_text):
    try:
        inputs = tokenizer(input_text,
                           return_tensors="pt",
                           padding=True,
                           truncation=True)
        outputs = model(**inputs)
        logits = outputs.logits
        predicted_class = torch.argmax(logits, dim=1).item()
        emotions = ["분노", "기쁨", "불안", "당황", "슬픔", "상처"]
        return emotions[predicted_class]
    except Exception as e:
        print(f"Error in predict_emotion: {str(e)}")
        return "Error"


# LLM-based binary classification function
def classify_positive_or_negative(input_text):
    try:
        result = emotion_classifier_llm(input_text)
        sentiment = result[0]["label"]
        # LLM predicts positive sentiment (considered as "기쁨")
        if "positive" in sentiment.lower():
            return "기쁨"
        return "부정"  # LLM determines the sentiment is not positive
    except Exception as e:
        print(f"Error in LLM Sentiment Classification: {str(e)}")
        return "Error"


# Main emotion prediction function
def predict_emotion(input_text):
    # First, LLM performs binary classification
    sentiment_class = classify_positive_or_negative(input_text)

    # If LLM predicts positive (기쁨), return "기쁨"
    if sentiment_class == "기쁨":
        return "기쁨"

    # Otherwise, pass input to KoELECTRA for further emotion prediction
    return predict_emotion_koelectra(input_text)


# Function to recommend songs based on emotions
def recommend_song(emotion):
    song_recommendations = {
        "기쁨": [
            (
                "Happy - Pharrell Williams",
                "https://www.youtube.com/watch?v=ZbZSe6N_BXs",
            ),
            (
                "I Feel Good - James Brown",
                "https://www.youtube.com/watch?v=U5TqIdff_DQ",
            ),
        ],
        "분노": [
            ("Calm Down - Rema",
             "https://www.youtube.com/watch?v=WcIcVapfqXw"),
            ("Let It Be - The Beatles",
             "https://www.youtube.com/watch?v=QDYfEBY9NM4"),
        ],
        "슬픔": [
            ("Someone Like You - Adele",
             "https://www.youtube.com/watch?v=hLQl3WQQoQ0"),
            ("Fix You - Coldplay",
             "https://www.youtube.com/watch?v=k4V3Mo61fJM"),
        ],
        "불안": [
            ("Brave - Sara Bareilles",
             "https://www.youtube.com/watch?v=QUQsqBqxoR4"),
            ("Don't Panic - Coldplay",
             "https://www.youtube.com/watch?v=Lh3TokLzzmw"),
        ],
        "상처": [
            ("Hurt - Johnny Cash",
             "https://www.youtube.com/watch?v=vt1Pwfnh5pc"),
            ("The Scientist - Coldplay",
             "https://www.youtube.com/watch?v=RB-RcX5DS5A"),
        ],
        "당황": [
            (
                "Shake It Off - Taylor Swift",
                "https://www.youtube.com/watch?v=nfWlot6h_JM",
            ),
            ("Don't Panic - Coldplay",
             "https://www.youtube.com/watch?v=Lh3TokLzzmw"),
        ],
    }
    if emotion in song_recommendations:
        song_list = song_recommendations[emotion]
        # Return song title and link using HTML anchor tags
        song_recommendation_text = ", ".join([
            f"<a href='{url}' target='_blank'>{title}</a>"
            for title, url in song_list
        ])
        return f"오늘 기분이 '{emotion}'하신가요? 이런 노래를 추천드려요: {song_recommendation_text}"
    return "기분에 맞는 노래를 찾을 수 없어요. 다른 노래를 들려드릴게요!"


# Function to recommend a song based on recent emotion history
def recommend_song_based_on_history(emotion_history):
    recent_emotions = emotion_history[-3:]
    emotion_counts = {
        emotion: recent_emotions.count(emotion)
        for emotion in set(recent_emotions)
    }
    most_common_emotion = max(emotion_counts, key=emotion_counts.get)
    return recommend_song(most_common_emotion)


# Chatbot response function
def chatbot_response(user_input):
    responses = [
        "더 이야기 해주세요.",
        "무슨 일이 있었나요?",
        "어떤 감정인지 더 설명해 주실 수 있나요?",
        "당신의 이야기를 듣고 싶어요.",
    ]
    return responses[conversation_count % len(responses)]


# Flask app route definitions
@app.route("/")
def index():
    return render_template("index.html")


# Chat route for emotion prediction and song recommendation
@app.route("/chat", methods=["POST"])
def chat():
    global conversation_count, conversation_history, emotion_history

    user_input = request.form["message"]

    # Track the conversation count and store the input
    conversation_count += 1
    conversation_history.append(user_input)

    # Perform emotion analysis
    emotion = predict_emotion(user_input)
    emotion_history.append(emotion)

    # After 3 conversations, recommend a song based on emotions
    if conversation_count >= 3:
        final_emotion = emotion_history[-1]
        song_recommendation = recommend_song_based_on_history(emotion_history)

        # Reset conversation state
        conversation_count = 0
        conversation_history = []
        emotion_history = []

        return jsonify({
            "emotion": final_emotion,
            "song_recommendation": song_recommendation
        })

    # Return default chatbot response until 3 conversations are reached
    response = chatbot_response(user_input)
    return jsonify({"message": response})


if __name__ == "__main__":
    app.run(debug=True)
