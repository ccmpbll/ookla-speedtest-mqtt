#!/bin/bash

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
		mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC -f /tmp/speedtest-result
	else
		echo "$(date +%D_%T) - Sending Data to ($MQTT_SERVER) with no authentication..."
		mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC -f /tmp/speedtest-result
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
			mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC -f /tmp/speedtest-result
		else
			echo "$(date +%D_%T) - Sending Data to ($MQTT_SERVER) with no authentication..."
			mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC -f /tmp/speedtest-result
		fi

		echo "$(date +%D_%T) - Cleaning up for the next run..."
		rm /tmp/speedtest-result
		echo "$(date +%D_%T) - Sleeping for $SLEEP Seconds..."
		sleep $SLEEP
	done
fi