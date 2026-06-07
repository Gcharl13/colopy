; ============================================================
; VICEROY.EXE overlay page 0x1D (record 28) -- RE-SEGMENTED
; file_offset (disk image) = 0x077880
; code_offset (first insn) = 0x077990
; code_end (next reloc hdr)= 0x077E00  [resident size 71 para -> nominal_end 0x077CF0; on-disk code spills past it]
; reloc_count = 58  flags = 0x0000
; display IP base = page-image-relative (IP = file - 0x077880)
; functions in page = 5
; ============================================================

; ---- func_077990  size=164  insns=61  prologue=ENTER 0x002E,0  terminal=RET ----
  077990  0110: c82e0000         enter 0x2e, 0
  077994  0114: 52               push dx
  077995  0115: 50               push ax
  077996  0116: 53               push bx
  077997  0117: 56               push si
  077998  0118: c746d60100       mov word ptr [bp - 0x2a], 1
  07799D  011D: 1e               push ds
  07799E  011E: 50               push ax
  07799F  011F: 8d1e6a24         lea bx, [0x246a]
  0779A3  0123: 9a860e1f18       lcall 0x181f, 0xe86
  0779A8  0128: 8946d2           mov word ptr [bp - 0x2e], ax
  0779AB  012B: 0bc0             or ax, ax
  0779AD  012D: 746e             je 0x19d
  0779AF  012F: c746d40100       mov word ptr [bp - 0x2c], 1
  0779B4  0134: eb03             jmp 0x139
  0779B6  0136: ff46d4           inc word ptr [bp - 0x2c]
  0779B9  0139: 8b46d0           mov ax, word ptr [bp - 0x30]
  0779BC  013C: 3946d4           cmp word ptr [bp - 0x2c], ax
  0779BF  013F: 7f1f             jg 0x160
  0779C1  0141: 8b5ed2           mov bx, word ptr [bp - 0x2e]
  0779C4  0144: f6470610         test byte ptr [bx + 6], 0x10
  0779C8  0148: 7553             jne 0x19d
  0779CA  014A: 53               push bx
  0779CB  014B: 6a24             push 0x24
  0779CD  014D: 8d46d8           lea ax, [bp - 0x28]
  0779D0  0150: 50               push ax
  0779D1  0151: 9aca091d0d       lcall 0xd1d, 0x9ca
  0779D6  0156: 83c406           add sp, 6
  0779D9  0159: 0bc0             or ax, ax
  0779DB  015B: 75d9             jne 0x136
  0779DD  015D: eb3e             jmp 0x19d
  0779DF  015F: 90               nop 
  0779E0  0160: c746d40000       mov word ptr [bp - 0x2c], 0
  0779E5  0165: eb11             jmp 0x178
  0779E7  0167: 90               nop 
  0779E8  0168: 8b76d4           mov si, word ptr [bp - 0x2c]
  0779EB  016B: 807ad820         cmp byte ptr [bp + si - 0x28], 0x20
  0779EF  016F: 7d04             jge 0x175
  0779F1  0171: c642d800         mov byte ptr [bp + si - 0x28], 0
  0779F5  0175: ff46d4           inc word ptr [bp - 0x2c]
  0779F8  0178: 8d46d8           lea ax, [bp - 0x28]
  0779FB  017B: 50               push ax
  0779FC  017C: 9a42081d0d       lcall 0xd1d, 0x842
  077A01  0181: 83c402           add sp, 2
  077A04  0184: 3b46d4           cmp ax, word ptr [bp - 0x2c]
  077A07  0187: 7fdf             jg 0x168
  077A09  0189: 8d46d8           lea ax, [bp - 0x28]
  077A0C  018C: 50               push ax
  077A0D  018D: ff76cc           push word ptr [bp - 0x34]
  077A10  0190: 9ae4071d0d       lcall 0xd1d, 0x7e4
  077A15  0195: 83c404           add sp, 4
  077A18  0198: c746d60000       mov word ptr [bp - 0x2a], 0
  077A1D  019D: 837ed200         cmp word ptr [bp - 0x2e], 0
  077A21  01A1: 740b             je 0x1ae
  077A23  01A3: ff76d2           push word ptr [bp - 0x2e]
  077A26  01A6: 9af4031d0d       lcall 0xd1d, 0x3f4
  077A2B  01AB: 83c402           add sp, 2
  077A2E  01AE: 8b46d6           mov ax, word ptr [bp - 0x2a]
  077A31  01B1: 5e               pop si
  077A32  01B2: c9               leave 
  077A33  01B3: c3               ret 

; ---- func_077A34  size=169  insns=63  prologue=ENTER 0x0058,0  terminal=RETF ----
  077A34  01B4: c8580000         enter 0x58, 0
  077A38  01B8: 53               push bx
  077A39  01B9: 56               push si
  077A3A  01BA: c746ae0100       mov word ptr [bp - 0x52], 1
  077A3F  01BF: 1e               push ds
  077A40  01C0: 53               push bx
  077A41  01C1: 8d1ec824         lea bx, [0x24c8]
  077A45  01C5: 9a860e1f18       lcall 0x181f, 0xe86
  077A4A  01CA: 8946a8           mov word ptr [bp - 0x58], ax
  077A4D  01CD: 0bc0             or ax, ax
  077A4F  01CF: 7478             je 0x249
  077A51  01D1: c746ac0100       mov word ptr [bp - 0x54], 1
  077A56  01D6: 8b5ea8           mov bx, word ptr [bp - 0x58]
  077A59  01D9: f6470610         test byte ptr [bx + 6], 0x10
  077A5D  01DD: 756a             jne 0x249
  077A5F  01DF: 53               push bx
  077A60  01E0: 6a4f             push 0x4f
  077A62  01E2: 8d46b0           lea ax, [bp - 0x50]
  077A65  01E5: 50               push ax
  077A66  01E6: 9aca091d0d       lcall 0xd1d, 0x9ca
  077A6B  01EB: 83c406           add sp, 6
  077A6E  01EE: 0bc0             or ax, ax
  077A70  01F0: 7457             je 0x249
  077A72  01F2: c746aa0000       mov word ptr [bp - 0x56], 0
  077A77  01F7: eb11             jmp 0x20a
  077A79  01F9: 90               nop 
  077A7A  01FA: 8b76aa           mov si, word ptr [bp - 0x56]
  077A7D  01FD: 807ab020         cmp byte ptr [bp + si - 0x50], 0x20
  077A81  0201: 7d04             jge 0x207
  077A83  0203: c642b000         mov byte ptr [bp + si - 0x50], 0
  077A87  0207: ff46aa           inc word ptr [bp - 0x56]
  077A8A  020A: 8d46b0           lea ax, [bp - 0x50]
  077A8D  020D: 50               push ax
  077A8E  020E: 9a42081d0d       lcall 0xd1d, 0x842
  077A93  0213: 83c402           add sp, 2
  077A96  0216: 3b46aa           cmp ax, word ptr [bp - 0x56]
  077A99  0219: 7fdf             jg 0x1fa
  077A9B  021B: 6a03             push 3
  077A9D  021D: 68cb24           push 0x24cb
  077AA0  0220: 8d46b0           lea ax, [bp - 0x50]
  077AA3  0223: 50               push ax
  077AA4  0224: 9abc081d0d       lcall 0xd1d, 0x8bc
  077AA9  0229: 83c406           add sp, 6
  077AAC  022C: 0bc0             or ax, ax
  077AAE  022E: 7506             jne 0x236
  077AB0  0230: 8946ac           mov word ptr [bp - 0x54], ax
  077AB3  0233: eb0e             jmp 0x243
  077AB5  0235: 90               nop 
  077AB6  0236: 8d46b0           lea ax, [bp - 0x50]
  077AB9  0239: 16               push ss
  077ABA  023A: 50               push ax
  077ABB  023B: b80100           mov ax, 1
  077ABE  023E: 9a260f1f1a       lcall 0x1a1f, 0xf26
  077AC3  0243: 837eac00         cmp word ptr [bp - 0x54], 0
  077AC7  0247: 758d             jne 0x1d6
  077AC9  0249: 837ea800         cmp word ptr [bp - 0x58], 0
  077ACD  024D: 740b             je 0x25a
  077ACF  024F: ff76a8           push word ptr [bp - 0x58]
  077AD2  0252: 9af4031d0d       lcall 0xd1d, 0x3f4
  077AD7  0257: 83c402           add sp, 2
  077ADA  025A: 5e               pop si
  077ADB  025B: c9               leave 
  077ADC  025C: cb               retf 

; ---- func_077ADE  size=49  insns=18  prologue=push bp;mov bp,sp  terminal=RETF ----
  077ADE  025E: 55               push bp
  077ADF  025F: 8bec             mov bp, sp
  077AE1  0261: 9ae2051f18       lcall 0x181f, 0x5e2
  077AE6  0266: 0bc0             or ax, ax
  077AE8  0268: 740e             je 0x278
  077AEA  026A: 6a00             push 0
  077AEC  026C: 9ade041f18       lcall 0x181f, 0x4de
  077AF1  0271: 8be5             mov sp, bp
  077AF3  0273: 9ad8051f18       lcall 0x181f, 0x5d8
  077AF8  0278: 9ace051f18       lcall 0x181f, 0x5ce
  077AFD  027D: 6a03             push 3
  077AFF  027F: 6a00             push 0
  077B01  0281: 9ac4051f18       lcall 0x181f, 0x5c4
  077B06  0286: 8be5             mov sp, bp
  077B08  0288: b80300           mov ax, 3
  077B0B  028B: cd10             int 0x10
  077B0D  028D: c9               leave 
  077B0E  028E: cb               retf 

; ---- func_077B10  size=590  insns=204  prologue=ENTER 0x0052,0  terminal=RET imm16 ----
  077B10  0290: c8520000         enter 0x52, 0
  077B14  0294: 52               push dx
  077B15  0295: 50               push ax
  077B16  0296: 53               push bx
  077B17  0297: 57               push di
  077B18  0298: 56               push si
  077B19  0299: 8bf0             mov si, ax
  077B1B  029B: 8bfa             mov di, dx
  077B1D  029D: 895eae           mov word ptr [bp - 0x52], bx
  077B20  02A0: 0e               push cs
  077B21  02A1: e8d202           call 0x576
  077B24  02A4: 837e04ec         cmp word ptr [bp + 4], -0x14
  077B28  02A8: 7503             jne 0x2ad
  077B2A  02AA: e9ff01           jmp 0x4ac
  077B2D  02AD: 68cf24           push 0x24cf
  077B30  02B0: 8d46b0           lea ax, [bp - 0x50]
  077B33  02B3: 50               push ax
  077B34  02B4: 9ae4071d0d       lcall 0xd1d, 0x7e4
  077B39  02B9: 83c404           add sp, 4
  077B3C  02BC: ff76ae           push word ptr [bp - 0x52]
  077B3F  02BF: 8d46b0           lea ax, [bp - 0x50]
  077B42  02C2: 50               push ax
  077B43  02C3: 9aa4071d0d       lcall 0xd1d, 0x7a4
  077B48  02C8: 83c404           add sp, 4
  077B4B  02CB: 68d724           push 0x24d7
  077B4E  02CE: 8d46b0           lea ax, [bp - 0x50]
  077B51  02D1: 50               push ax
  077B52  02D2: 9aa4071d0d       lcall 0xd1d, 0x7a4
  077B57  02D7: 83c404           add sp, 4
  077B5A  02DA: 56               push si
  077B5B  02DB: 8d46b0           lea ax, [bp - 0x50]
  077B5E  02DE: 50               push ax
  077B5F  02DF: 9aa4071d0d       lcall 0xd1d, 0x7a4
  077B64  02E4: 83c404           add sp, 4
  077B67  02E7: 68e524           push 0x24e5
  077B6A  02EA: 8d46b0           lea ax, [bp - 0x50]
  077B6D  02ED: 50               push ax
  077B6E  02EE: 9aa4071d0d       lcall 0xd1d, 0x7a4
  077B73  02F3: 83c404           add sp, 4
  077B76  02F6: 57               push di
  077B77  02F7: 8d46b0           lea ax, [bp - 0x50]
  077B7A  02FA: 50               push ax
  077B7B  02FB: 9aa4071d0d       lcall 0xd1d, 0x7a4
  077B80  0300: 83c404           add sp, 4
  077B83  0303: 68ee24           push 0x24ee
  077B86  0306: 8d46b0           lea ax, [bp - 0x50]
  077B89  0309: 50               push ax
  077B8A  030A: 9aa4071d0d       lcall 0xd1d, 0x7a4
  077B8F  030F: 83c404           add sp, 4
  077B92  0312: ff760a           push word ptr [bp + 0xa]
  077B95  0315: 8d46b0           lea ax, [bp - 0x50]
  077B98  0318: 50               push ax
  077B99  0319: 9aa4071d0d       lcall 0xd1d, 0x7a4
  077B9E  031E: 83c404           add sp, 4
  077BA1  0321: 8d46b0           lea ax, [bp - 0x50]
  077BA4  0324: 16               push ss
  077BA5  0325: 50               push ax
  077BA6  0326: b80100           mov ax, 1
  077BA9  0329: 9a260f1f1a       lcall 0x1a1f, 0xf26
  077BAE  032E: 687824           push 0x2478
  077BB1  0331: 9a42081d0d       lcall 0xd1d, 0x842
  077BB6  0336: 83c402           add sp, 2
  077BB9  0339: 0bc0             or ax, ax
  077BBB  033B: 740c             je 0x349
  077BBD  033D: 1e               push ds
  077BBE  033E: 687824           push 0x2478
  077BC1  0341: b80100           mov ax, 1
  077BC4  0344: 9a260f1f1a       lcall 0x1a1f, 0xf26
  077BC9  0349: 803e4f2600       cmp byte ptr [0x264f], 0
  077BCE  034E: 7503             jne 0x353
  077BD0  0350: e98200           jmp 0x3d5
  077BD3  0353: 6a0a             push 0xa
  077BD5  0355: ff76ac           push word ptr [bp - 0x54]
  077BD8  0358: ff365426         push word ptr [0x2654]
  077BDC  035C: ff365226         push word ptr [0x2652]
  077BE0  0360: 9a16091d0d       lcall 0xd1d, 0x916
  077BE5  0365: 83c408           add sp, 8
  077BE8  0368: 6a0a             push 0xa
  077BEA  036A: ff760a           push word ptr [bp + 0xa]
  077BED  036D: ff365826         push word ptr [0x2658]
  077BF1  0371: ff365626         push word ptr [0x2656]
  077BF5  0375: 9a16091d0d       lcall 0xd1d, 0x916
  077BFA  037A: 83c408           add sp, 8
  077BFD  037D: 68f024           push 0x24f0
  077C00  0380: 8d46b0           lea ax, [bp - 0x50]
  077C03  0383: 50               push ax
  077C04  0384: 9ae4071d0d       lcall 0xd1d, 0x7e4
  077C09  0389: 83c404           add sp, 4
  077C0C  038C: ff76ac           push word ptr [bp - 0x54]
  077C0F  038F: 8d46b0           lea ax, [bp - 0x50]
  077C12  0392: 50               push ax
  077C13  0393: 9aa4071d0d       lcall 0xd1d, 0x7a4
  077C18  0398: 83c404           add sp, 4
  077C1B  039B: 680325           push 0x2503
  077C1E  039E: 8d46b0           lea ax, [bp - 0x50]
  077C21  03A1: 50               push ax
  077C22  03A2: 9aa4071d0d       lcall 0xd1d, 0x7a4
  077C27  03A7: 83c404           add sp, 4
  077C2A  03AA: ff760a           push word ptr [bp + 0xa]
  077C2D  03AD: 8d46b0           lea ax, [bp - 0x50]
  077C30  03B0: 50               push ax
  077C31  03B1: 9aa4071d0d       lcall 0xd1d, 0x7a4
  077C36  03B6: 83c404           add sp, 4
  077C39  03B9: 681525           push 0x2515
  077C3C  03BC: 8d46b0           lea ax, [bp - 0x50]
  077C3F  03BF: 50               push ax
  077C40  03C0: 9aa4071d0d       lcall 0xd1d, 0x7a4
  077C45  03C5: 83c404           add sp, 4
  077C48  03C8: 8d46b0           lea ax, [bp - 0x50]
  077C4B  03CB: 16               push ss
  077C4C  03CC: 50               push ax
  077C4D  03CD: b80100           mov ax, 1
  077C50  03D0: 9a260f1f1a       lcall 0x1a1f, 0xf26
  077C55  03D5: 1e               push ds
  077C56  03D6: 682725           push 0x2527
  077C59  03D9: b80100           mov ax, 1
  077C5C  03DC: 9a260f1f1a       lcall 0x1a1f, 0xf26
  077C61  03E1: 682925           push 0x2529
  077C64  03E4: 8d46b0           lea ax, [bp - 0x50]
  077C67  03E7: 50               push ax
  077C68  03E8: 9ae4071d0d       lcall 0xd1d, 0x7e4
  077C6D  03ED: 83c404           add sp, 4
  077C70  03F0: 6a0a             push 0xa
  077C72  03F2: ff76ac           push word ptr [bp - 0x54]
  077C75  03F5: ff7608           push word ptr [bp + 8]
  077C78  03F8: ff7606           push word ptr [bp + 6]
  077C7B  03FB: 9a16091d0d       lcall 0xd1d, 0x916
  077C80  0400: 83c408           add sp, 8
  077C83  0403: ff76ac           push word ptr [bp - 0x54]
  077C86  0406: 8d46b0           lea ax, [bp - 0x50]
  077C89  0409: 50               push ax
  077C8A  040A: 9aa4071d0d       lcall 0xd1d, 0x7a4
  077C8F  040F: 83c404           add sp, 4
  077C92  0412: 8d46b0           lea ax, [bp - 0x50]
  077C95  0415: 16               push ss
  077C96  0416: 50               push ax
  077C97  0417: b80100           mov ax, 1
  077C9A  041A: 9a260f1f1a       lcall 0x1a1f, 0xf26
  077C9F  041F: 684425           push 0x2544
  077CA2  0422: 8d46b0           lea ax, [bp - 0x50]
  077CA5  0425: 50               push ax
  077CA6  0426: 9ae4071d0d       lcall 0xd1d, 0x7e4
  077CAB  042B: 83c404           add sp, 4
  077CAE  042E: 6a0a             push 0xa
  077CB0  0430: ff76ac           push word ptr [bp - 0x54]
  077CB3  0433: ff36ac27         push word ptr [0x27ac]
  077CB7  0437: 9afa081d0d       lcall 0xd1d, 0x8fa
  077CBC  043C: 83c406           add sp, 6
  077CBF  043F: ff76ac           push word ptr [bp - 0x54]
  077CC2  0442: 8d46b0           lea ax, [bp - 0x50]
  077CC5  0445: 50               push ax
  077CC6  0446: 9aa4071d0d       lcall 0xd1d, 0x7a4
  077CCB  044B: 83c404           add sp, 4
  077CCE  044E: 8d46b0           lea ax, [bp - 0x50]
  077CD1  0451: 16               push ss
  077CD2  0452: 50               push ax
  077CD3  0453: b80100           mov ax, 1
  077CD6  0456: 9a260f1f1a       lcall 0x1a1f, 0xf26
  077CDB  045B: 685f25           push 0x255f
  077CDE  045E: 8d46b0           lea ax, [bp - 0x50]
  077CE1  0461: 50               push ax
  077CE2  0462: 9ae4071d0d       lcall 0xd1d, 0x7e4
  077CE7  0467: 83c404           add sp, 4
  077CEA  046A: 6a0a             push 0xa
  077CEC  046C: ff76ac           push word ptr [bp - 0x54]
  077CEF  046F: 9abc081f18       lcall 0x181f, 0x8bc
  077CF4  0474: 50               push ax
  077CF5  0475: 9afa081d0d       lcall 0xd1d, 0x8fa
  077CFA  047A: 83c406           add sp, 6
  077CFD  047D: ff76ac           push word ptr [bp - 0x54]
  077D00  0480: 8d46b0           lea ax, [bp - 0x50]
  077D03  0483: 50               push ax
  077D04  0484: 9aa4071d0d       lcall 0xd1d, 0x7a4
  077D09  0489: 83c404           add sp, 4
  077D0C  048C: 8d46b0           lea ax, [bp - 0x50]
  077D0F  048F: 16               push ss
  077D10  0490: 50               push ax
  077D11  0491: b80100           mov ax, 1
  077D14  0494: 9a260f1f1a       lcall 0x1a1f, 0xf26
  077D19  0499: 1e               push ds
  077D1A  049A: 687a25           push 0x257a
  077D1D  049D: b80100           mov ax, 1
  077D20  04A0: 9a260f1f1a       lcall 0x1a1f, 0xf26
  077D25  04A5: 8d1e7c25         lea bx, [0x257c]
  077D29  04A9: eb05             jmp 0x4b0
  077D2B  04AB: 90               nop 
  077D2C  04AC: 8d1e8725         lea bx, [0x2587]
  077D30  04B0: 0e               push cs
  077D31  04B1: e8c700           call 0x57b
  077D34  04B4: a17424           mov ax, word ptr [0x2474]
  077D37  04B7: 0b067224         or ax, word ptr [0x2472]
  077D3B  04BB: 7404             je 0x4c1
  077D3D  04BD: ff1e7224         lcall [0x2472]
  077D41  04C1: a17024           mov ax, word ptr [0x2470]
  077D44  04C4: 0b066e24         or ax, word ptr [0x246e]
  077D48  04C8: 7404             je 0x4ce
  077D4A  04CA: ff1e6e24         lcall [0x246e]
  077D4E  04CE: 6a03             push 3
  077D50  04D0: 9a0d031d0d       lcall 0xd1d, 0x30d
  077D55  04D5: 83c402           add sp, 2
  077D58  04D8: 5e               pop si
  077D59  04D9: 5f               pop di
  077D5A  04DA: c9               leave 
  077D5B  04DB: c20800           ret 8

; ---- func_077D5E  size=162  insns=64  prologue=ENTER 0x006A,0  terminal=page-end ----
  077D5E  04DE: c86a0000         enter 0x6a, 0
  077D62  04E2: 53               push bx
  077D63  04E3: 52               push dx
  077D64  04E4: 50               push ax
  077D65  04E5: 57               push di
  077D66  04E6: 56               push si
  077D67  04E7: 8bfb             mov di, bx
  077D69  04E9: 8bf0             mov si, ax
  077D6B  04EB: c746fe0000       mov word ptr [bp - 2], 0
  077D70  04F0: a17624           mov ax, word ptr [0x2476]
  077D73  04F3: 3bd0             cmp dx, ax
  077D75  04F5: 7c79             jl 0x570
  077D77  04F7: 6a0a             push 0xa
  077D79  04F9: 8d46be           lea ax, [bp - 0x42]
  077D7C  04FC: 50               push ax
  077D7D  04FD: 56               push si
  077D7E  04FE: 9afa081d0d       lcall 0xd1d, 0x8fa
  077D83  0503: 83c406           add sp, 6
  077D86  0506: 6a0a             push 0xa
  077D88  0508: 8d4696           lea ax, [bp - 0x6a]
  077D8B  050B: 50               push ax
  077D8C  050C: 57               push di
  077D8D  050D: 9afa081d0d       lcall 0xd1d, 0x8fa
  077D92  0512: 83c406           add sp, 6
  077D95  0515: 6a0a             push 0xa
  077D97  0517: 8d46f2           lea ax, [bp - 0xe]
  077D9A  051A: 50               push ax
  077D9B  051B: ff760c           push word ptr [bp + 0xc]
  077D9E  051E: ff760a           push word ptr [bp + 0xa]
  077DA1  0521: 9a16091d0d       lcall 0xd1d, 0x916
  077DA6  0526: 83c408           add sp, 8
  077DA9  0529: 6a0a             push 0xa
  077DAB  052B: 8d46e6           lea ax, [bp - 0x1a]
  077DAE  052E: 50               push ax
  077DAF  052F: ff7608           push word ptr [bp + 8]
  077DB2  0532: ff7606           push word ptr [bp + 6]
  077DB5  0535: 9a16091d0d       lcall 0xd1d, 0x916
  077DBA  053A: 83c408           add sp, 8
  077DBD  053D: 8bd6             mov dx, si
  077DBF  053F: f7d2             not dx
  077DC1  0541: 42               inc dx
  077DC2  0542: 8d5ebe           lea bx, [bp - 0x42]
  077DC5  0545: 8d069225         lea ax, [0x2592]
  077DC9  0549: e8c4fb           call 0x110
  077DCC  054C: 8bd7             mov dx, di
  077DCE  054E: 8d5e96           lea bx, [bp - 0x6a]
  077DD1  0551: 8d069d25         lea ax, [0x259d]
  077DD5  0555: e8b8fb           call 0x110
  077DD8  0558: 8d46e6           lea ax, [bp - 0x1a]
  077DDB  055B: 50               push ax
  077DDC  055C: 9a7a021f19       lcall 0x191f, 0x27a
  077DE1  0561: 52               push dx
  077DE2  0562: 50               push ax
  077DE3  0563: 56               push si
  077DE4  0564: 8d5ebe           lea bx, [bp - 0x42]
  077DE7  0567: 8d4696           lea ax, [bp - 0x6a]
  077DEA  056A: 8d56f2           lea dx, [bp - 0xe]
  077DED  056D: e820fd           call 0x290
  077DF0  0570: 5e               pop si
  077DF1  0571: 5f               pop di
  077DF2  0572: c9               leave 
  077DF3  0573: ca0800           retf 8
  077DF6  0576: ead4031f18       ljmp 0x181f:0x3d4
  077DFB  057B: ea1a0f1f1a       ljmp 0x1a1f:0xf1a
