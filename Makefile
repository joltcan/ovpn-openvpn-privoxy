
CONTAINER  := ovpn-openvpn-proxy
IMAGE_NAME := ovpn-openvpn-proxy
HUB_USER := jolt
DATA_DIR   := /tmp/docker-data/ovpn-openvpn-proxy

build:
	docker \
		build \
		--rm --tag=$(IMAGE_NAME) .
	@echo Image tag: ${IMAGE_NAME}

start: run

run:
	docker \
		run \
		--detach \
		--interactive \
		--tty \
		--hostname=${CONTAINER} \
		--name=${CONTAINER} \
		--dns=208.67.222.222 --dns=208.67.220.220 \
		--cap-add=NET_ADMIN \
		--device=/dev/net/tun \
		-e "REGION=se-malmo" \
		-e "USERNAME=${OVPN_USERNAME}" \
		-e "PASSWORD=${OVPN_PASSWORD}" \
		-v /etc/localtime:/etc/localtime:ro \
		-p 8118:8118 \
		$(IMAGE_NAME)

shell:
	docker \
		run \
		--rm \
		--interactive \
		--tty \
		--hostname=${CONTAINER} \
		--name=${CONTAINER} \
		--dns=208.67.222.222 --dns=208.67.220.220 \
		-e "REGION=se" \
		-e "USERNAME=${OVPN_USERNAME}" \
		-e "PASSWORD=${OVPN_PASSWORD}" \
		-v /etc/localtime:/etc/localtime:ro \
		-p 8118:8118 \
		$(IMAGE_NAME) \
		/bin/ash

exec:
	docker exec \
		--interactive \
		--tty \
		${CONTAINER} \
		/bin/ash

stop:
	docker \
		kill ${CONTAINER}

history:
	docker \
		history ${IMAGE_NAME}

clean:
	docker \
		rm ${CONTAINER}
push:
	docker tag ${IMAGE_NAME} ${HUB_USER}/${IMAGE_NAME} && docker push ${HUB_USER}/${IMAGE_NAME}

restart: stop clean run
