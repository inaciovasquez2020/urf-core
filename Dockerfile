# syntax=docker/dockerfile:1.7

FROM python:3.11-slim AS runtime

ARG VCS_REF=unknown
ARG BUILD_DATE=unknown
ARG VERSION=dev

LABEL org.opencontainers.image.title="urf-sg-verifier" \
      org.opencontainers.image.description="Deterministic verifier for URF spectral-gap certificate JSON artifacts." \
      org.opencontainers.image.source="https://github.com/inaciovasquez2020/urf-core" \
      org.opencontainers.image.url="https://github.com/inaciovasquez2020/urf-core/pkgs/container/urf-sg-verifier" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.licenses="MIT"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN addgroup --system urf \
 && adduser --system --ingroup urf --home /app urf \
 && mkdir -p /app/verification /app/standards/URF-SG

COPY requirements-sg-verifier.txt /app/requirements-sg-verifier.txt
RUN pip install --no-cache-dir -r /app/requirements-sg-verifier.txt

COPY --chown=urf:urf verification/verify.py /app/verification/verify.py
COPY --chown=urf:urf standards/URF-SG/schema.json /app/standards/URF-SG/schema.json
COPY --chown=urf:urf verification/certs/URF-SG-BASE-2.json /app/verification/certs/URF-SG-BASE-2.json

USER urf

ENTRYPOINT ["python", "/app/verification/verify.py"]
