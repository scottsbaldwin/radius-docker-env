radius:
	docker run --rm --platform linux/amd64 --name my-radius \
		-v $(PWD)/raddb/clients.conf:/etc/raddb/clients.conf \
		-v $(PWD)/raddb/mods-config/files/authorize:/etc/raddb/mods-config/files/authorize \
		-v $(PWD)/raddb/mods-enabled/rest:/etc/raddb/mods-enabled/rest \
		-v $(PWD)/raddb/sites-available/default:/etc/raddb/sites-available/default \
		-t -p 1812-1813:1812-1813/udp freeradius/freeradius-server -X

radtest_shell:
	docker run --rm --platform linux/amd64 --name radtest -it freeradius/freeradius-server /bin/bash

radtest:
	docker run --rm --platform linux/amd64 --name radtest -it freeradius/freeradius-server radtest bob test host.docker.internal 0 mysecret

radtest_evo:
	docker run --rm --platform linux/amd64 --name radtest -it freeradius/freeradius-server radtest 'myuser@example.com' 'Password1!' host.docker.internal 0 mysecret

stop:
	docker stop my-radius