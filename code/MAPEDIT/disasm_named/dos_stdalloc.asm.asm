; MAPEDIT.EXE named disasm — module dos_stdalloc.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __myalloc  file 0x017038..0x01705E  seg 0x1388:0x21b8  (dos_stdalloc.asm.obj) ----
  017038  53               push bx
  017039  06               push es
  01703A  51               push cx
  01703B  b90004           mov cx, 0x400
  01703E  870e9248         xchg word ptr [0x4892], cx
  017042  51               push cx
  017043  50               push ax
  017044  9af2238813       lcall 0x1388, 0x23f2
  017049  5b               pop bx
  01704A  8f069248         pop word ptr [0x4892]
  01704E  59               pop cx
  01704F  8cda             mov dx, ds
  017051  0bc0             or ax, ax
  017053  7403             je 0x17058
  017055  07               pop es
  017056  5b               pop bx
  017057  c3               ret
  017058  8bc1             mov ax, cx
  01705A  e914df           jmp 0x14f71
  01705D  00               .byte 0x00
