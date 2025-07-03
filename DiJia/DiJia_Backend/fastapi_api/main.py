from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from openai import OpenAI
from dotenv import load_dotenv
from routes import admin
import os

# ✅ Charger les variables d’environnement
load_dotenv()

# ✅ Instancier le client sans arguments (il lira OPENAI_API_KEY automatiquement)
client = OpenAI(api_key=os.environ["OPENAI_API_KEY"])

# ✅ Définir l’app FastAPI
app = FastAPI()
app.include_router(admin.router)

# ✅ CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ✅ Modèle de message
class Message(BaseModel):
    user_id: str
    content: str

# ✅ Endpoint principal
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
        return {"response": "Erreur dans le traitement GPT.", "error": str(e)}

# ✅ Endpoint de test
@app.get("/api/ping")
def ping():
    return {"ping": "pong"}
