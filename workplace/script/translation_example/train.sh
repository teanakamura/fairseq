CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
EXEC_FILE_PATH=~/fairseq/fairseq/fairseq_cli/
DATA_DIR=~/fairseq/workplace/data-bin/wmt17_en_de/
SAVE_DIR=~/fairseq/workplace/checkpoints/wmt17_en_de/insertion_transformer/

CUDA_VISIBLE_DEVICES=7,8,9 \
   python ${EXEC_FILE_PATH}train.py ${DATA_DIR} \
   --save-dir ${SAVE_DIR} \
   --arch insertion_transformer \
      --apply-bert-init \
   --task translation_lev \
   --ddp-backend=no_c10d \
   --criterion nat_loss \
      --label-smoothing 0.1 \
   --noise random_delete \
   --share-all-embeddings \
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
   --log-interval 100 \
   --fixed-validation-seed 7 \
   --max-tokens 4096 \
   --save-interval-updates 10000 \
   --max-update 300000
