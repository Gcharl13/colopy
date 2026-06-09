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
