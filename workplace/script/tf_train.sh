echo ${JOB_ID}

FAIRSEQ_ROOT=~/fairseq
#SCRIPT_DIR=`dirname $0`
#SCRIPT_DIR=${FAIRSEQ_ROOT}/workplace/script
CONF_DIR=${FAIRSEQ_ROOT}/workplace/script/configs
CONF_FILE=$1

while [ ! -f "$CONF_DIR/$CONF_FILE" ]
do
  ls "$CONF_DIR" | grep -E ".+\.conf" --colour=never
  read "CONF_FILE?Input config file: "
done
echo "CONFIG FILE: $CONF_FILE"

declare -A CONF # bash>=4.2
CONF[model]=transformer
CONF[arch]=transformer
CONF[task]=translation
CONF[criterion]=cross_entropy
CONF[max_source]=512
CONF[max_target]=512
CONF[lr]=0.0005
CONF[min_lr]=1e-09
CONF[warmup_updates]=10000
CONF[warmup_init_lr]=1e-07
CONF[dropout]=0.3
CONF[weight_decay]=0.01
CONF[max_tokens]=2048
CONF[max_sentences]=16
CONF[update_freq]=4
CONF[max_update]=300000
CONF[keep_last_epochs]=3
CONF[fp16]=true

while read line
do
  if echo $line | grep -F = &>/dev/null
  then
    varname=$(echo "$line" | cut -d '=' -f 1)
    CONF[$varname]=$(echo "$line" | cut -d '=' -f 2-)
  fi
done < $CONF_DIR/$CONF_FILE
CONF_FILE=

ENV_FILE=${FAIRSEQ_ROOT}/workplace/script/env
source ${ENV_FILE}
echo EXEC_FILE_PATH: ${EXEC_FILE_PATH}
echo DATA_DIR: ${DATA_DIR}
echo SAVE_DIR: ${SAVE_DIR}
echo USER_DIR: ${USER_DIR}
echo TENSORBOARD_DIR: ${TENSORBOARD_DIR}

#CUDA_VISIBLE_DEVICES=0,2,3 \
OPTIONAL_ARGS=(
   --save-dir ${SAVE_DIR}
   --arch ${CONF[arch]}
      --max-source-positions ${CONF[max_source]}
      --max-target-positions ${CONF[max_target]}
   --task ${CONF[task]}
     --truncate-source
   --ddp-backend=no_c10d
   --criterion ${CONF[criterion]}
   --optimizer adam
      --adam-betas "(0.9,0.98)"
   --lr ${CONF[lr]}
   --lr-scheduler inverse_sqrt
   --min-lr ${CONF[min_lr]}
   --warmup-updates ${CONF[warmup_updates]}
   --warmup-init-lr ${CONF[warmup_init_lr]}
   --dropout ${CONF[dropout]}
   --weight-decay ${CONF[weight_decay]}
   --decoder-learned-pos
   --encoder-learned-pos
   --log-format simple
   --log-interval 1000
   --fixed-validation-seed 7
   --max-tokens ${CONF[max_tokens]}
   --max-sentences ${CONF[max_sentences]}
   --update-freq ${CONF[update_freq]}
   --save-interval-updates 20000
   --max-update ${CONF[max_update]}
   --skip-invalid-size-inputs-valid-test
   --user-dir ${USER_DIR}
   --keep-last-epochs ${CONF[keep_last_epochs]}
   --truncate-source
   --tensorboard-logdir ${TENSORBOARD_DIR}
)
if ${CONF[fp16]}; then
  OPTIONAL_ARGS+=--fp16
fi
# echo $OPTIONAL_ARGS
echo "python ${EXEC_FILE_PATH}train.py ${DATA_DIR} ${OPTIONAL_ARGS}"
python ${EXEC_FILE_PATH}train.py ${DATA_DIR} ${OPTIONAL_ARGS}
