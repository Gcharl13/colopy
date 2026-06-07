; ============================================================================
; MZ header + relocation table
; (mechanically labeled per formats/EXE_MZ.md; not Phase 2 "identified")
; ============================================================================

0000  4D 5A      e_signature            = 0x5A4D   ; MZ
0002  09 00      e_last_page            = 0x0009   ; bytes used in last 512-byte page
0004  E0 00      e_pages                = 0x00E0   ; total 512-byte pages in image
0006  55 05      e_relocs               = 0x0555   ; relocation entry count
0008  60 01      e_hdr_paragraphs       = 0x0160   ; header size in 16-byte paragraphs
000A  02 03      e_min_alloc            = 0x0302   ; min extra paragraphs
000C  FF 0F      e_max_alloc            = 0x0FFF   ; max extra paragraphs
000E  82 1C      e_ss                   = 0x1C82   ; initial SS (segment-relative)
0010  00 10      e_sp                   = 0x1000   ; initial SP
0012  7C 56      e_checksum             = 0x567C   ; header checksum
0014  1E 00      e_ip                   = 0x001E   ; initial IP
0016  88 13      e_cs                   = 0x1388   ; initial CS (segment-relative)
0018  1E 00      e_reloc_table_offset   = 0x001E   ; file offset of relocation table
001A  00 00      e_overlay_number       = 0x0000   ; 0 = main module

; ---- Relocation table ----
; 1365 entries starting at file offset 0x001E
; Each entry: (offset, segment) — DOS adds load segment to the word
; at image[offset + segment*16] at load time.
