echo ${JOB_ID}

FAIRSEQ_ROOT=~/fairseq/
CONF_DIR=${FAIRSEQ_ROOT}/workplace/script/configs
CONF_FILE=$1

while [ ! -f "$CONF_DIR/$CONF_FILE" ]
do
  ls "$CONF_DIR" | grep -E ".+\.conf" --colour=never
  read "CONF_FILE?Input config file: "
done

declare -A CONF # bash>=4.2
echo "CONFIG FILE: $CONF_FILE"

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

#CUDA_VISIBLE_DEVICES=7,8,9 \
   python ${EXEC_GEN_FILE_PATH}generate.py ${GEN_DATA_DIR} \
   --gen-subset test \
   --path ${SAVE_FILE} \
   --beam 5 \
   --task translation \
      --iter-decode-max-iter 30 \
      --iter-decode-eos-penalty 1 \
   --max-tokens 4096 \
   --skip-invalid-size-inputs-valid-test \
   --max-source-positions 512 \
   --min-len 5 \
   --system ${OUT_DIR}/${SYSTEM} \
   --reference ${OUT_DIR}/${REFERENCE} \
   --truncate-source \
   --user-dir ${USER_DIR}

if [ ${CONF[data]: -7} = subword ]; then
  CURRENT_DIR=`pwd`
  cd $OUT_DIR
  sed -r 's/(@@ )|(@@ ?$)//g' system_output-subword.txt > system_output.txt
  sed -r 's/(@@ )|(@@ ?$)//g' reference-subword.txt > reference.txt
  cd ${CURRENT_DIR}
fi

unset CONF
