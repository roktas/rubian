FROM debian

ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=$DEBIAN_FRONTEND

RUN apt-get -y update
RUN apt-get install -y --no-install-recommends curl ca-certificates bats shellcheck

COPY . /app
WORKDIR /app

ENTRYPOINT ["/usr/bin/bats"]
CMD ["tests"]
