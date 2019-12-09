CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
EXEC_FILE_PATH='../../fairseq/fairseq_cli/'
DATA='cnndm_dot_small'
DATA_DIR=$HOME'/Data/cnndm-pj/'${DATA}
DEST_DIR='../data-bin/'${DATA}

python ${EXEC_FILE_PATH}preprocess.py \
  --task translation_lev \
  --source-lang doc \
  --target-lang sum \
  --trainpref ${DATA_DIR}/train \
  --validpref ${DATA_DIR}/val \
  --testpref ${DATA_DIR}/test \
  --destdir ${DEST_DIR} \
  --nwordssrc 50000 \
  --nwordstgt 50000 \
  --joined-dictionary
