# 🧪 Fake API - Projeto de Autenticação Mock

API REST simples em Flask para simular um serviço de autenticação.  
Ideal para desenvolvimento e testes offline.

---

## ✅ ✨ Funcionalidades

- Mock de autenticação (POST /api/autenticar/json)
- Armazena usuários mock em JSON
- Persistência com volume externo
- Rotas para gerenciar dados mock
- Health check simples

---

## ✅ 📦 Estrutura recomendada

```

fake_api/
├── .env
├── .env.example
├── .gitignore
├── Dockerfile
├── LICENSE
├── Readme.md
├── app
│   ├── config.py
│   └── main.py
├── data
│   ├── dados_mock.json
│   └── dados_mock_exemplo.json
├── deploy.sh
├── fake_api.md
└── requirements.txt

````

✅ Nota:
Antes de rodar o aplicativo ou buildar a imagem, certifique-se de criar e configurar o arquivo .env com as credenciais da API.
Consulte o arquivo .env.example para ver como preencher o formato corretamente.

---

## ✅ 🚀 Endpoints disponíveis

### ✅ **POST /api/autenticar/json**
Autentica um usuário mock.  
- Recebe: `login`, `senha` via `application/x-www-form-urlencoded`
- Responde com:
  - ✅ 200 + dados do usuário, se login/senha válidos
  - ❌ 404 se não encontrado

---

### ✅ **GET /mock_data**
Lista todos os usuários mock salvos.

---

### ✅ **POST /mock_data**
Adiciona um usuário temporariamente à lista de usuários.  
Os dados persistem apenas enquanto o app estiver rodando **e se o volume estiver montado**.  
Formato esperado:
```json
{
  "login": "2",
  "senha": "teste",
  "usuario": {
    "pessoa": {
      "codigo": 2,
      "nome": "João",
      "email": "joao@example.com"
    },
    "codigo": 2,
    "tipo": "FUNCIONARIO",
    "situacao": "ATIVO",
    "grupo": "DOCENTE"
  }
}
````

---

### ✅ **GET /health**

Retorna status do serviço:

```json
{
  "status": "ok",
  "service": "fake_api",
  "version": "1.2.1"
}
```

---

## ✅ 📦 Pré-requisitos

* Python 3.12 (ou similar) **OU** Podman/Docker
* Flask (ver `requirements.txt`)

---

## ✅ ⚙️ Usando localmente (sem container)

1️⃣ Instale dependências:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

2️⃣ Crie a pasta de dados (opcional):

```bash
mkdir -p data
cp data/dados_mock_exemplo.json data/dados_mock.json
```

3️⃣ Rode o servidor:

```bash
python app/main.py
```

---

## ✅ 🐳 Usando com Podman/Docker

### ✅ 1️⃣ Build da imagem

```bash
podman build -t fake_api .
```

---

### ✅ 2️⃣ Inicialize os dados no HOST

Crie a pasta de dados no host e copie o exemplo:

```bash
mkdir -p ~/fake_api_data
cp data/dados_mock_exemplo.json ~/fake_api_data/dados_mock.json
```

---

### ✅ 3️⃣ Rodar o container

Para rodar e mapear porta + volume:

```bash
podman run --rm -p 5001:5001 -v ~/fake_api_data:/app/data fake_api
```

⭐️ Ou em segundo plano:

```bash
podman run -d --rm -p 5001:5001 -v ~/fake_api_data:/app/data fake_api
```

---

### ✅ 4️⃣ Verificar logs

```bash
podman logs <container_id>
```

---

### ✅ 5️⃣ Parar container

```bash
podman stop <container_id>
```

---

## ✅ 🗂️ Volume persistente

⭐️ Qualquer dado adicionado via POST `/mock_data` será salvo em:

```
~/fake_api_data/dados_mock.json
```

✔️ Sobrevive mesmo após reiniciar o container!

---

## ✅ ⚠️ Observação

✅ Se rodar **sem montar o volume**, todos os dados serão perdidos ao parar o container.

---

## ✅ 📝 Licença

MIT License
