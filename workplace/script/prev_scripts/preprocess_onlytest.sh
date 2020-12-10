CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
EXEC_FILE_PATH=../../fairseq/fairseq_cli/
DATA=cnndm-pj
SIZE=full
DETAIL=tfidf_annt_01
SRCDICT_DETAIL=tfidf_annt_008
DATA_DETAIL=$DETAIL
DEST_DETAIL=${SRCDICT_DETAIL}/${DETAIL}_data
# DATA_DETAIL=$DETAIL/subword-nmt
# DEST_DETAIL=${SRCDICT_DETAIL}-subword/${DETAIL}-subword_data
DATA_DIR=$HOME/Data/$DATA/$SIZE/$DATA_DETAIL
DEST_DIR=../data-bin/$DATA/$SIZE/$DEST_DETAIL
DICT_DIR=../data-bin/$DATA/$SIZE/$SRCDICT_DETAIL

python ${EXEC_FILE_PATH}preprocess.py \
  --task translation \
  --source-lang doc \
  --target-lang sum \
  --testpref ${DATA_DIR}/test \
  --destdir ${DEST_DIR} \
  --nwordssrc 50000 \
  --nwordstgt 50000 \
  --joined-dictionary \
  --workers 16 \
  --srcdict ${DICT_DIR}/dict.doc.txt\
