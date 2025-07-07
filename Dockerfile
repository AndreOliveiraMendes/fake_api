# Imagem base
FROM python:3.12-slim

# Autor/label opcional
LABEL maintainer="ao_mendes@hotmail.com"

# Diretório de trabalho
WORKDIR /app

# Copia requirements primeiro (cache melhor)
COPY requirements.txt .

# Atualiza pip e instala dependências
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copia o código
COPY app/ app/
COPY data/ data/
COPY .env ./

# Expor a porta
EXPOSE 5001

# Comando de execução
CMD ["python", "-m", "app.main"]
