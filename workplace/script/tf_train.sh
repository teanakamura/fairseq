FAIRSEQ_ROOT=~/fairseq/
CONF_FILE=${FAIRSEQ_ROOT}workplace/script/configs/lab.conf
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

#CURRENT_DIR=`pwd`
#SCRIPT_DIR=`dirname $0`
#cd $SCRIPT_DIR

EXEC_FILE_PATH=${FAIRSEQ_ROOT}fairseq/fairseq_cli/
DATA_DIR=${FAIRSEQ_ROOT}workplace/data-bin/${CONF[data]}/
SAVE_DIR=${FAIRSEQ_ROOT}workplace/checkpoints/${CONF[data]}/${CONF[model]}/
USER_DIR=${FAIRSEQ_ROOT}workplace/user-dir/

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
   --criterion cross_entropy_with_coverage \
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
   --keep-last-epochs 10 \
   #--fp16 \
