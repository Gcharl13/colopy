; ============================================================
; VICEROY.EXE overlay page 0x0F (record 14) -- RE-SEGMENTED
; file_offset (disk image) = 0x0562B0
; code_offset (first insn) = 0x056A10
; code_end (next reloc hdr)= 0x05A950  [resident size 1012 para -> nominal_end 0x05A1F0; on-disk code spills past it]
; reloc_count = 461  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x0562B0)
; functions in page = 14
; ============================================================

; ---- func_056A10  size=247  insns=90  prologue=ENTER 0x0016,0  terminal=RETF ----
  056A10  0760: c8160000         enter 0x16, 0
  056A14  0764: 56               push si
  056A15  0765: 8b1e4285         mov bx, word ptr [0x8542]
  056A19  0769: 8a07             mov al, byte ptr [bx]
  056A1B  076B: 2ae4             sub ah, ah
  056A1D  076D: 8a5701           mov dl, byte ptr [bx + 1]
  056A20  0770: 2af6             sub dh, dh
  056A22  0772: 9ae0071f18       lcall 0x181f, 0x7e0
  056A27  0777: 8946f0           mov word ptr [bp - 0x10], ax
  056A2A  077A: 0bc0             or ax, ax
  056A2C  077C: 7c10             jl 0x78e
  056A2E  077E: 6a0a             push 0xa
  056A30  0780: 50               push ax
  056A31  0781: 9abc081f18       lcall 0x181f, 0x8bc
  056A36  0786: 83c404           add sp, 4
  056A39  0789: 8946fe           mov word ptr [bp - 2], ax
  056A3C  078C: eb05             jmp 0x793
  056A3E  078E: c746fe0000       mov word ptr [bp - 2], 0
  056A43  0793: c746f2ffff       mov word ptr [bp - 0xe], 0xffff
  056A48  0798: 2bc0             sub ax, ax
  056A4A  079A: 8946ec           mov word ptr [bp - 0x14], ax
  056A4D  079D: 8946f8           mov word ptr [bp - 8], ax
  056A50  07A0: 8946ea           mov word ptr [bp - 0x16], ax
  056A53  07A3: 8946fa           mov word ptr [bp - 6], ax
  056A56  07A6: eb79             jmp 0x821
  056A58  07A8: 90               nop 
  056A59  07A9: 90               nop 
  056A5A  07AA: 8b5efa           mov bx, word ptr [bp - 6]
  056A5D  07AD: 8a87be00         mov al, byte ptr [bx + 0xbe]
  056A61  07B1: 98               cwde 
  056A62  07B2: 8b364285         mov si, word ptr [0x8542]
  056A66  07B6: 8a4c01           mov cl, byte ptr [si + 1]
  056A69  07B9: 2aed             sub ch, ch
  056A6B  07BB: 03c1             add ax, cx
  056A6D  07BD: 8bd0             mov dx, ax
  056A6F  07BF: 8a87b400         mov al, byte ptr [bx + 0xb4]
  056A73  07C3: 98               cwde 
  056A74  07C4: 8a0c             mov cl, byte ptr [si]
  056A76  07C6: 03c1             add ax, cx
  056A78  07C8: 9ae0071f18       lcall 0x181f, 0x7e0
  056A7D  07CD: 8946f0           mov word ptr [bp - 0x10], ax
  056A80  07D0: 0bc0             or ax, ax
  056A82  07D2: 7c4a             jl 0x81e
  056A84  07D4: 6bd81c           imul bx, ax, 0x1c
  056A87  07D7: 8a8f4731         mov cl, byte ptr [bx + 0x3147]
  056A8B  07DB: 83e10f           and cx, 0xf
  056A8E  07DE: 894eee           mov word ptr [bp - 0x12], cx
  056A91  07E1: 6a0a             push 0xa
  056A93  07E3: 50               push ax
  056A94  07E4: 9abc081f18       lcall 0x181f, 0x8bc
  056A99  07E9: 83c404           add sp, 4
  056A9C  07EC: 8946fc           mov word ptr [bp - 4], ax
  056A9F  07EF: 8b46ee           mov ax, word ptr [bp - 0x12]
  056AA2  07F2: 39460c           cmp word ptr [bp + 0xc], ax
  056AA5  07F5: 7527             jne 0x81e
  056AA7  07F7: 6a0b             push 0xb
  056AA9  07F9: ff76f0           push word ptr [bp - 0x10]
  056AAC  07FC: 9abc081f18       lcall 0x181f, 0x8bc
  056AB1  0801: 83c404           add sp, 4
  056AB4  0804: c1f803           sar ax, 3
  056AB7  0807: 0146f8           add word ptr [bp - 8], ax
  056ABA  080A: 8b46fc           mov ax, word ptr [bp - 4]
  056ABD  080D: 0146ec           add word ptr [bp - 0x14], ax
  056AC0  0810: 3946ea           cmp word ptr [bp - 0x16], ax
  056AC3  0813: 7f09             jg 0x81e
  056AC5  0815: 8946ea           mov word ptr [bp - 0x16], ax
  056AC8  0818: 8b46ee           mov ax, word ptr [bp - 0x12]
  056ACB  081B: 8946f2           mov word ptr [bp - 0xe], ax
  056ACE  081E: ff46fa           inc word ptr [bp - 6]
  056AD1  0821: 837efa08         cmp word ptr [bp - 6], 8
  056AD5  0825: 7c83             jl 0x7aa
  056AD7  0827: 837e0600         cmp word ptr [bp + 6], 0
  056ADB  082B: 7408             je 0x835
  056ADD  082D: 8b46f2           mov ax, word ptr [bp - 0xe]
  056AE0  0830: 8b5e06           mov bx, word ptr [bp + 6]
  056AE3  0833: 8907             mov word ptr [bx], ax
  056AE5  0835: 837e0800         cmp word ptr [bp + 8], 0
  056AE9  0839: 7408             je 0x843
  056AEB  083B: 8b46fe           mov ax, word ptr [bp - 2]
  056AEE  083E: 8b5e08           mov bx, word ptr [bp + 8]
  056AF1  0841: 8907             mov word ptr [bx], ax
  056AF3  0843: 837e0a00         cmp word ptr [bp + 0xa], 0
  056AF7  0847: 7408             je 0x851
  056AF9  0849: 8b46ec           mov ax, word ptr [bp - 0x14]
  056AFC  084C: 8b5e0a           mov bx, word ptr [bp + 0xa]
  056AFF  084F: 8907             mov word ptr [bx], ax
  056B01  0851: 8b46f8           mov ax, word ptr [bp - 8]
  056B04  0854: 5e               pop si
  056B05  0855: c9               leave 
  056B06  0856: cb               retf 

; ---- func_056B08  size=138  insns=48  prologue=ENTER 0x000E,0  terminal=RETF ----
  056B08  0858: c80e0000         enter 0xe, 0
  056B0C  085C: 56               push si
  056B0D  085D: c746f20000       mov word ptr [bp - 0xe], 0
  056B12  0862: 8a46f2           mov al, byte ptr [bp - 0xe]
  056B15  0865: 8b5ef2           mov bx, word ptr [bp - 0xe]
  056B18  0868: 888750a1         mov byte ptr [bx - 0x5eb0], al
  056B1C  086C: 6a00             push 0
  056B1E  086E: 6a64             push 0x64
  056B20  0870: 69f33c01         imul si, bx, 0x13c
  056B24  0874: ffb43488         push word ptr [si - 0x77cc]
  056B28  0878: ffb43288         push word ptr [si - 0x77ce]
  056B2C  087C: 9ac60e1d0d       lcall 0xd1d, 0xec6
  056B31  0881: 8b5ef2           mov bx, word ptr [bp - 0xe]
  056B34  0884: 8a8f9892         mov cl, byte ptr [bx - 0x6d68]
  056B38  0888: 2aed             sub ch, ch
  056B3A  088A: d1e1             shl cx, 1
  056B3C  088C: 03c1             add ax, cx
  056B3E  088E: 8a8f1094         mov cl, byte ptr [bx - 0x6bf0]
  056B42  0892: 2aed             sub ch, ch
  056B44  0894: 03c1             add ax, cx
  056B46  0896: d1e3             shl bx, 1
  056B48  0898: 03871c94         add ax, word ptr [bx - 0x6be4]
  056B4C  089C: 8946f6           mov word ptr [bp - 0xa], ax
  056B4F  089F: 8bf3             mov si, bx
  056B51  08A1: 8942f8           mov word ptr [bp + si - 8], ax
  056B54  08A4: ff46f2           inc word ptr [bp - 0xe]
  056B57  08A7: 837ef204         cmp word ptr [bp - 0xe], 4
  056B5B  08AB: 7cb5             jl 0x862
  056B5D  08AD: 1e               push ds
  056B5E  08AE: 6850a1           push 0xa150
  056B61  08B1: 8d46f8           lea ax, [bp - 8]
  056B64  08B4: 16               push ss
  056B65  08B5: 50               push ax
  056B66  08B6: b80400           mov ax, 4
  056B69  08B9: 9ad00e1f19       lcall 0x191f, 0xed0
  056B6E  08BE: c746f20000       mov word ptr [bp - 0xe], 0
  056B73  08C3: 8a46f2           mov al, byte ptr [bp - 0xe]
  056B76  08C6: 8b5ef2           mov bx, word ptr [bp - 0xe]
  056B79  08C9: 8a9f50a1         mov bl, byte ptr [bx - 0x5eb0]
  056B7D  08CD: 2aff             sub bh, bh
  056B7F  08CF: 895ef4           mov word ptr [bp - 0xc], bx
  056B82  08D2: 88877c91         mov byte ptr [bx - 0x6e84], al
  056B86  08D6: ff46f2           inc word ptr [bp - 0xe]
  056B89  08D9: 837ef204         cmp word ptr [bp - 0xe], 4
  056B8D  08DD: 7ce4             jl 0x8c3
  056B8F  08DF: 5e               pop si
  056B90  08E0: c9               leave 
  056B91  08E1: cb               retf 

; ---- func_056B92  size=171  insns=58  prologue=ENTER 0x0002,0  terminal=RETF ----
  056B92  08E2: c8020000         enter 2, 0
  056B96  08E6: 56               push si
  056B97  08E7: 6a40             push 0x40
  056B99  08E9: ff7608           push word ptr [bp + 8]
  056B9C  08EC: ff7606           push word ptr [bp + 6]
  056B9F  08EF: 9a060a1f18       lcall 0x181f, 0xa06
  056BA4  08F4: 83c406           add sp, 6
  056BA7  08F7: 8946fe           mov word ptr [bp - 2], ax
  056BAA  08FA: 837e0604         cmp word ptr [bp + 6], 4
  056BAE  08FE: 7c03             jl 0x903
  056BB0  0900: e98400           jmp 0x987
  056BB3  0903: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  056BB7  0907: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  056BBC  090C: 7579             jne 0x987
  056BBE  090E: ff7608           push word ptr [bp + 8]
  056BC1  0911: 9a1a0a1f18       lcall 0x181f, 0xa1a
  056BC6  0916: 83c402           add sp, 2
  056BC9  0919: 50               push ax
  056BCA  091A: 6a00             push 0
  056BCC  091C: 9a38041f18       lcall 0x181f, 0x438
  056BD1  0921: 83c404           add sp, 4
  056BD4  0924: ff7606           push word ptr [bp + 6]
  056BD7  0927: 9a1a0a1f18       lcall 0x181f, 0xa1a
  056BDC  092C: 83c402           add sp, 2
  056BDF  092F: 50               push ax
  056BE0  0930: 6a01             push 1
  056BE2  0932: 9a38041f18       lcall 0x181f, 0x438
  056BE7  0937: 83c404           add sp, 4
  056BEA  093A: 8b4608           mov ax, word ptr [bp + 8]
  056BED  093D: 2d0400           sub ax, 4
  056BF0  0940: 50               push ax
  056BF1  0941: 68ec17           push 0x17ec
  056BF4  0944: 8bf0             mov si, ax
  056BF6  0946: 9a9c011f19       lcall 0x191f, 0x19c
  056BFB  094B: 83c404           add sp, 4
  056BFE  094E: ff7608           push word ptr [bp + 8]
  056C01  0951: 8b4606           mov ax, word ptr [bp + 6]
  056C04  0954: 2d0400           sub ax, 4
  056C07  0957: 50               push ax
  056C08  0958: 9a0c031f18       lcall 0x181f, 0x30c
  056C0D  095D: 83c404           add sp, 4
  056C10  0960: 3d1900           cmp ax, 0x19
  056C13  0963: 7d22             jge 0x987
  056C15  0965: ff7608           push word ptr [bp + 8]
  056C18  0968: 9aa4091f18       lcall 0x181f, 0x9a4
  056C1D  096D: 83c402           add sp, 2
  056C20  0970: 50               push ax
  056C21  0971: 6a00             push 0
  056C23  0973: 9a38041f18       lcall 0x181f, 0x438
  056C28  0978: 83c404           add sp, 4
  056C2B  097B: 56               push si
  056C2C  097C: 68f817           push 0x17f8
  056C2F  097F: 9a9c011f19       lcall 0x191f, 0x19c
  056C34  0984: 83c404           add sp, 4
  056C37  0987: 8b46fe           mov ax, word ptr [bp - 2]
  056C3A  098A: 5e               pop si
  056C3B  098B: c9               leave 
  056C3C  098C: cb               retf 

; ---- func_056C3E  size=3580  insns=1189  prologue=ENTER 0x0054,0  terminal=RETF ----
  056C3E  098E: c8540000         enter 0x54, 0
  056C42  0992: 56               push si
  056C43  0993: b8ffff           mov ax, 0xffff
  056C46  0996: 8946c0           mov word ptr [bp - 0x40], ax
  056C49  0999: 8946b6           mov word ptr [bp - 0x4a], ax
  056C4C  099C: 2bc0             sub ax, ax
  056C4E  099E: 8946e8           mov word ptr [bp - 0x18], ax
  056C51  09A1: 8946b0           mov word ptr [bp - 0x50], ax
  056C54  09A4: 8946ca           mov word ptr [bp - 0x36], ax
  056C57  09A7: 8b460a           mov ax, word ptr [bp + 0xa]
  056C5A  09AA: 8946c4           mov word ptr [bp - 0x3c], ax
  056C5D  09AD: 8b4608           mov ax, word ptr [bp + 8]
  056C60  09B0: 2d0400           sub ax, 4
  056C63  09B3: 50               push ax
  056C64  09B4: 9a420a1f18       lcall 0x181f, 0xa42
  056C69  09B9: 83c402           add sp, 2
  056C6C  09BC: ff7606           push word ptr [bp + 6]
  056C6F  09BF: ff36528d         push word ptr [0x8d52]
  056C73  09C3: 9a0c031f18       lcall 0x181f, 0x30c
  056C78  09C8: 83c404           add sp, 4
  056C7B  09CB: 8946ae           mov word ptr [bp - 0x52], ax
  056C7E  09CE: ff7608           push word ptr [bp + 8]
  056C81  09D1: ff7606           push word ptr [bp + 6]
  056C84  09D4: 9a380a1f18       lcall 0x181f, 0xa38
  056C89  09D9: 83c404           add sp, 4
  056C8C  09DC: 8946cc           mov word ptr [bp - 0x34], ax
  056C8F  09DF: a820             test al, 0x20
  056C91  09E1: 7403             je 0x9e6
  056C93  09E3: e99c01           jmp 0xb82
  056C96  09E6: 6a20             push 0x20
  056C98  09E8: ff7608           push word ptr [bp + 8]
  056C9B  09EB: ff7606           push word ptr [bp + 6]
  056C9E  09EE: 9a060a1f18       lcall 0x181f, 0xa06
  056CA3  09F3: 83c406           add sp, 6
  056CA6  09F6: 8946cc           mov word ptr [bp - 0x34], ax
  056CA9  09F9: 8b7606           mov si, word ptr [bp + 6]
  056CAC  09FC: d1e6             shl si, 1
  056CAE  09FE: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  056CB2  0A02: 8b4046           mov ax, word ptr [bx + si + 0x46]
  056CB5  0A05: 3d1400           cmp ax, 0x14
  056CB8  0A08: 7e03             jle 0xa0d
  056CBA  0A0A: b81400           mov ax, 0x14
  056CBD  0A0D: 894046           mov word ptr [bx + si + 0x46], ax
  056CC0  0A10: ff7606           push word ptr [bp + 6]
  056CC3  0A13: ff36528d         push word ptr [0x8d52]
  056CC7  0A17: 9a0c031f18       lcall 0x181f, 0x30c
  056CCC  0A1C: 83c404           add sp, 4
  056CCF  0A1F: 8946ae           mov word ptr [bp - 0x52], ax
  056CD2  0A22: ff7608           push word ptr [bp + 8]
  056CD5  0A25: 9aa4091f18       lcall 0x181f, 0x9a4
  056CDA  0A2A: 83c402           add sp, 2
  056CDD  0A2D: 50               push ax
  056CDE  0A2E: 6a00             push 0
  056CE0  0A30: 9a38041f18       lcall 0x181f, 0x438
  056CE5  0A35: 83c404           add sp, 4
  056CE8  0A38: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  056CEC  0A3C: 8a5f02           mov bl, byte ptr [bx + 2]
  056CEF  0A3F: 2aff             sub bh, bh
  056CF1  0A41: 8bc3             mov ax, bx
  056CF3  0A43: d1e3             shl bx, 1
  056CF5  0A45: 03d8             add bx, ax
  056CF7  0A47: d1e3             shl bx, 1
  056CF9  0A49: ffb73696         push word ptr [bx - 0x69ca]
  056CFD  0A4D: 6a01             push 1
  056CFF  0A4F: 9a38041f18       lcall 0x181f, 0x438
  056D04  0A54: 83c404           add sp, 4
  056D07  0A57: 8b1e528d         mov bx, word ptr [0x8d52]
  056D0B  0A5B: 8a872a96         mov al, byte ptr [bx - 0x69d6]
  056D0F  0A5F: 2ae4             sub ah, ah
  056D11  0A61: 6a00             push 0
  056D13  0A63: 50               push ax
  056D14  0A64: 6a00             push 0
  056D16  0A66: 9aae091f18       lcall 0x181f, 0x9ae
  056D1B  0A6B: 83c406           add sp, 6
  056D1E  0A6E: 837e0604         cmp word ptr [bp + 6], 4
  056D22  0A72: 7c03             jl 0xa77
  056D24  0A74: e99f00           jmp 0xb16
  056D27  0A77: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  056D2B  0A7B: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  056D30  0A80: 7403             je 0xa85
  056D32  0A82: e99100           jmp 0xb16
  056D35  0A85: c746e60500       mov word ptr [bp - 0x1a], 5
  056D3A  0A8A: 833e528d00       cmp word ptr [0x8d52], 0
  056D3F  0A8F: 7505             jne 0xa96
  056D41  0A91: c746e60700       mov word ptr [bp - 0x1a], 7
  056D46  0A96: 833e528d01       cmp word ptr [0x8d52], 1
  056D4B  0A9B: 7505             jne 0xaa2
  056D4D  0A9D: c746e60600       mov word ptr [bp - 0x1a], 6
  056D52  0AA2: 833e8e5314       cmp word ptr [0x538e], 0x14
  056D57  0AA7: 7d0e             jge 0xab7
  056D59  0AA9: 833ea20000       cmp word ptr [0xa2], 0
  056D5E  0AAE: 7407             je 0xab7
  056D60  0AB0: 833e528d02       cmp word ptr [0x8d52], 2
  056D65  0AB5: 7d0b             jge 0xac2
  056D67  0AB7: ff76e6           push word ptr [bp - 0x1a]
  056D6A  0ABA: 9aac041f18       lcall 0x181f, 0x4ac
  056D6F  0ABF: eb09             jmp 0xaca
  056D71  0AC1: 90               nop 
  056D72  0AC2: ff76e6           push word ptr [bp - 0x1a]
  056D75  0AC5: 9a98041f18       lcall 0x181f, 0x498
  056D7A  0ACA: 83c402           add sp, 2
  056D7D  0ACD: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  056D81  0AD1: 8a874531         mov al, byte ptr [bx + 0x3145]
  056D85  0AD5: 2ae4             sub ah, ah
  056D87  0AD7: 50               push ax
  056D88  0AD8: 8a874431         mov al, byte ptr [bx + 0x3144]
  056D8C  0ADC: 50               push ax
  056D8D  0ADD: 9a9a0d1f18       lcall 0x181f, 0xd9a
  056D92  0AE2: 83c404           add sp, 4
  056D95  0AE5: a1528d           mov ax, word ptr [0x8d52]
  056D98  0AE8: 0bc0             or ax, ax
  056D9A  0AEA: 7408             je 0xaf4
  056D9C  0AEC: 48               dec ax
  056D9D  0AED: 7423             je 0xb12
  056D9F  0AEF: 6a03             push 3
  056DA1  0AF1: eb03             jmp 0xaf6
  056DA3  0AF3: 90               nop 
  056DA4  0AF4: 6a05             push 5
  056DA6  0AF6: 9a24051f18       lcall 0x181f, 0x524
  056DAB  0AFB: 83c402           add sp, 2
  056DAE  0AFE: ff36528d         push word ptr [0x8d52]
  056DB2  0B02: 680318           push 0x1803
  056DB5  0B05: 9a9c011f19       lcall 0x191f, 0x19c
  056DBA  0B0A: 83c404           add sp, 4
  056DBD  0B0D: 8946f6           mov word ptr [bp - 0xa], ax
  056DC0  0B10: eb09             jmp 0xb1b
  056DC2  0B12: 6a04             push 4
  056DC4  0B14: ebe0             jmp 0xaf6
  056DC6  0B16: c746f60100       mov word ptr [bp - 0xa], 1
  056DCB  0B1B: 837ef602         cmp word ptr [bp - 0xa], 2
  056DCF  0B1F: 7413             je 0xb34
  056DD1  0B21: ff7608           push word ptr [bp + 8]
  056DD4  0B24: ff7606           push word ptr [bp + 6]
  056DD7  0B27: 0e               push cs
  056DD8  0B28: e81e34           call 0x3f49
  056DDB  0B2B: 83c404           add sp, 4
  056DDE  0B2E: 8946cc           mov word ptr [bp - 0x34], ax
  056DE1  0B31: eb39             jmp 0xb6c
  056DE3  0B33: 90               nop 
  056DE4  0B34: 6a00             push 0
  056DE6  0B36: 6a64             push 0x64
  056DE8  0B38: ff7606           push word ptr [bp + 6]
  056DEB  0B3B: ff36528d         push word ptr [0x8d52]
  056DEF  0B3F: 9a6c0d1f18       lcall 0x181f, 0xd6c
  056DF4  0B44: 83c408           add sp, 8
  056DF7  0B47: ff7608           push word ptr [bp + 8]
  056DFA  0B4A: 9a1a0a1f18       lcall 0x181f, 0xa1a
  056DFF  0B4F: 83c402           add sp, 2
  056E02  0B52: 50               push ax
  056E03  0B53: 6a00             push 0
  056E05  0B55: 9a38041f18       lcall 0x181f, 0x438
  056E0A  0B5A: 83c404           add sp, 4
  056E0D  0B5D: ff36528d         push word ptr [0x8d52]
  056E11  0B61: 681118           push 0x1811
  056E14  0B64: 9a9c011f19       lcall 0x191f, 0x19c
  056E19  0B69: 83c404           add sp, 4
  056E1C  0B6C: c746e80100       mov word ptr [bp - 0x18], 1
  056E21  0B71: 8b7606           mov si, word ptr [bp + 6]
  056E24  0B74: d1e6             shl si, 1
  056E26  0B76: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  056E2A  0B7A: c7402e0200       mov word ptr [bx + si + 0x2e], 2
  056E2F  0B7F: e9e30b           jmp 0x1765
  056E32  0B82: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  056E36  0B86: 8a874431         mov al, byte ptr [bx + 0x3144]
  056E3A  0B8A: 2ae4             sub ah, ah
  056E3C  0B8C: 8946d4           mov word ptr [bp - 0x2c], ax
  056E3F  0B8F: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  056E43  0B93: 2aed             sub ch, ch
  056E45  0B95: 894ece           mov word ptr [bp - 0x32], cx
  056E48  0B98: 8b760c           mov si, word ptr [bp + 0xc]
  056E4B  0B9B: 8bd0             mov dx, ax
  056E4D  0B9D: 8a84b400         mov al, byte ptr [si + 0xb4]
  056E51  0BA1: 98               cwde 
  056E52  0BA2: 03d0             add dx, ax
  056E54  0BA4: 8956f8           mov word ptr [bp - 8], dx
  056E57  0BA7: 8a84be00         mov al, byte ptr [si + 0xbe]
  056E5B  0BAB: 98               cwde 
  056E5C  0BAC: 03c8             add cx, ax
  056E5E  0BAE: 894ef0           mov word ptr [bp - 0x10], cx
  056E61  0BB1: f687483108       test byte ptr [bx + 0x3148], 8
  056E66  0BB6: 7403             je 0xbbb
  056E68  0BB8: e9aa0b           jmp 0x1765
  056E6B  0BBB: ff76ce           push word ptr [bp - 0x32]
  056E6E  0BBE: ff76d4           push word ptr [bp - 0x2c]
  056E71  0BC1: 9af0061f18       lcall 0x181f, 0x6f0
  056E76  0BC6: 83c404           add sp, 4
  056E79  0BC9: 0bc0             or ax, ax
  056E7B  0BCB: 7c03             jl 0xbd0
  056E7D  0BCD: e9950b           jmp 0x1765
  056E80  0BD0: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  056E84  0BD4: 8a874731         mov al, byte ptr [bx + 0x3147]
  056E88  0BD8: 250f00           and ax, 0xf
  056E8B  0BDB: 8946ba           mov word ptr [bp - 0x46], ax
  056E8E  0BDE: 8b46f8           mov ax, word ptr [bp - 8]
  056E91  0BE1: 8b56f0           mov dx, word ptr [bp - 0x10]
  056E94  0BE4: 9ae0071f18       lcall 0x181f, 0x7e0
  056E99  0BE9: 89460a           mov word ptr [bp + 0xa], ax
  056E9C  0BEC: 837eba04         cmp word ptr [bp - 0x46], 4
  056EA0  0BF0: 7d20             jge 0xc12
  056EA2  0BF2: 6bd81c           imul bx, ax, 0x1c
  056EA5  0BF5: 80bf46310c       cmp byte ptr [bx + 0x3146], 0xc
  056EAA  0BFA: 7403             je 0xbff
  056EAC  0BFC: e9660b           jmp 0x1765
  056EAF  0BFF: 8b46c4           mov ax, word ptr [bp - 0x3c]
  056EB2  0C02: 8946c0           mov word ptr [bp - 0x40], ax
  056EB5  0C05: 80760c04         xor byte ptr [bp + 0xc], 4
  056EB9  0C09: 837e0a00         cmp word ptr [bp + 0xa], 0
  056EBD  0C0D: 7d2b             jge 0xc3a
  056EBF  0C0F: e9530b           jmp 0x1765
  056EC2  0C12: 0bc0             or ax, ax
  056EC4  0C14: 7c0d             jl 0xc23
  056EC6  0C16: 6bd81c           imul bx, ax, 0x1c
  056EC9  0C19: 80bf46310c       cmp byte ptr [bx + 0x3146], 0xc
  056ECE  0C1E: 7503             jne 0xc23
  056ED0  0C20: 8946c0           mov word ptr [bp - 0x40], ax
  056ED3  0C23: ff76f0           push word ptr [bp - 0x10]
  056ED6  0C26: ff76f8           push word ptr [bp - 8]
  056ED9  0C29: 9abe071f18       lcall 0x181f, 0x7be
  056EDE  0C2E: 83c404           add sp, 4
  056EE1  0C31: 8946b6           mov word ptr [bp - 0x4a], ax
  056EE4  0C34: 8b46c4           mov ax, word ptr [bp - 0x3c]
  056EE7  0C37: 89460a           mov word ptr [bp + 0xa], ax
  056EEA  0C3A: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  056EEE  0C3E: 8a874431         mov al, byte ptr [bx + 0x3144]
  056EF2  0C42: 2ae4             sub ah, ah
  056EF4  0C44: 8946d4           mov word ptr [bp - 0x2c], ax
  056EF7  0C47: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  056EFB  0C4B: 2aed             sub ch, ch
  056EFD  0C4D: 894ece           mov word ptr [bp - 0x32], cx
  056F00  0C50: 8b760c           mov si, word ptr [bp + 0xc]
  056F03  0C53: 8bd0             mov dx, ax
  056F05  0C55: 8a84b400         mov al, byte ptr [si + 0xb4]
  056F09  0C59: 98               cwde 
  056F0A  0C5A: 03d0             add dx, ax
  056F0C  0C5C: 8956f8           mov word ptr [bp - 8], dx
  056F0F  0C5F: 8a84be00         mov al, byte ptr [si + 0xbe]
  056F13  0C63: 98               cwde 
  056F14  0C64: 03c8             add cx, ax
  056F16  0C66: 894ef0           mov word ptr [bp - 0x10], cx
  056F19  0C69: 80bf4a3100       cmp byte ptr [bx + 0x314a], 0
  056F1E  0C6E: 7d03             jge 0xc73
  056F20  0C70: e9f20a           jmp 0x1765
  056F23  0C73: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  056F27  0C77: 8a874a31         mov al, byte ptr [bx + 0x314a]
  056F2B  0C7B: 98               cwde 
  056F2C  0C7C: 50               push ax
  056F2D  0C7D: 9a4c0a1f18       lcall 0x181f, 0xa4c
  056F32  0C82: 83c402           add sp, 2
  056F35  0C85: 8b7606           mov si, word ptr [bp + 6]
  056F38  0C88: d1e6             shl si, 1
  056F3A  0C8A: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  056F3E  0C8E: 8b400a           mov ax, word ptr [bx + si + 0xa]
  056F41  0C91: 8946b8           mov word ptr [bp - 0x48], ax
  056F44  0C94: 8976ac           mov word ptr [bp - 0x54], si
  056F47  0C97: 3d8000           cmp ax, 0x80
  056F4A  0C9A: 7c06             jl 0xca2
  056F4C  0C9C: b80100           mov ax, 1
  056F4F  0C9F: eb03             jmp 0xca4
  056F51  0CA1: 90               nop 
  056F52  0CA2: 2bc0             sub ax, ax
  056F54  0CA4: 8946f2           mov word ptr [bp - 0xe], ax
  056F57  0CA7: 837eae4b         cmp word ptr [bp - 0x52], 0x4b
  056F5B  0CAB: 7c05             jl 0xcb2
  056F5D  0CAD: b80100           mov ax, 1
  056F60  0CB0: eb02             jmp 0xcb4
  056F62  0CB2: 2bc0             sub ax, ax
  056F64  0CB4: 8946c8           mov word ptr [bp - 0x38], ax
  056F67  0CB7: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  056F6B  0CBB: 83782e01         cmp word ptr [bx + si + 0x2e], 1
  056F6F  0CBF: 7505             jne 0xcc6
  056F71  0CC1: c746f20100       mov word ptr [bp - 0xe], 1
  056F76  0CC6: 0bc0             or ax, ax
  056F78  0CC8: 7403             je 0xccd
  056F7A  0CCA: e9980a           jmp 0x1765
  056F7D  0CCD: 3946f2           cmp word ptr [bp - 0xe], ax
  056F80  0CD0: 741e             je 0xcf0
  056F82  0CD2: 688000           push 0x80
  056F85  0CD5: 6a01             push 1
  056F87  0CD7: 9ad4041f18       lcall 0x181f, 0x4d4
  056F8C  0CDC: 83c404           add sp, 4
  056F8F  0CDF: 8946f4           mov word ptr [bp - 0xc], ax
  056F92  0CE2: 8b4eb8           mov cx, word ptr [bp - 0x48]
  056F95  0CE5: 81e98000         sub cx, 0x80
  056F99  0CE9: 3bc1             cmp ax, cx
  056F9B  0CEB: 7d03             jge 0xcf0
  056F9D  0CED: e9750a           jmp 0x1765
  056FA0  0CF0: 684801           push 0x148
  056FA3  0CF3: 6a01             push 1
  056FA5  0CF5: 9ad4041f18       lcall 0x181f, 0x4d4
  056FAA  0CFA: 83c404           add sp, 4
  056FAD  0CFD: 8946f4           mov word ptr [bp - 0xc], ax
  056FB0  0D00: 8b4eae           mov cx, word ptr [bp - 0x52]
  056FB3  0D03: 83e919           sub cx, 0x19
  056FB6  0D06: 7902             jns 0xd0a
  056FB8  0D08: 2bc9             sub cx, cx
  056FBA  0D0A: c1e102           shl cx, 2
  056FBD  0D0D: 034eb8           add cx, word ptr [bp - 0x48]
  056FC0  0D10: 3bc8             cmp cx, ax
  056FC2  0D12: 7f06             jg 0xd1a
  056FC4  0D14: b80100           mov ax, 1
  056FC7  0D17: eb03             jmp 0xd1c
  056FC9  0D19: 90               nop 
  056FCA  0D1A: 2bc0             sub ax, ax
  056FCC  0D1C: 8946be           mov word ptr [bp - 0x42], ax
  056FCF  0D1F: 8946b0           mov word ptr [bp - 0x50], ax
  056FD2  0D22: 837ef200         cmp word ptr [bp - 0xe], 0
  056FD6  0D26: 7506             jne 0xd2e
  056FD8  0D28: 837ec800         cmp word ptr [bp - 0x38], 0
  056FDC  0D2C: 7405             je 0xd33
  056FDE  0D2E: c746b00000       mov word ptr [bp - 0x50], 0
  056FE3  0D33: 837eb000         cmp word ptr [bp - 0x50], 0
  056FE7  0D37: 7419             je 0xd52
  056FE9  0D39: 837eae32         cmp word ptr [bp - 0x52], 0x32
  056FED  0D3D: 7c13             jl 0xd52
  056FEF  0D3F: c746b00000       mov word ptr [bp - 0x50], 0
  056FF4  0D44: 8b7606           mov si, word ptr [bp + 6]
  056FF7  0D47: d1e6             shl si, 1
  056FF9  0D49: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  056FFD  0D4D: c7402e0200       mov word ptr [bx + si + 0x2e], 2
  057002  0D52: 837e0604         cmp word ptr [bp + 6], 4
  057006  0D56: 7c03             jl 0xd5b
  057008  0D58: e98800           jmp 0xde3
  05700B  0D5B: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  05700F  0D5F: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  057014  0D64: 757d             jne 0xde3
  057016  0D66: 837eb600         cmp word ptr [bp - 0x4a], 0
  05701A  0D6A: 7c77             jl 0xde3
  05701C  0D6C: 6a00             push 0
  05701E  0D6E: ff76f0           push word ptr [bp - 0x10]
  057021  0D71: ff76f8           push word ptr [bp - 8]
  057024  0D74: 9a080e1f18       lcall 0x181f, 0xe08
  057029  0D79: 83c406           add sp, 6
  05702C  0D7C: ff76f0           push word ptr [bp - 0x10]
  05702F  0D7F: ff76f8           push word ptr [bp - 8]
  057032  0D82: ff76ce           push word ptr [bp - 0x32]
  057035  0D85: ff76d4           push word ptr [bp - 0x2c]
  057038  0D88: 6aff             push -1
  05703A  0D8A: 68c000           push 0xc0
  05703D  0D8D: ff76c4           push word ptr [bp - 0x3c]
  057040  0D90: 9ad0021f18       lcall 0x181f, 0x2d0
  057045  0D95: 83c40e           add sp, 0xe
  057048  0D98: 6a01             push 1
  05704A  0D9A: 6a02             push 2
  05704C  0D9C: 6a02             push 2
  05704E  0D9E: ff76f0           push word ptr [bp - 0x10]
  057051  0DA1: ff76f8           push word ptr [bp - 8]
  057054  0DA4: 9aba091f18       lcall 0x181f, 0x9ba
  057059  0DA9: 83c40a           add sp, 0xa
  05705C  0DAC: 6a08             push 8
  05705E  0DAE: 6a00             push 0
  057060  0DB0: 9ad4041f18       lcall 0x181f, 0x4d4
  057065  0DB5: 83c404           add sp, 4
  057068  0DB8: 0bc0             or ax, ax
  05706A  0DBA: 7527             jne 0xde3
  05706C  0DBC: c746e60500       mov word ptr [bp - 0x1a], 5
  057071  0DC1: 3906528d         cmp word ptr [0x8d52], ax
  057075  0DC5: 7505             jne 0xdcc
  057077  0DC7: c746e60700       mov word ptr [bp - 0x1a], 7
  05707C  0DCC: 833e528d01       cmp word ptr [0x8d52], 1
  057081  0DD1: 7505             jne 0xdd8
  057083  0DD3: c746e60600       mov word ptr [bp - 0x1a], 6
  057088  0DD8: ff76e6           push word ptr [bp - 0x1a]
  05708B  0DDB: 9a98041f18       lcall 0x181f, 0x498
  057090  0DE0: 83c402           add sp, 2
  057093  0DE3: 9a34041f1a       lcall 0x1a1f, 0x434
  057098  0DE8: a1589e           mov ax, word ptr [0x9e58]
  05709B  0DEB: 2b06789e         sub ax, word ptr [0x9e78]
  05709F  0DEF: 8946d2           mov word ptr [bp - 0x2e], ax
  0570A2  0DF2: 0bc0             or ax, ax
  0570A4  0DF4: 7f03             jg 0xdf9
  0570A6  0DF6: e9e301           jmp 0xfdc
  0570A9  0DF9: 837ec800         cmp word ptr [bp - 0x38], 0
  0570AD  0DFD: 7403             je 0xe02
  0570AF  0DFF: e9da01           jmp 0xfdc
  0570B2  0E02: 837eb600         cmp word ptr [bp - 0x4a], 0
  0570B6  0E06: 7d03             jge 0xe0b
  0570B8  0E08: e9d101           jmp 0xfdc
  0570BB  0E0B: ff76b6           push word ptr [bp - 0x4a]
  0570BE  0E0E: 9ae6091f18       lcall 0x181f, 0x9e6
  0570C3  0E13: 83c402           add sp, 2
  0570C6  0E16: 8b1e4285         mov bx, word ptr [0x8542]
  0570CA  0E1A: 83bf9a004b       cmp word ptr [bx + 0x9a], 0x4b
  0570CF  0E1F: 7d03             jge 0xe24
  0570D1  0E21: e9b801           jmp 0xfdc
  0570D4  0E24: 8b879a00         mov ax, word ptr [bx + 0x9a]
  0570D8  0E28: d1f8             sar ax, 1
  0570DA  0E2A: 8946c6           mov word ptr [bp - 0x3a], ax
  0570DD  0E2D: 6a64             push 0x64
  0570DF  0E2F: 6a01             push 1
  0570E1  0E31: 9ad4041f18       lcall 0x181f, 0x4d4
  0570E6  0E36: 83c404           add sp, 4
  0570E9  0E39: 3b46d2           cmp ax, word ptr [bp - 0x2e]
  0570EC  0E3C: 7e03             jle 0xe41
  0570EE  0E3E: e99b01           jmp 0xfdc
  0570F1  0E41: ff7608           push word ptr [bp + 8]
  0570F4  0E44: 9aa4091f18       lcall 0x181f, 0x9a4
  0570F9  0E49: 83c402           add sp, 2
  0570FC  0E4C: 50               push ax
  0570FD  0E4D: 6a00             push 0
  0570FF  0E4F: 9a38041f18       lcall 0x181f, 0x438
  057104  0E54: 83c404           add sp, 4
  057107  0E57: a14285           mov ax, word ptr [0x8542]
  05710A  0E5A: 40               inc ax
  05710B  0E5B: 40               inc ax
  05710C  0E5C: 1e               push ds
  05710D  0E5D: 50               push ax
  05710E  0E5E: b80100           mov ax, 1
  057111  0E61: 8946e8           mov word ptr [bp - 0x18], ax
  057114  0E64: 50               push ax
  057115  0E65: 9a16041f18       lcall 0x181f, 0x416
  05711A  0E6A: 83c406           add sp, 6
  05711D  0E6D: 8b46c6           mov ax, word ptr [bp - 0x3a]
  057120  0E70: 99               cdq 
  057121  0E71: 52               push dx
  057122  0E72: 50               push ax
  057123  0E73: 6a00             push 0
  057125  0E75: 9aae091f18       lcall 0x181f, 0x9ae
  05712A  0E7A: 83c406           add sp, 6
  05712D  0E7D: 8b1e4285         mov bx, word ptr [0x8542]
  057131  0E81: 8b879a00         mov ax, word ptr [bx + 0x9a]
  057135  0E85: 99               cdq 
  057136  0E86: 52               push dx
  057137  0E87: 50               push ax
  057138  0E88: 6a01             push 1
  05713A  0E8A: 9aae091f18       lcall 0x181f, 0x9ae
  05713F  0E8F: 83c406           add sp, 6
  057142  0E92: 837e0604         cmp word ptr [bp + 6], 4
  057146  0E96: 7d36             jge 0xece
  057148  0E98: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  05714C  0E9C: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  057151  0EA1: 752b             jne 0xece
  057153  0EA3: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  057157  0EA7: 8a874531         mov al, byte ptr [bx + 0x3145]
  05715B  0EAB: 2ae4             sub ah, ah
  05715D  0EAD: 50               push ax
  05715E  0EAE: 8a874431         mov al, byte ptr [bx + 0x3144]
  057162  0EB2: 50               push ax
  057163  0EB3: 9a9a0d1f18       lcall 0x181f, 0xd9a
  057168  0EB8: 83c404           add sp, 4
  05716B  0EBB: ff36528d         push word ptr [0x8d52]
  05716F  0EBF: 681c18           push 0x181c
  057172  0EC2: 9a9c011f19       lcall 0x191f, 0x19c
  057177  0EC7: 83c404           add sp, 4
  05717A  0ECA: eb11             jmp 0xedd
  05717C  0ECC: 90               nop 
  05717D  0ECD: 90               nop 
  05717E  0ECE: 837e0602         cmp word ptr [bp + 6], 2
  057182  0ED2: 7506             jne 0xeda
  057184  0ED4: b80100           mov ax, 1
  057187  0ED7: eb04             jmp 0xedd
  057189  0ED9: 90               nop 
  05718A  0EDA: b80200           mov ax, 2
  05718D  0EDD: 8946f6           mov word ptr [bp - 0xa], ax
  057190  0EE0: 3d0200           cmp ax, 2
  057193  0EE3: 7403             je 0xee8
  057195  0EE5: e99200           jmp 0xf7a
  057198  0EE8: 8b46c6           mov ax, word ptr [bp - 0x3a]
  05719B  0EEB: 8b1e4285         mov bx, word ptr [0x8542]
  05719F  0EEF: 29879a00         sub word ptr [bx + 0x9a], ax
  0571A3  0EF3: 8b7606           mov si, word ptr [bp + 6]
  0571A6  0EF6: d1e6             shl si, 1
  0571A8  0EF8: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  0571AC  0EFC: c7400a0000       mov word ptr [bx + si + 0xa], 0
  0571B1  0F01: c746fafbff       mov word ptr [bp - 6], 0xfffb
  0571B6  0F06: f6470304         test byte ptr [bx + 3], 4
  0571BA  0F0A: 740c             je 0xf18
  0571BC  0F0C: c746faf6ff       mov word ptr [bp - 6], 0xfff6
  0571C1  0F11: eb05             jmp 0xf18
  0571C3  0F13: 90               nop 
  0571C4  0F14: 836efa05         sub word ptr [bp - 6], 5
  0571C8  0F18: ff7606           push word ptr [bp + 6]
  0571CB  0F1B: ff36528d         push word ptr [0x8d52]
  0571CF  0F1F: 9a0c031f18       lcall 0x181f, 0x30c
  0571D4  0F24: 83c404           add sp, 4
  0571D7  0F27: 0346fa           add ax, word ptr [bp - 6]
  0571DA  0F2A: 3d4600           cmp ax, 0x46
  0571DD  0F2D: 7fe5             jg 0xf14
  0571DF  0F2F: 6a00             push 0
  0571E1  0F31: ff76fa           push word ptr [bp - 6]
  0571E4  0F34: ff7606           push word ptr [bp + 6]
  0571E7  0F37: ff36528d         push word ptr [0x8d52]
  0571EB  0F3B: 9a6c0d1f18       lcall 0x181f, 0xd6c
  0571F0  0F40: 83c408           add sp, 8
  0571F3  0F43: c746ca0100       mov word ptr [bp - 0x36], 1
  0571F8  0F48: 837eb000         cmp word ptr [bp - 0x50], 0
  0571FC  0F4C: 7517             jne 0xf65
  0571FE  0F4E: a0a653           mov al, byte ptr [0x53a6]
  057201  0F51: 2ae4             sub ah, ah
  057203  0F53: 50               push ax
  057204  0F54: 6a00             push 0
  057206  0F56: 9ad4041f18       lcall 0x181f, 0x4d4
  05720B  0F5B: 83c404           add sp, 4
  05720E  0F5E: 0bc0             or ax, ax
  057210  0F60: 7403             je 0xf65
  057212  0F62: e90008           jmp 0x1765
  057215  0F65: c746b00100       mov word ptr [bp - 0x50], 1
  05721A  0F6A: 8b7606           mov si, word ptr [bp + 6]
  05721D  0F6D: d1e6             shl si, 1
  05721F  0F6F: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  057223  0F73: c7402e0200       mov word ptr [bx + si + 0x2e], 2
  057228  0F78: eb62             jmp 0xfdc
  05722A  0F7A: 8b7606           mov si, word ptr [bp + 6]
  05722D  0F7D: d1e6             shl si, 1
  05722F  0F7F: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  057233  0F83: 8b400a           mov ax, word ptr [bx + si + 0xa]
  057236  0F86: d1f8             sar ax, 1
  057238  0F88: 01400a           add word ptr [bx + si + 0xa], ax
  05723B  0F8B: a0a653           mov al, byte ptr [0x53a6]
  05723E  0F8E: 2ae4             sub ah, ah
  057240  0F90: 40               inc ax
  057241  0F91: d1f8             sar ax, 1
  057243  0F93: 40               inc ax
  057244  0F94: 8946fa           mov word ptr [bp - 6], ax
  057247  0F97: f6470304         test byte ptr [bx + 3], 4
  05724B  0F9B: 7405             je 0xfa2
  05724D  0F9D: d1e0             shl ax, 1
  05724F  0F9F: 8946fa           mov word ptr [bp - 6], ax
  057252  0FA2: 837ebe00         cmp word ptr [bp - 0x42], 0
  057256  0FA6: 7403             je 0xfab
  057258  0FA8: d17efa           sar word ptr [bp - 6], 1
  05725B  0FAB: 6a00             push 0
  05725D  0FAD: ff76fa           push word ptr [bp - 6]
  057260  0FB0: ff7608           push word ptr [bp + 8]
  057263  0FB3: ff36528d         push word ptr [0x8d52]
  057267  0FB7: 9a6c0d1f18       lcall 0x181f, 0xd6c
  05726C  0FBC: 83c408           add sp, 8
  05726F  0FBF: 8b7606           mov si, word ptr [bp + 6]
  057272  0FC2: d1e6             shl si, 1
  057274  0FC4: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  057278  0FC8: 83782e02         cmp word ptr [bx + si + 0x2e], 2
  05727C  0FCC: 7505             jne 0xfd3
  05727E  0FCE: c7402e0000       mov word ptr [bx + si + 0x2e], 0
  057283  0FD3: 837eb000         cmp word ptr [bp - 0x50], 0
  057287  0FD7: 7403             je 0xfdc
  057289  0FD9: e98907           jmp 0x1765
  05728C  0FDC: 837eb000         cmp word ptr [bp - 0x50], 0
  057290  0FE0: 7503             jne 0xfe5
  057292  0FE2: e96a05           jmp 0x154f
  057295  0FE5: 837eb600         cmp word ptr [bp - 0x4a], 0
  057299  0FE9: 7d03             jge 0xfee
  05729B  0FEB: e97707           jmp 0x1765
  05729E  0FEE: 8b7606           mov si, word ptr [bp + 6]
  0572A1  0FF1: d1e6             shl si, 1
  0572A3  0FF3: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0572A7  0FF7: c7402e0200       mov word ptr [bx + si + 0x2e], 2
  0572AC  0FFC: ff76b6           push word ptr [bp - 0x4a]
  0572AF  0FFF: 9ae6091f18       lcall 0x181f, 0x9e6
  0572B4  1004: 83c402           add sp, 2
  0572B7  1007: 9a3a0d1f18       lcall 0x181f, 0xd3a
  0572BC  100C: 8946b4           mov word ptr [bp - 0x4c], ax
  0572BF  100F: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  0572C3  1013: c7400a0000       mov word ptr [bx + si + 0xa], 0
  0572C8  1018: ff7608           push word ptr [bp + 8]
  0572CB  101B: 9aa4091f18       lcall 0x181f, 0x9a4
  0572D0  1020: 83c402           add sp, 2
  0572D3  1023: 50               push ax
  0572D4  1024: 6a00             push 0
  0572D6  1026: 9a38041f18       lcall 0x181f, 0x438
  0572DB  102B: 83c404           add sp, 4
  0572DE  102E: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  0572E2  1032: 8a4705           mov al, byte ptr [bx + 5]
  0572E5  1035: 8bc8             mov cx, ax
  0572E7  1037: 250f00           and ax, 0xf
  0572EA  103A: 3b4606           cmp ax, word ptr [bp + 6]
  0572ED  103D: 7403             je 0x1042
  0572EF  103F: e98a00           jmp 0x10cc
  0572F2  1042: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0572F6  1046: 8a4702           mov al, byte ptr [bx + 2]
  0572F9  1049: 2ae4             sub ah, ah
  0572FB  104B: 40               inc ax
  0572FC  104C: 40               inc ax
  0572FD  104D: 8946fc           mov word ptr [bp - 4], ax
  057300  1050: f6c110           test cl, 0x10
  057303  1053: 7405             je 0x105a
  057305  1055: d1e0             shl ax, 1
  057307  1057: 8946fc           mov word ptr [bp - 4], ax
  05730A  105A: 6a0f             push 0xf
  05730C  105C: 6a00             push 0
  05730E  105E: 9ad4041f18       lcall 0x181f, 0x4d4
  057313  1063: 83c404           add sp, 4
  057316  1066: 3b46fc           cmp ax, word ptr [bp - 4]
  057319  1069: 7d61             jge 0x10cc
  05731B  106B: 837e0604         cmp word ptr [bp + 6], 4
  05731F  106F: 7d2b             jge 0x109c
  057321  1071: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  057325  1075: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05732A  107A: 7520             jne 0x109c
  05732C  107C: a14285           mov ax, word ptr [0x8542]
  05732F  107F: 40               inc ax
  057330  1080: 40               inc ax
  057331  1081: 1e               push ds
  057332  1082: 50               push ax
  057333  1083: 6a00             push 0
  057335  1085: 9a16041f18       lcall 0x181f, 0x416
  05733A  108A: 83c406           add sp, 6
  05733D  108D: ff36528d         push word ptr [0x8d52]
  057341  1091: 682a18           push 0x182a
  057344  1094: 9a9c011f19       lcall 0x191f, 0x19c
  057349  1099: 83c404           add sp, 4
  05734C  109C: 8b1e4285         mov bx, word ptr [0x8542]
  057350  10A0: 8a4701           mov al, byte ptr [bx + 1]
  057353  10A3: 2ae4             sub ah, ah
  057355  10A5: 50               push ax
  057356  10A6: 8a07             mov al, byte ptr [bx]
  057358  10A8: 50               push ax
  057359  10A9: 8a471a           mov al, byte ptr [bx + 0x1a]
  05735C  10AC: 50               push ax
  05735D  10AD: 6a00             push 0
  05735F  10AF: 9a5c091f18       lcall 0x181f, 0x95c
  057364  10B4: 83c408           add sp, 8
  057367  10B7: 89460a           mov word ptr [bp + 0xa], ax
  05736A  10BA: 0bc0             or ax, ax
  05736C  10BC: 7d03             jge 0x10c1
  05736E  10BE: e9a406           jmp 0x1765
  057371  10C1: 6bd81c           imul bx, ax, 0x1c
  057374  10C4: c6875b311b       mov byte ptr [bx + 0x315b], 0x1b
  057379  10C9: e99406           jmp 0x1760
  05737C  10CC: a1589e           mov ax, word ptr [0x9e58]
  05737F  10CF: 3906789e         cmp word ptr [0x9e78], ax
  057383  10D3: 7e6d             jle 0x1142
  057385  10D5: 837eca00         cmp word ptr [bp - 0x36], 0
  057389  10D9: 7567             jne 0x1142
  05738B  10DB: 8b1e4285         mov bx, word ptr [0x8542]
  05738F  10DF: 83bf9a0019       cmp word ptr [bx + 0x9a], 0x19
  057394  10E4: 7f5c             jg 0x1142
  057396  10E6: b84b00           mov ax, 0x4b
  057399  10E9: 2b879a00         sub ax, word ptr [bx + 0x9a]
  05739D  10ED: 8946c6           mov word ptr [bp - 0x3a], ax
  0573A0  10F0: 99               cdq 
  0573A1  10F1: 52               push dx
  0573A2  10F2: 50               push ax
  0573A3  10F3: 6a00             push 0
  0573A5  10F5: 9aae091f18       lcall 0x181f, 0x9ae
  0573AA  10FA: 83c406           add sp, 6
  0573AD  10FD: 8b46c6           mov ax, word ptr [bp - 0x3a]
  0573B0  1100: 8b1e4285         mov bx, word ptr [0x8542]
  0573B4  1104: 01879a00         add word ptr [bx + 0x9a], ax
  0573B8  1108: 837e0604         cmp word ptr [bp + 6], 4
  0573BC  110C: 7c03             jl 0x1111
  0573BE  110E: e94f06           jmp 0x1760
  0573C1  1111: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  0573C5  1115: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  0573CA  111A: 7403             je 0x111f
  0573CC  111C: e94106           jmp 0x1760
  0573CF  111F: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  0573D3  1123: 8a874531         mov al, byte ptr [bx + 0x3145]
  0573D7  1127: 2ae4             sub ah, ah
  0573D9  1129: 50               push ax
  0573DA  112A: 8a874431         mov al, byte ptr [bx + 0x3144]
  0573DE  112E: 50               push ax
  0573DF  112F: 9a9a0d1f18       lcall 0x181f, 0xd9a
  0573E4  1134: 83c404           add sp, 4
  0573E7  1137: ff36528d         push word ptr [0x8d52]
  0573EB  113B: 683918           push 0x1839
  0573EE  113E: e95f01           jmp 0x12a0
  0573F1  1141: 90               nop 
  0573F2  1142: 2bc0             sub ax, ax
  0573F4  1144: a3789e           mov word ptr [0x9e78], ax
  0573F7  1147: 8946d0           mov word ptr [bp - 0x30], ax
  0573FA  114A: eb24             jmp 0x1170
  0573FC  114C: 8a46d0           mov al, byte ptr [bp - 0x30]
  0573FF  114F: 8b76d0           mov si, word ptr [bp - 0x30]
  057402  1152: 8842d6           mov byte ptr [bp + si - 0x2a], al
  057405  1155: 8b46b4           mov ax, word ptr [bp - 0x4c]
  057408  1158: 2d0a00           sub ax, 0xa
  05740B  115B: d1e6             shl si, 1
  05740D  115D: 8b1e4285         mov bx, word ptr [0x8542]
  057411  1161: 39809a00         cmp word ptr [bx + si + 0x9a], ax
  057415  1165: 7e06             jle 0x116d
  057417  1167: c784789e0100     mov word ptr [si - 0x6188], 1
  05741D  116D: ff46d0           inc word ptr [bp - 0x30]
  057420  1170: 837ed010         cmp word ptr [bp - 0x30], 0x10
  057424  1174: 7cd6             jl 0x114c
  057426  1176: 8d46d6           lea ax, [bp - 0x2a]
  057429  1179: 16               push ss
  05742A  117A: 50               push ax
  05742B  117B: 1e               push ds
  05742C  117C: 68789e           push 0x9e78
  05742F  117F: b81000           mov ax, 0x10
  057432  1182: 9ad00e1f19       lcall 0x191f, 0xed0
  057437  1187: 6a03             push 3
  057439  1189: 6a01             push 1
  05743B  118B: 9ad4041f18       lcall 0x181f, 0x4d4
  057440  1190: 83c404           add sp, 4
  057443  1193: 8946f4           mov word ptr [bp - 0xc], ax
  057446  1196: c746fe0100       mov word ptr [bp - 2], 1
  05744B  119B: 8d5ee6           lea bx, [bp - 0x1a]
  05744E  119E: 2b5ef4           sub bx, word ptr [bp - 0xc]
  057451  11A1: 8a07             mov al, byte ptr [bx]
  057453  11A3: 98               cwde 
  057454  11A4: 8946c2           mov word ptr [bp - 0x3e], ax
  057457  11A7: 3d0700           cmp ax, 7
  05745A  11AA: 750f             jne 0x11bb
  05745C  11AC: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  057460  11B0: 807f0202         cmp byte ptr [bx + 2], 2
  057464  11B4: 7305             jae 0x11bb
  057466  11B6: c746fe0000       mov word ptr [bp - 2], 0
  05746B  11BB: 0bc0             or ax, ax
  05746D  11BD: 7503             jne 0x11c2
  05746F  11BF: 8946fe           mov word ptr [bp - 2], ax
  057472  11C2: 837efe00         cmp word ptr [bp - 2], 0
  057476  11C6: 7503             jne 0x11cb
  057478  11C8: ff46f4           inc word ptr [bp - 0xc]
  05747B  11CB: 837efe00         cmp word ptr [bp - 2], 0
  05747F  11CF: 74c5             je 0x1196
  057481  11D1: b86400           mov ax, 0x64
  057484  11D4: 8b1e4285         mov bx, word ptr [0x8542]
  057488  11D8: 8a4f1a           mov cl, byte ptr [bx + 0x1a]
  05748B  11DB: 2aed             sub ch, ch
  05748D  11DD: 8bf1             mov si, cx
  05748F  11DF: c1e604           shl si, 4
  057492  11E2: 8b5ec2           mov bx, word ptr [bp - 0x3e]
  057495  11E5: 8a88bc84         mov cl, byte ptr [bx + si - 0x7b44]
  057499  11E9: 41               inc cx
  05749A  11EA: 99               cdq 
  05749B  11EB: f7f9             idiv cx
  05749D  11ED: be989e           mov si, 0x9e98
  0574A0  11F0: 8b4ef4           mov cx, word ptr [bp - 0xc]
  0574A3  11F3: d1e1             shl cx, 1
  0574A5  11F5: 2bf1             sub si, cx
  0574A7  11F7: 8b0c             mov cx, word ptr [si]
  0574A9  11F9: 83c105           add cx, 5
  0574AC  11FC: 3bc1             cmp ax, cx
  0574AE  11FE: 7e02             jle 0x1202
  0574B0  1200: 8bc1             mov ax, cx
  0574B2  1202: 3d6400           cmp ax, 0x64
  0574B5  1205: 7e03             jle 0x120a
  0574B7  1207: b86400           mov ax, 0x64
  0574BA  120A: 3d0500           cmp ax, 5
  0574BD  120D: 7d03             jge 0x1212
  0574BF  120F: b80500           mov ax, 5
  0574C2  1212: 8b4eb4           mov cx, word ptr [bp - 0x4c]
  0574C5  1215: 8bf3             mov si, bx
  0574C7  1217: d1e6             shl si, 1
  0574C9  1219: 8b1e4285         mov bx, word ptr [0x8542]
  0574CD  121D: 2b889a00         sub cx, word ptr [bx + si + 0x9a]
  0574D1  1221: 3bc1             cmp ax, cx
  0574D3  1223: 7e02             jle 0x1227
  0574D5  1225: 8bc1             mov ax, cx
  0574D7  1227: 3d0200           cmp ax, 2
  0574DA  122A: 7d03             jge 0x122f
  0574DC  122C: b80200           mov ax, 2
  0574DF  122F: 8946b2           mov word ptr [bp - 0x4e], ax
  0574E2  1232: 8d4702           lea ax, [bx + 2]
  0574E5  1235: 1e               push ds
  0574E6  1236: 50               push ax
  0574E7  1237: 6a01             push 1
  0574E9  1239: 9a16041f18       lcall 0x181f, 0x416
  0574EE  123E: 83c406           add sp, 6
  0574F1  1241: 8b46b2           mov ax, word ptr [bp - 0x4e]
  0574F4  1244: 99               cdq 
  0574F5  1245: 52               push dx
  0574F6  1246: 50               push ax
  0574F7  1247: 6a00             push 0
  0574F9  1249: 9aae091f18       lcall 0x181f, 0x9ae
  0574FE  124E: 83c406           add sp, 6
  057501  1251: ffb4c097         push word ptr [si - 0x6840]
  057505  1255: 6a02             push 2
  057507  1257: 9a38041f18       lcall 0x181f, 0x438
  05750C  125C: 83c404           add sp, 4
  05750F  125F: 8b46b2           mov ax, word ptr [bp - 0x4e]
  057512  1262: 8b1e4285         mov bx, word ptr [0x8542]
  057516  1266: 01809a00         add word ptr [bx + si + 0x9a], ax
  05751A  126A: 837e0604         cmp word ptr [bp + 6], 4
  05751E  126E: 7c03             jl 0x1273
  057520  1270: e9ed04           jmp 0x1760
  057523  1273: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  057527  1277: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05752C  127C: 7403             je 0x1281
  05752E  127E: e9df04           jmp 0x1760
  057531  1281: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  057535  1285: 8a874531         mov al, byte ptr [bx + 0x3145]
  057539  1289: 2ae4             sub ah, ah
  05753B  128B: 50               push ax
  05753C  128C: 8a874431         mov al, byte ptr [bx + 0x3144]
  057540  1290: 50               push ax
  057541  1291: 9a9a0d1f18       lcall 0x181f, 0xd9a
  057546  1296: 83c404           add sp, 4
  057549  1299: ff36528d         push word ptr [0x8d52]
  05754D  129D: 684818           push 0x1848
  057550  12A0: 9a9c011f19       lcall 0x191f, 0x19c
  057555  12A5: 83c404           add sp, 4
  057558  12A8: e9b504           jmp 0x1760
  05755B  12AB: 90               nop 
  05755C  12AC: 837eb600         cmp word ptr [bp - 0x4a], 0
  057560  12B0: 7d03             jge 0x12b5
  057562  12B2: e91903           jmp 0x15ce
  057565  12B5: ff76b6           push word ptr [bp - 0x4a]
  057568  12B8: 9ae6091f18       lcall 0x181f, 0x9e6
  05756D  12BD: 83c402           add sp, 2
  057570  12C0: c746c2ffff       mov word ptr [bp - 0x3e], 0xffff
  057575  12C5: 2bc0             sub ax, ax
  057577  12C7: 8946bc           mov word ptr [bp - 0x44], ax
  05757A  12CA: 8946d0           mov word ptr [bp - 0x30], ax
  05757D  12CD: e98b00           jmp 0x135b
  057580  12D0: 8b76d0           mov si, word ptr [bp - 0x30]
  057583  12D3: d1e6             shl si, 1
  057585  12D5: 8b1e4285         mov bx, word ptr [0x8542]
  057589  12D9: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  05758D  12DD: 3d6400           cmp ax, 0x64
  057590  12E0: 7e03             jle 0x12e5
  057592  12E2: b86400           mov ax, 0x64
  057595  12E5: 8946ea           mov word ptr [bp - 0x16], ax
  057598  12E8: 8b7606           mov si, word ptr [bp + 6]
  05759B  12EB: c1e604           shl si, 4
  05759E  12EE: 8b5ed0           mov bx, word ptr [bp - 0x30]
  0575A1  12F1: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  0575A5  12F5: 2ae4             sub ah, ah
  0575A7  12F7: 8946ee           mov word ptr [bp - 0x12], ax
  0575AA  12FA: 83fb08           cmp bx, 8
  0575AD  12FD: 7513             jne 0x1312
  0575AF  12FF: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0575B3  1303: 8a4708           mov al, byte ptr [bx + 8]
  0575B6  1306: 98               cwde 
  0575B7  1307: 2b46ee           sub ax, word ptr [bp - 0x12]
  0575BA  130A: f7d8             neg ax
  0575BC  130C: 050a00           add ax, 0xa
  0575BF  130F: 8946ee           mov word ptr [bp - 0x12], ax
  0575C2  1312: 837ed00f         cmp word ptr [bp - 0x30], 0xf
  0575C6  1316: 7523             jne 0x133b
  0575C8  1318: 6a04             push 4
  0575CA  131A: 6a01             push 1
  0575CC  131C: 9ad4041f18       lcall 0x181f, 0x4d4
  0575D1  1321: 83c404           add sp, 4
  0575D4  1324: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0575D8  1328: 8a4f02           mov cl, byte ptr [bx + 2]
  0575DB  132B: 2aed             sub ch, ch
  0575DD  132D: 2bc1             sub ax, cx
  0575DF  132F: 8a0ea653         mov cl, byte ptr [0x53a6]
  0575E3  1333: 03c1             add ax, cx
  0575E5  1335: 050400           add ax, 4
  0575E8  1338: 0146ee           add word ptr [bp - 0x12], ax
  0575EB  133B: 8b46ee           mov ax, word ptr [bp - 0x12]
  0575EE  133E: f76eea           imul word ptr [bp - 0x16]
  0575F1  1341: 8946ec           mov word ptr [bp - 0x14], ax
  0575F4  1344: 3b46bc           cmp ax, word ptr [bp - 0x44]
  0575F7  1347: 7e0f             jle 0x1358
  0575F9  1349: 8946bc           mov word ptr [bp - 0x44], ax
  0575FC  134C: 8b46d0           mov ax, word ptr [bp - 0x30]
  0575FF  134F: 8946c2           mov word ptr [bp - 0x3e], ax
  057602  1352: 8b46ea           mov ax, word ptr [bp - 0x16]
  057605  1355: 8946b2           mov word ptr [bp - 0x4e], ax
  057608  1358: ff46d0           inc word ptr [bp - 0x30]
  05760B  135B: 837ed010         cmp word ptr [bp - 0x30], 0x10
  05760F  135F: 7d03             jge 0x1364
  057611  1361: e96cff           jmp 0x12d0
  057614  1364: 837ec200         cmp word ptr [bp - 0x3e], 0
  057618  1368: 7d03             jge 0x136d
  05761A  136A: e9dd01           jmp 0x154a
  05761D  136D: 8b7606           mov si, word ptr [bp + 6]
  057620  1370: d1e6             shl si, 1
  057622  1372: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  057626  1376: c7402e0100       mov word ptr [bx + si + 0x2e], 1
  05762B  137B: a0a653           mov al, byte ptr [0x53a6]
  05762E  137E: 2ae4             sub ah, ah
  057630  1380: 40               inc ax
  057631  1381: 50               push ax
  057632  1382: 6a00             push 0
  057634  1384: 9ad4041f18       lcall 0x181f, 0x4d4
  057639  1389: 83c404           add sp, 4
  05763C  138C: 0bc0             or ax, ax
  05763E  138E: 7503             jne 0x1393
  057640  1390: d17eb2           sar word ptr [bp - 0x4e], 1
  057643  1393: ff7606           push word ptr [bp + 6]
  057646  1396: 9aa4091f18       lcall 0x181f, 0x9a4
  05764B  139B: 83c402           add sp, 2
  05764E  139E: 50               push ax
  05764F  139F: 6a00             push 0
  057651  13A1: 9a38041f18       lcall 0x181f, 0x438
  057656  13A6: 83c404           add sp, 4
  057659  13A9: ff7608           push word ptr [bp + 8]
  05765C  13AC: 9aa4091f18       lcall 0x181f, 0x9a4
  057661  13B1: 83c402           add sp, 2
  057664  13B4: 50               push ax
  057665  13B5: 6a01             push 1
  057667  13B7: 9a38041f18       lcall 0x181f, 0x438
  05766C  13BC: 83c404           add sp, 4
  05766F  13BF: 8b5ec2           mov bx, word ptr [bp - 0x3e]
  057672  13C2: d1e3             shl bx, 1
  057674  13C4: ffb7c097         push word ptr [bx - 0x6840]
  057678  13C8: 6a02             push 2
  05767A  13CA: 9a38041f18       lcall 0x181f, 0x438
  05767F  13CF: 83c404           add sp, 4
  057682  13D2: a14285           mov ax, word ptr [0x8542]
  057685  13D5: 40               inc ax
  057686  13D6: 40               inc ax
  057687  13D7: 1e               push ds
  057688  13D8: 50               push ax
  057689  13D9: 6a03             push 3
  05768B  13DB: 9a16041f18       lcall 0x181f, 0x416
  057690  13E0: 83c406           add sp, 6
  057693  13E3: 8b46b2           mov ax, word ptr [bp - 0x4e]
  057696  13E6: 99               cdq 
  057697  13E7: 52               push dx
  057698  13E8: 50               push ax
  057699  13E9: 6a00             push 0
  05769B  13EB: 9aae091f18       lcall 0x181f, 0x9ae
  0576A0  13F0: 83c406           add sp, 6
  0576A3  13F3: 837e0604         cmp word ptr [bp + 6], 4
  0576A7  13F7: 7d5f             jge 0x1458
  0576A9  13F9: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  0576AD  13FD: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  0576B2  1402: 7554             jne 0x1458
  0576B4  1404: c746e60500       mov word ptr [bp - 0x1a], 5
  0576B9  1409: 833e528d00       cmp word ptr [0x8d52], 0
  0576BE  140E: 7505             jne 0x1415
  0576C0  1410: c746e60700       mov word ptr [bp - 0x1a], 7
  0576C5  1415: 833e528d01       cmp word ptr [0x8d52], 1
  0576CA  141A: 7505             jne 0x1421
  0576CC  141C: c746e60600       mov word ptr [bp - 0x1a], 6
  0576D1  1421: ff76e6           push word ptr [bp - 0x1a]
  0576D4  1424: 9aac041f18       lcall 0x181f, 0x4ac
  0576D9  1429: 83c402           add sp, 2
  0576DC  142C: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  0576E0  1430: 8a874531         mov al, byte ptr [bx + 0x3145]
  0576E4  1434: 2ae4             sub ah, ah
  0576E6  1436: 50               push ax
  0576E7  1437: 8a874431         mov al, byte ptr [bx + 0x3144]
  0576EB  143B: 50               push ax
  0576EC  143C: 9a9a0d1f18       lcall 0x181f, 0xd9a
  0576F1  1441: 83c404           add sp, 4
  0576F4  1444: ff36528d         push word ptr [0x8d52]
  0576F8  1448: 686618           push 0x1866
  0576FB  144B: 9a9c011f19       lcall 0x191f, 0x19c
  057700  1450: 83c404           add sp, 4
  057703  1453: 8946f6           mov word ptr [bp - 0xa], ax
  057706  1456: eb2f             jmp 0x1487
  057708  1458: c746f60200       mov word ptr [bp - 0xa], 2
  05770D  145D: 837ec20f         cmp word ptr [bp - 0x3e], 0xf
  057711  1461: 7505             jne 0x1468
  057713  1463: c746f60100       mov word ptr [bp - 0xa], 1
  057718  1468: 6a0a             push 0xa
  05771A  146A: 8b46f8           mov ax, word ptr [bp - 8]
  05771D  146D: 8b56f0           mov dx, word ptr [bp - 0x10]
  057720  1470: 9ae0071f18       lcall 0x181f, 0x7e0
  057725  1475: 50               push ax
  057726  1476: 9abc081f18       lcall 0x181f, 0x8bc
  05772B  147B: 83c404           add sp, 4
  05772E  147E: 0bc0             or ax, ax
  057730  1480: 7405             je 0x1487
  057732  1482: c746f60100       mov word ptr [bp - 0xa], 1
  057737  1487: 837ef602         cmp word ptr [bp - 0xa], 2
  05773B  148B: 7403             je 0x1490
  05773D  148D: e9c202           jmp 0x1752
  057740  1490: 8b7606           mov si, word ptr [bp + 6]
  057743  1493: d1e6             shl si, 1
  057745  1495: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  057749  1499: c7400a0000       mov word ptr [bx + si + 0xa], 0
  05774E  149E: 8b46bc           mov ax, word ptr [bp - 0x44]
  057751  14A1: c1e002           shl ax, 2
  057754  14A4: b99cff           mov cx, 0xff9c
  057757  14A7: 99               cdq 
  057758  14A8: f7f9             idiv cx
  05775A  14AA: 8946fa           mov word ptr [bp - 6], ax
  05775D  14AD: eb05             jmp 0x14b4
  05775F  14AF: 90               nop 
  057760  14B0: 836efa05         sub word ptr [bp - 6], 5
  057764  14B4: ff7606           push word ptr [bp + 6]
  057767  14B7: ff36528d         push word ptr [0x8d52]
  05776B  14BB: 9a0c031f18       lcall 0x181f, 0x30c
  057770  14C0: 83c404           add sp, 4
  057773  14C3: 0346fa           add ax, word ptr [bp - 6]
  057776  14C6: 3d4600           cmp ax, 0x46
  057779  14C9: 7fe5             jg 0x14b0
  05777B  14CB: 6a00             push 0
  05777D  14CD: ff76fa           push word ptr [bp - 6]
  057780  14D0: ff7606           push word ptr [bp + 6]
  057783  14D3: ff36528d         push word ptr [0x8d52]
  057787  14D7: 9a6c0d1f18       lcall 0x181f, 0xd6c
  05778C  14DC: 83c408           add sp, 8
  05778F  14DF: 8b46b2           mov ax, word ptr [bp - 0x4e]
  057792  14E2: 8b76c2           mov si, word ptr [bp - 0x3e]
  057795  14E5: d1e6             shl si, 1
  057797  14E7: 8b1e4285         mov bx, word ptr [0x8542]
  05779B  14EB: 29809a00         sub word ptr [bx + si + 0x9a], ax
  05779F  14EF: 837ec20f         cmp word ptr [bp - 0x3e], 0xf
  0577A3  14F3: 7520             jne 0x1515
  0577A5  14F5: ff760a           push word ptr [bp + 0xa]
  0577A8  14F8: 9a02091f18       lcall 0x181f, 0x902
  0577AD  14FD: 83c402           add sp, 2
  0577B0  1500: 0bc0             or ax, ax
  0577B2  1502: 750a             jne 0x150e
  0577B4  1504: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  0577B8  1508: fe874631         inc byte ptr [bx + 0x3146]
  0577BC  150C: eb07             jmp 0x1515
  0577BE  150E: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0577C2  1512: fe4707           inc byte ptr [bx + 7]
  0577C5  1515: 837ec208         cmp word ptr [bp - 0x3e], 8
  0577C9  1519: 7403             je 0x151e
  0577CB  151B: e94202           jmp 0x1760
  0577CE  151E: ff760a           push word ptr [bp + 0xa]
  0577D1  1521: 9ad0081f18       lcall 0x181f, 0x8d0
  0577D6  1526: 83c402           add sp, 2
  0577D9  1529: 0bc0             or ax, ax
  0577DB  152B: 750b             jne 0x1538
  0577DD  152D: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  0577E1  1531: 8087463102       add byte ptr [bx + 0x3146], 2
  0577E6  1536: eb08             jmp 0x1540
  0577E8  1538: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0577EC  153C: 83470a32         add word ptr [bx + 0xa], 0x32
  0577F0  1540: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0577F4  1544: fe4708           inc byte ptr [bx + 8]
  0577F7  1547: e91602           jmp 0x1760
  0577FA  154A: c746b6ffff       mov word ptr [bp - 0x4a], 0xffff
  0577FF  154F: 8b7606           mov si, word ptr [bp + 6]
  057802  1552: d1e6             shl si, 1
  057804  1554: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  057808  1558: 83782e02         cmp word ptr [bx + si + 0x2e], 2
  05780C  155C: 7412             je 0x1570
  05780E  155E: 837eb600         cmp word ptr [bp - 0x4a], 0
  057812  1562: 7c03             jl 0x1567
  057814  1564: e945fd           jmp 0x12ac
  057817  1567: 837ec000         cmp word ptr [bp - 0x40], 0
  05781B  156B: 7c03             jl 0x1570
  05781D  156D: e93cfd           jmp 0x12ac
  057820  1570: 837e0604         cmp word ptr [bp + 6], 4
  057824  1574: 7d46             jge 0x15bc
  057826  1576: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  05782A  157A: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05782F  157F: 753b             jne 0x15bc
  057831  1581: ff7608           push word ptr [bp + 8]
  057834  1584: 9aa4091f18       lcall 0x181f, 0x9a4
  057839  1589: 83c402           add sp, 2
  05783C  158C: 50               push ax
  05783D  158D: 6a00             push 0
  05783F  158F: 9a38041f18       lcall 0x181f, 0x438
  057844  1594: 83c404           add sp, 4
  057847  1597: ff7606           push word ptr [bp + 6]
  05784A  159A: 9a1a0a1f18       lcall 0x181f, 0xa1a
  05784F  159F: 83c402           add sp, 2
  057852  15A2: 50               push ax
  057853  15A3: 6a01             push 1
  057855  15A5: 9a38041f18       lcall 0x181f, 0x438
  05785A  15AA: 83c404           add sp, 4
  05785D  15AD: ff36528d         push word ptr [0x8d52]
  057861  15B1: 685818           push 0x1858
  057864  15B4: 9a9c011f19       lcall 0x191f, 0x19c
  057869  15B9: 83c404           add sp, 4
  05786C  15BC: 8b7606           mov si, word ptr [bp + 6]
  05786F  15BF: d1e6             shl si, 1
  057871  15C1: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  057875  15C5: c7400a0000       mov word ptr [bx + si + 0xa], 0
  05787A  15CA: e99801           jmp 0x1765
  05787D  15CD: 90               nop 
  05787E  15CE: 837ec000         cmp word ptr [bp - 0x40], 0
  057882  15D2: 7d03             jge 0x15d7
  057884  15D4: e98e01           jmp 0x1765
  057887  15D7: 8b7606           mov si, word ptr [bp + 6]
  05788A  15DA: d1e6             shl si, 1
  05788C  15DC: c7402e0100       mov word ptr [bx + si + 0x2e], 1
  057891  15E1: 6a00             push 0
  057893  15E3: ff76c0           push word ptr [bp - 0x40]
  057896  15E6: 9ae60b1f18       lcall 0x181f, 0xbe6
  05789B  15EB: 83c404           add sp, 4
  05789E  15EE: 8946c2           mov word ptr [bp - 0x3e], ax
  0578A1  15F1: 6a00             push 0
  0578A3  15F3: ff76c0           push word ptr [bp - 0x40]
  0578A6  15F6: 9a680c1f18       lcall 0x181f, 0xc68
  0578AB  15FB: 83c404           add sp, 4
  0578AE  15FE: 8946b2           mov word ptr [bp - 0x4e], ax
  0578B1  1601: ff7606           push word ptr [bp + 6]
  0578B4  1604: 9aa4091f18       lcall 0x181f, 0x9a4
  0578B9  1609: 83c402           add sp, 2
  0578BC  160C: 50               push ax
  0578BD  160D: 6a00             push 0
  0578BF  160F: 9a38041f18       lcall 0x181f, 0x438
  0578C4  1614: 83c404           add sp, 4
  0578C7  1617: ff7608           push word ptr [bp + 8]
  0578CA  161A: 9aa4091f18       lcall 0x181f, 0x9a4
  0578CF  161F: 83c402           add sp, 2
  0578D2  1622: 50               push ax
  0578D3  1623: 6a01             push 1
  0578D5  1625: 9a38041f18       lcall 0x181f, 0x438
  0578DA  162A: 83c404           add sp, 4
  0578DD  162D: 8b5ec2           mov bx, word ptr [bp - 0x3e]
  0578E0  1630: d1e3             shl bx, 1
  0578E2  1632: ffb7c097         push word ptr [bx - 0x6840]
  0578E6  1636: 6a02             push 2
  0578E8  1638: 9a38041f18       lcall 0x181f, 0x438
  0578ED  163D: 83c404           add sp, 4
  0578F0  1640: 8b46b2           mov ax, word ptr [bp - 0x4e]
  0578F3  1643: 99               cdq 
  0578F4  1644: 52               push dx
  0578F5  1645: 50               push ax
  0578F6  1646: 6a00             push 0
  0578F8  1648: 9aae091f18       lcall 0x181f, 0x9ae
  0578FD  164D: 83c406           add sp, 6
  057900  1650: 837e0604         cmp word ptr [bp + 6], 4
  057904  1654: 7c03             jl 0x1659
  057906  1656: e9a300           jmp 0x16fc
  057909  1659: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  05790D  165D: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  057912  1662: 7403             je 0x1667
  057914  1664: e99500           jmp 0x16fc
  057917  1667: c746e60500       mov word ptr [bp - 0x1a], 5
  05791C  166C: 833e528d00       cmp word ptr [0x8d52], 0
  057921  1671: 7505             jne 0x1678
  057923  1673: c746e60700       mov word ptr [bp - 0x1a], 7
  057928  1678: 833e528d01       cmp word ptr [0x8d52], 1
  05792D  167D: 7505             jne 0x1684
  05792F  167F: c746e60600       mov word ptr [bp - 0x1a], 6
  057934  1684: ff76e6           push word ptr [bp - 0x1a]
  057937  1687: 9aac041f18       lcall 0x181f, 0x4ac
  05793C  168C: 83c402           add sp, 2
  05793F  168F: 6a00             push 0
  057941  1691: ff76f0           push word ptr [bp - 0x10]
  057944  1694: ff76f8           push word ptr [bp - 8]
  057947  1697: 9a080e1f18       lcall 0x181f, 0xe08
  05794C  169C: 83c406           add sp, 6
  05794F  169F: ff76f0           push word ptr [bp - 0x10]
  057952  16A2: ff76f8           push word ptr [bp - 8]
  057955  16A5: ff76ce           push word ptr [bp - 0x32]
  057958  16A8: ff76d4           push word ptr [bp - 0x2c]
  05795B  16AB: 6aff             push -1
  05795D  16AD: 68c000           push 0xc0
  057960  16B0: ff76c4           push word ptr [bp - 0x3c]
  057963  16B3: 9ad0021f18       lcall 0x181f, 0x2d0
  057968  16B8: 83c40e           add sp, 0xe
  05796B  16BB: 6a01             push 1
  05796D  16BD: 6a02             push 2
  05796F  16BF: 6a02             push 2
  057971  16C1: ff76f0           push word ptr [bp - 0x10]
  057974  16C4: ff76f8           push word ptr [bp - 8]
  057977  16C7: 9aba091f18       lcall 0x181f, 0x9ba
  05797C  16CC: 83c40a           add sp, 0xa
  05797F  16CF: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  057983  16D3: 8a874531         mov al, byte ptr [bx + 0x3145]
  057987  16D7: 2ae4             sub ah, ah
  057989  16D9: 50               push ax
  05798A  16DA: 8a874431         mov al, byte ptr [bx + 0x3144]
  05798E  16DE: 50               push ax
  05798F  16DF: 9a9a0d1f18       lcall 0x181f, 0xd9a
  057994  16E4: 83c404           add sp, 4
  057997  16E7: ff36528d         push word ptr [0x8d52]
  05799B  16EB: 687118           push 0x1871
  05799E  16EE: 9a9c011f19       lcall 0x191f, 0x19c
  0579A3  16F3: 83c404           add sp, 4
  0579A6  16F6: 8946f6           mov word ptr [bp - 0xa], ax
  0579A9  16F9: eb06             jmp 0x1701
  0579AB  16FB: 90               nop 
  0579AC  16FC: c746f60100       mov word ptr [bp - 0xa], 1
  0579B1  1701: 837ef601         cmp word ptr [bp - 0xa], 1
  0579B5  1705: 754b             jne 0x1752
  0579B7  1707: 8b7606           mov si, word ptr [bp + 6]
  0579BA  170A: c1e604           shl si, 4
  0579BD  170D: 8b5ec2           mov bx, word ptr [bp - 0x3e]
  0579C0  1710: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  0579C4  1714: 2ae4             sub ah, ah
  0579C6  1716: f76eb2           imul word ptr [bp - 0x4e]
  0579C9  1719: c1e002           shl ax, 2
  0579CC  171C: b99cff           mov cx, 0xff9c
  0579CF  171F: 99               cdq 
  0579D0  1720: f7f9             idiv cx
  0579D2  1722: 8946fa           mov word ptr [bp - 6], ax
  0579D5  1725: 2bc9             sub cx, cx
  0579D7  1727: 8b7606           mov si, word ptr [bp + 6]
  0579DA  172A: d1e6             shl si, 1
  0579DC  172C: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  0579E0  1730: 89480a           mov word ptr [bx + si + 0xa], cx
  0579E3  1733: 51               push cx
  0579E4  1734: 50               push ax
  0579E5  1735: ff7606           push word ptr [bp + 6]
  0579E8  1738: ff36528d         push word ptr [0x8d52]
  0579EC  173C: 9a6c0d1f18       lcall 0x181f, 0xd6c
  0579F1  1741: 83c408           add sp, 8
  0579F4  1744: 6a00             push 0
  0579F6  1746: ff76c0           push word ptr [bp - 0x40]
  0579F9  1749: 9aec0a1f18       lcall 0x181f, 0xaec
  0579FE  174E: e954fb           jmp 0x12a5
  057A01  1751: 90               nop 
  057A02  1752: 8b7606           mov si, word ptr [bp + 6]
  057A05  1755: d1e6             shl si, 1
  057A07  1757: 8b1e4a8d         mov bx, word ptr [0x8d4a]
  057A0B  175B: 81400a8000       add word ptr [bx + si + 0xa], 0x80
  057A10  1760: c746e80100       mov word ptr [bp - 0x18], 1
  057A15  1765: 837ee800         cmp word ptr [bp - 0x18], 0
  057A19  1769: 7419             je 0x1784
  057A1B  176B: 6b5ec41c         imul bx, word ptr [bp - 0x3c], 0x1c
  057A1F  176F: 8a874731         mov al, byte ptr [bx + 0x3147]
  057A23  1773: 240f             and al, 0xf
  057A25  1775: 3c04             cmp al, 4
  057A27  1777: 720b             jb 0x1784
  057A29  1779: ff76c4           push word ptr [bp - 0x3c]
  057A2C  177C: 9a34091f18       lcall 0x181f, 0x934
  057A31  1781: 83c402           add sp, 2
  057A34  1784: 8b46e8           mov ax, word ptr [bp - 0x18]
  057A37  1787: 5e               pop si
  057A38  1788: c9               leave 
  057A39  1789: cb               retf 

; ---- func_057A3A  size=103  insns=36  prologue=ENTER 0x0054,0  terminal=RETF ----
  057A3A  178A: c8540000         enter 0x54, 0
  057A3E  178E: 687e18           push 0x187e
  057A41  1791: 8d46b0           lea ax, [bp - 0x50]
  057A44  1794: 8946ac           mov word ptr [bp - 0x54], ax
  057A47  1797: 50               push ax
  057A48  1798: 9ae4071d0d       lcall 0xd1d, 0x7e4
  057A4D  179D: 83c404           add sp, 4
  057A50  17A0: ff7608           push word ptr [bp + 8]
  057A53  17A3: 8d46b0           lea ax, [bp - 0x50]
  057A56  17A6: 50               push ax
  057A57  17A7: 9aa4071d0d       lcall 0xd1d, 0x7a4
  057A5C  17AC: 83c404           add sp, 4
  057A5F  17AF: 8d46b0           lea ax, [bp - 0x50]
  057A62  17B2: 50               push ax
  057A63  17B3: 687c08           push 0x87c
  057A66  17B6: 9a28091f19       lcall 0x191f, 0x928
  057A6B  17BB: 83c404           add sp, 4
  057A6E  17BE: 0bc0             or ax, ax
  057A70  17C0: 7519             jne 0x17db
  057A72  17C2: 8946ae           mov word ptr [bp - 0x52], ax
  057A75  17C5: eb0c             jmp 0x17d3
  057A77  17C7: 90               nop 
  057A78  17C8: 9a1c091f19       lcall 0x191f, 0x91c
  057A7D  17CD: 8946ac           mov word ptr [bp - 0x54], ax
  057A80  17D0: ff46ae           inc word ptr [bp - 0x52]
  057A83  17D3: 8b460a           mov ax, word ptr [bp + 0xa]
  057A86  17D6: 3946ae           cmp word ptr [bp - 0x52], ax
  057A89  17D9: 7eed             jle 0x17c8
  057A8B  17DB: 1e               push ds
  057A8C  17DC: ff76ac           push word ptr [bp - 0x54]
  057A8F  17DF: ff7606           push word ptr [bp + 6]
  057A92  17E2: 9a16041f18       lcall 0x181f, 0x416
  057A97  17E7: 83c406           add sp, 6
  057A9A  17EA: 9ab80f1f19       lcall 0x191f, 0xfb8
  057A9F  17EF: c9               leave 
  057AA0  17F0: cb               retf 

; ---- func_057AA2  size=89  insns=30  prologue=ENTER 0x0056,0  terminal=RETF ----
  057AA2  17F2: c8560000         enter 0x56, 0
  057AA6  17F6: 8d46b0           lea ax, [bp - 0x50]
  057AA9  17F9: 8946aa           mov word ptr [bp - 0x56], ax
  057AAC  17FC: 688418           push 0x1884
  057AAF  17FF: 687c08           push 0x87c
  057AB2  1802: 9a28091f19       lcall 0x191f, 0x928
  057AB7  1807: 83c404           add sp, 4
  057ABA  180A: 0bc0             or ax, ax
  057ABC  180C: 7527             jne 0x1835
  057ABE  180E: 837e0801         cmp word ptr [bp + 8], 1
  057AC2  1812: 1bc0             sbb ax, ax
  057AC4  1814: 250100           and ax, 1
  057AC7  1817: 40               inc ax
  057AC8  1818: 8946ae           mov word ptr [bp - 0x52], ax
  057ACB  181B: c746ac0000       mov word ptr [bp - 0x54], 0
  057AD0  1820: eb0b             jmp 0x182d
  057AD2  1822: 9a1c091f19       lcall 0x191f, 0x91c
  057AD7  1827: 8946aa           mov word ptr [bp - 0x56], ax
  057ADA  182A: ff46ac           inc word ptr [bp - 0x54]
  057ADD  182D: 8b46ac           mov ax, word ptr [bp - 0x54]
  057AE0  1830: 3946ae           cmp word ptr [bp - 0x52], ax
  057AE3  1833: 7fed             jg 0x1822
  057AE5  1835: 1e               push ds
  057AE6  1836: ff76aa           push word ptr [bp - 0x56]
  057AE9  1839: ff7606           push word ptr [bp + 6]
  057AEC  183C: 9a16041f18       lcall 0x181f, 0x416
  057AF1  1841: 83c406           add sp, 6
  057AF4  1844: 9ab80f1f19       lcall 0x191f, 0xfb8
  057AF9  1849: c9               leave 
  057AFA  184A: cb               retf 

; ---- func_057AFC  size=484  insns=172  prologue=ENTER 0x000C,0  terminal=RETF ----
  057AFC  184C: c80c0000         enter 0xc, 0
  057B00  1850: 56               push si
  057B01  1851: a09853           mov al, byte ptr [0x5398]
  057B04  1854: 380653a1         cmp byte ptr [0xa153], al
  057B08  1858: 7506             jne 0x1860
  057B0A  185A: 2bc0             sub ax, ax
  057B0C  185C: 5e               pop si
  057B0D  185D: c9               leave 
  057B0E  185E: cb               retf 
  057B0F  185F: 90               nop 
  057B10  1860: 833e8e5328       cmp word ptr [0x538e], 0x28
  057B15  1865: 7cf3             jl 0x185a
  057B17  1867: 8b5e06           mov bx, word ptr [bp + 6]
  057B1A  186A: 80bf0c9408       cmp byte ptr [bx - 0x6bf4], 8
  057B1F  186F: 730a             jae 0x187b
  057B21  1871: 8b5e08           mov bx, word ptr [bp + 8]
  057B24  1874: 80bf0c9408       cmp byte ptr [bx - 0x6bf4], 8
  057B29  1879: 72df             jb 0x185a
  057B2B  187B: a19853           mov ax, word ptr [0x5398]
  057B2E  187E: 8946f4           mov word ptr [bp - 0xc], ax
  057B31  1881: 695e063c01       imul bx, word ptr [bp + 6], 0x13c
  057B36  1886: f687088804       test byte ptr [bx - 0x77f8], 4
  057B3B  188B: 75cd             jne 0x185a
  057B3D  188D: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  057B42  1892: f687088804       test byte ptr [bx - 0x77f8], 4
  057B47  1897: 75c1             jne 0x185a
  057B49  1899: 50               push ax
  057B4A  189A: ff7606           push word ptr [bp + 6]
  057B4D  189D: 9a380a1f18       lcall 0x181f, 0xa38
  057B52  18A2: 83c404           add sp, 4
  057B55  18A5: 2460             and al, 0x60
  057B57  18A7: 3c20             cmp al, 0x20
  057B59  18A9: 7524             jne 0x18cf
  057B5B  18AB: 8b5e06           mov bx, word ptr [bp + 6]
  057B5E  18AE: d1e3             shl bx, 1
  057B60  18B0: 8b871c94         mov ax, word ptr [bx - 0x6be4]
  057B64  18B4: 8b5ef4           mov bx, word ptr [bp - 0xc]
  057B67  18B7: d1e3             shl bx, 1
  057B69  18B9: 39871c94         cmp word ptr [bx - 0x6be4], ax
  057B6D  18BD: 779b             ja 0x185a
  057B6F  18BF: 8b5e06           mov bx, word ptr [bp + 6]
  057B72  18C2: 8a871094         mov al, byte ptr [bx - 0x6bf0]
  057B76  18C6: 8b5ef4           mov bx, word ptr [bp - 0xc]
  057B79  18C9: 38871094         cmp byte ptr [bx - 0x6bf0], al
  057B7D  18CD: 778b             ja 0x185a
  057B7F  18CF: ff76f4           push word ptr [bp - 0xc]
  057B82  18D2: ff7608           push word ptr [bp + 8]
  057B85  18D5: 9a380a1f18       lcall 0x181f, 0xa38
  057B8A  18DA: 83c404           add sp, 4
  057B8D  18DD: 2460             and al, 0x60
  057B8F  18DF: 3c20             cmp al, 0x20
  057B91  18E1: 752a             jne 0x190d
  057B93  18E3: 8b5e08           mov bx, word ptr [bp + 8]
  057B96  18E6: d1e3             shl bx, 1
  057B98  18E8: 8b871c94         mov ax, word ptr [bx - 0x6be4]
  057B9C  18EC: 8b5ef4           mov bx, word ptr [bp - 0xc]
  057B9F  18EF: d1e3             shl bx, 1
  057BA1  18F1: 39871c94         cmp word ptr [bx - 0x6be4], ax
  057BA5  18F5: 7603             jbe 0x18fa
  057BA7  18F7: e960ff           jmp 0x185a
  057BAA  18FA: 8b5e06           mov bx, word ptr [bp + 6]
  057BAD  18FD: 8a871094         mov al, byte ptr [bx - 0x6bf0]
  057BB1  1901: 8b5ef4           mov bx, word ptr [bp - 0xc]
  057BB4  1904: 38871094         cmp byte ptr [bx - 0x6bf0], al
  057BB8  1908: 7603             jbe 0x190d
  057BBA  190A: e94dff           jmp 0x185a
  057BBD  190D: 2bc0             sub ax, ax
  057BBF  190F: 8946f6           mov word ptr [bp - 0xa], ax
  057BC2  1912: 8946f8           mov word ptr [bp - 8], ax
  057BC5  1915: eb2b             jmp 0x1942
  057BC7  1917: 90               nop 
  057BC8  1918: 8b4606           mov ax, word ptr [bp + 6]
  057BCB  191B: 3946f8           cmp word ptr [bp - 8], ax
  057BCE  191E: 741f             je 0x193f
  057BD0  1920: 8b4608           mov ax, word ptr [bp + 8]
  057BD3  1923: 3946f8           cmp word ptr [bp - 8], ax
  057BD6  1926: 7417             je 0x193f
  057BD8  1928: ff76f8           push word ptr [bp - 8]
  057BDB  192B: ff7606           push word ptr [bp + 6]
  057BDE  192E: 9a380a1f18       lcall 0x181f, 0xa38
  057BE3  1933: 83c404           add sp, 4
  057BE6  1936: 2460             and al, 0x60
  057BE8  1938: 3c20             cmp al, 0x20
  057BEA  193A: 7503             jne 0x193f
  057BEC  193C: ff46f6           inc word ptr [bp - 0xa]
  057BEF  193F: ff46f8           inc word ptr [bp - 8]
  057BF2  1942: 837ef804         cmp word ptr [bp - 8], 4
  057BF6  1946: 7cd0             jl 0x1918
  057BF8  1948: ff7608           push word ptr [bp + 8]
  057BFB  194B: ff7606           push word ptr [bp + 6]
  057BFE  194E: 9a380a1f18       lcall 0x181f, 0xa38
  057C03  1953: 83c404           add sp, 4
  057C06  1956: 2460             and al, 0x60
  057C08  1958: 3c20             cmp al, 0x20
  057C0A  195A: 7403             je 0x195f
  057C0C  195C: ff46f6           inc word ptr [bp - 0xa]
  057C0F  195F: 8b5e06           mov bx, word ptr [bp + 6]
  057C12  1962: 8bc3             mov ax, bx
  057C14  1964: d1e3             shl bx, 1
  057C16  1966: 03d8             add bx, ax
  057C18  1968: 8a876695         mov al, byte ptr [bx - 0x6a9a]
  057C1C  196C: 98               cwde 
  057C1D  196D: 2946f6           sub word ptr [bp - 0xa], ax
  057C20  1970: 2bc0             sub ax, ax
  057C22  1972: 8946fe           mov word ptr [bp - 2], ax
  057C25  1975: 8946fa           mov word ptr [bp - 6], ax
  057C28  1978: b80100           mov ax, 1
  057C2B  197B: 8946fc           mov word ptr [bp - 4], ax
  057C2E  197E: 8946f8           mov word ptr [bp - 8], ax
  057C31  1981: e98000           jmp 0x1a04
  057C34  1984: 8b5e06           mov bx, word ptr [bp + 6]
  057C37  1987: c1e304           shl bx, 4
  057C3A  198A: 035ef8           add bx, word ptr [bp - 8]
  057C3D  198D: 80bfe69400       cmp byte ptr [bx - 0x6b1a], 0
  057C42  1992: 7426             je 0x19ba
  057C44  1994: 8a87a694         mov al, byte ptr [bx - 0x6b5a]
  057C48  1998: d0e8             shr al, 1
  057C4A  199A: 2ae4             sub ah, ah
  057C4C  199C: 8a8f7295         mov cl, byte ptr [bx - 0x6a8e]
  057C50  19A0: d0e9             shr cl, 1
  057C52  19A2: 2aed             sub ch, ch
  057C54  19A4: 03c1             add ax, cx
  057C56  19A6: 8b7608           mov si, word ptr [bp + 8]
  057C59  19A9: c1e604           shl si, 4
  057C5C  19AC: 8b5ef8           mov bx, word ptr [bp - 8]
  057C5F  19AF: 8a887295         mov cl, byte ptr [bx + si - 0x6a8e]
  057C63  19B3: 3bc1             cmp ax, cx
  057C65  19B5: 7d03             jge 0x19ba
  057C67  19B7: e9a0fe           jmp 0x185a
  057C6A  19BA: 8b7606           mov si, word ptr [bp + 6]
  057C6D  19BD: c1e604           shl si, 4
  057C70  19C0: 8b5ef8           mov bx, word ptr [bp - 8]
  057C73  19C3: 80b8729500       cmp byte ptr [bx + si - 0x6a8e], 0
  057C78  19C8: 7437             je 0x1a01
  057C7A  19CA: 8b4608           mov ax, word ptr [bp + 8]
  057C7D  19CD: c1e004           shl ax, 4
  057C80  19D0: 03d8             add bx, ax
  057C82  19D2: 80bfa69400       cmp byte ptr [bx - 0x6b5a], 0
  057C87  19D7: 7428             je 0x1a01
  057C89  19D9: 8bc3             mov ax, bx
  057C8B  19DB: 8b5ef8           mov bx, word ptr [bp - 8]
  057C8E  19DE: 8a887295         mov cl, byte ptr [bx + si - 0x6a8e]
  057C92  19E2: 2aed             sub ch, ch
  057C94  19E4: 014efa           add word ptr [bp - 6], cx
  057C97  19E7: 8bd8             mov bx, ax
  057C99  19E9: 8a8f7295         mov cl, byte ptr [bx - 0x6a8e]
  057C9D  19ED: 8a97a694         mov dl, byte ptr [bx - 0x6b5a]
  057CA1  19F1: 2af6             sub dh, dh
  057CA3  19F3: 03d1             add dx, cx
  057CA5  19F5: d1fa             sar dx, 1
  057CA7  19F7: 0156fc           add word ptr [bp - 4], dx
  057CAA  19FA: 81c6e694         add si, 0x94e6
  057CAE  19FE: 0176fe           add word ptr [bp - 2], si
  057CB1  1A01: ff46f8           inc word ptr [bp - 8]
  057CB4  1A04: 837ef80f         cmp word ptr [bp - 8], 0xf
  057CB8  1A08: 7d03             jge 0x1a0d
  057CBA  1A0A: e977ff           jmp 0x1984
  057CBD  1A0D: 8b46fa           mov ax, word ptr [bp - 6]
  057CC0  1A10: c1e002           shl ax, 2
  057CC3  1A13: 99               cdq 
  057CC4  1A14: f77efc           idiv word ptr [bp - 4]
  057CC7  1A17: 8b4ef6           mov cx, word ptr [bp - 0xa]
  057CCA  1A1A: 83c104           add cx, 4
  057CCD  1A1D: 3bc1             cmp ax, cx
  057CCF  1A1F: 7d09             jge 0x1a2a
  057CD1  1A21: 837efe00         cmp word ptr [bp - 2], 0
  057CD5  1A25: 7403             je 0x1a2a
  057CD7  1A27: e930fe           jmp 0x185a
  057CDA  1A2A: b80100           mov ax, 1
  057CDD  1A2D: 5e               pop si
  057CDE  1A2E: c9               leave 
  057CDF  1A2F: cb               retf 

; ---- func_057CE0  size=224  insns=76  prologue=ENTER 0x000E,0  terminal=RETF ----
  057CE0  1A30: c80e0000         enter 0xe, 0
  057CE4  1A34: c746f20000       mov word ptr [bp - 0xe], 0
  057CE9  1A39: eb5b             jmp 0x1a96
  057CEB  1A3B: 90               nop 
  057CEC  1A3C: 837ef808         cmp word ptr [bp - 8], 8
  057CF0  1A40: 7d30             jge 0x1a72
  057CF2  1A42: 8b5ef8           mov bx, word ptr [bp - 8]
  057CF5  1A45: 8a87be00         mov al, byte ptr [bx + 0xbe]
  057CF9  1A49: 98               cwde 
  057CFA  1A4A: 0346f4           add ax, word ptr [bp - 0xc]
  057CFD  1A4D: 50               push ax
  057CFE  1A4E: 8a87b400         mov al, byte ptr [bx + 0xb4]
  057D02  1A52: 98               cwde 
  057D03  1A53: 0346f6           add ax, word ptr [bp - 0xa]
  057D06  1A56: 50               push ax
  057D07  1A57: 9a96061f18       lcall 0x181f, 0x696
  057D0C  1A5C: 83c404           add sp, 4
  057D0F  1A5F: 3b4606           cmp ax, word ptr [bp + 6]
  057D12  1A62: 7505             jne 0x1a69
  057D14  1A64: c746fa0100       mov word ptr [bp - 6], 1
  057D19  1A69: ff46f8           inc word ptr [bp - 8]
  057D1C  1A6C: 837efa00         cmp word ptr [bp - 6], 0
  057D20  1A70: 74ca             je 0x1a3c
  057D22  1A72: 837efa00         cmp word ptr [bp - 6], 0
  057D26  1A76: 741b             je 0x1a93
  057D28  1A78: 6b5ef21c         imul bx, word ptr [bp - 0xe], 0x1c
  057D2C  1A7C: 80bf4c3105       cmp byte ptr [bx + 0x314c], 5
  057D31  1A81: 7407             je 0x1a8a
  057D33  1A83: 80bf4c3106       cmp byte ptr [bx + 0x314c], 6
  057D38  1A88: 7509             jne 0x1a93
  057D3A  1A8A: 6b5ef21c         imul bx, word ptr [bp - 0xe], 0x1c
  057D3E  1A8E: c6874c3100       mov byte ptr [bx + 0x314c], 0
  057D43  1A93: ff46f2           inc word ptr [bp - 0xe]
  057D46  1A96: a19c53           mov ax, word ptr [0x539c]
  057D49  1A99: 3946f2           cmp word ptr [bp - 0xe], ax
  057D4C  1A9C: 7d70             jge 0x1b0e
  057D4E  1A9E: 6b5ef21c         imul bx, word ptr [bp - 0xe], 0x1c
  057D52  1AA2: 8a874731         mov al, byte ptr [bx + 0x3147]
  057D56  1AA6: 240f             and al, 0xf
  057D58  1AA8: 3a4608           cmp al, byte ptr [bp + 8]
  057D5B  1AAB: 75e6             jne 0x1a93
  057D5D  1AAD: 6b5ef21c         imul bx, word ptr [bp - 0xe], 0x1c
  057D61  1AB1: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  057D66  1AB6: 7207             jb 0x1abf
  057D68  1AB8: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  057D6D  1ABD: 76d4             jbe 0x1a93
  057D6F  1ABF: 6b5ef21c         imul bx, word ptr [bp - 0xe], 0x1c
  057D73  1AC3: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  057D77  1AC7: 2aff             sub bh, bh
  057D79  1AC9: 8bc3             mov ax, bx
  057D7B  1ACB: d1e3             shl bx, 1
  057D7D  1ACD: 03d8             add bx, ax
  057D7F  1ACF: d1e3             shl bx, 1
  057D81  1AD1: 03d8             add bx, ax
  057D83  1AD3: d1e3             shl bx, 1
  057D85  1AD5: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  057D8A  1ADA: 76b7             jbe 0x1a93
  057D8C  1ADC: 6b5ef21c         imul bx, word ptr [bp - 0xe], 0x1c
  057D90  1AE0: 8a874431         mov al, byte ptr [bx + 0x3144]
  057D94  1AE4: 2ae4             sub ah, ah
  057D96  1AE6: 8946f6           mov word ptr [bp - 0xa], ax
  057D99  1AE9: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  057D9D  1AED: 2aed             sub ch, ch
  057D9F  1AEF: 894ef4           mov word ptr [bp - 0xc], cx
  057DA2  1AF2: c746fa0000       mov word ptr [bp - 6], 0
  057DA7  1AF7: 51               push cx
  057DA8  1AF8: 50               push ax
  057DA9  1AF9: 9a02031f18       lcall 0x181f, 0x302
  057DAE  1AFE: 83c404           add sp, 4
  057DB1  1B01: 0bc0             or ax, ax
  057DB3  1B03: 748e             je 0x1a93
  057DB5  1B05: c746f80000       mov word ptr [bp - 8], 0
  057DBA  1B0A: e95fff           jmp 0x1a6c
  057DBD  1B0D: 90               nop 
  057DBE  1B0E: c9               leave 
  057DBF  1B0F: cb               retf 

; ---- func_057DC0  size=397  insns=141  prologue=push bp;mov bp,sp  terminal=RETF ----
  057DC0  1B10: 55               push bp
  057DC1  1B11: 8bec             mov bp, sp
  057DC3  1B13: 56               push si
  057DC4  1B14: f606825301       test byte ptr [0x5382], 1
  057DC9  1B19: 7403             je 0x1b1e
  057DCB  1B1B: e97c01           jmp 0x1c9a
  057DCE  1B1E: 8b4606           mov ax, word ptr [bp + 6]
  057DD1  1B21: 03068e53         add ax, word ptr [0x538e]
  057DD5  1B25: 034608           add ax, word ptr [bp + 8]
  057DD8  1B28: b90300           mov cx, 3
  057DDB  1B2B: 99               cdq 
  057DDC  1B2C: f7f9             idiv cx
  057DDE  1B2E: 0bd2             or dx, dx
  057DE0  1B30: 7415             je 0x1b47
  057DE2  1B32: ff7608           push word ptr [bp + 8]
  057DE5  1B35: ff7606           push word ptr [bp + 6]
  057DE8  1B38: 9a380a1f18       lcall 0x181f, 0xa38
  057DED  1B3D: 83c404           add sp, 4
  057DF0  1B40: a820             test al, 0x20
  057DF2  1B42: 7403             je 0x1b47
  057DF4  1B44: e95301           jmp 0x1c9a
  057DF7  1B47: ff7608           push word ptr [bp + 8]
  057DFA  1B4A: ff7606           push word ptr [bp + 6]
  057DFD  1B4D: 9a380a1f18       lcall 0x181f, 0xa38
  057E02  1B52: 83c404           add sp, 4
  057E05  1B55: a802             test al, 2
  057E07  1B57: 7403             je 0x1b5c
  057E09  1B59: e93e01           jmp 0x1c9a
  057E0C  1B5C: ff7606           push word ptr [bp + 6]
  057E0F  1B5F: ff7608           push word ptr [bp + 8]
  057E12  1B62: 9a380a1f18       lcall 0x181f, 0xa38
  057E17  1B67: 83c404           add sp, 4
  057E1A  1B6A: a802             test al, 2
  057E1C  1B6C: 7403             je 0x1b71
  057E1E  1B6E: e92901           jmp 0x1c9a
  057E21  1B71: ff7606           push word ptr [bp + 6]
  057E24  1B74: 9aa4091f18       lcall 0x181f, 0x9a4
  057E29  1B79: 83c402           add sp, 2
  057E2C  1B7C: 50               push ax
  057E2D  1B7D: 6a00             push 0
  057E2F  1B7F: 9a38041f18       lcall 0x181f, 0x438
  057E34  1B84: 83c404           add sp, 4
  057E37  1B87: ff7608           push word ptr [bp + 8]
  057E3A  1B8A: 9aa4091f18       lcall 0x181f, 0x9a4
  057E3F  1B8F: 83c402           add sp, 2
  057E42  1B92: 50               push ax
  057E43  1B93: 6a01             push 1
  057E45  1B95: 9a38041f18       lcall 0x181f, 0x438
  057E4A  1B9A: 83c404           add sp, 4
  057E4D  1B9D: ff7608           push word ptr [bp + 8]
  057E50  1BA0: ff7606           push word ptr [bp + 6]
  057E53  1BA3: 0e               push cs
  057E54  1BA4: e8b123           call 0x3f58
  057E57  1BA7: 83c404           add sp, 4
  057E5A  1BAA: 0bc0             or ax, ax
  057E5C  1BAC: 757a             jne 0x1c28
  057E5E  1BAE: ff7606           push word ptr [bp + 6]
  057E61  1BB1: ff7608           push word ptr [bp + 8]
  057E64  1BB4: 0e               push cs
  057E65  1BB5: e8a023           call 0x3f58
  057E68  1BB8: 83c404           add sp, 4
  057E6B  1BBB: 0bc0             or ax, ax
  057E6D  1BBD: 7569             jne 0x1c28
  057E6F  1BBF: ff7608           push word ptr [bp + 8]
  057E72  1BC2: ff7606           push word ptr [bp + 6]
  057E75  1BC5: 9a380a1f18       lcall 0x181f, 0xa38
  057E7A  1BCA: 83c404           add sp, 4
  057E7D  1BCD: a840             test al, 0x40
  057E7F  1BCF: 7403             je 0x1bd4
  057E81  1BD1: e9c600           jmp 0x1c9a
  057E84  1BD4: 6a02             push 2
  057E86  1BD6: 688d18           push 0x188d
  057E89  1BD9: 9a52061f18       lcall 0x181f, 0x652
  057E8E  1BDE: 83c404           add sp, 4
  057E91  1BE1: 6a40             push 0x40
  057E93  1BE3: ff7608           push word ptr [bp + 8]
  057E96  1BE6: ff7606           push word ptr [bp + 6]
  057E99  1BE9: 9a060a1f18       lcall 0x181f, 0xa06
  057E9E  1BEE: 83c406           add sp, 6
  057EA1  1BF1: ff7608           push word ptr [bp + 8]
  057EA4  1BF4: ff7606           push word ptr [bp + 6]
  057EA7  1BF7: 0e               push cs
  057EA8  1BF8: e83523           call 0x3f30
  057EAB  1BFB: 83c404           add sp, 4
  057EAE  1BFE: ff7606           push word ptr [bp + 6]
  057EB1  1C01: ff7608           push word ptr [bp + 8]
  057EB4  1C04: 0e               push cs
  057EB5  1C05: e82823           call 0x3f30
  057EB8  1C08: 83c404           add sp, 4
  057EBB  1C0B: b001             mov al, 1
  057EBD  1C0D: 6976063c01       imul si, word ptr [bp + 6], 0x13c
  057EC2  1C12: 8b5e08           mov bx, word ptr [bp + 8]
  057EC5  1C15: 88804888         mov byte ptr [bx + si - 0x77b8], al
  057EC9  1C19: 69f33c01         imul si, bx, 0x13c
  057ECD  1C1D: 8b5e06           mov bx, word ptr [bp + 6]
  057ED0  1C20: 88804888         mov byte ptr [bx + si - 0x77b8], al
  057ED4  1C24: 5e               pop si
  057ED5  1C25: c9               leave 
  057ED6  1C26: cb               retf 
  057ED7  1C27: 90               nop 
  057ED8  1C28: ff7608           push word ptr [bp + 8]
  057EDB  1C2B: ff7606           push word ptr [bp + 6]
  057EDE  1C2E: 9a380a1f18       lcall 0x181f, 0xa38
  057EE3  1C33: 83c404           add sp, 4
  057EE6  1C36: a840             test al, 0x40
  057EE8  1C38: 7512             jne 0x1c4c
  057EEA  1C3A: ff7608           push word ptr [bp + 8]
  057EED  1C3D: ff7606           push word ptr [bp + 6]
  057EF0  1C40: 9a380a1f18       lcall 0x181f, 0xa38
  057EF5  1C45: 83c404           add sp, 4
  057EF8  1C48: a820             test al, 0x20
  057EFA  1C4A: 754e             jne 0x1c9a
  057EFC  1C4C: ff7608           push word ptr [bp + 8]
  057EFF  1C4F: ff7606           push word ptr [bp + 6]
  057F02  1C52: 9a380a1f18       lcall 0x181f, 0xa38
  057F07  1C57: 83c404           add sp, 4
  057F0A  1C5A: a840             test al, 0x40
  057F0C  1C5C: 7408             je 0x1c66
  057F0E  1C5E: 6a02             push 2
  057F10  1C60: 689818           push 0x1898
  057F13  1C63: eb06             jmp 0x1c6b
  057F15  1C65: 90               nop 
  057F16  1C66: 6a02             push 2
  057F18  1C68: 68a518           push 0x18a5
  057F1B  1C6B: 9a52061f18       lcall 0x181f, 0x652
  057F20  1C70: 83c404           add sp, 4
  057F23  1C73: 2ac0             sub al, al
  057F25  1C75: 6976063c01       imul si, word ptr [bp + 6], 0x13c
  057F2A  1C7A: 8b5e08           mov bx, word ptr [bp + 8]
  057F2D  1C7D: 88804888         mov byte ptr [bx + si - 0x77b8], al
  057F31  1C81: 69f33c01         imul si, bx, 0x13c
  057F35  1C85: 8b5e06           mov bx, word ptr [bp + 6]
  057F38  1C88: 88804888         mov byte ptr [bx + si - 0x77b8], al
  057F3C  1C8C: 6a40             push 0x40
  057F3E  1C8E: ff7608           push word ptr [bp + 8]
  057F41  1C91: 53               push bx
  057F42  1C92: 9a100a1f18       lcall 0x181f, 0xa10
  057F47  1C97: 83c406           add sp, 6
  057F4A  1C9A: 5e               pop si
  057F4B  1C9B: c9               leave 
  057F4C  1C9C: cb               retf 

; ---- func_057F4E  size=7151  insns=2356  prologue=ENTER 0x00D6,0  terminal=RETF ----
  057F4E  1C9E: c8d60000         enter 0xd6, 0
  057F52  1CA2: 57               push di
  057F53  1CA3: 56               push si
  057F54  1CA4: c7864effffff     mov word ptr [bp - 0xb2], 0xffff
  057F5A  1CAA: 2bc0             sub ax, ax
  057F5C  1CAC: 898674ff         mov word ptr [bp - 0x8c], ax
  057F60  1CB0: 898634ff         mov word ptr [bp - 0xcc], ax
  057F64  1CB4: 89469a           mov word ptr [bp - 0x66], ax
  057F67  1CB7: 89865aff         mov word ptr [bp - 0xa6], ax
  057F6B  1CBB: 8946f6           mov word ptr [bp - 0xa], ax
  057F6E  1CBE: 89862eff         mov word ptr [bp - 0xd2], ax
  057F72  1CC2: 898646ff         mov word ptr [bp - 0xba], ax
  057F76  1CC6: 898652ff         mov word ptr [bp - 0xae], ax
  057F7A  1CCA: 898644ff         mov word ptr [bp - 0xbc], ax
  057F7E  1CCE: 898666ff         mov word ptr [bp - 0x9a], ax
  057F82  1CD2: 894698           mov word ptr [bp - 0x68], ax
  057F85  1CD5: 894696           mov word ptr [bp - 0x6a], ax
  057F88  1CD8: 0e               push cs
  057F89  1CD9: e84a22           call 0x3f26
  057F8C  1CDC: 837e0604         cmp word ptr [bp + 6], 4
  057F90  1CE0: 7d0b             jge 0x1ced
  057F92  1CE2: 6b5e0634         imul bx, word ptr [bp + 6], 0x34
  057F96  1CE6: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  057F9B  1CEB: 7417             je 0x1d04
  057F9D  1CED: ff7608           push word ptr [bp + 8]
  057FA0  1CF0: ff7606           push word ptr [bp + 6]
  057FA3  1CF3: 0e               push cs
  057FA4  1CF4: e85722           call 0x3f4e
  057FA7  1CF7: 83c404           add sp, 4
  057FAA  1CFA: c78674ff0100     mov word ptr [bp - 0x8c], 1
  057FB0  1D00: e93b1b           jmp 0x383e
  057FB3  1D03: 90               nop 
  057FB4  1D04: f606825301       test byte ptr [0x5382], 1
  057FB9  1D09: 7403             je 0x1d0e
  057FBB  1D0B: e9301b           jmp 0x383e
  057FBE  1D0E: 8b460e           mov ax, word ptr [bp + 0xe]
  057FC1  1D11: 898646ff         mov word ptr [bp - 0xba], ax
  057FC5  1D15: ff7608           push word ptr [bp + 8]
  057FC8  1D18: ff7606           push word ptr [bp + 6]
  057FCB  1D1B: 9a380a1f18       lcall 0x181f, 0xa38
  057FD0  1D20: 83c404           add sp, 4
  057FD3  1D23: a820             test al, 0x20
  057FD5  1D25: 7510             jne 0x1d37
  057FD7  1D27: c78646ff0100     mov word ptr [bp - 0xba], 1
  057FDD  1D2D: 6a0a             push 0xa
  057FDF  1D2F: 9a24051f18       lcall 0x181f, 0x524
  057FE4  1D34: 83c402           add sp, 2
  057FE7  1D37: 8b5e08           mov bx, word ptr [bp + 8]
  057FEA  1D3A: d1e3             shl bx, 1
  057FEC  1D3C: 8b87c853         mov ax, word ptr [bx + 0x53c8]
  057FF0  1D40: 051000           add ax, 0x10
  057FF3  1D43: 3b068e53         cmp ax, word ptr [0x538e]
  057FF7  1D47: 7f16             jg 0x1d5f
  057FF9  1D49: c78646ff0100     mov word ptr [bp - 0xba], 1
  057FFF  1D4F: 6a10             push 0x10
  058001  1D51: ff7608           push word ptr [bp + 8]
  058004  1D54: ff7606           push word ptr [bp + 6]
  058007  1D57: 9a100a1f18       lcall 0x181f, 0xa10
  05800C  1D5C: 83c406           add sp, 6
  05800F  1D5F: ff7608           push word ptr [bp + 8]
  058012  1D62: ff7606           push word ptr [bp + 6]
  058015  1D65: 9a380a1f18       lcall 0x181f, 0xa38
  05801A  1D6A: 83c404           add sp, 4
  05801D  1D6D: 251000           and ax, 0x10
  058020  1D70: 898664ff         mov word ptr [bp - 0x9c], ax
  058024  1D74: 83be46ff00       cmp word ptr [bp - 0xba], 0
  058029  1D79: 7503             jne 0x1d7e
  05802B  1D7B: e9c01a           jmp 0x383e
  05802E  1D7E: 8b4608           mov ax, word ptr [bp + 8]
  058031  1D81: 0bc0             or ax, ax
  058033  1D83: 740b             je 0x1d90
  058035  1D85: 48               dec ax
  058036  1D86: 7450             je 0x1dd8
  058038  1D88: 48               dec ax
  058039  1D89: 7453             je 0x1dde
  05803B  1D8B: 48               dec ax
  05803C  1D8C: 7456             je 0x1de4
  05803E  1D8E: eb08             jmp 0x1d98
  058040  1D90: b82080           mov ax, 0x8020
  058043  1D93: 9ac0041f18       lcall 0x181f, 0x4c0
  058048  1D98: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  05804D  1D9D: f687088804       test byte ptr [bx - 0x77f8], 4
  058052  1DA2: 7406             je 0x1daa
  058054  1DA4: c78666ff0100     mov word ptr [bp - 0x9a], 1
  05805A  1DAA: ff7606           push word ptr [bp + 6]
  05805D  1DAD: 9a82051f18       lcall 0x181f, 0x582
  058062  1DB2: 83c402           add sp, 2
  058065  1DB5: 8b5e08           mov bx, word ptr [bp + 8]
  058068  1DB8: d1e3             shl bx, 1
  05806A  1DBA: 8b87c853         mov ax, word ptr [bx + 0x53c8]
  05806E  1DBE: 898676ff         mov word ptr [bp - 0x8a], ax
  058072  1DC2: a18e53           mov ax, word ptr [0x538e]
  058075  1DC5: 8987c853         mov word ptr [bx + 0x53c8], ax
  058079  1DC9: b80100           mov ax, 1
  05807C  1DCC: 898674ff         mov word ptr [bp - 0x8c], ax
  058080  1DD0: 898636ff         mov word ptr [bp - 0xca], ax
  058084  1DD4: e92501           jmp 0x1efc
  058087  1DD7: 90               nop 
  058088  1DD8: b82180           mov ax, 0x8021
  05808B  1DDB: ebb6             jmp 0x1d93
  05808D  1DDD: 90               nop 
  05808E  1DDE: b82280           mov ax, 0x8022
  058091  1DE1: ebb0             jmp 0x1d93
  058093  1DE3: 90               nop 
  058094  1DE4: b82380           mov ax, 0x8023
  058097  1DE7: ebaa             jmp 0x1d93
  058099  1DE9: 90               nop 
  05809A  1DEA: 2ac0             sub al, al
  05809C  1DEC: c1e304           shl bx, 4
  05809F  1DEF: 039e36ff         add bx, word ptr [bp - 0xca]
  0580A3  1DF3: 3887e694         cmp byte ptr [bx - 0x6b1a], al
  0580A7  1DF7: 763b             jbe 0x1e34
  0580A9  1DF9: 8b7606           mov si, word ptr [bp + 6]
  0580AC  1DFC: c1e604           shl si, 4
  0580AF  1DFF: 8bc3             mov ax, bx
  0580B1  1E01: 8b9e36ff         mov bx, word ptr [bp - 0xca]
  0580B5  1E05: 8bf8             mov di, ax
  0580B7  1E07: 8a80b295         mov al, byte ptr [bx + si - 0x6a4e]
  0580BB  1E0B: 3885a694         cmp byte ptr [di - 0x6b5a], al
  0580BF  1E0F: 7323             jae 0x1e34
  0580C1  1E11: 2ae4             sub ah, ah
  0580C3  1E13: 8a8da694         mov cl, byte ptr [di - 0x6b5a]
  0580C7  1E17: 2aed             sub ch, ch
  0580C9  1E19: 41               inc cx
  0580CA  1E1A: 99               cdq 
  0580CB  1E1B: f7f9             idiv cx
  0580CD  1E1D: 803ea65301       cmp byte ptr [0x53a6], 1
  0580D2  1E22: 1ac9             sbb cl, cl
  0580D4  1E24: 80e101           and cl, 1
  0580D7  1E27: 80c101           add cl, 1
  0580DA  1E2A: d3e0             shl ax, cl
  0580DC  1E2C: 018634ff         add word ptr [bp - 0xcc], ax
  0580E0  1E30: e9c500           jmp 0x1ef8
  0580E3  1E33: 90               nop 
  0580E4  1E34: 8b7606           mov si, word ptr [bp + 6]
  0580E7  1E37: c1e604           shl si, 4
  0580EA  1E3A: 8b9e36ff         mov bx, word ptr [bp - 0xca]
  0580EE  1E3E: 80b8b29500       cmp byte ptr [bx + si - 0x6a4e], 0
  0580F3  1E43: 7413             je 0x1e58
  0580F5  1E45: 8b7608           mov si, word ptr [bp + 8]
  0580F8  1E48: c1e604           shl si, 4
  0580FB  1E4B: 80b8b29500       cmp byte ptr [bx + si - 0x6a4e], 0
  058100  1E50: 7406             je 0x1e58
  058102  1E52: c7865aff0100     mov word ptr [bp - 0xa6], 1
  058108  1E58: 8b7608           mov si, word ptr [bp + 8]
  05810B  1E5B: c1e604           shl si, 4
  05810E  1E5E: 80b8b29500       cmp byte ptr [bx + si - 0x6a4e], 0
  058113  1E63: 7413             je 0x1e78
  058115  1E65: 8b7606           mov si, word ptr [bp + 6]
  058118  1E68: c1e604           shl si, 4
  05811B  1E6B: 80b8269504       cmp byte ptr [bx + si - 0x6ada], 4
  058120  1E70: 7606             jbe 0x1e78
  058122  1E72: c7865aff0100     mov word ptr [bp - 0xa6], 1
  058128  1E78: 8b5e06           mov bx, word ptr [bp + 6]
  05812B  1E7B: c1e304           shl bx, 4
  05812E  1E7E: 039e36ff         add bx, word ptr [bp - 0xca]
  058132  1E82: 80bfe69400       cmp byte ptr [bx - 0x6b1a], 0
  058137  1E87: 7433             je 0x1ebc
  058139  1E89: 8b7608           mov si, word ptr [bp + 8]
  05813C  1E8C: c1e604           shl si, 4
  05813F  1E8F: 03b636ff         add si, word ptr [bp - 0xca]
  058143  1E93: 80bce69401       cmp byte ptr [si - 0x6b1a], 1
  058148  1E98: 7610             jbe 0x1eaa
  05814A  1E9A: 8a84b295         mov al, byte ptr [si - 0x6a4e]
  05814E  1E9E: 2ae4             sub ah, ah
  058150  1EA0: 8a8fb295         mov cl, byte ptr [bx - 0x6a4e]
  058154  1EA4: 2aed             sub ch, ch
  058156  1EA6: 2bc1             sub ax, cx
  058158  1EA8: eb4b             jmp 0x1ef5
  05815A  1EAA: 8b7608           mov si, word ptr [bp + 8]
  05815D  1EAD: c1e604           shl si, 4
  058160  1EB0: 8b9e36ff         mov bx, word ptr [bp - 0xca]
  058164  1EB4: 8a80b295         mov al, byte ptr [bx + si - 0x6a4e]
  058168  1EB8: 2ae4             sub ah, ah
  05816A  1EBA: eb39             jmp 0x1ef5
  05816C  1EBC: 8b5e08           mov bx, word ptr [bp + 8]
  05816F  1EBF: c1e304           shl bx, 4
  058172  1EC2: 039e36ff         add bx, word ptr [bp - 0xca]
  058176  1EC6: 8a87b295         mov al, byte ptr [bx - 0x6a4e]
  05817A  1ECA: 2ae4             sub ah, ah
  05817C  1ECC: 8b7606           mov si, word ptr [bp + 6]
  05817F  1ECF: c1e604           shl si, 4
  058182  1ED2: 8bcb             mov cx, bx
  058184  1ED4: 8b9e36ff         mov bx, word ptr [bp - 0xca]
  058188  1ED8: 8a90b295         mov dl, byte ptr [bx + si - 0x6a4e]
  05818C  1EDC: 2af6             sub dh, dh
  05818E  1EDE: 2bc2             sub ax, dx
  058190  1EE0: 89866cff         mov word ptr [bp - 0x94], ax
  058194  1EE4: 8bf1             mov si, cx
  058196  1EE6: 80bce69401       cmp byte ptr [si - 0x6b1a], 1
  05819B  1EEB: 1ac9             sbb cl, cl
  05819D  1EED: 80e101           and cl, 1
  0581A0  1EF0: 80c101           add cl, 1
  0581A3  1EF3: d3f8             sar ax, cl
  0581A5  1EF5: 01469a           add word ptr [bp - 0x66], ax
  0581A8  1EF8: ff8636ff         inc word ptr [bp - 0xca]
  0581AC  1EFC: 83be36ff0f       cmp word ptr [bp - 0xca], 0xf
  0581B1  1F01: 7d13             jge 0x1f16
  0581B3  1F03: 8b5e08           mov bx, word ptr [bp + 8]
  0581B6  1F06: 80bf989201       cmp byte ptr [bx - 0x6d68], 1
  0581BB  1F0B: 7703             ja 0x1f10
  0581BD  1F0D: e9dafe           jmp 0x1dea
  0581C0  1F10: b001             mov al, 1
  0581C2  1F12: e9d7fe           jmp 0x1dec
  0581C5  1F15: 90               nop 
  0581C6  1F16: 2bc0             sub ax, ax
  0581C8  1F18: 8946fa           mov word ptr [bp - 6], ax
  0581CB  1F1B: 898650ff         mov word ptr [bp - 0xb0], ax
  0581CF  1F1F: 8946a0           mov word ptr [bp - 0x60], ax
  0581D2  1F22: 89863cff         mov word ptr [bp - 0xc4], ax
  0581D6  1F26: e9c600           jmp 0x1fef
  0581D9  1F29: 90               nop 
  0581DA  1F2A: ffb63cff         push word ptr [bp - 0xc4]
  0581DE  1F2E: 9ae6091f18       lcall 0x181f, 0x9e6
  0581E3  1F33: 83c402           add sp, 2
  0581E6  1F36: 8a4606           mov al, byte ptr [bp + 6]
  0581E9  1F39: 8b1e4285         mov bx, word ptr [0x8542]
  0581ED  1F3D: 38471a           cmp byte ptr [bx + 0x1a], al
  0581F0  1F40: 740b             je 0x1f4d
  0581F2  1F42: 8a4608           mov al, byte ptr [bp + 8]
  0581F5  1F45: 38471a           cmp byte ptr [bx + 0x1a], al
  0581F8  1F48: 7403             je 0x1f4d
  0581FA  1F4A: e99e00           jmp 0x1feb
  0581FD  1F4D: ff7608           push word ptr [bp + 8]
  058200  1F50: 8d863eff         lea ax, [bp - 0xc2]
  058204  1F54: 50               push ax
  058205  1F55: 8d4efc           lea cx, [bp - 4]
  058208  1F58: 51               push cx
  058209  1F59: 8d9670ff         lea dx, [bp - 0x90]
  05820D  1F5D: 52               push dx
  05820E  1F5E: 0e               push cs
  05820F  1F5F: e8dd1f           call 0x3f3f
  058212  1F62: 83c408           add sp, 8
  058215  1F65: 89864aff         mov word ptr [bp - 0xb6], ax
  058219  1F69: 8b4608           mov ax, word ptr [bp + 8]
  05821C  1F6C: 398670ff         cmp word ptr [bp - 0x90], ax
  058220  1F70: 7560             jne 0x1fd2
  058222  1F72: 8b864aff         mov ax, word ptr [bp - 0xb6]
  058226  1F76: d1e0             shl ax, 1
  058228  1F78: 01469a           add word ptr [bp - 0x66], ax
  05822B  1F7B: 837efc00         cmp word ptr [bp - 4], 0
  05822F  1F7F: 7407             je 0x1f88
  058231  1F81: 83be3eff01       cmp word ptr [bp - 0xc2], 1
  058236  1F86: 7e11             jle 0x1f99
  058238  1F88: 83be34ff00       cmp word ptr [bp - 0xcc], 0
  05823D  1F8D: 7404             je 0x1f93
  05823F  1F8F: ff8e34ff         dec word ptr [bp - 0xcc]
  058243  1F93: c7865aff0100     mov word ptr [bp - 0xa6], 1
  058249  1F99: 8b1e4285         mov bx, word ptr [0x8542]
  05824D  1F9D: 8a4701           mov al, byte ptr [bx + 1]
  058250  1FA0: 2ae4             sub ah, ah
  058252  1FA2: 50               push ax
  058253  1FA3: 8a07             mov al, byte ptr [bx]
  058255  1FA5: 50               push ax
  058256  1FA6: 9a22071f18       lcall 0x181f, 0x722
  05825B  1FAB: 83c404           add sp, 4
  05825E  1FAE: 8bf0             mov si, ax
  058260  1FB0: 89b67cff         mov word ptr [bp - 0x84], si
  058264  1FB4: 8b5e08           mov bx, word ptr [bp + 8]
  058267  1FB7: c1e304           shl bx, 4
  05826A  1FBA: 80b8e69400       cmp byte ptr [bx + si - 0x6b1a], 0
  05826F  1FBF: 7504             jne 0x1fc5
  058271  1FC1: d1a64aff         shl word ptr [bp - 0xb6], 1
  058275  1FC5: 8b864aff         mov ax, word ptr [bp - 0xb6]
  058279  1FC9: 018650ff         add word ptr [bp - 0xb0], ax
  05827D  1FCD: c746a00100       mov word ptr [bp - 0x60], 1
  058282  1FD2: 8b4606           mov ax, word ptr [bp + 6]
  058285  1FD5: 398670ff         cmp word ptr [bp - 0x90], ax
  058289  1FD9: 7510             jne 0x1feb
  05828B  1FDB: 8b864aff         mov ax, word ptr [bp - 0xb6]
  05828F  1FDF: 0146fa           add word ptr [bp - 6], ax
  058292  1FE2: 8b863eff         mov ax, word ptr [bp - 0xc2]
  058296  1FE6: d1e0             shl ax, 1
  058298  1FE8: 29469a           sub word ptr [bp - 0x66], ax
  05829B  1FEB: ff863cff         inc word ptr [bp - 0xc4]
  05829F  1FEF: a19e53           mov ax, word ptr [0x539e]
  0582A2  1FF2: 39863cff         cmp word ptr [bp - 0xc4], ax
  0582A6  1FF6: 7d03             jge 0x1ffb
  0582A8  1FF8: e92fff           jmp 0x1f2a
  0582AB  1FFB: 8a4606           mov al, byte ptr [bp + 6]
  0582AE  1FFE: 380653a1         cmp byte ptr [0xa153], al
  0582B2  2002: 7520             jne 0x2024
  0582B4  2004: 833e8e5350       cmp word ptr [0x538e], 0x50
  0582B9  2009: 7c19             jl 0x2024
  0582BB  200B: 8b5e06           mov bx, word ptr [bp + 6]
  0582BE  200E: 80bf989203       cmp byte ptr [bx - 0x6d68], 3
  0582C3  2013: 760f             jbe 0x2024
  0582C5  2015: 8b5e08           mov bx, word ptr [bp + 8]
  0582C8  2018: 80bf989201       cmp byte ptr [bx - 0x6d68], 1
  0582CD  201D: 7605             jbe 0x2024
  0582CF  201F: c746f60100       mov word ptr [bp - 0xa], 1
  0582D4  2024: 6976083c01       imul si, word ptr [bp + 8], 0x13c
  0582D9  2029: 8b5e06           mov bx, word ptr [bp + 6]
  0582DC  202C: 8a803c88         mov al, byte ptr [bx + si - 0x77c4]
  0582E0  2030: 250200           and ax, 2
  0582E3  2033: 898654ff         mov word ptr [bp - 0xac], ax
  0582E7  2037: 837ef600         cmp word ptr [bp - 0xa], 0
  0582EB  203B: 7517             jne 0x2054
  0582ED  203D: 0bc0             or ax, ax
  0582EF  203F: 743a             je 0x207b
  0582F1  2041: 8b7608           mov si, word ptr [bp + 8]
  0582F4  2044: 8a842c94         mov al, byte ptr [si - 0x6bd4]
  0582F8  2048: 8bc8             mov cx, ax
  0582FA  204A: d0e0             shl al, 1
  0582FC  204C: 02c1             add al, cl
  0582FE  204E: 3a872c94         cmp al, byte ptr [bx - 0x6bd4]
  058302  2052: 7627             jbe 0x207b
  058304  2054: c7865aff0100     mov word ptr [bp - 0xa6], 1
  05830A  205A: c78634ff0000     mov word ptr [bp - 0xcc], 0
  058310  2060: 68ac26           push 0x26ac
  058313  2063: b0c8             mov al, 0xc8
  058315  2065: f626a653         mul byte ptr [0x53a6]
  058319  2069: 056400           add ax, 0x64
  05831C  206C: 50               push ax
  05831D  206D: ff769a           push word ptr [bp - 0x66]
  058320  2070: 9a5c031f18       lcall 0x181f, 0x35c
  058325  2075: 83c406           add sp, 6
  058328  2078: 89469a           mov word ptr [bp - 0x66], ax
  05832B  207B: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  058330  2080: 7406             je 0x2088
  058332  2082: c7865aff0100     mov word ptr [bp - 0xa6], 1
  058338  2088: 83be34ff00       cmp word ptr [bp - 0xcc], 0
  05833D  208D: 740a             je 0x2099
  05833F  208F: 2bc0             sub ax, ax
  058341  2091: 89865aff         mov word ptr [bp - 0xa6], ax
  058345  2095: 89862eff         mov word ptr [bp - 0xd2], ax
  058349  2099: 6a13             push 0x13
  05834B  209B: ff7606           push word ptr [bp + 6]
  05834E  209E: 9ab4071f18       lcall 0x181f, 0x7b4
  058353  20A3: 83c404           add sp, 4
  058356  20A6: 0bc0             or ax, ax
  058358  20A8: 7413             je 0x20bd
  05835A  20AA: 2bc0             sub ax, ax
  05835C  20AC: 8946f6           mov word ptr [bp - 0xa], ax
  05835F  20AF: 89865aff         mov word ptr [bp - 0xa6], ax
  058363  20B3: 398676ff         cmp word ptr [bp - 0x8a], ax
  058367  20B7: 7d04             jge 0x20bd
  058369  20B9: 898676ff         mov word ptr [bp - 0x8a], ax
  05836D  20BD: 83be54ff00       cmp word ptr [bp - 0xac], 0
  058372  20C2: 752c             jne 0x20f0
  058374  20C4: a0a653           mov al, byte ptr [0x53a6]
  058377  20C7: 2ae4             sub ah, ah
  058379  20C9: 2d0a00           sub ax, 0xa
  05837C  20CC: f7d8             neg ax
  05837E  20CE: 8bc8             mov cx, ax
  058380  20D0: c1e002           shl ax, 2
  058383  20D3: 03c1             add ax, cx
  058385  20D5: d1e0             shl ax, 1
  058387  20D7: 3b068e53         cmp ax, word ptr [0x538e]
  05838B  20DB: 7e13             jle 0x20f0
  05838D  20DD: 2bc0             sub ax, ax
  05838F  20DF: 8946f6           mov word ptr [bp - 0xa], ax
  058392  20E2: 89865aff         mov word ptr [bp - 0xa6], ax
  058396  20E6: 398676ff         cmp word ptr [bp - 0x8a], ax
  05839A  20EA: 7d04             jge 0x20f0
  05839C  20EC: 898676ff         mov word ptr [bp - 0x8a], ax
  0583A0  20F0: a0a653           mov al, byte ptr [0x53a6]
  0583A3  20F3: 2ae4             sub ah, ah
  0583A5  20F5: 050800           add ax, 8
  0583A8  20F8: f76e9a           imul word ptr [bp - 0x66]
  0583AB  20FB: 8bc8             mov cx, ax
  0583AD  20FD: c1e002           shl ax, 2
  0583B0  2100: 03c1             add ax, cx
  0583B2  2102: d1e0             shl ax, 1
  0583B4  2104: b96400           mov cx, 0x64
  0583B7  2107: 99               cdq 
  0583B8  2108: f7f9             idiv cx
  0583BA  210A: 89469a           mov word ptr [bp - 0x66], ax
  0583BD  210D: 83be54ff00       cmp word ptr [bp - 0xac], 0
  0583C2  2112: 7406             je 0x211a
  0583C4  2114: d1669a           shl word ptr [bp - 0x66], 1
  0583C7  2117: eb3b             jmp 0x2154
  0583C9  2119: 90               nop 
  0583CA  211A: 83be76ff00       cmp word ptr [bp - 0x8a], 0
  0583CF  211F: 7d07             jge 0x2128
  0583D1  2121: c17e9a02         sar word ptr [bp - 0x66], 2
  0583D5  2125: eb2d             jmp 0x2154
  0583D7  2127: 90               nop 
  0583D8  2128: 833e8e5332       cmp word ptr [0x538e], 0x32
  0583DD  212D: 7d05             jge 0x2134
  0583DF  212F: d17e9a           sar word ptr [bp - 0x66], 1
  0583E2  2132: eb0c             jmp 0x2140
  0583E4  2134: 390e8e53         cmp word ptr [0x538e], cx
  0583E8  2138: 7d06             jge 0x2140
  0583EA  213A: c1f802           sar ax, 2
  0583ED  213D: 29469a           sub word ptr [bp - 0x66], ax
  0583F0  2140: 8b5e06           mov bx, word ptr [bp + 6]
  0583F3  2143: 80bf989202       cmp byte ptr [bx - 0x6d68], 2
  0583F8  2148: 770a             ja 0x2154
  0583FA  214A: 80bf109408       cmp byte ptr [bx - 0x6bf0], 8
  0583FF  214F: 7303             jae 0x2154
  058401  2151: d17e9a           sar word ptr [bp - 0x66], 1
  058404  2154: 689001           push 0x190
  058407  2157: 6a00             push 0
  058409  2159: a0a653           mov al, byte ptr [0x53a6]
  05840C  215C: 2ae4             sub ah, ah
  05840E  215E: 40               inc ax
  05840F  215F: f76e9a           imul word ptr [bp - 0x66]
  058412  2162: c1f803           sar ax, 3
  058415  2165: 50               push ax
  058416  2166: 9a5c031f18       lcall 0x181f, 0x35c
  05841B  216B: 83c406           add sp, 6
  05841E  216E: 6bc032           imul ax, ax, 0x32
  058421  2171: 89469a           mov word ptr [bp - 0x66], ax
  058424  2174: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  058429  2179: 740d             je 0x2188
  05842B  217B: a0a653           mov al, byte ptr [0x53a6]
  05842E  217E: 2ae4             sub ah, ah
  058430  2180: 40               inc ax
  058431  2181: 69c0f401         imul ax, ax, 0x1f4
  058435  2185: 01469a           add word ptr [bp - 0x66], ax
  058438  2188: 8b469a           mov ax, word ptr [bp - 0x66]
  05843B  218B: 99               cdq 
  05843C  218C: 8b1efc84         mov bx, word ptr [0x84fc]
  058440  2190: 39572c           cmp word ptr [bx + 0x2c], dx
  058443  2193: 7f4b             jg 0x21e0
  058445  2195: 7c05             jl 0x219c
  058447  2197: 39472a           cmp word ptr [bx + 0x2a], ax
  05844A  219A: 7344             jae 0x21e0
  05844C  219C: 8b4f2a           mov cx, word ptr [bx + 0x2a]
  05844F  219F: 8b772c           mov si, word ptr [bx + 0x2c]
  058452  21A2: 898e2aff         mov word ptr [bp - 0xd6], cx
  058456  21A6: 89b62cff         mov word ptr [bp - 0xd4], si
  05845A  21AA: d1e1             shl cx, 1
  05845C  21AC: d1d6             rcl si, 1
  05845E  21AE: 3bf2             cmp si, dx
  058460  21B0: 7c2e             jl 0x21e0
  058462  21B2: 7f04             jg 0x21b8
  058464  21B4: 3bc8             cmp cx, ax
  058466  21B6: 7628             jbe 0x21e0
  058468  21B8: 83be2cff00       cmp word ptr [bp - 0xd4], 0
  05846D  21BD: 7c21             jl 0x21e0
  05846F  21BF: 7f08             jg 0x21c9
  058471  21C1: 81be2aff2c01     cmp word ptr [bp - 0xd6], 0x12c
  058477  21C7: 7217             jb 0x21e0
  058479  21C9: 6a00             push 0
  05847B  21CB: 6a32             push 0x32
  05847D  21CD: ffb62cff         push word ptr [bp - 0xd4]
  058481  21D1: ffb62aff         push word ptr [bp - 0xd6]
  058485  21D5: 9ac60e1d0d       lcall 0xd1d, 0xec6
  05848A  21DA: 6bc032           imul ax, ax, 0x32
  05848D  21DD: 89469a           mov word ptr [bp - 0x66], ax
  058490  21E0: 6a13             push 0x13
  058492  21E2: ff7606           push word ptr [bp + 6]
  058495  21E5: 9ab4071f18       lcall 0x181f, 0x7b4
  05849A  21EA: 83c404           add sp, 4
  05849D  21ED: 0bc0             or ax, ax
  05849F  21EF: 7403             je 0x21f4
  0584A1  21F1: d17e9a           sar word ptr [bp - 0x66], 1
  0584A4  21F4: 837e9a00         cmp word ptr [bp - 0x66], 0
  0584A8  21F8: 7416             je 0x2210
  0584AA  21FA: 8b5e08           mov bx, word ptr [bp + 8]
  0584AD  21FD: 8a872c94         mov al, byte ptr [bx - 0x6bd4]
  0584B1  2201: 8bc8             mov cx, ax
  0584B3  2203: d0e0             shl al, 1
  0584B5  2205: 02c1             add al, cl
  0584B7  2207: 8b5e06           mov bx, word ptr [bp + 6]
  0584BA  220A: 3a872c94         cmp al, byte ptr [bx - 0x6bd4]
  0584BE  220E: 7306             jae 0x2216
  0584C0  2210: c7865aff0000     mov word ptr [bp - 0xa6], 0
  0584C6  2216: 83be5aff00       cmp word ptr [bp - 0xa6], 0
  0584CB  221B: 7406             je 0x2223
  0584CD  221D: c7862eff0100     mov word ptr [bp - 0xd2], 1
  0584D3  2223: 8b865aff         mov ax, word ptr [bp - 0xa6]
  0584D7  2227: 89866eff         mov word ptr [bp - 0x92], ax
  0584DB  222B: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  0584DF  222F: 8a874731         mov al, byte ptr [bx + 0x3147]
  0584E3  2233: 240f             and al, 0xf
  0584E5  2235: 3a4608           cmp al, byte ptr [bp + 8]
  0584E8  2238: 7403             je 0x223d
  0584EA  223A: e92301           jmp 0x2360
  0584ED  223D: 6aff             push -1
  0584EF  223F: ff7608           push word ptr [bp + 8]
  0584F2  2242: 8a874531         mov al, byte ptr [bx + 0x3145]
  0584F6  2246: 2ae4             sub ah, ah
  0584F8  2248: 50               push ax
  0584F9  2249: 8a874431         mov al, byte ptr [bx + 0x3144]
  0584FD  224D: 50               push ax
  0584FE  224E: 8bf3             mov si, bx
  058500  2250: 9a14061f18       lcall 0x181f, 0x614
  058505  2255: 83c408           add sp, 8
  058508  2258: 89469e           mov word ptr [bp - 0x62], ax
  05850B  225B: 8b5e0c           mov bx, word ptr [bp + 0xc]
  05850E  225E: 8a87b400         mov al, byte ptr [bx + 0xb4]
  058512  2262: 98               cwde 
  058513  2263: 8a8c4431         mov cl, byte ptr [si + 0x3144]
  058517  2267: 2aed             sub ch, ch
  058519  2269: 03c8             add cx, ax
  05851B  226B: 898e5cff         mov word ptr [bp - 0xa4], cx
  05851F  226F: 8a87be00         mov al, byte ptr [bx + 0xbe]
  058523  2273: 98               cwde 
  058524  2274: 8a944531         mov dl, byte ptr [si + 0x3145]
  058528  2278: 2af6             sub dh, dh
  05852A  227A: 03d0             add dx, ax
  05852C  227C: 899656ff         mov word ptr [bp - 0xaa], dx
  058530  2280: 52               push dx
  058531  2281: 51               push cx
  058532  2282: 9abe071f18       lcall 0x181f, 0x7be
  058537  2287: 83c404           add sp, 4
  05853A  228A: 89863cff         mov word ptr [bp - 0xc4], ax
  05853E  228E: 0bc0             or ax, ax
  058540  2290: 7d03             jge 0x2295
  058542  2292: e9cb00           jmp 0x2360
  058545  2295: 837e9e00         cmp word ptr [bp - 0x62], 0
  058549  2299: 7d03             jge 0x229e
  05854B  229B: e9c200           jmp 0x2360
  05854E  229E: ff769e           push word ptr [bp - 0x62]
  058551  22A1: 9ae6091f18       lcall 0x181f, 0x9e6
  058556  22A6: 83c402           add sp, 2
  058559  22A9: 9a3a0d1f18       lcall 0x181f, 0xd3a
  05855E  22AE: 898630ff         mov word ptr [bp - 0xd0], ax
  058562  22B2: 8b863cff         mov ax, word ptr [bp - 0xc4]
  058566  22B6: 89867aff         mov word ptr [bp - 0x86], ax
  05856A  22BA: 50               push ax
  05856B  22BB: 9ae6091f18       lcall 0x181f, 0x9e6
  058570  22C0: 83c402           add sp, 2
  058573  22C3: 8b469a           mov ax, word ptr [bp - 0x66]
  058576  22C6: b90a00           mov cx, 0xa
  058579  22C9: 99               cdq 
  05857A  22CA: f7f9             idiv cx
  05857C  22CC: 89866cff         mov word ptr [bp - 0x94], ax
  058580  22D0: 8a0ea653         mov cl, byte ptr [0x53a6]
  058584  22D4: 2aed             sub ch, ch
  058586  22D6: 49               dec cx
  058587  22D7: 49               dec cx
  058588  22D8: f7e9             imul cx
  05858A  22DA: 8b4e9a           mov cx, word ptr [bp - 0x66]
  05858D  22DD: d1f9             sar cx, 1
  05858F  22DF: 03c1             add ax, cx
  058591  22E1: 898642ff         mov word ptr [bp - 0xbe], ax
  058595  22E5: 2bc0             sub ax, ax
  058597  22E7: 898640ff         mov word ptr [bp - 0xc0], ax
  05859B  22EB: 89865eff         mov word ptr [bp - 0xa2], ax
  05859F  22EF: eb68             jmp 0x2359
  0585A1  22F1: 90               nop 
  0585A2  22F2: 8b8630ff         mov ax, word ptr [bp - 0xd0]
  0585A6  22F6: 6b5e9e65         imul bx, word ptr [bp - 0x62], 0x65
  0585AA  22FA: 039e5eff         add bx, word ptr [bp - 0xa2]
  0585AE  22FE: d1e3             shl bx, 1
  0585B0  2300: 2b87e05d         sub ax, word ptr [bx + 0x5de0]
  0585B4  2304: 8bb65eff         mov si, word ptr [bp - 0xa2]
  0585B8  2308: d1e6             shl si, 1
  0585BA  230A: 8b1e4285         mov bx, word ptr [0x8542]
  0585BE  230E: 3b809a00         cmp ax, word ptr [bx + si + 0x9a]
  0585C2  2312: 7e04             jle 0x2318
  0585C4  2314: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  0585C8  2318: 89864cff         mov word ptr [bp - 0xb4], ax
  0585CC  231C: 8b7608           mov si, word ptr [bp + 8]
  0585CF  231F: c1e604           shl si, 4
  0585D2  2322: 8b9e5eff         mov bx, word ptr [bp - 0xa2]
  0585D6  2326: 8a88bc84         mov cl, byte ptr [bx + si - 0x7b44]
  0585DA  232A: 2aed             sub ch, ch
  0585DC  232C: f7e9             imul cx
  0585DE  232E: 89469c           mov word ptr [bp - 0x64], ax
  0585E1  2331: 3b8642ff         cmp ax, word ptr [bp - 0xbe]
  0585E5  2335: 7c1e             jl 0x2355
  0585E7  2337: 8b8640ff         mov ax, word ptr [bp - 0xc0]
  0585EB  233B: 39469c           cmp word ptr [bp - 0x64], ax
  0585EE  233E: 7c15             jl 0x2355
  0585F0  2340: 8b469c           mov ax, word ptr [bp - 0x64]
  0585F3  2343: 898640ff         mov word ptr [bp - 0xc0], ax
  0585F7  2347: 8bc3             mov ax, bx
  0585F9  2349: 89864eff         mov word ptr [bp - 0xb2], ax
  0585FD  234D: 8b864cff         mov ax, word ptr [bp - 0xb4]
  058601  2351: 898678ff         mov word ptr [bp - 0x88], ax
  058605  2355: ff865eff         inc word ptr [bp - 0xa2]
  058609  2359: 83be5eff10       cmp word ptr [bp - 0xa2], 0x10
  05860E  235E: 7c92             jl 0x22f2
  058610  2360: c78648ff0000     mov word ptr [bp - 0xb8], 0
  058616  2366: 83be54ff00       cmp word ptr [bp - 0xac], 0
  05861B  236B: 7406             je 0x2373
  05861D  236D: c78648fffeff     mov word ptr [bp - 0xb8], 0xfffe
  058623  2373: c78638ffffff     mov word ptr [bp - 0xc8], 0xffff
  058629  2379: c7865eff0000     mov word ptr [bp - 0xa2], 0
  05862F  237F: ffb65eff         push word ptr [bp - 0xa2]
  058633  2383: 9a420a1f18       lcall 0x181f, 0xa42
  058638  2388: 83c402           add sp, 2
  05863B  238B: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  05863F  238F: f6470380         test byte ptr [bx + 3], 0x80
  058643  2393: 7579             jne 0x240e
  058645  2395: ff7608           push word ptr [bp + 8]
  058648  2398: ffb65eff         push word ptr [bp - 0xa2]
  05864C  239C: 9a0c031f18       lcall 0x181f, 0x30c
  058651  23A1: 83c404           add sp, 4
  058654  23A4: 3d4b00           cmp ax, 0x4b
  058657  23A7: 7d17             jge 0x23c0
  058659  23A9: 8b865eff         mov ax, word ptr [bp - 0xa2]
  05865D  23AD: 050400           add ax, 4
  058660  23B0: 50               push ax
  058661  23B1: ff7606           push word ptr [bp + 6]
  058664  23B4: 9a380a1f18       lcall 0x181f, 0xa38
  058669  23B9: 83c404           add sp, 4
  05866C  23BC: a802             test al, 2
  05866E  23BE: 744e             je 0x240e
  058670  23C0: 8b9e5eff         mov bx, word ptr [bp - 0xa2]
  058674  23C4: 8a878491         mov al, byte ptr [bx - 0x6e7c]
  058678  23C8: 2ae4             sub ah, ah
  05867A  23CA: 8b5e08           mov bx, word ptr [bp + 8]
  05867D  23CD: d1e3             shl bx, 1
  05867F  23CF: 39871c94         cmp word ptr [bx - 0x6be4], ax
  058683  23D3: 7d04             jge 0x23d9
  058685  23D5: ff8648ff         inc word ptr [bp - 0xb8]
  058689  23D9: ff8648ff         inc word ptr [bp - 0xb8]
  05868D  23DD: ff7606           push word ptr [bp + 6]
  058690  23E0: ffb65eff         push word ptr [bp - 0xa2]
  058694  23E4: 9a0c031f18       lcall 0x181f, 0x30c
  058699  23E9: 83c404           add sp, 4
  05869C  23EC: 3d4b00           cmp ax, 0x4b
  05869F  23EF: 7d1d             jge 0x240e
  0586A1  23F1: 8b865eff         mov ax, word ptr [bp - 0xa2]
  0586A5  23F5: 050400           add ax, 4
  0586A8  23F8: 50               push ax
  0586A9  23F9: ff7606           push word ptr [bp + 6]
  0586AC  23FC: 8bf0             mov si, ax
  0586AE  23FE: 9a380a1f18       lcall 0x181f, 0xa38
  0586B3  2403: 83c404           add sp, 4
  0586B6  2406: a802             test al, 2
  0586B8  2408: 7504             jne 0x240e
  0586BA  240A: 89b638ff         mov word ptr [bp - 0xc8], si
  0586BE  240E: ff865eff         inc word ptr [bp - 0xa2]
  0586C2  2412: 83be5eff08       cmp word ptr [bp - 0xa2], 8
  0586C7  2417: 7d03             jge 0x241c
  0586C9  2419: e963ff           jmp 0x237f
  0586CC  241C: c7865eff0000     mov word ptr [bp - 0xa2], 0
  0586D2  2422: 8b4606           mov ax, word ptr [bp + 6]
  0586D5  2425: 39865eff         cmp word ptr [bp - 0xa2], ax
  0586D9  2429: 7477             je 0x24a2
  0586DB  242B: 8b4608           mov ax, word ptr [bp + 8]
  0586DE  242E: 39865eff         cmp word ptr [bp - 0xa2], ax
  0586E2  2432: 746e             je 0x24a2
  0586E4  2434: a1d253           mov ax, word ptr [0x53d2]
  0586E7  2437: 39865eff         cmp word ptr [bp - 0xa2], ax
  0586EB  243B: 7465             je 0x24a2
  0586ED  243D: ffb65eff         push word ptr [bp - 0xa2]
  0586F1  2441: ff7608           push word ptr [bp + 8]
  0586F4  2444: 9a380a1f18       lcall 0x181f, 0xa38
  0586F9  2449: 83c404           add sp, 4
  0586FC  244C: 2460             and al, 0x60
  0586FE  244E: 3c20             cmp al, 0x20
  058700  2450: 7550             jne 0x24a2
  058702  2452: 8b9e5eff         mov bx, word ptr [bp - 0xa2]
  058706  2456: d1e3             shl bx, 1
  058708  2458: 8b871c94         mov ax, word ptr [bx - 0x6be4]
  05870C  245C: c1e002           shl ax, 2
  05870F  245F: 8b5e08           mov bx, word ptr [bp + 8]
  058712  2462: d1e3             shl bx, 1
  058714  2464: 3b871c94         cmp ax, word ptr [bx - 0x6be4]
  058718  2468: 7e04             jle 0x246e
  05871A  246A: ff8648ff         inc word ptr [bp - 0xb8]
  05871E  246E: 8b5e08           mov bx, word ptr [bp + 8]
  058721  2471: d1e3             shl bx, 1
  058723  2473: 8b871c94         mov ax, word ptr [bx - 0x6be4]
  058727  2477: 8b9e5eff         mov bx, word ptr [bp - 0xa2]
  05872B  247B: d1e3             shl bx, 1
  05872D  247D: 39871c94         cmp word ptr [bx - 0x6be4], ax
  058731  2481: 7604             jbe 0x2487
  058733  2483: ff8648ff         inc word ptr [bp - 0xb8]
  058737  2487: ffb65eff         push word ptr [bp - 0xa2]
  05873B  248B: ff7606           push word ptr [bp + 6]
  05873E  248E: 9a380a1f18       lcall 0x181f, 0xa38
  058743  2493: 83c404           add sp, 4
  058746  2496: a840             test al, 0x40
  058748  2498: 7408             je 0x24a2
  05874A  249A: 8b865eff         mov ax, word ptr [bp - 0xa2]
  05874E  249E: 898638ff         mov word ptr [bp - 0xc8], ax
  058752  24A2: ff865eff         inc word ptr [bp - 0xa2]
  058756  24A6: 83be5eff04       cmp word ptr [bp - 0xa2], 4
  05875B  24AB: 7d03             jge 0x24b0
  05875D  24AD: e972ff           jmp 0x2422
  058760  24B0: 8b5e08           mov bx, word ptr [bp + 8]
  058763  24B3: 8bc3             mov ax, bx
  058765  24B5: d1e3             shl bx, 1
  058767  24B7: 03d8             add bx, ax
  058769  24B9: 8a876695         mov al, byte ptr [bx - 0x6a9a]
  05876D  24BD: 98               cwde 
  05876E  24BE: 298648ff         sub word ptr [bp - 0xb8], ax
  058772  24C2: 8b5e06           mov bx, word ptr [bp + 6]
  058775  24C5: d1e3             shl bx, 1
  058777  24C7: 8b871c94         mov ax, word ptr [bx - 0x6be4]
  05877B  24CB: 8b5e08           mov bx, word ptr [bp + 8]
  05877E  24CE: d1e3             shl bx, 1
  058780  24D0: 39871c94         cmp word ptr [bx - 0x6be4], ax
  058784  24D4: 7604             jbe 0x24da
  058786  24D6: ff8e48ff         dec word ptr [bp - 0xb8]
  05878A  24DA: 837ef600         cmp word ptr [bp - 0xa], 0
  05878E  24DE: 7538             jne 0x2518
  058790  24E0: ff7608           push word ptr [bp + 8]
  058793  24E3: ff7606           push word ptr [bp + 6]
  058796  24E6: 9a380a1f18       lcall 0x181f, 0xa38
  05879B  24EB: 83c404           add sp, 4
  05879E  24EE: 254000           and ax, 0x40
  0587A1  24F1: 3d0100           cmp ax, 1
  0587A4  24F4: 1bc0             sbb ax, ax
  0587A6  24F6: f7d8             neg ax
  0587A8  24F8: 3b8648ff         cmp ax, word ptr [bp - 0xb8]
  0587AC  24FC: 7d1a             jge 0x2518
  0587AE  24FE: 6a01             push 1
  0587B0  2500: 2bc0             sub ax, ax
  0587B2  2502: 89865aff         mov word ptr [bp - 0xa6], ax
  0587B6  2506: 50               push ax
  0587B7  2507: 9ad4041f18       lcall 0x181f, 0x4d4
  0587BC  250C: 83c404           add sp, 4
  0587BF  250F: 0bc0             or ax, ax
  0587C1  2511: 7405             je 0x2518
  0587C3  2513: c7469a0000       mov word ptr [bp - 0x66], 0
  0587C8  2518: 837e0e00         cmp word ptr [bp + 0xe], 0
  0587CC  251C: 7523             jne 0x2541
  0587CE  251E: 83be5aff00       cmp word ptr [bp - 0xa6], 0
  0587D3  2523: 751c             jne 0x2541
  0587D5  2525: 83be34ff00       cmp word ptr [bp - 0xcc], 0
  0587DA  252A: 7415             je 0x2541
  0587DC  252C: ff7608           push word ptr [bp + 8]
  0587DF  252F: ff7606           push word ptr [bp + 6]
  0587E2  2532: 9a380a1f18       lcall 0x181f, 0xa38
  0587E7  2537: 83c404           add sp, 4
  0587EA  253A: a840             test al, 0x40
  0587EC  253C: 7403             je 0x2541
  0587EE  253E: e9fd12           jmp 0x383e
  0587F1  2541: 83be5aff00       cmp word ptr [bp - 0xa6], 0
  0587F6  2546: 743d             je 0x2585
  0587F8  2548: ff7608           push word ptr [bp + 8]
  0587FB  254B: ff7606           push word ptr [bp + 6]
  0587FE  254E: 9a380a1f18       lcall 0x181f, 0xa38
  058803  2553: 83c404           add sp, 4
  058806  2556: a840             test al, 0x40
  058808  2558: 742b             je 0x2585
  05880A  255A: 83be54ff00       cmp word ptr [bp - 0xac], 0
  05880F  255F: 7514             jne 0x2575
  058811  2561: 8b5e06           mov bx, word ptr [bp + 6]
  058814  2564: d1e3             shl bx, 1
  058816  2566: 8b871c94         mov ax, word ptr [bx - 0x6be4]
  05881A  256A: 8b5e08           mov bx, word ptr [bp + 8]
  05881D  256D: d1e3             shl bx, 1
  05881F  256F: 39871c94         cmp word ptr [bx - 0x6be4], ax
  058823  2573: 7310             jae 0x2585
  058825  2575: c78652ff0100     mov word ptr [bp - 0xae], 1
  05882B  257B: 2bc0             sub ax, ax
  05882D  257D: 89865aff         mov word ptr [bp - 0xa6], ax
  058831  2581: 89862eff         mov word ptr [bp - 0xd2], ax
  058835  2585: 83be2eff00       cmp word ptr [bp - 0xd2], 0
  05883A  258A: 7506             jne 0x2592
  05883C  258C: 68b018           push 0x18b0
  05883F  258F: eb04             jmp 0x2595
  058841  2591: 90               nop 
  058842  2592: 68b518           push 0x18b5
  058845  2595: 8d4682           lea ax, [bp - 0x7e]
  058848  2598: 50               push ax
  058849  2599: 9ae4071d0d       lcall 0xd1d, 0x7e4
  05884E  259E: 83c404           add sp, 4
  058851  25A1: c646a600         mov byte ptr [bp - 0x5a], 0
  058855  25A5: 8a1ea653         mov bl, byte ptr [0x53a6]
  058859  25A9: 2aff             sub bh, bh
  05885B  25AB: d1e3             shl bx, 1
  05885D  25AD: ffb79483         push word ptr [bx - 0x7c6c]
  058861  25B1: 8d46a6           lea ax, [bp - 0x5a]
  058864  25B4: 50               push ax
  058865  25B5: 9a6e011f18       lcall 0x181f, 0x16e
  05886A  25BA: 83c404           add sp, 4
  05886D  25BD: 8d46a6           lea ax, [bp - 0x5a]
  058870  25C0: 50               push ax
  058871  25C1: 9a78011f18       lcall 0x181f, 0x178
  058876  25C6: 83c402           add sp, 2
  058879  25C9: 6b460634         imul ax, word ptr [bp + 6], 0x34
  05887D  25CD: 050e54           add ax, 0x540e
  058880  25D0: 50               push ax
  058881  25D1: 8d46a6           lea ax, [bp - 0x5a]
  058884  25D4: 50               push ax
  058885  25D5: 9aa4071d0d       lcall 0xd1d, 0x7a4
  05888A  25DA: 83c404           add sp, 4
  05888D  25DD: 8d46a6           lea ax, [bp - 0x5a]
  058890  25E0: 16               push ss
  058891  25E1: 50               push ax
  058892  25E2: 6a00             push 0
  058894  25E4: 9a16041f18       lcall 0x181f, 0x416
  058899  25E9: 83c406           add sp, 6
  05889C  25EC: 6b460834         imul ax, word ptr [bp + 8], 0x34
  0588A0  25F0: 052654           add ax, 0x5426
  0588A3  25F3: 1e               push ds
  0588A4  25F4: 50               push ax
  0588A5  25F5: 6a01             push 1
  0588A7  25F7: 9a16041f18       lcall 0x181f, 0x416
  0588AC  25FC: 83c406           add sp, 6
  0588AF  25FF: ff7608           push word ptr [bp + 8]
  0588B2  2602: 68bb18           push 0x18bb
  0588B5  2605: 6a02             push 2
  0588B7  2607: 0e               push cs
  0588B8  2608: e82a19           call 0x3f35
  0588BB  260B: 83c406           add sp, 6
  0588BE  260E: ff7608           push word ptr [bp + 8]
  0588C1  2611: 68c118           push 0x18c1
  0588C4  2614: 6a03             push 3
  0588C6  2616: 0e               push cs
  0588C7  2617: e81b19           call 0x3f35
  0588CA  261A: 83c406           add sp, 6
  0588CD  261D: 68c718           push 0x18c7
  0588D0  2620: 8d46a6           lea ax, [bp - 0x5a]
  0588D3  2623: 50               push ax
  0588D4  2624: 9ae4071d0d       lcall 0xd1d, 0x7e4
  0588D9  2629: 83c404           add sp, 4
  0588DC  262C: ff7608           push word ptr [bp + 8]
  0588DF  262F: ff7606           push word ptr [bp + 6]
  0588E2  2632: 9a380a1f18       lcall 0x181f, 0xa38
  0588E7  2637: 83c404           add sp, 4
  0588EA  263A: a820             test al, 0x20
  0588EC  263C: 751e             jne 0x265c
  0588EE  263E: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  0588F2  2642: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  0588F7  2647: 720d             jb 0x2656
  0588F9  2649: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  0588FE  264E: 7706             ja 0x2656
  058900  2650: 68cd18           push 0x18cd
  058903  2653: eb0b             jmp 0x2660
  058905  2655: 90               nop 
  058906  2656: 68d218           push 0x18d2
  058909  2659: eb05             jmp 0x2660
  05890B  265B: 90               nop 
  05890C  265C: 8d4682           lea ax, [bp - 0x7e]
  05890F  265F: 50               push ax
  058910  2660: 8d46a6           lea ax, [bp - 0x5a]
  058913  2663: 50               push ax
  058914  2664: 9aa4071d0d       lcall 0xd1d, 0x7a4
  058919  2669: 83c404           add sp, 4
  05891C  266C: 83be66ff00       cmp word ptr [bp - 0x9a], 0
  058921  2671: 740f             je 0x2682
  058923  2673: 68d818           push 0x18d8
  058926  2676: 8d46a6           lea ax, [bp - 0x5a]
  058929  2679: 50               push ax
  05892A  267A: 9ae4071d0d       lcall 0xd1d, 0x7e4
  05892F  267F: 83c404           add sp, 4
  058932  2682: ff7608           push word ptr [bp + 8]
  058935  2685: 8d46a6           lea ax, [bp - 0x5a]
  058938  2688: 50               push ax
  058939  2689: 9a88061f1a       lcall 0x1a1f, 0x688
  05893E  268E: 83c404           add sp, 4
  058941  2691: 83be38ff00       cmp word ptr [bp - 0xc8], 0
  058946  2696: 7d03             jge 0x269b
  058948  2698: e94e01           jmp 0x27e9
  05894B  269B: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  058950  26A0: 7403             je 0x26a5
  058952  26A2: e94401           jmp 0x27e9
  058955  26A5: ffb638ff         push word ptr [bp - 0xc8]
  058959  26A9: ff7606           push word ptr [bp + 6]
  05895C  26AC: 9a380a1f18       lcall 0x181f, 0xa38
  058961  26B1: 83c404           add sp, 4
  058964  26B4: a820             test al, 0x20
  058966  26B6: 7503             jne 0x26bb
  058968  26B8: e92e01           jmp 0x27e9
  05896B  26BB: ffb638ff         push word ptr [bp - 0xc8]
  05896F  26BF: 9aa4091f18       lcall 0x181f, 0x9a4
  058974  26C4: 83c402           add sp, 2
  058977  26C7: 50               push ax
  058978  26C8: 6a00             push 0
  05897A  26CA: 9a38041f18       lcall 0x181f, 0x438
  05897F  26CF: 83c404           add sp, 4
  058982  26D2: 83be38ff04       cmp word ptr [bp - 0xc8], 4
  058987  26D7: 7d37             jge 0x2710
  058989  26D9: 68e118           push 0x18e1
  05898C  26DC: 8d46a6           lea ax, [bp - 0x5a]
  05898F  26DF: 50               push ax
  058990  26E0: 9ae4071d0d       lcall 0xd1d, 0x7e4
  058995  26E5: 83c404           add sp, 4
  058998  26E8: 83be2eff01       cmp word ptr [bp - 0xd2], 1
  05899D  26ED: 1bc0             sbb ax, ax
  05899F  26EF: f7d8             neg ax
  0589A1  26F1: 50               push ax
  0589A2  26F2: 6a01             push 1
  0589A4  26F4: 0e               push cs
  0589A5  26F5: e84c18           call 0x3f44
  0589A8  26F8: 83c404           add sp, 4
  0589AB  26FB: 83be66ff00       cmp word ptr [bp - 0x9a], 0
  0589B0  2700: 7477             je 0x2779
  0589B2  2702: 68e817           push 0x17e8
  0589B5  2705: 8d46a6           lea ax, [bp - 0x5a]
  0589B8  2708: 50               push ax
  0589B9  2709: 9aa4071d0d       lcall 0xd1d, 0x7a4
  0589BE  270E: eb66             jmp 0x2776
  0589C0  2710: 68eb18           push 0x18eb
  0589C3  2713: 8d46a6           lea ax, [bp - 0x5a]
  0589C6  2716: 50               push ax
  0589C7  2717: 9ae4071d0d       lcall 0xd1d, 0x7e4
  0589CC  271C: 83c404           add sp, 4
  0589CF  271F: ffb638ff         push word ptr [bp - 0xc8]
  0589D3  2723: 9aa4091f18       lcall 0x181f, 0x9a4
  0589D8  2728: 83c402           add sp, 2
  0589DB  272B: 50               push ax
  0589DC  272C: 6a01             push 1
  0589DE  272E: 9a38041f18       lcall 0x181f, 0x438
  0589E3  2733: 83c404           add sp, 4
  0589E6  2736: 83be66ff00       cmp word ptr [bp - 0x9a], 0
  0589EB  273B: 7425             je 0x2762
  0589ED  273D: 68e817           push 0x17e8
  0589F0  2740: 8d46a6           lea ax, [bp - 0x5a]
  0589F3  2743: 50               push ax
  0589F4  2744: 9aa4071d0d       lcall 0xd1d, 0x7a4
  0589F9  2749: 83c404           add sp, 4
  0589FC  274C: 6b460834         imul ax, word ptr [bp + 8], 0x34
  058A00  2750: 052654           add ax, 0x5426
  058A03  2753: 1e               push ds
  058A04  2754: 50               push ax
  058A05  2755: 6a00             push 0
  058A07  2757: 9a16041f18       lcall 0x181f, 0x416
  058A0C  275C: 83c406           add sp, 6
  058A0F  275F: eb18             jmp 0x2779
  058A11  2761: 90               nop 
  058A12  2762: ffb638ff         push word ptr [bp - 0xc8]
  058A16  2766: 9a1a0a1f18       lcall 0x181f, 0xa1a
  058A1B  276B: 83c402           add sp, 2
  058A1E  276E: 50               push ax
  058A1F  276F: 6a00             push 0
  058A21  2771: 9a38041f18       lcall 0x181f, 0x438
  058A26  2776: 83c404           add sp, 4
  058A29  2779: ff7608           push word ptr [bp + 8]
  058A2C  277C: 8d46a6           lea ax, [bp - 0x5a]
  058A2F  277F: 50               push ax
  058A30  2780: 9a88061f1a       lcall 0x1a1f, 0x688
  058A35  2785: 83c404           add sp, 4
  058A38  2788: 8946f8           mov word ptr [bp - 8], ax
  058A3B  278B: 3d0200           cmp ax, 2
  058A3E  278E: 7559             jne 0x27e9
  058A40  2790: 6a01             push 1
  058A42  2792: 2bc0             sub ax, ax
  058A44  2794: 89865aff         mov word ptr [bp - 0xa6], ax
  058A48  2798: 50               push ax
  058A49  2799: 9ad4041f18       lcall 0x181f, 0x4d4
  058A4E  279E: 83c404           add sp, 4
  058A51  27A1: 0bc0             or ax, ax
  058A53  27A3: 7405             je 0x27aa
  058A55  27A5: c7469a0000       mov word ptr [bp - 0x66], 0
  058A5A  27AA: 83be38ff04       cmp word ptr [bp - 0xc8], 4
  058A5F  27AF: 7d21             jge 0x27d2
  058A61  27B1: 6a40             push 0x40
  058A63  27B3: ffb638ff         push word ptr [bp - 0xc8]
  058A67  27B7: ff7606           push word ptr [bp + 6]
  058A6A  27BA: 9a100a1f18       lcall 0x181f, 0xa10
  058A6F  27BF: 83c406           add sp, 6
  058A72  27C2: 69b638ff3c01     imul si, word ptr [bp - 0xc8], 0x13c
  058A78  27C8: 8b5e06           mov bx, word ptr [bp + 6]
  058A7B  27CB: 80883c8802       or byte ptr [bx + si - 0x77c4], 2
  058A80  27D0: eb17             jmp 0x27e9
  058A82  27D2: 6a00             push 0
  058A84  27D4: 6a64             push 0x64
  058A86  27D6: ff7606           push word ptr [bp + 6]
  058A89  27D9: 8b8638ff         mov ax, word ptr [bp - 0xc8]
  058A8D  27DD: 2d0400           sub ax, 4
  058A90  27E0: 50               push ax
  058A91  27E1: 9a6c0d1f18       lcall 0x181f, 0xd6c
  058A96  27E6: 83c408           add sp, 8
  058A99  27E9: ff7606           push word ptr [bp + 6]
  058A9C  27EC: ff7608           push word ptr [bp + 8]
  058A9F  27EF: 9a380a1f18       lcall 0x181f, 0xa38
  058AA4  27F4: 83c404           add sp, 4
  058AA7  27F7: a880             test al, 0x80
  058AA9  27F9: 7503             jne 0x27fe
  058AAB  27FB: e96c01           jmp 0x296a
  058AAE  27FE: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  058AB3  2803: 7403             je 0x2808
  058AB5  2805: e96201           jmp 0x296a
  058AB8  2808: 6b5e0613         imul bx, word ptr [bp + 6], 0x13
  058ABC  280C: 80bf5c9200       cmp byte ptr [bx - 0x6da4], 0
  058AC1  2811: 7503             jne 0x2816
  058AC3  2813: e95401           jmp 0x296a
  058AC6  2816: ff7608           push word ptr [bp + 8]
  058AC9  2819: 68f318           push 0x18f3
  058ACC  281C: 6a00             push 0
  058ACE  281E: 0e               push cs
  058ACF  281F: e81317           call 0x3f35
  058AD2  2822: 83c406           add sp, 6
  058AD5  2825: ff7606           push word ptr [bp + 6]
  058AD8  2828: 9aa4091f18       lcall 0x181f, 0x9a4
  058ADD  282D: 83c402           add sp, 2
  058AE0  2830: 50               push ax
  058AE1  2831: 6a01             push 1
  058AE3  2833: 9a38041f18       lcall 0x181f, 0x438
  058AE8  2838: 83c404           add sp, 4
  058AEB  283B: 6b460834         imul ax, word ptr [bp + 8], 0x34
  058AEF  283F: 052654           add ax, 0x5426
  058AF2  2842: 1e               push ds
  058AF3  2843: 50               push ax
  058AF4  2844: 6a02             push 2
  058AF6  2846: 8bf0             mov si, ax
  058AF8  2848: 9a16041f18       lcall 0x181f, 0x416
  058AFD  284D: 83c406           add sp, 6
  058B00  2850: ffb62eff         push word ptr [bp - 0xd2]
  058B04  2854: 6a03             push 3
  058B06  2856: 0e               push cs
  058B07  2857: e8ea16           call 0x3f44
  058B0A  285A: 83c404           add sp, 4
  058B0D  285D: 68fa18           push 0x18fa
  058B10  2860: 8d46a6           lea ax, [bp - 0x5a]
  058B13  2863: 50               push ax
  058B14  2864: 9ae4071d0d       lcall 0xd1d, 0x7e4
  058B19  2869: 83c404           add sp, 4
  058B1C  286C: 83be66ff00       cmp word ptr [bp - 0x9a], 0
  058B21  2871: 741b             je 0x288e
  058B23  2873: 68e817           push 0x17e8
  058B26  2876: 8d46a6           lea ax, [bp - 0x5a]
  058B29  2879: 50               push ax
  058B2A  287A: 9aa4071d0d       lcall 0xd1d, 0x7a4
  058B2F  287F: 83c404           add sp, 4
  058B32  2882: 1e               push ds
  058B33  2883: 56               push si
  058B34  2884: 6a00             push 0
  058B36  2886: 9a16041f18       lcall 0x181f, 0x416
  058B3B  288B: 83c406           add sp, 6
  058B3E  288E: ff7608           push word ptr [bp + 8]
  058B41  2891: 8d46a6           lea ax, [bp - 0x5a]
  058B44  2894: 50               push ax
  058B45  2895: 9a88061f1a       lcall 0x1a1f, 0x688
  058B4A  289A: 83c404           add sp, 4
  058B4D  289D: 8946f8           mov word ptr [bp - 8], ax
  058B50  28A0: 3d0200           cmp ax, 2
  058B53  28A3: 7403             je 0x28a8
  058B55  28A5: e9c200           jmp 0x296a
  058B58  28A8: 8b460a           mov ax, word ptr [bp + 0xa]
  058B5B  28AB: 898658ff         mov word ptr [bp - 0xa8], ax
  058B5F  28AF: 2bc0             sub ax, ax
  058B61  28B1: 89866aff         mov word ptr [bp - 0x96], ax
  058B65  28B5: 89460a           mov word ptr [bp + 0xa], ax
  058B68  28B8: eb67             jmp 0x2921
  058B6A  28BA: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  058B6E  28BE: 8a874731         mov al, byte ptr [bx + 0x3147]
  058B72  28C2: 240f             and al, 0xf
  058B74  28C4: 3a4606           cmp al, byte ptr [bp + 6]
  058B77  28C7: 7555             jne 0x291e
  058B79  28C9: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  058B7D  28CD: 80bf463110       cmp byte ptr [bx + 0x3146], 0x10
  058B82  28D2: 754a             jne 0x291e
  058B84  28D4: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  058B88  28D8: 8a874431         mov al, byte ptr [bx + 0x3144]
  058B8C  28DC: 2a4606           sub al, byte ptr [bp + 6]
  058B8F  28DF: 3cec             cmp al, 0xec
  058B91  28E1: 7404             je 0x28e7
  058B93  28E3: ff866aff         inc word ptr [bp - 0x96]
  058B97  28E7: ff760a           push word ptr [bp + 0xa]
  058B9A  28EA: 9a20091f18       lcall 0x181f, 0x920
  058B9F  28EF: 83c402           add sp, 2
  058BA2  28F2: 8b4606           mov ax, word ptr [bp + 6]
  058BA5  28F5: 2d1400           sub ax, 0x14
  058BA8  28F8: 50               push ax
  058BA9  28F9: 50               push ax
  058BAA  28FA: ff760a           push word ptr [bp + 0xa]
  058BAD  28FD: 9a48091f18       lcall 0x181f, 0x948
  058BB2  2902: 83c406           add sp, 6
  058BB5  2905: 695e063c01       imul bx, word ptr [bp + 6], 0x13c
  058BBA  290A: 8a873a88         mov al, byte ptr [bx - 0x77c6]
  058BBE  290E: 6b760a1c         imul si, word ptr [bp + 0xa], 0x1c
  058BC2  2912: 88844d31         mov byte ptr [si + 0x314d], al
  058BC6  2916: 8a873b88         mov al, byte ptr [bx - 0x77c5]
  058BCA  291A: 88844e31         mov byte ptr [si + 0x314e], al
  058BCE  291E: ff460a           inc word ptr [bp + 0xa]
  058BD1  2921: a19c53           mov ax, word ptr [0x539c]
  058BD4  2924: 39460a           cmp word ptr [bp + 0xa], ax
  058BD7  2927: 7c91             jl 0x28ba
  058BD9  2929: 6976083c01       imul si, word ptr [bp + 8], 0x13c
  058BDE  292E: 8b5e06           mov bx, word ptr [bp + 6]
  058BE1  2931: 80a03c887f       and byte ptr [bx + si - 0x77c4], 0x7f
  058BE6  2936: 83be6aff00       cmp word ptr [bp - 0x96], 0
  058BEB  293B: 7418             je 0x2955
  058BED  293D: ffb66aff         push word ptr [bp - 0x96]
  058BF1  2941: 6a00             push 0
  058BF3  2943: 9ad4041f18       lcall 0x181f, 0x4d4
  058BF8  2948: 83c404           add sp, 4
  058BFB  294B: 0bc0             or ax, ax
  058BFD  294D: 7406             je 0x2955
  058BFF  294F: c7865aff0000     mov word ptr [bp - 0xa6], 0
  058C05  2955: 8b8e6aff         mov cx, word ptr [bp - 0x96]
  058C09  2959: 41               inc cx
  058C0A  295A: 8b469a           mov ax, word ptr [bp - 0x66]
  058C0D  295D: 99               cdq 
  058C0E  295E: f7f9             idiv cx
  058C10  2960: 89469a           mov word ptr [bp - 0x66], ax
  058C13  2963: 8b8658ff         mov ax, word ptr [bp - 0xa8]
  058C17  2967: 89460a           mov word ptr [bp + 0xa], ax
  058C1A  296A: 83be64ff00       cmp word ptr [bp - 0x9c], 0
  058C1F  296F: 7403             je 0x2974
  058C21  2971: e9e001           jmp 0x2b54
  058C24  2974: 8b5e08           mov bx, word ptr [bp + 8]
  058C27  2977: 8a870c94         mov al, byte ptr [bx - 0x6bf4]
  058C2B  297B: c0e802           shr al, 2
  058C2E  297E: 2ae4             sub ah, ah
  058C30  2980: 3b46fa           cmp ax, word ptr [bp - 6]
  058C33  2983: 7e1c             jle 0x29a1
  058C35  2985: 837efa0c         cmp word ptr [bp - 6], 0xc
  058C39  2989: 7f03             jg 0x298e
  058C3B  298B: e9c601           jmp 0x2b54
  058C3E  298E: 6a04             push 4
  058C40  2990: 6a00             push 0
  058C42  2992: 9ad4041f18       lcall 0x181f, 0x4d4
  058C47  2997: 83c404           add sp, 4
  058C4A  299A: 0bc0             or ax, ax
  058C4C  299C: 7403             je 0x29a1
  058C4E  299E: e9b301           jmp 0x2b54
  058C51  29A1: ff7608           push word ptr [bp + 8]
  058C54  29A4: 680119           push 0x1901
  058C57  29A7: 6a00             push 0
  058C59  29A9: 0e               push cs
  058C5A  29AA: e88815           call 0x3f35
  058C5D  29AD: 83c406           add sp, 6
  058C60  29B0: ff7606           push word ptr [bp + 6]
  058C63  29B3: 9aa4091f18       lcall 0x181f, 0x9a4
  058C68  29B8: 83c402           add sp, 2
  058C6B  29BB: 50               push ax
  058C6C  29BC: 6a01             push 1
  058C6E  29BE: 9a38041f18       lcall 0x181f, 0x438
  058C73  29C3: 83c404           add sp, 4
  058C76  29C6: ff7608           push word ptr [bp + 8]
  058C79  29C9: 9aa4091f18       lcall 0x181f, 0x9a4
  058C7E  29CE: 83c402           add sp, 2
  058C81  29D1: 50               push ax
  058C82  29D2: 6a02             push 2
  058C84  29D4: 9a38041f18       lcall 0x181f, 0x438
  058C89  29D9: 83c404           add sp, 4
  058C8C  29DC: ffb62eff         push word ptr [bp - 0xd2]
  058C90  29E0: 6a03             push 3
  058C92  29E2: 0e               push cs
  058C93  29E3: e85e15           call 0x3f44
  058C96  29E6: 83c404           add sp, 4
  058C99  29E9: 680819           push 0x1908
  058C9C  29EC: 8d46a6           lea ax, [bp - 0x5a]
  058C9F  29EF: 50               push ax
  058CA0  29F0: 9ae4071d0d       lcall 0xd1d, 0x7e4
  058CA5  29F5: 83c404           add sp, 4
  058CA8  29F8: 83be66ff00       cmp word ptr [bp - 0x9a], 0
  058CAD  29FD: 7422             je 0x2a21
  058CAF  29FF: 68e817           push 0x17e8
  058CB2  2A02: 8d46a6           lea ax, [bp - 0x5a]
  058CB5  2A05: 50               push ax
  058CB6  2A06: 9aa4071d0d       lcall 0xd1d, 0x7a4
  058CBB  2A0B: 83c404           add sp, 4
  058CBE  2A0E: 6b460834         imul ax, word ptr [bp + 8], 0x34
  058CC2  2A12: 052654           add ax, 0x5426
  058CC5  2A15: 1e               push ds
  058CC6  2A16: 50               push ax
  058CC7  2A17: 6a00             push 0
  058CC9  2A19: 9a16041f18       lcall 0x181f, 0x416
  058CCE  2A1E: 83c406           add sp, 6
  058CD1  2A21: ff7608           push word ptr [bp + 8]
  058CD4  2A24: 8d46a6           lea ax, [bp - 0x5a]
  058CD7  2A27: 50               push ax
  058CD8  2A28: 9a88061f1a       lcall 0x1a1f, 0x688
  058CDD  2A2D: 83c404           add sp, 4
  058CE0  2A30: 8946f8           mov word ptr [bp - 8], ax
  058CE3  2A33: 3d0200           cmp ax, 2
  058CE6  2A36: 7403             je 0x2a3b
  058CE8  2A38: e91901           jmp 0x2b54
  058CEB  2A3B: 6b46fa9c         imul ax, word ptr [bp - 6], -0x64
  058CEF  2A3F: 01469a           add word ptr [bp - 0x66], ax
  058CF2  2A42: 8b469a           mov ax, word ptr [bp - 0x66]
  058CF5  2A45: 0bc0             or ax, ax
  058CF7  2A47: 7d02             jge 0x2a4b
  058CF9  2A49: 2bc0             sub ax, ax
  058CFB  2A4B: 89469a           mov word ptr [bp - 0x66], ax
  058CFE  2A4E: c78644ff0100     mov word ptr [bp - 0xbc], 1
  058D04  2A54: 2bc0             sub ax, ax
  058D06  2A56: 89865aff         mov word ptr [bp - 0xa6], ax
  058D0A  2A5A: 89460a           mov word ptr [bp + 0xa], ax
  058D0D  2A5D: eb7a             jmp 0x2ad9
  058D0F  2A5F: 90               nop 
  058D10  2A60: 83be72ff08       cmp word ptr [bp - 0x8e], 8
  058D15  2A65: 7d3c             jge 0x2aa3
  058D17  2A67: 8b9e72ff         mov bx, word ptr [bp - 0x8e]
  058D1B  2A6B: 8a87be00         mov al, byte ptr [bx + 0xbe]
  058D1F  2A6F: 98               cwde 
  058D20  2A70: 038660ff         add ax, word ptr [bp - 0xa0]
  058D24  2A74: 8946a2           mov word ptr [bp - 0x5e], ax
  058D27  2A77: 50               push ax
  058D28  2A78: 8a87b400         mov al, byte ptr [bx + 0xb4]
  058D2C  2A7C: 98               cwde 
  058D2D  2A7D: 038668ff         add ax, word ptr [bp - 0x98]
  058D31  2A81: 8946fe           mov word ptr [bp - 2], ax
  058D34  2A84: 50               push ax
  058D35  2A85: 9a96061f18       lcall 0x181f, 0x696
  058D3A  2A8A: 83c404           add sp, 4
  058D3D  2A8D: 3b4608           cmp ax, word ptr [bp + 8]
  058D40  2A90: 7506             jne 0x2a98
  058D42  2A92: c7867eff0100     mov word ptr [bp - 0x82], 1
  058D48  2A98: ff8672ff         inc word ptr [bp - 0x8e]
  058D4C  2A9C: 83be7eff00       cmp word ptr [bp - 0x82], 0
  058D51  2AA1: 74bd             je 0x2a60
  058D53  2AA3: 83be7eff00       cmp word ptr [bp - 0x82], 0
  058D58  2AA8: 742c             je 0x2ad6
  058D5A  2AAA: 8b4606           mov ax, word ptr [bp + 6]
  058D5D  2AAD: 2d1400           sub ax, 0x14
  058D60  2AB0: 50               push ax
  058D61  2AB1: 50               push ax
  058D62  2AB2: ff760a           push word ptr [bp + 0xa]
  058D65  2AB5: 9a80081f18       lcall 0x181f, 0x880
  058D6A  2ABA: 83c406           add sp, 6
  058D6D  2ABD: 695e063c01       imul bx, word ptr [bp + 6], 0x13c
  058D72  2AC2: 8a873a88         mov al, byte ptr [bx - 0x77c6]
  058D76  2AC6: 6b760a1c         imul si, word ptr [bp + 0xa], 0x1c
  058D7A  2ACA: 88844d31         mov byte ptr [si + 0x314d], al
  058D7E  2ACE: 8a873b88         mov al, byte ptr [bx - 0x77c5]
  058D82  2AD2: 88844e31         mov byte ptr [si + 0x314e], al
  058D86  2AD6: ff460a           inc word ptr [bp + 0xa]
  058D89  2AD9: a19c53           mov ax, word ptr [0x539c]
  058D8C  2ADC: 39460a           cmp word ptr [bp + 0xa], ax
  058D8F  2ADF: 7d73             jge 0x2b54
  058D91  2AE1: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  058D95  2AE5: 8a874731         mov al, byte ptr [bx + 0x3147]
  058D99  2AE9: 240f             and al, 0xf
  058D9B  2AEB: 3a4606           cmp al, byte ptr [bp + 6]
  058D9E  2AEE: 75e6             jne 0x2ad6
  058DA0  2AF0: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  058DA4  2AF4: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  058DA9  2AF9: 7207             jb 0x2b02
  058DAB  2AFB: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  058DB0  2B00: 76d4             jbe 0x2ad6
  058DB2  2B02: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  058DB6  2B06: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  058DBA  2B0A: 2aff             sub bh, bh
  058DBC  2B0C: 8bc3             mov ax, bx
  058DBE  2B0E: d1e3             shl bx, 1
  058DC0  2B10: 03d8             add bx, ax
  058DC2  2B12: d1e3             shl bx, 1
  058DC4  2B14: 03d8             add bx, ax
  058DC6  2B16: d1e3             shl bx, 1
  058DC8  2B18: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  058DCD  2B1D: 76b7             jbe 0x2ad6
  058DCF  2B1F: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  058DD3  2B23: 8a874431         mov al, byte ptr [bx + 0x3144]
  058DD7  2B27: 2ae4             sub ah, ah
  058DD9  2B29: 898668ff         mov word ptr [bp - 0x98], ax
  058DDD  2B2D: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  058DE1  2B31: 2aed             sub ch, ch
  058DE3  2B33: 898e60ff         mov word ptr [bp - 0xa0], cx
  058DE7  2B37: c7867eff0000     mov word ptr [bp - 0x82], 0
  058DED  2B3D: 51               push cx
  058DEE  2B3E: 50               push ax
  058DEF  2B3F: 9a02031f18       lcall 0x181f, 0x302
  058DF4  2B44: 83c404           add sp, 4
  058DF7  2B47: 0bc0             or ax, ax
  058DF9  2B49: 748b             je 0x2ad6
  058DFB  2B4B: c78672ff0000     mov word ptr [bp - 0x8e], 0
  058E01  2B51: e948ff           jmp 0x2a9c
  058E04  2B54: 837e9a00         cmp word ptr [bp - 0x66], 0
  058E08  2B58: 7503             jne 0x2b5d
  058E0A  2B5A: e9e100           jmp 0x2c3e
  058E0D  2B5D: 83be2eff01       cmp word ptr [bp - 0xd2], 1
  058E12  2B62: 7403             je 0x2b67
  058E14  2B64: e9d700           jmp 0x2c3e
  058E17  2B67: 8b469a           mov ax, word ptr [bp - 0x66]
  058E1A  2B6A: 99               cdq 
  058E1B  2B6B: 8b1efc84         mov bx, word ptr [0x84fc]
  058E1F  2B6F: 39572c           cmp word ptr [bx + 0x2c], dx
  058E22  2B72: 7d03             jge 0x2b77
  058E24  2B74: e9c700           jmp 0x2c3e
  058E27  2B77: 7f08             jg 0x2b81
  058E29  2B79: 39472a           cmp word ptr [bx + 0x2a], ax
  058E2C  2B7C: 7703             ja 0x2b81
  058E2E  2B7E: e9bd00           jmp 0x2c3e
  058E31  2B81: ff7608           push word ptr [bp + 8]
  058E34  2B84: 680f19           push 0x190f
  058E37  2B87: 6a00             push 0
  058E39  2B89: 8bf0             mov si, ax
  058E3B  2B8B: 8bfa             mov di, dx
  058E3D  2B8D: 0e               push cs
  058E3E  2B8E: e8a413           call 0x3f35
  058E41  2B91: 83c406           add sp, 6
  058E44  2B94: ff7606           push word ptr [bp + 6]
  058E47  2B97: 9aa4091f18       lcall 0x181f, 0x9a4
  058E4C  2B9C: 83c402           add sp, 2
  058E4F  2B9F: 50               push ax
  058E50  2BA0: 6a01             push 1
  058E52  2BA2: 9a38041f18       lcall 0x181f, 0x438
  058E57  2BA7: 83c404           add sp, 4
  058E5A  2BAA: 6b460834         imul ax, word ptr [bp + 8], 0x34
  058E5E  2BAE: 052654           add ax, 0x5426
  058E61  2BB1: 1e               push ds
  058E62  2BB2: 50               push ax
  058E63  2BB3: 6a02             push 2
  058E65  2BB5: 89862aff         mov word ptr [bp - 0xd6], ax
  058E69  2BB9: 9a16041f18       lcall 0x181f, 0x416
  058E6E  2BBE: 83c406           add sp, 6
  058E71  2BC1: 57               push di
  058E72  2BC2: 56               push si
  058E73  2BC3: 6a00             push 0
  058E75  2BC5: 9aae091f18       lcall 0x181f, 0x9ae
  058E7A  2BCA: 83c406           add sp, 6
  058E7D  2BCD: 681619           push 0x1916
  058E80  2BD0: 8d46a6           lea ax, [bp - 0x5a]
  058E83  2BD3: 50               push ax
  058E84  2BD4: 9ae4071d0d       lcall 0xd1d, 0x7e4
  058E89  2BD9: 83c404           add sp, 4
  058E8C  2BDC: 83be66ff00       cmp word ptr [bp - 0x9a], 0
  058E91  2BE1: 741e             je 0x2c01
  058E93  2BE3: 68e817           push 0x17e8
  058E96  2BE6: 8d46a6           lea ax, [bp - 0x5a]
  058E99  2BE9: 50               push ax
  058E9A  2BEA: 9aa4071d0d       lcall 0xd1d, 0x7a4
  058E9F  2BEF: 83c404           add sp, 4
  058EA2  2BF2: 1e               push ds
  058EA3  2BF3: ffb62aff         push word ptr [bp - 0xd6]
  058EA7  2BF7: 6a00             push 0
  058EA9  2BF9: 9a16041f18       lcall 0x181f, 0x416
  058EAE  2BFE: 83c406           add sp, 6
  058EB1  2C01: ff7608           push word ptr [bp + 8]
  058EB4  2C04: 8d46a6           lea ax, [bp - 0x5a]
  058EB7  2C07: 50               push ax
  058EB8  2C08: 9a88061f1a       lcall 0x1a1f, 0x688
  058EBD  2C0D: 83c404           add sp, 4
  058EC0  2C10: 8946f8           mov word ptr [bp - 8], ax
  058EC3  2C13: 3d0200           cmp ax, 2
  058EC6  2C16: 7521             jne 0x2c39
  058EC8  2C18: 8b469a           mov ax, word ptr [bp - 0x66]
  058ECB  2C1B: 99               cdq 
  058ECC  2C1C: 8b1efc84         mov bx, word ptr [0x84fc]
  058ED0  2C20: 29472a           sub word ptr [bx + 0x2a], ax
  058ED3  2C23: 19572c           sbb word ptr [bx + 0x2c], dx
  058ED6  2C26: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  058EDB  2C2B: 01873288         add word ptr [bx - 0x77ce], ax
  058EDF  2C2F: 11973488         adc word ptr [bx - 0x77cc], dx
  058EE3  2C33: c7865aff0000     mov word ptr [bp - 0xa6], 0
  058EE9  2C39: c7469ae703       mov word ptr [bp - 0x66], 0x3e7
  058EEE  2C3E: 83be2eff00       cmp word ptr [bp - 0xd2], 0
  058EF3  2C43: 7503             jne 0x2c48
  058EF5  2C45: e9d400           jmp 0x2d1c
  058EF8  2C48: 817e9ae703       cmp word ptr [bp - 0x66], 0x3e7
  058EFD  2C4D: 7503             jne 0x2c52
  058EFF  2C4F: e9ca00           jmp 0x2d1c
  058F02  2C52: 83be4eff00       cmp word ptr [bp - 0xb2], 0
  058F07  2C57: 7d03             jge 0x2c5c
  058F09  2C59: e9c000           jmp 0x2d1c
  058F0C  2C5C: ff7608           push word ptr [bp + 8]
  058F0F  2C5F: 681e19           push 0x191e
  058F12  2C62: 6a00             push 0
  058F14  2C64: 0e               push cs
  058F15  2C65: e8cd12           call 0x3f35
  058F18  2C68: 83c406           add sp, 6
  058F1B  2C6B: 8b8678ff         mov ax, word ptr [bp - 0x88]
  058F1F  2C6F: 99               cdq 
  058F20  2C70: 52               push dx
  058F21  2C71: 50               push ax
  058F22  2C72: 6a00             push 0
  058F24  2C74: 9aae091f18       lcall 0x181f, 0x9ae
  058F29  2C79: 83c406           add sp, 6
  058F2C  2C7C: 8b9e4eff         mov bx, word ptr [bp - 0xb2]
  058F30  2C80: d1e3             shl bx, 1
  058F32  2C82: ffb7c097         push word ptr [bx - 0x6840]
  058F36  2C86: 6a01             push 1
  058F38  2C88: 9a38041f18       lcall 0x181f, 0x438
  058F3D  2C8D: 83c404           add sp, 4
  058F40  2C90: ff7608           push word ptr [bp + 8]
  058F43  2C93: 9aa4091f18       lcall 0x181f, 0x9a4
  058F48  2C98: 83c402           add sp, 2
  058F4B  2C9B: 50               push ax
  058F4C  2C9C: 6a02             push 2
  058F4E  2C9E: 9a38041f18       lcall 0x181f, 0x438
  058F53  2CA3: 83c404           add sp, 4
  058F56  2CA6: 682619           push 0x1926
  058F59  2CA9: 8d46a6           lea ax, [bp - 0x5a]
  058F5C  2CAC: 50               push ax
  058F5D  2CAD: 9ae4071d0d       lcall 0xd1d, 0x7e4
  058F62  2CB2: 83c404           add sp, 4
  058F65  2CB5: 83be66ff00       cmp word ptr [bp - 0x9a], 0
  058F6A  2CBA: 7422             je 0x2cde
  058F6C  2CBC: 68e817           push 0x17e8
  058F6F  2CBF: 8d46a6           lea ax, [bp - 0x5a]
  058F72  2CC2: 50               push ax
  058F73  2CC3: 9aa4071d0d       lcall 0xd1d, 0x7a4
  058F78  2CC8: 83c404           add sp, 4
  058F7B  2CCB: 6b460834         imul ax, word ptr [bp + 8], 0x34
  058F7F  2CCF: 052654           add ax, 0x5426
  058F82  2CD2: 1e               push ds
  058F83  2CD3: 50               push ax
  058F84  2CD4: 6a00             push 0
  058F86  2CD6: 9a16041f18       lcall 0x181f, 0x416
  058F8B  2CDB: 83c406           add sp, 6
  058F8E  2CDE: ff7608           push word ptr [bp + 8]
  058F91  2CE1: 8d46a6           lea ax, [bp - 0x5a]
  058F94  2CE4: 50               push ax
  058F95  2CE5: 9a88061f1a       lcall 0x1a1f, 0x688
  058F9A  2CEA: 83c404           add sp, 4
  058F9D  2CED: 8946f8           mov word ptr [bp - 8], ax
  058FA0  2CF0: 3d0200           cmp ax, 2
  058FA3  2CF3: 7527             jne 0x2d1c
  058FA5  2CF5: 8b8678ff         mov ax, word ptr [bp - 0x88]
  058FA9  2CF9: 6b9e7aff65       imul bx, word ptr [bp - 0x86], 0x65
  058FAE  2CFE: 039e5eff         add bx, word ptr [bp - 0xa2]
  058FB2  2D02: d1e3             shl bx, 1
  058FB4  2D04: 2987e05d         sub word ptr [bx + 0x5de0], ax
  058FB8  2D08: 6b5e9e65         imul bx, word ptr [bp - 0x62], 0x65
  058FBC  2D0C: 039e5eff         add bx, word ptr [bp - 0xa2]
  058FC0  2D10: d1e3             shl bx, 1
  058FC2  2D12: 0187e05d         add word ptr [bx + 0x5de0], ax
  058FC6  2D16: c7865aff0000     mov word ptr [bp - 0xa6], 0
  058FCC  2D1C: 83be5aff00       cmp word ptr [bp - 0xa6], 0
  058FD1  2D21: 7439             je 0x2d5c
  058FD3  2D23: ff7608           push word ptr [bp + 8]
  058FD6  2D26: ff7606           push word ptr [bp + 6]
  058FD9  2D29: 9a380a1f18       lcall 0x181f, 0xa38
  058FDE  2D2E: 83c404           add sp, 4
  058FE1  2D31: a840             test al, 0x40
  058FE3  2D33: 7427             je 0x2d5c
  058FE5  2D35: 837e9a64         cmp word ptr [bp - 0x66], 0x64
  058FE9  2D39: 7e21             jle 0x2d5c
  058FEB  2D3B: ff7608           push word ptr [bp + 8]
  058FEE  2D3E: 683019           push 0x1930
  058FF1  2D41: 9a88061f1a       lcall 0x1a1f, 0x688
  058FF6  2D46: 83c404           add sp, 4
  058FF9  2D49: 6a40             push 0x40
  058FFB  2D4B: ff7608           push word ptr [bp + 8]
  058FFE  2D4E: ff7606           push word ptr [bp + 6]
  059001  2D51: 9a100a1f18       lcall 0x181f, 0xa10
  059006  2D56: 83c406           add sp, 6
  059009  2D59: e99f00           jmp 0x2dfb
  05900C  2D5C: 83be5aff00       cmp word ptr [bp - 0xa6], 0
  059011  2D61: 743b             je 0x2d9e
  059013  2D63: 817e9ae703       cmp word ptr [bp - 0x66], 0x3e7
  059018  2D68: 7534             jne 0x2d9e
  05901A  2D6A: ff7608           push word ptr [bp + 8]
  05901D  2D6D: 683819           push 0x1938
  059020  2D70: 6a00             push 0
  059022  2D72: 0e               push cs
  059023  2D73: e8bf11           call 0x3f35
  059026  2D76: 83c406           add sp, 6
  059029  2D79: 6b460834         imul ax, word ptr [bp + 8], 0x34
  05902D  2D7D: 052654           add ax, 0x5426
  059030  2D80: 1e               push ds
  059031  2D81: 50               push ax
  059032  2D82: 6a01             push 1
  059034  2D84: 9a16041f18       lcall 0x181f, 0x416
  059039  2D89: 83c406           add sp, 6
  05903C  2D8C: 6a04             push 4
  05903E  2D8E: 9aac041f18       lcall 0x181f, 0x4ac
  059043  2D93: 83c402           add sp, 2
  059046  2D96: ff7608           push word ptr [bp + 8]
  059049  2D99: 684019           push 0x1940
  05904C  2D9C: eba3             jmp 0x2d41
  05904E  2D9E: 83be5aff00       cmp word ptr [bp - 0xa6], 0
  059053  2DA3: 7456             je 0x2dfb
  059055  2DA5: ff7608           push word ptr [bp + 8]
  059058  2DA8: 684919           push 0x1949
  05905B  2DAB: 6a00             push 0
  05905D  2DAD: 0e               push cs
  05905E  2DAE: e88411           call 0x3f35
  059061  2DB1: 83c406           add sp, 6
  059064  2DB4: 6b460834         imul ax, word ptr [bp + 8], 0x34
  059068  2DB8: 052654           add ax, 0x5426
  05906B  2DBB: 1e               push ds
  05906C  2DBC: 50               push ax
  05906D  2DBD: 6a01             push 1
  05906F  2DBF: 9a16041f18       lcall 0x181f, 0x416
  059074  2DC4: 83c406           add sp, 6
  059077  2DC7: 685119           push 0x1951
  05907A  2DCA: 8d46a6           lea ax, [bp - 0x5a]
  05907D  2DCD: 50               push ax
  05907E  2DCE: 9ae4071d0d       lcall 0xd1d, 0x7e4
  059083  2DD3: 83c404           add sp, 4
  059086  2DD6: 83be66ff00       cmp word ptr [bp - 0x9a], 0
  05908B  2DDB: 740f             je 0x2dec
  05908D  2DDD: 68e817           push 0x17e8
  059090  2DE0: 8d46a6           lea ax, [bp - 0x5a]
  059093  2DE3: 50               push ax
  059094  2DE4: 9aa4071d0d       lcall 0xd1d, 0x7a4
  059099  2DE9: 83c404           add sp, 4
  05909C  2DEC: ff7608           push word ptr [bp + 8]
  05909F  2DEF: 8d46a6           lea ax, [bp - 0x5a]
  0590A2  2DF2: 50               push ax
  0590A3  2DF3: 9a88061f1a       lcall 0x1a1f, 0x688
  0590A8  2DF8: 83c404           add sp, 4
  0590AB  2DFB: c78632ff0000     mov word ptr [bp - 0xce], 0
  0590B1  2E01: 83be5aff00       cmp word ptr [bp - 0xa6], 0
  0590B6  2E06: 7403             je 0x2e0b
  0590B8  2E08: e9c101           jmp 0x2fcc
  0590BB  2E0B: ff7608           push word ptr [bp + 8]
  0590BE  2E0E: ff7606           push word ptr [bp + 6]
  0590C1  2E11: 9a380a1f18       lcall 0x181f, 0xa38
  0590C6  2E16: 83c404           add sp, 4
  0590C9  2E19: a840             test al, 0x40
  0590CB  2E1B: 7403             je 0x2e20
  0590CD  2E1D: e9ac01           jmp 0x2fcc
  0590D0  2E20: ff7608           push word ptr [bp + 8]
  0590D3  2E23: 685519           push 0x1955
  0590D6  2E26: 6a00             push 0
  0590D8  2E28: 0e               push cs
  0590D9  2E29: e80911           call 0x3f35
  0590DC  2E2C: 83c406           add sp, 6
  0590DF  2E2F: ff7606           push word ptr [bp + 6]
  0590E2  2E32: 9aa4091f18       lcall 0x181f, 0x9a4
  0590E7  2E37: 83c402           add sp, 2
  0590EA  2E3A: 50               push ax
  0590EB  2E3B: 6a01             push 1
  0590ED  2E3D: 9a38041f18       lcall 0x181f, 0x438
  0590F2  2E42: 83c404           add sp, 4
  0590F5  2E45: ff7608           push word ptr [bp + 8]
  0590F8  2E48: 9aa4091f18       lcall 0x181f, 0x9a4
  0590FD  2E4D: 83c402           add sp, 2
  059100  2E50: 50               push ax
  059101  2E51: 6a02             push 2
  059103  2E53: 9a38041f18       lcall 0x181f, 0x438
  059108  2E58: 83c404           add sp, 4
  05910B  2E5B: 83be66ff00       cmp word ptr [bp - 0x9a], 0
  059110  2E60: 7408             je 0x2e6a
  059112  2E62: c746f80100       mov word ptr [bp - 8], 1
  059117  2E67: eb12             jmp 0x2e7b
  059119  2E69: 90               nop 
  05911A  2E6A: ff7608           push word ptr [bp + 8]
  05911D  2E6D: 685d19           push 0x195d
  059120  2E70: 9a88061f1a       lcall 0x1a1f, 0x688
  059125  2E75: 83c404           add sp, 4
  059128  2E78: 8946f8           mov word ptr [bp - 8], ax
  05912B  2E7B: 837ef801         cmp word ptr [bp - 8], 1
  05912F  2E7F: 7531             jne 0x2eb2
  059131  2E81: 6a40             push 0x40
  059133  2E83: ff7608           push word ptr [bp + 8]
  059136  2E86: ff7606           push word ptr [bp + 6]
  059139  2E89: 9a060a1f18       lcall 0x181f, 0xa06
  05913E  2E8E: 83c406           add sp, 6
  059141  2E91: a18e53           mov ax, word ptr [0x538e]
  059144  2E94: 051000           add ax, 0x10
  059147  2E97: 8b5e08           mov bx, word ptr [bp + 8]
  05914A  2E9A: d1e3             shl bx, 1
  05914C  2E9C: 8987c853         mov word ptr [bx + 0x53c8], ax
  059150  2EA0: 686419           push 0x1964
  059153  2EA3: 8d46a6           lea ax, [bp - 0x5a]
  059156  2EA6: 50               push ax
  059157  2EA7: 9ae4071d0d       lcall 0xd1d, 0x7e4
  05915C  2EAC: 83c404           add sp, 4
  05915F  2EAF: e93601           jmp 0x2fe8
  059162  2EB2: 83be54ff00       cmp word ptr [bp - 0xac], 0
  059167  2EB7: 7403             je 0x2ebc
  059169  2EB9: e9a400           jmp 0x2f60
  05916C  2EBC: 6a00             push 0
  05916E  2EBE: 6a64             push 0x64
  059170  2EC0: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  059175  2EC5: ffb73488         push word ptr [bx - 0x77cc]
  059179  2EC9: ffb73288         push word ptr [bx - 0x77ce]
  05917D  2ECD: 8bf3             mov si, bx
  05917F  2ECF: 9ac60e1d0d       lcall 0xd1d, 0xec6
  059184  2ED4: 50               push ax
  059185  2ED5: 6a00             push 0
  059187  2ED7: 8b8634ff         mov ax, word ptr [bp - 0xcc]
  05918B  2EDB: 48               dec ax
  05918C  2EDC: 48               dec ax
  05918D  2EDD: d1e0             shl ax, 1
  05918F  2EDF: 50               push ax
  059190  2EE0: 9a5c031f18       lcall 0x181f, 0x35c
  059195  2EE5: 83c406           add sp, 6
  059198  2EE8: 6bc064           imul ax, ax, 0x64
  05919B  2EEB: 89866cff         mov word ptr [bp - 0x94], ax
  05919F  2EEF: 0bc0             or ax, ax
  0591A1  2EF1: 746d             je 0x2f60
  0591A3  2EF3: 686a19           push 0x196a
  0591A6  2EF6: 8d4e82           lea cx, [bp - 0x7e]
  0591A9  2EF9: 51               push cx
  0591AA  2EFA: 9ae4071d0d       lcall 0xd1d, 0x7e4
  0591AF  2EFF: 83c404           add sp, 4
  0591B2  2F02: 8b866cff         mov ax, word ptr [bp - 0x94]
  0591B6  2F06: 99               cdq 
  0591B7  2F07: 52               push dx
  0591B8  2F08: 50               push ax
  0591B9  2F09: 2bc9             sub cx, cx
  0591BB  2F0B: 898e2eff         mov word ptr [bp - 0xd2], cx
  0591BF  2F0F: 51               push cx
  0591C0  2F10: 8bf8             mov di, ax
  0591C2  2F12: 89be2aff         mov word ptr [bp - 0xd6], di
  0591C6  2F16: 89962cff         mov word ptr [bp - 0xd4], dx
  0591CA  2F1A: 9aae091f18       lcall 0x181f, 0x9ae
  0591CF  2F1F: 83c406           add sp, 6
  0591D2  2F22: ff7608           push word ptr [bp + 8]
  0591D5  2F25: 686f19           push 0x196f
  0591D8  2F28: 9a88061f1a       lcall 0x1a1f, 0x688
  0591DD  2F2D: 83c404           add sp, 4
  0591E0  2F30: 8946f8           mov word ptr [bp - 8], ax
  0591E3  2F33: 48               dec ax
  0591E4  2F34: 752a             jne 0x2f60
  0591E6  2F36: 6a40             push 0x40
  0591E8  2F38: ff7608           push word ptr [bp + 8]
  0591EB  2F3B: ff7606           push word ptr [bp + 6]
  0591EE  2F3E: 9a060a1f18       lcall 0x181f, 0xa06
  0591F3  2F43: 83c406           add sp, 6
  0591F6  2F46: 8b862aff         mov ax, word ptr [bp - 0xd6]
  0591FA  2F4A: 8b962cff         mov dx, word ptr [bp - 0xd4]
  0591FE  2F4E: 29843288         sub word ptr [si - 0x77ce], ax
  059202  2F52: 19943488         sbb word ptr [si - 0x77cc], dx
  059206  2F56: 8b1efc84         mov bx, word ptr [0x84fc]
  05920A  2F5A: 01472a           add word ptr [bx + 0x2a], ax
  05920D  2F5D: 11572c           adc word ptr [bx + 0x2c], dx
  059210  2F60: ff7608           push word ptr [bp + 8]
  059213  2F63: ff7606           push word ptr [bp + 6]
  059216  2F66: 9a380a1f18       lcall 0x181f, 0xa38
  05921B  2F6B: 83c404           add sp, 4
  05921E  2F6E: a840             test al, 0x40
  059220  2F70: 7576             jne 0x2fe8
  059222  2F72: 687819           push 0x1978
  059225  2F75: 8d46a6           lea ax, [bp - 0x5a]
  059228  2F78: 50               push ax
  059229  2F79: 9ae4071d0d       lcall 0xd1d, 0x7e4
  05922E  2F7E: 83c404           add sp, 4
  059231  2F81: 8d4682           lea ax, [bp - 0x7e]
  059234  2F84: 50               push ax
  059235  2F85: 8d46a6           lea ax, [bp - 0x5a]
  059238  2F88: 50               push ax
  059239  2F89: 9aa4071d0d       lcall 0xd1d, 0x7a4
  05923E  2F8E: 83c404           add sp, 4
  059241  2F91: ff7608           push word ptr [bp + 8]
  059244  2F94: 687c19           push 0x197c
  059247  2F97: 6a00             push 0
  059249  2F99: 0e               push cs
  05924A  2F9A: e8980f           call 0x3f35
  05924D  2F9D: 83c406           add sp, 6
  059250  2FA0: 6b460834         imul ax, word ptr [bp + 8], 0x34
  059254  2FA4: 052654           add ax, 0x5426
  059257  2FA7: 1e               push ds
  059258  2FA8: 50               push ax
  059259  2FA9: 6a01             push 1
  05925B  2FAB: 9a16041f18       lcall 0x181f, 0x416
  059260  2FB0: 83c406           add sp, 6
  059263  2FB3: 6a04             push 4
  059265  2FB5: 9aac041f18       lcall 0x181f, 0x4ac
  05926A  2FBA: 83c402           add sp, 2
  05926D  2FBD: ff7608           push word ptr [bp + 8]
  059270  2FC0: 8d46a6           lea ax, [bp - 0x5a]
  059273  2FC3: 50               push ax
  059274  2FC4: 9a88061f1a       lcall 0x1a1f, 0x688
  059279  2FC9: e9e0fe           jmp 0x2eac
  05927C  2FCC: 83be5aff00       cmp word ptr [bp - 0xa6], 0
  059281  2FD1: 7515             jne 0x2fe8
  059283  2FD3: 688419           push 0x1984
  059286  2FD6: 8d46a6           lea ax, [bp - 0x5a]
  059289  2FD9: 50               push ax
  05928A  2FDA: 9ae4071d0d       lcall 0xd1d, 0x7e4
  05928F  2FDF: 83c404           add sp, 4
  059292  2FE2: c78632ff0100     mov word ptr [bp - 0xce], 1
  059298  2FE8: ff7608           push word ptr [bp + 8]
  05929B  2FEB: ff7606           push word ptr [bp + 6]
  05929E  2FEE: 9a380a1f18       lcall 0x181f, 0xa38
  0592A3  2FF3: 83c404           add sp, 4
  0592A6  2FF6: a840             test al, 0x40
  0592A8  2FF8: 741a             je 0x3014
  0592AA  2FFA: ff7608           push word ptr [bp + 8]
  0592AD  2FFD: ff7606           push word ptr [bp + 6]
  0592B0  3000: 0e               push cs
  0592B1  3001: e82c0f           call 0x3f30
  0592B4  3004: 83c404           add sp, 4
  0592B7  3007: ff7606           push word ptr [bp + 6]
  0592BA  300A: ff7608           push word ptr [bp + 8]
  0592BD  300D: 0e               push cs
  0592BE  300E: e81f0f           call 0x3f30
  0592C1  3011: 83c404           add sp, 4
  0592C4  3014: 83be5aff00       cmp word ptr [bp - 0xa6], 0
  0592C9  3019: 7403             je 0x301e
  0592CB  301B: e90c08           jmp 0x382a
  0592CE  301E: ff7608           push word ptr [bp + 8]
  0592D1  3021: ff7606           push word ptr [bp + 6]
  0592D4  3024: 9a380a1f18       lcall 0x181f, 0xa38
  0592D9  3029: 83c404           add sp, 4
  0592DC  302C: a840             test al, 0x40
  0592DE  302E: 7503             jne 0x3033
  0592E0  3030: e9f707           jmp 0x382a
  0592E3  3033: ff7606           push word ptr [bp + 6]
  0592E6  3036: 9aa4091f18       lcall 0x181f, 0x9a4
  0592EB  303B: 83c402           add sp, 2
  0592EE  303E: 50               push ax
  0592EF  303F: 6a00             push 0
  0592F1  3041: 9a38041f18       lcall 0x181f, 0x438
  0592F6  3046: 83c404           add sp, 4
  0592F9  3049: ff7608           push word ptr [bp + 8]
  0592FC  304C: 9aa4091f18       lcall 0x181f, 0x9a4
  059301  3051: 83c402           add sp, 2
  059304  3054: 50               push ax
  059305  3055: 6a01             push 1
  059307  3057: 9a38041f18       lcall 0x181f, 0x438
  05930C  305C: 83c404           add sp, 4
  05930F  305F: 8d4682           lea ax, [bp - 0x7e]
  059312  3062: 50               push ax
  059313  3063: 8d46a6           lea ax, [bp - 0x5a]
  059316  3066: 50               push ax
  059317  3067: 9aa4071d0d       lcall 0xd1d, 0x7a4
  05931C  306C: 83c404           add sp, 4
  05931F  306F: 83be32ff00       cmp word ptr [bp - 0xce], 0
  059324  3074: 7429             je 0x309f
  059326  3076: 8a1ea653         mov bl, byte ptr [0x53a6]
  05932A  307A: 2aff             sub bh, bh
  05932C  307C: d1e3             shl bx, 1
  05932E  307E: ffb79483         push word ptr [bx - 0x7c6c]
  059332  3082: 6a02             push 2
  059334  3084: 9a38041f18       lcall 0x181f, 0x438
  059339  3089: 83c404           add sp, 4
  05933C  308C: 6b460634         imul ax, word ptr [bp + 6], 0x34
  059340  3090: 050e54           add ax, 0x540e
  059343  3093: 1e               push ds
  059344  3094: 50               push ax
  059345  3095: 6a03             push 3
  059347  3097: 9a16041f18       lcall 0x181f, 0x416
  05934C  309C: 83c406           add sp, 6
  05934F  309F: 83be66ff00       cmp word ptr [bp - 0x9a], 0
  059354  30A4: 7438             je 0x30de
  059356  30A6: 688d19           push 0x198d
  059359  30A9: 8d46a6           lea ax, [bp - 0x5a]
  05935C  30AC: 50               push ax
  05935D  30AD: 9ae4071d0d       lcall 0xd1d, 0x7e4
  059362  30B2: 83c404           add sp, 4
  059365  30B5: 6b460834         imul ax, word ptr [bp + 8], 0x34
  059369  30B9: 052654           add ax, 0x5426
  05936C  30BC: 1e               push ds
  05936D  30BD: 50               push ax
  05936E  30BE: 6a00             push 0
  059370  30C0: 9a16041f18       lcall 0x181f, 0x416
  059375  30C5: 83c406           add sp, 6
  059378  30C8: ff7606           push word ptr [bp + 6]
  05937B  30CB: 9a1a0a1f18       lcall 0x181f, 0xa1a
  059380  30D0: 83c402           add sp, 2
  059383  30D3: 50               push ax
  059384  30D4: 6a01             push 1
  059386  30D6: 9a38041f18       lcall 0x181f, 0x438
  05938B  30DB: 83c404           add sp, 4
  05938E  30DE: ff7608           push word ptr [bp + 8]
  059391  30E1: 8d46a6           lea ax, [bp - 0x5a]
  059394  30E4: 50               push ax
  059395  30E5: 9a88061f1a       lcall 0x1a1f, 0x688
  05939A  30EA: 83c404           add sp, 4
  05939D  30ED: 8946f8           mov word ptr [bp - 8], ax
  0593A0  30F0: 3d0200           cmp ax, 2
  0593A3  30F3: 7403             je 0x30f8
  0593A5  30F5: e9de02           jmp 0x33d6
  0593A8  30F8: c7867eff0000     mov word ptr [bp - 0x82], 0
  0593AE  30FE: 837ea000         cmp word ptr [bp - 0x60], 0
  0593B2  3102: 7512             jne 0x3116
  0593B4  3104: ff7608           push word ptr [bp + 8]
  0593B7  3107: 689619           push 0x1996
  0593BA  310A: 9a88061f1a       lcall 0x1a1f, 0x688
  0593BF  310F: 83c404           add sp, 4
  0593C2  3112: e9d101           jmp 0x32e6
  0593C5  3115: 90               nop 
  0593C6  3116: 83be34ff00       cmp word ptr [bp - 0xcc], 0
  0593CB  311B: 741f             je 0x313c
  0593CD  311D: 83be52ff00       cmp word ptr [bp - 0xae], 0
  0593D2  3122: 7518             jne 0x313c
  0593D4  3124: ff7608           push word ptr [bp + 8]
  0593D7  3127: 68a619           push 0x19a6
  0593DA  312A: 9a88061f1a       lcall 0x1a1f, 0x688
  0593DF  312F: 83c404           add sp, 4
  0593E2  3132: c7867eff0100     mov word ptr [bp - 0x82], 1
  0593E8  3138: e9ab01           jmp 0x32e6
  0593EB  313B: 90               nop 
  0593EC  313C: a0a653           mov al, byte ptr [0x53a6]
  0593EF  313F: 2ae4             sub ah, ah
  0593F1  3141: 40               inc ax
  0593F2  3142: 40               inc ax
  0593F3  3143: f7ae50ff         imul word ptr [bp - 0xb0]
  0593F7  3147: 6bc019           imul ax, ax, 0x19
  0593FA  314A: 898662ff         mov word ptr [bp - 0x9e], ax
  0593FE  314E: 83be54ff00       cmp word ptr [bp - 0xac], 0
  059403  3153: 7406             je 0x315b
  059405  3155: d1e0             shl ax, 1
  059407  3157: 898662ff         mov word ptr [bp - 0x9e], ax
  05940B  315B: 83be6eff00       cmp word ptr [bp - 0x92], 0
  059410  3160: 7406             je 0x3168
  059412  3162: d1f8             sar ax, 1
  059414  3164: 018662ff         add word ptr [bp - 0x9e], ax
  059418  3168: 83be44ff00       cmp word ptr [bp - 0xbc], 0
  05941D  316D: 7408             je 0x3177
  05941F  316F: 6b46face         imul ax, word ptr [bp - 6], -0x32
  059423  3173: 018662ff         add word ptr [bp - 0x9e], ax
  059427  3177: 6a13             push 0x13
  059429  3179: ff7606           push word ptr [bp + 6]
  05942C  317C: 9ab4071f18       lcall 0x181f, 0x7b4
  059431  3181: 83c404           add sp, 4
  059434  3184: 0bc0             or ax, ax
  059436  3186: 7404             je 0x318c
  059438  3188: d1be62ff         sar word ptr [bp - 0x9e], 1
  05943C  318C: ff7608           push word ptr [bp + 8]
  05943F  318F: 9aa4091f18       lcall 0x181f, 0x9a4
  059444  3194: 83c402           add sp, 2
  059447  3197: 50               push ax
  059448  3198: 6a00             push 0
  05944A  319A: 9a38041f18       lcall 0x181f, 0x438
  05944F  319F: 83c404           add sp, 4
  059452  31A2: 8b8662ff         mov ax, word ptr [bp - 0x9e]
  059456  31A6: 3d6400           cmp ax, 0x64
  059459  31A9: 7d03             jge 0x31ae
  05945B  31AB: b86400           mov ax, 0x64
  05945E  31AE: 898662ff         mov word ptr [bp - 0x9e], ax
  059462  31B2: 99               cdq 
  059463  31B3: 8b1efc84         mov bx, word ptr [0x84fc]
  059467  31B7: 3b572c           cmp dx, word ptr [bx + 0x2c]
  05946A  31BA: 7f0e             jg 0x31ca
  05946C  31BC: 7c05             jl 0x31c3
  05946E  31BE: 3b472a           cmp ax, word ptr [bx + 0x2a]
  059471  31C1: 7707             ja 0x31ca
  059473  31C3: 83be52ff00       cmp word ptr [bp - 0xae], 0
  059478  31C8: 740a             je 0x31d4
  05947A  31CA: ff7608           push word ptr [bp + 8]
  05947D  31CD: 68af19           push 0x19af
  059480  31D0: e937ff           jmp 0x310a
  059483  31D3: 90               nop 
  059484  31D4: 99               cdq 
  059485  31D5: 52               push dx
  059486  31D6: 50               push ax
  059487  31D7: 6a00             push 0
  059489  31D9: 8bf0             mov si, ax
  05948B  31DB: 8bfa             mov di, dx
  05948D  31DD: 9aae091f18       lcall 0x181f, 0x9ae
  059492  31E2: 83c406           add sp, 6
  059495  31E5: ff7608           push word ptr [bp + 8]
  059498  31E8: 68bb19           push 0x19bb
  05949B  31EB: 9a88061f1a       lcall 0x1a1f, 0x688
  0594A0  31F0: 83c404           add sp, 4
  0594A3  31F3: 89863aff         mov word ptr [bp - 0xc6], ax
  0594A7  31F7: 48               dec ax
  0594A8  31F8: 751d             jne 0x3217
  0594AA  31FA: 8b1efc84         mov bx, word ptr [0x84fc]
  0594AE  31FE: 29772a           sub word ptr [bx + 0x2a], si
  0594B1  3201: 197f2c           sbb word ptr [bx + 0x2c], di
  0594B4  3204: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  0594B9  3209: 01b73288         add word ptr [bx - 0x77ce], si
  0594BD  320D: 11bf3488         adc word ptr [bx - 0x77cc], di
  0594C1  3211: c7867eff0100     mov word ptr [bp - 0x82], 1
  0594C7  3217: 83be3aff02       cmp word ptr [bp - 0xc6], 2
  0594CC  321C: 7403             je 0x3221
  0594CE  321E: e9c500           jmp 0x32e6
  0594D1  3221: 8b5e08           mov bx, word ptr [bp + 8]
  0594D4  3224: 8a872c94         mov al, byte ptr [bx - 0x6bd4]
  0594D8  3228: 2ae4             sub ah, ah
  0594DA  322A: 8b5e06           mov bx, word ptr [bp + 6]
  0594DD  322D: 8a8f2c94         mov cl, byte ptr [bx - 0x6bd4]
  0594E1  3231: 2aed             sub ch, ch
  0594E3  3233: 03c1             add ax, cx
  0594E5  3235: 8946a4           mov word ptr [bp - 0x5c], ax
  0594E8  3238: 83be54ff00       cmp word ptr [bp - 0xac], 0
  0594ED  323D: 7405             je 0x3244
  0594EF  323F: d1e0             shl ax, 1
  0594F1  3241: 8946a4           mov word ptr [bp - 0x5c], ax
  0594F4  3244: 50               push ax
  0594F5  3245: 6a00             push 0
  0594F7  3247: 9ad4041f18       lcall 0x181f, 0x4d4
  0594FC  324C: 83c404           add sp, 4
  0594FF  324F: 8b5e06           mov bx, word ptr [bp + 6]
  059502  3252: 8a8f2c94         mov cl, byte ptr [bx - 0x6bd4]
  059506  3256: 2aed             sub ch, ch
  059508  3258: 3bc8             cmp cx, ax
  05950A  325A: 7c0a             jl 0x3266
  05950C  325C: ff7608           push word ptr [bp + 8]
  05950F  325F: 68c919           push 0x19c9
  059512  3262: e9c5fe           jmp 0x312a
  059515  3265: 90               nop 
  059516  3266: 68d219           push 0x19d2
  059519  3269: 8d46a6           lea ax, [bp - 0x5a]
  05951C  326C: 50               push ax
  05951D  326D: 9ae4071d0d       lcall 0xd1d, 0x7e4
  059522  3272: 83c404           add sp, 4
  059525  3275: 83be66ff00       cmp word ptr [bp - 0x9a], 0
  05952A  327A: 740f             je 0x328b
  05952C  327C: 68d619           push 0x19d6
  05952F  327F: 8d4682           lea ax, [bp - 0x7e]
  059532  3282: 50               push ax
  059533  3283: 9ae4071d0d       lcall 0xd1d, 0x7e4
  059538  3288: 83c404           add sp, 4
  05953B  328B: 8d4682           lea ax, [bp - 0x7e]
  05953E  328E: 50               push ax
  05953F  328F: 8d46a6           lea ax, [bp - 0x5a]
  059542  3292: 50               push ax
  059543  3293: 9aa4071d0d       lcall 0xd1d, 0x7a4
  059548  3298: 83c404           add sp, 4
  05954B  329B: ff7608           push word ptr [bp + 8]
  05954E  329E: 68dc19           push 0x19dc
  059551  32A1: 6a00             push 0
  059553  32A3: 0e               push cs
  059554  32A4: e88e0c           call 0x3f35
  059557  32A7: 83c406           add sp, 6
  05955A  32AA: 6b460834         imul ax, word ptr [bp + 8], 0x34
  05955E  32AE: 052654           add ax, 0x5426
  059561  32B1: 1e               push ds
  059562  32B2: 50               push ax
  059563  32B3: 6a01             push 1
  059565  32B5: 9a16041f18       lcall 0x181f, 0x416
  05956A  32BA: 83c406           add sp, 6
  05956D  32BD: 6a04             push 4
  05956F  32BF: 9aac041f18       lcall 0x181f, 0x4ac
  059574  32C4: 83c402           add sp, 2
  059577  32C7: ff7608           push word ptr [bp + 8]
  05957A  32CA: 8d46a6           lea ax, [bp - 0x5a]
  05957D  32CD: 50               push ax
  05957E  32CE: 9a88061f1a       lcall 0x1a1f, 0x688
  059583  32D3: 83c404           add sp, 4
  059586  32D6: 6a40             push 0x40
  059588  32D8: ff7608           push word ptr [bp + 8]
  05958B  32DB: ff7606           push word ptr [bp + 6]
  05958E  32DE: 9a100a1f18       lcall 0x181f, 0xa10
  059593  32E3: 83c406           add sp, 6
  059596  32E6: 83be7eff00       cmp word ptr [bp - 0x82], 0
  05959B  32EB: 7503             jne 0x32f0
  05959D  32ED: e9e600           jmp 0x33d6
  0595A0  32F0: c70640170100     mov word ptr [0x1740], 1
  0595A6  32F6: c7460a0000       mov word ptr [bp + 0xa], 0
  0595AB  32FB: eb7a             jmp 0x3377
  0595AD  32FD: 90               nop 
  0595AE  32FE: 83be72ff08       cmp word ptr [bp - 0x8e], 8
  0595B3  3303: 7d3c             jge 0x3341
  0595B5  3305: 8b9e72ff         mov bx, word ptr [bp - 0x8e]
  0595B9  3309: 8a87be00         mov al, byte ptr [bx + 0xbe]
  0595BD  330D: 98               cwde 
  0595BE  330E: 038660ff         add ax, word ptr [bp - 0xa0]
  0595C2  3312: 8946a2           mov word ptr [bp - 0x5e], ax
  0595C5  3315: 50               push ax
  0595C6  3316: 8a87b400         mov al, byte ptr [bx + 0xb4]
  0595CA  331A: 98               cwde 
  0595CB  331B: 038668ff         add ax, word ptr [bp - 0x98]
  0595CF  331F: 8946fe           mov word ptr [bp - 2], ax
  0595D2  3322: 50               push ax
  0595D3  3323: 9a96061f18       lcall 0x181f, 0x696
  0595D8  3328: 83c404           add sp, 4
  0595DB  332B: 3b4606           cmp ax, word ptr [bp + 6]
  0595DE  332E: 7506             jne 0x3336
  0595E0  3330: c7867eff0100     mov word ptr [bp - 0x82], 1
  0595E6  3336: ff8672ff         inc word ptr [bp - 0x8e]
  0595EA  333A: 83be7eff00       cmp word ptr [bp - 0x82], 0
  0595EF  333F: 74bd             je 0x32fe
  0595F1  3341: 83be7eff00       cmp word ptr [bp - 0x82], 0
  0595F6  3346: 742c             je 0x3374
  0595F8  3348: 8b4608           mov ax, word ptr [bp + 8]
  0595FB  334B: 2d1400           sub ax, 0x14
  0595FE  334E: 50               push ax
  0595FF  334F: 50               push ax
  059600  3350: ff760a           push word ptr [bp + 0xa]
  059603  3353: 9a80081f18       lcall 0x181f, 0x880
  059608  3358: 83c406           add sp, 6
  05960B  335B: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  059610  3360: 8a873a88         mov al, byte ptr [bx - 0x77c6]
  059614  3364: 6b760a1c         imul si, word ptr [bp + 0xa], 0x1c
  059618  3368: 88844d31         mov byte ptr [si + 0x314d], al
  05961C  336C: 8a873b88         mov al, byte ptr [bx - 0x77c5]
  059620  3370: 88844e31         mov byte ptr [si + 0x314e], al
  059624  3374: ff460a           inc word ptr [bp + 0xa]
  059627  3377: a19c53           mov ax, word ptr [0x539c]
  05962A  337A: 39460a           cmp word ptr [bp + 0xa], ax
  05962D  337D: 7d57             jge 0x33d6
  05962F  337F: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  059633  3383: 8a874731         mov al, byte ptr [bx + 0x3147]
  059637  3387: 240f             and al, 0xf
  059639  3389: 3a4608           cmp al, byte ptr [bp + 8]
  05963C  338C: 75e6             jne 0x3374
  05963E  338E: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  059642  3392: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  059647  3397: 7207             jb 0x33a0
  059649  3399: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  05964E  339E: 76d4             jbe 0x3374
  059650  33A0: 6b5e0a1c         imul bx, word ptr [bp + 0xa], 0x1c
  059654  33A4: 8a874431         mov al, byte ptr [bx + 0x3144]
  059658  33A8: 2ae4             sub ah, ah
  05965A  33AA: 898668ff         mov word ptr [bp - 0x98], ax
  05965E  33AE: 8a8f4531         mov cl, byte ptr [bx + 0x3145]
  059662  33B2: 2aed             sub ch, ch
  059664  33B4: 898e60ff         mov word ptr [bp - 0xa0], cx
  059668  33B8: c7867eff0000     mov word ptr [bp - 0x82], 0
  05966E  33BE: 51               push cx
  05966F  33BF: 50               push ax
  059670  33C0: 9a02031f18       lcall 0x181f, 0x302
  059675  33C5: 83c404           add sp, 4
  059678  33C8: 0bc0             or ax, ax
  05967A  33CA: 74a8             je 0x3374
  05967C  33CC: c78672ff0000     mov word ptr [bp - 0x8e], 0
  059682  33D2: e965ff           jmp 0x333a
  059685  33D5: 90               nop 
  059686  33D6: 837ef803         cmp word ptr [bp - 8], 3
  05968A  33DA: 7403             je 0x33df
  05968C  33DC: e9d100           jmp 0x34b0
  05968F  33DF: 6a13             push 0x13
  059691  33E1: ff7606           push word ptr [bp + 6]
  059694  33E4: 9ab4071f18       lcall 0x181f, 0x7b4
  059699  33E9: 83c404           add sp, 4
  05969C  33EC: 0bc0             or ax, ax
  05969E  33EE: 7414             je 0x3404
  0596A0  33F0: 6a02             push 2
  0596A2  33F2: 6a00             push 0
  0596A4  33F4: 9ad4041f18       lcall 0x181f, 0x4d4
  0596A9  33F9: 83c404           add sp, 4
  0596AC  33FC: 0bc0             or ax, ax
  0596AE  33FE: 7504             jne 0x3404
  0596B0  3400: ff8634ff         inc word ptr [bp - 0xcc]
  0596B4  3404: 6a00             push 0
  0596B6  3406: 6a64             push 0x64
  0596B8  3408: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  0596BD  340D: ffb73488         push word ptr [bx - 0x77cc]
  0596C1  3411: ffb73288         push word ptr [bx - 0x77ce]
  0596C5  3415: 8bf3             mov si, bx
  0596C7  3417: 9ac60e1d0d       lcall 0xd1d, 0xec6
  0596CC  341C: 50               push ax
  0596CD  341D: 6a00             push 0
  0596CF  341F: ffb634ff         push word ptr [bp - 0xcc]
  0596D3  3423: 9a5c031f18       lcall 0x181f, 0x35c
  0596D8  3428: 83c406           add sp, 6
  0596DB  342B: 6bc064           imul ax, ax, 0x64
  0596DE  342E: 89866cff         mov word ptr [bp - 0x94], ax
  0596E2  3432: 0bc0             or ax, ax
  0596E4  3434: 7e42             jle 0x3478
  0596E6  3436: 99               cdq 
  0596E7  3437: 52               push dx
  0596E8  3438: 50               push ax
  0596E9  3439: 6a00             push 0
  0596EB  343B: 8bf8             mov di, ax
  0596ED  343D: 89be2aff         mov word ptr [bp - 0xd6], di
  0596F1  3441: 89962cff         mov word ptr [bp - 0xd4], dx
  0596F5  3445: 9aae091f18       lcall 0x181f, 0x9ae
  0596FA  344A: 83c406           add sp, 6
  0596FD  344D: ff7608           push word ptr [bp + 8]
  059700  3450: 68e419           push 0x19e4
  059703  3453: 9a88061f1a       lcall 0x1a1f, 0x688
  059708  3458: 83c404           add sp, 4
  05970B  345B: 8b862aff         mov ax, word ptr [bp - 0xd6]
  05970F  345F: 8b962cff         mov dx, word ptr [bp - 0xd4]
  059713  3463: 29843288         sub word ptr [si - 0x77ce], ax
  059717  3467: 19943488         sbb word ptr [si - 0x77cc], dx
  05971B  346B: 8b1efc84         mov bx, word ptr [0x84fc]
  05971F  346F: 01472a           add word ptr [bx + 0x2a], ax
  059722  3472: 11572c           adc word ptr [bx + 0x2c], dx
  059725  3475: eb39             jmp 0x34b0
  059727  3477: 90               nop 
  059728  3478: 83be6eff00       cmp word ptr [bp - 0x92], 0
  05972D  347D: 7423             je 0x34a2
  05972F  347F: 6a04             push 4
  059731  3481: 9aac041f18       lcall 0x181f, 0x4ac
  059736  3486: 83c402           add sp, 2
  059739  3489: 6a40             push 0x40
  05973B  348B: ff7608           push word ptr [bp + 8]
  05973E  348E: ff7606           push word ptr [bp + 6]
  059741  3491: 9a100a1f18       lcall 0x181f, 0xa10
  059746  3496: 83c406           add sp, 6
  059749  3499: ff7608           push word ptr [bp + 8]
  05974C  349C: 68ea19           push 0x19ea
  05974F  349F: eb07             jmp 0x34a8
  059751  34A1: 90               nop 
  059752  34A2: ff7608           push word ptr [bp + 8]
  059755  34A5: 68f219           push 0x19f2
  059758  34A8: 9a88061f1a       lcall 0x1a1f, 0x688
  05975D  34AD: 83c404           add sp, 4
  059760  34B0: 837ef804         cmp word ptr [bp - 8], 4
  059764  34B4: 7403             je 0x34b9
  059766  34B6: e97103           jmp 0x382a
  059769  34B9: 8d1e7c08         lea bx, [0x87c]
  05976D  34BD: 8d06fa19         lea ax, [0x19fa]
  059771  34C1: 2bd2             sub dx, dx
  059773  34C3: 9a82011f19       lcall 0x191f, 0x182
  059778  34C8: 894696           mov word ptr [bp - 0x6a], ax
  05977B  34CB: 895698           mov word ptr [bp - 0x68], dx
  05977E  34CE: 0bd0             or dx, ax
  059780  34D0: 7503             jne 0x34d5
  059782  34D2: e96903           jmp 0x383e
  059785  34D5: 2bc0             sub ax, ax
  059787  34D7: 89866cff         mov word ptr [bp - 0x94], ax
  05978B  34DB: 89865eff         mov word ptr [bp - 0xa2], ax
  05978F  34DF: eb0e             jmp 0x34ef
  059791  34E1: 90               nop 
  059792  34E2: 8b4606           mov ax, word ptr [bp + 6]
  059795  34E5: 39865eff         cmp word ptr [bp - 0xa2], ax
  059799  34E9: 7541             jne 0x352c
  05979B  34EB: ff865eff         inc word ptr [bp - 0xa2]
  05979F  34EF: 83be5eff0c       cmp word ptr [bp - 0xa2], 0xc
  0597A4  34F4: 7c03             jl 0x34f9
  0597A6  34F6: e98300           jmp 0x357c
  0597A9  34F9: 83be5eff04       cmp word ptr [bp - 0xa2], 4
  0597AE  34FE: 7ce2             jl 0x34e2
  0597B0  3500: ffb65eff         push word ptr [bp - 0xa2]
  0597B4  3504: 9a420a1f18       lcall 0x181f, 0xa42
  0597B9  3509: 83c402           add sp, 2
  0597BC  350C: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  0597C0  3510: f6470380         test byte ptr [bx + 3], 0x80
  0597C4  3514: 75d5             jne 0x34eb
  0597C6  3516: ffb65eff         push word ptr [bp - 0xa2]
  0597CA  351A: ff7606           push word ptr [bp + 6]
  0597CD  351D: 9a380a1f18       lcall 0x181f, 0xa38
  0597D2  3522: 83c404           add sp, 4
  0597D5  3525: a820             test al, 0x20
  0597D7  3527: 751f             jne 0x3548
  0597D9  3529: ebc0             jmp 0x34eb
  0597DB  352B: 90               nop 
  0597DC  352C: 8b4608           mov ax, word ptr [bp + 8]
  0597DF  352F: 39865eff         cmp word ptr [bp - 0xa2], ax
  0597E3  3533: 74b6             je 0x34eb
  0597E5  3535: ffb65eff         push word ptr [bp - 0xa2]
  0597E9  3539: ff7606           push word ptr [bp + 6]
  0597EC  353C: 9a380a1f18       lcall 0x181f, 0xa38
  0597F1  3541: 83c404           add sp, 4
  0597F4  3544: a820             test al, 0x20
  0597F6  3546: 74a3             je 0x34eb
  0597F8  3548: 8b865eff         mov ax, word ptr [bp - 0xa2]
  0597FC  354C: 40               inc ax
  0597FD  354D: 50               push ax
  0597FE  354E: ffb65eff         push word ptr [bp - 0xa2]
  059802  3552: 9a1a0a1f18       lcall 0x181f, 0xa1a
  059807  3557: 83c402           add sp, 2
  05980A  355A: 50               push ax
  05980B  355B: 9a22001f18       lcall 0x181f, 0x22
  059810  3560: 83c402           add sp, 2
  059813  3563: 52               push dx
  059814  3564: 50               push ax
  059815  3565: ff7698           push word ptr [bp - 0x68]
  059818  3568: ff7696           push word ptr [bp - 0x6a]
  05981B  356B: 9a76011f19       lcall 0x191f, 0x176
  059820  3570: 83c40a           add sp, 0xa
  059823  3573: c7866cff0100     mov word ptr [bp - 0x94], 1
  059829  3579: e96fff           jmp 0x34eb
  05982C  357C: 83be6cff00       cmp word ptr [bp - 0x94], 0
  059831  3581: 750f             jne 0x3592
  059833  3583: ff7698           push word ptr [bp - 0x68]
  059836  3586: ff7696           push word ptr [bp - 0x6a]
  059839  3589: 9aa8011f19       lcall 0x191f, 0x1a8
  05983E  358E: e9ad02           jmp 0x383e
  059841  3591: 90               nop 
  059842  3592: ff7698           push word ptr [bp - 0x68]
  059845  3595: ff7696           push word ptr [bp - 0x6a]
  059848  3598: 9a6a011f19       lcall 0x191f, 0x16a
  05984D  359D: 8946f8           mov word ptr [bp - 8], ax
  059850  35A0: ff7698           push word ptr [bp - 0x68]
  059853  35A3: ff7696           push word ptr [bp - 0x6a]
  059856  35A6: 9aa8011f19       lcall 0x191f, 0x1a8
  05985B  35AB: 2bc0             sub ax, ax
  05985D  35AD: 894698           mov word ptr [bp - 0x68], ax
  059860  35B0: 894696           mov word ptr [bp - 0x6a], ax
  059863  35B3: 3946f8           cmp word ptr [bp - 8], ax
  059866  35B6: 7f03             jg 0x35bb
  059868  35B8: e96f02           jmp 0x382a
  05986B  35BB: 8b46f8           mov ax, word ptr [bp - 8]
  05986E  35BE: 48               dec ax
  05986F  35BF: 898638ff         mov word ptr [bp - 0xc8], ax
  059873  35C3: 50               push ax
  059874  35C4: 9a1a0a1f18       lcall 0x181f, 0xa1a
  059879  35C9: 83c402           add sp, 2
  05987C  35CC: 50               push ax
  05987D  35CD: 6a00             push 0
  05987F  35CF: 9a38041f18       lcall 0x181f, 0x438
  059884  35D4: 83c404           add sp, 4
  059887  35D7: ffb638ff         push word ptr [bp - 0xc8]
  05988B  35DB: ff7608           push word ptr [bp + 8]
  05988E  35DE: 9a380a1f18       lcall 0x181f, 0xa38
  059893  35E3: 83c404           add sp, 4
  059896  35E6: a820             test al, 0x20
  059898  35E8: 7512             jne 0x35fc
  05989A  35EA: ff7608           push word ptr [bp + 8]
  05989D  35ED: 68031a           push 0x1a03
  0598A0  35F0: 9a88061f1a       lcall 0x1a1f, 0x688
  0598A5  35F5: 83c404           add sp, 4
  0598A8  35F8: e92f02           jmp 0x382a
  0598AB  35FB: 90               nop 
  0598AC  35FC: ffb638ff         push word ptr [bp - 0xc8]
  0598B0  3600: ff7608           push word ptr [bp + 8]
  0598B3  3603: 9a380a1f18       lcall 0x181f, 0xa38
  0598B8  3608: 83c404           add sp, 4
  0598BB  360B: a840             test al, 0x40
  0598BD  360D: 7509             jne 0x3618
  0598BF  360F: ff7608           push word ptr [bp + 8]
  0598C2  3612: 680d1a           push 0x1a0d
  0598C5  3615: ebd9             jmp 0x35f0
  0598C7  3617: 90               nop 
  0598C8  3618: 83be38ff04       cmp word ptr [bp - 0xc8], 4
  0598CD  361D: 7d03             jge 0x3622
  0598CF  361F: e9aa00           jmp 0x36cc
  0598D2  3622: ffb638ff         push word ptr [bp - 0xc8]
  0598D6  3626: 9a420a1f18       lcall 0x181f, 0xa42
  0598DB  362B: 83c402           add sp, 2
  0598DE  362E: 68c800           push 0xc8
  0598E1  3631: 6a0a             push 0xa
  0598E3  3633: 6a00             push 0
  0598E5  3635: 6a32             push 0x32
  0598E7  3637: 8b1e528d         mov bx, word ptr [0x8d52]
  0598EB  363B: 8a878491         mov al, byte ptr [bx - 0x6e7c]
  0598EF  363F: 2ae4             sub ah, ah
  0598F1  3641: 6a00             push 0
  0598F3  3643: 50               push ax
  0598F4  3644: 6a00             push 0
  0598F6  3646: 6a32             push 0x32
  0598F8  3648: 695e063c01       imul bx, word ptr [bp + 6], 0x13c
  0598FD  364D: ffb73488         push word ptr [bx - 0x77cc]
  059901  3651: ffb73288         push word ptr [bx - 0x77ce]
  059905  3655: 9ac60e1d0d       lcall 0xd1d, 0xec6
  05990A  365A: 52               push dx
  05990B  365B: 50               push ax
  05990C  365C: 9a600f1d0d       lcall 0xd1d, 0xf60
  059911  3661: 8bc8             mov cx, ax
  059913  3663: 8bda             mov bx, dx
  059915  3665: d1e0             shl ax, 1
  059917  3667: d1d2             rcl dx, 1
  059919  3669: 03c1             add ax, cx
  05991B  366B: 13d3             adc dx, bx
  05991D  366D: 52               push dx
  05991E  366E: 50               push ax
  05991F  366F: 9ac60e1d0d       lcall 0xd1d, 0xec6
  059924  3674: 50               push ax
  059925  3675: 9a5c031f18       lcall 0x181f, 0x35c
  05992A  367A: 83c406           add sp, 6
  05992D  367D: 6bc032           imul ax, ax, 0x32
  059930  3680: 89866cff         mov word ptr [bp - 0x94], ax
  059934  3684: 6a13             push 0x13
  059936  3686: ff7606           push word ptr [bp + 6]
  059939  3689: 9ab4071f18       lcall 0x181f, 0x7b4
  05993E  368E: 83c404           add sp, 4
  059941  3691: 0bc0             or ax, ax
  059943  3693: 7404             je 0x3699
  059945  3695: d1be6cff         sar word ptr [bp - 0x94], 1
  059949  3699: ffb638ff         push word ptr [bp - 0xc8]
  05994D  369D: 9aa4091f18       lcall 0x181f, 0x9a4
  059952  36A2: 83c402           add sp, 2
  059955  36A5: 50               push ax
  059956  36A6: 6a00             push 0
  059958  36A8: 9a38041f18       lcall 0x181f, 0x438
  05995D  36AD: 83c404           add sp, 4
  059960  36B0: 8b866cff         mov ax, word ptr [bp - 0x94]
  059964  36B4: 99               cdq 
  059965  36B5: 52               push dx
  059966  36B6: 50               push ax
  059967  36B7: 6a00             push 0
  059969  36B9: 9aae091f18       lcall 0x181f, 0x9ae
  05996E  36BE: 83c406           add sp, 6
  059971  36C1: ff7608           push word ptr [bp + 8]
  059974  36C4: 681a1a           push 0x1a1a
  059977  36C7: e99500           jmp 0x375f
  05997A  36CA: 90               nop 
  05997B  36CB: 90               nop 
  05997C  36CC: 68c800           push 0xc8
  05997F  36CF: 6a0a             push 0xa
  059981  36D1: 6a00             push 0
  059983  36D3: 6a32             push 0x32
  059985  36D5: 6a00             push 0
  059987  36D7: 6a32             push 0x32
  059989  36D9: 695e063c01       imul bx, word ptr [bp + 6], 0x13c
  05998E  36DE: ffb73488         push word ptr [bx - 0x77cc]
  059992  36E2: ffb73288         push word ptr [bx - 0x77ce]
  059996  36E6: 9ac60e1d0d       lcall 0xd1d, 0xec6
  05999B  36EB: 52               push dx
  05999C  36EC: 50               push ax
  05999D  36ED: 8b9e38ff         mov bx, word ptr [bp - 0xc8]
  0599A1  36F1: 8a872c94         mov al, byte ptr [bx - 0x6bd4]
  0599A5  36F5: 2ae4             sub ah, ah
  0599A7  36F7: d1e3             shl bx, 1
  0599A9  36F9: 03871c94         add ax, word ptr [bx - 0x6be4]
  0599AD  36FD: 6a00             push 0
  0599AF  36FF: 50               push ax
  0599B0  3700: 9a600f1d0d       lcall 0xd1d, 0xf60
  0599B5  3705: 52               push dx
  0599B6  3706: 50               push ax
  0599B7  3707: 9ac60e1d0d       lcall 0xd1d, 0xec6
  0599BC  370C: 50               push ax
  0599BD  370D: 9a5c031f18       lcall 0x181f, 0x35c
  0599C2  3712: 83c406           add sp, 6
  0599C5  3715: 6bc032           imul ax, ax, 0x32
  0599C8  3718: 89866cff         mov word ptr [bp - 0x94], ax
  0599CC  371C: 6a13             push 0x13
  0599CE  371E: ff7606           push word ptr [bp + 6]
  0599D1  3721: 9ab4071f18       lcall 0x181f, 0x7b4
  0599D6  3726: 83c404           add sp, 4
  0599D9  3729: 0bc0             or ax, ax
  0599DB  372B: 7404             je 0x3731
  0599DD  372D: d1be6cff         sar word ptr [bp - 0x94], 1
  0599E1  3731: ffb638ff         push word ptr [bp - 0xc8]
  0599E5  3735: 9aa4091f18       lcall 0x181f, 0x9a4
  0599EA  373A: 83c402           add sp, 2
  0599ED  373D: 50               push ax
  0599EE  373E: 6a00             push 0
  0599F0  3740: 9a38041f18       lcall 0x181f, 0x438
  0599F5  3745: 83c404           add sp, 4
  0599F8  3748: 8b866cff         mov ax, word ptr [bp - 0x94]
  0599FC  374C: 99               cdq 
  0599FD  374D: 52               push dx
  0599FE  374E: 50               push ax
  0599FF  374F: 6a00             push 0
  059A01  3751: 9aae091f18       lcall 0x181f, 0x9ae
  059A06  3756: 83c406           add sp, 6
  059A09  3759: ff7608           push word ptr [bp + 8]
  059A0C  375C: 68271a           push 0x1a27
  059A0F  375F: 9a88061f1a       lcall 0x1a1f, 0x688
  059A14  3764: 83c404           add sp, 4
  059A17  3767: 8946f8           mov word ptr [bp - 8], ax
  059A1A  376A: 3d0100           cmp ax, 1
  059A1D  376D: 7403             je 0x3772
  059A1F  376F: e9b800           jmp 0x382a
  059A22  3772: 8b866cff         mov ax, word ptr [bp - 0x94]
  059A26  3776: 99               cdq 
  059A27  3777: 8b1efc84         mov bx, word ptr [0x84fc]
  059A2B  377B: 39572c           cmp word ptr [bx + 0x2c], dx
  059A2E  377E: 7f10             jg 0x3790
  059A30  3780: 7c05             jl 0x3787
  059A32  3782: 39472a           cmp word ptr [bx + 0x2a], ax
  059A35  3785: 7309             jae 0x3790
  059A37  3787: ff7608           push word ptr [bp + 8]
  059A3A  378A: 68331a           push 0x1a33
  059A3D  378D: e960fe           jmp 0x35f0
  059A40  3790: 6a40             push 0x40
  059A42  3792: ffb638ff         push word ptr [bp - 0xc8]
  059A46  3796: ff7608           push word ptr [bp + 8]
  059A49  3799: 9a100a1f18       lcall 0x181f, 0xa10
  059A4E  379E: 83c406           add sp, 6
  059A51  37A1: 83be38ff04       cmp word ptr [bp - 0xc8], 4
  059A56  37A6: 7d10             jge 0x37b8
  059A58  37A8: 69b638ff3c01     imul si, word ptr [bp - 0xc8], 0x13c
  059A5E  37AE: 8b5e08           mov bx, word ptr [bp + 8]
  059A61  37B1: 80883c8802       or byte ptr [bx + si - 0x77c4], 2
  059A66  37B6: eb11             jmp 0x37c9
  059A68  37B8: 6a02             push 2
  059A6A  37BA: ffb638ff         push word ptr [bp - 0xc8]
  059A6E  37BE: ff7608           push word ptr [bp + 8]
  059A71  37C1: 9a060a1f18       lcall 0x181f, 0xa06
  059A76  37C6: 83c406           add sp, 6
  059A79  37C9: ff7608           push word ptr [bp + 8]
  059A7C  37CC: 9a1a0a1f18       lcall 0x181f, 0xa1a
  059A81  37D1: 83c402           add sp, 2
  059A84  37D4: 50               push ax
  059A85  37D5: 6a00             push 0
  059A87  37D7: 9a38041f18       lcall 0x181f, 0x438
  059A8C  37DC: 83c404           add sp, 4
  059A8F  37DF: ffb638ff         push word ptr [bp - 0xc8]
  059A93  37E3: 9a1a0a1f18       lcall 0x181f, 0xa1a
  059A98  37E8: 83c402           add sp, 2
  059A9B  37EB: 50               push ax
  059A9C  37EC: 6a01             push 1
  059A9E  37EE: 9a38041f18       lcall 0x181f, 0x438
  059AA3  37F3: 83c404           add sp, 4
  059AA6  37F6: 6a04             push 4
  059AA8  37F8: 9aac041f18       lcall 0x181f, 0x4ac
  059AAD  37FD: 83c402           add sp, 2
  059AB0  3800: ff7608           push word ptr [bp + 8]
  059AB3  3803: 683f1a           push 0x1a3f
  059AB6  3806: 9a88061f1a       lcall 0x1a1f, 0x688
  059ABB  380B: 83c404           add sp, 4
  059ABE  380E: 8b866cff         mov ax, word ptr [bp - 0x94]
  059AC2  3812: 99               cdq 
  059AC3  3813: 8b1efc84         mov bx, word ptr [0x84fc]
  059AC7  3817: 29472a           sub word ptr [bx + 0x2a], ax
  059ACA  381A: 19572c           sbb word ptr [bx + 0x2c], dx
  059ACD  381D: 695e083c01       imul bx, word ptr [bp + 8], 0x13c
  059AD2  3822: 01873288         add word ptr [bx - 0x77ce], ax
  059AD6  3826: 11973488         adc word ptr [bx - 0x77cc], dx
  059ADA  382A: 83be52ff00       cmp word ptr [bp - 0xae], 0
  059ADF  382F: 740d             je 0x383e
  059AE1  3831: 6976083c01       imul si, word ptr [bp + 8], 0x13c
  059AE6  3836: 8b5e06           mov bx, word ptr [bp + 6]
  059AE9  3839: 80883c8808       or byte ptr [bx + si - 0x77c4], 8
  059AEE  383E: ff7608           push word ptr [bp + 8]
  059AF1  3841: ff7606           push word ptr [bp + 6]
  059AF4  3844: 9a380a1f18       lcall 0x181f, 0xa38
  059AF9  3849: 83c404           add sp, 4
  059AFC  384C: a840             test al, 0x40
  059AFE  384E: 7435             je 0x3885
  059B00  3850: a0a653           mov al, byte ptr [0x53a6]
  059B03  3853: 2ae4             sub ah, ah
  059B05  3855: 2d0600           sub ax, 6
  059B08  3858: f7d8             neg ax
  059B0A  385A: d1e0             shl ax, 1
  059B0C  385C: 89866cff         mov word ptr [bp - 0x94], ax
  059B10  3860: 6a13             push 0x13
  059B12  3862: ff7606           push word ptr [bp + 6]
  059B15  3865: 9ab4071f18       lcall 0x181f, 0x7b4
  059B1A  386A: 83c404           add sp, 4
  059B1D  386D: 0bc0             or ax, ax
  059B1F  386F: 7404             je 0x3875
  059B21  3871: d1be6cff         sar word ptr [bp - 0x94], 1
  059B25  3875: 8a866cff         mov al, byte ptr [bp - 0x94]
  059B29  3879: 6976083c01       imul si, word ptr [bp + 8], 0x13c
  059B2E  387E: 8b5e06           mov bx, word ptr [bp + 6]
  059B31  3881: 88804888         mov byte ptr [bx + si - 0x77b8], al
  059B35  3885: 8b8674ff         mov ax, word ptr [bp - 0x8c]
  059B39  3889: 5e               pop si
  059B3A  388A: 5f               pop di
  059B3B  388B: c9               leave 
  059B3C  388C: cb               retf 

; ---- func_059B3E  size=81  insns=26  prologue=ENTER 0x0002,0  terminal=RETF ----
  059B3E  388E: c8020000         enter 2, 0
  059B42  3892: ff7606           push word ptr [bp + 6]
  059B45  3895: 9a0c091f18       lcall 0x181f, 0x90c
  059B4A  389A: 83c402           add sp, 2
  059B4D  389D: 2ae4             sub ah, ah
  059B4F  389F: 050300           add ax, 3
  059B52  38A2: 8946fe           mov word ptr [bp - 2], ax
  059B55  38A5: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  059B59  38A9: 80bf463110       cmp byte ptr [bx + 0x3146], 0x10
  059B5E  38AE: 7503             jne 0x38b3
  059B60  38B0: d166fe           shl word ptr [bp - 2], 1
  059B63  38B3: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  059B67  38B7: 80bf46310f       cmp byte ptr [bx + 0x3146], 0xf
  059B6C  38BC: 7504             jne 0x38c2
  059B6E  38BE: 8346fe03         add word ptr [bp - 2], 3
  059B72  38C2: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  059B76  38C6: 8a875031         mov al, byte ptr [bx + 0x3150]
  059B7A  38CA: 2ae4             sub ah, ah
  059B7C  38CC: c1e002           shl ax, 2
  059B7F  38CF: 2946fe           sub word ptr [bp - 2], ax
  059B82  38D2: 8b46fe           mov ax, word ptr [bp - 2]
  059B85  38D5: 3d0100           cmp ax, 1
  059B88  38D8: 7d03             jge 0x38dd
  059B8A  38DA: b80100           mov ax, 1
  059B8D  38DD: c9               leave 
  059B8E  38DE: cb               retf 

; ---- func_059B90  size=2173  insns=729  prologue=ENTER 0x004A,0  terminal=RETF ----
  059B90  38E0: c84a0000         enter 0x4a, 0
  059B94  38E4: 56               push si
  059B95  38E5: 2bc0             sub ax, ax
  059B97  38E7: 8946c8           mov word ptr [bp - 0x38], ax
  059B9A  38EA: 8946ca           mov word ptr [bp - 0x36], ax
  059B9D  38ED: eb0e             jmp 0x38fd
  059B9F  38EF: 90               nop 
  059BA0  38F0: 8b76ca           mov si, word ptr [bp - 0x36]
  059BA3  38F3: d1e6             shl si, 1
  059BA5  38F5: c742e20000       mov word ptr [bp + si - 0x1e], 0
  059BAA  38FA: ff46ca           inc word ptr [bp - 0x36]
  059BAD  38FD: 837eca0c         cmp word ptr [bp - 0x36], 0xc
  059BB1  3901: 7ced             jl 0x38f0
  059BB3  3903: 8b4606           mov ax, word ptr [bp + 6]
  059BB6  3906: 8946be           mov word ptr [bp - 0x42], ax
  059BB9  3909: 6bd81c           imul bx, ax, 0x1c
  059BBC  390C: 8a8f4731         mov cl, byte ptr [bx + 0x3147]
  059BC0  3910: 83e10f           and cx, 0xf
  059BC3  3913: 894eb6           mov word ptr [bp - 0x4a], cx
  059BC6  3916: 50               push ax
  059BC7  3917: 9a0c091f18       lcall 0x181f, 0x90c
  059BCC  391C: 83c402           add sp, 2
  059BCF  391F: 2ae4             sub ah, ah
  059BD1  3921: 8946c4           mov word ptr [bp - 0x3c], ax
  059BD4  3924: ff760a           push word ptr [bp + 0xa]
  059BD7  3927: ff7608           push word ptr [bp + 8]
  059BDA  392A: 9a68071f18       lcall 0x181f, 0x768
  059BDF  392F: 83c404           add sp, 4
  059BE2  3932: 8946cc           mov word ptr [bp - 0x34], ax
  059BE5  3935: ff760a           push word ptr [bp + 0xa]
  059BE8  3938: ff7608           push word ptr [bp + 8]
  059BEB  393B: 9a96061f18       lcall 0x181f, 0x696
  059BF0  3940: 83c404           add sp, 4
  059BF3  3943: 0bc0             or ax, ax
  059BF5  3945: 7c05             jl 0x394c
  059BF7  3947: b80100           mov ax, 1
  059BFA  394A: eb02             jmp 0x394e
  059BFC  394C: 2bc0             sub ax, ax
  059BFE  394E: 8946ce           mov word ptr [bp - 0x32], ax
  059C01  3951: c746d20000       mov word ptr [bp - 0x2e], 0
  059C06  3956: e93304           jmp 0x3d8c
  059C09  3959: 90               nop 
  059C0A  395A: 8b46c0           mov ax, word ptr [bp - 0x40]
  059C0D  395D: 8946fe           mov word ptr [bp - 2], ax
  059C10  3960: 8b46b6           mov ax, word ptr [bp - 0x4a]
  059C13  3963: 8946fa           mov word ptr [bp - 6], ax
  059C16  3966: 8b4efe           mov cx, word ptr [bp - 2]
  059C19  3969: 894ebc           mov word ptr [bp - 0x44], cx
  059C1C  396C: 0bc9             or cx, cx
  059C1E  396E: 7d03             jge 0x3973
  059C20  3970: e91004           jmp 0x3d83
  059C23  3973: 3bc1             cmp ax, cx
  059C25  3975: 7503             jne 0x397a
  059C27  3977: e90904           jmp 0x3d83
  059C2A  397A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  059C2E  397E: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  059C33  3983: 7303             jae 0x3988
  059C35  3985: e95602           jmp 0x3bde
  059C38  3988: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  059C3D  398D: 7603             jbe 0x3992
  059C3F  398F: e94c02           jmp 0x3bde
  059C42  3992: 837ecc00         cmp word ptr [bp - 0x34], 0
  059C46  3996: 7503             jne 0x399b
  059C48  3998: e94302           jmp 0x3bde
  059C4B  399B: ff76ba           push word ptr [bp - 0x46]
  059C4E  399E: ff76c2           push word ptr [bp - 0x3e]
  059C51  39A1: 8bf3             mov si, bx
  059C53  39A3: 9a68071f18       lcall 0x181f, 0x768
  059C58  39A8: 83c404           add sp, 4
  059C5B  39AB: 0bc0             or ax, ax
  059C5D  39AD: 7503             jne 0x39b2
  059C5F  39AF: e92c02           jmp 0x3bde
  059C62  39B2: 837ebe00         cmp word ptr [bp - 0x42], 0
  059C66  39B6: 7d03             jge 0x39bb
  059C68  39B8: e92302           jmp 0x3bde
  059C6B  39BB: ff76bc           push word ptr [bp - 0x44]
  059C6E  39BE: ff76fa           push word ptr [bp - 6]
  059C71  39C1: 9a380a1f18       lcall 0x181f, 0xa38
  059C76  39C6: 83c404           add sp, 4
  059C79  39C9: a840             test al, 0x40
  059C7B  39CB: 740a             je 0x39d7
  059C7D  39CD: 80bc463110       cmp byte ptr [si + 0x3146], 0x10
  059C82  39D2: 7403             je 0x39d7
  059C84  39D4: e90702           jmp 0x3bde
  059C87  39D7: 8b46be           mov ax, word ptr [bp - 0x42]
  059C8A  39DA: 8946d4           mov word ptr [bp - 0x2c], ax
  059C8D  39DD: e9ce01           jmp 0x3bae
  059C90  39E0: c746d60000       mov word ptr [bp - 0x2a], 0
  059C95  39E5: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  059C99  39E9: 80bf463110       cmp byte ptr [bx + 0x3146], 0x10
  059C9E  39EE: 7505             jne 0x39f5
  059CA0  39F0: c746d60400       mov word ptr [bp - 0x2a], 4
  059CA5  39F5: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  059CA9  39F9: 80bf463111       cmp byte ptr [bx + 0x3146], 0x11
  059CAE  39FE: 7505             jne 0x3a05
  059CB0  3A00: c746d60600       mov word ptr [bp - 0x2a], 6
  059CB5  3A05: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  059CB9  3A09: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  059CBE  3A0E: 7505             jne 0x3a15
  059CC0  3A10: c746d60800       mov word ptr [bp - 0x2a], 8
  059CC5  3A15: 837ed600         cmp word ptr [bp - 0x2a], 0
  059CC9  3A19: 7503             jne 0x3a1e
  059CCB  3A1B: e9f900           jmp 0x3b17
  059CCE  3A1E: ff7606           push word ptr [bp + 6]
  059CD1  3A21: 0e               push cs
  059CD2  3A22: e81505           call 0x3f3a
  059CD5  3A25: 83c402           add sp, 2
  059CD8  3A28: 8946fc           mov word ptr [bp - 4], ax
  059CDB  3A2B: ff76be           push word ptr [bp - 0x42]
  059CDE  3A2E: 0e               push cs
  059CDF  3A2F: e80805           call 0x3f3a
  059CE2  3A32: 83c402           add sp, 2
  059CE5  3A35: 40               inc ax
  059CE6  3A36: 40               inc ax
  059CE7  3A37: 8946d8           mov word ptr [bp - 0x28], ax
  059CEA  3A3A: 0346fc           add ax, word ptr [bp - 4]
  059CED  3A3D: 8946da           mov word ptr [bp - 0x26], ax
  059CF0  3A40: 50               push ax
  059CF1  3A41: 6a01             push 1
  059CF3  3A43: 9ad4041f18       lcall 0x181f, 0x4d4
  059CF8  3A48: 83c404           add sp, 4
  059CFB  3A4B: 8946dc           mov word ptr [bp - 0x24], ax
  059CFE  3A4E: 3b46fc           cmp ax, word ptr [bp - 4]
  059D01  3A51: 7d07             jge 0x3a5a
  059D03  3A53: c746d60000       mov word ptr [bp - 0x2a], 0
  059D08  3A58: eb0b             jmp 0x3a65
  059D0A  3A5A: 8b46fc           mov ax, word ptr [bp - 4]
  059D0D  3A5D: 3946dc           cmp word ptr [bp - 0x24], ax
  059D10  3A60: 7503             jne 0x3a65
  059D12  3A62: d17ed6           sar word ptr [bp - 0x2a], 1
  059D15  3A65: 837ed600         cmp word ptr [bp - 0x2a], 0
  059D19  3A69: 7403             je 0x3a6e
  059D1B  3A6B: e9a900           jmp 0x3b17
  059D1E  3A6E: 837efa04         cmp word ptr [bp - 6], 4
  059D22  3A72: 7d0b             jge 0x3a7f
  059D24  3A74: 6b5efa34         imul bx, word ptr [bp - 6], 0x34
  059D28  3A78: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  059D2D  3A7D: 7417             je 0x3a96
  059D2F  3A7F: 837ebc04         cmp word ptr [bp - 0x44], 4
  059D33  3A83: 7c03             jl 0x3a88
  059D35  3A85: e98f00           jmp 0x3b17
  059D38  3A88: 6b5ebc34         imul bx, word ptr [bp - 0x44], 0x34
  059D3C  3A8C: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  059D41  3A91: 7403             je 0x3a96
  059D43  3A93: e98100           jmp 0x3b17
  059D46  3A96: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  059D4A  3A9A: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  059D4E  3A9E: 2aff             sub bh, bh
  059D50  3AA0: 8bc3             mov ax, bx
  059D52  3AA2: d1e3             shl bx, 1
  059D54  3AA4: 03d8             add bx, ax
  059D56  3AA6: d1e3             shl bx, 1
  059D58  3AA8: 03d8             add bx, ax
  059D5A  3AAA: d1e3             shl bx, 1
  059D5C  3AAC: ffb73052         push word ptr [bx + 0x5230]
  059D60  3AB0: 6a00             push 0
  059D62  3AB2: 9a38041f18       lcall 0x181f, 0x438
  059D67  3AB7: 83c404           add sp, 4
  059D6A  3ABA: ff76bc           push word ptr [bp - 0x44]
  059D6D  3ABD: 9aa4091f18       lcall 0x181f, 0x9a4
  059D72  3AC2: 83c402           add sp, 2
  059D75  3AC5: 50               push ax
  059D76  3AC6: 6a01             push 1
  059D78  3AC8: 9a38041f18       lcall 0x181f, 0x438
  059D7D  3ACD: 83c404           add sp, 4
  059D80  3AD0: ff76fa           push word ptr [bp - 6]
  059D83  3AD3: 9aa4091f18       lcall 0x181f, 0x9a4
  059D88  3AD8: 83c402           add sp, 2
  059D8B  3ADB: 50               push ax
  059D8C  3ADC: 6a02             push 2
  059D8E  3ADE: 9a38041f18       lcall 0x181f, 0x438
  059D93  3AE3: 83c404           add sp, 4
  059D96  3AE6: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  059D9A  3AEA: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  059D9E  3AEE: 2aff             sub bh, bh
  059DA0  3AF0: 8bc3             mov ax, bx
  059DA2  3AF2: d1e3             shl bx, 1
  059DA4  3AF4: 03d8             add bx, ax
  059DA6  3AF6: d1e3             shl bx, 1
  059DA8  3AF8: 03d8             add bx, ax
  059DAA  3AFA: d1e3             shl bx, 1
  059DAC  3AFC: ffb73052         push word ptr [bx + 0x5230]
  059DB0  3B00: 6a03             push 3
  059DB2  3B02: 9a38041f18       lcall 0x181f, 0x438
  059DB7  3B07: 83c404           add sp, 4
  059DBA  3B0A: 6a00             push 0
  059DBC  3B0C: 68491a           push 0x1a49
  059DBF  3B0F: 9a52061f18       lcall 0x181f, 0x652
  059DC4  3B14: 83c404           add sp, 4
  059DC7  3B17: 837ed600         cmp word ptr [bp - 0x2a], 0
  059DCB  3B1B: 7503             jne 0x3b20
  059DCD  3B1D: e98300           jmp 0x3ba3
  059DD0  3B20: 8a46d6           mov al, byte ptr [bp - 0x2a]
  059DD3  3B23: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  059DD7  3B27: 00874931         add byte ptr [bx + 0x3149], al
  059DDB  3B2B: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  059DDF  3B2F: 2aff             sub bh, bh
  059DE1  3B31: 8bc3             mov ax, bx
  059DE3  3B33: d1e3             shl bx, 1
  059DE5  3B35: 03d8             add bx, ax
  059DE7  3B37: d1e3             shl bx, 1
  059DE9  3B39: 03d8             add bx, ax
  059DEB  3B3B: d1e3             shl bx, 1
  059DED  3B3D: ffb73052         push word ptr [bx + 0x5230]
  059DF1  3B41: 6a00             push 0
  059DF3  3B43: 9a38041f18       lcall 0x181f, 0x438
  059DF8  3B48: 83c404           add sp, 4
  059DFB  3B4B: ff76fe           push word ptr [bp - 2]
  059DFE  3B4E: 9aa4091f18       lcall 0x181f, 0x9a4
  059E03  3B53: 83c402           add sp, 2
  059E06  3B56: 50               push ax
  059E07  3B57: 6a01             push 1
  059E09  3B59: 9a38041f18       lcall 0x181f, 0x438
  059E0E  3B5E: 83c404           add sp, 4
  059E11  3B61: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  059E15  3B65: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  059E19  3B69: 2aff             sub bh, bh
  059E1B  3B6B: 8bc3             mov ax, bx
  059E1D  3B6D: d1e3             shl bx, 1
  059E1F  3B6F: 03d8             add bx, ax
  059E21  3B71: d1e3             shl bx, 1
  059E23  3B73: 03d8             add bx, ax
  059E25  3B75: d1e3             shl bx, 1
  059E27  3B77: ffb73052         push word ptr [bx + 0x5230]
  059E2B  3B7B: 6a02             push 2
  059E2D  3B7D: 9a38041f18       lcall 0x181f, 0x438
  059E32  3B82: 83c404           add sp, 4
  059E35  3B85: 837efa04         cmp word ptr [bp - 6], 4
  059E39  3B89: 7d18             jge 0x3ba3
  059E3B  3B8B: 6b5efa34         imul bx, word ptr [bp - 6], 0x34
  059E3F  3B8F: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  059E44  3B94: 750d             jne 0x3ba3
  059E46  3B96: 6a00             push 0
  059E48  3B98: 68511a           push 0x1a51
  059E4B  3B9B: 9a52061f18       lcall 0x181f, 0x652
  059E50  3BA0: 83c404           add sp, 4
  059E53  3BA3: 8b46be           mov ax, word ptr [bp - 0x42]
  059E56  3BA6: 9ae4021f18       lcall 0x181f, 0x2e4
  059E5B  3BAB: 8946be           mov word ptr [bp - 0x42], ax
  059E5E  3BAE: 0bc0             or ax, ax
  059E60  3BB0: 7c26             jl 0x3bd8
  059E62  3BB2: 8a46c4           mov al, byte ptr [bp - 0x3c]
  059E65  3BB5: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  059E69  3BB9: 38874931         cmp byte ptr [bx + 0x3149], al
  059E6D  3BBD: 7319             jae 0x3bd8
  059E6F  3BBF: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  059E73  3BC3: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  059E78  3BC8: 72d9             jb 0x3ba3
  059E7A  3BCA: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  059E7F  3BCF: 7703             ja 0x3bd4
  059E81  3BD1: e90cfe           jmp 0x39e0
  059E84  3BD4: ebcd             jmp 0x3ba3
  059E86  3BD6: 90               nop 
  059E87  3BD7: 90               nop 
  059E88  3BD8: 8b46d4           mov ax, word ptr [bp - 0x2c]
  059E8B  3BDB: 8946be           mov word ptr [bp - 0x42], ax
  059E8E  3BDE: 837ec000         cmp word ptr [bp - 0x40], 0
  059E92  3BE2: 7c06             jl 0x3bea
  059E94  3BE4: b80100           mov ax, 1
  059E97  3BE7: eb03             jmp 0x3bec
  059E99  3BE9: 90               nop 
  059E9A  3BEA: 2bc0             sub ax, ax
  059E9C  3BEC: 8946c0           mov word ptr [bp - 0x40], ax
  059E9F  3BEF: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  059EA3  3BF3: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  059EA8  3BF8: 7303             jae 0x3bfd
  059EAA  3BFA: e90501           jmp 0x3d02
  059EAD  3BFD: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  059EB2  3C02: 7603             jbe 0x3c07
  059EB4  3C04: e9fb00           jmp 0x3d02
  059EB7  3C07: 0bc0             or ax, ax
  059EB9  3C09: 7503             jne 0x3c0e
  059EBB  3C0B: e9f400           jmp 0x3d02
  059EBE  3C0E: 8a46c4           mov al, byte ptr [bp - 0x3c]
  059EC1  3C11: 38874931         cmp byte ptr [bx + 0x3149], al
  059EC5  3C15: 7203             jb 0x3c1a
  059EC7  3C17: e9e800           jmp 0x3d02
  059ECA  3C1A: ff76bc           push word ptr [bp - 0x44]
  059ECD  3C1D: ff76fa           push word ptr [bp - 6]
  059ED0  3C20: 8bf3             mov si, bx
  059ED2  3C22: 9a380a1f18       lcall 0x181f, 0xa38
  059ED7  3C27: 83c404           add sp, 4
  059EDA  3C2A: a840             test al, 0x40
  059EDC  3C2C: 740a             je 0x3c38
  059EDE  3C2E: 80bc463110       cmp byte ptr [si + 0x3146], 0x10
  059EE3  3C33: 7403             je 0x3c38
  059EE5  3C35: e9ca00           jmp 0x3d02
  059EE8  3C38: ff76ba           push word ptr [bp - 0x46]
  059EEB  3C3B: ff76c2           push word ptr [bp - 0x3e]
  059EEE  3C3E: 9abe071f18       lcall 0x181f, 0x7be
  059EF3  3C43: 83c404           add sp, 4
  059EF6  3C46: 8946c6           mov word ptr [bp - 0x3a], ax
  059EF9  3C49: 0bc0             or ax, ax
  059EFB  3C4B: 7d03             jge 0x3c50
  059EFD  3C4D: e9b200           jmp 0x3d02
  059F00  3C50: 50               push ax
  059F01  3C51: 9ae6091f18       lcall 0x181f, 0x9e6
  059F06  3C56: 83c402           add sp, 2
  059F09  3C59: c746d6ffff       mov word ptr [bp - 0x2a], 0xffff
  059F0E  3C5E: 6a02             push 2
  059F10  3C60: 9afc091f18       lcall 0x181f, 0x9fc
  059F15  3C65: 83c402           add sp, 2
  059F18  3C68: 0bc0             or ax, ax
  059F1A  3C6A: 740e             je 0x3c7a
  059F1C  3C6C: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  059F20  3C70: 8087493132       add byte ptr [bx + 0x3149], 0x32
  059F25  3C75: a19a8f           mov ax, word ptr [0x8f9a]
  059F28  3C78: eb1a             jmp 0x3c94
  059F2A  3C7A: 6a01             push 1
  059F2C  3C7C: 9afc091f18       lcall 0x181f, 0x9fc
  059F31  3C81: 83c402           add sp, 2
  059F34  3C84: 0bc0             or ax, ax
  059F36  3C86: 740f             je 0x3c97
  059F38  3C88: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  059F3C  3C8C: 8087493102       add byte ptr [bx + 0x3149], 2
  059F41  3C91: a18e8f           mov ax, word ptr [0x8f8e]
  059F44  3C94: 8946d6           mov word ptr [bp - 0x2a], ax
  059F47  3C97: 837ed600         cmp word ptr [bp - 0x2a], 0
  059F4B  3C9B: 7c65             jl 0x3d02
  059F4D  3C9D: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  059F51  3CA1: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  059F55  3CA5: 2aff             sub bh, bh
  059F57  3CA7: 8bc3             mov ax, bx
  059F59  3CA9: d1e3             shl bx, 1
  059F5B  3CAB: 03d8             add bx, ax
  059F5D  3CAD: d1e3             shl bx, 1
  059F5F  3CAF: 03d8             add bx, ax
  059F61  3CB1: d1e3             shl bx, 1
  059F63  3CB3: ffb73052         push word ptr [bx + 0x5230]
  059F67  3CB7: 6a00             push 0
  059F69  3CB9: 9a38041f18       lcall 0x181f, 0x438
  059F6E  3CBE: 83c404           add sp, 4
  059F71  3CC1: ff76fe           push word ptr [bp - 2]
  059F74  3CC4: 9aa4091f18       lcall 0x181f, 0x9a4
  059F79  3CC9: 83c402           add sp, 2
  059F7C  3CCC: 50               push ax
  059F7D  3CCD: 6a01             push 1
  059F7F  3CCF: 9a38041f18       lcall 0x181f, 0x438
  059F84  3CD4: 83c404           add sp, 4
  059F87  3CD7: ff76d6           push word ptr [bp - 0x2a]
  059F8A  3CDA: 6a02             push 2
  059F8C  3CDC: 9a38041f18       lcall 0x181f, 0x438
  059F91  3CE1: 83c404           add sp, 4
  059F94  3CE4: 837efa04         cmp word ptr [bp - 6], 4
  059F98  3CE8: 7d18             jge 0x3d02
  059F9A  3CEA: 6b5efa34         imul bx, word ptr [bp - 6], 0x34
  059F9E  3CEE: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  059FA3  3CF3: 750d             jne 0x3d02
  059FA5  3CF5: 6a00             push 0
  059FA7  3CF7: 685a1a           push 0x1a5a
  059FAA  3CFA: 9a52061f18       lcall 0x181f, 0x652
  059FAF  3CFF: 83c404           add sp, 4
  059FB2  3D02: 837ece00         cmp word ptr [bp - 0x32], 0
  059FB6  3D06: 7519             jne 0x3d21
  059FB8  3D08: 837ec000         cmp word ptr [bp - 0x40], 0
  059FBC  3D0C: 7513             jne 0x3d21
  059FBE  3D0E: ff76ba           push word ptr [bp - 0x46]
  059FC1  3D11: ff76c2           push word ptr [bp - 0x3e]
  059FC4  3D14: 9a68071f18       lcall 0x181f, 0x768
  059FC9  3D19: 83c404           add sp, 4
  059FCC  3D1C: 3b46cc           cmp ax, word ptr [bp - 0x34]
  059FCF  3D1F: 7562             jne 0x3d83
  059FD1  3D21: 837ebe00         cmp word ptr [bp - 0x42], 0
  059FD5  3D25: 7c5c             jl 0x3d83
  059FD7  3D27: 8b46be           mov ax, word ptr [bp - 0x42]
  059FDA  3D2A: 8946d4           mov word ptr [bp - 0x2c], ax
  059FDD  3D2D: eb4a             jmp 0x3d79
  059FDF  3D2F: 90               nop 
  059FE0  3D30: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  059FE4  3D34: 80bf4c3101       cmp byte ptr [bx + 0x314c], 1
  059FE9  3D39: 7533             jne 0x3d6e
  059FEB  3D3B: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  059FF0  3D40: 7207             jb 0x3d49
  059FF2  3D42: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  059FF7  3D47: 761c             jbe 0x3d65
  059FF9  3D49: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  059FFD  3D4D: 8a874531         mov al, byte ptr [bx + 0x3145]
  05A001  3D51: 2ae4             sub ah, ah
  05A003  3D53: 50               push ax
  05A004  3D54: 8a874431         mov al, byte ptr [bx + 0x3144]
  05A008  3D58: 50               push ax
  05A009  3D59: 9a68071f18       lcall 0x181f, 0x768
  05A00E  3D5E: 83c404           add sp, 4
  05A011  3D61: 0bc0             or ax, ax
  05A013  3D63: 7509             jne 0x3d6e
  05A015  3D65: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  05A019  3D69: c6874c3100       mov byte ptr [bx + 0x314c], 0
  05A01E  3D6E: 8b46be           mov ax, word ptr [bp - 0x42]
  05A021  3D71: 9ae4021f18       lcall 0x181f, 0x2e4
  05A026  3D76: 8946be           mov word ptr [bp - 0x42], ax
  05A029  3D79: 0bc0             or ax, ax
  05A02B  3D7B: 7db3             jge 0x3d30
  05A02D  3D7D: 8b46d4           mov ax, word ptr [bp - 0x2c]
  05A030  3D80: 8946be           mov word ptr [bp - 0x42], ax
  05A033  3D83: 837ecc00         cmp word ptr [bp - 0x34], 0
  05A037  3D87: 7455             je 0x3dde
  05A039  3D89: ff46d2           inc word ptr [bp - 0x2e]
  05A03C  3D8C: 837ed208         cmp word ptr [bp - 0x2e], 8
  05A040  3D90: 7c03             jl 0x3d95
  05A042  3D92: e98d01           jmp 0x3f22
  05A045  3D95: 8b5ed2           mov bx, word ptr [bp - 0x2e]
  05A048  3D98: 8a87be00         mov al, byte ptr [bx + 0xbe]
  05A04C  3D9C: 98               cwde 
  05A04D  3D9D: 03460a           add ax, word ptr [bp + 0xa]
  05A050  3DA0: 8946ba           mov word ptr [bp - 0x46], ax
  05A053  3DA3: 50               push ax
  05A054  3DA4: 8a87b400         mov al, byte ptr [bx + 0xb4]
  05A058  3DA8: 98               cwde 
  05A059  3DA9: 034608           add ax, word ptr [bp + 8]
  05A05C  3DAC: 8946c2           mov word ptr [bp - 0x3e], ax
  05A05F  3DAF: 50               push ax
  05A060  3DB0: 9abe061f18       lcall 0x181f, 0x6be
  05A065  3DB5: 83c404           add sp, 4
  05A068  3DB8: 8946c0           mov word ptr [bp - 0x40], ax
  05A06B  3DBB: 8b46c2           mov ax, word ptr [bp - 0x3e]
  05A06E  3DBE: 8b56ba           mov dx, word ptr [bp - 0x46]
  05A071  3DC1: 9ae0071f18       lcall 0x181f, 0x7e0
  05A076  3DC6: 8946be           mov word ptr [bp - 0x42], ax
  05A079  3DC9: 0bc0             or ax, ax
  05A07B  3DCB: 7d03             jge 0x3dd0
  05A07D  3DCD: e98afb           jmp 0x395a
  05A080  3DD0: 6bd81c           imul bx, ax, 0x1c
  05A083  3DD3: 8a874731         mov al, byte ptr [bx + 0x3147]
  05A087  3DD7: 250f00           and ax, 0xf
  05A08A  3DDA: e980fb           jmp 0x395d
  05A08D  3DDD: 90               nop 
  05A08E  3DDE: ff76ba           push word ptr [bp - 0x46]
  05A091  3DE1: ff76c2           push word ptr [bp - 0x3e]
  05A094  3DE4: 9a68071f18       lcall 0x181f, 0x768
  05A099  3DE9: 83c404           add sp, 4
  05A09C  3DEC: 0bc0             or ax, ax
  05A09E  3DEE: 7599             jne 0x3d89
  05A0A0  3DF0: 3946fe           cmp word ptr [bp - 2], ax
  05A0A3  3DF3: 7c94             jl 0x3d89
  05A0A5  3DF5: 8b46fe           mov ax, word ptr [bp - 2]
  05A0A8  3DF8: 3946b6           cmp word ptr [bp - 0x4a], ax
  05A0AB  3DFB: 748c             je 0x3d89
  05A0AD  3DFD: 8bf0             mov si, ax
  05A0AF  3DFF: d1e6             shl si, 1
  05A0B1  3E01: 837ae200         cmp word ptr [bp + si - 0x1e], 0
  05A0B5  3E05: 7582             jne 0x3d89
  05A0B7  3E07: 837ebe00         cmp word ptr [bp - 0x42], 0
  05A0BB  3E0B: 7c0b             jl 0x3e18
  05A0BD  3E0D: 8a46d2           mov al, byte ptr [bp - 0x2e]
  05A0C0  3E10: 6b5ebe1c         imul bx, word ptr [bp - 0x42], 0x1c
  05A0C4  3E14: 88874f31         mov byte ptr [bx + 0x314f], al
  05A0C8  3E18: 837eb604         cmp word ptr [bp - 0x4a], 4
  05A0CC  3E1C: 7c48             jl 0x3e66
  05A0CE  3E1E: 837efe04         cmp word ptr [bp - 2], 4
  05A0D2  3E22: 7c42             jl 0x3e66
  05A0D4  3E24: 8b46fe           mov ax, word ptr [bp - 2]
  05A0D7  3E27: 2d0400           sub ax, 4
  05A0DA  3E2A: 8946d0           mov word ptr [bp - 0x30], ax
  05A0DD  3E2D: 6bd84e           imul bx, ax, 0x4e
  05A0E0  3E30: 8b46b6           mov ax, word ptr [bp - 0x4a]
  05A0E3  3E33: 2d0400           sub ax, 4
  05A0E6  3E36: 8946de           mov word ptr [bp - 0x22], ax
  05A0E9  3E39: 6bf04e           imul si, ax, 0x4e
  05A0EC  3E3C: 8a84de5a         mov al, byte ptr [si + 0x5ade]
  05A0F0  3E40: 3a87de5a         cmp al, byte ptr [bx + 0x5ade]
  05A0F4  3E44: 7d04             jge 0x3e4a
  05A0F6  3E46: 8a87de5a         mov al, byte ptr [bx + 0x5ade]
  05A0FA  3E4A: 8846e0           mov byte ptr [bp - 0x20], al
  05A0FD  3E4D: 8884de5a         mov byte ptr [si + 0x5ade], al
  05A101  3E51: 8a46e0           mov al, byte ptr [bp - 0x20]
  05A104  3E54: 8887de5a         mov byte ptr [bx + 0x5ade], al
  05A108  3E58: 8b76fe           mov si, word ptr [bp - 2]
  05A10B  3E5B: d1e6             shl si, 1
  05A10D  3E5D: c742e20100       mov word ptr [bp + si - 0x1e], 1
  05A112  3E62: e924ff           jmp 0x3d89
  05A115  3E65: 90               nop 
  05A116  3E66: 837eb604         cmp word ptr [bp - 0x4a], 4
  05A11A  3E6A: 7d12             jge 0x3e7e
  05A11C  3E6C: 6b5eb634         imul bx, word ptr [bp - 0x4a], 0x34
  05A120  3E70: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05A125  3E75: 7507             jne 0x3e7e
  05A127  3E77: c746c80100       mov word ptr [bp - 0x38], 1
  05A12C  3E7C: eb34             jmp 0x3eb2
  05A12E  3E7E: 837efe04         cmp word ptr [bp - 2], 4
  05A132  3E82: 7d12             jge 0x3e96
  05A134  3E84: 6b5efe34         imul bx, word ptr [bp - 2], 0x34
  05A138  3E88: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05A13D  3E8D: 7507             jne 0x3e96
  05A13F  3E8F: c746c80100       mov word ptr [bp - 0x38], 1
  05A144  3E94: eb0c             jmp 0x3ea2
  05A146  3E96: 837eb604         cmp word ptr [bp - 0x4a], 4
  05A14A  3E9A: 7c16             jl 0x3eb2
  05A14C  3E9C: 837efe04         cmp word ptr [bp - 2], 4
  05A150  3EA0: 7d10             jge 0x3eb2
  05A152  3EA2: 8d46bc           lea ax, [bp - 0x44]
  05A155  3EA5: 50               push ax
  05A156  3EA6: 8d46fa           lea ax, [bp - 6]
  05A159  3EA9: 50               push ax
  05A15A  3EAA: 9a66031f18       lcall 0x181f, 0x366
  05A15F  3EAF: 83c404           add sp, 4
  05A162  3EB2: 837ebc04         cmp word ptr [bp - 0x44], 4
  05A166  3EB6: 7c06             jl 0x3ebe
  05A168  3EB8: b80100           mov ax, 1
  05A16B  3EBB: eb03             jmp 0x3ec0
  05A16D  3EBD: 90               nop 
  05A16E  3EBE: 2bc0             sub ax, ax
  05A170  3EC0: 8946b8           mov word ptr [bp - 0x48], ax
  05A173  3EC3: 0bc0             or ax, ax
  05A175  3EC5: 7415             je 0x3edc
  05A177  3EC7: ff76d2           push word ptr [bp - 0x2e]
  05A17A  3ECA: ff7606           push word ptr [bp + 6]
  05A17D  3ECD: ff76bc           push word ptr [bp - 0x44]
  05A180  3ED0: ff76fa           push word ptr [bp - 6]
  05A183  3ED3: 0e               push cs
  05A184  3ED4: e87c00           call 0x3f53
  05A187  3ED7: 83c408           add sp, 8
  05A18A  3EDA: eb1c             jmp 0x3ef8
  05A18C  3EDC: f606825301       test byte ptr [0x5382], 1
  05A191  3EE1: 751d             jne 0x3f00
  05A193  3EE3: 6a00             push 0
  05A195  3EE5: ff76d2           push word ptr [bp - 0x2e]
  05A198  3EE8: ff7606           push word ptr [bp + 6]
  05A19B  3EEB: ff76bc           push word ptr [bp - 0x44]
  05A19E  3EEE: ff76fa           push word ptr [bp - 6]
  05A1A1  3EF1: 0e               push cs
  05A1A2  3EF2: e83600           call 0x3f2b
  05A1A5  3EF5: 83c40a           add sp, 0xa
  05A1A8  3EF8: 8b76fe           mov si, word ptr [bp - 2]
  05A1AB  3EFB: d1e6             shl si, 1
  05A1AD  3EFD: 8942e2           mov word ptr [bp + si - 0x1e], ax
  05A1B0  3F00: 8b76fe           mov si, word ptr [bp - 2]
  05A1B3  3F03: d1e6             shl si, 1
  05A1B5  3F05: 837ae200         cmp word ptr [bp + si - 0x1e], 0
  05A1B9  3F09: 7503             jne 0x3f0e
  05A1BB  3F0B: e97bfe           jmp 0x3d89
  05A1BE  3F0E: 6a20             push 0x20
  05A1C0  3F10: ff76fe           push word ptr [bp - 2]
  05A1C3  3F13: ff76b6           push word ptr [bp - 0x4a]
  05A1C6  3F16: 9a060a1f18       lcall 0x181f, 0xa06
  05A1CB  3F1B: 83c406           add sp, 6
  05A1CE  3F1E: e968fe           jmp 0x3d89
  05A1D1  3F21: 90               nop 
  05A1D2  3F22: 5e               pop si
  05A1D3  3F23: c9               leave 
  05A1D4  3F24: cb               retf 
  05A1D5  3F25: 90               nop 
  05A1D6  3F26: ea50051f18       ljmp 0x181f:0x550
  05A1DB  3F2B: eafc051f1a       ljmp 0x1a1f:0x5fc
  05A1E0  3F30: ea0a061f1a       ljmp 0x1a1f:0x60a
  05A1E5  3F35: ea18061f1a       ljmp 0x1a1f:0x618
  05A1EA  3F3A: ea26061f1a       ljmp 0x1a1f:0x626
  05A1EF  3F3F: ea34061f1a       ljmp 0x1a1f:0x634
  05A1F4  3F44: ea42061f1a       ljmp 0x1a1f:0x642
  05A1F9  3F49: ea50061f1a       ljmp 0x1a1f:0x650
  05A1FE  3F4E: ea5e061f1a       ljmp 0x1a1f:0x65e
  05A203  3F53: ea6c061f1a       ljmp 0x1a1f:0x66c
  05A208  3F58: ea7a061f1a       ljmp 0x1a1f:0x67a
  05A20D  3F5D: 00c8             add al, cl
  05A20F  3F5F: 1200             adc al, byte ptr [bx + si]
  05A211  3F61: 0056c7           add byte ptr [bp - 0x39], dl
  05A214  3F64: 46               inc si
  05A215  3F65: f60000           test byte ptr [bx + si], 0
  05A218  3F68: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05A21C  3F6C: 8a874731         mov al, byte ptr [bx + 0x3147]
  05A220  3F70: 250f00           and ax, 0xf
  05A223  3F73: 8946f0           mov word ptr [bp - 0x10], ax
  05A226  3F76: 8b1e4285         mov bx, word ptr [0x8542]
  05A22A  3F7A: 8a4f1a           mov cl, byte ptr [bx + 0x1a]
  05A22D  3F7D: 2aed             sub ch, ch
  05A22F  3F7F: 894efe           mov word ptr [bp - 2], cx
  05A232  3F82: 3d0400           cmp ax, 4
  05A235  3F85: 7d2b             jge 0x3fb2
  05A237  3F87: 6bf034           imul si, ax, 0x34
  05A23A  3F8A: 38ac3f54         cmp byte ptr [si + 0x543f], ch
  05A23E  3F8E: 7522             jne 0x3fb2
  05A240  3F90: 8d4702           lea ax, [bx + 2]
  05A243  3F93: 1e               push ds
  05A244  3F94: 50               push ax
  05A245  3F95: 6a00             push 0
  05A247  3F97: 9a16041f18       lcall 0x181f, 0x416
  05A24C  3F9C: 83c406           add sp, 6
  05A24F  3F9F: 6a03             push 3
  05A251  3FA1: 68641a           push 0x1a64
  05A254  3FA4: 9a52061f18       lcall 0x181f, 0x652
  05A259  3FA9: 83c404           add sp, 4
  05A25C  3FAC: 8946fa           mov word ptr [bp - 6], ax
  05A25F  3FAF: eb06             jmp 0x3fb7
  05A261  3FB1: 90               nop 
  05A262  3FB2: c746fa0300       mov word ptr [bp - 6], 3
  05A267  3FB7: 837efa03         cmp word ptr [bp - 6], 3
  05A26B  3FBB: 7405             je 0x3fc2
  05A26D  3FBD: c746f60100       mov word ptr [bp - 0xa], 1
  05A272  3FC2: 837efa03         cmp word ptr [bp - 6], 3
  05A276  3FC6: 7c03             jl 0x3fcb
  05A278  3FC8: e98c01           jmp 0x4157
  05A27B  3FCB: 837efa01         cmp word ptr [bp - 6], 1
  05A27F  3FCF: 755b             jne 0x402c
  05A281  3FD1: f606825301       test byte ptr [0x5382], 1
  05A286  3FD6: 7414             je 0x3fec
  05A288  3FD8: 6a01             push 1
  05A28A  3FDA: 68701a           push 0x1a70
  05A28D  3FDD: 9a52061f18       lcall 0x181f, 0x652
  05A292  3FE2: 83c404           add sp, 4
  05A295  3FE5: 8b46f6           mov ax, word ptr [bp - 0xa]
  05A298  3FE8: 5e               pop si
  05A299  3FE9: c9               leave 
  05A29A  3FEA: cb               retf 
  05A29B  3FEB: 90               nop 
  05A29C  3FEC: 8b1e4285         mov bx, word ptr [0x8542]
  05A2A0  3FF0: 8a07             mov al, byte ptr [bx]
  05A2A2  3FF2: 2ae4             sub ah, ah
  05A2A4  3FF4: 6b76061c         imul si, word ptr [bp + 6], 0x1c
  05A2A8  3FF8: 8a8c4431         mov cl, byte ptr [si + 0x3144]
  05A2AC  3FFC: 2aed             sub ch, ch
  05A2AE  3FFE: 2bc1             sub ax, cx
  05A2B0  4000: 8a4f01           mov cl, byte ptr [bx + 1]
  05A2B3  4003: 8a944531         mov dl, byte ptr [si + 0x3145]
  05A2B7  4007: 2af6             sub dh, dh
  05A2B9  4009: 2bca             sub cx, dx
  05A2BB  400B: 6a01             push 1
  05A2BD  400D: 8bd1             mov dx, cx
  05A2BF  400F: 9a9c051f1a       lcall 0x1a1f, 0x59c
  05A2C4  4014: 50               push ax
  05A2C5  4015: ff7606           push word ptr [bp + 6]
  05A2C8  4018: ff76fe           push word ptr [bp - 2]
  05A2CB  401B: ff76f0           push word ptr [bp - 0x10]
  05A2CE  401E: 9afc051f1a       lcall 0x1a1f, 0x5fc
  05A2D3  4023: 83c40a           add sp, 0xa
  05A2D6  4026: 8b46f6           mov ax, word ptr [bp - 0xa]
  05A2D9  4029: 5e               pop si
  05A2DA  402A: c9               leave 
  05A2DB  402B: cb               retf 
  05A2DC  402C: 6a00             push 0
  05A2DE  402E: 9ab00a1f18       lcall 0x181f, 0xab0
  05A2E3  4033: 83c402           add sp, 2
  05A2E6  4036: 050600           add ax, 6
  05A2E9  4039: d1e0             shl ax, 1
  05A2EB  403B: 8946fc           mov word ptr [bp - 4], ax
  05A2EE  403E: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05A2F2  4042: 80bf5b3116       cmp byte ptr [bx + 0x315b], 0x16
  05A2F7  4047: 7503             jne 0x404c
  05A2F9  4049: d17efc           sar word ptr [bp - 4], 1
  05A2FC  404C: 833e945304       cmp word ptr [0x5394], 4
  05A301  4051: 7d16             jge 0x4069
  05A303  4053: 6b1e945334       imul bx, word ptr [0x5394], 0x34
  05A308  4058: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05A30D  405D: 750a             jne 0x4069
  05A30F  405F: a0a653           mov al, byte ptr [0x53a6]
  05A312  4062: 2ae4             sub ah, ah
  05A314  4064: 48               dec ax
  05A315  4065: 48               dec ax
  05A316  4066: 0146fc           add word ptr [bp - 4], ax
  05A319  4069: ff36a683         push word ptr [0x83a6]
  05A31D  406D: 9aca041f18       lcall 0x181f, 0x4ca
  05A322  4072: 83c402           add sp, 2
  05A325  4075: 6a24             push 0x24
  05A327  4077: 6a01             push 1
  05A329  4079: 9ad4041f18       lcall 0x181f, 0x4d4
  05A32E  407E: 83c404           add sp, 4
  05A331  4081: 3b46fc           cmp ax, word ptr [bp - 4]
  05A334  4084: 7f06             jg 0x408c
  05A336  4086: b80100           mov ax, 1
  05A339  4089: eb03             jmp 0x408e
  05A33B  408B: 90               nop 
  05A33C  408C: 2bc0             sub ax, ax
  05A33E  408E: 0bc0             or ax, ax
  05A340  4090: 7503             jne 0x4095
  05A342  4092: e9a500           jmp 0x413a
  05A345  4095: a14285           mov ax, word ptr [0x8542]
  05A348  4098: 40               inc ax
  05A349  4099: 40               inc ax
  05A34A  409A: 1e               push ds
  05A34B  409B: 50               push ax
  05A34C  409C: 6a01             push 1
  05A34E  409E: 9a16041f18       lcall 0x181f, 0x416
  05A353  40A3: 83c406           add sp, 6
  05A356  40A6: 6a00             push 0
  05A358  40A8: 6a64             push 0x64
  05A35A  40AA: 6a00             push 0
  05A35C  40AC: 9aae091f18       lcall 0x181f, 0x9ae
  05A361  40B1: 83c406           add sp, 6
  05A364  40B4: 837ef004         cmp word ptr [bp - 0x10], 4
  05A368  40B8: 7d28             jge 0x40e2
  05A36A  40BA: 6b5ef034         imul bx, word ptr [bp - 0x10], 0x34
  05A36E  40BE: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05A373  40C3: 751d             jne 0x40e2
  05A375  40C5: ff76fe           push word ptr [bp - 2]
  05A378  40C8: 9aa4091f18       lcall 0x181f, 0x9a4
  05A37D  40CD: 83c402           add sp, 2
  05A380  40D0: 50               push ax
  05A381  40D1: 6a00             push 0
  05A383  40D3: 9a38041f18       lcall 0x181f, 0x438
  05A388  40D8: 83c404           add sp, 4
  05A38B  40DB: 6a03             push 3
  05A38D  40DD: 68821a           push 0x1a82
  05A390  40E0: eb2c             jmp 0x410e
  05A392  40E2: 837efe04         cmp word ptr [bp - 2], 4
  05A396  40E6: 7d2e             jge 0x4116
  05A398  40E8: 6b5efe34         imul bx, word ptr [bp - 2], 0x34
  05A39C  40EC: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  05A3A1  40F1: 7523             jne 0x4116
  05A3A3  40F3: ff76f0           push word ptr [bp - 0x10]
  05A3A6  40F6: 9aa4091f18       lcall 0x181f, 0x9a4
  05A3AB  40FB: 83c402           add sp, 2
  05A3AE  40FE: 50               push ax
  05A3AF  40FF: 6a00             push 0
  05A3B1  4101: 9a38041f18       lcall 0x181f, 0x438
  05A3B6  4106: 83c404           add sp, 4
  05A3B9  4109: 6a03             push 3
  05A3BB  410B: 68901a           push 0x1a90
  05A3BE  410E: 9a52061f18       lcall 0x181f, 0x652
  05A3C3  4113: 83c404           add sp, 4
  05A3C6  4116: 8b1e4285         mov bx, word ptr [0x8542]
  05A3CA  411A: 8387aa0064       add word ptr [bx + 0xaa], 0x64
  05A3CF  411F: ff7606           push word ptr [bp + 6]
  05A3D2  4122: 9a08081f18       lcall 0x181f, 0x808
  05A3D7  4127: 83c402           add sp, 2
  05A3DA  412A: 6a01             push 1
  05A3DC  412C: 9a1c0e1f18       lcall 0x181f, 0xe1c
  05A3E1  4131: 83c402           add sp, 2
  05A3E4  4134: 8b46f6           mov ax, word ptr [bp - 0xa]
  05A3E7  4137: 5e               pop si
  05A3E8  4138: c9               leave 
  05A3E9  4139: cb               retf 
  05A3EA  413A: c706980b0100     mov word ptr [0xb98], 1
  05A3F0  4140: c606370301       mov byte ptr [0x337], 1
  05A3F5  4145: ff36c68d         push word ptr [0x8dc6]
  05A3F9  4149: 9a08061f18       lcall 0x181f, 0x608
  05A3FE  414E: 83c402           add sp, 2
  05A401  4151: c706980b0000     mov word ptr [0xb98], 0
  05A407  4157: 8b46f6           mov ax, word ptr [bp - 0xa]
  05A40A  415A: 5e               pop si
  05A40B  415B: c9               leave 
  05A40C  415C: cb               retf 

; ---- func_05A40E  size=1107  insns=387  prologue=ENTER 0x0074,0  terminal=RETF ----
  05A40E  415E: c8740000         enter 0x74, 0
  05A412  4162: 56               push si
  05A413  4163: c746980100       mov word ptr [bp - 0x68], 1
  05A418  4168: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05A41C  416C: 8a874731         mov al, byte ptr [bx + 0x3147]
  05A420  4170: 250f00           and ax, 0xf
  05A423  4173: 89468c           mov word ptr [bp - 0x74], ax
  05A426  4176: 8b1e4285         mov bx, word ptr [0x8542]
  05A42A  417A: 8a4f1a           mov cl, byte ptr [bx + 0x1a]
  05A42D  417D: 2aed             sub ch, ch
  05A42F  417F: 894efc           mov word ptr [bp - 4], cx
  05A432  4182: 3d0400           cmp ax, 4
  05A435  4185: 7c03             jl 0x418a
  05A437  4187: e92104           jmp 0x45ab
  05A43A  418A: 6bd834           imul bx, ax, 0x34
  05A43D  418D: 38af3f54         cmp byte ptr [bx + 0x543f], ch
  05A441  4191: 7403             je 0x4196
  05A443  4193: e91504           jmp 0x45ab
  05A446  4196: 51               push cx
  05A447  4197: 50               push ax
  05A448  4198: 9a380a1f18       lcall 0x181f, 0xa38
  05A44D  419D: 83c404           add sp, 4
  05A450  41A0: a840             test al, 0x40
  05A452  41A2: 7510             jne 0x41b4
  05A454  41A4: 8d1ea01a         lea bx, [0x1aa0]
  05A458  41A8: 9afe031f18       lcall 0x181f, 0x3fe
  05A45D  41AD: 8b4698           mov ax, word ptr [bp - 0x68]
  05A460  41B0: 5e               pop si
  05A461  41B1: c9               leave 
  05A462  41B2: cb               retf 
  05A463  41B3: 90               nop 
  05A464  41B4: 6a04             push 4
  05A466  41B6: ff768c           push word ptr [bp - 0x74]
  05A469  41B9: 9ab4071f18       lcall 0x181f, 0x7b4
  05A46E  41BE: 83c404           add sp, 4
  05A471  41C1: 0bc0             or ax, ax
  05A473  41C3: 7523             jne 0x41e8
  05A475  41C5: ff76fc           push word ptr [bp - 4]
  05A478  41C8: 68ab1a           push 0x1aab
  05A47B  41CB: 50               push ax
  05A47C  41CC: 9a18061f1a       lcall 0x1a1f, 0x618
  05A481  41D1: 83c406           add sp, 6
  05A484  41D4: ff76fc           push word ptr [bp - 4]
  05A487  41D7: 68b31a           push 0x1ab3
  05A48A  41DA: 9a88061f1a       lcall 0x1a1f, 0x688
  05A48F  41DF: 83c404           add sp, 4
  05A492  41E2: 8b4698           mov ax, word ptr [bp - 0x68]
  05A495  41E5: 5e               pop si
  05A496  41E6: c9               leave 
  05A497  41E7: cb               retf 
  05A498  41E8: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05A49C  41EC: 80bf503100       cmp byte ptr [bx + 0x3150], 0
  05A4A1  41F1: 7509             jne 0x41fc
  05A4A3  41F3: ff76fc           push word ptr [bp - 4]
  05A4A6  41F6: 68c51a           push 0x1ac5
  05A4A9  41F9: ebdf             jmp 0x41da
  05A4AB  41FB: 90               nop 
  05A4AC  41FC: c7469c0000       mov word ptr [bp - 0x64], 0
  05A4B1  4201: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05A4B5  4205: 80bf503101       cmp byte ptr [bx + 0x3150], 1
  05A4BA  420A: 7703             ja 0x420f
  05A4BC  420C: e9ef00           jmp 0x42fe
  05A4BF  420F: 8d1e7c08         lea bx, [0x87c]
  05A4C3  4213: 8d06d21a         lea ax, [0x1ad2]
  05A4C7  4217: 2bd2             sub dx, dx
  05A4C9  4219: 9a82011f19       lcall 0x191f, 0x182
  05A4CE  421E: 8946a0           mov word ptr [bp - 0x60], ax
  05A4D1  4221: 8956a2           mov word ptr [bp - 0x5e], dx
  05A4D4  4224: 0bd0             or dx, ax
  05A4D6  4226: 7503             jne 0x422b
  05A4D8  4228: e98003           jmp 0x45ab
  05A4DB  422B: c7469a0000       mov word ptr [bp - 0x66], 0
  05A4E0  4230: eb6d             jmp 0x429f
  05A4E2  4232: ff769a           push word ptr [bp - 0x66]
  05A4E5  4235: ff7606           push word ptr [bp + 6]
  05A4E8  4238: 9ae60b1f18       lcall 0x181f, 0xbe6
  05A4ED  423D: 83c404           add sp, 4
  05A4F0  4240: 894694           mov word ptr [bp - 0x6c], ax
  05A4F3  4243: 6a0a             push 0xa
  05A4F5  4245: 8d46aa           lea ax, [bp - 0x56]
  05A4F8  4248: 50               push ax
  05A4F9  4249: ff769a           push word ptr [bp - 0x66]
  05A4FC  424C: ff7606           push word ptr [bp + 6]
  05A4FF  424F: 9a680c1f18       lcall 0x181f, 0xc68
  05A504  4254: 83c404           add sp, 4
  05A507  4257: 89469e           mov word ptr [bp - 0x62], ax
  05A50A  425A: 50               push ax
  05A50B  425B: 9afa081d0d       lcall 0xd1d, 0x8fa
  05A510  4260: 83c406           add sp, 6
  05A513  4263: 8d46aa           lea ax, [bp - 0x56]
  05A516  4266: 50               push ax
  05A517  4267: 9a78011f18       lcall 0x181f, 0x178
  05A51C  426C: 83c402           add sp, 2
  05A51F  426F: 8b5e94           mov bx, word ptr [bp - 0x6c]
  05A522  4272: d1e3             shl bx, 1
  05A524  4274: ffb7c097         push word ptr [bx - 0x6840]
  05A528  4278: 8d46aa           lea ax, [bp - 0x56]
  05A52B  427B: 50               push ax
  05A52C  427C: 9a6e011f18       lcall 0x181f, 0x16e
  05A531  4281: 83c404           add sp, 4
  05A534  4284: 8b469a           mov ax, word ptr [bp - 0x66]
  05A537  4287: 40               inc ax
  05A538  4288: 50               push ax
  05A539  4289: 8d46aa           lea ax, [bp - 0x56]
  05A53C  428C: 16               push ss
  05A53D  428D: 50               push ax
  05A53E  428E: ff76a2           push word ptr [bp - 0x5e]
  05A541  4291: ff76a0           push word ptr [bp - 0x60]
  05A544  4294: 9a76011f19       lcall 0x191f, 0x176
  05A549  4299: 83c40a           add sp, 0xa
  05A54C  429C: ff469a           inc word ptr [bp - 0x66]
  05A54F  429F: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05A553  42A3: 8a875031         mov al, byte ptr [bx + 0x3150]
  05A557  42A7: 2ae4             sub ah, ah
  05A559  42A9: 3b469a           cmp ax, word ptr [bp - 0x66]
  05A55C  42AC: 7f84             jg 0x4232
  05A55E  42AE: 6a63             push 0x63
  05A560  42B0: ff36fa2d         push word ptr [0x2dfa]
  05A564  42B4: 9a22001f18       lcall 0x181f, 0x22
  05A569  42B9: 83c402           add sp, 2
  05A56C  42BC: 52               push dx
  05A56D  42BD: 50               push ax
  05A56E  42BE: ff76a2           push word ptr [bp - 0x5e]
  05A571  42C1: ff76a0           push word ptr [bp - 0x60]
  05A574  42C4: 9a76011f19       lcall 0x191f, 0x176
  05A579  42C9: 83c40a           add sp, 0xa
  05A57C  42CC: ff76a2           push word ptr [bp - 0x5e]
  05A57F  42CF: ff76a0           push word ptr [bp - 0x60]
  05A582  42D2: 9a6a011f19       lcall 0x191f, 0x16a
  05A587  42D7: 8946a6           mov word ptr [bp - 0x5a], ax
  05A58A  42DA: ff76a2           push word ptr [bp - 0x5e]
  05A58D  42DD: ff76a0           push word ptr [bp - 0x60]
  05A590  42E0: 9aa8011f19       lcall 0x191f, 0x1a8
  05A595  42E5: 837ea600         cmp word ptr [bp - 0x5a], 0
  05A599  42E9: 7503             jne 0x42ee
  05A59B  42EB: e9bd02           jmp 0x45ab
  05A59E  42EE: 837ea663         cmp word ptr [bp - 0x5a], 0x63
  05A5A2  42F2: 7503             jne 0x42f7
  05A5A4  42F4: e9b402           jmp 0x45ab
  05A5A7  42F7: 8b46a6           mov ax, word ptr [bp - 0x5a]
  05A5AA  42FA: 48               dec ax
  05A5AB  42FB: 89469c           mov word ptr [bp - 0x64], ax
  05A5AE  42FE: ff769c           push word ptr [bp - 0x64]
  05A5B1  4301: ff7606           push word ptr [bp + 6]
  05A5B4  4304: 9ae60b1f18       lcall 0x181f, 0xbe6
  05A5B9  4309: 83c404           add sp, 4
  05A5BC  430C: 894694           mov word ptr [bp - 0x6c], ax
  05A5BF  430F: ff769c           push word ptr [bp - 0x64]
  05A5C2  4312: ff7606           push word ptr [bp + 6]
  05A5C5  4315: 9a680c1f18       lcall 0x181f, 0xc68
  05A5CA  431A: 83c404           add sp, 4
  05A5CD  431D: 89469e           mov word ptr [bp - 0x62], ax
  05A5D0  4320: 8b76fc           mov si, word ptr [bp - 4]
  05A5D3  4323: c1e604           shl si, 4
  05A5D6  4326: 8b5e94           mov bx, word ptr [bp - 0x6c]
  05A5D9  4329: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  05A5DD  432D: 2ae4             sub ah, ah
  05A5DF  432F: f76e9e           imul word ptr [bp - 0x62]
  05A5E2  4332: 894690           mov word ptr [bp - 0x70], ax
  05A5E5  4335: 695efc3c01       imul bx, word ptr [bp - 4], 0x13c
  05A5EA  433A: 8a870988         mov al, byte ptr [bx - 0x77f7]
  05A5EE  433E: 98               cwde 
  05A5EF  433F: 8bc8             mov cx, ax
  05A5F1  4341: 8b4690           mov ax, word ptr [bp - 0x70]
  05A5F4  4344: f7e9             imul cx
  05A5F6  4346: b96400           mov cx, 0x64
  05A5F9  4349: 99               cdq 
  05A5FA  434A: f7f9             idiv cx
  05A5FC  434C: 894692           mov word ptr [bp - 0x6e], ax
  05A5FF  434F: 2b4690           sub ax, word ptr [bp - 0x70]
  05A602  4352: f7d8             neg ax
  05A604  4354: 8946a8           mov word ptr [bp - 0x58], ax
  05A607  4357: f606825301       test byte ptr [0x5382], 1
  05A60C  435C: 7515             jne 0x4373
  05A60E  435E: ff76fc           push word ptr [bp - 4]
  05A611  4361: ff768c           push word ptr [bp - 0x74]
  05A614  4364: 9a380a1f18       lcall 0x181f, 0xa38
  05A619  4369: 83c404           add sp, 4
  05A61C  436C: a802             test al, 2
  05A61E  436E: 7403             je 0x4373
  05A620  4370: d17ea8           sar word ptr [bp - 0x58], 1
  05A623  4373: f606825301       test byte ptr [0x5382], 1
  05A628  4378: 7408             je 0x4382
  05A62A  437A: a1d453           mov ax, word ptr [0x53d4]
  05A62D  437D: 3946fc           cmp word ptr [bp - 4], ax
  05A630  4380: 7422             je 0x43a4
  05A632  4382: a0a653           mov al, byte ptr [0x53a6]
  05A635  4385: 2ae4             sub ah, ah
  05A637  4387: 40               inc ax
  05A638  4388: 8bc8             mov cx, ax
  05A63A  438A: d1e0             shl ax, 1
  05A63C  438C: 03c1             add ax, cx
  05A63E  438E: c1e002           shl ax, 2
  05A641  4391: 50               push ax
  05A642  4392: 6a0a             push 0xa
  05A644  4394: 9ad4041f18       lcall 0x181f, 0x4d4
  05A649  4399: 83c404           add sp, 4
  05A64C  439C: f76ea8           imul word ptr [bp - 0x58]
  05A64F  439F: b99cff           mov cx, 0xff9c
  05A652  43A2: eb11             jmp 0x43b5
  05A654  43A4: b8fbff           mov ax, 0xfffb
  05A657  43A7: 8a0ea653         mov cl, byte ptr [0x53a6]
  05A65B  43AB: 2aed             sub ch, ch
  05A65D  43AD: 2bc1             sub ax, cx
  05A65F  43AF: f76ea8           imul word ptr [bp - 0x58]
  05A662  43B2: b96400           mov cx, 0x64
  05A665  43B5: 99               cdq 
  05A666  43B6: f7f9             idiv cx
  05A668  43B8: 0146a8           add word ptr [bp - 0x58], ax
  05A66B  43BB: 8b46a8           mov ax, word ptr [bp - 0x58]
  05A66E  43BE: 3d0100           cmp ax, 1
  05A671  43C1: 7d03             jge 0x43c6
  05A673  43C3: b80100           mov ax, 1
  05A676  43C6: 8946a8           mov word ptr [bp - 0x58], ax
  05A679  43C9: b8ffff           mov ax, 0xffff
  05A67C  43CC: 89468e           mov word ptr [bp - 0x72], ax
  05A67F  43CF: 8946fe           mov word ptr [bp - 2], ax
  05A682  43D2: 2bc0             sub ax, ax
  05A684  43D4: 8946fa           mov word ptr [bp - 6], ax
  05A687  43D7: 89469a           mov word ptr [bp - 0x66], ax
  05A68A  43DA: eb0b             jmp 0x43e7
  05A68C  43DC: 8b469a           mov ax, word ptr [bp - 0x66]
  05A68F  43DF: 394694           cmp word ptr [bp - 0x6c], ax
  05A692  43E2: 752e             jne 0x4412
  05A694  43E4: ff469a           inc word ptr [bp - 0x66]
  05A697  43E7: 837e9a10         cmp word ptr [bp - 0x66], 0x10
  05A69B  43EB: 7c03             jl 0x43f0
  05A69D  43ED: e9c400           jmp 0x44b4
  05A6A0  43F0: f606825301       test byte ptr [0x5382], 1
  05A6A5  43F5: 75e5             jne 0x43dc
  05A6A7  43F7: 837e9a0f         cmp word ptr [bp - 0x66], 0xf
  05A6AB  43FB: 74e7             je 0x43e4
  05A6AD  43FD: 837e9a0e         cmp word ptr [bp - 0x66], 0xe
  05A6B1  4401: 74e1             je 0x43e4
  05A6B3  4403: 837e9a00         cmp word ptr [bp - 0x66], 0
  05A6B7  4407: 74db             je 0x43e4
  05A6B9  4409: 837e9a05         cmp word ptr [bp - 0x66], 5
  05A6BD  440D: 75cd             jne 0x43dc
  05A6BF  440F: ebd3             jmp 0x43e4
  05A6C1  4411: 90               nop 
  05A6C2  4412: 8bf0             mov si, ax
  05A6C4  4414: d1e6             shl si, 1
  05A6C6  4416: 8b1e4285         mov bx, word ptr [0x8542]
  05A6CA  441A: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  05A6CE  441E: 3d6400           cmp ax, 0x64
  05A6D1  4421: 7e03             jle 0x4426
  05A6D3  4423: b86400           mov ax, 0x64
  05A6D6  4426: 8946a4           mov word ptr [bp - 0x5c], ax
  05A6D9  4429: f606825301       test byte ptr [0x5382], 1
  05A6DE  442E: 742a             je 0x445a
  05A6E0  4430: 837e940f         cmp word ptr [bp - 0x6c], 0xf
  05A6E4  4434: 7406             je 0x443c
  05A6E6  4436: 837e9408         cmp word ptr [bp - 0x6c], 8
  05A6EA  443A: 751e             jne 0x445a
  05A6EC  443C: a1d453           mov ax, word ptr [0x53d4]
  05A6EF  443F: 3946fc           cmp word ptr [bp - 4], ax
  05A6F2  4442: 7508             jne 0x444c
  05A6F4  4444: c746a46400       mov word ptr [bp - 0x5c], 0x64
  05A6F9  4449: eb0f             jmp 0x445a
  05A6FB  444B: 90               nop 
  05A6FC  444C: 8b46a4           mov ax, word ptr [bp - 0x5c]
  05A6FF  444F: 3d3200           cmp ax, 0x32
  05A702  4452: 7d03             jge 0x4457
  05A704  4454: b83200           mov ax, 0x32
  05A707  4457: 8946a4           mov word ptr [bp - 0x5c], ax
  05A70A  445A: 8b76fc           mov si, word ptr [bp - 4]
  05A70D  445D: c1e604           shl si, 4
  05A710  4460: 8b5e9a           mov bx, word ptr [bp - 0x66]
  05A713  4463: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  05A717  4467: 2ae4             sub ah, ah
  05A719  4469: f76ea4           imul word ptr [bp - 0x5c]
  05A71C  446C: 894696           mov word ptr [bp - 0x6a], ax
  05A71F  446F: eb16             jmp 0x4487
  05A721  4471: 90               nop 
  05A722  4472: ff4ea4           dec word ptr [bp - 0x5c]
  05A725  4475: 8b76fc           mov si, word ptr [bp - 4]
  05A728  4478: c1e604           shl si, 4
  05A72B  447B: 8b5e9a           mov bx, word ptr [bp - 0x66]
  05A72E  447E: 8a80bc84         mov al, byte ptr [bx + si - 0x7b44]
  05A732  4482: 2ae4             sub ah, ah
  05A734  4484: 294696           sub word ptr [bp - 0x6a], ax
  05A737  4487: 8b4690           mov ax, word ptr [bp - 0x70]
  05A73A  448A: 394696           cmp word ptr [bp - 0x6a], ax
  05A73D  448D: 7fe3             jg 0x4472
  05A73F  448F: 837ea400         cmp word ptr [bp - 0x5c], 0
  05A743  4493: 7f03             jg 0x4498
  05A745  4495: e94cff           jmp 0x43e4
  05A748  4498: 8b4696           mov ax, word ptr [bp - 0x6a]
  05A74B  449B: 39468e           cmp word ptr [bp - 0x72], ax
  05A74E  449E: 7c03             jl 0x44a3
  05A750  44A0: e941ff           jmp 0x43e4
  05A753  44A3: 89468e           mov word ptr [bp - 0x72], ax
  05A756  44A6: 8b46a4           mov ax, word ptr [bp - 0x5c]
  05A759  44A9: 8946fa           mov word ptr [bp - 6], ax
  05A75C  44AC: 8bc3             mov ax, bx
  05A75E  44AE: 8946fe           mov word ptr [bp - 2], ax
  05A761  44B1: e930ff           jmp 0x43e4
  05A764  44B4: 837e8e00         cmp word ptr [bp - 0x72], 0
  05A768  44B8: 7d2c             jge 0x44e6
  05A76A  44BA: 8b5e94           mov bx, word ptr [bp - 0x6c]
  05A76D  44BD: d1e3             shl bx, 1
  05A76F  44BF: ffb7c097         push word ptr [bx - 0x6840]
  05A773  44C3: 6a00             push 0
  05A775  44C5: 9a38041f18       lcall 0x181f, 0x438
  05A77A  44CA: 83c404           add sp, 4
  05A77D  44CD: 8b469e           mov ax, word ptr [bp - 0x62]
  05A780  44D0: 99               cdq 
  05A781  44D1: 52               push dx
  05A782  44D2: 50               push ax
  05A783  44D3: 6a00             push 0
  05A785  44D5: 9aae091f18       lcall 0x181f, 0x9ae
  05A78A  44DA: 83c406           add sp, 6
  05A78D  44DD: ff76fc           push word ptr [bp - 4]
  05A790  44E0: 68dd1a           push 0x1add
  05A793  44E3: e9f4fc           jmp 0x41da
  05A796  44E6: 8b5e94           mov bx, word ptr [bp - 0x6c]
  05A799  44E9: d1e3             shl bx, 1
  05A79B  44EB: ffb7c097         push word ptr [bx - 0x6840]
  05A79F  44EF: 6a01             push 1
  05A7A1  44F1: 9a38041f18       lcall 0x181f, 0x438
  05A7A6  44F6: 83c404           add sp, 4
  05A7A9  44F9: 8b469e           mov ax, word ptr [bp - 0x62]
  05A7AC  44FC: 99               cdq 
  05A7AD  44FD: 52               push dx
  05A7AE  44FE: 50               push ax
  05A7AF  44FF: 6a01             push 1
  05A7B1  4501: 9aae091f18       lcall 0x181f, 0x9ae
  05A7B6  4506: 83c406           add sp, 6
  05A7B9  4509: 8b5efe           mov bx, word ptr [bp - 2]
  05A7BC  450C: d1e3             shl bx, 1
  05A7BE  450E: ffb7c097         push word ptr [bx - 0x6840]
  05A7C2  4512: 6a00             push 0
  05A7C4  4514: 9a38041f18       lcall 0x181f, 0x438
  05A7C9  4519: 83c404           add sp, 4
  05A7CC  451C: 8b46fa           mov ax, word ptr [bp - 6]
  05A7CF  451F: 99               cdq 
  05A7D0  4520: 52               push dx
  05A7D1  4521: 50               push ax
  05A7D2  4522: 6a00             push 0
  05A7D4  4524: 9aae091f18       lcall 0x181f, 0x9ae
  05A7D9  4529: 83c406           add sp, 6
  05A7DC  452C: 8b46a8           mov ax, word ptr [bp - 0x58]
  05A7DF  452F: 99               cdq 
  05A7E0  4530: 52               push dx
  05A7E1  4531: 50               push ax
  05A7E2  4532: 6a02             push 2
  05A7E4  4534: 9aae091f18       lcall 0x181f, 0x9ae
  05A7E9  4539: 83c406           add sp, 6
  05A7EC  453C: ff76fc           push word ptr [bp - 4]
  05A7EF  453F: 68e91a           push 0x1ae9
  05A7F2  4542: 9a88061f1a       lcall 0x1a1f, 0x688
  05A7F7  4547: 83c404           add sp, 4
  05A7FA  454A: 8946a6           mov word ptr [bp - 0x5a], ax
  05A7FD  454D: 3d0200           cmp ax, 2
  05A800  4550: 7f59             jg 0x45ab
  05A802  4552: 3d0100           cmp ax, 1
  05A805  4555: 7525             jne 0x457c
  05A807  4557: ff76fe           push word ptr [bp - 2]
  05A80A  455A: ff769c           push word ptr [bp - 0x64]
  05A80D  455D: ff7606           push word ptr [bp + 6]
  05A810  4560: 9aea0c1f18       lcall 0x181f, 0xcea
  05A815  4565: 83c406           add sp, 6
  05A818  4568: ff76fa           push word ptr [bp - 6]
  05A81B  456B: ff769c           push word ptr [bp - 0x64]
  05A81E  456E: ff7606           push word ptr [bp + 6]
  05A821  4571: 9aa40c1f18       lcall 0x181f, 0xca4
  05A826  4576: 83c406           add sp, 6
  05A829  4579: eb20             jmp 0x459b
  05A82B  457B: 90               nop 
  05A82C  457C: ff769c           push word ptr [bp - 0x64]
  05A82F  457F: ff7606           push word ptr [bp + 6]
  05A832  4582: 9aec0a1f18       lcall 0x181f, 0xaec
  05A837  4587: 83c404           add sp, 4
  05A83A  458A: 8b46a8           mov ax, word ptr [bp - 0x58]
  05A83D  458D: 99               cdq 
  05A83E  458E: 695e8c3c01       imul bx, word ptr [bp - 0x74], 0x13c
  05A843  4593: 01873288         add word ptr [bx - 0x77ce], ax
  05A847  4597: 11973488         adc word ptr [bx - 0x77cc], dx
  05A84B  459B: 8b469e           mov ax, word ptr [bp - 0x62]
  05A84E  459E: 8b7694           mov si, word ptr [bp - 0x6c]
  05A851  45A1: d1e6             shl si, 1
  05A853  45A3: 8b1e4285         mov bx, word ptr [0x8542]
  05A857  45A7: 01809a00         add word ptr [bx + si + 0x9a], ax
  05A85B  45AB: 8b4698           mov ax, word ptr [bp - 0x68]
  05A85E  45AE: 5e               pop si
  05A85F  45AF: c9               leave 
  05A860  45B0: cb               retf 

; ---- func_05A862  size=224  insns=75  prologue=ENTER 0x0004,0  terminal=page-end ----
  05A862  45B2: c8040000         enter 4, 0
  05A866  45B6: c746fc0000       mov word ptr [bp - 4], 0
  05A86B  45BB: a19c53           mov ax, word ptr [0x539c]
  05A86E  45BE: 8946fe           mov word ptr [bp - 2], ax
  05A871  45C1: ff7608           push word ptr [bp + 8]
  05A874  45C4: 9ae6091f18       lcall 0x181f, 0x9e6
  05A879  45C9: 83c402           add sp, 2
  05A87C  45CC: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05A880  45D0: 80bf463105       cmp byte ptr [bx + 0x3146], 5
  05A885  45D5: 751b             jne 0x45f2
  05A887  45D7: ff7606           push word ptr [bp + 6]
  05A88A  45DA: 0e               push cs
  05A88B  45DB: e8af00           call 0x468d
  05A88E  45DE: 83c402           add sp, 2
  05A891  45E1: 8946fc           mov word ptr [bp - 4], ax
  05A894  45E4: a19c53           mov ax, word ptr [0x539c]
  05A897  45E7: 3946fe           cmp word ptr [bp - 2], ax
  05A89A  45EA: 742c             je 0x4618
  05A89C  45EC: 8b46fc           mov ax, word ptr [bp - 4]
  05A89F  45EF: c9               leave 
  05A8A0  45F0: cb               retf 
  05A8A1  45F1: 90               nop 
  05A8A2  45F2: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05A8A6  45F6: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  05A8AA  45FA: 2aff             sub bh, bh
  05A8AC  45FC: 8bc3             mov ax, bx
  05A8AE  45FE: d1e3             shl bx, 1
  05A8B0  4600: 03d8             add bx, ax
  05A8B2  4602: d1e3             shl bx, 1
  05A8B4  4604: 03d8             add bx, ax
  05A8B6  4606: d1e3             shl bx, 1
  05A8B8  4608: 80bf375200       cmp byte ptr [bx + 0x5237], 0
  05A8BD  460D: 74d5             je 0x45e4
  05A8BF  460F: ff7606           push word ptr [bp + 6]
  05A8C2  4612: 0e               push cs
  05A8C3  4613: e87200           call 0x4688
  05A8C6  4616: ebc6             jmp 0x45de
  05A8C8  4618: f606825301       test byte ptr [0x5382], 1
  05A8CD  461D: 7451             je 0x4670
  05A8CF  461F: 837efc00         cmp word ptr [bp - 4], 0
  05A8D3  4623: 754b             jne 0x4670
  05A8D5  4625: 8b1e4285         mov bx, word ptr [0x8542]
  05A8D9  4629: 807f1a04         cmp byte ptr [bx + 0x1a], 4
  05A8DD  462D: 730e             jae 0x463d
  05A8DF  462F: 8a471a           mov al, byte ptr [bx + 0x1a]
  05A8E2  4632: 2ae4             sub ah, ah
  05A8E4  4634: 6bd834           imul bx, ax, 0x34
  05A8E7  4637: 38a73f54         cmp byte ptr [bx + 0x543f], ah
  05A8EB  463B: 7433             je 0x4670
  05A8ED  463D: a0d253           mov al, byte ptr [0x53d2]
  05A8F0  4640: 8b1e4285         mov bx, word ptr [0x8542]
  05A8F4  4644: 38471a           cmp byte ptr [bx + 0x1a], al
  05A8F7  4647: 7427             je 0x4670
  05A8F9  4649: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  05A8FD  464D: 8a874731         mov al, byte ptr [bx + 0x3147]
  05A901  4651: 240f             and al, 0xf
  05A903  4653: 3c04             cmp al, 4
  05A905  4655: 7319             jae 0x4670
  05A907  4657: 2ae4             sub ah, ah
  05A909  4659: 6bd834           imul bx, ax, 0x34
  05A90C  465C: 38a73f54         cmp byte ptr [bx + 0x543f], ah
  05A910  4660: 750e             jne 0x4670
  05A912  4662: 8d1ef31a         lea bx, [0x1af3]
  05A916  4666: 9afe031f18       lcall 0x181f, 0x3fe
  05A91B  466B: c746fc0100       mov word ptr [bp - 4], 1
  05A920  4670: 837efc00         cmp word ptr [bp - 4], 0
  05A924  4674: 7503             jne 0x4679
  05A926  4676: e973ff           jmp 0x45ec
  05A929  4679: ff7606           push word ptr [bp + 6]
  05A92C  467C: 9a34091f18       lcall 0x181f, 0x934
  05A931  4681: 83c402           add sp, 2
  05A934  4684: e965ff           jmp 0x45ec
  05A937  4687: 90               nop 
  05A938  4688: ea94061f1a       ljmp 0x1a1f:0x694
  05A93D  468D: eaa2061f1a       ljmp 0x1a1f:0x6a2
