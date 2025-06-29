ARG ROS_DISTRO=jazzy
FROM ros:${ROS_DISTRO}

ENV COLCON_WS=/root/colcon_ws
ENV COLCON_WS_SRC=/root/colcon_ws/src

ENV DEBIAN_FRONTEND noninteractive

# Note that this is not needed with ROS 2 jazzy anymore
ENV PYTHONWARNINGS="ignore:setup.py install is deprecated::setuptools.command.install"

# Note that ros-humble-kobuki-core from humble got removed to jazzy
# install all dependencies
RUN apt-get update \ 
    && apt-get install -y \
        libudev-dev \
        udev \
        python3-bloom \
        python3-rosdep \
        fakeroot \
        debhelper \
        dh-python \
        ros-${ROS_DISTRO}-ament-cmake-ros \
        ros-${ROS_DISTRO}-angles \
        ros-${ROS_DISTRO}-diagnostic-updater \
        ros-${ROS_DISTRO}-ecl-* \
        ros-${ROS_DISTRO}-geometry-msgs \
        ros-${ROS_DISTRO}-joint-state-publisher \
        ros-${ROS_DISTRO}-kobuki-ros-interfaces \
        ros-${ROS_DISTRO}-kobuki-velocity-smoother \
        ros-${ROS_DISTRO}-rclcpp \
        ros-${ROS_DISTRO}-rclcpp-components \
        ros-${ROS_DISTRO}-rcl-interfaces \
        ros-${ROS_DISTRO}-rcpputils \
        ros-${ROS_DISTRO}-ros2test \
        ros-${ROS_DISTRO}-ros-testing \
        ros-${ROS_DISTRO}-std-msgs \
        ros-${ROS_DISTRO}-xacro \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR ${COLCON_WS}

# Clone necessary repositories from source.
RUN git clone -b devel https://github.com/stonier/ecl_lite.git
RUN git clone -b devel https://github.com/stonier/ecl_core.git
RUN git clone -b devel https://github.com/kobuki-base/kobuki_core.git

ENV CXXFLAGS_OVERRIDE="-Wno-error=overloaded-virtual"

COPY ./build_repo.bash /tmp/build_repo.bash
RUN chmod +x /tmp/build_repo.bash

RUN bash -c "/tmp/build_repo.bash ecl_lite"
RUN bash -c "/tmp/build_repo.bash ecl_core"

ENV CXXFLAGS_OVERRIDE="-Wno-error=overloaded-virtual"

RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
    cd kobuki_core && \
    bloom-generate rosdebian --ros-distro ${ROS_DISTRO} && \
    export CXXFLAGS="${CXXFLAGS} ${CXXFLAGS_OVERRIDE}" && \
    DEB_BUILD_OPTIONS="parallel=$(nproc)" fakeroot debian/rules "binary --parallel"

RUN dpkg -i ros-${ROS_DISTRO}-kobuki-core*.deb

COPY ./kobuki.list /etc/ros/rosdep/sources.list.d/99-kobuki.list
COPY ./kobuki.yaml /opt/ros/kobuki.yaml

COPY ./cmd_vel_mux ${COLCON_WS_SRC}/cmd_vel_mux

RUN . /opt/ros/${ROS_DISTRO}/setup.sh\
    && cd ${COLCON_WS_SRC}/cmd_vel_mux \
    && bloom-generate rosdebian \
    && DEB_BUILD_OPTIONS="parallel=$(nproc)" fakeroot debian/rules "binary --parallel"

RUN dpkg -i ${COLCON_WS_SRC}/ros-${ROS_DISTRO}-cmd-vel-mux*.deb

COPY ./kobuki_ros ${COLCON_WS_SRC}/kobuki_ros

RUN . /opt/ros/${ROS_DISTRO}/setup.sh && \
  rosdep update

# RUN . /opt/ros/${ROS_DISTRO}/setup.sh\
#     && rosdep install --from-paths src/kobuki_ros --ignore-src -r -y

RUN . /opt/ros/${ROS_DISTRO}/setup.sh\
    && cd ${COLCON_WS_SRC}/kobuki_ros/kobuki_description \
    && bloom-generate rosdebian \
    && DEB_BUILD_OPTIONS="parallel=$(nproc)" fakeroot debian/rules "binary --parallel"

RUN dpkg -i ${COLCON_WS_SRC}/kobuki_ros/ros-${ROS_DISTRO}-kobuki-description*.deb

RUN . /opt/ros/${ROS_DISTRO}/setup.sh\
    && cd ${COLCON_WS_SRC}/kobuki_ros/kobuki_keyop \
    && bloom-generate rosdebian \
    && DEB_BUILD_OPTIONS="parallel=$(nproc)" fakeroot debian/rules "binary --parallel"

RUN dpkg -i ${COLCON_WS_SRC}/kobuki_ros/ros-${ROS_DISTRO}-kobuki-keyop*.deb

RUN . /opt/ros/${ROS_DISTRO}/setup.sh\
    && cd ${COLCON_WS_SRC}/kobuki_ros/kobuki_node \
    && bloom-generate rosdebian \
    && DEB_BUILD_OPTIONS="parallel=$(nproc)" fakeroot make -f debian/rules "binary --parallel"

RUN dpkg -i ${COLCON_WS_SRC}/kobuki_ros/ros-${ROS_DISTRO}-kobuki-node*.deb

RUN . /opt/ros/${ROS_DISTRO}/setup.sh\
    && cd ${COLCON_WS_SRC}/kobuki_ros/kobuki_auto_docking \
    && bloom-generate rosdebian \
    && DEB_BUILD_OPTIONS="parallel=$(nproc)" fakeroot make -f debian/rules "binary --parallel"

RUN dpkg -i ${COLCON_WS_SRC}/kobuki_ros/ros-${ROS_DISTRO}-kobuki-auto-docking*.deb

RUN . /opt/ros/${ROS_DISTRO}/setup.sh\
    && cd ${COLCON_WS_SRC}/kobuki_ros/kobuki_bumper2pc \
    && bloom-generate rosdebian \
    && DEB_BUILD_OPTIONS="parallel=$(nproc)" fakeroot make -f debian/rules "binary --parallel"

RUN dpkg -i ${COLCON_WS_SRC}/kobuki_ros/ros-${ROS_DISTRO}-kobuki-bumper2pc*.deb

RUN . /opt/ros/${ROS_DISTRO}/setup.sh\
    && cd ${COLCON_WS_SRC}/kobuki_ros/kobuki_random_walker \
    && bloom-generate rosdebian \
    && DEB_BUILD_OPTIONS="parallel=$(nproc)" fakeroot make -f debian/rules "binary --parallel"

RUN dpkg -i ${COLCON_WS_SRC}/kobuki_ros/ros-${ROS_DISTRO}-kobuki-random-walker*.deb

RUN . /opt/ros/${ROS_DISTRO}/setup.sh\
    && cd ${COLCON_WS_SRC}/kobuki_ros/kobuki_safety_controller \
    && bloom-generate rosdebian \
    && DEB_BUILD_OPTIONS="parallel=$(nproc)" fakeroot make -f debian/rules "binary --parallel"

RUN dpkg -i ${COLCON_WS_SRC}/kobuki_ros/ros-${ROS_DISTRO}-kobuki-safety-controller*.deb

RUN . /opt/ros/${ROS_DISTRO}/setup.sh\
    && cd ${COLCON_WS_SRC}/kobuki_ros/kobuki_ros \
    && bloom-generate rosdebian \
    && DEB_BUILD_OPTIONS="parallel=$(nproc)" fakeroot make -f debian/rules "binary --parallel"

RUN dpkg -i ${COLCON_WS_SRC}/kobuki_ros/ros-${ROS_DISTRO}-kobuki-ros*.deb

RUN mkdir /deb && \
    find ${COLCON_WS} -name "*.deb" -exec mv {} /deb/ \;