#!/bin/bash -x
source scripts/common.sh
#RUN_DIR=$(dirname $0)
#OLD_VERSION=$(cat ${RUN_DIR}/VERSION)
#INCREMENT=$(git rev-parse --abbrev-ref HEAD | awk -F "/" '{ print $1}')
#SEMVER="/usr/bin/semver"
#COMMIT_MESSAGE=$(git log -1 --pretty=%B)
if [ "${INCREMENT}" == "major" ]; then
	NEW_VERSION=$(${SEMVER} -i ${INCREMENT} ${OLD_VERSION})
elif [ "${INCREMENT}" == "minor" ]; then
	NEW_VERSION=$(${SEMVER} -i ${INCREMENT} ${OLD_VERSION})
else
	NEW_VERSION=$(${SEMVER} -i ${OLD_VERSION})
	INCREMENT="default"
fi
echo -e "Version: ${OLD_VERSION} will undergo ${INCREMENT} increment to ${NEW_VERSION}"
echo ${NEW_VERSION} > ${RUN_DIR}/VERSION
git add ${RUN_DIR}/VERSION
git tag -a ${NEW_VERSION}  -m "${COMMIT_MESSAGE}"
