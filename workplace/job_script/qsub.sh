#!/bin/bash
#@(#) This script is to easily execute qsub

_usage() {
  echo "Usage:"
  echo "  ${0} -o STDOUT_FILE -s EXEC_SCRIPT"
  #exit 1
}

while getopts o:e: OPT;
do
  case ${OPT} in
    o) CHECK_o=true
       STDOUT=${OPTARG}
       ;;
    e) CHECK_e=true
       EXE=${OPTARG}
       ;;
    :|\?) FAIL_OTHER=true  # Missing required argument | Invalid option
          _usage
          ;;
  esac
done
shift `expr ${OPTIND} - 1`

[[ ${CHECK_o}${CHECK_e} != truetrue && $FAIL_OTHER != true ]] && _usage  # Missing required option
while [ -z $STDOUT ]
do
  read "STDOUT?  Input std out file path (-o): "
done
while [ -z $EXE ]
do
  read "EXE?  Input execution file (-e): "
done


CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
JOB_SCRIPT=~/fairseq/workplace/job_script/job.sh
echo "qsub -o "$STDOUT" "$JOB_SCRIPT" "$EXE
#qsub -o $STDOUT $JOB_SCRIPT $EXE

