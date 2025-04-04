#!/bin/bash

for i in {1..5}; do
  JSON=$(mullvad status --json)

  STATE=$(echo "$JSON" | jq -r '.state')

  if [[ "$STATE" == "connected" ]]; then
    COUNTRY=$(echo "$JSON" | jq -r '.details.location.country')
    CITY=$(echo "$JSON" | jq -r '.details.location.city')
    ADDRESS=$(echo "$JSON" | jq -r '.details.endpoint.address')
    TUNNEL=$(echo "$JSON" | jq -r '.details.endpoint.tunnel_interface')

    notify-send "${TUNNEL}" "connected to ${CITY}, ${COUNTRY}.\n${ADDRESS}"
    exit 0
  fi

  sleep 1
done

notify-send "mullvad" "mullvad not connected ⚠️"
exit 1

