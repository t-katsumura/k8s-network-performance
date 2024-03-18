FROM ubuntu:24.04

RUN apt-get update && apt-get install -y \
    vim \
    curl \
    iperf \
    iperf3 \
    netperf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
