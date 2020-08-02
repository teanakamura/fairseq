#!/bin/sh

echo "PATH: $PATH"
echo "SHELL VARIABLE: $SHELLVAR"
echo "ENVIRONMENTAL VARIABLE: $ENVVAR"
echo "PID/BASHPID/PPID: $$/$BASHPID/$PPID"

eval $(parse_yaml test.yml)
echo $a $a_b $c $c_d
