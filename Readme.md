# 🧪 Fake API

Mock API simples e portátil para desenvolvimento local.  
Permite simular autenticação de usuários com dados fictícios.  

✅ Ideal para testar aplicações sem precisar da API real.  
✅ Pode rodar em container (Podman/Docker) ou como app Python puro.

---

## 📜 Funcionalidades

- 🔐 Endpoint de autenticação mockado: `/api/autenticar/json`
- ❤️ Health check: `/health`
- 🗂️ Endpoint de debug: `/mock_data` (lista todos os usuários fake)
- ✅ Totalmente configurável via código (adicionar/remover usuários mock)

---

## 🚀 Como rodar

Você pode rodar **de duas formas**:

---

### 🟣 1️⃣ Usando Podman (recomendado)

📦 **1. Build da imagem**
```bash
podman build -t fake_api .
````

🚀 **2. Rodar o container**

```bash
podman run -d --name fake_api_server -p 5001:5001 fake_api
```

✅ A API estará em:

```
http://127.0.0.1:5001
```

🛑 **3. Parar o container**

```bash
podman stop fake_api_server
```

🗑️ **4. Remover o container**

```bash
podman rm fake_api_server
```

---

### 🟣 2️⃣ Usando Python puro

✅ Requisitos: Python 3.11+ ou 3.12+

📦 **1. Clonar o repositório**

```bash
git clone <repo_url>
cd fake_api
```

🐍 **2. Criar e ativar o ambiente virtual**

```bash
python -m venv .venv

# Ativar no Linux/Mac
source .venv/bin/activate

# Ativar no Windows
.venv\Scripts\activate
```

📦 **3. Instalar dependências**

```bash
pip install -r requirements.txt
```

🚀 **4. Rodar**

```bash
python main.py
```

✅ A API estará em:

```
http://127.0.0.1:5001
```

---

## 📡 Endpoints disponíveis

✅ **POST /api/autenticar/json**

* Autentica um usuário fake.
* Retorna 200 com dados de exemplo ou 404 se inválido.

✅ **GET /health**

* Verifica se o servidor está rodando.
* Responde com status `ok`.

✅ **GET /mock\_data**

* Lista todos os usuários mockados atualmente.

---

## ⚙️ Exemplo de usuário mock

```json
{
  "login": "1",
  "senha": "admin",
  "usuario": {
    "pessoa": {
      "codigo": 1,
      "nome": "admin",
      "email": "admin@admin.admin"
    },
    "codigo": 1,
    "tipo": "FUNCIONARIO",
    "situacao": "ATIVO",
    "grupo": "ADMINISTRADOR"
  }
}
```

---

## 💡 Dicas úteis

✅ Ver logs do container:

```bash
podman logs fake_api_server
```

✅ Testar health check:

```bash
curl http://127.0.0.1:5001/health
```

✅ Parar tudo facilmente:

```bash
podman stop fake_api_server && podman rm fake_api_server
```

---

## 📦 .gitignore sugerido

```
.venv/
__pycache__/
*.py[cod]
*.log
.vscode/
*.tar
```

---

## ✅ Licença

Este projeto é livre para uso acadêmico ou de desenvolvimento.
Você pode copiar, modificar e distribuir à vontade.
Sugestão: [MIT License](https://opensource.org/licenses/MIT)

---

## 🤝 Contribuições

Sugestões, issues ou pull requests são muito bem-vindos!
