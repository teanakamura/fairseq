import re
import sys
import os
from os import path
sys.path.insert(0, path.join(path.dirname(os.getcwd()), 'fairseq'))
from fairseq_cli.preprocess import cli_main

if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw?|\.exe)?$', '', sys.argv[0])
    sys.exit(cli_main())
