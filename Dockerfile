FROM python:3.14-slim

WORKDIR /app

# The mcp package depends on ada-url, which is a C++ library that needs to be
# compiled from source. The following adds the C++ compiler and build tools.
RUN apt-get update && \
    apt-get install -y g++ build-essential && \
    rm -rf /var/lib/apt/lists/*

ENV POETRY_VERSION=2.2.1 \
    POETRY_VIRTUALENVS_IN_PROJECT=true

ENV PATH="/app/.venv/bin:$PATH"

RUN pip install "poetry==${POETRY_VERSION}"

COPY poetry.lock pyproject.toml ./
RUN poetry install --only main

COPY . .

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
