# Estágio 1: Builder (instala as dependências num virtualenv isolado)
FROM python:3.13-alpine AS builder

WORKDIR /app
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Estágio 2: Imagem final enxuta (copia apenas o virtualenv sem ferramentas de build antigas)
FROM python:3.13-alpine

RUN apk update && apk upgrade --no-cache && \
    adduser -D appuser

WORKDIR /app

COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY --chown=appuser:appuser . .

USER appuser

ENV FLASK_HOST=0.0.0.0
EXPOSE 5000

CMD ["python", "app.py"]