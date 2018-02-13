
QLS=$(wildcard ql/*.ql)
RUNS=$(QLS:.ql=.run)
RESULTS=$(QLS:.ql=.result)

.PRECIOUS: ql/%.run

result: $(RESULTS)

ql/%.run: ql/%.ql
	./lgtm.py run $< > $@

ql/%.result: ql/%.run
	./lgtm.py results $< > $@

clean:
	rm ql/*.run ql/*.result
