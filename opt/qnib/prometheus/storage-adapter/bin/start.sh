#!/bin/bash

export EXTRA_ARGS="-influxdb-url=http://${INFLUXDB_HOST:-tasks.influxdb}:8086/ -influxdb.database=${INFLUXDB_DB:-prometheus} -influxdb.retention-policy=${INFLUXDB_RETENTION_POLICY:-autogen}"

prometheus-storage-adapter ${EXTRA_ARGS}
