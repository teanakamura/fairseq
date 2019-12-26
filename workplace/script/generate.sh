CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
#EXEC_FILE_PATH='../../fairseq/fairseq_cli/'
EXEC_FILE_PATH='./'
MODEL=insertion_transformer_fw_tau
DATA=cnndm/small
DATA_DIR=../data-bin/${DATA}/
SAVE_DIR=../checkpoints/${DATA}/${MODEL}/checkpoint3000.pt
USER_DIR=../user-dir/
OUT_DIR=../generation/${DATA}/${MODEL}_best/
SYSTEM=system_output.txt
REFERENCE=reference.txt

mkdir -p ${OUT_DIR}

CUDA_VISIBLE_DEVICES=7,8,9 \
   python ${EXEC_FILE_PATH}generate.py ${DATA_DIR} \
   --gen-subset test \
   --path ${SAVE_DIR} \
   --beam 5 \
   --task translation_lev \
      --iter-decode-max-iter 30 \
      --iter-decode-eos-penalty 1 \
   --print-step \
   --max-tokens 4096 \
   --skip-invalid-size-inputs-valid-test \
   --max-source-positions 2048 \
   --min-len 5 \
   --user-dir ${USER_DIR} \
   --system ${OUT_DIR}${SYSTEM}\
   --reference ${OUT_DIR}${REFERENCE} \
   --retain-iter-history \
#  --iter-decode-force-max-iter \
