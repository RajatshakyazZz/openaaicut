FROM denoland/deno:bin AS deno

FROM python:3.11-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends ffmpeg ca-certificates bzip2 fonts-noto-core fonts-noto-cjk \
 && rm -rf /var/lib/apt/lists/*

COPY --from=deno /deno /usr/local/bin/deno

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY studio studio
COPY web web

ENV OPENAICUT_DATA=/data \
    OPENAICUT_HOST=0.0.0.0 \
    OPENAICUT_TRUST_PROXY=1 \
    PYTHONUNBUFFERED=1

EXPOSE 8765

CMD ["python", "-m", "studio.server"]
