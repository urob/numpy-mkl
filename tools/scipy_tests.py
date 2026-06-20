import os
import sys

# Guard required: on Windows multiprocessing.Pool uses 'spawn', which reimports
# __main__ in each worker. Without this guard the workers would re-execute
# scipy.test(), causing recursive test runs and a deadlock in test_pool.
if __name__ == '__main__':
    import scipy

    # Exclude tests with known MKL-specific numerical precision failures.
    # Use -k (name-based filter) rather than --deselect (path-based): passing
    # --deselect with a scipy/ path triggers early path resolution by pytest,
    # which initializes MKL threads before test_pool's fork() and deadlocks.
    extra_args = []

    match os.environ.get('RUNNER_OS'):
        case 'Windows':
            # test_gh22705: j0 for large arguments; MKL intercepts sin/cos at
            # runtime and its range reduction for x=1e15/1e30 doesn't meet the
            # rtol=5e-15 tolerance.
            extra_args += ['-k', 'not test_gh22705']
        case 'Linux':
            # test_support_moments_sample: MKL computes a Normal moment as exact
            # 0.0 vs ~3e-9, just exceeding the atol=2e-09 tolerance.
            extra_args += ['-k', 'not test_support_moments_sample']

    passed = scipy.test(extra_argv=extra_args or None)
    sys.exit(not passed)
