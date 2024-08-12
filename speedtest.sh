#!/bin/bash

#functions and variables
mqttwithpass() {
	mosquitto_pub -u $MQTT_USER -P $MQTT_PASS -h $MQTT_SERVER -t $MQTT_TOPIC -f $RESULTS
}

mqttnopass() {
	mosquitto_pub -h $MQTT_SERVER -t $MQTT_TOPIC -f $RESULTS
}

convertmbps() {
	jq ".download.bandwidth = "$(echo "scale=2; $(jq -r '.download.bandwidth' $RESULTS)/125000" | bc)"" $RESULTS | sponge $RESULTS
	jq ".upload.bandwidth = "$(echo "scale=2; $(jq -r '.upload.bandwidth' $RESULTS)/125000" | bc)"" $RESULTS | sponge $RESULTS
}

RESULTS_FORMAT="json-pretty"
RESULTS_PATH="/tmp/speedtest-results"
FIRST_START_PATH="/first_start"
LOG_DATE_FORMAT="$(date +%D_%T)"

#check if container has been started before
if [ ! -f $FIRST_START_PATH ]; then
	touch $FIRST_START_PATH
	touch $RESULTS

    if [[ "${SERVER_ID}" ]]; then
		echo "$LOG_DATE_FORMAT - Running Ookla speed test using specified server..."
        speedtest --accept-license --accept-gdpr --server-id=$SERVER_ID --format=$RESULTS_FORMAT &> $RESULTS
    else
		echo "$LOG_DATE_FORMAT - Running Ookla speed test..."
        speedtest --accept-license --accept-gdpr --format=$RESULTS_FORMAT &> $RESULTS
    fi

	#since this is the first run, the license acceptance info shows up at the beginning of our output
	sed -i '1,16d' $RESULTS

	#the default value from the speedtest is in bytes, here we convert that to Mbps
	convertmbps

	if [[ "${MQTT_PASS}" ]]; then
		echo "$LOG_DATE_FORMAT - Sending JSON data to ($MQTT_SERVER)..."
		mqttwithpass

	else
		echo "$LOG_DATE_FORMAT - Sending JSON data to ($MQTT_SERVER) with no authentication..."
		mqttnopass
	fi

	echo "$LOG_DATE_FORMAT - Cleaning up for the next run..."
	rm $RESULTS
	echo "$LOG_DATE_FORMAT - First run is complete. License and GDPR have been accepted."
	echo "$LOG_DATE_FORMAT - Sleeping for $SLEEP Seconds..."
	sleep $SLEEP
else
	#if container has been started before, stdout is fine, no license acceptance
	while true
	do
		touch $RESULTS

		if [[ "${SERVER_ID}" ]]; then
			echo "$LOG_DATE_FORMAT - Running Ookla speed test using specified server..."
			speedtest --server-id=$SERVER_ID --format=$RESULTS_FORMAT &> $RESULTS
		else
			echo "$LOG_DATE_FORMAT - Running Ookla speed test..."
			speedtest --format=$RESULTS_FORMAT &> $RESULTS
		fi

		#the default value from the speedtest is in bytes, here we convert that to Mbps
		convertmbps

		if [[ "${MQTT_PASS}" ]]; then
			echo "$LOG_DATE_FORMAT - Sending JSON data to ($MQTT_SERVER)..."
			mqttwithpass
		else
			echo "$LOG_DATE_FORMAT - Sending JSON data to ($MQTT_SERVER) with no authentication..."
			mqttnopass
		fi

		echo "$LOG_DATE_FORMAT - Cleaning up for the next run..."
		rm $RESULTS
		echo "$LOG_DATE_FORMAT - Sleeping for $SLEEP Seconds..."
		sleep $SLEEP
	done
fi