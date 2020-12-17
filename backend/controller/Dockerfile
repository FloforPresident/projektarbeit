FROM python:3.8

WORKDIR /app
ADD . /app

COPY controller/pyproject.toml controller/poetry.lock /app/

RUN apt-get update && \
    apt-get install cmake
RUN apt-get install -y python3-dev
RUN pip install poetry && poetry config virtualenvs.create false && poetry install --no-root --no-dev

ENV PYTHONUNBU, dannFFERED definitely

CMD ["python", "controller/controller/websocket.py"]