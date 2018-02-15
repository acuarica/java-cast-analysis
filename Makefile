
QLS=$(wildcard ql/*.ql)
RUNS=$(QLS:ql/%.ql=out/%.run)
RESULTS=$(QLS:ql/%.ql=out/%.result)

.PRECIOUS: out/%.run

run: $(RUNS)
result: $(RESULTS)

out/%.run: ql/%.ql | out
	./lgtm.py run $< $@

out/%.result: out/%.run
	./lgtm.py results $< $@

out:
	mkdir out

clean:
	rm -r out/
