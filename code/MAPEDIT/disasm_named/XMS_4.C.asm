; MAPEDIT.EXE named disasm — module XMS_4.C.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _xms_umb_purge  file 0x013E90..0x013EB4  seg 0x1289:0x0  (XMS_4.C.obj) ----
  013E90  55               push bp
  013E91  8bec             mov bp, sp
  013E93  bbac5a           mov bx, 0x5aac
  013E96  8b0ef644         mov cx, word ptr [0x44f6]
  013E9A  e30f             jcxz 0x13eab
  013E9C  53               push bx
  013E9D  8b17             mov dx, word ptr [bx]
  013E9F  b411             mov ah, 0x11
  013EA1  ff1e6c3c         lcall [0x3c6c]
  013EA5  5b               pop bx
  013EA6  83c302           add bx, 2
  013EA9  e2f1             loop 0x13e9c
  013EAB  c706f6440000     mov word ptr [0x44f6], 0
  013EB1  c9               leave
  013EB2  cb               retf
  013EB3  90               nop
