#!/bin/bash

#functions
mqttwithpass() {
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC -f /tmp/speedtest-result
}

mqttnopass() {
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC -f /tmp/speedtest-result
}

convertmbps() {
	jq ".download.bandwidth = "$(echo "scale=2; $(jq -r '.download.bandwidth' /tmp/speedtest-results)/125000" | bc)"" /tmp/speedtest-results | sponge /tmp/speedtest-results
	jq ".upload.bandwidth = "$(echo "scale=2; $(jq -r '.upload.bandwidth' /tmp/speedtest-results)/125000" | bc)"" /tmp/speedtest-results | sponge /tmp/speedtest-results
}

#check if container has been started before
if [ ! -f /first_start ]; then
	touch /first_start
	touch /tmp/speedtest-result

    if [[ "${SERVER_ID}" ]]; then
		echo "$(date +%D_%T) - Running Ookla speed test using specified server..."
        speedtest --accept-license --accept-gdpr --server-id=$SERVER_ID --format=json-pretty &> /tmp/speedtest-results
    else
		echo "$(date +%D_%T) - Running Ookla speed test..."
        speedtest --accept-license --accept-gdpr --format=json-pretty &> /tmp/speedtest-results
    fi

	#since this is the first run, the license acceptance info shows up at the beginning of our output
	sed -i '1,16d' /tmp/speedtest-result

	#the default value from the speedtest is in bytes, here we convert that to Mbps
	convertmbps

	if [[ "${MQTT_PASS}" ]]; then
		echo "$(date +%D_%T) - Sending JSON data to ($MQTT_SERVER)..."
		mqttwithpass

	else
		echo "$(date +%D_%T) - Sending JSON data to ($MQTT_SERVER) with no authentication..."
		mqttnopass
	fi

	echo "$(date +%D_%T) - Cleaning up for the next run..."
	rm /tmp/speedtest-results
	echo "$(date +%D_%T) - First run is complete. License and GDPR have been accepted."
	echo "$(date +%D_%T) - Sleeping for $SLEEP Seconds..."
	sleep $SLEEP
else
	#if container has been started before, stdout is fine, no license acceptance
	while true
	do
		touch /tmp/speedtest-result

		if [[ "${SERVER_ID}" ]]; then
			echo "$(date +%D_%T) - Running Ookla speed test using specified server..."
			speedtest --server-id=$SERVER_ID --format=json-pretty &> /tmp/speedtest-results
		else
			echo "$(date +%D_%T) - Running Ookla speed test..."
			speedtest --format=json-pretty &> /tmp/speedtest-results
		fi

		#the default value from the speedtest is in bytes, here we convert that to Mbps
		convertmbps

		if [[ "${MQTT_PASS}" ]]; then
			echo "$(date +%D_%T) - Sending JSON data to ($MQTT_SERVER)..."
			mqttwithpass
		else
			echo "$(date +%D_%T) - Sending JSON data to ($MQTT_SERVER) with no authentication..."
			mqttnopass
		fi

		echo "$(date +%D_%T) - Cleaning up for the next run..."
		rm /tmp/speedtest-results
		echo "$(date +%D_%T) - Sleeping for $SLEEP Seconds..."
		sleep $SLEEP
	done
fi