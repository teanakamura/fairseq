#!/bin/zsh

CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
while getopts d:y: OPT
do
  case ${OPT} in
    d) DATA=${OPTARG}
       ;;
    y) YML=${OPTARG}
       ;;
  esac
done
shift `expr ${OPTIND} - 1`
echo

while [ -z $DATA ] || [ ! -d "$SCRIPT_DIR/yaml_configs/$DATA" ]
do
  ls "$SCRIPT_DIR/yaml_configs/"
  read "DATA?Input data (-d): "
  echo
done
while [ ! -f "$SCRIPT_DIR/yaml_configs/$DATA/$YML.yml" ]
do
  ls "$SCRIPT_DIR/yaml_configs/$DATA"
  read "YML?Input yaml file basename (-y): "
  echo
done

EXEC_FILE_PATH=$SCRIPT_DIR/../../fairseq/fairseq_cli/

data_subpath_array=("${(ps./.)DATA}")
yml_path=$SCRIPT_DIR/yaml_configs
if [ -f $yml_path/default.yml ]; then; eval $(parse_yaml $yml_path/default.yml); fi
for subpath in ${data_subpath_array[@]}; do
  yml_path=$yml_path/$subpath
  if [ -f $yml_path/default.yml ]; then
    eval $(parse_yaml $yml_path/default.yml)
    echo $yml_path/default.yml
  fi
done
eval $(parse_yaml $yml_path/$YML.yml)
echo $yml_path/$YML.yml

DATA_DIR=$HOME/Data/$data_name/$data_type
echo DATA_DIR: $DATA_DIR
DEST_DIR=$SCRIPT_DIR/../data-bin/$data_name/${dest_dir:-$data_type}
echo DEST_DIR: $DEST_DIR

python ${EXEC_FILE_PATH}preprocess.py \
  --task translation \
  --source-lang $lang_src \
  --target-lang $lang_tgt \
  --trainpref $DATA_DIR/train \
  --validpref $DATA_DIR/val \
  --testpref $DATA_DIR/test \
  --destdir $DEST_DIR \
  --nwordssrc 50000 \
  --nwordstgt 50000 \
  --joined-dictionary \
  --workers 16 \
