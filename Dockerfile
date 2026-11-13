# Imagem base Alpine enxuta (superfície de ataque mínima)
FROM python:3.12-alpine

# Atualiza índices e pacotes do sistema Alpine
RUN apk update && apk upgrade --no-cache

# Cria usuário não-root para execução segura da aplicação
RUN adduser -D appuser

WORKDIR /app

# Instala dependências Python atualizadas e remove wheels antigos embutidos (CVE-2025-47273)
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r requirements.txt && \
    rm -rf /usr/local/lib/python3.12/ensurepip/_bundled/*

# Copia o código da aplicação e define permissões
COPY --chown=appuser:appuser . .

USER appuser

ENV FLASK_HOST=0.0.0.0
EXPOSE 5000

CMD ["python", "app.py"]