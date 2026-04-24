SRC     = -f src.f
COMPOPT = -sverilog -debug_access+all -kdb
SIMOPT  = 

all: comp sim

clean:
	rm -rf csrc simv* ucli.key

cleanall: clean
	rm -rf *.log

comp:
	vcs $(COMPOPT) $(SRC)

sim:
	./simv -l simulation.log $(SIMOPT)
