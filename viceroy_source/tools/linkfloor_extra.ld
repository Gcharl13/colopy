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
