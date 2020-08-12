#!/bin/bash

#$ -l rt_C.small=1
#$ -l h_rt=72:00:00
#$ -j y
#$ -cwd
#$ -o test.out
##$ -e std/std0/err

echo 'MAIN'
echo "PATH: $PATH"
source testrc
echo "PATH: $PATH"
echo "SHELL VARIABLE: $SHELLVAR"
echo "ENVIRONMENTAL VARIABLE: $ENVVAR"
echo "PID/BASHPID/PPID: $$/$BASHPID/$PPID"

echo
echo 'ZSH'
zsh subtest.sh

echo
echo 'BASH'
bash subtest.sh
