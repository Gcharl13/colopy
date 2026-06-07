; ============================================================
; VICEROY.EXE overlay page 0x15 (record 20) -- RE-SEGMENTED
; file_offset (disk image) = 0x066680
; code_offset (first insn) = 0x066850
; code_end (next reloc hdr)= 0x068980  [resident size 531 para -> nominal_end 0x0687B0; on-disk code spills past it]
; reloc_count = 105  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x066680)
; functions in page = 37
; ============================================================

; ---- func_066850  size=51  insns=17  prologue=ENTER 0x0108,0  terminal=RETF ----
  066850  01D0: c8080100         enter 0x108, 0
  066854  01D4: b81000           mov ax, 0x10
  066857  01D7: 8946f8           mov word ptr [bp - 8], ax
  06685A  01DA: 8946fa           mov word ptr [bp - 6], ax
  06685D  01DD: 8d86f8fe         lea ax, [bp - 0x108]
  066861  01E1: 8946fc           mov word ptr [bp - 4], ax
  066864  01E4: 8c56fe           mov word ptr [bp - 2], ss
  066867  01E7: ff367601         push word ptr [0x176]
  06686B  01EB: ff367401         push word ptr [0x174]
  06686F  01EF: 6a00             push 0
  066871  01F1: 8b4606           mov ax, word ptr [bp + 6]
  066874  01F4: 8d5ef8           lea bx, [bp - 8]
  066877  01F7: 2bd2             sub dx, dx
  066879  01F9: 9a54021f18       lcall 0x181f, 0x254
  06687E  01FE: 8a4680           mov al, byte ptr [bp - 0x80]
  066881  0201: c9               leave 
  066882  0202: cb               retf 

; ---- func_066884  size=228  insns=92  prologue=ENTER 0x0108,0  terminal=RETF ----
  066884  0204: c8080100         enter 0x108, 0
  066888  0208: b81000           mov ax, 0x10
  06688B  020B: 8946f8           mov word ptr [bp - 8], ax
  06688E  020E: 8946fa           mov word ptr [bp - 6], ax
  066891  0211: 8d86f8fe         lea ax, [bp - 0x108]
  066895  0215: 8946fc           mov word ptr [bp - 4], ax
  066898  0218: 8c56fe           mov word ptr [bp - 2], ss
  06689B  021B: 6a00             push 0
  06689D  021D: 6a00             push 0
  06689F  021F: 8d46f8           lea ax, [bp - 8]
  0668A2  0222: 50               push ax
  0668A3  0223: ff7606           push word ptr [bp + 6]
  0668A6  0226: ff366e01         push word ptr [0x16e]
  0668AA  022A: ff366c01         push word ptr [0x16c]
  0668AE  022E: 9a5e021f18       lcall 0x181f, 0x25e
  0668B3  0233: 8a4680           mov al, byte ptr [bp - 0x80]
  0668B6  0236: c9               leave 
  0668B7  0237: cb               retf 
  0668B8  0238: 56               push si
  0668B9  0239: 2bf6             sub si, si
  0668BB  023B: 56               push si
  0668BC  023C: 0e               push cs
  0668BD  023D: e84105           call 0x781
  0668C0  0240: 83c402           add sp, 2
  0668C3  0243: 888476a5         mov byte ptr [si - 0x5a8a], al
  0668C7  0247: 56               push si
  0668C8  0248: 0e               push cs
  0668C9  0249: e83505           call 0x781
  0668CC  024C: 83c402           add sp, 2
  0668CF  024F: 888486a5         mov byte ptr [si - 0x5a7a], al
  0668D3  0253: 56               push si
  0668D4  0254: 0e               push cs
  0668D5  0255: e82905           call 0x781
  0668D8  0258: 83c402           add sp, 2
  0668DB  025B: 88847ea5         mov byte ptr [si - 0x5a82], al
  0668DF  025F: 46               inc si
  0668E0  0260: 83fe08           cmp si, 8
  0668E3  0263: 7cd6             jl 0x23b
  0668E5  0265: 6a18             push 0x18
  0668E7  0267: 0e               push cs
  0668E8  0268: e81605           call 0x781
  0668EB  026B: 83c402           add sp, 2
  0668EE  026E: a28ea5           mov byte ptr [0xa58e], al
  0668F1  0271: 6a19             push 0x19
  0668F3  0273: 0e               push cs
  0668F4  0274: e80a05           call 0x781
  0668F7  0277: 83c402           add sp, 2
  0668FA  027A: a28fa5           mov byte ptr [0xa58f], al
  0668FD  027D: 6a1a             push 0x1a
  0668FF  027F: 0e               push cs
  066900  0280: e8fe04           call 0x781
  066903  0283: 83c402           add sp, 2
  066906  0286: a290a5           mov byte ptr [0xa590], al
  066909  0289: 6a21             push 0x21
  06690B  028B: 0e               push cs
  06690C  028C: e8ed04           call 0x77c
  06690F  028F: 83c402           add sp, 2
  066912  0292: a291a5           mov byte ptr [0xa591], al
  066915  0295: 6a31             push 0x31
  066917  0297: 0e               push cs
  066918  0298: e8e104           call 0x77c
  06691B  029B: 83c402           add sp, 2
  06691E  029E: a292a5           mov byte ptr [0xa592], al
  066921  02A1: 5e               pop si
  066922  02A2: cb               retf 
  066923  02A3: 90               nop 
  066924  02A4: 2bc0             sub ax, ax
  066926  02A6: cb               retf 
  066927  02A7: 90               nop 
  066928  02A8: a17e01           mov ax, word ptr [0x17e]
  06692B  02AB: 2d1300           sub ax, 0x13
  06692E  02AE: a3ca9c           mov word ptr [0x9cca], ax
  066931  02B1: a13a85           mov ax, word ptr [0x853a]
  066934  02B4: 2d3900           sub ax, 0x39
  066937  02B7: 50               push ax
  066938  02B8: 6a01             push 1
  06693A  02BA: a17c01           mov ax, word ptr [0x17c]
  06693D  02BD: 2d1c00           sub ax, 0x1c
  066940  02C0: a3cc9c           mov word ptr [0x9ccc], ax
  066943  02C3: 50               push ax
  066944  02C4: 9a5c031f18       lcall 0x181f, 0x35c
  066949  02C9: 83c406           add sp, 6
  06694C  02CC: a3cc9c           mov word ptr [0x9ccc], ax
  06694F  02CF: a13c85           mov ax, word ptr [0x853c]
  066952  02D2: 2d2800           sub ax, 0x28
  066955  02D5: 50               push ax
  066956  02D6: 6a01             push 1
  066958  02D8: ff36ca9c         push word ptr [0x9cca]
  06695C  02DC: 9a5c031f18       lcall 0x181f, 0x35c
  066961  02E1: 83c406           add sp, 6
  066964  02E4: a3ca9c           mov word ptr [0x9cca], ax
  066967  02E7: cb               retf 

; ---- func_066968  size=558  insns=201  prologue=ENTER 0x0038,0  terminal=RETF ----
  066968  02E8: c8380000         enter 0x38, 0
  06696C  02EC: 57               push di
  06696D  02ED: 56               push si
  06696E  02EE: 837e0e00         cmp word ptr [bp + 0xe], 0
  066972  02F2: 7c0e             jl 0x302
  066974  02F4: 8a4e0e           mov cl, byte ptr [bp + 0xe]
  066977  02F7: b81000           mov ax, 0x10
  06697A  02FA: d3e0             shl ax, cl
  06697C  02FC: 8946e2           mov word ptr [bp - 0x1e], ax
  06697F  02FF: eb06             jmp 0x307
  066981  0301: 90               nop 
  066982  0302: c746e20000       mov word ptr [bp - 0x1e], 0
  066987  0307: 8b7606           mov si, word ptr [bp + 6]
  06698A  030A: 8b7e08           mov di, word ptr [bp + 8]
  06698D  030D: 57               push di
  06698E  030E: 56               push si
  06698F  030F: 9a0e071f18       lcall 0x181f, 0x70e
  066994  0314: 83c404           add sp, 4
  066997  0317: 8946d6           mov word ptr [bp - 0x2a], ax
  06699A  031A: 8956d8           mov word ptr [bp - 0x28], dx
  06699D  031D: 57               push di
  06699E  031E: 56               push si
  06699F  031F: 9a40071f18       lcall 0x181f, 0x740
  0669A4  0324: 83c404           add sp, 4
  0669A7  0327: 8946d2           mov word ptr [bp - 0x2e], ax
  0669AA  032A: 8956d4           mov word ptr [bp - 0x2c], dx
  0669AD  032D: 57               push di
  0669AE  032E: 56               push si
  0669AF  032F: 9a36071f18       lcall 0x181f, 0x736
  0669B4  0334: 83c404           add sp, 4
  0669B7  0337: 8946ce           mov word ptr [bp - 0x32], ax
  0669BA  033A: 8956d0           mov word ptr [bp - 0x30], dx
  0669BD  033D: 57               push di
  0669BE  033E: 56               push si
  0669BF  033F: 9aa0061f18       lcall 0x181f, 0x6a0
  0669C4  0344: 83c404           add sp, 4
  0669C7  0347: 8946ca           mov word ptr [bp - 0x36], ax
  0669CA  034A: 8956cc           mov word ptr [bp - 0x34], dx
  0669CD  034D: 8bc6             mov ax, si
  0669CF  034F: 2b06cc9c         sub ax, word ptr [0x9ccc]
  0669D3  0353: 05fc00           add ax, 0xfc
  0669D6  0356: 8bd7             mov dx, di
  0669D8  0358: 2b16ca9c         sub dx, word ptr [0x9cca]
  0669DC  035C: 83c209           add dx, 9
  0669DF  035F: 8d1ea82d         lea bx, [0x2da8]
  0669E3  0363: 9a90021f18       lcall 0x181f, 0x290
  0669E8  0368: 8946da           mov word ptr [bp - 0x26], ax
  0669EB  036B: 8956dc           mov word ptr [bp - 0x24], dx
  0669EE  036E: a13a85           mov ax, word ptr [0x853a]
  0669F1  0371: 8946e0           mov word ptr [bp - 0x20], ax
  0669F4  0374: a1aa2d           mov ax, word ptr [0x2daa]
  0669F7  0377: 8946de           mov word ptr [bp - 0x22], ax
  0669FA  037A: c746e60000       mov word ptr [bp - 0x1a], 0
  0669FF  037F: 837e0c00         cmp word ptr [bp + 0xc], 0
  066A03  0383: 7f03             jg 0x388
  066A05  0385: e98a01           jmp 0x512
  066A08  0388: 8b4e0a           mov cx, word ptr [bp + 0xa]
  066A0B  038B: c746fe0000       mov word ptr [bp - 2], 0
  066A10  0390: 0bc9             or cx, cx
  066A12  0392: 7f03             jg 0x397
  066A14  0394: e94501           jmp 0x4dc
  066A17  0397: c45ed6           les bx, ptr [bp - 0x2a]
  066A1A  039A: ff46d6           inc word ptr [bp - 0x2a]
  066A1D  039D: 268a07           mov al, byte ptr es:[bx]
  066A20  03A0: 8846e5           mov byte ptr [bp - 0x1b], al
  066A23  03A3: c45eca           les bx, ptr [bp - 0x36]
  066A26  03A6: ff46ca           inc word ptr [bp - 0x36]
  066A29  03A9: 268a07           mov al, byte ptr es:[bx]
  066A2C  03AC: 8846e4           mov byte ptr [bp - 0x1c], al
  066A2F  03AF: c45ed2           les bx, ptr [bp - 0x2e]
  066A32  03B2: ff46d2           inc word ptr [bp - 0x2e]
  066A35  03B5: 268a07           mov al, byte ptr es:[bx]
  066A38  03B8: 8846fc           mov byte ptr [bp - 4], al
  066A3B  03BB: c45ece           les bx, ptr [bp - 0x32]
  066A3E  03BE: ff46ce           inc word ptr [bp - 0x32]
  066A41  03C1: 268a07           mov al, byte ptr es:[bx]
  066A44  03C4: 8846fd           mov byte ptr [bp - 3], al
  066A47  03C7: 837e1000         cmp word ptr [bp + 0x10], 0
  066A4B  03CB: 7407             je 0x3d4
  066A4D  03CD: c646fd0f         mov byte ptr [bp - 3], 0xf
  066A51  03D1: e9ec00           jmp 0x4c0
  066A54  03D4: 837ee200         cmp word ptr [bp - 0x1e], 0
  066A58  03D8: 7410             je 0x3ea
  066A5A  03DA: 8a46fd           mov al, byte ptr [bp - 3]
  066A5D  03DD: 2ae4             sub ah, ah
  066A5F  03DF: 8546e2           test word ptr [bp - 0x1e], ax
  066A62  03E2: 7506             jne 0x3ea
  066A64  03E4: 8866fd           mov byte ptr [bp - 3], ah
  066A67  03E7: e9d600           jmp 0x4c0
  066A6A  03EA: c646fd00         mov byte ptr [bp - 3], 0
  066A6E  03EE: f646fc02         test byte ptr [bp - 4], 2
  066A72  03F2: 7422             je 0x416
  066A74  03F4: 8a56e4           mov dl, byte ptr [bp - 0x1c]
  066A77  03F7: c0ea04           shr dl, 4
  066A7A  03FA: 2af6             sub dh, dh
  066A7C  03FC: 83fa04           cmp dx, 4
  066A7F  03FF: 7c09             jl 0x40a
  066A81  0401: 8bda             mov bx, dx
  066A83  0403: 8a874808         mov al, byte ptr [bx + 0x848]
  066A87  0407: eb07             jmp 0x410
  066A89  0409: 90               nop 
  066A8A  040A: 8bda             mov bx, dx
  066A8C  040C: 8a874808         mov al, byte ptr [bx + 0x848]
  066A90  0410: 8846fd           mov byte ptr [bp - 3], al
  066A93  0413: eb7c             jmp 0x491
  066A95  0415: 90               nop 
  066A96  0416: f646fc01         test byte ptr [bp - 4], 1
  066A9A  041A: 7475             je 0x491
  066A9C  041C: 8b4606           mov ax, word ptr [bp + 6]
  066A9F  041F: 0346fe           add ax, word ptr [bp - 2]
  066AA2  0422: 8b56e6           mov dx, word ptr [bp - 0x1a]
  066AA5  0425: 035608           add dx, word ptr [bp + 8]
  066AA8  0428: 9ae0071f18       lcall 0x181f, 0x7e0
  066AAD  042D: 8bf0             mov si, ax
  066AAF  042F: 0bf6             or si, si
  066AB1  0431: 7c5e             jl 0x491
  066AB3  0433: 6bde1c           imul bx, si, 0x1c
  066AB6  0436: 8a874731         mov al, byte ptr [bx + 0x3147]
  066ABA  043A: 2ae4             sub ah, ah
  066ABC  043C: 8a4e0e           mov cl, byte ptr [bp + 0xe]
  066ABF  043F: ba1000           mov dx, 0x10
  066AC2  0442: d3e2             shl dx, cl
  066AC4  0444: 85c2             test dx, ax
  066AC6  0446: 7507             jne 0x44f
  066AC8  0448: 833ea25300       cmp word ptr [0x53a2], 0
  066ACD  044D: 7442             je 0x491
  066ACF  044F: 8a46e4           mov al, byte ptr [bp - 0x1c]
  066AD2  0452: c0e804           shr al, 4
  066AD5  0455: 2ae4             sub ah, ah
  066AD7  0457: 8bf8             mov di, ax
  066AD9  0459: 83ff04           cmp di, 4
  066ADC  045C: 7c08             jl 0x466
  066ADE  045E: 8a854808         mov al, byte ptr [di + 0x848]
  066AE2  0462: eb06             jmp 0x46a
  066AE4  0464: 90               nop 
  066AE5  0465: 90               nop 
  066AE6  0466: 8a854808         mov al, byte ptr [di + 0x848]
  066AEA  046A: 8846fd           mov byte ptr [bp - 3], al
  066AED  046D: 80bf463110       cmp byte ptr [bx + 0x3146], 0x10
  066AF2  0472: 751d             jne 0x491
  066AF4  0474: 8a874731         mov al, byte ptr [bx + 0x3147]
  066AF8  0478: 240f             and al, 0xf
  066AFA  047A: 3a460e           cmp al, byte ptr [bp + 0xe]
  066AFD  047D: 7412             je 0x491
  066AFF  047F: 833ea25300       cmp word ptr [0x53a2], 0
  066B04  0484: 750b             jne 0x491
  066B06  0486: 83bf5e3100       cmp word ptr [bx + 0x315e], 0
  066B0B  048B: 7d04             jge 0x491
  066B0D  048D: c646fd08         mov byte ptr [bp - 3], 8
  066B11  0491: 807efd00         cmp byte ptr [bp - 3], 0
  066B15  0495: 7529             jne 0x4c0
  066B17  0497: f646e520         test byte ptr [bp - 0x1b], 0x20
  066B1B  049B: 7413             je 0x4b0
  066B1D  049D: 8a46e5           mov al, byte ptr [bp - 0x1b]
  066B20  04A0: 2480             and al, 0x80
  066B22  04A2: 3c01             cmp al, 1
  066B24  04A4: 1ac0             sbb al, al
  066B26  04A6: 2401             and al, 1
  066B28  04A8: 041b             add al, 0x1b
  066B2A  04AA: 8846e5           mov byte ptr [bp - 0x1b], al
  066B2D  04AD: eb05             jmp 0x4b4
  066B2F  04AF: 90               nop 
  066B30  04B0: 8066e51f         and byte ptr [bp - 0x1b], 0x1f
  066B34  04B4: 8a5ee5           mov bl, byte ptr [bp - 0x1b]
  066B37  04B7: 2aff             sub bh, bh
  066B39  04B9: 8a8776a5         mov al, byte ptr [bx - 0x5a8a]
  066B3D  04BD: 8846fd           mov byte ptr [bp - 3], al
  066B40  04C0: 8a46fd           mov al, byte ptr [bp - 3]
  066B43  04C3: c45eda           les bx, ptr [bp - 0x26]
  066B46  04C6: ff46da           inc word ptr [bp - 0x26]
  066B49  04C9: 268807           mov byte ptr es:[bx], al
  066B4C  04CC: 8b460a           mov ax, word ptr [bp + 0xa]
  066B4F  04CF: ff46fe           inc word ptr [bp - 2]
  066B52  04D2: 3946fe           cmp word ptr [bp - 2], ax
  066B55  04D5: 7d03             jge 0x4da
  066B57  04D7: e9bdfe           jmp 0x397
  066B5A  04DA: 8bc8             mov cx, ax
  066B5C  04DC: 8b46e0           mov ax, word ptr [bp - 0x20]
  066B5F  04DF: 2bc1             sub ax, cx
  066B61  04E1: 0146d6           add word ptr [bp - 0x2a], ax
  066B64  04E4: 8b46e0           mov ax, word ptr [bp - 0x20]
  066B67  04E7: 2bc1             sub ax, cx
  066B69  04E9: 0146d2           add word ptr [bp - 0x2e], ax
  066B6C  04EC: 8b46e0           mov ax, word ptr [bp - 0x20]
  066B6F  04EF: 2bc1             sub ax, cx
  066B71  04F1: 0146ca           add word ptr [bp - 0x36], ax
  066B74  04F4: 8b46e0           mov ax, word ptr [bp - 0x20]
  066B77  04F7: 2bc1             sub ax, cx
  066B79  04F9: 0146ce           add word ptr [bp - 0x32], ax
  066B7C  04FC: 8b46de           mov ax, word ptr [bp - 0x22]
  066B7F  04FF: 2bc1             sub ax, cx
  066B81  0501: 0146da           add word ptr [bp - 0x26], ax
  066B84  0504: 8b460c           mov ax, word ptr [bp + 0xc]
  066B87  0507: ff46e6           inc word ptr [bp - 0x1a]
  066B8A  050A: 3946e6           cmp word ptr [bp - 0x1a], ax
  066B8D  050D: 7d03             jge 0x512
  066B8F  050F: e979fe           jmp 0x38b
  066B92  0512: 5e               pop si
  066B93  0513: 5f               pop di
  066B94  0514: c9               leave 
  066B95  0515: cb               retf 

; ---- func_066B96  size=26  insns=12  prologue=push bp;mov bp,sp  terminal=RETF ----
  066B96  0516: 55               push bp
  066B97  0517: 8bec             mov bp, sp
  066B99  0519: 6a00             push 0
  066B9B  051B: ff7606           push word ptr [bp + 6]
  066B9E  051E: 6a27             push 0x27
  066BA0  0520: 6a38             push 0x38
  066BA2  0522: ff36ca9c         push word ptr [0x9cca]
  066BA6  0526: ff36cc9c         push word ptr [0x9ccc]
  066BAA  052A: 0e               push cs
  066BAB  052B: e84902           call 0x777
  066BAE  052E: c9               leave 
  066BAF  052F: cb               retf 

; ---- func_066BB0  size=293  insns=107  prologue=ENTER 0x0004,0  terminal=RETF ----
  066BB0  0530: c8040000         enter 4, 0
  066BB4  0534: 57               push di
  066BB5  0535: 56               push si
  066BB6  0536: 8b7e06           mov di, word ptr [bp + 6]
  066BB9  0539: 8b7608           mov si, word ptr [bp + 8]
  066BBC  053C: 0e               push cs
  066BBD  053D: e83202           call 0x772
  066BC0  0540: 8bc6             mov ax, si
  066BC2  0542: 3b36ca9c         cmp si, word ptr [0x9cca]
  066BC6  0546: 7d04             jge 0x54c
  066BC8  0548: 8b36ca9c         mov si, word ptr [0x9cca]
  066BCC  054C: 8976fe           mov word ptr [bp - 2], si
  066BCF  054F: 03460c           add ax, word ptr [bp + 0xc]
  066BD2  0552: 48               dec ax
  066BD3  0553: 8b0eca9c         mov cx, word ptr [0x9cca]
  066BD7  0557: 83c126           add cx, 0x26
  066BDA  055A: 3bc1             cmp ax, cx
  066BDC  055C: 7e02             jle 0x560
  066BDE  055E: 8bc1             mov ax, cx
  066BE0  0560: 2bc6             sub ax, si
  066BE2  0562: 40               inc ax
  066BE3  0563: 7902             jns 0x567
  066BE5  0565: 2bc0             sub ax, ax
  066BE7  0567: 89460c           mov word ptr [bp + 0xc], ax
  066BEA  056A: 8bc7             mov ax, di
  066BEC  056C: 037e0a           add di, word ptr [bp + 0xa]
  066BEF  056F: 3b06cc9c         cmp ax, word ptr [0x9ccc]
  066BF3  0573: 7d03             jge 0x578
  066BF5  0575: a1cc9c           mov ax, word ptr [0x9ccc]
  066BF8  0578: 8946fc           mov word ptr [bp - 4], ax
  066BFB  057B: 8d4dff           lea cx, [di - 1]
  066BFE  057E: 8b16cc9c         mov dx, word ptr [0x9ccc]
  066C02  0582: 83c237           add dx, 0x37
  066C05  0585: 3bca             cmp cx, dx
  066C07  0587: 7e02             jle 0x58b
  066C09  0589: 8bca             mov cx, dx
  066C0B  058B: 2bc8             sub cx, ax
  066C0D  058D: 41               inc cx
  066C0E  058E: 7902             jns 0x592
  066C10  0590: 2bc9             sub cx, cx
  066C12  0592: 894e0a           mov word ptr [bp + 0xa], cx
  066C15  0595: 0bc9             or cx, cx
  066C17  0597: 7503             jne 0x59c
  066C19  0599: e9b500           jmp 0x651
  066C1C  059C: 837e0c00         cmp word ptr [bp + 0xc], 0
  066C20  05A0: 7503             jne 0x5a5
  066C22  05A2: e9ac00           jmp 0x651
  066C25  05A5: ff7612           push word ptr [bp + 0x12]
  066C28  05A8: ff7610           push word ptr [bp + 0x10]
  066C2B  05AB: ff760c           push word ptr [bp + 0xc]
  066C2E  05AE: 51               push cx
  066C2F  05AF: ff76fe           push word ptr [bp - 2]
  066C32  05B2: ff76fc           push word ptr [bp - 4]
  066C35  05B5: 0e               push cs
  066C36  05B6: e8be01           call 0x777
  066C39  05B9: 83c40c           add sp, 0xc
  066C3C  05BC: ff36ae2d         push word ptr [0x2dae]
  066C40  05C0: ff36ac2d         push word ptr [0x2dac]
  066C44  05C4: ff36aa2d         push word ptr [0x2daa]
  066C48  05C8: ff36a82d         push word ptr [0x2da8]
  066C4C  05CC: a1ca9c           mov ax, word ptr [0x9cca]
  066C4F  05CF: 052600           add ax, 0x26
  066C52  05D2: 3b060688         cmp ax, word ptr [0x8806]
  066C56  05D6: 7e03             jle 0x5db
  066C58  05D8: a10688           mov ax, word ptr [0x8806]
  066C5B  05DB: 2b06ca9c         sub ax, word ptr [0x9cca]
  066C5F  05DF: 050900           add ax, 9
  066C62  05E2: 50               push ax
  066C63  05E3: 6a0f             push 0xf
  066C65  05E5: a1cc9c           mov ax, word ptr [0x9ccc]
  066C68  05E8: 8bd8             mov bx, ax
  066C6A  05EA: 83c337           add bx, 0x37
  066C6D  05ED: 3b1e0488         cmp bx, word ptr [0x8804]
  066C71  05F1: 7e04             jle 0x5f7
  066C73  05F3: 8b1e0488         mov bx, word ptr [0x8804]
  066C77  05F7: 2bd8             sub bx, ax
  066C79  05F9: 3b062883         cmp ax, word ptr [0x8328]
  066C7D  05FD: 7d03             jge 0x602
  066C7F  05FF: a12883           mov ax, word ptr [0x8328]
  066C82  0602: 2b06cc9c         sub ax, word ptr [0x9ccc]
  066C86  0606: 05fc00           add ax, 0xfc
  066C89  0609: 8d9ffc00         lea bx, [bx + 0xfc]
  066C8D  060D: 8b16ca9c         mov dx, word ptr [0x9cca]
  066C91  0611: 3b162e83         cmp dx, word ptr [0x832e]
  066C95  0615: 7d04             jge 0x61b
  066C97  0617: 8b162e83         mov dx, word ptr [0x832e]
  066C9B  061B: 2b16ca9c         sub dx, word ptr [0x9cca]
  066C9F  061F: 83c209           add dx, 9
  066CA2  0622: 9ace001f18       lcall 0x181f, 0xce
  066CA7  0627: 837e0e00         cmp word ptr [bp + 0xe], 0
  066CAB  062B: 7424             je 0x651
  066CAD  062D: 8b46fe           mov ax, word ptr [bp - 2]
  066CB0  0630: 2b06ca9c         sub ax, word ptr [0x9cca]
  066CB4  0634: 050900           add ax, 9
  066CB7  0637: 50               push ax
  066CB8  0638: ff760a           push word ptr [bp + 0xa]
  066CBB  063B: ff760c           push word ptr [bp + 0xc]
  066CBE  063E: 8bd0             mov dx, ax
  066CC0  0640: 8b46fc           mov ax, word ptr [bp - 4]
  066CC3  0643: 2b06cc9c         sub ax, word ptr [0x9ccc]
  066CC7  0647: 05fc00           add ax, 0xfc
  066CCA  064A: 8bd8             mov bx, ax
  066CCC  064C: 9ae2001f18       lcall 0x181f, 0xe2
  066CD1  0651: 5e               pop si
  066CD2  0652: 5f               pop di
  066CD3  0653: c9               leave 
  066CD4  0654: cb               retf 

; ---- func_066CD6  size=379  insns=129  prologue=push bp;mov bp,sp  terminal=RETF ----
  066CD6  0656: 55               push bp
  066CD7  0657: 8bec             mov bp, sp
  066CD9  0659: 0e               push cs
  066CDA  065A: e81501           call 0x772
  066CDD  065D: 833e2c0800       cmp word ptr [0x82c], 0
  066CE2  0662: 7524             jne 0x688
  066CE4  0664: ff36ae2d         push word ptr [0x2dae]
  066CE8  0668: ff36ac2d         push word ptr [0x2dac]
  066CEC  066C: ff36aa2d         push word ptr [0x2daa]
  066CF0  0670: ff36a82d         push word ptr [0x2da8]
  066CF4  0674: 6a29             push 0x29
  066CF6  0676: 6a00             push 0
  066CF8  0678: b8f100           mov ax, 0xf1
  066CFB  067B: ba0800           mov dx, 8
  066CFE  067E: bb4f00           mov bx, 0x4f
  066D01  0681: 9aba001f18       lcall 0x181f, 0xba
  066D06  0686: eb33             jmp 0x6bb
  066D08  0688: 6a00             push 0
  066D0A  068A: 6a00             push 0
  066D0C  068C: 6a29             push 0x29
  066D0E  068E: 6a4f             push 0x4f
  066D10  0690: 6a08             push 8
  066D12  0692: 68f100           push 0xf1
  066D15  0695: 8b1e2c08         mov bx, word ptr [0x82c]
  066D19  0699: ff7706           push word ptr [bx + 6]
  066D1C  069C: ff7704           push word ptr [bx + 4]
  066D1F  069F: ff7702           push word ptr [bx + 2]
  066D22  06A2: ff37             push word ptr [bx]
  066D24  06A4: ff36ae2d         push word ptr [0x2dae]
  066D28  06A8: ff36ac2d         push word ptr [0x2dac]
  066D2C  06AC: ff36aa2d         push word ptr [0x2daa]
  066D30  06B0: ff36a82d         push word ptr [0x2da8]
  066D34  06B4: 9ac4001f18       lcall 0x181f, 0xc4
  066D39  06B9: 8be5             mov sp, bp
  066D3B  06BB: ff36ae2d         push word ptr [0x2dae]
  066D3F  06BF: ff36ac2d         push word ptr [0x2dac]
  066D43  06C3: ff36aa2d         push word ptr [0x2daa]
  066D47  06C7: ff36a82d         push word ptr [0x2da8]
  066D4B  06CB: 6a30             push 0x30
  066D4D  06CD: 6a06             push 6
  066D4F  06CF: b8fb00           mov ax, 0xfb
  066D52  06D2: ba0800           mov dx, 8
  066D55  06D5: bb3401           mov bx, 0x134
  066D58  06D8: 9ace001f18       lcall 0x181f, 0xce
  066D5D  06DD: ff7608           push word ptr [bp + 8]
  066D60  06E0: 0e               push cs
  066D61  06E1: e8a200           call 0x786
  066D64  06E4: 8be5             mov sp, bp
  066D66  06E6: ff36ae2d         push word ptr [0x2dae]
  066D6A  06EA: ff36ac2d         push word ptr [0x2dac]
  066D6E  06EE: ff36aa2d         push word ptr [0x2daa]
  066D72  06F2: ff36a82d         push word ptr [0x2da8]
  066D76  06F6: a1ca9c           mov ax, word ptr [0x9cca]
  066D79  06F9: 052600           add ax, 0x26
  066D7C  06FC: 3b060688         cmp ax, word ptr [0x8806]
  066D80  0700: 7e03             jle 0x705
  066D82  0702: a10688           mov ax, word ptr [0x8806]
  066D85  0705: 2b06ca9c         sub ax, word ptr [0x9cca]
  066D89  0709: 050900           add ax, 9
  066D8C  070C: 50               push ax
  066D8D  070D: 6a0f             push 0xf
  066D8F  070F: a1cc9c           mov ax, word ptr [0x9ccc]
  066D92  0712: 8bd8             mov bx, ax
  066D94  0714: 83c337           add bx, 0x37
  066D97  0717: 3b1e0488         cmp bx, word ptr [0x8804]
  066D9B  071B: 7e04             jle 0x721
  066D9D  071D: 8b1e0488         mov bx, word ptr [0x8804]
  066DA1  0721: 2bd8             sub bx, ax
  066DA3  0723: 3b062883         cmp ax, word ptr [0x8328]
  066DA7  0727: 7d03             jge 0x72c
  066DA9  0729: a12883           mov ax, word ptr [0x8328]
  066DAC  072C: 2b06cc9c         sub ax, word ptr [0x9ccc]
  066DB0  0730: 05fc00           add ax, 0xfc
  066DB3  0733: 8d9ffc00         lea bx, [bx + 0xfc]
  066DB7  0737: 8b16ca9c         mov dx, word ptr [0x9cca]
  066DBB  073B: 3b162e83         cmp dx, word ptr [0x832e]
  066DBF  073F: 7d04             jge 0x745
  066DC1  0741: 8b162e83         mov dx, word ptr [0x832e]
  066DC5  0745: 2b16ca9c         sub dx, word ptr [0x9cca]
  066DC9  0749: 83c209           add dx, 9
  066DCC  074C: 9ace001f18       lcall 0x181f, 0xce
  066DD1  0751: 837e0600         cmp word ptr [bp + 6], 0
  066DD5  0755: 7413             je 0x76a
  066DD7  0757: 6a08             push 8
  066DD9  0759: 6a4f             push 0x4f
  066DDB  075B: 6a29             push 0x29
  066DDD  075D: b8f100           mov ax, 0xf1
  066DE0  0760: ba0800           mov dx, 8
  066DE3  0763: 8bd8             mov bx, ax
  066DE5  0765: 9ae2001f18       lcall 0x181f, 0xe2
  066DEA  076A: c9               leave 
  066DEB  076B: cb               retf 
  066DEC  076C: 0e               push cs
  066DED  076D: e80200           call 0x772
  066DF0  0770: cb               retf 
  066DF1  0771: 90               nop 
  066DF2  0772: ea9a051f18       ljmp 0x181f:0x59a
  066DF7  0777: ea96081f1a       ljmp 0x1a1f:0x896
  066DFC  077C: eab2081f1a       ljmp 0x1a1f:0x8b2
  066E01  0781: eac0081f1a       ljmp 0x1a1f:0x8c0
  066E06  0786: eace081f1a       ljmp 0x1a1f:0x8ce
  066E0B  078B: 00558b           add byte ptr [di - 0x75], dl
  066E0E  078E: ec               in al, dx
  066E0F  078F: 8b5e06           mov bx, word ptr [bp + 6]
  066E12  0792: 8b07             mov ax, word ptr [bx]
  066E14  0794: 3b062883         cmp ax, word ptr [0x8328]
  066E18  0798: 7d03             jge 0x79d
  066E1A  079A: a12883           mov ax, word ptr [0x8328]
  066E1D  079D: 8907             mov word ptr [bx], ax
  066E1F  079F: 8b5e08           mov bx, word ptr [bp + 8]
  066E22  07A2: 8b07             mov ax, word ptr [bx]
  066E24  07A4: 3b062e83         cmp ax, word ptr [0x832e]
  066E28  07A8: 7d03             jge 0x7ad
  066E2A  07AA: a12e83           mov ax, word ptr [0x832e]
  066E2D  07AD: 8907             mov word ptr [bx], ax
  066E2F  07AF: 8b5e0a           mov bx, word ptr [bp + 0xa]
  066E32  07B2: 8b07             mov ax, word ptr [bx]
  066E34  07B4: 3b060488         cmp ax, word ptr [0x8804]
  066E38  07B8: 7e03             jle 0x7bd
  066E3A  07BA: a10488           mov ax, word ptr [0x8804]
  066E3D  07BD: 8907             mov word ptr [bx], ax
  066E3F  07BF: 8b5e0c           mov bx, word ptr [bp + 0xc]
  066E42  07C2: 8b07             mov ax, word ptr [bx]
  066E44  07C4: 3b060688         cmp ax, word ptr [0x8806]
  066E48  07C8: 7e03             jle 0x7cd
  066E4A  07CA: a10688           mov ax, word ptr [0x8806]
  066E4D  07CD: 8907             mov word ptr [bx], ax
  066E4F  07CF: c9               leave 
  066E50  07D0: cb               retf 

; ---- func_066E52  size=118  insns=52  prologue=ENTER 0x0004,0  terminal=RETF ----
  066E52  07D2: c8040000         enter 4, 0
  066E56  07D6: 57               push di
  066E57  07D7: 56               push si
  066E58  07D8: 8b5e0a           mov bx, word ptr [bp + 0xa]
  066E5B  07DB: 8b07             mov ax, word ptr [bx]
  066E5D  07DD: 8b7606           mov si, word ptr [bp + 6]
  066E60  07E0: 0304             add ax, word ptr [si]
  066E62  07E2: 48               dec ax
  066E63  07E3: 8946fe           mov word ptr [bp - 2], ax
  066E66  07E6: 8b7e0c           mov di, word ptr [bp + 0xc]
  066E69  07E9: 8b05             mov ax, word ptr [di]
  066E6B  07EB: 8b5e08           mov bx, word ptr [bp + 8]
  066E6E  07EE: 0307             add ax, word ptr [bx]
  066E70  07F0: 48               dec ax
  066E71  07F1: 8946fc           mov word ptr [bp - 4], ax
  066E74  07F4: a10488           mov ax, word ptr [0x8804]
  066E77  07F7: 3b46fe           cmp ax, word ptr [bp - 2]
  066E7A  07FA: 7e03             jle 0x7ff
  066E7C  07FC: 8b46fe           mov ax, word ptr [bp - 2]
  066E7F  07FF: 8b0c             mov cx, word ptr [si]
  066E81  0801: 3b0e2883         cmp cx, word ptr [0x8328]
  066E85  0805: 7d04             jge 0x80b
  066E87  0807: 8b0e2883         mov cx, word ptr [0x8328]
  066E8B  080B: 890c             mov word ptr [si], cx
  066E8D  080D: 2bc1             sub ax, cx
  066E8F  080F: 40               inc ax
  066E90  0810: 8b760a           mov si, word ptr [bp + 0xa]
  066E93  0813: 8904             mov word ptr [si], ax
  066E95  0815: 8b0e0688         mov cx, word ptr [0x8806]
  066E99  0819: 3b4efc           cmp cx, word ptr [bp - 4]
  066E9C  081C: 7e03             jle 0x821
  066E9E  081E: 8b4efc           mov cx, word ptr [bp - 4]
  066EA1  0821: 8b17             mov dx, word ptr [bx]
  066EA3  0823: 3b162e83         cmp dx, word ptr [0x832e]
  066EA7  0827: 7d04             jge 0x82d
  066EA9  0829: 8b162e83         mov dx, word ptr [0x832e]
  066EAD  082D: 8917             mov word ptr [bx], dx
  066EAF  082F: 2bca             sub cx, dx
  066EB1  0831: 41               inc cx
  066EB2  0832: 890d             mov word ptr [di], cx
  066EB4  0834: 0bc0             or ax, ax
  066EB6  0836: 7d02             jge 0x83a
  066EB8  0838: 2bc0             sub ax, ax
  066EBA  083A: 8904             mov word ptr [si], ax
  066EBC  083C: 0bc9             or cx, cx
  066EBE  083E: 7d02             jge 0x842
  066EC0  0840: 2bc9             sub cx, cx
  066EC2  0842: 890d             mov word ptr [di], cx
  066EC4  0844: 5e               pop si
  066EC5  0845: 5f               pop di
  066EC6  0846: c9               leave 
  066EC7  0847: cb               retf 

; ---- func_066EC8  size=159  insns=52  prologue=ENTER 0x0008,0  terminal=RETF ----
  066EC8  0848: c8080000         enter 8, 0
  066ECC  084C: a12c83           mov ax, word ptr [0x832c]
  066ECF  084F: 2b062e83         sub ax, word ptr [0x832e]
  066ED3  0853: 034608           add ax, word ptr [bp + 8]
  066ED6  0856: f72e2683         imul word ptr [0x8326]
  066EDA  085A: 8bc8             mov cx, ax
  066EDC  085C: 8b460a           mov ax, word ptr [bp + 0xa]
  066EDF  085F: f72ed45a         imul word ptr [0x5ad4]
  066EE3  0863: 8bd0             mov dx, ax
  066EE5  0865: 8b460c           mov ax, word ptr [bp + 0xc]
  066EE8  0868: 8bda             mov bx, dx
  066EEA  086A: f72e2683         imul word ptr [0x8326]
  066EEE  086E: ff36a483         push word ptr [0x83a4]
  066EF2  0872: ff36a283         push word ptr [0x83a2]
  066EF6  0876: ff36a083         push word ptr [0x83a0]
  066EFA  087A: ff369e83         push word ptr [0x839e]
  066EFE  087E: ff36ae2d         push word ptr [0x2dae]
  066F02  0882: ff36ac2d         push word ptr [0x2dac]
  066F06  0886: ff36aa2d         push word ptr [0x2daa]
  066F0A  088A: ff36a82d         push word ptr [0x2da8]
  066F0E  088E: 8bd1             mov dx, cx
  066F10  0890: 83c108           add cx, 8
  066F13  0893: 51               push cx
  066F14  0894: 53               push bx
  066F15  0895: 50               push ax
  066F16  0896: a12a83           mov ax, word ptr [0x832a]
  066F19  0899: 2b062883         sub ax, word ptr [0x8328]
  066F1D  089D: 034606           add ax, word ptr [bp + 6]
  066F20  08A0: 8bca             mov cx, dx
  066F22  08A2: f72ed45a         imul word ptr [0x5ad4]
  066F26  08A6: 8bd8             mov bx, ax
  066F28  08A8: 8bd1             mov dx, cx
  066F2A  08AA: 9a3a031f18       lcall 0x181f, 0x33a
  066F2F  08AF: c9               leave 
  066F30  08B0: cb               retf 
  066F31  08B1: 90               nop 
  066F32  08B2: ff36a483         push word ptr [0x83a4]
  066F36  08B6: ff36a283         push word ptr [0x83a2]
  066F3A  08BA: ff36a083         push word ptr [0x83a0]
  066F3E  08BE: ff369e83         push word ptr [0x839e]
  066F42  08C2: ff36ae2d         push word ptr [0x2dae]
  066F46  08C6: ff36ac2d         push word ptr [0x2dac]
  066F4A  08CA: ff36aa2d         push word ptr [0x2daa]
  066F4E  08CE: ff36a82d         push word ptr [0x2da8]
  066F52  08D2: 6a08             push 8
  066F54  08D4: ff365085         push word ptr [0x8550]
  066F58  08D8: ff365285         push word ptr [0x8552]
  066F5C  08DC: 2bc0             sub ax, ax
  066F5E  08DE: 99               cdq 
  066F5F  08DF: 2bdb             sub bx, bx
  066F61  08E1: 9a3a031f18       lcall 0x181f, 0x33a
  066F66  08E6: cb               retf 

; ---- func_066F68  size=211  insns=74  prologue=ENTER 0x0018,0  terminal=RETF ----
  066F68  08E8: c8180000         enter 0x18, 0
  066F6C  08EC: c746f40100       mov word ptr [bp - 0xc], 1
  066F71  08F1: c746f00000       mov word ptr [bp - 0x10], 0
  066F76  08F6: 2bc0             sub ax, ax
  066F78  08F8: 8946fc           mov word ptr [bp - 4], ax
  066F7B  08FB: 8946fa           mov word ptr [bp - 6], ax
  066F7E  08FE: a14685           mov ax, word ptr [0x8546]
  066F81  0901: f72e4485         imul word ptr [0x8544]
  066F85  0905: 8946f6           mov word ptr [bp - 0xa], ax
  066F88  0908: 2bc0             sub ax, ax
  066F8A  090A: a33a83           mov word ptr [0x833a], ax
  066F8D  090D: a33883           mov word ptr [0x8338], ax
  066F90  0910: 8b46f4           mov ax, word ptr [bp - 0xc]
  066F93  0913: d1e8             shr ax, 1
  066F95  0915: 7303             jae 0x91a
  066F97  0917: 3500b4           xor ax, 0xb400
  066F9A  091A: 8946f4           mov word ptr [bp - 0xc], ax
  066F9D  091D: 8b46f4           mov ax, word ptr [bp - 0xc]
  066FA0  0920: 48               dec ax
  066FA1  0921: 8946fe           mov word ptr [bp - 2], ax
  066FA4  0924: 3b46f6           cmp ax, word ptr [bp - 0xa]
  066FA7  0927: 7370             jae 0x999
  066FA9  0929: 2bd2             sub dx, dx
  066FAB  092B: f7364485         div word ptr [0x8544]
  066FAF  092F: 8bc8             mov cx, ax
  066FB1  0931: 8b46fe           mov ax, word ptr [bp - 2]
  066FB4  0934: 2bd2             sub dx, dx
  066FB6  0936: f7364485         div word ptr [0x8544]
  066FBA  093A: 8bc2             mov ax, dx
  066FBC  093C: 03062a83         add ax, word ptr [0x832a]
  066FC0  0940: f72ed45a         imul word ptr [0x5ad4]
  066FC4  0944: 8bd0             mov dx, ax
  066FC6  0946: 8bc1             mov ax, cx
  066FC8  0948: 03062c83         add ax, word ptr [0x832c]
  066FCC  094C: 8bca             mov cx, dx
  066FCE  094E: f72e2683         imul word ptr [0x8326]
  066FD2  0952: 050800           add ax, 8
  066FD5  0955: 50               push ax
  066FD6  0956: ff36d45a         push word ptr [0x5ad4]
  066FDA  095A: ff362683         push word ptr [0x8326]
  066FDE  095E: 8bd0             mov dx, ax
  066FE0  0960: 8bc1             mov ax, cx
  066FE2  0962: 8bd8             mov bx, ax
  066FE4  0964: 9ae2001f18       lcall 0x181f, 0xe2
  066FE9  0969: 817ef6b400       cmp word ptr [bp - 0xa], 0xb4
  066FEE  096E: 7729             ja 0x999
  066FF0  0970: 8b46fc           mov ax, word ptr [bp - 4]
  066FF3  0973: 0b46fa           or ax, word ptr [bp - 6]
  066FF6  0976: 7416             je 0x98e
  066FF8  0978: 9a22000c0c       lcall 0xc0c, 0x22
  066FFD  097D: 2b46fa           sub ax, word ptr [bp - 6]
  067000  0980: 1b56fc           sbb dx, word ptr [bp - 4]
  067003  0983: 0bd2             or dx, dx
  067005  0985: 7cf1             jl 0x978
  067007  0987: 7f05             jg 0x98e
  067009  0989: 3d0100           cmp ax, 1
  06700C  098C: 72ea             jb 0x978
  06700E  098E: 9a22000c0c       lcall 0xc0c, 0x22
  067013  0993: 8946fa           mov word ptr [bp - 6], ax
  067016  0996: 8956fc           mov word ptr [bp - 4], dx
  067019  0999: ff46f0           inc word ptr [bp - 0x10]
  06701C  099C: 7403             je 0x9a1
  06701E  099E: e96fff           jmp 0x910
  067021  09A1: c9               leave 
  067022  09A2: cb               retf 
  067023  09A3: 90               nop 
  067024  09A4: 6a08             push 8
  067026  09A6: ff365085         push word ptr [0x8550]
  06702A  09AA: ff365285         push word ptr [0x8552]
  06702E  09AE: 2bc0             sub ax, ax
  067030  09B0: ba0800           mov dx, 8
  067033  09B3: 2bdb             sub bx, bx
  067035  09B5: 9ae2001f18       lcall 0x181f, 0xe2
  06703A  09BA: cb               retf 

; ---- func_06703C  size=69  insns=25  prologue=ENTER 0x0008,0  terminal=RETF ----
  06703C  09BC: c8080000         enter 8, 0
  067040  09C0: a12c83           mov ax, word ptr [0x832c]
  067043  09C3: 2b062e83         sub ax, word ptr [0x832e]
  067047  09C7: 034608           add ax, word ptr [bp + 8]
  06704A  09CA: f72e2683         imul word ptr [0x8326]
  06704E  09CE: 050800           add ax, 8
  067051  09D1: 8bc8             mov cx, ax
  067053  09D3: 8b460a           mov ax, word ptr [bp + 0xa]
  067056  09D6: f72ed45a         imul word ptr [0x5ad4]
  06705A  09DA: 8bd0             mov dx, ax
  06705C  09DC: 8b460c           mov ax, word ptr [bp + 0xc]
  06705F  09DF: 8bda             mov bx, dx
  067061  09E1: f72e2683         imul word ptr [0x8326]
  067065  09E5: 51               push cx
  067066  09E6: 53               push bx
  067067  09E7: 50               push ax
  067068  09E8: a12a83           mov ax, word ptr [0x832a]
  06706B  09EB: 2b062883         sub ax, word ptr [0x8328]
  06706F  09EF: 034606           add ax, word ptr [bp + 6]
  067072  09F2: f72ed45a         imul word ptr [0x5ad4]
  067076  09F6: 8bd8             mov bx, ax
  067078  09F8: 8bd1             mov dx, cx
  06707A  09FA: 9ae2001f18       lcall 0x181f, 0xe2
  06707F  09FF: c9               leave 
  067080  0A00: cb               retf 

; ---- func_067082  size=256  insns=89  prologue=ENTER 0x000E,0  terminal=RETF ----
  067082  0A02: c80e0000         enter 0xe, 0
  067086  0A06: 8a0e9653         mov cl, byte ptr [0x5396]
  06708A  0A0A: 80c104           add cl, 4
  06708D  0A0D: b001             mov al, 1
  06708F  0A0F: d2e0             shl al, cl
  067091  0A11: 8846f7           mov byte ptr [bp - 9], al
  067094  0A14: 8b460a           mov ax, word ptr [bp + 0xa]
  067097  0A17: 034606           add ax, word ptr [bp + 6]
  06709A  0A1A: 48               dec ax
  06709B  0A1B: 8946f4           mov word ptr [bp - 0xc], ax
  06709E  0A1E: 8b460c           mov ax, word ptr [bp + 0xc]
  0670A1  0A21: 034608           add ax, word ptr [bp + 8]
  0670A4  0A24: 48               dec ax
  0670A5  0A25: 8946f2           mov word ptr [bp - 0xe], ax
  0670A8  0A28: 8d46f2           lea ax, [bp - 0xe]
  0670AB  0A2B: 50               push ax
  0670AC  0A2C: 8d46f4           lea ax, [bp - 0xc]
  0670AF  0A2F: 50               push ax
  0670B0  0A30: 8d4608           lea ax, [bp + 8]
  0670B3  0A33: 50               push ax
  0670B4  0A34: 8d4606           lea ax, [bp + 6]
  0670B7  0A37: 50               push ax
  0670B8  0A38: 9a06091f1a       lcall 0x1a1f, 0x906
  0670BD  0A3D: 83c408           add sp, 8
  0670C0  0A40: c746f80000       mov word ptr [bp - 8], 0
  0670C5  0A45: 833e9a5300       cmp word ptr [0x539a], 0
  0670CA  0A4A: 7f03             jg 0xa4f
  0670CC  0A4C: e99900           jmp 0xae8
  0670CF  0A4F: c746faec54       mov word ptr [bp - 6], 0x54ec
  0670D4  0A54: 8b5efa           mov bx, word ptr [bp - 6]
  0670D7  0A57: 8a07             mov al, byte ptr [bx]
  0670D9  0A59: 2ae4             sub ah, ah
  0670DB  0A5B: 8946fc           mov word ptr [bp - 4], ax
  0670DE  0A5E: 8a4f01           mov cl, byte ptr [bx + 1]
  0670E1  0A61: 2aed             sub ch, ch
  0670E3  0A63: 894efe           mov word ptr [bp - 2], cx
  0670E6  0A66: 3b4606           cmp ax, word ptr [bp + 6]
  0670E9  0A69: 7c6b             jl 0xad6
  0670EB  0A6B: 3946f4           cmp word ptr [bp - 0xc], ax
  0670EE  0A6E: 7c66             jl 0xad6
  0670F0  0A70: 8b4608           mov ax, word ptr [bp + 8]
  0670F3  0A73: 3bc8             cmp cx, ax
  0670F5  0A75: 7c5f             jl 0xad6
  0670F7  0A77: 8bc1             mov ax, cx
  0670F9  0A79: 3946f2           cmp word ptr [bp - 0xe], ax
  0670FC  0A7C: 7c58             jl 0xad6
  0670FE  0A7E: 50               push ax
  0670FF  0A7F: ff76fc           push word ptr [bp - 4]
  067102  0A82: 9a4a071f18       lcall 0x181f, 0x74a
  067107  0A87: 83c404           add sp, 4
  06710A  0A8A: 8446f7           test byte ptr [bp - 9], al
  06710D  0A8D: 7507             jne 0xa96
  06710F  0A8F: 833ea25300       cmp word ptr [0x53a2], 0
  067114  0A94: 7440             je 0xad6
  067116  0A96: ff36a483         push word ptr [0x83a4]
  06711A  0A9A: ff36a283         push word ptr [0x83a2]
  06711E  0A9E: ff36a083         push word ptr [0x83a0]
  067122  0AA2: ff369e83         push word ptr [0x839e]
  067126  0AA6: ff368601         push word ptr [0x186]
  06712A  0AAA: a12a83           mov ax, word ptr [0x832a]
  06712D  0AAD: 2b062883         sub ax, word ptr [0x8328]
  067131  0AB1: 0346fc           add ax, word ptr [bp - 4]
  067134  0AB4: f72ed45a         imul word ptr [0x5ad4]
  067138  0AB8: 8bd0             mov dx, ax
  06713A  0ABA: a12c83           mov ax, word ptr [0x832c]
  06713D  0ABD: 2b062e83         sub ax, word ptr [0x832e]
  067141  0AC1: 0346fe           add ax, word ptr [bp - 2]
  067144  0AC4: 8bca             mov cx, dx
  067146  0AC6: f72e2683         imul word ptr [0x8326]
  06714A  0ACA: 8bd8             mov bx, ax
  06714C  0ACC: 8bd1             mov dx, cx
  06714E  0ACE: 8b46f8           mov ax, word ptr [bp - 8]
  067151  0AD1: 9ab2021f18       lcall 0x181f, 0x2b2
  067156  0AD6: 8346fa12         add word ptr [bp - 6], 0x12
  06715A  0ADA: a19a53           mov ax, word ptr [0x539a]
  06715D  0ADD: ff46f8           inc word ptr [bp - 8]
  067160  0AE0: 3946f8           cmp word ptr [bp - 8], ax
  067163  0AE3: 7d03             jge 0xae8
  067165  0AE5: e96cff           jmp 0xa54
  067168  0AE8: c9               leave 
  067169  0AE9: cb               retf 
  06716A  0AEA: ff364685         push word ptr [0x8546]
  06716E  0AEE: ff364485         push word ptr [0x8544]
  067172  0AF2: ff362e83         push word ptr [0x832e]
  067176  0AF6: ff362883         push word ptr [0x8328]
  06717A  0AFA: 0e               push cs
  06717B  0AFB: e8bc04           call 0xfba
  06717E  0AFE: 83c408           add sp, 8
  067181  0B01: cb               retf 

; ---- func_067182  size=350  insns=119  prologue=ENTER 0x0012,0  terminal=RETF ----
  067182  0B02: c8120000         enter 0x12, 0
  067186  0B06: 57               push di
  067187  0B07: 56               push si
  067188  0B08: 8a0e9653         mov cl, byte ptr [0x5396]
  06718C  0B0C: 80c104           add cl, 4
  06718F  0B0F: b001             mov al, 1
  067191  0B11: d2e0             shl al, cl
  067193  0B13: 8846f3           mov byte ptr [bp - 0xd], al
  067196  0B16: 8b460a           mov ax, word ptr [bp + 0xa]
  067199  0B19: 034606           add ax, word ptr [bp + 6]
  06719C  0B1C: 48               dec ax
  06719D  0B1D: 8946f0           mov word ptr [bp - 0x10], ax
  0671A0  0B20: 8b460c           mov ax, word ptr [bp + 0xc]
  0671A3  0B23: 034608           add ax, word ptr [bp + 8]
  0671A6  0B26: 48               dec ax
  0671A7  0B27: 8946ee           mov word ptr [bp - 0x12], ax
  0671AA  0B2A: 8d46ee           lea ax, [bp - 0x12]
  0671AD  0B2D: 50               push ax
  0671AE  0B2E: 8d46f0           lea ax, [bp - 0x10]
  0671B1  0B31: 50               push ax
  0671B2  0B32: 8d4608           lea ax, [bp + 8]
  0671B5  0B35: 50               push ax
  0671B6  0B36: 8d4606           lea ax, [bp + 6]
  0671B9  0B39: 50               push ax
  0671BA  0B3A: 9a06091f1a       lcall 0x1a1f, 0x906
  0671BF  0B3F: 83c408           add sp, 8
  0671C2  0B42: c746fe0000       mov word ptr [bp - 2], 0
  0671C7  0B47: 833e9e5300       cmp word ptr [0x539e], 0
  0671CC  0B4C: 7f03             jg 0xb51
  0671CE  0B4E: e9f300           jmp 0xc44
  0671D1  0B51: c746fc465d       mov word ptr [bp - 4], 0x5d46
  0671D6  0B56: 8b5efc           mov bx, word ptr [bp - 4]
  0671D9  0B59: 8a07             mov al, byte ptr [bx]
  0671DB  0B5B: 2ae4             sub ah, ah
  0671DD  0B5D: 8bf8             mov di, ax
  0671DF  0B5F: 8a4f01           mov cl, byte ptr [bx + 1]
  0671E2  0B62: 2aed             sub ch, ch
  0671E4  0B64: 8bf1             mov si, cx
  0671E6  0B66: 3b4606           cmp ax, word ptr [bp + 6]
  0671E9  0B69: 7d03             jge 0xb6e
  0671EB  0B6B: e9c300           jmp 0xc31
  0671EE  0B6E: 397ef0           cmp word ptr [bp - 0x10], di
  0671F1  0B71: 7d03             jge 0xb76
  0671F3  0B73: e9bb00           jmp 0xc31
  0671F6  0B76: 397608           cmp word ptr [bp + 8], si
  0671F9  0B79: 7e03             jle 0xb7e
  0671FB  0B7B: e9b300           jmp 0xc31
  0671FE  0B7E: 3976ee           cmp word ptr [bp - 0x12], si
  067201  0B81: 7d03             jge 0xb86
  067203  0B83: e9ab00           jmp 0xc31
  067206  0B86: ff369653         push word ptr [0x5396]
  06720A  0B8A: ff76fe           push word ptr [bp - 2]
  06720D  0B8D: 9a96091f19       lcall 0x191f, 0x996
  067212  0B92: 83c404           add sp, 4
  067215  0B95: 0bc0             or ax, ax
  067217  0B97: 7503             jne 0xb9c
  067219  0B99: e99500           jmp 0xc31
  06721C  0B9C: 56               push si
  06721D  0B9D: 57               push di
  06721E  0B9E: 9a4a071f18       lcall 0x181f, 0x74a
  067223  0BA3: 83c404           add sp, 4
  067226  0BA6: 8446f3           test byte ptr [bp - 0xd], al
  067229  0BA9: 7507             jne 0xbb2
  06722B  0BAB: 833ea25300       cmp word ptr [0x53a2], 0
  067230  0BB0: 747f             je 0xc31
  067232  0BB2: 8bc7             mov ax, di
  067234  0BB4: 2b062883         sub ax, word ptr [0x8328]
  067238  0BB8: 03062a83         add ax, word ptr [0x832a]
  06723C  0BBC: f72ed45a         imul word ptr [0x5ad4]
  067240  0BC0: 8946fa           mov word ptr [bp - 6], ax
  067243  0BC3: 8bc6             mov ax, si
  067245  0BC5: 2b062e83         sub ax, word ptr [0x832e]
  067249  0BC9: 03062c83         add ax, word ptr [0x832c]
  06724D  0BCD: f72e2683         imul word ptr [0x8326]
  067251  0BD1: 8946f8           mov word ptr [bp - 8], ax
  067254  0BD4: 833e840100       cmp word ptr [0x184], 0
  067259  0BD9: 750f             jne 0xbea
  06725B  0BDB: 833e900800       cmp word ptr [0x890], 0
  067260  0BE0: 7508             jne 0xbea
  067262  0BE2: c746f40100       mov word ptr [bp - 0xc], 1
  067267  0BE7: eb06             jmp 0xbef
  067269  0BE9: 90               nop 
  06726A  0BEA: c746f40000       mov word ptr [bp - 0xc], 0
  06726F  0BEF: 833e840100       cmp word ptr [0x184], 0
  067274  0BF4: 750e             jne 0xc04
  067276  0BF6: 833e900800       cmp word ptr [0x890], 0
  06727B  0BFB: 7507             jne 0xc04
  06727D  0BFD: c746f60100       mov word ptr [bp - 0xa], 1
  067282  0C02: eb05             jmp 0xc09
  067284  0C04: c746f60000       mov word ptr [bp - 0xa], 0
  067289  0C09: ff36a483         push word ptr [0x83a4]
  06728D  0C0D: ff36a283         push word ptr [0x83a2]
  067291  0C11: ff36a083         push word ptr [0x83a0]
  067295  0C15: ff369e83         push word ptr [0x839e]
  067299  0C19: ff368601         push word ptr [0x186]
  06729D  0C1D: ff76f4           push word ptr [bp - 0xc]
  0672A0  0C20: ff76f6           push word ptr [bp - 0xa]
  0672A3  0C23: 8b46fe           mov ax, word ptr [bp - 2]
  0672A6  0C26: 8b56fa           mov dx, word ptr [bp - 6]
  0672A9  0C29: 8b5ef8           mov bx, word ptr [bp - 8]
  0672AC  0C2C: 9aa8021f18       lcall 0x181f, 0x2a8
  0672B1  0C31: 8146fcca00       add word ptr [bp - 4], 0xca
  0672B6  0C36: a19e53           mov ax, word ptr [0x539e]
  0672B9  0C39: ff46fe           inc word ptr [bp - 2]
  0672BC  0C3C: 3946fe           cmp word ptr [bp - 2], ax
  0672BF  0C3F: 7d03             jge 0xc44
  0672C1  0C41: e912ff           jmp 0xb56
  0672C4  0C44: 5e               pop si
  0672C5  0C45: 5f               pop di
  0672C6  0C46: c9               leave 
  0672C7  0C47: cb               retf 
  0672C8  0C48: ff364685         push word ptr [0x8546]
  0672CC  0C4C: ff364485         push word ptr [0x8544]
  0672D0  0C50: ff362e83         push word ptr [0x832e]
  0672D4  0C54: ff362883         push word ptr [0x8328]
  0672D8  0C58: 0e               push cs
  0672D9  0C59: e85403           call 0xfb0
  0672DC  0C5C: 83c408           add sp, 8
  0672DF  0C5F: cb               retf 

; ---- func_0672E0  size=236  insns=97  prologue=ENTER 0x000A,0  terminal=RETF ----
  0672E0  0C60: c80a0000         enter 0xa, 0
  0672E4  0C64: 57               push di
  0672E5  0C65: 56               push si
  0672E6  0C66: 8b7e08           mov di, word ptr [bp + 8]
  0672E9  0C69: b8ffff           mov ax, 0xffff
  0672EC  0C6C: 8946fc           mov word ptr [bp - 4], ax
  0672EF  0C6F: 8946fa           mov word ptr [bp - 6], ax
  0672F2  0C72: 0bff             or di, di
  0672F4  0C74: 7406             je 0xc7c
  0672F6  0C76: 837e0a00         cmp word ptr [bp + 0xa], 0
  0672FA  0C7A: 751f             jne 0xc9b
  0672FC  0C7C: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  067300  0C80: 8a874531         mov al, byte ptr [bx + 0x3145]
  067304  0C84: 2ae4             sub ah, ah
  067306  0C86: 50               push ax
  067307  0C87: 8a874431         mov al, byte ptr [bx + 0x3144]
  06730B  0C8B: 50               push ax
  06730C  0C8C: 9abe071f18       lcall 0x181f, 0x7be
  067311  0C91: 83c404           add sp, 4
  067314  0C94: 0bc0             or ax, ax
  067316  0C96: 7c03             jl 0xc9b
  067318  0C98: e98300           jmp 0xd1e
  06731B  0C9B: 8b4606           mov ax, word ptr [bp + 6]
  06731E  0C9E: 9aee021f18       lcall 0x181f, 0x2ee
  067323  0CA3: 8946fe           mov word ptr [bp - 2], ax
  067326  0CA6: 9ae4021f18       lcall 0x181f, 0x2e4
  06732B  0CAB: 0bc0             or ax, ax
  06732D  0CAD: 7c05             jl 0xcb4
  06732F  0CAF: b80100           mov ax, 1
  067332  0CB2: eb02             jmp 0xcb6
  067334  0CB4: 2bc0             sub ax, ax
  067336  0CB6: 8b5e0c           mov bx, word ptr [bp + 0xc]
  067339  0CB9: 8907             mov word ptr [bx], ax
  06733B  0CBB: 0bff             or di, di
  06733D  0CBD: 7551             jne 0xd10
  06733F  0CBF: 8b46fe           mov ax, word ptr [bp - 2]
  067342  0CC2: 894606           mov word ptr [bp + 6], ax
  067345  0CC5: 8b76fe           mov si, word ptr [bp - 2]
  067348  0CC8: 0bf6             or si, si
  06734A  0CCA: 7c4c             jl 0xd18
  06734C  0CCC: 8b7efc           mov di, word ptr [bp - 4]
  06734F  0CCF: 6bde1c           imul bx, si, 0x1c
  067352  0CD2: 8a874631         mov al, byte ptr [bx + 0x3146]
  067356  0CD6: 3c0d             cmp al, 0xd
  067358  0CD8: 7206             jb 0xce0
  06735A  0CDA: 3c11             cmp al, 0x11
  06735C  0CDC: 7702             ja 0xce0
  06735E  0CDE: 8bfe             mov di, si
  067360  0CE0: 8bc6             mov ax, si
  067362  0CE2: 9ae4021f18       lcall 0x181f, 0x2e4
  067367  0CE7: 8bf0             mov si, ax
  067369  0CE9: 0bf6             or si, si
  06736B  0CEB: 7de2             jge 0xccf
  06736D  0CED: 837e0800         cmp word ptr [bp + 8], 0
  067371  0CF1: 7414             je 0xd07
  067373  0CF3: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  067377  0CF7: 8a874631         mov al, byte ptr [bx + 0x3146]
  06737B  0CFB: 3c0d             cmp al, 0xd
  06737D  0CFD: 7204             jb 0xd03
  06737F  0CFF: 3c11             cmp al, 0x11
  067381  0D01: 761b             jbe 0xd1e
  067383  0D03: 0bff             or di, di
  067385  0D05: 7c17             jl 0xd1e
  067387  0D07: 0bff             or di, di
  067389  0D09: 7c1d             jl 0xd28
  06738B  0D0B: 6bdf1c           imul bx, di, 0x1c
  06738E  0D0E: eb1c             jmp 0xd2c
  067390  0D10: 837e0a00         cmp word ptr [bp + 0xa], 0
  067394  0D14: 74af             je 0xcc5
  067396  0D16: eb10             jmp 0xd28
  067398  0D18: 8b7efc           mov di, word ptr [bp - 4]
  06739B  0D1B: ebd0             jmp 0xced
  06739D  0D1D: 90               nop 
  06739E  0D1E: 8b76fa           mov si, word ptr [bp - 6]
  0673A1  0D21: 8bc6             mov ax, si
  0673A3  0D23: 5e               pop si
  0673A4  0D24: 5f               pop di
  0673A5  0D25: c9               leave 
  0673A6  0D26: cb               retf 
  0673A7  0D27: 90               nop 
  0673A8  0D28: 6b5e061c         imul bx, word ptr [bp + 6], 0x1c
  0673AC  0D2C: 8a9f4631         mov bl, byte ptr [bx + 0x3146]
  0673B0  0D30: 2aff             sub bh, bh
  0673B2  0D32: 8bc3             mov ax, bx
  0673B4  0D34: d1e3             shl bx, 1
  0673B6  0D36: 03d8             add bx, ax
  0673B8  0D38: d1e3             shl bx, 1
  0673BA  0D3A: 03d8             add bx, ax
  0673BC  0D3C: d1e3             shl bx, 1
  0673BE  0D3E: 8a873252         mov al, byte ptr [bx + 0x5232]
  0673C2  0D42: 2ae4             sub ah, ah
  0673C4  0D44: 8bf0             mov si, ax
  0673C6  0D46: 8bc6             mov ax, si
  0673C8  0D48: 5e               pop si
  0673C9  0D49: 5f               pop di
  0673CA  0D4A: c9               leave 
  0673CB  0D4B: cb               retf 

; ---- func_0673CC  size=169  insns=58  prologue=ENTER 0x0004,0  terminal=RETF ----
  0673CC  0D4C: c8040000         enter 4, 0
  0673D0  0D50: 57               push di
  0673D1  0D51: 56               push si
  0673D2  0D52: 837e0800         cmp word ptr [bp + 8], 0
  0673D6  0D56: 7409             je 0xd61
  0673D8  0D58: 837e0a00         cmp word ptr [bp + 0xa], 0
  0673DC  0D5C: 7503             jne 0xd61
  0673DE  0D5E: e99000           jmp 0xdf1
  0673E1  0D61: 837e0800         cmp word ptr [bp + 8], 0
  0673E5  0D65: 7409             je 0xd70
  0673E7  0D67: 8b7606           mov si, word ptr [bp + 6]
  0673EA  0D6A: 837e0a00         cmp word ptr [bp + 0xa], 0
  0673EE  0D6E: 751e             jne 0xd8e
  0673F0  0D70: 8b7606           mov si, word ptr [bp + 6]
  0673F3  0D73: 6bde1c           imul bx, si, 0x1c
  0673F6  0D76: 8a874531         mov al, byte ptr [bx + 0x3145]
  0673FA  0D7A: 2ae4             sub ah, ah
  0673FC  0D7C: 50               push ax
  0673FD  0D7D: 8a874431         mov al, byte ptr [bx + 0x3144]
  067401  0D81: 50               push ax
  067402  0D82: 9abe071f18       lcall 0x181f, 0x7be
  067407  0D87: 83c404           add sp, 4
  06740A  0D8A: 0bc0             or ax, ax
  06740C  0D8C: 7d63             jge 0xdf1
  06740E  0D8E: 837e0801         cmp word ptr [bp + 8], 1
  067412  0D92: 1bff             sbb di, di
  067414  0D94: 83e740           and di, 0x40
  067417  0D97: 81c78000         add di, 0x80
  06741B  0D9B: 6bde1c           imul bx, si, 0x1c
  06741E  0D9E: 8a874431         mov al, byte ptr [bx + 0x3144]
  067422  0DA2: 2ae4             sub ah, ah
  067424  0DA4: 2b062883         sub ax, word ptr [0x8328]
  067428  0DA8: 03062a83         add ax, word ptr [0x832a]
  06742C  0DAC: f72ed45a         imul word ptr [0x5ad4]
  067430  0DB0: 8946fe           mov word ptr [bp - 2], ax
  067433  0DB3: 8a874531         mov al, byte ptr [bx + 0x3145]
  067437  0DB7: 2ae4             sub ah, ah
  067439  0DB9: 2b062e83         sub ax, word ptr [0x832e]
  06743D  0DBD: 03062c83         add ax, word ptr [0x832c]
  067441  0DC1: f72e2683         imul word ptr [0x8326]
  067445  0DC5: 050800           add ax, 8
  067448  0DC8: 8946fc           mov word ptr [bp - 4], ax
  06744B  0DCB: 8a874731         mov al, byte ptr [bx + 0x3147]
  06744F  0DCF: 240f             and al, 0xf
  067451  0DD1: 3a069653         cmp al, byte ptr [0x5396]
  067455  0DD5: 7403             je 0xdda
  067457  0DD7: 83cf20           or di, 0x20
  06745A  0DDA: ff76fc           push word ptr [bp - 4]
  06745D  0DDD: ff36d45a         push word ptr [0x5ad4]
  067461  0DE1: ff368601         push word ptr [0x186]
  067465  0DE5: 8bc6             mov ax, si
  067467  0DE7: 8bd7             mov dx, di
  067469  0DE9: 8b5efe           mov bx, word ptr [bp - 2]
  06746C  0DEC: 9abc021f18       lcall 0x181f, 0x2bc
  067471  0DF1: 5e               pop si
  067472  0DF2: 5f               pop di
  067473  0DF3: c9               leave 
  067474  0DF4: cb               retf 

; ---- func_067476  size=50  insns=22  prologue=push bp;mov bp,sp  terminal=RETF ----
  067476  0DF6: 55               push bp
  067477  0DF7: 8bec             mov bp, sp
  067479  0DF9: 833ea21e00       cmp word ptr [0x1ea2], 0
  06747E  0DFE: 741a             je 0xe1a
  067480  0E00: 6a00             push 0
  067482  0E02: 6a01             push 1
  067484  0E04: ff369253         push word ptr [0x5392]
  067488  0E08: 0e               push cs
  067489  0E09: e8b301           call 0xfbf
  06748C  0E0C: 8be5             mov sp, bp
  06748E  0E0E: 837e0600         cmp word ptr [bp + 6], 0
  067492  0E12: 7412             je 0xe26
  067494  0E14: 6a01             push 1
  067496  0E16: 6a01             push 1
  067498  0E18: eb04             jmp 0xe1e
  06749A  0E1A: 6a00             push 0
  06749C  0E1C: 6a00             push 0
  06749E  0E1E: ff369253         push word ptr [0x5392]
  0674A2  0E22: 0e               push cs
  0674A3  0E23: e89901           call 0xfbf
  0674A6  0E26: c9               leave 
  0674A7  0E27: cb               retf 

; ---- func_0674A8  size=147  insns=55  prologue=ENTER 0x0004,0  terminal=RETF ----
  0674A8  0E28: c8040000         enter 4, 0
  0674AC  0E2C: 56               push si
  0674AD  0E2D: 833e905300       cmp word ptr [0x5390], 0
  0674B2  0E32: 7576             jne 0xeaa
  0674B4  0E34: 833e260800       cmp word ptr [0x826], 0
  0674B9  0E39: 756f             jne 0xeaa
  0674BB  0E3B: 803e280800       cmp byte ptr [0x828], 0
  0674C0  0E40: 7568             jne 0xeaa
  0674C2  0E42: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  0674C7  0E47: 895efe           mov word ptr [bp - 2], bx
  0674CA  0E4A: 8a874731         mov al, byte ptr [bx + 0x3147]
  0674CE  0E4E: 240f             and al, 0xf
  0674D0  0E50: 3c04             cmp al, 4
  0674D2  0E52: 7356             jae 0xeaa
  0674D4  0E54: 8a874731         mov al, byte ptr [bx + 0x3147]
  0674D8  0E58: 240f             and al, 0xf
  0674DA  0E5A: 2ae4             sub ah, ah
  0674DC  0E5C: 6bd834           imul bx, ax, 0x34
  0674DF  0E5F: 38a73f54         cmp byte ptr [bx + 0x543f], ah
  0674E3  0E63: 7545             jne 0xeaa
  0674E5  0E65: a19253           mov ax, word ptr [0x5392]
  0674E8  0E68: 9a66091f18       lcall 0x181f, 0x966
  0674ED  0E6D: 0bc0             or ax, ax
  0674EF  0E6F: 7439             je 0xeaa
  0674F1  0E71: 8b7606           mov si, word ptr [bp + 6]
  0674F4  0E74: 6bde1c           imul bx, si, 0x1c
  0674F7  0E77: 895efc           mov word ptr [bp - 4], bx
  0674FA  0E7A: 8a874431         mov al, byte ptr [bx + 0x3144]
  0674FE  0E7E: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  067503  0E83: 895efe           mov word ptr [bp - 2], bx
  067506  0E86: 38874431         cmp byte ptr [bx + 0x3144], al
  06750A  0E8A: 751e             jne 0xeaa
  06750C  0E8C: 8b5efc           mov bx, word ptr [bp - 4]
  06750F  0E8F: 8a874531         mov al, byte ptr [bx + 0x3145]
  067513  0E93: 8b5efe           mov bx, word ptr [bp - 2]
  067516  0E96: 38874531         cmp byte ptr [bx + 0x3145], al
  06751A  0E9A: 750e             jne 0xeaa
  06751C  0E9C: 6a01             push 1
  06751E  0E9E: 0e               push cs
  06751F  0E9F: e80901           call 0xfab
  067522  0EA2: 83c402           add sp, 2
  067525  0EA5: 5e               pop si
  067526  0EA6: c9               leave 
  067527  0EA7: cb               retf 
  067528  0EA8: 90               nop 
  067529  0EA9: 90               nop 
  06752A  0EAA: 6a00             push 0
  06752C  0EAC: 6a00             push 0
  06752E  0EAE: ff7606           push word ptr [bp + 6]
  067531  0EB1: 0e               push cs
  067532  0EB2: e80a01           call 0xfbf
  067535  0EB5: 83c406           add sp, 6
  067538  0EB8: 5e               pop si
  067539  0EB9: c9               leave 
  06753A  0EBA: cb               retf 

; ---- func_06753C  size=264  insns=98  prologue=ENTER 0x000E,0  terminal=JMP-tail ----
  06753C  0EBC: c80e0000         enter 0xe, 0
  067540  0EC0: 57               push di
  067541  0EC1: 56               push si
  067542  0EC2: 8b7608           mov si, word ptr [bp + 8]
  067545  0EC5: 8b4606           mov ax, word ptr [bp + 6]
  067548  0EC8: 8946f6           mov word ptr [bp - 0xa], ax
  06754B  0ECB: 03460a           add ax, word ptr [bp + 0xa]
  06754E  0ECE: 48               dec ax
  06754F  0ECF: 8946f8           mov word ptr [bp - 8], ax
  067552  0ED2: 8976f4           mov word ptr [bp - 0xc], si
  067555  0ED5: 03760c           add si, word ptr [bp + 0xc]
  067558  0ED8: 4e               dec si
  067559  0ED9: 8976f2           mov word ptr [bp - 0xe], si
  06755C  0EDC: 8d46f2           lea ax, [bp - 0xe]
  06755F  0EDF: 50               push ax
  067560  0EE0: 8d46f8           lea ax, [bp - 8]
  067563  0EE3: 50               push ax
  067564  0EE4: 8d46f4           lea ax, [bp - 0xc]
  067567  0EE7: 50               push ax
  067568  0EE8: 8d46f6           lea ax, [bp - 0xa]
  06756B  0EEB: 50               push ax
  06756C  0EEC: 9a06091f1a       lcall 0x1a1f, 0x906
  067571  0EF1: 83c408           add sp, 8
  067574  0EF4: 8a0e9653         mov cl, byte ptr [0x5396]
  067578  0EF8: 80c104           add cl, 4
  06757B  0EFB: b001             mov al, 1
  06757D  0EFD: d2e0             shl al, cl
  06757F  0EFF: 8846fd           mov byte ptr [bp - 3], al
  067582  0F02: c746fe0000       mov word ptr [bp - 2], 0
  067587  0F07: 833e9c5300       cmp word ptr [0x539c], 0
  06758C  0F0C: 7e7c             jle 0xf8a
  06758E  0F0E: be4431           mov si, 0x3144
  067591  0F11: 837c1800         cmp word ptr [si + 0x18], 0
  067595  0F15: 7d65             jge 0xf7c
  067597  0F17: 8a04             mov al, byte ptr [si]
  067599  0F19: 2ae4             sub ah, ah
  06759B  0F1B: 8bf8             mov di, ax
  06759D  0F1D: 8a4c01           mov cl, byte ptr [si + 1]
  0675A0  0F20: 2aed             sub ch, ch
  0675A2  0F22: 3b46f6           cmp ax, word ptr [bp - 0xa]
  0675A5  0F25: 7c55             jl 0xf7c
  0675A7  0F27: 397ef8           cmp word ptr [bp - 8], di
  0675AA  0F2A: 7c50             jl 0xf7c
  0675AC  0F2C: 394ef4           cmp word ptr [bp - 0xc], cx
  0675AF  0F2F: 7f4b             jg 0xf7c
  0675B1  0F31: 394ef2           cmp word ptr [bp - 0xe], cx
  0675B4  0F34: 7c46             jl 0xf7c
  0675B6  0F36: 8a4403           mov al, byte ptr [si + 3]
  0675B9  0F39: 240f             and al, 0xf
  0675BB  0F3B: 3a069653         cmp al, byte ptr [0x5396]
  0675BF  0F3F: 7517             jne 0xf58
  0675C1  0F41: 51               push cx
  0675C2  0F42: 57               push di
  0675C3  0F43: 9a4a071f18       lcall 0x181f, 0x74a
  0675C8  0F48: 83c404           add sp, 4
  0675CB  0F4B: 2246fd           and al, byte ptr [bp - 3]
  0675CE  0F4E: 2ae4             sub ah, ah
  0675D0  0F50: 8946fa           mov word ptr [bp - 6], ax
  0675D3  0F53: 8bd0             mov dx, ax
  0675D5  0F55: eb11             jmp 0xf68
  0675D7  0F57: 90               nop 
  0675D8  0F58: 8a5403           mov dl, byte ptr [si + 3]
  0675DB  0F5B: 8a0e9653         mov cl, byte ptr [0x5396]
  0675DF  0F5F: b81000           mov ax, 0x10
  0675E2  0F62: d3e0             shl ax, cl
  0675E4  0F64: 22d0             and dl, al
  0675E6  0F66: 2af6             sub dh, dh
  0675E8  0F68: 0bd2             or dx, dx
  0675EA  0F6A: 7506             jne 0xf72
  0675EC  0F6C: 3916a253         cmp word ptr [0x53a2], dx
  0675F0  0F70: 740a             je 0xf7c
  0675F2  0F72: ff76fe           push word ptr [bp - 2]
  0675F5  0F75: 0e               push cs
  0675F6  0F76: e83c00           call 0xfb5
  0675F9  0F79: 83c402           add sp, 2
  0675FC  0F7C: 83c61c           add si, 0x1c
  0675FF  0F7F: a19c53           mov ax, word ptr [0x539c]
  067602  0F82: ff46fe           inc word ptr [bp - 2]
  067605  0F85: 3946fe           cmp word ptr [bp - 2], ax
  067608  0F88: 7c87             jl 0xf11
  06760A  0F8A: 5e               pop si
  06760B  0F8B: 5f               pop di
  06760C  0F8C: c9               leave 
  06760D  0F8D: cb               retf 
  06760E  0F8E: ff364685         push word ptr [0x8546]
  067612  0F92: ff364485         push word ptr [0x8544]
  067616  0F96: ff362e83         push word ptr [0x832e]
  06761A  0F9A: ff362883         push word ptr [0x8328]
  06761E  0F9E: 0e               push cs
  06761F  0F9F: e80400           call 0xfa6
  067622  0FA2: 83c408           add sp, 8
  067625  0FA5: cb               retf 
  067626  0FA6: ea44031f18       ljmp 0x181f:0x344
  06762B  0FAB: ea2a0e1f18       ljmp 0x181f:0xe2a
  067630  0FB0: ea22091f1a       ljmp 0x1a1f:0x922
  067635  0FB5: ea30091f1a       ljmp 0x1a1f:0x930
  06763A  0FBA: ea4c091f1a       ljmp 0x1a1f:0x94c
  06763F  0FBF: ea5a091f1a       ljmp 0x1a1f:0x95a

; ---- func_067644  size=188  insns=66  prologue=ENTER 0x0002,0  terminal=RETF ----
  067644  0FC4: c8020000         enter 2, 0
  067648  0FC8: 56               push si
  067649  0FC9: 8b760e           mov si, word ptr [bp + 0xe]
  06764C  0FCC: 8d460c           lea ax, [bp + 0xc]
  06764F  0FCF: 50               push ax
  067650  0FD0: 8d4e0a           lea cx, [bp + 0xa]
  067653  0FD3: 51               push cx
  067654  0FD4: 8d5608           lea dx, [bp + 8]
  067657  0FD7: 52               push dx
  067658  0FD8: 8d5e06           lea bx, [bp + 6]
  06765B  0FDB: 53               push bx
  06765C  0FDC: 9a14091f1a       lcall 0x1a1f, 0x914
  067661  0FE1: 83c408           add sp, 8
  067664  0FE4: ff760c           push word ptr [bp + 0xc]
  067667  0FE7: 833ea25300       cmp word ptr [0x53a2], 0
  06766C  0FEC: 7406             je 0xff4
  06766E  0FEE: b8ffff           mov ax, 0xffff
  067671  0FF1: eb04             jmp 0xff7
  067673  0FF3: 90               nop 
  067674  0FF4: a19653           mov ax, word ptr [0x5396]
  067677  0FF7: 50               push ax
  067678  0FF8: 8b4606           mov ax, word ptr [bp + 6]
  06767B  0FFB: 8b5608           mov dx, word ptr [bp + 8]
  06767E  0FFE: 8b5e0a           mov bx, word ptr [bp + 0xa]
  067681  1001: 9a68091f1a       lcall 0x1a1f, 0x968
  067686  1006: 9a88081f19       lcall 0x191f, 0x888
  06768B  100B: 9a96081f19       lcall 0x191f, 0x896
  067690  1010: ff760c           push word ptr [bp + 0xc]
  067693  1013: ff760a           push word ptr [bp + 0xa]
  067696  1016: ff7608           push word ptr [bp + 8]
  067699  1019: ff7606           push word ptr [bp + 6]
  06769C  101C: 9a2c031f18       lcall 0x181f, 0x32c
  0676A1  1021: 83c408           add sp, 8
  0676A4  1024: ff760c           push word ptr [bp + 0xc]
  0676A7  1027: ff760a           push word ptr [bp + 0xa]
  0676AA  102A: ff7608           push word ptr [bp + 8]
  0676AD  102D: ff7606           push word ptr [bp + 6]
  0676B0  1030: 9a44031f18       lcall 0x181f, 0x344
  0676B5  1035: 83c408           add sp, 8
  0676B8  1038: 6a00             push 0
  0676BA  103A: 8976fe           mov word ptr [bp - 2], si
  0676BD  103D: 833ea25300       cmp word ptr [0x53a2], 0
  0676C2  1042: 7406             je 0x104a
  0676C4  1044: b8ffff           mov ax, 0xffff
  0676C7  1047: eb04             jmp 0x104d
  0676C9  1049: 90               nop 
  0676CA  104A: a19653           mov ax, word ptr [0x5396]
  0676CD  104D: 50               push ax
  0676CE  104E: 56               push si
  0676CF  104F: ff760c           push word ptr [bp + 0xc]
  0676D2  1052: ff760a           push word ptr [bp + 0xa]
  0676D5  1055: ff7608           push word ptr [bp + 8]
  0676D8  1058: ff7606           push word ptr [bp + 6]
  0676DB  105B: 9a380e1f18       lcall 0x181f, 0xe38
  0676E0  1060: 83c40e           add sp, 0xe
  0676E3  1063: 837efe00         cmp word ptr [bp - 2], 0
  0676E7  1067: 7414             je 0x107d
  0676E9  1069: ff760c           push word ptr [bp + 0xc]
  0676EC  106C: ff760a           push word ptr [bp + 0xa]
  0676EF  106F: ff7608           push word ptr [bp + 8]
  0676F2  1072: ff7606           push word ptr [bp + 6]
  0676F5  1075: 9af8081f1a       lcall 0x1a1f, 0x8f8
  0676FA  107A: 83c408           add sp, 8
  0676FD  107D: 5e               pop si
  0676FE  107E: c9               leave 
  0676FF  107F: cb               retf 

; ---- func_067700  size=202  insns=65  prologue=ENTER 0x0050,0  terminal=RETF ----
  067700  1080: c8500000         enter 0x50, 0
  067704  1084: ff36ae2d         push word ptr [0x2dae]
  067708  1088: ff36ac2d         push word ptr [0x2dac]
  06770C  108C: ff36aa2d         push word ptr [0x2daa]
  067710  1090: ff36a82d         push word ptr [0x2da8]
  067714  1094: a15285           mov ax, word ptr [0x8552]
  067717  1097: 050800           add ax, 8
  06771A  109A: 50               push ax
  06771B  109B: 6a00             push 0
  06771D  109D: b8ffff           mov ax, 0xffff
  067720  10A0: ba0700           mov dx, 7
  067723  10A3: 8b1e5085         mov bx, word ptr [0x8550]
  067727  10A7: 9ace001f18       lcall 0x181f, 0xce
  06772C  10AC: 833ea25300       cmp word ptr [0x53a2], 0
  067731  10B1: 7405             je 0x10b8
  067733  10B3: b8ffff           mov ax, 0xffff
  067736  10B6: eb03             jmp 0x10bb
  067738  10B8: a19653           mov ax, word ptr [0x5396]
  06773B  10BB: 9aa4021f19       lcall 0x191f, 0x2a4
  067740  10C0: 9a88081f19       lcall 0x191f, 0x888
  067745  10C5: 9a96081f19       lcall 0x191f, 0x896
  06774A  10CA: 9a96021f19       lcall 0x191f, 0x296
  06774F  10CF: 9a3e091f1a       lcall 0x1a1f, 0x93e
  067754  10D4: 833e840103       cmp word ptr [0x184], 3
  067759  10D9: 7546             jne 0x1121
  06775B  10DB: c646b000         mov byte ptr [bp - 0x50], 0
  06775F  10DF: 6b06965334       imul ax, word ptr [0x5396], 0x34
  067764  10E4: 052654           add ax, 0x5426
  067767  10E7: 50               push ax
  067768  10E8: 8d46b0           lea ax, [bp - 0x50]
  06776B  10EB: 50               push ax
  06776C  10EC: 9ae4071d0d       lcall 0xd1d, 0x7e4
  067771  10F1: 83c404           add sp, 4
  067774  10F4: 6a0f             push 0xf
  067776  10F6: a12c83           mov ax, word ptr [0x832c]
  067779  10F9: f72e2683         imul word ptr [0x8326]
  06777D  10FD: c41e9e08         les bx, ptr [0x89e]
  067781  1101: 268a0f           mov cl, byte ptr es:[bx]
  067784  1104: 2aed             sub ch, ch
  067786  1106: 03c1             add ax, cx
  067788  1108: d1f8             sar ax, 1
  06778A  110A: 050800           add ax, 8
  06778D  110D: 50               push ax
  06778E  110E: ff365085         push word ptr [0x8550]
  067792  1112: 6a00             push 0
  067794  1114: 8d46b0           lea ax, [bp - 0x50]
  067797  1117: 16               push ss
  067798  1118: 50               push ax
  067799  1119: 9a00011f18       lcall 0x181f, 0x100
  06779E  111E: 83c40c           add sp, 0xc
  0677A1  1121: 833ea25300       cmp word ptr [0x53a2], 0
  0677A6  1126: 7406             je 0x112e
  0677A8  1128: b8ffff           mov ax, 0xffff
  0677AB  112B: eb04             jmp 0x1131
  0677AD  112D: 90               nop 
  0677AE  112E: a19653           mov ax, word ptr [0x5396]
  0677B1  1131: 50               push ax
  0677B2  1132: ff7606           push word ptr [bp + 6]
  0677B5  1135: 9aa4081f1a       lcall 0x1a1f, 0x8a4
  0677BA  113A: 83c404           add sp, 4
  0677BD  113D: 837e0600         cmp word ptr [bp + 6], 0
  0677C1  1141: 7405             je 0x1148
  0677C3  1143: 9aea081f1a       lcall 0x1a1f, 0x8ea
  0677C8  1148: c9               leave 
  0677C9  1149: cb               retf 

; ---- func_0677CA  size=178  insns=62  prologue=ENTER 0x0008,0  terminal=RETF ----
  0677CA  114A: c8080000         enter 8, 0
  0677CE  114E: 6b1e92531c       imul bx, word ptr [0x5392], 0x1c
  0677D3  1153: 8a874431         mov al, byte ptr [bx + 0x3144]
  0677D7  1157: 2ae4             sub ah, ah
  0677D9  1159: 8946fe           mov word ptr [bp - 2], ax
  0677DC  115C: 8a874531         mov al, byte ptr [bx + 0x3145]
  0677E0  1160: 8946fc           mov word ptr [bp - 4], ax
  0677E3  1163: b80100           mov ax, 1
  0677E6  1166: 8946f8           mov word ptr [bp - 8], ax
  0677E9  1169: 8946fa           mov word ptr [bp - 6], ax
  0677EC  116C: 8d46f8           lea ax, [bp - 8]
  0677EF  116F: 50               push ax
  0677F0  1170: 8d4efa           lea cx, [bp - 6]
  0677F3  1173: 51               push cx
  0677F4  1174: 8d56fc           lea dx, [bp - 4]
  0677F7  1177: 52               push dx
  0677F8  1178: 8d5efe           lea bx, [bp - 2]
  0677FB  117B: 53               push bx
  0677FC  117C: 9a14091f1a       lcall 0x1a1f, 0x914
  067801  1181: 83c408           add sp, 8
  067804  1184: ff76f8           push word ptr [bp - 8]
  067807  1187: ff76fa           push word ptr [bp - 6]
  06780A  118A: ff76fc           push word ptr [bp - 4]
  06780D  118D: ff76fe           push word ptr [bp - 2]
  067810  1190: 9a2c031f18       lcall 0x181f, 0x32c
  067815  1195: 83c408           add sp, 8
  067818  1198: ff7606           push word ptr [bp + 6]
  06781B  119B: 9a2a0e1f18       lcall 0x181f, 0xe2a
  067820  11A0: 83c402           add sp, 2
  067823  11A3: ff76f8           push word ptr [bp - 8]
  067826  11A6: ff76fa           push word ptr [bp - 6]
  067829  11A9: ff76fc           push word ptr [bp - 4]
  06782C  11AC: ff76fe           push word ptr [bp - 2]
  06782F  11AF: 9af8081f1a       lcall 0x1a1f, 0x8f8
  067834  11B4: c9               leave 
  067835  11B5: cb               retf 
  067836  11B6: 8b1e9453         mov bx, word ptr [0x5394]
  06783A  11BA: 8bc3             mov ax, bx
  06783C  11BC: d1e3             shl bx, 1
  06783E  11BE: 03d8             add bx, ax
  067840  11C0: d1e3             shl bx, 1
  067842  11C2: 81c38e94         add bx, 0x948e
  067846  11C6: a17c01           mov ax, word ptr [0x17c]
  067849  11C9: 8907             mov word ptr [bx], ax
  06784B  11CB: a17e01           mov ax, word ptr [0x17e]
  06784E  11CE: 894702           mov word ptr [bx + 2], ax
  067851  11D1: a18401           mov ax, word ptr [0x184]
  067854  11D4: 894704           mov word ptr [bx + 4], ax
  067857  11D7: cb               retf 
  067858  11D8: 8b1e9453         mov bx, word ptr [0x5394]
  06785C  11DC: 8bc3             mov ax, bx
  06785E  11DE: d1e3             shl bx, 1
  067860  11E0: 03d8             add bx, ax
  067862  11E2: d1e3             shl bx, 1
  067864  11E4: 8b878e94         mov ax, word ptr [bx - 0x6b72]
  067868  11E8: a37c01           mov word ptr [0x17c], ax
  06786B  11EB: 81c38e94         add bx, 0x948e
  06786F  11EF: 8b4702           mov ax, word ptr [bx + 2]
  067872  11F2: a37e01           mov word ptr [0x17e], ax
  067875  11F5: 8b4704           mov ax, word ptr [bx + 4]
  067878  11F8: a38401           mov word ptr [0x184], ax
  06787B  11FB: cb               retf 

; ---- func_06787C  size=423  insns=157  prologue=ENTER 0x0004,0  terminal=RETF ----
  06787C  11FC: c8040000         enter 4, 0
  067880  1200: 8a0e8401         mov cl, byte ptr [0x184]
  067884  1204: b80f00           mov ax, 0xf
  067887  1207: d3e0             shl ax, cl
  067889  1209: a34485           mov word ptr [0x8544], ax
  06788C  120C: b80c00           mov ax, 0xc
  06788F  120F: d3e0             shl ax, cl
  067891  1211: a34685           mov word ptr [0x8546], ax
  067894  1214: 833e8a0100       cmp word ptr [0x18a], 0
  067899  1219: 740f             je 0x122a
  06789B  121B: b80500           mov ax, 5
  06789E  121E: a34485           mov word ptr [0x8544], ax
  0678A1  1221: a34685           mov word ptr [0x8546], ax
  0678A4  1224: c70684010000     mov word ptr [0x184], 0
  0678AA  122A: 8a0e8401         mov cl, byte ptr [0x184]
  0678AE  122E: b81000           mov ax, 0x10
  0678B1  1231: d3f8             sar ax, cl
  0678B3  1233: a3d45a           mov word ptr [0x5ad4], ax
  0678B6  1236: a32683           mov word ptr [0x8326], ax
  0678B9  1239: a14485           mov ax, word ptr [0x8544]
  0678BC  123C: d1f8             sar ax, 1
  0678BE  123E: 2b067c01         sub ax, word ptr [0x17c]
  0678C2  1242: f7d8             neg ax
  0678C4  1244: a32883           mov word ptr [0x8328], ax
  0678C7  1247: 8b0e4685         mov cx, word ptr [0x8546]
  0678CB  124B: d1f9             sar cx, 1
  0678CD  124D: 2b0e7e01         sub cx, word ptr [0x17e]
  0678D1  1251: f7d9             neg cx
  0678D3  1253: 890e2e83         mov word ptr [0x832e], cx
  0678D7  1257: 833e8a0100       cmp word ptr [0x18a], 0
  0678DC  125C: 7534             jne 0x1292
  0678DE  125E: 3d0100           cmp ax, 1
  0678E1  1261: 7d03             jge 0x1266
  0678E3  1263: b80100           mov ax, 1
  0678E6  1266: 8b163a85         mov dx, word ptr [0x853a]
  0678EA  126A: 2b164485         sub dx, word ptr [0x8544]
  0678EE  126E: 4a               dec dx
  0678EF  126F: 3bc2             cmp ax, dx
  0678F1  1271: 7e02             jle 0x1275
  0678F3  1273: 8bc2             mov ax, dx
  0678F5  1275: a32883           mov word ptr [0x8328], ax
  0678F8  1278: 83f901           cmp cx, 1
  0678FB  127B: 7d03             jge 0x1280
  0678FD  127D: b90100           mov cx, 1
  067900  1280: a13c85           mov ax, word ptr [0x853c]
  067903  1283: 2b064685         sub ax, word ptr [0x8546]
  067907  1287: 48               dec ax
  067908  1288: 3bc8             cmp cx, ax
  06790A  128A: 7e02             jle 0x128e
  06790C  128C: 8bc8             mov cx, ax
  06790E  128E: 890e2e83         mov word ptr [0x832e], cx
  067912  1292: 2bc0             sub ax, ax
  067914  1294: a32a83           mov word ptr [0x832a], ax
  067917  1297: a32c83           mov word ptr [0x832c], ax
  06791A  129A: a13a85           mov ax, word ptr [0x853a]
  06791D  129D: 48               dec ax
  06791E  129E: 48               dec ax
  06791F  129F: 3b064485         cmp ax, word ptr [0x8544]
  067923  12A3: 7d19             jge 0x12be
  067925  12A5: c70628830100     mov word ptr [0x8328], 1
  06792B  12AB: 8b0e4485         mov cx, word ptr [0x8544]
  06792F  12AF: 2b0e3a85         sub cx, word ptr [0x853a]
  067933  12B3: 41               inc cx
  067934  12B4: 41               inc cx
  067935  12B5: d1f9             sar cx, 1
  067937  12B7: 890e2a83         mov word ptr [0x832a], cx
  06793B  12BB: a34485           mov word ptr [0x8544], ax
  06793E  12BE: a13c85           mov ax, word ptr [0x853c]
  067941  12C1: 48               dec ax
  067942  12C2: 48               dec ax
  067943  12C3: 3b064685         cmp ax, word ptr [0x8546]
  067947  12C7: 7d19             jge 0x12e2
  067949  12C9: c7062e830100     mov word ptr [0x832e], 1
  06794F  12CF: 8b0e4685         mov cx, word ptr [0x8546]
  067953  12D3: 2b0e3c85         sub cx, word ptr [0x853c]
  067957  12D7: 41               inc cx
  067958  12D8: 41               inc cx
  067959  12D9: d1f9             sar cx, 1
  06795B  12DB: 890e2c83         mov word ptr [0x832c], cx
  06795F  12DF: a34685           mov word ptr [0x8546], ax
  067962  12E2: a12883           mov ax, word ptr [0x8328]
  067965  12E5: 48               dec ax
  067966  12E6: a34c85           mov word ptr [0x854c], ax
  067969  12E9: a12e83           mov ax, word ptr [0x832e]
  06796C  12EC: 48               dec ax
  06796D  12ED: a34e85           mov word ptr [0x854e], ax
  067970  12F0: 833e5a0100       cmp word ptr [0x15a], 0
  067975  12F5: 7471             je 0x1368
  067977  12F7: 833e8a0100       cmp word ptr [0x18a], 0
  06797C  12FC: 7518             jne 0x1316
  06797E  12FE: 8a0e8401         mov cl, byte ptr [0x184]
  067982  1302: b80f00           mov ax, 0xf
  067985  1305: d3e0             shl ax, cl
  067987  1307: 40               inc ax
  067988  1308: 40               inc ax
  067989  1309: a34885           mov word ptr [0x8548], ax
  06798C  130C: b80c00           mov ax, 0xc
  06798F  130F: d3e0             shl ax, cl
  067991  1311: 40               inc ax
  067992  1312: 40               inc ax
  067993  1313: eb5c             jmp 0x1371
  067995  1315: 90               nop 
  067996  1316: a14c85           mov ax, word ptr [0x854c]
  067999  1319: 050600           add ax, 6
  06799C  131C: 8946fe           mov word ptr [bp - 2], ax
  06799F  131F: a14e85           mov ax, word ptr [0x854e]
  0679A2  1322: 050600           add ax, 6
  0679A5  1325: 8946fc           mov word ptr [bp - 4], ax
  0679A8  1328: a13a85           mov ax, word ptr [0x853a]
  0679AB  132B: 48               dec ax
  0679AC  132C: 3b46fe           cmp ax, word ptr [bp - 2]
  0679AF  132F: 7e03             jle 0x1334
  0679B1  1331: 8b46fe           mov ax, word ptr [bp - 2]
  0679B4  1334: 8b0e4c85         mov cx, word ptr [0x854c]
  0679B8  1338: 0bc9             or cx, cx
  0679BA  133A: 7d02             jge 0x133e
  0679BC  133C: 2bc9             sub cx, cx
  0679BE  133E: 890e4c85         mov word ptr [0x854c], cx
  0679C2  1342: 2bc1             sub ax, cx
  0679C4  1344: 40               inc ax
  0679C5  1345: a34885           mov word ptr [0x8548], ax
  0679C8  1348: a13c85           mov ax, word ptr [0x853c]
  0679CB  134B: 48               dec ax
  0679CC  134C: 3b46fc           cmp ax, word ptr [bp - 4]
  0679CF  134F: 7e03             jle 0x1354
  0679D1  1351: 8b46fc           mov ax, word ptr [bp - 4]
  0679D4  1354: 8b0e4e85         mov cx, word ptr [0x854e]
  0679D8  1358: 0bc9             or cx, cx
  0679DA  135A: 7d02             jge 0x135e
  0679DC  135C: 2bc9             sub cx, cx
  0679DE  135E: 890e4e85         mov word ptr [0x854e], cx
  0679E2  1362: 2bc1             sub ax, cx
  0679E4  1364: 40               inc ax
  0679E5  1365: eb0a             jmp 0x1371
  0679E7  1367: 90               nop 
  0679E8  1368: a13a85           mov ax, word ptr [0x853a]
  0679EB  136B: a34885           mov word ptr [0x8548], ax
  0679EE  136E: a13c85           mov ax, word ptr [0x853c]
  0679F1  1371: a34a85           mov word ptr [0x854a], ax
  0679F4  1374: 8a0e8401         mov cl, byte ptr [0x184]
  0679F8  1378: b86400           mov ax, 0x64
  0679FB  137B: d3f8             sar ax, cl
  0679FD  137D: a38601           mov word ptr [0x186], ax
  067A00  1380: b80500           mov ax, 5
  067A03  1383: d3e0             shl ax, cl
  067A05  1385: 050500           add ax, 5
  067A08  1388: a38801           mov word ptr [0x188], ax
  067A0B  138B: a14485           mov ax, word ptr [0x8544]
  067A0E  138E: 03062883         add ax, word ptr [0x8328]
  067A12  1392: 48               dec ax
  067A13  1393: a30488           mov word ptr [0x8804], ax
  067A16  1396: a14685           mov ax, word ptr [0x8546]
  067A19  1399: 03062e83         add ax, word ptr [0x832e]
  067A1D  139D: 48               dec ax
  067A1E  139E: a30688           mov word ptr [0x8806], ax
  067A21  13A1: c9               leave 
  067A22  13A2: cb               retf 

; ---- func_067A24  size=352  insns=128  prologue=ENTER 0x0010,0  terminal=RET ----
  067A24  13A4: c8100000         enter 0x10, 0
  067A28  13A8: 56               push si
  067A29  13A9: 2ac0             sub al, al
  067A2B  13AB: a2a3a8           mov byte ptr [0xa8a3], al
  067A2E  13AE: a2a6a8           mov byte ptr [0xa8a6], al
  067A31  13B1: c746fc0000       mov word ptr [bp - 4], 0
  067A36  13B6: 8b5efc           mov bx, word ptr [bp - 4]
  067A39  13B9: c687242d00       mov byte ptr [bx + 0x2d24], 0
  067A3E  13BE: ff46fc           inc word ptr [bp - 4]
  067A41  13C1: 837efc04         cmp word ptr [bp - 4], 4
  067A45  13C5: 7cef             jl 0x13b6
  067A47  13C7: 833e840100       cmp word ptr [0x184], 0
  067A4C  13CC: 7403             je 0x13d1
  067A4E  13CE: e9bf00           jmp 0x1490
  067A51  13D1: c746fc0000       mov word ptr [bp - 4], 0
  067A56  13D6: e99e00           jmp 0x1477
  067A59  13D9: 90               nop 
  067A5A  13DA: a14885           mov ax, word ptr [0x8548]
  067A5D  13DD: f7d8             neg ax
  067A5F  13DF: 8946f2           mov word ptr [bp - 0xe], ax
  067A62  13E2: 80bfbe0000       cmp byte ptr [bx + 0xbe], 0
  067A67  13E7: 7e05             jle 0x13ee
  067A69  13E9: a14885           mov ax, word ptr [0x8548]
  067A6C  13EC: eb02             jmp 0x13f0
  067A6E  13EE: 2bc0             sub ax, ax
  067A70  13F0: 8946f0           mov word ptr [bp - 0x10], ax
  067A73  13F3: 8a87b400         mov al, byte ptr [bx + 0xb4]
  067A77  13F7: 98               cwde 
  067A78  13F8: 8bd8             mov bx, ax
  067A7A  13FA: 031e98a5         add bx, word ptr [0xa598]
  067A7E  13FE: 8e069aa5         mov es, word ptr [0xa59a]
  067A82  1402: 035ef2           add bx, word ptr [bp - 0xe]
  067A85  1405: 8b76f0           mov si, word ptr [bp - 0x10]
  067A88  1408: 268a00           mov al, byte ptr es:[bx + si]
  067A8B  140B: 241f             and al, 0x1f
  067A8D  140D: 8846f6           mov byte ptr [bp - 0xa], al
  067A90  1410: 3c18             cmp al, 0x18
  067A92  1412: 7304             jae 0x1418
  067A94  1414: 8066f607         and byte ptr [bp - 0xa], 7
  067A98  1418: 8a46f6           mov al, byte ptr [bp - 0xa]
  067A9B  141B: 2ae4             sub ah, ah
  067A9D  141D: 50               push ax
  067A9E  141E: 9aaa061f18       lcall 0x181f, 0x6aa
  067AA3  1423: 83c402           add sp, 2
  067AA6  1426: 3c19             cmp al, 0x19
  067AA8  1428: 744a             je 0x1474
  067AAA  142A: 3c1a             cmp al, 0x1a
  067AAC  142C: 7446             je 0x1474
  067AAE  142E: 8a4efc           mov cl, byte ptr [bp - 4]
  067AB1  1431: b001             mov al, 1
  067AB3  1433: d2e0             shl al, cl
  067AB5  1435: 0806a6a8         or byte ptr [0xa8a6], al
  067AB9  1439: fe06a3a8         inc byte ptr [0xa8a3]
  067ABD  143D: f646fc01         test byte ptr [bp - 4], 1
  067AC1  1441: 7411             je 0x1454
  067AC3  1443: 8ad9             mov bl, cl
  067AC5  1445: fec3             inc bl
  067AC7  1447: 83e306           and bx, 6
  067ACA  144A: d1fb             sar bx, 1
  067ACC  144C: 808f242d02       or byte ptr [bx + 0x2d24], 2
  067AD1  1451: eb21             jmp 0x1474
  067AD3  1453: 90               nop 
  067AD4  1454: 8a46f6           mov al, byte ptr [bp - 0xa]
  067AD7  1457: a2a1a8           mov byte ptr [0xa8a1], al
  067ADA  145A: 8b46fc           mov ax, word ptr [bp - 4]
  067ADD  145D: d1f8             sar ax, 1
  067ADF  145F: 8bc8             mov cx, ax
  067AE1  1461: fec0             inc al
  067AE3  1463: 250300           and ax, 3
  067AE6  1466: 8bd9             mov bx, cx
  067AE8  1468: 808f242d04       or byte ptr [bx + 0x2d24], 4
  067AED  146D: 8bd8             mov bx, ax
  067AEF  146F: 808f242d01       or byte ptr [bx + 0x2d24], 1
  067AF4  1474: ff46fc           inc word ptr [bp - 4]
  067AF7  1477: 837efc08         cmp word ptr [bp - 4], 8
  067AFB  147B: 7d13             jge 0x1490
  067AFD  147D: 8b5efc           mov bx, word ptr [bp - 4]
  067B00  1480: 80bfbe0000       cmp byte ptr [bx + 0xbe], 0
  067B05  1485: 7d03             jge 0x148a
  067B07  1487: e950ff           jmp 0x13da
  067B0A  148A: 2bc0             sub ax, ax
  067B0C  148C: e950ff           jmp 0x13df
  067B0F  148F: 90               nop 
  067B10  1490: a0a1a8           mov al, byte ptr [0xa8a1]
  067B13  1493: 2ae4             sub ah, ah
  067B15  1495: 50               push ax
  067B16  1496: 9aaa061f18       lcall 0x181f, 0x6aa
  067B1B  149B: 83c402           add sp, 2
  067B1E  149E: a2a2a8           mov byte ptr [0xa8a2], al
  067B21  14A1: a0a3a8           mov al, byte ptr [0xa8a3]
  067B24  14A4: 2ae4             sub ah, ah
  067B26  14A6: 5e               pop si
  067B27  14A7: c9               leave 
  067B28  14A8: c3               ret 
  067B29  14A9: 90               nop 
  067B2A  14AA: 56               push si
  067B2B  14AB: c41e98a5         les bx, ptr [0xa598]
  067B2F  14AF: 8bf0             mov si, ax
  067B31  14B1: 268a00           mov al, byte ptr es:[bx + si]
  067B34  14B4: 3a06a4a8         cmp al, byte ptr [0xa8a4]
  067B38  14B8: 720a             jb 0x14c4
  067B3A  14BA: 3a06a5a8         cmp al, byte ptr [0xa8a5]
  067B3E  14BE: 7704             ja 0x14c4
  067B40  14C0: 0016a3a8         add byte ptr [0xa8a3], dl
  067B44  14C4: 5e               pop si
  067B45  14C5: c3               ret 
  067B46  14C6: c606a3a800       mov byte ptr [0xa8a3], 0
  067B4B  14CB: 391e8401         cmp word ptr [0x184], bx
  067B4F  14CF: 7f2d             jg 0x14fe
  067B51  14D1: a2a4a8           mov byte ptr [0xa8a4], al
  067B54  14D4: 8ac2             mov al, dl
  067B56  14D6: a2a5a8           mov byte ptr [0xa8a5], al
  067B59  14D9: a14885           mov ax, word ptr [0x8548]
  067B5C  14DC: f7d8             neg ax
  067B5E  14DE: ba0800           mov dx, 8
  067B61  14E1: e8c6ff           call 0x14aa
  067B64  14E4: a14885           mov ax, word ptr [0x8548]
  067B67  14E7: ba0400           mov dx, 4
  067B6A  14EA: e8bdff           call 0x14aa
  067B6D  14ED: b8ffff           mov ax, 0xffff
  067B70  14F0: ba0200           mov dx, 2
  067B73  14F3: e8b4ff           call 0x14aa
  067B76  14F6: b80100           mov ax, 1
  067B79  14F9: 8bd0             mov dx, ax
  067B7B  14FB: e8acff           call 0x14aa
  067B7E  14FE: a0a3a8           mov al, byte ptr [0xa8a3]
  067B81  1501: 2ae4             sub ah, ah
  067B83  1503: c3               ret 

; ---- func_067B84  size=96  insns=34  prologue=ENTER 0x0002,0  terminal=RET ----
  067B84  1504: c8020000         enter 2, 0
  067B88  1508: 50               push ax
  067B89  1509: 56               push si
  067B8A  150A: c746fe0000       mov word ptr [bp - 2], 0
  067B8F  150F: 3b168401         cmp dx, word ptr [0x184]
  067B93  1513: 7c49             jl 0x155e
  067B95  1515: c41e98a5         les bx, ptr [0xa598]
  067B99  1519: 2b1e4885         sub bx, word ptr [0x8548]
  067B9D  151D: 268a07           mov al, byte ptr es:[bx]
  067BA0  1520: 2ae4             sub ah, ah
  067BA2  1522: 8546fc           test word ptr [bp - 4], ax
  067BA5  1525: 7404             je 0x152b
  067BA7  1527: 8346fe08         add word ptr [bp - 2], 8
  067BAB  152B: 8b1e98a5         mov bx, word ptr [0xa598]
  067BAF  152F: 8b364885         mov si, word ptr [0x8548]
  067BB3  1533: 268a00           mov al, byte ptr es:[bx + si]
  067BB6  1536: 2ae4             sub ah, ah
  067BB8  1538: 8546fc           test word ptr [bp - 4], ax
  067BBB  153B: 7404             je 0x1541
  067BBD  153D: 8346fe04         add word ptr [bp - 2], 4
  067BC1  1541: 268a47ff         mov al, byte ptr es:[bx - 1]
  067BC5  1545: 2ae4             sub ah, ah
  067BC7  1547: 8546fc           test word ptr [bp - 4], ax
  067BCA  154A: 7404             je 0x1550
  067BCC  154C: 8346fe02         add word ptr [bp - 2], 2
  067BD0  1550: 268a4701         mov al, byte ptr es:[bx + 1]
  067BD4  1554: 2ae4             sub ah, ah
  067BD6  1556: 8546fc           test word ptr [bp - 4], ax
  067BD9  1559: 7403             je 0x155e
  067BDB  155B: ff46fe           inc word ptr [bp - 2]
  067BDE  155E: 8b46fe           mov ax, word ptr [bp - 2]
  067BE1  1561: 5e               pop si
  067BE2  1562: c9               leave 
  067BE3  1563: c3               ret 

; ---- func_067BE4  size=111  insns=38  prologue=ENTER 0x0004,0  terminal=RET ----
  067BE4  1564: c8040000         enter 4, 0
  067BE8  1568: 50               push ax
  067BE9  1569: 56               push si
  067BEA  156A: c746fc0000       mov word ptr [bp - 4], 0
  067BEF  156F: 39168401         cmp word ptr [0x184], dx
  067BF3  1573: 7f58             jg 0x15cd
  067BF5  1575: c746fea000       mov word ptr [bp - 2], 0xa0
  067BFA  157A: c41e98a5         les bx, ptr [0xa598]
  067BFE  157E: 2b1e4885         sub bx, word ptr [0x8548]
  067C02  1582: 268a07           mov al, byte ptr es:[bx]
  067C05  1585: 25a000           and ax, 0xa0
  067C08  1588: 3b46fa           cmp ax, word ptr [bp - 6]
  067C0B  158B: 7504             jne 0x1591
  067C0D  158D: 8346fc08         add word ptr [bp - 4], 8
  067C11  1591: 8b1e98a5         mov bx, word ptr [0xa598]
  067C15  1595: 8b364885         mov si, word ptr [0x8548]
  067C19  1599: 268a00           mov al, byte ptr es:[bx + si]
  067C1C  159C: 2246fe           and al, byte ptr [bp - 2]
  067C1F  159F: 2ae4             sub ah, ah
  067C21  15A1: 3b46fa           cmp ax, word ptr [bp - 6]
  067C24  15A4: 7504             jne 0x15aa
  067C26  15A6: 8346fc04         add word ptr [bp - 4], 4
  067C2A  15AA: 268a47ff         mov al, byte ptr es:[bx - 1]
  067C2E  15AE: 2246fe           and al, byte ptr [bp - 2]
  067C31  15B1: 2ae4             sub ah, ah
  067C33  15B3: 3b46fa           cmp ax, word ptr [bp - 6]
  067C36  15B6: 7504             jne 0x15bc
  067C38  15B8: 8346fc02         add word ptr [bp - 4], 2
  067C3C  15BC: 268a4701         mov al, byte ptr es:[bx + 1]
  067C40  15C0: 2246fe           and al, byte ptr [bp - 2]
  067C43  15C3: 2ae4             sub ah, ah
  067C45  15C5: 3b46fa           cmp ax, word ptr [bp - 6]
  067C48  15C8: 7503             jne 0x15cd
  067C4A  15CA: ff46fc           inc word ptr [bp - 4]
  067C4D  15CD: 8b46fc           mov ax, word ptr [bp - 4]
  067C50  15D0: 5e               pop si
  067C51  15D1: c9               leave 
  067C52  15D2: c3               ret 

; ---- func_067C54  size=57  insns=21  prologue=ENTER 0x0004,0  terminal=RET ----
  067C54  15D4: c8040000         enter 4, 0
  067C58  15D8: 56               push si
  067C59  15D9: c746fc0000       mov word ptr [bp - 4], 0
  067C5E  15DE: c41e98a5         les bx, ptr [0xa598]
  067C62  15E2: 8b7606           mov si, word ptr [bp + 6]
  067C65  15E5: 268a00           mov al, byte ptr es:[bx + si]
  067C68  15E8: 251f00           and ax, 0x1f
  067C6B  15EB: 8946fe           mov word ptr [bp - 2], ax
  067C6E  15EE: 3d1800           cmp ax, 0x18
  067C71  15F1: 7d14             jge 0x1607
  067C73  15F3: 8a46fe           mov al, byte ptr [bp - 2]
  067C76  15F6: 2407             and al, 7
  067C78  15F8: 3c01             cmp al, 1
  067C7A  15FA: 740b             je 0x1607
  067C7C  15FC: 837efe07         cmp word ptr [bp - 2], 7
  067C80  1600: 7e05             jle 0x1607
  067C82  1602: c746fc0100       mov word ptr [bp - 4], 1
  067C87  1607: 8b46fc           mov ax, word ptr [bp - 4]
  067C8A  160A: 5e               pop si
  067C8B  160B: c9               leave 
  067C8C  160C: c3               ret 

; ---- func_067C8E  size=102  insns=38  prologue=ENTER 0x0002,0  terminal=RET ----
  067C8E  160E: c8020000         enter 2, 0
  067C92  1612: 50               push ax
  067C93  1613: c746fe0000       mov word ptr [bp - 2], 0
  067C98  1618: 39168401         cmp word ptr [0x184], dx
  067C9C  161C: 7f51             jg 0x166f
  067C9E  161E: a14885           mov ax, word ptr [0x8548]
  067CA1  1621: f7d8             neg ax
  067CA3  1623: 50               push ax
  067CA4  1624: ff76fc           push word ptr [bp - 4]
  067CA7  1627: e8aaff           call 0x15d4
  067CAA  162A: 83c404           add sp, 4
  067CAD  162D: 0bc0             or ax, ax
  067CAF  162F: 7404             je 0x1635
  067CB1  1631: 8346fe08         add word ptr [bp - 2], 8
  067CB5  1635: ff364885         push word ptr [0x8548]
  067CB9  1639: ff76fc           push word ptr [bp - 4]
  067CBC  163C: e895ff           call 0x15d4
  067CBF  163F: 83c404           add sp, 4
  067CC2  1642: 0bc0             or ax, ax
  067CC4  1644: 7404             je 0x164a
  067CC6  1646: 8346fe04         add word ptr [bp - 2], 4
  067CCA  164A: 6aff             push -1
  067CCC  164C: ff76fc           push word ptr [bp - 4]
  067CCF  164F: e882ff           call 0x15d4
  067CD2  1652: 83c404           add sp, 4
  067CD5  1655: 0bc0             or ax, ax
  067CD7  1657: 7404             je 0x165d
  067CD9  1659: 8346fe02         add word ptr [bp - 2], 2
  067CDD  165D: 6a01             push 1
  067CDF  165F: ff76fc           push word ptr [bp - 4]
  067CE2  1662: e86fff           call 0x15d4
  067CE5  1665: 83c404           add sp, 4
  067CE8  1668: 0bc0             or ax, ax
  067CEA  166A: 7403             je 0x166f
  067CEC  166C: ff46fe           inc word ptr [bp - 2]
  067CEF  166F: 8b46fe           mov ax, word ptr [bp - 2]
  067CF2  1672: c9               leave 
  067CF3  1673: c3               ret 

; ---- func_067CF4  size=96  insns=34  prologue=ENTER 0x0002,0  terminal=RET ----
  067CF4  1674: c8020000         enter 2, 0
  067CF8  1678: 50               push ax
  067CF9  1679: 56               push si
  067CFA  167A: c746fe0000       mov word ptr [bp - 2], 0
  067CFF  167F: 39168401         cmp word ptr [0x184], dx
  067D03  1683: 7f49             jg 0x16ce
  067D05  1685: c41e94a5         les bx, ptr [0xa594]
  067D09  1689: 2b1e4885         sub bx, word ptr [0x8548]
  067D0D  168D: 268a07           mov al, byte ptr es:[bx]
  067D10  1690: 2ae4             sub ah, ah
  067D12  1692: 8546fc           test word ptr [bp - 4], ax
  067D15  1695: 7404             je 0x169b
  067D17  1697: 8346fe08         add word ptr [bp - 2], 8
  067D1B  169B: 8b1e94a5         mov bx, word ptr [0xa594]
  067D1F  169F: 8b364885         mov si, word ptr [0x8548]
  067D23  16A3: 268a00           mov al, byte ptr es:[bx + si]
  067D26  16A6: 2ae4             sub ah, ah
  067D28  16A8: 8546fc           test word ptr [bp - 4], ax
  067D2B  16AB: 7404             je 0x16b1
  067D2D  16AD: 8346fe04         add word ptr [bp - 2], 4
  067D31  16B1: 268a47ff         mov al, byte ptr es:[bx - 1]
  067D35  16B5: 2ae4             sub ah, ah
  067D37  16B7: 8546fc           test word ptr [bp - 4], ax
  067D3A  16BA: 7404             je 0x16c0
  067D3C  16BC: 8346fe02         add word ptr [bp - 2], 2
  067D40  16C0: 268a4701         mov al, byte ptr es:[bx + 1]
  067D44  16C4: 2ae4             sub ah, ah
  067D46  16C6: 8546fc           test word ptr [bp - 4], ax
  067D49  16C9: 7403             je 0x16ce
  067D4B  16CB: ff46fe           inc word ptr [bp - 2]
  067D4E  16CE: 8b46fe           mov ax, word ptr [bp - 2]
  067D51  16D1: 5e               pop si
  067D52  16D2: c9               leave 
  067D53  16D3: c3               ret 

; ---- func_067D54  size=116  insns=45  prologue=ENTER 0x000A,0  terminal=RET ----
  067D54  16D4: c80a0000         enter 0xa, 0
  067D58  16D8: 50               push ax
  067D59  16D9: 56               push si
  067D5A  16DA: c746fc0000       mov word ptr [bp - 4], 0
  067D5F  16DF: 3b168401         cmp dx, word ptr [0x184]
  067D63  16E3: 7c5d             jl 0x1742
  067D65  16E5: c746fa0100       mov word ptr [bp - 6], 1
  067D6A  16EA: c746fe0000       mov word ptr [bp - 2], 0
  067D6F  16EF: eb36             jmp 0x1727
  067D71  16F1: 90               nop 
  067D72  16F2: a14885           mov ax, word ptr [0x8548]
  067D75  16F5: f7d0             not ax
  067D77  16F7: 40               inc ax
  067D78  16F8: eb02             jmp 0x16fc
  067D7A  16FA: 2bc0             sub ax, ax
  067D7C  16FC: 8946f8           mov word ptr [bp - 8], ax
  067D7F  16FF: 8a87b400         mov al, byte ptr [bx + 0xb4]
  067D83  1703: 98               cwde 
  067D84  1704: 8bd8             mov bx, ax
  067D86  1706: 031e94a5         add bx, word ptr [0xa594]
  067D8A  170A: 8e0696a5         mov es, word ptr [0xa596]
  067D8E  170E: 8b76f8           mov si, word ptr [bp - 8]
  067D91  1711: 268a00           mov al, byte ptr es:[bx + si]
  067D94  1714: 2ae4             sub ah, ah
  067D96  1716: 8546f4           test word ptr [bp - 0xc], ax
  067D99  1719: 7406             je 0x1721
  067D9B  171B: 8b46fa           mov ax, word ptr [bp - 6]
  067D9E  171E: 0946fc           or word ptr [bp - 4], ax
  067DA1  1721: d166fa           shl word ptr [bp - 6], 1
  067DA4  1724: ff46fe           inc word ptr [bp - 2]
  067DA7  1727: 837efe08         cmp word ptr [bp - 2], 8
  067DAB  172B: 7d15             jge 0x1742
  067DAD  172D: 8b5efe           mov bx, word ptr [bp - 2]
  067DB0  1730: 8a87be00         mov al, byte ptr [bx + 0xbe]
  067DB4  1734: 0ac0             or al, al
  067DB6  1736: 74c2             je 0x16fa
  067DB8  1738: 0ac0             or al, al
  067DBA  173A: 7cb6             jl 0x16f2
  067DBC  173C: a14885           mov ax, word ptr [0x8548]
  067DBF  173F: ebbb             jmp 0x16fc
  067DC1  1741: 90               nop 
  067DC2  1742: 8b46fc           mov ax, word ptr [bp - 4]
  067DC5  1745: 5e               pop si
  067DC6  1746: c9               leave 
  067DC7  1747: c3               ret 

; ---- func_067DC8  size=95  insns=32  prologue=ENTER 0x0004,0  terminal=RET ----
  067DC8  1748: c8040000         enter 4, 0
  067DCC  174C: 8b0e7401         mov cx, word ptr [0x174]
  067DD0  1750: 8b167601         mov dx, word ptr [0x176]
  067DD4  1754: 894efc           mov word ptr [bp - 4], cx
  067DD7  1757: 8956fe           mov word ptr [bp - 2], dx
  067DDA  175A: 833e860164       cmp word ptr [0x186], 0x64
  067DDF  175F: 7c29             jl 0x178a
  067DE1  1761: 52               push dx
  067DE2  1762: 51               push cx
  067DE3  1763: 8a0ea51e         mov cl, byte ptr [0x1ea5]
  067DE7  1767: 2aed             sub ch, ch
  067DE9  1769: 030ea6a5         add cx, word ptr [0xa5a6]
  067DED  176D: 83e90f           sub cx, 0xf
  067DF0  1770: 51               push cx
  067DF1  1771: 8a16a41e         mov dl, byte ptr [0x1ea4]
  067DF5  1775: 2af6             sub dh, dh
  067DF7  1777: 0316a4a5         add dx, word ptr [0xa5a4]
  067DFB  177B: 83ea08           sub dx, 8
  067DFE  177E: 8d1e9e83         lea bx, [0x839e]
  067E02  1782: 9a54021f18       lcall 0x181f, 0x254
  067E07  1787: c9               leave 
  067E08  1788: c3               ret 
  067E09  1789: 90               nop 
  067E0A  178A: ff76fe           push word ptr [bp - 2]
  067E0D  178D: ff76fc           push word ptr [bp - 4]
  067E10  1790: ff36a6a5         push word ptr [0xa5a6]
  067E14  1794: ff368601         push word ptr [0x186]
  067E18  1798: 8d1e9e83         lea bx, [0x839e]
  067E1C  179C: 8b16a4a5         mov dx, word ptr [0xa5a4]
  067E20  17A0: 9af8021f18       lcall 0x181f, 0x2f8
  067E25  17A5: c9               leave 
  067E26  17A6: c3               ret 

; ---- func_067E28  size=99  insns=36  prologue=ENTER 0x0004,0  terminal=RET ----
  067E28  17A8: c8040000         enter 4, 0
  067E2C  17AC: 8b0e6c01         mov cx, word ptr [0x16c]
  067E30  17B0: 8b166e01         mov dx, word ptr [0x16e]
  067E34  17B4: 894efc           mov word ptr [bp - 4], cx
  067E37  17B7: 8956fe           mov word ptr [bp - 2], dx
  067E3A  17BA: 833e840100       cmp word ptr [0x184], 0
  067E3F  17BF: 752d             jne 0x17ee
  067E41  17C1: 8a1ea51e         mov bl, byte ptr [0x1ea5]
  067E45  17C5: 2aff             sub bh, bh
  067E47  17C7: 031ea6a5         add bx, word ptr [0xa5a6]
  067E4B  17CB: 83eb0f           sub bx, 0xf
  067E4E  17CE: 53               push bx
  067E4F  17CF: 8a1ea41e         mov bl, byte ptr [0x1ea4]
  067E53  17D3: 2aff             sub bh, bh
  067E55  17D5: 031ea4a5         add bx, word ptr [0xa5a4]
  067E59  17D9: 83eb08           sub bx, 8
  067E5C  17DC: 53               push bx
  067E5D  17DD: 689e83           push 0x839e
  067E60  17E0: 50               push ax
  067E61  17E1: 52               push dx
  067E62  17E2: 51               push cx
  067E63  17E3: 9a5e021f18       lcall 0x181f, 0x25e
  067E68  17E8: 83c40c           add sp, 0xc
  067E6B  17EB: c9               leave 
  067E6C  17EC: c3               ret 
  067E6D  17ED: 90               nop 
  067E6E  17EE: ff368401         push word ptr [0x184]
  067E72  17F2: ff36a6a5         push word ptr [0xa5a6]
  067E76  17F6: ff36a4a5         push word ptr [0xa5a4]
  067E7A  17FA: 689e83           push 0x839e
  067E7D  17FD: 50               push ax
  067E7E  17FE: ff76fe           push word ptr [bp - 2]
  067E81  1801: ff76fc           push word ptr [bp - 4]
  067E84  1804: 9a72021f18       lcall 0x181f, 0x272
  067E89  1809: c9               leave 
  067E8A  180A: c3               ret 

; ---- func_067E8C  size=95  insns=32  prologue=ENTER 0x0004,0  terminal=RET ----
  067E8C  180C: c8040000         enter 4, 0
  067E90  1810: 8b0e7401         mov cx, word ptr [0x174]
  067E94  1814: 8b167601         mov dx, word ptr [0x176]
  067E98  1818: 894efc           mov word ptr [bp - 4], cx
  067E9B  181B: 8956fe           mov word ptr [bp - 2], dx
  067E9E  181E: 833e860164       cmp word ptr [0x186], 0x64
  067EA3  1823: 7c29             jl 0x184e
  067EA5  1825: 52               push dx
  067EA6  1826: 51               push cx
  067EA7  1827: 8a0ea51e         mov cl, byte ptr [0x1ea5]
  067EAB  182B: 2aed             sub ch, ch
  067EAD  182D: 030ea6a5         add cx, word ptr [0xa5a6]
  067EB1  1831: 83e90f           sub cx, 0xf
  067EB4  1834: 51               push cx
  067EB5  1835: 8a16a41e         mov dl, byte ptr [0x1ea4]
  067EB9  1839: 2af6             sub dh, dh
  067EBB  183B: 0316a4a5         add dx, word ptr [0xa5a4]
  067EBF  183F: 83ea08           sub dx, 8
  067EC2  1842: 8d1e9e83         lea bx, [0x839e]
  067EC6  1846: 9a8e091f1a       lcall 0x1a1f, 0x98e
  067ECB  184B: c9               leave 
  067ECC  184C: c3               ret 
  067ECD  184D: 90               nop 
  067ECE  184E: ff76fe           push word ptr [bp - 2]
  067ED1  1851: ff76fc           push word ptr [bp - 4]
  067ED4  1854: ff36a6a5         push word ptr [0xa5a6]
  067ED8  1858: ff368601         push word ptr [0x186]
  067EDC  185C: 8d1e9e83         lea bx, [0x839e]
  067EE0  1860: 8b16a4a5         mov dx, word ptr [0xa5a4]
  067EE4  1864: 9a84091f1a       lcall 0x1a1f, 0x984
  067EE9  1869: c9               leave 
  067EEA  186A: c3               ret 

; ---- func_067EEC  size=99  insns=36  prologue=ENTER 0x0004,0  terminal=RET ----
  067EEC  186C: c8040000         enter 4, 0
  067EF0  1870: 8b0e6c01         mov cx, word ptr [0x16c]
  067EF4  1874: 8b166e01         mov dx, word ptr [0x16e]
  067EF8  1878: 894efc           mov word ptr [bp - 4], cx
  067EFB  187B: 8956fe           mov word ptr [bp - 2], dx
  067EFE  187E: 833e840100       cmp word ptr [0x184], 0
  067F03  1883: 752d             jne 0x18b2
  067F05  1885: 8a1ea51e         mov bl, byte ptr [0x1ea5]
  067F09  1889: 2aff             sub bh, bh
  067F0B  188B: 031ea6a5         add bx, word ptr [0xa5a6]
  067F0F  188F: 83eb0f           sub bx, 0xf
  067F12  1892: 53               push bx
  067F13  1893: 8a1ea41e         mov bl, byte ptr [0x1ea4]
  067F17  1897: 2aff             sub bh, bh
  067F19  1899: 031ea4a5         add bx, word ptr [0xa5a4]
  067F1D  189D: 83eb08           sub bx, 8
  067F20  18A0: 53               push bx
  067F21  18A1: 689e83           push 0x839e
  067F24  18A4: 50               push ax
  067F25  18A5: 52               push dx
  067F26  18A6: 51               push cx
  067F27  18A7: 9a68021f18       lcall 0x181f, 0x268
  067F2C  18AC: 83c40c           add sp, 0xc
  067F2F  18AF: c9               leave 
  067F30  18B0: c3               ret 
  067F31  18B1: 90               nop 
  067F32  18B2: ff368401         push word ptr [0x184]
  067F36  18B6: ff36a6a5         push word ptr [0xa5a6]
  067F3A  18BA: ff36a4a5         push word ptr [0xa5a4]
  067F3E  18BE: 689e83           push 0x839e
  067F41  18C1: 50               push ax
  067F42  18C2: ff76fe           push word ptr [bp - 2]
  067F45  18C5: ff76fc           push word ptr [bp - 4]
  067F48  18C8: 9a86021f18       lcall 0x181f, 0x286
  067F4D  18CD: c9               leave 
  067F4E  18CE: c3               ret 

; ---- func_067F50  size=599  insns=210  prologue=ENTER 0x002C,0  terminal=RET ----
  067F50  18D0: c82c0000         enter 0x2c, 0
  067F54  18D4: 56               push si
  067F55  18D5: a1a8a5           mov ax, word ptr [0xa5a8]
  067F58  18D8: 8946da           mov word ptr [bp - 0x26], ax
  067F5B  18DB: 2bc0             sub ax, ax
  067F5D  18DD: a3a8a5           mov word ptr [0xa5a8], ax
  067F60  18E0: 8946fc           mov word ptr [bp - 4], ax
  067F63  18E3: e9c000           jmp 0x19a6
  067F66  18E6: 8b46ec           mov ax, word ptr [bp - 0x14]
  067F69  18E9: 2b067c01         sub ax, word ptr [0x17c]
  067F6D  18ED: f7d0             not ax
  067F6F  18EF: 40               inc ax
  067F70  18F0: 8946dc           mov word ptr [bp - 0x24], ax
  067F73  18F3: ff368a01         push word ptr [0x18a]
  067F77  18F7: 8b46e8           mov ax, word ptr [bp - 0x18]
  067F7A  18FA: 2b067e01         sub ax, word ptr [0x17e]
  067F7E  18FE: 0bc0             or ax, ax
  067F80  1900: 7f0a             jg 0x190c
  067F82  1902: 8b46e8           mov ax, word ptr [bp - 0x18]
  067F85  1905: 2b067e01         sub ax, word ptr [0x17e]
  067F89  1909: f7d0             not ax
  067F8B  190B: 40               inc ax
  067F8C  190C: 50               push ax
  067F8D  190D: ff76dc           push word ptr [bp - 0x24]
  067F90  1910: 9ac8061f18       lcall 0x181f, 0x6c8
  067F95  1915: 83c406           add sp, 6
  067F98  1918: 3d0100           cmp ax, 1
  067F9B  191B: 1bc0             sbb ax, ax
  067F9D  191D: f7d8             neg ax
  067F9F  191F: 0946f8           or word ptr [bp - 8], ax
  067FA2  1922: 8b46fe           mov ax, word ptr [bp - 2]
  067FA5  1925: 8946ee           mov word ptr [bp - 0x12], ax
  067FA8  1928: 837ef600         cmp word ptr [bp - 0xa], 0
  067FAC  192C: 7d07             jge 0x1935
  067FAE  192E: 2b064885         sub ax, word ptr [0x8548]
  067FB2  1932: 8946ee           mov word ptr [bp - 0x12], ax
  067FB5  1935: 837ef600         cmp word ptr [bp - 0xa], 0
  067FB9  1939: 7e06             jle 0x1941
  067FBB  193B: a14885           mov ax, word ptr [0x8548]
  067FBE  193E: 0146ee           add word ptr [bp - 0x12], ax
  067FC1  1941: c41e98a5         les bx, ptr [0xa598]
  067FC5  1945: 8b76ee           mov si, word ptr [bp - 0x12]
  067FC8  1948: 268a00           mov al, byte ptr es:[bx + si]
  067FCB  194B: 241f             and al, 0x1f
  067FCD  194D: 8846f4           mov byte ptr [bp - 0xc], al
  067FD0  1950: 3c18             cmp al, 0x18
  067FD2  1952: 7304             jae 0x1958
  067FD4  1954: 8066f407         and byte ptr [bp - 0xc], 7
  067FD8  1958: 8a46f4           mov al, byte ptr [bp - 0xc]
  067FDB  195B: 2ae4             sub ah, ah
  067FDD  195D: 50               push ax
  067FDE  195E: 9aaa061f18       lcall 0x181f, 0x6aa
  067FE3  1963: 83c402           add sp, 2
  067FE6  1966: 8846e4           mov byte ptr [bp - 0x1c], al
  067FE9  1969: c41e94a5         les bx, ptr [0xa594]
  067FED  196D: 8b76ee           mov si, word ptr [bp - 0x12]
  067FF0  1970: c41e9ca5         les bx, ptr [0xa59c]
  067FF4  1974: 268a00           mov al, byte ptr es:[bx + si]
  067FF7  1977: 803e9ea800       cmp byte ptr [0xa89e], 0
  067FFC  197C: 7406             je 0x1984
  067FFE  197E: 84069ea8         test byte ptr [0xa89e], al
  068002  1982: 7406             je 0x198a
  068004  1984: 837ef800         cmp word ptr [bp - 8], 0
  068008  1988: 7408             je 0x1992
  06800A  198A: c746f20100       mov word ptr [bp - 0xe], 1
  06800F  198F: eb06             jmp 0x1997
  068011  1991: 90               nop 
  068012  1992: c746f20000       mov word ptr [bp - 0xe], 0
  068017  1997: 837e0400         cmp word ptr [bp + 4], 0
  06801B  199B: 7465             je 0x1a02
  06801D  199D: 837ef200         cmp word ptr [bp - 0xe], 0
  068021  19A1: 745f             je 0x1a02
  068023  19A3: ff46fc           inc word ptr [bp - 4]
  068026  19A6: 837efc04         cmp word ptr [bp - 4], 4
  06802A  19AA: 7c03             jl 0x19af
  06802C  19AC: e96f01           jmp 0x1b1e
  06802F  19AF: 8b5efc           mov bx, word ptr [bp - 4]
  068032  19B2: 8a87ae00         mov al, byte ptr [bx + 0xae]
  068036  19B6: 98               cwde 
  068037  19B7: 8946f6           mov word ptr [bp - 0xa], ax
  06803A  19BA: 8bc8             mov cx, ax
  06803C  19BC: 8a87a800         mov al, byte ptr [bx + 0xa8]
  068040  19C0: 98               cwde 
  068041  19C1: 8946fe           mov word ptr [bp - 2], ax
  068044  19C4: 0306a0a5         add ax, word ptr [0xa5a0]
  068048  19C8: 8946ec           mov word ptr [bp - 0x14], ax
  06804B  19CB: 030ea2a5         add cx, word ptr [0xa5a2]
  06804F  19CF: 894ee8           mov word ptr [bp - 0x18], cx
  068052  19D2: 51               push cx
  068053  19D3: 50               push ax
  068054  19D4: 9a02031f18       lcall 0x181f, 0x302
  068059  19D9: 83c404           add sp, 4
  06805C  19DC: 3d0100           cmp ax, 1
  06805F  19DF: 1bc0             sbb ax, ax
  068061  19E1: f7d8             neg ax
  068063  19E3: 8946f8           mov word ptr [bp - 8], ax
  068066  19E6: 833e8a0100       cmp word ptr [0x18a], 0
  06806B  19EB: 7503             jne 0x19f0
  06806D  19ED: e932ff           jmp 0x1922
  068070  19F0: 8b46ec           mov ax, word ptr [bp - 0x14]
  068073  19F3: 2b067c01         sub ax, word ptr [0x17c]
  068077  19F7: 0bc0             or ax, ax
  068079  19F9: 7f03             jg 0x19fe
  06807B  19FB: e9e8fe           jmp 0x18e6
  06807E  19FE: e9effe           jmp 0x18f0
  068081  1A01: 90               nop 
  068082  1A02: 807ee419         cmp byte ptr [bp - 0x1c], 0x19
  068086  1A06: 7409             je 0x1a11
  068088  1A08: 807ee41a         cmp byte ptr [bp - 0x1c], 0x1a
  06808C  1A0C: 7403             je 0x1a11
  06808E  1A0E: e9a100           jmp 0x1ab2
  068091  1A11: 837e0600         cmp word ptr [bp + 6], 0
  068095  1A15: 7403             je 0x1a1a
  068097  1A17: e99800           jmp 0x1ab2
  06809A  1A1A: c746f00700       mov word ptr [bp - 0x10], 7
  06809F  1A1F: eb14             jmp 0x1a35
  0680A1  1A21: 90               nop 
  0680A2  1A22: a13a85           mov ax, word ptr [0x853a]
  0680A5  1A25: 3946ea           cmp word ptr [bp - 0x16], ax
  0680A8  1A28: 7d08             jge 0x1a32
  0680AA  1A2A: a13c85           mov ax, word ptr [0x853c]
  0680AD  1A2D: 3946e0           cmp word ptr [bp - 0x20], ax
  0680B0  1A30: 7c40             jl 0x1a72
  0680B2  1A32: ff4ef0           dec word ptr [bp - 0x10]
  0680B5  1A35: 807ee419         cmp byte ptr [bp - 0x1c], 0x19
  0680B9  1A39: 7406             je 0x1a41
  0680BB  1A3B: 807ee41a         cmp byte ptr [bp - 0x1c], 0x1a
  0680BF  1A3F: 755f             jne 0x1aa0
  0680C1  1A41: 837ef000         cmp word ptr [bp - 0x10], 0
  0680C5  1A45: 7c59             jl 0x1aa0
  0680C7  1A47: 8b5ef0           mov bx, word ptr [bp - 0x10]
  0680CA  1A4A: 8a87b400         mov al, byte ptr [bx + 0xb4]
  0680CE  1A4E: 98               cwde 
  0680CF  1A4F: 0346ec           add ax, word ptr [bp - 0x14]
  0680D2  1A52: 8946ea           mov word ptr [bp - 0x16], ax
  0680D5  1A55: 8a87be00         mov al, byte ptr [bx + 0xbe]
  0680D9  1A59: 98               cwde 
  0680DA  1A5A: 0346e8           add ax, word ptr [bp - 0x18]
  0680DD  1A5D: 8946e0           mov word ptr [bp - 0x20], ax
  0680E0  1A60: f6c301           test bl, 1
  0680E3  1A63: 75cd             jne 0x1a32
  0680E5  1A65: 837eea00         cmp word ptr [bp - 0x16], 0
  0680E9  1A69: 7cc7             jl 0x1a32
  0680EB  1A6B: 0bc0             or ax, ax
  0680ED  1A6D: 7db3             jge 0x1a22
  0680EF  1A6F: ebc1             jmp 0x1a32
  0680F1  1A71: 90               nop 
  0680F2  1A72: ff76e0           push word ptr [bp - 0x20]
  0680F5  1A75: ff76ea           push word ptr [bp - 0x16]
  0680F8  1A78: 9a2c071f18       lcall 0x181f, 0x72c
  0680FD  1A7D: 83c404           add sp, 4
  068100  1A80: 241f             and al, 0x1f
  068102  1A82: 2ae4             sub ah, ah
  068104  1A84: 8946de           mov word ptr [bp - 0x22], ax
  068107  1A87: 3d1800           cmp ax, 0x18
  06810A  1A8A: 7d04             jge 0x1a90
  06810C  1A8C: 8366de07         and word ptr [bp - 0x22], 7
  068110  1A90: ff76de           push word ptr [bp - 0x22]
  068113  1A93: 9aaa061f18       lcall 0x181f, 0x6aa
  068118  1A98: 83c402           add sp, 2
  06811B  1A9B: 8846e4           mov byte ptr [bp - 0x1c], al
  06811E  1A9E: eb92             jmp 0x1a32
  068120  1AA0: 807ee419         cmp byte ptr [bp - 0x1c], 0x19
  068124  1AA4: 7503             jne 0x1aa9
  068126  1AA6: e9fafe           jmp 0x19a3
  068129  1AA9: 807ee41a         cmp byte ptr [bp - 0x1c], 0x1a
  06812D  1AAD: 7503             jne 0x1ab2
  06812F  1AAF: e9f1fe           jmp 0x19a3
  068132  1AB2: 807ee419         cmp byte ptr [bp - 0x1c], 0x19
  068136  1AB6: 7406             je 0x1abe
  068138  1AB8: 807ee41a         cmp byte ptr [bp - 0x1c], 0x1a
  06813C  1ABC: 7515             jne 0x1ad3
  06813E  1ABE: 837e0800         cmp word ptr [bp + 8], 0
  068142  1AC2: 750f             jne 0x1ad3
  068144  1AC4: 837e0400         cmp word ptr [bp + 4], 0
  068148  1AC8: 7509             jne 0x1ad3
  06814A  1ACA: 837ef200         cmp word ptr [bp - 0xe], 0
  06814E  1ACE: 7503             jne 0x1ad3
  068150  1AD0: e9d0fe           jmp 0x19a3
  068153  1AD3: a0a2a8           mov al, byte ptr [0xa8a2]
  068156  1AD6: 251f00           and ax, 0x1f
  068159  1AD9: 8946e2           mov word ptr [bp - 0x1e], ax
  06815C  1ADC: 3d1800           cmp ax, 0x18
  06815F  1ADF: 7d04             jge 0x1ae5
  068161  1AE1: 8366e207         and word ptr [bp - 0x1e], 7
  068165  1AE5: ff76e2           push word ptr [bp - 0x1e]
  068168  1AE8: 9aaa061f18       lcall 0x181f, 0x6aa
  06816D  1AED: 83c402           add sp, 2
  068170  1AF0: 2ae4             sub ah, ah
  068172  1AF2: 8946e2           mov word ptr [bp - 0x1e], ax
  068175  1AF5: 3a46e4           cmp al, byte ptr [bp - 0x1c]
  068178  1AF8: 750f             jne 0x1b09
  06817A  1AFA: 837e0400         cmp word ptr [bp + 4], 0
  06817E  1AFE: 7509             jne 0x1b09
  068180  1B00: 837ef200         cmp word ptr [bp - 0xe], 0
  068184  1B04: 7503             jne 0x1b09
  068186  1B06: e99afe           jmp 0x19a3
  068189  1B09: 8b46fc           mov ax, word ptr [bp - 4]
  06818C  1B0C: 056900           add ax, 0x69
  06818F  1B0F: e836fc           call 0x1748
  068192  1B12: 8a46e4           mov al, byte ptr [bp - 0x1c]
  068195  1B15: 2ae4             sub ah, ah
  068197  1B17: e852fd           call 0x186c
  06819A  1B1A: e986fe           jmp 0x19a3
  06819D  1B1D: 90               nop 
  06819E  1B1E: 8b46da           mov ax, word ptr [bp - 0x26]
  0681A1  1B21: a3a8a5           mov word ptr [0xa5a8], ax
  0681A4  1B24: 5e               pop si
  0681A5  1B25: c9               leave 
  0681A6  1B26: c3               ret 

; ---- func_0681A8  size=1076  insns=363  prologue=ENTER 0x0024,0  terminal=RET ----
  0681A8  1B28: c8240000         enter 0x24, 0
  0681AC  1B2C: 50               push ax
  0681AD  1B2D: 56               push si
  0681AE  1B2E: c746e40000       mov word ptr [bp - 0x1c], 0
  0681B3  1B33: c41e94a5         les bx, ptr [0xa594]
  0681B7  1B37: 268a07           mov al, byte ptr es:[bx]
  0681BA  1B3A: a29fa8           mov byte ptr [0xa89f], al
  0681BD  1B3D: c41e98a5         les bx, ptr [0xa598]
  0681C1  1B41: 268a07           mov al, byte ptr es:[bx]
  0681C4  1B44: a2a1a8           mov byte ptr [0xa8a1], al
  0681C7  1B47: c41e9ca5         les bx, ptr [0xa59c]
  0681CB  1B4B: 268a0f           mov cl, byte ptr es:[bx]
  0681CE  1B4E: 880ea0a8         mov byte ptr [0xa8a0], cl
  0681D2  1B52: 2ae4             sub ah, ah
  0681D4  1B54: 50               push ax
  0681D5  1B55: 9aaa061f18       lcall 0x181f, 0x6aa
  0681DA  1B5A: 83c402           add sp, 2
  0681DD  1B5D: a2a2a8           mov byte ptr [0xa8a2], al
  0681E0  1B60: 803e9ea800       cmp byte ptr [0xa89e], 0
  0681E5  1B65: 7409             je 0x1b70
  0681E7  1B67: a09ea8           mov al, byte ptr [0xa89e]
  0681EA  1B6A: 8406a0a8         test byte ptr [0xa8a0], al
  0681EE  1B6E: 7406             je 0x1b76
  0681F0  1B70: 837eda00         cmp word ptr [bp - 0x26], 0
  0681F4  1B74: 7408             je 0x1b7e
  0681F6  1B76: c746f80100       mov word ptr [bp - 8], 1
  0681FB  1B7B: eb06             jmp 0x1b83
  0681FD  1B7D: 90               nop 
  0681FE  1B7E: c746f80000       mov word ptr [bp - 8], 0
  068203  1B83: a0a1a8           mov al, byte ptr [0xa8a1]
  068206  1B86: 25c000           and ax, 0xc0
  068209  1B89: 8946ee           mov word ptr [bp - 0x12], ax
  06820C  1B8C: 837ef800         cmp word ptr [bp - 8], 0
  068210  1B90: 743c             je 0x1bce
  068212  1B92: b89500           mov ax, 0x95
  068215  1B95: e8b0fb           call 0x1748
  068218  1B98: 833e840100       cmp word ptr [0x184], 0
  06821D  1B9D: 7403             je 0x1ba2
  06821F  1B9F: e9b703           jmp 0x1f59
  068222  1BA2: 803ea2a819       cmp byte ptr [0xa8a2], 0x19
  068227  1BA7: 7407             je 0x1bb0
  068229  1BA9: 803ea2a81a       cmp byte ptr [0xa8a2], 0x1a
  06822E  1BAE: 7508             jne 0x1bb8
  068230  1BB0: c746de0100       mov word ptr [bp - 0x22], 1
  068235  1BB5: eb06             jmp 0x1bbd
  068237  1BB7: 90               nop 
  068238  1BB8: c746de0000       mov word ptr [bp - 0x22], 0
  06823D  1BBD: 6a00             push 0
  06823F  1BBF: ff76de           push word ptr [bp - 0x22]
  068242  1BC2: 6a01             push 1
  068244  1BC4: e809fd           call 0x18d0
  068247  1BC7: 83c406           add sp, 6
  06824A  1BCA: 5e               pop si
  06824B  1BCB: c9               leave 
  06824C  1BCC: c3               ret 
  06824D  1BCD: 90               nop 
  06824E  1BCE: c646fc00         mov byte ptr [bp - 4], 0
  068252  1BD2: c646fe19         mov byte ptr [bp - 2], 0x19
  068256  1BD6: 803ea2a819       cmp byte ptr [0xa8a2], 0x19
  06825B  1BDB: 7407             je 0x1be4
  06825D  1BDD: 803ea2a81a       cmp byte ptr [0xa8a2], 0x1a
  068262  1BE2: 7510             jne 0x1bf4
  068264  1BE4: a0a2a8           mov al, byte ptr [0xa8a2]
  068267  1BE7: 8846fe           mov byte ptr [bp - 2], al
  06826A  1BEA: e8b7f7           call 0x13a4
  06826D  1BED: 8946e4           mov word ptr [bp - 0x1c], ax
  068270  1BF0: c646fc01         mov byte ptr [bp - 4], 1
  068274  1BF4: 807efc00         cmp byte ptr [bp - 4], 0
  068278  1BF8: 7446             je 0x1c40
  06827A  1BFA: 837ee400         cmp word ptr [bp - 0x1c], 0
  06827E  1BFE: 7540             jne 0x1c40
  068280  1C00: 8a46fe           mov al, byte ptr [bp - 2]
  068283  1C03: 2ae4             sub ah, ah
  068285  1C05: e8a0fb           call 0x17a8
  068288  1C08: 833e840100       cmp word ptr [0x184], 0
  06828D  1C0D: 7403             je 0x1c12
  06828F  1C0F: e94703           jmp 0x1f59
  068292  1C12: ff36a2a5         push word ptr [0xa5a2]
  068296  1C16: ff36a0a5         push word ptr [0xa5a0]
  06829A  1C1A: 9a18071f18       lcall 0x181f, 0x718
  06829F  1C1F: 83c404           add sp, 4
  0682A2  1C22: 8946e2           mov word ptr [bp - 0x1e], ax
  0682A5  1C25: 40               inc ax
  0682A6  1C26: 7410             je 0x1c38
  0682A8  1C28: 833e8a0100       cmp word ptr [0x18a], 0
  0682AD  1C2D: 7509             jne 0x1c38
  0682AF  1C2F: 8b46e2           mov ax, word ptr [bp - 0x1e]
  0682B2  1C32: 055a00           add ax, 0x5a
  0682B5  1C35: e810fb           call 0x1748
  0682B8  1C38: 6a01             push 1
  0682BA  1C3A: 6a01             push 1
  0682BC  1C3C: 6a00             push 0
  0682BE  1C3E: eb84             jmp 0x1bc4
  0682C0  1C40: 803ea2a818       cmp byte ptr [0xa8a2], 0x18
  0682C5  1C45: 7309             jae 0x1c50
  0682C7  1C47: a0a2a8           mov al, byte ptr [0xa8a2]
  0682CA  1C4A: 250700           and ax, 7
  0682CD  1C4D: eb06             jmp 0x1c55
  0682CF  1C4F: 90               nop 
  0682D0  1C50: a0a2a8           mov al, byte ptr [0xa8a2]
  0682D3  1C53: 2ae4             sub ah, ah
  0682D5  1C55: 8946e0           mov word ptr [bp - 0x20], ax
  0682D8  1C58: 3d0100           cmp ax, 1
  0682DB  1C5B: 751c             jne 0x1c79
  0682DD  1C5D: 803ea2a808       cmp byte ptr [0xa8a2], 8
  0682E2  1C62: 7207             jb 0x1c6b
  0682E4  1C64: 803ea2a810       cmp byte ptr [0xa8a2], 0x10
  0682E9  1C69: 7213             jb 0x1c7e
  0682EB  1C6B: 803ea2a810       cmp byte ptr [0xa8a2], 0x10
  0682F0  1C70: 7207             jb 0x1c79
  0682F2  1C72: 803ea2a818       cmp byte ptr [0xa8a2], 0x18
  0682F7  1C77: 7205             jb 0x1c7e
  0682F9  1C79: 8b46e0           mov ax, word ptr [bp - 0x20]
  0682FC  1C7C: eb03             jmp 0x1c81
  0682FE  1C7E: b81100           mov ax, 0x11
  068301  1C81: e824fb           call 0x17a8
  068304  1C84: 833e840100       cmp word ptr [0x184], 0
  068309  1C89: 7510             jne 0x1c9b
  06830B  1C8B: 6a00             push 0
  06830D  1C8D: 8a46fc           mov al, byte ptr [bp - 4]
  068310  1C90: 2ae4             sub ah, ah
  068312  1C92: 50               push ax
  068313  1C93: 6a00             push 0
  068315  1C95: e838fc           call 0x18d0
  068318  1C98: 83c406           add sp, 6
  06831B  1C9B: 837ee001         cmp word ptr [bp - 0x20], 1
  06831F  1C9F: 742e             je 0x1ccf
  068321  1CA1: 803ea2a808       cmp byte ptr [0xa8a2], 8
  068326  1CA6: 7207             jb 0x1caf
  068328  1CA8: 803ea2a810       cmp byte ptr [0xa8a2], 0x10
  06832D  1CAD: 720e             jb 0x1cbd
  06832F  1CAF: 803ea2a810       cmp byte ptr [0xa8a2], 0x10
  068334  1CB4: 7219             jb 0x1ccf
  068336  1CB6: 803ea2a818       cmp byte ptr [0xa8a2], 0x18
  06833B  1CBB: 7312             jae 0x1ccf
  06833D  1CBD: 8b46e0           mov ax, word ptr [bp - 0x20]
  068340  1CC0: ba0300           mov dx, 3
  068343  1CC3: e848f9           call 0x160e
  068346  1CC6: 8946ec           mov word ptr [bp - 0x14], ax
  068349  1CC9: 054100           add ax, 0x41
  06834C  1CCC: e879fa           call 0x1748
  06834F  1CCF: f6069fa840       test byte ptr [0xa89f], 0x40
  068354  1CD4: 7406             je 0x1cdc
  068356  1CD6: b89600           mov ax, 0x96
  068359  1CD9: e86cfa           call 0x1748
  06835C  1CDC: f606a1a820       test byte ptr [0xa8a1], 0x20
  068361  1CE1: 7427             je 0x1d0a
  068363  1CE3: 807efc00         cmp byte ptr [bp - 4], 0
  068367  1CE7: 7521             jne 0x1d0a
  068369  1CE9: a0a1a8           mov al, byte ptr [0xa8a1]
  06836C  1CEC: 25a000           and ax, 0xa0
  06836F  1CEF: ba0200           mov dx, 2
  068372  1CF2: e86ff8           call 0x1564
  068375  1CF5: 8946ec           mov word ptr [bp - 0x14], ax
  068378  1CF8: f606a1a880       test byte ptr [0xa8a1], 0x80
  06837D  1CFD: 7405             je 0x1d04
  06837F  1CFF: 052100           add ax, 0x21
  068382  1D02: eb03             jmp 0x1d07
  068384  1D04: 053100           add ax, 0x31
  068387  1D07: e83efa           call 0x1748
  06838A  1D0A: f606a1a840       test byte ptr [0xa8a1], 0x40
  06838F  1D0F: 7438             je 0x1d49
  068391  1D11: 807efc00         cmp byte ptr [bp - 4], 0
  068395  1D15: 7532             jne 0x1d49
  068397  1D17: f606a1a880       test byte ptr [0xa8a1], 0x80
  06839C  1D1C: 7408             je 0x1d26
  06839E  1D1E: c746e80100       mov word ptr [bp - 0x18], 1
  0683A3  1D23: eb06             jmp 0x1d2b
  0683A5  1D25: 90               nop 
  0683A6  1D26: c746e81100       mov word ptr [bp - 0x18], 0x11
  0683AB  1D2B: b84000           mov ax, 0x40
  0683AE  1D2E: ba0300           mov dx, 3
  0683B1  1D31: e8d0f7           call 0x1504
  0683B4  1D34: 8946ec           mov word ptr [bp - 0x14], ax
  0683B7  1D37: 0bc0             or ax, ax
  0683B9  1D39: 7505             jne 0x1d40
  0683BB  1D3B: c746ec0f00       mov word ptr [bp - 0x14], 0xf
  0683C0  1D40: 8b46e8           mov ax, word ptr [bp - 0x18]
  0683C3  1D43: 0346ec           add ax, word ptr [bp - 0x14]
  0683C6  1D46: e8fff9           call 0x1748
  0683C9  1D49: 833e840100       cmp word ptr [0x184], 0
  0683CE  1D4E: 7547             jne 0x1d97
  0683D0  1D50: 833e8e0100       cmp word ptr [0x18e], 0
  0683D5  1D55: 7540             jne 0x1d97
  0683D7  1D57: ff36a2a5         push word ptr [0xa5a2]
  0683DB  1D5B: ff36a0a5         push word ptr [0xa5a0]
  0683DF  1D5F: 9a18071f18       lcall 0x181f, 0x718
  0683E4  1D64: 83c404           add sp, 4
  0683E7  1D67: 8946e2           mov word ptr [bp - 0x1e], ax
  0683EA  1D6A: 40               inc ax
  0683EB  1D6B: 7410             je 0x1d7d
  0683ED  1D6D: 833e8a0100       cmp word ptr [0x18a], 0
  0683F2  1D72: 7509             jne 0x1d7d
  0683F4  1D74: 8b46e2           mov ax, word ptr [bp - 0x1e]
  0683F7  1D77: 055a00           add ax, 0x5a
  0683FA  1D7A: e8cbf9           call 0x1748
  0683FD  1D7D: ff36a2a5         push word ptr [0xa5a2]
  068401  1D81: ff36a0a5         push word ptr [0xa5a0]
  068405  1D85: 9a5e071f18       lcall 0x181f, 0x75e
  06840A  1D8A: 83c404           add sp, 4
  06840D  1D8D: 0bc0             or ax, ax
  06840F  1D8F: 7406             je 0x1d97
  068411  1D91: b86800           mov ax, 0x68
  068414  1D94: e8b1f9           call 0x1748
  068417  1D97: f6069fa80a       test byte ptr [0xa89f], 0xa
  06841C  1D9C: 744d             je 0x1deb
  06841E  1D9E: 807efc00         cmp byte ptr [bp - 4], 0
  068422  1DA2: 7547             jne 0x1deb
  068424  1DA4: 833e8e0100       cmp word ptr [0x18e], 0
  068429  1DA9: 7540             jne 0x1deb
  06842B  1DAB: b80a00           mov ax, 0xa
  06842E  1DAE: ba0100           mov dx, 1
  068431  1DB1: e820f9           call 0x16d4
  068434  1DB4: 8946ec           mov word ptr [bp - 0x14], ax
  068437  1DB7: 0bc0             or ax, ax
  068439  1DB9: 7509             jne 0x1dc4
  06843B  1DBB: b85100           mov ax, 0x51
  06843E  1DBE: e887f9           call 0x1748
  068441  1DC1: eb28             jmp 0x1deb
  068443  1DC3: 90               nop 
  068444  1DC4: c746e60100       mov word ptr [bp - 0x1a], 1
  068449  1DC9: c746ea0000       mov word ptr [bp - 0x16], 0
  06844E  1DCE: 8b46ec           mov ax, word ptr [bp - 0x14]
  068451  1DD1: 8546e6           test word ptr [bp - 0x1a], ax
  068454  1DD4: 7409             je 0x1ddf
  068456  1DD6: 8b46ea           mov ax, word ptr [bp - 0x16]
  068459  1DD9: 055200           add ax, 0x52
  06845C  1DDC: e869f9           call 0x1748
  06845F  1DDF: d166e6           shl word ptr [bp - 0x1a], 1
  068462  1DE2: ff46ea           inc word ptr [bp - 0x16]
  068465  1DE5: 837eea08         cmp word ptr [bp - 0x16], 8
  068469  1DE9: 7ce3             jl 0x1dce
  06846B  1DEB: 807efc00         cmp byte ptr [bp - 4], 0
  06846F  1DEF: 7503             jne 0x1df4
  068471  1DF1: e96501           jmp 0x1f59
  068474  1DF4: c746faffff       mov word ptr [bp - 6], 0xffff
  068479  1DF9: a0a6a8           mov al, byte ptr [0xa8a6]
  06847C  1DFC: 24dd             and al, 0xdd
  06847E  1DFE: 3cc1             cmp al, 0xc1
  068480  1E00: 7505             jne 0x1e07
  068482  1E02: c746fa0000       mov word ptr [bp - 6], 0
  068487  1E07: a0a6a8           mov al, byte ptr [0xa8a6]
  06848A  1E0A: 2477             and al, 0x77
  06848C  1E0C: 3c07             cmp al, 7
  06848E  1E0E: 7505             jne 0x1e15
  068490  1E10: c746fa0100       mov word ptr [bp - 6], 1
  068495  1E15: a0a6a8           mov al, byte ptr [0xa8a6]
  068498  1E18: 2477             and al, 0x77
  06849A  1E1A: 3c70             cmp al, 0x70
  06849C  1E1C: 7505             jne 0x1e23
  06849E  1E1E: c746fa0200       mov word ptr [bp - 6], 2
  0684A3  1E23: a0a6a8           mov al, byte ptr [0xa8a6]
  0684A6  1E26: 24dd             and al, 0xdd
  0684A8  1E28: 3c1c             cmp al, 0x1c
  0684AA  1E2A: 7505             jne 0x1e31
  0684AC  1E2C: c746fa0300       mov word ptr [bp - 6], 3
  0684B1  1E31: 837efa00         cmp word ptr [bp - 6], 0
  0684B5  1E35: 7d4b             jge 0x1e82
  0684B7  1E37: c746f40000       mov word ptr [bp - 0xc], 0
  0684BC  1E3C: 8a46f4           mov al, byte ptr [bp - 0xc]
  0684BF  1E3F: fec0             inc al
  0684C1  1E41: 250300           and ax, 3
  0684C4  1E44: 8946f0           mov word ptr [bp - 0x10], ax
  0684C7  1E47: 243e             and al, 0x3e
  0684C9  1E49: c0e002           shl al, 2
  0684CC  1E4C: a2a41e           mov byte ptr [0x1ea4], al
  0684CF  1E4F: 8a46f4           mov al, byte ptr [bp - 0xc]
  0684D2  1E52: 24fe             and al, 0xfe
  0684D4  1E54: c0e002           shl al, 2
  0684D7  1E57: a2a51e           mov byte ptr [0x1ea5], al
  0684DA  1E5A: 8b5ef4           mov bx, word ptr [bp - 0xc]
  0684DD  1E5D: 8a87242d         mov al, byte ptr [bx + 0x2d24]
  0684E1  1E61: 2ae4             sub ah, ah
  0684E3  1E63: c1e002           shl ax, 2
  0684E6  1E66: 03c3             add ax, bx
  0684E8  1E68: 056d00           add ax, 0x6d
  0684EB  1E6B: e8daf8           call 0x1748
  0684EE  1E6E: ff46f4           inc word ptr [bp - 0xc]
  0684F1  1E71: 837ef404         cmp word ptr [bp - 0xc], 4
  0684F5  1E75: 7cc5             jl 0x1e3c
  0684F7  1E77: 2ac0             sub al, al
  0684F9  1E79: a2a51e           mov byte ptr [0x1ea5], al
  0684FC  1E7C: a2a41e           mov byte ptr [0x1ea4], al
  0684FF  1E7F: eb12             jmp 0x1e93
  068501  1E81: 90               nop 
  068502  1E82: 2ac0             sub al, al
  068504  1E84: a2a51e           mov byte ptr [0x1ea5], al
  068507  1E87: a2a41e           mov byte ptr [0x1ea4], al
  06850A  1E8A: 8b46fa           mov ax, word ptr [bp - 6]
  06850D  1E8D: 059700           add ax, 0x97
  068510  1E90: e8b5f8           call 0x1748
  068513  1E93: 8a46fe           mov al, byte ptr [bp - 2]
  068516  1E96: 2ae4             sub ah, ah
  068518  1E98: e8d1f9           call 0x186c
  06851B  1E9B: 837eee00         cmp word ptr [bp - 0x12], 0
  06851F  1E9F: 7503             jne 0x1ea4
  068521  1EA1: e98800           jmp 0x1f2c
  068524  1EA4: 8a46ee           mov al, byte ptr [bp - 0x12]
  068527  1EA7: 258000           and ax, 0x80
  06852A  1EAA: 3d0100           cmp ax, 1
  06852D  1EAD: 1bc0             sbb ax, ax
  06852F  1EAF: 250400           and ax, 4
  068532  1EB2: 058d00           add ax, 0x8d
  068535  1EB5: 8946f0           mov word ptr [bp - 0x10], ax
  068538  1EB8: c746f40000       mov word ptr [bp - 0xc], 0
  06853D  1EBD: eb59             jmp 0x1f18
  06853F  1EBF: 90               nop 
  068540  1EC0: a14885           mov ax, word ptr [0x8548]
  068543  1EC3: f7d8             neg ax
  068545  1EC5: 8946de           mov word ptr [bp - 0x22], ax
  068548  1EC8: 80bfae0000       cmp byte ptr [bx + 0xae], 0
  06854D  1ECD: 7e05             jle 0x1ed4
  06854F  1ECF: a14885           mov ax, word ptr [0x8548]
  068552  1ED2: eb02             jmp 0x1ed6
  068554  1ED4: 2bc0             sub ax, ax
  068556  1ED6: 8946dc           mov word ptr [bp - 0x24], ax
  068559  1ED9: 8a87a800         mov al, byte ptr [bx + 0xa8]
  06855D  1EDD: 98               cwde 
  06855E  1EDE: 8bd8             mov bx, ax
  068560  1EE0: 031e98a5         add bx, word ptr [0xa598]
  068564  1EE4: 8e069aa5         mov es, word ptr [0xa59a]
  068568  1EE8: 035ede           add bx, word ptr [bp - 0x22]
  06856B  1EEB: 8b76dc           mov si, word ptr [bp - 0x24]
  06856E  1EEE: 268a00           mov al, byte ptr es:[bx + si]
  068571  1EF1: 2ae4             sub ah, ah
  068573  1EF3: a840             test al, 0x40
  068575  1EF5: 741e             je 0x1f15
  068577  1EF7: 50               push ax
  068578  1EF8: 9aaa061f18       lcall 0x181f, 0x6aa
  06857D  1EFD: 83c402           add sp, 2
  068580  1F00: 2ae4             sub ah, ah
  068582  1F02: 3d1900           cmp ax, 0x19
  068585  1F05: 740e             je 0x1f15
  068587  1F07: 3d1a00           cmp ax, 0x1a
  06858A  1F0A: 7409             je 0x1f15
  06858C  1F0C: 8b46f0           mov ax, word ptr [bp - 0x10]
  06858F  1F0F: 0346f4           add ax, word ptr [bp - 0xc]
  068592  1F12: e833f8           call 0x1748
  068595  1F15: ff46f4           inc word ptr [bp - 0xc]
  068598  1F18: 837ef404         cmp word ptr [bp - 0xc], 4
  06859C  1F1C: 7d0e             jge 0x1f2c
  06859E  1F1E: 8b5ef4           mov bx, word ptr [bp - 0xc]
  0685A1  1F21: 80bfae0000       cmp byte ptr [bx + 0xae], 0
  0685A6  1F26: 7c98             jl 0x1ec0
  0685A8  1F28: 2bc0             sub ax, ax
  0685AA  1F2A: eb99             jmp 0x1ec5
  0685AC  1F2C: 833e840100       cmp word ptr [0x184], 0
  0685B1  1F31: 7526             jne 0x1f59
  0685B3  1F33: 833e8a0100       cmp word ptr [0x18a], 0
  0685B8  1F38: 751f             jne 0x1f59
  0685BA  1F3A: ff36a2a5         push word ptr [0xa5a2]
  0685BE  1F3E: ff36a0a5         push word ptr [0xa5a0]
  0685C2  1F42: 9a18071f18       lcall 0x181f, 0x718
  0685C7  1F47: 83c404           add sp, 4
  0685CA  1F4A: 8946e2           mov word ptr [bp - 0x1e], ax
  0685CD  1F4D: 40               inc ax
  0685CE  1F4E: 7409             je 0x1f59
  0685D0  1F50: 8b46e2           mov ax, word ptr [bp - 0x1e]
  0685D3  1F53: 055a00           add ax, 0x5a
  0685D6  1F56: e8eff7           call 0x1748
  0685D9  1F59: 5e               pop si
  0685DA  1F5A: c9               leave 
  0685DB  1F5B: c3               ret 

; ---- func_0685DC  size=699  insns=241  prologue=ENTER 0x0028,0  terminal=RETF imm16 ----
  0685DC  1F5C: c8280000         enter 0x28, 0
  0685E0  1F60: 53               push bx
  0685E1  1F61: 52               push dx
  0685E2  1F62: 50               push ax
  0685E3  1F63: 56               push si
  0685E4  1F64: c746e20000       mov word ptr [bp - 0x1e], 0
  0685E9  1F69: 837e0600         cmp word ptr [bp + 6], 0
  0685ED  1F6D: 7c0f             jl 0x1f7e
  0685EF  1F6F: 8a4e06           mov cl, byte ptr [bp + 6]
  0685F2  1F72: 80c104           add cl, 4
  0685F5  1F75: b001             mov al, 1
  0685F7  1F77: d2e0             shl al, cl
  0685F9  1F79: a29ea8           mov byte ptr [0xa89e], al
  0685FC  1F7C: eb05             jmp 0x1f83
  0685FE  1F7E: c6069ea800       mov byte ptr [0xa89e], 0
  068603  1F83: 0e               push cs
  068604  1F84: e86303           call 0x22ea
  068607  1F87: 8b46d2           mov ax, word ptr [bp - 0x2e]
  06860A  1F8A: 39060488         cmp word ptr [0x8804], ax
  06860E  1F8E: 7d03             jge 0x1f93
  068610  1F90: e97f02           jmp 0x2212
  068613  1F93: 8b46d4           mov ax, word ptr [bp - 0x2c]
  068616  1F96: 39060688         cmp word ptr [0x8806], ax
  06861A  1F9A: 7d03             jge 0x1f9f
  06861C  1F9C: e97302           jmp 0x2212
  06861F  1F9F: 8b46d6           mov ax, word ptr [bp - 0x2a]
  068622  1FA2: 0346d2           add ax, word ptr [bp - 0x2e]
  068625  1FA5: 48               dec ax
  068626  1FA6: 8946e4           mov word ptr [bp - 0x1c], ax
  068629  1FA9: 8b4608           mov ax, word ptr [bp + 8]
  06862C  1FAC: 0346d4           add ax, word ptr [bp - 0x2c]
  06862F  1FAF: 48               dec ax
  068630  1FB0: 8946de           mov word ptr [bp - 0x22], ax
  068633  1FB3: 8b46e4           mov ax, word ptr [bp - 0x1c]
  068636  1FB6: 3b060488         cmp ax, word ptr [0x8804]
  06863A  1FBA: 7e03             jle 0x1fbf
  06863C  1FBC: a10488           mov ax, word ptr [0x8804]
  06863F  1FBF: 8946e4           mov word ptr [bp - 0x1c], ax
  068642  1FC2: 8b4ed2           mov cx, word ptr [bp - 0x2e]
  068645  1FC5: 3b0e2883         cmp cx, word ptr [0x8328]
  068649  1FC9: 7d04             jge 0x1fcf
  06864B  1FCB: 8b0e2883         mov cx, word ptr [0x8328]
  06864F  1FCF: 894ed2           mov word ptr [bp - 0x2e], cx
  068652  1FD2: a10688           mov ax, word ptr [0x8806]
  068655  1FD5: 3b46de           cmp ax, word ptr [bp - 0x22]
  068658  1FD8: 7e03             jle 0x1fdd
  06865A  1FDA: 8b46de           mov ax, word ptr [bp - 0x22]
  06865D  1FDD: 8946de           mov word ptr [bp - 0x22], ax
  068660  1FE0: 8b56d4           mov dx, word ptr [bp - 0x2c]
  068663  1FE3: 3b162e83         cmp dx, word ptr [0x832e]
  068667  1FE7: 7d04             jge 0x1fed
  068669  1FE9: 8b162e83         mov dx, word ptr [0x832e]
  06866D  1FED: 8956d4           mov word ptr [bp - 0x2c], dx
  068670  1FF0: 2bc2             sub ax, dx
  068672  1FF2: 40               inc ax
  068673  1FF3: 894608           mov word ptr [bp + 8], ax
  068676  1FF6: 2b0e2883         sub cx, word ptr [0x8328]
  06867A  1FFA: 894ee6           mov word ptr [bp - 0x1a], cx
  06867D  1FFD: 2b162e83         sub dx, word ptr [0x832e]
  068681  2001: 8956e0           mov word ptr [bp - 0x20], dx
  068684  2004: 833e5a0100       cmp word ptr [0x15a], 0
  068689  2009: 743d             je 0x2048
  06868B  200B: 8bc2             mov ax, dx
  06868D  200D: 40               inc ax
  06868E  200E: f72e4885         imul word ptr [0x8548]
  068692  2012: 03c8             add cx, ax
  068694  2014: 41               inc cx
  068695  2015: 8bc1             mov ax, cx
  068697  2017: 030e5c01         add cx, word ptr [0x15c]
  06869B  201B: 8b165e01         mov dx, word ptr [0x15e]
  06869F  201F: 894ef4           mov word ptr [bp - 0xc], cx
  0686A2  2022: 8956f6           mov word ptr [bp - 0xa], dx
  0686A5  2025: 8bc8             mov cx, ax
  0686A7  2027: 03066001         add ax, word ptr [0x160]
  0686AB  202B: 8b166201         mov dx, word ptr [0x162]
  0686AF  202F: 8946fa           mov word ptr [bp - 6], ax
  0686B2  2032: 8956fc           mov word ptr [bp - 4], dx
  0686B5  2035: 030e6801         add cx, word ptr [0x168]
  0686B9  2039: a16a01           mov ax, word ptr [0x16a]
  0686BC  203C: 894eda           mov word ptr [bp - 0x26], cx
  0686BF  203F: 8946dc           mov word ptr [bp - 0x24], ax
  0686C2  2042: a14885           mov ax, word ptr [0x8548]
  0686C5  2045: eb56             jmp 0x209d
  0686C7  2047: 90               nop 
  0686C8  2048: 8b46d4           mov ax, word ptr [bp - 0x2c]
  0686CB  204B: 3d0100           cmp ax, 1
  0686CE  204E: 7d03             jge 0x2053
  0686D0  2050: b80100           mov ax, 1
  0686D3  2053: 8946ec           mov word ptr [bp - 0x14], ax
  0686D6  2056: 50               push ax
  0686D7  2057: 8b4ed2           mov cx, word ptr [bp - 0x2e]
  0686DA  205A: 83f901           cmp cx, 1
  0686DD  205D: 7d03             jge 0x2062
  0686DF  205F: b90100           mov cx, 1
  0686E2  2062: 894eee           mov word ptr [bp - 0x12], cx
  0686E5  2065: 51               push cx
  0686E6  2066: 8bf0             mov si, ax
  0686E8  2068: 9a0e071f18       lcall 0x181f, 0x70e
  0686ED  206D: 83c404           add sp, 4
  0686F0  2070: 8946f4           mov word ptr [bp - 0xc], ax
  0686F3  2073: 8956f6           mov word ptr [bp - 0xa], dx
  0686F6  2076: 56               push si
  0686F7  2077: ff76ee           push word ptr [bp - 0x12]
  0686FA  207A: 9a40071f18       lcall 0x181f, 0x740
  0686FF  207F: 83c404           add sp, 4
  068702  2082: 8946fa           mov word ptr [bp - 6], ax
  068705  2085: 8956fc           mov word ptr [bp - 4], dx
  068708  2088: 56               push si
  068709  2089: ff76ee           push word ptr [bp - 0x12]
  06870C  208C: 9a36071f18       lcall 0x181f, 0x736
  068711  2091: 83c404           add sp, 4
  068714  2094: 8946da           mov word ptr [bp - 0x26], ax
  068717  2097: 8956dc           mov word ptr [bp - 0x24], dx
  06871A  209A: a13a85           mov ax, word ptr [0x853a]
  06871D  209D: 8946ea           mov word ptr [bp - 0x16], ax
  068720  20A0: a12c83           mov ax, word ptr [0x832c]
  068723  20A3: 0346e0           add ax, word ptr [bp - 0x20]
  068726  20A6: 40               inc ax
  068727  20A7: f72e2683         imul word ptr [0x8326]
  06872B  20AB: 48               dec ax
  06872C  20AC: a3a6a5           mov word ptr [0xa5a6], ax
  06872F  20AF: 8b46d4           mov ax, word ptr [bp - 0x2c]
  068732  20B2: 8946ec           mov word ptr [bp - 0x14], ax
  068735  20B5: e90601           jmp 0x21be
  068738  20B8: c746f00000       mov word ptr [bp - 0x10], 0
  06873D  20BD: 833e8a0100       cmp word ptr [0x18a], 0
  068742  20C2: 7415             je 0x20d9
  068744  20C4: 2b067e01         sub ax, word ptr [0x17e]
  068748  20C8: 0bc0             or ax, ax
  06874A  20CA: 7f0a             jg 0x20d6
  06874C  20CC: 8b46ec           mov ax, word ptr [bp - 0x14]
  06874F  20CF: 2b067e01         sub ax, word ptr [0x17e]
  068753  20D3: f7d0             not ax
  068755  20D5: 40               inc ax
  068756  20D6: 8946e2           mov word ptr [bp - 0x1e], ax
  068759  20D9: c706a8a50000     mov word ptr [0xa5a8], 0
  06875F  20DF: a12a83           mov ax, word ptr [0x832a]
  068762  20E2: 0346e6           add ax, word ptr [bp - 0x1a]
  068765  20E5: f72ed45a         imul word ptr [0x5ad4]
  068769  20E9: 8b0ed45a         mov cx, word ptr [0x5ad4]
  06876D  20ED: d1f9             sar cx, 1
  06876F  20EF: 03c8             add cx, ax
  068771  20F1: 890ea4a5         mov word ptr [0xa5a4], cx
  068775  20F5: 8b46d2           mov ax, word ptr [bp - 0x2e]
  068778  20F8: 8946ee           mov word ptr [bp - 0x12], ax
  06877B  20FB: eb7e             jmp 0x217b
  06877D  20FD: 90               nop 
  06877E  20FE: c746f80000       mov word ptr [bp - 8], 0
  068783  2103: 837ef800         cmp word ptr [bp - 8], 0
  068787  2107: 7406             je 0x210f
  068789  2109: 837ef000         cmp word ptr [bp - 0x10], 0
  06878D  210D: 7507             jne 0x2116
  06878F  210F: c746f20100       mov word ptr [bp - 0xe], 1
  068794  2114: eb05             jmp 0x211b
  068796  2116: c746f20000       mov word ptr [bp - 0xe], 0
  06879B  211B: 833e8a0100       cmp word ptr [0x18a], 0
  0687A0  2120: 742c             je 0x214e
  0687A2  2122: ff368a01         push word ptr [0x18a]
  0687A6  2126: ff76e2           push word ptr [bp - 0x1e]
  0687A9  2129: 2b067c01         sub ax, word ptr [0x17c]
  0687AD  212D: 0bc0             or ax, ax
  0687AF  212F: 7f0a             jg 0x213b
  0687B1  2131: 8b46ee           mov ax, word ptr [bp - 0x12]
  0687B4  2134: 2b067c01         sub ax, word ptr [0x17c]
  0687B8  2138: f7d0             not ax
  0687BA  213A: 40               inc ax
  0687BB  213B: 50               push ax
  0687BC  213C: 9ac8061f18       lcall 0x181f, 0x6c8
  0687C1  2141: 83c406           add sp, 6
  0687C4  2144: 3d0100           cmp ax, 1
  0687C7  2147: 1bc0             sbb ax, ax
  0687C9  2149: f7d8             neg ax
  0687CB  214B: 0946f2           or word ptr [bp - 0xe], ax
  0687CE  214E: 8b46f2           mov ax, word ptr [bp - 0xe]
  0687D1  2151: e8d4f9           call 0x1b28
  0687D4  2154: a1d45a           mov ax, word ptr [0x5ad4]
  0687D7  2157: 0106a4a5         add word ptr [0xa5a4], ax
  0687DB  215B: 837ef800         cmp word ptr [bp - 8], 0
  0687DF  215F: 7412             je 0x2173
  0687E1  2161: 837ef000         cmp word ptr [bp - 0x10], 0
  0687E5  2165: 740c             je 0x2173
  0687E7  2167: ff0698a5         inc word ptr [0xa598]
  0687EB  216B: ff0694a5         inc word ptr [0xa594]
  0687EF  216F: ff069ca5         inc word ptr [0xa59c]
  0687F3  2173: 8036a8a501       xor byte ptr [0xa5a8], 1
  0687F8  2178: ff46ee           inc word ptr [bp - 0x12]
  0687FB  217B: 8b46ee           mov ax, word ptr [bp - 0x12]
  0687FE  217E: 3946e4           cmp word ptr [bp - 0x1c], ax
  068801  2181: 7c1f             jl 0x21a2
  068803  2183: a3a0a5           mov word ptr [0xa5a0], ax
  068806  2186: 0bc0             or ax, ax
  068808  2188: 7f03             jg 0x218d
  06880A  218A: e971ff           jmp 0x20fe
  06880D  218D: 8b0e3a85         mov cx, word ptr [0x853a]
  068811  2191: 49               dec cx
  068812  2192: 3bc8             cmp cx, ax
  068814  2194: 7f03             jg 0x2199
  068816  2196: e965ff           jmp 0x20fe
  068819  2199: c746f80100       mov word ptr [bp - 8], 1
  06881E  219E: e962ff           jmp 0x2103
  068821  21A1: 90               nop 
  068822  21A2: a12683           mov ax, word ptr [0x8326]
  068825  21A5: 0106a6a5         add word ptr [0xa5a6], ax
  068829  21A9: 837ef000         cmp word ptr [bp - 0x10], 0
  06882D  21AD: 740c             je 0x21bb
  06882F  21AF: 8b46ea           mov ax, word ptr [bp - 0x16]
  068832  21B2: 0146f4           add word ptr [bp - 0xc], ax
  068835  21B5: 0146fa           add word ptr [bp - 6], ax
  068838  21B8: 0146da           add word ptr [bp - 0x26], ax
  06883B  21BB: ff46ec           inc word ptr [bp - 0x14]
  06883E  21BE: 8b46de           mov ax, word ptr [bp - 0x22]
  068841  21C1: 3946ec           cmp word ptr [bp - 0x14], ax
  068844  21C4: 7f4c             jg 0x2212
  068846  21C6: 8b46ec           mov ax, word ptr [bp - 0x14]
  068849  21C9: a3a2a5           mov word ptr [0xa5a2], ax
  06884C  21CC: 8b4ef4           mov cx, word ptr [bp - 0xc]
  06884F  21CF: 8b56f6           mov dx, word ptr [bp - 0xa]
  068852  21D2: 890e98a5         mov word ptr [0xa598], cx
  068856  21D6: 89169aa5         mov word ptr [0xa59a], dx
  06885A  21DA: 8b4efa           mov cx, word ptr [bp - 6]
  06885D  21DD: 8b56fc           mov dx, word ptr [bp - 4]
  068860  21E0: 890e94a5         mov word ptr [0xa594], cx
  068864  21E4: 891696a5         mov word ptr [0xa596], dx
  068868  21E8: 8b4eda           mov cx, word ptr [bp - 0x26]
  06886B  21EB: 8b56dc           mov dx, word ptr [bp - 0x24]
  06886E  21EE: 890e9ca5         mov word ptr [0xa59c], cx
  068872  21F2: 89169ea5         mov word ptr [0xa59e], dx
  068876  21F6: 0bc0             or ax, ax
  068878  21F8: 7f03             jg 0x21fd
  06887A  21FA: e9bbfe           jmp 0x20b8
  06887D  21FD: 8b0e3c85         mov cx, word ptr [0x853c]
  068881  2201: 49               dec cx
  068882  2202: 3bc8             cmp cx, ax
  068884  2204: 7f03             jg 0x2209
  068886  2206: e9affe           jmp 0x20b8
  068889  2209: c746f00100       mov word ptr [bp - 0x10], 1
  06888E  220E: e9acfe           jmp 0x20bd
  068891  2211: 90               nop 
  068892  2212: 5e               pop si
  068893  2213: c9               leave 
  068894  2214: ca0400           retf 4

; ---- func_068898  size=149  insns=50  prologue=push bp;mov bp,sp  terminal=RETF ----
  068898  2218: 55               push bp
  068899  2219: 8bec             mov bp, sp
  06889B  221B: 50               push ax
  06889C  221C: 0e               push cs
  06889D  221D: e8ca00           call 0x22ea
  0688A0  2220: 833e2a8300       cmp word ptr [0x832a], 0
  0688A5  2225: 7507             jne 0x222e
  0688A7  2227: 833e2c8300       cmp word ptr [0x832c], 0
  0688AC  222C: 7457             je 0x2285
  0688AE  222E: 833e2c0800       cmp word ptr [0x82c], 0
  0688B3  2233: 7439             je 0x226e
  0688B5  2235: 6af8             push -8
  0688B7  2237: 6a00             push 0
  0688B9  2239: ff369e83         push word ptr [0x839e]
  0688BD  223D: ff36a083         push word ptr [0x83a0]
  0688C1  2241: 6a00             push 0
  0688C3  2243: 6a00             push 0
  0688C5  2245: 8b1e2c08         mov bx, word ptr [0x82c]
  0688C9  2249: ff7706           push word ptr [bx + 6]
  0688CC  224C: ff7704           push word ptr [bx + 4]
  0688CF  224F: ff7702           push word ptr [bx + 2]
  0688D2  2252: ff37             push word ptr [bx]
  0688D4  2254: ff36a483         push word ptr [0x83a4]
  0688D8  2258: ff36a283         push word ptr [0x83a2]
  0688DC  225C: ff36a083         push word ptr [0x83a0]
  0688E0  2260: ff369e83         push word ptr [0x839e]
  0688E4  2264: 9ac4001f18       lcall 0x181f, 0xc4
  0688E9  2269: 83c41c           add sp, 0x1c
  0688EC  226C: eb17             jmp 0x2285
  0688EE  226E: ff36a483         push word ptr [0x83a4]
  0688F2  2272: ff36a283         push word ptr [0x83a2]
  0688F6  2276: ff36a083         push word ptr [0x83a0]
  0688FA  227A: ff369e83         push word ptr [0x839e]
  0688FE  227E: 2ac0             sub al, al
  068900  2280: 9a84041f18       lcall 0x181f, 0x484
  068905  2285: ff364685         push word ptr [0x8546]
  068909  2289: ff76fe           push word ptr [bp - 2]
  06890C  228C: a12883           mov ax, word ptr [0x8328]
  06890F  228F: 8b162e83         mov dx, word ptr [0x832e]
  068913  2293: 8b1e4485         mov bx, word ptr [0x8544]
  068917  2297: 0e               push cs
  068918  2298: e85900           call 0x22f4
  06891B  229B: c9               leave 
  06891C  229C: cb               retf 
  06891D  229D: 90               nop 
  06891E  229E: 89168a01         mov word ptr [0x18a], dx
  068922  22A2: 0e               push cs
  068923  22A3: e84900           call 0x22ef
  068926  22A6: c7068a010000     mov word ptr [0x18a], 0
  06892C  22AC: cb               retf 

; ---- func_06892E  size=75  insns=25  prologue=ENTER 0x0008,0  terminal=page-end ----
  06892E  22AE: c8080000         enter 8, 0
  068932  22B2: c746fc0000       mov word ptr [bp - 4], 0
  068937  22B7: eb20             jmp 0x22d9
  068939  22B9: 90               nop 
  06893A  22BA: ff46fe           inc word ptr [bp - 2]
  06893D  22BD: 8b46fe           mov ax, word ptr [bp - 2]
  068940  22C0: 39063a85         cmp word ptr [0x853a], ax
  068944  22C4: 7e10             jle 0x22d6
  068946  22C6: 6aff             push -1
  068948  22C8: ff76fc           push word ptr [bp - 4]
  06894B  22CB: 50               push ax
  06894C  22CC: 9a04071f18       lcall 0x181f, 0x704
  068951  22D1: 83c406           add sp, 6
  068954  22D4: ebe4             jmp 0x22ba
  068956  22D6: ff46fc           inc word ptr [bp - 4]
  068959  22D9: a13c85           mov ax, word ptr [0x853c]
  06895C  22DC: 3946fc           cmp word ptr [bp - 4], ax
  06895F  22DF: 7d07             jge 0x22e8
  068961  22E1: c746fe0000       mov word ptr [bp - 2], 0
  068966  22E6: ebd5             jmp 0x22bd
  068968  22E8: c9               leave 
  068969  22E9: cb               retf 
  06896A  22EA: ea8e011f19       ljmp 0x191f:0x18e
  06896F  22EF: eaa4021f19       ljmp 0x191f:0x2a4
  068974  22F4: ea68091f1a       ljmp 0x1a1f:0x968
