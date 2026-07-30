; MAPEDIT.EXE named disasm — module FILEIO_5.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @fileio_fix_lf_input  file 0x00D240..0x00D26E  seg 0xBC4:0x0  (FILEIO_5.C.obj) ----
  00D240  c8040000         enter 4, 0
  00D244  56               push si
  00D245  6a0a             push 0xa
  00D247  ff7608           push word ptr [bp + 8]
  00D24A  ff7606           push word ptr [bp + 6]
  00D24D  9a820d8813       lcall 0x1388, 0xd82
  00D252  83c406           add sp, 6
  00D255  8bf0             mov si, ax
  00D257  8956fe           mov word ptr [bp - 2], dx
  00D25A  0bd0             or dx, ax
  00D25C  7407             je 0xd265
  00D25E  8e46fe           mov es, word ptr [bp - 2]
  00D261  26c60400         mov byte ptr es:[si], 0
  00D265  8b56fe           mov dx, word ptr [bp - 2]
  00D268  5e               pop si
  00D269  c9               leave
  00D26A  ca0400           retf 4
  00D26D  90               nop

; ---- @fileio_fix_lf_output  file 0x00D26E..0x00D2A0  seg 0xBC4:0x2e  (FILEIO_5.C.obj) ----
  00D26E  c8080000         enter 8, 0
  00D272  57               push di
  00D273  8b7e06           mov di, word ptr [bp + 6]
  00D276  8b4608           mov ax, word ptr [bp + 8]
  00D279  50               push ax
  00D27A  57               push di
  00D27B  897ef8           mov word ptr [bp - 8], di
  00D27E  8946fa           mov word ptr [bp - 6], ax
  00D281  9ad40d8813       lcall 0x1388, 0xdd4
  00D286  83c404           add sp, 4
  00D289  8bd8             mov bx, ax
  00D28B  035ef8           add bx, word ptr [bp - 8]
  00D28E  8e46fa           mov es, word ptr [bp - 6]
  00D291  26c6070a         mov byte ptr es:[bx], 0xa
  00D295  43               inc bx
  00D296  26c60700         mov byte ptr es:[bx], 0
  00D29A  5f               pop di
  00D29B  c9               leave
  00D29C  ca0400           retf 4
  00D29F  90               nop
