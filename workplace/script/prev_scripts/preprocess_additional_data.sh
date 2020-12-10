CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
EXEC_FILE_PATH=../../fairseq/fairseq_cli/
DATA=cnndm-pj
SIZE=full
DETAIL=tfidf_annt_sep
# DATA_DETAIL=$DETAIL
# DEST_DETAIL=$DETAIL/additional_data
DATA_DETAIL=$DETAIL/subword-nmt
DEST_DETAIL=$DETAIL-subword/additional_data
DATA_DIR=$HOME/Data/$DATA/$SIZE/$DATA_DETAIL
DEST_DIR=../data-bin/$DATA/$SIZE/$DEST_DETAIL

python ${EXEC_FILE_PATH}preprocess.py \
  --task translation \
  --source-lang add \
  --trainpref ${DATA_DIR}/train \
  --validpref ${DATA_DIR}/val \
  --testpref ${DATA_DIR}/test \
  --destdir ${DEST_DIR} \
  --nwordssrc 50000 \
  --nwordstgt 50000 \
  --workers 16 \
  --only-source
