; MAPEDIT.EXE named disasm — module mcga_b.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @mcga_retrace  file 0x011C1A..0x011C2E  seg 0x1061:0xa  (mcga_b.c.obj) ----
  011C1A  55               push bp
  011C1B  8bec             mov bp, sp
  011C1D  bada03           mov dx, 0x3da
  011C20  b408             mov ah, 8
  011C22  ec               in al, dx
  011C23  22c4             and al, ah
  011C25  75fb             jne 0x11c22
  011C27  ec               in al, dx
  011C28  22c4             and al, ah
  011C2A  74fb             je 0x11c27
  011C2C  c9               leave
  011C2D  cb               retf

; ---- @mcga_setpal_range  file 0x011C2E..0x011C96  seg 0x1061:0x1e  (mcga_b.c.obj) ----
  011C2E  c8040000         enter 4, 0
  011C32  52               push dx
  011C33  50               push ax
  011C34  57               push di
  011C35  56               push si
  011C36  8bc8             mov cx, ax
  011C38  d1e0             shl ax, 1
  011C3A  03c1             add ax, cx
  011C3C  8946fe           mov word ptr [bp - 2], ax
  011C3F  8bc2             mov ax, dx
  011C41  d1e2             shl dx, 1
  011C43  03d0             add dx, ax
  011C45  8956fc           mov word ptr [bp - 4], dx
  011C48  c706b63affff     mov word ptr [0x3ab6], 0xffff
  011C4E  8b1eb43a         mov bx, word ptr [0x3ab4]
  011C52  8b7efc           mov di, word ptr [bp - 4]
  011C55  1e               push ds
  011C56  c57606           lds si, ptr [bp + 6]
  011C59  0376fe           add si, word ptr [bp - 2]
  011C5C  bac803           mov dx, 0x3c8
  011C5F  8b46f8           mov ax, word ptr [bp - 8]
  011C62  ee               out dx, al
  011C63  42               inc dx
  011C64  52               push dx
  011C65  bada03           mov dx, 0x3da
  011C68  b408             mov ah, 8
  011C6A  ec               in al, dx
  011C6B  22c4             and al, ah
  011C6D  75fb             jne 0x11c6a
  011C6F  ec               in al, dx
  011C70  22c4             and al, ah
  011C72  74fb             je 0x11c6f
  011C74  fa               cli
  011C75  5a               pop dx
  011C76  8bcf             mov cx, di
  011C78  3bcb             cmp cx, bx
  011C7A  7602             jbe 0x11c7e
  011C7C  8bcb             mov cx, bx
  011C7E  51               push cx
  011C7F  6e               outsb dx, byte ptr [si]
  011C80  e2fd             loop 0x11c7f
  011C82  fb               sti
  011C83  59               pop cx
  011C84  2bf9             sub di, cx
  011C86  75dc             jne 0x11c64
  011C88  1f               pop ds
  011C89  c706b63a0000     mov word ptr [0x3ab6], 0
  011C8F  5e               pop si
  011C90  5f               pop di
  011C91  c9               leave
  011C92  ca0400           retf 4
  011C95  90               nop
