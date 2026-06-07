; ============================================================================
; MZ header + relocation table
; (mechanically labeled per formats/EXE_MZ.md; not Phase 2 "identified")
; ============================================================================

0000  4D 5A      e_signature            = 0x5A4D   ; MZ
0002  C7 00      e_last_page            = 0x00C7   ; bytes used in last 512-byte page
0004  84 00      e_pages                = 0x0084   ; total 512-byte pages in image
0006  98 02      e_relocs               = 0x0298   ; relocation entry count
0008  C0 00      e_hdr_paragraphs       = 0x00C0   ; header size in 16-byte paragraphs
000A  EF 03      e_min_alloc            = 0x03EF   ; min extra paragraphs
000C  FF 0F      e_max_alloc            = 0x0FFF   ; max extra paragraphs
000E  9B 11      e_ss                   = 0x119B   ; initial SS (segment-relative)
0010  00 20      e_sp                   = 0x2000   ; initial SP
0012  CF 12      e_checksum             = 0x12CF   ; header checksum
0014  5C 01      e_ip                   = 0x015C   ; initial IP
0016  52 04      e_cs                   = 0x0452   ; initial CS (segment-relative)
0018  1E 00      e_reloc_table_offset   = 0x001E   ; file offset of relocation table
001A  00 00      e_overlay_number       = 0x0000   ; 0 = main module

; ---- Relocation table ----
; 664 entries starting at file offset 0x001E
; Each entry: (offset, segment) — DOS adds load segment to the word
; at image[offset + segment*16] at load time.
