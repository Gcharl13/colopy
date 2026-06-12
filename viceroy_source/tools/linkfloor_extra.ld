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
/* 0022/0416/09AE/0438 — wired in Phase 4.3k below (headless guard added). */
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
/* func_0069D2 -> func_0069D2_logic_sz_12: RESOLVED 2026-06-12.  The "garrison
 * regression" was a missing-link cascade, not a port bug: func_0069D2's place
 * half (bare-name func_00693A) bound to a weak no-op stub, so relocated units
 * were unlinked to (-1,-1) and never placed; the planner then stamped the
 * stranded unit orders=1/prof='?'.  Fixed by the two PROVIDEs below plus the
 * lifecycle.c cdecl arg-order fixes (set_head/notify had push-order copied
 * verbatim instead of reversed). */
PROVIDE(func_0069D2 = func_0069D2_logic_sz_12);
EXTERN(func_0069D2_logic_sz_12)
PROVIDE(func_00693A = func_00693A_logic_sz_14);
EXTERN(func_00693A_logic_sz_14)
/* 0x037F:0x015E resident call = file 0x5D4E: layer-160 tile mask set/clear
 * (x, y, mask, set).  Both lifecycle.c sites fixed to the cdecl arg order. */
PROVIDE(map_tile_set_head_037F_15E = func_005D4E_logic_sz_40);
EXTERN(func_005D4E_logic_sz_40)
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

/* Phase 4.3j (2026-06-12): colony screen stub wiring.
 *
 * colony_screen_init_owner(owner) -> market_set_active(power):
 *   0x181F:0x582 -> file 0x30550 = func_030550, already ported in
 *   src/market/pricing.c as market_set_active(int power).  Same body:
 *   DG16(0x9E12)=power; DG16(0x84FC)=0x8808+power*0x13C.  BYTE_VERIFIED.
 *
 * colony_misc_b82(arg) -> func_009626(arg):
 *   0x181F:0xB82 -> file 0x9626 = func_009626 (53 bytes).  Counts colonists
 *   in the current colony (ctx@0x8542) whose job (func_0090C8(i)) == arg.
 *   Ported 2026-06-12 in src/load_image/load_image_008C70_00AAB9.c.  BYTE_VERIFIED. */
PROVIDE(colony_screen_init_owner = market_set_active);
EXTERN(market_set_active)
PROVIDE(colony_misc_b82 = func_009626);
EXTERN(func_009626)

/* Phase 4.3k (2026-06-12): wire dialog chain stubs with headless guards.
 * All four targets now check `if (!g_buf_ptr_2D42_2D44) return 0/NULL` at entry,
 * so they are safe to call in headless (smoke-test) mode where the NAMES.TXT
 * string table is never loaded.  Thunk resolutions (byte-verified via whois.py):
 *   overlay_call_181F_0022 0x181F:0x0022 -> file 0x2462 = find_char_in_buffer
 *     (NUL-string-table walker; ported in src/iolib/format.c)
 *   overlay_call_181F_0416 0x181F:0x0416 -> file 0x6C220 = func_06C220_dialog_slot_set_block
 *     (per-dialog scratch-block writer; ported in overlay_06C220_06D938.c)
 *   overlay_call_181F_09AE 0x181F:0x09AE -> file 0x6C27C = func_06C27C_dialog_slot_set_pair
 *     (word-pair slot table writer; ported in overlay_06C220_06D938.c)
 *   overlay_call_181F_0438 0x181F:0x0438 -> file 0x6C23C = func_06C23C_dialog_make_from_int
 *     (build-dialog-from-int; ported in overlay_06C220_06D938.c) */
PROVIDE(overlay_call_181F_0022 = find_char_in_buffer);
EXTERN(find_char_in_buffer)
PROVIDE(overlay_call_181F_0416 = func_06C220_dialog_slot_set_block);
PROVIDE(overlay_call_181F_09AE = func_06C27C_dialog_slot_set_pair);
PROVIDE(overlay_call_181F_0438 = func_06C23C_dialog_make_from_int);

/* Phase 4.3l (2026-06-12): opt_lookup_rec (110 hits/5-turn) wired with headless guard.
 * 0x191F:0x182 -> file 0x6F0F4 = func_06F0F4_text_template_run (already ported).
 * Headless guard added at func entry: returns 0 if g_buf_ptr_2D42_2D44==NULL. */
PROVIDE(opt_lookup_rec = func_06F0F4_text_template_run);
EXTERN(func_06F0F4_text_template_run)

/* Phase 4.3n (2026-06-12): wire overlay_call_181F_0484 via existing port.
 * 0x181F:0x0484 -> resident 0B8D:0004 -> file 0x0DCD4 = func_00DCD4_op_sz_34.
 * Body: pushes 4 args [bp+6..0xC] then calls overlay_call_0B9E_000A() (now a
 * strong no-op in render_glue.c); all args are ignored by the callee.
 * Arity mismatch is safe: stub callers pass 0 args (cdecl, no-arg prototype),
 * callee reads from stack-above-ret which is garbage but never dereferenced. */
PROVIDE(overlay_call_181F_0484 = func_00DCD4_op_sz_34);
EXTERN(func_00DCD4_op_sz_34)

/* Phase 4.3q (2026-06-12): symbols exposed by the LIVE MOVE PIPELINE (the
 * ai_eval_unit stage/commit blocks byte-restored).  All targets are existing
 * BYTE_VERIFIED ports:
 *   map_tile_occupancy_id_037F_0A  (chain.c extern) 0x037F:0x000A = bounds gate
 *   overlay_call_037F_0200  file 0x5DF0 = layer-164 owner-nibble read (x,y)
 *   overlay_call_037F_02E0  file 0x5ED0 = layer-168 tile address (x,y)
 *   func_007002 / func_006FC4  bare-name near calls (chain seen-flag setters)
 *   ovly_notify_view_7D6  0x181F:0x7D6 file 0x701C = chain seen-flag walker
 *     (extern order fixed to the cdecl truth (unit, view) in unit_orders.c) */
PROVIDE(map_tile_occupancy_id_037F_0A = func_005BFA_logic_sz_49);
PROVIDE(overlay_call_037F_0200 = func_005DF0_logic_sz_40);
PROVIDE(overlay_call_037F_02E0 = func_005ED0_logic_sz_23);
EXTERN(func_005ED0_logic_sz_23)
PROVIDE(func_007002 = func_007002_logic_sz_26);
EXTERN(func_007002_logic_sz_26)
PROVIDE(func_006FC4 = func_006FC4_logic_sz_20);
EXTERN(func_006FC4_logic_sz_20)
PROVIDE(ovly_notify_view_7D6 = func_00701C_logic_sz_48);
EXTERN(func_00701C_logic_sz_48)
EXTERN(func_006FD8_logic_sz_42)
EXTERN(func_007356_logic_sz_56)
EXTERN(func_0079A0_op_sz_119)
EXTERN(func_006F5A_op_sz_105)
EXTERN(func_007936_logic_sz_48)
EXTERN(func_0078F4_logic_sz_66)
EXTERN(func_006608_logic_sz_106)
EXTERN(func_006A7C_logic_sz_50)
EXTERN(func_02EB1C_logic_sz_10)
EXTERN(func_05C878_treasure_transport_event)
EXTERN(func_002544_logic_sz_60)
EXTERN(func_002892_logic_sz_30)
EXTERN(func_00260E_tooltip_append)
EXTERN(func_002632_tooltip_append_indexed)

/* Phase 4.5 (2026-06-12): the 11 mixed data/function symbols reconciled.
 * Each was "named like DGROUP data but called like a function"; resolution
 * per symbol (byte-verified identities):
 *   colony_8542            -> STRONG getter in runtime/dgroup.c (near ptr
 *                             [0x8542] resolved to a host pointer)
 *   colony_field_C86       -> 0x181F:0xC86 = file 0x8524 SoL%% getter
 *   colony_finalize_8DC6   -> 0x181F:0x608 = file 0x2C5D4 choice commit
 *                             (ovly_commit_choice_608 = same target)
 *   colony_helper_C22      -> 0x181F:0xC22 = colony screen compositor
 *                             (strong headless no-op in render_glue.c)
 *   colony_helper_C5E      -> RESOLVED AWAY: 0x181F:0xC5E = file 0x8720 era
 *                             band int, the [bx+0x329] was a DGROUP table
 *                             read; call site fixed, extern deleted
 *   colony_misc_b82        -> wired Phase 4.3j (func_009626)
 *   g_iob_dispatch_2B18    -> DETACHED host fn-ptr in runtime/dgroup.c
 *                             (64-bit code ptr cannot live in the DGROUP
 *                             slot); call site NULL-guarded
 *   panel_helper_1E1D      -> cs:0x6E1D ljmp 0x191F:0xD9C = func_0317CC
 *                             Europe-panel painter, UNPORTED (4.6 row)
 *   panel_helper_1E6D      -> cs:0x6E6D ljmp 0x191F:0xE7C = func_0318D2
 *                             Europe-panel painter, UNPORTED (4.6 row)
 *   sol_helper_3695        -> cs:0x3695 ljmp 0x1A1F:0x7E = func_03E162
 *   unit_translate_action_8BC6 -> file 0x8BC6 = DG8(arg+0x2F5) table read */
PROVIDE(colony_field_C86 = func_008524_colony_sz_18);
PROVIDE(colony_finalize_8DC6 = func_02C5D4_colony_sz_592);
PROVIDE(ovly_commit_choice_608 = func_02C5D4_colony_sz_592);
EXTERN(func_02C5D4_colony_sz_592)
PROVIDE(colony_helper_C22 = colony_screen_compose);
PROVIDE(sol_helper_3695 = func_03E162_op_sz_145);
EXTERN(func_03E162_op_sz_145)
PROVIDE(unit_translate_action_8BC6 = func_008BC6_logic_sz_13);
EXTERN(func_008BC6_logic_sz_13)
EXTERN(func_008720)
/* riders on the same identities: sol_pct + colony_helper_C5E_count are the
 * sol_tory/auto_manage spellings of 0x181F:0xC86 / 0x181F:0xD3A */
PROVIDE(sol_pct = func_008524_colony_sz_18);
EXTERN(func_008524_colony_sz_18)
PROVIDE(colony_helper_C5E_count = func_008D00_colony_stock_cap);

/* Phase 4.1 tranche 2 (2026-06-12): machine-triaged SAFE arity rows — every
 * C call site already passes the measured arity (tools/arity_truth.py),
 * targets are existing T-symbol ports (verified via nm).  Triage script:
 * /tmp/arity_triage.py over tools/generated/thunk_arity_blocked.json. */
PROVIDE(aFldiv                = func_010496_logic_sz_154);  /* 2-arg long div */
EXTERN(func_010496_logic_sz_154)
PROVIDE(bars_draw             = func_003104_logic_sz_143);  /* 4-arg bar draw */
EXTERN(func_003104_logic_sz_143)
PROVIDE(layer_set_object      = func_005E18_op_sz_120);     /* (x,y,val) layer-164 write */
PROVIDE(ovl_fortify_accum     = func_0062B4_op_sz_39);      /* (x,y) is-sea probe */
PROVIDE(point_in_rect         = func_004B16_logic_sz_46);   /* (x,y,w,h) hit test */
EXTERN(func_004B16_logic_sz_46)
PROVIDE(select_player_ctx     = func_0082DC_logic_sz_118);  /* (id) set current colony */
PROVIDE(unit_select_for_order = func_006D24_op_sz_197);     /* 4-arg unit pick */
EXTERN(func_006D24_op_sz_197)

/* Phase 4.6 (2026-06-12): the two Europe-panel painters were ALREADY ported
 * under semantic names (military_list_panel / naval_list_panel in
 * overlay_02F3A2_031E4C.c); the panel_helper trampoline identities from the
 * 4.5 audit wire here.  cs:0x6E1D -> ljmp 0x191F:0xD9C -> file 0x317CC;
 * cs:0x6E6D -> ljmp 0x191F:0xE7C -> file 0x318D2.  Their unit-walk loops
 * are byte-fixed to the real 0x7E0/0x2E4 chain helpers (the weak-zero
 * unit_first_of_owner/unit_next pair would have looped forever). */
PROVIDE(panel_helper_1E1D = military_list_panel);
EXTERN(military_list_panel)
PROVIDE(panel_helper_1E6D = naval_list_panel);
EXTERN(naval_list_panel)

/* Phase 4.6 (2026-06-12): MSC exit() family.  0x0D1D:0x30D = file 0xF8DD;
 * every EXE call site pushes exit code 3 (fatal paths).  Strong def in
 * runtime/msc_string.c terminates like the original (the weak stub
 * RETURNED, silently continuing fatal paths).  EXTERN forces the archive
 * member out so the strong T beats the weak stub. */
EXTERN(overlay_call_0D1D_030D)

/* Phase 4.3 mass pass 1 wiring (2026-06-12): canonical thunks whose call
 * sites now ALL pass the EXE-extracted arguments (tools/arg_restore.py +
 * the safety triage).  Targets verified as T symbols via nm. */
PROVIDE(overlay_call_0D1D_0942 = func_00FF12_rtl_sz_87);
EXTERN(func_00FF12_rtl_sz_87)
PROVIDE(overlay_call_181F_00A6 = func_00273E_logic_sz_10);
EXTERN(func_00273E_logic_sz_10)
PROVIDE(overlay_call_181F_04A2 = func_0050FC_logic_sz_11);
EXTERN(func_0050FC_logic_sz_11)
PROVIDE(overlay_call_181F_04B6 = func_00513C_logic_sz_26);
EXTERN(func_00513C_logic_sz_26)
PROVIDE(overlay_call_181F_04FC = func_0051D2_logic_sz_62);
EXTERN(func_0051D2_logic_sz_62)
PROVIDE(overlay_call_181F_0AA6 = func_00994C_logic_sz_40);
EXTERN(func_00994C_logic_sz_40)
PROVIDE(overlay_call_181F_0CAE = func_00913C_logic_sz_72);
EXTERN(func_00913C_logic_sz_72)
PROVIDE(overlay_call_181F_0DC2 = func_00C07A_logic_sz_32);
EXTERN(func_00C07A_logic_sz_32)
PROVIDE(overlay_call_181F_0DD6 = func_00C09A_logic_sz_19);
EXTERN(func_00C09A_logic_sz_19)
PROVIDE(overlay_call_181F_0DEA = func_00C0D0_logic_sz_57);
EXTERN(func_00C0D0_logic_sz_57)
PROVIDE(overlay_call_181F_0EA4 = func_00C646_rtl_sz_74);
EXTERN(func_00C646_rtl_sz_74)
PROVIDE(overlay_call_191F_0F8E = func_03ADA6_rtl_sz_1362);
EXTERN(func_03ADA6_rtl_sz_1362)

/* Phase 4.3 mass pass 2 wiring (2026-06-12): next tranche of canonical
 * thunks whose sites all pass EXE-true args (triage-verified, nm-checked). */
PROVIDE(overlay_call_181F_03EA = func_005160_op_sz_45);
EXTERN(func_005160_op_sz_45)
PROVIDE(overlay_call_181F_0498 = func_0050F0_logic_sz_11);
EXTERN(func_0050F0_logic_sz_11)
PROVIDE(overlay_call_181F_05FA = func_035B06_sec_sz_118);
EXTERN(func_035B06_sec_sz_118)
PROVIDE(overlay_call_181F_07F4 = func_007A80_op_sz_143);
EXTERN(func_007A80_op_sz_143)
PROVIDE(overlay_call_181F_0844 = func_00693A_logic_sz_14);
PROVIDE(overlay_call_181F_0862 = func_0075E4_logic_sz_26);
EXTERN(func_0075E4_logic_sz_26)
PROVIDE(overlay_call_181F_097A = func_007A20_logic_sz_96);
EXTERN(func_007A20_logic_sz_96)
PROVIDE(overlay_call_181F_0A56 = func_00822A_logic_sz_36);
EXTERN(func_00822A_logic_sz_36)
PROVIDE(overlay_call_181F_0B5A = func_00887C_logic_sz_21);
EXTERN(func_00887C_logic_sz_21)
PROVIDE(overlay_call_191F_0254 = func_02EE34_logic_sz_12);
EXTERN(func_02EE34_logic_sz_12)
PROVIDE(overlay_call_191F_0A74 = func_042138_power_census);
EXTERN(func_042138_power_census)
PROVIDE(overlay_call_1A1F_022A = func_060382_tile_terrain_nibble);
EXTERN(func_060382_tile_terrain_nibble)

/* Phase 4.3 mass pass 3 wiring (2026-06-12). */
PROVIDE(overlay_call_181F_0B14 = func_008686_logic_sz_34);
EXTERN(func_008686_logic_sz_34)
PROVIDE(overlay_call_181F_0D44 = func_008982_logic_sz_532);
EXTERN(func_008982_logic_sz_532)

/* Phase 4.3 mass pass 4 wiring (2026-06-12). */
PROVIDE(overlay_call_181F_06F0 = func_005F82_logic_sz_31);
PROVIDE(overlay_call_181F_07A0 = func_006608_logic_sz_106);
PROVIDE(overlay_call_181F_084E = func_007356_logic_sz_56);
PROVIDE(overlay_call_181F_0876 = func_0075FE_logic_sz_17);
EXTERN(func_0075FE_logic_sz_17)
PROVIDE(overlay_call_181F_0B00 = func_008D9C_lookup_table_2F4_signed);
EXTERN(func_008D9C_lookup_table_2F4_signed)
PROVIDE(overlay_call_181F_0B82 = func_009626);

/* Phase 4.3 pass 5 wiring (2026-06-12). */
PROVIDE(overlay_call_02FD_006C = func_00543C_op_sz_131);
EXTERN(func_00543C_op_sz_131)
PROVIDE(overlay_call_05B3_024E = func_00817E_logic_sz_14);
EXTERN(func_00817E_logic_sz_14)
PROVIDE(overlay_call_191F_0934 = func_0694AE_cargo_select_dialog);
EXTERN(func_0694AE_cargo_select_dialog)

/* Phase 4.6 Batch A portables (2026-06-12): the full-screen refresh body at
 * file 0xC136 (uncharted interstitial), reached by TWO thunk windows. */
PROVIDE(overlay_call_181F_056A = func_00C136_screen_refresh);
PROVIDE(overlay_call_0984_04F6 = func_00C136_screen_refresh);
EXTERN(func_00C136_screen_refresh)

/* Phase 4.6 Batch B (2026-06-12): the "uncharted entry" rows re-derived via
 * the authoritative thunk records (the owner+offset arithmetic in
 * THUNK_WIRING's mid-entry table was wrong for these) -- 17 thunks whose
 * targets are EXISTING PORTS with matching call-site arity (triage-checked).
 * Mostly the COLONY-SCREEN input/panel handler family (page03). */
PROVIDE(overlay_call_181F_03D4 = func_077ADE_error_screen_teardown);
EXTERN(func_077ADE_error_screen_teardown)
PROVIDE(overlay_call_191F_0048 = func_0242AE_mouse_region);
EXTERN(func_0242AE_mouse_region)
PROVIDE(overlay_call_191F_0182 = func_06F0F4_text_template_run);
PROVIDE(overlay_call_191F_0436 = func_06F698_fmt_pair_into_9CC8);
EXTERN(func_06F698_fmt_pair_into_9CC8)
PROVIDE(overlay_call_191F_0570 = func_02B9DC_op_sz_72);
EXTERN(func_02B9DC_op_sz_72)
PROVIDE(overlay_call_191F_0588 = func_02AFCE_logic_sz_41);
EXTERN(func_02AFCE_logic_sz_41)
PROVIDE(overlay_call_191F_0624 = func_02A31C_header_selector);
EXTERN(func_02A31C_header_selector)
PROVIDE(overlay_call_191F_063C = func_029C10_colony_input_tick);
EXTERN(func_029C10_colony_input_tick)
PROVIDE(overlay_call_191F_0678 = func_02B744_colony_sz_24);
EXTERN(func_02B744_colony_sz_24)
PROVIDE(overlay_call_191F_06CC = func_0299A0_colony_hit_region);
EXTERN(func_0299A0_colony_hit_region)
PROVIDE(overlay_call_191F_0744 = func_02BB8A_logic_sz_106);
EXTERN(func_02BB8A_logic_sz_106)
PROVIDE(overlay_call_191F_0768 = func_029D24_commodity_legend);
EXTERN(func_029D24_commodity_legend)
PROVIDE(overlay_call_191F_0798 = func_027BB6_colony_buildings_panel);
EXTERN(func_027BB6_colony_buildings_panel)
PROVIDE(overlay_call_191F_07A4 = func_02A0BC_assign_work_tile);
EXTERN(func_02A0BC_assign_work_tile)
PROVIDE(overlay_call_191F_07E0 = func_029AC0_colonist_slot_hit);
EXTERN(func_029AC0_colonist_slot_hit)
PROVIDE(overlay_call_191F_0810 = func_029DD4_colony_click_router);
EXTERN(func_029DD4_colony_click_router)
PROVIDE(overlay_call_1A1F_0806 = func_064266_walk_stamp_blob);
EXTERN(func_064266_walk_stamp_blob)

/* Phase 4.3 pass 6 wiring (2026-06-12). str_append = the file-0x28B0
 * append-space wrapper (overlay_02F3A2's spelling; sites pass the buffer). */
PROVIDE(overlay_call_029F_0318 = func_005108_op_sz_51);
PROVIDE(overlay_call_181F_048E = func_0050BC_op_sz_51);
EXTERN(func_0050BC_op_sz_51)
PROVIDE(str_append = func_0028B0_append_space);
EXTERN(func_0028B0_append_space)

/* Phase 4.6 Batch C (2026-06-12): canonical thunk spellings of already-
 * implemented bodies (all C sites 0-arg, targets void/no-arg). */
PROVIDE(overlay_call_181F_0C22 = colony_screen_compose);
PROVIDE(overlay_call_181F_059A = func_066BB0_prep);

/* Phase 4.3 pass 7 wiring (2026-06-12): weak canonicals whose sites now all
 * pass EXE-true args (post near-match-extended).  0736/06A0 are the layer
 * far-addr helpers; their two C sites DISCARD the result (locals the port
 * never consumed), so the int-truncation of the host pointer is inert. */
PROVIDE(overlay_call_181F_0638 = func_052F7E_ai_power_asset_census);
EXTERN(func_052F7E_ai_power_asset_census)
PROVIDE(overlay_call_181F_06A0 = func_005D84_logic_sz_23);
EXTERN(func_005D84_logic_sz_23)
PROVIDE(overlay_call_181F_0736 = func_005ED0_logic_sz_23);
PROVIDE(overlay_call_191F_0AD4 = func_06F5DA_opt_set_field_a_const8);
EXTERN(func_06F5DA_opt_set_field_a_const8)
PROVIDE(overlay_call_1A1F_0814 = func_06436C_walk_write_thin);
EXTERN(func_06436C_walk_write_thin)
PROVIDE(overlay_call_1A1F_085A = func_0641EC_walk_stamp_range);
EXTERN(func_0641EC_walk_stamp_range)

/* Phase 4.6 bare-name alias sweep (2026-06-12): BODY-MISSING rows that are
 * bare hex spellings of EXISTING _sz_N ports -- guarded (canonical decoration
 * of the SAME hex base, unique candidate) + arity-triaged (every C call site
 * passes the port's exact param count).  23 rows. */
PROVIDE(func_006E94 = func_006E94_logic_sz_198);
PROVIDE(func_00768C = func_00768C_logic_sz_161);
EXTERN(func_00768C_logic_sz_161)
PROVIDE(func_007A80 = func_007A80_op_sz_143);
PROVIDE(func_007BE8 = func_007BE8_op_sz_66);
EXTERN(func_007BE8_op_sz_66)
PROVIDE(func_007C2A = func_007C2A_logic_sz_46);
EXTERN(func_007C2A_logic_sz_46)
PROVIDE(func_007F34 = func_007F34_logic_sz_27);
PROVIDE(func_007F62 = func_007F62_logic_sz_30);
EXTERN(func_007F62_logic_sz_30)
PROVIDE(func_0084C8 = func_0084C8_logic_sz_19);
EXTERN(func_0084C8_logic_sz_19)
PROVIDE(func_00864E = func_00864E_logic_sz_31);
EXTERN(func_00864E_logic_sz_31)
PROVIDE(func_0087F4 = func_0087F4_logic_sz_18);
EXTERN(func_0087F4_logic_sz_18)
PROVIDE(func_008D00 = func_008D00_colony_stock_cap);
PROVIDE(func_00975A = func_00975A_logic_sz_25);
EXTERN(func_00975A_logic_sz_25)
PROVIDE(func_009786 = func_009786_logic_sz_12);
EXTERN(func_009786_logic_sz_12)
PROVIDE(func_0098F6 = func_0098F6_logic_sz_85);
EXTERN(func_0098F6_logic_sz_85)
PROVIDE(func_00B2A2 = func_00B2A2_cargo_slot_good);
EXTERN(func_00B2A2_cargo_slot_good)
PROVIDE(func_00B2F0 = func_00B2F0_cargo_slot_amount);
EXTERN(func_00B2F0_cargo_slot_amount)
PROVIDE(func_00B900 = func_00B900_colony_sz_618);
EXTERN(func_00B900_colony_sz_618)
PROVIDE(func_00BF3C = func_00BF3C_logic_sz_182);
PROVIDE(func_010B26 = func_010B26_logic_sz_149);
EXTERN(func_010B26_logic_sz_149)
PROVIDE(func_010CA0 = func_010CA0_rtl_sz_44);
EXTERN(func_010CA0_rtl_sz_44)
PROVIDE(func_010E66 = func_010E66_rtl_sz_116);
EXTERN(func_010E66_rtl_sz_116)
PROVIDE(func_010EE2 = func_010EE2_rtl_sz_75);
EXTERN(func_010EE2_rtl_sz_75)
PROVIDE(func_01146A = func_01146A_logic_sz_122);
EXTERN(func_01146A_logic_sz_122)

/* Phase 4.7 detached-globals sweep (2026-06-12): weak-stub VARIABLES
 * aliased to their byte-cited DGROUP homes (the silent-divergence class
 * G1 caught live in automove).  g_wXXXX names encode their own offsets;
 * the rest carry the offset in their extern decl comments. */
PROVIDE(g_w0070 = g_dgroup + 0x70);  /* name-encoded */
PROVIDE(g_snd_A0 = g_dgroup + 0xa0);  /* decl-cited */
PROVIDE(g_snd_A2 = g_dgroup + 0xa2);  /* decl-cited */
PROVIDE(g_snd_A4 = g_dgroup + 0xa4);  /* decl-cited */
PROVIDE(g_layer_terrain = g_dgroup + 0x15c);  /* decl-cited */
PROVIDE(g_layer_elev = g_dgroup + 0x160);  /* decl-cited */
PROVIDE(g_w0334 = g_dgroup + 0x334);  /* name-encoded */
PROVIDE(g_w0340 = g_dgroup + 0x340);  /* name-encoded */
PROVIDE(g_w0342 = g_dgroup + 0x342);  /* name-encoded */
PROVIDE(g_w0344 = g_dgroup + 0x344);  /* name-encoded */
PROVIDE(g_w0348 = g_dgroup + 0x348);  /* name-encoded */
PROVIDE(g_w034A = g_dgroup + 0x34a);  /* name-encoded */
PROVIDE(g_w034E = g_dgroup + 0x34e);  /* name-encoded */
PROVIDE(g_w0890 = g_dgroup + 0x890);  /* name-encoded */
PROVIDE(g_menubar_off = g_dgroup + 0x896);  /* decl-cited */
PROVIDE(g_menubar_seg = g_dgroup + 0x898);  /* decl-cited */
PROVIDE(g_w0B98 = g_dgroup + 0xb98);  /* name-encoded */
PROVIDE(g_w0D04 = g_dgroup + 0xd04);  /* name-encoded */
PROVIDE(g_lcr_attempts = g_dgroup + 0x1dc6);  /* decl-cited */
PROVIDE(g_lcr_good_results = g_dgroup + 0x1dc7);  /* decl-cited */
PROVIDE(g_w1F5E = g_dgroup + 0x1f5e);  /* name-encoded */
PROVIDE(g_w1F66 = g_dgroup + 0x1f66);  /* name-encoded */
PROVIDE(g_w1F68 = g_dgroup + 0x1f68);  /* name-encoded */
PROVIDE(g_file_flags = g_dgroup + 0x27bb);  /* decl-cited */
PROVIDE(g_region_2DA8c = g_dgroup + 0x2da8);  /* decl-cited */
PROVIDE(g_rpt_str = g_dgroup + 0x2dee);  /* decl-cited */
PROVIDE(g_unit_records = g_dgroup + 0x3144);  /* decl-cited */
PROVIDE(g_w5372 = g_dgroup + 0x5372);  /* name-encoded */
PROVIDE(g_turn_counter = g_dgroup + 0x538e);  /* decl-cited */
PROVIDE(g_season = g_dgroup + 0x5390);  /* decl-cited */
PROVIDE(g_current_nation = g_dgroup + 0x5394);  /* decl-cited */
PROVIDE(g_active_player_idx = g_dgroup + 0x5396);  /* decl-cited */
PROVIDE(g_w539C = g_dgroup + 0x539c);  /* name-encoded */
PROVIDE(g_w53A0 = g_dgroup + 0x53a0);  /* name-encoded */
PROVIDE(g_w53C2 = g_dgroup + 0x53c2);  /* name-encoded */
PROVIDE(g_native_settlements = g_dgroup + 0x54ec);  /* decl-cited */
PROVIDE(g_dialog_rect = g_dgroup + 0x839e);  /* decl-cited */
PROVIDE(g_active_colony = g_dgroup + 0x8542);  /* decl-cited */
PROVIDE(g_active_colony_ptr = g_dgroup + 0x8542);  /* decl-cited */
PROVIDE(g_power_records = g_dgroup + 0x8808);  /* decl-cited */
PROVIDE(g_w8D58 = g_dgroup + 0x8d58);  /* name-encoded */
PROVIDE(g_w8D5A = g_dgroup + 0x8d5a);  /* name-encoded */
PROVIDE(g_w8D5C = g_dgroup + 0x8d5c);  /* name-encoded */
PROVIDE(g_w8D5E = g_dgroup + 0x8d5e);  /* name-encoded */
PROVIDE(g_w8D60 = g_dgroup + 0x8d60);  /* name-encoded */
PROVIDE(g_w8D72 = g_dgroup + 0x8d72);  /* name-encoded */
PROVIDE(g_w8D76 = g_dgroup + 0x8d76);  /* name-encoded */
PROVIDE(g_w8D78 = g_dgroup + 0x8d78);  /* name-encoded */
PROVIDE(g_w8D7A = g_dgroup + 0x8d7a);  /* name-encoded */
PROVIDE(g_w8D7C = g_dgroup + 0x8d7c);  /* name-encoded */
PROVIDE(g_w8DE4 = g_dgroup + 0x8de4);  /* name-encoded */
PROVIDE(g_w8DE6 = g_dgroup + 0x8de6);  /* name-encoded */
PROVIDE(g_w8F8E = g_dgroup + 0x8f8e);  /* name-encoded */
PROVIDE(g_w8F9A = g_dgroup + 0x8f9a);  /* name-encoded */

/* Phase 4.7 globals residue (2026-06-12): */
PROVIDE(g_ai_personality = g_dgroup + 0x540E);  /* stride 0x34; +0x31 == [0x543F] cite */
PROVIDE(g_power_name_tbl = g_dgroup + 0x838C);  /* [bx-0x7C74] with bx=power*2 -> base 0x838C */
PROVIDE(g_metric_tbl_minus = g_dgroup + 0x941C);     /* base -0x6BE4 */
PROVIDE(g_powerflag_8808_minus = g_dgroup + 0x8808); /* idx*0x13C - 0x77F8 -> PowerRecord */

/* Phase 4.7 role-name sweep (2026-06-12): decl-cited thunk identities,
 * whois-resolved to existing ports, every site arity-checked. */
PROVIDE(ov_colony_select = func_0082DC_logic_sz_118);
PROVIDE(ov_strbuf_init2 = func_06C220_dialog_slot_set_block);
PROVIDE(ov_strbuf_init = func_06C220_dialog_slot_set_block);
PROVIDE(ov_report_dispatch = func_076B9E_write_record_fields_7);
EXTERN(func_076B9E_write_record_fields_7)
PROVIDE(ov_unit_cargo_query = func_00B2A2_cargo_slot_good);
PROVIDE(ov_unit_stat_format = func_06C23C_dialog_make_from_int);
PROVIDE(ovly_name_word_A2E = func_0081A4_logic_sz_28);
EXTERN(func_0081A4_logic_sz_28)
PROVIDE(ovly_terrain_id_6B4 = func_005DBA_logic_sz_17);
PROVIDE(ovly_tile_ability_72C = func_005CFE_map_tile_read_layer_15C);
PROVIDE(ovly_tile_ability_754 = func_005D32_map_tile_read_layer_160);
PROVIDE(ovly_tile_kind_78C = func_00627A_op_sz_57);
EXTERN(func_00627A_op_sz_57)
PROVIDE(ovly_tile_occupied_768 = func_0062B4_op_sz_39);
PROVIDE(ovly_tile_query_7E0 = func_0066CC_op_sz_57);

/* Phase 4.7 Europe-trade trampolines (2026-06-12): the cs:0x6Dxx/0x6Exx
 * ljmp table at file 0x36813 (cs-base 0x2FAF0) decoded entry-by-entry;
 * 10 targets are existing ports with extern-decl arity == port arity.
 * (Case note: the C externs are near_6Dxx UPPERCASE-hex.) */
PROVIDE(near_6D28 = func_03234A);
EXTERN(func_03234A)
PROVIDE(near_6D5F = func_032FE2);
EXTERN(func_032FE2)
PROVIDE(near_6D8C = func_03334E);
EXTERN(func_03334E)
PROVIDE(near_6D91 = func_0322D0);
EXTERN(func_0322D0)
PROVIDE(near_6DC8 = func_03342C);
EXTERN(func_03342C)
PROVIDE(near_6DE6 = func_032914);
EXTERN(func_032914)
PROVIDE(near_6E0E = func_0320EE);
EXTERN(func_0320EE)
PROVIDE(near_6E27 = func_032122);
EXTERN(func_032122)
PROVIDE(near_6E77 = func_0335FA);
EXTERN(func_0335FA)
PROVIDE(near_6E7C = func_0321FC);
EXTERN(func_0321FC)
