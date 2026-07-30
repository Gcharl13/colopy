; MAPEDIT.EXE named disasm — module rewind.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _rewind  file 0x015718..0x01575C  seg 0x1388:0x898  (rewind.c.obj) ----
  015718  55               push bp
  015719  8bec             mov bp, sp
  01571B  57               push di
  01571C  56               push si
  01571D  8b7606           mov si, word ptr [bp + 6]
  015720  8a4407           mov al, byte ptr [si + 7]
  015723  2ae4             sub ah, ah
  015725  8bf8             mov di, ax
  015727  56               push si
  015728  9ace158813       lcall 0x1388, 0x15ce
  01572D  83c402           add sp, 2
  015730  80a57745fd       and byte ptr [di + 0x4577], 0xfd
  015735  806406cf         and byte ptr [si + 6], 0xcf
  015739  f6440680         test byte ptr [si + 6], 0x80
  01573D  7408             je 0x15747
  01573F  8a4406           mov al, byte ptr [si + 6]
  015742  24fc             and al, 0xfc
  015744  884406           mov byte ptr [si + 6], al
  015747  2bc0             sub ax, ax
  015749  50               push ax
  01574A  50               push ax
  01574B  50               push ax
  01574C  57               push di
  01574D  9ad21b8813       lcall 0x1388, 0x1bd2
  015752  83c408           add sp, 8
  015755  5e               pop si
  015756  5f               pop di
  015757  8be5             mov sp, bp
  015759  5d               pop bp
  01575A  cb               retf
  01575B  90               nop
