FROM python:3.10

WORKDIR /app

# Copie uniquement requirements.txt d'abord (meilleure cache Docker)
COPY requirements.txt .

# Installe les dépendances (dont openai)
RUN pip install --no-cache-dir -r requirements.txt

# Puis copie le reste du code
COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]