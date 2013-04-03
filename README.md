autobench
=========

`autobench` is a framework to compare the performance of go 1.0 (go 1.0.3) and go 1.1 (go +tip).

usage
-----

`autobench` downloads and builds Go 1.0.3 and Go tip and runs a set of Go 1 benchmarks for comparison.

Useful targets are

    make go1 		# runs bench/go1 benchmarks _once_
    make runtime 	# runs bench/runtime benchmarks _once_
    make clean 		# removes any previous benchmark results
    make update		# updates the go.tip version to the latest revision, clears any benchmark results


licence
-------

This package uses benchmark code from the Go project. Where otherwise unspecified this code is released into the public domain.
