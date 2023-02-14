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
make radtest_shell
```

Inside the testing shell, run this command.

```
# radtest 'INSERT_EMAIL' 'INSERT_PASSWORD' host.docker.internal 0 mysecret
radtest 'myuser@example.com' 'Password1!' host.docker.internal 0 mysecret
```