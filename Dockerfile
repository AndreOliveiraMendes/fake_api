FROM python:3.12-slim

LABEL maintainer="ao_mendes@hotmail.com"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# dependências de sistema (útil pra libs como mysqlclient, sass, etc.)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# instala dependências primeiro (cache layer eficiente)
COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# copia apenas o necessário depois
COPY app/ app/
COPY config.py .
COPY data/ data/

EXPOSE 5001

CMD ["python", "-m", "app.main"]