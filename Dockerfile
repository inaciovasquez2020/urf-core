# Pin digest after step below
FROM ubuntu:24.04@sha256:sha256:cd1dba651b3080c3686ecf4e3c4220f026b521fb76978881737d24f200828b2b
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git xz-utils python3 \
  && rm -rf /var/lib/apt/lists/*
WORKDIR /work
COPY . /work
RUN rm -rf .lake || true
CMD ["bash","-lc","python3 tools/rolecheck/rolecheck.py core && echo OK"]
