# =============================================================================
# Makefile for VICEROY.EXE reconstruction
# -----------------------------------------------------------------------------
# This is a DOCUMENTATION Makefile.  It captures the build steps that would
# be required by a period-correct toolchain (Microsoft C 6.0 / Borland C++
# 3.x + RTLink/Plus 4.x linker) to produce a byte-equivalent VICEROY.EXE.
#
# The actual build is NOT runnable on a modern host — it requires:
#   - The original Microsoft C 6.0 (or Borland C++ 3.1) compiler toolchain
#   - The RTLink/Plus linker from Pocket Soft (1992-era version)
#   - DOS/16-bit linker setup with correct .RTLINK / .DEF script files
#
# Reproducing the exact byte sequence requires the same linker version and
# the same OBJ-emission ordering as the original team used in 1994.
# =============================================================================

# ---- Toolchain (as it would have appeared on a 1994 dev machine) -----------
CC      = cl /AL /Gs /Os /Zp2          # Microsoft C 6.0, large model, stack-check off,
                                        # optimize-for-size, struct-pack 2
LINK    = link
RTLINK  = rtlink                        # RTLink/Plus, 1992-era

# ---- Compile flags ---------------------------------------------------------
CFLAGS  = -I include /D__DOS__ /D_VICEROY_

# ---- Source units (per object file) ----------------------------------------
OBJS_BOOT     = obj/entry.obj
OBJS_RUNTIME  = obj/cstart.obj obj/atexit.obj
OBJS_IOLIB    = obj/file.obj  obj/format.obj  obj/string.obj  obj/memory.obj
OBJS_COLONY   = obj/colony_turn_update.obj  obj/colony_assignment.obj \
                obj/colony_accessors.obj    obj/colony_commodity.obj \
                obj/colony_production_support.obj  obj/colony_sol_tory.obj \
                obj/colony_auto_manage.obj
OBJS_UNIT     = obj/unit_cargo.obj  obj/unit_chain.obj \
                obj/unit_lifecycle.obj  obj/unit_move.obj
OBJS_MAP      = obj/map_bounds.obj    obj/map_layers.obj
OBJS_OVERLAY  = obj/rtlink.obj
OBJS_DATA     = obj/data_production.obj  obj/data_terrain_yield.obj
# Subsystems ported 2026-05-30 (wave 1-2). NOTE: this Makefile is a documentation
# manifest only (no MSC 6.0 compiler in this env); deps below are illustrative, and
# combat/ff/market and the overlay segments are not yet all listed here.
OBJS_NATIVE   = obj/native_settlement.obj  obj/native_raid.obj  obj/native_mission.obj \
                obj/native_tribe_query.obj obj/native_village_raze.obj  obj/native_haggle.obj
OBJS_KING     = obj/king_demands.obj  obj/king_ref.obj  obj/king_tax_raise.obj \
                obj/king_sons_of_liberty.obj  obj/king_intervention.obj  obj/king_tax_apply.obj \
                obj/king_events.obj  obj/king_war_turn.obj
OBJS_DIPLO    = obj/diplomacy_relations.obj  obj/diplomacy_treaty.obj \
                obj/diplomacy_meeting.obj
# Render tile chain (wave 4): func_O514 -> func_O513 -> func_O512 + leaf emitters
OBJS_RENDER   = obj/render_tile_chain.obj  obj/render_terrain.obj \
                obj/render_blit.obj  obj/render_hud.obj  obj/render_units.obj \
                obj/render_tile_info_panel.obj
OBJS_SAVE     = obj/save_serializer.obj  obj/load_deserializer.obj
OBJS_AI       = obj/ai_driver.obj  obj/ai_unit_orders.obj  obj/ai_unit_leaf.obj \
                obj/ai_native_unit_ai.obj
OBJS_MAPGEN   = obj/mapgen_generator.obj  obj/mapgen_climate.obj \
                obj/mapgen_rivers.obj  obj/mapgen_settlements.obj
# In-game screen handlers (wave 5): located in overlay reseg, string-key verified
OBJS_UI       = obj/ui_main_loop.obj  obj/ui_colony_screen.obj  obj/ui_europe_screen.obj \
                obj/ui_dialog.obj  obj/ui_menu.obj  obj/ui_title_screen.obj  obj/ui_hall_of_fame.obj \
                obj/ui_report_screen.obj  obj/ui_king_audience.obj  obj/ui_options_dialog.obj
# Combat (waves 1-6): func_05B2C2 resolver + demotion ladder + modifier mechanism + naval
OBJS_COMBAT   = obj/combat.obj  obj/combat_demotion_ladder.obj \
                obj/combat_modifiers.obj  obj/naval.obj  obj/land.obj

OBJS_LOAD_IMAGE = $(OBJS_BOOT) $(OBJS_RUNTIME) $(OBJS_IOLIB) \
                  $(OBJS_COLONY) $(OBJS_UNIT) $(OBJS_MAP) \
                  $(OBJS_OVERLAY) $(OBJS_DATA) $(OBJS_NATIVE) \
                  $(OBJS_KING) $(OBJS_DIPLO) $(OBJS_SAVE) \
                  $(OBJS_AI) $(OBJS_MAPGEN) $(OBJS_RENDER) $(OBJS_UI) \
                  $(OBJS_COMBAT)

# Overlay segments — would be linked separately by RTLink
OBJS_OVERLAY_SEGMENTS = $(wildcard obj/overlay_seg_*.obj)

# ---- Targets ---------------------------------------------------------------

all: obj/VICEROY.EXE

obj/VICEROY.EXE: $(OBJS_LOAD_IMAGE) $(OBJS_OVERLAY_SEGMENTS) viceroy.rtlink
	$(RTLINK) @viceroy.rtlink

# Pattern rule for any source file
obj/%.obj: src/%.c
	$(CC) $(CFLAGS) /c /Fo$@ $<

verify: obj/VICEROY.EXE
	@echo "Verifying byte-equivalent against original..."
	cmp -s obj/VICEROY.EXE ../raw/COLONIZE/VICEROY.EXE \
		&& echo "OK: byte-equivalent" \
		|| echo "FAIL: differences detected — see verification/byte_compare.py"

clean:
	rm -rf obj

# ---- Per-source dependencies (excerpt) -------------------------------------
obj/colony_turn_update.obj: src/colony/turn_update.c \
	include/colony.h include/unit.h include/globals.h include/viceroy.h
obj/colony_assignment.obj: src/colony/assignment.c \
	include/colony.h include/unit.h include/globals.h include/viceroy.h
obj/colony_accessors.obj: src/colony/accessors.c \
	include/colony.h include/globals.h include/viceroy_types.h
obj/colony_commodity.obj: src/colony/commodity.c \
	include/colony.h include/unit.h include/globals.h include/viceroy.h
obj/colony_production_support.obj: src/colony/production_support.c \
	include/colony.h include/globals.h include/viceroy.h
obj/unit_cargo.obj: src/unit/cargo.c \
	include/unit.h include/globals.h include/viceroy_types.h
obj/file.obj: src/iolib/file.c \
	include/iolib.h include/globals.h include/dos.h
obj/cstart.obj: src/runtime/cstart.c \
	include/runtime.h include/iolib.h include/globals.h include/dos.h
obj/entry.obj: src/boot/entry.c \
	include/runtime.h include/rtlink.h include/dos.h include/globals.h
obj/rtlink.obj: src/overlay/rtlink.c \
	include/rtlink.h include/dos.h include/globals.h

# ---- Notes -----------------------------------------------------------------
#
# To produce a byte-equivalent VICEROY.EXE the linker order matters.  The
# OBJ-input order is:
#
#   1. cstart  (provides _main entry; goes first per the C runtime convention)
#   2. boot/entry  (entry_point stub)
#   3. iolib (file/format/string/memory) — alphabetical within set
#   4. runtime (atexit, exit_chain)
#   5. colony, unit, map (game-logic OBJs)
#   6. overlay/rtlink
#   7. data (terminal segments holding initialized DGROUP tables)
#
# RTLink/Plus then post-processes the linked image to install thunks at
# DGROUP:0x1A5F0 and rewrite all cross-segment LCALLs to go through the
# thunks.  The .RTLINK script (viceroy.rtlink) tells it which OBJs
# belong to which overlay segment.
