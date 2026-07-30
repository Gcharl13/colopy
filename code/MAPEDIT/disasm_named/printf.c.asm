; MAPEDIT.EXE named disasm — module printf.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _printf  file 0x015428..0x015466  seg 0x1388:0x5a8  (printf.c.obj) ----
  015428  55               push bp
  015429  8bec             mov bp, sp
  01542B  83ec04           sub sp, 4
  01542E  57               push di
  01542F  56               push si
  015430  bece46           mov si, 0x46ce
  015433  56               push si
  015434  e8650f           call 0x1639c
  015437  83c402           add sp, 2
  01543A  8bf8             mov di, ax
  01543C  8d4608           lea ax, [bp + 8]
  01543F  50               push ax
  015440  ff7606           push word ptr [bp + 6]
  015443  b8ce46           mov ax, 0x46ce
  015446  50               push ax
  015447  9aa6168813       lcall 0x1388, 0x16a6
  01544C  83c406           add sp, 6
  01544F  8946fc           mov word ptr [bp - 4], ax
  015452  b8ce46           mov ax, 0x46ce
  015455  50               push ax
  015456  57               push di
  015457  e8b50f           call 0x1640f
  01545A  83c404           add sp, 4
  01545D  8b46fc           mov ax, word ptr [bp - 4]
  015460  5e               pop si
  015461  5f               pop di
  015462  8be5             mov sp, bp
  015464  5d               pop bp
  015465  cb               retf
