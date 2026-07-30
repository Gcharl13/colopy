; MAPEDIT.EXE named disasm — module mcga_7.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @mcga_setpal  file 0x00ED0A..0x00ED5E  seg 0xD70:0xa  (mcga_7.c.obj) ----
  00ED0A  55               push bp
  00ED0B  8bec             mov bp, sp
  00ED0D  57               push di
  00ED0E  56               push si
  00ED0F  c706b63a0100     mov word ptr [0x3ab6], 1
  00ED15  8b1eb43a         mov bx, word ptr [0x3ab4]
  00ED19  bf0003           mov di, 0x300
  00ED1C  1e               push ds
  00ED1D  c57606           lds si, ptr [bp + 6]
  00ED20  bac803           mov dx, 0x3c8
  00ED23  32c0             xor al, al
  00ED25  ee               out dx, al
  00ED26  42               inc dx
  00ED27  52               push dx
  00ED28  bada03           mov dx, 0x3da
  00ED2B  b408             mov ah, 8
  00ED2D  ec               in al, dx
  00ED2E  22c4             and al, ah
  00ED30  75fb             jne 0xed2d
  00ED32  ec               in al, dx
  00ED33  22c4             and al, ah
  00ED35  74fb             je 0xed32
  00ED37  fa               cli
  00ED38  5a               pop dx
  00ED39  8bcf             mov cx, di
  00ED3B  3bcb             cmp cx, bx
  00ED3D  7602             jbe 0xed41
  00ED3F  8bcb             mov cx, bx
  00ED41  51               push cx
  00ED42  6e               outsb dx, byte ptr [si]
  00ED43  eb01             jmp 0xed46
  00ED45  90               nop
  00ED46  eb00             jmp 0xed48
  00ED48  e2f8             loop 0xed42
  00ED4A  fb               sti
  00ED4B  59               pop cx
  00ED4C  2bf9             sub di, cx
  00ED4E  75d7             jne 0xed27
  00ED50  1f               pop ds
  00ED51  c706b63a0000     mov word ptr [0x3ab6], 0
  00ED57  5e               pop si
  00ED58  5f               pop di
  00ED59  c9               leave
  00ED5A  ca0400           retf 4
  00ED5D  90               nop
