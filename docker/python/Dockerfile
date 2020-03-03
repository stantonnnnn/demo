FROM python:3
# Dockerhub stuff doesn't update as frequently as we'd like, so ensure
#   that we update right here.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    pip install flask pandas --no-cache-dir && \
    mkdir /app && \
    useradd -d /app python && \
    chown python:python /app
USER python
EXPOSE 5000/tcp
CMD [ "/usr/local/bin/flask", "run", "--host", "0.0.0.0" ]
