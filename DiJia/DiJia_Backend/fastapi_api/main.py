from fastapi import FastAPI, Request
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from openai import OpenAI
import os



client = OpenAI(api_key=os.getenv("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"))  

app = FastAPI()

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
        print(f"Erreur rencontrée : {e}")
        return {"response": "Erreur dans le traitement GPT-4.", "error": str(e)}

@app.get("/api/ping")
def ping():
    return {"ping": "pong"}