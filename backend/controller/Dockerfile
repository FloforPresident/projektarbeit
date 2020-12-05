FROM python:3.8

WORKDIR /app
ADD . /app

COPY controller/pyproject.toml controller/poetry.lock /app/

RUN pip install poetry && poetry config virtualenvs.create false && poetry install --no-root --no-dev

ENV PYTHONUNBUFFERED definitely

CMD ["python", "controller/controller/websocket.py"]