#!/usr/local/opt/python/bin/python3.7
# -*- coding: utf-8 -*-
import re
import sys
from os import path
fairseq_path = path.abspath(path.join(path.abspath(__file__), '../../fairseq'))
sys.path.insert(0, fairseq_path)
from fairseq_cli.train import cli_main

if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw?|\.exe)?$', '', sys.argv[0])
    sys.exit(cli_main())
