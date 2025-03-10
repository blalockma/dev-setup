FROM ubuntu:22.04 as base

WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl wget git build-essential sudo tzdata && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS user
RUN addgroup --gid 1000 mason
RUN adduser --gecos mason --uid 1000 --gid 1000 --disabled-password mason
RUN adduser mason sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER mason
WORKDIR /home/mason

RUN git clone https://github.com/blalockma/dev-setup.git
WORKDIR /home/mason/dev-setup

RUN ./run 1_
RUN ./run 2_
RUN ./run 3_
RUN ./run 4_
RUN ./run 5_

WORKDIR /home/mason

ENTRYPOINT ["/bin/zsh"]
