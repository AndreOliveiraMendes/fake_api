FROM python:3.12-slim

WORKDIR /app

# Copia as dependências e instala
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia o código
COPY . .

# Expor a porta para o host
EXPOSE 5001

# Rodar o app
CMD ["python", "main.py"]