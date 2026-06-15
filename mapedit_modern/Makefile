# Makefile for the modern MAPEDIT reimplementation.
#
#   make            build the mpedit CLI + unit tests
#   make test       run the unit tests (round-trips AMER2.MP if present)
#   make gui        build the SDL2 editor (requires libsdl2-dev) -- added later
#   make clean

CC      ?= cc
CFLAGS  ?= -std=c11 -O2 -Wall -Wextra -Wshadow -Iinclude
BUILD   := build

CORE_SRC := src/mp.c src/terrain.c src/txt.c src/editor.c
CORE_OBJ := $(CORE_SRC:src/%.c=$(BUILD)/%.o)

AMER2 ?= ../raw/COLONIZE/AMER2.MP

.PHONY: all test clean
all: $(BUILD)/mpedit $(BUILD)/test_mp

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/%.o: src/%.c | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/mpedit: $(CORE_OBJ) src/cli.c | $(BUILD)
	$(CC) $(CFLAGS) $(CORE_OBJ) src/cli.c -o $@

$(BUILD)/test_mp: $(CORE_OBJ) tests/test_mp.c | $(BUILD)
	$(CC) $(CFLAGS) $(CORE_OBJ) tests/test_mp.c -o $@

test: $(BUILD)/test_mp
	./$(BUILD)/test_mp $(AMER2)

clean:
	rm -rf $(BUILD)
