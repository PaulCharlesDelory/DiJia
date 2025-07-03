from fastapi import APIRouter, HTTPException
from typing import List
from pydantic import BaseModel

router = APIRouter()

# Simule la base de données
fake_ai_db = [
    {"id": 1, "name": "DiJia", "model": "gpt-3.5-turbo"},
    {"id": 2, "name": "Nova", "model": "gpt-4"},
]

class AIModel(BaseModel):
    id: int
    name: str
    model: str

@router.get("/api/admin/list-ai", response_model=List[AIModel])
def list_ais():
    return fake_ai_db

@router.delete("/api/admin/delete-ai/{ai_id}")
def delete_ai(ai_id: int):
    global fake_ai_db
    for ai in fake_ai_db:
        if ai["id"] == ai_id:
            fake_ai_db.remove(ai)
            return {"message": "IA supprimée"}
    raise HTTPException(status_code=404, detail="IA non trouvée")

