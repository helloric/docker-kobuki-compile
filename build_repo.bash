#!/bin/bash
set -e

CXXFLAGS_OVERRIDE="-Wno-error=overloaded-virtual"

REPO_NAME="$1"

source "/opt/ros/${ROS_DISTRO}/setup.bash"

BUILD_ORDER=$(cd "$REPO_NAME" && colcon list --names-only --topological-order)

echo "--- Processing repository '$REPO_NAME'. Determined Build Order: $BUILD_ORDER ---"

for pkg in $BUILD_ORDER; do
  DEB_PKG_NAME_HYPHENS=$(echo "$pkg" | sed 's/_/-/g')
  DEB_PKG_FULL_NAME="ros-${ROS_DISTRO}-${DEB_PKG_NAME_HYPHENS}"
  
  echo "--- Checking for official package: $DEB_PKG_FULL_NAME ---"
  
  # Use apt-cache to check if the package is available from apt repos
  if apt-cache show "$DEB_PKG_FULL_NAME" > /dev/null 2>&1; then
    echo "--> Official package '$DEB_PKG_FULL_NAME' found. SKIPPING source build."

  else
    echo "--> Official package not found. BUILDING '$pkg' from source."
    (
      cd "${REPO_NAME}/${pkg}" && \
      bloom-generate rosdebian --ros-distro "$ROS_DISTRO" --quiet && \
      export CXXFLAGS="${CXXFLAGS} ${CXXFLAGS_OVERRIDE}" && \
      DEB_BUILD_OPTIONS="parallel=$(nproc)" fakeroot debian/rules "binary --parallel"
    ) || exit 1 # Exit script if build fails
    
    echo "--- Installing locally built deb for '$pkg' ---"
    dpkg -i "${REPO_NAME}/ros-${ROS_DISTRO}-${DEB_PKG_NAME_HYPHENS}"*.deb
  fi
done
echo "--- Finished processing repository '$REPO_NAME' ---"
