; MAPEDIT.EXE named disasm — module video_2.ASM.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _VIDEO_ADDRESS  file 0x012742..0x012754  seg 0x1114:0x2  (video_2.ASM.obj) ----
  012742  bf00a0           mov di, 0xa000
  012745  8ec7             mov es, di
  012747  c1e206           shl dx, 6
  01274A  8bfa             mov di, dx
  01274C  c1e202           shl dx, 2
  01274F  03fa             add di, dx
  012751  03f9             add di, cx
  012753  cb               retf
