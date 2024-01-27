# Build mcmap in separate image
FROM debian:latest AS mcmap-build
RUN apt-get update \
    && apt-get install -y git make g++ cmake libpng-dev libspdlog-dev

WORKDIR /mcmap-build
RUN git clone https://github.com/spoutn1k/mcmap \
    && mkdir -p mcmap/build \
    && cd mcmap/build \
    && cmake .. \
    && make -j

# Main image
FROM debian:latest AS mcmap
RUN apt-get update \
    && apt-get install -y curl cron libicu-dev libgomp1

# Copy over mcmap binaries
WORKDIR /mcmap
COPY --from=mcmap-build /mcmap-build/mcmap/build/bin/* /mcmap/

# Download + unpack unmined
WORKDIR /unmined
RUN curl -#L https://unmined.net/download/unmined-cli-linux-x64-dev/?tmstv=1706219771 -o unmined.tar.gz \
    && tar -xf unmined.tar.gz -C /tmp \
    && rm unmined.tar.gz \
    && mv /tmp/unmined*/* /unmined/ \
    && rm -r /tmp/unmined*

# Copy over script and set up cronjob
COPY ./genmap.sh /unmined/genmap.sh
RUN chmod +x /unmined/genmap.sh \
    && echo "*/5 * * * * /unmined/genmap.sh > /proc/1/fd/1 2>/proc/1/fd/2" > /etc/cron.d/genmap \
    && chmod 0644 /etc/cron.d/genmap \
    && crontab /etc/cron.d/genmap

# PAM bug :(
# https://stackoverflow.com/questions/43323754/cannot-make-remove-an-entry-for-the-specified-session-cron
RUN sed -i '/session    required     pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/cron

ENTRYPOINT [ "cron", "-f" ] 
