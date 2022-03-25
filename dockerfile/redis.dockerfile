## This redis is used as debug client
FROM ubuntu as builder

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install git build-essential pkg-config -y

WORKDIR /tmp
RUN git clone https://github.com/redis/redis

WORKDIR /tmp/redis
RUN make

FROM ubuntu
WORKDIR /root/
RUN apt-get update
RUN apt-get install dnsutils -y

COPY --from=builder /tmp/redis/src/redis-cli /usr/local/bin
COPY --from=builder /tmp/redis/src/redis-server /usr/local/bin
COPY --from=builder /tmp/redis/src/redis-benchmark /usr/local/bin

CMD ["redis-benchmark"]

