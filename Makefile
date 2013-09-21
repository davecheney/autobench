TOP=$(shell pwd)
WORK=$(TOP)/work
GO_CHECKOUT=$(WORK)/go
GO_11_ROOT=$(GO_CHECKOUT).11
GO_11_BIN=$(GO_11_ROOT)/bin/go
GO_TIP_ROOT=$(GO_CHECKOUT).tip
GO_TIP_BIN=$(GO_TIP_ROOT)/bin/go

# uncomment to benchmark with gccgo
# TESTFLAGS=-compiler=gccgo

BENCHCMP=$(GO_11_ROOT)/misc/benchcmp

# setup our benchmarking environment
GOPATH=$(TOP)
export GOPATH
unexport GOROOT GOBIN

bench: go1 runtime http floats

go1: $(WORK)/go1-11.txt $(WORK)/go1-tip.txt
	$(BENCHCMP) $^

runtime: $(WORK)/runtime-11.txt $(WORK)/runtime-tip.txt
	$(BENCHCMP) $^

http: $(WORK)/http-11.txt $(WORK)/http-tip.txt
	$(BENCHCMP) $^

floats: $(WORK)/floats-11.txt $(WORK)/floats-tip.txt
	$(BENCHCMP) $^

update: $(GO_CHECKOUT) $(GO_11_ROOT) $(GO_TIP_ROOT)
	hg pull --cwd $(GO_CHECKOUT) -u
	hg pull --cwd $(GO_11_ROOT) -u
	hg pull --cwd $(GO_TIP_ROOT) -u
	rm -rf $(GO_11_ROOT)/bin $(GO_TIP_ROOT)/bin
	rm -f $(WORK)/*.txt

$(GO_CHECKOUT):
	hg clone https://code.google.com/p/go $@

$(GO_11_ROOT): $(GO_CHECKOUT)
	hg clone -b release-branch.go1.1 $(GO_CHECKOUT) $@

$(GO_11_BIN): $(GO_11_ROOT)
	cd $(GO_11_ROOT)/src ; ./make.bash

$(GO_TIP_ROOT): $(GO_CHECKOUT)
	hg clone -r tip $(GO_CHECKOUT) $@

$(GO_TIP_BIN): $(GO_TIP_ROOT)
	cd $(GO_TIP_ROOT)/src ; ./make.bash

$(WORK)/go1-11.txt: $(GO_11_BIN)
	$(GO_11_BIN) test $(TESTFLAGS) -bench=. bench/go1 > $@

$(WORK)/go1-tip.txt: $(GO_TIP_BIN)
	$(GO_TIP_BIN) test $(TESTFLAGS) -bench=. bench/go1 > $@

$(WORK)/runtime-11.txt: $(GO_11_BIN)
	$(GO_11_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/runtime > $@

$(WORK)/runtime-tip.txt: $(GO_TIP_BIN)
	$(GO_TIP_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/runtime > $@

$(WORK)/http-11.txt: $(GO_11_BIN)
	$(GO_11_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/http > $@

$(WORK)/http-tip.txt: $(GO_TIP_BIN)
	$(GO_TIP_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/http > $@

$(WORK)/floats-11.txt: $(GO_11_BIN)
	$(GO_11_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/floats > $@

$(WORK)/floats-tip.txt: $(GO_TIP_BIN)
	$(GO_TIP_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/floats > $@

clean:	
	rm -f $(WORK)/*.txt
