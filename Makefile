TOP=$(shell pwd)
WORK=$(TOP)/work
GO_CHECKOUT=$(WORK)/go
GO_103_ROOT=$(GO_CHECKOUT).103
GO_103_BIN=$(GO_103_ROOT)/bin/go
GO_TIP_ROOT=$(GO_CHECKOUT).tip
GO_TIP_BIN=$(GO_TIP_ROOT)/bin/go
GOPATH=$(TOP)

BENCHCMP=$(GO_TIP_ROOT)/misc/benchcmp

unexport GOROOT

bench: $(WORK)/go-103.txt $(WORK)/go-tip.txt
	$(BENCHCMP) $^

$(GO_CHECKOUT):
	hg clone https://code.google.com/p/go $(GO_CHECKOUT)

$(GO_103_ROOT): $(GO_CHECKOUT)
	hg clone -b release-branch.go1 $(GO_CHECKOUT) $@

$(GO_103_BIN): $(GO_103_ROOT)
	cd $(GO_103_ROOT)/src ; ./make.bash

$(WORK)/go-103.txt: $(GO_103_BIN)
	$(GO_103_BIN) test -bench=. bench/go1 > $@

$(GO_TIP_ROOT): $(GO_CHECKOUT)
	hg clone -r tip $(GO_CHECKOUT) $@

$(GO_TIP_BIN): $(GO_TIP_ROOT)
	cd $(GO_TIP_ROOT)/src ; ./make.bash

$(WORK)/go-tip.txt: $(GO_TIP_ROOT)
	$(GO_TIP_BIN) test -bench=. bench/go1 > $@

clean:	
	rm $(WORK)/*.txt
