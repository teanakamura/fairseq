#!/bin/bash

SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
pwd

#$ -l rt_F=1
#$ -l h_rt=72:00:00
#$ -j y
#$ -cwd
#$ -o std/std0/out
##$ -e std/std0/err

## load jobrc
source ~/fairseq/workplace/job_script/jobrc

## Initialize module
source ~/fairseq/workplace/job_script/module_load.sh

~/fairseq/workplace/script/$1 $2 $3
