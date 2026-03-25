# Use a minimal base image (e.g., alpine)
FROM python:3.13-trixie

# Install the MariaDB client
RUN apt-get update && \
    apt-get install -y \
    curl \
    # wget \
    # make \
    # gnupg \
    mariadb-client \
    redis-tools \
    kafkacat \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install cqlsh --break-system-packages

# (Optional) Pre-configure the connection
ENV CQLSH_HOST=cassandra-host
ENV CQLSH_PORT=9042

# RabbitMQ Admin
ARG TARGETARCH
ADD https://github.com/rabbitmq/rabbitmqadmin-ng/releases/download/v2.28.0/rabbitmqadmin_2.28.0_${TARGETARCH}.deb /tmp/

RUN dpkg -i /tmp/rabbitmqadmin_2.28.0_${TARGETARCH}.deb && \
    rm /tmp/rabbitmqadmin_2.28.0_${TARGETARCH}.deb

# Set the working directory
WORKDIR /app

# Copy your script(s) into the image
COPY ./scripts ./

RUN chmod +x ./*.sh

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["./db-sleep.sh"]

