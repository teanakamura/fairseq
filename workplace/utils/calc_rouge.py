import argparse
import numpy as np
from sumeval.metrics.rouge import RougeCalculator
#from utils import process_bpe_symbol


def read_file(filename, bpe_symbol=None):
  with open(filename) as f:
    # lines = [process_bpe_symbol(line.strip(), bpe_symbol) for line in f]
    # lines = [l.split() for l in f]
    # from IPython import embed; embed()
    return f.readlines()


def main(args):
  system_out_list = read_file(args.system_out, args.remove_bpe)
  reference_list = read_file(args.reference, args.remove_bpe)
  rouge4one = RougeCalculator(stopwords=True, lang=args.lang)
  rouge4other = RougeCalculator(stopwords=False, lang=args.lang)
  rougeone_list = []
  rougetwo_list = []
  rougel_list = []
  for index, snt in enumerate(system_out_list):
    rougeone_list.append(rouge4one.rouge_1(summary=snt, references=reference_list[index], alpha=args.alpha))
    rougetwo_list.append(rouge4other.rouge_2(summary=snt, references=reference_list[index], alpha=args.alpha))
    rougel_list.append(rouge4one.rouge_l(summary=snt, references=reference_list[index], alpha=args.alpha))
  print('ROUGE-1\t%.6f'%(np.average(rougeone_list)))
  print('ROUGE-2\t%.6f'%(np.average(rougetwo_list)))
  print('ROUGE-L\t%.6f'%(np.average(rougel_list)))


if __name__ == "__main__":
  data_path = '../generation/cnndm_small/insertion_transformer_tau/'
  #data_path = '../generation/cnndm_small/insertion_transformer_tau/'
  #data_path = '../generation/cnndm_small/insertion_transformer_tau/'
#data_path = '../generation/cnndm/small/insertion_transformer_fw_tau_best/'
#data_path = '../generation/wmt14/'
  parser = argparse.ArgumentParser()
  parser.add_argument('-s', '--system', dest='system_out',
      default=data_path+'system_output.txt',
      help='specify the system output file name')
  parser.add_argument('-r', '--reference', dest='reference',
      default=data_path+'reference.txt',
      help='specify the reference file name')
  parser.add_argument('-l', '--lang', default='en')
  parser.add_argument('--alpha', type=float, default=0.5)
  parser.add_argument('--remove-bpe', default=None)
  args = parser.parse_args()
  main(args)
