
include ../Makefile.local

SQLITE_FLAGS+=-cmd "ATTACH '$(MAVENCLASS_DB)' as mavenclass"
# SQLITE_FLAGS+=-cmd "PRAGMA main.synchronous = OFF"
# SQLITE_FLAGS+=-cmd "PRAGMA main.journal_mode = OFF"
# SQLITE_FLAGS+=-cmd "PRAGMA main.locking_mode = EXCLUSIVE"
# SQLITE_FLAGS+=-cmd "PRAGMA mavenclass.synchronous = OFF"
# SQLITE_FLAGS+=-cmd "PRAGMA mavenclass.journal_mode = OFF"
# SQLITE_FLAGS+=-cmd "PRAGMA mavenclass.locking_mode = EXCLUSIVE"

DBS=$(patsubst %.sql,%.sqlite3,$(wildcard *.sql))

all: $(DBS)

%.sqlite3: %.sql
	cat $< | $(SQLITE) $(SQLITE_FLAGS) $@
