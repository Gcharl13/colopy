; ============================================================
; VICEROY.EXE overlay page 0x18 (record 23) -- RE-SEGMENTED
; file_offset (disk image) = 0x06F850
; code_offset (first insn) = 0x06F8E0
; code_end (next reloc hdr)= 0x06FB40  [resident size 38 para -> nominal_end 0x06FAB0; on-disk code spills past it]
; reloc_count = 24  flags = 0x0000
; display IP base = page-image-relative (IP = file - 0x06F850)
; functions in page = 4
; ============================================================

; ---- func_06F8E0  size=26  insns=7  prologue=no-frame (first byte 0x83)  terminal=RETF ----
  06F8E0  0090: 833e142000       cmp word ptr [0x2014], 0
  06F8E5  0095: 7412             je 0xa9
  06F8E7  0097: ff361420         push word ptr [0x2014]
  06F8EB  009B: 9af4031d0d       lcall 0xd1d, 0x3f4
  06F8F0  00A0: 83c402           add sp, 2
  06F8F3  00A3: c70614200000     mov word ptr [0x2014], 0
  06F8F9  00A9: cb               retf 

; ---- func_06F8FA  size=447  insns=176  prologue=ENTER 0x00A2,0  terminal=RETF ----
  06F8FA  00AA: c8a20000         enter 0xa2, 0
  06F8FE  00AE: 57               push di
  06F8FF  00AF: 56               push si
  06F900  00B0: 8b7606           mov si, word ptr [bp + 6]
  06F903  00B3: c746fe0100       mov word ptr [bp - 2], 1
  06F908  00B8: 2bff             sub di, di
  06F90A  00BA: c646ae40         mov byte ptr [bp - 0x52], 0x40
  06F90E  00BE: c646af00         mov byte ptr [bp - 0x51], 0
  06F912  00C2: ff7608           push word ptr [bp + 8]
  06F915  00C5: 8d46ae           lea ax, [bp - 0x52]
  06F918  00C8: 50               push ax
  06F919  00C9: 9aa4071d0d       lcall 0xd1d, 0x7a4
  06F91E  00CE: 83c404           add sp, 4
  06F921  00D1: 8d46ae           lea ax, [bp - 0x52]
  06F924  00D4: 50               push ax
  06F925  00D5: 9a640d1d0d       lcall 0xd1d, 0xd64
  06F92A  00DA: 83c402           add sp, 2
  06F92D  00DD: 0bf6             or si, si
  06F92F  00DF: 743d             je 0x11e
  06F931  00E1: 0e               push cs
  06F932  00E2: e8f301           call 0x2d8
  06F935  00E5: 56               push si
  06F936  00E6: 8d865eff         lea ax, [bp - 0xa2]
  06F93A  00EA: 50               push ax
  06F93B  00EB: 9ae4071d0d       lcall 0xd1d, 0x7e4
  06F940  00F0: 83c404           add sp, 4
  06F943  00F3: 8d865eff         lea ax, [bp - 0xa2]
  06F947  00F7: 16               push ss
  06F948  00F8: 50               push ax
  06F949  00F9: 1e               push ds
  06F94A  00FA: 681620           push 0x2016
  06F94D  00FD: 9a940a1f1a       lcall 0x1a1f, 0xa94
  06F952  0102: 8d865eff         lea ax, [bp - 0xa2]
  06F956  0106: 16               push ss
  06F957  0107: 50               push ax
  06F958  0108: 8d1e1a20         lea bx, [0x201a]
  06F95C  010C: 9a860e1f18       lcall 0x181f, 0xe86
  06F961  0111: a31420           mov word ptr [0x2014], ax
  06F964  0114: 0bc0             or ax, ax
  06F966  0116: 7509             jne 0x121
  06F968  0118: 8b76fe           mov si, word ptr [bp - 2]
  06F96B  011B: eb6b             jmp 0x188
  06F96D  011D: 90               nop 
  06F96E  011E: bf0100           mov di, 1
  06F971  0121: 837e0800         cmp word ptr [bp + 8], 0
  06F975  0125: 745f             je 0x186
  06F977  0127: 2bf6             sub si, si
  06F979  0129: ff361420         push word ptr [0x2014]
  06F97D  012D: 6a50             push 0x50
  06F97F  012F: 683c83           push 0x833c
  06F982  0132: 9aca091d0d       lcall 0xd1d, 0x9ca
  06F987  0137: 83c406           add sp, 6
  06F98A  013A: 0bc0             or ax, ax
  06F98C  013C: 750b             jne 0x149
  06F98E  013E: 0bff             or di, di
  06F990  0140: 74d6             je 0x118
  06F992  0142: 2bff             sub di, di
  06F994  0144: c6063c8300       mov byte ptr [0x833c], 0
  06F999  0149: 1e               push ds
  06F99A  014A: 683c83           push 0x833c
  06F99D  014D: 9a4e0b1f1a       lcall 0x1a1f, 0xb4e
  06F9A2  0152: 1e               push ds
  06F9A3  0153: 683c83           push 0x833c
  06F9A6  0156: 9a440b1f1a       lcall 0x1a1f, 0xb44
  06F9AB  015B: 8d46ae           lea ax, [bp - 0x52]
  06F9AE  015E: 50               push ax
  06F9AF  015F: 683c83           push 0x833c
  06F9B2  0162: 9a16081d0d       lcall 0xd1d, 0x816
  06F9B7  0167: 83c404           add sp, 4
  06F9BA  016A: 0bc0             or ax, ax
  06F9BC  016C: 7503             jne 0x171
  06F9BE  016E: be0100           mov si, 1
  06F9C1  0171: 0bf6             or si, si
  06F9C3  0173: 74b4             je 0x129
  06F9C5  0175: 683c83           push 0x833c
  06F9C8  0178: 9a42081d0d       lcall 0xd1d, 0x842
  06F9CD  017D: 83c402           add sp, 2
  06F9D0  0180: 053c83           add ax, 0x833c
  06F9D3  0183: a308a6           mov word ptr [0xa608], ax
  06F9D6  0186: 2bf6             sub si, si
  06F9D8  0188: 0bf6             or si, si
  06F9DA  018A: 7404             je 0x190
  06F9DC  018C: 0e               push cs
  06F9DD  018D: e84801           call 0x2d8
  06F9E0  0190: 8bc6             mov ax, si
  06F9E2  0192: 5e               pop si
  06F9E3  0193: 5f               pop di
  06F9E4  0194: c9               leave 
  06F9E5  0195: cb               retf 
  06F9E6  0196: 56               push si
  06F9E7  0197: 2bf6             sub si, si
  06F9E9  0199: ff361420         push word ptr [0x2014]
  06F9ED  019D: 6a50             push 0x50
  06F9EF  019F: 683c83           push 0x833c
  06F9F2  01A2: 9aca091d0d       lcall 0xd1d, 0x9ca
  06F9F7  01A7: 83c406           add sp, 6
  06F9FA  01AA: 0bc0             or ax, ax
  06F9FC  01AC: 7433             je 0x1e1
  06F9FE  01AE: 1e               push ds
  06F9FF  01AF: 683c83           push 0x833c
  06FA02  01B2: 9a4e0b1f1a       lcall 0x1a1f, 0xb4e
  06FA07  01B7: 1e               push ds
  06FA08  01B8: 683c83           push 0x833c
  06FA0B  01BB: 9a440b1f1a       lcall 0x1a1f, 0xb44
  06FA10  01C0: 6a5f             push 0x5f
  06FA12  01C2: 683c83           push 0x833c
  06FA15  01C5: 9a560c1d0d       lcall 0xd1d, 0xc56
  06FA1A  01CA: 83c404           add sp, 4
  06FA1D  01CD: 8bf0             mov si, ax
  06FA1F  01CF: 0bf6             or si, si
  06FA21  01D1: 7403             je 0x1d6
  06FA23  01D3: c60420           mov byte ptr [si], 0x20
  06FA26  01D6: 0bf6             or si, si
  06FA28  01D8: 75e6             jne 0x1c0
  06FA2A  01DA: be3c83           mov si, 0x833c
  06FA2D  01DD: 893608a6         mov word ptr [0xa608], si
  06FA31  01E1: 0bf6             or si, si
  06FA33  01E3: 7504             jne 0x1e9
  06FA35  01E5: 0e               push cs
  06FA36  01E6: e8ef00           call 0x2d8
  06FA39  01E9: 8bc6             mov ax, si
  06FA3B  01EB: 5e               pop si
  06FA3C  01EC: cb               retf 
  06FA3D  01ED: 90               nop 
  06FA3E  01EE: 57               push di
  06FA3F  01EF: 56               push si
  06FA40  01F0: 8b3608a6         mov si, word ptr [0xa608]
  06FA44  01F4: bfb8a5           mov di, 0xa5b8
  06FA47  01F7: 803c00           cmp byte ptr [si], 0
  06FA4A  01FA: 7410             je 0x20c
  06FA4C  01FC: 803c2c           cmp byte ptr [si], 0x2c
  06FA4F  01FF: 740b             je 0x20c
  06FA51  0201: 8a04             mov al, byte ptr [si]
  06FA53  0203: 8805             mov byte ptr [di], al
  06FA55  0205: 47               inc di
  06FA56  0206: 46               inc si
  06FA57  0207: 803c00           cmp byte ptr [si], 0
  06FA5A  020A: 75f0             jne 0x1fc
  06FA5C  020C: 803c00           cmp byte ptr [si], 0
  06FA5F  020F: 7401             je 0x212
  06FA61  0211: 46               inc si
  06FA62  0212: 893608a6         mov word ptr [0xa608], si
  06FA66  0216: c60500           mov byte ptr [di], 0
  06FA69  0219: 1e               push ds
  06FA6A  021A: 68b8a5           push 0xa5b8
  06FA6D  021D: 9a440b1f1a       lcall 0x1a1f, 0xb44
  06FA72  0222: b8b8a5           mov ax, 0xa5b8
  06FA75  0225: 5e               pop si
  06FA76  0226: 5f               pop di
  06FA77  0227: cb               retf 
  06FA78  0228: 0e               push cs
  06FA79  0229: e8b100           call 0x2dd
  06FA7C  022C: 8bd8             mov bx, ax
  06FA7E  022E: 9a3a0b1f1a       lcall 0x1a1f, 0xb3a
  06FA83  0233: cb               retf 
  06FA84  0234: 683c83           push 0x833c
  06FA87  0237: 9a42081d0d       lcall 0xd1d, 0x842
  06FA8C  023C: 83c402           add sp, 2
  06FA8F  023F: 053c83           add ax, 0x833c
  06FA92  0242: a308a6           mov word ptr [0xa608], ax
  06FA95  0245: cb               retf 
  06FA96  0246: 0e               push cs
  06FA97  0247: e88400           call 0x2ce
  06FA9A  024A: 1e               push ds
  06FA9B  024B: 683c83           push 0x833c
  06FA9E  024E: 9a18001f18       lcall 0x181f, 0x18
  06FAA3  0253: 83c404           add sp, 4
  06FAA6  0256: cb               retf 
  06FAA7  0257: 90               nop 
  06FAA8  0258: 0e               push cs
  06FAA9  0259: e88100           call 0x2dd
  06FAAC  025C: 1e               push ds
  06FAAD  025D: 68b8a5           push 0xa5b8
  06FAB0  0260: 9a18001f18       lcall 0x181f, 0x18
  06FAB5  0265: 83c404           add sp, 4
  06FAB8  0268: cb               retf 

; ---- func_06FABA  size=46  insns=20  prologue=ENTER 0x0002,0  terminal=RETF ----
  06FABA  026A: c8020000         enter 2, 0
  06FABE  026E: 56               push si
  06FABF  026F: c646ff00         mov byte ptr [bp - 1], 0
  06FAC3  0273: 0e               push cs
  06FAC4  0274: e86600           call 0x2dd
  06FAC7  0277: beb8a5           mov si, 0xa5b8
  06FACA  027A: 803c30           cmp byte ptr [si], 0x30
  06FACD  027D: 7405             je 0x284
  06FACF  027F: 803c31           cmp byte ptr [si], 0x31
  06FAD2  0282: 750e             jne 0x292
  06FAD4  0284: d066ff           shl byte ptr [bp - 1], 1
  06FAD7  0287: 803c31           cmp byte ptr [si], 0x31
  06FADA  028A: 7503             jne 0x28f
  06FADC  028C: fe46ff           inc byte ptr [bp - 1]
  06FADF  028F: 46               inc si
  06FAE0  0290: ebe8             jmp 0x27a
  06FAE2  0292: 8a46ff           mov al, byte ptr [bp - 1]
  06FAE5  0295: 5e               pop si
  06FAE6  0296: c9               leave 
  06FAE7  0297: cb               retf 

; ---- func_06FAE8  size=74  insns=30  prologue=ENTER 0x0002,0  terminal=page-end ----
  06FAE8  0298: c8020000         enter 2, 0
  06FAEC  029C: 56               push si
  06FAED  029D: be0100           mov si, 1
  06FAF0  02A0: ff7608           push word ptr [bp + 8]
  06FAF3  02A3: ff7606           push word ptr [bp + 6]
  06FAF6  02A6: 0e               push cs
  06FAF7  02A7: e82900           call 0x2d3
  06FAFA  02AA: 83c404           add sp, 4
  06FAFD  02AD: 0bc0             or ax, ax
  06FAFF  02AF: 7513             jne 0x2c4
  06FB01  02B1: 8b5e0a           mov bx, word ptr [bp + 0xa]
  06FB04  02B4: 0bdb             or bx, bx
  06FB06  02B6: 7c0a             jl 0x2c2
  06FB08  02B8: 8d7701           lea si, [bx + 1]
  06FB0B  02BB: 0e               push cs
  06FB0C  02BC: e80f00           call 0x2ce
  06FB0F  02BF: 4e               dec si
  06FB10  02C0: 75f9             jne 0x2bb
  06FB12  02C2: 2bf6             sub si, si
  06FB14  02C4: 0e               push cs
  06FB15  02C5: e81000           call 0x2d8
  06FB18  02C8: 8bc6             mov ax, si
  06FB1A  02CA: 5e               pop si
  06FB1B  02CB: c9               leave 
  06FB1C  02CC: cb               retf 
  06FB1D  02CD: 90               nop 
  06FB1E  02CE: ea1c091f19       ljmp 0x191f:0x91c
  06FB23  02D3: ea28091f19       ljmp 0x191f:0x928
  06FB28  02D8: eab80f1f19       ljmp 0x191f:0xfb8
  06FB2D  02DD: eac40f1f19       ljmp 0x191f:0xfc4
