; ============================================================
; VICEROY.EXE overlay page 0x02 (record 1) -- RE-SEGMENTED
; file_offset (disk image) = 0x024BF0
; code_offset (first insn) = 0x025900
; code_end (next reloc hdr)= 0x02CB00  [resident size 1824 para -> nominal_end 0x02BDF0; on-disk code spills past it]
; reloc_count = 826  flags = 0x0000
; display IP base = page-image-relative (IP = file - 0x024BF0)
; functions in page = 67
; ============================================================

; ---- func_025900  size=285  insns=106  prologue=ENTER 0x0016,0  terminal=RETF ----
  025900  0D10: c8160000         enter 0x16, 0
  025904  0D14: 56               push si
  025905  0D15: 8b1e4285         mov bx, word ptr [0x8542]
  025909  0D19: 8a07             mov al, byte ptr [bx]
  02590B  0D1B: 2ae4             sub ah, ah
  02590D  0D1D: 8a5701           mov dl, byte ptr [bx + 1]
  025910  0D20: 2af6             sub dh, dh
  025912  0D22: 9ae0071f18       lcall 0x181f, 0x7e0
  025917  0D27: 8946f0           mov word ptr [bp - 0x10], ax
  02591A  0D2A: 0bc0             or ax, ax
  02591C  0D2C: 7c10             jl 0xd3e
  02591E  0D2E: 6a0a             push 0xa
  025920  0D30: 50               push ax
  025921  0D31: 9abc081f18       lcall 0x181f, 0x8bc
  025926  0D36: 83c404           add sp, 4
  025929  0D39: 8946fc           mov word ptr [bp - 4], ax
  02592C  0D3C: eb05             jmp 0xd43
  02592E  0D3E: c746fc0000       mov word ptr [bp - 4], 0
  025933  0D43: c746f4ffff       mov word ptr [bp - 0xc], 0xffff
  025938  0D48: 2bc0             sub ax, ax
  02593A  0D4A: 8946ec           mov word ptr [bp - 0x14], ax
  02593D  0D4D: 8946ea           mov word ptr [bp - 0x16], ax
  025940  0D50: 8946fa           mov word ptr [bp - 6], ax
  025943  0D53: eb19             jmp 0xd6e
  025945  0D55: 90               nop 
  025946  0D56: ff76ee           push word ptr [bp - 0x12]
  025949  0D59: 8a471a           mov al, byte ptr [bx + 0x1a]
  02594C  0D5C: 2ae4             sub ah, ah
  02594E  0D5E: 50               push ax
  02594F  0D5F: 9a380a1f18       lcall 0x181f, 0xa38
  025954  0D64: 83c404           add sp, 4
  025957  0D67: a840             test al, 0x40
  025959  0D69: 746d             je 0xdd8
  02595B  0D6B: ff46fa           inc word ptr [bp - 6]
  02595E  0D6E: 837efa08         cmp word ptr [bp - 6], 8
  025962  0D72: 7d7c             jge 0xdf0
  025964  0D74: 8b5efa           mov bx, word ptr [bp - 6]
  025967  0D77: 8a87be00         mov al, byte ptr [bx + 0xbe]
  02596B  0D7B: 98               cwde 
  02596C  0D7C: 8b364285         mov si, word ptr [0x8542]
  025970  0D80: 8a4c01           mov cl, byte ptr [si + 1]
  025973  0D83: 2aed             sub ch, ch
  025975  0D85: 03c1             add ax, cx
  025977  0D87: 8bd0             mov dx, ax
  025979  0D89: 8a87b400         mov al, byte ptr [bx + 0xb4]
  02597D  0D8D: 98               cwde 
  02597E  0D8E: 8a0c             mov cl, byte ptr [si]
  025980  0D90: 03c1             add ax, cx
  025982  0D92: 9ae0071f18       lcall 0x181f, 0x7e0
  025987  0D97: 8946f0           mov word ptr [bp - 0x10], ax
  02598A  0D9A: 0bc0             or ax, ax
  02598C  0D9C: 7ccd             jl 0xd6b
  02598E  0D9E: 6bd81c           imul bx, ax, 0x1c
  025991  0DA1: 8a874731         mov al, byte ptr [bx + 0x3147]
  025995  0DA5: 250f00           and ax, 0xf
  025998  0DA8: 8946ee           mov word ptr [bp - 0x12], ax
  02599B  0DAB: 3d0400           cmp ax, 4
  02599E  0DAE: 7dbb             jge 0xd6b
  0259A0  0DB0: 6a0a             push 0xa
  0259A2  0DB2: ff76f0           push word ptr [bp - 0x10]
  0259A5  0DB5: 9abc081f18       lcall 0x181f, 0x8bc
  0259AA  0DBA: 83c404           add sp, 4
  0259AD  0DBD: 8946fe           mov word ptr [bp - 2], ax
  0259B0  0DC0: 8b1e4285         mov bx, word ptr [0x8542]
  0259B4  0DC4: 8a471a           mov al, byte ptr [bx + 0x1a]
  0259B7  0DC7: 2ae4             sub ah, ah
  0259B9  0DC9: 3b46ee           cmp ax, word ptr [bp - 0x12]
  0259BC  0DCC: 7588             jne 0xd56
  0259BE  0DCE: 8b46fe           mov ax, word ptr [bp - 2]
  0259C1  0DD1: 0146fc           add word ptr [bp - 4], ax
  0259C4  0DD4: eb95             jmp 0xd6b
  0259C6  0DD6: 90               nop 
  0259C7  0DD7: 90               nop 
  0259C8  0DD8: 8b46fe           mov ax, word ptr [bp - 2]
  0259CB  0DDB: 0146ec           add word ptr [bp - 0x14], ax
  0259CE  0DDE: 3946ea           cmp word ptr [bp - 0x16], ax
  0259D1  0DE1: 7f88             jg 0xd6b
  0259D3  0DE3: 8946ea           mov word ptr [bp - 0x16], ax
  0259D6  0DE6: 8b46ee           mov ax, word ptr [bp - 0x12]
  0259D9  0DE9: 8946f4           mov word ptr [bp - 0xc], ax
  0259DC  0DEC: e97cff           jmp 0xd6b
  0259DF  0DEF: 90               nop 
  0259E0  0DF0: 8b46ec           mov ax, word ptr [bp - 0x14]
  0259E3  0DF3: 2b46fc           sub ax, word ptr [bp - 4]
  0259E6  0DF6: 7902             jns 0xdfa
  0259E8  0DF8: 2bc0             sub ax, ax
  0259EA  0DFA: 8946f2           mov word ptr [bp - 0xe], ax
  0259ED  0DFD: 837e0600         cmp word ptr [bp + 6], 0
  0259F1  0E01: 7408             je 0xe0b
  0259F3  0E03: 8b46f4           mov ax, word ptr [bp - 0xc]
  0259F6  0E06: 8b5e06           mov bx, word ptr [bp + 6]
  0259F9  0E09: 8907             mov word ptr [bx], ax
  0259FB  0E0B: 837e0800         cmp word ptr [bp + 8], 0
  0259FF  0E0F: 7408             je 0xe19
  025A01  0E11: 8b46fc           mov ax, word ptr [bp - 4]
  025A04  0E14: 8b5e08           mov bx, word ptr [bp + 8]
  025A07  0E17: 8907             mov word ptr [bx], ax
  025A09  0E19: 837e0a00         cmp word ptr [bp + 0xa], 0
  025A0D  0E1D: 7408             je 0xe27
  025A0F  0E1F: 8b46ec           mov ax, word ptr [bp - 0x14]
  025A12  0E22: 8b5e0a           mov bx, word ptr [bp + 0xa]
  025A15  0E25: 8907             mov word ptr [bx], ax
  025A17  0E27: 8b46f2           mov ax, word ptr [bp - 0xe]
  025A1A  0E2A: 5e               pop si
  025A1B  0E2B: c9               leave 
  025A1C  0E2C: cb               retf 

; ---- func_025A1E  size=531  insns=188  prologue=ENTER 0x0040,0  terminal=RETF ----
  025A1E  0E2E: c8400000         enter 0x40, 0
  025A22  0E32: 56               push si
  025A23  0E33: c746f80000       mov word ptr [bp - 8], 0
  025A28  0E38: ff7606           push word ptr [bp + 6]
  025A2B  0E3B: 9a0e0c1f18       lcall 0x181f, 0xc0e
  025A30  0E40: 83c402           add sp, 2
  025A33  0E43: 8946f2           mov word ptr [bp - 0xe], ax
  025A36  0E46: ff7606           push word ptr [bp + 6]
  025A39  0E49: 9a540c1f18       lcall 0x181f, 0xc54
  025A3E  0E4E: 83c402           add sp, 2
  025A41  0E51: 8946fc           mov word ptr [bp - 4], ax
  025A44  0E54: 8b4608           mov ax, word ptr [bp + 8]
  025A47  0E57: 3946f2           cmp word ptr [bp - 0xe], ax
  025A4A  0E5A: 7503             jne 0xe5f
  025A4C  0E5C: e9dc01           jmp 0x103b
  025A4F  0E5F: 50               push ax
  025A50  0E60: ff7606           push word ptr [bp + 6]
  025A53  0E63: 9a0a0b1f18       lcall 0x181f, 0xb0a
  025A58  0E68: 83c404           add sp, 4
  025A5B  0E6B: 8946fa           mov word ptr [bp - 6], ax
  025A5E  0E6E: 3d0200           cmp ax, 2
  025A61  0E71: 7561             jne 0xed4
  025A63  0E73: 6a00             push 0
  025A65  0E75: 9afc091f18       lcall 0x181f, 0x9fc
  025A6A  0E7A: 83c402           add sp, 2
  025A6D  0E7D: 0bc0             or ax, ax
  025A6F  0E7F: 7415             je 0xe96
  025A71  0E81: 8b1e4285         mov bx, word ptr [0x8542]
  025A75  0E85: 807f1f03         cmp byte ptr [bx + 0x1f], 3
  025A79  0E89: 7f0b             jg 0xe96
  025A7B  0E8B: c746f81500       mov word ptr [bp - 8], 0x15
  025A80  0E90: 8b46f8           mov ax, word ptr [bp - 8]
  025A83  0E93: 5e               pop si
  025A84  0E94: c9               leave 
  025A85  0E95: cb               retf 
  025A86  0E96: 837e0815         cmp word ptr [bp + 8], 0x15
  025A8A  0E9A: 7422             je 0xebe
  025A8C  0E9C: 837e0817         cmp word ptr [bp + 8], 0x17
  025A90  0EA0: 741c             je 0xebe
  025A92  0EA2: 6a00             push 0
  025A94  0EA4: 6a00             push 0
  025A96  0EA6: 6a00             push 0
  025A98  0EA8: 0e               push cs
  025A99  0EA9: e84f70           call 0x7efb
  025A9C  0EAC: 83c406           add sp, 6
  025A9F  0EAF: 0bc0             or ax, ax
  025AA1  0EB1: 740b             je 0xebe
  025AA3  0EB3: c746f81400       mov word ptr [bp - 8], 0x14
  025AA8  0EB8: 8b46f8           mov ax, word ptr [bp - 8]
  025AAB  0EBB: 5e               pop si
  025AAC  0EBC: c9               leave 
  025AAD  0EBD: cb               retf 
  025AAE  0EBE: 8b1e4285         mov bx, word ptr [0x8542]
  025AB2  0EC2: 807f1f01         cmp byte ptr [bx + 0x1f], 1
  025AB6  0EC6: 750c             jne 0xed4
  025AB8  0EC8: c746f80300       mov word ptr [bp - 8], 3
  025ABD  0ECD: 8b46f8           mov ax, word ptr [bp - 8]
  025AC0  0ED0: 5e               pop si
  025AC1  0ED1: c9               leave 
  025AC2  0ED2: cb               retf 
  025AC3  0ED3: 90               nop 
  025AC4  0ED4: 837efa03         cmp word ptr [bp - 6], 3
  025AC8  0ED8: 7516             jne 0xef0
  025ACA  0EDA: 8b1e4285         mov bx, word ptr [0x8542]
  025ACE  0EDE: 807f1f20         cmp byte ptr [bx + 0x1f], 0x20
  025AD2  0EE2: 7c0c             jl 0xef0
  025AD4  0EE4: c746f80400       mov word ptr [bp - 8], 4
  025AD9  0EE9: 8b46f8           mov ax, word ptr [bp - 8]
  025ADC  0EEC: 5e               pop si
  025ADD  0EED: c9               leave 
  025ADE  0EEE: cb               retf 
  025ADF  0EEF: 90               nop 
  025AE0  0EF0: 837e0808         cmp word ptr [bp + 8], 8
  025AE4  0EF4: 751a             jne 0xf10
  025AE6  0EF6: 6a06             push 6
  025AE8  0EF8: 9afc091f18       lcall 0x181f, 0x9fc
  025AED  0EFD: 83c402           add sp, 2
  025AF0  0F00: 0bc0             or ax, ax
  025AF2  0F02: 750c             jne 0xf10
  025AF4  0F04: c746f80d00       mov word ptr [bp - 8], 0xd
  025AF9  0F09: 8b46f8           mov ax, word ptr [bp - 8]
  025AFC  0F0C: 5e               pop si
  025AFD  0F0D: c9               leave 
  025AFE  0F0E: cb               retf 
  025AFF  0F0F: 90               nop 
  025B00  0F10: 837e0812         cmp word ptr [bp + 8], 0x12
  025B04  0F14: 7403             je 0xf19
  025B06  0F16: e9c700           jmp 0xfe0
  025B09  0F19: 6a12             push 0x12
  025B0B  0F1B: 9a820b1f18       lcall 0x181f, 0xb82
  025B10  0F20: 83c402           add sp, 2
  025B13  0F23: 8946f6           mov word ptr [bp - 0xa], ax
  025B16  0F26: 6a0e             push 0xe
  025B18  0F28: 9afc091f18       lcall 0x181f, 0x9fc
  025B1D  0F2D: 83c402           add sp, 2
  025B20  0F30: 0bc0             or ax, ax
  025B22  0F32: 740e             je 0xf42
  025B24  0F34: 837ef603         cmp word ptr [bp - 0xa], 3
  025B28  0F38: 7c40             jl 0xf7a
  025B2A  0F3A: c746f80700       mov word ptr [bp - 8], 7
  025B2F  0F3F: e9f900           jmp 0x103b
  025B32  0F42: 6a0d             push 0xd
  025B34  0F44: 9afc091f18       lcall 0x181f, 0x9fc
  025B39  0F49: 83c402           add sp, 2
  025B3C  0F4C: 0bc0             or ax, ax
  025B3E  0F4E: 740e             je 0xf5e
  025B40  0F50: 837ef602         cmp word ptr [bp - 0xa], 2
  025B44  0F54: 7c24             jl 0xf7a
  025B46  0F56: c746f80800       mov word ptr [bp - 8], 8
  025B4B  0F5B: e9dd00           jmp 0x103b
  025B4E  0F5E: 6a0c             push 0xc
  025B50  0F60: 9afc091f18       lcall 0x181f, 0x9fc
  025B55  0F65: 83c402           add sp, 2
  025B58  0F68: 0bc0             or ax, ax
  025B5A  0F6A: 740e             je 0xf7a
  025B5C  0F6C: 837ef601         cmp word ptr [bp - 0xa], 1
  025B60  0F70: 7c08             jl 0xf7a
  025B62  0F72: c746f80900       mov word ptr [bp - 8], 9
  025B67  0F77: e9c100           jmp 0x103b
  025B6A  0F7A: 837efc1c         cmp word ptr [bp - 4], 0x1c
  025B6E  0F7E: 7505             jne 0xf85
  025B70  0F80: c746fc1900       mov word ptr [bp - 4], 0x19
  025B75  0F85: 8b5efc           mov bx, word ptr [bp - 4]
  025B78  0F88: c1e303           shl bx, 3
  025B7B  0F8B: 83bfa68e03       cmp word ptr [bx - 0x715a], 3
  025B80  0F90: 7e08             jle 0xf9a
  025B82  0F92: c746f81000       mov word ptr [bp - 8], 0x10
  025B87  0F97: e9a100           jmp 0x103b
  025B8A  0F9A: 8b5efc           mov bx, word ptr [bp - 4]
  025B8D  0F9D: c1e303           shl bx, 3
  025B90  0FA0: 83bfa68e03       cmp word ptr [bx - 0x715a], 3
  025B95  0FA5: 7517             jne 0xfbe
  025B97  0FA7: 6a0e             push 0xe
  025B99  0FA9: 9afc091f18       lcall 0x181f, 0x9fc
  025B9E  0FAE: 83c402           add sp, 2
  025BA1  0FB1: 0bc0             or ax, ax
  025BA3  0FB3: 7509             jne 0xfbe
  025BA5  0FB5: c746f81200       mov word ptr [bp - 8], 0x12
  025BAA  0FBA: eb7f             jmp 0x103b
  025BAC  0FBC: 90               nop 
  025BAD  0FBD: 90               nop 
  025BAE  0FBE: 8b5efc           mov bx, word ptr [bp - 4]
  025BB1  0FC1: c1e303           shl bx, 3
  025BB4  0FC4: 83bfa68e02       cmp word ptr [bx - 0x715a], 2
  025BB9  0FC9: 7515             jne 0xfe0
  025BBB  0FCB: 6a0d             push 0xd
  025BBD  0FCD: 9afc091f18       lcall 0x181f, 0x9fc
  025BC2  0FD2: 83c402           add sp, 2
  025BC5  0FD5: 0bc0             or ax, ax
  025BC7  0FD7: 7507             jne 0xfe0
  025BC9  0FD9: c746f81100       mov word ptr [bp - 8], 0x11
  025BCE  0FDE: eb5b             jmp 0x103b
  025BD0  0FE0: 6a32             push 0x32
  025BD2  0FE2: 6a00             push 0
  025BD4  0FE4: 8d46c0           lea ax, [bp - 0x40]
  025BD7  0FE7: 50               push ax
  025BD8  0FE8: 9aae0d1d0d       lcall 0xd1d, 0xdae
  025BDD  0FED: 83c406           add sp, 6
  025BE0  0FF0: c746f40000       mov word ptr [bp - 0xc], 0
  025BE5  0FF5: eb21             jmp 0x1018
  025BE7  0FF7: 90               nop 
  025BE8  0FF8: 8b4606           mov ax, word ptr [bp + 6]
  025BEB  0FFB: 3946f4           cmp word ptr [bp - 0xc], ax
  025BEE  0FFE: 7415             je 0x1015
  025BF0  1000: ff76f4           push word ptr [bp - 0xc]
  025BF3  1003: 9a0e0c1f18       lcall 0x181f, 0xc0e
  025BF8  1008: 83c402           add sp, 2
  025BFB  100B: 8bf0             mov si, ax
  025BFD  100D: 8976fe           mov word ptr [bp - 2], si
  025C00  1010: d1e6             shl si, 1
  025C02  1012: ff42c0           inc word ptr [bp + si - 0x40]
  025C05  1015: ff46f4           inc word ptr [bp - 0xc]
  025C08  1018: 8b1e4285         mov bx, word ptr [0x8542]
  025C0C  101C: 8a471f           mov al, byte ptr [bx + 0x1f]
  025C0F  101F: 98               cwde 
  025C10  1020: 3b46f4           cmp ax, word ptr [bp - 0xc]
  025C13  1023: 7fd3             jg 0xff8
  025C15  1025: 8b7608           mov si, word ptr [bp + 8]
  025C18  1028: d1e6             shl si, 1
  025C1A  102A: 837ac003         cmp word ptr [bp + si - 0x40], 3
  025C1E  102E: 7c0b             jl 0x103b
  025C20  1030: 837e0809         cmp word ptr [bp + 8], 9
  025C24  1034: 7e05             jle 0x103b
  025C26  1036: c746f81600       mov word ptr [bp - 8], 0x16
  025C2B  103B: 8b46f8           mov ax, word ptr [bp - 8]
  025C2E  103E: 5e               pop si
  025C2F  103F: c9               leave 
  025C30  1040: cb               retf 

; ---- func_025C32  size=258  insns=94  prologue=ENTER 0x00A4,0  terminal=RETF ----
  025C32  1042: c8a40000         enter 0xa4, 0
  025C36  1046: 57               push di
  025C37  1047: 56               push si
  025C38  1048: 8b1e4285         mov bx, word ptr [0x8542]
  025C3C  104C: 807f1f02         cmp byte ptr [bx + 0x1f], 2
  025C40  1050: 7d03             jge 0x1055
  025C42  1052: e9eb00           jmp 0x1140
  025C45  1055: c746bc0000       mov word ptr [bp - 0x44], 0
  025C4A  105A: eb2a             jmp 0x1086
  025C4C  105C: 8a46bc           mov al, byte ptr [bp - 0x44]
  025C4F  105F: 8b76bc           mov si, word ptr [bp - 0x44]
  025C52  1062: 88825cff         mov byte ptr [bp + si - 0xa4], al
  025C56  1066: 8a4040           mov al, byte ptr [bx + si + 0x40]
  025C59  1069: 88827cff         mov byte ptr [bp + si - 0x84], al
  025C5D  106D: 56               push si
  025C5E  106E: 9a1c0d1f18       lcall 0x181f, 0xd1c
  025C63  1073: 83c402           add sp, 2
  025C66  1076: 8842de           mov byte ptr [bp + si - 0x22], al
  025C69  1079: 8b1e4285         mov bx, word ptr [0x8542]
  025C6D  107D: 8a4020           mov al, byte ptr [bx + si + 0x20]
  025C70  1080: 88429c           mov byte ptr [bp + si - 0x64], al
  025C73  1083: ff46bc           inc word ptr [bp - 0x44]
  025C76  1086: 8a471f           mov al, byte ptr [bx + 0x1f]
  025C79  1089: 98               cwde 
  025C7A  108A: 3b46bc           cmp ax, word ptr [bp - 0x44]
  025C7D  108D: 7fcd             jg 0x105c
  025C7F  108F: 8d865cff         lea ax, [bp - 0xa4]
  025C83  1093: 16               push ss
  025C84  1094: 50               push ax
  025C85  1095: 8d469c           lea ax, [bp - 0x64]
  025C88  1098: 16               push ss
  025C89  1099: 50               push ax
  025C8A  109A: 8b1e4285         mov bx, word ptr [0x8542]
  025C8E  109E: 8a471f           mov al, byte ptr [bx + 0x1f]
  025C91  10A1: 98               cwde 
  025C92  10A2: 9a70081f19       lcall 0x191f, 0x870
  025C97  10A7: c746bc0000       mov word ptr [bp - 0x44], 0
  025C9C  10AC: eb14             jmp 0x10c2
  025C9E  10AE: 8a46bc           mov al, byte ptr [bp - 0x44]
  025CA1  10B1: 8b76bc           mov si, word ptr [bp - 0x44]
  025CA4  10B4: 8a8a5cff         mov cl, byte ptr [bp + si - 0xa4]
  025CA8  10B8: 2aed             sub ch, ch
  025CAA  10BA: 8bf9             mov di, cx
  025CAC  10BC: 8843be           mov byte ptr [bp + di - 0x42], al
  025CAF  10BF: ff46bc           inc word ptr [bp - 0x44]
  025CB2  10C2: 8b1e4285         mov bx, word ptr [0x8542]
  025CB6  10C6: 8a471f           mov al, byte ptr [bx + 0x1f]
  025CB9  10C9: 98               cwde 
  025CBA  10CA: 3b46bc           cmp ax, word ptr [bp - 0x44]
  025CBD  10CD: 7fdf             jg 0x10ae
  025CBF  10CF: c746bc0000       mov word ptr [bp - 0x44], 0
  025CC4  10D4: eb29             jmp 0x10ff
  025CC6  10D6: 8b76bc           mov si, word ptr [bp - 0x44]
  025CC9  10D9: 8a827cff         mov al, byte ptr [bp + si - 0x84]
  025CCD  10DD: 8a4abe           mov cl, byte ptr [bp + si - 0x42]
  025CD0  10E0: 2aed             sub ch, ch
  025CD2  10E2: 8bf9             mov di, cx
  025CD4  10E4: 884140           mov byte ptr [bx + di + 0x40], al
  025CD7  10E7: 8a429c           mov al, byte ptr [bp + si - 0x64]
  025CDA  10EA: 884020           mov byte ptr [bx + si + 0x20], al
  025CDD  10ED: 8a42de           mov al, byte ptr [bp + si - 0x22]
  025CE0  10F0: 2ae4             sub ah, ah
  025CE2  10F2: 50               push ax
  025CE3  10F3: 57               push di
  025CE4  10F4: 9a7e0a1f18       lcall 0x181f, 0xa7e
  025CE9  10F9: 83c404           add sp, 4
  025CEC  10FC: ff46bc           inc word ptr [bp - 0x44]
  025CEF  10FF: 8b1e4285         mov bx, word ptr [0x8542]
  025CF3  1103: 8a471f           mov al, byte ptr [bx + 0x1f]
  025CF6  1106: 98               cwde 
  025CF7  1107: 3b46bc           cmp ax, word ptr [bp - 0x44]
  025CFA  110A: 7fca             jg 0x10d6
  025CFC  110C: 8b367c8d         mov si, word ptr [0x8d7c]
  025D00  1110: 8a42be           mov al, byte ptr [bp + si - 0x42]
  025D03  1113: 2ae4             sub ah, ah
  025D05  1115: a37c8d           mov word ptr [0x8d7c], ax
  025D08  1118: c746bc0000       mov word ptr [bp - 0x44], 0
  025D0D  111D: 8b1e4285         mov bx, word ptr [0x8542]
  025D11  1121: 8b76bc           mov si, word ptr [bp - 0x44]
  025D14  1124: 8a4070           mov al, byte ptr [bx + si + 0x70]
  025D17  1127: 8846fe           mov byte ptr [bp - 2], al
  025D1A  112A: 0ac0             or al, al
  025D1C  112C: 7c09             jl 0x1137
  025D1E  112E: 98               cwde 
  025D1F  112F: 8bf8             mov di, ax
  025D21  1131: 8a43be           mov al, byte ptr [bp + di - 0x42]
  025D24  1134: 884070           mov byte ptr [bx + si + 0x70], al
  025D27  1137: ff46bc           inc word ptr [bp - 0x44]
  025D2A  113A: 837ebc14         cmp word ptr [bp - 0x44], 0x14
  025D2E  113E: 7cdd             jl 0x111d
  025D30  1140: 5e               pop si
  025D31  1141: 5f               pop di
  025D32  1142: c9               leave 
  025D33  1143: cb               retf 

; ---- func_025D34  size=442  insns=156  prologue=ENTER 0x0038,0  terminal=RETF ----
  025D34  1144: c8380000         enter 0x38, 0
  025D38  1148: 57               push di
  025D39  1149: 56               push si
  025D3A  114A: 9a620d1f18       lcall 0x181f, 0xd62
  025D3F  114F: c746ee0000       mov word ptr [bp - 0x12], 0
  025D44  1154: b0ff             mov al, 0xff
  025D46  1156: 8b5eee           mov bx, word ptr [bp - 0x12]
  025D49  1159: 8887928e         mov byte ptr [bx - 0x716e], al
  025D4D  115D: 8887828e         mov byte ptr [bx - 0x717e], al
  025D51  1161: 8bf3             mov si, bx
  025D53  1163: d1e6             shl si, 1
  025D55  1165: c742caffff       mov word ptr [bp + si - 0x36], 0xffff
  025D5A  116A: ff46ee           inc word ptr [bp - 0x12]
  025D5D  116D: 837eee0f         cmp word ptr [bp - 0x12], 0xf
  025D61  1171: 7ce1             jl 0x1154
  025D63  1173: c746ee0000       mov word ptr [bp - 0x12], 0
  025D68  1178: 8b76ee           mov si, word ptr [bp - 0x12]
  025D6B  117B: d1e6             shl si, 1
  025D6D  117D: c742f20000       mov word ptr [bp + si - 0xe], 0
  025D72  1182: ff46ee           inc word ptr [bp - 0x12]
  025D75  1185: 837eee05         cmp word ptr [bp - 0x12], 5
  025D79  1189: 7ced             jl 0x1178
  025D7B  118B: c746ee0000       mov word ptr [bp - 0x12], 0
  025D80  1190: eb2b             jmp 0x11bd
  025D82  1192: ff46fc           inc word ptr [bp - 4]
  025D85  1195: 8b5eee           mov bx, word ptr [bp - 0x12]
  025D88  1198: 8a872402         mov al, byte ptr [bx + 0x224]
  025D8C  119C: 2ae4             sub ah, ah
  025D8E  119E: 3b46fc           cmp ax, word ptr [bp - 4]
  025D91  11A1: 7e17             jle 0x11ba
  025D93  11A3: 2aff             sub bh, bh
  025D95  11A5: 8b76ee           mov si, word ptr [bp - 0x12]
  025D98  11A8: 8a842a02         mov al, byte ptr [si + 0x22a]
  025D9C  11AC: 8bf0             mov si, ax
  025D9E  11AE: 8bc3             mov ax, bx
  025DA0  11B0: 8b5efc           mov bx, word ptr [bp - 4]
  025DA3  11B3: 8880628d         mov byte ptr [bx + si - 0x729e], al
  025DA7  11B7: ebd9             jmp 0x1192
  025DA9  11B9: 90               nop 
  025DAA  11BA: ff46ee           inc word ptr [bp - 0x12]
  025DAD  11BD: 837eee05         cmp word ptr [bp - 0x12], 5
  025DB1  11C1: 7d07             jge 0x11ca
  025DB3  11C3: c746fc0000       mov word ptr [bp - 4], 0
  025DB8  11C8: ebcb             jmp 0x1195
  025DBA  11CA: c746ee0000       mov word ptr [bp - 0x12], 0
  025DBF  11CF: 8b5eee           mov bx, word ptr [bp - 0x12]
  025DC2  11D2: 8a9f628d         mov bl, byte ptr [bx - 0x729e]
  025DC6  11D6: 2aff             sub bh, bh
  025DC8  11D8: 895ef0           mov word ptr [bp - 0x10], bx
  025DCB  11DB: 8a872a02         mov al, byte ptr [bx + 0x22a]
  025DCF  11DF: 2ae4             sub ah, ah
  025DD1  11E1: 8946ea           mov word ptr [bp - 0x16], ax
  025DD4  11E4: 8a872402         mov al, byte ptr [bx + 0x224]
  025DD8  11E8: 8946fe           mov word ptr [bp - 2], ax
  025DDB  11EB: 8b46fe           mov ax, word ptr [bp - 2]
  025DDE  11EE: 48               dec ax
  025DDF  11EF: 50               push ax
  025DE0  11F0: 6a00             push 0
  025DE2  11F2: 9ad4041f18       lcall 0x181f, 0x4d4
  025DE7  11F7: 83c404           add sp, 4
  025DEA  11FA: 0346ea           add ax, word ptr [bp - 0x16]
  025DED  11FD: 8946e8           mov word ptr [bp - 0x18], ax
  025DF0  1200: 8bd8             mov bx, ax
  025DF2  1202: 80bf928e00       cmp byte ptr [bx - 0x716e], 0
  025DF7  1207: 7de2             jge 0x11eb
  025DF9  1209: 8a46ee           mov al, byte ptr [bp - 0x12]
  025DFC  120C: 8887928e         mov byte ptr [bx - 0x716e], al
  025E00  1210: ff46ee           inc word ptr [bp - 0x12]
  025E03  1213: 837eee0f         cmp word ptr [bp - 0x12], 0xf
  025E07  1217: 7cb6             jl 0x11cf
  025E09  1219: c746ee0000       mov word ptr [bp - 0x12], 0
  025E0E  121E: 8b5eee           mov bx, word ptr [bp - 0x12]
  025E11  1221: 8bc3             mov ax, bx
  025E13  1223: d1e3             shl bx, 1
  025E15  1225: 03d8             add bx, ax
  025E17  1227: c1e302           shl bx, 2
  025E1A  122A: 8a87888f         mov al, byte ptr [bx - 0x7078]
  025E1E  122E: 98               cwde 
  025E1F  122F: 8bf0             mov si, ax
  025E21  1231: 8976c8           mov word ptr [bp - 0x38], si
  025E24  1234: d1e6             shl si, 1
  025E26  1236: 837aca00         cmp word ptr [bp + si - 0x36], 0
  025E2A  123A: 7d27             jge 0x1263
  025E2C  123C: 8a87878f         mov al, byte ptr [bx - 0x7079]
  025E30  1240: 98               cwde 
  025E31  1241: 8bf8             mov di, ax
  025E33  1243: 897eec           mov word ptr [bp - 0x14], di
  025E36  1246: d1e7             shl di, 1
  025E38  1248: 8b43f2           mov ax, word ptr [bp + di - 0xe]
  025E3B  124B: ff43f2           inc word ptr [bp + di - 0xe]
  025E3E  124E: 8946f0           mov word ptr [bp - 0x10], ax
  025E41  1251: 8b5eec           mov bx, word ptr [bp - 0x14]
  025E44  1254: 8a872a02         mov al, byte ptr [bx + 0x22a]
  025E48  1258: 2ae4             sub ah, ah
  025E4A  125A: 0146f0           add word ptr [bp - 0x10], ax
  025E4D  125D: 8b46f0           mov ax, word ptr [bp - 0x10]
  025E50  1260: 8942ca           mov word ptr [bp + si - 0x36], ax
  025E53  1263: ff46ee           inc word ptr [bp - 0x12]
  025E56  1266: 837eee2a         cmp word ptr [bp - 0x12], 0x2a
  025E5A  126A: 7cb2             jl 0x121e
  025E5C  126C: c746ee0000       mov word ptr [bp - 0x12], 0
  025E61  1271: ff76ee           push word ptr [bp - 0x12]
  025E64  1274: 9afc091f18       lcall 0x181f, 0x9fc
  025E69  1279: 83c402           add sp, 2
  025E6C  127C: 0bc0             or ax, ax
  025E6E  127E: 7505             jne 0x1285
  025E70  1280: 3946ee           cmp word ptr [bp - 0x12], ax
  025E73  1283: 752e             jne 0x12b3
  025E75  1285: 8b5eee           mov bx, word ptr [bp - 0x12]
  025E78  1288: 8bc3             mov ax, bx
  025E7A  128A: d1e3             shl bx, 1
  025E7C  128C: 03d8             add bx, ax
  025E7E  128E: c1e302           shl bx, 2
  025E81  1291: 8a87888f         mov al, byte ptr [bx - 0x7078]
  025E85  1295: 98               cwde 
  025E86  1296: 8bf0             mov si, ax
  025E88  1298: 8976c8           mov word ptr [bp - 0x38], si
  025E8B  129B: d1e6             shl si, 1
  025E8D  129D: 8b42ca           mov ax, word ptr [bp + si - 0x36]
  025E90  12A0: 8946f0           mov word ptr [bp - 0x10], ax
  025E93  12A3: 8bd8             mov bx, ax
  025E95  12A5: 8a87928e         mov al, byte ptr [bx - 0x716e]
  025E99  12A9: 98               cwde 
  025E9A  12AA: 8bd8             mov bx, ax
  025E9C  12AC: 8a46ee           mov al, byte ptr [bp - 0x12]
  025E9F  12AF: 8887828e         mov byte ptr [bx - 0x717e], al
  025EA3  12B3: ff46ee           inc word ptr [bp - 0x12]
  025EA6  12B6: 837eee2a         cmp word ptr [bp - 0x12], 0x2a
  025EAA  12BA: 7cb5             jl 0x1271
  025EAC  12BC: 5e               pop si
  025EAD  12BD: 5f               pop di
  025EAE  12BE: c9               leave 
  025EAF  12BF: cb               retf 
  025EB0  12C0: 0e               push cs
  025EB1  12C1: e8386b           call 0x7dfc
  025EB4  12C4: cb               retf 
  025EB5  12C5: 90               nop 
  025EB6  12C6: 6a01             push 1
  025EB8  12C8: ff36a483         push word ptr [0x83a4]
  025EBC  12CC: ff36a283         push word ptr [0x83a2]
  025EC0  12D0: ff36a083         push word ptr [0x83a0]
  025EC4  12D4: ff369e83         push word ptr [0x839e]
  025EC8  12D8: 68a00b           push 0xba0
  025ECB  12DB: 9a7a081f19       lcall 0x191f, 0x87a
  025ED0  12E0: 83c40c           add sp, 0xc
  025ED3  12E3: 0bc0             or ax, ax
  025ED5  12E5: 7416             je 0x12fd
  025ED7  12E7: 6a00             push 0
  025ED9  12E9: 6a00             push 0
  025EDB  12EB: 6a00             push 0
  025EDD  12ED: 6a00             push 0
  025EDF  12EF: b8adff           mov ax, 0xffad
  025EE2  12F2: ba0200           mov dx, 2
  025EE5  12F5: bb2c00           mov bx, 0x2c
  025EE8  12F8: 9a72071f18       lcall 0x181f, 0x772
  025EED  12FD: cb               retf 

; ---- func_025EEE  size=308  insns=108  prologue=ENTER 0x005E,0  terminal=RETF ----
  025EEE  12FE: c85e0000         enter 0x5e, 0
  025EF2  1302: 8b5e0c           mov bx, word ptr [bp + 0xc]
  025EF5  1305: 8a873002         mov al, byte ptr [bx + 0x230]
  025EF9  1309: 98               cwde 
  025EFA  130A: 8946aa           mov word ptr [bp - 0x56], ax
  025EFD  130D: 8a873602         mov al, byte ptr [bx + 0x236]
  025F01  1311: 98               cwde 
  025F02  1312: 8946a8           mov word ptr [bp - 0x58], ax
  025F05  1315: c646b000         mov byte ptr [bp - 0x50], 0
  025F09  1319: 837e0600         cmp word ptr [bp + 6], 0
  025F0D  131D: 7c43             jl 0x1362
  025F0F  131F: ff7606           push word ptr [bp + 6]
  025F12  1322: 9afc091f18       lcall 0x181f, 0x9fc
  025F17  1327: 83c402           add sp, 2
  025F1A  132A: 0bc0             or ax, ax
  025F1C  132C: 741c             je 0x134a
  025F1E  132E: 8b5e06           mov bx, word ptr [bp + 6]
  025F21  1331: 8bc3             mov ax, bx
  025F23  1333: d1e3             shl bx, 1
  025F25  1335: 03d8             add bx, ax
  025F27  1337: c1e302           shl bx, 2
  025F2A  133A: ffb7828f         push word ptr [bx - 0x707e]
  025F2E  133E: 8d46b0           lea ax, [bp - 0x50]
  025F31  1341: 50               push ax
  025F32  1342: 9a6e011f18       lcall 0x181f, 0x16e
  025F37  1347: 83c404           add sp, 4
  025F3A  134A: 837e0c03         cmp word ptr [bp + 0xc], 3
  025F3E  134E: 7522             jne 0x1372
  025F40  1350: 8d46b0           lea ax, [bp - 0x50]
  025F43  1353: 50               push ax
  025F44  1354: 9a78011f18       lcall 0x181f, 0x178
  025F49  1359: 83c402           add sp, 2
  025F4C  135C: ff36b02e         push word ptr [0x2eb0]
  025F50  1360: eb04             jmp 0x1366
  025F52  1362: ff36ae2e         push word ptr [0x2eae]
  025F56  1366: 8d46b0           lea ax, [bp - 0x50]
  025F59  1369: 50               push ax
  025F5A  136A: 9a6e011f18       lcall 0x181f, 0x16e
  025F5F  136F: 83c404           add sp, 4
  025F62  1372: ff36a008         push word ptr [0x8a0]
  025F66  1376: ff369e08         push word ptr [0x89e]
  025F6A  137A: 8d46b0           lea ax, [bp - 0x50]
  025F6D  137D: 16               push ss
  025F6E  137E: 50               push ax
  025F6F  137F: 2bc0             sub ax, ax
  025F71  1381: 9a04021f18       lcall 0x181f, 0x204
  025F76  1386: 48               dec ax
  025F77  1387: 8946a2           mov word ptr [bp - 0x5e], ax
  025F7A  138A: 40               inc ax
  025F7B  138B: 40               inc ax
  025F7C  138C: 8946a6           mov word ptr [bp - 0x5a], ax
  025F7F  138F: c746a40700       mov word ptr [bp - 0x5c], 7
  025F84  1394: d1f8             sar ax, 1
  025F86  1396: 8b4eaa           mov cx, word ptr [bp - 0x56]
  025F89  1399: d1f9             sar cx, 1
  025F8B  139B: 2bc8             sub cx, ax
  025F8D  139D: 034e08           add cx, word ptr [bp + 8]
  025F90  13A0: 894eae           mov word ptr [bp - 0x52], cx
  025F93  13A3: 8b460a           mov ax, word ptr [bp + 0xa]
  025F96  13A6: 8946ac           mov word ptr [bp - 0x54], ax
  025F99  13A9: 837e0c02         cmp word ptr [bp + 0xc], 2
  025F9D  13AD: 740c             je 0x13bb
  025F9F  13AF: 837e0c04         cmp word ptr [bp + 0xc], 4
  025FA3  13B3: 7406             je 0x13bb
  025FA5  13B5: 837e0600         cmp word ptr [bp + 6], 0
  025FA9  13B9: 7d0f             jge 0x13ca
  025FAB  13BB: 8b46a8           mov ax, word ptr [bp - 0x58]
  025FAE  13BE: d1f8             sar ax, 1
  025FB0  13C0: 8b4ea4           mov cx, word ptr [bp - 0x5c]
  025FB3  13C3: d1f9             sar cx, 1
  025FB5  13C5: 2bc1             sub ax, cx
  025FB7  13C7: 0146ac           add word ptr [bp - 0x54], ax
  025FBA  13CA: b8c700           mov ax, 0xc7
  025FBD  13CD: 2b46a6           sub ax, word ptr [bp - 0x5a]
  025FC0  13D0: 50               push ax
  025FC1  13D1: 6a00             push 0
  025FC3  13D3: ff76ae           push word ptr [bp - 0x52]
  025FC6  13D6: 9a5c031f18       lcall 0x181f, 0x35c
  025FCB  13DB: 83c406           add sp, 6
  025FCE  13DE: 8946ae           mov word ptr [bp - 0x52], ax
  025FD1  13E1: ff36ae2d         push word ptr [0x2dae]
  025FD5  13E5: ff36ac2d         push word ptr [0x2dac]
  025FD9  13E9: ff36aa2d         push word ptr [0x2daa]
  025FDD  13ED: ff36a82d         push word ptr [0x2da8]
  025FE1  13F1: ff76a4           push word ptr [bp - 0x5c]
  025FE4  13F4: 6a00             push 0
  025FE6  13F6: 8b56ac           mov dx, word ptr [bp - 0x54]
  025FE9  13F9: 8b5ea6           mov bx, word ptr [bp - 0x5a]
  025FEC  13FC: 9aba001f18       lcall 0x181f, 0xba
  025FF1  1401: 6a0f             push 0xf
  025FF3  1403: b8ffff           mov ax, 0xffff
  025FF6  1406: ba0f00           mov dx, 0xf
  025FF9  1409: 8bda             mov bx, dx
  025FFB  140B: 9af0011f18       lcall 0x181f, 0x1f0
  026000  1410: ff36a008         push word ptr [0x8a0]
  026004  1414: ff369e08         push word ptr [0x89e]
  026008  1418: 8d46b0           lea ax, [bp - 0x50]
  02600B  141B: 16               push ss
  02600C  141C: 50               push ax
  02600D  141D: 6a00             push 0
  02600F  141F: 8b46ae           mov ax, word ptr [bp - 0x52]
  026012  1422: 40               inc ax
  026013  1423: 8b56ac           mov dx, word ptr [bp - 0x54]
  026016  1426: 42               inc dx
  026017  1427: 8d1ea82d         lea bx, [0x2da8]
  02601B  142B: 9afa011f18       lcall 0x181f, 0x1fa
  026020  1430: c9               leave 
  026021  1431: cb               retf 

; ---- func_026022  size=288  insns=102  prologue=ENTER 0x0064,0  terminal=RETF ----
  026022  1432: c8640000         enter 0x64, 0
  026026  1436: 56               push si
  026027  1437: c646b000         mov byte ptr [bp - 0x50], 0
  02602B  143B: 8b5e06           mov bx, word ptr [bp + 6]
  02602E  143E: d1e3             shl bx, 1
  026030  1440: ffb7c097         push word ptr [bx - 0x6840]
  026034  1444: 8d46b0           lea ax, [bp - 0x50]
  026037  1447: 50               push ax
  026038  1448: 8bf3             mov si, bx
  02603A  144A: 9a6e011f18       lcall 0x181f, 0x16e
  02603F  144F: 83c404           add sp, 4
  026042  1452: 8d46b0           lea ax, [bp - 0x50]
  026045  1455: 50               push ax
  026046  1456: 9a78011f18       lcall 0x181f, 0x178
  02604B  145B: 83c402           add sp, 2
  02604E  145E: 8d46b0           lea ax, [bp - 0x50]
  026051  1461: 50               push ax
  026052  1462: 9a1e011f18       lcall 0x181f, 0x11e
  026057  1467: 83c402           add sp, 2
  02605A  146A: 8b1e4285         mov bx, word ptr [0x8542]
  02605E  146E: ffb09a00         push word ptr [bx + si + 0x9a]
  026062  1472: 8d46b0           lea ax, [bp - 0x50]
  026065  1475: 16               push ss
  026066  1476: 50               push ax
  026067  1477: 9a82011f18       lcall 0x181f, 0x182
  02606C  147C: 83c406           add sp, 6
  02606F  147F: 8d46b0           lea ax, [bp - 0x50]
  026072  1482: 50               push ax
  026073  1483: 9a78011f18       lcall 0x181f, 0x178
  026078  1488: 83c402           add sp, 2
  02607B  148B: ff362e2e         push word ptr [0x2e2e]
  02607F  148F: 8d46b0           lea ax, [bp - 0x50]
  026082  1492: 50               push ax
  026083  1493: 9a6e011f18       lcall 0x181f, 0x16e
  026088  1498: 83c404           add sp, 4
  02608B  149B: 8d46b0           lea ax, [bp - 0x50]
  02608E  149E: 50               push ax
  02608F  149F: 9a28011f18       lcall 0x181f, 0x128
  026094  14A4: 83c402           add sp, 2
  026097  14A7: c746ae0100       mov word ptr [bp - 0x52], 1
  02609C  14AC: c746acb500       mov word ptr [bp - 0x54], 0xb5
  0260A1  14B1: 6b460613         imul ax, word ptr [bp + 6], 0x13
  0260A5  14B5: 050a00           add ax, 0xa
  0260A8  14B8: 8946a4           mov word ptr [bp - 0x5c], ax
  0260AB  14BB: ff36a008         push word ptr [0x8a0]
  0260AF  14BF: ff369e08         push word ptr [0x89e]
  0260B3  14C3: 8d4eb0           lea cx, [bp - 0x50]
  0260B6  14C6: 16               push ss
  0260B7  14C7: 51               push cx
  0260B8  14C8: 8bf0             mov si, ax
  0260BA  14CA: 2bc0             sub ax, ax
  0260BC  14CC: 9a04021f18       lcall 0x181f, 0x204
  0260C1  14D1: 48               dec ax
  0260C2  14D2: 89469c           mov word ptr [bp - 0x64], ax
  0260C5  14D5: 40               inc ax
  0260C6  14D6: 40               inc ax
  0260C7  14D7: 8946a0           mov word ptr [bp - 0x60], ax
  0260CA  14DA: 8bc8             mov cx, ax
  0260CC  14DC: 2d3101           sub ax, 0x131
  0260CF  14DF: f7d8             neg ax
  0260D1  14E1: 50               push ax
  0260D2  14E2: 6a00             push 0
  0260D4  14E4: 8bc1             mov ax, cx
  0260D6  14E6: d1f9             sar cx, 1
  0260D8  14E8: 2bf1             sub si, cx
  0260DA  14EA: 56               push si
  0260DB  14EB: 8bf0             mov si, ax
  0260DD  14ED: 9a5c031f18       lcall 0x181f, 0x35c
  0260E2  14F2: 83c406           add sp, 6
  0260E5  14F5: 8946aa           mov word ptr [bp - 0x56], ax
  0260E8  14F8: ff36ae2d         push word ptr [0x2dae]
  0260EC  14FC: ff36ac2d         push word ptr [0x2dac]
  0260F0  1500: ff36aa2d         push word ptr [0x2daa]
  0260F4  1504: ff36a82d         push word ptr [0x2da8]
  0260F8  1508: b80700           mov ax, 7
  0260FB  150B: 89469e           mov word ptr [bp - 0x62], ax
  0260FE  150E: 50               push ax
  0260FF  150F: 6a00             push 0
  026101  1511: bac100           mov dx, 0xc1
  026104  1514: 8956a8           mov word ptr [bp - 0x58], dx
  026107  1517: 8bde             mov bx, si
  026109  1519: 8b46aa           mov ax, word ptr [bp - 0x56]
  02610C  151C: 9aba001f18       lcall 0x181f, 0xba
  026111  1521: 6a0f             push 0xf
  026113  1523: b8ffff           mov ax, 0xffff
  026116  1526: ba0f00           mov dx, 0xf
  026119  1529: 8bda             mov bx, dx
  02611B  152B: 9af0011f18       lcall 0x181f, 0x1f0
  026120  1530: ff36a008         push word ptr [0x8a0]
  026124  1534: ff369e08         push word ptr [0x89e]
  026128  1538: 8d46b0           lea ax, [bp - 0x50]
  02612B  153B: 16               push ss
  02612C  153C: 50               push ax
  02612D  153D: 6a00             push 0
  02612F  153F: 8b46aa           mov ax, word ptr [bp - 0x56]
  026132  1542: 40               inc ax
  026133  1543: 8d1ea82d         lea bx, [0x2da8]
  026137  1547: bac200           mov dx, 0xc2
  02613A  154A: 9afa011f18       lcall 0x181f, 0x1fa
  02613F  154F: 5e               pop si
  026140  1550: c9               leave 
  026141  1551: cb               retf 

; ---- func_026142  size=507  insns=181  prologue=ENTER 0x006E,0  terminal=RETF ----
  026142  1552: c86e0000         enter 0x6e, 0
  026146  1556: 57               push di
  026147  1557: 56               push si
  026148  1558: 837e0600         cmp word ptr [bp + 6], 0
  02614C  155C: 7d03             jge 0x1561
  02614E  155E: e9e801           jmp 0x1749
  026151  1561: 8b4606           mov ax, word ptr [bp + 6]
  026154  1564: c1f803           sar ax, 3
  026157  1567: 8946aa           mov word ptr [bp - 0x56], ax
  02615A  156A: 8bd8             mov bx, ax
  02615C  156C: 8b7606           mov si, word ptr [bp + 6]
  02615F  156F: 83e607           and si, 7
  026162  1572: 8976ae           mov word ptr [bp - 0x52], si
  026165  1575: 8bc6             mov ax, si
  026167  1577: c1e602           shl si, 2
  02616A  157A: 03f0             add si, ax
  02616C  157C: f680f08d10       test byte ptr [bx + si - 0x7210], 0x10
  026171  1581: 7403             je 0x1586
  026173  1583: e9c301           jmp 0x1749
  026176  1586: 8b1e4285         mov bx, word ptr [0x8542]
  02617A  158A: 8a4701           mov al, byte ptr [bx + 1]
  02617D  158D: 2ae4             sub ah, ah
  02617F  158F: 0346aa           add ax, word ptr [bp - 0x56]
  026182  1592: 48               dec ax
  026183  1593: 48               dec ax
  026184  1594: 8946a4           mov word ptr [bp - 0x5c], ax
  026187  1597: c646b000         mov byte ptr [bp - 0x50], 0
  02618B  159B: 50               push ax
  02618C  159C: 8a07             mov al, byte ptr [bx]
  02618E  159E: 2ae4             sub ah, ah
  026190  15A0: 0346ae           add ax, word ptr [bp - 0x52]
  026193  15A3: 48               dec ax
  026194  15A4: 48               dec ax
  026195  15A5: 8946a6           mov word ptr [bp - 0x5a], ax
  026198  15A8: 50               push ax
  026199  15A9: 9a8c071f18       lcall 0x181f, 0x78c
  02619E  15AE: 83c404           add sp, 4
  0261A1  15B1: 89469e           mov word ptr [bp - 0x62], ax
  0261A4  15B4: 3d1900           cmp ax, 0x19
  0261A7  15B7: 7521             jne 0x15da
  0261A9  15B9: ff76a4           push word ptr [bp - 0x5c]
  0261AC  15BC: ff76a6           push word ptr [bp - 0x5a]
  0261AF  15BF: 9ab4061f18       lcall 0x181f, 0x6b4
  0261B4  15C4: 83c404           add sp, 4
  0261B7  15C7: fec8             dec al
  0261B9  15C9: 740f             je 0x15da
  0261BB  15CB: ff360a2e         push word ptr [0x2e0a]
  0261BF  15CF: 8d46b0           lea ax, [bp - 0x50]
  0261C2  15D2: 50               push ax
  0261C3  15D3: 9a6e011f18       lcall 0x181f, 0x16e
  0261C8  15D8: eb0c             jmp 0x15e6
  0261CA  15DA: ff769e           push word ptr [bp - 0x62]
  0261CD  15DD: 8d46b0           lea ax, [bp - 0x50]
  0261D0  15E0: 50               push ax
  0261D1  15E1: 9ae6011f18       lcall 0x181f, 0x1e6
  0261D6  15E6: 83c404           add sp, 4
  0261D9  15E9: ff76a4           push word ptr [bp - 0x5c]
  0261DC  15EC: ff76a6           push word ptr [bp - 0x5a]
  0261DF  15EF: 9a2c071f18       lcall 0x181f, 0x72c
  0261E4  15F4: 83c404           add sp, 4
  0261E7  15F7: a840             test al, 0x40
  0261E9  15F9: 7437             je 0x1632
  0261EB  15FB: 68a70b           push 0xba7
  0261EE  15FE: 8d46b0           lea ax, [bp - 0x50]
  0261F1  1601: 50               push ax
  0261F2  1602: 9aa4071d0d       lcall 0xd1d, 0x7a4
  0261F7  1607: 83c404           add sp, 4
  0261FA  160A: ff76a4           push word ptr [bp - 0x5c]
  0261FD  160D: ff76a6           push word ptr [bp - 0x5a]
  026200  1610: 9a2c071f18       lcall 0x181f, 0x72c
  026205  1615: 83c404           add sp, 4
  026208  1618: a880             test al, 0x80
  02620A  161A: 7406             je 0x1622
  02620C  161C: ff36b42d         push word ptr [0x2db4]
  026210  1620: eb04             jmp 0x1626
  026212  1622: ff36b62d         push word ptr [0x2db6]
  026216  1626: 8d46b0           lea ax, [bp - 0x50]
  026219  1629: 50               push ax
  02621A  162A: 9a6e011f18       lcall 0x181f, 0x16e
  02621F  162F: 83c404           add sp, 4
  026222  1632: ff76a4           push word ptr [bp - 0x5c]
  026225  1635: ff76a6           push word ptr [bp - 0x5a]
  026228  1638: 9a54071f18       lcall 0x181f, 0x754
  02622D  163D: 83c404           add sp, 4
  026230  1640: a80a             test al, 0xa
  026232  1642: 750c             jne 0x1650
  026234  1644: 837ea602         cmp word ptr [bp - 0x5a], 2
  026238  1648: 7525             jne 0x166f
  02623A  164A: 837ea402         cmp word ptr [bp - 0x5c], 2
  02623E  164E: 751f             jne 0x166f
  026240  1650: 68a90b           push 0xba9
  026243  1653: 8d46b0           lea ax, [bp - 0x50]
  026246  1656: 50               push ax
  026247  1657: 9aa4071d0d       lcall 0xd1d, 0x7a4
  02624C  165C: 83c404           add sp, 4
  02624F  165F: ff36f82d         push word ptr [0x2df8]
  026253  1663: 8d46b0           lea ax, [bp - 0x50]
  026256  1666: 50               push ax
  026257  1667: 9a6e011f18       lcall 0x181f, 0x16e
  02625C  166C: 83c404           add sp, 4
  02625F  166F: ff76a4           push word ptr [bp - 0x5c]
  026262  1672: ff76a6           push word ptr [bp - 0x5a]
  026265  1675: 9a54071f18       lcall 0x181f, 0x754
  02626A  167A: 83c404           add sp, 4
  02626D  167D: a840             test al, 0x40
  02626F  167F: 741f             je 0x16a0
  026271  1681: 68ab0b           push 0xbab
  026274  1684: 8d46b0           lea ax, [bp - 0x50]
  026277  1687: 50               push ax
  026278  1688: 9aa4071d0d       lcall 0xd1d, 0x7a4
  02627D  168D: 83c404           add sp, 4
  026280  1690: ff36602e         push word ptr [0x2e60]
  026284  1694: 8d46b0           lea ax, [bp - 0x50]
  026287  1697: 50               push ax
  026288  1698: 9a6e011f18       lcall 0x181f, 0x16e
  02628D  169D: 83c404           add sp, 4
  026290  16A0: 6b46aa18         imul ax, word ptr [bp - 0x56], 0x18
  026294  16A4: 050800           add ax, 8
  026297  16A7: 8946a8           mov word ptr [bp - 0x58], ax
  02629A  16AA: ff36a008         push word ptr [0x8a0]
  02629E  16AE: ff369e08         push word ptr [0x89e]
  0262A2  16B2: 8d4eb0           lea cx, [bp - 0x50]
  0262A5  16B5: 16               push ss
  0262A6  16B6: 51               push cx
  0262A7  16B7: 8bf0             mov si, ax
  0262A9  16B9: 2bc0             sub ax, ax
  0262AB  16BB: 9a04021f18       lcall 0x181f, 0x204
  0262B0  16C0: 48               dec ax
  0262B1  16C1: 894692           mov word ptr [bp - 0x6e], ax
  0262B4  16C4: 40               inc ax
  0262B5  16C5: 40               inc ax
  0262B6  16C6: 894696           mov word ptr [bp - 0x6a], ax
  0262B9  16C9: 8976a0           mov word ptr [bp - 0x60], si
  0262BC  16CC: 8bc8             mov cx, ax
  0262BE  16CE: 2d4001           sub ax, 0x140
  0262C1  16D1: f7d8             neg ax
  0262C3  16D3: 50               push ax
  0262C4  16D4: 68c800           push 0xc8
  0262C7  16D7: 8bc1             mov ax, cx
  0262C9  16D9: d1f9             sar cx, 1
  0262CB  16DB: 6b56ae18         imul dx, word ptr [bp - 0x52], 0x18
  0262CF  16DF: 81c2d400         add dx, 0xd4
  0262D3  16E3: 8956ac           mov word ptr [bp - 0x54], dx
  0262D6  16E6: 2bd1             sub dx, cx
  0262D8  16E8: 52               push dx
  0262D9  16E9: 8bf8             mov di, ax
  0262DB  16EB: 9a5c031f18       lcall 0x181f, 0x35c
  0262E0  16F0: 83c406           add sp, 6
  0262E3  16F3: 8946a2           mov word ptr [bp - 0x5e], ax
  0262E6  16F6: ff36ae2d         push word ptr [0x2dae]
  0262EA  16FA: ff36ac2d         push word ptr [0x2dac]
  0262EE  16FE: ff36aa2d         push word ptr [0x2daa]
  0262F2  1702: ff36a82d         push word ptr [0x2da8]
  0262F6  1706: b80700           mov ax, 7
  0262F9  1709: 894694           mov word ptr [bp - 0x6c], ax
  0262FC  170C: 50               push ax
  0262FD  170D: 6a00             push 0
  0262FF  170F: 8bd6             mov dx, si
  026301  1711: 8bdf             mov bx, di
  026303  1713: 8b46a2           mov ax, word ptr [bp - 0x5e]
  026306  1716: 9aba001f18       lcall 0x181f, 0xba
  02630B  171B: 6a0f             push 0xf
  02630D  171D: b8ffff           mov ax, 0xffff
  026310  1720: ba0f00           mov dx, 0xf
  026313  1723: 8bda             mov bx, dx
  026315  1725: 9af0011f18       lcall 0x181f, 0x1f0
  02631A  172A: ff36a008         push word ptr [0x8a0]
  02631E  172E: ff369e08         push word ptr [0x89e]
  026322  1732: 8d46b0           lea ax, [bp - 0x50]
  026325  1735: 16               push ss
  026326  1736: 50               push ax
  026327  1737: 6a00             push 0
  026329  1739: 8b46a2           mov ax, word ptr [bp - 0x5e]
  02632C  173C: 40               inc ax
  02632D  173D: 8d5401           lea dx, [si + 1]
  026330  1740: 8d1ea82d         lea bx, [0x2da8]
  026334  1744: 9afa011f18       lcall 0x181f, 0x1fa
  026339  1749: 5e               pop si
  02633A  174A: 5f               pop di
  02633B  174B: c9               leave 
  02633C  174C: cb               retf 

; ---- func_02633E  size=54  insns=17  prologue=push bp;mov bp,sp  terminal=RETF ----
  02633E  174E: 55               push bp
  02633F  174F: 8bec             mov bp, sp
  026341  1751: ff36a483         push word ptr [0x83a4]
  026345  1755: ff36a283         push word ptr [0x83a2]
  026349  1759: ff36a083         push word ptr [0x83a0]
  02634D  175D: ff369e83         push word ptr [0x839e]
  026351  1761: ff36ae2d         push word ptr [0x2dae]
  026355  1765: ff36ac2d         push word ptr [0x2dac]
  026359  1769: ff36aa2d         push word ptr [0x2daa]
  02635D  176D: ff36a82d         push word ptr [0x2da8]
  026361  1771: ff760c           push word ptr [bp + 0xc]
  026364  1774: 8b4606           mov ax, word ptr [bp + 6]
  026367  1777: 8b5608           mov dx, word ptr [bp + 8]
  02636A  177A: 8b5e0a           mov bx, word ptr [bp + 0xa]
  02636D  177D: 9a44041f18       lcall 0x181f, 0x444
  026372  1782: c9               leave 
  026373  1783: cb               retf 

; ---- func_026374  size=308  insns=104  prologue=ENTER 0x000E,0  terminal=RETF ----
  026374  1784: c80e0000         enter 0xe, 0
  026378  1788: 56               push si
  026379  1789: 8b1e4285         mov bx, word ptr [0x8542]
  02637D  178D: 8a07             mov al, byte ptr [bx]
  02637F  178F: 2ae4             sub ah, ah
  026381  1791: a37c01           mov word ptr [0x17c], ax
  026384  1794: 8a4701           mov al, byte ptr [bx + 1]
  026387  1797: a37e01           mov word ptr [0x17e], ax
  02638A  179A: 9a5e0c1f18       lcall 0x181f, 0xc5e
  02638F  179F: 8bd0             mov dx, ax
  026391  17A1: 8b1e4285         mov bx, word ptr [0x8542]
  026395  17A5: 8a471a           mov al, byte ptr [bx + 0x1a]
  026398  17A8: 2ae4             sub ah, ah
  02639A  17AA: 9aa4081f19       lcall 0x191f, 0x8a4
  02639F  17AF: 9a96081f19       lcall 0x191f, 0x896
  0263A4  17B4: 9a88081f19       lcall 0x191f, 0x888
  0263A9  17B9: 6a50             push 0x50
  0263AB  17BB: 6a50             push 0x50
  0263AD  17BD: 6a08             push 8
  0263AF  17BF: 68c800           push 0xc8
  0263B2  17C2: 6a00             push 0
  0263B4  17C4: 6a00             push 0
  0263B6  17C6: ff36a483         push word ptr [0x83a4]
  0263BA  17CA: ff36a283         push word ptr [0x83a2]
  0263BE  17CE: ff36a083         push word ptr [0x83a0]
  0263C2  17D2: ff369e83         push word ptr [0x839e]
  0263C6  17D6: ff36a483         push word ptr [0x83a4]
  0263CA  17DA: ff36a283         push word ptr [0x83a2]
  0263CE  17DE: ff36a083         push word ptr [0x83a0]
  0263D2  17E2: ff369e83         push word ptr [0x839e]
  0263D6  17E6: 9a10051f18       lcall 0x181f, 0x510
  0263DB  17EB: 83c41c           add sp, 0x1c
  0263DE  17EE: 9a5e0c1f18       lcall 0x181f, 0xc5e
  0263E3  17F3: 8bd8             mov bx, ax
  0263E5  17F5: 8a872903         mov al, byte ptr [bx + 0x329]
  0263E9  17F9: 2ae4             sub ah, ah
  0263EB  17FB: 8946fc           mov word ptr [bp - 4], ax
  0263EE  17FE: c746fe0000       mov word ptr [bp - 2], 0
  0263F3  1803: e9a400           jmp 0x18aa
  0263F6  1806: 8bd8             mov bx, ax
  0263F8  1808: 8bc8             mov cx, ax
  0263FA  180A: 8a87de00         mov al, byte ptr [bx + 0xde]
  0263FE  180E: 98               cwde 
  0263FF  180F: 8b364285         mov si, word ptr [0x8542]
  026403  1813: 8a5401           mov dl, byte ptr [si + 1]
  026406  1816: 2af6             sub dh, dh
  026408  1818: 03c2             add ax, dx
  02640A  181A: 8946f6           mov word ptr [bp - 0xa], ax
  02640D  181D: 50               push ax
  02640E  181E: 8a87c800         mov al, byte ptr [bx + 0xc8]
  026412  1822: 98               cwde 
  026413  1823: 8a0c             mov cl, byte ptr [si]
  026415  1825: 2aed             sub ch, ch
  026417  1827: 03c1             add ax, cx
  026419  1829: 8946f8           mov word ptr [bp - 8], ax
  02641C  182C: 50               push ax
  02641D  182D: 9a02031f18       lcall 0x181f, 0x302
  026422  1832: 83c404           add sp, 4
  026425  1835: 0bc0             or ax, ax
  026427  1837: 746e             je 0x18a7
  026429  1839: 8b1e4285         mov bx, word ptr [0x8542]
  02642D  183D: 807f1a04         cmp byte ptr [bx + 0x1a], 4
  026431  1841: 7320             jae 0x1863
  026433  1843: ff76f6           push word ptr [bp - 0xa]
  026436  1846: ff76f8           push word ptr [bp - 8]
  026439  1849: 9a4a071f18       lcall 0x181f, 0x74a
  02643E  184E: 83c404           add sp, 4
  026441  1851: 2ae4             sub ah, ah
  026443  1853: 8b1e4285         mov bx, word ptr [0x8542]
  026447  1857: 8a4f1a           mov cl, byte ptr [bx + 0x1a]
  02644A  185A: ba1000           mov dx, 0x10
  02644D  185D: d3e2             shl dx, cl
  02644F  185F: 85c2             test dx, ax
  026451  1861: 7444             je 0x18a7
  026453  1863: ff76f6           push word ptr [bp - 0xa]
  026456  1866: ff76f8           push word ptr [bp - 8]
  026459  1869: 9a18071f18       lcall 0x181f, 0x718
  02645E  186E: 83c404           add sp, 4
  026461  1871: 8946fa           mov word ptr [bp - 6], ax
  026464  1874: 40               inc ax
  026465  1875: 7430             je 0x18a7
  026467  1877: 8b5efe           mov bx, word ptr [bp - 2]
  02646A  187A: b018             mov al, 0x18
  02646C  187C: f6afde00         imul byte ptr [bx + 0xde]
  026470  1880: 053c00           add ax, 0x3c
  026473  1883: ff367601         push word ptr [0x176]
  026477  1887: ff367401         push word ptr [0x174]
  02647B  188B: 50               push ax
  02647C  188C: 8a87c800         mov al, byte ptr [bx + 0xc8]
  026480  1890: 98               cwde 
  026481  1891: 6bd018           imul dx, ax, 0x18
  026484  1894: 81c2fc00         add dx, 0xfc
  026488  1898: 8b46fa           mov ax, word ptr [bp - 6]
  02648B  189B: 055a00           add ax, 0x5a
  02648E  189E: 8d1e9e83         lea bx, [0x839e]
  026492  18A2: 9a54021f18       lcall 0x181f, 0x254
  026497  18A7: ff46fe           inc word ptr [bp - 2]
  02649A  18AA: 8b46fe           mov ax, word ptr [bp - 2]
  02649D  18AD: 3946fc           cmp word ptr [bp - 4], ax
  0264A0  18B0: 7e03             jle 0x18b5
  0264A2  18B2: e951ff           jmp 0x1806
  0264A5  18B5: 5e               pop si
  0264A6  18B6: c9               leave 
  0264A7  18B7: cb               retf 

; ---- func_0264A8  size=1062  insns=363  prologue=ENTER 0x0020,0  terminal=RETF ----
  0264A8  18B8: c8200000         enter 0x20, 0
  0264AC  18BC: 56               push si
  0264AD  18BD: a03603           mov al, byte ptr [0x336]
  0264B0  18C0: 2ae4             sub ah, ah
  0264B2  18C2: a37000           mov word ptr [0x70], ax
  0264B5  18C5: b81800           mov ax, 0x18
  0264B8  18C8: 8946e6           mov word ptr [bp - 0x1a], ax
  0264BB  18CB: 8946e4           mov word ptr [bp - 0x1c], ax
  0264BE  18CE: a03508           mov al, byte ptr [0x835]
  0264C1  18D1: 2ae4             sub ah, ah
  0264C3  18D3: 50               push ax
  0264C4  18D4: 6a78             push 0x78
  0264C6  18D6: 6a78             push 0x78
  0264C8  18D8: 6a08             push 8
  0264CA  18DA: b8c800           mov ax, 0xc8
  0264CD  18DD: 8946ee           mov word ptr [bp - 0x12], ax
  0264D0  18E0: 50               push ax
  0264D1  18E1: ff36ae2d         push word ptr [0x2dae]
  0264D5  18E5: ff36ac2d         push word ptr [0x2dac]
  0264D9  18E9: ff36aa2d         push word ptr [0x2daa]
  0264DD  18ED: ff36a82d         push word ptr [0x2da8]
  0264E1  18F1: 9a06051f18       lcall 0x181f, 0x506
  0264E6  18F6: 83c412           add sp, 0x12
  0264E9  18F9: 6a48             push 0x48
  0264EB  18FB: 6a48             push 0x48
  0264ED  18FD: 6a20             push 0x20
  0264EF  18FF: 68e000           push 0xe0
  0264F2  1902: 0e               push cs
  0264F3  1903: e8cd65           call 0x7ed3
  0264F6  1906: 83c408           add sp, 8
  0264F9  1909: ff36ae2d         push word ptr [0x2dae]
  0264FD  190D: ff36ac2d         push word ptr [0x2dac]
  026501  1911: ff36aa2d         push word ptr [0x2daa]
  026505  1915: ff36a82d         push word ptr [0x2da8]
  026509  1919: 688000           push 0x80
  02650C  191C: 6a00             push 0
  02650E  191E: b8c700           mov ax, 0xc7
  026511  1921: ba0700           mov dx, 7
  026514  1924: bb4001           mov bx, 0x140
  026517  1927: 9ace001f18       lcall 0x181f, 0xce
  02651C  192C: ff36ae2d         push word ptr [0x2dae]
  026520  1930: ff36ac2d         push word ptr [0x2dac]
  026524  1934: ff36aa2d         push word ptr [0x2daa]
  026528  1938: ff36a82d         push word ptr [0x2da8]
  02652C  193C: 6a68             push 0x68
  02652E  193E: 6a00             push 0
  026530  1940: b8df00           mov ax, 0xdf
  026533  1943: ba1f00           mov dx, 0x1f
  026536  1946: bb2801           mov bx, 0x128
  026539  1949: 9ace001f18       lcall 0x181f, 0xce
  02653E  194E: c746ec0000       mov word ptr [bp - 0x14], 0
  026543  1953: e95703           jmp 0x1cad
  026546  1956: 8b76ee           mov si, word ptr [bp - 0x12]
  026549  1959: 8bc6             mov ax, si
  02654B  195B: c1e602           shl si, 2
  02654E  195E: 03f0             add si, ax
  026550  1960: 8b5eec           mov bx, word ptr [bp - 0x14]
  026553  1963: 8a80f08d         mov al, byte ptr [bx + si - 0x7210]
  026557  1967: 2ae4             sub ah, ah
  026559  1969: 8946fc           mov word ptr [bp - 4], ax
  02655C  196C: a840             test al, 0x40
  02655E  196E: 7429             je 0x1999
  026560  1970: ff36ae2d         push word ptr [0x2dae]
  026564  1974: ff36ac2d         push word ptr [0x2dac]
  026568  1978: ff36aa2d         push word ptr [0x2daa]
  02656C  197C: ff36a82d         push word ptr [0x2da8]
  026570  1980: 8b46f4           mov ax, word ptr [bp - 0xc]
  026573  1983: 051700           add ax, 0x17
  026576  1986: 50               push ax
  026577  1987: 6a0c             push 0xc
  026579  1989: 8b46f8           mov ax, word ptr [bp - 8]
  02657C  198C: 8bd8             mov bx, ax
  02657E  198E: 83c317           add bx, 0x17
  026581  1991: 8b56f4           mov dx, word ptr [bp - 0xc]
  026584  1994: 9ace001f18       lcall 0x181f, 0xce
  026589  1999: 837efc00         cmp word ptr [bp - 4], 0
  02658D  199D: 7535             jne 0x19d4
  02658F  199F: 8b76ee           mov si, word ptr [bp - 0x12]
  026592  19A2: 8bc6             mov ax, si
  026594  19A4: c1e602           shl si, 2
  026597  19A7: 03f0             add si, ax
  026599  19A9: 8b5eec           mov bx, word ptr [bp - 0x14]
  02659C  19AC: 80b89e8d00       cmp byte ptr [bx + si - 0x7262], 0
  0265A1  19B1: 7c21             jl 0x19d4
  0265A3  19B3: ff364008         push word ptr [0x840]
  0265A7  19B7: ff363e08         push word ptr [0x83e]
  0265AB  19BB: 8b46f4           mov ax, word ptr [bp - 0xc]
  0265AE  19BE: 050400           add ax, 4
  0265B1  19C1: 50               push ax
  0265B2  19C2: 8b56f8           mov dx, word ptr [bp - 8]
  0265B5  19C5: 83c208           add dx, 8
  0265B8  19C8: b86d00           mov ax, 0x6d
  0265BB  19CB: 8d1ea82d         lea bx, [0x2da8]
  0265BF  19CF: 9a54021f18       lcall 0x181f, 0x254
  0265C4  19D4: f646fc80         test byte ptr [bp - 4], 0x80
  0265C8  19D8: 7474             je 0x1a4e
  0265CA  19DA: 8b1e4285         mov bx, word ptr [0x8542]
  0265CE  19DE: 8a4701           mov al, byte ptr [bx + 1]
  0265D1  19E1: 2ae4             sub ah, ah
  0265D3  19E3: 0346ec           add ax, word ptr [bp - 0x14]
  0265D6  19E6: 48               dec ax
  0265D7  19E7: 48               dec ax
  0265D8  19E8: 8946f6           mov word ptr [bp - 0xa], ax
  0265DB  19EB: 8bd0             mov dx, ax
  0265DD  19ED: 8a07             mov al, byte ptr [bx]
  0265DF  19EF: 2ae4             sub ah, ah
  0265E1  19F1: 0346ee           add ax, word ptr [bp - 0x12]
  0265E4  19F4: 48               dec ax
  0265E5  19F5: 48               dec ax
  0265E6  19F6: 8946fa           mov word ptr [bp - 6], ax
  0265E9  19F9: 9ae0071f18       lcall 0x181f, 0x7e0
  0265EE  19FE: eb25             jmp 0x1a25
  0265F0  1A00: 6b5ee21c         imul bx, word ptr [bp - 0x1e], 0x1c
  0265F4  1A04: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  0265F8  1A08: 2aff             sub bh, bh
  0265FA  1A0A: 8bc3             mov ax, bx
  0265FC  1A0C: d1e3             shl bx, 1
  0265FE  1A0E: 03d8             add bx, ax
  026600  1A10: d1e3             shl bx, 1
  026602  1A12: 03d8             add bx, ax
  026604  1A14: d1e3             shl bx, 1
  026606  1A16: 80bf365201       cmp byte ptr [bx + 0x5236], 1
  02660B  1A1B: 770f             ja 0x1a2c
  02660D  1A1D: 8b46e2           mov ax, word ptr [bp - 0x1e]
  026610  1A20: 9ae4021f18       lcall 0x181f, 0x2e4
  026615  1A25: 8946e2           mov word ptr [bp - 0x1e], ax
  026618  1A28: 0bc0             or ax, ax
  02661A  1A2A: 7dd4             jge 0x1a00
  02661C  1A2C: 837ee200         cmp word ptr [bp - 0x1e], 0
  026620  1A30: 7c1c             jl 0x1a4e
  026622  1A32: 8b46f4           mov ax, word ptr [bp - 0xc]
  026625  1A35: 050400           add ax, 4
  026628  1A38: 50               push ax
  026629  1A39: 6a10             push 0x10
  02662B  1A3B: 6a64             push 0x64
  02662D  1A3D: 8b5ef8           mov bx, word ptr [bp - 8]
  026630  1A40: 83c304           add bx, 4
  026633  1A43: 8b46e2           mov ax, word ptr [bp - 0x1e]
  026636  1A46: bae000           mov dx, 0xe0
  026639  1A49: 9abc021f18       lcall 0x181f, 0x2bc
  02663E  1A4E: f646fc08         test byte ptr [bp - 4], 8
  026642  1A52: 744b             je 0x1a9f
  026644  1A54: ff76f8           push word ptr [bp - 8]
  026647  1A57: ff76f4           push word ptr [bp - 0xc]
  02664A  1A5A: 6a18             push 0x18
  02664C  1A5C: 6a10             push 0x10
  02664E  1A5E: 6a00             push 0
  026650  1A60: 6a00             push 0
  026652  1A62: 8a1691a8         mov dl, byte ptr [0xa891]
  026656  1A66: 2af6             sub dh, dh
  026658  1A68: 8bda             mov bx, dx
  02665A  1A6A: b81700           mov ax, 0x17
  02665D  1A6D: 9a36021f18       lcall 0x181f, 0x236
  026662  1A72: 803e93a800       cmp byte ptr [0xa893], 0
  026667  1A77: 7c26             jl 0x1a9f
  026669  1A79: ff76f8           push word ptr [bp - 8]
  02666C  1A7C: 8b46f4           mov ax, word ptr [bp - 0xc]
  02666F  1A7F: 050d00           add ax, 0xd
  026672  1A82: 50               push ax
  026673  1A83: 6a18             push 0x18
  026675  1A85: 6a10             push 0x10
  026677  1A87: 6a00             push 0
  026679  1A89: 6a00             push 0
  02667B  1A8B: a094a8           mov al, byte ptr [0xa894]
  02667E  1A8E: 98               cwde 
  02667F  1A8F: 8bd0             mov dx, ax
  026681  1A91: 8bda             mov bx, dx
  026683  1A93: a093a8           mov al, byte ptr [0xa893]
  026686  1A96: 98               cwde 
  026687  1A97: 051700           add ax, 0x17
  02668A  1A9A: 9a36021f18       lcall 0x181f, 0x236
  02668F  1A9F: 6a01             push 1
  026691  1AA1: 8d46f0           lea ax, [bp - 0x10]
  026694  1AA4: 50               push ax
  026695  1AA5: ff76ec           push word ptr [bp - 0x14]
  026698  1AA8: ff76ee           push word ptr [bp - 0x12]
  02669B  1AAB: 9a3c0b1f18       lcall 0x181f, 0xb3c
  0266A0  1AB0: 83c408           add sp, 8
  0266A3  1AB3: 8946f2           mov word ptr [bp - 0xe], ax
  0266A6  1AB6: 8b46f0           mov ax, word ptr [bp - 0x10]
  0266A9  1AB9: 051700           add ax, 0x17
  0266AC  1ABC: 8946fe           mov word ptr [bp - 2], ax
  0266AF  1ABF: ff76ec           push word ptr [bp - 0x14]
  0266B2  1AC2: ff76ee           push word ptr [bp - 0x12]
  0266B5  1AC5: 9ae00c1f18       lcall 0x181f, 0xce0
  0266BA  1ACA: 83c404           add sp, 4
  0266BD  1ACD: 98               cwde 
  0266BE  1ACE: 8946e0           mov word ptr [bp - 0x20], ax
  0266C1  1AD1: 50               push ax
  0266C2  1AD2: 9a0e0c1f18       lcall 0x181f, 0xc0e
  0266C7  1AD7: 83c402           add sp, 2
  0266CA  1ADA: 8946e8           mov word ptr [bp - 0x18], ax
  0266CD  1ADD: 3d0800           cmp ax, 8
  0266D0  1AE0: 7505             jne 0x1ae7
  0266D2  1AE2: c746fe3a00       mov word ptr [bp - 2], 0x3a
  0266D7  1AE7: 837ef200         cmp word ptr [bp - 0xe], 0
  0266DB  1AEB: 7e2b             jle 0x1b18
  0266DD  1AED: ff76f8           push word ptr [bp - 8]
  0266E0  1AF0: ff76f4           push word ptr [bp - 0xc]
  0266E3  1AF3: 6a18             push 0x18
  0266E5  1AF5: 837ef202         cmp word ptr [bp - 0xe], 2
  0266E9  1AF9: 7e05             jle 0x1b00
  0266EB  1AFB: b81000           mov ax, 0x10
  0266EE  1AFE: eb03             jmp 0x1b03
  0266F0  1B00: b81800           mov ax, 0x18
  0266F3  1B03: 50               push ax
  0266F4  1B04: 6a00             push 0
  0266F6  1B06: 6a00             push 0
  0266F8  1B08: 8b46fe           mov ax, word ptr [bp - 2]
  0266FB  1B0B: 8b56f2           mov dx, word ptr [bp - 0xe]
  0266FE  1B0E: 8bda             mov bx, dx
  026700  1B10: 9a36021f18       lcall 0x181f, 0x236
  026705  1B15: eb56             jmp 0x1b6d
  026707  1B17: 90               nop 
  026708  1B18: 837ef000         cmp word ptr [bp - 0x10], 0
  02670C  1B1C: 7c4f             jl 0x1b6d
  02670E  1B1E: 8b76f0           mov si, word ptr [bp - 0x10]
  026711  1B21: 8bc6             mov ax, si
  026713  1B23: d1e6             shl si, 1
  026715  1B25: 03f0             add si, ax
  026717  1B27: c1e602           shl si, 2
  02671A  1B2A: c41e3e08         les bx, ptr [0x83e]
  02671E  1B2E: 268b805201       mov ax, word ptr es:[bx + si + 0x152]
  026723  1B33: 8946ea           mov word ptr [bp - 0x16], ax
  026726  1B36: 06               push es
  026727  1B37: 53               push bx
  026728  1B38: 8b4ef4           mov cx, word ptr [bp - 0xc]
  02672B  1B3B: 41               inc cx
  02672C  1B3C: 51               push cx
  02672D  1B3D: ba1000           mov dx, 0x10
  026730  1B40: 2bd0             sub dx, ax
  026732  1B42: d1fa             sar dx, 1
  026734  1B44: 0356f8           add dx, word ptr [bp - 8]
  026737  1B47: 8b46fe           mov ax, word ptr [bp - 2]
  02673A  1B4A: 8d1ea82d         lea bx, [0x2da8]
  02673E  1B4E: 9a54021f18       lcall 0x181f, 0x254
  026743  1B53: ff364008         push word ptr [0x840]
  026747  1B57: ff363e08         push word ptr [0x83e]
  02674B  1B5B: ff76f4           push word ptr [bp - 0xc]
  02674E  1B5E: b84100           mov ax, 0x41
  026751  1B61: 8d1ea82d         lea bx, [0x2da8]
  026755  1B65: 8b56f8           mov dx, word ptr [bp - 8]
  026758  1B68: 9a54021f18       lcall 0x181f, 0x254
  02675D  1B6D: 837ef000         cmp word ptr [bp - 0x10], 0
  026761  1B71: 7c1e             jl 0x1b91
  026763  1B73: 6a03             push 3
  026765  1B75: ff76e0           push word ptr [bp - 0x20]
  026768  1B78: 9a740a1f18       lcall 0x181f, 0xa74
  02676D  1B7D: 83c402           add sp, 2
  026770  1B80: 8b56f8           mov dx, word ptr [bp - 8]
  026773  1B83: 83c20c           add dx, 0xc
  026776  1B86: 8b5ef4           mov bx, word ptr [bp - 0xc]
  026779  1B89: 83c306           add bx, 6
  02677C  1B8C: 9a4a021f18       lcall 0x181f, 0x24a
  026781  1B91: 833e980b00       cmp word ptr [0xb98], 0
  026786  1B96: 743e             je 0x1bd6
  026788  1B98: ff46ee           inc word ptr [bp - 0x12]
  02678B  1B9B: 837eee05         cmp word ptr [bp - 0x12], 5
  02678F  1B9F: 7c03             jl 0x1ba4
  026791  1BA1: e90601           jmp 0x1caa
  026794  1BA4: 6b46ee18         imul ax, word ptr [bp - 0x12], 0x18
  026798  1BA8: 05c800           add ax, 0xc8
  02679B  1BAB: 8946f8           mov word ptr [bp - 8], ax
  02679E  1BAE: 6b46ec18         imul ax, word ptr [bp - 0x14], 0x18
  0267A2  1BB2: 050800           add ax, 8
  0267A5  1BB5: 8946f4           mov word ptr [bp - 0xc], ax
  0267A8  1BB8: 837eee00         cmp word ptr [bp - 0x12], 0
  0267AC  1BBC: 74da             je 0x1b98
  0267AE  1BBE: 837eec00         cmp word ptr [bp - 0x14], 0
  0267B2  1BC2: 74d4             je 0x1b98
  0267B4  1BC4: 837eee04         cmp word ptr [bp - 0x12], 4
  0267B8  1BC8: 74ce             je 0x1b98
  0267BA  1BCA: 837eec04         cmp word ptr [bp - 0x14], 4
  0267BE  1BCE: 7403             je 0x1bd3
  0267C0  1BD0: e983fd           jmp 0x1956
  0267C3  1BD3: ebc3             jmp 0x1b98
  0267C5  1BD5: 90               nop 
  0267C6  1BD6: ff76ec           push word ptr [bp - 0x14]
  0267C9  1BD9: ff76ee           push word ptr [bp - 0x12]
  0267CC  1BDC: 9ae00c1f18       lcall 0x181f, 0xce0
  0267D1  1BE1: 83c404           add sp, 4
  0267D4  1BE4: 98               cwde 
  0267D5  1BE5: 8946e0           mov word ptr [bp - 0x20], ax
  0267D8  1BE8: 39067c8d         cmp word ptr [0x8d7c], ax
  0267DC  1BEC: 7537             jne 0x1c25
  0267DE  1BEE: 833eee0700       cmp word ptr [0x7ee], 0
  0267E3  1BF3: 7407             je 0x1bfc
  0267E5  1BF5: 833e548d00       cmp word ptr [0x8d54], 0
  0267EA  1BFA: 7429             je 0x1c25
  0267EC  1BFC: ff36ae2d         push word ptr [0x2dae]
  0267F0  1C00: ff36ac2d         push word ptr [0x2dac]
  0267F4  1C04: ff36aa2d         push word ptr [0x2daa]
  0267F8  1C08: ff36a82d         push word ptr [0x2da8]
  0267FC  1C0C: 8b46f4           mov ax, word ptr [bp - 0xc]
  0267FF  1C0F: 051700           add ax, 0x17
  026802  1C12: 50               push ax
  026803  1C13: 6a0a             push 0xa
  026805  1C15: 8b46f8           mov ax, word ptr [bp - 8]
  026808  1C18: 8bd8             mov bx, ax
  02680A  1C1A: 83c317           add bx, 0x17
  02680D  1C1D: 8b56f4           mov dx, word ptr [bp - 0xc]
  026810  1C20: 9ace001f18       lcall 0x181f, 0xce
  026815  1C25: 833e340300       cmp word ptr [0x334], 0
  02681A  1C2A: 7507             jne 0x1c33
  02681C  1C2C: 833eee0700       cmp word ptr [0x7ee], 0
  026821  1C31: 7407             je 0x1c3a
  026823  1C33: 833e2e0300       cmp word ptr [0x32e], 0
  026828  1C38: 742d             je 0x1c67
  02682A  1C3A: 833eee0700       cmp word ptr [0x7ee], 0
  02682F  1C3F: 7503             jne 0x1c44
  026831  1C41: e954ff           jmp 0x1b98
  026834  1C44: 833e548d00       cmp word ptr [0x8d54], 0
  026839  1C49: 7403             je 0x1c4e
  02683B  1C4B: e94aff           jmp 0x1b98
  02683E  1C4E: ff363203         push word ptr [0x332]
  026842  1C52: ff363003         push word ptr [0x330]
  026846  1C56: 9ae00c1f18       lcall 0x181f, 0xce0
  02684B  1C5B: 83c404           add sp, 4
  02684E  1C5E: 3a067e8d         cmp al, byte ptr [0x8d7e]
  026852  1C62: 7403             je 0x1c67
  026854  1C64: e931ff           jmp 0x1b98
  026857  1C67: a13003           mov ax, word ptr [0x330]
  02685A  1C6A: 3946ee           cmp word ptr [bp - 0x12], ax
  02685D  1C6D: 7403             je 0x1c72
  02685F  1C6F: e926ff           jmp 0x1b98
  026862  1C72: a13203           mov ax, word ptr [0x332]
  026865  1C75: 3946ec           cmp word ptr [bp - 0x14], ax
  026868  1C78: 7403             je 0x1c7d
  02686A  1C7A: e91bff           jmp 0x1b98
  02686D  1C7D: ff36ae2d         push word ptr [0x2dae]
  026871  1C81: ff36ac2d         push word ptr [0x2dac]
  026875  1C85: ff36aa2d         push word ptr [0x2daa]
  026879  1C89: ff36a82d         push word ptr [0x2da8]
  02687D  1C8D: 8b46f4           mov ax, word ptr [bp - 0xc]
  026880  1C90: 051700           add ax, 0x17
  026883  1C93: 50               push ax
  026884  1C94: 6a0f             push 0xf
  026886  1C96: 8b46f8           mov ax, word ptr [bp - 8]
  026889  1C99: 8bd8             mov bx, ax
  02688B  1C9B: 83c317           add bx, 0x17
  02688E  1C9E: 8b56f4           mov dx, word ptr [bp - 0xc]
  026891  1CA1: 9ace001f18       lcall 0x181f, 0xce
  026896  1CA6: e9effe           jmp 0x1b98
  026899  1CA9: 90               nop 
  02689A  1CAA: ff46ec           inc word ptr [bp - 0x14]
  02689D  1CAD: 837eec05         cmp word ptr [bp - 0x14], 5
  0268A1  1CB1: 7d09             jge 0x1cbc
  0268A3  1CB3: c746ee0000       mov word ptr [bp - 0x12], 0
  0268A8  1CB8: e9e0fe           jmp 0x1b9b
  0268AB  1CBB: 90               nop 
  0268AC  1CBC: c70670000000     mov word ptr [0x70], 0
  0268B2  1CC2: 837e0600         cmp word ptr [bp + 6], 0
  0268B6  1CC6: 7413             je 0x1cdb
  0268B8  1CC8: 6a08             push 8
  0268BA  1CCA: 6a78             push 0x78
  0268BC  1CCC: 6a78             push 0x78
  0268BE  1CCE: b8c800           mov ax, 0xc8
  0268C1  1CD1: ba0800           mov dx, 8
  0268C4  1CD4: 8bd8             mov bx, ax
  0268C6  1CD6: 9ae2001f18       lcall 0x181f, 0xe2
  0268CB  1CDB: 5e               pop si
  0268CC  1CDC: c9               leave 
  0268CD  1CDD: cb               retf 

; ---- func_0268CE  size=483  insns=174  prologue=ENTER 0x0054,0  terminal=RETF ----
  0268CE  1CDE: c8540000         enter 0x54, 0
  0268D2  1CE2: 56               push si
  0268D3  1CE3: 8b1e4285         mov bx, word ptr [0x8542]
  0268D7  1CE7: 807f1a04         cmp byte ptr [bx + 0x1a], 4
  0268DB  1CEB: 7311             jae 0x1cfe
  0268DD  1CED: 8a471a           mov al, byte ptr [bx + 0x1a]
  0268E0  1CF0: 2ae4             sub ah, ah
  0268E2  1CF2: 6bd834           imul bx, ax, 0x34
  0268E5  1CF5: 38a73f54         cmp byte ptr [bx + 0x543f], ah
  0268E9  1CF9: 7503             jne 0x1cfe
  0268EB  1CFB: e90a01           jmp 0x1e08
  0268EE  1CFE: 833e980b00       cmp word ptr [0xb98], 0
  0268F3  1D03: 7403             je 0x1d08
  0268F5  1D05: e90001           jmp 0x1e08
  0268F8  1D08: 803e280800       cmp byte ptr [0x828], 0
  0268FD  1D0D: 7403             je 0x1d12
  0268FF  1D0F: e9f600           jmp 0x1e08
  026902  1D12: c646b000         mov byte ptr [bp - 0x50], 0
  026906  1D16: 8b1e4285         mov bx, word ptr [0x8542]
  02690A  1D1A: 8a471b           mov al, byte ptr [bx + 0x1b]
  02690D  1D1D: 2ae4             sub ah, ah
  02690F  1D1F: 50               push ax
  026910  1D20: 8d46b0           lea ax, [bp - 0x50]
  026913  1D23: 16               push ss
  026914  1D24: 50               push ax
  026915  1D25: 9aa0011f18       lcall 0x181f, 0x1a0
  02691A  1D2A: 83c406           add sp, 6
  02691D  1D2D: 8d46b0           lea ax, [bp - 0x50]
  026920  1D30: 50               push ax
  026921  1D31: 9a78011f18       lcall 0x181f, 0x178
  026926  1D36: 83c402           add sp, 2
  026929  1D39: c746ac0000       mov word ptr [bp - 0x54], 0
  02692E  1D3E: eb29             jmp 0x1d69
  026930  1D40: 8b1e4285         mov bx, word ptr [0x8542]
  026934  1D44: 8b76ac           mov si, word ptr [bp - 0x54]
  026937  1D47: 8a808c00         mov al, byte ptr [bx + si + 0x8c]
  02693B  1D4B: 98               cwde 
  02693C  1D4C: 50               push ax
  02693D  1D4D: 8d46b0           lea ax, [bp - 0x50]
  026940  1D50: 16               push ss
  026941  1D51: 50               push ax
  026942  1D52: 9a82011f18       lcall 0x181f, 0x182
  026947  1D57: 83c406           add sp, 6
  02694A  1D5A: 8d46b0           lea ax, [bp - 0x50]
  02694D  1D5D: 50               push ax
  02694E  1D5E: 9a78011f18       lcall 0x181f, 0x178
  026953  1D63: 83c402           add sp, 2
  026956  1D66: ff46ac           inc word ptr [bp - 0x54]
  026959  1D69: 837eac04         cmp word ptr [bp - 0x54], 4
  02695D  1D6D: 7d25             jge 0x1d94
  02695F  1D6F: 837eac01         cmp word ptr [bp - 0x54], 1
  026963  1D73: 75cb             jne 0x1d40
  026965  1D75: 8b1e4285         mov bx, word ptr [0x8542]
  026969  1D79: 8a878d00         mov al, byte ptr [bx + 0x8d]
  02696D  1D7D: 98               cwde 
  02696E  1D7E: 8bd8             mov bx, ax
  026970  1D80: d1e3             shl bx, 1
  026972  1D82: ffb7c097         push word ptr [bx - 0x6840]
  026976  1D86: 8d46b0           lea ax, [bp - 0x50]
  026979  1D89: 50               push ax
  02697A  1D8A: 9a6e011f18       lcall 0x181f, 0x16e
  02697F  1D8F: 83c404           add sp, 4
  026982  1D92: ebc6             jmp 0x1d5a
  026984  1D94: ff36382e         push word ptr [0x2e38]
  026988  1D98: 8d46b0           lea ax, [bp - 0x50]
  02698B  1D9B: 50               push ax
  02698C  1D9C: 9a6e011f18       lcall 0x181f, 0x16e
  026991  1DA1: 83c404           add sp, 4
  026994  1DA4: 8d46b0           lea ax, [bp - 0x50]
  026997  1DA7: 50               push ax
  026998  1DA8: 9a78011f18       lcall 0x181f, 0x178
  02699D  1DAD: 83c402           add sp, 2
  0269A0  1DB0: 8b1e4285         mov bx, word ptr [0x8542]
  0269A4  1DB4: 8a4701           mov al, byte ptr [bx + 1]
  0269A7  1DB7: 2ae4             sub ah, ah
  0269A9  1DB9: 50               push ax
  0269AA  1DBA: 8a07             mov al, byte ptr [bx]
  0269AC  1DBC: 50               push ax
  0269AD  1DBD: 9a22071f18       lcall 0x181f, 0x722
  0269B2  1DC2: 83c404           add sp, 4
  0269B5  1DC5: 8946ae           mov word ptr [bp - 0x52], ax
  0269B8  1DC8: 50               push ax
  0269B9  1DC9: 8d4eb0           lea cx, [bp - 0x50]
  0269BC  1DCC: 16               push ss
  0269BD  1DCD: 51               push cx
  0269BE  1DCE: 9a82011f18       lcall 0x181f, 0x182
  0269C3  1DD3: 83c406           add sp, 6
  0269C6  1DD6: 8d46b0           lea ax, [bp - 0x50]
  0269C9  1DD9: 50               push ax
  0269CA  1DDA: 9abe011f18       lcall 0x181f, 0x1be
  0269CF  1DDF: 83c402           add sp, 2
  0269D2  1DE2: 8b76ae           mov si, word ptr [bp - 0x52]
  0269D5  1DE5: 8b1e4285         mov bx, word ptr [0x8542]
  0269D9  1DE9: 8a5f1a           mov bl, byte ptr [bx + 0x1a]
  0269DC  1DEC: 2aff             sub bh, bh
  0269DE  1DEE: c1e304           shl bx, 4
  0269E1  1DF1: 8a807098         mov al, byte ptr [bx + si - 0x6790]
  0269E5  1DF5: 2ae4             sub ah, ah
  0269E7  1DF7: 50               push ax
  0269E8  1DF8: 8d46b0           lea ax, [bp - 0x50]
  0269EB  1DFB: 16               push ss
  0269EC  1DFC: 50               push ax
  0269ED  1DFD: 9a82011f18       lcall 0x181f, 0x182
  0269F2  1E02: 83c406           add sp, 6
  0269F5  1E05: eb6a             jmp 0x1e71
  0269F7  1E07: 90               nop 
  0269F8  1E08: a14285           mov ax, word ptr [0x8542]
  0269FB  1E0B: 40               inc ax
  0269FC  1E0C: 40               inc ax
  0269FD  1E0D: 50               push ax
  0269FE  1E0E: 8d46b0           lea ax, [bp - 0x50]
  026A01  1E11: 50               push ax
  026A02  1E12: 9ae4071d0d       lcall 0xd1d, 0x7e4
  026A07  1E17: 83c404           add sp, 4
  026A0A  1E1A: 8d46b0           lea ax, [bp - 0x50]
  026A0D  1E1D: 50               push ax
  026A0E  1E1E: 9adc011f18       lcall 0x181f, 0x1dc
  026A13  1E23: 83c402           add sp, 2
  026A16  1E26: 8d46b0           lea ax, [bp - 0x50]
  026A19  1E29: 50               push ax
  026A1A  1E2A: 9a78011f18       lcall 0x181f, 0x178
  026A1F  1E2F: 83c402           add sp, 2
  026A22  1E32: 8b1e8c53         mov bx, word ptr [0x538c]
  026A26  1E36: d1e3             shl bx, 1
  026A28  1E38: ffb70098         push word ptr [bx - 0x6800]
  026A2C  1E3C: 8d46b0           lea ax, [bp - 0x50]
  026A2F  1E3F: 50               push ax
  026A30  1E40: 9a6e011f18       lcall 0x181f, 0x16e
  026A35  1E45: 83c404           add sp, 4
  026A38  1E48: 8d46b0           lea ax, [bp - 0x50]
  026A3B  1E4B: 50               push ax
  026A3C  1E4C: 9ab4011f18       lcall 0x181f, 0x1b4
  026A41  1E51: 83c402           add sp, 2
  026A44  1E54: ff368a53         push word ptr [0x538a]
  026A48  1E58: 8d46b0           lea ax, [bp - 0x50]
  026A4B  1E5B: 16               push ss
  026A4C  1E5C: 50               push ax
  026A4D  1E5D: 9a82011f18       lcall 0x181f, 0x182
  026A52  1E62: 83c406           add sp, 6
  026A55  1E65: 8d46b0           lea ax, [bp - 0x50]
  026A58  1E68: 50               push ax
  026A59  1E69: 9adc011f18       lcall 0x181f, 0x1dc
  026A5E  1E6E: 83c402           add sp, 2
  026A61  1E71: ff36a093         push word ptr [0x93a0]
  026A65  1E75: 9a22001f18       lcall 0x181f, 0x22
  026A6A  1E7A: 83c402           add sp, 2
  026A6D  1E7D: 52               push dx
  026A6E  1E7E: 50               push ax
  026A6F  1E7F: 8d46b0           lea ax, [bp - 0x50]
  026A72  1E82: 16               push ss
  026A73  1E83: 50               push ax
  026A74  1E84: 9ab4111d0d       lcall 0xd1d, 0x11b4
  026A79  1E89: 83c408           add sp, 8
  026A7C  1E8C: 8d46b0           lea ax, [bp - 0x50]
  026A7F  1E8F: 50               push ax
  026A80  1E90: 9a78011f18       lcall 0x181f, 0x178
  026A85  1E95: 83c402           add sp, 2
  026A88  1E98: 8d46b0           lea ax, [bp - 0x50]
  026A8B  1E9B: 50               push ax
  026A8C  1E9C: 8b1e4285         mov bx, word ptr [0x8542]
  026A90  1EA0: 8a471a           mov al, byte ptr [bx + 0x1a]
  026A93  1EA3: 2ae4             sub ah, ah
  026A95  1EA5: 50               push ax
  026A96  1EA6: 9a1e0b1f18       lcall 0x181f, 0xb1e
  026A9B  1EAB: 83c404           add sp, 4
  026A9E  1EAE: 8d46b0           lea ax, [bp - 0x50]
  026AA1  1EB1: 16               push ss
  026AA2  1EB2: 50               push ax
  026AA3  1EB3: ff7606           push word ptr [bp + 6]
  026AA6  1EB6: 9ab0001f18       lcall 0x181f, 0xb0
  026AAB  1EBB: 83c406           add sp, 6
  026AAE  1EBE: 5e               pop si
  026AAF  1EBF: c9               leave 
  026AB0  1EC0: cb               retf 

; ---- func_026AB2  size=282  insns=100  prologue=ENTER 0x0014,0  terminal=RETF ----
  026AB2  1EC2: c8140000         enter 0x14, 0
  026AB6  1EC6: c746fe0000       mov word ptr [bp - 2], 0
  026ABB  1ECB: c746f40300       mov word ptr [bp - 0xc], 3
  026AC0  1ED0: 8d4606           lea ax, [bp + 6]
  026AC3  1ED3: 50               push ax
  026AC4  1ED4: ff7608           push word ptr [bp + 8]
  026AC7  1ED7: a04b02           mov al, byte ptr [0x24b]
  026ACA  1EDA: 98               cwde 
  026ACB  1EDB: 50               push ax
  026ACC  1EDC: 50               push ax
  026ACD  1EDD: 8d46fa           lea ax, [bp - 6]
  026AD0  1EE0: 50               push ax
  026AD1  1EE1: 8d46f0           lea ax, [bp - 0x10]
  026AD4  1EE4: 50               push ax
  026AD5  1EE5: 6a02             push 2
  026AD7  1EE7: b86700           mov ax, 0x67
  026ADA  1EEA: 8b560a           mov dx, word ptr [bp + 0xa]
  026ADD  1EED: 8bda             mov bx, dx
  026ADF  1EEF: 9a40021f18       lcall 0x181f, 0x240
  026AE4  1EF4: 8946ee           mov word ptr [bp - 0x12], ax
  026AE7  1EF7: 8b1e4285         mov bx, word ptr [0x8542]
  026AEB  1EFB: 8a07             mov al, byte ptr [bx]
  026AED  1EFD: 2ae4             sub ah, ah
  026AEF  1EFF: 8a5701           mov dl, byte ptr [bx + 1]
  026AF2  1F02: 2af6             sub dh, dh
  026AF4  1F04: 9ae0071f18       lcall 0x181f, 0x7e0
  026AF9  1F09: eb60             jmp 0x1f6b
  026AFB  1F0B: 90               nop 
  026AFC  1F0C: a17c8d           mov ax, word ptr [0x8d7c]
  026AFF  1F0F: 8946fc           mov word ptr [bp - 4], ax
  026B02  1F12: 8b46f6           mov ax, word ptr [bp - 0xa]
  026B05  1F15: 3946fc           cmp word ptr [bp - 4], ax
  026B08  1F18: 7543             jne 0x1f5d
  026B0A  1F1A: ff36ae2d         push word ptr [0x2dae]
  026B0E  1F1E: ff36ac2d         push word ptr [0x2dac]
  026B12  1F22: ff36aa2d         push word ptr [0x2daa]
  026B16  1F26: ff36a82d         push word ptr [0x2da8]
  026B1A  1F2A: 8b5ef8           mov bx, word ptr [bp - 8]
  026B1D  1F2D: 8bc3             mov ax, bx
  026B1F  1F2F: d1e3             shl bx, 1
  026B21  1F31: 03d8             add bx, ax
  026B23  1F33: c1e302           shl bx, 2
  026B26  1F36: 031e3e08         add bx, word ptr [0x83e]
  026B2A  1F3A: 8e064008         mov es, word ptr [0x840]
  026B2E  1F3E: 268b4740         mov ax, word ptr es:[bx + 0x40]
  026B32  1F42: 034608           add ax, word ptr [bp + 8]
  026B35  1F45: 50               push ax
  026B36  1F46: 6a0a             push 0xa
  026B38  1F48: 8b4606           mov ax, word ptr [bp + 6]
  026B3B  1F4B: 268b5f3e         mov bx, word ptr es:[bx + 0x3e]
  026B3F  1F4F: 03d8             add bx, ax
  026B41  1F51: 48               dec ax
  026B42  1F52: 43               inc bx
  026B43  1F53: 43               inc bx
  026B44  1F54: 8b5608           mov dx, word ptr [bp + 8]
  026B47  1F57: 42               inc dx
  026B48  1F58: 9ace001f18       lcall 0x181f, 0xce
  026B4D  1F5D: 8b46ee           mov ax, word ptr [bp - 0x12]
  026B50  1F60: 014606           add word ptr [bp + 6], ax
  026B53  1F63: 8b46ec           mov ax, word ptr [bp - 0x14]
  026B56  1F66: 9ae4021f18       lcall 0x181f, 0x2e4
  026B5B  1F6B: 8946ec           mov word ptr [bp - 0x14], ax
  026B5E  1F6E: 0bc0             or ax, ax
  026B60  1F70: 7c68             jl 0x1fda
  026B62  1F72: 50               push ax
  026B63  1F73: 9a280b1f18       lcall 0x181f, 0xb28
  026B68  1F78: 83c402           add sp, 2
  026B6B  1F7B: 0bc0             or ax, ax
  026B6D  1F7D: 74e4             je 0x1f63
  026B6F  1F7F: a1728d           mov ax, word ptr [0x8d72]
  026B72  1F82: ff46fe           inc word ptr [bp - 2]
  026B75  1F85: 3946fe           cmp word ptr [bp - 2], ax
  026B78  1F88: 7fd9             jg 0x1f63
  026B7A  1F8A: ff76ec           push word ptr [bp - 0x14]
  026B7D  1F8D: 9a780b1f18       lcall 0x181f, 0xb78
  026B82  1F92: 83c402           add sp, 2
  026B85  1F95: 8946f2           mov word ptr [bp - 0xe], ax
  026B88  1F98: ff76ec           push word ptr [bp - 0x14]
  026B8B  1F9B: 9a4a0c1f18       lcall 0x181f, 0xc4a
  026B90  1FA0: 83c402           add sp, 2
  026B93  1FA3: 8946f6           mov word ptr [bp - 0xa], ax
  026B96  1FA6: 50               push ax
  026B97  1FA7: 9a740a1f18       lcall 0x181f, 0xa74
  026B9C  1FAC: 83c402           add sp, 2
  026B9F  1FAF: 8946f8           mov word ptr [bp - 8], ax
  026BA2  1FB2: 6a07             push 7
  026BA4  1FB4: 8b5606           mov dx, word ptr [bp + 6]
  026BA7  1FB7: 8b5e08           mov bx, word ptr [bp + 8]
  026BAA  1FBA: 9a4a021f18       lcall 0x181f, 0x24a
  026BAF  1FBF: 833eee0700       cmp word ptr [0x7ee], 0
  026BB4  1FC4: 7503             jne 0x1fc9
  026BB6  1FC6: e943ff           jmp 0x1f0c
  026BB9  1FC9: 833e548d00       cmp word ptr [0x8d54], 0
  026BBE  1FCE: 7403             je 0x1fd3
  026BC0  1FD0: e939ff           jmp 0x1f0c
  026BC3  1FD3: a17e8d           mov ax, word ptr [0x8d7e]
  026BC6  1FD6: e936ff           jmp 0x1f0f
  026BC9  1FD9: 90               nop 
  026BCA  1FDA: c9               leave 
  026BCB  1FDB: cb               retf 

; ---- func_026BCC  size=246  insns=89  prologue=ENTER 0x000E,0  terminal=RETF ----
  026BCC  1FDC: c80e0000         enter 0xe, 0
  026BD0  1FE0: ff7606           push word ptr [bp + 6]
  026BD3  1FE3: 9a820b1f18       lcall 0x181f, 0xb82
  026BD8  1FE8: 83c402           add sp, 2
  026BDB  1FEB: 8946fa           mov word ptr [bp - 6], ax
  026BDE  1FEE: 8d4608           lea ax, [bp + 8]
  026BE1  1FF1: 50               push ax
  026BE2  1FF2: ff760a           push word ptr [bp + 0xa]
  026BE5  1FF5: 8b5e0c           mov bx, word ptr [bp + 0xc]
  026BE8  1FF8: 8a874802         mov al, byte ptr [bx + 0x248]
  026BEC  1FFC: 98               cwde 
  026BED  1FFD: 50               push ax
  026BEE  1FFE: 50               push ax
  026BEF  1FFF: 8d46fc           lea ax, [bp - 4]
  026BF2  2002: 50               push ax
  026BF3  2003: 8d46f4           lea ax, [bp - 0xc]
  026BF6  2006: 50               push ax
  026BF7  2007: 6a02             push 2
  026BF9  2009: 8b4606           mov ax, word ptr [bp + 6]
  026BFC  200C: 055200           add ax, 0x52
  026BFF  200F: 8b56fa           mov dx, word ptr [bp - 6]
  026C02  2012: 8bda             mov bx, dx
  026C04  2014: 9a40021f18       lcall 0x181f, 0x240
  026C09  2019: 8946f2           mov word ptr [bp - 0xe], ax
  026C0C  201C: c746f60000       mov word ptr [bp - 0xa], 0
  026C11  2021: eb5a             jmp 0x207d
  026C13  2023: 90               nop 
  026C14  2024: a17c8d           mov ax, word ptr [0x8d7c]
  026C17  2027: 8946fe           mov word ptr [bp - 2], ax
  026C1A  202A: 3946f6           cmp word ptr [bp - 0xa], ax
  026C1D  202D: 7545             jne 0x2074
  026C1F  202F: ff36ae2d         push word ptr [0x2dae]
  026C23  2033: ff36ac2d         push word ptr [0x2dac]
  026C27  2037: ff36aa2d         push word ptr [0x2daa]
  026C2B  203B: ff36a82d         push word ptr [0x2da8]
  026C2F  203F: 8b5ef8           mov bx, word ptr [bp - 8]
  026C32  2042: 8bc3             mov ax, bx
  026C34  2044: d1e3             shl bx, 1
  026C36  2046: 03d8             add bx, ax
  026C38  2048: c1e302           shl bx, 2
  026C3B  204B: 031e3e08         add bx, word ptr [0x83e]
  026C3F  204F: 8e064008         mov es, word ptr [0x840]
  026C43  2053: 268b4740         mov ax, word ptr es:[bx + 0x40]
  026C47  2057: 03460a           add ax, word ptr [bp + 0xa]
  026C4A  205A: 40               inc ax
  026C4B  205B: 50               push ax
  026C4C  205C: 6a0a             push 0xa
  026C4E  205E: 8b4608           mov ax, word ptr [bp + 8]
  026C51  2061: 268b5f3e         mov bx, word ptr es:[bx + 0x3e]
  026C55  2065: 03d8             add bx, ax
  026C57  2067: 48               dec ax
  026C58  2068: 43               inc bx
  026C59  2069: 43               inc bx
  026C5A  206A: 8b560a           mov dx, word ptr [bp + 0xa]
  026C5D  206D: 42               inc dx
  026C5E  206E: 42               inc dx
  026C5F  206F: 9ace001f18       lcall 0x181f, 0xce
  026C64  2074: 8b46f2           mov ax, word ptr [bp - 0xe]
  026C67  2077: 014608           add word ptr [bp + 8], ax
  026C6A  207A: ff46f6           inc word ptr [bp - 0xa]
  026C6D  207D: 8b1e4285         mov bx, word ptr [0x8542]
  026C71  2081: 8a471f           mov al, byte ptr [bx + 0x1f]
  026C74  2084: 98               cwde 
  026C75  2085: 3b46f6           cmp ax, word ptr [bp - 0xa]
  026C78  2088: 7e46             jle 0x20d0
  026C7A  208A: ff76f6           push word ptr [bp - 0xa]
  026C7D  208D: 9a0e0c1f18       lcall 0x181f, 0xc0e
  026C82  2092: 83c402           add sp, 2
  026C85  2095: 3b4606           cmp ax, word ptr [bp + 6]
  026C88  2098: 75e0             jne 0x207a
  026C8A  209A: ff76f6           push word ptr [bp - 0xa]
  026C8D  209D: 9a740a1f18       lcall 0x181f, 0xa74
  026C92  20A2: 83c402           add sp, 2
  026C95  20A5: 8946f8           mov word ptr [bp - 8], ax
  026C98  20A8: 6a07             push 7
  026C9A  20AA: 8b5e0a           mov bx, word ptr [bp + 0xa]
  026C9D  20AD: 43               inc bx
  026C9E  20AE: 8b5608           mov dx, word ptr [bp + 8]
  026CA1  20B1: 9a4a021f18       lcall 0x181f, 0x24a
  026CA6  20B6: 833eee0700       cmp word ptr [0x7ee], 0
  026CAB  20BB: 7503             jne 0x20c0
  026CAD  20BD: e964ff           jmp 0x2024
  026CB0  20C0: 833e548d00       cmp word ptr [0x8d54], 0
  026CB5  20C5: 7403             je 0x20ca
  026CB7  20C7: e95aff           jmp 0x2024
  026CBA  20CA: a17e8d           mov ax, word ptr [0x8d7e]
  026CBD  20CD: e957ff           jmp 0x2027
  026CC0  20D0: c9               leave 
  026CC1  20D1: cb               retf 

; ---- func_026CC2  size=273  insns=94  prologue=ENTER 0x000C,0  terminal=RETF ----
  026CC2  20D2: c80c0000         enter 0xc, 0
  026CC6  20D6: c746faffff       mov word ptr [bp - 6], 0xffff
  026CCB  20DB: 2bc0             sub ax, ax
  026CCD  20DD: 8946fe           mov word ptr [bp - 2], ax
  026CD0  20E0: 8946fc           mov word ptr [bp - 4], ax
  026CD3  20E3: 8946f6           mov word ptr [bp - 0xa], ax
  026CD6  20E6: 837e0613         cmp word ptr [bp + 6], 0x13
  026CDA  20EA: 7406             je 0x20f2
  026CDC  20EC: 837e0614         cmp word ptr [bp + 6], 0x14
  026CE0  20F0: 7510             jne 0x2102
  026CE2  20F2: a092a8           mov al, byte ptr [0xa892]
  026CE5  20F5: 2ae4             sub ah, ah
  026CE7  20F7: 8946fe           mov word ptr [bp - 2], ax
  026CEA  20FA: c746fc3f00       mov word ptr [bp - 4], 0x3f
  026CEF  20FF: e9b200           jmp 0x21b4
  026CF2  2102: 837e0611         cmp word ptr [bp + 6], 0x11
  026CF6  2106: 750e             jne 0x2116
  026CF8  2108: a1d88d           mov ax, word ptr [0x8dd8]
  026CFB  210B: 8946fe           mov word ptr [bp - 2], ax
  026CFE  210E: c746fc1f00       mov word ptr [bp - 4], 0x1f
  026D03  2113: e99e00           jmp 0x21b4
  026D06  2116: ff7606           push word ptr [bp + 6]
  026D09  2119: 9ace0a1f18       lcall 0x181f, 0xace
  026D0E  211E: 83c402           add sp, 2
  026D11  2121: 8946f4           mov word ptr [bp - 0xc], ax
  026D14  2124: 0bc0             or ax, ax
  026D16  2126: 7d03             jge 0x212b
  026D18  2128: e98900           jmp 0x21b4
  026D1B  212B: ff7606           push word ptr [bp + 6]
  026D1E  212E: 9aaa0b1f18       lcall 0x181f, 0xbaa
  026D23  2133: 83c402           add sp, 2
  026D26  2136: 0bc0             or ax, ax
  026D28  2138: 7c7a             jl 0x21b4
  026D2A  213A: 8b46f4           mov ax, word ptr [bp - 0xc]
  026D2D  213D: eb33             jmp 0x2172
  026D2F  213F: 90               nop 
  026D30  2140: 8b46f4           mov ax, word ptr [bp - 0xc]
  026D33  2143: 8946fa           mov word ptr [bp - 6], ax
  026D36  2146: 051700           add ax, 0x17
  026D39  2149: 8946fc           mov word ptr [bp - 4], ax
  026D3C  214C: eb46             jmp 0x2194
  026D3E  214E: c746fa1000       mov word ptr [bp - 6], 0x10
  026D43  2153: c746fc3700       mov word ptr [bp - 4], 0x37
  026D48  2158: eb3a             jmp 0x2194
  026D4A  215A: c746fa1100       mov word ptr [bp - 6], 0x11
  026D4F  215F: c746fc3900       mov word ptr [bp - 4], 0x39
  026D54  2164: eb2e             jmp 0x2194
  026D56  2166: c746fa1200       mov word ptr [bp - 6], 0x12
  026D5B  216B: c746fc3f00       mov word ptr [bp - 4], 0x3f
  026D60  2170: eb22             jmp 0x2194
  026D62  2172: 2d0900           sub ax, 9
  026D65  2175: 3d0800           cmp ax, 8
  026D68  2178: 771a             ja 0x2194
  026D6A  217A: d1e0             shl ax, 1
  026D6C  217C: 93               xchg bx, ax
  026D6D  217D: 2effa77214       jmp word ptr cs:[bx + 0x1472]
  026D72  2182: 3014             xor byte ptr [si], dl
  026D74  2184: 3014             xor byte ptr [si], dl
  026D76  2186: 3014             xor byte ptr [si], dl
  026D78  2188: 3014             xor byte ptr [si], dl
  026D7A  218A: 3e1430           adc al, 0x30
  026D7D  218D: 1430             adc al, 0x30
  026D7F  218F: 144a             adc al, 0x4a
  026D81  2191: 1456             adc al, 0x56
  026D83  2193: 1483             adc al, 0x83
  026D85  2195: 7efa             jle 0x2191
  026D87  2197: 007e0c           add byte ptr [bp + 0xc], bh
  026D8A  219A: 8b5efa           mov bx, word ptr [bp - 6]
  026D8D  219D: d1e3             shl bx, 1
  026D8F  219F: 8b87c88d         mov ax, word ptr [bx - 0x7238]
  026D93  21A3: 8946fe           mov word ptr [bp - 2], ax
  026D96  21A6: 837ef411         cmp word ptr [bp - 0xc], 0x11
  026D9A  21AA: 7508             jne 0x21b4
  026D9C  21AC: a092a8           mov al, byte ptr [0xa892]
  026D9F  21AF: 2ae4             sub ah, ah
  026DA1  21B1: 2946fe           sub word ptr [bp - 2], ax
  026DA4  21B4: 837e0800         cmp word ptr [bp + 8], 0
  026DA8  21B8: 7408             je 0x21c2
  026DAA  21BA: 8b46fa           mov ax, word ptr [bp - 6]
  026DAD  21BD: 8b5e08           mov bx, word ptr [bp + 8]
  026DB0  21C0: 8907             mov word ptr [bx], ax
  026DB2  21C2: 837e0a00         cmp word ptr [bp + 0xa], 0
  026DB6  21C6: 7408             je 0x21d0
  026DB8  21C8: 8b46fc           mov ax, word ptr [bp - 4]
  026DBB  21CB: 8b5e0a           mov bx, word ptr [bp + 0xa]
  026DBE  21CE: 8907             mov word ptr [bx], ax
  026DC0  21D0: 837e0c00         cmp word ptr [bp + 0xc], 0
  026DC4  21D4: 7408             je 0x21de
  026DC6  21D6: 8b46f6           mov ax, word ptr [bp - 0xa]
  026DC9  21D9: 8b5e0c           mov bx, word ptr [bp + 0xc]
  026DCC  21DC: 8907             mov word ptr [bx], ax
  026DCE  21DE: 8b46fe           mov ax, word ptr [bp - 2]
  026DD1  21E1: c9               leave 
  026DD2  21E2: cb               retf 

; ---- func_026DD4  size=541  insns=193  prologue=ENTER 0x0062,0  terminal=RETF ----
  026DD4  21E4: c8620000         enter 0x62, 0
  026DD8  21E8: c746aa0000       mov word ptr [bp - 0x56], 0
  026DDD  21ED: a03603           mov al, byte ptr [0x336]
  026DE0  21F0: 2ae4             sub ah, ah
  026DE2  21F2: a37000           mov word ptr [0x70], ax
  026DE5  21F5: 8b4606           mov ax, word ptr [bp + 6]
  026DE8  21F8: 40               inc ax
  026DE9  21F9: 8946a8           mov word ptr [bp - 0x58], ax
  026DEC  21FC: 837e0600         cmp word ptr [bp + 6], 0
  026DF0  2200: 7513             jne 0x2215
  026DF2  2202: 6a00             push 0
  026DF4  2204: 9afc091f18       lcall 0x181f, 0x9fc
  026DF9  2209: 83c402           add sp, 2
  026DFC  220C: 0bc0             or ax, ax
  026DFE  220E: 7505             jne 0x2215
  026E00  2210: c746a81100       mov word ptr [bp - 0x58], 0x11
  026E05  2215: 837e060f         cmp word ptr [bp + 6], 0xf
  026E09  2219: 7406             je 0x2221
  026E0B  221B: 837e0611         cmp word ptr [bp + 6], 0x11
  026E0F  221F: 7528             jne 0x2249
  026E11  2221: 6a0f             push 0xf
  026E13  2223: 9afc091f18       lcall 0x181f, 0x9fc
  026E18  2228: 83c402           add sp, 2
  026E1B  222B: 0bc0             or ax, ax
  026E1D  222D: 7415             je 0x2244
  026E1F  222F: 6a11             push 0x11
  026E21  2231: 9afc091f18       lcall 0x181f, 0x9fc
  026E26  2236: 83c402           add sp, 2
  026E29  2239: 0bc0             or ax, ax
  026E2B  223B: 740c             je 0x2249
  026E2D  223D: c746a83000       mov word ptr [bp - 0x58], 0x30
  026E32  2242: eb05             jmp 0x2249
  026E34  2244: c746a82f00       mov word ptr [bp - 0x58], 0x2f
  026E39  2249: ff364408         push word ptr [0x844]
  026E3D  224D: ff364208         push word ptr [0x842]
  026E41  2251: ff760a           push word ptr [bp + 0xa]
  026E44  2254: 8b46a8           mov ax, word ptr [bp - 0x58]
  026E47  2257: 8d1ea82d         lea bx, [0x2da8]
  026E4B  225B: 8b5608           mov dx, word ptr [bp + 8]
  026E4E  225E: 9a54021f18       lcall 0x181f, 0x254
  026E53  2263: ff7606           push word ptr [bp + 6]
  026E56  2266: 9ace0a1f18       lcall 0x181f, 0xace
  026E5B  226B: 83c402           add sp, 2
  026E5E  226E: 8946a0           mov word ptr [bp - 0x60], ax
  026E61  2271: 837e060f         cmp word ptr [bp + 6], 0xf
  026E65  2275: 7513             jne 0x228a
  026E67  2277: 6a11             push 0x11
  026E69  2279: 9afc091f18       lcall 0x181f, 0x9fc
  026E6E  227E: 83c402           add sp, 2
  026E71  2281: 0bc0             or ax, ax
  026E73  2283: 7405             je 0x228a
  026E75  2285: c746061100       mov word ptr [bp + 6], 0x11
  026E7A  228A: 837ea000         cmp word ptr [bp - 0x60], 0
  026E7E  228E: 7d15             jge 0x22a5
  026E80  2290: 837e0613         cmp word ptr [bp + 6], 0x13
  026E84  2294: 740f             je 0x22a5
  026E86  2296: 837e0614         cmp word ptr [bp + 6], 0x14
  026E8A  229A: 7409             je 0x22a5
  026E8C  229C: 837e0611         cmp word ptr [bp + 6], 0x11
  026E90  22A0: 7403             je 0x22a5
  026E92  22A2: e9d000           jmp 0x2375
  026E95  22A5: ff7606           push word ptr [bp + 6]
  026E98  22A8: 9aaa0b1f18       lcall 0x181f, 0xbaa
  026E9D  22AD: 83c402           add sp, 2
  026EA0  22B0: 8946a6           mov word ptr [bp - 0x5a], ax
  026EA3  22B3: 8d46fe           lea ax, [bp - 2]
  026EA6  22B6: 50               push ax
  026EA7  22B7: 8d46a2           lea ax, [bp - 0x5e]
  026EAA  22BA: 50               push ax
  026EAB  22BB: 8d469e           lea ax, [bp - 0x62]
  026EAE  22BE: 50               push ax
  026EAF  22BF: ff7606           push word ptr [bp + 6]
  026EB2  22C2: 0e               push cs
  026EB3  22C3: e8905b           call 0x7e56
  026EB6  22C6: 83c408           add sp, 8
  026EB9  22C9: 8946fc           mov word ptr [bp - 4], ax
  026EBC  22CC: 837e0611         cmp word ptr [bp + 6], 0x11
  026EC0  22D0: 7505             jne 0x22d7
  026EC2  22D2: c746aa0900       mov word ptr [bp - 0x56], 9
  026EC7  22D7: 0bc0             or ax, ax
  026EC9  22D9: 7431             je 0x230c
  026ECB  22DB: 8b5e0c           mov bx, word ptr [bp + 0xc]
  026ECE  22DE: 8a874e02         mov al, byte ptr [bx + 0x24e]
  026ED2  22E2: 98               cwde 
  026ED3  22E3: 034608           add ax, word ptr [bp + 8]
  026ED6  22E6: 50               push ax
  026ED7  22E7: 8a875402         mov al, byte ptr [bx + 0x254]
  026EDB  22EB: 98               cwde 
  026EDC  22EC: 03460a           add ax, word ptr [bp + 0xa]
  026EDF  22EF: 0346aa           add ax, word ptr [bp - 0x56]
  026EE2  22F2: 50               push ax
  026EE3  22F3: 8a875a02         mov al, byte ptr [bx + 0x25a]
  026EE7  22F7: 98               cwde 
  026EE8  22F8: 50               push ax
  026EE9  22F9: 50               push ax
  026EEA  22FA: ff76fe           push word ptr [bp - 2]
  026EED  22FD: 6a00             push 0
  026EEF  22FF: 8b46a2           mov ax, word ptr [bp - 0x5e]
  026EF2  2302: 8b56fc           mov dx, word ptr [bp - 4]
  026EF5  2305: 8bda             mov bx, dx
  026EF7  2307: 9a36021f18       lcall 0x181f, 0x236
  026EFC  230C: 837ea600         cmp word ptr [bp - 0x5a], 0
  026F00  2310: 7463             je 0x2375
  026F02  2312: 7e30             jle 0x2344
  026F04  2314: ff7606           push word ptr [bp + 6]
  026F07  2317: 9a880a1f18       lcall 0x181f, 0xa88
  026F0C  231C: 83c402           add sp, 2
  026F0F  231F: ff760c           push word ptr [bp + 0xc]
  026F12  2322: 8b5e0c           mov bx, word ptr [bp + 0xc]
  026F15  2325: 8a874202         mov al, byte ptr [bx + 0x242]
  026F19  2329: 98               cwde 
  026F1A  232A: 03460a           add ax, word ptr [bp + 0xa]
  026F1D  232D: 50               push ax
  026F1E  232E: 8a873c02         mov al, byte ptr [bx + 0x23c]
  026F22  2332: 98               cwde 
  026F23  2333: 034608           add ax, word ptr [bp + 8]
  026F26  2336: 50               push ax
  026F27  2337: ff76a0           push word ptr [bp - 0x60]
  026F2A  233A: 0e               push cs
  026F2B  233B: e8275b           call 0x7e65
  026F2E  233E: 83c408           add sp, 8
  026F31  2341: eb32             jmp 0x2375
  026F33  2343: 90               nop 
  026F34  2344: ff7606           push word ptr [bp + 6]
  026F37  2347: 9a880a1f18       lcall 0x181f, 0xa88
  026F3C  234C: 83c402           add sp, 2
  026F3F  234F: 0bc0             or ax, ax
  026F41  2351: 7522             jne 0x2375
  026F43  2353: 8b46a6           mov ax, word ptr [bp - 0x5a]
  026F46  2356: f7d8             neg ax
  026F48  2358: 50               push ax
  026F49  2359: 8b5e0c           mov bx, word ptr [bp + 0xc]
  026F4C  235C: 8a874202         mov al, byte ptr [bx + 0x242]
  026F50  2360: 98               cwde 
  026F51  2361: 03460a           add ax, word ptr [bp + 0xa]
  026F54  2364: 50               push ax
  026F55  2365: 8a873c02         mov al, byte ptr [bx + 0x23c]
  026F59  2369: 98               cwde 
  026F5A  236A: 034608           add ax, word ptr [bp + 8]
  026F5D  236D: 50               push ax
  026F5E  236E: 0e               push cs
  026F5F  236F: e8535a           call 0x7dc5
  026F62  2372: 83c406           add sp, 6
  026F65  2375: 837e0611         cmp word ptr [bp + 6], 0x11
  026F69  2379: 7513             jne 0x238e
  026F6B  237B: 6a0f             push 0xf
  026F6D  237D: 9afc091f18       lcall 0x181f, 0x9fc
  026F72  2382: 83c402           add sp, 2
  026F75  2385: 0bc0             or ax, ax
  026F77  2387: 7405             je 0x238e
  026F79  2389: c746060f00       mov word ptr [bp + 6], 0xf
  026F7E  238E: c746a40000       mov word ptr [bp - 0x5c], 0
  026F83  2393: 837e060f         cmp word ptr [bp + 6], 0xf
  026F87  2397: 750d             jne 0x23a6
  026F89  2399: 8b1e4285         mov bx, word ptr [0x8542]
  026F8D  239D: 8a879500         mov al, byte ptr [bx + 0x95]
  026F91  23A1: 2ae4             sub ah, ah
  026F93  23A3: 8946a4           mov word ptr [bp - 0x5c], ax
  026F96  23A6: 837e061e         cmp word ptr [bp + 6], 0x1e
  026F9A  23AA: 750d             jne 0x23b9
  026F9C  23AC: 8b1e4285         mov bx, word ptr [0x8542]
  026FA0  23B0: 8a879600         mov al, byte ptr [bx + 0x96]
  026FA4  23B4: 2ae4             sub ah, ah
  026FA6  23B6: 8946a4           mov word ptr [bp - 0x5c], ax
  026FA9  23B9: 837ea401         cmp word ptr [bp - 0x5c], 1
  026FAD  23BD: 7e3a             jle 0x23f9
  026FAF  23BF: 6a0a             push 0xa
  026FB1  23C1: 8d46ac           lea ax, [bp - 0x54]
  026FB4  23C4: 50               push ax
  026FB5  23C5: ff76a4           push word ptr [bp - 0x5c]
  026FB8  23C8: 9afa081d0d       lcall 0xd1d, 0x8fa
  026FBD  23CD: 83c406           add sp, 6
  026FC0  23D0: 6a0f             push 0xf
  026FC2  23D2: 8b5e0c           mov bx, word ptr [bp + 0xc]
  026FC5  23D5: 8a873602         mov al, byte ptr [bx + 0x236]
  026FC9  23D9: d0f8             sar al, 1
  026FCB  23DB: 98               cwde 
  026FCC  23DC: 03460a           add ax, word ptr [bp + 0xa]
  026FCF  23DF: 2d0300           sub ax, 3
  026FD2  23E2: 50               push ax
  026FD3  23E3: 8a873002         mov al, byte ptr [bx + 0x230]
  026FD7  23E7: d0f8             sar al, 1
  026FD9  23E9: 98               cwde 
  026FDA  23EA: 034608           add ax, word ptr [bp + 8]
  026FDD  23ED: 48               dec ax
  026FDE  23EE: 50               push ax
  026FDF  23EF: 8d46ac           lea ax, [bp - 0x54]
  026FE2  23F2: 16               push ss
  026FE3  23F3: 50               push ax
  026FE4  23F4: 9a3c011f18       lcall 0x181f, 0x13c
  026FE9  23F9: c70670000000     mov word ptr [0x70], 0
  026FEF  23FF: c9               leave 
  026FF0  2400: cb               retf 

; ---- func_026FF2  size=41  insns=14  prologue=ENTER 0x0002,0  terminal=RETF ----
  026FF2  2402: c8020000         enter 2, 0
  026FF6  2406: 8b5e0a           mov bx, word ptr [bp + 0xa]
  026FF9  2409: 8a876002         mov al, byte ptr [bx + 0x260]
  026FFD  240D: 98               cwde 
  026FFE  240E: 0bc0             or ax, ax
  027000  2410: 7417             je 0x2429
  027002  2412: ff364408         push word ptr [0x844]
  027006  2416: ff364208         push word ptr [0x842]
  02700A  241A: ff7608           push word ptr [bp + 8]
  02700D  241D: 8d1ea82d         lea bx, [0x2da8]
  027011  2421: 8b5606           mov dx, word ptr [bp + 6]
  027014  2424: 9a54021f18       lcall 0x181f, 0x254
  027019  2429: c9               leave 
  02701A  242A: cb               retf 

; ---- func_02701C  size=180  insns=68  prologue=ENTER 0x000A,0  terminal=RETF ----
  02701C  242C: c80a0000         enter 0xa, 0
  027020  2430: 56               push si
  027021  2431: ff36ae2d         push word ptr [0x2dae]
  027025  2435: ff36ac2d         push word ptr [0x2dac]
  027029  2439: ff36aa2d         push word ptr [0x2daa]
  02702D  243D: ff36a82d         push word ptr [0x2da8]
  027031  2441: 688000           push 0x80
  027034  2444: 6a00             push 0
  027036  2446: b8ffff           mov ax, 0xffff
  027039  2449: ba0700           mov dx, 7
  02703C  244C: bbc700           mov bx, 0xc7
  02703F  244F: 9ace001f18       lcall 0x181f, 0xce
  027044  2454: 6a07             push 7
  027046  2456: 6a78             push 0x78
  027048  2458: 68c700           push 0xc7
  02704B  245B: 6a08             push 8
  02704D  245D: 6a00             push 0
  02704F  245F: ff36ae2d         push word ptr [0x2dae]
  027053  2463: ff36ac2d         push word ptr [0x2dac]
  027057  2467: ff36aa2d         push word ptr [0x2daa]
  02705B  246B: ff36a82d         push word ptr [0x2da8]
  02705F  246F: 9afc041f18       lcall 0x181f, 0x4fc
  027064  2474: 83c412           add sp, 0x12
  027067  2477: c746f80000       mov word ptr [bp - 8], 0
  02706C  247C: eb0d             jmp 0x248b
  02706E  247E: 52               push dx
  02706F  247F: 51               push cx
  027070  2480: 56               push si
  027071  2481: 0e               push cs
  027072  2482: e86c5a           call 0x7ef1
  027075  2485: 83c406           add sp, 6
  027078  2488: ff46f8           inc word ptr [bp - 8]
  02707B  248B: 837ef80f         cmp word ptr [bp - 8], 0xf
  02707F  248F: 7d33             jge 0x24c4
  027081  2491: 8b5ef8           mov bx, word ptr [bp - 8]
  027084  2494: c1e302           shl bx, 2
  027087  2497: 8b876602         mov ax, word ptr [bx + 0x266]
  02708B  249B: 8b8f6802         mov cx, word ptr [bx + 0x268]
  02708F  249F: 83c108           add cx, 8
  027092  24A2: 8b5ef8           mov bx, word ptr [bp - 8]
  027095  24A5: 8a97628d         mov dl, byte ptr [bx - 0x729e]
  027099  24A9: 2af6             sub dh, dh
  02709B  24AB: 8bf0             mov si, ax
  02709D  24AD: 8a87828e         mov al, byte ptr [bx - 0x717e]
  0270A1  24B1: 98               cwde 
  0270A2  24B2: 0bc0             or ax, ax
  0270A4  24B4: 7cc8             jl 0x247e
  0270A6  24B6: 52               push dx
  0270A7  24B7: 51               push cx
  0270A8  24B8: 56               push si
  0270A9  24B9: 50               push ax
  0270AA  24BA: 0e               push cs
  0270AB  24BB: e87559           call 0x7e33
  0270AE  24BE: 83c408           add sp, 8
  0270B1  24C1: ebc5             jmp 0x2488
  0270B3  24C3: 90               nop 
  0270B4  24C4: 837e0600         cmp word ptr [bp + 6], 0
  0270B8  24C8: 7413             je 0x24dd
  0270BA  24CA: 6a08             push 8
  0270BC  24CC: 68c700           push 0xc7
  0270BF  24CF: 6a78             push 0x78
  0270C1  24D1: 2bc0             sub ax, ax
  0270C3  24D3: ba0800           mov dx, 8
  0270C6  24D6: 2bdb             sub bx, bx
  0270C8  24D8: 9ae2001f18       lcall 0x181f, 0xe2
  0270CD  24DD: 5e               pop si
  0270CE  24DE: c9               leave 
  0270CF  24DF: cb               retf 

; ---- func_0270D0  size=1278  insns=432  prologue=ENTER 0x007E,0  terminal=RETF ----
  0270D0  24E0: c87e0000         enter 0x7e, 0
  0270D4  24E4: 57               push di
  0270D5  24E5: 56               push si
  0270D6  24E6: 6a30             push 0x30
  0270D8  24E8: 6a78             push 0x78
  0270DA  24EA: 688200           push 0x82
  0270DD  24ED: 6a00             push 0
  0270DF  24EF: 0e               push cs
  0270E0  24F0: e8e059           call 0x7ed3
  0270E3  24F3: 83c408           add sp, 8
  0270E6  24F6: 8b1e4285         mov bx, word ptr [0x8542]
  0270EA  24FA: 8a471f           mov al, byte ptr [bx + 0x1f]
  0270ED  24FD: 98               cwde 
  0270EE  24FE: 0306728d         add ax, word ptr [0x8d72]
  0270F2  2502: 894698           mov word ptr [bp - 0x68], ax
  0270F5  2505: c746a40100       mov word ptr [bp - 0x5c], 1
  0270FA  250A: c746a08f00       mov word ptr [bp - 0x60], 0x8f
  0270FF  250F: 2bc0             sub ax, ax
  027101  2511: 894682           mov word ptr [bp - 0x7e], ax
  027104  2514: 894692           mov word ptr [bp - 0x6e], ax
  027107  2517: eb32             jmp 0x254b
  027109  2519: 90               nop 
  02710A  251A: 50               push ax
  02710B  251B: 9a0e0c1f18       lcall 0x181f, 0xc0e
  027110  2520: 83c402           add sp, 2
  027113  2523: 89468e           mov word ptr [bp - 0x72], ax
  027116  2526: ff7692           push word ptr [bp - 0x6e]
  027119  2529: 9a740a1f18       lcall 0x181f, 0xa74
  02711E  252E: 83c402           add sp, 2
  027121  2531: 89469a           mov word ptr [bp - 0x66], ax
  027124  2534: 8bf0             mov si, ax
  027126  2536: d1e6             shl si, 1
  027128  2538: 03f0             add si, ax
  02712A  253A: c1e602           shl si, 2
  02712D  253D: c41e3e08         les bx, ptr [0x83e]
  027131  2541: 268b403e         mov ax, word ptr es:[bx + si + 0x3e]
  027135  2545: 014682           add word ptr [bp - 0x7e], ax
  027138  2548: ff4692           inc word ptr [bp - 0x6e]
  02713B  254B: 8b4692           mov ax, word ptr [bp - 0x6e]
  02713E  254E: 394698           cmp word ptr [bp - 0x68], ax
  027141  2551: 7fc7             jg 0x251a
  027143  2553: c60690a802       mov byte ptr [0xa890], 2
  027148  2558: c746a60400       mov word ptr [bp - 0x5a], 4
  02714D  255D: 833e728d00       cmp word ptr [0x8d72], 0
  027152  2562: 750c             jne 0x2570
  027154  2564: c746a60000       mov word ptr [bp - 0x5a], 0
  027159  2569: eb05             jmp 0x2570
  02715B  256B: 90               nop 
  02715C  256C: fe0e90a8         dec byte ptr [0xa890]
  027160  2570: a090a8           mov al, byte ptr [0xa890]
  027163  2573: 98               cwde 
  027164  2574: 8b4e98           mov cx, word ptr [bp - 0x68]
  027167  2577: 49               dec cx
  027168  2578: f7e9             imul cx
  02716A  257A: 0346a6           add ax, word ptr [bp - 0x5a]
  02716D  257D: 034682           add ax, word ptr [bp - 0x7e]
  027170  2580: 3d6000           cmp ax, 0x60
  027173  2583: 7de7             jge 0x256c
  027175  2585: ff46a4           inc word ptr [bp - 0x5c]
  027178  2588: ff4ea0           dec word ptr [bp - 0x60]
  02717B  258B: 2bc0             sub ax, ax
  02717D  258D: 8946ac           mov word ptr [bp - 0x54], ax
  027180  2590: 894692           mov word ptr [bp - 0x6e], ax
  027183  2593: e92d01           jmp 0x26c3
  027186  2596: c7469c0a00       mov word ptr [bp - 0x64], 0xa
  02718B  259B: 833e2e0301       cmp word ptr [0x32e], 1
  027190  25A0: 750e             jne 0x25b0
  027192  25A2: 833e340300       cmp word ptr [0x334], 0
  027197  25A7: 7507             jne 0x25b0
  027199  25A9: 833ef60700       cmp word ptr [0x7f6], 0
  02719E  25AE: 7451             je 0x2601
  0271A0  25B0: 833eee0700       cmp word ptr [0x7ee], 0
  0271A5  25B5: 7407             je 0x25be
  0271A7  25B7: 833e548d00       cmp word ptr [0x8d54], 0
  0271AC  25BC: 7443             je 0x2601
  0271AE  25BE: ff36ae2d         push word ptr [0x2dae]
  0271B2  25C2: ff36ac2d         push word ptr [0x2dac]
  0271B6  25C6: ff36aa2d         push word ptr [0x2daa]
  0271BA  25CA: ff36a82d         push word ptr [0x2da8]
  0271BE  25CE: 8b5e9a           mov bx, word ptr [bp - 0x66]
  0271C1  25D1: 8bc3             mov ax, bx
  0271C3  25D3: d1e3             shl bx, 1
  0271C5  25D5: 03d8             add bx, ax
  0271C7  25D7: c1e302           shl bx, 2
  0271CA  25DA: 031e3e08         add bx, word ptr [0x83e]
  0271CE  25DE: 8e064008         mov es, word ptr [0x840]
  0271D2  25E2: 268b4740         mov ax, word ptr es:[bx + 0x40]
  0271D6  25E6: 0346a0           add ax, word ptr [bp - 0x60]
  0271D9  25E9: 50               push ax
  0271DA  25EA: 8a469c           mov al, byte ptr [bp - 0x64]
  0271DD  25ED: 50               push ax
  0271DE  25EE: 8b46a4           mov ax, word ptr [bp - 0x5c]
  0271E1  25F1: 268b5f3e         mov bx, word ptr es:[bx + 0x3e]
  0271E5  25F5: 03d8             add bx, ax
  0271E7  25F7: 48               dec ax
  0271E8  25F8: 8b56a0           mov dx, word ptr [bp - 0x60]
  0271EB  25FB: 42               inc dx
  0271EC  25FC: 9ace001f18       lcall 0x181f, 0xce
  0271F1  2601: 8b4692           mov ax, word ptr [bp - 0x6e]
  0271F4  2604: 39067e8d         cmp word ptr [0x8d7e], ax
  0271F8  2608: 7556             jne 0x2660
  0271FA  260A: 833eee0700       cmp word ptr [0x7ee], 0
  0271FF  260F: 744f             je 0x2660
  027201  2611: 833e2e0301       cmp word ptr [0x32e], 1
  027206  2616: 7548             jne 0x2660
  027208  2618: 833e548d00       cmp word ptr [0x8d54], 0
  02720D  261D: 7541             jne 0x2660
  02720F  261F: ff36ae2d         push word ptr [0x2dae]
  027213  2623: ff36ac2d         push word ptr [0x2dac]
  027217  2627: ff36aa2d         push word ptr [0x2daa]
  02721B  262B: ff36a82d         push word ptr [0x2da8]
  02721F  262F: 8b5e9a           mov bx, word ptr [bp - 0x66]
  027222  2632: 8bc3             mov ax, bx
  027224  2634: d1e3             shl bx, 1
  027226  2636: 03d8             add bx, ax
  027228  2638: c1e302           shl bx, 2
  02722B  263B: 031e3e08         add bx, word ptr [0x83e]
  02722F  263F: 8e064008         mov es, word ptr [0x840]
  027233  2643: 268b4740         mov ax, word ptr es:[bx + 0x40]
  027237  2647: 0346a0           add ax, word ptr [bp - 0x60]
  02723A  264A: 50               push ax
  02723B  264B: 6a0f             push 0xf
  02723D  264D: 8b46a4           mov ax, word ptr [bp - 0x5c]
  027240  2650: 268b5f3e         mov bx, word ptr es:[bx + 0x3e]
  027244  2654: 03d8             add bx, ax
  027246  2656: 48               dec ax
  027247  2657: 8b56a0           mov dx, word ptr [bp - 0x60]
  02724A  265A: 42               inc dx
  02724B  265B: 9ace001f18       lcall 0x181f, 0xce
  027250  2660: a090a8           mov al, byte ptr [0xa890]
  027253  2663: 98               cwde 
  027254  2664: 8b769a           mov si, word ptr [bp - 0x66]
  027257  2667: 8bce             mov cx, si
  027259  2669: d1e6             shl si, 1
  02725B  266B: 03f1             add si, cx
  02725D  266D: c1e602           shl si, 2
  027260  2670: c41e3e08         les bx, ptr [0x83e]
  027264  2674: 2603403e         add ax, word ptr es:[bx + si + 0x3e]
  027268  2678: 894696           mov word ptr [bp - 0x6a], ax
  02726B  267B: 3d0100           cmp ax, 1
  02726E  267E: 7d06             jge 0x2686
  027270  2680: 48               dec ax
  027271  2681: f7d8             neg ax
  027273  2683: 0146ac           add word ptr [bp - 0x54], ax
  027276  2686: 8b4696           mov ax, word ptr [bp - 0x6a]
  027279  2689: 3d0100           cmp ax, 1
  02727C  268C: 7d03             jge 0x2691
  02727E  268E: b80100           mov ax, 1
  027281  2691: 894696           mov word ptr [bp - 0x6a], ax
  027284  2694: eb0c             jmp 0x26a2
  027286  2696: 837eac00         cmp word ptr [bp - 0x54], 0
  02728A  269A: 7e0c             jle 0x26a8
  02728C  269C: ff4e96           dec word ptr [bp - 0x6a]
  02728F  269F: ff4eac           dec word ptr [bp - 0x54]
  027292  26A2: 837e9601         cmp word ptr [bp - 0x6a], 1
  027296  26A6: 7fee             jg 0x2696
  027298  26A8: 8b4696           mov ax, word ptr [bp - 0x6a]
  02729B  26AB: 0146a4           add word ptr [bp - 0x5c], ax
  02729E  26AE: 8b1e4285         mov bx, word ptr [0x8542]
  0272A2  26B2: 8a471f           mov al, byte ptr [bx + 0x1f]
  0272A5  26B5: 98               cwde 
  0272A6  26B6: 2b4692           sub ax, word ptr [bp - 0x6e]
  0272A9  26B9: 48               dec ax
  0272AA  26BA: 7504             jne 0x26c0
  0272AC  26BC: 8346a404         add word ptr [bp - 0x5c], 4
  0272B0  26C0: ff4692           inc word ptr [bp - 0x6e]
  0272B3  26C3: 8b4692           mov ax, word ptr [bp - 0x6e]
  0272B6  26C6: 394698           cmp word ptr [bp - 0x68], ax
  0272B9  26C9: 7e63             jle 0x272e
  0272BB  26CB: 50               push ax
  0272BC  26CC: 9a0e0c1f18       lcall 0x181f, 0xc0e
  0272C1  26D1: 83c402           add sp, 2
  0272C4  26D4: 89468e           mov word ptr [bp - 0x72], ax
  0272C7  26D7: ff7692           push word ptr [bp - 0x6e]
  0272CA  26DA: 9a740a1f18       lcall 0x181f, 0xa74
  0272CF  26DF: 83c402           add sp, 2
  0272D2  26E2: 89469a           mov word ptr [bp - 0x66], ax
  0272D5  26E5: ff364008         push word ptr [0x840]
  0272D9  26E9: ff363e08         push word ptr [0x83e]
  0272DD  26ED: ff76a0           push word ptr [bp - 0x60]
  0272E0  26F0: 8d1ea82d         lea bx, [0x2da8]
  0272E4  26F4: 8b56a4           mov dx, word ptr [bp - 0x5c]
  0272E7  26F7: 9a54021f18       lcall 0x181f, 0x254
  0272EC  26FC: 833e980b00       cmp word ptr [0xb98], 0
  0272F1  2701: 7403             je 0x2706
  0272F3  2703: e95aff           jmp 0x2660
  0272F6  2706: 8b4692           mov ax, word ptr [bp - 0x6e]
  0272F9  2709: 39067c8d         cmp word ptr [0x8d7c], ax
  0272FD  270D: 7403             je 0x2712
  0272FF  270F: e9effe           jmp 0x2601
  027302  2712: 833e2e0301       cmp word ptr [0x32e], 1
  027307  2717: 7403             je 0x271c
  027309  2719: e97afe           jmp 0x2596
  02730C  271C: 833eee0700       cmp word ptr [0x7ee], 0
  027311  2721: 7403             je 0x2726
  027313  2723: e970fe           jmp 0x2596
  027316  2726: c7469c0f00       mov word ptr [bp - 0x64], 0xf
  02731B  272B: e96dfe           jmp 0x259b
  02731E  272E: a03603           mov al, byte ptr [0x336]
  027321  2731: 2ae4             sub ah, ah
  027323  2733: a37000           mov word ptr [0x70], ax
  027326  2736: c746a0a300       mov word ptr [bp - 0x60], 0xa3
  02732B  273B: 9a18021f18       lcall 0x181f, 0x218
  027330  2740: 833e328e00       cmp word ptr [0x8e32], 0
  027335  2745: 7541             jne 0x2788
  027337  2747: a095a8           mov al, byte ptr [0xa895]
  02733A  274A: 2ae4             sub ah, ah
  02733C  274C: 8bc8             mov cx, ax
  02733E  274E: 3b060a8e         cmp ax, word ptr [0x8e0a]
  027342  2752: 7e03             jle 0x2757
  027344  2754: a10a8e           mov ax, word ptr [0x8e0a]
  027347  2757: 8946fe           mov word ptr [bp - 2], ax
  02734A  275A: 2bc8             sub cx, ax
  02734C  275C: 7902             jns 0x2760
  02734E  275E: 2bc9             sub cx, cx
  027350  2760: 894ea8           mov word ptr [bp - 0x58], cx
  027353  2763: 8b1e0a8e         mov bx, word ptr [0x8e0a]
  027357  2767: 8bd3             mov dx, bx
  027359  2769: 2bd8             sub bx, ax
  02735B  276B: b81740           mov ax, 0x4017
  02735E  276E: 9a22021f18       lcall 0x181f, 0x222
  027363  2773: 8b16c88d         mov dx, word ptr [0x8dc8]
  027367  2777: 2b160a8e         sub dx, word ptr [0x8e0a]
  02736B  277B: 8956aa           mov word ptr [bp - 0x56], dx
  02736E  277E: 8bda             mov bx, dx
  027370  2780: 2b5ea8           sub bx, word ptr [bp - 0x58]
  027373  2783: b81740           mov ax, 0x4017
  027376  2786: eb25             jmp 0x27ad
  027378  2788: 8b16c88d         mov dx, word ptr [0x8dc8]
  02737C  278C: 8bda             mov bx, dx
  02737E  278E: a095a8           mov al, byte ptr [0xa895]
  027381  2791: 2ae4             sub ah, ah
  027383  2793: 2bd8             sub bx, ax
  027385  2795: b81740           mov ax, 0x4017
  027388  2798: 9a22021f18       lcall 0x181f, 0x222
  02738D  279D: 833e328e00       cmp word ptr [0x8e32], 0
  027392  27A2: 740e             je 0x27b2
  027394  27A4: b81780           mov ax, 0x8017
  027397  27A7: 8b16328e         mov dx, word ptr [0x8e32]
  02739B  27AB: 2bdb             sub bx, bx
  02739D  27AD: 9a22021f18       lcall 0x181f, 0x222
  0273A2  27B2: 833eea8d00       cmp word ptr [0x8dea], 0
  0273A7  27B7: 740e             je 0x27c7
  0273A9  27B9: 8b16ea8d         mov dx, word ptr [0x8dea]
  0273AD  27BD: b83900           mov ax, 0x39
  0273B0  27C0: 2bdb             sub bx, bx
  0273B2  27C2: 9a22021f18       lcall 0x181f, 0x222
  0273B7  27C7: 833eec8d00       cmp word ptr [0x8dec], 0
  0273BC  27CC: 740e             je 0x27dc
  0273BE  27CE: 8b16ec8d         mov dx, word ptr [0x8dec]
  0273C2  27D2: b83f00           mov ax, 0x3f
  0273C5  27D5: 2bdb             sub bx, bx
  0273C7  27D7: 9a22021f18       lcall 0x181f, 0x222
  0273CC  27DC: 6a04             push 4
  0273CE  27DE: b80200           mov ax, 2
  0273D1  27E1: 8b56a0           mov dx, word ptr [bp - 0x60]
  0273D4  27E4: bb7600           mov bx, 0x76
  0273D7  27E7: 9a2c021f18       lcall 0x181f, 0x22c
  0273DC  27EC: 9a860c1f18       lcall 0x181f, 0xc86
  0273E1  27F1: 894690           mov word ptr [bp - 0x70], ax
  0273E4  27F4: 2d6400           sub ax, 0x64
  0273E7  27F7: f7d8             neg ax
  0273E9  27F9: 894686           mov word ptr [bp - 0x7a], ax
  0273EC  27FC: 8b1e4285         mov bx, word ptr [0x8542]
  0273F0  2800: 8bc8             mov cx, ax
  0273F2  2802: 8a471f           mov al, byte ptr [bx + 0x1f]
  0273F5  2805: 98               cwde 
  0273F6  2806: 8bf0             mov si, ax
  0273F8  2808: 8bd6             mov dx, si
  0273FA  280A: 8bc1             mov ax, cx
  0273FC  280C: 8bca             mov cx, dx
  0273FE  280E: f7e9             imul cx
  027400  2810: 053200           add ax, 0x32
  027403  2813: bf6400           mov di, 0x64
  027406  2816: 99               cdq 
  027407  2817: f7ff             idiv di
  027409  2819: 8946a2           mov word ptr [bp - 0x5e], ax
  02740C  281C: 2bc8             sub cx, ax
  02740E  281E: 894e88           mov word ptr [bp - 0x78], cx
  027411  2821: c746a08400       mov word ptr [bp - 0x60], 0x84
  027416  2826: a0a653           mov al, byte ptr [0x53a6]
  027419  2829: 2ae4             sub ah, ah
  02741B  282B: 2d0a00           sub ax, 0xa
  02741E  282E: f7d8             neg ax
  027420  2830: 89469e           mov word ptr [bp - 0x62], ax
  027423  2833: 807f1a04         cmp byte ptr [bx + 0x1a], 4
  027427  2837: 730e             jae 0x2847
  027429  2839: 8a471a           mov al, byte ptr [bx + 0x1a]
  02742C  283C: 2ae4             sub ah, ah
  02742E  283E: 6bd834           imul bx, ax, 0x34
  027431  2841: 38a73f54         cmp byte ptr [bx + 0x543f], ah
  027435  2845: 7405             je 0x284c
  027437  2847: c7469e3200       mov word ptr [bp - 0x62], 0x32
  02743C  284C: c746840f00       mov word ptr [bp - 0x7c], 0xf
  027441  2851: 8b46a2           mov ax, word ptr [bp - 0x5e]
  027444  2854: 39469e           cmp word ptr [bp - 0x62], ax
  027447  2857: 7f05             jg 0x285e
  027449  2859: c746840400       mov word ptr [bp - 0x7c], 4
  02744E  285E: 8b469e           mov ax, word ptr [bp - 0x62]
  027451  2861: d1e0             shl ax, 1
  027453  2863: 3b46a2           cmp ax, word ptr [bp - 0x5e]
  027456  2866: 7f05             jg 0x286d
  027458  2868: c746840c00       mov word ptr [bp - 0x7c], 0xc
  02745D  286D: 837e9000         cmp word ptr [bp - 0x70], 0
  027461  2871: 7503             jne 0x2876
  027463  2873: e99100           jmp 0x2907
  027466  2876: ff364008         push word ptr [0x840]
  02746A  287A: ff363e08         push word ptr [0x83e]
  02746E  287E: ff76a0           push word ptr [bp - 0x60]
  027471  2881: b87c00           mov ax, 0x7c
  027474  2884: 8d1ea82d         lea bx, [0x2da8]
  027478  2888: ba0200           mov dx, 2
  02747B  288B: 9a54021f18       lcall 0x181f, 0x254
  027480  2890: c41e3e08         les bx, ptr [0x83e]
  027484  2894: 268b870e06       mov ax, word ptr es:[bx + 0x60e]
  027489  2899: 40               inc ax
  02748A  289A: 40               inc ax
  02748B  289B: 8946a4           mov word ptr [bp - 0x5c], ax
  02748E  289E: 6a0a             push 0xa
  027490  28A0: 8d46ae           lea ax, [bp - 0x52]
  027493  28A3: 50               push ax
  027494  28A4: ff7690           push word ptr [bp - 0x70]
  027497  28A7: 9afa081d0d       lcall 0xd1d, 0x8fa
  02749C  28AC: 83c406           add sp, 6
  02749F  28AF: 8d46ae           lea ax, [bp - 0x52]
  0274A2  28B2: 50               push ax
  0274A3  28B3: 9a0a011f18       lcall 0x181f, 0x10a
  0274A8  28B8: 83c402           add sp, 2
  0274AB  28BB: 8d46ae           lea ax, [bp - 0x52]
  0274AE  28BE: 50               push ax
  0274AF  28BF: 9a78011f18       lcall 0x181f, 0x178
  0274B4  28C4: 83c402           add sp, 2
  0274B7  28C7: 8d46ae           lea ax, [bp - 0x52]
  0274BA  28CA: 50               push ax
  0274BB  28CB: 9a1e011f18       lcall 0x181f, 0x11e
  0274C0  28D0: 83c402           add sp, 2
  0274C3  28D3: ff7688           push word ptr [bp - 0x78]
  0274C6  28D6: 8d46ae           lea ax, [bp - 0x52]
  0274C9  28D9: 16               push ss
  0274CA  28DA: 50               push ax
  0274CB  28DB: 9a82011f18       lcall 0x181f, 0x182
  0274D0  28E0: 83c406           add sp, 6
  0274D3  28E3: 8d46ae           lea ax, [bp - 0x52]
  0274D6  28E6: 50               push ax
  0274D7  28E7: 9a28011f18       lcall 0x181f, 0x128
  0274DC  28EC: 83c402           add sp, 2
  0274DF  28EF: ff7684           push word ptr [bp - 0x7c]
  0274E2  28F2: 8b46a0           mov ax, word ptr [bp - 0x60]
  0274E5  28F5: 40               inc ax
  0274E6  28F6: 50               push ax
  0274E7  28F7: ff76a4           push word ptr [bp - 0x5c]
  0274EA  28FA: 8d46ae           lea ax, [bp - 0x52]
  0274ED  28FD: 16               push ss
  0274EE  28FE: 50               push ax
  0274EF  28FF: 9a3c011f18       lcall 0x181f, 0x13c
  0274F4  2904: 83c40a           add sp, 0xa
  0274F7  2907: 837e8600         cmp word ptr [bp - 0x7a], 0
  0274FB  290B: 7503             jne 0x2910
  0274FD  290D: e9ab00           jmp 0x29bb
  027500  2910: 6a0a             push 0xa
  027502  2912: 8d46ae           lea ax, [bp - 0x52]
  027505  2915: 50               push ax
  027506  2916: ff7686           push word ptr [bp - 0x7a]
  027509  2919: 9afa081d0d       lcall 0xd1d, 0x8fa
  02750E  291E: 83c406           add sp, 6
  027511  2921: 8d46ae           lea ax, [bp - 0x52]
  027514  2924: 50               push ax
  027515  2925: 9a0a011f18       lcall 0x181f, 0x10a
  02751A  292A: 83c402           add sp, 2
  02751D  292D: 8d46ae           lea ax, [bp - 0x52]
  027520  2930: 50               push ax
  027521  2931: 9a78011f18       lcall 0x181f, 0x178
  027526  2936: 83c402           add sp, 2
  027529  2939: 8d46ae           lea ax, [bp - 0x52]
  02752C  293C: 50               push ax
  02752D  293D: 9a1e011f18       lcall 0x181f, 0x11e
  027532  2942: 83c402           add sp, 2
  027535  2945: ff76a2           push word ptr [bp - 0x5e]
  027538  2948: 8d46ae           lea ax, [bp - 0x52]
  02753B  294B: 16               push ss
  02753C  294C: 50               push ax
  02753D  294D: 9a82011f18       lcall 0x181f, 0x182
  027542  2952: 83c406           add sp, 6
  027545  2955: 8d46ae           lea ax, [bp - 0x52]
  027548  2958: 50               push ax
  027549  2959: 9a28011f18       lcall 0x181f, 0x128
  02754E  295E: 83c402           add sp, 2
  027551  2961: b87500           mov ax, 0x75
  027554  2964: c41e3e08         les bx, ptr [0x83e]
  027558  2968: 262b871a06       sub ax, word ptr es:[bx + 0x61a]
  02755D  296D: 8946a4           mov word ptr [bp - 0x5c], ax
  027560  2970: ff7684           push word ptr [bp - 0x7c]
  027563  2973: 8b4ea0           mov cx, word ptr [bp - 0x60]
  027566  2976: 41               inc cx
  027567  2977: 51               push cx
  027568  2978: ff36a008         push word ptr [0x8a0]
  02756C  297C: ff369e08         push word ptr [0x89e]
  027570  2980: 8d4eae           lea cx, [bp - 0x52]
  027573  2983: 16               push ss
  027574  2984: 51               push cx
  027575  2985: 8bf0             mov si, ax
  027577  2987: 2bc0             sub ax, ax
  027579  2989: 9a04021f18       lcall 0x181f, 0x204
  02757E  298E: 2bf0             sub si, ax
  027580  2990: 89768c           mov word ptr [bp - 0x74], si
  027583  2993: 56               push si
  027584  2994: 8d46ae           lea ax, [bp - 0x52]
  027587  2997: 16               push ss
  027588  2998: 50               push ax
  027589  2999: 9a3c011f18       lcall 0x181f, 0x13c
  02758E  299E: 83c40a           add sp, 0xa
  027591  29A1: ff364008         push word ptr [0x840]
  027595  29A5: ff363e08         push word ptr [0x83e]
  027599  29A9: ff76a0           push word ptr [bp - 0x60]
  02759C  29AC: b87d00           mov ax, 0x7d
  02759F  29AF: 8d1ea82d         lea bx, [0x2da8]
  0275A3  29B3: 8b56a4           mov dx, word ptr [bp - 0x5c]
  0275A6  29B6: 9a54021f18       lcall 0x181f, 0x254
  0275AB  29BB: c70670000000     mov word ptr [0x70], 0
  0275B1  29C1: 837e0600         cmp word ptr [bp + 6], 0
  0275B5  29C5: 7413             je 0x29da
  0275B7  29C7: 688200           push 0x82
  0275BA  29CA: 6a78             push 0x78
  0275BC  29CC: 6a30             push 0x30
  0275BE  29CE: 2bc0             sub ax, ax
  0275C0  29D0: ba8200           mov dx, 0x82
  0275C3  29D3: 2bdb             sub bx, bx
  0275C5  29D5: 9ae2001f18       lcall 0x181f, 0xe2
  0275CA  29DA: 5e               pop si
  0275CB  29DB: 5f               pop di
  0275CC  29DC: c9               leave 
  0275CD  29DD: cb               retf 

; ---- func_0275CE  size=376  insns=119  prologue=ENTER 0x0008,0  terminal=RETF ----
  0275CE  29DE: c8080000         enter 8, 0
  0275D2  29E2: 56               push si
  0275D3  29E3: a03603           mov al, byte ptr [0x336]
  0275D6  29E6: 2ae4             sub ah, ah
  0275D8  29E8: a37000           mov word ptr [0x70], ax
  0275DB  29EB: c746fc8600       mov word ptr [bp - 4], 0x86
  0275E0  29F0: 9a18021f18       lcall 0x181f, 0x218
  0275E5  29F5: c746fa0000       mov word ptr [bp - 6], 0
  0275EA  29FA: 8b46fa           mov ax, word ptr [bp - 6]
  0275ED  29FD: 8bd8             mov bx, ax
  0275EF  29FF: d1e3             shl bx, 1
  0275F1  2A01: 83bfc88d00       cmp word ptr [bx - 0x7238], 0
  0275F6  2A06: 741f             je 0x2a27
  0275F8  2A08: 3d0500           cmp ax, 5
  0275FB  2A0B: 741a             je 0x2a27
  0275FD  2A0D: 0bc0             or ax, ax
  0275FF  2A0F: 7416             je 0x2a27
  027601  2A11: 051700           add ax, 0x17
  027604  2A14: 8bcb             mov cx, bx
  027606  2A16: 8b9f328e         mov bx, word ptr [bx - 0x71ce]
  02760A  2A1A: 8bf1             mov si, cx
  02760C  2A1C: 8b94c88d         mov dx, word ptr [si - 0x7238]
  027610  2A20: 03d3             add dx, bx
  027612  2A22: 9a22021f18       lcall 0x181f, 0x222
  027617  2A27: ff46fa           inc word ptr [bp - 6]
  02761A  2A2A: 837efa07         cmp word ptr [bp - 6], 7
  02761E  2A2E: 7eca             jle 0x29fa
  027620  2A30: 6a02             push 2
  027622  2A32: b8d500           mov ax, 0xd5
  027625  2A35: 8b56fc           mov dx, word ptr [bp - 4]
  027628  2A38: bb5900           mov bx, 0x59
  02762B  2A3B: 9a2c021f18       lcall 0x181f, 0x22c
  027630  2A40: 8346fc0e         add word ptr [bp - 4], 0xe
  027634  2A44: 9a18021f18       lcall 0x181f, 0x218
  027639  2A49: c746fa0800       mov word ptr [bp - 6], 8
  02763E  2A4E: c746fe0000       mov word ptr [bp - 2], 0
  027643  2A53: 8b5efa           mov bx, word ptr [bp - 6]
  027646  2A56: 80bfa20200       cmp byte ptr [bx + 0x2a2], 0
  02764B  2A5B: 7c10             jl 0x2a6d
  02764D  2A5D: 8a87a202         mov al, byte ptr [bx + 0x2a2]
  027651  2A61: 98               cwde 
  027652  2A62: 8bd8             mov bx, ax
  027654  2A64: d1e3             shl bx, 1
  027656  2A66: 8b875a8e         mov ax, word ptr [bx - 0x71a6]
  02765A  2A6A: 8946fe           mov word ptr [bp - 2], ax
  02765D  2A6D: 8b5efa           mov bx, word ptr [bp - 6]
  027660  2A70: d1e3             shl bx, 1
  027662  2A72: 83bfc88d00       cmp word ptr [bx - 0x7238], 0
  027667  2A77: 7506             jne 0x2a7f
  027669  2A79: 837efe00         cmp word ptr [bp - 2], 0
  02766D  2A7D: 741e             je 0x2a9d
  02766F  2A7F: 8b46fa           mov ax, word ptr [bp - 6]
  027672  2A82: 8bd8             mov bx, ax
  027674  2A84: d1e3             shl bx, 1
  027676  2A86: 051700           add ax, 0x17
  027679  2A89: 8b97c88d         mov dx, word ptr [bx - 0x7238]
  02767D  2A8D: 3b56fe           cmp dx, word ptr [bp - 2]
  027680  2A90: 7d03             jge 0x2a95
  027682  2A92: 8b56fe           mov dx, word ptr [bp - 2]
  027685  2A95: 8b5efe           mov bx, word ptr [bp - 2]
  027688  2A98: 9a22021f18       lcall 0x181f, 0x222
  02768D  2A9D: ff46fa           inc word ptr [bp - 6]
  027690  2AA0: 837efa0f         cmp word ptr [bp - 6], 0xf
  027694  2AA4: 7ea8             jle 0x2a4e
  027696  2AA6: 6a02             push 2
  027698  2AA8: b8d500           mov ax, 0xd5
  02769B  2AAB: 8b56fc           mov dx, word ptr [bp - 4]
  02769E  2AAE: bb5900           mov bx, 0x59
  0276A1  2AB1: 9a2c021f18       lcall 0x181f, 0x22c
  0276A6  2AB6: 8346fc0e         add word ptr [bp - 4], 0xe
  0276AA  2ABA: 9a18021f18       lcall 0x181f, 0x218
  0276AF  2ABF: a1d28d           mov ax, word ptr [0x8dd2]
  0276B2  2AC2: 3906148e         cmp word ptr [0x8e14], ax
  0276B6  2AC6: 7322             jae 0x2aea
  0276B8  2AC8: 833e148e00       cmp word ptr [0x8e14], 0
  0276BD  2ACD: 740e             je 0x2add
  0276BF  2ACF: b81c00           mov ax, 0x1c
  0276C2  2AD2: 8b16148e         mov dx, word ptr [0x8e14]
  0276C6  2AD6: 2bdb             sub bx, bx
  0276C8  2AD8: 9a22021f18       lcall 0x181f, 0x222
  0276CD  2ADD: 8b16d28d         mov dx, word ptr [0x8dd2]
  0276D1  2AE1: 2b16148e         sub dx, word ptr [0x8e14]
  0276D5  2AE5: b81c00           mov ax, 0x1c
  0276D8  2AE8: eb1e             jmp 0x2b08
  0276DA  2AEA: 0bc0             or ax, ax
  0276DC  2AEC: 740c             je 0x2afa
  0276DE  2AEE: 8bd0             mov dx, ax
  0276E0  2AF0: b81c00           mov ax, 0x1c
  0276E3  2AF3: 2bdb             sub bx, bx
  0276E5  2AF5: 9a22021f18       lcall 0x181f, 0x222
  0276EA  2AFA: 833e3c8e00       cmp word ptr [0x8e3c], 0
  0276EF  2AFF: 740e             je 0x2b0f
  0276F1  2B01: b81c80           mov ax, 0x801c
  0276F4  2B04: 8b163c8e         mov dx, word ptr [0x8e3c]
  0276F8  2B08: 2bdb             sub bx, bx
  0276FA  2B0A: 9a22021f18       lcall 0x181f, 0x222
  0276FF  2B0F: a1648e           mov ax, word ptr [0x8e64]
  027702  2B12: 3906e88d         cmp word ptr [0x8de8], ax
  027706  2B16: 7410             je 0x2b28
  027708  2B18: 8b16e88d         mov dx, word ptr [0x8de8]
  02770C  2B1C: 2bd0             sub dx, ax
  02770E  2B1E: b83700           mov ax, 0x37
  027711  2B21: 2bdb             sub bx, bx
  027713  2B23: 9a22021f18       lcall 0x181f, 0x222
  027718  2B28: 833e648e00       cmp word ptr [0x8e64], 0
  02771D  2B2D: 740e             je 0x2b3d
  02771F  2B2F: b83780           mov ax, 0x8037
  027722  2B32: 8b16648e         mov dx, word ptr [0x8e64]
  027726  2B36: 2bdb             sub bx, bx
  027728  2B38: 9a22021f18       lcall 0x181f, 0x222
  02772D  2B3D: 6a04             push 4
  02772F  2B3F: b8d500           mov ax, 0xd5
  027732  2B42: 8b56fc           mov dx, word ptr [bp - 4]
  027735  2B45: bb5900           mov bx, 0x59
  027738  2B48: 9a2c021f18       lcall 0x181f, 0x22c
  02773D  2B4D: c70670000000     mov word ptr [0x70], 0
  027743  2B53: 5e               pop si
  027744  2B54: c9               leave 
  027745  2B55: cb               retf 

; ---- func_027746  size=526  insns=176  prologue=ENTER 0x0076,0  terminal=RETF ----
  027746  2B56: c8760000         enter 0x76, 0
  02774A  2B5A: 833e980b00       cmp word ptr [0xb98], 0
  02774F  2B5F: 745b             je 0x2bbc
  027751  2B61: c646a000         mov byte ptr [bp - 0x60], 0
  027755  2B65: 8d46fa           lea ax, [bp - 6]
  027758  2B68: 50               push ax
  027759  2B69: 8b1e4285         mov bx, word ptr [0x8542]
  02775D  2B6D: 8a879400         mov al, byte ptr [bx + 0x94]
  027761  2B71: 98               cwde 
  027762  2B72: 50               push ax
  027763  2B73: 9ac40a1f18       lcall 0x181f, 0xac4
  027768  2B78: 83c404           add sp, 4
  02776B  2B7B: 894696           mov word ptr [bp - 0x6a], ax
  02776E  2B7E: 8b1e4285         mov bx, word ptr [0x8542]
  027772  2B82: 8a879400         mov al, byte ptr [bx + 0x94]
  027776  2B86: 98               cwde 
  027777  2B87: 50               push ax
  027778  2B88: 9a4e0d1f18       lcall 0x181f, 0xd4e
  02777D  2B8D: 83c402           add sp, 2
  027780  2B90: 8946fc           mov word ptr [bp - 4], ax
  027783  2B93: 8956fe           mov word ptr [bp - 2], dx
  027786  2B96: 0bd0             or dx, ax
  027788  2B98: 7411             je 0x2bab
  02778A  2B9A: ff76fe           push word ptr [bp - 2]
  02778D  2B9D: 50               push ax
  02778E  2B9E: 8d46a0           lea ax, [bp - 0x60]
  027791  2BA1: 16               push ss
  027792  2BA2: 50               push ax
  027793  2BA3: 9ab4111d0d       lcall 0xd1d, 0x11b4
  027798  2BA8: 83c408           add sp, 8
  02779B  2BAB: 6a39             push 0x39
  02779D  2BAD: 688400           push 0x84
  0277A0  2BB0: 6a5b             push 0x5b
  0277A2  2BB2: 68d300           push 0xd3
  0277A5  2BB5: 8d46a0           lea ax, [bp - 0x60]
  0277A8  2BB8: 16               push ss
  0277A9  2BB9: eb18             jmp 0x2bd3
  0277AB  2BBB: 90               nop 
  0277AC  2BBC: 6a39             push 0x39
  0277AE  2BBE: 688400           push 0x84
  0277B1  2BC1: 6a5b             push 0x5b
  0277B3  2BC3: 68d300           push 0xd3
  0277B6  2BC6: ff369a93         push word ptr [0x939a]
  0277BA  2BCA: 9a22001f18       lcall 0x181f, 0x22
  0277BF  2BCF: 83c402           add sp, 2
  0277C2  2BD2: 52               push dx
  0277C3  2BD3: 50               push ax
  0277C4  2BD4: 9a00011f18       lcall 0x181f, 0x100
  0277C9  2BD9: 83c40c           add sp, 0xc
  0277CC  2BDC: c7469c9e00       mov word ptr [bp - 0x64], 0x9e
  0277D1  2BE1: b8d500           mov ax, 0xd5
  0277D4  2BE4: 89469e           mov word ptr [bp - 0x62], ax
  0277D7  2BE7: 894692           mov word ptr [bp - 0x6e], ax
  0277DA  2BEA: c746941200       mov word ptr [bp - 0x6c], 0x12
  0277DF  2BEF: c7468c0500       mov word ptr [bp - 0x74], 5
  0277E4  2BF4: b81000           mov ax, 0x10
  0277E7  2BF7: 8946f6           mov word ptr [bp - 0xa], ax
  0277EA  2BFA: 8946f2           mov word ptr [bp - 0xe], ax
  0277ED  2BFD: 2bc0             sub ax, ax
  0277EF  2BFF: 8946f0           mov word ptr [bp - 0x10], ax
  0277F2  2C02: 894698           mov word ptr [bp - 0x68], ax
  0277F5  2C05: 89469a           mov word ptr [bp - 0x66], ax
  0277F8  2C08: 8946f8           mov word ptr [bp - 8], ax
  0277FB  2C0B: 8b1e4285         mov bx, word ptr [0x8542]
  0277FF  2C0F: 8a07             mov al, byte ptr [bx]
  027801  2C11: 2ae4             sub ah, ah
  027803  2C13: 8a5701           mov dl, byte ptr [bx + 1]
  027806  2C16: 2af6             sub dh, dh
  027808  2C18: 9ae0071f18       lcall 0x181f, 0x7e0
  02780D  2C1D: 8946f4           mov word ptr [bp - 0xc], ax
  027810  2C20: e9f800           jmp 0x2d1b
  027813  2C23: 90               nop 
  027814  2C24: ff364008         push word ptr [0x840]
  027818  2C28: ff363e08         push word ptr [0x83e]
  02781C  2C2C: 8b46f2           mov ax, word ptr [bp - 0xe]
  02781F  2C2F: 034690           add ax, word ptr [bp - 0x70]
  027822  2C32: 48               dec ax
  027823  2C33: 50               push ax
  027824  2C34: 6a23             push 0x23
  027826  2C36: 8b468e           mov ax, word ptr [bp - 0x72]
  027829  2C39: 9ada021f18       lcall 0x181f, 0x2da
  02782E  2C3E: 8b56f6           mov dx, word ptr [bp - 0xa]
  027831  2C41: d1fa             sar dx, 1
  027833  2C43: 035692           add dx, word ptr [bp - 0x6e]
  027836  2C46: 8d1ea82d         lea bx, [0x2da8]
  02783A  2C4A: 9af8021f18       lcall 0x181f, 0x2f8
  02783F  2C4F: a17a8d           mov ax, word ptr [0x8d7a]
  027842  2C52: 39469a           cmp word ptr [bp - 0x66], ax
  027845  2C55: 7568             jne 0x2cbf
  027847  2C57: c7468a0a00       mov word ptr [bp - 0x76], 0xa
  02784C  2C5C: 833eee0700       cmp word ptr [0x7ee], 0
  027851  2C61: 740c             je 0x2c6f
  027853  2C63: 833e548d04       cmp word ptr [0x8d54], 4
  027858  2C68: 7505             jne 0x2c6f
  02785A  2C6A: c7468a0f00       mov word ptr [bp - 0x76], 0xf
  02785F  2C6F: 833e2e0303       cmp word ptr [0x32e], 3
  027864  2C74: 750c             jne 0x2c82
  027866  2C76: 833e340300       cmp word ptr [0x334], 0
  02786B  2C7B: 7405             je 0x2c82
  02786D  2C7D: c7468a0f00       mov word ptr [bp - 0x76], 0xf
  027872  2C82: 837e8a00         cmp word ptr [bp - 0x76], 0
  027876  2C86: 7437             je 0x2cbf
  027878  2C88: 833e980b00       cmp word ptr [0xb98], 0
  02787D  2C8D: 7530             jne 0x2cbf
  02787F  2C8F: ff36ae2d         push word ptr [0x2dae]
  027883  2C93: ff36ac2d         push word ptr [0x2dac]
  027887  2C97: ff36aa2d         push word ptr [0x2daa]
  02788B  2C9B: ff36a82d         push word ptr [0x2da8]
  02788F  2C9F: 8b46f2           mov ax, word ptr [bp - 0xe]
  027892  2CA2: 03469c           add ax, word ptr [bp - 0x64]
  027895  2CA5: 50               push ax
  027896  2CA6: 8a468a           mov al, byte ptr [bp - 0x76]
  027899  2CA9: 50               push ax
  02789A  2CAA: 8b4692           mov ax, word ptr [bp - 0x6e]
  02789D  2CAD: 8b5ef6           mov bx, word ptr [bp - 0xa]
  0278A0  2CB0: 03d8             add bx, ax
  0278A2  2CB2: 48               dec ax
  0278A3  2CB3: 8b569c           mov dx, word ptr [bp - 0x64]
  0278A6  2CB6: 2b56f8           sub dx, word ptr [bp - 8]
  0278A9  2CB9: 4a               dec dx
  0278AA  2CBA: 9ace001f18       lcall 0x181f, 0xce
  0278AF  2CBF: 8b4694           mov ax, word ptr [bp - 0x6c]
  0278B2  2CC2: 014692           add word ptr [bp - 0x6e], ax
  0278B5  2CC5: 8b468c           mov ax, word ptr [bp - 0x74]
  0278B8  2CC8: ff46f0           inc word ptr [bp - 0x10]
  0278BB  2CCB: 3946f0           cmp word ptr [bp - 0x10], ax
  0278BE  2CCE: 7c40             jl 0x2d10
  0278C0  2CD0: c746f00000       mov word ptr [bp - 0x10], 0
  0278C5  2CD5: ff4698           inc word ptr [bp - 0x68]
  0278C8  2CD8: 837e9803         cmp word ptr [bp - 0x68], 3
  0278CC  2CDC: 7c03             jl 0x2ce1
  0278CE  2CDE: e98100           jmp 0x2d62
  0278D1  2CE1: 837e9801         cmp word ptr [bp - 0x68], 1
  0278D5  2CE5: 7507             jne 0x2cee
  0278D7  2CE7: c7469c9800       mov word ptr [bp - 0x64], 0x98
  0278DC  2CEC: eb05             jmp 0x2cf3
  0278DE  2CEE: c7469c9000       mov word ptr [bp - 0x64], 0x90
  0278E3  2CF3: c74692d500       mov word ptr [bp - 0x6e], 0xd5
  0278E8  2CF8: c7468c1100       mov word ptr [bp - 0x74], 0x11
  0278ED  2CFD: c746f60300       mov word ptr [bp - 0xa], 3
  0278F2  2D02: b80500           mov ax, 5
  0278F5  2D05: 894694           mov word ptr [bp - 0x6c], ax
  0278F8  2D08: 8946f2           mov word ptr [bp - 0xe], ax
  0278FB  2D0B: c746f80100       mov word ptr [bp - 8], 1
  027900  2D10: ff469a           inc word ptr [bp - 0x66]
  027903  2D13: 8b468e           mov ax, word ptr [bp - 0x72]
  027906  2D16: 9ae4021f18       lcall 0x181f, 0x2e4
  02790B  2D1B: 89468e           mov word ptr [bp - 0x72], ax
  02790E  2D1E: 0bc0             or ax, ax
  027910  2D20: 7c40             jl 0x2d62
  027912  2D22: 6bd81c           imul bx, ax, 0x1c
  027915  2D25: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  027919  2D29: 2aff             sub bh, bh
  02791B  2D2B: 8bc3             mov ax, bx
  02791D  2D2D: d1e3             shl bx, 1
  02791F  2D2F: 03d8             add bx, ax
  027921  2D31: d1e3             shl bx, 1
  027923  2D33: 03d8             add bx, ax
  027925  2D35: d1e3             shl bx, 1
  027927  2D37: 80bf375200       cmp byte ptr [bx + 0x5237], 0
  02792C  2D3C: 75d5             jne 0x2d13
  02792E  2D3E: 8b469c           mov ax, word ptr [bp - 0x64]
  027931  2D41: 894690           mov word ptr [bp - 0x70], ax
  027934  2D44: 837e9800         cmp word ptr [bp - 0x68], 0
  027938  2D48: 7403             je 0x2d4d
  02793A  2D4A: e9d7fe           jmp 0x2c24
  02793D  2D4D: 50               push ax
  02793E  2D4E: 6a10             push 0x10
  027940  2D50: 6a64             push 0x64
  027942  2D52: 8b468e           mov ax, word ptr [bp - 0x72]
  027945  2D55: 2bd2             sub dx, dx
  027947  2D57: 8b5e92           mov bx, word ptr [bp - 0x6e]
  02794A  2D5A: 9abc021f18       lcall 0x181f, 0x2bc
  02794F  2D5F: e9edfe           jmp 0x2c4f
  027952  2D62: c9               leave 
  027953  2D63: cb               retf 

; ---- func_027954  size=56  insns=21  prologue=ENTER 0x0004,0  terminal=RETF ----
  027954  2D64: c8040000         enter 4, 0
  027958  2D68: ff7606           push word ptr [bp + 6]
  02795B  2D6B: 9a22001f18       lcall 0x181f, 0x22
  027960  2D70: 83c402           add sp, 2
  027963  2D73: 52               push dx
  027964  2D74: 50               push ax
  027965  2D75: 9a14011f18       lcall 0x181f, 0x114
  02796A  2D7A: 8946fe           mov word ptr [bp - 2], ax
  02796D  2D7D: c41e9e08         les bx, ptr [0x89e]
  027971  2D81: 268a07           mov al, byte ptr es:[bx]
  027974  2D84: 2ae4             sub ah, ah
  027976  2D86: 48               dec ax
  027977  2D87: 8b4efe           mov cx, word ptr [bp - 2]
  02797A  2D8A: 83c106           add cx, 6
  02797D  2D8D: 8b5e08           mov bx, word ptr [bp + 8]
  027980  2D90: 890f             mov word ptr [bx], cx
  027982  2D92: 050400           add ax, 4
  027985  2D95: 8b5e0a           mov bx, word ptr [bp + 0xa]
  027988  2D98: 8907             mov word ptr [bx], ax
  02798A  2D9A: c9               leave 
  02798B  2D9B: cb               retf 

; ---- func_02798C  size=334  insns=121  prologue=ENTER 0x0010,0  terminal=RETF ----
  02798C  2D9C: c8100000         enter 0x10, 0
  027990  2DA0: 57               push di
  027991  2DA1: 56               push si
  027992  2DA2: 8a460c           mov al, byte ptr [bp + 0xc]
  027995  2DA5: 250100           and ax, 1
  027998  2DA8: 7514             jne 0x2dbe
  02799A  2DAA: c646fc0f         mov byte ptr [bp - 4], 0xf
  02799E  2DAE: c746faffff       mov word ptr [bp - 6], 0xffff
  0279A3  2DB3: c646f439         mov byte ptr [bp - 0xc], 0x39
  0279A7  2DB7: c646fe30         mov byte ptr [bp - 2], 0x30
  0279AB  2DBB: eb12             jmp 0x2dcf
  0279AD  2DBD: 90               nop 
  0279AE  2DBE: c646fc00         mov byte ptr [bp - 4], 0
  0279B2  2DC2: c746fa0f00       mov word ptr [bp - 6], 0xf
  0279B7  2DC7: c646f430         mov byte ptr [bp - 0xc], 0x30
  0279BB  2DCB: c646fe39         mov byte ptr [bp - 2], 0x39
  0279BF  2DCF: 8d46f6           lea ax, [bp - 0xa]
  0279C2  2DD2: 50               push ax
  0279C3  2DD3: 8d4ef8           lea cx, [bp - 8]
  0279C6  2DD6: 51               push cx
  0279C7  2DD7: ff7606           push word ptr [bp + 6]
  0279CA  2DDA: 0e               push cs
  0279CB  2DDB: e8f14f           call 0x7dcf
  0279CE  2DDE: 83c406           add sp, 6
  0279D1  2DE1: 8b4608           mov ax, word ptr [bp + 8]
  0279D4  2DE4: 050300           add ax, 3
  0279D7  2DE7: 8946f2           mov word ptr [bp - 0xe], ax
  0279DA  2DEA: 8b460a           mov ax, word ptr [bp + 0xa]
  0279DD  2DED: 40               inc ax
  0279DE  2DEE: 40               inc ax
  0279DF  2DEF: 8946f0           mov word ptr [bp - 0x10], ax
  0279E2  2DF2: ff36ae2d         push word ptr [0x2dae]
  0279E6  2DF6: ff36ac2d         push word ptr [0x2dac]
  0279EA  2DFA: ff36aa2d         push word ptr [0x2daa]
  0279EE  2DFE: ff36a82d         push word ptr [0x2da8]
  0279F2  2E02: 8a46fe           mov al, byte ptr [bp - 2]
  0279F5  2E05: 50               push ax
  0279F6  2E06: 8b4608           mov ax, word ptr [bp + 8]
  0279F9  2E09: 8bd0             mov dx, ax
  0279FB  2E0B: 0356f8           add dx, word ptr [bp - 8]
  0279FE  2E0E: 8b5e0a           mov bx, word ptr [bp + 0xa]
  027A01  2E11: 035ef6           add bx, word ptr [bp - 0xa]
  027A04  2E14: 4b               dec bx
  027A05  2E15: 4a               dec dx
  027A06  2E16: 8bf0             mov si, ax
  027A08  2E18: 9abc081f19       lcall 0x191f, 0x8bc
  027A0D  2E1D: ff36ae2d         push word ptr [0x2dae]
  027A11  2E21: ff36ac2d         push word ptr [0x2dac]
  027A15  2E25: ff36aa2d         push word ptr [0x2daa]
  027A19  2E29: ff36a82d         push word ptr [0x2da8]
  027A1D  2E2D: 8a46fe           mov al, byte ptr [bp - 2]
  027A20  2E30: 50               push ax
  027A21  2E31: 8b4608           mov ax, word ptr [bp + 8]
  027A24  2E34: 0346f8           add ax, word ptr [bp - 8]
  027A27  2E37: 48               dec ax
  027A28  2E38: 8b5e0a           mov bx, word ptr [bp + 0xa]
  027A2B  2E3B: 035ef6           add bx, word ptr [bp - 0xa]
  027A2E  2E3E: 8d5fff           lea bx, [bx - 1]
  027A31  2E41: 8b560a           mov dx, word ptr [bp + 0xa]
  027A34  2E44: 8bfa             mov di, dx
  027A36  2E46: 9ab2081f19       lcall 0x191f, 0x8b2
  027A3B  2E4B: ff36ae2d         push word ptr [0x2dae]
  027A3F  2E4F: ff36ac2d         push word ptr [0x2dac]
  027A43  2E53: ff36aa2d         push word ptr [0x2daa]
  027A47  2E57: ff36a82d         push word ptr [0x2da8]
  027A4B  2E5B: 8a46f4           mov al, byte ptr [bp - 0xc]
  027A4E  2E5E: 50               push ax
  027A4F  2E5F: 8bdf             mov bx, di
  027A51  2E61: 8bc6             mov ax, si
  027A53  2E63: 8b5608           mov dx, word ptr [bp + 8]
  027A56  2E66: 0356f8           add dx, word ptr [bp - 8]
  027A59  2E69: 4a               dec dx
  027A5A  2E6A: 9abc081f19       lcall 0x191f, 0x8bc
  027A5F  2E6F: ff36ae2d         push word ptr [0x2dae]
  027A63  2E73: ff36ac2d         push word ptr [0x2dac]
  027A67  2E77: ff36aa2d         push word ptr [0x2daa]
  027A6B  2E7B: ff36a82d         push word ptr [0x2da8]
  027A6F  2E7F: 8a46f4           mov al, byte ptr [bp - 0xc]
  027A72  2E82: 50               push ax
  027A73  2E83: 8bc6             mov ax, si
  027A75  2E85: 8b5e0a           mov bx, word ptr [bp + 0xa]
  027A78  2E88: 035ef6           add bx, word ptr [bp - 0xa]
  027A7B  2E8B: 4b               dec bx
  027A7C  2E8C: 8bd7             mov dx, di
  027A7E  2E8E: 9ab2081f19       lcall 0x191f, 0x8b2
  027A83  2E93: 837efa00         cmp word ptr [bp - 6], 0
  027A87  2E97: 7c2c             jl 0x2ec5
  027A89  2E99: ff36ae2d         push word ptr [0x2dae]
  027A8D  2E9D: ff36ac2d         push word ptr [0x2dac]
  027A91  2EA1: ff36aa2d         push word ptr [0x2daa]
  027A95  2EA5: ff36a82d         push word ptr [0x2da8]
  027A99  2EA9: 8b46f6           mov ax, word ptr [bp - 0xa]
  027A9C  2EAC: 48               dec ax
  027A9D  2EAD: 48               dec ax
  027A9E  2EAE: 50               push ax
  027A9F  2EAF: 8a46fa           mov al, byte ptr [bp - 6]
  027AA2  2EB2: 50               push ax
  027AA3  2EB3: 8b4608           mov ax, word ptr [bp + 8]
  027AA6  2EB6: 40               inc ax
  027AA7  2EB7: 8b5ef8           mov bx, word ptr [bp - 8]
  027AAA  2EBA: 4b               dec bx
  027AAB  2EBB: 4b               dec bx
  027AAC  2EBC: 8b560a           mov dx, word ptr [bp + 0xa]
  027AAF  2EBF: 42               inc dx
  027AB0  2EC0: 9aba001f18       lcall 0x181f, 0xba
  027AB5  2EC5: 8a46fc           mov al, byte ptr [bp - 4]
  027AB8  2EC8: 2ae4             sub ah, ah
  027ABA  2ECA: 50               push ax
  027ABB  2ECB: ff76f0           push word ptr [bp - 0x10]
  027ABE  2ECE: ff76f2           push word ptr [bp - 0xe]
  027AC1  2ED1: ff7606           push word ptr [bp + 6]
  027AC4  2ED4: 9a22001f18       lcall 0x181f, 0x22
  027AC9  2ED9: 83c402           add sp, 2
  027ACC  2EDC: 52               push dx
  027ACD  2EDD: 50               push ax
  027ACE  2EDE: 9a3c011f18       lcall 0x181f, 0x13c
  027AD3  2EE3: 83c40a           add sp, 0xa
  027AD6  2EE6: 5e               pop si
  027AD7  2EE7: 5f               pop di
  027AD8  2EE8: c9               leave 
  027AD9  2EE9: cb               retf 

; ---- func_027ADA  size=220  insns=81  prologue=ENTER 0x0002,0  terminal=RETF ----
  027ADA  2EEA: c8020000         enter 2, 0
  027ADE  2EEE: c746feffff       mov word ptr [bp - 2], 0xffff
  027AE3  2EF3: 833eee0700       cmp word ptr [0x7ee], 0
  027AE8  2EF8: 740d             je 0x2f07
  027AEA  2EFA: 833e548d04       cmp word ptr [0x8d54], 4
  027AEF  2EFF: 7506             jne 0x2f07
  027AF1  2F01: a14203           mov ax, word ptr [0x342]
  027AF4  2F04: 8946fe           mov word ptr [bp - 2], ax
  027AF7  2F07: 6a09             push 9
  027AF9  2F09: 6a1e             push 0x1e
  027AFB  2F0B: 688a00           push 0x8a
  027AFE  2F0E: 68d800           push 0xd8
  027B01  2F11: 0e               push cs
  027B02  2F12: e8be4f           call 0x7ed3
  027B05  2F15: 83c408           add sp, 8
  027B08  2F18: 6a09             push 9
  027B0A  2F1A: 6a1e             push 0x1e
  027B0C  2F1C: 688a00           push 0x8a
  027B0F  2F1F: 680e01           push 0x10e
  027B12  2F22: 0e               push cs
  027B13  2F23: e8ad4f           call 0x7ed3
  027B16  2F26: 83c408           add sp, 8
  027B19  2F29: 8b1e4285         mov bx, word ptr [0x8542]
  027B1D  2F2D: 80bf940000       cmp byte ptr [bx + 0x94], 0
  027B22  2F32: 7c1d             jl 0x2f51
  027B24  2F34: 837efe01         cmp word ptr [bp - 2], 1
  027B28  2F38: 1bc0             sbb ax, ax
  027B2A  2F3A: f7d8             neg ax
  027B2C  2F3C: 250100           and ax, 1
  027B2F  2F3F: 50               push ax
  027B30  2F40: 688a00           push 0x8a
  027B33  2F43: 68d800           push 0xd8
  027B36  2F46: ff36a293         push word ptr [0x93a2]
  027B3A  2F4A: 0e               push cs
  027B3B  2F4B: e8e04e           call 0x7e2e
  027B3E  2F4E: 83c408           add sp, 8
  027B41  2F51: 837efe01         cmp word ptr [bp - 2], 1
  027B45  2F55: 7505             jne 0x2f5c
  027B47  2F57: b80100           mov ax, 1
  027B4A  2F5A: eb02             jmp 0x2f5e
  027B4C  2F5C: 2bc0             sub ax, ax
  027B4E  2F5E: 250100           and ax, 1
  027B51  2F61: 50               push ax
  027B52  2F62: 688a00           push 0x8a
  027B55  2F65: 680e01           push 0x10e
  027B58  2F68: ff36a493         push word ptr [0x93a4]
  027B5C  2F6C: 0e               push cs
  027B5D  2F6D: e8be4e           call 0x7e2e
  027B60  2F70: c9               leave 
  027B61  2F71: cb               retf 
  027B62  2F72: 833eee0700       cmp word ptr [0x7ee], 0
  027B67  2F77: 7407             je 0x2f80
  027B69  2F79: 833e548d04       cmp word ptr [0x8d54], 4
  027B6E  2F7E: 7445             je 0x2fc5
  027B70  2F80: 6a09             push 9
  027B72  2F82: 6a1e             push 0x1e
  027B74  2F84: 688a00           push 0x8a
  027B77  2F87: 680e01           push 0x10e
  027B7A  2F8A: 0e               push cs
  027B7B  2F8B: e8454f           call 0x7ed3
  027B7E  2F8E: 83c408           add sp, 8
  027B81  2F91: 833e340301       cmp word ptr [0x334], 1
  027B86  2F96: 1bc0             sbb ax, ax
  027B88  2F98: f7d8             neg ax
  027B8A  2F9A: 250100           and ax, 1
  027B8D  2F9D: 0c02             or al, 2
  027B8F  2F9F: 50               push ax
  027B90  2FA0: 688a00           push 0x8a
  027B93  2FA3: 680e01           push 0x10e
  027B96  2FA6: ff36a493         push word ptr [0x93a4]
  027B9A  2FAA: 0e               push cs
  027B9B  2FAB: e8804e           call 0x7e2e
  027B9E  2FAE: 83c408           add sp, 8
  027BA1  2FB1: 688a00           push 0x8a
  027BA4  2FB4: 6a1e             push 0x1e
  027BA6  2FB6: 6a09             push 9
  027BA8  2FB8: b80e01           mov ax, 0x10e
  027BAB  2FBB: ba8a00           mov dx, 0x8a
  027BAE  2FBE: 8bd8             mov bx, ax
  027BB0  2FC0: 9ae2001f18       lcall 0x181f, 0xe2
  027BB5  2FC5: cb               retf 

; ---- func_027BB6  size=461  insns=166  prologue=ENTER 0x0074,0  terminal=RETF ----
  027BB6  2FC6: c8740000         enter 0x74, 0
  027BBA  2FCA: c646a400         mov byte ptr [bp - 0x5c], 0
  027BBE  2FCE: 8d46fa           lea ax, [bp - 6]
  027BC1  2FD1: 50               push ax
  027BC2  2FD2: 8b1e4285         mov bx, word ptr [0x8542]
  027BC6  2FD6: 8a879400         mov al, byte ptr [bx + 0x94]
  027BCA  2FDA: 98               cwde 
  027BCB  2FDB: 50               push ax
  027BCC  2FDC: 9ac40a1f18       lcall 0x181f, 0xac4
  027BD1  2FE1: 83c404           add sp, 4
  027BD4  2FE4: 89469c           mov word ptr [bp - 0x64], ax
  027BD7  2FE7: 8b1e4285         mov bx, word ptr [0x8542]
  027BDB  2FEB: 8a879400         mov al, byte ptr [bx + 0x94]
  027BDF  2FEF: 98               cwde 
  027BE0  2FF0: 50               push ax
  027BE1  2FF1: 9a4e0d1f18       lcall 0x181f, 0xd4e
  027BE6  2FF6: 83c402           add sp, 2
  027BE9  2FF9: 8946fc           mov word ptr [bp - 4], ax
  027BEC  2FFC: 8956fe           mov word ptr [bp - 2], dx
  027BEF  2FFF: 0bd0             or dx, ax
  027BF1  3001: 7411             je 0x3014
  027BF3  3003: ff76fe           push word ptr [bp - 2]
  027BF6  3006: 50               push ax
  027BF7  3007: 8d46a4           lea ax, [bp - 0x5c]
  027BFA  300A: 16               push ss
  027BFB  300B: 50               push ax
  027BFC  300C: 9ab4111d0d       lcall 0xd1d, 0x11b4
  027C01  3011: 83c408           add sp, 8
  027C04  3014: 6a39             push 0x39
  027C06  3016: 688400           push 0x84
  027C09  3019: 6a5b             push 0x5b
  027C0B  301B: 68d300           push 0xd3
  027C0E  301E: 8d46a4           lea ax, [bp - 0x5c]
  027C11  3021: 16               push ss
  027C12  3022: 50               push ax
  027C13  3023: 9a00011f18       lcall 0x181f, 0x100
  027C18  3028: 83c40c           add sp, 0xc
  027C1B  302B: 0e               push cs
  027C1C  302C: e8454e           call 0x7e74
  027C1F  302F: b85a00           mov ax, 0x5a
  027C22  3032: c41e3e08         les bx, ptr [0x83e]
  027C26  3036: 268b8fd202       mov cx, word ptr es:[bx + 0x2d2]
  027C2B  303B: 894e92           mov word ptr [bp - 0x6e], cx
  027C2E  303E: 41               inc cx
  027C2F  303F: 99               cdq 
  027C30  3040: f7f9             idiv cx
  027C32  3042: 8946f6           mov word ptr [bp - 0xa], ax
  027C35  3045: c746960400       mov word ptr [bp - 0x6a], 4
  027C3A  304A: 268b8fd402       mov cx, word ptr es:[bx + 0x2d4]
  027C3F  304F: d1f9             sar cx, 1
  027C41  3051: 894e90           mov word ptr [bp - 0x70], cx
  027C44  3054: 89468e           mov word ptr [bp - 0x72], ax
  027C47  3057: 8bc8             mov cx, ax
  027C49  3059: 8b469c           mov ax, word ptr [bp - 0x64]
  027C4C  305C: 48               dec ax
  027C4D  305D: 8bd8             mov bx, ax
  027C4F  305F: 99               cdq 
  027C50  3060: f7f9             idiv cx
  027C52  3062: 40               inc ax
  027C53  3063: 894698           mov word ptr [bp - 0x68], ax
  027C56  3066: 3d0400           cmp ax, 4
  027C59  3069: 7e17             jle 0x3082
  027C5B  306B: c746980400       mov word ptr [bp - 0x68], 4
  027C60  3070: 8bc3             mov ax, bx
  027C62  3072: 99               cdq 
  027C63  3073: 33c2             xor ax, dx
  027C65  3075: 2bc2             sub ax, dx
  027C67  3077: c1f802           sar ax, 2
  027C6A  307A: 33c2             xor ax, dx
  027C6C  307C: 2bc2             sub ax, dx
  027C6E  307E: 40               inc ax
  027C6F  307F: 89468e           mov word ptr [bp - 0x72], ax
  027C72  3082: 8b1e4285         mov bx, word ptr [0x8542]
  027C76  3086: 8b879200         mov ax, word ptr [bx + 0x92]
  027C7A  308A: 89469e           mov word ptr [bp - 0x62], ax
  027C7D  308D: c746f85b00       mov word ptr [bp - 8], 0x5b
  027C82  3092: 8b4690           mov ax, word ptr [bp - 0x70]
  027C85  3095: f76e98           imul word ptr [bp - 0x68]
  027C88  3098: 40               inc ax
  027C89  3099: 40               inc ax
  027C8A  309A: 8946f4           mov word ptr [bp - 0xc], ax
  027C8D  309D: 837e9808         cmp word ptr [bp - 0x68], 8
  027C91  30A1: 7505             jne 0x30a8
  027C93  30A3: c746f43000       mov word ptr [bp - 0xc], 0x30
  027C98  30A8: c746a2d400       mov word ptr [bp - 0x5e], 0xd4
  027C9D  30AD: c746a09200       mov word ptr [bp - 0x60], 0x92
  027CA2  30B2: c7469a0000       mov word ptr [bp - 0x66], 0
  027CA7  30B7: eb37             jmp 0x30f0
  027CA9  30B9: 90               nop 
  027CAA  30BA: ff76a2           push word ptr [bp - 0x5e]
  027CAD  30BD: ff76a0           push word ptr [bp - 0x60]
  027CB0  30C0: 6a59             push 0x59
  027CB2  30C2: 6a00             push 0
  027CB4  30C4: 6a00             push 0
  027CB6  30C6: 6a01             push 1
  027CB8  30C8: 8b5e9e           mov bx, word ptr [bp - 0x62]
  027CBB  30CB: 3b5e8e           cmp bx, word ptr [bp - 0x72]
  027CBE  30CE: 7e03             jle 0x30d3
  027CC0  30D0: 8b5e8e           mov bx, word ptr [bp - 0x72]
  027CC3  30D3: 895e94           mov word ptr [bp - 0x6c], bx
  027CC6  30D6: b83700           mov ax, 0x37
  027CC9  30D9: 8b568e           mov dx, word ptr [bp - 0x72]
  027CCC  30DC: 9a36021f18       lcall 0x181f, 0x236
  027CD1  30E1: 8b4694           mov ax, word ptr [bp - 0x6c]
  027CD4  30E4: 29469e           sub word ptr [bp - 0x62], ax
  027CD7  30E7: 8b4690           mov ax, word ptr [bp - 0x70]
  027CDA  30EA: 0146a0           add word ptr [bp - 0x60], ax
  027CDD  30ED: ff469a           inc word ptr [bp - 0x66]
  027CE0  30F0: 8b4698           mov ax, word ptr [bp - 0x68]
  027CE3  30F3: 39469a           cmp word ptr [bp - 0x66], ax
  027CE6  30F6: 7cc2             jl 0x30ba
  027CE8  30F8: 837efa00         cmp word ptr [bp - 6], 0
  027CEC  30FC: 7503             jne 0x3101
  027CEE  30FE: e99000           jmp 0x3191
  027CF1  3101: c646a400         mov byte ptr [bp - 0x5c], 0
  027CF5  3105: 8d46a4           lea ax, [bp - 0x5c]
  027CF8  3108: 50               push ax
  027CF9  3109: 9a1e011f18       lcall 0x181f, 0x11e
  027CFE  310E: 83c402           add sp, 2
  027D01  3111: ff36102e         push word ptr [0x2e10]
  027D05  3115: 8d46a4           lea ax, [bp - 0x5c]
  027D08  3118: 50               push ax
  027D09  3119: 9a6e011f18       lcall 0x181f, 0x16e
  027D0E  311E: 83c404           add sp, 4
  027D11  3121: 8d46a4           lea ax, [bp - 0x5c]
  027D14  3124: 50               push ax
  027D15  3125: 9a78011f18       lcall 0x181f, 0x178
  027D1A  312A: 83c402           add sp, 2
  027D1D  312D: ff76fa           push word ptr [bp - 6]
  027D20  3130: 8d46a4           lea ax, [bp - 0x5c]
  027D23  3133: 16               push ss
  027D24  3134: 50               push ax
  027D25  3135: 9a82011f18       lcall 0x181f, 0x182
  027D2A  313A: 83c406           add sp, 6
  027D2D  313D: 8d46a4           lea ax, [bp - 0x5c]
  027D30  3140: 50               push ax
  027D31  3141: 9a78011f18       lcall 0x181f, 0x178
  027D36  3146: 83c402           add sp, 2
  027D39  3149: ff36dc97         push word ptr [0x97dc]
  027D3D  314D: 8d46a4           lea ax, [bp - 0x5c]
  027D40  3150: 50               push ax
  027D41  3151: 9a6e011f18       lcall 0x181f, 0x16e
  027D46  3156: 83c404           add sp, 4
  027D49  3159: 8d46a4           lea ax, [bp - 0x5c]
  027D4C  315C: 50               push ax
  027D4D  315D: 9a28011f18       lcall 0x181f, 0x128
  027D52  3162: 83c402           add sp, 2
  027D55  3165: 8b46fa           mov ax, word ptr [bp - 6]
  027D58  3168: 8b1e4285         mov bx, word ptr [0x8542]
  027D5C  316C: 3987b600         cmp word ptr [bx + 0xb6], ax
  027D60  3170: 7c06             jl 0x3178
  027D62  3172: b80700           mov ax, 7
  027D65  3175: eb04             jmp 0x317b
  027D67  3177: 90               nop 
  027D68  3178: b80f00           mov ax, 0xf
  027D6B  317B: 89468c           mov word ptr [bp - 0x74], ax
  027D6E  317E: 50               push ax
  027D6F  317F: 68aa00           push 0xaa
  027D72  3182: 6a5b             push 0x5b
  027D74  3184: 68d300           push 0xd3
  027D77  3187: 8d46a4           lea ax, [bp - 0x5c]
  027D7A  318A: 16               push ss
  027D7B  318B: 50               push ax
  027D7C  318C: 9a00011f18       lcall 0x181f, 0x100
  027D81  3191: c9               leave 
  027D82  3192: cb               retf 

; ---- func_027D84  size=46  insns=18  prologue=push bp;mov bp,sp  terminal=RETF ----
  027D84  3194: 55               push bp
  027D85  3195: 8bec             mov bp, sp
  027D87  3197: 8b4606           mov ax, word ptr [bp + 6]
  027D8A  319A: 8bc8             mov cx, ax
  027D8C  319C: d1e0             shl ax, 1
  027D8E  319E: 03c1             add ax, cx
  027D90  31A0: c1e002           shl ax, 2
  027D93  31A3: 057f00           add ax, 0x7f
  027D96  31A6: 8b5e08           mov bx, word ptr [bp + 8]
  027D99  31A9: 8907             mov word ptr [bx], ax
  027D9B  31AB: 8b5e0a           mov bx, word ptr [bp + 0xa]
  027D9E  31AE: c707a500         mov word ptr [bx], 0xa5
  027DA2  31B2: 8b5e0c           mov bx, word ptr [bp + 0xc]
  027DA5  31B5: c7070a00         mov word ptr [bx], 0xa
  027DA9  31B9: 8b5e0e           mov bx, word ptr [bp + 0xe]
  027DAC  31BC: c7071600         mov word ptr [bx], 0x16
  027DB0  31C0: c9               leave 
  027DB1  31C1: cb               retf 

; ---- func_027DB2  size=921  insns=320  prologue=ENTER 0x0074,0  terminal=RETF ----
  027DB2  31C2: c8740000         enter 0x74, 0
  027DB6  31C6: 56               push si
  027DB7  31C7: 6a30             push 0x30
  027DB9  31C9: 6a54             push 0x54
  027DBB  31CB: 688200           push 0x82
  027DBE  31CE: 6a79             push 0x79
  027DC0  31D0: 0e               push cs
  027DC1  31D1: e8ff4c           call 0x7ed3
  027DC4  31D4: 83c408           add sp, 8
  027DC7  31D7: 833e3c0300       cmp word ptr [0x33c], 0
  027DCC  31DC: 7568             jne 0x3246
  027DCE  31DE: 6a39             push 0x39
  027DD0  31E0: 688400           push 0x84
  027DD3  31E3: 6a54             push 0x54
  027DD5  31E5: 6a79             push 0x79
  027DD7  31E7: ff36d02d         push word ptr [0x2dd0]
  027DDB  31EB: 9a22001f18       lcall 0x181f, 0x22
  027DE0  31F0: 83c402           add sp, 2
  027DE3  31F3: 52               push dx
  027DE4  31F4: 50               push ax
  027DE5  31F5: 9a00011f18       lcall 0x181f, 0x100
  027DEA  31FA: 83c40c           add sp, 0xc
  027DED  31FD: c7469e0000       mov word ptr [bp - 0x62], 0
  027DF2  3202: eb03             jmp 0x3207
  027DF4  3204: ff469e           inc word ptr [bp - 0x62]
  027DF7  3207: 837e9e06         cmp word ptr [bp - 0x62], 6
  027DFB  320B: 7c03             jl 0x3210
  027DFD  320D: e92e03           jmp 0x353e
  027E00  3210: 8d4698           lea ax, [bp - 0x68]
  027E03  3213: 50               push ax
  027E04  3214: 8d469a           lea ax, [bp - 0x66]
  027E07  3217: 50               push ax
  027E08  3218: 8d46a4           lea ax, [bp - 0x5c]
  027E0B  321B: 50               push ax
  027E0C  321C: 8d4ea6           lea cx, [bp - 0x5a]
  027E0F  321F: 51               push cx
  027E10  3220: ff769e           push word ptr [bp - 0x62]
  027E13  3223: 0e               push cs
  027E14  3224: e8c14b           call 0x7de8
  027E17  3227: 83c40a           add sp, 0xa
  027E1A  322A: ff364008         push word ptr [0x840]
  027E1E  322E: ff363e08         push word ptr [0x83e]
  027E22  3232: ff76a4           push word ptr [bp - 0x5c]
  027E25  3235: b87b00           mov ax, 0x7b
  027E28  3238: 8d1ea82d         lea bx, [0x2da8]
  027E2C  323C: 8b56a6           mov dx, word ptr [bp - 0x5a]
  027E2F  323F: 9a54021f18       lcall 0x181f, 0x254
  027E34  3244: ebbe             jmp 0x3204
  027E36  3246: c646b000         mov byte ptr [bp - 0x50], 0
  027E3A  324A: ff36e82d         push word ptr [0x2de8]
  027E3E  324E: 8d46b0           lea ax, [bp - 0x50]
  027E41  3251: 50               push ax
  027E42  3252: 9a6e011f18       lcall 0x181f, 0x16e
  027E47  3257: 83c404           add sp, 4
  027E4A  325A: 8d46b0           lea ax, [bp - 0x50]
  027E4D  325D: 50               push ax
  027E4E  325E: 9abe011f18       lcall 0x181f, 0x1be
  027E53  3263: 83c402           add sp, 2
  027E56  3266: ff363e03         push word ptr [0x33e]
  027E5A  326A: 9a320b1f18       lcall 0x181f, 0xb32
  027E5F  326F: 83c402           add sp, 2
  027E62  3272: 894690           mov word ptr [bp - 0x70], ax
  027E65  3275: 6bd81c           imul bx, ax, 0x1c
  027E68  3278: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  027E6C  327C: 2aff             sub bh, bh
  027E6E  327E: 8bc3             mov ax, bx
  027E70  3280: d1e3             shl bx, 1
  027E72  3282: 03d8             add bx, ax
  027E74  3284: d1e3             shl bx, 1
  027E76  3286: 03d8             add bx, ax
  027E78  3288: d1e3             shl bx, 1
  027E7A  328A: ffb73052         push word ptr [bx + 0x5230]
  027E7E  328E: 9a22001f18       lcall 0x181f, 0x22
  027E83  3293: 83c402           add sp, 2
  027E86  3296: 52               push dx
  027E87  3297: 50               push ax
  027E88  3298: 8d46b0           lea ax, [bp - 0x50]
  027E8B  329B: 16               push ss
  027E8C  329C: 50               push ax
  027E8D  329D: 9ab4111d0d       lcall 0xd1d, 0x11b4
  027E92  32A2: 83c408           add sp, 8
  027E95  32A5: 6a39             push 0x39
  027E97  32A7: 688400           push 0x84
  027E9A  32AA: 6a54             push 0x54
  027E9C  32AC: 6a79             push 0x79
  027E9E  32AE: 8d46b0           lea ax, [bp - 0x50]
  027EA1  32B1: 16               push ss
  027EA2  32B2: 50               push ax
  027EA3  32B3: 9a00011f18       lcall 0x181f, 0x100
  027EA8  32B8: 83c40c           add sp, 0xc
  027EAB  32BB: c746a49300       mov word ptr [bp - 0x5c], 0x93
  027EB0  32C0: b88200           mov ax, 0x82
  027EB3  32C3: 8946a6           mov word ptr [bp - 0x5a], ax
  027EB6  32C6: 894694           mov word ptr [bp - 0x6c], ax
  027EB9  32C9: c7468c0400       mov word ptr [bp - 0x74], 4
  027EBE  32CE: b81000           mov ax, 0x10
  027EC1  32D1: 8946ae           mov word ptr [bp - 0x52], ax
  027EC4  32D4: 8946aa           mov word ptr [bp - 0x56], ax
  027EC7  32D7: 2bc0             sub ax, ax
  027EC9  32D9: 8946a8           mov word ptr [bp - 0x58], ax
  027ECC  32DC: 8946a2           mov word ptr [bp - 0x5e], ax
  027ECF  32DF: 89469e           mov word ptr [bp - 0x62], ax
  027ED2  32E2: e92901           jmp 0x340e
  027ED5  32E5: 90               nop 
  027ED6  32E6: ff364008         push word ptr [0x840]
  027EDA  32EA: ff363e08         push word ptr [0x83e]
  027EDE  32EE: 8b4692           mov ax, word ptr [bp - 0x6e]
  027EE1  32F1: 0346aa           add ax, word ptr [bp - 0x56]
  027EE4  32F4: 48               dec ax
  027EE5  32F5: 50               push ax
  027EE6  32F6: 6a19             push 0x19
  027EE8  32F8: 6b5e901c         imul bx, word ptr [bp - 0x70], 0x1c
  027EEC  32FC: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  027EF0  3300: 2aff             sub bh, bh
  027EF2  3302: 8bc3             mov ax, bx
  027EF4  3304: d1e3             shl bx, 1
  027EF6  3306: 03d8             add bx, ax
  027EF8  3308: d1e3             shl bx, 1
  027EFA  330A: 03d8             add bx, ax
  027EFC  330C: d1e3             shl bx, 1
  027EFE  330E: 8a873252         mov al, byte ptr [bx + 0x5232]
  027F02  3312: 2ae4             sub ah, ah
  027F04  3314: 8b56ae           mov dx, word ptr [bp - 0x52]
  027F07  3317: d1fa             sar dx, 1
  027F09  3319: 035694           add dx, word ptr [bp - 0x6c]
  027F0C  331C: 8d1ea82d         lea bx, [0x2da8]
  027F10  3320: 9af8021f18       lcall 0x181f, 0x2f8
  027F15  3325: a13e03           mov ax, word ptr [0x33e]
  027F18  3328: 39469e           cmp word ptr [bp - 0x62], ax
  027F1B  332B: 7408             je 0x3335
  027F1D  332D: a14003           mov ax, word ptr [0x340]
  027F20  3330: 39469e           cmp word ptr [bp - 0x62], ax
  027F23  3333: 757d             jne 0x33b2
  027F25  3335: c6468e00         mov byte ptr [bp - 0x72], 0
  027F29  3339: a13e03           mov ax, word ptr [0x33e]
  027F2C  333C: 39469e           cmp word ptr [bp - 0x62], ax
  027F2F  333F: 7504             jne 0x3345
  027F31  3341: c6468e0a         mov byte ptr [bp - 0x72], 0xa
  027F35  3345: 833eee0700       cmp word ptr [0x7ee], 0
  027F3A  334A: 7412             je 0x335e
  027F3C  334C: 833e548d08       cmp word ptr [0x8d54], 8
  027F41  3351: 750b             jne 0x335e
  027F43  3353: 803e8ba800       cmp byte ptr [0xa88b], 0
  027F48  3358: 7504             jne 0x335e
  027F4A  335A: c6468e0f         mov byte ptr [bp - 0x72], 0xf
  027F4E  335E: 833e2e0302       cmp word ptr [0x32e], 2
  027F53  3363: 7513             jne 0x3378
  027F55  3365: 833e340300       cmp word ptr [0x334], 0
  027F5A  336A: 740c             je 0x3378
  027F5C  336C: a14003           mov ax, word ptr [0x340]
  027F5F  336F: 39469e           cmp word ptr [bp - 0x62], ax
  027F62  3372: 7504             jne 0x3378
  027F64  3374: c6468e0f         mov byte ptr [bp - 0x72], 0xf
  027F68  3378: 807e8e00         cmp byte ptr [bp - 0x72], 0
  027F6C  337C: 7434             je 0x33b2
  027F6E  337E: 833e980b00       cmp word ptr [0xb98], 0
  027F73  3383: 752d             jne 0x33b2
  027F75  3385: ff36ae2d         push word ptr [0x2dae]
  027F79  3389: ff36ac2d         push word ptr [0x2dac]
  027F7D  338D: ff36aa2d         push word ptr [0x2daa]
  027F81  3391: ff36a82d         push word ptr [0x2da8]
  027F85  3395: 8b4692           mov ax, word ptr [bp - 0x6e]
  027F88  3398: 0346aa           add ax, word ptr [bp - 0x56]
  027F8B  339B: 50               push ax
  027F8C  339C: 8a468e           mov al, byte ptr [bp - 0x72]
  027F8F  339F: 50               push ax
  027F90  33A0: 8b4694           mov ax, word ptr [bp - 0x6c]
  027F93  33A3: 8bd8             mov bx, ax
  027F95  33A5: 035eae           add bx, word ptr [bp - 0x52]
  027F98  33A8: 48               dec ax
  027F99  33A9: 8b5692           mov dx, word ptr [bp - 0x6e]
  027F9C  33AC: 4a               dec dx
  027F9D  33AD: 9ace001f18       lcall 0x181f, 0xce
  027FA2  33B2: 837ea201         cmp word ptr [bp - 0x5e], 1
  027FA6  33B6: 1bc0             sbb ax, ax
  027FA8  33B8: 250d00           and ax, 0xd
  027FAB  33BB: 050500           add ax, 5
  027FAE  33BE: 014694           add word ptr [bp - 0x6c], ax
  027FB1  33C1: 8b468c           mov ax, word ptr [bp - 0x74]
  027FB4  33C4: ff46a8           inc word ptr [bp - 0x58]
  027FB7  33C7: 3946a8           cmp word ptr [bp - 0x58], ax
  027FBA  33CA: 7c3f             jl 0x340b
  027FBC  33CC: c746a80000       mov word ptr [bp - 0x58], 0
  027FC1  33D1: ff46a2           inc word ptr [bp - 0x5e]
  027FC4  33D4: 837ea201         cmp word ptr [bp - 0x5e], 1
  027FC8  33D8: 7e18             jle 0x33f2
  027FCA  33DA: ff363e03         push word ptr [0x33e]
  027FCE  33DE: 9a320b1f18       lcall 0x181f, 0xb32
  027FD3  33E3: 83c402           add sp, 2
  027FD6  33E6: 894690           mov word ptr [bp - 0x70], ax
  027FD9  33E9: c7469e0000       mov word ptr [bp - 0x62], 0
  027FDE  33EE: e9d600           jmp 0x34c7
  027FE1  33F1: 90               nop 
  027FE2  33F2: c746947c00       mov word ptr [bp - 0x6c], 0x7c
  027FE7  33F7: c746a48b00       mov word ptr [bp - 0x5c], 0x8b
  027FEC  33FC: c7468c1000       mov word ptr [bp - 0x74], 0x10
  027FF1  3401: c746ae0300       mov word ptr [bp - 0x52], 3
  027FF6  3406: c746aa0400       mov word ptr [bp - 0x56], 4
  027FFB  340B: ff469e           inc word ptr [bp - 0x62]
  027FFE  340E: a13c03           mov ax, word ptr [0x33c]
  028001  3411: 39469e           cmp word ptr [bp - 0x62], ax
  028004  3414: 7dc4             jge 0x33da
  028006  3416: ff769e           push word ptr [bp - 0x62]
  028009  3419: 9a320b1f18       lcall 0x181f, 0xb32
  02800E  341E: 83c402           add sp, 2
  028011  3421: 894690           mov word ptr [bp - 0x70], ax
  028014  3424: 8b46a4           mov ax, word ptr [bp - 0x5c]
  028017  3427: 894692           mov word ptr [bp - 0x6e], ax
  02801A  342A: 6b5e901c         imul bx, word ptr [bp - 0x70], 0x1c
  02801E  342E: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  028023  3433: 721b             jb 0x3450
  028025  3435: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  02802A  343A: 7714             ja 0x3450
  02802C  343C: 837ea200         cmp word ptr [bp - 0x5e], 0
  028030  3440: 750e             jne 0x3450
  028032  3442: 48               dec ax
  028033  3443: 894692           mov word ptr [bp - 0x6e], ax
  028036  3446: 837e9e00         cmp word ptr [bp - 0x62], 0
  02803A  344A: 7404             je 0x3450
  02803C  344C: 48               dec ax
  02803D  344D: 894692           mov word ptr [bp - 0x6e], ax
  028040  3450: 837ea200         cmp word ptr [bp - 0x5e], 0
  028044  3454: 7403             je 0x3459
  028046  3456: e98dfe           jmp 0x32e6
  028049  3459: ff7692           push word ptr [bp - 0x6e]
  02804C  345C: 6a10             push 0x10
  02804E  345E: 6a64             push 0x64
  028050  3460: 8b4690           mov ax, word ptr [bp - 0x70]
  028053  3463: 2bd2             sub dx, dx
  028055  3465: 8b5e94           mov bx, word ptr [bp - 0x6c]
  028058  3468: 9abc021f18       lcall 0x181f, 0x2bc
  02805D  346D: e9b5fe           jmp 0x3325
  028060  3470: be2700           mov si, 0x27
  028063  3473: 89769c           mov word ptr [bp - 0x64], si
  028066  3476: 037696           add si, word ptr [bp - 0x6a]
  028069  3479: 8bce             mov cx, si
  02806B  347B: 8bc1             mov ax, cx
  02806D  347D: d1e6             shl si, 1
  02806F  347F: 03f0             add si, ax
  028071  3481: c1e602           shl si, 2
  028074  3484: c41e3e08         les bx, ptr [0x83e]
  028078  3488: 268b403e         mov ax, word ptr es:[bx + si + 0x3e]
  02807C  348C: 8946a0           mov word ptr [bp - 0x60], ax
  02807F  348F: 06               push es
  028080  3490: 53               push bx
  028081  3491: ff76a4           push word ptr [bp - 0x5c]
  028084  3494: d1f8             sar ax, 1
  028086  3496: 8b569a           mov dx, word ptr [bp - 0x66]
  028089  3499: 4a               dec dx
  02808A  349A: d1fa             sar dx, 1
  02808C  349C: 2bd0             sub dx, ax
  02808E  349E: 0356a6           add dx, word ptr [bp - 0x5a]
  028091  34A1: 42               inc dx
  028092  34A2: 8bc1             mov ax, cx
  028094  34A4: 8d1ea82d         lea bx, [0x2da8]
  028098  34A8: eb15             jmp 0x34bf
  02809A  34AA: ff364008         push word ptr [0x840]
  02809E  34AE: ff363e08         push word ptr [0x83e]
  0280A2  34B2: ff76a4           push word ptr [bp - 0x5c]
  0280A5  34B5: b87b00           mov ax, 0x7b
  0280A8  34B8: 8d1ea82d         lea bx, [0x2da8]
  0280AC  34BC: 8b56a6           mov dx, word ptr [bp - 0x5a]
  0280AF  34BF: 9a54021f18       lcall 0x181f, 0x254
  0280B4  34C4: ff469e           inc word ptr [bp - 0x62]
  0280B7  34C7: 837e9e06         cmp word ptr [bp - 0x62], 6
  0280BB  34CB: 7d71             jge 0x353e
  0280BD  34CD: 8d4698           lea ax, [bp - 0x68]
  0280C0  34D0: 50               push ax
  0280C1  34D1: 8d469a           lea ax, [bp - 0x66]
  0280C4  34D4: 50               push ax
  0280C5  34D5: 8d4ea4           lea cx, [bp - 0x5c]
  0280C8  34D8: 51               push cx
  0280C9  34D9: 8d56a6           lea dx, [bp - 0x5a]
  0280CC  34DC: 52               push dx
  0280CD  34DD: ff769e           push word ptr [bp - 0x62]
  0280D0  34E0: 0e               push cs
  0280D1  34E1: e80449           call 0x7de8
  0280D4  34E4: 83c40a           add sp, 0xa
  0280D7  34E7: 6b5e901c         imul bx, word ptr [bp - 0x70], 0x1c
  0280DB  34EB: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  0280DF  34EF: 2aff             sub bh, bh
  0280E1  34F1: 8bc3             mov ax, bx
  0280E3  34F3: d1e3             shl bx, 1
  0280E5  34F5: 03d8             add bx, ax
  0280E7  34F7: d1e3             shl bx, 1
  0280E9  34F9: 03d8             add bx, ax
  0280EB  34FB: d1e3             shl bx, 1
  0280ED  34FD: 8a873752         mov al, byte ptr [bx + 0x5237]
  0280F1  3501: 2ae4             sub ah, ah
  0280F3  3503: 3b469e           cmp ax, word ptr [bp - 0x62]
  0280F6  3506: 7ea2             jle 0x34aa
  0280F8  3508: ff769e           push word ptr [bp - 0x62]
  0280FB  350B: ff7690           push word ptr [bp - 0x70]
  0280FE  350E: 9ae60b1f18       lcall 0x181f, 0xbe6
  028103  3513: 83c404           add sp, 4
  028106  3516: 894696           mov word ptr [bp - 0x6a], ax
  028109  3519: ff769e           push word ptr [bp - 0x62]
  02810C  351C: ff7690           push word ptr [bp - 0x70]
  02810F  351F: 9a680c1f18       lcall 0x181f, 0xc68
  028114  3524: 83c404           add sp, 4
  028117  3527: 8946ac           mov word ptr [bp - 0x54], ax
  02811A  352A: 837e9600         cmp word ptr [bp - 0x6a], 0
  02811E  352E: 7c94             jl 0x34c4
  028120  3530: 3d6400           cmp ax, 0x64
  028123  3533: 7d03             jge 0x3538
  028125  3535: e938ff           jmp 0x3470
  028128  3538: be1700           mov si, 0x17
  02812B  353B: e935ff           jmp 0x3473
  02812E  353E: 837e0600         cmp word ptr [bp + 6], 0
  028132  3542: 7414             je 0x3558
  028134  3544: 688200           push 0x82
  028137  3547: 6a54             push 0x54
  028139  3549: 6a30             push 0x30
  02813B  354B: b87900           mov ax, 0x79
  02813E  354E: ba8200           mov dx, 0x82
  028141  3551: 8bd8             mov bx, ax
  028143  3553: 9ae2001f18       lcall 0x181f, 0xe2
  028148  3558: 5e               pop si
  028149  3559: c9               leave 
  02814A  355A: cb               retf 

; ---- func_02814C  size=82  insns=38  prologue=push bp;mov bp,sp  terminal=RETF ----
  02814C  355C: 55               push bp
  02814D  355D: 8bec             mov bp, sp
  02814F  355F: 6a30             push 0x30
  028151  3561: 6a5b             push 0x5b
  028153  3563: 688200           push 0x82
  028156  3566: 68d300           push 0xd3
  028159  3569: 0e               push cs
  02815A  356A: e86649           call 0x7ed3
  02815D  356D: 8be5             mov sp, bp
  02815F  356F: a03703           mov al, byte ptr [0x337]
  028162  3572: 2ae4             sub ah, ah
  028164  3574: eb12             jmp 0x3588
  028166  3576: 0e               push cs
  028167  3577: e84648           call 0x7dc0
  02816A  357A: eb16             jmp 0x3592
  02816C  357C: 0e               push cs
  02816D  357D: e8e048           call 0x7e60
  028170  3580: eb10             jmp 0x3592
  028172  3582: 0e               push cs
  028173  3583: e82a49           call 0x7eb0
  028176  3586: eb0a             jmp 0x3592
  028178  3588: 0bc0             or ax, ax
  02817A  358A: 74ea             je 0x3576
  02817C  358C: 48               dec ax
  02817D  358D: 74ed             je 0x357c
  02817F  358F: 48               dec ax
  028180  3590: 74f0             je 0x3582
  028182  3592: 837e0600         cmp word ptr [bp + 6], 0
  028186  3596: 7414             je 0x35ac
  028188  3598: 688200           push 0x82
  02818B  359B: 6a5b             push 0x5b
  02818D  359D: 6a30             push 0x30
  02818F  359F: b8d300           mov ax, 0xd3
  028192  35A2: ba8200           mov dx, 0x82
  028195  35A5: 8bd8             mov bx, ax
  028197  35A7: 9ae2001f18       lcall 0x181f, 0xe2
  02819C  35AC: c9               leave 
  02819D  35AD: cb               retf 

; ---- func_02819E  size=55  insns=19  prologue=ENTER 0x0004,0  terminal=RETF ----
  02819E  35AE: c8040000         enter 4, 0
  0281A2  35B2: 6b460613         imul ax, word ptr [bp + 6], 0x13
  0281A6  35B6: 40               inc ax
  0281A7  35B7: 833e980b00       cmp word ptr [0xb98], 0
  0281AC  35BC: 7525             jne 0x35e3
  0281AE  35BE: ff36ae2d         push word ptr [0x2dae]
  0281B2  35C2: ff36ac2d         push word ptr [0x2dac]
  0281B6  35C6: ff36aa2d         push word ptr [0x2daa]
  0281BA  35CA: ff36a82d         push word ptr [0x2da8]
  0281BE  35CE: 68c700           push 0xc7
  0281C1  35D1: 8a4e08           mov cl, byte ptr [bp + 8]
  0281C4  35D4: 51               push cx
  0281C5  35D5: 8bd8             mov bx, ax
  0281C7  35D7: 83c312           add bx, 0x12
  0281CA  35DA: 48               dec ax
  0281CB  35DB: bab300           mov dx, 0xb3
  0281CE  35DE: 9ace001f18       lcall 0x181f, 0xce
  0281D3  35E3: c9               leave 
  0281D4  35E4: cb               retf 

; ---- func_0281D6  size=598  insns=208  prologue=ENTER 0x0080,0  terminal=RETF ----
  0281D6  35E6: c8800000         enter 0x80, 0
  0281DA  35EA: 56               push si
  0281DB  35EB: 6a15             push 0x15
  0281DD  35ED: 684001           push 0x140
  0281E0  35F0: 68b300           push 0xb3
  0281E3  35F3: 6a00             push 0
  0281E5  35F5: 0e               push cs
  0281E6  35F6: e8da48           call 0x7ed3
  0281E9  35F9: 83c408           add sp, 8
  0281EC  35FC: c746920100       mov word ptr [bp - 0x6e], 1
  0281F1  3601: c7468eb500       mov word ptr [bp - 0x72], 0xb5
  0281F6  3606: c746820000       mov word ptr [bp - 0x7e], 0
  0281FB  360B: eb34             jmp 0x3641
  0281FD  360D: 90               nop 
  0281FE  360E: 6a0a             push 0xa
  028200  3610: 8d46aa           lea ax, [bp - 0x56]
  028203  3613: 50               push ax
  028204  3614: ff768a           push word ptr [bp - 0x76]
  028207  3617: 9afa081d0d       lcall 0xd1d, 0x8fa
  02820C  361C: 83c406           add sp, 6
  02820F  361F: ff76fa           push word ptr [bp - 6]
  028212  3622: ff7684           push word ptr [bp - 0x7c]
  028215  3625: 8b4688           mov ax, word ptr [bp - 0x78]
  028218  3628: 40               inc ax
  028219  3629: 50               push ax
  02821A  362A: 8d46aa           lea ax, [bp - 0x56]
  02821D  362D: 16               push ss
  02821E  362E: 50               push ax
  02821F  362F: 9a3c011f18       lcall 0x181f, 0x13c
  028224  3634: 83c40a           add sp, 0xa
  028227  3637: 894688           mov word ptr [bp - 0x78], ax
  02822A  363A: 83469213         add word ptr [bp - 0x6e], 0x13
  02822E  363E: ff4682           inc word ptr [bp - 0x7e]
  028231  3641: 837e8210         cmp word ptr [bp - 0x7e], 0x10
  028235  3645: 7c03             jl 0x364a
  028237  3647: e95a01           jmp 0x37a4
  02823A  364A: ff364008         push word ptr [0x840]
  02823E  364E: ff363e08         push word ptr [0x83e]
  028242  3652: ff768e           push word ptr [bp - 0x72]
  028245  3655: 8b4682           mov ax, word ptr [bp - 0x7e]
  028248  3658: 8bf0             mov si, ax
  02824A  365A: 8bc8             mov cx, ax
  02824C  365C: d1e6             shl si, 1
  02824E  365E: 03f1             add si, cx
  028250  3660: c1e602           shl si, 2
  028253  3663: 051700           add ax, 0x17
  028256  3666: 8b5692           mov dx, word ptr [bp - 0x6e]
  028259  3669: c41e3e08         les bx, ptr [0x83e]
  02825D  366D: 268b885201       mov cx, word ptr es:[bx + si + 0x152]
  028262  3672: d1f9             sar cx, 1
  028264  3674: 2bd1             sub dx, cx
  028266  3676: 83c209           add dx, 9
  028269  3679: 895680           mov word ptr [bp - 0x80], dx
  02826C  367C: 8d1ea82d         lea bx, [0x2da8]
  028270  3680: 9a54021f18       lcall 0x181f, 0x254
  028275  3685: c646aa00         mov byte ptr [bp - 0x56], 0
  028279  3689: 6a0a             push 0xa
  02827B  368B: 8d4696           lea ax, [bp - 0x6a]
  02827E  368E: 50               push ax
  02827F  368F: 8b7682           mov si, word ptr [bp - 0x7e]
  028282  3692: d1e6             shl si, 1
  028284  3694: 8b1e4285         mov bx, word ptr [0x8542]
  028288  3698: ffb09a00         push word ptr [bx + si + 0x9a]
  02828C  369C: 9afa081d0d       lcall 0xd1d, 0x8fa
  028291  36A1: 83c406           add sp, 6
  028294  36A4: 8d4696           lea ax, [bp - 0x6a]
  028297  36A7: 50               push ax
  028298  36A8: 8d46aa           lea ax, [bp - 0x56]
  02829B  36AB: 50               push ax
  02829C  36AC: 9aa4071d0d       lcall 0xd1d, 0x7a4
  0282A1  36B1: 83c404           add sp, 4
  0282A4  36B4: c74684c200       mov word ptr [bp - 0x7c], 0xc2
  0282A9  36B9: ff36a008         push word ptr [0x8a0]
  0282AD  36BD: ff369e08         push word ptr [0x89e]
  0282B1  36C1: 8d46aa           lea ax, [bp - 0x56]
  0282B4  36C4: 16               push ss
  0282B5  36C5: 50               push ax
  0282B6  36C6: 2bc0             sub ax, ax
  0282B8  36C8: 9a04021f18       lcall 0x181f, 0x204
  0282BD  36CD: 40               inc ax
  0282BE  36CE: 8946fc           mov word ptr [bp - 4], ax
  0282C1  36D1: d1f8             sar ax, 1
  0282C3  36D3: 2b4692           sub ax, word ptr [bp - 0x6e]
  0282C6  36D6: f7d8             neg ax
  0282C8  36D8: 050900           add ax, 9
  0282CB  36DB: 894688           mov word ptr [bp - 0x78], ax
  0282CE  36DE: c746940f00       mov word ptr [bp - 0x6c], 0xf
  0282D3  36E3: 8b1e4285         mov bx, word ptr [0x8542]
  0282D7  36E7: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  0282DB  36EB: b96400           mov cx, 0x64
  0282DE  36EE: 8bd8             mov bx, ax
  0282E0  36F0: 99               cdq 
  0282E1  36F1: f7f9             idiv cx
  0282E3  36F3: 894690           mov word ptr [bp - 0x70], ax
  0282E6  36F6: 8bc3             mov ax, bx
  0282E8  36F8: 99               cdq 
  0282E9  36F9: f7f9             idiv cx
  0282EB  36FB: 89568a           mov word ptr [bp - 0x76], dx
  0282EE  36FE: c746fe9400       mov word ptr [bp - 2], 0x94
  0282F3  3703: c746fa3d00       mov word ptr [bp - 6], 0x3d
  0282F8  3708: 6a12             push 0x12
  0282FA  370A: 9afc091f18       lcall 0x181f, 0x9fc
  0282FF  370F: 83c402           add sp, 2
  028302  3712: 0bc0             or ax, ax
  028304  3714: 7414             je 0x372a
  028306  3716: ff7682           push word ptr [bp - 0x7e]
  028309  3719: 9afe0c1f18       lcall 0x181f, 0xcfe
  02830E  371E: 83c402           add sp, 2
  028311  3721: 0bc0             or ax, ax
  028313  3723: 7405             je 0x372a
  028315  3725: c746fa0a00       mov word ptr [bp - 6], 0xa
  02831A  372A: 837e8200         cmp word ptr [bp - 0x7e], 0
  02831E  372E: 741e             je 0x374e
  028320  3730: 9a3a0d1f18       lcall 0x181f, 0xd3a
  028325  3735: 8b7682           mov si, word ptr [bp - 0x7e]
  028328  3738: d1e6             shl si, 1
  02832A  373A: 8b1e4285         mov bx, word ptr [0x8542]
  02832E  373E: 39809a00         cmp word ptr [bx + si + 0x9a], ax
  028332  3742: 7e0a             jle 0x374e
  028334  3744: c746fe0c00       mov word ptr [bp - 2], 0xc
  028339  3749: c746fa0400       mov word ptr [bp - 6], 4
  02833E  374E: 837e9000         cmp word ptr [bp - 0x70], 0
  028342  3752: 7f03             jg 0x3757
  028344  3754: e9b7fe           jmp 0x360e
  028347  3757: 6a0a             push 0xa
  028349  3759: 8d46aa           lea ax, [bp - 0x56]
  02834C  375C: 50               push ax
  02834D  375D: ff7690           push word ptr [bp - 0x70]
  028350  3760: 9afa081d0d       lcall 0xd1d, 0x8fa
  028355  3765: 83c406           add sp, 6
  028358  3768: ff76fe           push word ptr [bp - 2]
  02835B  376B: ff7684           push word ptr [bp - 0x7c]
  02835E  376E: 8b4688           mov ax, word ptr [bp - 0x78]
  028361  3771: 40               inc ax
  028362  3772: 50               push ax
  028363  3773: 8d46aa           lea ax, [bp - 0x56]
  028366  3776: 16               push ss
  028367  3777: 50               push ax
  028368  3778: 9a3c011f18       lcall 0x181f, 0x13c
  02836D  377D: 83c40a           add sp, 0xa
  028370  3780: 894688           mov word ptr [bp - 0x78], ax
  028373  3783: c646aa00         mov byte ptr [bp - 0x56], 0
  028377  3787: 8d46aa           lea ax, [bp - 0x56]
  02837A  378A: 16               push ss
  02837B  378B: 50               push ax
  02837C  378C: 8b468a           mov ax, word ptr [bp - 0x76]
  02837F  378F: ba0200           mov dx, 2
  028382  3792: 9a9a0e1f18       lcall 0x181f, 0xe9a
  028387  3797: ff76fa           push word ptr [bp - 6]
  02838A  379A: ff7684           push word ptr [bp - 0x7c]
  02838D  379D: ff7688           push word ptr [bp - 0x78]
  028390  37A0: e987fe           jmp 0x362a
  028393  37A3: 90               nop 
  028394  37A4: c746820000       mov word ptr [bp - 0x7e], 0
  028399  37A9: a03a03           mov al, byte ptr [0x33a]
  02839C  37AC: 2ae4             sub ah, ah
  02839E  37AE: 3b4682           cmp ax, word ptr [bp - 0x7e]
  0283A1  37B1: 7545             jne 0x37f8
  0283A3  37B3: 6a0a             push 0xa
  0283A5  37B5: 50               push ax
  0283A6  37B6: 0e               push cs
  0283A7  37B7: e82946           call 0x7de3
  0283AA  37BA: 83c404           add sp, 4
  0283AD  37BD: 833eee0700       cmp word ptr [0x7ee], 0
  0283B2  37C2: 7413             je 0x37d7
  0283B4  37C4: 833e548d05       cmp word ptr [0x8d54], 5
  0283B9  37C9: 750c             jne 0x37d7
  0283BB  37CB: 6a0e             push 0xe
  0283BD  37CD: ff7682           push word ptr [bp - 0x7e]
  0283C0  37D0: 0e               push cs
  0283C1  37D1: e80f46           call 0x7de3
  0283C4  37D4: 83c404           add sp, 4
  0283C7  37D7: 833e2e0304       cmp word ptr [0x32e], 4
  0283CC  37DC: 751a             jne 0x37f8
  0283CE  37DE: 833e340300       cmp word ptr [0x334], 0
  0283D3  37E3: 7413             je 0x37f8
  0283D5  37E5: 803e9d0b00       cmp byte ptr [0xb9d], 0
  0283DA  37EA: 750c             jne 0x37f8
  0283DC  37EC: 6a0e             push 0xe
  0283DE  37EE: ff7682           push word ptr [bp - 0x7e]
  0283E1  37F1: 0e               push cs
  0283E2  37F2: e8ee45           call 0x7de3
  0283E5  37F5: 83c404           add sp, 4
  0283E8  37F8: ff4682           inc word ptr [bp - 0x7e]
  0283EB  37FB: 837e8210         cmp word ptr [bp - 0x7e], 0x10
  0283EF  37FF: 7ca8             jl 0x37a9
  0283F1  3801: 6a0f             push 0xf
  0283F3  3803: 68b300           push 0xb3
  0283F6  3806: 683201           push 0x132
  0283F9  3809: ff365e2f         push word ptr [0x2f5e]
  0283FD  380D: 9a22001f18       lcall 0x181f, 0x22
  028402  3812: 83c402           add sp, 2
  028405  3815: 52               push dx
  028406  3816: 50               push ax
  028407  3817: 9a3c011f18       lcall 0x181f, 0x13c
  02840C  381C: 83c40a           add sp, 0xa
  02840F  381F: 837e0600         cmp word ptr [bp + 6], 0
  028413  3823: 7414             je 0x3839
  028415  3825: 68b300           push 0xb3
  028418  3828: 684001           push 0x140
  02841B  382B: 6a15             push 0x15
  02841D  382D: 2bc0             sub ax, ax
  02841F  382F: bab300           mov dx, 0xb3
  028422  3832: 2bdb             sub bx, bx
  028424  3834: 9ae2001f18       lcall 0x181f, 0xe2
  028429  3839: 5e               pop si
  02842A  383A: c9               leave 
  02842B  383B: cb               retf 

; ---- func_02842C  size=57  insns=26  prologue=push bp;mov bp,sp  terminal=RETF ----
  02842C  383C: 55               push bp
  02842D  383D: 8bec             mov bp, sp
  02842F  383F: 56               push si
  028430  3840: 8b5e08           mov bx, word ptr [bp + 8]
  028433  3843: 8bc3             mov ax, bx
  028435  3845: d1e3             shl bx, 1
  028437  3847: 03d8             add bx, ax
  028439  3849: c1e302           shl bx, 2
  02843C  384C: 031e3e08         add bx, word ptr [0x83e]
  028440  3850: 8e064008         mov es, word ptr [0x840]
  028444  3854: 268b473e         mov ax, word ptr es:[bx + 0x3e]
  028448  3858: 8b760a           mov si, word ptr [bp + 0xa]
  02844B  385B: 8904             mov word ptr [si], ax
  02844D  385D: 268b4740         mov ax, word ptr es:[bx + 0x40]
  028451  3861: 8b5e0c           mov bx, word ptr [bp + 0xc]
  028454  3864: 8907             mov word ptr [bx], ax
  028456  3866: 40               inc ax
  028457  3867: 40               inc ax
  028458  3868: f76e06           imul word ptr [bp + 6]
  02845B  386B: 48               dec ax
  02845C  386C: 48               dec ax
  02845D  386D: 8b5e0e           mov bx, word ptr [bp + 0xe]
  028460  3870: 8907             mov word ptr [bx], ax
  028462  3872: 5e               pop si
  028463  3873: c9               leave 
  028464  3874: cb               retf 

; ---- func_028466  size=214  insns=76  prologue=ENTER 0x000C,0  terminal=RETF ----
  028466  3876: c80c0000         enter 0xc, 0
  02846A  387A: 8d46f4           lea ax, [bp - 0xc]
  02846D  387D: 50               push ax
  02846E  387E: 8d46f6           lea ax, [bp - 0xa]
  028471  3881: 50               push ax
  028472  3882: 8d46fe           lea ax, [bp - 2]
  028475  3885: 50               push ax
  028476  3886: ff760a           push word ptr [bp + 0xa]
  028479  3889: ff7608           push word ptr [bp + 8]
  02847C  388C: 0e               push cs
  02847D  388D: e85c46           call 0x7eec
  028480  3890: 83c40a           add sp, 0xa
  028483  3893: c746f80000       mov word ptr [bp - 8], 0
  028488  3898: eb48             jmp 0x38e2
  02848A  389A: ff36ae2d         push word ptr [0x2dae]
  02848E  389E: ff36ac2d         push word ptr [0x2dac]
  028492  38A2: ff36aa2d         push word ptr [0x2daa]
  028496  38A6: ff36a82d         push word ptr [0x2da8]
  02849A  38AA: 0346f6           add ax, word ptr [bp - 0xa]
  02849D  38AD: 50               push ax
  02849E  38AE: 6a3f             push 0x3f
  0284A0  38B0: 8b46fc           mov ax, word ptr [bp - 4]
  0284A3  38B3: 8b5efe           mov bx, word ptr [bp - 2]
  0284A6  38B6: 03d8             add bx, ax
  0284A8  38B8: 40               inc ax
  0284A9  38B9: 8b56fa           mov dx, word ptr [bp - 6]
  0284AC  38BC: 42               inc dx
  0284AD  38BD: 9ace001f18       lcall 0x181f, 0xce
  0284B2  38C2: ff364008         push word ptr [0x840]
  0284B6  38C6: ff363e08         push word ptr [0x83e]
  0284BA  38CA: ff76fa           push word ptr [bp - 6]
  0284BD  38CD: 8b460a           mov ax, word ptr [bp + 0xa]
  0284C0  38D0: 0346f8           add ax, word ptr [bp - 8]
  0284C3  38D3: 8d1ea82d         lea bx, [0x2da8]
  0284C7  38D7: 8b56fc           mov dx, word ptr [bp - 4]
  0284CA  38DA: 9a54021f18       lcall 0x181f, 0x254
  0284CF  38DF: ff46f8           inc word ptr [bp - 8]
  0284D2  38E2: 8b46f8           mov ax, word ptr [bp - 8]
  0284D5  38E5: 394608           cmp word ptr [bp + 8], ax
  0284D8  38E8: 7e60             jle 0x394a
  0284DA  38EA: c746fc2f01       mov word ptr [bp - 4], 0x12f
  0284DF  38EF: 8b4ef6           mov cx, word ptr [bp - 0xa]
  0284E2  38F2: 41               inc cx
  0284E3  38F3: 41               inc cx
  0284E4  38F4: f7e9             imul cx
  0284E6  38F6: 058400           add ax, 0x84
  0284E9  38F9: 8946fa           mov word ptr [bp - 6], ax
  0284EC  38FC: 8b4ef8           mov cx, word ptr [bp - 8]
  0284EF  38FF: 394e06           cmp word ptr [bp + 6], cx
  0284F2  3902: 7596             jne 0x389a
  0284F4  3904: ff36ae2d         push word ptr [0x2dae]
  0284F8  3908: ff36ac2d         push word ptr [0x2dac]
  0284FC  390C: ff36aa2d         push word ptr [0x2daa]
  028500  3910: ff36a82d         push word ptr [0x2da8]
  028504  3914: 0346f6           add ax, word ptr [bp - 0xa]
  028507  3917: 48               dec ax
  028508  3918: 50               push ax
  028509  3919: 6a3f             push 0x3f
  02850B  391B: 8b56fa           mov dx, word ptr [bp - 6]
  02850E  391E: 8b5efe           mov bx, word ptr [bp - 2]
  028511  3921: 81c32e01         add bx, 0x12e
  028515  3925: b82f01           mov ax, 0x12f
  028518  3928: 9ace001f18       lcall 0x181f, 0xce
  02851D  392D: ff364008         push word ptr [0x840]
  028521  3931: ff363e08         push word ptr [0x83e]
  028525  3935: 8b46fa           mov ax, word ptr [bp - 6]
  028528  3938: 40               inc ax
  028529  3939: 50               push ax
  02852A  393A: 8b460a           mov ax, word ptr [bp + 0xa]
  02852D  393D: 0346f8           add ax, word ptr [bp - 8]
  028530  3940: 8d1ea82d         lea bx, [0x2da8]
  028534  3944: ba3001           mov dx, 0x130
  028537  3947: eb91             jmp 0x38da
  028539  3949: 90               nop 
  02853A  394A: c9               leave 
  02853B  394B: cb               retf 

; ---- func_02853C  size=85  insns=34  prologue=ENTER 0x0002,0  terminal=RETF ----
  02853C  394C: c8020000         enter 2, 0
  028540  3950: 6a2d             push 0x2d
  028542  3952: 6a11             push 0x11
  028544  3954: 688400           push 0x84
  028547  3957: 682f01           push 0x12f
  02854A  395A: 0e               push cs
  02854B  395B: e87545           call 0x7ed3
  02854E  395E: 83c408           add sp, 8
  028551  3961: 833e980b00       cmp word ptr [0xb98], 0
  028556  3966: 751d             jne 0x3985
  028558  3968: 6a44             push 0x44
  02855A  396A: 6a03             push 3
  02855C  396C: 837e0800         cmp word ptr [bp + 8], 0
  028560  3970: 7406             je 0x3978
  028562  3972: a03903           mov al, byte ptr [0x339]
  028565  3975: eb04             jmp 0x397b
  028567  3977: 90               nop 
  028568  3978: a03703           mov al, byte ptr [0x337]
  02856B  397B: 2ae4             sub ah, ah
  02856D  397D: 50               push ax
  02856E  397E: 0e               push cs
  02856F  397F: e80744           call 0x7d89
  028572  3982: 83c406           add sp, 6
  028575  3985: 837e0600         cmp word ptr [bp + 6], 0
  028579  3989: 7414             je 0x399f
  02857B  398B: 688400           push 0x84
  02857E  398E: 6a11             push 0x11
  028580  3990: 6a2d             push 0x2d
  028582  3992: b82f01           mov ax, 0x12f
  028585  3995: ba8400           mov dx, 0x84
  028588  3998: 8bd8             mov bx, ax
  02858A  399A: 9ae2001f18       lcall 0x181f, 0xe2
  02858F  399F: c9               leave 
  028590  39A0: cb               retf 

; ---- func_028592  size=512  insns=212  prologue=push bp;mov bp,sp  terminal=RETF ----
  028592  39A2: 55               push bp
  028593  39A3: 8bec             mov bp, sp
  028595  39A5: 9a220c1f18       lcall 0x181f, 0xc22
  02859A  39AA: 0e               push cs
  02859B  39AB: e8bc44           call 0x7e6a
  02859E  39AE: 0e               push cs
  02859F  39AF: e82b45           call 0x7edd
  0285A2  39B2: 68c800           push 0xc8
  0285A5  39B5: 684001           push 0x140
  0285A8  39B8: 6a00             push 0
  0285AA  39BA: 6a00             push 0
  0285AC  39BC: 0e               push cs
  0285AD  39BD: e81345           call 0x7ed3
  0285B0  39C0: 8be5             mov sp, bp
  0285B2  39C2: 6a00             push 0
  0285B4  39C4: 0e               push cs
  0285B5  39C5: e82e45           call 0x7ef6
  0285B8  39C8: 8be5             mov sp, bp
  0285BA  39CA: 6a00             push 0
  0285BC  39CC: 0e               push cs
  0285BD  39CD: e8e143           call 0x7db1
  0285C0  39D0: 8be5             mov sp, bp
  0285C2  39D2: 6a00             push 0
  0285C4  39D4: 0e               push cs
  0285C5  39D5: e81544           call 0x7ded
  0285C8  39D8: 8be5             mov sp, bp
  0285CA  39DA: 6a00             push 0
  0285CC  39DC: 0e               push cs
  0285CD  39DD: e84944           call 0x7e29
  0285D0  39E0: 8be5             mov sp, bp
  0285D2  39E2: 6a00             push 0
  0285D4  39E4: 6a00             push 0
  0285D6  39E6: 0e               push cs
  0285D7  39E7: e80d44           call 0x7df7
  0285DA  39EA: 8be5             mov sp, bp
  0285DC  39EC: 6a00             push 0
  0285DE  39EE: 0e               push cs
  0285DF  39EF: e81944           call 0x7e0b
  0285E2  39F2: 8be5             mov sp, bp
  0285E4  39F4: 6a00             push 0
  0285E6  39F6: 0e               push cs
  0285E7  39F7: e89943           call 0x7d93
  0285EA  39FA: 8be5             mov sp, bp
  0285EC  39FC: 6a00             push 0
  0285EE  39FE: 0e               push cs
  0285EF  39FF: e88c43           call 0x7d8e
  0285F2  3A02: 8be5             mov sp, bp
  0285F4  3A04: 837e0600         cmp word ptr [bp + 6], 0
  0285F8  3A08: 7412             je 0x3a1c
  0285FA  3A0A: 6a00             push 0
  0285FC  3A0C: 684001           push 0x140
  0285FF  3A0F: 68c800           push 0xc8
  028602  3A12: 2bc0             sub ax, ax
  028604  3A14: 99               cdq 
  028605  3A15: 2bdb             sub bx, bx
  028607  3A17: 9ae2001f18       lcall 0x181f, 0xe2
  02860C  3A1C: c9               leave 
  02860D  3A1D: cb               retf 
  02860E  3A1E: 0e               push cs
  02860F  3A1F: e87f44           call 0x7ea1
  028612  3A22: 6a01             push 1
  028614  3A24: 0e               push cs
  028615  3A25: e8fc43           call 0x7e24
  028618  3A28: 83c402           add sp, 2
  02861B  3A2B: cb               retf 
  02861C  3A2C: 833e340301       cmp word ptr [0x334], 1
  028621  3A31: 1bc0             sbb ax, ax
  028623  3A33: f7d8             neg ax
  028625  3A35: a33403           mov word ptr [0x334], ax
  028628  3A38: a12e03           mov ax, word ptr [0x32e]
  02862B  3A3B: eb3d             jmp 0x3a7a
  02862D  3A3D: 90               nop 
  02862E  3A3E: 6a01             push 1
  028630  3A40: 0e               push cs
  028631  3A41: e8a943           call 0x7ded
  028634  3A44: 83c402           add sp, 2
  028637  3A47: eb41             jmp 0x3a8a
  028639  3A49: 90               nop 
  02863A  3A4A: 803e9f0b00       cmp byte ptr [0xb9f], 0
  02863F  3A4F: 7539             jne 0x3a8a
  028641  3A51: 6a01             push 1
  028643  3A53: 0e               push cs
  028644  3A54: e85a43           call 0x7db1
  028647  3A57: ebeb             jmp 0x3a44
  028649  3A59: 90               nop 
  02864A  3A5A: 803e9d0b00       cmp byte ptr [0xb9d], 0
  02864F  3A5F: 7529             jne 0x3a8a
  028651  3A61: 6a01             push 1
  028653  3A63: 0e               push cs
  028654  3A64: e8c243           call 0x7e29
  028657  3A67: ebdb             jmp 0x3a44
  028659  3A69: 90               nop 
  02865A  3A6A: 6a01             push 1
  02865C  3A6C: 0e               push cs
  02865D  3A6D: e82343           call 0x7d93
  028660  3A70: ebd2             jmp 0x3a44
  028662  3A72: 6a01             push 1
  028664  3A74: 0e               push cs
  028665  3A75: e89343           call 0x7e0b
  028668  3A78: ebca             jmp 0x3a44
  02866A  3A7A: 0bc0             or ax, ax
  02866C  3A7C: 74cc             je 0x3a4a
  02866E  3A7E: 48               dec ax
  02866F  3A7F: 74bd             je 0x3a3e
  028671  3A81: 48               dec ax
  028672  3A82: 74ee             je 0x3a72
  028674  3A84: 48               dec ax
  028675  3A85: 74e3             je 0x3a6a
  028677  3A87: 48               dec ax
  028678  3A88: 74d0             je 0x3a5a
  02867A  3A8A: 803e370302       cmp byte ptr [0x337], 2
  02867F  3A8F: 750e             jne 0x3a9f
  028681  3A91: 8b1e4285         mov bx, word ptr [0x8542]
  028685  3A95: f6471c80         test byte ptr [bx + 0x1c], 0x80
  028689  3A99: 7404             je 0x3a9f
  02868B  3A9B: 0e               push cs
  02868C  3A9C: e8f843           call 0x7e97
  02868F  3A9F: cb               retf 
  028690  3AA0: c70634030100     mov word ptr [0x334], 1
  028696  3AA6: 9afa0b1f18       lcall 0x181f, 0xbfa
  02869B  3AAB: 6a01             push 1
  02869D  3AAD: 0e               push cs
  02869E  3AAE: e83c43           call 0x7ded
  0286A1  3AB1: 83c402           add sp, 2
  0286A4  3AB4: 6a01             push 1
  0286A6  3AB6: 0e               push cs
  0286A7  3AB7: e8d442           call 0x7d8e
  0286AA  3ABA: 83c402           add sp, 2
  0286AD  3ABD: 6a01             push 1
  0286AF  3ABF: 0e               push cs
  0286B0  3AC0: e8ee42           call 0x7db1
  0286B3  3AC3: 83c402           add sp, 2
  0286B6  3AC6: 6a01             push 1
  0286B8  3AC8: 0e               push cs
  0286B9  3AC9: e8c742           call 0x7d93
  0286BC  3ACC: 83c402           add sp, 2
  0286BF  3ACF: 6a01             push 1
  0286C1  3AD1: 0e               push cs
  0286C2  3AD2: e83643           call 0x7e0b
  0286C5  3AD5: 83c402           add sp, 2
  0286C8  3AD8: 6a01             push 1
  0286CA  3ADA: 0e               push cs
  0286CB  3ADB: e84b43           call 0x7e29
  0286CE  3ADE: 83c402           add sp, 2
  0286D1  3AE1: 6a01             push 1
  0286D3  3AE3: 0e               push cs
  0286D4  3AE4: e80f44           call 0x7ef6
  0286D7  3AE7: 83c402           add sp, 2
  0286DA  3AEA: f606825380       test byte ptr [0x5382], 0x80
  0286DF  3AEF: 7423             je 0x3b14
  0286E1  3AF1: f606805310       test byte ptr [0x5380], 0x10
  0286E6  3AF6: 751c             jne 0x3b14
  0286E8  3AF8: 833e328e00       cmp word ptr [0x8e32], 0
  0286ED  3AFD: 7507             jne 0x3b06
  0286EF  3AFF: 833e5a8e00       cmp word ptr [0x8e5a], 0
  0286F4  3B04: 740e             je 0x3b14
  0286F6  3B06: 8d1ead0b         lea bx, [0xbad]
  0286FA  3B0A: 9afe031f18       lcall 0x181f, 0x3fe
  0286FF  3B0F: 800e805310       or byte ptr [0x5380], 0x10
  028704  3B14: 9a06000c0c       lcall 0xc0c, 6
  028709  3B19: 051400           add ax, 0x14
  02870C  3B1C: 83d200           adc dx, 0
  02870F  3B1F: a35a8d           mov word ptr [0x8d5a], ax
  028712  3B22: 89165c8d         mov word ptr [0x8d5c], dx
  028716  3B26: 9a06000c0c       lcall 0xc0c, 6
  02871B  3B2B: 050800           add ax, 8
  02871E  3B2E: 83d200           adc dx, 0
  028721  3B31: a35e8d           mov word ptr [0x8d5e], ax
  028724  3B34: 8916608d         mov word ptr [0x8d60], dx
  028728  3B38: cb               retf 
  028729  3B39: 90               nop 
  02872A  3B3A: c70634030100     mov word ptr [0x334], 1
  028730  3B40: 9afa0b1f18       lcall 0x181f, 0xbfa
  028735  3B45: 6a01             push 1
  028737  3B47: 0e               push cs
  028738  3B48: e8a242           call 0x7ded
  02873B  3B4B: 83c402           add sp, 2
  02873E  3B4E: 6a01             push 1
  028740  3B50: 0e               push cs
  028741  3B51: e83a42           call 0x7d8e
  028744  3B54: 83c402           add sp, 2
  028747  3B57: 6a01             push 1
  028749  3B59: 0e               push cs
  02874A  3B5A: e85442           call 0x7db1
  02874D  3B5D: 83c402           add sp, 2
  028750  3B60: 6a00             push 0
  028752  3B62: 6a01             push 1
  028754  3B64: 0e               push cs
  028755  3B65: e88f42           call 0x7df7
  028758  3B68: 83c404           add sp, 4
  02875B  3B6B: 6a01             push 1
  02875D  3B6D: 0e               push cs
  02875E  3B6E: e82242           call 0x7d93
  028761  3B71: 83c402           add sp, 2
  028764  3B74: 6a01             push 1
  028766  3B76: 0e               push cs
  028767  3B77: e89142           call 0x7e0b
  02876A  3B7A: 83c402           add sp, 2
  02876D  3B7D: 6a01             push 1
  02876F  3B7F: 0e               push cs
  028770  3B80: e8a642           call 0x7e29
  028773  3B83: 83c402           add sp, 2
  028776  3B86: 6a01             push 1
  028778  3B88: 0e               push cs
  028779  3B89: e86a43           call 0x7ef6
  02877C  3B8C: 83c402           add sp, 2
  02877F  3B8F: 9a06000c0c       lcall 0xc0c, 6
  028784  3B94: 051400           add ax, 0x14
  028787  3B97: 83d200           adc dx, 0
  02878A  3B9A: a35a8d           mov word ptr [0x8d5a], ax
  02878D  3B9D: 89165c8d         mov word ptr [0x8d5c], dx
  028791  3BA1: cb               retf 

; ---- func_028792  size=32  insns=13  prologue=push bp;mov bp,sp  terminal=RETF ----
  028792  3BA2: 55               push bp
  028793  3BA3: 8bec             mov bp, sp
  028795  3BA5: ff760a           push word ptr [bp + 0xa]
  028798  3BA8: ff7608           push word ptr [bp + 8]
  02879B  3BAB: ff7606           push word ptr [bp + 6]
  02879E  3BAE: 9a92001f18       lcall 0x181f, 0x92
  0287A3  3BB3: 8be5             mov sp, bp
  0287A5  3BB5: 6a00             push 0
  0287A7  3BB7: 6a00             push 0
  0287A9  3BB9: 6a01             push 1
  0287AB  3BBB: 9ab0001f18       lcall 0x181f, 0xb0
  0287B0  3BC0: c9               leave 
  0287B1  3BC1: cb               retf 

; ---- func_0287B2  size=19  insns=8  prologue=push bp;mov bp,sp  terminal=RETF ----
  0287B2  3BC2: 55               push bp
  0287B3  3BC3: 8bec             mov bp, sp
  0287B5  3BC5: 8b5e06           mov bx, word ptr [bp + 6]
  0287B8  3BC8: d1e3             shl bx, 1
  0287BA  3BCA: ffb7b293         push word ptr [bx - 0x6c4e]
  0287BE  3BCE: 9a74001f18       lcall 0x181f, 0x74
  0287C3  3BD3: c9               leave 
  0287C4  3BD4: cb               retf 

; ---- func_0287C6  size=35  insns=16  prologue=push bp;mov bp,sp  terminal=RETF ----
  0287C6  3BD6: 55               push bp
  0287C7  3BD7: 8bec             mov bp, sp
  0287C9  3BD9: 6a01             push 1
  0287CB  3BDB: 9a56001f18       lcall 0x181f, 0x56
  0287D0  3BE0: 8be5             mov sp, bp
  0287D2  3BE2: ff7606           push word ptr [bp + 6]
  0287D5  3BE5: 0e               push cs
  0287D6  3BE6: e8e042           call 0x7ec9
  0287D9  3BE9: 8be5             mov sp, bp
  0287DB  3BEB: ff760a           push word ptr [bp + 0xa]
  0287DE  3BEE: ff7608           push word ptr [bp + 8]
  0287E1  3BF1: 6a03             push 3
  0287E3  3BF3: 0e               push cs
  0287E4  3BF4: e8c342           call 0x7eba
  0287E7  3BF7: c9               leave 
  0287E8  3BF8: cb               retf 

; ---- func_0287EA  size=60  insns=25  prologue=push bp;mov bp,sp  terminal=RETF ----
  0287EA  3BFA: 55               push bp
  0287EB  3BFB: 8bec             mov bp, sp
  0287ED  3BFD: 6a01             push 1
  0287EF  3BFF: 9a56001f18       lcall 0x181f, 0x56
  0287F4  3C04: 8be5             mov sp, bp
  0287F6  3C06: 837e0a00         cmp word ptr [bp + 0xa], 0
  0287FA  3C0A: 7404             je 0x3c10
  0287FC  3C0C: 6a0f             push 0xf
  0287FE  3C0E: eb02             jmp 0x3c12
  028800  3C10: 6a10             push 0x10
  028802  3C12: 0e               push cs
  028803  3C13: e8b342           call 0x7ec9
  028806  3C16: 83c402           add sp, 2
  028809  3C19: 8b5e06           mov bx, word ptr [bp + 6]
  02880C  3C1C: d1e3             shl bx, 1
  02880E  3C1E: ffb7c097         push word ptr [bx - 0x6840]
  028812  3C22: 9a74001f18       lcall 0x181f, 0x74
  028817  3C27: 83c402           add sp, 2
  02881A  3C2A: 6a00             push 0
  02881C  3C2C: 6a00             push 0
  02881E  3C2E: 6a01             push 1
  028820  3C30: 0e               push cs
  028821  3C31: e88642           call 0x7eba
  028824  3C34: c9               leave 
  028825  3C35: cb               retf 

; ---- func_028826  size=23  insns=9  prologue=push bp;mov bp,sp  terminal=RETF ----
  028826  3C36: 55               push bp
  028827  3C37: 8bec             mov bp, sp
  028829  3C39: c706b80b0100     mov word ptr [0xbb8], 1
  02882F  3C3F: 8b4606           mov ax, word ptr [bp + 6]
  028832  3C42: a3ce9c           mov word ptr [0x9cce], ax
  028835  3C45: 8b4608           mov ax, word ptr [bp + 8]
  028838  3C48: a3d09c           mov word ptr [0x9cd0], ax
  02883B  3C4B: c9               leave 
  02883C  3C4C: cb               retf 

; ---- func_02883E  size=1357  insns=481  prologue=ENTER 0x006A,0  terminal=RETF ----
  02883E  3C4E: c86a0000         enter 0x6a, 0
  028842  3C52: 57               push di
  028843  3C53: 56               push si
  028844  3C54: c746ac0100       mov word ptr [bp - 0x54], 1
  028849  3C59: ff7606           push word ptr [bp + 6]
  02884C  3C5C: 9a0e0c1f18       lcall 0x181f, 0xc0e
  028851  3C61: 83c402           add sp, 2
  028854  3C64: 8946a2           mov word ptr [bp - 0x5e], ax
  028857  3C67: ff7606           push word ptr [bp + 6]
  02885A  3C6A: 9a540c1f18       lcall 0x181f, 0xc54
  02885F  3C6F: 83c402           add sp, 2
  028862  3C72: 894696           mov word ptr [bp - 0x6a], ax
  028865  3C75: 8b4608           mov ax, word ptr [bp + 8]
  028868  3C78: 89469a           mov word ptr [bp - 0x66], ax
  02886B  3C7B: 3d1700           cmp ax, 0x17
  02886E  3C7E: 7505             jne 0x3c85
  028870  3C80: c7469a1500       mov word ptr [bp - 0x66], 0x15
  028875  3C85: 50               push ax
  028876  3C86: ff7606           push word ptr [bp + 6]
  028879  3C89: 0e               push cs
  02887A  3C8A: e88341           call 0x7e10
  02887D  3C8D: 83c404           add sp, 4
  028880  3C90: 89469e           mov word ptr [bp - 0x62], ax
  028883  3C93: e95c02           jmp 0x3ef2
  028886  3C96: 6a05             push 5
  028888  3C98: 68ba0b           push 0xbba
  02888B  3C9B: 9a52061f18       lcall 0x181f, 0x652
  028890  3CA0: 83c404           add sp, 4
  028893  3CA3: e98602           jmp 0x3f2c
  028896  3CA6: 6a05             push 5
  028898  3CA8: 68c70b           push 0xbc7
  02889B  3CAB: ebee             jmp 0x3c9b
  02889D  3CAD: 90               nop 
  02889E  3CAE: 8d1ed50b         lea bx, [0xbd5]
  0288A2  3CB2: 9afe031f18       lcall 0x181f, 0x3fe
  0288A7  3CB7: e97202           jmp 0x3f2c
  0288AA  3CBA: 8d1edf0b         lea bx, [0xbdf]
  0288AE  3CBE: ebf2             jmp 0x3cb2
  0288B0  3CC0: a14285           mov ax, word ptr [0x8542]
  0288B3  3CC3: 40               inc ax
  0288B4  3CC4: 40               inc ax
  0288B5  3CC5: 1e               push ds
  0288B6  3CC6: 50               push ax
  0288B7  3CC7: 6a00             push 0
  0288B9  3CC9: 9a16041f18       lcall 0x181f, 0x416
  0288BE  3CCE: 83c406           add sp, 6
  0288C1  3CD1: 6a05             push 5
  0288C3  3CD3: 68e90b           push 0xbe9
  0288C6  3CD6: ebc3             jmp 0x3c9b
  0288C8  3CD8: a14285           mov ax, word ptr [0x8542]
  0288CB  3CDB: 40               inc ax
  0288CC  3CDC: 40               inc ax
  0288CD  3CDD: 1e               push ds
  0288CE  3CDE: 50               push ax
  0288CF  3CDF: 1e               push ds
  0288D0  3CE0: 68d29c           push 0x9cd2
  0288D3  3CE3: 9a7e111d0d       lcall 0xd1d, 0x117e
  0288D8  3CE8: 83c408           add sp, 8
  0288DB  3CEB: 68ee0b           push 0xbee
  0288DE  3CEE: 8d46b0           lea ax, [bp - 0x50]
  0288E1  3CF1: 50               push ax
  0288E2  3CF2: 9ae4071d0d       lcall 0xd1d, 0x7e4
  0288E7  3CF7: 83c404           add sp, 4
  0288EA  3CFA: 8b1e4285         mov bx, word ptr [0x8542]
  0288EE  3CFE: 8a5f1a           mov bl, byte ptr [bx + 0x1a]
  0288F1  3D01: 2aff             sub bh, bh
  0288F3  3D03: 80bf989202       cmp byte ptr [bx - 0x6d68], 2
  0288F8  3D08: 7317             jae 0x3d21
  0288FA  3D0A: 813e8a532706     cmp word ptr [0x538a], 0x627
  028900  3D10: 7e0f             jle 0x3d21
  028902  3D12: 68f60b           push 0xbf6
  028905  3D15: 8d46b0           lea ax, [bp - 0x50]
  028908  3D18: 50               push ax
  028909  3D19: 9aa4071d0d       lcall 0xd1d, 0x7a4
  02890E  3D1E: 83c404           add sp, 4
  028911  3D21: 6a05             push 5
  028913  3D23: 8d46b0           lea ax, [bp - 0x50]
  028916  3D26: 50               push ax
  028917  3D27: 9a52061f18       lcall 0x181f, 0x652
  02891C  3D2C: 83c404           add sp, 4
  02891F  3D2F: 48               dec ax
  028920  3D30: 7403             je 0x3d35
  028922  3D32: e9f701           jmp 0x3f2c
  028925  3D35: c7469e0000       mov word ptr [bp - 0x62], 0
  02892A  3D3A: e9ef01           jmp 0x3f2c
  02892D  3D3D: 90               nop 
  02892E  3D3E: ff7606           push word ptr [bp + 6]
  028931  3D41: 9a540c1f18       lcall 0x181f, 0xc54
  028936  3D46: 83c402           add sp, 2
  028939  3D49: 894696           mov word ptr [bp - 0x6a], ax
  02893C  3D4C: 3d1c00           cmp ax, 0x1c
  02893F  3D4F: 7507             jne 0x3d58
  028941  3D51: ff36c02d         push word ptr [0x2dc0]
  028945  3D55: eb0a             jmp 0x3d61
  028947  3D57: 90               nop 
  028948  3D58: 8bd8             mov bx, ax
  02894A  3D5A: c1e303           shl bx, 3
  02894D  3D5D: ffb7a28e         push word ptr [bx - 0x715e]
  028951  3D61: 9a22001f18       lcall 0x181f, 0x22
  028956  3D66: 83c402           add sp, 2
  028959  3D69: 52               push dx
  02895A  3D6A: 50               push ax
  02895B  3D6B: 8d46b0           lea ax, [bp - 0x50]
  02895E  3D6E: 16               push ss
  02895F  3D6F: 50               push ax
  028960  3D70: 9a7e111d0d       lcall 0xd1d, 0x117e
  028965  3D75: 83c408           add sp, 8
  028968  3D78: 8d46b0           lea ax, [bp - 0x50]
  02896B  3D7B: 50               push ax
  02896C  3D7C: 9a640d1d0d       lcall 0xd1d, 0xd64
  028971  3D81: 83c402           add sp, 2
  028974  3D84: 8d46b0           lea ax, [bp - 0x50]
  028977  3D87: 16               push ss
  028978  3D88: 50               push ax
  028979  3D89: 1e               push ds
  02897A  3D8A: 68d29c           push 0x9cd2
  02897D  3D8D: 9a7e111d0d       lcall 0xd1d, 0x117e
  028982  3D92: 83c408           add sp, 8
  028985  3D95: 8b5e9a           mov bx, word ptr [bp - 0x66]
  028988  3D98: c1e303           shl bx, 3
  02898B  3D9B: ffb7a28e         push word ptr [bx - 0x715e]
  02898F  3D9F: 9a22001f18       lcall 0x181f, 0x22
  028994  3DA4: 83c402           add sp, 2
  028997  3DA7: 52               push dx
  028998  3DA8: 50               push ax
  028999  3DA9: 8d46b0           lea ax, [bp - 0x50]
  02899C  3DAC: 16               push ss
  02899D  3DAD: 50               push ax
  02899E  3DAE: 9a7e111d0d       lcall 0xd1d, 0x117e
  0289A3  3DB3: 83c408           add sp, 8
  0289A6  3DB6: 8d46b0           lea ax, [bp - 0x50]
  0289A9  3DB9: 50               push ax
  0289AA  3DBA: 9a640d1d0d       lcall 0xd1d, 0xd64
  0289AF  3DBF: 83c402           add sp, 2
  0289B2  3DC2: 8d46b0           lea ax, [bp - 0x50]
  0289B5  3DC5: 16               push ss
  0289B6  3DC6: 50               push ax
  0289B7  3DC7: 1e               push ds
  0289B8  3DC8: 68129d           push 0x9d12
  0289BB  3DCB: 9a7e111d0d       lcall 0xd1d, 0x117e
  0289C0  3DD0: 83c408           add sp, 8
  0289C3  3DD3: 6a05             push 5
  0289C5  3DD5: 68f80b           push 0xbf8
  0289C8  3DD8: e94cff           jmp 0x3d27
  0289CB  3DDB: 90               nop 
  0289CC  3DDC: 8b5e9a           mov bx, word ptr [bp - 0x66]
  0289CF  3DDF: c1e303           shl bx, 3
  0289D2  3DE2: ffb7a28e         push word ptr [bx - 0x715e]
  0289D6  3DE6: 9a22001f18       lcall 0x181f, 0x22
  0289DB  3DEB: 83c402           add sp, 2
  0289DE  3DEE: 52               push dx
  0289DF  3DEF: 50               push ax
  0289E0  3DF0: 8d46b0           lea ax, [bp - 0x50]
  0289E3  3DF3: 16               push ss
  0289E4  3DF4: 50               push ax
  0289E5  3DF5: 9a7e111d0d       lcall 0xd1d, 0x117e
  0289EA  3DFA: 83c408           add sp, 8
  0289ED  3DFD: 8d46b0           lea ax, [bp - 0x50]
  0289F0  3E00: 50               push ax
  0289F1  3E01: 9a640d1d0d       lcall 0xd1d, 0xd64
  0289F6  3E06: 83c402           add sp, 2
  0289F9  3E09: 8d46b0           lea ax, [bp - 0x50]
  0289FC  3E0C: 16               push ss
  0289FD  3E0D: 50               push ax
  0289FE  3E0E: 1e               push ds
  0289FF  3E0F: 68d29c           push 0x9cd2
  028A02  3E12: 9a7e111d0d       lcall 0xd1d, 0x117e
  028A07  3E17: 83c408           add sp, 8
  028A0A  3E1A: 68010c           push 0xc01
  028A0D  3E1D: 8d46b0           lea ax, [bp - 0x50]
  028A10  3E20: 50               push ax
  028A11  3E21: 9ae4071d0d       lcall 0xd1d, 0x7e4
  028A16  3E26: 83c404           add sp, 4
  028A19  3E29: 837e9e0e         cmp word ptr [bp - 0x62], 0xe
  028A1D  3E2D: 750f             jne 0x3e3e
  028A1F  3E2F: 68090c           push 0xc09
  028A22  3E32: 8d46b0           lea ax, [bp - 0x50]
  028A25  3E35: 50               push ax
  028A26  3E36: 9ae4071d0d       lcall 0xd1d, 0x7e4
  028A2B  3E3B: 83c404           add sp, 4
  028A2E  3E3E: 837e9e0f         cmp word ptr [bp - 0x62], 0xf
  028A32  3E42: 7403             je 0x3e47
  028A34  3E44: e9dafe           jmp 0x3d21
  028A37  3E47: 68110c           push 0xc11
  028A3A  3E4A: 8d46b0           lea ax, [bp - 0x50]
  028A3D  3E4D: 50               push ax
  028A3E  3E4E: 9ae4071d0d       lcall 0xd1d, 0x7e4
  028A43  3E53: e9c8fe           jmp 0x3d1e
  028A46  3E56: 6a05             push 5
  028A48  3E58: 681a0c           push 0xc1a
  028A4B  3E5B: e93dfe           jmp 0x3c9b
  028A4E  3E5E: 6a05             push 5
  028A50  3E60: 68200c           push 0xc20
  028A53  3E63: e935fe           jmp 0x3c9b
  028A56  3E66: 6a05             push 5
  028A58  3E68: 68290c           push 0xc29
  028A5B  3E6B: e92dfe           jmp 0x3c9b
  028A5E  3E6E: 6a05             push 5
  028A60  3E70: 68310c           push 0xc31
  028A63  3E73: e925fe           jmp 0x3c9b
  028A66  3E76: ff7606           push word ptr [bp + 6]
  028A69  3E79: 9a540c1f18       lcall 0x181f, 0xc54
  028A6E  3E7E: 83c402           add sp, 2
  028A71  3E81: 8bd8             mov bx, ax
  028A73  3E83: 895e96           mov word ptr [bp - 0x6a], bx
  028A76  3E86: c1e303           shl bx, 3
  028A79  3E89: ffb7a28e         push word ptr [bx - 0x715e]
  028A7D  3E8D: 6a00             push 0
  028A7F  3E8F: 9a38041f18       lcall 0x181f, 0x438
  028A84  3E94: 83c404           add sp, 4
  028A87  3E97: 6a05             push 5
  028A89  3E99: 683b0c           push 0xc3b
  028A8C  3E9C: e9fcfd           jmp 0x3c9b
  028A8F  3E9F: 90               nop 
  028A90  3EA0: ff7606           push word ptr [bp + 6]
  028A93  3EA3: 9a540c1f18       lcall 0x181f, 0xc54
  028A98  3EA8: 83c402           add sp, 2
  028A9B  3EAB: 8bd8             mov bx, ax
  028A9D  3EAD: 895e96           mov word ptr [bp - 0x6a], bx
  028AA0  3EB0: c1e303           shl bx, 3
  028AA3  3EB3: ffb7a28e         push word ptr [bx - 0x715e]
  028AA7  3EB7: 6a00             push 0
  028AA9  3EB9: 9a38041f18       lcall 0x181f, 0x438
  028AAE  3EBE: 83c404           add sp, 4
  028AB1  3EC1: 6a05             push 5
  028AB3  3EC3: 68470c           push 0xc47
  028AB6  3EC6: e9d2fd           jmp 0x3c9b
  028AB9  3EC9: 90               nop 
  028ABA  3ECA: 6a05             push 5
  028ABC  3ECC: 68560c           push 0xc56
  028ABF  3ECF: e9c9fd           jmp 0x3c9b
  028AC2  3ED2: 6a05             push 5
  028AC4  3ED4: 685f0c           push 0xc5f
  028AC7  3ED7: e9c1fd           jmp 0x3c9b
  028ACA  3EDA: 6a05             push 5
  028ACC  3EDC: 68680c           push 0xc68
  028ACF  3EDF: e9b9fd           jmp 0x3c9b
  028AD2  3EE2: 6a00             push 0
  028AD4  3EE4: 68740c           push 0xc74
  028AD7  3EE7: e9b1fd           jmp 0x3c9b
  028ADA  3EEA: 6a01             push 1
  028ADC  3EEC: 687c0c           push 0xc7c
  028ADF  3EEF: e9a9fd           jmp 0x3c9b
  028AE2  3EF2: 48               dec ax
  028AE3  3EF3: 3d1500           cmp ax, 0x15
  028AE6  3EF6: 7734             ja 0x3f2c
  028AE8  3EF8: d1e0             shl ax, 1
  028AEA  3EFA: 93               xchg bx, ax
  028AEB  3EFB: 2effa7f031       jmp word ptr cs:[bx + 0x31f0]
  028AF0  3F00: aa               stosb byte ptr es:[di], al
  028AF1  3F01: 2f               das 
  028AF2  3F02: 9e               sahf 
  028AF3  3F03: 2f               das 
  028AF4  3F04: c82fb02f         enter -0x4fd1, 0x2f
  028AF8  3F08: 2e30cc           xor ah, cl
  028AFB  3F0B: 304631           xor byte ptr [bp + 0x31], al
  028AFE  3F0E: 4e               dec si
  028AFF  3F0F: 315631           xor word ptr [bp + 0x31], dx
  028B02  3F12: ca31c2           retf 0xc231
  028B05  3F15: 31ba31d2         xor word ptr [bp + si - 0x2dcf], di
  028B09  3F19: 31cc             xor sp, cx
  028B0B  3F1B: 30cc             xor ah, cl
  028B0D  3F1D: 305e31           xor byte ptr [bp + 0x31], bl
  028B10  3F20: 663190311c       xor dword ptr [bx + si + 0x1c31], edx
  028B15  3F25: 32da             xor bl, dl
  028B17  3F27: 31862f96         xor word ptr [bp - 0x69d1], ax
  028B1B  3F2B: 2f               das 
  028B1C  3F2C: 837e9e00         cmp word ptr [bp - 0x62], 0
  028B20  3F30: 7403             je 0x3f35
  028B22  3F32: e95902           jmp 0x418e
  028B25  3F35: 833eb80b00       cmp word ptr [0xbb8], 0
  028B2A  3F3A: 7503             jne 0x3f3f
  028B2C  3F3C: e98301           jmp 0x40c2
  028B2F  3F3F: 8b36ce9c         mov si, word ptr [0x9cce]
  028B33  3F43: 8bc6             mov ax, si
  028B35  3F45: c1e602           shl si, 2
  028B38  3F48: 03f0             add si, ax
  028B3A  3F4A: 8b1ed09c         mov bx, word ptr [0x9cd0]
  028B3E  3F4E: 8a809e8d         mov al, byte ptr [bx + si - 0x7262]
  028B42  3F52: 98               cwde 
  028B43  3F53: 894698           mov word ptr [bp - 0x68], ax
  028B46  3F56: 0bc0             or ax, ax
  028B48  3F58: 7d03             jge 0x3f5d
  028B4A  3F5A: e96501           jmp 0x40c2
  028B4D  3F5D: 8b1e4285         mov bx, word ptr [0x8542]
  028B51  3F61: 8a4f1a           mov cl, byte ptr [bx + 0x1a]
  028B54  3F64: 2aed             sub ch, ch
  028B56  3F66: 51               push cx
  028B57  3F67: 50               push ax
  028B58  3F68: 9a380a1f18       lcall 0x181f, 0xa38
  028B5D  3F6D: 83c404           add sp, 4
  028B60  3F70: a840             test al, 0x40
  028B62  3F72: 7503             jne 0x3f77
  028B64  3F74: e94b01           jmp 0x40c2
  028B67  3F77: ff7698           push word ptr [bp - 0x68]
  028B6A  3F7A: 9aa4091f18       lcall 0x181f, 0x9a4
  028B6F  3F7F: 83c402           add sp, 2
  028B72  3F82: 50               push ax
  028B73  3F83: 6a00             push 0
  028B75  3F85: 9a38041f18       lcall 0x181f, 0x438
  028B7A  3F8A: 83c404           add sp, 4
  028B7D  3F8D: 8b1e4285         mov bx, word ptr [0x8542]
  028B81  3F91: 8a4701           mov al, byte ptr [bx + 1]
  028B84  3F94: 2ae4             sub ah, ah
  028B86  3F96: 0306d09c         add ax, word ptr [0x9cd0]
  028B8A  3F9A: 48               dec ax
  028B8B  3F9B: 48               dec ax
  028B8C  3F9C: 8946a0           mov word ptr [bp - 0x60], ax
  028B8F  3F9F: 6aff             push -1
  028B91  3FA1: 6aff             push -1
  028B93  3FA3: 50               push ax
  028B94  3FA4: 8a07             mov al, byte ptr [bx]
  028B96  3FA6: 2ae4             sub ah, ah
  028B98  3FA8: 0306ce9c         add ax, word ptr [0x9cce]
  028B9C  3FAC: 48               dec ax
  028B9D  3FAD: 48               dec ax
  028B9E  3FAE: 8946a4           mov word ptr [bp - 0x5c], ax
  028BA1  3FB1: 50               push ax
  028BA2  3FB2: 9a840d1f18       lcall 0x181f, 0xd84
  028BA7  3FB7: 83c408           add sp, 8
  028BAA  3FBA: 8b4698           mov ax, word ptr [bp - 0x68]
  028BAD  3FBD: 2d0400           sub ax, 4
  028BB0  3FC0: 50               push ax
  028BB1  3FC1: 9a420a1f18       lcall 0x181f, 0xa42
  028BB6  3FC6: 83c402           add sp, 2
  028BB9  3FC9: ff76a0           push word ptr [bp - 0x60]
  028BBC  3FCC: ff76a4           push word ptr [bp - 0x5c]
  028BBF  3FCF: 8b1e4285         mov bx, word ptr [0x8542]
  028BC3  3FD3: 8a471a           mov al, byte ptr [bx + 0x1a]
  028BC6  3FD6: 2ae4             sub ah, ah
  028BC8  3FD8: 50               push ax
  028BC9  3FD9: ff364c8d         push word ptr [0x8d4c]
  028BCD  3FDD: 9a780d1f18       lcall 0x181f, 0xd78
  028BD2  3FE2: 83c408           add sp, 8
  028BD5  3FE5: 8946a6           mov word ptr [bp - 0x5a], ax
  028BD8  3FE8: 99               cdq 
  028BD9  3FE9: 52               push dx
  028BDA  3FEA: 50               push ax
  028BDB  3FEB: 6a01             push 1
  028BDD  3FED: 8bf0             mov si, ax
  028BDF  3FEF: 8bfa             mov di, dx
  028BE1  3FF1: 9aae091f18       lcall 0x181f, 0x9ae
  028BE6  3FF6: 83c406           add sp, 6
  028BE9  3FF9: a1528d           mov ax, word ptr [0x8d52]
  028BEC  3FFC: a35c1f           mov word ptr [0x1f5c], ax
  028BEF  3FFF: 8d1e7c08         lea bx, [0x87c]
  028BF3  4003: 8d06820c         lea ax, [0xc82]
  028BF7  4007: 2bd2             sub dx, dx
  028BF9  4009: 9a82011f19       lcall 0x191f, 0x182
  028BFE  400E: 8946a8           mov word ptr [bp - 0x58], ax
  028C01  4011: 8956aa           mov word ptr [bp - 0x56], dx
  028C04  4014: 0bd0             or dx, ax
  028C06  4016: 7503             jne 0x401b
  028C08  4018: e9a700           jmp 0x40c2
  028C0B  401B: 8b1e4285         mov bx, word ptr [0x8542]
  028C0F  401F: 8a471a           mov al, byte ptr [bx + 0x1a]
  028C12  4022: 2ae4             sub ah, ah
  028C14  4024: 50               push ax
  028C15  4025: 9a920a1f18       lcall 0x181f, 0xa92
  028C1A  402A: 83c402           add sp, 2
  028C1D  402D: 3bfa             cmp di, dx
  028C1F  402F: 7c18             jl 0x4049
  028C21  4031: 7f04             jg 0x4037
  028C23  4033: 3bf0             cmp si, ax
  028C25  4035: 7612             jbe 0x4049
  028C27  4037: 6a01             push 1
  028C29  4039: 6a02             push 2
  028C2B  403B: ff76aa           push word ptr [bp - 0x56]
  028C2E  403E: ff76a8           push word ptr [bp - 0x58]
  028C31  4041: 9ab6011f19       lcall 0x191f, 0x1b6
  028C36  4046: 83c408           add sp, 8
  028C39  4049: ff76aa           push word ptr [bp - 0x56]
  028C3C  404C: ff76a8           push word ptr [bp - 0x58]
  028C3F  404F: 9a6a011f19       lcall 0x191f, 0x16a
  028C44  4054: 8946ae           mov word ptr [bp - 0x52], ax
  028C47  4057: ff76aa           push word ptr [bp - 0x56]
  028C4A  405A: ff76a8           push word ptr [bp - 0x58]
  028C4D  405D: 9aa8011f19       lcall 0x191f, 0x1a8
  028C52  4062: 837eae01         cmp word ptr [bp - 0x52], 1
  028C56  4066: 7503             jne 0x406b
  028C58  4068: e92301           jmp 0x418e
  028C5B  406B: 837eae02         cmp word ptr [bp - 0x52], 2
  028C5F  406F: 7551             jne 0x40c2
  028C61  4071: 8b46a6           mov ax, word ptr [bp - 0x5a]
  028C64  4074: 99               cdq 
  028C65  4075: 52               push dx
  028C66  4076: 50               push ax
  028C67  4077: 8b1e4285         mov bx, word ptr [0x8542]
  028C6B  407B: 8a471a           mov al, byte ptr [bx + 0x1a]
  028C6E  407E: 2ae4             sub ah, ah
  028C70  4080: 50               push ax
  028C71  4081: 9af60a1f18       lcall 0x181f, 0xaf6
  028C76  4086: 83c406           add sp, 6
  028C79  4089: 8b1e4e8d         mov bx, word ptr [0x8d4e]
  028C7D  408D: fe4705           inc byte ptr [bx + 5]
  028C80  4090: 8b36ce9c         mov si, word ptr [0x9cce]
  028C84  4094: 8bc6             mov ax, si
  028C86  4096: c1e602           shl si, 2
  028C89  4099: 03f0             add si, ax
  028C8B  409B: 8b1ed09c         mov bx, word ptr [0x9cd0]
  028C8F  409F: c6809e8dff       mov byte ptr [bx + si - 0x7262], 0xff
  028C94  40A4: 6a01             push 1
  028C96  40A6: 53               push bx
  028C97  40A7: ff36ce9c         push word ptr [0x9cce]
  028C9B  40AB: 9a900c1f18       lcall 0x181f, 0xc90
  028CA0  40B0: 83c406           add sp, 6
  028CA3  40B3: ff36528d         push word ptr [0x8d52]
  028CA7  40B7: 688d0c           push 0xc8d
  028CAA  40BA: 9a9c011f19       lcall 0x191f, 0x19c
  028CAF  40BF: 83c404           add sp, 4
  028CB2  40C2: 837e0809         cmp word ptr [bp + 8], 9
  028CB6  40C6: 7c18             jl 0x40e0
  028CB8  40C8: 8b1e4285         mov bx, word ptr [0x8542]
  028CBC  40CC: 8a471f           mov al, byte ptr [bx + 0x1f]
  028CBF  40CF: 98               cwde 
  028CC0  40D0: 3b4606           cmp ax, word ptr [bp + 6]
  028CC3  40D3: 7e0b             jle 0x40e0
  028CC5  40D5: ff7606           push word ptr [bp + 6]
  028CC8  40D8: 9aa60a1f18       lcall 0x181f, 0xaa6
  028CCD  40DD: 83c402           add sp, 2
  028CD0  40E0: ff7608           push word ptr [bp + 8]
  028CD3  40E3: ff7606           push word ptr [bp + 6]
  028CD6  40E6: 9a360c1f18       lcall 0x181f, 0xc36
  028CDB  40EB: 83c404           add sp, 4
  028CDE  40EE: 89469c           mov word ptr [bp - 0x64], ax
  028CE1  40F1: 837e0818         cmp word ptr [bp + 8], 0x18
  028CE5  40F5: 7406             je 0x40fd
  028CE7  40F7: 837e0810         cmp word ptr [bp + 8], 0x10
  028CEB  40FB: 7510             jne 0x410d
  028CED  40FD: 8b4608           mov ax, word ptr [bp + 8]
  028CF0  4100: 394696           cmp word ptr [bp - 0x6a], ax
  028CF3  4103: 7508             jne 0x410d
  028CF5  4105: b82480           mov ax, 0x8024
  028CF8  4108: 9ac0041f18       lcall 0x181f, 0x4c0
  028CFD  410D: f606825380       test byte ptr [0x5382], 0x80
  028D02  4112: 7442             je 0x4156
  028D04  4114: f606875304       test byte ptr [0x5387], 4
  028D09  4119: 753b             jne 0x4156
  028D0B  411B: 8b1e4285         mov bx, word ptr [0x8542]
  028D0F  411F: 807f1f03         cmp byte ptr [bx + 0x1f], 3
  028D13  4123: 7c31             jl 0x4156
  028D15  4125: 6a00             push 0
  028D17  4127: 9afc091f18       lcall 0x181f, 0x9fc
  028D1C  412C: 83c402           add sp, 2
  028D1F  412F: 0bc0             or ax, ax
  028D21  4131: 7523             jne 0x4156
  028D23  4133: a14285           mov ax, word ptr [0x8542]
  028D26  4136: 40               inc ax
  028D27  4137: 40               inc ax
  028D28  4138: 1e               push ds
  028D29  4139: 50               push ax
  028D2A  413A: 6a00             push 0
  028D2C  413C: 9a16041f18       lcall 0x181f, 0x416
  028D31  4141: 83c406           add sp, 6
  028D34  4144: 6a01             push 1
  028D36  4146: 68990c           push 0xc99
  028D39  4149: 9a52061f18       lcall 0x181f, 0x652
  028D3E  414E: 83c404           add sp, 4
  028D41  4151: 800e875304       or byte ptr [0x5387], 4
  028D46  4156: 837ea213         cmp word ptr [bp - 0x5e], 0x13
  028D4A  415A: 7c08             jl 0x4164
  028D4C  415C: 8b469c           mov ax, word ptr [bp - 0x64]
  028D4F  415F: a34e03           mov word ptr [0x34e], ax
  028D52  4162: eb0c             jmp 0x4170
  028D54  4164: 837e0813         cmp word ptr [bp + 8], 0x13
  028D58  4168: 7c06             jl 0x4170
  028D5A  416A: c7064e03ffff     mov word ptr [0x34e], 0xffff
  028D60  4170: 8b469c           mov ax, word ptr [bp - 0x64]
  028D63  4173: a37c8d           mov word ptr [0x8d7c], ax
  028D66  4176: a37e8d           mov word ptr [0x8d7e], ax
  028D69  4179: 8b1e4285         mov bx, word ptr [0x8542]
  028D6D  417D: 807f1f00         cmp byte ptr [bx + 0x1f], 0
  028D71  4181: 7506             jne 0x4189
  028D73  4183: c70646030000     mov word ptr [0x346], 0
  028D79  4189: c746ac0000       mov word ptr [bp - 0x54], 0
  028D7E  418E: c706b80b0000     mov word ptr [0xbb8], 0
  028D84  4194: 8b46ac           mov ax, word ptr [bp - 0x54]
  028D87  4197: 5e               pop si
  028D88  4198: 5f               pop di
  028D89  4199: c9               leave 
  028D8A  419A: cb               retf 

; ---- func_028D8C  size=3091  insns=989  prologue=ENTER 0x0148,0  terminal=RETF ----
  028D8C  419C: c8480100         enter 0x148, 0
  028D90  41A0: 56               push si
  028D91  41A1: 2bc0             sub ax, ax
  028D93  41A3: 8986d4fe         mov word ptr [bp - 0x12c], ax
  028D97  41A7: 898614ff         mov word ptr [bp - 0xec], ax
  028D9B  41AB: 89860eff         mov word ptr [bp - 0xf2], ax
  028D9F  41AF: 8b1e4285         mov bx, word ptr [0x8542]
  028DA3  41B3: 8a471f           mov al, byte ptr [bx + 0x1f]
  028DA6  41B6: 8bc8             mov cx, ax
  028DA8  41B8: 98               cwde 
  028DA9  41B9: 3b067c8d         cmp ax, word ptr [0x8d7c]
  028DAD  41BD: 7f0f             jg 0x41ce
  028DAF  41BF: 80f920           cmp cl, 0x20
  028DB2  41C2: 7c0a             jl 0x41ce
  028DB4  41C4: b80100           mov ax, 1
  028DB7  41C7: 894606           mov word ptr [bp + 6], ax
  028DBA  41CA: 8986d4fe         mov word ptr [bp - 0x12c], ax
  028DBE  41CE: c78638ff0100     mov word ptr [bp - 0xc8], 1
  028DC4  41D4: ff367c8d         push word ptr [0x8d7c]
  028DC8  41D8: 9a540c1f18       lcall 0x181f, 0xc54
  028DCD  41DD: 83c402           add sp, 2
  028DD0  41E0: 50               push ax
  028DD1  41E1: 9a9a0c1f18       lcall 0x181f, 0xc9a
  028DD6  41E6: 83c402           add sp, 2
  028DD9  41E9: 0bc0             or ax, ax
  028DDB  41EB: 7504             jne 0x41f1
  028DDD  41ED: 898638ff         mov word ptr [bp - 0xc8], ax
  028DE1  41F1: c70634030000     mov word ptr [0x334], 0
  028DE7  41F7: 0e               push cs
  028DE8  41F8: e84c3c           call 0x7e47
  028DEB  41FB: 837e0600         cmp word ptr [bp + 6], 0
  028DEF  41FF: 740f             je 0x4210
  028DF1  4201: c78608ff1300     mov word ptr [bp - 0xf8], 0x13
  028DF7  4207: c786bcfe0600     mov word ptr [bp - 0x144], 6
  028DFD  420D: eb0d             jmp 0x421c
  028DFF  420F: 90               nop 
  028E00  4210: c78608ff0000     mov word ptr [bp - 0xf8], 0
  028E06  4216: c786bcfe1900     mov word ptr [bp - 0x144], 0x19
  028E0C  421C: ff367c8d         push word ptr [0x8d7c]
  028E10  4220: 9a0e0c1f18       lcall 0x181f, 0xc0e
  028E15  4225: 83c402           add sp, 2
  028E18  4228: 8946fa           mov word ptr [bp - 6], ax
  028E1B  422B: 3d1200           cmp ax, 0x12
  028E1E  422E: 7506             jne 0x4236
  028E20  4230: b80100           mov ax, 1
  028E23  4233: eb03             jmp 0x4238
  028E25  4235: 90               nop 
  028E26  4236: 2bc0             sub ax, ax
  028E28  4238: 898612ff         mov word ptr [bp - 0xee], ax
  028E2C  423C: 6a20             push 0x20
  028E2E  423E: 6a00             push 0
  028E30  4240: 8d866cff         lea ax, [bp - 0x94]
  028E34  4244: 50               push ax
  028E35  4245: 9aae0d1d0d       lcall 0xd1d, 0xdae
  028E3A  424A: 83c406           add sp, 6
  028E3D  424D: ff76fa           push word ptr [bp - 6]
  028E40  4250: 8d86c2fe         lea ax, [bp - 0x13e]
  028E44  4254: 50               push ax
  028E45  4255: 9a460b1f18       lcall 0x181f, 0xb46
  028E4A  425A: 83c404           add sp, 4
  028E4D  425D: 8986cafe         mov word ptr [bp - 0x136], ax
  028E51  4261: c786d0fe0000     mov word ptr [bp - 0x130], 0
  028E57  4267: eb23             jmp 0x428c
  028E59  4269: 90               nop 
  028E5A  426A: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  028E5E  426E: d1e6             shl si, 1
  028E60  4270: 83bac2fe00       cmp word ptr [bp + si - 0x13e], 0
  028E65  4275: 7411             je 0x4288
  028E67  4277: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  028E6B  427B: d1e6             shl si, 1
  028E6D  427D: 8bb2c2fe         mov si, word ptr [bp + si - 0x13e]
  028E71  4281: d1e6             shl si, 1
  028E73  4283: 83826cff32       add word ptr [bp + si - 0x94], 0x32
  028E78  4288: ff86d0fe         inc word ptr [bp - 0x130]
  028E7C  428C: 8b86cafe         mov ax, word ptr [bp - 0x136]
  028E80  4290: 3986d0fe         cmp word ptr [bp - 0x130], ax
  028E84  4294: 7d36             jge 0x42cc
  028E86  4296: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  028E8A  429A: d1e6             shl si, 1
  028E8C  429C: 83bac2fe0e       cmp word ptr [bp + si - 0x13e], 0xe
  028E91  42A1: 75c7             jne 0x426a
  028E93  42A3: 8b1e4285         mov bx, word ptr [0x8542]
  028E97  42A7: 8a471f           mov al, byte ptr [bx + 0x1f]
  028E9A  42AA: 98               cwde 
  028E9B  42AB: 2b067c8d         sub ax, word ptr [0x8d7c]
  028E9F  42AF: f7d8             neg ax
  028EA1  42B1: 50               push ax
  028EA2  42B2: 9ac80b1f18       lcall 0x181f, 0xbc8
  028EA7  42B7: 83c402           add sp, 2
  028EAA  42BA: 8986c0fe         mov word ptr [bp - 0x140], ax
  028EAE  42BE: 6bd81c           imul bx, ax, 0x1c
  028EB1  42C1: 8a875931         mov al, byte ptr [bx + 0x3159]
  028EB5  42C5: 2ae4             sub ah, ah
  028EB7  42C7: 014688           add word ptr [bp - 0x78], ax
  028EBA  42CA: ebbc             jmp 0x4288
  028EBC  42CC: c786d0fe0000     mov word ptr [bp - 0x130], 0
  028EC2  42D2: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  028EC6  42D6: d1e6             shl si, 1
  028EC8  42D8: 8b826cff         mov ax, word ptr [bp + si - 0x94]
  028ECC  42DC: 8b1e4285         mov bx, word ptr [0x8542]
  028ED0  42E0: 01809a00         add word ptr [bx + si + 0x9a], ax
  028ED4  42E4: ff86d0fe         inc word ptr [bp - 0x130]
  028ED8  42E8: 83bed0fe10       cmp word ptr [bp - 0x130], 0x10
  028EDD  42ED: 7ce3             jl 0x42d2
  028EDF  42EF: 6a10             push 0x10
  028EE1  42F1: 6a00             push 0
  028EE3  42F3: 8d468c           lea ax, [bp - 0x74]
  028EE6  42F6: 50               push ax
  028EE7  42F7: 9aae0d1d0d       lcall 0xd1d, 0xdae
  028EEC  42FC: 83c406           add sp, 6
  028EEF  42FF: 6a64             push 0x64
  028EF1  4301: 6a14             push 0x14
  028EF3  4303: 8b1e4285         mov bx, word ptr [0x8542]
  028EF7  4307: 8b87b600         mov ax, word ptr [bx + 0xb6]
  028EFB  430B: b91400           mov cx, 0x14
  028EFE  430E: 99               cdq 
  028EFF  430F: f7f9             idiv cx
  028F01  4311: 898636ff         mov word ptr [bp - 0xca], ax
  028F05  4315: 6bc014           imul ax, ax, 0x14
  028F08  4318: 50               push ax
  028F09  4319: 9a5c031f18       lcall 0x181f, 0x35c
  028F0E  431E: 83c406           add sp, 6
  028F11  4321: 88469a           mov byte ptr [bp - 0x66], al
  028F14  4324: b032             mov al, 0x32
  028F16  4326: 884694           mov byte ptr [bp - 0x6c], al
  028F19  4329: 88469b           mov byte ptr [bp - 0x65], al
  028F1C  432C: 837e0600         cmp word ptr [bp + 6], 0
  028F20  4330: 740c             je 0x433e
  028F22  4332: 8b8608ff         mov ax, word ptr [bp - 0xf8]
  028F26  4336: 3946fa           cmp word ptr [bp - 6], ax
  028F29  4339: 7d03             jge 0x433e
  028F2B  433B: ff46f8           inc word ptr [bp - 8]
  028F2E  433E: c746f80000       mov word ptr [bp - 8], 0
  028F33  4343: 8b8608ff         mov ax, word ptr [bp - 0xf8]
  028F37  4347: 8986d0fe         mov word ptr [bp - 0x130], ax
  028F3B  434B: eb21             jmp 0x436e
  028F3D  434D: 90               nop 
  028F3E  434E: ffb6d0fe         push word ptr [bp - 0x130]
  028F42  4352: 9ab40b1f18       lcall 0x181f, 0xbb4
  028F47  4357: 83c402           add sp, 2
  028F4A  435A: 0bc0             or ax, ax
  028F4C  435C: 7509             jne 0x4367
  028F4E  435E: 8b46fa           mov ax, word ptr [bp - 6]
  028F51  4361: 3986d0fe         cmp word ptr [bp - 0x130], ax
  028F55  4365: 7503             jne 0x436a
  028F57  4367: ff46f8           inc word ptr [bp - 8]
  028F5A  436A: ff86d0fe         inc word ptr [bp - 0x130]
  028F5E  436E: 8b86bcfe         mov ax, word ptr [bp - 0x144]
  028F62  4372: 038608ff         add ax, word ptr [bp - 0xf8]
  028F66  4376: 3b86d0fe         cmp ax, word ptr [bp - 0x130]
  028F6A  437A: 7fd2             jg 0x434e
  028F6C  437C: c786bafe0000     mov word ptr [bp - 0x146], 0
  028F72  4382: 8b1e4285         mov bx, word ptr [0x8542]
  028F76  4386: 8a471f           mov al, byte ptr [bx + 0x1f]
  028F79  4389: 98               cwde 
  028F7A  438A: 3b067c8d         cmp ax, word ptr [0x8d7c]
  028F7E  438E: 7f3a             jg 0x43ca
  028F80  4390: 837efa15         cmp word ptr [bp - 6], 0x15
  028F84  4394: 7406             je 0x439c
  028F86  4396: 837efa17         cmp word ptr [bp - 6], 0x17
  028F8A  439A: 752e             jne 0x43ca
  028F8C  439C: 8a471f           mov al, byte ptr [bx + 0x1f]
  028F8F  439F: 98               cwde 
  028F90  43A0: 2b067c8d         sub ax, word ptr [0x8d7c]
  028F94  43A4: f7d8             neg ax
  028F96  43A6: 50               push ax
  028F97  43A7: 9ac80b1f18       lcall 0x181f, 0xbc8
  028F9C  43AC: 83c402           add sp, 2
  028F9F  43AF: 8986c0fe         mov word ptr [bp - 0x140], ax
  028FA3  43B3: 6bd81c           imul bx, ax, 0x1c
  028FA6  43B6: 80bf463109       cmp byte ptr [bx + 0x3146], 9
  028FAB  43BB: 7407             je 0x43c4
  028FAD  43BD: 80bf463107       cmp byte ptr [bx + 0x3146], 7
  028FB2  43C2: 7506             jne 0x43ca
  028FB4  43C4: c786bafe0100     mov word ptr [bp - 0x146], 1
  028FBA  43CA: c7065c030100     mov word ptr [0x35c], 1
  028FC0  43D0: c78632ffffff     mov word ptr [bp - 0xce], 0xffff
  028FC6  43D6: 8b1e4285         mov bx, word ptr [0x8542]
  028FCA  43DA: 8a471f           mov al, byte ptr [bx + 0x1f]
  028FCD  43DD: 98               cwde 
  028FCE  43DE: 3b067c8d         cmp ax, word ptr [0x8d7c]
  028FD2  43E2: 7f1c             jg 0x4400
  028FD4  43E4: 2b067c8d         sub ax, word ptr [0x8d7c]
  028FD8  43E8: f7d8             neg ax
  028FDA  43EA: 50               push ax
  028FDB  43EB: 9ac80b1f18       lcall 0x181f, 0xbc8
  028FE0  43F0: 83c402           add sp, 2
  028FE3  43F3: 8986c0fe         mov word ptr [bp - 0x140], ax
  028FE7  43F7: 9aee081f18       lcall 0x181f, 0x8ee
  028FEC  43FC: 898632ff         mov word ptr [bp - 0xce], ax
  028FF0  4400: 83bed4fe00       cmp word ptr [bp - 0x12c], 0
  028FF5  4405: 7403             je 0x440a
  028FF7  4407: e9ba01           jmp 0x45c4
  028FFA  440A: 8d86d2fe         lea ax, [bp - 0x12e]
  028FFE  440E: 50               push ax
  028FFF  440F: 8d860cff         lea ax, [bp - 0xf4]
  029003  4413: 50               push ax
  029004  4414: ff367c8d         push word ptr [0x8d7c]
  029008  4418: 9a300d1f18       lcall 0x181f, 0xd30
  02900D  441D: 83c406           add sp, 6
  029010  4420: 0bc0             or ax, ax
  029012  4422: 744b             je 0x446f
  029014  4424: c78614ff0100     mov word ptr [bp - 0xec], 1
  02901A  442A: c786d0fe0000     mov word ptr [bp - 0x130], 0
  029020  4430: ffb6d0fe         push word ptr [bp - 0x130]
  029024  4434: ff367c8d         push word ptr [0x8d7c]
  029028  4438: 9a360c1f18       lcall 0x181f, 0xc36
  02902D  443D: 83c404           add sp, 4
  029030  4440: a37c8d           mov word ptr [0x8d7c], ax
  029033  4443: 6a00             push 0
  029035  4445: 8d8630ff         lea ax, [bp - 0xd0]
  029039  4449: 50               push ax
  02903A  444A: ffb6d2fe         push word ptr [bp - 0x12e]
  02903E  444E: ffb60cff         push word ptr [bp - 0xf4]
  029042  4452: 9a3c0b1f18       lcall 0x181f, 0xb3c
  029047  4457: 83c408           add sp, 8
  02904A  445A: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  02904E  445E: d1e6             shl si, 1
  029050  4460: 898216ff         mov word ptr [bp + si - 0xea], ax
  029054  4464: ff86d0fe         inc word ptr [bp - 0x130]
  029058  4468: 83bed0fe08       cmp word ptr [bp - 0x130], 8
  02905D  446D: 7ec1             jle 0x4430
  02905F  446F: c786d0fe0000     mov word ptr [bp - 0x130], 0
  029065  4475: e90201           jmp 0x457a
  029068  4478: 8b86d0fe         mov ax, word ptr [bp - 0x130]
  02906C  447C: 8bf0             mov si, ax
  02906E  447E: d1e6             shl si, 1
  029070  4480: 89823aff         mov word ptr [bp + si - 0xc6], ax
  029074  4484: ffb6d0fe         push word ptr [bp - 0x130]
  029078  4488: ff367c8d         push word ptr [0x8d7c]
  02907C  448C: 9a6e0b1f18       lcall 0x181f, 0xb6e
  029081  4491: 83c404           add sp, 4
  029084  4494: 0bc0             or ax, ax
  029086  4496: 7410             je 0x44a8
  029088  4498: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  02908C  449C: d1e6             shl si, 1
  02908E  449E: c782d6fe0000     mov word ptr [bp + si - 0x12a], 0
  029094  44A4: e9cf00           jmp 0x4576
  029097  44A7: 90               nop 
  029098  44A8: a1be8d           mov ax, word ptr [0x8dbe]
  02909B  44AB: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  02909F  44AF: d1e6             shl si, 1
  0290A1  44B1: 8982d6fe         mov word ptr [bp + si - 0x12a], ax
  0290A5  44B5: e9be00           jmp 0x4576
  0290A8  44B8: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  0290AC  44BC: d1e6             shl si, 1
  0290AE  44BE: 8d823aff         lea ax, [bp + si - 0xc6]
  0290B2  44C2: 50               push ax
  0290B3  44C3: ff367c8d         push word ptr [0x8d7c]
  0290B7  44C7: 9ad60c1f18       lcall 0x181f, 0xcd6
  0290BC  44CC: 83c404           add sp, 4
  0290BF  44CF: 8982d6fe         mov word ptr [bp + si - 0x12a], ax
  0290C3  44D3: 83bed0fe11       cmp word ptr [bp - 0x130], 0x11
  0290C8  44D8: 7403             je 0x44dd
  0290CA  44DA: e99900           jmp 0x4576
  0290CD  44DD: 6a0f             push 0xf
  0290CF  44DF: 8b1e4285         mov bx, word ptr [0x8542]
  0290D3  44E3: 8a471a           mov al, byte ptr [bx + 0x1a]
  0290D6  44E6: 2ae4             sub ah, ah
  0290D8  44E8: 50               push ax
  0290D9  44E9: 9ab4071f18       lcall 0x181f, 0x7b4
  0290DE  44EE: 83c404           add sp, 4
  0290E1  44F1: 0bc0             or ax, ax
  0290E3  44F3: 740a             je 0x44ff
  0290E5  44F5: 8b82d6fe         mov ax, word ptr [bp + si - 0x12a]
  0290E9  44F9: d1f8             sar ax, 1
  0290EB  44FB: 0182d6fe         add word ptr [bp + si - 0x12a], ax
  0290EF  44FF: 6a11             push 0x11
  0290F1  4501: 8b1e4285         mov bx, word ptr [0x8542]
  0290F5  4505: 8a471a           mov al, byte ptr [bx + 0x1a]
  0290F8  4508: 2ae4             sub ah, ah
  0290FA  450A: 50               push ax
  0290FB  450B: 9ab4071f18       lcall 0x181f, 0x7b4
  029100  4510: 83c404           add sp, 4
  029103  4513: 0bc0             or ax, ax
  029105  4515: 7426             je 0x453d
  029107  4517: 8b1e4285         mov bx, word ptr [0x8542]
  02910B  451B: 8a471a           mov al, byte ptr [bx + 0x1a]
  02910E  451E: 2ae4             sub ah, ah
  029110  4520: 69d83c01         imul bx, ax, 0x13c
  029114  4524: 8a870988         mov al, byte ptr [bx - 0x77f7]
  029118  4528: 98               cwde 
  029119  4529: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  02911D  452D: d1e6             shl si, 1
  02911F  452F: f7aad6fe         imul word ptr [bp + si - 0x12a]
  029123  4533: b96400           mov cx, 0x64
  029126  4536: 99               cdq 
  029127  4537: f7f9             idiv cx
  029129  4539: 0182d6fe         add word ptr [bp + si - 0x12a], ax
  02912D  453D: 6a14             push 0x14
  02912F  453F: 9afc091f18       lcall 0x181f, 0x9fc
  029134  4544: 83c402           add sp, 2
  029137  4547: 0bc0             or ax, ax
  029139  4549: 740d             je 0x4558
  02913B  454B: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  02913F  454F: d1e6             shl si, 1
  029141  4551: d1a2d6fe         shl word ptr [bp + si - 0x12a], 1
  029145  4555: eb1f             jmp 0x4576
  029147  4557: 90               nop 
  029148  4558: 6a13             push 0x13
  02914A  455A: 9afc091f18       lcall 0x181f, 0x9fc
  02914F  455F: 83c402           add sp, 2
  029152  4562: 0bc0             or ax, ax
  029154  4564: 7410             je 0x4576
  029156  4566: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  02915A  456A: d1e6             shl si, 1
  02915C  456C: 8b82d6fe         mov ax, word ptr [bp + si - 0x12a]
  029160  4570: d1f8             sar ax, 1
  029162  4572: 0182d6fe         add word ptr [bp + si - 0x12a], ax
  029166  4576: ff86d0fe         inc word ptr [bp - 0x130]
  02916A  457A: 83bed0fe13       cmp word ptr [bp - 0x130], 0x13
  02916F  457F: 7d43             jge 0x45c4
  029171  4581: ff367c8d         push word ptr [0x8d7c]
  029175  4585: 9aa60a1f18       lcall 0x181f, 0xaa6
  02917A  458A: 83c402           add sp, 2
  02917D  458D: ffb6d0fe         push word ptr [bp - 0x130]
  029181  4591: ff367c8d         push word ptr [0x8d7c]
  029185  4595: 9a360c1f18       lcall 0x181f, 0xc36
  02918A  459A: 83c404           add sp, 4
  02918D  459D: a37c8d           mov word ptr [0x8d7c], ax
  029190  45A0: 83bed0fe09       cmp word ptr [bp - 0x130], 9
  029195  45A5: 7c03             jl 0x45aa
  029197  45A7: e90eff           jmp 0x44b8
  02919A  45AA: 83bed0fe08       cmp word ptr [bp - 0x130], 8
  02919F  45AF: 7d03             jge 0x45b4
  0291A1  45B1: e9c4fe           jmp 0x4478
  0291A4  45B4: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  0291A8  45B8: d1e6             shl si, 1
  0291AA  45BA: c7823aff0000     mov word ptr [bp + si - 0xc6], 0
  0291B0  45C0: e9c1fe           jmp 0x4484
  0291B3  45C3: 90               nop 
  0291B4  45C4: 83be14ff00       cmp word ptr [bp - 0xec], 0
  0291B9  45C9: 7414             je 0x45df
  0291BB  45CB: a07c8d           mov al, byte ptr [0x8d7c]
  0291BE  45CE: 50               push ax
  0291BF  45CF: ffb6d2fe         push word ptr [bp - 0x12e]
  0291C3  45D3: ffb60cff         push word ptr [bp - 0xf4]
  0291C7  45D7: 9a440d1f18       lcall 0x181f, 0xd44
  0291CC  45DC: 83c406           add sp, 6
  0291CF  45DF: 837efa14         cmp word ptr [bp - 6], 0x14
  0291D3  45E3: 7510             jne 0x45f5
  0291D5  45E5: 8b4688           mov ax, word ptr [bp - 0x78]
  0291D8  45E8: 8b1e4285         mov bx, word ptr [0x8542]
  0291DC  45EC: 2987b600         sub word ptr [bx + 0xb6], ax
  0291E0  45F0: c746880000       mov word ptr [bp - 0x78], 0
  0291E5  45F5: ff76fa           push word ptr [bp - 6]
  0291E8  45F8: ff367c8d         push word ptr [0x8d7c]
  0291EC  45FC: 9a360c1f18       lcall 0x181f, 0xc36
  0291F1  4601: 83c404           add sp, 4
  0291F4  4604: a37c8d           mov word ptr [0x8d7c], ax
  0291F7  4607: c746fc0000       mov word ptr [bp - 4], 0
  0291FC  460C: c746a00100       mov word ptr [bp - 0x60], 1
  029201  4611: c7862eff1900     mov word ptr [bp - 0xd2], 0x19
  029207  4617: a19e08           mov ax, word ptr [0x89e]
  02920A  461A: 8b16a008         mov dx, word ptr [0x8a0]
  02920E  461E: 898628ff         mov word ptr [bp - 0xd8], ax
  029212  4622: 89962aff         mov word ptr [bp - 0xd6], dx
  029216  4626: 837ef80d         cmp word ptr [bp - 8], 0xd
  02921A  462A: 7e11             jle 0x463d
  02921C  462C: 837ef810         cmp word ptr [bp - 8], 0x10
  029220  4630: 7e0b             jle 0x463d
  029222  4632: c746a00200       mov word ptr [bp - 0x60], 2
  029227  4637: c7862eff1000     mov word ptr [bp - 0xd2], 0x10
  02922D  463D: ffb62aff         push word ptr [bp - 0xd6]
  029231  4641: ffb628ff         push word ptr [bp - 0xd8]
  029235  4645: 680008           push 0x800
  029238  4648: 9a3c021f19       lcall 0x191f, 0x23c
  02923D  464D: 83c406           add sp, 6
  029240  4650: 89469c           mov word ptr [bp - 0x64], ax
  029243  4653: 89569e           mov word ptr [bp - 0x62], dx
  029246  4656: 0bd0             or dx, ax
  029248  4658: 7503             jne 0x465d
  02924A  465A: e93c06           jmp 0x4c99
  02924D  465D: c45e9c           les bx, ptr [bp - 0x64]
  029250  4660: 26804f0a01       or byte ptr es:[bx + 0xa], 1
  029255  4665: 26c747220800     mov word ptr es:[bx + 0x22], 8
  02925B  466B: 68be00           push 0xbe
  02925E  466E: 06               push es
  02925F  466F: 53               push bx
  029260  4670: 9ad2081f19       lcall 0x191f, 0x8d2
  029265  4675: 83c406           add sp, 6
  029268  4678: c646a400         mov byte ptr [bp - 0x5c], 0
  02926C  467C: ff36ae93         push word ptr [0x93ae]
  029270  4680: 8d46a4           lea ax, [bp - 0x5c]
  029273  4683: 50               push ax
  029274  4684: 9a6e011f18       lcall 0x181f, 0x16e
  029279  4689: 83c404           add sp, 4
  02927C  468C: ff367c8d         push word ptr [0x8d7c]
  029280  4690: 9a540c1f18       lcall 0x181f, 0xc54
  029285  4695: 83c402           add sp, 2
  029288  4698: 89862cff         mov word ptr [bp - 0xd4], ax
  02928C  469C: 8d46a4           lea ax, [bp - 0x5c]
  02928F  469F: 50               push ax
  029290  46A0: 9a78011f18       lcall 0x181f, 0x178
  029295  46A5: 83c402           add sp, 2
  029298  46A8: 83be2cff1c       cmp word ptr [bp - 0xd4], 0x1c
  02929D  46AD: 7506             jne 0x46b5
  02929F  46AF: c7862cff1300     mov word ptr [bp - 0xd4], 0x13
  0292A5  46B5: 8b9e2cff         mov bx, word ptr [bp - 0xd4]
  0292A9  46B9: c1e303           shl bx, 3
  0292AC  46BC: ffb7a48e         push word ptr [bx - 0x715c]
  0292B0  46C0: 8d46a4           lea ax, [bp - 0x5c]
  0292B3  46C3: 50               push ax
  0292B4  46C4: 9a6e011f18       lcall 0x181f, 0x16e
  0292B9  46C9: 83c404           add sp, 4
  0292BC  46CC: ff367c8d         push word ptr [0x8d7c]
  0292C0  46D0: 9a0e0c1f18       lcall 0x181f, 0xc0e
  0292C5  46D5: 83c402           add sp, 2
  0292C8  46D8: 89860aff         mov word ptr [bp - 0xf6], ax
  0292CC  46DC: 3b862cff         cmp ax, word ptr [bp - 0xd4]
  0292D0  46E0: 7434             je 0x4716
  0292D2  46E2: 3d1300           cmp ax, 0x13
  0292D5  46E5: 742f             je 0x4716
  0292D7  46E7: 8d4ea4           lea cx, [bp - 0x5c]
  0292DA  46EA: 51               push cx
  0292DB  46EB: 9a1e011f18       lcall 0x181f, 0x11e
  0292E0  46F0: 83c402           add sp, 2
  0292E3  46F3: 8b9e0aff         mov bx, word ptr [bp - 0xf6]
  0292E7  46F7: c1e303           shl bx, 3
  0292EA  46FA: ffb7a28e         push word ptr [bx - 0x715e]
  0292EE  46FE: 8d46a4           lea ax, [bp - 0x5c]
  0292F1  4701: 50               push ax
  0292F2  4702: 9a6e011f18       lcall 0x181f, 0x16e
  0292F7  4707: 83c404           add sp, 4
  0292FA  470A: 8d46a4           lea ax, [bp - 0x5c]
  0292FD  470D: 50               push ax
  0292FE  470E: 9a28011f18       lcall 0x181f, 0x128
  029303  4713: 83c402           add sp, 2
  029306  4716: 8d46a4           lea ax, [bp - 0x5c]
  029309  4719: 50               push ax
  02930A  471A: 9abe011f18       lcall 0x181f, 0x1be
  02930F  471F: 83c402           add sp, 2
  029312  4722: 8d46a4           lea ax, [bp - 0x5c]
  029315  4725: 16               push ss
  029316  4726: 50               push ax
  029317  4727: ff769e           push word ptr [bp - 0x62]
  02931A  472A: ff769c           push word ptr [bp - 0x64]
  02931D  472D: 9ac6081f19       lcall 0x191f, 0x8c6
  029322  4732: 83c408           add sp, 8
  029325  4735: 8b46fc           mov ax, word ptr [bp - 4]
  029328  4738: f7ae2eff         imul word ptr [bp - 0xd2]
  02932C  473C: 898610ff         mov word ptr [bp - 0xf0], ax
  029330  4740: 8b8608ff         mov ax, word ptr [bp - 0xf8]
  029334  4744: 8986befe         mov word ptr [bp - 0x142], ax
  029338  4748: eb25             jmp 0x476f
  02933A  474A: 8b46fa           mov ax, word ptr [bp - 6]
  02933D  474D: 3986befe         cmp word ptr [bp - 0x142], ax
  029341  4751: 7414             je 0x4767
  029343  4753: ff86befe         inc word ptr [bp - 0x142]
  029347  4757: ffb6befe         push word ptr [bp - 0x142]
  02934B  475B: 9ab40b1f18       lcall 0x181f, 0xbb4
  029350  4760: 83c402           add sp, 2
  029353  4763: 0bc0             or ax, ax
  029355  4765: 74e3             je 0x474a
  029357  4767: ff86befe         inc word ptr [bp - 0x142]
  02935B  476B: ff8e10ff         dec word ptr [bp - 0xf0]
  02935F  476F: 83be10ff00       cmp word ptr [bp - 0xf0], 0
  029364  4774: 7fe1             jg 0x4757
  029366  4776: eb0d             jmp 0x4785
  029368  4778: 8b46fa           mov ax, word ptr [bp - 6]
  02936B  477B: 3986befe         cmp word ptr [bp - 0x142], ax
  02936F  477F: 7414             je 0x4795
  029371  4781: ff86befe         inc word ptr [bp - 0x142]
  029375  4785: ffb6befe         push word ptr [bp - 0x142]
  029379  4789: 9ab40b1f18       lcall 0x181f, 0xbb4
  02937E  478E: 83c402           add sp, 2
  029381  4791: 0bc0             or ax, ax
  029383  4793: 74e3             je 0x4778
  029385  4795: 8b86befe         mov ax, word ptr [bp - 0x142]
  029389  4799: 8986d0fe         mov word ptr [bp - 0x130], ax
  02938D  479D: 8b862eff         mov ax, word ptr [bp - 0xd2]
  029391  47A1: 8986cefe         mov word ptr [bp - 0x132], ax
  029395  47A5: 837ea001         cmp word ptr [bp - 0x60], 1
  029399  47A9: 7e24             jle 0x47cf
  02939B  47AB: 837efc00         cmp word ptr [bp - 4], 0
  02939F  47AF: 7e1e             jle 0x47cf
  0293A1  47B1: 6a62             push 0x62
  0293A3  47B3: ff36aa93         push word ptr [0x93aa]
  0293A7  47B7: 9a22001f18       lcall 0x181f, 0x22
  0293AC  47BC: 83c402           add sp, 2
  0293AF  47BF: 52               push dx
  0293B0  47C0: 50               push ax
  0293B1  47C1: ff769e           push word ptr [bp - 0x62]
  0293B4  47C4: ff769c           push word ptr [bp - 0x64]
  0293B7  47C7: 9a76011f19       lcall 0x191f, 0x176
  0293BC  47CC: 83c40a           add sp, 0xa
  0293BF  47CF: 83be38ff00       cmp word ptr [bp - 0xc8], 0
  0293C4  47D4: 742a             je 0x4800
  0293C6  47D6: 837efc00         cmp word ptr [bp - 4], 0
  0293CA  47DA: 7524             jne 0x4800
  0293CC  47DC: 837e0600         cmp word ptr [bp + 6], 0
  0293D0  47E0: 751e             jne 0x4800
  0293D2  47E2: 6a61             push 0x61
  0293D4  47E4: ff36122e         push word ptr [0x2e12]
  0293D8  47E8: 9a22001f18       lcall 0x181f, 0x22
  0293DD  47ED: 83c402           add sp, 2
  0293E0  47F0: 52               push dx
  0293E1  47F1: 50               push ax
  0293E2  47F2: ff769e           push word ptr [bp - 0x62]
  0293E5  47F5: ff769c           push word ptr [bp - 0x64]
  0293E8  47F8: 9a76011f19       lcall 0x191f, 0x176
  0293ED  47FD: 83c40a           add sp, 0xa
  0293F0  4800: 837e0600         cmp word ptr [bp + 6], 0
  0293F4  4804: 7470             je 0x4876
  0293F6  4806: 837efc00         cmp word ptr [bp - 4], 0
  0293FA  480A: 756a             jne 0x4876
  0293FC  480C: 8b8608ff         mov ax, word ptr [bp - 0xf8]
  029400  4810: 3946fa           cmp word ptr [bp - 6], ax
  029403  4813: 7d61             jge 0x4876
  029405  4815: c646a400         mov byte ptr [bp - 0x5c], 0
  029409  4819: 8b5efa           mov bx, word ptr [bp - 6]
  02940C  481C: c1e303           shl bx, 3
  02940F  481F: ffb7a28e         push word ptr [bx - 0x715e]
  029413  4823: 8d46a4           lea ax, [bp - 0x5c]
  029416  4826: 50               push ax
  029417  4827: 9a6e011f18       lcall 0x181f, 0x16e
  02941C  482C: 83c404           add sp, 4
  02941F  482F: 8b46fa           mov ax, word ptr [bp - 6]
  029422  4832: 40               inc ax
  029423  4833: 50               push ax
  029424  4834: 8d4ea4           lea cx, [bp - 0x5c]
  029427  4837: 16               push ss
  029428  4838: 51               push cx
  029429  4839: ff769e           push word ptr [bp - 0x62]
  02942C  483C: ff769c           push word ptr [bp - 0x64]
  02942F  483F: 8bf0             mov si, ax
  029431  4841: 9a76011f19       lcall 0x191f, 0x176
  029436  4846: 83c40a           add sp, 0xa
  029439  4849: 8b46fa           mov ax, word ptr [bp - 6]
  02943C  484C: 3986ccfe         cmp word ptr [bp - 0x134], ax
  029440  4850: 7511             jne 0x4863
  029442  4852: 6a01             push 1
  029444  4854: 56               push si
  029445  4855: ff769e           push word ptr [bp - 0x62]
  029448  4858: ff769c           push word ptr [bp - 0x64]
  02944B  485B: 9a3c031f19       lcall 0x191f, 0x33c
  029450  4860: 83c408           add sp, 8
  029453  4863: 8b46fa           mov ax, word ptr [bp - 6]
  029456  4866: 40               inc ax
  029457  4867: 50               push ax
  029458  4868: ff769e           push word ptr [bp - 0x62]
  02945B  486B: ff769c           push word ptr [bp - 0x64]
  02945E  486E: 9aec081f19       lcall 0x191f, 0x8ec
  029463  4873: 83c406           add sp, 6
  029466  4876: ffb6d0fe         push word ptr [bp - 0x130]
  02946A  487A: 9ab40b1f18       lcall 0x181f, 0xbb4
  02946F  487F: 83c402           add sp, 2
  029472  4882: 8946f4           mov word ptr [bp - 0xc], ax
  029475  4885: 8b46fa           mov ax, word ptr [bp - 6]
  029478  4888: 3986d0fe         cmp word ptr [bp - 0x130], ax
  02947C  488C: 7505             jne 0x4893
  02947E  488E: c746f4feff       mov word ptr [bp - 0xc], 0xfffe
  029483  4893: 837ef400         cmp word ptr [bp - 0xc], 0
  029487  4897: 7503             jne 0x489c
  029489  4899: e9ca01           jmp 0x4a66
  02948C  489C: c646a400         mov byte ptr [bp - 0x5c], 0
  029490  48A0: 8b9ed0fe         mov bx, word ptr [bp - 0x130]
  029494  48A4: c1e303           shl bx, 3
  029497  48A7: ffb7a28e         push word ptr [bx - 0x715e]
  02949B  48AB: 8d46a4           lea ax, [bp - 0x5c]
  02949E  48AE: 50               push ax
  02949F  48AF: 9a6e011f18       lcall 0x181f, 0x16e
  0294A4  48B4: 83c404           add sp, 4
  0294A7  48B7: 68a30c           push 0xca3
  0294AA  48BA: 8d46a4           lea ax, [bp - 0x5c]
  0294AD  48BD: 50               push ax
  0294AE  48BE: 9aa4071d0d       lcall 0xd1d, 0x7a4
  0294B3  48C3: 83c404           add sp, 4
  0294B6  48C6: 83bed0fe13       cmp word ptr [bp - 0x130], 0x13
  0294BB  48CB: 7c03             jl 0x48d0
  0294BD  48CD: e98300           jmp 0x4953
  0294C0  48D0: 83bed0fe12       cmp word ptr [bp - 0x130], 0x12
  0294C5  48D5: 747c             je 0x4953
  0294C7  48D7: 68a80c           push 0xca8
  0294CA  48DA: 8d46a4           lea ax, [bp - 0x5c]
  0294CD  48DD: 50               push ax
  0294CE  48DE: 9aa4071d0d       lcall 0xd1d, 0x7a4
  0294D3  48E3: 83c404           add sp, 4
  0294D6  48E6: 83be14ff00       cmp word ptr [bp - 0xec], 0
  0294DB  48EB: 742d             je 0x491a
  0294DD  48ED: 83bed0fe08       cmp word ptr [bp - 0x130], 8
  0294E2  48F2: 7f26             jg 0x491a
  0294E4  48F4: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  0294E8  48F8: d1e6             shl si, 1
  0294EA  48FA: ffb216ff         push word ptr [bp + si - 0xea]
  0294EE  48FE: 8d46a4           lea ax, [bp - 0x5c]
  0294F1  4901: 16               push ss
  0294F2  4902: 50               push ax
  0294F3  4903: 9a82011f18       lcall 0x181f, 0x182
  0294F8  4908: 83c406           add sp, 6
  0294FB  490B: 68ac0c           push 0xcac
  0294FE  490E: 8d46a4           lea ax, [bp - 0x5c]
  029501  4911: 50               push ax
  029502  4912: 9aa4071d0d       lcall 0xd1d, 0x7a4
  029507  4917: 83c404           add sp, 4
  02950A  491A: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  02950E  491E: d1e6             shl si, 1
  029510  4920: ffb2d6fe         push word ptr [bp + si - 0x12a]
  029514  4924: 8d46a4           lea ax, [bp - 0x5c]
  029517  4927: 16               push ss
  029518  4928: 50               push ax
  029519  4929: 9a82011f18       lcall 0x181f, 0x182
  02951E  492E: 83c406           add sp, 6
  029521  4931: 8d46a4           lea ax, [bp - 0x5c]
  029524  4934: 50               push ax
  029525  4935: 9a78011f18       lcall 0x181f, 0x178
  02952A  493A: 83c402           add sp, 2
  02952D  493D: 8b9a3aff         mov bx, word ptr [bp + si - 0xc6]
  029531  4941: d1e3             shl bx, 1
  029533  4943: ffb7c097         push word ptr [bx - 0x6840]
  029537  4947: 8d46a4           lea ax, [bp - 0x5c]
  02953A  494A: 50               push ax
  02953B  494B: 9a6e011f18       lcall 0x181f, 0x16e
  029540  4950: 83c404           add sp, 4
  029543  4953: ffb6d0fe         push word ptr [bp - 0x130]
  029547  4957: 8d86c2fe         lea ax, [bp - 0x13e]
  02954B  495B: 50               push ax
  02954C  495C: 9a460b1f18       lcall 0x181f, 0xb46
  029551  4961: 83c404           add sp, 4
  029554  4964: 8986cafe         mov word ptr [bp - 0x136], ax
  029558  4968: 0bc0             or ax, ax
  02955A  496A: 7d03             jge 0x496f
  02955C  496C: e99100           jmp 0x4a00
  02955F  496F: 8b46fa           mov ax, word ptr [bp - 6]
  029562  4972: 3986d0fe         cmp word ptr [bp - 0x130], ax
  029566  4976: 7503             jne 0x497b
  029568  4978: e98500           jmp 0x4a00
  02956B  497B: c786c8fe0000     mov word ptr [bp - 0x138], 0
  029571  4981: eb73             jmp 0x49f6
  029573  4983: 90               nop 
  029574  4984: 8d46a4           lea ax, [bp - 0x5c]
  029577  4987: 50               push ax
  029578  4988: 9a78011f18       lcall 0x181f, 0x178
  02957D  498D: 83c402           add sp, 2
  029580  4990: 8d46a4           lea ax, [bp - 0x5c]
  029583  4993: 50               push ax
  029584  4994: 9a1e011f18       lcall 0x181f, 0x11e
  029589  4999: 83c402           add sp, 2
  02958C  499C: 8bb6c8fe         mov si, word ptr [bp - 0x138]
  029590  49A0: d1e6             shl si, 1
  029592  49A2: 8bb2c2fe         mov si, word ptr [bp + si - 0x13e]
  029596  49A6: 8a428c           mov al, byte ptr [bp + si - 0x74]
  029599  49A9: 2ae4             sub ah, ah
  02959B  49AB: 898636ff         mov word ptr [bp - 0xca], ax
  02959F  49AF: 50               push ax
  0295A0  49B0: 8d46a4           lea ax, [bp - 0x5c]
  0295A3  49B3: 16               push ss
  0295A4  49B4: 50               push ax
  0295A5  49B5: 9a82011f18       lcall 0x181f, 0x182
  0295AA  49BA: 83c406           add sp, 6
  0295AD  49BD: 8d46a4           lea ax, [bp - 0x5c]
  0295B0  49C0: 50               push ax
  0295B1  49C1: 9a78011f18       lcall 0x181f, 0x178
  0295B6  49C6: 83c402           add sp, 2
  0295B9  49C9: d1e6             shl si, 1
  0295BB  49CB: ffb4c097         push word ptr [si - 0x6840]
  0295BF  49CF: 9a22001f18       lcall 0x181f, 0x22
  0295C4  49D4: 83c402           add sp, 2
  0295C7  49D7: 52               push dx
  0295C8  49D8: 50               push ax
  0295C9  49D9: 8d46a4           lea ax, [bp - 0x5c]
  0295CC  49DC: 16               push ss
  0295CD  49DD: 50               push ax
  0295CE  49DE: 9ab4111d0d       lcall 0xd1d, 0x11b4
  0295D3  49E3: 83c408           add sp, 8
  0295D6  49E6: 8d46a4           lea ax, [bp - 0x5c]
  0295D9  49E9: 50               push ax
  0295DA  49EA: 9a28011f18       lcall 0x181f, 0x128
  0295DF  49EF: 83c402           add sp, 2
  0295E2  49F2: ff86c8fe         inc word ptr [bp - 0x138]
  0295E6  49F6: 8b86cafe         mov ax, word ptr [bp - 0x136]
  0295EA  49FA: 3986c8fe         cmp word ptr [bp - 0x138], ax
  0295EE  49FE: 7c84             jl 0x4984
  0295F0  4A00: 8b86d0fe         mov ax, word ptr [bp - 0x130]
  0295F4  4A04: 40               inc ax
  0295F5  4A05: 50               push ax
  0295F6  4A06: 8d4ea4           lea cx, [bp - 0x5c]
  0295F9  4A09: 16               push ss
  0295FA  4A0A: 51               push cx
  0295FB  4A0B: ff769e           push word ptr [bp - 0x62]
  0295FE  4A0E: ff769c           push word ptr [bp - 0x64]
  029601  4A11: 8bf0             mov si, ax
  029603  4A13: 9a76011f19       lcall 0x191f, 0x176
  029608  4A18: 83c40a           add sp, 0xa
  02960B  4A1B: ff367c8d         push word ptr [0x8d7c]
  02960F  4A1F: 9a540c1f18       lcall 0x181f, 0xc54
  029614  4A24: 83c402           add sp, 2
  029617  4A27: 8986ccfe         mov word ptr [bp - 0x134], ax
  02961B  4A2B: 837ef4ff         cmp word ptr [bp - 0xc], -1
  02961F  4A2F: 7403             je 0x4a34
  029621  4A31: e90c01           jmp 0x4b40
  029624  4A34: 6a01             push 1
  029626  4A36: 56               push si
  029627  4A37: ff769e           push word ptr [bp - 0x62]
  02962A  4A3A: ff769c           push word ptr [bp - 0x64]
  02962D  4A3D: 9ab6011f19       lcall 0x191f, 0x1b6
  029632  4A42: 83c408           add sp, 8
  029635  4A45: 8b46fa           mov ax, word ptr [bp - 6]
  029638  4A48: 3986d0fe         cmp word ptr [bp - 0x130], ax
  02963C  4A4C: 7514             jne 0x4a62
  02963E  4A4E: 8b86d0fe         mov ax, word ptr [bp - 0x130]
  029642  4A52: 40               inc ax
  029643  4A53: 50               push ax
  029644  4A54: ff769e           push word ptr [bp - 0x62]
  029647  4A57: ff769c           push word ptr [bp - 0x64]
  02964A  4A5A: 9aec081f19       lcall 0x191f, 0x8ec
  02964F  4A5F: 83c406           add sp, 6
  029652  4A62: ff8ecefe         dec word ptr [bp - 0x132]
  029656  4A66: ff86d0fe         inc word ptr [bp - 0x130]
  02965A  4A6A: 83becefe00       cmp word ptr [bp - 0x132], 0
  02965F  4A6F: 7e0a             jle 0x4a7b
  029661  4A71: 83bed0fe19       cmp word ptr [bp - 0x130], 0x19
  029666  4A76: 7d03             jge 0x4a7b
  029668  4A78: e9fbfd           jmp 0x4876
  02966B  4A7B: 837ea001         cmp word ptr [bp - 0x60], 1
  02966F  4A7F: 7e24             jle 0x4aa5
  029671  4A81: 837efc00         cmp word ptr [bp - 4], 0
  029675  4A85: 751e             jne 0x4aa5
  029677  4A87: 6a62             push 0x62
  029679  4A89: ff36aa93         push word ptr [0x93aa]
  02967D  4A8D: 9a22001f18       lcall 0x181f, 0x22
  029682  4A92: 83c402           add sp, 2
  029685  4A95: 52               push dx
  029686  4A96: 50               push ax
  029687  4A97: ff769e           push word ptr [bp - 0x62]
  02968A  4A9A: ff769c           push word ptr [bp - 0x64]
  02968D  4A9D: 9a76011f19       lcall 0x191f, 0x176
  029692  4AA2: 83c40a           add sp, 0xa
  029695  4AA5: c706661f0100     mov word ptr [0x1f66], 1
  02969B  4AAB: ff769e           push word ptr [bp - 0x62]
  02969E  4AAE: ff769c           push word ptr [bp - 0x64]
  0296A1  4AB1: 9a6a011f19       lcall 0x191f, 0x16a
  0296A6  4AB6: 8946a2           mov word ptr [bp - 0x5e], ax
  0296A9  4AB9: ff769e           push word ptr [bp - 0x62]
  0296AC  4ABC: ff769c           push word ptr [bp - 0x64]
  0296AF  4ABF: 9aa8011f19       lcall 0x191f, 0x1a8
  0296B4  4AC4: 2bc0             sub ax, ax
  0296B6  4AC6: 89469e           mov word ptr [bp - 0x62], ax
  0296B9  4AC9: 89469c           mov word ptr [bp - 0x64], ax
  0296BC  4ACC: 837ea262         cmp word ptr [bp - 0x5e], 0x62
  0296C0  4AD0: 7509             jne 0x4adb
  0296C2  4AD2: b80100           mov ax, 1
  0296C5  4AD5: 2b46fc           sub ax, word ptr [bp - 4]
  0296C8  4AD8: 8946fc           mov word ptr [bp - 4], ax
  0296CB  4ADB: 833e681f00       cmp word ptr [0x1f68], 0
  0296D0  4AE0: 740b             je 0x4aed
  0296D2  4AE2: 837ea261         cmp word ptr [bp - 0x5e], 0x61
  0296D6  4AE6: 7505             jne 0x4aed
  0296D8  4AE8: c746a26200       mov word ptr [bp - 0x5e], 0x62
  0296DD  4AED: 837ea262         cmp word ptr [bp - 0x5e], 0x62
  0296E1  4AF1: 7503             jne 0x4af6
  0296E3  4AF3: e947fb           jmp 0x463d
  0296E6  4AF6: 833e681f00       cmp word ptr [0x1f68], 0
  0296EB  4AFB: 7471             je 0x4b6e
  0296ED  4AFD: c706681f0000     mov word ptr [0x1f68], 0
  0296F3  4B03: 837ea200         cmp word ptr [bp - 0x5e], 0
  0296F7  4B07: 7e65             jle 0x4b6e
  0296F9  4B09: c786d0fe0000     mov word ptr [bp - 0x130], 0
  0296FF  4B0F: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  029703  4B13: d1e6             shl si, 1
  029705  4B15: 8b826cff         mov ax, word ptr [bp + si - 0x94]
  029709  4B19: 8b1e4285         mov bx, word ptr [0x8542]
  02970D  4B1D: 29809a00         sub word ptr [bx + si + 0x9a], ax
  029711  4B21: ff86d0fe         inc word ptr [bp - 0x130]
  029715  4B25: 83bed0fe10       cmp word ptr [bp - 0x130], 0x10
  02971A  4B2A: 7ce3             jl 0x4b0f
  02971C  4B2C: 8b46a2           mov ax, word ptr [bp - 0x5e]
  02971F  4B2F: 48               dec ax
  029720  4B30: 50               push ax
  029721  4B31: 9ade081f19       lcall 0x191f, 0x8de
  029726  4B36: 83c402           add sp, 2
  029729  4B39: 0e               push cs
  02972A  4B3A: e80033           call 0x7e3d
  02972D  4B3D: e96ff6           jmp 0x41af
  029730  4B40: 3986d0fe         cmp word ptr [bp - 0x130], ax
  029734  4B44: 7412             je 0x4b58
  029736  4B46: 83bed0fe17       cmp word ptr [bp - 0x130], 0x17
  02973B  4B4B: 7403             je 0x4b50
  02973D  4B4D: e9f5fe           jmp 0x4a45
  029740  4B50: 3d1500           cmp ax, 0x15
  029743  4B53: 7403             je 0x4b58
  029745  4B55: e9edfe           jmp 0x4a45
  029748  4B58: 6a01             push 1
  02974A  4B5A: 8b86d0fe         mov ax, word ptr [bp - 0x130]
  02974E  4B5E: 40               inc ax
  02974F  4B5F: 50               push ax
  029750  4B60: ff769e           push word ptr [bp - 0x62]
  029753  4B63: ff769c           push word ptr [bp - 0x64]
  029756  4B66: 9a3c031f19       lcall 0x191f, 0x33c
  02975B  4B6B: e9d4fe           jmp 0x4a42
  02975E  4B6E: c786d0fe0000     mov word ptr [bp - 0x130], 0
  029764  4B74: 8bb6d0fe         mov si, word ptr [bp - 0x130]
  029768  4B78: d1e6             shl si, 1
  02976A  4B7A: 8b826cff         mov ax, word ptr [bp + si - 0x94]
  02976E  4B7E: 8b1e4285         mov bx, word ptr [0x8542]
  029772  4B82: 29809a00         sub word ptr [bx + si + 0x9a], ax
  029776  4B86: ff86d0fe         inc word ptr [bp - 0x130]
  02977A  4B8A: 83bed0fe10       cmp word ptr [bp - 0x130], 0x10
  02977F  4B8F: 7ce3             jl 0x4b74
  029781  4B91: c7065c030000     mov word ptr [0x35c], 0
  029787  4B97: 837ea261         cmp word ptr [bp - 0x5e], 0x61
  02978B  4B9B: 753d             jne 0x4bda
  02978D  4B9D: 8b9eccfe         mov bx, word ptr [bp - 0x134]
  029791  4BA1: c1e303           shl bx, 3
  029794  4BA4: ffb7a48e         push word ptr [bx - 0x715c]
  029798  4BA8: 6a00             push 0
  02979A  4BAA: 9a38041f18       lcall 0x181f, 0x438
  02979F  4BAF: 83c404           add sp, 4
  0297A2  4BB2: 6a05             push 5
  0297A4  4BB4: 68ae0c           push 0xcae
  0297A7  4BB7: 9a52061f18       lcall 0x181f, 0x652
  0297AC  4BBC: 83c404           add sp, 4
  0297AF  4BBF: 48               dec ax
  0297B0  4BC0: 750e             jne 0x4bd0
  0297B2  4BC2: 6a1c             push 0x1c
  0297B4  4BC4: ff367c8d         push word ptr [0x8d7c]
  0297B8  4BC8: 9aae0c1f18       lcall 0x181f, 0xcae
  0297BD  4BCD: 83c404           add sp, 4
  0297C0  4BD0: 8b46fa           mov ax, word ptr [bp - 6]
  0297C3  4BD3: 898634ff         mov word ptr [bp - 0xcc], ax
  0297C7  4BD7: eb56             jmp 0x4c2f
  0297C9  4BD9: 90               nop 
  0297CA  4BDA: 837ea200         cmp word ptr [bp - 0x5e], 0
  0297CE  4BDE: 7e38             jle 0x4c18
  0297D0  4BE0: 8b46a2           mov ax, word ptr [bp - 0x5e]
  0297D3  4BE3: 48               dec ax
  0297D4  4BE4: 898634ff         mov word ptr [bp - 0xcc], ax
  0297D8  4BE8: 50               push ax
  0297D9  4BE9: ff367c8d         push word ptr [0x8d7c]
  0297DD  4BED: 0e               push cs
  0297DE  4BEE: e8ca31           call 0x7dbb
  0297E1  4BF1: 83c404           add sp, 4
  0297E4  4BF4: 0bc0             or ax, ax
  0297E6  4BF6: 7537             jne 0x4c2f
  0297E8  4BF8: 837efa09         cmp word ptr [bp - 6], 9
  0297EC  4BFC: 7c31             jl 0x4c2f
  0297EE  4BFE: 83be34ff09       cmp word ptr [bp - 0xcc], 9
  0297F3  4C03: 7d2a             jge 0x4c2f
  0297F5  4C05: ffb634ff         push word ptr [bp - 0xcc]
  0297F9  4C09: ff367c8d         push word ptr [0x8d7c]
  0297FD  4C0D: 9a6e0b1f18       lcall 0x181f, 0xb6e
  029802  4C12: 83c404           add sp, 4
  029805  4C15: eb18             jmp 0x4c2f
  029807  4C17: 90               nop 
  029808  4C18: 8b46fa           mov ax, word ptr [bp - 6]
  02980B  4C1B: 898634ff         mov word ptr [bp - 0xcc], ax
  02980F  4C1F: 50               push ax
  029810  4C20: ff367c8d         push word ptr [0x8d7c]
  029814  4C24: 9a360c1f18       lcall 0x181f, 0xc36
  029819  4C29: 83c404           add sp, 4
  02981C  4C2C: a37c8d           mov word ptr [0x8d7c], ax
  02981F  4C2F: 83bebafe00       cmp word ptr [bp - 0x146], 0
  029824  4C34: 7442             je 0x4c78
  029826  4C36: 83be34ff15       cmp word ptr [bp - 0xcc], 0x15
  02982B  4C3B: 7407             je 0x4c44
  02982D  4C3D: 83be34ff17       cmp word ptr [bp - 0xcc], 0x17
  029832  4C42: 7534             jne 0x4c78
  029834  4C44: 8b1e4285         mov bx, word ptr [0x8542]
  029838  4C48: 8a471f           mov al, byte ptr [bx + 0x1f]
  02983B  4C4B: 98               cwde 
  02983C  4C4C: 2b067c8d         sub ax, word ptr [0x8d7c]
  029840  4C50: f7d8             neg ax
  029842  4C52: 50               push ax
  029843  4C53: 9ac80b1f18       lcall 0x181f, 0xbc8
  029848  4C58: 83c402           add sp, 2
  02984B  4C5B: 8986c0fe         mov word ptr [bp - 0x140], ax
  02984F  4C5F: 83be34ff15       cmp word ptr [bp - 0xcc], 0x15
  029854  4C64: 750a             jne 0x4c70
  029856  4C66: 6bd81c           imul bx, ax, 0x1c
  029859  4C69: c687463109       mov byte ptr [bx + 0x3146], 9
  02985E  4C6E: eb08             jmp 0x4c78
  029860  4C70: 6bd81c           imul bx, ax, 0x1c
  029863  4C73: c687463107       mov byte ptr [bx + 0x3146], 7
  029868  4C78: 0e               push cs
  029869  4C79: e80c32           call 0x7e88
  02986C  4C7C: 83be0eff00       cmp word ptr [bp - 0xf2], 0
  029871  4C81: 7409             je 0x4c8c
  029873  4C83: a17c8d           mov ax, word ptr [0x8d7c]
  029876  4C86: a34e03           mov word ptr [0x34e], ax
  029879  4C89: eb0e             jmp 0x4c99
  02987B  4C8B: 90               nop 
  02987C  4C8C: 83be34ff13       cmp word ptr [bp - 0xcc], 0x13
  029881  4C91: 7c06             jl 0x4c99
  029883  4C93: c7064e03ffff     mov word ptr [0x34e], 0xffff
  029889  4C99: c7065c030000     mov word ptr [0x35c], 0
  02988F  4C9F: 8b469e           mov ax, word ptr [bp - 0x62]
  029892  4CA2: 0b469c           or ax, word ptr [bp - 0x64]
  029895  4CA5: 740b             je 0x4cb2
  029897  4CA7: ff769e           push word ptr [bp - 0x62]
  02989A  4CAA: ff769c           push word ptr [bp - 0x64]
  02989D  4CAD: 9aa8011f19       lcall 0x191f, 0x1a8
  0298A2  4CB2: 5e               pop si
  0298A3  4CB3: c9               leave 
  0298A4  4CB4: cb               retf 
  0298A5  4CB5: 90               nop 
  0298A6  4CB6: 56               push si
  0298A7  4CB7: 8b363003         mov si, word ptr [0x330]
  0298AB  4CBB: 8bc6             mov ax, si
  0298AD  4CBD: c1e602           shl si, 2
  0298B0  4CC0: 03f0             add si, ax
  0298B2  4CC2: 8b1e3203         mov bx, word ptr [0x332]
  0298B6  4CC6: 80b8f08d00       cmp byte ptr [bx + si - 0x7210], 0
  0298BB  4CCB: 7403             je 0x4cd0
  0298BD  4CCD: e9d900           jmp 0x4da9
  0298C0  4CD0: 53               push bx
  0298C1  4CD1: 50               push ax
  0298C2  4CD2: 9ae00c1f18       lcall 0x181f, 0xce0
  0298C7  4CD7: 83c404           add sp, 4
  0298CA  4CDA: fec0             inc al
  0298CC  4CDC: 7403             je 0x4ce1
  0298CE  4CDE: e99300           jmp 0x4d74
  0298D1  4CE1: ff363203         push word ptr [0x332]
  0298D5  4CE5: ff363003         push word ptr [0x330]
  0298D9  4CE9: 0e               push cs
  0298DA  4CEA: e8ba30           call 0x7da7
  0298DD  4CED: 83c404           add sp, 4
  0298E0  4CF0: ff367c8d         push word ptr [0x8d7c]
  0298E4  4CF4: 9a0e0c1f18       lcall 0x181f, 0xc0e
  0298E9  4CF9: 83c402           add sp, 2
  0298EC  4CFC: 3d0900           cmp ax, 9
  0298EF  4CFF: 7d09             jge 0x4d0a
  0298F1  4D01: 0bc0             or ax, ax
  0298F3  4D03: 7405             je 0x4d0a
  0298F5  4D05: 3d0800           cmp ax, 8
  0298F8  4D08: 7530             jne 0x4d3a
  0298FA  4D0A: 8b1e4285         mov bx, word ptr [0x8542]
  0298FE  4D0E: 8a4701           mov al, byte ptr [bx + 1]
  029901  4D11: 2ae4             sub ah, ah
  029903  4D13: 03063203         add ax, word ptr [0x332]
  029907  4D17: 48               dec ax
  029908  4D18: 48               dec ax
  029909  4D19: 50               push ax
  02990A  4D1A: 8a07             mov al, byte ptr [bx]
  02990C  4D1C: 2ae4             sub ah, ah
  02990E  4D1E: 03063003         add ax, word ptr [0x330]
  029912  4D22: 48               dec ax
  029913  4D23: 48               dec ax
  029914  4D24: 50               push ax
  029915  4D25: 9a68071f18       lcall 0x181f, 0x768
  02991A  4D2A: 83c404           add sp, 4
  02991D  4D2D: 0bc0             or ax, ax
  02991F  4D2F: 7405             je 0x4d36
  029921  4D31: 6a08             push 8
  029923  4D33: eb06             jmp 0x4d3b
  029925  4D35: 90               nop 
  029926  4D36: 6a00             push 0
  029928  4D38: eb01             jmp 0x4d3b
  02992A  4D3A: 50               push ax
  02992B  4D3B: ff367c8d         push word ptr [0x8d7c]
  02992F  4D3F: 0e               push cs
  029930  4D40: e87830           call 0x7dbb
  029933  4D43: 83c404           add sp, 4
  029936  4D46: 3d0100           cmp ax, 1
  029939  4D49: 1bc0             sbb ax, ax
  02993B  4D4B: f7d8             neg ax
  02993D  4D4D: 0bc0             or ax, ax
  02993F  4D4F: 7458             je 0x4da9
  029941  4D51: ff367c8d         push word ptr [0x8d7c]
  029945  4D55: 9aa60a1f18       lcall 0x181f, 0xaa6
  02994A  4D5A: 83c402           add sp, 2
  02994D  4D5D: a07c8d           mov al, byte ptr [0x8d7c]
  029950  4D60: 50               push ax
  029951  4D61: ff363203         push word ptr [0x332]
  029955  4D65: ff363003         push word ptr [0x330]
  029959  4D69: 9a440d1f18       lcall 0x181f, 0xd44
  02995E  4D6E: 83c406           add sp, 6
  029961  4D71: eb36             jmp 0x4da9
  029963  4D73: 90               nop 
  029964  4D74: ff363203         push word ptr [0x332]
  029968  4D78: ff363003         push word ptr [0x330]
  02996C  4D7C: 9ae00c1f18       lcall 0x181f, 0xce0
  029971  4D81: 83c404           add sp, 4
  029974  4D84: 3a067c8d         cmp al, byte ptr [0x8d7c]
  029978  4D88: 7416             je 0x4da0
  02997A  4D8A: ff363203         push word ptr [0x332]
  02997E  4D8E: ff363003         push word ptr [0x330]
  029982  4D92: 9ae00c1f18       lcall 0x181f, 0xce0
  029987  4D97: 83c404           add sp, 4
  02998A  4D9A: 98               cwde 
  02998B  4D9B: a37c8d           mov word ptr [0x8d7c], ax
  02998E  4D9E: eb09             jmp 0x4da9
  029990  4DA0: 6a00             push 0
  029992  4DA2: 0e               push cs
  029993  4DA3: e8ec30           call 0x7e92
  029996  4DA6: 83c402           add sp, 2
  029999  4DA9: 0e               push cs
  02999A  4DAA: e8db30           call 0x7e88
  02999D  4DAD: 5e               pop si
  02999E  4DAE: cb               retf 

; ---- func_0299A0  size=287  insns=108  prologue=ENTER 0x0002,0  terminal=RETF ----
  0299A0  4DB0: c8020000         enter 2, 0
  0299A4  4DB4: c746fe1400       mov word ptr [bp - 2], 0x14
  0299A9  4DB9: 6a78             push 0x78
  0299AB  4DBB: 6a78             push 0x78
  0299AD  4DBD: 6a08             push 8
  0299AF  4DBF: 68c800           push 0xc8
  0299B2  4DC2: 9aca031f18       lcall 0x181f, 0x3ca
  0299B7  4DC7: 83c408           add sp, 8
  0299BA  4DCA: 0bc0             or ax, ax
  0299BC  4DCC: 740a             je 0x4dd8
  0299BE  4DCE: c746fe0100       mov word ptr [bp - 2], 1
  0299C3  4DD3: 8b46fe           mov ax, word ptr [bp - 2]
  0299C6  4DD6: c9               leave 
  0299C7  4DD7: cb               retf 
  0299C8  4DD8: 6a15             push 0x15
  0299CA  4DDA: 6a0f             push 0xf
  0299CC  4DDC: 68b300           push 0xb3
  0299CF  4DDF: 683101           push 0x131
  0299D2  4DE2: 9aca031f18       lcall 0x181f, 0x3ca
  0299D7  4DE7: 83c408           add sp, 8
  0299DA  4DEA: 0bc0             or ax, ax
  0299DC  4DEC: 740a             je 0x4df8
  0299DE  4DEE: c746fe0900       mov word ptr [bp - 2], 9
  0299E3  4DF3: 8b46fe           mov ax, word ptr [bp - 2]
  0299E6  4DF6: c9               leave 
  0299E7  4DF7: cb               retf 
  0299E8  4DF8: 6a30             push 0x30
  0299EA  4DFA: 6a78             push 0x78
  0299EC  4DFC: 688200           push 0x82
  0299EF  4DFF: 6a00             push 0
  0299F1  4E01: 9aca031f18       lcall 0x181f, 0x3ca
  0299F6  4E06: 83c408           add sp, 8
  0299F9  4E09: 0bc0             or ax, ax
  0299FB  4E0B: 740b             je 0x4e18
  0299FD  4E0D: c746fe0000       mov word ptr [bp - 2], 0
  029A02  4E12: 8b46fe           mov ax, word ptr [bp - 2]
  029A05  4E15: c9               leave 
  029A06  4E16: cb               retf 
  029A07  4E17: 90               nop 
  029A08  4E18: 6a78             push 0x78
  029A0A  4E1A: 68c700           push 0xc7
  029A0D  4E1D: 6a08             push 8
  029A0F  4E1F: 6a00             push 0
  029A11  4E21: 9aca031f18       lcall 0x181f, 0x3ca
  029A16  4E26: 83c408           add sp, 8
  029A19  4E29: 0bc0             or ax, ax
  029A1B  4E2B: 740b             je 0x4e38
  029A1D  4E2D: c746fe0200       mov word ptr [bp - 2], 2
  029A22  4E32: 8b46fe           mov ax, word ptr [bp - 2]
  029A25  4E35: c9               leave 
  029A26  4E36: cb               retf 
  029A27  4E37: 90               nop 
  029A28  4E38: 6a2d             push 0x2d
  029A2A  4E3A: 6a11             push 0x11
  029A2C  4E3C: 688400           push 0x84
  029A2F  4E3F: 682f01           push 0x12f
  029A32  4E42: 9aca031f18       lcall 0x181f, 0x3ca
  029A37  4E47: 83c408           add sp, 8
  029A3A  4E4A: 0bc0             or ax, ax
  029A3C  4E4C: 740a             je 0x4e58
  029A3E  4E4E: c746fe0300       mov word ptr [bp - 2], 3
  029A43  4E53: 8b46fe           mov ax, word ptr [bp - 2]
  029A46  4E56: c9               leave 
  029A47  4E57: cb               retf 
  029A48  4E58: 6a15             push 0x15
  029A4A  4E5A: 683101           push 0x131
  029A4D  4E5D: 68b300           push 0xb3
  029A50  4E60: 6a00             push 0
  029A52  4E62: 9aca031f18       lcall 0x181f, 0x3ca
  029A57  4E67: 83c408           add sp, 8
  029A5A  4E6A: 0bc0             or ax, ax
  029A5C  4E6C: 7408             je 0x4e76
  029A5E  4E6E: c746fe0500       mov word ptr [bp - 2], 5
  029A63  4E73: eb55             jmp 0x4eca
  029A65  4E75: 90               nop 
  029A66  4E76: 6a30             push 0x30
  029A68  4E78: 6a5b             push 0x5b
  029A6A  4E7A: 688200           push 0x82
  029A6D  4E7D: 68d300           push 0xd3
  029A70  4E80: 9aca031f18       lcall 0x181f, 0x3ca
  029A75  4E85: 83c408           add sp, 8
  029A78  4E88: 0bc0             or ax, ax
  029A7A  4E8A: 7408             je 0x4e94
  029A7C  4E8C: c746fe0400       mov word ptr [bp - 2], 4
  029A81  4E91: eb37             jmp 0x4eca
  029A83  4E93: 90               nop 
  029A84  4E94: 6a30             push 0x30
  029A86  4E96: 6a54             push 0x54
  029A88  4E98: 688200           push 0x82
  029A8B  4E9B: 6a79             push 0x79
  029A8D  4E9D: 9aca031f18       lcall 0x181f, 0x3ca
  029A92  4EA2: 83c408           add sp, 8
  029A95  4EA5: 0bc0             or ax, ax
  029A97  4EA7: 7407             je 0x4eb0
  029A99  4EA9: c746fe0800       mov word ptr [bp - 2], 8
  029A9E  4EAE: eb1a             jmp 0x4eca
  029AA0  4EB0: 6a07             push 7
  029AA2  4EB2: 684001           push 0x140
  029AA5  4EB5: 6a00             push 0
  029AA7  4EB7: 6a00             push 0
  029AA9  4EB9: 9aca031f18       lcall 0x181f, 0x3ca
  029AAE  4EBE: 83c408           add sp, 8
  029AB1  4EC1: 0bc0             or ax, ax
  029AB3  4EC3: 7405             je 0x4eca
  029AB5  4EC5: c746fe0a00       mov word ptr [bp - 2], 0xa
  029ABA  4ECA: 8b46fe           mov ax, word ptr [bp - 2]
  029ABD  4ECD: c9               leave 
  029ABE  4ECE: cb               retf 

; ---- func_029AC0  size=196  insns=72  prologue=ENTER 0x0010,0  terminal=RETF ----
  029AC0  4ED0: c8100000         enter 0x10, 0
  029AC4  4ED4: 56               push si
  029AC5  4ED5: 8b1e4285         mov bx, word ptr [0x8542]
  029AC9  4ED9: 8a471f           mov al, byte ptr [bx + 0x1f]
  029ACC  4EDC: 98               cwde 
  029ACD  4EDD: 0306728d         add ax, word ptr [0x8d72]
  029AD1  4EE1: 8946f6           mov word ptr [bp - 0xa], ax
  029AD4  4EE4: 48               dec ax
  029AD5  4EE5: 8946fe           mov word ptr [bp - 2], ax
  029AD8  4EE8: c746fa0200       mov word ptr [bp - 6], 2
  029ADD  4EED: 2bc0             sub ax, ax
  029ADF  4EEF: 8946f0           mov word ptr [bp - 0x10], ax
  029AE2  4EF2: 8946fc           mov word ptr [bp - 4], ax
  029AE5  4EF5: 8946f2           mov word ptr [bp - 0xe], ax
  029AE8  4EF8: eb40             jmp 0x4f3a
  029AEA  4EFA: 837efc00         cmp word ptr [bp - 4], 0
  029AEE  4EFE: 7e0c             jle 0x4f0c
  029AF0  4F00: ff4ef4           dec word ptr [bp - 0xc]
  029AF3  4F03: ff4efc           dec word ptr [bp - 4]
  029AF6  4F06: 837ef401         cmp word ptr [bp - 0xc], 1
  029AFA  4F0A: 7fee             jg 0x4efa
  029AFC  4F0C: 8b46f4           mov ax, word ptr [bp - 0xc]
  029AFF  4F0F: 0146fa           add word ptr [bp - 6], ax
  029B02  4F12: 8b1e4285         mov bx, word ptr [0x8542]
  029B06  4F16: 8a471f           mov al, byte ptr [bx + 0x1f]
  029B09  4F19: 98               cwde 
  029B0A  4F1A: 2b46f2           sub ax, word ptr [bp - 0xe]
  029B0D  4F1D: 48               dec ax
  029B0E  4F1E: 7504             jne 0x4f24
  029B10  4F20: 8346fa04         add word ptr [bp - 6], 4
  029B14  4F24: a1e807           mov ax, word ptr [0x7e8]
  029B17  4F27: 3946fa           cmp word ptr [bp - 6], ax
  029B1A  4F2A: 7e0b             jle 0x4f37
  029B1C  4F2C: 8b46f2           mov ax, word ptr [bp - 0xe]
  029B1F  4F2F: 8946fe           mov word ptr [bp - 2], ax
  029B22  4F32: c746f00100       mov word ptr [bp - 0x10], 1
  029B27  4F37: ff46f2           inc word ptr [bp - 0xe]
  029B2A  4F3A: 837ef000         cmp word ptr [bp - 0x10], 0
  029B2E  4F3E: 754e             jne 0x4f8e
  029B30  4F40: 8b46f6           mov ax, word ptr [bp - 0xa]
  029B33  4F43: 3946f2           cmp word ptr [bp - 0xe], ax
  029B36  4F46: 7d46             jge 0x4f8e
  029B38  4F48: ff76f2           push word ptr [bp - 0xe]
  029B3B  4F4B: 9a740a1f18       lcall 0x181f, 0xa74
  029B40  4F50: 83c402           add sp, 2
  029B43  4F53: 8946f8           mov word ptr [bp - 8], ax
  029B46  4F56: a090a8           mov al, byte ptr [0xa890]
  029B49  4F59: 98               cwde 
  029B4A  4F5A: 8b76f8           mov si, word ptr [bp - 8]
  029B4D  4F5D: 8bce             mov cx, si
  029B4F  4F5F: d1e6             shl si, 1
  029B51  4F61: 03f1             add si, cx
  029B53  4F63: c1e602           shl si, 2
  029B56  4F66: c41e3e08         les bx, ptr [0x83e]
  029B5A  4F6A: 2603403e         add ax, word ptr es:[bx + si + 0x3e]
  029B5E  4F6E: 8946f4           mov word ptr [bp - 0xc], ax
  029B61  4F71: 3d0100           cmp ax, 1
  029B64  4F74: 7d06             jge 0x4f7c
  029B66  4F76: 48               dec ax
  029B67  4F77: f7d8             neg ax
  029B69  4F79: 0146fc           add word ptr [bp - 4], ax
  029B6C  4F7C: 8b46f4           mov ax, word ptr [bp - 0xc]
  029B6F  4F7F: 3d0100           cmp ax, 1
  029B72  4F82: 7d03             jge 0x4f87
  029B74  4F84: b80100           mov ax, 1
  029B77  4F87: 8946f4           mov word ptr [bp - 0xc], ax
  029B7A  4F8A: e979ff           jmp 0x4f06
  029B7D  4F8D: 90               nop 
  029B7E  4F8E: 8b46fe           mov ax, word ptr [bp - 2]
  029B81  4F91: 5e               pop si
  029B82  4F92: c9               leave 
  029B83  4F93: cb               retf 

; ---- func_029B84  size=57  insns=18  prologue=push bp;mov bp,sp  terminal=RETF ----
  029B84  4F94: 55               push bp
  029B85  4F95: 8bec             mov bp, sp
  029B87  4F97: ff364008         push word ptr [0x840]
  029B8B  4F9B: ff363e08         push word ptr [0x83e]
  029B8F  4F9F: ff7606           push word ptr [bp + 6]
  029B92  4FA2: 9a740a1f18       lcall 0x181f, 0xa74
  029B97  4FA7: 83c402           add sp, 2
  029B9A  4FAA: ba0100           mov dx, 1
  029B9D  4FAD: 9af8081f19       lcall 0x191f, 0x8f8
  029BA2  4FB2: c70644030100     mov word ptr [0x344], 1
  029BA8  4FB8: c706548d0600     mov word ptr [0x8d54], 6
  029BAE  4FBE: 8b4606           mov ax, word ptr [bp + 6]
  029BB1  4FC1: a37c8d           mov word ptr [0x8d7c], ax
  029BB4  4FC4: a37e8d           mov word ptr [0x8d7e], ax
  029BB7  4FC7: 0e               push cs
  029BB8  4FC8: e8bd2e           call 0x7e88
  029BBB  4FCB: c9               leave 
  029BBC  4FCC: cb               retf 

; ---- func_029BBE  size=82  insns=25  prologue=ENTER 0x0002,0  terminal=RETF ----
  029BBE  4FCE: c8020000         enter 2, 0
  029BC2  4FD2: ff364008         push word ptr [0x840]
  029BC6  4FD6: ff363e08         push word ptr [0x83e]
  029BCA  4FDA: 837e0864         cmp word ptr [bp + 8], 0x64
  029BCE  4FDE: 7c06             jl 0x4fe6
  029BD0  4FE0: b81700           mov ax, 0x17
  029BD3  4FE3: eb04             jmp 0x4fe9
  029BD5  4FE5: 90               nop 
  029BD6  4FE6: b82700           mov ax, 0x27
  029BD9  4FE9: 034606           add ax, word ptr [bp + 6]
  029BDC  4FEC: 2bd2             sub dx, dx
  029BDE  4FEE: 9af8081f19       lcall 0x191f, 0x8f8
  029BE3  4FF3: c70644030100     mov word ptr [0x344], 1
  029BE9  4FF9: c706548d0700     mov word ptr [0x8d54], 7
  029BEF  4FFF: c9               leave 
  029BF0  5000: cb               retf 
  029BF1  5001: 90               nop 
  029BF2  5002: 833e440300       cmp word ptr [0x344], 0
  029BF7  5007: 7416             je 0x501f
  029BF9  5009: ff363c08         push word ptr [0x83c]
  029BFD  500D: ff363a08         push word ptr [0x83a]
  029C01  5011: b80100           mov ax, 1
  029C04  5014: 9a68041f19       lcall 0x191f, 0x468
  029C09  5019: c70644030000     mov word ptr [0x344], 0
  029C0F  501F: cb               retf 

; ---- func_029C10  size=275  insns=96  prologue=ENTER 0x0008,0  terminal=RETF ----
  029C10  5020: c8080000         enter 8, 0
  029C14  5024: 0e               push cs
  029C15  5025: e8a62e           call 0x7ece
  029C18  5028: 8946f8           mov word ptr [bp - 8], ax
  029C1B  502B: 833e548d06       cmp word ptr [0x8d54], 6
  029C20  5030: 7520             jne 0x5052
  029C22  5032: 833ef40700       cmp word ptr [0x7f4], 0
  029C27  5037: 7503             jne 0x503c
  029C29  5039: e9f500           jmp 0x5131
  029C2C  503C: 833e568d00       cmp word ptr [0x8d56], 0
  029C31  5041: 7503             jne 0x5046
  029C33  5043: e9eb00           jmp 0x5131
  029C36  5046: 6a00             push 0
  029C38  5048: 0e               push cs
  029C39  5049: e8462e           call 0x7e92
  029C3C  504C: 83c402           add sp, 2
  029C3F  504F: c9               leave 
  029C40  5050: cb               retf 
  029C41  5051: 90               nop 
  029C42  5052: 39067e8d         cmp word ptr [0x8d7e], ax
  029C46  5056: 7507             jne 0x505f
  029C48  5058: 833e2e0301       cmp word ptr [0x32e], 1
  029C4D  505D: 743b             je 0x509a
  029C4F  505F: c7062e030100     mov word ptr [0x32e], 1
  029C55  5065: a37e8d           mov word ptr [0x8d7e], ax
  029C58  5068: 8d4efc           lea cx, [bp - 4]
  029C5B  506B: 51               push cx
  029C5C  506C: 8d56fe           lea dx, [bp - 2]
  029C5F  506F: 52               push dx
  029C60  5070: 50               push ax
  029C61  5071: 9a300d1f18       lcall 0x181f, 0xd30
  029C66  5076: 83c406           add sp, 6
  029C69  5079: 0bc0             or ax, ax
  029C6B  507B: 740c             je 0x5089
  029C6D  507D: 8b46fe           mov ax, word ptr [bp - 2]
  029C70  5080: a33003           mov word ptr [0x330], ax
  029C73  5083: 8b46fc           mov ax, word ptr [bp - 4]
  029C76  5086: a33203           mov word ptr [0x332], ax
  029C79  5089: 0e               push cs
  029C7A  508A: e8fb2d           call 0x7e88
  029C7D  508D: 833eec0700       cmp word ptr [0x7ec], 0
  029C82  5092: 7506             jne 0x509a
  029C84  5094: c706588d0000     mov word ptr [0x8d58], 0
  029C8A  509A: 833eee0700       cmp word ptr [0x7ee], 0
  029C8F  509F: 742c             je 0x50cd
  029C91  50A1: 833ee40700       cmp word ptr [0x7e4], 0
  029C96  50A6: 7525             jne 0x50cd
  029C98  50A8: 833e588d00       cmp word ptr [0x8d58], 0
  029C9D  50AD: 741e             je 0x50cd
  029C9F  50AF: 9a06000c0c       lcall 0xc0c, 6
  029CA4  50B4: 3b16608d         cmp dx, word ptr [0x8d60]
  029CA8  50B8: 7c13             jl 0x50cd
  029CAA  50BA: 7f06             jg 0x50c2
  029CAC  50BC: 3b065e8d         cmp ax, word ptr [0x8d5e]
  029CB0  50C0: 720b             jb 0x50cd
  029CB2  50C2: ff367e8d         push word ptr [0x8d7e]
  029CB6  50C6: 0e               push cs
  029CB7  50C7: e8ec2c           call 0x7db6
  029CBA  50CA: 83c402           add sp, 2
  029CBD  50CD: 833ef40700       cmp word ptr [0x7f4], 0
  029CC2  50D2: 745d             je 0x5131
  029CC4  50D4: 0e               push cs
  029CC5  50D5: e8832d           call 0x7e5b
  029CC8  50D8: 0bc0             or ax, ax
  029CCA  50DA: 7555             jne 0x5131
  029CCC  50DC: a17c8d           mov ax, word ptr [0x8d7c]
  029CCF  50DF: 39067e8d         cmp word ptr [0x8d7e], ax
  029CD3  50E3: 7409             je 0x50ee
  029CD5  50E5: a17e8d           mov ax, word ptr [0x8d7e]
  029CD8  50E8: a37c8d           mov word ptr [0x8d7c], ax
  029CDB  50EB: eb11             jmp 0x50fe
  029CDD  50ED: 90               nop 
  029CDE  50EE: 833ee40700       cmp word ptr [0x7e4], 0
  029CE3  50F3: 7509             jne 0x50fe
  029CE5  50F5: 6a00             push 0
  029CE7  50F7: 0e               push cs
  029CE8  50F8: e8972d           call 0x7e92
  029CEB  50FB: 83c402           add sp, 2
  029CEE  50FE: 0e               push cs
  029CEF  50FF: e8862d           call 0x7e88
  029CF2  5102: 833ee40700       cmp word ptr [0x7e4], 0
  029CF7  5107: 7428             je 0x5131
  029CF9  5109: ff367c8d         push word ptr [0x8d7c]
  029CFD  510D: 9a540c1f18       lcall 0x181f, 0xc54
  029D02  5112: 83c402           add sp, 2
  029D05  5115: 8946fa           mov word ptr [bp - 6], ax
  029D08  5118: 3d1c00           cmp ax, 0x1c
  029D0B  511B: 7505             jne 0x5122
  029D0D  511D: c746fa1300       mov word ptr [bp - 6], 0x13
  029D12  5122: ff76fa           push word ptr [bp - 6]
  029D15  5125: 9ade081f19       lcall 0x191f, 0x8de
  029D1A  512A: 83c402           add sp, 2
  029D1D  512D: 0e               push cs
  029D1E  512E: e80c2d           call 0x7e3d
  029D21  5131: c9               leave 
  029D22  5132: cb               retf 

; ---- func_029D24  size=176  insns=60  prologue=ENTER 0x0006,0  terminal=RETF ----
  029D24  5134: c8060000         enter 6, 0
  029D28  5138: 56               push si
  029D29  5139: 8d1e7c08         lea bx, [0x87c]
  029D2D  513D: 8d06b90c         lea ax, [0xcb9]
  029D31  5141: 2bd2             sub dx, dx
  029D33  5143: 9a82011f19       lcall 0x191f, 0x182
  029D38  5148: 8946fc           mov word ptr [bp - 4], ax
  029D3B  514B: 8956fe           mov word ptr [bp - 2], dx
  029D3E  514E: 0bd0             or dx, ax
  029D40  5150: 7478             je 0x51ca
  029D42  5152: c746fa0000       mov word ptr [bp - 6], 0
  029D47  5157: 8b46fa           mov ax, word ptr [bp - 6]
  029D4A  515A: 40               inc ax
  029D4B  515B: 50               push ax
  029D4C  515C: 8b5efa           mov bx, word ptr [bp - 6]
  029D4F  515F: d1e3             shl bx, 1
  029D51  5161: ffb7c097         push word ptr [bx - 0x6840]
  029D55  5165: 8bf0             mov si, ax
  029D57  5167: 9a22001f18       lcall 0x181f, 0x22
  029D5C  516C: 83c402           add sp, 2
  029D5F  516F: 52               push dx
  029D60  5170: 50               push ax
  029D61  5171: ff76fe           push word ptr [bp - 2]
  029D64  5174: ff76fc           push word ptr [bp - 4]
  029D67  5177: 9a76011f19       lcall 0x191f, 0x176
  029D6C  517C: 83c40a           add sp, 0xa
  029D6F  517F: ff76fa           push word ptr [bp - 6]
  029D72  5182: 9afe0c1f18       lcall 0x181f, 0xcfe
  029D77  5187: 83c402           add sp, 2
  029D7A  518A: 8bd0             mov dx, ax
  029D7C  518C: 8bc6             mov ax, si
  029D7E  518E: 9a62021f19       lcall 0x191f, 0x262
  029D83  5193: ff46fa           inc word ptr [bp - 6]
  029D86  5196: 837efa10         cmp word ptr [bp - 6], 0x10
  029D8A  519A: 7cbb             jl 0x5157
  029D8C  519C: ff76fe           push word ptr [bp - 2]
  029D8F  519F: ff76fc           push word ptr [bp - 4]
  029D92  51A2: 9a6a011f19       lcall 0x191f, 0x16a
  029D97  51A7: c746fa0000       mov word ptr [bp - 6], 0
  029D9C  51AC: 8b46fa           mov ax, word ptr [bp - 6]
  029D9F  51AF: 40               inc ax
  029DA0  51B0: 9a06031f19       lcall 0x191f, 0x306
  029DA5  51B5: 50               push ax
  029DA6  51B6: ff76fa           push word ptr [bp - 6]
  029DA9  51B9: 9a260d1f18       lcall 0x181f, 0xd26
  029DAE  51BE: 83c404           add sp, 4
  029DB1  51C1: ff46fa           inc word ptr [bp - 6]
  029DB4  51C4: 837efa10         cmp word ptr [bp - 6], 0x10
  029DB8  51C8: 7ce2             jl 0x51ac
  029DBA  51CA: 0e               push cs
  029DBB  51CB: e8dd2c           call 0x7eab
  029DBE  51CE: 8b46fe           mov ax, word ptr [bp - 2]
  029DC1  51D1: 0b46fc           or ax, word ptr [bp - 4]
  029DC4  51D4: 740b             je 0x51e1
  029DC6  51D6: ff76fe           push word ptr [bp - 2]
  029DC9  51D9: ff76fc           push word ptr [bp - 4]
  029DCC  51DC: 9aa8011f19       lcall 0x191f, 0x1a8
  029DD1  51E1: 5e               pop si
  029DD2  51E2: c9               leave 
  029DD3  51E3: cb               retf 

; ---- func_029DD4  size=744  insns=275  prologue=ENTER 0x0012,0  terminal=RETF ----
  029DD4  51E4: c8120000         enter 0x12, 0
  029DD8  51E8: 57               push di
  029DD9  51E9: 56               push si
  029DDA  51EA: b8ffff           mov ax, 0xffff
  029DDD  51ED: 8946fe           mov word ptr [bp - 2], ax
  029DE0  51F0: 8946f2           mov word ptr [bp - 0xe], ax
  029DE3  51F3: 0e               push cs
  029DE4  51F4: e8642c           call 0x7e5b
  029DE7  51F7: 3d0200           cmp ax, 2
  029DEA  51FA: 7403             je 0x51ff
  029DEC  51FC: e9c902           jmp 0x54c8
  029DEF  51FF: c746f40000       mov word ptr [bp - 0xc], 0
  029DF4  5204: e9b500           jmp 0x52bc
  029DF7  5207: 90               nop 
  029DF8  5208: 0bc0             or ax, ax
  029DFA  520A: 7d03             jge 0x520f
  029DFC  520C: e9aa00           jmp 0x52b9
  029DFF  520F: 50               push ax
  029E00  5210: 9ace0a1f18       lcall 0x181f, 0xace
  029E05  5215: 83c402           add sp, 2
  029E08  5218: 8946f0           mov word ptr [bp - 0x10], ax
  029E0B  521B: 0bc0             or ax, ax
  029E0D  521D: 7d03             jge 0x5222
  029E0F  521F: e99700           jmp 0x52b9
  029E12  5222: ff76fe           push word ptr [bp - 2]
  029E15  5225: 9aaa0b1f18       lcall 0x181f, 0xbaa
  029E1A  522A: 83c402           add sp, 2
  029E1D  522D: 0bc0             or ax, ax
  029E1F  522F: 7e0d             jle 0x523e
  029E21  5231: ff76fe           push word ptr [bp - 2]
  029E24  5234: 9aaa0b1f18       lcall 0x181f, 0xbaa
  029E29  5239: 83c402           add sp, 2
  029E2C  523C: eb0e             jmp 0x524c
  029E2E  523E: ff76fe           push word ptr [bp - 2]
  029E31  5241: 9aaa0b1f18       lcall 0x181f, 0xbaa
  029E36  5246: 83c402           add sp, 2
  029E39  5249: f7d0             not ax
  029E3B  524B: 40               inc ax
  029E3C  524C: 8946f6           mov word ptr [bp - 0xa], ax
  029E3F  524F: 8b5eee           mov bx, word ptr [bp - 0x12]
  029E42  5252: 8a873c02         mov al, byte ptr [bx + 0x23c]
  029E46  5256: 98               cwde 
  029E47  5257: 0346fc           add ax, word ptr [bp - 4]
  029E4A  525A: 50               push ax
  029E4B  525B: 8a874202         mov al, byte ptr [bx + 0x242]
  029E4F  525F: 98               cwde 
  029E50  5260: 0346fa           add ax, word ptr [bp - 6]
  029E53  5263: 50               push ax
  029E54  5264: 8a874802         mov al, byte ptr [bx + 0x248]
  029E58  5268: 98               cwde 
  029E59  5269: 50               push ax
  029E5A  526A: 50               push ax
  029E5B  526B: 6a02             push 2
  029E5D  526D: 8b46f0           mov ax, word ptr [bp - 0x10]
  029E60  5270: 055200           add ax, 0x52
  029E63  5273: 8b56f6           mov dx, word ptr [bp - 0xa]
  029E66  5276: 8bda             mov bx, dx
  029E68  5278: 9a0e021f18       lcall 0x181f, 0x20e
  029E6D  527D: 8946f2           mov word ptr [bp - 0xe], ax
  029E70  5280: ff76fe           push word ptr [bp - 2]
  029E73  5283: 9a880a1f18       lcall 0x181f, 0xa88
  029E78  5288: 83c402           add sp, 2
  029E7B  528B: 0bc0             or ax, ax
  029E7D  528D: 7513             jne 0x52a2
  029E7F  528F: 3946f2           cmp word ptr [bp - 0xe], ax
  029E82  5292: 7c25             jl 0x52b9
  029E84  5294: 8b1e4285         mov bx, word ptr [0x8542]
  029E88  5298: 8a471f           mov al, byte ptr [bx + 0x1f]
  029E8B  529B: 98               cwde 
  029E8C  529C: 0346f2           add ax, word ptr [bp - 0xe]
  029E8F  529F: eb15             jmp 0x52b6
  029E91  52A1: 90               nop 
  029E92  52A2: 837ef200         cmp word ptr [bp - 0xe], 0
  029E96  52A6: 7c11             jl 0x52b9
  029E98  52A8: ff76f2           push word ptr [bp - 0xe]
  029E9B  52AB: ff76f0           push word ptr [bp - 0x10]
  029E9E  52AE: 9af40c1f18       lcall 0x181f, 0xcf4
  029EA3  52B3: 83c404           add sp, 4
  029EA6  52B6: 8946f8           mov word ptr [bp - 8], ax
  029EA9  52B9: ff46f4           inc word ptr [bp - 0xc]
  029EAC  52BC: 837ef40f         cmp word ptr [bp - 0xc], 0xf
  029EB0  52C0: 7c03             jl 0x52c5
  029EB2  52C2: e9a300           jmp 0x5368
  029EB5  52C5: 837efe00         cmp word ptr [bp - 2], 0
  029EB9  52C9: 7c03             jl 0x52ce
  029EBB  52CB: e99a00           jmp 0x5368
  029EBE  52CE: 8b5ef4           mov bx, word ptr [bp - 0xc]
  029EC1  52D1: c1e302           shl bx, 2
  029EC4  52D4: 8b876602         mov ax, word ptr [bx + 0x266]
  029EC8  52D8: 8946fc           mov word ptr [bp - 4], ax
  029ECB  52DB: 8b8f6802         mov cx, word ptr [bx + 0x268]
  029ECF  52DF: 83c108           add cx, 8
  029ED2  52E2: 894efa           mov word ptr [bp - 6], cx
  029ED5  52E5: 8b5ef4           mov bx, word ptr [bp - 0xc]
  029ED8  52E8: 8a97628d         mov dl, byte ptr [bx - 0x729e]
  029EDC  52EC: 2af6             sub dh, dh
  029EDE  52EE: 8956ee           mov word ptr [bp - 0x12], dx
  029EE1  52F1: 8bf2             mov si, dx
  029EE3  52F3: 8bf8             mov di, ax
  029EE5  52F5: 8a843602         mov al, byte ptr [si + 0x236]
  029EE9  52F9: 98               cwde 
  029EEA  52FA: 50               push ax
  029EEB  52FB: 8a843002         mov al, byte ptr [si + 0x230]
  029EEF  52FF: 98               cwde 
  029EF0  5300: 50               push ax
  029EF1  5301: 51               push cx
  029EF2  5302: 57               push di
  029EF3  5303: 9aca031f18       lcall 0x181f, 0x3ca
  029EF8  5308: 83c408           add sp, 8
  029EFB  530B: 0bc0             or ax, ax
  029EFD  530D: 74aa             je 0x52b9
  029EFF  530F: 8b5ef4           mov bx, word ptr [bp - 0xc]
  029F02  5312: 8a87828e         mov al, byte ptr [bx - 0x717e]
  029F06  5316: 98               cwde 
  029F07  5317: 8946fe           mov word ptr [bp - 2], ax
  029F0A  531A: 833ef60700       cmp word ptr [0x7f6], 0
  029F0F  531F: 7403             je 0x5324
  029F11  5321: e9e4fe           jmp 0x5208
  029F14  5324: c6069b0b01       mov byte ptr [0xb9b], 1
  029F19  5329: 3a069a0b         cmp al, byte ptr [0xb9a]
  029F1D  532D: 7503             jne 0x5332
  029F1F  532F: e99601           jmp 0x54c8
  029F22  5332: a29a0b           mov byte ptr [0xb9a], al
  029F25  5335: 6a00             push 0
  029F27  5337: 0e               push cs
  029F28  5338: e8532a           call 0x7d8e
  029F2B  533B: 83c402           add sp, 2
  029F2E  533E: ff76ee           push word ptr [bp - 0x12]
  029F31  5341: ff76fa           push word ptr [bp - 6]
  029F34  5344: ff76fc           push word ptr [bp - 4]
  029F37  5347: ff76fe           push word ptr [bp - 2]
  029F3A  534A: 0e               push cs
  029F3B  534B: e8712b           call 0x7ebf
  029F3E  534E: 83c408           add sp, 8
  029F41  5351: 6a08             push 8
  029F43  5353: 68c700           push 0xc7
  029F46  5356: 6a78             push 0x78
  029F48  5358: 2bc0             sub ax, ax
  029F4A  535A: ba0800           mov dx, 8
  029F4D  535D: 2bdb             sub bx, bx
  029F4F  535F: 9ae2001f18       lcall 0x181f, 0xe2
  029F54  5364: 5e               pop si
  029F55  5365: 5f               pop di
  029F56  5366: c9               leave 
  029F57  5367: cb               retf 
  029F58  5368: 837efe00         cmp word ptr [bp - 2], 0
  029F5C  536C: 7d03             jge 0x5371
  029F5E  536E: e95701           jmp 0x54c8
  029F61  5371: 833e548d06       cmp word ptr [0x8d54], 6
  029F66  5376: 753e             jne 0x53b6
  029F68  5378: 833ef40700       cmp word ptr [0x7f4], 0
  029F6D  537D: 7503             jne 0x5382
  029F6F  537F: e94601           jmp 0x54c8
  029F72  5382: 837ef000         cmp word ptr [bp - 0x10], 0
  029F76  5386: 7d03             jge 0x538b
  029F78  5388: e93d01           jmp 0x54c8
  029F7B  538B: 837ef015         cmp word ptr [bp - 0x10], 0x15
  029F7F  538F: 7403             je 0x5394
  029F81  5391: e90901           jmp 0x549d
  029F84  5394: ff367c8d         push word ptr [0x8d7c]
  029F88  5398: 9a0e0c1f18       lcall 0x181f, 0xc0e
  029F8D  539D: 83c402           add sp, 2
  029F90  53A0: 3d1300           cmp ax, 0x13
  029F93  53A3: 7c03             jl 0x53a8
  029F95  53A5: e92001           jmp 0x54c8
  029F98  53A8: 6a01             push 1
  029F9A  53AA: 0e               push cs
  029F9B  53AB: e8e42a           call 0x7e92
  029F9E  53AE: 83c402           add sp, 2
  029FA1  53B1: 5e               pop si
  029FA2  53B2: 5f               pop di
  029FA3  53B3: c9               leave 
  029FA4  53B4: cb               retf 
  029FA5  53B5: 90               nop 
  029FA6  53B6: 833eee0700       cmp word ptr [0x7ee], 0
  029FAB  53BB: 7456             je 0x5413
  029FAD  53BD: 837ef200         cmp word ptr [bp - 0xe], 0
  029FB1  53C1: 7c50             jl 0x5413
  029FB3  53C3: 8b46f8           mov ax, word ptr [bp - 8]
  029FB6  53C6: 39067e8d         cmp word ptr [0x8d7e], ax
  029FBA  53CA: 741c             je 0x53e8
  029FBC  53CC: c7062e030100     mov word ptr [0x32e], 1
  029FC2  53D2: a37e8d           mov word ptr [0x8d7e], ax
  029FC5  53D5: 833eec0700       cmp word ptr [0x7ec], 0
  029FCA  53DA: 7506             jne 0x53e2
  029FCC  53DC: c706588d0000     mov word ptr [0x8d58], 0
  029FD2  53E2: 0e               push cs
  029FD3  53E3: e8a22a           call 0x7e88
  029FD6  53E6: eb2b             jmp 0x5413
  029FD8  53E8: 833e588d00       cmp word ptr [0x8d58], 0
  029FDD  53ED: 7424             je 0x5413
  029FDF  53EF: 833ee40700       cmp word ptr [0x7e4], 0
  029FE4  53F4: 751d             jne 0x5413
  029FE6  53F6: 9a06000c0c       lcall 0xc0c, 6
  029FEB  53FB: 3b16608d         cmp dx, word ptr [0x8d60]
  029FEF  53FF: 7c12             jl 0x5413
  029FF1  5401: 7f06             jg 0x5409
  029FF3  5403: 3b065e8d         cmp ax, word ptr [0x8d5e]
  029FF7  5407: 720a             jb 0x5413
  029FF9  5409: ff76f8           push word ptr [bp - 8]
  029FFC  540C: 0e               push cs
  029FFD  540D: e8a629           call 0x7db6
  02A000  5410: 83c402           add sp, 2
  02A003  5413: 833ef40700       cmp word ptr [0x7f4], 0
  02A008  5418: 7503             jne 0x541d
  02A00A  541A: e9ab00           jmp 0x54c8
  02A00D  541D: 837ef200         cmp word ptr [bp - 0xe], 0
  02A011  5421: 7c59             jl 0x547c
  02A013  5423: 8b46f8           mov ax, word ptr [bp - 8]
  02A016  5426: 39067c8d         cmp word ptr [0x8d7c], ax
  02A01A  542A: 740c             je 0x5438
  02A01C  542C: a37c8d           mov word ptr [0x8d7c], ax
  02A01F  542F: a37e8d           mov word ptr [0x8d7e], ax
  02A022  5432: 0e               push cs
  02A023  5433: e8522a           call 0x7e88
  02A026  5436: eb10             jmp 0x5448
  02A028  5438: 833ee40700       cmp word ptr [0x7e4], 0
  02A02D  543D: 7509             jne 0x5448
  02A02F  543F: 6a00             push 0
  02A031  5441: 0e               push cs
  02A032  5442: e84d2a           call 0x7e92
  02A035  5445: 83c402           add sp, 2
  02A038  5448: 833ee40700       cmp word ptr [0x7e4], 0
  02A03D  544D: 7479             je 0x54c8
  02A03F  544F: ff367c8d         push word ptr [0x8d7c]
  02A043  5453: 9a540c1f18       lcall 0x181f, 0xc54
  02A048  5458: 83c402           add sp, 2
  02A04B  545B: 8946f0           mov word ptr [bp - 0x10], ax
  02A04E  545E: 3d1c00           cmp ax, 0x1c
  02A051  5461: 7505             jne 0x5468
  02A053  5463: c746f01300       mov word ptr [bp - 0x10], 0x13
  02A058  5468: ff76f0           push word ptr [bp - 0x10]
  02A05B  546B: 9ade081f19       lcall 0x191f, 0x8de
  02A060  5470: 83c402           add sp, 2
  02A063  5473: 0e               push cs
  02A064  5474: e8c629           call 0x7e3d
  02A067  5477: 5e               pop si
  02A068  5478: 5f               pop di
  02A069  5479: c9               leave 
  02A06A  547A: cb               retf 
  02A06B  547B: 90               nop 
  02A06C  547C: 833ee40700       cmp word ptr [0x7e4], 0
  02A071  5481: 740b             je 0x548e
  02A073  5483: ff76fe           push word ptr [bp - 2]
  02A076  5486: 9a02091f19       lcall 0x191f, 0x902
  02A07B  548B: ebe3             jmp 0x5470
  02A07D  548D: 90               nop 
  02A07E  548E: 837ef000         cmp word ptr [bp - 0x10], 0
  02A082  5492: 7c20             jl 0x54b4
  02A084  5494: 837ef015         cmp word ptr [bp - 0x10], 0x15
  02A088  5498: 7503             jne 0x549d
  02A08A  549A: e90bff           jmp 0x53a8
  02A08D  549D: ff76f0           push word ptr [bp - 0x10]
  02A090  54A0: ff367c8d         push word ptr [0x8d7c]
  02A094  54A4: 0e               push cs
  02A095  54A5: e81329           call 0x7dbb
  02A098  54A8: 83c404           add sp, 4
  02A09B  54AB: 0e               push cs
  02A09C  54AC: e8d929           call 0x7e88
  02A09F  54AF: 5e               pop si
  02A0A0  54B0: 5f               pop di
  02A0A1  54B1: c9               leave 
  02A0A2  54B2: cb               retf 
  02A0A3  54B3: 90               nop 
  02A0A4  54B4: ff76fe           push word ptr [bp - 2]
  02A0A7  54B7: 9a880a1f18       lcall 0x181f, 0xa88
  02A0AC  54BC: 83c402           add sp, 2
  02A0AF  54BF: 3d1200           cmp ax, 0x12
  02A0B2  54C2: 7504             jne 0x54c8
  02A0B4  54C4: 0e               push cs
  02A0B5  54C5: e8d429           call 0x7e9c
  02A0B8  54C8: 5e               pop si
  02A0B9  54C9: 5f               pop di
  02A0BA  54CA: c9               leave 
  02A0BB  54CB: cb               retf 

; ---- func_02A0BC  size=607  insns=230  prologue=ENTER 0x0012,0  terminal=RETF ----
  02A0BC  54CC: c8120000         enter 0x12, 0
  02A0C0  54D0: 56               push si
  02A0C1  54D1: a1ea07           mov ax, word ptr [0x7ea]
  02A0C4  54D4: 2d0800           sub ax, 8
  02A0C7  54D7: 3d7700           cmp ax, 0x77
  02A0CA  54DA: 7e03             jle 0x54df
  02A0CC  54DC: b87700           mov ax, 0x77
  02A0CF  54DF: 8946f8           mov word ptr [bp - 8], ax
  02A0D2  54E2: a1e807           mov ax, word ptr [0x7e8]
  02A0D5  54E5: 2dc800           sub ax, 0xc8
  02A0D8  54E8: 3d7700           cmp ax, 0x77
  02A0DB  54EB: 7e03             jle 0x54f0
  02A0DD  54ED: b87700           mov ax, 0x77
  02A0E0  54F0: b91800           mov cx, 0x18
  02A0E3  54F3: 99               cdq 
  02A0E4  54F4: f7f9             idiv cx
  02A0E6  54F6: 8946f6           mov word ptr [bp - 0xa], ax
  02A0E9  54F9: 8b46f8           mov ax, word ptr [bp - 8]
  02A0EC  54FC: 99               cdq 
  02A0ED  54FD: f7f9             idiv cx
  02A0EF  54FF: 8946f2           mov word ptr [bp - 0xe], ax
  02A0F2  5502: 837ef600         cmp word ptr [bp - 0xa], 0
  02A0F6  5506: 7503             jne 0x550b
  02A0F8  5508: e91d02           jmp 0x5728
  02A0FB  550B: 0bc0             or ax, ax
  02A0FD  550D: 7503             jne 0x5512
  02A0FF  550F: e91602           jmp 0x5728
  02A102  5512: 837ef604         cmp word ptr [bp - 0xa], 4
  02A106  5516: 7503             jne 0x551b
  02A108  5518: e90d02           jmp 0x5728
  02A10B  551B: 3d0400           cmp ax, 4
  02A10E  551E: 7503             jne 0x5523
  02A110  5520: e90502           jmp 0x5728
  02A113  5523: 833e548d06       cmp word ptr [0x8d54], 6
  02A118  5528: 7403             je 0x552d
  02A11A  552A: e9d100           jmp 0x55fe
  02A11D  552D: 833ef40700       cmp word ptr [0x7f4], 0
  02A122  5532: 7503             jne 0x5537
  02A124  5534: e9f101           jmp 0x5728
  02A127  5537: 50               push ax
  02A128  5538: ff76f6           push word ptr [bp - 0xa]
  02A12B  553B: 9ae00c1f18       lcall 0x181f, 0xce0
  02A130  5540: 83c404           add sp, 4
  02A133  5543: 0ac0             or al, al
  02A135  5545: 7c03             jl 0x554a
  02A137  5547: e9de01           jmp 0x5728
  02A13A  554A: 8b76f6           mov si, word ptr [bp - 0xa]
  02A13D  554D: 8bc6             mov ax, si
  02A13F  554F: c1e602           shl si, 2
  02A142  5552: 03f0             add si, ax
  02A144  5554: 8b5ef2           mov bx, word ptr [bp - 0xe]
  02A147  5557: 80b8f08d00       cmp byte ptr [bx + si - 0x7210], 0
  02A14C  555C: 7403             je 0x5561
  02A14E  555E: e9c701           jmp 0x5728
  02A151  5561: a33003           mov word ptr [0x330], ax
  02A154  5564: 891e3203         mov word ptr [0x332], bx
  02A158  5568: 53               push bx
  02A159  5569: 50               push ax
  02A15A  556A: 0e               push cs
  02A15B  556B: e83928           call 0x7da7
  02A15E  556E: 83c404           add sp, 4
  02A161  5571: ff367c8d         push word ptr [0x8d7c]
  02A165  5575: 9a0e0c1f18       lcall 0x181f, 0xc0e
  02A16A  557A: 83c402           add sp, 2
  02A16D  557D: 3d0900           cmp ax, 9
  02A170  5580: 7d09             jge 0x558b
  02A172  5582: 3d0800           cmp ax, 8
  02A175  5585: 7404             je 0x558b
  02A177  5587: 0bc0             or ax, ax
  02A179  5589: 7535             jne 0x55c0
  02A17B  558B: 8b1e4285         mov bx, word ptr [0x8542]
  02A17F  558F: 8a4701           mov al, byte ptr [bx + 1]
  02A182  5592: 2ae4             sub ah, ah
  02A184  5594: 03063203         add ax, word ptr [0x332]
  02A188  5598: 48               dec ax
  02A189  5599: 48               dec ax
  02A18A  559A: 8946f2           mov word ptr [bp - 0xe], ax
  02A18D  559D: 50               push ax
  02A18E  559E: 8a07             mov al, byte ptr [bx]
  02A190  55A0: 2ae4             sub ah, ah
  02A192  55A2: 03063003         add ax, word ptr [0x330]
  02A196  55A6: 48               dec ax
  02A197  55A7: 48               dec ax
  02A198  55A8: 8946f6           mov word ptr [bp - 0xa], ax
  02A19B  55AB: 50               push ax
  02A19C  55AC: 9a68071f18       lcall 0x181f, 0x768
  02A1A1  55B1: 83c404           add sp, 4
  02A1A4  55B4: 0bc0             or ax, ax
  02A1A6  55B6: 7404             je 0x55bc
  02A1A8  55B8: 6a08             push 8
  02A1AA  55BA: eb05             jmp 0x55c1
  02A1AC  55BC: 6a00             push 0
  02A1AE  55BE: eb01             jmp 0x55c1
  02A1B0  55C0: 50               push ax
  02A1B1  55C1: ff367c8d         push word ptr [0x8d7c]
  02A1B5  55C5: 0e               push cs
  02A1B6  55C6: e8f227           call 0x7dbb
  02A1B9  55C9: 83c404           add sp, 4
  02A1BC  55CC: 3d0100           cmp ax, 1
  02A1BF  55CF: 1bc0             sbb ax, ax
  02A1C1  55D1: f7d8             neg ax
  02A1C3  55D3: 0bc0             or ax, ax
  02A1C5  55D5: 7420             je 0x55f7
  02A1C7  55D7: ff367c8d         push word ptr [0x8d7c]
  02A1CB  55DB: 9aa60a1f18       lcall 0x181f, 0xaa6
  02A1D0  55E0: 83c402           add sp, 2
  02A1D3  55E3: a07c8d           mov al, byte ptr [0x8d7c]
  02A1D6  55E6: 50               push ax
  02A1D7  55E7: ff363203         push word ptr [0x332]
  02A1DB  55EB: ff363003         push word ptr [0x330]
  02A1DF  55EF: 9a440d1f18       lcall 0x181f, 0xd44
  02A1E4  55F4: 83c406           add sp, 6
  02A1E7  55F7: 0e               push cs
  02A1E8  55F8: e88d28           call 0x7e88
  02A1EB  55FB: 5e               pop si
  02A1EC  55FC: c9               leave 
  02A1ED  55FD: cb               retf 
  02A1EE  55FE: 833ef60700       cmp word ptr [0x7f6], 0
  02A1F3  5603: 7543             jne 0x5648
  02A1F5  5605: c6069f0b01       mov byte ptr [0xb9f], 1
  02A1FA  560A: c1e003           shl ax, 3
  02A1FD  560D: 0346f6           add ax, word ptr [bp - 0xa]
  02A200  5610: 8946fe           mov word ptr [bp - 2], ax
  02A203  5613: 3a069e0b         cmp al, byte ptr [0xb9e]
  02A207  5617: 7503             jne 0x561c
  02A209  5619: e90c01           jmp 0x5728
  02A20C  561C: a29e0b           mov byte ptr [0xb9e], al
  02A20F  561F: 6a00             push 0
  02A211  5621: 0e               push cs
  02A212  5622: e88c27           call 0x7db1
  02A215  5625: 83c402           add sp, 2
  02A218  5628: ff76fe           push word ptr [bp - 2]
  02A21B  562B: 0e               push cs
  02A21C  562C: e8eb27           call 0x7e1a
  02A21F  562F: 83c402           add sp, 2
  02A222  5632: 6a08             push 8
  02A224  5634: 6a78             push 0x78
  02A226  5636: 6a78             push 0x78
  02A228  5638: b8c800           mov ax, 0xc8
  02A22B  563B: ba0800           mov dx, 8
  02A22E  563E: 8bd8             mov bx, ax
  02A230  5640: 9ae2001f18       lcall 0x181f, 0xe2
  02A235  5645: 5e               pop si
  02A236  5646: c9               leave 
  02A237  5647: cb               retf 
  02A238  5648: a13003           mov ax, word ptr [0x330]
  02A23B  564B: 3946f6           cmp word ptr [bp - 0xa], ax
  02A23E  564E: 750f             jne 0x565f
  02A240  5650: a13203           mov ax, word ptr [0x332]
  02A243  5653: 3946f2           cmp word ptr [bp - 0xe], ax
  02A246  5656: 7507             jne 0x565f
  02A248  5658: 833e2e0300       cmp word ptr [0x32e], 0
  02A24D  565D: 7423             je 0x5682
  02A24F  565F: c7062e030000     mov word ptr [0x32e], 0
  02A255  5665: 8b46f6           mov ax, word ptr [bp - 0xa]
  02A258  5668: a33003           mov word ptr [0x330], ax
  02A25B  566B: 8b46f2           mov ax, word ptr [bp - 0xe]
  02A25E  566E: a33203           mov word ptr [0x332], ax
  02A261  5671: 833eec0700       cmp word ptr [0x7ec], 0
  02A266  5676: 7506             jne 0x567e
  02A268  5678: c706588d0000     mov word ptr [0x8d58], 0
  02A26E  567E: 0e               push cs
  02A26F  567F: e80628           call 0x7e88
  02A272  5682: 833eee0700       cmp word ptr [0x7ee], 0
  02A277  5687: 743c             je 0x56c5
  02A279  5689: 833ee40700       cmp word ptr [0x7e4], 0
  02A27E  568E: 7535             jne 0x56c5
  02A280  5690: 833e588d00       cmp word ptr [0x8d58], 0
  02A285  5695: 742e             je 0x56c5
  02A287  5697: 9a06000c0c       lcall 0xc0c, 6
  02A28C  569C: 3b16608d         cmp dx, word ptr [0x8d60]
  02A290  56A0: 7c23             jl 0x56c5
  02A292  56A2: 7f06             jg 0x56aa
  02A294  56A4: 3b065e8d         cmp ax, word ptr [0x8d5e]
  02A298  56A8: 721b             jb 0x56c5
  02A29A  56AA: ff76f2           push word ptr [bp - 0xe]
  02A29D  56AD: ff76f6           push word ptr [bp - 0xa]
  02A2A0  56B0: 9ae00c1f18       lcall 0x181f, 0xce0
  02A2A5  56B5: 83c404           add sp, 4
  02A2A8  56B8: 0ac0             or al, al
  02A2AA  56BA: 7c09             jl 0x56c5
  02A2AC  56BC: 98               cwde 
  02A2AD  56BD: 50               push ax
  02A2AE  56BE: 0e               push cs
  02A2AF  56BF: e8f426           call 0x7db6
  02A2B2  56C2: 83c402           add sp, 2
  02A2B5  56C5: 833ef40700       cmp word ptr [0x7f4], 0
  02A2BA  56CA: 745c             je 0x5728
  02A2BC  56CC: 0e               push cs
  02A2BD  56CD: e88b27           call 0x7e5b
  02A2C0  56D0: 48               dec ax
  02A2C1  56D1: 7555             jne 0x5728
  02A2C3  56D3: 833ee40700       cmp word ptr [0x7e4], 0
  02A2C8  56D8: 7508             jne 0x56e2
  02A2CA  56DA: 0e               push cs
  02A2CB  56DB: e82827           call 0x7e06
  02A2CE  56DE: 5e               pop si
  02A2CF  56DF: c9               leave 
  02A2D0  56E0: cb               retf 
  02A2D1  56E1: 90               nop 
  02A2D2  56E2: 8b76f6           mov si, word ptr [bp - 0xa]
  02A2D5  56E5: 8bc6             mov ax, si
  02A2D7  56E7: c1e602           shl si, 2
  02A2DA  56EA: 03f0             add si, ax
  02A2DC  56EC: 8b5ef2           mov bx, word ptr [bp - 0xe]
  02A2DF  56EF: 80b8f08d10       cmp byte ptr [bx + si - 0x7210], 0x10
  02A2E4  56F4: 7432             je 0x5728
  02A2E6  56F6: 8b1e4285         mov bx, word ptr [0x8542]
  02A2EA  56FA: 8a4701           mov al, byte ptr [bx + 1]
  02A2ED  56FD: 2ae4             sub ah, ah
  02A2EF  56FF: 48               dec ax
  02A2F0  5700: 48               dec ax
  02A2F1  5701: 0146f2           add word ptr [bp - 0xe], ax
  02A2F4  5704: ff76f2           push word ptr [bp - 0xe]
  02A2F7  5707: 8a07             mov al, byte ptr [bx]
  02A2F9  5709: 2ae4             sub ah, ah
  02A2FB  570B: 48               dec ax
  02A2FC  570C: 48               dec ax
  02A2FD  570D: 0146f6           add word ptr [bp - 0xa], ax
  02A300  5710: ff76f6           push word ptr [bp - 0xa]
  02A303  5713: 9a8c071f18       lcall 0x181f, 0x78c
  02A308  5718: 83c404           add sp, 4
  02A30B  571B: 50               push ax
  02A30C  571C: 9a28041f19       lcall 0x191f, 0x428
  02A311  5721: 83c402           add sp, 2
  02A314  5724: 0e               push cs
  02A315  5725: e81527           call 0x7e3d
  02A318  5728: 5e               pop si
  02A319  5729: c9               leave 
  02A31A  572A: cb               retf 

; ---- func_02A31C  size=325  insns=122  prologue=ENTER 0x0018,0  terminal=RETF ----
  02A31C  572C: c8180000         enter 0x18, 0
  02A320  5730: b8ffff           mov ax, 0xffff
  02A323  5733: 8946f8           mov word ptr [bp - 8], ax
  02A326  5736: 8946f0           mov word ptr [bp - 0x10], ax
  02A329  5739: c746fe3903       mov word ptr [bp - 2], 0x339
  02A32E  573E: c746f43703       mov word ptr [bp - 0xc], 0x337
  02A333  5743: 8d46ea           lea ax, [bp - 0x16]
  02A336  5746: 50               push ax
  02A337  5747: 8d46ee           lea ax, [bp - 0x12]
  02A33A  574A: 50               push ax
  02A33B  574B: 8d46fc           lea ax, [bp - 4]
  02A33E  574E: 50               push ax
  02A33F  574F: b84400           mov ax, 0x44
  02A342  5752: 8946ec           mov word ptr [bp - 0x14], ax
  02A345  5755: 50               push ax
  02A346  5756: b80300           mov ax, 3
  02A349  5759: 8946fa           mov word ptr [bp - 6], ax
  02A34C  575C: 50               push ax
  02A34D  575D: 0e               push cs
  02A34E  575E: e88b27           call 0x7eec
  02A351  5761: 83c40a           add sp, 0xa
  02A354  5764: 6a2d             push 0x2d
  02A356  5766: 6a11             push 0x11
  02A358  5768: 688400           push 0x84
  02A35B  576B: 682f01           push 0x12f
  02A35E  576E: 9aca031f18       lcall 0x181f, 0x3ca
  02A363  5773: 83c408           add sp, 8
  02A366  5776: 0bc0             or ax, ax
  02A368  5778: 7448             je 0x57c2
  02A36A  577A: 2bc0             sub ax, ax
  02A36C  577C: 8946f8           mov word ptr [bp - 8], ax
  02A36F  577F: 8946e8           mov word ptr [bp - 0x18], ax
  02A372  5782: eb38             jmp 0x57bc
  02A374  5784: 8b46e8           mov ax, word ptr [bp - 0x18]
  02A377  5787: 3946fa           cmp word ptr [bp - 6], ax
  02A37A  578A: 7e36             jle 0x57c2
  02A37C  578C: 8b4eee           mov cx, word ptr [bp - 0x12]
  02A37F  578F: 41               inc cx
  02A380  5790: 41               inc cx
  02A381  5791: f7e9             imul cx
  02A383  5793: 058400           add ax, 0x84
  02A386  5796: 8946f2           mov word ptr [bp - 0xe], ax
  02A389  5799: ff76ee           push word ptr [bp - 0x12]
  02A38C  579C: ff76fc           push word ptr [bp - 4]
  02A38F  579F: 50               push ax
  02A390  57A0: b82f01           mov ax, 0x12f
  02A393  57A3: 8946f6           mov word ptr [bp - 0xa], ax
  02A396  57A6: 50               push ax
  02A397  57A7: 9aca031f18       lcall 0x181f, 0x3ca
  02A39C  57AC: 83c408           add sp, 8
  02A39F  57AF: 0bc0             or ax, ax
  02A3A1  57B1: 7406             je 0x57b9
  02A3A3  57B3: 8b46e8           mov ax, word ptr [bp - 0x18]
  02A3A6  57B6: 8946f0           mov word ptr [bp - 0x10], ax
  02A3A9  57B9: ff46e8           inc word ptr [bp - 0x18]
  02A3AC  57BC: 837ef000         cmp word ptr [bp - 0x10], 0
  02A3B0  57C0: 7cc2             jl 0x5784
  02A3B2  57C2: 833eec0700       cmp word ptr [0x7ec], 0
  02A3B7  57C7: 7507             jne 0x57d0
  02A3B9  57C9: 803e8aa800       cmp byte ptr [0xa88a], 0
  02A3BE  57CE: 7d16             jge 0x57e6
  02A3C0  57D0: 8a46f8           mov al, byte ptr [bp - 8]
  02A3C3  57D3: a28aa8           mov byte ptr [0xa88a], al
  02A3C6  57D6: 837efe00         cmp word ptr [bp - 2], 0
  02A3CA  57DA: 740a             je 0x57e6
  02A3CC  57DC: 8b5ef4           mov bx, word ptr [bp - 0xc]
  02A3CF  57DF: 8a07             mov al, byte ptr [bx]
  02A3D1  57E1: 8b5efe           mov bx, word ptr [bp - 2]
  02A3D4  57E4: 8807             mov byte ptr [bx], al
  02A3D6  57E6: 833ef60700       cmp word ptr [0x7f6], 0
  02A3DB  57EB: 7426             je 0x5813
  02A3DD  57ED: a08aa8           mov al, byte ptr [0xa88a]
  02A3E0  57F0: 98               cwde 
  02A3E1  57F1: 3b46f8           cmp ax, word ptr [bp - 8]
  02A3E4  57F4: 751d             jne 0x5813
  02A3E6  57F6: 837ef000         cmp word ptr [bp - 0x10], 0
  02A3EA  57FA: 7c17             jl 0x5813
  02A3EC  57FC: 8a46f0           mov al, byte ptr [bp - 0x10]
  02A3EF  57FF: 8b5efe           mov bx, word ptr [bp - 2]
  02A3F2  5802: 3807             cmp byte ptr [bx], al
  02A3F4  5804: 740d             je 0x5813
  02A3F6  5806: 8807             mov byte ptr [bx], al
  02A3F8  5808: 6a01             push 1
  02A3FA  580A: 6a01             push 1
  02A3FC  580C: 0e               push cs
  02A3FD  580D: e8e725           call 0x7df7
  02A400  5810: 83c404           add sp, 4
  02A403  5813: 833ef40700       cmp word ptr [0x7f4], 0
  02A408  5818: 7455             je 0x586f
  02A40A  581A: a08aa8           mov al, byte ptr [0xa88a]
  02A40D  581D: 98               cwde 
  02A40E  581E: 3b46f8           cmp ax, word ptr [bp - 8]
  02A411  5821: 752d             jne 0x5850
  02A413  5823: 837ef000         cmp word ptr [bp - 0x10], 0
  02A417  5827: 7c27             jl 0x5850
  02A419  5829: 8b5efe           mov bx, word ptr [bp - 2]
  02A41C  582C: 8a07             mov al, byte ptr [bx]
  02A41E  582E: 8b5ef4           mov bx, word ptr [bp - 0xc]
  02A421  5831: 3807             cmp byte ptr [bx], al
  02A423  5833: 7413             je 0x5848
  02A425  5835: 837ef800         cmp word ptr [bp - 8], 0
  02A429  5839: 7505             jne 0x5840
  02A42B  583B: 8a07             mov al, byte ptr [bx]
  02A42D  583D: a23803           mov byte ptr [0x338], al
  02A430  5840: 8b5efe           mov bx, word ptr [bp - 2]
  02A433  5843: 8a07             mov al, byte ptr [bx]
  02A435  5845: eb04             jmp 0x584b
  02A437  5847: 90               nop 
  02A438  5848: a03803           mov al, byte ptr [0x338]
  02A43B  584B: 8b5ef4           mov bx, word ptr [bp - 0xc]
  02A43E  584E: 8807             mov byte ptr [bx], al
  02A440  5850: 833e460300       cmp word ptr [0x346], 0
  02A445  5855: 7418             je 0x586f
  02A447  5857: 833e2e0303       cmp word ptr [0x32e], 3
  02A44C  585C: 750d             jne 0x586b
  02A44E  585E: 803e370301       cmp byte ptr [0x337], 1
  02A453  5863: 7406             je 0x586b
  02A455  5865: c7062e030100     mov word ptr [0x32e], 1
  02A45B  586B: 0e               push cs
  02A45C  586C: e83c26           call 0x7eab
  02A45F  586F: c9               leave 
  02A460  5870: cb               retf 

; ---- func_02A462  size=579  insns=206  prologue=ENTER 0x0008,0  terminal=RETF ----
  02A462  5872: c8080000         enter 8, 0
  02A466  5876: 56               push si
  02A467  5877: c746fa0100       mov word ptr [bp - 6], 1
  02A46C  587C: 8b7608           mov si, word ptr [bp + 8]
  02A46F  587F: d1e6             shl si, 1
  02A471  5881: 8b1e4285         mov bx, word ptr [0x8542]
  02A475  5885: 83b89a0001       cmp word ptr [bx + si + 0x9a], 1
  02A47A  588A: 7d4a             jge 0x58d6
  02A47C  588C: 6a01             push 1
  02A47E  588E: 9a56001f18       lcall 0x181f, 0x56
  02A483  5893: 83c402           add sp, 2
  02A486  5896: 6a06             push 6
  02A488  5898: 0e               push cs
  02A489  5899: e82d26           call 0x7ec9
  02A48C  589C: 83c402           add sp, 2
  02A48F  589F: ffb4c097         push word ptr [si - 0x6840]
  02A493  58A3: 9a74001f18       lcall 0x181f, 0x74
  02A498  58A8: 83c402           add sp, 2
  02A49B  58AB: 6a07             push 7
  02A49D  58AD: 0e               push cs
  02A49E  58AE: e81826           call 0x7ec9
  02A4A1  58B1: 83c402           add sp, 2
  02A4A4  58B4: 833eee0701       cmp word ptr [0x7ee], 1
  02A4A9  58B9: 1bc0             sbb ax, ax
  02A4AB  58BB: 257800           and ax, 0x78
  02A4AE  58BE: 99               cdq 
  02A4AF  58BF: 52               push dx
  02A4B0  58C0: 50               push ax
  02A4B1  58C1: 6a03             push 3
  02A4B3  58C3: 0e               push cs
  02A4B4  58C4: e8f325           call 0x7eba
  02A4B7  58C7: 83c406           add sp, 6
  02A4BA  58CA: c706548d1400     mov word ptr [0x8d54], 0x14
  02A4C0  58D0: 8b46fa           mov ax, word ptr [bp - 6]
  02A4C3  58D3: 5e               pop si
  02A4C4  58D4: c9               leave 
  02A4C5  58D5: cb               retf 
  02A4C6  58D6: 833e900800       cmp word ptr [0x890], 0
  02A4CB  58DB: 743f             je 0x591c
  02A4CD  58DD: 833e3c0300       cmp word ptr [0x33c], 0
  02A4D2  58E2: 7538             jne 0x591c
  02A4D4  58E4: 6a01             push 1
  02A4D6  58E6: 9a56001f18       lcall 0x181f, 0x56
  02A4DB  58EB: 83c402           add sp, 2
  02A4DE  58EE: 6a05             push 5
  02A4E0  58F0: 0e               push cs
  02A4E1  58F1: e8d525           call 0x7ec9
  02A4E4  58F4: 83c402           add sp, 2
  02A4E7  58F7: 8b5e08           mov bx, word ptr [bp + 8]
  02A4EA  58FA: d1e3             shl bx, 1
  02A4EC  58FC: ffb7c097         push word ptr [bx - 0x6840]
  02A4F0  5900: 9a74001f18       lcall 0x181f, 0x74
  02A4F5  5905: 83c402           add sp, 2
  02A4F8  5908: 9a88001f18       lcall 0x181f, 0x88
  02A4FD  590D: 1e               push ds
  02A4FE  590E: 68c00c           push 0xcc0
  02A501  5911: 9a6a001f18       lcall 0x181f, 0x6a
  02A506  5916: 83c404           add sp, 4
  02A509  5919: eb99             jmp 0x58b4
  02A50B  591B: 90               nop 
  02A50C  591C: 837e0a00         cmp word ptr [bp + 0xa], 0
  02A510  5920: 7503             jne 0x5925
  02A512  5922: e98501           jmp 0x5aaa
  02A515  5925: 8d46fe           lea ax, [bp - 2]
  02A518  5928: 50               push ax
  02A519  5929: ff7608           push word ptr [bp + 8]
  02A51C  592C: ff7606           push word ptr [bp + 6]
  02A51F  592F: 9a960b1f18       lcall 0x181f, 0xb96
  02A524  5934: 83c406           add sp, 6
  02A527  5937: 0bc0             or ax, ax
  02A529  5939: 7549             jne 0x5984
  02A52B  593B: 6a01             push 1
  02A52D  593D: 9a56001f18       lcall 0x181f, 0x56
  02A532  5942: 83c402           add sp, 2
  02A535  5945: 6a04             push 4
  02A537  5947: 0e               push cs
  02A538  5948: e87e25           call 0x7ec9
  02A53B  594B: 83c402           add sp, 2
  02A53E  594E: 8b5e08           mov bx, word ptr [bp + 8]
  02A541  5951: d1e3             shl bx, 1
  02A543  5953: ffb7c097         push word ptr [bx - 0x6840]
  02A547  5957: 9a74001f18       lcall 0x181f, 0x74
  02A54C  595C: 83c402           add sp, 2
  02A54F  595F: 9a88001f18       lcall 0x181f, 0x88
  02A554  5964: 1e               push ds
  02A555  5965: 68c20c           push 0xcc2
  02A558  5968: 9a6a001f18       lcall 0x181f, 0x6a
  02A55D  596D: 83c404           add sp, 4
  02A560  5970: 6a00             push 0
  02A562  5972: 6a78             push 0x78
  02A564  5974: 6a03             push 3
  02A566  5976: 0e               push cs
  02A567  5977: e84025           call 0x7eba
  02A56A  597A: 83c406           add sp, 6
  02A56D  597D: 8b46fa           mov ax, word ptr [bp - 6]
  02A570  5980: 5e               pop si
  02A571  5981: c9               leave 
  02A572  5982: cb               retf 
  02A573  5983: 90               nop 
  02A574  5984: 8b46fe           mov ax, word ptr [bp - 2]
  02A577  5987: 3d6400           cmp ax, 0x64
  02A57A  598A: 7e03             jle 0x598f
  02A57C  598C: b86400           mov ax, 0x64
  02A57F  598F: 8946fe           mov word ptr [bp - 2], ax
  02A582  5992: 8b7608           mov si, word ptr [bp + 8]
  02A585  5995: d1e6             shl si, 1
  02A587  5997: 8b1e4285         mov bx, word ptr [0x8542]
  02A58B  599B: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  02A58F  599F: 3b46fe           cmp ax, word ptr [bp - 2]
  02A592  59A2: 7e03             jle 0x59a7
  02A594  59A4: 8b46fe           mov ax, word ptr [bp - 2]
  02A597  59A7: 8946fe           mov word ptr [bp - 2], ax
  02A59A  59AA: 837e0c00         cmp word ptr [bp + 0xc], 0
  02A59E  59AE: 747e             je 0x5a2e
  02A5A0  59B0: ffb4c097         push word ptr [si - 0x6840]
  02A5A4  59B4: 6a00             push 0
  02A5A6  59B6: 9a38041f18       lcall 0x181f, 0x438
  02A5AB  59BB: 83c404           add sp, 4
  02A5AE  59BE: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  02A5B2  59C2: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  02A5B6  59C6: 2aff             sub bh, bh
  02A5B8  59C8: 8bc3             mov ax, bx
  02A5BA  59CA: d1e3             shl bx, 1
  02A5BC  59CC: 03d8             add bx, ax
  02A5BE  59CE: d1e3             shl bx, 1
  02A5C0  59D0: 03d8             add bx, ax
  02A5C2  59D2: d1e3             shl bx, 1
  02A5C4  59D4: ffb73052         push word ptr [bx + 0x5230]
  02A5C8  59D8: 6a01             push 1
  02A5CA  59DA: 9a38041f18       lcall 0x181f, 0x438
  02A5CF  59DF: 83c404           add sp, 4
  02A5D2  59E2: 8b46fe           mov ax, word ptr [bp - 2]
  02A5D5  59E5: 99               cdq 
  02A5D6  59E6: 52               push dx
  02A5D7  59E7: 50               push ax
  02A5D8  59E8: 6a00             push 0
  02A5DA  59EA: 9aae091f18       lcall 0x181f, 0x9ae
  02A5DF  59EF: 83c406           add sp, 6
  02A5E2  59F2: 8d1e7c08         lea bx, [0x87c]
  02A5E6  59F6: 8d06c40c         lea ax, [0xcc4]
  02A5EA  59FA: 8b56fe           mov dx, word ptr [bp - 2]
  02A5ED  59FD: 9a36041f19       lcall 0x191f, 0x436
  02A5F2  5A02: 0bc0             or ax, ax
  02A5F4  5A04: 7403             je 0x5a09
  02A5F6  5A06: e9a600           jmp 0x5aaf
  02A5F9  5A09: ff76fe           push word ptr [bp - 2]
  02A5FC  5A0C: 50               push ax
  02A5FD  5A0D: ff36c89c         push word ptr [0x9cc8]
  02A601  5A11: 9a5c031f18       lcall 0x181f, 0x35c
  02A606  5A16: 83c406           add sp, 6
  02A609  5A19: 8946f8           mov word ptr [bp - 8], ax
  02A60C  5A1C: 3b46fe           cmp ax, word ptr [bp - 2]
  02A60F  5A1F: 7e03             jle 0x5a24
  02A611  5A21: 8b46fe           mov ax, word ptr [bp - 2]
  02A614  5A24: 8946fe           mov word ptr [bp - 2], ax
  02A617  5A27: 0bc0             or ax, ax
  02A619  5A29: 7f03             jg 0x5a2e
  02A61B  5A2B: e98100           jmp 0x5aaf
  02A61E  5A2E: 50               push ax
  02A61F  5A2F: ff7608           push word ptr [bp + 8]
  02A622  5A32: ff7606           push word ptr [bp + 6]
  02A625  5A35: 9ad80a1f18       lcall 0x181f, 0xad8
  02A62A  5A3A: 83c406           add sp, 6
  02A62D  5A3D: 8946fc           mov word ptr [bp - 4], ax
  02A630  5A40: 6a01             push 1
  02A632  5A42: 9a56001f18       lcall 0x181f, 0x56
  02A637  5A47: 83c402           add sp, 2
  02A63A  5A4A: ff36c48d         push word ptr [0x8dc4]
  02A63E  5A4E: 9a7e001f18       lcall 0x181f, 0x7e
  02A643  5A53: 83c402           add sp, 2
  02A646  5A56: 8b5e08           mov bx, word ptr [bp + 8]
  02A649  5A59: d1e3             shl bx, 1
  02A64B  5A5B: ffb7c097         push word ptr [bx - 0x6840]
  02A64F  5A5F: 9a74001f18       lcall 0x181f, 0x74
  02A654  5A64: 83c402           add sp, 2
  02A657  5A67: 6a02             push 2
  02A659  5A69: 0e               push cs
  02A65A  5A6A: e85c24           call 0x7ec9
  02A65D  5A6D: 83c402           add sp, 2
  02A660  5A70: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  02A664  5A74: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  02A668  5A78: 2aff             sub bh, bh
  02A66A  5A7A: 8bc3             mov ax, bx
  02A66C  5A7C: d1e3             shl bx, 1
  02A66E  5A7E: 03d8             add bx, ax
  02A670  5A80: d1e3             shl bx, 1
  02A672  5A82: 03d8             add bx, ax
  02A674  5A84: d1e3             shl bx, 1
  02A676  5A86: ffb73052         push word ptr [bx + 0x5230]
  02A67A  5A8A: 9a74001f18       lcall 0x181f, 0x74
  02A67F  5A8F: 83c402           add sp, 2
  02A682  5A92: 6a00             push 0
  02A684  5A94: 6a78             push 0x78
  02A686  5A96: 6a01             push 1
  02A688  5A98: 0e               push cs
  02A689  5A99: e81e24           call 0x7eba
  02A68C  5A9C: 83c406           add sp, 6
  02A68F  5A9F: 833e900800       cmp word ptr [0x890], 0
  02A694  5AA4: 7404             je 0x5aaa
  02A696  5AA6: 0e               push cs
  02A697  5AA7: e80124           call 0x7eab
  02A69A  5AAA: c746fa0000       mov word ptr [bp - 6], 0
  02A69F  5AAF: 8b46fa           mov ax, word ptr [bp - 6]
  02A6A2  5AB2: 5e               pop si
  02A6A3  5AB3: c9               leave 
  02A6A4  5AB4: cb               retf 

; ---- func_02A6A6  size=582  insns=206  prologue=ENTER 0x000E,0  terminal=RETF ----
  02A6A6  5AB6: c80e0000         enter 0xe, 0
  02A6AA  5ABA: 56               push si
  02A6AB  5ABB: c746fa0100       mov word ptr [bp - 6], 1
  02A6B0  5AC0: c746f60000       mov word ptr [bp - 0xa], 0
  02A6B5  5AC5: ff7608           push word ptr [bp + 8]
  02A6B8  5AC8: ff7606           push word ptr [bp + 6]
  02A6BB  5ACB: 9a2c0c1f18       lcall 0x181f, 0xc2c
  02A6C0  5AD0: 83c404           add sp, 4
  02A6C3  5AD3: 8946f4           mov word ptr [bp - 0xc], ax
  02A6C6  5AD6: 0bc0             or ax, ax
  02A6C8  5AD8: 7d4a             jge 0x5b24
  02A6CA  5ADA: 833e900800       cmp word ptr [0x890], 0
  02A6CF  5ADF: 7503             jne 0x5ae4
  02A6D1  5AE1: e91202           jmp 0x5cf6
  02A6D4  5AE4: 6a01             push 1
  02A6D6  5AE6: 9a56001f18       lcall 0x181f, 0x56
  02A6DB  5AEB: 83c402           add sp, 2
  02A6DE  5AEE: 6a09             push 9
  02A6E0  5AF0: 0e               push cs
  02A6E1  5AF1: e8d523           call 0x7ec9
  02A6E4  5AF4: 83c402           add sp, 2
  02A6E7  5AF7: 8b5e08           mov bx, word ptr [bp + 8]
  02A6EA  5AFA: d1e3             shl bx, 1
  02A6EC  5AFC: ffb7c097         push word ptr [bx - 0x6840]
  02A6F0  5B00: 9a74001f18       lcall 0x181f, 0x74
  02A6F5  5B05: 83c402           add sp, 2
  02A6F8  5B08: 6a0a             push 0xa
  02A6FA  5B0A: 0e               push cs
  02A6FB  5B0B: e8bb23           call 0x7ec9
  02A6FE  5B0E: 83c402           add sp, 2
  02A701  5B11: 6a00             push 0
  02A703  5B13: 6a78             push 0x78
  02A705  5B15: 6a03             push 3
  02A707  5B17: 0e               push cs
  02A708  5B18: e89f23           call 0x7eba
  02A70B  5B1B: 83c406           add sp, 6
  02A70E  5B1E: 8b46fa           mov ax, word ptr [bp - 6]
  02A711  5B21: 5e               pop si
  02A712  5B22: c9               leave 
  02A713  5B23: cb               retf 
  02A714  5B24: 837e0a00         cmp word ptr [bp + 0xa], 0
  02A718  5B28: 7503             jne 0x5b2d
  02A71A  5B2A: e9a500           jmp 0x5bd2
  02A71D  5B2D: 8b5e08           mov bx, word ptr [bp + 8]
  02A720  5B30: d1e3             shl bx, 1
  02A722  5B32: ffb7c097         push word ptr [bx - 0x6840]
  02A726  5B36: 6a00             push 0
  02A728  5B38: 9a38041f18       lcall 0x181f, 0x438
  02A72D  5B3D: 83c404           add sp, 4
  02A730  5B40: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  02A734  5B44: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  02A738  5B48: 2aff             sub bh, bh
  02A73A  5B4A: 8bc3             mov ax, bx
  02A73C  5B4C: d1e3             shl bx, 1
  02A73E  5B4E: 03d8             add bx, ax
  02A740  5B50: d1e3             shl bx, 1
  02A742  5B52: 03d8             add bx, ax
  02A744  5B54: d1e3             shl bx, 1
  02A746  5B56: ffb73052         push word ptr [bx + 0x5230]
  02A74A  5B5A: 6a01             push 1
  02A74C  5B5C: 9a38041f18       lcall 0x181f, 0x438
  02A751  5B61: 83c404           add sp, 4
  02A754  5B64: a14285           mov ax, word ptr [0x8542]
  02A757  5B67: 40               inc ax
  02A758  5B68: 40               inc ax
  02A759  5B69: 1e               push ds
  02A75A  5B6A: 50               push ax
  02A75B  5B6B: 6a02             push 2
  02A75D  5B6D: 9a16041f18       lcall 0x181f, 0x416
  02A762  5B72: 83c406           add sp, 6
  02A765  5B75: a1c48d           mov ax, word ptr [0x8dc4]
  02A768  5B78: 99               cdq 
  02A769  5B79: 52               push dx
  02A76A  5B7A: 50               push ax
  02A76B  5B7B: 6a00             push 0
  02A76D  5B7D: 9aae091f18       lcall 0x181f, 0x9ae
  02A772  5B82: 83c406           add sp, 6
  02A775  5B85: 8d1e7c08         lea bx, [0x87c]
  02A779  5B89: 8d06cd0c         lea ax, [0xccd]
  02A77D  5B8D: 8b16c48d         mov dx, word ptr [0x8dc4]
  02A781  5B91: 9a36041f19       lcall 0x191f, 0x436
  02A786  5B96: 0bc0             or ax, ax
  02A788  5B98: 7403             je 0x5b9d
  02A78A  5B9A: e95901           jmp 0x5cf6
  02A78D  5B9D: ff36c48d         push word ptr [0x8dc4]
  02A791  5BA1: 50               push ax
  02A792  5BA2: ff36c89c         push word ptr [0x9cc8]
  02A796  5BA6: 9a5c031f18       lcall 0x181f, 0x35c
  02A79B  5BAB: 83c406           add sp, 6
  02A79E  5BAE: 8946f2           mov word ptr [bp - 0xe], ax
  02A7A1  5BB1: a1c48d           mov ax, word ptr [0x8dc4]
  02A7A4  5BB4: 2b46f2           sub ax, word ptr [bp - 0xe]
  02A7A7  5BB7: 8946f6           mov word ptr [bp - 0xa], ax
  02A7AA  5BBA: 8b46f2           mov ax, word ptr [bp - 0xe]
  02A7AD  5BBD: 3b06c48d         cmp ax, word ptr [0x8dc4]
  02A7B1  5BC1: 7e03             jle 0x5bc6
  02A7B3  5BC3: a1c48d           mov ax, word ptr [0x8dc4]
  02A7B6  5BC6: a3c48d           mov word ptr [0x8dc4], ax
  02A7B9  5BC9: 837ef200         cmp word ptr [bp - 0xe], 0
  02A7BD  5BCD: 7f03             jg 0x5bd2
  02A7BF  5BCF: e92401           jmp 0x5cf6
  02A7C2  5BD2: 9a3a0d1f18       lcall 0x181f, 0xd3a
  02A7C7  5BD7: 8946fe           mov word ptr [bp - 2], ax
  02A7CA  5BDA: 8b7608           mov si, word ptr [bp + 8]
  02A7CD  5BDD: d1e6             shl si, 1
  02A7CF  5BDF: 8b1e4285         mov bx, word ptr [0x8542]
  02A7D3  5BE3: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  02A7D7  5BE7: 0306c48d         add ax, word ptr [0x8dc4]
  02A7DB  5BEB: 3b46fe           cmp ax, word ptr [bp - 2]
  02A7DE  5BEE: 7e74             jle 0x5c64
  02A7E0  5BF0: 837e0800         cmp word ptr [bp + 8], 0
  02A7E4  5BF4: 746e             je 0x5c64
  02A7E6  5BF6: 833e900800       cmp word ptr [0x890], 0
  02A7EB  5BFB: 7467             je 0x5c64
  02A7ED  5BFD: 8d4702           lea ax, [bx + 2]
  02A7F0  5C00: 1e               push ds
  02A7F1  5C01: 50               push ax
  02A7F2  5C02: 6a00             push 0
  02A7F4  5C04: 9a16041f18       lcall 0x181f, 0x416
  02A7F9  5C09: 83c406           add sp, 6
  02A7FC  5C0C: ffb4c097         push word ptr [si - 0x6840]
  02A800  5C10: 6a01             push 1
  02A802  5C12: 9a38041f18       lcall 0x181f, 0x438
  02A807  5C17: 83c404           add sp, 4
  02A80A  5C1A: 8b1e4285         mov bx, word ptr [0x8542]
  02A80E  5C1E: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  02A812  5C22: 99               cdq 
  02A813  5C23: 52               push dx
  02A814  5C24: 50               push ax
  02A815  5C25: 6a00             push 0
  02A817  5C27: 9aae091f18       lcall 0x181f, 0x9ae
  02A81C  5C2C: 83c406           add sp, 6
  02A81F  5C2F: 8b46fe           mov ax, word ptr [bp - 2]
  02A822  5C32: 99               cdq 
  02A823  5C33: 52               push dx
  02A824  5C34: 50               push ax
  02A825  5C35: 6a01             push 1
  02A827  5C37: 9aae091f18       lcall 0x181f, 0x9ae
  02A82C  5C3C: 83c406           add sp, 6
  02A82F  5C3F: a1c48d           mov ax, word ptr [0x8dc4]
  02A832  5C42: 99               cdq 
  02A833  5C43: 52               push dx
  02A834  5C44: 50               push ax
  02A835  5C45: 6a02             push 2
  02A837  5C47: 9aae091f18       lcall 0x181f, 0x9ae
  02A83C  5C4C: 83c406           add sp, 6
  02A83F  5C4F: 6a05             push 5
  02A841  5C51: 68d60c           push 0xcd6
  02A844  5C54: 9a52061f18       lcall 0x181f, 0x652
  02A849  5C59: 83c404           add sp, 4
  02A84C  5C5C: 3d0200           cmp ax, 2
  02A84F  5C5F: 7403             je 0x5c64
  02A851  5C61: e99200           jmp 0x5cf6
  02A854  5C64: a1c48d           mov ax, word ptr [0x8dc4]
  02A857  5C67: 8946f8           mov word ptr [bp - 8], ax
  02A85A  5C6A: ff76f4           push word ptr [bp - 0xc]
  02A85D  5C6D: ff7606           push word ptr [bp + 6]
  02A860  5C70: 9aec0a1f18       lcall 0x181f, 0xaec
  02A865  5C75: 83c404           add sp, 4
  02A868  5C78: 8b46f8           mov ax, word ptr [bp - 8]
  02A86B  5C7B: 8b7608           mov si, word ptr [bp + 8]
  02A86E  5C7E: d1e6             shl si, 1
  02A870  5C80: 8b1e4285         mov bx, word ptr [0x8542]
  02A874  5C84: 01809a00         add word ptr [bx + si + 0x9a], ax
  02A878  5C88: ff76f6           push word ptr [bp - 0xa]
  02A87B  5C8B: ff7608           push word ptr [bp + 8]
  02A87E  5C8E: ff7606           push word ptr [bp + 6]
  02A881  5C91: 9a580d1f18       lcall 0x181f, 0xd58
  02A886  5C96: 83c406           add sp, 6
  02A889  5C99: 8b46f8           mov ax, word ptr [bp - 8]
  02A88C  5C9C: a3c48d           mov word ptr [0x8dc4], ax
  02A88F  5C9F: 6a01             push 1
  02A891  5CA1: 9a56001f18       lcall 0x181f, 0x56
  02A896  5CA6: 83c402           add sp, 2
  02A899  5CA9: ff36c48d         push word ptr [0x8dc4]
  02A89D  5CAD: 9a7e001f18       lcall 0x181f, 0x7e
  02A8A2  5CB2: 83c402           add sp, 2
  02A8A5  5CB5: ffb4c097         push word ptr [si - 0x6840]
  02A8A9  5CB9: 9a74001f18       lcall 0x181f, 0x74
  02A8AE  5CBE: 83c402           add sp, 2
  02A8B1  5CC1: 6a02             push 2
  02A8B3  5CC3: 0e               push cs
  02A8B4  5CC4: e80222           call 0x7ec9
  02A8B7  5CC7: 83c402           add sp, 2
  02A8BA  5CCA: a14285           mov ax, word ptr [0x8542]
  02A8BD  5CCD: 40               inc ax
  02A8BE  5CCE: 40               inc ax
  02A8BF  5CCF: 1e               push ds
  02A8C0  5CD0: 50               push ax
  02A8C1  5CD1: 9a6a001f18       lcall 0x181f, 0x6a
  02A8C6  5CD6: 83c404           add sp, 4
  02A8C9  5CD9: 6a00             push 0
  02A8CB  5CDB: 6a78             push 0x78
  02A8CD  5CDD: 6a01             push 1
  02A8CF  5CDF: 0e               push cs
  02A8D0  5CE0: e8d721           call 0x7eba
  02A8D3  5CE3: 83c406           add sp, 6
  02A8D6  5CE6: 833e900800       cmp word ptr [0x890], 0
  02A8DB  5CEB: 7404             je 0x5cf1
  02A8DD  5CED: 0e               push cs
  02A8DE  5CEE: e8ba21           call 0x7eab
  02A8E1  5CF1: c746fa0000       mov word ptr [bp - 6], 0
  02A8E6  5CF6: 8b46fa           mov ax, word ptr [bp - 6]
  02A8E9  5CF9: 5e               pop si
  02A8EA  5CFA: c9               leave 
  02A8EB  5CFB: cb               retf 

; ---- func_02A8EC  size=512  insns=180  prologue=ENTER 0x0008,0  terminal=RETF ----
  02A8EC  5CFC: c8080000         enter 8, 0
  02A8F0  5D00: c746fc0100       mov word ptr [bp - 4], 1
  02A8F5  5D05: 8d46fe           lea ax, [bp - 2]
  02A8F8  5D08: 50               push ax
  02A8F9  5D09: ff760a           push word ptr [bp + 0xa]
  02A8FC  5D0C: ff7606           push word ptr [bp + 6]
  02A8FF  5D0F: 9ae60b1f18       lcall 0x181f, 0xbe6
  02A904  5D14: 83c404           add sp, 4
  02A907  5D17: 8946f8           mov word ptr [bp - 8], ax
  02A90A  5D1A: 50               push ax
  02A90B  5D1B: ff7608           push word ptr [bp + 8]
  02A90E  5D1E: 9a960b1f18       lcall 0x181f, 0xb96
  02A913  5D23: 83c406           add sp, 6
  02A916  5D26: 0bc0             or ax, ax
  02A918  5D28: 7512             jne 0x5d3c
  02A91A  5D2A: 50               push ax
  02A91B  5D2B: 6a78             push 0x78
  02A91D  5D2D: 6a04             push 4
  02A91F  5D2F: 0e               push cs
  02A920  5D30: e8b421           call 0x7ee7
  02A923  5D33: 83c406           add sp, 6
  02A926  5D36: 8b46fc           mov ax, word ptr [bp - 4]
  02A929  5D39: c9               leave 
  02A92A  5D3A: cb               retf 
  02A92B  5D3B: 90               nop 
  02A92C  5D3C: 8b46fe           mov ax, word ptr [bp - 2]
  02A92F  5D3F: 3d6400           cmp ax, 0x64
  02A932  5D42: 7e03             jle 0x5d47
  02A934  5D44: b86400           mov ax, 0x64
  02A937  5D47: 8946fe           mov word ptr [bp - 2], ax
  02A93A  5D4A: ff760a           push word ptr [bp + 0xa]
  02A93D  5D4D: ff7606           push word ptr [bp + 6]
  02A940  5D50: 9a680c1f18       lcall 0x181f, 0xc68
  02A945  5D55: 83c404           add sp, 4
  02A948  5D58: 3b46fe           cmp ax, word ptr [bp - 2]
  02A94B  5D5B: 7f11             jg 0x5d6e
  02A94D  5D5D: ff760a           push word ptr [bp + 0xa]
  02A950  5D60: ff7606           push word ptr [bp + 6]
  02A953  5D63: 9a680c1f18       lcall 0x181f, 0xc68
  02A958  5D68: 83c404           add sp, 4
  02A95B  5D6B: 8946fe           mov word ptr [bp - 2], ax
  02A95E  5D6E: 837e0c00         cmp word ptr [bp + 0xc], 0
  02A962  5D72: 7503             jne 0x5d77
  02A964  5D74: e9ba00           jmp 0x5e31
  02A967  5D77: ff760a           push word ptr [bp + 0xa]
  02A96A  5D7A: ff7606           push word ptr [bp + 6]
  02A96D  5D7D: 9ae60b1f18       lcall 0x181f, 0xbe6
  02A972  5D82: 83c404           add sp, 4
  02A975  5D85: 8bd8             mov bx, ax
  02A977  5D87: 895ef8           mov word ptr [bp - 8], bx
  02A97A  5D8A: d1e3             shl bx, 1
  02A97C  5D8C: ffb7c097         push word ptr [bx - 0x6840]
  02A980  5D90: 6a00             push 0
  02A982  5D92: 9a38041f18       lcall 0x181f, 0x438
  02A987  5D97: 83c404           add sp, 4
  02A98A  5D9A: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  02A98E  5D9E: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  02A992  5DA2: 2aff             sub bh, bh
  02A994  5DA4: 8bc3             mov ax, bx
  02A996  5DA6: d1e3             shl bx, 1
  02A998  5DA8: 03d8             add bx, ax
  02A99A  5DAA: d1e3             shl bx, 1
  02A99C  5DAC: 03d8             add bx, ax
  02A99E  5DAE: d1e3             shl bx, 1
  02A9A0  5DB0: ffb73052         push word ptr [bx + 0x5230]
  02A9A4  5DB4: 6a01             push 1
  02A9A6  5DB6: 9a38041f18       lcall 0x181f, 0x438
  02A9AB  5DBB: 83c404           add sp, 4
  02A9AE  5DBE: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  02A9B2  5DC2: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  02A9B6  5DC6: 2aff             sub bh, bh
  02A9B8  5DC8: 8bc3             mov ax, bx
  02A9BA  5DCA: d1e3             shl bx, 1
  02A9BC  5DCC: 03d8             add bx, ax
  02A9BE  5DCE: d1e3             shl bx, 1
  02A9C0  5DD0: 03d8             add bx, ax
  02A9C2  5DD2: d1e3             shl bx, 1
  02A9C4  5DD4: ffb73052         push word ptr [bx + 0x5230]
  02A9C8  5DD8: 6a02             push 2
  02A9CA  5DDA: 9a38041f18       lcall 0x181f, 0x438
  02A9CF  5DDF: 83c404           add sp, 4
  02A9D2  5DE2: 8b46fe           mov ax, word ptr [bp - 2]
  02A9D5  5DE5: 99               cdq 
  02A9D6  5DE6: 52               push dx
  02A9D7  5DE7: 50               push ax
  02A9D8  5DE8: 6a00             push 0
  02A9DA  5DEA: 9aae091f18       lcall 0x181f, 0x9ae
  02A9DF  5DEF: 83c406           add sp, 6
  02A9E2  5DF2: 8d1e7c08         lea bx, [0x87c]
  02A9E6  5DF6: 8d06e40c         lea ax, [0xce4]
  02A9EA  5DFA: 8b56fe           mov dx, word ptr [bp - 2]
  02A9ED  5DFD: 9a36041f19       lcall 0x191f, 0x436
  02A9F2  5E02: 0bc0             or ax, ax
  02A9F4  5E04: 7403             je 0x5e09
  02A9F6  5E06: e9ee00           jmp 0x5ef7
  02A9F9  5E09: ff76fe           push word ptr [bp - 2]
  02A9FC  5E0C: 50               push ax
  02A9FD  5E0D: ff36c89c         push word ptr [0x9cc8]
  02AA01  5E11: 9a5c031f18       lcall 0x181f, 0x35c
  02AA06  5E16: 83c406           add sp, 6
  02AA09  5E19: 8946fa           mov word ptr [bp - 6], ax
  02AA0C  5E1C: 8b46fe           mov ax, word ptr [bp - 2]
  02AA0F  5E1F: 3b46fa           cmp ax, word ptr [bp - 6]
  02AA12  5E22: 7e03             jle 0x5e27
  02AA14  5E24: 8b46fa           mov ax, word ptr [bp - 6]
  02AA17  5E27: 8946fe           mov word ptr [bp - 2], ax
  02AA1A  5E2A: 0bc0             or ax, ax
  02AA1C  5E2C: 7f03             jg 0x5e31
  02AA1E  5E2E: e9c600           jmp 0x5ef7
  02AA21  5E31: ff760a           push word ptr [bp + 0xa]
  02AA24  5E34: ff7606           push word ptr [bp + 6]
  02AA27  5E37: 9aec0a1f18       lcall 0x181f, 0xaec
  02AA2C  5E3C: 83c404           add sp, 4
  02AA2F  5E3F: 8946f8           mov word ptr [bp - 8], ax
  02AA32  5E42: 0bc0             or ax, ax
  02AA34  5E44: 7d0a             jge 0x5e50
  02AA36  5E46: 6a00             push 0
  02AA38  5E48: 6a78             push 0x78
  02AA3A  5E4A: 6a0b             push 0xb
  02AA3C  5E4C: e9e0fe           jmp 0x5d2f
  02AA3F  5E4F: 90               nop 
  02AA40  5E50: a1c48d           mov ax, word ptr [0x8dc4]
  02AA43  5E53: 3946fe           cmp word ptr [bp - 2], ax
  02AA46  5E56: 7d18             jge 0x5e70
  02AA48  5E58: 2b46fe           sub ax, word ptr [bp - 2]
  02AA4B  5E5B: 50               push ax
  02AA4C  5E5C: ff76f8           push word ptr [bp - 8]
  02AA4F  5E5F: ff7606           push word ptr [bp + 6]
  02AA52  5E62: 9a580d1f18       lcall 0x181f, 0xd58
  02AA57  5E67: 83c406           add sp, 6
  02AA5A  5E6A: 8b46fe           mov ax, word ptr [bp - 2]
  02AA5D  5E6D: a3c48d           mov word ptr [0x8dc4], ax
  02AA60  5E70: 50               push ax
  02AA61  5E71: ff76f8           push word ptr [bp - 8]
  02AA64  5E74: ff7608           push word ptr [bp + 8]
  02AA67  5E77: 9a580d1f18       lcall 0x181f, 0xd58
  02AA6C  5E7C: 83c406           add sp, 6
  02AA6F  5E7F: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  02AA73  5E83: 80bf4c3102       cmp byte ptr [bx + 0x314c], 2
  02AA78  5E88: 7405             je 0x5e8f
  02AA7A  5E8A: c6874c3100       mov byte ptr [bx + 0x314c], 0
  02AA7F  5E8F: 6a01             push 1
  02AA81  5E91: 9a56001f18       lcall 0x181f, 0x56
  02AA86  5E96: 83c402           add sp, 2
  02AA89  5E99: ff36c48d         push word ptr [0x8dc4]
  02AA8D  5E9D: 9a7e001f18       lcall 0x181f, 0x7e
  02AA92  5EA2: 83c402           add sp, 2
  02AA95  5EA5: 8b5ef8           mov bx, word ptr [bp - 8]
  02AA98  5EA8: d1e3             shl bx, 1
  02AA9A  5EAA: ffb7c097         push word ptr [bx - 0x6840]
  02AA9E  5EAE: 9a74001f18       lcall 0x181f, 0x74
  02AAA3  5EB3: 83c402           add sp, 2
  02AAA6  5EB6: 6a02             push 2
  02AAA8  5EB8: 0e               push cs
  02AAA9  5EB9: e80d20           call 0x7ec9
  02AAAC  5EBC: 83c402           add sp, 2
  02AAAF  5EBF: 6b5e081c         imul bx, word ptr [bp + 8], 0x1c
  02AAB3  5EC3: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  02AAB7  5EC7: 2aff             sub bh, bh
  02AAB9  5EC9: 8bc3             mov ax, bx
  02AABB  5ECB: d1e3             shl bx, 1
  02AABD  5ECD: 03d8             add bx, ax
  02AABF  5ECF: d1e3             shl bx, 1
  02AAC1  5ED1: 03d8             add bx, ax
  02AAC3  5ED3: d1e3             shl bx, 1
  02AAC5  5ED5: ffb73052         push word ptr [bx + 0x5230]
  02AAC9  5ED9: 9a74001f18       lcall 0x181f, 0x74
  02AACE  5EDE: 83c402           add sp, 2
  02AAD1  5EE1: 6a00             push 0
  02AAD3  5EE3: 6a78             push 0x78
  02AAD5  5EE5: 6a01             push 1
  02AAD7  5EE7: 0e               push cs
  02AAD8  5EE8: e8cf1f           call 0x7eba
  02AADB  5EEB: 83c406           add sp, 6
  02AADE  5EEE: 0e               push cs
  02AADF  5EEF: e8b91f           call 0x7eab
  02AAE2  5EF2: c746fc0000       mov word ptr [bp - 4], 0
  02AAE7  5EF7: 8b46fc           mov ax, word ptr [bp - 4]
  02AAEA  5EFA: c9               leave 
  02AAEB  5EFB: cb               retf 

; ---- func_02AAEC  size=674  insns=244  prologue=ENTER 0x0064,0  terminal=RETF ----
  02AAEC  5EFC: c8640000         enter 0x64, 0
  02AAF0  5F00: 57               push di
  02AAF1  5F01: 56               push si
  02AAF2  5F02: 2bc0             sub ax, ax
  02AAF4  5F04: 8946aa           mov word ptr [bp - 0x56], ax
  02AAF7  5F07: 8946a8           mov word ptr [bp - 0x58], ax
  02AAFA  5F0A: ff363e03         push word ptr [0x33e]
  02AAFE  5F0E: 9a320b1f18       lcall 0x181f, 0xb32
  02AB03  5F13: 83c402           add sp, 2
  02AB06  5F16: 8946a0           mov word ptr [bp - 0x60], ax
  02AB09  5F19: 0bc0             or ax, ax
  02AB0B  5F1B: 7d03             jge 0x5f20
  02AB0D  5F1D: e96702           jmp 0x6187
  02AB10  5F20: 9a66091f18       lcall 0x181f, 0x966
  02AB15  5F25: 0bc0             or ax, ax
  02AB17  5F27: 7406             je 0x5f2f
  02AB19  5F29: 8b46a0           mov ax, word ptr [bp - 0x60]
  02AB1C  5F2C: a39253           mov word ptr [0x5392], ax
  02AB1F  5F2F: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02AB23  5F33: 8d874631         lea ax, [bx + 0x3146]
  02AB27  5F37: 8bf0             mov si, ax
  02AB29  5F39: 8bcb             mov cx, bx
  02AB2B  5F3B: 8a1c             mov bl, byte ptr [si]
  02AB2D  5F3D: 2aff             sub bh, bh
  02AB2F  5F3F: 8bd3             mov dx, bx
  02AB31  5F41: d1e3             shl bx, 1
  02AB33  5F43: 03da             add bx, dx
  02AB35  5F45: d1e3             shl bx, 1
  02AB37  5F47: 03da             add bx, dx
  02AB39  5F49: d1e3             shl bx, 1
  02AB3B  5F4B: ffb73052         push word ptr [bx + 0x5230]
  02AB3F  5F4F: 6a00             push 0
  02AB41  5F51: 8bfe             mov di, si
  02AB43  5F53: 8bf1             mov si, cx
  02AB45  5F55: 9a38041f18       lcall 0x181f, 0x438
  02AB4A  5F5A: 83c404           add sp, 4
  02AB4D  5F5D: c646b000         mov byte ptr [bp - 0x50], 0
  02AB51  5F61: 803d0a           cmp byte ptr [di], 0xa
  02AB54  5F64: 7548             jne 0x5fae
  02AB56  5F66: 8a845b31         mov al, byte ptr [si + 0x315b]
  02AB5A  5F6A: 2ae4             sub ah, ah
  02AB5C  5F6C: b96400           mov cx, 0x64
  02AB5F  5F6F: f7e1             mul cx
  02AB61  5F71: 89469c           mov word ptr [bp - 0x64], ax
  02AB64  5F74: 89569e           mov word ptr [bp - 0x62], dx
  02AB67  5F77: 8d46b0           lea ax, [bp - 0x50]
  02AB6A  5F7A: 50               push ax
  02AB6B  5F7B: 9a78011f18       lcall 0x181f, 0x178
  02AB70  5F80: 83c402           add sp, 2
  02AB73  5F83: 8d46b0           lea ax, [bp - 0x50]
  02AB76  5F86: 50               push ax
  02AB77  5F87: 9a1e011f18       lcall 0x181f, 0x11e
  02AB7C  5F8C: 83c402           add sp, 2
  02AB7F  5F8F: ff769e           push word ptr [bp - 0x62]
  02AB82  5F92: ff769c           push word ptr [bp - 0x64]
  02AB85  5F95: 8d46b0           lea ax, [bp - 0x50]
  02AB88  5F98: 16               push ss
  02AB89  5F99: 50               push ax
  02AB8A  5F9A: 9ad8001f18       lcall 0x181f, 0xd8
  02AB8F  5F9F: 83c408           add sp, 8
  02AB92  5FA2: 8d46b0           lea ax, [bp - 0x50]
  02AB95  5FA5: 50               push ax
  02AB96  5FA6: 9a28011f18       lcall 0x181f, 0x128
  02AB9B  5FAB: 83c402           add sp, 2
  02AB9E  5FAE: 8d46b0           lea ax, [bp - 0x50]
  02ABA1  5FB1: 16               push ss
  02ABA2  5FB2: 50               push ax
  02ABA3  5FB3: 6a01             push 1
  02ABA5  5FB5: 9a16041f18       lcall 0x181f, 0x416
  02ABAA  5FBA: 83c406           add sp, 6
  02ABAD  5FBD: 8d1e7c08         lea bx, [0x87c]
  02ABB1  5FC1: 8d06ed0c         lea ax, [0xced]
  02ABB5  5FC5: 2bd2             sub dx, dx
  02ABB7  5FC7: 9a82011f19       lcall 0x191f, 0x182
  02ABBC  5FCC: 8946a8           mov word ptr [bp - 0x58], ax
  02ABBF  5FCF: 8956aa           mov word ptr [bp - 0x56], dx
  02ABC2  5FD2: 0bd0             or dx, ax
  02ABC4  5FD4: 7503             jne 0x5fd9
  02ABC6  5FD6: e9ae01           jmp 0x6187
  02ABC9  5FD9: c45ea8           les bx, ptr [bp - 0x58]
  02ABCC  5FDC: 26804f0a03       or byte ptr es:[bx + 0xa], 3
  02ABD1  5FE1: 68f80c           push 0xcf8
  02ABD4  5FE4: 687c08           push 0x87c
  02ABD7  5FE7: 9a28091f19       lcall 0x191f, 0x928
  02ABDC  5FEC: 83c404           add sp, 4
  02ABDF  5FEF: 0bc0             or ax, ax
  02ABE1  5FF1: 7403             je 0x5ff6
  02ABE3  5FF3: e99101           jmp 0x6187
  02ABE6  5FF6: 50               push ax
  02ABE7  5FF7: 50               push ax
  02ABE8  5FF8: 50               push ax
  02ABE9  5FF9: ff76a0           push word ptr [bp - 0x60]
  02ABEC  5FFC: ff364008         push word ptr [0x840]
  02ABF0  6000: ff363e08         push word ptr [0x83e]
  02ABF4  6004: ff76aa           push word ptr [bp - 0x56]
  02ABF7  6007: ff76a8           push word ptr [bp - 0x58]
  02ABFA  600A: 9a30021f19       lcall 0x191f, 0x230
  02ABFF  600F: 83c410           add sp, 0x10
  02AC02  6012: c746a20100       mov word ptr [bp - 0x5e], 1
  02AC07  6017: e99900           jmp 0x60b3
  02AC0A  601A: 833e3e0300       cmp word ptr [0x33e], 0
  02AC0F  601F: 7f20             jg 0x6041
  02AC11  6021: 2bc0             sub ax, ax
  02AC13  6023: 8946a4           mov word ptr [bp - 0x5c], ax
  02AC16  6026: eb6c             jmp 0x6094
  02AC18  6028: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02AC1C  602C: 80bf4c3101       cmp byte ptr [bx + 0x314c], 1
  02AC21  6031: 1bc0             sbb ax, ax
  02AC23  6033: 40               inc ax
  02AC24  6034: ebed             jmp 0x6023
  02AC26  6036: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02AC2A  603A: 80bf4c3101       cmp byte ptr [bx + 0x314c], 1
  02AC2F  603F: 74e0             je 0x6021
  02AC31  6041: b80100           mov ax, 1
  02AC34  6044: ebdd             jmp 0x6023
  02AC36  6046: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02AC3A  604A: 80bf4c3105       cmp byte ptr [bx + 0x314c], 5
  02AC3F  604F: 7415             je 0x6066
  02AC41  6051: 80bf4c3106       cmp byte ptr [bx + 0x314c], 6
  02AC46  6056: 740e             je 0x6066
  02AC48  6058: 80bf46310c       cmp byte ptr [bx + 0x3146], 0xc
  02AC4D  605D: 7407             je 0x6066
  02AC4F  605F: c746a40100       mov word ptr [bp - 0x5c], 1
  02AC54  6064: eb2e             jmp 0x6094
  02AC56  6066: c746a40000       mov word ptr [bp - 0x5c], 0
  02AC5B  606B: eb27             jmp 0x6094
  02AC5D  606D: 90               nop 
  02AC5E  606E: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02AC62  6072: 8a875031         mov al, byte ptr [bx + 0x3150]
  02AC66  6076: 2ae4             sub ah, ah
  02AC68  6078: eba9             jmp 0x6023
  02AC6A  607A: 48               dec ax
  02AC6B  607B: 3d0500           cmp ax, 5
  02AC6E  607E: 7714             ja 0x6094
  02AC70  6080: d1e0             shl ax, 1
  02AC72  6082: 93               xchg bx, ax
  02AC73  6083: 2effa77853       jmp word ptr cs:[bx + 0x5378]
  02AC78  6088: 0a5318           or dl, byte ptr [bp + di + 0x18]
  02AC7B  608B: 53               push bx
  02AC7C  608C: 2653             push bx
  02AC7E  608E: 3653             push bx
  02AC80  6090: 5e               pop si
  02AC81  6091: 53               push bx
  02AC82  6092: 4f               dec di
  02AC83  6093: 53               push bx
  02AC84  6094: 837ea400         cmp word ptr [bp - 0x5c], 0
  02AC88  6098: 7416             je 0x60b0
  02AC8A  609A: ff76a2           push word ptr [bp - 0x5e]
  02AC8D  609D: 8d46b0           lea ax, [bp - 0x50]
  02AC90  60A0: 16               push ss
  02AC91  60A1: 50               push ax
  02AC92  60A2: ff76aa           push word ptr [bp - 0x56]
  02AC95  60A5: ff76a8           push word ptr [bp - 0x58]
  02AC98  60A8: 9a76011f19       lcall 0x191f, 0x176
  02AC9D  60AD: 83c40a           add sp, 0xa
  02ACA0  60B0: ff46a2           inc word ptr [bp - 0x5e]
  02ACA3  60B3: 837ea206         cmp word ptr [bp - 0x5e], 6
  02ACA7  60B7: 7f1b             jg 0x60d4
  02ACA9  60B9: 8d46b0           lea ax, [bp - 0x50]
  02ACAC  60BC: 50               push ax
  02ACAD  60BD: 9a1c091f19       lcall 0x191f, 0x91c
  02ACB2  60C2: 8946a6           mov word ptr [bp - 0x5a], ax
  02ACB5  60C5: 50               push ax
  02ACB6  60C6: 9a10091f19       lcall 0x191f, 0x910
  02ACBB  60CB: 83c404           add sp, 4
  02ACBE  60CE: 8b46a2           mov ax, word ptr [bp - 0x5e]
  02ACC1  60D1: eba7             jmp 0x607a
  02ACC3  60D3: 90               nop 
  02ACC4  60D4: ff76aa           push word ptr [bp - 0x56]
  02ACC7  60D7: ff76a8           push word ptr [bp - 0x58]
  02ACCA  60DA: 9a6a011f19       lcall 0x191f, 0x16a
  02ACCF  60DF: 8946ac           mov word ptr [bp - 0x54], ax
  02ACD2  60E2: ff76aa           push word ptr [bp - 0x56]
  02ACD5  60E5: ff76a8           push word ptr [bp - 0x58]
  02ACD8  60E8: 9aa8011f19       lcall 0x191f, 0x1a8
  02ACDD  60ED: 2bc0             sub ax, ax
  02ACDF  60EF: 8946aa           mov word ptr [bp - 0x56], ax
  02ACE2  60F2: 8946a8           mov word ptr [bp - 0x58], ax
  02ACE5  60F5: 837eac01         cmp word ptr [bp - 0x54], 1
  02ACE9  60F9: 7d03             jge 0x60fe
  02ACEB  60FB: e98900           jmp 0x6187
  02ACEE  60FE: 837eac06         cmp word ptr [bp - 0x54], 6
  02ACF2  6102: 7c03             jl 0x6107
  02ACF4  6104: e98000           jmp 0x6187
  02ACF7  6107: 8b46ac           mov ax, word ptr [bp - 0x54]
  02ACFA  610A: eb6c             jmp 0x6178
  02ACFC  610C: ff76a0           push word ptr [bp - 0x60]
  02ACFF  610F: 9a9e081f18       lcall 0x181f, 0x89e
  02AD04  6114: 83c402           add sp, 2
  02AD07  6117: 8b46a0           mov ax, word ptr [bp - 0x60]
  02AD0A  611A: a3788d           mov word ptr [0x8d78], ax
  02AD0D  611D: 2bc0             sub ax, ax
  02AD0F  611F: a34003           mov word ptr [0x340], ax
  02AD12  6122: a33e03           mov word ptr [0x33e], ax
  02AD15  6125: eb60             jmp 0x6187
  02AD17  6127: 90               nop 
  02AD18  6128: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02AD1C  612C: c6874c3100       mov byte ptr [bx + 0x314c], 0
  02AD21  6131: eb54             jmp 0x6187
  02AD23  6133: 90               nop 
  02AD24  6134: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02AD28  6138: c6874c3101       mov byte ptr [bx + 0x314c], 1
  02AD2D  613D: eb48             jmp 0x6187
  02AD2F  613F: 90               nop 
  02AD30  6140: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02AD34  6144: c6874c3105       mov byte ptr [bx + 0x314c], 5
  02AD39  6149: eb3c             jmp 0x6187
  02AD3B  614B: 90               nop 
  02AD3C  614C: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02AD40  6150: 80bf503100       cmp byte ptr [bx + 0x3150], 0
  02AD45  6155: 7430             je 0x6187
  02AD47  6157: 6a00             push 0
  02AD49  6159: 6a00             push 0
  02AD4B  615B: ff76a0           push word ptr [bp - 0x60]
  02AD4E  615E: 9ae60b1f18       lcall 0x181f, 0xbe6
  02AD53  6163: 83c404           add sp, 4
  02AD56  6166: 8946ae           mov word ptr [bp - 0x52], ax
  02AD59  6169: 50               push ax
  02AD5A  616A: ff76a0           push word ptr [bp - 0x60]
  02AD5D  616D: 0e               push cs
  02AD5E  616E: e8681c           call 0x7dd9
  02AD61  6171: 83c406           add sp, 6
  02AD64  6174: 0bc0             or ax, ax
  02AD66  6176: eb0d             jmp 0x6185
  02AD68  6178: 48               dec ax
  02AD69  6179: 7491             je 0x610c
  02AD6B  617B: 48               dec ax
  02AD6C  617C: 74aa             je 0x6128
  02AD6E  617E: 48               dec ax
  02AD6F  617F: 74b3             je 0x6134
  02AD71  6181: 48               dec ax
  02AD72  6182: 74bc             je 0x6140
  02AD74  6184: 48               dec ax
  02AD75  6185: 74c5             je 0x614c
  02AD77  6187: 8b46aa           mov ax, word ptr [bp - 0x56]
  02AD7A  618A: 0b46a8           or ax, word ptr [bp - 0x58]
  02AD7D  618D: 740b             je 0x619a
  02AD7F  618F: ff76aa           push word ptr [bp - 0x56]
  02AD82  6192: ff76a8           push word ptr [bp - 0x58]
  02AD85  6195: 9aa8011f19       lcall 0x191f, 0x1a8
  02AD8A  619A: 5e               pop si
  02AD8B  619B: 5f               pop di
  02AD8C  619C: c9               leave 
  02AD8D  619D: cb               retf 

; ---- func_02AD8E  size=331  insns=118  prologue=ENTER 0x000A,0  terminal=RETF ----
  02AD8E  619E: c80a0000         enter 0xa, 0
  02AD92  61A2: 813eea079300     cmp word ptr [0x7ea], 0x93
  02AD98  61A8: 7d08             jge 0x61b2
  02AD9A  61AA: c746f80100       mov word ptr [bp - 8], 1
  02AD9F  61AF: eb06             jmp 0x61b7
  02ADA1  61B1: 90               nop 
  02ADA2  61B2: c746f80000       mov word ptr [bp - 8], 0
  02ADA7  61B7: 837ef800         cmp word ptr [bp - 8], 0
  02ADAB  61BB: 751b             jne 0x61d8
  02ADAD  61BD: 6a47             push 0x47
  02ADAF  61BF: 6a00             push 0
  02ADB1  61C1: a1e807           mov ax, word ptr [0x7e8]
  02ADB4  61C4: 2d8200           sub ax, 0x82
  02ADB7  61C7: 50               push ax
  02ADB8  61C8: 9a5c031f18       lcall 0x181f, 0x35c
  02ADBD  61CD: 83c406           add sp, 6
  02ADC0  61D0: b91200           mov cx, 0x12
  02ADC3  61D3: 99               cdq 
  02ADC4  61D4: f7f9             idiv cx
  02ADC6  61D6: eb1d             jmp 0x61f5
  02ADC8  61D8: 6a4e             push 0x4e
  02ADCA  61DA: 6a00             push 0
  02ADCC  61DC: a1e807           mov ax, word ptr [0x7e8]
  02ADCF  61DF: 2d7c00           sub ax, 0x7c
  02ADD2  61E2: 50               push ax
  02ADD3  61E3: 9a5c031f18       lcall 0x181f, 0x35c
  02ADD8  61E8: 83c406           add sp, 6
  02ADDB  61EB: 40               inc ax
  02ADDC  61EC: b90500           mov cx, 5
  02ADDF  61EF: 99               cdq 
  02ADE0  61F0: f7f9             idiv cx
  02ADE2  61F2: 050400           add ax, 4
  02ADE5  61F5: 8946f6           mov word ptr [bp - 0xa], ax
  02ADE8  61F8: a13c03           mov ax, word ptr [0x33c]
  02ADEB  61FB: 48               dec ax
  02ADEC  61FC: 3b46f6           cmp ax, word ptr [bp - 0xa]
  02ADEF  61FF: 7e03             jle 0x6204
  02ADF1  6201: 8b46f6           mov ax, word ptr [bp - 0xa]
  02ADF4  6204: 8946f6           mov word ptr [bp - 0xa], ax
  02ADF7  6207: 833e548d07       cmp word ptr [0x8d54], 7
  02ADFC  620C: 756c             jne 0x627a
  02ADFE  620E: 833ef40700       cmp word ptr [0x7f4], 0
  02AE03  6213: 7503             jne 0x6218
  02AE05  6215: e9cf00           jmp 0x62e7
  02AE08  6218: 803e8ca800       cmp byte ptr [0xa88c], 0
  02AE0D  621D: 7535             jne 0x6254
  02AE0F  621F: ff363e03         push word ptr [0x33e]
  02AE13  6223: 9a320b1f18       lcall 0x181f, 0xb32
  02AE18  6228: 83c402           add sp, 2
  02AE1B  622B: 8946fe           mov word ptr [bp - 2], ax
  02AE1E  622E: ff76f6           push word ptr [bp - 0xa]
  02AE21  6231: 9a320b1f18       lcall 0x181f, 0xb32
  02AE26  6236: 83c402           add sp, 2
  02AE29  6239: 8946fc           mov word ptr [bp - 4], ax
  02AE2C  623C: 9aa2031f18       lcall 0x181f, 0x3a2
  02AE31  6241: 50               push ax
  02AE32  6242: a08fa8           mov al, byte ptr [0xa88f]
  02AE35  6245: 2ae4             sub ah, ah
  02AE37  6247: 50               push ax
  02AE38  6248: ff76fc           push word ptr [bp - 4]
  02AE3B  624B: ff76fe           push word ptr [bp - 2]
  02AE3E  624E: 0e               push cs
  02AE3F  624F: e82c1c           call 0x7e7e
  02AE42  6252: eb21             jmp 0x6275
  02AE44  6254: 50               push ax
  02AE45  6255: 9a320b1f18       lcall 0x181f, 0xb32
  02AE4A  625A: 83c402           add sp, 2
  02AE4D  625D: 8946fe           mov word ptr [bp - 2], ax
  02AE50  6260: 9aa2031f18       lcall 0x181f, 0x3a2
  02AE55  6265: 50               push ax
  02AE56  6266: 6a01             push 1
  02AE58  6268: a08da8           mov al, byte ptr [0xa88d]
  02AE5B  626B: 2ae4             sub ah, ah
  02AE5D  626D: 50               push ax
  02AE5E  626E: ff76fe           push word ptr [bp - 2]
  02AE61  6271: 0e               push cs
  02AE62  6272: e8631c           call 0x7ed8
  02AE65  6275: 83c408           add sp, 8
  02AE68  6278: c9               leave 
  02AE69  6279: cb               retf 
  02AE6A  627A: 833eec0700       cmp word ptr [0x7ec], 0
  02AE6F  627F: 7406             je 0x6287
  02AE71  6281: a13e03           mov ax, word ptr [0x33e]
  02AE74  6284: a3040d           mov word ptr [0xd04], ax
  02AE77  6287: 833ef60700       cmp word ptr [0x7f6], 0
  02AE7C  628C: 7413             je 0x62a1
  02AE7E  628E: c7062e030200     mov word ptr [0x32e], 2
  02AE84  6294: 8b46f6           mov ax, word ptr [bp - 0xa]
  02AE87  6297: a34003           mov word ptr [0x340], ax
  02AE8A  629A: a33e03           mov word ptr [0x33e], ax
  02AE8D  629D: 0e               push cs
  02AE8E  629E: e80a1c           call 0x7eab
  02AE91  62A1: 833ef40700       cmp word ptr [0x7f4], 0
  02AE96  62A6: 743f             je 0x62e7
  02AE98  62A8: 833ee40700       cmp word ptr [0x7e4], 0
  02AE9D  62AD: 750f             jne 0x62be
  02AE9F  62AF: a13e03           mov ax, word ptr [0x33e]
  02AEA2  62B2: 3906040d         cmp word ptr [0xd04], ax
  02AEA6  62B6: 752f             jne 0x62e7
  02AEA8  62B8: 0e               push cs
  02AEA9  62B9: e8081c           call 0x7ec4
  02AEAC  62BC: c9               leave 
  02AEAD  62BD: cb               retf 
  02AEAE  62BE: 833e3c0300       cmp word ptr [0x33c], 0
  02AEB3  62C3: 7422             je 0x62e7
  02AEB5  62C5: ff363e03         push word ptr [0x33e]
  02AEB9  62C9: 9a320b1f18       lcall 0x181f, 0xb32
  02AEBE  62CE: 83c402           add sp, 2
  02AEC1  62D1: 6bd81c           imul bx, ax, 0x1c
  02AEC4  62D4: 8a874631         mov al, byte ptr [bx + 0x3146]
  02AEC8  62D8: 2ae4             sub ah, ah
  02AECA  62DA: 50               push ax
  02AECB  62DB: 9a42091f19       lcall 0x191f, 0x942
  02AED0  62E0: 83c402           add sp, 2
  02AED3  62E3: 0e               push cs
  02AED4  62E4: e8561b           call 0x7e3d
  02AED7  62E7: c9               leave 
  02AED8  62E8: cb               retf 

; ---- func_02AEDA  size=243  insns=90  prologue=ENTER 0x0008,0  terminal=RETF ----
  02AEDA  62EA: c8080000         enter 8, 0
  02AEDE  62EE: 56               push si
  02AEDF  62EF: 833e3c0300       cmp word ptr [0x33c], 0
  02AEE4  62F4: 7503             jne 0x62f9
  02AEE6  62F6: e9e100           jmp 0x63da
  02AEE9  62F9: 6a47             push 0x47
  02AEEB  62FB: 6a00             push 0
  02AEED  62FD: a1e807           mov ax, word ptr [0x7e8]
  02AEF0  6300: 2d7f00           sub ax, 0x7f
  02AEF3  6303: 50               push ax
  02AEF4  6304: 9a5c031f18       lcall 0x181f, 0x35c
  02AEF9  6309: 83c406           add sp, 6
  02AEFC  630C: b90c00           mov cx, 0xc
  02AEFF  630F: 99               cdq 
  02AF00  6310: f7f9             idiv cx
  02AF02  6312: 8946fc           mov word ptr [bp - 4], ax
  02AF05  6315: ff363e03         push word ptr [0x33e]
  02AF09  6319: 8bf0             mov si, ax
  02AF0B  631B: 9a320b1f18       lcall 0x181f, 0xb32
  02AF10  6320: 83c402           add sp, 2
  02AF13  6323: 8946f8           mov word ptr [bp - 8], ax
  02AF16  6326: 56               push si
  02AF17  6327: 50               push ax
  02AF18  6328: 9ae60b1f18       lcall 0x181f, 0xbe6
  02AF1D  632D: 83c404           add sp, 4
  02AF20  6330: 8946fa           mov word ptr [bp - 6], ax
  02AF23  6333: 833e548d07       cmp word ptr [0x8d54], 7
  02AF28  6338: 7530             jne 0x636a
  02AF2A  633A: 833ef40700       cmp word ptr [0x7f4], 0
  02AF2F  633F: 7503             jne 0x6344
  02AF31  6341: e99600           jmp 0x63da
  02AF34  6344: 803e8ca801       cmp byte ptr [0xa88c], 1
  02AF39  6349: 7403             je 0x634e
  02AF3B  634B: e98c00           jmp 0x63da
  02AF3E  634E: 9aa2031f18       lcall 0x181f, 0x3a2
  02AF43  6353: 50               push ax
  02AF44  6354: 6a01             push 1
  02AF46  6356: a08da8           mov al, byte ptr [0xa88d]
  02AF49  6359: 2ae4             sub ah, ah
  02AF4B  635B: 50               push ax
  02AF4C  635C: ff76f8           push word ptr [bp - 8]
  02AF4F  635F: 0e               push cs
  02AF50  6360: e8751b           call 0x7ed8
  02AF53  6363: 83c408           add sp, 8
  02AF56  6366: 5e               pop si
  02AF57  6367: c9               leave 
  02AF58  6368: cb               retf 
  02AF59  6369: 90               nop 
  02AF5A  636A: 833eec0700       cmp word ptr [0x7ec], 0
  02AF5F  636F: 7446             je 0x63b7
  02AF61  6371: 0bc0             or ax, ax
  02AF63  6373: 7c42             jl 0x63b7
  02AF65  6375: 833ee40700       cmp word ptr [0x7e4], 0
  02AF6A  637A: 753b             jne 0x63b7
  02AF6C  637C: 6a00             push 0
  02AF6E  637E: 6a00             push 0
  02AF70  6380: 50               push ax
  02AF71  6381: 0e               push cs
  02AF72  6382: e8801b           call 0x7f05
  02AF75  6385: 83c406           add sp, 6
  02AF78  6388: c6068ca800       mov byte ptr [0xa88c], 0
  02AF7D  638D: 8a46fa           mov al, byte ptr [bp - 6]
  02AF80  6390: a28da8           mov byte ptr [0xa88d], al
  02AF83  6393: 8a46fc           mov al, byte ptr [bp - 4]
  02AF86  6396: a28fa8           mov byte ptr [0xa88f], al
  02AF89  6399: ff76fc           push word ptr [bp - 4]
  02AF8C  639C: ff76f8           push word ptr [bp - 8]
  02AF8F  639F: 9a680c1f18       lcall 0x181f, 0xc68
  02AF94  63A4: 83c404           add sp, 4
  02AF97  63A7: a28ea8           mov byte ptr [0xa88e], al
  02AF9A  63AA: 2ae4             sub ah, ah
  02AF9C  63AC: 50               push ax
  02AF9D  63AD: ff76fa           push word ptr [bp - 6]
  02AFA0  63B0: 0e               push cs
  02AFA1  63B1: e82a1a           call 0x7dde
  02AFA4  63B4: 83c404           add sp, 4
  02AFA7  63B7: 833ef40700       cmp word ptr [0x7f4], 0
  02AFAC  63BC: 741c             je 0x63da
  02AFAE  63BE: 837efa00         cmp word ptr [bp - 6], 0
  02AFB2  63C2: 7c16             jl 0x63da
  02AFB4  63C4: 833ee40700       cmp word ptr [0x7e4], 0
  02AFB9  63C9: 740f             je 0x63da
  02AFBB  63CB: ff76fa           push word ptr [bp - 6]
  02AFBE  63CE: 9a34091f19       lcall 0x191f, 0x934
  02AFC3  63D3: 83c402           add sp, 2
  02AFC6  63D6: 0e               push cs
  02AFC7  63D7: e8631a           call 0x7e3d
  02AFCA  63DA: 5e               pop si
  02AFCB  63DB: c9               leave 
  02AFCC  63DC: cb               retf 

; ---- func_02AFCE  size=119  insns=48  prologue=ENTER 0x0002,0  terminal=RETF ----
  02AFCE  63DE: c8020000         enter 2, 0
  02AFD2  63E2: 833ef60700       cmp word ptr [0x7f6], 0
  02AFD7  63E7: 7411             je 0x63fa
  02AFD9  63E9: 833e2e0302       cmp word ptr [0x32e], 2
  02AFDE  63EE: 740a             je 0x63fa
  02AFE0  63F0: c7062e030200     mov word ptr [0x32e], 2
  02AFE6  63F6: 0e               push cs
  02AFE7  63F7: e8b11a           call 0x7eab
  02AFEA  63FA: 6a16             push 0x16
  02AFEC  63FC: 6a48             push 0x48
  02AFEE  63FE: 68a500           push 0xa5
  02AFF1  6401: 6a7f             push 0x7f
  02AFF3  6403: 9aca031f18       lcall 0x181f, 0x3ca
  02AFF8  6408: 83c408           add sp, 8
  02AFFB  640B: 0bc0             or ax, ax
  02AFFD  640D: 7407             je 0x6416
  02AFFF  640F: c646fe01         mov byte ptr [bp - 2], 1
  02B003  6413: eb05             jmp 0x641a
  02B005  6415: 90               nop 
  02B006  6416: c646fe00         mov byte ptr [bp - 2], 0
  02B00A  641A: 833eec0700       cmp word ptr [0x7ec], 0
  02B00F  641F: 7507             jne 0x6428
  02B011  6421: 833e548d07       cmp word ptr [0x8d54], 7
  02B016  6426: 7506             jne 0x642e
  02B018  6428: 8a46fe           mov al, byte ptr [bp - 2]
  02B01B  642B: a28ba8           mov byte ptr [0xa88b], al
  02B01E  642E: a08ba8           mov al, byte ptr [0xa88b]
  02B021  6431: 2ae4             sub ah, ah
  02B023  6433: eb17             jmp 0x644c
  02B025  6435: 90               nop 
  02B026  6436: 0e               push cs
  02B027  6437: e83f1a           call 0x7e79
  02B02A  643A: c9               leave 
  02B02B  643B: cb               retf 
  02B02C  643C: 8a46fe           mov al, byte ptr [bp - 2]
  02B02F  643F: 38068ba8         cmp byte ptr [0xa88b], al
  02B033  6443: 750e             jne 0x6453
  02B035  6445: 0e               push cs
  02B036  6446: e8b71a           call 0x7f00
  02B039  6449: c9               leave 
  02B03A  644A: cb               retf 
  02B03B  644B: 90               nop 
  02B03C  644C: 0bc0             or ax, ax
  02B03E  644E: 74e6             je 0x6436
  02B040  6450: 48               dec ax
  02B041  6451: 74e9             je 0x643c
  02B043  6453: c9               leave 
  02B044  6454: cb               retf 

; ---- func_02B046  size=602  insns=213  prologue=ENTER 0x0060,0  terminal=RETF ----
  02B046  6456: c8600000         enter 0x60, 0
  02B04A  645A: 56               push si
  02B04B  645B: 2bc0             sub ax, ax
  02B04D  645D: 8946ac           mov word ptr [bp - 0x54], ax
  02B050  6460: 8946aa           mov word ptr [bp - 0x56], ax
  02B053  6463: a1788d           mov ax, word ptr [0x8d78]
  02B056  6466: 8b167a8d         mov dx, word ptr [0x8d7a]
  02B05A  646A: 9a2a091f18       lcall 0x181f, 0x92a
  02B05F  646F: 8946a0           mov word ptr [bp - 0x60], ax
  02B062  6472: 0bc0             or ax, ax
  02B064  6474: 7d03             jge 0x6479
  02B066  6476: e92102           jmp 0x669a
  02B069  6479: 9a66091f18       lcall 0x181f, 0x966
  02B06E  647E: 0bc0             or ax, ax
  02B070  6480: 7406             je 0x6488
  02B072  6482: 8b46a0           mov ax, word ptr [bp - 0x60]
  02B075  6485: a39253           mov word ptr [0x5392], ax
  02B078  6488: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02B07C  648C: 8bc3             mov ax, bx
  02B07E  648E: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  02B082  6492: 2aff             sub bh, bh
  02B084  6494: 8bcb             mov cx, bx
  02B086  6496: d1e3             shl bx, 1
  02B088  6498: 03d9             add bx, cx
  02B08A  649A: d1e3             shl bx, 1
  02B08C  649C: 03d9             add bx, cx
  02B08E  649E: d1e3             shl bx, 1
  02B090  64A0: ffb73052         push word ptr [bx + 0x5230]
  02B094  64A4: 6a00             push 0
  02B096  64A6: 8bf0             mov si, ax
  02B098  64A8: 9a38041f18       lcall 0x181f, 0x438
  02B09D  64AD: 83c404           add sp, 4
  02B0A0  64B0: c646b000         mov byte ptr [bp - 0x50], 0
  02B0A4  64B4: ff76a0           push word ptr [bp - 0x60]
  02B0A7  64B7: 9a280b1f18       lcall 0x181f, 0xb28
  02B0AC  64BC: 83c402           add sp, 2
  02B0AF  64BF: 0bc0             or ax, ax
  02B0B1  64C1: 744b             je 0x650e
  02B0B3  64C3: 8a845b31         mov al, byte ptr [si + 0x315b]
  02B0B7  64C7: 98               cwde 
  02B0B8  64C8: 8946a2           mov word ptr [bp - 0x5e], ax
  02B0BB  64CB: 3d1c00           cmp ax, 0x1c
  02B0BE  64CE: 743e             je 0x650e
  02B0C0  64D0: 8d46b0           lea ax, [bp - 0x50]
  02B0C3  64D3: 50               push ax
  02B0C4  64D4: 9a78011f18       lcall 0x181f, 0x178
  02B0C9  64D9: 83c402           add sp, 2
  02B0CC  64DC: 8d46b0           lea ax, [bp - 0x50]
  02B0CF  64DF: 50               push ax
  02B0D0  64E0: 9a1e011f18       lcall 0x181f, 0x11e
  02B0D5  64E5: 83c402           add sp, 2
  02B0D8  64E8: 8a845b31         mov al, byte ptr [si + 0x315b]
  02B0DC  64EC: 98               cwde 
  02B0DD  64ED: 8bd8             mov bx, ax
  02B0DF  64EF: c1e303           shl bx, 3
  02B0E2  64F2: ffb7a48e         push word ptr [bx - 0x715c]
  02B0E6  64F6: 8d46b0           lea ax, [bp - 0x50]
  02B0E9  64F9: 50               push ax
  02B0EA  64FA: 9a6e011f18       lcall 0x181f, 0x16e
  02B0EF  64FF: 83c404           add sp, 4
  02B0F2  6502: 8d46b0           lea ax, [bp - 0x50]
  02B0F5  6505: 50               push ax
  02B0F6  6506: 9a28011f18       lcall 0x181f, 0x128
  02B0FB  650B: 83c402           add sp, 2
  02B0FE  650E: 8d46b0           lea ax, [bp - 0x50]
  02B101  6511: 16               push ss
  02B102  6512: 50               push ax
  02B103  6513: 6a01             push 1
  02B105  6515: 9a16041f18       lcall 0x181f, 0x416
  02B10A  651A: 83c406           add sp, 6
  02B10D  651D: 8d1e7c08         lea bx, [0x87c]
  02B111  6521: 8d06060d         lea ax, [0xd06]
  02B115  6525: 2bd2             sub dx, dx
  02B117  6527: 9a82011f19       lcall 0x191f, 0x182
  02B11C  652C: 8946aa           mov word ptr [bp - 0x56], ax
  02B11F  652F: 8956ac           mov word ptr [bp - 0x54], dx
  02B122  6532: 0bd0             or dx, ax
  02B124  6534: 7503             jne 0x6539
  02B126  6536: e96101           jmp 0x669a
  02B129  6539: c45eaa           les bx, ptr [bp - 0x56]
  02B12C  653C: 26804f0a03       or byte ptr es:[bx + 0xa], 3
  02B131  6541: 68110d           push 0xd11
  02B134  6544: 687c08           push 0x87c
  02B137  6547: 9a28091f19       lcall 0x191f, 0x928
  02B13C  654C: 83c404           add sp, 4
  02B13F  654F: 0bc0             or ax, ax
  02B141  6551: 7403             je 0x6556
  02B143  6553: e94401           jmp 0x669a
  02B146  6556: 50               push ax
  02B147  6557: 50               push ax
  02B148  6558: 50               push ax
  02B149  6559: ff76a0           push word ptr [bp - 0x60]
  02B14C  655C: ff364008         push word ptr [0x840]
  02B150  6560: ff363e08         push word ptr [0x83e]
  02B154  6564: ff76ac           push word ptr [bp - 0x54]
  02B157  6567: ff76aa           push word ptr [bp - 0x56]
  02B15A  656A: 9a30021f19       lcall 0x191f, 0x230
  02B15F  656F: 83c410           add sp, 0x10
  02B162  6572: c746a40100       mov word ptr [bp - 0x5c], 1
  02B167  6577: eb2d             jmp 0x65a6
  02B169  6579: 90               nop 
  02B16A  657A: a1788d           mov ax, word ptr [0x8d78]
  02B16D  657D: 3946a0           cmp word ptr [bp - 0x60], ax
  02B170  6580: 756d             jne 0x65ef
  02B172  6582: 2bc0             sub ax, ax
  02B174  6584: 8946a6           mov word ptr [bp - 0x5a], ax
  02B177  6587: 837ea600         cmp word ptr [bp - 0x5a], 0
  02B17B  658B: 7416             je 0x65a3
  02B17D  658D: ff76a4           push word ptr [bp - 0x5c]
  02B180  6590: 8d46b0           lea ax, [bp - 0x50]
  02B183  6593: 16               push ss
  02B184  6594: 50               push ax
  02B185  6595: ff76ac           push word ptr [bp - 0x54]
  02B188  6598: ff76aa           push word ptr [bp - 0x56]
  02B18B  659B: 9a76011f19       lcall 0x191f, 0x176
  02B190  65A0: 83c40a           add sp, 0xa
  02B193  65A3: ff46a4           inc word ptr [bp - 0x5c]
  02B196  65A6: 837ea405         cmp word ptr [bp - 0x5c], 5
  02B19A  65AA: 7f6a             jg 0x6616
  02B19C  65AC: 8d46b0           lea ax, [bp - 0x50]
  02B19F  65AF: 50               push ax
  02B1A0  65B0: 9a1c091f19       lcall 0x191f, 0x91c
  02B1A5  65B5: 8946a8           mov word ptr [bp - 0x58], ax
  02B1A8  65B8: 50               push ax
  02B1A9  65B9: 9a10091f19       lcall 0x191f, 0x910
  02B1AE  65BE: 83c404           add sp, 4
  02B1B1  65C1: 8b46a4           mov ax, word ptr [bp - 0x5c]
  02B1B4  65C4: 48               dec ax
  02B1B5  65C5: 74b3             je 0x657a
  02B1B7  65C7: 48               dec ax
  02B1B8  65C8: 740c             je 0x65d6
  02B1BA  65CA: 48               dec ax
  02B1BB  65CB: 7417             je 0x65e4
  02B1BD  65CD: 48               dec ax
  02B1BE  65CE: 7424             je 0x65f4
  02B1C0  65D0: 48               dec ax
  02B1C1  65D1: 7433             je 0x6606
  02B1C3  65D3: ebb2             jmp 0x6587
  02B1C5  65D5: 90               nop 
  02B1C6  65D6: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02B1CA  65DA: 80bf4c3101       cmp byte ptr [bx + 0x314c], 1
  02B1CF  65DF: 1bc0             sbb ax, ax
  02B1D1  65E1: 40               inc ax
  02B1D2  65E2: eba0             jmp 0x6584
  02B1D4  65E4: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02B1D8  65E8: 80bf4c3101       cmp byte ptr [bx + 0x314c], 1
  02B1DD  65ED: 7493             je 0x6582
  02B1DF  65EF: b80100           mov ax, 1
  02B1E2  65F2: eb90             jmp 0x6584
  02B1E4  65F4: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02B1E8  65F8: 80bf4c3105       cmp byte ptr [bx + 0x314c], 5
  02B1ED  65FD: 740f             je 0x660e
  02B1EF  65FF: 80bf4c3106       cmp byte ptr [bx + 0x314c], 6
  02B1F4  6604: 7408             je 0x660e
  02B1F6  6606: c746a60100       mov word ptr [bp - 0x5a], 1
  02B1FB  660B: e979ff           jmp 0x6587
  02B1FE  660E: c746a60000       mov word ptr [bp - 0x5a], 0
  02B203  6613: e971ff           jmp 0x6587
  02B206  6616: ff76ac           push word ptr [bp - 0x54]
  02B209  6619: ff76aa           push word ptr [bp - 0x56]
  02B20C  661C: 9a6a011f19       lcall 0x191f, 0x16a
  02B211  6621: 8946ae           mov word ptr [bp - 0x52], ax
  02B214  6624: ff76ac           push word ptr [bp - 0x54]
  02B217  6627: ff76aa           push word ptr [bp - 0x56]
  02B21A  662A: 9aa8011f19       lcall 0x191f, 0x1a8
  02B21F  662F: 2bc0             sub ax, ax
  02B221  6631: 8946ac           mov word ptr [bp - 0x54], ax
  02B224  6634: 8946aa           mov word ptr [bp - 0x56], ax
  02B227  6637: 837eae01         cmp word ptr [bp - 0x52], 1
  02B22B  663B: 7c5d             jl 0x669a
  02B22D  663D: 837eae05         cmp word ptr [bp - 0x52], 5
  02B231  6641: 7d57             jge 0x669a
  02B233  6643: 8b46ae           mov ax, word ptr [bp - 0x52]
  02B236  6646: eb46             jmp 0x668e
  02B238  6648: ff76a0           push word ptr [bp - 0x60]
  02B23B  664B: 9a9e081f18       lcall 0x181f, 0x89e
  02B240  6650: 83c402           add sp, 2
  02B243  6653: 8b46a0           mov ax, word ptr [bp - 0x60]
  02B246  6656: a3788d           mov word ptr [0x8d78], ax
  02B249  6659: c7067a8d0000     mov word ptr [0x8d7a], 0
  02B24F  665F: eb39             jmp 0x669a
  02B251  6661: 90               nop 
  02B252  6662: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02B256  6666: c6874c3100       mov byte ptr [bx + 0x314c], 0
  02B25B  666B: eb2d             jmp 0x669a
  02B25D  666D: 90               nop 
  02B25E  666E: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02B262  6672: c6874c3101       mov byte ptr [bx + 0x314c], 1
  02B267  6677: eb21             jmp 0x669a
  02B269  6679: 90               nop 
  02B26A  667A: 6b5ea01c         imul bx, word ptr [bp - 0x60], 0x1c
  02B26E  667E: c6874c3105       mov byte ptr [bx + 0x314c], 5
  02B273  6683: b85800           mov ax, 0x58
  02B276  6686: 9ac0041f18       lcall 0x181f, 0x4c0
  02B27B  668B: eb0d             jmp 0x669a
  02B27D  668D: 90               nop 
  02B27E  668E: 48               dec ax
  02B27F  668F: 74b7             je 0x6648
  02B281  6691: 48               dec ax
  02B282  6692: 74ce             je 0x6662
  02B284  6694: 48               dec ax
  02B285  6695: 74d7             je 0x666e
  02B287  6697: 48               dec ax
  02B288  6698: 74e0             je 0x667a
  02B28A  669A: 8b46ac           mov ax, word ptr [bp - 0x54]
  02B28D  669D: 0b46aa           or ax, word ptr [bp - 0x56]
  02B290  66A0: 740b             je 0x66ad
  02B292  66A2: ff76ac           push word ptr [bp - 0x54]
  02B295  66A5: ff76aa           push word ptr [bp - 0x56]
  02B298  66A8: 9aa8011f19       lcall 0x191f, 0x1a8
  02B29D  66AD: 5e               pop si
  02B29E  66AE: c9               leave 
  02B29F  66AF: cb               retf 

; ---- func_02B2A0  size=199  insns=72  prologue=ENTER 0x0008,0  terminal=RETF ----
  02B2A0  66B0: c8080000         enter 8, 0
  02B2A4  66B4: 813eea079e00     cmp word ptr [0x7ea], 0x9e
  02B2AA  66BA: 7c20             jl 0x66dc
  02B2AC  66BC: 6a59             push 0x59
  02B2AE  66BE: 2bc0             sub ax, ax
  02B2B0  66C0: 8946fc           mov word ptr [bp - 4], ax
  02B2B3  66C3: 50               push ax
  02B2B4  66C4: a1e807           mov ax, word ptr [0x7e8]
  02B2B7  66C7: 2dd500           sub ax, 0xd5
  02B2BA  66CA: 50               push ax
  02B2BB  66CB: 9a5c031f18       lcall 0x181f, 0x35c
  02B2C0  66D0: 83c406           add sp, 6
  02B2C3  66D3: b91200           mov cx, 0x12
  02B2C6  66D6: 99               cdq 
  02B2C7  66D7: f7f9             idiv cx
  02B2C9  66D9: eb39             jmp 0x6714
  02B2CB  66DB: 90               nop 
  02B2CC  66DC: 813eea079800     cmp word ptr [0x7ea], 0x98
  02B2D2  66E2: 7c08             jl 0x66ec
  02B2D4  66E4: c746fc0100       mov word ptr [bp - 4], 1
  02B2D9  66E9: eb06             jmp 0x66f1
  02B2DB  66EB: 90               nop 
  02B2DC  66EC: c746fc0200       mov word ptr [bp - 4], 2
  02B2E1  66F1: 6a53             push 0x53
  02B2E3  66F3: 6a00             push 0
  02B2E5  66F5: a1e807           mov ax, word ptr [0x7e8]
  02B2E8  66F8: 2dd500           sub ax, 0xd5
  02B2EB  66FB: 50               push ax
  02B2EC  66FC: 9a5c031f18       lcall 0x181f, 0x35c
  02B2F1  6701: 83c406           add sp, 6
  02B2F4  6704: 40               inc ax
  02B2F5  6705: b90500           mov cx, 5
  02B2F8  6708: 99               cdq 
  02B2F9  6709: f7f9             idiv cx
  02B2FB  670B: 6b4efc11         imul cx, word ptr [bp - 4], 0x11
  02B2FF  670F: 03c1             add ax, cx
  02B301  6711: 2d0c00           sub ax, 0xc
  02B304  6714: 8946f8           mov word ptr [bp - 8], ax
  02B307  6717: a1768d           mov ax, word ptr [0x8d76]
  02B30A  671A: 48               dec ax
  02B30B  671B: 3b46f8           cmp ax, word ptr [bp - 8]
  02B30E  671E: 7e03             jle 0x6723
  02B310  6720: 8b46f8           mov ax, word ptr [bp - 8]
  02B313  6723: 833ef60700       cmp word ptr [0x7f6], 0
  02B318  6728: 744b             je 0x6775
  02B31A  672A: c7062e030300     mov word ptr [0x32e], 3
  02B320  6730: a37a8d           mov word ptr [0x8d7a], ax
  02B323  6733: 833ef40700       cmp word ptr [0x7f4], 0
  02B328  6738: 7437             je 0x6771
  02B32A  673A: 833ee40700       cmp word ptr [0x7e4], 0
  02B32F  673F: 7507             jne 0x6748
  02B331  6741: 0e               push cs
  02B332  6742: e80c17           call 0x7e51
  02B335  6745: eb2a             jmp 0x6771
  02B337  6747: 90               nop 
  02B338  6748: 833e728d00       cmp word ptr [0x8d72], 0
  02B33D  674D: 7422             je 0x6771
  02B33F  674F: a1788d           mov ax, word ptr [0x8d78]
  02B342  6752: 8b167a8d         mov dx, word ptr [0x8d7a]
  02B346  6756: 9a2a091f18       lcall 0x181f, 0x92a
  02B34B  675B: 6bd81c           imul bx, ax, 0x1c
  02B34E  675E: 8a874631         mov al, byte ptr [bx + 0x3146]
  02B352  6762: 2ae4             sub ah, ah
  02B354  6764: 50               push ax
  02B355  6765: 9a42091f19       lcall 0x191f, 0x942
  02B35A  676A: 83c402           add sp, 2
  02B35D  676D: 0e               push cs
  02B35E  676E: e8cc16           call 0x7e3d
  02B361  6771: 0e               push cs
  02B362  6772: e81317           call 0x7e88
  02B365  6775: c9               leave 
  02B366  6776: cb               retf 

; ---- func_02B368  size=361  insns=126  prologue=ENTER 0x005A,0  terminal=RETF ----
  02B368  6778: c85a0000         enter 0x5a, 0
  02B36C  677C: 8b460a           mov ax, word ptr [bp + 0xa]
  02B36F  677F: 40               inc ax
  02B370  6780: 40               inc ax
  02B371  6781: 8946a6           mov word ptr [bp - 0x5a], ax
  02B374  6784: 837e0aff         cmp word ptr [bp + 0xa], -1
  02B378  6788: 7512             jne 0x679c
  02B37A  678A: 50               push ax
  02B37B  678B: ff36a893         push word ptr [0x93a8]
  02B37F  678F: 9a22001f18       lcall 0x181f, 0x22
  02B384  6794: 83c402           add sp, 2
  02B387  6797: 52               push dx
  02B388  6798: e93801           jmp 0x68d3
  02B38B  679B: 90               nop 
  02B38C  679C: 6a00             push 0
  02B38E  679E: ff760a           push word ptr [bp + 0xa]
  02B391  67A1: 9ac20c1f18       lcall 0x181f, 0xcc2
  02B396  67A6: 83c404           add sp, 4
  02B399  67A9: 8946aa           mov word ptr [bp - 0x56], ax
  02B39C  67AC: 8d46fe           lea ax, [bp - 2]
  02B39F  67AF: 50               push ax
  02B3A0  67B0: ff760a           push word ptr [bp + 0xa]
  02B3A3  67B3: 9ac40a1f18       lcall 0x181f, 0xac4
  02B3A8  67B8: 83c404           add sp, 4
  02B3AB  67BB: 8946a8           mov word ptr [bp - 0x58], ax
  02B3AE  67BE: ff760a           push word ptr [bp + 0xa]
  02B3B1  67C1: 9a4e0d1f18       lcall 0x181f, 0xd4e
  02B3B6  67C6: 83c402           add sp, 2
  02B3B9  67C9: 52               push dx
  02B3BA  67CA: 50               push ax
  02B3BB  67CB: 8d46ac           lea ax, [bp - 0x54]
  02B3BE  67CE: 16               push ss
  02B3BF  67CF: 50               push ax
  02B3C0  67D0: 9a7e111d0d       lcall 0xd1d, 0x117e
  02B3C5  67D5: 83c408           add sp, 8
  02B3C8  67D8: 8d46ac           lea ax, [bp - 0x54]
  02B3CB  67DB: 50               push ax
  02B3CC  67DC: 9a640d1d0d       lcall 0xd1d, 0xd64
  02B3D1  67E1: 83c402           add sp, 2
  02B3D4  67E4: 8d46ac           lea ax, [bp - 0x54]
  02B3D7  67E7: 50               push ax
  02B3D8  67E8: 9a78011f18       lcall 0x181f, 0x178
  02B3DD  67ED: 83c402           add sp, 2
  02B3E0  67F0: 681d0d           push 0xd1d
  02B3E3  67F3: 8d46ac           lea ax, [bp - 0x54]
  02B3E6  67F6: 50               push ax
  02B3E7  67F7: 9aa4071d0d       lcall 0xd1d, 0x7a4
  02B3EC  67FC: 83c404           add sp, 4
  02B3EF  67FF: 8d46ac           lea ax, [bp - 0x54]
  02B3F2  6802: 50               push ax
  02B3F3  6803: 9a1e011f18       lcall 0x181f, 0x11e
  02B3F8  6808: 83c402           add sp, 2
  02B3FB  680B: 8b46a8           mov ax, word ptr [bp - 0x58]
  02B3FE  680E: 8b1e4285         mov bx, word ptr [0x8542]
  02B402  6812: 2b879200         sub ax, word ptr [bx + 0x92]
  02B406  6816: 7902             jns 0x681a
  02B408  6818: 2bc0             sub ax, ax
  02B40A  681A: 8946fc           mov word ptr [bp - 4], ax
  02B40D  681D: 837eaa01         cmp word ptr [bp - 0x56], 1
  02B411  6821: 7527             jne 0x684a
  02B413  6823: ff760a           push word ptr [bp + 0xa]
  02B416  6826: 9afc091f18       lcall 0x181f, 0x9fc
  02B41B  682B: 83c402           add sp, 2
  02B41E  682E: 0bc0             or ax, ax
  02B420  6830: 7418             je 0x684a
  02B422  6832: ff36b82e         push word ptr [0x2eb8]
  02B426  6836: 8d46ac           lea ax, [bp - 0x54]
  02B429  6839: 50               push ax
  02B42A  683A: 9a6e011f18       lcall 0x181f, 0x16e
  02B42F  683F: 83c404           add sp, 4
  02B432  6842: c746fe0000       mov word ptr [bp - 2], 0
  02B437  6847: eb2d             jmp 0x6876
  02B439  6849: 90               nop 
  02B43A  684A: ff76fc           push word ptr [bp - 4]
  02B43D  684D: 8d46ac           lea ax, [bp - 0x54]
  02B440  6850: 16               push ss
  02B441  6851: 50               push ax
  02B442  6852: 9a82011f18       lcall 0x181f, 0x182
  02B447  6857: 83c406           add sp, 6
  02B44A  685A: 8d46ac           lea ax, [bp - 0x54]
  02B44D  685D: 50               push ax
  02B44E  685E: 9a78011f18       lcall 0x181f, 0x178
  02B453  6863: 83c402           add sp, 2
  02B456  6866: ff36e097         push word ptr [0x97e0]
  02B45A  686A: 8d46ac           lea ax, [bp - 0x54]
  02B45D  686D: 50               push ax
  02B45E  686E: 9a6e011f18       lcall 0x181f, 0x16e
  02B463  6873: 83c404           add sp, 4
  02B466  6876: 8d46ac           lea ax, [bp - 0x54]
  02B469  6879: 50               push ax
  02B46A  687A: 9a28011f18       lcall 0x181f, 0x128
  02B46F  687F: 83c402           add sp, 2
  02B472  6882: 837efe00         cmp word ptr [bp - 2], 0
  02B476  6886: 7444             je 0x68cc
  02B478  6888: 8d46ac           lea ax, [bp - 0x54]
  02B47B  688B: 50               push ax
  02B47C  688C: 9a1e011f18       lcall 0x181f, 0x11e
  02B481  6891: 83c402           add sp, 2
  02B484  6894: ff76fe           push word ptr [bp - 2]
  02B487  6897: 8d46ac           lea ax, [bp - 0x54]
  02B48A  689A: 16               push ss
  02B48B  689B: 50               push ax
  02B48C  689C: 9a82011f18       lcall 0x181f, 0x182
  02B491  68A1: 83c406           add sp, 6
  02B494  68A4: 8d46ac           lea ax, [bp - 0x54]
  02B497  68A7: 50               push ax
  02B498  68A8: 9a78011f18       lcall 0x181f, 0x178
  02B49D  68AD: 83c402           add sp, 2
  02B4A0  68B0: ff36dc97         push word ptr [0x97dc]
  02B4A4  68B4: 8d46ac           lea ax, [bp - 0x54]
  02B4A7  68B7: 50               push ax
  02B4A8  68B8: 9a6e011f18       lcall 0x181f, 0x16e
  02B4AD  68BD: 83c404           add sp, 4
  02B4B0  68C0: 8d46ac           lea ax, [bp - 0x54]
  02B4B3  68C3: 50               push ax
  02B4B4  68C4: 9a28011f18       lcall 0x181f, 0x128
  02B4B9  68C9: 83c402           add sp, 2
  02B4BC  68CC: ff76a6           push word ptr [bp - 0x5a]
  02B4BF  68CF: 8d46ac           lea ax, [bp - 0x54]
  02B4C2  68D2: 16               push ss
  02B4C3  68D3: 50               push ax
  02B4C4  68D4: ff7608           push word ptr [bp + 8]
  02B4C7  68D7: ff7606           push word ptr [bp + 6]
  02B4CA  68DA: 9a76011f19       lcall 0x191f, 0x176
  02B4CF  68DF: c9               leave 
  02B4D0  68E0: cb               retf 

; ---- func_02B4D2  size=625  insns=213  prologue=ENTER 0x001E,0  terminal=RETF ----
  02B4D2  68E2: c81e0000         enter 0x1e, 0
  02B4D6  68E6: b80100           mov ax, 1
  02B4D9  68E9: 8946f8           mov word ptr [bp - 8], ax
  02B4DC  68EC: 8946f0           mov word ptr [bp - 0x10], ax
  02B4DF  68EF: c746fa0000       mov word ptr [bp - 6], 0
  02B4E4  68F4: 2bc0             sub ax, ax
  02B4E6  68F6: 8946f6           mov word ptr [bp - 0xa], ax
  02B4E9  68F9: 8946f4           mov word ptr [bp - 0xc], ax
  02B4EC  68FC: 9ae20a1f18       lcall 0x181f, 0xae2
  02B4F1  6901: 8946ee           mov word ptr [bp - 0x12], ax
  02B4F4  6904: 8946ec           mov word ptr [bp - 0x14], ax
  02B4F7  6907: 8b0e9e08         mov cx, word ptr [0x89e]
  02B4FB  690B: 8b16a008         mov dx, word ptr [0x8a0]
  02B4FF  690F: 894ee8           mov word ptr [bp - 0x18], cx
  02B502  6912: 8956ea           mov word ptr [bp - 0x16], dx
  02B505  6915: 3d0e00           cmp ax, 0xe
  02B508  6918: 7e0f             jle 0x6929
  02B50A  691A: 3d1600           cmp ax, 0x16
  02B50D  691D: 7e0a             jle 0x6929
  02B50F  691F: c746f80200       mov word ptr [bp - 8], 2
  02B514  6924: c746ec1000       mov word ptr [bp - 0x14], 0x10
  02B519  6929: c746fe0000       mov word ptr [bp - 2], 0
  02B51E  692E: ff76ea           push word ptr [bp - 0x16]
  02B521  6931: ff76e8           push word ptr [bp - 0x18]
  02B524  6934: 680008           push 0x800
  02B527  6937: 9a3c021f19       lcall 0x191f, 0x23c
  02B52C  693C: 83c406           add sp, 6
  02B52F  693F: 8946f4           mov word ptr [bp - 0xc], ax
  02B532  6942: 8956f6           mov word ptr [bp - 0xa], dx
  02B535  6945: 0bd0             or dx, ax
  02B537  6947: 7503             jne 0x694c
  02B539  6949: e9ee01           jmp 0x6b3a
  02B53C  694C: c45ef4           les bx, ptr [bp - 0xc]
  02B53F  694F: 26804f0a01       or byte ptr es:[bx + 0xa], 1
  02B544  6954: ff36a693         push word ptr [0x93a6]
  02B548  6958: 9a22001f18       lcall 0x181f, 0x22
  02B54D  695D: 83c402           add sp, 2
  02B550  6960: 52               push dx
  02B551  6961: 50               push ax
  02B552  6962: ff76f6           push word ptr [bp - 0xa]
  02B555  6965: ff76f4           push word ptr [bp - 0xc]
  02B558  6968: 9ac6081f19       lcall 0x191f, 0x8c6
  02B55D  696D: 83c408           add sp, 8
  02B560  6970: 837efe00         cmp word ptr [bp - 2], 0
  02B564  6974: 7e1e             jle 0x6994
  02B566  6976: 6a62             push 0x62
  02B568  6978: ff36aa93         push word ptr [0x93aa]
  02B56C  697C: 9a22001f18       lcall 0x181f, 0x22
  02B571  6981: 83c402           add sp, 2
  02B574  6984: 52               push dx
  02B575  6985: 50               push ax
  02B576  6986: ff76f6           push word ptr [bp - 0xa]
  02B579  6989: ff76f4           push word ptr [bp - 0xc]
  02B57C  698C: 9a76011f19       lcall 0x191f, 0x176
  02B581  6991: 83c40a           add sp, 0xa
  02B584  6994: 8b46ec           mov ax, word ptr [bp - 0x14]
  02B587  6997: f76efe           imul word ptr [bp - 2]
  02B58A  699A: 8946e4           mov word ptr [bp - 0x1c], ax
  02B58D  699D: c746e60000       mov word ptr [bp - 0x1a], 0
  02B592  69A2: eb5f             jmp 0x6a03
  02B594  69A4: 0346e4           add ax, word ptr [bp - 0x1c]
  02B597  69A7: 50               push ax
  02B598  69A8: 9a640b1f18       lcall 0x181f, 0xb64
  02B59D  69AD: 83c402           add sp, 2
  02B5A0  69B0: 8946e2           mov word ptr [bp - 0x1e], ax
  02B5A3  69B3: 3dffff           cmp ax, 0xffff
  02B5A6  69B6: 7c48             jl 0x6a00
  02B5A8  69B8: 50               push ax
  02B5A9  69B9: ff76f6           push word ptr [bp - 0xa]
  02B5AC  69BC: ff76f4           push word ptr [bp - 0xc]
  02B5AF  69BF: 0e               push cs
  02B5B0  69C0: e87f14           call 0x7e42
  02B5B3  69C3: 83c406           add sp, 6
  02B5B6  69C6: 8b1e4285         mov bx, word ptr [0x8542]
  02B5BA  69CA: 8a879400         mov al, byte ptr [bx + 0x94]
  02B5BE  69CE: 98               cwde 
  02B5BF  69CF: 3b46e2           cmp ax, word ptr [bp - 0x1e]
  02B5C2  69D2: 752c             jne 0x6a00
  02B5C4  69D4: 40               inc ax
  02B5C5  69D5: 40               inc ax
  02B5C6  69D6: 50               push ax
  02B5C7  69D7: ff76f6           push word ptr [bp - 0xa]
  02B5CA  69DA: ff76f4           push word ptr [bp - 0xc]
  02B5CD  69DD: 9aec081f19       lcall 0x191f, 0x8ec
  02B5D2  69E2: 83c406           add sp, 6
  02B5D5  69E5: 6a01             push 1
  02B5D7  69E7: 8b46e2           mov ax, word ptr [bp - 0x1e]
  02B5DA  69EA: 40               inc ax
  02B5DB  69EB: 40               inc ax
  02B5DC  69EC: 50               push ax
  02B5DD  69ED: ff76f6           push word ptr [bp - 0xa]
  02B5E0  69F0: ff76f4           push word ptr [bp - 0xc]
  02B5E3  69F3: 9a3c031f19       lcall 0x191f, 0x33c
  02B5E8  69F8: 83c408           add sp, 8
  02B5EB  69FB: c746fa0100       mov word ptr [bp - 6], 1
  02B5F0  6A00: ff46e6           inc word ptr [bp - 0x1a]
  02B5F3  6A03: 8b46e6           mov ax, word ptr [bp - 0x1a]
  02B5F6  6A06: 3946ec           cmp word ptr [bp - 0x14], ax
  02B5F9  6A09: 7f99             jg 0x69a4
  02B5FB  6A0B: 8b46f8           mov ax, word ptr [bp - 8]
  02B5FE  6A0E: 48               dec ax
  02B5FF  6A0F: 3b46fe           cmp ax, word ptr [bp - 2]
  02B602  6A12: 7e4b             jle 0x6a5f
  02B604  6A14: 6a63             push 0x63
  02B606  6A16: ff36aa93         push word ptr [0x93aa]
  02B60A  6A1A: 9a22001f18       lcall 0x181f, 0x22
  02B60F  6A1F: 83c402           add sp, 2
  02B612  6A22: 52               push dx
  02B613  6A23: 50               push ax
  02B614  6A24: ff76f6           push word ptr [bp - 0xa]
  02B617  6A27: ff76f4           push word ptr [bp - 0xc]
  02B61A  6A2A: 9a76011f19       lcall 0x191f, 0x176
  02B61F  6A2F: 83c40a           add sp, 0xa
  02B622  6A32: 837efa00         cmp word ptr [bp - 6], 0
  02B626  6A36: 7527             jne 0x6a5f
  02B628  6A38: 6a65             push 0x65
  02B62A  6A3A: ff76f6           push word ptr [bp - 0xa]
  02B62D  6A3D: ff76f4           push word ptr [bp - 0xc]
  02B630  6A40: 9aec081f19       lcall 0x191f, 0x8ec
  02B635  6A45: 83c406           add sp, 6
  02B638  6A48: 6a01             push 1
  02B63A  6A4A: 6a65             push 0x65
  02B63C  6A4C: ff76f6           push word ptr [bp - 0xa]
  02B63F  6A4F: ff76f4           push word ptr [bp - 0xc]
  02B642  6A52: 9a3c031f19       lcall 0x191f, 0x33c
  02B647  6A57: 83c408           add sp, 8
  02B64A  6A5A: c746fa0100       mov word ptr [bp - 6], 1
  02B64F  6A5F: 837efa00         cmp word ptr [bp - 6], 0
  02B653  6A63: 7528             jne 0x6a8d
  02B655  6A65: 837efe00         cmp word ptr [bp - 2], 0
  02B659  6A69: 7422             je 0x6a8d
  02B65B  6A6B: 6a64             push 0x64
  02B65D  6A6D: ff76f6           push word ptr [bp - 0xa]
  02B660  6A70: ff76f4           push word ptr [bp - 0xc]
  02B663  6A73: 9aec081f19       lcall 0x191f, 0x8ec
  02B668  6A78: 83c406           add sp, 6
  02B66B  6A7B: 6a01             push 1
  02B66D  6A7D: 6a64             push 0x64
  02B66F  6A7F: ff76f6           push word ptr [bp - 0xa]
  02B672  6A82: ff76f4           push word ptr [bp - 0xc]
  02B675  6A85: 9a3c031f19       lcall 0x191f, 0x33c
  02B67A  6A8A: 83c408           add sp, 8
  02B67D  6A8D: c706661f0100     mov word ptr [0x1f66], 1
  02B683  6A93: ff76f6           push word ptr [bp - 0xa]
  02B686  6A96: ff76f4           push word ptr [bp - 0xc]
  02B689  6A99: 9a6a011f19       lcall 0x191f, 0x16a
  02B68E  6A9E: 8946fc           mov word ptr [bp - 4], ax
  02B691  6AA1: 8b46f6           mov ax, word ptr [bp - 0xa]
  02B694  6AA4: 0b46f4           or ax, word ptr [bp - 0xc]
  02B697  6AA7: 740b             je 0x6ab4
  02B699  6AA9: ff76f6           push word ptr [bp - 0xa]
  02B69C  6AAC: ff76f4           push word ptr [bp - 0xc]
  02B69F  6AAF: 9aa8011f19       lcall 0x191f, 0x1a8
  02B6A4  6AB4: 2bc0             sub ax, ax
  02B6A6  6AB6: 8946f6           mov word ptr [bp - 0xa], ax
  02B6A9  6AB9: 8946f4           mov word ptr [bp - 0xc], ax
  02B6AC  6ABC: 8b46fc           mov ax, word ptr [bp - 4]
  02B6AF  6ABF: 2d6200           sub ax, 0x62
  02B6B2  6AC2: 7438             je 0x6afc
  02B6B4  6AC4: 48               dec ax
  02B6B5  6AC5: 743b             je 0x6b02
  02B6B7  6AC7: c746f00000       mov word ptr [bp - 0x10], 0
  02B6BC  6ACC: 837efc00         cmp word ptr [bp - 4], 0
  02B6C0  6AD0: 7e5f             jle 0x6b31
  02B6C2  6AD2: 833e681f00       cmp word ptr [0x1f68], 0
  02B6C7  6AD7: 7447             je 0x6b20
  02B6C9  6AD9: 8d46e2           lea ax, [bp - 0x1e]
  02B6CC  6ADC: 50               push ax
  02B6CD  6ADD: 8b4efc           mov cx, word ptr [bp - 4]
  02B6D0  6AE0: 49               dec cx
  02B6D1  6AE1: 49               dec cx
  02B6D2  6AE2: 51               push cx
  02B6D3  6AE3: 9ac20c1f18       lcall 0x181f, 0xcc2
  02B6D8  6AE8: 83c404           add sp, 4
  02B6DB  6AEB: 8946f2           mov word ptr [bp - 0xe], ax
  02B6DE  6AEE: 48               dec ax
  02B6DF  6AEF: 7517             jne 0x6b08
  02B6E1  6AF1: ff76e2           push word ptr [bp - 0x1e]
  02B6E4  6AF4: 9a02091f19       lcall 0x191f, 0x902
  02B6E9  6AF9: eb1b             jmp 0x6b16
  02B6EB  6AFB: 90               nop 
  02B6EC  6AFC: ff4efe           dec word ptr [bp - 2]
  02B6EF  6AFF: eb30             jmp 0x6b31
  02B6F1  6B01: 90               nop 
  02B6F2  6B02: ff46fe           inc word ptr [bp - 2]
  02B6F5  6B05: eb2a             jmp 0x6b31
  02B6F7  6B07: 90               nop 
  02B6F8  6B08: 837ef202         cmp word ptr [bp - 0xe], 2
  02B6FC  6B0C: 750b             jne 0x6b19
  02B6FE  6B0E: ff76e2           push word ptr [bp - 0x1e]
  02B701  6B11: 9a42091f19       lcall 0x191f, 0x942
  02B706  6B16: 83c402           add sp, 2
  02B709  6B19: 0e               push cs
  02B70A  6B1A: e82013           call 0x7e3d
  02B70D  6B1D: e90efe           jmp 0x692e
  02B710  6B20: 8a46fc           mov al, byte ptr [bp - 4]
  02B713  6B23: 2c02             sub al, 2
  02B715  6B25: 8b1e4285         mov bx, word ptr [0x8542]
  02B719  6B29: 88879400         mov byte ptr [bx + 0x94], al
  02B71D  6B2D: 80671c7f         and byte ptr [bx + 0x1c], 0x7f
  02B721  6B31: 837ef000         cmp word ptr [bp - 0x10], 0
  02B725  6B35: 7403             je 0x6b3a
  02B727  6B37: e9f4fd           jmp 0x692e
  02B72A  6B3A: 8b46f6           mov ax, word ptr [bp - 0xa]
  02B72D  6B3D: 0b46f4           or ax, word ptr [bp - 0xc]
  02B730  6B40: 740b             je 0x6b4d
  02B732  6B42: ff76f6           push word ptr [bp - 0xa]
  02B735  6B45: ff76f4           push word ptr [bp - 0xc]
  02B738  6B48: 9aa8011f19       lcall 0x191f, 0x1a8
  02B73D  6B4D: 0e               push cs
  02B73E  6B4E: e85a13           call 0x7eab
  02B741  6B51: c9               leave 
  02B742  6B52: cb               retf 

; ---- func_02B744  size=386  insns=140  prologue=ENTER 0x0012,0  terminal=RETF ----
  02B744  6B54: c8120000         enter 0x12, 0
  02B748  6B58: 57               push di
  02B749  6B59: 56               push si
  02B74A  6B5A: 8d46ee           lea ax, [bp - 0x12]
  02B74D  6B5D: 50               push ax
  02B74E  6B5E: 8b1e4285         mov bx, word ptr [0x8542]
  02B752  6B62: 8a879400         mov al, byte ptr [bx + 0x94]
  02B756  6B66: 98               cwde 
  02B757  6B67: 50               push ax
  02B758  6B68: 9ac20c1f18       lcall 0x181f, 0xcc2
  02B75D  6B6D: 83c404           add sp, 4
  02B760  6B70: 8946f4           mov word ptr [bp - 0xc], ax
  02B763  6B73: 8d46fe           lea ax, [bp - 2]
  02B766  6B76: 50               push ax
  02B767  6B77: 8b1e4285         mov bx, word ptr [0x8542]
  02B76B  6B7B: 8a879400         mov al, byte ptr [bx + 0x94]
  02B76F  6B7F: 98               cwde 
  02B770  6B80: 50               push ax
  02B771  6B81: 9ac40a1f18       lcall 0x181f, 0xac4
  02B776  6B86: 83c404           add sp, 4
  02B779  6B89: 8946f2           mov word ptr [bp - 0xe], ax
  02B77C  6B8C: 8b46fe           mov ax, word ptr [bp - 2]
  02B77F  6B8F: 8b1e4285         mov bx, word ptr [0x8542]
  02B783  6B93: 2b87b600         sub ax, word ptr [bx + 0xb6]
  02B787  6B97: 7902             jns 0x6b9b
  02B789  6B99: 2bc0             sub ax, ax
  02B78B  6B9B: 8946f0           mov word ptr [bp - 0x10], ax
  02B78E  6B9E: 837ef400         cmp word ptr [bp - 0xc], 0
  02B792  6BA2: 7503             jne 0x6ba7
  02B794  6BA4: e92b01           jmp 0x6cd2
  02B797  6BA7: 8b46f2           mov ax, word ptr [bp - 0xe]
  02B79A  6BAA: 2b879200         sub ax, word ptr [bx + 0x92]
  02B79E  6BAE: 7902             jns 0x6bb2
  02B7A0  6BB0: 2bc0             sub ax, ax
  02B7A2  6BB2: 8946fa           mov word ptr [bp - 6], ax
  02B7A5  6BB5: 0bc0             or ax, ax
  02B7A7  6BB7: 7f09             jg 0x6bc2
  02B7A9  6BB9: 837ef000         cmp word ptr [bp - 0x10], 0
  02B7AD  6BBD: 7503             jne 0x6bc2
  02B7AF  6BBF: e91001           jmp 0x6cd2
  02B7B2  6BC2: 8bc8             mov cx, ax
  02B7B4  6BC4: d1e0             shl ax, 1
  02B7B6  6BC6: 03c1             add ax, cx
  02B7B8  6BC8: c1e002           shl ax, 2
  02B7BB  6BCB: 03c1             add ax, cx
  02B7BD  6BCD: 8946f8           mov word ptr [bp - 8], ax
  02B7C0  6BD0: 837ef000         cmp word ptr [bp - 0x10], 0
  02B7C4  6BD4: 741a             je 0x6bf0
  02B7C6  6BD6: 8a4f1a           mov cl, byte ptr [bx + 0x1a]
  02B7C9  6BD9: 2aed             sub ch, ch
  02B7CB  6BDB: 69d93c01         imul bx, cx, 0x13c
  02B7CF  6BDF: 8a876288         mov al, byte ptr [bx - 0x779e]
  02B7D3  6BE3: 98               cwde 
  02B7D4  6BE4: 050400           add ax, 4
  02B7D7  6BE7: f76ef0           imul word ptr [bp - 0x10]
  02B7DA  6BEA: 0346f8           add ax, word ptr [bp - 8]
  02B7DD  6BED: 8946f8           mov word ptr [bp - 8], ax
  02B7E0  6BF0: 8b1e4285         mov bx, word ptr [0x8542]
  02B7E4  6BF4: 83bf920000       cmp word ptr [bx + 0x92], 0
  02B7E9  6BF9: 7503             jne 0x6bfe
  02B7EB  6BFB: d166f8           shl word ptr [bp - 8], 1
  02B7EE  6BFE: 8a879400         mov al, byte ptr [bx + 0x94]
  02B7F2  6C02: 98               cwde 
  02B7F3  6C03: 50               push ax
  02B7F4  6C04: 9a4e0d1f18       lcall 0x181f, 0xd4e
  02B7F9  6C09: 83c402           add sp, 2
  02B7FC  6C0C: 52               push dx
  02B7FD  6C0D: 50               push ax
  02B7FE  6C0E: 1e               push ds
  02B7FF  6C0F: 68d29c           push 0x9cd2
  02B802  6C12: 9a7e111d0d       lcall 0xd1d, 0x117e
  02B807  6C17: 83c408           add sp, 8
  02B80A  6C1A: 8b46f8           mov ax, word ptr [bp - 8]
  02B80D  6C1D: 99               cdq 
  02B80E  6C1E: a3b09c           mov word ptr [0x9cb0], ax
  02B811  6C21: 8916b29c         mov word ptr [0x9cb2], dx
  02B815  6C25: 8b1e4285         mov bx, word ptr [0x8542]
  02B819  6C29: 8a4f1a           mov cl, byte ptr [bx + 0x1a]
  02B81C  6C2C: 2aed             sub ch, ch
  02B81E  6C2E: 51               push cx
  02B81F  6C2F: 8bf0             mov si, ax
  02B821  6C31: 8bfa             mov di, dx
  02B823  6C33: 9a920a1f18       lcall 0x181f, 0xa92
  02B828  6C38: 83c402           add sp, 2
  02B82B  6C3B: a3b49c           mov word ptr [0x9cb4], ax
  02B82E  6C3E: 8916b69c         mov word ptr [0x9cb6], dx
  02B832  6C42: 8b1e4285         mov bx, word ptr [0x8542]
  02B836  6C46: 8a471a           mov al, byte ptr [bx + 0x1a]
  02B839  6C49: 2ae4             sub ah, ah
  02B83B  6C4B: 50               push ax
  02B83C  6C4C: 9a920a1f18       lcall 0x181f, 0xa92
  02B841  6C51: 83c402           add sp, 2
  02B844  6C54: 3bd7             cmp dx, di
  02B846  6C56: 7c18             jl 0x6c70
  02B848  6C58: 7f04             jg 0x6c5e
  02B84A  6C5A: 3bc6             cmp ax, si
  02B84C  6C5C: 7212             jb 0x6c70
  02B84E  6C5E: 6a05             push 5
  02B850  6C60: 68220d           push 0xd22
  02B853  6C63: 9a52061f18       lcall 0x181f, 0x652
  02B858  6C68: 83c404           add sp, 4
  02B85B  6C6B: 8946fc           mov word ptr [bp - 4], ax
  02B85E  6C6E: eb12             jmp 0x6c82
  02B860  6C70: 6a05             push 5
  02B862  6C72: 68290d           push 0xd29
  02B865  6C75: 9a52061f18       lcall 0x181f, 0x652
  02B86A  6C7A: 83c404           add sp, 4
  02B86D  6C7D: c746fc0000       mov word ptr [bp - 4], 0
  02B872  6C82: 837efc02         cmp word ptr [bp - 4], 2
  02B876  6C86: 754a             jne 0x6cd2
  02B878  6C88: 8b46f2           mov ax, word ptr [bp - 0xe]
  02B87B  6C8B: 8b1e4285         mov bx, word ptr [0x8542]
  02B87F  6C8F: 2b879200         sub ax, word ptr [bx + 0x92]
  02B883  6C93: 8946f6           mov word ptr [bp - 0xa], ax
  02B886  6C96: 0bc0             or ax, ax
  02B888  6C98: 7e04             jle 0x6c9e
  02B88A  6C9A: 01879800         add word ptr [bx + 0x98], ax
  02B88E  6C9E: 8b46f2           mov ax, word ptr [bp - 0xe]
  02B891  6CA1: 8b1e4285         mov bx, word ptr [0x8542]
  02B895  6CA5: 89879200         mov word ptr [bx + 0x92], ax
  02B899  6CA9: 8b46f8           mov ax, word ptr [bp - 8]
  02B89C  6CAC: 99               cdq 
  02B89D  6CAD: 52               push dx
  02B89E  6CAE: 50               push ax
  02B89F  6CAF: 8a471a           mov al, byte ptr [bx + 0x1a]
  02B8A2  6CB2: 2ae4             sub ah, ah
  02B8A4  6CB4: 50               push ax
  02B8A5  6CB5: 9af60a1f18       lcall 0x181f, 0xaf6
  02B8AA  6CBA: 83c406           add sp, 6
  02B8AD  6CBD: 837efe00         cmp word ptr [bp - 2], 0
  02B8B1  6CC1: 740b             je 0x6cce
  02B8B3  6CC3: 8b46f0           mov ax, word ptr [bp - 0x10]
  02B8B6  6CC6: 8b1e4285         mov bx, word ptr [0x8542]
  02B8BA  6CCA: 0187b600         add word ptr [bx + 0xb6], ax
  02B8BE  6CCE: 0e               push cs
  02B8BF  6CCF: e8d911           call 0x7eab
  02B8C2  6CD2: 5e               pop si
  02B8C3  6CD3: 5f               pop di
  02B8C4  6CD4: c9               leave 
  02B8C5  6CD5: cb               retf 

; ---- func_02B8C6  size=277  insns=115  prologue=ENTER 0x000A,0  terminal=RETF ----
  02B8C6  6CD6: c80a0000         enter 0xa, 0
  02B8CA  6CDA: a14203           mov ax, word ptr [0x342]
  02B8CD  6CDD: 8946f6           mov word ptr [bp - 0xa], ax
  02B8D0  6CE0: c7064203ffff     mov word ptr [0x342], 0xffff
  02B8D6  6CE6: 8b1e4285         mov bx, word ptr [0x8542]
  02B8DA  6CEA: 80bf940000       cmp byte ptr [bx + 0x94], 0
  02B8DF  6CEF: 7c39             jl 0x6d2a
  02B8E1  6CF1: 8d46f8           lea ax, [bp - 8]
  02B8E4  6CF4: 50               push ax
  02B8E5  6CF5: 8d4efa           lea cx, [bp - 6]
  02B8E8  6CF8: 51               push cx
  02B8E9  6CF9: ff36a293         push word ptr [0x93a2]
  02B8ED  6CFD: 0e               push cs
  02B8EE  6CFE: e8ce10           call 0x7dcf
  02B8F1  6D01: 83c406           add sp, 6
  02B8F4  6D04: ff76f8           push word ptr [bp - 8]
  02B8F7  6D07: ff76fa           push word ptr [bp - 6]
  02B8FA  6D0A: b88a00           mov ax, 0x8a
  02B8FD  6D0D: 8946fc           mov word ptr [bp - 4], ax
  02B900  6D10: 50               push ax
  02B901  6D11: b8d800           mov ax, 0xd8
  02B904  6D14: 8946fe           mov word ptr [bp - 2], ax
  02B907  6D17: 50               push ax
  02B908  6D18: 9aca031f18       lcall 0x181f, 0x3ca
  02B90D  6D1D: 83c408           add sp, 8
  02B910  6D20: 0bc0             or ax, ax
  02B912  6D22: 7406             je 0x6d2a
  02B914  6D24: c70642030000     mov word ptr [0x342], 0
  02B91A  6D2A: 8d46f8           lea ax, [bp - 8]
  02B91D  6D2D: 50               push ax
  02B91E  6D2E: 8d4efa           lea cx, [bp - 6]
  02B921  6D31: 51               push cx
  02B922  6D32: ff36a493         push word ptr [0x93a4]
  02B926  6D36: 0e               push cs
  02B927  6D37: e89510           call 0x7dcf
  02B92A  6D3A: 83c406           add sp, 6
  02B92D  6D3D: ff76f8           push word ptr [bp - 8]
  02B930  6D40: ff76fa           push word ptr [bp - 6]
  02B933  6D43: b88a00           mov ax, 0x8a
  02B936  6D46: 8946fc           mov word ptr [bp - 4], ax
  02B939  6D49: 50               push ax
  02B93A  6D4A: b80e01           mov ax, 0x10e
  02B93D  6D4D: 8946fe           mov word ptr [bp - 2], ax
  02B940  6D50: 50               push ax
  02B941  6D51: 9aca031f18       lcall 0x181f, 0x3ca
  02B946  6D56: 83c408           add sp, 8
  02B949  6D59: 0bc0             or ax, ax
  02B94B  6D5B: 7406             je 0x6d63
  02B94D  6D5D: c70642030100     mov word ptr [0x342], 1
  02B953  6D63: 8b46f6           mov ax, word ptr [bp - 0xa]
  02B956  6D66: 39064203         cmp word ptr [0x342], ax
  02B95A  6D6A: 7507             jne 0x6d73
  02B95C  6D6C: 833ef00700       cmp word ptr [0x7f0], 0
  02B961  6D71: 7418             je 0x6d8b
  02B963  6D73: 0e               push cs
  02B964  6D74: e8fd10           call 0x7e74
  02B967  6D77: 688200           push 0x82
  02B96A  6D7A: 6a5b             push 0x5b
  02B96C  6D7C: 6a30             push 0x30
  02B96E  6D7E: b8d300           mov ax, 0xd3
  02B971  6D81: ba8200           mov dx, 0x82
  02B974  6D84: 8bd8             mov bx, ax
  02B976  6D86: 9ae2001f18       lcall 0x181f, 0xe2
  02B97B  6D8B: 833ef40700       cmp word ptr [0x7f4], 0
  02B980  6D90: 7419             je 0x6dab
  02B982  6D92: a14203           mov ax, word ptr [0x342]
  02B985  6D95: eb0d             jmp 0x6da4
  02B987  6D97: 90               nop 
  02B988  6D98: 0e               push cs
  02B989  6D99: e89c10           call 0x7e38
  02B98C  6D9C: c9               leave 
  02B98D  6D9D: cb               retf 
  02B98E  6D9E: 0e               push cs
  02B98F  6D9F: e8e110           call 0x7e83
  02B992  6DA2: c9               leave 
  02B993  6DA3: cb               retf 
  02B994  6DA4: 0bc0             or ax, ax
  02B996  6DA6: 74f0             je 0x6d98
  02B998  6DA8: 48               dec ax
  02B999  6DA9: 74f3             je 0x6d9e
  02B99B  6DAB: c9               leave 
  02B99C  6DAC: cb               retf 
  02B99D  6DAD: 90               nop 
  02B99E  6DAE: 833ef40700       cmp word ptr [0x7f4], 0
  02B9A3  6DB3: 7410             je 0x6dc5
  02B9A5  6DB5: 803e360301       cmp byte ptr [0x336], 1
  02B9AA  6DBA: 1ac0             sbb al, al
  02B9AC  6DBC: f6d8             neg al
  02B9AE  6DBE: a23603           mov byte ptr [0x336], al
  02B9B1  6DC1: 0e               push cs
  02B9B2  6DC2: e8c310           call 0x7e88
  02B9B5  6DC5: cb               retf 
  02B9B6  6DC6: a03703           mov al, byte ptr [0x337]
  02B9B9  6DC9: 2ae4             sub ah, ah
  02B9BB  6DCB: eb13             jmp 0x6de0
  02B9BD  6DCD: 90               nop 
  02B9BE  6DCE: 0e               push cs
  02B9BF  6DCF: e8d410           call 0x7ea6
  02B9C2  6DD2: cb               retf 
  02B9C3  6DD3: 90               nop 
  02B9C4  6DD4: 0e               push cs
  02B9C5  6DD5: e8d40f           call 0x7dac
  02B9C8  6DD8: cb               retf 
  02B9C9  6DD9: 90               nop 
  02B9CA  6DDA: 0e               push cs
  02B9CB  6DDB: e8a60f           call 0x7d84
  02B9CE  6DDE: cb               retf 
  02B9CF  6DDF: 90               nop 
  02B9D0  6DE0: 0bc0             or ax, ax
  02B9D2  6DE2: 74f6             je 0x6dda
  02B9D4  6DE4: 48               dec ax
  02B9D5  6DE5: 74ed             je 0x6dd4
  02B9D7  6DE7: 48               dec ax
  02B9D8  6DE8: 74e4             je 0x6dce
  02B9DA  6DEA: cb               retf 

; ---- func_02B9DC  size=429  insns=158  prologue=ENTER 0x0006,0  terminal=RETF ----
  02B9DC  6DEC: c8060000         enter 6, 0
  02B9E0  6DF0: 56               push si
  02B9E1  6DF1: 833e548d07       cmp word ptr [0x8d54], 7
  02B9E6  6DF6: 753c             jne 0x6e34
  02B9E8  6DF8: 833ef40700       cmp word ptr [0x7f4], 0
  02B9ED  6DFD: 7503             jne 0x6e02
  02B9EF  6DFF: e93601           jmp 0x6f38
  02B9F2  6E02: 803e8ca800       cmp byte ptr [0xa88c], 0
  02B9F7  6E07: 7403             je 0x6e0c
  02B9F9  6E09: e92c01           jmp 0x6f38
  02B9FC  6E0C: ff363e03         push word ptr [0x33e]
  02BA00  6E10: 9a320b1f18       lcall 0x181f, 0xb32
  02BA05  6E15: 83c402           add sp, 2
  02BA08  6E18: 8946fc           mov word ptr [bp - 4], ax
  02BA0B  6E1B: 9aa2031f18       lcall 0x181f, 0x3a2
  02BA10  6E20: 50               push ax
  02BA11  6E21: a08da8           mov al, byte ptr [0xa88d]
  02BA14  6E24: 2ae4             sub ah, ah
  02BA16  6E26: 50               push ax
  02BA17  6E27: ff76fc           push word ptr [bp - 4]
  02BA1A  6E2A: 0e               push cs
  02BA1B  6E2B: e8ab0f           call 0x7dd9
  02BA1E  6E2E: 83c406           add sp, 6
  02BA21  6E31: 5e               pop si
  02BA22  6E32: c9               leave 
  02BA23  6E33: cb               retf 
  02BA24  6E34: 683101           push 0x131
  02BA27  6E37: 6a00             push 0
  02BA29  6E39: ff36e807         push word ptr [0x7e8]
  02BA2D  6E3D: 9a5c031f18       lcall 0x181f, 0x35c
  02BA32  6E42: 83c406           add sp, 6
  02BA35  6E45: b91300           mov cx, 0x13
  02BA38  6E48: 99               cdq 
  02BA39  6E49: f7f9             idiv cx
  02BA3B  6E4B: 8946fa           mov word ptr [bp - 6], ax
  02BA3E  6E4E: 3d1000           cmp ax, 0x10
  02BA41  6E51: 7c03             jl 0x6e56
  02BA43  6E53: e9e200           jmp 0x6f38
  02BA46  6E56: 833ef60700       cmp word ptr [0x7f6], 0
  02BA4B  6E5B: 753f             jne 0x6e9c
  02BA4D  6E5D: c6069d0b01       mov byte ptr [0xb9d], 1
  02BA52  6E62: 8a46fa           mov al, byte ptr [bp - 6]
  02BA55  6E65: 38069c0b         cmp byte ptr [0xb9c], al
  02BA59  6E69: 7503             jne 0x6e6e
  02BA5B  6E6B: e9ca00           jmp 0x6f38
  02BA5E  6E6E: a29c0b           mov byte ptr [0xb9c], al
  02BA61  6E71: 6a00             push 0
  02BA63  6E73: 0e               push cs
  02BA64  6E74: e8b20f           call 0x7e29
  02BA67  6E77: 83c402           add sp, 2
  02BA6A  6E7A: ff76fa           push word ptr [bp - 6]
  02BA6D  6E7D: 0e               push cs
  02BA6E  6E7E: e81c0f           call 0x7d9d
  02BA71  6E81: 83c402           add sp, 2
  02BA74  6E84: 68b300           push 0xb3
  02BA77  6E87: 683101           push 0x131
  02BA7A  6E8A: 6a15             push 0x15
  02BA7C  6E8C: 2bc0             sub ax, ax
  02BA7E  6E8E: bab300           mov dx, 0xb3
  02BA81  6E91: 2bdb             sub bx, bx
  02BA83  6E93: 9ae2001f18       lcall 0x181f, 0xe2
  02BA88  6E98: 5e               pop si
  02BA89  6E99: c9               leave 
  02BA8A  6E9A: cb               retf 
  02BA8B  6E9B: 90               nop 
  02BA8C  6E9C: 833e2e0304       cmp word ptr [0x32e], 4
  02BA91  6EA1: 7509             jne 0x6eac
  02BA93  6EA3: 8a46fa           mov al, byte ptr [bp - 6]
  02BA96  6EA6: 38063a03         cmp byte ptr [0x33a], al
  02BA9A  6EAA: 7410             je 0x6ebc
  02BA9C  6EAC: c7062e030400     mov word ptr [0x32e], 4
  02BAA2  6EB2: 8a46fa           mov al, byte ptr [bp - 6]
  02BAA5  6EB5: a23a03           mov byte ptr [0x33a], al
  02BAA8  6EB8: 0e               push cs
  02BAA9  6EB9: e8ef0f           call 0x7eab
  02BAAC  6EBC: 833ee40700       cmp word ptr [0x7e4], 0
  02BAB1  6EC1: 7419             je 0x6edc
  02BAB3  6EC3: 833ef40700       cmp word ptr [0x7f4], 0
  02BAB8  6EC8: 746e             je 0x6f38
  02BABA  6ECA: ff76fa           push word ptr [bp - 6]
  02BABD  6ECD: 9a34091f19       lcall 0x191f, 0x934
  02BAC2  6ED2: 83c402           add sp, 2
  02BAC5  6ED5: 0e               push cs
  02BAC6  6ED6: e8640f           call 0x7e3d
  02BAC9  6ED9: 5e               pop si
  02BACA  6EDA: c9               leave 
  02BACB  6EDB: cb               retf 
  02BACC  6EDC: 6a00             push 0
  02BACE  6EDE: 6a00             push 0
  02BAD0  6EE0: ff76fa           push word ptr [bp - 6]
  02BAD3  6EE3: ff363e03         push word ptr [0x33e]
  02BAD7  6EE7: 9a320b1f18       lcall 0x181f, 0xb32
  02BADC  6EEC: 83c402           add sp, 2
  02BADF  6EEF: 50               push ax
  02BAE0  6EF0: 0e               push cs
  02BAE1  6EF1: e8e40f           call 0x7ed8
  02BAE4  6EF4: 83c408           add sp, 8
  02BAE7  6EF7: 0bc0             or ax, ax
  02BAE9  6EF9: 753d             jne 0x6f38
  02BAEB  6EFB: 6a01             push 1
  02BAED  6EFD: 50               push ax
  02BAEE  6EFE: ff76fa           push word ptr [bp - 6]
  02BAF1  6F01: 0e               push cs
  02BAF2  6F02: e80010           call 0x7f05
  02BAF5  6F05: 83c406           add sp, 6
  02BAF8  6F08: c6068ca801       mov byte ptr [0xa88c], 1
  02BAFD  6F0D: 8a46fa           mov al, byte ptr [bp - 6]
  02BB00  6F10: a28da8           mov byte ptr [0xa88d], al
  02BB03  6F13: 8b76fa           mov si, word ptr [bp - 6]
  02BB06  6F16: d1e6             shl si, 1
  02BB08  6F18: 8b1e4285         mov bx, word ptr [0x8542]
  02BB0C  6F1C: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  02BB10  6F20: 3d6400           cmp ax, 0x64
  02BB13  6F23: 7e03             jle 0x6f28
  02BB15  6F25: b86400           mov ax, 0x64
  02BB18  6F28: a28ea8           mov byte ptr [0xa88e], al
  02BB1B  6F2B: 2ae4             sub ah, ah
  02BB1D  6F2D: 50               push ax
  02BB1E  6F2E: ff76fa           push word ptr [bp - 6]
  02BB21  6F31: 0e               push cs
  02BB22  6F32: e8a90e           call 0x7dde
  02BB25  6F35: 83c404           add sp, 4
  02BB28  6F38: 5e               pop si
  02BB29  6F39: c9               leave 
  02BB2A  6F3A: cb               retf 
  02BB2B  6F3B: 90               nop 
  02BB2C  6F3C: 833e548d0a       cmp word ptr [0x8d54], 0xa
  02BB31  6F41: 7540             jne 0x6f83
  02BB33  6F43: 833ef40700       cmp word ptr [0x7f4], 0
  02BB38  6F48: 7439             je 0x6f83
  02BB3A  6F4A: 6a17             push 0x17
  02BB3C  6F4C: 8b164285         mov dx, word ptr [0x8542]
  02BB40  6F50: 42               inc dx
  02BB41  6F51: 42               inc dx
  02BB42  6F52: 8d1e7c08         lea bx, [0x87c]
  02BB46  6F56: 8d06300d         lea ax, [0xd30]
  02BB4A  6F5A: 9a20011f19       lcall 0x191f, 0x120
  02BB4F  6F5F: 682098           push 0x9820
  02BB52  6F62: 9a42081d0d       lcall 0xd1d, 0x842
  02BB57  6F67: 83c402           add sp, 2
  02BB5A  6F6A: 0bc0             or ax, ax
  02BB5C  6F6C: 7415             je 0x6f83
  02BB5E  6F6E: 682098           push 0x9820
  02BB61  6F71: a14285           mov ax, word ptr [0x8542]
  02BB64  6F74: 40               inc ax
  02BB65  6F75: 40               inc ax
  02BB66  6F76: 50               push ax
  02BB67  6F77: 9ae4071d0d       lcall 0xd1d, 0x7e4
  02BB6C  6F7C: 83c404           add sp, 4
  02BB6F  6F7F: 0e               push cs
  02BB70  6F80: e8280f           call 0x7eab
  02BB73  6F83: cb               retf 
  02BB74  6F84: 833e548d09       cmp word ptr [0x8d54], 9
  02BB79  6F89: 750d             jne 0x6f98
  02BB7B  6F8B: 833ef40700       cmp word ptr [0x7f4], 0
  02BB80  6F90: 7406             je 0x6f98
  02BB82  6F92: c70646030000     mov word ptr [0x346], 0
  02BB88  6F98: cb               retf 

; ---- func_02BB8A  size=232  insns=100  prologue=ENTER 0x0002,0  terminal=RETF ----
  02BB8A  6F9A: c8020000         enter 2, 0
  02BB8E  6F9E: 833eec0700       cmp word ptr [0x7ec], 0
  02BB93  6FA3: 7507             jne 0x6fac
  02BB95  6FA5: 833ef60700       cmp word ptr [0x7f6], 0
  02BB9A  6FAA: 750a             jne 0x6fb6
  02BB9C  6FAC: 0e               push cs
  02BB9D  6FAD: e8ab0e           call 0x7e5b
  02BBA0  6FB0: a3548d           mov word ptr [0x8d54], ax
  02BBA3  6FB3: a3568d           mov word ptr [0x8d56], ax
  02BBA6  6FB6: a1548d           mov ax, word ptr [0x8d54]
  02BBA9  6FB9: 8946fe           mov word ptr [bp - 2], ax
  02BBAC  6FBC: 3d0600           cmp ax, 6
  02BBAF  6FBF: 7405             je 0x6fc6
  02BBB1  6FC1: 3d0700           cmp ax, 7
  02BBB4  6FC4: 7528             jne 0x6fee
  02BBB6  6FC6: 0e               push cs
  02BBB7  6FC7: e8910e           call 0x7e5b
  02BBBA  6FCA: 8946fe           mov word ptr [bp - 2], ax
  02BBBD  6FCD: 3d0800           cmp ax, 8
  02BBC0  6FD0: 7432             je 0x7004
  02BBC2  6FD2: 7715             ja 0x6fe9
  02BBC4  6FD4: 0ac0             or al, al
  02BBC6  6FD6: 7c11             jl 0x6fe9
  02BBC8  6FD8: 2c02             sub al, 2
  02BBCA  6FDA: 7e06             jle 0x6fe2
  02BBCC  6FDC: 2c03             sub al, 3
  02BBCE  6FDE: 7424             je 0x7004
  02BBD0  6FE0: eb07             jmp 0x6fe9
  02BBD2  6FE2: 833e548d06       cmp word ptr [0x8d54], 6
  02BBD7  6FE7: 7405             je 0x6fee
  02BBD9  6FE9: c746fe1400       mov word ptr [bp - 2], 0x14
  02BBDE  6FEE: 833ef60700       cmp word ptr [0x7f6], 0
  02BBE3  6FF3: 7517             jne 0x700c
  02BBE5  6FF5: 837efe02         cmp word ptr [bp - 2], 2
  02BBE9  6FF9: 7517             jne 0x7012
  02BBEB  6FFB: f606845302       test byte ptr [0x5384], 2
  02BBF0  7000: 740a             je 0x700c
  02BBF2  7002: c9               leave 
  02BBF3  7003: cb               retf 
  02BBF4  7004: 833e548d07       cmp word ptr [0x8d54], 7
  02BBF9  7009: ebdc             jmp 0x6fe7
  02BBFB  700B: 90               nop 
  02BBFC  700C: 8b46fe           mov ax, word ptr [bp - 2]
  02BBFF  700F: eb4b             jmp 0x705c
  02BC01  7011: 90               nop 
  02BC02  7012: 837efe05         cmp word ptr [bp - 2], 5
  02BC06  7016: 7406             je 0x701e
  02BC08  7018: 837efe01         cmp word ptr [bp - 2], 1
  02BC0C  701C: 7562             jne 0x7080
  02BC0E  701E: f606845301       test byte ptr [0x5384], 1
  02BC13  7023: ebdb             jmp 0x7000
  02BC15  7025: 90               nop 
  02BC16  7026: 0e               push cs
  02BC17  7027: e8f50d           call 0x7e1f
  02BC1A  702A: eb54             jmp 0x7080
  02BC1C  702C: 0e               push cs
  02BC1D  702D: e8850e           call 0x7eb5
  02BC20  7030: eb4e             jmp 0x7080
  02BC22  7032: 0e               push cs
  02BC23  7033: e8ac0e           call 0x7ee2
  02BC26  7036: eb48             jmp 0x7080
  02BC28  7038: 0e               push cs
  02BC29  7039: e8d90d           call 0x7e15
  02BC2C  703C: eb42             jmp 0x7080
  02BC2E  703E: 0e               push cs
  02BC2F  703F: e8880d           call 0x7dca
  02BC32  7042: eb3c             jmp 0x7080
  02BC34  7044: 0e               push cs
  02BC35  7045: e8500d           call 0x7d98
  02BC38  7048: c9               leave 
  02BC39  7049: cb               retf 
  02BC3A  704A: 0e               push cs
  02BC3B  704B: e8860d           call 0x7dd4
  02BC3E  704E: c9               leave 
  02BC3F  704F: cb               retf 
  02BC40  7050: 0e               push cs
  02BC41  7051: e8f80d           call 0x7e4c
  02BC44  7054: c9               leave 
  02BC45  7055: cb               retf 
  02BC46  7056: 0e               push cs
  02BC47  7057: e8150e           call 0x7e6f
  02BC4A  705A: c9               leave 
  02BC4B  705B: cb               retf 
  02BC4C  705C: 3d0a00           cmp ax, 0xa
  02BC4F  705F: 771f             ja 0x7080
  02BC51  7061: d1e0             shl ax, 1
  02BC53  7063: 93               xchg bx, ax
  02BC54  7064: 2effa75a63       jmp word ptr cs:[bx + 0x635a]
  02BC59  7069: 90               nop 
  02BC5A  706A: 16               push ss
  02BC5B  706B: 631c             arpl word ptr [si], bx
  02BC5D  706D: 6322             arpl word ptr [bp + si], sp
  02BC5F  706F: 6328             arpl word ptr [bx + si], bp
  02BC61  7071: 6334             arpl word ptr [si], si
  02BC63  7073: 632e6370         arpl word ptr [0x7063], bp
  02BC67  7077: 637063           arpl word ptr [bx + si + 0x63], si
  02BC6A  707A: 3a6346           cmp ah, byte ptr [bp + di + 0x46]
  02BC6D  707D: 634063           arpl word ptr [bx + si + 0x63], ax
  02BC70  7080: c9               leave 
  02BC71  7081: cb               retf 

; ---- func_02BC72  size=2259  insns=848  prologue=ENTER 0x0018,0  terminal=RETF ----
  02BC72  7082: c8180000         enter 0x18, 0
  02BC76  7086: 56               push si
  02BC77  7087: c746f20100       mov word ptr [bp - 0xe], 1
  02BC7C  708C: 8b4606           mov ax, word ptr [bp + 6]
  02BC7F  708F: 3d4e00           cmp ax, 0x4e
  02BC82  7092: 7503             jne 0x7097
  02BC84  7094: e9f502           jmp 0x738c
  02BC87  7097: 7e03             jle 0x709c
  02BC89  7099: e93004           jmp 0x74cc
  02BC8C  709C: 3d4d00           cmp ax, 0x4d
  02BC8F  709F: 7503             jne 0x70a4
  02BC91  70A1: e9c002           jmp 0x7364
  02BC94  70A4: 7603             jbe 0x70a9
  02BC96  70A6: e94704           jmp 0x74f0
  02BC99  70A9: 3c2d             cmp al, 0x2d
  02BC9B  70AB: 7503             jne 0x70b0
  02BC9D  70AD: e90e03           jmp 0x73be
  02BCA0  70B0: 7e03             jle 0x70b5
  02BCA2  70B2: e9cf03           jmp 0x7484
  02BCA5  70B5: 2c09             sub al, 9
  02BCA7  70B7: 7503             jne 0x70bc
  02BCA9  70B9: e93e02           jmp 0x72fa
  02BCAC  70BC: 2c12             sub al, 0x12
  02BCAE  70BE: 740a             je 0x70ca
  02BCB0  70C0: 2c10             sub al, 0x10
  02BCB2  70C2: 7503             jne 0x70c7
  02BCB4  70C4: e92903           jmp 0x73f0
  02BCB7  70C7: e92604           jmp 0x74f0
  02BCBA  70CA: 2bc0             sub ax, ax
  02BCBC  70CC: a34603           mov word ptr [0x346], ax
  02BCBF  70CF: 8946f2           mov word ptr [bp - 0xe], ax
  02BCC2  70D2: f606835320       test byte ptr [0x5383], 0x20
  02BCC7  70D7: 7503             jne 0x70dc
  02BCC9  70D9: e98504           jmp 0x7561
  02BCCC  70DC: 8b4606           mov ax, word ptr [bp + 6]
  02BCCF  70DF: 3d7400           cmp ax, 0x74
  02BCD2  70E2: 7503             jne 0x70e7
  02BCD4  70E4: e94904           jmp 0x7530
  02BCD7  70E7: 7603             jbe 0x70ec
  02BCD9  70E9: e97504           jmp 0x7561
  02BCDC  70EC: 3c53             cmp al, 0x53
  02BCDE  70EE: 7503             jne 0x70f3
  02BCE0  70F0: e99f04           jmp 0x7592
  02BCE3  70F3: 7e03             jle 0x70f8
  02BCE5  70F5: e97805           jmp 0x7670
  02BCE8  70F8: 2c20             sub al, 0x20
  02BCEA  70FA: 7503             jne 0x70ff
  02BCEC  70FC: e96105           jmp 0x7660
  02BCEF  70FF: fec8             dec al
  02BCF1  7101: 7503             jne 0x7106
  02BCF3  7103: e9f004           jmp 0x75f6
  02BCF6  7106: 2c03             sub al, 3
  02BCF8  7108: 7503             jne 0x710d
  02BCFA  710A: e99904           jmp 0x75a6
  02BCFD  710D: fec8             dec al
  02BCFF  710F: 7503             jne 0x7114
  02BD01  7111: e9b004           jmp 0x75c4
  02BD04  7114: e94a04           jmp 0x7561
  02BD07  7117: 90               nop 
  02BD08  7118: a12e03           mov ax, word ptr [0x32e]
  02BD0B  711B: 0bc0             or ax, ax
  02BD0D  711D: 7417             je 0x7136
  02BD0F  711F: 48               dec ax
  02BD10  7120: 7462             je 0x7184
  02BD12  7122: 48               dec ax
  02BD13  7123: 7503             jne 0x7128
  02BD15  7125: e98000           jmp 0x71a8
  02BD18  7128: 48               dec ax
  02BD19  7129: 7503             jne 0x712e
  02BD1B  712B: e99000           jmp 0x71be
  02BD1E  712E: 48               dec ax
  02BD1F  712F: 7503             jne 0x7134
  02BD21  7131: e9b200           jmp 0x71e6
  02BD24  7134: eb46             jmp 0x717c
  02BD26  7136: a13203           mov ax, word ptr [0x332]
  02BD29  7139: 8bd8             mov bx, ax
  02BD2B  713B: 8b363003         mov si, word ptr [0x330]
  02BD2F  713F: 8976f8           mov word ptr [bp - 8], si
  02BD32  7142: 8bce             mov cx, si
  02BD34  7144: c1e602           shl si, 2
  02BD37  7147: 03f1             add si, cx
  02BD39  7149: 80b8f08d10       cmp byte ptr [bx + si - 0x7210], 0x10
  02BD3E  714E: 742c             je 0x717c
  02BD40  7150: 8b364285         mov si, word ptr [0x8542]
  02BD44  7154: 8a0c             mov cl, byte ptr [si]
  02BD46  7156: 2aed             sub ch, ch
  02BD48  7158: 034ef8           add cx, word ptr [bp - 8]
  02BD4B  715B: 49               dec cx
  02BD4C  715C: 49               dec cx
  02BD4D  715D: 894ef8           mov word ptr [bp - 8], cx
  02BD50  7160: 8a5401           mov dl, byte ptr [si + 1]
  02BD53  7163: 2af6             sub dh, dh
  02BD55  7165: 03c2             add ax, dx
  02BD57  7167: 48               dec ax
  02BD58  7168: 48               dec ax
  02BD59  7169: 50               push ax
  02BD5A  716A: 51               push cx
  02BD5B  716B: 9a8c071f18       lcall 0x181f, 0x78c
  02BD60  7170: 83c404           add sp, 4
  02BD63  7173: 50               push ax
  02BD64  7174: 9a28041f19       lcall 0x191f, 0x428
  02BD69  7179: 83c402           add sp, 2
  02BD6C  717C: 0e               push cs
  02BD6D  717D: e8bd0c           call 0x7e3d
  02BD70  7180: e96d03           jmp 0x74f0
  02BD73  7183: 90               nop 
  02BD74  7184: ff367c8d         push word ptr [0x8d7c]
  02BD78  7188: 9a540c1f18       lcall 0x181f, 0xc54
  02BD7D  718D: 83c402           add sp, 2
  02BD80  7190: 8946f0           mov word ptr [bp - 0x10], ax
  02BD83  7193: 3d1c00           cmp ax, 0x1c
  02BD86  7196: 7505             jne 0x719d
  02BD88  7198: c746f01300       mov word ptr [bp - 0x10], 0x13
  02BD8D  719D: ff76f0           push word ptr [bp - 0x10]
  02BD90  71A0: 9ade081f19       lcall 0x191f, 0x8de
  02BD95  71A5: ebd2             jmp 0x7179
  02BD97  71A7: 90               nop 
  02BD98  71A8: 833e3c0300       cmp word ptr [0x33c], 0
  02BD9D  71AD: 74cd             je 0x717c
  02BD9F  71AF: ff363e03         push word ptr [0x33e]
  02BDA3  71B3: 9a320b1f18       lcall 0x181f, 0xb32
  02BDA8  71B8: 83c402           add sp, 2
  02BDAB  71BB: eb14             jmp 0x71d1
  02BDAD  71BD: 90               nop 
  02BDAE  71BE: 833e728d00       cmp word ptr [0x8d72], 0
  02BDB3  71C3: 74b7             je 0x717c
  02BDB5  71C5: a1788d           mov ax, word ptr [0x8d78]
  02BDB8  71C8: 8b167a8d         mov dx, word ptr [0x8d7a]
  02BDBC  71CC: 9a2a091f18       lcall 0x181f, 0x92a
  02BDC1  71D1: 8946ea           mov word ptr [bp - 0x16], ax
  02BDC4  71D4: 6bd81c           imul bx, ax, 0x1c
  02BDC7  71D7: 8a874631         mov al, byte ptr [bx + 0x3146]
  02BDCB  71DB: 2ae4             sub ah, ah
  02BDCD  71DD: 50               push ax
  02BDCE  71DE: 9a42091f19       lcall 0x191f, 0x942
  02BDD3  71E3: eb94             jmp 0x7179
  02BDD5  71E5: 90               nop 
  02BDD6  71E6: a03a03           mov al, byte ptr [0x33a]
  02BDD9  71E9: 2ae4             sub ah, ah
  02BDDB  71EB: 50               push ax
  02BDDC  71EC: 9a34091f19       lcall 0x191f, 0x934
  02BDE1  71F1: eb86             jmp 0x7179
  02BDE3  71F3: 90               nop 
  02BDE4  71F4: a1c68d           mov ax, word ptr [0x8dc6]
  02BDE7  71F7: 8946ea           mov word ptr [bp - 0x16], ax
  02BDEA  71FA: 817e063c01       cmp word ptr [bp + 6], 0x13c
  02BDEF  71FF: 7512             jne 0x7213
  02BDF1  7201: 8b1e4285         mov bx, word ptr [0x8542]
  02BDF5  7205: 8a471a           mov al, byte ptr [bx + 0x1a]
  02BDF8  7208: 2ae4             sub ah, ah
  02BDFA  720A: 50               push ax
  02BDFB  720B: 9a0c041f19       lcall 0x191f, 0x40c
  02BE00  7210: 83c402           add sp, 2
  02BE03  7213: 817e063d01       cmp word ptr [bp + 6], 0x13d
  02BE08  7218: 7512             jne 0x722c
  02BE0A  721A: 8b1e4285         mov bx, word ptr [0x8542]
  02BE0E  721E: 8a471a           mov al, byte ptr [bx + 0x1a]
  02BE11  7221: 2ae4             sub ah, ah
  02BE13  7223: 50               push ax
  02BE14  7224: 9afe031f19       lcall 0x191f, 0x3fe
  02BE19  7229: 83c402           add sp, 2
  02BE1C  722C: 817e063e01       cmp word ptr [bp + 6], 0x13e
  02BE21  7231: 7512             jne 0x7245
  02BE23  7233: 8b1e4285         mov bx, word ptr [0x8542]
  02BE27  7237: 8a471a           mov al, byte ptr [bx + 0x1a]
  02BE2A  723A: 2ae4             sub ah, ah
  02BE2C  723C: 50               push ax
  02BE2D  723D: 9af0031f19       lcall 0x191f, 0x3f0
  02BE32  7242: 83c402           add sp, 2
  02BE35  7245: 817e063f01       cmp word ptr [bp + 6], 0x13f
  02BE3A  724A: 7512             jne 0x725e
  02BE3C  724C: 8b1e4285         mov bx, word ptr [0x8542]
  02BE40  7250: 8a471a           mov al, byte ptr [bx + 0x1a]
  02BE43  7253: 2ae4             sub ah, ah
  02BE45  7255: 50               push ax
  02BE46  7256: 9ae2031f19       lcall 0x191f, 0x3e2
  02BE4B  725B: 83c402           add sp, 2
  02BE4E  725E: 817e064001       cmp word ptr [bp + 6], 0x140
  02BE53  7263: 7512             jne 0x7277
  02BE55  7265: 8b1e4285         mov bx, word ptr [0x8542]
  02BE59  7269: 8a471a           mov al, byte ptr [bx + 0x1a]
  02BE5C  726C: 2ae4             sub ah, ah
  02BE5E  726E: 50               push ax
  02BE5F  726F: 9ad4031f19       lcall 0x191f, 0x3d4
  02BE64  7274: 83c402           add sp, 2
  02BE67  7277: 817e064101       cmp word ptr [bp + 6], 0x141
  02BE6C  727C: 7512             jne 0x7290
  02BE6E  727E: 8b1e4285         mov bx, word ptr [0x8542]
  02BE72  7282: 8a471a           mov al, byte ptr [bx + 0x1a]
  02BE75  7285: 2ae4             sub ah, ah
  02BE77  7287: 50               push ax
  02BE78  7288: 9ac6031f19       lcall 0x191f, 0x3c6
  02BE7D  728D: 83c402           add sp, 2
  02BE80  7290: 817e064201       cmp word ptr [bp + 6], 0x142
  02BE85  7295: 7512             jne 0x72a9
  02BE87  7297: 8b1e4285         mov bx, word ptr [0x8542]
  02BE8B  729B: 8a471a           mov al, byte ptr [bx + 0x1a]
  02BE8E  729E: 2ae4             sub ah, ah
  02BE90  72A0: 50               push ax
  02BE91  72A1: 9ab8031f19       lcall 0x191f, 0x3b8
  02BE96  72A6: 83c402           add sp, 2
  02BE99  72A9: 817e064301       cmp word ptr [bp + 6], 0x143
  02BE9E  72AE: 7512             jne 0x72c2
  02BEA0  72B0: 8b1e4285         mov bx, word ptr [0x8542]
  02BEA4  72B4: 8a471a           mov al, byte ptr [bx + 0x1a]
  02BEA7  72B7: 2ae4             sub ah, ah
  02BEA9  72B9: 50               push ax
  02BEAA  72BA: 9a1a041f19       lcall 0x191f, 0x41a
  02BEAF  72BF: 83c402           add sp, 2
  02BEB2  72C2: 817e064401       cmp word ptr [bp + 6], 0x144
  02BEB7  72C7: 7519             jne 0x72e2
  02BEB9  72C9: f606835320       test byte ptr [0x5383], 0x20
  02BEBE  72CE: 7408             je 0x72d8
  02BEC0  72D0: 9a74051f18       lcall 0x181f, 0x574
  02BEC5  72D5: eb0b             jmp 0x72e2
  02BEC7  72D7: 90               nop 
  02BEC8  72D8: 6a01             push 1
  02BECA  72DA: 9aaa031f19       lcall 0x191f, 0x3aa
  02BECF  72DF: 83c402           add sp, 2
  02BED2  72E2: ff76ea           push word ptr [bp - 0x16]
  02BED5  72E5: 9ae6091f18       lcall 0x181f, 0x9e6
  02BEDA  72EA: 83c402           add sp, 2
  02BEDD  72ED: 6a01             push 1
  02BEDF  72EF: 0e               push cs
  02BEE0  72F0: e8310b           call 0x7e24
  02BEE3  72F3: 83c402           add sp, 2
  02BEE6  72F6: e9d9fd           jmp 0x70d2
  02BEE9  72F9: 90               nop 
  02BEEA  72FA: b80500           mov ax, 5
  02BEED  72FD: 50               push ax
  02BEEE  72FE: a12e03           mov ax, word ptr [0x32e]
  02BEF1  7301: 40               inc ax
  02BEF2  7302: 50               push ax
  02BEF3  7303: 9a8e031f18       lcall 0x181f, 0x38e
  02BEF8  7308: 83c404           add sp, 4
  02BEFB  730B: a32e03           mov word ptr [0x32e], ax
  02BEFE  730E: 3d0200           cmp ax, 2
  02BF01  7311: 750b             jne 0x731e
  02BF03  7313: 833e3c0300       cmp word ptr [0x33c], 0
  02BF08  7318: 7504             jne 0x731e
  02BF0A  731A: ff062e03         inc word ptr [0x32e]
  02BF0E  731E: 833e2e0303       cmp word ptr [0x32e], 3
  02BF13  7323: 7512             jne 0x7337
  02BF15  7325: 803e370301       cmp byte ptr [0x337], 1
  02BF1A  732A: 7507             jne 0x7333
  02BF1C  732C: 833e768d00       cmp word ptr [0x8d76], 0
  02BF21  7331: 7504             jne 0x7337
  02BF23  7333: ff062e03         inc word ptr [0x32e]
  02BF27  7337: 0e               push cs
  02BF28  7338: e84d0b           call 0x7e88
  02BF2B  733B: e994fd           jmp 0x70d2
  02BF2E  733E: 833e3c0300       cmp word ptr [0x33c], 0
  02BF33  7343: 7503             jne 0x7348
  02BF35  7345: e98afd           jmp 0x70d2
  02BF38  7348: ff363e03         push word ptr [0x33e]
  02BF3C  734C: 9a320b1f18       lcall 0x181f, 0xb32
  02BF41  7351: 83c402           add sp, 2
  02BF44  7354: 50               push ax
  02BF45  7355: 9ade011f19       lcall 0x191f, 0x1de
  02BF4A  735A: 83c402           add sp, 2
  02BF4D  735D: 0e               push cs
  02BF4E  735E: e84a0b           call 0x7eab
  02BF51  7361: e96efd           jmp 0x70d2
  02BF54  7364: a03703           mov al, byte ptr [0x337]
  02BF57  7367: 2ae4             sub ah, ah
  02BF59  7369: 40               inc ax
  02BF5A  736A: b90300           mov cx, 3
  02BF5D  736D: 99               cdq 
  02BF5E  736E: f7f9             idiv cx
  02BF60  7370: 88163803         mov byte ptr [0x338], dl
  02BF64  7374: 88163703         mov byte ptr [0x337], dl
  02BF68  7378: 390e2e03         cmp word ptr [0x32e], cx
  02BF6C  737C: 75df             jne 0x735d
  02BF6E  737E: 80fa01           cmp dl, 1
  02BF71  7381: 74da             je 0x735d
  02BF73  7383: c7062e030100     mov word ptr [0x32e], 1
  02BF79  7389: ebd2             jmp 0x735d
  02BF7B  738B: 90               nop 
  02BF7C  738C: 803e360301       cmp byte ptr [0x336], 1
  02BF81  7391: 1ac0             sbb al, al
  02BF83  7393: f6d8             neg al
  02BF85  7395: a23603           mov byte ptr [0x336], al
  02BF88  7398: eb9d             jmp 0x7337
  02BF8A  739A: 833e3c0300       cmp word ptr [0x33c], 0
  02BF8F  739F: 7503             jne 0x73a4
  02BF91  73A1: e92efd           jmp 0x70d2
  02BF94  73A4: 6a00             push 0
  02BF96  73A6: ff363e03         push word ptr [0x33e]
  02BF9A  73AA: 9a320b1f18       lcall 0x181f, 0xb32
  02BF9F  73AF: 83c402           add sp, 2
  02BFA2  73B2: 50               push ax
  02BFA3  73B3: 9ad0011f19       lcall 0x191f, 0x1d0
  02BFA8  73B8: 83c404           add sp, 4
  02BFAB  73BB: eba0             jmp 0x735d
  02BFAD  73BD: 90               nop 
  02BFAE  73BE: 833e3c0300       cmp word ptr [0x33c], 0
  02BFB3  73C3: 7432             je 0x73f7
  02BFB5  73C5: 837e065f         cmp word ptr [bp + 6], 0x5f
  02BFB9  73C9: 7505             jne 0x73d0
  02BFBB  73CB: b80100           mov ax, 1
  02BFBE  73CE: eb02             jmp 0x73d2
  02BFC0  73D0: 2bc0             sub ax, ax
  02BFC2  73D2: 50               push ax
  02BFC3  73D3: a03a03           mov al, byte ptr [0x33a]
  02BFC6  73D6: 2ae4             sub ah, ah
  02BFC8  73D8: 50               push ax
  02BFC9  73D9: ff363e03         push word ptr [0x33e]
  02BFCD  73DD: 9a320b1f18       lcall 0x181f, 0xb32
  02BFD2  73E2: 83c402           add sp, 2
  02BFD5  73E5: 50               push ax
  02BFD6  73E6: 0e               push cs
  02BFD7  73E7: e8ef09           call 0x7dd9
  02BFDA  73EA: 83c406           add sp, 6
  02BFDD  73ED: e9e2fc           jmp 0x70d2
  02BFE0  73F0: 833e3c0300       cmp word ptr [0x33c], 0
  02BFE5  73F5: 750d             jne 0x7404
  02BFE7  73F7: 6a00             push 0
  02BFE9  73F9: 6a78             push 0x78
  02BFEB  73FB: 6a05             push 5
  02BFED  73FD: 0e               push cs
  02BFEE  73FE: e8e60a           call 0x7ee7
  02BFF1  7401: ebe7             jmp 0x73ea
  02BFF3  7403: 90               nop 
  02BFF4  7404: 837e062b         cmp word ptr [bp + 6], 0x2b
  02BFF8  7408: 7506             jne 0x7410
  02BFFA  740A: b80100           mov ax, 1
  02BFFD  740D: eb03             jmp 0x7412
  02BFFF  740F: 90               nop 
  02C000  7410: 2bc0             sub ax, ax
  02C002  7412: 50               push ax
  02C003  7413: 6a01             push 1
  02C005  7415: a03a03           mov al, byte ptr [0x33a]
  02C008  7418: 2ae4             sub ah, ah
  02C00A  741A: 50               push ax
  02C00B  741B: ff363e03         push word ptr [0x33e]
  02C00F  741F: 9a320b1f18       lcall 0x181f, 0xb32
  02C014  7424: 83c402           add sp, 2
  02C017  7427: 50               push ax
  02C018  7428: 0e               push cs
  02C019  7429: e8ac0a           call 0x7ed8
  02C01C  742C: 83c408           add sp, 8
  02C01F  742F: e9a0fc           jmp 0x70d2
  02C022  7432: 8a4606           mov al, byte ptr [bp + 6]
  02C025  7435: 2c31             sub al, 0x31
  02C027  7437: a23803           mov byte ptr [0x338], al
  02C02A  743A: a23703           mov byte ptr [0x337], al
  02C02D  743D: 833e2e0303       cmp word ptr [0x32e], 3
  02C032  7442: 7403             je 0x7447
  02C034  7444: e916ff           jmp 0x735d
  02C037  7447: fec8             dec al
  02C039  7449: e935ff           jmp 0x7381
  02C03C  744C: 803e370302       cmp byte ptr [0x337], 2
  02C041  7451: 7416             je 0x7469
  02C043  7453: c606370302       mov byte ptr [0x337], 2
  02C048  7458: 833e2e0303       cmp word ptr [0x32e], 3
  02C04D  745D: 7506             jne 0x7465
  02C04F  745F: c7062e030100     mov word ptr [0x32e], 1
  02C055  7465: 0e               push cs
  02C056  7466: e8420a           call 0x7eab
  02C059  7469: 837e0642         cmp word ptr [bp + 6], 0x42
  02C05D  746D: 7406             je 0x7475
  02C05F  746F: 837e0662         cmp word ptr [bp + 6], 0x62
  02C063  7473: 7507             jne 0x747c
  02C065  7475: 0e               push cs
  02C066  7476: e8bf09           call 0x7e38
  02C069  7479: e956fc           jmp 0x70d2
  02C06C  747C: 0e               push cs
  02C06D  747D: e8030a           call 0x7e83
  02C070  7480: e94ffc           jmp 0x70d2
  02C073  7483: 90               nop 
  02C074  7484: 2c31             sub al, 0x31
  02C076  7486: 3d1b00           cmp ax, 0x1b
  02C079  7489: 7765             ja 0x74f0
  02C07B  748B: d1e0             shl ax, 1
  02C07D  748D: 93               xchg bx, ax
  02C07E  748E: 2effa78467       jmp word ptr cs:[bx + 0x6784]
  02C083  7493: 90               nop 
  02C084  7494: 226722           and ah, byte ptr [bx + 0x22]
  02C087  7497: 672267e0         and ah, byte ptr [edi - 0x20]
  02C08B  749B: 67e067           loopne 0x7505
  02C08E  749E: e067             loopne 0x7507
  02C090  74A0: e067             loopne 0x7509
  02C092  74A2: e067             loopne 0x750b
  02C094  74A4: e067             loopne 0x750d
  02C096  74A6: e067             loopne 0x750f
  02C098  74A8: e067             loopne 0x7511
  02C09A  74AA: e067             loopne 0x7513
  02C09C  74AC: e066             loopne 0x7514
  02C09E  74AE: e067             loopne 0x7517
  02C0A0  74B0: e067             loopne 0x7519
  02C0A2  74B2: e067             loopne 0x751b
  02C0A4  74B4: e067             loopne 0x751d
  02C0A6  74B6: 3c67             cmp al, 0x67
  02C0A8  74B8: 3c67             cmp al, 0x67
  02C0AA  74BA: e067             loopne 0x7523
  02C0AC  74BC: e067             loopne 0x7525
  02C0AE  74BE: e067             loopne 0x7527
  02C0B0  74C0: e067             loopne 0x7529
  02C0B2  74C2: e067             loopne 0x752b
  02C0B4  74C4: e067             loopne 0x752d
  02C0B6  74C6: e067             loopne 0x752f
  02C0B8  74C8: e067             loopne 0x7531
  02C0BA  74CA: 2e663d6d007503   cmp eax, 0x375006d
  02C0C1  74D1: e990fe           jmp 0x7364
  02C0C4  74D4: 7f30             jg 0x7506
  02C0C6  74D6: 3d6c00           cmp ax, 0x6c
  02C0C9  74D9: 7503             jne 0x74de
  02C0CB  74DB: e960fe           jmp 0x733e
  02C0CE  74DE: 7710             ja 0x74f0
  02C0D0  74E0: 3c5f             cmp al, 0x5f
  02C0D2  74E2: 7503             jne 0x74e7
  02C0D4  74E4: e9d7fe           jmp 0x73be
  02C0D7  74E7: 7f0f             jg 0x74f8
  02C0D9  74E9: 2c55             sub al, 0x55
  02C0DB  74EB: 7503             jne 0x74f0
  02C0DD  74ED: e9aafe           jmp 0x739a
  02C0E0  74F0: c746f20000       mov word ptr [bp - 0xe], 0
  02C0E5  74F5: e9dafb           jmp 0x70d2
  02C0E8  74F8: 2c62             sub al, 0x62
  02C0EA  74FA: 7cf4             jl 0x74f0
  02C0EC  74FC: fec8             dec al
  02C0EE  74FE: 7f03             jg 0x7503
  02C0F0  7500: e949ff           jmp 0x744c
  02C0F3  7503: ebeb             jmp 0x74f0
  02C0F5  7505: 90               nop 
  02C0F6  7506: 3d7500           cmp ax, 0x75
  02C0F9  7509: 7503             jne 0x750e
  02C0FB  750B: e98cfe           jmp 0x739a
  02C0FE  750E: 7f0a             jg 0x751a
  02C100  7510: 2d6e00           sub ax, 0x6e
  02C103  7513: 7503             jne 0x7518
  02C105  7515: e974fe           jmp 0x738c
  02C108  7518: ebd6             jmp 0x74f0
  02C10A  751A: 2d3b01           sub ax, 0x13b
  02C10D  751D: 7503             jne 0x7522
  02C10F  751F: e9f6fb           jmp 0x7118
  02C112  7522: 48               dec ax
  02C113  7523: 7ccb             jl 0x74f0
  02C115  7525: 2d0800           sub ax, 8
  02C118  7528: 7f03             jg 0x752d
  02C11A  752A: e9c7fc           jmp 0x71f4
  02C11D  752D: ebc1             jmp 0x74f0
  02C11F  752F: 90               nop 
  02C120  7530: 8b1e4285         mov bx, word ptr [0x8542]
  02C124  7534: 8a471f           mov al, byte ptr [bx + 0x1f]
  02C127  7537: 98               cwde 
  02C128  7538: 8946ea           mov word ptr [bp - 0x16], ax
  02C12B  753B: fe471f           inc byte ptr [bx + 0x1f]
  02C12E  753E: 6a00             push 0
  02C130  7540: ff76ea           push word ptr [bp - 0x16]
  02C133  7543: 9a360c1f18       lcall 0x181f, 0xc36
  02C138  7548: 83c404           add sp, 4
  02C13B  754B: 6a1c             push 0x1c
  02C13D  754D: ff76ea           push word ptr [bp - 0x16]
  02C140  7550: 9aae0c1f18       lcall 0x181f, 0xcae
  02C145  7555: 83c404           add sp, 4
  02C148  7558: 6a01             push 1
  02C14A  755A: 0e               push cs
  02C14B  755B: e8c608           call 0x7e24
  02C14E  755E: 83c402           add sp, 2
  02C151  7561: 837ef200         cmp word ptr [bp - 0xe], 0
  02C155  7565: 7404             je 0x756b
  02C157  7567: 0e               push cs
  02C158  7568: e84009           call 0x7eab
  02C15B  756B: 833e2e0301       cmp word ptr [0x32e], 1
  02C160  7570: 7403             je 0x7575
  02C162  7572: e95701           jmp 0x76cc
  02C165  7575: 8b4606           mov ax, word ptr [bp + 6]
  02C168  7578: 2d0d00           sub ax, 0xd
  02C16B  757B: 7503             jne 0x7580
  02C16D  757D: e94001           jmp 0x76c0
  02C170  7580: 2d3e01           sub ax, 0x13e
  02C173  7583: 7503             jne 0x7588
  02C175  7585: e90001           jmp 0x7688
  02C178  7588: 48               dec ax
  02C179  7589: 48               dec ax
  02C17A  758A: 7503             jne 0x758f
  02C17C  758C: e91d01           jmp 0x76ac
  02C17F  758F: 5e               pop si
  02C180  7590: c9               leave 
  02C181  7591: cb               retf 
  02C182  7592: ff367c8d         push word ptr [0x8d7c]
  02C186  7596: 9a0e0c1f18       lcall 0x181f, 0xc0e
  02C18B  759B: 83c402           add sp, 2
  02C18E  759E: 50               push ax
  02C18F  759F: ff367c8d         push word ptr [0x8d7c]
  02C193  75A3: ebab             jmp 0x7550
  02C195  75A5: 90               nop 
  02C196  75A6: 8b1e4285         mov bx, word ptr [0x8542]
  02C19A  75AA: 8a471a           mov al, byte ptr [bx + 0x1a]
  02C19D  75AD: 2ae4             sub ah, ah
  02C19F  75AF: 69d83c01         imul bx, ax, 0x13c
  02C1A3  75B3: 81873288e803     add word ptr [bx - 0x77ce], 0x3e8
  02C1A9  75B9: 8397348800       adc word ptr [bx - 0x77cc], 0
  02C1AE  75BE: 0e               push cs
  02C1AF  75BF: e8e908           call 0x7eab
  02C1B2  75C2: eb9d             jmp 0x7561
  02C1B4  75C4: a03a03           mov al, byte ptr [0x33a]
  02C1B7  75C7: 2ae4             sub ah, ah
  02C1B9  75C9: 8bf0             mov si, ax
  02C1BB  75CB: d1e6             shl si, 1
  02C1BD  75CD: 8b1e4285         mov bx, word ptr [0x8542]
  02C1C1  75D1: 83809a0064       add word ptr [bx + si + 0x9a], 0x64
  02C1C6  75D6: ebe6             jmp 0x75be
  02C1C8  75D8: a03a03           mov al, byte ptr [0x33a]
  02C1CB  75DB: 2ae4             sub ah, ah
  02C1CD  75DD: 8bf0             mov si, ax
  02C1CF  75DF: d1e6             shl si, 1
  02C1D1  75E1: 8b1e4285         mov bx, word ptr [0x8542]
  02C1D5  75E5: 8b809a00         mov ax, word ptr [bx + si + 0x9a]
  02C1D9  75E9: 2d6400           sub ax, 0x64
  02C1DC  75EC: 7902             jns 0x75f0
  02C1DE  75EE: 2bc0             sub ax, ax
  02C1E0  75F0: 89809a00         mov word ptr [bx + si + 0x9a], ax
  02C1E4  75F4: ebc8             jmp 0x75be
  02C1E6  75F6: c746f40000       mov word ptr [bp - 0xc], 0
  02C1EB  75FB: 8b1e4285         mov bx, word ptr [0x8542]
  02C1EF  75FF: 8b76f4           mov si, word ptr [bp - 0xc]
  02C1F2  7602: c6808400ff       mov byte ptr [bx + si + 0x84], 0xff
  02C1F7  7607: ff46f4           inc word ptr [bp - 0xc]
  02C1FA  760A: 837ef406         cmp word ptr [bp - 0xc], 6
  02C1FE  760E: 7ceb             jl 0x75fb
  02C200  7610: 6a00             push 0
  02C202  7612: 6a10             push 0x10
  02C204  7614: 9abe0b1f18       lcall 0x181f, 0xbbe
  02C209  7619: 83c404           add sp, 4
  02C20C  761C: 6a00             push 0
  02C20E  761E: 6a1f             push 0x1f
  02C210  7620: 9abe0b1f18       lcall 0x181f, 0xbbe
  02C215  7625: 83c404           add sp, 4
  02C218  7628: 6a00             push 0
  02C21A  762A: 6a0b             push 0xb
  02C21C  762C: 9abe0b1f18       lcall 0x181f, 0xbbe
  02C221  7631: 83c404           add sp, 4
  02C224  7634: 6a00             push 0
  02C226  7636: 6a0a             push 0xa
  02C228  7638: 9abe0b1f18       lcall 0x181f, 0xbbe
  02C22D  763D: 83c404           add sp, 4
  02C230  7640: 6a00             push 0
  02C232  7642: 6a1e             push 0x1e
  02C234  7644: 9abe0b1f18       lcall 0x181f, 0xbbe
  02C239  7649: 83c404           add sp, 4
  02C23C  764C: 8b1e4285         mov bx, word ptr [0x8542]
  02C240  7650: fe879500         inc byte ptr [bx + 0x95]
  02C244  7654: fe879600         inc byte ptr [bx + 0x96]
  02C248  7658: 0e               push cs
  02C249  7659: e8a007           call 0x7dfc
  02C24C  765C: e9f9fe           jmp 0x7558
  02C24F  765F: 90               nop 
  02C250  7660: ff36c68d         push word ptr [0x8dc6]
  02C254  7664: 9a50091f19       lcall 0x191f, 0x950
  02C259  7669: 83c402           add sp, 2
  02C25C  766C: e9e9fe           jmp 0x7558
  02C25F  766F: 90               nop 
  02C260  7670: 2c54             sub al, 0x54
  02C262  7672: 7503             jne 0x7677
  02C264  7674: e9b9fe           jmp 0x7530
  02C267  7677: 2c0a             sub al, 0xa
  02C269  7679: 7503             jne 0x767e
  02C26B  767B: e95aff           jmp 0x75d8
  02C26E  767E: 2c15             sub al, 0x15
  02C270  7680: 7503             jne 0x7685
  02C272  7682: e90dff           jmp 0x7592
  02C275  7685: e9d9fe           jmp 0x7561
  02C278  7688: 8b1e4285         mov bx, word ptr [0x8542]
  02C27C  768C: 8a471f           mov al, byte ptr [bx + 0x1f]
  02C27F  768F: 98               cwde 
  02C280  7690: 0306728d         add ax, word ptr [0x8d72]
  02C284  7694: 50               push ax
  02C285  7695: a17c8d           mov ax, word ptr [0x8d7c]
  02C288  7698: 48               dec ax
  02C289  7699: 50               push ax
  02C28A  769A: 9a8e031f18       lcall 0x181f, 0x38e
  02C28F  769F: 83c404           add sp, 4
  02C292  76A2: a37c8d           mov word ptr [0x8d7c], ax
  02C295  76A5: 0e               push cs
  02C296  76A6: e8df07           call 0x7e88
  02C299  76A9: 5e               pop si
  02C29A  76AA: c9               leave 
  02C29B  76AB: cb               retf 
  02C29C  76AC: 8b1e4285         mov bx, word ptr [0x8542]
  02C2A0  76B0: 8a471f           mov al, byte ptr [bx + 0x1f]
  02C2A3  76B3: 98               cwde 
  02C2A4  76B4: 0306728d         add ax, word ptr [0x8d72]
  02C2A8  76B8: 50               push ax
  02C2A9  76B9: a17c8d           mov ax, word ptr [0x8d7c]
  02C2AC  76BC: 40               inc ax
  02C2AD  76BD: ebda             jmp 0x7699
  02C2AF  76BF: 90               nop 
  02C2B0  76C0: 6a00             push 0
  02C2B2  76C2: 0e               push cs
  02C2B3  76C3: e8cc07           call 0x7e92
  02C2B6  76C6: 83c402           add sp, 2
  02C2B9  76C9: 5e               pop si
  02C2BA  76CA: c9               leave 
  02C2BB  76CB: cb               retf 
  02C2BC  76CC: 833e2e0300       cmp word ptr [0x32e], 0
  02C2C1  76D1: 7403             je 0x76d6
  02C2C3  76D3: e9c600           jmp 0x779c
  02C2C6  76D6: 2bc0             sub ax, ax
  02C2C8  76D8: 8946e8           mov word ptr [bp - 0x18], ax
  02C2CB  76DB: 8946ec           mov word ptr [bp - 0x14], ax
  02C2CE  76DE: 8b4606           mov ax, word ptr [bp + 6]
  02C2D1  76E1: 3d4b01           cmp ax, 0x14b
  02C2D4  76E4: 741a             je 0x7700
  02C2D6  76E6: 7e03             jle 0x76eb
  02C2D8  76E8: e99f00           jmp 0x778a
  02C2DB  76EB: 2d0d00           sub ax, 0xd
  02C2DE  76EE: 7503             jne 0x76f3
  02C2E0  76F0: e98f00           jmp 0x7782
  02C2E3  76F3: 2d3a01           sub ax, 0x13a
  02C2E6  76F6: 7478             je 0x7770
  02C2E8  76F8: 48               dec ax
  02C2E9  76F9: 7462             je 0x775d
  02C2EB  76FB: 48               dec ax
  02C2EC  76FC: 745a             je 0x7758
  02C2EE  76FE: eb05             jmp 0x7705
  02C2F0  7700: c746ecffff       mov word ptr [bp - 0x14], 0xffff
  02C2F5  7705: 837eec00         cmp word ptr [bp - 0x14], 0
  02C2F9  7709: 7509             jne 0x7714
  02C2FB  770B: 837ee800         cmp word ptr [bp - 0x18], 0
  02C2FF  770F: 7503             jne 0x7714
  02C301  7711: e93e02           jmp 0x7952
  02C304  7714: 6a03             push 3
  02C306  7716: 8b46ec           mov ax, word ptr [bp - 0x14]
  02C309  7719: 03063003         add ax, word ptr [0x330]
  02C30D  771D: 48               dec ax
  02C30E  771E: 50               push ax
  02C30F  771F: 9a8e031f18       lcall 0x181f, 0x38e
  02C314  7724: 83c404           add sp, 4
  02C317  7727: 40               inc ax
  02C318  7728: a33003           mov word ptr [0x330], ax
  02C31B  772B: 6a03             push 3
  02C31D  772D: 8b46e8           mov ax, word ptr [bp - 0x18]
  02C320  7730: 03063203         add ax, word ptr [0x332]
  02C324  7734: 48               dec ax
  02C325  7735: 50               push ax
  02C326  7736: 9a8e031f18       lcall 0x181f, 0x38e
  02C32B  773B: 83c404           add sp, 4
  02C32E  773E: 40               inc ax
  02C32F  773F: a33203           mov word ptr [0x332], ax
  02C332  7742: c70634030000     mov word ptr [0x334], 0
  02C338  7748: 0e               push cs
  02C339  7749: e8fb06           call 0x7e47
  02C33C  774C: 5e               pop si
  02C33D  774D: c9               leave 
  02C33E  774E: cb               retf 
  02C33F  774F: 90               nop 
  02C340  7750: c746ec0100       mov word ptr [bp - 0x14], 1
  02C345  7755: ebae             jmp 0x7705
  02C347  7757: 90               nop 
  02C348  7758: c746ec0100       mov word ptr [bp - 0x14], 1
  02C34D  775D: c746e8ffff       mov word ptr [bp - 0x18], 0xffff
  02C352  7762: eba1             jmp 0x7705
  02C354  7764: b80100           mov ax, 1
  02C357  7767: 8946ec           mov word ptr [bp - 0x14], ax
  02C35A  776A: 8946e8           mov word ptr [bp - 0x18], ax
  02C35D  776D: eb96             jmp 0x7705
  02C35F  776F: 90               nop 
  02C360  7770: b8ffff           mov ax, 0xffff
  02C363  7773: ebf2             jmp 0x7767
  02C365  7775: 90               nop 
  02C366  7776: c746ecffff       mov word ptr [bp - 0x14], 0xffff
  02C36B  777B: c746e80100       mov word ptr [bp - 0x18], 1
  02C370  7780: eb83             jmp 0x7705
  02C372  7782: 0e               push cs
  02C373  7783: e88006           call 0x7e06
  02C376  7786: e97cff           jmp 0x7705
  02C379  7789: 90               nop 
  02C37A  778A: 2d4d01           sub ax, 0x14d
  02C37D  778D: 74c1             je 0x7750
  02C37F  778F: 48               dec ax
  02C380  7790: 48               dec ax
  02C381  7791: 74e3             je 0x7776
  02C383  7793: 48               dec ax
  02C384  7794: 74e5             je 0x777b
  02C386  7796: 48               dec ax
  02C387  7797: 74cb             je 0x7764
  02C389  7799: e969ff           jmp 0x7705
  02C38C  779C: 833e2e0304       cmp word ptr [0x32e], 4
  02C391  77A1: 753f             jne 0x77e2
  02C393  77A3: 8b4606           mov ax, word ptr [bp + 6]
  02C396  77A6: 2d4801           sub ax, 0x148
  02C399  77A9: 7411             je 0x77bc
  02C39B  77AB: 2d0300           sub ax, 3
  02C39E  77AE: 740c             je 0x77bc
  02C3A0  77B0: 48               dec ax
  02C3A1  77B1: 48               dec ax
  02C3A2  77B2: 7424             je 0x77d8
  02C3A4  77B4: 2d0300           sub ax, 3
  02C3A7  77B7: 741f             je 0x77d8
  02C3A9  77B9: e99601           jmp 0x7952
  02C3AC  77BC: 6a10             push 0x10
  02C3AE  77BE: a03a03           mov al, byte ptr [0x33a]
  02C3B1  77C1: 2ae4             sub ah, ah
  02C3B3  77C3: 48               dec ax
  02C3B4  77C4: 50               push ax
  02C3B5  77C5: 9a8e031f18       lcall 0x181f, 0x38e
  02C3BA  77CA: 83c404           add sp, 4
  02C3BD  77CD: a23a03           mov byte ptr [0x33a], al
  02C3C0  77D0: 0e               push cs
  02C3C1  77D1: e8d706           call 0x7eab
  02C3C4  77D4: 5e               pop si
  02C3C5  77D5: c9               leave 
  02C3C6  77D6: cb               retf 
  02C3C7  77D7: 90               nop 
  02C3C8  77D8: 6a10             push 0x10
  02C3CA  77DA: a03a03           mov al, byte ptr [0x33a]
  02C3CD  77DD: 2ae4             sub ah, ah
  02C3CF  77DF: 40               inc ax
  02C3D0  77E0: ebe2             jmp 0x77c4
  02C3D2  77E2: 833e2e0302       cmp word ptr [0x32e], 2
  02C3D7  77E7: 7403             je 0x77ec
  02C3D9  77E9: e9b000           jmp 0x789c
  02C3DC  77EC: 8b4606           mov ax, word ptr [bp + 6]
  02C3DF  77EF: 3d7300           cmp ax, 0x73
  02C3E2  77F2: 7503             jne 0x77f7
  02C3E4  77F4: e98100           jmp 0x7878
  02C3E7  77F7: 7e03             jle 0x77fc
  02C3E9  77F9: e98a00           jmp 0x7886
  02C3EC  77FC: 3d5300           cmp ax, 0x53
  02C3EF  77FF: 7477             je 0x7878
  02C3F1  7801: 77cd             ja 0x77d0
  02C3F3  7803: 2c0d             sub al, 0xd
  02C3F5  7805: 7471             je 0x7878
  02C3F7  7807: 2c13             sub al, 0x13
  02C3F9  7809: 746d             je 0x7878
  02C3FB  780B: ebc3             jmp 0x77d0
  02C3FD  780D: 90               nop 
  02C3FE  780E: 90               nop 
  02C3FF  780F: 90               nop 
  02C400  7810: 833e400304       cmp word ptr [0x340], 4
  02C405  7815: 7d07             jge 0x781e
  02C407  7817: 8306400304       add word ptr [0x340], 4
  02C40C  781C: eb0d             jmp 0x782b
  02C40E  781E: 833e400308       cmp word ptr [0x340], 8
  02C413  7823: 7c36             jl 0x785b
  02C415  7825: c70640030000     mov word ptr [0x340], 0
  02C41B  782B: ff363c03         push word ptr [0x33c]
  02C41F  782F: ff364003         push word ptr [0x340]
  02C423  7833: 9a8e031f18       lcall 0x181f, 0x38e
  02C428  7838: 83c404           add sp, 4
  02C42B  783B: a34003           mov word ptr [0x340], ax
  02C42E  783E: a33e03           mov word ptr [0x33e], ax
  02C431  7841: eb8d             jmp 0x77d0
  02C433  7843: 90               nop 
  02C434  7844: 833e400308       cmp word ptr [0x340], 8
  02C439  7849: 7c09             jl 0x7854
  02C43B  784B: c70640030300     mov word ptr [0x340], 3
  02C441  7851: ebd8             jmp 0x782b
  02C443  7853: 90               nop 
  02C444  7854: 833e400304       cmp word ptr [0x340], 4
  02C449  7859: 7cbc             jl 0x7817
  02C44B  785B: 832e400304       sub word ptr [0x340], 4
  02C450  7860: ebc9             jmp 0x782b
  02C452  7862: ff363c03         push word ptr [0x33c]
  02C456  7866: a14003           mov ax, word ptr [0x340]
  02C459  7869: 48               dec ax
  02C45A  786A: eb08             jmp 0x7874
  02C45C  786C: ff363c03         push word ptr [0x33c]
  02C460  7870: a14003           mov ax, word ptr [0x340]
  02C463  7873: 40               inc ax
  02C464  7874: 50               push ax
  02C465  7875: ebbc             jmp 0x7833
  02C467  7877: 90               nop 
  02C468  7878: a14003           mov ax, word ptr [0x340]
  02C46B  787B: a33e03           mov word ptr [0x33e], ax
  02C46E  787E: 0e               push cs
  02C46F  787F: e84206           call 0x7ec4
  02C472  7882: e94bff           jmp 0x77d0
  02C475  7885: 90               nop 
  02C476  7886: 2d4801           sub ax, 0x148
  02C479  7889: 7485             je 0x7810
  02C47B  788B: 2d0300           sub ax, 3
  02C47E  788E: 74d2             je 0x7862
  02C480  7890: 48               dec ax
  02C481  7891: 48               dec ax
  02C482  7892: 74d8             je 0x786c
  02C484  7894: 2d0300           sub ax, 3
  02C487  7897: 74ab             je 0x7844
  02C489  7899: e934ff           jmp 0x77d0
  02C48C  789C: 833e2e0303       cmp word ptr [0x32e], 3
  02C491  78A1: 7403             je 0x78a6
  02C493  78A3: e9ac00           jmp 0x7952
  02C496  78A6: a03703           mov al, byte ptr [0x337]
  02C499  78A9: 2ae4             sub ah, ah
  02C49B  78AB: e99e00           jmp 0x794c
  02C49E  78AE: 8b4606           mov ax, word ptr [bp + 6]
  02C4A1  78B1: 2d0d00           sub ax, 0xd
  02C4A4  78B4: 7503             jne 0x78b9
  02C4A6  78B6: e98b00           jmp 0x7944
  02C4A9  78B9: 2d3b01           sub ax, 0x13b
  02C4AC  78BC: 7412             je 0x78d0
  02C4AE  78BE: 2d0300           sub ax, 3
  02C4B1  78C1: 746b             je 0x792e
  02C4B3  78C3: 48               dec ax
  02C4B4  78C4: 48               dec ax
  02C4B5  78C5: 7471             je 0x7938
  02C4B7  78C7: 2d0300           sub ax, 3
  02C4BA  78CA: 743c             je 0x7908
  02C4BC  78CC: e901ff           jmp 0x77d0
  02C4BF  78CF: 90               nop 
  02C4C0  78D0: 833e7a8d05       cmp word ptr [0x8d7a], 5
  02C4C5  78D5: 7d07             jge 0x78de
  02C4C7  78D7: 83067a8d05       add word ptr [0x8d7a], 5
  02C4CC  78DC: eb14             jmp 0x78f2
  02C4CE  78DE: 833e7a8d16       cmp word ptr [0x8d7a], 0x16
  02C4D3  78E3: 7d07             jge 0x78ec
  02C4D5  78E5: 83067a8d11       add word ptr [0x8d7a], 0x11
  02C4DA  78EA: eb06             jmp 0x78f2
  02C4DC  78EC: c7067a8d0400     mov word ptr [0x8d7a], 4
  02C4E2  78F2: ff36768d         push word ptr [0x8d76]
  02C4E6  78F6: ff367a8d         push word ptr [0x8d7a]
  02C4EA  78FA: 9a8e031f18       lcall 0x181f, 0x38e
  02C4EF  78FF: 83c404           add sp, 4
  02C4F2  7902: a37a8d           mov word ptr [0x8d7a], ax
  02C4F5  7905: e9c8fe           jmp 0x77d0
  02C4F8  7908: 833e7a8d16       cmp word ptr [0x8d7a], 0x16
  02C4FD  790D: 7c07             jl 0x7916
  02C4FF  790F: 832e7a8d11       sub word ptr [0x8d7a], 0x11
  02C504  7914: ebdc             jmp 0x78f2
  02C506  7916: 833e7a8d05       cmp word ptr [0x8d7a], 5
  02C50B  791B: 7c09             jl 0x7926
  02C50D  791D: c7067a8d0000     mov word ptr [0x8d7a], 0
  02C513  7923: ebcd             jmp 0x78f2
  02C515  7925: 90               nop 
  02C516  7926: c7067a8d1600     mov word ptr [0x8d7a], 0x16
  02C51C  792C: ebc4             jmp 0x78f2
  02C51E  792E: ff36768d         push word ptr [0x8d76]
  02C522  7932: a17a8d           mov ax, word ptr [0x8d7a]
  02C525  7935: 48               dec ax
  02C526  7936: eb08             jmp 0x7940
  02C528  7938: ff36768d         push word ptr [0x8d76]
  02C52C  793C: a17a8d           mov ax, word ptr [0x8d7a]
  02C52F  793F: 40               inc ax
  02C530  7940: 50               push ax
  02C531  7941: ebb7             jmp 0x78fa
  02C533  7943: 90               nop 
  02C534  7944: 0e               push cs
  02C535  7945: e80905           call 0x7e51
  02C538  7948: e985fe           jmp 0x77d0
  02C53B  794B: 90               nop 
  02C53C  794C: 48               dec ax
  02C53D  794D: 7503             jne 0x7952
  02C53F  794F: e95cff           jmp 0x78ae
  02C542  7952: 5e               pop si
  02C543  7953: c9               leave 
  02C544  7954: cb               retf 

; ---- func_02C546  size=141  insns=48  prologue=ENTER 0x0006,0  terminal=RET ----
  02C546  7956: c8060000         enter 6, 0
  02C54A  795A: a09b0b           mov al, byte ptr [0xb9b]
  02C54D  795D: 8846fc           mov byte ptr [bp - 4], al
  02C550  7960: a09d0b           mov al, byte ptr [0xb9d]
  02C553  7963: 8846fa           mov byte ptr [bp - 6], al
  02C556  7966: a09f0b           mov al, byte ptr [0xb9f]
  02C559  7969: 8846fe           mov byte ptr [bp - 2], al
  02C55C  796C: 2ac0             sub al, al
  02C55E  796E: a29b0b           mov byte ptr [0xb9b], al
  02C561  7971: a29d0b           mov byte ptr [0xb9d], al
  02C564  7974: a29f0b           mov byte ptr [0xb9f], al
  02C567  7977: 0e               push cs
  02C568  7978: e81205           call 0x7e8d
  02C56B  797B: 803e9b0b00       cmp byte ptr [0xb9b], 0
  02C570  7980: 750f             jne 0x7991
  02C572  7982: 807efc00         cmp byte ptr [bp - 4], 0
  02C576  7986: 7409             je 0x7991
  02C578  7988: 6a01             push 1
  02C57A  798A: 0e               push cs
  02C57B  798B: e80004           call 0x7d8e
  02C57E  798E: 83c402           add sp, 2
  02C581  7991: 803e9d0b00       cmp byte ptr [0xb9d], 0
  02C586  7996: 750f             jne 0x79a7
  02C588  7998: 807efa00         cmp byte ptr [bp - 6], 0
  02C58C  799C: 7409             je 0x79a7
  02C58E  799E: 6a01             push 1
  02C590  79A0: 0e               push cs
  02C591  79A1: e88504           call 0x7e29
  02C594  79A4: 83c402           add sp, 2
  02C597  79A7: 803e9f0b00       cmp byte ptr [0xb9f], 0
  02C59C  79AC: 750f             jne 0x79bd
  02C59E  79AE: 807efe00         cmp byte ptr [bp - 2], 0
  02C5A2  79B2: 7409             je 0x79bd
  02C5A4  79B4: 6a01             push 1
  02C5A6  79B6: 0e               push cs
  02C5A7  79B7: e8f703           call 0x7db1
  02C5AA  79BA: 83c402           add sp, 2
  02C5AD  79BD: 803e9b0b00       cmp byte ptr [0xb9b], 0
  02C5B2  79C2: 7505             jne 0x79c9
  02C5B4  79C4: c6069a0bfe       mov byte ptr [0xb9a], 0xfe
  02C5B9  79C9: 803e9d0b00       cmp byte ptr [0xb9d], 0
  02C5BE  79CE: 7505             jne 0x79d5
  02C5C0  79D0: c6069c0bfe       mov byte ptr [0xb9c], 0xfe
  02C5C5  79D5: 803e9f0b00       cmp byte ptr [0xb9f], 0
  02C5CA  79DA: 7505             jne 0x79e1
  02C5CC  79DC: c6069e0bfe       mov byte ptr [0xb9e], 0xfe
  02C5D1  79E1: c9               leave 
  02C5D2  79E2: c3               ret 

; ---- func_02C5D4  size=1318  insns=373  prologue=ENTER 0x001A,0  terminal=page-end ----
  02C5D4  79E4: c81a0000         enter 0x1a, 0
  02C5D8  79E8: 56               push si
  02C5D9  79E9: 9a5e091f19       lcall 0x191f, 0x95e
  02C5DE  79EE: 6a00             push 0
  02C5E0  79F0: 9a56001f18       lcall 0x181f, 0x56
  02C5E5  79F5: 83c402           add sp, 2
  02C5E8  79F8: 6a07             push 7
  02C5EA  79FA: 684001           push 0x140
  02C5ED  79FD: 6a00             push 0
  02C5EF  79FF: 6a00             push 0
  02C5F1  7A01: 9aa6001f18       lcall 0x181f, 0xa6
  02C5F6  7A06: 83c408           add sp, 8
  02C5F9  7A09: ff7606           push word ptr [bp + 6]
  02C5FC  7A0C: 9ae6091f18       lcall 0x181f, 0x9e6
  02C601  7A11: 83c402           add sp, 2
  02C604  7A14: c7067c8d0000     mov word ptr [0x8d7c], 0
  02C60A  7A1A: 9a720c1f18       lcall 0x181f, 0xc72
  02C60F  7A1F: c70690080100     mov word ptr [0x890], 1
  02C615  7A25: 0e               push cs
  02C616  7A26: e87804           call 0x7ea1
  02C619  7A29: 833e4a0300       cmp word ptr [0x34a], 0
  02C61E  7A2E: 7c0e             jl 0x7a3e
  02C620  7A30: 6a00             push 0
  02C622  7A32: ff364a03         push word ptr [0x34a]
  02C626  7A36: 9abe0b1f18       lcall 0x181f, 0xbbe
  02C62B  7A3B: 83c404           add sp, 4
  02C62E  7A3E: 0e               push cs
  02C62F  7A3F: e86003           call 0x7da2
  02C632  7A42: 6a01             push 1
  02C634  7A44: 0e               push cs
  02C635  7A45: e8dc03           call 0x7e24
  02C638  7A48: 83c402           add sp, 2
  02C63B  7A4B: 833e4a0300       cmp word ptr [0x34a], 0
  02C640  7A50: 7c2d             jl 0x7a7f
  02C642  7A52: 6a01             push 1
  02C644  7A54: ff364a03         push word ptr [0x34a]
  02C648  7A58: 9abe0b1f18       lcall 0x181f, 0xbbe
  02C64D  7A5D: 83c404           add sp, 4
  02C650  7A60: 0e               push cs
  02C651  7A61: e83e03           call 0x7da2
  02C654  7A64: 6a00             push 0
  02C656  7A66: 0e               push cs
  02C657  7A67: e8ba03           call 0x7e24
  02C65A  7A6A: 83c402           add sp, 2
  02C65D  7A6D: b85400           mov ax, 0x54
  02C660  7A70: 9ac0041f18       lcall 0x181f, 0x4c0
  02C665  7A75: 6a08             push 8
  02C667  7A77: 9aea031f18       lcall 0x181f, 0x3ea
  02C66C  7A7C: 83c402           add sp, 2
  02C66F  7A7F: 833e980b00       cmp word ptr [0xb98], 0
  02C674  7A84: 7408             je 0x7a8e
  02C676  7A86: 9ac0031f18       lcall 0x181f, 0x3c0
  02C67B  7A8B: e9d602           jmp 0x7d64
  02C67E  7A8E: f606825380       test byte ptr [0x5382], 0x80
  02C683  7A93: 7503             jne 0x7a98
  02C685  7A95: e9c700           jmp 0x7b5f
  02C688  7A98: f606865380       test byte ptr [0x5386], 0x80
  02C68D  7A9D: 7403             je 0x7aa2
  02C68F  7A9F: e9bd00           jmp 0x7b5f
  02C692  7AA2: 6a00             push 0
  02C694  7AA4: 9a0e0c1f18       lcall 0x181f, 0xc0e
  02C699  7AA9: 83c402           add sp, 2
  02C69C  7AAC: 8946ee           mov word ptr [bp - 0x12], ax
  02C69F  7AAF: 3d0d00           cmp ax, 0xd
  02C6A2  7AB2: 750c             jne 0x7ac0
  02C6A4  7AB4: c746ec1000       mov word ptr [bp - 0x14], 0x10
  02C6A9  7AB9: c746fe0000       mov word ptr [bp - 2], 0
  02C6AE  7ABE: eb67             jmp 0x7b27
  02C6B0  7AC0: 8946ec           mov word ptr [bp - 0x14], ax
  02C6B3  7AC3: 8d46f2           lea ax, [bp - 0xe]
  02C6B6  7AC6: 50               push ax
  02C6B7  7AC7: 8d4ef4           lea cx, [bp - 0xc]
  02C6BA  7ACA: 51               push cx
  02C6BB  7ACB: 2bd2             sub dx, dx
  02C6BD  7ACD: 8956fe           mov word ptr [bp - 2], dx
  02C6C0  7AD0: 52               push dx
  02C6C1  7AD1: 9a300d1f18       lcall 0x181f, 0xd30
  02C6C6  7AD6: 83c406           add sp, 6
  02C6C9  7AD9: 8b1e4285         mov bx, word ptr [0x8542]
  02C6CD  7ADD: 8a07             mov al, byte ptr [bx]
  02C6CF  7ADF: 2ae4             sub ah, ah
  02C6D1  7AE1: 48               dec ax
  02C6D2  7AE2: 48               dec ax
  02C6D3  7AE3: 0146f4           add word ptr [bp - 0xc], ax
  02C6D6  7AE6: 8a4701           mov al, byte ptr [bx + 1]
  02C6D9  7AE9: 2ae4             sub ah, ah
  02C6DB  7AEB: 48               dec ax
  02C6DC  7AEC: 48               dec ax
  02C6DD  7AED: 0146f2           add word ptr [bp - 0xe], ax
  02C6E0  7AF0: ff76f2           push word ptr [bp - 0xe]
  02C6E3  7AF3: ff76f4           push word ptr [bp - 0xc]
  02C6E6  7AF6: 9a8c071f18       lcall 0x181f, 0x78c
  02C6EB  7AFB: 83c404           add sp, 4
  02C6EE  7AFE: 8946f0           mov word ptr [bp - 0x10], ax
  02C6F1  7B01: c746fa0000       mov word ptr [bp - 6], 0
  02C6F6  7B06: 8b76f0           mov si, word ptr [bp - 0x10]
  02C6F9  7B09: c1e604           shl si, 4
  02C6FC  7B0C: 8b5efa           mov bx, word ptr [bp - 6]
  02C6FF  7B0F: 80b87b2f00       cmp byte ptr [bx + si + 0x2f7b], 0
  02C704  7B14: 7408             je 0x7b1e
  02C706  7B16: 3b5eee           cmp bx, word ptr [bp - 0x12]
  02C709  7B19: 7403             je 0x7b1e
  02C70B  7B1B: 895efe           mov word ptr [bp - 2], bx
  02C70E  7B1E: ff46fa           inc word ptr [bp - 6]
  02C711  7B21: 837efa08         cmp word ptr [bp - 6], 8
  02C715  7B25: 7cdf             jl 0x7b06
  02C717  7B27: 8b5eec           mov bx, word ptr [bp - 0x14]
  02C71A  7B2A: d1e3             shl bx, 1
  02C71C  7B2C: ffb7c097         push word ptr [bx - 0x6840]
  02C720  7B30: 6a00             push 0
  02C722  7B32: 9a38041f18       lcall 0x181f, 0x438
  02C727  7B37: 83c404           add sp, 4
  02C72A  7B3A: 8b5efe           mov bx, word ptr [bp - 2]
  02C72D  7B3D: d1e3             shl bx, 1
  02C72F  7B3F: ffb7c097         push word ptr [bx - 0x6840]
  02C733  7B43: 6a01             push 1
  02C735  7B45: 9a38041f18       lcall 0x181f, 0x438
  02C73A  7B4A: 83c404           add sp, 4
  02C73D  7B4D: 6a05             push 5
  02C73F  7B4F: 683d0d           push 0xd3d
  02C742  7B52: 9a52061f18       lcall 0x181f, 0x652
  02C747  7B57: 83c404           add sp, 4
  02C74A  7B5A: 800e865380       or byte ptr [0x5386], 0x80
  02C74F  7B5F: f606825380       test byte ptr [0x5382], 0x80
  02C754  7B64: 746b             je 0x7bd1
  02C756  7B66: f606875380       test byte ptr [0x5387], 0x80
  02C75B  7B6B: 7564             jne 0x7bd1
  02C75D  7B6D: c746fc0000       mov word ptr [bp - 4], 0
  02C762  7B72: 8b1e4285         mov bx, word ptr [0x8542]
  02C766  7B76: 8a07             mov al, byte ptr [bx]
  02C768  7B78: 2ae4             sub ah, ah
  02C76A  7B7A: 8a5701           mov dl, byte ptr [bx + 1]
  02C76D  7B7D: 2af6             sub dh, dh
  02C76F  7B7F: 9ae0071f18       lcall 0x181f, 0x7e0
  02C774  7B84: eb1b             jmp 0x7ba1
  02C776  7B86: 6bd81c           imul bx, ax, 0x1c
  02C779  7B89: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  02C77E  7B8E: 720c             jb 0x7b9c
  02C780  7B90: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  02C785  7B95: 7705             ja 0x7b9c
  02C787  7B97: c746fc0100       mov word ptr [bp - 4], 1
  02C78C  7B9C: 9ae4021f18       lcall 0x181f, 0x2e4
  02C791  7BA1: 8946fa           mov word ptr [bp - 6], ax
  02C794  7BA4: 0bc0             or ax, ax
  02C796  7BA6: 7dde             jge 0x7b86
  02C798  7BA8: 837efc00         cmp word ptr [bp - 4], 0
  02C79C  7BAC: 7423             je 0x7bd1
  02C79E  7BAE: a14285           mov ax, word ptr [0x8542]
  02C7A1  7BB1: 40               inc ax
  02C7A2  7BB2: 40               inc ax
  02C7A3  7BB3: 1e               push ds
  02C7A4  7BB4: 50               push ax
  02C7A5  7BB5: 6a00             push 0
  02C7A7  7BB7: 9a16041f18       lcall 0x181f, 0x416
  02C7AC  7BBC: 83c406           add sp, 6
  02C7AF  7BBF: 6a05             push 5
  02C7B1  7BC1: 68470d           push 0xd47
  02C7B4  7BC4: 9a52061f18       lcall 0x181f, 0x652
  02C7B9  7BC9: 83c404           add sp, 4
  02C7BC  7BCC: 800e875380       or byte ptr [0x5387], 0x80
  02C7C1  7BD1: c70646030100     mov word ptr [0x346], 1
  02C7C7  7BD7: 9a06000c0c       lcall 0xc0c, 6
  02C7CC  7BDC: 051400           add ax, 0x14
  02C7CF  7BDF: 83d200           adc dx, 0
  02C7D2  7BE2: a35a8d           mov word ptr [0x8d5a], ax
  02C7D5  7BE5: 89165c8d         mov word ptr [0x8d5c], dx
  02C7D9  7BE9: 9a7a041f18       lcall 0x181f, 0x47a
  02C7DE  7BEE: 803e280800       cmp byte ptr [0x828], 0
  02C7E3  7BF3: 7477             je 0x7c6c
  02C7E5  7BF5: 9a06000c0c       lcall 0xc0c, 6
  02C7EA  7BFA: 8946f6           mov word ptr [bp - 0xa], ax
  02C7ED  7BFD: 8956f8           mov word ptr [bp - 8], dx
  02C7F0  7C00: 9a70041f18       lcall 0x181f, 0x470
  02C7F5  7C05: 2bc0             sub ax, ax
  02C7F7  7C07: 9a66041f18       lcall 0x181f, 0x466
  02C7FC  7C0C: 833ef40700       cmp word ptr [0x7f4], 0
  02C801  7C11: 7509             jne 0x7c1c
  02C803  7C13: 9af6001f18       lcall 0x181f, 0xf6
  02C808  7C18: 0bc0             or ax, ax
  02C80A  7C1A: 7417             je 0x7c33
  02C80C  7C1C: 9aec001f18       lcall 0x181f, 0xec
  02C811  7C21: 6a05             push 5
  02C813  7C23: 9ab6051f18       lcall 0x181f, 0x5b6
  02C818  7C28: 83c402           add sp, 2
  02C81B  7C2B: 2bc0             sub ax, ax
  02C81D  7C2D: a34603           mov word ptr [0x346], ax
  02C820  7C30: a3c253           mov word ptr [0x53c2], ax
  02C823  7C33: 2bc0             sub ax, ax
  02C825  7C35: 8b164603         mov dx, word ptr [0x346]
  02C829  7C39: 9a5c041f18       lcall 0x181f, 0x45c
  02C82E  7C3E: 9a06000c0c       lcall 0xc0c, 6
  02C833  7C43: 8946e8           mov word ptr [bp - 0x18], ax
  02C836  7C46: 8956ea           mov word ptr [bp - 0x16], dx
  02C839  7C49: 2b46f6           sub ax, word ptr [bp - 0xa]
  02C83C  7C4C: 1b56f8           sbb dx, word ptr [bp - 8]
  02C83F  7C4F: 0bd2             or dx, dx
  02C841  7C51: 7c0d             jl 0x7c60
  02C843  7C53: 7f05             jg 0x7c5a
  02C845  7C55: 3d5802           cmp ax, 0x258
  02C848  7C58: 7206             jb 0x7c60
  02C84A  7C5A: c70646030000     mov word ptr [0x346], 0
  02C850  7C60: 833e460300       cmp word ptr [0x346], 0
  02C855  7C65: 7599             jne 0x7c00
  02C857  7C67: e9d900           jmp 0x7d43
  02C85A  7C6A: 90               nop 
  02C85B  7C6B: 90               nop 
  02C85C  7C6C: 9a70041f18       lcall 0x181f, 0x470
  02C861  7C71: 2bc0             sub ax, ax
  02C863  7C73: 9a66041f18       lcall 0x181f, 0x466
  02C868  7C78: 9a06000c0c       lcall 0xc0c, 6
  02C86D  7C7D: 8946e8           mov word ptr [bp - 0x18], ax
  02C870  7C80: 8956ea           mov word ptr [bp - 0x16], dx
  02C873  7C83: 833eec0700       cmp word ptr [0x7ec], 0
  02C878  7C88: 7413             je 0x7c9d
  02C87A  7C8A: 050800           add ax, 8
  02C87D  7C8D: 83d200           adc dx, 0
  02C880  7C90: a35e8d           mov word ptr [0x8d5e], ax
  02C883  7C93: 8916608d         mov word ptr [0x8d60], dx
  02C887  7C97: c706588d0100     mov word ptr [0x8d58], 1
  02C88D  7C9D: a15a8d           mov ax, word ptr [0x8d5a]
  02C890  7CA0: 8b165c8d         mov dx, word ptr [0x8d5c]
  02C894  7CA4: 3956ea           cmp word ptr [bp - 0x16], dx
  02C897  7CA7: 7c1e             jl 0x7cc7
  02C899  7CA9: 7f05             jg 0x7cb0
  02C89B  7CAB: 3946e8           cmp word ptr [bp - 0x18], ax
  02C89E  7CAE: 7217             jb 0x7cc7
  02C8A0  7CB0: 0e               push cs
  02C8A1  7CB1: e89301           call 0x7e47
  02C8A4  7CB4: 8b46e8           mov ax, word ptr [bp - 0x18]
  02C8A7  7CB7: 8b56ea           mov dx, word ptr [bp - 0x16]
  02C8AA  7CBA: 051400           add ax, 0x14
  02C8AD  7CBD: 83d200           adc dx, 0
  02C8B0  7CC0: a35a8d           mov word ptr [0x8d5a], ax
  02C8B3  7CC3: 89165c8d         mov word ptr [0x8d5c], dx
  02C8B7  7CC7: 9af6001f18       lcall 0x181f, 0xf6
  02C8BC  7CCC: 0bc0             or ax, ax
  02C8BE  7CCE: 741d             je 0x7ced
  02C8C0  7CD0: 9ae0031f18       lcall 0x181f, 0x3e0
  02C8C5  7CD5: 8946e6           mov word ptr [bp - 0x1a], ax
  02C8C8  7CD8: 833e340300       cmp word ptr [0x334], 0
  02C8CD  7CDD: 7404             je 0x7ce3
  02C8CF  7CDF: 0e               push cs
  02C8D0  7CE0: e86401           call 0x7e47
  02C8D3  7CE3: ff76e6           push word ptr [bp - 0x1a]
  02C8D6  7CE6: 0e               push cs
  02C8D7  7CE7: e80801           call 0x7df2
  02C8DA  7CEA: 83c402           add sp, 2
  02C8DD  7CED: 833e440300       cmp word ptr [0x344], 0
  02C8E2  7CF2: 740b             je 0x7cff
  02C8E4  7CF4: 833eee0700       cmp word ptr [0x7ee], 0
  02C8E9  7CF9: 7504             jne 0x7cff
  02C8EB  7CFB: 0e               push cs
  02C8EC  7CFC: e80201           call 0x7e01
  02C8EF  7CFF: 833eec0700       cmp word ptr [0x7ec], 0
  02C8F4  7D04: 7413             je 0x7d19
  02C8F6  7D06: 6a00             push 0
  02C8F8  7D08: 9a56001f18       lcall 0x181f, 0x56
  02C8FD  7D0D: 83c402           add sp, 2
  02C900  7D10: 6a01             push 1
  02C902  7D12: 0e               push cs
  02C903  7D13: e8e001           call 0x7ef6
  02C906  7D16: 83c402           add sp, 2
  02C909  7D19: 9a9c001f18       lcall 0x181f, 0x9c
  02C90E  7D1E: 0bc0             or ax, ax
  02C910  7D20: 7409             je 0x7d2b
  02C912  7D22: 6a01             push 1
  02C914  7D24: 0e               push cs
  02C915  7D25: e8ce01           call 0x7ef6
  02C918  7D28: 83c402           add sp, 2
  02C91B  7D2B: e828fc           call 0x7956
  02C91E  7D2E: 2bc0             sub ax, ax
  02C920  7D30: 8b164603         mov dx, word ptr [0x346]
  02C924  7D34: 9a5c041f18       lcall 0x181f, 0x45c
  02C929  7D39: 833e460300       cmp word ptr [0x346], 0
  02C92E  7D3E: 7403             je 0x7d43
  02C930  7D40: e929ff           jmp 0x7c6c
  02C933  7D43: 0e               push cs
  02C934  7D44: e8ba00           call 0x7e01
  02C937  7D47: 6a00             push 0
  02C939  7D49: 9a56001f18       lcall 0x181f, 0x56
  02C93E  7D4E: 83c402           add sp, 2
  02C941  7D51: 833e480300       cmp word ptr [0x348], 0
  02C946  7D56: 740c             je 0x7d64
  02C948  7D58: ff36c68d         push word ptr [0x8dc6]
  02C94C  7D5C: 9a54021f19       lcall 0x191f, 0x254
  02C951  7D61: 83c402           add sp, 2
  02C954  7D64: c7064e03ffff     mov word ptr [0x34e], 0xffff
  02C95A  7D6A: c70670000000     mov word ptr [0x70], 0
  02C960  7D70: 9a6c091f19       lcall 0x191f, 0x96c
  02C965  7D75: c70690080000     mov word ptr [0x890], 0
  02C96B  7D7B: 9a6a051f18       lcall 0x181f, 0x56a
  02C970  7D80: 5e               pop si
  02C971  7D81: c9               leave 
  02C972  7D82: cb               retf 
  02C973  7D83: 90               nop 
  02C974  7D84: eac8041f19       ljmp 0x191f:0x4c8
  02C979  7D89: ead4041f19       ljmp 0x191f:0x4d4
  02C97E  7D8E: eae0041f19       ljmp 0x191f:0x4e0
  02C983  7D93: eaec041f19       ljmp 0x191f:0x4ec
  02C988  7D98: eaf8041f19       ljmp 0x191f:0x4f8
  02C98D  7D9D: ea04051f19       ljmp 0x191f:0x504
  02C992  7DA2: ea10051f19       ljmp 0x191f:0x510
  02C997  7DA7: ea1c051f19       ljmp 0x191f:0x51c
  02C99C  7DAC: ea28051f19       ljmp 0x191f:0x528
  02C9A1  7DB1: ea34051f19       ljmp 0x191f:0x534
  02C9A6  7DB6: ea40051f19       ljmp 0x191f:0x540
  02C9AB  7DBB: ea4c051f19       ljmp 0x191f:0x54c
  02C9B0  7DC0: ea58051f19       ljmp 0x191f:0x558
  02C9B5  7DC5: ea64051f19       ljmp 0x191f:0x564
  02C9BA  7DCA: ea70051f19       ljmp 0x191f:0x570
  02C9BF  7DCF: ea7c051f19       ljmp 0x191f:0x57c
  02C9C4  7DD4: ea88051f19       ljmp 0x191f:0x588
  02C9C9  7DD9: ea94051f19       ljmp 0x191f:0x594
  02C9CE  7DDE: eaa0051f19       ljmp 0x191f:0x5a0
  02C9D3  7DE3: eaac051f19       ljmp 0x191f:0x5ac
  02C9D8  7DE8: eab8051f19       ljmp 0x191f:0x5b8
  02C9DD  7DED: eac4051f19       ljmp 0x191f:0x5c4
  02C9E2  7DF2: ead0051f19       ljmp 0x191f:0x5d0
  02C9E7  7DF7: eadc051f19       ljmp 0x191f:0x5dc
  02C9EC  7DFC: eae8051f19       ljmp 0x191f:0x5e8
  02C9F1  7E01: eaf4051f19       ljmp 0x191f:0x5f4
  02C9F6  7E06: ea00061f19       ljmp 0x191f:0x600
  02C9FB  7E0B: ea0c061f19       ljmp 0x191f:0x60c
  02CA00  7E10: ea18061f19       ljmp 0x191f:0x618
  02CA05  7E15: ea24061f19       ljmp 0x191f:0x624
  02CA0A  7E1A: ea30061f19       ljmp 0x191f:0x630
  02CA0F  7E1F: ea3c061f19       ljmp 0x191f:0x63c
  02CA14  7E24: ea48061f19       ljmp 0x191f:0x648
  02CA19  7E29: ea54061f19       ljmp 0x191f:0x654
  02CA1E  7E2E: ea60061f19       ljmp 0x191f:0x660
  02CA23  7E33: ea6c061f19       ljmp 0x191f:0x66c
  02CA28  7E38: ea78061f19       ljmp 0x191f:0x678
  02CA2D  7E3D: ea84061f19       ljmp 0x191f:0x684
  02CA32  7E42: ea90061f19       ljmp 0x191f:0x690
  02CA37  7E47: ea9c061f19       ljmp 0x191f:0x69c
  02CA3C  7E4C: eaa8061f19       ljmp 0x191f:0x6a8
  02CA41  7E51: eab4061f19       ljmp 0x191f:0x6b4
  02CA46  7E56: eac0061f19       ljmp 0x191f:0x6c0
  02CA4B  7E5B: eacc061f19       ljmp 0x191f:0x6cc
  02CA50  7E60: ead8061f19       ljmp 0x191f:0x6d8
  02CA55  7E65: eae4061f19       ljmp 0x191f:0x6e4
  02CA5A  7E6A: eaf0061f19       ljmp 0x191f:0x6f0
  02CA5F  7E6F: eafc061f19       ljmp 0x191f:0x6fc
  02CA64  7E74: ea08071f19       ljmp 0x191f:0x708
  02CA69  7E79: ea14071f19       ljmp 0x191f:0x714
  02CA6E  7E7E: ea20071f19       ljmp 0x191f:0x720
  02CA73  7E83: ea2c071f19       ljmp 0x191f:0x72c
  02CA78  7E88: ea38071f19       ljmp 0x191f:0x738
  02CA7D  7E8D: ea44071f19       ljmp 0x191f:0x744
  02CA82  7E92: ea50071f19       ljmp 0x191f:0x750
  02CA87  7E97: ea5c071f19       ljmp 0x191f:0x75c
  02CA8C  7E9C: ea68071f19       ljmp 0x191f:0x768
  02CA91  7EA1: ea74071f19       ljmp 0x191f:0x774
  02CA96  7EA6: ea80071f19       ljmp 0x191f:0x780
  02CA9B  7EAB: ea8c071f19       ljmp 0x191f:0x78c
  02CAA0  7EB0: ea98071f19       ljmp 0x191f:0x798
  02CAA5  7EB5: eaa4071f19       ljmp 0x191f:0x7a4
  02CAAA  7EBA: eab0071f19       ljmp 0x191f:0x7b0
  02CAAF  7EBF: eabc071f19       ljmp 0x191f:0x7bc
  02CAB4  7EC4: eac8071f19       ljmp 0x191f:0x7c8
  02CAB9  7EC9: ead4071f19       ljmp 0x191f:0x7d4
  02CABE  7ECE: eae0071f19       ljmp 0x191f:0x7e0
  02CAC3  7ED3: eaec071f19       ljmp 0x191f:0x7ec
  02CAC8  7ED8: eaf8071f19       ljmp 0x191f:0x7f8
  02CACD  7EDD: ea04081f19       ljmp 0x191f:0x804
  02CAD2  7EE2: ea10081f19       ljmp 0x191f:0x810
  02CAD7  7EE7: ea1c081f19       ljmp 0x191f:0x81c
  02CADC  7EEC: ea28081f19       ljmp 0x191f:0x828
  02CAE1  7EF1: ea34081f19       ljmp 0x191f:0x834
  02CAE6  7EF6: ea40081f19       ljmp 0x191f:0x840
  02CAEB  7EFB: ea4c081f19       ljmp 0x191f:0x84c
  02CAF0  7F00: ea58081f19       ljmp 0x191f:0x858
  02CAF5  7F05: ea64081f19       ljmp 0x191f:0x864
