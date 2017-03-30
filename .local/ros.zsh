# ROS related setup
# ros.org
[[ -s "/opt/ros/kinetic/setup.zsh" ]] && source "/opt/ros/kinetic/setup.zsh" || echo "LOCAL: ROS is not installed"

if [ -e /opt/ros/kinetic/setup.zsh ]; then
  export ROS_WORKSPACE=~/ros_workspace
  export ROS_PACKAGE_PATH=$ROS_WORKSPACE:$ROS_PACKAGE_PATH
fi
