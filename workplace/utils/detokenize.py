import sentencepiece as spm
import os
import argparse
import yaml
from attrdict import AttrDict


HOME=os.environ['HOME']
FAIRSEQ_ROOT=f'{HOME}/fairseq'
SPMODEL_ROOT=f'{HOME}/data'

def deepupdate(dict_base, other):
  for k, v in other.items():
    if isinstance(v, dict) and k in dict_base:
      deepupdate(dict_base[k], v)
    else:
      dict_base[k] = v

def parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('-d', '--data', required=True)
    parser.add_argument('-y', '--yaml', required=True)
    return parser.parse_args()

def load_yaml():
    args = parse()
    yaml_root_path = f'{FAIRSEQ_ROOT}/workplace/script/yaml_configs'
    conf = yaml.safe_load(open(f'{yaml_root_path}/default.yml'))
    if os.path.isfile(f'{yaml_root_path}/{args.data}/default.yml'):
        deepupdate(conf, yaml.safe_load(open(f'{yaml_root_path}/{args.data}/default.yml')))
    deepupdate(conf, yaml.safe_load(open(f'{yaml_root_path}/{args.data}/{args.yaml}')))
    return AttrDict(conf)

if __name__ == '__main__':
    conf = load_yaml()
    sp = spm.SentencePieceProcessor()
    sp.load(f'{SPMODEL_ROOT}/{conf.data.name}/{conf.sp_model}')
    gen_path = f'{FAIRSEQ_ROOT}/workplace/generation/{conf.data.name}/{conf.data.type}/{conf.model.name}{conf.checkpoint}'

    files = ['system_output.txt', 'reference.txt']

    for file in files:
        with open(f'{gen_path}/{file}') as f:
            lines = f.readlines()
        with open(f'{gen_path}/{file}.dtk', 'w') as f:
            for i, l in enumerate(lines, 1):
                print(f'{i}/{len(lines)}', end='\r')
                idx, *pieces = l.strip().split(None)
                sent = sp.DecodePieces(pieces)
                f.write(f'{idx} {sent}\n')

