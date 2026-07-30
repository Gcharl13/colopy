; MAPEDIT.EXE named disasm — module PACK_2.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- PACK_WRITE_MEMORY  file 0x014C0A..0x014C78  seg 0x1360:0xa  (PACK_2.C.obj) ----
  014C0A  55               push bp
  014C0B  8bec             mov bp, sp
  014C0D  57               push di
  014C0E  56               push si
  014C0F  c47e06           les di, ptr [bp + 6]
  014C12  268b0d           mov cx, word ptr es:[di]
  014C15  a1844a           mov ax, word ptr [0x4a84]
  014C18  8b16864a         mov dx, word ptr [0x4a86]
  014C1C  83faff           cmp dx, -1
  014C1F  741c             je 0x14c3d
  014C21  50               push ax
  014C22  0bc2             or ax, dx
  014C24  58               pop ax
  014C25  7436             je 0x14c5d
  014C27  0bd2             or dx, dx
  014C29  7506             jne 0x14c31
  014C2B  3bc8             cmp cx, ax
  014C2D  7602             jbe 0x14c31
  014C2F  8bc8             mov cx, ax
  014C31  2bc1             sub ax, cx
  014C33  83da00           sbb dx, 0
  014C36  a3844a           mov word ptr [0x4a84], ax
  014C39  8916864a         mov word ptr [0x4a86], dx
  014C3D  010e8469         add word ptr [0x6984], cx
  014C41  8316866900       adc word ptr [0x6986], 0
  014C46  8bc1             mov ax, cx
  014C48  0bc9             or cx, cx
  014C4A  7411             je 0x14c5d
  014C4C  1e               push ds
  014C4D  c43e9e5a         les di, ptr [0x5a9e]
  014C51  c5760a           lds si, ptr [bp + 0xa]
  014C54  f3a4             rep movsb byte ptr es:[di], byte ptr [si]
  014C56  8bd7             mov dx, di
  014C58  1f               pop ds
  014C59  89169e5a         mov word ptr [0x5a9e], dx
  014C5D  ff36a05a         push word ptr [0x5aa0]
  014C61  ff369e5a         push word ptr [0x5a9e]
  014C65  9a02004f10       lcall 0x104f, 2
  014C6A  a39e5a           mov word ptr [0x5a9e], ax
  014C6D  8916a05a         mov word ptr [0x5aa0], dx
  014C71  5e               pop si
  014C72  5f               pop di
  014C73  c9               leave
  014C74  ca0800           retf 8
  014C77  90               nop
