#!/bin/bash
set -euo pipefail

log() {
    echo "$(date +%D_%T) - $*" >> /proc/1/fd/1
}

# Validate required environment variables
: "${MQTT_SERVER:?MQTT_SERVER is required}"
: "${MQTT_TOPIC:?MQTT_TOPIC is required}"
: "${CRON:?CRON is required}"

log "Setting up cron job..."
{
    echo "MQTT_SERVER=\"$MQTT_SERVER\""
    echo "MQTT_TOPIC=\"$MQTT_TOPIC\""
    [ -n "${MQTT_USER:-}" ] && echo "MQTT_USER=\"$MQTT_USER\""
    [ -n "${MQTT_PASS:-}" ] && echo "MQTT_PASS=\"$MQTT_PASS\""
    [ -n "${SERVER_ID:-}" ] && echo "SERVER_ID=\"$SERVER_ID\""
    [ -n "${TZ:-}" ] && echo "TZ=\"$TZ\""
    echo "$CRON /usr/bin/speedtest.sh"
} | crontab - || { log "ERROR: Failed to install crontab. Exiting."; exit 1; }

log "Running cron in foreground..."
exec cron -f
