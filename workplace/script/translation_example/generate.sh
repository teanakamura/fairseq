CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
EXEC_FILE_PATH=~/fairseq/fairseq/fairseq_cli/
DATA_DIR=~/fairseq/workplace/data-bin/wmt17_en_de/
SAVE_DIR=~/fairseq/workplace/checkpoints/wmt17_en_de/insertion_transformer/checkpoint_best.pt

#CUDA_VISIBLE_DEVICES=2,3 \
   python ${EXEC_FILE_PATH}generate.py ${DATA_DIR} \
   --gen-subset test \
   --path ${SAVE_DIR} \
   --batch-size 32 \
   --beam 5 \
   --task translation_lev \
      --iter-decode-max-iter 100 \
      --iter-decode-eos-penalty 0 \
      --iter-decode-force-max-iter \
   --print-step \
   --max-tokens 4096 \
   --skip-invalid-size-inputs-valid-test \
   --max-source-positions 2048 \
   --remove-bpe \
   --min-len 5 
