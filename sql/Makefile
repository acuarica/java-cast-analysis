
include ../Makefile.local

OUTS=$(patsubst %.sql,%.out,$(wildcard *.sql))

all: $(OUTS)

%.out: %.sql
	cat $< | $(SQLITE) $(SQLITE_FLAGS) $(MAVENCLASS_DB) > $@
