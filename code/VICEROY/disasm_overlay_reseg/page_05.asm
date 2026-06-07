; ============================================================
; VICEROY.EXE overlay page 0x05 (record 4) -- RE-SEGMENTED
; file_offset (disk image) = 0x036990
; code_offset (first insn) = 0x037340
; code_end (next reloc hdr)= 0x03B380  [resident size 1028 para -> nominal_end 0x03A9D0; on-disk code spills past it]
; reloc_count = 608  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x036990)
; functions in page = 21
; ============================================================

; ---- func_037340  size=137  insns=47  prologue=ENTER 0x0352,0  terminal=RETF ----
  037340  09B0: c8520300         enter 0x352, 0
  037344  09B4: 68a211           push 0x11a2
  037347  09B7: 8d46b0           lea ax, [bp - 0x50]
  03734A  09BA: 50               push ax
  03734B  09BB: 9ae4071d0d       lcall 0xd1d, 0x7e4
  037350  09C0: 83c404           add sp, 4
  037353  09C3: ff7606           push word ptr [bp + 6]
  037356  09C6: 8d46b0           lea ax, [bp - 0x50]
  037359  09C9: 16               push ss
  03735A  09CA: 50               push ax
  03735B  09CB: 9a82011f18       lcall 0x181f, 0x182
  037360  09D0: 83c406           add sp, 6
  037363  09D3: 8d86aefc         lea ax, [bp - 0x352]
  037367  09D7: 16               push ss
  037368  09D8: 50               push ax
  037369  09D9: 6a00             push 0
  03736B  09DB: ff36ae2d         push word ptr [0x2dae]
  03736F  09DF: ff36ac2d         push word ptr [0x2dac]
  037373  09E3: ff36aa2d         push word ptr [0x2daa]
  037377  09E7: ff36a82d         push word ptr [0x2da8]
  03737B  09EB: 8d46b0           lea ax, [bp - 0x50]
  03737E  09EE: 50               push ax
  03737F  09EF: 9a4e041f18       lcall 0x181f, 0x44e
  037384  09F4: 83c410           add sp, 0x10
  037387  09F7: 0bc0             or ax, ax
  037389  09F9: 7419             je 0xa14
  03738B  09FB: ff36ae2d         push word ptr [0x2dae]
  03738F  09FF: ff36ac2d         push word ptr [0x2dac]
  037393  0A03: ff36aa2d         push word ptr [0x2daa]
  037397  0A07: ff36a82d         push word ptr [0x2da8]
  03739B  0A0B: b022             mov al, 0x22
  03739D  0A0D: 9a84041f18       lcall 0x181f, 0x484
  0373A2  0A12: c9               leave 
  0373A3  0A13: cb               retf 
  0373A4  0A14: a17203           mov ax, word ptr [0x372]
  0373A7  0A17: 8946ae           mov word ptr [bp - 0x52], ax
  0373AA  0A1A: c70672030000     mov word ptr [0x372], 0
  0373B0  0A20: 8d86aefc         lea ax, [bp - 0x352]
  0373B4  0A24: 16               push ss
  0373B5  0A25: 50               push ax
  0373B6  0A26: b89800           mov ax, 0x98
  0373B9  0A29: ba6400           mov dx, 0x64
  0373BC  0A2C: 9a22002e0c       lcall 0xc2e, 0x22
  0373C1  0A31: 8b46ae           mov ax, word ptr [bp - 0x52]
  0373C4  0A34: a37203           mov word ptr [0x372], ax
  0373C7  0A37: c9               leave 
  0373C8  0A38: cb               retf 

; ---- func_0373CA  size=128  insns=43  prologue=push bp;mov bp,sp  terminal=RETF ----
  0373CA  0A3A: 55               push bp
  0373CB  0A3B: 8bec             mov bp, sp
  0373CD  0A3D: 837e0800         cmp word ptr [bp + 8], 0
  0373D1  0A41: 7d05             jge 0xa48
  0373D3  0A43: c74608b800       mov word ptr [bp + 8], 0xb8
  0373D8  0A48: 837e06ff         cmp word ptr [bp + 6], -1
  0373DC  0A4C: 7505             jne 0xa53
  0373DE  0A4E: c746069100       mov word ptr [bp + 6], 0x91
  0373E3  0A53: 837e06fe         cmp word ptr [bp + 6], -2
  0373E7  0A57: 7505             jne 0xa5e
  0373E9  0A59: c746061e01       mov word ptr [bp + 6], 0x11e
  0373EE  0A5E: ff36ae2d         push word ptr [0x2dae]
  0373F2  0A62: ff36ac2d         push word ptr [0x2dac]
  0373F6  0A66: ff36aa2d         push word ptr [0x2daa]
  0373FA  0A6A: ff36a82d         push word ptr [0x2da8]
  0373FE  0A6E: 8b4608           mov ax, word ptr [bp + 8]
  037401  0A71: 050d00           add ax, 0xd
  037404  0A74: 50               push ax
  037405  0A75: 6a77             push 0x77
  037407  0A77: 8b4606           mov ax, word ptr [bp + 6]
  03740A  0A7A: 8bd8             mov bx, ax
  03740C  0A7C: 83c31d           add bx, 0x1d
  03740F  0A7F: 8b5608           mov dx, word ptr [bp + 8]
  037412  0A82: 9ace001f18       lcall 0x181f, 0xce
  037417  0A87: c41e9e08         les bx, ptr [0x89e]
  03741B  0A8B: 268a07           mov al, byte ptr es:[bx]
  03741E  0A8E: d0e8             shr al, 1
  037420  0A90: 2ae4             sub ah, ah
  037422  0A92: 2d0700           sub ax, 7
  037425  0A95: f7d8             neg ax
  037427  0A97: 014608           add word ptr [bp + 8], ax
  03742A  0A9A: 689200           push 0x92
  03742D  0A9D: ff7608           push word ptr [bp + 8]
  037430  0AA0: 6a1e             push 0x1e
  037432  0AA2: ff7606           push word ptr [bp + 6]
  037435  0AA5: ff36162e         push word ptr [0x2e16]
  037439  0AA9: 9a22001f18       lcall 0x181f, 0x22
  03743E  0AAE: 83c402           add sp, 2
  037441  0AB1: 52               push dx
  037442  0AB2: 50               push ax
  037443  0AB3: 9a00011f18       lcall 0x181f, 0x100
  037448  0AB8: c9               leave 
  037449  0AB9: cb               retf 

; ---- func_03744A  size=1294  insns=469  prologue=ENTER 0x006E,0  terminal=RETF ----
  03744A  0ABA: c86e0000         enter 0x6e, 0
  03744E  0ABE: 57               push di
  03744F  0ABF: 56               push si
  037450  0AC0: 6a01             push 1
  037452  0AC2: 0e               push cs
  037453  0AC3: e8fd29           call 0x34c3
  037456  0AC6: 83c402           add sp, 2
  037459  0AC9: 689000           push 0x90
  03745C  0ACC: 6a05             push 5
  03745E  0ACE: 684001           push 0x140
  037461  0AD1: 6a00             push 0
  037463  0AD3: ff36f42d         push word ptr [0x2df4]
  037467  0AD7: 9a22001f18       lcall 0x181f, 0x22
  03746C  0ADC: 83c402           add sp, 2
  03746F  0ADF: 52               push dx
  037470  0AE0: 50               push ax
  037471  0AE1: 9a00011f18       lcall 0x181f, 0x100
  037476  0AE6: 83c40c           add sp, 0xc
  037479  0AE9: c746a60a00       mov word ptr [bp - 0x5a], 0xa
  03747E  0AEE: c746a41900       mov word ptr [bp - 0x5c], 0x19
  037483  0AF3: c7469c0000       mov word ptr [bp - 0x64], 0
  037488  0AF8: e9a303           jmp 0xe9e
  03748B  0AFB: 90               nop 
  03748C  0AFC: 8b5efe           mov bx, word ptr [bp - 2]
  03748F  0AFF: 8a874808         mov al, byte ptr [bx + 0x848]
  037493  0B03: 884692           mov byte ptr [bp - 0x6e], al
  037496  0B06: 83fb0a           cmp bx, 0xa
  037499  0B09: 7504             jne 0xb0f
  03749B  0B0B: c646920c         mov byte ptr [bp - 0x6e], 0xc
  03749F  0B0F: c646ae00         mov byte ptr [bp - 0x52], 0
  0374A3  0B13: 53               push bx
  0374A4  0B14: 9a1a0a1f18       lcall 0x181f, 0xa1a
  0374A9  0B19: 83c402           add sp, 2
  0374AC  0B1C: 50               push ax
  0374AD  0B1D: 8d46ae           lea ax, [bp - 0x52]
  0374B0  0B20: 50               push ax
  0374B1  0B21: 9a6e011f18       lcall 0x181f, 0x16e
  0374B6  0B26: 83c404           add sp, 4
  0374B9  0B29: 8d46ae           lea ax, [bp - 0x52]
  0374BC  0B2C: 50               push ax
  0374BD  0B2D: 9abe011f18       lcall 0x181f, 0x1be
  0374C2  0B32: 83c402           add sp, 2
  0374C5  0B35: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0374C9  0B39: f6470380         test byte ptr [bx + 3], 0x80
  0374CD  0B3D: 7449             je 0xb88
  0374CF  0B3F: ff36be2e         push word ptr [0x2ebe]
  0374D3  0B43: 8d46ae           lea ax, [bp - 0x52]
  0374D6  0B46: 50               push ax
  0374D7  0B47: 9a6e011f18       lcall 0x181f, 0x16e
  0374DC  0B4C: 83c404           add sp, 4
  0374DF  0B4F: 6a00             push 0
  0374E1  0B51: 8b4694           mov ax, word ptr [bp - 0x6c]
  0374E4  0B54: 40               inc ax
  0374E5  0B55: 50               push ax
  0374E6  0B56: ff7698           push word ptr [bp - 0x68]
  0374E9  0B59: 8d4eae           lea cx, [bp - 0x52]
  0374EC  0B5C: 16               push ss
  0374ED  0B5D: 51               push cx
  0374EE  0B5E: 8bf0             mov si, ax
  0374F0  0B60: 9a3c011f18       lcall 0x181f, 0x13c
  0374F5  0B65: 83c40a           add sp, 0xa
  0374F8  0B68: 6a00             push 0
  0374FA  0B6A: ff7694           push word ptr [bp - 0x6c]
  0374FD  0B6D: 8b4698           mov ax, word ptr [bp - 0x68]
  037500  0B70: 40               inc ax
  037501  0B71: 50               push ax
  037502  0B72: 8d4eae           lea cx, [bp - 0x52]
  037505  0B75: 16               push ss
  037506  0B76: 51               push cx
  037507  0B77: 8bf8             mov di, ax
  037509  0B79: 9a3c011f18       lcall 0x181f, 0x13c
  03750E  0B7E: 83c40a           add sp, 0xa
  037511  0B81: 6a00             push 0
  037513  0B83: 56               push si
  037514  0B84: 57               push di
  037515  0B85: eb37             jmp 0xbbe
  037517  0B87: 90               nop 
  037518  0B88: 6a00             push 0
  03751A  0B8A: ff7694           push word ptr [bp - 0x6c]
  03751D  0B8D: 8b4698           mov ax, word ptr [bp - 0x68]
  037520  0B90: 40               inc ax
  037521  0B91: 50               push ax
  037522  0B92: 8d4eae           lea cx, [bp - 0x52]
  037525  0B95: 16               push ss
  037526  0B96: 51               push cx
  037527  0B97: 8bf0             mov si, ax
  037529  0B99: 9a3c011f18       lcall 0x181f, 0x13c
  03752E  0B9E: 83c40a           add sp, 0xa
  037531  0BA1: 6a00             push 0
  037533  0BA3: 8b4694           mov ax, word ptr [bp - 0x6c]
  037536  0BA6: 40               inc ax
  037537  0BA7: 50               push ax
  037538  0BA8: ff7698           push word ptr [bp - 0x68]
  03753B  0BAB: 8d4eae           lea cx, [bp - 0x52]
  03753E  0BAE: 16               push ss
  03753F  0BAF: 51               push cx
  037540  0BB0: 8bf8             mov di, ax
  037542  0BB2: 9a3c011f18       lcall 0x181f, 0x13c
  037547  0BB7: 83c40a           add sp, 0xa
  03754A  0BBA: 6a00             push 0
  03754C  0BBC: 57               push di
  03754D  0BBD: 56               push si
  03754E  0BBE: 8d46ae           lea ax, [bp - 0x52]
  037551  0BC1: 16               push ss
  037552  0BC2: 50               push ax
  037553  0BC3: 9a3c011f18       lcall 0x181f, 0x13c
  037558  0BC8: 83c40a           add sp, 0xa
  03755B  0BCB: 8a4692           mov al, byte ptr [bp - 0x6e]
  03755E  0BCE: 2ae4             sub ah, ah
  037560  0BD0: 50               push ax
  037561  0BD1: ff7694           push word ptr [bp - 0x6c]
  037564  0BD4: ff7698           push word ptr [bp - 0x68]
  037567  0BD7: 8d46ae           lea ax, [bp - 0x52]
  03756A  0BDA: 16               push ss
  03756B  0BDB: 50               push ax
  03756C  0BDC: 9a3c011f18       lcall 0x181f, 0x13c
  037571  0BE1: 83c40a           add sp, 0xa
  037574  0BE4: 894698           mov word ptr [bp - 0x68], ax
  037577  0BE7: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  03757B  0BEB: f6470380         test byte ptr [bx + 3], 0x80
  03757F  0BEF: 7403             je 0xbf4
  037581  0BF1: e9a302           jmp 0xe97
  037584  0BF4: c646ae00         mov byte ptr [bp - 0x52], 0
  037588  0BF8: 8a5f02           mov bl, byte ptr [bx + 2]
  03758B  0BFB: 2aff             sub bh, bh
  03758D  0BFD: 8bc3             mov ax, bx
  03758F  0BFF: d1e3             shl bx, 1
  037591  0C01: 03d8             add bx, ax
  037593  0C03: d1e3             shl bx, 1
  037595  0C05: ffb73296         push word ptr [bx - 0x69ce]
  037599  0C09: 8d46ae           lea ax, [bp - 0x52]
  03759C  0C0C: 50               push ax
  03759D  0C0D: 9a6e011f18       lcall 0x181f, 0x16e
  0375A2  0C12: 83c404           add sp, 4
  0375A5  0C15: 6a00             push 0
  0375A7  0C17: ff7694           push word ptr [bp - 0x6c]
  0375AA  0C1A: 8d46ae           lea ax, [bp - 0x52]
  0375AD  0C1D: 16               push ss
  0375AE  0C1E: 50               push ax
  0375AF  0C1F: 9a14011f18       lcall 0x181f, 0x114
  0375B4  0C24: 83c404           add sp, 4
  0375B7  0C27: 2d3601           sub ax, 0x136
  0375BA  0C2A: f7d8             neg ax
  0375BC  0C2C: 894698           mov word ptr [bp - 0x68], ax
  0375BF  0C2F: 40               inc ax
  0375C0  0C30: 50               push ax
  0375C1  0C31: 8d4eae           lea cx, [bp - 0x52]
  0375C4  0C34: 16               push ss
  0375C5  0C35: 51               push cx
  0375C6  0C36: 8bf0             mov si, ax
  0375C8  0C38: 9a3c011f18       lcall 0x181f, 0x13c
  0375CD  0C3D: 83c40a           add sp, 0xa
  0375D0  0C40: 6a00             push 0
  0375D2  0C42: 8b4694           mov ax, word ptr [bp - 0x6c]
  0375D5  0C45: 40               inc ax
  0375D6  0C46: 50               push ax
  0375D7  0C47: ff7698           push word ptr [bp - 0x68]
  0375DA  0C4A: 8d4eae           lea cx, [bp - 0x52]
  0375DD  0C4D: 16               push ss
  0375DE  0C4E: 51               push cx
  0375DF  0C4F: 8bf8             mov di, ax
  0375E1  0C51: 9a3c011f18       lcall 0x181f, 0x13c
  0375E6  0C56: 83c40a           add sp, 0xa
  0375E9  0C59: 6a00             push 0
  0375EB  0C5B: 57               push di
  0375EC  0C5C: 56               push si
  0375ED  0C5D: 8d46ae           lea ax, [bp - 0x52]
  0375F0  0C60: 16               push ss
  0375F1  0C61: 50               push ax
  0375F2  0C62: 9a3c011f18       lcall 0x181f, 0x13c
  0375F7  0C67: 83c40a           add sp, 0xa
  0375FA  0C6A: 8a4692           mov al, byte ptr [bp - 0x6e]
  0375FD  0C6D: 2ae4             sub ah, ah
  0375FF  0C6F: 50               push ax
  037600  0C70: ff7694           push word ptr [bp - 0x6c]
  037603  0C73: ff7698           push word ptr [bp - 0x68]
  037606  0C76: 8d46ae           lea ax, [bp - 0x52]
  037609  0C79: 16               push ss
  03760A  0C7A: 50               push ax
  03760B  0C7B: 9a3c011f18       lcall 0x181f, 0x13c
  037610  0C80: 83c40a           add sp, 0xa
  037613  0C83: 8b46a6           mov ax, word ptr [bp - 0x5a]
  037616  0C86: 051e00           add ax, 0x1e
  037619  0C89: 894698           mov word ptr [bp - 0x68], ax
  03761C  0C8C: c41e9e08         les bx, ptr [0x89e]
  037620  0C90: 268a07           mov al, byte ptr es:[bx]
  037623  0C93: 2ae4             sub ah, ah
  037625  0C95: 40               inc ax
  037626  0C96: 40               inc ax
  037627  0C97: 014694           add word ptr [bp - 0x6c], ax
  03762A  0C9A: 2bc0             sub ax, ax
  03762C  0C9C: 8946a2           mov word ptr [bp - 0x5e], ax
  03762F  0C9F: 8946aa           mov word ptr [bp - 0x56], ax
  037632  0CA2: 8946a8           mov word ptr [bp - 0x58], ax
  037635  0CA5: eb2d             jmp 0xcd4
  037637  0CA7: 90               nop 
  037638  0CA8: 6bd812           imul bx, ax, 0x12
  03763B  0CAB: 8a4efe           mov cl, byte ptr [bp - 2]
  03763E  0CAE: 388fee54         cmp byte ptr [bx + 0x54ee], cl
  037642  0CB2: 751d             jne 0xcd1
  037644  0CB4: 50               push ax
  037645  0CB5: 9a4c0a1f18       lcall 0x181f, 0xa4c
  03764A  0CBA: 83c402           add sp, 2
  03764D  0CBD: ff46a2           inc word ptr [bp - 0x5e]
  037650  0CC0: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  037654  0CC4: 8a4705           mov al, byte ptr [bx + 5]
  037657  0CC7: 240f             and al, 0xf
  037659  0CC9: 3a4606           cmp al, byte ptr [bp + 6]
  03765C  0CCC: 7503             jne 0xcd1
  03765E  0CCE: ff46aa           inc word ptr [bp - 0x56]
  037661  0CD1: ff46a8           inc word ptr [bp - 0x58]
  037664  0CD4: 8b46a8           mov ax, word ptr [bp - 0x58]
  037667  0CD7: 39069a53         cmp word ptr [0x539a], ax
  03766B  0CDB: 7fcb             jg 0xca8
  03766D  0CDD: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  037671  0CE1: 8a4707           mov al, byte ptr [bx + 7]
  037674  0CE4: 98               cwde 
  037675  0CE5: 894696           mov word ptr [bp - 0x6a], ax
  037678  0CE8: c746a80000       mov word ptr [bp - 0x58], 0
  03767D  0CED: eb23             jmp 0xd12
  03767F  0CEF: 90               nop 
  037680  0CF0: 6bd81c           imul bx, ax, 0x1c
  037683  0CF3: 8a874731         mov al, byte ptr [bx + 0x3147]
  037687  0CF7: 240f             and al, 0xf
  037689  0CF9: 3a46fe           cmp al, byte ptr [bp - 2]
  03768C  0CFC: 7511             jne 0xd0f
  03768E  0CFE: 80bf463114       cmp byte ptr [bx + 0x3146], 0x14
  037693  0D03: 7407             je 0xd0c
  037695  0D05: 80bf463116       cmp byte ptr [bx + 0x3146], 0x16
  03769A  0D0A: 7503             jne 0xd0f
  03769C  0D0C: ff4696           inc word ptr [bp - 0x6a]
  03769F  0D0F: ff46a8           inc word ptr [bp - 0x58]
  0376A2  0D12: 8b46a8           mov ax, word ptr [bp - 0x58]
  0376A5  0D15: 39069c53         cmp word ptr [0x539c], ax
  0376A9  0D19: 7fd5             jg 0xcf0
  0376AB  0D1B: b83200           mov ax, 0x32
  0376AE  0D1E: f76e96           imul word ptr [bp - 0x6a]
  0376B1  0D21: 894696           mov word ptr [bp - 0x6a], ax
  0376B4  0D24: c646ae00         mov byte ptr [bp - 0x52], 0
  0376B8  0D28: ff76a2           push word ptr [bp - 0x5e]
  0376BB  0D2B: 8d46ae           lea ax, [bp - 0x52]
  0376BE  0D2E: 16               push ss
  0376BF  0D2F: 50               push ax
  0376C0  0D30: 9a82011f18       lcall 0x181f, 0x182
  0376C5  0D35: 83c406           add sp, 6
  0376C8  0D38: 8d46ae           lea ax, [bp - 0x52]
  0376CB  0D3B: 50               push ax
  0376CC  0D3C: 9a78011f18       lcall 0x181f, 0x178
  0376D1  0D41: 83c402           add sp, 2
  0376D4  0D44: 837ea201         cmp word ptr [bp - 0x5e], 1
  0376D8  0D48: 7518             jne 0xd62
  0376DA  0D4A: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0376DE  0D4E: 8a5f02           mov bl, byte ptr [bx + 2]
  0376E1  0D51: 2aff             sub bh, bh
  0376E3  0D53: 8bc3             mov ax, bx
  0376E5  0D55: d1e3             shl bx, 1
  0376E7  0D57: 03d8             add bx, ax
  0376E9  0D59: d1e3             shl bx, 1
  0376EB  0D5B: ffb73496         push word ptr [bx - 0x69cc]
  0376EF  0D5F: eb16             jmp 0xd77
  0376F1  0D61: 90               nop 
  0376F2  0D62: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0376F6  0D66: 8a5f02           mov bl, byte ptr [bx + 2]
  0376F9  0D69: 2aff             sub bh, bh
  0376FB  0D6B: 8bc3             mov ax, bx
  0376FD  0D6D: d1e3             shl bx, 1
  0376FF  0D6F: 03d8             add bx, ax
  037701  0D71: d1e3             shl bx, 1
  037703  0D73: ffb73696         push word ptr [bx - 0x69ca]
  037707  0D77: 8d46ae           lea ax, [bp - 0x52]
  03770A  0D7A: 50               push ax
  03770B  0D7B: 9a6e011f18       lcall 0x181f, 0x16e
  037710  0D80: 83c404           add sp, 4
  037713  0D83: 6a00             push 0
  037715  0D85: ff7694           push word ptr [bp - 0x6c]
  037718  0D88: ff7698           push word ptr [bp - 0x68]
  03771B  0D8B: 8d46ae           lea ax, [bp - 0x52]
  03771E  0D8E: 16               push ss
  03771F  0D8F: 50               push ax
  037720  0D90: 9a3c011f18       lcall 0x181f, 0x13c
  037725  0D95: 83c40a           add sp, 0xa
  037728  0D98: 83469838         add word ptr [bp - 0x68], 0x38
  03772C  0D9C: 837eaa00         cmp word ptr [bp - 0x56], 0
  037730  0DA0: 7451             je 0xdf3
  037732  0DA2: c646ae00         mov byte ptr [bp - 0x52], 0
  037736  0DA6: ff76aa           push word ptr [bp - 0x56]
  037739  0DA9: 8d46ae           lea ax, [bp - 0x52]
  03773C  0DAC: 16               push ss
  03773D  0DAD: 50               push ax
  03773E  0DAE: 9a82011f18       lcall 0x181f, 0x182
  037743  0DB3: 83c406           add sp, 6
  037746  0DB6: 8d46ae           lea ax, [bp - 0x52]
  037749  0DB9: 50               push ax
  03774A  0DBA: 9a78011f18       lcall 0x181f, 0x178
  03774F  0DBF: 83c402           add sp, 2
  037752  0DC2: 837eaa01         cmp word ptr [bp - 0x56], 1
  037756  0DC6: 7506             jne 0xdce
  037758  0DC8: ff36f02d         push word ptr [0x2df0]
  03775C  0DCC: eb04             jmp 0xdd2
  03775E  0DCE: ff36f22d         push word ptr [0x2df2]
  037762  0DD2: 8d46ae           lea ax, [bp - 0x52]
  037765  0DD5: 50               push ax
  037766  0DD6: 9a6e011f18       lcall 0x181f, 0x16e
  03776B  0DDB: 83c404           add sp, 4
  03776E  0DDE: 6a00             push 0
  037770  0DE0: ff7694           push word ptr [bp - 0x6c]
  037773  0DE3: ff7698           push word ptr [bp - 0x68]
  037776  0DE6: 8d46ae           lea ax, [bp - 0x52]
  037779  0DE9: 16               push ss
  03777A  0DEA: 50               push ax
  03777B  0DEB: 9a3c011f18       lcall 0x181f, 0x13c
  037780  0DF0: 83c40a           add sp, 0xa
  037783  0DF3: 83469838         add word ptr [bp - 0x68], 0x38
  037787  0DF7: 837e9600         cmp word ptr [bp - 0x6a], 0
  03778B  0DFB: 7445             je 0xe42
  03778D  0DFD: c646ae00         mov byte ptr [bp - 0x52], 0
  037791  0E01: ff7696           push word ptr [bp - 0x6a]
  037794  0E04: 8d46ae           lea ax, [bp - 0x52]
  037797  0E07: 16               push ss
  037798  0E08: 50               push ax
  037799  0E09: 9a82011f18       lcall 0x181f, 0x182
  03779E  0E0E: 83c406           add sp, 6
  0377A1  0E11: 8d46ae           lea ax, [bp - 0x52]
  0377A4  0E14: 50               push ax
  0377A5  0E15: 9a78011f18       lcall 0x181f, 0x178
  0377AA  0E1A: 83c402           add sp, 2
  0377AD  0E1D: ff36de97         push word ptr [0x97de]
  0377B1  0E21: 8d46ae           lea ax, [bp - 0x52]
  0377B4  0E24: 50               push ax
  0377B5  0E25: 9a6e011f18       lcall 0x181f, 0x16e
  0377BA  0E2A: 83c404           add sp, 4
  0377BD  0E2D: 6a00             push 0
  0377BF  0E2F: ff7694           push word ptr [bp - 0x6c]
  0377C2  0E32: ff7698           push word ptr [bp - 0x68]
  0377C5  0E35: 8d46ae           lea ax, [bp - 0x52]
  0377C8  0E38: 16               push ss
  0377C9  0E39: 50               push ax
  0377CA  0E3A: 9a3c011f18       lcall 0x181f, 0x13c
  0377CF  0E3F: 83c40a           add sp, 0xa
  0377D2  0E42: 83469838         add word ptr [bp - 0x68], 0x38
  0377D6  0E46: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0377DA  0E4A: 807f0800         cmp byte ptr [bx + 8], 0
  0377DE  0E4E: 7447             je 0xe97
  0377E0  0E50: c646ae00         mov byte ptr [bp - 0x52], 0
  0377E4  0E54: 8a4708           mov al, byte ptr [bx + 8]
  0377E7  0E57: 98               cwde 
  0377E8  0E58: 50               push ax
  0377E9  0E59: 8d46ae           lea ax, [bp - 0x52]
  0377EC  0E5C: 16               push ss
  0377ED  0E5D: 50               push ax
  0377EE  0E5E: 9a82011f18       lcall 0x181f, 0x182
  0377F3  0E63: 83c406           add sp, 6
  0377F6  0E66: 8d46ae           lea ax, [bp - 0x52]
  0377F9  0E69: 50               push ax
  0377FA  0E6A: 9a78011f18       lcall 0x181f, 0x178
  0377FF  0E6F: 83c402           add sp, 2
  037802  0E72: ff36142e         push word ptr [0x2e14]
  037806  0E76: 8d46ae           lea ax, [bp - 0x52]
  037809  0E79: 50               push ax
  03780A  0E7A: 9a6e011f18       lcall 0x181f, 0x16e
  03780F  0E7F: 83c404           add sp, 4
  037812  0E82: 6a00             push 0
  037814  0E84: ff7694           push word ptr [bp - 0x6c]
  037817  0E87: ff7698           push word ptr [bp - 0x68]
  03781A  0E8A: 8d46ae           lea ax, [bp - 0x52]
  03781D  0E8D: 16               push ss
  03781E  0E8E: 50               push ax
  03781F  0E8F: 9a3c011f18       lcall 0x181f, 0x13c
  037824  0E94: 83c40a           add sp, 0xa
  037827  0E97: 8346a415         add word ptr [bp - 0x5c], 0x15
  03782B  0E9B: ff469c           inc word ptr [bp - 0x64]
  03782E  0E9E: 837e9c08         cmp word ptr [bp - 0x64], 8
  037832  0EA2: 7c03             jl 0xea7
  037834  0EA4: e9fb00           jmp 0xfa2
  037837  0EA7: ff769c           push word ptr [bp - 0x64]
  03783A  0EAA: 9a420a1f18       lcall 0x181f, 0xa42
  03783F  0EAF: 83c402           add sp, 2
  037842  0EB2: a1508d           mov ax, word ptr [0x8d50]
  037845  0EB5: 8946fe           mov word ptr [bp - 2], ax
  037848  0EB8: 50               push ax
  037849  0EB9: ff7606           push word ptr [bp + 6]
  03784C  0EBC: 9a380a1f18       lcall 0x181f, 0xa38
  037851  0EC1: 83c404           add sp, 4
  037854  0EC4: a820             test al, 0x20
  037856  0EC6: 750a             jne 0xed2
  037858  0EC8: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  03785C  0ECC: f6470380         test byte ptr [bx + 3], 0x80
  037860  0ED0: 74c9             je 0xe9b
  037862  0ED2: 8b46a6           mov ax, word ptr [bp - 0x5a]
  037865  0ED5: 894698           mov word ptr [bp - 0x68], ax
  037868  0ED8: 8b46a4           mov ax, word ptr [bp - 0x5c]
  03786B  0EDB: 894694           mov word ptr [bp - 0x6c], ax
  03786E  0EDE: ff7606           push word ptr [bp + 6]
  037871  0EE1: ff769c           push word ptr [bp - 0x64]
  037874  0EE4: 9a0c031f18       lcall 0x181f, 0x30c
  037879  0EE9: 83c404           add sp, 4
  03787C  0EEC: 50               push ax
  03787D  0EED: 9a600a1f18       lcall 0x181f, 0xa60
  037882  0EF2: 83c402           add sp, 2
  037885  0EF5: 8946ac           mov word ptr [bp - 0x54], ax
  037888  0EF8: ff7606           push word ptr [bp + 6]
  03788B  0EFB: ff769c           push word ptr [bp - 0x64]
  03788E  0EFE: 9a0c031f18       lcall 0x181f, 0x30c
  037893  0F03: 83c404           add sp, 4
  037896  0F06: 6b4eac19         imul cx, word ptr [bp - 0x54], 0x19
  03789A  0F0A: 2bc1             sub ax, cx
  03789C  0F0C: b90500           mov cx, 5
  03789F  0F0F: 99               cdq 
  0378A0  0F10: f7f9             idiv cx
  0378A2  0F12: 89469e           mov word ptr [bp - 0x62], ax
  0378A5  0F15: 837eac00         cmp word ptr [bp - 0x54], 0
  0378A9  0F19: 7e09             jle 0xf24
  0378AB  0F1B: b80400           mov ax, 4
  0378AE  0F1E: 2b469e           sub ax, word ptr [bp - 0x62]
  0378B1  0F21: 89469e           mov word ptr [bp - 0x62], ax
  0378B4  0F24: 6a04             push 4
  0378B6  0F26: 6a00             push 0
  0378B8  0F28: 50               push ax
  0378B9  0F29: 9a5c031f18       lcall 0x181f, 0x35c
  0378BE  0F2E: 83c406           add sp, 6
  0378C1  0F31: 89469e           mov word ptr [bp - 0x62], ax
  0378C4  0F34: 8b46ac           mov ax, word ptr [bp - 0x54]
  0378C7  0F37: 8946a0           mov word ptr [bp - 0x60], ax
  0378CA  0F3A: c7469a0000       mov word ptr [bp - 0x66], 0
  0378CF  0F3F: ff76fe           push word ptr [bp - 2]
  0378D2  0F42: ff7606           push word ptr [bp + 6]
  0378D5  0F45: 9a380a1f18       lcall 0x181f, 0xa38
  0378DA  0F4A: 83c404           add sp, 4
  0378DD  0F4D: a840             test al, 0x40
  0378DF  0F4F: 750a             jne 0xf5b
  0378E1  0F51: c7469a0100       mov word ptr [bp - 0x66], 1
  0378E6  0F56: c746a00400       mov word ptr [bp - 0x60], 4
  0378EB  0F5B: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0378EF  0F5F: f6470380         test byte ptr [bx + 3], 0x80
  0378F3  0F63: 7405             je 0xf6a
  0378F5  0F65: c746ac0300       mov word ptr [bp - 0x54], 3
  0378FA  0F6A: ff364008         push word ptr [0x840]
  0378FE  0F6E: ff363e08         push word ptr [0x83e]
  037902  0F72: ff7694           push word ptr [bp - 0x6c]
  037905  0F75: 8b46ac           mov ax, word ptr [bp - 0x54]
  037908  0F78: 057200           add ax, 0x72
  03790B  0F7B: 8d1ea82d         lea bx, [0x2da8]
  03790F  0F7F: 8b5698           mov dx, word ptr [bp - 0x68]
  037912  0F82: 9a54021f18       lcall 0x181f, 0x254
  037917  0F87: 83469814         add word ptr [bp - 0x68], 0x14
  03791B  0F8B: 83469403         add word ptr [bp - 0x6c], 3
  03791F  0F8F: 837efe04         cmp word ptr [bp - 2], 4
  037923  0F93: 7d03             jge 0xf98
  037925  0F95: e964fb           jmp 0xafc
  037928  0F98: 8b5efe           mov bx, word ptr [bp - 2]
  03792B  0F9B: 8a874808         mov al, byte ptr [bx + 0x848]
  03792F  0F9F: e961fb           jmp 0xb03
  037932  0FA2: 6aff             push -1
  037934  0FA4: 6afe             push -2
  037936  0FA6: 0e               push cs
  037937  0FA7: e8f624           call 0x34a0
  03793A  0FAA: 83c404           add sp, 4
  03793D  0FAD: 6a00             push 0
  03793F  0FAF: 684001           push 0x140
  037942  0FB2: 68c800           push 0xc8
  037945  0FB5: 2bc0             sub ax, ax
  037947  0FB7: 99               cdq 
  037948  0FB8: 2bdb             sub bx, bx
  03794A  0FBA: 9ae2001f18       lcall 0x181f, 0xe2
  03794F  0FBF: 9ac0031f18       lcall 0x181f, 0x3c0
  037954  0FC4: 5e               pop si
  037955  0FC5: 5f               pop di
  037956  0FC6: c9               leave 
  037957  0FC7: cb               retf 

; ---- func_037958  size=184  insns=67  prologue=ENTER 0x002C,0  terminal=RETF ----
  037958  0FC8: c82c0000         enter 0x2c, 0
  03795C  0FCC: ff7606           push word ptr [bp + 6]
  03795F  0FCF: 9a82051f18       lcall 0x181f, 0x582
  037964  0FD4: 83c402           add sp, 2
  037967  0FD7: 6a02             push 2
  037969  0FD9: 0e               push cs
  03796A  0FDA: e8e624           call 0x34c3
  03796D  0FDD: 83c402           add sp, 2
  037970  0FE0: 689000           push 0x90
  037973  0FE3: 6a05             push 5
  037975  0FE5: 684001           push 0x140
  037978  0FE8: 6a00             push 0
  03797A  0FEA: ff36f62d         push word ptr [0x2df6]
  03797E  0FEE: 9a22001f18       lcall 0x181f, 0x22
  037983  0FF3: 83c402           add sp, 2
  037986  0FF6: 52               push dx
  037987  0FF7: 50               push ax
  037988  0FF8: 9a00011f18       lcall 0x181f, 0x100
  03798D  0FFD: 83c40c           add sp, 0xc
  037990  1000: b80a00           mov ax, 0xa
  037993  1003: 8946d6           mov word ptr [bp - 0x2a], ax
  037996  1006: 50               push ax
  037997  1007: b81900           mov ax, 0x19
  03799A  100A: 8946d4           mov word ptr [bp - 0x2c], ax
  03799D  100D: 50               push ax
  03799E  100E: 682c01           push 0x12c
  0379A1  1011: 6a00             push 0
  0379A3  1013: 6a00             push 0
  0379A5  1015: 6a01             push 1
  0379A7  1017: 8b1efc84         mov bx, word ptr [0x84fc]
  0379AB  101B: 8b5730           mov dx, word ptr [bx + 0x30]
  0379AE  101E: 8b5f2e           mov bx, word ptr [bx + 0x2e]
  0379B1  1021: b83900           mov ax, 0x39
  0379B4  1024: 9a36021f18       lcall 0x181f, 0x236
  0379B9  1029: f606835320       test byte ptr [0x5383], 0x20
  0379BE  102E: 742c             je 0x105c
  0379C0  1030: 8b1efc84         mov bx, word ptr [0x84fc]
  0379C4  1034: ff7730           push word ptr [bx + 0x30]
  0379C7  1037: ff772e           push word ptr [bx + 0x2e]
  0379CA  103A: 68a911           push 0x11a9
  0379CD  103D: 8d46d8           lea ax, [bp - 0x28]
  0379D0  1040: 50               push ax
  0379D1  1041: 9a480b1d0d       lcall 0xd1d, 0xb48
  0379D6  1046: 83c408           add sp, 8
  0379D9  1049: 6a0f             push 0xf
  0379DB  104B: 6a19             push 0x19
  0379DD  104D: 6a0a             push 0xa
  0379DF  104F: 8d46d8           lea ax, [bp - 0x28]
  0379E2  1052: 16               push ss
  0379E3  1053: 50               push ax
  0379E4  1054: 9a3c011f18       lcall 0x181f, 0x13c
  0379E9  1059: 83c40a           add sp, 0xa
  0379EC  105C: 6aff             push -1
  0379EE  105E: 6afe             push -2
  0379F0  1060: 0e               push cs
  0379F1  1061: e83c24           call 0x34a0
  0379F4  1064: 83c404           add sp, 4
  0379F7  1067: 6a00             push 0
  0379F9  1069: 684001           push 0x140
  0379FC  106C: 68c800           push 0xc8
  0379FF  106F: 2bc0             sub ax, ax
  037A01  1071: 99               cdq 
  037A02  1072: 2bdb             sub bx, bx
  037A04  1074: 9ae2001f18       lcall 0x181f, 0xe2
  037A09  1079: 9ac0031f18       lcall 0x181f, 0x3c0
  037A0E  107E: c9               leave 
  037A0F  107F: cb               retf 

; ---- func_037A10  size=1646  insns=555  prologue=ENTER 0x006E,0  terminal=RETF ----
  037A10  1080: c86e0000         enter 0x6e, 0
  037A14  1084: 56               push si
  037A15  1085: ff7606           push word ptr [bp + 6]
  037A18  1088: 9a82051f18       lcall 0x181f, 0x582
  037A1D  108D: 83c402           add sp, 2
  037A20  1090: 6a03             push 3
  037A22  1092: 0e               push cs
  037A23  1093: e82d24           call 0x34c3
  037A26  1096: 83c402           add sp, 2
  037A29  1099: 689000           push 0x90
  037A2C  109C: 6a05             push 5
  037A2E  109E: 684001           push 0x140
  037A31  10A1: 6a00             push 0
  037A33  10A3: ff36042e         push word ptr [0x2e04]
  037A37  10A7: 9a22001f18       lcall 0x181f, 0x22
  037A3C  10AC: 83c402           add sp, 2
  037A3F  10AF: 52               push dx
  037A40  10B0: 50               push ax
  037A41  10B1: 9a00011f18       lcall 0x181f, 0x100
  037A46  10B6: 83c40c           add sp, 0xc
  037A49  10B9: c746aa0400       mov word ptr [bp - 0x56], 4
  037A4E  10BE: c746a61900       mov word ptr [bp - 0x5a], 0x19
  037A53  10C3: c646b000         mov byte ptr [bp - 0x50], 0
  037A57  10C7: f606825301       test byte ptr [0x5382], 1
  037A5C  10CC: 7562             jne 0x1130
  037A5E  10CE: ff369a2e         push word ptr [0x2e9a]
  037A62  10D2: 8d46b0           lea ax, [bp - 0x50]
  037A65  10D5: 50               push ax
  037A66  10D6: 9a6e011f18       lcall 0x181f, 0x16e
  037A6B  10DB: 83c404           add sp, 4
  037A6E  10DE: 8d46b0           lea ax, [bp - 0x50]
  037A71  10E1: 50               push ax
  037A72  10E2: 9abe011f18       lcall 0x181f, 0x1be
  037A77  10E7: 83c402           add sp, 2
  037A7A  10EA: 8b1efc84         mov bx, word ptr [0x84fc]
  037A7E  10EE: 837f1200         cmp word ptr [bx + 0x12], 0
  037A82  10F2: 7d03             jge 0x10f7
  037A84  10F4: e98100           jmp 0x1178
  037A87  10F7: 8d46b0           lea ax, [bp - 0x50]
  037A8A  10FA: 50               push ax
  037A8B  10FB: 9a1e011f18       lcall 0x181f, 0x11e
  037A90  1100: 83c402           add sp, 2
  037A93  1103: 8b1efc84         mov bx, word ptr [0x84fc]
  037A97  1107: 8b5f12           mov bx, word ptr [bx + 0x12]
  037A9A  110A: 8bc3             mov ax, bx
  037A9C  110C: d1e3             shl bx, 1
  037A9E  110E: 03d8             add bx, ax
  037AA0  1110: d1e3             shl bx, 1
  037AA2  1112: ffb75296         push word ptr [bx - 0x69ae]
  037AA6  1116: 8d46b0           lea ax, [bp - 0x50]
  037AA9  1119: 50               push ax
  037AAA  111A: 9a6e011f18       lcall 0x181f, 0x16e
  037AAF  111F: 83c404           add sp, 4
  037AB2  1122: 8d46b0           lea ax, [bp - 0x50]
  037AB5  1125: 50               push ax
  037AB6  1126: 9a28011f18       lcall 0x181f, 0x128
  037ABB  112B: eb48             jmp 0x1175
  037ABD  112D: 90               nop 
  037ABE  112E: 90               nop 
  037ABF  112F: 90               nop 
  037AC0  1130: f606825302       test byte ptr [0x5382], 2
  037AC5  1135: 7541             jne 0x1178
  037AC7  1137: ff36d453         push word ptr [0x53d4]
  037ACB  113B: 9aa4091f18       lcall 0x181f, 0x9a4
  037AD0  1140: 83c402           add sp, 2
  037AD3  1143: 50               push ax
  037AD4  1144: 8d46b0           lea ax, [bp - 0x50]
  037AD7  1147: 50               push ax
  037AD8  1148: 9a6e011f18       lcall 0x181f, 0x16e
  037ADD  114D: 83c404           add sp, 4
  037AE0  1150: 8d46b0           lea ax, [bp - 0x50]
  037AE3  1153: 50               push ax
  037AE4  1154: 9a78011f18       lcall 0x181f, 0x178
  037AE9  1159: 83c402           add sp, 2
  037AEC  115C: ff369c2e         push word ptr [0x2e9c]
  037AF0  1160: 8d46b0           lea ax, [bp - 0x50]
  037AF3  1163: 50               push ax
  037AF4  1164: 9a6e011f18       lcall 0x181f, 0x16e
  037AF9  1169: 83c404           add sp, 4
  037AFC  116C: 8d46b0           lea ax, [bp - 0x50]
  037AFF  116F: 50               push ax
  037B00  1170: 9abe011f18       lcall 0x181f, 0x1be
  037B05  1175: 83c402           add sp, 2
  037B08  1178: ff7606           push word ptr [bp + 6]
  037B0B  117B: 9a660f1f19       lcall 0x191f, 0xf66
  037B10  1180: 83c402           add sp, 2
  037B13  1183: 8946ac           mov word ptr [bp - 0x54], ax
  037B16  1186: f606825302       test byte ptr [0x5382], 2
  037B1B  118B: 7412             je 0x119f
  037B1D  118D: 8b1efc84         mov bx, word ptr [0x84fc]
  037B21  1191: 8b470c           mov ax, word ptr [bx + 0xc]
  037B24  1194: 3b46ac           cmp ax, word ptr [bp - 0x54]
  037B27  1197: 7d03             jge 0x119c
  037B29  1199: 8b46ac           mov ax, word ptr [bp - 0x54]
  037B2C  119C: 8946ac           mov word ptr [bp - 0x54], ax
  037B2F  119F: 8b1efc84         mov bx, word ptr [0x84fc]
  037B33  11A3: 8b470c           mov ax, word ptr [bx + 0xc]
  037B36  11A6: 3b46ac           cmp ax, word ptr [bp - 0x54]
  037B39  11A9: 7e03             jle 0x11ae
  037B3B  11AB: 8b46ac           mov ax, word ptr [bp - 0x54]
  037B3E  11AE: 89469a           mov word ptr [bp - 0x66], ax
  037B41  11B1: f606835320       test byte ptr [0x5383], 0x20
  037B46  11B6: 7470             je 0x1228
  037B48  11B8: 8d46b0           lea ax, [bp - 0x50]
  037B4B  11BB: 50               push ax
  037B4C  11BC: 9a78011f18       lcall 0x181f, 0x178
  037B51  11C1: 83c402           add sp, 2
  037B54  11C4: 8d46b0           lea ax, [bp - 0x50]
  037B57  11C7: 50               push ax
  037B58  11C8: 9a1e011f18       lcall 0x181f, 0x11e
  037B5D  11CD: 83c402           add sp, 2
  037B60  11D0: 8b46ac           mov ax, word ptr [bp - 0x54]
  037B63  11D3: 2b469a           sub ax, word ptr [bp - 0x66]
  037B66  11D6: 50               push ax
  037B67  11D7: 8d46b0           lea ax, [bp - 0x50]
  037B6A  11DA: 16               push ss
  037B6B  11DB: 50               push ax
  037B6C  11DC: 9a82011f18       lcall 0x181f, 0x182
  037B71  11E1: 83c406           add sp, 6
  037B74  11E4: 8d46b0           lea ax, [bp - 0x50]
  037B77  11E7: 50               push ax
  037B78  11E8: 9a78011f18       lcall 0x181f, 0x178
  037B7D  11ED: 83c402           add sp, 2
  037B80  11F0: ff36ee2d         push word ptr [0x2dee]
  037B84  11F4: 8d46b0           lea ax, [bp - 0x50]
  037B87  11F7: 50               push ax
  037B88  11F8: 9a6e011f18       lcall 0x181f, 0x16e
  037B8D  11FD: 83c404           add sp, 4
  037B90  1200: 8d46b0           lea ax, [bp - 0x50]
  037B93  1203: 50               push ax
  037B94  1204: 9a78011f18       lcall 0x181f, 0x178
  037B99  1209: 83c402           add sp, 2
  037B9C  120C: ff76ac           push word ptr [bp - 0x54]
  037B9F  120F: 8d46b0           lea ax, [bp - 0x50]
  037BA2  1212: 16               push ss
  037BA3  1213: 50               push ax
  037BA4  1214: 9a82011f18       lcall 0x181f, 0x182
  037BA9  1219: 83c406           add sp, 6
  037BAC  121C: 8d46b0           lea ax, [bp - 0x50]
  037BAF  121F: 50               push ax
  037BB0  1220: 9a28011f18       lcall 0x181f, 0x128
  037BB5  1225: 83c402           add sp, 2
  037BB8  1228: 689200           push 0x92
  037BBB  122B: ff76a6           push word ptr [bp - 0x5a]
  037BBE  122E: ff76aa           push word ptr [bp - 0x56]
  037BC1  1231: 8d46b0           lea ax, [bp - 0x50]
  037BC4  1234: 16               push ss
  037BC5  1235: 50               push ax
  037BC6  1236: 9a3c011f18       lcall 0x181f, 0x13c
  037BCB  123B: 83c40a           add sp, 0xa
  037BCE  123E: ff76aa           push word ptr [bp - 0x56]
  037BD1  1241: c41e9e08         les bx, ptr [0x89e]
  037BD5  1245: 268a07           mov al, byte ptr es:[bx]
  037BD8  1248: 2ae4             sub ah, ah
  037BDA  124A: 40               inc ax
  037BDB  124B: 40               inc ax
  037BDC  124C: 0146a6           add word ptr [bp - 0x5a], ax
  037BDF  124F: 8b46a6           mov ax, word ptr [bp - 0x5a]
  037BE2  1252: 50               push ax
  037BE3  1253: 682c01           push 0x12c
  037BE6  1256: 6a00             push 0
  037BE8  1258: 6a00             push 0
  037BEA  125A: 6a01             push 1
  037BEC  125C: b83f00           mov ax, 0x3f
  037BEF  125F: 8b56ac           mov dx, word ptr [bp - 0x54]
  037BF2  1262: 8b5e9a           mov bx, word ptr [bp - 0x66]
  037BF5  1265: 9a36021f18       lcall 0x181f, 0x236
  037BFA  126A: 8b46a6           mov ax, word ptr [bp - 0x5a]
  037BFD  126D: c41e3e08         les bx, ptr [0x83e]
  037C01  1271: 2603873403       add ax, word ptr es:[bx + 0x334]
  037C06  1276: 40               inc ax
  037C07  1277: 40               inc ax
  037C08  1278: 8946a6           mov word ptr [bp - 0x5a], ax
  037C0B  127B: 8b5e06           mov bx, word ptr [bp + 6]
  037C0E  127E: 8a871094         mov al, byte ptr [bx - 0x6bf0]
  037C12  1282: 2c01             sub al, 1
  037C14  1284: 1ac9             sbb cl, cl
  037C16  1286: f6d1             not cl
  037C18  1288: 22c1             and al, cl
  037C1A  128A: 0401             add al, 1
  037C1C  128C: 2ae4             sub ah, ah
  037C1E  128E: 894692           mov word ptr [bp - 0x6e], ax
  037C21  1291: 6a00             push 0
  037C23  1293: 6a64             push 0x64
  037C25  1295: 8bc8             mov cx, ax
  037C27  1297: f72ed053         imul word ptr [0x53d0]
  037C2B  129B: 52               push dx
  037C2C  129C: 50               push ax
  037C2D  129D: 8bf1             mov si, cx
  037C2F  129F: 9ac60e1d0d       lcall 0xd1d, 0xec6
  037C34  12A4: 89469c           mov word ptr [bp - 0x64], ax
  037C37  12A7: 2bf0             sub si, ax
  037C39  12A9: 897694           mov word ptr [bp - 0x6c], si
  037C3C  12AC: c646b000         mov byte ptr [bp - 0x50], 0
  037C40  12B0: ff36442e         push word ptr [0x2e44]
  037C44  12B4: 8d46b0           lea ax, [bp - 0x50]
  037C47  12B7: 50               push ax
  037C48  12B8: 9a6e011f18       lcall 0x181f, 0x16e
  037C4D  12BD: 83c404           add sp, 4
  037C50  12C0: 8d46b0           lea ax, [bp - 0x50]
  037C53  12C3: 50               push ax
  037C54  12C4: 9a78011f18       lcall 0x181f, 0x178
  037C59  12C9: 83c402           add sp, 2
  037C5C  12CC: ff36482e         push word ptr [0x2e48]
  037C60  12D0: 8d46b0           lea ax, [bp - 0x50]
  037C63  12D3: 50               push ax
  037C64  12D4: 9a6e011f18       lcall 0x181f, 0x16e
  037C69  12D9: 83c404           add sp, 4
  037C6C  12DC: 8d46b0           lea ax, [bp - 0x50]
  037C6F  12DF: 50               push ax
  037C70  12E0: 9abe011f18       lcall 0x181f, 0x1be
  037C75  12E5: 83c402           add sp, 2
  037C78  12E8: ff36d053         push word ptr [0x53d0]
  037C7C  12EC: 8d46b0           lea ax, [bp - 0x50]
  037C7F  12EF: 16               push ss
  037C80  12F0: 50               push ax
  037C81  12F1: 9a82011f18       lcall 0x181f, 0x182
  037C86  12F6: 83c406           add sp, 6
  037C89  12F9: 8d46b0           lea ax, [bp - 0x50]
  037C8C  12FC: 50               push ax
  037C8D  12FD: 9a0a011f18       lcall 0x181f, 0x10a
  037C92  1302: 83c402           add sp, 2
  037C95  1305: 8d46b0           lea ax, [bp - 0x50]
  037C98  1308: 50               push ax
  037C99  1309: 9a78011f18       lcall 0x181f, 0x178
  037C9E  130E: 83c402           add sp, 2
  037CA1  1311: 8d46b0           lea ax, [bp - 0x50]
  037CA4  1314: 50               push ax
  037CA5  1315: 9a78011f18       lcall 0x181f, 0x178
  037CAA  131A: 83c402           add sp, 2
  037CAD  131D: 8d46b0           lea ax, [bp - 0x50]
  037CB0  1320: 50               push ax
  037CB1  1321: 9a78011f18       lcall 0x181f, 0x178
  037CB6  1326: 83c402           add sp, 2
  037CB9  1329: ff36462e         push word ptr [0x2e46]
  037CBD  132D: 8d46b0           lea ax, [bp - 0x50]
  037CC0  1330: 50               push ax
  037CC1  1331: 9a6e011f18       lcall 0x181f, 0x16e
  037CC6  1336: 83c404           add sp, 4
  037CC9  1339: 8d46b0           lea ax, [bp - 0x50]
  037CCC  133C: 50               push ax
  037CCD  133D: 9a78011f18       lcall 0x181f, 0x178
  037CD2  1342: 83c402           add sp, 2
  037CD5  1345: ff36482e         push word ptr [0x2e48]
  037CD9  1349: 8d46b0           lea ax, [bp - 0x50]
  037CDC  134C: 50               push ax
  037CDD  134D: 9a6e011f18       lcall 0x181f, 0x16e
  037CE2  1352: 83c404           add sp, 4
  037CE5  1355: 8d46b0           lea ax, [bp - 0x50]
  037CE8  1358: 50               push ax
  037CE9  1359: 9abe011f18       lcall 0x181f, 0x1be
  037CEE  135E: 83c402           add sp, 2
  037CF1  1361: b86400           mov ax, 0x64
  037CF4  1364: 2b06d053         sub ax, word ptr [0x53d0]
  037CF8  1368: 50               push ax
  037CF9  1369: 8d46b0           lea ax, [bp - 0x50]
  037CFC  136C: 16               push ss
  037CFD  136D: 50               push ax
  037CFE  136E: 9a82011f18       lcall 0x181f, 0x182
  037D03  1373: 83c406           add sp, 6
  037D06  1376: 8d46b0           lea ax, [bp - 0x50]
  037D09  1379: 50               push ax
  037D0A  137A: 9a0a011f18       lcall 0x181f, 0x10a
  037D0F  137F: 83c402           add sp, 2
  037D12  1382: 689200           push 0x92
  037D15  1385: 8346a60c         add word ptr [bp - 0x5a], 0xc
  037D19  1389: 8b46a6           mov ax, word ptr [bp - 0x5a]
  037D1C  138C: 50               push ax
  037D1D  138D: ff76aa           push word ptr [bp - 0x56]
  037D20  1390: 8d4eb0           lea cx, [bp - 0x50]
  037D23  1393: 16               push ss
  037D24  1394: 51               push cx
  037D25  1395: 9a3c011f18       lcall 0x181f, 0x13c
  037D2A  139A: 83c40a           add sp, 0xa
  037D2D  139D: c41e9e08         les bx, ptr [0x89e]
  037D31  13A1: 268a07           mov al, byte ptr es:[bx]
  037D34  13A4: 2ae4             sub ah, ah
  037D36  13A6: 0346a6           add ax, word ptr [bp - 0x5a]
  037D39  13A9: 40               inc ax
  037D3A  13AA: 40               inc ax
  037D3B  13AB: 8946a6           mov word ptr [bp - 0x5a], ax
  037D3E  13AE: 9a18021f18       lcall 0x181f, 0x218
  037D43  13B3: b87c00           mov ax, 0x7c
  037D46  13B6: 8b569c           mov dx, word ptr [bp - 0x64]
  037D49  13B9: 2bdb             sub bx, bx
  037D4B  13BB: 9a22021f18       lcall 0x181f, 0x222
  037D50  13C0: b87d00           mov ax, 0x7d
  037D53  13C3: 8b5694           mov dx, word ptr [bp - 0x6c]
  037D56  13C6: 2bdb             sub bx, bx
  037D58  13C8: 9a22021f18       lcall 0x181f, 0x222
  037D5D  13CD: 6a04             push 4
  037D5F  13CF: 8b46aa           mov ax, word ptr [bp - 0x56]
  037D62  13D2: 8b56a6           mov dx, word ptr [bp - 0x5a]
  037D65  13D5: bb2c01           mov bx, 0x12c
  037D68  13D8: 9a2c021f18       lcall 0x181f, 0x22c
  037D6D  13DD: c41e3e08         les bx, ptr [0x83e]
  037D71  13E1: 268b871006       mov ax, word ptr es:[bx + 0x610]
  037D76  13E6: 050e00           add ax, 0xe
  037D79  13E9: 0146a6           add word ptr [bp - 0x5a], ax
  037D7C  13EC: 2bc0             sub ax, ax
  037D7E  13EE: 8946a4           mov word ptr [bp - 0x5c], ax
  037D81  13F1: 8946a8           mov word ptr [bp - 0x58], ax
  037D84  13F4: 89469e           mov word ptr [bp - 0x62], ax
  037D87  13F7: eb17             jmp 0x1410
  037D89  13F9: 90               nop 
  037D8A  13FA: 8b5e9e           mov bx, word ptr [bp - 0x62]
  037D8D  13FD: d1e3             shl bx, 1
  037D8F  13FF: 8b87da53         mov ax, word ptr [bx + 0x53da]
  037D93  1403: 0146a8           add word ptr [bp - 0x58], ax
  037D96  1406: 8b87e253         mov ax, word ptr [bx + 0x53e2]
  037D9A  140A: 0146a4           add word ptr [bp - 0x5c], ax
  037D9D  140D: ff469e           inc word ptr [bp - 0x62]
  037DA0  1410: 837e9e04         cmp word ptr [bp - 0x62], 4
  037DA4  1414: 7ce4             jl 0x13fa
  037DA6  1416: 837ea800         cmp word ptr [bp - 0x58], 0
  037DAA  141A: 7503             jne 0x141f
  037DAC  141C: e9d800           jmp 0x14f7
  037DAF  141F: c646b000         mov byte ptr [bp - 0x50], 0
  037DB3  1423: ff7606           push word ptr [bp + 6]
  037DB6  1426: 9a5e061f18       lcall 0x181f, 0x65e
  037DBB  142B: 83c402           add sp, 2
  037DBE  142E: 50               push ax
  037DBF  142F: 8d46b0           lea ax, [bp - 0x50]
  037DC2  1432: 50               push ax
  037DC3  1433: 9a6e011f18       lcall 0x181f, 0x16e
  037DC8  1438: 83c404           add sp, 4
  037DCB  143B: 8d46b0           lea ax, [bp - 0x50]
  037DCE  143E: 50               push ax
  037DCF  143F: 9a78011f18       lcall 0x181f, 0x178
  037DD4  1444: 83c402           add sp, 2
  037DD7  1447: ff36642e         push word ptr [0x2e64]
  037DDB  144B: 8d46b0           lea ax, [bp - 0x50]
  037DDE  144E: 50               push ax
  037DDF  144F: 9a6e011f18       lcall 0x181f, 0x16e
  037DE4  1454: 83c404           add sp, 4
  037DE7  1457: 8d46b0           lea ax, [bp - 0x50]
  037DEA  145A: 50               push ax
  037DEB  145B: 9abe011f18       lcall 0x181f, 0x1be
  037DF0  1460: 83c402           add sp, 2
  037DF3  1463: 689200           push 0x92
  037DF6  1466: ff76a6           push word ptr [bp - 0x5a]
  037DF9  1469: ff76aa           push word ptr [bp - 0x56]
  037DFC  146C: 8d46b0           lea ax, [bp - 0x50]
  037DFF  146F: 16               push ss
  037E00  1470: 50               push ax
  037E01  1471: 9a3c011f18       lcall 0x181f, 0x13c
  037E06  1476: 83c40a           add sp, 0xa
  037E09  1479: c41e9e08         les bx, ptr [0x89e]
  037E0D  147D: 268a07           mov al, byte ptr es:[bx]
  037E10  1480: 2ae4             sub ah, ah
  037E12  1482: 40               inc ax
  037E13  1483: 40               inc ax
  037E14  1484: 0146a6           add word ptr [bp - 0x5a], ax
  037E17  1487: 9a18021f18       lcall 0x181f, 0x218
  037E1C  148C: a08652           mov al, byte ptr [0x5286]
  037E1F  148F: 2ae4             sub ah, ah
  037E21  1491: 8b16da53         mov dx, word ptr [0x53da]
  037E25  1495: 2bdb             sub bx, bx
  037E27  1497: 9a22021f18       lcall 0x181f, 0x222
  037E2C  149C: a0a252           mov al, byte ptr [0x52a2]
  037E2F  149F: 2ae4             sub ah, ah
  037E31  14A1: 8b16dc53         mov dx, word ptr [0x53dc]
  037E35  14A5: 2bdb             sub bx, bx
  037E37  14A7: 9a22021f18       lcall 0x181f, 0x222
  037E3C  14AC: a0cc52           mov al, byte ptr [0x52cc]
  037E3F  14AF: 2ae4             sub ah, ah
  037E41  14B1: 8b16e053         mov dx, word ptr [0x53e0]
  037E45  14B5: 2bdb             sub bx, bx
  037E47  14B7: 9a22021f18       lcall 0x181f, 0x222
  037E4C  14BC: a02e53           mov al, byte ptr [0x532e]
  037E4F  14BF: 2ae4             sub ah, ah
  037E51  14C1: 8b16de53         mov dx, word ptr [0x53de]
  037E55  14C5: 2bdb             sub bx, bx
  037E57  14C7: 9a22021f18       lcall 0x181f, 0x222
  037E5C  14CC: c70670000100     mov word ptr [0x70], 1
  037E62  14D2: 6a04             push 4
  037E64  14D4: 8b46aa           mov ax, word ptr [bp - 0x56]
  037E67  14D7: 8b56a6           mov dx, word ptr [bp - 0x5a]
  037E6A  14DA: bb2c01           mov bx, 0x12c
  037E6D  14DD: 9a2c021f18       lcall 0x181f, 0x22c
  037E72  14E2: c70670000000     mov word ptr [0x70], 0
  037E78  14E8: c41e3e08         les bx, ptr [0x83e]
  037E7C  14EC: 268b871006       mov ax, word ptr es:[bx + 0x610]
  037E81  14F1: 050e00           add ax, 0xe
  037E84  14F4: 0146a6           add word ptr [bp - 0x5a], ax
  037E87  14F7: 837ea400         cmp word ptr [bp - 0x5c], 0
  037E8B  14FB: 7503             jne 0x1500
  037E8D  14FD: e9d900           jmp 0x15d9
  037E90  1500: c646b000         mov byte ptr [bp - 0x50], 0
  037E94  1504: ff36d453         push word ptr [0x53d4]
  037E98  1508: 9aa4091f18       lcall 0x181f, 0x9a4
  037E9D  150D: 83c402           add sp, 2
  037EA0  1510: 50               push ax
  037EA1  1511: 8d46b0           lea ax, [bp - 0x50]
  037EA4  1514: 50               push ax
  037EA5  1515: 9a6e011f18       lcall 0x181f, 0x16e
  037EAA  151A: 83c404           add sp, 4
  037EAD  151D: 8d46b0           lea ax, [bp - 0x50]
  037EB0  1520: 50               push ax
  037EB1  1521: 9a78011f18       lcall 0x181f, 0x178
  037EB6  1526: 83c402           add sp, 2
  037EB9  1529: ff36982e         push word ptr [0x2e98]
  037EBD  152D: 8d46b0           lea ax, [bp - 0x50]
  037EC0  1530: 50               push ax
  037EC1  1531: 9a6e011f18       lcall 0x181f, 0x16e
  037EC6  1536: 83c404           add sp, 4
  037EC9  1539: 8d46b0           lea ax, [bp - 0x50]
  037ECC  153C: 50               push ax
  037ECD  153D: 9abe011f18       lcall 0x181f, 0x1be
  037ED2  1542: 83c402           add sp, 2
  037ED5  1545: 689200           push 0x92
  037ED8  1548: ff76a6           push word ptr [bp - 0x5a]
  037EDB  154B: ff76aa           push word ptr [bp - 0x56]
  037EDE  154E: 8d46b0           lea ax, [bp - 0x50]
  037EE1  1551: 16               push ss
  037EE2  1552: 50               push ax
  037EE3  1553: 9a3c011f18       lcall 0x181f, 0x13c
  037EE8  1558: 83c40a           add sp, 0xa
  037EEB  155B: c41e9e08         les bx, ptr [0x89e]
  037EEF  155F: 268a07           mov al, byte ptr es:[bx]
  037EF2  1562: 2ae4             sub ah, ah
  037EF4  1564: 40               inc ax
  037EF5  1565: 40               inc ax
  037EF6  1566: 0146a6           add word ptr [bp - 0x5a], ax
  037EF9  1569: 9a18021f18       lcall 0x181f, 0x218
  037EFE  156E: a0b052           mov al, byte ptr [0x52b0]
  037F01  1571: 2ae4             sub ah, ah
  037F03  1573: 8b16e253         mov dx, word ptr [0x53e2]
  037F07  1577: 2bdb             sub bx, bx
  037F09  1579: 9a22021f18       lcall 0x181f, 0x222
  037F0E  157E: a09452           mov al, byte ptr [0x5294]
  037F11  1581: 2ae4             sub ah, ah
  037F13  1583: 8b16e453         mov dx, word ptr [0x53e4]
  037F17  1587: 2bdb             sub bx, bx
  037F19  1589: 9a22021f18       lcall 0x181f, 0x222
  037F1E  158E: a0cc52           mov al, byte ptr [0x52cc]
  037F21  1591: 2ae4             sub ah, ah
  037F23  1593: 8b16e853         mov dx, word ptr [0x53e8]
  037F27  1597: 2bdb             sub bx, bx
  037F29  1599: 9a22021f18       lcall 0x181f, 0x222
  037F2E  159E: a02e53           mov al, byte ptr [0x532e]
  037F31  15A1: 2ae4             sub ah, ah
  037F33  15A3: 8b16e653         mov dx, word ptr [0x53e6]
  037F37  15A7: 2bdb             sub bx, bx
  037F39  15A9: 9a22021f18       lcall 0x181f, 0x222
  037F3E  15AE: c70670000100     mov word ptr [0x70], 1
  037F44  15B4: 6a04             push 4
  037F46  15B6: 8b46aa           mov ax, word ptr [bp - 0x56]
  037F49  15B9: 8b56a6           mov dx, word ptr [bp - 0x5a]
  037F4C  15BC: bb2c01           mov bx, 0x12c
  037F4F  15BF: 9a2c021f18       lcall 0x181f, 0x22c
  037F54  15C4: c70670000000     mov word ptr [0x70], 0
  037F5A  15CA: c41e3e08         les bx, ptr [0x83e]
  037F5E  15CE: 268b871006       mov ax, word ptr es:[bx + 0x610]
  037F63  15D3: 050e00           add ax, 0xe
  037F66  15D6: 0146a6           add word ptr [bp - 0x5a], ax
  037F69  15D9: c646b000         mov byte ptr [bp - 0x50], 0
  037F6D  15DD: ff366c2e         push word ptr [0x2e6c]
  037F71  15E1: 8d46b0           lea ax, [bp - 0x50]
  037F74  15E4: 50               push ax
  037F75  15E5: 9a6e011f18       lcall 0x181f, 0x16e
  037F7A  15EA: 83c404           add sp, 4
  037F7D  15ED: 8d46b0           lea ax, [bp - 0x50]
  037F80  15F0: 50               push ax
  037F81  15F1: 9abe011f18       lcall 0x181f, 0x1be
  037F86  15F6: 83c402           add sp, 2
  037F89  15F9: 689200           push 0x92
  037F8C  15FC: ff76a6           push word ptr [bp - 0x5a]
  037F8F  15FF: ff76aa           push word ptr [bp - 0x56]
  037F92  1602: 8d46b0           lea ax, [bp - 0x50]
  037F95  1605: 16               push ss
  037F96  1606: 50               push ax
  037F97  1607: 9a3c011f18       lcall 0x181f, 0x13c
  037F9C  160C: 83c40a           add sp, 0xa
  037F9F  160F: 8b46aa           mov ax, word ptr [bp - 0x56]
  037FA2  1612: 894698           mov word ptr [bp - 0x68], ax
  037FA5  1615: c41e9e08         les bx, ptr [0x89e]
  037FA9  1619: 268a07           mov al, byte ptr es:[bx]
  037FAC  161C: 2ae4             sub ah, ah
  037FAE  161E: 40               inc ax
  037FAF  161F: 40               inc ax
  037FB0  1620: 0146a6           add word ptr [bp - 0x5a], ax
  037FB3  1623: 8b46a6           mov ax, word ptr [bp - 0x5a]
  037FB6  1626: 894696           mov word ptr [bp - 0x6a], ax
  037FB9  1629: 2bc0             sub ax, ax
  037FBB  162B: 8946ae           mov word ptr [bp - 0x52], ax
  037FBE  162E: 8946a2           mov word ptr [bp - 0x5e], ax
  037FC1  1631: 89469e           mov word ptr [bp - 0x62], ax
  037FC4  1634: eb72             jmp 0x16a8
  037FC6  1636: ff769e           push word ptr [bp - 0x62]
  037FC9  1639: ff7606           push word ptr [bp + 6]
  037FCC  163C: 9ab4071f18       lcall 0x181f, 0x7b4
  037FD1  1641: 83c404           add sp, 4
  037FD4  1644: 0bc0             or ax, ax
  037FD6  1646: 745d             je 0x16a5
  037FD8  1648: c646b000         mov byte ptr [bp - 0x50], 0
  037FDC  164C: 8b5e9e           mov bx, word ptr [bp - 0x62]
  037FDF  164F: 8bc3             mov ax, bx
  037FE1  1651: d1e3             shl bx, 1
  037FE3  1653: 03d8             add bx, ax
  037FE5  1655: d1e3             shl bx, 1
  037FE7  1657: ffb75296         push word ptr [bx - 0x69ae]
  037FEB  165B: 8d46b0           lea ax, [bp - 0x50]
  037FEE  165E: 50               push ax
  037FEF  165F: 9a6e011f18       lcall 0x181f, 0x16e
  037FF4  1664: 83c404           add sp, 4
  037FF7  1667: 6a61             push 0x61
  037FF9  1669: ff7696           push word ptr [bp - 0x6a]
  037FFC  166C: ff7698           push word ptr [bp - 0x68]
  037FFF  166F: 8d46b0           lea ax, [bp - 0x50]
  038002  1672: 16               push ss
  038003  1673: 50               push ax
  038004  1674: 9a3c011f18       lcall 0x181f, 0x13c
  038009  1679: 83c40a           add sp, 0xa
  03800C  167C: 8346984e         add word ptr [bp - 0x68], 0x4e
  038010  1680: ff46ae           inc word ptr [bp - 0x52]
  038013  1683: 837eae04         cmp word ptr [bp - 0x52], 4
  038017  1687: 7c1c             jl 0x16a5
  038019  1689: c746ae0000       mov word ptr [bp - 0x52], 0
  03801E  168E: ff46a2           inc word ptr [bp - 0x5e]
  038021  1691: c41e9e08         les bx, ptr [0x89e]
  038025  1695: 268a07           mov al, byte ptr es:[bx]
  038028  1698: 2ae4             sub ah, ah
  03802A  169A: 40               inc ax
  03802B  169B: 40               inc ax
  03802C  169C: 014696           add word ptr [bp - 0x6a], ax
  03802F  169F: 8b46aa           mov ax, word ptr [bp - 0x56]
  038032  16A2: 894698           mov word ptr [bp - 0x68], ax
  038035  16A5: ff469e           inc word ptr [bp - 0x62]
  038038  16A8: 837e9e19         cmp word ptr [bp - 0x62], 0x19
  03803C  16AC: 7c88             jl 0x1636
  03803E  16AE: 6aff             push -1
  038040  16B0: 6afe             push -2
  038042  16B2: 0e               push cs
  038043  16B3: e8ea1d           call 0x34a0
  038046  16B6: 83c404           add sp, 4
  038049  16B9: 6a00             push 0
  03804B  16BB: 684001           push 0x140
  03804E  16BE: 68c800           push 0xc8
  038051  16C1: 2bc0             sub ax, ax
  038053  16C3: 99               cdq 
  038054  16C4: 2bdb             sub bx, bx
  038056  16C6: 9ae2001f18       lcall 0x181f, 0xe2
  03805B  16CB: 9ac0031f18       lcall 0x181f, 0x3c0
  038060  16D0: 833e460300       cmp word ptr [0x346], 0
  038065  16D5: 7514             jne 0x16eb
  038067  16D7: 833e389e00       cmp word ptr [0x9e38], 0
  03806C  16DC: 750d             jne 0x16eb
  03806E  16DE: 6aff             push -1
  038070  16E0: ff7606           push word ptr [bp + 6]
  038073  16E3: 9a740f1f19       lcall 0x191f, 0xf74
  038078  16E8: 83c404           add sp, 4
  03807B  16EB: 5e               pop si
  03807C  16EC: c9               leave 
  03807D  16ED: cb               retf 

; ---- func_03807E  size=921  insns=327  prologue=ENTER 0x00CE,0  terminal=RETF ----
  03807E  16EE: c8ce0000         enter 0xce, 0
  038082  16F2: 56               push si
  038083  16F3: 6a60             push 0x60
  038085  16F5: 2bc0             sub ax, ax
  038087  16F7: 8946fe           mov word ptr [bp - 2], ax
  03808A  16FA: 8946a2           mov word ptr [bp - 0x5e], ax
  03808D  16FD: 89469a           mov word ptr [bp - 0x66], ax
  038090  1700: 50               push ax
  038091  1701: 8d8634ff         lea ax, [bp - 0xcc]
  038095  1705: 50               push ax
  038096  1706: 9aae0d1d0d       lcall 0xd1d, 0xdae
  03809B  170B: 83c406           add sp, 6
  03809E  170E: 8b4608           mov ax, word ptr [bp + 8]
  0380A1  1711: 8946a6           mov word ptr [bp - 0x5a], ax
  0380A4  1714: 3d1300           cmp ax, 0x13
  0380A7  1717: 7505             jne 0x171e
  0380A9  1719: c746a61c00       mov word ptr [bp - 0x5a], 0x1c
  0380AE  171E: c7469c0000       mov word ptr [bp - 0x64], 0
  0380B3  1723: eb36             jmp 0x175b
  0380B5  1725: 90               nop 
  0380B6  1726: ff46aa           inc word ptr [bp - 0x56]
  0380B9  1729: 8b1e4285         mov bx, word ptr [0x8542]
  0380BD  172D: 8a471f           mov al, byte ptr [bx + 0x1f]
  0380C0  1730: 98               cwde 
  0380C1  1731: 3b46aa           cmp ax, word ptr [bp - 0x56]
  0380C4  1734: 7e22             jle 0x1758
  0380C6  1736: ff76aa           push word ptr [bp - 0x56]
  0380C9  1739: 9a540c1f18       lcall 0x181f, 0xc54
  0380CE  173E: 83c402           add sp, 2
  0380D1  1741: 8946a8           mov word ptr [bp - 0x58], ax
  0380D4  1744: 3b46a6           cmp ax, word ptr [bp - 0x5a]
  0380D7  1747: 75dd             jne 0x1726
  0380D9  1749: ff469a           inc word ptr [bp - 0x66]
  0380DC  174C: 8b769c           mov si, word ptr [bp - 0x64]
  0380DF  174F: d1e6             shl si, 1
  0380E1  1751: ff8234ff         inc word ptr [bp + si - 0xcc]
  0380E5  1755: ebcf             jmp 0x1726
  0380E7  1757: 90               nop 
  0380E8  1758: ff469c           inc word ptr [bp - 0x64]
  0380EB  175B: 8b469c           mov ax, word ptr [bp - 0x64]
  0380EE  175E: 39069e53         cmp word ptr [0x539e], ax
  0380F2  1762: 7e1c             jle 0x1780
  0380F4  1764: 50               push ax
  0380F5  1765: 9ae6091f18       lcall 0x181f, 0x9e6
  0380FA  176A: 83c402           add sp, 2
  0380FD  176D: 8a4606           mov al, byte ptr [bp + 6]
  038100  1770: 8b1e4285         mov bx, word ptr [0x8542]
  038104  1774: 38471a           cmp byte ptr [bx + 0x1a], al
  038107  1777: 75df             jne 0x1758
  038109  1779: c746aa0000       mov word ptr [bp - 0x56], 0
  03810E  177E: eba9             jmp 0x1729
  038110  1780: c746940000       mov word ptr [bp - 0x6c], 0
  038115  1785: eb35             jmp 0x17bc
  038117  1787: 90               nop 
  038118  1788: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  03811C  178C: 8a874531         mov al, byte ptr [bx + 0x3145]
  038120  1790: 2ae4             sub ah, ah
  038122  1792: 50               push ax
  038123  1793: 8a874431         mov al, byte ptr [bx + 0x3144]
  038127  1797: 50               push ax
  038128  1798: 9abe071f18       lcall 0x181f, 0x7be
  03812D  179D: 83c404           add sp, 4
  038130  17A0: 898632ff         mov word ptr [bp - 0xce], ax
  038134  17A4: 0bc0             or ax, ax
  038136  17A6: 7c0e             jl 0x17b6
  038138  17A8: ff469a           inc word ptr [bp - 0x66]
  03813B  17AB: 8bf0             mov si, ax
  03813D  17AD: d1e6             shl si, 1
  03813F  17AF: ff8234ff         inc word ptr [bp + si - 0xcc]
  038143  17B3: eb04             jmp 0x17b9
  038145  17B5: 90               nop 
  038146  17B6: ff46a2           inc word ptr [bp - 0x5e]
  038149  17B9: ff4694           inc word ptr [bp - 0x6c]
  03814C  17BC: 8b4694           mov ax, word ptr [bp - 0x6c]
  03814F  17BF: 39069c53         cmp word ptr [0x539c], ax
  038153  17C3: 7e53             jle 0x1818
  038155  17C5: 6bd81c           imul bx, ax, 0x1c
  038158  17C8: 8a874731         mov al, byte ptr [bx + 0x3147]
  03815C  17CC: 240f             and al, 0xf
  03815E  17CE: 3a4606           cmp al, byte ptr [bp + 6]
  038161  17D1: 75e6             jne 0x17b9
  038163  17D3: ff7694           push word ptr [bp - 0x6c]
  038166  17D6: 9a280b1f18       lcall 0x181f, 0xb28
  03816B  17DB: 83c402           add sp, 2
  03816E  17DE: 0bc0             or ax, ax
  038170  17E0: 74d7             je 0x17b9
  038172  17E2: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  038176  17E6: 8a875b31         mov al, byte ptr [bx + 0x315b]
  03817A  17EA: 98               cwde 
  03817B  17EB: 8946a8           mov word ptr [bp - 0x58], ax
  03817E  17EE: 3b46a6           cmp ax, word ptr [bp - 0x5a]
  038181  17F1: 75c6             jne 0x17b9
  038183  17F3: 6b5e941c         imul bx, word ptr [bp - 0x6c], 0x1c
  038187  17F7: 8a874531         mov al, byte ptr [bx + 0x3145]
  03818B  17FB: 2ae4             sub ah, ah
  03818D  17FD: 50               push ax
  03818E  17FE: 8a874431         mov al, byte ptr [bx + 0x3144]
  038192  1802: 50               push ax
  038193  1803: 9a02031f18       lcall 0x181f, 0x302
  038198  1808: 83c404           add sp, 4
  03819B  180B: 0bc0             or ax, ax
  03819D  180D: 7403             je 0x1812
  03819F  180F: e976ff           jmp 0x1788
  0381A2  1812: ff46fe           inc word ptr [bp - 2]
  0381A5  1815: eba2             jmp 0x17b9
  0381A7  1817: 90               nop 
  0381A8  1818: 6a04             push 4
  0381AA  181A: 0e               push cs
  0381AB  181B: e8a51c           call 0x34c3
  0381AE  181E: 83c402           add sp, 2
  0381B1  1821: 689000           push 0x90
  0381B4  1824: 6a05             push 5
  0381B6  1826: 684001           push 0x140
  0381B9  1829: 6a00             push 0
  0381BB  182B: ff361c2e         push word ptr [0x2e1c]
  0381BF  182F: 9a22001f18       lcall 0x181f, 0x22
  0381C4  1834: 83c402           add sp, 2
  0381C7  1837: 52               push dx
  0381C8  1838: 50               push ax
  0381C9  1839: 9a00011f18       lcall 0x181f, 0x100
  0381CE  183E: 83c40c           add sp, 0xc
  0381D1  1841: c41e9e08         les bx, ptr [0x89e]
  0381D5  1845: 268a07           mov al, byte ptr es:[bx]
  0381D8  1848: 2ae4             sub ah, ah
  0381DA  184A: 050600           add ax, 6
  0381DD  184D: 8946a0           mov word ptr [bp - 0x60], ax
  0381E0  1850: c646ae00         mov byte ptr [bp - 0x52], 0
  0381E4  1854: 8d46ae           lea ax, [bp - 0x52]
  0381E7  1857: 50               push ax
  0381E8  1858: 9a1e011f18       lcall 0x181f, 0x11e
  0381ED  185D: 83c402           add sp, 2
  0381F0  1860: 8b5e08           mov bx, word ptr [bp + 8]
  0381F3  1863: c1e303           shl bx, 3
  0381F6  1866: ffb7a48e         push word ptr [bx - 0x715c]
  0381FA  186A: 8d46ae           lea ax, [bp - 0x52]
  0381FD  186D: 50               push ax
  0381FE  186E: 8bf3             mov si, bx
  038200  1870: 9a6e011f18       lcall 0x181f, 0x16e
  038205  1875: 83c404           add sp, 4
  038208  1878: 8d46ae           lea ax, [bp - 0x52]
  03820B  187B: 50               push ax
  03820C  187C: 9a28011f18       lcall 0x181f, 0x128
  038211  1881: 83c402           add sp, 2
  038214  1884: 689100           push 0x91
  038217  1887: ff76a0           push word ptr [bp - 0x60]
  03821A  188A: 684001           push 0x140
  03821D  188D: 6a00             push 0
  03821F  188F: 8d46ae           lea ax, [bp - 0x52]
  038222  1892: 16               push ss
  038223  1893: 50               push ax
  038224  1894: 9a00011f18       lcall 0x181f, 0x100
  038229  1899: 83c40c           add sp, 0xc
  03822C  189C: 6a03             push 3
  03822E  189E: 8b4608           mov ax, word ptr [bp + 8]
  038231  18A1: 9ac6021f18       lcall 0x181f, 0x2c6
  038236  18A6: ba0200           mov dx, 2
  038239  18A9: bb1800           mov bx, 0x18
  03823C  18AC: 9a4a021f18       lcall 0x181f, 0x24a
  038241  18B1: c646ae00         mov byte ptr [bp - 0x52], 0
  038245  18B5: ffb4a48e         push word ptr [si - 0x715c]
  038249  18B9: 8d46ae           lea ax, [bp - 0x52]
  03824C  18BC: 50               push ax
  03824D  18BD: 9a6e011f18       lcall 0x181f, 0x16e
  038252  18C2: 83c404           add sp, 4
  038255  18C5: 8d46ae           lea ax, [bp - 0x52]
  038258  18C8: 50               push ax
  038259  18C9: 9abe011f18       lcall 0x181f, 0x1be
  03825E  18CE: 83c402           add sp, 2
  038261  18D1: ff760a           push word ptr [bp + 0xa]
  038264  18D4: 8d46ae           lea ax, [bp - 0x52]
  038267  18D7: 16               push ss
  038268  18D8: 50               push ax
  038269  18D9: 9a82011f18       lcall 0x181f, 0x182
  03826E  18DE: 83c406           add sp, 6
  038271  18E1: 689200           push 0x92
  038274  18E4: 6a1e             push 0x1e
  038276  18E6: 6a0e             push 0xe
  038278  18E8: 8d46ae           lea ax, [bp - 0x52]
  03827B  18EB: 16               push ss
  03827C  18EC: 50               push ax
  03827D  18ED: 9a3c011f18       lcall 0x181f, 0x13c
  038282  18F2: 83c40a           add sp, 0xa
  038285  18F5: c746a4a000       mov word ptr [bp - 0x5c], 0xa0
  03828A  18FA: b81900           mov ax, 0x19
  03828D  18FD: 8946a0           mov word ptr [bp - 0x60], ax
  038290  1900: 894696           mov word ptr [bp - 0x6a], ax
  038293  1903: c7469c0000       mov word ptr [bp - 0x64], 0
  038298  1908: eb36             jmp 0x1940
  03829A  190A: ff76fe           push word ptr [bp - 2]
  03829D  190D: 8d46ae           lea ax, [bp - 0x52]
  0382A0  1910: 16               push ss
  0382A1  1911: 50               push ax
  0382A2  1912: 9a82011f18       lcall 0x181f, 0x182
  0382A7  1917: 83c406           add sp, 6
  0382AA  191A: 689200           push 0x92
  0382AD  191D: ff7696           push word ptr [bp - 0x6a]
  0382B0  1920: ff7698           push word ptr [bp - 0x68]
  0382B3  1923: 8d46ae           lea ax, [bp - 0x52]
  0382B6  1926: 16               push ss
  0382B7  1927: 50               push ax
  0382B8  1928: 9a3c011f18       lcall 0x181f, 0x13c
  0382BD  192D: 83c40a           add sp, 0xa
  0382C0  1930: c41e9e08         les bx, ptr [0x89e]
  0382C4  1934: 268a07           mov al, byte ptr es:[bx]
  0382C7  1937: 2ae4             sub ah, ah
  0382C9  1939: 40               inc ax
  0382CA  193A: 014696           add word ptr [bp - 0x6a], ax
  0382CD  193D: ff469c           inc word ptr [bp - 0x64]
  0382D0  1940: 837e9c03         cmp word ptr [bp - 0x64], 3
  0382D4  1944: 7d68             jge 0x19ae
  0382D6  1946: c646ae00         mov byte ptr [bp - 0x52], 0
  0382DA  194A: 8b5e9c           mov bx, word ptr [bp - 0x64]
  0382DD  194D: d1e3             shl bx, 1
  0382DF  194F: ffb7242e         push word ptr [bx + 0x2e24]
  0382E3  1953: 8d46ae           lea ax, [bp - 0x52]
  0382E6  1956: 50               push ax
  0382E7  1957: 9a6e011f18       lcall 0x181f, 0x16e
  0382EC  195C: 83c404           add sp, 4
  0382EF  195F: 8d46ae           lea ax, [bp - 0x52]
  0382F2  1962: 50               push ax
  0382F3  1963: 9abe011f18       lcall 0x181f, 0x1be
  0382F8  1968: 83c402           add sp, 2
  0382FB  196B: 689200           push 0x92
  0382FE  196E: ff7696           push word ptr [bp - 0x6a]
  038301  1971: ff76a4           push word ptr [bp - 0x5c]
  038304  1974: 8d46ae           lea ax, [bp - 0x52]
  038307  1977: 16               push ss
  038308  1978: 50               push ax
  038309  1979: 9a3c011f18       lcall 0x181f, 0x13c
  03830E  197E: 83c40a           add sp, 0xa
  038311  1981: 8b46a4           mov ax, word ptr [bp - 0x5c]
  038314  1984: 055f00           add ax, 0x5f
  038317  1987: 894698           mov word ptr [bp - 0x68], ax
  03831A  198A: c646ae00         mov byte ptr [bp - 0x52], 0
  03831E  198E: 8b469c           mov ax, word ptr [bp - 0x64]
  038321  1991: 0bc0             or ax, ax
  038323  1993: 7503             jne 0x1998
  038325  1995: e972ff           jmp 0x190a
  038328  1998: 48               dec ax
  038329  1999: 7407             je 0x19a2
  03832B  199B: 48               dec ax
  03832C  199C: 740a             je 0x19a8
  03832E  199E: e979ff           jmp 0x191a
  038331  19A1: 90               nop 
  038332  19A2: ff76a2           push word ptr [bp - 0x5e]
  038335  19A5: e965ff           jmp 0x190d
  038338  19A8: ff769a           push word ptr [bp - 0x66]
  03833B  19AB: e95fff           jmp 0x190d
  03833E  19AE: b80200           mov ax, 2
  038341  19B1: 8946a4           mov word ptr [bp - 0x5c], ax
  038344  19B4: 894698           mov word ptr [bp - 0x68], ax
  038347  19B7: 8346a028         add word ptr [bp - 0x60], 0x28
  03834B  19BB: 8b46a0           mov ax, word ptr [bp - 0x60]
  03834E  19BE: 894696           mov word ptr [bp - 0x6a], ax
  038351  19C1: 2bc0             sub ax, ax
  038353  19C3: 8946ac           mov word ptr [bp - 0x54], ax
  038356  19C6: 89469e           mov word ptr [bp - 0x62], ax
  038359  19C9: 89469c           mov word ptr [bp - 0x64], ax
  03835C  19CC: e98700           jmp 0x1a56
  03835F  19CF: 90               nop 
  038360  19D0: 50               push ax
  038361  19D1: 9ae6091f18       lcall 0x181f, 0x9e6
  038366  19D6: 83c402           add sp, 2
  038369  19D9: 8b769c           mov si, word ptr [bp - 0x64]
  03836C  19DC: d1e6             shl si, 1
  03836E  19DE: 83ba34ff00       cmp word ptr [bp + si - 0xcc], 0
  038373  19E3: 746e             je 0x1a53
  038375  19E5: a14285           mov ax, word ptr [0x8542]
  038378  19E8: 40               inc ax
  038379  19E9: 40               inc ax
  03837A  19EA: 50               push ax
  03837B  19EB: 8d46ae           lea ax, [bp - 0x52]
  03837E  19EE: 50               push ax
  03837F  19EF: 9ae4071d0d       lcall 0xd1d, 0x7e4
  038384  19F4: 83c404           add sp, 4
  038387  19F7: 8d46ae           lea ax, [bp - 0x52]
  03838A  19FA: 50               push ax
  03838B  19FB: 9abe011f18       lcall 0x181f, 0x1be
  038390  1A00: 83c402           add sp, 2
  038393  1A03: 8b769c           mov si, word ptr [bp - 0x64]
  038396  1A06: d1e6             shl si, 1
  038398  1A08: ffb234ff         push word ptr [bp + si - 0xcc]
  03839C  1A0C: 8d46ae           lea ax, [bp - 0x52]
  03839F  1A0F: 16               push ss
  0383A0  1A10: 50               push ax
  0383A1  1A11: 9a82011f18       lcall 0x181f, 0x182
  0383A6  1A16: 83c406           add sp, 6
  0383A9  1A19: 6a61             push 0x61
  0383AB  1A1B: ff7696           push word ptr [bp - 0x6a]
  0383AE  1A1E: ff7698           push word ptr [bp - 0x68]
  0383B1  1A21: 8d46ae           lea ax, [bp - 0x52]
  0383B4  1A24: 16               push ss
  0383B5  1A25: 50               push ax
  0383B6  1A26: 9a3c011f18       lcall 0x181f, 0x13c
  0383BB  1A2B: 83c40a           add sp, 0xa
  0383BE  1A2E: 83469869         add word ptr [bp - 0x68], 0x69
  0383C2  1A32: ff46ac           inc word ptr [bp - 0x54]
  0383C5  1A35: 837eac03         cmp word ptr [bp - 0x54], 3
  0383C9  1A39: 7c18             jl 0x1a53
  0383CB  1A3B: c746ac0000       mov word ptr [bp - 0x54], 0
  0383D0  1A40: 83469609         add word ptr [bp - 0x6a], 9
  0383D4  1A44: 8b46a4           mov ax, word ptr [bp - 0x5c]
  0383D7  1A47: 894698           mov word ptr [bp - 0x68], ax
  0383DA  1A4A: ff469e           inc word ptr [bp - 0x62]
  0383DD  1A4D: 837e9e0a         cmp word ptr [bp - 0x62], 0xa
  0383E1  1A51: 740f             je 0x1a62
  0383E3  1A53: ff469c           inc word ptr [bp - 0x64]
  0383E6  1A56: 8b469c           mov ax, word ptr [bp - 0x64]
  0383E9  1A59: 39069e53         cmp word ptr [0x539e], ax
  0383ED  1A5D: 7e03             jle 0x1a62
  0383EF  1A5F: e96eff           jmp 0x19d0
  0383F2  1A62: 6aff             push -1
  0383F4  1A64: 6afe             push -2
  0383F6  1A66: 0e               push cs
  0383F7  1A67: e8361a           call 0x34a0
  0383FA  1A6A: 83c404           add sp, 4
  0383FD  1A6D: 6a00             push 0
  0383FF  1A6F: 684001           push 0x140
  038402  1A72: 68c800           push 0xc8
  038405  1A75: 2bc0             sub ax, ax
  038407  1A77: 99               cdq 
  038408  1A78: 2bdb             sub bx, bx
  03840A  1A7A: 9ae2001f18       lcall 0x181f, 0xe2
  03840F  1A7F: 9ac0031f18       lcall 0x181f, 0x3c0
  038414  1A84: 5e               pop si
  038415  1A85: c9               leave 
  038416  1A86: cb               retf 

; ---- func_038418  size=864  insns=271  prologue=ENTER 0x0120,0  terminal=RETF ----
  038418  1A88: c8200100         enter 0x120, 0
  03841C  1A8C: 57               push di
  03841D  1A8D: 56               push si
  03841E  1A8E: ff7606           push word ptr [bp + 6]
  038421  1A91: 9a82051f18       lcall 0x181f, 0x582
  038426  1A96: 83c402           add sp, 2
  038429  1A99: 6a04             push 4
  03842B  1A9B: 0e               push cs
  03842C  1A9C: e8241a           call 0x34c3
  03842F  1A9F: 83c402           add sp, 2
  038432  1AA2: 689000           push 0x90
  038435  1AA5: 6a05             push 5
  038437  1AA7: 684001           push 0x140
  03843A  1AAA: 6a00             push 0
  03843C  1AAC: ff361c2e         push word ptr [0x2e1c]
  038440  1AB0: 9a22001f18       lcall 0x181f, 0x22
  038445  1AB5: 83c402           add sp, 2
  038448  1AB8: 52               push dx
  038449  1AB9: 50               push ax
  03844A  1ABA: 9a00011f18       lcall 0x181f, 0x100
  03844F  1ABF: 83c40c           add sp, 0xc
  038452  1AC2: 689100           push 0x91
  038455  1AC5: c41e9e08         les bx, ptr [0x89e]
  038459  1AC9: 268a07           mov al, byte ptr es:[bx]
  03845C  1ACC: 2ae4             sub ah, ah
  03845E  1ACE: 050600           add ax, 6
  038461  1AD1: 50               push ax
  038462  1AD2: 684001           push 0x140
  038465  1AD5: 6a00             push 0
  038467  1AD7: ff362a2e         push word ptr [0x2e2a]
  03846B  1ADB: 9a22001f18       lcall 0x181f, 0x22
  038470  1AE0: 83c402           add sp, 2
  038473  1AE3: 52               push dx
  038474  1AE4: 50               push ax
  038475  1AE5: 9a00011f18       lcall 0x181f, 0x100
  03847A  1AEA: 83c40c           add sp, 0xc
  03847D  1AED: c786fafe0200     mov word ptr [bp - 0x106], 2
  038483  1AF3: c786f8fe1900     mov word ptr [bp - 0x108], 0x19
  038489  1AF9: 6a3a             push 0x3a
  03848B  1AFB: 6a00             push 0
  03848D  1AFD: 8d863cff         lea ax, [bp - 0xc4]
  038491  1B01: 50               push ax
  038492  1B02: 9aae0d1d0d       lcall 0xd1d, 0xdae
  038497  1B07: 83c406           add sp, 6
  03849A  1B0A: c786f2fe0000     mov word ptr [bp - 0x10e], 0
  0384A0  1B10: 8bb6f2fe         mov si, word ptr [bp - 0x10e]
  0384A4  1B14: d1e6             shl si, 1
  0384A6  1B16: c742c64001       mov word ptr [bp + si - 0x3a], 0x140
  0384AB  1B1B: c78202ffc800     mov word ptr [bp + si - 0xfe], 0xc8
  0384B1  1B21: ff86f2fe         inc word ptr [bp - 0x10e]
  0384B5  1B25: 83bef2fe1d       cmp word ptr [bp - 0x10e], 0x1d
  0384BA  1B2A: 7ce4             jl 0x1b10
  0384BC  1B2C: c786f2fe0000     mov word ptr [bp - 0x10e], 0
  0384C2  1B32: eb30             jmp 0x1b64
  0384C4  1B34: ff86fcfe         inc word ptr [bp - 0x104]
  0384C8  1B38: 8b1e4285         mov bx, word ptr [0x8542]
  0384CC  1B3C: 8a471f           mov al, byte ptr [bx + 0x1f]
  0384CF  1B3F: 98               cwde 
  0384D0  1B40: 3b86fcfe         cmp ax, word ptr [bp - 0x104]
  0384D4  1B44: 7e1a             jle 0x1b60
  0384D6  1B46: ffb6fcfe         push word ptr [bp - 0x104]
  0384DA  1B4A: 9a540c1f18       lcall 0x181f, 0xc54
  0384DF  1B4F: 83c402           add sp, 2
  0384E2  1B52: 8bf0             mov si, ax
  0384E4  1B54: 89b6ecfe         mov word ptr [bp - 0x114], si
  0384E8  1B58: d1e6             shl si, 1
  0384EA  1B5A: ff823cff         inc word ptr [bp + si - 0xc4]
  0384EE  1B5E: ebd4             jmp 0x1b34
  0384F0  1B60: ff86f2fe         inc word ptr [bp - 0x10e]
  0384F4  1B64: 8b86f2fe         mov ax, word ptr [bp - 0x10e]
  0384F8  1B68: 39069e53         cmp word ptr [0x539e], ax
  0384FC  1B6C: 7e1e             jle 0x1b8c
  0384FE  1B6E: 50               push ax
  0384FF  1B6F: 9ae6091f18       lcall 0x181f, 0x9e6
  038504  1B74: 83c402           add sp, 2
  038507  1B77: 8a4606           mov al, byte ptr [bp + 6]
  03850A  1B7A: 8b1e4285         mov bx, word ptr [0x8542]
  03850E  1B7E: 38471a           cmp byte ptr [bx + 0x1a], al
  038511  1B81: 75dd             jne 0x1b60
  038513  1B83: c786fcfe0000     mov word ptr [bp - 0x104], 0
  038519  1B89: ebad             jmp 0x1b38
  03851B  1B8B: 90               nop 
  03851C  1B8C: c786e6fe0000     mov word ptr [bp - 0x11a], 0
  038522  1B92: eb36             jmp 0x1bca
  038524  1B94: 6b9ee6fe1c       imul bx, word ptr [bp - 0x11a], 0x1c
  038529  1B99: 8a874731         mov al, byte ptr [bx + 0x3147]
  03852D  1B9D: 240f             and al, 0xf
  03852F  1B9F: 3a4606           cmp al, byte ptr [bp + 6]
  038532  1BA2: 7522             jne 0x1bc6
  038534  1BA4: ffb6e6fe         push word ptr [bp - 0x11a]
  038538  1BA8: 9a280b1f18       lcall 0x181f, 0xb28
  03853D  1BAD: 83c402           add sp, 2
  038540  1BB0: 0bc0             or ax, ax
  038542  1BB2: 7412             je 0x1bc6
  038544  1BB4: 6b9ee6fe1c       imul bx, word ptr [bp - 0x11a], 0x1c
  038549  1BB9: 8a875b31         mov al, byte ptr [bx + 0x315b]
  03854D  1BBD: 98               cwde 
  03854E  1BBE: 8bf0             mov si, ax
  038550  1BC0: d1e6             shl si, 1
  038552  1BC2: ff823cff         inc word ptr [bp + si - 0xc4]
  038556  1BC6: ff86e6fe         inc word ptr [bp - 0x11a]
  03855A  1BCA: a19c53           mov ax, word ptr [0x539c]
  03855D  1BCD: 3986e6fe         cmp word ptr [bp - 0x11a], ax
  038561  1BD1: 7cc1             jl 0x1b94
  038563  1BD3: 8b8674ff         mov ax, word ptr [bp - 0x8c]
  038567  1BD7: 018662ff         add word ptr [bp - 0x9e], ax
  03856B  1BDB: 8b86f8fe         mov ax, word ptr [bp - 0x108]
  03856F  1BDF: 8986e4fe         mov word ptr [bp - 0x11c], ax
  038573  1BE3: 8b86fafe         mov ax, word ptr [bp - 0x106]
  038577  1BE7: 8986e8fe         mov word ptr [bp - 0x118], ax
  03857B  1BEB: c786eefe6900     mov word ptr [bp - 0x112], 0x69
  038581  1BF1: c786eafe1200     mov word ptr [bp - 0x116], 0x12
  038587  1BF7: 2bc0             sub ax, ax
  038589  1BF9: 8986fefe         mov word ptr [bp - 0x102], ax
  03858D  1BFD: 8986f6fe         mov word ptr [bp - 0x10a], ax
  038591  1C01: 8986f2fe         mov word ptr [bp - 0x10e], ax
  038595  1C05: e93401           jmp 0x1d3c
  038598  1C08: 8b86f2fe         mov ax, word ptr [bp - 0x10e]
  03859C  1C0C: 8986e6fe         mov word ptr [bp - 0x11a], ax
  0385A0  1C10: 3d1300           cmp ax, 0x13
  0385A3  1C13: 7503             jne 0x1c18
  0385A5  1C15: e92001           jmp 0x1d38
  0385A8  1C18: 3d1700           cmp ax, 0x17
  0385AB  1C1B: 7503             jne 0x1c20
  0385AD  1C1D: e91801           jmp 0x1d38
  0385B0  1C20: 3d1200           cmp ax, 0x12
  0385B3  1C23: 7503             jne 0x1c28
  0385B5  1C25: e91001           jmp 0x1d38
  0385B8  1C28: 3d1c00           cmp ax, 0x1c
  0385BB  1C2B: 7506             jne 0x1c33
  0385BD  1C2D: c786e6fe1300     mov word ptr [bp - 0x11a], 0x13
  0385C3  1C33: 8b86e4fe         mov ax, word ptr [bp - 0x11c]
  0385C7  1C37: 8bb6e6fe         mov si, word ptr [bp - 0x11a]
  0385CB  1C3B: d1e6             shl si, 1
  0385CD  1C3D: 898202ff         mov word ptr [bp + si - 0xfe], ax
  0385D1  1C41: 6a03             push 3
  0385D3  1C43: 8b86e6fe         mov ax, word ptr [bp - 0x11a]
  0385D7  1C47: 9ac6021f18       lcall 0x181f, 0x2c6
  0385DC  1C4C: 8b9ee4fe         mov bx, word ptr [bp - 0x11c]
  0385E0  1C50: 4b               dec bx
  0385E1  1C51: 8b96e8fe         mov dx, word ptr [bp - 0x118]
  0385E5  1C55: 8952c6           mov word ptr [bp + si - 0x3a], dx
  0385E8  1C58: 8bfa             mov di, dx
  0385EA  1C5A: 9a4a021f18       lcall 0x181f, 0x24a
  0385EF  1C5F: c68676ff00       mov byte ptr [bp - 0x8a], 0
  0385F4  1C64: 8b9ee6fe         mov bx, word ptr [bp - 0x11a]
  0385F8  1C68: c1e303           shl bx, 3
  0385FB  1C6B: ffb7a48e         push word ptr [bx - 0x715c]
  0385FF  1C6F: 8d8676ff         lea ax, [bp - 0x8a]
  038603  1C73: 50               push ax
  038604  1C74: 9a6e011f18       lcall 0x181f, 0x16e
  038609  1C79: 83c404           add sp, 4
  03860C  1C7C: ff36a008         push word ptr [0x8a0]
  038610  1C80: ff369e08         push word ptr [0x89e]
  038614  1C84: 8d8676ff         lea ax, [bp - 0x8a]
  038618  1C88: 16               push ss
  038619  1C89: 50               push ax
  03861A  1C8A: 2bc0             sub ax, ax
  03861C  1C8C: 9a04021f18       lcall 0x181f, 0x204
  038621  1C91: 48               dec ax
  038622  1C92: 8986e2fe         mov word ptr [bp - 0x11e], ax
  038626  1C96: 689200           push 0x92
  038629  1C99: 8b86e4fe         mov ax, word ptr [bp - 0x11c]
  03862D  1C9D: 40               inc ax
  03862E  1C9E: 50               push ax
  03862F  1C9F: 8d4d0c           lea cx, [di + 0xc]
  038632  1CA2: 51               push cx
  038633  1CA3: 8d8e76ff         lea cx, [bp - 0x8a]
  038637  1CA7: 16               push ss
  038638  1CA8: 51               push cx
  038639  1CA9: 8986e0fe         mov word ptr [bp - 0x120], ax
  03863D  1CAD: 9a3c011f18       lcall 0x181f, 0x13c
  038642  1CB2: 83c40a           add sp, 0xa
  038645  1CB5: c41e9e08         les bx, ptr [0x89e]
  038649  1CB9: 268a07           mov al, byte ptr es:[bx]
  03864C  1CBC: 2ae4             sub ah, ah
  03864E  1CBE: 0386e0fe         add ax, word ptr [bp - 0x120]
  038652  1CC2: 40               inc ax
  038653  1CC3: 8986f0fe         mov word ptr [bp - 0x110], ax
  038657  1CC7: c68676ff00       mov byte ptr [bp - 0x8a], 0
  03865C  1CCC: ffb23cff         push word ptr [bp + si - 0xc4]
  038660  1CD0: 8d8676ff         lea ax, [bp - 0x8a]
  038664  1CD4: 16               push ss
  038665  1CD5: 50               push ax
  038666  1CD6: 9a82011f18       lcall 0x181f, 0x182
  03866B  1CDB: 83c406           add sp, 6
  03866E  1CDE: 8d4527           lea ax, [di + 0x27]
  038671  1CE1: 8986f4fe         mov word ptr [bp - 0x10c], ax
  038675  1CE5: 6a61             push 0x61
  038677  1CE7: ffb6f0fe         push word ptr [bp - 0x110]
  03867B  1CEB: 50               push ax
  03867C  1CEC: 8d8676ff         lea ax, [bp - 0x8a]
  038680  1CF0: 16               push ss
  038681  1CF1: 50               push ax
  038682  1CF2: 9a3c011f18       lcall 0x181f, 0x13c
  038687  1CF7: 83c40a           add sp, 0xa
  03868A  1CFA: 8b86eafe         mov ax, word ptr [bp - 0x116]
  03868E  1CFE: 0186e4fe         add word ptr [bp - 0x11c], ax
  038692  1D02: 83bef6fe01       cmp word ptr [bp - 0x10a], 1
  038697  1D07: 1bc0             sbb ax, ax
  038699  1D09: 40               inc ax
  03869A  1D0A: 050800           add ax, 8
  03869D  1D0D: ff86fefe         inc word ptr [bp - 0x102]
  0386A1  1D11: 3b86fefe         cmp ax, word ptr [bp - 0x102]
  0386A5  1D15: 7f21             jg 0x1d38
  0386A7  1D17: 83bef6fe02       cmp word ptr [bp - 0x10a], 2
  0386AC  1D1C: 7d1a             jge 0x1d38
  0386AE  1D1E: c786fefe0000     mov word ptr [bp - 0x102], 0
  0386B4  1D24: ff86f6fe         inc word ptr [bp - 0x10a]
  0386B8  1D28: 8b86f8fe         mov ax, word ptr [bp - 0x108]
  0386BC  1D2C: 8986e4fe         mov word ptr [bp - 0x11c], ax
  0386C0  1D30: 03beeefe         add di, word ptr [bp - 0x112]
  0386C4  1D34: 89bee8fe         mov word ptr [bp - 0x118], di
  0386C8  1D38: ff86f2fe         inc word ptr [bp - 0x10e]
  0386CC  1D3C: 83bef2fe1d       cmp word ptr [bp - 0x10e], 0x1d
  0386D1  1D41: 7d03             jge 0x1d46
  0386D3  1D43: e9c2fe           jmp 0x1c08
  0386D6  1D46: 6aff             push -1
  0386D8  1D48: 6afe             push -2
  0386DA  1D4A: 0e               push cs
  0386DB  1D4B: e85217           call 0x34a0
  0386DE  1D4E: 83c404           add sp, 4
  0386E1  1D51: 6a00             push 0
  0386E3  1D53: 684001           push 0x140
  0386E6  1D56: 68c800           push 0xc8
  0386E9  1D59: 2bc0             sub ax, ax
  0386EB  1D5B: 99               cdq 
  0386EC  1D5C: 2bdb             sub bx, bx
  0386EE  1D5E: 9ae2001f18       lcall 0x181f, 0xe2
  0386F3  1D63: 9ac0031f18       lcall 0x181f, 0x3c0
  0386F8  1D68: 898600ff         mov word ptr [bp - 0x100], ax
  0386FC  1D6C: 0bc0             or ax, ax
  0386FE  1D6E: 7574             jne 0x1de4
  038700  1D70: c786e6feffff     mov word ptr [bp - 0x11a], 0xffff
  038706  1D76: 813ee8071e01     cmp word ptr [0x7e8], 0x11e
  03870C  1D7C: 7c08             jl 0x1d86
  03870E  1D7E: 813eea07b800     cmp word ptr [0x7ea], 0xb8
  038714  1D84: 7d3a             jge 0x1dc0
  038716  1D86: c786f2fe0000     mov word ptr [bp - 0x10e], 0
  03871C  1D8C: ffb6eafe         push word ptr [bp - 0x116]
  038720  1D90: ffb6eefe         push word ptr [bp - 0x112]
  038724  1D94: 8bb6f2fe         mov si, word ptr [bp - 0x10e]
  038728  1D98: d1e6             shl si, 1
  03872A  1D9A: ffb202ff         push word ptr [bp + si - 0xfe]
  03872E  1D9E: ff72c6           push word ptr [bp + si - 0x3a]
  038731  1DA1: 9aca031f18       lcall 0x181f, 0x3ca
  038736  1DA6: 83c408           add sp, 8
  038739  1DA9: 0bc0             or ax, ax
  03873B  1DAB: 7408             je 0x1db5
  03873D  1DAD: 8b86f2fe         mov ax, word ptr [bp - 0x10e]
  038741  1DB1: 8986e6fe         mov word ptr [bp - 0x11a], ax
  038745  1DB5: ff86f2fe         inc word ptr [bp - 0x10e]
  038749  1DB9: 83bef2fe1d       cmp word ptr [bp - 0x10e], 0x1d
  03874E  1DBE: 7ccc             jl 0x1d8c
  038750  1DC0: 83bee6fe00       cmp word ptr [bp - 0x11a], 0
  038755  1DC5: 7c1d             jl 0x1de4
  038757  1DC7: 8bb6e6fe         mov si, word ptr [bp - 0x11a]
  03875B  1DCB: d1e6             shl si, 1
  03875D  1DCD: ffb23cff         push word ptr [bp + si - 0xc4]
  038761  1DD1: ffb6e6fe         push word ptr [bp - 0x11a]
  038765  1DD5: ff7606           push word ptr [bp + 6]
  038768  1DD8: 0e               push cs
  038769  1DD9: e8e216           call 0x34be
  03876C  1DDC: 83c406           add sp, 6
  03876F  1DDF: e9acfc           jmp 0x1a8e
  038772  1DE2: 90               nop 
  038773  1DE3: 90               nop 
  038774  1DE4: 5e               pop si
  038775  1DE5: 5f               pop di
  038776  1DE6: c9               leave 
  038777  1DE7: cb               retf 

; ---- func_038778  size=280  insns=88  prologue=ENTER 0x0006,0  terminal=RETF ----
  038778  1DE8: c8060000         enter 6, 0
  03877C  1DEC: ff7606           push word ptr [bp + 6]
  03877F  1DEF: 9a82051f18       lcall 0x181f, 0x582
  038784  1DF4: 83c402           add sp, 2
  038787  1DF7: 6a05             push 5
  038789  1DF9: 0e               push cs
  03878A  1DFA: e8c616           call 0x34c3
  03878D  1DFD: 83c402           add sp, 2
  038790  1E00: 689000           push 0x90
  038793  1E03: 6a05             push 5
  038795  1E05: 684001           push 0x140
  038798  1E08: 6a00             push 0
  03879A  1E0A: ff361e2e         push word ptr [0x2e1e]
  03879E  1E0E: 9a22001f18       lcall 0x181f, 0x22
  0387A3  1E13: 83c402           add sp, 2
  0387A6  1E16: 52               push dx
  0387A7  1E17: 50               push ax
  0387A8  1E18: 9a00011f18       lcall 0x181f, 0x100
  0387AD  1E1D: 83c40c           add sp, 0xc
  0387B0  1E20: 689100           push 0x91
  0387B3  1E23: c41e9e08         les bx, ptr [0x89e]
  0387B7  1E27: 268a07           mov al, byte ptr es:[bx]
  0387BA  1E2A: 2ae4             sub ah, ah
  0387BC  1E2C: 050600           add ax, 6
  0387BF  1E2F: 50               push ax
  0387C0  1E30: 684001           push 0x140
  0387C3  1E33: 6a00             push 0
  0387C5  1E35: ff36582f         push word ptr [0x2f58]
  0387C9  1E39: 9a22001f18       lcall 0x181f, 0x22
  0387CE  1E3E: 83c402           add sp, 2
  0387D1  1E41: 52               push dx
  0387D2  1E42: 50               push ax
  0387D3  1E43: 9a00011f18       lcall 0x181f, 0x100
  0387D8  1E48: 83c40c           add sp, 0xc
  0387DB  1E4B: c746fe5a00       mov word ptr [bp - 2], 0x5a
  0387E0  1E50: c746fc1900       mov word ptr [bp - 4], 0x19
  0387E5  1E55: ff36ae2d         push word ptr [0x2dae]
  0387E9  1E59: ff36ac2d         push word ptr [0x2dac]
  0387ED  1E5D: ff36aa2d         push word ptr [0x2daa]
  0387F1  1E61: ff36a82d         push word ptr [0x2da8]
  0387F5  1E65: 6a77             push 0x77
  0387F7  1E67: b85700           mov ax, 0x57
  0387FA  1E6A: ba1900           mov dx, 0x19
  0387FD  1E6D: bbb200           mov bx, 0xb2
  038800  1E70: 9ab2081f19       lcall 0x191f, 0x8b2
  038805  1E75: c746fa0000       mov word ptr [bp - 6], 0
  03880A  1E7A: ff364008         push word ptr [0x840]
  03880E  1E7E: ff363e08         push word ptr [0x83e]
  038812  1E82: 8b46fc           mov ax, word ptr [bp - 4]
  038815  1E85: 40               inc ax
  038816  1E86: 40               inc ax
  038817  1E87: 50               push ax
  038818  1E88: 8b46fa           mov ax, word ptr [bp - 6]
  03881B  1E8B: 051700           add ax, 0x17
  03881E  1E8E: 8d1ea82d         lea bx, [0x2da8]
  038822  1E92: 8b56fe           mov dx, word ptr [bp - 2]
  038825  1E95: 9a54021f18       lcall 0x181f, 0x254
  03882A  1E9A: ff36ae2d         push word ptr [0x2dae]
  03882E  1E9E: ff36ac2d         push word ptr [0x2dac]
  038832  1EA2: ff36aa2d         push word ptr [0x2daa]
  038836  1EA6: ff36a82d         push word ptr [0x2da8]
  03883A  1EAA: 6a77             push 0x77
  03883C  1EAC: 8346fe0e         add word ptr [bp - 2], 0xe
  038840  1EB0: 8b46fe           mov ax, word ptr [bp - 2]
  038843  1EB3: 2d0300           sub ax, 3
  038846  1EB6: ba1900           mov dx, 0x19
  038849  1EB9: bbb200           mov bx, 0xb2
  03884C  1EBC: 9ab2081f19       lcall 0x191f, 0x8b2
  038851  1EC1: ff46fa           inc word ptr [bp - 6]
  038854  1EC4: 837efa10         cmp word ptr [bp - 6], 0x10
  038858  1EC8: 7cb0             jl 0x1e7a
  03885A  1ECA: c746fa0000       mov word ptr [bp - 6], 0
  03885F  1ECF: ff36ae2d         push word ptr [0x2dae]
  038863  1ED3: ff36ac2d         push word ptr [0x2dac]
  038867  1ED7: ff36aa2d         push word ptr [0x2daa]
  03886B  1EDB: ff36a82d         push word ptr [0x2da8]
  03886F  1EDF: 6a77             push 0x77
  038871  1EE1: 8b5efa           mov bx, word ptr [bp - 6]
  038874  1EE4: c1e303           shl bx, 3
  038877  1EE7: 83c32a           add bx, 0x2a
  03887A  1EEA: b80200           mov ax, 2
  03887D  1EED: ba3701           mov dx, 0x137
  038880  1EF0: 9abc081f19       lcall 0x191f, 0x8bc
  038885  1EF5: ff46fa           inc word ptr [bp - 6]
  038888  1EF8: 837efa12         cmp word ptr [bp - 6], 0x12
  03888C  1EFC: 7cd1             jl 0x1ecf
  03888E  1EFE: c9               leave 
  03888F  1EFF: cb               retf 

; ---- func_038890  size=447  insns=156  prologue=ENTER 0x0066,0  terminal=RETF ----
  038890  1F00: c8660000         enter 0x66, 0
  038894  1F04: 56               push si
  038895  1F05: ff7606           push word ptr [bp + 6]
  038898  1F08: 0e               push cs
  038899  1F09: e89915           call 0x34a5
  03889C  1F0C: 83c402           add sp, 2
  03889F  1F0F: c746aa0200       mov word ptr [bp - 0x56], 2
  0388A4  1F14: c746a82a00       mov word ptr [bp - 0x58], 0x2a
  0388A9  1F19: 2bc0             sub ax, ax
  0388AB  1F1B: 8946ae           mov word ptr [bp - 0x52], ax
  0388AE  1F1E: 89469c           mov word ptr [bp - 0x64], ax
  0388B1  1F21: 8946a4           mov word ptr [bp - 0x5c], ax
  0388B4  1F24: e95b01           jmp 0x2082
  0388B7  1F27: 90               nop 
  0388B8  1F28: 50               push ax
  0388B9  1F29: 9ae6091f18       lcall 0x181f, 0x9e6
  0388BE  1F2E: 83c402           add sp, 2
  0388C1  1F31: 8a4606           mov al, byte ptr [bp + 6]
  0388C4  1F34: 8b1e4285         mov bx, word ptr [0x8542]
  0388C8  1F38: 38471a           cmp byte ptr [bx + 0x1a], al
  0388CB  1F3B: 7403             je 0x1f40
  0388CD  1F3D: e93f01           jmp 0x207f
  0388D0  1F40: 689200           push 0x92
  0388D3  1F43: 8b46a8           mov ax, word ptr [bp - 0x58]
  0388D6  1F46: 40               inc ax
  0388D7  1F47: 40               inc ax
  0388D8  1F48: 50               push ax
  0388D9  1F49: ff76aa           push word ptr [bp - 0x56]
  0388DC  1F4C: 8bc3             mov ax, bx
  0388DE  1F4E: 40               inc ax
  0388DF  1F4F: 40               inc ax
  0388E0  1F50: 1e               push ds
  0388E1  1F51: 50               push ax
  0388E2  1F52: 9a3c011f18       lcall 0x181f, 0x13c
  0388E7  1F57: 83c40a           add sp, 0xa
  0388EA  1F5A: c7469e5500       mov word ptr [bp - 0x62], 0x55
  0388EF  1F5F: c746a00000       mov word ptr [bp - 0x60], 0
  0388F4  1F64: 6a0a             push 0xa
  0388F6  1F66: 8d46b0           lea ax, [bp - 0x50]
  0388F9  1F69: 50               push ax
  0388FA  1F6A: 8b76a0           mov si, word ptr [bp - 0x60]
  0388FD  1F6D: d1e6             shl si, 1
  0388FF  1F6F: 8b1e4285         mov bx, word ptr [0x8542]
  038903  1F73: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  038907  1F77: 8946ac           mov word ptr [bp - 0x54], ax
  03890A  1F7A: 50               push ax
  03890B  1F7B: 9afa081d0d       lcall 0xd1d, 0x8fa
  038910  1F80: 83c406           add sp, 6
  038913  1F83: c7469a0000       mov word ptr [bp - 0x66], 0
  038918  1F88: 837eac00         cmp word ptr [bp - 0x54], 0
  03891C  1F8C: 7405             je 0x1f93
  03891E  1F8E: c7469a6100       mov word ptr [bp - 0x66], 0x61
  038923  1F93: 837eac64         cmp word ptr [bp - 0x54], 0x64
  038927  1F97: 7c05             jl 0x1f9e
  038929  1F99: c7469a9200       mov word ptr [bp - 0x66], 0x92
  03892E  1F9E: 8b469e           mov ax, word ptr [bp - 0x62]
  038931  1FA1: 8946a6           mov word ptr [bp - 0x5a], ax
  038934  1FA4: 817eace803       cmp word ptr [bp - 0x54], 0x3e8
  038939  1FA9: 7d06             jge 0x1fb1
  03893B  1FAB: 050400           add ax, 4
  03893E  1FAE: 8946a6           mov word ptr [bp - 0x5a], ax
  038941  1FB1: 837eac64         cmp word ptr [bp - 0x54], 0x64
  038945  1FB5: 7d04             jge 0x1fbb
  038947  1FB7: 8346a604         add word ptr [bp - 0x5a], 4
  03894B  1FBB: 837eac0a         cmp word ptr [bp - 0x54], 0xa
  03894F  1FBF: 7d04             jge 0x1fc5
  038951  1FC1: 8346a604         add word ptr [bp - 0x5a], 4
  038955  1FC5: 817eace803       cmp word ptr [bp - 0x54], 0x3e8
  03895A  1FCA: 7c3d             jl 0x2009
  03895C  1FCC: 6a0a             push 0xa
  03895E  1FCE: 8d46b0           lea ax, [bp - 0x50]
  038961  1FD1: 50               push ax
  038962  1FD2: 8b46ac           mov ax, word ptr [bp - 0x54]
  038965  1FD5: b9e803           mov cx, 0x3e8
  038968  1FD8: 99               cdq 
  038969  1FD9: f7f9             idiv cx
  03896B  1FDB: 50               push ax
  03896C  1FDC: 9afa081d0d       lcall 0xd1d, 0x8fa
  038971  1FE1: 83c406           add sp, 6
  038974  1FE4: 8d46b0           lea ax, [bp - 0x50]
  038977  1FE7: 50               push ax
  038978  1FE8: 9a78011f18       lcall 0x181f, 0x178
  03897D  1FED: 83c402           add sp, 2
  038980  1FF0: ff362c2e         push word ptr [0x2e2c]
  038984  1FF4: 8d46b0           lea ax, [bp - 0x50]
  038987  1FF7: 50               push ax
  038988  1FF8: 9a6e011f18       lcall 0x181f, 0x16e
  03898D  1FFD: 83c404           add sp, 4
  038990  2000: c7469a0e00       mov word ptr [bp - 0x66], 0xe
  038995  2005: 8346a604         add word ptr [bp - 0x5a], 4
  038999  2009: ff769a           push word ptr [bp - 0x66]
  03899C  200C: 8b46a8           mov ax, word ptr [bp - 0x58]
  03899F  200F: 40               inc ax
  0389A0  2010: 40               inc ax
  0389A1  2011: 50               push ax
  0389A2  2012: ff76a6           push word ptr [bp - 0x5a]
  0389A5  2015: 8d46b0           lea ax, [bp - 0x50]
  0389A8  2018: 16               push ss
  0389A9  2019: 50               push ax
  0389AA  201A: 9a3c011f18       lcall 0x181f, 0x13c
  0389AF  201F: 83c40a           add sp, 0xa
  0389B2  2022: 83469e0e         add word ptr [bp - 0x62], 0xe
  0389B6  2026: ff46a0           inc word ptr [bp - 0x60]
  0389B9  2029: 837ea010         cmp word ptr [bp - 0x60], 0x10
  0389BD  202D: 7d03             jge 0x2032
  0389BF  202F: e932ff           jmp 0x1f64
  0389C2  2032: 8346a808         add word ptr [bp - 0x58], 8
  0389C6  2036: ff469c           inc word ptr [bp - 0x64]
  0389C9  2039: 837e9c11         cmp word ptr [bp - 0x64], 0x11
  0389CD  203D: 7c40             jl 0x207f
  0389CF  203F: 6aff             push -1
  0389D1  2041: 6afe             push -2
  0389D3  2043: 0e               push cs
  0389D4  2044: e85914           call 0x34a0
  0389D7  2047: 83c404           add sp, 4
  0389DA  204A: 6a00             push 0
  0389DC  204C: 684001           push 0x140
  0389DF  204F: 68c800           push 0xc8
  0389E2  2052: 2bc0             sub ax, ax
  0389E4  2054: 99               cdq 
  0389E5  2055: 2bdb             sub bx, bx
  0389E7  2057: 9ae2001f18       lcall 0x181f, 0xe2
  0389EC  205C: 9ac0031f18       lcall 0x181f, 0x3c0
  0389F1  2061: ff7606           push word ptr [bp + 6]
  0389F4  2064: 0e               push cs
  0389F5  2065: e83d14           call 0x34a5
  0389F8  2068: 83c402           add sp, 2
  0389FB  206B: c746aa0200       mov word ptr [bp - 0x56], 2
  038A00  2070: c746a82a00       mov word ptr [bp - 0x58], 0x2a
  038A05  2075: c7469c0000       mov word ptr [bp - 0x64], 0
  038A0A  207A: c746ae0100       mov word ptr [bp - 0x52], 1
  038A0F  207F: ff46a4           inc word ptr [bp - 0x5c]
  038A12  2082: 8b46a4           mov ax, word ptr [bp - 0x5c]
  038A15  2085: 39069e53         cmp word ptr [0x539e], ax
  038A19  2089: 7e03             jle 0x208e
  038A1B  208B: e99afe           jmp 0x1f28
  038A1E  208E: 837e9c00         cmp word ptr [bp - 0x64], 0
  038A22  2092: 7506             jne 0x209a
  038A24  2094: 837eae00         cmp word ptr [bp - 0x52], 0
  038A28  2098: 7522             jne 0x20bc
  038A2A  209A: 6aff             push -1
  038A2C  209C: 6afe             push -2
  038A2E  209E: 0e               push cs
  038A2F  209F: e8fe13           call 0x34a0
  038A32  20A2: 83c404           add sp, 4
  038A35  20A5: 6a00             push 0
  038A37  20A7: 684001           push 0x140
  038A3A  20AA: 68c800           push 0xc8
  038A3D  20AD: 2bc0             sub ax, ax
  038A3F  20AF: 99               cdq 
  038A40  20B0: 2bdb             sub bx, bx
  038A42  20B2: 9ae2001f18       lcall 0x181f, 0xe2
  038A47  20B7: 9ac0031f18       lcall 0x181f, 0x3c0
  038A4C  20BC: 5e               pop si
  038A4D  20BD: c9               leave 
  038A4E  20BE: cb               retf 

; ---- func_038A50  size=1155  insns=396  prologue=ENTER 0x008C,0  terminal=RETF ----
  038A50  20C0: c88c0000         enter 0x8c, 0
  038A54  20C4: 56               push si
  038A55  20C5: ff7606           push word ptr [bp + 6]
  038A58  20C8: 9a82051f18       lcall 0x181f, 0x582
  038A5D  20CD: 83c402           add sp, 2
  038A60  20D0: 6a05             push 5
  038A62  20D2: 0e               push cs
  038A63  20D3: e8ed13           call 0x34c3
  038A66  20D6: 83c402           add sp, 2
  038A69  20D9: 689000           push 0x90
  038A6C  20DC: 6a05             push 5
  038A6E  20DE: 684001           push 0x140
  038A71  20E1: 6a00             push 0
  038A73  20E3: ff361e2e         push word ptr [0x2e1e]
  038A77  20E7: 9a22001f18       lcall 0x181f, 0x22
  038A7C  20EC: 83c402           add sp, 2
  038A7F  20EF: 52               push dx
  038A80  20F0: 50               push ax
  038A81  20F1: 9a00011f18       lcall 0x181f, 0x100
  038A86  20F6: 83c40c           add sp, 0xc
  038A89  20F9: 689100           push 0x91
  038A8C  20FC: c41e9e08         les bx, ptr [0x89e]
  038A90  2100: 268a07           mov al, byte ptr es:[bx]
  038A93  2103: 2ae4             sub ah, ah
  038A95  2105: 050600           add ax, 6
  038A98  2108: 50               push ax
  038A99  2109: 684001           push 0x140
  038A9C  210C: 6a00             push 0
  038A9E  210E: ff36562f         push word ptr [0x2f56]
  038AA2  2112: 9a22001f18       lcall 0x181f, 0x22
  038AA7  2117: 83c402           add sp, 2
  038AAA  211A: 52               push dx
  038AAB  211B: 50               push ax
  038AAC  211C: 9a00011f18       lcall 0x181f, 0x100
  038AB1  2121: 83c40c           add sp, 0xc
  038AB4  2124: ff36ae2d         push word ptr [0x2dae]
  038AB8  2128: ff36ac2d         push word ptr [0x2dac]
  038ABC  212C: ff36aa2d         push word ptr [0x2daa]
  038AC0  2130: ff36a82d         push word ptr [0x2da8]
  038AC4  2134: 6a77             push 0x77
  038AC6  2136: b84300           mov ax, 0x43
  038AC9  2139: ba1900           mov dx, 0x19
  038ACC  213C: bba100           mov bx, 0xa1
  038ACF  213F: 9ab2081f19       lcall 0x191f, 0x8b2
  038AD4  2144: c646ac00         mov byte ptr [bp - 0x54], 0
  038AD8  2148: ff362e2e         push word ptr [0x2e2e]
  038ADC  214C: 8d46ac           lea ax, [bp - 0x54]
  038ADF  214F: 50               push ax
  038AE0  2150: 9a6e011f18       lcall 0x181f, 0x16e
  038AE5  2155: 83c404           add sp, 4
  038AE8  2158: 689200           push 0x92
  038AEB  215B: b81900           mov ax, 0x19
  038AEE  215E: 8946a6           mov word ptr [bp - 0x5a], ax
  038AF1  2161: 898678ff         mov word ptr [bp - 0x88], ax
  038AF5  2165: 50               push ax
  038AF6  2166: 6a4c             push 0x4c
  038AF8  2168: 8d46ac           lea ax, [bp - 0x54]
  038AFB  216B: 16               push ss
  038AFC  216C: 50               push ax
  038AFD  216D: 9a3c011f18       lcall 0x181f, 0x13c
  038B02  2172: 83c40a           add sp, 0xa
  038B05  2175: c646ac00         mov byte ptr [bp - 0x54], 0
  038B09  2179: ff36302e         push word ptr [0x2e30]
  038B0D  217D: 8d46ac           lea ax, [bp - 0x54]
  038B10  2180: 50               push ax
  038B11  2181: 9a6e011f18       lcall 0x181f, 0x16e
  038B16  2186: 83c404           add sp, 4
  038B19  2189: 689200           push 0x92
  038B1C  218C: 6a19             push 0x19
  038B1E  218E: ff36a008         push word ptr [0x8a0]
  038B22  2192: ff369e08         push word ptr [0x89e]
  038B26  2196: 8d46ac           lea ax, [bp - 0x54]
  038B29  2199: 16               push ss
  038B2A  219A: 50               push ax
  038B2B  219B: 2bc0             sub ax, ax
  038B2D  219D: 9a04021f18       lcall 0x181f, 0x204
  038B32  21A2: 48               dec ax
  038B33  21A3: 898674ff         mov word ptr [bp - 0x8c], ax
  038B37  21A7: 2d9000           sub ax, 0x90
  038B3A  21AA: f7d8             neg ax
  038B3C  21AC: 50               push ax
  038B3D  21AD: 8d46ac           lea ax, [bp - 0x54]
  038B40  21B0: 16               push ss
  038B41  21B1: 50               push ax
  038B42  21B2: 9a3c011f18       lcall 0x181f, 0x13c
  038B47  21B7: 83c40a           add sp, 0xa
  038B4A  21BA: c646ac00         mov byte ptr [bp - 0x54], 0
  038B4E  21BE: ff36502f         push word ptr [0x2f50]
  038B52  21C2: 8d46ac           lea ax, [bp - 0x54]
  038B55  21C5: 50               push ax
  038B56  21C6: 9a6e011f18       lcall 0x181f, 0x16e
  038B5B  21CB: 83c404           add sp, 4
  038B5E  21CE: 689200           push 0x92
  038B61  21D1: 6a19             push 0x19
  038B63  21D3: b8aa00           mov ax, 0xaa
  038B66  21D6: 8946a8           mov word ptr [bp - 0x58], ax
  038B69  21D9: 50               push ax
  038B6A  21DA: 8d46ac           lea ax, [bp - 0x54]
  038B6D  21DD: 16               push ss
  038B6E  21DE: 50               push ax
  038B6F  21DF: 9a3c011f18       lcall 0x181f, 0x13c
  038B74  21E4: 83c40a           add sp, 0xa
  038B77  21E7: c646ac00         mov byte ptr [bp - 0x54], 0
  038B7B  21EB: ff36522f         push word ptr [0x2f52]
  038B7F  21EF: 8d46ac           lea ax, [bp - 0x54]
  038B82  21F2: 50               push ax
  038B83  21F3: 9a6e011f18       lcall 0x181f, 0x16e
  038B88  21F8: 83c404           add sp, 4
  038B8B  21FB: 689200           push 0x92
  038B8E  21FE: 6a19             push 0x19
  038B90  2200: b8dc00           mov ax, 0xdc
  038B93  2203: 89867aff         mov word ptr [bp - 0x86], ax
  038B97  2207: 50               push ax
  038B98  2208: 8d46ac           lea ax, [bp - 0x54]
  038B9B  220B: 16               push ss
  038B9C  220C: 50               push ax
  038B9D  220D: 9a3c011f18       lcall 0x181f, 0x13c
  038BA2  2212: 83c40a           add sp, 0xa
  038BA5  2215: c7867cff0000     mov word ptr [bp - 0x84], 0
  038BAB  221B: ff36ae2d         push word ptr [0x2dae]
  038BAF  221F: ff36ac2d         push word ptr [0x2dac]
  038BB3  2223: ff36aa2d         push word ptr [0x2daa]
  038BB7  2227: ff36a82d         push word ptr [0x2da8]
  038BBB  222B: 6a77             push 0x77
  038BBD  222D: 8b9e7cff         mov bx, word ptr [bp - 0x84]
  038BC1  2231: c1e303           shl bx, 3
  038BC4  2234: 83c321           add bx, 0x21
  038BC7  2237: b80200           mov ax, 2
  038BCA  223A: ba3801           mov dx, 0x138
  038BCD  223D: 9abc081f19       lcall 0x191f, 0x8bc
  038BD2  2242: ff867cff         inc word ptr [bp - 0x84]
  038BD6  2246: 83be7cff11       cmp word ptr [bp - 0x84], 0x11
  038BDB  224B: 7cce             jl 0x221b
  038BDD  224D: c746a80200       mov word ptr [bp - 0x58], 2
  038BE2  2252: c746a62100       mov word ptr [bp - 0x5a], 0x21
  038BE7  2257: c7867cff0000     mov word ptr [bp - 0x84], 0
  038BED  225D: e94b02           jmp 0x24ab
  038BF0  2260: f75efc           neg word ptr [bp - 4]
  038BF3  2263: 8356fe00         adc word ptr [bp - 2], 0
  038BF7  2267: f75efe           neg word ptr [bp - 2]
  038BFA  226A: c78676ff0400     mov word ptr [bp - 0x8a], 4
  038C00  2270: c6867eff00       mov byte ptr [bp - 0x82], 0
  038C05  2275: 837efe00         cmp word ptr [bp - 2], 0
  038C09  2279: 7c28             jl 0x22a3
  038C0B  227B: 7f07             jg 0x2284
  038C0D  227D: 817efc1027       cmp word ptr [bp - 4], 0x2710
  038C12  2282: 721f             jb 0x22a3
  038C14  2284: 6a00             push 0
  038C16  2286: 68e803           push 0x3e8
  038C19  2289: 8d46fc           lea ax, [bp - 4]
  038C1C  228C: 50               push ax
  038C1D  228D: 9a920f1d0d       lcall 0xd1d, 0xf92
  038C22  2292: ff362c2e         push word ptr [0x2e2c]
  038C26  2296: 8d867eff         lea ax, [bp - 0x82]
  038C2A  229A: 50               push ax
  038C2B  229B: 9a6e011f18       lcall 0x181f, 0x16e
  038C30  22A0: 83c404           add sp, 4
  038C33  22A3: c646ac00         mov byte ptr [bp - 0x54], 0
  038C37  22A7: ff76fe           push word ptr [bp - 2]
  038C3A  22AA: ff76fc           push word ptr [bp - 4]
  038C3D  22AD: 8d46ac           lea ax, [bp - 0x54]
  038C40  22B0: 16               push ss
  038C41  22B1: 50               push ax
  038C42  22B2: 9ad2011f18       lcall 0x181f, 0x1d2
  038C47  22B7: 83c408           add sp, 8
  038C4A  22BA: 8d867eff         lea ax, [bp - 0x82]
  038C4E  22BE: 50               push ax
  038C4F  22BF: 8d46ac           lea ax, [bp - 0x54]
  038C52  22C2: 50               push ax
  038C53  22C3: 9aa4071d0d       lcall 0xd1d, 0x7a4
  038C58  22C8: 83c404           add sp, 4
  038C5B  22CB: 838676ff08       add word ptr [bp - 0x8a], 8
  038C60  22D0: ffb676ff         push word ptr [bp - 0x8a]
  038C64  22D4: 8b46a6           mov ax, word ptr [bp - 0x5a]
  038C67  22D7: 40               inc ax
  038C68  22D8: 40               inc ax
  038C69  22D9: 50               push ax
  038C6A  22DA: ff36a008         push word ptr [0x8a0]
  038C6E  22DE: ff369e08         push word ptr [0x89e]
  038C72  22E2: 8d46ac           lea ax, [bp - 0x54]
  038C75  22E5: 16               push ss
  038C76  22E6: 50               push ax
  038C77  22E7: 2bc0             sub ax, ax
  038C79  22E9: 9a04021f18       lcall 0x181f, 0x204
  038C7E  22EE: 48               dec ax
  038C7F  22EF: 898674ff         mov word ptr [bp - 0x8c], ax
  038C83  22F3: 2b867aff         sub ax, word ptr [bp - 0x86]
  038C87  22F7: f7d8             neg ax
  038C89  22F9: 051500           add ax, 0x15
  038C8C  22FC: 50               push ax
  038C8D  22FD: 8d46ac           lea ax, [bp - 0x54]
  038C90  2300: 16               push ss
  038C91  2301: 50               push ax
  038C92  2302: 9a3c011f18       lcall 0x181f, 0x13c
  038C97  2307: 83c40a           add sp, 0xa
  038C9A  230A: 6b5e064f         imul bx, word ptr [bp + 6], 0x4f
  038C9E  230E: 039e7cff         add bx, word ptr [bp - 0x84]
  038CA2  2312: c1e302           shl bx, 2
  038CA5  2315: 8b878488         mov ax, word ptr [bx - 0x777c]
  038CA9  2319: 8b978688         mov dx, word ptr [bx - 0x777a]
  038CAD  231D: 8946fc           mov word ptr [bp - 4], ax
  038CB0  2320: 8956fe           mov word ptr [bp - 2], dx
  038CB3  2323: 0bd2             or dx, dx
  038CB5  2325: 7c09             jl 0x2330
  038CB7  2327: c78676ff0200     mov word ptr [bp - 0x8a], 2
  038CBD  232D: eb11             jmp 0x2340
  038CBF  232F: 90               nop 
  038CC0  2330: c78676ff0400     mov word ptr [bp - 0x8a], 4
  038CC6  2336: f75efc           neg word ptr [bp - 4]
  038CC9  2339: 8356fe00         adc word ptr [bp - 2], 0
  038CCD  233D: f75efe           neg word ptr [bp - 2]
  038CD0  2340: c6867eff00       mov byte ptr [bp - 0x82], 0
  038CD5  2345: 837efe00         cmp word ptr [bp - 2], 0
  038CD9  2349: 7c28             jl 0x2373
  038CDB  234B: 7f07             jg 0x2354
  038CDD  234D: 817efc1027       cmp word ptr [bp - 4], 0x2710
  038CE2  2352: 721f             jb 0x2373
  038CE4  2354: 6a00             push 0
  038CE6  2356: 68e803           push 0x3e8
  038CE9  2359: 8d46fc           lea ax, [bp - 4]
  038CEC  235C: 50               push ax
  038CED  235D: 9a920f1d0d       lcall 0xd1d, 0xf92
  038CF2  2362: ff362c2e         push word ptr [0x2e2c]
  038CF6  2366: 8d867eff         lea ax, [bp - 0x82]
  038CFA  236A: 50               push ax
  038CFB  236B: 9a6e011f18       lcall 0x181f, 0x16e
  038D00  2370: 83c404           add sp, 4
  038D03  2373: c646ac00         mov byte ptr [bp - 0x54], 0
  038D07  2377: ff76fe           push word ptr [bp - 2]
  038D0A  237A: ff76fc           push word ptr [bp - 4]
  038D0D  237D: 8d46ac           lea ax, [bp - 0x54]
  038D10  2380: 16               push ss
  038D11  2381: 50               push ax
  038D12  2382: 9ad2011f18       lcall 0x181f, 0x1d2
  038D17  2387: 83c408           add sp, 8
  038D1A  238A: 8d867eff         lea ax, [bp - 0x82]
  038D1E  238E: 50               push ax
  038D1F  238F: 8d46ac           lea ax, [bp - 0x54]
  038D22  2392: 50               push ax
  038D23  2393: 9aa4071d0d       lcall 0xd1d, 0x7a4
  038D28  2398: 83c404           add sp, 4
  038D2B  239B: 68b411           push 0x11b4
  038D2E  239E: 8d46ac           lea ax, [bp - 0x54]
  038D31  23A1: 50               push ax
  038D32  23A2: 9aa4071d0d       lcall 0xd1d, 0x7a4
  038D37  23A7: 83c404           add sp, 4
  038D3A  23AA: 838676ff08       add word ptr [bp - 0x8a], 8
  038D3F  23AF: ffb676ff         push word ptr [bp - 0x8a]
  038D43  23B3: 8b46a6           mov ax, word ptr [bp - 0x5a]
  038D46  23B6: 40               inc ax
  038D47  23B7: 40               inc ax
  038D48  23B8: 50               push ax
  038D49  23B9: ff36a008         push word ptr [0x8a0]
  038D4D  23BD: ff369e08         push word ptr [0x89e]
  038D51  23C1: 8d4eac           lea cx, [bp - 0x54]
  038D54  23C4: 16               push ss
  038D55  23C5: 51               push cx
  038D56  23C6: 8bf0             mov si, ax
  038D58  23C8: 2bc0             sub ax, ax
  038D5A  23CA: 9a04021f18       lcall 0x181f, 0x204
  038D5F  23CF: 48               dec ax
  038D60  23D0: 898674ff         mov word ptr [bp - 0x8c], ax
  038D64  23D4: 2b867aff         sub ax, word ptr [bp - 0x86]
  038D68  23D8: f7d8             neg ax
  038D6A  23DA: 054a00           add ax, 0x4a
  038D6D  23DD: 50               push ax
  038D6E  23DE: 8d46ac           lea ax, [bp - 0x54]
  038D71  23E1: 16               push ss
  038D72  23E2: 50               push ax
  038D73  23E3: 9a3c011f18       lcall 0x181f, 0x13c
  038D78  23E8: 83c40a           add sp, 0xa
  038D7B  23EB: c646ac00         mov byte ptr [bp - 0x54], 0
  038D7F  23EF: ffb67cff         push word ptr [bp - 0x84]
  038D83  23F3: 9aea091f19       lcall 0x191f, 0x9ea
  038D88  23F8: 83c402           add sp, 2
  038D8B  23FB: 99               cdq 
  038D8C  23FC: 52               push dx
  038D8D  23FD: 50               push ax
  038D8E  23FE: 8d46ac           lea ax, [bp - 0x54]
  038D91  2401: 16               push ss
  038D92  2402: 50               push ax
  038D93  2403: 9ad8001f18       lcall 0x181f, 0xd8
  038D98  2408: 83c408           add sp, 8
  038D9B  240B: b86100           mov ax, 0x61
  038D9E  240E: 898676ff         mov word ptr [bp - 0x8a], ax
  038DA2  2412: 50               push ax
  038DA3  2413: 56               push si
  038DA4  2414: ff36a008         push word ptr [0x8a0]
  038DA8  2418: ff369e08         push word ptr [0x89e]
  038DAC  241C: 8d46ac           lea ax, [bp - 0x54]
  038DAF  241F: 16               push ss
  038DB0  2420: 50               push ax
  038DB1  2421: 2bc0             sub ax, ax
  038DB3  2423: 9a04021f18       lcall 0x181f, 0x204
  038DB8  2428: 48               dec ax
  038DB9  2429: 898674ff         mov word ptr [bp - 0x8c], ax
  038DBD  242D: 83867aff64       add word ptr [bp - 0x86], 0x64
  038DC2  2432: 8b8e7aff         mov cx, word ptr [bp - 0x86]
  038DC6  2436: 2bc8             sub cx, ax
  038DC8  2438: 83c11d           add cx, 0x1d
  038DCB  243B: 51               push cx
  038DCC  243C: 8d46ac           lea ax, [bp - 0x54]
  038DCF  243F: 16               push ss
  038DD0  2440: 50               push ax
  038DD1  2441: 9a3c011f18       lcall 0x181f, 0x13c
  038DD6  2446: 83c40a           add sp, 0xa
  038DD9  2449: c646ac00         mov byte ptr [bp - 0x54], 0
  038DDD  244D: ffb67cff         push word ptr [bp - 0x84]
  038DE1  2451: 9a3e0c1f19       lcall 0x191f, 0xc3e
  038DE6  2456: 83c402           add sp, 2
  038DE9  2459: 99               cdq 
  038DEA  245A: 52               push dx
  038DEB  245B: 50               push ax
  038DEC  245C: 8d46ac           lea ax, [bp - 0x54]
  038DEF  245F: 16               push ss
  038DF0  2460: 50               push ax
  038DF1  2461: 9ad8001f18       lcall 0x181f, 0xd8
  038DF6  2466: 83c408           add sp, 8
  038DF9  2469: 6a61             push 0x61
  038DFB  246B: 56               push si
  038DFC  246C: ff36a008         push word ptr [0x8a0]
  038E00  2470: ff369e08         push word ptr [0x89e]
  038E04  2474: 8d46ac           lea ax, [bp - 0x54]
  038E07  2477: 16               push ss
  038E08  2478: 50               push ax
  038E09  2479: 2bc0             sub ax, ax
  038E0B  247B: 9a04021f18       lcall 0x181f, 0x204
  038E10  2480: 48               dec ax
  038E11  2481: 898674ff         mov word ptr [bp - 0x8c], ax
  038E15  2485: 8b8e7aff         mov cx, word ptr [bp - 0x86]
  038E19  2489: 83c132           add cx, 0x32
  038E1C  248C: 898e7aff         mov word ptr [bp - 0x86], cx
  038E20  2490: 2bc8             sub cx, ax
  038E22  2492: 83c11e           add cx, 0x1e
  038E25  2495: 51               push cx
  038E26  2496: 8d46ac           lea ax, [bp - 0x54]
  038E29  2499: 16               push ss
  038E2A  249A: 50               push ax
  038E2B  249B: 9a3c011f18       lcall 0x181f, 0x13c
  038E30  24A0: 83c40a           add sp, 0xa
  038E33  24A3: 8346a608         add word ptr [bp - 0x5a], 8
  038E37  24A7: ff867cff         inc word ptr [bp - 0x84]
  038E3B  24AB: 83be7cff10       cmp word ptr [bp - 0x84], 0x10
  038E40  24B0: 7d62             jge 0x2514
  038E42  24B2: c646ac00         mov byte ptr [bp - 0x54], 0
  038E46  24B6: 8b9e7cff         mov bx, word ptr [bp - 0x84]
  038E4A  24BA: d1e3             shl bx, 1
  038E4C  24BC: ffb7c097         push word ptr [bx - 0x6840]
  038E50  24C0: 8d46ac           lea ax, [bp - 0x54]
  038E53  24C3: 50               push ax
  038E54  24C4: 9a6e011f18       lcall 0x181f, 0x16e
  038E59  24C9: 83c404           add sp, 4
  038E5C  24CC: 689200           push 0x92
  038E5F  24CF: 8b46a6           mov ax, word ptr [bp - 0x5a]
  038E62  24D2: 40               inc ax
  038E63  24D3: 40               inc ax
  038E64  24D4: 50               push ax
  038E65  24D5: ff76a8           push word ptr [bp - 0x58]
  038E68  24D8: 8d46ac           lea ax, [bp - 0x54]
  038E6B  24DB: 16               push ss
  038E6C  24DC: 50               push ax
  038E6D  24DD: 9a3c011f18       lcall 0x181f, 0x13c
  038E72  24E2: 83c40a           add sp, 0xa
  038E75  24E5: c7867aff4600     mov word ptr [bp - 0x86], 0x46
  038E7B  24EB: 6b5e064f         imul bx, word ptr [bp + 6], 0x4f
  038E7F  24EF: 039e7cff         add bx, word ptr [bp - 0x84]
  038E83  24F3: c1e302           shl bx, 2
  038E86  24F6: 8b87c488         mov ax, word ptr [bx - 0x773c]
  038E8A  24FA: 8b97c688         mov dx, word ptr [bx - 0x773a]
  038E8E  24FE: 8946fc           mov word ptr [bp - 4], ax
  038E91  2501: 8956fe           mov word ptr [bp - 2], dx
  038E94  2504: 0bd2             or dx, dx
  038E96  2506: 7d03             jge 0x250b
  038E98  2508: e955fd           jmp 0x2260
  038E9B  250B: c78676ff0200     mov word ptr [bp - 0x8a], 2
  038EA1  2511: e95cfd           jmp 0x2270
  038EA4  2514: 6aff             push -1
  038EA6  2516: 6afe             push -2
  038EA8  2518: 0e               push cs
  038EA9  2519: e8840f           call 0x34a0
  038EAC  251C: 83c404           add sp, 4
  038EAF  251F: 6a00             push 0
  038EB1  2521: 684001           push 0x140
  038EB4  2524: 68c800           push 0xc8
  038EB7  2527: 2bc0             sub ax, ax
  038EB9  2529: 99               cdq 
  038EBA  252A: 2bdb             sub bx, bx
  038EBC  252C: 9ae2001f18       lcall 0x181f, 0xe2
  038EC1  2531: 9ac0031f18       lcall 0x181f, 0x3c0
  038EC6  2536: ff7606           push word ptr [bp + 6]
  038EC9  2539: 0e               push cs
  038ECA  253A: e87c0f           call 0x34b9
  038ECD  253D: 83c402           add sp, 2
  038ED0  2540: 5e               pop si
  038ED1  2541: c9               leave 
  038ED2  2542: cb               retf 

; ---- func_038ED4  size=87  insns=32  prologue=ENTER 0x0002,0  terminal=RETF ----
  038ED4  2544: c8020000         enter 2, 0
  038ED8  2548: 6a06             push 6
  038EDA  254A: 0e               push cs
  038EDB  254B: e8750f           call 0x34c3
  038EDE  254E: 83c402           add sp, 2
  038EE1  2551: 689000           push 0x90
  038EE4  2554: 6a05             push 5
  038EE6  2556: 684001           push 0x140
  038EE9  2559: 6a00             push 0
  038EEB  255B: ff36202e         push word ptr [0x2e20]
  038EEF  255F: 9a22001f18       lcall 0x181f, 0x22
  038EF4  2564: 83c402           add sp, 2
  038EF7  2567: 52               push dx
  038EF8  2568: 50               push ax
  038EF9  2569: 9a00011f18       lcall 0x181f, 0x100
  038EFE  256E: 83c40c           add sp, 0xc
  038F01  2571: c41e9e08         les bx, ptr [0x89e]
  038F05  2575: 268a07           mov al, byte ptr es:[bx]
  038F08  2578: 2ae4             sub ah, ah
  038F0A  257A: 050600           add ax, 6
  038F0D  257D: 689100           push 0x91
  038F10  2580: 50               push ax
  038F11  2581: 684001           push 0x140
  038F14  2584: 6a00             push 0
  038F16  2586: ff365c2f         push word ptr [0x2f5c]
  038F1A  258A: 9a22001f18       lcall 0x181f, 0x22
  038F1F  258F: 83c402           add sp, 2
  038F22  2592: 52               push dx
  038F23  2593: 50               push ax
  038F24  2594: 9a00011f18       lcall 0x181f, 0x100
  038F29  2599: c9               leave 
  038F2A  259A: cb               retf 

; ---- func_038F2C  size=659  insns=228  prologue=ENTER 0x0066,0  terminal=RETF ----
  038F2C  259C: c8660000         enter 0x66, 0
  038F30  25A0: 56               push si
  038F31  25A1: ff7606           push word ptr [bp + 6]
  038F34  25A4: 9a82051f18       lcall 0x181f, 0x582
  038F39  25A9: 83c402           add sp, 2
  038F3C  25AC: c746aa0200       mov word ptr [bp - 0x56], 2
  038F41  25B1: c746a81400       mov word ptr [bp - 0x58], 0x14
  038F46  25B6: 0e               push cs
  038F47  25B7: e8f00e           call 0x34aa
  038F4A  25BA: 2bc0             sub ax, ax
  038F4C  25BC: 8946ae           mov word ptr [bp - 0x52], ax
  038F4F  25BF: 89469a           mov word ptr [bp - 0x66], ax
  038F52  25C2: 8946a4           mov word ptr [bp - 0x5c], ax
  038F55  25C5: e93101           jmp 0x26f9
  038F58  25C8: 6a13             push 0x13
  038F5A  25CA: 9afc091f18       lcall 0x181f, 0x9fc
  038F5F  25CF: 83c402           add sp, 2
  038F62  25D2: 0bc0             or ax, ax
  038F64  25D4: 7410             je 0x25e6
  038F66  25D6: ff364e2f         push word ptr [0x2f4e]
  038F6A  25DA: 8d46b0           lea ax, [bp - 0x50]
  038F6D  25DD: 50               push ax
  038F6E  25DE: 9a6e011f18       lcall 0x181f, 0x16e
  038F73  25E3: 83c404           add sp, 4
  038F76  25E6: 689200           push 0x92
  038F79  25E9: 8b46a8           mov ax, word ptr [bp - 0x58]
  038F7C  25EC: 050700           add ax, 7
  038F7F  25EF: 50               push ax
  038F80  25F0: 8b4ea0           mov cx, word ptr [bp - 0x60]
  038F83  25F3: 83c103           add cx, 3
  038F86  25F6: 51               push cx
  038F87  25F7: 8d4eb0           lea cx, [bp - 0x50]
  038F8A  25FA: 16               push ss
  038F8B  25FB: 51               push cx
  038F8C  25FC: 8bf0             mov si, ax
  038F8E  25FE: 9a3c011f18       lcall 0x181f, 0x13c
  038F93  2603: 83c40a           add sp, 0xa
  038F96  2606: ff364008         push word ptr [0x840]
  038F9A  260A: ff363e08         push word ptr [0x83e]
  038F9E  260E: 8b46a8           mov ax, word ptr [bp - 0x58]
  038FA1  2611: 40               inc ax
  038FA2  2612: 40               inc ax
  038FA3  2613: 50               push ax
  038FA4  2614: b83f00           mov ax, 0x3f
  038FA7  2617: 8d1ea82d         lea bx, [0x2da8]
  038FAB  261B: bad200           mov dx, 0xd2
  038FAE  261E: 9a54021f18       lcall 0x181f, 0x254
  038FB3  2623: c41e3e08         les bx, ptr [0x83e]
  038FB7  2627: 268b873203       mov ax, word ptr es:[bx + 0x332]
  038FBC  262C: 05d400           add ax, 0xd4
  038FBF  262F: 8946a0           mov word ptr [bp - 0x60], ax
  038FC2  2632: c646b000         mov byte ptr [bp - 0x50], 0
  038FC6  2636: ff36ec8d         push word ptr [0x8dec]
  038FCA  263A: 8d46b0           lea ax, [bp - 0x50]
  038FCD  263D: 16               push ss
  038FCE  263E: 50               push ax
  038FCF  263F: 9a82011f18       lcall 0x181f, 0x182
  038FD4  2644: 83c406           add sp, 6
  038FD7  2647: 689200           push 0x92
  038FDA  264A: 56               push si
  038FDB  264B: 8b46a0           mov ax, word ptr [bp - 0x60]
  038FDE  264E: 050300           add ax, 3
  038FE1  2651: 50               push ax
  038FE2  2652: 8d46b0           lea ax, [bp - 0x50]
  038FE5  2655: 16               push ss
  038FE6  2656: 50               push ax
  038FE7  2657: 9a3c011f18       lcall 0x181f, 0x13c
  038FEC  265C: 83c40a           add sp, 0xa
  038FEF  265F: c746a0fa00       mov word ptr [bp - 0x60], 0xfa
  038FF4  2664: c746ac0000       mov word ptr [bp - 0x54], 0
  038FF9  2669: eb37             jmp 0x26a2
  038FFB  266B: 90               nop 
  038FFC  266C: ff76ac           push word ptr [bp - 0x54]
  038FFF  266F: 9a0e0c1f18       lcall 0x181f, 0xc0e
  039004  2674: 83c402           add sp, 2
  039007  2677: 8946a2           mov word ptr [bp - 0x5e], ax
  03900A  267A: 3d1100           cmp ax, 0x11
  03900D  267D: 7520             jne 0x269f
  03900F  267F: 6a07             push 7
  039011  2681: ff76ac           push word ptr [bp - 0x54]
  039014  2684: 9a740a1f18       lcall 0x181f, 0xa74
  039019  2689: 83c402           add sp, 2
  03901C  268C: 8946a6           mov word ptr [bp - 0x5a], ax
  03901F  268F: 8b5ea8           mov bx, word ptr [bp - 0x58]
  039022  2692: 43               inc bx
  039023  2693: 8b56a0           mov dx, word ptr [bp - 0x60]
  039026  2696: 9a4a021f18       lcall 0x181f, 0x24a
  03902B  269B: 8346a00c         add word ptr [bp - 0x60], 0xc
  03902F  269F: ff46ac           inc word ptr [bp - 0x54]
  039032  26A2: 8b1e4285         mov bx, word ptr [0x8542]
  039036  26A6: 8a471f           mov al, byte ptr [bx + 0x1f]
  039039  26A9: 98               cwde 
  03903A  26AA: 3b46ac           cmp ax, word ptr [bp - 0x54]
  03903D  26AD: 7fbd             jg 0x266c
  03903F  26AF: 8346a811         add word ptr [bp - 0x58], 0x11
  039043  26B3: ff469a           inc word ptr [bp - 0x66]
  039046  26B6: 837e9a09         cmp word ptr [bp - 0x66], 9
  03904A  26BA: 7c3a             jl 0x26f6
  03904C  26BC: 6aff             push -1
  03904E  26BE: 6afe             push -2
  039050  26C0: 0e               push cs
  039051  26C1: e8dc0d           call 0x34a0
  039054  26C4: 83c404           add sp, 4
  039057  26C7: 6a00             push 0
  039059  26C9: 684001           push 0x140
  03905C  26CC: 68c800           push 0xc8
  03905F  26CF: 2bc0             sub ax, ax
  039061  26D1: 99               cdq 
  039062  26D2: 2bdb             sub bx, bx
  039064  26D4: 9ae2001f18       lcall 0x181f, 0xe2
  039069  26D9: 9ac0031f18       lcall 0x181f, 0x3c0
  03906E  26DE: 0e               push cs
  03906F  26DF: e8c80d           call 0x34aa
  039072  26E2: c746aa0200       mov word ptr [bp - 0x56], 2
  039077  26E7: c746a81400       mov word ptr [bp - 0x58], 0x14
  03907C  26EC: c7469a0000       mov word ptr [bp - 0x66], 0
  039081  26F1: c746ae0100       mov word ptr [bp - 0x52], 1
  039086  26F6: ff46a4           inc word ptr [bp - 0x5c]
  039089  26F9: 8b46a4           mov ax, word ptr [bp - 0x5c]
  03908C  26FC: 39069e53         cmp word ptr [0x539e], ax
  039090  2700: 7f03             jg 0x2705
  039092  2702: e9f900           jmp 0x27fe
  039095  2705: 50               push ax
  039096  2706: 9ae6091f18       lcall 0x181f, 0x9e6
  03909B  270B: 83c402           add sp, 2
  03909E  270E: 8a4606           mov al, byte ptr [bp + 6]
  0390A1  2711: 8b1e4285         mov bx, word ptr [0x8542]
  0390A5  2715: 38471a           cmp byte ptr [bx + 0x1a], al
  0390A8  2718: 75dc             jne 0x26f6
  0390AA  271A: 9a720c1f18       lcall 0x181f, 0xc72
  0390AF  271F: 9a220c1f18       lcall 0x181f, 0xc22
  0390B4  2724: 9a040c1f18       lcall 0x181f, 0xc04
  0390B9  2729: ff36ae2d         push word ptr [0x2dae]
  0390BD  272D: ff36ac2d         push word ptr [0x2dac]
  0390C1  2731: ff36aa2d         push word ptr [0x2daa]
  0390C5  2735: ff36a82d         push word ptr [0x2da8]
  0390C9  2739: 6a64             push 0x64
  0390CB  273B: 6a01             push 1
  0390CD  273D: 6a00             push 0
  0390CF  273F: 8b56aa           mov dx, word ptr [bp - 0x56]
  0390D2  2742: 42               inc dx
  0390D3  2743: 42               inc dx
  0390D4  2744: a1c68d           mov ax, word ptr [0x8dc6]
  0390D7  2747: 8b5ea8           mov bx, word ptr [bp - 0x58]
  0390DA  274A: 9aa8021f18       lcall 0x181f, 0x2a8
  0390DF  274F: 689200           push 0x92
  0390E2  2752: 8b46a8           mov ax, word ptr [bp - 0x58]
  0390E5  2755: 050700           add ax, 7
  0390E8  2758: 50               push ax
  0390E9  2759: 8b4eaa           mov cx, word ptr [bp - 0x56]
  0390EC  275C: 83c117           add cx, 0x17
  0390EF  275F: 51               push cx
  0390F0  2760: 8b0e4285         mov cx, word ptr [0x8542]
  0390F4  2764: 41               inc cx
  0390F5  2765: 41               inc cx
  0390F6  2766: 1e               push ds
  0390F7  2767: 51               push cx
  0390F8  2768: 8bf0             mov si, ax
  0390FA  276A: 9a3c011f18       lcall 0x181f, 0x13c
  0390FF  276F: 83c40a           add sp, 0xa
  039102  2772: 89769c           mov word ptr [bp - 0x64], si
  039105  2775: ff364008         push word ptr [0x840]
  039109  2779: ff363e08         push word ptr [0x83e]
  03910D  277D: 8b46a8           mov ax, word ptr [bp - 0x58]
  039110  2780: 40               inc ax
  039111  2781: 40               inc ax
  039112  2782: 50               push ax
  039113  2783: b87c00           mov ax, 0x7c
  039116  2786: 8d1ea82d         lea bx, [0x2da8]
  03911A  278A: ba6e00           mov dx, 0x6e
  03911D  278D: 9a54021f18       lcall 0x181f, 0x254
  039122  2792: c41e3e08         les bx, ptr [0x83e]
  039126  2796: 268b870e06       mov ax, word ptr es:[bx + 0x60e]
  03912B  279B: 057000           add ax, 0x70
  03912E  279E: 8946a0           mov word ptr [bp - 0x60], ax
  039131  27A1: c646b000         mov byte ptr [bp - 0x50], 0
  039135  27A5: 9a860c1f18       lcall 0x181f, 0xc86
  03913A  27AA: 50               push ax
  03913B  27AB: 8d46b0           lea ax, [bp - 0x50]
  03913E  27AE: 16               push ss
  03913F  27AF: 50               push ax
  039140  27B0: 9a82011f18       lcall 0x181f, 0x182
  039145  27B5: 83c406           add sp, 6
  039148  27B8: 8d46b0           lea ax, [bp - 0x50]
  03914B  27BB: 50               push ax
  03914C  27BC: 9a0a011f18       lcall 0x181f, 0x10a
  039151  27C1: 83c402           add sp, 2
  039154  27C4: 689200           push 0x92
  039157  27C7: 56               push si
  039158  27C8: 8b46a0           mov ax, word ptr [bp - 0x60]
  03915B  27CB: 050300           add ax, 3
  03915E  27CE: 50               push ax
  03915F  27CF: 8d46b0           lea ax, [bp - 0x50]
  039162  27D2: 16               push ss
  039163  27D3: 50               push ax
  039164  27D4: 9a3c011f18       lcall 0x181f, 0x13c
  039169  27D9: 83c40a           add sp, 0xa
  03916C  27DC: c746a09600       mov word ptr [bp - 0x60], 0x96
  039171  27E1: c646b000         mov byte ptr [bp - 0x50], 0
  039175  27E5: 6a14             push 0x14
  039177  27E7: 9afc091f18       lcall 0x181f, 0x9fc
  03917C  27EC: 83c402           add sp, 2
  03917F  27EF: 0bc0             or ax, ax
  039181  27F1: 7503             jne 0x27f6
  039183  27F3: e9d2fd           jmp 0x25c8
  039186  27F6: ff367290         push word ptr [0x9072]
  03918A  27FA: e9ddfd           jmp 0x25da
  03918D  27FD: 90               nop 
  03918E  27FE: 837e9a00         cmp word ptr [bp - 0x66], 0
  039192  2802: 7506             jne 0x280a
  039194  2804: 837eae00         cmp word ptr [bp - 0x52], 0
  039198  2808: 7522             jne 0x282c
  03919A  280A: 6aff             push -1
  03919C  280C: 6afe             push -2
  03919E  280E: 0e               push cs
  03919F  280F: e88e0c           call 0x34a0
  0391A2  2812: 83c404           add sp, 4
  0391A5  2815: 6a00             push 0
  0391A7  2817: 684001           push 0x140
  0391AA  281A: 68c800           push 0xc8
  0391AD  281D: 2bc0             sub ax, ax
  0391AF  281F: 99               cdq 
  0391B0  2820: 2bdb             sub bx, bx
  0391B2  2822: 9ae2001f18       lcall 0x181f, 0xe2
  0391B7  2827: 9ac0031f18       lcall 0x181f, 0x3c0
  0391BC  282C: 5e               pop si
  0391BD  282D: c9               leave 
  0391BE  282E: cb               retf 

; ---- func_0391C0  size=87  insns=32  prologue=ENTER 0x0002,0  terminal=RETF ----
  0391C0  2830: c8020000         enter 2, 0
  0391C4  2834: 6a06             push 6
  0391C6  2836: 0e               push cs
  0391C7  2837: e8890c           call 0x34c3
  0391CA  283A: 83c402           add sp, 2
  0391CD  283D: 689000           push 0x90
  0391D0  2840: 6a05             push 5
  0391D2  2842: 684001           push 0x140
  0391D5  2845: 6a00             push 0
  0391D7  2847: ff36202e         push word ptr [0x2e20]
  0391DB  284B: 9a22001f18       lcall 0x181f, 0x22
  0391E0  2850: 83c402           add sp, 2
  0391E3  2853: 52               push dx
  0391E4  2854: 50               push ax
  0391E5  2855: 9a00011f18       lcall 0x181f, 0x100
  0391EA  285A: 83c40c           add sp, 0xc
  0391ED  285D: c41e9e08         les bx, ptr [0x89e]
  0391F1  2861: 268a07           mov al, byte ptr es:[bx]
  0391F4  2864: 2ae4             sub ah, ah
  0391F6  2866: 050600           add ax, 6
  0391F9  2869: 689100           push 0x91
  0391FC  286C: 50               push ax
  0391FD  286D: 684001           push 0x140
  039200  2870: 6a00             push 0
  039202  2872: ff365a2f         push word ptr [0x2f5a]
  039206  2876: 9a22001f18       lcall 0x181f, 0x22
  03920B  287B: 83c402           add sp, 2
  03920E  287E: 52               push dx
  03920F  287F: 50               push ax
  039210  2880: 9a00011f18       lcall 0x181f, 0x100
  039215  2885: c9               leave 
  039216  2886: cb               retf 

; ---- func_039218  size=475  insns=166  prologue=ENTER 0x0068,0  terminal=RETF ----
  039218  2888: c8680000         enter 0x68, 0
  03921C  288C: ff7606           push word ptr [bp + 6]
  03921F  288F: 9a82051f18       lcall 0x181f, 0x582
  039224  2894: 83c402           add sp, 2
  039227  2897: c746a60200       mov word ptr [bp - 0x5a], 2
  03922C  289C: c746a21400       mov word ptr [bp - 0x5e], 0x14
  039231  28A1: 0e               push cs
  039232  28A2: e8230c           call 0x34c8
  039235  28A5: 2bc0             sub ax, ax
  039237  28A7: 8946ac           mov word ptr [bp - 0x54], ax
  03923A  28AA: 894698           mov word ptr [bp - 0x68], ax
  03923D  28AD: 8946a0           mov word ptr [bp - 0x60], ax
  039240  28B0: e9ab00           jmp 0x295e
  039243  28B3: 90               nop 
  039244  28B4: 8b469c           mov ax, word ptr [bp - 0x64]
  039247  28B7: 9ae4021f18       lcall 0x181f, 0x2e4
  03924C  28BC: 89469c           mov word ptr [bp - 0x64], ax
  03924F  28BF: 0bc0             or ax, ax
  039251  28C1: 7c51             jl 0x2914
  039253  28C3: 6bd81c           imul bx, ax, 0x1c
  039256  28C6: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  03925A  28CA: 2aff             sub bh, bh
  03925C  28CC: 8bc3             mov ax, bx
  03925E  28CE: d1e3             shl bx, 1
  039260  28D0: 03d8             add bx, ax
  039262  28D2: d1e3             shl bx, 1
  039264  28D4: 03d8             add bx, ax
  039266  28D6: d1e3             shl bx, 1
  039268  28D8: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  03926D  28DD: 72d5             jb 0x28b4
  03926F  28DF: 6b5e9c1c         imul bx, word ptr [bp - 0x64], 0x1c
  039273  28E3: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  039278  28E8: 7207             jb 0x28f1
  03927A  28EA: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  03927F  28EF: 76c3             jbe 0x28b4
  039281  28F1: 817e9e2c01       cmp word ptr [bp - 0x62], 0x12c
  039286  28F6: 7fbc             jg 0x28b4
  039288  28F8: ff76a2           push word ptr [bp - 0x5e]
  03928B  28FB: 6aff             push -1
  03928D  28FD: 6a64             push 0x64
  03928F  28FF: 8b469c           mov ax, word ptr [bp - 0x64]
  039292  2902: 2bd2             sub dx, dx
  039294  2904: 8b5e9e           mov bx, word ptr [bp - 0x62]
  039297  2907: 9abc021f18       lcall 0x181f, 0x2bc
  03929C  290C: 8b46a8           mov ax, word ptr [bp - 0x58]
  03929F  290F: 01469e           add word ptr [bp - 0x62], ax
  0392A2  2912: eba0             jmp 0x28b4
  0392A4  2914: 8346a211         add word ptr [bp - 0x5e], 0x11
  0392A8  2918: ff4698           inc word ptr [bp - 0x68]
  0392AB  291B: 837e9809         cmp word ptr [bp - 0x68], 9
  0392AF  291F: 7c3a             jl 0x295b
  0392B1  2921: 6aff             push -1
  0392B3  2923: 6afe             push -2
  0392B5  2925: 0e               push cs
  0392B6  2926: e8770b           call 0x34a0
  0392B9  2929: 83c404           add sp, 4
  0392BC  292C: 6a00             push 0
  0392BE  292E: 684001           push 0x140
  0392C1  2931: 68c800           push 0xc8
  0392C4  2934: 2bc0             sub ax, ax
  0392C6  2936: 99               cdq 
  0392C7  2937: 2bdb             sub bx, bx
  0392C9  2939: 9ae2001f18       lcall 0x181f, 0xe2
  0392CE  293E: 9ac0031f18       lcall 0x181f, 0x3c0
  0392D3  2943: 0e               push cs
  0392D4  2944: e8810b           call 0x34c8
  0392D7  2947: c746a60200       mov word ptr [bp - 0x5a], 2
  0392DC  294C: c746a21400       mov word ptr [bp - 0x5e], 0x14
  0392E1  2951: c746980000       mov word ptr [bp - 0x68], 0
  0392E6  2956: c746ac0100       mov word ptr [bp - 0x54], 1
  0392EB  295B: ff46a0           inc word ptr [bp - 0x60]
  0392EE  295E: 8b46a0           mov ax, word ptr [bp - 0x60]
  0392F1  2961: 39069e53         cmp word ptr [0x539e], ax
  0392F5  2965: 7f03             jg 0x296a
  0392F7  2967: e9c200           jmp 0x2a2c
  0392FA  296A: 50               push ax
  0392FB  296B: 9ae6091f18       lcall 0x181f, 0x9e6
  039300  2970: 83c402           add sp, 2
  039303  2973: 8a4606           mov al, byte ptr [bp + 6]
  039306  2976: 8b1e4285         mov bx, word ptr [0x8542]
  03930A  297A: 38471a           cmp byte ptr [bx + 0x1a], al
  03930D  297D: 75dc             jne 0x295b
  03930F  297F: ff36ae2d         push word ptr [0x2dae]
  039313  2983: ff36ac2d         push word ptr [0x2dac]
  039317  2987: ff36aa2d         push word ptr [0x2daa]
  03931B  298B: ff36a82d         push word ptr [0x2da8]
  03931F  298F: 6a64             push 0x64
  039321  2991: 6a01             push 1
  039323  2993: 6a00             push 0
  039325  2995: 8b56a6           mov dx, word ptr [bp - 0x5a]
  039328  2998: 42               inc dx
  039329  2999: 42               inc dx
  03932A  299A: a1c68d           mov ax, word ptr [0x8dc6]
  03932D  299D: 8b5ea2           mov bx, word ptr [bp - 0x5e]
  039330  29A0: 9aa8021f18       lcall 0x181f, 0x2a8
  039335  29A5: 689200           push 0x92
  039338  29A8: 8b46a2           mov ax, word ptr [bp - 0x5e]
  03933B  29AB: 050700           add ax, 7
  03933E  29AE: 50               push ax
  03933F  29AF: 8b46a6           mov ax, word ptr [bp - 0x5a]
  039342  29B2: 051700           add ax, 0x17
  039345  29B5: 50               push ax
  039346  29B6: a14285           mov ax, word ptr [0x8542]
  039349  29B9: 40               inc ax
  03934A  29BA: 40               inc ax
  03934B  29BB: 1e               push ds
  03934C  29BC: 50               push ax
  03934D  29BD: 9a3c011f18       lcall 0x181f, 0x13c
  039352  29C2: 83c40a           add sp, 0xa
  039355  29C5: c7469e6e00       mov word ptr [bp - 0x62], 0x6e
  03935A  29CA: 6a0a             push 0xa
  03935C  29CC: 8b1e4285         mov bx, word ptr [0x8542]
  039360  29D0: 8a07             mov al, byte ptr [bx]
  039362  29D2: 2ae4             sub ah, ah
  039364  29D4: 8a5701           mov dl, byte ptr [bx + 1]
  039367  29D7: 2af6             sub dh, dh
  039369  29D9: 9ae0071f18       lcall 0x181f, 0x7e0
  03936E  29DE: 8946aa           mov word ptr [bp - 0x56], ax
  039371  29E1: 50               push ax
  039372  29E2: 9abc081f18       lcall 0x181f, 0x8bc
  039377  29E7: 83c404           add sp, 4
  03937A  29EA: 8946fe           mov word ptr [bp - 2], ax
  03937D  29ED: 6a01             push 1
  03937F  29EF: ff76aa           push word ptr [bp - 0x56]
  039382  29F2: 9aea071f18       lcall 0x181f, 0x7ea
  039387  29F7: 83c404           add sp, 4
  03938A  29FA: 8b46aa           mov ax, word ptr [bp - 0x56]
  03938D  29FD: 9aee021f18       lcall 0x181f, 0x2ee
  039392  2A02: 8946aa           mov word ptr [bp - 0x56], ax
  039395  2A05: 837efe00         cmp word ptr [bp - 2], 0
  039399  2A09: 7f03             jg 0x2a0e
  03939B  2A0B: ff46fe           inc word ptr [bp - 2]
  03939E  2A0E: 6a12             push 0x12
  0393A0  2A10: 6a01             push 1
  0393A2  2A12: b8d200           mov ax, 0xd2
  0393A5  2A15: 99               cdq 
  0393A6  2A16: f77efe           idiv word ptr [bp - 2]
  0393A9  2A19: 50               push ax
  0393AA  2A1A: 9a5c031f18       lcall 0x181f, 0x35c
  0393AF  2A1F: 83c406           add sp, 6
  0393B2  2A22: 8946a8           mov word ptr [bp - 0x58], ax
  0393B5  2A25: 8b46aa           mov ax, word ptr [bp - 0x56]
  0393B8  2A28: e991fe           jmp 0x28bc
  0393BB  2A2B: 90               nop 
  0393BC  2A2C: 837e9800         cmp word ptr [bp - 0x68], 0
  0393C0  2A30: 7506             jne 0x2a38
  0393C2  2A32: 837eac00         cmp word ptr [bp - 0x54], 0
  0393C6  2A36: 7522             jne 0x2a5a
  0393C8  2A38: 6aff             push -1
  0393CA  2A3A: 6afe             push -2
  0393CC  2A3C: 0e               push cs
  0393CD  2A3D: e8600a           call 0x34a0
  0393D0  2A40: 83c404           add sp, 4
  0393D3  2A43: 6a00             push 0
  0393D5  2A45: 684001           push 0x140
  0393D8  2A48: 68c800           push 0xc8
  0393DB  2A4B: 2bc0             sub ax, ax
  0393DD  2A4D: 99               cdq 
  0393DE  2A4E: 2bdb             sub bx, bx
  0393E0  2A50: 9ae2001f18       lcall 0x181f, 0xe2
  0393E5  2A55: 9ac0031f18       lcall 0x181f, 0x3c0
  0393EA  2A5A: ff7606           push word ptr [bp + 6]
  0393ED  2A5D: 0e               push cs
  0393EE  2A5E: e8530a           call 0x34b4
  0393F1  2A61: c9               leave 
  0393F2  2A62: cb               retf 

; ---- func_0393F4  size=344  insns=116  prologue=ENTER 0x0058,0  terminal=RETF ----
  0393F4  2A64: c8580000         enter 0x58, 0
  0393F8  2A68: ff7606           push word ptr [bp + 6]
  0393FB  2A6B: 9a82051f18       lcall 0x181f, 0x582
  039400  2A70: 83c402           add sp, 2
  039403  2A73: 6a07             push 7
  039405  2A75: 0e               push cs
  039406  2A76: e84a0a           call 0x34c3
  039409  2A79: 83c402           add sp, 2
  03940C  2A7C: 689000           push 0x90
  03940F  2A7F: 6a05             push 5
  039411  2A81: 684001           push 0x140
  039414  2A84: 6a00             push 0
  039416  2A86: ff36222e         push word ptr [0x2e22]
  03941A  2A8A: 9a22001f18       lcall 0x181f, 0x22
  03941F  2A8F: 83c402           add sp, 2
  039422  2A92: 52               push dx
  039423  2A93: 50               push ax
  039424  2A94: 9a00011f18       lcall 0x181f, 0x100
  039429  2A99: 83c40c           add sp, 0xc
  03942C  2A9C: c746ac1900       mov word ptr [bp - 0x54], 0x19
  039431  2AA1: c646b000         mov byte ptr [bp - 0x50], 0
  039435  2AA5: ff36342e         push word ptr [0x2e34]
  039439  2AA9: 8d46b0           lea ax, [bp - 0x50]
  03943C  2AAC: 50               push ax
  03943D  2AAD: 9a6e011f18       lcall 0x181f, 0x16e
  039442  2AB2: 83c404           add sp, 4
  039445  2AB5: 689200           push 0x92
  039448  2AB8: b81b00           mov ax, 0x1b
  03944B  2ABB: 8946a8           mov word ptr [bp - 0x58], ax
  03944E  2ABE: 50               push ax
  03944F  2ABF: 6a50             push 0x50
  039451  2AC1: b80200           mov ax, 2
  039454  2AC4: 8946ae           mov word ptr [bp - 0x52], ax
  039457  2AC7: 50               push ax
  039458  2AC8: 8d46b0           lea ax, [bp - 0x50]
  03945B  2ACB: 16               push ss
  03945C  2ACC: 50               push ax
  03945D  2ACD: 9a00011f18       lcall 0x181f, 0x100
  039462  2AD2: 83c40c           add sp, 0xc
  039465  2AD5: c646b000         mov byte ptr [bp - 0x50], 0
  039469  2AD9: ff36362e         push word ptr [0x2e36]
  03946D  2ADD: 8d46b0           lea ax, [bp - 0x50]
  039470  2AE0: 50               push ax
  039471  2AE1: 9a6e011f18       lcall 0x181f, 0x16e
  039476  2AE6: 83c404           add sp, 4
  039479  2AE9: 689200           push 0x92
  03947C  2AEC: 6a1b             push 0x1b
  03947E  2AEE: 6a50             push 0x50
  039480  2AF0: 6a52             push 0x52
  039482  2AF2: 8d46b0           lea ax, [bp - 0x50]
  039485  2AF5: 16               push ss
  039486  2AF6: 50               push ax
  039487  2AF7: 9a00011f18       lcall 0x181f, 0x100
  03948C  2AFC: 83c40c           add sp, 0xc
  03948F  2AFF: c646b000         mov byte ptr [bp - 0x50], 0
  039493  2B03: ff36382e         push word ptr [0x2e38]
  039497  2B07: 8d46b0           lea ax, [bp - 0x50]
  03949A  2B0A: 50               push ax
  03949B  2B0B: 9a6e011f18       lcall 0x181f, 0x16e
  0394A0  2B10: 83c404           add sp, 4
  0394A3  2B13: 689200           push 0x92
  0394A6  2B16: 6a1b             push 0x1b
  0394A8  2B18: 6a50             push 0x50
  0394AA  2B1A: 68a200           push 0xa2
  0394AD  2B1D: 8d46b0           lea ax, [bp - 0x50]
  0394B0  2B20: 16               push ss
  0394B1  2B21: 50               push ax
  0394B2  2B22: 9a00011f18       lcall 0x181f, 0x100
  0394B7  2B27: 83c40c           add sp, 0xc
  0394BA  2B2A: c646b000         mov byte ptr [bp - 0x50], 0
  0394BE  2B2E: ff363a2e         push word ptr [0x2e3a]
  0394C2  2B32: 8d46b0           lea ax, [bp - 0x50]
  0394C5  2B35: 50               push ax
  0394C6  2B36: 9a6e011f18       lcall 0x181f, 0x16e
  0394CB  2B3B: 83c404           add sp, 4
  0394CE  2B3E: 689200           push 0x92
  0394D1  2B41: 6a1b             push 0x1b
  0394D3  2B43: 6a4c             push 0x4c
  0394D5  2B45: 68f200           push 0xf2
  0394D8  2B48: 8d46b0           lea ax, [bp - 0x50]
  0394DB  2B4B: 16               push ss
  0394DC  2B4C: 50               push ax
  0394DD  2B4D: 9a00011f18       lcall 0x181f, 0x100
  0394E2  2B52: 83c40c           add sp, 0xc
  0394E5  2B55: c746aa0100       mov word ptr [bp - 0x56], 1
  0394EA  2B5A: ff36ae2d         push word ptr [0x2dae]
  0394EE  2B5E: ff36ac2d         push word ptr [0x2dac]
  0394F2  2B62: ff36aa2d         push word ptr [0x2daa]
  0394F6  2B66: ff36a82d         push word ptr [0x2da8]
  0394FA  2B6A: 6a77             push 0x77
  0394FC  2B6C: 6b46aa50         imul ax, word ptr [bp - 0x56], 0x50
  039500  2B70: 0346ae           add ax, word ptr [bp - 0x52]
  039503  2B73: ba1900           mov dx, 0x19
  039506  2B76: bbb400           mov bx, 0xb4
  039509  2B79: 9ab2081f19       lcall 0x191f, 0x8b2
  03950E  2B7E: ff46aa           inc word ptr [bp - 0x56]
  039511  2B81: 837eaa03         cmp word ptr [bp - 0x56], 3
  039515  2B85: 7ed3             jle 0x2b5a
  039517  2B87: c746aa0000       mov word ptr [bp - 0x56], 0
  03951C  2B8C: ff36ae2d         push word ptr [0x2dae]
  039520  2B90: ff36ac2d         push word ptr [0x2dac]
  039524  2B94: ff36aa2d         push word ptr [0x2daa]
  039528  2B98: ff36a82d         push word ptr [0x2da8]
  03952C  2B9C: 6a77             push 0x77
  03952E  2B9E: 8b46aa           mov ax, word ptr [bp - 0x56]
  039531  2BA1: 40               inc ax
  039532  2BA2: 40               inc ax
  039533  2BA3: 6bd814           imul bx, ax, 0x14
  039536  2BA6: b80200           mov ax, 2
  039539  2BA9: ba3a01           mov dx, 0x13a
  03953C  2BAC: 9abc081f19       lcall 0x191f, 0x8bc
  039541  2BB1: ff46aa           inc word ptr [bp - 0x56]
  039544  2BB4: 837eaa08         cmp word ptr [bp - 0x56], 8
  039548  2BB8: 7cd2             jl 0x2b8c
  03954A  2BBA: c9               leave 
  03954B  2BBB: cb               retf 

; ---- func_03954C  size=827  insns=294  prologue=ENTER 0x006A,0  terminal=RETF ----
  03954C  2BBC: c86a0000         enter 0x6a, 0
  039550  2BC0: 56               push si
  039551  2BC1: ff7606           push word ptr [bp + 6]
  039554  2BC4: 0e               push cs
  039555  2BC5: e8e708           call 0x34af
  039558  2BC8: 83c402           add sp, 2
  03955B  2BCB: c746aa0200       mov word ptr [bp - 0x56], 2
  039560  2BD0: c746a82a00       mov word ptr [bp - 0x58], 0x2a
  039565  2BD5: 2bc0             sub ax, ax
  039567  2BD7: 8946ae           mov word ptr [bp - 0x52], ax
  03956A  2BDA: 89469c           mov word ptr [bp - 0x64], ax
  03956D  2BDD: 894698           mov word ptr [bp - 0x68], ax
  039570  2BE0: e97302           jmp 0x2e56
  039573  2BE3: 90               nop 
  039574  2BE4: ff76a8           push word ptr [bp - 0x58]
  039577  2BE7: 6a00             push 0
  039579  2BE9: 6a64             push 0x64
  03957B  2BEB: 8b5eaa           mov bx, word ptr [bp - 0x56]
  03957E  2BEE: 83c356           add bx, 0x56
  039581  2BF1: 8b4698           mov ax, word ptr [bp - 0x68]
  039584  2BF4: 2bd2             sub dx, dx
  039586  2BF6: 9abc021f18       lcall 0x181f, 0x2bc
  03958B  2BFB: 8b46a8           mov ax, word ptr [bp - 0x58]
  03958E  2BFE: 050300           add ax, 3
  039591  2C01: 894696           mov word ptr [bp - 0x6a], ax
  039594  2C04: 8b46aa           mov ax, word ptr [bp - 0x56]
  039597  2C07: 055600           add ax, 0x56
  03959A  2C0A: 89469a           mov word ptr [bp - 0x66], ax
  03959D  2C0D: 8946a6           mov word ptr [bp - 0x5a], ax
  0395A0  2C10: c746a40000       mov word ptr [bp - 0x5c], 0
  0395A5  2C15: eb28             jmp 0x2c3f
  0395A7  2C17: 90               nop 
  0395A8  2C18: b82700           mov ax, 0x27
  0395AB  2C1B: 8946a0           mov word ptr [bp - 0x60], ax
  0395AE  2C1E: ff364008         push word ptr [0x840]
  0395B2  2C22: ff363e08         push word ptr [0x83e]
  0395B6  2C26: ff7696           push word ptr [bp - 0x6a]
  0395B9  2C29: 03469e           add ax, word ptr [bp - 0x62]
  0395BC  2C2C: 8d1ea82d         lea bx, [0x2da8]
  0395C0  2C30: 8b56a6           mov dx, word ptr [bp - 0x5a]
  0395C3  2C33: 9a54021f18       lcall 0x181f, 0x254
  0395C8  2C38: 8346a60c         add word ptr [bp - 0x5a], 0xc
  0395CC  2C3C: ff46a4           inc word ptr [bp - 0x5c]
  0395CF  2C3F: 6b5e981c         imul bx, word ptr [bp - 0x68], 0x1c
  0395D3  2C43: 8a875031         mov al, byte ptr [bx + 0x3150]
  0395D7  2C47: 2ae4             sub ah, ah
  0395D9  2C49: 3b46a4           cmp ax, word ptr [bp - 0x5c]
  0395DC  2C4C: 7e2c             jle 0x2c7a
  0395DE  2C4E: ff76a4           push word ptr [bp - 0x5c]
  0395E1  2C51: ff7698           push word ptr [bp - 0x68]
  0395E4  2C54: 9ae60b1f18       lcall 0x181f, 0xbe6
  0395E9  2C59: 83c404           add sp, 4
  0395EC  2C5C: 89469e           mov word ptr [bp - 0x62], ax
  0395EF  2C5F: ff76a4           push word ptr [bp - 0x5c]
  0395F2  2C62: ff7698           push word ptr [bp - 0x68]
  0395F5  2C65: 9a680c1f18       lcall 0x181f, 0xc68
  0395FA  2C6A: 83c404           add sp, 4
  0395FD  2C6D: 8946ac           mov word ptr [bp - 0x54], ax
  039600  2C70: 3d6400           cmp ax, 0x64
  039603  2C73: 7ca3             jl 0x2c18
  039605  2C75: b81700           mov ax, 0x17
  039608  2C78: eba1             jmp 0x2c1b
  03960A  2C7A: 8b46a8           mov ax, word ptr [bp - 0x58]
  03960D  2C7D: 050600           add ax, 6
  039610  2C80: 894696           mov word ptr [bp - 0x6a], ax
  039613  2C83: 8b4eaa           mov cx, word ptr [bp - 0x56]
  039616  2C86: 83c118           add cx, 0x18
  039619  2C89: 894e9a           mov word ptr [bp - 0x66], cx
  03961C  2C8C: c646b000         mov byte ptr [bp - 0x50], 0
  039620  2C90: 6b5e981c         imul bx, word ptr [bp - 0x68], 0x1c
  039624  2C94: 8d974631         lea dx, [bx + 0x3146]
  039628  2C98: 8bda             mov bx, dx
  03962A  2C9A: 8a1f             mov bl, byte ptr [bx]
  03962C  2C9C: 2aff             sub bh, bh
  03962E  2C9E: 8bf3             mov si, bx
  039630  2CA0: d1e3             shl bx, 1
  039632  2CA2: 03de             add bx, si
  039634  2CA4: d1e3             shl bx, 1
  039636  2CA6: 03de             add bx, si
  039638  2CA8: d1e3             shl bx, 1
  03963A  2CAA: ffb73052         push word ptr [bx + 0x5230]
  03963E  2CAE: 8d5eb0           lea bx, [bp - 0x50]
  039641  2CB1: 53               push bx
  039642  2CB2: 8bf2             mov si, dx
  039644  2CB4: 9a6e011f18       lcall 0x181f, 0x16e
  039649  2CB9: 83c404           add sp, 4
  03964C  2CBC: 803c0d           cmp byte ptr [si], 0xd
  03964F  2CBF: 720f             jb 0x2cd0
  039651  2CC1: 803c12           cmp byte ptr [si], 0x12
  039654  2CC4: 770a             ja 0x2cd0
  039656  2CC6: 6a61             push 0x61
  039658  2CC8: ff7696           push word ptr [bp - 0x6a]
  03965B  2CCB: ff769a           push word ptr [bp - 0x66]
  03965E  2CCE: eb0c             jmp 0x2cdc
  039660  2CD0: 6a61             push 0x61
  039662  2CD2: ff7696           push word ptr [bp - 0x6a]
  039665  2CD5: 8b469a           mov ax, word ptr [bp - 0x66]
  039668  2CD8: 055600           add ax, 0x56
  03966B  2CDB: 50               push ax
  03966C  2CDC: 8d46b0           lea ax, [bp - 0x50]
  03966F  2CDF: 16               push ss
  039670  2CE0: 50               push ax
  039671  2CE1: 9a3c011f18       lcall 0x181f, 0x13c
  039676  2CE6: 83c40a           add sp, 0xa
  039679  2CE9: 6b5e981c         imul bx, word ptr [bp - 0x68], 0x1c
  03967D  2CED: 8a874431         mov al, byte ptr [bx + 0x3144]
  039681  2CF1: 2ae4             sub ah, ah
  039683  2CF3: 8946a6           mov word ptr [bp - 0x5a], ax
  039686  2CF6: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  03968A  2CFA: 2aed             sub ch, ch
  03968C  2CFC: 894ea2           mov word ptr [bp - 0x5e], cx
  03968F  2CFF: 8866b0           mov byte ptr [bp - 0x50], ah
  039692  2D02: 6a00             push 0
  039694  2D04: 8a974731         mov dl, byte ptr [bx + 0x3147]
  039698  2D08: 83e20f           and dx, 0xf
  03969B  2D0B: 52               push dx
  03969C  2D0C: 51               push cx
  03969D  2D0D: 50               push ax
  03969E  2D0E: 8d46b0           lea ax, [bp - 0x50]
  0396A1  2D11: 50               push ax
  0396A2  2D12: 8bf3             mov si, bx
  0396A4  2D14: 9a820f1f19       lcall 0x191f, 0xf82
  0396A9  2D19: 83c40a           add sp, 0xa
  0396AC  2D1C: 6a61             push 0x61
  0396AE  2D1E: ff7696           push word ptr [bp - 0x6a]
  0396B1  2D21: 6a50             push 0x50
  0396B3  2D23: 8b46aa           mov ax, word ptr [bp - 0x56]
  0396B6  2D26: 05a000           add ax, 0xa0
  0396B9  2D29: 50               push ax
  0396BA  2D2A: 8d46b0           lea ax, [bp - 0x50]
  0396BD  2D2D: 16               push ss
  0396BE  2D2E: 50               push ax
  0396BF  2D2F: 9a00011f18       lcall 0x181f, 0x100
  0396C4  2D34: 83c40c           add sp, 0xc
  0396C7  2D37: 8b46aa           mov ax, word ptr [bp - 0x56]
  0396CA  2D3A: 05f000           add ax, 0xf0
  0396CD  2D3D: 89469a           mov word ptr [bp - 0x66], ax
  0396D0  2D40: 80bc4c3103       cmp byte ptr [si + 0x314c], 3
  0396D5  2D45: 740e             je 0x2d55
  0396D7  2D47: 80bc4c310b       cmp byte ptr [si + 0x314c], 0xb
  0396DC  2D4C: 7407             je 0x2d55
  0396DE  2D4E: 80bc4c3102       cmp byte ptr [si + 0x314c], 2
  0396E3  2D53: 752f             jne 0x2d84
  0396E5  2D55: 6b5e981c         imul bx, word ptr [bp - 0x68], 0x1c
  0396E9  2D59: 8a874d31         mov al, byte ptr [bx + 0x314d]
  0396ED  2D5D: 2ae4             sub ah, ah
  0396EF  2D5F: 8946a6           mov word ptr [bp - 0x5a], ax
  0396F2  2D62: 8a8f4e31         mov cl, byte ptr [bx + 0x314e]
  0396F6  2D66: 2aed             sub ch, ch
  0396F8  2D68: 894ea2           mov word ptr [bp - 0x5e], cx
  0396FB  2D6B: 8866b0           mov byte ptr [bp - 0x50], ah
  0396FE  2D6E: 6a01             push 1
  039700  2D70: ff7606           push word ptr [bp + 6]
  039703  2D73: 51               push cx
  039704  2D74: 50               push ax
  039705  2D75: 8d46b0           lea ax, [bp - 0x50]
  039708  2D78: 50               push ax
  039709  2D79: 9a820f1f19       lcall 0x191f, 0xf82
  03970E  2D7E: 83c40a           add sp, 0xa
  039711  2D81: eb6c             jmp 0x2def
  039713  2D83: 90               nop 
  039714  2D84: ff76a2           push word ptr [bp - 0x5e]
  039717  2D87: ff76a6           push word ptr [bp - 0x5a]
  03971A  2D8A: 9a02031f18       lcall 0x181f, 0x302
  03971F  2D8F: 83c404           add sp, 4
  039722  2D92: 0bc0             or ax, ax
  039724  2D94: 7570             jne 0x2e06
  039726  2D96: c646b000         mov byte ptr [bp - 0x50], 0
  03972A  2D9A: 8a4606           mov al, byte ptr [bp + 6]
  03972D  2D9D: 8a4ea6           mov cl, byte ptr [bp - 0x5a]
  039730  2DA0: 2ac1             sub al, cl
  039732  2DA2: 3c18             cmp al, 0x18
  039734  2DA4: 740a             je 0x2db0
  039736  2DA6: 2a4e06           sub cl, byte ptr [bp + 6]
  039739  2DA9: f6d9             neg cl
  03973B  2DAB: 80f91c           cmp cl, 0x1c
  03973E  2DAE: 7514             jne 0x2dc4
  039740  2DB0: 6b460634         imul ax, word ptr [bp + 6], 0x34
  039744  2DB4: 052654           add ax, 0x5426
  039747  2DB7: 50               push ax
  039748  2DB8: 8d46b0           lea ax, [bp - 0x50]
  03974B  2DBB: 50               push ax
  03974C  2DBC: 9ae4071d0d       lcall 0xd1d, 0x7e4
  039751  2DC1: eb29             jmp 0x2dec
  039753  2DC3: 90               nop 
  039754  2DC4: 8a4606           mov al, byte ptr [bp + 6]
  039757  2DC7: 8a4ea6           mov cl, byte ptr [bp - 0x5a]
  03975A  2DCA: 2ac1             sub al, cl
  03975C  2DCC: 3c0c             cmp al, 0xc
  03975E  2DCE: 740a             je 0x2dda
  039760  2DD0: 2a4e06           sub cl, byte ptr [bp + 6]
  039763  2DD3: f6d9             neg cl
  039765  2DD5: 80f910           cmp cl, 0x10
  039768  2DD8: 7515             jne 0x2def
  03976A  2DDA: 8b5e06           mov bx, word ptr [bp + 6]
  03976D  2DDD: d1e3             shl bx, 1
  03976F  2DDF: ffb78c83         push word ptr [bx - 0x7c74]
  039773  2DE3: 8d46b0           lea ax, [bp - 0x50]
  039776  2DE6: 50               push ax
  039777  2DE7: 9a6e011f18       lcall 0x181f, 0x16e
  03977C  2DEC: 83c404           add sp, 4
  03977F  2DEF: 6a61             push 0x61
  039781  2DF1: ff7696           push word ptr [bp - 0x6a]
  039784  2DF4: 6a4c             push 0x4c
  039786  2DF6: ff769a           push word ptr [bp - 0x66]
  039789  2DF9: 8d46b0           lea ax, [bp - 0x50]
  03978C  2DFC: 16               push ss
  03978D  2DFD: 50               push ax
  03978E  2DFE: 9a00011f18       lcall 0x181f, 0x100
  039793  2E03: 83c40c           add sp, 0xc
  039796  2E06: 8346a814         add word ptr [bp - 0x58], 0x14
  03979A  2E0A: ff469c           inc word ptr [bp - 0x64]
  03979D  2E0D: 837e9c07         cmp word ptr [bp - 0x64], 7
  0397A1  2E11: 7c40             jl 0x2e53
  0397A3  2E13: 6aff             push -1
  0397A5  2E15: 6afe             push -2
  0397A7  2E17: 0e               push cs
  0397A8  2E18: e88506           call 0x34a0
  0397AB  2E1B: 83c404           add sp, 4
  0397AE  2E1E: 6a00             push 0
  0397B0  2E20: 684001           push 0x140
  0397B3  2E23: 68c800           push 0xc8
  0397B6  2E26: 2bc0             sub ax, ax
  0397B8  2E28: 99               cdq 
  0397B9  2E29: 2bdb             sub bx, bx
  0397BB  2E2B: 9ae2001f18       lcall 0x181f, 0xe2
  0397C0  2E30: 9ac0031f18       lcall 0x181f, 0x3c0
  0397C5  2E35: ff7606           push word ptr [bp + 6]
  0397C8  2E38: 0e               push cs
  0397C9  2E39: e87306           call 0x34af
  0397CC  2E3C: 83c402           add sp, 2
  0397CF  2E3F: c746aa0200       mov word ptr [bp - 0x56], 2
  0397D4  2E44: c746a82a00       mov word ptr [bp - 0x58], 0x2a
  0397D9  2E49: c7469c0000       mov word ptr [bp - 0x64], 0
  0397DE  2E4E: c746ae0100       mov word ptr [bp - 0x52], 1
  0397E3  2E53: ff4698           inc word ptr [bp - 0x68]
  0397E6  2E56: 8b4698           mov ax, word ptr [bp - 0x68]
  0397E9  2E59: 39069c53         cmp word ptr [0x539c], ax
  0397ED  2E5D: 7e67             jle 0x2ec6
  0397EF  2E5F: 6bd81c           imul bx, ax, 0x1c
  0397F2  2E62: 8a874731         mov al, byte ptr [bx + 0x3147]
  0397F6  2E66: 240f             and al, 0xf
  0397F8  2E68: 3a4606           cmp al, byte ptr [bp + 6]
  0397FB  2E6B: 75e6             jne 0x2e53
  0397FD  2E6D: 6b5e981c         imul bx, word ptr [bp - 0x68], 0x1c
  039801  2E71: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  039806  2E76: 7207             jb 0x2e7f
  039808  2E78: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  03980D  2E7D: 761c             jbe 0x2e9b
  03980F  2E7F: 6b5e981c         imul bx, word ptr [bp - 0x68], 0x1c
  039813  2E83: 8a874531         mov al, byte ptr [bx + 0x3145]
  039817  2E87: 2ae4             sub ah, ah
  039819  2E89: 50               push ax
  03981A  2E8A: 8a874431         mov al, byte ptr [bx + 0x3144]
  03981E  2E8E: 50               push ax
  03981F  2E8F: 9a68071f18       lcall 0x181f, 0x768
  039824  2E94: 83c404           add sp, 4
  039827  2E97: 0bc0             or ax, ax
  039829  2E99: 74b8             je 0x2e53
  03982B  2E9B: 6b5e981c         imul bx, word ptr [bp - 0x68], 0x1c
  03982F  2E9F: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  039834  2EA4: 7303             jae 0x2ea9
  039836  2EA6: e93bfd           jmp 0x2be4
  039839  2EA9: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  03983E  2EAE: 7603             jbe 0x2eb3
  039840  2EB0: e931fd           jmp 0x2be4
  039843  2EB3: ff76a8           push word ptr [bp - 0x58]
  039846  2EB6: 6a00             push 0
  039848  2EB8: 6a64             push 0x64
  03984A  2EBA: 8b4698           mov ax, word ptr [bp - 0x68]
  03984D  2EBD: 2bd2             sub dx, dx
  03984F  2EBF: 8b5eaa           mov bx, word ptr [bp - 0x56]
  039852  2EC2: e931fd           jmp 0x2bf6
  039855  2EC5: 90               nop 
  039856  2EC6: 837e9c00         cmp word ptr [bp - 0x64], 0
  03985A  2ECA: 7506             jne 0x2ed2
  03985C  2ECC: 837eae00         cmp word ptr [bp - 0x52], 0
  039860  2ED0: 7522             jne 0x2ef4
  039862  2ED2: 6aff             push -1
  039864  2ED4: 6afe             push -2
  039866  2ED6: 0e               push cs
  039867  2ED7: e8c605           call 0x34a0
  03986A  2EDA: 83c404           add sp, 4
  03986D  2EDD: 6a00             push 0
  03986F  2EDF: 684001           push 0x140
  039872  2EE2: 68c800           push 0xc8
  039875  2EE5: 2bc0             sub ax, ax
  039877  2EE7: 99               cdq 
  039878  2EE8: 2bdb             sub bx, bx
  03987A  2EEA: 9ae2001f18       lcall 0x181f, 0xe2
  03987F  2EEF: 9ac0031f18       lcall 0x181f, 0x3c0
  039884  2EF4: 5e               pop si
  039885  2EF5: c9               leave 
  039886  2EF6: cb               retf 

; ---- func_039888  size=1551  insns=530  prologue=ENTER 0x0072,0  terminal=RETF ----
  039888  2EF8: c8720000         enter 0x72, 0
  03988C  2EFC: 56               push si
  03988D  2EFD: f606825301       test byte ptr [0x5382], 1
  039892  2F02: 7410             je 0x2f14
  039894  2F04: 6a01             push 1
  039896  2F06: 68b611           push 0x11b6
  039899  2F09: 9a52061f18       lcall 0x181f, 0x652
  03989E  2F0E: 83c404           add sp, 4
  0398A1  2F11: 5e               pop si
  0398A2  2F12: c9               leave 
  0398A3  2F13: cb               retf 
  0398A4  2F14: ff7606           push word ptr [bp + 6]
  0398A7  2F17: 9a82051f18       lcall 0x181f, 0x582
  0398AC  2F1C: 83c402           add sp, 2
  0398AF  2F1F: 6a08             push 8
  0398B1  2F21: 0e               push cs
  0398B2  2F22: e89e05           call 0x34c3
  0398B5  2F25: 83c402           add sp, 2
  0398B8  2F28: 689000           push 0x90
  0398BB  2F2B: 6a02             push 2
  0398BD  2F2D: 684001           push 0x140
  0398C0  2F30: 6a00             push 0
  0398C2  2F32: ff36742e         push word ptr [0x2e74]
  0398C6  2F36: 9a22001f18       lcall 0x181f, 0x22
  0398CB  2F3B: 83c402           add sp, 2
  0398CE  2F3E: 52               push dx
  0398CF  2F3F: 50               push ax
  0398D0  2F40: 9a00011f18       lcall 0x181f, 0x100
  0398D5  2F45: 83c40c           add sp, 0xc
  0398D8  2F48: c746a60200       mov word ptr [bp - 0x5a], 2
  0398DD  2F4D: c746a20d00       mov word ptr [bp - 0x5e], 0xd
  0398E2  2F52: c7469a0000       mov word ptr [bp - 0x66], 0
  0398E7  2F57: ff36ae2d         push word ptr [0x2dae]
  0398EB  2F5B: ff36ac2d         push word ptr [0x2dac]
  0398EF  2F5F: ff36aa2d         push word ptr [0x2daa]
  0398F3  2F63: ff36a82d         push word ptr [0x2da8]
  0398F7  2F67: 6a77             push 0x77
  0398F9  2F69: 6b5e9a2d         imul bx, word ptr [bp - 0x66], 0x2d
  0398FD  2F6D: 035ea2           add bx, word ptr [bp - 0x5e]
  039900  2F70: 83eb03           sub bx, 3
  039903  2F73: 895eaa           mov word ptr [bp - 0x56], bx
  039906  2F76: 2bc0             sub ax, ax
  039908  2F78: ba3f01           mov dx, 0x13f
  03990B  2F7B: 9abc081f19       lcall 0x191f, 0x8bc
  039910  2F80: ff469a           inc word ptr [bp - 0x66]
  039913  2F83: 837e9a04         cmp word ptr [bp - 0x66], 4
  039917  2F87: 7cce             jl 0x2f57
  039919  2F89: c7469a0000       mov word ptr [bp - 0x66], 0
  03991E  2F8E: e9dc03           jmp 0x336d
  039921  2F91: 90               nop 
  039922  2F92: 6a04             push 4
  039924  2F94: ff7606           push word ptr [bp + 6]
  039927  2F97: 9ab4071f18       lcall 0x181f, 0x7b4
  03992C  2F9C: 83c404           add sp, 4
  03992F  2F9F: 0bc0             or ax, ax
  039931  2FA1: 7509             jne 0x2fac
  039933  2FA3: 3906a253         cmp word ptr [0x53a2], ax
  039937  2FA7: 7503             jne 0x2fac
  039939  2FA9: e9eb01           jmp 0x3197
  03993C  2FAC: c646b000         mov byte ptr [bp - 0x50], 0
  039940  2FB0: ff36782e         push word ptr [0x2e78]
  039944  2FB4: 8d46b0           lea ax, [bp - 0x50]
  039947  2FB7: 50               push ax
  039948  2FB8: 9a6e011f18       lcall 0x181f, 0x16e
  03994D  2FBD: 83c404           add sp, 4
  039950  2FC0: 8d46b0           lea ax, [bp - 0x50]
  039953  2FC3: 50               push ax
  039954  2FC4: 9abe011f18       lcall 0x181f, 0x1be
  039959  2FC9: 83c402           add sp, 2
  03995C  2FCC: 8b5e9a           mov bx, word ptr [bp - 0x66]
  03995F  2FCF: 8a879892         mov al, byte ptr [bx - 0x6d68]
  039963  2FD3: 2ae4             sub ah, ah
  039965  2FD5: 50               push ax
  039966  2FD6: 8d46b0           lea ax, [bp - 0x50]
  039969  2FD9: 16               push ss
  03996A  2FDA: 50               push ax
  03996B  2FDB: 9a82011f18       lcall 0x181f, 0x182
  039970  2FE0: 83c406           add sp, 6
  039973  2FE3: 689100           push 0x91
  039976  2FE6: ff76a2           push word ptr [bp - 0x5e]
  039979  2FE9: ff76a6           push word ptr [bp - 0x5a]
  03997C  2FEC: 8d46b0           lea ax, [bp - 0x50]
  03997F  2FEF: 16               push ss
  039980  2FF0: 50               push ax
  039981  2FF1: 9a3c011f18       lcall 0x181f, 0x13c
  039986  2FF6: 83c40a           add sp, 0xa
  039989  2FF9: c646b000         mov byte ptr [bp - 0x50], 0
  03998D  2FFD: ff367c2e         push word ptr [0x2e7c]
  039991  3001: 8d46b0           lea ax, [bp - 0x50]
  039994  3004: 50               push ax
  039995  3005: 9a6e011f18       lcall 0x181f, 0x16e
  03999A  300A: 83c404           add sp, 4
  03999D  300D: 8d46b0           lea ax, [bp - 0x50]
  0399A0  3010: 50               push ax
  0399A1  3011: 9abe011f18       lcall 0x181f, 0x1be
  0399A6  3016: 83c402           add sp, 2
  0399A9  3019: 8b5e9a           mov bx, word ptr [bp - 0x66]
  0399AC  301C: d1e3             shl bx, 1
  0399AE  301E: ffb74e94         push word ptr [bx - 0x6bb2]
  0399B2  3022: 8d46b0           lea ax, [bp - 0x50]
  0399B5  3025: 16               push ss
  0399B6  3026: 50               push ax
  0399B7  3027: 8bf3             mov si, bx
  0399B9  3029: 9a82011f18       lcall 0x181f, 0x182
  0399BE  302E: 83c406           add sp, 6
  0399C1  3031: 689100           push 0x91
  0399C4  3034: ff76a2           push word ptr [bp - 0x5e]
  0399C7  3037: 6a50             push 0x50
  0399C9  3039: 8d46b0           lea ax, [bp - 0x50]
  0399CC  303C: 16               push ss
  0399CD  303D: 50               push ax
  0399CE  303E: 9a3c011f18       lcall 0x181f, 0x13c
  0399D3  3043: 83c40a           add sp, 0xa
  0399D6  3046: c646b000         mov byte ptr [bp - 0x50], 0
  0399DA  304A: ff367a2e         push word ptr [0x2e7a]
  0399DE  304E: 8d46b0           lea ax, [bp - 0x50]
  0399E1  3051: 50               push ax
  0399E2  3052: 9a6e011f18       lcall 0x181f, 0x16e
  0399E7  3057: 83c404           add sp, 4
  0399EA  305A: 8d46b0           lea ax, [bp - 0x50]
  0399ED  305D: 50               push ax
  0399EE  305E: 9abe011f18       lcall 0x181f, 0x1be
  0399F3  3063: 83c402           add sp, 2
  0399F6  3066: 8b5e9a           mov bx, word ptr [bp - 0x66]
  0399F9  3069: 8a871094         mov al, byte ptr [bx - 0x6bf0]
  0399FD  306D: 2ae4             sub ah, ah
  0399FF  306F: 50               push ax
  039A00  3070: 8d46b0           lea ax, [bp - 0x50]
  039A03  3073: 16               push ss
  039A04  3074: 50               push ax
  039A05  3075: 9a82011f18       lcall 0x181f, 0x182
  039A0A  307A: 83c406           add sp, 6
  039A0D  307D: 689100           push 0x91
  039A10  3080: ff76a2           push word ptr [bp - 0x5e]
  039A13  3083: 68a000           push 0xa0
  039A16  3086: 8d46b0           lea ax, [bp - 0x50]
  039A19  3089: 16               push ss
  039A1A  308A: 50               push ax
  039A1B  308B: 9a3c011f18       lcall 0x181f, 0x13c
  039A20  3090: 83c40a           add sp, 0xa
  039A23  3093: c41e9e08         les bx, ptr [0x89e]
  039A27  3097: 268a07           mov al, byte ptr es:[bx]
  039A2A  309A: 2ae4             sub ah, ah
  039A2C  309C: 40               inc ax
  039A2D  309D: 0146a2           add word ptr [bp - 0x5e], ax
  039A30  30A0: c646b000         mov byte ptr [bp - 0x50], 0
  039A34  30A4: ff367e2e         push word ptr [0x2e7e]
  039A38  30A8: 8d46b0           lea ax, [bp - 0x50]
  039A3B  30AB: 50               push ax
  039A3C  30AC: 9a6e011f18       lcall 0x181f, 0x16e
  039A41  30B1: 83c404           add sp, 4
  039A44  30B4: 8d46b0           lea ax, [bp - 0x50]
  039A47  30B7: 50               push ax
  039A48  30B8: 9abe011f18       lcall 0x181f, 0x1be
  039A4D  30BD: 83c402           add sp, 2
  039A50  30C0: 8b841c94         mov ax, word ptr [si - 0x6be4]
  039A54  30C4: c1e803           shr ax, 3
  039A57  30C7: 50               push ax
  039A58  30C8: 8d46b0           lea ax, [bp - 0x50]
  039A5B  30CB: 16               push ss
  039A5C  30CC: 50               push ax
  039A5D  30CD: 9a82011f18       lcall 0x181f, 0x182
  039A62  30D2: 83c406           add sp, 6
  039A65  30D5: 689100           push 0x91
  039A68  30D8: ff76a2           push word ptr [bp - 0x5e]
  039A6B  30DB: ff76a6           push word ptr [bp - 0x5a]
  039A6E  30DE: 8d46b0           lea ax, [bp - 0x50]
  039A71  30E1: 16               push ss
  039A72  30E2: 50               push ax
  039A73  30E3: 9a3c011f18       lcall 0x181f, 0x13c
  039A78  30E8: 83c40a           add sp, 0xa
  039A7B  30EB: c646b000         mov byte ptr [bp - 0x50], 0
  039A7F  30EF: ff36802e         push word ptr [0x2e80]
  039A83  30F3: 8d46b0           lea ax, [bp - 0x50]
  039A86  30F6: 50               push ax
  039A87  30F7: 9a6e011f18       lcall 0x181f, 0x16e
  039A8C  30FC: 83c404           add sp, 4
  039A8F  30FF: 8d46b0           lea ax, [bp - 0x50]
  039A92  3102: 50               push ax
  039A93  3103: 9abe011f18       lcall 0x181f, 0x1be
  039A98  3108: 83c402           add sp, 2
  039A9B  310B: 6b5e9a13         imul bx, word ptr [bp - 0x66], 0x13
  039A9F  310F: 8a875d92         mov al, byte ptr [bx - 0x6da3]
  039AA3  3113: 2ae4             sub ah, ah
  039AA5  3115: 8a8f5c92         mov cl, byte ptr [bx - 0x6da4]
  039AA9  3119: 2aed             sub ch, ch
  039AAB  311B: 03c1             add ax, cx
  039AAD  311D: c1e003           shl ax, 3
  039AB0  3120: 8946ae           mov word ptr [bp - 0x52], ax
  039AB3  3123: 50               push ax
  039AB4  3124: 8d46b0           lea ax, [bp - 0x50]
  039AB7  3127: 16               push ss
  039AB8  3128: 50               push ax
  039AB9  3129: 9a82011f18       lcall 0x181f, 0x182
  039ABE  312E: 83c406           add sp, 6
  039AC1  3131: 689100           push 0x91
  039AC4  3134: ff76a2           push word ptr [bp - 0x5e]
  039AC7  3137: 6a50             push 0x50
  039AC9  3139: 8d46b0           lea ax, [bp - 0x50]
  039ACC  313C: 16               push ss
  039ACD  313D: 50               push ax
  039ACE  313E: 9a3c011f18       lcall 0x181f, 0x13c
  039AD3  3143: 83c40a           add sp, 0xa
  039AD6  3146: c646b000         mov byte ptr [bp - 0x50], 0
  039ADA  314A: ff36822e         push word ptr [0x2e82]
  039ADE  314E: 8d46b0           lea ax, [bp - 0x50]
  039AE1  3151: 50               push ax
  039AE2  3152: 9a6e011f18       lcall 0x181f, 0x16e
  039AE7  3157: 83c404           add sp, 4
  039AEA  315A: 8d46b0           lea ax, [bp - 0x50]
  039AED  315D: 50               push ax
  039AEE  315E: 9abe011f18       lcall 0x181f, 0x1be
  039AF3  3163: 83c402           add sp, 2
  039AF6  3166: 8b5e9a           mov bx, word ptr [bp - 0x66]
  039AF9  3169: 8a871494         mov al, byte ptr [bx - 0x6bec]
  039AFD  316D: 2ae4             sub ah, ah
  039AFF  316F: 50               push ax
  039B00  3170: 8d46b0           lea ax, [bp - 0x50]
  039B03  3173: 16               push ss
  039B04  3174: 50               push ax
  039B05  3175: 9a82011f18       lcall 0x181f, 0x182
  039B0A  317A: 83c406           add sp, 6
  039B0D  317D: 689100           push 0x91
  039B10  3180: ff76a2           push word ptr [bp - 0x5e]
  039B13  3183: b8a000           mov ax, 0xa0
  039B16  3186: 894698           mov word ptr [bp - 0x68], ax
  039B19  3189: 50               push ax
  039B1A  318A: 8d46b0           lea ax, [bp - 0x50]
  039B1D  318D: 16               push ss
  039B1E  318E: 50               push ax
  039B1F  318F: 9a3c011f18       lcall 0x181f, 0x13c
  039B24  3194: 83c40a           add sp, 0xa
  039B27  3197: c41e9e08         les bx, ptr [0x89e]
  039B2B  319B: 268a07           mov al, byte ptr es:[bx]
  039B2E  319E: 2ae4             sub ah, ah
  039B30  31A0: 40               inc ax
  039B31  31A1: 0146a2           add word ptr [bp - 0x5e], ax
  039B34  31A4: 8b46a6           mov ax, word ptr [bp - 0x5a]
  039B37  31A7: 894698           mov word ptr [bp - 0x68], ax
  039B3A  31AA: 2bc0             sub ax, ax
  039B3C  31AC: 8946a0           mov word ptr [bp - 0x60], ax
  039B3F  31AF: 894694           mov word ptr [bp - 0x6c], ax
  039B42  31B2: eb07             jmp 0x31bb
  039B44  31B4: 83469850         add word ptr [bp - 0x68], 0x50
  039B48  31B8: ff4694           inc word ptr [bp - 0x6c]
  039B4B  31BB: 837e9404         cmp word ptr [bp - 0x6c], 4
  039B4F  31BF: 7c03             jl 0x31c4
  039B51  31C1: e9c600           jmp 0x328a
  039B54  31C4: 8b469a           mov ax, word ptr [bp - 0x66]
  039B57  31C7: 394694           cmp word ptr [bp - 0x6c], ax
  039B5A  31CA: 74ec             je 0x31b8
  039B5C  31CC: ff7694           push word ptr [bp - 0x6c]
  039B5F  31CF: 50               push ax
  039B60  31D0: 9a380a1f18       lcall 0x181f, 0xa38
  039B65  31D5: 83c404           add sp, 4
  039B68  31D8: a820             test al, 0x20
  039B6A  31DA: 74dc             je 0x31b8
  039B6C  31DC: 8b4694           mov ax, word ptr [bp - 0x6c]
  039B6F  31DF: 3906d253         cmp word ptr [0x53d2], ax
  039B73  31E3: 74d3             je 0x31b8
  039B75  31E5: c746a00100       mov word ptr [bp - 0x60], 1
  039B7A  31EA: c646b000         mov byte ptr [bp - 0x50], 0
  039B7E  31EE: 8bd8             mov bx, ax
  039B80  31F0: d1e3             shl bx, 1
  039B82  31F2: ffb7428d         push word ptr [bx - 0x72be]
  039B86  31F6: 8d46b0           lea ax, [bp - 0x50]
  039B89  31F9: 50               push ax
  039B8A  31FA: 9a6e011f18       lcall 0x181f, 0x16e
  039B8F  31FF: 83c404           add sp, 4
  039B92  3202: 8d46b0           lea ax, [bp - 0x50]
  039B95  3205: 50               push ax
  039B96  3206: 9abe011f18       lcall 0x181f, 0x1be
  039B9B  320B: 83c402           add sp, 2
  039B9E  320E: 689100           push 0x91
  039BA1  3211: ff76a2           push word ptr [bp - 0x5e]
  039BA4  3214: ff7698           push word ptr [bp - 0x68]
  039BA7  3217: 8d46b0           lea ax, [bp - 0x50]
  039BAA  321A: 16               push ss
  039BAB  321B: 50               push ax
  039BAC  321C: 9a3c011f18       lcall 0x181f, 0x13c
  039BB1  3221: 83c40a           add sp, 0xa
  039BB4  3224: 89469e           mov word ptr [bp - 0x62], ax
  039BB7  3227: c646b000         mov byte ptr [bp - 0x50], 0
  039BBB  322B: ff7694           push word ptr [bp - 0x6c]
  039BBE  322E: ff769a           push word ptr [bp - 0x66]
  039BC1  3231: 9a380a1f18       lcall 0x181f, 0xa38
  039BC6  3236: 83c404           add sp, 4
  039BC9  3239: 254000           and ax, 0x40
  039BCC  323C: 894690           mov word ptr [bp - 0x70], ax
  039BCF  323F: 3d0100           cmp ax, 1
  039BD2  3242: 1bdb             sbb bx, bx
  039BD4  3244: 83c366           add bx, 0x66
  039BD7  3247: d1e3             shl bx, 1
  039BD9  3249: ffb7ba2d         push word ptr [bx + 0x2dba]
  039BDD  324D: 8d4eb0           lea cx, [bp - 0x50]
  039BE0  3250: 51               push cx
  039BE1  3251: 9a6e011f18       lcall 0x181f, 0x16e
  039BE6  3256: 83c404           add sp, 4
  039BE9  3259: 837e9001         cmp word ptr [bp - 0x70], 1
  039BED  325D: 1bc0             sbb ax, ax
  039BEF  325F: 24fd             and al, 0xfd
  039BF1  3261: 050f00           add ax, 0xf
  039BF4  3264: 50               push ax
  039BF5  3265: ff76a2           push word ptr [bp - 0x5e]
  039BF8  3268: ff769e           push word ptr [bp - 0x62]
  039BFB  326B: 8d46b0           lea ax, [bp - 0x50]
  039BFE  326E: 16               push ss
  039BFF  326F: 50               push ax
  039C00  3270: 9a3c011f18       lcall 0x181f, 0x13c
  039C05  3275: 83c40a           add sp, 0xa
  039C08  3278: 837e9850         cmp word ptr [bp - 0x68], 0x50
  039C0C  327C: 7c03             jl 0x3281
  039C0E  327E: e933ff           jmp 0x31b4
  039C11  3281: c746985000       mov word ptr [bp - 0x68], 0x50
  039C16  3286: e92fff           jmp 0x31b8
  039C19  3289: 90               nop 
  039C1A  328A: 837ea000         cmp word ptr [bp - 0x60], 0
  039C1E  328E: 740d             je 0x329d
  039C20  3290: c41e9e08         les bx, ptr [0x89e]
  039C24  3294: 268a07           mov al, byte ptr es:[bx]
  039C27  3297: 2ae4             sub ah, ah
  039C29  3299: 40               inc ax
  039C2A  329A: 0146a2           add word ptr [bp - 0x5e], ax
  039C2D  329D: 8b46a6           mov ax, word ptr [bp - 0x5a]
  039C30  32A0: 894698           mov word ptr [bp - 0x68], ax
  039C33  32A3: 695e9a3c01       imul bx, word ptr [bp - 0x66], 0x13c
  039C38  32A8: f687088804       test byte ptr [bx - 0x77f8], 4
  039C3D  32AD: 7403             je 0x32b2
  039C3F  32AF: e9af00           jmp 0x3361
  039C42  32B2: 8b769a           mov si, word ptr [bp - 0x66]
  039C45  32B5: 8a8c1094         mov cl, byte ptr [si - 0x6bf0]
  039C49  32B9: 2aed             sub ch, ch
  039C4B  32BB: 8a872188         mov al, byte ptr [bx - 0x77df]
  039C4F  32BF: 2ae4             sub ah, ah
  039C51  32C1: f7e9             imul cx
  039C53  32C3: bb6400           mov bx, 0x64
  039C56  32C6: 99               cdq 
  039C57  32C7: f7fb             idiv bx
  039C59  32C9: 894696           mov word ptr [bp - 0x6a], ax
  039C5C  32CC: 2bc8             sub cx, ax
  039C5E  32CE: 894ea4           mov word ptr [bp - 0x5c], cx
  039C61  32D1: c646b000         mov byte ptr [bp - 0x50], 0
  039C65  32D5: ff36662e         push word ptr [0x2e66]
  039C69  32D9: 8d46b0           lea ax, [bp - 0x50]
  039C6C  32DC: 50               push ax
  039C6D  32DD: 9a6e011f18       lcall 0x181f, 0x16e
  039C72  32E2: 83c404           add sp, 4
  039C75  32E5: 8d46b0           lea ax, [bp - 0x50]
  039C78  32E8: 50               push ax
  039C79  32E9: 9abe011f18       lcall 0x181f, 0x1be
  039C7E  32EE: 83c402           add sp, 2
  039C81  32F1: ff7696           push word ptr [bp - 0x6a]
  039C84  32F4: 8d46b0           lea ax, [bp - 0x50]
  039C87  32F7: 16               push ss
  039C88  32F8: 50               push ax
  039C89  32F9: 9a82011f18       lcall 0x181f, 0x182
  039C8E  32FE: 83c406           add sp, 6
  039C91  3301: 689100           push 0x91
  039C94  3304: ff76a2           push word ptr [bp - 0x5e]
  039C97  3307: ff7698           push word ptr [bp - 0x68]
  039C9A  330A: 8d46b0           lea ax, [bp - 0x50]
  039C9D  330D: 16               push ss
  039C9E  330E: 50               push ax
  039C9F  330F: 9a3c011f18       lcall 0x181f, 0x13c
  039CA4  3314: 83c40a           add sp, 0xa
  039CA7  3317: c646b000         mov byte ptr [bp - 0x50], 0
  039CAB  331B: ff36682e         push word ptr [0x2e68]
  039CAF  331F: 8d46b0           lea ax, [bp - 0x50]
  039CB2  3322: 50               push ax
  039CB3  3323: 9a6e011f18       lcall 0x181f, 0x16e
  039CB8  3328: 83c404           add sp, 4
  039CBB  332B: 8d46b0           lea ax, [bp - 0x50]
  039CBE  332E: 50               push ax
  039CBF  332F: 9abe011f18       lcall 0x181f, 0x1be
  039CC4  3334: 83c402           add sp, 2
  039CC7  3337: ff76a4           push word ptr [bp - 0x5c]
  039CCA  333A: 8d46b0           lea ax, [bp - 0x50]
  039CCD  333D: 16               push ss
  039CCE  333E: 50               push ax
  039CCF  333F: 9a82011f18       lcall 0x181f, 0x182
  039CD4  3344: 83c406           add sp, 6
  039CD7  3347: 689100           push 0x91
  039CDA  334A: ff76a2           push word ptr [bp - 0x5e]
  039CDD  334D: b85000           mov ax, 0x50
  039CE0  3350: 894698           mov word ptr [bp - 0x68], ax
  039CE3  3353: 50               push ax
  039CE4  3354: 8d46b0           lea ax, [bp - 0x50]
  039CE7  3357: 16               push ss
  039CE8  3358: 50               push ax
  039CE9  3359: 9a3c011f18       lcall 0x181f, 0x13c
  039CEE  335E: 83c40a           add sp, 0xa
  039CF1  3361: 8b46aa           mov ax, word ptr [bp - 0x56]
  039CF4  3364: 052d00           add ax, 0x2d
  039CF7  3367: 8946a2           mov word ptr [bp - 0x5e], ax
  039CFA  336A: ff469a           inc word ptr [bp - 0x66]
  039CFD  336D: 837e9a04         cmp word ptr [bp - 0x66], 4
  039D01  3371: 7c03             jl 0x3376
  039D03  3373: e90401           jmp 0x347a
  039D06  3376: c646b000         mov byte ptr [bp - 0x50], 0
  039D0A  337A: 6b469a34         imul ax, word ptr [bp - 0x66], 0x34
  039D0E  337E: 050e54           add ax, 0x540e
  039D11  3381: 50               push ax
  039D12  3382: 8d46b0           lea ax, [bp - 0x50]
  039D15  3385: 50               push ax
  039D16  3386: 9aa4071d0d       lcall 0xd1d, 0x7a4
  039D1B  338B: 83c404           add sp, 4
  039D1E  338E: ff36762e         push word ptr [0x2e76]
  039D22  3392: 8d46b0           lea ax, [bp - 0x50]
  039D25  3395: 50               push ax
  039D26  3396: 9a6e011f18       lcall 0x181f, 0x16e
  039D2B  339B: 83c404           add sp, 4
  039D2E  339E: 8d46b0           lea ax, [bp - 0x50]
  039D31  33A1: 50               push ax
  039D32  33A2: 9a78011f18       lcall 0x181f, 0x178
  039D37  33A7: 83c402           add sp, 2
  039D3A  33AA: 689200           push 0x92
  039D3D  33AD: 8b46a2           mov ax, word ptr [bp - 0x5e]
  039D40  33B0: 8946aa           mov word ptr [bp - 0x56], ax
  039D43  33B3: 50               push ax
  039D44  33B4: ff76a6           push word ptr [bp - 0x5a]
  039D47  33B7: 8d46b0           lea ax, [bp - 0x50]
  039D4A  33BA: 16               push ss
  039D4B  33BB: 50               push ax
  039D4C  33BC: 9a3c011f18       lcall 0x181f, 0x13c
  039D51  33C1: 83c40a           add sp, 0xa
  039D54  33C4: 894698           mov word ptr [bp - 0x68], ax
  039D57  33C7: c646b000         mov byte ptr [bp - 0x50], 0
  039D5B  33CB: 695e9a3c01       imul bx, word ptr [bp - 0x66], 0x13c
  039D60  33D0: f687088804       test byte ptr [bx - 0x77f8], 4
  039D65  33D5: 741c             je 0x33f3
  039D67  33D7: ff36382f         push word ptr [0x2f38]
  039D6B  33DB: 8d46b0           lea ax, [bp - 0x50]
  039D6E  33DE: 50               push ax
  039D6F  33DF: 9a6e011f18       lcall 0x181f, 0x16e
  039D74  33E4: 83c404           add sp, 4
  039D77  33E7: 8d46b0           lea ax, [bp - 0x50]
  039D7A  33EA: 50               push ax
  039D7B  33EB: 9a78011f18       lcall 0x181f, 0x178
  039D80  33F0: 83c402           add sp, 2
  039D83  33F3: ff769a           push word ptr [bp - 0x66]
  039D86  33F6: 9aa4091f18       lcall 0x181f, 0x9a4
  039D8B  33FB: 83c402           add sp, 2
  039D8E  33FE: 50               push ax
  039D8F  33FF: 8d46b0           lea ax, [bp - 0x50]
  039D92  3402: 50               push ax
  039D93  3403: 9a6e011f18       lcall 0x181f, 0x16e
  039D98  3408: 83c404           add sp, 4
  039D9B  340B: 8d46b0           lea ax, [bp - 0x50]
  039D9E  340E: 50               push ax
  039D9F  340F: 9abe011f18       lcall 0x181f, 0x1be
  039DA4  3414: 83c402           add sp, 2
  039DA7  3417: 6a61             push 0x61
  039DA9  3419: ff76a2           push word ptr [bp - 0x5e]
  039DAC  341C: ff7698           push word ptr [bp - 0x68]
  039DAF  341F: 8d46b0           lea ax, [bp - 0x50]
  039DB2  3422: 16               push ss
  039DB3  3423: 50               push ax
  039DB4  3424: 9a3c011f18       lcall 0x181f, 0x13c
  039DB9  3429: 83c40a           add sp, 0xa
  039DBC  342C: c41e9e08         les bx, ptr [0x89e]
  039DC0  3430: 268a07           mov al, byte ptr es:[bx]
  039DC3  3433: 2ae4             sub ah, ah
  039DC5  3435: 8bc8             mov cx, ax
  039DC7  3437: 40               inc ax
  039DC8  3438: 0146a2           add word ptr [bp - 0x5e], ax
  039DCB  343B: 8b469a           mov ax, word ptr [bp - 0x66]
  039DCE  343E: 3906d253         cmp word ptr [0x53d2], ax
  039DD2  3442: 7403             je 0x3447
  039DD4  3444: e94bfb           jmp 0x2f92
  039DD7  3447: c646b000         mov byte ptr [bp - 0x50], 0
  039DDB  344B: 41               inc cx
  039DDC  344C: 014ea2           add word ptr [bp - 0x5e], cx
  039DDF  344F: ff36362f         push word ptr [0x2f36]
  039DE3  3453: 8d46b0           lea ax, [bp - 0x50]
  039DE6  3456: 50               push ax
  039DE7  3457: 9a6e011f18       lcall 0x181f, 0x16e
  039DEC  345C: 83c404           add sp, 4
  039DEF  345F: 689100           push 0x91
  039DF2  3462: ff76a2           push word ptr [bp - 0x5e]
  039DF5  3465: 684001           push 0x140
  039DF8  3468: 6a00             push 0
  039DFA  346A: 8d46b0           lea ax, [bp - 0x50]
  039DFD  346D: 16               push ss
  039DFE  346E: 50               push ax
  039DFF  346F: 9a00011f18       lcall 0x181f, 0x100
  039E04  3474: 83c40c           add sp, 0xc
  039E07  3477: e9e7fe           jmp 0x3361
  039E0A  347A: 6aff             push -1
  039E0C  347C: 6afe             push -2
  039E0E  347E: 0e               push cs
  039E0F  347F: e81e00           call 0x34a0
  039E12  3482: 83c404           add sp, 4
  039E15  3485: 6a00             push 0
  039E17  3487: 684001           push 0x140
  039E1A  348A: 68c800           push 0xc8
  039E1D  348D: 2bc0             sub ax, ax
  039E1F  348F: 99               cdq 
  039E20  3490: 2bdb             sub bx, bx
  039E22  3492: 9ae2001f18       lcall 0x181f, 0xe2
  039E27  3497: 9ac0031f18       lcall 0x181f, 0x3c0
  039E2C  349C: 5e               pop si
  039E2D  349D: c9               leave 
  039E2E  349E: cb               retf 
  039E2F  349F: 90               nop 
  039E30  34A0: eae80e1f19       ljmp 0x191f:0xee8
  039E35  34A5: eaf60e1f19       ljmp 0x191f:0xef6
  039E3A  34AA: ea040f1f19       ljmp 0x191f:0xf04
  039E3F  34AF: ea120f1f19       ljmp 0x191f:0xf12
  039E44  34B4: ea200f1f19       ljmp 0x191f:0xf20
  039E49  34B9: ea2e0f1f19       ljmp 0x191f:0xf2e
  039E4E  34BE: ea3c0f1f19       ljmp 0x191f:0xf3c
  039E53  34C3: ea4a0f1f19       ljmp 0x191f:0xf4a
  039E58  34C8: ea580f1f19       ljmp 0x191f:0xf58
  039E5D  34CD: 006a00           add byte ptr [bp + si], ch
  039E60  34D0: ff36ae2d         push word ptr [0x2dae]
  039E64  34D4: ff36ac2d         push word ptr [0x2dac]
  039E68  34D8: ff36aa2d         push word ptr [0x2daa]
  039E6C  34DC: ff36a82d         push word ptr [0x2da8]
  039E70  34E0: 68c611           push 0x11c6
  039E73  34E3: 9a7a081f19       lcall 0x191f, 0x87a
  039E78  34E8: 83c40c           add sp, 0xc
  039E7B  34EB: 0bc0             or ax, ax
  039E7D  34ED: 7417             je 0x3506
  039E7F  34EF: ff36ae2d         push word ptr [0x2dae]
  039E83  34F3: ff36ac2d         push word ptr [0x2dac]
  039E87  34F7: ff36aa2d         push word ptr [0x2daa]
  039E8B  34FB: ff36a82d         push word ptr [0x2da8]
  039E8F  34FF: b008             mov al, 8
  039E91  3501: 9a84041f18       lcall 0x181f, 0x484
  039E96  3506: cb               retf 

; ---- func_039E98  size=73  insns=22  prologue=push bp;mov bp,sp  terminal=RET ----
  039E98  3508: 55               push bp
  039E99  3509: 8bec             mov bp, sp
  039E9B  350B: 83060e2d08       add word ptr [0x2d0e], 8
  039EA0  3510: 813e0e2d2401     cmp word ptr [0x2d0e], 0x124
  039EA6  3516: 7c13             jl 0x352b
  039EA8  3518: 8306102d08       add word ptr [0x2d10], 8
  039EAD  351D: a00e2d           mov al, byte ptr [0x2d0e]
  039EB0  3520: 250800           and ax, 8
  039EB3  3523: d1f8             sar ax, 1
  039EB5  3525: 051000           add ax, 0x10
  039EB8  3528: a30e2d           mov word ptr [0x2d0e], ax
  039EBB  352B: 813e102d9000     cmp word ptr [0x2d10], 0x90
  039EC1  3531: 7d1c             jge 0x354f
  039EC3  3533: ff364008         push word ptr [0x840]
  039EC7  3537: ff363e08         push word ptr [0x83e]
  039ECB  353B: ff36102d         push word ptr [0x2d10]
  039ECF  353F: 8b4604           mov ax, word ptr [bp + 4]
  039ED2  3542: 8d1ea82d         lea bx, [0x2da8]
  039ED6  3546: 8b160e2d         mov dx, word ptr [0x2d0e]
  039EDA  354A: 9a54021f18       lcall 0x181f, 0x254
  039EDF  354F: c9               leave 
  039EE0  3550: c3               ret 

; ---- func_039EE2  size=2781  insns=960  prologue=ENTER 0x007E,0  terminal=RETF ----
  039EE2  3552: c87e0000         enter 0x7e, 0
  039EE6  3556: a0a853           mov al, byte ptr [0x53a8]
  039EE9  3559: 98               cwde 
  039EEA  355A: 8bc8             mov cx, ax
  039EEC  355C: b064             mov al, 0x64
  039EEE  355E: f62ea753         imul byte ptr [0x53a7]
  039EF2  3562: 03c8             add cx, ax
  039EF4  3564: 894e96           mov word ptr [bp - 0x6a], cx
  039EF7  3567: 2bc0             sub ax, ax
  039EF9  3569: 8946aa           mov word ptr [bp - 0x56], ax
  039EFC  356C: 894692           mov word ptr [bp - 0x6e], ax
  039EFF  356F: 8946fe           mov word ptr [bp - 2], ax
  039F02  3572: 8946a6           mov word ptr [bp - 0x5a], ax
  039F05  3575: 8946ac           mov word ptr [bp - 0x54], ax
  039F08  3578: 8946a0           mov word ptr [bp - 0x60], ax
  039F0B  357B: 894694           mov word ptr [bp - 0x6c], ax
  039F0E  357E: 8946a8           mov word ptr [bp - 0x58], ax
  039F11  3581: 89469c           mov word ptr [bp - 0x64], ax
  039F14  3584: 89468c           mov word ptr [bp - 0x74], ax
  039F17  3587: 894682           mov word ptr [bp - 0x7e], ax
  039F1A  358A: eb1a             jmp 0x35a6
  039F1C  358C: a19853           mov ax, word ptr [0x5398]
  039F1F  358F: 394682           cmp word ptr [bp - 0x7e], ax
  039F22  3592: 740f             je 0x35a3
  039F24  3594: 695e823c01       imul bx, word ptr [bp - 0x7e], 0x13c
  039F29  3599: f687088804       test byte ptr [bx - 0x77f8], 4
  039F2E  359E: 7403             je 0x35a3
  039F30  35A0: ff46aa           inc word ptr [bp - 0x56]
  039F33  35A3: ff4682           inc word ptr [bp - 0x7e]
  039F36  35A6: 837e8204         cmp word ptr [bp - 0x7e], 4
  039F3A  35AA: 7ce0             jl 0x358c
  039F3C  35AC: a19853           mov ax, word ptr [0x5398]
  039F3F  35AF: 894682           mov word ptr [bp - 0x7e], ax
  039F42  35B2: 837e0600         cmp word ptr [bp + 6], 0
  039F46  35B6: 7503             jne 0x35bb
  039F48  35B8: e94f01           jmp 0x370a
  039F4B  35BB: 0e               push cs
  039F4C  35BC: e82a14           call 0x49e9
  039F4F  35BF: a03108           mov al, byte ptr [0x831]
  039F52  35C2: 2ae4             sub ah, ah
  039F54  35C4: 50               push ax
  039F55  35C5: b80500           mov ax, 5
  039F58  35C8: 89469e           mov word ptr [bp - 0x62], ax
  039F5B  35CB: 50               push ax
  039F5C  35CC: 684001           push 0x140
  039F5F  35CF: 6a00             push 0
  039F61  35D1: ff369e2e         push word ptr [0x2e9e]
  039F65  35D5: 9a22001f18       lcall 0x181f, 0x22
  039F6A  35DA: 83c402           add sp, 2
  039F6D  35DD: 52               push dx
  039F6E  35DE: 50               push ax
  039F6F  35DF: 9a00011f18       lcall 0x181f, 0x100
  039F74  35E4: 83c40c           add sp, 0xc
  039F77  35E7: f606825310       test byte ptr [0x5382], 0x10
  039F7C  35EC: 742c             je 0x361a
  039F7E  35EE: a03008           mov al, byte ptr [0x830]
  039F81  35F1: 2ae4             sub ah, ah
  039F83  35F3: 50               push ax
  039F84  35F4: b86100           mov ax, 0x61
  039F87  35F7: 89469e           mov word ptr [bp - 0x62], ax
  039F8A  35FA: 50               push ax
  039F8B  35FB: 684001           push 0x140
  039F8E  35FE: 6a00             push 0
  039F90  3600: ff36b62e         push word ptr [0x2eb6]
  039F94  3604: 9a22001f18       lcall 0x181f, 0x22
  039F99  3609: 83c402           add sp, 2
  039F9C  360C: 52               push dx
  039F9D  360D: 50               push ax
  039F9E  360E: 9a00011f18       lcall 0x181f, 0x100
  039FA3  3613: 83c40c           add sp, 0xc
  039FA6  3616: e9ef09           jmp 0x4008
  039FA9  3619: 90               nop 
  039FAA  361A: c41e9e08         les bx, ptr [0x89e]
  039FAE  361E: 268a07           mov al, byte ptr es:[bx]
  039FB1  3621: 2ae4             sub ah, ah
  039FB3  3623: 40               inc ax
  039FB4  3624: 01469e           add word ptr [bp - 0x62], ax
  039FB7  3627: c646ae00         mov byte ptr [bp - 0x52], 0
  039FBB  362B: 8a1ea653         mov bl, byte ptr [0x53a6]
  039FBF  362F: 2aff             sub bh, bh
  039FC1  3631: d1e3             shl bx, 1
  039FC3  3633: ffb79483         push word ptr [bx - 0x7c6c]
  039FC7  3637: 8d46ae           lea ax, [bp - 0x52]
  039FCA  363A: 50               push ax
  039FCB  363B: 9a6e011f18       lcall 0x181f, 0x16e
  039FD0  3640: 83c404           add sp, 4
  039FD3  3643: 8d46ae           lea ax, [bp - 0x52]
  039FD6  3646: 50               push ax
  039FD7  3647: 9a78011f18       lcall 0x181f, 0x178
  039FDC  364C: 83c402           add sp, 2
  039FDF  364F: 6b468234         imul ax, word ptr [bp - 0x7e], 0x34
  039FE3  3653: 050e54           add ax, 0x540e
  039FE6  3656: 50               push ax
  039FE7  3657: 8d46ae           lea ax, [bp - 0x52]
  039FEA  365A: 50               push ax
  039FEB  365B: 9aa4071d0d       lcall 0xd1d, 0x7a4
  039FF0  3660: 83c404           add sp, 4
  039FF3  3663: 8d46ae           lea ax, [bp - 0x52]
  039FF6  3666: 50               push ax
  039FF7  3667: 9a78011f18       lcall 0x181f, 0x178
  039FFC  366C: 83c402           add sp, 2
  039FFF  366F: ff36e02d         push word ptr [0x2de0]
  03A003  3673: 8d46ae           lea ax, [bp - 0x52]
  03A006  3676: 50               push ax
  03A007  3677: 9a6e011f18       lcall 0x181f, 0x16e
  03A00C  367C: 83c404           add sp, 4
  03A00F  367F: 8d46ae           lea ax, [bp - 0x52]
  03A012  3682: 50               push ax
  03A013  3683: 9a78011f18       lcall 0x181f, 0x178
  03A018  3688: 83c402           add sp, 2
  03A01B  368B: ff7682           push word ptr [bp - 0x7e]
  03A01E  368E: 9a5e061f18       lcall 0x181f, 0x65e
  03A023  3693: 83c402           add sp, 2
  03A026  3696: 50               push ax
  03A027  3697: 8d46ae           lea ax, [bp - 0x52]
  03A02A  369A: 50               push ax
  03A02B  369B: 9a6e011f18       lcall 0x181f, 0x16e
  03A030  36A0: 83c404           add sp, 4
  03A033  36A3: 8d46ae           lea ax, [bp - 0x52]
  03A036  36A6: 50               push ax
  03A037  36A7: 9abe011f18       lcall 0x181f, 0x1be
  03A03C  36AC: 83c402           add sp, 2
  03A03F  36AF: 8b1e8c53         mov bx, word ptr [0x538c]
  03A043  36B3: d1e3             shl bx, 1
  03A045  36B5: ffb70098         push word ptr [bx - 0x6800]
  03A049  36B9: 8d46ae           lea ax, [bp - 0x52]
  03A04C  36BC: 50               push ax
  03A04D  36BD: 9a6e011f18       lcall 0x181f, 0x16e
  03A052  36C2: 83c404           add sp, 4
  03A055  36C5: 8d46ae           lea ax, [bp - 0x52]
  03A058  36C8: 50               push ax
  03A059  36C9: 9a78011f18       lcall 0x181f, 0x178
  03A05E  36CE: 83c402           add sp, 2
  03A061  36D1: ff368a53         push word ptr [0x538a]
  03A065  36D5: 8d46ae           lea ax, [bp - 0x52]
  03A068  36D8: 16               push ss
  03A069  36D9: 50               push ax
  03A06A  36DA: 9a82011f18       lcall 0x181f, 0x182
  03A06F  36DF: 83c406           add sp, 6
  03A072  36E2: a03108           mov al, byte ptr [0x831]
  03A075  36E5: 2ae4             sub ah, ah
  03A077  36E7: 50               push ax
  03A078  36E8: ff769e           push word ptr [bp - 0x62]
  03A07B  36EB: 684001           push 0x140
  03A07E  36EE: 6a00             push 0
  03A080  36F0: 8d46ae           lea ax, [bp - 0x52]
  03A083  36F3: 16               push ss
  03A084  36F4: 50               push ax
  03A085  36F5: 9a00011f18       lcall 0x181f, 0x100
  03A08A  36FA: 83c40c           add sp, 0xc
  03A08D  36FD: c41e9e08         les bx, ptr [0x89e]
  03A091  3701: 268a07           mov al, byte ptr es:[bx]
  03A094  3704: 2ae4             sub ah, ah
  03A096  3706: 40               inc ax
  03A097  3707: 01469e           add word ptr [bp - 0x62], ax
  03A09A  370A: c7469e1800       mov word ptr [bp - 0x62], 0x18
  03A09F  370F: b81000           mov ax, 0x10
  03A0A2  3712: 8946a4           mov word ptr [bp - 0x5c], ax
  03A0A5  3715: a30e2d           mov word ptr [0x2d0e], ax
  03A0A8  3718: c706102d2000     mov word ptr [0x2d10], 0x20
  03A0AE  371E: c746840000       mov word ptr [bp - 0x7c], 0
  03A0B3  3723: eb68             jmp 0x378d
  03A0B5  3725: 90               nop 
  03A0B6  3726: c746a20000       mov word ptr [bp - 0x5e], 0
  03A0BB  372B: eb20             jmp 0x374d
  03A0BD  372D: 90               nop 
  03A0BE  372E: 837e9019         cmp word ptr [bp - 0x70], 0x19
  03A0C2  3732: 740c             je 0x3740
  03A0C4  3734: 837e901a         cmp word ptr [bp - 0x70], 0x1a
  03A0C8  3738: 7406             je 0x3740
  03A0CA  373A: 837e901b         cmp word ptr [bp - 0x70], 0x1b
  03A0CE  373E: 7506             jne 0x3746
  03A0D0  3740: ff4692           inc word ptr [bp - 0x6e]
  03A0D3  3743: eb05             jmp 0x374a
  03A0D5  3745: 90               nop 
  03A0D6  3746: 83469204         add word ptr [bp - 0x6e], 4
  03A0DA  374A: ff46a2           inc word ptr [bp - 0x5e]
  03A0DD  374D: 8b1e4285         mov bx, word ptr [0x8542]
  03A0E1  3751: 8a471f           mov al, byte ptr [bx + 0x1f]
  03A0E4  3754: 98               cwde 
  03A0E5  3755: 3b46a2           cmp ax, word ptr [bp - 0x5e]
  03A0E8  3758: 7e30             jle 0x378a
  03A0EA  375A: ff76a2           push word ptr [bp - 0x5e]
  03A0ED  375D: 9a540c1f18       lcall 0x181f, 0xc54
  03A0F2  3762: 83c402           add sp, 2
  03A0F5  3765: 894690           mov word ptr [bp - 0x70], ax
  03A0F8  3768: 9ac6021f18       lcall 0x181f, 0x2c6
  03A0FD  376D: 894698           mov word ptr [bp - 0x68], ax
  03A100  3770: 837e0600         cmp word ptr [bp + 6], 0
  03A104  3774: 7407             je 0x377d
  03A106  3776: 50               push ax
  03A107  3777: e88efd           call 0x3508
  03A10A  377A: 83c402           add sp, 2
  03A10D  377D: 837e901c         cmp word ptr [bp - 0x70], 0x1c
  03A111  3781: 75ab             jne 0x372e
  03A113  3783: 83469202         add word ptr [bp - 0x6e], 2
  03A117  3787: ebc1             jmp 0x374a
  03A119  3789: 90               nop 
  03A11A  378A: ff4684           inc word ptr [bp - 0x7c]
  03A11D  378D: a19e53           mov ax, word ptr [0x539e]
  03A120  3790: 394684           cmp word ptr [bp - 0x7c], ax
  03A123  3793: 7d2f             jge 0x37c4
  03A125  3795: ff7684           push word ptr [bp - 0x7c]
  03A128  3798: 9ae6091f18       lcall 0x181f, 0x9e6
  03A12D  379D: 83c402           add sp, 2
  03A130  37A0: 8a4682           mov al, byte ptr [bp - 0x7e]
  03A133  37A3: 8b1e4285         mov bx, word ptr [0x8542]
  03A137  37A7: 38471a           cmp byte ptr [bx + 0x1a], al
  03A13A  37AA: 7503             jne 0x37af
  03A13C  37AC: e977ff           jmp 0x3726
  03A13F  37AF: f606825301       test byte ptr [0x5382], 1
  03A144  37B4: 74d4             je 0x378a
  03A146  37B6: a0d253           mov al, byte ptr [0x53d2]
  03A149  37B9: 38471a           cmp byte ptr [bx + 0x1a], al
  03A14C  37BC: 7503             jne 0x37c1
  03A14E  37BE: e965ff           jmp 0x3726
  03A151  37C1: ebc7             jmp 0x378a
  03A153  37C3: 90               nop 
  03A154  37C4: c746860000       mov word ptr [bp - 0x7a], 0
  03A159  37C9: eb13             jmp 0x37de
  03A15B  37CB: 90               nop 
  03A15C  37CC: ff7686           push word ptr [bp - 0x7a]
  03A15F  37CF: 9a780b1f18       lcall 0x181f, 0xb78
  03A164  37D4: 83c402           add sp, 2
  03A167  37D7: 0bc0             or ax, ax
  03A169  37D9: 7d2f             jge 0x380a
  03A16B  37DB: ff4686           inc word ptr [bp - 0x7a]
  03A16E  37DE: a19c53           mov ax, word ptr [0x539c]
  03A171  37E1: 394686           cmp word ptr [bp - 0x7a], ax
  03A174  37E4: 7c03             jl 0x37e9
  03A176  37E6: e98300           jmp 0x386c
  03A179  37E9: 6b5e861c         imul bx, word ptr [bp - 0x7a], 0x1c
  03A17D  37ED: 8a874731         mov al, byte ptr [bx + 0x3147]
  03A181  37F1: 240f             and al, 0xf
  03A183  37F3: 3a4682           cmp al, byte ptr [bp - 0x7e]
  03A186  37F6: 74d4             je 0x37cc
  03A188  37F8: f606825301       test byte ptr [0x5382], 1
  03A18D  37FD: 74dc             je 0x37db
  03A18F  37FF: a1d253           mov ax, word ptr [0x53d2]
  03A192  3802: 394682           cmp word ptr [bp - 0x7e], ax
  03A195  3805: 74c5             je 0x37cc
  03A197  3807: ebd2             jmp 0x37db
  03A199  3809: 90               nop 
  03A19A  380A: 8b4686           mov ax, word ptr [bp - 0x7a]
  03A19D  380D: 9ada021f18       lcall 0x181f, 0x2da
  03A1A2  3812: 894698           mov word ptr [bp - 0x68], ax
  03A1A5  3815: 3d4a00           cmp ax, 0x4a
  03A1A8  3818: 7c19             jl 0x3833
  03A1AA  381A: 3d4e00           cmp ax, 0x4e
  03A1AD  381D: 7f14             jg 0x3833
  03A1AF  381F: 6b5e861c         imul bx, word ptr [bp - 0x7a], 0x1c
  03A1B3  3823: 8a875b31         mov al, byte ptr [bx + 0x315b]
  03A1B7  3827: 98               cwde 
  03A1B8  3828: 894690           mov word ptr [bp - 0x70], ax
  03A1BB  382B: 9ac6021f18       lcall 0x181f, 0x2c6
  03A1C0  3830: 894698           mov word ptr [bp - 0x68], ax
  03A1C3  3833: 837e0600         cmp word ptr [bp + 6], 0
  03A1C7  3837: 7407             je 0x3840
  03A1C9  3839: 50               push ax
  03A1CA  383A: e8cbfc           call 0x3508
  03A1CD  383D: 83c402           add sp, 2
  03A1D0  3840: 837e901c         cmp word ptr [bp - 0x70], 0x1c
  03A1D4  3844: 7506             jne 0x384c
  03A1D6  3846: 83469202         add word ptr [bp - 0x6e], 2
  03A1DA  384A: eb8f             jmp 0x37db
  03A1DC  384C: 837e9019         cmp word ptr [bp - 0x70], 0x19
  03A1E0  3850: 740c             je 0x385e
  03A1E2  3852: 837e901a         cmp word ptr [bp - 0x70], 0x1a
  03A1E6  3856: 7406             je 0x385e
  03A1E8  3858: 837e901b         cmp word ptr [bp - 0x70], 0x1b
  03A1EC  385C: 7506             jne 0x3864
  03A1EE  385E: ff4692           inc word ptr [bp - 0x6e]
  03A1F1  3861: e977ff           jmp 0x37db
  03A1F4  3864: 83469204         add word ptr [bp - 0x6e], 4
  03A1F8  3868: e970ff           jmp 0x37db
  03A1FB  386B: 90               nop 
  03A1FC  386C: 837e0600         cmp word ptr [bp + 6], 0
  03A200  3870: 7503             jne 0x3875
  03A202  3872: e98500           jmp 0x38fa
  03A205  3875: c646ae00         mov byte ptr [bp - 0x52], 0
  03A209  3879: ff7682           push word ptr [bp - 0x7e]
  03A20C  387C: 9a5e061f18       lcall 0x181f, 0x65e
  03A211  3881: 83c402           add sp, 2
  03A214  3884: 50               push ax
  03A215  3885: 8d46ae           lea ax, [bp - 0x52]
  03A218  3888: 50               push ax
  03A219  3889: 9a6e011f18       lcall 0x181f, 0x16e
  03A21E  388E: 83c404           add sp, 4
  03A221  3891: 8d46ae           lea ax, [bp - 0x52]
  03A224  3894: 50               push ax
  03A225  3895: 9a78011f18       lcall 0x181f, 0x178
  03A22A  389A: 83c402           add sp, 2
  03A22D  389D: ff36a02e         push word ptr [0x2ea0]
  03A231  38A1: 8d46ae           lea ax, [bp - 0x52]
  03A234  38A4: 50               push ax
  03A235  38A5: 9a6e011f18       lcall 0x181f, 0x16e
  03A23A  38AA: 83c404           add sp, 4
  03A23D  38AD: 8d46ae           lea ax, [bp - 0x52]
  03A240  38B0: 50               push ax
  03A241  38B1: 9abe011f18       lcall 0x181f, 0x1be
  03A246  38B6: 83c402           add sp, 2
  03A249  38B9: 8d46ae           lea ax, [bp - 0x52]
  03A24C  38BC: 50               push ax
  03A24D  38BD: 9a78011f18       lcall 0x181f, 0x178
  03A252  38C2: 83c402           add sp, 2
  03A255  38C5: 8d46ae           lea ax, [bp - 0x52]
  03A258  38C8: 50               push ax
  03A259  38C9: 9a46011f18       lcall 0x181f, 0x146
  03A25E  38CE: 83c402           add sp, 2
  03A261  38D1: ff7692           push word ptr [bp - 0x6e]
  03A264  38D4: 8d46ae           lea ax, [bp - 0x52]
  03A267  38D7: 16               push ss
  03A268  38D8: 50               push ax
  03A269  38D9: 9a82011f18       lcall 0x181f, 0x182
  03A26E  38DE: 83c406           add sp, 6
  03A271  38E1: a03008           mov al, byte ptr [0x830]
  03A274  38E4: 2ae4             sub ah, ah
  03A276  38E6: 50               push ax
  03A277  38E7: ff769e           push word ptr [bp - 0x62]
  03A27A  38EA: ff76a4           push word ptr [bp - 0x5c]
  03A27D  38ED: 8d46ae           lea ax, [bp - 0x52]
  03A280  38F0: 16               push ss
  03A281  38F1: 50               push ax
  03A282  38F2: 9a3c011f18       lcall 0x181f, 0x13c
  03A287  38F7: 83c40a           add sp, 0xa
  03A28A  38FA: c7468a1000       mov word ptr [bp - 0x76], 0x10
  03A28F  38FF: a1102d           mov ax, word ptr [0x2d10]
  03A292  3902: 051400           add ax, 0x14
  03A295  3905: 89469e           mov word ptr [bp - 0x62], ax
  03A298  3908: c41e9e08         les bx, ptr [0x89e]
  03A29C  390C: 268a0f           mov cl, byte ptr es:[bx]
  03A29F  390F: 2aed             sub ch, ch
  03A2A1  3911: 03c1             add ax, cx
  03A2A3  3913: 40               inc ax
  03A2A4  3914: 894688           mov word ptr [bp - 0x78], ax
  03A2A7  3917: c7469a0000       mov word ptr [bp - 0x66], 0
  03A2AC  391C: ff769a           push word ptr [bp - 0x66]
  03A2AF  391F: ff7682           push word ptr [bp - 0x7e]
  03A2B2  3922: 9ab4071f18       lcall 0x181f, 0x7b4
  03A2B7  3927: 83c404           add sp, 4
  03A2BA  392A: 0bc0             or ax, ax
  03A2BC  392C: 7466             je 0x3994
  03A2BE  392E: 8346a805         add word ptr [bp - 0x58], 5
  03A2C2  3932: 837e0600         cmp word ptr [bp + 6], 0
  03A2C6  3936: 745c             je 0x3994
  03A2C8  3938: c646ae00         mov byte ptr [bp - 0x52], 0
  03A2CC  393C: 8b5e9a           mov bx, word ptr [bp - 0x66]
  03A2CF  393F: 8bc3             mov ax, bx
  03A2D1  3941: d1e3             shl bx, 1
  03A2D3  3943: 03d8             add bx, ax
  03A2D5  3945: d1e3             shl bx, 1
  03A2D7  3947: ffb75296         push word ptr [bx - 0x69ae]
  03A2DB  394B: 8d46ae           lea ax, [bp - 0x52]
  03A2DE  394E: 50               push ax
  03A2DF  394F: 9a6e011f18       lcall 0x181f, 0x16e
  03A2E4  3954: 83c404           add sp, 4
  03A2E7  3957: 817e889000       cmp word ptr [bp - 0x78], 0x90
  03A2EC  395C: 7f19             jg 0x3977
  03A2EE  395E: a03008           mov al, byte ptr [0x830]
  03A2F1  3961: 2ae4             sub ah, ah
  03A2F3  3963: 50               push ax
  03A2F4  3964: ff7688           push word ptr [bp - 0x78]
  03A2F7  3967: ff768a           push word ptr [bp - 0x76]
  03A2FA  396A: 8d46ae           lea ax, [bp - 0x52]
  03A2FD  396D: 16               push ss
  03A2FE  396E: 50               push ax
  03A2FF  396F: 9a3c011f18       lcall 0x181f, 0x13c
  03A304  3974: 83c40a           add sp, 0xa
  03A307  3977: 83468a48         add word ptr [bp - 0x76], 0x48
  03A30B  397B: 817e8a2c01       cmp word ptr [bp - 0x76], 0x12c
  03A310  3980: 7e12             jle 0x3994
  03A312  3982: c7468a1000       mov word ptr [bp - 0x76], 0x10
  03A317  3987: c41e9e08         les bx, ptr [0x89e]
  03A31B  398B: 268a07           mov al, byte ptr es:[bx]
  03A31E  398E: 2ae4             sub ah, ah
  03A320  3990: 40               inc ax
  03A321  3991: 014688           add word ptr [bp - 0x78], ax
  03A324  3994: ff469a           inc word ptr [bp - 0x66]
  03A327  3997: 837e9a19         cmp word ptr [bp - 0x66], 0x19
  03A32B  399B: 7d03             jge 0x39a0
  03A32D  399D: e97cff           jmp 0x391c
  03A330  39A0: c646ae00         mov byte ptr [bp - 0x52], 0
  03A334  39A4: ff7682           push word ptr [bp - 0x7e]
  03A337  39A7: 9a5e061f18       lcall 0x181f, 0x65e
  03A33C  39AC: 83c402           add sp, 2
  03A33F  39AF: 50               push ax
  03A340  39B0: 8d46ae           lea ax, [bp - 0x52]
  03A343  39B3: 50               push ax
  03A344  39B4: 9a6e011f18       lcall 0x181f, 0x16e
  03A349  39B9: 83c404           add sp, 4
  03A34C  39BC: 8d46ae           lea ax, [bp - 0x52]
  03A34F  39BF: 50               push ax
  03A350  39C0: 9a78011f18       lcall 0x181f, 0x178
  03A355  39C5: 83c402           add sp, 2
  03A358  39C8: ff36c62e         push word ptr [0x2ec6]
  03A35C  39CC: 8d46ae           lea ax, [bp - 0x52]
  03A35F  39CF: 50               push ax
  03A360  39D0: 9a6e011f18       lcall 0x181f, 0x16e
  03A365  39D5: 83c404           add sp, 4
  03A368  39D8: 8d46ae           lea ax, [bp - 0x52]
  03A36B  39DB: 50               push ax
  03A36C  39DC: 9abe011f18       lcall 0x181f, 0x1be
  03A371  39E1: 83c402           add sp, 2
  03A374  39E4: 8d46ae           lea ax, [bp - 0x52]
  03A377  39E7: 50               push ax
  03A378  39E8: 9a46011f18       lcall 0x181f, 0x146
  03A37D  39ED: 83c402           add sp, 2
  03A380  39F0: ff76a8           push word ptr [bp - 0x58]
  03A383  39F3: 8d46ae           lea ax, [bp - 0x52]
  03A386  39F6: 16               push ss
  03A387  39F7: 50               push ax
  03A388  39F8: 9a82011f18       lcall 0x181f, 0x182
  03A38D  39FD: 83c406           add sp, 6
  03A390  3A00: a03008           mov al, byte ptr [0x830]
  03A393  3A03: 2ae4             sub ah, ah
  03A395  3A05: 50               push ax
  03A396  3A06: ff769e           push word ptr [bp - 0x62]
  03A399  3A09: ff76a4           push word ptr [bp - 0x5c]
  03A39C  3A0C: 8d46ae           lea ax, [bp - 0x52]
  03A39F  3A0F: 16               push ss
  03A3A0  3A10: 50               push ax
  03A3A1  3A11: 9a3c011f18       lcall 0x181f, 0x13c
  03A3A6  3A16: 83c40a           add sp, 0xa
  03A3A9  3A19: 817e9e9000       cmp word ptr [bp - 0x62], 0x90
  03A3AE  3A1E: 7f08             jg 0x3a28
  03A3B0  3A20: c7469e9600       mov word ptr [bp - 0x62], 0x96
  03A3B5  3A25: eb0e             jmp 0x3a35
  03A3B7  3A27: 90               nop 
  03A3B8  3A28: c41e9e08         les bx, ptr [0x89e]
  03A3BC  3A2C: 268a07           mov al, byte ptr es:[bx]
  03A3BF  3A2F: 2ae4             sub ah, ah
  03A3C1  3A31: 40               inc ax
  03A3C2  3A32: 01469e           add word ptr [bp - 0x62], ax
  03A3C5  3A35: b81000           mov ax, 0x10
  03A3C8  3A38: 8946a4           mov word ptr [bp - 0x5c], ax
  03A3CB  3A3B: 89468a           mov word ptr [bp - 0x76], ax
  03A3CE  3A3E: ff7682           push word ptr [bp - 0x7e]
  03A3D1  3A41: 9a82051f18       lcall 0x181f, 0x582
  03A3D6  3A46: 83c402           add sp, 2
  03A3D9  3A49: 8b1efc84         mov bx, word ptr [0x84fc]
  03A3DD  3A4D: 837f2c00         cmp word ptr [bx + 0x2c], 0
  03A3E1  3A51: 7d03             jge 0x3a56
  03A3E3  3A53: e9be00           jmp 0x3b14
  03A3E6  3A56: 7f0a             jg 0x3a62
  03A3E8  3A58: 817f2ae803       cmp word ptr [bx + 0x2a], 0x3e8
  03A3ED  3A5D: 7303             jae 0x3a62
  03A3EF  3A5F: e9b200           jmp 0x3b14
  03A3F2  3A62: 6a00             push 0
  03A3F4  3A64: 68e803           push 0x3e8
  03A3F7  3A67: ff772c           push word ptr [bx + 0x2c]
  03A3FA  3A6A: ff772a           push word ptr [bx + 0x2a]
  03A3FD  3A6D: 9ac60e1d0d       lcall 0xd1d, 0xec6
  03A402  3A72: 8946fe           mov word ptr [bp - 2], ax
  03A405  3A75: 837e0600         cmp word ptr [bp + 6], 0
  03A409  3A79: 7503             jne 0x3a7e
  03A40B  3A7B: e99600           jmp 0x3b14
  03A40E  3A7E: c646ae00         mov byte ptr [bp - 0x52], 0
  03A412  3A82: ff36302e         push word ptr [0x2e30]
  03A416  3A86: 8d46ae           lea ax, [bp - 0x52]
  03A419  3A89: 50               push ax
  03A41A  3A8A: 9a6e011f18       lcall 0x181f, 0x16e
  03A41F  3A8F: 83c404           add sp, 4
  03A422  3A92: 8d46ae           lea ax, [bp - 0x52]
  03A425  3A95: 50               push ax
  03A426  3A96: 9abe011f18       lcall 0x181f, 0x1be
  03A42B  3A9B: 83c402           add sp, 2
  03A42E  3A9E: 8d46ae           lea ax, [bp - 0x52]
  03A431  3AA1: 50               push ax
  03A432  3AA2: 9a1e011f18       lcall 0x181f, 0x11e
  03A437  3AA7: 83c402           add sp, 2
  03A43A  3AAA: 8b1efc84         mov bx, word ptr [0x84fc]
  03A43E  3AAE: ff772c           push word ptr [bx + 0x2c]
  03A441  3AB1: ff772a           push word ptr [bx + 0x2a]
  03A444  3AB4: 8d46ae           lea ax, [bp - 0x52]
  03A447  3AB7: 16               push ss
  03A448  3AB8: 50               push ax
  03A449  3AB9: 9ad8001f18       lcall 0x181f, 0xd8
  03A44E  3ABE: 83c408           add sp, 8
  03A451  3AC1: 8d46ae           lea ax, [bp - 0x52]
  03A454  3AC4: 50               push ax
  03A455  3AC5: 9a28011f18       lcall 0x181f, 0x128
  03A45A  3ACA: 83c402           add sp, 2
  03A45D  3ACD: 8d46ae           lea ax, [bp - 0x52]
  03A460  3AD0: 50               push ax
  03A461  3AD1: 9a78011f18       lcall 0x181f, 0x178
  03A466  3AD6: 83c402           add sp, 2
  03A469  3AD9: 8d46ae           lea ax, [bp - 0x52]
  03A46C  3ADC: 50               push ax
  03A46D  3ADD: 9a46011f18       lcall 0x181f, 0x146
  03A472  3AE2: 83c402           add sp, 2
  03A475  3AE5: ff76fe           push word ptr [bp - 2]
  03A478  3AE8: 8d46ae           lea ax, [bp - 0x52]
  03A47B  3AEB: 16               push ss
  03A47C  3AEC: 50               push ax
  03A47D  3AED: 9a82011f18       lcall 0x181f, 0x182
  03A482  3AF2: 83c406           add sp, 6
  03A485  3AF5: a03008           mov al, byte ptr [0x830]
  03A488  3AF8: 2ae4             sub ah, ah
  03A48A  3AFA: 50               push ax
  03A48B  3AFB: ff769e           push word ptr [bp - 0x62]
  03A48E  3AFE: 6a10             push 0x10
  03A490  3B00: 8d46ae           lea ax, [bp - 0x52]
  03A493  3B03: 16               push ss
  03A494  3B04: 50               push ax
  03A495  3B05: 9a3c011f18       lcall 0x181f, 0x13c
  03A49A  3B0A: 83c40a           add sp, 0xa
  03A49D  3B0D: 89468a           mov word ptr [bp - 0x76], ax
  03A4A0  3B10: 83468a14         add word ptr [bp - 0x76], 0x14
  03A4A4  3B14: 8b1efc84         mov bx, word ptr [0x84fc]
  03A4A8  3B18: 807f1800         cmp byte ptr [bx + 0x18], 0
  03A4AC  3B1C: 7503             jne 0x3b21
  03A4AE  3B1E: e99300           jmp 0x3bb4
  03A4B1  3B21: 8a4718           mov al, byte ptr [bx + 0x18]
  03A4B4  3B24: 2ae4             sub ah, ah
  03A4B6  3B26: b9ffff           mov cx, 0xffff
  03A4B9  3B29: 8a16a653         mov dl, byte ptr [0x53a6]
  03A4BD  3B2D: 2af6             sub dh, dh
  03A4BF  3B2F: 2bca             sub cx, dx
  03A4C1  3B31: 8bd8             mov bx, ax
  03A4C3  3B33: f7e9             imul cx
  03A4C5  3B35: 894694           mov word ptr [bp - 0x6c], ax
  03A4C8  3B38: 837e0600         cmp word ptr [bp + 6], 0
  03A4CC  3B3C: 7476             je 0x3bb4
  03A4CE  3B3E: c646ae00         mov byte ptr [bp - 0x52], 0
  03A4D2  3B42: 53               push bx
  03A4D3  3B43: 8d46ae           lea ax, [bp - 0x52]
  03A4D6  3B46: 16               push ss
  03A4D7  3B47: 50               push ax
  03A4D8  3B48: 9a82011f18       lcall 0x181f, 0x182
  03A4DD  3B4D: 83c406           add sp, 6
  03A4E0  3B50: 8d46ae           lea ax, [bp - 0x52]
  03A4E3  3B53: 50               push ax
  03A4E4  3B54: 9a78011f18       lcall 0x181f, 0x178
  03A4E9  3B59: 83c402           add sp, 2
  03A4EC  3B5C: ff36a42e         push word ptr [0x2ea4]
  03A4F0  3B60: 8d46ae           lea ax, [bp - 0x52]
  03A4F3  3B63: 50               push ax
  03A4F4  3B64: 9a6e011f18       lcall 0x181f, 0x16e
  03A4F9  3B69: 83c404           add sp, 4
  03A4FC  3B6C: 8d46ae           lea ax, [bp - 0x52]
  03A4FF  3B6F: 50               push ax
  03A500  3B70: 9abe011f18       lcall 0x181f, 0x1be
  03A505  3B75: 83c402           add sp, 2
  03A508  3B78: 8d46ae           lea ax, [bp - 0x52]
  03A50B  3B7B: 50               push ax
  03A50C  3B7C: 9a78011f18       lcall 0x181f, 0x178
  03A511  3B81: 83c402           add sp, 2
  03A514  3B84: ff7694           push word ptr [bp - 0x6c]
  03A517  3B87: 8d46ae           lea ax, [bp - 0x52]
  03A51A  3B8A: 16               push ss
  03A51B  3B8B: 50               push ax
  03A51C  3B8C: 9a82011f18       lcall 0x181f, 0x182
  03A521  3B91: 83c406           add sp, 6
  03A524  3B94: a03008           mov al, byte ptr [0x830]
  03A527  3B97: 2ae4             sub ah, ah
  03A529  3B99: 50               push ax
  03A52A  3B9A: ff769e           push word ptr [bp - 0x62]
  03A52D  3B9D: ff768a           push word ptr [bp - 0x76]
  03A530  3BA0: 8d46ae           lea ax, [bp - 0x52]
  03A533  3BA3: 16               push ss
  03A534  3BA4: 50               push ax
  03A535  3BA5: 9a3c011f18       lcall 0x181f, 0x13c
  03A53A  3BAA: 83c40a           add sp, 0xa
  03A53D  3BAD: 89468a           mov word ptr [bp - 0x76], ax
  03A540  3BB0: 83468a14         add word ptr [bp - 0x76], 0x14
  03A544  3BB4: c41e9e08         les bx, ptr [0x89e]
  03A548  3BB8: 268a07           mov al, byte ptr es:[bx]
  03A54B  3BBB: 2ae4             sub ah, ah
  03A54D  3BBD: 40               inc ax
  03A54E  3BBE: 01469e           add word ptr [bp - 0x62], ax
  03A551  3BC1: 8b46a4           mov ax, word ptr [bp - 0x5c]
  03A554  3BC4: 89468a           mov word ptr [bp - 0x76], ax
  03A557  3BC7: 833ed05300       cmp word ptr [0x53d0], 0
  03A55C  3BCC: 7503             jne 0x3bd1
  03A55E  3BCE: e99400           jmp 0x3c65
  03A561  3BD1: 8b0ed053         mov cx, word ptr [0x53d0]
  03A565  3BD5: 894ea6           mov word ptr [bp - 0x5a], cx
  03A568  3BD8: 837e0600         cmp word ptr [bp + 6], 0
  03A56C  3BDC: 7503             jne 0x3be1
  03A56E  3BDE: e98400           jmp 0x3c65
  03A571  3BE1: c646ae00         mov byte ptr [bp - 0x52], 0
  03A575  3BE5: ff36442e         push word ptr [0x2e44]
  03A579  3BE9: 8d4eae           lea cx, [bp - 0x52]
  03A57C  3BEC: 51               push cx
  03A57D  3BED: 9a6e011f18       lcall 0x181f, 0x16e
  03A582  3BF2: 83c404           add sp, 4
  03A585  3BF5: 8d46ae           lea ax, [bp - 0x52]
  03A588  3BF8: 50               push ax
  03A589  3BF9: 9a78011f18       lcall 0x181f, 0x178
  03A58E  3BFE: 83c402           add sp, 2
  03A591  3C01: ff36482e         push word ptr [0x2e48]
  03A595  3C05: 8d46ae           lea ax, [bp - 0x52]
  03A598  3C08: 50               push ax
  03A599  3C09: 9a6e011f18       lcall 0x181f, 0x16e
  03A59E  3C0E: 83c404           add sp, 4
  03A5A1  3C11: 8d46ae           lea ax, [bp - 0x52]
  03A5A4  3C14: 50               push ax
  03A5A5  3C15: 9abe011f18       lcall 0x181f, 0x1be
  03A5AA  3C1A: 83c402           add sp, 2
  03A5AD  3C1D: 8d46ae           lea ax, [bp - 0x52]
  03A5B0  3C20: 50               push ax
  03A5B1  3C21: 9a78011f18       lcall 0x181f, 0x178
  03A5B6  3C26: 83c402           add sp, 2
  03A5B9  3C29: 8d46ae           lea ax, [bp - 0x52]
  03A5BC  3C2C: 50               push ax
  03A5BD  3C2D: 9a46011f18       lcall 0x181f, 0x146
  03A5C2  3C32: 83c402           add sp, 2
  03A5C5  3C35: ff76a6           push word ptr [bp - 0x5a]
  03A5C8  3C38: 8d46ae           lea ax, [bp - 0x52]
  03A5CB  3C3B: 16               push ss
  03A5CC  3C3C: 50               push ax
  03A5CD  3C3D: 9a82011f18       lcall 0x181f, 0x182
  03A5D2  3C42: 83c406           add sp, 6
  03A5D5  3C45: a03008           mov al, byte ptr [0x830]
  03A5D8  3C48: 2ae4             sub ah, ah
  03A5DA  3C4A: 50               push ax
  03A5DB  3C4B: ff769e           push word ptr [bp - 0x62]
  03A5DE  3C4E: ff768a           push word ptr [bp - 0x76]
  03A5E1  3C51: 8d46ae           lea ax, [bp - 0x52]
  03A5E4  3C54: 16               push ss
  03A5E5  3C55: 50               push ax
  03A5E6  3C56: 9a3c011f18       lcall 0x181f, 0x13c
  03A5EB  3C5B: 83c40a           add sp, 0xa
  03A5EE  3C5E: 89468a           mov word ptr [bp - 0x76], ax
  03A5F1  3C61: 83468a14         add word ptr [bp - 0x76], 0x14
  03A5F5  3C65: f606825308       test byte ptr [0x5382], 8
  03A5FA  3C6A: 7503             jne 0x3c6f
  03A5FC  3C6C: e9dd00           jmp 0x3d4c
  03A5FF  3C6F: 817e96f406       cmp word ptr [bp - 0x6a], 0x6f4
  03A604  3C74: 7c03             jl 0x3c79
  03A606  3C76: e9d300           jmp 0x3d4c
  03A609  3C79: b8f406           mov ax, 0x6f4
  03A60C  3C7C: 2b4696           sub ax, word ptr [bp - 0x6a]
  03A60F  3C7F: d1e0             shl ax, 1
  03A611  3C81: 89469c           mov word ptr [bp - 0x64], ax
  03A614  3C84: 837e0600         cmp word ptr [bp + 6], 0
  03A618  3C88: 7503             jne 0x3c8d
  03A61A  3C8A: e9bf00           jmp 0x3d4c
  03A61D  3C8D: c646ae00         mov byte ptr [bp - 0x52], 0
  03A621  3C91: ff36d62e         push word ptr [0x2ed6]
  03A625  3C95: 8d4eae           lea cx, [bp - 0x52]
  03A628  3C98: 51               push cx
  03A629  3C99: 9a6e011f18       lcall 0x181f, 0x16e
  03A62E  3C9E: 83c404           add sp, 4
  03A631  3CA1: 8d46ae           lea ax, [bp - 0x52]
  03A634  3CA4: 50               push ax
  03A635  3CA5: 9a78011f18       lcall 0x181f, 0x178
  03A63A  3CAA: 83c402           add sp, 2
  03A63D  3CAD: 8d46ae           lea ax, [bp - 0x52]
  03A640  3CB0: 50               push ax
  03A641  3CB1: 9a1e011f18       lcall 0x181f, 0x11e
  03A646  3CB6: 83c402           add sp, 2
  03A649  3CB9: 8b1e8c53         mov bx, word ptr [0x538c]
  03A64D  3CBD: d1e3             shl bx, 1
  03A64F  3CBF: ffb70098         push word ptr [bx - 0x6800]
  03A653  3CC3: 8d46ae           lea ax, [bp - 0x52]
  03A656  3CC6: 50               push ax
  03A657  3CC7: 9a6e011f18       lcall 0x181f, 0x16e
  03A65C  3CCC: 83c404           add sp, 4
  03A65F  3CCF: 8d46ae           lea ax, [bp - 0x52]
  03A662  3CD2: 50               push ax
  03A663  3CD3: 9a78011f18       lcall 0x181f, 0x178
  03A668  3CD8: 83c402           add sp, 2
  03A66B  3CDB: ff368a53         push word ptr [0x538a]
  03A66F  3CDF: 8d46ae           lea ax, [bp - 0x52]
  03A672  3CE2: 16               push ss
  03A673  3CE3: 50               push ax
  03A674  3CE4: 9a82011f18       lcall 0x181f, 0x182
  03A679  3CE9: 83c406           add sp, 6
  03A67C  3CEC: 8d46ae           lea ax, [bp - 0x52]
  03A67F  3CEF: 50               push ax
  03A680  3CF0: 9a28011f18       lcall 0x181f, 0x128
  03A685  3CF5: 83c402           add sp, 2
  03A688  3CF8: 8d46ae           lea ax, [bp - 0x52]
  03A68B  3CFB: 50               push ax
  03A68C  3CFC: 9abe011f18       lcall 0x181f, 0x1be
  03A691  3D01: 83c402           add sp, 2
  03A694  3D04: 8d46ae           lea ax, [bp - 0x52]
  03A697  3D07: 50               push ax
  03A698  3D08: 9a78011f18       lcall 0x181f, 0x178
  03A69D  3D0D: 83c402           add sp, 2
  03A6A0  3D10: 8d46ae           lea ax, [bp - 0x52]
  03A6A3  3D13: 50               push ax
  03A6A4  3D14: 9a46011f18       lcall 0x181f, 0x146
  03A6A9  3D19: 83c402           add sp, 2
  03A6AC  3D1C: ff769c           push word ptr [bp - 0x64]
  03A6AF  3D1F: 8d46ae           lea ax, [bp - 0x52]
  03A6B2  3D22: 16               push ss
  03A6B3  3D23: 50               push ax
  03A6B4  3D24: 9a82011f18       lcall 0x181f, 0x182
  03A6B9  3D29: 83c406           add sp, 6
  03A6BC  3D2C: a03008           mov al, byte ptr [0x830]
  03A6BF  3D2F: 2ae4             sub ah, ah
  03A6C1  3D31: 50               push ax
  03A6C2  3D32: ff769e           push word ptr [bp - 0x62]
  03A6C5  3D35: ff768a           push word ptr [bp - 0x76]
  03A6C8  3D38: 8d46ae           lea ax, [bp - 0x52]
  03A6CB  3D3B: 16               push ss
  03A6CC  3D3C: 50               push ax
  03A6CD  3D3D: 9a3c011f18       lcall 0x181f, 0x13c
  03A6D2  3D42: 83c40a           add sp, 0xa
  03A6D5  3D45: 89468a           mov word ptr [bp - 0x76], ax
  03A6D8  3D48: 83468a14         add word ptr [bp - 0x76], 0x14
  03A6DC  3D4C: 833ed05300       cmp word ptr [0x53d0], 0
  03A6E1  3D51: 750e             jne 0x3d61
  03A6E3  3D53: f606825308       test byte ptr [0x5382], 8
  03A6E8  3D58: 7414             je 0x3d6e
  03A6EA  3D5A: 817e96f406       cmp word ptr [bp - 0x6a], 0x6f4
  03A6EF  3D5F: 7d0d             jge 0x3d6e
  03A6F1  3D61: c41e9e08         les bx, ptr [0x89e]
  03A6F5  3D65: 268a07           mov al, byte ptr es:[bx]
  03A6F8  3D68: 2ae4             sub ah, ah
  03A6FA  3D6A: 40               inc ax
  03A6FB  3D6B: 01469e           add word ptr [bp - 0x62], ax
  03A6FE  3D6E: 8b46a4           mov ax, word ptr [bp - 0x5c]
  03A701  3D71: 89468a           mov word ptr [bp - 0x76], ax
  03A704  3D74: f606825302       test byte ptr [0x5382], 2
  03A709  3D79: 7478             je 0x3df3
  03A70B  3D7B: 8b1efc84         mov bx, word ptr [0x84fc]
  03A70F  3D7F: 837f0c64         cmp word ptr [bx + 0xc], 0x64
  03A713  3D83: 7c6e             jl 0x3df3
  03A715  3D85: 8b470c           mov ax, word ptr [bx + 0xc]
  03A718  3D88: b96400           mov cx, 0x64
  03A71B  3D8B: 99               cdq 
  03A71C  3D8C: f7f9             idiv cx
  03A71E  3D8E: 3bc1             cmp ax, cx
  03A720  3D90: 7e02             jle 0x3d94
  03A722  3D92: 8bc1             mov ax, cx
  03A724  3D94: 8946a0           mov word ptr [bp - 0x60], ax
  03A727  3D97: c646ae00         mov byte ptr [bp - 0x52], 0
  03A72B  3D9B: ff36e497         push word ptr [0x97e4]
  03A72F  3D9F: 8d46ae           lea ax, [bp - 0x52]
  03A732  3DA2: 50               push ax
  03A733  3DA3: 9a6e011f18       lcall 0x181f, 0x16e
  03A738  3DA8: 83c404           add sp, 4
  03A73B  3DAB: 8d46ae           lea ax, [bp - 0x52]
  03A73E  3DAE: 50               push ax
  03A73F  3DAF: 9abe011f18       lcall 0x181f, 0x1be
  03A744  3DB4: 83c402           add sp, 2
  03A747  3DB7: 8d46ae           lea ax, [bp - 0x52]
  03A74A  3DBA: 50               push ax
  03A74B  3DBB: 9a46011f18       lcall 0x181f, 0x146
  03A750  3DC0: 83c402           add sp, 2
  03A753  3DC3: ff76a0           push word ptr [bp - 0x60]
  03A756  3DC6: 8d46ae           lea ax, [bp - 0x52]
  03A759  3DC9: 16               push ss
  03A75A  3DCA: 50               push ax
  03A75B  3DCB: 9a82011f18       lcall 0x181f, 0x182
  03A760  3DD0: 83c406           add sp, 6
  03A763  3DD3: a03008           mov al, byte ptr [0x830]
  03A766  3DD6: 2ae4             sub ah, ah
  03A768  3DD8: 50               push ax
  03A769  3DD9: ff769e           push word ptr [bp - 0x62]
  03A76C  3DDC: ff768a           push word ptr [bp - 0x76]
  03A76F  3DDF: 8d46ae           lea ax, [bp - 0x52]
  03A772  3DE2: 16               push ss
  03A773  3DE3: 50               push ax
  03A774  3DE4: 9a3c011f18       lcall 0x181f, 0x13c
  03A779  3DE9: 83c40a           add sp, 0xa
  03A77C  3DEC: 89468a           mov word ptr [bp - 0x76], ax
  03A77F  3DEF: 83468a14         add word ptr [bp - 0x76], 0x14
  03A783  3DF3: f606825308       test byte ptr [0x5382], 8
  03A788  3DF8: 7503             jne 0x3dfd
  03A78A  3DFA: e9ee00           jmp 0x3eeb
  03A78D  3DFD: 8a4eaa           mov cl, byte ptr [bp - 0x56]
  03A790  3E00: b86400           mov ax, 0x64
  03A793  3E03: d3f8             sar ax, cl
  03A795  3E05: 8946ac           mov word ptr [bp - 0x54], ax
  03A798  3E08: 837e0600         cmp word ptr [bp + 6], 0
  03A79C  3E0C: 7503             jne 0x3e11
  03A79E  3E0E: e9da00           jmp 0x3eeb
  03A7A1  3E11: c646ae00         mov byte ptr [bp - 0x52], 0
  03A7A5  3E15: ff36a22e         push word ptr [0x2ea2]
  03A7A9  3E19: 8d46ae           lea ax, [bp - 0x52]
  03A7AC  3E1C: 50               push ax
  03A7AD  3E1D: 9a6e011f18       lcall 0x181f, 0x16e
  03A7B2  3E22: 83c404           add sp, 4
  03A7B5  3E25: 8d46ae           lea ax, [bp - 0x52]
  03A7B8  3E28: 50               push ax
  03A7B9  3E29: 9a78011f18       lcall 0x181f, 0x178
  03A7BE  3E2E: 83c402           add sp, 2
  03A7C1  3E31: ff36a82e         push word ptr [0x2ea8]
  03A7C5  3E35: 8d46ae           lea ax, [bp - 0x52]
  03A7C8  3E38: 50               push ax
  03A7C9  3E39: 9a6e011f18       lcall 0x181f, 0x16e
  03A7CE  3E3E: 83c404           add sp, 4
  03A7D1  3E41: 837eaa00         cmp word ptr [bp - 0x56], 0
  03A7D5  3E45: 7450             je 0x3e97
  03A7D7  3E47: 8d46ae           lea ax, [bp - 0x52]
  03A7DA  3E4A: 50               push ax
  03A7DB  3E4B: 9a78011f18       lcall 0x181f, 0x178
  03A7E0  3E50: 83c402           add sp, 2
  03A7E3  3E53: 8d46ae           lea ax, [bp - 0x52]
  03A7E6  3E56: 50               push ax
  03A7E7  3E57: 9a1e011f18       lcall 0x181f, 0x11e
  03A7EC  3E5C: 83c402           add sp, 2
  03A7EF  3E5F: ff76aa           push word ptr [bp - 0x56]
  03A7F2  3E62: 8d46ae           lea ax, [bp - 0x52]
  03A7F5  3E65: 16               push ss
  03A7F6  3E66: 50               push ax
  03A7F7  3E67: 9a82011f18       lcall 0x181f, 0x182
  03A7FC  3E6C: 83c406           add sp, 6
  03A7FF  3E6F: 8d46ae           lea ax, [bp - 0x52]
  03A802  3E72: 50               push ax
  03A803  3E73: 9a78011f18       lcall 0x181f, 0x178
  03A808  3E78: 83c402           add sp, 2
  03A80B  3E7B: ff36d82e         push word ptr [0x2ed8]
  03A80F  3E7F: 8d46ae           lea ax, [bp - 0x52]
  03A812  3E82: 50               push ax
  03A813  3E83: 9a6e011f18       lcall 0x181f, 0x16e
  03A818  3E88: 83c404           add sp, 4
  03A81B  3E8B: 8d46ae           lea ax, [bp - 0x52]
  03A81E  3E8E: 50               push ax
  03A81F  3E8F: 9a28011f18       lcall 0x181f, 0x128
  03A824  3E94: 83c402           add sp, 2
  03A827  3E97: 8d46ae           lea ax, [bp - 0x52]
  03A82A  3E9A: 50               push ax
  03A82B  3E9B: 9abe011f18       lcall 0x181f, 0x1be
  03A830  3EA0: 83c402           add sp, 2
  03A833  3EA3: 8d46ae           lea ax, [bp - 0x52]
  03A836  3EA6: 50               push ax
  03A837  3EA7: 9a46011f18       lcall 0x181f, 0x146
  03A83C  3EAC: 83c402           add sp, 2
  03A83F  3EAF: ff76ac           push word ptr [bp - 0x54]
  03A842  3EB2: 8d46ae           lea ax, [bp - 0x52]
  03A845  3EB5: 16               push ss
  03A846  3EB6: 50               push ax
  03A847  3EB7: 9a82011f18       lcall 0x181f, 0x182
  03A84C  3EBC: 83c406           add sp, 6
  03A84F  3EBF: 8d46ae           lea ax, [bp - 0x52]
  03A852  3EC2: 50               push ax
  03A853  3EC3: 9a0a011f18       lcall 0x181f, 0x10a
  03A858  3EC8: 83c402           add sp, 2
  03A85B  3ECB: a03008           mov al, byte ptr [0x830]
  03A85E  3ECE: 2ae4             sub ah, ah
  03A860  3ED0: 50               push ax
  03A861  3ED1: ff769e           push word ptr [bp - 0x62]
  03A864  3ED4: ff768a           push word ptr [bp - 0x76]
  03A867  3ED7: 8d46ae           lea ax, [bp - 0x52]
  03A86A  3EDA: 16               push ss
  03A86B  3EDB: 50               push ax
  03A86C  3EDC: 9a3c011f18       lcall 0x181f, 0x13c
  03A871  3EE1: 83c40a           add sp, 0xa
  03A874  3EE4: 89468a           mov word ptr [bp - 0x76], ax
  03A877  3EE7: 83468a14         add word ptr [bp - 0x76], 0x14
  03A87B  3EEB: f606825302       test byte ptr [0x5382], 2
  03A880  3EF0: 7507             jne 0x3ef9
  03A882  3EF2: f606825308       test byte ptr [0x5382], 8
  03A887  3EF7: 740d             je 0x3f06
  03A889  3EF9: c41e9e08         les bx, ptr [0x89e]
  03A88D  3EFD: 268a07           mov al, byte ptr es:[bx]
  03A890  3F00: 2ae4             sub ah, ah
  03A892  3F02: 40               inc ax
  03A893  3F03: 01469e           add word ptr [bp - 0x62], ax
  03A896  3F06: 8b469c           mov ax, word ptr [bp - 0x64]
  03A899  3F09: 0346a8           add ax, word ptr [bp - 0x58]
  03A89C  3F0C: 034694           add ax, word ptr [bp - 0x6c]
  03A89F  3F0F: 0346a0           add ax, word ptr [bp - 0x60]
  03A8A2  3F12: 0346a6           add ax, word ptr [bp - 0x5a]
  03A8A5  3F15: 0346fe           add ax, word ptr [bp - 2]
  03A8A8  3F18: 034692           add ax, word ptr [bp - 0x6e]
  03A8AB  3F1B: 89468c           mov word ptr [bp - 0x74], ax
  03A8AE  3F1E: 837eac00         cmp word ptr [bp - 0x54], 0
  03A8B2  3F22: 742e             je 0x3f52
  03A8B4  3F24: b80800           mov ax, 8
  03A8B7  3F27: 8a4eaa           mov cl, byte ptr [bp - 0x56]
  03A8BA  3F2A: d3f8             sar ax, cl
  03A8BC  3F2C: 8946ac           mov word ptr [bp - 0x54], ax
  03A8BF  3F2F: 99               cdq 
  03A8C0  3F30: 050800           add ax, 8
  03A8C3  3F33: 83d200           adc dx, 0
  03A8C6  3F36: 52               push dx
  03A8C7  3F37: 50               push ax
  03A8C8  3F38: 8b468c           mov ax, word ptr [bp - 0x74]
  03A8CB  3F3B: 99               cdq 
  03A8CC  3F3C: 52               push dx
  03A8CD  3F3D: 50               push ax
  03A8CE  3F3E: 9a600f1d0d       lcall 0xd1d, 0xf60
  03A8D3  3F43: d1fa             sar dx, 1
  03A8D5  3F45: d1d8             rcr ax, 1
  03A8D7  3F47: d1fa             sar dx, 1
  03A8D9  3F49: d1d8             rcr ax, 1
  03A8DB  3F4B: d1fa             sar dx, 1
  03A8DD  3F4D: d1d8             rcr ax, 1
  03A8DF  3F4F: 89468c           mov word ptr [bp - 0x74], ax
  03A8E2  3F52: 8b46a4           mov ax, word ptr [bp - 0x5c]
  03A8E5  3F55: 89468a           mov word ptr [bp - 0x76], ax
  03A8E8  3F58: 837e0600         cmp word ptr [bp + 6], 0
  03A8EC  3F5C: 7503             jne 0x3f61
  03A8EE  3F5E: e9a700           jmp 0x4008
  03A8F1  3F61: c646ae00         mov byte ptr [bp - 0x52], 0
  03A8F5  3F65: ff36ac2e         push word ptr [0x2eac]
  03A8F9  3F69: 8d4eae           lea cx, [bp - 0x52]
  03A8FC  3F6C: 51               push cx
  03A8FD  3F6D: 9a6e011f18       lcall 0x181f, 0x16e
  03A902  3F72: 83c404           add sp, 4
  03A905  3F75: 8d46ae           lea ax, [bp - 0x52]
  03A908  3F78: 50               push ax
  03A909  3F79: 9abe011f18       lcall 0x181f, 0x1be
  03A90E  3F7E: 83c402           add sp, 2
  03A911  3F81: ff768c           push word ptr [bp - 0x74]
  03A914  3F84: 8d46ae           lea ax, [bp - 0x52]
  03A917  3F87: 16               push ss
  03A918  3F88: 50               push ax
  03A919  3F89: 9a82011f18       lcall 0x181f, 0x182
  03A91E  3F8E: 83c406           add sp, 6
  03A921  3F91: a03108           mov al, byte ptr [0x831]
  03A924  3F94: 2ae4             sub ah, ah
  03A926  3F96: 50               push ax
  03A927  3F97: ff769e           push word ptr [bp - 0x62]
  03A92A  3F9A: ff768a           push word ptr [bp - 0x76]
  03A92D  3F9D: 8d46ae           lea ax, [bp - 0x52]
  03A930  3FA0: 16               push ss
  03A931  3FA1: 50               push ax
  03A932  3FA2: 9a3c011f18       lcall 0x181f, 0x13c
  03A937  3FA7: 83c40a           add sp, 0xa
  03A93A  3FAA: 89468a           mov word ptr [bp - 0x76], ax
  03A93D  3FAD: ff36ae2d         push word ptr [0x2dae]
  03A941  3FB1: ff36ac2d         push word ptr [0x2dac]
  03A945  3FB5: ff36aa2d         push word ptr [0x2daa]
  03A949  3FB9: ff36a82d         push word ptr [0x2da8]
  03A94D  3FBD: 6a07             push 7
  03A94F  3FBF: a03508           mov al, byte ptr [0x835]
  03A952  3FC2: 50               push ax
  03A953  3FC3: b82300           mov ax, 0x23
  03A956  3FC6: baba00           mov dx, 0xba
  03A959  3FC9: bbfa00           mov bx, 0xfa
  03A95C  3FCC: 9aba001f18       lcall 0x181f, 0xba
  03A961  3FD1: ff36ae2d         push word ptr [0x2dae]
  03A965  3FD5: ff36ac2d         push word ptr [0x2dac]
  03A969  3FD9: ff36aa2d         push word ptr [0x2daa]
  03A96D  3FDD: ff36a82d         push word ptr [0x2da8]
  03A971  3FE1: 6a07             push 7
  03A973  3FE3: a03008           mov al, byte ptr [0x830]
  03A976  3FE6: 50               push ax
  03A977  3FE7: 68fa00           push 0xfa
  03A97A  3FEA: 6a00             push 0
  03A97C  3FEC: 8b468c           mov ax, word ptr [bp - 0x74]
  03A97F  3FEF: c1f802           sar ax, 2
  03A982  3FF2: 50               push ax
  03A983  3FF3: 9a5c031f18       lcall 0x181f, 0x35c
  03A988  3FF8: 83c406           add sp, 6
  03A98B  3FFB: 8bd8             mov bx, ax
  03A98D  3FFD: b82300           mov ax, 0x23
  03A990  4000: baba00           mov dx, 0xba
  03A993  4003: 9aba001f18       lcall 0x181f, 0xba
  03A998  4008: 837e0600         cmp word ptr [bp + 6], 0
  03A99C  400C: 741c             je 0x402a
  03A99E  400E: 6a00             push 0
  03A9A0  4010: 684001           push 0x140
  03A9A3  4013: 68c800           push 0xc8
  03A9A6  4016: 2bc0             sub ax, ax
  03A9A8  4018: 99               cdq 
  03A9A9  4019: 2bdb             sub bx, bx
  03A9AB  401B: 9ae2001f18       lcall 0x181f, 0xe2
  03A9B0  4020: 9aec001f18       lcall 0x181f, 0xec
  03A9B5  4025: 9ac0031f18       lcall 0x181f, 0x3c0
  03A9BA  402A: 8b468c           mov ax, word ptr [bp - 0x74]
  03A9BD  402D: c9               leave 
  03A9BE  402E: cb               retf 

; ---- func_03A9C0  size=2360  insns=748  prologue=ENTER 0x03C4,0  terminal=RETF ----
  03A9C0  4030: c8c40300         enter 0x3c4, 0
  03A9C4  4034: c78640ffffff     mov word ptr [bp - 0xc0], 0xffff
  03A9CA  403A: c746fe0000       mov word ptr [bp - 2], 0
  03A9CF  403F: 2bc0             sub ax, ax
  03A9D1  4041: 89864aff         mov word ptr [bp - 0xb6], ax
  03A9D5  4045: 898648ff         mov word ptr [bp - 0xb8], ax
  03A9D9  4049: 394608           cmp word ptr [bp + 8], ax
  03A9DC  404C: 7407             je 0x4055
  03A9DE  404E: 8b5e08           mov bx, word ptr [bp + 8]
  03A9E1  4051: c707ffff         mov word ptr [bx], 0xffff
  03A9E5  4055: a17203           mov ax, word ptr [0x372]
  03A9E8  4058: 898646ff         mov word ptr [bp - 0xba], ax
  03A9EC  405C: c70672030000     mov word ptr [0x372], 0
  03A9F2  4062: ff7606           push word ptr [bp + 6]
  03A9F5  4065: 0e               push cs
  03A9F6  4066: e87109           call 0x49da
  03A9F9  4069: 83c402           add sp, 2
  03A9FC  406C: 898642ff         mov word ptr [bp - 0xbe], ax
  03AA00  4070: 0bc0             or ax, ax
  03AA02  4072: 7f06             jg 0x407a
  03AA04  4074: 8b46fe           mov ax, word ptr [bp - 2]
  03AA07  4077: c9               leave 
  03AA08  4078: cb               retf 
  03AA09  4079: 90               nop 
  03AA0A  407A: a0a653           mov al, byte ptr [0x53a6]
  03AA0D  407D: 2ae4             sub ah, ah
  03AA0F  407F: 050400           add ax, 4
  03AA12  4082: 8946a0           mov word ptr [bp - 0x60], ax
  03AA15  4085: 803ea65303       cmp byte ptr [0x53a6], 3
  03AA1A  408A: 7204             jb 0x4090
  03AA1C  408C: 40               inc ax
  03AA1D  408D: 8946a0           mov word ptr [bp - 0x60], ax
  03AA20  4090: 803ea65304       cmp byte ptr [0x53a6], 4
  03AA25  4095: 7203             jb 0x409a
  03AA27  4097: ff46a0           inc word ptr [bp - 0x60]
  03AA2A  409A: 83be42ff00       cmp word ptr [bp - 0xbe], 0
  03AA2F  409F: 7439             je 0x40da
  03AA31  40A1: 8b46a0           mov ax, word ptr [bp - 0x60]
  03AA34  40A4: f7ae42ff         imul word ptr [bp - 0xbe]
  03AA38  40A8: b96400           mov cx, 0x64
  03AA3B  40AB: 99               cdq 
  03AA3C  40AC: f7f9             idiv cx
  03AA3E  40AE: 8946fe           mov word ptr [bp - 2], ax
  03AA41  40B1: c78644ff0100     mov word ptr [bp - 0xbc], 1
  03AA47  40B7: 8b8644ff         mov ax, word ptr [bp - 0xbc]
  03AA4B  40BB: 8bc8             mov cx, ax
  03AA4D  40BD: f7e9             imul cx
  03AA4F  40BF: bb0300           mov bx, 3
  03AA52  40C2: 99               cdq 
  03AA53  40C3: f7fb             idiv bx
  03AA55  40C5: 3b46fe           cmp ax, word ptr [bp - 2]
  03AA58  40C8: 7d05             jge 0x40cf
  03AA5A  40CA: 49               dec cx
  03AA5B  40CB: 898e40ff         mov word ptr [bp - 0xc0], cx
  03AA5F  40CF: ff8644ff         inc word ptr [bp - 0xbc]
  03AA63  40D3: 83be44ff18       cmp word ptr [bp - 0xbc], 0x18
  03AA68  40D8: 7edd             jle 0x40b7
  03AA6A  40DA: d17efe           sar word ptr [bp - 2], 1
  03AA6D  40DD: 8b8640ff         mov ax, word ptr [bp - 0xc0]
  03AA71  40E1: 3d1700           cmp ax, 0x17
  03AA74  40E4: 7e03             jle 0x40e9
  03AA76  40E6: b81700           mov ax, 0x17
  03AA79  40E9: 898640ff         mov word ptr [bp - 0xc0], ax
  03AA7D  40ED: 837e0800         cmp word ptr [bp + 8], 0
  03AA81  40F1: 7405             je 0x40f8
  03AA83  40F3: 8b5e08           mov bx, word ptr [bp + 8]
  03AA86  40F6: 8907             mov word ptr [bx], ax
  03AA88  40F8: 83be40ff00       cmp word ptr [bp - 0xc0], 0
  03AA8D  40FD: 7d03             jge 0x4102
  03AA8F  40FF: e972ff           jmp 0x4074
  03AA92  4102: 837e0600         cmp word ptr [bp + 6], 0
  03AA96  4106: 7503             jne 0x410b
  03AA98  4108: e969ff           jmp 0x4074
  03AA9B  410B: f606825310       test byte ptr [0x5382], 0x10
  03AAA0  4110: 7403             je 0x4115
  03AAA2  4112: e95fff           jmp 0x4074
  03AAA5  4115: 9ade0f1f19       lcall 0x191f, 0xfde
  03AAAA  411A: 68cf11           push 0x11cf
  03AAAD  411D: 8d46a2           lea ax, [bp - 0x5e]
  03AAB0  4120: 50               push ax
  03AAB1  4121: 9ae4071d0d       lcall 0xd1d, 0x7e4
  03AAB6  4126: 83c404           add sp, 4
  03AAB9  4129: 83be40ff09       cmp word ptr [bp - 0xc0], 9
  03AABE  412E: 7d0f             jge 0x413f
  03AAC0  4130: 68d511           push 0x11d5
  03AAC3  4133: 8d46a2           lea ax, [bp - 0x5e]
  03AAC6  4136: 50               push ax
  03AAC7  4137: 9aa4071d0d       lcall 0xd1d, 0x7a4
  03AACC  413C: 83c404           add sp, 4
  03AACF  413F: 8b8640ff         mov ax, word ptr [bp - 0xc0]
  03AAD3  4143: 40               inc ax
  03AAD4  4144: 50               push ax
  03AAD5  4145: 8d46a2           lea ax, [bp - 0x5e]
  03AAD8  4148: 16               push ss
  03AAD9  4149: 50               push ax
  03AADA  414A: 9a82011f18       lcall 0x181f, 0x182
  03AADF  414F: 83c406           add sp, 6
  03AAE2  4152: 9ab6031f18       lcall 0x181f, 0x3b6
  03AAE7  4157: 8d863efc         lea ax, [bp - 0x3c2]
  03AAEB  415B: 16               push ss
  03AAEC  415C: 50               push ax
  03AAED  415D: 6a00             push 0
  03AAEF  415F: ff36ae2d         push word ptr [0x2dae]
  03AAF3  4163: ff36ac2d         push word ptr [0x2dac]
  03AAF7  4167: ff36aa2d         push word ptr [0x2daa]
  03AAFB  416B: ff36a82d         push word ptr [0x2da8]
  03AAFF  416F: 68d711           push 0x11d7
  03AB02  4172: 9a4e041f18       lcall 0x181f, 0x44e
  03AB07  4177: 83c410           add sp, 0x10
  03AB0A  417A: 0bc0             or ax, ax
  03AB0C  417C: 741a             je 0x4198
  03AB0E  417E: ff36ae2d         push word ptr [0x2dae]
  03AB12  4182: ff36ac2d         push word ptr [0x2dac]
  03AB16  4186: ff36aa2d         push word ptr [0x2daa]
  03AB1A  418A: ff36a82d         push word ptr [0x2da8]
  03AB1E  418E: 2ac0             sub al, al
  03AB20  4190: 9a84041f18       lcall 0x181f, 0x484
  03AB25  4195: eb0c             jmp 0x41a3
  03AB27  4197: 90               nop 
  03AB28  4198: 8d863efc         lea ax, [bp - 0x3c2]
  03AB2C  419C: 16               push ss
  03AB2D  419D: 50               push ax
  03AB2E  419E: 9af4031f18       lcall 0x181f, 0x3f4
  03AB33  41A3: 6a0c             push 0xc
  03AB35  41A5: 8d8632ff         lea ax, [bp - 0xce]
  03AB39  41A9: 50               push ax
  03AB3A  41AA: 8d4ef2           lea cx, [bp - 0xe]
  03AB3D  41AD: 51               push cx
  03AB3E  41AE: 9a820d1d0d       lcall 0xd1d, 0xd82
  03AB43  41B3: 83c406           add sp, 6
  03AB46  41B6: 8d863efc         lea ax, [bp - 0x3c2]
  03AB4A  41BA: a3f223           mov word ptr [0x23f2], ax
  03AB4D  41BD: 8c16f423         mov word ptr [0x23f4], ss
  03AB51  41C1: 8d5ea2           lea bx, [bp - 0x5e]
  03AB54  41C4: 2bc0             sub ax, ax
  03AB56  41C6: 9ad00f1f19       lcall 0x191f, 0xfd0
  03AB5B  41CB: 898648ff         mov word ptr [bp - 0xb8], ax
  03AB5F  41CF: 89964aff         mov word ptr [bp - 0xb6], dx
  03AB63  41D3: 2bc0             sub ax, ax
  03AB65  41D5: a3f423           mov word ptr [0x23f4], ax
  03AB68  41D8: a3f223           mov word ptr [0x23f2], ax
  03AB6B  41DB: 6a0c             push 0xc
  03AB6D  41DD: 8d46f2           lea ax, [bp - 0xe]
  03AB70  41E0: 50               push ax
  03AB71  41E1: 8d8632ff         lea ax, [bp - 0xce]
  03AB75  41E5: 50               push ax
  03AB76  41E6: 9a820d1d0d       lcall 0xd1d, 0xd82
  03AB7B  41EB: 83c406           add sp, 6
  03AB7E  41EE: 8d863efc         lea ax, [bp - 0x3c2]
  03AB82  41F2: 16               push ss
  03AB83  41F3: 50               push ax
  03AB84  41F4: 9af4031f18       lcall 0x181f, 0x3f4
  03AB89  41F9: c7864cff0500     mov word ptr [bp - 0xb4], 5
  03AB8F  41FF: 68e011           push 0x11e0
  03AB92  4202: 687c08           push 0x87c
  03AB95  4205: 9a28091f19       lcall 0x191f, 0x928
  03AB9A  420A: 83c404           add sp, 4
  03AB9D  420D: 6b06985334       imul ax, word ptr [0x5398], 0x34
  03ABA2  4212: 052654           add ax, 0x5426
  03ABA5  4215: 1e               push ds
  03ABA6  4216: 50               push ax
  03ABA7  4217: 6a00             push 0
  03ABA9  4219: 9a16041f18       lcall 0x181f, 0x416
  03ABAE  421E: 83c406           add sp, 6
  03ABB1  4221: 8b46fe           mov ax, word ptr [bp - 2]
  03ABB4  4224: 99               cdq 
  03ABB5  4225: 52               push dx
  03ABB6  4226: 50               push ax
  03ABB7  4227: 6a00             push 0
  03ABB9  4229: 9aae091f18       lcall 0x181f, 0x9ae
  03ABBE  422E: 83c406           add sp, 6
  03ABC1  4231: c78644ff0000     mov word ptr [bp - 0xbc], 0
  03ABC7  4237: 9a1c091f19       lcall 0x191f, 0x91c
  03ABCC  423C: 8d46a2           lea ax, [bp - 0x5e]
  03ABCF  423F: 50               push ax
  03ABD0  4240: 683c83           push 0x833c
  03ABD3  4243: 9a10091f19       lcall 0x191f, 0x910
  03ABD8  4248: 83c404           add sp, 4
  03ABDB  424B: 68fc00           push 0xfc
  03ABDE  424E: ffb64cff         push word ptr [bp - 0xb4]
  03ABE2  4252: 684001           push 0x140
  03ABE5  4255: 6a00             push 0
  03ABE7  4257: 8d46a2           lea ax, [bp - 0x5e]
  03ABEA  425A: 16               push ss
  03ABEB  425B: 50               push ax
  03ABEC  425C: 9a00011f18       lcall 0x181f, 0x100
  03ABF1  4261: 83c40c           add sp, 0xc
  03ABF4  4264: c41e9e08         les bx, ptr [0x89e]
  03ABF8  4268: 268a07           mov al, byte ptr es:[bx]
  03ABFB  426B: 2ae4             sub ah, ah
  03ABFD  426D: 40               inc ax
  03ABFE  426E: 01864cff         add word ptr [bp - 0xb4], ax
  03AC02  4272: ff8644ff         inc word ptr [bp - 0xbc]
  03AC06  4276: 83be44ff03       cmp word ptr [bp - 0xbc], 3
  03AC0B  427B: 7cba             jl 0x4237
  03AC0D  427D: 68e911           push 0x11e9
  03AC10  4280: 6a00             push 0
  03AC12  4282: 9a28091f19       lcall 0x191f, 0x928
  03AC17  4287: 83c404           add sp, 4
  03AC1A  428A: c78644ff0000     mov word ptr [bp - 0xbc], 0
  03AC20  4290: eb7e             jmp 0x4310
  03AC22  4292: b8ffff           mov ax, 0xffff
  03AC25  4295: c41e9e08         les bx, ptr [0x89e]
  03AC29  4299: 268a0f           mov cl, byte ptr es:[bx]
  03AC2C  429C: 2aed             sub ch, ch
  03AC2E  429E: 2bc1             sub ax, cx
  03AC30  42A0: 8b8e44ff         mov cx, word ptr [bp - 0xbc]
  03AC34  42A4: 41               inc cx
  03AC35  42A5: f7e9             imul cx
  03AC37  42A7: 05c300           add ax, 0xc3
  03AC3A  42AA: 89864cff         mov word ptr [bp - 0xb4], ax
  03AC3E  42AE: c7863cfcfe00     mov word ptr [bp - 0x3c4], 0xfe
  03AC44  42B4: 8b8640ff         mov ax, word ptr [bp - 0xc0]
  03AC48  42B8: 398644ff         cmp word ptr [bp - 0xbc], ax
  03AC4C  42BC: 7506             jne 0x42c4
  03AC4E  42BE: c7863cfcfc00     mov word ptr [bp - 0x3c4], 0xfc
  03AC54  42C4: 9a1c091f19       lcall 0x191f, 0x91c
  03AC59  42C9: 9ac40f1f19       lcall 0x191f, 0xfc4
  03AC5E  42CE: 50               push ax
  03AC5F  42CF: 8d46a2           lea ax, [bp - 0x5e]
  03AC62  42D2: 50               push ax
  03AC63  42D3: 9ae4071d0d       lcall 0xd1d, 0x7e4
  03AC68  42D8: 83c404           add sp, 4
  03AC6B  42DB: 9ac40f1f19       lcall 0x191f, 0xfc4
  03AC70  42E0: 50               push ax
  03AC71  42E1: 8d8650ff         lea ax, [bp - 0xb0]
  03AC75  42E5: 50               push ax
  03AC76  42E6: 9ae4071d0d       lcall 0xd1d, 0x7e4
  03AC7B  42EB: 83c404           add sp, 4
  03AC7E  42EE: 8a863cfc         mov al, byte ptr [bp - 0x3c4]
  03AC82  42F2: 2ae4             sub ah, ah
  03AC84  42F4: 50               push ax
  03AC85  42F5: ffb64cff         push word ptr [bp - 0xb4]
  03AC89  42F9: 68a000           push 0xa0
  03AC8C  42FC: 68a000           push 0xa0
  03AC8F  42FF: 8d46a2           lea ax, [bp - 0x5e]
  03AC92  4302: 16               push ss
  03AC93  4303: 50               push ax
  03AC94  4304: 9a00011f18       lcall 0x181f, 0x100
  03AC99  4309: 83c40c           add sp, 0xc
  03AC9C  430C: ff8644ff         inc word ptr [bp - 0xbc]
  03ACA0  4310: 8b8640ff         mov ax, word ptr [bp - 0xc0]
  03ACA4  4314: 398644ff         cmp word ptr [bp - 0xbc], ax
  03ACA8  4318: 7f03             jg 0x431d
  03ACAA  431A: e975ff           jmp 0x4292
  03ACAD  431D: 9ab80f1f19       lcall 0x191f, 0xfb8
  03ACB2  4322: 6a20             push 0x20
  03ACB4  4324: 6b06985334       imul ax, word ptr [0x5398], 0x34
  03ACB9  4329: 050e54           add ax, 0x540e
  03ACBC  432C: 50               push ax
  03ACBD  432D: 9a1a0d1d0d       lcall 0xd1d, 0xd1a
  03ACC2  4332: 83c404           add sp, 4
  03ACC5  4335: 89863eff         mov word ptr [bp - 0xc2], ax
  03ACC9  4339: 0bc0             or ax, ax
  03ACCB  433B: 750c             jne 0x4349
  03ACCD  433D: 6b06985334       imul ax, word ptr [0x5398], 0x34
  03ACD2  4342: 050e54           add ax, 0x540e
  03ACD5  4345: 89863eff         mov word ptr [bp - 0xc2], ax
  03ACD9  4349: 1e               push ds
  03ACDA  434A: 50               push ax
  03ACDB  434B: 6a00             push 0
  03ACDD  434D: 9a16041f18       lcall 0x181f, 0x416
  03ACE2  4352: 83c406           add sp, 6
  03ACE5  4355: 8d46a2           lea ax, [bp - 0x5e]
  03ACE8  4358: 50               push ax
  03ACE9  4359: 8d8e50ff         lea cx, [bp - 0xb0]
  03ACED  435D: 51               push cx
  03ACEE  435E: 9a10091f19       lcall 0x191f, 0x910
  03ACF3  4363: 83c404           add sp, 4
  03ACF6  4366: 68fc00           push 0xfc
  03ACF9  4369: b88e00           mov ax, 0x8e
  03ACFC  436C: 89864cff         mov word ptr [bp - 0xb4], ax
  03AD00  4370: 50               push ax
  03AD01  4371: 688c00           push 0x8c
  03AD04  4374: 6a22             push 0x22
  03AD06  4376: 8d46a2           lea ax, [bp - 0x5e]
  03AD09  4379: 16               push ss
  03AD0A  437A: 50               push ax
  03AD0B  437B: 9a00011f18       lcall 0x181f, 0x100
  03AD10  4380: 83c40c           add sp, 0xc
  03AD13  4383: 6a00             push 0
  03AD15  4385: 684001           push 0x140
  03AD18  4388: 68c800           push 0xc8
  03AD1B  438B: 2bc0             sub ax, ax
  03AD1D  438D: 99               cdq 
  03AD1E  438E: 2bdb             sub bx, bx
  03AD20  4390: 9ae2001f18       lcall 0x181f, 0xe2
  03AD25  4395: 8b864aff         mov ax, word ptr [bp - 0xb6]
  03AD29  4399: 0b8648ff         or ax, word ptr [bp - 0xb8]
  03AD2D  439D: 7422             je 0x43c1
  03AD2F  439F: ffb64aff         push word ptr [bp - 0xb6]
  03AD33  43A3: ffb648ff         push word ptr [bp - 0xb8]
  03AD37  43A7: c49e48ff         les bx, ptr [bp - 0xb8]
  03AD3B  43AB: 26ff7748         push word ptr es:[bx + 0x48]
  03AD3F  43AF: 6a64             push 0x64
  03AD41  43B1: 268b5746         mov dx, word ptr es:[bx + 0x46]
  03AD45  43B5: b80100           mov ax, 1
  03AD48  43B8: 8d1ea82d         lea bx, [0x2da8]
  03AD4C  43BC: 9af8021f18       lcall 0x181f, 0x2f8
  03AD51  43C1: 83be40ff17       cmp word ptr [bp - 0xc0], 0x17
  03AD56  43C6: 7c06             jl 0x43ce
  03AD58  43C8: b82400           mov ax, 0x24
  03AD5B  43CB: eb10             jmp 0x43dd
  03AD5D  43CD: 90               nop 
  03AD5E  43CE: 83be40ff06       cmp word ptr [bp - 0xc0], 6
  03AD63  43D3: 7e05             jle 0x43da
  03AD65  43D5: b82500           mov ax, 0x25
  03AD68  43D8: eb03             jmp 0x43dd
  03AD6A  43DA: b82100           mov ax, 0x21
  03AD6D  43DD: 9ac0041f18       lcall 0x181f, 0x4c0
  03AD72  43E2: 6a08             push 8
  03AD74  43E4: 9aea031f18       lcall 0x181f, 0x3ea
  03AD79  43E9: 83c402           add sp, 2
  03AD7C  43EC: 9aac0a1f19       lcall 0x191f, 0xaac
  03AD81  43F1: 9aec001f18       lcall 0x181f, 0xec
  03AD86  43F6: 9ac0031f18       lcall 0x181f, 0x3c0
  03AD8B  43FB: 9ab6031f18       lcall 0x181f, 0x3b6
  03AD90  4400: 6800a0           push 0xa000
  03AD93  4403: 6800fc           push 0xfc00
  03AD96  4406: 9af4031f18       lcall 0x181f, 0x3f4
  03AD9B  440B: 8b8646ff         mov ax, word ptr [bp - 0xba]
  03AD9F  440F: a37203           mov word ptr [0x372], ax
  03ADA2  4412: e95ffc           jmp 0x4074
  03ADA5  4415: 90               nop 
  03ADA6  4416: c8600100         enter 0x160, 0
  03ADAA  441A: 57               push di
  03ADAB  441B: 56               push si
  03ADAC  441C: c746fe0000       mov word ptr [bp - 2], 0
  03ADB1  4421: 68ef11           push 0x11ef
  03ADB4  4424: 68f211           push 0x11f2
  03ADB7  4427: 9ada041d0d       lcall 0xd1d, 0x4da
  03ADBC  442C: 83c404           add sp, 4
  03ADBF  442F: 8986a4fe         mov word ptr [bp - 0x15c], ax
  03ADC3  4433: 0bc0             or ax, ax
  03ADC5  4435: 7431             je 0x4468
  03ADC7  4437: c746fe0100       mov word ptr [bp - 2], 1
  03ADCC  443C: 50               push ax
  03ADCD  443D: 6a01             push 1
  03ADCF  443F: 68d200           push 0xd2
  03ADD2  4442: 8d8600ff         lea ax, [bp - 0x100]
  03ADD6  4446: 50               push ax
  03ADD7  4447: 9a28051d0d       lcall 0xd1d, 0x528
  03ADDC  444C: 83c408           add sp, 8
  03ADDF  444F: 0bc0             or ax, ax
  03ADE1  4451: 7503             jne 0x4456
  03ADE3  4453: 8946fe           mov word ptr [bp - 2], ax
  03ADE6  4456: ffb6a4fe         push word ptr [bp - 0x15c]
  03ADEA  445A: 9af4031d0d       lcall 0xd1d, 0x3f4
  03ADEF  445F: 83c402           add sp, 2
  03ADF2  4462: c786a4fe0000     mov word ptr [bp - 0x15c], 0
  03ADF8  4468: c786a6fe0000     mov word ptr [bp - 0x15a], 0
  03ADFE  446E: 837efe00         cmp word ptr [bp - 2], 0
  03AE02  4472: 7407             je 0x447b
  03AE04  4474: 83bea6fe05       cmp word ptr [bp - 0x15a], 5
  03AE09  4479: 752f             jne 0x44aa
  03AE0B  447B: 6bb6a6fe2a       imul si, word ptr [bp - 0x15a], 0x2a
  03AE10  4480: c68200ff00       mov byte ptr [bp + si - 0x100], 0
  03AE15  4485: b8ffff           mov ax, 0xffff
  03AE18  4488: 898218ff         mov word ptr [bp + si - 0xe8], ax
  03AE1C  448C: 898224ff         mov word ptr [bp + si - 0xdc], ax
  03AE20  4490: 898226ff         mov word ptr [bp + si - 0xda], ax
  03AE24  4494: 2bc0             sub ax, ax
  03AE26  4496: 898222ff         mov word ptr [bp + si - 0xde], ax
  03AE2A  449A: 89821eff         mov word ptr [bp + si - 0xe2], ax
  03AE2E  449E: 898220ff         mov word ptr [bp + si - 0xe0], ax
  03AE32  44A2: 89821aff         mov word ptr [bp + si - 0xe6], ax
  03AE36  44A6: 89821cff         mov word ptr [bp + si - 0xe4], ax
  03AE3A  44AA: ff86a6fe         inc word ptr [bp - 0x15a]
  03AE3E  44AE: 83bea6fe06       cmp word ptr [bp - 0x15a], 6
  03AE43  44B3: 7cb9             jl 0x446e
  03AE45  44B5: c786acfeffff     mov word ptr [bp - 0x154], 0xffff
  03AE4B  44BB: 837e0600         cmp word ptr [bp + 6], 0
  03AE4F  44BF: 744d             je 0x450e
  03AE51  44C1: c786a6fe0000     mov word ptr [bp - 0x15a], 0
  03AE57  44C7: eb6d             jmp 0x4536
  03AE59  44C9: 90               nop 
  03AE5A  44CA: 6bb6aafe2a       imul si, word ptr [bp - 0x156], 0x2a
  03AE5F  44CF: 8dba00ff         lea di, [bp + si - 0x100]
  03AE63  44D3: 8db2d6fe         lea si, [bp + si - 0x12a]
  03AE67  44D7: 8cd0             mov ax, ss
  03AE69  44D9: 8ec0             mov es, ax
  03AE6B  44DB: b91500           mov cx, 0x15
  03AE6E  44DE: f3a5             rep movsw word ptr es:[di], word ptr [si]
  03AE70  44E0: ff8eaafe         dec word ptr [bp - 0x156]
  03AE74  44E4: 8b86a6fe         mov ax, word ptr [bp - 0x15a]
  03AE78  44E8: 3986aafe         cmp word ptr [bp - 0x156], ax
  03AE7C  44EC: 7fdc             jg 0x44ca
  03AE7E  44EE: 6bf02a           imul si, ax, 0x2a
  03AE81  44F1: 8b4606           mov ax, word ptr [bp + 6]
  03AE84  44F4: 8dba00ff         lea di, [bp + si - 0x100]
  03AE88  44F8: 8bf0             mov si, ax
  03AE8A  44FA: 16               push ss
  03AE8B  44FB: 07               pop es
  03AE8C  44FC: b91500           mov cx, 0x15
  03AE8F  44FF: f3a5             rep movsw word ptr es:[di], word ptr [si]
  03AE91  4501: 8b86a6fe         mov ax, word ptr [bp - 0x15a]
  03AE95  4505: 8986acfe         mov word ptr [bp - 0x154], ax
  03AE99  4509: c746060000       mov word ptr [bp + 6], 0
  03AE9E  450E: 6a00             push 0
  03AEA0  4510: ff36ae2d         push word ptr [0x2dae]
  03AEA4  4514: ff36ac2d         push word ptr [0x2dac]
  03AEA8  4518: ff36aa2d         push word ptr [0x2daa]
  03AEAC  451C: ff36a82d         push word ptr [0x2da8]
  03AEB0  4520: 68ff11           push 0x11ff
  03AEB3  4523: 9a7a081f19       lcall 0x191f, 0x87a
  03AEB8  4528: 83c40c           add sp, 0xc
  03AEBB  452B: 0bc0             or ax, ax
  03AEBD  452D: 742f             je 0x455e
  03AEBF  452F: e91f04           jmp 0x4951
  03AEC2  4532: ff86a6fe         inc word ptr [bp - 0x15a]
  03AEC6  4536: 83bea6fe06       cmp word ptr [bp - 0x15a], 6
  03AECB  453B: 7dd1             jge 0x450e
  03AECD  453D: 8b5e06           mov bx, word ptr [bp + 6]
  03AED0  4540: 8b4726           mov ax, word ptr [bx + 0x26]
  03AED3  4543: 6bb6a6fe2a       imul si, word ptr [bp - 0x15a], 0x2a
  03AED8  4548: 398226ff         cmp word ptr [bp + si - 0xda], ax
  03AEDC  454C: 7c07             jl 0x4555
  03AEDE  454E: 83bea6fe05       cmp word ptr [bp - 0x15a], 5
  03AEE3  4553: 75dd             jne 0x4532
  03AEE5  4555: c786aafe0500     mov word ptr [bp - 0x156], 5
  03AEEB  455B: eb87             jmp 0x44e4
  03AEED  455D: 90               nop 
  03AEEE  455E: a03308           mov al, byte ptr [0x833]
  03AEF1  4561: 2ae4             sub ah, ah
  03AEF3  4563: 50               push ax
  03AEF4  4564: a03008           mov al, byte ptr [0x830]
  03AEF7  4567: 50               push ax
  03AEF8  4568: 6a03             push 3
  03AEFA  456A: 684001           push 0x140
  03AEFD  456D: 6a00             push 0
  03AEFF  456F: ff363a2f         push word ptr [0x2f3a]
  03AF03  4573: 9a22001f18       lcall 0x181f, 0x22
  03AF08  4578: 83c402           add sp, 2
  03AF0B  457B: 52               push dx
  03AF0C  457C: 50               push ax
  03AF0D  457D: 9ac8011f18       lcall 0x181f, 0x1c8
  03AF12  4582: 83c40e           add sp, 0xe
  03AF15  4585: c786a8fe1000     mov word ptr [bp - 0x158], 0x10
  03AF1B  458B: c786aefe0a00     mov word ptr [bp - 0x152], 0xa
  03AF21  4591: c786a6fe0000     mov word ptr [bp - 0x15a], 0
  03AF27  4597: e9ce01           jmp 0x4768
  03AF2A  459A: 6bb6a6fe2a       imul si, word ptr [bp - 0x15a], 0x2a
  03AF2F  459F: 83ba1aff00       cmp word ptr [bp + si - 0xe6], 0
  03AF34  45A4: 7406             je 0x45ac
  03AF36  45A6: ff36422f         push word ptr [0x2f42]
  03AF3A  45AA: eb4e             jmp 0x45fa
  03AF3C  45AC: ff36442f         push word ptr [0x2f44]
  03AF40  45B0: 8d86b0fe         lea ax, [bp - 0x150]
  03AF44  45B4: 50               push ax
  03AF45  45B5: 9a6e011f18       lcall 0x181f, 0x16e
  03AF4A  45BA: 83c404           add sp, 4
  03AF4D  45BD: 8d86b0fe         lea ax, [bp - 0x150]
  03AF51  45C1: 50               push ax
  03AF52  45C2: 9ab4011f18       lcall 0x181f, 0x1b4
  03AF57  45C7: 83c402           add sp, 2
  03AF5A  45CA: 6bb6a6fe2a       imul si, word ptr [bp - 0x15a], 0x2a
  03AF5F  45CF: ffb218ff         push word ptr [bp + si - 0xe8]
  03AF63  45D3: 9a5e061f18       lcall 0x181f, 0x65e
  03AF68  45D8: 83c402           add sp, 2
  03AF6B  45DB: 50               push ax
  03AF6C  45DC: 8d86b0fe         lea ax, [bp - 0x150]
  03AF70  45E0: 50               push ax
  03AF71  45E1: 9a6e011f18       lcall 0x181f, 0x16e
  03AF76  45E6: 83c404           add sp, 4
  03AF79  45E9: 8d86b0fe         lea ax, [bp - 0x150]
  03AF7D  45ED: 50               push ax
  03AF7E  45EE: 9a78011f18       lcall 0x181f, 0x178
  03AF83  45F3: 83c402           add sp, 2
  03AF86  45F6: ff36782e         push word ptr [0x2e78]
  03AF8A  45FA: 8d86b0fe         lea ax, [bp - 0x150]
  03AF8E  45FE: 50               push ax
  03AF8F  45FF: 9a6e011f18       lcall 0x181f, 0x16e
  03AF94  4604: 83c404           add sp, 4
  03AF97  4607: 8d86b0fe         lea ax, [bp - 0x150]
  03AF9B  460B: 50               push ax
  03AF9C  460C: 9a78011f18       lcall 0x181f, 0x178
  03AFA1  4611: 83c402           add sp, 2
  03AFA4  4614: ff363c2f         push word ptr [0x2f3c]
  03AFA8  4618: 8d86b0fe         lea ax, [bp - 0x150]
  03AFAC  461C: 50               push ax
  03AFAD  461D: 9a6e011f18       lcall 0x181f, 0x16e
  03AFB2  4622: 83c404           add sp, 4
  03AFB5  4625: 8d86b0fe         lea ax, [bp - 0x150]
  03AFB9  4629: 50               push ax
  03AFBA  462A: 9a78011f18       lcall 0x181f, 0x178
  03AFBF  462F: 83c402           add sp, 2
  03AFC2  4632: ff363e2f         push word ptr [0x2f3e]
  03AFC6  4636: 8d86b0fe         lea ax, [bp - 0x150]
  03AFCA  463A: 50               push ax
  03AFCB  463B: 9a6e011f18       lcall 0x181f, 0x16e
  03AFD0  4640: 83c404           add sp, 4
  03AFD3  4643: 8d86b0fe         lea ax, [bp - 0x150]
  03AFD7  4647: 50               push ax
  03AFD8  4648: 9a78011f18       lcall 0x181f, 0x178
  03AFDD  464D: 83c402           add sp, 2
  03AFE0  4650: 6bb6a6fe2a       imul si, word ptr [bp - 0x15a], 0x2a
  03AFE5  4655: ffb21eff         push word ptr [bp + si - 0xe2]
  03AFE9  4659: 8d86b0fe         lea ax, [bp - 0x150]
  03AFED  465D: 16               push ss
  03AFEE  465E: 50               push ax
  03AFEF  465F: 9a82011f18       lcall 0x181f, 0x182
  03AFF4  4664: 83c406           add sp, 6
  03AFF7  4667: 8d86b0fe         lea ax, [bp - 0x150]
  03AFFB  466B: 50               push ax
  03AFFC  466C: 9adc011f18       lcall 0x181f, 0x1dc
  03B001  4671: 83c402           add sp, 2
  03B004  4674: ff36462f         push word ptr [0x2f46]
  03B008  4678: 8d86b0fe         lea ax, [bp - 0x150]
  03B00C  467C: 50               push ax
  03B00D  467D: 9a6e011f18       lcall 0x181f, 0x16e
  03B012  4682: 83c404           add sp, 4
  03B015  4685: 8d86b0fe         lea ax, [bp - 0x150]
  03B019  4689: 50               push ax
  03B01A  468A: 9abe011f18       lcall 0x181f, 0x1be
  03B01F  468F: 83c402           add sp, 2
  03B022  4692: ffb224ff         push word ptr [bp + si - 0xdc]
  03B026  4696: 8d86b0fe         lea ax, [bp - 0x150]
  03B02A  469A: 16               push ss
  03B02B  469B: 50               push ax
  03B02C  469C: 9a82011f18       lcall 0x181f, 0x182
  03B031  46A1: 83c406           add sp, 6
  03B034  46A4: a03308           mov al, byte ptr [0x833]
  03B037  46A7: 2ae4             sub ah, ah
  03B039  46A9: 50               push ax
  03B03A  46AA: ffb6a0fe         push word ptr [bp - 0x160]
  03B03E  46AE: ffb6a8fe         push word ptr [bp - 0x158]
  03B042  46B2: ffb6a2fe         push word ptr [bp - 0x15e]
  03B046  46B6: 8d86b0fe         lea ax, [bp - 0x150]
  03B04A  46BA: 16               push ss
  03B04B  46BB: 50               push ax
  03B04C  46BC: 9a8c011f18       lcall 0x181f, 0x18c
  03B051  46C1: 83c40c           add sp, 0xc
  03B054  46C4: c41e8a26         les bx, ptr [0x268a]
  03B058  46C8: 268a07           mov al, byte ptr es:[bx]
  03B05B  46CB: 2ae4             sub ah, ah
  03B05D  46CD: 40               inc ax
  03B05E  46CE: 40               inc ax
  03B05F  46CF: 0186a8fe         add word ptr [bp - 0x158], ax
  03B063  46D3: c686b0fe00       mov byte ptr [bp - 0x150], 0
  03B068  46D8: 681a12           push 0x121a
  03B06B  46DB: 8d86b0fe         lea ax, [bp - 0x150]
  03B06F  46DF: 50               push ax
  03B070  46E0: 9aa4071d0d       lcall 0xd1d, 0x7a4
  03B075  46E5: 83c404           add sp, 4
  03B078  46E8: ff36482f         push word ptr [0x2f48]
  03B07C  46EC: 8d86b0fe         lea ax, [bp - 0x150]
  03B080  46F0: 50               push ax
  03B081  46F1: 9a6e011f18       lcall 0x181f, 0x16e
  03B086  46F6: 83c404           add sp, 4
  03B089  46F9: 8d86b0fe         lea ax, [bp - 0x150]
  03B08D  46FD: 50               push ax
  03B08E  46FE: 9abe011f18       lcall 0x181f, 0x1be
  03B093  4703: 83c402           add sp, 2
  03B096  4706: ffb226ff         push word ptr [bp + si - 0xda]
  03B09A  470A: 8d86b0fe         lea ax, [bp - 0x150]
  03B09E  470E: 16               push ss
  03B09F  470F: 50               push ax
  03B0A0  4710: 9a82011f18       lcall 0x181f, 0x182
  03B0A5  4715: 83c406           add sp, 6
  03B0A8  4718: 8d86b0fe         lea ax, [bp - 0x150]
  03B0AC  471C: 50               push ax
  03B0AD  471D: 9a0a011f18       lcall 0x181f, 0x10a
  03B0B2  4722: 83c402           add sp, 2
  03B0B5  4725: 681f12           push 0x121f
  03B0B8  4728: 8d86b0fe         lea ax, [bp - 0x150]
  03B0BC  472C: 50               push ax
  03B0BD  472D: 9aa4071d0d       lcall 0xd1d, 0x7a4
  03B0C2  4732: 83c404           add sp, 4
  03B0C5  4735: a03308           mov al, byte ptr [0x833]
  03B0C8  4738: 2ae4             sub ah, ah
  03B0CA  473A: 50               push ax
  03B0CB  473B: ffb6a0fe         push word ptr [bp - 0x160]
  03B0CF  473F: ffb6a8fe         push word ptr [bp - 0x158]
  03B0D3  4743: 684001           push 0x140
  03B0D6  4746: 6a00             push 0
  03B0D8  4748: 8d86b0fe         lea ax, [bp - 0x150]
  03B0DC  474C: 16               push ss
  03B0DD  474D: 50               push ax
  03B0DE  474E: 9ac8011f18       lcall 0x181f, 0x1c8
  03B0E3  4753: 83c40e           add sp, 0xe
  03B0E6  4756: c41e8a26         les bx, ptr [0x268a]
  03B0EA  475A: 268a07           mov al, byte ptr es:[bx]
  03B0ED  475D: 2ae4             sub ah, ah
  03B0EF  475F: 40               inc ax
  03B0F0  4760: 0186a8fe         add word ptr [bp - 0x158], ax
  03B0F4  4764: ff86a6fe         inc word ptr [bp - 0x15a]
  03B0F8  4768: 83bea6fe05       cmp word ptr [bp - 0x15a], 5
  03B0FD  476D: 7c03             jl 0x4772
  03B0FF  476F: e99a01           jmp 0x490c
  03B102  4772: 8b86a6fe         mov ax, word ptr [bp - 0x15a]
  03B106  4776: 8946fc           mov word ptr [bp - 4], ax
  03B109  4779: 3d0400           cmp ax, 4
  03B10C  477C: 750c             jne 0x478a
  03B10E  477E: 83beacfe05       cmp word ptr [bp - 0x154], 5
  03B113  4783: 7505             jne 0x478a
  03B115  4785: c746fc0500       mov word ptr [bp - 4], 5
  03B11A  478A: 6bf02a           imul si, ax, 0x2a
  03B11D  478D: 83ba18ff00       cmp word ptr [bp + si - 0xe8], 0
  03B122  4792: 7cd0             jl 0x4764
  03B124  4794: a03008           mov al, byte ptr [0x830]
  03B127  4797: 2ae4             sub ah, ah
  03B129  4799: 8986a0fe         mov word ptr [bp - 0x160], ax
  03B12D  479D: 8b86acfe         mov ax, word ptr [bp - 0x154]
  03B131  47A1: 3946fc           cmp word ptr [bp - 4], ax
  03B134  47A4: 7509             jne 0x47af
  03B136  47A6: a03108           mov al, byte ptr [0x831]
  03B139  47A9: 2ae4             sub ah, ah
  03B13B  47AB: 8986a0fe         mov word ptr [bp - 0x160], ax
  03B13F  47AF: 8386a8fe04       add word ptr [bp - 0x158], 4
  03B144  47B4: c686b0fe00       mov byte ptr [bp - 0x150], 0
  03B149  47B9: 8b46fc           mov ax, word ptr [bp - 4]
  03B14C  47BC: 40               inc ax
  03B14D  47BD: 50               push ax
  03B14E  47BE: 8d86b0fe         lea ax, [bp - 0x150]
  03B152  47C2: 16               push ss
  03B153  47C3: 50               push ax
  03B154  47C4: 9a82011f18       lcall 0x181f, 0x182
  03B159  47C9: 83c406           add sp, 6
  03B15C  47CC: 8d86b0fe         lea ax, [bp - 0x150]
  03B160  47D0: 50               push ax
  03B161  47D1: 9adc011f18       lcall 0x181f, 0x1dc
  03B166  47D6: 83c402           add sp, 2
  03B169  47D9: 6bb6a6fe2a       imul si, word ptr [bp - 0x15a], 0x2a
  03B16E  47DE: 8b9a22ff         mov bx, word ptr [bp + si - 0xde]
  03B172  47E2: d1e3             shl bx, 1
  03B174  47E4: ffb79483         push word ptr [bx - 0x7c6c]
  03B178  47E8: 8d86b0fe         lea ax, [bp - 0x150]
  03B17C  47EC: 50               push ax
  03B17D  47ED: 9a6e011f18       lcall 0x181f, 0x16e
  03B182  47F2: 83c404           add sp, 4
  03B185  47F5: 8d86b0fe         lea ax, [bp - 0x150]
  03B189  47F9: 50               push ax
  03B18A  47FA: 9a78011f18       lcall 0x181f, 0x178
  03B18F  47FF: 83c402           add sp, 2
  03B192  4802: 8d8200ff         lea ax, [bp + si - 0x100]
  03B196  4806: 50               push ax
  03B197  4807: 8d86b0fe         lea ax, [bp - 0x150]
  03B19B  480B: 50               push ax
  03B19C  480C: 9aa4071d0d       lcall 0xd1d, 0x7a4
  03B1A1  4811: 83c404           add sp, 4
  03B1A4  4814: 8d86b0fe         lea ax, [bp - 0x150]
  03B1A8  4818: 50               push ax
  03B1A9  4819: 9a78011f18       lcall 0x181f, 0x178
  03B1AE  481E: 83c402           add sp, 2
  03B1B1  4821: ff36e02d         push word ptr [0x2de0]
  03B1B5  4825: 8d86b0fe         lea ax, [bp - 0x150]
  03B1B9  4829: 50               push ax
  03B1BA  482A: 9a6e011f18       lcall 0x181f, 0x16e
  03B1BF  482F: 83c404           add sp, 4
  03B1C2  4832: 8d86b0fe         lea ax, [bp - 0x150]
  03B1C6  4836: 50               push ax
  03B1C7  4837: 9a78011f18       lcall 0x181f, 0x178
  03B1CC  483C: 83c402           add sp, 2
  03B1CF  483F: 83ba1aff00       cmp word ptr [bp + si - 0xe6], 0
  03B1D4  4844: 741e             je 0x4864
  03B1D6  4846: ff36382f         push word ptr [0x2f38]
  03B1DA  484A: 8d86b0fe         lea ax, [bp - 0x150]
  03B1DE  484E: 50               push ax
  03B1DF  484F: 9a6e011f18       lcall 0x181f, 0x16e
  03B1E4  4854: 83c404           add sp, 4
  03B1E7  4857: 8d86b0fe         lea ax, [bp - 0x150]
  03B1EB  485B: 50               push ax
  03B1EC  485C: 9a78011f18       lcall 0x181f, 0x178
  03B1F1  4861: 83c402           add sp, 2
  03B1F4  4864: 6bb6a6fe2a       imul si, word ptr [bp - 0x15a], 0x2a
  03B1F9  4869: ffb218ff         push word ptr [bp + si - 0xe8]
  03B1FD  486D: 9a5e061f18       lcall 0x181f, 0x65e
  03B202  4872: 83c402           add sp, 2
  03B205  4875: 50               push ax
  03B206  4876: 8d86b0fe         lea ax, [bp - 0x150]
  03B20A  487A: 50               push ax
  03B20B  487B: 9a6e011f18       lcall 0x181f, 0x16e
  03B210  4880: 83c404           add sp, 4
  03B213  4883: a03308           mov al, byte ptr [0x833]
  03B216  4886: 2ae4             sub ah, ah
  03B218  4888: 50               push ax
  03B219  4889: ffb6a0fe         push word ptr [bp - 0x160]
  03B21D  488D: ffb6a8fe         push word ptr [bp - 0x158]
  03B221  4891: ffb6aefe         push word ptr [bp - 0x152]
  03B225  4895: 8d86b0fe         lea ax, [bp - 0x150]
  03B229  4899: 16               push ss
  03B22A  489A: 50               push ax
  03B22B  489B: 9a8c011f18       lcall 0x181f, 0x18c
  03B230  48A0: 83c40c           add sp, 0xc
  03B233  48A3: c41e8a26         les bx, ptr [0x268a]
  03B237  48A7: 268a07           mov al, byte ptr es:[bx]
  03B23A  48AA: 2ae4             sub ah, ah
  03B23C  48AC: 40               inc ax
  03B23D  48AD: 40               inc ax
  03B23E  48AE: 0186a8fe         add word ptr [bp - 0x158], ax
  03B242  48B2: 8b86aefe         mov ax, word ptr [bp - 0x152]
  03B246  48B6: 050f00           add ax, 0xf
  03B249  48B9: 8986a2fe         mov word ptr [bp - 0x15e], ax
  03B24D  48BD: c686b0fe00       mov byte ptr [bp - 0x150], 0
  03B252  48C2: 83ba1cff00       cmp word ptr [bp + si - 0xe4], 0
  03B257  48C7: 7503             jne 0x48cc
  03B259  48C9: e9cefc           jmp 0x459a
  03B25C  48CC: ff36402f         push word ptr [0x2f40]
  03B260  48D0: 8d86b0fe         lea ax, [bp - 0x150]
  03B264  48D4: 50               push ax
  03B265  48D5: 9a6e011f18       lcall 0x181f, 0x16e
  03B26A  48DA: 83c404           add sp, 4
  03B26D  48DD: 8d86b0fe         lea ax, [bp - 0x150]
  03B271  48E1: 50               push ax
  03B272  48E2: 9ab4011f18       lcall 0x181f, 0x1b4
  03B277  48E7: 83c402           add sp, 2
  03B27A  48EA: ffb218ff         push word ptr [bp + si - 0xe8]
  03B27E  48EE: 680812           push 0x1208
  03B281  48F1: 681412           push 0x1214
  03B284  48F4: 9a22041f18       lcall 0x181f, 0x422
  03B289  48F9: 83c406           add sp, 6
  03B28C  48FC: 683c83           push 0x833c
  03B28F  48FF: 8d86b0fe         lea ax, [bp - 0x150]
  03B293  4903: 50               push ax
  03B294  4904: 9aa4071d0d       lcall 0xd1d, 0x7a4
  03B299  4909: e9f8fc           jmp 0x4604
  03B29C  490C: 6a00             push 0
  03B29E  490E: 684001           push 0x140
  03B2A1  4911: 68c800           push 0xc8
  03B2A4  4914: 2bc0             sub ax, ax
  03B2A6  4916: 99               cdq 
  03B2A7  4917: 2bdb             sub bx, bx
  03B2A9  4919: 9ae2001f18       lcall 0x181f, 0xe2
  03B2AE  491E: 9aec001f18       lcall 0x181f, 0xec
  03B2B3  4923: 9ac0031f18       lcall 0x181f, 0x3c0
  03B2B8  4928: 682412           push 0x1224
  03B2BB  492B: 682712           push 0x1227
  03B2BE  492E: 9ada041d0d       lcall 0xd1d, 0x4da
  03B2C3  4933: 83c404           add sp, 4
  03B2C6  4936: 8986a4fe         mov word ptr [bp - 0x15c], ax
  03B2CA  493A: 0bc0             or ax, ax
  03B2CC  493C: 7413             je 0x4951
  03B2CE  493E: 50               push ax
  03B2CF  493F: 6a01             push 1
  03B2D1  4941: 68d200           push 0xd2
  03B2D4  4944: 8d8600ff         lea ax, [bp - 0x100]
  03B2D8  4948: 50               push ax
  03B2D9  4949: 9a0c061d0d       lcall 0xd1d, 0x60c
  03B2DE  494E: 83c408           add sp, 8
  03B2E1  4951: 83bea4fe00       cmp word ptr [bp - 0x15c], 0
  03B2E6  4956: 740c             je 0x4964
  03B2E8  4958: ffb6a4fe         push word ptr [bp - 0x15c]
  03B2EC  495C: 9af4031d0d       lcall 0xd1d, 0x3f4
  03B2F1  4961: 83c402           add sp, 2
  03B2F4  4964: 5e               pop si
  03B2F5  4965: 5f               pop di
  03B2F6  4966: c9               leave 
  03B2F7  4967: cb               retf 

; ---- func_03B2F8  size=134  insns=48  prologue=ENTER 0x002C,0  terminal=page-end ----
  03B2F8  4968: c82c0000         enter 0x2c, 0
  03B2FC  496C: 6b06985334       imul ax, word ptr [0x5398], 0x34
  03B301  4971: 050e54           add ax, 0x540e
  03B304  4974: 50               push ax
  03B305  4975: 8d46d6           lea ax, [bp - 0x2a]
  03B308  4978: 50               push ax
  03B309  4979: 9ae4071d0d       lcall 0xd1d, 0x7e4
  03B30E  497E: 83c404           add sp, 4
  03B311  4981: a19853           mov ax, word ptr [0x5398]
  03B314  4984: 8946ee           mov word ptr [bp - 0x12], ax
  03B317  4987: a08253           mov al, byte ptr [0x5382]
  03B31A  498A: 250100           and ax, 1
  03B31D  498D: 8946f0           mov word ptr [bp - 0x10], ax
  03B320  4990: a08253           mov al, byte ptr [0x5382]
  03B323  4993: 250800           and ax, 8
  03B326  4996: 8946f2           mov word ptr [bp - 0xe], ax
  03B329  4999: a18a53           mov ax, word ptr [0x538a]
  03B32C  499C: 8946f4           mov word ptr [bp - 0xc], ax
  03B32F  499F: a18c53           mov ax, word ptr [0x538c]
  03B332  49A2: 8946f6           mov word ptr [bp - 0xa], ax
  03B335  49A5: a0a653           mov al, byte ptr [0x53a6]
  03B338  49A8: 2ae4             sub ah, ah
  03B33A  49AA: 8946f8           mov word ptr [bp - 8], ax
  03B33D  49AD: 6a00             push 0
  03B33F  49AF: 0e               push cs
  03B340  49B0: e82700           call 0x49da
  03B343  49B3: 83c402           add sp, 2
  03B346  49B6: 8946fa           mov word ptr [bp - 6], ax
  03B349  49B9: 8d46d4           lea ax, [bp - 0x2c]
  03B34C  49BC: 50               push ax
  03B34D  49BD: 6a01             push 1
  03B34F  49BF: 0e               push cs
  03B350  49C0: e82100           call 0x49e4
  03B353  49C3: 83c404           add sp, 4
  03B356  49C6: 8946fc           mov word ptr [bp - 4], ax
  03B359  49C9: 8b46d4           mov ax, word ptr [bp - 0x2c]
  03B35C  49CC: 8946fe           mov word ptr [bp - 2], ax
  03B35F  49CF: 8d46d6           lea ax, [bp - 0x2a]
  03B362  49D2: 50               push ax
  03B363  49D3: 0e               push cs
  03B364  49D4: e80800           call 0x49df
  03B367  49D7: c9               leave 
  03B368  49D8: cb               retf 
  03B369  49D9: 90               nop 
  03B36A  49DA: eaaa031f19       ljmp 0x191f:0x3aa
  03B36F  49DF: ea8e0f1f19       ljmp 0x191f:0xf8e
  03B374  49E4: ea9c0f1f19       ljmp 0x191f:0xf9c
  03B379  49E9: eaaa0f1f19       ljmp 0x191f:0xfaa
