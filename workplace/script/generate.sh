CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
#EXEC_FILE_PATH='../../fairseq/fairseq_cli/'
EXEC_FILE_PATH='./'
DATA_DIR='../data-bin/cnndm_small/'
SAVE_DIR='../checkpoints/cnndm_small/insertion_transformer_tau/checkpoint_last.pt'
USER_DIR='../user-dir/'

CUDA_VISIBLE_DEVICES=7,8,9 \
   python ${EXEC_FILE_PATH}generate.py ${DATA_DIR} \
   --gen-subset train \
   --path ${SAVE_DIR} \
   --beam 5 \
   --task translation_lev \
      --iter-decode-max-iter 10 \
      --iter-decode-eos-penalty 1 \
   --print-step \
   --retain-iter-history \
   --max-tokens 4096 \
   --skip-invalid-size-inputs-valid-test \
   --max-source-positions 2048 \
   --min-len 5 \
   --user-dir ${USER_DIR}
#  --iter-decode-force-max-iter \
