CONF_FILE=./configs/type1.conf
declare -A CONF # bash<4.2

while read line
do
  if echo $line | grep -F = &>/dev/null
  then
    varname=$(echo "$line" | cut -d '=' -f 1)
    conf[$varname]=$(echo "$line" | cut -d '=' -f 2-)
  fi
done < $CONF_FILE


CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR

FAIRSEQ_ROOT=~/fairseq/
DATA=cnndm
MODEL=insertion_transformer_fw_tau
EXEC_FILE_PATH=${FAIRSEQ_ROOT}fairseq/fairseq_cli/
echo ${EXEC_FILE_PATH}
DATA_DIR=${FAIRSEQ_ROOT}workplace/data-bin/${DATA}/
SAVE_DIR=${FAIRSEQ_ROOT}workplace/checkpoints/${DATA}/${MODEL}/
USER_DIR=${FAIRSEQ_ROOT}workplace/user-dir/


#CUDA_VISIBLE_DEVICES=7,8,9 \
   python ${EXEC_FILE_PATH}train.py ${DATA_DIR} \
   --save-dir ${SAVE_DIR} \
   --arch insertion_transformer \
      --max-source-positions 2048 \
      --max-target-positions 512 \
      --apply-bert-init \
      --label-tau 0.01 \
   --task translation_lev \
   --ddp-backend=no_c10d \
   --criterion nat_loss \
      --label-smoothing 0.1 \
   --noise random_delete \
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
   --fp16 \
