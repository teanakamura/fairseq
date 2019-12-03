CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
EXEC_FILE_PATH='../../fairseq/fairseq_cli/'
DATA_DIR='../data-bin/cnndm/'
SAVE_DIR='../checkpoints/cnndm/insertion_transformer/checkpoint_best.pt'

CUDA_VISIBLE_DEVICES=2,3 \
   python ${EXEC_FILE_PATH}generate.py ${DATA_DIR} \
   --gen-subset test \
   --path ${SAVE_DIR} \
   --batch-size 32 \
   --beam 5 \
   --task translation_lev \
      --iter-decode-max-iter 100 \
      --iter-decode-eos-penalty 0 \
      --print-step \
      --iter-decode-force-max-iter \
   --max-tokens 4096 \
   --skip-invalid-size-inputs-valid-test \
   --max-source-positions 2048 \
   --remove-bpe 
