FROM ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN sed -r -i 's,http://(.*).ubuntu.com,http://mirror.us-tx.kamatera.com,' /etc/apt/sources.list

RUN apt-get update && apt-get -y upgrade && apt-get -y install \
    libxext-dev \
    libx11-dev \
    libglvnd-dev \
    libglx-dev \
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    freeglut3-dev \
    mesa-utils \
    mesa-utils-extra \
    && apt-get -y autoremove \
    && apt-get clean

RUN apt-get update && apt-get -y upgrade && apt-get -y install \
    git \
    curl \
    wget \
    build-essential \
    cmake \
    lsb-release \
    gnupg \
    gnupg2 \
    locales \
    net-tools \
    iputils-ping \
    netcat \
    software-properties-common \
    python3-dev \
    python3-pip \
    python-is-python3 && \
    add-apt-repository universe \
    && apt-get -y autoremove \
    && apt-get clean

RUN locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt-get update && apt-get -y upgrade && apt-get -y install \
    ros-humble-desktop \
    ros-dev-tools \
    ros-humble-velodyne \
    ros-humble-velodyne-simulator \
    python3-rosdep \
    && apt-get -y autoremove \
    && apt-get clean

RUN wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null && \
    apt-get update && apt-get -y upgrade && apt-get -y install \
    gz-garden \
    python3-sdformat13 \
    ros-humble-ros-gzgarden \
    ros-humble-xacro \
    && apt-get -y autoremove \
    && apt-get clean


ENV ROS_DISTRO humble
ENV TURTLEBOT3_MODEL burger

ENV QT_X11_NO_MITSHM 1
ENV QT_DEBUG_PLUGINS=1
ENV TERM xterm-256color

ENV HOME /root
ENV BOAT_WS /root/roboboat_ws
ENV BOAT_SRC /root/roboboat_ws/src

RUN mkdir -p ${BOAT_SRC} && \
    git clone --progress --verbose https://github.com/osrf/vrx.git ${BOAT_SRC}/vrx

RUN source /opt/ros/${ROS_DISTRO}/setup.bash && \
    cd ${BOAT_WS} && \
    rosdep init && \
    rosdep update && \
    rosdep install --from-paths src -y --ignore-src && \
    colcon build --merge-install

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ${HOME}/.bashrc && \
    echo "source ${BOAT_WS}/install/setup.bash" >> ${HOME}/.bashrc && \
    echo "cd ${BOAT_WS}" >> ${HOME}/.bashrc