; ============================================================================
; MZ header + relocation table
; (mechanically labeled per formats/EXE_MZ.md; not Phase 2 "identified")
; ============================================================================

0000  4D 5A      e_signature            = 0x5A4D   ; MZ
0002  65 00      e_last_page            = 0x0065   ; bytes used in last 512-byte page
0004  04 01      e_pages                = 0x0104   ; total 512-byte pages in image
0006  D4 08      e_relocs               = 0x08D4   ; relocation entry count
0008  40 02      e_hdr_paragraphs       = 0x0240   ; header size in 16-byte paragraphs
000A  C9 0B      e_min_alloc            = 0x0BC9   ; min extra paragraphs
000C  E9 0B      e_max_alloc            = 0x0BE9   ; max extra paragraphs
000E  E5 25      e_ss                   = 0x25E5   ; initial SS (segment-relative)
0010  96 40      e_sp                   = 0x4096   ; initial SP
0012  00 00      e_checksum             = 0x0000   ; header checksum
0014  1D 07      e_ip                   = 0x071D   ; initial IP
0016  0D 11      e_cs                   = 0x110D   ; initial CS (segment-relative)
0018  1E 00      e_reloc_table_offset   = 0x001E   ; file offset of relocation table
001A  00 00      e_overlay_number       = 0x0000   ; 0 = main module

; ---- Relocation table ----
; 2260 entries starting at file offset 0x001E
; Each entry: (offset, segment) — DOS adds load segment to the word
; at image[offset + segment*16] at load time.
