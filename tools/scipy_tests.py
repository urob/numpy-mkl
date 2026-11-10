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
            # TestSphHarm: sph_harm_y_all and sph_harm_y disagree by up to 3e-4
            # relative on values of order 1e-20, where the two recurrences and
            # MKL's sin/cos cancel differently. Filter on the class rather than
            # test_all, which as a substring would match unrelated tests.
            extra_args += ['-k', 'not test_gh22705 and not TestSphHarm']
        case 'Linux':
            # test_support_moments_sample: MKL computes a Normal moment as exact
            # 0.0 vs ~3e-9, just exceeding the atol=2e-09 tolerance.
            # test_decomp_cossin::test_properties: compares two cossin calls on
            # the same input with rtol=1e-15; MKL isn't bitwise reproducible
            # across calls (alignment-dependent code paths), giving ~1e-16 diffs
            # on the m=20 cases (seen on cp315t). Scoped to the module since
            # other scipy tests are also named test_properties.
            extra_args += [
                '-k',
                'not test_support_moments_sample'
                ' and not (test_decomp_cossin and test_properties)',
            ]

    passed = scipy.test(extra_argv=extra_args or None)
    sys.exit(not passed)
