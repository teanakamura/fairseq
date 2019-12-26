CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
#EXEC_FILE_PATH='../../fairseq/fairseq_cli/'
EXEC_FILE_PATH='../'
DATA_DIR='../../data-bin/cnndm/small/'
SAVE_DIR='../../checkpoints/cnndm/small/transformer/checkpoint_last.pt'
USER_DIR='../../user-dir/'
OUT_DIR=../../generation/cnndm/transformer/
SYSTEM=system_output.txt
REFERENCE=reference.txt


CUDA_VISIBLE_DEVICES=7,8,9 \
   python ${EXEC_FILE_PATH}generate.py ${DATA_DIR} \
   --gen-subset train \
   --path ${SAVE_DIR} \
   --beam 5 \
   --task translation \
      --iter-decode-max-iter 10 \
      --iter-decode-eos-penalty 1 \
   --max-tokens 4096 \
   --skip-invalid-size-inputs-valid-test \
   --max-source-positions 2048 \
   --min-len 5 \
   --user-dir ${USER_DIR} \
   --system ${OUT_DIR}${SYSTEM}\
   --reference ${OUT_DIR}${REFERENCE}
#  --iter-decode-force-max-iter \
