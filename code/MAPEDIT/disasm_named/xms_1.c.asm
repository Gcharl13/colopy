; MAPEDIT.EXE named disasm — module xms_1.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @xms_detect  file 0x01096A..0x0109EC  seg 0xF36:0xa  (xms_1.c.obj) ----
  01096A  c8040000         enter 4, 0
  01096E  c706683c0000     mov word ptr [0x3c68], 0
  010974  833e6a3c00       cmp word ptr [0x3c6a], 0
  010979  752a             jne 0x109a5
  01097B  b80043           mov ax, 0x4300
  01097E  cd2f             int 0x2f
  010980  3c80             cmp al, 0x80
  010982  7521             jne 0x109a5
  010984  b81043           mov ax, 0x4310
  010987  cd2f             int 0x2f
  010989  891e6c3c         mov word ptr [0x3c6c], bx
  01098D  8c066e3c         mov word ptr [0x3c6e], es
  010991  32e4             xor ah, ah
  010993  ff1e6c3c         lcall [0x3c6c]
  010997  a30853           mov word ptr [0x5308], ax
  01099A  3d0002           cmp ax, 0x200
  01099D  7206             jb 0x109a5
  01099F  c706683cffff     mov word ptr [0x3c68], 0xffff
  0109A5  c7066207ffff     mov word ptr [0x762], 0xffff
  0109AB  c7066407ffff     mov word ptr [0x764], 0xffff
  0109B1  c6064a0700       mov byte ptr [0x74a], 0
  0109B6  833e683c00       cmp word ptr [0x3c68], 0
  0109BB  742a             je 0x109e7
  0109BD  6a00             push 0
  0109BF  6a01             push 1
  0109C1  9a08008112       lcall 0x1281, 8
  0109C6  83c404           add sp, 4
  0109C9  8946fc           mov word ptr [bp - 4], ax
  0109CC  8956fe           mov word ptr [bp - 2], dx
  0109CF  0bd0             or dx, ax
  0109D1  7414             je 0x109e7
  0109D3  c446fc           les ax, ptr [bp - 4]
  0109D6  8cc0             mov ax, es
  0109D8  48               dec ax
  0109D9  a3703c           mov word ptr [0x3c70], ax
  0109DC  ff76fe           push word ptr [bp - 2]
  0109DF  ff76fc           push word ptr [bp - 4]
  0109E2  9a4a008112       lcall 0x1281, 0x4a
  0109E7  a1683c           mov ax, word ptr [0x3c68]
  0109EA  c9               leave
  0109EB  cb               retf
