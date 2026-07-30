; MAPEDIT.EXE named disasm — module searchsg.asm.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- __searchseg  file 0x0173C6..0x01BE09  seg 0x1388:0x2546  (searchsg.asm.obj) ----
  0173C6  41               inc cx
  0173C7  80e1fe           and cl, 0xfe
  0173CA  53               push bx
  0173CB  fc               cld
  0173CC  8b7708           mov si, word ptr [bx + 8]
  0173CF  8b5f0a           mov bx, word ptr [bx + 0xa]
  0173D2  33ff             xor di, di
  0173D4  eb23             jmp 0x173f9
  0173D6  8bc3             mov ax, bx
  0173D8  5b               pop bx
  0173D9  a801             test al, 1
  0173DB  7542             jne 0x1741f
  0173DD  53               push bx
  0173DE  8b7706           mov si, word ptr [bx + 6]
  0173E1  8b5f08           mov bx, word ptr [bx + 8]
  0173E4  3bde             cmp bx, si
  0173E6  7436             je 0x1741e
  0173E8  4b               dec bx
  0173E9  33ff             xor di, di
  0173EB  eb0c             jmp 0x173f9
  0173ED  90               nop
  0173EE  8d54fe           lea dx, [si - 2]
  0173F1  3bd3             cmp dx, bx
  0173F3  73e1             jae 0x173d6
  0173F5  03f0             add si, ax
  0173F7  7223             jb 0x1741c
  0173F9  ad               lodsw ax, word ptr [si]
  0173FA  a801             test al, 1
  0173FC  74f0             je 0x173ee
  0173FE  8bfe             mov di, si
  017400  48               dec ax
  017401  3bc1             cmp ax, cx
  017403  7323             jae 0x17428
  017405  03f0             add si, ax
  017407  7213             jb 0x1741c
  017409  8bd0             mov dx, ax
  01740B  ad               lodsw ax, word ptr [si]
  01740C  a801             test al, 1
  01740E  74de             je 0x173ee
  017410  03c2             add ax, dx
  017412  050200           add ax, 2
  017415  8bf7             mov si, di
  017417  8944fe           mov word ptr [si - 2], ax
  01741A  ebe4             jmp 0x17400
  01741C  8bc0             mov ax, ax
  01741E  5b               pop bx
  01741F  8b4706           mov ax, word ptr [bx + 6]
  017422  894708           mov word ptr [bx + 8], ax
  017425  f9               stc
  017426  eb19             jmp 0x17441
  017428  5b               pop bx
  017429  894cfe           mov word ptr [si - 2], cx
  01742C  7409             je 0x17437
  01742E  03f9             add di, cx
  017430  2bc1             sub ax, cx
  017432  48               dec ax
  017433  8905             mov word ptr [di], ax
  017435  2bf9             sub di, cx
  017437  03f9             add di, cx
  017439  897f08           mov word ptr [bx + 8], di
  01743C  8bc6             mov ax, si
  01743E  8cda             mov dx, ds
  017440  f8               clc
  017441  c3               ret
  017442  0000             add byte ptr [bx + si], al
  017444  0000             add byte ptr [bx + si], al
  017446  0000             add byte ptr [bx + si], al
  017448  0000             add byte ptr [bx + si], al
  01744A  0000             add byte ptr [bx + si], al
  01744C  0000             add byte ptr [bx + si], al
  01744E  0000             add byte ptr [bx + si], al
  017450  e715             out 0x15, ax
  017452  0000             add byte ptr [bx + si], al
  017454  0000             add byte ptr [bx + si], al
  017456  0000             add byte ptr [bx + si], al
  017458  0000             add byte ptr [bx + si], al
  01745A  0000             add byte ptr [bx + si], al
  01745C  0000             add byte ptr [bx + si], al
  01745E  0000             add byte ptr [bx + si], al
  017460  07               pop es
  017461  f6f7             div bh
  017463  f8               clc
  017464  f9               stc
  017465  fa               cli
  017466  fb               sti
  017467  0000             add byte ptr [bx + si], al
  017469  0000             add byte ptr [bx + si], al
  01746B  0000             add byte ptr [bx + si], al
  01746D  0000             add byte ptr [bx + si], al
  01746F  0000             add byte ptr [bx + si], al
  017471  0000             add byte ptr [bx + si], al
  017473  0000             add byte ptr [bx + si], al
  017475  0000             add byte ptr [bx + si], al
  017477  004d53           add byte ptr [di + 0x53], cl
  01747A  205275           and byte ptr [bp + si + 0x75], dl
  01747D  6e               outsb dx, byte ptr [si]
  01747E  2d5469           sub ax, 0x6954
  017481  6d               insw word ptr es:[di], dx
  017482  65204c69         and byte ptr gs:[si + 0x69], cl
  017486  627261           bound si, dword ptr [bp + si + 0x61]
  017489  7279             jb 0x17504
  01748B  202d             and byte ptr [di], ch
  01748D  20436f           and byte ptr [bp + di + 0x6f], al
  017490  7079             jo 0x1750b
  017492  7269             jb 0x174fd
  017494  67687420         push 0x2074
  017498  286329           sub byte ptr [bp + di + 0x29], ah
  01749B  2031             and byte ptr [bx + di], dh
  01749D  3939             cmp word ptr [bx + di], di
  01749F  302c             xor byte ptr [si], ch
  0174A1  204d69           and byte ptr [di + 0x69], cl
  0174A4  63726f           arpl word ptr [bp + si + 0x6f], si
  0174A7  736f             jae 0x17518
  0174A9  667420           je 0x174cc
  0174AC  43               inc bx
  0174AD  6f               outsw dx, word ptr [si]
  0174AE  7270             jb 0x17520
  0174B0  1800             sbb byte ptr [bx + si], al
  0174B2  0000             add byte ptr [bx + si], al
  0174B4  0000             add byte ptr [bx + si], al
  0174B6  0000             add byte ptr [bx + si], al
  0174B8  0000             add byte ptr [bx + si], al
  0174BA  0000             add byte ptr [bx + si], al
  0174BC  0000             add byte ptr [bx + si], al
  0174BE  0000             add byte ptr [bx + si], al
  0174C0  0000             add byte ptr [bx + si], al
  0174C2  0000             add byte ptr [bx + si], al
  0174C4  0000             add byte ptr [bx + si], al
  0174C6  194000           sbb word ptr [bx + si], ax
  0174C9  0000             add byte ptr [bx + si], al
  0174CB  0000             add byte ptr [bx + si], al
  0174CD  00ff             add bh, bh
  0174CF  ff00             inc word ptr [bx + si]
  0174D1  0000             add byte ptr [bx + si], al
  0174D3  0000             add byte ptr [bx + si], al
  0174D5  0000             add byte ptr [bx + si], al
  0174D7  0000             add byte ptr [bx + si], al
  0174D9  0000             add byte ptr [bx + si], al
  0174DB  0000             add byte ptr [bx + si], al
  0174DD  0000             add byte ptr [bx + si], al
  0174DF  0001             add byte ptr [bx + di], al
  0174E1  0000             add byte ptr [bx + si], al
  0174E3  0000             add byte ptr [bx + si], al
  0174E5  0000             add byte ptr [bx + si], al
  0174E7  0000             add byte ptr [bx + si], al
  0174E9  0000             add byte ptr [bx + si], al
  0174EB  0000             add byte ptr [bx + si], al
  0174ED  0000             add byte ptr [bx + si], al
  0174EF  0000             add byte ptr [bx + si], al
  0174F1  0000             add byte ptr [bx + si], al
  0174F3  004741           add byte ptr [bx + 0x41], al
  0174F6  4d               dec bp
  0174F7  45               inc bp
  0174F8  0000             add byte ptr [bx + si], al
  0174FA  0000             add byte ptr [bx + si], al
  0174FC  0000             add byte ptr [bx + si], al
  0174FE  0000             add byte ptr [bx + si], al
  017500  0000             add byte ptr [bx + si], al
  017502  44               inc sp
  017503  95               xchg bp, ax
  017504  08802f8a         or byte ptr [bx + si - 0x75d1], al
  017508  95               xchg bp, ax
  017509  86808a67         xchg byte ptr [bx + si + 0x678a], al
  01750D  61               popaw
  01750E  6d               insw word ptr es:[di], dx
  01750F  65006d61         add byte ptr gs:[di + 0x61], ch
  017513  706d             jo 0x17582
  017515  656e             outsb dx, byte ptr gs:[si]
  017517  7500             jne 0x17519
  017519  007669           add byte ptr [bp + 0x69], dh
  01751C  657700           ja 0x1751f
  01751F  6d               insw word ptr es:[di], dx
  017520  61               popaw
  017521  706d             jo 0x17590
  017523  656e             outsb dx, byte ptr gs:[si]
  017525  7500             jne 0x17527
  017527  0000             add byte ptr [bx + si], al
  017529  637570           arpl word ptr [di + 0x70], si
  01752C  006d61           add byte ptr [di + 0x61], ch
  01752F  706d             jo 0x1759e
  017531  656e             outsb dx, byte ptr gs:[si]
  017533  7500             jne 0x17535
  017535  0000             add byte ptr [bx + si], al
  017537  68656c           push 0x6c65
  01753A  7000             jo 0x1753c
  01753C  6d               insw word ptr es:[di], dx
  01753D  61               popaw
  01753E  706d             jo 0x175ad
  017540  656e             outsb dx, byte ptr gs:[si]
  017542  7500             jne 0x17544
  017544  0028             add byte ptr [bx + si], ch
  017546  4d               dec bp
  017547  6f               outsw dx, word ptr [si]
  017548  7265             jb 0x175af
  01754A  2900             sub word ptr [bx + si], ax
  01754C  284d6f           sub byte ptr [di + 0x6f], cl
  01754F  7265             jb 0x175b6
  017551  2900             sub word ptr [bx + si], ax
  017553  2800             sub byte ptr [bx + si], al
  017555  2900             sub word ptr [bx + si], ax
  017557  2800             sub byte ptr [bx + si], al
  017559  2900             sub word ptr [bx + si], ax
  01755B  53               push bx
  01755C  697a653a20       imul di, word ptr [bp + si + 0x65], 0x203a
  017561  2825             sub byte ptr [di], ah
  017563  642c20           sub al, 0x20
  017566  256429           and ax, 0x2964
  017569  004375           add byte ptr [bp + di + 0x75], al
  01756C  7273             jb 0x175e1
  01756E  3a20             cmp ah, byte ptr [bx + si]
  017570  2825             sub byte ptr [di], ah
  017572  642c20           sub al, 0x20
  017575  256429           and ax, 0x2964
  017578  005465           add byte ptr [si + 0x65], dl
  01757B  7272             jb 0x175ef
  01757D  61               popaw
  01757E  696e206174       imul bp, word ptr [bp + 0x20], 0x7461
  017583  206375           and byte ptr [bp + di + 0x75], ah
  017586  7273             jb 0x175fb
  017588  6f               outsw dx, word ptr [si]
  017589  723a             jb 0x175c5
  01758B  005365           add byte ptr [bp + di + 0x65], dl
  01758E  6c               insb byte ptr es:[di], dx
  01758F  65637465         arpl word ptr gs:[si + 0x65], si
  017593  643a00           cmp al, byte ptr fs:[bx + si]
  017596  53               push bx
  017597  686966           push 0x6669
  01759A  742d             je 0x175c9
  01759C  4c               dec sp
  01759D  6566743a         je 0x175db
  0175A1  2020             and byte ptr [bx + si], ah
  0175A3  41               inc cx
  0175A4  6464005368       add byte ptr fs:[bp + di + 0x68], dl
  0175A9  6966742d52       imul sp, word ptr [bp + 0x74], 0x522d
  0175AE  696768743a       imul sp, word ptr [bx + 0x68], 0x3a74
  0175B3  205265           and byte ptr [bp + si + 0x65], dl
  0175B6  6d               insw word ptr es:[di], dx
  0175B7  6f               outsw dx, word ptr [si]
  0175B8  7665             jbe 0x1761f
  0175BA  005368           add byte ptr [bp + di + 0x68], dl
  0175BD  6966742d4c       imul sp, word ptr [bp + 0x74], 0x4c2d
  0175C2  6566743a         je 0x17600
  0175C6  2020             and byte ptr [bx + si], ah
  0175C8  41               inc cx
  0175C9  6464005368       add byte ptr fs:[bp + di + 0x68], dl
  0175CE  6966742d52       imul sp, word ptr [bp + 0x74], 0x522d
  0175D3  696768743a       imul sp, word ptr [bx + 0x68], 0x3a74
  0175D8  205265           and byte ptr [bp + si + 0x65], dl
  0175DB  6d               insw word ptr es:[di], dx
  0175DC  6f               outsw dx, word ptr [si]
  0175DD  7665             jbe 0x17644
  0175DF  005368           add byte ptr [bp + di + 0x68], dl
  0175E2  6966742d4c       imul sp, word ptr [bp + 0x74], 0x4c2d
  0175E7  6566743a         je 0x17625
  0175EB  2020             and byte ptr [bx + si], ah
  0175ED  50               push ax
  0175EE  61               popaw
  0175EF  696e740053       imul bp, word ptr [bp + 0x74], 0x5300
  0175F4  686966           push 0x6669
  0175F7  742d             je 0x17626
  0175F9  52               push dx
  0175FA  696768743a       imul sp, word ptr [bx + 0x68], 0x3a74
  0175FF  205069           and byte ptr [bx + si + 0x69], dl
  017602  636b20           arpl word ptr [bp + di + 0x20], bp
  017605  7570             jne 0x17677
  017607  004669           add byte ptr [bp + 0x69], al
  01760A  6c               insb byte ptr es:[di], dx
  01760B  6c               insb byte ptr es:[di], dx
  01760C  207261           and byte ptr [bp + si + 0x61], dh
  01760F  646975733a20     imul si, word ptr fs:[di + 0x73], 0x203a
  017615  256400           and ax, 0x64
  017618  43               inc bx
  017619  6f               outsw dx, word ptr [si]
  01761A  61               popaw
  01761B  7374             jae 0x17691
  01761D  205072           and byte ptr [bx + si + 0x72], dl
  017620  6f               outsw dx, word ptr [si]
  017621  7465             je 0x17688
  017623  63743a           arpl word ptr [si + 0x3a], si
  017626  204f4e           and byte ptr [bx + 0x4e], cl
  017629  00436f           add byte ptr [bp + di + 0x6f], al
  01762C  61               popaw
  01762D  7374             jae 0x176a3
  01762F  205072           and byte ptr [bx + si + 0x72], dl
  017632  6f               outsw dx, word ptr [si]
  017633  7465             je 0x1769a
  017635  63743a           arpl word ptr [si + 0x3a], si
  017638  204f46           and byte ptr [bx + 0x46], cl
  01763B  46               inc si
  01763C  0000             add byte ptr [bx + si], al
  01763E  0100             add word ptr [bx + si], ax
  017640  4d               dec bp
  017641  45               inc bp
  017642  4d               dec bp
  017643  4f               dec di
  017644  52               push dx
  017645  59               pop cx
  017646  004445           add byte ptr [si + 0x45], al
  017649  42               inc dx
  01764A  55               push bp
  01764B  47               inc di
  01764C  00554e           add byte ptr [di + 0x4e], dl
  01764F  54               push sp
  017650  49               dec cx
  017651  54               push sp
  017652  4c               dec sp
  017653  45               inc bp
  017654  44               inc sp
  017655  2e4d             dec bp
  017657  50               push ax
  017658  004e45           add byte ptr [bp + 0x45], cl
  01765B  57               push di
  01765C  4e               dec si
  01765D  41               inc cx
  01765E  4d               dec bp
  01765F  45               inc bp
  017660  004d41           add byte ptr [di + 0x41], cl
  017663  50               push ax
  017664  45               inc bp
  017665  44               inc sp
  017666  49               dec cx
  017667  54               push sp
  017668  004d50           add byte ptr [di + 0x50], cl
  01766B  00434f           add byte ptr [bp + di + 0x4f], al
  01766E  4e               dec si
  01766F  54               push sp
  017670  49               dec cx
  017671  4e               dec si
  017672  45               inc bp
  017673  4e               dec si
  017674  54               push sp
  017675  53               push bx
  017676  3100             xor word ptr [bx + si], ax
  017678  4d               dec bp
  017679  41               inc cx
  01767A  50               push ax
  01767B  45               inc bp
  01767C  44               inc sp
  01767D  49               dec cx
  01767E  54               push sp
  01767F  00434f           add byte ptr [bp + di + 0x4f], al
  017682  4e               dec si
  017683  54               push sp
  017684  49               dec cx
  017685  4e               dec si
  017686  45               inc bp
  017687  4e               dec si
  017688  54               push sp
  017689  53               push bx
  01768A  3200             xor al, byte ptr [bx + si]
  01768C  4d               dec bp
  01768D  41               inc cx
  01768E  50               push ax
  01768F  45               inc bp
  017690  44               inc sp
  017691  49               dec cx
  017692  54               push sp
  017693  005341           add byte ptr [bp + di + 0x41], dl
  017696  56               push si
  017697  45               inc bp
  017698  004d41           add byte ptr [di + 0x41], cl
  01769B  50               push ax
  01769C  45               inc bp
  01769D  44               inc sp
  01769E  49               dec cx
  01769F  54               push sp
  0176A0  004552           add byte ptr [di + 0x52], al
  0176A3  52               push dx
  0176A4  4f               dec di
  0176A5  52               push dx
  0176A6  004d41           add byte ptr [di + 0x41], cl
  0176A9  50               push ax
  0176AA  45               inc bp
  0176AB  44               inc sp
  0176AC  49               dec cx
  0176AD  54               push sp
  0176AE  005341           add byte ptr [bp + di + 0x41], dl
  0176B1  56               push si
  0176B2  45               inc bp
  0176B3  41               inc cx
  0176B4  53               push bx
  0176B5  004d41           add byte ptr [di + 0x41], cl
  0176B8  50               push ax
  0176B9  45               inc bp
  0176BA  44               inc sp
  0176BB  49               dec cx
  0176BC  54               push sp
  0176BD  004d50           add byte ptr [di + 0x50], cl
  0176C0  004552           add byte ptr [di + 0x52], al
  0176C3  52               push dx
  0176C4  4f               dec di
  0176C5  52               push dx
  0176C6  004d41           add byte ptr [di + 0x41], cl
  0176C9  50               push ax
  0176CA  45               inc bp
  0176CB  44               inc sp
  0176CC  49               dec cx
  0176CD  54               push sp
  0176CE  004352           add byte ptr [bp + di + 0x52], al
  0176D1  45               inc bp
  0176D2  41               inc cx
  0176D3  54               push sp
  0176D4  45               inc bp
  0176D5  4e               dec si
  0176D6  4f               dec di
  0176D7  57               push di
  0176D8  004d41           add byte ptr [di + 0x41], cl
  0176DB  50               push ax
  0176DC  45               inc bp
  0176DD  44               inc sp
  0176DE  49               dec cx
  0176DF  54               push sp
  0176E0  004c4f           add byte ptr [si + 0x4f], cl
  0176E3  41               inc cx
  0176E4  44               inc sp
  0176E5  004d41           add byte ptr [di + 0x41], cl
  0176E8  50               push ax
  0176E9  45               inc bp
  0176EA  44               inc sp
  0176EB  49               dec cx
  0176EC  54               push sp
  0176ED  002a             add byte ptr [bp + si], ch
  0176EF  2e4d             dec bp
  0176F1  50               push ax
  0176F2  004d41           add byte ptr [di + 0x41], cl
  0176F5  50               push ax
  0176F6  54               push sp
  0176F7  4f               dec di
  0176F8  4c               dec sp
  0176F9  4f               dec di
  0176FA  41               inc cx
  0176FB  44               inc sp
  0176FC  004d41           add byte ptr [di + 0x41], cl
  0176FF  50               push ax
  017700  45               inc bp
  017701  44               inc sp
  017702  49               dec cx
  017703  54               push sp
  017704  004552           add byte ptr [di + 0x52], al
  017707  52               push dx
  017708  4f               dec di
  017709  52               push dx
  01770A  004d41           add byte ptr [di + 0x41], cl
  01770D  50               push ax
  01770E  45               inc bp
  01770F  44               inc sp
  017710  49               dec cx
  017711  54               push sp
  017712  004558           add byte ptr [di + 0x58], al
  017715  49               dec cx
  017716  54               push sp
  017717  004d41           add byte ptr [di + 0x41], cl
  01771A  50               push ax
  01771B  45               inc bp
  01771C  44               inc sp
  01771D  49               dec cx
  01771E  54               push sp
  01771F  004552           add byte ptr [di + 0x52], al
  017722  52               push dx
  017723  4f               dec di
  017724  52               push dx
  017725  004d41           add byte ptr [di + 0x41], cl
  017728  50               push ax
  017729  45               inc bp
  01772A  44               inc sp
  01772B  49               dec cx
  01772C  54               push sp
  01772D  004845           add byte ptr [bx + si + 0x45], cl
  017730  4c               dec sp
  017731  50               push ax
  017732  3100             xor word ptr [bx + si], ax
  017734  4d               dec bp
  017735  41               inc cx
  017736  50               push ax
  017737  45               inc bp
  017738  44               inc sp
  017739  49               dec cx
  01773A  54               push sp
  01773B  004845           add byte ptr [bx + si + 0x45], cl
  01773E  4c               dec sp
  01773F  50               push ax
  017740  3200             xor al, byte ptr [bx + si]
  017742  4d               dec bp
  017743  41               inc cx
  017744  50               push ax
  017745  45               inc bp
  017746  44               inc sp
  017747  49               dec cx
  017748  54               push sp
  017749  004845           add byte ptr [bx + si + 0x45], cl
  01774C  4c               dec sp
  01774D  50               push ax
  01774E  3300             xor ax, word ptr [bx + si]
  017750  4d               dec bp
  017751  41               inc cx
  017752  50               push ax
  017753  45               inc bp
  017754  44               inc sp
  017755  49               dec cx
  017756  54               push sp
  017757  004845           add byte ptr [bx + si + 0x45], cl
  01775A  4c               dec sp
  01775B  50               push ax
  01775C  3400             xor al, 0
  01775E  4d               dec bp
  01775F  41               inc cx
  017760  50               push ax
  017761  45               inc bp
  017762  44               inc sp
  017763  49               dec cx
  017764  54               push sp
  017765  004142           add byte ptr [bx + di + 0x42], al
  017768  4f               dec di
  017769  55               push bp
  01776A  54               push sp
  01776B  004d41           add byte ptr [di + 0x41], cl
  01776E  50               push ax
  01776F  45               inc bp
  017770  44               inc sp
  017771  49               dec cx
  017772  54               push sp
  017773  004558           add byte ptr [di + 0x58], al
  017776  49               dec cx
  017777  54               push sp
  017778  004d41           add byte ptr [di + 0x41], cl
  01777B  50               push ax
  01777C  45               inc bp
  01777D  44               inc sp
  01777E  49               dec cx
  01777F  54               push sp
  017780  004552           add byte ptr [di + 0x52], al
  017783  52               push dx
  017784  4f               dec di
  017785  52               push dx
  017786  004d41           add byte ptr [di + 0x41], cl
  017789  50               push ax
  01778A  45               inc bp
  01778B  44               inc sp
  01778C  49               dec cx
  01778D  54               push sp
  01778E  006e61           add byte ptr [bp + 0x61], ch
  017791  6d               insw word ptr es:[di], dx
  017792  657300           jae 0x17795
  017795  6c               insb byte ptr es:[di], dx
  017796  61               popaw
  017797  62656c           bound sp, dword ptr [di + 0x6c]
  01779A  7300             jae 0x1779c
  01779C  55               push bp
  01779D  4e               dec si
  01779E  46               inc si
  01779F  4f               dec di
  0177A0  52               push dx
  0177A1  45               inc bp
  0177A2  53               push bx
  0177A3  54               push sp
  0177A4  45               inc bp
  0177A5  44               inc sp
  0177A6  00464f           add byte ptr [bp + 0x4f], al
  0177A9  52               push dx
  0177AA  45               inc bp
  0177AB  53               push bx
  0177AC  54               push sp
  0177AD  45               inc bp
  0177AE  44               inc sp
  0177AF  004f54           add byte ptr [bx + 0x54], cl
  0177B2  48               dec ax
  0177B3  45               inc bp
  0177B4  52               push dx
  0177B5  004f54           add byte ptr [bx + 0x54], cl
  0177B8  48               dec ax
  0177B9  45               inc bp
  0177BA  52               push dx
  0177BB  5f               pop di
  0177BC  4e               dec si
  0177BD  41               inc cx
  0177BE  4d               dec bp
  0177BF  45               inc bp
  0177C0  53               push bx
  0177C1  00434f           add byte ptr [bp + di + 0x4f], al
  0177C4  4c               dec sp
  0177C5  4f               dec di
  0177C6  52               push dx
  0177C7  53               push bx
  0177C8  002a             add byte ptr [bp + si], ch
  0177CA  2e4d             dec bp
  0177CC  50               push ax
  0177CD  004d41           add byte ptr [di + 0x41], cl
  0177D0  50               push ax
  0177D1  54               push sp
  0177D2  4f               dec di
  0177D3  45               inc bp
  0177D4  44               inc sp
  0177D5  49               dec cx
  0177D6  54               push sp
  0177D7  004d41           add byte ptr [di + 0x41], cl
  0177DA  50               push ax
  0177DB  45               inc bp
  0177DC  44               inc sp
  0177DD  49               dec cx
  0177DE  54               push sp
  0177DF  007669           add byte ptr [bp + 0x69], dh
  0177E2  636572           arpl word ptr [di + 0x72], sp
  0177E5  6f               outsw dx, word ptr [si]
  0177E6  792e             jns 0x17816
  0177E8  7061             jo 0x1784b
  0177EA  6c               insb byte ptr es:[di], dx
  0177EB  00666f           add byte ptr [bp + 0x6f], ah
  0177EE  6e               outsb dx, byte ptr [si]
  0177EF  7469             je 0x1785a
  0177F1  6e               outsb dx, byte ptr [si]
  0177F2  7472             je 0x17866
  0177F4  00666f           add byte ptr [bp + 0x6f], ah
  0177F7  6e               outsb dx, byte ptr [si]
  0177F8  7474             je 0x1786e
  0177FA  696e790063       imul bp, word ptr [bp + 0x79], 0x6300
  0177FF  7572             jne 0x17873
  017801  736f             jae 0x17872
  017803  7200             jb 0x17805
  017805  7068             jo 0x1786f
  017807  7973             jns 0x1787c
  017809  3000             xor byte ptr [bx + si], al
  01780B  69636f6e73       imul sp, word ptr [bp + di + 0x6f], 0x736e
  017810  00776f           add byte ptr [bx + 0x6f], dh
  017813  6f               outsw dx, word ptr [si]
  017814  647469           je 0x17880
  017817  6c               insb byte ptr es:[di], dx
  017818  6500436f         add byte ptr gs:[bp + di + 0x6f], al
  01781C  6c               insb byte ptr es:[di], dx
  01781D  6f               outsw dx, word ptr [si]
  01781E  6e               outsb dx, byte ptr [si]
  01781F  697a617469       imul di, word ptr [bp + si + 0x61], 0x6974
  017824  6f               outsw dx, word ptr [si]
  017825  6e               outsb dx, byte ptr [si]
  017826  204d61           and byte ptr [di + 0x61], cl
  017829  7020             jo 0x1784b
  01782B  45               inc bp
  01782C  6469746f720a     imul si, word ptr fs:[si + 0x6f], 0xa72
  017832  00436f           add byte ptr [bp + di + 0x6f], al
  017835  7079             jo 0x178b0
  017837  7269             jb 0x178a2
  017839  67687420         push 0x2074
  01783D  284329           sub byte ptr [bp + di + 0x29], al
  017840  2031             and byte ptr [bx + di], dh
  017842  3939             cmp word ptr [bx + di], di
  017844  3420             xor al, 0x20
  017846  627920           bound di, dword ptr [bx + di + 0x20]
  017849  4d               dec bp
  01784A  6963726f70       imul sp, word ptr [bp + di + 0x72], 0x706f
  01784F  726f             jb 0x178c0
  017851  7365             jae 0x178b8
  017853  20536f           and byte ptr [bp + di + 0x6f], dl
  017856  667477           je 0x178d0
  017859  61               popaw
  01785A  7265             jb 0x178c1
  01785C  0a0a             or cl, byte ptr [bp + si]
  01785E  004f70           add byte ptr [bx + 0x70], cl
  017861  7469             je 0x178cc
  017863  6f               outsw dx, word ptr [si]
  017864  6e               outsb dx, byte ptr [si]
  017865  733a             jae 0x178a1
  017867  0a00             or al, byte ptr [bx + si]
  017869  2020             and byte ptr [bx + si], ah
  01786B  6d               insw word ptr es:[di], dx
  01786C  61               popaw
  01786D  7065             jo 0x178d4
  01786F  646974202020     imul si, word ptr fs:[si + 0x20], 0x2020
  017875  2020             and byte ptr [bx + si], ah
  017877  2020             and byte ptr [bx + si], ah
  017879  2020             and byte ptr [bx + si], ah
  01787B  2020             and byte ptr [bx + si], ah
  01787D  3d2053           cmp ax, 0x5320
  017880  7461             je 0x178e3
  017882  7274             jb 0x178f8
  017884  7320             jae 0x178a6
  017886  656469746f7220   imul si, word ptr fs:[si + 0x6f], 0x2072
  01788D  6e               outsb dx, byte ptr [si]
  01788E  6f               outsw dx, word ptr [si]
  01788F  726d             jb 0x178fe
  017891  61               popaw
  017892  6c               insb byte ptr es:[di], dx
  017893  6c               insb byte ptr es:[di], dx
  017894  790a             jns 0x178a0
  017896  0020             add byte ptr [bx + si], ah
  017898  206d61           and byte ptr [di + 0x61], ch
  01789B  7065             jo 0x17902
  01789D  646974202d63     imul si, word ptr fs:[si + 0x20], 0x632d
  0178A3  2020             and byte ptr [bx + si], ah
  0178A5  2020             and byte ptr [bx + si], ah
  0178A7  2020             and byte ptr [bx + si], ah
  0178A9  2020             and byte ptr [bx + si], ah
  0178AB  3d2046           cmp ax, 0x4620
  0178AE  6f               outsw dx, word ptr [si]
  0178AF  7263             jb 0x17914
  0178B1  65206372         and byte ptr gs:[bp + di + 0x72], ah
  0178B5  6561             popaw
  0178B7  7469             je 0x17922
  0178B9  6f               outsw dx, word ptr [si]
  0178BA  6e               outsb dx, byte ptr [si]
  0178BB  206f66           and byte ptr [bx + 0x66], ch
  0178BE  206e65           and byte ptr [bp + 0x65], ch
  0178C1  7720             ja 0x178e3
  0178C3  6d               insw word ptr es:[di], dx
  0178C4  61               popaw
  0178C5  700a             jo 0x178d1
  0178C7  0020             add byte ptr [bx + si], ah
  0178C9  206d61           and byte ptr [di + 0x61], ch
  0178CC  7065             jo 0x17933
  0178CE  646974202d6d     imul si, word ptr fs:[si + 0x20], 0x6d2d
  0178D4  3a6669           cmp ah, byte ptr [bp + 0x69]
  0178D7  6c               insb byte ptr es:[di], dx
  0178D8  652020           and byte ptr gs:[bx + si], ah
  0178DB  203d             and byte ptr [di], bh
  0178DD  204564           and byte ptr [di + 0x64], al
  0178E0  6974732073       imul si, word ptr [si + 0x73], 0x7320
  0178E5  7065             jo 0x1794c
  0178E7  636966           arpl word ptr [bx + di + 0x66], bp
  0178EA  6965642066       imul sp, word ptr [di + 0x64], 0x6620
  0178EF  696c650a00       imul bp, word ptr [si + 0x65], 0xa
  0178F4  2d2f00           sub ax, 0x2f
  0178F7  45               inc bp
  0178F8  7869             js 0x17963
  0178FA  7420             je 0x1791c
  0178FC  7661             jbe 0x1795f
  0178FE  6c               insb byte ptr es:[di], dx
  0178FF  7565             jne 0x17966
  017901  3a20             cmp ah, byte ptr [bx + si]
  017903  25640a           and ax, 0xa64
  017906  0000             add byte ptr [bx + si], al
  017908  3000             xor byte ptr [bx + si], al
  01790A  0000             add byte ptr [bx + si], al
  01790C  0000             add byte ptr [bx + si], al
  01790E  0000             add byte ptr [bx + si], al
  017910  6d               insw word ptr es:[di], dx
  017911  7000             jo 0x17913
  017913  0000             add byte ptr [bx + si], al
  017915  0000             add byte ptr [bx + si], al
  017917  0000             add byte ptr [bx + si], al
  017919  0000             add byte ptr [bx + si], al
  01791B  0000             add byte ptr [bx + si], al
  01791D  0000             add byte ptr [bx + si], al
  01791F  0000             add byte ptr [bx + si], al
  017921  0000             add byte ptr [bx + si], al
  017923  0000             add byte ptr [bx + si], al
  017925  0000             add byte ptr [bx + si], al
  017927  0000             add byte ptr [bx + si], al
  017929  0000             add byte ptr [bx + si], al
  01792B  0000             add byte ptr [bx + si], al
  01792D  0000             add byte ptr [bx + si], al
  01792F  0000             add byte ptr [bx + si], al
  017931  0000             add byte ptr [bx + si], al
  017933  0000             add byte ptr [bx + si], al
  017935  0000             add byte ptr [bx + si], al
  017937  0000             add byte ptr [bx + si], al
  017939  0000             add byte ptr [bx + si], al
  01793B  0000             add byte ptr [bx + si], al
  01793D  0000             add byte ptr [bx + si], al
  01793F  0000             add byte ptr [bx + si], al
  017941  006400           add byte ptr [si], ah
  017944  0a00             or al, byte ptr [bx + si]
  017946  0000             add byte ptr [bx + si], al
  017948  0000             add byte ptr [bx + si], al
  01794A  0000             add byte ptr [bx + si], al
  01794C  0000             add byte ptr [bx + si], al
  01794E  06               push es
  01794F  0001             add byte ptr [bx + di], al
  017951  0002             add byte ptr [bp + si], al
  017953  0003             add byte ptr [bp + di], al
  017955  0004             add byte ptr [si], al
  017957  0005             add byte ptr [di], al
  017959  00060006         add byte ptr [0x600], al
  01795D  0009             add byte ptr [bx + di], cl
  01795F  0001             add byte ptr [bx + di], al
  017961  0008             add byte ptr [bx + si], cl
  017963  0009             add byte ptr [bx + di], cl
  017965  000a             add byte ptr [bp + si], cl
  017967  000a             add byte ptr [bp + si], cl
  017969  00060006         add byte ptr [0x600], al
  01796D  0009             add byte ptr [bx + di], cl
  01796F  0001             add byte ptr [bx + di], al
  017971  0008             add byte ptr [bx + si], cl
  017973  0009             add byte ptr [bx + di], cl
  017975  000a             add byte ptr [bp + si], cl
  017977  000a             add byte ptr [bp + si], cl
  017979  00060006         add byte ptr [0x600], al
  01797D  00ff             add bh, bh
  01797F  ff07             inc word ptr [bx]
  017981  00ff             add bh, bh
  017983  ff0c             dec word ptr [si]
  017985  000d             add byte ptr [di], cl
  017987  00496c           add byte ptr [bx + di + 0x6c], cl
  01798A  6c               insb byte ptr es:[di], dx
  01798B  656761           popaw
  01798E  6c               insb byte ptr es:[di], dx
  01798F  20656e           and byte ptr [di + 0x6e], ah
  017992  7472             je 0x17a06
  017994  7920             jns 0x179b6
  017996  696e746f20       imul bp, word ptr [bp + 0x74], 0x206f
  01799B  7669             jbe 0x17a06
  01799D  6c               insb byte ptr es:[di], dx
  01799E  6c               insb byte ptr es:[di], dx
  01799F  61               popaw
  0179A0  67650000         add byte ptr gs:[eax], al
  0179A4  2453             and al, 0x53
  0179A6  54               push sp
  0179A7  52               push dx
  0179A8  49               dec cx
  0179A9  4e               dec si
  0179AA  47               inc di
  0179AB  0007             add byte ptr [bx], al
  0179AD  0007             add byte ptr [bx], al
  0179AF  0008             add byte ptr [bx + si], cl
  0179B1  0008             add byte ptr [bx + si], cl
  0179B3  0000             add byte ptr [bx + si], al
  0179B5  0000             add byte ptr [bx + si], al
  0179B7  0000             add byte ptr [bx + si], al
  0179B9  0000             add byte ptr [bx + si], al
  0179BB  0008             add byte ptr [bx + si], cl
  0179BD  000f             add byte ptr [bx], cl
  0179BF  0007             add byte ptr [bx], al
  0179C1  0008             add byte ptr [bx + si], cl
  0179C3  0000             add byte ptr [bx + si], al
  0179C5  0000             add byte ptr [bx + si], al
  0179C7  00ff             add bh, bh
  0179C9  ff               .byte 0xff
  0179CA  ff               .byte 0xff
  0179CB  ff               .byte 0xff
  0179CC  ff               .byte 0xff
  0179CD  ff               .byte 0xff
  0179CE  ff               .byte 0xff
  0179CF  ff               .byte 0xff
  0179D0  ff               .byte 0xff
  0179D1  ff00             inc word ptr [bx + si]
  0179D3  0001             add byte ptr [bx + di], al
  0179D5  0000             add byte ptr [bx + si], al
  0179D7  0000             add byte ptr [bx + si], al
  0179D9  0000             add byte ptr [bx + si], al
  0179DB  0000             add byte ptr [bx + si], al
  0179DD  0000             add byte ptr [bx + si], al
  0179DF  0000             add byte ptr [bx + si], al
  0179E1  004b49           add byte ptr [bp + di + 0x49], cl
  0179E4  4e               dec si
  0179E5  47               inc di
  0179E6  00494e           add byte ptr [bx + di + 0x4e], cl
  0179E9  44               inc sp
  0179EA  304130           xor byte ptr [bx + di + 0x30], al
  0179ED  004d53           add byte ptr [di + 0x53], cl
  0179F0  53               push bx
  0179F1  3000             xor byte ptr [bx + si], al
  0179F3  4d               dec bp
  0179F4  59               pop cx
  0179F5  52               push dx
  0179F6  3000             xor byte ptr [bx + si], al
  0179F8  3200             xor al, byte ptr [bx + si]
  0179FA  0000             add byte ptr [bx + si], al
  0179FC  7e7b             jle 0x17a79
  0179FE  7d7c             jge 0x17a7c
  017A00  007e5b           add byte ptr [bp + 0x5b], bh
  017A03  2000             and byte ptr [bx + si], al
  017A05  2000             and byte ptr [bx + si], al
  017A07  57               push di
  017A08  0020             add byte ptr [bx + si], ah
  017A0A  005f00           add byte ptr [bx], bl
  017A0D  0000             add byte ptr [bx + si], al
  017A0F  0000             add byte ptr [bx + si], al
  017A11  0000             add byte ptr [bx + si], al
  017A13  0c53             or al, 0x53
  017A15  54               push sp
  017A16  52               push dx
  017A17  49               dec cx
  017A18  4e               dec si
  017A19  47               inc di
  017A1A  004e55           add byte ptr [bp + 0x55], cl
  017A1D  4d               dec bp
  017A1E  42               inc dx
  017A1F  45               inc bp
  017A20  52               push dx
  017A21  004845           add byte ptr [bx + si + 0x45], cl
  017A24  58               pop ax
  017A25  0030             add byte ptr [bx + si], dh
  017A27  00434f           add byte ptr [bp + di + 0x4f], al
  017A2A  55               push bp
  017A2B  4e               dec si
  017A2C  54               push sp
  017A2D  52               push dx
  017A2E  59               pop cx
  017A2F  005945           add byte ptr [bx + di + 0x45], bl
  017A32  41               inc cx
  017A33  52               push dx
  017A34  0025             add byte ptr [di], ah
  017A36  004f50           add byte ptr [bx + 0x50], cl
  017A39  54               push sp
  017A3A  49               dec cx
  017A3B  4f               dec di
  017A3C  4e               dec si
  017A3D  53               push bx
  017A3E  005052           add byte ptr [bx + si + 0x52], dl
  017A41  4f               dec di
  017A42  4d               dec bp
  017A43  50               push ax
  017A44  54               push sp
  017A45  005445           add byte ptr [si + 0x45], dl
  017A48  58               pop ax
  017A49  54               push sp
  017A4A  00534d           add byte ptr [bp + di + 0x4d], dl
  017A4D  41               inc cx
  017A4E  4c               dec sp
  017A4F  4c               dec sp
  017A50  46               inc si
  017A51  4f               dec di
  017A52  4e               dec si
  017A53  54               push sp
  017A54  005900           add byte ptr [bx + di], bl
  017A57  58               pop ax
  017A58  005749           add byte ptr [bx + 0x49], dl
  017A5B  44               inc sp
  017A5C  54               push sp
  017A5D  48               dec ax
  017A5E  004c45           add byte ptr [si + 0x45], cl
  017A61  4e               dec si
  017A62  47               inc di
  017A63  54               push sp
  017A64  48               dec ax
  017A65  004348           add byte ptr [bp + di + 0x48], al
  017A68  45               inc bp
  017A69  43               inc bx
  017A6A  4b               dec bx
  017A6B  42               inc dx
  017A6C  4f               dec di
  017A6D  58               pop ax
  017A6E  004445           add byte ptr [si + 0x45], al
  017A71  46               inc si
  017A72  41               inc cx
  017A73  55               push bp
  017A74  4c               dec sp
  017A75  54               push sp
  017A76  0000             add byte ptr [bx + si], al
  017A78  0000             add byte ptr [bx + si], al
  017A7A  54               push sp
  017A7B  45               inc bp
  017A7C  58               pop ax
  017A7D  54               push sp
  017A7E  43               inc bx
  017A7F  4f               dec di
  017A80  4c               dec sp
  017A81  52               push dx
  017A82  0000             add byte ptr [bx + si], al
  017A84  07               pop es
  017A85  0007             add byte ptr [bx], al
  017A87  0007             add byte ptr [bx], al
  017A89  0007             add byte ptr [bx], al
  017A8B  0008             add byte ptr [bx + si], cl
  017A8D  0008             add byte ptr [bx + si], cl
  017A8F  0008             add byte ptr [bx + si], cl
  017A91  0008             add byte ptr [bx + si], cl
  017A93  0000             add byte ptr [bx + si], al
  017A95  0000             add byte ptr [bx + si], al
  017A97  0008             add byte ptr [bx + si], cl
  017A99  000f             add byte ptr [bx], cl
  017A9B  0000             add byte ptr [bx + si], al
  017A9D  0008             add byte ptr [bx + si], cl
  017A9F  000f             add byte ptr [bx], cl
  017AA1  0000             add byte ptr [bx + si], al
  017AA3  004d45           add byte ptr [di + 0x45], cl
  017AA6  4e               dec si
  017AA7  55               push bp
  017AA8  43               inc bx
  017AA9  4f               dec di
  017AAA  4c               dec sp
  017AAB  52               push dx
  017AAC  2e53             push bx
  017AAE  53               push bx
  017AAF  0000             add byte ptr [bx + si], al
  017AB1  005458           add byte ptr [si + 0x58], dl
  017AB4  54               push sp
  017AB5  007274           add byte ptr [bp + si + 0x74], dh
  017AB8  0000             add byte ptr [bx + si], al
  017ABA  2000             and byte ptr [bx + si], al
  017ABC  2c20             sub al, 0x20
  017ABE  003a             add byte ptr [bp + si], bh
  017AC0  2000             and byte ptr [bx + si], al
  017AC2  2e2020           and byte ptr cs:[bx + si], ah
  017AC5  0025             add byte ptr [di], ah
  017AC7  0028             add byte ptr [bx + si], ch
  017AC9  0029             add byte ptr [bx + di], ch
  017ACB  007b00           add byte ptr [bp + di], bh
  017ACE  7d00             jge 0x17ad0
  017AD0  2b00             sub ax, word ptr [bx + si]
  017AD2  2d0078           sub ax, 0x7800
  017AD5  0030             add byte ptr [bx + si], dh
  017AD7  0024             add byte ptr [si], ah
  017AD9  006761           add byte ptr [bx + 0x61], ah
  017ADC  6d               insw word ptr es:[di], dx
  017ADD  65006d65         add byte ptr gs:[di + 0x65], ch
  017AE1  6e               outsb dx, byte ptr [si]
  017AE2  7500             jne 0x17ae4
  017AE4  0000             add byte ptr [bx + si], al
  017AE6  0000             add byte ptr [bx + si], al
  017AE8  7669             jbe 0x17b53
  017AEA  657700           ja 0x17aed
  017AED  0000             add byte ptr [bx + si], al
  017AEF  0000             add byte ptr [bx + si], al
  017AF1  6f               outsw dx, word ptr [si]
  017AF2  7264             jb 0x17b58
  017AF4  657273           jb 0x17b6a
  017AF7  0000             add byte ptr [bx + si], al
  017AF9  0000             add byte ptr [bx + si], al
  017AFB  007265           add byte ptr [bp + si + 0x65], dh
  017AFE  706f             jo 0x17b6f
  017B00  7274             jb 0x17b76
  017B02  7300             jae 0x17b04
  017B04  0000             add byte ptr [bx + si], al
  017B06  007472           add byte ptr [si + 0x72], dh
  017B09  61               popaw
  017B0A  6465006375       add byte ptr gs:[bp + di + 0x75], ah
  017B0F  7000             jo 0x17b11
  017B11  0000             add byte ptr [bx + si], al
  017B13  0000             add byte ptr [bx + si], al
  017B15  7065             jo 0x17b7c
  017B17  646961000074     imul sp, word ptr fs:[bx + di], 0x7400
  017B1D  657272           jb 0x17b92
  017B20  61               popaw
  017B21  696e000001       imul bp, word ptr [bp], 0x100
  017B26  00ff             add bh, bh
  017B28  0000             add byte ptr [bx + si], al
  017B2A  ff00             inc word ptr [bx + si]
  017B2C  0100             add word ptr [bx + si], ax
  017B2E  0000             add byte ptr [bx + si], al
  017B30  0001             add byte ptr [bx + di], al
  017B32  0101             add word ptr [bx + di], ax
  017B34  00ff             add bh, bh
  017B36  ff               .byte 0xff
  017B37  ff00             inc word ptr [bx + si]
  017B39  00ff             add bh, bh
  017B3B  ff00             inc word ptr [bx + si]
  017B3D  0101             add word ptr [bx + di], ax
  017B3F  0100             add word ptr [bx + si], ax
  017B41  ff00             inc word ptr [bx + si]
  017B43  0000             add byte ptr [bx + si], al
  017B45  0100             add word ptr [bx + si], ax
  017B47  ff               .byte 0xff
  017B48  ff01             inc word ptr [bx + di]
  017B4A  01ff             add di, di
  017B4C  0002             add byte ptr [bp + si], al
  017B4E  00fe             add dh, bh
  017B50  ff01             inc word ptr [bx + di]
  017B52  ff01             inc word ptr [bx + di]
  017B54  fe               .byte 0xfe
  017B55  fe02             inc byte ptr [bp + si]
  017B57  0200             add al, byte ptr [bx + si]
  017B59  00ff             add bh, bh
  017B5B  0001             add byte ptr [bx + di], al
  017B5D  00ff             add bh, bh
  017B5F  ff01             inc word ptr [bx + di]
  017B61  01fe             add si, di
  017B63  0002             add byte ptr [bp + si], al
  017B65  00fe             add dh, bh
  017B67  fe02             inc byte ptr [bp + si]
  017B69  02ff             add bh, bh
  017B6B  01ff             add di, di
  017B6D  0100             add word ptr [bx + si], ax
  017B6F  004261           add byte ptr [bp + si + 0x61], al
  017B72  636875           arpl word ptr [bx + si + 0x75], bp
  017B75  6e               outsb dx, byte ptr [si]
  017B76  6761             popaw
  017B78  0a00             or al, byte ptr [bx + si]
  017B7A  7262             jb 0x17bde
  017B7C  007762           add byte ptr [bx + 0x62], dh
  017B7F  007262           add byte ptr [bp + si + 0x62], dh
  017B82  0000             add byte ptr [bx + si], al
  017B84  0000             add byte ptr [bx + si], al
  017B86  0000             add byte ptr [bx + si], al
  017B88  0000             add byte ptr [bx + si], al
  017B8A  2e002e005c       add byte ptr cs:[0x5c00], ch
  017B8F  00ff             add bh, bh
  017B91  ff00             inc word ptr [bx + si]
  017B93  0000             add byte ptr [bx + si], al
  017B95  0000             add byte ptr [bx + si], al
  017B97  0000             add byte ptr [bx + si], al
  017B99  0000             add byte ptr [bx + si], al
  017B9B  0000             add byte ptr [bx + si], al
  017B9D  0000             add byte ptr [bx + si], al
  017B9F  0000             add byte ptr [bx + si], al
  017BA1  0000             add byte ptr [bx + si], al
  017BA3  0000             add byte ptr [bx + si], al
  017BA5  0000             add byte ptr [bx + si], al
  017BA7  0000             add byte ptr [bx + si], al
  017BA9  0000             add byte ptr [bx + si], al
  017BAB  0024             add byte ptr [si], ah
  017BAD  7072             jo 0x17c21
  017BAF  657365           jae 0x17c17
  017BB2  7276             jb 0x17c2a
  017BB4  0000             add byte ptr [bx + si], al
  017BB6  0000             add byte ptr [bx + si], al
  017BB8  0000             add byte ptr [bx + si], al
  017BBA  0000             add byte ptr [bx + si], al
  017BBC  0b00             or ax, word ptr [bx + si]
  017BBE  0000             add byte ptr [bx + si], al
  017BC0  0000             add byte ptr [bx + si], al
  017BC2  0000             add byte ptr [bx + si], al
  017BC4  0000             add byte ptr [bx + si], al
  017BC6  0000             add byte ptr [bx + si], al
  017BC8  0000             add byte ptr [bx + si], al
  017BCA  ff               .byte 0xff
  017BCB  ff               .byte 0xff
  017BCC  ff               .byte 0xff
  017BCD  ff00             inc word ptr [bx + si]
  017BCF  e1f5             loope 0x17bc6
  017BD1  05ffff           add ax, 0xffff
  017BD4  ff               .byte 0xff
  017BD5  ff00             inc word ptr [bx + si]
  017BD7  e1f5             loope 0x17bce
  017BD9  050000           add ax, 0
  017BDC  0000             add byte ptr [bx + si], al
  017BDE  0000             add byte ptr [bx + si], al
  017BE0  2473             and al, 0x73
  017BE2  7973             jns 0x17c57
  017BE4  2400             and al, 0
  017BE6  6c               insb byte ptr es:[di], dx
  017BE7  004000           add byte ptr [bx + si], al
  017BEA  1400             adc al, 0
  017BEC  0000             add byte ptr [bx + si], al
  017BEE  0000             add byte ptr [bx + si], al
  017BF0  0000             add byte ptr [bx + si], al
  017BF2  0000             add byte ptr [bx + si], al
  017BF4  0000             add byte ptr [bx + si], al
  017BF6  0000             add byte ptr [bx + si], al
  017BF8  0000             add byte ptr [bx + si], al
  017BFA  0000             add byte ptr [bx + si], al
  017BFC  0000             add byte ptr [bx + si], al
  017BFE  0000             add byte ptr [bx + si], al
  017C00  0000             add byte ptr [bx + si], al
  017C02  0000             add byte ptr [bx + si], al
  017C04  0000             add byte ptr [bx + si], al
  017C06  0000             add byte ptr [bx + si], al
  017C08  0000             add byte ptr [bx + si], al
  017C0A  0000             add byte ptr [bx + si], al
  017C0C  0000             add byte ptr [bx + si], al
  017C0E  0000             add byte ptr [bx + si], al
  017C10  0000             add byte ptr [bx + si], al
  017C12  0000             add byte ptr [bx + si], al
  017C14  0000             add byte ptr [bx + si], al
  017C16  0000             add byte ptr [bx + si], al
  017C18  0000             add byte ptr [bx + si], al
  017C1A  0000             add byte ptr [bx + si], al
  017C1C  0000             add byte ptr [bx + si], al
  017C1E  0000             add byte ptr [bx + si], al
  017C20  0000             add byte ptr [bx + si], al
  017C22  0000             add byte ptr [bx + si], al
  017C24  0000             add byte ptr [bx + si], al
  017C26  0000             add byte ptr [bx + si], al
  017C28  0000             add byte ptr [bx + si], al
  017C2A  0000             add byte ptr [bx + si], al
  017C2C  0000             add byte ptr [bx + si], al
  017C2E  0000             add byte ptr [bx + si], al
  017C30  0000             add byte ptr [bx + si], al
  017C32  0000             add byte ptr [bx + si], al
  017C34  0000             add byte ptr [bx + si], al
  017C36  0000             add byte ptr [bx + si], al
  017C38  0000             add byte ptr [bx + si], al
  017C3A  0000             add byte ptr [bx + si], al
  017C3C  0000             add byte ptr [bx + si], al
  017C3E  0000             add byte ptr [bx + si], al
  017C40  0000             add byte ptr [bx + si], al
  017C42  0000             add byte ptr [bx + si], al
  017C44  0000             add byte ptr [bx + si], al
  017C46  0000             add byte ptr [bx + si], al
  017C48  0000             add byte ptr [bx + si], al
  017C4A  0000             add byte ptr [bx + si], al
  017C4C  0000             add byte ptr [bx + si], al
  017C4E  0000             add byte ptr [bx + si], al
  017C50  0000             add byte ptr [bx + si], al
  017C52  0000             add byte ptr [bx + si], al
  017C54  0000             add byte ptr [bx + si], al
  017C56  0000             add byte ptr [bx + si], al
  017C58  0000             add byte ptr [bx + si], al
  017C5A  0000             add byte ptr [bx + si], al
  017C5C  0000             add byte ptr [bx + si], al
  017C5E  0000             add byte ptr [bx + si], al
  017C60  0000             add byte ptr [bx + si], al
  017C62  0000             add byte ptr [bx + si], al
  017C64  0000             add byte ptr [bx + si], al
  017C66  0000             add byte ptr [bx + si], al
  017C68  0000             add byte ptr [bx + si], al
  017C6A  0000             add byte ptr [bx + si], al
  017C6C  0000             add byte ptr [bx + si], al
  017C6E  0000             add byte ptr [bx + si], al
  017C70  0000             add byte ptr [bx + si], al
  017C72  0000             add byte ptr [bx + si], al
  017C74  0000             add byte ptr [bx + si], al
  017C76  0000             add byte ptr [bx + si], al
  017C78  0000             add byte ptr [bx + si], al
  017C7A  0000             add byte ptr [bx + si], al
  017C7C  0000             add byte ptr [bx + si], al
  017C7E  0000             add byte ptr [bx + si], al
  017C80  0000             add byte ptr [bx + si], al
  017C82  0000             add byte ptr [bx + si], al
  017C84  0000             add byte ptr [bx + si], al
  017C86  0000             add byte ptr [bx + si], al
  017C88  0000             add byte ptr [bx + si], al
  017C8A  0000             add byte ptr [bx + si], al
  017C8C  0000             add byte ptr [bx + si], al
  017C8E  0000             add byte ptr [bx + si], al
  017C90  0000             add byte ptr [bx + si], al
  017C92  0000             add byte ptr [bx + si], al
  017C94  0000             add byte ptr [bx + si], al
  017C96  0000             add byte ptr [bx + si], al
  017C98  0000             add byte ptr [bx + si], al
  017C9A  0000             add byte ptr [bx + si], al
  017C9C  0000             add byte ptr [bx + si], al
  017C9E  0000             add byte ptr [bx + si], al
  017CA0  0000             add byte ptr [bx + si], al
  017CA2  0000             add byte ptr [bx + si], al
  017CA4  0000             add byte ptr [bx + si], al
  017CA6  0000             add byte ptr [bx + si], al
  017CA8  0000             add byte ptr [bx + si], al
  017CAA  0000             add byte ptr [bx + si], al
  017CAC  0000             add byte ptr [bx + si], al
  017CAE  0000             add byte ptr [bx + si], al
  017CB0  0000             add byte ptr [bx + si], al
  017CB2  0000             add byte ptr [bx + si], al
  017CB4  0000             add byte ptr [bx + si], al
  017CB6  0000             add byte ptr [bx + si], al
  017CB8  0000             add byte ptr [bx + si], al
  017CBA  0000             add byte ptr [bx + si], al
  017CBC  0000             add byte ptr [bx + si], al
  017CBE  0000             add byte ptr [bx + si], al
  017CC0  0000             add byte ptr [bx + si], al
  017CC2  0000             add byte ptr [bx + si], al
  017CC4  0000             add byte ptr [bx + si], al
  017CC6  0000             add byte ptr [bx + si], al
  017CC8  0000             add byte ptr [bx + si], al
  017CCA  0000             add byte ptr [bx + si], al
  017CCC  0000             add byte ptr [bx + si], al
  017CCE  0000             add byte ptr [bx + si], al
  017CD0  0000             add byte ptr [bx + si], al
  017CD2  0000             add byte ptr [bx + si], al
  017CD4  0000             add byte ptr [bx + si], al
  017CD6  0000             add byte ptr [bx + si], al
  017CD8  0000             add byte ptr [bx + si], al
  017CDA  0000             add byte ptr [bx + si], al
  017CDC  0000             add byte ptr [bx + si], al
  017CDE  0000             add byte ptr [bx + si], al
  017CE0  0000             add byte ptr [bx + si], al
  017CE2  0000             add byte ptr [bx + si], al
  017CE4  0000             add byte ptr [bx + si], al
  017CE6  0000             add byte ptr [bx + si], al
  017CE8  0000             add byte ptr [bx + si], al
  017CEA  0000             add byte ptr [bx + si], al
  017CEC  0000             add byte ptr [bx + si], al
  017CEE  0000             add byte ptr [bx + si], al
  017CF0  0000             add byte ptr [bx + si], al
  017CF2  0000             add byte ptr [bx + si], al
  017CF4  0000             add byte ptr [bx + si], al
  017CF6  0000             add byte ptr [bx + si], al
  017CF8  0000             add byte ptr [bx + si], al
  017CFA  0000             add byte ptr [bx + si], al
  017CFC  0000             add byte ptr [bx + si], al
  017CFE  0000             add byte ptr [bx + si], al
  017D00  0000             add byte ptr [bx + si], al
  017D02  0000             add byte ptr [bx + si], al
  017D04  0000             add byte ptr [bx + si], al
  017D06  0000             add byte ptr [bx + si], al
  017D08  0000             add byte ptr [bx + si], al
  017D0A  0000             add byte ptr [bx + si], al
  017D0C  0000             add byte ptr [bx + si], al
  017D0E  0000             add byte ptr [bx + si], al
  017D10  0000             add byte ptr [bx + si], al
  017D12  0000             add byte ptr [bx + si], al
  017D14  0000             add byte ptr [bx + si], al
  017D16  0000             add byte ptr [bx + si], al
  017D18  0000             add byte ptr [bx + si], al
  017D1A  0000             add byte ptr [bx + si], al
  017D1C  0000             add byte ptr [bx + si], al
  017D1E  0000             add byte ptr [bx + si], al
  017D20  0000             add byte ptr [bx + si], al
  017D22  0000             add byte ptr [bx + si], al
  017D24  0000             add byte ptr [bx + si], al
  017D26  0000             add byte ptr [bx + si], al
  017D28  0000             add byte ptr [bx + si], al
  017D2A  0000             add byte ptr [bx + si], al
  017D2C  0000             add byte ptr [bx + si], al
  017D2E  0000             add byte ptr [bx + si], al
  017D30  0000             add byte ptr [bx + si], al
  017D32  0000             add byte ptr [bx + si], al
  017D34  0000             add byte ptr [bx + si], al
  017D36  0000             add byte ptr [bx + si], al
  017D38  0000             add byte ptr [bx + si], al
  017D3A  0000             add byte ptr [bx + si], al
  017D3C  0000             add byte ptr [bx + si], al
  017D3E  0000             add byte ptr [bx + si], al
  017D40  0000             add byte ptr [bx + si], al
  017D42  0000             add byte ptr [bx + si], al
  017D44  0000             add byte ptr [bx + si], al
  017D46  0000             add byte ptr [bx + si], al
  017D48  0000             add byte ptr [bx + si], al
  017D4A  0000             add byte ptr [bx + si], al
  017D4C  0000             add byte ptr [bx + si], al
  017D4E  0000             add byte ptr [bx + si], al
  017D50  0000             add byte ptr [bx + si], al
  017D52  0000             add byte ptr [bx + si], al
  017D54  0000             add byte ptr [bx + si], al
  017D56  0000             add byte ptr [bx + si], al
  017D58  0000             add byte ptr [bx + si], al
  017D5A  0000             add byte ptr [bx + si], al
  017D5C  0000             add byte ptr [bx + si], al
  017D5E  0000             add byte ptr [bx + si], al
  017D60  0000             add byte ptr [bx + si], al
  017D62  0000             add byte ptr [bx + si], al
  017D64  0000             add byte ptr [bx + si], al
  017D66  0000             add byte ptr [bx + si], al
  017D68  0000             add byte ptr [bx + si], al
  017D6A  0000             add byte ptr [bx + si], al
  017D6C  0000             add byte ptr [bx + si], al
  017D6E  0000             add byte ptr [bx + si], al
  017D70  0000             add byte ptr [bx + si], al
  017D72  0000             add byte ptr [bx + si], al
  017D74  0000             add byte ptr [bx + si], al
  017D76  0000             add byte ptr [bx + si], al
  017D78  0000             add byte ptr [bx + si], al
  017D7A  0000             add byte ptr [bx + si], al
  017D7C  0000             add byte ptr [bx + si], al
  017D7E  0000             add byte ptr [bx + si], al
  017D80  0000             add byte ptr [bx + si], al
  017D82  0000             add byte ptr [bx + si], al
  017D84  0000             add byte ptr [bx + si], al
  017D86  0000             add byte ptr [bx + si], al
  017D88  0000             add byte ptr [bx + si], al
  017D8A  0000             add byte ptr [bx + si], al
  017D8C  0000             add byte ptr [bx + si], al
  017D8E  0000             add byte ptr [bx + si], al
  017D90  0000             add byte ptr [bx + si], al
  017D92  0000             add byte ptr [bx + si], al
  017D94  0000             add byte ptr [bx + si], al
  017D96  0000             add byte ptr [bx + si], al
  017D98  0000             add byte ptr [bx + si], al
  017D9A  0000             add byte ptr [bx + si], al
  017D9C  0000             add byte ptr [bx + si], al
  017D9E  0000             add byte ptr [bx + si], al
  017DA0  0000             add byte ptr [bx + si], al
  017DA2  0000             add byte ptr [bx + si], al
  017DA4  0000             add byte ptr [bx + si], al
  017DA6  0000             add byte ptr [bx + si], al
  017DA8  0000             add byte ptr [bx + si], al
  017DAA  0000             add byte ptr [bx + si], al
  017DAC  0000             add byte ptr [bx + si], al
  017DAE  0000             add byte ptr [bx + si], al
  017DB0  0000             add byte ptr [bx + si], al
  017DB2  0000             add byte ptr [bx + si], al
  017DB4  0000             add byte ptr [bx + si], al
  017DB6  0000             add byte ptr [bx + si], al
  017DB8  0000             add byte ptr [bx + si], al
  017DBA  0000             add byte ptr [bx + si], al
  017DBC  0000             add byte ptr [bx + si], al
  017DBE  0000             add byte ptr [bx + si], al
  017DC0  0000             add byte ptr [bx + si], al
  017DC2  0000             add byte ptr [bx + si], al
  017DC4  0000             add byte ptr [bx + si], al
  017DC6  0000             add byte ptr [bx + si], al
  017DC8  0000             add byte ptr [bx + si], al
  017DCA  0000             add byte ptr [bx + si], al
  017DCC  0000             add byte ptr [bx + si], al
  017DCE  0000             add byte ptr [bx + si], al
  017DD0  0000             add byte ptr [bx + si], al
  017DD2  0000             add byte ptr [bx + si], al
  017DD4  0000             add byte ptr [bx + si], al
  017DD6  0000             add byte ptr [bx + si], al
  017DD8  0000             add byte ptr [bx + si], al
  017DDA  0000             add byte ptr [bx + si], al
  017DDC  0000             add byte ptr [bx + si], al
  017DDE  0000             add byte ptr [bx + si], al
  017DE0  0000             add byte ptr [bx + si], al
  017DE2  0000             add byte ptr [bx + si], al
  017DE4  0000             add byte ptr [bx + si], al
  017DE6  0000             add byte ptr [bx + si], al
  017DE8  0000             add byte ptr [bx + si], al
  017DEA  0000             add byte ptr [bx + si], al
  017DEC  0000             add byte ptr [bx + si], al
  017DEE  0000             add byte ptr [bx + si], al
  017DF0  0000             add byte ptr [bx + si], al
  017DF2  0000             add byte ptr [bx + si], al
  017DF4  0000             add byte ptr [bx + si], al
  017DF6  0000             add byte ptr [bx + si], al
  017DF8  0000             add byte ptr [bx + si], al
  017DFA  0000             add byte ptr [bx + si], al
  017DFC  0000             add byte ptr [bx + si], al
  017DFE  0000             add byte ptr [bx + si], al
  017E00  0000             add byte ptr [bx + si], al
  017E02  0000             add byte ptr [bx + si], al
  017E04  0000             add byte ptr [bx + si], al
  017E06  0000             add byte ptr [bx + si], al
  017E08  0000             add byte ptr [bx + si], al
  017E0A  0000             add byte ptr [bx + si], al
  017E0C  0000             add byte ptr [bx + si], al
  017E0E  0000             add byte ptr [bx + si], al
  017E10  0000             add byte ptr [bx + si], al
  017E12  0000             add byte ptr [bx + si], al
  017E14  0000             add byte ptr [bx + si], al
  017E16  0000             add byte ptr [bx + si], al
  017E18  0000             add byte ptr [bx + si], al
  017E1A  0000             add byte ptr [bx + si], al
  017E1C  0000             add byte ptr [bx + si], al
  017E1E  0000             add byte ptr [bx + si], al
  017E20  0000             add byte ptr [bx + si], al
  017E22  0000             add byte ptr [bx + si], al
  017E24  0000             add byte ptr [bx + si], al
  017E26  0000             add byte ptr [bx + si], al
  017E28  0000             add byte ptr [bx + si], al
  017E2A  0000             add byte ptr [bx + si], al
  017E2C  0000             add byte ptr [bx + si], al
  017E2E  0000             add byte ptr [bx + si], al
  017E30  0000             add byte ptr [bx + si], al
  017E32  0000             add byte ptr [bx + si], al
  017E34  0000             add byte ptr [bx + si], al
  017E36  0000             add byte ptr [bx + si], al
  017E38  0000             add byte ptr [bx + si], al
  017E3A  0000             add byte ptr [bx + si], al
  017E3C  0000             add byte ptr [bx + si], al
  017E3E  0000             add byte ptr [bx + si], al
  017E40  0000             add byte ptr [bx + si], al
  017E42  0000             add byte ptr [bx + si], al
  017E44  0000             add byte ptr [bx + si], al
  017E46  0000             add byte ptr [bx + si], al
  017E48  0000             add byte ptr [bx + si], al
  017E4A  0000             add byte ptr [bx + si], al
  017E4C  0000             add byte ptr [bx + si], al
  017E4E  0000             add byte ptr [bx + si], al
  017E50  0000             add byte ptr [bx + si], al
  017E52  0000             add byte ptr [bx + si], al
  017E54  0000             add byte ptr [bx + si], al
  017E56  0000             add byte ptr [bx + si], al
  017E58  0000             add byte ptr [bx + si], al
  017E5A  0000             add byte ptr [bx + si], al
  017E5C  0000             add byte ptr [bx + si], al
  017E5E  0000             add byte ptr [bx + si], al
  017E60  0000             add byte ptr [bx + si], al
  017E62  0000             add byte ptr [bx + si], al
  017E64  0000             add byte ptr [bx + si], al
  017E66  0000             add byte ptr [bx + si], al
  017E68  0000             add byte ptr [bx + si], al
  017E6A  0000             add byte ptr [bx + si], al
  017E6C  0000             add byte ptr [bx + si], al
  017E6E  0000             add byte ptr [bx + si], al
  017E70  0000             add byte ptr [bx + si], al
  017E72  0000             add byte ptr [bx + si], al
  017E74  0000             add byte ptr [bx + si], al
  017E76  0000             add byte ptr [bx + si], al
  017E78  0000             add byte ptr [bx + si], al
  017E7A  0000             add byte ptr [bx + si], al
  017E7C  0000             add byte ptr [bx + si], al
  017E7E  0000             add byte ptr [bx + si], al
  017E80  0000             add byte ptr [bx + si], al
  017E82  0000             add byte ptr [bx + si], al
  017E84  0000             add byte ptr [bx + si], al
  017E86  0000             add byte ptr [bx + si], al
  017E88  0000             add byte ptr [bx + si], al
  017E8A  0000             add byte ptr [bx + si], al
  017E8C  0000             add byte ptr [bx + si], al
  017E8E  0000             add byte ptr [bx + si], al
  017E90  0000             add byte ptr [bx + si], al
  017E92  0000             add byte ptr [bx + si], al
  017E94  0000             add byte ptr [bx + si], al
  017E96  0000             add byte ptr [bx + si], al
  017E98  0000             add byte ptr [bx + si], al
  017E9A  0000             add byte ptr [bx + si], al
  017E9C  0000             add byte ptr [bx + si], al
  017E9E  0000             add byte ptr [bx + si], al
  017EA0  0000             add byte ptr [bx + si], al
  017EA2  0000             add byte ptr [bx + si], al
  017EA4  0000             add byte ptr [bx + si], al
  017EA6  0000             add byte ptr [bx + si], al
  017EA8  0000             add byte ptr [bx + si], al
  017EAA  0000             add byte ptr [bx + si], al
  017EAC  0000             add byte ptr [bx + si], al
  017EAE  0000             add byte ptr [bx + si], al
  017EB0  0000             add byte ptr [bx + si], al
  017EB2  0000             add byte ptr [bx + si], al
  017EB4  0000             add byte ptr [bx + si], al
  017EB6  0000             add byte ptr [bx + si], al
  017EB8  0000             add byte ptr [bx + si], al
  017EBA  0000             add byte ptr [bx + si], al
  017EBC  0000             add byte ptr [bx + si], al
  017EBE  0000             add byte ptr [bx + si], al
  017EC0  0000             add byte ptr [bx + si], al
  017EC2  0000             add byte ptr [bx + si], al
  017EC4  0000             add byte ptr [bx + si], al
  017EC6  0000             add byte ptr [bx + si], al
  017EC8  0000             add byte ptr [bx + si], al
  017ECA  0000             add byte ptr [bx + si], al
  017ECC  0000             add byte ptr [bx + si], al
  017ECE  0000             add byte ptr [bx + si], al
  017ED0  0000             add byte ptr [bx + si], al
  017ED2  0000             add byte ptr [bx + si], al
  017ED4  0000             add byte ptr [bx + si], al
  017ED6  0000             add byte ptr [bx + si], al
  017ED8  0000             add byte ptr [bx + si], al
  017EDA  0000             add byte ptr [bx + si], al
  017EDC  0000             add byte ptr [bx + si], al
  017EDE  0000             add byte ptr [bx + si], al
  017EE0  0000             add byte ptr [bx + si], al
  017EE2  0000             add byte ptr [bx + si], al
  017EE4  0000             add byte ptr [bx + si], al
  017EE6  0000             add byte ptr [bx + si], al
  017EE8  0000             add byte ptr [bx + si], al
  017EEA  0000             add byte ptr [bx + si], al
  017EEC  0000             add byte ptr [bx + si], al
  017EEE  0000             add byte ptr [bx + si], al
  017EF0  0000             add byte ptr [bx + si], al
  017EF2  0000             add byte ptr [bx + si], al
  017EF4  0000             add byte ptr [bx + si], al
  017EF6  0000             add byte ptr [bx + si], al
  017EF8  0000             add byte ptr [bx + si], al
  017EFA  0000             add byte ptr [bx + si], al
  017EFC  0000             add byte ptr [bx + si], al
  017EFE  0000             add byte ptr [bx + si], al
  017F00  0000             add byte ptr [bx + si], al
  017F02  0000             add byte ptr [bx + si], al
  017F04  0000             add byte ptr [bx + si], al
  017F06  0000             add byte ptr [bx + si], al
  017F08  0000             add byte ptr [bx + si], al
  017F0A  0000             add byte ptr [bx + si], al
  017F0C  0000             add byte ptr [bx + si], al
  017F0E  0000             add byte ptr [bx + si], al
  017F10  0000             add byte ptr [bx + si], al
  017F12  0000             add byte ptr [bx + si], al
  017F14  0000             add byte ptr [bx + si], al
  017F16  0000             add byte ptr [bx + si], al
  017F18  0000             add byte ptr [bx + si], al
  017F1A  0000             add byte ptr [bx + si], al
  017F1C  0000             add byte ptr [bx + si], al
  017F1E  0000             add byte ptr [bx + si], al
  017F20  0000             add byte ptr [bx + si], al
  017F22  0000             add byte ptr [bx + si], al
  017F24  0000             add byte ptr [bx + si], al
  017F26  0000             add byte ptr [bx + si], al
  017F28  0000             add byte ptr [bx + si], al
  017F2A  0000             add byte ptr [bx + si], al
  017F2C  0000             add byte ptr [bx + si], al
  017F2E  0000             add byte ptr [bx + si], al
  017F30  0000             add byte ptr [bx + si], al
  017F32  0000             add byte ptr [bx + si], al
  017F34  0000             add byte ptr [bx + si], al
  017F36  0000             add byte ptr [bx + si], al
  017F38  0000             add byte ptr [bx + si], al
  017F3A  0000             add byte ptr [bx + si], al
  017F3C  0000             add byte ptr [bx + si], al
  017F3E  0000             add byte ptr [bx + si], al
  017F40  0000             add byte ptr [bx + si], al
  017F42  0000             add byte ptr [bx + si], al
  017F44  0000             add byte ptr [bx + si], al
  017F46  0000             add byte ptr [bx + si], al
  017F48  0000             add byte ptr [bx + si], al
  017F4A  0000             add byte ptr [bx + si], al
  017F4C  0000             add byte ptr [bx + si], al
  017F4E  0000             add byte ptr [bx + si], al
  017F50  0000             add byte ptr [bx + si], al
  017F52  0000             add byte ptr [bx + si], al
  017F54  0000             add byte ptr [bx + si], al
  017F56  0000             add byte ptr [bx + si], al
  017F58  0000             add byte ptr [bx + si], al
  017F5A  0000             add byte ptr [bx + si], al
  017F5C  0000             add byte ptr [bx + si], al
  017F5E  0000             add byte ptr [bx + si], al
  017F60  0000             add byte ptr [bx + si], al
  017F62  0000             add byte ptr [bx + si], al
  017F64  0000             add byte ptr [bx + si], al
  017F66  0000             add byte ptr [bx + si], al
  017F68  0000             add byte ptr [bx + si], al
  017F6A  0000             add byte ptr [bx + si], al
  017F6C  0000             add byte ptr [bx + si], al
  017F6E  0000             add byte ptr [bx + si], al
  017F70  0000             add byte ptr [bx + si], al
  017F72  0000             add byte ptr [bx + si], al
  017F74  0000             add byte ptr [bx + si], al
  017F76  0000             add byte ptr [bx + si], al
  017F78  0000             add byte ptr [bx + si], al
  017F7A  0000             add byte ptr [bx + si], al
  017F7C  0000             add byte ptr [bx + si], al
  017F7E  0000             add byte ptr [bx + si], al
  017F80  0000             add byte ptr [bx + si], al
  017F82  0000             add byte ptr [bx + si], al
  017F84  0000             add byte ptr [bx + si], al
  017F86  0000             add byte ptr [bx + si], al
  017F88  0000             add byte ptr [bx + si], al
  017F8A  0000             add byte ptr [bx + si], al
  017F8C  0000             add byte ptr [bx + si], al
  017F8E  0000             add byte ptr [bx + si], al
  017F90  0000             add byte ptr [bx + si], al
  017F92  0000             add byte ptr [bx + si], al
  017F94  0000             add byte ptr [bx + si], al
  017F96  0000             add byte ptr [bx + si], al
  017F98  0000             add byte ptr [bx + si], al
  017F9A  0000             add byte ptr [bx + si], al
  017F9C  0000             add byte ptr [bx + si], al
  017F9E  0000             add byte ptr [bx + si], al
  017FA0  0000             add byte ptr [bx + si], al
  017FA2  0000             add byte ptr [bx + si], al
  017FA4  0000             add byte ptr [bx + si], al
  017FA6  0000             add byte ptr [bx + si], al
  017FA8  0000             add byte ptr [bx + si], al
  017FAA  0000             add byte ptr [bx + si], al
  017FAC  0000             add byte ptr [bx + si], al
  017FAE  0000             add byte ptr [bx + si], al
  017FB0  0000             add byte ptr [bx + si], al
  017FB2  0000             add byte ptr [bx + si], al
  017FB4  0000             add byte ptr [bx + si], al
  017FB6  0000             add byte ptr [bx + si], al
  017FB8  0000             add byte ptr [bx + si], al
  017FBA  0000             add byte ptr [bx + si], al
  017FBC  0000             add byte ptr [bx + si], al
  017FBE  0000             add byte ptr [bx + si], al
  017FC0  0000             add byte ptr [bx + si], al
  017FC2  0000             add byte ptr [bx + si], al
  017FC4  0000             add byte ptr [bx + si], al
  017FC6  0000             add byte ptr [bx + si], al
  017FC8  0000             add byte ptr [bx + si], al
  017FCA  0000             add byte ptr [bx + si], al
  017FCC  0000             add byte ptr [bx + si], al
  017FCE  0000             add byte ptr [bx + si], al
  017FD0  0000             add byte ptr [bx + si], al
  017FD2  0000             add byte ptr [bx + si], al
  017FD4  0000             add byte ptr [bx + si], al
  017FD6  0000             add byte ptr [bx + si], al
  017FD8  0000             add byte ptr [bx + si], al
  017FDA  0000             add byte ptr [bx + si], al
  017FDC  0000             add byte ptr [bx + si], al
  017FDE  0000             add byte ptr [bx + si], al
  017FE0  0000             add byte ptr [bx + si], al
  017FE2  0000             add byte ptr [bx + si], al
  017FE4  0000             add byte ptr [bx + si], al
  017FE6  0000             add byte ptr [bx + si], al
  017FE8  0000             add byte ptr [bx + si], al
  017FEA  0000             add byte ptr [bx + si], al
  017FEC  0000             add byte ptr [bx + si], al
  017FEE  0000             add byte ptr [bx + si], al
  017FF0  0000             add byte ptr [bx + si], al
  017FF2  0000             add byte ptr [bx + si], al
  017FF4  0000             add byte ptr [bx + si], al
  017FF6  0000             add byte ptr [bx + si], al
  017FF8  0000             add byte ptr [bx + si], al
  017FFA  0000             add byte ptr [bx + si], al
  017FFC  0000             add byte ptr [bx + si], al
  017FFE  0000             add byte ptr [bx + si], al
  018000  0000             add byte ptr [bx + si], al
  018002  0000             add byte ptr [bx + si], al
  018004  0000             add byte ptr [bx + si], al
  018006  0000             add byte ptr [bx + si], al
  018008  0000             add byte ptr [bx + si], al
  01800A  0000             add byte ptr [bx + si], al
  01800C  0000             add byte ptr [bx + si], al
  01800E  0000             add byte ptr [bx + si], al
  018010  0000             add byte ptr [bx + si], al
  018012  0000             add byte ptr [bx + si], al
  018014  0000             add byte ptr [bx + si], al
  018016  0000             add byte ptr [bx + si], al
  018018  0000             add byte ptr [bx + si], al
  01801A  0000             add byte ptr [bx + si], al
  01801C  0000             add byte ptr [bx + si], al
  01801E  0000             add byte ptr [bx + si], al
  018020  0000             add byte ptr [bx + si], al
  018022  0000             add byte ptr [bx + si], al
  018024  0000             add byte ptr [bx + si], al
  018026  0000             add byte ptr [bx + si], al
  018028  0000             add byte ptr [bx + si], al
  01802A  0000             add byte ptr [bx + si], al
  01802C  0000             add byte ptr [bx + si], al
  01802E  0000             add byte ptr [bx + si], al
  018030  0000             add byte ptr [bx + si], al
  018032  0000             add byte ptr [bx + si], al
  018034  0000             add byte ptr [bx + si], al
  018036  0000             add byte ptr [bx + si], al
  018038  0000             add byte ptr [bx + si], al
  01803A  0000             add byte ptr [bx + si], al
  01803C  0000             add byte ptr [bx + si], al
  01803E  0000             add byte ptr [bx + si], al
  018040  0000             add byte ptr [bx + si], al
  018042  0000             add byte ptr [bx + si], al
  018044  0000             add byte ptr [bx + si], al
  018046  0000             add byte ptr [bx + si], al
  018048  0000             add byte ptr [bx + si], al
  01804A  0000             add byte ptr [bx + si], al
  01804C  0000             add byte ptr [bx + si], al
  01804E  0000             add byte ptr [bx + si], al
  018050  0000             add byte ptr [bx + si], al
  018052  0000             add byte ptr [bx + si], al
  018054  0000             add byte ptr [bx + si], al
  018056  0000             add byte ptr [bx + si], al
  018058  0000             add byte ptr [bx + si], al
  01805A  0000             add byte ptr [bx + si], al
  01805C  0000             add byte ptr [bx + si], al
  01805E  0000             add byte ptr [bx + si], al
  018060  0000             add byte ptr [bx + si], al
  018062  0000             add byte ptr [bx + si], al
  018064  0000             add byte ptr [bx + si], al
  018066  0000             add byte ptr [bx + si], al
  018068  0000             add byte ptr [bx + si], al
  01806A  0000             add byte ptr [bx + si], al
  01806C  0000             add byte ptr [bx + si], al
  01806E  0000             add byte ptr [bx + si], al
  018070  0000             add byte ptr [bx + si], al
  018072  0000             add byte ptr [bx + si], al
  018074  0000             add byte ptr [bx + si], al
  018076  0000             add byte ptr [bx + si], al
  018078  0000             add byte ptr [bx + si], al
  01807A  0000             add byte ptr [bx + si], al
  01807C  0000             add byte ptr [bx + si], al
  01807E  0000             add byte ptr [bx + si], al
  018080  0000             add byte ptr [bx + si], al
  018082  0000             add byte ptr [bx + si], al
  018084  0000             add byte ptr [bx + si], al
  018086  0000             add byte ptr [bx + si], al
  018088  0000             add byte ptr [bx + si], al
  01808A  0000             add byte ptr [bx + si], al
  01808C  0000             add byte ptr [bx + si], al
  01808E  0000             add byte ptr [bx + si], al
  018090  0000             add byte ptr [bx + si], al
  018092  0000             add byte ptr [bx + si], al
  018094  0000             add byte ptr [bx + si], al
  018096  0000             add byte ptr [bx + si], al
  018098  0000             add byte ptr [bx + si], al
  01809A  0000             add byte ptr [bx + si], al
  01809C  0000             add byte ptr [bx + si], al
  01809E  0000             add byte ptr [bx + si], al
  0180A0  0000             add byte ptr [bx + si], al
  0180A2  0000             add byte ptr [bx + si], al
  0180A4  0000             add byte ptr [bx + si], al
  0180A6  0000             add byte ptr [bx + si], al
  0180A8  0000             add byte ptr [bx + si], al
  0180AA  0000             add byte ptr [bx + si], al
  0180AC  0000             add byte ptr [bx + si], al
  0180AE  0000             add byte ptr [bx + si], al
  0180B0  0000             add byte ptr [bx + si], al
  0180B2  0000             add byte ptr [bx + si], al
  0180B4  0000             add byte ptr [bx + si], al
  0180B6  0000             add byte ptr [bx + si], al
  0180B8  0000             add byte ptr [bx + si], al
  0180BA  0000             add byte ptr [bx + si], al
  0180BC  0000             add byte ptr [bx + si], al
  0180BE  0000             add byte ptr [bx + si], al
  0180C0  0000             add byte ptr [bx + si], al
  0180C2  0000             add byte ptr [bx + si], al
  0180C4  0000             add byte ptr [bx + si], al
  0180C6  0000             add byte ptr [bx + si], al
  0180C8  0000             add byte ptr [bx + si], al
  0180CA  0000             add byte ptr [bx + si], al
  0180CC  0000             add byte ptr [bx + si], al
  0180CE  0000             add byte ptr [bx + si], al
  0180D0  0000             add byte ptr [bx + si], al
  0180D2  0000             add byte ptr [bx + si], al
  0180D4  0000             add byte ptr [bx + si], al
  0180D6  0000             add byte ptr [bx + si], al
  0180D8  0000             add byte ptr [bx + si], al
  0180DA  0000             add byte ptr [bx + si], al
  0180DC  0000             add byte ptr [bx + si], al
  0180DE  0000             add byte ptr [bx + si], al
  0180E0  0000             add byte ptr [bx + si], al
  0180E2  0000             add byte ptr [bx + si], al
  0180E4  0000             add byte ptr [bx + si], al
  0180E6  0000             add byte ptr [bx + si], al
  0180E8  0000             add byte ptr [bx + si], al
  0180EA  0000             add byte ptr [bx + si], al
  0180EC  0000             add byte ptr [bx + si], al
  0180EE  0000             add byte ptr [bx + si], al
  0180F0  0000             add byte ptr [bx + si], al
  0180F2  0000             add byte ptr [bx + si], al
  0180F4  0000             add byte ptr [bx + si], al
  0180F6  0000             add byte ptr [bx + si], al
  0180F8  0000             add byte ptr [bx + si], al
  0180FA  0000             add byte ptr [bx + si], al
  0180FC  0000             add byte ptr [bx + si], al
  0180FE  0000             add byte ptr [bx + si], al
  018100  0000             add byte ptr [bx + si], al
  018102  0000             add byte ptr [bx + si], al
  018104  0000             add byte ptr [bx + si], al
  018106  0000             add byte ptr [bx + si], al
  018108  0000             add byte ptr [bx + si], al
  01810A  0000             add byte ptr [bx + si], al
  01810C  0000             add byte ptr [bx + si], al
  01810E  0000             add byte ptr [bx + si], al
  018110  0000             add byte ptr [bx + si], al
  018112  0000             add byte ptr [bx + si], al
  018114  0000             add byte ptr [bx + si], al
  018116  0000             add byte ptr [bx + si], al
  018118  0000             add byte ptr [bx + si], al
  01811A  0000             add byte ptr [bx + si], al
  01811C  0000             add byte ptr [bx + si], al
  01811E  0000             add byte ptr [bx + si], al
  018120  0000             add byte ptr [bx + si], al
  018122  0000             add byte ptr [bx + si], al
  018124  0000             add byte ptr [bx + si], al
  018126  0000             add byte ptr [bx + si], al
  018128  0000             add byte ptr [bx + si], al
  01812A  0000             add byte ptr [bx + si], al
  01812C  0000             add byte ptr [bx + si], al
  01812E  0000             add byte ptr [bx + si], al
  018130  0000             add byte ptr [bx + si], al
  018132  0000             add byte ptr [bx + si], al
  018134  0000             add byte ptr [bx + si], al
  018136  0000             add byte ptr [bx + si], al
  018138  0000             add byte ptr [bx + si], al
  01813A  0000             add byte ptr [bx + si], al
  01813C  0000             add byte ptr [bx + si], al
  01813E  0000             add byte ptr [bx + si], al
  018140  0000             add byte ptr [bx + si], al
  018142  0000             add byte ptr [bx + si], al
  018144  0000             add byte ptr [bx + si], al
  018146  0000             add byte ptr [bx + si], al
  018148  0000             add byte ptr [bx + si], al
  01814A  0000             add byte ptr [bx + si], al
  01814C  0000             add byte ptr [bx + si], al
  01814E  0000             add byte ptr [bx + si], al
  018150  0000             add byte ptr [bx + si], al
  018152  0000             add byte ptr [bx + si], al
  018154  0000             add byte ptr [bx + si], al
  018156  0000             add byte ptr [bx + si], al
  018158  0000             add byte ptr [bx + si], al
  01815A  0000             add byte ptr [bx + si], al
  01815C  0000             add byte ptr [bx + si], al
  01815E  0000             add byte ptr [bx + si], al
  018160  0000             add byte ptr [bx + si], al
  018162  0000             add byte ptr [bx + si], al
  018164  0000             add byte ptr [bx + si], al
  018166  0000             add byte ptr [bx + si], al
  018168  0000             add byte ptr [bx + si], al
  01816A  0000             add byte ptr [bx + si], al
  01816C  0000             add byte ptr [bx + si], al
  01816E  0000             add byte ptr [bx + si], al
  018170  0000             add byte ptr [bx + si], al
  018172  0000             add byte ptr [bx + si], al
  018174  0000             add byte ptr [bx + si], al
  018176  0000             add byte ptr [bx + si], al
  018178  0000             add byte ptr [bx + si], al
  01817A  0000             add byte ptr [bx + si], al
  01817C  0000             add byte ptr [bx + si], al
  01817E  0000             add byte ptr [bx + si], al
  018180  0000             add byte ptr [bx + si], al
  018182  0000             add byte ptr [bx + si], al
  018184  0000             add byte ptr [bx + si], al
  018186  0000             add byte ptr [bx + si], al
  018188  0000             add byte ptr [bx + si], al
  01818A  0000             add byte ptr [bx + si], al
  01818C  0000             add byte ptr [bx + si], al
  01818E  0000             add byte ptr [bx + si], al
  018190  0000             add byte ptr [bx + si], al
  018192  0000             add byte ptr [bx + si], al
  018194  0000             add byte ptr [bx + si], al
  018196  0000             add byte ptr [bx + si], al
  018198  0000             add byte ptr [bx + si], al
  01819A  0000             add byte ptr [bx + si], al
  01819C  0000             add byte ptr [bx + si], al
  01819E  0000             add byte ptr [bx + si], al
  0181A0  0000             add byte ptr [bx + si], al
  0181A2  0000             add byte ptr [bx + si], al
  0181A4  0000             add byte ptr [bx + si], al
  0181A6  0000             add byte ptr [bx + si], al
  0181A8  0000             add byte ptr [bx + si], al
  0181AA  0000             add byte ptr [bx + si], al
  0181AC  0000             add byte ptr [bx + si], al
  0181AE  0000             add byte ptr [bx + si], al
  0181B0  0000             add byte ptr [bx + si], al
  0181B2  0000             add byte ptr [bx + si], al
  0181B4  0000             add byte ptr [bx + si], al
  0181B6  0000             add byte ptr [bx + si], al
  0181B8  0000             add byte ptr [bx + si], al
  0181BA  0000             add byte ptr [bx + si], al
  0181BC  0000             add byte ptr [bx + si], al
  0181BE  0000             add byte ptr [bx + si], al
  0181C0  0000             add byte ptr [bx + si], al
  0181C2  0000             add byte ptr [bx + si], al
  0181C4  0000             add byte ptr [bx + si], al
  0181C6  0000             add byte ptr [bx + si], al
  0181C8  0000             add byte ptr [bx + si], al
  0181CA  0000             add byte ptr [bx + si], al
  0181CC  0000             add byte ptr [bx + si], al
  0181CE  0000             add byte ptr [bx + si], al
  0181D0  0000             add byte ptr [bx + si], al
  0181D2  0000             add byte ptr [bx + si], al
  0181D4  0000             add byte ptr [bx + si], al
  0181D6  0000             add byte ptr [bx + si], al
  0181D8  0000             add byte ptr [bx + si], al
  0181DA  0000             add byte ptr [bx + si], al
  0181DC  0000             add byte ptr [bx + si], al
  0181DE  0000             add byte ptr [bx + si], al
  0181E0  0000             add byte ptr [bx + si], al
  0181E2  0000             add byte ptr [bx + si], al
  0181E4  0000             add byte ptr [bx + si], al
  0181E6  0000             add byte ptr [bx + si], al
  0181E8  0000             add byte ptr [bx + si], al
  0181EA  0000             add byte ptr [bx + si], al
  0181EC  0000             add byte ptr [bx + si], al
  0181EE  0000             add byte ptr [bx + si], al
  0181F0  0000             add byte ptr [bx + si], al
  0181F2  0000             add byte ptr [bx + si], al
  0181F4  0000             add byte ptr [bx + si], al
  0181F6  0000             add byte ptr [bx + si], al
  0181F8  0000             add byte ptr [bx + si], al
  0181FA  0000             add byte ptr [bx + si], al
  0181FC  0000             add byte ptr [bx + si], al
  0181FE  0000             add byte ptr [bx + si], al
  018200  0000             add byte ptr [bx + si], al
  018202  0000             add byte ptr [bx + si], al
  018204  0000             add byte ptr [bx + si], al
  018206  0000             add byte ptr [bx + si], al
  018208  0000             add byte ptr [bx + si], al
  01820A  0000             add byte ptr [bx + si], al
  01820C  0000             add byte ptr [bx + si], al
  01820E  0000             add byte ptr [bx + si], al
  018210  0000             add byte ptr [bx + si], al
  018212  0000             add byte ptr [bx + si], al
  018214  0000             add byte ptr [bx + si], al
  018216  0000             add byte ptr [bx + si], al
  018218  0000             add byte ptr [bx + si], al
  01821A  0000             add byte ptr [bx + si], al
  01821C  0000             add byte ptr [bx + si], al
  01821E  0000             add byte ptr [bx + si], al
  018220  0000             add byte ptr [bx + si], al
  018222  0000             add byte ptr [bx + si], al
  018224  0000             add byte ptr [bx + si], al
  018226  0000             add byte ptr [bx + si], al
  018228  0000             add byte ptr [bx + si], al
  01822A  0000             add byte ptr [bx + si], al
  01822C  0000             add byte ptr [bx + si], al
  01822E  0000             add byte ptr [bx + si], al
  018230  0000             add byte ptr [bx + si], al
  018232  0000             add byte ptr [bx + si], al
  018234  0000             add byte ptr [bx + si], al
  018236  0000             add byte ptr [bx + si], al
  018238  0000             add byte ptr [bx + si], al
  01823A  0000             add byte ptr [bx + si], al
  01823C  0000             add byte ptr [bx + si], al
  01823E  0000             add byte ptr [bx + si], al
  018240  0000             add byte ptr [bx + si], al
  018242  0000             add byte ptr [bx + si], al
  018244  0000             add byte ptr [bx + si], al
  018246  0000             add byte ptr [bx + si], al
  018248  0000             add byte ptr [bx + si], al
  01824A  0000             add byte ptr [bx + si], al
  01824C  0000             add byte ptr [bx + si], al
  01824E  0000             add byte ptr [bx + si], al
  018250  0000             add byte ptr [bx + si], al
  018252  0000             add byte ptr [bx + si], al
  018254  0000             add byte ptr [bx + si], al
  018256  0000             add byte ptr [bx + si], al
  018258  0000             add byte ptr [bx + si], al
  01825A  0000             add byte ptr [bx + si], al
  01825C  0000             add byte ptr [bx + si], al
  01825E  0000             add byte ptr [bx + si], al
  018260  0000             add byte ptr [bx + si], al
  018262  0000             add byte ptr [bx + si], al
  018264  0000             add byte ptr [bx + si], al
  018266  0000             add byte ptr [bx + si], al
  018268  0000             add byte ptr [bx + si], al
  01826A  0000             add byte ptr [bx + si], al
  01826C  0000             add byte ptr [bx + si], al
  01826E  0000             add byte ptr [bx + si], al
  018270  0000             add byte ptr [bx + si], al
  018272  0000             add byte ptr [bx + si], al
  018274  0000             add byte ptr [bx + si], al
  018276  0000             add byte ptr [bx + si], al
  018278  0000             add byte ptr [bx + si], al
  01827A  0000             add byte ptr [bx + si], al
  01827C  0000             add byte ptr [bx + si], al
  01827E  0000             add byte ptr [bx + si], al
  018280  0000             add byte ptr [bx + si], al
  018282  0000             add byte ptr [bx + si], al
  018284  0000             add byte ptr [bx + si], al
  018286  0000             add byte ptr [bx + si], al
  018288  0000             add byte ptr [bx + si], al
  01828A  0000             add byte ptr [bx + si], al
  01828C  0000             add byte ptr [bx + si], al
  01828E  0000             add byte ptr [bx + si], al
  018290  0000             add byte ptr [bx + si], al
  018292  0000             add byte ptr [bx + si], al
  018294  0000             add byte ptr [bx + si], al
  018296  0000             add byte ptr [bx + si], al
  018298  0000             add byte ptr [bx + si], al
  01829A  0000             add byte ptr [bx + si], al
  01829C  0000             add byte ptr [bx + si], al
  01829E  0000             add byte ptr [bx + si], al
  0182A0  0000             add byte ptr [bx + si], al
  0182A2  0000             add byte ptr [bx + si], al
  0182A4  0000             add byte ptr [bx + si], al
  0182A6  0000             add byte ptr [bx + si], al
  0182A8  0000             add byte ptr [bx + si], al
  0182AA  0000             add byte ptr [bx + si], al
  0182AC  0000             add byte ptr [bx + si], al
  0182AE  0000             add byte ptr [bx + si], al
  0182B0  0000             add byte ptr [bx + si], al
  0182B2  0000             add byte ptr [bx + si], al
  0182B4  0000             add byte ptr [bx + si], al
  0182B6  0000             add byte ptr [bx + si], al
  0182B8  0000             add byte ptr [bx + si], al
  0182BA  0000             add byte ptr [bx + si], al
  0182BC  0000             add byte ptr [bx + si], al
  0182BE  0000             add byte ptr [bx + si], al
  0182C0  0000             add byte ptr [bx + si], al
  0182C2  0000             add byte ptr [bx + si], al
  0182C4  0000             add byte ptr [bx + si], al
  0182C6  0000             add byte ptr [bx + si], al
  0182C8  0000             add byte ptr [bx + si], al
  0182CA  0000             add byte ptr [bx + si], al
  0182CC  0000             add byte ptr [bx + si], al
  0182CE  0000             add byte ptr [bx + si], al
  0182D0  0000             add byte ptr [bx + si], al
  0182D2  0000             add byte ptr [bx + si], al
  0182D4  0000             add byte ptr [bx + si], al
  0182D6  0000             add byte ptr [bx + si], al
  0182D8  0000             add byte ptr [bx + si], al
  0182DA  0000             add byte ptr [bx + si], al
  0182DC  0000             add byte ptr [bx + si], al
  0182DE  0000             add byte ptr [bx + si], al
  0182E0  0000             add byte ptr [bx + si], al
  0182E2  0000             add byte ptr [bx + si], al
  0182E4  0000             add byte ptr [bx + si], al
  0182E6  0000             add byte ptr [bx + si], al
  0182E8  0000             add byte ptr [bx + si], al
  0182EA  0000             add byte ptr [bx + si], al
  0182EC  0000             add byte ptr [bx + si], al
  0182EE  0000             add byte ptr [bx + si], al
  0182F0  0000             add byte ptr [bx + si], al
  0182F2  0000             add byte ptr [bx + si], al
  0182F4  0000             add byte ptr [bx + si], al
  0182F6  0000             add byte ptr [bx + si], al
  0182F8  0000             add byte ptr [bx + si], al
  0182FA  0000             add byte ptr [bx + si], al
  0182FC  0000             add byte ptr [bx + si], al
  0182FE  0000             add byte ptr [bx + si], al
  018300  0000             add byte ptr [bx + si], al
  018302  0000             add byte ptr [bx + si], al
  018304  0000             add byte ptr [bx + si], al
  018306  0000             add byte ptr [bx + si], al
  018308  0000             add byte ptr [bx + si], al
  01830A  0000             add byte ptr [bx + si], al
  01830C  0000             add byte ptr [bx + si], al
  01830E  0000             add byte ptr [bx + si], al
  018310  0000             add byte ptr [bx + si], al
  018312  0000             add byte ptr [bx + si], al
  018314  0000             add byte ptr [bx + si], al
  018316  0000             add byte ptr [bx + si], al
  018318  0000             add byte ptr [bx + si], al
  01831A  0000             add byte ptr [bx + si], al
  01831C  0000             add byte ptr [bx + si], al
  01831E  0000             add byte ptr [bx + si], al
  018320  0000             add byte ptr [bx + si], al
  018322  0000             add byte ptr [bx + si], al
  018324  0000             add byte ptr [bx + si], al
  018326  0000             add byte ptr [bx + si], al
  018328  0000             add byte ptr [bx + si], al
  01832A  0000             add byte ptr [bx + si], al
  01832C  0000             add byte ptr [bx + si], al
  01832E  0000             add byte ptr [bx + si], al
  018330  0000             add byte ptr [bx + si], al
  018332  0000             add byte ptr [bx + si], al
  018334  0000             add byte ptr [bx + si], al
  018336  0000             add byte ptr [bx + si], al
  018338  0000             add byte ptr [bx + si], al
  01833A  0000             add byte ptr [bx + si], al
  01833C  0000             add byte ptr [bx + si], al
  01833E  0000             add byte ptr [bx + si], al
  018340  0000             add byte ptr [bx + si], al
  018342  0000             add byte ptr [bx + si], al
  018344  0000             add byte ptr [bx + si], al
  018346  0000             add byte ptr [bx + si], al
  018348  0000             add byte ptr [bx + si], al
  01834A  0000             add byte ptr [bx + si], al
  01834C  0000             add byte ptr [bx + si], al
  01834E  0000             add byte ptr [bx + si], al
  018350  0000             add byte ptr [bx + si], al
  018352  0000             add byte ptr [bx + si], al
  018354  0000             add byte ptr [bx + si], al
  018356  0000             add byte ptr [bx + si], al
  018358  0000             add byte ptr [bx + si], al
  01835A  0000             add byte ptr [bx + si], al
  01835C  0000             add byte ptr [bx + si], al
  01835E  0000             add byte ptr [bx + si], al
  018360  0000             add byte ptr [bx + si], al
  018362  0000             add byte ptr [bx + si], al
  018364  0000             add byte ptr [bx + si], al
  018366  0000             add byte ptr [bx + si], al
  018368  0000             add byte ptr [bx + si], al
  01836A  0000             add byte ptr [bx + si], al
  01836C  0000             add byte ptr [bx + si], al
  01836E  0000             add byte ptr [bx + si], al
  018370  0000             add byte ptr [bx + si], al
  018372  0000             add byte ptr [bx + si], al
  018374  0000             add byte ptr [bx + si], al
  018376  0000             add byte ptr [bx + si], al
  018378  0000             add byte ptr [bx + si], al
  01837A  0000             add byte ptr [bx + si], al
  01837C  0000             add byte ptr [bx + si], al
  01837E  0000             add byte ptr [bx + si], al
  018380  0000             add byte ptr [bx + si], al
  018382  0000             add byte ptr [bx + si], al
  018384  0000             add byte ptr [bx + si], al
  018386  0000             add byte ptr [bx + si], al
  018388  0000             add byte ptr [bx + si], al
  01838A  0000             add byte ptr [bx + si], al
  01838C  0000             add byte ptr [bx + si], al
  01838E  0000             add byte ptr [bx + si], al
  018390  0000             add byte ptr [bx + si], al
  018392  0000             add byte ptr [bx + si], al
  018394  0000             add byte ptr [bx + si], al
  018396  0000             add byte ptr [bx + si], al
  018398  0000             add byte ptr [bx + si], al
  01839A  0000             add byte ptr [bx + si], al
  01839C  0000             add byte ptr [bx + si], al
  01839E  0000             add byte ptr [bx + si], al
  0183A0  0000             add byte ptr [bx + si], al
  0183A2  0000             add byte ptr [bx + si], al
  0183A4  0000             add byte ptr [bx + si], al
  0183A6  0000             add byte ptr [bx + si], al
  0183A8  0000             add byte ptr [bx + si], al
  0183AA  0000             add byte ptr [bx + si], al
  0183AC  0000             add byte ptr [bx + si], al
  0183AE  0000             add byte ptr [bx + si], al
  0183B0  0000             add byte ptr [bx + si], al
  0183B2  0000             add byte ptr [bx + si], al
  0183B4  0000             add byte ptr [bx + si], al
  0183B6  0000             add byte ptr [bx + si], al
  0183B8  0000             add byte ptr [bx + si], al
  0183BA  0000             add byte ptr [bx + si], al
  0183BC  0000             add byte ptr [bx + si], al
  0183BE  0000             add byte ptr [bx + si], al
  0183C0  0000             add byte ptr [bx + si], al
  0183C2  0000             add byte ptr [bx + si], al
  0183C4  0000             add byte ptr [bx + si], al
  0183C6  0000             add byte ptr [bx + si], al
  0183C8  0000             add byte ptr [bx + si], al
  0183CA  0000             add byte ptr [bx + si], al
  0183CC  0000             add byte ptr [bx + si], al
  0183CE  0000             add byte ptr [bx + si], al
  0183D0  0000             add byte ptr [bx + si], al
  0183D2  0000             add byte ptr [bx + si], al
  0183D4  0000             add byte ptr [bx + si], al
  0183D6  0000             add byte ptr [bx + si], al
  0183D8  0000             add byte ptr [bx + si], al
  0183DA  0000             add byte ptr [bx + si], al
  0183DC  0000             add byte ptr [bx + si], al
  0183DE  0000             add byte ptr [bx + si], al
  0183E0  0000             add byte ptr [bx + si], al
  0183E2  0000             add byte ptr [bx + si], al
  0183E4  0000             add byte ptr [bx + si], al
  0183E6  0000             add byte ptr [bx + si], al
  0183E8  0000             add byte ptr [bx + si], al
  0183EA  0000             add byte ptr [bx + si], al
  0183EC  0000             add byte ptr [bx + si], al
  0183EE  0000             add byte ptr [bx + si], al
  0183F0  0000             add byte ptr [bx + si], al
  0183F2  0000             add byte ptr [bx + si], al
  0183F4  0000             add byte ptr [bx + si], al
  0183F6  0000             add byte ptr [bx + si], al
  0183F8  0000             add byte ptr [bx + si], al
  0183FA  0000             add byte ptr [bx + si], al
  0183FC  0000             add byte ptr [bx + si], al
  0183FE  0000             add byte ptr [bx + si], al
  018400  0000             add byte ptr [bx + si], al
  018402  0000             add byte ptr [bx + si], al
  018404  0000             add byte ptr [bx + si], al
  018406  0000             add byte ptr [bx + si], al
  018408  0000             add byte ptr [bx + si], al
  01840A  0000             add byte ptr [bx + si], al
  01840C  0000             add byte ptr [bx + si], al
  01840E  0000             add byte ptr [bx + si], al
  018410  0000             add byte ptr [bx + si], al
  018412  0000             add byte ptr [bx + si], al
  018414  0000             add byte ptr [bx + si], al
  018416  0000             add byte ptr [bx + si], al
  018418  0000             add byte ptr [bx + si], al
  01841A  0000             add byte ptr [bx + si], al
  01841C  0000             add byte ptr [bx + si], al
  01841E  0000             add byte ptr [bx + si], al
  018420  0000             add byte ptr [bx + si], al
  018422  0000             add byte ptr [bx + si], al
  018424  0000             add byte ptr [bx + si], al
  018426  0000             add byte ptr [bx + si], al
  018428  0000             add byte ptr [bx + si], al
  01842A  0000             add byte ptr [bx + si], al
  01842C  0000             add byte ptr [bx + si], al
  01842E  0000             add byte ptr [bx + si], al
  018430  0000             add byte ptr [bx + si], al
  018432  0000             add byte ptr [bx + si], al
  018434  0000             add byte ptr [bx + si], al
  018436  0000             add byte ptr [bx + si], al
  018438  0000             add byte ptr [bx + si], al
  01843A  0000             add byte ptr [bx + si], al
  01843C  0000             add byte ptr [bx + si], al
  01843E  0000             add byte ptr [bx + si], al
  018440  0000             add byte ptr [bx + si], al
  018442  0000             add byte ptr [bx + si], al
  018444  0000             add byte ptr [bx + si], al
  018446  0000             add byte ptr [bx + si], al
  018448  0000             add byte ptr [bx + si], al
  01844A  0000             add byte ptr [bx + si], al
  01844C  0000             add byte ptr [bx + si], al
  01844E  0000             add byte ptr [bx + si], al
  018450  0000             add byte ptr [bx + si], al
  018452  0000             add byte ptr [bx + si], al
  018454  0000             add byte ptr [bx + si], al
  018456  0000             add byte ptr [bx + si], al
  018458  0000             add byte ptr [bx + si], al
  01845A  0000             add byte ptr [bx + si], al
  01845C  0000             add byte ptr [bx + si], al
  01845E  0000             add byte ptr [bx + si], al
  018460  0000             add byte ptr [bx + si], al
  018462  0000             add byte ptr [bx + si], al
  018464  0000             add byte ptr [bx + si], al
  018466  0000             add byte ptr [bx + si], al
  018468  0000             add byte ptr [bx + si], al
  01846A  0000             add byte ptr [bx + si], al
  01846C  0000             add byte ptr [bx + si], al
  01846E  0000             add byte ptr [bx + si], al
  018470  0000             add byte ptr [bx + si], al
  018472  0000             add byte ptr [bx + si], al
  018474  0000             add byte ptr [bx + si], al
  018476  0000             add byte ptr [bx + si], al
  018478  0000             add byte ptr [bx + si], al
  01847A  0000             add byte ptr [bx + si], al
  01847C  0000             add byte ptr [bx + si], al
  01847E  0000             add byte ptr [bx + si], al
  018480  0000             add byte ptr [bx + si], al
  018482  0000             add byte ptr [bx + si], al
  018484  0000             add byte ptr [bx + si], al
  018486  0000             add byte ptr [bx + si], al
  018488  0000             add byte ptr [bx + si], al
  01848A  0000             add byte ptr [bx + si], al
  01848C  0000             add byte ptr [bx + si], al
  01848E  0000             add byte ptr [bx + si], al
  018490  0000             add byte ptr [bx + si], al
  018492  0000             add byte ptr [bx + si], al
  018494  0000             add byte ptr [bx + si], al
  018496  0000             add byte ptr [bx + si], al
  018498  0000             add byte ptr [bx + si], al
  01849A  0000             add byte ptr [bx + si], al
  01849C  0000             add byte ptr [bx + si], al
  01849E  0000             add byte ptr [bx + si], al
  0184A0  0000             add byte ptr [bx + si], al
  0184A2  0000             add byte ptr [bx + si], al
  0184A4  0000             add byte ptr [bx + si], al
  0184A6  0000             add byte ptr [bx + si], al
  0184A8  0000             add byte ptr [bx + si], al
  0184AA  0000             add byte ptr [bx + si], al
  0184AC  0000             add byte ptr [bx + si], al
  0184AE  0000             add byte ptr [bx + si], al
  0184B0  0000             add byte ptr [bx + si], al
  0184B2  0000             add byte ptr [bx + si], al
  0184B4  0000             add byte ptr [bx + si], al
  0184B6  0000             add byte ptr [bx + si], al
  0184B8  0000             add byte ptr [bx + si], al
  0184BA  0000             add byte ptr [bx + si], al
  0184BC  0000             add byte ptr [bx + si], al
  0184BE  0000             add byte ptr [bx + si], al
  0184C0  0000             add byte ptr [bx + si], al
  0184C2  0000             add byte ptr [bx + si], al
  0184C4  0000             add byte ptr [bx + si], al
  0184C6  0000             add byte ptr [bx + si], al
  0184C8  0000             add byte ptr [bx + si], al
  0184CA  0000             add byte ptr [bx + si], al
  0184CC  0000             add byte ptr [bx + si], al
  0184CE  0000             add byte ptr [bx + si], al
  0184D0  0000             add byte ptr [bx + si], al
  0184D2  0000             add byte ptr [bx + si], al
  0184D4  0000             add byte ptr [bx + si], al
  0184D6  0000             add byte ptr [bx + si], al
  0184D8  0000             add byte ptr [bx + si], al
  0184DA  0000             add byte ptr [bx + si], al
  0184DC  0000             add byte ptr [bx + si], al
  0184DE  0000             add byte ptr [bx + si], al
  0184E0  0000             add byte ptr [bx + si], al
  0184E2  0000             add byte ptr [bx + si], al
  0184E4  0000             add byte ptr [bx + si], al
  0184E6  0000             add byte ptr [bx + si], al
  0184E8  0000             add byte ptr [bx + si], al
  0184EA  0000             add byte ptr [bx + si], al
  0184EC  0000             add byte ptr [bx + si], al
  0184EE  0000             add byte ptr [bx + si], al
  0184F0  0000             add byte ptr [bx + si], al
  0184F2  0000             add byte ptr [bx + si], al
  0184F4  0000             add byte ptr [bx + si], al
  0184F6  0000             add byte ptr [bx + si], al
  0184F8  0000             add byte ptr [bx + si], al
  0184FA  0000             add byte ptr [bx + si], al
  0184FC  0000             add byte ptr [bx + si], al
  0184FE  0000             add byte ptr [bx + si], al
  018500  0000             add byte ptr [bx + si], al
  018502  0000             add byte ptr [bx + si], al
  018504  0000             add byte ptr [bx + si], al
  018506  0000             add byte ptr [bx + si], al
  018508  0000             add byte ptr [bx + si], al
  01850A  0000             add byte ptr [bx + si], al
  01850C  0000             add byte ptr [bx + si], al
  01850E  0000             add byte ptr [bx + si], al
  018510  0000             add byte ptr [bx + si], al
  018512  0000             add byte ptr [bx + si], al
  018514  0000             add byte ptr [bx + si], al
  018516  0000             add byte ptr [bx + si], al
  018518  0000             add byte ptr [bx + si], al
  01851A  0000             add byte ptr [bx + si], al
  01851C  0000             add byte ptr [bx + si], al
  01851E  0000             add byte ptr [bx + si], al
  018520  0000             add byte ptr [bx + si], al
  018522  0000             add byte ptr [bx + si], al
  018524  0000             add byte ptr [bx + si], al
  018526  0000             add byte ptr [bx + si], al
  018528  0000             add byte ptr [bx + si], al
  01852A  0000             add byte ptr [bx + si], al
  01852C  0000             add byte ptr [bx + si], al
  01852E  0000             add byte ptr [bx + si], al
  018530  0000             add byte ptr [bx + si], al
  018532  0000             add byte ptr [bx + si], al
  018534  0000             add byte ptr [bx + si], al
  018536  0000             add byte ptr [bx + si], al
  018538  0000             add byte ptr [bx + si], al
  01853A  0000             add byte ptr [bx + si], al
  01853C  0000             add byte ptr [bx + si], al
  01853E  0000             add byte ptr [bx + si], al
  018540  0000             add byte ptr [bx + si], al
  018542  0000             add byte ptr [bx + si], al
  018544  0000             add byte ptr [bx + si], al
  018546  0000             add byte ptr [bx + si], al
  018548  0000             add byte ptr [bx + si], al
  01854A  0000             add byte ptr [bx + si], al
  01854C  0000             add byte ptr [bx + si], al
  01854E  0000             add byte ptr [bx + si], al
  018550  0000             add byte ptr [bx + si], al
  018552  0000             add byte ptr [bx + si], al
  018554  0000             add byte ptr [bx + si], al
  018556  0000             add byte ptr [bx + si], al
  018558  0000             add byte ptr [bx + si], al
  01855A  0000             add byte ptr [bx + si], al
  01855C  0000             add byte ptr [bx + si], al
  01855E  0000             add byte ptr [bx + si], al
  018560  0000             add byte ptr [bx + si], al
  018562  0000             add byte ptr [bx + si], al
  018564  0000             add byte ptr [bx + si], al
  018566  0000             add byte ptr [bx + si], al
  018568  0000             add byte ptr [bx + si], al
  01856A  0000             add byte ptr [bx + si], al
  01856C  0000             add byte ptr [bx + si], al
  01856E  0000             add byte ptr [bx + si], al
  018570  0000             add byte ptr [bx + si], al
  018572  0000             add byte ptr [bx + si], al
  018574  0000             add byte ptr [bx + si], al
  018576  0000             add byte ptr [bx + si], al
  018578  0000             add byte ptr [bx + si], al
  01857A  0000             add byte ptr [bx + si], al
  01857C  0000             add byte ptr [bx + si], al
  01857E  0000             add byte ptr [bx + si], al
  018580  0000             add byte ptr [bx + si], al
  018582  0000             add byte ptr [bx + si], al
  018584  0000             add byte ptr [bx + si], al
  018586  0000             add byte ptr [bx + si], al
  018588  0000             add byte ptr [bx + si], al
  01858A  0000             add byte ptr [bx + si], al
  01858C  0000             add byte ptr [bx + si], al
  01858E  0000             add byte ptr [bx + si], al
  018590  0000             add byte ptr [bx + si], al
  018592  0000             add byte ptr [bx + si], al
  018594  0000             add byte ptr [bx + si], al
  018596  0000             add byte ptr [bx + si], al
  018598  0000             add byte ptr [bx + si], al
  01859A  0000             add byte ptr [bx + si], al
  01859C  0000             add byte ptr [bx + si], al
  01859E  0000             add byte ptr [bx + si], al
  0185A0  0000             add byte ptr [bx + si], al
  0185A2  0000             add byte ptr [bx + si], al
  0185A4  0000             add byte ptr [bx + si], al
  0185A6  0000             add byte ptr [bx + si], al
  0185A8  0000             add byte ptr [bx + si], al
  0185AA  0000             add byte ptr [bx + si], al
  0185AC  0000             add byte ptr [bx + si], al
  0185AE  0000             add byte ptr [bx + si], al
  0185B0  0000             add byte ptr [bx + si], al
  0185B2  0000             add byte ptr [bx + si], al
  0185B4  0000             add byte ptr [bx + si], al
  0185B6  0000             add byte ptr [bx + si], al
  0185B8  0000             add byte ptr [bx + si], al
  0185BA  0000             add byte ptr [bx + si], al
  0185BC  0000             add byte ptr [bx + si], al
  0185BE  0000             add byte ptr [bx + si], al
  0185C0  0000             add byte ptr [bx + si], al
  0185C2  0000             add byte ptr [bx + si], al
  0185C4  0000             add byte ptr [bx + si], al
  0185C6  0000             add byte ptr [bx + si], al
  0185C8  0000             add byte ptr [bx + si], al
  0185CA  0000             add byte ptr [bx + si], al
  0185CC  0000             add byte ptr [bx + si], al
  0185CE  0000             add byte ptr [bx + si], al
  0185D0  0000             add byte ptr [bx + si], al
  0185D2  0000             add byte ptr [bx + si], al
  0185D4  0000             add byte ptr [bx + si], al
  0185D6  0000             add byte ptr [bx + si], al
  0185D8  0000             add byte ptr [bx + si], al
  0185DA  0000             add byte ptr [bx + si], al
  0185DC  0000             add byte ptr [bx + si], al
  0185DE  0000             add byte ptr [bx + si], al
  0185E0  0000             add byte ptr [bx + si], al
  0185E2  0000             add byte ptr [bx + si], al
  0185E4  0000             add byte ptr [bx + si], al
  0185E6  0000             add byte ptr [bx + si], al
  0185E8  0000             add byte ptr [bx + si], al
  0185EA  0000             add byte ptr [bx + si], al
  0185EC  0000             add byte ptr [bx + si], al
  0185EE  0000             add byte ptr [bx + si], al
  0185F0  0000             add byte ptr [bx + si], al
  0185F2  0000             add byte ptr [bx + si], al
  0185F4  0000             add byte ptr [bx + si], al
  0185F6  0000             add byte ptr [bx + si], al
  0185F8  0000             add byte ptr [bx + si], al
  0185FA  0000             add byte ptr [bx + si], al
  0185FC  0000             add byte ptr [bx + si], al
  0185FE  0000             add byte ptr [bx + si], al
  018600  0000             add byte ptr [bx + si], al
  018602  0000             add byte ptr [bx + si], al
  018604  0000             add byte ptr [bx + si], al
  018606  0000             add byte ptr [bx + si], al
  018608  0000             add byte ptr [bx + si], al
  01860A  0000             add byte ptr [bx + si], al
  01860C  0000             add byte ptr [bx + si], al
  01860E  0000             add byte ptr [bx + si], al
  018610  0000             add byte ptr [bx + si], al
  018612  0000             add byte ptr [bx + si], al
  018614  0000             add byte ptr [bx + si], al
  018616  0000             add byte ptr [bx + si], al
  018618  0000             add byte ptr [bx + si], al
  01861A  0000             add byte ptr [bx + si], al
  01861C  0000             add byte ptr [bx + si], al
  01861E  0000             add byte ptr [bx + si], al
  018620  0000             add byte ptr [bx + si], al
  018622  0000             add byte ptr [bx + si], al
  018624  0000             add byte ptr [bx + si], al
  018626  0000             add byte ptr [bx + si], al
  018628  0000             add byte ptr [bx + si], al
  01862A  0000             add byte ptr [bx + si], al
  01862C  0000             add byte ptr [bx + si], al
  01862E  0000             add byte ptr [bx + si], al
  018630  0000             add byte ptr [bx + si], al
  018632  0000             add byte ptr [bx + si], al
  018634  0000             add byte ptr [bx + si], al
  018636  0000             add byte ptr [bx + si], al
  018638  0000             add byte ptr [bx + si], al
  01863A  0000             add byte ptr [bx + si], al
  01863C  0000             add byte ptr [bx + si], al
  01863E  0000             add byte ptr [bx + si], al
  018640  0000             add byte ptr [bx + si], al
  018642  0000             add byte ptr [bx + si], al
  018644  0000             add byte ptr [bx + si], al
  018646  0000             add byte ptr [bx + si], al
  018648  0000             add byte ptr [bx + si], al
  01864A  0000             add byte ptr [bx + si], al
  01864C  0000             add byte ptr [bx + si], al
  01864E  0000             add byte ptr [bx + si], al
  018650  0000             add byte ptr [bx + si], al
  018652  0000             add byte ptr [bx + si], al
  018654  0000             add byte ptr [bx + si], al
  018656  0000             add byte ptr [bx + si], al
  018658  0000             add byte ptr [bx + si], al
  01865A  0000             add byte ptr [bx + si], al
  01865C  0000             add byte ptr [bx + si], al
  01865E  0000             add byte ptr [bx + si], al
  018660  0000             add byte ptr [bx + si], al
  018662  0000             add byte ptr [bx + si], al
  018664  0000             add byte ptr [bx + si], al
  018666  0000             add byte ptr [bx + si], al
  018668  0000             add byte ptr [bx + si], al
  01866A  0000             add byte ptr [bx + si], al
  01866C  0000             add byte ptr [bx + si], al
  01866E  0000             add byte ptr [bx + si], al
  018670  0000             add byte ptr [bx + si], al
  018672  0000             add byte ptr [bx + si], al
  018674  0000             add byte ptr [bx + si], al
  018676  0000             add byte ptr [bx + si], al
  018678  0000             add byte ptr [bx + si], al
  01867A  0000             add byte ptr [bx + si], al
  01867C  0000             add byte ptr [bx + si], al
  01867E  0000             add byte ptr [bx + si], al
  018680  0000             add byte ptr [bx + si], al
  018682  0000             add byte ptr [bx + si], al
  018684  0000             add byte ptr [bx + si], al
  018686  0000             add byte ptr [bx + si], al
  018688  0000             add byte ptr [bx + si], al
  01868A  0000             add byte ptr [bx + si], al
  01868C  0000             add byte ptr [bx + si], al
  01868E  0000             add byte ptr [bx + si], al
  018690  0000             add byte ptr [bx + si], al
  018692  0000             add byte ptr [bx + si], al
  018694  0000             add byte ptr [bx + si], al
  018696  0000             add byte ptr [bx + si], al
  018698  0000             add byte ptr [bx + si], al
  01869A  0000             add byte ptr [bx + si], al
  01869C  0000             add byte ptr [bx + si], al
  01869E  0000             add byte ptr [bx + si], al
  0186A0  0000             add byte ptr [bx + si], al
  0186A2  0000             add byte ptr [bx + si], al
  0186A4  0000             add byte ptr [bx + si], al
  0186A6  0000             add byte ptr [bx + si], al
  0186A8  0000             add byte ptr [bx + si], al
  0186AA  0000             add byte ptr [bx + si], al
  0186AC  0000             add byte ptr [bx + si], al
  0186AE  0000             add byte ptr [bx + si], al
  0186B0  0000             add byte ptr [bx + si], al
  0186B2  0000             add byte ptr [bx + si], al
  0186B4  0000             add byte ptr [bx + si], al
  0186B6  0000             add byte ptr [bx + si], al
  0186B8  0000             add byte ptr [bx + si], al
  0186BA  0000             add byte ptr [bx + si], al
  0186BC  0000             add byte ptr [bx + si], al
  0186BE  0000             add byte ptr [bx + si], al
  0186C0  0000             add byte ptr [bx + si], al
  0186C2  0000             add byte ptr [bx + si], al
  0186C4  0000             add byte ptr [bx + si], al
  0186C6  0000             add byte ptr [bx + si], al
  0186C8  0000             add byte ptr [bx + si], al
  0186CA  0000             add byte ptr [bx + si], al
  0186CC  0000             add byte ptr [bx + si], al
  0186CE  0000             add byte ptr [bx + si], al
  0186D0  0000             add byte ptr [bx + si], al
  0186D2  0000             add byte ptr [bx + si], al
  0186D4  0000             add byte ptr [bx + si], al
  0186D6  0000             add byte ptr [bx + si], al
  0186D8  0000             add byte ptr [bx + si], al
  0186DA  0000             add byte ptr [bx + si], al
  0186DC  0000             add byte ptr [bx + si], al
  0186DE  0000             add byte ptr [bx + si], al
  0186E0  0000             add byte ptr [bx + si], al
  0186E2  0000             add byte ptr [bx + si], al
  0186E4  0000             add byte ptr [bx + si], al
  0186E6  0000             add byte ptr [bx + si], al
  0186E8  0000             add byte ptr [bx + si], al
  0186EA  0000             add byte ptr [bx + si], al
  0186EC  0000             add byte ptr [bx + si], al
  0186EE  0000             add byte ptr [bx + si], al
  0186F0  0000             add byte ptr [bx + si], al
  0186F2  0000             add byte ptr [bx + si], al
  0186F4  0000             add byte ptr [bx + si], al
  0186F6  0000             add byte ptr [bx + si], al
  0186F8  0000             add byte ptr [bx + si], al
  0186FA  0000             add byte ptr [bx + si], al
  0186FC  0000             add byte ptr [bx + si], al
  0186FE  0000             add byte ptr [bx + si], al
  018700  0000             add byte ptr [bx + si], al
  018702  0000             add byte ptr [bx + si], al
  018704  0000             add byte ptr [bx + si], al
  018706  0000             add byte ptr [bx + si], al
  018708  0000             add byte ptr [bx + si], al
  01870A  0000             add byte ptr [bx + si], al
  01870C  0000             add byte ptr [bx + si], al
  01870E  0000             add byte ptr [bx + si], al
  018710  0000             add byte ptr [bx + si], al
  018712  0000             add byte ptr [bx + si], al
  018714  0000             add byte ptr [bx + si], al
  018716  0000             add byte ptr [bx + si], al
  018718  0000             add byte ptr [bx + si], al
  01871A  0000             add byte ptr [bx + si], al
  01871C  0000             add byte ptr [bx + si], al
  01871E  0000             add byte ptr [bx + si], al
  018720  0000             add byte ptr [bx + si], al
  018722  0000             add byte ptr [bx + si], al
  018724  0000             add byte ptr [bx + si], al
  018726  0000             add byte ptr [bx + si], al
  018728  0000             add byte ptr [bx + si], al
  01872A  0000             add byte ptr [bx + si], al
  01872C  0000             add byte ptr [bx + si], al
  01872E  0000             add byte ptr [bx + si], al
  018730  0000             add byte ptr [bx + si], al
  018732  0000             add byte ptr [bx + si], al
  018734  0000             add byte ptr [bx + si], al
  018736  0000             add byte ptr [bx + si], al
  018738  0000             add byte ptr [bx + si], al
  01873A  0000             add byte ptr [bx + si], al
  01873C  0000             add byte ptr [bx + si], al
  01873E  0000             add byte ptr [bx + si], al
  018740  0000             add byte ptr [bx + si], al
  018742  0000             add byte ptr [bx + si], al
  018744  0000             add byte ptr [bx + si], al
  018746  0000             add byte ptr [bx + si], al
  018748  0000             add byte ptr [bx + si], al
  01874A  0000             add byte ptr [bx + si], al
  01874C  0000             add byte ptr [bx + si], al
  01874E  0000             add byte ptr [bx + si], al
  018750  0000             add byte ptr [bx + si], al
  018752  0000             add byte ptr [bx + si], al
  018754  0000             add byte ptr [bx + si], al
  018756  0000             add byte ptr [bx + si], al
  018758  0000             add byte ptr [bx + si], al
  01875A  0000             add byte ptr [bx + si], al
  01875C  0000             add byte ptr [bx + si], al
  01875E  0000             add byte ptr [bx + si], al
  018760  0000             add byte ptr [bx + si], al
  018762  0000             add byte ptr [bx + si], al
  018764  0000             add byte ptr [bx + si], al
  018766  0000             add byte ptr [bx + si], al
  018768  0000             add byte ptr [bx + si], al
  01876A  0000             add byte ptr [bx + si], al
  01876C  0000             add byte ptr [bx + si], al
  01876E  0000             add byte ptr [bx + si], al
  018770  0000             add byte ptr [bx + si], al
  018772  0000             add byte ptr [bx + si], al
  018774  0000             add byte ptr [bx + si], al
  018776  0000             add byte ptr [bx + si], al
  018778  0000             add byte ptr [bx + si], al
  01877A  0000             add byte ptr [bx + si], al
  01877C  0000             add byte ptr [bx + si], al
  01877E  0000             add byte ptr [bx + si], al
  018780  0000             add byte ptr [bx + si], al
  018782  0000             add byte ptr [bx + si], al
  018784  0000             add byte ptr [bx + si], al
  018786  0000             add byte ptr [bx + si], al
  018788  0000             add byte ptr [bx + si], al
  01878A  0000             add byte ptr [bx + si], al
  01878C  0000             add byte ptr [bx + si], al
  01878E  0000             add byte ptr [bx + si], al
  018790  0000             add byte ptr [bx + si], al
  018792  0000             add byte ptr [bx + si], al
  018794  0000             add byte ptr [bx + si], al
  018796  0000             add byte ptr [bx + si], al
  018798  0000             add byte ptr [bx + si], al
  01879A  0000             add byte ptr [bx + si], al
  01879C  0000             add byte ptr [bx + si], al
  01879E  0000             add byte ptr [bx + si], al
  0187A0  0000             add byte ptr [bx + si], al
  0187A2  0000             add byte ptr [bx + si], al
  0187A4  0000             add byte ptr [bx + si], al
  0187A6  0000             add byte ptr [bx + si], al
  0187A8  0000             add byte ptr [bx + si], al
  0187AA  0000             add byte ptr [bx + si], al
  0187AC  0000             add byte ptr [bx + si], al
  0187AE  0000             add byte ptr [bx + si], al
  0187B0  0000             add byte ptr [bx + si], al
  0187B2  0000             add byte ptr [bx + si], al
  0187B4  0000             add byte ptr [bx + si], al
  0187B6  0000             add byte ptr [bx + si], al
  0187B8  0000             add byte ptr [bx + si], al
  0187BA  0000             add byte ptr [bx + si], al
  0187BC  0000             add byte ptr [bx + si], al
  0187BE  0000             add byte ptr [bx + si], al
  0187C0  0000             add byte ptr [bx + si], al
  0187C2  0000             add byte ptr [bx + si], al
  0187C4  0000             add byte ptr [bx + si], al
  0187C6  0000             add byte ptr [bx + si], al
  0187C8  0000             add byte ptr [bx + si], al
  0187CA  0000             add byte ptr [bx + si], al
  0187CC  0000             add byte ptr [bx + si], al
  0187CE  0000             add byte ptr [bx + si], al
  0187D0  0000             add byte ptr [bx + si], al
  0187D2  0000             add byte ptr [bx + si], al
  0187D4  0000             add byte ptr [bx + si], al
  0187D6  0000             add byte ptr [bx + si], al
  0187D8  0000             add byte ptr [bx + si], al
  0187DA  0000             add byte ptr [bx + si], al
  0187DC  0000             add byte ptr [bx + si], al
  0187DE  0000             add byte ptr [bx + si], al
  0187E0  0000             add byte ptr [bx + si], al
  0187E2  0000             add byte ptr [bx + si], al
  0187E4  0000             add byte ptr [bx + si], al
  0187E6  0000             add byte ptr [bx + si], al
  0187E8  0000             add byte ptr [bx + si], al
  0187EA  0000             add byte ptr [bx + si], al
  0187EC  0000             add byte ptr [bx + si], al
  0187EE  0000             add byte ptr [bx + si], al
  0187F0  0000             add byte ptr [bx + si], al
  0187F2  0000             add byte ptr [bx + si], al
  0187F4  0000             add byte ptr [bx + si], al
  0187F6  0000             add byte ptr [bx + si], al
  0187F8  0000             add byte ptr [bx + si], al
  0187FA  0000             add byte ptr [bx + si], al
  0187FC  0000             add byte ptr [bx + si], al
  0187FE  0000             add byte ptr [bx + si], al
  018800  0000             add byte ptr [bx + si], al
  018802  0000             add byte ptr [bx + si], al
  018804  0000             add byte ptr [bx + si], al
  018806  0000             add byte ptr [bx + si], al
  018808  0000             add byte ptr [bx + si], al
  01880A  0000             add byte ptr [bx + si], al
  01880C  0000             add byte ptr [bx + si], al
  01880E  0000             add byte ptr [bx + si], al
  018810  0000             add byte ptr [bx + si], al
  018812  0000             add byte ptr [bx + si], al
  018814  0000             add byte ptr [bx + si], al
  018816  0000             add byte ptr [bx + si], al
  018818  0000             add byte ptr [bx + si], al
  01881A  0000             add byte ptr [bx + si], al
  01881C  0000             add byte ptr [bx + si], al
  01881E  0000             add byte ptr [bx + si], al
  018820  0000             add byte ptr [bx + si], al
  018822  0000             add byte ptr [bx + si], al
  018824  0000             add byte ptr [bx + si], al
  018826  0000             add byte ptr [bx + si], al
  018828  0000             add byte ptr [bx + si], al
  01882A  0000             add byte ptr [bx + si], al
  01882C  0000             add byte ptr [bx + si], al
  01882E  0000             add byte ptr [bx + si], al
  018830  0000             add byte ptr [bx + si], al
  018832  0000             add byte ptr [bx + si], al
  018834  0000             add byte ptr [bx + si], al
  018836  0000             add byte ptr [bx + si], al
  018838  0000             add byte ptr [bx + si], al
  01883A  0000             add byte ptr [bx + si], al
  01883C  0000             add byte ptr [bx + si], al
  01883E  0000             add byte ptr [bx + si], al
  018840  0000             add byte ptr [bx + si], al
  018842  0000             add byte ptr [bx + si], al
  018844  0000             add byte ptr [bx + si], al
  018846  0000             add byte ptr [bx + si], al
  018848  0000             add byte ptr [bx + si], al
  01884A  0000             add byte ptr [bx + si], al
  01884C  0000             add byte ptr [bx + si], al
  01884E  0000             add byte ptr [bx + si], al
  018850  0000             add byte ptr [bx + si], al
  018852  0000             add byte ptr [bx + si], al
  018854  0000             add byte ptr [bx + si], al
  018856  0000             add byte ptr [bx + si], al
  018858  0000             add byte ptr [bx + si], al
  01885A  0000             add byte ptr [bx + si], al
  01885C  0000             add byte ptr [bx + si], al
  01885E  0000             add byte ptr [bx + si], al
  018860  0000             add byte ptr [bx + si], al
  018862  0000             add byte ptr [bx + si], al
  018864  0000             add byte ptr [bx + si], al
  018866  0000             add byte ptr [bx + si], al
  018868  0000             add byte ptr [bx + si], al
  01886A  0000             add byte ptr [bx + si], al
  01886C  0000             add byte ptr [bx + si], al
  01886E  0000             add byte ptr [bx + si], al
  018870  0000             add byte ptr [bx + si], al
  018872  0000             add byte ptr [bx + si], al
  018874  0000             add byte ptr [bx + si], al
  018876  0000             add byte ptr [bx + si], al
  018878  0000             add byte ptr [bx + si], al
  01887A  0000             add byte ptr [bx + si], al
  01887C  0000             add byte ptr [bx + si], al
  01887E  0000             add byte ptr [bx + si], al
  018880  0000             add byte ptr [bx + si], al
  018882  0000             add byte ptr [bx + si], al
  018884  0000             add byte ptr [bx + si], al
  018886  0000             add byte ptr [bx + si], al
  018888  0000             add byte ptr [bx + si], al
  01888A  0000             add byte ptr [bx + si], al
  01888C  0000             add byte ptr [bx + si], al
  01888E  0000             add byte ptr [bx + si], al
  018890  0000             add byte ptr [bx + si], al
  018892  0000             add byte ptr [bx + si], al
  018894  0000             add byte ptr [bx + si], al
  018896  0000             add byte ptr [bx + si], al
  018898  0000             add byte ptr [bx + si], al
  01889A  0000             add byte ptr [bx + si], al
  01889C  0000             add byte ptr [bx + si], al
  01889E  0000             add byte ptr [bx + si], al
  0188A0  0000             add byte ptr [bx + si], al
  0188A2  0000             add byte ptr [bx + si], al
  0188A4  0000             add byte ptr [bx + si], al
  0188A6  0000             add byte ptr [bx + si], al
  0188A8  0000             add byte ptr [bx + si], al
  0188AA  0000             add byte ptr [bx + si], al
  0188AC  0000             add byte ptr [bx + si], al
  0188AE  0000             add byte ptr [bx + si], al
  0188B0  0000             add byte ptr [bx + si], al
  0188B2  0000             add byte ptr [bx + si], al
  0188B4  0000             add byte ptr [bx + si], al
  0188B6  0000             add byte ptr [bx + si], al
  0188B8  0000             add byte ptr [bx + si], al
  0188BA  0000             add byte ptr [bx + si], al
  0188BC  0000             add byte ptr [bx + si], al
  0188BE  0000             add byte ptr [bx + si], al
  0188C0  0000             add byte ptr [bx + si], al
  0188C2  0000             add byte ptr [bx + si], al
  0188C4  0000             add byte ptr [bx + si], al
  0188C6  0000             add byte ptr [bx + si], al
  0188C8  0000             add byte ptr [bx + si], al
  0188CA  0000             add byte ptr [bx + si], al
  0188CC  0000             add byte ptr [bx + si], al
  0188CE  0000             add byte ptr [bx + si], al
  0188D0  0000             add byte ptr [bx + si], al
  0188D2  0000             add byte ptr [bx + si], al
  0188D4  0000             add byte ptr [bx + si], al
  0188D6  0000             add byte ptr [bx + si], al
  0188D8  0000             add byte ptr [bx + si], al
  0188DA  0000             add byte ptr [bx + si], al
  0188DC  0000             add byte ptr [bx + si], al
  0188DE  0000             add byte ptr [bx + si], al
  0188E0  0000             add byte ptr [bx + si], al
  0188E2  0000             add byte ptr [bx + si], al
  0188E4  0000             add byte ptr [bx + si], al
  0188E6  0000             add byte ptr [bx + si], al
  0188E8  0000             add byte ptr [bx + si], al
  0188EA  0000             add byte ptr [bx + si], al
  0188EC  0000             add byte ptr [bx + si], al
  0188EE  0000             add byte ptr [bx + si], al
  0188F0  0000             add byte ptr [bx + si], al
  0188F2  0000             add byte ptr [bx + si], al
  0188F4  0000             add byte ptr [bx + si], al
  0188F6  0000             add byte ptr [bx + si], al
  0188F8  0000             add byte ptr [bx + si], al
  0188FA  0000             add byte ptr [bx + si], al
  0188FC  0000             add byte ptr [bx + si], al
  0188FE  0000             add byte ptr [bx + si], al
  018900  0000             add byte ptr [bx + si], al
  018902  0000             add byte ptr [bx + si], al
  018904  0000             add byte ptr [bx + si], al
  018906  0000             add byte ptr [bx + si], al
  018908  0000             add byte ptr [bx + si], al
  01890A  0000             add byte ptr [bx + si], al
  01890C  0000             add byte ptr [bx + si], al
  01890E  0000             add byte ptr [bx + si], al
  018910  0000             add byte ptr [bx + si], al
  018912  0000             add byte ptr [bx + si], al
  018914  0000             add byte ptr [bx + si], al
  018916  0000             add byte ptr [bx + si], al
  018918  0000             add byte ptr [bx + si], al
  01891A  0000             add byte ptr [bx + si], al
  01891C  0000             add byte ptr [bx + si], al
  01891E  0000             add byte ptr [bx + si], al
  018920  0000             add byte ptr [bx + si], al
  018922  0000             add byte ptr [bx + si], al
  018924  0000             add byte ptr [bx + si], al
  018926  0000             add byte ptr [bx + si], al
  018928  0000             add byte ptr [bx + si], al
  01892A  0000             add byte ptr [bx + si], al
  01892C  0000             add byte ptr [bx + si], al
  01892E  0000             add byte ptr [bx + si], al
  018930  0000             add byte ptr [bx + si], al
  018932  0000             add byte ptr [bx + si], al
  018934  0000             add byte ptr [bx + si], al
  018936  0000             add byte ptr [bx + si], al
  018938  0000             add byte ptr [bx + si], al
  01893A  0000             add byte ptr [bx + si], al
  01893C  0000             add byte ptr [bx + si], al
  01893E  0000             add byte ptr [bx + si], al
  018940  0000             add byte ptr [bx + si], al
  018942  0000             add byte ptr [bx + si], al
  018944  0000             add byte ptr [bx + si], al
  018946  0000             add byte ptr [bx + si], al
  018948  0000             add byte ptr [bx + si], al
  01894A  0000             add byte ptr [bx + si], al
  01894C  0000             add byte ptr [bx + si], al
  01894E  0000             add byte ptr [bx + si], al
  018950  0000             add byte ptr [bx + si], al
  018952  0000             add byte ptr [bx + si], al
  018954  0000             add byte ptr [bx + si], al
  018956  0000             add byte ptr [bx + si], al
  018958  0000             add byte ptr [bx + si], al
  01895A  0000             add byte ptr [bx + si], al
  01895C  0000             add byte ptr [bx + si], al
  01895E  0000             add byte ptr [bx + si], al
  018960  0000             add byte ptr [bx + si], al
  018962  0000             add byte ptr [bx + si], al
  018964  0000             add byte ptr [bx + si], al
  018966  0000             add byte ptr [bx + si], al
  018968  0000             add byte ptr [bx + si], al
  01896A  0000             add byte ptr [bx + si], al
  01896C  0000             add byte ptr [bx + si], al
  01896E  0000             add byte ptr [bx + si], al
  018970  0000             add byte ptr [bx + si], al
  018972  0000             add byte ptr [bx + si], al
  018974  0000             add byte ptr [bx + si], al
  018976  0000             add byte ptr [bx + si], al
  018978  0000             add byte ptr [bx + si], al
  01897A  0000             add byte ptr [bx + si], al
  01897C  0000             add byte ptr [bx + si], al
  01897E  0000             add byte ptr [bx + si], al
  018980  0000             add byte ptr [bx + si], al
  018982  0000             add byte ptr [bx + si], al
  018984  0000             add byte ptr [bx + si], al
  018986  0000             add byte ptr [bx + si], al
  018988  0000             add byte ptr [bx + si], al
  01898A  0000             add byte ptr [bx + si], al
  01898C  0000             add byte ptr [bx + si], al
  01898E  0000             add byte ptr [bx + si], al
  018990  0000             add byte ptr [bx + si], al
  018992  0000             add byte ptr [bx + si], al
  018994  0000             add byte ptr [bx + si], al
  018996  0000             add byte ptr [bx + si], al
  018998  0000             add byte ptr [bx + si], al
  01899A  0000             add byte ptr [bx + si], al
  01899C  0000             add byte ptr [bx + si], al
  01899E  0000             add byte ptr [bx + si], al
  0189A0  0000             add byte ptr [bx + si], al
  0189A2  0000             add byte ptr [bx + si], al
  0189A4  0000             add byte ptr [bx + si], al
  0189A6  0000             add byte ptr [bx + si], al
  0189A8  0000             add byte ptr [bx + si], al
  0189AA  0000             add byte ptr [bx + si], al
  0189AC  0000             add byte ptr [bx + si], al
  0189AE  0000             add byte ptr [bx + si], al
  0189B0  0000             add byte ptr [bx + si], al
  0189B2  0000             add byte ptr [bx + si], al
  0189B4  0000             add byte ptr [bx + si], al
  0189B6  0000             add byte ptr [bx + si], al
  0189B8  0000             add byte ptr [bx + si], al
  0189BA  0000             add byte ptr [bx + si], al
  0189BC  0000             add byte ptr [bx + si], al
  0189BE  0000             add byte ptr [bx + si], al
  0189C0  0000             add byte ptr [bx + si], al
  0189C2  0000             add byte ptr [bx + si], al
  0189C4  0000             add byte ptr [bx + si], al
  0189C6  0000             add byte ptr [bx + si], al
  0189C8  0000             add byte ptr [bx + si], al
  0189CA  0000             add byte ptr [bx + si], al
  0189CC  0000             add byte ptr [bx + si], al
  0189CE  0000             add byte ptr [bx + si], al
  0189D0  0000             add byte ptr [bx + si], al
  0189D2  0000             add byte ptr [bx + si], al
  0189D4  0000             add byte ptr [bx + si], al
  0189D6  0000             add byte ptr [bx + si], al
  0189D8  0000             add byte ptr [bx + si], al
  0189DA  0000             add byte ptr [bx + si], al
  0189DC  0000             add byte ptr [bx + si], al
  0189DE  0000             add byte ptr [bx + si], al
  0189E0  0000             add byte ptr [bx + si], al
  0189E2  0000             add byte ptr [bx + si], al
  0189E4  0000             add byte ptr [bx + si], al
  0189E6  0000             add byte ptr [bx + si], al
  0189E8  0000             add byte ptr [bx + si], al
  0189EA  0000             add byte ptr [bx + si], al
  0189EC  0000             add byte ptr [bx + si], al
  0189EE  0000             add byte ptr [bx + si], al
  0189F0  0000             add byte ptr [bx + si], al
  0189F2  0000             add byte ptr [bx + si], al
  0189F4  0000             add byte ptr [bx + si], al
  0189F6  0000             add byte ptr [bx + si], al
  0189F8  0000             add byte ptr [bx + si], al
  0189FA  0000             add byte ptr [bx + si], al
  0189FC  0000             add byte ptr [bx + si], al
  0189FE  0000             add byte ptr [bx + si], al
  018A00  0000             add byte ptr [bx + si], al
  018A02  0000             add byte ptr [bx + si], al
  018A04  0000             add byte ptr [bx + si], al
  018A06  0000             add byte ptr [bx + si], al
  018A08  0000             add byte ptr [bx + si], al
  018A0A  0000             add byte ptr [bx + si], al
  018A0C  0000             add byte ptr [bx + si], al
  018A0E  0000             add byte ptr [bx + si], al
  018A10  0000             add byte ptr [bx + si], al
  018A12  0000             add byte ptr [bx + si], al
  018A14  0000             add byte ptr [bx + si], al
  018A16  0000             add byte ptr [bx + si], al
  018A18  0000             add byte ptr [bx + si], al
  018A1A  0000             add byte ptr [bx + si], al
  018A1C  0000             add byte ptr [bx + si], al
  018A1E  0000             add byte ptr [bx + si], al
  018A20  0000             add byte ptr [bx + si], al
  018A22  0000             add byte ptr [bx + si], al
  018A24  0000             add byte ptr [bx + si], al
  018A26  0000             add byte ptr [bx + si], al
  018A28  0000             add byte ptr [bx + si], al
  018A2A  0000             add byte ptr [bx + si], al
  018A2C  0000             add byte ptr [bx + si], al
  018A2E  0000             add byte ptr [bx + si], al
  018A30  0000             add byte ptr [bx + si], al
  018A32  0000             add byte ptr [bx + si], al
  018A34  0000             add byte ptr [bx + si], al
  018A36  0000             add byte ptr [bx + si], al
  018A38  0000             add byte ptr [bx + si], al
  018A3A  0000             add byte ptr [bx + si], al
  018A3C  0000             add byte ptr [bx + si], al
  018A3E  0000             add byte ptr [bx + si], al
  018A40  0000             add byte ptr [bx + si], al
  018A42  0000             add byte ptr [bx + si], al
  018A44  0000             add byte ptr [bx + si], al
  018A46  0000             add byte ptr [bx + si], al
  018A48  0000             add byte ptr [bx + si], al
  018A4A  0000             add byte ptr [bx + si], al
  018A4C  0000             add byte ptr [bx + si], al
  018A4E  0000             add byte ptr [bx + si], al
  018A50  0000             add byte ptr [bx + si], al
  018A52  0000             add byte ptr [bx + si], al
  018A54  0000             add byte ptr [bx + si], al
  018A56  0000             add byte ptr [bx + si], al
  018A58  0000             add byte ptr [bx + si], al
  018A5A  0000             add byte ptr [bx + si], al
  018A5C  0000             add byte ptr [bx + si], al
  018A5E  0000             add byte ptr [bx + si], al
  018A60  0000             add byte ptr [bx + si], al
  018A62  0000             add byte ptr [bx + si], al
  018A64  0000             add byte ptr [bx + si], al
  018A66  0000             add byte ptr [bx + si], al
  018A68  0000             add byte ptr [bx + si], al
  018A6A  0000             add byte ptr [bx + si], al
  018A6C  0000             add byte ptr [bx + si], al
  018A6E  0000             add byte ptr [bx + si], al
  018A70  0000             add byte ptr [bx + si], al
  018A72  0000             add byte ptr [bx + si], al
  018A74  0000             add byte ptr [bx + si], al
  018A76  0000             add byte ptr [bx + si], al
  018A78  0000             add byte ptr [bx + si], al
  018A7A  0000             add byte ptr [bx + si], al
  018A7C  0000             add byte ptr [bx + si], al
  018A7E  0000             add byte ptr [bx + si], al
  018A80  0000             add byte ptr [bx + si], al
  018A82  0000             add byte ptr [bx + si], al
  018A84  0000             add byte ptr [bx + si], al
  018A86  0000             add byte ptr [bx + si], al
  018A88  0000             add byte ptr [bx + si], al
  018A8A  0000             add byte ptr [bx + si], al
  018A8C  0000             add byte ptr [bx + si], al
  018A8E  0000             add byte ptr [bx + si], al
  018A90  0000             add byte ptr [bx + si], al
  018A92  0000             add byte ptr [bx + si], al
  018A94  0000             add byte ptr [bx + si], al
  018A96  0000             add byte ptr [bx + si], al
  018A98  0000             add byte ptr [bx + si], al
  018A9A  0000             add byte ptr [bx + si], al
  018A9C  0000             add byte ptr [bx + si], al
  018A9E  0000             add byte ptr [bx + si], al
  018AA0  0000             add byte ptr [bx + si], al
  018AA2  0000             add byte ptr [bx + si], al
  018AA4  0000             add byte ptr [bx + si], al
  018AA6  0000             add byte ptr [bx + si], al
  018AA8  0000             add byte ptr [bx + si], al
  018AAA  0000             add byte ptr [bx + si], al
  018AAC  0000             add byte ptr [bx + si], al
  018AAE  0000             add byte ptr [bx + si], al
  018AB0  0000             add byte ptr [bx + si], al
  018AB2  0000             add byte ptr [bx + si], al
  018AB4  0000             add byte ptr [bx + si], al
  018AB6  0000             add byte ptr [bx + si], al
  018AB8  0000             add byte ptr [bx + si], al
  018ABA  0000             add byte ptr [bx + si], al
  018ABC  0000             add byte ptr [bx + si], al
  018ABE  0000             add byte ptr [bx + si], al
  018AC0  0000             add byte ptr [bx + si], al
  018AC2  0000             add byte ptr [bx + si], al
  018AC4  0000             add byte ptr [bx + si], al
  018AC6  0000             add byte ptr [bx + si], al
  018AC8  0000             add byte ptr [bx + si], al
  018ACA  0000             add byte ptr [bx + si], al
  018ACC  0000             add byte ptr [bx + si], al
  018ACE  0000             add byte ptr [bx + si], al
  018AD0  0000             add byte ptr [bx + si], al
  018AD2  0000             add byte ptr [bx + si], al
  018AD4  0000             add byte ptr [bx + si], al
  018AD6  0000             add byte ptr [bx + si], al
  018AD8  0000             add byte ptr [bx + si], al
  018ADA  0000             add byte ptr [bx + si], al
  018ADC  0000             add byte ptr [bx + si], al
  018ADE  0000             add byte ptr [bx + si], al
  018AE0  0000             add byte ptr [bx + si], al
  018AE2  0000             add byte ptr [bx + si], al
  018AE4  0000             add byte ptr [bx + si], al
  018AE6  0000             add byte ptr [bx + si], al
  018AE8  0000             add byte ptr [bx + si], al
  018AEA  0000             add byte ptr [bx + si], al
  018AEC  0000             add byte ptr [bx + si], al
  018AEE  0000             add byte ptr [bx + si], al
  018AF0  0000             add byte ptr [bx + si], al
  018AF2  0000             add byte ptr [bx + si], al
  018AF4  0000             add byte ptr [bx + si], al
  018AF6  0000             add byte ptr [bx + si], al
  018AF8  0000             add byte ptr [bx + si], al
  018AFA  0000             add byte ptr [bx + si], al
  018AFC  0000             add byte ptr [bx + si], al
  018AFE  0000             add byte ptr [bx + si], al
  018B00  0000             add byte ptr [bx + si], al
  018B02  0000             add byte ptr [bx + si], al
  018B04  0000             add byte ptr [bx + si], al
  018B06  0000             add byte ptr [bx + si], al
  018B08  0000             add byte ptr [bx + si], al
  018B0A  0000             add byte ptr [bx + si], al
  018B0C  0000             add byte ptr [bx + si], al
  018B0E  0000             add byte ptr [bx + si], al
  018B10  0000             add byte ptr [bx + si], al
  018B12  0000             add byte ptr [bx + si], al
  018B14  0000             add byte ptr [bx + si], al
  018B16  0000             add byte ptr [bx + si], al
  018B18  0000             add byte ptr [bx + si], al
  018B1A  0000             add byte ptr [bx + si], al
  018B1C  0000             add byte ptr [bx + si], al
  018B1E  0000             add byte ptr [bx + si], al
  018B20  0000             add byte ptr [bx + si], al
  018B22  0000             add byte ptr [bx + si], al
  018B24  0000             add byte ptr [bx + si], al
  018B26  0000             add byte ptr [bx + si], al
  018B28  0000             add byte ptr [bx + si], al
  018B2A  0000             add byte ptr [bx + si], al
  018B2C  0000             add byte ptr [bx + si], al
  018B2E  0000             add byte ptr [bx + si], al
  018B30  0000             add byte ptr [bx + si], al
  018B32  0000             add byte ptr [bx + si], al
  018B34  0000             add byte ptr [bx + si], al
  018B36  0000             add byte ptr [bx + si], al
  018B38  0000             add byte ptr [bx + si], al
  018B3A  0000             add byte ptr [bx + si], al
  018B3C  0000             add byte ptr [bx + si], al
  018B3E  0000             add byte ptr [bx + si], al
  018B40  0000             add byte ptr [bx + si], al
  018B42  0000             add byte ptr [bx + si], al
  018B44  0000             add byte ptr [bx + si], al
  018B46  0000             add byte ptr [bx + si], al
  018B48  0000             add byte ptr [bx + si], al
  018B4A  0000             add byte ptr [bx + si], al
  018B4C  0000             add byte ptr [bx + si], al
  018B4E  0000             add byte ptr [bx + si], al
  018B50  0000             add byte ptr [bx + si], al
  018B52  0000             add byte ptr [bx + si], al
  018B54  0000             add byte ptr [bx + si], al
  018B56  0000             add byte ptr [bx + si], al
  018B58  0000             add byte ptr [bx + si], al
  018B5A  0000             add byte ptr [bx + si], al
  018B5C  0000             add byte ptr [bx + si], al
  018B5E  0000             add byte ptr [bx + si], al
  018B60  0000             add byte ptr [bx + si], al
  018B62  0000             add byte ptr [bx + si], al
  018B64  0000             add byte ptr [bx + si], al
  018B66  0000             add byte ptr [bx + si], al
  018B68  0000             add byte ptr [bx + si], al
  018B6A  0000             add byte ptr [bx + si], al
  018B6C  0000             add byte ptr [bx + si], al
  018B6E  0000             add byte ptr [bx + si], al
  018B70  0000             add byte ptr [bx + si], al
  018B72  0000             add byte ptr [bx + si], al
  018B74  0000             add byte ptr [bx + si], al
  018B76  0000             add byte ptr [bx + si], al
  018B78  0000             add byte ptr [bx + si], al
  018B7A  0000             add byte ptr [bx + si], al
  018B7C  0000             add byte ptr [bx + si], al
  018B7E  0000             add byte ptr [bx + si], al
  018B80  0000             add byte ptr [bx + si], al
  018B82  0000             add byte ptr [bx + si], al
  018B84  0000             add byte ptr [bx + si], al
  018B86  0000             add byte ptr [bx + si], al
  018B88  0000             add byte ptr [bx + si], al
  018B8A  0000             add byte ptr [bx + si], al
  018B8C  0000             add byte ptr [bx + si], al
  018B8E  0000             add byte ptr [bx + si], al
  018B90  0000             add byte ptr [bx + si], al
  018B92  0000             add byte ptr [bx + si], al
  018B94  0000             add byte ptr [bx + si], al
  018B96  0000             add byte ptr [bx + si], al
  018B98  0000             add byte ptr [bx + si], al
  018B9A  0000             add byte ptr [bx + si], al
  018B9C  0000             add byte ptr [bx + si], al
  018B9E  0000             add byte ptr [bx + si], al
  018BA0  0000             add byte ptr [bx + si], al
  018BA2  0000             add byte ptr [bx + si], al
  018BA4  0000             add byte ptr [bx + si], al
  018BA6  0000             add byte ptr [bx + si], al
  018BA8  0000             add byte ptr [bx + si], al
  018BAA  0000             add byte ptr [bx + si], al
  018BAC  0000             add byte ptr [bx + si], al
  018BAE  0000             add byte ptr [bx + si], al
  018BB0  0000             add byte ptr [bx + si], al
  018BB2  0000             add byte ptr [bx + si], al
  018BB4  0000             add byte ptr [bx + si], al
  018BB6  0000             add byte ptr [bx + si], al
  018BB8  0000             add byte ptr [bx + si], al
  018BBA  0000             add byte ptr [bx + si], al
  018BBC  0000             add byte ptr [bx + si], al
  018BBE  0000             add byte ptr [bx + si], al
  018BC0  0000             add byte ptr [bx + si], al
  018BC2  0000             add byte ptr [bx + si], al
  018BC4  0000             add byte ptr [bx + si], al
  018BC6  0000             add byte ptr [bx + si], al
  018BC8  0000             add byte ptr [bx + si], al
  018BCA  0000             add byte ptr [bx + si], al
  018BCC  0000             add byte ptr [bx + si], al
  018BCE  0000             add byte ptr [bx + si], al
  018BD0  0000             add byte ptr [bx + si], al
  018BD2  0000             add byte ptr [bx + si], al
  018BD4  0000             add byte ptr [bx + si], al
  018BD6  0000             add byte ptr [bx + si], al
  018BD8  0000             add byte ptr [bx + si], al
  018BDA  0000             add byte ptr [bx + si], al
  018BDC  0000             add byte ptr [bx + si], al
  018BDE  0000             add byte ptr [bx + si], al
  018BE0  0000             add byte ptr [bx + si], al
  018BE2  0000             add byte ptr [bx + si], al
  018BE4  0000             add byte ptr [bx + si], al
  018BE6  0000             add byte ptr [bx + si], al
  018BE8  0000             add byte ptr [bx + si], al
  018BEA  0000             add byte ptr [bx + si], al
  018BEC  0000             add byte ptr [bx + si], al
  018BEE  0000             add byte ptr [bx + si], al
  018BF0  0000             add byte ptr [bx + si], al
  018BF2  0000             add byte ptr [bx + si], al
  018BF4  0000             add byte ptr [bx + si], al
  018BF6  0000             add byte ptr [bx + si], al
  018BF8  0000             add byte ptr [bx + si], al
  018BFA  0000             add byte ptr [bx + si], al
  018BFC  0000             add byte ptr [bx + si], al
  018BFE  0000             add byte ptr [bx + si], al
  018C00  0000             add byte ptr [bx + si], al
  018C02  0000             add byte ptr [bx + si], al
  018C04  0000             add byte ptr [bx + si], al
  018C06  0000             add byte ptr [bx + si], al
  018C08  0000             add byte ptr [bx + si], al
  018C0A  0000             add byte ptr [bx + si], al
  018C0C  0000             add byte ptr [bx + si], al
  018C0E  0000             add byte ptr [bx + si], al
  018C10  0000             add byte ptr [bx + si], al
  018C12  0000             add byte ptr [bx + si], al
  018C14  0000             add byte ptr [bx + si], al
  018C16  0000             add byte ptr [bx + si], al
  018C18  0000             add byte ptr [bx + si], al
  018C1A  0000             add byte ptr [bx + si], al
  018C1C  0000             add byte ptr [bx + si], al
  018C1E  0000             add byte ptr [bx + si], al
  018C20  0000             add byte ptr [bx + si], al
  018C22  0000             add byte ptr [bx + si], al
  018C24  0000             add byte ptr [bx + si], al
  018C26  0000             add byte ptr [bx + si], al
  018C28  0000             add byte ptr [bx + si], al
  018C2A  0000             add byte ptr [bx + si], al
  018C2C  0000             add byte ptr [bx + si], al
  018C2E  0000             add byte ptr [bx + si], al
  018C30  0000             add byte ptr [bx + si], al
  018C32  0000             add byte ptr [bx + si], al
  018C34  0000             add byte ptr [bx + si], al
  018C36  0000             add byte ptr [bx + si], al
  018C38  0000             add byte ptr [bx + si], al
  018C3A  0000             add byte ptr [bx + si], al
  018C3C  0000             add byte ptr [bx + si], al
  018C3E  0000             add byte ptr [bx + si], al
  018C40  0000             add byte ptr [bx + si], al
  018C42  0000             add byte ptr [bx + si], al
  018C44  0000             add byte ptr [bx + si], al
  018C46  0000             add byte ptr [bx + si], al
  018C48  0000             add byte ptr [bx + si], al
  018C4A  0000             add byte ptr [bx + si], al
  018C4C  0000             add byte ptr [bx + si], al
  018C4E  0000             add byte ptr [bx + si], al
  018C50  0000             add byte ptr [bx + si], al
  018C52  0000             add byte ptr [bx + si], al
  018C54  0000             add byte ptr [bx + si], al
  018C56  0000             add byte ptr [bx + si], al
  018C58  0000             add byte ptr [bx + si], al
  018C5A  0000             add byte ptr [bx + si], al
  018C5C  0000             add byte ptr [bx + si], al
  018C5E  0000             add byte ptr [bx + si], al
  018C60  0000             add byte ptr [bx + si], al
  018C62  0000             add byte ptr [bx + si], al
  018C64  0000             add byte ptr [bx + si], al
  018C66  0000             add byte ptr [bx + si], al
  018C68  0000             add byte ptr [bx + si], al
  018C6A  0000             add byte ptr [bx + si], al
  018C6C  0000             add byte ptr [bx + si], al
  018C6E  0000             add byte ptr [bx + si], al
  018C70  0000             add byte ptr [bx + si], al
  018C72  0000             add byte ptr [bx + si], al
  018C74  0000             add byte ptr [bx + si], al
  018C76  0000             add byte ptr [bx + si], al
  018C78  0000             add byte ptr [bx + si], al
  018C7A  0000             add byte ptr [bx + si], al
  018C7C  0000             add byte ptr [bx + si], al
  018C7E  0000             add byte ptr [bx + si], al
  018C80  0000             add byte ptr [bx + si], al
  018C82  0000             add byte ptr [bx + si], al
  018C84  0000             add byte ptr [bx + si], al
  018C86  0000             add byte ptr [bx + si], al
  018C88  0000             add byte ptr [bx + si], al
  018C8A  0000             add byte ptr [bx + si], al
  018C8C  0000             add byte ptr [bx + si], al
  018C8E  0000             add byte ptr [bx + si], al
  018C90  0000             add byte ptr [bx + si], al
  018C92  0000             add byte ptr [bx + si], al
  018C94  0000             add byte ptr [bx + si], al
  018C96  0000             add byte ptr [bx + si], al
  018C98  0000             add byte ptr [bx + si], al
  018C9A  0000             add byte ptr [bx + si], al
  018C9C  0000             add byte ptr [bx + si], al
  018C9E  0000             add byte ptr [bx + si], al
  018CA0  0000             add byte ptr [bx + si], al
  018CA2  0000             add byte ptr [bx + si], al
  018CA4  0000             add byte ptr [bx + si], al
  018CA6  0000             add byte ptr [bx + si], al
  018CA8  0000             add byte ptr [bx + si], al
  018CAA  0000             add byte ptr [bx + si], al
  018CAC  0000             add byte ptr [bx + si], al
  018CAE  0000             add byte ptr [bx + si], al
  018CB0  0000             add byte ptr [bx + si], al
  018CB2  0000             add byte ptr [bx + si], al
  018CB4  0000             add byte ptr [bx + si], al
  018CB6  0000             add byte ptr [bx + si], al
  018CB8  0000             add byte ptr [bx + si], al
  018CBA  0000             add byte ptr [bx + si], al
  018CBC  0000             add byte ptr [bx + si], al
  018CBE  0000             add byte ptr [bx + si], al
  018CC0  0000             add byte ptr [bx + si], al
  018CC2  0000             add byte ptr [bx + si], al
  018CC4  0000             add byte ptr [bx + si], al
  018CC6  0000             add byte ptr [bx + si], al
  018CC8  0000             add byte ptr [bx + si], al
  018CCA  0000             add byte ptr [bx + si], al
  018CCC  0000             add byte ptr [bx + si], al
  018CCE  0000             add byte ptr [bx + si], al
  018CD0  0000             add byte ptr [bx + si], al
  018CD2  0000             add byte ptr [bx + si], al
  018CD4  0000             add byte ptr [bx + si], al
  018CD6  0000             add byte ptr [bx + si], al
  018CD8  0000             add byte ptr [bx + si], al
  018CDA  0000             add byte ptr [bx + si], al
  018CDC  0000             add byte ptr [bx + si], al
  018CDE  0000             add byte ptr [bx + si], al
  018CE0  0000             add byte ptr [bx + si], al
  018CE2  0000             add byte ptr [bx + si], al
  018CE4  0000             add byte ptr [bx + si], al
  018CE6  0000             add byte ptr [bx + si], al
  018CE8  0000             add byte ptr [bx + si], al
  018CEA  0000             add byte ptr [bx + si], al
  018CEC  0000             add byte ptr [bx + si], al
  018CEE  0000             add byte ptr [bx + si], al
  018CF0  0000             add byte ptr [bx + si], al
  018CF2  0000             add byte ptr [bx + si], al
  018CF4  0000             add byte ptr [bx + si], al
  018CF6  0000             add byte ptr [bx + si], al
  018CF8  0000             add byte ptr [bx + si], al
  018CFA  0000             add byte ptr [bx + si], al
  018CFC  0000             add byte ptr [bx + si], al
  018CFE  0000             add byte ptr [bx + si], al
  018D00  0000             add byte ptr [bx + si], al
  018D02  0000             add byte ptr [bx + si], al
  018D04  0000             add byte ptr [bx + si], al
  018D06  0000             add byte ptr [bx + si], al
  018D08  0000             add byte ptr [bx + si], al
  018D0A  0000             add byte ptr [bx + si], al
  018D0C  0000             add byte ptr [bx + si], al
  018D0E  0000             add byte ptr [bx + si], al
  018D10  0000             add byte ptr [bx + si], al
  018D12  0000             add byte ptr [bx + si], al
  018D14  0000             add byte ptr [bx + si], al
  018D16  0000             add byte ptr [bx + si], al
  018D18  0000             add byte ptr [bx + si], al
  018D1A  0000             add byte ptr [bx + si], al
  018D1C  0000             add byte ptr [bx + si], al
  018D1E  0000             add byte ptr [bx + si], al
  018D20  0000             add byte ptr [bx + si], al
  018D22  0000             add byte ptr [bx + si], al
  018D24  0000             add byte ptr [bx + si], al
  018D26  0000             add byte ptr [bx + si], al
  018D28  0000             add byte ptr [bx + si], al
  018D2A  0000             add byte ptr [bx + si], al
  018D2C  0000             add byte ptr [bx + si], al
  018D2E  0000             add byte ptr [bx + si], al
  018D30  0000             add byte ptr [bx + si], al
  018D32  0000             add byte ptr [bx + si], al
  018D34  0000             add byte ptr [bx + si], al
  018D36  0000             add byte ptr [bx + si], al
  018D38  0000             add byte ptr [bx + si], al
  018D3A  0000             add byte ptr [bx + si], al
  018D3C  0000             add byte ptr [bx + si], al
  018D3E  0000             add byte ptr [bx + si], al
  018D40  0000             add byte ptr [bx + si], al
  018D42  0000             add byte ptr [bx + si], al
  018D44  0000             add byte ptr [bx + si], al
  018D46  0000             add byte ptr [bx + si], al
  018D48  0000             add byte ptr [bx + si], al
  018D4A  0000             add byte ptr [bx + si], al
  018D4C  0000             add byte ptr [bx + si], al
  018D4E  0000             add byte ptr [bx + si], al
  018D50  0000             add byte ptr [bx + si], al
  018D52  0000             add byte ptr [bx + si], al
  018D54  0000             add byte ptr [bx + si], al
  018D56  0000             add byte ptr [bx + si], al
  018D58  0000             add byte ptr [bx + si], al
  018D5A  0000             add byte ptr [bx + si], al
  018D5C  0000             add byte ptr [bx + si], al
  018D5E  0000             add byte ptr [bx + si], al
  018D60  0000             add byte ptr [bx + si], al
  018D62  0000             add byte ptr [bx + si], al
  018D64  0000             add byte ptr [bx + si], al
  018D66  0000             add byte ptr [bx + si], al
  018D68  0000             add byte ptr [bx + si], al
  018D6A  0000             add byte ptr [bx + si], al
  018D6C  0000             add byte ptr [bx + si], al
  018D6E  0000             add byte ptr [bx + si], al
  018D70  0000             add byte ptr [bx + si], al
  018D72  0000             add byte ptr [bx + si], al
  018D74  0000             add byte ptr [bx + si], al
  018D76  0000             add byte ptr [bx + si], al
  018D78  0000             add byte ptr [bx + si], al
  018D7A  0000             add byte ptr [bx + si], al
  018D7C  0000             add byte ptr [bx + si], al
  018D7E  0000             add byte ptr [bx + si], al
  018D80  0000             add byte ptr [bx + si], al
  018D82  0000             add byte ptr [bx + si], al
  018D84  0000             add byte ptr [bx + si], al
  018D86  0000             add byte ptr [bx + si], al
  018D88  0000             add byte ptr [bx + si], al
  018D8A  0000             add byte ptr [bx + si], al
  018D8C  0000             add byte ptr [bx + si], al
  018D8E  0000             add byte ptr [bx + si], al
  018D90  0000             add byte ptr [bx + si], al
  018D92  0000             add byte ptr [bx + si], al
  018D94  0000             add byte ptr [bx + si], al
  018D96  0000             add byte ptr [bx + si], al
  018D98  0000             add byte ptr [bx + si], al
  018D9A  0000             add byte ptr [bx + si], al
  018D9C  0000             add byte ptr [bx + si], al
  018D9E  0000             add byte ptr [bx + si], al
  018DA0  0000             add byte ptr [bx + si], al
  018DA2  0000             add byte ptr [bx + si], al
  018DA4  0000             add byte ptr [bx + si], al
  018DA6  0000             add byte ptr [bx + si], al
  018DA8  0000             add byte ptr [bx + si], al
  018DAA  0000             add byte ptr [bx + si], al
  018DAC  0000             add byte ptr [bx + si], al
  018DAE  0000             add byte ptr [bx + si], al
  018DB0  0000             add byte ptr [bx + si], al
  018DB2  0000             add byte ptr [bx + si], al
  018DB4  0000             add byte ptr [bx + si], al
  018DB6  0000             add byte ptr [bx + si], al
  018DB8  0000             add byte ptr [bx + si], al
  018DBA  0000             add byte ptr [bx + si], al
  018DBC  0000             add byte ptr [bx + si], al
  018DBE  0000             add byte ptr [bx + si], al
  018DC0  0000             add byte ptr [bx + si], al
  018DC2  0000             add byte ptr [bx + si], al
  018DC4  0000             add byte ptr [bx + si], al
  018DC6  0000             add byte ptr [bx + si], al
  018DC8  0000             add byte ptr [bx + si], al
  018DCA  0000             add byte ptr [bx + si], al
  018DCC  0000             add byte ptr [bx + si], al
  018DCE  0000             add byte ptr [bx + si], al
  018DD0  0000             add byte ptr [bx + si], al
  018DD2  0000             add byte ptr [bx + si], al
  018DD4  0000             add byte ptr [bx + si], al
  018DD6  0000             add byte ptr [bx + si], al
  018DD8  0000             add byte ptr [bx + si], al
  018DDA  0000             add byte ptr [bx + si], al
  018DDC  0000             add byte ptr [bx + si], al
  018DDE  0000             add byte ptr [bx + si], al
  018DE0  0000             add byte ptr [bx + si], al
  018DE2  0000             add byte ptr [bx + si], al
  018DE4  0000             add byte ptr [bx + si], al
  018DE6  0000             add byte ptr [bx + si], al
  018DE8  0000             add byte ptr [bx + si], al
  018DEA  0000             add byte ptr [bx + si], al
  018DEC  0000             add byte ptr [bx + si], al
  018DEE  0000             add byte ptr [bx + si], al
  018DF0  0000             add byte ptr [bx + si], al
  018DF2  0000             add byte ptr [bx + si], al
  018DF4  0000             add byte ptr [bx + si], al
  018DF6  0000             add byte ptr [bx + si], al
  018DF8  0000             add byte ptr [bx + si], al
  018DFA  0000             add byte ptr [bx + si], al
  018DFC  0000             add byte ptr [bx + si], al
  018DFE  0000             add byte ptr [bx + si], al
  018E00  0000             add byte ptr [bx + si], al
  018E02  0000             add byte ptr [bx + si], al
  018E04  0000             add byte ptr [bx + si], al
  018E06  0000             add byte ptr [bx + si], al
  018E08  0000             add byte ptr [bx + si], al
  018E0A  0000             add byte ptr [bx + si], al
  018E0C  0000             add byte ptr [bx + si], al
  018E0E  0000             add byte ptr [bx + si], al
  018E10  0000             add byte ptr [bx + si], al
  018E12  0000             add byte ptr [bx + si], al
  018E14  0000             add byte ptr [bx + si], al
  018E16  0000             add byte ptr [bx + si], al
  018E18  0000             add byte ptr [bx + si], al
  018E1A  0000             add byte ptr [bx + si], al
  018E1C  0000             add byte ptr [bx + si], al
  018E1E  0000             add byte ptr [bx + si], al
  018E20  0000             add byte ptr [bx + si], al
  018E22  0000             add byte ptr [bx + si], al
  018E24  0000             add byte ptr [bx + si], al
  018E26  0000             add byte ptr [bx + si], al
  018E28  0000             add byte ptr [bx + si], al
  018E2A  0000             add byte ptr [bx + si], al
  018E2C  0000             add byte ptr [bx + si], al
  018E2E  0000             add byte ptr [bx + si], al
  018E30  0000             add byte ptr [bx + si], al
  018E32  0000             add byte ptr [bx + si], al
  018E34  0000             add byte ptr [bx + si], al
  018E36  0000             add byte ptr [bx + si], al
  018E38  0000             add byte ptr [bx + si], al
  018E3A  0000             add byte ptr [bx + si], al
  018E3C  0000             add byte ptr [bx + si], al
  018E3E  0000             add byte ptr [bx + si], al
  018E40  0000             add byte ptr [bx + si], al
  018E42  0000             add byte ptr [bx + si], al
  018E44  0000             add byte ptr [bx + si], al
  018E46  0000             add byte ptr [bx + si], al
  018E48  0000             add byte ptr [bx + si], al
  018E4A  0000             add byte ptr [bx + si], al
  018E4C  0000             add byte ptr [bx + si], al
  018E4E  0000             add byte ptr [bx + si], al
  018E50  0000             add byte ptr [bx + si], al
  018E52  0000             add byte ptr [bx + si], al
  018E54  0000             add byte ptr [bx + si], al
  018E56  0000             add byte ptr [bx + si], al
  018E58  0000             add byte ptr [bx + si], al
  018E5A  0000             add byte ptr [bx + si], al
  018E5C  0000             add byte ptr [bx + si], al
  018E5E  0000             add byte ptr [bx + si], al
  018E60  0000             add byte ptr [bx + si], al
  018E62  0000             add byte ptr [bx + si], al
  018E64  0000             add byte ptr [bx + si], al
  018E66  0000             add byte ptr [bx + si], al
  018E68  0000             add byte ptr [bx + si], al
  018E6A  0000             add byte ptr [bx + si], al
  018E6C  0000             add byte ptr [bx + si], al
  018E6E  0000             add byte ptr [bx + si], al
  018E70  0000             add byte ptr [bx + si], al
  018E72  0000             add byte ptr [bx + si], al
  018E74  0000             add byte ptr [bx + si], al
  018E76  0000             add byte ptr [bx + si], al
  018E78  0000             add byte ptr [bx + si], al
  018E7A  0000             add byte ptr [bx + si], al
  018E7C  0000             add byte ptr [bx + si], al
  018E7E  0000             add byte ptr [bx + si], al
  018E80  0000             add byte ptr [bx + si], al
  018E82  0000             add byte ptr [bx + si], al
  018E84  0000             add byte ptr [bx + si], al
  018E86  0000             add byte ptr [bx + si], al
  018E88  0000             add byte ptr [bx + si], al
  018E8A  0000             add byte ptr [bx + si], al
  018E8C  0000             add byte ptr [bx + si], al
  018E8E  0000             add byte ptr [bx + si], al
  018E90  0000             add byte ptr [bx + si], al
  018E92  0000             add byte ptr [bx + si], al
  018E94  0000             add byte ptr [bx + si], al
  018E96  0000             add byte ptr [bx + si], al
  018E98  0000             add byte ptr [bx + si], al
  018E9A  0000             add byte ptr [bx + si], al
  018E9C  0000             add byte ptr [bx + si], al
  018E9E  0000             add byte ptr [bx + si], al
  018EA0  0000             add byte ptr [bx + si], al
  018EA2  0000             add byte ptr [bx + si], al
  018EA4  0000             add byte ptr [bx + si], al
  018EA6  0000             add byte ptr [bx + si], al
  018EA8  0000             add byte ptr [bx + si], al
  018EAA  0000             add byte ptr [bx + si], al
  018EAC  0000             add byte ptr [bx + si], al
  018EAE  0000             add byte ptr [bx + si], al
  018EB0  0000             add byte ptr [bx + si], al
  018EB2  0000             add byte ptr [bx + si], al
  018EB4  0000             add byte ptr [bx + si], al
  018EB6  0000             add byte ptr [bx + si], al
  018EB8  0000             add byte ptr [bx + si], al
  018EBA  0000             add byte ptr [bx + si], al
  018EBC  0000             add byte ptr [bx + si], al
  018EBE  0000             add byte ptr [bx + si], al
  018EC0  0000             add byte ptr [bx + si], al
  018EC2  0000             add byte ptr [bx + si], al
  018EC4  0000             add byte ptr [bx + si], al
  018EC6  0000             add byte ptr [bx + si], al
  018EC8  0000             add byte ptr [bx + si], al
  018ECA  0000             add byte ptr [bx + si], al
  018ECC  0000             add byte ptr [bx + si], al
  018ECE  0000             add byte ptr [bx + si], al
  018ED0  0000             add byte ptr [bx + si], al
  018ED2  0000             add byte ptr [bx + si], al
  018ED4  0000             add byte ptr [bx + si], al
  018ED6  0000             add byte ptr [bx + si], al
  018ED8  0000             add byte ptr [bx + si], al
  018EDA  0000             add byte ptr [bx + si], al
  018EDC  0000             add byte ptr [bx + si], al
  018EDE  0000             add byte ptr [bx + si], al
  018EE0  0000             add byte ptr [bx + si], al
  018EE2  0000             add byte ptr [bx + si], al
  018EE4  0000             add byte ptr [bx + si], al
  018EE6  0000             add byte ptr [bx + si], al
  018EE8  0000             add byte ptr [bx + si], al
  018EEA  0000             add byte ptr [bx + si], al
  018EEC  0000             add byte ptr [bx + si], al
  018EEE  0000             add byte ptr [bx + si], al
  018EF0  0000             add byte ptr [bx + si], al
  018EF2  0000             add byte ptr [bx + si], al
  018EF4  0000             add byte ptr [bx + si], al
  018EF6  0000             add byte ptr [bx + si], al
  018EF8  0000             add byte ptr [bx + si], al
  018EFA  0000             add byte ptr [bx + si], al
  018EFC  0000             add byte ptr [bx + si], al
  018EFE  0000             add byte ptr [bx + si], al
  018F00  0000             add byte ptr [bx + si], al
  018F02  0000             add byte ptr [bx + si], al
  018F04  0000             add byte ptr [bx + si], al
  018F06  0000             add byte ptr [bx + si], al
  018F08  0000             add byte ptr [bx + si], al
  018F0A  0000             add byte ptr [bx + si], al
  018F0C  0000             add byte ptr [bx + si], al
  018F0E  0000             add byte ptr [bx + si], al
  018F10  0000             add byte ptr [bx + si], al
  018F12  0000             add byte ptr [bx + si], al
  018F14  0000             add byte ptr [bx + si], al
  018F16  0000             add byte ptr [bx + si], al
  018F18  0000             add byte ptr [bx + si], al
  018F1A  0000             add byte ptr [bx + si], al
  018F1C  0000             add byte ptr [bx + si], al
  018F1E  0000             add byte ptr [bx + si], al
  018F20  0000             add byte ptr [bx + si], al
  018F22  0000             add byte ptr [bx + si], al
  018F24  0000             add byte ptr [bx + si], al
  018F26  0000             add byte ptr [bx + si], al
  018F28  0000             add byte ptr [bx + si], al
  018F2A  0000             add byte ptr [bx + si], al
  018F2C  0000             add byte ptr [bx + si], al
  018F2E  0000             add byte ptr [bx + si], al
  018F30  0000             add byte ptr [bx + si], al
  018F32  0000             add byte ptr [bx + si], al
  018F34  0000             add byte ptr [bx + si], al
  018F36  0000             add byte ptr [bx + si], al
  018F38  0000             add byte ptr [bx + si], al
  018F3A  0000             add byte ptr [bx + si], al
  018F3C  0000             add byte ptr [bx + si], al
  018F3E  0000             add byte ptr [bx + si], al
  018F40  0000             add byte ptr [bx + si], al
  018F42  0000             add byte ptr [bx + si], al
  018F44  0000             add byte ptr [bx + si], al
  018F46  0000             add byte ptr [bx + si], al
  018F48  0000             add byte ptr [bx + si], al
  018F4A  0000             add byte ptr [bx + si], al
  018F4C  0000             add byte ptr [bx + si], al
  018F4E  0000             add byte ptr [bx + si], al
  018F50  0000             add byte ptr [bx + si], al
  018F52  0000             add byte ptr [bx + si], al
  018F54  0000             add byte ptr [bx + si], al
  018F56  0000             add byte ptr [bx + si], al
  018F58  0000             add byte ptr [bx + si], al
  018F5A  0000             add byte ptr [bx + si], al
  018F5C  0000             add byte ptr [bx + si], al
  018F5E  0000             add byte ptr [bx + si], al
  018F60  0000             add byte ptr [bx + si], al
  018F62  0000             add byte ptr [bx + si], al
  018F64  0000             add byte ptr [bx + si], al
  018F66  0000             add byte ptr [bx + si], al
  018F68  0000             add byte ptr [bx + si], al
  018F6A  0000             add byte ptr [bx + si], al
  018F6C  0000             add byte ptr [bx + si], al
  018F6E  0000             add byte ptr [bx + si], al
  018F70  0000             add byte ptr [bx + si], al
  018F72  0000             add byte ptr [bx + si], al
  018F74  0000             add byte ptr [bx + si], al
  018F76  0000             add byte ptr [bx + si], al
  018F78  0000             add byte ptr [bx + si], al
  018F7A  0000             add byte ptr [bx + si], al
  018F7C  0000             add byte ptr [bx + si], al
  018F7E  0000             add byte ptr [bx + si], al
  018F80  0000             add byte ptr [bx + si], al
  018F82  0000             add byte ptr [bx + si], al
  018F84  0000             add byte ptr [bx + si], al
  018F86  0000             add byte ptr [bx + si], al
  018F88  0000             add byte ptr [bx + si], al
  018F8A  0000             add byte ptr [bx + si], al
  018F8C  0000             add byte ptr [bx + si], al
  018F8E  0000             add byte ptr [bx + si], al
  018F90  0000             add byte ptr [bx + si], al
  018F92  0000             add byte ptr [bx + si], al
  018F94  0000             add byte ptr [bx + si], al
  018F96  0000             add byte ptr [bx + si], al
  018F98  0000             add byte ptr [bx + si], al
  018F9A  0000             add byte ptr [bx + si], al
  018F9C  0000             add byte ptr [bx + si], al
  018F9E  0000             add byte ptr [bx + si], al
  018FA0  0000             add byte ptr [bx + si], al
  018FA2  0000             add byte ptr [bx + si], al
  018FA4  0000             add byte ptr [bx + si], al
  018FA6  0000             add byte ptr [bx + si], al
  018FA8  0000             add byte ptr [bx + si], al
  018FAA  0000             add byte ptr [bx + si], al
  018FAC  0000             add byte ptr [bx + si], al
  018FAE  0000             add byte ptr [bx + si], al
  018FB0  0000             add byte ptr [bx + si], al
  018FB2  0000             add byte ptr [bx + si], al
  018FB4  0000             add byte ptr [bx + si], al
  018FB6  0000             add byte ptr [bx + si], al
  018FB8  0000             add byte ptr [bx + si], al
  018FBA  0000             add byte ptr [bx + si], al
  018FBC  0000             add byte ptr [bx + si], al
  018FBE  0000             add byte ptr [bx + si], al
  018FC0  0000             add byte ptr [bx + si], al
  018FC2  0000             add byte ptr [bx + si], al
  018FC4  0000             add byte ptr [bx + si], al
  018FC6  0000             add byte ptr [bx + si], al
  018FC8  0000             add byte ptr [bx + si], al
  018FCA  0000             add byte ptr [bx + si], al
  018FCC  0000             add byte ptr [bx + si], al
  018FCE  0000             add byte ptr [bx + si], al
  018FD0  0000             add byte ptr [bx + si], al
  018FD2  0000             add byte ptr [bx + si], al
  018FD4  0000             add byte ptr [bx + si], al
  018FD6  0000             add byte ptr [bx + si], al
  018FD8  0000             add byte ptr [bx + si], al
  018FDA  0000             add byte ptr [bx + si], al
  018FDC  0000             add byte ptr [bx + si], al
  018FDE  0000             add byte ptr [bx + si], al
  018FE0  0000             add byte ptr [bx + si], al
  018FE2  0000             add byte ptr [bx + si], al
  018FE4  0000             add byte ptr [bx + si], al
  018FE6  0000             add byte ptr [bx + si], al
  018FE8  0000             add byte ptr [bx + si], al
  018FEA  0000             add byte ptr [bx + si], al
  018FEC  0000             add byte ptr [bx + si], al
  018FEE  0000             add byte ptr [bx + si], al
  018FF0  0000             add byte ptr [bx + si], al
  018FF2  0000             add byte ptr [bx + si], al
  018FF4  0000             add byte ptr [bx + si], al
  018FF6  0000             add byte ptr [bx + si], al
  018FF8  0000             add byte ptr [bx + si], al
  018FFA  0000             add byte ptr [bx + si], al
  018FFC  0000             add byte ptr [bx + si], al
  018FFE  0000             add byte ptr [bx + si], al
  019000  0000             add byte ptr [bx + si], al
  019002  0000             add byte ptr [bx + si], al
  019004  0000             add byte ptr [bx + si], al
  019006  0000             add byte ptr [bx + si], al
  019008  0000             add byte ptr [bx + si], al
  01900A  0000             add byte ptr [bx + si], al
  01900C  0000             add byte ptr [bx + si], al
  01900E  0000             add byte ptr [bx + si], al
  019010  0000             add byte ptr [bx + si], al
  019012  0000             add byte ptr [bx + si], al
  019014  0000             add byte ptr [bx + si], al
  019016  0000             add byte ptr [bx + si], al
  019018  0000             add byte ptr [bx + si], al
  01901A  0000             add byte ptr [bx + si], al
  01901C  0000             add byte ptr [bx + si], al
  01901E  0000             add byte ptr [bx + si], al
  019020  0000             add byte ptr [bx + si], al
  019022  0000             add byte ptr [bx + si], al
  019024  0000             add byte ptr [bx + si], al
  019026  0000             add byte ptr [bx + si], al
  019028  0000             add byte ptr [bx + si], al
  01902A  0000             add byte ptr [bx + si], al
  01902C  0000             add byte ptr [bx + si], al
  01902E  0000             add byte ptr [bx + si], al
  019030  0000             add byte ptr [bx + si], al
  019032  0000             add byte ptr [bx + si], al
  019034  0000             add byte ptr [bx + si], al
  019036  0000             add byte ptr [bx + si], al
  019038  0000             add byte ptr [bx + si], al
  01903A  0000             add byte ptr [bx + si], al
  01903C  0000             add byte ptr [bx + si], al
  01903E  0000             add byte ptr [bx + si], al
  019040  0000             add byte ptr [bx + si], al
  019042  0000             add byte ptr [bx + si], al
  019044  0000             add byte ptr [bx + si], al
  019046  0000             add byte ptr [bx + si], al
  019048  0000             add byte ptr [bx + si], al
  01904A  0000             add byte ptr [bx + si], al
  01904C  0000             add byte ptr [bx + si], al
  01904E  0000             add byte ptr [bx + si], al
  019050  0000             add byte ptr [bx + si], al
  019052  0000             add byte ptr [bx + si], al
  019054  0000             add byte ptr [bx + si], al
  019056  0000             add byte ptr [bx + si], al
  019058  0000             add byte ptr [bx + si], al
  01905A  0000             add byte ptr [bx + si], al
  01905C  0000             add byte ptr [bx + si], al
  01905E  0000             add byte ptr [bx + si], al
  019060  0000             add byte ptr [bx + si], al
  019062  0000             add byte ptr [bx + si], al
  019064  0000             add byte ptr [bx + si], al
  019066  0000             add byte ptr [bx + si], al
  019068  0000             add byte ptr [bx + si], al
  01906A  0000             add byte ptr [bx + si], al
  01906C  0000             add byte ptr [bx + si], al
  01906E  0000             add byte ptr [bx + si], al
  019070  0000             add byte ptr [bx + si], al
  019072  0000             add byte ptr [bx + si], al
  019074  0000             add byte ptr [bx + si], al
  019076  0000             add byte ptr [bx + si], al
  019078  0000             add byte ptr [bx + si], al
  01907A  0000             add byte ptr [bx + si], al
  01907C  0000             add byte ptr [bx + si], al
  01907E  0000             add byte ptr [bx + si], al
  019080  0000             add byte ptr [bx + si], al
  019082  0000             add byte ptr [bx + si], al
  019084  0000             add byte ptr [bx + si], al
  019086  0000             add byte ptr [bx + si], al
  019088  0000             add byte ptr [bx + si], al
  01908A  0000             add byte ptr [bx + si], al
  01908C  0000             add byte ptr [bx + si], al
  01908E  0000             add byte ptr [bx + si], al
  019090  0000             add byte ptr [bx + si], al
  019092  0000             add byte ptr [bx + si], al
  019094  0000             add byte ptr [bx + si], al
  019096  0000             add byte ptr [bx + si], al
  019098  0000             add byte ptr [bx + si], al
  01909A  0000             add byte ptr [bx + si], al
  01909C  0000             add byte ptr [bx + si], al
  01909E  0000             add byte ptr [bx + si], al
  0190A0  0000             add byte ptr [bx + si], al
  0190A2  0000             add byte ptr [bx + si], al
  0190A4  0000             add byte ptr [bx + si], al
  0190A6  0000             add byte ptr [bx + si], al
  0190A8  0000             add byte ptr [bx + si], al
  0190AA  0000             add byte ptr [bx + si], al
  0190AC  0000             add byte ptr [bx + si], al
  0190AE  0000             add byte ptr [bx + si], al
  0190B0  0000             add byte ptr [bx + si], al
  0190B2  0000             add byte ptr [bx + si], al
  0190B4  0000             add byte ptr [bx + si], al
  0190B6  0000             add byte ptr [bx + si], al
  0190B8  0000             add byte ptr [bx + si], al
  0190BA  0000             add byte ptr [bx + si], al
  0190BC  0000             add byte ptr [bx + si], al
  0190BE  0000             add byte ptr [bx + si], al
  0190C0  0000             add byte ptr [bx + si], al
  0190C2  0000             add byte ptr [bx + si], al
  0190C4  0000             add byte ptr [bx + si], al
  0190C6  0000             add byte ptr [bx + si], al
  0190C8  0000             add byte ptr [bx + si], al
  0190CA  0000             add byte ptr [bx + si], al
  0190CC  0000             add byte ptr [bx + si], al
  0190CE  0000             add byte ptr [bx + si], al
  0190D0  0000             add byte ptr [bx + si], al
  0190D2  0000             add byte ptr [bx + si], al
  0190D4  0000             add byte ptr [bx + si], al
  0190D6  0000             add byte ptr [bx + si], al
  0190D8  0000             add byte ptr [bx + si], al
  0190DA  0000             add byte ptr [bx + si], al
  0190DC  0000             add byte ptr [bx + si], al
  0190DE  0000             add byte ptr [bx + si], al
  0190E0  0000             add byte ptr [bx + si], al
  0190E2  0000             add byte ptr [bx + si], al
  0190E4  0000             add byte ptr [bx + si], al
  0190E6  0000             add byte ptr [bx + si], al
  0190E8  0000             add byte ptr [bx + si], al
  0190EA  0000             add byte ptr [bx + si], al
  0190EC  0000             add byte ptr [bx + si], al
  0190EE  0000             add byte ptr [bx + si], al
  0190F0  0000             add byte ptr [bx + si], al
  0190F2  0000             add byte ptr [bx + si], al
  0190F4  0000             add byte ptr [bx + si], al
  0190F6  0000             add byte ptr [bx + si], al
  0190F8  0000             add byte ptr [bx + si], al
  0190FA  0000             add byte ptr [bx + si], al
  0190FC  0000             add byte ptr [bx + si], al
  0190FE  0000             add byte ptr [bx + si], al
  019100  0000             add byte ptr [bx + si], al
  019102  0000             add byte ptr [bx + si], al
  019104  0000             add byte ptr [bx + si], al
  019106  0000             add byte ptr [bx + si], al
  019108  0000             add byte ptr [bx + si], al
  01910A  0000             add byte ptr [bx + si], al
  01910C  0000             add byte ptr [bx + si], al
  01910E  0000             add byte ptr [bx + si], al
  019110  0000             add byte ptr [bx + si], al
  019112  0000             add byte ptr [bx + si], al
  019114  0000             add byte ptr [bx + si], al
  019116  0000             add byte ptr [bx + si], al
  019118  0000             add byte ptr [bx + si], al
  01911A  0000             add byte ptr [bx + si], al
  01911C  0000             add byte ptr [bx + si], al
  01911E  0000             add byte ptr [bx + si], al
  019120  0000             add byte ptr [bx + si], al
  019122  0000             add byte ptr [bx + si], al
  019124  0000             add byte ptr [bx + si], al
  019126  0000             add byte ptr [bx + si], al
  019128  0000             add byte ptr [bx + si], al
  01912A  0000             add byte ptr [bx + si], al
  01912C  0000             add byte ptr [bx + si], al
  01912E  0000             add byte ptr [bx + si], al
  019130  0000             add byte ptr [bx + si], al
  019132  0000             add byte ptr [bx + si], al
  019134  0000             add byte ptr [bx + si], al
  019136  0000             add byte ptr [bx + si], al
  019138  0000             add byte ptr [bx + si], al
  01913A  0000             add byte ptr [bx + si], al
  01913C  0000             add byte ptr [bx + si], al
  01913E  0000             add byte ptr [bx + si], al
  019140  0000             add byte ptr [bx + si], al
  019142  0000             add byte ptr [bx + si], al
  019144  0000             add byte ptr [bx + si], al
  019146  0000             add byte ptr [bx + si], al
  019148  0000             add byte ptr [bx + si], al
  01914A  0000             add byte ptr [bx + si], al
  01914C  0000             add byte ptr [bx + si], al
  01914E  0000             add byte ptr [bx + si], al
  019150  0000             add byte ptr [bx + si], al
  019152  0000             add byte ptr [bx + si], al
  019154  0000             add byte ptr [bx + si], al
  019156  0000             add byte ptr [bx + si], al
  019158  0000             add byte ptr [bx + si], al
  01915A  0000             add byte ptr [bx + si], al
  01915C  0000             add byte ptr [bx + si], al
  01915E  0000             add byte ptr [bx + si], al
  019160  0000             add byte ptr [bx + si], al
  019162  0000             add byte ptr [bx + si], al
  019164  0000             add byte ptr [bx + si], al
  019166  0000             add byte ptr [bx + si], al
  019168  0000             add byte ptr [bx + si], al
  01916A  0000             add byte ptr [bx + si], al
  01916C  0000             add byte ptr [bx + si], al
  01916E  0000             add byte ptr [bx + si], al
  019170  0000             add byte ptr [bx + si], al
  019172  0000             add byte ptr [bx + si], al
  019174  0000             add byte ptr [bx + si], al
  019176  0000             add byte ptr [bx + si], al
  019178  0000             add byte ptr [bx + si], al
  01917A  0000             add byte ptr [bx + si], al
  01917C  0000             add byte ptr [bx + si], al
  01917E  0000             add byte ptr [bx + si], al
  019180  0000             add byte ptr [bx + si], al
  019182  0000             add byte ptr [bx + si], al
  019184  0000             add byte ptr [bx + si], al
  019186  0000             add byte ptr [bx + si], al
  019188  0000             add byte ptr [bx + si], al
  01918A  0000             add byte ptr [bx + si], al
  01918C  0000             add byte ptr [bx + si], al
  01918E  0000             add byte ptr [bx + si], al
  019190  0000             add byte ptr [bx + si], al
  019192  0000             add byte ptr [bx + si], al
  019194  0000             add byte ptr [bx + si], al
  019196  0000             add byte ptr [bx + si], al
  019198  0000             add byte ptr [bx + si], al
  01919A  0000             add byte ptr [bx + si], al
  01919C  0000             add byte ptr [bx + si], al
  01919E  0000             add byte ptr [bx + si], al
  0191A0  0000             add byte ptr [bx + si], al
  0191A2  0000             add byte ptr [bx + si], al
  0191A4  0000             add byte ptr [bx + si], al
  0191A6  0000             add byte ptr [bx + si], al
  0191A8  0000             add byte ptr [bx + si], al
  0191AA  0000             add byte ptr [bx + si], al
  0191AC  0000             add byte ptr [bx + si], al
  0191AE  0000             add byte ptr [bx + si], al
  0191B0  0000             add byte ptr [bx + si], al
  0191B2  0000             add byte ptr [bx + si], al
  0191B4  0000             add byte ptr [bx + si], al
  0191B6  0000             add byte ptr [bx + si], al
  0191B8  0000             add byte ptr [bx + si], al
  0191BA  0000             add byte ptr [bx + si], al
  0191BC  0000             add byte ptr [bx + si], al
  0191BE  0000             add byte ptr [bx + si], al
  0191C0  0000             add byte ptr [bx + si], al
  0191C2  0000             add byte ptr [bx + si], al
  0191C4  0000             add byte ptr [bx + si], al
  0191C6  0000             add byte ptr [bx + si], al
  0191C8  0000             add byte ptr [bx + si], al
  0191CA  0000             add byte ptr [bx + si], al
  0191CC  0000             add byte ptr [bx + si], al
  0191CE  0000             add byte ptr [bx + si], al
  0191D0  0000             add byte ptr [bx + si], al
  0191D2  0000             add byte ptr [bx + si], al
  0191D4  0000             add byte ptr [bx + si], al
  0191D6  0000             add byte ptr [bx + si], al
  0191D8  0000             add byte ptr [bx + si], al
  0191DA  0000             add byte ptr [bx + si], al
  0191DC  0000             add byte ptr [bx + si], al
  0191DE  0000             add byte ptr [bx + si], al
  0191E0  0000             add byte ptr [bx + si], al
  0191E2  0000             add byte ptr [bx + si], al
  0191E4  0000             add byte ptr [bx + si], al
  0191E6  0000             add byte ptr [bx + si], al
  0191E8  0000             add byte ptr [bx + si], al
  0191EA  0000             add byte ptr [bx + si], al
  0191EC  0000             add byte ptr [bx + si], al
  0191EE  0000             add byte ptr [bx + si], al
  0191F0  0000             add byte ptr [bx + si], al
  0191F2  0000             add byte ptr [bx + si], al
  0191F4  0000             add byte ptr [bx + si], al
  0191F6  0000             add byte ptr [bx + si], al
  0191F8  0000             add byte ptr [bx + si], al
  0191FA  0000             add byte ptr [bx + si], al
  0191FC  0000             add byte ptr [bx + si], al
  0191FE  0000             add byte ptr [bx + si], al
  019200  0000             add byte ptr [bx + si], al
  019202  0000             add byte ptr [bx + si], al
  019204  0000             add byte ptr [bx + si], al
  019206  0000             add byte ptr [bx + si], al
  019208  0000             add byte ptr [bx + si], al
  01920A  0000             add byte ptr [bx + si], al
  01920C  0000             add byte ptr [bx + si], al
  01920E  0000             add byte ptr [bx + si], al
  019210  0000             add byte ptr [bx + si], al
  019212  0000             add byte ptr [bx + si], al
  019214  0000             add byte ptr [bx + si], al
  019216  0000             add byte ptr [bx + si], al
  019218  0000             add byte ptr [bx + si], al
  01921A  0000             add byte ptr [bx + si], al
  01921C  0000             add byte ptr [bx + si], al
  01921E  0000             add byte ptr [bx + si], al
  019220  0000             add byte ptr [bx + si], al
  019222  0000             add byte ptr [bx + si], al
  019224  0000             add byte ptr [bx + si], al
  019226  0000             add byte ptr [bx + si], al
  019228  0000             add byte ptr [bx + si], al
  01922A  0000             add byte ptr [bx + si], al
  01922C  0000             add byte ptr [bx + si], al
  01922E  0000             add byte ptr [bx + si], al
  019230  0000             add byte ptr [bx + si], al
  019232  0000             add byte ptr [bx + si], al
  019234  0000             add byte ptr [bx + si], al
  019236  0000             add byte ptr [bx + si], al
  019238  0000             add byte ptr [bx + si], al
  01923A  0000             add byte ptr [bx + si], al
  01923C  0000             add byte ptr [bx + si], al
  01923E  0000             add byte ptr [bx + si], al
  019240  0000             add byte ptr [bx + si], al
  019242  0000             add byte ptr [bx + si], al
  019244  0000             add byte ptr [bx + si], al
  019246  0000             add byte ptr [bx + si], al
  019248  0000             add byte ptr [bx + si], al
  01924A  0000             add byte ptr [bx + si], al
  01924C  0000             add byte ptr [bx + si], al
  01924E  0000             add byte ptr [bx + si], al
  019250  0000             add byte ptr [bx + si], al
  019252  0000             add byte ptr [bx + si], al
  019254  0000             add byte ptr [bx + si], al
  019256  0000             add byte ptr [bx + si], al
  019258  0000             add byte ptr [bx + si], al
  01925A  0000             add byte ptr [bx + si], al
  01925C  0000             add byte ptr [bx + si], al
  01925E  0000             add byte ptr [bx + si], al
  019260  0000             add byte ptr [bx + si], al
  019262  0000             add byte ptr [bx + si], al
  019264  0000             add byte ptr [bx + si], al
  019266  0000             add byte ptr [bx + si], al
  019268  0000             add byte ptr [bx + si], al
  01926A  0000             add byte ptr [bx + si], al
  ; ...truncated
