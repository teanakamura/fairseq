from os.path import expanduser
home = expanduser("~") + '/'
source_dir = home + 'Data/cnndm-pj/'
dest_dir = home + 'Data/cnndm-pj/cnndm/'
delimiter = '<summ-content>'
modes = ['test', 'val', 'train']

for mode in modes:
  source = source_dir + mode + '.txt'
  dest_sum = dest_dir + mode + '.sum'
  dest_doc = dest_dir + mode + '.doc'

  with open(source) as so, open(dest_sum, 'w') as ds, open(dest_doc, 'w') as dd:
    for i, l in enumerate(so):
      s, d = l.split(delimiter)
      ds.write('<BOS> ' + s + '\n')
      dd.write(d)
