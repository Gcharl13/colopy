; MAPEDIT.EXE named disasm — module TIMER_1.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @timer_read  file 0x00E786..0x00E792  seg 0xD18:0x6  (TIMER_1.C.obj) ----
  00E786  c41e7607         les bx, ptr [0x776]
  00E78A  268b07           mov ax, word ptr es:[bx]
  00E78D  268b5702         mov dx, word ptr es:[bx + 2]
  00E791  cb               retf

; ---- @timer_read_dos  file 0x00E792..0x00E7A2  seg 0xD18:0x12  (TIMER_1.C.obj) ----
  00E792  bb4000           mov bx, 0x40
  00E795  8ec3             mov es, bx
  00E797  bb6c00           mov bx, 0x6c
  00E79A  268b07           mov ax, word ptr es:[bx]
  00E79D  268b5702         mov dx, word ptr es:[bx + 2]
  00E7A1  cb               retf

; ---- @timer_read_600  file 0x00E7A2..0x00E7AA  seg 0xD18:0x22  (TIMER_1.C.obj) ----
  00E7A2  a1b650           mov ax, word ptr [0x50b6]
  00E7A5  8b16b850         mov dx, word ptr [0x50b8]
  00E7A9  cb               retf

; ---- @timer_read_60  file 0x00E7AA..0x00E7B2  seg 0xD18:0x2a  (TIMER_1.C.obj) ----
  00E7AA  a1724e           mov ax, word ptr [0x4e72]
  00E7AD  8b16744e         mov dx, word ptr [0x4e74]
  00E7B1  cb               retf

; ---- _timer_hack  file 0x00E7B2..0x00E7CC  seg 0xD18:0x32  (TIMER_1.C.obj) ----
  00E7B2  9a7d011c0d       lcall 0xd1c, 0x17d
  00E7B7  9a5d002711       lcall 0x1127, 0x5d
  00E7BC  9a00011511       lcall 0x1115, 0x100
  00E7C1  9af3011c0d       lcall 0xd1c, 0x1f3
  00E7C6  cb               retf
  00E7C7  90               nop
  00E7C8  0000             add byte ptr [bx + si], al
  00E7CA  0000             add byte ptr [bx + si], al
