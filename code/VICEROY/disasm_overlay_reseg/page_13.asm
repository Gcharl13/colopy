; ============================================================
; VICEROY.EXE overlay page 0x13 (record 18) -- RE-SEGMENTED
; file_offset (disk image) = 0x061CA0
; code_offset (first insn) = 0x061E10
; code_end (next reloc hdr)= 0x0633E0  [resident size 349 para -> nominal_end 0x063270; on-disk code spills past it]
; reloc_count = 79  flags = 0x0000
; display IP base = page-image-relative (IP = file - 0x061CA0)
; functions in page = 7
; ============================================================

; ---- func_061E10  size=133  insns=50  prologue=ENTER 0x0006,0  terminal=RET imm16 ----
  061E10  0170: c8060000         enter 6, 0
  061E14  0174: 53               push bx
  061E15  0175: 52               push dx
  061E16  0176: 50               push ax
  061E17  0177: c746fa0000       mov word ptr [bp - 6], 0
  061E1C  017C: 8946fe           mov word ptr [bp - 2], ax
  061E1F  017F: eb56             jmp 0x1d7
  061E21  0181: 90               nop 
  061E22  0182: ff46fc           inc word ptr [bp - 4]
  061E25  0185: 837efa00         cmp word ptr [bp - 6], 0
  061E29  0189: 7549             jne 0x1d4
  061E2B  018B: 8b46f6           mov ax, word ptr [bp - 0xa]
  061E2E  018E: 40               inc ax
  061E2F  018F: 3b46fc           cmp ax, word ptr [bp - 4]
  061E32  0192: 7c40             jl 0x1d4
  061E34  0194: ff76fc           push word ptr [bp - 4]
  061E37  0197: ff76fe           push word ptr [bp - 2]
  061E3A  019A: 9a68071f18       lcall 0x181f, 0x768
  061E3F  019F: 83c404           add sp, 4
  061E42  01A2: 3b4604           cmp ax, word ptr [bp + 4]
  061E45  01A5: 75db             jne 0x182
  061E47  01A7: 0bc0             or ax, ax
  061E49  01A9: 7412             je 0x1bd
  061E4B  01AB: ff76fc           push word ptr [bp - 4]
  061E4E  01AE: ff76fe           push word ptr [bp - 2]
  061E51  01B1: 9ab4061f18       lcall 0x181f, 0x6b4
  061E56  01B6: 83c404           add sp, 4
  061E59  01B9: fec8             dec al
  061E5B  01BB: 75c5             jne 0x182
  061E5D  01BD: 8b46fe           mov ax, word ptr [bp - 2]
  061E60  01C0: 8b5ef8           mov bx, word ptr [bp - 8]
  061E63  01C3: 8907             mov word ptr [bx], ax
  061E65  01C5: 8b46fc           mov ax, word ptr [bp - 4]
  061E68  01C8: 8b5e06           mov bx, word ptr [bp + 6]
  061E6B  01CB: 8907             mov word ptr [bx], ax
  061E6D  01CD: c746fa0100       mov word ptr [bp - 6], 1
  061E72  01D2: ebae             jmp 0x182
  061E74  01D4: ff46fe           inc word ptr [bp - 2]
  061E77  01D7: 837efa00         cmp word ptr [bp - 6], 0
  061E7B  01DB: 7511             jne 0x1ee
  061E7D  01DD: 8b46f4           mov ax, word ptr [bp - 0xc]
  061E80  01E0: 40               inc ax
  061E81  01E1: 3b46fe           cmp ax, word ptr [bp - 2]
  061E84  01E4: 7c08             jl 0x1ee
  061E86  01E6: 8b46f6           mov ax, word ptr [bp - 0xa]
  061E89  01E9: 8946fc           mov word ptr [bp - 4], ax
  061E8C  01EC: eb97             jmp 0x185
  061E8E  01EE: 8b46fa           mov ax, word ptr [bp - 6]
  061E91  01F1: c9               leave 
  061E92  01F2: c20400           ret 4

; ---- func_061E96  size=107  insns=42  prologue=ENTER 0x0004,0  terminal=RETF ----
  061E96  01F6: c8040000         enter 4, 0
  061E9A  01FA: 52               push dx
  061E9B  01FB: 50               push ax
  061E9C  01FC: c746fc0800       mov word ptr [bp - 4], 8
  061EA1  0201: 0bc0             or ax, ax
  061EA3  0203: 7e05             jle 0x20a
  061EA5  0205: b80100           mov ax, 1
  061EA8  0208: eb0b             jmp 0x215
  061EAA  020A: 0bc0             or ax, ax
  061EAC  020C: 7c04             jl 0x212
  061EAE  020E: 2bc0             sub ax, ax
  061EB0  0210: eb03             jmp 0x215
  061EB2  0212: b8ffff           mov ax, 0xffff
  061EB5  0215: 8946f8           mov word ptr [bp - 8], ax
  061EB8  0218: 837efa00         cmp word ptr [bp - 6], 0
  061EBC  021C: 7e06             jle 0x224
  061EBE  021E: b80100           mov ax, 1
  061EC1  0221: eb0e             jmp 0x231
  061EC3  0223: 90               nop 
  061EC4  0224: 837efa00         cmp word ptr [bp - 6], 0
  061EC8  0228: 7c04             jl 0x22e
  061ECA  022A: 2bc0             sub ax, ax
  061ECC  022C: eb03             jmp 0x231
  061ECE  022E: b8ffff           mov ax, 0xffff
  061ED1  0231: 8946fa           mov word ptr [bp - 6], ax
  061ED4  0234: c746fe0000       mov word ptr [bp - 2], 0
  061ED9  0239: 8b5efe           mov bx, word ptr [bp - 2]
  061EDC  023C: 8a87b400         mov al, byte ptr [bx + 0xb4]
  061EE0  0240: 98               cwde 
  061EE1  0241: 3b46f8           cmp ax, word ptr [bp - 8]
  061EE4  0244: 750d             jne 0x253
  061EE6  0246: 8a87be00         mov al, byte ptr [bx + 0xbe]
  061EEA  024A: 98               cwde 
  061EEB  024B: 3b46fa           cmp ax, word ptr [bp - 6]
  061EEE  024E: 7503             jne 0x253
  061EF0  0250: 895efc           mov word ptr [bp - 4], bx
  061EF3  0253: ff46fe           inc word ptr [bp - 2]
  061EF6  0256: 837efe08         cmp word ptr [bp - 2], 8
  061EFA  025A: 7cdd             jl 0x239
  061EFC  025C: 8b46fc           mov ax, word ptr [bp - 4]
  061EFF  025F: c9               leave 
  061F00  0260: cb               retf 

; ---- func_061F02  size=2067  insns=698  prologue=ENTER 0x0084,0  terminal=RETF ----
  061F02  0262: c8840000         enter 0x84, 0
  061F06  0266: 53               push bx
  061F07  0267: 52               push dx
  061F08  0268: 50               push ax
  061F09  0269: 56               push si
  061F0A  026A: a1f21d           mov ax, word ptr [0x1df2]
  061F0D  026D: 8946dc           mov word ptr [bp - 0x24], ax
  061F10  0270: 0bc0             or ax, ax
  061F12  0272: 751b             jne 0x28f
  061F14  0274: f606940810       test byte ptr [0x894], 0x10
  061F19  0279: 7414             je 0x28f
  061F1B  027B: 3906a253         cmp word ptr [0x53a2], ax
  061F1F  027F: 7509             jne 0x28a
  061F21  0281: a19653           mov ax, word ptr [0x5396]
  061F24  0284: 3906d61d         cmp word ptr [0x1dd6], ax
  061F28  0288: 7505             jne 0x28f
  061F2A  028A: c746dc0100       mov word ptr [bp - 0x24], 1
  061F2F  028F: a14ea1           mov ax, word ptr [0xa14e]
  061F32  0292: 2d0800           sub ax, 8
  061F35  0295: 8946f8           mov word ptr [bp - 8], ax
  061F38  0298: a14ca1           mov ax, word ptr [0xa14c]
  061F3B  029B: 2d0800           sub ax, 8
  061F3E  029E: 8946f6           mov word ptr [bp - 0xa], ax
  061F41  02A1: 833ed21d0d       cmp word ptr [0x1dd2], 0xd
  061F46  02A6: 7c0e             jl 0x2b6
  061F48  02A8: 833ed21d12       cmp word ptr [0x1dd2], 0x12
  061F4D  02AD: 7f07             jg 0x2b6
  061F4F  02AF: c746e20100       mov word ptr [bp - 0x1e], 1
  061F54  02B4: eb05             jmp 0x2bb
  061F56  02B6: c746e20000       mov word ptr [bp - 0x1e], 0
  061F5B  02BB: 8b1ed21d         mov bx, word ptr [0x1dd2]
  061F5F  02BF: 8bc3             mov ax, bx
  061F61  02C1: d1e3             shl bx, 1
  061F63  02C3: 03d8             add bx, ax
  061F65  02C5: d1e3             shl bx, 1
  061F67  02C7: 03d8             add bx, ax
  061F69  02C9: d1e3             shl bx, 1
  061F6B  02CB: 80bf345203       cmp byte ptr [bx + 0x5234], 3
  061F70  02D0: 7706             ja 0x2d8
  061F72  02D2: b80100           mov ax, 1
  061F75  02D5: eb03             jmp 0x2da
  061F77  02D7: 90               nop 
  061F78  02D8: 2bc0             sub ax, ax
  061F7A  02DA: 8946f0           mov word ptr [bp - 0x10], ax
  061F7D  02DD: c70670a30000     mov word ptr [0xa370], 0
  061F83  02E3: a14ea1           mov ax, word ptr [0xa14e]
  061F86  02E6: 39061a2d         cmp word ptr [0x2d1a], ax
  061F8A  02EA: 7522             jne 0x30e
  061F8C  02EC: a14ca1           mov ax, word ptr [0xa14c]
  061F8F  02EF: 39061c2d         cmp word ptr [0x2d1c], ax
  061F93  02F3: 7519             jne 0x30e
  061F95  02F5: 8bb676ff         mov si, word ptr [bp - 0x8a]
  061F99  02F9: 2b76f8           sub si, word ptr [bp - 8]
  061F9C  02FC: c1e604           shl si, 4
  061F9F  02FF: 2b76f6           sub si, word ptr [bp - 0xa]
  061FA2  0302: 8bda             mov bx, dx
  061FA4  0304: 80b870a200       cmp byte ptr [bx + si - 0x5d90], 0
  061FA9  0309: 7403             je 0x30e
  061FAB  030B: e9ac00           jmp 0x3ba
  061FAE  030E: a14ea1           mov ax, word ptr [0xa14e]
  061FB1  0311: a31a2d           mov word ptr [0x2d1a], ax
  061FB4  0314: a14ca1           mov ax, word ptr [0xa14c]
  061FB7  0317: a31c2d           mov word ptr [0x2d1c], ax
  061FBA  031A: 680001           push 0x100
  061FBD  031D: 6a00             push 0
  061FBF  031F: 6870a2           push 0xa270
  061FC2  0322: 9aae0d1d0d       lcall 0xd1d, 0xdae
  061FC7  0327: 83c406           add sp, 6
  061FCA  032A: c706182d0000     mov word ptr [0x2d18], 0
  061FD0  0330: a04ea1           mov al, byte ptr [0xa14e]
  061FD3  0333: a272a3           mov byte ptr [0xa372], al
  061FD6  0336: a04ca1           mov al, byte ptr [0xa14c]
  061FD9  0339: a272a4           mov byte ptr [0xa472], al
  061FDC  033C: c706162d0100     mov word ptr [0x2d16], 1
  061FE2  0342: 8b364ea1         mov si, word ptr [0xa14e]
  061FE6  0346: 2b76f8           sub si, word ptr [bp - 8]
  061FE9  0349: c1e604           shl si, 4
  061FEC  034C: 2b76f6           sub si, word ptr [bp - 0xa]
  061FEF  034F: 8b1e4ca1         mov bx, word ptr [0xa14c]
  061FF3  0353: c68070a201       mov byte ptr [bx + si - 0x5d90], 1
  061FF8  0358: 8b867aff         mov ax, word ptr [bp - 0x86]
  061FFC  035C: a370a3           mov word ptr [0xa370], ax
  061FFF  035F: 8b1e182d         mov bx, word ptr [0x2d18]
  062003  0363: 8a8772a3         mov al, byte ptr [bx - 0x5c8e]
  062007  0367: 2ae4             sub ah, ah
  062009  0369: 8946e6           mov word ptr [bp - 0x1a], ax
  06200C  036C: 8a8772a4         mov al, byte ptr [bx - 0x5b8e]
  062010  0370: 8946e0           mov word ptr [bp - 0x20], ax
  062013  0373: ff06182d         inc word ptr [0x2d18]
  062017  0377: 8b76e6           mov si, word ptr [bp - 0x1a]
  06201A  037A: 2b76f8           sub si, word ptr [bp - 8]
  06201D  037D: c1e604           shl si, 4
  062020  0380: 2b76f6           sub si, word ptr [bp - 0xa]
  062023  0383: 8bd8             mov bx, ax
  062025  0385: 8a8070a2         mov al, byte ptr [bx + si - 0x5d90]
  062029  0389: 8946f4           mov word ptr [bp - 0xc], ax
  06202C  038C: 3b0670a3         cmp ax, word ptr [0xa370]
  062030  0390: 7f1a             jg 0x3ac
  062032  0392: 8b46e6           mov ax, word ptr [bp - 0x1a]
  062035  0395: 398676ff         cmp word ptr [bp - 0x8a], ax
  062039  0399: 7403             je 0x39e
  06203B  039B: e98600           jmp 0x424
  06203E  039E: 8bc3             mov ax, bx
  062040  03A0: 398678ff         cmp word ptr [bp - 0x88], ax
  062044  03A4: 757e             jne 0x424
  062046  03A6: 8b46f4           mov ax, word ptr [bp - 0xc]
  062049  03A9: a370a3           mov word ptr [0xa370], ax
  06204C  03AC: a1182d           mov ax, word ptr [0x2d18]
  06204F  03AF: 3906162d         cmp word ptr [0x2d16], ax
  062053  03B3: 7405             je 0x3ba
  062055  03B5: 3de100           cmp ax, 0xe1
  062058  03B8: 7ca5             jl 0x35f
  06205A  03BA: c746eaffff       mov word ptr [bp - 0x16], 0xffff
  06205F  03BF: a170a3           mov ax, word ptr [0xa370]
  062062  03C2: 39867aff         cmp word ptr [bp - 0x86], ax
  062066  03C6: 7f03             jg 0x3cb
  062068  03C8: e96b05           jmp 0x936
  06206B  03CB: b86300           mov ax, 0x63
  06206E  03CE: 8946d2           mov word ptr [bp - 0x2e], ax
  062071  03D1: 8946f4           mov word ptr [bp - 0xc], ax
  062074  03D4: ffb678ff         push word ptr [bp - 0x88]
  062078  03D8: ffb676ff         push word ptr [bp - 0x8a]
  06207C  03DC: 9a54071f18       lcall 0x181f, 0x754
  062081  03E1: 83c404           add sp, 4
  062084  03E4: 250a00           and ax, 0xa
  062087  03E7: 8946ec           mov word ptr [bp - 0x14], ax
  06208A  03EA: ffb678ff         push word ptr [bp - 0x88]
  06208E  03EE: ffb676ff         push word ptr [bp - 0x8a]
  062092  03F2: 9a2c071f18       lcall 0x181f, 0x72c
  062097  03F7: 83c404           add sp, 4
  06209A  03FA: 254000           and ax, 0x40
  06209D  03FD: 8946e8           mov word ptr [bp - 0x18], ax
  0620A0  0400: 8bb676ff         mov si, word ptr [bp - 0x8a]
  0620A4  0404: 2b76f8           sub si, word ptr [bp - 8]
  0620A7  0407: c1e604           shl si, 4
  0620AA  040A: 2b76f6           sub si, word ptr [bp - 0xa]
  0620AD  040D: 8b9e78ff         mov bx, word ptr [bp - 0x88]
  0620B1  0411: 8a8070a2         mov al, byte ptr [bx + si - 0x5d90]
  0620B5  0415: 2ae4             sub ah, ah
  0620B7  0417: 8946fe           mov word ptr [bp - 2], ax
  0620BA  041A: c746f20000       mov word ptr [bp - 0xe], 0
  0620BF  041F: e9b202           jmp 0x6d4
  0620C2  0422: 90               nop 
  0620C3  0423: 90               nop 
  0620C4  0424: 53               push bx
  0620C5  0425: ff76e6           push word ptr [bp - 0x1a]
  0620C8  0428: 9a54071f18       lcall 0x181f, 0x754
  0620CD  042D: 83c404           add sp, 4
  0620D0  0430: 250a00           and ax, 0xa
  0620D3  0433: 8946ec           mov word ptr [bp - 0x14], ax
  0620D6  0436: ff76e0           push word ptr [bp - 0x20]
  0620D9  0439: ff76e6           push word ptr [bp - 0x1a]
  0620DC  043C: 9a2c071f18       lcall 0x181f, 0x72c
  0620E1  0441: 83c404           add sp, 4
  0620E4  0444: 254000           and ax, 0x40
  0620E7  0447: 8946e8           mov word ptr [bp - 0x18], ax
  0620EA  044A: c746f20000       mov word ptr [bp - 0xe], 0
  0620EF  044F: eb13             jmp 0x464
  0620F1  0451: 90               nop 
  0620F2  0452: 8b46fc           mov ax, word ptr [bp - 4]
  0620F5  0455: 2b064ea1         sub ax, word ptr [0xa14e]
  0620F9  0459: f7d0             not ax
  0620FB  045B: 40               inc ax
  0620FC  045C: 3d0800           cmp ax, 8
  0620FF  045F: 7c33             jl 0x494
  062101  0461: ff46f2           inc word ptr [bp - 0xe]
  062104  0464: 837ef208         cmp word ptr [bp - 0xe], 8
  062108  0468: 7c03             jl 0x46d
  06210A  046A: e93fff           jmp 0x3ac
  06210D  046D: 8b5ef2           mov bx, word ptr [bp - 0xe]
  062110  0470: 8a87be00         mov al, byte ptr [bx + 0xbe]
  062114  0474: 98               cwde 
  062115  0475: 0346e0           add ax, word ptr [bp - 0x20]
  062118  0478: 8946fa           mov word ptr [bp - 6], ax
  06211B  047B: 8a87b400         mov al, byte ptr [bx + 0xb4]
  06211F  047F: 98               cwde 
  062120  0480: 0346e6           add ax, word ptr [bp - 0x1a]
  062123  0483: 8946fc           mov word ptr [bp - 4], ax
  062126  0486: 2b064ea1         sub ax, word ptr [0xa14e]
  06212A  048A: 8946cc           mov word ptr [bp - 0x34], ax
  06212D  048D: 0bc0             or ax, ax
  06212F  048F: 7ec1             jle 0x452
  062131  0491: ebc9             jmp 0x45c
  062133  0493: 90               nop 
  062134  0494: 8b46fa           mov ax, word ptr [bp - 6]
  062137  0497: 2b064ca1         sub ax, word ptr [0xa14c]
  06213B  049B: 8946ce           mov word ptr [bp - 0x32], ax
  06213E  049E: 0bc0             or ax, ax
  062140  04A0: 7f0a             jg 0x4ac
  062142  04A2: 8b46fa           mov ax, word ptr [bp - 6]
  062145  04A5: 2b064ca1         sub ax, word ptr [0xa14c]
  062149  04A9: f7d0             not ax
  06214B  04AB: 40               inc ax
  06214C  04AC: 3d0800           cmp ax, 8
  06214F  04AF: 7db0             jge 0x461
  062151  04B1: ff76fa           push word ptr [bp - 6]
  062154  04B4: ff76fc           push word ptr [bp - 4]
  062157  04B7: 9a02031f18       lcall 0x181f, 0x302
  06215C  04BC: 83c404           add sp, 4
  06215F  04BF: 0bc0             or ax, ax
  062161  04C1: 749e             je 0x461
  062163  04C3: ff76fa           push word ptr [bp - 6]
  062166  04C6: ff76fc           push word ptr [bp - 4]
  062169  04C9: 9a8c071f18       lcall 0x181f, 0x78c
  06216E  04CE: 83c404           add sp, 4
  062171  04D1: 8946ee           mov word ptr [bp - 0x12], ax
  062174  04D4: 3d1900           cmp ax, 0x19
  062177  04D7: 7405             je 0x4de
  062179  04D9: 3d1a00           cmp ax, 0x1a
  06217C  04DC: 7508             jne 0x4e6
  06217E  04DE: c746cc0100       mov word ptr [bp - 0x34], 1
  062183  04E3: eb06             jmp 0x4eb
  062185  04E5: 90               nop 
  062186  04E6: c746cc0000       mov word ptr [bp - 0x34], 0
  06218B  04EB: 8b46e2           mov ax, word ptr [bp - 0x1e]
  06218E  04EE: 3946cc           cmp word ptr [bp - 0x34], ax
  062191  04F1: 7516             jne 0x509
  062193  04F3: 0bc0             or ax, ax
  062195  04F5: 7451             je 0x548
  062197  04F7: ff76fa           push word ptr [bp - 6]
  06219A  04FA: ff76fc           push word ptr [bp - 4]
  06219D  04FD: 9ab4061f18       lcall 0x181f, 0x6b4
  0621A2  0502: 83c404           add sp, 4
  0621A5  0505: fec8             dec al
  0621A7  0507: 743f             je 0x548
  0621A9  0509: ff76fa           push word ptr [bp - 6]
  0621AC  050C: ff76fc           push word ptr [bp - 4]
  0621AF  050F: 9a96061f18       lcall 0x181f, 0x696
  0621B4  0514: 83c404           add sp, 4
  0621B7  0517: 0bc0             or ax, ax
  0621B9  0519: 7d03             jge 0x51e
  0621BB  051B: e943ff           jmp 0x461
  0621BE  051E: 8b46fc           mov ax, word ptr [bp - 4]
  0621C1  0521: 398676ff         cmp word ptr [bp - 0x8a], ax
  0621C5  0525: 7509             jne 0x530
  0621C7  0527: 8b46fa           mov ax, word ptr [bp - 6]
  0621CA  052A: 398678ff         cmp word ptr [bp - 0x88], ax
  0621CE  052E: 7418             je 0x548
  0621D0  0530: 8b46fc           mov ax, word ptr [bp - 4]
  0621D3  0533: 39061a2d         cmp word ptr [0x2d1a], ax
  0621D7  0537: 7403             je 0x53c
  0621D9  0539: e925ff           jmp 0x461
  0621DC  053C: 8b46fa           mov ax, word ptr [bp - 6]
  0621DF  053F: 39061c2d         cmp word ptr [0x2d1c], ax
  0621E3  0543: 7403             je 0x548
  0621E5  0545: e919ff           jmp 0x461
  0621E8  0548: 833ed21d13       cmp word ptr [0x1dd2], 0x13
  0621ED  054D: 7c15             jl 0x564
  0621EF  054F: ff76fa           push word ptr [bp - 6]
  0621F2  0552: ff76fc           push word ptr [bp - 4]
  0621F5  0555: 9a5e071f18       lcall 0x181f, 0x75e
  0621FA  055A: 83c404           add sp, 4
  0621FD  055D: 0bc0             or ax, ax
  0621FF  055F: 7403             je 0x564
  062201  0561: e9fdfe           jmp 0x461
  062204  0564: 8b46f4           mov ax, word ptr [bp - 0xc]
  062207  0567: 8946d8           mov word ptr [bp - 0x28], ax
  06220A  056A: 833ed61d00       cmp word ptr [0x1dd6], 0
  06220F  056F: 7c51             jl 0x5c2
  062211  0571: ff76fa           push word ptr [bp - 6]
  062214  0574: ff76fc           push word ptr [bp - 4]
  062217  0577: 9ad2061f18       lcall 0x181f, 0x6d2
  06221C  057C: 83c404           add sp, 4
  06221F  057F: 8946d6           mov word ptr [bp - 0x2a], ax
  062222  0582: 0bc0             or ax, ax
  062224  0584: 7c09             jl 0x58f
  062226  0586: 3b06d61d         cmp ax, word ptr [0x1dd6]
  06222A  058A: 7403             je 0x58f
  06222C  058C: e9d2fe           jmp 0x461
  06222F  058F: ff36d61d         push word ptr [0x1dd6]
  062233  0593: ff76fa           push word ptr [bp - 6]
  062236  0596: ff76fc           push word ptr [bp - 4]
  062239  0599: 9ae6061f18       lcall 0x181f, 0x6e6
  06223E  059E: 83c406           add sp, 6
  062241  05A1: 0bc0             or ax, ax
  062243  05A3: 7c1d             jl 0x5c2
  062245  05A5: 833ed61d04       cmp word ptr [0x1dd6], 4
  06224A  05AA: 7c03             jl 0x5af
  06224C  05AC: e9b2fe           jmp 0x461
  06224F  05AF: 6b1ed61d34       imul bx, word ptr [0x1dd6], 0x34
  062254  05B4: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  062259  05B9: 7403             je 0x5be
  06225B  05BB: e9a3fe           jmp 0x461
  06225E  05BE: 8346d808         add word ptr [bp - 0x28], 8
  062262  05C2: 833ed61d00       cmp word ptr [0x1dd6], 0
  062267  05C7: 7c38             jl 0x601
  062269  05C9: 8b46d6           mov ax, word ptr [bp - 0x2a]
  06226C  05CC: 3906d61d         cmp word ptr [0x1dd6], ax
  062270  05D0: 752f             jne 0x601
  062272  05D2: 3d0400           cmp ax, 4
  062275  05D5: 7d0a             jge 0x5e1
  062277  05D7: 6bd834           imul bx, ax, 0x34
  06227A  05DA: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  06227F  05DF: 7420             je 0x601
  062281  05E1: ff76fa           push word ptr [bp - 6]
  062284  05E4: ff76fc           push word ptr [bp - 4]
  062287  05E7: 9abe061f18       lcall 0x181f, 0x6be
  06228C  05EC: 83c404           add sp, 4
  06228F  05EF: 0bc0             or ax, ax
  062291  05F1: 7d0e             jge 0x601
  062293  05F3: 8b46fc           mov ax, word ptr [bp - 4]
  062296  05F6: 8b56fa           mov dx, word ptr [bp - 6]
  062299  05F9: 9ae0071f18       lcall 0x181f, 0x7e0
  06229E  05FE: 8946da           mov word ptr [bp - 0x26], ax
  0622A1  0601: 837eec00         cmp word ptr [bp - 0x14], 0
  0622A5  0605: 7412             je 0x619
  0622A7  0607: ff76fa           push word ptr [bp - 6]
  0622AA  060A: ff76fc           push word ptr [bp - 4]
  0622AD  060D: 9a54071f18       lcall 0x181f, 0x754
  0622B2  0612: 83c404           add sp, 4
  0622B5  0615: a80a             test al, 0xa
  0622B7  0617: 7507             jne 0x620
  0622B9  0619: 833ed41d00       cmp word ptr [0x1dd4], 0
  0622BE  061E: 7406             je 0x626
  0622C0  0620: ff46d8           inc word ptr [bp - 0x28]
  0622C3  0623: eb4a             jmp 0x66f
  0622C5  0625: 90               nop 
  0622C6  0626: 837ee800         cmp word ptr [bp - 0x18], 0
  0622CA  062A: 7422             je 0x64e
  0622CC  062C: ff76fa           push word ptr [bp - 6]
  0622CF  062F: ff76fc           push word ptr [bp - 4]
  0622D2  0632: 9a2c071f18       lcall 0x181f, 0x72c
  0622D7  0637: 83c404           add sp, 4
  0622DA  063A: a840             test al, 0x40
  0622DC  063C: 7410             je 0x64e
  0622DE  063E: 8b46e6           mov ax, word ptr [bp - 0x1a]
  0622E1  0641: 3946fc           cmp word ptr [bp - 4], ax
  0622E4  0644: 74da             je 0x620
  0622E6  0646: 8b46e0           mov ax, word ptr [bp - 0x20]
  0622E9  0649: 3946fa           cmp word ptr [bp - 6], ax
  0622EC  064C: 74d2             je 0x620
  0622EE  064E: 837ef000         cmp word ptr [bp - 0x10], 0
  0622F2  0652: 7406             je 0x65a
  0622F4  0654: 8346d803         add word ptr [bp - 0x28], 3
  0622F8  0658: eb15             jmp 0x66f
  0622FA  065A: 8b5eee           mov bx, word ptr [bp - 0x12]
  0622FD  065D: c1e304           shl bx, 4
  062300  0660: 8a87762f         mov al, byte ptr [bx + 0x2f76]
  062304  0664: 2ae4             sub ah, ah
  062306  0666: 8bc8             mov cx, ax
  062308  0668: d1e0             shl ax, 1
  06230A  066A: 03c1             add ax, cx
  06230C  066C: 0146d8           add word ptr [bp - 0x28], ax
  06230F  066F: 8b76fc           mov si, word ptr [bp - 4]
  062312  0672: 2b76f8           sub si, word ptr [bp - 8]
  062315  0675: c1e604           shl si, 4
  062318  0678: 2b76f6           sub si, word ptr [bp - 0xa]
  06231B  067B: 8b5efa           mov bx, word ptr [bp - 6]
  06231E  067E: 8a8070a2         mov al, byte ptr [bx + si - 0x5d90]
  062322  0682: 2ae4             sub ah, ah
  062324  0684: 8946d4           mov word ptr [bp - 0x2c], ax
  062327  0687: 0bc0             or ax, ax
  062329  0689: 7408             je 0x693
  06232B  068B: 3b46d8           cmp ax, word ptr [bp - 0x28]
  06232E  068E: 7f03             jg 0x693
  062330  0690: e9cefd           jmp 0x461
  062333  0693: 8a46d8           mov al, byte ptr [bp - 0x28]
  062336  0696: 8b76fc           mov si, word ptr [bp - 4]
  062339  0699: 2b76f8           sub si, word ptr [bp - 8]
  06233C  069C: c1e604           shl si, 4
  06233F  069F: 2b76f6           sub si, word ptr [bp - 0xa]
  062342  06A2: 888070a2         mov byte ptr [bx + si - 0x5d90], al
  062346  06A6: 8a46fc           mov al, byte ptr [bp - 4]
  062349  06A9: 8b36162d         mov si, word ptr [0x2d16]
  06234D  06AD: 888472a3         mov byte ptr [si - 0x5c8e], al
  062351  06B1: 889c72a4         mov byte ptr [si - 0x5b8e], bl
  062355  06B5: 8bc6             mov ax, si
  062357  06B7: fec0             inc al
  062359  06B9: 2ae4             sub ah, ah
  06235B  06BB: a3162d           mov word ptr [0x2d16], ax
  06235E  06BE: e9a0fd           jmp 0x461
  062361  06C1: 90               nop 
  062362  06C2: 8b46fc           mov ax, word ptr [bp - 4]
  062365  06C5: 2b064ea1         sub ax, word ptr [0xa14e]
  062369  06C9: f7d0             not ax
  06236B  06CB: 40               inc ax
  06236C  06CC: 3d0800           cmp ax, 8
  06236F  06CF: 7c35             jl 0x706
  062371  06D1: ff46f2           inc word ptr [bp - 0xe]
  062374  06D4: 837ef208         cmp word ptr [bp - 0xe], 8
  062378  06D8: 7c03             jl 0x6dd
  06237A  06DA: e95902           jmp 0x936
  06237D  06DD: 8b5ef2           mov bx, word ptr [bp - 0xe]
  062380  06E0: 8a87be00         mov al, byte ptr [bx + 0xbe]
  062384  06E4: 98               cwde 
  062385  06E5: 038678ff         add ax, word ptr [bp - 0x88]
  062389  06E9: 8946fa           mov word ptr [bp - 6], ax
  06238C  06EC: 8a87b400         mov al, byte ptr [bx + 0xb4]
  062390  06F0: 98               cwde 
  062391  06F1: 038676ff         add ax, word ptr [bp - 0x8a]
  062395  06F5: 8946fc           mov word ptr [bp - 4], ax
  062398  06F8: 2b064ea1         sub ax, word ptr [0xa14e]
  06239C  06FC: 8946ce           mov word ptr [bp - 0x32], ax
  06239F  06FF: 0bc0             or ax, ax
  0623A1  0701: 7ebf             jle 0x6c2
  0623A3  0703: ebc7             jmp 0x6cc
  0623A5  0705: 90               nop 
  0623A6  0706: 8b46fa           mov ax, word ptr [bp - 6]
  0623A9  0709: 2b064ca1         sub ax, word ptr [0xa14c]
  0623AD  070D: 8946ce           mov word ptr [bp - 0x32], ax
  0623B0  0710: 0bc0             or ax, ax
  0623B2  0712: 7f0a             jg 0x71e
  0623B4  0714: 8b46fa           mov ax, word ptr [bp - 6]
  0623B7  0717: 2b064ca1         sub ax, word ptr [0xa14c]
  0623BB  071B: f7d0             not ax
  0623BD  071D: 40               inc ax
  0623BE  071E: 3d0800           cmp ax, 8
  0623C1  0721: 7dae             jge 0x6d1
  0623C3  0723: ff76fa           push word ptr [bp - 6]
  0623C6  0726: ff76fc           push word ptr [bp - 4]
  0623C9  0729: 9a02031f18       lcall 0x181f, 0x302
  0623CE  072E: 83c404           add sp, 4
  0623D1  0731: 0bc0             or ax, ax
  0623D3  0733: 749c             je 0x6d1
  0623D5  0735: ff76fa           push word ptr [bp - 6]
  0623D8  0738: ff76fc           push word ptr [bp - 4]
  0623DB  073B: 9a8c071f18       lcall 0x181f, 0x78c
  0623E0  0740: 83c404           add sp, 4
  0623E3  0743: 8946ee           mov word ptr [bp - 0x12], ax
  0623E6  0746: 3d1900           cmp ax, 0x19
  0623E9  0749: 7405             je 0x750
  0623EB  074B: 3d1a00           cmp ax, 0x1a
  0623EE  074E: 7508             jne 0x758
  0623F0  0750: c746cc0100       mov word ptr [bp - 0x34], 1
  0623F5  0755: eb06             jmp 0x75d
  0623F7  0757: 90               nop 
  0623F8  0758: c746cc0000       mov word ptr [bp - 0x34], 0
  0623FD  075D: 8b46e2           mov ax, word ptr [bp - 0x1e]
  062400  0760: 3946cc           cmp word ptr [bp - 0x34], ax
  062403  0763: 7516             jne 0x77b
  062405  0765: 0bc0             or ax, ax
  062407  0767: 7451             je 0x7ba
  062409  0769: ff76fa           push word ptr [bp - 6]
  06240C  076C: ff76fc           push word ptr [bp - 4]
  06240F  076F: 9ab4061f18       lcall 0x181f, 0x6b4
  062414  0774: 83c404           add sp, 4
  062417  0777: fec8             dec al
  062419  0779: 743f             je 0x7ba
  06241B  077B: ff76fa           push word ptr [bp - 6]
  06241E  077E: ff76fc           push word ptr [bp - 4]
  062421  0781: 9a96061f18       lcall 0x181f, 0x696
  062426  0786: 83c404           add sp, 4
  062429  0789: 0bc0             or ax, ax
  06242B  078B: 7d03             jge 0x790
  06242D  078D: e941ff           jmp 0x6d1
  062430  0790: 8b46fc           mov ax, word ptr [bp - 4]
  062433  0793: 398676ff         cmp word ptr [bp - 0x8a], ax
  062437  0797: 7509             jne 0x7a2
  062439  0799: 8b46fa           mov ax, word ptr [bp - 6]
  06243C  079C: 398678ff         cmp word ptr [bp - 0x88], ax
  062440  07A0: 7418             je 0x7ba
  062442  07A2: 8b46fc           mov ax, word ptr [bp - 4]
  062445  07A5: 39061a2d         cmp word ptr [0x2d1a], ax
  062449  07A9: 7403             je 0x7ae
  06244B  07AB: e923ff           jmp 0x6d1
  06244E  07AE: 8b46fa           mov ax, word ptr [bp - 6]
  062451  07B1: 39061c2d         cmp word ptr [0x2d1c], ax
  062455  07B5: 7403             je 0x7ba
  062457  07B7: e917ff           jmp 0x6d1
  06245A  07BA: 833ed21d13       cmp word ptr [0x1dd2], 0x13
  06245F  07BF: 7c15             jl 0x7d6
  062461  07C1: ff76fa           push word ptr [bp - 6]
  062464  07C4: ff76fc           push word ptr [bp - 4]
  062467  07C7: 9a5e071f18       lcall 0x181f, 0x75e
  06246C  07CC: 83c404           add sp, 4
  06246F  07CF: 0bc0             or ax, ax
  062471  07D1: 7403             je 0x7d6
  062473  07D3: e9fbfe           jmp 0x6d1
  062476  07D6: 8b76fc           mov si, word ptr [bp - 4]
  062479  07D9: 2b76f8           sub si, word ptr [bp - 8]
  06247C  07DC: c1e604           shl si, 4
  06247F  07DF: 2b76f6           sub si, word ptr [bp - 0xa]
  062482  07E2: 8b5efa           mov bx, word ptr [bp - 6]
  062485  07E5: 8a8070a2         mov al, byte ptr [bx + si - 0x5d90]
  062489  07E9: 2ae4             sub ah, ah
  06248B  07EB: 8946de           mov word ptr [bp - 0x22], ax
  06248E  07EE: 833ed61d00       cmp word ptr [0x1dd6], 0
  062493  07F3: 7c4f             jl 0x844
  062495  07F5: 53               push bx
  062496  07F6: ff76fc           push word ptr [bp - 4]
  062499  07F9: 9ad2061f18       lcall 0x181f, 0x6d2
  06249E  07FE: 83c404           add sp, 4
  0624A1  0801: 8946d6           mov word ptr [bp - 0x2a], ax
  0624A4  0804: 0bc0             or ax, ax
  0624A6  0806: 7c09             jl 0x811
  0624A8  0808: 3b06d61d         cmp ax, word ptr [0x1dd6]
  0624AC  080C: 7403             je 0x811
  0624AE  080E: e9c0fe           jmp 0x6d1
  0624B1  0811: ff36d61d         push word ptr [0x1dd6]
  0624B5  0815: ff76fa           push word ptr [bp - 6]
  0624B8  0818: ff76fc           push word ptr [bp - 4]
  0624BB  081B: 9ae6061f18       lcall 0x181f, 0x6e6
  0624C0  0820: 83c406           add sp, 6
  0624C3  0823: 0bc0             or ax, ax
  0624C5  0825: 7c1d             jl 0x844
  0624C7  0827: 833ed61d04       cmp word ptr [0x1dd6], 4
  0624CC  082C: 7c03             jl 0x831
  0624CE  082E: e9a0fe           jmp 0x6d1
  0624D1  0831: 6b1ed61d34       imul bx, word ptr [0x1dd6], 0x34
  0624D6  0836: 80bf3f5400       cmp byte ptr [bx + 0x543f], 0
  0624DB  083B: 7403             je 0x840
  0624DD  083D: e991fe           jmp 0x6d1
  0624E0  0840: 8346de08         add word ptr [bp - 0x22], 8
  0624E4  0844: 837ede00         cmp word ptr [bp - 0x22], 0
  0624E8  0848: 7503             jne 0x84d
  0624EA  084A: e984fe           jmp 0x6d1
  0624ED  084D: 8b46de           mov ax, word ptr [bp - 0x22]
  0624F0  0850: 3946fe           cmp word ptr [bp - 2], ax
  0624F3  0853: 7f03             jg 0x858
  0624F5  0855: e979fe           jmp 0x6d1
  0624F8  0858: 837eec00         cmp word ptr [bp - 0x14], 0
  0624FC  085C: 741a             je 0x878
  0624FE  085E: ff76fa           push word ptr [bp - 6]
  062501  0861: ff76fc           push word ptr [bp - 4]
  062504  0864: 9a54071f18       lcall 0x181f, 0x754
  062509  0869: 83c404           add sp, 4
  06250C  086C: a80a             test al, 0xa
  06250E  086E: 7408             je 0x878
  062510  0870: c746e40100       mov word ptr [bp - 0x1c], 1
  062515  0875: eb5b             jmp 0x8d2
  062517  0877: 90               nop 
  062518  0878: 837ee800         cmp word ptr [bp - 0x18], 0
  06251C  087C: 7424             je 0x8a2
  06251E  087E: ff76fa           push word ptr [bp - 6]
  062521  0881: ff76fc           push word ptr [bp - 4]
  062524  0884: 9a2c071f18       lcall 0x181f, 0x72c
  062529  0889: 83c404           add sp, 4
  06252C  088C: a840             test al, 0x40
  06252E  088E: 7412             je 0x8a2
  062530  0890: 8b46fc           mov ax, word ptr [bp - 4]
  062533  0893: 398676ff         cmp word ptr [bp - 0x8a], ax
  062537  0897: 74d7             je 0x870
  062539  0899: 8b46fa           mov ax, word ptr [bp - 6]
  06253C  089C: 398678ff         cmp word ptr [bp - 0x88], ax
  062540  08A0: 74ce             je 0x870
  062542  08A2: 837ef000         cmp word ptr [bp - 0x10], 0
  062546  08A6: 7408             je 0x8b0
  062548  08A8: c746e40300       mov word ptr [bp - 0x1c], 3
  06254D  08AD: eb23             jmp 0x8d2
  06254F  08AF: 90               nop 
  062550  08B0: ff76fa           push word ptr [bp - 6]
  062553  08B3: ff76fc           push word ptr [bp - 4]
  062556  08B6: 9a8c071f18       lcall 0x181f, 0x78c
  06255B  08BB: 83c404           add sp, 4
  06255E  08BE: 8bd8             mov bx, ax
  062560  08C0: c1e304           shl bx, 4
  062563  08C3: 8a87762f         mov al, byte ptr [bx + 0x2f76]
  062567  08C7: 2ae4             sub ah, ah
  062569  08C9: 8bc8             mov cx, ax
  06256B  08CB: d1e0             shl ax, 1
  06256D  08CD: 03c1             add ax, cx
  06256F  08CF: 8946e4           mov word ptr [bp - 0x1c], ax
  062572  08D2: 8b46d2           mov ax, word ptr [bp - 0x2e]
  062575  08D5: 8b4ee4           mov cx, word ptr [bp - 0x1c]
  062578  08D8: 014ede           add word ptr [bp - 0x22], cx
  06257B  08DB: 3946de           cmp word ptr [bp - 0x22], ax
  06257E  08DE: 7e03             jle 0x8e3
  062580  08E0: e9eefd           jmp 0x6d1
  062583  08E3: 8b46fc           mov ax, word ptr [bp - 4]
  062586  08E6: 8b56fa           mov dx, word ptr [bp - 6]
  062589  08E9: 9ae0071f18       lcall 0x181f, 0x7e0
  06258E  08EE: 8946da           mov word ptr [bp - 0x26], ax
  062591  08F1: ff76fa           push word ptr [bp - 6]
  062594  08F4: ff76fc           push word ptr [bp - 4]
  062597  08F7: ff364ca1         push word ptr [0xa14c]
  06259B  08FB: ff364ea1         push word ptr [0xa14e]
  06259F  08FF: 9a7a031f18       lcall 0x181f, 0x37a
  0625A4  0904: 83c408           add sp, 8
  0625A7  0907: 8946d8           mov word ptr [bp - 0x28], ax
  0625AA  090A: 8b46d2           mov ax, word ptr [bp - 0x2e]
  0625AD  090D: 3946de           cmp word ptr [bp - 0x22], ax
  0625B0  0910: 7d16             jge 0x928
  0625B2  0912: 8b46de           mov ax, word ptr [bp - 0x22]
  0625B5  0915: 8946d2           mov word ptr [bp - 0x2e], ax
  0625B8  0918: 8b46f2           mov ax, word ptr [bp - 0xe]
  0625BB  091B: 8946ea           mov word ptr [bp - 0x16], ax
  0625BE  091E: 8b46d8           mov ax, word ptr [bp - 0x28]
  0625C1  0921: 8946f4           mov word ptr [bp - 0xc], ax
  0625C4  0924: e9aafd           jmp 0x6d1
  0625C7  0927: 90               nop 
  0625C8  0928: 8b46f4           mov ax, word ptr [bp - 0xc]
  0625CB  092B: 3946d8           cmp word ptr [bp - 0x28], ax
  0625CE  092E: 7c03             jl 0x933
  0625D0  0930: e99efd           jmp 0x6d1
  0625D3  0933: ebe3             jmp 0x918
  0625D5  0935: 90               nop 
  0625D6  0936: 837eea00         cmp word ptr [bp - 0x16], 0
  0625DA  093A: 7d0c             jge 0x948
  0625DC  093C: a11a2d           mov ax, word ptr [0x2d1a]
  0625DF  093F: a34ea1           mov word ptr [0xa14e], ax
  0625E2  0942: a11c2d           mov ax, word ptr [0x2d1c]
  0625E5  0945: a34ca1           mov word ptr [0xa14c], ax
  0625E8  0948: 837edc00         cmp word ptr [bp - 0x24], 0
  0625EC  094C: 7503             jne 0x951
  0625EE  094E: e91e01           jmp 0xa6f
  0625F1  0951: 8b8676ff         mov ax, word ptr [bp - 0x8a]
  0625F5  0955: a37c01           mov word ptr [0x17c], ax
  0625F8  0958: 8b8678ff         mov ax, word ptr [bp - 0x88]
  0625FC  095C: a37e01           mov word ptr [0x17e], ax
  0625FF  095F: 6a01             push 1
  062601  0961: 9a1c0e1f18       lcall 0x181f, 0xe1c
  062606  0966: 83c402           add sp, 2
  062609  0969: c746e60000       mov word ptr [bp - 0x1a], 0
  06260E  096E: eb3d             jmp 0x9ad
  062610  0970: ff46e0           inc word ptr [bp - 0x20]
  062613  0973: 837ee010         cmp word ptr [bp - 0x20], 0x10
  062617  0977: 7d31             jge 0x9aa
  062619  0979: 8b46f6           mov ax, word ptr [bp - 0xa]
  06261C  097C: 0346e0           add ax, word ptr [bp - 0x20]
  06261F  097F: 8946ce           mov word ptr [bp - 0x32], ax
  062622  0982: 8b76e6           mov si, word ptr [bp - 0x1a]
  062625  0985: c1e604           shl si, 4
  062628  0988: 8b5ee0           mov bx, word ptr [bp - 0x20]
  06262B  098B: 80b870a200       cmp byte ptr [bx + si - 0x5d90], 0
  062630  0990: 74de             je 0x970
  062632  0992: 6a0f             push 0xf
  062634  0994: 8a8870a2         mov cl, byte ptr [bx + si - 0x5d90]
  062638  0998: 2aed             sub ch, ch
  06263A  099A: 51               push cx
  06263B  099B: 50               push ax
  06263C  099C: ff76cc           push word ptr [bp - 0x34]
  06263F  099F: 9a2c011f19       lcall 0x191f, 0x12c
  062644  09A4: 83c408           add sp, 8
  062647  09A7: ebc7             jmp 0x970
  062649  09A9: 90               nop 
  06264A  09AA: ff46e6           inc word ptr [bp - 0x1a]
  06264D  09AD: 837ee610         cmp word ptr [bp - 0x1a], 0x10
  062651  09B1: 7d11             jge 0x9c4
  062653  09B3: 8b46f8           mov ax, word ptr [bp - 8]
  062656  09B6: 0346e6           add ax, word ptr [bp - 0x1a]
  062659  09B9: 8946cc           mov word ptr [bp - 0x34], ax
  06265C  09BC: c746e00000       mov word ptr [bp - 0x20], 0
  062661  09C1: ebb0             jmp 0x973
  062663  09C3: 90               nop 
  062664  09C4: ff76ea           push word ptr [bp - 0x16]
  062667  09C7: ffb67aff         push word ptr [bp - 0x86]
  06266B  09CB: ffb678ff         push word ptr [bp - 0x88]
  06266F  09CF: ffb676ff         push word ptr [bp - 0x8a]
  062673  09D3: ff364ca1         push word ptr [0xa14c]
  062677  09D7: ff364ea1         push word ptr [0xa14e]
  06267B  09DB: 68d81d           push 0x1dd8
  06267E  09DE: 8d867cff         lea ax, [bp - 0x84]
  062682  09E2: 50               push ax
  062683  09E3: 9a480b1d0d       lcall 0xd1d, 0xb48
  062688  09E8: 83c410           add sp, 0x10
  06268B  09EB: 6a0c             push 0xc
  06268D  09ED: b8ffff           mov ax, 0xffff
  062690  09F0: ba0c00           mov dx, 0xc
  062693  09F3: 8bda             mov bx, dx
  062695  09F5: 9af0011f18       lcall 0x181f, 0x1f0
  06269A  09FA: ff36a008         push word ptr [0x8a0]
  06269E  09FE: ff369e08         push word ptr [0x89e]
  0626A2  0A02: 8d867cff         lea ax, [bp - 0x84]
  0626A6  0A06: 16               push ss
  0626A7  0A07: 50               push ax
  0626A8  0A08: 6a00             push 0
  0626AA  0A0A: 8d1eca1d         lea bx, [0x1dca]
  0626AE  0A0E: b80500           mov ax, 5
  0626B1  0A11: babe00           mov dx, 0xbe
  0626B4  0A14: 9afa011f18       lcall 0x181f, 0x1fa
  0626B9  0A19: 9ae0031f18       lcall 0x181f, 0x3e0
  0626BE  0A1E: 8946d0           mov word ptr [bp - 0x30], ax
  0626C1  0A21: 50               push ax
  0626C2  0A22: 9a2c091d0d       lcall 0xd1d, 0x92c
  0626C7  0A27: 83c402           add sp, 2
  0626CA  0A2A: 8946d0           mov word ptr [bp - 0x30], ax
  0626CD  0A2D: eb27             jmp 0xa56
  0626CF  0A2F: 90               nop 
  0626D0  0A30: a18401           mov ax, word ptr [0x184]
  0626D3  0A33: 48               dec ax
  0626D4  0A34: 7902             jns 0xa38
  0626D6  0A36: 2bc0             sub ax, ax
  0626D8  0A38: a38401           mov word ptr [0x184], ax
  0626DB  0A3B: e913ff           jmp 0x951
  0626DE  0A3E: a18401           mov ax, word ptr [0x184]
  0626E1  0A41: 40               inc ax
  0626E2  0A42: 3d0300           cmp ax, 3
  0626E5  0A45: 7ef1             jle 0xa38
  0626E7  0A47: b80300           mov ax, 3
  0626EA  0A4A: ebec             jmp 0xa38
  0626EC  0A4C: 2bc0             sub ax, ax
  0626EE  0A4E: a3f21d           mov word ptr [0x1df2], ax
  0626F1  0A51: a3f41d           mov word ptr [0x1df4], ax
  0626F4  0A54: eb0f             jmp 0xa65
  0626F6  0A56: 3d5a00           cmp ax, 0x5a
  0626F9  0A59: 74d5             je 0xa30
  0626FB  0A5B: 7708             ja 0xa65
  0626FD  0A5D: 2c1b             sub al, 0x1b
  0626FF  0A5F: 74eb             je 0xa4c
  062701  0A61: 2c3d             sub al, 0x3d
  062703  0A63: 74d9             je 0xa3e
  062705  0A65: 6a01             push 1
  062707  0A67: 9a1c0e1f18       lcall 0x181f, 0xe1c
  06270C  0A6C: 83c402           add sp, 2
  06270F  0A6F: 8b46ea           mov ax, word ptr [bp - 0x16]
  062712  0A72: 5e               pop si
  062713  0A73: c9               leave 
  062714  0A74: cb               retf 

; ---- func_062716  size=168  insns=68  prologue=ENTER 0x000C,0  terminal=RETF imm16 ----
  062716  0A76: c80c0000         enter 0xc, 0
  06271A  0A7A: 50               push ax
  06271B  0A7B: c746fcffff       mov word ptr [bp - 4], 0xffff
  062720  0A80: 2bc3             sub ax, bx
  062722  0A82: 0bc0             or ax, ax
  062724  0A84: 7f08             jg 0xa8e
  062726  0A86: 8b46f2           mov ax, word ptr [bp - 0xe]
  062729  0A89: 2bc3             sub ax, bx
  06272B  0A8B: f7d0             not ax
  06272D  0A8D: 40               inc ax
  06272E  0A8E: 0bc0             or ax, ax
  062730  0A90: 7515             jne 0xaa7
  062732  0A92: 8bc2             mov ax, dx
  062734  0A94: 2b460a           sub ax, word ptr [bp + 0xa]
  062737  0A97: 0bc0             or ax, ax
  062739  0A99: 7f08             jg 0xaa3
  06273B  0A9B: 8bc2             mov ax, dx
  06273D  0A9D: 2b460a           sub ax, word ptr [bp + 0xa]
  062740  0AA0: f7d0             not ax
  062742  0AA2: 40               inc ax
  062743  0AA3: 0bc0             or ax, ax
  062745  0AA5: 746d             je 0xb14
  062747  0AA7: 8b46f2           mov ax, word ptr [bp - 0xe]
  06274A  0AAA: 2bc3             sub ax, bx
  06274C  0AAC: 0bc0             or ax, ax
  06274E  0AAE: 7f08             jg 0xab8
  062750  0AB0: 8b46f2           mov ax, word ptr [bp - 0xe]
  062753  0AB3: 2bc3             sub ax, bx
  062755  0AB5: f7d0             not ax
  062757  0AB7: 40               inc ax
  062758  0AB8: 3d0800           cmp ax, 8
  06275B  0ABB: 7d5a             jge 0xb17
  06275D  0ABD: 8bc2             mov ax, dx
  06275F  0ABF: 2b460a           sub ax, word ptr [bp + 0xa]
  062762  0AC2: 0bc0             or ax, ax
  062764  0AC4: 7f08             jg 0xace
  062766  0AC6: 8bc2             mov ax, dx
  062768  0AC8: 2b460a           sub ax, word ptr [bp + 0xa]
  06276B  0ACB: f7d0             not ax
  06276D  0ACD: 40               inc ax
  06276E  0ACE: 3d0800           cmp ax, 8
  062771  0AD1: 7d44             jge 0xb17
  062773  0AD3: 837e0801         cmp word ptr [bp + 8], 1
  062777  0AD7: 1bc0             sbb ax, ax
  062779  0AD9: 24f4             and al, 0xf4
  06277B  0ADB: 050d00           add ax, 0xd
  06277E  0ADE: a3d21d           mov word ptr [0x1dd2], ax
  062781  0AE1: 8bc3             mov ax, bx
  062783  0AE3: a34ea1           mov word ptr [0xa14e], ax
  062786  0AE6: 8b460a           mov ax, word ptr [bp + 0xa]
  062789  0AE9: a34ca1           mov word ptr [0xa14c], ax
  06278C  0AEC: a1d61d           mov ax, word ptr [0x1dd6]
  06278F  0AEF: 8946fe           mov word ptr [bp - 2], ax
  062792  0AF2: c706d61dffff     mov word ptr [0x1dd6], 0xffff
  062798  0AF8: 8b46f2           mov ax, word ptr [bp - 0xe]
  06279B  0AFB: 8b5e06           mov bx, word ptr [bp + 6]
  06279E  0AFE: 0e               push cs
  06279F  0AFF: e82a0c           call 0x172c
  0627A2  0B02: 8946fc           mov word ptr [bp - 4], ax
  0627A5  0B05: 8b46fe           mov ax, word ptr [bp - 2]
  0627A8  0B08: a3d61d           mov word ptr [0x1dd6], ax
  0627AB  0B0B: 837efc00         cmp word ptr [bp - 4], 0
  0627AF  0B0F: 7c06             jl 0xb17
  0627B1  0B11: a170a3           mov ax, word ptr [0xa370]
  0627B4  0B14: 8946fc           mov word ptr [bp - 4], ax
  0627B7  0B17: 8b46fc           mov ax, word ptr [bp - 4]
  0627BA  0B1A: c9               leave 
  0627BB  0B1B: ca0600           retf 6

; ---- func_0627BE  size=415  insns=158  prologue=ENTER 0x0014,0  terminal=RET ----
  0627BE  0B1E: c8140000         enter 0x14, 0
  0627C2  0B22: 53               push bx
  0627C3  0B23: 52               push dx
  0627C4  0B24: 50               push ax
  0627C5  0B25: 56               push si
  0627C6  0B26: c746f2ffff       mov word ptr [bp - 0xe], 0xffff
  0627CB  0B2B: c1f802           sar ax, 2
  0627CE  0B2E: 8946f0           mov word ptr [bp - 0x10], ax
  0627D1  0B31: c1fa02           sar dx, 2
  0627D4  0B34: 8956ee           mov word ptr [bp - 0x12], dx
  0627D7  0B37: 0bdb             or bx, bx
  0627D9  0B39: 740d             je 0xb48
  0627DB  0B3B: 6bf012           imul si, ax, 0x12
  0627DE  0B3E: 8bda             mov bx, dx
  0627E0  0B40: 80b8f68600       cmp byte ptr [bx + si - 0x790a], 0
  0627E5  0B45: eb0b             jmp 0xb52
  0627E7  0B47: 90               nop 
  0627E8  0B48: 6bf012           imul si, ax, 0x12
  0627EB  0B4B: 8bda             mov bx, dx
  0627ED  0B4D: 80b8e88500       cmp byte ptr [bx + si - 0x7a18], 0
  0627F2  0B52: 7405             je 0xb59
  0627F4  0B54: c746f20800       mov word ptr [bp - 0xe], 8
  0627F9  0B59: 837ef208         cmp word ptr [bp - 0xe], 8
  0627FD  0B5D: 753d             jne 0xb9c
  0627FF  0B5F: 8d46fa           lea ax, [bp - 6]
  062802  0B62: 50               push ax
  062803  0B63: ff76ea           push word ptr [bp - 0x16]
  062806  0B66: 8b46f0           mov ax, word ptr [bp - 0x10]
  062809  0B69: c1e002           shl ax, 2
  06280C  0B6C: 40               inc ax
  06280D  0B6D: 8b56ee           mov dx, word ptr [bp - 0x12]
  062810  0B70: c1e202           shl dx, 2
  062813  0B73: 42               inc dx
  062814  0B74: 8d5efe           lea bx, [bp - 2]
  062817  0B77: e8f6f5           call 0x170
  06281A  0B7A: 0bc0             or ax, ax
  06281C  0B7C: 7419             je 0xb97
  06281E  0B7E: ff76e8           push word ptr [bp - 0x18]
  062821  0B81: ff76ea           push word ptr [bp - 0x16]
  062824  0B84: 6a12             push 0x12
  062826  0B86: 8b46fe           mov ax, word ptr [bp - 2]
  062829  0B89: 8b56fa           mov dx, word ptr [bp - 6]
  06282C  0B8C: 8b5ee6           mov bx, word ptr [bp - 0x1a]
  06282F  0B8F: 0e               push cs
  062830  0B90: e88f0b           call 0x1722
  062833  0B93: 0bc0             or ax, ax
  062835  0B95: 7d05             jge 0xb9c
  062837  0B97: c746f2ffff       mov word ptr [bp - 0xe], 0xffff
  06283C  0B9C: 837ef200         cmp word ptr [bp - 0xe], 0
  062840  0BA0: 7c03             jl 0xba5
  062842  0BA2: e9e700           jmp 0xc8c
  062845  0BA5: c746ec6300       mov word ptr [bp - 0x14], 0x63
  06284A  0BAA: c746f40000       mov word ptr [bp - 0xc], 0
  06284F  0BAF: eb10             jmp 0xbc1
  062851  0BB1: 90               nop 
  062852  0BB2: 837ef800         cmp word ptr [bp - 8], 0
  062856  0BB6: 7c06             jl 0xbbe
  062858  0BB8: 837ef812         cmp word ptr [bp - 8], 0x12
  06285C  0BBC: 7c30             jl 0xbee
  06285E  0BBE: ff46f4           inc word ptr [bp - 0xc]
  062861  0BC1: 837ef408         cmp word ptr [bp - 0xc], 8
  062865  0BC5: 7c03             jl 0xbca
  062867  0BC7: e9c200           jmp 0xc8c
  06286A  0BCA: 8b5ef4           mov bx, word ptr [bp - 0xc]
  06286D  0BCD: 8a87be00         mov al, byte ptr [bx + 0xbe]
  062871  0BD1: 98               cwde 
  062872  0BD2: 0346ee           add ax, word ptr [bp - 0x12]
  062875  0BD5: 8946f8           mov word ptr [bp - 8], ax
  062878  0BD8: 8a87b400         mov al, byte ptr [bx + 0xb4]
  06287C  0BDC: 98               cwde 
  06287D  0BDD: 0346f0           add ax, word ptr [bp - 0x10]
  062880  0BE0: 8946fc           mov word ptr [bp - 4], ax
  062883  0BE3: 0bc0             or ax, ax
  062885  0BE5: 7cd7             jl 0xbbe
  062887  0BE7: 3d0f00           cmp ax, 0xf
  06288A  0BEA: 7cc6             jl 0xbb2
  06288C  0BEC: ebd0             jmp 0xbbe
  06288E  0BEE: 837eea00         cmp word ptr [bp - 0x16], 0
  062892  0BF2: 740d             je 0xc01
  062894  0BF4: 6bf012           imul si, ax, 0x12
  062897  0BF7: 8b5ef8           mov bx, word ptr [bp - 8]
  06289A  0BFA: 80b8f68600       cmp byte ptr [bx + si - 0x790a], 0
  06289F  0BFF: 7513             jne 0xc14
  0628A1  0C01: 837eea00         cmp word ptr [bp - 0x16], 0
  0628A5  0C05: 75b7             jne 0xbbe
  0628A7  0C07: 6bf012           imul si, ax, 0x12
  0628AA  0C0A: 8b5ef8           mov bx, word ptr [bp - 8]
  0628AD  0C0D: 80b8e88500       cmp byte ptr [bx + si - 0x7a18], 0
  0628B2  0C12: 74aa             je 0xbbe
  0628B4  0C14: 8bc3             mov ax, bx
  0628B6  0C16: c1e002           shl ax, 2
  0628B9  0C19: 40               inc ax
  0628BA  0C1A: 8946fa           mov word ptr [bp - 6], ax
  0628BD  0C1D: 2b46e8           sub ax, word ptr [bp - 0x18]
  0628C0  0C20: f7d8             neg ax
  0628C2  0C22: 50               push ax
  0628C3  0C23: 8b46fc           mov ax, word ptr [bp - 4]
  0628C6  0C26: c1e002           shl ax, 2
  0628C9  0C29: 40               inc ax
  0628CA  0C2A: 8946fe           mov word ptr [bp - 2], ax
  0628CD  0C2D: 2b46e6           sub ax, word ptr [bp - 0x1a]
  0628D0  0C30: f7d8             neg ax
  0628D2  0C32: 50               push ax
  0628D3  0C33: 9a70031f18       lcall 0x181f, 0x370
  0628D8  0C38: 83c404           add sp, 4
  0628DB  0C3B: 8946f6           mov word ptr [bp - 0xa], ax
  0628DE  0C3E: 3b46ec           cmp ax, word ptr [bp - 0x14]
  0628E1  0C41: 7c03             jl 0xc46
  0628E3  0C43: e978ff           jmp 0xbbe
  0628E6  0C46: 8d4efa           lea cx, [bp - 6]
  0628E9  0C49: 51               push cx
  0628EA  0C4A: ff76ea           push word ptr [bp - 0x16]
  0628ED  0C4D: 8b56fa           mov dx, word ptr [bp - 6]
  0628F0  0C50: 8b46fe           mov ax, word ptr [bp - 2]
  0628F3  0C53: 8d5efe           lea bx, [bp - 2]
  0628F6  0C56: e817f5           call 0x170
  0628F9  0C59: 0bc0             or ax, ax
  0628FB  0C5B: 7503             jne 0xc60
  0628FD  0C5D: e95eff           jmp 0xbbe
  062900  0C60: ff76e8           push word ptr [bp - 0x18]
  062903  0C63: ff76ea           push word ptr [bp - 0x16]
  062906  0C66: 6a12             push 0x12
  062908  0C68: 8b46fe           mov ax, word ptr [bp - 2]
  06290B  0C6B: 8b56fa           mov dx, word ptr [bp - 6]
  06290E  0C6E: 8b5ee6           mov bx, word ptr [bp - 0x1a]
  062911  0C71: 0e               push cs
  062912  0C72: e8ad0a           call 0x1722
  062915  0C75: 0bc0             or ax, ax
  062917  0C77: 7d03             jge 0xc7c
  062919  0C79: e942ff           jmp 0xbbe
  06291C  0C7C: 8b46f6           mov ax, word ptr [bp - 0xa]
  06291F  0C7F: 8946ec           mov word ptr [bp - 0x14], ax
  062922  0C82: 8b46f4           mov ax, word ptr [bp - 0xc]
  062925  0C85: 8946f2           mov word ptr [bp - 0xe], ax
  062928  0C88: e933ff           jmp 0xbbe
  06292B  0C8B: 90               nop 
  06292C  0C8C: 837ef200         cmp word ptr [bp - 0xe], 0
  062930  0C90: 7c19             jl 0xcab
  062932  0C92: 8b5ef2           mov bx, word ptr [bp - 0xe]
  062935  0C95: 8a87b400         mov al, byte ptr [bx + 0xb4]
  062939  0C99: 98               cwde 
  06293A  0C9A: 0346f0           add ax, word ptr [bp - 0x10]
  06293D  0C9D: a34ea1           mov word ptr [0xa14e], ax
  062940  0CA0: 8a87be00         mov al, byte ptr [bx + 0xbe]
  062944  0CA4: 98               cwde 
  062945  0CA5: 0346ee           add ax, word ptr [bp - 0x12]
  062948  0CA8: a34ca1           mov word ptr [0xa14c], ax
  06294B  0CAB: 837ef200         cmp word ptr [bp - 0xe], 0
  06294F  0CAF: 7c07             jl 0xcb8
  062951  0CB1: b80100           mov ax, 1
  062954  0CB4: 5e               pop si
  062955  0CB5: c9               leave 
  062956  0CB6: c3               ret 
  062957  0CB7: 90               nop 
  062958  0CB8: 2bc0             sub ax, ax
  06295A  0CBA: 5e               pop si
  06295B  0CBB: c9               leave 
  06295C  0CBC: c3               ret 

; ---- func_06295E  size=1061  insns=373  prologue=ENTER 0x007A,0  terminal=RETF imm16 ----
  06295E  0CBE: c87a0000         enter 0x7a, 0
  062962  0CC2: 53               push bx
  062963  0CC3: 52               push dx
  062964  0CC4: 50               push ax
  062965  0CC5: 56               push si
  062966  0CC6: c746fc0000       mov word ptr [bp - 4], 0
  06296B  0CCB: a1f41d           mov ax, word ptr [0x1df4]
  06296E  0CCE: 894694           mov word ptr [bp - 0x6c], ax
  062971  0CD1: 0bc0             or ax, ax
  062973  0CD3: 751b             jne 0xcf0
  062975  0CD5: f606940820       test byte ptr [0x894], 0x20
  06297A  0CDA: 7414             je 0xcf0
  06297C  0CDC: 3906a253         cmp word ptr [0x53a2], ax
  062980  0CE0: 7509             jne 0xceb
  062982  0CE2: a19653           mov ax, word ptr [0x5396]
  062985  0CE5: 3906d61d         cmp word ptr [0x1dd6], ax
  062989  0CE9: 7505             jne 0xcf0
  06298B  0CEB: c746940100       mov word ptr [bp - 0x6c], 1
  062990  0CF0: 8bc3             mov ax, bx
  062992  0CF2: a34ea1           mov word ptr [0xa14e], ax
  062995  0CF5: 8b4606           mov ax, word ptr [bp + 6]
  062998  0CF8: a34ca1           mov word ptr [0xa14c], ax
  06299B  0CFB: 833ed21d0d       cmp word ptr [0x1dd2], 0xd
  0629A0  0D00: 7c0e             jl 0xd10
  0629A2  0D02: 833ed21d12       cmp word ptr [0x1dd2], 0x12
  0629A7  0D07: 7f07             jg 0xd10
  0629A9  0D09: c746980100       mov word ptr [bp - 0x68], 1
  0629AE  0D0E: eb05             jmp 0xd15
  0629B0  0D10: c746980000       mov word ptr [bp - 0x68], 0
  0629B5  0D15: 8b4680           mov ax, word ptr [bp - 0x80]
  0629B8  0D18: 8b5e98           mov bx, word ptr [bp - 0x68]
  0629BB  0D1B: e800fe           call 0xb1e
  0629BE  0D1E: 0bc0             or ax, ax
  0629C0  0D20: 7503             jne 0xd25
  0629C2  0D22: e98900           jmp 0xdae
  0629C5  0D25: a14ea1           mov ax, word ptr [0xa14e]
  0629C8  0D28: a372a5           mov word ptr [0xa572], ax
  0629CB  0D2B: 894680           mov word ptr [bp - 0x80], ax
  0629CE  0D2E: a14ca1           mov ax, word ptr [0xa14c]
  0629D1  0D31: a374a5           mov word ptr [0xa574], ax
  0629D4  0D34: 894682           mov word ptr [bp - 0x7e], ax
  0629D7  0D37: 8b4684           mov ax, word ptr [bp - 0x7c]
  0629DA  0D3A: 8b5606           mov dx, word ptr [bp + 6]
  0629DD  0D3D: 8b5e98           mov bx, word ptr [bp - 0x68]
  0629E0  0D40: e8dbfd           call 0xb1e
  0629E3  0D43: 680e01           push 0x10e
  0629E6  0D46: 6a00             push 0
  0629E8  0D48: 6862a1           push 0xa162
  0629EB  0D4B: 9aae0d1d0d       lcall 0xd1d, 0xdae
  0629F0  0D50: 83c406           add sp, 6
  0629F3  0D53: c706182d0000     mov word ptr [0x2d18], 0
  0629F9  0D59: a04ea1           mov al, byte ptr [0xa14e]
  0629FC  0D5C: a272a3           mov byte ptr [0xa372], al
  0629FF  0D5F: a04ca1           mov al, byte ptr [0xa14c]
  062A02  0D62: a272a4           mov byte ptr [0xa472], al
  062A05  0D65: c706162d0100     mov word ptr [0x2d16], 1
  062A0B  0D6B: 6b364ea112       imul si, word ptr [0xa14e], 0x12
  062A10  0D70: 8b1e4ca1         mov bx, word ptr [0xa14c]
  062A14  0D74: c68062a101       mov byte ptr [bx + si - 0x5e9e], 1
  062A19  0D79: 8b1e182d         mov bx, word ptr [0x2d18]
  062A1D  0D7D: 8a8772a3         mov al, byte ptr [bx - 0x5c8e]
  062A21  0D81: 2ae4             sub ah, ah
  062A23  0D83: 89469c           mov word ptr [bp - 0x64], ax
  062A26  0D86: 8a8772a4         mov al, byte ptr [bx - 0x5b8e]
  062A2A  0D8A: 89469a           mov word ptr [bp - 0x66], ax
  062A2D  0D8D: fec3             inc bl
  062A2F  0D8F: 2aff             sub bh, bh
  062A31  0D91: 891e182d         mov word ptr [0x2d18], bx
  062A35  0D95: 8b469c           mov ax, word ptr [bp - 0x64]
  062A38  0D98: 394680           cmp word ptr [bp - 0x80], ax
  062A3B  0D9B: 7521             jne 0xdbe
  062A3D  0D9D: 8b469a           mov ax, word ptr [bp - 0x66]
  062A40  0DA0: 394682           cmp word ptr [bp - 0x7e], ax
  062A43  0DA3: 7519             jne 0xdbe
  062A45  0DA5: c746fc0100       mov word ptr [bp - 4], 1
  062A4A  0DAA: e9b200           jmp 0xe5f
  062A4D  0DAD: 90               nop 
  062A4E  0DAE: 8b4684           mov ax, word ptr [bp - 0x7c]
  062A51  0DB1: a34ea1           mov word ptr [0xa14e], ax
  062A54  0DB4: 8b4606           mov ax, word ptr [bp + 6]
  062A57  0DB7: a34ca1           mov word ptr [0xa14c], ax
  062A5A  0DBA: e91203           jmp 0x10cf
  062A5D  0DBD: 90               nop 
  062A5E  0DBE: 6b5e9c12         imul bx, word ptr [bp - 0x64], 0x12
  062A62  0DC2: 035e9a           add bx, word ptr [bp - 0x66]
  062A65  0DC5: 8a8762a1         mov al, byte ptr [bx - 0x5e9e]
  062A69  0DC9: 2ae4             sub ah, ah
  062A6B  0DCB: 8946a8           mov word ptr [bp - 0x58], ax
  062A6E  0DCE: 895e86           mov word ptr [bp - 0x7a], bx
  062A71  0DD1: 837e9800         cmp word ptr [bp - 0x68], 0
  062A75  0DD5: 7407             je 0xdde
  062A77  0DD7: 8a87f686         mov al, byte ptr [bx - 0x790a]
  062A7B  0DDB: eb0c             jmp 0xde9
  062A7D  0DDD: 90               nop 
  062A7E  0DDE: 6b769c12         imul si, word ptr [bp - 0x64], 0x12
  062A82  0DE2: 8b5e9a           mov bx, word ptr [bp - 0x66]
  062A85  0DE5: 8a80e885         mov al, byte ptr [bx + si - 0x7a18]
  062A89  0DE9: 2ae4             sub ah, ah
  062A8B  0DEB: 894690           mov word ptr [bp - 0x70], ax
  062A8E  0DEE: c746a40000       mov word ptr [bp - 0x5c], 0
  062A93  0DF3: 8a4ea4           mov cl, byte ptr [bp - 0x5c]
  062A96  0DF6: b80100           mov ax, 1
  062A99  0DF9: d3e0             shl ax, cl
  062A9B  0DFB: 854690           test word ptr [bp - 0x70], ax
  062A9E  0DFE: 7444             je 0xe44
  062AA0  0E00: 8b5ea4           mov bx, word ptr [bp - 0x5c]
  062AA3  0E03: 8a87be00         mov al, byte ptr [bx + 0xbe]
  062AA7  0E07: 98               cwde 
  062AA8  0E08: 03469a           add ax, word ptr [bp - 0x66]
  062AAB  0E0B: 8946aa           mov word ptr [bp - 0x56], ax
  062AAE  0E0E: 8a87b400         mov al, byte ptr [bx + 0xb4]
  062AB2  0E12: 98               cwde 
  062AB3  0E13: 03469c           add ax, word ptr [bp - 0x64]
  062AB6  0E16: 8946fe           mov word ptr [bp - 2], ax
  062AB9  0E19: 6bf012           imul si, ax, 0x12
  062ABC  0E1C: 8b5eaa           mov bx, word ptr [bp - 0x56]
  062ABF  0E1F: 80b862a100       cmp byte ptr [bx + si - 0x5e9e], 0
  062AC4  0E24: 751e             jne 0xe44
  062AC6  0E26: 8a4ea8           mov cl, byte ptr [bp - 0x58]
  062AC9  0E29: fec1             inc cl
  062ACB  0E2B: 888862a1         mov byte ptr [bx + si - 0x5e9e], cl
  062ACF  0E2F: 8b36162d         mov si, word ptr [0x2d16]
  062AD3  0E33: 888472a3         mov byte ptr [si - 0x5c8e], al
  062AD7  0E37: 889c72a4         mov byte ptr [si - 0x5b8e], bl
  062ADB  0E3B: 8bc6             mov ax, si
  062ADD  0E3D: fec0             inc al
  062ADF  0E3F: 2ae4             sub ah, ah
  062AE1  0E41: a3162d           mov word ptr [0x2d16], ax
  062AE4  0E44: ff46a4           inc word ptr [bp - 0x5c]
  062AE7  0E47: 837ea408         cmp word ptr [bp - 0x5c], 8
  062AEB  0E4B: 7ca6             jl 0xdf3
  062AED  0E4D: 837efc00         cmp word ptr [bp - 4], 0
  062AF1  0E51: 750c             jne 0xe5f
  062AF3  0E53: a1182d           mov ax, word ptr [0x2d18]
  062AF6  0E56: 3906162d         cmp word ptr [0x2d16], ax
  062AFA  0E5A: 7403             je 0xe5f
  062AFC  0E5C: e91aff           jmp 0xd79
  062AFF  0E5F: c746a00000       mov word ptr [bp - 0x60], 0
  062B04  0E64: 837efc00         cmp word ptr [bp - 4], 0
  062B08  0E68: 7503             jne 0xe6d
  062B0A  0E6A: e91801           jmp 0xf85
  062B0D  0E6D: c7468a6300       mov word ptr [bp - 0x76], 0x63
  062B12  0E72: c7469effff       mov word ptr [bp - 0x62], 0xffff
  062B17  0E77: 837e9800         cmp word ptr [bp - 0x68], 0
  062B1B  0E7B: 740d             je 0xe8a
  062B1D  0E7D: 6b768012         imul si, word ptr [bp - 0x80], 0x12
  062B21  0E81: 8b5e82           mov bx, word ptr [bp - 0x7e]
  062B24  0E84: 8a80f686         mov al, byte ptr [bx + si - 0x790a]
  062B28  0E88: eb0b             jmp 0xe95
  062B2A  0E8A: 6b768012         imul si, word ptr [bp - 0x80], 0x12
  062B2E  0E8E: 8b5e82           mov bx, word ptr [bp - 0x7e]
  062B31  0E91: 8a80e885         mov al, byte ptr [bx + si - 0x7a18]
  062B35  0E95: 2ae4             sub ah, ah
  062B37  0E97: 894690           mov word ptr [bp - 0x70], ax
  062B3A  0E9A: c746a40000       mov word ptr [bp - 0x5c], 0
  062B3F  0E9F: eb39             jmp 0xeda
  062B41  0EA1: 90               nop 
  062B42  0EA2: 8b468a           mov ax, word ptr [bp - 0x76]
  062B45  0EA5: 3bc8             cmp cx, ax
  062B47  0EA7: 752e             jne 0xed7
  062B49  0EA9: 8bc3             mov ax, bx
  062B4B  0EAB: c1e002           shl ax, 2
  062B4E  0EAE: 40               inc ax
  062B4F  0EAF: 50               push ax
  062B50  0EB0: 8b46fe           mov ax, word ptr [bp - 2]
  062B53  0EB3: c1e002           shl ax, 2
  062B56  0EB6: 40               inc ax
  062B57  0EB7: 50               push ax
  062B58  0EB8: ff7606           push word ptr [bp + 6]
  062B5B  0EBB: ff7684           push word ptr [bp - 0x7c]
  062B5E  0EBE: 9a7a031f18       lcall 0x181f, 0x37a
  062B63  0EC3: 83c408           add sp, 8
  062B66  0EC6: 89468c           mov word ptr [bp - 0x74], ax
  062B69  0EC9: 3b46a8           cmp ax, word ptr [bp - 0x58]
  062B6C  0ECC: 7d09             jge 0xed7
  062B6E  0ECE: 8b4ea4           mov cx, word ptr [bp - 0x5c]
  062B71  0ED1: 894e9e           mov word ptr [bp - 0x62], cx
  062B74  0ED4: 8946a8           mov word ptr [bp - 0x58], ax
  062B77  0ED7: ff46a4           inc word ptr [bp - 0x5c]
  062B7A  0EDA: 837ea408         cmp word ptr [bp - 0x5c], 8
  062B7E  0EDE: 7d62             jge 0xf42
  062B80  0EE0: 8a4ea4           mov cl, byte ptr [bp - 0x5c]
  062B83  0EE3: b80100           mov ax, 1
  062B86  0EE6: d3e0             shl ax, cl
  062B88  0EE8: 854690           test word ptr [bp - 0x70], ax
  062B8B  0EEB: 74ea             je 0xed7
  062B8D  0EED: 8b5ea4           mov bx, word ptr [bp - 0x5c]
  062B90  0EF0: 8a87be00         mov al, byte ptr [bx + 0xbe]
  062B94  0EF4: 98               cwde 
  062B95  0EF5: 034682           add ax, word ptr [bp - 0x7e]
  062B98  0EF8: 8946aa           mov word ptr [bp - 0x56], ax
  062B9B  0EFB: 8a87b400         mov al, byte ptr [bx + 0xb4]
  062B9F  0EFF: 98               cwde 
  062BA0  0F00: 034680           add ax, word ptr [bp - 0x80]
  062BA3  0F03: 8946fe           mov word ptr [bp - 2], ax
  062BA6  0F06: 6bf012           imul si, ax, 0x12
  062BA9  0F09: 8b5eaa           mov bx, word ptr [bp - 0x56]
  062BAC  0F0C: 8a8862a1         mov cl, byte ptr [bx + si - 0x5e9e]
  062BB0  0F10: 2aed             sub ch, ch
  062BB2  0F12: 894e96           mov word ptr [bp - 0x6a], cx
  062BB5  0F15: 0bc9             or cx, cx
  062BB7  0F17: 74be             je 0xed7
  062BB9  0F19: 3b4e8a           cmp cx, word ptr [bp - 0x76]
  062BBC  0F1C: 7d84             jge 0xea2
  062BBE  0F1E: 894e8a           mov word ptr [bp - 0x76], cx
  062BC1  0F21: 8b4ea4           mov cx, word ptr [bp - 0x5c]
  062BC4  0F24: 894e9e           mov word ptr [bp - 0x62], cx
  062BC7  0F27: c1e302           shl bx, 2
  062BCA  0F2A: 43               inc bx
  062BCB  0F2B: 53               push bx
  062BCC  0F2C: c1e002           shl ax, 2
  062BCF  0F2F: 40               inc ax
  062BD0  0F30: 50               push ax
  062BD1  0F31: ff7606           push word ptr [bp + 6]
  062BD4  0F34: ff7684           push word ptr [bp - 0x7c]
  062BD7  0F37: 9a7a031f18       lcall 0x181f, 0x37a
  062BDC  0F3C: 83c408           add sp, 8
  062BDF  0F3F: eb93             jmp 0xed4
  062BE1  0F41: 90               nop 
  062BE2  0F42: 837e9e00         cmp word ptr [bp - 0x62], 0
  062BE6  0F46: 7c3d             jl 0xf85
  062BE8  0F48: 8b5e9e           mov bx, word ptr [bp - 0x62]
  062BEB  0F4B: 8a87be00         mov al, byte ptr [bx + 0xbe]
  062BEF  0F4F: 98               cwde 
  062BF0  0F50: 034682           add ax, word ptr [bp - 0x7e]
  062BF3  0F53: c1e002           shl ax, 2
  062BF6  0F56: 40               inc ax
  062BF7  0F57: 8946a2           mov word ptr [bp - 0x5e], ax
  062BFA  0F5A: 8bc8             mov cx, ax
  062BFC  0F5C: 8a87b400         mov al, byte ptr [bx + 0xb4]
  062C00  0F60: 98               cwde 
  062C01  0F61: 034680           add ax, word ptr [bp - 0x80]
  062C04  0F64: c1e002           shl ax, 2
  062C07  0F67: 40               inc ax
  062C08  0F68: 8946a6           mov word ptr [bp - 0x5a], ax
  062C0B  0F6B: 894692           mov word ptr [bp - 0x6e], ax
  062C0E  0F6E: 894e8e           mov word ptr [bp - 0x72], cx
  062C11  0F71: c746a00100       mov word ptr [bp - 0x60], 1
  062C16  0F76: 8d56a2           lea dx, [bp - 0x5e]
  062C19  0F79: 52               push dx
  062C1A  0F7A: ff7698           push word ptr [bp - 0x68]
  062C1D  0F7D: 8bd1             mov dx, cx
  062C1F  0F7F: 8d5ea6           lea bx, [bp - 0x5a]
  062C22  0F82: e8ebf1           call 0x170
  062C25  0F85: 837ea000         cmp word ptr [bp - 0x60], 0
  062C29  0F89: 740b             je 0xf96
  062C2B  0F8B: 8b46a6           mov ax, word ptr [bp - 0x5a]
  062C2E  0F8E: a34ea1           mov word ptr [0xa14e], ax
  062C31  0F91: 8b46a2           mov ax, word ptr [bp - 0x5e]
  062C34  0F94: eb09             jmp 0xf9f
  062C36  0F96: 8b4684           mov ax, word ptr [bp - 0x7c]
  062C39  0F99: a34ea1           mov word ptr [0xa14e], ax
  062C3C  0F9C: 8b4606           mov ax, word ptr [bp + 6]
  062C3F  0F9F: a34ca1           mov word ptr [0xa14c], ax
  062C42  0FA2: 837e9400         cmp word ptr [bp - 0x6c], 0
  062C46  0FA6: 7503             jne 0xfab
  062C48  0FA8: e92401           jmp 0x10cf
  062C4B  0FAB: 8b4680           mov ax, word ptr [bp - 0x80]
  062C4E  0FAE: a37c01           mov word ptr [0x17c], ax
  062C51  0FB1: 8b4682           mov ax, word ptr [bp - 0x7e]
  062C54  0FB4: a37e01           mov word ptr [0x17e], ax
  062C57  0FB7: 6a01             push 1
  062C59  0FB9: 9a1c0e1f18       lcall 0x181f, 0xe1c
  062C5E  0FBE: 83c402           add sp, 2
  062C61  0FC1: c7469a0000       mov word ptr [bp - 0x66], 0
  062C66  0FC6: eb3b             jmp 0x1003
  062C68  0FC8: ff469c           inc word ptr [bp - 0x64]
  062C6B  0FCB: 837e9c0f         cmp word ptr [bp - 0x64], 0xf
  062C6F  0FCF: 7d2f             jge 0x1000
  062C71  0FD1: 6b769c12         imul si, word ptr [bp - 0x64], 0x12
  062C75  0FD5: 8b5e9a           mov bx, word ptr [bp - 0x66]
  062C78  0FD8: 80b862a100       cmp byte ptr [bx + si - 0x5e9e], 0
  062C7D  0FDD: 74e9             je 0xfc8
  062C7F  0FDF: 6a0f             push 0xf
  062C81  0FE1: 8a8062a1         mov al, byte ptr [bx + si - 0x5e9e]
  062C85  0FE5: 2ae4             sub ah, ah
  062C87  0FE7: 50               push ax
  062C88  0FE8: c1e302           shl bx, 2
  062C8B  0FEB: 43               inc bx
  062C8C  0FEC: 53               push bx
  062C8D  0FED: 8b469c           mov ax, word ptr [bp - 0x64]
  062C90  0FF0: c1e002           shl ax, 2
  062C93  0FF3: 40               inc ax
  062C94  0FF4: 50               push ax
  062C95  0FF5: 9a2c011f19       lcall 0x191f, 0x12c
  062C9A  0FFA: 83c408           add sp, 8
  062C9D  0FFD: ebc9             jmp 0xfc8
  062C9F  0FFF: 90               nop 
  062CA0  1000: ff469a           inc word ptr [bp - 0x66]
  062CA3  1003: 837e9a12         cmp word ptr [bp - 0x66], 0x12
  062CA7  1007: 7d07             jge 0x1010
  062CA9  1009: c7469c0000       mov word ptr [bp - 0x64], 0
  062CAE  100E: ebbb             jmp 0xfcb
  062CB0  1010: 8b4682           mov ax, word ptr [bp - 0x7e]
  062CB3  1013: c1e002           shl ax, 2
  062CB6  1016: 50               push ax
  062CB7  1017: 8b4680           mov ax, word ptr [bp - 0x80]
  062CBA  101A: c1e002           shl ax, 2
  062CBD  101D: 50               push ax
  062CBE  101E: ff768e           push word ptr [bp - 0x72]
  062CC1  1021: ff7692           push word ptr [bp - 0x6e]
  062CC4  1024: ff76a2           push word ptr [bp - 0x5e]
  062CC7  1027: ff76a6           push word ptr [bp - 0x5a]
  062CCA  102A: 8b5e9e           mov bx, word ptr [bp - 0x62]
  062CCD  102D: 8a87be00         mov al, byte ptr [bx + 0xbe]
  062CD1  1031: 98               cwde 
  062CD2  1032: 50               push ax
  062CD3  1033: 8a87b400         mov al, byte ptr [bx + 0xb4]
  062CD7  1037: 98               cwde 
  062CD8  1038: 50               push ax
  062CD9  1039: 53               push bx
  062CDA  103A: 68f61d           push 0x1df6
  062CDD  103D: 8d46ac           lea ax, [bp - 0x54]
  062CE0  1040: 50               push ax
  062CE1  1041: 9a480b1d0d       lcall 0xd1d, 0xb48
  062CE6  1046: 83c416           add sp, 0x16
  062CE9  1049: 6a0c             push 0xc
  062CEB  104B: b8ffff           mov ax, 0xffff
  062CEE  104E: ba0c00           mov dx, 0xc
  062CF1  1051: 8bda             mov bx, dx
  062CF3  1053: 9af0011f18       lcall 0x181f, 0x1f0
  062CF8  1058: ff36a008         push word ptr [0x8a0]
  062CFC  105C: ff369e08         push word ptr [0x89e]
  062D00  1060: 8d46ac           lea ax, [bp - 0x54]
  062D03  1063: 16               push ss
  062D04  1064: 50               push ax
  062D05  1065: 6a00             push 0
  062D07  1067: 8d1eca1d         lea bx, [0x1dca]
  062D0B  106B: b80500           mov ax, 5
  062D0E  106E: babe00           mov dx, 0xbe
  062D11  1071: 9afa011f18       lcall 0x181f, 0x1fa
  062D16  1076: 9ae0031f18       lcall 0x181f, 0x3e0
  062D1B  107B: 894688           mov word ptr [bp - 0x78], ax
  062D1E  107E: 50               push ax
  062D1F  107F: 9a2c091d0d       lcall 0xd1d, 0x92c
  062D24  1084: 83c402           add sp, 2
  062D27  1087: 894688           mov word ptr [bp - 0x78], ax
  062D2A  108A: eb2a             jmp 0x10b6
  062D2C  108C: a18401           mov ax, word ptr [0x184]
  062D2F  108F: 48               dec ax
  062D30  1090: 7902             jns 0x1094
  062D32  1092: 2bc0             sub ax, ax
  062D34  1094: a38401           mov word ptr [0x184], ax
  062D37  1097: e911ff           jmp 0xfab
  062D3A  109A: a18401           mov ax, word ptr [0x184]
  062D3D  109D: 40               inc ax
  062D3E  109E: 3d0300           cmp ax, 3
  062D41  10A1: 7ef1             jle 0x1094
  062D43  10A3: b80300           mov ax, 3
  062D46  10A6: ebec             jmp 0x1094
  062D48  10A8: 2bc0             sub ax, ax
  062D4A  10AA: 894694           mov word ptr [bp - 0x6c], ax
  062D4D  10AD: a3f21d           mov word ptr [0x1df2], ax
  062D50  10B0: a3f41d           mov word ptr [0x1df4], ax
  062D53  10B3: eb10             jmp 0x10c5
  062D55  10B5: 90               nop 
  062D56  10B6: 3d5a00           cmp ax, 0x5a
  062D59  10B9: 74d1             je 0x108c
  062D5B  10BB: 7708             ja 0x10c5
  062D5D  10BD: 2c1b             sub al, 0x1b
  062D5F  10BF: 74e7             je 0x10a8
  062D61  10C1: 2c3d             sub al, 0x3d
  062D63  10C3: 74d5             je 0x109a
  062D65  10C5: 6a01             push 1
  062D67  10C7: 9a1c0e1f18       lcall 0x181f, 0xe1c
  062D6C  10CC: 83c402           add sp, 2
  062D6F  10CF: 837e9400         cmp word ptr [bp - 0x6c], 0
  062D73  10D3: 7406             je 0x10db
  062D75  10D5: c706f21d0100     mov word ptr [0x1df2], 1
  062D7B  10DB: 8b46fc           mov ax, word ptr [bp - 4]
  062D7E  10DE: 5e               pop si
  062D7F  10DF: c9               leave 
  062D80  10E0: ca0200           retf 2

; ---- func_062D84  size=1618  insns=561  prologue=ENTER 0x0046,0  terminal=page-end ----
  062D84  10E4: c8460000         enter 0x46, 0
  062D88  10E8: 50               push ax
  062D89  10E9: 56               push si
  062D8A  10EA: c746e6ffff       mov word ptr [bp - 0x1a], 0xffff
  062D8F  10EF: c746d00000       mov word ptr [bp - 0x30], 0
  062D94  10F4: f606940840       test byte ptr [0x894], 0x40
  062D99  10F9: 741b             je 0x1116
  062D9B  10FB: 833ea25300       cmp word ptr [0x53a2], 0
  062DA0  1100: 750f             jne 0x1111
  062DA2  1102: 6bd81c           imul bx, ax, 0x1c
  062DA5  1105: 8a874731         mov al, byte ptr [bx + 0x3147]
  062DA9  1109: 240f             and al, 0xf
  062DAB  110B: 3a069653         cmp al, byte ptr [0x5396]
  062DAF  110F: 7505             jne 0x1116
  062DB1  1111: c746d00100       mov word ptr [bp - 0x30], 1
  062DB6  1116: 6b5eb81c         imul bx, word ptr [bp - 0x48], 0x1c
  062DBA  111A: 8a874d31         mov al, byte ptr [bx + 0x314d]
  062DBE  111E: 2ae4             sub ah, ah
  062DC0  1120: 8946e8           mov word ptr [bp - 0x18], ax
  062DC3  1123: 8a874e31         mov al, byte ptr [bx + 0x314e]
  062DC7  1127: 8946e2           mov word ptr [bp - 0x1e], ax
  062DCA  112A: 8a874431         mov al, byte ptr [bx + 0x3144]
  062DCE  112E: 8946ca           mov word ptr [bp - 0x36], ax
  062DD1  1131: 8a874531         mov al, byte ptr [bx + 0x3145]
  062DD5  1135: 8946c2           mov word ptr [bp - 0x3e], ax
  062DD8  1138: 8a874631         mov al, byte ptr [bx + 0x3146]
  062DDC  113C: 8bc8             mov cx, ax
  062DDE  113E: a3d21d           mov word ptr [0x1dd2], ax
  062DE1  1141: 80f90d           cmp cl, 0xd
  062DE4  1144: 720c             jb 0x1152
  062DE6  1146: 80f912           cmp cl, 0x12
  062DE9  1149: 7707             ja 0x1152
  062DEB  114B: c746dc0100       mov word ptr [bp - 0x24], 1
  062DF0  1150: eb05             jmp 0x1157
  062DF2  1152: c746dc0000       mov word ptr [bp - 0x24], 0
  062DF7  1157: ff76e2           push word ptr [bp - 0x1e]
  062DFA  115A: ff76e8           push word ptr [bp - 0x18]
  062DFD  115D: 9a02031f18       lcall 0x181f, 0x302
  062E02  1162: 83c404           add sp, 4
  062E05  1165: 0bc0             or ax, ax
  062E07  1167: 7503             jne 0x116c
  062E09  1169: e99d05           jmp 0x1709
  062E0C  116C: 8b46ca           mov ax, word ptr [bp - 0x36]
  062E0F  116F: 3946e8           cmp word ptr [bp - 0x18], ax
  062E12  1172: 750b             jne 0x117f
  062E14  1174: 8b46c2           mov ax, word ptr [bp - 0x3e]
  062E17  1177: 3946e2           cmp word ptr [bp - 0x1e], ax
  062E1A  117A: 7503             jne 0x117f
  062E1C  117C: e98a05           jmp 0x1709
  062E1F  117F: 6b5eb81c         imul bx, word ptr [bp - 0x48], 0x1c
  062E23  1183: 8a874731         mov al, byte ptr [bx + 0x3147]
  062E27  1187: 250f00           and ax, 0xf
  062E2A  118A: 8946d2           mov word ptr [bp - 0x2e], ax
  062E2D  118D: 6bd834           imul bx, ax, 0x34
  062E30  1190: 80bf3f5401       cmp byte ptr [bx + 0x543f], 1
  062E35  1195: 1bc0             sbb ax, ax
  062E37  1197: f7d8             neg ax
  062E39  1199: 8946da           mov word ptr [bp - 0x26], ax
  062E3C  119C: 8b46e8           mov ax, word ptr [bp - 0x18]
  062E3F  119F: 2b46ca           sub ax, word ptr [bp - 0x36]
  062E42  11A2: 8946ce           mov word ptr [bp - 0x32], ax
  062E45  11A5: 8b4ee2           mov cx, word ptr [bp - 0x1e]
  062E48  11A8: 2b4ec2           sub cx, word ptr [bp - 0x3e]
  062E4B  11AB: 894ec8           mov word ptr [bp - 0x38], cx
  062E4E  11AE: 0bc0             or ax, ax
  062E50  11B0: 7f03             jg 0x11b5
  062E52  11B2: f7d0             not ax
  062E54  11B4: 40               inc ax
  062E55  11B5: 3d0100           cmp ax, 1
  062E58  11B8: 7f22             jg 0x11dc
  062E5A  11BA: 0bc9             or cx, cx
  062E5C  11BC: 7e04             jle 0x11c2
  062E5E  11BE: 8bc1             mov ax, cx
  062E60  11C0: eb05             jmp 0x11c7
  062E62  11C2: 8bc1             mov ax, cx
  062E64  11C4: f7d0             not ax
  062E66  11C6: 40               inc ax
  062E67  11C7: 3d0100           cmp ax, 1
  062E6A  11CA: 7f10             jg 0x11dc
  062E6C  11CC: 8b46ce           mov ax, word ptr [bp - 0x32]
  062E6F  11CF: 8bd1             mov dx, cx
  062E71  11D1: 0e               push cs
  062E72  11D2: e85205           call 0x1727
  062E75  11D5: 8946e6           mov word ptr [bp - 0x1a], ax
  062E78  11D8: e92e05           jmp 0x1709
  062E7B  11DB: 90               nop 
  062E7C  11DC: c746ea0000       mov word ptr [bp - 0x16], 0
  062E81  11E1: 8b46e8           mov ax, word ptr [bp - 0x18]
  062E84  11E4: 2b46ca           sub ax, word ptr [bp - 0x36]
  062E87  11E7: 0bc0             or ax, ax
  062E89  11E9: 7f09             jg 0x11f4
  062E8B  11EB: 8b46e8           mov ax, word ptr [bp - 0x18]
  062E8E  11EE: 2b46ca           sub ax, word ptr [bp - 0x36]
  062E91  11F1: f7d0             not ax
  062E93  11F3: 40               inc ax
  062E94  11F4: 3d0700           cmp ax, 7
  062E97  11F7: 7d58             jge 0x1251
  062E99  11F9: 8b46e2           mov ax, word ptr [bp - 0x1e]
  062E9C  11FC: 2b46c2           sub ax, word ptr [bp - 0x3e]
  062E9F  11FF: 8946ba           mov word ptr [bp - 0x46], ax
  062EA2  1202: 0bc0             or ax, ax
  062EA4  1204: 7f09             jg 0x120f
  062EA6  1206: 8b46e2           mov ax, word ptr [bp - 0x1e]
  062EA9  1209: 2b46c2           sub ax, word ptr [bp - 0x3e]
  062EAC  120C: f7d0             not ax
  062EAE  120E: 40               inc ax
  062EAF  120F: 3d0700           cmp ax, 7
  062EB2  1212: 7d3d             jge 0x1251
  062EB4  1214: 8b46e8           mov ax, word ptr [bp - 0x18]
  062EB7  1217: a34ea1           mov word ptr [0xa14e], ax
  062EBA  121A: 8b4ee2           mov cx, word ptr [bp - 0x1e]
  062EBD  121D: 890e4ca1         mov word ptr [0xa14c], cx
  062EC1  1221: 8b46ca           mov ax, word ptr [bp - 0x36]
  062EC4  1224: 8b56c2           mov dx, word ptr [bp - 0x3e]
  062EC7  1227: bbe703           mov bx, 0x3e7
  062ECA  122A: 0e               push cs
  062ECB  122B: e8fe04           call 0x172c
  062ECE  122E: 8946e6           mov word ptr [bp - 0x1a], ax
  062ED1  1231: 0bc0             or ax, ax
  062ED3  1233: 7c17             jl 0x124c
  062ED5  1235: 837ed000         cmp word ptr [bp - 0x30], 0
  062ED9  1239: 7503             jne 0x123e
  062EDB  123B: e9cb04           jmp 0x1709
  062EDE  123E: ff76e2           push word ptr [bp - 0x1e]
  062EE1  1241: ff76e8           push word ptr [bp - 0x18]
  062EE4  1244: 50               push ax
  062EE5  1245: 68281e           push 0x1e28
  062EE8  1248: e9b604           jmp 0x1701
  062EEB  124B: 90               nop 
  062EEC  124C: c746ea0100       mov word ptr [bp - 0x16], 1
  062EF1  1251: ff76e2           push word ptr [bp - 0x1e]
  062EF4  1254: 8b46ca           mov ax, word ptr [bp - 0x36]
  062EF7  1257: 8b56c2           mov dx, word ptr [bp - 0x3e]
  062EFA  125A: 8b5ee8           mov bx, word ptr [bp - 0x18]
  062EFD  125D: 0e               push cs
  062EFE  125E: e8d004           call 0x1731
  062F01  1261: 0bc0             or ax, ax
  062F03  1263: 7508             jne 0x126d
  062F05  1265: 3946ea           cmp word ptr [bp - 0x16], ax
  062F08  1268: 7403             je 0x126d
  062F0A  126A: e99a00           jmp 0x1307
  062F0D  126D: 8b46ca           mov ax, word ptr [bp - 0x36]
  062F10  1270: 8b56c2           mov dx, word ptr [bp - 0x3e]
  062F13  1273: bbe603           mov bx, 0x3e6
  062F16  1276: 0e               push cs
  062F17  1277: e8b204           call 0x172c
  062F1A  127A: 8946e6           mov word ptr [bp - 0x1a], ax
  062F1D  127D: 0bc0             or ax, ax
  062F1F  127F: 7d33             jge 0x12b4
  062F21  1281: a174a5           mov ax, word ptr [0xa574]
  062F24  1284: c1e002           shl ax, 2
  062F27  1287: 40               inc ax
  062F28  1288: a34ca1           mov word ptr [0xa14c], ax
  062F2B  128B: 684ca1           push 0xa14c
  062F2E  128E: ff76dc           push word ptr [bp - 0x24]
  062F31  1291: 8bd0             mov dx, ax
  062F33  1293: a172a5           mov ax, word ptr [0xa572]
  062F36  1296: c1e002           shl ax, 2
  062F39  1299: 40               inc ax
  062F3A  129A: a34ea1           mov word ptr [0xa14e], ax
  062F3D  129D: 8d1e4ea1         lea bx, [0xa14e]
  062F41  12A1: e8ccee           call 0x170
  062F44  12A4: 8b46ca           mov ax, word ptr [bp - 0x36]
  062F47  12A7: 8b56c2           mov dx, word ptr [bp - 0x3e]
  062F4A  12AA: bbe603           mov bx, 0x3e6
  062F4D  12AD: 0e               push cs
  062F4E  12AE: e87b04           call 0x172c
  062F51  12B1: 8946e6           mov word ptr [bp - 0x1a], ax
  062F54  12B4: 0bc0             or ax, ax
  062F56  12B6: 7c4f             jl 0x1307
  062F58  12B8: 6b5eb81c         imul bx, word ptr [bp - 0x48], 0x1c
  062F5C  12BC: 80bf493100       cmp byte ptr [bx + 0x3149], 0
  062F61  12C1: 746d             je 0x1330
  062F63  12C3: 80bf4c310b       cmp byte ptr [bx + 0x314c], 0xb
  062F68  12C8: 7566             jne 0x1330
  062F6A  12CA: 80bf4b3139       cmp byte ptr [bx + 0x314b], 0x39
  062F6F  12CF: 745f             je 0x1330
  062F71  12D1: 80bf4f3100       cmp byte ptr [bx + 0x314f], 0
  062F76  12D6: 7c58             jl 0x1330
  062F78  12D8: 8a874f31         mov al, byte ptr [bx + 0x314f]
  062F7C  12DC: 3404             xor al, 4
  062F7E  12DE: 98               cwde 
  062F7F  12DF: 3b46e6           cmp ax, word ptr [bp - 0x1a]
  062F82  12E2: 754c             jne 0x1330
  062F84  12E4: 8b46e8           mov ax, word ptr [bp - 0x18]
  062F87  12E7: a34ea1           mov word ptr [0xa14e], ax
  062F8A  12EA: 8b4ee2           mov cx, word ptr [bp - 0x1e]
  062F8D  12ED: 890e4ca1         mov word ptr [0xa14c], cx
  062F91  12F1: 837ed000         cmp word ptr [bp - 0x30], 0
  062F95  12F5: 7410             je 0x1307
  062F97  12F7: 51               push cx
  062F98  12F8: 50               push ax
  062F99  12F9: ff76e6           push word ptr [bp - 0x1a]
  062F9C  12FC: 682c1e           push 0x1e2c
  062F9F  12FF: 9a7e071f18       lcall 0x181f, 0x77e
  062FA4  1304: 83c408           add sp, 8
  062FA7  1307: 6b5eb81c         imul bx, word ptr [bp - 0x48], 0x1c
  062FAB  130B: 8a874731         mov al, byte ptr [bx + 0x3147]
  062FAF  130F: 240f             and al, 0xf
  062FB1  1311: 3c04             cmp al, 4
  062FB3  1313: 7203             jb 0x1318
  062FB5  1315: e9f103           jmp 0x1709
  062FB8  1318: a14ca1           mov ax, word ptr [0xa14c]
  062FBB  131B: 2b46c2           sub ax, word ptr [bp - 0x3e]
  062FBE  131E: 8946c8           mov word ptr [bp - 0x38], ax
  062FC1  1321: a14ea1           mov ax, word ptr [0xa14e]
  062FC4  1324: 2b46ca           sub ax, word ptr [bp - 0x36]
  062FC7  1327: 8946ce           mov word ptr [bp - 0x32], ax
  062FCA  132A: 0bc0             or ax, ax
  062FCC  132C: 7e1c             jle 0x134a
  062FCE  132E: eb1d             jmp 0x134d
  062FD0  1330: 837ed000         cmp word ptr [bp - 0x30], 0
  062FD4  1334: 7503             jne 0x1339
  062FD6  1336: e9d003           jmp 0x1709
  062FD9  1339: ff76e6           push word ptr [bp - 0x1a]
  062FDC  133C: ff364ca1         push word ptr [0xa14c]
  062FE0  1340: ff364ea1         push word ptr [0xa14e]
  062FE4  1344: 68321e           push 0x1e32
  062FE7  1347: e9b703           jmp 0x1701
  062FEA  134A: f7d0             not ax
  062FEC  134C: 40               inc ax
  062FED  134D: 8946d8           mov word ptr [bp - 0x28], ax
  062FF0  1350: 837ec800         cmp word ptr [bp - 0x38], 0
  062FF4  1354: 7e06             jle 0x135c
  062FF6  1356: 8b46c8           mov ax, word ptr [bp - 0x38]
  062FF9  1359: eb07             jmp 0x1362
  062FFB  135B: 90               nop 
  062FFC  135C: 8b46c8           mov ax, word ptr [bp - 0x38]
  062FFF  135F: f7d0             not ax
  063001  1361: 40               inc ax
  063002  1362: 8946d6           mov word ptr [bp - 0x2a], ax
  063005  1365: 3b46d8           cmp ax, word ptr [bp - 0x28]
  063008  1368: 7d03             jge 0x136d
  06300A  136A: 8b46d8           mov ax, word ptr [bp - 0x28]
  06300D  136D: 0346d6           add ax, word ptr [bp - 0x2a]
  063010  1370: 0346d8           add ax, word ptr [bp - 0x28]
  063013  1373: 8946f0           mov word ptr [bp - 0x10], ax
  063016  1376: 837ece00         cmp word ptr [bp - 0x32], 0
  06301A  137A: 756c             jne 0x13e8
  06301C  137C: 837ec800         cmp word ptr [bp - 0x38], 0
  063020  1380: 7566             jne 0x13e8
  063022  1382: 6b5eb81c         imul bx, word ptr [bp - 0x48], 0x1c
  063026  1386: c6874c3100       mov byte ptr [bx + 0x314c], 0
  06302B  138B: 837eda00         cmp word ptr [bp - 0x26], 0
  06302F  138F: 7532             jne 0x13c3
  063031  1391: 80bf46310d       cmp byte ptr [bx + 0x3146], 0xd
  063036  1396: 722b             jb 0x13c3
  063038  1398: 80bf463112       cmp byte ptr [bx + 0x3146], 0x12
  06303D  139D: 7724             ja 0x13c3
  06303F  139F: ff76b8           push word ptr [bp - 0x48]
  063042  13A2: 8bf3             mov si, bx
  063044  13A4: 9a20091f18       lcall 0x181f, 0x920
  063049  13A9: 83c402           add sp, 2
  06304C  13AC: 8a844e31         mov al, byte ptr [si + 0x314e]
  063050  13B0: 2ae4             sub ah, ah
  063052  13B2: 50               push ax
  063053  13B3: 8a844d31         mov al, byte ptr [si + 0x314d]
  063057  13B7: 50               push ax
  063058  13B8: ff76b8           push word ptr [bp - 0x48]
  06305B  13BB: 9a48091f18       lcall 0x181f, 0x948
  063060  13C0: 83c406           add sp, 6
  063063  13C3: ff76b8           push word ptr [bp - 0x48]
  063066  13C6: 9a34091f18       lcall 0x181f, 0x934
  06306B  13CB: 83c402           add sp, 2
  06306E  13CE: 837ed000         cmp word ptr [bp - 0x30], 0
  063072  13D2: 7503             jne 0x13d7
  063074  13D4: e93203           jmp 0x1709
  063077  13D7: ff76e6           push word ptr [bp - 0x1a]
  06307A  13DA: ff364ca1         push word ptr [0xa14c]
  06307E  13DE: ff364ea1         push word ptr [0xa14e]
  063082  13E2: 68371e           push 0x1e37
  063085  13E5: e91903           jmp 0x1701
  063088  13E8: c746c40f27       mov word ptr [bp - 0x3c], 0x270f
  06308D  13ED: c746e60800       mov word ptr [bp - 0x1a], 8
  063092  13F2: ff76c2           push word ptr [bp - 0x3e]
  063095  13F5: ff76ca           push word ptr [bp - 0x36]
  063098  13F8: 9a54071f18       lcall 0x181f, 0x754
  06309D  13FD: 83c404           add sp, 4
  0630A0  1400: 250a00           and ax, 0xa
  0630A3  1403: 8946ec           mov word ptr [bp - 0x14], ax
  0630A6  1406: ff76c2           push word ptr [bp - 0x3e]
  0630A9  1409: ff76ca           push word ptr [bp - 0x36]
  0630AC  140C: 9a2c071f18       lcall 0x181f, 0x72c
  0630B1  1411: 83c404           add sp, 4
  0630B4  1414: 254000           and ax, 0x40
  0630B7  1417: 8946e4           mov word ptr [bp - 0x1c], ax
  0630BA  141A: ff76d2           push word ptr [bp - 0x2e]
  0630BD  141D: ff76c2           push word ptr [bp - 0x3e]
  0630C0  1420: ff76ca           push word ptr [bp - 0x36]
  0630C3  1423: 9a52091f18       lcall 0x181f, 0x952
  0630C8  1428: 83c406           add sp, 6
  0630CB  142B: c746ee0000       mov word ptr [bp - 0x12], 0
  0630D0  1430: eb37             jmp 0x1469
  0630D2  1432: 8bc1             mov ax, cx
  0630D4  1434: f7d0             not ax
  0630D6  1436: 40               inc ax
  0630D7  1437: 8946fc           mov word ptr [bp - 4], ax
  0630DA  143A: 0bd2             or dx, dx
  0630DC  143C: 7e04             jle 0x1442
  0630DE  143E: 8bc2             mov ax, dx
  0630E0  1440: eb05             jmp 0x1447
  0630E2  1442: 8bc2             mov ax, dx
  0630E4  1444: f7d0             not ax
  0630E6  1446: 40               inc ax
  0630E7  1447: 8946f6           mov word ptr [bp - 0xa], ax
  0630EA  144A: 3b46fc           cmp ax, word ptr [bp - 4]
  0630ED  144D: 7d03             jge 0x1452
  0630EF  144F: 8b46fc           mov ax, word ptr [bp - 4]
  0630F2  1452: 0346f6           add ax, word ptr [bp - 0xa]
  0630F5  1455: 0346fc           add ax, word ptr [bp - 4]
  0630F8  1458: 8946cc           mov word ptr [bp - 0x34], ax
  0630FB  145B: 837eda00         cmp word ptr [bp - 0x26], 0
  0630FF  145F: 7441             je 0x14a2
  063101  1461: 3b46f0           cmp ax, word ptr [bp - 0x10]
  063104  1464: 7e3c             jle 0x14a2
  063106  1466: ff46ee           inc word ptr [bp - 0x12]
  063109  1469: 837eee08         cmp word ptr [bp - 0x12], 8
  06310D  146D: 7c03             jl 0x1472
  06310F  146F: e96a01           jmp 0x15dc
  063112  1472: 8b5eee           mov bx, word ptr [bp - 0x12]
  063115  1475: 8a87b400         mov al, byte ptr [bx + 0xb4]
  063119  1479: 98               cwde 
  06311A  147A: 8bc8             mov cx, ax
  06311C  147C: 0346ca           add ax, word ptr [bp - 0x36]
  06311F  147F: 8946f8           mov word ptr [bp - 8], ax
  063122  1482: 8a87be00         mov al, byte ptr [bx + 0xbe]
  063126  1486: 98               cwde 
  063127  1487: 8bd0             mov dx, ax
  063129  1489: 0346c2           add ax, word ptr [bp - 0x3e]
  06312C  148C: 8946f4           mov word ptr [bp - 0xc], ax
  06312F  148F: 2b4ece           sub cx, word ptr [bp - 0x32]
  063132  1492: f7d9             neg cx
  063134  1494: 2b56c8           sub dx, word ptr [bp - 0x38]
  063137  1497: f7da             neg dx
  063139  1499: 0bc9             or cx, cx
  06313B  149B: 7e95             jle 0x1432
  06313D  149D: 8bc1             mov ax, cx
  06313F  149F: eb96             jmp 0x1437
  063141  14A1: 90               nop 
  063142  14A2: ff76f4           push word ptr [bp - 0xc]
  063145  14A5: ff76f8           push word ptr [bp - 8]
  063148  14A8: 9a02031f18       lcall 0x181f, 0x302
  06314D  14AD: 83c404           add sp, 4
  063150  14B0: 0bc0             or ax, ax
  063152  14B2: 74b2             je 0x1466
  063154  14B4: ff76f4           push word ptr [bp - 0xc]
  063157  14B7: ff76f8           push word ptr [bp - 8]
  06315A  14BA: 9a8c071f18       lcall 0x181f, 0x78c
  06315F  14BF: 83c404           add sp, 4
  063162  14C2: 8946d4           mov word ptr [bp - 0x2c], ax
  063165  14C5: ff76f4           push word ptr [bp - 0xc]
  063168  14C8: ff76f8           push word ptr [bp - 8]
  06316B  14CB: 9ad2061f18       lcall 0x181f, 0x6d2
  063170  14D0: 83c404           add sp, 4
  063173  14D3: 0bc0             or ax, ax
  063175  14D5: 7c05             jl 0x14dc
  063177  14D7: 3b46d2           cmp ax, word ptr [bp - 0x2e]
  06317A  14DA: 7539             jne 0x1515
  06317C  14DC: 837ed419         cmp word ptr [bp - 0x2c], 0x19
  063180  14E0: 7406             je 0x14e8
  063182  14E2: 837ed41a         cmp word ptr [bp - 0x2c], 0x1a
  063186  14E6: 7508             jne 0x14f0
  063188  14E8: c746ba0100       mov word ptr [bp - 0x46], 1
  06318D  14ED: eb06             jmp 0x14f5
  06318F  14EF: 90               nop 
  063190  14F0: c746ba0000       mov word ptr [bp - 0x46], 0
  063195  14F5: 8b46ba           mov ax, word ptr [bp - 0x46]
  063198  14F8: 3946dc           cmp word ptr [bp - 0x24], ax
  06319B  14FB: 7518             jne 0x1515
  06319D  14FD: 837edc00         cmp word ptr [bp - 0x24], 0
  0631A1  1501: 743e             je 0x1541
  0631A3  1503: ff76f4           push word ptr [bp - 0xc]
  0631A6  1506: ff76f8           push word ptr [bp - 8]
  0631A9  1509: 9ab4061f18       lcall 0x181f, 0x6b4
  0631AE  150E: 83c404           add sp, 4
  0631B1  1511: fec8             dec al
  0631B3  1513: 742c             je 0x1541
  0631B5  1515: ff76f4           push word ptr [bp - 0xc]
  0631B8  1518: ff76f8           push word ptr [bp - 8]
  0631BB  151B: 9a96061f18       lcall 0x181f, 0x696
  0631C0  1520: 83c404           add sp, 4
  0631C3  1523: 3b46d2           cmp ax, word ptr [bp - 0x2e]
  0631C6  1526: 7403             je 0x152b
  0631C8  1528: e93bff           jmp 0x1466
  0631CB  152B: 8b46f8           mov ax, word ptr [bp - 8]
  0631CE  152E: 3946e8           cmp word ptr [bp - 0x18], ax
  0631D1  1531: 7403             je 0x1536
  0631D3  1533: e930ff           jmp 0x1466
  0631D6  1536: 8b46f4           mov ax, word ptr [bp - 0xc]
  0631D9  1539: 3946e2           cmp word ptr [bp - 0x1e], ax
  0631DC  153C: 7403             je 0x1541
  0631DE  153E: e925ff           jmp 0x1466
  0631E1  1541: 837eec00         cmp word ptr [bp - 0x14], 0
  0631E5  1545: 7419             je 0x1560
  0631E7  1547: ff76f4           push word ptr [bp - 0xc]
  0631EA  154A: ff76f8           push word ptr [bp - 8]
  0631ED  154D: 9a54071f18       lcall 0x181f, 0x754
  0631F2  1552: 83c404           add sp, 4
  0631F5  1555: a80a             test al, 0xa
  0631F7  1557: 7407             je 0x1560
  0631F9  1559: c746de0100       mov word ptr [bp - 0x22], 1
  0631FE  155E: eb52             jmp 0x15b2
  063200  1560: 837ee400         cmp word ptr [bp - 0x1c], 0
  063204  1564: 741a             je 0x1580
  063206  1566: ff76f4           push word ptr [bp - 0xc]
  063209  1569: ff76f8           push word ptr [bp - 8]
  06320C  156C: 9a2c071f18       lcall 0x181f, 0x72c
  063211  1571: 83c404           add sp, 4
  063214  1574: a840             test al, 0x40
  063216  1576: 7408             je 0x1580
  063218  1578: 8b46f8           mov ax, word ptr [bp - 8]
  06321B  157B: 3946ca           cmp word ptr [bp - 0x36], ax
  06321E  157E: 74d9             je 0x1559
  063220  1580: 8b46f4           mov ax, word ptr [bp - 0xc]
  063223  1583: 3946c2           cmp word ptr [bp - 0x3e], ax
  063226  1586: 74d1             je 0x1559
  063228  1588: ff76b8           push word ptr [bp - 0x48]
  06322B  158B: 9a0c091f18       lcall 0x181f, 0x90c
  063230  1590: 83c402           add sp, 2
  063233  1593: 3c01             cmp al, 1
  063235  1595: 7615             jbe 0x15ac
  063237  1597: 8b5ed4           mov bx, word ptr [bp - 0x2c]
  06323A  159A: c1e304           shl bx, 4
  06323D  159D: 8a87762f         mov al, byte ptr [bx + 0x2f76]
  063241  15A1: 2ae4             sub ah, ah
  063243  15A3: 8bc8             mov cx, ax
  063245  15A5: d1e0             shl ax, 1
  063247  15A7: 03c1             add ax, cx
  063249  15A9: eb04             jmp 0x15af
  06324B  15AB: 90               nop 
  06324C  15AC: b80300           mov ax, 3
  06324F  15AF: 8946de           mov word ptr [bp - 0x22], ax
  063252  15B2: 8b46c4           mov ax, word ptr [bp - 0x3c]
  063255  15B5: 8b4ecc           mov cx, word ptr [bp - 0x34]
  063258  15B8: c1e102           shl cx, 2
  06325B  15BB: 034ef6           add cx, word ptr [bp - 0xa]
  06325E  15BE: 034efc           add cx, word ptr [bp - 4]
  063261  15C1: 014ede           add word ptr [bp - 0x22], cx
  063264  15C4: 3946de           cmp word ptr [bp - 0x22], ax
  063267  15C7: 7c03             jl 0x15cc
  063269  15C9: e99afe           jmp 0x1466
  06326C  15CC: 8b46ee           mov ax, word ptr [bp - 0x12]
  06326F  15CF: 8946e6           mov word ptr [bp - 0x1a], ax
  063272  15D2: 8b46de           mov ax, word ptr [bp - 0x22]
  063275  15D5: 8946c4           mov word ptr [bp - 0x3c], ax
  063278  15D8: e98bfe           jmp 0x1466
  06327B  15DB: 90               nop 
  06327C  15DC: 6b5eb81c         imul bx, word ptr [bp - 0x48], 0x1c
  063280  15E0: 80bf4f3100       cmp byte ptr [bx + 0x314f], 0
  063285  15E5: 7d03             jge 0x15ea
  063287  15E7: e9d200           jmp 0x16bc
  06328A  15EA: 8a874f31         mov al, byte ptr [bx + 0x314f]
  06328E  15EE: 3404             xor al, 4
  063290  15F0: 98               cwde 
  063291  15F1: 3b46e6           cmp ax, word ptr [bp - 0x1a]
  063294  15F4: 7403             je 0x15f9
  063296  15F6: e9c300           jmp 0x16bc
  063299  15F9: c746e6ffff       mov word ptr [bp - 0x1a], 0xffff
  06329E  15FE: 80bf4c310b       cmp byte ptr [bx + 0x314c], 0xb
  0632A3  1603: 7403             je 0x1608
  0632A5  1605: e9a300           jmp 0x16ab
  0632A8  1608: 80bf4b3139       cmp byte ptr [bx + 0x314b], 0x39
  0632AD  160D: 7503             jne 0x1612
  0632AF  160F: e99900           jmp 0x16ab
  0632B2  1612: c746e00000       mov word ptr [bp - 0x20], 0
  0632B7  1617: e98800           jmp 0x16a2
  0632BA  161A: 837ee008         cmp word ptr [bp - 0x20], 8
  0632BE  161E: 7c03             jl 0x1623
  0632C0  1620: e98800           jmp 0x16ab
  0632C3  1623: 6a07             push 7
  0632C5  1625: 6a00             push 0
  0632C7  1627: 9ad4041f18       lcall 0x181f, 0x4d4
  0632CC  162C: 83c404           add sp, 4
  0632CF  162F: 8bd8             mov bx, ax
  0632D1  1631: 895ee6           mov word ptr [bp - 0x1a], bx
  0632D4  1634: 8a87b400         mov al, byte ptr [bx + 0xb4]
  0632D8  1638: 98               cwde 
  0632D9  1639: 0346ca           add ax, word ptr [bp - 0x36]
  0632DC  163C: 8946f8           mov word ptr [bp - 8], ax
  0632DF  163F: 8bc8             mov cx, ax
  0632E1  1641: 8a87be00         mov al, byte ptr [bx + 0xbe]
  0632E5  1645: 98               cwde 
  0632E6  1646: 0346c2           add ax, word ptr [bp - 0x3e]
  0632E9  1649: 8946f4           mov word ptr [bp - 0xc], ax
  0632EC  164C: 50               push ax
  0632ED  164D: 51               push cx
  0632EE  164E: 9ad2061f18       lcall 0x181f, 0x6d2
  0632F3  1653: 83c404           add sp, 4
  0632F6  1656: 0bc0             or ax, ax
  0632F8  1658: 7c05             jl 0x165f
  0632FA  165A: 3b46d2           cmp ax, word ptr [bp - 0x2e]
  0632FD  165D: 753b             jne 0x169a
  0632FF  165F: ff76f4           push word ptr [bp - 0xc]
  063302  1662: ff76f8           push word ptr [bp - 8]
  063305  1665: 9a68071f18       lcall 0x181f, 0x768
  06330A  166A: 83c404           add sp, 4
  06330D  166D: 3b46dc           cmp ax, word ptr [bp - 0x24]
  063310  1670: 7528             jne 0x169a
  063312  1672: 0bc0             or ax, ax
  063314  1674: 7412             je 0x1688
  063316  1676: ff76f4           push word ptr [bp - 0xc]
  063319  1679: ff76f8           push word ptr [bp - 8]
  06331C  167C: 9ab4061f18       lcall 0x181f, 0x6b4
  063321  1681: 83c404           add sp, 4
  063324  1684: fec8             dec al
  063326  1686: 7512             jne 0x169a
  063328  1688: ff76f4           push word ptr [bp - 0xc]
  06332B  168B: ff76f8           push word ptr [bp - 8]
  06332E  168E: 9a02031f18       lcall 0x181f, 0x302
  063333  1693: 83c404           add sp, 4
  063336  1696: 0bc0             or ax, ax
  063338  1698: 7505             jne 0x169f
  06333A  169A: c746e6ffff       mov word ptr [bp - 0x1a], 0xffff
  06333F  169F: ff46e0           inc word ptr [bp - 0x20]
  063342  16A2: 837ee600         cmp word ptr [bp - 0x1a], 0
  063346  16A6: 7d03             jge 0x16ab
  063348  16A8: e96fff           jmp 0x161a
  06334B  16AB: 837ee600         cmp word ptr [bp - 0x1a], 0
  06334F  16AF: 7d0b             jge 0x16bc
  063351  16B1: ff76b8           push word ptr [bp - 0x48]
  063354  16B4: 9a34091f18       lcall 0x181f, 0x934
  063359  16B9: 83c402           add sp, 2
  06335C  16BC: 837ed000         cmp word ptr [bp - 0x30], 0
  063360  16C0: 741a             je 0x16dc
  063362  16C2: 6a00             push 0
  063364  16C4: 6b5eb81c         imul bx, word ptr [bp - 0x48], 0x1c
  063368  16C8: 8a874f31         mov al, byte ptr [bx + 0x314f]
  06336C  16CC: 98               cwde 
  06336D  16CD: 50               push ax
  06336E  16CE: ff76e6           push word ptr [bp - 0x1a]
  063371  16D1: 683c1e           push 0x1e3c
  063374  16D4: 9a7e071f18       lcall 0x181f, 0x77e
  063379  16D9: 83c408           add sp, 8
  06337C  16DC: 837ee608         cmp word ptr [bp - 0x1a], 8
  063380  16E0: 7527             jne 0x1709
  063382  16E2: ff76b8           push word ptr [bp - 0x48]
  063385  16E5: 9a34091f18       lcall 0x181f, 0x934
  06338A  16EA: 83c402           add sp, 2
  06338D  16ED: c746e6ffff       mov word ptr [bp - 0x1a], 0xffff
  063392  16F2: 837ed000         cmp word ptr [bp - 0x30], 0
  063396  16F6: 7411             je 0x1709
  063398  16F8: 6a00             push 0
  06339A  16FA: 6a00             push 0
  06339C  16FC: 6a00             push 0
  06339E  16FE: 68401e           push 0x1e40
  0633A1  1701: 9a7e071f18       lcall 0x181f, 0x77e
  0633A6  1706: 83c408           add sp, 8
  0633A9  1709: 2bc0             sub ax, ax
  0633AB  170B: a3f21d           mov word ptr [0x1df2], ax
  0633AE  170E: a3f41d           mov word ptr [0x1df4], ax
  0633B1  1711: 8a46e6           mov al, byte ptr [bp - 0x1a]
  0633B4  1714: 6b5eb81c         imul bx, word ptr [bp - 0x48], 0x1c
  0633B8  1718: 88874f31         mov byte ptr [bx + 0x314f], al
  0633BC  171C: 8b46e6           mov ax, word ptr [bp - 0x1a]
  0633BF  171F: 5e               pop si
  0633C0  1720: c9               leave 
  0633C1  1721: cb               retf 
  0633C2  1722: ea7e021f1a       ljmp 0x1a1f:0x27e
  0633C7  1727: ea9c051f1a       ljmp 0x1a1f:0x59c
  0633CC  172C: eaf0051f1a       ljmp 0x1a1f:0x5f0
  0633D1  1731: ead0071f1a       ljmp 0x1a1f:0x7d0
