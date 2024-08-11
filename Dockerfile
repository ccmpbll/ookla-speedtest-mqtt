FROM alpine:latest
LABEL Name=ookla-speedtest-mqtt
LABEL maintainer="Chris Campbell"

ARG SPEEDTEST_CLI_VERSION="1.2.0"

RUN apk --no-cache --no-progress update
RUN apk --no-cache --no-progress upgrade
RUN apk --no-cache --no-progress add bash curl mosquitto-clients -y
RUN rm -rf /tmp/* /var/tmp/*

RUN wget https://install.speedtest.net/app/cli/ookla-speedtest-${SPEEDTEST_CLI_VERSION}-linux-x86_64.tgz -O /tmp/ookla-speedtest.tgz

RUN tar zxvf /tmp/ookla-speedtest.tgz -C /tmp speedtest
RUN mv /tmp/speedtest /bin/speedtest
RUN ["chmod", "+x", "/bin/speedtest"]
RUN rm /tmp/ookla-speedtest.tgz

COPY speedtest.sh /usr/bin
RUN ["chmod", "+x", "/usr/bin/speedtest.sh"]

CMD /usr/bin/speedtest.sh