# Host build of the colopy core. `make && make test`.
CC      ?= gcc
# -Wframe-larger-than: the board's task stacks are a few KB, so a fat
# stack frame is a CRASH on hardware, not a style issue.  The bar is set
# just above the two big key/click dispatchers (~3 KB each, inherent to
# a switch whose frame is the union of every case's locals) so it stays
# quiet on those while catching real offenders — the colony painter used
# to put a 25,600-byte scene band here, which smashed the ESP32 loop
# stack and crashed the board (2026-08-17).
#
# It is PER-FUNCTION, and that is the whole of what it can see.  Every
# OTHER board stack crash was DEPTH: legal frames stacked under legal
# frames.  `make test` therefore also runs tools/stack_budget.py, which
# walks the real call graph and sizes the worst path from each entry
# point.  The build-colony crash (2026-08-19) got past this gate at
# 3,488 bytes — under the per-frame bar, on top of the whole command
# chain.
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
test: smoke budget records mock assets
	./smoke
# The depth gate.  Self-locating, so the cwd here does not matter.
budget:
	python3 ../../tools/stack_budget.py --limit 4096
# The staleness gate: the ledger's load-bearing claims, as probes that run.
records:
	python3 ../../tools/stale_check.py
# The .ino gate: the IDE's prototype hoist emulated, then a syntax check
# of the generated P4 sketch, BLE off and on (REMAINING_WORK.md G2e).
mock:
	sh ../../tools/ino_mock/check.sh
# The asset gate (STATUS.md gate C): every shipped .SS/.PIK/.FF decodes
# through the in-repo codec into extracted/ (git-ignored); declared
# failures must keep failing.  Seconds, so it runs every time (G7).
assets:
	python3 ../../tools/extract_visuals.py --quiet
# The ONLY gate that compares the port to the real game.  Deliberately NOT in
# `test`: --capture drives DOSBox and takes minutes.  The diff pass is seconds
# and runs off committed captures.
census:
	python3 ../../tools/screen_census.py
census-capture:
	python3 ../../tools/screen_census.py --capture
clean:
	rm -f smoke $(OBJ)
.PHONY: test budget records mock assets census census-capture clean
