/* linkfloor_extra.ld -- COMMITTED companion to the generated
 * tools/generated/linkfloor.ld.  Byte-exact g_dgroup aliases for
 * DGROUP globals whose NAMES don't carry their offset (linkgap.py
 * derives aliases from g_*_HEXADDR names; these are cited in their
 * former definitions in src/data/production.c, converted to extern
 * 2026-06-09 so storage lives in g_dgroup, not standalone BSS). */
PROVIDE(g_pair_key1 = g_dgroup + 0xC8);
PROVIDE(g_pair_key2 = g_dgroup + 0xDE);
PROVIDE(g_program_ds = g_dgroup + 0x27B2);
PROVIDE(g_NFILE_QQ = g_dgroup + 0x27B9);
PROVIDE(g_argc = g_dgroup + 0x27CF);
PROVIDE(g_argv = g_dgroup + 0x27D1);
PROVIDE(g_envp = g_dgroup + 0x27D3);
PROVIDE(g_overlay_layout = g_dgroup + 0x3995);
PROVIDE(g_map_width = g_dgroup + 0x853A);
PROVIDE(g_map_height = g_dgroup + 0x853C);
PROVIDE(g_render_aux_a = g_dgroup + 0x8D4C);
PROVIDE(g_render_aux_b_ptr = g_dgroup + 0x8D4E);
PROVIDE(g_iter_aux_a = g_dgroup + 0x8D72);
PROVIDE(g_iter_aux_b = g_dgroup + 0x8D74);
PROVIDE(g_iter_aux_c = g_dgroup + 0x8D76);
PROVIDE(g_iter_handle = g_dgroup + 0x8D78);
PROVIDE(g_iter_aux_d = g_dgroup + 0x8D7A);
PROVIDE(g_pop_or_year = g_dgroup + 0x8DB8);
PROVIDE(g_global_amount = g_dgroup + 0x8DC8);
PROVIDE(g_band_base = g_dgroup + 0x8E0A);
PROVIDE(g_over_low = g_dgroup + 0x8E32);
PROVIDE(g_over_high = g_dgroup + 0x8E5A);

/* map-renderer resident helpers: render/'s extern names -> their ported
 * load_image bodies (thunk targets resolved from the EXE thunk records) */
PROVIDE(classify_terrain    = func_006204_logic_sz_46);            /* 0x181F:0x6AA */
PROVIDE(subcell_priority    = func_005C2C_logic_sz_132);           /* 0x181F:0x6C8 */
PROVIDE(is_xy_in_map_bounds = func_005BFA_logic_sz_49);            /* 0x181F:0x302 */
PROVIDE(read_terrain_byte   = func_005CFE_map_tile_read_layer_15C);/* 0x181F:0x72C */
PROVIDE(special_feature_at  = func_0060A0_logic_sz_128);           /* 0x181F:0x718 */
PROVIDE(river_detail_at     = func_006188_op_sz_91);               /* 0x181F:0x75E */

/* view-rect globals used by func_066E0C/066E52 (overlay_0612E6 ports) */
PROVIDE(g_view_col0   = g_dgroup + 0x8328);
PROVIDE(g_view_row0   = g_dgroup + 0x832E);
PROVIDE(g_view_maxcol = g_dgroup + 0x8804);
PROVIDE(g_view_maxrow = g_dgroup + 0x8806);
PROVIDE(g_w53A2 = g_dgroup + 0x53A2);

/* canonical chain primitives: the load_image callers use the func_0XXXXX
 * names; the bodies live under their semantic names in src/unit/ */
PROVIDE(func_006672 = unit_chain_resolve);
PROVIDE(func_0066BA = unit_chain_next);
PROVIDE(overlay_call_0427_004A = unit_chain_next);  /* LCALL 0x427:0x004A -> file 0x66BA = unit_chain_next */
PROVIDE(func_0068AA = unit_chain_unlink);

/* naval.c DS-word globals + tables (byte-exact homes) */
PROVIDE(g_active_unit      = g_dgroup + 0x5392);
PROVIDE(g_ship_dest_status = g_dgroup + 0x9E4E);
PROVIDE(g_ship_dest_aux    = g_dgroup + 0x9E50);
PROVIDE(g_active_power     = g_dgroup + 0x5394);
PROVIDE(g_in_europe_flag   = g_dgroup + 0x5382);
PROVIDE(g_unit_stat        = g_dgroup + 0x5230);
PROVIDE(g_units            = g_dgroup + 0x3144);
/* world-turn integration pass (2026-06-10): tables the per-turn engines walk */
PROVIDE(g_table_8F86_stride12 = g_dgroup + 0x8F86);
PROVIDE(price_seed = g_dgroup + 0x53EA);
PROVIDE(display_price = g_dgroup + 0x7B44);
PROVIDE(cargo_col0 = g_dgroup + 0x97C0);
PROVIDE(nation_name = g_dgroup + 0x7C74);
PROVIDE(power_is_ai = g_dgroup + 0x543F);
PROVIDE(g_market_year = g_dgroup + 0x538A);
PROVIDE(g_market_phase = g_dgroup + 0x538E);
PROVIDE(difficulty = g_dgroup + 0x53A6);
PROVIDE(g_active_power_index = g_dgroup + 0x9E12);
PROVIDE(g_cargo_param = g_dgroup + 0x96FC);
PROVIDE(g_map_w = g_dgroup + 0x853A);
PROVIDE(g_map_h = g_dgroup + 0x853C);
/* save/load record tables + counts (byte-cited in save_serializer.c) */
PROVIDE(g_colony_table = g_dgroup + 0x5D46);
PROVIDE(g_unit_table   = g_dgroup + 0x3144);
PROVIDE(g_power_table  = g_dgroup + 0x8808);
PROVIDE(g_native_table = g_dgroup + 0x54EC);
PROVIDE(g_colony_count = g_dgroup + 0x539E);
PROVIDE(g_unit_count   = g_dgroup + 0x539C);
PROVIDE(g_native_count = g_dgroup + 0x539A);
PROVIDE(g_save_version = g_dgroup + 0x081A);

/* automove / map-kernel globals (overlay_0612E6_066EB3.c externs) — these
 * resolved to DETACHED weak stub variables (reads/writes never touched the
 * real DGROUP; indexing the zero-size g_unit_bytes crashed), caught live
 * 2026-06-11 when the AI dispatch chain (ROUTE_B 1.6) first exercised
 * func_062D84_unit_automove.  Offsets are the file's own byte-cited homes.
 * The map-layer FAR POINTERS (g_layer0_terrain 0x85A8 etc.) are deliberately
 * NOT aliased: 64-bit host pointers cannot live in 4-byte DGROUP slots; they
 * remain host-side variables owned by the platform map-attach layer. */
PROVIDE(g_unit_bytes = g_dgroup + 0x3144);
PROVIDE(g_dir_dx = g_dgroup + 0xB4);
PROVIDE(g_dir_dy = g_dgroup + 0xBE);
PROVIDE(g_observe_flag = g_dgroup + 0x53A2);
PROVIDE(g_active_player = g_dgroup + 0x5396);
PROVIDE(g_active_nation = g_dgroup + 0x5394);
PROVIDE(g_view_col0_b = g_dgroup + 0x832C);
PROVIDE(g_view_stride = g_dgroup + 0x8326);
PROVIDE(g_minimap_row0 = g_dgroup + 0x9CCA);
PROVIDE(g_minimap_col0 = g_dgroup + 0x9CCC);
PROVIDE(g_traderoute_count = g_dgroup + 0x53A0);
PROVIDE(g_color_byhi = g_dgroup + 0x848);
PROVIDE(g_color_byterrain = g_dgroup + 0x5A8A);
/* func_04CC50 planner state (byte-cited in overlay_04C306_053BC1.c): */
PROVIDE(g_ai_mapgrid_9FAA  = g_dgroup + 0x9FAA);  /* work grid, (x>>2)*0x12+(y>>2) */
PROVIDE(g_ai_bitmask_173C  = g_dgroup + 0x173C);  /* region coverage bitmask */
PROVIDE(g_ai_bitmask_173E  = g_dgroup + 0x173E);

/* AI unit-turn path leaves (Gate G1, 2026-06-11): native_unit_ai.c +
 * func_006CCA declare these role-named externs with FULL argument lists
 * matching the targets' arities (positional contract == the original
 * stack pushes), so the PROVIDE alias is exact.  Resolutions: whois on
 * the cited thunks (181F:0754/072C/0952/06B4/0614/0808; 0981:0000 is a
 * direct resident far call). */
PROVIDE(ovly_ability_754       = func_005D32_map_tile_read_layer_160);
PROVIDE(ovly_ability_72C       = func_005CFE_map_tile_read_layer_15C);
PROVIDE(ovly_query_952         = func_00723E_op_sz_48);
PROVIDE(ovly_terrain_6B4       = func_005DBA_logic_sz_17);
PROVIDE(ovly_occupant_614      = func_0083F2_op_sz_71);
PROVIDE(ovly_unit_unlink_808   = func_006E94_logic_sz_198);
PROVIDE(overlay_call_0981_0000 = func_00BC10_ff_owned);
PROVIDE(ovly_step_unit_2E4     = unit_chain_next);   /* 181F:02E4 — stub-0 made
                                  the tile-stack walks spin (the 1.2 hang class) */
PROVIDE(ovly_clear_orders_934  = func_007BCE_logic_sz_25); /* 181F:0934 end-turn
                                  (native_unit_ai.c / unit_ai_leaf.c externs) */
/* G1 tranche 2 (2026-06-11): ai_eval_unit + native_unit_ai + unit_ai_leaf
 * probe leaves.  All targets are existing ports; arity checked against the
 * extern declarations (and the EXE call sites where conventions differed —
 * 7E0 is the register-pair AX/DX call, leaf extern corrected). */
PROVIDE(ovly_unit_ability_754  = func_005D32_map_tile_read_layer_160);   /* 181F:0754
                                  (unit_orders.c spelling of ovly_ability_754) */
PROVIDE(ovly_unit_ability_72C  = func_005CFE_map_tile_read_layer_15C);   /* 181F:072C */
PROVIDE(ovly_occupant_at_6BE   = func_005FD4_map_xy_bounds_or_neg1_alt); /* 181F:06BE */
PROVIDE(ovly_query_6BE         = func_005FD4_map_xy_bounds_or_neg1_alt);
PROVIDE(ovly_target_query_6BE  = func_005FD4_map_xy_bounds_or_neg1_alt);
PROVIDE(ovly_tile_to_unit_7E0  = func_0066CC_op_sz_57);                  /* 181F:07E0 (AX,DX) */
PROVIDE(ovly_attackable_6F0    = func_005F82_logic_sz_31);               /* 181F:06F0 */
PROVIDE(ovly_relation_query_826 = func_00730A_op_sz_75);                 /* 181F:0826 */
PROVIDE(ovly_finalize_unit_90C = func_006CCA_logic_sz_13);               /* 181F:090C =
                                  movement ALLOWANCE (the "finalize" name was a
                                  misread; moves_left = allowance - used) */
PROVIDE(ovly_commit_A4C        = func_0081F2_logic_sz_34);               /* 181F:0A4C */
PROVIDE(ovly_dist_370          = func_004900_logic_sz_15);               /* 181F:0370 */
PROVIDE(ovly_query_37A         = func_00493C_logic_sz_14);               /* 181F:037A */
PROVIDE(ovly_colony_at_7BE     = func_008D26_op_sz_69);                  /* 181F:07BE */
PROVIDE(ovly_target_query_7BE  = func_008D26_op_sz_69);
PROVIDE(ovly_query_6DC         = func_005DF0_logic_sz_40);               /* 181F:06DC */
PROVIDE(ovly_query_682         = func_005F04_map_xy_bounds_or_neg1);     /* 181F:0682 */
PROVIDE(ovly_query_718         = func_0060A0_logic_sz_128);              /* 181F:0718 */
PROVIDE(ovly_market_value_30C  = func_0082A0_logic_sz_18);               /* 181F:030C */
PROVIDE(ovly_terrain_78C       = func_00627A_op_sz_57);                  /* 181F:078C */
/* G1 tranche 3 (2026-06-11): the rows the tranche-2 depths exposed. */
PROVIDE(ovly_relation_970      = func_00726E_op_sz_116);                 /* 181F:0970 (view,x,y) */
PROVIDE(ovly_step_916          = func_007966_logic_sz_41);               /* 181F:0916 (unit) */
PROVIDE(func_00726E            = func_00726E_op_sz_116);                 /* bare-name implicit-decl
                                  calls inside func_00730A bound to the weak stub */
/* MSC long-math intrinsics (real impls in src/runtime/longmath.c; the
 * public names are aliased so linkgap suppresses their weak stubs and the
 * alias reference forces the archive extraction): */
PROVIDE(ov_long_mul_F60        = msc_aFlmul);   /* 0x0D1D:0x0F60 __aFlmul */
PROVIDE(ov_long_div_EC6        = msc_aFldiv);   /* 0x0D1D:0x0EC6 __aFldiv */
PROVIDE(ldiv32                 = msc_aFldiv);
/* G1 tranche 4 (2026-06-11): func_052F7E PHASE-5 planner trampolines.
 * Page-0x12 cs:0x7Axx stubs resolved 2026-06-10 (banner in the overlay file).
 * 7AD0 (gold/income tick) is LIVE (its host-pointer bug in scoring/compute.c
 * fixed on first execution).  7ADF/7AB2 are NOT yet wired: first live run of
 * func_04CC50 exposed that its PHASE-1 "bound-unit iterator" is a degraded
 * reconstruction — 0x181F:0x8BC is func_0073A8(unit, class) (a 2-STACK-ARG
 * chain query, byte-read @0x4CCE7 push 3/4/6), not a next-unit call, and the
 * 0x2EE/0x2E4 chain steps need their AX unit args restored.  The planner
 * bodies go live when that loop is byte-restored (named in G1 status). */
PROVIDE(ovly_tramp_7AD0        = gold_income_tick_for_power);     /* 1A1F:0554 -> func_051EF4 */
PROVIDE(ovly_tramp_7ADF        = func_04C532_ai_queue_a_rebuild); /* 1A1F:0578 (loop byte-restored
                                  2026-06-11: slot-clear -> func_04C1F0(power,i), emit arg order
                                  corrected to (power, r0..r3)) */
PROVIDE(ovly_tramp_7AB2        = func_04CC50_ai_strategic_plan_build); /* 1A1F:050C (per-unit loop +
                                  PHASE 6/7 slot capture byte-restored 2026-06-11; colony plan
                                  phase 0x4D048..0x4D6ED still DEGRADED-PENDING, no emits) */
/* G1 tranche 5 (2026-06-11): option_bit_test call site fixed at the source (sol_tory.c:
 * now calls func_00863E_wrapper_with_global_8DC6(0x12) directly, as PROVIDE cannot
 * override a generated __attribute__((weak)) stub in this link configuration). */

/* keepalive: force archive member extraction for ported functions whose
 * strong definition would otherwise lose to the weak stubs (the archive
 * is after linkfloor_stubs.c.o on the link line, so EXTERN() is needed
 * to mark each entry as undefined before the archive sweep). */
EXTERN(ai_unit_leaf)
EXTERN(func_008734_logic_sz_30)
EXTERN(func_005D32_map_tile_read_layer_160)
EXTERN(func_005CFE_map_tile_read_layer_15C)
EXTERN(func_00723E_op_sz_48)
EXTERN(func_005DBA_logic_sz_17)
EXTERN(func_0083F2_op_sz_71)
EXTERN(func_006E94_logic_sz_198)
EXTERN(func_00BC10_ff_owned)
EXTERN(unit_chain_next)
EXTERN(func_005FD4_map_xy_bounds_or_neg1_alt)
EXTERN(func_0066CC_op_sz_57)
EXTERN(func_005F82_logic_sz_31)
EXTERN(func_00730A_op_sz_75)
EXTERN(func_0081F2_logic_sz_34)
EXTERN(func_004900_logic_sz_15)
EXTERN(func_00493C_logic_sz_14)
EXTERN(func_008D26_op_sz_69)
EXTERN(func_005DF0_logic_sz_40)
EXTERN(func_005F04_map_xy_bounds_or_neg1)
EXTERN(func_0060A0_logic_sz_128)
EXTERN(func_0082A0_logic_sz_18)
EXTERN(func_00627A_op_sz_57)
EXTERN(func_00726E_op_sz_116)
EXTERN(func_007966_logic_sz_41)
EXTERN(gold_income_tick_for_power)
EXTERN(func_00BCAA_op_sz_64)
EXTERN(func_00BCEA_op_sz_61)
EXTERN(func_00CD0B_logic_sz_67)
EXTERN(func_005E90_op_sz_64)
EXTERN(func_0082DC_logic_sz_118)
EXTERN(func_006018_logic_sz_33)
EXTERN(func_00863E_wrapper_with_global_8DC6)
/* Phase 3.4 (2026-06-12): E3 screen-id map closure.  Strong no-op override for
 * the 0x181F:0x772 diagnostic reporter call; defined in src/ui/screen_id_map.c.
 * EXTERN forces archive-member extraction so the strong T def beats the weak W
 * def in linkfloor_stubs.c (the archive is linked after the direct objects). */
EXTERN(overlay_call_181F_0772)
/* Phase 3.5 (2026-06-12): dialog/event sweep.  Wire overlay thunks that were
 * previously unaliased weak stubs, and force extraction of their targets.
 *
 * Thunk wiring (byte-verified):
 *   overlay_call_181F_0022 -> 0x181F:0x0022 (resident Type-B) -> func_00E76A
 *     (the clipped RLE blitter; called by func_06C23C_dialog_make_from_int
 *      to create the dialog backdrop @asm 0x6C242)
 *   overlay_call_181F_0416 -> 0x181F:0x0416 -> func_06C220_dialog_slot_set_block
 *     (the text-slot emitter; called both directly and from func_06F7EA which
 *      func_06C23C calls as its tail @asm 0x6C24F)
 */
/* 0022 (RLE blitter) and 0416 (dialog text slot) are interactive-only;
 * their targets crash in headless mode without sprite/dialog initialisation.
 * They remain as weak stubs intentionally until a headless guard is wired.
 * PROVIDE not used here: linkgap.py generates the stubs for these two. */
EXTERN(func_06C23C_dialog_make_from_int)
EXTERN(func_06C27C_dialog_slot_set_pair)
EXTERN(func_06C220_dialog_slot_set_block)
EXTERN(func_034318_runtime_chain_289)
EXTERN(func_007F34_logic_sz_27)
EXTERN(func_007F96_op_sz_105)
EXTERN(func_008000_op_sz_115)
EXTERN(market_bid_price)
EXTERN(func_00E76A_logic_sz_505)

/* Phase 4.1 (2026-06-12): resident-segment stubs — these are NOT RTLink thunks
 * so thunkwire.py cannot auto-wire them; identified by byte analysis:
 *   overlay_call_037F_000A file 0x5BFA -> func_005BFA_logic_sz_49 is_xy_in_map_bounds
 *     (ENTER 2,0 / cmp [bp+6],1 / ... / cmp [0x853C]-1,[bp+8] bounds gate)
 *   overlay_call_037F_03E4 file 0x5FD4 -> func_005FD4_map_xy_bounds_or_neg1_alt
 *     (ENTER 2,0 / call 0x5BFA; if 0 ret -1; else call 0x5D32 ...)
 *   overlay_call_03E4_0074 file 0x62B4 -> func_0062B4_op_sz_39 is_sea_tile
 *     (terrain&0x1F in {0x19, 0x1A}; called 0x181F:0x768 in naval_screen.c)
 */
/* Phase 4.3 (2026-06-12): caller arity fixed — all callers of these three stubs
 * now pass (uint16_t x, uint16_t y) explicitly; PROVIDE aliases are now safe.
 *   overlay_call_037F_000A -> func_005BFA_logic_sz_49 is_xy_in_map_bounds(x,y)
 *   overlay_call_037F_03E4 -> func_005FD4_map_xy_bounds_or_neg1_alt(x,y)
 *   overlay_call_03E4_0074 -> func_0062B4_op_sz_39 is_sea_tile(x,y) */
PROVIDE(overlay_call_037F_000A = func_005BFA_logic_sz_49);
PROVIDE(overlay_call_037F_03E4 = func_005FD4_map_xy_bounds_or_neg1_alt);
PROVIDE(overlay_call_03E4_0074 = func_0062B4_op_sz_39);
EXTERN(func_005BFA_logic_sz_49)
EXTERN(func_005FD4_map_xy_bounds_or_neg1_alt)
EXTERN(func_0062B4_op_sz_39)

/* Phase 4.3 continued (2026-06-12): remaining resident-segment stubs with (x,y) arities.
 *   overlay_call_037F_010E file 0x5CFE -> func_005CFE_map_tile_read_layer_15C(x,y)
 *     (reads map layer 0x15C at (x,y); called as terrain tile-code source)
 *   overlay_call_037F_0314 file 0x5F04 -> func_005F04_map_xy_bounds_or_neg1(x,y)
 *     (returns chain-head unit at (x,y) or -1; PROVIDE(ovly_query_682) already alias)
 *   overlay_call_037F_0358 file 0x5F48 -> func_005F48_logic_sz_58(x,y)
 *     (water/sea probe: returns >= 0 iff tile is navigable water)
 *   func_007178 bare name -> func_007178_op_sz_192(x,y,arg2)
 *     (region-gated neighbour scan; called by func_00723E via near-call) */
PROVIDE(overlay_call_037F_010E = func_005CFE_map_tile_read_layer_15C);
PROVIDE(overlay_call_037F_0314 = func_005F04_map_xy_bounds_or_neg1);
PROVIDE(overlay_call_037F_0358 = func_005F48_logic_sz_58);
PROVIDE(func_007178            = func_007178_op_sz_192);
EXTERN(func_005F48_logic_sz_58)
EXTERN(func_007178_op_sz_192)

/* Phase 4.3c (2026-06-12): batch wiring of bare-name and named-semantic stubs.
 * All thunk targets verified via whois.py; arity cross-checked against declarations.
 *
 * Bare-name -> decorated-name (near calls within load_image to functions named
 * func_XXXXXX but defined as func_XXXXXX_op/logic/colony_sz_NNN):
 *   func_008956(a,b) -> lookup_byte_from_pair  (g_pair_key table scan, 2 args)
 *   func_00772E(u)   -> func_00772E_op_sz_149  (unit colony-work dispatcher, 1 arg)
 *   func_0088D0(r,c) -> func_0088D0_colony_sz_71  (colony-tile occupancy test, 2 args)
 *   func_00A93E()    -> func_00A93E_logic_sz_86   (5x5 grid fill, 0 args)
 *   func_0081C6(u)   -> func_0081C6_logic_sz_44   (Pocahontas/settle loop, 1 arg)
 *
 * Named semantics for sol_tory.c / turn_update.c colony-turn calls:
 *   colony_query(field,idx)   0x181F:0xB50 -> func_008DBC_logic_sz_69
 *   set_current_colony(id)    0x181F:0x9E6 -> func_0082DC_logic_sz_118
 *   ring_best_for_food(a,b)   0x181F:0xCB8 -> func_0098B4_logic_sz_65
 *   colony_query_further()    0x181F:0xD3A -> func_008D00_colony_stock_cap
 *   feature_yield_bonus(r,g)  near 0x9AAA  -> func_009AAA_logic_sz_241
 *
 * Native AI ovly_ stubs (all from native_unit_ai.c; thunk targets byte-verified):
 *   random_int_4D4(lo,hi)      0x181F:0x4D4 -> random_int   (rng.c, already live)
 *   ovly_clamp_or_scale_A60(v) 0x181F:0xA60 -> func_008262_logic_sz_20
 *   ovly_name_word_A1A(pwr)    0x181F:0xA1A -> func_0080C8_logic_sz_14
 *   ovly_name_word_9A4(pwr)    0x181F:0x9A4 -> func_008110_logic_sz_14
 *   ovly_animate_352(x1,y1,x2,y2,z) 0x181F:0x352 -> func_00BF3C_logic_sz_182
 *   ovly_query_8BC(two,unit)   0x181F:0x8BC -> func_0073A8_logic_sz_99
 *   ovly_query_984(pwr,x,y)    0x181F:0x984 -> func_00704C_op_sz_205
 *   ovly_query_384(a,dir)      0x181F:0x384 -> func_0049FC_logic_sz_20 */
PROVIDE(func_008956            = lookup_byte_from_pair);
PROVIDE(func_00772E            = func_00772E_op_sz_149);
PROVIDE(func_0088D0            = func_0088D0_colony_sz_71);
PROVIDE(func_00A93E            = func_00A93E_logic_sz_86);
PROVIDE(func_0081C6            = func_0081C6_logic_sz_44);
PROVIDE(colony_query           = func_008DBC_logic_sz_69);
PROVIDE(set_current_colony     = func_0082DC_logic_sz_118);
PROVIDE(ring_best_for_food     = func_0098B4_logic_sz_65);
PROVIDE(colony_query_further   = func_008D00_colony_stock_cap);
PROVIDE(feature_yield_bonus    = func_009AAA_logic_sz_241);
PROVIDE(random_int_4D4         = random_int);
PROVIDE(ovly_clamp_or_scale_A60 = func_008262_logic_sz_20);
PROVIDE(ovly_name_word_A1A     = func_0080C8_logic_sz_14);
PROVIDE(ovly_name_word_9A4     = func_008110_logic_sz_14);
PROVIDE(ovly_animate_352       = func_00BF3C_logic_sz_182);
PROVIDE(ovly_query_8BC         = func_0073A8_logic_sz_99);
PROVIDE(ovly_query_984         = func_00704C_op_sz_205);
PROVIDE(ovly_query_384         = func_0049FC_logic_sz_20);
EXTERN(func_008DBC_logic_sz_69)
EXTERN(func_0098B4_logic_sz_65)
EXTERN(func_009AAA_logic_sz_241)
EXTERN(func_008262_logic_sz_20)
EXTERN(func_0080C8_logic_sz_14)
EXTERN(func_008110_logic_sz_14)
EXTERN(func_00BF3C_logic_sz_182)
EXTERN(func_0073A8_logic_sz_99)
EXTERN(func_00704C_op_sz_205)
EXTERN(func_0049FC_logic_sz_20)
EXTERN(func_0081C6_logic_sz_44)
EXTERN(func_008D00_colony_stock_cap)

/* Phase 4.3d (2026-06-12): next batch of safe PROVIDE aliases.
 * Arity cross-checked against all call sites; zero-arg callers fixed above.
 *
 * Resident-segment overlay stubs (non-thunk, direct file targets):
 *   overlay_call_037F_02A0(x,y)   file 0x5E90 -> func_005E90_op_sz_64  map-region query
 *   overlay_call_05B3_0004(pw,sl) file 0x7F34 -> func_007F34_logic_sz_27 relations byte
 *   overlay_call_05B3_01E0(r)     file 0x8110 -> func_008110_logic_sz_14 name-word lookup
 *
 * Bare-name -> decorated-name (near calls to func_XXXXXX in load_image; bodies
 * defined under the full func_XXXXXX_<class>_sz_NNN name):
 *   func_006B46(u,phase)  -> func_006B46_op_sz_365  chain eviction to (-3,-3)
 *   func_0069D2(u,x,y)    -> func_0069D2_logic_sz_12 unlink+replace unit at (x,y)
 *   func_00A6A2(r,c)      -> func_00A6A2_colony_sz_130 colony tile updater
 *   func_00860E(col,bit)  -> func_00860E_logic_sz_15  colony bit-test
 *   func_00BEDE(a,b,c)    -> func_00BEDE_op_sz_93    map-cursor move+redraw */
PROVIDE(overlay_call_037F_02A0 = func_005E90_op_sz_64);
PROVIDE(overlay_call_05B3_0004 = func_007F34_logic_sz_27);
PROVIDE(overlay_call_05B3_01E0 = func_008110_logic_sz_14);
PROVIDE(func_006B46            = func_006B46_op_sz_365);
/* func_0069D2 -> func_0069D2_logic_sz_12 DEFERRED: wiring moves ship u3 from (8,5) to
 * (-2,-2) via func_00772E_op_sz_149's garrison-loading path, breaking the smoke baseline.
 * Root cause: func_00772E is called for navigating ships (type 0x0E, orders 0x0B), which
 * triggers the unconditional chain-head relocation.  Needs calling-context audit before
 * wiring.  Regression: u3 ends orders=0x01 prof=0x3F instead of 0x0B/0x31. */
PROVIDE(func_00A6A2            = func_00A6A2_colony_sz_130);
PROVIDE(func_00860E            = func_00860E_logic_sz_15);
PROVIDE(func_00BEDE            = func_00BEDE_op_sz_93);
EXTERN(func_005E90_op_sz_64)
EXTERN(func_006B46_op_sz_365)
EXTERN(func_00A6A2_colony_sz_130)
EXTERN(func_00860E_logic_sz_15)
EXTERN(func_00BEDE_op_sz_93)

/* Phase 4.3e (2026-06-12): next stub batch — bare-name aliases and semantic stubs.
 * Arity cross-checked; zero-arg callers fixed above.
 *
 * Bare-name -> decorated-name:
 *   func_0066CC -> func_0066CC_op_sz_57   tile-chain head (210-byte complete port)
 *
 * Resident-segment overlay stubs (non-thunk):
 *   overlay_call_037F_0142(x,y)  file 0x5D32 -> func_005D32_map_tile_read_layer_160
 *   overlay_call_024C_0040(dx,dy) file 0x4900 -> func_004900_logic_sz_15 (grid dist)
 *
 * RTLink thunk stubs:
 *   overlay_call_181F_0E1C(active) 0x181F:0xE1C -> func_067700_compose_active_tile
 *     (all callers are in unbuilt overlay files so no call-site fixes needed)
 *
 * Named semantic stub:
 *   rebel_sentiment_pct_ovl()  0x181F:0xC86 -> func_008524_colony_sz_18 (SoL %) */
PROVIDE(func_0066CC            = func_0066CC_op_sz_57);
PROVIDE(overlay_call_037F_0142 = func_005D32_map_tile_read_layer_160);
PROVIDE(overlay_call_024C_0040 = func_004900_logic_sz_15);
PROVIDE(overlay_call_181F_0E1C = func_067700_compose_active_tile);
PROVIDE(rebel_sentiment_pct_ovl = func_008524_colony_sz_18);
EXTERN(func_008524_colony_sz_18)
EXTERN(func_067700_compose_active_tile)

/* Phase 4.3h (2026-06-12): wire overlay_call_181F_0D84 -> func_046056_nearest_settlement.
 * Target is the 4-arg nearest-settlement finder: x(bp+6), y(bp+8), dir(bp+A), region(bp+C).
 * All 6 C call sites updated to pass explicit args; BYTE_VERIFIED target via EXE analysis. */
PROVIDE(overlay_call_181F_0D84 = func_046056_nearest_settlement);
EXTERN(func_046056_nearest_settlement)

/* Phase 4.3i (2026-06-12): fix linker gaps exposed by new function ports.
 *
 * func_0627BE_distance: declared extern in overlay_0612E6_066EB3.c but never defined;
 *   comment says 0x181F:0x370 = octile distance.  Alias to the existing port.
 *
 * overlay_call_181F_0998: 110 stub hits/5-turns -> menu_lookup_run (func_06F51A,
 *   already ported in src/ui/menu.c).  All call sites correctly pass 0 args. */
PROVIDE(func_0627BE_distance   = func_004900_logic_sz_15);
PROVIDE(overlay_call_181F_0998 = menu_lookup_run);
EXTERN(menu_lookup_run)
/* func_00863E bare-name -> decorated wrapper (1-arg colony-bit test via global 0x8DC6).
 * Called by func_00864E_logic_sz_31 (which func_008720 calls), and by the
 * func_00864E_count/last walkers in load_image_008262_008C6F.c. */
PROVIDE(func_00863E = func_00863E_wrapper_with_global_8DC6);
EXTERN(func_00863E_wrapper_with_global_8DC6)
