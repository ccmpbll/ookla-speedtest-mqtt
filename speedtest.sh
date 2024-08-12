#!/bin/bash

mqttwithpass() {
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/ping/jitter -m $(jq -r '.ping.jitter' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/ping/latency -m $(jq -r '.ping.latency' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/ping/low -m $(jq -r '.ping.low' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/ping/high -m $(jq -r '.ping.high' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/download/bandwidth -m $(echo "scale=2; $(jq -r '.download.bandwidth' /tmp/speedtest-result)/125000" | bc)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/download/latency/iqm -m $(jq -r '.download.latency.iqm' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/download/latency/low -m $(jq -r '.download.latency.low' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/download/latency/high -m $(jq -r '.download.latency.high' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/download/latency/jitter -m $(jq -r '.download.latency.jitter' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/upload/bandwidth -m $(echo "scale=2; $(jq -r '.upload.bandwidth' /tmp/speedtest-result)/125000" | bc)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/upload/latency/iqm -m $(jq -r '.upload.latency.iqm' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/upload/latency/low -m $(jq -r '.upload.latency.low' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/upload/latency/high -m $(jq -r '.upload.latency.high' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/upload/latency/jitter -m $(jq -r '.upload.latency.jitter' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/packetloss -m $(jq -r '.packetLoss' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/isp -m $(jq -r '.isp' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/interface/externalip -m $(jq -r '.interface.externalIp' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/server/id -m $(jq -r '.server.id' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/server/name -m $(jq -r '.server.name' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/server/location -m $(jq -r '.server.location' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/server/country -m $(jq -r '.server.country' /tmp/speedtest-result)
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC/server/ip -m $(jq -r '.server.ip' /tmp/speedtest-result)
}

mqttnopass() {
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/ping/jitter -m $(jq -r '.ping.jitter' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/ping/latency -m $(jq -r '.ping.latency' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/ping/low -m $(jq -r '.ping.low' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/ping/high -m $(jq -r '.ping.high' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/download/bandwidth -m $(echo "scale=2; $(jq -r '.download.bandwidth' /tmp/speedtest-result)/125000" | bc)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/download/latency/iqm -m $(jq -r '.download.latency.iqm' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/download/latency/low -m $(jq -r '.download.latency.low' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/download/latency/high -m $(jq -r '.download.latency.high' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/download/latency/jitter -m $(jq -r '.download.latency.jitter' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/upload/bandwidth -m $(echo "scale=2; $(jq -r '.upload.bandwidth' /tmp/speedtest-result)/125000" | bc)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/upload/latency/iqm -m $(jq -r '.upload.latency.iqm' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/upload/latency/low -m $(jq -r '.upload.latency.low' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/upload/latency/high -m $(jq -r '.upload.latency.high' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/upload/latency/jitter -m $(jq -r '.upload.latency.jitter' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/packetloss -m $(jq -r '.packetLoss' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/isp -m $(jq -r '.isp' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/interface/externalip -m $(jq -r '.interface.externalIp' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/server/id -m $(jq -r '.server.id' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/server/name -m $(jq -r '.server.name' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/server/location -m $(jq -r '.server.location' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/server/country -m $(jq -r '.server.country' /tmp/speedtest-result)
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC/server/ip -m $(jq -r '.server.ip' /tmp/speedtest-result)
}

if [ ! -f /first_start ]; then
	touch /first_start
	touch /tmp/speedtest-result

    if [[ "${SERVER_ID}" ]]; then
		echo "$(date +%D_%T) - Running Ookla speed test using specified server..."
        speedtest --accept-license --accept-gdpr --server-id=$SERVER_ID --format=json-pretty &> /tmp/speedtest-result
    else
		echo "$(date +%D_%T) - Running Ookla speed test..."
        speedtest --accept-license --accept-gdpr --format=json-pretty &> /tmp/speedtest-result
    fi

	sed -i '1,16d' /tmp/speedtest-result

	if [[ "${MQTT_PASS}" ]]; then
		echo "$(date +%D_%T) - Sending Data to ($MQTT_SERVER)..."
		mqttwithpass

	else
		echo "$(date +%D_%T) - Sending Data to ($MQTT_SERVER) with no authentication..."
		mqttnopass
	fi

	echo "$(date +%D_%T) - Cleaning up for the next run..."
	rm /tmp/speedtest-result
	echo "$(date +%D_%T) - First run is complete. License and GDPR have been accepted."
	echo "$(date +%D_%T) - Sleeping for $SLEEP Seconds..."
	sleep $SLEEP
else
	while true
	do
		touch /tmp/speedtest-result

		if [[ "${SERVER_ID}" ]]; then
			echo "$(date +%D_%T) - Running Ookla speed test using specified server..."
			speedtest --server-id=$SERVER_ID --format=json-pretty &> /tmp/speedtest-result
		else
			echo "$(date +%D_%T) - Running Ookla speed test..."
			speedtest --format=json-pretty &> /tmp/speedtest-result
		fi

		if [[ "${MQTT_PASS}" ]]; then
			echo "$(date +%D_%T) - Sending Data to ($MQTT_SERVER)..."
			mqttwithpass
		else
			echo "$(date +%D_%T) - Sending Data to ($MQTT_SERVER) with no authentication..."
			mqttnopass
		fi

		echo "$(date +%D_%T) - Cleaning up for the next run..."
		rm /tmp/speedtest-result
		echo "$(date +%D_%T) - Sleeping for $SLEEP Seconds..."
		sleep $SLEEP
	done
fi