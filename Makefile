build_image:
	docker build -t nyrio_one .

create_container:
	docker run -d \
	--name nyrio_one
	--gpus all \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	nyrio_docker:latest && \
	containerId=$(docker ps -l -q) && \
	xhost +local:$(docker inspect --format='{{ .Config.Hostname }}' '${containerId}')

start_container:
	docker start nyrio_one

stop_container:
	docker stop nyrio_one