; MAPEDIT.EXE named disasm — module btype_3.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @xtoi  file 0x011B0A..0x011B6E  seg 0x1050:0xa  (btype_3.c.obj) ----
  011B0A  c8040000         enter 4, 0
  011B0E  53               push bx
  011B0F  57               push di
  011B10  56               push si
  011B11  2bff             sub di, di
  011B13  803f00           cmp byte ptr [bx], 0
  011B16  744f             je 0x11b67
  011B18  8a07             mov al, byte ptr [bx]
  011B1A  98               cwde
  011B1B  8bf0             mov si, ax
  011B1D  ff46fa           inc word ptr [bp - 6]
  011B20  f684a94502       test byte ptr [si + 0x45a9], 2
  011B25  7403             je 0x11b2a
  011B27  83ee20           sub si, 0x20
  011B2A  f684a94504       test byte ptr [si + 0x45a9], 4
  011B2F  740b             je 0x11b3c
  011B31  c1e704           shl di, 4
  011B34  8d44d0           lea ax, [si - 0x30]
  011B37  03f8             add di, ax
  011B39  eb24             jmp 0x11b5f
  011B3B  90               nop
  011B3C  83fe41           cmp si, 0x41
  011B3F  7c0d             jl 0x11b4e
  011B41  83fe46           cmp si, 0x46
  011B44  7f08             jg 0x11b4e
  011B46  c1e704           shl di, 4
  011B49  8d44c9           lea ax, [si - 0x37]
  011B4C  ebe9             jmp 0x11b37
  011B4E  8b5efa           mov bx, word ptr [bp - 6]
  011B51  803f00           cmp byte ptr [bx], 0
  011B54  7409             je 0x11b5f
  011B56  43               inc bx
  011B57  803f00           cmp byte ptr [bx], 0
  011B5A  75fa             jne 0x11b56
  011B5C  895efa           mov word ptr [bp - 6], bx
  011B5F  8b5efa           mov bx, word ptr [bp - 6]
  011B62  803f00           cmp byte ptr [bx], 0
  011B65  75b1             jne 0x11b18
  011B67  8bc7             mov ax, di
  011B69  5e               pop si
  011B6A  5f               pop di
  011B6B  c9               leave
  011B6C  cb               retf
  011B6D  90               nop
