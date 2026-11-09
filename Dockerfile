# syntax=docker/dockerfile:1
# Base on the local native Apple Silicon (arm64) ROS 2 Humble image
FROM ros:humble-ros-base

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential build tools, ROS 2 message libraries, and Python dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Build tools for ROS 2
    python3-colcon-common-extensions \
    python3-pip \
    # Additional ROS 2 message and transform packages
    ros-humble-sensor-msgs \
    ros-humble-geometry-msgs \
    ros-humble-trajectory-msgs \
    # Math & scientific libraries for Kinematics & Trajectory planning
    python3-numpy \
    python3-scipy \
    # Lightweight async web server & websocket support for browser visualization
    python3-aiohttp \
    # Shell utilities & debugging tools
    curl \
    git \
    bash-completion \
    && rm -rf /var/lib/apt/lists/*

# Automatically source ROS 2 and workspace overlays in interactive shells
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc && \
    echo "if [ -f /ros2_ws/install/setup.bash ]; then source /ros2_ws/install/setup.bash; fi" >> /root/.bashrc

# Set working directory to the ROS 2 workspace
WORKDIR /ros2_ws

# Expose port 8080 for the Three.js 3D web visualizer and WebSocket bridge
EXPOSE 8080

# Keep the official ROS entrypoint which sources /opt/ros/humble/setup.bash
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
