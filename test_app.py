import pytest
import app as app_module
from app import app


@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client


def test_home_status_code(client):
    resposta = client.get('/')
    assert resposta.status_code == 200


def test_home_mensagem(client):
    resposta = client.get('/')
    dados = resposta.get_json()
    assert dados['mensagem'] == "Bem-vindo a API FastOrder!"


def test_soma(client):
    resposta = client.get('/api/soma?a=10&b=5')
    dados = resposta.get_json()

    assert resposta.status_code == 200
    assert dados['resultado'] == 15


def test_status_flag_desativada(client, monkeypatch):
    monkeypatch.setattr(app_module, 'FEATURE_DESCONTO_PROMO', False)
    resposta = client.get('/api/status')
    dados = resposta.get_json()

    assert resposta.status_code == 200
    assert dados['flags']['desconto_promo'] is False


def test_desconto_bloqueado_quando_flag_desativada(client, monkeypatch):
    monkeypatch.setattr(app_module, 'FEATURE_DESCONTO_PROMO', False)
    resposta = client.get('/api/desconto?valor=100&porcentagem=15')
    dados = resposta.get_json()

    assert resposta.status_code == 403
    assert 'desativada' in dados['erro']


def test_desconto_funcionando_quando_flag_ativada(client, monkeypatch):
    monkeypatch.setattr(app_module, 'FEATURE_DESCONTO_PROMO', True)
    resposta = client.get('/api/desconto?valor=100&porcentagem=15')
    dados = resposta.get_json()

    assert resposta.status_code == 200
    assert dados['valor_final'] == 85.0
    assert dados['desconto_aplicado'] == "15.0%"
    