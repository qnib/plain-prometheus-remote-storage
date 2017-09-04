ARG DOCKER_REGISTRY=docker.io
FROM ${DOCKER_REGISTRY}/qnib/alplain-golang as build

ARG COMMIT=aa5cdcb11e7fd987587045bec62194cc31a7a707
LABEL prometheus..commit=${COMMIT}
RUN apk --update add libarchive-tools wget \
 && mkdir -p /usr/local/src/github.com/prometheus/ \
 && wget -qO - https://github.com/prometheus/prometheus/archive/${COMMIT}.zip | bsdtar xfz - -C /usr/local/src/github.com/prometheus/ \
 && mv /usr/local/src/github.com/prometheus/prometheus-${COMMIT} /usr/local/src/github.com/prometheus/prometheus \
 && cd /usr/local/src/github.com/prometheus/prometheus/documentation/examples/remote_storage/remote_storage_adapter \
 && go build -o /usr/local/bin/prometheus-storage-adapter

FROM ${DOCKER_REGISTRY}/qnib/alplain-init
COPY --from=build /usr/local/bin/prometheus-storage-adapter /usr/local/bin/
COPY opt/qnib/prometheus/storage-adapter/bin/start.sh /opt/qnib/prometheus/storage-adapter/bin/
CMD ["opt/qnib/prometheus/storage-adapter/bin/start.sh"]
