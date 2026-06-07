; ============================================================
; VICEROY.EXE overlay page 0x0C (record 11) -- RE-SEGMENTED
; file_offset (disk image) = 0x046600
; code_offset (first insn) = 0x046DE0
; code_end (next reloc hdr)= 0x04BA50  [resident size 1223 para -> nominal_end 0x04B270; on-disk code spills past it]
; reloc_count = 492  flags = 0x0000
; display IP base = page-image-relative (IP = file - 0x046600)
; functions in page = 19
; ============================================================

; ---- func_046DE0  size=56  insns=22  prologue=ENTER 0x0004,0  terminal=RETF ----
  046DE0  07E0: c8040000         enter 4, 0
  046DE4  07E4: 56               push si
  046DE5  07E5: 6b5e0612         imul bx, word ptr [bp + 6], 0x12
  046DE9  07E9: 8a87ee54         mov al, byte ptr [bx + 0x54ee]
  046DED  07ED: 2ae4             sub ah, ah
  046DEF  07EF: 2d0400           sub ax, 4
  046DF2  07F2: 6bf04e           imul si, ax, 0x4e
  046DF5  07F5: 8a84d85a         mov al, byte ptr [si + 0x5ad8]
  046DF9  07F9: 2ae4             sub ah, ah
  046DFB  07FB: 8bc8             mov cx, ax
  046DFD  07FD: d1e0             shl ax, 1
  046DFF  07FF: 050300           add ax, 3
  046E02  0802: 8946fe           mov word ptr [bp - 2], ax
  046E05  0805: f687ef5404       test byte ptr [bx + 0x54ef], 4
  046E0A  080A: 7406             je 0x812
  046E0C  080C: 03c8             add cx, ax
  046E0E  080E: 41               inc cx
  046E0F  080F: 894efe           mov word ptr [bp - 2], cx
  046E12  0812: 8b46fe           mov ax, word ptr [bp - 2]
  046E15  0815: 5e               pop si
  046E16  0816: c9               leave 
  046E17  0817: cb               retf 

; ---- func_046E18  size=167  insns=52  prologue=ENTER 0x0006,0  terminal=RETF ----
  046E18  0818: c8060000         enter 6, 0
  046E1C  081C: c746feffff       mov word ptr [bp - 2], 0xffff
  046E21  0821: 833e9a5354       cmp word ptr [0x539a], 0x54
  046E26  0826: 7c03             jl 0x82b
  046E28  0828: e98f00           jmp 0x8ba
  046E2B  082B: a19a53           mov ax, word ptr [0x539a]
  046E2E  082E: ff069a53         inc word ptr [0x539a]
  046E32  0832: 8946fe           mov word ptr [bp - 2], ax
  046E35  0835: 50               push ax
  046E36  0836: 9a4c0a1f18       lcall 0x181f, 0xa4c
  046E3B  083B: 83c402           add sp, 2
  046E3E  083E: 8b4606           mov ax, word ptr [bp + 6]
  046E41  0841: 2d0400           sub ax, 4
  046E44  0844: 50               push ax
  046E45  0845: 9a420a1f18       lcall 0x181f, 0xa42
  046E4A  084A: 83c402           add sp, 2
  046E4D  084D: 8a4606           mov al, byte ptr [bp + 6]
  046E50  0850: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  046E54  0854: 884702           mov byte ptr [bx + 2], al
  046E57  0857: 8a4608           mov al, byte ptr [bp + 8]
  046E5A  085A: 8807             mov byte ptr [bx], al
  046E5C  085C: 8a460a           mov al, byte ptr [bp + 0xa]
  046E5F  085F: 884701           mov byte ptr [bx + 1], al
  046E62  0862: ff76fe           push word ptr [bp - 2]
  046E65  0865: 0e               push cs
  046E66  0866: e8cb4b           call 0x5434
  046E69  0869: 83c402           add sp, 2
  046E6C  086C: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  046E70  0870: 884704           mov byte ptr [bx + 4], al
  046E73  0873: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  046E77  0877: c64705ff         mov byte ptr [bx + 5], 0xff
  046E7B  087B: c6470600         mov byte ptr [bx + 6], 0
  046E7F  087F: ff760a           push word ptr [bp + 0xa]
  046E82  0882: ff7608           push word ptr [bp + 8]
  046E85  0885: 9a40071f18       lcall 0x181f, 0x740
  046E8A  088A: 83c404           add sp, 4
  046E8D  088D: 8ec2             mov es, dx
  046E8F  088F: 8bd8             mov bx, ax
  046E91  0891: 26800f02         or byte ptr es:[bx], 2
  046E95  0895: ff7606           push word ptr [bp + 6]
  046E98  0898: ff760a           push word ptr [bp + 0xa]
  046E9B  089B: ff7608           push word ptr [bp + 8]
  046E9E  089E: 9a04071f18       lcall 0x181f, 0x704
  046EA3  08A3: 6b5efe12         imul bx, word ptr [bp - 2], 0x12
  046EA7  08A7: c687ef5400       mov byte ptr [bx + 0x54ef], 0
  046EAC  08AC: b0ff             mov al, 0xff
  046EAE  08AE: 8887f354         mov byte ptr [bx + 0x54f3], al
  046EB2  08B2: 8887f454         mov byte ptr [bx + 0x54f4], al
  046EB6  08B6: 8887f554         mov byte ptr [bx + 0x54f5], al
  046EBA  08BA: 8b46fe           mov ax, word ptr [bp - 2]
  046EBD  08BD: c9               leave 
  046EBE  08BE: cb               retf 

; ---- func_046EC0  size=258  insns=95  prologue=ENTER 0x0002,0  terminal=RETF ----
  046EC0  08C0: c8020000         enter 2, 0
  046EC4  08C4: 57               push di
  046EC5  08C5: 56               push si
  046EC6  08C6: ff7606           push word ptr [bp + 6]
  046EC9  08C9: 9a4c0a1f18       lcall 0x181f, 0xa4c
  046ECE  08CE: 83c402           add sp, 2
  046ED1  08D1: 6a00             push 0
  046ED3  08D3: 6a02             push 2
  046ED5  08D5: 6b5e0612         imul bx, word ptr [bp + 6], 0x12
  046ED9  08D9: 8a87ed54         mov al, byte ptr [bx + 0x54ed]
  046EDD  08DD: 2ae4             sub ah, ah
  046EDF  08DF: 50               push ax
  046EE0  08E0: 8a87ec54         mov al, byte ptr [bx + 0x54ec]
  046EE4  08E4: 50               push ax
  046EE5  08E5: 9a8c061f18       lcall 0x181f, 0x68c
  046EEA  08EA: 83c408           add sp, 8
  046EED  08ED: a19c53           mov ax, word ptr [0x539c]
  046EF0  08F0: 48               dec ax
  046EF1  08F1: 8946fe           mov word ptr [bp - 2], ax
  046EF4  08F4: eb14             jmp 0x90a
  046EF6  08F6: 8a4606           mov al, byte ptr [bp + 6]
  046EF9  08F9: 6b5efe1c         imul bx, word ptr [bp - 2], 0x1c
  046EFD  08FD: 38874a31         cmp byte ptr [bx + 0x314a], al
  046F01  0901: 7e04             jle 0x907
  046F03  0903: fe8f4a31         dec byte ptr [bx + 0x314a]
  046F07  0907: ff4efe           dec word ptr [bp - 2]
  046F0A  090A: 837efe00         cmp word ptr [bp - 2], 0
  046F0E  090E: 7c24             jl 0x934
  046F10  0910: 6b5efe1c         imul bx, word ptr [bp - 2], 0x1c
  046F14  0914: 8a874731         mov al, byte ptr [bx + 0x3147]
  046F18  0918: 240f             and al, 0xf
  046F1A  091A: 3c04             cmp al, 4
  046F1C  091C: 72e9             jb 0x907
  046F1E  091E: 8a4606           mov al, byte ptr [bp + 6]
  046F21  0921: 38874a31         cmp byte ptr [bx + 0x314a], al
  046F25  0925: 75cf             jne 0x8f6
  046F27  0927: ff76fe           push word ptr [bp - 2]
  046F2A  092A: 9a08081f18       lcall 0x181f, 0x808
  046F2F  092F: 83c402           add sp, 2
  046F32  0932: ebd3             jmp 0x907
  046F34  0934: 8b4606           mov ax, word ptr [bp + 6]
  046F37  0937: 8946fe           mov word ptr [bp - 2], ax
  046F3A  093A: eb18             jmp 0x954
  046F3C  093C: 6b5efe12         imul bx, word ptr [bp - 2], 0x12
  046F40  0940: 8dbfec54         lea di, [bx + 0x54ec]
  046F44  0944: 8db7fe54         lea si, [bx + 0x54fe]
  046F48  0948: 8cd8             mov ax, ds
  046F4A  094A: 8ec0             mov es, ax
  046F4C  094C: b90900           mov cx, 9
  046F4F  094F: f3a5             rep movsw word ptr es:[di], word ptr [si]
  046F51  0951: ff46fe           inc word ptr [bp - 2]
  046F54  0954: a19a53           mov ax, word ptr [0x539a]
  046F57  0957: 48               dec ax
  046F58  0958: 3b46fe           cmp ax, word ptr [bp - 2]
  046F5B  095B: 7fdf             jg 0x93c
  046F5D  095D: ff0e9a53         dec word ptr [0x539a]
  046F61  0961: 8b1e528d         mov bx, word ptr [0x8d52]
  046F65  0965: fe8f2a96         dec byte ptr [bx - 0x69d6]
  046F69  0969: 7427             je 0x992
  046F6B  096B: 8b364e8d         mov si, word ptr [0x8d4e]
  046F6F  096F: 8a4408           mov al, byte ptr [si + 8]
  046F72  0972: 98               cwde 
  046F73  0973: b9ffff           mov cx, 0xffff
  046F76  0976: 8a972a96         mov dl, byte ptr [bx - 0x69d6]
  046F7A  097A: 2af6             sub dh, dh
  046F7C  097C: 2bca             sub cx, dx
  046F7E  097E: 99               cdq 
  046F7F  097F: f7f9             idiv cx
  046F81  0981: 004408           add byte ptr [si + 8], al
  046F84  0984: 8b440a           mov ax, word ptr [si + 0xa]
  046F87  0987: 99               cdq 
  046F88  0988: f7f9             idiv cx
  046F8A  098A: 01440a           add word ptr [si + 0xa], ax
  046F8D  098D: 5e               pop si
  046F8E  098E: 5f               pop di
  046F8F  098F: c9               leave 
  046F90  0990: cb               retf 
  046F91  0991: 90               nop 
  046F92  0992: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  046F96  0996: 804f0380         or byte ptr [bx + 3], 0x80
  046F9A  099A: ff36508d         push word ptr [0x8d50]
  046F9E  099E: 9aa4091f18       lcall 0x181f, 0x9a4
  046FA3  09A3: 83c402           add sp, 2
  046FA6  09A6: 50               push ax
  046FA7  09A7: 6a00             push 0
  046FA9  09A9: 9a38041f18       lcall 0x181f, 0x438
  046FAE  09AE: 83c404           add sp, 4
  046FB1  09B1: 6a03             push 3
  046FB3  09B3: 68d414           push 0x14d4
  046FB6  09B6: 9a52061f18       lcall 0x181f, 0x652
  046FBB  09BB: 83c404           add sp, 4
  046FBE  09BE: 5e               pop si
  046FBF  09BF: 5f               pop di
  046FC0  09C0: c9               leave 
  046FC1  09C1: cb               retf 

; ---- func_046FC2  size=56  insns=21  prologue=ENTER 0x0004,0  terminal=RETF ----
  046FC2  09C2: c8040000         enter 4, 0
  046FC6  09C6: 8b4606           mov ax, word ptr [bp + 6]
  046FC9  09C9: 050400           add ax, 4
  046FCC  09CC: 8946fc           mov word ptr [bp - 4], ax
  046FCF  09CF: a19a53           mov ax, word ptr [0x539a]
  046FD2  09D2: 48               dec ax
  046FD3  09D3: 8946fe           mov word ptr [bp - 2], ax
  046FD6  09D6: eb1a             jmp 0x9f2
  046FD8  09D8: 8a46fc           mov al, byte ptr [bp - 4]
  046FDB  09DB: 6b5efe12         imul bx, word ptr [bp - 2], 0x12
  046FDF  09DF: 3887ee54         cmp byte ptr [bx + 0x54ee], al
  046FE3  09E3: 750a             jne 0x9ef
  046FE5  09E5: ff76fe           push word ptr [bp - 2]
  046FE8  09E8: 0e               push cs
  046FE9  09E9: e8164a           call 0x5402
  046FEC  09EC: 83c402           add sp, 2
  046FEF  09EF: ff4efe           dec word ptr [bp - 2]
  046FF2  09F2: 837efe00         cmp word ptr [bp - 2], 0
  046FF6  09F6: 7de0             jge 0x9d8
  046FF8  09F8: c9               leave 
  046FF9  09F9: cb               retf 

; ---- func_046FFA  size=4835  insns=1599  prologue=ENTER 0x00A2,0  terminal=RETF ----
  046FFA  09FA: c8a20000         enter 0xa2, 0
  046FFE  09FE: 56               push si
  046FFF  09FF: 2bc0             sub ax, ax
  047001  0A01: 89867eff         mov word ptr [bp - 0x82], ax
  047005  0A05: 894696           mov word ptr [bp - 0x6a], ax
  047008  0A08: 894686           mov word ptr [bp - 0x7a], ax
  04700B  0A0B: a18e53           mov ax, word ptr [0x538e]
  04700E  0A0E: b9e7ff           mov cx, 0xffe7
  047011  0A11: 99               cdq 
  047012  0A12: f7f9             idiv cx
  047014  0A14: 03068e53         add ax, word ptr [0x538e]
  047018  0A18: 894684           mov word ptr [bp - 0x7c], ax
  04701B  0A1B: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04701F  0A1F: 8a874431         mov al, byte ptr [bx + 0x3144]
  047023  0A23: 2ae4             sub ah, ah
  047025  0A25: 8946aa           mov word ptr [bp - 0x56], ax
  047028  0A28: 8a874531         mov al, byte ptr [bx + 0x3145]
  04702C  0A2C: 89469c           mov word ptr [bp - 0x64], ax
  04702F  0A2F: 8a874731         mov al, byte ptr [bx + 0x3147]
  047033  0A33: 250f00           and ax, 0xf
  047036  0A36: 89866cff         mov word ptr [bp - 0x94], ax
  04703A  0A3A: 2d0400           sub ax, 4
  04703D  0A3D: 8946be           mov word ptr [bp - 0x42], ax
  047040  0A40: 50               push ax
  047041  0A41: 9a420a1f18       lcall 0x181f, 0xa42
  047046  0A46: 83c402           add sp, 2
  047049  0A49: ff769c           push word ptr [bp - 0x64]
  04704C  0A4C: ff76aa           push word ptr [bp - 0x56]
  04704F  0A4F: 9a54071f18       lcall 0x181f, 0x754
  047054  0A54: 83c404           add sp, 4
  047057  0A57: 250a00           and ax, 0xa
  04705A  0A5A: 8946d6           mov word ptr [bp - 0x2a], ax
  04705D  0A5D: ff769c           push word ptr [bp - 0x64]
  047060  0A60: ff76aa           push word ptr [bp - 0x56]
  047063  0A63: 9a2c071f18       lcall 0x181f, 0x72c
  047068  0A68: 83c404           add sp, 4
  04706B  0A6B: 254000           and ax, 0x40
  04706E  0A6E: 8946c2           mov word ptr [bp - 0x3e], ax
  047071  0A71: ffb66cff         push word ptr [bp - 0x94]
  047075  0A75: ff769c           push word ptr [bp - 0x64]
  047078  0A78: ff76aa           push word ptr [bp - 0x56]
  04707B  0A7B: 9a52091f18       lcall 0x181f, 0x952
  047080  0A80: 83c406           add sp, 6
  047083  0A83: 8946e4           mov word ptr [bp - 0x1c], ax
  047086  0A86: a1fa8c           mov ax, word ptr [0x8cfa]
  047089  0A89: 898660ff         mov word ptr [bp - 0xa0], ax
  04708D  0A8D: c746b80800       mov word ptr [bp - 0x48], 8
  047092  0A92: ff769c           push word ptr [bp - 0x64]
  047095  0A95: ff76aa           push word ptr [bp - 0x56]
  047098  0A98: 9ab4061f18       lcall 0x181f, 0x6b4
  04709D  0A9D: 83c404           add sp, 4
  0470A0  0AA0: 8846da           mov byte ptr [bp - 0x26], al
  0470A3  0AA3: f606940802       test byte ptr [0x894], 2
  0470A8  0AA8: 743f             je 0xae9
  0470AA  0AAA: 833ea25300       cmp word ptr [0x53a2], 0
  0470AF  0AAF: 7524             jne 0xad5
  0470B1  0AB1: 833e985304       cmp word ptr [0x5398], 4
  0470B6  0AB6: 7d1d             jge 0xad5
  0470B8  0AB8: ff769c           push word ptr [bp - 0x64]
  0470BB  0ABB: ff76aa           push word ptr [bp - 0x56]
  0470BE  0ABE: 9a4a071f18       lcall 0x181f, 0x74a
  0470C3  0AC3: 83c404           add sp, 4
  0470C6  0AC6: 2ae4             sub ah, ah
  0470C8  0AC8: 8a0e9853         mov cl, byte ptr [0x5398]
  0470CC  0ACC: ba1000           mov dx, 0x10
  0470CF  0ACF: d3e2             shl dx, cl
  0470D1  0AD1: 85c2             test dx, ax
  0470D3  0AD3: 7414             je 0xae9
  0470D5  0AD5: ff369853         push word ptr [0x5398]
  0470D9  0AD9: ff7606           push word ptr [bp + 6]
  0470DC  0ADC: 9a3e091f18       lcall 0x181f, 0x93e
  0470E1  0AE1: 83c404           add sp, 4
  0470E4  0AE4: c746860100       mov word ptr [bp - 0x7a], 1
  0470E9  0AE9: 837e8600         cmp word ptr [bp - 0x7a], 0
  0470ED  0AED: 740e             je 0xafd
  0470EF  0AEF: ff769c           push word ptr [bp - 0x64]
  0470F2  0AF2: ff76aa           push word ptr [bp - 0x56]
  0470F5  0AF5: 9a9a0d1f18       lcall 0x181f, 0xd9a
  0470FA  0AFA: 83c404           add sp, 4
  0470FD  0AFD: 8a46da           mov al, byte ptr [bp - 0x26]
  047100  0B00: 2ae4             sub ah, ah
  047102  0B02: 50               push ax
  047103  0B03: 6aff             push -1
  047105  0B05: ff769c           push word ptr [bp - 0x64]
  047108  0B08: ff76aa           push word ptr [bp - 0x56]
  04710B  0B0B: 9a14061f18       lcall 0x181f, 0x614
  047110  0B10: 83c408           add sp, 8
  047113  0B13: 89866eff         mov word ptr [bp - 0x92], ax
  047117  0B17: a1b88d           mov ax, word ptr [0x8db8]
  04711A  0B1A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04711E  0B1E: 8a874a31         mov al, byte ptr [bx + 0x314a]
  047122  0B22: 98               cwde 
  047123  0B23: 894688           mov word ptr [bp - 0x78], ax
  047126  0B26: 0bc0             or ax, ax
  047128  0B28: 7c06             jl 0xb30
  04712A  0B2A: 3b069a53         cmp ax, word ptr [0x539a]
  04712E  0B2E: 7c16             jl 0xb46
  047130  0B30: ff7606           push word ptr [bp + 6]
  047133  0B33: 9a08081f18       lcall 0x181f, 0x808
  047138  0B38: 83c402           add sp, 2
  04713B  0B3B: c746b8ffff       mov word ptr [bp - 0x48], 0xffff
  047140  0B40: 8b46b8           mov ax, word ptr [bp - 0x48]
  047143  0B43: 5e               pop si
  047144  0B44: c9               leave 
  047145  0B45: cb               retf 
  047146  0B46: 50               push ax
  047147  0B47: 9a4c0a1f18       lcall 0x181f, 0xa4c
  04714C  0B4C: 83c402           add sp, 2
  04714F  0B4F: 6b5e8812         imul bx, word ptr [bp - 0x78], 0x12
  047153  0B53: 8a87ed54         mov al, byte ptr [bx + 0x54ed]
  047157  0B57: 2ae4             sub ah, ah
  047159  0B59: 2b469c           sub ax, word ptr [bp - 0x64]
  04715C  0B5C: f7d8             neg ax
  04715E  0B5E: 50               push ax
  04715F  0B5F: 8a87ec54         mov al, byte ptr [bx + 0x54ec]
  047163  0B63: 2ae4             sub ah, ah
  047165  0B65: 2b46aa           sub ax, word ptr [bp - 0x56]
  047168  0B68: f7d8             neg ax
  04716A  0B6A: 50               push ax
  04716B  0B6B: 8bf3             mov si, bx
  04716D  0B6D: 9a70031f18       lcall 0x181f, 0x370
  047172  0B72: 83c404           add sp, 4
  047175  0B75: 898670ff         mov word ptr [bp - 0x90], ax
  047179  0B79: 837e8800         cmp word ptr [bp - 0x78], 0
  04717D  0B7D: 7c1e             jl 0xb9d
  04717F  0B7F: 8a84ed54         mov al, byte ptr [si + 0x54ed]
  047183  0B83: 2ae4             sub ah, ah
  047185  0B85: 50               push ax
  047186  0B86: 8a84ec54         mov al, byte ptr [si + 0x54ec]
  04718A  0B8A: 50               push ax
  04718B  0B8B: 9ab4061f18       lcall 0x181f, 0x6b4
  047190  0B90: 83c404           add sp, 4
  047193  0B93: 3a46da           cmp al, byte ptr [bp - 0x26]
  047196  0B96: 7405             je 0xb9d
  047198  0B98: c74688ffff       mov word ptr [bp - 0x78], 0xffff
  04719D  0B9D: c746baffff       mov word ptr [bp - 0x46], 0xffff
  0471A2  0BA2: 83be6eff00       cmp word ptr [bp - 0x92], 0
  0471A7  0BA7: 7c41             jl 0xbea
  0471A9  0BA9: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  0471AD  0BAD: 8a4701           mov al, byte ptr [bx + 1]
  0471B0  0BB0: 2ae4             sub ah, ah
  0471B2  0BB2: 50               push ax
  0471B3  0BB3: 8a07             mov al, byte ptr [bx]
  0471B5  0BB5: 50               push ax
  0471B6  0BB6: 699e6effca00     imul bx, word ptr [bp - 0x92], 0xca
  0471BC  0BBC: 8a87475d         mov al, byte ptr [bx + 0x5d47]
  0471C0  0BC0: 50               push ax
  0471C1  0BC1: 8a87465d         mov al, byte ptr [bx + 0x5d46]
  0471C5  0BC5: 50               push ax
  0471C6  0BC6: 8bf3             mov si, bx
  0471C8  0BC8: 9a7a031f18       lcall 0x181f, 0x37a
  0471CD  0BCD: 83c408           add sp, 8
  0471D0  0BD0: 8946ba           mov word ptr [bp - 0x46], ax
  0471D3  0BD3: 8a84655d         mov al, byte ptr [si + 0x5d65]
  0471D7  0BD7: d0f8             sar al, 1
  0471D9  0BD9: 3c02             cmp al, 2
  0471DB  0BDB: 7d02             jge 0xbdf
  0471DD  0BDD: b002             mov al, 2
  0471DF  0BDF: 98               cwde 
  0471E0  0BE0: 3b46ba           cmp ax, word ptr [bp - 0x46]
  0471E3  0BE3: 7d05             jge 0xbea
  0471E5  0BE5: c746baffff       mov word ptr [bp - 0x46], 0xffff
  0471EA  0BEA: 8b4606           mov ax, word ptr [bp + 6]
  0471ED  0BED: 89468e           mov word ptr [bp - 0x72], ax
  0471F0  0BF0: c746b4ffff       mov word ptr [bp - 0x4c], 0xffff
  0471F5  0BF5: 2bc0             sub ax, ax
  0471F7  0BF7: 894690           mov word ptr [bp - 0x70], ax
  0471FA  0BFA: 8946cc           mov word ptr [bp - 0x34], ax
  0471FD  0BFD: eb16             jmp 0xc15
  0471FF  0BFF: 90               nop 
  047200  0C00: ff76e8           push word ptr [bp - 0x18]
  047203  0C03: ff76f6           push word ptr [bp - 0xa]
  047206  0C06: 9a68071f18       lcall 0x181f, 0x768
  04720B  0C0B: 83c404           add sp, 4
  04720E  0C0E: 0bc0             or ax, ax
  047210  0C10: 7448             je 0xc5a
  047212  0C12: ff46cc           inc word ptr [bp - 0x34]
  047215  0C15: 837ecc08         cmp word ptr [bp - 0x34], 8
  047219  0C19: 7c03             jl 0xc1e
  04721B  0C1B: e9da00           jmp 0xcf8
  04721E  0C1E: 8b5ecc           mov bx, word ptr [bp - 0x34]
  047221  0C21: 8a87be00         mov al, byte ptr [bx + 0xbe]
  047225  0C25: 98               cwde 
  047226  0C26: 8b364a8d         mov si, word ptr [0x8d4a]
  04722A  0C2A: 8a4c01           mov cl, byte ptr [si + 1]
  04722D  0C2D: 2aed             sub ch, ch
  04722F  0C2F: 03c1             add ax, cx
  047231  0C31: 8946e8           mov word ptr [bp - 0x18], ax
  047234  0C34: 50               push ax
  047235  0C35: 8a87b400         mov al, byte ptr [bx + 0xb4]
  047239  0C39: 98               cwde 
  04723A  0C3A: 8a0c             mov cl, byte ptr [si]
  04723C  0C3C: 03c1             add ax, cx
  04723E  0C3E: 8946f6           mov word ptr [bp - 0xa], ax
  047241  0C41: 50               push ax
  047242  0C42: 9adc061f18       lcall 0x181f, 0x6dc
  047247  0C47: 83c404           add sp, 4
  04724A  0C4A: 98               cwde 
  04724B  0C4B: 8946fa           mov word ptr [bp - 6], ax
  04724E  0C4E: 0bc0             or ax, ax
  047250  0C50: 7cc0             jl 0xc12
  047252  0C52: 3d0400           cmp ax, 4
  047255  0C55: 7ca9             jl 0xc00
  047257  0C57: ebb9             jmp 0xc12
  047259  0C59: 90               nop 
  04725A  0C5A: 8b46f6           mov ax, word ptr [bp - 0xa]
  04725D  0C5D: 8b56e8           mov dx, word ptr [bp - 0x18]
  047260  0C60: 9ae0071f18       lcall 0x181f, 0x7e0
  047265  0C65: 894606           mov word ptr [bp + 6], ax
  047268  0C68: 0bc0             or ax, ax
  04726A  0C6A: 7ca6             jl 0xc12
  04726C  0C6C: c746d00000       mov word ptr [bp - 0x30], 0
  047271  0C71: eb3e             jmp 0xcb1
  047273  0C73: 90               nop 
  047274  0C74: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  047278  0C78: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04727D  0C7D: 7207             jb 0xc86
  04727F  0C7F: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  047284  0C84: 7620             jbe 0xca6
  047286  0C86: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04728A  0C8A: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04728E  0C8E: 2aff             sub bh, bh
  047290  0C90: 8bc3             mov ax, bx
  047292  0C92: d1e3             shl bx, 1
  047294  0C94: 03d8             add bx, ax
  047296  0C96: d1e3             shl bx, 1
  047298  0C98: 03d8             add bx, ax
  04729A  0C9A: d1e3             shl bx, 1
  04729C  0C9C: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  0472A1  0CA1: 7603             jbe 0xca6
  0472A3  0CA3: ff46d0           inc word ptr [bp - 0x30]
  0472A6  0CA6: 8b4606           mov ax, word ptr [bp + 6]
  0472A9  0CA9: 9ae4021f18       lcall 0x181f, 0x2e4
  0472AE  0CAE: 894606           mov word ptr [bp + 6], ax
  0472B1  0CB1: 0bc0             or ax, ax
  0472B3  0CB3: 7dbf             jge 0xc74
  0472B5  0CB5: 837ed000         cmp word ptr [bp - 0x30], 0
  0472B9  0CB9: 7e24             jle 0xcdf
  0472BB  0CBB: ff76e8           push word ptr [bp - 0x18]
  0472BE  0CBE: ff76f6           push word ptr [bp - 0xa]
  0472C1  0CC1: 9abe071f18       lcall 0x181f, 0x7be
  0472C6  0CC6: 83c404           add sp, 4
  0472C9  0CC9: 8946c8           mov word ptr [bp - 0x38], ax
  0472CC  0CCC: 0bc0             or ax, ax
  0472CE  0CCE: 7c0f             jl 0xcdf
  0472D0  0CD0: 69d8ca00         imul bx, ax, 0xca
  0472D4  0CD4: 8a87655d         mov al, byte ptr [bx + 0x5d65]
  0472D8  0CD8: c0f802           sar al, 2
  0472DB  0CDB: 98               cwde 
  0472DC  0CDC: 2946d0           sub word ptr [bp - 0x30], ax
  0472DF  0CDF: 837ed000         cmp word ptr [bp - 0x30], 0
  0472E3  0CE3: 7f03             jg 0xce8
  0472E5  0CE5: e92aff           jmp 0xc12
  0472E8  0CE8: 8b46d0           mov ax, word ptr [bp - 0x30]
  0472EB  0CEB: 014690           add word ptr [bp - 0x70], ax
  0472EE  0CEE: 8b46fa           mov ax, word ptr [bp - 6]
  0472F1  0CF1: 8946b4           mov word ptr [bp - 0x4c], ax
  0472F4  0CF4: e91bff           jmp 0xc12
  0472F7  0CF7: 90               nop 
  0472F8  0CF8: 8b468e           mov ax, word ptr [bp - 0x72]
  0472FB  0CFB: 894606           mov word ptr [bp + 6], ax
  0472FE  0CFE: 837e9002         cmp word ptr [bp - 0x70], 2
  047302  0D02: 7d0a             jge 0xd0e
  047304  0D04: c746900000       mov word ptr [bp - 0x70], 0
  047309  0D09: c746b4ffff       mov word ptr [bp - 0x4c], 0xffff
  04730E  0D0E: 2bc0             sub ax, ax
  047310  0D10: 89867aff         mov word ptr [bp - 0x86], ax
  047314  0D14: 8946a0           mov word ptr [bp - 0x60], ax
  047317  0D17: eb4c             jmp 0xd65
  047319  0D19: 90               nop 
  04731A  0D1A: ff76a0           push word ptr [bp - 0x60]
  04731D  0D1D: ff76be           push word ptr [bp - 0x42]
  047320  0D20: 9a0c031f18       lcall 0x181f, 0x30c
  047325  0D25: 83c404           add sp, 4
  047328  0D28: 3d4b00           cmp ax, 0x4b
  04732B  0D2B: 7c0c             jl 0xd39
  04732D  0D2D: ff867aff         inc word ptr [bp - 0x86]
  047331  0D31: 8a4ea0           mov cl, byte ptr [bp - 0x60]
  047334  0D34: b80100           mov ax, 1
  047337  0D37: d3e0             shl ax, cl
  047339  0D39: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04733D  0D3D: 8a874a31         mov al, byte ptr [bx + 0x314a]
  047341  0D41: 98               cwde 
  047342  0D42: 8bd8             mov bx, ax
  047344  0D44: c1e303           shl bx, 3
  047347  0D47: 03d8             add bx, ax
  047349  0D49: 035ea0           add bx, word ptr [bp - 0x60]
  04734C  0D4C: d1e3             shl bx, 1
  04734E  0D4E: 81bff6548000     cmp word ptr [bx + 0x54f6], 0x80
  047354  0D54: 7c0c             jl 0xd62
  047356  0D56: ff867aff         inc word ptr [bp - 0x86]
  04735A  0D5A: 8a4ea0           mov cl, byte ptr [bp - 0x60]
  04735D  0D5D: b80100           mov ax, 1
  047360  0D60: d3e0             shl ax, cl
  047362  0D62: ff46a0           inc word ptr [bp - 0x60]
  047365  0D65: 837ea004         cmp word ptr [bp - 0x60], 4
  047369  0D69: 7caf             jl 0xd1a
  04736B  0D6B: c78672ffffff     mov word ptr [bp - 0x8e], 0xffff
  047371  0D71: c746cc0000       mov word ptr [bp - 0x34], 0
  047376  0D76: eb15             jmp 0xd8d
  047378  0D78: ff76e8           push word ptr [bp - 0x18]
  04737B  0D7B: ff76f6           push word ptr [bp - 0xa]
  04737E  0D7E: 9a5e071f18       lcall 0x181f, 0x75e
  047383  0D83: 83c404           add sp, 4
  047386  0D86: 0bc0             or ax, ax
  047388  0D88: 7448             je 0xdd2
  04738A  0D8A: ff46cc           inc word ptr [bp - 0x34]
  04738D  0D8D: 837ecc09         cmp word ptr [bp - 0x34], 9
  047391  0D91: 7c03             jl 0xd96
  047393  0D93: e9f80b           jmp 0x198e
  047396  0D96: 8b5ecc           mov bx, word ptr [bp - 0x34]
  047399  0D99: 8a87be00         mov al, byte ptr [bx + 0xbe]
  04739D  0D9D: 98               cwde 
  04739E  0D9E: 03469c           add ax, word ptr [bp - 0x64]
  0473A1  0DA1: 8946e8           mov word ptr [bp - 0x18], ax
  0473A4  0DA4: c746dcc800       mov word ptr [bp - 0x24], 0xc8
  0473A9  0DA9: c746ce0000       mov word ptr [bp - 0x32], 0
  0473AE  0DAE: 50               push ax
  0473AF  0DAF: 8a87b400         mov al, byte ptr [bx + 0xb4]
  0473B3  0DB3: 98               cwde 
  0473B4  0DB4: 0346aa           add ax, word ptr [bp - 0x56]
  0473B7  0DB7: 8946f6           mov word ptr [bp - 0xa], ax
  0473BA  0DBA: 50               push ax
  0473BB  0DBB: 9a8c071f18       lcall 0x181f, 0x78c
  0473C0  0DC0: 83c404           add sp, 4
  0473C3  0DC3: 89468a           mov word ptr [bp - 0x76], ax
  0473C6  0DC6: 3d1900           cmp ax, 0x19
  0473C9  0DC9: 74bf             je 0xd8a
  0473CB  0DCB: 3d1a00           cmp ax, 0x1a
  0473CE  0DCE: 75a8             jne 0xd78
  0473D0  0DD0: ebb8             jmp 0xd8a
  0473D2  0DD2: 837e8a18         cmp word ptr [bp - 0x76], 0x18
  0473D6  0DD6: 74b2             je 0xd8a
  0473D8  0DD8: ff76e8           push word ptr [bp - 0x18]
  0473DB  0DDB: ff76f6           push word ptr [bp - 0xa]
  0473DE  0DDE: 9adc061f18       lcall 0x181f, 0x6dc
  0473E3  0DE3: 83c404           add sp, 4
  0473E6  0DE6: 98               cwde 
  0473E7  0DE7: 8946fa           mov word ptr [bp - 6], ax
  0473EA  0DEA: ff76e8           push word ptr [bp - 0x18]
  0473ED  0DED: ff76f6           push word ptr [bp - 0xa]
  0473F0  0DF0: 9a82061f18       lcall 0x181f, 0x682
  0473F5  0DF5: 83c404           add sp, 4
  0473F8  0DF8: 8946a2           mov word ptr [bp - 0x5e], ax
  0473FB  0DFB: ff76e8           push word ptr [bp - 0x18]
  0473FE  0DFE: ff76f6           push word ptr [bp - 0xa]
  047401  0E01: 9abe061f18       lcall 0x181f, 0x6be
  047406  0E06: 83c404           add sp, 4
  047409  0E09: 8946a4           mov word ptr [bp - 0x5c], ax
  04740C  0E0C: ff76e8           push word ptr [bp - 0x18]
  04740F  0E0F: ff76f6           push word ptr [bp - 0xa]
  047412  0E12: 9a54071f18       lcall 0x181f, 0x754
  047417  0E17: 83c404           add sp, 4
  04741A  0E1A: 250a00           and ax, 0xa
  04741D  0E1D: 8946c0           mov word ptr [bp - 0x40], ax
  047420  0E20: ff76e8           push word ptr [bp - 0x18]
  047423  0E23: ff76f6           push word ptr [bp - 0xa]
  047426  0E26: 9a2c071f18       lcall 0x181f, 0x72c
  04742B  0E2B: 83c404           add sp, 4
  04742E  0E2E: 254000           and ax, 0x40
  047431  0E31: 8946ac           mov word ptr [bp - 0x54], ax
  047434  0E34: ff76e8           push word ptr [bp - 0x18]
  047437  0E37: ff76f6           push word ptr [bp - 0xa]
  04743A  0E3A: 9a18071f18       lcall 0x181f, 0x718
  04743F  0E3F: 83c404           add sp, 4
  047442  0E42: 40               inc ax
  047443  0E43: 7405             je 0xe4a
  047445  0E45: b80100           mov ax, 1
  047448  0E48: eb02             jmp 0xe4c
  04744A  0E4A: 2bc0             sub ax, ax
  04744C  0E4C: 8946ae           mov word ptr [bp - 0x52], ax
  04744F  0E4F: 837efa00         cmp word ptr [bp - 6], 0
  047453  0E53: 7c09             jl 0xe5e
  047455  0E55: 8b866cff         mov ax, word ptr [bp - 0x94]
  047459  0E59: 3946fa           cmp word ptr [bp - 6], ax
  04745C  0E5C: 7510             jne 0xe6e
  04745E  0E5E: 2bc0             sub ax, ax
  047460  0E60: 894692           mov word ptr [bp - 0x6e], ax
  047463  0E63: 8946ec           mov word ptr [bp - 0x14], ax
  047466  0E66: 898678ff         mov word ptr [bp - 0x88], ax
  04746A  0E6A: e98600           jmp 0xef3
  04746D  0E6D: 90               nop 
  04746E  0E6E: 804ece01         or byte ptr [bp - 0x32], 1
  047472  0E72: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  047476  0E76: 8a874a31         mov al, byte ptr [bx + 0x314a]
  04747A  0E7A: 98               cwde 
  04747B  0E7B: 8bd8             mov bx, ax
  04747D  0E7D: c1e303           shl bx, 3
  047480  0E80: 03d8             add bx, ax
  047482  0E82: 035efa           add bx, word ptr [bp - 6]
  047485  0E85: d1e3             shl bx, 1
  047487  0E87: 8b87f654         mov ax, word ptr [bx + 0x54f6]
  04748B  0E8B: 898678ff         mov word ptr [bp - 0x88], ax
  04748F  0E8F: 837efa04         cmp word ptr [bp - 6], 4
  047493  0E93: 7c07             jl 0xe9c
  047495  0E95: c746920000       mov word ptr [bp - 0x6e], 0
  04749A  0E9A: eb43             jmp 0xedf
  04749C  0E9C: 3d8000           cmp ax, 0x80
  04749F  0E9F: 7c05             jl 0xea6
  0474A1  0EA1: b80100           mov ax, 1
  0474A4  0EA4: eb02             jmp 0xea8
  0474A6  0EA6: 2bc0             sub ax, ax
  0474A8  0EA8: 8946ec           mov word ptr [bp - 0x14], ax
  0474AB  0EAB: ff76fa           push word ptr [bp - 6]
  0474AE  0EAE: ff36528d         push word ptr [0x8d52]
  0474B2  0EB2: 9a0c031f18       lcall 0x181f, 0x30c
  0474B7  0EB7: 83c404           add sp, 4
  0474BA  0EBA: 3d4b00           cmp ax, 0x4b
  0474BD  0EBD: 7c05             jl 0xec4
  0474BF  0EBF: b80100           mov ax, 1
  0474C2  0EC2: eb02             jmp 0xec6
  0474C4  0EC4: 2bc0             sub ax, ax
  0474C6  0EC6: 894692           mov word ptr [bp - 0x6e], ax
  0474C9  0EC9: 0bc0             or ax, ax
  0474CB  0ECB: 7405             je 0xed2
  0474CD  0ECD: c746ec0100       mov word ptr [bp - 0x14], 1
  0474D2  0ED2: 8b46b4           mov ax, word ptr [bp - 0x4c]
  0474D5  0ED5: 3946fa           cmp word ptr [bp - 6], ax
  0474D8  0ED8: 7505             jne 0xedf
  0474DA  0EDA: c746ec0100       mov word ptr [bp - 0x14], 1
  0474DF  0EDF: 837e9200         cmp word ptr [bp - 0x6e], 0
  0474E3  0EE3: 7404             je 0xee9
  0474E5  0EE5: 804ece04         or byte ptr [bp - 0x32], 4
  0474E9  0EE9: 837eec00         cmp word ptr [bp - 0x14], 0
  0474ED  0EED: 7404             je 0xef3
  0474EF  0EEF: 804ece40         or byte ptr [bp - 0x32], 0x40
  0474F3  0EF3: c746b00000       mov word ptr [bp - 0x50], 0
  0474F8  0EF8: 837ea200         cmp word ptr [bp - 0x5e], 0
  0474FC  0EFC: 7c06             jl 0xf04
  0474FE  0EFE: 8b46a2           mov ax, word ptr [bp - 0x5e]
  047501  0F01: eb04             jmp 0xf07
  047503  0F03: 90               nop 
  047504  0F04: 8b46a4           mov ax, word ptr [bp - 0x5c]
  047507  0F07: 89468c           mov word ptr [bp - 0x74], ax
  04750A  0F0A: 3b866cff         cmp ax, word ptr [bp - 0x94]
  04750E  0F0E: 7505             jne 0xf15
  047510  0F10: c7468cffff       mov word ptr [bp - 0x74], 0xffff
  047515  0F15: 837e8c00         cmp word ptr [bp - 0x74], 0
  047519  0F19: 7c09             jl 0xf24
  04751B  0F1B: 804ece02         or byte ptr [bp - 0x32], 2
  04751F  0F1F: c746b00100       mov word ptr [bp - 0x50], 1
  047524  0F24: b8ffff           mov ax, 0xffff
  047527  0F27: 894698           mov word ptr [bp - 0x68], ax
  04752A  0F2A: 898668ff         mov word ptr [bp - 0x98], ax
  04752E  0F2E: 837eb000         cmp word ptr [bp - 0x50], 0
  047532  0F32: 7403             je 0xf37
  047534  0F34: e9df00           jmp 0x1016
  047537  0F37: 8b4606           mov ax, word ptr [bp + 6]
  04753A  0F3A: 8946c8           mov word ptr [bp - 0x38], ax
  04753D  0F3D: c746b60000       mov word ptr [bp - 0x4a], 0
  047542  0F42: eb2d             jmp 0xf71
  047544  0F44: ff76f2           push word ptr [bp - 0xe]
  047547  0F47: ff36528d         push word ptr [0x8d52]
  04754B  0F4B: 9a0c031f18       lcall 0x181f, 0x30c
  047550  0F50: 83c404           add sp, 4
  047553  0F53: d1f8             sar ax, 1
  047555  0F55: 0146d8           add word ptr [bp - 0x28], ax
  047558  0F58: 8b8668ff         mov ax, word ptr [bp - 0x98]
  04755C  0F5C: 3946d8           cmp word ptr [bp - 0x28], ax
  04755F  0F5F: 7c0d             jl 0xf6e
  047561  0F61: 8b46d8           mov ax, word ptr [bp - 0x28]
  047564  0F64: 898668ff         mov word ptr [bp - 0x98], ax
  047568  0F68: 8b46f2           mov ax, word ptr [bp - 0xe]
  04756B  0F6B: 894698           mov word ptr [bp - 0x68], ax
  04756E  0F6E: ff46b6           inc word ptr [bp - 0x4a]
  047571  0F71: 837eb608         cmp word ptr [bp - 0x4a], 8
  047575  0F75: 7c03             jl 0xf7a
  047577  0F77: e99600           jmp 0x1010
  04757A  0F7A: 8b5eb6           mov bx, word ptr [bp - 0x4a]
  04757D  0F7D: 8a87be00         mov al, byte ptr [bx + 0xbe]
  047581  0F81: 98               cwde 
  047582  0F82: 0346e8           add ax, word ptr [bp - 0x18]
  047585  0F85: 89469a           mov word ptr [bp - 0x66], ax
  047588  0F88: 8a87b400         mov al, byte ptr [bx + 0xb4]
  04758C  0F8C: 98               cwde 
  04758D  0F8D: 0346f6           add ax, word ptr [bp - 0xa]
  047590  0F90: 8946a8           mov word ptr [bp - 0x58], ax
  047593  0F93: 3b46aa           cmp ax, word ptr [bp - 0x56]
  047596  0F96: 7508             jne 0xfa0
  047598  0F98: 8b469c           mov ax, word ptr [bp - 0x64]
  04759B  0F9B: 39469a           cmp word ptr [bp - 0x66], ax
  04759E  0F9E: 74ce             je 0xf6e
  0475A0  0FA0: c746d86400       mov word ptr [bp - 0x28], 0x64
  0475A5  0FA5: ff769a           push word ptr [bp - 0x66]
  0475A8  0FA8: ff76a8           push word ptr [bp - 0x58]
  0475AB  0FAB: 9abe061f18       lcall 0x181f, 0x6be
  0475B0  0FB0: 83c404           add sp, 4
  0475B3  0FB3: 894680           mov word ptr [bp - 0x80], ax
  0475B6  0FB6: 8946f2           mov word ptr [bp - 0xe], ax
  0475B9  0FB9: 0bc0             or ax, ax
  0475BB  0FBB: 7d3d             jge 0xffa
  0475BD  0FBD: 8b46a8           mov ax, word ptr [bp - 0x58]
  0475C0  0FC0: 8b569a           mov dx, word ptr [bp - 0x66]
  0475C3  0FC3: 9ae0071f18       lcall 0x181f, 0x7e0
  0475C8  0FC8: 894606           mov word ptr [bp + 6], ax
  0475CB  0FCB: 0bc0             or ax, ax
  0475CD  0FCD: 7c9f             jl 0xf6e
  0475CF  0FCF: 6bd81c           imul bx, ax, 0x1c
  0475D2  0FD2: 8a874731         mov al, byte ptr [bx + 0x3147]
  0475D6  0FD6: 240f             and al, 0xf
  0475D8  0FD8: 3a866cff         cmp al, byte ptr [bp - 0x94]
  0475DC  0FDC: 7490             je 0xf6e
  0475DE  0FDE: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0475E2  0FE2: 80bf46310c       cmp byte ptr [bx + 0x3146], 0xc
  0475E7  0FE7: 7585             jne 0xf6e
  0475E9  0FE9: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0475ED  0FED: 8a874731         mov al, byte ptr [bx + 0x3147]
  0475F1  0FF1: 250f00           and ax, 0xf
  0475F4  0FF4: 8946f2           mov word ptr [bp - 0xe], ax
  0475F7  0FF7: d17ed8           sar word ptr [bp - 0x28], 1
  0475FA  0FFA: 837ef200         cmp word ptr [bp - 0xe], 0
  0475FE  0FFE: 7d03             jge 0x1003
  047600  1000: e96bff           jmp 0xf6e
  047603  1003: 837ef204         cmp word ptr [bp - 0xe], 4
  047607  1007: 7d03             jge 0x100c
  047609  1009: e938ff           jmp 0xf44
  04760C  100C: e95fff           jmp 0xf6e
  04760F  100F: 90               nop 
  047610  1010: 8b46c8           mov ax, word ptr [bp - 0x38]
  047613  1013: 894606           mov word ptr [bp + 6], ax
  047616  1016: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04761A  101A: 8a4701           mov al, byte ptr [bx + 1]
  04761D  101D: 2ae4             sub ah, ah
  04761F  101F: 50               push ax
  047620  1020: 8a07             mov al, byte ptr [bx]
  047622  1022: 50               push ax
  047623  1023: ff76e8           push word ptr [bp - 0x18]
  047626  1026: ff76f6           push word ptr [bp - 0xa]
  047629  1029: 9a7a031f18       lcall 0x181f, 0x37a
  04762E  102E: 83c408           add sp, 8
  047631  1031: 8946ca           mov word ptr [bp - 0x36], ax
  047634  1034: 837e9800         cmp word ptr [bp - 0x68], 0
  047638  1038: 7d03             jge 0x103d
  04763A  103A: e99400           jmp 0x10d1
  04763D  103D: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  047641  1041: 8a874a31         mov al, byte ptr [bx + 0x314a]
  047645  1045: 98               cwde 
  047646  1046: 8bf0             mov si, ax
  047648  1048: c1e603           shl si, 3
  04764B  104B: 03f0             add si, ax
  04764D  104D: 037698           add si, word ptr [bp - 0x68]
  047650  1050: d1e6             shl si, 1
  047652  1052: 8b84f654         mov ax, word ptr [si + 0x54f6]
  047656  1056: 898678ff         mov word ptr [bp - 0x88], ax
  04765A  105A: 899e5eff         mov word ptr [bp - 0xa2], bx
  04765E  105E: 3d8000           cmp ax, 0x80
  047661  1061: 7c05             jl 0x1068
  047663  1063: b80100           mov ax, 1
  047666  1066: eb02             jmp 0x106a
  047668  1068: 2bc0             sub ax, ax
  04766A  106A: 8946ec           mov word ptr [bp - 0x14], ax
  04766D  106D: ff7698           push word ptr [bp - 0x68]
  047670  1070: ff36528d         push word ptr [0x8d52]
  047674  1074: 9a0c031f18       lcall 0x181f, 0x30c
  047679  1079: 83c404           add sp, 4
  04767C  107C: 3d4b00           cmp ax, 0x4b
  04767F  107F: 7c05             jl 0x1086
  047681  1081: b80100           mov ax, 1
  047684  1084: eb02             jmp 0x1088
  047686  1086: 2bc0             sub ax, ax
  047688  1088: 894692           mov word ptr [bp - 0x6e], ax
  04768B  108B: 837eec00         cmp word ptr [bp - 0x14], 0
  04768F  108F: 751e             jne 0x10af
  047691  1091: 0bc0             or ax, ax
  047693  1093: 751a             jne 0x10af
  047695  1095: 8b4684           mov ax, word ptr [bp - 0x7c]
  047698  1098: 8b9e5eff         mov bx, word ptr [bp - 0xa2]
  04769C  109C: 2b875631         sub ax, word ptr [bx + 0x3156]
  0476A0  10A0: 8b4eca           mov cx, word ptr [bp - 0x36]
  0476A3  10A3: d1e1             shl cx, 1
  0476A5  10A5: 83c105           add cx, 5
  0476A8  10A8: 3bc1             cmp ax, cx
  0476AA  10AA: 7d03             jge 0x10af
  0476AC  10AC: e9dbfc           jmp 0xd8a
  0476AF  10AF: 8b4684           mov ax, word ptr [bp - 0x7c]
  0476B2  10B2: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0476B6  10B6: 2b875631         sub ax, word ptr [bx + 0x3156]
  0476BA  10BA: d1e0             shl ax, 1
  0476BC  10BC: 018668ff         add word ptr [bp - 0x98], ax
  0476C0  10C0: 8b8668ff         mov ax, word ptr [bp - 0x98]
  0476C4  10C4: 0146dc           add word ptr [bp - 0x24], ax
  0476C7  10C7: 837e9200         cmp word ptr [bp - 0x6e], 0
  0476CB  10CB: 7504             jne 0x10d1
  0476CD  10CD: 804ece80         or byte ptr [bp - 0x32], 0x80
  0476D1  10D1: 837eb000         cmp word ptr [bp - 0x50], 0
  0476D5  10D5: 7577             jne 0x114e
  0476D7  10D7: 837e9800         cmp word ptr [bp - 0x68], 0
  0476DB  10DB: 7d71             jge 0x114e
  0476DD  10DD: 837eba00         cmp word ptr [bp - 0x46], 0
  0476E1  10E1: 7c6b             jl 0x114e
  0476E3  10E3: 699e6effca00     imul bx, word ptr [bp - 0x92], 0xca
  0476E9  10E9: 8bc3             mov ax, bx
  0476EB  10EB: 8a9f605d         mov bl, byte ptr [bx + 0x5d60]
  0476EF  10EF: 2aff             sub bh, bh
  0476F1  10F1: 8a8f1094         mov cl, byte ptr [bx - 0x6bf0]
  0476F5  10F5: c0e903           shr cl, 3
  0476F8  10F8: 2aed             sub ch, ch
  0476FA  10FA: 8b56ba           mov dx, word ptr [bp - 0x46]
  0476FD  10FD: d1e2             shl dx, 1
  0476FF  10FF: 03ca             add cx, dx
  047701  1101: 83c105           add cx, 5
  047704  1104: 8b5684           mov dx, word ptr [bp - 0x7c]
  047707  1107: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04770B  110B: 2b975631         sub dx, word ptr [bx + 0x3156]
  04770F  110F: 3bca             cmp cx, dx
  047711  1111: 7f3b             jg 0x114e
  047713  1113: 8bd8             mov bx, ax
  047715  1115: 8a8f475d         mov cl, byte ptr [bx + 0x5d47]
  047719  1119: 2aed             sub ch, ch
  04771B  111B: 2b4ee8           sub cx, word ptr [bp - 0x18]
  04771E  111E: f7d9             neg cx
  047720  1120: 51               push cx
  047721  1121: 8a8f465d         mov cl, byte ptr [bx + 0x5d46]
  047725  1125: 2aed             sub ch, ch
  047727  1127: 2b4ef6           sub cx, word ptr [bp - 0xa]
  04772A  112A: f7d9             neg cx
  04772C  112C: 51               push cx
  04772D  112D: 9a70031f18       lcall 0x181f, 0x370
  047732  1132: 83c404           add sp, 4
  047735  1135: 8946d2           mov word ptr [bp - 0x2e], ax
  047738  1138: 3d0c00           cmp ax, 0xc
  04773B  113B: 7d11             jge 0x114e
  04773D  113D: 2d0c00           sub ax, 0xc
  047740  1140: f7d8             neg ax
  047742  1142: 8bc8             mov cx, ax
  047744  1144: c1e002           shl ax, 2
  047747  1147: 03c1             add ax, cx
  047749  1149: d1e0             shl ax, 1
  04774B  114B: 0146dc           add word ptr [bp - 0x24], ax
  04774E  114E: 837eb000         cmp word ptr [bp - 0x50], 0
  047752  1152: 7503             jne 0x1157
  047754  1154: e93f02           jmp 0x1396
  047757  1157: 837efa04         cmp word ptr [bp - 6], 4
  04775B  115B: 7c03             jl 0x1160
  04775D  115D: e92afc           jmp 0xd8a
  047760  1160: ff76fa           push word ptr [bp - 6]
  047763  1163: ff76be           push word ptr [bp - 0x42]
  047766  1166: 9a0c031f18       lcall 0x181f, 0x30c
  04776B  116B: 83c404           add sp, 4
  04776E  116E: 898662ff         mov word ptr [bp - 0x9e], ax
  047772  1172: 3d6400           cmp ax, 0x64
  047775  1175: 7e03             jle 0x117a
  047777  1177: b86400           mov ax, 0x64
  04777A  117A: 898662ff         mov word ptr [bp - 0x9e], ax
  04777E  117E: 837ea200         cmp word ptr [bp - 0x5e], 0
  047782  1182: 7d09             jge 0x118d
  047784  1184: 837ea400         cmp word ptr [bp - 0x5c], 0
  047788  1188: 7d03             jge 0x118d
  04778A  118A: e9fb01           jmp 0x1388
  04778D  118D: 2bc0             sub ax, ax
  04778F  118F: 8946e0           mov word ptr [bp - 0x20], ax
  047792  1192: 8946c6           mov word ptr [bp - 0x3a], ax
  047795  1195: 898676ff         mov word ptr [bp - 0x8a], ax
  047799  1199: 6a02             push 2
  04779B  119B: ff7606           push word ptr [bp + 6]
  04779E  119E: 9abc081f18       lcall 0x181f, 0x8bc
  0477A3  11A3: 83c404           add sp, 4
  0477A6  11A6: 48               dec ax
  0477A7  11A7: 7505             jne 0x11ae
  0477A9  11A9: b80100           mov ax, 1
  0477AC  11AC: eb02             jmp 0x11b0
  0477AE  11AE: 2bc0             sub ax, ax
  0477B0  11B0: 89867cff         mov word ptr [bp - 0x84], ax
  0477B4  11B4: 837ea200         cmp word ptr [bp - 0x5e], 0
  0477B8  11B8: 7d03             jge 0x11bd
  0477BA  11BA: e91501           jmp 0x12d2
  0477BD  11BD: 8b46f6           mov ax, word ptr [bp - 0xa]
  0477C0  11C0: 8b56e8           mov dx, word ptr [bp - 0x18]
  0477C3  11C3: 9ae0071f18       lcall 0x181f, 0x7e0
  0477C8  11C8: 8946d4           mov word ptr [bp - 0x2c], ax
  0477CB  11CB: 8b5e8a           mov bx, word ptr [bp - 0x76]
  0477CE  11CE: c1e304           shl bx, 4
  0477D1  11D1: 8a87772f         mov al, byte ptr [bx + 0x2f77]
  0477D5  11D5: 2ae4             sub ah, ah
  0477D7  11D7: c1e002           shl ax, 2
  0477DA  11DA: 0146dc           add word ptr [bp - 0x24], ax
  0477DD  11DD: 8b46d4           mov ax, word ptr [bp - 0x2c]
  0477E0  11E0: e9dd00           jmp 0x12c0
  0477E3  11E3: 90               nop 
  0477E4  11E4: 83be7cff00       cmp word ptr [bp - 0x84], 0
  0477E9  11E9: 7409             je 0x11f4
  0477EB  11EB: 8346dc32         add word ptr [bp - 0x24], 0x32
  0477EF  11EF: c746e00100       mov word ptr [bp - 0x20], 1
  0477F4  11F4: c78676ff0100     mov word ptr [bp - 0x8a], 1
  0477FA  11FA: e9bb00           jmp 0x12b8
  0477FD  11FD: 90               nop 
  0477FE  11FE: 837eca01         cmp word ptr [bp - 0x36], 1
  047802  1202: 7e03             jle 0x1207
  047804  1204: e9b100           jmp 0x12b8
  047807  1207: 8b4690           mov ax, word ptr [bp - 0x70]
  04780A  120A: 050500           add ax, 5
  04780D  120D: c1e002           shl ax, 2
  047810  1210: 0146dc           add word ptr [bp - 0x24], ax
  047813  1213: e9a200           jmp 0x12b8
  047816  1216: 8346dc23         add word ptr [bp - 0x24], 0x23
  04781A  121A: c746c60100       mov word ptr [bp - 0x3a], 1
  04781F  121F: eb0b             jmp 0x122c
  047821  1221: 90               nop 
  047822  1222: 8346dc05         add word ptr [bp - 0x24], 5
  047826  1226: eb04             jmp 0x122c
  047828  1228: 8346dc0a         add word ptr [bp - 0x24], 0xa
  04782C  122C: 8b867cff         mov ax, word ptr [bp - 0x84]
  047830  1230: 8946e0           mov word ptr [bp - 0x20], ax
  047833  1233: e98200           jmp 0x12b8
  047836  1236: 8346dc0a         add word ptr [bp - 0x24], 0xa
  04783A  123A: eb7c             jmp 0x12b8
  04783C  123C: 90               nop 
  04783D  123D: 90               nop 
  04783E  123E: 8346dc02         add word ptr [bp - 0x24], 2
  047842  1242: 6b5e821c         imul bx, word ptr [bp - 0x7e], 0x1c
  047846  1246: 80bf503100       cmp byte ptr [bx + 0x3150], 0
  04784B  124B: 740d             je 0x125a
  04784D  124D: c746c60100       mov word ptr [bp - 0x3a], 1
  047852  1252: 804ece10         or byte ptr [bp - 0x32], 0x10
  047856  1256: 8346dc08         add word ptr [bp - 0x24], 8
  04785A  125A: 837ec600         cmp word ptr [bp - 0x3a], 0
  04785E  125E: 7512             jne 0x1272
  047860  1260: 6a64             push 0x64
  047862  1262: 6a32             push 0x32
  047864  1264: 9ad4041f18       lcall 0x181f, 0x4d4
  047869  1269: 83c404           add sp, 4
  04786C  126C: 3b8662ff         cmp ax, word ptr [bp - 0x9e]
  047870  1270: 7d46             jge 0x12b8
  047872  1272: 6b5e821c         imul bx, word ptr [bp - 0x7e], 0x1c
  047876  1276: 83bf5c3100       cmp word ptr [bx + 0x315c], 0
  04787B  127B: 7d3b             jge 0x12b8
  04787D  127D: 83bf5e3100       cmp word ptr [bx + 0x315e], 0
  047882  1282: 7d34             jge 0x12b8
  047884  1284: 8346dc0a         add word ptr [bp - 0x24], 0xa
  047888  1288: b80100           mov ax, 1
  04788B  128B: 8946c6           mov word ptr [bp - 0x3a], ax
  04788E  128E: eba0             jmp 0x1230
  047890  1290: 3d0c00           cmp ax, 0xc
  047893  1293: 7723             ja 0x12b8
  047895  1295: d1e0             shl ax, 1
  047897  1297: 93               xchg bx, ax
  047898  1298: 2effa7be0a       jmp word ptr cs:[bx + 0xabe]
  04789D  129D: 90               nop 
  04789E  129E: 42               inc dx
  04789F  129F: 0a1e0a48         or bl, byte ptr [0x480a]
  0478A3  12A3: 0ad8             or bl, al
  0478A5  12A5: 0a1e0a56         or bl, byte ptr [0x560a]
  0478A9  12A9: 0ad8             or bl, al
  0478AB  12AB: 0ad8             or bl, al
  0478AD  12AD: 0ad8             or bl, al
  0478AF  12AF: 0ad8             or bl, al
  0478B1  12B1: 0a04             or al, byte ptr [si]
  0478B3  12B3: 0a360a5e         or dh, byte ptr [0x5e0a]
  0478B7  12B7: 0a8b4682         or cl, byte ptr [bp + di - 0x7dba]
  0478BB  12BB: 9ae4021f18       lcall 0x181f, 0x2e4
  0478C0  12C0: 894682           mov word ptr [bp - 0x7e], ax
  0478C3  12C3: 0bc0             or ax, ax
  0478C5  12C5: 7c0b             jl 0x12d2
  0478C7  12C7: 6bd81c           imul bx, ax, 0x1c
  0478CA  12CA: 8a874631         mov al, byte ptr [bx + 0x3146]
  0478CE  12CE: 2ae4             sub ah, ah
  0478D0  12D0: ebbe             jmp 0x1290
  0478D2  12D2: 837ea400         cmp word ptr [bp - 0x5c], 0
  0478D6  12D6: 7c16             jl 0x12ee
  0478D8  12D8: 83be62ff4b       cmp word ptr [bp - 0x9e], 0x4b
  0478DD  12DD: 7c04             jl 0x12e3
  0478DF  12DF: 8346dc14         add word ptr [bp - 0x24], 0x14
  0478E3  12E3: 83be62ff32       cmp word ptr [bp - 0x9e], 0x32
  0478E8  12E8: 7c04             jl 0x12ee
  0478EA  12EA: 8346dc0a         add word ptr [bp - 0x24], 0xa
  0478EE  12EE: 83be62ff19       cmp word ptr [bp - 0x9e], 0x19
  0478F3  12F3: 7f2d             jg 0x1322
  0478F5  12F5: 837eec00         cmp word ptr [bp - 0x14], 0
  0478F9  12F9: 7527             jne 0x1322
  0478FB  12FB: 837ee000         cmp word ptr [bp - 0x20], 0
  0478FF  12FF: 7503             jne 0x1304
  047901  1301: e986fa           jmp 0xd8a
  047904  1304: 83be76ff00       cmp word ptr [bp - 0x8a], 0
  047909  1309: 7503             jne 0x130e
  04790B  130B: e97cfa           jmp 0xd8a
  04790E  130E: 6a07             push 7
  047910  1310: 6a00             push 0
  047912  1312: 9ad4041f18       lcall 0x181f, 0x4d4
  047917  1317: 83c404           add sp, 4
  04791A  131A: 0bc0             or ax, ax
  04791C  131C: 7416             je 0x1334
  04791E  131E: e969fa           jmp 0xd8a
  047921  1321: 90               nop 
  047922  1322: 837ea400         cmp word ptr [bp - 0x5c], 0
  047926  1326: 7d0c             jge 0x1334
  047928  1328: 83be78ff20       cmp word ptr [bp - 0x88], 0x20
  04792D  132D: 7c05             jl 0x1334
  04792F  132F: c746ec0100       mov word ptr [bp - 0x14], 1
  047934  1334: b83200           mov ax, 0x32
  047937  1337: 2b8662ff         sub ax, word ptr [bp - 0x9e]
  04793B  133B: 898674ff         mov word ptr [bp - 0x8c], ax
  04793F  133F: 2946dc           sub word ptr [bp - 0x24], ax
  047942  1342: ffb662ff         push word ptr [bp - 0x9e]
  047946  1346: 9a600a1f18       lcall 0x181f, 0xa60
  04794B  134B: 83c402           add sp, 2
  04794E  134E: 2d0400           sub ax, 4
  047951  1351: f7d8             neg ax
  047953  1353: 898664ff         mov word ptr [bp - 0x9c], ax
  047957  1357: 837efa04         cmp word ptr [bp - 6], 4
  04795B  135B: 7d10             jge 0x136d
  04795D  135D: 6b5efa34         imul bx, word ptr [bp - 6], 0x34
  047961  1361: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  047966  1366: 7505             jne 0x136d
  047968  1368: a0a653           mov al, byte ptr [0x53a6]
  04796B  136B: 2ae4             sub ah, ah
  04796D  136D: 837ee000         cmp word ptr [bp - 0x20], 0
  047971  1371: 7509             jne 0x137c
  047973  1373: 837eec00         cmp word ptr [bp - 0x14], 0
  047977  1377: 7503             jne 0x137c
  047979  1379: e90efa           jmp 0xd8a
  04797C  137C: 804ece08         or byte ptr [bp - 0x32], 8
  047980  1380: c746960100       mov word ptr [bp - 0x6a], 1
  047985  1385: eb0f             jmp 0x1396
  047987  1387: 90               nop 
  047988  1388: b83200           mov ax, 0x32
  04798B  138B: 2b8662ff         sub ax, word ptr [bp - 0x9e]
  04798F  138F: 898674ff         mov word ptr [bp - 0x8c], ax
  047993  1393: 2946dc           sub word ptr [bp - 0x24], ax
  047996  1396: c746ee0000       mov word ptr [bp - 0x12], 0
  04799B  139B: 8b46a4           mov ax, word ptr [bp - 0x5c]
  04799E  139E: 39866cff         cmp word ptr [bp - 0x94], ax
  0479A2  13A2: 7547             jne 0x13eb
  0479A4  13A4: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0479A8  13A8: 807f0700         cmp byte ptr [bx + 7], 0
  0479AC  13AC: 7e1b             jle 0x13c9
  0479AE  13AE: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0479B2  13B2: 80bf463113       cmp byte ptr [bx + 0x3146], 0x13
  0479B7  13B7: 7407             je 0x13c0
  0479B9  13B9: 80bf463115       cmp byte ptr [bx + 0x3146], 0x15
  0479BE  13BE: 7509             jne 0x13c9
  0479C0  13C0: 8346dc14         add word ptr [bp - 0x24], 0x14
  0479C4  13C4: c746ee0100       mov word ptr [bp - 0x12], 1
  0479C9  13C9: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0479CD  13CD: 837f0a19         cmp word ptr [bx + 0xa], 0x19
  0479D1  13D1: 7c18             jl 0x13eb
  0479D3  13D3: ff7606           push word ptr [bp + 6]
  0479D6  13D6: 9a0c091f18       lcall 0x181f, 0x90c
  0479DB  13DB: 83c402           add sp, 2
  0479DE  13DE: 3c03             cmp al, 3
  0479E0  13E0: 7709             ja 0x13eb
  0479E2  13E2: 8346dc14         add word ptr [bp - 0x24], 0x14
  0479E6  13E6: c746ee0100       mov word ptr [bp - 0x12], 1
  0479EB  13EB: 837ecc08         cmp word ptr [bp - 0x34], 8
  0479EF  13EF: 7435             je 0x1426
  0479F1  13F1: 837ea200         cmp word ptr [bp - 0x5e], 0
  0479F5  13F5: 7c6b             jl 0x1462
  0479F7  13F7: 8b46a2           mov ax, word ptr [bp - 0x5e]
  0479FA  13FA: 39866cff         cmp word ptr [bp - 0x94], ax
  0479FE  13FE: 7562             jne 0x1462
  047A00  1400: 8b46f6           mov ax, word ptr [bp - 0xa]
  047A03  1403: 8b56e8           mov dx, word ptr [bp - 0x18]
  047A06  1406: 9ae0071f18       lcall 0x181f, 0x7e0
  047A0B  140B: 8946d4           mov word ptr [bp - 0x2c], ax
  047A0E  140E: 9ae4021f18       lcall 0x181f, 0x2e4
  047A13  1413: 0bc0             or ax, ax
  047A15  1415: 7c09             jl 0x1420
  047A17  1417: 837ea400         cmp word ptr [bp - 0x5c], 0
  047A1B  141B: 7d03             jge 0x1420
  047A1D  141D: e96af9           jmp 0xd8a
  047A20  1420: 836edc28         sub word ptr [bp - 0x24], 0x28
  047A24  1424: eb3c             jmp 0x1462
  047A26  1426: 6a02             push 2
  047A28  1428: ff7606           push word ptr [bp + 6]
  047A2B  142B: 9abc081f18       lcall 0x181f, 0x8bc
  047A30  1430: 83c404           add sp, 4
  047A33  1433: 48               dec ax
  047A34  1434: f7d8             neg ax
  047A36  1436: 6bc028           imul ax, ax, 0x28
  047A39  1439: 0146dc           add word ptr [bp - 0x24], ax
  047A3C  143C: 837e9600         cmp word ptr [bp - 0x6a], 0
  047A40  1440: 751c             jne 0x145e
  047A42  1442: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  047A46  1446: 8a4702           mov al, byte ptr [bx + 2]
  047A49  1449: 2ae4             sub ah, ah
  047A4B  144B: 40               inc ax
  047A4C  144C: c1e002           shl ax, 2
  047A4F  144F: 50               push ax
  047A50  1450: 6a00             push 0
  047A52  1452: 9ad4041f18       lcall 0x181f, 0x4d4
  047A57  1457: 83c404           add sp, 4
  047A5A  145A: 0bc0             or ax, ax
  047A5C  145C: 7504             jne 0x1462
  047A5E  145E: 836edc19         sub word ptr [bp - 0x24], 0x19
  047A62  1462: 837ecc08         cmp word ptr [bp - 0x34], 8
  047A66  1466: 7503             jne 0x146b
  047A68  1468: e96b01           jmp 0x15d6
  047A6B  146B: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  047A6F  146F: 8a874f31         mov al, byte ptr [bx + 0x314f]
  047A73  1473: 98               cwde 
  047A74  1474: 3b46cc           cmp ax, word ptr [bp - 0x34]
  047A77  1477: 7507             jne 0x1480
  047A79  1479: 8346dc04         add word ptr [bp - 0x24], 4
  047A7D  147D: eb35             jmp 0x14b4
  047A7F  147F: 90               nop 
  047A80  1480: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  047A84  1484: 8a874f31         mov al, byte ptr [bx + 0x314f]
  047A88  1488: 98               cwde 
  047A89  1489: 50               push ax
  047A8A  148A: ff76cc           push word ptr [bp - 0x34]
  047A8D  148D: 9a84031f18       lcall 0x181f, 0x384
  047A92  1492: 83c404           add sp, 4
  047A95  1495: 0bc0             or ax, ax
  047A97  1497: 7407             je 0x14a0
  047A99  1499: 8346dc03         add word ptr [bp - 0x24], 3
  047A9D  149D: eb15             jmp 0x14b4
  047A9F  149F: 90               nop 
  047AA0  14A0: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  047AA4  14A4: 8a874f31         mov al, byte ptr [bx + 0x314f]
  047AA8  14A8: 3404             xor al, 4
  047AAA  14AA: 98               cwde 
  047AAB  14AB: 3b46cc           cmp ax, word ptr [bp - 0x34]
  047AAE  14AE: 7504             jne 0x14b4
  047AB0  14B0: 836edc06         sub word ptr [bp - 0x24], 6
  047AB4  14B4: 837ec000         cmp word ptr [bp - 0x40], 0
  047AB8  14B8: 7503             jne 0x14bd
  047ABA  14BA: e9fb00           jmp 0x15b8
  047ABD  14BD: 837ed600         cmp word ptr [bp - 0x2a], 0
  047AC1  14C1: 7503             jne 0x14c6
  047AC3  14C3: e9f200           jmp 0x15b8
  047AC6  14C6: 8346dc04         add word ptr [bp - 0x24], 4
  047ACA  14CA: 837e8800         cmp word ptr [bp - 0x78], 0
  047ACE  14CE: 7c6c             jl 0x153c
  047AD0  14D0: 6b5e8812         imul bx, word ptr [bp - 0x78], 0x12
  047AD4  14D4: 8a87ed54         mov al, byte ptr [bx + 0x54ed]
  047AD8  14D8: 2ae4             sub ah, ah
  047ADA  14DA: 2b46e8           sub ax, word ptr [bp - 0x18]
  047ADD  14DD: f7d8             neg ax
  047ADF  14DF: 50               push ax
  047AE0  14E0: 8a87ec54         mov al, byte ptr [bx + 0x54ec]
  047AE4  14E4: 2ae4             sub ah, ah
  047AE6  14E6: 2b46f6           sub ax, word ptr [bp - 0xa]
  047AE9  14E9: f7d8             neg ax
  047AEB  14EB: 50               push ax
  047AEC  14EC: 9a70031f18       lcall 0x181f, 0x370
  047AF1  14F1: 83c404           add sp, 4
  047AF4  14F4: 8946d2           mov word ptr [bp - 0x2e], ax
  047AF7  14F7: 3d0200           cmp ax, 2
  047AFA  14FA: 7e40             jle 0x153c
  047AFC  14FC: 8bc8             mov cx, ax
  047AFE  14FE: d1e0             shl ax, 1
  047B00  1500: 03c1             add ax, cx
  047B02  1502: 8946ea           mov word ptr [bp - 0x16], ax
  047B05  1505: 83be7aff00       cmp word ptr [bp - 0x86], 0
  047B0A  150A: 7405             je 0x1511
  047B0C  150C: d1f8             sar ax, 1
  047B0E  150E: 8946ea           mov word ptr [bp - 0x16], ax
  047B11  1511: ff7606           push word ptr [bp + 6]
  047B14  1514: 9a02091f18       lcall 0x181f, 0x902
  047B19  1519: 83c402           add sp, 2
  047B1C  151C: 0bc0             or ax, ax
  047B1E  151E: 7403             je 0x1523
  047B20  1520: d17eea           sar word ptr [bp - 0x16], 1
  047B23  1523: ff7606           push word ptr [bp + 6]
  047B26  1526: 9ad0081f18       lcall 0x181f, 0x8d0
  047B2B  152B: 83c402           add sp, 2
  047B2E  152E: 0bc0             or ax, ax
  047B30  1530: 7404             je 0x1536
  047B32  1532: c17eea02         sar word ptr [bp - 0x16], 2
  047B36  1536: 8b46ea           mov ax, word ptr [bp - 0x16]
  047B39  1539: 2946dc           sub word ptr [bp - 0x24], ax
  047B3C  153C: ffb66cff         push word ptr [bp - 0x94]
  047B40  1540: ff76e8           push word ptr [bp - 0x18]
  047B43  1543: ff76f6           push word ptr [bp - 0xa]
  047B46  1546: 9a84091f18       lcall 0x181f, 0x984
  047B4B  154B: 83c406           add sp, 6
  047B4E  154E: 0bc0             or ax, ax
  047B50  1550: 7503             jne 0x1555
  047B52  1552: e94501           jmp 0x169a
  047B55  1555: 833efa8c04       cmp word ptr [0x8cfa], 4
  047B5A  155A: 7c03             jl 0x155f
  047B5C  155C: e93701           jmp 0x1696
  047B5F  155F: ff36fa8c         push word ptr [0x8cfa]
  047B63  1563: ffb66cff         push word ptr [bp - 0x94]
  047B67  1567: 9a380a1f18       lcall 0x181f, 0xa38
  047B6C  156C: 83c404           add sp, 4
  047B6F  156F: 89469e           mov word ptr [bp - 0x62], ax
  047B72  1572: a820             test al, 0x20
  047B74  1574: 7504             jne 0x157a
  047B76  1576: 8346dc32         add word ptr [bp - 0x24], 0x32
  047B7A  157A: ff36fa8c         push word ptr [0x8cfa]
  047B7E  157E: ff76be           push word ptr [bp - 0x42]
  047B81  1581: 9a0c031f18       lcall 0x181f, 0x30c
  047B86  1586: 83c404           add sp, 4
  047B89  1589: 898662ff         mov word ptr [bp - 0x9e], ax
  047B8D  158D: 50               push ax
  047B8E  158E: 9a600a1f18       lcall 0x181f, 0xa60
  047B93  1593: 83c402           add sp, 2
  047B96  1596: 0bc0             or ax, ax
  047B98  1598: 7f03             jg 0x159d
  047B9A  159A: e9fd00           jmp 0x169a
  047B9D  159D: ff36fa8c         push word ptr [0x8cfa]
  047BA1  15A1: ff76be           push word ptr [bp - 0x42]
  047BA4  15A4: 9a0c031f18       lcall 0x181f, 0x30c
  047BA9  15A9: 83c404           add sp, 4
  047BAC  15AC: 2d3200           sub ax, 0x32
  047BAF  15AF: c1f802           sar ax, 2
  047BB2  15B2: 0146dc           add word ptr [bp - 0x24], ax
  047BB5  15B5: e9e200           jmp 0x169a
  047BB8  15B8: f646cc01         test byte ptr [bp - 0x34], 1
  047BBC  15BC: 7403             je 0x15c1
  047BBE  15BE: e909ff           jmp 0x14ca
  047BC1  15C1: 837eac00         cmp word ptr [bp - 0x54], 0
  047BC5  15C5: 7503             jne 0x15ca
  047BC7  15C7: e900ff           jmp 0x14ca
  047BCA  15CA: 837ec200         cmp word ptr [bp - 0x3e], 0
  047BCE  15CE: 7503             jne 0x15d3
  047BD0  15D0: e9f7fe           jmp 0x14ca
  047BD3  15D3: e9f0fe           jmp 0x14c6
  047BD6  15D6: 83be7aff00       cmp word ptr [bp - 0x86], 0
  047BDB  15DB: 7551             jne 0x162e
  047BDD  15DD: 837ee400         cmp word ptr [bp - 0x1c], 0
  047BE1  15E1: 743f             je 0x1622
  047BE3  15E3: 83be60ff04       cmp word ptr [bp - 0xa0], 4
  047BE8  15E8: 7c03             jl 0x15ed
  047BEA  15EA: e9ddfe           jmp 0x14ca
  047BED  15ED: ffb660ff         push word ptr [bp - 0xa0]
  047BF1  15F1: ff76be           push word ptr [bp - 0x42]
  047BF4  15F4: 9a0c031f18       lcall 0x181f, 0x30c
  047BF9  15F9: 83c404           add sp, 4
  047BFC  15FC: 898662ff         mov word ptr [bp - 0x9e], ax
  047C00  1600: 50               push ax
  047C01  1601: 9a600a1f18       lcall 0x181f, 0xa60
  047C06  1606: 83c402           add sp, 2
  047C09  1609: 0bc0             or ax, ax
  047C0B  160B: 7f03             jg 0x1610
  047C0D  160D: e9bafe           jmp 0x14ca
  047C10  1610: 8b8662ff         mov ax, word ptr [bp - 0x9e]
  047C14  1614: 2d3200           sub ax, 0x32
  047C17  1617: d1f8             sar ax, 1
  047C19  1619: 050800           add ax, 8
  047C1C  161C: 0146dc           add word ptr [bp - 0x24], ax
  047C1F  161F: e9a8fe           jmp 0x14ca
  047C22  1622: 837eee00         cmp word ptr [bp - 0x12], 0
  047C26  1626: 7503             jne 0x162b
  047C28  1628: e95ff7           jmp 0xd8a
  047C2B  162B: e99cfe           jmp 0x14ca
  047C2E  162E: 837ee400         cmp word ptr [bp - 0x1c], 0
  047C32  1632: 7503             jne 0x1637
  047C34  1634: e993fe           jmp 0x14ca
  047C37  1637: 83be60ff04       cmp word ptr [bp - 0xa0], 4
  047C3C  163C: 7d1c             jge 0x165a
  047C3E  163E: ffb660ff         push word ptr [bp - 0xa0]
  047C42  1642: ff76be           push word ptr [bp - 0x42]
  047C45  1645: 9a0c031f18       lcall 0x181f, 0x30c
  047C4A  164A: 83c404           add sp, 4
  047C4D  164D: 3d5f00           cmp ax, 0x5f
  047C50  1650: 7c08             jl 0x165a
  047C52  1652: 8346dc10         add word ptr [bp - 0x24], 0x10
  047C56  1656: e971fe           jmp 0x14ca
  047C59  1659: 90               nop 
  047C5A  165A: 83be60ff04       cmp word ptr [bp - 0xa0], 4
  047C5F  165F: 7c03             jl 0x1664
  047C61  1661: e966fe           jmp 0x14ca
  047C64  1664: ffb660ff         push word ptr [bp - 0xa0]
  047C68  1668: ff76be           push word ptr [bp - 0x42]
  047C6B  166B: 9a0c031f18       lcall 0x181f, 0x30c
  047C70  1670: 83c404           add sp, 4
  047C73  1673: 898662ff         mov word ptr [bp - 0x9e], ax
  047C77  1677: 50               push ax
  047C78  1678: 9a600a1f18       lcall 0x181f, 0xa60
  047C7D  167D: 83c402           add sp, 2
  047C80  1680: 0bc0             or ax, ax
  047C82  1682: 7f03             jg 0x1687
  047C84  1684: e943fe           jmp 0x14ca
  047C87  1687: 8b8662ff         mov ax, word ptr [bp - 0x9e]
  047C8B  168B: 2d3200           sub ax, 0x32
  047C8E  168E: d1f8             sar ax, 1
  047C90  1690: 050500           add ax, 5
  047C93  1693: eb87             jmp 0x161c
  047C95  1695: 90               nop 
  047C96  1696: 836edc19         sub word ptr [bp - 0x24], 0x19
  047C9A  169A: 83be7aff00       cmp word ptr [bp - 0x86], 0
  047C9F  169F: 7403             je 0x16a4
  047CA1  16A1: e9a400           jmp 0x1748
  047CA4  16A4: 837efa00         cmp word ptr [bp - 6], 0
  047CA8  16A8: 7d04             jge 0x16ae
  047CAA  16AA: 8346dc05         add word ptr [bp - 0x24], 5
  047CAE  16AE: 83be6eff00       cmp word ptr [bp - 0x92], 0
  047CB3  16B3: 7d03             jge 0x16b8
  047CB5  16B5: e98002           jmp 0x1938
  047CB8  16B8: ff76e8           push word ptr [bp - 0x18]
  047CBB  16BB: ff76f6           push word ptr [bp - 0xa]
  047CBE  16BE: 9ab4061f18       lcall 0x181f, 0x6b4
  047CC3  16C3: 83c404           add sp, 4
  047CC6  16C6: 3a46da           cmp al, byte ptr [bp - 0x26]
  047CC9  16C9: 7403             je 0x16ce
  047CCB  16CB: e96a02           jmp 0x1938
  047CCE  16CE: 699e6effca00     imul bx, word ptr [bp - 0x92], 0xca
  047CD4  16D4: 8a87475d         mov al, byte ptr [bx + 0x5d47]
  047CD8  16D8: 2ae4             sub ah, ah
  047CDA  16DA: 2b46e8           sub ax, word ptr [bp - 0x18]
  047CDD  16DD: f7d8             neg ax
  047CDF  16DF: 50               push ax
  047CE0  16E0: 8a87465d         mov al, byte ptr [bx + 0x5d46]
  047CE4  16E4: 2ae4             sub ah, ah
  047CE6  16E6: 2b46f6           sub ax, word ptr [bp - 0xa]
  047CE9  16E9: f7d8             neg ax
  047CEB  16EB: 50               push ax
  047CEC  16EC: 8bf3             mov si, bx
  047CEE  16EE: 9a70031f18       lcall 0x181f, 0x370
  047CF3  16F3: 83c404           add sp, 4
  047CF6  16F6: 8946d2           mov word ptr [bp - 0x2e], ax
  047CF9  16F9: 8a84605d         mov al, byte ptr [si + 0x5d60]
  047CFD  16FD: 2ae4             sub ah, ah
  047CFF  16FF: 50               push ax
  047D00  1700: ff76be           push word ptr [bp - 0x42]
  047D03  1703: 9a0c031f18       lcall 0x181f, 0x30c
  047D08  1708: 83c404           add sp, 4
  047D0B  170B: 898662ff         mov word ptr [bp - 0x9e], ax
  047D0F  170F: 837ed20c         cmp word ptr [bp - 0x2e], 0xc
  047D13  1713: 7c03             jl 0x1718
  047D15  1715: e92002           jmp 0x1938
  047D18  1718: 50               push ax
  047D19  1719: 9a600a1f18       lcall 0x181f, 0xa60
  047D1E  171E: 83c402           add sp, 2
  047D21  1721: 40               inc ax
  047D22  1722: 3d0100           cmp ax, 1
  047D25  1725: 7d03             jge 0x172a
  047D27  1727: e9fa01           jmp 0x1924
  047D2A  172A: ffb662ff         push word ptr [bp - 0x9e]
  047D2E  172E: 9a600a1f18       lcall 0x181f, 0xa60
  047D33  1733: 83c402           add sp, 2
  047D36  1736: 40               inc ax
  047D37  1737: b90c00           mov cx, 0xc
  047D3A  173A: 2b4ed2           sub cx, word ptr [bp - 0x2e]
  047D3D  173D: f7e9             imul cx
  047D3F  173F: c1f802           sar ax, 2
  047D42  1742: 0146dc           add word ptr [bp - 0x24], ax
  047D45  1745: e9f001           jmp 0x1938
  047D48  1748: 837eec00         cmp word ptr [bp - 0x14], 0
  047D4C  174C: 7509             jne 0x1757
  047D4E  174E: 837e9200         cmp word ptr [bp - 0x6e], 0
  047D52  1752: 7503             jne 0x1757
  047D54  1754: e92101           jmp 0x1878
  047D57  1757: 8346dc05         add word ptr [bp - 0x24], 5
  047D5B  175B: 837eae00         cmp word ptr [bp - 0x52], 0
  047D5F  175F: 7404             je 0x1765
  047D61  1761: 8346dc0a         add word ptr [bp - 0x24], 0xa
  047D65  1765: ff76e8           push word ptr [bp - 0x18]
  047D68  1768: ff76f6           push word ptr [bp - 0xa]
  047D6B  176B: 9abe071f18       lcall 0x181f, 0x7be
  047D70  1770: 83c404           add sp, 4
  047D73  1773: 898666ff         mov word ptr [bp - 0x9a], ax
  047D77  1777: 0bc0             or ax, ax
  047D79  1779: 7c11             jl 0x178c
  047D7B  177B: 50               push ax
  047D7C  177C: 9ae6091f18       lcall 0x181f, 0x9e6
  047D81  1781: 83c402           add sp, 2
  047D84  1784: 8146dcf401       add word ptr [bp - 0x24], 0x1f4
  047D89  1789: e9f500           jmp 0x1881
  047D8C  178C: 837ea200         cmp word ptr [bp - 0x5e], 0
  047D90  1790: 7d03             jge 0x1795
  047D92  1792: e9ec00           jmp 0x1881
  047D95  1795: ffb66cff         push word ptr [bp - 0x94]
  047D99  1799: 8b46f6           mov ax, word ptr [bp - 0xa]
  047D9C  179C: 8b56e8           mov dx, word ptr [bp - 0x18]
  047D9F  179F: 9ae0071f18       lcall 0x181f, 0x7e0
  047DA4  17A4: 50               push ax
  047DA5  17A5: 9a58041f1a       lcall 0x1a1f, 0x458
  047DAA  17AA: 83c404           add sp, 4
  047DAD  17AD: 8946c4           mov word ptr [bp - 0x3c], ax
  047DB0  17B0: 6a01             push 1
  047DB2  17B2: ff7606           push word ptr [bp + 6]
  047DB5  17B5: 9ac8091f18       lcall 0x181f, 0x9c8
  047DBA  17BA: 83c404           add sp, 4
  047DBD  17BD: 8bc8             mov cx, ax
  047DBF  17BF: d1e0             shl ax, 1
  047DC1  17C1: 03c1             add ax, cx
  047DC3  17C3: d1f8             sar ax, 1
  047DC5  17C5: 8946b0           mov word ptr [bp - 0x50], ax
  047DC8  17C8: ff7606           push word ptr [bp + 6]
  047DCB  17CB: ff76c4           push word ptr [bp - 0x3c]
  047DCE  17CE: 9adc091f18       lcall 0x181f, 0x9dc
  047DD3  17D3: 83c404           add sp, 4
  047DD6  17D6: 894694           mov word ptr [bp - 0x6c], ax
  047DD9  17D9: 6b5ec41c         imul bx, word ptr [bp - 0x3c], 0x1c
  047DDD  17DD: 80bf46310b       cmp byte ptr [bx + 0x3146], 0xb
  047DE2  17E2: 7504             jne 0x17e8
  047DE4  17E4: c17e9403         sar word ptr [bp - 0x6c], 3
  047DE8  17E8: 8b4606           mov ax, word ptr [bp + 6]
  047DEB  17EB: 89468e           mov word ptr [bp - 0x72], ax
  047DEE  17EE: 8b46c4           mov ax, word ptr [bp - 0x3c]
  047DF1  17F1: 9aee021f18       lcall 0x181f, 0x2ee
  047DF6  17F6: eb4e             jmp 0x1846
  047DF8  17F8: 8346dc10         add word ptr [bp - 0x24], 0x10
  047DFC  17FC: eb40             jmp 0x183e
  047DFE  17FE: 8346dc08         add word ptr [bp - 0x24], 8
  047E02  1802: eb3a             jmp 0x183e
  047E04  1804: 8346dc04         add word ptr [bp - 0x24], 4
  047E08  1808: eb34             jmp 0x183e
  047E0A  180A: ff4edc           dec word ptr [bp - 0x24]
  047E0D  180D: eb2f             jmp 0x183e
  047E0F  180F: 90               nop 
  047E10  1810: 836edc02         sub word ptr [bp - 0x24], 2
  047E14  1814: eb28             jmp 0x183e
  047E16  1816: 3d0c00           cmp ax, 0xc
  047E19  1819: 7723             ja 0x183e
  047E1B  181B: d1e0             shl ax, 1
  047E1D  181D: 93               xchg bx, ax
  047E1E  181E: 2effa74410       jmp word ptr cs:[bx + 0x1044]
  047E23  1823: 90               nop 
  047E24  1824: 2410             and al, 0x10
  047E26  1826: 3010             xor byte ptr [bx + si], dl
  047E28  1828: 1e               push ds
  047E29  1829: 101e102a         adc byte ptr [0x2a10], bl
  047E2D  182D: 101e105e         adc byte ptr [0x5e10], bl
  047E31  1831: 105e10           adc byte ptr [bp + 0x10], bl
  047E34  1834: 5e               pop si
  047E35  1835: 105e10           adc byte ptr [bp + 0x10], bl
  047E38  1838: 1810             sbb byte ptr [bx + si], dl
  047E3A  183A: 1810             sbb byte ptr [bx + si], dl
  047E3C  183C: 1810             sbb byte ptr [bx + si], dl
  047E3E  183E: 8b4606           mov ax, word ptr [bp + 6]
  047E41  1841: 9ae4021f18       lcall 0x181f, 0x2e4
  047E46  1846: 894606           mov word ptr [bp + 6], ax
  047E49  1849: 0bc0             or ax, ax
  047E4B  184B: 7c0b             jl 0x1858
  047E4D  184D: 6bd81c           imul bx, ax, 0x1c
  047E50  1850: 8a874631         mov al, byte ptr [bx + 0x3146]
  047E54  1854: 2ae4             sub ah, ah
  047E56  1856: ebbe             jmp 0x1816
  047E58  1858: 8b468e           mov ax, word ptr [bp - 0x72]
  047E5B  185B: 894606           mov word ptr [bp + 6], ax
  047E5E  185E: 8b46b0           mov ax, word ptr [bp - 0x50]
  047E61  1861: 394694           cmp word ptr [bp - 0x6c], ax
  047E64  1864: 7f08             jg 0x186e
  047E66  1866: 2b4694           sub ax, word ptr [bp - 0x6c]
  047E69  1869: 051e00           add ax, 0x1e
  047E6C  186C: eb05             jmp 0x1873
  047E6E  186E: 2b4694           sub ax, word ptr [bp - 0x6c]
  047E71  1871: d1e0             shl ax, 1
  047E73  1873: 0146dc           add word ptr [bp - 0x24], ax
  047E76  1876: eb09             jmp 0x1881
  047E78  1878: 837ea400         cmp word ptr [bp - 0x5c], 0
  047E7C  187C: 7c03             jl 0x1881
  047E7E  187E: e909f5           jmp 0xd8a
  047E81  1881: 83be6eff00       cmp word ptr [bp - 0x92], 0
  047E86  1886: 7d03             jge 0x188b
  047E88  1888: e9ad00           jmp 0x1938
  047E8B  188B: 699e6effca00     imul bx, word ptr [bp - 0x92], 0xca
  047E91  1891: 8a87475d         mov al, byte ptr [bx + 0x5d47]
  047E95  1895: 2ae4             sub ah, ah
  047E97  1897: 2b46e8           sub ax, word ptr [bp - 0x18]
  047E9A  189A: f7d8             neg ax
  047E9C  189C: 50               push ax
  047E9D  189D: 8a87465d         mov al, byte ptr [bx + 0x5d46]
  047EA1  18A1: 2ae4             sub ah, ah
  047EA3  18A3: 2b46f6           sub ax, word ptr [bp - 0xa]
  047EA6  18A6: f7d8             neg ax
  047EA8  18A8: 50               push ax
  047EA9  18A9: 8bf3             mov si, bx
  047EAB  18AB: 9a70031f18       lcall 0x181f, 0x370
  047EB0  18B0: 83c404           add sp, 4
  047EB3  18B3: 8946d2           mov word ptr [bp - 0x2e], ax
  047EB6  18B6: ff76e8           push word ptr [bp - 0x18]
  047EB9  18B9: ff76f6           push word ptr [bp - 0xa]
  047EBC  18BC: 9ab4061f18       lcall 0x181f, 0x6b4
  047EC1  18C1: 83c404           add sp, 4
  047EC4  18C4: 3a46da           cmp al, byte ptr [bp - 0x26]
  047EC7  18C7: 756f             jne 0x1938
  047EC9  18C9: 8a84605d         mov al, byte ptr [si + 0x5d60]
  047ECD  18CD: 2ae4             sub ah, ah
  047ECF  18CF: 50               push ax
  047ED0  18D0: ffb66cff         push word ptr [bp - 0x94]
  047ED4  18D4: 9a380a1f18       lcall 0x181f, 0xa38
  047ED9  18D9: 83c404           add sp, 4
  047EDC  18DC: 89469e           mov word ptr [bp - 0x62], ax
  047EDF  18DF: 8a84605d         mov al, byte ptr [si + 0x5d60]
  047EE3  18E3: 2ae4             sub ah, ah
  047EE5  18E5: 50               push ax
  047EE6  18E6: ff76be           push word ptr [bp - 0x42]
  047EE9  18E9: 9a0c031f18       lcall 0x181f, 0x30c
  047EEE  18EE: 83c404           add sp, 4
  047EF1  18F1: 3d4b00           cmp ax, 0x4b
  047EF4  18F4: 7d34             jge 0x192a
  047EF6  18F6: 8a84605d         mov al, byte ptr [si + 0x5d60]
  047EFA  18FA: 2ae4             sub ah, ah
  047EFC  18FC: 50               push ax
  047EFD  18FD: ff76be           push word ptr [bp - 0x42]
  047F00  1900: 9a0c031f18       lcall 0x181f, 0x30c
  047F05  1905: 83c404           add sp, 4
  047F08  1908: 898662ff         mov word ptr [bp - 0x9e], ax
  047F0C  190C: 837ed20c         cmp word ptr [bp - 0x2e], 0xc
  047F10  1910: 7d26             jge 0x1938
  047F12  1912: 50               push ax
  047F13  1913: 9a600a1f18       lcall 0x181f, 0xa60
  047F18  1918: 83c402           add sp, 2
  047F1B  191B: 40               inc ax
  047F1C  191C: 3d0100           cmp ax, 1
  047F1F  191F: 7c03             jl 0x1924
  047F21  1921: e906fe           jmp 0x172a
  047F24  1924: b80100           mov ax, 1
  047F27  1927: e90dfe           jmp 0x1737
  047F2A  192A: f6469e20         test byte ptr [bp - 0x62], 0x20
  047F2E  192E: 7408             je 0x1938
  047F30  1930: 8b46d2           mov ax, word ptr [bp - 0x2e]
  047F33  1933: d1e0             shl ax, 1
  047F35  1935: 2946dc           sub word ptr [bp - 0x24], ax
  047F38  1938: 6a05             push 5
  047F3A  193A: 6a01             push 1
  047F3C  193C: 9ad4041f18       lcall 0x181f, 0x4d4
  047F41  1941: 83c404           add sp, 4
  047F44  1944: 0146dc           add word ptr [bp - 0x24], ax
  047F47  1947: 8b46dc           mov ax, word ptr [bp - 0x24]
  047F4A  194A: 0bc0             or ax, ax
  047F4C  194C: 7d02             jge 0x1950
  047F4E  194E: 2bc0             sub ax, ax
  047F50  1950: 8946dc           mov word ptr [bp - 0x24], ax
  047F53  1953: 837e8600         cmp word ptr [bp - 0x7a], 0
  047F57  1957: 7411             je 0x196a
  047F59  1959: 6a0f             push 0xf
  047F5B  195B: 50               push ax
  047F5C  195C: ff76e8           push word ptr [bp - 0x18]
  047F5F  195F: ff76f6           push word ptr [bp - 0xa]
  047F62  1962: 9a2c011f19       lcall 0x191f, 0x12c
  047F67  1967: 83c408           add sp, 8
  047F6A  196A: 8b8672ff         mov ax, word ptr [bp - 0x8e]
  047F6E  196E: 3946dc           cmp word ptr [bp - 0x24], ax
  047F71  1971: 7f03             jg 0x1976
  047F73  1973: e914f4           jmp 0xd8a
  047F76  1976: 8b46dc           mov ax, word ptr [bp - 0x24]
  047F79  1979: 898672ff         mov word ptr [bp - 0x8e], ax
  047F7D  197D: 8b46cc           mov ax, word ptr [bp - 0x34]
  047F80  1980: 8946b8           mov word ptr [bp - 0x48], ax
  047F83  1983: 8b46ce           mov ax, word ptr [bp - 0x32]
  047F86  1986: 89867eff         mov word ptr [bp - 0x82], ax
  047F8A  198A: e9fdf3           jmp 0xd8a
  047F8D  198D: 90               nop 
  047F8E  198E: 837e8600         cmp word ptr [bp - 0x7a], 0
  047F92  1992: 7405             je 0x1999
  047F94  1994: 9ae0031f18       lcall 0x181f, 0x3e0
  047F99  1999: 8a46b8           mov al, byte ptr [bp - 0x48]
  047F9C  199C: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  047FA0  19A0: 88874f31         mov byte ptr [bx + 0x314f], al
  047FA4  19A4: 837eb808         cmp word ptr [bp - 0x48], 8
  047FA8  19A8: 7403             je 0x19ad
  047FAA  19AA: e9a100           jmp 0x1a4e
  047FAD  19AD: 80bf4c3105       cmp byte ptr [bx + 0x314c], 5
  047FB2  19B2: 7407             je 0x19bb
  047FB4  19B4: 80bf4c3106       cmp byte ptr [bx + 0x314c], 6
  047FB9  19B9: 750b             jne 0x19c6
  047FBB  19BB: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  047FBF  19BF: c6874c3106       mov byte ptr [bx + 0x314c], 6
  047FC4  19C4: eb09             jmp 0x19cf
  047FC6  19C6: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  047FCA  19CA: c6874c3105       mov byte ptr [bx + 0x314c], 5
  047FCF  19CF: ff769c           push word ptr [bp - 0x64]
  047FD2  19D2: ff76aa           push word ptr [bp - 0x56]
  047FD5  19D5: 9abe061f18       lcall 0x181f, 0x6be
  047FDA  19DA: 83c404           add sp, 4
  047FDD  19DD: 3b866cff         cmp ax, word ptr [bp - 0x94]
  047FE1  19E1: 7574             jne 0x1a57
  047FE3  19E3: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  047FE7  19E7: 807f0700         cmp byte ptr [bx + 7], 0
  047FEB  19EB: 7e35             jle 0x1a22
  047FED  19ED: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  047FF1  19F1: 80bf463113       cmp byte ptr [bx + 0x3146], 0x13
  047FF6  19F6: 7407             je 0x19ff
  047FF8  19F8: 80bf463115       cmp byte ptr [bx + 0x3146], 0x15
  047FFD  19FD: 7523             jne 0x1a22
  047FFF  19FF: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  048003  1A03: fe874631         inc byte ptr [bx + 0x3146]
  048007  1A07: a0a653           mov al, byte ptr [0x53a6]
  04800A  1A0A: 2ae4             sub ah, ah
  04800C  1A0C: 50               push ax
  04800D  1A0D: 6a00             push 0
  04800F  1A0F: 9ad4041f18       lcall 0x181f, 0x4d4
  048014  1A14: 83c404           add sp, 4
  048017  1A17: 0bc0             or ax, ax
  048019  1A19: 7507             jne 0x1a22
  04801B  1A1B: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04801F  1A1F: fe4f07           dec byte ptr [bx + 7]
  048022  1A22: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  048026  1A26: 837f0a19         cmp word ptr [bx + 0xa], 0x19
  04802A  1A2A: 7c2b             jl 0x1a57
  04802C  1A2C: ff7606           push word ptr [bp + 6]
  04802F  1A2F: 9a0c091f18       lcall 0x181f, 0x90c
  048034  1A34: 83c402           add sp, 2
  048037  1A37: 3c03             cmp al, 3
  048039  1A39: 771c             ja 0x1a57
  04803B  1A3B: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04803F  1A3F: 8087463102       add byte ptr [bx + 0x3146], 2
  048044  1A44: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  048048  1A48: 836f0a19         sub word ptr [bx + 0xa], 0x19
  04804C  1A4C: eb09             jmp 0x1a57
  04804E  1A4E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  048052  1A52: c6874c3100       mov byte ptr [bx + 0x314c], 0
  048057  1A57: f6867eff0a       test byte ptr [bp - 0x82], 0xa
  04805C  1A5C: 7451             je 0x1aaf
  04805E  1A5E: 8b5eb8           mov bx, word ptr [bp - 0x48]
  048061  1A61: 8a87be00         mov al, byte ptr [bx + 0xbe]
  048065  1A65: 98               cwde 
  048066  1A66: 03469c           add ax, word ptr [bp - 0x64]
  048069  1A69: 8946e8           mov word ptr [bp - 0x18], ax
  04806C  1A6C: 50               push ax
  04806D  1A6D: 8a87b400         mov al, byte ptr [bx + 0xb4]
  048071  1A71: 98               cwde 
  048072  1A72: 0346aa           add ax, word ptr [bp - 0x56]
  048075  1A75: 8946f6           mov word ptr [bp - 0xa], ax
  048078  1A78: 50               push ax
  048079  1A79: 9adc061f18       lcall 0x181f, 0x6dc
  04807E  1A7E: 83c404           add sp, 4
  048081  1A81: 98               cwde 
  048082  1A82: 8946fa           mov word ptr [bp - 6], ax
  048085  1A85: 8bf0             mov si, ax
  048087  1A87: d1e6             shl si, 1
  048089  1A89: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04808D  1A8D: 83782e02         cmp word ptr [bx + si + 0x2e], 2
  048091  1A91: 7513             jne 0x1aa6
  048093  1A93: c746b80800       mov word ptr [bp - 0x48], 8
  048098  1A98: ff7606           push word ptr [bp + 6]
  04809B  1A9B: 9a34091f18       lcall 0x181f, 0x934
  0480A0  1AA0: 83c402           add sp, 2
  0480A3  1AA3: e92002           jmp 0x1cc6
  0480A6  1AA6: 8bf0             mov si, ax
  0480A8  1AA8: d1e6             shl si, 1
  0480AA  1AAA: c7402e0100       mov word ptr [bx + si + 0x2e], 1
  0480AF  1AAF: 8a867eff         mov al, byte ptr [bp - 0x82]
  0480B3  1AB3: 254000           and ax, 0x40
  0480B6  1AB6: 8946ec           mov word ptr [bp - 0x14], ax
  0480B9  1AB9: 8a867eff         mov al, byte ptr [bp - 0x82]
  0480BD  1ABD: 250400           and ax, 4
  0480C0  1AC0: 894692           mov word ptr [bp - 0x6e], ax
  0480C3  1AC3: 8a867eff         mov al, byte ptr [bp - 0x82]
  0480C7  1AC7: 250200           and ax, 2
  0480CA  1ACA: 8946b0           mov word ptr [bp - 0x50], ax
  0480CD  1ACD: 0bc0             or ax, ax
  0480CF  1ACF: 7507             jne 0x1ad8
  0480D1  1AD1: f6867eff08       test byte ptr [bp - 0x82], 8
  0480D6  1AD6: 741e             je 0x1af6
  0480D8  1AD8: ff7606           push word ptr [bp + 6]
  0480DB  1ADB: 9a0c091f18       lcall 0x181f, 0x90c
  0480E0  1AE0: 83c402           add sp, 2
  0480E3  1AE3: 2ae4             sub ah, ah
  0480E5  1AE5: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0480E9  1AE9: 8a8f4931         mov cl, byte ptr [bx + 0x3149]
  0480ED  1AED: 2aed             sub ch, ch
  0480EF  1AEF: 2bc1             sub ax, cx
  0480F1  1AF1: 3d0300           cmp ax, 3
  0480F4  1AF4: 7c9d             jl 0x1a93
  0480F6  1AF6: f6867eff08       test byte ptr [bp - 0x82], 8
  0480FB  1AFB: 7503             jne 0x1b00
  0480FD  1AFD: e99100           jmp 0x1b91
  048100  1B00: 837efa04         cmp word ptr [bp - 6], 4
  048104  1B04: 7c03             jl 0x1b09
  048106  1B06: e98800           jmp 0x1b91
  048109  1B09: 6b5efa34         imul bx, word ptr [bp - 6], 0x34
  04810D  1B0D: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  048112  1B12: 757d             jne 0x1b91
  048114  1B14: 6aff             push -1
  048116  1B16: ff76fa           push word ptr [bp - 6]
  048119  1B19: ff76e8           push word ptr [bp - 0x18]
  04811C  1B1C: ff76f6           push word ptr [bp - 0xa]
  04811F  1B1F: 9a14061f18       lcall 0x181f, 0x614
  048124  1B24: 83c408           add sp, 8
  048127  1B27: 89866eff         mov word ptr [bp - 0x92], ax
  04812B  1B2B: 0bc0             or ax, ax
  04812D  1B2D: 7c62             jl 0x1b91
  04812F  1B2F: 6a00             push 0
  048131  1B31: ff76e8           push word ptr [bp - 0x18]
  048134  1B34: ff76f6           push word ptr [bp - 0xa]
  048137  1B37: ff76e8           push word ptr [bp - 0x18]
  04813A  1B3A: ff76f6           push word ptr [bp - 0xa]
  04813D  1B3D: 9a52031f18       lcall 0x181f, 0x352
  048142  1B42: 83c40a           add sp, 0xa
  048145  1B45: ffb66cff         push word ptr [bp - 0x94]
  048149  1B49: 9a1a0a1f18       lcall 0x181f, 0xa1a
  04814E  1B4E: 83c402           add sp, 2
  048151  1B51: 50               push ax
  048152  1B52: 6a00             push 0
  048154  1B54: 9a38041f18       lcall 0x181f, 0x438
  048159  1B59: 83c404           add sp, 4
  04815C  1B5C: a14285           mov ax, word ptr [0x8542]
  04815F  1B5F: 40               inc ax
  048160  1B60: 40               inc ax
  048161  1B61: 1e               push ds
  048162  1B62: 50               push ax
  048163  1B63: 6a01             push 1
  048165  1B65: 9a16041f18       lcall 0x181f, 0x416
  04816A  1B6A: 83c406           add sp, 6
  04816D  1B6D: ffb66cff         push word ptr [bp - 0x94]
  048171  1B71: 9aa4091f18       lcall 0x181f, 0x9a4
  048176  1B76: 83c402           add sp, 2
  048179  1B79: 50               push ax
  04817A  1B7A: 6a02             push 2
  04817C  1B7C: 9a38041f18       lcall 0x181f, 0x438
  048181  1B81: 83c404           add sp, 4
  048184  1B84: 6a01             push 1
  048186  1B86: 68dc14           push 0x14dc
  048189  1B89: 9a52061f18       lcall 0x181f, 0x652
  04818E  1B8E: 83c404           add sp, 4
  048191  1B91: f6867eff0a       test byte ptr [bp - 0x82], 0xa
  048196  1B96: 7506             jne 0x1b9e
  048198  1B98: 837e9200         cmp word ptr [bp - 0x6e], 0
  04819C  1B9C: 740e             je 0x1bac
  04819E  1B9E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0481A2  1BA2: 80a74831f7       and byte ptr [bx + 0x3148], 0xf7
  0481A7  1BA7: 80a67eff7f       and byte ptr [bp - 0x82], 0x7f
  0481AC  1BAC: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0481B0  1BB0: f687483108       test byte ptr [bx + 0x3148], 8
  0481B5  1BB5: 7421             je 0x1bd8
  0481B7  1BB7: 80a74831f7       and byte ptr [bx + 0x3148], 0xf7
  0481BC  1BBC: 8a874531         mov al, byte ptr [bx + 0x3145]
  0481C0  1BC0: 2ae4             sub ah, ah
  0481C2  1BC2: 50               push ax
  0481C3  1BC3: 8a874431         mov al, byte ptr [bx + 0x3144]
  0481C7  1BC7: 50               push ax
  0481C8  1BC8: ff7606           push word ptr [bp + 6]
  0481CB  1BCB: 9a92011f1a       lcall 0x1a1f, 0x192
  0481D0  1BD0: 83c406           add sp, 6
  0481D3  1BD3: e9bdfe           jmp 0x1a93
  0481D6  1BD6: 90               nop 
  0481D7  1BD7: 90               nop 
  0481D8  1BD8: f6867eff80       test byte ptr [bp - 0x82], 0x80
  0481DD  1BDD: 7410             je 0x1bef
  0481DF  1BDF: a18e53           mov ax, word ptr [0x538e]
  0481E2  1BE2: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0481E6  1BE6: 89875631         mov word ptr [bx + 0x3156], ax
  0481EA  1BEA: 808f483108       or byte ptr [bx + 0x3148], 8
  0481EF  1BEF: f6867eff8a       test byte ptr [bp - 0x82], 0x8a
  0481F4  1BF4: 7403             je 0x1bf9
  0481F6  1BF6: e9b100           jmp 0x1caa
  0481F9  1BF9: 837eba00         cmp word ptr [bp - 0x46], 0
  0481FD  1BFD: 7d03             jge 0x1c02
  0481FF  1BFF: e9a800           jmp 0x1caa
  048202  1C02: 699e6effca00     imul bx, word ptr [bp - 0x92], 0xca
  048208  1C08: 8bc3             mov ax, bx
  04820A  1C0A: 8a9f605d         mov bl, byte ptr [bx + 0x5d60]
  04820E  1C0E: 2aff             sub bh, bh
  048210  1C10: 8a8f1094         mov cl, byte ptr [bx - 0x6bf0]
  048214  1C14: c0e903           shr cl, 3
  048217  1C17: 2aed             sub ch, ch
  048219  1C19: 8b56ba           mov dx, word ptr [bp - 0x46]
  04821C  1C1C: c1e202           shl dx, 2
  04821F  1C1F: 03ca             add cx, dx
  048221  1C21: 83c10a           add cx, 0xa
  048224  1C24: 8b5684           mov dx, word ptr [bp - 0x7c]
  048227  1C27: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04822B  1C2B: 2b975631         sub dx, word ptr [bx + 0x3156]
  04822F  1C2F: 3bca             cmp cx, dx
  048231  1C31: 7f77             jg 0x1caa
  048233  1C33: 8bf0             mov si, ax
  048235  1C35: 8a8c465d         mov cl, byte ptr [si + 0x5d46]
  048239  1C39: 888f4d31         mov byte ptr [bx + 0x314d], cl
  04823D  1C3D: 8a8c475d         mov cl, byte ptr [si + 0x5d47]
  048241  1C41: 888f4e31         mov byte ptr [bx + 0x314e], cl
  048245  1C45: 8b4606           mov ax, word ptr [bp + 6]
  048248  1C48: 9a10021f1a       lcall 0x1a1f, 0x210
  04824D  1C4D: 89866aff         mov word ptr [bp - 0x96], ax
  048251  1C51: 0bc0             or ax, ax
  048253  1C53: 7c55             jl 0x1caa
  048255  1C55: 8bd8             mov bx, ax
  048257  1C57: 8a87b400         mov al, byte ptr [bx + 0xb4]
  04825B  1C5B: 98               cwde 
  04825C  1C5C: 0346aa           add ax, word ptr [bp - 0x56]
  04825F  1C5F: 8946fe           mov word ptr [bp - 2], ax
  048262  1C62: 8bd0             mov dx, ax
  048264  1C64: 8a87be00         mov al, byte ptr [bx + 0xbe]
  048268  1C68: 98               cwde 
  048269  1C69: 03469c           add ax, word ptr [bp - 0x64]
  04826C  1C6C: 8946f0           mov word ptr [bp - 0x10], ax
  04826F  1C6F: 50               push ax
  048270  1C70: 52               push dx
  048271  1C71: 9abe061f18       lcall 0x181f, 0x6be
  048276  1C76: 83c404           add sp, 4
  048279  1C79: 8946a4           mov word ptr [bp - 0x5c], ax
  04827C  1C7C: 0bc0             or ax, ax
  04827E  1C7E: 7c06             jl 0x1c86
  048280  1C80: 3b866cff         cmp ax, word ptr [bp - 0x94]
  048284  1C84: 7524             jne 0x1caa
  048286  1C86: ff76f0           push word ptr [bp - 0x10]
  048289  1C89: ff76fe           push word ptr [bp - 2]
  04828C  1C8C: 9a82061f18       lcall 0x181f, 0x682
  048291  1C91: 83c404           add sp, 4
  048294  1C94: 89468c           mov word ptr [bp - 0x74], ax
  048297  1C97: 0bc0             or ax, ax
  048299  1C99: 7c06             jl 0x1ca1
  04829B  1C9B: 3b866cff         cmp ax, word ptr [bp - 0x94]
  04829F  1C9F: 7509             jne 0x1caa
  0482A1  1CA1: 8b866aff         mov ax, word ptr [bp - 0x96]
  0482A5  1CA5: 8946b8           mov word ptr [bp - 0x48], ax
  0482A8  1CA8: eb1c             jmp 0x1cc6
  0482AA  1CAA: f6867eff1a       test byte ptr [bp - 0x82], 0x1a
  0482AF  1CAF: 7515             jne 0x1cc6
  0482B1  1CB1: f6867eff01       test byte ptr [bp - 0x82], 1
  0482B6  1CB6: 740e             je 0x1cc6
  0482B8  1CB8: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0482BC  1CBC: 80bf493100       cmp byte ptr [bx + 0x3149], 0
  0482C1  1CC1: 7403             je 0x1cc6
  0482C3  1CC3: e9cdfd           jmp 0x1a93
  0482C6  1CC6: 837eb808         cmp word ptr [bp - 0x48], 8
  0482CA  1CCA: 750b             jne 0x1cd7
  0482CC  1CCC: ff7606           push word ptr [bp + 6]
  0482CF  1CCF: 9a34091f18       lcall 0x181f, 0x934
  0482D4  1CD4: 83c402           add sp, 2
  0482D7  1CD7: 8b46b8           mov ax, word ptr [bp - 0x48]
  0482DA  1CDA: 5e               pop si
  0482DB  1CDB: c9               leave 
  0482DC  1CDC: cb               retf 

; ---- func_0482DE  size=48  insns=20  prologue=ENTER 0x0002,0  terminal=RETF ----
  0482DE  1CDE: c8020000         enter 2, 0
  0482E2  1CE2: ff7606           push word ptr [bp + 6]
  0482E5  1CE5: 0e               push cs
  0482E6  1CE6: e83237           call 0x541b
  0482E9  1CE9: 83c402           add sp, 2
  0482EC  1CEC: 3d0800           cmp ax, 8
  0482EF  1CEF: 740f             je 0x1d00
  0482F1  1CF1: 50               push ax
  0482F2  1CF2: ff7606           push word ptr [bp + 6]
  0482F5  1CF5: 9a50011f1a       lcall 0x1a1f, 0x150
  0482FA  1CFA: 83c404           add sp, 4
  0482FD  1CFD: c9               leave 
  0482FE  1CFE: cb               retf 
  0482FF  1CFF: 90               nop 
  048300  1D00: 0bc0             or ax, ax
  048302  1D02: 7c08             jl 0x1d0c
  048304  1D04: ff7606           push word ptr [bp + 6]
  048307  1D07: 9a34091f18       lcall 0x181f, 0x934
  04830C  1D0C: c9               leave 
  04830D  1D0D: cb               retf 

; ---- func_04830E  size=743  insns=259  prologue=ENTER 0x0018,0  terminal=RETF ----
  04830E  1D0E: c8180000         enter 0x18, 0
  048312  1D12: 56               push si
  048313  1D13: c746ec0000       mov word ptr [bp - 0x14], 0
  048318  1D18: ff7606           push word ptr [bp + 6]
  04831B  1D1B: 9a4c0a1f18       lcall 0x181f, 0xa4c
  048320  1D20: 83c402           add sp, 2
  048323  1D23: ff7606           push word ptr [bp + 6]
  048326  1D26: 0e               push cs
  048327  1D27: e80a37           call 0x5434
  04832A  1D2A: 83c402           add sp, 2
  04832D  1D2D: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  048331  1D31: 3a4704           cmp al, byte ptr [bx + 4]
  048334  1D34: 7605             jbe 0x1d3b
  048336  1D36: c746ec0200       mov word ptr [bp - 0x14], 2
  04833B  1D3B: f6470301         test byte ptr [bx + 3], 1
  04833F  1D3F: 7405             je 0x1d46
  048341  1D41: c746ec0100       mov word ptr [bp - 0x14], 1
  048346  1D46: 837eec00         cmp word ptr [bp - 0x14], 0
  04834A  1D4A: 7503             jne 0x1d4f
  04834C  1D4C: e99300           jmp 0x1de2
  04834F  1D4F: 8a4704           mov al, byte ptr [bx + 4]
  048352  1D52: 004706           add byte ptr [bx + 6], al
  048355  1D55: 807f0614         cmp byte ptr [bx + 6], 0x14
  048359  1D59: 7d03             jge 0x1d5e
  04835B  1D5B: e98400           jmp 0x1de2
  04835E  1D5E: c6470600         mov byte ptr [bx + 6], 0
  048362  1D62: 837eec02         cmp word ptr [bp - 0x14], 2
  048366  1D66: 7506             jne 0x1d6e
  048368  1D68: fe4704           inc byte ptr [bx + 4]
  04836B  1D6B: eb75             jmp 0x1de2
  04836D  1D6D: 90               nop 
  04836E  1D6E: c746fe1300       mov word ptr [bp - 2], 0x13
  048373  1D73: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  048377  1D77: 807f0700         cmp byte ptr [bx + 7], 0
  04837B  1D7B: 7e1e             jle 0x1d9b
  04837D  1D7D: a0a653           mov al, byte ptr [0x53a6]
  048380  1D80: 2ae4             sub ah, ah
  048382  1D82: 50               push ax
  048383  1D83: 6a00             push 0
  048385  1D85: 9ad4041f18       lcall 0x181f, 0x4d4
  04838A  1D8A: 83c404           add sp, 4
  04838D  1D8D: 0bc0             or ax, ax
  04838F  1D8F: 7507             jne 0x1d98
  048391  1D91: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  048395  1D95: fe4f07           dec byte ptr [bx + 7]
  048398  1D98: ff46fe           inc word ptr [bp - 2]
  04839B  1D9B: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04839F  1D9F: 837f0a32         cmp word ptr [bx + 0xa], 0x32
  0483A3  1DA3: 7c08             jl 0x1dad
  0483A5  1DA5: 836f0a32         sub word ptr [bx + 0xa], 0x32
  0483A9  1DA9: 8346fe02         add word ptr [bp - 2], 2
  0483AD  1DAD: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  0483B1  1DB1: 8a4701           mov al, byte ptr [bx + 1]
  0483B4  1DB4: 2ae4             sub ah, ah
  0483B6  1DB6: 50               push ax
  0483B7  1DB7: 8a07             mov al, byte ptr [bx]
  0483B9  1DB9: 50               push ax
  0483BA  1DBA: 8a4702           mov al, byte ptr [bx + 2]
  0483BD  1DBD: 50               push ax
  0483BE  1DBE: ff76fe           push word ptr [bp - 2]
  0483C1  1DC1: 9a5c091f18       lcall 0x181f, 0x95c
  0483C6  1DC6: 83c408           add sp, 8
  0483C9  1DC9: 8946f0           mov word ptr [bp - 0x10], ax
  0483CC  1DCC: 0bc0             or ax, ax
  0483CE  1DCE: 7c12             jl 0x1de2
  0483D0  1DD0: 6bd81c           imul bx, ax, 0x1c
  0483D3  1DD3: 8a4606           mov al, byte ptr [bp + 6]
  0483D6  1DD6: 88874a31         mov byte ptr [bx + 0x314a], al
  0483DA  1DDA: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  0483DE  1DDE: 806703fe         and byte ptr [bx + 3], 0xfe
  0483E2  1DE2: f606825301       test byte ptr [0x5382], 1
  0483E7  1DE7: 7403             je 0x1dec
  0483E9  1DE9: e98200           jmp 0x1e6e
  0483EC  1DEC: c746ee0000       mov word ptr [bp - 0x12], 0
  0483F1  1DF1: eb35             jmp 0x1e28
  0483F3  1DF3: 90               nop 
  0483F4  1DF4: b80c00           mov ax, 0xc
  0483F7  1DF7: 2b46e8           sub ax, word ptr [bp - 0x18]
  0483FA  1DFA: 50               push ax
  0483FB  1DFB: 6a00             push 0
  0483FD  1DFD: 9ad4041f18       lcall 0x181f, 0x4d4
  048402  1E02: 83c404           add sp, 4
  048405  1E05: 0bc0             or ax, ax
  048407  1E07: 7503             jne 0x1e0c
  048409  1E09: ff46fa           inc word ptr [bp - 6]
  04840C  1E0C: ff46f4           inc word ptr [bp - 0xc]
  04840F  1E0F: 8b46e8           mov ax, word ptr [bp - 0x18]
  048412  1E12: 40               inc ax
  048413  1E13: 3b46f4           cmp ax, word ptr [bp - 0xc]
  048416  1E16: 7fdc             jg 0x1df4
  048418  1E18: 8a46fa           mov al, byte ptr [bp - 6]
  04841B  1E1B: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04841F  1E1F: 8b76ee           mov si, word ptr [bp - 0x12]
  048422  1E22: 004036           add byte ptr [bx + si + 0x36], al
  048425  1E25: ff46ee           inc word ptr [bp - 0x12]
  048428  1E28: 837eee04         cmp word ptr [bp - 0x12], 4
  04842C  1E2C: 7d40             jge 0x1e6e
  04842E  1E2E: ff36508d         push word ptr [0x8d50]
  048432  1E32: ff76ee           push word ptr [bp - 0x12]
  048435  1E35: 9a380a1f18       lcall 0x181f, 0xa38
  04843A  1E3A: 83c404           add sp, 4
  04843D  1E3D: a820             test al, 0x20
  04843F  1E3F: 74e4             je 0x1e25
  048441  1E41: ff76ee           push word ptr [bp - 0x12]
  048444  1E44: ff36528d         push word ptr [0x8d52]
  048448  1E48: 9a0c031f18       lcall 0x181f, 0x30c
  04844D  1E4D: 83c404           add sp, 4
  048450  1E50: 8946ea           mov word ptr [bp - 0x16], ax
  048453  1E53: 50               push ax
  048454  1E54: 9a600a1f18       lcall 0x181f, 0xa60
  048459  1E59: 83c402           add sp, 2
  04845C  1E5C: 8946e8           mov word ptr [bp - 0x18], ax
  04845F  1E5F: f7e8             imul ax
  048461  1E61: 8946e8           mov word ptr [bp - 0x18], ax
  048464  1E64: 2bc0             sub ax, ax
  048466  1E66: 8946fa           mov word ptr [bp - 6], ax
  048469  1E69: 8946f4           mov word ptr [bp - 0xc], ax
  04846C  1E6C: eba1             jmp 0x1e0f
  04846E  1E6E: 8d46fc           lea ax, [bp - 4]
  048471  1E71: 50               push ax
  048472  1E72: ff364c8d         push word ptr [0x8d4c]
  048476  1E76: 9a16031f18       lcall 0x181f, 0x316
  04847B  1E7B: 83c404           add sp, 4
  04847E  1E7E: 8946ee           mov word ptr [bp - 0x12], ax
  048481  1E81: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  048485  1E85: 8a4705           mov al, byte ptr [bx + 5]
  048488  1E88: 98               cwde 
  048489  1E89: 8946f2           mov word ptr [bp - 0xe], ax
  04848C  1E8C: 0bc0             or ax, ax
  04848E  1E8E: 7c06             jl 0x1e96
  048490  1E90: 250f00           and ax, 0xf
  048493  1E93: 8946f2           mov word ptr [bp - 0xe], ax
  048496  1E96: 0bc0             or ax, ax
  048498  1E98: 7d09             jge 0x1ea3
  04849A  1E9A: 837eee00         cmp word ptr [bp - 0x12], 0
  04849E  1E9E: 7d03             jge 0x1ea3
  0484A0  1EA0: e91901           jmp 0x1fbc
  0484A3  1EA3: 8a4703           mov al, byte ptr [bx + 3]
  0484A6  1EA6: 2404             and al, 4
  0484A8  1EA8: 3c01             cmp al, 1
  0484AA  1EAA: 1bc0             sbb ax, ax
  0484AC  1EAC: 40               inc ax
  0484AD  1EAD: 8946f8           mov word ptr [bp - 8], ax
  0484B0  1EB0: 837ef200         cmp word ptr [bp - 0xe], 0
  0484B4  1EB4: 7c68             jl 0x1f1e
  0484B6  1EB6: 8bc8             mov cx, ax
  0484B8  1EB8: 8a4705           mov al, byte ptr [bx + 5]
  0484BB  1EBB: 2410             and al, 0x10
  0484BD  1EBD: 3c01             cmp al, 1
  0484BF  1EBF: 1bc0             sbb ax, ax
  0484C1  1EC1: 24fd             and al, 0xfd
  0484C3  1EC3: 050400           add ax, 4
  0484C6  1EC6: d3e0             shl ax, cl
  0484C8  1EC8: 8946fa           mov word ptr [bp - 6], ax
  0484CB  1ECB: 6a18             push 0x18
  0484CD  1ECD: ff76f2           push word ptr [bp - 0xe]
  0484D0  1ED0: 9ab4071f18       lcall 0x181f, 0x7b4
  0484D5  1ED5: 83c404           add sp, 4
  0484D8  1ED8: 0bc0             or ax, ax
  0484DA  1EDA: 7403             je 0x1edf
  0484DC  1EDC: d166fa           shl word ptr [bp - 6], 1
  0484DF  1EDF: 6a17             push 0x17
  0484E1  1EE1: ff76f2           push word ptr [bp - 0xe]
  0484E4  1EE4: 9ab4071f18       lcall 0x181f, 0x7b4
  0484E9  1EE9: 83c404           add sp, 4
  0484EC  1EEC: 0bc0             or ax, ax
  0484EE  1EEE: 7403             je 0x1ef3
  0484F0  1EF0: d17efa           sar word ptr [bp - 6], 1
  0484F3  1EF3: 8a46fa           mov al, byte ptr [bp - 6]
  0484F6  1EF6: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0484FA  1EFA: 8b76f2           mov si, word ptr [bp - 0xe]
  0484FD  1EFD: 004036           add byte ptr [bx + si + 0x36], al
  048500  1F00: 8b46fa           mov ax, word ptr [bp - 6]
  048503  1F03: 8bc8             mov cx, ax
  048505  1F05: d1e0             shl ax, 1
  048507  1F07: 03c1             add ax, cx
  048509  1F09: d1e6             shl si, 1
  04850B  1F0B: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04850F  1F0F: 29400a           sub word ptr [bx + si + 0xa], ax
  048512  1F12: 8b400a           mov ax, word ptr [bx + si + 0xa]
  048515  1F15: 0bc0             or ax, ax
  048517  1F17: 7d02             jge 0x1f1b
  048519  1F19: 2bc0             sub ax, ax
  04851B  1F1B: 89400a           mov word ptr [bx + si + 0xa], ax
  04851E  1F1E: 837eee00         cmp word ptr [bp - 0x12], 0
  048522  1F22: 7c44             jl 0x1f68
  048524  1F24: 8a4ef8           mov cl, byte ptr [bp - 8]
  048527  1F27: 8b46fc           mov ax, word ptr [bp - 4]
  04852A  1F2A: d3e0             shl ax, cl
  04852C  1F2C: 8946f6           mov word ptr [bp - 0xa], ax
  04852F  1F2F: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  048533  1F33: 8b76ee           mov si, word ptr [bp - 0x12]
  048536  1F36: 284036           sub byte ptr [bx + si + 0x36], al
  048539  1F39: 3b76f2           cmp si, word ptr [bp - 0xe]
  04853C  1F3C: 7503             jne 0x1f41
  04853E  1F3E: d17ef6           sar word ptr [bp - 0xa], 1
  048541  1F41: ff76ee           push word ptr [bp - 0x12]
  048544  1F44: ff36528d         push word ptr [0x8d52]
  048548  1F48: 9a0c031f18       lcall 0x181f, 0x30c
  04854D  1F4D: 83c404           add sp, 4
  048550  1F50: b90500           mov cx, 5
  048553  1F53: 99               cdq 
  048554  1F54: f7f9             idiv cx
  048556  1F56: 0146f6           add word ptr [bp - 0xa], ax
  048559  1F59: 8b46f6           mov ax, word ptr [bp - 0xa]
  04855C  1F5C: 8b76ee           mov si, word ptr [bp - 0x12]
  04855F  1F5F: d1e6             shl si, 1
  048561  1F61: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  048565  1F65: 01400a           add word ptr [bx + si + 0xa], ax
  048568  1F68: 837ef200         cmp word ptr [bp - 0xe], 0
  04856C  1F6C: 7c24             jl 0x1f92
  04856E  1F6E: eb15             jmp 0x1f85
  048570  1F70: 80683608         sub byte ptr [bx + si + 0x36], 8
  048574  1F74: 6a03             push 3
  048576  1F76: 6aff             push -1
  048578  1F78: 56               push si
  048579  1F79: ff36528d         push word ptr [0x8d52]
  04857D  1F7D: 9a6c0d1f18       lcall 0x181f, 0xd6c
  048582  1F82: 83c408           add sp, 8
  048585  1F85: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  048589  1F89: 8b76f2           mov si, word ptr [bp - 0xe]
  04858C  1F8C: 80783608         cmp byte ptr [bx + si + 0x36], 8
  048590  1F90: 7dde             jge 0x1f70
  048592  1F92: 837eee00         cmp word ptr [bp - 0x12], 0
  048596  1F96: 7c24             jl 0x1fbc
  048598  1F98: eb15             jmp 0x1faf
  04859A  1F9A: 80403608         add byte ptr [bx + si + 0x36], 8
  04859E  1F9E: 6a05             push 5
  0485A0  1FA0: 6a01             push 1
  0485A2  1FA2: 56               push si
  0485A3  1FA3: ff36528d         push word ptr [0x8d52]
  0485A7  1FA7: 9a6c0d1f18       lcall 0x181f, 0xd6c
  0485AC  1FAC: 83c408           add sp, 8
  0485AF  1FAF: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0485B3  1FB3: 8b76ee           mov si, word ptr [bp - 0x12]
  0485B6  1FB6: 807836f8         cmp byte ptr [bx + si + 0x36], 0xf8
  0485BA  1FBA: 7ede             jle 0x1f9a
  0485BC  1FBC: c746ee0000       mov word ptr [bp - 0x12], 0
  0485C1  1FC1: eb04             jmp 0x1fc7
  0485C3  1FC3: 90               nop 
  0485C4  1FC4: ff46ee           inc word ptr [bp - 0x12]
  0485C7  1FC7: 837eee04         cmp word ptr [bp - 0x12], 4
  0485CB  1FCB: 7d25             jge 0x1ff2
  0485CD  1FCD: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0485D1  1FD1: 8b76ee           mov si, word ptr [bp - 0x12]
  0485D4  1FD4: 80783608         cmp byte ptr [bx + si + 0x36], 8
  0485D8  1FD8: 7cea             jl 0x1fc4
  0485DA  1FDA: 80683608         sub byte ptr [bx + si + 0x36], 8
  0485DE  1FDE: 6a00             push 0
  0485E0  1FE0: 6aff             push -1
  0485E2  1FE2: 56               push si
  0485E3  1FE3: ff36528d         push word ptr [0x8d52]
  0485E7  1FE7: 9a6c0d1f18       lcall 0x181f, 0xd6c
  0485EC  1FEC: 83c408           add sp, 8
  0485EF  1FEF: ebdc             jmp 0x1fcd
  0485F1  1FF1: 90               nop 
  0485F2  1FF2: 5e               pop si
  0485F3  1FF3: c9               leave 
  0485F4  1FF4: cb               retf 

; ---- func_0485F6  size=804  insns=267  prologue=ENTER 0x000C,0  terminal=RETF ----
  0485F6  1FF6: c80c0000         enter 0xc, 0
  0485FA  1FFA: 56               push si
  0485FB  1FFB: c746f80000       mov word ptr [bp - 8], 0
  048600  2000: ff36a683         push word ptr [0x83a6]
  048604  2004: 9aca041f18       lcall 0x181f, 0x4ca
  048609  2009: 83c402           add sp, 2
  04860C  200C: 8b4606           mov ax, word ptr [bp + 6]
  04860F  200F: 050400           add ax, 4
  048612  2012: a39453           mov word ptr [0x5394], ax
  048615  2015: ff7606           push word ptr [bp + 6]
  048618  2018: 9a420a1f18       lcall 0x181f, 0xa42
  04861D  201D: 83c402           add sp, 2
  048620  2020: 8b5e06           mov bx, word ptr [bp + 6]
  048623  2023: 8a874c08         mov al, byte ptr [bx + 0x84c]
  048627  2027: 2ae4             sub ah, ah
  048629  2029: 50               push ax
  04862A  202A: 9a90051f18       lcall 0x181f, 0x590
  04862F  202F: 83c402           add sp, 2
  048632  2032: f606825301       test byte ptr [0x5382], 1
  048637  2037: 7503             jne 0x203c
  048639  2039: e91d01           jmp 0x2159
  04863C  203C: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  048640  2040: f6470320         test byte ptr [bx + 3], 0x20
  048644  2044: 7403             je 0x2049
  048646  2046: e91001           jmp 0x2159
  048649  2049: ff369853         push word ptr [0x5398]
  04864D  204D: ff7606           push word ptr [bp + 6]
  048650  2050: 9a0c031f18       lcall 0x181f, 0x30c
  048655  2055: 83c404           add sp, 4
  048658  2058: 8946f4           mov word ptr [bp - 0xc], ax
  04865B  205B: 3d1900           cmp ax, 0x19
  04865E  205E: 7c1a             jl 0x207a
  048660  2060: 689001           push 0x190
  048663  2063: 6a01             push 1
  048665  2065: 9ad4041f18       lcall 0x181f, 0x4d4
  04866A  206A: 83c404           add sp, 4
  04866D  206D: 3946f4           cmp word ptr [bp - 0xc], ax
  048670  2070: 7c08             jl 0x207a
  048672  2072: c746f60100       mov word ptr [bp - 0xa], 1
  048677  2077: eb06             jmp 0x207f
  048679  2079: 90               nop 
  04867A  207A: c746f60000       mov word ptr [bp - 0xa], 0
  04867F  207F: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  048683  2083: f6470340         test byte ptr [bx + 3], 0x40
  048687  2087: 7405             je 0x208e
  048689  2089: c746f60100       mov word ptr [bp - 0xa], 1
  04868E  208E: 837ef600         cmp word ptr [bp - 0xa], 0
  048692  2092: 7503             jne 0x2097
  048694  2094: e9c200           jmp 0x2159
  048697  2097: a0a653           mov al, byte ptr [0x53a6]
  04869A  209A: 2ae4             sub ah, ah
  04869C  209C: 2d0500           sub ax, 5
  04869F  209F: f7d8             neg ax
  0486A1  20A1: d1e0             shl ax, 1
  0486A3  20A3: 50               push ax
  0486A4  20A4: 6a00             push 0
  0486A6  20A6: 9ad4041f18       lcall 0x181f, 0x4d4
  0486AB  20AB: 83c404           add sp, 4
  0486AE  20AE: 0bc0             or ax, ax
  0486B0  20B0: 7403             je 0x20b5
  0486B2  20B2: e9a400           jmp 0x2159
  0486B5  20B5: ff36508d         push word ptr [0x8d50]
  0486B9  20B9: 9aa4091f18       lcall 0x181f, 0x9a4
  0486BE  20BE: 83c402           add sp, 2
  0486C1  20C1: 50               push ax
  0486C2  20C2: 6a00             push 0
  0486C4  20C4: 9a38041f18       lcall 0x181f, 0x438
  0486C9  20C9: 83c404           add sp, 4
  0486CC  20CC: ff36508d         push word ptr [0x8d50]
  0486D0  20D0: 9a1a0a1f18       lcall 0x181f, 0xa1a
  0486D5  20D5: 83c402           add sp, 2
  0486D8  20D8: 50               push ax
  0486D9  20D9: 6a01             push 1
  0486DB  20DB: 9a38041f18       lcall 0x181f, 0x438
  0486E0  20E0: 83c404           add sp, 4
  0486E3  20E3: 8d1ef614         lea bx, [0x14f6]
  0486E7  20E7: 9afe031f18       lcall 0x181f, 0x3fe
  0486EC  20EC: 6a00             push 0
  0486EE  20EE: 6a64             push 0x64
  0486F0  20F0: ff369853         push word ptr [0x5398]
  0486F4  20F4: ff36528d         push word ptr [0x8d52]
  0486F8  20F8: 9a6c0d1f18       lcall 0x181f, 0xd6c
  0486FD  20FD: 83c408           add sp, 8
  048700  2100: 6a00             push 0
  048702  2102: 6a9c             push -0x64
  048704  2104: ff36d253         push word ptr [0x53d2]
  048708  2108: ff36528d         push word ptr [0x8d52]
  04870C  210C: 9a6c0d1f18       lcall 0x181f, 0xd6c
  048711  2111: 83c408           add sp, 8
  048714  2114: ff369853         push word ptr [0x5398]
  048718  2118: ff36528d         push word ptr [0x8d52]
  04871C  211C: 9a98031f1a       lcall 0x1a1f, 0x398
  048721  2121: 83c404           add sp, 4
  048724  2124: 8b1e528d         mov bx, word ptr [0x8d52]
  048728  2128: 8a872a96         mov al, byte ptr [bx - 0x69d6]
  04872C  212C: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  048730  2130: 8bc8             mov cx, ax
  048732  2132: 3a4707           cmp al, byte ptr [bx + 7]
  048735  2135: 7e03             jle 0x213a
  048737  2137: 8a4707           mov al, byte ptr [bx + 7]
  04873A  213A: 884707           mov byte ptr [bx + 7], al
  04873D  213D: c0670702         shl byte ptr [bx + 7], 2
  048741  2141: 8ac1             mov al, cl
  048743  2143: 3a4708           cmp al, byte ptr [bx + 8]
  048746  2146: 7e03             jle 0x214b
  048748  2148: 8a4708           mov al, byte ptr [bx + 8]
  04874B  214B: 884708           mov byte ptr [bx + 8], al
  04874E  214E: b119             mov cl, 0x19
  048750  2150: f6e9             imul cl
  048752  2152: 89470a           mov word ptr [bx + 0xa], ax
  048755  2155: 804f0320         or byte ptr [bx + 3], 0x20
  048759  2159: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04875D  215D: 8a4707           mov al, byte ptr [bx + 7]
  048760  2160: 0ac0             or al, al
  048762  2162: 7d02             jge 0x2166
  048764  2164: 2ac0             sub al, al
  048766  2166: 884707           mov byte ptr [bx + 7], al
  048769  2169: c746fa0000       mov word ptr [bp - 6], 0
  04876E  216E: eb33             jmp 0x21a3
  048770  2170: a09453           mov al, byte ptr [0x5394]
  048773  2173: 6b5efa12         imul bx, word ptr [bp - 6], 0x12
  048777  2177: 3887ee54         cmp byte ptr [bx + 0x54ee], al
  04877B  217B: 7523             jne 0x21a0
  04877D  217D: 837ef800         cmp word ptr [bp - 8], 0
  048781  2181: 740e             je 0x2191
  048783  2183: ff76fa           push word ptr [bp - 6]
  048786  2186: 680315           push 0x1503
  048789  2189: 9a12071d0d       lcall 0xd1d, 0x712
  04878E  218E: 83c404           add sp, 4
  048791  2191: ff76fa           push word ptr [bp - 6]
  048794  2194: 0e               push cs
  048795  2195: e88832           call 0x5420
  048798  2198: 83c402           add sp, 2
  04879B  219B: 9a70041f18       lcall 0x181f, 0x470
  0487A0  21A0: ff46fa           inc word ptr [bp - 6]
  0487A3  21A3: a19a53           mov ax, word ptr [0x539a]
  0487A6  21A6: 3946fa           cmp word ptr [bp - 6], ax
  0487A9  21A9: 7cc5             jl 0x2170
  0487AB  21AB: c746fa0000       mov word ptr [bp - 6], 0
  0487B0  21B0: eb1e             jmp 0x21d0
  0487B2  21B2: 0bc0             or ax, ax
  0487B4  21B4: 7d17             jge 0x21cd
  0487B6  21B6: 8a4702           mov al, byte ptr [bx + 2]
  0487B9  21B9: 2ae4             sub ah, ah
  0487BB  21BB: 0346fe           add ax, word ptr [bp - 2]
  0487BE  21BE: 40               inc ax
  0487BF  21BF: 0bc0             or ax, ax
  0487C1  21C1: 7e02             jle 0x21c5
  0487C3  21C3: 2bc0             sub ax, ax
  0487C5  21C5: 8b76fa           mov si, word ptr [bp - 6]
  0487C8  21C8: d1e6             shl si, 1
  0487CA  21CA: 89400e           mov word ptr [bx + si + 0xe], ax
  0487CD  21CD: ff46fa           inc word ptr [bp - 6]
  0487D0  21D0: 837efa10         cmp word ptr [bp - 6], 0x10
  0487D4  21D4: 7d22             jge 0x21f8
  0487D6  21D6: 8b76fa           mov si, word ptr [bp - 6]
  0487D9  21D9: d1e6             shl si, 1
  0487DB  21DB: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0487DF  21DF: 8b400e           mov ax, word ptr [bx + si + 0xe]
  0487E2  21E2: 8946fe           mov word ptr [bp - 2], ax
  0487E5  21E5: 0bc0             or ax, ax
  0487E7  21E7: 7ec9             jle 0x21b2
  0487E9  21E9: 8a4f02           mov cl, byte ptr [bx + 2]
  0487EC  21EC: 2aed             sub ch, ch
  0487EE  21EE: 2bc1             sub ax, cx
  0487F0  21F0: 48               dec ax
  0487F1  21F1: 79d7             jns 0x21ca
  0487F3  21F3: 2bc0             sub ax, ax
  0487F5  21F5: ebd3             jmp 0x21ca
  0487F7  21F7: 90               nop 
  0487F8  21F8: 837ef800         cmp word ptr [bp - 8], 0
  0487FC  21FC: 740b             je 0x2209
  0487FE  21FE: 680f15           push 0x150f
  048801  2201: 9a12071d0d       lcall 0xd1d, 0x712
  048806  2206: 83c402           add sp, 2
  048809  2209: ff7606           push word ptr [bp + 6]
  04880C  220C: 9a70021f1a       lcall 0x1a1f, 0x270
  048811  2211: 83c402           add sp, 2
  048814  2214: 9a70041f18       lcall 0x181f, 0x470
  048819  2219: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04881D  221D: 807f0800         cmp byte ptr [bx + 8], 0
  048821  2221: 7421             je 0x2244
  048823  2223: 8a4708           mov al, byte ptr [bx + 8]
  048826  2226: 98               cwde 
  048827  2227: 01470a           add word ptr [bx + 0xa], ax
  04882A  222A: 8b470a           mov ax, word ptr [bx + 0xa]
  04882D  222D: 8b7606           mov si, word ptr [bp + 6]
  048830  2230: 8a8c2296         mov cl, byte ptr [si - 0x69de]
  048834  2234: 2aed             sub ch, ch
  048836  2236: 83c119           add cx, 0x19
  048839  2239: d1e1             shl cx, 1
  04883B  223B: 3bc1             cmp ax, cx
  04883D  223D: 7e02             jle 0x2241
  04883F  223F: 8bc1             mov ax, cx
  048841  2241: 89470a           mov word ptr [bx + 0xa], ax
  048844  2244: c746fa0000       mov word ptr [bp - 6], 0
  048849  2249: eb19             jmp 0x2264
  04884B  224B: 90               nop 
  04884C  224C: 6b5efa1c         imul bx, word ptr [bp - 6], 0x1c
  048850  2250: 8a874731         mov al, byte ptr [bx + 0x3147]
  048854  2254: 240f             and al, 0xf
  048856  2256: 3a069453         cmp al, byte ptr [0x5394]
  04885A  225A: 7505             jne 0x2261
  04885C  225C: c6875a3100       mov byte ptr [bx + 0x315a], 0
  048861  2261: ff46fa           inc word ptr [bp - 6]
  048864  2264: a19c53           mov ax, word ptr [0x539c]
  048867  2267: 3946fa           cmp word ptr [bp - 6], ax
  04886A  226A: 7ce0             jl 0x224c
  04886C  226C: 9a70041f18       lcall 0x181f, 0x470
  048871  2271: 2bc0             sub ax, ax
  048873  2273: 8946fc           mov word ptr [bp - 4], ax
  048876  2276: 8946fa           mov word ptr [bp - 6], ax
  048879  2279: eb3a             jmp 0x22b5
  04887B  227B: 90               nop 
  04887C  227C: 837ef800         cmp word ptr [bp - 8], 0
  048880  2280: 741e             je 0x22a0
  048882  2282: 6b5efa1c         imul bx, word ptr [bp - 6], 0x1c
  048886  2286: 8a874531         mov al, byte ptr [bx + 0x3145]
  04888A  228A: 2ae4             sub ah, ah
  04888C  228C: 50               push ax
  04888D  228D: 8a874431         mov al, byte ptr [bx + 0x3144]
  048891  2291: 50               push ax
  048892  2292: ff76fa           push word ptr [bp - 6]
  048895  2295: 681615           push 0x1516
  048898  2298: 9a12071d0d       lcall 0xd1d, 0x712
  04889D  229D: 83c408           add sp, 8
  0488A0  22A0: ff76fa           push word ptr [bp - 6]
  0488A3  22A3: 0e               push cs
  0488A4  22A4: e86a31           call 0x5411
  0488A7  22A7: 83c402           add sp, 2
  0488AA  22AA: c746fc0100       mov word ptr [bp - 4], 1
  0488AF  22AF: eb12             jmp 0x22c3
  0488B1  22B1: 90               nop 
  0488B2  22B2: ff46fa           inc word ptr [bp - 6]
  0488B5  22B5: 837efc00         cmp word ptr [bp - 4], 0
  0488B9  22B9: 7537             jne 0x22f2
  0488BB  22BB: a19c53           mov ax, word ptr [0x539c]
  0488BE  22BE: 3946fa           cmp word ptr [bp - 6], ax
  0488C1  22C1: 7d2f             jge 0x22f2
  0488C3  22C3: 8b46fa           mov ax, word ptr [bp - 6]
  0488C6  22C6: 9a7a091f18       lcall 0x181f, 0x97a
  0488CB  22CB: 0bc0             or ax, ax
  0488CD  22CD: 74e3             je 0x22b2
  0488CF  22CF: 6b5efa1c         imul bx, word ptr [bp - 6], 0x1c
  0488D3  22D3: fe875a31         inc byte ptr [bx + 0x315a]
  0488D7  22D7: 80bf5a3114       cmp byte ptr [bx + 0x315a], 0x14
  0488DC  22DC: 769e             jbe 0x227c
  0488DE  22DE: ff76fa           push word ptr [bp - 6]
  0488E1  22E1: 8bf3             mov si, bx
  0488E3  22E3: 9a34091f18       lcall 0x181f, 0x934
  0488E8  22E8: 83c402           add sp, 2
  0488EB  22EB: c6845a3100       mov byte ptr [si + 0x315a], 0
  0488F0  22F0: ebd1             jmp 0x22c3
  0488F2  22F2: 837efc00         cmp word ptr [bp - 4], 0
  0488F6  22F6: 7403             je 0x22fb
  0488F8  22F8: e971ff           jmp 0x226c
  0488FB  22FB: 837ef800         cmp word ptr [bp - 8], 0
  0488FF  22FF: 740b             je 0x230c
  048901  2301: 682815           push 0x1528
  048904  2304: 9a12071d0d       lcall 0xd1d, 0x712
  048909  2309: 83c402           add sp, 2
  04890C  230C: ff7606           push word ptr [bp + 6]
  04890F  230F: 9a420a1f18       lcall 0x181f, 0xa42
  048914  2314: 83c402           add sp, 2
  048917  2317: 5e               pop si
  048918  2318: c9               leave 
  048919  2319: cb               retf 

; ---- func_04891A  size=287  insns=99  prologue=ENTER 0x0012,0  terminal=RETF ----
  04891A  231A: c8120000         enter 0x12, 0
  04891E  231E: 56               push si
  04891F  231F: c746ee0000       mov word ptr [bp - 0x12], 0
  048924  2324: eb1d             jmp 0x2343
  048926  2326: ff46fc           inc word ptr [bp - 4]
  048929  2329: 837efc04         cmp word ptr [bp - 4], 4
  04892D  232D: 7d11             jge 0x2340
  04892F  232F: 6b5eee27         imul bx, word ptr [bp - 0x12], 0x27
  048933  2333: 035efc           add bx, word ptr [bp - 4]
  048936  2336: d1e3             shl bx, 1
  048938  2338: c787045b0000     mov word ptr [bx + 0x5b04], 0
  04893E  233E: ebe6             jmp 0x2326
  048940  2340: ff46ee           inc word ptr [bp - 0x12]
  048943  2343: 837eee08         cmp word ptr [bp - 0x12], 8
  048947  2347: 7d07             jge 0x2350
  048949  2349: c746fc0000       mov word ptr [bp - 4], 0
  04894E  234E: ebd9             jmp 0x2329
  048950  2350: c746f00000       mov word ptr [bp - 0x10], 0
  048955  2355: 6b5ef04e         imul bx, word ptr [bp - 0x10], 0x4e
  048959  2359: f687d95a80       test byte ptr [bx + 0x5ad9], 0x80
  04895E  235E: 750a             jne 0x236a
  048960  2360: ff76f0           push word ptr [bp - 0x10]
  048963  2363: 0e               push cs
  048964  2364: e8a530           call 0x540c
  048967  2367: 83c402           add sp, 2
  04896A  236A: ff46f0           inc word ptr [bp - 0x10]
  04896D  236D: 837ef008         cmp word ptr [bp - 0x10], 8
  048971  2371: 7ce2             jl 0x2355
  048973  2373: c746f00000       mov word ptr [bp - 0x10], 0
  048978  2378: eb79             jmp 0x23f3
  04897A  237A: 90               nop 
  04897B  237B: 90               nop 
  04897C  237C: ff46f8           inc word ptr [bp - 8]
  04897F  237F: 8b46f4           mov ax, word ptr [bp - 0xc]
  048982  2382: 3946f8           cmp word ptr [bp - 8], ax
  048985  2385: 7d69             jge 0x23f0
  048987  2387: 8b5ef8           mov bx, word ptr [bp - 8]
  04898A  238A: 8a87c800         mov al, byte ptr [bx + 0xc8]
  04898E  238E: 98               cwde 
  04898F  238F: 0346f6           add ax, word ptr [bp - 0xa]
  048992  2392: 8946fe           mov word ptr [bp - 2], ax
  048995  2395: 8a87de00         mov al, byte ptr [bx + 0xde]
  048999  2399: 98               cwde 
  04899A  239A: 0346f2           add ax, word ptr [bp - 0xe]
  04899D  239D: 8946fa           mov word ptr [bp - 6], ax
  0489A0  23A0: 8b1e4285         mov bx, word ptr [0x8542]
  0489A4  23A4: 8b76f8           mov si, word ptr [bp - 8]
  0489A7  23A7: 80787000         cmp byte ptr [bx + si + 0x70], 0
  0489AB  23AB: 7ccf             jl 0x237c
  0489AD  23AD: 50               push ax
  0489AE  23AE: ff76fe           push word ptr [bp - 2]
  0489B1  23B1: 9adc061f18       lcall 0x181f, 0x6dc
  0489B6  23B6: 83c404           add sp, 4
  0489B9  23B9: 98               cwde 
  0489BA  23BA: 8946fc           mov word ptr [bp - 4], ax
  0489BD  23BD: 3d0400           cmp ax, 4
  0489C0  23C0: 7cba             jl 0x237c
  0489C2  23C2: 8b46ee           mov ax, word ptr [bp - 0x12]
  0489C5  23C5: 3946fc           cmp word ptr [bp - 4], ax
  0489C8  23C8: 74b2             je 0x237c
  0489CA  23CA: ff76fa           push word ptr [bp - 6]
  0489CD  23CD: ff76fe           push word ptr [bp - 2]
  0489D0  23D0: 9ad2061f18       lcall 0x181f, 0x6d2
  0489D5  23D5: 83c404           add sp, 4
  0489D8  23D8: 0bc0             or ax, ax
  0489DA  23DA: 7da0             jge 0x237c
  0489DC  23DC: ff76ee           push word ptr [bp - 0x12]
  0489DF  23DF: ff76fa           push word ptr [bp - 6]
  0489E2  23E2: ff76fe           push word ptr [bp - 2]
  0489E5  23E5: 9a04071f18       lcall 0x181f, 0x704
  0489EA  23EA: 83c406           add sp, 6
  0489ED  23ED: eb8d             jmp 0x237c
  0489EF  23EF: 90               nop 
  0489F0  23F0: ff46f0           inc word ptr [bp - 0x10]
  0489F3  23F3: a19e53           mov ax, word ptr [0x539e]
  0489F6  23F6: 3946f0           cmp word ptr [bp - 0x10], ax
  0489F9  23F9: 7d3b             jge 0x2436
  0489FB  23FB: ff76f0           push word ptr [bp - 0x10]
  0489FE  23FE: 9ae6091f18       lcall 0x181f, 0x9e6
  048A03  2403: 83c402           add sp, 2
  048A06  2406: 8b1e4285         mov bx, word ptr [0x8542]
  048A0A  240A: 8a471a           mov al, byte ptr [bx + 0x1a]
  048A0D  240D: 2ae4             sub ah, ah
  048A0F  240F: 8946ee           mov word ptr [bp - 0x12], ax
  048A12  2412: 8a07             mov al, byte ptr [bx]
  048A14  2414: 8946f6           mov word ptr [bp - 0xa], ax
  048A17  2417: 8a4701           mov al, byte ptr [bx + 1]
  048A1A  241A: 8946f2           mov word ptr [bp - 0xe], ax
  048A1D  241D: 9a5e0c1f18       lcall 0x181f, 0xc5e
  048A22  2422: 8bd8             mov bx, ax
  048A24  2424: 8a872903         mov al, byte ptr [bx + 0x329]
  048A28  2428: 2ae4             sub ah, ah
  048A2A  242A: 8946f4           mov word ptr [bp - 0xc], ax
  048A2D  242D: c746f80000       mov word ptr [bp - 8], 0
  048A32  2432: e94aff           jmp 0x237f
  048A35  2435: 90               nop 
  048A36  2436: 5e               pop si
  048A37  2437: c9               leave 
  048A38  2438: cb               retf 

; ---- func_048A3A  size=617  insns=213  prologue=ENTER 0x0038,0  terminal=RETF ----
  048A3A  243A: c8380000         enter 0x38, 0
  048A3E  243E: a1528d           mov ax, word ptr [0x8d52]
  048A41  2441: 8946d6           mov word ptr [bp - 0x2a], ax
  048A44  2444: a14c8d           mov ax, word ptr [0x8d4c]
  048A47  2447: 8946cc           mov word ptr [bp - 0x34], ax
  048A4A  244A: 2bc0             sub ax, ax
  048A4C  244C: 8946d4           mov word ptr [bp - 0x2c], ax
  048A4F  244F: 8946d2           mov word ptr [bp - 0x2e], ax
  048A52  2452: 8946d0           mov word ptr [bp - 0x30], ax
  048A55  2455: eb2a             jmp 0x2481
  048A57  2457: 90               nop 
  048A58  2458: ff76d0           push word ptr [bp - 0x30]
  048A5B  245B: 9a4c0a1f18       lcall 0x181f, 0xa4c
  048A60  2460: 83c402           add sp, 2
  048A63  2463: 8b46d6           mov ax, word ptr [bp - 0x2a]
  048A66  2466: 3906528d         cmp word ptr [0x8d52], ax
  048A6A  246A: 7512             jne 0x247e
  048A6C  246C: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  048A70  2470: 8a4705           mov al, byte ptr [bx + 5]
  048A73  2473: 250f00           and ax, 0xf
  048A76  2476: 3b4608           cmp ax, word ptr [bp + 8]
  048A79  2479: 7503             jne 0x247e
  048A7B  247B: ff46d4           inc word ptr [bp - 0x2c]
  048A7E  247E: ff46d0           inc word ptr [bp - 0x30]
  048A81  2481: a19a53           mov ax, word ptr [0x539a]
  048A84  2484: 3946d0           cmp word ptr [bp - 0x30], ax
  048A87  2487: 7ccf             jl 0x2458
  048A89  2489: ff76cc           push word ptr [bp - 0x34]
  048A8C  248C: 9a4c0a1f18       lcall 0x181f, 0xa4c
  048A91  2491: 83c402           add sp, 2
  048A94  2494: 6a17             push 0x17
  048A96  2496: ff7608           push word ptr [bp + 8]
  048A99  2499: 9ab4071f18       lcall 0x181f, 0x7b4
  048A9E  249E: 83c404           add sp, 4
  048AA1  24A1: 0bc0             or ax, ax
  048AA3  24A3: 7403             je 0x24a8
  048AA5  24A5: d166d4           shl word ptr [bp - 0x2c], 1
  048AA8  24A8: 6a18             push 0x18
  048AAA  24AA: ff7608           push word ptr [bp + 8]
  048AAD  24AD: 9ab4071f18       lcall 0x181f, 0x7b4
  048AB2  24B2: 83c404           add sp, 4
  048AB5  24B5: 0bc0             or ax, ax
  048AB7  24B7: 7403             je 0x24bc
  048AB9  24B9: d17ed4           sar word ptr [bp - 0x2c], 1
  048ABC  24BC: 6a10             push 0x10
  048ABE  24BE: ff7608           push word ptr [bp + 8]
  048AC1  24C1: 9ab4071f18       lcall 0x181f, 0x7b4
  048AC6  24C6: 83c404           add sp, 4
  048AC9  24C9: 0bc0             or ax, ax
  048ACB  24CB: 7403             je 0x24d0
  048ACD  24CD: d17ed4           sar word ptr [bp - 0x2c], 1
  048AD0  24D0: 837e0801         cmp word ptr [bp + 8], 1
  048AD4  24D4: 7503             jne 0x24d9
  048AD6  24D6: d17ed4           sar word ptr [bp - 0x2c], 1
  048AD9  24D9: ff7608           push word ptr [bp + 8]
  048ADC  24DC: ff36528d         push word ptr [0x8d52]
  048AE0  24E0: 9a0c031f18       lcall 0x181f, 0x30c
  048AE5  24E5: 83c404           add sp, 4
  048AE8  24E8: 50               push ax
  048AE9  24E9: 9a600a1f18       lcall 0x181f, 0xa60
  048AEE  24EE: 83c402           add sp, 2
  048AF1  24F1: 8946ca           mov word ptr [bp - 0x36], ax
  048AF4  24F4: 0bc0             or ax, ax
  048AF6  24F6: 7412             je 0x250a
  048AF8  24F8: 48               dec ax
  048AF9  24F9: 742f             je 0x252a
  048AFB  24FB: 48               dec ax
  048AFC  24FC: 7438             je 0x2536
  048AFE  24FE: 8b46d4           mov ax, word ptr [bp - 0x2c]
  048B01  2501: c1e003           shl ax, 3
  048B04  2504: 2d0500           sub ax, 5
  048B07  2507: eb0a             jmp 0x2513
  048B09  2509: 90               nop 
  048B0A  250A: 8b46d4           mov ax, word ptr [bp - 0x2c]
  048B0D  250D: c1e003           shl ax, 3
  048B10  2510: 2d1900           sub ax, 0x19
  048B13  2513: 8946d2           mov word ptr [bp - 0x2e], ax
  048B16  2516: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  048B1A  251A: f6470304         test byte ptr [bx + 3], 4
  048B1E  251E: 7433             je 0x2553
  048B20  2520: 0bc0             or ax, ax
  048B22  2522: 7e1e             jle 0x2542
  048B24  2524: b80100           mov ax, 1
  048B27  2527: eb24             jmp 0x254d
  048B29  2529: 90               nop 
  048B2A  252A: 8b46d4           mov ax, word ptr [bp - 0x2c]
  048B2D  252D: c1e003           shl ax, 3
  048B30  2530: 2d0f00           sub ax, 0xf
  048B33  2533: ebde             jmp 0x2513
  048B35  2535: 90               nop 
  048B36  2536: 8b46d4           mov ax, word ptr [bp - 0x2c]
  048B39  2539: c1e003           shl ax, 3
  048B3C  253C: 2d0a00           sub ax, 0xa
  048B3F  253F: ebd2             jmp 0x2513
  048B41  2541: 90               nop 
  048B42  2542: 0bc0             or ax, ax
  048B44  2544: 7c04             jl 0x254a
  048B46  2546: 2bc0             sub ax, ax
  048B48  2548: eb03             jmp 0x254d
  048B4A  254A: b8ffff           mov ax, 0xffff
  048B4D  254D: c1e003           shl ax, 3
  048B50  2550: 0146d2           add word ptr [bp - 0x2e], ax
  048B53  2553: 683215           push 0x1532
  048B56  2556: 8d46d8           lea ax, [bp - 0x28]
  048B59  2559: 50               push ax
  048B5A  255A: 9ae4071d0d       lcall 0xd1d, 0x7e4
  048B5F  255F: 83c404           add sp, 4
  048B62  2562: 837ed2fb         cmp word ptr [bp - 0x2e], -5
  048B66  2566: 7c0e             jl 0x2576
  048B68  2568: 8b46ca           mov ax, word ptr [bp - 0x36]
  048B6B  256B: 3d0100           cmp ax, 1
  048B6E  256E: 7d03             jge 0x2573
  048B70  2570: b80100           mov ax, 1
  048B73  2573: 8946ca           mov word ptr [bp - 0x36], ax
  048B76  2576: 837ed200         cmp word ptr [bp - 0x2e], 0
  048B7A  257A: 7e0e             jle 0x258a
  048B7C  257C: 8b46ca           mov ax, word ptr [bp - 0x36]
  048B7F  257F: 3d0200           cmp ax, 2
  048B82  2582: 7d03             jge 0x2587
  048B84  2584: b80200           mov ax, 2
  048B87  2587: 8946ca           mov word ptr [bp - 0x36], ax
  048B8A  258A: 837ed20a         cmp word ptr [bp - 0x2e], 0xa
  048B8E  258E: 7c05             jl 0x2595
  048B90  2590: c746ca0300       mov word ptr [bp - 0x36], 3
  048B95  2595: 8a46ca           mov al, byte ptr [bp - 0x36]
  048B98  2598: 0046df           add byte ptr [bp - 0x21], al
  048B9B  259B: 6aff             push -1
  048B9D  259D: ff7608           push word ptr [bp + 8]
  048BA0  25A0: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  048BA4  25A4: 8a4701           mov al, byte ptr [bx + 1]
  048BA7  25A7: 2ae4             sub ah, ah
  048BA9  25A9: 50               push ax
  048BAA  25AA: 8a07             mov al, byte ptr [bx]
  048BAC  25AC: 50               push ax
  048BAD  25AD: 9a14061f18       lcall 0x181f, 0x614
  048BB2  25B2: 83c408           add sp, 8
  048BB5  25B5: 8946ce           mov word ptr [bp - 0x32], ax
  048BB8  25B8: 8b5e08           mov bx, word ptr [bp + 8]
  048BBB  25BB: d1e3             shl bx, 1
  048BBD  25BD: ffb7f897         push word ptr [bx - 0x6808]
  048BC1  25C1: 6a00             push 0
  048BC3  25C3: 9a38041f18       lcall 0x181f, 0x438
  048BC8  25C8: 83c404           add sp, 4
  048BCB  25CB: 837ece00         cmp word ptr [bp - 0x32], 0
  048BCF  25CF: 7c17             jl 0x25e8
  048BD1  25D1: 6946ceca00       imul ax, word ptr [bp - 0x32], 0xca
  048BD6  25D6: 05485d           add ax, 0x5d48
  048BD9  25D9: 1e               push ds
  048BDA  25DA: 50               push ax
  048BDB  25DB: 6a01             push 1
  048BDD  25DD: 9a16041f18       lcall 0x181f, 0x416
  048BE2  25E2: 83c406           add sp, 6
  048BE5  25E5: eb14             jmp 0x25fb
  048BE7  25E7: 90               nop 
  048BE8  25E8: 8b5e08           mov bx, word ptr [bp + 8]
  048BEB  25EB: d1e3             shl bx, 1
  048BED  25ED: ffb78c83         push word ptr [bx - 0x7c74]
  048BF1  25F1: 6a01             push 1
  048BF3  25F3: 9a38041f18       lcall 0x181f, 0x438
  048BF8  25F8: 83c404           add sp, 4
  048BFB  25FB: 8b1e8c53         mov bx, word ptr [0x538c]
  048BFF  25FF: d1e3             shl bx, 1
  048C01  2601: ffb70098         push word ptr [bx - 0x6800]
  048C05  2605: 6a02             push 2
  048C07  2607: 9a38041f18       lcall 0x181f, 0x438
  048C0C  260C: 83c404           add sp, 4
  048C0F  260F: a18a53           mov ax, word ptr [0x538a]
  048C12  2612: 99               cdq 
  048C13  2613: a3b09c           mov word ptr [0x9cb0], ax
  048C16  2616: 8916b29c         mov word ptr [0x9cb2], dx
  048C1A  261A: ff760a           push word ptr [bp + 0xa]
  048C1D  261D: 9aa4091f18       lcall 0x181f, 0x9a4
  048C22  2622: 83c402           add sp, 2
  048C25  2625: 50               push ax
  048C26  2626: 6a03             push 3
  048C28  2628: 9a38041f18       lcall 0x181f, 0x438
  048C2D  262D: 83c404           add sp, 4
  048C30  2630: 837e0804         cmp word ptr [bp + 8], 4
  048C34  2634: 7d21             jge 0x2657
  048C36  2636: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  048C3A  263A: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  048C3F  263F: 7516             jne 0x2657
  048C41  2641: b82480           mov ax, 0x8024
  048C44  2644: 9ac0041f18       lcall 0x181f, 0x4c0
  048C49  2649: 6a04             push 4
  048C4B  264B: 8d46d8           lea ax, [bp - 0x28]
  048C4E  264E: 50               push ax
  048C4F  264F: 9a52061f18       lcall 0x181f, 0x652
  048C54  2654: 83c404           add sp, 4
  048C57  2657: 8a4608           mov al, byte ptr [bp + 8]
  048C5A  265A: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  048C5E  265E: 884705           mov byte ptr [bx + 5], al
  048C61  2661: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  048C65  2665: 80bf5b3118       cmp byte ptr [bx + 0x315b], 0x18
  048C6A  266A: 7411             je 0x267d
  048C6C  266C: 6a16             push 0x16
  048C6E  266E: ff7608           push word ptr [bp + 8]
  048C71  2671: 9ab4071f18       lcall 0x181f, 0x7b4
  048C76  2676: 83c404           add sp, 4
  048C79  2679: 0bc0             or ax, ax
  048C7B  267B: 7408             je 0x2685
  048C7D  267D: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  048C81  2681: 804f0510         or byte ptr [bx + 5], 0x10
  048C85  2685: ff7606           push word ptr [bp + 6]
  048C88  2688: 9a08081f18       lcall 0x181f, 0x808
  048C8D  268D: 83c402           add sp, 2
  048C90  2690: 6a00             push 0
  048C92  2692: ff76d2           push word ptr [bp - 0x2e]
  048C95  2695: ff7608           push word ptr [bp + 8]
  048C98  2698: ff36528d         push word ptr [0x8d52]
  048C9C  269C: 9a6c0d1f18       lcall 0x181f, 0xd6c
  048CA1  26A1: c9               leave 
  048CA2  26A2: cb               retf 

; ---- func_048CA4  size=656  insns=223  prologue=ENTER 0x0020,0  terminal=RETF ----
  048CA4  26A4: c8200000         enter 0x20, 0
  048CA8  26A8: 56               push si
  048CA9  26A9: 8b4608           mov ax, word ptr [bp + 8]
  048CAC  26AC: 8946ee           mov word ptr [bp - 0x12], ax
  048CAF  26AF: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  048CB3  26B3: 8a4705           mov al, byte ptr [bx + 5]
  048CB6  26B6: 250f00           and ax, 0xf
  048CB9  26B9: 8946f2           mov word ptr [bp - 0xe], ax
  048CBC  26BC: a14c8d           mov ax, word ptr [0x8d4c]
  048CBF  26BF: 8946f8           mov word ptr [bp - 8], ax
  048CC2  26C2: 2bc0             sub ax, ax
  048CC4  26C4: 8946ec           mov word ptr [bp - 0x14], ax
  048CC7  26C7: 8946e8           mov word ptr [bp - 0x18], ax
  048CCA  26CA: 8946f4           mov word ptr [bp - 0xc], ax
  048CCD  26CD: 8946f0           mov word ptr [bp - 0x10], ax
  048CD0  26D0: 8946ea           mov word ptr [bp - 0x16], ax
  048CD3  26D3: eb75             jmp 0x274a
  048CD5  26D5: 90               nop 
  048CD6  26D6: 3946ee           cmp word ptr [bp - 0x12], ax
  048CD9  26D9: 7509             jne 0x26e4
  048CDB  26DB: 8b46fa           mov ax, word ptr [bp - 6]
  048CDE  26DE: 0146ec           add word ptr [bp - 0x14], ax
  048CE1  26E1: eb07             jmp 0x26ea
  048CE3  26E3: 90               nop 
  048CE4  26E4: 8b46fa           mov ax, word ptr [bp - 6]
  048CE7  26E7: 0146f6           add word ptr [bp - 0xa], ax
  048CEA  26EA: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  048CEE  26EE: 807f0500         cmp byte ptr [bx + 5], 0
  048CF2  26F2: 7c53             jl 0x2747
  048CF4  26F4: 8a4705           mov al, byte ptr [bx + 5]
  048CF7  26F7: 8bc8             mov cx, ax
  048CF9  26F9: 250f00           and ax, 0xf
  048CFC  26FC: 8946fc           mov word ptr [bp - 4], ax
  048CFF  26FF: 8ac1             mov al, cl
  048D01  2701: 251000           and ax, 0x10
  048D04  2704: 8946e6           mov word ptr [bp - 0x1a], ax
  048D07  2707: 8a4f04           mov cl, byte ptr [bx + 4]
  048D0A  270A: 2aed             sub ch, ch
  048D0C  270C: 014ef6           add word ptr [bp - 0xa], cx
  048D0F  270F: 0bc0             or ax, ax
  048D11  2711: 7403             je 0x2716
  048D13  2713: d166f6           shl word ptr [bp - 0xa], 1
  048D16  2716: f6470304         test byte ptr [bx + 3], 4
  048D1A  271A: 7403             je 0x271f
  048D1C  271C: d166f6           shl word ptr [bp - 0xa], 1
  048D1F  271F: 8b4608           mov ax, word ptr [bp + 8]
  048D22  2722: 3946f2           cmp word ptr [bp - 0xe], ax
  048D25  2725: 7509             jne 0x2730
  048D27  2727: 8b46f6           mov ax, word ptr [bp - 0xa]
  048D2A  272A: 0146ec           add word ptr [bp - 0x14], ax
  048D2D  272D: eb18             jmp 0x2747
  048D2F  272F: 90               nop 
  048D30  2730: 3946ee           cmp word ptr [bp - 0x12], ax
  048D33  2733: 7509             jne 0x273e
  048D35  2735: 8b46f6           mov ax, word ptr [bp - 0xa]
  048D38  2738: 0146e8           add word ptr [bp - 0x18], ax
  048D3B  273B: eb0a             jmp 0x2747
  048D3D  273D: 90               nop 
  048D3E  273E: 8b46f6           mov ax, word ptr [bp - 0xa]
  048D41  2741: 0146f0           add word ptr [bp - 0x10], ax
  048D44  2744: 0146f4           add word ptr [bp - 0xc], ax
  048D47  2747: ff46ea           inc word ptr [bp - 0x16]
  048D4A  274A: a19a53           mov ax, word ptr [0x539a]
  048D4D  274D: 3946ea           cmp word ptr [bp - 0x16], ax
  048D50  2750: 7d40             jge 0x2792
  048D52  2752: ff76ea           push word ptr [bp - 0x16]
  048D55  2755: 9a4c0a1f18       lcall 0x181f, 0xa4c
  048D5A  275A: 83c402           add sp, 2
  048D5D  275D: 8a460a           mov al, byte ptr [bp + 0xa]
  048D60  2760: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  048D64  2764: 384702           cmp byte ptr [bx + 2], al
  048D67  2767: 75de             jne 0x2747
  048D69  2769: c746f60000       mov word ptr [bp - 0xa], 0
  048D6E  276E: 8d46fa           lea ax, [bp - 6]
  048D71  2771: 50               push ax
  048D72  2772: ff76ea           push word ptr [bp - 0x16]
  048D75  2775: 9a16031f18       lcall 0x181f, 0x316
  048D7A  277A: 83c404           add sp, 4
  048D7D  277D: 8946e2           mov word ptr [bp - 0x1e], ax
  048D80  2780: 3b46f2           cmp ax, word ptr [bp - 0xe]
  048D83  2783: 7403             je 0x2788
  048D85  2785: e94eff           jmp 0x26d6
  048D88  2788: 8b46fa           mov ax, word ptr [bp - 6]
  048D8B  278B: 0146e8           add word ptr [bp - 0x18], ax
  048D8E  278E: e959ff           jmp 0x26ea
  048D91  2791: 90               nop 
  048D92  2792: ff76f8           push word ptr [bp - 8]
  048D95  2795: 9a4c0a1f18       lcall 0x181f, 0xa4c
  048D9A  279A: 83c402           add sp, 2
  048D9D  279D: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  048DA1  27A1: 80bf5b3103       cmp byte ptr [bx + 0x315b], 3
  048DA6  27A6: 7506             jne 0x27ae
  048DA8  27A8: b80100           mov ax, 1
  048DAB  27AB: eb03             jmp 0x27b0
  048DAD  27AD: 90               nop 
  048DAE  27AE: 2bc0             sub ax, ax
  048DB0  27B0: 8946fe           mov word ptr [bp - 2], ax
  048DB3  27B3: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  048DB7  27B7: 8a4705           mov al, byte ptr [bx + 5]
  048DBA  27BA: 251000           and ax, 0x10
  048DBD  27BD: 8946e0           mov word ptr [bp - 0x20], ax
  048DC0  27C0: 8a4703           mov al, byte ptr [bx + 3]
  048DC3  27C3: 250400           and ax, 4
  048DC6  27C6: 8946e4           mov word ptr [bp - 0x1c], ax
  048DC9  27C9: ff76f2           push word ptr [bp - 0xe]
  048DCC  27CC: ff36528d         push word ptr [0x8d52]
  048DD0  27D0: 8bf0             mov si, ax
  048DD2  27D2: 9a0c031f18       lcall 0x181f, 0x30c
  048DD7  27D7: 83c404           add sp, 4
  048DDA  27DA: 8bce             mov cx, si
  048DDC  27DC: d3e0             shl ax, cl
  048DDE  27DE: 0146e8           add word ptr [bp - 0x18], ax
  048DE1  27E1: ff76ee           push word ptr [bp - 0x12]
  048DE4  27E4: ff36528d         push word ptr [0x8d52]
  048DE8  27E8: 9a0c031f18       lcall 0x181f, 0x30c
  048DED  27ED: 83c404           add sp, 4
  048DF0  27F0: b101             mov cl, 1
  048DF2  27F2: 2a4ee4           sub cl, byte ptr [bp - 0x1c]
  048DF5  27F5: d3f8             sar ax, cl
  048DF7  27F7: 0146ec           add word ptr [bp - 0x14], ax
  048DFA  27FA: 8b46ec           mov ax, word ptr [bp - 0x14]
  048DFD  27FD: 50               push ax
  048DFE  27FE: 9a600a1f18       lcall 0x181f, 0xa60
  048E03  2803: 83c402           add sp, 2
  048E06  2806: 40               inc ax
  048E07  2807: 0146f0           add word ptr [bp - 0x10], ax
  048E0A  280A: ff76e8           push word ptr [bp - 0x18]
  048E0D  280D: 9a600a1f18       lcall 0x181f, 0xa60
  048E12  2812: 83c402           add sp, 2
  048E15  2815: 40               inc ax
  048E16  2816: 0146f4           add word ptr [bp - 0xc], ax
  048E19  2819: 837ee400         cmp word ptr [bp - 0x1c], 0
  048E1D  281D: 7427             je 0x2846
  048E1F  281F: 6a14             push 0x14
  048E21  2821: 6a01             push 1
  048E23  2823: 9ad4041f18       lcall 0x181f, 0x4d4
  048E28  2828: 83c404           add sp, 4
  048E2B  282B: 0146e8           add word ptr [bp - 0x18], ax
  048E2E  282E: 6a14             push 0x14
  048E30  2830: 6a01             push 1
  048E32  2832: 9ad4041f18       lcall 0x181f, 0x4d4
  048E37  2837: 83c404           add sp, 4
  048E3A  283A: 0346ec           add ax, word ptr [bp - 0x14]
  048E3D  283D: 8946ec           mov word ptr [bp - 0x14], ax
  048E40  2840: d166f4           shl word ptr [bp - 0xc], 1
  048E43  2843: d166f0           shl word ptr [bp - 0x10], 1
  048E46  2846: 837efe00         cmp word ptr [bp - 2], 0
  048E4A  284A: 7406             je 0x2852
  048E4C  284C: d166e8           shl word ptr [bp - 0x18], 1
  048E4F  284F: d166f4           shl word ptr [bp - 0xc], 1
  048E52  2852: 837ee000         cmp word ptr [bp - 0x20], 0
  048E56  2856: 7406             je 0x285e
  048E58  2858: d166ec           shl word ptr [bp - 0x14], 1
  048E5B  285B: d166f0           shl word ptr [bp - 0x10], 1
  048E5E  285E: ff76ee           push word ptr [bp - 0x12]
  048E61  2861: 9aa4091f18       lcall 0x181f, 0x9a4
  048E66  2866: 83c402           add sp, 2
  048E69  2869: 50               push ax
  048E6A  286A: 6a00             push 0
  048E6C  286C: 9a38041f18       lcall 0x181f, 0x438
  048E71  2871: 83c404           add sp, 4
  048E74  2874: ff76f2           push word ptr [bp - 0xe]
  048E77  2877: 9aa4091f18       lcall 0x181f, 0x9a4
  048E7C  287C: 83c402           add sp, 2
  048E7F  287F: 50               push ax
  048E80  2880: 6a01             push 1
  048E82  2882: 9a38041f18       lcall 0x181f, 0x438
  048E87  2887: 83c404           add sp, 4
  048E8A  288A: ff36508d         push word ptr [0x8d50]
  048E8E  288E: 9aa4091f18       lcall 0x181f, 0x9a4
  048E93  2893: 83c402           add sp, 2
  048E96  2896: 50               push ax
  048E97  2897: 6a02             push 2
  048E99  2899: 9a38041f18       lcall 0x181f, 0x438
  048E9E  289E: 83c404           add sp, 4
  048EA1  28A1: 8b46ec           mov ax, word ptr [bp - 0x14]
  048EA4  28A4: 0346e8           add ax, word ptr [bp - 0x18]
  048EA7  28A7: 50               push ax
  048EA8  28A8: 6a01             push 1
  048EAA  28AA: 9ad4041f18       lcall 0x181f, 0x4d4
  048EAF  28AF: 83c404           add sp, 4
  048EB2  28B2: 3b46e8           cmp ax, word ptr [bp - 0x18]
  048EB5  28B5: 7f2f             jg 0x28e6
  048EB7  28B7: b82480           mov ax, 0x8024
  048EBA  28BA: 9ac0041f18       lcall 0x181f, 0x4c0
  048EBF  28BF: 6a04             push 4
  048EC1  28C1: 683b15           push 0x153b
  048EC4  28C4: 9a52061f18       lcall 0x181f, 0x652
  048EC9  28C9: 83c404           add sp, 4
  048ECC  28CC: 8a46ee           mov al, byte ptr [bp - 0x12]
  048ECF  28CF: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  048ED3  28D3: 884705           mov byte ptr [bx + 5], al
  048ED6  28D6: 837efe00         cmp word ptr [bp - 2], 0
  048EDA  28DA: 7405             je 0x28e1
  048EDC  28DC: 0c10             or al, 0x10
  048EDE  28DE: 884705           mov byte ptr [bx + 5], al
  048EE1  28E1: f75ef0           neg word ptr [bp - 0x10]
  048EE4  28E4: eb18             jmp 0x28fe
  048EE6  28E6: b85300           mov ax, 0x53
  048EE9  28E9: 9ac0041f18       lcall 0x181f, 0x4c0
  048EEE  28EE: 6a04             push 4
  048EF0  28F0: 684315           push 0x1543
  048EF3  28F3: 9a52061f18       lcall 0x181f, 0x652
  048EF8  28F8: 83c404           add sp, 4
  048EFB  28FB: f75ef4           neg word ptr [bp - 0xc]
  048EFE  28FE: ff7606           push word ptr [bp + 6]
  048F01  2901: 9a08081f18       lcall 0x181f, 0x808
  048F06  2906: 83c402           add sp, 2
  048F09  2909: 6a00             push 0
  048F0B  290B: ff76f4           push word ptr [bp - 0xc]
  048F0E  290E: ff76f2           push word ptr [bp - 0xe]
  048F11  2911: ff36528d         push word ptr [0x8d52]
  048F15  2915: 9a6c0d1f18       lcall 0x181f, 0xd6c
  048F1A  291A: 83c408           add sp, 8
  048F1D  291D: 6a00             push 0
  048F1F  291F: ff76f0           push word ptr [bp - 0x10]
  048F22  2922: ff76ee           push word ptr [bp - 0x12]
  048F25  2925: ff36528d         push word ptr [0x8d52]
  048F29  2929: 9a6c0d1f18       lcall 0x181f, 0xd6c
  048F2E  292E: 83c408           add sp, 8
  048F31  2931: 5e               pop si
  048F32  2932: c9               leave 
  048F33  2933: cb               retf 

; ---- func_048F34  size=1740  insns=624  prologue=ENTER 0x00A4,0  terminal=RETF ----
  048F34  2934: c8a40000         enter 0xa4, 0
  048F38  2938: 57               push di
  048F39  2939: 56               push si
  048F3A  293A: 2bc0             sub ax, ax
  048F3C  293C: 898664ff         mov word ptr [bp - 0x9c], ax
  048F40  2940: 898662ff         mov word ptr [bp - 0x9e], ax
  048F44  2944: 898666ff         mov word ptr [bp - 0x9a], ax
  048F48  2948: 8946a4           mov word ptr [bp - 0x5c], ax
  048F4B  294B: 89468e           mov word ptr [bp - 0x72], ax
  048F4E  294E: 8946a8           mov word ptr [bp - 0x58], ax
  048F51  2951: 894698           mov word ptr [bp - 0x68], ax
  048F54  2954: 894694           mov word ptr [bp - 0x6c], ax
  048F57  2957: 8946aa           mov word ptr [bp - 0x56], ax
  048F5A  295A: 894688           mov word ptr [bp - 0x78], ax
  048F5D  295D: 89469a           mov word ptr [bp - 0x66], ax
  048F60  2960: 894684           mov word ptr [bp - 0x7c], ax
  048F63  2963: 89469c           mov word ptr [bp - 0x64], ax
  048F66  2966: 89468c           mov word ptr [bp - 0x74], ax
  048F69  2969: eb0c             jmp 0x2977
  048F6B  296B: 90               nop 
  048F6C  296C: 8b768c           mov si, word ptr [bp - 0x74]
  048F6F  296F: c68268ff00       mov byte ptr [bp + si - 0x98], 0
  048F74  2974: ff468c           inc word ptr [bp - 0x74]
  048F77  2977: 837e8c19         cmp word ptr [bp - 0x74], 0x19
  048F7B  297B: 7cef             jl 0x296c
  048F7D  297D: c7468c0000       mov word ptr [bp - 0x74], 0
  048F82  2982: e9aa00           jmp 0x2a2f
  048F85  2985: 90               nop 
  048F86  2986: ff4690           inc word ptr [bp - 0x70]
  048F89  2989: 837e9005         cmp word ptr [bp - 0x70], 5
  048F8D  298D: 7c03             jl 0x2992
  048F8F  298F: e98800           jmp 0x2a1a
  048F92  2992: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  048F96  2996: 8a4701           mov al, byte ptr [bx + 1]
  048F99  2999: 2ae4             sub ah, ah
  048F9B  299B: 8b364285         mov si, word ptr [0x8542]
  048F9F  299F: 8a4c01           mov cl, byte ptr [si + 1]
  048FA2  29A2: 2aed             sub ch, ch
  048FA4  29A4: 2bc1             sub ax, cx
  048FA6  29A6: 03468a           add ax, word ptr [bp - 0x76]
  048FA9  29A9: 8946a6           mov word ptr [bp - 0x5a], ax
  048FAC  29AC: 48               dec ax
  048FAD  29AD: 48               dec ax
  048FAE  29AE: 50               push ax
  048FAF  29AF: 8a07             mov al, byte ptr [bx]
  048FB1  29B1: 2ae4             sub ah, ah
  048FB3  29B3: 8a0c             mov cl, byte ptr [si]
  048FB5  29B5: 2bc1             sub ax, cx
  048FB7  29B7: 034690           add ax, word ptr [bp - 0x70]
  048FBA  29BA: 8946fc           mov word ptr [bp - 4], ax
  048FBD  29BD: 48               dec ax
  048FBE  29BE: 48               dec ax
  048FBF  29BF: 50               push ax
  048FC0  29C0: 9a02031f18       lcall 0x181f, 0x302
  048FC5  29C5: 83c404           add sp, 4
  048FC8  29C8: 0bc0             or ax, ax
  048FCA  29CA: 74ba             je 0x2986
  048FCC  29CC: 837efc00         cmp word ptr [bp - 4], 0
  048FD0  29D0: 7cb4             jl 0x2986
  048FD2  29D2: 837efc05         cmp word ptr [bp - 4], 5
  048FD6  29D6: 7dae             jge 0x2986
  048FD8  29D8: 837ea600         cmp word ptr [bp - 0x5a], 0
  048FDC  29DC: 7ca8             jl 0x2986
  048FDE  29DE: 837ea605         cmp word ptr [bp - 0x5a], 5
  048FE2  29E2: 7da2             jge 0x2986
  048FE4  29E4: 837e9002         cmp word ptr [bp - 0x70], 2
  048FE8  29E8: 7506             jne 0x29f0
  048FEA  29EA: 837e8a02         cmp word ptr [bp - 0x76], 2
  048FEE  29EE: 7412             je 0x2a02
  048FF0  29F0: ff768a           push word ptr [bp - 0x76]
  048FF3  29F3: ff7690           push word ptr [bp - 0x70]
  048FF6  29F6: 9ae00c1f18       lcall 0x181f, 0xce0
  048FFB  29FB: 83c404           add sp, 4
  048FFE  29FE: 0ac0             or al, al
  049000  2A00: 7c84             jl 0x2986
  049002  2A02: 8b768a           mov si, word ptr [bp - 0x76]
  049005  2A05: 8bc6             mov ax, si
  049007  2A07: c1e602           shl si, 2
  04900A  2A0A: 03f0             add si, ax
  04900C  2A0C: 037690           add si, word ptr [bp - 0x70]
  04900F  2A0F: 897692           mov word ptr [bp - 0x6e], si
  049012  2A12: c68268ff01       mov byte ptr [bp + si - 0x98], 1
  049017  2A17: e96cff           jmp 0x2986
  04901A  2A1A: ff468a           inc word ptr [bp - 0x76]
  04901D  2A1D: 837e8a05         cmp word ptr [bp - 0x76], 5
  049021  2A21: 7d09             jge 0x2a2c
  049023  2A23: c746900000       mov word ptr [bp - 0x70], 0
  049028  2A28: e95eff           jmp 0x2989
  04902B  2A2B: 90               nop 
  04902C  2A2C: ff468c           inc word ptr [bp - 0x74]
  04902F  2A2F: a19e53           mov ax, word ptr [0x539e]
  049032  2A32: 39468c           cmp word ptr [bp - 0x74], ax
  049035  2A35: 7d13             jge 0x2a4a
  049037  2A37: ff768c           push word ptr [bp - 0x74]
  04903A  2A3A: 9ae6091f18       lcall 0x181f, 0x9e6
  04903F  2A3F: 83c402           add sp, 2
  049042  2A42: c7468a0000       mov word ptr [bp - 0x76], 0
  049047  2A47: ebd4             jmp 0x2a1d
  049049  2A49: 90               nop 
  04904A  2A4A: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04904E  2A4E: 8a4701           mov al, byte ptr [bx + 1]
  049051  2A51: 2ae4             sub ah, ah
  049053  2A53: 48               dec ax
  049054  2A54: 48               dec ax
  049055  2A55: 89468a           mov word ptr [bp - 0x76], ax
  049058  2A58: e9ce01           jmp 0x2c29
  04905B  2A5B: 90               nop 
  04905C  2A5C: ff46a4           inc word ptr [bp - 0x5c]
  04905F  2A5F: 8346a802         add word ptr [bp - 0x58], 2
  049063  2A63: e9bc00           jmp 0x2b22
  049066  2A66: 837e8219         cmp word ptr [bp - 0x7e], 0x19
  04906A  2A6A: 7406             je 0x2a72
  04906C  2A6C: 837e821a         cmp word ptr [bp - 0x7e], 0x1a
  049070  2A70: 7520             jne 0x2a92
  049072  2A72: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  049076  2A76: 8a4702           mov al, byte ptr [bx + 2]
  049079  2A79: 2ae4             sub ah, ah
  04907B  2A7B: 40               inc ax
  04907C  2A7C: 014688           add word ptr [bp - 0x78], ax
  04907F  2A7F: 837e8803         cmp word ptr [bp - 0x78], 3
  049083  2A83: 7d03             jge 0x2a88
  049085  2A85: e99a00           jmp 0x2b22
  049088  2A88: 83469402         add word ptr [bp - 0x6c], 2
  04908C  2A8C: 836e8803         sub word ptr [bp - 0x78], 3
  049090  2A90: ebed             jmp 0x2a7f
  049092  2A92: 837e8208         cmp word ptr [bp - 0x7e], 8
  049096  2A96: 7c03             jl 0x2a9b
  049098  2A98: e98700           jmp 0x2b22
  04909B  2A9B: 837e8205         cmp word ptr [bp - 0x7e], 5
  04909F  2A9F: 7504             jne 0x2aa5
  0490A1  2AA1: 8346aa04         add word ptr [bp - 0x56], 4
  0490A5  2AA5: 837e8207         cmp word ptr [bp - 0x7e], 7
  0490A9  2AA9: 7504             jne 0x2aaf
  0490AB  2AAB: 8346aa02         add word ptr [bp - 0x56], 2
  0490AF  2AAF: 837e8204         cmp word ptr [bp - 0x7e], 4
  0490B3  2AB3: 7504             jne 0x2ab9
  0490B5  2AB5: 83468404         add word ptr [bp - 0x7c], 4
  0490B9  2AB9: 837e8206         cmp word ptr [bp - 0x7e], 6
  0490BD  2ABD: 7504             jne 0x2ac3
  0490BF  2ABF: 83468402         add word ptr [bp - 0x7c], 2
  0490C3  2AC3: 837e8203         cmp word ptr [bp - 0x7e], 3
  0490C7  2AC7: 7504             jne 0x2acd
  0490C9  2AC9: 83469a04         add word ptr [bp - 0x66], 4
  0490CD  2ACD: 837e8200         cmp word ptr [bp - 0x7e], 0
  0490D1  2AD1: 7504             jne 0x2ad7
  0490D3  2AD3: 83469c02         add word ptr [bp - 0x64], 2
  0490D7  2AD7: 837e8202         cmp word ptr [bp - 0x7e], 2
  0490DB  2ADB: 7507             jne 0x2ae4
  0490DD  2ADD: ff469a           inc word ptr [bp - 0x66]
  0490E0  2AE0: 83469402         add word ptr [bp - 0x6c], 2
  0490E4  2AE4: 837e8201         cmp word ptr [bp - 0x7e], 1
  0490E8  2AE8: 7e22             jle 0x2b0c
  0490EA  2AEA: 83469402         add word ptr [bp - 0x6c], 2
  0490EE  2AEE: 837e8206         cmp word ptr [bp - 0x7e], 6
  0490F2  2AF2: 7d12             jge 0x2b06
  0490F4  2AF4: ff4694           inc word ptr [bp - 0x6c]
  0490F7  2AF7: f6468204         test byte ptr [bp - 0x7e], 4
  0490FB  2AFB: 7503             jne 0x2b00
  0490FD  2AFD: e95fff           jmp 0x2a5f
  049100  2B00: 83469802         add word ptr [bp - 0x68], 2
  049104  2B04: eb1c             jmp 0x2b22
  049106  2B06: ff469c           inc word ptr [bp - 0x64]
  049109  2B09: eb17             jmp 0x2b22
  04910B  2B0B: 90               nop 
  04910C  2B0C: 837e8201         cmp word ptr [bp - 0x7e], 1
  049110  2B10: 7506             jne 0x2b18
  049112  2B12: 83469804         add word ptr [bp - 0x68], 4
  049116  2B16: eb0a             jmp 0x2b22
  049118  2B18: 837e8200         cmp word ptr [bp - 0x7e], 0
  04911C  2B1C: 7504             jne 0x2b22
  04911E  2B1E: 8346a803         add word ptr [bp - 0x58], 3
  049122  2B22: ff4690           inc word ptr [bp - 0x70]
  049125  2B25: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  049129  2B29: 8a07             mov al, byte ptr [bx]
  04912B  2B2B: 2ae4             sub ah, ah
  04912D  2B2D: 40               inc ax
  04912E  2B2E: 40               inc ax
  04912F  2B2F: 3b4690           cmp ax, word ptr [bp - 0x70]
  049132  2B32: 7d03             jge 0x2b37
  049134  2B34: e9ef00           jmp 0x2c26
  049137  2B37: ff768a           push word ptr [bp - 0x76]
  04913A  2B3A: ff7690           push word ptr [bp - 0x70]
  04913D  2B3D: 9a02031f18       lcall 0x181f, 0x302
  049142  2B42: 83c404           add sp, 4
  049145  2B45: 0bc0             or ax, ax
  049147  2B47: 74d9             je 0x2b22
  049149  2B49: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04914D  2B4D: 8a4701           mov al, byte ptr [bx + 1]
  049150  2B50: 2ae4             sub ah, ah
  049152  2B52: 2b468a           sub ax, word ptr [bp - 0x76]
  049155  2B55: f7d8             neg ax
  049157  2B57: 40               inc ax
  049158  2B58: 40               inc ax
  049159  2B59: 8946a6           mov word ptr [bp - 0x5a], ax
  04915C  2B5C: 8bc8             mov cx, ax
  04915E  2B5E: c1e002           shl ax, 2
  049161  2B61: 03c1             add ax, cx
  049163  2B63: 8a0f             mov cl, byte ptr [bx]
  049165  2B65: 2aed             sub ch, ch
  049167  2B67: 2b4e90           sub cx, word ptr [bp - 0x70]
  04916A  2B6A: f7d9             neg cx
  04916C  2B6C: 41               inc cx
  04916D  2B6D: 41               inc cx
  04916E  2B6E: 894efc           mov word ptr [bp - 4], cx
  049171  2B71: 03c1             add ax, cx
  049173  2B73: 894692           mov word ptr [bp - 0x6e], ax
  049176  2B76: 8bf0             mov si, ax
  049178  2B78: 80ba68ff00       cmp byte ptr [bp + si - 0x98], 0
  04917D  2B7D: 75a3             jne 0x2b22
  04917F  2B7F: ff768a           push word ptr [bp - 0x76]
  049182  2B82: ff7690           push word ptr [bp - 0x70]
  049185  2B85: 9a8c071f18       lcall 0x181f, 0x78c
  04918A  2B8A: 83c404           add sp, 4
  04918D  2B8D: 894682           mov word ptr [bp - 0x7e], ax
  049190  2B90: 3d1b00           cmp ax, 0x1b
  049193  2B93: 7504             jne 0x2b99
  049195  2B95: ff8662ff         inc word ptr [bp - 0x9e]
  049199  2B99: 3d1c00           cmp ax, 0x1c
  04919C  2B9C: 7504             jne 0x2ba2
  04919E  2B9E: ff8666ff         inc word ptr [bp - 0x9a]
  0491A2  2BA2: 3d1800           cmp ax, 0x18
  0491A5  2BA5: 7504             jne 0x2bab
  0491A7  2BA7: 8346a804         add word ptr [bp - 0x58], 4
  0491AB  2BAB: 3d0800           cmp ax, 8
  0491AE  2BAE: 7c05             jl 0x2bb5
  0491B0  2BB0: 3d1000           cmp ax, 0x10
  0491B3  2BB3: 7c10             jl 0x2bc5
  0491B5  2BB5: 3d1000           cmp ax, 0x10
  0491B8  2BB8: 7d03             jge 0x2bbd
  0491BA  2BBA: e9a9fe           jmp 0x2a66
  0491BD  2BBD: 3d1800           cmp ax, 0x18
  0491C0  2BC0: 7c03             jl 0x2bc5
  0491C2  2BC2: e9a1fe           jmp 0x2a66
  0491C5  2BC5: ff4694           inc word ptr [bp - 0x6c]
  0491C8  2BC8: 3d0800           cmp ax, 8
  0491CB  2BCB: 7c0c             jl 0x2bd9
  0491CD  2BCD: 3d1000           cmp ax, 0x10
  0491D0  2BD0: 7d07             jge 0x2bd9
  0491D2  2BD2: 2d0800           sub ax, 8
  0491D5  2BD5: 898664ff         mov word ptr [bp - 0x9c], ax
  0491D9  2BD9: 837e8210         cmp word ptr [bp - 0x7e], 0x10
  0491DD  2BDD: 7c10             jl 0x2bef
  0491DF  2BDF: 837e8218         cmp word ptr [bp - 0x7e], 0x18
  0491E3  2BE3: 7d0a             jge 0x2bef
  0491E5  2BE5: 8b4682           mov ax, word ptr [bp - 0x7e]
  0491E8  2BE8: 2d1000           sub ax, 0x10
  0491EB  2BEB: 898664ff         mov word ptr [bp - 0x9c], ax
  0491EF  2BEF: 83be64ff03       cmp word ptr [bp - 0x9c], 3
  0491F4  2BF4: 7d03             jge 0x2bf9
  0491F6  2BF6: e963fe           jmp 0x2a5c
  0491F9  2BF9: ff468e           inc word ptr [bp - 0x72]
  0491FC  2BFC: ff4698           inc word ptr [bp - 0x68]
  0491FF  2BFF: 83be64ff05       cmp word ptr [bp - 0x9c], 5
  049204  2C04: 7504             jne 0x2c0a
  049206  2C06: 8346aa02         add word ptr [bp - 0x56], 2
  04920A  2C0A: 83be64ff04       cmp word ptr [bp - 0x9c], 4
  04920F  2C0F: 7504             jne 0x2c15
  049211  2C11: 83468402         add word ptr [bp - 0x7c], 2
  049215  2C15: 83be64ff03       cmp word ptr [bp - 0x9c], 3
  04921A  2C1A: 7403             je 0x2c1f
  04921C  2C1C: e903ff           jmp 0x2b22
  04921F  2C1F: 83469a02         add word ptr [bp - 0x66], 2
  049223  2C23: e9fcfe           jmp 0x2b22
  049226  2C26: ff468a           inc word ptr [bp - 0x76]
  049229  2C29: 8a4701           mov al, byte ptr [bx + 1]
  04922C  2C2C: 2ae4             sub ah, ah
  04922E  2C2E: 40               inc ax
  04922F  2C2F: 40               inc ax
  049230  2C30: 3b468a           cmp ax, word ptr [bp - 0x76]
  049233  2C33: 7c0d             jl 0x2c42
  049235  2C35: 8a07             mov al, byte ptr [bx]
  049237  2C37: 2ae4             sub ah, ah
  049239  2C39: 48               dec ax
  04923A  2C3A: 48               dec ax
  04923B  2C3B: 894690           mov word ptr [bp - 0x70], ax
  04923E  2C3E: e9e4fe           jmp 0x2b25
  049241  2C41: 90               nop 
  049242  2C42: 8a4704           mov al, byte ptr [bx + 4]
  049245  2C45: 2ae4             sub ah, ah
  049247  2C47: 40               inc ax
  049248  2C48: 89865eff         mov word ptr [bp - 0xa2], ax
  04924C  2C4C: 8bc8             mov cx, ax
  04924E  2C4E: f7e9             imul cx
  049250  2C50: 898660ff         mov word ptr [bp - 0xa0], ax
  049254  2C54: c7468c0000       mov word ptr [bp - 0x74], 0
  049259  2C59: 2bc0             sub ax, ax
  04925B  2C5B: 8b5e8c           mov bx, word ptr [bp - 0x74]
  04925E  2C5E: d1e3             shl bx, 1
  049260  2C60: 8987589e         mov word ptr [bx - 0x61a8], ax
  049264  2C64: 8987789e         mov word ptr [bx - 0x6188], ax
  049268  2C68: ff468c           inc word ptr [bp - 0x74]
  04926B  2C6B: 837e8c10         cmp word ptr [bp - 0x74], 0x10
  04926F  2C6F: 7ce8             jl 0x2c59
  049271  2C71: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  049275  2C75: 8a4702           mov al, byte ptr [bx + 2]
  049278  2C78: 8bc8             mov cx, ax
  04927A  2C7A: 2ae4             sub ah, ah
  04927C  2C7C: be0700           mov si, 7
  04927F  2C7F: 2bf0             sub si, ax
  049281  2C81: 03865eff         add ax, word ptr [bp - 0xa2]
  049285  2C85: f76e94           imul word ptr [bp - 0x6c]
  049288  2C88: 99               cdq 
  049289  2C89: f7fe             idiv si
  04928B  2C8B: 0106789e         add word ptr [0x9e78], ax
  04928F  2C8F: 898e5cff         mov word ptr [bp - 0xa4], cx
  049293  2C93: 80f901           cmp cl, 1
  049296  2C96: 7604             jbe 0x2c9c
  049298  2C98: b101             mov cl, 1
  04929A  2C9A: eb02             jmp 0x2c9e
  04929C  2C9C: 2ac9             sub cl, cl
  04929E  2C9E: 8b8660ff         mov ax, word ptr [bp - 0xa0]
  0492A2  2CA2: c1e002           shl ax, 2
  0492A5  2CA5: d3f8             sar ax, cl
  0492A7  2CA7: a3589e           mov word ptr [0x9e58], ax
  0492AA  2CAA: 80be5cff01       cmp byte ptr [bp - 0xa4], 1
  0492AF  2CAF: 725e             jb 0x2d0f
  0492B1  2CB1: 80be5cff02       cmp byte ptr [bp - 0xa4], 2
  0492B6  2CB6: 723c             jb 0x2cf4
  0492B8  2CB8: 8b470c           mov ax, word ptr [bx + 0xc]
  0492BB  2CBB: 8b1e528d         mov bx, word ptr [0x8d52]
  0492BF  2CBF: 8a8f2a96         mov cl, byte ptr [bx - 0x69d6]
  0492C3  2CC3: 80e901           sub cl, 1
  0492C6  2CC6: 1ad2             sbb dl, dl
  0492C8  2CC8: f6d2             not dl
  0492CA  2CCA: 22ca             and cl, dl
  0492CC  2CCC: 80c101           add cl, 1
  0492CF  2CCF: 2aed             sub ch, ch
  0492D1  2CD1: 894ea2           mov word ptr [bp - 0x5e], cx
  0492D4  2CD4: 99               cdq 
  0492D5  2CD5: f7f9             idiv cx
  0492D7  2CD7: a3869e           mov word ptr [0x9e86], ax
  0492DA  2CDA: 8b8662ff         mov ax, word ptr [bp - 0x9e]
  0492DE  2CDE: c1e002           shl ax, 2
  0492E1  2CE1: 894686           mov word ptr [bp - 0x7a], ax
  0492E4  2CE4: 80be5cff02       cmp byte ptr [bp - 0xa4], 2
  0492E9  2CE9: 7605             jbe 0x2cf0
  0492EB  2CEB: d1e0             shl ax, 1
  0492ED  2CED: 894686           mov word ptr [bp - 0x7a], ax
  0492F0  2CF0: 0106869e         add word ptr [0x9e86], ax
  0492F4  2CF4: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0492F8  2CF8: 807f0201         cmp byte ptr [bx + 2], 1
  0492FC  2CFC: 7211             jb 0x2d0f
  0492FE  2CFE: 8b8666ff         mov ax, word ptr [bp - 0x9a]
  049302  2D02: d1e0             shl ax, 1
  049304  2D04: 038662ff         add ax, word ptr [bp - 0x9e]
  049308  2D08: 03469c           add ax, word ptr [bp - 0x64]
  04930B  2D0B: 0106849e         add word ptr [0x9e84], ax
  04930F  2D0F: 8b46a4           mov ax, word ptr [bp - 0x5c]
  049312  2D12: d1e0             shl ax, 1
  049314  2D14: 8b4e8e           mov cx, word ptr [bp - 0x72]
  049317  2D17: d1f9             sar cx, 1
  049319  2D19: 03c1             add ax, cx
  04931B  2D1B: 8a4f02           mov cl, byte ptr [bx + 2]
  04931E  2D1E: 2aed             sub ch, ch
  049320  2D20: 8bd1             mov dx, cx
  049322  2D22: 41               inc cx
  049323  2D23: 8bf2             mov si, dx
  049325  2D25: 99               cdq 
  049326  2D26: f7f9             idiv cx
  049328  2D28: 0106809e         add word ptr [0x9e80], ax
  04932C  2D2C: a1809e           mov ax, word ptr [0x9e80]
  04932F  2D2F: 03c6             add ax, si
  049331  2D31: d1e0             shl ax, 1
  049333  2D33: 99               cdq 
  049334  2D34: 33c2             xor ax, dx
  049336  2D36: 2bc2             sub ax, dx
  049338  2D38: c1f802           sar ax, 2
  04933B  2D3B: 33c2             xor ax, dx
  04933D  2D3D: 2bc2             sub ax, dx
  04933F  2D3F: d1e0             shl ax, 1
  049341  2D41: a3909e           mov word ptr [0x9e90], ax
  049344  2D44: 8b4684           mov ax, word ptr [bp - 0x7c]
  049347  2D47: 01067c9e         add word ptr [0x9e7c], ax
  04934B  2D4B: 8b46aa           mov ax, word ptr [bp - 0x56]
  04934E  2D4E: 01067a9e         add word ptr [0x9e7a], ax
  049352  2D52: 8bc6             mov ax, si
  049354  2D54: 03865eff         add ax, word ptr [bp - 0xa2]
  049358  2D58: f7ae5eff         imul word ptr [bp - 0xa2]
  04935C  2D5C: 8b4e98           mov cx, word ptr [bp - 0x68]
  04935F  2D5F: d1f9             sar cx, 1
  049361  2D61: 03c1             add ax, cx
  049363  2D63: 0346a8           add ax, word ptr [bp - 0x58]
  049366  2D66: a36e9e           mov word ptr [0x9e6e], ax
  049369  2D69: 8bc6             mov ax, si
  04936B  2D6B: 8b4e9a           mov cx, word ptr [bp - 0x66]
  04936E  2D6E: 010e7e9e         add word ptr [0x9e7e], cx
  049372  2D72: 03067e9e         add ax, word ptr [0x9e7e]
  049376  2D76: d1e0             shl ax, 1
  049378  2D78: 99               cdq 
  049379  2D79: 33c2             xor ax, dx
  04937B  2D7B: 2bc2             sub ax, dx
  04937D  2D7D: c1f802           sar ax, 2
  049380  2D80: 33c2             xor ax, dx
  049382  2D82: 2bc2             sub ax, dx
  049384  2D84: d1e0             shl ax, 1
  049386  2D86: a38e9e           mov word ptr [0x9e8e], ax
  049389  2D89: 034698           add ax, word ptr [bp - 0x68]
  04938C  2D8C: a35e9e           mov word ptr [0x9e5e], ax
  04938F  2D8F: b80600           mov ax, 6
  049392  2D92: 2bc6             sub ax, si
  049394  2D94: f7ae5eff         imul word ptr [bp - 0xa2]
  049398  2D98: 8b4ea8           mov cx, word ptr [bp - 0x58]
  04939B  2D9B: d1e1             shl cx, 1
  04939D  2D9D: 03c1             add ax, cx
  04939F  2D9F: 050500           add ax, 5
  0493A2  2DA2: a35c9e           mov word ptr [0x9e5c], ax
  0493A5  2DA5: 8b865eff         mov ax, word ptr [bp - 0xa2]
  0493A9  2DA9: d1e0             shl ax, 1
  0493AB  2DAB: 2bc6             sub ax, si
  0493AD  2DAD: 050700           add ax, 7
  0493B0  2DB0: d1e0             shl ax, 1
  0493B2  2DB2: a36c9e           mov word ptr [0x9e6c], ax
  0493B5  2DB5: 8b46a8           mov ax, word ptr [bp - 0x58]
  0493B8  2DB8: c1e003           shl ax, 3
  0493BB  2DBB: 0306809e         add ax, word ptr [0x9e80]
  0493BF  2DBF: a3709e           mov word ptr [0x9e70], ax
  0493C2  2DC2: 8bc6             mov ax, si
  0493C4  2DC4: d1e6             shl si, 1
  0493C6  2DC6: 03b65eff         add si, word ptr [bp - 0xa2]
  0493CA  2DCA: d1e6             shl si, 1
  0493CC  2DCC: 037698           add si, word ptr [bp - 0x68]
  0493CF  2DCF: d1e6             shl si, 1
  0493D1  2DD1: 89366a9e         mov word ptr [0x9e6a], si
  0493D5  2DD5: 8b8e5eff         mov cx, word ptr [bp - 0xa2]
  0493D9  2DD9: 83c103           add cx, 3
  0493DC  2DDC: 8bd0             mov dx, ax
  0493DE  2DDE: 40               inc ax
  0493DF  2DDF: 40               inc ax
  0493E0  2DE0: 8bf2             mov si, dx
  0493E2  2DE2: f7e9             imul cx
  0493E4  2DE4: 050800           add ax, 8
  0493E7  2DE7: a3729e           mov word ptr [0x9e72], ax
  0493EA  2DEA: 8bc6             mov ax, si
  0493EC  2DEC: f7ae5eff         imul word ptr [bp - 0xa2]
  0493F0  2DF0: 8b4ea8           mov cx, word ptr [bp - 0x58]
  0493F3  2DF3: d1f9             sar cx, 1
  0493F5  2DF5: fec1             inc cl
  0493F7  2DF7: d3e0             shl ax, cl
  0493F9  2DF9: a3749e           mov word ptr [0x9e74], ax
  0493FC  2DFC: 8a4707           mov al, byte ptr [bx + 7]
  0493FF  2DFF: 98               cwde 
  049400  2E00: 2d0700           sub ax, 7
  049403  2E03: f7d8             neg ax
  049405  2E05: 2bc6             sub ax, si
  049407  2E07: c1e002           shl ax, 2
  04940A  2E0A: a3769e           mov word ptr [0x9e76], ax
  04940D  2E0D: 8b470a           mov ax, word ptr [bx + 0xa]
  049410  2E10: 8b3e528d         mov di, word ptr [0x8d52]
  049414  2E14: 8a8d2a96         mov cl, byte ptr [di - 0x69d6]
  049418  2E18: d0e9             shr cl, 1
  04941A  2E1A: 2aed             sub ch, ch
  04941C  2E1C: 41               inc cx
  04941D  2E1D: 99               cdq 
  04941E  2E1E: f7f9             idiv cx
  049420  2E20: a3889e           mov word ptr [0x9e88], ax
  049423  2E23: 8a4708           mov al, byte ptr [bx + 8]
  049426  2E26: 98               cwde 
  049427  2E27: 2d0900           sub ax, 9
  04942A  2E2A: f7d8             neg ax
  04942C  2E2C: 2bc6             sub ax, si
  04942E  2E2E: c1e002           shl ax, 2
  049431  2E31: a3689e           mov word ptr [0x9e68], ax
  049434  2E34: 2bc0             sub ax, ax
  049436  2E36: a3969e           mov word ptr [0x9e96], ax
  049439  2E39: 89468c           mov word ptr [bp - 0x74], ax
  04943C  2E3C: eb1e             jmp 0x2e5c
  04943E  2E3E: 6a32             push 0x32
  049440  2E40: 6a00             push 0
  049442  2E42: 8b5e8c           mov bx, word ptr [bp - 0x74]
  049445  2E45: d1e3             shl bx, 1
  049447  2E47: ffb7589e         push word ptr [bx - 0x61a8]
  04944B  2E4B: 8bf3             mov si, bx
  04944D  2E4D: 9a5c031f18       lcall 0x181f, 0x35c
  049452  2E52: 83c406           add sp, 6
  049455  2E55: 8984589e         mov word ptr [si - 0x61a8], ax
  049459  2E59: ff468c           inc word ptr [bp - 0x74]
  04945C  2E5C: 837e8c10         cmp word ptr [bp - 0x74], 0x10
  049460  2E60: 7cdc             jl 0x2e3e
  049462  2E62: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  049466  2E66: f6470304         test byte ptr [bx + 3], 4
  04946A  2E6A: 744b             je 0x2eb7
  04946C  2E6C: c7468c0000       mov word ptr [bp - 0x74], 0
  049471  2E71: 8b5e8c           mov bx, word ptr [bp - 0x74]
  049474  2E74: d1e3             shl bx, 1
  049476  2E76: d1a7589e         shl word ptr [bx - 0x61a8], 1
  04947A  2E7A: ff468c           inc word ptr [bp - 0x74]
  04947D  2E7D: 837e8c07         cmp word ptr [bp - 0x74], 7
  049481  2E81: 7eee             jle 0x2e71
  049483  2E83: c7468c0d00       mov word ptr [bp - 0x74], 0xd
  049488  2E88: 8b5e8c           mov bx, word ptr [bp - 0x74]
  04948B  2E8B: d1e3             shl bx, 1
  04948D  2E8D: 8b87589e         mov ax, word ptr [bx - 0x61a8]
  049491  2E91: d1f8             sar ax, 1
  049493  2E93: 0187589e         add word ptr [bx - 0x61a8], ax
  049497  2E97: ff468c           inc word ptr [bp - 0x74]
  04949A  2E9A: 837e8c0f         cmp word ptr [bp - 0x74], 0xf
  04949E  2E9E: 7ee8             jle 0x2e88
  0494A0  2EA0: c7468c0700       mov word ptr [bp - 0x74], 7
  0494A5  2EA5: 8b5e8c           mov bx, word ptr [bp - 0x74]
  0494A8  2EA8: d1e3             shl bx, 1
  0494AA  2EAA: d1a7789e         shl word ptr [bx - 0x6188], 1
  0494AE  2EAE: ff468c           inc word ptr [bp - 0x74]
  0494B1  2EB1: 837e8c10         cmp word ptr [bp - 0x74], 0x10
  0494B5  2EB5: 7cee             jl 0x2ea5
  0494B7  2EB7: c7468c0000       mov word ptr [bp - 0x74], 0
  0494BC  2EBC: e9d900           jmp 0x2f98
  0494BF  2EBF: 90               nop 
  0494C0  2EC0: 0bd2             or dx, dx
  0494C2  2EC2: 7d16             jge 0x2eda
  0494C4  2EC4: 8bc2             mov ax, dx
  0494C6  2EC6: 053200           add ax, 0x32
  0494C9  2EC9: b96400           mov cx, 0x64
  0494CC  2ECC: 99               cdq 
  0494CD  2ECD: f7f9             idiv cx
  0494CF  2ECF: d1e0             shl ax, 1
  0494D1  2ED1: 8b5e8c           mov bx, word ptr [bp - 0x74]
  0494D4  2ED4: d1e3             shl bx, 1
  0494D6  2ED6: 0187789e         add word ptr [bx - 0x6188], ax
  0494DA  2EDA: f606940804       test byte ptr [0x894], 4
  0494DF  2EDF: 7456             je 0x2f37
  0494E1  2EE1: 8b5e8c           mov bx, word ptr [bp - 0x74]
  0494E4  2EE4: d1e3             shl bx, 1
  0494E6  2EE6: 83bf789e00       cmp word ptr [bx - 0x6188], 0
  0494EB  2EEB: 7507             jne 0x2ef4
  0494ED  2EED: 83bf589e00       cmp word ptr [bx - 0x61a8], 0
  0494F2  2EF2: 7443             je 0x2f37
  0494F4  2EF4: 8b5e8c           mov bx, word ptr [bp - 0x74]
  0494F7  2EF7: d1e3             shl bx, 1
  0494F9  2EF9: ffb7589e         push word ptr [bx - 0x61a8]
  0494FD  2EFD: ffb7789e         push word ptr [bx - 0x6188]
  049501  2F01: ffb7c097         push word ptr [bx - 0x6840]
  049505  2F05: 9a22001f18       lcall 0x181f, 0x22
  04950A  2F0A: 83c402           add sp, 2
  04950D  2F0D: 52               push dx
  04950E  2F0E: 50               push ax
  04950F  2F0F: 684b15           push 0x154b
  049512  2F12: 8d46ac           lea ax, [bp - 0x54]
  049515  2F15: 50               push ax
  049516  2F16: 9a480b1d0d       lcall 0xd1d, 0xb48
  04951B  2F1B: 83c40c           add sp, 0xc
  04951E  2F1E: 6a0f             push 0xf
  049520  2F20: 8b468c           mov ax, word ptr [bp - 0x74]
  049523  2F23: 40               inc ax
  049524  2F24: c1e003           shl ax, 3
  049527  2F27: 50               push ax
  049528  2F28: 6a01             push 1
  04952A  2F2A: 8d46ac           lea ax, [bp - 0x54]
  04952D  2F2D: 16               push ss
  04952E  2F2E: 50               push ax
  04952F  2F2F: 9a3c011f18       lcall 0x181f, 0x13c
  049534  2F34: 83c40a           add sp, 0xa
  049537  2F37: 8b5e8c           mov bx, word ptr [bp - 0x74]
  04953A  2F3A: d1e3             shl bx, 1
  04953C  2F3C: 8b87789e         mov ax, word ptr [bx - 0x6188]
  049540  2F40: 89469e           mov word ptr [bp - 0x62], ax
  049543  2F43: 8b87589e         mov ax, word ptr [bx - 0x61a8]
  049547  2F47: d1f8             sar ax, 1
  049549  2F49: 2987789e         sub word ptr [bx - 0x6188], ax
  04954D  2F4D: 899e5cff         mov word ptr [bp - 0xa4], bx
  049551  2F51: 837e9600         cmp word ptr [bp - 0x6a], 0
  049555  2F55: 7e05             jle 0x2f5c
  049557  2F57: b80100           mov ax, 1
  04955A  2F5A: eb02             jmp 0x2f5e
  04955C  2F5C: 2bc0             sub ax, ax
  04955E  2F5E: 3b87789e         cmp ax, word ptr [bx - 0x6188]
  049562  2F62: 7d04             jge 0x2f68
  049564  2F64: 8b87789e         mov ax, word ptr [bx - 0x6188]
  049568  2F68: 8987789e         mov word ptr [bx - 0x6188], ax
  04956C  2F6C: 837ea000         cmp word ptr [bp - 0x60], 0
  049570  2F70: 7e06             jle 0x2f78
  049572  2F72: b80100           mov ax, 1
  049575  2F75: eb03             jmp 0x2f7a
  049577  2F77: 90               nop 
  049578  2F78: 2bc0             sub ax, ax
  04957A  2F7A: 8b4e9e           mov cx, word ptr [bp - 0x62]
  04957D  2F7D: d1f9             sar cx, 1
  04957F  2F7F: 8b9e5cff         mov bx, word ptr [bp - 0xa4]
  049583  2F83: 298f589e         sub word ptr [bx - 0x61a8], cx
  049587  2F87: 8b8f589e         mov cx, word ptr [bx - 0x61a8]
  04958B  2F8B: 3bc8             cmp cx, ax
  04958D  2F8D: 7d02             jge 0x2f91
  04958F  2F8F: 8bc8             mov cx, ax
  049591  2F91: 898f589e         mov word ptr [bx - 0x61a8], cx
  049595  2F95: ff468c           inc word ptr [bp - 0x74]
  049598  2F98: 837e8c10         cmp word ptr [bp - 0x74], 0x10
  04959C  2F9C: 7d40             jge 0x2fde
  04959E  2F9E: 8b5e8c           mov bx, word ptr [bp - 0x74]
  0495A1  2FA1: d1e3             shl bx, 1
  0495A3  2FA3: 8b87789e         mov ax, word ptr [bx - 0x6188]
  0495A7  2FA7: 894696           mov word ptr [bp - 0x6a], ax
  0495AA  2FAA: 8b87589e         mov ax, word ptr [bx - 0x61a8]
  0495AE  2FAE: 8946a0           mov word ptr [bp - 0x60], ax
  0495B1  2FB1: 8bcb             mov cx, bx
  0495B3  2FB3: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0495B7  2FB7: 8bf1             mov si, cx
  0495B9  2FB9: 8b500e           mov dx, word ptr [bx + si + 0xe]
  0495BC  2FBC: 8956fe           mov word ptr [bp - 2], dx
  0495BF  2FBF: 0bd2             or dx, dx
  0495C1  2FC1: 7f03             jg 0x2fc6
  0495C3  2FC3: e9fafe           jmp 0x2ec0
  0495C6  2FC6: b8ceff           mov ax, 0xffce
  0495C9  2FC9: 2bc2             sub ax, dx
  0495CB  2FCB: bb6400           mov bx, 0x64
  0495CE  2FCE: 99               cdq 
  0495CF  2FCF: f7fb             idiv bx
  0495D1  2FD1: d1e0             shl ax, 1
  0495D3  2FD3: 0346a0           add ax, word ptr [bp - 0x60]
  0495D6  2FD6: 8984589e         mov word ptr [si - 0x61a8], ax
  0495DA  2FDA: e9fdfe           jmp 0x2eda
  0495DD  2FDD: 90               nop 
  0495DE  2FDE: f606940804       test byte ptr [0x894], 4
  0495E3  2FE3: 7417             je 0x2ffc
  0495E5  2FE5: 6a00             push 0
  0495E7  2FE7: 684001           push 0x140
  0495EA  2FEA: 68c800           push 0xc8
  0495ED  2FED: 2bc0             sub ax, ax
  0495EF  2FEF: 99               cdq 
  0495F0  2FF0: 2bdb             sub bx, bx
  0495F2  2FF2: 9ae2001f18       lcall 0x181f, 0xe2
  0495F7  2FF7: 9ae0031f18       lcall 0x181f, 0x3e0
  0495FC  2FFC: 5e               pop si
  0495FD  2FFD: 5f               pop di
  0495FE  2FFE: c9               leave 
  0495FF  2FFF: cb               retf 

; ---- func_049600  size=3451  insns=1138  prologue=ENTER 0x00D8,0  terminal=RETF ----
  049600  3000: c8d80000         enter 0xd8, 0
  049604  3004: 57               push di
  049605  3005: 56               push si
  049606  3006: c7863affffff     mov word ptr [bp - 0xc6], 0xffff
  04960C  300C: c7863cff0100     mov word ptr [bp - 0xc4], 1
  049612  3012: 837e0a00         cmp word ptr [bp + 0xa], 0
  049616  3016: 7c18             jl 0x3030
  049618  3018: 837e0a04         cmp word ptr [bp + 0xa], 4
  04961C  301C: 7d12             jge 0x3030
  04961E  301E: 6b5e0a34         imul bx, word ptr [bp + 0xa], 0x34
  049622  3022: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  049627  3027: 7507             jne 0x3030
  049629  3029: c746fa0100       mov word ptr [bp - 6], 1
  04962E  302E: eb05             jmp 0x3035
  049630  3030: c746fa0000       mov word ptr [bp - 6], 0
  049635  3035: 837efa00         cmp word ptr [bp - 6], 0
  049639  3039: 743c             je 0x3077
  04963B  303B: 6a03             push 3
  04963D  303D: 6a00             push 0
  04963F  303F: 9ad4041f18       lcall 0x181f, 0x4d4
  049644  3044: 83c404           add sp, 4
  049647  3047: 0bc0             or ax, ax
  049649  3049: 752c             jne 0x3077
  04964B  304B: 6a05             push 5
  04964D  304D: 9a98041f18       lcall 0x181f, 0x498
  049652  3052: 83c402           add sp, 2
  049655  3055: 833e528d00       cmp word ptr [0x8d52], 0
  04965A  305A: 750a             jne 0x3066
  04965C  305C: 6a07             push 7
  04965E  305E: 9a98041f18       lcall 0x181f, 0x498
  049663  3063: 83c402           add sp, 2
  049666  3066: 833e528d01       cmp word ptr [0x8d52], 1
  04966B  306B: 750a             jne 0x3077
  04966D  306D: 6a06             push 6
  04966F  306F: 9a98041f18       lcall 0x181f, 0x498
  049674  3074: 83c402           add sp, 2
  049677  3077: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04967B  307B: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  049680  3080: 7207             jb 0x3089
  049682  3082: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  049687  3087: 7609             jbe 0x3092
  049689  3089: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04968D  308D: c687583100       mov byte ptr [bx + 0x3158], 0
  049692  3092: c78640ff0000     mov word ptr [bp - 0xc0], 0
  049698  3098: 8a8640ff         mov al, byte ptr [bp - 0xc0]
  04969C  309C: 8bb640ff         mov si, word ptr [bp - 0xc0]
  0496A0  30A0: 884286           mov byte ptr [bp + si - 0x7a], al
  0496A3  30A3: 88826aff         mov byte ptr [bp + si - 0x96], al
  0496A7  30A7: ff8640ff         inc word ptr [bp - 0xc0]
  0496AB  30AB: 83be40ff10       cmp word ptr [bp - 0xc0], 0x10
  0496B0  30B0: 7ce6             jl 0x3098
  0496B2  30B2: ff36a683         push word ptr [0x83a6]
  0496B6  30B6: 9aca041f18       lcall 0x181f, 0x4ca
  0496BB  30BB: 83c402           add sp, 2
  0496BE  30BE: 0e               push cs
  0496BF  30BF: e88123           call 0x5443
  0496C2  30C2: a1789e           mov ax, word ptr [0x9e78]
  0496C5  30C5: 89469a           mov word ptr [bp - 0x66], ax
  0496C8  30C8: c706789e0000     mov word ptr [0x9e78], 0
  0496CE  30CE: a1929e           mov ax, word ptr [0x9e92]
  0496D1  30D1: 39469a           cmp word ptr [bp - 0x66], ax
  0496D4  30D4: 7e06             jle 0x30dc
  0496D6  30D6: c706589e0000     mov word ptr [0x9e58], 0
  0496DC  30DC: 8d866aff         lea ax, [bp - 0x96]
  0496E0  30E0: 16               push ss
  0496E1  30E1: 50               push ax
  0496E2  30E2: 1e               push ds
  0496E3  30E3: 68789e           push 0x9e78
  0496E6  30E6: b81000           mov ax, 0x10
  0496E9  30E9: 9ad00e1f19       lcall 0x191f, 0xed0
  0496EE  30EE: c78640ff0100     mov word ptr [bp - 0xc0], 1
  0496F4  30F4: 8d9e7aff         lea bx, [bp - 0x86]
  0496F8  30F8: 2b9e40ff         sub bx, word ptr [bp - 0xc0]
  0496FC  30FC: 8a07             mov al, byte ptr [bx]
  0496FE  30FE: 8bc8             mov cx, ax
  049700  3100: 98               cwde 
  049701  3101: 8bf0             mov si, ax
  049703  3103: d1e6             shl si, 1
  049705  3105: c784589e0000     mov word ptr [si - 0x61a8], 0
  04970B  310B: 0ac9             or cl, cl
  04970D  310D: 7503             jne 0x3112
  04970F  310F: c6070c           mov byte ptr [bx], 0xc
  049712  3112: ff8640ff         inc word ptr [bp - 0xc0]
  049716  3116: 83be40ff03       cmp word ptr [bp - 0xc0], 3
  04971B  311B: 7ed7             jle 0x30f4
  04971D  311D: 837e0a00         cmp word ptr [bp + 0xa], 0
  049721  3121: 7d03             jge 0x3126
  049723  3123: e9510c           jmp 0x3d77
  049726  3126: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04972A  312A: 80bf503100       cmp byte ptr [bx + 0x3150], 0
  04972F  312F: 7503             jne 0x3134
  049731  3131: e94701           jmp 0x327b
  049734  3134: c746840000       mov word ptr [bp - 0x7c], 0
  049739  3139: 80bf503101       cmp byte ptr [bx + 0x3150], 1
  04973E  313E: 7703             ja 0x3143
  049740  3140: e91501           jmp 0x3258
  049743  3143: 837efa00         cmp word ptr [bp - 6], 0
  049747  3147: 7515             jne 0x315e
  049749  3149: 8a875031         mov al, byte ptr [bx + 0x3150]
  04974D  314D: 2ae4             sub ah, ah
  04974F  314F: 48               dec ax
  049750  3150: 50               push ax
  049751  3151: 6a00             push 0
  049753  3153: 9ad4041f18       lcall 0x181f, 0x4d4
  049758  3158: 83c404           add sp, 4
  04975B  315B: e9f700           jmp 0x3255
  04975E  315E: 8d1e7c08         lea bx, [0x87c]
  049762  3162: 8d065615         lea ax, [0x1556]
  049766  3166: 2bd2             sub dx, dx
  049768  3168: 9a82011f19       lcall 0x191f, 0x182
  04976D  316D: 89469c           mov word ptr [bp - 0x64], ax
  049770  3170: 89569e           mov word ptr [bp - 0x62], dx
  049773  3173: 0bd0             or dx, ax
  049775  3175: 7503             jne 0x317a
  049777  3177: e9e80b           jmp 0x3d62
  04977A  317A: c78640ff0000     mov word ptr [bp - 0xc0], 0
  049780  3180: eb73             jmp 0x31f5
  049782  3182: ffb640ff         push word ptr [bp - 0xc0]
  049786  3186: ff7606           push word ptr [bp + 6]
  049789  3189: 9ae60b1f18       lcall 0x181f, 0xbe6
  04978E  318E: 83c404           add sp, 4
  049791  3191: 89863aff         mov word ptr [bp - 0xc6], ax
  049795  3195: 6a0a             push 0xa
  049797  3197: 8d46aa           lea ax, [bp - 0x56]
  04979A  319A: 50               push ax
  04979B  319B: ffb640ff         push word ptr [bp - 0xc0]
  04979F  319F: ff7606           push word ptr [bp + 6]
  0497A2  31A2: 9a680c1f18       lcall 0x181f, 0xc68
  0497A7  31A7: 83c404           add sp, 4
  0497AA  31AA: 894698           mov word ptr [bp - 0x68], ax
  0497AD  31AD: 50               push ax
  0497AE  31AE: 9afa081d0d       lcall 0xd1d, 0x8fa
  0497B3  31B3: 83c406           add sp, 6
  0497B6  31B6: 8d46aa           lea ax, [bp - 0x56]
  0497B9  31B9: 50               push ax
  0497BA  31BA: 9a78011f18       lcall 0x181f, 0x178
  0497BF  31BF: 83c402           add sp, 2
  0497C2  31C2: 8b9e3aff         mov bx, word ptr [bp - 0xc6]
  0497C6  31C6: d1e3             shl bx, 1
  0497C8  31C8: ffb7c097         push word ptr [bx - 0x6840]
  0497CC  31CC: 8d46aa           lea ax, [bp - 0x56]
  0497CF  31CF: 50               push ax
  0497D0  31D0: 9a6e011f18       lcall 0x181f, 0x16e
  0497D5  31D5: 83c404           add sp, 4
  0497D8  31D8: 8b8640ff         mov ax, word ptr [bp - 0xc0]
  0497DC  31DC: 40               inc ax
  0497DD  31DD: 50               push ax
  0497DE  31DE: 8d46aa           lea ax, [bp - 0x56]
  0497E1  31E1: 16               push ss
  0497E2  31E2: 50               push ax
  0497E3  31E3: ff769e           push word ptr [bp - 0x62]
  0497E6  31E6: ff769c           push word ptr [bp - 0x64]
  0497E9  31E9: 9a76011f19       lcall 0x191f, 0x176
  0497EE  31EE: 83c40a           add sp, 0xa
  0497F1  31F1: ff8640ff         inc word ptr [bp - 0xc0]
  0497F5  31F5: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0497F9  31F9: 8a875031         mov al, byte ptr [bx + 0x3150]
  0497FD  31FD: 2ae4             sub ah, ah
  0497FF  31FF: 3b8640ff         cmp ax, word ptr [bp - 0xc0]
  049803  3203: 7e03             jle 0x3208
  049805  3205: e97aff           jmp 0x3182
  049808  3208: 6a63             push 0x63
  04980A  320A: ff36fa2d         push word ptr [0x2dfa]
  04980E  320E: 9a22001f18       lcall 0x181f, 0x22
  049813  3213: 83c402           add sp, 2
  049816  3216: 52               push dx
  049817  3217: 50               push ax
  049818  3218: ff769e           push word ptr [bp - 0x62]
  04981B  321B: ff769c           push word ptr [bp - 0x64]
  04981E  321E: 9a76011f19       lcall 0x191f, 0x176
  049823  3223: 83c40a           add sp, 0xa
  049826  3226: ff769e           push word ptr [bp - 0x62]
  049829  3229: ff769c           push word ptr [bp - 0x64]
  04982C  322C: 9a6a011f19       lcall 0x191f, 0x16a
  049831  3231: 8946a4           mov word ptr [bp - 0x5c], ax
  049834  3234: ff769e           push word ptr [bp - 0x62]
  049837  3237: ff769c           push word ptr [bp - 0x64]
  04983A  323A: 9aa8011f19       lcall 0x191f, 0x1a8
  04983F  323F: 837ea400         cmp word ptr [bp - 0x5c], 0
  049843  3243: 7503             jne 0x3248
  049845  3245: e91a0b           jmp 0x3d62
  049848  3248: 837ea463         cmp word ptr [bp - 0x5c], 0x63
  04984C  324C: 7503             jne 0x3251
  04984E  324E: e9110b           jmp 0x3d62
  049851  3251: 8b46a4           mov ax, word ptr [bp - 0x5c]
  049854  3254: 48               dec ax
  049855  3255: 894684           mov word ptr [bp - 0x7c], ax
  049858  3258: ff7684           push word ptr [bp - 0x7c]
  04985B  325B: ff7606           push word ptr [bp + 6]
  04985E  325E: 9ae60b1f18       lcall 0x181f, 0xbe6
  049863  3263: 83c404           add sp, 4
  049866  3266: 89863aff         mov word ptr [bp - 0xc6], ax
  04986A  326A: ff7684           push word ptr [bp - 0x7c]
  04986D  326D: ff7606           push word ptr [bp + 6]
  049870  3270: 9a680c1f18       lcall 0x181f, 0xc68
  049875  3275: 83c404           add sp, 4
  049878  3278: 894698           mov word ptr [bp - 0x68], ax
  04987B  327B: ff760a           push word ptr [bp + 0xa]
  04987E  327E: ff36528d         push word ptr [0x8d52]
  049882  3282: 9a0c031f18       lcall 0x181f, 0x30c
  049887  3287: 83c404           add sp, 4
  04988A  328A: 89862cff         mov word ptr [bp - 0xd4], ax
  04988E  328E: 83be3aff00       cmp word ptr [bp - 0xc6], 0
  049893  3293: 7d03             jge 0x3298
  049895  3295: e9da03           jmp 0x3672
  049898  3298: 837efa00         cmp word ptr [bp - 6], 0
  04989C  329C: 7503             jne 0x32a1
  04989E  329E: e9fb00           jmp 0x339c
  0498A1  32A1: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  0498A5  32A5: 8a4708           mov al, byte ptr [bx + 8]
  0498A8  32A8: 98               cwde 
  0498A9  32A9: 3b863aff         cmp ax, word ptr [bp - 0xc6]
  0498AD  32AD: 741a             je 0x32c9
  0498AF  32AF: 8a4709           mov al, byte ptr [bx + 9]
  0498B2  32B2: 98               cwde 
  0498B3  32B3: 3b863aff         cmp ax, word ptr [bp - 0xc6]
  0498B7  32B7: 7410             je 0x32c9
  0498B9  32B9: 8b9e3aff         mov bx, word ptr [bp - 0xc6]
  0498BD  32BD: d1e3             shl bx, 1
  0498BF  32BF: 83bf589e00       cmp word ptr [bx - 0x61a8], 0
  0498C4  32C4: 7403             je 0x32c9
  0498C6  32C6: e9a900           jmp 0x3372
  0498C9  32C9: 8b9e3aff         mov bx, word ptr [bp - 0xc6]
  0498CD  32CD: d1e3             shl bx, 1
  0498CF  32CF: ffb7c097         push word ptr [bx - 0x6840]
  0498D3  32D3: 6a00             push 0
  0498D5  32D5: 9a38041f18       lcall 0x181f, 0x438
  0498DA  32DA: 83c404           add sp, 4
  0498DD  32DD: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  0498E1  32E1: 807f0800         cmp byte ptr [bx + 8], 0
  0498E5  32E5: 7c0e             jl 0x32f5
  0498E7  32E7: 8a4708           mov al, byte ptr [bx + 8]
  0498EA  32EA: 98               cwde 
  0498EB  32EB: 8bd8             mov bx, ax
  0498ED  32ED: d1e3             shl bx, 1
  0498EF  32EF: c787589e0000     mov word ptr [bx - 0x61a8], 0
  0498F5  32F5: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  0498F9  32F9: 807f0900         cmp byte ptr [bx + 9], 0
  0498FD  32FD: 7c0e             jl 0x330d
  0498FF  32FF: 8a4709           mov al, byte ptr [bx + 9]
  049902  3302: 98               cwde 
  049903  3303: 8bd8             mov bx, ax
  049905  3305: d1e3             shl bx, 1
  049907  3307: c787589e0000     mov word ptr [bx - 0x61a8], 0
  04990D  330D: 8d4686           lea ax, [bp - 0x7a]
  049910  3310: 16               push ss
  049911  3311: 50               push ax
  049912  3312: 1e               push ds
  049913  3313: 68589e           push 0x9e58
  049916  3316: b81000           mov ax, 0x10
  049919  3319: 9ad00e1f19       lcall 0x191f, 0xed0
  04991E  331E: 8a4695           mov al, byte ptr [bp - 0x6b]
  049921  3321: 98               cwde 
  049922  3322: 8bd8             mov bx, ax
  049924  3324: d1e3             shl bx, 1
  049926  3326: ffb7c097         push word ptr [bx - 0x6840]
  04992A  332A: 6a01             push 1
  04992C  332C: 9a38041f18       lcall 0x181f, 0x438
  049931  3331: 83c404           add sp, 4
  049934  3334: 8a4694           mov al, byte ptr [bp - 0x6c]
  049937  3337: 98               cwde 
  049938  3338: 8bd8             mov bx, ax
  04993A  333A: d1e3             shl bx, 1
  04993C  333C: ffb7c097         push word ptr [bx - 0x6840]
  049940  3340: 6a02             push 2
  049942  3342: 9a38041f18       lcall 0x181f, 0x438
  049947  3347: 83c404           add sp, 4
  04994A  334A: 8a4693           mov al, byte ptr [bp - 0x6d]
  04994D  334D: 98               cwde 
  04994E  334E: 8bd8             mov bx, ax
  049950  3350: d1e3             shl bx, 1
  049952  3352: ffb7c097         push word ptr [bx - 0x6840]
  049956  3356: 6a03             push 3
  049958  3358: 9a38041f18       lcall 0x181f, 0x438
  04995D  335D: 83c404           add sp, 4
  049960  3360: ff36528d         push word ptr [0x8d52]
  049964  3364: 686115           push 0x1561
  049967  3367: 9a9c011f19       lcall 0x191f, 0x19c
  04996C  336C: 83c404           add sp, 4
  04996F  336F: e9f009           jmp 0x3d62
  049972  3372: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  049976  3376: 8a4707           mov al, byte ptr [bx + 7]
  049979  3379: 98               cwde 
  04997A  337A: 3b863aff         cmp ax, word ptr [bp - 0xc6]
  04997E  337E: 751c             jne 0x339c
  049980  3380: 8bd8             mov bx, ax
  049982  3382: d1e3             shl bx, 1
  049984  3384: ffb7c097         push word ptr [bx - 0x6840]
  049988  3388: 6a00             push 0
  04998A  338A: 9a38041f18       lcall 0x181f, 0x438
  04998F  338F: 83c404           add sp, 4
  049992  3392: ff36528d         push word ptr [0x8d52]
  049996  3396: 686a15           push 0x156a
  049999  3399: ebcc             jmp 0x3367
  04999B  339B: 90               nop 
  04999C  339C: 6a05             push 5
  04999E  339E: 6a01             push 1
  0499A0  33A0: 9ad4041f18       lcall 0x181f, 0x4d4
  0499A5  33A5: 83c404           add sp, 4
  0499A8  33A8: 894680           mov word ptr [bp - 0x80], ax
  0499AB  33AB: c746a60600       mov word ptr [bp - 0x5a], 6
  0499B0  33B0: 83be3aff08       cmp word ptr [bp - 0xc6], 8
  0499B5  33B5: 7e05             jle 0x33bc
  0499B7  33B7: c746a60700       mov word ptr [bp - 0x5a], 7
  0499BC  33BC: 83be3aff0d       cmp word ptr [bp - 0xc6], 0xd
  0499C1  33C1: 750f             jne 0x33d2
  0499C3  33C3: 6a07             push 7
  0499C5  33C5: 6a00             push 0
  0499C7  33C7: 9ad4041f18       lcall 0x181f, 0x4d4
  0499CC  33CC: 83c404           add sp, 4
  0499CF  33CF: 2946a6           sub word ptr [bp - 0x5a], ax
  0499D2  33D2: 83be3aff0f       cmp word ptr [bp - 0xc6], 0xf
  0499D7  33D7: 7510             jne 0x33e9
  0499D9  33D9: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0499DD  33DD: 8a4707           mov al, byte ptr [bx + 7]
  0499E0  33E0: 98               cwde 
  0499E1  33E1: 2d0c00           sub ax, 0xc
  0499E4  33E4: f7d8             neg ax
  0499E6  33E6: 0146a6           add word ptr [bp - 0x5a], ax
  0499E9  33E9: 83be3aff08       cmp word ptr [bp - 0xc6], 8
  0499EE  33EE: 7510             jne 0x3400
  0499F0  33F0: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0499F4  33F4: 8a4708           mov al, byte ptr [bx + 8]
  0499F7  33F7: 98               cwde 
  0499F8  33F8: 2d0a00           sub ax, 0xa
  0499FB  33FB: f7d8             neg ax
  0499FD  33FD: 0146a6           add word ptr [bp - 0x5a], ax
  049A00  3400: 83be3aff0e       cmp word ptr [bp - 0xc6], 0xe
  049A05  3405: 7503             jne 0x340a
  049A07  3407: ff46a6           inc word ptr [bp - 0x5a]
  049A0A  340A: ffb62cff         push word ptr [bp - 0xd4]
  049A0E  340E: 9a600a1f18       lcall 0x181f, 0xa60
  049A13  3413: 83c402           add sp, 2
  049A16  3416: d1e0             shl ax, 1
  049A18  3418: 894682           mov word ptr [bp - 0x7e], ax
  049A1B  341B: 83be3aff0f       cmp word ptr [bp - 0xc6], 0xf
  049A20  3420: 7407             je 0x3429
  049A22  3422: 83be3aff08       cmp word ptr [bp - 0xc6], 8
  049A27  3427: 7505             jne 0x342e
  049A29  3429: c746820000       mov word ptr [bp - 0x7e], 0
  049A2E  342E: 8b9e3aff         mov bx, word ptr [bp - 0xc6]
  049A32  3432: d1e3             shl bx, 1
  049A34  3434: 83bf589e14       cmp word ptr [bx - 0x61a8], 0x14
  049A39  3439: 7c03             jl 0x343e
  049A3B  343B: d17e82           sar word ptr [bp - 0x7e], 1
  049A3E  343E: 6a00             push 0
  049A40  3440: 6a64             push 0x64
  049A42  3442: 8b46a6           mov ax, word ptr [bp - 0x5a]
  049A45  3445: 8a0ea653         mov cl, byte ptr [0x53a6]
  049A49  3449: 2aed             sub ch, ch
  049A4B  344B: 2bc1             sub ax, cx
  049A4D  344D: 2b4682           sub ax, word ptr [bp - 0x7e]
  049A50  3450: 034680           add ax, word ptr [bp - 0x80]
  049A53  3453: 050400           add ax, 4
  049A56  3456: d1e0             shl ax, 1
  049A58  3458: 89862aff         mov word ptr [bp - 0xd6], ax
  049A5C  345C: 8b9e3aff         mov bx, word ptr [bp - 0xc6]
  049A60  3460: d1e3             shl bx, 1
  049A62  3462: f7af589e         imul word ptr [bx - 0x61a8]
  049A66  3466: 0bc0             or ax, ax
  049A68  3468: 7d02             jge 0x346c
  049A6A  346A: 2bc0             sub ax, ax
  049A6C  346C: 8bc8             mov cx, ax
  049A6E  346E: 8b4680           mov ax, word ptr [bp - 0x80]
  049A71  3471: 8bd0             mov dx, ax
  049A73  3473: c1e002           shl ax, 2
  049A76  3476: 03c2             add ax, dx
  049A78  3478: 03c1             add ax, cx
  049A7A  347A: f76e98           imul word ptr [bp - 0x68]
  049A7D  347D: 52               push dx
  049A7E  347E: 50               push ax
  049A7F  347F: 8bf3             mov si, bx
  049A81  3481: 9ac60e1d0d       lcall 0xd1d, 0xec6
  049A86  3486: 99               cdq 
  049A87  3487: 2bc2             sub ax, dx
  049A89  3489: d1f8             sar ax, 1
  049A8B  348B: 3d0100           cmp ax, 1
  049A8E  348E: 7d03             jge 0x3493
  049A90  3490: b80100           mov ax, 1
  049A93  3493: 8946a0           mov word ptr [bp - 0x60], ax
  049A96  3496: 8b84589e         mov ax, word ptr [si - 0x61a8]
  049A9A  349A: 2b4682           sub ax, word ptr [bp - 0x7e]
  049A9D  349D: 050400           add ax, 4
  049AA0  34A0: b90a00           mov cx, 0xa
  049AA3  34A3: 8bd8             mov bx, ax
  049AA5  34A5: 99               cdq 
  049AA6  34A6: f7f9             idiv cx
  049AA8  34A8: 3d0300           cmp ax, 3
  049AAB  34AB: 7e03             jle 0x34b0
  049AAD  34AD: b80300           mov ax, 3
  049AB0  34B0: 898638ff         mov word ptr [bp - 0xc8], ax
  049AB4  34B4: 6a01             push 1
  049AB6  34B6: 6a00             push 0
  049AB8  34B8: 8bfb             mov di, bx
  049ABA  34BA: 9ad4041f18       lcall 0x181f, 0x4d4
  049ABF  34BF: 83c404           add sp, 4
  049AC2  34C2: c1ff02           sar di, 2
  049AC5  34C5: 03c7             add ax, di
  049AC7  34C7: 89863eff         mov word ptr [bp - 0xc2], ax
  049ACB  34CB: 8b4698           mov ax, word ptr [bp - 0x68]
  049ACE  34CE: 8946fc           mov word ptr [bp - 4], ax
  049AD1  34D1: 8b84589e         mov ax, word ptr [si - 0x61a8]
  049AD5  34D5: 40               inc ax
  049AD6  34D6: c1e002           shl ax, 2
  049AD9  34D9: 0346a0           add ax, word ptr [bp - 0x60]
  049ADC  34DC: 898634ff         mov word ptr [bp - 0xcc], ax
  049AE0  34E0: 8b9e38ff         mov bx, word ptr [bp - 0xc8]
  049AE4  34E4: d1e3             shl bx, 1
  049AE6  34E6: ffb74093         push word ptr [bx - 0x6cc0]
  049AEA  34EA: 6a00             push 0
  049AEC  34EC: 9a38041f18       lcall 0x181f, 0x438
  049AF1  34F1: 83c404           add sp, 4
  049AF4  34F4: ffb4c097         push word ptr [si - 0x6840]
  049AF8  34F8: 6a01             push 1
  049AFA  34FA: 9a38041f18       lcall 0x181f, 0x438
  049AFF  34FF: 83c404           add sp, 4
  049B02  3502: c7867aff0000     mov word ptr [bp - 0x86], 0
  049B08  3508: 687515           push 0x1575
  049B0B  350B: 8d8642ff         lea ax, [bp - 0xbe]
  049B0F  350F: 50               push ax
  049B10  3510: 9ae4071d0d       lcall 0xd1d, 0x7e4
  049B15  3515: 83c404           add sp, 4
  049B18  3518: c746960000       mov word ptr [bp - 0x6a], 0
  049B1D  351D: 8b46a0           mov ax, word ptr [bp - 0x60]
  049B20  3520: 99               cdq 
  049B21  3521: a3b09c           mov word ptr [0x9cb0], ax
  049B24  3524: 8916b29c         mov word ptr [0x9cb2], dx
  049B28  3528: 8b8634ff         mov ax, word ptr [bp - 0xcc]
  049B2C  352C: 99               cdq 
  049B2D  352D: a3b49c           mov word ptr [0x9cb4], ax
  049B30  3530: 8916b69c         mov word ptr [0x9cb6], dx
  049B34  3534: 8a867aff         mov al, byte ptr [bp - 0x86]
  049B38  3538: 0430             add al, 0x30
  049B3A  353A: 888647ff         mov byte ptr [bp - 0xb9], al
  049B3E  353E: 837efa00         cmp word ptr [bp - 6], 0
  049B42  3542: 7416             je 0x355a
  049B44  3544: ff36528d         push word ptr [0x8d52]
  049B48  3548: 8d8642ff         lea ax, [bp - 0xbe]
  049B4C  354C: 50               push ax
  049B4D  354D: 9a9c011f19       lcall 0x191f, 0x19c
  049B52  3552: 83c404           add sp, 4
  049B55  3555: 8946a4           mov word ptr [bp - 0x5c], ax
  049B58  3558: eb11             jmp 0x356b
  049B5A  355A: c746a40100       mov word ptr [bp - 0x5c], 1
  049B5F  355F: 83be2cff32       cmp word ptr [bp - 0xd4], 0x32
  049B64  3564: 7c05             jl 0x356b
  049B66  3566: c746a40300       mov word ptr [bp - 0x5c], 3
  049B6B  356B: 8b46a4           mov ax, word ptr [bp - 0x5c]
  049B6E  356E: 48               dec ax
  049B6F  356F: 740f             je 0x3580
  049B71  3571: 48               dec ax
  049B72  3572: 7503             jne 0x3577
  049B74  3574: e9ff01           jmp 0x3776
  049B77  3577: 48               dec ax
  049B78  3578: 7503             jne 0x357d
  049B7A  357A: e9cf02           jmp 0x384c
  049B7D  357D: e9c202           jmp 0x3842
  049B80  3580: ff7684           push word ptr [bp - 0x7c]
  049B83  3583: ff7606           push word ptr [bp + 6]
  049B86  3586: 9aec0a1f18       lcall 0x181f, 0xaec
  049B8B  358B: 83c404           add sp, 4
  049B8E  358E: 8b46a0           mov ax, word ptr [bp - 0x60]
  049B91  3591: 99               cdq 
  049B92  3592: 695e0a3c01       imul bx, word ptr [bp + 0xa], 0x13c
  049B97  3597: 01873288         add word ptr [bx - 0x77ce], ax
  049B9B  359B: 11973488         adc word ptr [bx - 0x77cc], dx
  049B9F  359F: a1c48d           mov ax, word ptr [0x8dc4]
  049BA2  35A2: 8bb63aff         mov si, word ptr [bp - 0xc6]
  049BA6  35A6: d1e6             shl si, 1
  049BA8  35A8: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  049BAC  35AC: 01400e           add word ptr [bx + si + 0xe], ax
  049BAF  35AF: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  049BB3  35B3: c64707ff         mov byte ptr [bx + 7], 0xff
  049BB7  35B7: 83be3eff00       cmp word ptr [bp - 0xc2], 0
  049BBC  35BC: 7e3f             jle 0x35fd
  049BBE  35BE: 6a00             push 0
  049BC0  35C0: 8b863eff         mov ax, word ptr [bp - 0xc2]
  049BC4  35C4: d1e0             shl ax, 1
  049BC6  35C6: f7d8             neg ax
  049BC8  35C8: 50               push ax
  049BC9  35C9: ff760a           push word ptr [bp + 0xa]
  049BCC  35CC: ff36528d         push word ptr [0x8d52]
  049BD0  35D0: 9a6c0d1f18       lcall 0x181f, 0xd6c
  049BD5  35D5: 83c408           add sp, 8
  049BD8  35D8: a1c48d           mov ax, word ptr [0x8dc4]
  049BDB  35DB: 8b760a           mov si, word ptr [bp + 0xa]
  049BDE  35DE: d1e6             shl si, 1
  049BE0  35E0: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  049BE4  35E4: 29400a           sub word ptr [bx + si + 0xa], ax
  049BE7  35E7: 8b480a           mov cx, word ptr [bx + si + 0xa]
  049BEA  35EA: 0bc9             or cx, cx
  049BEC  35EC: 7d02             jge 0x35f0
  049BEE  35EE: 2bc9             sub cx, cx
  049BF0  35F0: 89480a           mov word ptr [bx + si + 0xa], cx
  049BF3  35F3: 3d6400           cmp ax, 0x64
  049BF6  35F6: 7505             jne 0x35fd
  049BF8  35F8: c7400a0000       mov word ptr [bx + si + 0xa], 0
  049BFD  35FD: 837e060f         cmp word ptr [bp + 6], 0xf
  049C01  3601: 7413             je 0x3616
  049C03  3603: 837e0608         cmp word ptr [bp + 6], 8
  049C07  3607: 740d             je 0x3616
  049C09  3609: 8a863aff         mov al, byte ptr [bp - 0xc6]
  049C0D  360D: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  049C11  3611: 884708           mov byte ptr [bx + 8], al
  049C14  3614: eb08             jmp 0x361e
  049C16  3616: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  049C1A  361A: c64708ff         mov byte ptr [bx + 8], 0xff
  049C1E  361E: 83be3aff0f       cmp word ptr [bp - 0xc6], 0xf
  049C23  3623: 751a             jne 0x363f
  049C25  3625: 837e9819         cmp word ptr [bp - 0x68], 0x19
  049C29  3629: 7c07             jl 0x3632
  049C2B  362B: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  049C2F  362F: fe4707           inc byte ptr [bx + 7]
  049C32  3632: 837e9832         cmp word ptr [bp - 0x68], 0x32
  049C36  3636: 7c07             jl 0x363f
  049C38  3638: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  049C3C  363C: fe4707           inc byte ptr [bx + 7]
  049C3F  363F: 83be3aff08       cmp word ptr [bp - 0xc6], 8
  049C44  3644: 7523             jne 0x3669
  049C46  3646: 8b4698           mov ax, word ptr [bp - 0x68]
  049C49  3649: c1f802           sar ax, 2
  049C4C  364C: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  049C50  3650: 01470a           add word ptr [bx + 0xa], ax
  049C53  3653: 837e9819         cmp word ptr [bp - 0x68], 0x19
  049C57  3657: 7c03             jl 0x365c
  049C59  3659: fe4708           inc byte ptr [bx + 8]
  049C5C  365C: 837e9832         cmp word ptr [bp - 0x68], 0x32
  049C60  3660: 7c07             jl 0x3669
  049C62  3662: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  049C66  3666: fe4708           inc byte ptr [bx + 8]
  049C69  3669: 837e9600         cmp word ptr [bp - 0x6a], 0
  049C6D  366D: 7403             je 0x3672
  049C6F  366F: e9a6fe           jmp 0x3518
  049C72  3672: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  049C76  3676: 8bc3             mov ax, bx
  049C78  3678: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  049C7C  367C: 8bf0             mov si, ax
  049C7E  367E: 8a845031         mov al, byte ptr [si + 0x3150]
  049C82  3682: 2ae4             sub ah, ah
  049C84  3684: 2aff             sub bh, bh
  049C86  3686: 8bcb             mov cx, bx
  049C88  3688: d1e3             shl bx, 1
  049C8A  368A: 03d9             add bx, cx
  049C8C  368C: d1e3             shl bx, 1
  049C8E  368E: 03d9             add bx, cx
  049C90  3690: d1e3             shl bx, 1
  049C92  3692: 8a8f3752         mov cl, byte ptr [bx + 0x5237]
  049C96  3696: 2aed             sub ch, ch
  049C98  3698: 2bc8             sub cx, ax
  049C9A  369A: 83f901           cmp cx, 1
  049C9D  369D: 7d06             jge 0x36a5
  049C9F  369F: c7863cff0000     mov word ptr [bp - 0xc4], 0
  049CA5  36A5: 83be3cff00       cmp word ptr [bp - 0xc4], 0
  049CAA  36AA: 7503             jne 0x36af
  049CAC  36AC: e9b306           jmp 0x3d62
  049CAF  36AF: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  049CB3  36B3: 807f0800         cmp byte ptr [bx + 8], 0
  049CB7  36B7: 7c0e             jl 0x36c7
  049CB9  36B9: 8a4708           mov al, byte ptr [bx + 8]
  049CBC  36BC: 98               cwde 
  049CBD  36BD: 8bd8             mov bx, ax
  049CBF  36BF: d1e3             shl bx, 1
  049CC1  36C1: c787589e0000     mov word ptr [bx - 0x61a8], 0
  049CC7  36C7: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  049CCB  36CB: 807f0900         cmp byte ptr [bx + 9], 0
  049CCF  36CF: 7c0e             jl 0x36df
  049CD1  36D1: 8a4709           mov al, byte ptr [bx + 9]
  049CD4  36D4: 98               cwde 
  049CD5  36D5: 8bd8             mov bx, ax
  049CD7  36D7: d1e3             shl bx, 1
  049CD9  36D9: c787589e0000     mov word ptr [bx - 0x61a8], 0
  049CDF  36DF: 8d4686           lea ax, [bp - 0x7a]
  049CE2  36E2: 16               push ss
  049CE3  36E3: 50               push ax
  049CE4  36E4: 1e               push ds
  049CE5  36E5: 68589e           push 0x9e58
  049CE8  36E8: b81000           mov ax, 0x10
  049CEB  36EB: 9ad00e1f19       lcall 0x191f, 0xed0
  049CF0  36F0: 8a4695           mov al, byte ptr [bp - 0x6b]
  049CF3  36F3: 98               cwde 
  049CF4  36F4: 3b863aff         cmp ax, word ptr [bp - 0xc6]
  049CF8  36F8: 745b             je 0x3755
  049CFA  36FA: 8bc8             mov cx, ax
  049CFC  36FC: 8a4694           mov al, byte ptr [bp - 0x6c]
  049CFF  36FF: 98               cwde 
  049D00  3700: 3b863aff         cmp ax, word ptr [bp - 0xc6]
  049D04  3704: 744f             je 0x3755
  049D06  3706: 8bd9             mov bx, cx
  049D08  3708: d1e3             shl bx, 1
  049D0A  370A: ffb7c097         push word ptr [bx - 0x6840]
  049D0E  370E: 6a00             push 0
  049D10  3710: 8bf0             mov si, ax
  049D12  3712: 9a38041f18       lcall 0x181f, 0x438
  049D17  3717: 83c404           add sp, 4
  049D1A  371A: d1e6             shl si, 1
  049D1C  371C: ffb4c097         push word ptr [si - 0x6840]
  049D20  3720: 6a01             push 1
  049D22  3722: 9a38041f18       lcall 0x181f, 0x438
  049D27  3727: 83c404           add sp, 4
  049D2A  372A: 8a4693           mov al, byte ptr [bp - 0x6d]
  049D2D  372D: 98               cwde 
  049D2E  372E: 8bd8             mov bx, ax
  049D30  3730: d1e3             shl bx, 1
  049D32  3732: ffb7c097         push word ptr [bx - 0x6840]
  049D36  3736: 6a02             push 2
  049D38  3738: 9a38041f18       lcall 0x181f, 0x438
  049D3D  373D: 83c404           add sp, 4
  049D40  3740: 837efa00         cmp word ptr [bp - 6], 0
  049D44  3744: 740f             je 0x3755
  049D46  3746: ff36528d         push word ptr [0x8d52]
  049D4A  374A: 688715           push 0x1587
  049D4D  374D: 9a9c011f19       lcall 0x191f, 0x19c
  049D52  3752: 83c404           add sp, 4
  049D55  3755: 837efa00         cmp word ptr [bp - 6], 0
  049D59  3759: 7503             jne 0x375e
  049D5B  375B: e9a001           jmp 0x38fe
  049D5E  375E: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  049D62  3762: 807f07fe         cmp byte ptr [bx + 7], 0xfe
  049D66  3766: 7403             je 0x376b
  049D68  3768: e99301           jmp 0x38fe
  049D6B  376B: ff36528d         push word ptr [0x8d52]
  049D6F  376F: 688d15           push 0x158d
  049D72  3772: e9f2fb           jmp 0x3367
  049D75  3775: 90               nop 
  049D76  3776: d17efc           sar word ptr [bp - 4], 1
  049D79  3779: 83be3eff00       cmp word ptr [bp - 0xc2], 0
  049D7E  377E: 7e7e             jle 0x37fe
  049D80  3780: 8b863eff         mov ax, word ptr [bp - 0xc2]
  049D84  3784: c1e003           shl ax, 3
  049D87  3787: 50               push ax
  049D88  3788: 6a01             push 1
  049D8A  378A: 9ad4041f18       lcall 0x181f, 0x4d4
  049D8F  378F: 83c404           add sp, 4
  049D92  3792: 8a0ea653         mov cl, byte ptr [0x53a6]
  049D96  3796: 2aed             sub ch, ch
  049D98  3798: 3bc1             cmp ax, cx
  049D9A  379A: 7e62             jle 0x37fe
  049D9C  379C: ff8e3eff         dec word ptr [bp - 0xc2]
  049DA0  37A0: 8b9e3aff         mov bx, word ptr [bp - 0xc6]
  049DA4  37A4: d1e3             shl bx, 1
  049DA6  37A6: 8b87589e         mov ax, word ptr [bx - 0x61a8]
  049DAA  37AA: 8bc8             mov cx, ax
  049DAC  37AC: d1e0             shl ax, 1
  049DAE  37AE: 40               inc ax
  049DAF  37AF: 50               push ax
  049DB0  37B0: d1f9             sar cx, 1
  049DB2  37B2: 41               inc cx
  049DB3  37B3: 51               push cx
  049DB4  37B4: 9ad4041f18       lcall 0x181f, 0x4d4
  049DB9  37B9: 83c404           add sp, 4
  049DBC  37BC: 89867eff         mov word ptr [bp - 0x82], ax
  049DC0  37C0: f76e98           imul word ptr [bp - 0x68]
  049DC3  37C3: b96400           mov cx, 0x64
  049DC6  37C6: 99               cdq 
  049DC7  37C7: f7f9             idiv cx
  049DC9  37C9: 89867eff         mov word ptr [bp - 0x82], ax
  049DCD  37CD: 3d0100           cmp ax, 1
  049DD0  37D0: 7d03             jge 0x37d5
  049DD2  37D2: b80100           mov ax, 1
  049DD5  37D5: 89867eff         mov word ptr [bp - 0x82], ax
  049DD9  37D9: 0146a0           add word ptr [bp - 0x60], ax
  049DDC  37DC: 8b8634ff         mov ax, word ptr [bp - 0xcc]
  049DE0  37E0: 3946a0           cmp word ptr [bp - 0x60], ax
  049DE3  37E3: 7c0a             jl 0x37ef
  049DE5  37E5: 8b46a0           mov ax, word ptr [bp - 0x60]
  049DE8  37E8: 050a00           add ax, 0xa
  049DEB  37EB: 898634ff         mov word ptr [bp - 0xcc], ax
  049DEF  37EF: b80100           mov ax, 1
  049DF2  37F2: 89867aff         mov word ptr [bp - 0x86], ax
  049DF6  37F6: 894696           mov word ptr [bp - 0x6a], ax
  049DF9  37F9: e96dfe           jmp 0x3669
  049DFC  37FC: 90               nop 
  049DFD  37FD: 90               nop 
  049DFE  37FE: 8a863aff         mov al, byte ptr [bp - 0xc6]
  049E02  3802: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  049E06  3806: 884707           mov byte ptr [bx + 7], al
  049E09  3809: 6a00             push 0
  049E0B  380B: 8b4682           mov ax, word ptr [bp - 0x7e]
  049E0E  380E: d1f8             sar ax, 1
  049E10  3810: 40               inc ax
  049E11  3811: 50               push ax
  049E12  3812: ff760a           push word ptr [bp + 0xa]
  049E15  3815: ff36528d         push word ptr [0x8d52]
  049E19  3819: 9a6c0d1f18       lcall 0x181f, 0xd6c
  049E1E  381E: 83c408           add sp, 8
  049E21  3821: ff760c           push word ptr [bp + 0xc]
  049E24  3824: ff760a           push word ptr [bp + 0xa]
  049E27  3827: 9a380a1f18       lcall 0x181f, 0xa38
  049E2C  382C: 83c404           add sp, 4
  049E2F  382F: a840             test al, 0x40
  049E31  3831: 740f             je 0x3842
  049E33  3833: ff36528d         push word ptr [0x8d52]
  049E37  3837: 687c15           push 0x157c
  049E3A  383A: 9a9c011f19       lcall 0x191f, 0x19c
  049E3F  383F: 83c404           add sp, 4
  049E42  3842: c7863cff0000     mov word ptr [bp - 0xc4], 0
  049E48  3848: e91efe           jmp 0x3669
  049E4B  384B: 90               nop 
  049E4C  384C: 83be7aff00       cmp word ptr [bp - 0x86], 0
  049E51  3851: 75ef             jne 0x3842
  049E53  3853: ff7684           push word ptr [bp - 0x7c]
  049E56  3856: ff7606           push word ptr [bp + 6]
  049E59  3859: 9aec0a1f18       lcall 0x181f, 0xaec
  049E5E  385E: 83c404           add sp, 4
  049E61  3861: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  049E65  3865: c64707ff         mov byte ptr [bx + 7], 0xff
  049E69  3869: 837e060f         cmp word ptr [bp + 6], 0xf
  049E6D  386D: 740f             je 0x387e
  049E6F  386F: 837e0608         cmp word ptr [bp + 6], 8
  049E73  3873: 7409             je 0x387e
  049E75  3875: 8a863aff         mov al, byte ptr [bp - 0xc6]
  049E79  3879: 884708           mov byte ptr [bx + 8], al
  049E7C  387C: eb08             jmp 0x3886
  049E7E  387E: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  049E82  3882: c64708ff         mov byte ptr [bx + 8], 0xff
  049E86  3886: 83be3eff00       cmp word ptr [bp - 0xc2], 0
  049E8B  388B: 7c48             jl 0x38d5
  049E8D  388D: 6a00             push 0
  049E8F  388F: ff863eff         inc word ptr [bp - 0xc2]
  049E93  3893: 8b863eff         mov ax, word ptr [bp - 0xc2]
  049E97  3897: c1e002           shl ax, 2
  049E9A  389A: f7d8             neg ax
  049E9C  389C: 50               push ax
  049E9D  389D: ff760a           push word ptr [bp + 0xa]
  049EA0  38A0: ff36528d         push word ptr [0x8d52]
  049EA4  38A4: 9a6c0d1f18       lcall 0x181f, 0xd6c
  049EA9  38A9: 83c408           add sp, 8
  049EAC  38AC: a1c48d           mov ax, word ptr [0x8dc4]
  049EAF  38AF: d1e0             shl ax, 1
  049EB1  38B1: 8b760a           mov si, word ptr [bp + 0xa]
  049EB4  38B4: d1e6             shl si, 1
  049EB6  38B6: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  049EBA  38BA: 29400a           sub word ptr [bx + si + 0xa], ax
  049EBD  38BD: 8b400a           mov ax, word ptr [bx + si + 0xa]
  049EC0  38C0: 0bc0             or ax, ax
  049EC2  38C2: 7d02             jge 0x38c6
  049EC4  38C4: 2bc0             sub ax, ax
  049EC6  38C6: 89400a           mov word ptr [bx + si + 0xa], ax
  049EC9  38C9: 833ec48d64       cmp word ptr [0x8dc4], 0x64
  049ECE  38CE: 7505             jne 0x38d5
  049ED0  38D0: c7400a0000       mov word ptr [bx + si + 0xa], 0
  049ED5  38D5: 83be3aff0f       cmp word ptr [bp - 0xc6], 0xf
  049EDA  38DA: 7507             jne 0x38e3
  049EDC  38DC: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  049EE0  38E0: fe4707           inc byte ptr [bx + 7]
  049EE3  38E3: 83be3aff08       cmp word ptr [bp - 0xc6], 8
  049EE8  38E8: 7403             je 0x38ed
  049EEA  38EA: e97cfd           jmp 0x3669
  049EED  38ED: a1c48d           mov ax, word ptr [0x8dc4]
  049EF0  38F0: c1f802           sar ax, 2
  049EF3  38F3: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  049EF7  38F7: 01470a           add word ptr [bx + 0xa], ax
  049EFA  38FA: e969fd           jmp 0x3666
  049EFD  38FD: 90               nop 
  049EFE  38FE: 83be3aff00       cmp word ptr [bp - 0xc6], 0
  049F03  3903: 7d13             jge 0x3918
  049F05  3905: 837efa00         cmp word ptr [bp - 6], 0
  049F09  3909: 7503             jne 0x390e
  049F0B  390B: e95404           jmp 0x3d62
  049F0E  390E: ff36528d         push word ptr [0x8d52]
  049F12  3912: 689815           push 0x1598
  049F15  3915: e94ffa           jmp 0x3367
  049F18  3918: 2bc0             sub ax, ax
  049F1A  391A: 8946a8           mov word ptr [bp - 0x58], ax
  049F1D  391D: 898640ff         mov word ptr [bp - 0xc0], ax
  049F21  3921: eb54             jmp 0x3977
  049F23  3923: 90               nop 
  049F24  3924: 83be40ff10       cmp word ptr [bp - 0xc0], 0x10
  049F29  3929: 7d52             jge 0x397d
  049F2B  392B: 8d9e79ff         lea bx, [bp - 0x87]
  049F2F  392F: 2b9e40ff         sub bx, word ptr [bp - 0xc0]
  049F33  3933: 8a07             mov al, byte ptr [bx]
  049F35  3935: 98               cwde 
  049F36  3936: 89863aff         mov word ptr [bp - 0xc6], ax
  049F3A  393A: 3d0f00           cmp ax, 0xf
  049F3D  393D: 7434             je 0x3973
  049F3F  393F: 0bc0             or ax, ax
  049F41  3941: 7430             je 0x3973
  049F43  3943: 3d0e00           cmp ax, 0xe
  049F46  3946: 742b             je 0x3973
  049F48  3948: 3d0d00           cmp ax, 0xd
  049F4B  394B: 7426             je 0x3973
  049F4D  394D: 8bd8             mov bx, ax
  049F4F  394F: d1e3             shl bx, 1
  049F51  3951: ffb7c097         push word ptr [bx - 0x6840]
  049F55  3955: ff76a8           push word ptr [bp - 0x58]
  049F58  3958: 9a38041f18       lcall 0x181f, 0x438
  049F5D  395D: 83c404           add sp, 4
  049F60  3960: b80f00           mov ax, 0xf
  049F63  3963: 2b8640ff         sub ax, word ptr [bp - 0xc0]
  049F67  3967: 8b76a8           mov si, word ptr [bp - 0x58]
  049F6A  396A: d1e6             shl si, 1
  049F6C  396C: 89822eff         mov word ptr [bp + si - 0xd2], ax
  049F70  3970: ff46a8           inc word ptr [bp - 0x58]
  049F73  3973: ff8640ff         inc word ptr [bp - 0xc0]
  049F77  3977: 837ea803         cmp word ptr [bp - 0x58], 3
  049F7B  397B: 7ca7             jl 0x3924
  049F7D  397D: 837efa00         cmp word ptr [bp - 6], 0
  049F81  3981: 7415             je 0x3998
  049F83  3983: ff36528d         push word ptr [0x8d52]
  049F87  3987: 68a015           push 0x15a0
  049F8A  398A: 9a9c011f19       lcall 0x191f, 0x19c
  049F8F  398F: 83c404           add sp, 4
  049F92  3992: 8946a4           mov word ptr [bp - 0x5c], ax
  049F95  3995: eb4f             jmp 0x39e6
  049F97  3997: 90               nop 
  049F98  3998: c746a40100       mov word ptr [bp - 0x5c], 1
  049F9D  399D: c78636fff1d8     mov word ptr [bp - 0xca], 0xd8f1
  049FA3  39A3: c78640ff0000     mov word ptr [bp - 0xc0], 0
  049FA9  39A9: 8d9e7aff         lea bx, [bp - 0x86]
  049FAD  39AD: 2b9e40ff         sub bx, word ptr [bp - 0xc0]
  049FB1  39B1: 8a07             mov al, byte ptr [bx]
  049FB3  39B3: 98               cwde 
  049FB4  39B4: 8bf0             mov si, ax
  049FB6  39B6: 8976a2           mov word ptr [bp - 0x5e], si
  049FB9  39B9: 8b5e0a           mov bx, word ptr [bp + 0xa]
  049FBC  39BC: c1e304           shl bx, 4
  049FBF  39BF: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  049FC3  39C3: 2ae4             sub ah, ah
  049FC5  39C5: 898638ff         mov word ptr [bp - 0xc8], ax
  049FC9  39C9: 3b8636ff         cmp ax, word ptr [bp - 0xca]
  049FCD  39CD: 7e0c             jle 0x39db
  049FCF  39CF: 898636ff         mov word ptr [bp - 0xca], ax
  049FD3  39D3: 8b8640ff         mov ax, word ptr [bp - 0xc0]
  049FD7  39D7: 40               inc ax
  049FD8  39D8: 8946a4           mov word ptr [bp - 0x5c], ax
  049FDB  39DB: ff8640ff         inc word ptr [bp - 0xc0]
  049FDF  39DF: 83be40ff03       cmp word ptr [bp - 0xc0], 3
  049FE4  39E4: 7cc3             jl 0x39a9
  049FE6  39E6: 837ea401         cmp word ptr [bp - 0x5c], 1
  049FEA  39EA: 7d03             jge 0x39ef
  049FEC  39EC: e97303           jmp 0x3d62
  049FEF  39EF: 837ea403         cmp word ptr [bp - 0x5c], 3
  049FF3  39F3: 7e03             jle 0x39f8
  049FF5  39F5: e96a03           jmp 0x3d62
  049FF8  39F8: 8b76a4           mov si, word ptr [bp - 0x5c]
  049FFB  39FB: d1e6             shl si, 1
  049FFD  39FD: 8bb22cff         mov si, word ptr [bp + si - 0xd4]
  04A001  3A01: 89b67cff         mov word ptr [bp - 0x84], si
  04A005  3A05: 8a826aff         mov al, byte ptr [bp + si - 0x96]
  04A009  3A09: 98               cwde 
  04A00A  3A0A: 89863aff         mov word ptr [bp - 0xc6], ax
  04A00E  3A0E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04A012  3A12: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04A017  3A17: 720c             jb 0x3a25
  04A019  3A19: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04A01E  3A1E: 7705             ja 0x3a25
  04A020  3A20: c13ec48d02       sar word ptr [0x8dc4], 2
  04A025  3A25: c746a0c800       mov word ptr [bp - 0x60], 0xc8
  04A02A  3A2A: 3d0800           cmp ax, 8
  04A02D  3A2D: 7c14             jl 0x3a43
  04A02F  3A2F: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04A033  3A33: 8a4702           mov al, byte ptr [bx + 2]
  04A036  3A36: 2ae4             sub ah, ah
  04A038  3A38: 2d0800           sub ax, 8
  04A03B  3A3B: f7d8             neg ax
  04A03D  3A3D: 6bc032           imul ax, ax, 0x32
  04A040  3A40: 8946a0           mov word ptr [bp - 0x60], ax
  04A043  3A43: 83be3aff07       cmp word ptr [bp - 0xc6], 7
  04A048  3A48: 7c20             jl 0x3a6a
  04A04A  3A4A: 8b760a           mov si, word ptr [bp + 0xa]
  04A04D  3A4D: c1e604           shl si, 4
  04A050  3A50: 8b9e3aff         mov bx, word ptr [bp - 0xc6]
  04A054  3A54: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  04A058  3A58: 2ae4             sub ah, ah
  04A05A  3A5A: 8a0ea653         mov cl, byte ptr [0x53a6]
  04A05E  3A5E: 2aed             sub ch, ch
  04A060  3A60: d1e1             shl cx, 1
  04A062  3A62: 83c10f           add cx, 0xf
  04A065  3A65: f7e9             imul cx
  04A067  3A67: 0146a0           add word ptr [bp - 0x60], ax
  04A06A  3A6A: ff76a0           push word ptr [bp - 0x60]
  04A06D  3A6D: 6a00             push 0
  04A06F  3A6F: 9ad4041f18       lcall 0x181f, 0x4d4
  04A074  3A74: 83c404           add sp, 4
  04A077  3A77: 0146a0           add word ptr [bp - 0x60], ax
  04A07A  3A7A: 8b9e7cff         mov bx, word ptr [bp - 0x84]
  04A07E  3A7E: d1e3             shl bx, 1
  04A080  3A80: 8b87789e         mov ax, word ptr [bx - 0x6188]
  04A084  3A84: c1e002           shl ax, 2
  04A087  3A87: 2946a0           sub word ptr [bp - 0x60], ax
  04A08A  3A8A: ff760a           push word ptr [bp + 0xa]
  04A08D  3A8D: ff36528d         push word ptr [0x8d52]
  04A091  3A91: 9a0c031f18       lcall 0x181f, 0x30c
  04A096  3A96: 83c404           add sp, 4
  04A099  3A99: c1e002           shl ax, 2
  04A09C  3A9C: 0146a0           add word ptr [bp - 0x60], ax
  04A09F  3A9F: 6a00             push 0
  04A0A1  3AA1: 6a64             push 0x64
  04A0A3  3AA3: a1c48d           mov ax, word ptr [0x8dc4]
  04A0A6  3AA6: f76ea0           imul word ptr [bp - 0x60]
  04A0A9  3AA9: 52               push dx
  04A0AA  3AAA: 50               push ax
  04A0AB  3AAB: 9ac60e1d0d       lcall 0xd1d, 0xec6
  04A0B0  3AB0: 8946a0           mov word ptr [bp - 0x60], ax
  04A0B3  3AB3: 6a02             push 2
  04A0B5  3AB5: 6a00             push 0
  04A0B7  3AB7: 9ad4041f18       lcall 0x181f, 0x4d4
  04A0BC  3ABC: 83c404           add sp, 4
  04A0BF  3ABF: 894680           mov word ptr [bp - 0x80], ax
  04A0C2  3AC2: a0a653           mov al, byte ptr [0x53a6]
  04A0C5  3AC5: 2ae4             sub ah, ah
  04A0C7  3AC7: 034680           add ax, word ptr [bp - 0x80]
  04A0CA  3ACA: 8bc8             mov cx, ax
  04A0CC  3ACC: c1e002           shl ax, 2
  04A0CF  3ACF: 03c1             add ax, cx
  04A0D1  3AD1: d1e0             shl ax, 1
  04A0D3  3AD3: 0146a0           add word ptr [bp - 0x60], ax
  04A0D6  3AD6: 8b46a0           mov ax, word ptr [bp - 0x60]
  04A0D9  3AD9: 3d3200           cmp ax, 0x32
  04A0DC  3ADC: 7d03             jge 0x3ae1
  04A0DE  3ADE: b83200           mov ax, 0x32
  04A0E1  3AE1: 8946a0           mov word ptr [bp - 0x60], ax
  04A0E4  3AE4: 8b9e3aff         mov bx, word ptr [bp - 0xc6]
  04A0E8  3AE8: d1e3             shl bx, 1
  04A0EA  3AEA: ffb7c097         push word ptr [bx - 0x6840]
  04A0EE  3AEE: 6a00             push 0
  04A0F0  3AF0: 9a38041f18       lcall 0x181f, 0x438
  04A0F5  3AF5: 83c404           add sp, 4
  04A0F8  3AF8: a1c48d           mov ax, word ptr [0x8dc4]
  04A0FB  3AFB: 99               cdq 
  04A0FC  3AFC: a3b89c           mov word ptr [0x9cb8], ax
  04A0FF  3AFF: 8916ba9c         mov word ptr [0x9cba], dx
  04A103  3B03: 695e0a3c01       imul bx, word ptr [bp + 0xa], 0x13c
  04A108  3B08: ffb73488         push word ptr [bx - 0x77cc]
  04A10C  3B0C: ffb73288         push word ptr [bx - 0x77ce]
  04A110  3B10: 6a03             push 3
  04A112  3B12: 9aae091f18       lcall 0x181f, 0x9ae
  04A117  3B17: 83c406           add sp, 6
  04A11A  3B1A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04A11E  3B1E: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04A123  3B23: 720d             jb 0x3b32
  04A125  3B25: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04A12A  3B2A: 7706             ja 0x3b32
  04A12C  3B2C: a10e2e           mov ax, word ptr [0x2e0e]
  04A12F  3B2F: eb04             jmp 0x3b35
  04A131  3B31: 90               nop 
  04A132  3B32: a10c2e           mov ax, word ptr [0x2e0c]
  04A135  3B35: 898628ff         mov word ptr [bp - 0xd8], ax
  04A139  3B39: 50               push ax
  04A13A  3B3A: 6a01             push 1
  04A13C  3B3C: 9a38041f18       lcall 0x181f, 0x438
  04A141  3B41: 83c404           add sp, 4
  04A144  3B44: 68a915           push 0x15a9
  04A147  3B47: 8d8642ff         lea ax, [bp - 0xbe]
  04A14B  3B4B: 50               push ax
  04A14C  3B4C: 9ae4071d0d       lcall 0xd1d, 0x7e4
  04A151  3B51: 83c404           add sp, 4
  04A154  3B54: c7867aff0000     mov word ptr [bp - 0x86], 0
  04A15A  3B5A: c746960000       mov word ptr [bp - 0x6a], 0
  04A15F  3B5F: 8b46a0           mov ax, word ptr [bp - 0x60]
  04A162  3B62: d1f8             sar ax, 1
  04A164  3B64: 3d0a00           cmp ax, 0xa
  04A167  3B67: 7d03             jge 0x3b6c
  04A169  3B69: b80a00           mov ax, 0xa
  04A16C  3B6C: 898634ff         mov word ptr [bp - 0xcc], ax
  04A170  3B70: 8b4ea0           mov cx, word ptr [bp - 0x60]
  04A173  3B73: c1f902           sar cx, 2
  04A176  3B76: 83f901           cmp cx, 1
  04A179  3B79: 7d03             jge 0x3b7e
  04A17B  3B7B: b90100           mov cx, 1
  04A17E  3B7E: 894efe           mov word ptr [bp - 2], cx
  04A181  3B81: 8b46a0           mov ax, word ptr [bp - 0x60]
  04A184  3B84: 99               cdq 
  04A185  3B85: a3b09c           mov word ptr [0x9cb0], ax
  04A188  3B88: 8916b29c         mov word ptr [0x9cb2], dx
  04A18C  3B8C: 8b8634ff         mov ax, word ptr [bp - 0xcc]
  04A190  3B90: 99               cdq 
  04A191  3B91: a3b49c           mov word ptr [0x9cb4], ax
  04A194  3B94: 8916b69c         mov word ptr [0x9cb6], dx
  04A198  3B98: 8a867aff         mov al, byte ptr [bp - 0x86]
  04A19C  3B9C: 0430             add al, 0x30
  04A19E  3B9E: 888645ff         mov byte ptr [bp - 0xbb], al
  04A1A2  3BA2: c746a40100       mov word ptr [bp - 0x5c], 1
  04A1A7  3BA7: 837efa00         cmp word ptr [bp - 6], 0
  04A1AB  3BAB: 7414             je 0x3bc1
  04A1AD  3BAD: ff36528d         push word ptr [0x8d52]
  04A1B1  3BB1: 8d8642ff         lea ax, [bp - 0xbe]
  04A1B5  3BB5: 50               push ax
  04A1B6  3BB6: 9a9c011f19       lcall 0x191f, 0x19c
  04A1BB  3BBB: 83c404           add sp, 4
  04A1BE  3BBE: 8946a4           mov word ptr [bp - 0x5c], ax
  04A1C1  3BC1: 8b46a4           mov ax, word ptr [bp - 0x5c]
  04A1C4  3BC4: e98501           jmp 0x3d4c
  04A1C7  3BC7: 90               nop 
  04A1C8  3BC8: 8b46a0           mov ax, word ptr [bp - 0x60]
  04A1CB  3BCB: 99               cdq 
  04A1CC  3BCC: 695e0a3c01       imul bx, word ptr [bp + 0xa], 0x13c
  04A1D1  3BD1: 39973488         cmp word ptr [bx - 0x77cc], dx
  04A1D5  3BD5: 7c77             jl 0x3c4e
  04A1D7  3BD7: 7f06             jg 0x3bdf
  04A1D9  3BD9: 39873288         cmp word ptr [bx - 0x77ce], ax
  04A1DD  3BDD: 726f             jb 0x3c4e
  04A1DF  3BDF: 29873288         sub word ptr [bx - 0x77ce], ax
  04A1E3  3BE3: 19973488         sbb word ptr [bx - 0x77cc], dx
  04A1E7  3BE7: 8a863aff         mov al, byte ptr [bp - 0xc6]
  04A1EB  3BEB: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04A1EF  3BEF: 884709           mov byte ptr [bx + 9], al
  04A1F2  3BF2: 83be3aff09       cmp word ptr [bp - 0xc6], 9
  04A1F7  3BF7: 7504             jne 0x3bfd
  04A1F9  3BF9: c64709ff         mov byte ptr [bx + 9], 0xff
  04A1FD  3BFD: a1c48d           mov ax, word ptr [0x8dc4]
  04A200  3C00: 8bb63aff         mov si, word ptr [bp - 0xc6]
  04A204  3C04: d1e6             shl si, 1
  04A206  3C06: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04A20A  3C0A: 29400e           sub word ptr [bx + si + 0xe], ax
  04A20D  3C0D: 50               push ax
  04A20E  3C0E: ffb63aff         push word ptr [bp - 0xc6]
  04A212  3C12: ff7606           push word ptr [bp + 6]
  04A215  3C15: 9a580d1f18       lcall 0x181f, 0xd58
  04A21A  3C1A: 83c406           add sp, 6
  04A21D  3C1D: 8b46a0           mov ax, word ptr [bp - 0x60]
  04A220  3C20: b91900           mov cx, 0x19
  04A223  3C23: 99               cdq 
  04A224  3C24: f7f9             idiv cx
  04A226  3C26: 40               inc ax
  04A227  3C27: 50               push ax
  04A228  3C28: 6a00             push 0
  04A22A  3C2A: 9ad4041f18       lcall 0x181f, 0x4d4
  04A22F  3C2F: 83c404           add sp, 4
  04A232  3C32: 89863eff         mov word ptr [bp - 0xc2], ax
  04A236  3C36: 6a00             push 0
  04A238  3C38: f7d8             neg ax
  04A23A  3C3A: 50               push ax
  04A23B  3C3B: ff760a           push word ptr [bp + 0xa]
  04A23E  3C3E: ff36528d         push word ptr [0x8d52]
  04A242  3C42: 9a6c0d1f18       lcall 0x181f, 0xd6c
  04A247  3C47: 83c408           add sp, 8
  04A24A  3C4A: e90c01           jmp 0x3d59
  04A24D  3C4D: 90               nop 
  04A24E  3C4E: 695e0a3c01       imul bx, word ptr [bp + 0xa], 0x13c
  04A253  3C53: 8b873288         mov ax, word ptr [bx - 0x77ce]
  04A257  3C57: 8b973488         mov dx, word ptr [bx - 0x77cc]
  04A25B  3C5B: a3b09c           mov word ptr [0x9cb0], ax
  04A25E  3C5E: 8916b29c         mov word ptr [0x9cb2], dx
  04A262  3C62: 837efa00         cmp word ptr [bp - 6], 0
  04A266  3C66: 740f             je 0x3c77
  04A268  3C68: ff36528d         push word ptr [0x8d52]
  04A26C  3C6C: 68ae15           push 0x15ae
  04A26F  3C6F: 9a9c011f19       lcall 0x191f, 0x19c
  04A274  3C74: 83c404           add sp, 4
  04A277  3C77: 6a00             push 0
  04A279  3C79: 6a01             push 1
  04A27B  3C7B: ebbe             jmp 0x3c3b
  04A27D  3C7D: 90               nop 
  04A27E  3C7E: 8b9e7cff         mov bx, word ptr [bp - 0x84]
  04A282  3C82: d1e3             shl bx, 1
  04A284  3C84: 8b87789e         mov ax, word ptr [bx - 0x6188]
  04A288  3C88: b91900           mov cx, 0x19
  04A28B  3C8B: 99               cdq 
  04A28C  3C8C: f7f9             idiv cx
  04A28E  3C8E: 050800           add ax, 8
  04A291  3C91: 89862aff         mov word ptr [bp - 0xd6], ax
  04A295  3C95: 50               push ax
  04A296  3C96: 6a00             push 0
  04A298  3C98: 9ad4041f18       lcall 0x181f, 0x4d4
  04A29D  3C9D: 83c404           add sp, 4
  04A2A0  3CA0: 894680           mov word ptr [bp - 0x80], ax
  04A2A3  3CA3: 837ea00a         cmp word ptr [bp - 0x60], 0xa
  04A2A7  3CA7: 7e65             jle 0x3d0e
  04A2A9  3CA9: a0a653           mov al, byte ptr [0x53a6]
  04A2AC  3CAC: 2ae4             sub ah, ah
  04A2AE  3CAE: 8bc8             mov cx, ax
  04A2B0  3CB0: 40               inc ax
  04A2B1  3CB1: 3b4680           cmp ax, word ptr [bp - 0x80]
  04A2B4  3CB4: 7d58             jge 0x3d0e
  04A2B6  3CB6: 8b46fe           mov ax, word ptr [bp - 2]
  04A2B9  3CB9: 2946a0           sub word ptr [bp - 0x60], ax
  04A2BC  3CBC: 8b46a0           mov ax, word ptr [bp - 0x60]
  04A2BF  3CBF: 3d0a00           cmp ax, 0xa
  04A2C2  3CC2: 7d03             jge 0x3cc7
  04A2C4  3CC4: b80a00           mov ax, 0xa
  04A2C7  3CC7: 8946a0           mov word ptr [bp - 0x60], ax
  04A2CA  3CCA: 83e908           sub cx, 8
  04A2CD  3CCD: f7d9             neg cx
  04A2CF  3CCF: 51               push cx
  04A2D0  3CD0: 6a01             push 1
  04A2D2  3CD2: 9ad4041f18       lcall 0x181f, 0x4d4
  04A2D7  3CD7: 83c404           add sp, 4
  04A2DA  3CDA: 48               dec ax
  04A2DB  3CDB: 7513             jne 0x3cf0
  04A2DD  3CDD: 6a00             push 0
  04A2DF  3CDF: 6a01             push 1
  04A2E1  3CE1: ff760a           push word ptr [bp + 0xa]
  04A2E4  3CE4: ff36528d         push word ptr [0x8d52]
  04A2E8  3CE8: 9a6c0d1f18       lcall 0x181f, 0xd6c
  04A2ED  3CED: 83c408           add sp, 8
  04A2F0  3CF0: ff760c           push word ptr [bp + 0xc]
  04A2F3  3CF3: ff760a           push word ptr [bp + 0xa]
  04A2F6  3CF6: 9a380a1f18       lcall 0x181f, 0xa38
  04A2FB  3CFB: 83c404           add sp, 4
  04A2FE  3CFE: a840             test al, 0x40
  04A300  3D00: 7457             je 0x3d59
  04A302  3D02: b80100           mov ax, 1
  04A305  3D05: 89867aff         mov word ptr [bp - 0x86], ax
  04A309  3D09: 894696           mov word ptr [bp - 0x6a], ax
  04A30C  3D0C: eb4b             jmp 0x3d59
  04A30E  3D0E: 6a00             push 0
  04A310  3D10: 6a02             push 2
  04A312  3D12: ff760a           push word ptr [bp + 0xa]
  04A315  3D15: ff36528d         push word ptr [0x8d52]
  04A319  3D19: 9a6c0d1f18       lcall 0x181f, 0xd6c
  04A31E  3D1E: 83c408           add sp, 8
  04A321  3D21: ff760c           push word ptr [bp + 0xc]
  04A324  3D24: ff760a           push word ptr [bp + 0xa]
  04A327  3D27: 9a380a1f18       lcall 0x181f, 0xa38
  04A32C  3D2C: 83c404           add sp, 4
  04A32F  3D2F: a840             test al, 0x40
  04A331  3D31: 7426             je 0x3d59
  04A333  3D33: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04A337  3D37: c64707fe         mov byte ptr [bx + 7], 0xfe
  04A33B  3D3B: ff36528d         push word ptr [0x8d52]
  04A33F  3D3F: 68b815           push 0x15b8
  04A342  3D42: 9a9c011f19       lcall 0x191f, 0x19c
  04A347  3D47: 83c404           add sp, 4
  04A34A  3D4A: eb0d             jmp 0x3d59
  04A34C  3D4C: 48               dec ax
  04A34D  3D4D: 7503             jne 0x3d52
  04A34F  3D4F: e976fe           jmp 0x3bc8
  04A352  3D52: 48               dec ax
  04A353  3D53: 7503             jne 0x3d58
  04A355  3D55: e926ff           jmp 0x3c7e
  04A358  3D58: 48               dec ax
  04A359  3D59: 837e9600         cmp word ptr [bp - 0x6a], 0
  04A35D  3D5D: 7403             je 0x3d62
  04A35F  3D5F: e9f8fd           jmp 0x3b5a
  04A362  3D62: 8b760a           mov si, word ptr [bp + 0xa]
  04A365  3D65: d1e6             shl si, 1
  04A367  3D67: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04A36B  3D6B: 8b400a           mov ax, word ptr [bx + si + 0xa]
  04A36E  3D6E: 0bc0             or ax, ax
  04A370  3D70: 7d02             jge 0x3d74
  04A372  3D72: 2bc0             sub ax, ax
  04A374  3D74: 89400a           mov word ptr [bx + si + 0xa], ax
  04A377  3D77: 5e               pop si
  04A378  3D78: 5f               pop di
  04A379  3D79: c9               leave 
  04A37A  3D7A: cb               retf 

; ---- func_04A37C  size=170  insns=58  prologue=ENTER 0x0006,0  terminal=RETF ----
  04A37C  3D7C: c8060000         enter 6, 0
  04A380  3D80: ff760a           push word ptr [bp + 0xa]
  04A383  3D83: ff36528d         push word ptr [0x8d52]
  04A387  3D87: 9a0c031f18       lcall 0x181f, 0x30c
  04A38C  3D8C: 83c404           add sp, 4
  04A38F  3D8F: 8946fa           mov word ptr [bp - 6], ax
  04A392  3D92: 68f401           push 0x1f4
  04A395  3D95: 2bc0             sub ax, ax
  04A397  3D97: 8946fc           mov word ptr [bp - 4], ax
  04A39A  3D9A: 50               push ax
  04A39B  3D9B: 9ad4041f18       lcall 0x181f, 0x4d4
  04A3A0  3DA0: 83c404           add sp, 4
  04A3A3  3DA3: 8946fe           mov word ptr [bp - 2], ax
  04A3A6  3DA6: ff760c           push word ptr [bp + 0xc]
  04A3A9  3DA9: 9aa4091f18       lcall 0x181f, 0x9a4
  04A3AE  3DAE: 83c402           add sp, 2
  04A3B1  3DB1: 50               push ax
  04A3B2  3DB2: 6a00             push 0
  04A3B4  3DB4: 9a38041f18       lcall 0x181f, 0x438
  04A3B9  3DB9: 83c404           add sp, 4
  04A3BC  3DBC: 8b46fa           mov ax, word ptr [bp - 6]
  04A3BF  3DBF: 3946fe           cmp word ptr [bp - 2], ax
  04A3C2  3DC2: 7f22             jg 0x3de6
  04A3C4  3DC4: 6a03             push 3
  04A3C6  3DC6: 68c315           push 0x15c3
  04A3C9  3DC9: 9a52061f18       lcall 0x181f, 0x652
  04A3CE  3DCE: 83c404           add sp, 4
  04A3D1  3DD1: ff7606           push word ptr [bp + 6]
  04A3D4  3DD4: 9a08081f18       lcall 0x181f, 0x808
  04A3D9  3DD9: 83c402           add sp, 2
  04A3DC  3DDC: c746fc0100       mov word ptr [bp - 4], 1
  04A3E1  3DE1: 8b46fc           mov ax, word ptr [bp - 4]
  04A3E4  3DE4: c9               leave 
  04A3E5  3DE5: cb               retf 
  04A3E6  3DE6: d1e0             shl ax, 1
  04A3E8  3DE8: 3b46fe           cmp ax, word ptr [bp - 2]
  04A3EB  3DEB: 7c15             jl 0x3e02
  04A3ED  3DED: ff36528d         push word ptr [0x8d52]
  04A3F1  3DF1: 68ce15           push 0x15ce
  04A3F4  3DF4: 9a9c011f19       lcall 0x191f, 0x19c
  04A3F9  3DF9: 83c404           add sp, 4
  04A3FC  3DFC: 8b46fc           mov ax, word ptr [bp - 4]
  04A3FF  3DFF: c9               leave 
  04A400  3E00: cb               retf 
  04A401  3E01: 90               nop 
  04A402  3E02: ff36528d         push word ptr [0x8d52]
  04A406  3E06: 68da15           push 0x15da
  04A409  3E09: 9a9c011f19       lcall 0x191f, 0x19c
  04A40E  3E0E: 83c404           add sp, 4
  04A411  3E11: ff760c           push word ptr [bp + 0xc]
  04A414  3E14: ff760a           push word ptr [bp + 0xa]
  04A417  3E17: ff7608           push word ptr [bp + 8]
  04A41A  3E1A: ff7606           push word ptr [bp + 6]
  04A41D  3E1D: 0e               push cs
  04A41E  3E1E: e82716           call 0x5448
  04A421  3E21: 8b46fc           mov ax, word ptr [bp - 4]
  04A424  3E24: c9               leave 
  04A425  3E25: cb               retf 

; ---- func_04A426  size=931  insns=318  prologue=ENTER 0x0036,0  terminal=RETF ----
  04A426  3E26: c8360000         enter 0x36, 0
  04A42A  3E2A: 56               push si
  04A42B  3E2B: 837e0804         cmp word ptr [bp + 8], 4
  04A42F  3E2F: 7d13             jge 0x3e44
  04A431  3E31: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04A435  3E35: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04A43A  3E3A: 7508             jne 0x3e44
  04A43C  3E3C: c746f00100       mov word ptr [bp - 0x10], 1
  04A441  3E41: eb06             jmp 0x3e49
  04A443  3E43: 90               nop 
  04A444  3E44: c746f00000       mov word ptr [bp - 0x10], 0
  04A449  3E49: 837ef000         cmp word ptr [bp - 0x10], 0
  04A44D  3E4D: 743c             je 0x3e8b
  04A44F  3E4F: 6a03             push 3
  04A451  3E51: 6a00             push 0
  04A453  3E53: 9ad4041f18       lcall 0x181f, 0x4d4
  04A458  3E58: 83c404           add sp, 4
  04A45B  3E5B: 0bc0             or ax, ax
  04A45D  3E5D: 752c             jne 0x3e8b
  04A45F  3E5F: 6a05             push 5
  04A461  3E61: 9a98041f18       lcall 0x181f, 0x498
  04A466  3E66: 83c402           add sp, 2
  04A469  3E69: 833e528d00       cmp word ptr [0x8d52], 0
  04A46E  3E6E: 750a             jne 0x3e7a
  04A470  3E70: 6a07             push 7
  04A472  3E72: 9a98041f18       lcall 0x181f, 0x498
  04A477  3E77: 83c402           add sp, 2
  04A47A  3E7A: 833e528d01       cmp word ptr [0x8d52], 1
  04A47F  3E7F: 750a             jne 0x3e8b
  04A481  3E81: 6a06             push 6
  04A483  3E83: 9a98041f18       lcall 0x181f, 0x498
  04A488  3E88: 83c402           add sp, 2
  04A48B  3E8B: 0e               push cs
  04A48C  3E8C: e8b415           call 0x5443
  04A48F  3E8F: ff367a91         push word ptr [0x917a]
  04A493  3E93: 9aca041f18       lcall 0x181f, 0x4ca
  04A498  3E98: 83c402           add sp, 2
  04A49B  3E9B: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04A49F  3E9F: 8a4701           mov al, byte ptr [bx + 1]
  04A4A2  3EA2: 2ae4             sub ah, ah
  04A4A4  3EA4: 2bd2             sub dx, dx
  04A4A6  3EA6: 8af2             mov dh, dl
  04A4A8  3EA8: 8ad4             mov dl, ah
  04A4AA  3EAA: 8ae0             mov ah, al
  04A4AC  3EAC: 2ac0             sub al, al
  04A4AE  3EAE: 8a0f             mov cl, byte ptr [bx]
  04A4B0  3EB0: 2aed             sub ch, ch
  04A4B2  3EB2: 03c1             add ax, cx
  04A4B4  3EB4: 83d200           adc dx, 0
  04A4B7  3EB7: 0306808d         add ax, word ptr [0x8d80]
  04A4BB  3EBB: 1316828d         adc dx, word ptr [0x8d82]
  04A4BF  3EBF: 8946f2           mov word ptr [bp - 0xe], ax
  04A4C2  3EC2: 8956f4           mov word ptr [bp - 0xc], dx
  04A4C5  3EC5: 52               push dx
  04A4C6  3EC6: 50               push ax
  04A4C7  3EC7: 9a900d1f18       lcall 0x181f, 0xd90
  04A4CC  3ECC: 83c404           add sp, 4
  04A4CF  3ECF: c706889e0000     mov word ptr [0x9e88], 0
  04A4D5  3ED5: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04A4D9  3ED9: 807f0201         cmp byte ptr [bx + 2], 1
  04A4DD  3EDD: 730c             jae 0x3eeb
  04A4DF  3EDF: 2bc0             sub ax, ax
  04A4E1  3EE1: a3909e           mov word ptr [0x9e90], ax
  04A4E4  3EE4: a3849e           mov word ptr [0x9e84], ax
  04A4E7  3EE7: d13e789e         sar word ptr [0x9e78], 1
  04A4EB  3EEB: 807f0202         cmp byte ptr [bx + 2], 2
  04A4EF  3EEF: 7315             jae 0x3f06
  04A4F1  3EF1: 2bc0             sub ax, ax
  04A4F3  3EF3: a38e9e           mov word ptr [0x9e8e], ax
  04A4F6  3EF6: a38c9e           mov word ptr [0x9e8c], ax
  04A4F9  3EF9: a3869e           mov word ptr [0x9e86], ax
  04A4FC  3EFC: a1789e           mov ax, word ptr [0x9e78]
  04A4FF  3EFF: c1f802           sar ax, 2
  04A502  3F02: 2906789e         sub word ptr [0x9e78], ax
  04A506  3F06: 807f0203         cmp byte ptr [bx + 2], 3
  04A50A  3F0A: 7306             jae 0x3f12
  04A50C  3F0C: c7068a9e0000     mov word ptr [0x9e8a], 0
  04A512  3F12: 807f0203         cmp byte ptr [bx + 2], 3
  04A516  3F16: 7509             jne 0x3f21
  04A518  3F18: a1869e           mov ax, word ptr [0x9e86]
  04A51B  3F1B: d1f8             sar ax, 1
  04A51D  3F1D: 0106869e         add word ptr [0x9e86], ax
  04A521  3F21: 2bc0             sub ax, ax
  04A523  3F23: 8946ea           mov word ptr [bp - 0x16], ax
  04A526  3F26: 8946e0           mov word ptr [bp - 0x20], ax
  04A529  3F29: eb10             jmp 0x3f3b
  04A52B  3F2B: 90               nop 
  04A52C  3F2C: 8b5ee0           mov bx, word ptr [bp - 0x20]
  04A52F  3F2F: d1e3             shl bx, 1
  04A531  3F31: 8b87789e         mov ax, word ptr [bx - 0x6188]
  04A535  3F35: 0146ea           add word ptr [bp - 0x16], ax
  04A538  3F38: ff46e0           inc word ptr [bp - 0x20]
  04A53B  3F3B: 837ee010         cmp word ptr [bp - 0x20], 0x10
  04A53F  3F3F: 7ceb             jl 0x3f2c
  04A541  3F41: ff76ea           push word ptr [bp - 0x16]
  04A544  3F44: 6a01             push 1
  04A546  3F46: 9ad4041f18       lcall 0x181f, 0x4d4
  04A54B  3F4B: 83c404           add sp, 4
  04A54E  3F4E: 8946ec           mov word ptr [bp - 0x14], ax
  04A551  3F51: c746caffff       mov word ptr [bp - 0x36], 0xffff
  04A556  3F56: ff46ca           inc word ptr [bp - 0x36]
  04A559  3F59: 8b5eca           mov bx, word ptr [bp - 0x36]
  04A55C  3F5C: d1e3             shl bx, 1
  04A55E  3F5E: 8b87789e         mov ax, word ptr [bx - 0x6188]
  04A562  3F62: 2946ec           sub word ptr [bp - 0x14], ax
  04A565  3F65: 837eec00         cmp word ptr [bp - 0x14], 0
  04A569  3F69: 7feb             jg 0x3f56
  04A56B  3F6B: 837eca04         cmp word ptr [bp - 0x36], 4
  04A56F  3F6F: 751e             jne 0x3f8f
  04A571  3F71: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04A575  3F75: 8a4701           mov al, byte ptr [bx + 1]
  04A578  3F78: 2ae4             sub ah, ah
  04A57A  3F7A: 8a0f             mov cl, byte ptr [bx]
  04A57C  3F7C: 2aed             sub ch, ch
  04A57E  3F7E: 03c1             add ax, cx
  04A580  3F80: b90300           mov cx, 3
  04A583  3F83: 99               cdq 
  04A584  3F84: f7f9             idiv cx
  04A586  3F86: 0bd2             or dx, dx
  04A588  3F88: 7505             jne 0x3f8f
  04A58A  3F8A: c746ca1600       mov word ptr [bp - 0x36], 0x16
  04A58F  3F8F: 837eca00         cmp word ptr [bp - 0x36], 0
  04A593  3F93: 755d             jne 0x3ff2
  04A595  3F95: 2bc0             sub ax, ax
  04A597  3F97: 8946e8           mov word ptr [bp - 0x18], ax
  04A59A  3F9A: 8946e6           mov word ptr [bp - 0x1a], ax
  04A59D  3F9D: eb37             jmp 0x3fd6
  04A59F  3F9F: 90               nop 
  04A5A0  3FA0: 8b5ee6           mov bx, word ptr [bp - 0x1a]
  04A5A3  3FA3: 8a87de00         mov al, byte ptr [bx + 0xde]
  04A5A7  3FA7: 98               cwde 
  04A5A8  3FA8: 8b364a8d         mov si, word ptr [0x8d4a]
  04A5AC  3FAC: 8a4c01           mov cl, byte ptr [si + 1]
  04A5AF  3FAF: 2aed             sub ch, ch
  04A5B1  3FB1: 03c1             add ax, cx
  04A5B3  3FB3: 8946e2           mov word ptr [bp - 0x1e], ax
  04A5B6  3FB6: 50               push ax
  04A5B7  3FB7: 8a87c800         mov al, byte ptr [bx + 0xc8]
  04A5BB  3FBB: 98               cwde 
  04A5BC  3FBC: 8a0c             mov cl, byte ptr [si]
  04A5BE  3FBE: 03c1             add ax, cx
  04A5C0  3FC0: 8946e4           mov word ptr [bp - 0x1c], ax
  04A5C3  3FC3: 50               push ax
  04A5C4  3FC4: 9a68071f18       lcall 0x181f, 0x768
  04A5C9  3FC9: 83c404           add sp, 4
  04A5CC  3FCC: 0bc0             or ax, ax
  04A5CE  3FCE: 7403             je 0x3fd3
  04A5D0  3FD0: ff46e8           inc word ptr [bp - 0x18]
  04A5D3  3FD3: ff46e6           inc word ptr [bp - 0x1a]
  04A5D6  3FD6: 837ee614         cmp word ptr [bp - 0x1a], 0x14
  04A5DA  3FDA: 7cc4             jl 0x3fa0
  04A5DC  3FDC: 6a14             push 0x14
  04A5DE  3FDE: 6a01             push 1
  04A5E0  3FE0: 9ad4041f18       lcall 0x181f, 0x4d4
  04A5E5  3FE5: 83c404           add sp, 4
  04A5E8  3FE8: 3b46e8           cmp ax, word ptr [bp - 0x18]
  04A5EB  3FEB: 7d05             jge 0x3ff2
  04A5ED  3FED: c746ca0800       mov word ptr [bp - 0x36], 8
  04A5F2  3FF2: ff36a683         push word ptr [0x83a6]
  04A5F6  3FF6: 9aca041f18       lcall 0x181f, 0x4ca
  04A5FB  3FFB: 83c402           add sp, 2
  04A5FE  3FFE: 837e0c00         cmp word ptr [bp + 0xc], 0
  04A602  4002: 7403             je 0x4007
  04A604  4004: e9bc01           jmp 0x41c3
  04A607  4007: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04A60B  400B: 8a875b31         mov al, byte ptr [bx + 0x315b]
  04A60F  400F: 98               cwde 
  04A610  4010: 8946ee           mov word ptr [bp - 0x12], ax
  04A613  4013: ff760a           push word ptr [bp + 0xa]
  04A616  4016: 9a1a0a1f18       lcall 0x181f, 0xa1a
  04A61B  401B: 83c402           add sp, 2
  04A61E  401E: 50               push ax
  04A61F  401F: 6a00             push 0
  04A621  4021: 9a38041f18       lcall 0x181f, 0x438
  04A626  4026: 83c404           add sp, 4
  04A629  4029: 8b5eca           mov bx, word ptr [bp - 0x36]
  04A62C  402C: c1e303           shl bx, 3
  04A62F  402F: ffb7a28e         push word ptr [bx - 0x715e]
  04A633  4033: 6a01             push 1
  04A635  4035: 9a38041f18       lcall 0x181f, 0x438
  04A63A  403A: 83c404           add sp, 4
  04A63D  403D: ff7608           push word ptr [bp + 8]
  04A640  4040: ff36528d         push word ptr [0x8d52]
  04A644  4044: 9a0c031f18       lcall 0x181f, 0x30c
  04A649  4049: 83c404           add sp, 4
  04A64C  404C: 50               push ax
  04A64D  404D: 9a600a1f18       lcall 0x181f, 0xa60
  04A652  4052: 83c402           add sp, 2
  04A655  4055: 3d0100           cmp ax, 1
  04A658  4058: 7e40             jle 0x409a
  04A65A  405A: 68e715           push 0x15e7
  04A65D  405D: 8d46f6           lea ax, [bp - 0xa]
  04A660  4060: 50               push ax
  04A661  4061: 9ae4071d0d       lcall 0xd1d, 0x7e4
  04A666  4066: 83c404           add sp, 4
  04A669  4069: 6a00             push 0
  04A66B  406B: 6a03             push 3
  04A66D  406D: ff7608           push word ptr [bp + 8]
  04A670  4070: ff36528d         push word ptr [0x8d52]
  04A674  4074: 9a6c0d1f18       lcall 0x181f, 0xd6c
  04A679  4079: 83c408           add sp, 8
  04A67C  407C: ff760a           push word ptr [bp + 0xa]
  04A67F  407F: ff7608           push word ptr [bp + 8]
  04A682  4082: 9a380a1f18       lcall 0x181f, 0xa38
  04A687  4087: 83c404           add sp, 4
  04A68A  408A: 2460             and al, 0x60
  04A68C  408C: 3c20             cmp al, 0x20
  04A68E  408E: 7403             je 0x4093
  04A690  4090: e9fb00           jmp 0x418e
  04A693  4093: 8b46ca           mov ax, word ptr [bp - 0x36]
  04A696  4096: 5e               pop si
  04A697  4097: c9               leave 
  04A698  4098: cb               retf 
  04A699  4099: 90               nop 
  04A69A  409A: 837eee1a         cmp word ptr [bp - 0x12], 0x1a
  04A69E  409E: 7512             jne 0x40b2
  04A6A0  40A0: 68eb15           push 0x15eb
  04A6A3  40A3: 8d46f6           lea ax, [bp - 0xa]
  04A6A6  40A6: 50               push ax
  04A6A7  40A7: 9ae4071d0d       lcall 0xd1d, 0x7e4
  04A6AC  40AC: 83c404           add sp, 4
  04A6AF  40AF: e9dc00           jmp 0x418e
  04A6B2  40B2: 837eee1b         cmp word ptr [bp - 0x12], 0x1b
  04A6B6  40B6: 7510             jne 0x40c8
  04A6B8  40B8: 8d1ef415         lea bx, [0x15f4]
  04A6BC  40BC: 9afe031f18       lcall 0x181f, 0x3fe
  04A6C1  40C1: 8b46ca           mov ax, word ptr [bp - 0x36]
  04A6C4  40C4: 5e               pop si
  04A6C5  40C5: c9               leave 
  04A6C6  40C6: cb               retf 
  04A6C7  40C7: 90               nop 
  04A6C8  40C8: 837eee1c         cmp word ptr [bp - 0x12], 0x1c
  04A6CC  40CC: 7420             je 0x40ee
  04A6CE  40CE: 837eee19         cmp word ptr [bp - 0x12], 0x19
  04A6D2  40D2: 741a             je 0x40ee
  04A6D4  40D4: 8b5eee           mov bx, word ptr [bp - 0x12]
  04A6D7  40D7: c1e303           shl bx, 3
  04A6DA  40DA: ffb7a28e         push word ptr [bx - 0x715e]
  04A6DE  40DE: 6a01             push 1
  04A6E0  40E0: 9a38041f18       lcall 0x181f, 0x438
  04A6E5  40E5: 83c404           add sp, 4
  04A6E8  40E8: 680116           push 0x1601
  04A6EB  40EB: ebb6             jmp 0x40a3
  04A6ED  40ED: 90               nop 
  04A6EE  40EE: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04A6F2  40F2: f6470302         test byte ptr [bx + 3], 2
  04A6F6  40F6: 740c             je 0x4104
  04A6F8  40F8: f6470304         test byte ptr [bx + 3], 4
  04A6FC  40FC: 7506             jne 0x4104
  04A6FE  40FE: 680816           push 0x1608
  04A701  4101: eba0             jmp 0x40a3
  04A703  4103: 90               nop 
  04A704  4104: ff36a683         push word ptr [0x83a6]
  04A708  4108: 9aca041f18       lcall 0x181f, 0x4ca
  04A70D  410D: 83c402           add sp, 2
  04A710  4110: ff7608           push word ptr [bp + 8]
  04A713  4113: ff36528d         push word ptr [0x8d52]
  04A717  4117: 9a0c031f18       lcall 0x181f, 0x30c
  04A71C  411C: 83c404           add sp, 4
  04A71F  411F: 50               push ax
  04A720  4120: 9a600a1f18       lcall 0x181f, 0xa60
  04A725  4125: 83c402           add sp, 2
  04A728  4128: 0bc0             or ax, ax
  04A72A  412A: 7e22             jle 0x414e
  04A72C  412C: 68e803           push 0x3e8
  04A72F  412F: 6a01             push 1
  04A731  4131: 9ad4041f18       lcall 0x181f, 0x4d4
  04A736  4136: 83c404           add sp, 4
  04A739  4139: 8bc8             mov cx, ax
  04A73B  413B: b0c8             mov al, 0xc8
  04A73D  413D: f626a653         mul byte ptr [0x53a6]
  04A741  4141: 056400           add ax, 0x64
  04A744  4144: 3bc1             cmp ax, cx
  04A746  4146: 7e06             jle 0x414e
  04A748  4148: 681016           push 0x1610
  04A74B  414B: e955ff           jmp 0x40a3
  04A74E  414E: 837ef000         cmp word ptr [bp - 0x10], 0
  04A752  4152: 7418             je 0x416c
  04A754  4154: ff36528d         push word ptr [0x8d52]
  04A758  4158: 681516           push 0x1615
  04A75B  415B: 9a9c011f19       lcall 0x191f, 0x19c
  04A760  4160: 83c404           add sp, 4
  04A763  4163: 48               dec ax
  04A764  4164: 7406             je 0x416c
  04A766  4166: 681f16           push 0x161f
  04A769  4169: e937ff           jmp 0x40a3
  04A76C  416C: 682516           push 0x1625
  04A76F  416F: 8d46f6           lea ax, [bp - 0xa]
  04A772  4172: 50               push ax
  04A773  4173: 9ae4071d0d       lcall 0xd1d, 0x7e4
  04A778  4178: 83c404           add sp, 4
  04A77B  417B: 8a46ca           mov al, byte ptr [bp - 0x36]
  04A77E  417E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04A782  4182: 88875b31         mov byte ptr [bx + 0x315b], al
  04A786  4186: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04A78A  418A: 804f0302         or byte ptr [bx + 3], 2
  04A78E  418E: 682a16           push 0x162a
  04A791  4191: 8d46cc           lea ax, [bp - 0x34]
  04A794  4194: 50               push ax
  04A795  4195: 9ae4071d0d       lcall 0xd1d, 0x7e4
  04A79A  419A: 83c404           add sp, 4
  04A79D  419D: 8d46f6           lea ax, [bp - 0xa]
  04A7A0  41A0: 50               push ax
  04A7A1  41A1: 8d46cc           lea ax, [bp - 0x34]
  04A7A4  41A4: 50               push ax
  04A7A5  41A5: 9aa4071d0d       lcall 0xd1d, 0x7a4
  04A7AA  41AA: 83c404           add sp, 4
  04A7AD  41AD: 837ef000         cmp word ptr [bp - 0x10], 0
  04A7B1  41B1: 7410             je 0x41c3
  04A7B3  41B3: ff36528d         push word ptr [0x8d52]
  04A7B7  41B7: 8d46cc           lea ax, [bp - 0x34]
  04A7BA  41BA: 50               push ax
  04A7BB  41BB: 9a9c011f19       lcall 0x191f, 0x19c
  04A7C0  41C0: 83c404           add sp, 4
  04A7C3  41C3: 8b46ca           mov ax, word ptr [bp - 0x36]
  04A7C6  41C6: 5e               pop si
  04A7C7  41C7: c9               leave 
  04A7C8  41C8: cb               retf 

; ---- func_04A7CA  size=1077  insns=361  prologue=ENTER 0x0024,0  terminal=RETF ----
  04A7CA  41CA: c8240000         enter 0x24, 0
  04A7CE  41CE: 57               push di
  04A7CF  41CF: 56               push si
  04A7D0  41D0: c746e60000       mov word ptr [bp - 0x1a], 0
  04A7D5  41D5: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04A7D9  41D9: 80bf5b3116       cmp byte ptr [bx + 0x315b], 0x16
  04A7DE  41DE: 7506             jne 0x41e6
  04A7E0  41E0: b80100           mov ax, 1
  04A7E3  41E3: eb03             jmp 0x41e8
  04A7E5  41E5: 90               nop 
  04A7E6  41E6: 2bc0             sub ax, ax
  04A7E8  41E8: 8946dc           mov word ptr [bp - 0x24], ax
  04A7EB  41EB: ff7608           push word ptr [bp + 8]
  04A7EE  41EE: ff36528d         push word ptr [0x8d52]
  04A7F2  41F2: 9a0c031f18       lcall 0x181f, 0x30c
  04A7F7  41F7: 83c404           add sp, 4
  04A7FA  41FA: 8946de           mov word ptr [bp - 0x22], ax
  04A7FD  41FD: 3d4b00           cmp ax, 0x4b
  04A800  4200: 7c18             jl 0x421a
  04A802  4202: 6a06             push 6
  04A804  4204: ff7608           push word ptr [bp + 8]
  04A807  4207: 9ab4071f18       lcall 0x181f, 0x7b4
  04A80C  420C: 83c404           add sp, 4
  04A80F  420F: 0bc0             or ax, ax
  04A811  4211: 7503             jne 0x4216
  04A813  4213: e95c03           jmp 0x4572
  04A816  4216: e9a903           jmp 0x45c2
  04A819  4219: 90               nop 
  04A81A  421A: 6b46dc28         imul ax, word ptr [bp - 0x24], 0x28
  04A81E  421E: 056400           add ax, 0x64
  04A821  4221: 8946fe           mov word ptr [bp - 2], ax
  04A824  4224: 50               push ax
  04A825  4225: 6a00             push 0
  04A827  4227: 9ad4041f18       lcall 0x181f, 0x4d4
  04A82C  422C: 83c404           add sp, 4
  04A82F  422F: 8946e8           mov word ptr [bp - 0x18], ax
  04A832  4232: 837ede19         cmp word ptr [bp - 0x22], 0x19
  04A836  4236: 7c0b             jl 0x4243
  04A838  4238: 8b46de           mov ax, word ptr [bp - 0x22]
  04A83B  423B: c1f802           sar ax, 2
  04A83E  423E: 3b46e8           cmp ax, word ptr [bp - 0x18]
  04A841  4241: 7dbf             jge 0x4202
  04A843  4243: 833e528d02       cmp word ptr [0x8d52], 2
  04A848  4248: 7521             jne 0x426b
  04A84A  424A: 8a4edc           mov cl, byte ptr [bp - 0x24]
  04A84D  424D: a0a653           mov al, byte ptr [0x53a6]
  04A850  4250: 2ae4             sub ah, ah
  04A852  4252: 2d0800           sub ax, 8
  04A855  4255: f7d8             neg ax
  04A857  4257: d3e0             shl ax, cl
  04A859  4259: 8946fe           mov word ptr [bp - 2], ax
  04A85C  425C: 50               push ax
  04A85D  425D: 6a00             push 0
  04A85F  425F: 9ad4041f18       lcall 0x181f, 0x4d4
  04A864  4264: 83c404           add sp, 4
  04A867  4267: 0bc0             or ax, ax
  04A869  4269: 7497             je 0x4202
  04A86B  426B: 837e0804         cmp word ptr [bp + 8], 4
  04A86F  426F: 7c03             jl 0x4274
  04A871  4271: e9f000           jmp 0x4364
  04A874  4274: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04A878  4278: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04A87D  427D: 7403             je 0x4282
  04A87F  427F: e9e200           jmp 0x4364
  04A882  4282: 6a01             push 1
  04A884  4284: ff760a           push word ptr [bp + 0xa]
  04A887  4287: ff7608           push word ptr [bp + 8]
  04A88A  428A: ff7606           push word ptr [bp + 6]
  04A88D  428D: 0e               push cs
  04A88E  428E: e8ad11           call 0x543e
  04A891  4291: 83c408           add sp, 8
  04A894  4294: 8946ea           mov word ptr [bp - 0x16], ax
  04A897  4297: ff760a           push word ptr [bp + 0xa]
  04A89A  429A: 6aff             push -1
  04A89C  429C: ff364c8d         push word ptr [0x8d4c]
  04A8A0  42A0: ff7606           push word ptr [bp + 6]
  04A8A3  42A3: 0e               push cs
  04A8A4  42A4: e8a111           call 0x5448
  04A8A7  42A7: 83c408           add sp, 8
  04A8AA  42AA: c746e40000       mov word ptr [bp - 0x1c], 0
  04A8AF  42AF: 8a46e4           mov al, byte ptr [bp - 0x1c]
  04A8B2  42B2: 8b76e4           mov si, word ptr [bp - 0x1c]
  04A8B5  42B5: 8842ee           mov byte ptr [bp + si - 0x12], al
  04A8B8  42B8: ff46e4           inc word ptr [bp - 0x1c]
  04A8BB  42BB: 837ee410         cmp word ptr [bp - 0x1c], 0x10
  04A8BF  42BF: 7cee             jl 0x42af
  04A8C1  42C1: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04A8C5  42C5: 807f0800         cmp byte ptr [bx + 8], 0
  04A8C9  42C9: 7c0e             jl 0x42d9
  04A8CB  42CB: 8a4708           mov al, byte ptr [bx + 8]
  04A8CE  42CE: 98               cwde 
  04A8CF  42CF: 8bd8             mov bx, ax
  04A8D1  42D1: d1e3             shl bx, 1
  04A8D3  42D3: c787589e0000     mov word ptr [bx - 0x61a8], 0
  04A8D9  42D9: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04A8DD  42DD: 807f0900         cmp byte ptr [bx + 9], 0
  04A8E1  42E1: 7c0e             jl 0x42f1
  04A8E3  42E3: 8a4709           mov al, byte ptr [bx + 9]
  04A8E6  42E6: 98               cwde 
  04A8E7  42E7: 8bd8             mov bx, ax
  04A8E9  42E9: d1e3             shl bx, 1
  04A8EB  42EB: c787589e0000     mov word ptr [bx - 0x61a8], 0
  04A8F1  42F1: 8d46ee           lea ax, [bp - 0x12]
  04A8F4  42F4: 16               push ss
  04A8F5  42F5: 50               push ax
  04A8F6  42F6: 1e               push ds
  04A8F7  42F7: 68589e           push 0x9e58
  04A8FA  42FA: b81000           mov ax, 0x10
  04A8FD  42FD: 9ad00e1f19       lcall 0x191f, 0xed0
  04A902  4302: 8b5eea           mov bx, word ptr [bp - 0x16]
  04A905  4305: c1e303           shl bx, 3
  04A908  4308: ffb7a48e         push word ptr [bx - 0x715c]
  04A90C  430C: 6a00             push 0
  04A90E  430E: 9a38041f18       lcall 0x181f, 0x438
  04A913  4313: 83c404           add sp, 4
  04A916  4316: 8a5efd           mov bl, byte ptr [bp - 3]
  04A919  4319: 2aff             sub bh, bh
  04A91B  431B: d1e3             shl bx, 1
  04A91D  431D: ffb7c097         push word ptr [bx - 0x6840]
  04A921  4321: 6a01             push 1
  04A923  4323: 9a38041f18       lcall 0x181f, 0x438
  04A928  4328: 83c404           add sp, 4
  04A92B  432B: 8a5efc           mov bl, byte ptr [bp - 4]
  04A92E  432E: 2aff             sub bh, bh
  04A930  4330: d1e3             shl bx, 1
  04A932  4332: ffb7c097         push word ptr [bx - 0x6840]
  04A936  4336: 6a02             push 2
  04A938  4338: 9a38041f18       lcall 0x181f, 0x438
  04A93D  433D: 83c404           add sp, 4
  04A940  4340: 8a5efb           mov bl, byte ptr [bp - 5]
  04A943  4343: 2aff             sub bh, bh
  04A945  4345: d1e3             shl bx, 1
  04A947  4347: ffb7c097         push word ptr [bx - 0x6840]
  04A94B  434B: 6a03             push 3
  04A94D  434D: 9a38041f18       lcall 0x181f, 0x438
  04A952  4352: 83c404           add sp, 4
  04A955  4355: ff36528d         push word ptr [0x8d52]
  04A959  4359: 683016           push 0x1630
  04A95C  435C: 9a9c011f19       lcall 0x191f, 0x19c
  04A961  4361: 83c404           add sp, 4
  04A964  4364: ff760a           push word ptr [bp + 0xa]
  04A967  4367: 9aa4091f18       lcall 0x181f, 0x9a4
  04A96C  436C: 83c402           add sp, 2
  04A96F  436F: 50               push ax
  04A970  4370: 6a00             push 0
  04A972  4372: 9a38041f18       lcall 0x181f, 0x438
  04A977  4377: 83c404           add sp, 4
  04A97A  437A: 8b46de           mov ax, word ptr [bp - 0x22]
  04A97D  437D: 3946e8           cmp word ptr [bp - 0x18], ax
  04A980  4380: 7f03             jg 0x4385
  04A982  4382: e93d02           jmp 0x45c2
  04A985  4385: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04A989  4389: f6470308         test byte ptr [bx + 3], 8
  04A98D  438D: 7403             je 0x4392
  04A98F  438F: e93002           jmp 0x45c2
  04A992  4392: 804f0308         or byte ptr [bx + 3], 8
  04A996  4396: 6a03             push 3
  04A998  4398: 6a01             push 1
  04A99A  439A: 9ad4041f18       lcall 0x181f, 0x4d4
  04A99F  439F: 83c404           add sp, 4
  04A9A2  43A2: 8946fe           mov word ptr [bp - 2], ax
  04A9A5  43A5: 48               dec ax
  04A9A6  43A6: 740c             je 0x43b4
  04A9A8  43A8: 48               dec ax
  04A9A9  43A9: 7475             je 0x4420
  04A9AB  43AB: 48               dec ax
  04A9AC  43AC: 7503             jne 0x43b1
  04A9AE  43AE: e90901           jmp 0x44ba
  04A9B1  43B1: e90e02           jmp 0x45c2
  04A9B4  43B4: 837edc00         cmp word ptr [bp - 0x24], 0
  04A9B8  43B8: 7566             jne 0x4420
  04A9BA  43BA: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04A9BE  43BE: 8a5f02           mov bl, byte ptr [bx + 2]
  04A9C1  43C1: 2aff             sub bh, bh
  04A9C3  43C3: 8bc3             mov ax, bx
  04A9C5  43C5: d1e3             shl bx, 1
  04A9C7  43C7: 03d8             add bx, ax
  04A9C9  43C9: d1e3             shl bx, 1
  04A9CB  43CB: ffb73496         push word ptr [bx - 0x69cc]
  04A9CF  43CF: 6a01             push 1
  04A9D1  43D1: 9a38041f18       lcall 0x181f, 0x438
  04A9D6  43D6: 83c404           add sp, 4
  04A9D9  43D9: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04A9DD  43DD: c6875b3116       mov byte ptr [bx + 0x315b], 0x16
  04A9E2  43E2: 837e0804         cmp word ptr [bp + 8], 4
  04A9E6  43E6: 7c03             jl 0x43eb
  04A9E8  43E8: e90d02           jmp 0x45f8
  04A9EB  43EB: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04A9EF  43EF: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04A9F4  43F4: 7403             je 0x43f9
  04A9F6  43F6: e9ff01           jmp 0x45f8
  04A9F9  43F9: ff36528d         push word ptr [0x8d52]
  04A9FD  43FD: 683b16           push 0x163b
  04AA00  4400: 9a9c011f19       lcall 0x191f, 0x19c
  04AA05  4405: 83c404           add sp, 4
  04AA08  4408: 6a01             push 1
  04AA0A  440A: 9a1c0e1f18       lcall 0x181f, 0xe1c
  04AA0F  440F: 83c402           add sp, 2
  04AA12  4412: 6a03             push 3
  04AA14  4414: 684716           push 0x1647
  04AA17  4417: 9a52061f18       lcall 0x181f, 0x652
  04AA1C  441C: e9d601           jmp 0x45f5
  04AA1F  441F: 90               nop 
  04AA20  4420: 837e0804         cmp word ptr [bp + 8], 4
  04AA24  4424: 7d34             jge 0x445a
  04AA26  4426: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04AA2A  442A: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04AA2F  442F: 7529             jne 0x445a
  04AA31  4431: 6a00             push 0
  04AA33  4433: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04AA37  4437: 8a874531         mov al, byte ptr [bx + 0x3145]
  04AA3B  443B: 2ae4             sub ah, ah
  04AA3D  443D: 50               push ax
  04AA3E  443E: 8a874431         mov al, byte ptr [bx + 0x3144]
  04AA42  4442: 50               push ax
  04AA43  4443: 9a080e1f18       lcall 0x181f, 0xe08
  04AA48  4448: 83c406           add sp, 6
  04AA4B  444B: ff36528d         push word ptr [0x8d52]
  04AA4F  444F: 685416           push 0x1654
  04AA52  4452: 9a9c011f19       lcall 0x191f, 0x19c
  04AA57  4457: 83c404           add sp, 4
  04AA5A  445A: 8b4606           mov ax, word ptr [bp + 6]
  04AA5D  445D: ba0600           mov dx, 6
  04AA60  4460: 9a96071f18       lcall 0x181f, 0x796
  04AA65  4465: 837e0804         cmp word ptr [bp + 8], 4
  04AA69  4469: 7c03             jl 0x446e
  04AA6B  446B: e98a01           jmp 0x45f8
  04AA6E  446E: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04AA72  4472: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04AA77  4477: 7403             je 0x447c
  04AA79  4479: e97c01           jmp 0x45f8
  04AA7C  447C: 6a00             push 0
  04AA7E  447E: 9a1c0e1f18       lcall 0x181f, 0xe1c
  04AA83  4483: 83c402           add sp, 2
  04AA86  4486: 9a88021f19       lcall 0x191f, 0x288
  04AA8B  448B: 9a06000c0c       lcall 0xc0c, 6
  04AA90  4490: 8946e0           mov word ptr [bp - 0x20], ax
  04AA93  4493: 8956e2           mov word ptr [bp - 0x1e], dx
  04AA96  4496: 9a06000c0c       lcall 0xc0c, 6
  04AA9B  449B: 8b4ee0           mov cx, word ptr [bp - 0x20]
  04AA9E  449E: 8b5ee2           mov bx, word ptr [bp - 0x1e]
  04AAA1  44A1: 83c13c           add cx, 0x3c
  04AAA4  44A4: 83d300           adc bx, 0
  04AAA7  44A7: 3bd3             cmp dx, bx
  04AAA9  44A9: 7e03             jle 0x44ae
  04AAAB  44AB: e94a01           jmp 0x45f8
  04AAAE  44AE: 7ce6             jl 0x4496
  04AAB0  44B0: 3bc1             cmp ax, cx
  04AAB2  44B2: 7203             jb 0x44b7
  04AAB4  44B4: e94101           jmp 0x45f8
  04AAB7  44B7: ebdd             jmp 0x4496
  04AAB9  44B9: 90               nop 
  04AABA  44BA: ff7608           push word ptr [bp + 8]
  04AABD  44BD: 9aa4091f18       lcall 0x181f, 0x9a4
  04AAC2  44C2: 83c402           add sp, 2
  04AAC5  44C5: 50               push ax
  04AAC6  44C6: 6a01             push 1
  04AAC8  44C8: 9a38041f18       lcall 0x181f, 0x438
  04AACD  44CD: 83c404           add sp, 4
  04AAD0  44D0: a0a653           mov al, byte ptr [0x53a6]
  04AAD3  44D3: 2ae4             sub ah, ah
  04AAD5  44D5: 2d0a00           sub ax, 0xa
  04AAD8  44D8: f7d8             neg ax
  04AADA  44DA: 8946fe           mov word ptr [bp - 2], ax
  04AADD  44DD: 50               push ax
  04AADE  44DE: 6a01             push 1
  04AAE0  44E0: 8bf0             mov si, ax
  04AAE2  44E2: 9ad4041f18       lcall 0x181f, 0x4d4
  04AAE7  44E7: 83c404           add sp, 4
  04AAEA  44EA: 56               push si
  04AAEB  44EB: 6a01             push 1
  04AAED  44ED: 8bf8             mov di, ax
  04AAEF  44EF: 9ad4041f18       lcall 0x181f, 0x4d4
  04AAF4  44F4: 83c404           add sp, 4
  04AAF7  44F7: 56               push si
  04AAF8  44F8: 6a01             push 1
  04AAFA  44FA: 8bf0             mov si, ax
  04AAFC  44FC: 9ad4041f18       lcall 0x181f, 0x4d4
  04AB01  4501: 83c404           add sp, 4
  04AB04  4504: 03f0             add si, ax
  04AB06  4506: 03fe             add di, si
  04AB08  4508: 897eec           mov word ptr [bp - 0x14], di
  04AB0B  450B: 6a06             push 6
  04AB0D  450D: 6a01             push 1
  04AB0F  450F: 9ad4041f18       lcall 0x181f, 0x4d4
  04AB14  4514: 83c404           add sp, 4
  04AB17  4517: f76eec           imul word ptr [bp - 0x14]
  04AB1A  451A: c1e002           shl ax, 2
  04AB1D  451D: 8946ec           mov word ptr [bp - 0x14], ax
  04AB20  4520: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04AB24  4524: 8a4702           mov al, byte ptr [bx + 2]
  04AB27  4527: 2ae4             sub ah, ah
  04AB29  4529: 40               inc ax
  04AB2A  452A: f76eec           imul word ptr [bp - 0x14]
  04AB2D  452D: 8946ec           mov word ptr [bp - 0x14], ax
  04AB30  4530: 99               cdq 
  04AB31  4531: 52               push dx
  04AB32  4532: 50               push ax
  04AB33  4533: 6a00             push 0
  04AB35  4535: 9aae091f18       lcall 0x181f, 0x9ae
  04AB3A  453A: 83c406           add sp, 6
  04AB3D  453D: 837e0804         cmp word ptr [bp + 8], 4
  04AB41  4541: 7d1a             jge 0x455d
  04AB43  4543: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04AB47  4547: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04AB4C  454C: 750f             jne 0x455d
  04AB4E  454E: ff36528d         push word ptr [0x8d52]
  04AB52  4552: 685e16           push 0x165e
  04AB55  4555: 9a9c011f19       lcall 0x191f, 0x19c
  04AB5A  455A: 83c404           add sp, 4
  04AB5D  455D: 8b46ec           mov ax, word ptr [bp - 0x14]
  04AB60  4560: 99               cdq 
  04AB61  4561: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  04AB66  4566: 01873288         add word ptr [bx - 0x77ce], ax
  04AB6A  456A: 11973488         adc word ptr [bx - 0x77cc], dx
  04AB6E  456E: e98700           jmp 0x45f8
  04AB71  4571: 90               nop 
  04AB72  4572: c746e60100       mov word ptr [bp - 0x1a], 1
  04AB77  4577: ff760a           push word ptr [bp + 0xa]
  04AB7A  457A: 9aa4091f18       lcall 0x181f, 0x9a4
  04AB7F  457F: 83c402           add sp, 2
  04AB82  4582: 50               push ax
  04AB83  4583: 6a00             push 0
  04AB85  4585: 9a38041f18       lcall 0x181f, 0x438
  04AB8A  458A: 83c404           add sp, 4
  04AB8D  458D: 837e0804         cmp word ptr [bp + 8], 4
  04AB91  4591: 7d22             jge 0x45b5
  04AB93  4593: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04AB97  4597: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04AB9C  459C: 7517             jne 0x45b5
  04AB9E  459E: b85500           mov ax, 0x55
  04ABA1  45A1: 9ac0041f18       lcall 0x181f, 0x4c0
  04ABA6  45A6: ff36528d         push word ptr [0x8d52]
  04ABAA  45AA: 686816           push 0x1668
  04ABAD  45AD: 9a9c011f19       lcall 0x191f, 0x19c
  04ABB2  45B2: 83c404           add sp, 4
  04ABB5  45B5: ff7606           push word ptr [bp + 6]
  04ABB8  45B8: 9a08081f18       lcall 0x181f, 0x808
  04ABBD  45BD: 83c402           add sp, 2
  04ABC0  45C0: eb36             jmp 0x45f8
  04ABC2  45C2: ff7608           push word ptr [bp + 8]
  04ABC5  45C5: 9aa4091f18       lcall 0x181f, 0x9a4
  04ABCA  45CA: 83c402           add sp, 2
  04ABCD  45CD: 50               push ax
  04ABCE  45CE: 6a01             push 1
  04ABD0  45D0: 9a38041f18       lcall 0x181f, 0x438
  04ABD5  45D5: 83c404           add sp, 4
  04ABD8  45D8: 837e0804         cmp word ptr [bp + 8], 4
  04ABDC  45DC: 7d1a             jge 0x45f8
  04ABDE  45DE: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04ABE2  45E2: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04ABE7  45E7: 750f             jne 0x45f8
  04ABE9  45E9: ff36528d         push word ptr [0x8d52]
  04ABED  45ED: 687216           push 0x1672
  04ABF0  45F0: 9a9c011f19       lcall 0x191f, 0x19c
  04ABF5  45F5: 83c404           add sp, 4
  04ABF8  45F8: 8b46e6           mov ax, word ptr [bp - 0x1a]
  04ABFB  45FB: 5e               pop si
  04ABFC  45FC: 5f               pop di
  04ABFD  45FD: c9               leave 
  04ABFE  45FE: cb               retf 

; ---- func_04AC00  size=861  insns=289  prologue=ENTER 0x002A,0  terminal=RETF ----
  04AC00  4600: c82a0000         enter 0x2a, 0
  04AC04  4604: 56               push si
  04AC05  4605: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04AC09  4609: 8a874431         mov al, byte ptr [bx + 0x3144]
  04AC0D  460D: 2ae4             sub ah, ah
  04AC0F  460F: 8946e8           mov word ptr [bp - 0x18], ax
  04AC12  4612: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  04AC16  4616: 2aed             sub ch, ch
  04AC18  4618: 894ee2           mov word ptr [bp - 0x1e], cx
  04AC1B  461B: 51               push cx
  04AC1C  461C: 50               push ax
  04AC1D  461D: 9a22071f18       lcall 0x181f, 0x722
  04AC22  4622: 83c404           add sp, 4
  04AC25  4625: 8946fa           mov word ptr [bp - 6], ax
  04AC28  4628: ff7608           push word ptr [bp + 8]
  04AC2B  462B: ff36528d         push word ptr [0x8d52]
  04AC2F  462F: 9a0c031f18       lcall 0x181f, 0x30c
  04AC34  4634: 83c404           add sp, 4
  04AC37  4637: 8946d6           mov word ptr [bp - 0x2a], ax
  04AC3A  463A: 8b7608           mov si, word ptr [bp + 8]
  04AC3D  463D: c1e604           shl si, 4
  04AC40  4640: 8b5efa           mov bx, word ptr [bp - 6]
  04AC43  4643: 8a80b295         mov al, byte ptr [bx + si - 0x6a4e]
  04AC47  4647: 2ae4             sub ah, ah
  04AC49  4649: 8b5e08           mov bx, word ptr [bp + 8]
  04AC4C  464C: d1e3             shl bx, 1
  04AC4E  464E: 8b8f1c94         mov cx, word ptr [bx - 0x6be4]
  04AC52  4652: d1e9             shr cx, 1
  04AC54  4654: 03c1             add ax, cx
  04AC56  4656: 8946e6           mov word ptr [bp - 0x1a], ax
  04AC59  4659: 837e0802         cmp word ptr [bp + 8], 2
  04AC5D  465D: 7508             jne 0x4667
  04AC5F  465F: d1f8             sar ax, 1
  04AC61  4661: 0346e6           add ax, word ptr [bp - 0x1a]
  04AC64  4664: 8946e6           mov word ptr [bp - 0x1a], ax
  04AC67  4667: 6a0a             push 0xa
  04AC69  4669: ff7608           push word ptr [bp + 8]
  04AC6C  466C: 9ab4071f18       lcall 0x181f, 0x7b4
  04AC71  4671: 83c404           add sp, 4
  04AC74  4674: 0bc0             or ax, ax
  04AC76  4676: 7408             je 0x4680
  04AC78  4678: 8b46e6           mov ax, word ptr [bp - 0x1a]
  04AC7B  467B: d1f8             sar ax, 1
  04AC7D  467D: 0146e6           add word ptr [bp - 0x1a], ax
  04AC80  4680: 8b36528d         mov si, word ptr [0x8d52]
  04AC84  4684: c1e604           shl si, 4
  04AC87  4687: 8b5efa           mov bx, word ptr [bp - 6]
  04AC8A  468A: 8a80cc91         mov al, byte ptr [bx + si - 0x6e34]
  04AC8E  468E: 2ae4             sub ah, ah
  04AC90  4690: 8b1e528d         mov bx, word ptr [0x8d52]
  04AC94  4694: 8a8f8491         mov cl, byte ptr [bx - 0x6e7c]
  04AC98  4698: d0e9             shr cl, 1
  04AC9A  469A: 2aed             sub ch, ch
  04AC9C  469C: 03c1             add ax, cx
  04AC9E  469E: d1e0             shl ax, 1
  04ACA0  46A0: 8b4ed6           mov cx, word ptr [bp - 0x2a]
  04ACA3  46A3: d1f9             sar cx, 1
  04ACA5  46A5: 03c1             add ax, cx
  04ACA7  46A7: 8946e0           mov word ptr [bp - 0x20], ax
  04ACAA  46AA: 837e0804         cmp word ptr [bp + 8], 4
  04ACAE  46AE: 7d16             jge 0x46c6
  04ACB0  46B0: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04ACB4  46B4: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04ACB9  46B9: 750b             jne 0x46c6
  04ACBB  46BB: a0a653           mov al, byte ptr [0x53a6]
  04ACBE  46BE: 2ae4             sub ah, ah
  04ACC0  46C0: 40               inc ax
  04ACC1  46C1: 8946dc           mov word ptr [bp - 0x24], ax
  04ACC4  46C4: eb05             jmp 0x46cb
  04ACC6  46C6: c746dc0100       mov word ptr [bp - 0x24], 1
  04ACCB  46CB: ff76e6           push word ptr [bp - 0x1a]
  04ACCE  46CE: 6a00             push 0
  04ACD0  46D0: 9ad4041f18       lcall 0x181f, 0x4d4
  04ACD5  46D5: 83c404           add sp, 4
  04ACD8  46D8: ff76e0           push word ptr [bp - 0x20]
  04ACDB  46DB: 6a00             push 0
  04ACDD  46DD: 8bf0             mov si, ax
  04ACDF  46DF: 9ad4041f18       lcall 0x181f, 0x4d4
  04ACE4  46E4: 83c404           add sp, 4
  04ACE7  46E7: 3bc6             cmp ax, si
  04ACE9  46E9: 7d05             jge 0x46f0
  04ACEB  46EB: b80100           mov ax, 1
  04ACEE  46EE: eb02             jmp 0x46f2
  04ACF0  46F0: 2bc0             sub ax, ax
  04ACF2  46F2: 8946d8           mov word ptr [bp - 0x28], ax
  04ACF5  46F5: ff76fa           push word ptr [bp - 6]
  04ACF8  46F8: ff7608           push word ptr [bp + 8]
  04ACFB  46FB: ff76e2           push word ptr [bp - 0x1e]
  04ACFE  46FE: ff76e8           push word ptr [bp - 0x18]
  04AD01  4701: 9a14061f18       lcall 0x181f, 0x614
  04AD06  4706: 83c408           add sp, 8
  04AD09  4709: 8946da           mov word ptr [bp - 0x26], ax
  04AD0C  470C: 0bc0             or ax, ax
  04AD0E  470E: 7d05             jge 0x4715
  04AD10  4710: c746d80000       mov word ptr [bp - 0x28], 0
  04AD15  4715: 837ed800         cmp word ptr [bp - 0x28], 0
  04AD19  4719: 7508             jne 0x4723
  04AD1B  471B: 8b46e0           mov ax, word ptr [bp - 0x20]
  04AD1E  471E: 3946e6           cmp word ptr [bp - 0x1a], ax
  04AD21  4721: 7e06             jle 0x4729
  04AD23  4723: 837ed64b         cmp word ptr [bp - 0x2a], 0x4b
  04AD27  4727: 7c3f             jl 0x4768
  04AD29  4729: 837e0804         cmp word ptr [bp + 8], 4
  04AD2D  472D: 7c03             jl 0x4732
  04AD2F  472F: e91402           jmp 0x4946
  04AD32  4732: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04AD36  4736: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04AD3B  473B: 7403             je 0x4740
  04AD3D  473D: e90602           jmp 0x4946
  04AD40  4740: ff760a           push word ptr [bp + 0xa]
  04AD43  4743: 9aa4091f18       lcall 0x181f, 0x9a4
  04AD48  4748: 83c402           add sp, 2
  04AD4B  474B: 50               push ax
  04AD4C  474C: 6a00             push 0
  04AD4E  474E: 9a38041f18       lcall 0x181f, 0x438
  04AD53  4753: 83c404           add sp, 4
  04AD56  4756: ff36528d         push word ptr [0x8d52]
  04AD5A  475A: 687d16           push 0x167d
  04AD5D  475D: 9a9c011f19       lcall 0x191f, 0x19c
  04AD62  4762: 83c404           add sp, 4
  04AD65  4765: e9de01           jmp 0x4946
  04AD68  4768: 837ed800         cmp word ptr [bp - 0x28], 0
  04AD6C  476C: 7566             jne 0x47d4
  04AD6E  476E: 837ed632         cmp word ptr [bp - 0x2a], 0x32
  04AD72  4772: 7c60             jl 0x47d4
  04AD74  4774: 837e0804         cmp word ptr [bp + 8], 4
  04AD78  4778: 7c03             jl 0x477d
  04AD7A  477A: e9c901           jmp 0x4946
  04AD7D  477D: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04AD81  4781: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04AD86  4786: 7403             je 0x478b
  04AD88  4788: e9bb01           jmp 0x4946
  04AD8B  478B: 8bc3             mov ax, bx
  04AD8D  478D: 8a1ea653         mov bl, byte ptr [0x53a6]
  04AD91  4791: 2aff             sub bh, bh
  04AD93  4793: d1e3             shl bx, 1
  04AD95  4795: ffb79483         push word ptr [bx - 0x7c6c]
  04AD99  4799: 6a00             push 0
  04AD9B  479B: 8bf0             mov si, ax
  04AD9D  479D: 9a38041f18       lcall 0x181f, 0x438
  04ADA2  47A2: 83c404           add sp, 4
  04ADA5  47A5: 81c60e54         add si, 0x540e
  04ADA9  47A9: 1e               push ds
  04ADAA  47AA: 56               push si
  04ADAB  47AB: 6a01             push 1
  04ADAD  47AD: 9a16041f18       lcall 0x181f, 0x416
  04ADB2  47B2: 83c406           add sp, 6
  04ADB5  47B5: ff760a           push word ptr [bp + 0xa]
  04ADB8  47B8: 9a1a0a1f18       lcall 0x181f, 0xa1a
  04ADBD  47BD: 83c402           add sp, 2
  04ADC0  47C0: 50               push ax
  04ADC1  47C1: 6a02             push 2
  04ADC3  47C3: 9a38041f18       lcall 0x181f, 0x438
  04ADC8  47C8: 83c404           add sp, 4
  04ADCB  47CB: ff36528d         push word ptr [0x8d52]
  04ADCF  47CF: 688916           push 0x1689
  04ADD2  47D2: eb89             jmp 0x475d
  04ADD4  47D4: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04ADD8  47D8: f6470310         test byte ptr [bx + 3], 0x10
  04ADDC  47DC: 7506             jne 0x47e4
  04ADDE  47DE: 837ed800         cmp word ptr [bp - 0x28], 0
  04ADE2  47E2: 7554             jne 0x4838
  04ADE4  47E4: 837e0804         cmp word ptr [bp + 8], 4
  04ADE8  47E8: 7d46             jge 0x4830
  04ADEA  47EA: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04ADEE  47EE: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04ADF3  47F3: 753b             jne 0x4830
  04ADF5  47F5: 8a1ea653         mov bl, byte ptr [0x53a6]
  04ADF9  47F9: 2aff             sub bh, bh
  04ADFB  47FB: d1e3             shl bx, 1
  04ADFD  47FD: ffb79483         push word ptr [bx - 0x7c6c]
  04AE01  4801: 6a00             push 0
  04AE03  4803: 9a38041f18       lcall 0x181f, 0x438
  04AE08  4808: 83c404           add sp, 4
  04AE0B  480B: ff760a           push word ptr [bp + 0xa]
  04AE0E  480E: 9a1a0a1f18       lcall 0x181f, 0xa1a
  04AE13  4813: 83c402           add sp, 2
  04AE16  4816: 50               push ax
  04AE17  4817: 6a01             push 1
  04AE19  4819: 9a38041f18       lcall 0x181f, 0x438
  04AE1E  481E: 83c404           add sp, 4
  04AE21  4821: ff36528d         push word ptr [0x8d52]
  04AE25  4825: 689216           push 0x1692
  04AE28  4828: 9a9c011f19       lcall 0x191f, 0x19c
  04AE2D  482D: 83c404           add sp, 4
  04AE30  4830: c746dc0000       mov word ptr [bp - 0x24], 0
  04AE35  4835: e90e01           jmp 0x4946
  04AE38  4838: d166dc           shl word ptr [bp - 0x24], 1
  04AE3B  483B: 804f0310         or byte ptr [bx + 3], 0x10
  04AE3F  483F: 0e               push cs
  04AE40  4840: e8000c           call 0x5443
  04AE43  4843: c746e40000       mov word ptr [bp - 0x1c], 0
  04AE48  4848: 8a46e4           mov al, byte ptr [bp - 0x1c]
  04AE4B  484B: 8b76e4           mov si, word ptr [bp - 0x1c]
  04AE4E  484E: 8842ea           mov byte ptr [bp + si - 0x16], al
  04AE51  4851: ff46e4           inc word ptr [bp - 0x1c]
  04AE54  4854: 837ee410         cmp word ptr [bp - 0x1c], 0x10
  04AE58  4858: 7cee             jl 0x4848
  04AE5A  485A: 8d46ea           lea ax, [bp - 0x16]
  04AE5D  485D: 16               push ss
  04AE5E  485E: 50               push ax
  04AE5F  485F: 1e               push ds
  04AE60  4860: 68789e           push 0x9e78
  04AE63  4863: b81000           mov ax, 0x10
  04AE66  4866: 9ad00e1f19       lcall 0x191f, 0xed0
  04AE6B  486B: ff76da           push word ptr [bp - 0x26]
  04AE6E  486E: 9ae6091f18       lcall 0x181f, 0x9e6
  04AE73  4873: 83c402           add sp, 2
  04AE76  4876: 9a3a0d1f18       lcall 0x181f, 0xd3a
  04AE7B  487B: 8946fe           mov word ptr [bp - 2], ax
  04AE7E  487E: 8a46f9           mov al, byte ptr [bp - 7]
  04AE81  4881: 2ae4             sub ah, ah
  04AE83  4883: 8946de           mov word ptr [bp - 0x22], ax
  04AE86  4886: 8bf0             mov si, ax
  04AE88  4888: d1e6             shl si, 1
  04AE8A  488A: 8b1e4285         mov bx, word ptr [0x8542]
  04AE8E  488E: 8b46fe           mov ax, word ptr [bp - 2]
  04AE91  4891: 2b809a00         sub ax, word ptr [bx + si + 0x9a]
  04AE95  4895: 8b0e969e         mov cx, word ptr [0x9e96]
  04AE99  4899: 8bd1             mov dx, cx
  04AE9B  489B: d1e1             shl cx, 1
  04AE9D  489D: 03ca             add cx, dx
  04AE9F  489F: 83c10a           add cx, 0xa
  04AEA2  48A2: 83f964           cmp cx, 0x64
  04AEA5  48A5: 7e03             jle 0x48aa
  04AEA7  48A7: b96400           mov cx, 0x64
  04AEAA  48AA: 3bc1             cmp ax, cx
  04AEAC  48AC: 7e02             jle 0x48b0
  04AEAE  48AE: 8bc1             mov ax, cx
  04AEB0  48B0: 3d0a00           cmp ax, 0xa
  04AEB3  48B3: 7d03             jge 0x48b8
  04AEB5  48B5: b80a00           mov ax, 0xa
  04AEB8  48B8: 8946fc           mov word ptr [bp - 4], ax
  04AEBB  48BB: 8a1ea653         mov bl, byte ptr [0x53a6]
  04AEBF  48BF: 2aff             sub bh, bh
  04AEC1  48C1: d1e3             shl bx, 1
  04AEC3  48C3: ffb79483         push word ptr [bx - 0x7c6c]
  04AEC7  48C7: 6a00             push 0
  04AEC9  48C9: 9a38041f18       lcall 0x181f, 0x438
  04AECE  48CE: 83c404           add sp, 4
  04AED1  48D1: ff760a           push word ptr [bp + 0xa]
  04AED4  48D4: 9a1a0a1f18       lcall 0x181f, 0xa1a
  04AED9  48D9: 83c402           add sp, 2
  04AEDC  48DC: 50               push ax
  04AEDD  48DD: 6a01             push 1
  04AEDF  48DF: 9a38041f18       lcall 0x181f, 0x438
  04AEE4  48E4: 83c404           add sp, 4
  04AEE7  48E7: 8b46fc           mov ax, word ptr [bp - 4]
  04AEEA  48EA: 99               cdq 
  04AEEB  48EB: 52               push dx
  04AEEC  48EC: 50               push ax
  04AEED  48ED: 6a00             push 0
  04AEEF  48EF: 9aae091f18       lcall 0x181f, 0x9ae
  04AEF4  48F4: 83c406           add sp, 6
  04AEF7  48F7: ffb4c097         push word ptr [si - 0x6840]
  04AEFB  48FB: 6a02             push 2
  04AEFD  48FD: 9a38041f18       lcall 0x181f, 0x438
  04AF02  4902: 83c404           add sp, 4
  04AF05  4905: a14285           mov ax, word ptr [0x8542]
  04AF08  4908: 40               inc ax
  04AF09  4909: 40               inc ax
  04AF0A  490A: 1e               push ds
  04AF0B  490B: 50               push ax
  04AF0C  490C: 6a03             push 3
  04AF0E  490E: 9a16041f18       lcall 0x181f, 0x416
  04AF13  4913: 83c406           add sp, 6
  04AF16  4916: 837e0804         cmp word ptr [bp + 8], 4
  04AF1A  491A: 7d1a             jge 0x4936
  04AF1C  491C: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04AF20  4920: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04AF25  4925: 750f             jne 0x4936
  04AF27  4927: ff36528d         push word ptr [0x8d52]
  04AF2B  492B: 689d16           push 0x169d
  04AF2E  492E: 9a9c011f19       lcall 0x191f, 0x19c
  04AF33  4933: 83c404           add sp, 4
  04AF36  4936: 8b46fc           mov ax, word ptr [bp - 4]
  04AF39  4939: 8b76de           mov si, word ptr [bp - 0x22]
  04AF3C  493C: d1e6             shl si, 1
  04AF3E  493E: 8b1e4285         mov bx, word ptr [0x8542]
  04AF42  4942: 01809a00         add word ptr [bx + si + 0x9a], ax
  04AF46  4946: 6a00             push 0
  04AF48  4948: ff76dc           push word ptr [bp - 0x24]
  04AF4B  494B: ff7608           push word ptr [bp + 8]
  04AF4E  494E: ff36528d         push word ptr [0x8d52]
  04AF52  4952: 9a6c0d1f18       lcall 0x181f, 0xd6c
  04AF57  4957: 83c408           add sp, 8
  04AF5A  495A: 5e               pop si
  04AF5B  495B: c9               leave 
  04AF5C  495C: cb               retf 

; ---- func_04AF5E  size=937  insns=319  prologue=ENTER 0x0014,0  terminal=RETF ----
  04AF5E  495E: c8140000         enter 0x14, 0
  04AF62  4962: 56               push si
  04AF63  4963: ff7608           push word ptr [bp + 8]
  04AF66  4966: ff36528d         push word ptr [0x8d52]
  04AF6A  496A: 9a0c031f18       lcall 0x181f, 0x30c
  04AF6F  496F: 83c404           add sp, 4
  04AF72  4972: 054b00           add ax, 0x4b
  04AF75  4975: 99               cdq 
  04AF76  4976: 52               push dx
  04AF77  4977: 50               push ax
  04AF78  4978: 8b1e528d         mov bx, word ptr [0x8d52]
  04AF7C  497C: 8a872a96         mov al, byte ptr [bx - 0x69d6]
  04AF80  4980: 2ae4             sub ah, ah
  04AF82  4982: 8bc8             mov cx, ax
  04AF84  4984: c1e003           shl ax, 3
  04AF87  4987: 99               cdq 
  04AF88  4988: 8bf0             mov si, ax
  04AF8A  498A: 8a878491         mov al, byte ptr [bx - 0x6e7c]
  04AF8E  498E: c0e802           shr al, 2
  04AF91  4991: 25fe00           and ax, 0xfe
  04AF94  4994: d1e1             shl cx, 1
  04AF96  4996: 2bc1             sub ax, cx
  04AF98  4998: 8bca             mov cx, dx
  04AF9A  499A: 99               cdq 
  04AF9B  499B: 03f0             add si, ax
  04AF9D  499D: 13ca             adc cx, dx
  04AF9F  499F: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04AFA3  49A3: 8a4707           mov al, byte ptr [bx + 7]
  04AFA6  49A6: 98               cwde 
  04AFA7  49A7: d1e0             shl ax, 1
  04AFA9  49A9: 99               cdq 
  04AFAA  49AA: 03f0             add si, ax
  04AFAC  49AC: 13ca             adc cx, dx
  04AFAE  49AE: 8a4708           mov al, byte ptr [bx + 8]
  04AFB1  49B1: 98               cwde 
  04AFB2  49B2: d1e0             shl ax, 1
  04AFB4  49B4: 99               cdq 
  04AFB5  49B5: 03f0             add si, ax
  04AFB7  49B7: 13ca             adc cx, dx
  04AFB9  49B9: 51               push cx
  04AFBA  49BA: 56               push si
  04AFBB  49BB: 9a600f1d0d       lcall 0xd1d, 0xf60
  04AFC0  49C0: 8946f4           mov word ptr [bp - 0xc], ax
  04AFC3  49C3: 8956f6           mov word ptr [bp - 0xa], dx
  04AFC6  49C6: 837e0801         cmp word ptr [bp + 8], 1
  04AFCA  49CA: 7515             jne 0x49e1
  04AFCC  49CC: 6a00             push 0
  04AFCE  49CE: 6a03             push 3
  04AFD0  49D0: d1e0             shl ax, 1
  04AFD2  49D2: d1d2             rcl dx, 1
  04AFD4  49D4: 52               push dx
  04AFD5  49D5: 50               push ax
  04AFD6  49D6: 9ac60e1d0d       lcall 0xd1d, 0xec6
  04AFDB  49DB: 8946f4           mov word ptr [bp - 0xc], ax
  04AFDE  49DE: 8956f6           mov word ptr [bp - 0xa], dx
  04AFE1  49E1: a14c8d           mov ax, word ptr [0x8d4c]
  04AFE4  49E4: 8946fe           mov word ptr [bp - 2], ax
  04AFE7  49E7: c746ec0000       mov word ptr [bp - 0x14], 0
  04AFEC  49EC: eb25             jmp 0x4a13
  04AFEE  49EE: c746f0fa00       mov word ptr [bp - 0x10], 0xfa
  04AFF3  49F3: c746f20000       mov word ptr [bp - 0xe], 0
  04AFF8  49F8: f6470304         test byte ptr [bx + 3], 4
  04AFFC  49FC: 7406             je 0x4a04
  04AFFE  49FE: d166f0           shl word ptr [bp - 0x10], 1
  04B001  4A01: d156f2           rcl word ptr [bp - 0xe]
  04B004  4A04: 8b46f0           mov ax, word ptr [bp - 0x10]
  04B007  4A07: 8b56f2           mov dx, word ptr [bp - 0xe]
  04B00A  4A0A: 2946f4           sub word ptr [bp - 0xc], ax
  04B00D  4A0D: 1956f6           sbb word ptr [bp - 0xa], dx
  04B010  4A10: ff46ec           inc word ptr [bp - 0x14]
  04B013  4A13: a19a53           mov ax, word ptr [0x539a]
  04B016  4A16: 3946ec           cmp word ptr [bp - 0x14], ax
  04B019  4A19: 7d31             jge 0x4a4c
  04B01B  4A1B: ff76ec           push word ptr [bp - 0x14]
  04B01E  4A1E: 9a4c0a1f18       lcall 0x181f, 0xa4c
  04B023  4A23: 83c402           add sp, 2
  04B026  4A26: 8a460a           mov al, byte ptr [bp + 0xa]
  04B029  4A29: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04B02D  4A2D: 384702           cmp byte ptr [bx + 2], al
  04B030  4A30: 75de             jne 0x4a10
  04B032  4A32: 8a4705           mov al, byte ptr [bx + 5]
  04B035  4A35: 8bc8             mov cx, ax
  04B037  4A37: 250f00           and ax, 0xf
  04B03A  4A3A: 3b4608           cmp ax, word ptr [bp + 8]
  04B03D  4A3D: 75d1             jne 0x4a10
  04B03F  4A3F: f6c110           test cl, 0x10
  04B042  4A42: 74aa             je 0x49ee
  04B044  4A44: c746f0e803       mov word ptr [bp - 0x10], 0x3e8
  04B049  4A49: eba8             jmp 0x49f3
  04B04B  4A4B: 90               nop 
  04B04C  4A4C: ff76fe           push word ptr [bp - 2]
  04B04F  4A4F: 9a4c0a1f18       lcall 0x181f, 0xa4c
  04B054  4A54: 83c402           add sp, 2
  04B057  4A57: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04B05B  4A5B: 80bf5b3118       cmp byte ptr [bx + 0x315b], 0x18
  04B060  4A60: 7509             jne 0x4a6b
  04B062  4A62: 816ef4dc05       sub word ptr [bp - 0xc], 0x5dc
  04B067  4A67: 835ef600         sbb word ptr [bp - 0xa], 0
  04B06B  4A6B: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04B06F  4A6F: f6470304         test byte ptr [bx + 3], 4
  04B073  4A73: 7409             je 0x4a7e
  04B075  4A75: 816ef4f401       sub word ptr [bp - 0xc], 0x1f4
  04B07A  4A7A: 835ef600         sbb word ptr [bp - 0xa], 0
  04B07E  4A7E: 8b46f4           mov ax, word ptr [bp - 0xc]
  04B081  4A81: 8b56f6           mov dx, word ptr [bp - 0xa]
  04B084  4A84: 0bd2             or dx, dx
  04B086  4A86: 7f0c             jg 0x4a94
  04B088  4A88: 7c05             jl 0x4a8f
  04B08A  4A8A: 3df401           cmp ax, 0x1f4
  04B08D  4A8D: 7305             jae 0x4a94
  04B08F  4A8F: 2bd2             sub dx, dx
  04B091  4A91: b8f401           mov ax, 0x1f4
  04B094  4A94: 8946f4           mov word ptr [bp - 0xc], ax
  04B097  4A97: 8956f6           mov word ptr [bp - 0xa], dx
  04B09A  4A9A: 837e0804         cmp word ptr [bp + 8], 4
  04B09E  4A9E: 7c03             jl 0x4aa3
  04B0A0  4AA0: e98701           jmp 0x4c2a
  04B0A3  4AA3: 6b5e0834         imul bx, word ptr [bp + 8], 0x34
  04B0A7  4AA7: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04B0AC  4AAC: 7403             je 0x4ab1
  04B0AE  4AAE: e97901           jmp 0x4c2a
  04B0B1  4AB1: f606825301       test byte ptr [0x5382], 1
  04B0B6  4AB6: 740a             je 0x4ac2
  04B0B8  4AB8: a1d253           mov ax, word ptr [0x53d2]
  04B0BB  4ABB: 8946ee           mov word ptr [bp - 0x12], ax
  04B0BE  4ABE: e99c00           jmp 0x4b5d
  04B0C1  4AC1: 90               nop 
  04B0C2  4AC2: a1528d           mov ax, word ptr [0x8d52]
  04B0C5  4AC5: a35c1f           mov word ptr [0x1f5c], ax
  04B0C8  4AC8: ff760a           push word ptr [bp + 0xa]
  04B0CB  4ACB: 9aa4091f18       lcall 0x181f, 0x9a4
  04B0D0  4AD0: 83c402           add sp, 2
  04B0D3  4AD3: 50               push ax
  04B0D4  4AD4: 6a00             push 0
  04B0D6  4AD6: 9a38041f18       lcall 0x181f, 0x438
  04B0DB  4ADB: 83c404           add sp, 4
  04B0DE  4ADE: 8d1e7c08         lea bx, [0x87c]
  04B0E2  4AE2: 8d06a916         lea ax, [0x16a9]
  04B0E6  4AE6: 2bd2             sub dx, dx
  04B0E8  4AE8: 9a82011f19       lcall 0x191f, 0x182
  04B0ED  4AED: 8946f8           mov word ptr [bp - 8], ax
  04B0F0  4AF0: 8956fa           mov word ptr [bp - 6], dx
  04B0F3  4AF3: 0bd0             or dx, ax
  04B0F5  4AF5: 7503             jne 0x4afa
  04B0F7  4AF7: e90a02           jmp 0x4d04
  04B0FA  4AFA: c746ee0000       mov word ptr [bp - 0x12], 0
  04B0FF  4AFF: 8b4608           mov ax, word ptr [bp + 8]
  04B102  4B02: 3946ee           cmp word ptr [bp - 0x12], ax
  04B105  4B05: 7431             je 0x4b38
  04B107  4B07: a1d253           mov ax, word ptr [0x53d2]
  04B10A  4B0A: 3946ee           cmp word ptr [bp - 0x12], ax
  04B10D  4B0D: 7429             je 0x4b38
  04B10F  4B0F: 8b46ee           mov ax, word ptr [bp - 0x12]
  04B112  4B12: 40               inc ax
  04B113  4B13: 50               push ax
  04B114  4B14: ff76ee           push word ptr [bp - 0x12]
  04B117  4B17: 9a1a0a1f18       lcall 0x181f, 0xa1a
  04B11C  4B1C: 83c402           add sp, 2
  04B11F  4B1F: 50               push ax
  04B120  4B20: 9a22001f18       lcall 0x181f, 0x22
  04B125  4B25: 83c402           add sp, 2
  04B128  4B28: 52               push dx
  04B129  4B29: 50               push ax
  04B12A  4B2A: ff76fa           push word ptr [bp - 6]
  04B12D  4B2D: ff76f8           push word ptr [bp - 8]
  04B130  4B30: 9a76011f19       lcall 0x191f, 0x176
  04B135  4B35: 83c40a           add sp, 0xa
  04B138  4B38: ff46ee           inc word ptr [bp - 0x12]
  04B13B  4B3B: 837eee04         cmp word ptr [bp - 0x12], 4
  04B13F  4B3F: 7cbe             jl 0x4aff
  04B141  4B41: ff76fa           push word ptr [bp - 6]
  04B144  4B44: ff76f8           push word ptr [bp - 8]
  04B147  4B47: 9a6a011f19       lcall 0x191f, 0x16a
  04B14C  4B4C: 8946ee           mov word ptr [bp - 0x12], ax
  04B14F  4B4F: 3d0100           cmp ax, 1
  04B152  4B52: 7d03             jge 0x4b57
  04B154  4B54: b80100           mov ax, 1
  04B157  4B57: 8946ee           mov word ptr [bp - 0x12], ax
  04B15A  4B5A: ff4eee           dec word ptr [bp - 0x12]
  04B15D  4B5D: ff76ee           push word ptr [bp - 0x12]
  04B160  4B60: ff760a           push word ptr [bp + 0xa]
  04B163  4B63: 9a380a1f18       lcall 0x181f, 0xa38
  04B168  4B68: 83c404           add sp, 4
  04B16B  4B6B: a820             test al, 0x20
  04B16D  4B6D: 7529             jne 0x4b98
  04B16F  4B6F: ff76ee           push word ptr [bp - 0x12]
  04B172  4B72: 9a1a0a1f18       lcall 0x181f, 0xa1a
  04B177  4B77: 83c402           add sp, 2
  04B17A  4B7A: 50               push ax
  04B17B  4B7B: 6a00             push 0
  04B17D  4B7D: 9a38041f18       lcall 0x181f, 0x438
  04B182  4B82: 83c404           add sp, 4
  04B185  4B85: ff36528d         push word ptr [0x8d52]
  04B189  4B89: 68b716           push 0x16b7
  04B18C  4B8C: 9a9c011f19       lcall 0x191f, 0x19c
  04B191  4B91: 83c404           add sp, 4
  04B194  4B94: 5e               pop si
  04B195  4B95: c9               leave 
  04B196  4B96: cb               retf 
  04B197  4B97: 90               nop 
  04B198  4B98: ff76ee           push word ptr [bp - 0x12]
  04B19B  4B9B: 9a1a0a1f18       lcall 0x181f, 0xa1a
  04B1A0  4BA0: 83c402           add sp, 2
  04B1A3  4BA3: 50               push ax
  04B1A4  4BA4: 6a00             push 0
  04B1A6  4BA6: 9a38041f18       lcall 0x181f, 0x438
  04B1AB  4BAB: 83c404           add sp, 4
  04B1AE  4BAE: ff76f6           push word ptr [bp - 0xa]
  04B1B1  4BB1: ff76f4           push word ptr [bp - 0xc]
  04B1B4  4BB4: 6a00             push 0
  04B1B6  4BB6: 9aae091f18       lcall 0x181f, 0x9ae
  04B1BB  4BBB: 83c406           add sp, 6
  04B1BE  4BBE: ff36528d         push word ptr [0x8d52]
  04B1C2  4BC2: 68c116           push 0x16c1
  04B1C5  4BC5: 9a9c011f19       lcall 0x191f, 0x19c
  04B1CA  4BCA: 83c404           add sp, 4
  04B1CD  4BCD: 48               dec ax
  04B1CE  4BCE: 7403             je 0x4bd3
  04B1D0  4BD0: e93101           jmp 0x4d04
  04B1D3  4BD3: 8b46f4           mov ax, word ptr [bp - 0xc]
  04B1D6  4BD6: 8b56f6           mov dx, word ptr [bp - 0xa]
  04B1D9  4BD9: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  04B1DE  4BDE: 39973488         cmp word ptr [bx - 0x77cc], dx
  04B1E2  4BE2: 7f12             jg 0x4bf6
  04B1E4  4BE4: 7c06             jl 0x4bec
  04B1E6  4BE6: 39873288         cmp word ptr [bx - 0x77ce], ax
  04B1EA  4BEA: 730a             jae 0x4bf6
  04B1EC  4BEC: ff36528d         push word ptr [0x8d52]
  04B1F0  4BF0: 68d016           push 0x16d0
  04B1F3  4BF3: eb97             jmp 0x4b8c
  04B1F5  4BF5: 90               nop 
  04B1F6  4BF6: ff76ee           push word ptr [bp - 0x12]
  04B1F9  4BF9: ff36528d         push word ptr [0x8d52]
  04B1FD  4BFD: 9a0c031f18       lcall 0x181f, 0x30c
  04B202  4C02: 83c404           add sp, 4
  04B205  4C05: 3d4b00           cmp ax, 0x4b
  04B208  4C08: 7c6f             jl 0x4c79
  04B20A  4C0A: ff76ee           push word ptr [bp - 0x12]
  04B20D  4C0D: 9a1a0a1f18       lcall 0x181f, 0xa1a
  04B212  4C12: 83c402           add sp, 2
  04B215  4C15: 50               push ax
  04B216  4C16: 6a00             push 0
  04B218  4C18: 9a38041f18       lcall 0x181f, 0x438
  04B21D  4C1D: 83c404           add sp, 4
  04B220  4C20: ff36528d         push word ptr [0x8d52]
  04B224  4C24: 68dc16           push 0x16dc
  04B227  4C27: e962ff           jmp 0x4b8c
  04B22A  4C2A: a19853           mov ax, word ptr [0x5398]
  04B22D  4C2D: 8946ee           mov word ptr [bp - 0x12], ax
  04B230  4C30: 50               push ax
  04B231  4C31: ff760a           push word ptr [bp + 0xa]
  04B234  4C34: 9a380a1f18       lcall 0x181f, 0xa38
  04B239  4C39: 83c404           add sp, 4
  04B23C  4C3C: a820             test al, 0x20
  04B23E  4C3E: 7503             jne 0x4c43
  04B240  4C40: e9c100           jmp 0x4d04
  04B243  4C43: ff76ee           push word ptr [bp - 0x12]
  04B246  4C46: ff36528d         push word ptr [0x8d52]
  04B24A  4C4A: 9a0c031f18       lcall 0x181f, 0x30c
  04B24F  4C4F: 83c404           add sp, 4
  04B252  4C52: 3d4b00           cmp ax, 0x4b
  04B255  4C55: 7c03             jl 0x4c5a
  04B257  4C57: e9aa00           jmp 0x4d04
  04B25A  4C5A: 8b46f4           mov ax, word ptr [bp - 0xc]
  04B25D  4C5D: 8b56f6           mov dx, word ptr [bp - 0xa]
  04B260  4C60: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  04B265  4C65: 39973488         cmp word ptr [bx - 0x77cc], dx
  04B269  4C69: 7f0e             jg 0x4c79
  04B26B  4C6B: 7d03             jge 0x4c70
  04B26D  4C6D: e99400           jmp 0x4d04
  04B270  4C70: 39873288         cmp word ptr [bx - 0x77ce], ax
  04B274  4C74: 7303             jae 0x4c79
  04B276  4C76: e98b00           jmp 0x4d04
  04B279  4C79: ff760a           push word ptr [bp + 0xa]
  04B27C  4C7C: 9aa4091f18       lcall 0x181f, 0x9a4
  04B281  4C81: 83c402           add sp, 2
  04B284  4C84: 50               push ax
  04B285  4C85: 6a00             push 0
  04B287  4C87: 9a38041f18       lcall 0x181f, 0x438
  04B28C  4C8C: 83c404           add sp, 4
  04B28F  4C8F: ff7608           push word ptr [bp + 8]
  04B292  4C92: 9aa4091f18       lcall 0x181f, 0x9a4
  04B297  4C97: 83c402           add sp, 2
  04B29A  4C9A: 50               push ax
  04B29B  4C9B: 6a01             push 1
  04B29D  4C9D: 9a38041f18       lcall 0x181f, 0x438
  04B2A2  4CA2: 83c404           add sp, 4
  04B2A5  4CA5: ff760a           push word ptr [bp + 0xa]
  04B2A8  4CA8: 9a1a0a1f18       lcall 0x181f, 0xa1a
  04B2AD  4CAD: 83c402           add sp, 2
  04B2B0  4CB0: 50               push ax
  04B2B1  4CB1: 6a02             push 2
  04B2B3  4CB3: 9a38041f18       lcall 0x181f, 0x438
  04B2B8  4CB8: 83c404           add sp, 4
  04B2BB  4CBB: ff76ee           push word ptr [bp - 0x12]
  04B2BE  4CBE: 9aa4091f18       lcall 0x181f, 0x9a4
  04B2C3  4CC3: 83c402           add sp, 2
  04B2C6  4CC6: 50               push ax
  04B2C7  4CC7: 6a03             push 3
  04B2C9  4CC9: 9a38041f18       lcall 0x181f, 0x438
  04B2CE  4CCE: 83c404           add sp, 4
  04B2D1  4CD1: 6a01             push 1
  04B2D3  4CD3: 68e916           push 0x16e9
  04B2D6  4CD6: 9a52061f18       lcall 0x181f, 0x652
  04B2DB  4CDB: 83c404           add sp, 4
  04B2DE  4CDE: 6a00             push 0
  04B2E0  4CE0: 6a64             push 0x64
  04B2E2  4CE2: ff76ee           push word ptr [bp - 0x12]
  04B2E5  4CE5: ff36528d         push word ptr [0x8d52]
  04B2E9  4CE9: 9a6c0d1f18       lcall 0x181f, 0xd6c
  04B2EE  4CEE: 83c408           add sp, 8
  04B2F1  4CF1: 8b46f4           mov ax, word ptr [bp - 0xc]
  04B2F4  4CF4: 8b56f6           mov dx, word ptr [bp - 0xa]
  04B2F7  4CF7: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  04B2FC  4CFC: 29873288         sub word ptr [bx - 0x77ce], ax
  04B300  4D00: 19973488         sbb word ptr [bx - 0x77cc], dx
  04B304  4D04: 5e               pop si
  04B305  4D05: c9               leave 
  04B306  4D06: cb               retf 

; ---- func_04B308  size=1861  insns=635  prologue=ENTER 0x00BA,0  terminal=page-end ----
  04B308  4D08: c8ba0000         enter 0xba, 0
  04B30C  4D0C: 56               push si
  04B30D  4D0D: c746a80100       mov word ptr [bp - 0x58], 1
  04B312  4D12: c746a20000       mov word ptr [bp - 0x5e], 0
  04B317  4D17: 2bc0             sub ax, ax
  04B319  4D19: 8946a6           mov word ptr [bp - 0x5a], ax
  04B31C  4D1C: 8946a4           mov word ptr [bp - 0x5c], ax
  04B31F  4D1F: a19c53           mov ax, word ptr [0x539c]
  04B322  4D22: 8946aa           mov word ptr [bp - 0x56], ax
  04B325  4D25: ff760a           push word ptr [bp + 0xa]
  04B328  4D28: ff7608           push word ptr [bp + 8]
  04B32B  4D2B: 9af0091f18       lcall 0x181f, 0x9f0
  04B330  4D30: 83c404           add sp, 4
  04B333  4D33: 89469e           mov word ptr [bp - 0x62], ax
  04B336  4D36: 50               push ax
  04B337  4D37: 9a4c0a1f18       lcall 0x181f, 0xa4c
  04B33C  4D3C: 83c402           add sp, 2
  04B33F  4D3F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04B343  4D43: 8a874731         mov al, byte ptr [bx + 0x3147]
  04B347  4D47: 250f00           and ax, 0xf
  04B34A  4D4A: 894698           mov word ptr [bp - 0x68], ax
  04B34D  4D4D: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04B351  4D51: 8a4f02           mov cl, byte ptr [bx + 2]
  04B354  4D54: 2aed             sub ch, ch
  04B356  4D56: 894efe           mov word ptr [bp - 2], cx
  04B359  4D59: 83e904           sub cx, 4
  04B35C  4D5C: 894ea0           mov word ptr [bp - 0x60], cx
  04B35F  4D5F: 50               push ax
  04B360  4D60: 51               push cx
  04B361  4D61: 9a0c031f18       lcall 0x181f, 0x30c
  04B366  4D66: 83c404           add sp, 4
  04B369  4D69: 898646ff         mov word ptr [bp - 0xba], ax
  04B36D  4D6D: 8b7698           mov si, word ptr [bp - 0x68]
  04B370  4D70: d1e6             shl si, 1
  04B372  4D72: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04B376  4D76: 8b400a           mov ax, word ptr [bx + si + 0xa]
  04B379  4D79: 89469c           mov word ptr [bp - 0x64], ax
  04B37C  4D7C: 837e9804         cmp word ptr [bp - 0x68], 4
  04B380  4D80: 7d34             jge 0x4db6
  04B382  4D82: 6b5e9834         imul bx, word ptr [bp - 0x68], 0x34
  04B386  4D86: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04B38B  4D8B: 7529             jne 0x4db6
  04B38D  4D8D: 833ea20000       cmp word ptr [0xa2], 0
  04B392  4D92: 7522             jne 0x4db6
  04B394  4D94: 833e528d00       cmp word ptr [0x8d52], 0
  04B399  4D99: 7505             jne 0x4da0
  04B39B  4D9B: 6a07             push 7
  04B39D  4D9D: eb0f             jmp 0x4dae
  04B39F  4D9F: 90               nop 
  04B3A0  4DA0: 833e528d01       cmp word ptr [0x8d52], 1
  04B3A5  4DA5: 7505             jne 0x4dac
  04B3A7  4DA7: 6a06             push 6
  04B3A9  4DA9: eb03             jmp 0x4dae
  04B3AB  4DAB: 90               nop 
  04B3AC  4DAC: 6a05             push 5
  04B3AE  4DAE: 9aac041f18       lcall 0x181f, 0x4ac
  04B3B3  4DB3: 83c402           add sp, 2
  04B3B6  4DB6: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04B3BA  4DBA: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04B3BF  4DBF: 725b             jb 0x4e1c
  04B3C1  4DC1: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04B3C6  4DC6: 7754             ja 0x4e1c
  04B3C8  4DC8: ff76fe           push word ptr [bp - 2]
  04B3CB  4DCB: ff7698           push word ptr [bp - 0x68]
  04B3CE  4DCE: 9a380a1f18       lcall 0x181f, 0xa38
  04B3D3  4DD3: 83c404           add sp, 4
  04B3D6  4DD6: a820             test al, 0x20
  04B3D8  4DD8: 750c             jne 0x4de6
  04B3DA  4DDA: 8d1ef716         lea bx, [0x16f7]
  04B3DE  4DDE: 9afe031f18       lcall 0x181f, 0x3fe
  04B3E3  4DE3: e9ec05           jmp 0x53d2
  04B3E6  4DE6: 83be46ff4b       cmp word ptr [bp - 0xba], 0x4b
  04B3EB  4DEB: 7d06             jge 0x4df3
  04B3ED  4DED: 837e9c40         cmp word ptr [bp - 0x64], 0x40
  04B3F1  4DF1: 7c29             jl 0x4e1c
  04B3F3  4DF3: ff76fe           push word ptr [bp - 2]
  04B3F6  4DF6: 9aa4091f18       lcall 0x181f, 0x9a4
  04B3FB  4DFB: 83c402           add sp, 2
  04B3FE  4DFE: 50               push ax
  04B3FF  4DFF: 6a00             push 0
  04B401  4E01: 9a38041f18       lcall 0x181f, 0x438
  04B406  4E06: 83c404           add sp, 4
  04B409  4E09: ff36528d         push word ptr [0x8d52]
  04B40D  4E0D: 680517           push 0x1705
  04B410  4E10: 9a9c011f19       lcall 0x191f, 0x19c
  04B415  4E15: 83c404           add sp, 4
  04B418  4E18: e9b705           jmp 0x53d2
  04B41B  4E1B: 90               nop 
  04B41C  4E1C: 837e9804         cmp word ptr [bp - 0x68], 4
  04B420  4E20: 7d0e             jge 0x4e30
  04B422  4E22: 6b5e9834         imul bx, word ptr [bp - 0x68], 0x34
  04B426  4E26: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  04B42B  4E2B: 7503             jne 0x4e30
  04B42D  4E2D: e93a01           jmp 0x4f6a
  04B430  4E30: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04B434  4E34: 8a874631         mov al, byte ptr [bx + 0x3146]
  04B438  4E38: 2ae4             sub ah, ah
  04B43A  4E3A: e90701           jmp 0x4f44
  04B43D  4E3D: 90               nop 
  04B43E  4E3E: ff369853         push word ptr [0x5398]
  04B442  4E42: ff36528d         push word ptr [0x8d52]
  04B446  4E46: 9a0c031f18       lcall 0x181f, 0x30c
  04B44B  4E4B: 83c404           add sp, 4
  04B44E  4E4E: 3d4b00           cmp ax, 0x4b
  04B451  4E51: 7d5b             jge 0x4eae
  04B453  4E53: ff76fe           push word ptr [bp - 2]
  04B456  4E56: ff369853         push word ptr [0x5398]
  04B45A  4E5A: 9a380a1f18       lcall 0x181f, 0xa38
  04B45F  4E5F: 83c404           add sp, 4
  04B462  4E62: a820             test al, 0x20
  04B464  4E64: 7448             je 0x4eae
  04B466  4E66: 8b1e9853         mov bx, word ptr [0x5398]
  04B46A  4E6A: 8a877c91         mov al, byte ptr [bx - 0x6e84]
  04B46E  4E6E: 8b5e98           mov bx, word ptr [bp - 0x68]
  04B471  4E71: 38877c91         cmp byte ptr [bx - 0x6e84], al
  04B475  4E75: 7337             jae 0x4eae
  04B477  4E77: 69db3c01         imul bx, bx, 0x13c
  04B47B  4E7B: 83bf348800       cmp word ptr [bx - 0x77cc], 0
  04B480  4E80: 7c2c             jl 0x4eae
  04B482  4E82: 7f08             jg 0x4e8c
  04B484  4E84: 81bf3288dc05     cmp word ptr [bx - 0x77ce], 0x5dc
  04B48A  4E8A: 7222             jb 0x4eae
  04B48C  4E8C: 6a04             push 4
  04B48E  4E8E: 6a00             push 0
  04B490  4E90: 9ad4041f18       lcall 0x181f, 0x4d4
  04B495  4E95: 83c404           add sp, 4
  04B498  4E98: 0bc0             or ax, ax
  04B49A  4E9A: 750a             jne 0x4ea6
  04B49C  4E9C: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04B4A0  4EA0: 807f0500         cmp byte ptr [bx + 5], 0
  04B4A4  4EA4: 7c08             jl 0x4eae
  04B4A6  4EA6: c746ac0700       mov word ptr [bp - 0x54], 7
  04B4AB  4EAB: e94104           jmp 0x52ef
  04B4AE  4EAE: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04B4B2  4EB2: 807f0500         cmp byte ptr [bx + 5], 0
  04B4B6  4EB6: 7d08             jge 0x4ec0
  04B4B8  4EB8: c746ac0300       mov word ptr [bp - 0x54], 3
  04B4BD  4EBD: e92f04           jmp 0x52ef
  04B4C0  4EC0: 8a4705           mov al, byte ptr [bx + 5]
  04B4C3  4EC3: 250f00           and ax, 0xf
  04B4C6  4EC6: 3b4698           cmp ax, word ptr [bp - 0x68]
  04B4C9  4EC9: 7503             jne 0x4ece
  04B4CB  4ECB: e90405           jmp 0x53d2
  04B4CE  4ECE: c746ac0400       mov word ptr [bp - 0x54], 4
  04B4D3  4ED3: e91904           jmp 0x52ef
  04B4D6  4ED6: c746ac0100       mov word ptr [bp - 0x54], 1
  04B4DB  4EDB: e91104           jmp 0x52ef
  04B4DE  4EDE: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04B4E2  4EE2: 8a874531         mov al, byte ptr [bx + 0x3145]
  04B4E6  4EE6: 2ae4             sub ah, ah
  04B4E8  4EE8: 50               push ax
  04B4E9  4EE9: 8a874431         mov al, byte ptr [bx + 0x3144]
  04B4ED  4EED: 50               push ax
  04B4EE  4EEE: 9a22071f18       lcall 0x181f, 0x722
  04B4F3  4EF3: 83c404           add sp, 4
  04B4F6  4EF6: 89469a           mov word ptr [bp - 0x66], ax
  04B4F9  4EF9: c746ac0900       mov word ptr [bp - 0x54], 9
  04B4FE  4EFE: e9ee03           jmp 0x52ef
  04B501  4F01: 90               nop 
  04B502  4F02: c746ac0600       mov word ptr [bp - 0x54], 6
  04B507  4F07: e9e503           jmp 0x52ef
  04B50A  4F0A: ff7606           push word ptr [bp + 6]
  04B50D  4F0D: 9a780b1f18       lcall 0x181f, 0xb78
  04B512  4F12: 83c402           add sp, 2
  04B515  4F15: 0bc0             or ax, ax
  04B517  4F17: 7d03             jge 0x4f1c
  04B519  4F19: e9b604           jmp 0x53d2
  04B51C  4F1C: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04B520  4F20: 80bf5b311c       cmp byte ptr [bx + 0x315b], 0x1c
  04B525  4F25: 740a             je 0x4f31
  04B527  4F27: 80bf5b3119       cmp byte ptr [bx + 0x315b], 0x19
  04B52C  4F2C: 7403             je 0x4f31
  04B52E  4F2E: e9a104           jmp 0x53d2
  04B531  4F31: 83be46ff4b       cmp word ptr [bp - 0xba], 0x4b
  04B536  4F36: 7c03             jl 0x4f3b
  04B538  4F38: e99704           jmp 0x53d2
  04B53B  4F3B: c746ac0500       mov word ptr [bp - 0x54], 5
  04B540  4F40: e9ac03           jmp 0x52ef
  04B543  4F43: 90               nop 
  04B544  4F44: 48               dec ax
  04B545  4F45: 3d0b00           cmp ax, 0xb
  04B548  4F48: 77c0             ja 0x4f0a
  04B54A  4F4A: d1e0             shl ax, 1
  04B54C  4F4C: 93               xchg bx, ax
  04B54D  4F4D: 2effa77247       jmp word ptr cs:[bx + 0x4772]
  04B552  4F52: fe462a           inc byte ptr [bp + 0x2a]
  04B555  4F55: 47               inc di
  04B556  4F56: 5e               pop si
  04B557  4F57: 46               inc si
  04B558  4F58: fe4622           inc byte ptr [bp + 0x22]
  04B55B  4F5B: 47               inc di
  04B55C  4F5C: 2a472a           sub al, byte ptr [bx + 0x2a]
  04B55F  4F5F: 47               inc di
  04B560  4F60: 2a472a           sub al, byte ptr [bx + 0x2a]
  04B563  4F63: 47               inc di
  04B564  4F64: 2a47fe           sub al, byte ptr [bx - 2]
  04B567  4F67: 46               inc si
  04B568  4F68: f6466a07         test byte ptr [bp + 0x6a], 7
  04B56C  4F6C: 9a24051f18       lcall 0x181f, 0x524
  04B571  4F71: 83c402           add sp, 2
  04B574  4F74: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  04B578  4F78: 8a5f02           mov bl, byte ptr [bx + 2]
  04B57B  4F7B: 2aff             sub bh, bh
  04B57D  4F7D: 8bc3             mov ax, bx
  04B57F  4F7F: d1e3             shl bx, 1
  04B581  4F81: 03d8             add bx, ax
  04B583  4F83: d1e3             shl bx, 1
  04B585  4F85: ffb73496         push word ptr [bx - 0x69cc]
  04B589  4F89: 6a00             push 0
  04B58B  4F8B: 9a38041f18       lcall 0x181f, 0x438
  04B590  4F90: 83c404           add sp, 4
  04B593  4F93: ff76fe           push word ptr [bp - 2]
  04B596  4F96: 9a1a0a1f18       lcall 0x181f, 0xa1a
  04B59B  4F9B: 83c402           add sp, 2
  04B59E  4F9E: 50               push ax
  04B59F  4F9F: 6a01             push 1
  04B5A1  4FA1: 9a38041f18       lcall 0x181f, 0x438
  04B5A6  4FA6: 83c404           add sp, 4
  04B5A9  4FA9: 681017           push 0x1710
  04B5AC  4FAC: 8d46ae           lea ax, [bp - 0x52]
  04B5AF  4FAF: 50               push ax
  04B5B0  4FB0: 9ae4071d0d       lcall 0xd1d, 0x7e4
  04B5B5  4FB5: 83c404           add sp, 4
  04B5B8  4FB8: 83be46ff4b       cmp word ptr [bp - 0xba], 0x4b
  04B5BD  4FBD: 7c05             jl 0x4fc4
  04B5BF  4FBF: 681817           push 0x1718
  04B5C2  4FC2: eb37             jmp 0x4ffb
  04B5C4  4FC4: 83be46ff32       cmp word ptr [bp - 0xba], 0x32
  04B5C9  4FC9: 7c05             jl 0x4fd0
  04B5CB  4FCB: 681c17           push 0x171c
  04B5CE  4FCE: eb2b             jmp 0x4ffb
  04B5D0  4FD0: 83be46ff19       cmp word ptr [bp - 0xba], 0x19
  04B5D5  4FD5: 7d10             jge 0x4fe7
  04B5D7  4FD7: 8b7698           mov si, word ptr [bp - 0x68]
  04B5DA  4FDA: d1e6             shl si, 1
  04B5DC  4FDC: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04B5E0  4FE0: 81780a8000       cmp word ptr [bx + si + 0xa], 0x80
  04B5E5  4FE5: 7c05             jl 0x4fec
  04B5E7  4FE7: 682017           push 0x1720
  04B5EA  4FEA: eb0f             jmp 0x4ffb
  04B5EC  4FEC: 833e528d02       cmp word ptr [0x8d52], 2
  04B5F1  4FF1: 7505             jne 0x4ff8
  04B5F3  4FF3: 682717           push 0x1727
  04B5F6  4FF6: eb03             jmp 0x4ffb
  04B5F8  4FF8: 682e17           push 0x172e
  04B5FB  4FFB: 8d46ae           lea ax, [bp - 0x52]
  04B5FE  4FFE: 50               push ax
  04B5FF  4FFF: 9aa4071d0d       lcall 0xd1d, 0x7a4
  04B604  5004: 83c404           add sp, 4
  04B607  5007: 83be46ff32       cmp word ptr [bp - 0xba], 0x32
  04B60C  500C: 7c22             jl 0x5030
  04B60E  500E: 833e528d00       cmp word ptr [0x8d52], 0
  04B613  5013: 7505             jne 0x501a
  04B615  5015: 6a07             push 7
  04B617  5017: eb0f             jmp 0x5028
  04B619  5019: 90               nop 
  04B61A  501A: 833e528d01       cmp word ptr [0x8d52], 1
  04B61F  501F: 7505             jne 0x5026
  04B621  5021: 6a06             push 6
  04B623  5023: eb03             jmp 0x5028
  04B625  5025: 90               nop 
  04B626  5026: 6a05             push 5
  04B628  5028: 9aac041f18       lcall 0x181f, 0x4ac
  04B62D  502D: 83c402           add sp, 2
  04B630  5030: 8d1e7c08         lea bx, [0x87c]
  04B634  5034: 8d46ae           lea ax, [bp - 0x52]
  04B637  5037: 2bd2             sub dx, dx
  04B639  5039: 9a82011f19       lcall 0x191f, 0x182
  04B63E  503E: 8946a4           mov word ptr [bp - 0x5c], ax
  04B641  5041: 8956a6           mov word ptr [bp - 0x5a], dx
  04B644  5044: 0bd0             or dx, ax
  04B646  5046: 7503             jne 0x504b
  04B648  5048: e98703           jmp 0x53d2
  04B64B  504B: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04B64F  504F: 80bf46310c       cmp byte ptr [bx + 0x3146], 0xc
  04B654  5054: 740e             je 0x5064
  04B656  5056: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04B65B  505B: 7235             jb 0x5092
  04B65D  505D: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04B662  5062: 772e             ja 0x5092
  04B664  5064: 83be46ff4b       cmp word ptr [bp - 0xba], 0x4b
  04B669  5069: 7d09             jge 0x5074
  04B66B  506B: 6a01             push 1
  04B66D  506D: ff362a93         push word ptr [0x932a]
  04B671  5071: eb07             jmp 0x507a
  04B673  5073: 90               nop 
  04B674  5074: 6a02             push 2
  04B676  5076: ff362c93         push word ptr [0x932c]
  04B67A  507A: 9a22001f18       lcall 0x181f, 0x22
  04B67F  507F: 83c402           add sp, 2
  04B682  5082: 52               push dx
  04B683  5083: 50               push ax
  04B684  5084: ff76a6           push word ptr [bp - 0x5a]
  04B687  5087: ff76a4           push word ptr [bp - 0x5c]
  04B68A  508A: 9a76011f19       lcall 0x191f, 0x176
  04B68F  508F: 83c40a           add sp, 0xa
  04B692  5092: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04B696  5096: 80bf463105       cmp byte ptr [bx + 0x3146], 5
  04B69B  509B: 751e             jne 0x50bb
  04B69D  509D: 6a06             push 6
  04B69F  509F: ff363493         push word ptr [0x9334]
  04B6A3  50A3: 9a22001f18       lcall 0x181f, 0x22
  04B6A8  50A8: 83c402           add sp, 2
  04B6AB  50AB: 52               push dx
  04B6AC  50AC: 50               push ax
  04B6AD  50AD: ff76a6           push word ptr [bp - 0x5a]
  04B6B0  50B0: ff76a4           push word ptr [bp - 0x5c]
  04B6B3  50B3: 9a76011f19       lcall 0x191f, 0x176
  04B6B8  50B8: 83c40a           add sp, 0xa
  04B6BB  50BB: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04B6BF  50BF: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  04B6C4  50C4: 7207             jb 0x50cd
  04B6C6  50C6: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  04B6CB  50CB: 7640             jbe 0x510d
  04B6CD  50CD: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04B6D1  50D1: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04B6D5  50D5: 2aff             sub bh, bh
  04B6D7  50D7: 8bc3             mov ax, bx
  04B6D9  50D9: d1e3             shl bx, 1
  04B6DB  50DB: 03d8             add bx, ax
  04B6DD  50DD: d1e3             shl bx, 1
  04B6DF  50DF: 03d8             add bx, ax
  04B6E1  50E1: d1e3             shl bx, 1
  04B6E3  50E3: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  04B6E8  50E8: 7623             jbe 0x510d
  04B6EA  50EA: 6a09             push 9
  04B6EC  50EC: ff363a93         push word ptr [0x933a]
  04B6F0  50F0: 9a22001f18       lcall 0x181f, 0x22
  04B6F5  50F5: 83c402           add sp, 2
  04B6F8  50F8: 52               push dx
  04B6F9  50F9: 50               push ax
  04B6FA  50FA: ff76a6           push word ptr [bp - 0x5a]
  04B6FD  50FD: ff76a4           push word ptr [bp - 0x5c]
  04B700  5100: 9a76011f19       lcall 0x191f, 0x176
  04B705  5105: 83c40a           add sp, 0xa
  04B708  5108: c746a20100       mov word ptr [bp - 0x5e], 1
  04B70D  510D: ff76fe           push word ptr [bp - 2]
  04B710  5110: ff7698           push word ptr [bp - 0x68]
  04B713  5113: 9a380a1f18       lcall 0x181f, 0xa38
  04B718  5118: 83c404           add sp, 4
  04B71B  511B: a840             test al, 0x40
  04B71D  511D: 7503             jne 0x5122
  04B71F  511F: e94301           jmp 0x5265
  04B722  5122: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04B726  5126: 80bf463103       cmp byte ptr [bx + 0x3146], 3
  04B72B  512B: 7403             je 0x5130
  04B72D  512D: e99000           jmp 0x51c0
  04B730  5130: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04B734  5134: 807f0500         cmp byte ptr [bx + 5], 0
  04B738  5138: 7d12             jge 0x514c
  04B73A  513A: 6a03             push 3
  04B73C  513C: ff362e93         push word ptr [0x932e]
  04B740  5140: 9a22001f18       lcall 0x181f, 0x22
  04B745  5145: 83c402           add sp, 2
  04B748  5148: 52               push dx
  04B749  5149: eb5d             jmp 0x51a8
  04B74B  514B: 90               nop 
  04B74C  514C: 8a4705           mov al, byte ptr [bx + 5]
  04B74F  514F: 250f00           and ax, 0xf
  04B752  5152: 3b4698           cmp ax, word ptr [bp - 0x68]
  04B755  5155: 7460             je 0x51b7
  04B757  5157: ff363093         push word ptr [0x9330]
  04B75B  515B: 9a22001f18       lcall 0x181f, 0x22
  04B760  5160: 83c402           add sp, 2
  04B763  5163: 52               push dx
  04B764  5164: 50               push ax
  04B765  5165: 8d46ae           lea ax, [bp - 0x52]
  04B768  5168: 16               push ss
  04B769  5169: 50               push ax
  04B76A  516A: 9a7e111d0d       lcall 0xd1d, 0x117e
  04B76F  516F: 83c408           add sp, 8
  04B772  5172: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  04B776  5176: 8a4705           mov al, byte ptr [bx + 5]
  04B779  5179: 250f00           and ax, 0xf
  04B77C  517C: 50               push ax
  04B77D  517D: 9a1a0a1f18       lcall 0x181f, 0xa1a
  04B782  5182: 83c402           add sp, 2
  04B785  5185: 50               push ax
  04B786  5186: 9a22001f18       lcall 0x181f, 0x22
  04B78B  518B: 83c402           add sp, 2
  04B78E  518E: 52               push dx
  04B78F  518F: 50               push ax
  04B790  5190: 8d46ae           lea ax, [bp - 0x52]
  04B793  5193: 50               push ax
  04B794  5194: 8d8648ff         lea ax, [bp - 0xb8]
  04B798  5198: 50               push ax
  04B799  5199: 9a480b1d0d       lcall 0xd1d, 0xb48
  04B79E  519E: 83c408           add sp, 8
  04B7A1  51A1: 6a04             push 4
  04B7A3  51A3: 8d8648ff         lea ax, [bp - 0xb8]
  04B7A7  51A7: 16               push ss
  04B7A8  51A8: 50               push ax
  04B7A9  51A9: ff76a6           push word ptr [bp - 0x5a]
  04B7AC  51AC: ff76a4           push word ptr [bp - 0x5c]
  04B7AF  51AF: 9a76011f19       lcall 0x191f, 0x176
  04B7B4  51B4: 83c40a           add sp, 0xa
  04B7B7  51B7: 6a07             push 7
  04B7B9  51B9: ff363693         push word ptr [0x9336]
  04B7BD  51BD: e98d00           jmp 0x524d
  04B7C0  51C0: ff7606           push word ptr [bp + 6]
  04B7C3  51C3: 9a780b1f18       lcall 0x181f, 0xb78
  04B7C8  51C8: 83c402           add sp, 2
  04B7CB  51CB: 0bc0             or ax, ax
  04B7CD  51CD: 7c51             jl 0x5220
  04B7CF  51CF: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04B7D3  51D3: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04B7D7  51D7: 8bc3             mov ax, bx
  04B7D9  51D9: 2aff             sub bh, bh
  04B7DB  51DB: 8bcb             mov cx, bx
  04B7DD  51DD: d1e3             shl bx, 1
  04B7DF  51DF: 03d9             add bx, cx
  04B7E1  51E1: d1e3             shl bx, 1
  04B7E3  51E3: 03d9             add bx, cx
  04B7E5  51E5: d1e3             shl bx, 1
  04B7E7  51E7: 80bf365202       cmp byte ptr [bx + 0x5236], 2
  04B7EC  51EC: 7332             jae 0x5220
  04B7EE  51EE: 3c05             cmp al, 5
  04B7F0  51F0: 742e             je 0x5220
  04B7F2  51F2: ff7606           push word ptr [bp + 6]
  04B7F5  51F5: 9a780b1f18       lcall 0x181f, 0xb78
  04B7FA  51FA: 83c402           add sp, 2
  04B7FD  51FD: 3d1b00           cmp ax, 0x1b
  04B800  5200: 741e             je 0x5220
  04B802  5202: 6a05             push 5
  04B804  5204: ff363293         push word ptr [0x9332]
  04B808  5208: 9a22001f18       lcall 0x181f, 0x22
  04B80D  520D: 83c402           add sp, 2
  04B810  5210: 52               push dx
  04B811  5211: 50               push ax
  04B812  5212: ff76a6           push word ptr [bp - 0x5a]
  04B815  5215: ff76a4           push word ptr [bp - 0x5c]
  04B818  5218: 9a76011f19       lcall 0x191f, 0x176
  04B81D  521D: 83c40a           add sp, 0xa
  04B820  5220: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04B824  5224: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04B828  5228: 8bc3             mov ax, bx
  04B82A  522A: 2aff             sub bh, bh
  04B82C  522C: 8bcb             mov cx, bx
  04B82E  522E: d1e3             shl bx, 1
  04B830  5230: 03d9             add bx, cx
  04B832  5232: d1e3             shl bx, 1
  04B834  5234: 03d9             add bx, cx
  04B836  5236: d1e3             shl bx, 1
  04B838  5238: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  04B83D  523D: 7426             je 0x5265
  04B83F  523F: 3c0d             cmp al, 0xd
  04B841  5241: 7204             jb 0x5247
  04B843  5243: 3c12             cmp al, 0x12
  04B845  5245: 761e             jbe 0x5265
  04B847  5247: 6a08             push 8
  04B849  5249: ff363893         push word ptr [0x9338]
  04B84D  524D: 9a22001f18       lcall 0x181f, 0x22
  04B852  5252: 83c402           add sp, 2
  04B855  5255: 52               push dx
  04B856  5256: 50               push ax
  04B857  5257: ff76a6           push word ptr [bp - 0x5a]
  04B85A  525A: ff76a4           push word ptr [bp - 0x5c]
  04B85D  525D: 9a76011f19       lcall 0x191f, 0x176
  04B862  5262: 83c40a           add sp, 0xa
  04B865  5265: 837ea200         cmp word ptr [bp - 0x5e], 0
  04B869  5269: 7545             jne 0x52b0
  04B86B  526B: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  04B86F  526F: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  04B873  5273: 8bc3             mov ax, bx
  04B875  5275: 2aff             sub bh, bh
  04B877  5277: 8bcb             mov cx, bx
  04B879  5279: d1e3             shl bx, 1
  04B87B  527B: 03d9             add bx, cx
  04B87D  527D: d1e3             shl bx, 1
  04B87F  527F: 03d9             add bx, cx
  04B881  5281: d1e3             shl bx, 1
  04B883  5283: 80bf365200       cmp byte ptr [bx + 0x5236], 0
  04B888  5288: 7426             je 0x52b0
  04B88A  528A: 3c0d             cmp al, 0xd
  04B88C  528C: 7204             jb 0x5292
  04B88E  528E: 3c12             cmp al, 0x12
  04B890  5290: 761e             jbe 0x52b0
  04B892  5292: 6a09             push 9
  04B894  5294: ff363a93         push word ptr [0x933a]
  04B898  5298: 9a22001f18       lcall 0x181f, 0x22
  04B89D  529D: 83c402           add sp, 2
  04B8A0  52A0: 52               push dx
  04B8A1  52A1: 50               push ax
  04B8A2  52A2: ff76a6           push word ptr [bp - 0x5a]
  04B8A5  52A5: ff76a4           push word ptr [bp - 0x5c]
  04B8A8  52A8: 9a76011f19       lcall 0x191f, 0x176
  04B8AD  52AD: 83c40a           add sp, 0xa
  04B8B0  52B0: 6a0a             push 0xa
  04B8B2  52B2: ff363c93         push word ptr [0x933c]
  04B8B6  52B6: 9a22001f18       lcall 0x181f, 0x22
  04B8BB  52BB: 83c402           add sp, 2
  04B8BE  52BE: 52               push dx
  04B8BF  52BF: 50               push ax
  04B8C0  52C0: ff76a6           push word ptr [bp - 0x5a]
  04B8C3  52C3: ff76a4           push word ptr [bp - 0x5c]
  04B8C6  52C6: 9a76011f19       lcall 0x191f, 0x176
  04B8CB  52CB: 83c40a           add sp, 0xa
  04B8CE  52CE: ff76a6           push word ptr [bp - 0x5a]
  04B8D1  52D1: ff76a4           push word ptr [bp - 0x5c]
  04B8D4  52D4: 9a6a011f19       lcall 0x191f, 0x16a
  04B8D9  52D9: 8946ac           mov word ptr [bp - 0x54], ax
  04B8DC  52DC: ff76a6           push word ptr [bp - 0x5a]
  04B8DF  52DF: ff76a4           push word ptr [bp - 0x5c]
  04B8E2  52E2: 9aa8011f19       lcall 0x191f, 0x1a8
  04B8E7  52E7: 2bc0             sub ax, ax
  04B8E9  52E9: 8946a6           mov word ptr [bp - 0x5a], ax
  04B8EC  52EC: 8946a4           mov word ptr [bp - 0x5c], ax
  04B8EF  52EF: 8b46ac           mov ax, word ptr [bp - 0x54]
  04B8F2  52F2: e9bd00           jmp 0x53b2
  04B8F5  52F5: 90               nop 
  04B8F6  52F6: ff76fe           push word ptr [bp - 2]
  04B8F9  52F9: ff7698           push word ptr [bp - 0x68]
  04B8FC  52FC: ff769e           push word ptr [bp - 0x62]
  04B8FF  52FF: ff7606           push word ptr [bp + 6]
  04B902  5302: 0e               push cs
  04B903  5303: e84201           call 0x5448
  04B906  5306: 83c408           add sp, 8
  04B909  5309: e9c600           jmp 0x53d2
  04B90C  530C: ff76fe           push word ptr [bp - 2]
  04B90F  530F: ff7698           push word ptr [bp - 0x68]
  04B912  5312: ff769e           push word ptr [bp - 0x62]
  04B915  5315: ff7606           push word ptr [bp + 6]
  04B918  5318: 0e               push cs
  04B919  5319: e80e01           call 0x542a
  04B91C  531C: 83c408           add sp, 8
  04B91F  531F: 0bc0             or ax, ax
  04B921  5321: 7503             jne 0x5326
  04B923  5323: e9ac00           jmp 0x53d2
  04B926  5326: c746a80200       mov word ptr [bp - 0x58], 2
  04B92B  532B: e9a400           jmp 0x53d2
  04B92E  532E: c746a80200       mov word ptr [bp - 0x58], 2
  04B933  5333: ff76fe           push word ptr [bp - 2]
  04B936  5336: ff7698           push word ptr [bp - 0x68]
  04B939  5339: ff7606           push word ptr [bp + 6]
  04B93C  533C: 0e               push cs
  04B93D  533D: e8e500           call 0x5425
  04B940  5340: 83c406           add sp, 6
  04B943  5343: e98c00           jmp 0x53d2
  04B946  5346: ff76fe           push word ptr [bp - 2]
  04B949  5349: ff7698           push word ptr [bp - 0x68]
  04B94C  534C: ff7606           push word ptr [bp + 6]
  04B94F  534F: 0e               push cs
  04B950  5350: e8b400           call 0x5407
  04B953  5353: ebeb             jmp 0x5340
  04B955  5355: 90               nop 
  04B956  5356: ff76fe           push word ptr [bp - 2]
  04B959  5359: ff7698           push word ptr [bp - 0x68]
  04B95C  535C: ff7606           push word ptr [bp + 6]
  04B95F  535F: 0e               push cs
  04B960  5360: e8b300           call 0x5416
  04B963  5363: ebdb             jmp 0x5340
  04B965  5365: 90               nop 
  04B966  5366: ff76fe           push word ptr [bp - 2]
  04B969  5369: ff7698           push word ptr [bp - 0x68]
  04B96C  536C: ff7606           push word ptr [bp + 6]
  04B96F  536F: 0e               push cs
  04B970  5370: e8c600           call 0x5439
  04B973  5373: 83c406           add sp, 6
  04B976  5376: eba7             jmp 0x531f
  04B978  5378: 6a00             push 0
  04B97A  537A: ff76fe           push word ptr [bp - 2]
  04B97D  537D: ff7698           push word ptr [bp - 0x68]
  04B980  5380: ff7606           push word ptr [bp + 6]
  04B983  5383: 0e               push cs
  04B984  5384: e8b700           call 0x543e
  04B987  5387: e97cff           jmp 0x5306
  04B98A  538A: ff76fe           push word ptr [bp - 2]
  04B98D  538D: ff7698           push word ptr [bp - 0x68]
  04B990  5390: ff7606           push word ptr [bp + 6]
  04B993  5393: 0e               push cs
  04B994  5394: e89800           call 0x542f
  04B997  5397: eba7             jmp 0x5340
  04B999  5399: 90               nop 
  04B99A  539A: 6a04             push 4
  04B99C  539C: ff76fe           push word ptr [bp - 2]
  04B99F  539F: ff7698           push word ptr [bp - 0x68]
  04B9A2  53A2: 9a060a1f18       lcall 0x181f, 0xa06
  04B9A7  53A7: 83c406           add sp, 6
  04B9AA  53AA: c746a80000       mov word ptr [bp - 0x58], 0
  04B9AF  53AF: eb21             jmp 0x53d2
  04B9B1  53B1: 90               nop 
  04B9B2  53B2: 48               dec ax
  04B9B3  53B3: 3d0800           cmp ax, 8
  04B9B6  53B6: 771a             ja 0x53d2
  04B9B8  53B8: d1e0             shl ax, 1
  04B9BA  53BA: 93               xchg bx, ax
  04B9BB  53BB: 2effa7e04b       jmp word ptr cs:[bx + 0x4be0]
  04B9C0  53C0: 16               push ss
  04B9C1  53C1: 4b               dec bx
  04B9C2  53C2: 2c4b             sub al, 0x4b
  04B9C4  53C4: 4e               dec si
  04B9C5  53C5: 4b               dec bx
  04B9C6  53C6: 664b             dec ebx
  04B9C8  53C8: 98               cwde 
  04B9C9  53C9: 4b               dec bx
  04B9CA  53CA: 864b76           xchg byte ptr [bp + di + 0x76], cl
  04B9CD  53CD: 4b               dec bx
  04B9CE  53CE: aa               stosb byte ptr es:[di], al
  04B9CF  53CF: 4b               dec bx
  04B9D0  53D0: ba4b6a           mov dx, 0x6a4b
  04B9D3  53D3: 019a1c0e         add word ptr [bp + si + 0xe1c], bx
  04B9D7  53D7: 1f               pop ds
  04B9D8  53D8: 1883c402         sbb byte ptr [bp + di + 0x2c4], al
  04B9DC  53DC: a19c53           mov ax, word ptr [0x539c]
  04B9DF  53DF: 3946aa           cmp word ptr [bp - 0x56], ax
  04B9E2  53E2: 7406             je 0x53ea
  04B9E4  53E4: b80200           mov ax, 2
  04B9E7  53E7: 5e               pop si
  04B9E8  53E8: c9               leave 
  04B9E9  53E9: cb               retf 
  04B9EA  53EA: 837ea801         cmp word ptr [bp - 0x58], 1
  04B9EE  53EE: 750b             jne 0x53fb
  04B9F0  53F0: ff7606           push word ptr [bp + 6]
  04B9F3  53F3: 9a34091f18       lcall 0x181f, 0x934
  04B9F8  53F8: 83c402           add sp, 2
  04B9FB  53FB: 8b46a8           mov ax, word ptr [bp - 0x58]
  04B9FE  53FE: 5e               pop si
  04B9FF  53FF: c9               leave 
  04BA00  5400: cb               retf 
  04BA01  5401: 90               nop 
  04BA02  5402: ea48021f19       ljmp 0x191f:0x248
  04BA07  5407: eaa4031f1a       ljmp 0x1a1f:0x3a4
  04BA0C  540C: eab0031f1a       ljmp 0x1a1f:0x3b0
  04BA11  5411: eabc031f1a       ljmp 0x1a1f:0x3bc
  04BA16  5416: eac8031f1a       ljmp 0x1a1f:0x3c8
  04BA1B  541B: ead4031f1a       ljmp 0x1a1f:0x3d4
  04BA20  5420: eae0031f1a       ljmp 0x1a1f:0x3e0
  04BA25  5425: eaec031f1a       ljmp 0x1a1f:0x3ec
  04BA2A  542A: eaf8031f1a       ljmp 0x1a1f:0x3f8
  04BA2F  542F: ea04041f1a       ljmp 0x1a1f:0x404
  04BA34  5434: ea10041f1a       ljmp 0x1a1f:0x410
  04BA39  5439: ea1c041f1a       ljmp 0x1a1f:0x41c
  04BA3E  543E: ea28041f1a       ljmp 0x1a1f:0x428
  04BA43  5443: ea34041f1a       ljmp 0x1a1f:0x434
  04BA48  5448: ea4c041f1a       ljmp 0x1a1f:0x44c
