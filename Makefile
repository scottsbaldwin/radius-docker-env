pull:
	docker pull freeradius/freeradius-server

build:
	docker build -t my-radius-image -f Dockerfile .

# run:
# 	docker run -it --rm --name radius freeradius/freeradius-server

run:
	docker run --rm --name my-radius -t -p 1812-1813:1812-1813/udp my-radius-image -X

radtest_shell:
	docker run --rm --name radtest -it my-radius-image /bin/bash

radtest:
	docker run --rm --name radtest -it my-radius-image radtest bob test host.docker.internal 0 testing123

stop:
	docker stop my-radius

test:
	radtest bob test 127.0.0.1 0 testing123