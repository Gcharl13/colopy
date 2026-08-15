# Host build of the colopy core. `make && make test`.
CC      ?= gcc
CFLAGS  ?= -std=c11 -O2 -Wall -Wextra -Werror -I../core -I../data
OBJ      = ../data/colopy_data.o ../data/colopy_text.o ../core/colopy_sav.o ../core/colopy_map.o ../core/colopy_colony.o ../core/colopy_market.o ../core/colopy_events.o ../core/colopy_move.o ../core/colopy_combat.o ../core/colopy_turn.o main.o
smoke: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ)
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
test: smoke
	./smoke
clean:
	rm -f smoke $(OBJ)
.PHONY: test clean
