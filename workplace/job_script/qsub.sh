#!/bin/zsh
#@(#) This script is to easily execute qsub

_usage() {
  echo "Usage:"
  echo "  source $1 -o STDOUT_FILE -e EXEC_SCRIPT -c CONFIG_FILE\n"
  #exit 1
}
echo $0
echo $1

CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`

while getopts o:e:c: OPT;
do
  case ${OPT} in
    o) CHECK_o=true
       STDOUT=${OPTARG}
       echo $STDOUT
       ;;
    e) CHECK_e=true
       EXE=${OPTARG}
       ;;
    c) CHECK_c=true
       CONFIG=${OPTARG}
       ;;
    :|\?) FAIL_OTHER=true  # Missing required argument | Invalid option
          _usage $0
          ;;
  esac
done
shift `expr ${OPTIND} - 1`

[[ ${CHECK_o}${CHECK_e}${CHECK_c} != truetrue && $FAIL_OTHER != true ]] && _usage $0  # Missing required option
while [ -z $STDOUT ]
do
  tree -L 2 "$SCRIPT_DIR/std"
  read "STDOUT?Input std out file path (-o): "
  echo ""
done
while [ ! -f "$SCRIPT_DIR/../script/$EXE" ]
do
  ls "$SCRIPT_DIR/../script" | grep -E ".+\.sh" --colour=never
  read "EXE?Input execution file (-e): "
  echo ""
done
while [ ! -f "$SCRIPT_DIR/../script/configs/$CONFIG" ]
do
  ls "$SCRIPT_DIR/../script/configs" | grep -E ".+\.conf" --colour=never
  read "CONFIG?Input config file (-c): "
  echo ""
done

cd $SCRIPT_DIR
JOB_SCRIPT=~/fairseq/workplace/job_script/job.sh
echo "qsub -o std/$STDOUT $JOB_SCRIPT $EXE $CONFIG"
qsub -o std/$STDOUT $JOB_SCRIPT $EXE $CONFIG

cd $CURRENT_DIR
STDOUT=
EXE=
CONFIG=
