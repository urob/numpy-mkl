import os
import sys
from pathlib import Path

import numpy as np

np.show_config()

if os.environ['RUNNER_OS'] == 'Windows':
    # GH 20391
    libs = Path(sys.prefix) / 'libs'
    libs.mkdir(parents=True, exist_ok=True)

# Use same memory when running tests as upstream. This means we'll skip
# the same tests due to memory limitations.
os.environ['NPY_AVAILABLE_MEM'] = '4 GB'

# HACK: Disable timeout for NumPy 2.1 and earlier. Will fail with rc candidates.
ver = tuple(map(int, np.version.version.split('.')))
if ver >= (2, 2, 0):
    passed = np.test(label='full', extra_argv=['-n=auto', '--timeout=1800'])
else:
    passed = np.test(label='full', extra_argv=['-n=auto'])
sys.exit(not passed)
