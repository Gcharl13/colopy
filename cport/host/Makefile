# Host build of the colopy core. `make && make test`.
CC      ?= gcc
# -Wframe-larger-than: the board's task stacks are a few KB, so a fat
# stack frame is a CRASH on hardware, not a style issue.  The bar is set
# just above the two big key/click dispatchers (~3 KB each, inherent to
# a switch whose frame is the union of every case's locals) so it stays
# quiet on those while catching real offenders — the colony painter used
# to put a 25,600-byte scene band here, which smashed the ESP32 loop
# stack and crashed the board (2026-08-17).
CFLAGS  ?= -std=c11 -O2 -Wall -Wextra -Werror -Wframe-larger-than=4096 \
           -I../core -I../data
OBJ      = ../data/colopy_data.o ../data/colopy_text.o ../data/colopy_ui.o ../core/colopy_sav.o ../core/colopy_map.o ../core/colopy_colony.o ../core/colopy_market.o ../core/colopy_events.o ../core/colopy_move.o ../core/colopy_combat.o ../core/colopy_turn.o ../core/colopy_natives.o ../core/colopy_rivals.o ../core/colopy_resolve.o ../core/colopy_cmd.o ../core/colopy_europe.o ../core/colopy_village.o ../core/colopy_woi.o ../core/colopy_newgame.o ../core/colopy_extras.o ../render/colopy_render.o ../render/colopy_map_render.o ../render/colopy_dialog.o ../render/colopy_colony_render.o ../render/colopy_europe_render.o ../render/colopy_report_render.o ../render/colopy_boot_render.o ../game/colopy_input.o ../audio/colopy_audio.o ../audio/colopy_audio_mix.o ../audio/colopy_audio_pak.o ../audio/colopy_audio_cues.o pak_check.o render_smoke.o audio_pak_check.o audio_smoke.o main.o
HDRS = ../core/colopy_core.h ../core/colopy_sim.h ../core/colopy_state.h \
       ../core/colopy_records.h ../data/colopy_data.h ../data/colopy_pak.h \
       ../data/colopy_text.h ../data/colopy_ui.h \
       ../render/colopy_render.h ../game/colopy_input.h fixtures.h \
       ../audio/colopy_audio.h ../audio/colopy_audio_internal.h \
       ../data/colopy_audio_pak.h audio_fixture.h
smoke: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ)
%.o: %.c $(HDRS)
	$(CC) $(CFLAGS) -c $< -o $@
test: smoke
	./smoke
clean:
	rm -f smoke $(OBJ)
.PHONY: test clean
