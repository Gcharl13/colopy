; MAPEDIT.EXE named disasm — module atox.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __catox  file 0x016CF6..0x016D4A  seg 0x1388:0x1e76  (atox.asm.obj) ----
  016CF6  55               push bp
  016CF7  8bec             mov bp, sp
  016CF9  57               push di
  016CFA  56               push si
  016CFB  8b7606           mov si, word ptr [bp + 6]
  016CFE  33c0             xor ax, ax
  016D00  99               cdq
  016D01  33db             xor bx, bx
  016D03  ac               lodsb al, byte ptr [si]
  016D04  3c20             cmp al, 0x20
  016D06  74fb             je 0x16d03
  016D08  3c09             cmp al, 9
  016D0A  74f7             je 0x16d03
  016D0C  50               push ax
  016D0D  3c2d             cmp al, 0x2d
  016D0F  7404             je 0x16d15
  016D11  3c2b             cmp al, 0x2b
  016D13  7501             jne 0x16d16
  016D15  ac               lodsb al, byte ptr [si]
  016D16  3c39             cmp al, 0x39
  016D18  771f             ja 0x16d39
  016D1A  2c30             sub al, 0x30
  016D1C  721b             jb 0x16d39
  016D1E  d1e3             shl bx, 1
  016D20  d1d2             rcl dx, 1
  016D22  8bcb             mov cx, bx
  016D24  8bfa             mov di, dx
  016D26  d1e3             shl bx, 1
  016D28  d1d2             rcl dx, 1
  016D2A  d1e3             shl bx, 1
  016D2C  d1d2             rcl dx, 1
  016D2E  03d9             add bx, cx
  016D30  13d7             adc dx, di
  016D32  03d8             add bx, ax
  016D34  83d200           adc dx, 0
  016D37  ebdc             jmp 0x16d15
  016D39  58               pop ax
  016D3A  3c2d             cmp al, 0x2d
  016D3C  93               xchg bx, ax
  016D3D  7507             jne 0x16d46
  016D3F  f7d8             neg ax
  016D41  83d200           adc dx, 0
  016D44  f7da             neg dx
  016D46  5e               pop si
  016D47  5f               pop di
  016D48  5d               pop bp
  016D49  cb               retf
