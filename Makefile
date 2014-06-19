TOP  := $(shell pwd)
WORK := $(TOP)/work

# set these two values to the tags (or revisions) you wish to compare
OLD  := go1.2.2
NEW  := go1.3

GO_CHECKOUT=$(WORK)/go
GO_OLD_ROOT=$(WORK)/$(OLD)
GO_OLD_BIN=$(GO_OLD_ROOT)/bin/go
GO_NEW_ROOT=$(WORK)/$(NEW)
GO_NEW_BIN=$(GO_NEW_ROOT)/bin/go

GO1_BENCH=$(GO_NEW_ROOT)/test/bench/go1

# uncomment to benchmark with gccgo
# TESTFLAGS=-compiler=gccgo

all: bench

# setup our benchmarking environment
GOPATH=$(TOP)
export GOPATH
unexport GOROOT GOBIN

BENCHCMP=$(TOP)/bin/benchcmp

bench: go1 runtime http floats cipher megajson snappy
extra: bench bytes strings goquery

go1: $(WORK)/go1-$(OLD).txt $(WORK)/go1-$(NEW).txt $(BENCHCMP)
	@echo "# go1"
	@$(BENCHCMP) $(WORK)/go1-$(OLD).txt $(WORK)/go1-$(NEW).txt

runtime: $(WORK)/runtime-$(OLD).txt $(WORK)/runtime-$(NEW).txt $(BENCHCMP)
	@echo "# runtime"
	@$(BENCHCMP) $(WORK)/runtime-$(OLD).txt $(WORK)/runtime-$(NEW).txt

bytes: $(WORK)/bytes-$(OLD).txt $(WORK)/bytes-$(NEW).txt $(BENCHCMP)
	@echo "# bytes"
	@$(BENCHCMP) $(WORK)/bytes-$(OLD).txt $(WORK)/bytes-$(NEW).txt

cipher: $(WORK)/cipher-$(OLD).txt $(WORK)/cipher-$(NEW).txt $(BENCHCMP)
	@echo "# cipher"
	@$(BENCHCMP) $(WORK)/cipher-$(OLD).txt $(WORK)/cipher-$(NEW).txt

strings: $(WORK)/strings-$(OLD).txt $(WORK)/strings-$(NEW).txt $(BENCHCMP)
	@echo "# strings"
	@$(BENCHCMP) $(WORK)/strings-$(OLD).txt $(WORK)/strings-$(NEW).txt

http: $(WORK)/http-$(OLD).txt $(WORK)/http-$(NEW).txt $(BENCHCMP)
	@echo "# http"
	@$(BENCHCMP) $(WORK)/http-$(OLD).txt $(WORK)/http-$(NEW).txt

floats: $(WORK)/floats-$(OLD).txt $(WORK)/floats-$(NEW).txt $(BENCHCMP)
	@echo "# floats"
	@$(BENCHCMP) $(WORK)/floats-$(OLD).txt $(WORK)/floats-$(NEW).txt

megajson: $(WORK)/megajson-$(OLD).txt $(WORK)/megajson-$(NEW).txt $(BENCHCMP)
	@echo "#megajson"
	@$(BENCHCMP) $(WORK)/megajson-$(OLD).txt $(WORK)/megajson-$(NEW).txt

snappy: $(WORK)/snappy-$(OLD).txt $(WORK)/snappy-$(NEW).txt $(BENCHCMP)
	@echo "#snappy"
	@$(BENCHCMP) $(WORK)/snappy-$(OLD).txt $(WORK)/snappy-$(NEW).txt

goquery: $(WORK)/goquery-$(OLD).txt $(WORK)/goquery-$(NEW).txt $(BENCHCMP)
	@echo "#goquery"
	@$(BENCHCMP) $(WORK)/goquery-$(OLD).txt $(WORK)/goquery-$(NEW).txt

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

$(BENCHCMP): $(GO_NEW_BIN)
	cd $(GO_NEW_ROOT); ./bin/go get code.google.com/p/go.tools/cmd/benchcmp

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

$(WORK)/cipher-$(OLD).txt: $(GO_OLD_BIN)
	$(GO_OLD_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/cipher > $@

$(WORK)/cipher-$(NEW).txt: $(GO_NEW_BIN)
	$(GO_NEW_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/cipher > $@

$(WORK)/bytes-$(OLD).txt: $(GO_OLD_BIN)
	$(GO_OLD_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bytes > $@

$(WORK)/bytes-$(NEW).txt: $(GO_NEW_BIN)
	$(GO_NEW_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bytes > $@

$(WORK)/strings-$(OLD).txt: $(GO_OLD_BIN)
	$(GO_OLD_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. strings > $@

$(WORK)/strings-$(NEW).txt: $(GO_NEW_BIN)
	$(GO_NEW_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. strings > $@

$(WORK)/floats-$(OLD).txt: $(GO_OLD_BIN)
	$(GO_OLD_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/floats > $@

$(WORK)/floats-$(NEW).txt: $(GO_NEW_BIN)
	$(GO_NEW_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. bench/floats > $@

$(WORK)/megajson-$(OLD).txt: $(GO_OLD_BIN)
	$(GO_OLD_BIN) get -u -v -d github.com/benbjohnson/megajson
	cd $(GOPATH)/src/github.com/benbjohnson/megajson/.bench && $(GO_OLD_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. . > $@

$(WORK)/megajson-$(NEW).txt: $(GO_NEW_BIN)
	$(GO_NEW_BIN) get -u -v -d github.com/benbjohnson/megajson
	cd $(GOPATH)/src/github.com/benbjohnson/megajson/.bench && $(GO_OLD_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench=. . > $@

$(WORK)/snappy-$(OLD).txt: $(GO_OLD_BIN)
	$(GO_OLD_BIN) get -u -v -d code.google.com/p/snappy-go/snappy
	$(GO_OLD_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench='.*'. code.google.com/p/snappy-go/snappy > $@

$(WORK)/snappy-$(NEW).txt: $(GO_NEW_BIN)
	$(GO_NEW_BIN) get -u -v -d code.google.com/p/snappy-go/snappy
	$(GO_NEW_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench='.*' code.google.com/p/snappy-go/snappy > $@

$(WORK)/goquery-$(OLD).txt: $(GO_OLD_BIN)
	$(GO_OLD_BIN) get -u -v -d github.com/PuerkitoBio/goquery
	$(GO_OLD_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench='.*'. github.com/PuerkitoBio/goquery > $@

$(WORK)/goquery-$(NEW).txt: $(GO_NEW_BIN)
	$(GO_NEW_BIN) get -u -v -d github.com/PuerkitoBio/goquery
	$(GO_NEW_BIN) test $(TESTFLAGS) -test.run=XXX -test.bench='.*' github.com/PuerkitoBio/goquery > $@

clean:	
	rm -f $(WORK)/*.txt

.PHONEY: $(BENCHCMP) tip
