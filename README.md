# Docker Helper for Local FreeRADIUS

## Configuration

Edit the `mods-enabled/rest` file. And make the following changes.

Replace `INSERT_API_HOST` with the backend API that can handle RADIUS requests.

```
connect_uri = "https://INSERT_API_HOST/api/v1/radius"
```

Replace `INSERT_ENVIRONMENT_URL` and `INSERT_DIRECTORY_NAME` in the following line:

```
data = '{ "user": "%{User-Name}", "password": "%{User-Password}", "environment_url": "INSERT_ENVIRONMENT_URL", "domain": "INSERT_DIRECTORY_NAME", "ip_address": "%{Packet-Src-IP-Address}" }'
```

## Running

Start the server in a terminal with:

```
make radius
```

In another terminal, launch a container to issue tests from:

```
make client_shell
```

Create a `.env` file in the `scripts` directory that has variables for

```
# The host of the RADIUS server running in Docker
RADIUS_HOST=host.docker.internal

# The secret defined in clients.conf
RADIUS_SECRET=mysecret

# The username (or alias) to login as with the RADIUS server
RADIUS_USER=

# The password for the username above
RADIUS_PASS=
```

Inside the testing shell, run one of the following scripts from the `scripts` directory:

- `simple-auth-push-notification.sh` - issues an authentication request with the assumption that the API will do a push notification
- `simple-auth-otp.sh` - issues an authentication request with the assumption that the API will accept the provided OTP

```
/tmp/scripts/simple-auth-push-notification.sh

# or

/tmp/scripts/simple-auth-otp.sh
```

## Testing a Remote RADIUS Server

Create a `.env` file in the `scripts` directory that has variables for

```
# The IP address of the RADIUS server
RADIUS_HOST=

# The secret used to authenticate with the RADIUS server
RADIUS_SECRET=

# The username (or alias) to login as with the RADIUS server
RADIUS_USER=

# The password for the username above
RADIUS_PASS=
```

Launch a container to issue and attach to a shell:

```
make client_shell
```

Change into the scripts directory, and use one of the scripts to interact with the remote RADIUS server.

```
/tmp/scripts/challenge-based-auth.sh
```

For example, the output below shows a failed attempt (`Expected Access-Accept got Access-Reject`).

```
root@186824fc7752:/# /tmp/scripts/challenge-based-auth.sh
Sending RADIUS authentication request to 1.2.3.4...
Username: foo@example.com

 Please enter OTP > 123456
Sending OTP for foo@example.com...

Sent Access-Request Id 189 from 0.0.0.0:59697 to 1.2.3.4:1812 length 73
Received Access-Reject Id 189 from 1.2.3.4:1812 to 172.17.0.2:59697 length 20
(0) /tmp/radattrs: Expected Access-Accept got Access-Reject
```

Here is an example of a successful attempt.

```
root@186824fc7752:/# /tmp/scripts/challenge-based-auth.sh
Sending RADIUS authentication request to 1.2.3.4...
Username: my.user@mydomain.com

 Please enter OTP > 643679
Sending OTP for my.user@mydomain.com...

Sent Access-Request Id 183 from 0.0.0.0:49546 to 1.2.3.4:1812 length 87
Received Access-Accept Id 183 from 1.2.3.4:1812 to 172.17.0.2:49546 length 56
```