; MAPEDIT.EXE named disasm — module sound_2.ASM.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _SOUND_SYSTEM_SETUP  file 0x012870..0x012874  seg 0x1127:0x0  (sound_2.ASM.obj) ----
  012870  ff2e2a60         ljmp [0x602a]

; ---- _sound_queue  file 0x012874..0x01289B  seg 0x1127:0x4  (sound_2.ASM.obj) ----
  012874  803e374400       cmp byte ptr [0x4437], 0
  012879  7504             jne 0x1287f
  01287B  ff2e2e60         ljmp [0x602e]
  01287F  a03644           mov al, byte ptr [0x4436]
  012882  3c08             cmp al, 8
  012884  7314             jae 0x1289a
  012886  98               cwde
  012887  8bd8             mov bx, ax
  012889  d1e3             shl bx, 1
  01288B  55               push bp
  01288C  8bec             mov bp, sp
  01288E  8b4606           mov ax, word ptr [bp + 6]
  012891  89872644         mov word ptr [bx + 0x4426], ax
  012895  fe063644         inc byte ptr [0x4436]
  012899  5d               pop bp
  01289A  cb               retf

; ---- _SOUND_QUEUE_HOLD  file 0x01289B..0x0128A1  seg 0x1127:0x2b  (sound_2.ASM.obj) ----
  01289B  c6063744ff       mov byte ptr [0x4437], 0xff
  0128A0  cb               retf

; ---- _SOUND_QUEUE_FLUSH  file 0x0128A1..0x0128C9  seg 0x1127:0x31  (sound_2.ASM.obj) ----
  0128A1  c606374400       mov byte ptr [0x4437], 0
  0128A6  8a0e3644         mov cl, byte ptr [0x4436]
  0128AA  32ed             xor ch, ch
  0128AC  e315             jcxz 0x128c3
  0128AE  33db             xor bx, bx
  0128B0  53               push bx
  0128B1  51               push cx
  0128B2  ffb72644         push word ptr [bx + 0x4426]
  0128B6  9a04002711       lcall 0x1127, 4
  0128BB  58               pop ax
  0128BC  59               pop cx
  0128BD  5b               pop bx
  0128BE  83c302           add bx, 2
  0128C1  e2ed             loop 0x128b0
  0128C3  c606364400       mov byte ptr [0x4436], 0
  0128C8  cb               retf

; ---- _sound_system_shutdown  file 0x0128C9..0x0128CD  seg 0x1127:0x59  (sound_2.ASM.obj) ----
  0128C9  ff2e3260         ljmp [0x6032]

; ---- _sound_manager  file 0x0128CD..0x0128D1  seg 0x1127:0x5d  (sound_2.ASM.obj) ----
  0128CD  ff2e3660         ljmp [0x6036]

; ---- _SOUND_MAKE_NOISE  file 0x0128D1..0x0128D6  seg 0x1127:0x61  (sound_2.ASM.obj) ----
  0128D1  ff2e3a60         ljmp [0x603a]
  0128D5  00               .byte 0x00
