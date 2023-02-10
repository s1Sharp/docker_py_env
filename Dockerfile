FROM ubuntu:22.04

LABEL maintainer="maksim.carkov.201300@gmail.com"

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y systemd
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow
RUN apt-get install -y tzdata

WORKDIR /code

# Открываем порты
EXPOSE 22
EXPOSE 3000
EXPOSE 5000
EXPOSE 8848
EXPOSE 8080
EXPOSE 5432

RUN apt-get -y install git
RUN apt-get install -y python3-pip python3.10-venv
RUN python3 --version && pip3 -V
RUN apt-get install -y postgresql postgresql-contrib
RUN apt-get -y install ufw
RUN ufw allow 5432/tcp
RUN sed -i '/^host/s/ident/md5/' /etc/postgresql/14/main/pg_hba.conf
RUN sed -i '/^local/s/peer/trust/' /etc/postgresql/14/main/pg_hba.conf
RUN echo \
	"host    all             all             0.0.0.0/0                md5" >> /etc/postgresql/14/main/pg_hba.conf
RUN echo \
	"listen_addresses='*'" >> /etc/postgresql/14/main/postgresql.conf

RUN service postgresql start

COPY requirements.txt .
COPY psql_user_create.sh .
COPY .ssh /root/.ssh
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/id_rsa && chmod 644 /root/.ssh/id_rsa.pub

RUN python3 -m pip install -r requirements.txt

ENTRYPOINT ["/bin/bash"]