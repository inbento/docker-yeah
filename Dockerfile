FROM python:3.11-alpine

WORKDIR /app

RUN apk add --no-cache --virtual .build-deps \
    gcc \
    && pip install --no-cache-dir uv \
    && apk del .build-deps

COPY pyproject.toml .
RUN uv pip install --system --no-cache -r pyproject.toml --extra test \
    && rm -rf /root/.cache

COPY src/ ./src/
COPY tests/ ./tests/

EXPOSE 8020

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8020"]
