# Imagem base Alpine enxuta (superfície de ataque mínima e sem CVEs de pacotes Debian)
FROM python:3.12-alpine

# Atualiza índices e pacotes do sistema Alpine
RUN apk update && apk upgrade --no-cache

# Cria usuário não-root para execução segura da aplicação
RUN adduser -D appuser

WORKDIR /app

# Instala dependências Python atualizadas
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r requirements.txt

# Copia o código da aplicação e define permissões
COPY --chown=appuser:appuser . .

USER appuser

EXPOSE 5000

CMD ["python", "app.py"]