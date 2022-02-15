FROM python:3.9.10

RUN pip install devpi-server==6.4.0 devpi-web==4.0.8 --no-cache-dir

COPY . /root/.devpi

VOLUME ["/var/db"]

CMD ["sh", "root/.devpi/run.sh"]