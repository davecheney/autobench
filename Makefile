TOP  := $(shell pwd)
WORK := $(TOP)/work

# set these two values to the tags (or revisions) you wish to compare
OLD  := go1.1.2
NEW  := go1.2rc3

GO_CHECKOUT=$(WORK)/go
GO_OLD_ROOT=$(WORK)/$(OLD)
GO_OLD_BIN=$(GO_OLD_ROOT)/bin/go
GO_NEW_ROOT=$(WORK)/$(NEW)
GO_NEW_BIN=$(GO_NEW_ROOT)/bin/go

GO1_BENCH=$(GO_NEW_ROOT)/test/bench/go1

# uncomment to benchmark with gccgo
# TESTFLAGS=-compiler=gccgo

BENCHCMP=$(GO_CHECKOUT)/misc/benchcmp

# setup our benchmarking environment
GOPATH=$(TOP)
export GOPATH
unexport GOROOT GOBIN

bench: go1 runtime http floats megajson

go1: $(WORK)/go1-$(OLD).txt $(WORK)/go1-$(NEW).txt
	@echo "# go1"
	@$(BENCHCMP) $^

runtime: $(WORK)/runtime-$(OLD).txt $(WORK)/runtime-$(NEW).txt
	@echo "# runtime"
	@$(BENCHCMP) $^

http: $(WORK)/http-$(OLD).txt $(WORK)/http-$(NEW).txt
	@echo "# http"
	@$(BENCHCMP) $^

floats: $(WORK)/floats-$(OLD).txt $(WORK)/floats-$(NEW).txt
	@echo "# floats"
	@$(BENCHCMP) $^

megajson: $(WORK)/megajson-$(OLD).txt $(WORK)/megajson-$(NEW).txt
	@echo "#megajson"
	@$(BENCHCMP) $^

update-$(GO_CHECKOUT): $(GO_CHECKOUT)
	hg pull --cwd $(GO_CHECKOUT) -u

update: update-$(GO_CHECKOUT) $(GO_OLD_ROOT) $(GO_NEW_ROOT)
	hg pull --cwd $(GO_OLD_ROOT) -u
	hg pull --cwd $(GO_NEW_ROOT) -u
	rm -rf $(GO_OLD_ROOT)/bin $(GO_NEW_ROOT)/bin
	rm -f $(WORK)/*.txt

$(GO_CHECKOUT): 
	hg clone https://code.google.com/p/go $@

$(GO_OLD_ROOT): $(GO_CHECKOUT)
	hg clone -r $(OLD) $(GO_CHECKOUT) $@

$(GO_OLD_BIN): $(GO_OLD_ROOT)
	cd $(GO_OLD_ROOT)/src ; ./make.bash

$(GO_NEW_ROOT): $(GO_CHECKOUT)
	hg clone -r tip $(GO_CHECKOUT) $@

$(GO_NEW_BIN): $(GO_NEW_ROOT)
	cd $(GO_NEW_ROOT)/src ; ./make.bash

$(GO1_BENCH): $(GO_NEW_ROOT)

$(WORK)/go1-$(OLD).txt: $(GO_OLD_BIN) $(GO1_BENCH)
	cd $(GO1_BENCH) && $(GO_OLD_BIN) test $(TESTFLAGS) -bench=. > $@

$(WORK)/go1-$(NEW).txt: $(GO_NEW_BIN) $(GO1_BENCH)
	cd $(GO1_BENCH) && $(GO_NEW_BIN) test $(TESTFLAGS) -bench=. > $@

$(WORK)/runtime-$(OLD).txt: $(GO_OLD_BIN)
	$(GO_OLD_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/runtime > $@

$(WORK)/runtime-$(NEW).txt: $(GO_NEW_BIN)
	$(GO_NEW_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/runtime > $@

$(WORK)/http-$(OLD).txt: $(GO_OLD_BIN)
	$(GO_OLD_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/http > $@

$(WORK)/http-$(NEW).txt: $(GO_NEW_BIN)
	$(GO_NEW_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/http > $@

$(WORK)/floats-$(OLD).txt: $(GO_OLD_BIN)
	$(GO_OLD_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/floats > $@

$(WORK)/floats-$(NEW).txt: $(GO_NEW_BIN)
	$(GO_NEW_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/floats > $@

$(WORK)/megajson-$(OLD).txt: $(GO_OLD_BIN)
	$(GO_OLD_BIN) get -u -v -d github.com/benbjohnson/megajson
	$(GO_OLD_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. github.com/benbjohnson/megajson/bench > $@

$(WORK)/megajson-$(NEW).txt: $(GO_NEW_BIN)
	$(GO_OLD_BIN) get -u -v -d github.com/benbjohnson/megajson
	$(GO_NEW_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. github.com/benbjohnson/megajson/bench > $@

clean:	
	rm -f $(WORK)/*.txt
