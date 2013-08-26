autobench
=========

`autobench` is a framework to compare the performance of Go 1.1 and Go tip.

usage
-----

`autobench` downloads and builds the latest Go 1.1 and Go tip branches and runs a set of Go 1 benchmarks for comparison.

Useful targets are
	
    make bench		# runs all benchmarks, _once_
    make go1 		# runs bench/go1 benchmarks _once_
    make runtime 	# runs bench/runtime benchmarks _once_
    make http	 	# runs bench/http benchmarks _once_
    make clean 		# removes any previous benchmark results
    make update		# updates both branches to the latest revision, clears any benchmark results

You can optionally benchmark with gccgo instead of gc by either uncommenting the corresponding line in the Makefile or by setting TESTFLAGS to an appropriate value:

    make TESTFLAGS=-compiler=gcc bench

contributing
------------

Contributions and pull requests are always welcome. If you are submitting a pull request with benchmark data, please include the value of

    hg id work/go.11

and

    hg id work/go.tip

in the suffix of your file (follow the examples) so we can trace which revision this benchmark was taken from. If you want to include commentry in your benchmark, comments should start with a #.

licence
-------

This package uses benchmark code from the Go project. Where otherwise unspecified this code is released into the public domain.
