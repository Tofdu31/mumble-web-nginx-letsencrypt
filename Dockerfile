FROM alpine:edge

COPY ./ /home/node/

WORKDIR /home/node

RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    apk add --no-cache git nodejs npm tini websockify && \
    adduser -D -g 1001 -u 1001 -h /home/node node && \
    mkdir -p /home/node && \
    mkdir -p /home/node/.npm-global && \
    mkdir -p /home/node/app  && \
    chown -R node: /home/node

USER node

ENV PATH=/home/node/.npm-global/bin:$PATH
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global


# COPY ./ /opt/mumble-web/

# WORKDIR /opt/mumble-web

# RUN npm install && npm run build

RUN cd /home/node && \                                                                                                                                                                                                 npm install && \                                                                                                                                                                                                   npm run build                                                                                                                                                                                                  
USER root

RUN apk del gcc git make g++ || true

USER node

EXPOSE 80
ENV MUMBLE_SERVER=pushtotalk.nbility.fr

ENTRYPOINT ["/sbin/tini", "--"]
CMD websockify --ssl-target --web=/home/node/dist 80 "$MUMBLE_SERVER"
