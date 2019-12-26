CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
EXEC_FILE_PATH=../../fairseq/fairseq_cli/
DATA=cnndm-pj
SIZE=full
DETAIL=tfidf_annt_from_sum
DATA_DIR=$HOME/Data/$DATA/$SIZE/$DETAIL
DEST_DIR=../data-bin/$DATA/$SIZE/$DETAIL

python ${EXEC_FILE_PATH}preprocess.py \
  --task translation \
  --source-lang doc \
  --target-lang sum \
  --trainpref ${DATA_DIR}/train \
  --validpref ${DATA_DIR}/val \
  --testpref ${DATA_DIR}/test \
  --destdir ${DEST_DIR} \
  --nwordssrc 50000 \
  --nwordstgt 50000 \
  --joined-dictionary \
