from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from openai import OpenAI
from dotenv import load_dotenv
from routes import admin 
import os


load_dotenv()

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))  

app = FastAPI()

app.include_router(admin.router) 

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class Message(BaseModel):
    user_id: str
    content: str

@app.post("/api/message")
async def message_handler(msg: Message):
    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "Tu es une IA amicale appelée DiJia."},
                {"role": "user", "content": msg.content}
            ]
        )
        reply = response.choices[0].message.content
        return {"response": reply}

    except Exception as e:
        print(f"❌ Erreur rencontrée : {e}")
        return {"response": "Erreur dans le traitement GPT-4.", "error": str(e)}

# 🔁 Endpoint de test
@app.get("/api/ping")
def ping():
    return {"ping": "pong"}