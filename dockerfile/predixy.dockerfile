# Build image

FROM alpine:3.14 as builder

ENV PREDIXY_URL https://github.com/joyieldInc/predixy/archive/refs/tags/1.0.5.tar.gz

RUN apk --no-cache add alpine-sdk curl
RUN curl -L "$PREDIXY_URL" | tar xzf -

WORKDIR /predixy-1.0.5
# fix return type mismtach error
RUN sed -i "39 s/.*/#if false/" src/Util.h
# fix no execinfo.h error
RUN	sed -i "21d" src/Makefile
RUN	make

RUN cp src/predixy /tmp/predixy
RUN cp -r conf /etc

# Main image

FROM alpine:3.14

# predixy binary requires libgcc_s.so.1
RUN apk --no-cache add libgcc

COPY --from=builder /tmp/predixy /usr/local/sbin/predixy
COPY --from=builder /etc/conf /etc/conf

# remove unsed configurations
RUN sed -i "/^Include/ s/./# &/" /etc/conf/predixy.conf
# enable redis cluster configuration
RUN sed -i "s/^# Include cluster/Include cluster/" /etc/conf/predixy.conf

### XXX: use a script to add servers to /etc/conf/cluster.conf

EXPOSE 7617
CMD ["predixy /etc/conf/predixy.conf"]
