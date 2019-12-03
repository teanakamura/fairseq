#!/bin/bash

SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR

#$ -l rt_F=1
#$ -l h_rt=72:00:00
#$ -j y
#$ -cwd
#$ -o ../std/out
#$ -e ../std/err

## Initialize module
source /etc/profile.d/modules.sh

module load python/3.6/3.6.5
module load cuda/9.1/9.1.85.3
module load cudnn/7.1/7.1.3

source ~/venv/pytorch/bin/activate

source ~/fairseq/workplace/script/train.sh
