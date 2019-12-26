#CURRENT_DIR=`pwd`
#SCRIPT_DIR=`dirname $0`
#cd $SCRIPT_DIR

FAIRSEQ_ROOT=~/fairseq/
EXEC_FILE_PATH=${FAIRSEQ_ROOT}workplace/script/
DATA_DIR=${FAIRSEQ_ROOT}workplace/data-bin/${DATA}/
SAVE_DIR=${FAIRSEQ_ROOT}workplace/checkpoints/${_DATA}/${MODEL}/checkpoint${checkpoint}.pt
USER_DIR=${FAIRSEQ_ROOT}workplace/user-dir/
OUT_DIR=${FAIRSEQ_ROOT}workplace/generation/${DATA}/${MODEL}_best/
SYSTEM=system_output.txt
REFERENCE=reference.txt

mkdir -p ${OUT_DIR}

#CUDA_VISIBLE_DEVICES=7,8,9 \
   python ${EXEC_FILE_PATH}generate.py ${DATA_DIR} \
   --gen-subset test \
   --path ${SAVE_DIR} \
   --beam 5 \
   --task translation \
      --iter-decode-max-iter 30 \
      --iter-decode-eos-penalty 1 \
   --max-tokens 4096 \
   --skip-invalid-size-inputs-valid-test \
   --max-source-positions 512 \
   --min-len 5 \
   --user-dir ${USER_DIR} \
   --system ${OUT_DIR}${SYSTEM}\
   --reference ${OUT_DIR}${REFERENCE} \
