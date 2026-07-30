; MAPEDIT.EXE named disasm — module hspot_1.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @hspot_add  file 0x00D030..0x00D0A2  seg 0xBA3:0x0  (hspot_1.c.obj) ----
  00D030  55               push bp
  00D031  8bec             mov bp, sp
  00D033  57               push di
  00D034  56               push si
  00D035  8b361607         mov si, word ptr [0x716]
  00D039  83fe78           cmp si, 0x78
  00D03C  7522             jne 0xd060
  00D03E  8b460a           mov ax, word ptr [bp + 0xa]
  00D041  99               cdq
  00D042  52               push dx
  00D043  50               push ax
  00D044  8b4608           mov ax, word ptr [bp + 8]
  00D047  99               cdq
  00D048  52               push dx
  00D049  50               push ax
  00D04A  b8bcff           mov ax, 0xffbc
  00D04D  ba0200           mov dx, 2
  00D050  bb1c00           mov bx, 0x1c
  00D053  9ad603d00e       lcall 0xed0, 0x3d6
  00D058  2bc0             sub ax, ax
  00D05A  5e               pop si
  00D05B  5f               pop di
  00D05C  c9               leave
  00D05D  ca0800           retf 8
  00D060  46               inc si
  00D061  8bfe             mov di, si
  00D063  c1e704           shl di, 4
  00D066  89850a53         mov word ptr [di + 0x530a], ax
  00D06A  89950c53         mov word ptr [di + 0x530c], dx
  00D06E  899d0e53         mov word ptr [di + 0x530e], bx
  00D072  8b460c           mov ax, word ptr [bp + 0xc]
  00D075  89851053         mov word ptr [di + 0x5310], ax
  00D079  8b460a           mov ax, word ptr [bp + 0xa]
  00D07C  89851253         mov word ptr [di + 0x5312], ax
  00D080  8b4608           mov ax, word ptr [bp + 8]
  00D083  89851453         mov word ptr [di + 0x5314], ax
  00D087  c7851853ffff     mov word ptr [di + 0x5318], 0xffff
  00D08D  8b4606           mov ax, word ptr [bp + 6]
  00D090  89851653         mov word ptr [di + 0x5316], ax
  00D094  b8ffff           mov ax, 0xffff
  00D097  89361607         mov word ptr [0x716], si
  00D09B  5e               pop si
  00D09C  5f               pop di
  00D09D  c9               leave
  00D09E  ca0800           retf 8
  00D0A1  90               nop
