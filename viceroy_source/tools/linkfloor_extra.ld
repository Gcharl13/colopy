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

/* keepalive: force archive member extraction for ported functions whose
 * strong definition would otherwise lose to the weak stubs (the archive
 * is after linkfloor_stubs.c.o on the link line, so EXTERN() is needed
 * to mark each entry as undefined before the archive sweep). */
EXTERN(ai_unit_leaf)
EXTERN(func_008734_logic_sz_30)
