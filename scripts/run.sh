RUN_DIR=$(dirname $0)
DOCKER_FLAGS=$(cat ${RUN_DIR}/DOCKER_FLAGS)
NAME=$(cat ${RUN_DIR}/NAME)
DOCKER_REPO=$(cat ${RUN_DIR}/DOCKER_REPO)
VERSION=$(cat ${RUN_DIR}/VERSION)
OUT=/tmp/output
CONTAINER=$(docker run ${DOCKER_FLAGS} ${DOCKER_REPO}/${NAME}:${VERSION}|| echo "fail to start container\n" >>${OUTPUT})
sleep 5
curl --fail -i -H "Content-Type: application/json" --data '{"user":"alex","message":"Hi everyone! Alex here"}' localhost:5000/message || echo "fail to send message\n" >>${OUTPUT}
docker stop $CONTAINER
