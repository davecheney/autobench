TOP = $(shell pwd)
WORK=$(TOP)/work
GO_CHECKOUT=$(WORK)/go
GO_103_ROOT=$(WORK)/go.103
GO_103_BIN=$(GO_103_ROOT)/bin/go
GO_TIP_ROOT=$(WORK)/go.tip
GO_TIP_BIN=$(GO_TIP_ROOT)/bin/go
GOPATH=$(TOP)

BENCHCMP=$(GO_TIP_ROOT)/misc/benchcmp

unexport GOROOT

bench: setup
	TMPDIR=$(WORK)
	OLD=$(shell mktemp -t autobench )
	$(GO_103_BIN) test -bench=. bench/go1 >/tmp/old.txt
	NEW=$(shell mktemp -t autobench )
	$(GO_TIP_BIN) test -bench=. bench/go1 >/tmp/new.txt
	$(BENCHCMP) /tmp/old.txt /tmp/new.txt

setup: $(GO_103_BIN) $(GO_TIP_BIN)

$(GO_CHECKOUT):
	hg clone https://code.google.com/p/go $(GO_CHECKOUT)

$(GO_103_ROOT): $(GO_CHECKOUT)
	hg clone -b release-branch.go1 $(GO_CHECKOUT) $@

$(GO_103_BIN): $(GO_103_ROOT)
	cd $(GO_103_ROOT)/src ; ./make.bash

$(GO_TIP_ROOT): $(GO_CHECKOUT)
	hg clone -r tip $(GO_CHECKOUT) $@

$(GO_TIP_BIN): $(GO_TIP_ROOT)
	cd $(GO_TIP_ROOT)/src ; ./make.bash

clean:	
	rm -rf $(GO_103_BIN) $(GO_TIP_BIN)
	cd $(GO_103_ROOT)/src ; ./clean.bash
	cd $(GO_TIP_ROOT)/src ; ./clean.bash
