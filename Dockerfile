# PIN THIS DIGEST after first pull:
# docker pull ubuntu:24.04
# docker inspect --format='{{index .RepoDigests 0}}' ubuntu:24.04
FROM ubuntu:24.04@sha256:sha256:cd1dba651b3080c3686ecf4e3c4220f026b521fb76978881737d24f200828b2b

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git xz-utils python3 python3-venv python3-pip \
  && rm -rf /var/lib/apt/lists/*

# reproducible metadata
ARG VCS_REF=unknown
ARG BUILD_DATE=unknown
LABEL org.opencontainers.image.source="https://github.com/inaciovasquez2020/urf-core" \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.created=$BUILD_DATE

WORKDIR /work
COPY . /work

# Build deps deterministically (no caches inside image)
RUN rm -rf .lake || true

CMD ["bash","-lc","python3 tools/rolecheck/rolecheck.py core && echo OK"]
