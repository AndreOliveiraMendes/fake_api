import json
import os
from threading import Lock

from flask import Flask, jsonify, request, send_from_directory

from config import API_BASIC_PASS, API_BASIC_USER, API_HOST, API_PORT, DEBUG_MODE, TOKEN

app = Flask(__name__)

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_FILE = os.path.abspath(os.path.join(BASE_DIR, '..', 'data', 'dados_mock.json'))

# 🔒 controle de concorrência
lock = Lock()

# ✅ estado em memória
DADOS_USUARIO = []


# ========================
# DATA LAYER
# ========================

def get_data():
    return DADOS_USUARIO


def set_data(data):
    global DADOS_USUARIO
    DADOS_USUARIO = data


def load_data():
    if os.path.exists(DATA_FILE):
        try:
            with open(DATA_FILE, 'r') as f:
                data = json.load(f)
                set_data(data)
                app.logger.info("Dados carregados de %s", DATA_FILE)
        except json.JSONDecodeError:
            app.logger.warning("JSON inválido. Inicializando vazio.")
            set_data([])
    else:
        app.logger.warning("Arquivo não encontrado. Inicializando vazio.")
        set_data([])


def save_data():
    with lock:
        with open(DATA_FILE, 'w') as f:
            json.dump(get_data(), f, indent=2)
        app.logger.info("Dados salvos em %s", DATA_FILE)


# ========================
# VALIDATION
# ========================

def validar_usuario_mock(data):
    try:
        usuario = data["usuario"]
        pessoa = usuario["pessoa"]

        return all([
            data.get("login"),
            data.get("senha"),
            usuario.get("codigo"),
            usuario.get("tipo"),
            usuario.get("situacao"),
            usuario.get("grupo"),
            pessoa.get("codigo"),
            pessoa.get("nome"),
            pessoa.get("email"),
        ])
    except Exception:
        return False


# ========================
# ROUTES
# ========================

@app.route('/mock_data', methods=['GET'])
def listar_mock_users():
    return jsonify(get_data()), 200


@app.route('/mock_data', methods=['POST'])
def add_mock_user():
    data = request.get_json(silent=True)

    if not data:
        return jsonify({"error": "JSON não enviado."}), 400

    if not validar_usuario_mock(data):
        return jsonify({"error": "Formato inválido de usuário mock."}), 400

    usuarios = get_data()
    usuarios.append(data)

    save_data()

    return jsonify({"message": "Usuário adicionado com sucesso!"}), 201


@app.route('/health')
def health():
    return jsonify({
        "status": "ok",
        "users_loaded": len(get_data()),
        "file_exists": os.path.exists(DATA_FILE),
        "version": "1.5.0",
        "service": "fake_api"
    }), 200


@app.route('/autenticar/json', methods=['POST'])
def autenticar():
    auth = request.authorization

    if not auth:
        return jsonify({"error": "Unauthorized"}), 401

    if auth.username != API_BASIC_USER or auth.password != API_BASIC_PASS:
        return jsonify({"error": "Unauthorized"}), 401

    login = request.form.get('login')
    senha = request.form.get('senha')

    for user in get_data():
        if login == str(user['login']) and senha == str(user['senha']):
            return jsonify({"usuario": user["usuario"]}), 200

    return jsonify({"erro": "Usuário não encontrado"}), 404


@app.route('/reload', methods=['POST'])
def reload_data():
    token = request.args.get('token')

    if token != TOKEN:
        return jsonify({"error": "Unauthorized"}), 403

    app.logger.info("Reload triggered!")
    load_data()

    return jsonify({"ok": "recarregado"}), 200


@app.route('/favicon.ico')
def favicon():
    return send_from_directory(
        os.path.join(app.root_path, 'static', 'images'),
        'favicon.png',
        mimetype='image/vnd.microsoft.icon'
    )


# ========================
# STARTUP
# ========================

load_data()

if __name__ == '__main__':
    app.run(debug=DEBUG_MODE, host=API_HOST, port=API_PORT)
