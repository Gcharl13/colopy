# Host build of the colopy core. `make && make test`.
CC      ?= gcc
CFLAGS  ?= -std=c11 -O2 -Wall -Wextra -Werror -I../core -I../data
OBJ      = ../data/colopy_data.o ../core/colopy_sav.o ../core/colopy_map.o ../core/colopy_colony.o main.o
smoke: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ)
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
test: smoke
	./smoke
clean:
	rm -f smoke $(OBJ)
.PHONY: test clean
