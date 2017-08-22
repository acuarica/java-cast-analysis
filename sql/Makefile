
SQLITE3=sqlite3

DB=~/work/mavends/out/mavenclass-last.sqlite3
SQLITE_FLAGS=-header -echo

SRC=.
BUILD=.

SQLS=$(wildcard $(SRC)/*.sql)
OUTS=$(SQLS:$(SRC)/%.sql=$(BUILD)/%.out)

execallqueries: $(OUTS)

%.out: %.sql
	cat $< | $(SQLITE3) $(SQLITE_FLAGS) $(DB) > $@
