echo ${JOB_ID}

FAIRSEQ_ROOT=~/fairseq/
CONF_DIR=${FAIRSEQ_ROOT}/workplace/script/configs
CONF_FILE=$1

while [ ! -f "$CONF_DIR/$CONF_FILE" ]
do
  ls "$CONF_DIR" | grep -E ".+\.conf" --colour=never
  read "CONF_FILE?Input config file: "
done
echo "CONFIG FILE: $CONF_FILE"

declare -A CONF # bash>=4.2
CONF[model]=transformer
CONF[arch]=transformer
CONF[task]=translation
CONF[criterion]=cross_entropy
CONF[max_source]=512
CONF[max_target]=512
CONF[lr]=0.0005
CONF[min_lr]=1e-09
CONF[warmup_updates]=10000
CONF[warmup_init_lr]=1e-07
CONF[dropout]=0.3
CONF[weight_decay]=0.01
CONF[max_tokens]=2048
CONF[max_sentences]=16
CONF[update_freq]=4
CONF[max_update]=300000
CONF[keep_last_epochs]=3
CONF[fp16]=true
CONF[cpu]=false
CONF[reset_optimizer]=false
CONF[gen_subset]=test
CONF[beam]=5
CONF[gen_data]=

while read line
do
  if echo $line | grep -F = &>/dev/null
  then
    varname=$(echo "$line" | cut -d '=' -f 1)
    CONF[$varname]=$(echo "$line" | cut -d '=' -f 2-)
  fi
done < $CONF_DIR/$CONF_FILE
CONF_FILE=

ENV_FILE=${FAIRSEQ_ROOT}/workplace/script/env
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
   --task ${CONF[task]}
      --iter-decode-max-iter 30
      --iter-decode-eos-penalty 1
   --max-tokens ${CONF[max_tokens]}
   --skip-invalid-size-inputs-valid-test
   --max-source-positions ${CONF[max_source]}
   --min-len 5
   --system ${OUT_DIR}/${SYSTEM}
   --reference ${OUT_DIR}/${REFERENCE}
   --truncate-source
   --user-dir ${USER_DIR}
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
