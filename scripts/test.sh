ORIGINAL_DIR=$(pwd)
ROOT_PROJECT_DIR=$(git rev-parse --show-toplevel)
OUTPUT_FILE=/tmp/output
date> ${OUTPUT_FILE}

cd $ROOT_PROJECT_DIR
source scripts/common.sh

echo -e ${YELLOW}Running tests from  ${RUN_DIR}${NO_COLOUR}

python_install () {
  CURRENT_TEST=python_install
  echo -e ${YELLOW} Starting Python Install ${NO_COLOUR}
  pip install .[dev]
}

python_test () {
  CURRENT_TEST=Python
  echo -e ${YELLOW} Starting Python Test ${NO_COLOUR}
  pytest
}

linting_test () {
  CURRENT_TEST=Linting
  echo -e ${YELLOW} Starting Linting Test ${NO_COLOUR}
  autopep8 --recursive --in-place --aggressive --aggressive .
  pylint $(git ls-files '*.py')
}

build_test () {
  CURRENT_TEST=Build
  echo -e ${YELLOW} Starting Build Test ${NO_COLOUR} in $(pwd)
  ${RUN_DIR}/build.sh
}

run_test () {
  CURRENT_TEST=Run
  echo -e ${YELLOW} Starting Run Test ${NO_COLOUR}
  ${RUN_DIR}/run.sh | tee $OUTPUT_FILE 
  echo -e ${YELLOW} Finished Run Test ${NO_COLOUR}
}

all_tests_pass () {
  FAILED=$(grep fail ${OUTPUT_FILE}) 
  if [ -z ${FAILED} ]; then
  	echo -e ${GREEN} All tests passed ${NO_COLOUR}
  	${RUN_DIR}/increment.sh && ${RUN_DIR}/build.sh && ${RUN_DIR}/install.sh
  	exit 0
  else
  	exit 1
  fi
}

test_failed () {
  echo -e ${RED} ${CURRENT_TEST} test failed ${NO_COLOUR}
  cat ${OUTPUT_FILE}
  exit 1
}

python_install && python_test && linting_test && build_test && run_test && all_tests_pass || test_failed
