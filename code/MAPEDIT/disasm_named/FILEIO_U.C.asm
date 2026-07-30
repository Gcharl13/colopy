; MAPEDIT.EXE named disasm — module FILEIO_U.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @fileio_purge_all_spaces  file 0x00D7A2..0x00D810  seg 0xC1A:0x2  (FILEIO_U.C.obj) ----
  00D7A2  c8040100         enter 0x104, 0
  00D7A6  57               push di
  00D7A7  56               push si
  00D7A8  8b7e06           mov di, word ptr [bp + 6]
  00D7AB  ff7608           push word ptr [bp + 8]
  00D7AE  57               push di
  00D7AF  9a0c001f10       lcall 0x101f, 0xc
  00D7B4  8b4608           mov ax, word ptr [bp + 8]
  00D7B7  8bcf             mov cx, di
  00D7B9  8bf1             mov si, cx
  00D7BB  8946fe           mov word ptr [bp - 2], ax
  00D7BE  8ec0             mov es, ax
  00D7C0  8bdf             mov bx, di
  00D7C2  26803f00         cmp byte ptr es:[bx], 0
  00D7C6  741c             je 0xd7e4
  00D7C8  8ed8             mov ds, ax
  00D7CA  803c20           cmp byte ptr [si], 0x20
  00D7CD  740d             je 0xd7dc
  00D7CF  803c09           cmp byte ptr [si], 9
  00D7D2  7408             je 0xd7dc
  00D7D4  b8e715           mov ax, 0x15e7
  00D7D7  8ed8             mov ds, ax
  00D7D9  eb09             jmp 0xd7e4
  00D7DB  90               nop
  00D7DC  46               inc si
  00D7DD  803c00           cmp byte ptr [si], 0
  00D7E0  75e8             jne 0xd7ca
  00D7E2  ebf0             jmp 0xd7d4
  00D7E4  ff76fe           push word ptr [bp - 2]
  00D7E7  56               push si
  00D7E8  8d86fcfe         lea ax, [bp - 0x104]
  00D7EC  16               push ss
  00D7ED  50               push ax
  00D7EE  9aec0d8813       lcall 0x1388, 0xdec
  00D7F3  83c408           add sp, 8
  00D7F6  8d86fcfe         lea ax, [bp - 0x104]
  00D7FA  16               push ss
  00D7FB  50               push ax
  00D7FC  8b4608           mov ax, word ptr [bp + 8]
  00D7FF  50               push ax
  00D800  57               push di
  00D801  9aec0d8813       lcall 0x1388, 0xdec
  00D806  83c408           add sp, 8
  00D809  5e               pop si
  00D80A  5f               pop di
  00D80B  c9               leave
  00D80C  ca0400           retf 4
  00D80F  90               nop
