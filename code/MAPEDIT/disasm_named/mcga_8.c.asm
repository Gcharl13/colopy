; MAPEDIT.EXE named disasm — module mcga_8.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @mcga_getpal  file 0x011BCA..0x011C1A  seg 0x105C:0xa  (mcga_8.c.obj) ----
  011BCA  55               push bp
  011BCB  8bec             mov bp, sp
  011BCD  57               push di
  011BCE  56               push si
  011BCF  c706b63a0100     mov word ptr [0x3ab6], 1
  011BD5  bb4000           mov bx, 0x40
  011BD8  be0003           mov si, 0x300
  011BDB  c47e06           les di, ptr [bp + 6]
  011BDE  bac703           mov dx, 0x3c7
  011BE1  32c0             xor al, al
  011BE3  ee               out dx, al
  011BE4  bada03           mov dx, 0x3da
  011BE7  b408             mov ah, 8
  011BE9  ec               in al, dx
  011BEA  22c4             and al, ah
  011BEC  75fb             jne 0x11be9
  011BEE  ec               in al, dx
  011BEF  22c4             and al, ah
  011BF1  74fb             je 0x11bee
  011BF3  fa               cli
  011BF4  bac903           mov dx, 0x3c9
  011BF7  8bce             mov cx, si
  011BF9  3bcb             cmp cx, bx
  011BFB  7602             jbe 0x11bff
  011BFD  8bcb             mov cx, bx
  011BFF  51               push cx
  011C00  6c               insb byte ptr es:[di], dx
  011C01  eb01             jmp 0x11c04
  011C03  90               nop
  011C04  eb00             jmp 0x11c06
  011C06  e2f8             loop 0x11c00
  011C08  fb               sti
  011C09  59               pop cx
  011C0A  2bf1             sub si, cx
  011C0C  75d6             jne 0x11be4
  011C0E  c706b63a0000     mov word ptr [0x3ab6], 0
  011C14  5e               pop si
  011C15  5f               pop di
  011C16  c9               leave
  011C17  ca0400           retf 4
