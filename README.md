autobench
=========

`autobench` is a framework to compare the performance of go 1.0 (go 1.0.3) and go 1.1 (go +tip).

usage
-----

`autobench` downloads and builds Go 1.0.3 and Go tip and runs a set of Go 1 benchmarks for comparison.

Useful targets are

    make bench  	# runs the benchmarks _once_ 
    make clean 		# removes any previous benchmark results
    make update		# updates the go.tip version to the latest revision, clears any benchmark results
