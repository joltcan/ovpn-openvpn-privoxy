
CONTAINER	:= ovpn-openvpn-proxy
IMAGE_NAME	:= ${CONTAINER}
HUB_USER	:= ${USER}
DATA_DIR	:= /tmp/docker-data/${CONTAINER}
DNS			:= 1.1.1.1
REGION		:= us

# OVPN_USERNAME and OVPN_PASSWORD are taken from your SHELL if set, otherwise 
# declare them  here.

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
		--dns=${DNS} \
		--cap-add=NET_ADMIN \
		--device=/dev/net/tun \
		-e "REGION=${REGION}" \
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
		--dns=${DNS} \
		-e "REGION=${REGION}" \
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
