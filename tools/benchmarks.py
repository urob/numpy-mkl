import argparse
import inspect
import sys
from pathlib import Path
from timeit import Timer

import scipy

import numpy as np

parser = argparse.ArgumentParser(description='Run NumPy and SciPy benchmarks')
parser.add_argument('--self-tune', action='store_true', help='Tune the benchmark sizes')
parser.add_argument('-o', '--out-file', help='Output file for the results')

args = parser.parse_args()
out_file = Path(args.out_file) if args.out_file else None

fmt = '{name:<10}: {time:.4f}s ({loops:4d} loops)'


class Benchmark:
    def run(self, results=None, verbose=True, **kwargs):
        lbls = 'sml', 'med', 'lrg'
        for size, loops, lbl in zip(self.size, self.loops, lbls):
            best = self.run_single(size, loops, **kwargs)
            name = self.__class__.__name__ + f'({lbl})'
            if results is not None:
                results[name] = best
            if verbose:
                print(fmt.format(name=name, time=best, loops=loops))

    def run_single(self, size, loops, repeat=5, warmup=True):
        self.setup(size)
        if warmup:
            self.time_it()

        t = Timer(lambda: self.time_it())
        return min(t.repeat(repeat=repeat, number=loops))


class Chol(Benchmark):
    size = (21, 144, 987)
    loops = (2_500, 50, 1)

    def setup(self, k):
        rng = np.random.default_rng(1)
        tl = np.tri(k, k, -1)
        tl[tl > 0] = rng.random(k * (k - 1) // 2)
        self.x = tl + tl.T + (k - 1) * np.eye(k)

    def time_it(self):
        _ = np.linalg.svd(self.x)


class Det(Benchmark):
    size = (89, 987, 4181)
    loops = (2_500, 50, 1)

    def setup(self, k):
        rng = np.random.default_rng(1)
        self.x = rng.random((k, k))

    def time_it(self):
        _ = np.linalg.slogdet(self.x)


class Dot(Benchmark):
    size = (144, 610, 2584)
    loops = (2_500, 50, 1)

    def setup(self, k):
        rng = np.random.default_rng(1)
        self.x = rng.random((k, k))
        self.y = rng.random((k, k))

    def time_it(self):
        _ = np.dot(self.x, self.y)


class Eig(Benchmark):
    size = (21, 89, 610)
    loops = (2_500, 50, 1)

    def setup(self, k):
        rng = np.random.default_rng(1)
        self.x = rng.random((k, k))

    def time_it(self):
        _ = np.linalg.eig(self.x)


class Inv(Benchmark):
    size = (55, 610, 2584)
    loops = (2_500, 50, 1)

    def setup(self, k):
        rng = np.random.default_rng(1)
        self.x = rng.random((k, k))

    def time_it(self):
        _ = np.linalg.inv(self.x)


class LU(Benchmark):
    size = (55, 610, 2584)
    loops = (2_500, 50, 1)

    def setup(self, k):
        rng = np.random.default_rng(1)
        self.x = rng.random((k, k))

    def time_it(self):
        _ = scipy.linalg.lu(self.x)


class QR(Benchmark):
    size = (34, 377, 1597)
    loops = (2_500, 50, 1)

    def setup(self, k):
        rng = np.random.default_rng(1)
        self.x = rng.standard_normal((k, k))

    def time_it(self):
        _ = np.linalg.qr(self.x)


class SVD(Benchmark):
    size = (21, 144, 987)
    loops = (2_500, 50, 1)

    def setup(self, k):
        rng = np.random.default_rng(1)
        self.x = rng.random((k, k))

    def time_it(self):
        _ = np.linalg.svd(self.x)


class Solve(Benchmark):
    size = (89, 987, 4181)
    loops = (2_500, 50, 1)

    def setup(self, k):
        rng = np.random.default_rng(1)
        self.x = rng.random((k, k))
        self.y = rng.random((k, 1))

    def time_it(self):
        _ = np.linalg.solve(self.x, self.y)


class TuneBenchmark:
    # We want an exponential scheme to account for the exponential increase in
    # complexity. We also want to have a small enough base to stay close to the
    # target time. The Fibonacci sequence works pretty well (which converges to
    # an exponential with base of 1.618).
    sizes = (8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765)

    def __init__(self, benchmark, target_time=0.2):
        self.benchmark = benchmark
        self.target_time = target_time

        size = [self.run(loops) for loops in benchmark.loops]
        self.write(tuple(size))

    def write(self, size):
        file = Path(__file__)
        with file.open() as f:
            lines = f.readlines()
        pattern = f'class {self.benchmark.__name__}(Benchmark):'
        n = next(_ for _, line in enumerate(lines) if line.startswith(pattern))
        lines[n + 1] = f'    size = {size}\n'
        with file.open('w') as f:
            f.writelines(lines)

    def run(self, loops):
        t = np.zeros(len(self.sizes))
        for n, size in enumerate(self.sizes):
            t[n] = self.benchmark().run_single(size, loops)
            if t[n] > self.target_time:
                break
        idx = abs(t - self.target_time).argmin()
        name = self.benchmark.__name__ + f'({self.sizes[idx]})'
        print(fmt.format(name=name, time=t[idx], loops=loops))
        return self.sizes[idx]


def get_benchmarks():
    cls = inspect.getmembers(sys.modules[__name__], inspect.isclass)
    return [c for _, c in cls if issubclass(c, Benchmark) and c is not Benchmark]


if __name__ == '__main__':
    if args.self_tune:
        for b in get_benchmarks():
            TuneBenchmark(b)

    else:
        results = {}
        for b in get_benchmarks():
            b().run(results=results)

        print('\nTotal runtime: {:.4f}s'.format(sum(results.values())))

        if out_file:
            with out_file.open('w') as f:
                for k, v in results.items():
                    f.write(f'{v}\n')
