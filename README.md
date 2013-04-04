autobench
=========

`autobench` is a framework to compare the performance of go 1.0 (go 1.0.3) and go 1.1 (go +tip).

usage
-----

`autobench` downloads and builds Go 1.0.3 and Go tip and runs a set of Go 1 benchmarks for comparison.

Useful targets are
	
    make bench		# runs all benchmarks, _once_
    make go1 		# runs bench/go1 benchmarks _once_
    make runtime 	# runs bench/runtime benchmarks _once_
    make clean 		# removes any previous benchmark results
    make update		# updates the go.tip version to the latest revision, clears any benchmark results

notes
-----

There are several caveats to benchmarking last year's Go with tip

 * If you are benchmarking on an arm platform, remember that there was no automatic detection for GOARM, so you will have to set it yourself. See the [GoARM wiki page](https://code.google.com/p/go-wiki/wiki/GoArm) for more details

contributing
------------

Contributions and pull requests are always welcome. If you are submitting a pull request with benchmark data, please include the value of

    hg id work/go.tip

in the suffix of your file (follow the examples) so we can trace which revision this benchmark was taken from.

licence
-------

This package uses benchmark code from the Go project. Where otherwise unspecified this code is released into the public domain.
