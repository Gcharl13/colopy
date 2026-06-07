# Tools Triage

Classification of existing scripts in the project's top-level `tools/` directory
and what's reusable for `reverse_engineered/tools/`. Anything that touches
`colowin/` (Win16) or `colonize_sdl/` (the Python port) is out of scope.

| Script | Disposition | Notes |
|--------|-------------|-------|
| `tools/madspack.py` | **REUSE** | Standalone MADSPACK 2.0 decompressor. Outer container for `.SS`, `.PIK`, `.FF`. Production-ready. |
| `tools/extract_all.py` | **REUSE-PARSER** | Lift the parsing kernels: `load_palette` (VGA 6-bit), `madspack_decompress`, `fab_decompress*`, `extract_ss_file`, `extract_pik_file`. Wrap the I/O ourselves with our naming + sidecar JSON. |
| `tools/disassemble_viceroy.py` | **REUSE-PARSER** | Capstone x86-16 with `KNOWN_STRIDES` / `KNOWN_GLOBALS`. Lift `find_functions` and `disassemble_function`; rebuild the output layer to match `code/<EXE>/disasm/` per-function file convention. |
| `tools/disasm_full.py` | **REUSE-PARSER** | Variant with ENTER/LEAVE prologue detection. Use as a second source for function boundaries. |
| `tools/viceroy_audit.py` | **REFERENCE** | Read-only static audit; useful as a reference for what was previously identified, but not part of the new pipeline. |
| `tools/extract_with_mpskit.py` | **OPTIONAL** | Wrapper for external `mpskit` CLI. Useful as a cross-check on MADSPACK output, not required. |
| `tools/extract_sprites_v2.py` | **IGNORE** | Win16 coldata DLL extraction. Out of scope. |
| `tools/extract_all_coldata.py` | **IGNORE** | Win16 coldata DLL extraction. Out of scope. |
| `tools/extract_dialogs.py` | **IGNORE** | Win16 RT_DIALOG. Out of scope. |
| `tools/render_test.py` | **IGNORE** | Drives `colonize_sdl/`. Out of scope. |
| `tools/coast_test.py` | **IGNORE** | Drives `colonize_sdl/`. Out of scope. |

## Dependencies

- **capstone** — x86-16 real-mode disassembly.
- **pillow (PIL)** — PNG output, palette images.
- **struct** — stdlib, binary unpacking.

## Plan

For Phase 1, lift the kernels above (we won't import the existing scripts
directly to keep the new tree self-contained, but we can copy specific
functions with a comment citing their source). New tools to write fresh:
`disasm_mz.py`, `extract_strings.py`, `asset_xref_scan.py`,
`ledger_update.py`, `lint_naming.py`.
