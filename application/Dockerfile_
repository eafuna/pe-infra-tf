FROM python:3.10.13-slim-bullseye

ADD requirements.txt requirements.txt

ADD server.py server.py

RUN pip install -r requirements.txt --no-cache-dir

ENTRYPOINT ["python3"]
CMD ["server.py"]

# Run docker build -f Dockerfile . -t web-server-test
# Run docker run -rm -p 8000:80 — name web-server-test web-server-test