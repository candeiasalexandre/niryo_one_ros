FROM osrf/ros:kinetic-desktop-xenial

# nvidia-docker2 support to fix opengl errors 
# from https://github.com/filiperinaldi/Autoware/blob/c00719981da1ca62395d13c8f8158081be9b2382/docker/generic/Dockerfile.cuda
RUN apt-get update && apt-get install -y --no-install-recommends \
        pkg-config \
        libxau-dev \
        libxdmcp-dev \
        libxcb1-dev \
        libxext-dev \
        libx11-dev && \
    rm -rf /var/lib/apt/lists/*
COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04 \
  /usr/local/lib/x86_64-linux-gnu \
  /usr/lib/x86_64-linux-gnu
COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04 \
  /usr/local/share/glvnd/egl_vendor.d/10_nvidia.json \
  /usr/local/share/glvnd/egl_vendor.d/10_nvidia.json
RUN echo '/usr/local/lib/x86_64-linux-gnu' >> /etc/ld.so.conf.d/glvnd.conf && \
    ldconfig
RUN apt-get update

ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-kinetic-desktop-full=1.3.2-0*

RUN apt-get install -y \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential \
    ros-kinetic-catkin \
    python-catkin-tools

RUN rosdep update

# Niryo dependencies
RUN apt-get install -y --no-install-recommends \
    ros-kinetic-robot-state-publisher \
    ros-kinetic-moveit \
    ros-kinetic-rosbridge-suite \
    ros-kinetic-joy \
    ros-kinetic-ros-control \
    ros-kinetic-ros-controllers \
    ros-kinetic-tf2-web-republisher

RUN apt-get install -y \
    python-pip

RUN pip install --upgrade pip \
    && pip install jsonpickle

# copy files and compile code
ADD . /home/niryo/src
ENV BASH_ENV /opt/ros/kinetic/setup.bash
SHELL ["/bin/bash", "-c"]
WORKDIR /home/niryo
RUN "catkin_make"

#define entry point
RUN chmod +x /home/niryo/src/docker/ros_entrypoint.sh
ENTRYPOINT [ "/home/niryo/src/docker/ros_entrypoint.sh" ]