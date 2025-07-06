# 🧪 Manual do Fake API

Pequeno guia para construir, rodar e gerenciar o container da *fake_api* usando Podman.

---

## 📦 Como buildar (ou atualizar) a imagem

Se você alterou o código (ex.: `main.py`, `requirements.txt`), faça:

```bash
podman build -t fake_api .
````

✅ Isso cria ou atualiza a imagem chamada **fake\_api**.

✔️ Se quiser forçar sem cache:

```bash
podman build --no-cache -t fake_api .
```

---

## 📂 Como preparar os dados (somente na 1ª vez)

Crie o volume de dados mock no host com o arquivo inicial:

```bash
mkdir -p ~/fake_api_data
cp data/dados_mock_exemplo.json ~/fake_api_data/dados_mock.json
```

✅ Isso garante que os dados persistam entre execuções.

---

## 🚀 Como startar (rodar) a fake\_api

Rodar em background (detached), expondo a porta 5001 **e montando o volume**:

```bash
podman run -d \
  --name fake_api_server \
  -p 5001:5001 \
  -v ~/fake_api_data:/app/data \
  fake_api
```

✅ Flags explicadas:

* `-d` → roda em background
* `--name fake_api_server` → nome amigável para o container
* `-p 5001:5001` → expõe a porta para acesso local
* `-v ~/fake_api_data:/app/data` → monta volume persistente com os dados JSON

---

## 🩺 Como verificar se está rodando

✅ Ver containers ativos:

```bash
podman ps
```

✅ Testar a rota health check no browser ou terminal:

```bash
curl http://127.0.0.1:5001/health
```

✅ Ver logs do container:

```bash
podman logs fake_api_server
```

✅ Ver dados mock persistidos:

```bash
cat ~/fake_api_data/dados_mock.json
```

---

## 🛑 Como parar o container

Para parar o container rodando em background:

```bash
podman stop fake_api_server
```

---

## 🗑️ Como remover o container parado

Depois de parar, você pode remover o container:

```bash
podman rm fake_api_server
```

---

## 🔥 Como remover a imagem

Para limpar imagens antigas ou erradas:

```bash
podman images
podman rmi fake_api
```

---

## 💡 Dicas extras

✅ Ver todas as imagens locais:

```bash
podman images
```

✅ Ver todos os containers (inclusive parados):

```bash
podman ps -a
```

✅ Rodar removendo o container automaticamente ao parar:

```bash
podman run -d --rm -p 5001:5001 -v ~/fake_api_data:/app/data fake_api
```

---

## ✅ Exemplo de ciclo completo

```bash
# Buildar/atualizar a imagem
podman build -t fake_api .

# Parar e remover versão antiga se estiver rodando
podman stop fake_api_server
podman rm fake_api_server

# Criar volume e copiar dados iniciais (apenas 1ª vez)
mkdir -p ~/fake_api_data
cp data/dados_mock_exemplo.json ~/fake_api_data/dados_mock.json

# Rodar a nova versão com volume
podman run -d --name fake_api_server -p 5001:5001 -v ~/fake_api_data:/app/data fake_api

# Verificar logs
podman logs -f fake_api_server
```

---

✅ Com isso, sua **Fake API** está sempre pronta para rodar com dados persistentes, mockados e editáveis!
**Se atualizar a imagem ou os dados, basta rebuildar e restartar.**
