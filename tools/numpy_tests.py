import os
import sys
from pathlib import Path

import numpy as np

np.show_config()

if os.environ['RUNNER_OS'] == 'Windows':
    # GH 20391
    libs = Path(sys.prefix) / 'libs'
    libs.mkdir(parents=True, exist_ok=True)

passed = np.test(
    label='full', extra_argv=['-n=auto', '--timeout=1800', '--durations=10']
)
sys.exit(not passed)
