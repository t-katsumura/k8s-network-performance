FROM ubuntu:24.04@sha256:723ad8033f109978f8c7e6421ee684efb624eb5b9251b70c6788fdb2405d050b as builder

RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    git \
    zlib1g-dev \
    && git clone https://github.com/giltene/wrk2.git \
    && cd wrk2 \
    && make \
    && cp wrk /usr/local/bin/wrk2

FROM ubuntu:24.04@sha256:723ad8033f109978f8c7e6421ee684efb624eb5b9251b70c6788fdb2405d050b

COPY --from=builder /usr/local/bin/wrk2 /usr/local/bin/wrk2

RUN apt-get update && apt-get install -y \
    nano \
    wrk \
    curl \
    iperf \
    iperf3 \
    netperf \
    net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
