; MAPEDIT.EXE named disasm — module nmalloc.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __nfree  file 0x01727E..0x01729F  seg 0x1388:0x23fe  (nmalloc.asm.obj) ----
  01727E  55               push bp
  01727F  8bec             mov bp, sp
  017281  56               push si
  017282  8b5e06           mov bx, word ptr [bp + 6]
  017285  be3445           mov si, 0x4534
  017288  395c06           cmp word ptr [si + 6], bx
  01728B  730d             jae 0x1729a
  01728D  4b               dec bx
  01728E  4b               dec bx
  01728F  800f01           or byte ptr [bx], 1
  017292  395c08           cmp word ptr [si + 8], bx
  017295  7603             jbe 0x1729a
  017297  895c08           mov word ptr [si + 8], bx
  01729A  5e               pop si
  01729B  8be5             mov sp, bp
  01729D  5d               pop bp
  01729E  cb               retf

; ---- __nmalloc  file 0x01729F..0x0172C8  seg 0x1388:0x241f  (nmalloc.asm.obj) ----
  01729F  55               push bp
  0172A0  8bec             mov bp, sp
  0172A2  56               push si
  0172A3  57               push di
  0172A4  8b4e06           mov cx, word ptr [bp + 6]
  0172A7  83f9e8           cmp cx, -0x18
  0172AA  7712             ja 0x172be
  0172AC  bb3445           mov bx, 0x4534
  0172AF  e81401           call 0x173c6
  0172B2  730f             jae 0x172c3
  0172B4  e81100           call 0x172c8
  0172B7  7205             jb 0x172be
  0172B9  e80a01           call 0x173c6
  0172BC  7305             jae 0x172c3
  0172BE  33c0             xor ax, ax
  0172C0  99               cdq
  0172C1  eb00             jmp 0x172c3
  0172C3  5f               pop di
  0172C4  5e               pop si
  0172C5  5d               pop bp
  0172C6  cb               retf
  0172C7  00               .byte 0x00
