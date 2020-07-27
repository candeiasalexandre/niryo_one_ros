build_image:
	docker build -t niryo_one .

create_container:
	docker run -d \
	--name niryo_one \
	--gpus all \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	niryo_one:latest && \
	containerId=$(docker ps -l -q) && \
	xhost +local:$(docker inspect --format='{{ .Config.Hostname }}' '${containerId}')

delete_container: stop_container
	docker container rm niryo_one

start_container:
	docker start niryo_one

stop_container:
	docker stop niryo_one

attach_bash:
	docker exec -it niryo_one /bin/bash

copy_compile:
	docker cp . niryo_one:/home/niryo_one/src
	docker exec niryo_one /bin/bash -c "catkin_make"