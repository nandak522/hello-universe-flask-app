FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    TZ=Asia/Kolkata \
    DEBUG_DEPS="curl less lsof strace netcat net-tools" \
    BUILD_DEPS="build-essential" \
    APP_DEPS="python3-dev python3-pip tzdata" \
    APP_USER=appuser

WORKDIR /app

RUN set -ex \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && groupadd --system ${APP_USER} \
    && useradd --no-log-init --system --create-home --gid ${APP_USER} ${APP_USER} \
    && usermod -u 1000 ${APP_USER} \
    && groupmod -g 1000 ${APP_USER} \
    && chown -Rv ${APP_USER}:${APP_USER} /app \
    && apt-get update && apt-get install -y --no-install-recommends ${BUILD_DEPS} ${APP_DEPS} ${DEBUG_DEPS} \
    && rm -rf /usr/share/doc && rm -rf /usr/share/man \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false ${BUILD_DEPS} \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

USER ${APP_USER}
COPY --chown=${APP_USER}:${APP_USER} requirements.txt .
COPY --chown=${APP_USER}:${APP_USER} main.py .
RUN pip3 install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD ["python3", "main.py"]
