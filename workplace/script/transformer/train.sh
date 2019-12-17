CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR

FAIRSEQ_ROOT=~/fairseq/
DATA=cnndm_annt_small
MODEL=transformer
EXEC_FILE_PATH=${FAIRSEQ_ROOT}fairseq/fairseq_cli/
DATA_DIR=${FAIRSEQ_ROOT}workplace/data-bin/${DATA}/
SAVE_DIR=${FAIRSEQ_ROOT}workplace/checkpoints/${DATA}/${MODEL}/
USER_DIR=${FAIRSEQ_ROOT}workplace/user-dir/

CUDA_VISIBLE_DEVICES=0,2,3 \
   python ${EXEC_FILE_PATH}train.py ${DATA_DIR} \
   --save-dir ${SAVE_DIR} \
   --arch transformer \
      --max-source-positions 512 \
      --max-target-positions 512 \
   --task translation \
   --ddp-backend=no_c10d \
   --criterion cross_entropy \
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
   --user-dir ${USER_DIR}
#--fp16 \
