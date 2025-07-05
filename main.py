from flask import Flask, request, jsonify

app = Flask(__name__)

# Dados simulados
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
    }}
]

@app.route('/api/autenticar/json', methods=['POST'])
def autenticar():
    login = request.form.get('login')
    senha = request.form.get('senha')
    
    for user in DADOS_USUARIO:
        if login == user['login'] and senha == user['senha']:
            return jsonify({"usuario": user["usuario"]}), 200
    else:
        return jsonify({"erro": "Usuário não encontrado"}), 404
    
@app.route('/health')
def health():
    return jsonify({
        "status": "ok",
        "service": "fake_api",
        "version": "1.0.0"
    }), 200

@app.route('/mock_data')
def mock_data():
    return jsonify(DADOS_USUARIO)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=5001)
