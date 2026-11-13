# Imagem base atualizada e enxuta (reduz superfície de ataque e CVEs)
FROM python:3.12-slim

# Atualiza pacotes do sistema operacional para corrigir CVEs conhecidas
RUN apt-get update && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

# Cria usuário não-root para execução segura da aplicação
RUN useradd -m appuser

WORKDIR /app

# Instala dependências Python atualizadas
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copia o código da aplicação e define permissões
COPY --chown=appuser:appuser . .

USER appuser

EXPOSE 5000

CMD ["python", "app.py"]