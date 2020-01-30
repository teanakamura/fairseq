echo ${JOB_ID}

FAIRSEQ_ROOT=~/fairseq
#SCRIPT_DIR=`dirname $0`
#SCRIPT_DIR=${FAIRSEQ_ROOT}/workplace/script
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

EXEC_FILE_PATH=${FAIRSEQ_ROOT}/fairseq/fairseq_cli/
DATA_DIR=${FAIRSEQ_ROOT}/workplace/data-bin/${CONF[data]}/
GROUPDISK=/fs1/groups1/gcb50243/nakamura
SAVE_DIR=${GROUPDISK}/checkpoints/${CONF[data]}/${CONF[model]}/
USER_DIR=${FAIRSEQ_ROOT}/workplace/user-dir/
TENSORBOARD_DIR=${FAIRSEQ_ROOT}/workplace/tensorboard-log/${CONF[data]}/${CONF[model]}/log/

echo $DATA_DIR
echo $SAVE_DIR

#CUDA_VISIBLE_DEVICES=0,2,3 \
   python ${EXEC_FILE_PATH}train.py ${DATA_DIR} \
   --save-dir ${SAVE_DIR} \
   --arch transformer_cov \
      --max-source-positions 512 \
      --max-target-positions 512 \
   --task translation \
     --truncate-source \
   --ddp-backend=no_c10d \
   --criterion ${CONF[criterion]} \
   --optimizer adam \
      --adam-betas '(0.9,0.98)' \
   --lr 0.0005 \
   --lr-scheduler inverse_sqrt \
   --min-lr '1e-09' \
   --warmup-updates 10000 \
   --warmup-init-lr '1e-07' \
   --dropout 0.3 \
   --weight-decay 0.01 \
   --decoder-learned-pos \
   --encoder-learned-pos \
   --log-format 'simple' \
   --log-interval 1000 \
   --fixed-validation-seed 7 \
   --max-tokens 2048 \
   --max-sentences 16 \
   --update-freq 4 \
   --save-interval-updates 20000 \
   --max-update 300000 \
   --skip-invalid-size-inputs-valid-test \
   --user-dir ${USER_DIR} \
   --keep-last-epochs 3 \
   --truncate-source \
   --fp16 \
   --tensorboard-logdir ${TENSORBOARD_DIR} \
