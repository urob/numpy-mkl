import timeit

from scipy import linalg

import numpy as np

fmt = '{name:<30} {time:.4f}s ({number:6d} loops)'


class Benchmark:
    def run(self, repeat=5):
        for param, number in zip(self.params, self.numbers):
            self.setup(param)

            t = timeit.Timer(lambda: self.time_it())
            best = min(t.repeat(repeat=repeat, number=number))

            name = self.__class__.__name__ + f'({param})'
            print(fmt.format(name=name, time=best, number=number))


class DotProductBenchmark(Benchmark):
    params = (10, 100, 1000)
    numbers = (100_000, 5_000, 20)

    def setup(self, k):
        self.x = np.random.rand(k, k)
        self.y = np.random.rand(k, k)

    def time_it(self):
        np.dot(self.x, self.y)


class LinalgSolveBenchmark(Benchmark):
    params = (10, 100, 1000)
    numbers = (10_000, 1_000, 5)

    def setup(self, k):
        self.x = np.random.rand(k, k)
        self.y = np.random.rand(k, k)

    def time_it(self):
        np.linalg.solve(self.x, self.y)


class SciPyLinalgInvBenchmark(Benchmark):
    params = (10, 100, 1000)
    numbers = (10_000, 500, 5)

    def setup(self, k):
        self.x = np.random.rand(k, k)

    def time_it(self):
        linalg.inv(self.x)


if __name__ == '__main__':
    np.random.seed(42)

    DotProductBenchmark().run()
    LinalgSolveBenchmark().run()
    SciPyLinalgInvBenchmark().run()
