
JAVA=java
JAVAC=javac
JAVAP=javap

SRC=.
BUILD=.

SRCS=$(wildcard $(SRC)/*.java)
OBJS=$(SRCS:$(SRC)/%.java=$(BUILD)/%.class)
ASMS=$(OBJS:$(BUILD)/%.class=$(BUILD)/%.bytecode)
RUNS=$(OBJS:$(BUILD)/%.class=$(BUILD)/%.phonyrun)

.PHONY: run compile disassembly

run: $(RUNS)

compile: $(OBJS)

disassembly: $(ASMS)

%.class: %.java
	$(JAVAC) $<

%.bytecode: %.class
	$(JAVAP) -v $< > $@

%.phonyrun: %.class
	$(JAVA) $*
