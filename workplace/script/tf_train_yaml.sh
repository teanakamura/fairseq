#!/bin/zsh

update_conf () {
  parse_yaml $1 |
  while read line
  do
    if echo $line | grep -F = &>/dev/null
    then
      varname=$(echo "$line" | cut -d '=' -f 1)
      CONF[$varname]=$(echo "$line" | cut -d '=' -f 2- | sed -e 's/^"//' -e 's/"$//' )
    fi
  done
}


echo ${JOB_ID}


CONF_DIR=${FAIRSEQ_ROOT}/workplace/script/yaml_configs
DATA=$1
CONF_FILE=$2


declare -A CONF # bash>=4.2
update_conf $CONF_DIR/default.yml
update_conf $CONF_DIR/$DATA/default.yml
update_conf $CONF_DIR/$DATA/$CONF_FILE
for key in ${(k)CONF[@]}; do  # zsh
  echo "$key: ${CONF[$key]}"
done


ENV_FILE=${FAIRSEQ_ROOT}/workplace/script/env_yaml
source ${ENV_FILE}
echo EXEC_FILE_PATH: ${EXEC_FILE_PATH}
echo DATA_DIR: ${DATA_DIR}
echo SAVE_DIR: ${SAVE_DIR}
echo USER_DIR: ${USER_DIR}
echo TENSORBOARD_DIR: ${TENSORBOARD_DIR}

# #CUDA_VISIBLE_DEVICES=0,2,3 \
# ## zshの配列でオプショナル引数を作る
OPTIONAL_ARGS=(
   --save-dir ${SAVE_DIR}
   --arch ${CONF[model_arch]}
      --max-source-positions ${CONF[io_max_src]}
      --max-target-positions ${CONF[io_max_tgt]}
   --task ${CONF[model_task]}
     --truncate-source
   --ddp-backend=no_c10d
   --criterion ${CONF[model_criterion]}
   --optimizer adam
      --adam-betas "(0.9,0.98)"
   --lr ${CONF[lr_init]}
   --lr-scheduler inverse_sqrt
   --min-lr ${CONF[lr_min]}
   --warmup-updates ${CONF[warmup_updates]}
   --warmup-init-lr ${CONF[warmup_init_lr]}
   --dropout ${CONF[reg_dropout]}
   --weight-decay ${CONF[reg_weight_decay]}
   --decoder-learned-pos
   --encoder-learned-pos
   --log-format simple
   --log-interval 1000
   --fixed-validation-seed 7
   --max-tokens ${CONF[io_max_tokens]}
   --max-sentences ${CONF[io_max_sentences]}
   --update-freq ${CONF[update_freq]}
   --save-interval-updates 20000
   --clip-norm ${CONF[clip_norm]}
   --max-update ${CONF[update_max]}
   --max-epoch ${CONF[max_epoch]}
   --skip-invalid-size-inputs-valid-test
   --user-dir ${USER_DIR}
   --keep-last-epochs ${CONF[keep_last_epochs]}
   --truncate-source
   --tensorboard-logdir ${TENSORBOARD_DIR}
)
if ${CONF[fp16]}; then
  OPTIONAL_ARGS+='--fp16'
fi
if ${CONF[cpu]}; then
  OPTIONAL_ARGS+='--cpu'
fi
if ${CONF[reset_optimizer]}; then
  OPTIONAL_ARGS+='--reset-optimizer'
fi
if [ -n "${CONF[seed]}" ]; then
  OPTIONAL_ARGS+='--seed'
  OPTIONAL_ARGS+=${CONF[seed]}
fi
if [ -n "${CONF[model_criterion_label_smoothing]}" ]; then
  OPTIONAL_ARGS+='--label-smoothing'
  OPTIONAL_ARGS+=${CONF[model_criterion_label_smoothing]}
fi
if [ -n "${CONF[additional_data]}" ]; then
  OPTIONAL_ARGS+='--additional-data'
  OPTIONAL_ARGS+="${FAIRSEQ_ROOT}/${CONF[additional_data]}"
fi
# echo $OPTIONAL_ARGS
echo "python ${EXEC_FILE_PATH}train.py ${DATA_DIR} ${OPTIONAL_ARGS}"
python ${EXEC_FILE_PATH}train.py ${DATA_DIR} ${OPTIONAL_ARGS}
unset CONF
