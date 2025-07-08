import os
import json
from flask import Flask, request, jsonify
from config import API_HOST, API_BASIC_USER, API_BASIC_PASS

app = Flask(__name__)

# 🗂️ Define o caminho do arquivo de dados externo
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_FILE = os.path.abspath(os.path.join(BASE_DIR, '..', 'data', 'dados_mock.json'))

# ✅ Inicializa lista em memória
DADOS_USUARIO = []

# ✅ Função para carregar do JSON no disco
def load_data():
    global DADOS_USUARIO
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE, 'r') as f:
            try:
                DADOS_USUARIO = json.load(f)
                app.logger.info("Dados carregados de %s", DATA_FILE)
            except json.JSONDecodeError:
                app.logger.warning("Arquivo JSON vazio ou inválido. Inicializando vazio.")
                DADOS_USUARIO = []
    else:
        app.logger.warning("Arquivo %s não encontrado. Inicializando vazio.", DATA_FILE)
        DADOS_USUARIO = []

# ✅ Função para salvar para JSON no disco
def save_data():
    with open(DATA_FILE, 'w') as f:
        json.dump(DADOS_USUARIO, f, indent=2)
    app.logger.info("Dados salvos em %s", DATA_FILE)

# ✅ Validação básica do schema esperado
def validar_usuario_mock(data):
    if not isinstance(data, dict):
        return False
    if "login" not in data or "senha" not in data or "usuario" not in data:
        return False
    usuario = data["usuario"]
    pessoa = usuario.get("pessoa", {})
    required_usuario_fields = ["codigo", "tipo", "situacao", "grupo"]
    required_pessoa_fields = ["codigo", "nome", "email"]
    if not all(k in usuario for k in required_usuario_fields):
        return False
    if not all(k in pessoa for k in required_pessoa_fields):
        return False
    return True

# ✅ Rotas

@app.route('/mock_data', methods=['GET'])
def listar_mock_users():
    return jsonify(DADOS_USUARIO), 200

@app.route('/mock_data', methods=['POST'])
def add_mock_user():
    data = request.get_json()
    if not data:
        return jsonify({"error": "JSON não enviado."}), 400
    if not validar_usuario_mock(data):
        return jsonify({"error": "Formato inválido de usuário mock."}), 400
    DADOS_USUARIO.append(data)
    save_data()
    return jsonify({"message": "Usuário adicionado com sucesso!"}), 201

@app.route('/health')
def health():
    return jsonify({
        "status": "ok",
        "service": "fake_api",
        "version": "1.3.0"
    }), 200

@app.route('/api/autenticar/json', methods=['POST'])
def autenticar():
    auth = request.authorization
    if not auth or auth.username != API_BASIC_USER or auth.password != API_BASIC_PASS:
        return jsonify({"error": "Unauthorized"}), 401

    login = request.form.get('login')
    senha = request.form.get('senha')
    for user in DADOS_USUARIO:
        if login == str(user['login']) and senha == str(user['senha']):
            return jsonify({"usuario": user["usuario"]}), 200
    else:
        return jsonify({"erro": "Usuário não encontrado"}), 404

# ✅ Carrega os dados quando iniciar
if __name__ == '__main__':
    load_data()
    app.run(debug=True, host=API_HOST, port=5001)
