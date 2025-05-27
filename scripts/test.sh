ORIGINAL_DIR=$(pwd)
ROOT_PROJECT_DIR=$(git rev-parse --show-toplevel)
OUTPUT_FILE=/tmp/output

cd $ROOT_PROJECT_DIR
source $(git rev-parse --show-toplevel)/scripts/common.sh

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
  ${RUN_DIR}/run.sh &> $OUTPUT_FILE 
  (grep  fail ${OUTPUT_FILE} || echo -e ${GREEN}Success${NO_COLOUR=} ) && (grep fail ${OUTPUT_FILE} && exit 1)
}

all_tests_pass () {
  echo -e ${GREEN} All tests passed ${NO_COLOUR}
  cd $ORIGINAL_DIR
  ${RUN_DIR}/increment.sh && ${RUN_DIR}/build.sh
  exit 0
}

test_failed () {
  echo -e ${RED} ${CURRENT_TEST} test failed ${NO_COLOUR}
  cd $ORIGINAL_DIR
  exit 1
}

python_install && python_test && linting_test && build_test || run_test  && all_tests_pass || test_failed
