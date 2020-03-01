FROM frolvlad/alpine-glibc
ENTRYPOINT ["/ENTRYPOINT.sh"]
COPY ENTRYPOINT.sh /ENTRYPOINT.sh
EXPOSE 2222
EXPOSE 8080

ARG VERSION=0.0.8

ENV AWS_ACCESS_KEY_ID= \
    AWS_SECRET_ACCESS_KEY= \
    AWS_REGIONS=us-west-2 \
    AWS_LAMBDA_MEMORY=128 \
    SSH_PORT=2222 \
    PROXY_LISTENERS="admin:awslambdaproxy@:8080" \
    PROXY_FREQUENCY_REFRESH="14m20s"

RUN addgroup -g 1000 -S ssh && \
    adduser -u 1000 -S ssh -G ssh

RUN apk add --no-cache openssh-server unzip wget ca-certificates

COPY sshd_config /etc/ssh/sshd_config

WORKDIR /app

RUN wget --quiet https://github.com/dan-v/awslambdaproxy/releases/download/v${VERSION}/awslambdaproxy-linux-x86-64.zip

RUN unzip awslambdaproxy-linux-x86-64.zip && rm awslambdaproxy-linux-x86-64.zip

RUN apk del --purge --no-cache unzip wget \
    && rm -rf /var/cache/apk/*

USER ssh

RUN mkdir ${HOME}/.ssh

LABEL maintainer="awslambdaproxy <https://github.com/dan-v/awslambdaproxy>" \
    description="An AWS Lambda powered HTTP/SOCKS web proxy." \
    version="${VERSION}" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.name="awslambdaproxy" \
    org.label-schema.version="${VERSION}" \
    org.label-schema.usage="https://github.com/unixfox/awslambdaproxy-docker" \
    org.opencontainers.image.title="awslambdaproxy" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.documentation="https://github.com/unixfox/awslambdaproxy-docker"