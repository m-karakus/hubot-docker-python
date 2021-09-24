FROM python:3.8-slim-buster

RUN apt-get update \
    && apt-get install -y jq curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

RUN apt-get update \
    && apt-get install -y nodejs npm \
    && apt-get install -y build-essential \
    && apt-get install -y libssl-dev \
    && apt-get install -y git-core \
    && apt-get install -y redis-server \
    && apt-get install -y libexpat1-dev \
    && npm install -g coffee-script \
    && npm install -g npm@latest \
    && npm install -g yo@3 generator-hubot \
    && rm -rf /var/lib/apt/lists/*

# Create ubuntu user with sudo privileges
RUN useradd -G sudo hubot

# New added for disable sudo password
ENV HOME /home/hubot
WORKDIR $HOME

COPY package.json .
RUN npm install && npm cache clean --force

COPY . .

RUN chown -R hubot:hubot .
USER hubot

RUN yo hubot --adapter=slack --owner="metin <metin.karakus@yahoo.com>" --name="mr-robot" --description="A simple robot" --defaults
# RUN npm uninstall hubot-heroku-keepalive --save
#COPY external-scripts.json /hubot/

EXPOSE 80
CMD ["/bin/bash", "-c", "HUBOT_SLACK_TOKEN=XXXXXXX ./bin/hubot --name mr-robot --adapter slack"]
