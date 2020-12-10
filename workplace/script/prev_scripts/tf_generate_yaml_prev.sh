#!/bin/zsh

update_conf () {
  parse_yaml $1 |
  while read line
  do
    if echo $line | grep -F = &>/dev/null
    then
      varname=$(echo "$line" | cut -d '=' -f 1)
      CONF[$varname]=$(echo "$line" | cut -d '=' -f 2- | sed -e 's/^"//' -e 's/"$//' )
    fi
  done
}


echo ${JOB_ID}


CONF_DIR=${FAIRSEQ_ROOT}/workplace/script/yaml_configs
DATA=$1
CONF_FILE=$2


declare -A CONF # bash>=4.2
update_conf $CONF_DIR/default.yml
update_conf $CONF_DIR/$DATA/default.yml
update_conf $CONF_DIR/$DATA/$CONF_FILE
for key in ${(k)CONF[@]}; do  # zsh
  echo "$key: ${CONF[$key]}"
done


ENV_FILE=${FAIRSEQ_ROOT}/workplace/script/env_yaml
source ${ENV_FILE}
if [[ ${CONF[data]: -7} == subword ]]; then
  SYSTEM=system_output-subword.txt
  REFERENCE=reference-subword.txt
else
  SYSTEM=system_output.txt
  REFERENCE=reference.txt
fi

mkdir -p ${OUT_DIR}

#CUDA_VISIBLE_DEVICES=0,2,3 \
## zshの配列でオプショナル引数を作る
OPTIONAL_ARGS=(
   --gen-subset ${CONF[gen_subset]}
   --path ${SAVE_FILE}
   --beam ${CONF[beam]} 
   --task ${CONF[model_task]}
      --iter-decode-max-iter 30
      --iter-decode-eos-penalty 1
   --max-tokens ${CONF[io_max_tokens]}
   --skip-invalid-size-inputs-valid-test
   --max-source-positions ${CONF[io_max_src]}
   --min-len 5
   --system ${OUT_DIR}/${SYSTEM}
   --reference ${OUT_DIR}/${REFERENCE}
   --truncate-source
   --user-dir ${USER_DIR}
   --source-lang ${CONF[lang_src]}
   --target-lang ${CONF[lang_tgt]}
)
if ${CONF[fp16]}; then
  OPTIONAL_ARGS+='--fp16'
fi
if ${CONF[cpu]}; then
  OPTIONAL_ARGS+='--cpu'
fi
if ${CONF[reset_optimizer]}; then
  OPTIONAL_ARGS+='--reset-optimizer'
fi
if [ -n "${CONF[additional_data]}" ]; then
  echo "${CONF[additional_data]}"
  OPTIONAL_ARGS+='--additional-data'
  OPTIONAL_ARGS+="${FAIRSEQ_ROOT}/${CONF[additional_data]}"
fi
# echo $OPTIONAL_ARGS
echo "python ${EXEC_GEN_FILE_PATH}generate.py ${GEN_DATA_DIR} ${OPTIONAL_ARGS}"
python ${EXEC_GEN_FILE_PATH}generate.py ${GEN_DATA_DIR} ${OPTIONAL_ARGS}
unset CONF

if [[ ${CONF[data]: -7} = subword ]]; then
  CURRENT_DIR=`pwd`
  cd $OUT_DIR
  sed -r 's/(@@ )|(@@ ?$)//g' system_output-subword.txt > system_output.txt
  sed -r 's/(@@ )|(@@ ?$)//g' reference-subword.txt > reference.txt
  cd ${CURRENT_DIR}
fi
