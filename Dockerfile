# ✅ Imagem base oficial do Python
FROM python:3.12-slim

# ✅ Metadata (opcional)
LABEL maintainer="andré <ao_mendes@hotmail.com>"
LABEL version="1.2.1"
LABEL description="Fake API para testes locais com dados mock."

# ✅ Define diretório de trabalho
WORKDIR /app

# ✅ Copia o código da API
COPY app/ ./app

# ✅ Copia o requirements.txt
COPY requirements.txt .

# ✅ Instala dependências
RUN pip install --no-cache-dir -r requirements.txt

# ✅ Exponha a porta usada
EXPOSE 5001

# ✅ Defina ponto de entrada
CMD ["python", "app/main.py"]
