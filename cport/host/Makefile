# Host build of the colopy core. `make && make test`.
CC      ?= gcc
CFLAGS  ?= -std=c11 -O2 -Wall -Wextra -Werror -I../core -I../data
OBJ      = ../data/colopy_data.o ../data/colopy_text.o ../core/colopy_sav.o ../core/colopy_map.o ../core/colopy_colony.o ../core/colopy_market.o ../core/colopy_events.o ../core/colopy_move.o ../core/colopy_combat.o ../core/colopy_turn.o ../core/colopy_natives.o ../core/colopy_rivals.o ../core/colopy_resolve.o ../core/colopy_cmd.o ../core/colopy_europe.o ../core/colopy_village.o main.o
HDRS = ../core/colopy_core.h ../core/colopy_sim.h ../core/colopy_state.h \
       ../core/colopy_records.h ../data/colopy_data.h fixtures.h
smoke: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ)
%.o: %.c $(HDRS)
	$(CC) $(CFLAGS) -c $< -o $@
test: smoke
	./smoke
clean:
	rm -f smoke $(OBJ)
.PHONY: test clean
