#!/bin/bash

ROOT_DIR=/tmp/scripts
source ${ROOT_DIR}/.env

LOG_FILE=/tmp/01-shart-challenge.log

echo "Sending RADIUS authentication request to ${RADIUS_HOST}..."
echo "Username: ${RADIUS_USER}"
echo

radtest \
  "${RADIUS_USER}" "${RADIUS_PASS}" \
  "${RADIUS_HOST}" 0 "${RADIUS_SECRET}" \
  > ${LOG_FILE} 2> /dev/null

RADIUS_REPLY_MSG=$(awk '/Reply-Message =/ { print }' ${LOG_FILE} | sed -e 's/^.*Reply-Message =//' -e 's/"//g')
RADIUS_STATE=$(awk '/State =/ { print }' ${LOG_FILE} | sed -e 's/^.*State =//')

echo -n "${RADIUS_REPLY_MSG} > "
read RADIUS_OTP

echo "Sending OTP for ${RADIUS_USER}..."
echo

cat <<EOF > /tmp/radattrs
State = ${RADIUS_STATE}
User-Name = ${RADIUS_USER}
User-Password = ${RADIUS_OTP}
EOF

radclient -f /tmp/radattrs ${RADIUS_HOST} auth ${RADIUS_SECRET}