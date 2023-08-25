#!/bin/bash

ROOT_DIR=/tmp/scripts
source ${ROOT_DIR}/.env

LOG_FILE=/tmp/01-start-simple-otp.log

echo "Sending RADIUS authentication request to ${RADIUS_HOST}..."
echo "Username: ${RADIUS_USER}"

echo -n "Enter your OTP > "
read RADIUS_OTP

echo "Check for a push notification to your registered device..."
echo

radtest \
  "${RADIUS_USER}" "${RADIUS_PASS},${RADIUS_OTP}" \
  "${RADIUS_HOST}" 0 "${RADIUS_SECRET}" \

exit 0

# Alternative authentication using radclient

cat <<EOF > /tmp/radattrs
User-Name = ${RADIUS_USER}
User-Password = "${RADIUS_PASS},${RADIUS_OTP}"
EOF

radclient -f /tmp/radattrs ${RADIUS_HOST} auth ${RADIUS_SECRET}

exit 0
