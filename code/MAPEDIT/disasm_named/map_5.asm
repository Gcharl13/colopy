; MAPEDIT.EXE named disasm — module map_5.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _draw_map_region_2  file 0x00A02A..0x00A088  seg 0x8A2:0xa  (map_5.obj) ----
  00A02A  55               push bp
  00A02B  8bec             mov bp, sp
  00A02D  8d460c           lea ax, [bp + 0xc]
  00A030  50               push ax
  00A031  8d4e0a           lea cx, [bp + 0xa]
  00A034  51               push cx
  00A035  8d5608           lea dx, [bp + 8]
  00A038  52               push dx
  00A039  8d5e06           lea bx, [bp + 6]
  00A03C  53               push bx
  00A03D  9a4a007b08       lcall 0x87b, 0x4a
  00A042  8be5             mov sp, bp
  00A044  ff760c           push word ptr [bp + 0xc]
  00A047  6aff             push -1
  00A049  8b4606           mov ax, word ptr [bp + 6]
  00A04C  8b5608           mov dx, word ptr [bp + 8]
  00A04F  8b5e0a           mov bx, word ptr [bp + 0xa]
  00A052  9a660d470a       lcall 0xa47, 0xd66
  00A057  ff760c           push word ptr [bp + 0xc]
  00A05A  ff760a           push word ptr [bp + 0xa]
  00A05D  ff7608           push word ptr [bp + 8]
  00A060  ff7606           push word ptr [bp + 6]
  00A063  9ac0007b08       lcall 0x87b, 0xc0
  00A068  8be5             mov sp, bp
  00A06A  ff760c           push word ptr [bp + 0xc]
  00A06D  ff760a           push word ptr [bp + 0xa]
  00A070  ff7608           push word ptr [bp + 8]
  00A073  ff7606           push word ptr [bp + 6]
  00A076  9a34027b08       lcall 0x87b, 0x234
  00A07B  8be5             mov sp, bp
  00A07D  6aff             push -1
  00A07F  6a01             push 1
  00A081  9ab403560b       lcall 0xb56, 0x3b4
  00A086  c9               leave
  00A087  cb               retf

; ---- _draw_map_2  file 0x00A088..0x00A0D0  seg 0x8A2:0x68  (map_5.obj) ----
  00A088  ff36fa3a         push word ptr [0x3afa]
  00A08C  ff36f83a         push word ptr [0x3af8]
  00A090  ff36f63a         push word ptr [0x3af6]
  00A094  ff36f43a         push word ptr [0x3af4]
  00A098  a1ee64           mov ax, word ptr [0x64ee]
  00A09B  050800           add ax, 8
  00A09E  50               push ax
  00A09F  6a00             push 0
  00A0A1  b8ffff           mov ax, 0xffff
  00A0A4  ba0700           mov dx, 7
  00A0A7  8b1eec64         mov bx, word ptr [0x64ec]
  00A0AB  9a0c00860c       lcall 0xc86, 0xc
  00A0B0  b8ffff           mov ax, 0xffff
  00A0B3  9a2210470a       lcall 0xa47, 0x1022
  00A0B8  9a2a017b08       lcall 0x87b, 0x12a
  00A0BD  9a1c027b08       lcall 0x87b, 0x21c
  00A0C2  6aff             push -1
  00A0C4  6a01             push 1
  00A0C6  9ab403560b       lcall 0xb56, 0x3b4
  00A0CB  83c404           add sp, 4
  00A0CE  cb               retf
  00A0CF  90               nop
