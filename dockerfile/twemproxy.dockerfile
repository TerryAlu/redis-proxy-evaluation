# Build image

FROM alpine:3.14 as builder

ENV TWEMPROXY_URL https://github.com/twitter/twemproxy/releases/download/0.5.0/twemproxy-0.5.0.tar.gz

RUN apk --no-cache add alpine-sdk autoconf automake curl libtool

RUN curl -L "$TWEMPROXY_URL" | tar xzf - && \
    TWEMPROXY_DIR=$(find / -maxdepth 1 -iname "twemproxy*" | sort | tail -1) && \
    cd $TWEMPROXY_DIR && \
    autoreconf -fvi && CFLAGS="-ggdb3 -O0" ./configure --enable-debug=full && make && make install


# Main image

FROM alpine:3.14

RUN apk --no-cache add dumb-init
RUN apk --no-cache add bind-tools # nslookup

COPY --from=builder /usr/local/sbin/nutcracker /usr/local/sbin/nutcracker

EXPOSE 7777
CMD ["nutcracker"]
