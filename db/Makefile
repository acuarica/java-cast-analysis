
SQLITE3=sqlite3

MAVENCLASS=$(HOME)/work/mavends/out/mavenclass-last.sqlite3
SQLITE_FLAGS=-header -echo -bail
SQLITE_FLAGS+=-cmd "ATTACH '$(MAVENCLASS)' as mavenclass"
SQLITE_FLAGS+=-cmd "PRAGMA main.synchronous = OFF"
SQLITE_FLAGS+=-cmd "PRAGMA main.journal_mode = OFF"
SQLITE_FLAGS+=-cmd "PRAGMA main.locking_mode = EXCLUSIVE"
SQLITE_FLAGS+=-cmd "PRAGMA mavenclass.synchronous = OFF"
SQLITE_FLAGS+=-cmd "PRAGMA mavenclass.journal_mode = OFF"
SQLITE_FLAGS+=-cmd "PRAGMA mavenclass.locking_mode = EXCLUSIVE"

SRC=.
BUILD=.

SQLS=$(wildcard $(SRC)/*.sql)
DBS=$(SQLS:$(SRC)/%.sql=$(BUILD)/%.sqlite3)

createtables: $(DBS)

%.sqlite3: %.sql
	cat $< | $(SQLITE3) $(SQLITE_FLAGS) $@
