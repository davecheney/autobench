TOP=$(shell pwd)
WORK=$(TOP)/work
GO_CHECKOUT=$(WORK)/go
GO_103_ROOT=$(GO_CHECKOUT).103
GO_103_BIN=$(GO_103_ROOT)/bin/go
GO_TIP_ROOT=$(GO_CHECKOUT).tip
GO_TIP_BIN=$(GO_TIP_ROOT)/bin/go

BENCHCMP=$(GO_TIP_ROOT)/misc/benchcmp

# setup our benchmarking environment
GOPATH=$(TOP)
export GOPATH
unexport GOROOT

bench: go1 runtime

go1: $(WORK)/go1-103.txt $(WORK)/go1-tip.txt
	$(BENCHCMP) $^

runtime: $(WORK)/runtime-103.txt $(WORK)/runtime-tip.txt
	$(BENCHCMP) $^

http: $(WORK)/http-103.txt $(WORK)/http-tip.txt
	$(BENCHCMP) $^

update: $(GO_TIP_ROOT) 
	hg pull --cwd $(GO_CHECKOUT)
	hg pull --cwd $(GO_TIP_ROOT) -u
	rm -rf $(GO_TIP_ROOT)/bin
	rm -f $(WORK)/*tip.txt

$(GO_CHECKOUT):
	hg clone https://code.google.com/p/go $@

$(GO_103_ROOT): $(GO_CHECKOUT)
	hg clone -b release-branch.go1 $(GO_CHECKOUT) $@
	hg import --cwd $@ --no-commit $(TOP)/patches/6501099.diff

$(GO_TIP_ROOT): $(GO_CHECKOUT)
	hg clone -r tip $(GO_CHECKOUT) $@

$(GO_103_BIN): $(GO_103_ROOT)
	cd $(GO_103_ROOT)/src ; ./make.bash

$(GO_TIP_BIN): $(GO_TIP_ROOT)
	cd $(GO_TIP_ROOT)/src ; ./make.bash

$(WORK)/go1-103.txt: $(GO_103_BIN)
	$(GO_103_BIN) test -bench=. bench/go1 > $@

$(WORK)/go1-tip.txt: $(GO_TIP_BIN)
	$(GO_TIP_BIN) test -bench=. bench/go1 > $@

$(WORK)/runtime-103.txt: $(GO_103_BIN)
	$(GO_103_BIN) test -test.run=XXX -test.bench=. bench/runtime > $@

$(WORK)/runtime-tip.txt: $(GO_TIP_BIN)
	$(GO_TIP_BIN) test -test.run=XXX -test.bench=. bench/runtime > $@

$(WORK)/http-103.txt: $(GO_103_BIN)
	$(GO_103_BIN) test -test.run=XXX -test.bench=. bench/http > $@

$(WORK)/http-tip.txt: $(GO_TIP_BIN)
	$(GO_TIP_BIN) test -test.run=XXX -test.bench=. bench/http > $@

clean:	
	rm -f $(WORK)/*.txt
