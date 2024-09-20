IMAGE_NAME="roboboat"
IMAGE_TAG="devel"
DOCKERFILE_DIR="$HOME/roboboat/Docker"
docker build ${DOCKERFILE_DIR} -t "${IMAGE_NAME}:${IMAGE_TAG}" -f "${DOCKERFILE_DIR}/Dockerfile"
