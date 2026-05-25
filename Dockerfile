FROM python:3.12-slim

# Evita gerar cache e melhora logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# Instala dependências primeiro (melhora cache de build)
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copia só o necessário
COPY app ./app
COPY config.py .
COPY data ./data

# Segurança básica (não rodar como root)
RUN useradd -m appuser
USER appuser

EXPOSE 5001

CMD ["python", "-m", "app.main"]
