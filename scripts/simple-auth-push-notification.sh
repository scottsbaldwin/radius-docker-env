#!/bin/bash

ROOT_DIR=/tmp/scripts
source ${ROOT_DIR}/.env

LOG_FILE=/tmp/01-start-simple-push.log

echo "Sending RADIUS authentication request to ${RADIUS_HOST}..."
echo "Username: ${RADIUS_USER}"
echo "Check for a push notification to your registered device..."
echo

radtest \
  "${RADIUS_USER}" "${RADIUS_PASS}" \
  "${RADIUS_HOST}" 0 "${RADIUS_SECRET}" \

exit 0


# Alternative authentication using radclient

cat <<EOF > /tmp/radattrs
User-Name = ${RADIUS_USER}
User-Password = ${RADIUS_PASS}
EOF

radclient -f /tmp/radattrs ${RADIUS_HOST} auth ${RADIUS_SECRET}

exit 0
