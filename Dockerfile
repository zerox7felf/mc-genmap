FROM debian:latest

RUN apt-get update
RUN apt-get install -y git make g++ cmake libpng-dev libspdlog-dev curl cron

WORKDIR /mcmap-build
RUN git clone https://github.com/spoutn1k/mcmap
RUN mkdir -p mcmap/build && cd mcmap/build && cmake .. && make -j

WORKDIR /mcmap
RUN mv /mcmap-build/mcmap/build/bin/* /mcmap/

WORKDIR /unmined-build
RUN curl -#L https://unmined.net/download/unmined-cli-linux-x64-dev/?tmstv=1706219771 -o unmined.tar.gz
RUN tar -xf unmined.tar.gz

WORKDIR /unmined
RUN mv /unmined-build/unmined*/* /unmined/

RUN touch /var/log/cron.log
COPY ./genmap.sh /unmined/genmap.sh
RUN chmod +x /unmined/genmap.sh
RUN echo "*/5 * * * * /unmined/genmap.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/genmap
RUN chmod 0644 /etc/cron.d/genmap
RUN crontab /etc/cron.d/genmap

CMD cron && tail -f /var/log/cron.log
