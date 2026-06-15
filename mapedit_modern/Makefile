# Makefile for the modern MAPEDIT reimplementation.
#
#   make            build the mpedit CLI + unit tests
#   make test       run the unit tests (round-trips AMER2.MP if present)
#   make gui        build the SDL2 editor (requires libsdl2-dev) -- added later
#   make clean

CC      ?= cc
CFLAGS  ?= -std=c11 -O2 -Wall -Wextra -Wshadow -Iinclude -MMD -MP
BUILD   := build

CORE_SRC := src/mp.c src/terrain.c src/txt.c src/editor.c
CORE_OBJ := $(CORE_SRC:src/%.c=$(BUILD)/%.o)

# Renderer (backend-independent): framebuffer + sprites + ui layout.
RENDER_SRC := src/framebuffer.c src/sprites.c src/ui.c
RENDER_OBJ := $(RENDER_SRC:src/%.c=$(BUILD)/%.o)

AMER2 ?= ../raw/COLONIZE/AMER2.MP

.PHONY: all test gui clean
all: $(BUILD)/mpedit $(BUILD)/test_mp $(BUILD)/mpedit-shot

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/%.o: src/%.c | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/mpedit: $(CORE_OBJ) src/cli.c | $(BUILD)
	$(CC) $(CFLAGS) $(CORE_OBJ) src/cli.c -o $@

$(BUILD)/test_mp: $(CORE_OBJ) tests/test_mp.c | $(BUILD)
	$(CC) $(CFLAGS) $(CORE_OBJ) tests/test_mp.c -o $@

$(BUILD)/mpedit-shot: $(CORE_OBJ) $(RENDER_OBJ) src/shot.c | $(BUILD)
	$(CC) $(CFLAGS) $(CORE_OBJ) $(RENDER_OBJ) src/shot.c -o $@

# SDL2 editor (requires libsdl2-dev). Built on demand; not part of `all` so the
# core/renderer still build in environments without SDL2.
gui: $(BUILD)/mpedit-gui
$(BUILD)/mpedit-gui: $(CORE_OBJ) $(RENDER_OBJ) src/gui_sdl.c | $(BUILD)
	$(CC) $(CFLAGS) $(CORE_OBJ) $(RENDER_OBJ) src/gui_sdl.c -o $@ $(shell sdl2-config --cflags --libs 2>/dev/null || echo -lSDL2)

test: $(BUILD)/test_mp
	./$(BUILD)/test_mp $(AMER2)

clean:
	rm -rf $(BUILD)

-include $(BUILD)/*.d
