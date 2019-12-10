CURRENT_DIR=`pwd`
SCRIPT_DIR=`dirname $0`
cd $SCRIPT_DIR
EXEC_FILE_PATH=$HOME/fairseq/fairseq/fairseq_cli/
DATA_DIR=$HOME/fairseq/fairseq/examples/translation/wmt17_en_de
DEST_DIR=$HOME/fairseq/workplace/data-bin/wmt17_en_de

python ${EXEC_FILE_PATH}preprocess.py \
  --task translation_lev \
  --source-lang en \
  --target-lang de \
  --trainpref ${DATA_DIR}/train \
  --validpref ${DATA_DIR}/valid \
  --testpref ${DATA_DIR}/test \
  --destdir ${DEST_DIR} \
  --thresholdtgt 0 \
  --thresholdsrc 0 \
  --workers 20 \
  --nwordssrc 50000 \
  --nwordstgt 50000 \
  --joined-dictionary
