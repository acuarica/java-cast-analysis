
SRC=.
BUILD=.

JAVA=$(wildcard $(SRC)/*.java)
CLASS=$(JAVA:$(SRC)/%.java=$(BUILD)/%.class)
BYTECODE=$(CLASS:$(SRC)/%.class=$(BUILD)/%.bytecode)

.PHONY: run compile disassembly

run:
	java Generics

compile: $(CLASS)

disassembly: $(BYTECODE)

%.class: %.java
	javac $<

%.bytecode: %.class
	javap -v $< > $@
