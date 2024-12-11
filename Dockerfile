FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release \
    ca-certificates \
    software-properties-common \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# Prometheus
RUN curl -LO https://github.com/prometheus/prometheus/releases/download/v2.36.0/prometheus-2.36.0.linux-amd64.tar.gz \
    && tar -xvzf prometheus-2.36.0.linux-amd64.tar.gz \
    && mv prometheus-2.36.0.linux-amd64/prometheus /usr/local/bin/ \
    && rm -rf prometheus-2.36.0.linux-amd64*

# Grafana
RUN curl https://packages.grafana.com/gpg.key | tee /etc/apt/trusted.gpg.d/grafana.asc \
    && echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list \
    && apt-get update \
    && apt-get install -y grafana

WORKDIR /app

COPY ./prometheus/prometheus.yml /etc/prometheus/prometheus.yml

EXPOSE 9090 3000

CMD ["/bin/bash", "-c", "/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml & service grafana-server start && tail -f /dev/null"]
