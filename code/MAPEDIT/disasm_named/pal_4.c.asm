; MAPEDIT.EXE named disasm — module pal_4.c.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @pal_interface  file 0x014100..0x0141CA  seg 0x12B0:0x0  (pal_4.c.obj) ----
  014100  c8120000         enter 0x12, 0
  014104  53               push bx
  014105  57               push di
  014106  56               push si
  014107  2bdb             sub bx, bx
  014109  8bd3             mov dx, bx
  01410B  8956fa           mov word ptr [bp - 6], dx
  01410E  895ef6           mov word ptr [bp - 0xa], bx
  014111  83fa01           cmp dx, 1
  014114  1bc0             sbb ax, ax
  014116  24eb             and al, 0xeb
  014118  053f00           add ax, 0x3f
  01411B  c746f80000       mov word ptr [bp - 8], 0
  014120  895ef2           mov word ptr [bp - 0xe], bx
  014123  8956f0           mov word ptr [bp - 0x10], dx
  014126  8bf8             mov di, ax
  014128  2bd2             sub dx, dx
  01412A  8b5ef6           mov bx, word ptr [bp - 0xa]
  01412D  2bc9             sub cx, cx
  01412F  8956fc           mov word ptr [bp - 4], dx
  014132  8b46fa           mov ax, word ptr [bp - 6]
  014135  03c1             add ax, cx
  014137  8946fe           mov word ptr [bp - 2], ax
  01413A  837ef800         cmp word ptr [bp - 8], 0
  01413E  7416             je 0x14156
  014140  8bc7             mov ax, di
  014142  8b76fe           mov si, word ptr [bp - 2]
  014145  8bd6             mov dx, si
  014147  d1e6             shl si, 1
  014149  03f2             add si, dx
  01414B  0376ec           add si, word ptr [bp - 0x14]
  01414E  8976ee           mov word ptr [bp - 0x12], si
  014151  8804             mov byte ptr [si], al
  014153  eb0f             jmp 0x14164
  014155  90               nop
  014156  8bf0             mov si, ax
  014158  d1e6             shl si, 1
  01415A  03f0             add si, ax
  01415C  0376ec           add si, word ptr [bp - 0x14]
  01415F  8976ee           mov word ptr [bp - 0x12], si
  014162  881c             mov byte ptr [si], bl
  014164  837efc00         cmp word ptr [bp - 4], 0
  014168  740a             je 0x14174
  01416A  8bc7             mov ax, di
  01416C  8b76ee           mov si, word ptr [bp - 0x12]
  01416F  884401           mov byte ptr [si + 1], al
  014172  eb06             jmp 0x1417a
  014174  8b76ee           mov si, word ptr [bp - 0x12]
  014177  885c01           mov byte ptr [si + 1], bl
  01417A  0bc9             or cx, cx
  01417C  740a             je 0x14188
  01417E  8bc7             mov ax, di
  014180  8b76ee           mov si, word ptr [bp - 0x12]
  014183  884402           mov byte ptr [si + 2], al
  014186  eb06             jmp 0x1418e
  014188  8b76ee           mov si, word ptr [bp - 0x12]
  01418B  885c02           mov byte ptr [si + 2], bl
  01418E  41               inc cx
  01418F  83f902           cmp cx, 2
  014192  7c9e             jl 0x14132
  014194  8346fa02         add word ptr [bp - 6], 2
  014198  8b56fc           mov dx, word ptr [bp - 4]
  01419B  42               inc dx
  01419C  83fa02           cmp dx, 2
  01419F  7c8c             jl 0x1412d
  0141A1  ff46f8           inc word ptr [bp - 8]
  0141A4  837ef802         cmp word ptr [bp - 8], 2
  0141A8  7d03             jge 0x141ad
  0141AA  e97bff           jmp 0x14128
  0141AD  8b56f0           mov dx, word ptr [bp - 0x10]
  0141B0  42               inc dx
  0141B1  8b5ef2           mov bx, word ptr [bp - 0xe]
  0141B4  83c315           add bx, 0x15
  0141B7  83fb2a           cmp bx, 0x2a
  0141BA  7d03             jge 0x141bf
  0141BC  e94fff           jmp 0x1410e
  0141BF  8b5eec           mov bx, word ptr [bp - 0x14]
  0141C2  c6471315         mov byte ptr [bx + 0x13], 0x15
  0141C6  5e               pop si
  0141C7  5f               pop di
  0141C8  c9               leave
  0141C9  cb               retf

; ---- @pal_white  file 0x0141CA..0x014200  seg 0x12B0:0xca  (pal_4.c.obj) ----
  0141CA  c8040000         enter 4, 0
  0141CE  53               push bx
  0141CF  57               push di
  0141D0  56               push si
  0141D1  c646fc00         mov byte ptr [bp - 4], 0
  0141D5  c646fd15         mov byte ptr [bp - 3], 0x15
  0141D9  c646fe2a         mov byte ptr [bp - 2], 0x2a
  0141DD  c646ff3f         mov byte ptr [bp - 1], 0x3f
  0141E1  2bd2             sub dx, dx
  0141E3  8bf3             mov si, bx
  0141E5  8bfa             mov di, dx
  0141E7  8a43fc           mov al, byte ptr [bp + di - 4]
  0141EA  8804             mov byte ptr [si], al
  0141EC  884401           mov byte ptr [si + 1], al
  0141EF  884402           mov byte ptr [si + 2], al
  0141F2  83c603           add si, 3
  0141F5  42               inc dx
  0141F6  83fa04           cmp dx, 4
  0141F9  7cea             jl 0x141e5
  0141FB  5e               pop si
  0141FC  5f               pop di
  0141FD  c9               leave
  0141FE  cb               retf
  0141FF  90               nop

; ---- @pal_grey  file 0x014200..0x01427E  seg 0x12B0:0x100  (pal_4.c.obj) ----
  014200  c80e0000         enter 0xe, 0
  014204  52               push dx
  014205  50               push ax
  014206  56               push si
  014207  8b5608           mov dx, word ptr [bp + 8]
  01420A  8b4ef0           mov cx, word ptr [bp - 0x10]
  01420D  c746fc0000       mov word ptr [bp - 4], 0
  014212  8bc2             mov ax, dx
  014214  2b5606           sub dx, word ptr [bp + 6]
  014217  f7da             neg dx
  014219  8956f4           mov word ptr [bp - 0xc], dx
  01421C  8946fe           mov word ptr [bp - 2], ax
  01421F  0bc9             or cx, cx
  014221  7e56             jle 0x14279
  014223  8b76ee           mov si, word ptr [bp - 0x12]
  014226  8bc6             mov ax, si
  014228  d1e6             shl si, 1
  01422A  03f0             add si, ax
  01422C  03f3             add si, bx
  01422E  8bc1             mov ax, cx
  014230  48               dec ax
  014231  8946f2           mov word ptr [bp - 0xe], ax
  014234  894ef8           mov word ptr [bp - 8], cx
  014237  8b56fe           mov dx, word ptr [bp - 2]
  01423A  8814             mov byte ptr [si], dl
  01423C  885401           mov byte ptr [si + 1], dl
  01423F  885402           mov byte ptr [si + 2], dl
  014242  83f901           cmp cx, 1
  014245  7e2a             jle 0x14271
  014247  8b46f2           mov ax, word ptr [bp - 0xe]
  01424A  8b5ef4           mov bx, word ptr [bp - 0xc]
  01424D  015efc           add word ptr [bp - 4], bx
  014250  3946fc           cmp word ptr [bp - 4], ax
  014253  721c             jb 0x14271
  014255  8976fa           mov word ptr [bp - 6], si
  014258  8b5efc           mov bx, word ptr [bp - 4]
  01425B  42               inc dx
  01425C  b80100           mov ax, 1
  01425F  2bc1             sub ax, cx
  014261  03d8             add bx, ax
  014263  3b5ef2           cmp bx, word ptr [bp - 0xe]
  014266  73f3             jae 0x1425b
  014268  895efc           mov word ptr [bp - 4], bx
  01426B  8956fe           mov word ptr [bp - 2], dx
  01426E  8b76fa           mov si, word ptr [bp - 6]
  014271  83c603           add si, 3
  014274  ff4ef8           dec word ptr [bp - 8]
  014277  75be             jne 0x14237
  014279  5e               pop si
  01427A  c9               leave
  01427B  ca0400           retf 4
