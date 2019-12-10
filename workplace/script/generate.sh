CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
EXEC_FILE_PATH='../../fairseq/fairseq_cli/'
DATA_DIR='../data-bin/cnndm_small/'
SAVE_DIR='../checkpoints/cnndm_small/insertion_transformer2/checkpoint_best.pt'

CUDA_VISIBLE_DEVICES=7,8,9 \
   python ${EXEC_FILE_PATH}generate.py ${DATA_DIR} \
   --gen-subset train \
   --path ${SAVE_DIR} \
   --beam 5 \
   --task translation_lev \
      --iter-decode-max-iter 3 \
      --iter-decode-eos-penalty 1 \
      --iter-decode-force-max-iter \
   --print-step \
   --max-tokens 4096 \
   --skip-invalid-size-inputs-valid-test \
   --max-source-positions 2048 \
   --min-len 5 
