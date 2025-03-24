import sys

import numpy as np

np.show_config()

passed = np.test(
    label='full', extra_argv=['-n=auto', '--timeout=1800', '--durations=10']
)
sys.exit(not passed)
