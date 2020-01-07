FAIRSEQ_ROOT=~/fairseq/
CONF_FILE=${FAIRSEQ_ROOT}workplace/script/configs/v1.conf
declare -A CONF # bash>=4.2
echo $CONF_FILE

while read line
do
  if echo $line | grep -F = &>/dev/null
  then
    varname=$(echo "$line" | cut -d '=' -f 1)
    CONF[$varname]=$(echo "$line" | cut -d '=' -f 2-)
  fi
done < $CONF_FILE
CONF[data]=tfidf_annt_from_sum
CONF[sdata]=tfidf_annt_from_sum_fail
CONF[model]=transformer
CONF[checkpoint]=34

EXEC_FILE_PATH=${FAIRSEQ_ROOT}workplace/script/
DATA_DIR=${FAIRSEQ_ROOT}workplace/data-bin/${CONF[data]}/
SAVE_DIR=${FAIRSEQ_ROOT}workplace/checkpoints/${CONF[sdata]}/${CONF[model]}/checkpoint${CONF[checkpoint]}.pt
USER_DIR=${FAIRSEQ_ROOT}workplace/user-dir/
OUT_DIR=${FAIRSEQ_ROOT}workplace/generation/${CONF[sdata]}/${CONF[model]}_best/
SYSTEM=system_output.txt
REFERENCE=reference.txt

mkdir -p ${OUT_DIR}

#CUDA_VISIBLE_DEVICES=7,8,9 \
   python ${EXEC_FILE_PATH}generate.py ${DATA_DIR} \
   --gen-subset test \
   --path ${SAVE_DIR} \
   --beam 5 \
   --task translation \
      --iter-decode-max-iter 30 \
      --iter-decode-eos-penalty 1 \
   --max-tokens 4096 \
   --skip-invalid-size-inputs-valid-test \
   --max-source-positions 512 \
   --min-len 5 \
   --system ${OUT_DIR}${SYSTEM}\
   --reference ${OUT_DIR}${REFERENCE} \
