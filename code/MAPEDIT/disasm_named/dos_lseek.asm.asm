; MAPEDIT.EXE named disasm — module dos_lseek.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _lseek  file 0x016A52..0x016ACC  seg 0x1388:0x1bd2  (dos_lseek.asm.obj) ----
  016A52  55               push bp
  016A53  8bec             mov bp, sp
  016A55  83ec04           sub sp, 4
  016A58  8b5e06           mov bx, word ptr [bp + 6]
  016A5B  3b1e7545         cmp bx, word ptr [0x4575]
  016A5F  7205             jb 0x16a66
  016A61  b80009           mov ax, 0x900
  016A64  eb2a             jmp 0x16a90
  016A66  f7460a0080       test word ptr [bp + 0xa], 0x8000
  016A6B  7448             je 0x16ab5
  016A6D  837e0c00         cmp word ptr [bp + 0xc], 0
  016A71  741a             je 0x16a8d
  016A73  33c9             xor cx, cx
  016A75  8bd1             mov dx, cx
  016A77  b80142           mov ax, 0x4201
  016A7A  cd21             int 0x21
  016A7C  724b             jb 0x16ac9
  016A7E  f7460c0200       test word ptr [bp + 0xc], 2
  016A83  750e             jne 0x16a93
  016A85  034608           add ax, word ptr [bp + 8]
  016A88  13560a           adc dx, word ptr [bp + 0xa]
  016A8B  7928             jns 0x16ab5
  016A8D  b80016           mov ax, 0x1600
  016A90  f9               stc
  016A91  eb36             jmp 0x16ac9
  016A93  8956fe           mov word ptr [bp - 2], dx
  016A96  8946fc           mov word ptr [bp - 4], ax
  016A99  8bd1             mov dx, cx
  016A9B  b80242           mov ax, 0x4202
  016A9E  cd21             int 0x21
  016AA0  034608           add ax, word ptr [bp + 8]
  016AA3  13560a           adc dx, word ptr [bp + 0xa]
  016AA6  790d             jns 0x16ab5
  016AA8  8b4efe           mov cx, word ptr [bp - 2]
  016AAB  8b56fc           mov dx, word ptr [bp - 4]
  016AAE  b80042           mov ax, 0x4200
  016AB1  cd21             int 0x21
  016AB3  ebd8             jmp 0x16a8d
  016AB5  8b5608           mov dx, word ptr [bp + 8]
  016AB8  8b4e0a           mov cx, word ptr [bp + 0xa]
  016ABB  8a460c           mov al, byte ptr [bp + 0xc]
  016ABE  b442             mov ah, 0x42
  016AC0  cd21             int 0x21
  016AC2  7205             jb 0x16ac9
  016AC4  80a77745fd       and byte ptr [bx + 0x4577], 0xfd
  016AC9  e901f6           jmp 0x160cd
