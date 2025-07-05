# 🧪 Manual do Fake API

Pequeno guia para construir, rodar e gerenciar o container da *fake_api* usando Podman.

---

## 📦 Como buildar (ou atualizar) a imagem

Se você alterou o código (ex.: `main.py`, `requirements.txt`), faça:

```bash
podman build -t fake_api .
```

✅ Isso cria ou atualiza a imagem chamada **fake\_api**.

✔️ Se quiser forçar sem cache:

```bash
podman build --no-cache -t fake_api .
```

---

## 🚀 Como startar (rodar) a fake\_api

Rodar em background (detached), expondo a porta 5001:

```bash
podman run -d --name fake_api_server -p 5001:5001 fake_api
```

✅ Flags explicadas:

* `-d` → roda em background
* `--name fake_api_server` → nome amigável para o container
* `-p 5001:5001` → expõe a porta para acesso local

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
podman run -d --rm -p 5001:5001 fake_api
```

---

## ✅ Exemplo de ciclo completo

```bash
# Buildar/atualizar a imagem
podman build -t fake_api .

# Parar e remover versão antiga se estiver rodando
podman stop fake_api_server
podman rm fake_api_server

# Rodar a nova versão
podman run -d --name fake_api_server -p 5001:5001 fake_api

# Verificar logs
podman logs -f fake_api_server
```