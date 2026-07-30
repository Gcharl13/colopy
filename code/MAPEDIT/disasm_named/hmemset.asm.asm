; MAPEDIT.EXE named disasm — module hmemset.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __fmemset  file 0x015CE8..0x015D30  seg 0x1388:0xe68  (hmemset.asm.obj) ----
  015CE8  55               push bp
  015CE9  8bec             mov bp, sp
  015CEB  8b4e0c           mov cx, word ptr [bp + 0xc]
  015CEE  e338             jcxz 0x15d28
  015CF0  57               push di
  015CF1  c47e06           les di, ptr [bp + 6]
  015CF4  8bd7             mov dx, di
  015CF6  f7da             neg dx
  015CF8  740c             je 0x15d06
  015CFA  2bd1             sub dx, cx
  015CFC  1bdb             sbb bx, bx
  015CFE  23d3             and dx, bx
  015D00  03d1             add dx, cx
  015D02  87d1             xchg cx, dx
  015D04  2bd1             sub dx, cx
  015D06  8b460a           mov ax, word ptr [bp + 0xa]
  015D09  8ae0             mov ah, al
  015D0B  d1e9             shr cx, 1
  015D0D  f3ab             rep stosw word ptr es:[di], ax
  015D0F  13c9             adc cx, cx
  015D11  f3aa             rep stosb byte ptr es:[di], al
  015D13  87d1             xchg cx, dx
  015D15  e310             jcxz 0x15d27
  015D17  8cc3             mov bx, es
  015D19  81c30010         add bx, 0x1000
  015D1D  8ec3             mov es, bx
  015D1F  d1e9             shr cx, 1
  015D21  f3ab             rep stosw word ptr es:[di], ax
  015D23  13c9             adc cx, cx
  015D25  f3aa             rep stosb byte ptr es:[di], al
  015D27  5f               pop di
  015D28  8b4606           mov ax, word ptr [bp + 6]
  015D2B  8b5608           mov dx, word ptr [bp + 8]
  015D2E  5d               pop bp
  015D2F  cb               retf
