from flask import Flask, request, jsonify

app = Flask(__name__)

# Mock inicial
DADOS_USUARIO = [{
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
}]

# Validação do formato esperado
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

# GET → Lista todos
@app.route('/mock_data', methods=['GET'])
def listar_mock_users():
    return jsonify(DADOS_USUARIO), 200

# POST → Adiciona novo
@app.route('/mock_data', methods=['POST'])
def add_mock_user():
    data = request.get_json()

    if not data:
        return jsonify({"error": "JSON não enviado."}), 400

    if not validar_usuario_mock(data):
        return jsonify({"error": "Formato inválido de usuário mock."}), 400

    DADOS_USUARIO.append(data)
    return jsonify({"message": "Usuário adicionado com sucesso!"}), 201

# Health check
@app.route('/health')
def health():
    return jsonify({
        "status": "ok",
        "service": "fake_api",
        "version": "1.1.0"
    }), 200

@app.route('/api/autenticar/json', methods=['POST'])
def autenticar():
    login = request.form.get('login')
    senha = request.form.get('senha')
    
    for user in DADOS_USUARIO:
        if login == user['login'] and senha == user['senha']:
            return jsonify({"usuario": user["usuario"]}), 200
    else:
        return jsonify({"erro": "Usuário não encontrado"}), 404
    

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=5001)
