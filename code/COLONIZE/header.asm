; ============================================================================
; MZ header + relocation table
; (mechanically labeled per formats/EXE_MZ.md; not Phase 2 "identified")
; ============================================================================

0000  4D 5A      e_signature            = 0x5A4D   ; MZ
0002  E1 01      e_last_page            = 0x01E1   ; bytes used in last 512-byte page
0004  79 03      e_pages                = 0x0379   ; total 512-byte pages in image
0006  EF 23      e_relocs               = 0x23EF   ; relocation entry count
0008  00 09      e_hdr_paragraphs       = 0x0900   ; header size in 16-byte paragraphs
000A  1C 0C      e_min_alloc            = 0x0C1C   ; min extra paragraphs
000C  FF FF      e_max_alloc            = 0xFFFF   ; max extra paragraphs
000E  3A 70      e_ss                   = 0x703A   ; initial SS (segment-relative)
0010  00 20      e_sp                   = 0x2000   ; initial SP
0012  00 00      e_checksum             = 0x0000   ; header checksum
0014  18 00      e_ip                   = 0x0018   ; initial IP
0016  65 5F      e_cs                   = 0x5F65   ; initial CS (segment-relative)
0018  1E 00      e_reloc_table_offset   = 0x001E   ; file offset of relocation table
001A  00 00      e_overlay_number       = 0x0000   ; 0 = main module

; ---- Relocation table ----
; 9199 entries starting at file offset 0x001E
; Each entry: (offset, segment) — DOS adds load segment to the word
; at image[offset + segment*16] at load time.
