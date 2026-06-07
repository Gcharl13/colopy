; ============================================================
; VICEROY.EXE overlay page 0x1B (record 26) -- RE-SEGMENTED
; file_offset (disk image) = 0x0763D0
; code_offset (first insn) = 0x0764D0
; code_end (next reloc hdr)= 0x076D70  [resident size 138 para -> nominal_end 0x076C70; on-disk code spills past it]
; reloc_count = 51  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x0763D0)
; functions in page = 8
; ============================================================

; ---- func_0764D0  size=33  insns=8  prologue=no-frame (first byte 0xC7)  terminal=RETF ----
  0764D0  0100: c706ce230000     mov word ptr [0x23ce], 0
  0764D6  0106: a1c623           mov ax, word ptr [0x23c6]
  0764D9  0109: 8b16c823         mov dx, word ptr [0x23c8]
  0764DD  010D: a316a6           mov word ptr [0xa616], ax
  0764E0  0110: 891618a6         mov word ptr [0xa618], dx
  0764E4  0114: c706ca238038     mov word ptr [0x23ca], 0x3880
  0764EA  011A: c706cc230100     mov word ptr [0x23cc], 1
  0764F0  0120: cb               retf 

; ---- func_0764F2  size=49  insns=16  prologue=ENTER 0x0002,0  terminal=RETF ----
  0764F2  0122: c8020000         enter 2, 0
  0764F6  0126: c746fe0100       mov word ptr [bp - 2], 1
  0764FB  012B: b88038           mov ax, 0x3880
  0764FE  012E: ba0100           mov dx, 1
  076501  0131: 9a9a021f18       lcall 0x181f, 0x29a
  076506  0136: a3c623           mov word ptr [0x23c6], ax
  076509  0139: 8916c823         mov word ptr [0x23c8], dx
  07650D  013D: 8bc2             mov ax, dx
  07650F  013F: 0b06c623         or ax, word ptr [0x23c6]
  076513  0143: 7409             je 0x14e
  076515  0145: 0e               push cs
  076516  0146: e82401           call 0x26d
  076519  0149: c746fe0000       mov word ptr [bp - 2], 0
  07651E  014E: 8b46fe           mov ax, word ptr [bp - 2]
  076521  0151: c9               leave 
  076522  0152: cb               retf 

; ---- func_076524  size=111  insns=34  prologue=ENTER 0x0006,0  terminal=RETF ----
  076524  0154: c8060000         enter 6, 0
  076528  0158: 8b0e16a6         mov cx, word ptr [0xa616]
  07652C  015C: 8b1618a6         mov dx, word ptr [0xa618]
  076530  0160: 890ef623         mov word ptr [0x23f6], cx
  076534  0164: 8916f823         mov word ptr [0x23f8], dx
  076538  0168: 8b0eca23         mov cx, word ptr [0x23ca]
  07653C  016C: 8b16cc23         mov dx, word ptr [0x23cc]
  076540  0170: 890e1ea6         mov word ptr [0xa61e], cx
  076544  0174: 891620a6         mov word ptr [0xa620], dx
  076548  0178: 9a72031f1a       lcall 0x1a1f, 0x372
  07654D  017D: 8946fc           mov word ptr [bp - 4], ax
  076550  0180: 8956fe           mov word ptr [bp - 2], dx
  076553  0183: 0bd0             or dx, ax
  076555  0185: 742c             je 0x1b3
  076557  0187: a1ca23           mov ax, word ptr [0x23ca]
  07655A  018A: 8b16cc23         mov dx, word ptr [0x23cc]
  07655E  018E: 39161ca6         cmp word ptr [0xa61c], dx
  076562  0192: 7f1f             jg 0x1b3
  076564  0194: 7c06             jl 0x19c
  076566  0196: 39061aa6         cmp word ptr [0xa61a], ax
  07656A  019A: 7717             ja 0x1b3
  07656C  019C: ff06ce23         inc word ptr [0x23ce]
  076570  01A0: a11aa6           mov ax, word ptr [0xa61a]
  076573  01A3: 010616a6         add word ptr [0xa616], ax
  076577  01A7: 8b161ca6         mov dx, word ptr [0xa61c]
  07657B  01AB: 2906ca23         sub word ptr [0x23ca], ax
  07657F  01AF: 1916cc23         sbb word ptr [0x23cc], dx
  076583  01B3: 2bc0             sub ax, ax
  076585  01B5: a3f823           mov word ptr [0x23f8], ax
  076588  01B8: a3f623           mov word ptr [0x23f6], ax
  07658B  01BB: 8b46fc           mov ax, word ptr [bp - 4]
  07658E  01BE: 8b56fe           mov dx, word ptr [bp - 2]
  076591  01C1: c9               leave 
  076592  01C2: cb               retf 

; ---- func_076594  size=174  insns=58  prologue=ENTER 0x0002,0  terminal=JMP-tail ----
  076594  01C4: c8020000         enter 2, 0
  076598  01C8: c746fe0100       mov word ptr [bp - 2], 1
  07659D  01CD: 0e               push cs
  07659E  01CE: e89c00           call 0x26d
  0765A1  01D1: 8d1ed023         lea bx, [0x23d0]
  0765A5  01D5: b80040           mov ax, 0x4000
  0765A8  01D8: 0e               push cs
  0765A9  01D9: e88c00           call 0x268
  0765AC  01DC: a37401           mov word ptr [0x174], ax
  0765AF  01DF: 89167601         mov word ptr [0x176], dx
  0765B3  01E3: 8bc2             mov ax, dx
  0765B5  01E5: 0b067401         or ax, word ptr [0x174]
  0765B9  01E9: 7478             je 0x263
  0765BB  01EB: a17a01           mov ax, word ptr [0x17a]
  0765BE  01EE: 0b067801         or ax, word ptr [0x178]
  0765C2  01F2: 750a             jne 0x1fe
  0765C4  01F4: a17401           mov ax, word ptr [0x174]
  0765C7  01F7: a37801           mov word ptr [0x178], ax
  0765CA  01FA: 89167a01         mov word ptr [0x17a], dx
  0765CE  01FE: 8d1ed623         lea bx, [0x23d6]
  0765D2  0202: b80040           mov ax, 0x4000
  0765D5  0205: 0e               push cs
  0765D6  0206: e85f00           call 0x268
  0765D9  0209: a33e08           mov word ptr [0x83e], ax
  0765DC  020C: 89164008         mov word ptr [0x840], dx
  0765E0  0210: 8bc2             mov ax, dx
  0765E2  0212: 0b063e08         or ax, word ptr [0x83e]
  0765E6  0216: 744b             je 0x263
  0765E8  0218: 8d1edc23         lea bx, [0x23dc]
  0765EC  021C: b80040           mov ax, 0x4000
  0765EF  021F: 0e               push cs
  0765F0  0220: e84500           call 0x268
  0765F3  0223: a34208           mov word ptr [0x842], ax
  0765F6  0226: 89164408         mov word ptr [0x844], dx
  0765FA  022A: 8bc2             mov ax, dx
  0765FC  022C: 0b064208         or ax, word ptr [0x842]
  076600  0230: 7431             je 0x263
  076602  0232: 833ece2303       cmp word ptr [0x23ce], 3
  076607  0237: 7d25             jge 0x25e
  076609  0239: ff36cc23         push word ptr [0x23cc]
  07660D  023D: ff36ca23         push word ptr [0x23ca]
  076611  0241: ff361ca6         push word ptr [0xa61c]
  076615  0245: ff361aa6         push word ptr [0xa61a]
  076619  0249: b8aeff           mov ax, 0xffae
  07661C  024C: ba0200           mov dx, 2
  07661F  024F: bb2a00           mov bx, 0x2a
  076622  0252: 9a72071f18       lcall 0x181f, 0x772
  076627  0257: 8b46fe           mov ax, word ptr [bp - 2]
  07662A  025A: c9               leave 
  07662B  025B: cb               retf 
  07662C  025C: 90               nop 
  07662D  025D: 90               nop 
  07662E  025E: c746fe0000       mov word ptr [bp - 2], 0
  076633  0263: 8b46fe           mov ax, word ptr [bp - 2]
  076636  0266: c9               leave 
  076637  0267: cb               retf 
  076638  0268: ead00f1f19       ljmp 0x191f:0xfd0
  07663D  026D: eade0f1f19       ljmp 0x191f:0xfde

; ---- func_076642  size=1194  insns=401  prologue=ENTER 0x020E,0  terminal=RETF ----
  076642  0272: c80e0200         enter 0x20e, 0
  076646  0276: 50               push ax
  076647  0277: 53               push bx
  076648  0278: 57               push di
  076649  0279: 56               push si
  07664A  027A: 2bc0             sub ax, ax
  07664C  027C: 89469e           mov word ptr [bp - 0x62], ax
  07664F  027F: 89469c           mov word ptr [bp - 0x64], ax
  076652  0282: 8946a2           mov word ptr [bp - 0x5e], ax
  076655  0285: 8946a0           mov word ptr [bp - 0x60], ax
  076658  0288: 8986fafd         mov word ptr [bp - 0x206], ax
  07665C  028C: 8986f8fd         mov word ptr [bp - 0x208], ax
  076660  0290: 8986e6fe         mov word ptr [bp - 0x11a], ax
  076664  0294: 8986e4fe         mov word ptr [bp - 0x11c], ax
  076668  0298: c70650260d00     mov word ptr [0x2650], 0xd
  07666E  029E: 89861afe         mov word ptr [bp - 0x1e6], ax
  076672  02A2: 53               push bx
  076673  02A3: 8d46ae           lea ax, [bp - 0x52]
  076676  02A6: 50               push ax
  076677  02A7: 9ae4071d0d       lcall 0xd1d, 0x7e4
  07667C  02AC: 83c404           add sp, 4
  07667F  02AF: 6a2e             push 0x2e
  076681  02B1: 8d46ae           lea ax, [bp - 0x52]
  076684  02B4: 50               push ax
  076685  02B5: 9a560c1d0d       lcall 0xd1d, 0xc56
  07668A  02BA: 83c404           add sp, 4
  07668D  02BD: 0bc0             or ax, ax
  07668F  02BF: 750f             jne 0x2d0
  076691  02C1: 68e623           push 0x23e6
  076694  02C4: 8d46ae           lea ax, [bp - 0x52]
  076697  02C7: 50               push ax
  076698  02C8: 9aa4071d0d       lcall 0xd1d, 0x7a4
  07669D  02CD: 83c404           add sp, 4
  0766A0  02D0: 68ea23           push 0x23ea
  0766A3  02D3: 8d8604fe         lea ax, [bp - 0x1fc]
  0766A7  02D7: 50               push ax
  0766A8  02D8: 9ae4071d0d       lcall 0xd1d, 0x7e4
  0766AD  02DD: 83c404           add sp, 4
  0766B0  02E0: 8d46ae           lea ax, [bp - 0x52]
  0766B3  02E3: 898618fe         mov word ptr [bp - 0x1e8], ax
  0766B7  02E7: 50               push ax
  0766B8  02E8: 9a640d1d0d       lcall 0xd1d, 0xd64
  0766BD  02ED: 83c402           add sp, 2
  0766C0  02F0: 807eae2a         cmp byte ptr [bp - 0x52], 0x2a
  0766C4  02F4: 7507             jne 0x2fd
  0766C6  02F6: 8d46af           lea ax, [bp - 0x51]
  0766C9  02F9: 898618fe         mov word ptr [bp - 0x1e8], ax
  0766CD  02FD: 8b9e18fe         mov bx, word ptr [bp - 0x1e8]
  0766D1  0301: 803f52           cmp byte ptr [bx], 0x52
  0766D4  0304: 750b             jne 0x311
  0766D6  0306: 807f014d         cmp byte ptr [bx + 1], 0x4d
  0766DA  030A: 7505             jne 0x311
  0766DC  030C: 838618fe02       add word ptr [bp - 0x1e8], 2
  0766E1  0311: 6a06             push 6
  0766E3  0313: ffb618fe         push word ptr [bp - 0x1e8]
  0766E7  0317: 8d8604fe         lea ax, [bp - 0x1fc]
  0766EB  031B: 50               push ax
  0766EC  031C: 9a5e081d0d       lcall 0xd1d, 0x85e
  0766F1  0321: 83c406           add sp, 6
  0766F4  0324: 8d861afe         lea ax, [bp - 0x1e6]
  0766F8  0328: 16               push ss
  0766F9  0329: 50               push ax
  0766FA  032A: 8d46ae           lea ax, [bp - 0x52]
  0766FD  032D: 16               push ss
  0766FE  032E: 50               push ax
  0766FF  032F: 8d1eed23         lea bx, [0x23ed]
  076703  0333: b80100           mov ax, 1
  076706  0336: 9a9e0e1f1a       lcall 0x1a1f, 0xe9e
  07670B  033B: 0bc0             or ax, ax
  07670D  033D: 7409             je 0x348
  07670F  033F: c706f023ffff     mov word ptr [0x23f0], 0xffff
  076715  0345: e96103           jmp 0x6a9
  076718  0348: c706f023feff     mov word ptr [0x23f0], 0xfffe
  07671E  034E: c786f2fd9800     mov word ptr [bp - 0x20e], 0x98
  076724  0354: 8d86ecfe         lea ax, [bp - 0x114]
  076728  0358: 16               push ss
  076729  0359: 50               push ax
  07672A  035A: 6a00             push 0
  07672C  035C: 6a01             push 1
  07672E  035E: 8d861afe         lea ax, [bp - 0x1e6]
  076732  0362: 16               push ss
  076733  0363: 50               push ax
  076734  0364: b89800           mov ax, 0x98
  076737  0367: 99               cdq 
  076738  0368: 9a820e1f1a       lcall 0x1a1f, 0xe82
  07673D  036D: 0bd0             or dx, ax
  07673F  036F: 7503             jne 0x374
  076741  0371: e93503           jmp 0x6a9
  076744  0374: 8b8612ff         mov ax, word ptr [bp - 0xee]
  076748  0378: c1e004           shl ax, 4
  07674B  037B: 8946fe           mov word ptr [bp - 2], ax
  07674E  037E: 8b8612ff         mov ax, word ptr [bp - 0xee]
  076752  0382: 8bc8             mov cx, ax
  076754  0384: d1e0             shl ax, 1
  076756  0386: 03c1             add ax, cx
  076758  0388: c1e002           shl ax, 2
  07675B  038B: 054200           add ax, 0x42
  07675E  038E: 99               cdq 
  07675F  038F: 8986e8fe         mov word ptr [bp - 0x118], ax
  076763  0393: 8996eafe         mov word ptr [bp - 0x116], dx
  076767  0397: 894698           mov word ptr [bp - 0x68], ax
  07676A  039A: 89569a           mov word ptr [bp - 0x66], dx
  07676D  039D: 8986f4fd         mov word ptr [bp - 0x20c], ax
  076771  03A1: 8996f6fd         mov word ptr [bp - 0x20a], dx
  076775  03A5: f686f0fd02       test byte ptr [bp - 0x210], 2
  07677A  03AA: 7515             jne 0x3c1
  07677C  03AC: 80beecfe00       cmp byte ptr [bp - 0x114], 0
  076781  03B1: 750e             jne 0x3c1
  076783  03B3: 034680           add ax, word ptr [bp - 0x80]
  076786  03B6: 135682           adc dx, word ptr [bp - 0x7e]
  076789  03B9: 8986f4fd         mov word ptr [bp - 0x20c], ax
  07678D  03BD: 8996f6fd         mov word ptr [bp - 0x20a], dx
  076791  03C1: a1f823           mov ax, word ptr [0x23f8]
  076794  03C4: 0b06f623         or ax, word ptr [0x23f6]
  076798  03C8: 7422             je 0x3ec
  07679A  03CA: a11ea6           mov ax, word ptr [0xa61e]
  07679D  03CD: 8b1620a6         mov dx, word ptr [0xa620]
  0767A1  03D1: 3996f6fd         cmp word ptr [bp - 0x20a], dx
  0767A5  03D5: 7f15             jg 0x3ec
  0767A7  03D7: 7c06             jl 0x3df
  0767A9  03D9: 3986f4fd         cmp word ptr [bp - 0x20c], ax
  0767AD  03DD: 770d             ja 0x3ec
  0767AF  03DF: a1f623           mov ax, word ptr [0x23f6]
  0767B2  03E2: 8b16f823         mov dx, word ptr [0x23f8]
  0767B6  03E6: 8946a0           mov word ptr [bp - 0x60], ax
  0767B9  03E9: 8956a2           mov word ptr [bp - 0x5e], dx
  0767BC  03EC: 8b86f4fd         mov ax, word ptr [bp - 0x20c]
  0767C0  03F0: 8b96f6fd         mov dx, word ptr [bp - 0x20a]
  0767C4  03F4: a31aa6           mov word ptr [0xa61a], ax
  0767C7  03F7: 89161ca6         mov word ptr [0xa61c], dx
  0767CB  03FB: 8b4ea2           mov cx, word ptr [bp - 0x5e]
  0767CE  03FE: 0b4ea0           or cx, word ptr [bp - 0x60]
  0767D1  0401: 7511             jne 0x414
  0767D3  0403: 8d8e04fe         lea cx, [bp - 0x1fc]
  0767D7  0407: 16               push ss
  0767D8  0408: 51               push cx
  0767D9  0409: 9a900e1f1a       lcall 0x1a1f, 0xe90
  0767DE  040E: 8946a0           mov word ptr [bp - 0x60], ax
  0767E1  0411: 8956a2           mov word ptr [bp - 0x5e], dx
  0767E4  0414: 8b46a2           mov ax, word ptr [bp - 0x5e]
  0767E7  0417: 0b46a0           or ax, word ptr [bp - 0x60]
  0767EA  041A: 750a             jne 0x426
  0767EC  041C: c706f023fcff     mov word ptr [0x23f0], 0xfffc
  0767F2  0422: e98402           jmp 0x6a9
  0767F5  0425: 90               nop 
  0767F6  0426: 8b46fe           mov ax, word ptr [bp - 2]
  0767F9  0429: 99               cdq 
  0767FA  042A: 9a9a021f18       lcall 0x181f, 0x29a
  0767FF  042F: 89469c           mov word ptr [bp - 0x64], ax
  076802  0432: 89569e           mov word ptr [bp - 0x62], dx
  076805  0435: 0bd0             or dx, ax
  076807  0437: 74e3             je 0x41c
  076809  0439: c45ea0           les bx, ptr [bp - 0x60]
  07680C  043C: 2bc0             sub ax, ax
  07680E  043E: 26894740         mov word ptr es:[bx + 0x40], ax
  076812  0442: 2689473e         mov word ptr es:[bx + 0x3e], ax
  076816  0446: 26894738         mov word ptr es:[bx + 0x38], ax
  07681A  044A: 26894736         mov word ptr es:[bx + 0x36], ax
  07681E  044E: 26894730         mov word ptr es:[bx + 0x30], ax
  076822  0452: 2689472e         mov word ptr es:[bx + 0x2e], ax
  076826  0456: 26894734         mov word ptr es:[bx + 0x34], ax
  07682A  045A: 26894732         mov word ptr es:[bx + 0x32], ax
  07682E  045E: 2689473c         mov word ptr es:[bx + 0x3c], ax
  076832  0462: 2689473a         mov word ptr es:[bx + 0x3a], ax
  076836  0466: ff769e           push word ptr [bp - 0x62]
  076839  0469: ff769c           push word ptr [bp - 0x64]
  07683C  046C: 50               push ax
  07683D  046D: 6a01             push 1
  07683F  046F: 8d861afe         lea ax, [bp - 0x1e6]
  076843  0473: 16               push ss
  076844  0474: 50               push ax
  076845  0475: 8b46fe           mov ax, word ptr [bp - 2]
  076848  0478: 99               cdq 
  076849  0479: 9a820e1f1a       lcall 0x1a1f, 0xe82
  07684E  047E: 0bd0             or dx, ax
  076850  0480: 750a             jne 0x48c
  076852  0482: c706f023feff     mov word ptr [0x23f0], 0xfffe
  076858  0488: e91e02           jmp 0x6a9
  07685B  048B: 90               nop 
  07685C  048C: 83bef8fe00       cmp word ptr [bp - 0x108], 0
  076861  0491: 7519             jne 0x4ac
  076863  0493: 6a00             push 0
  076865  0495: 6a00             push 0
  076867  0497: 6a00             push 0
  076869  0499: 6a00             push 0
  07686B  049B: b8f9ff           mov ax, 0xfff9
  07686E  049E: ba0200           mov dx, 2
  076871  04A1: bb0d00           mov bx, 0xd
  076874  04A4: 9a72071f18       lcall 0x181f, 0x772
  076879  04A9: e9fd01           jmp 0x6a9
  07687C  04AC: 8bbe32fe         mov di, word ptr [bp - 0x1ce]
  076880  04B0: 8bc7             mov ax, di
  076882  04B2: c1e702           shl di, 2
  076885  04B5: 03f8             add di, ax
  076887  04B7: d1e7             shl di, 1
  076889  04B9: 8b8346fe         mov ax, word ptr [bp + di - 0x1ba]
  07688D  04BD: 8b9348fe         mov dx, word ptr [bp + di - 0x1b8]
  076891  04C1: 8986fcfd         mov word ptr [bp - 0x204], ax
  076895  04C5: 8996fefd         mov word ptr [bp - 0x202], dx
  076899  04C9: a1f423           mov ax, word ptr [0x23f4]
  07689C  04CC: 0b06f223         or ax, word ptr [0x23f2]
  0768A0  04D0: 7432             je 0x504
  0768A2  04D2: a1f223           mov ax, word ptr [0x23f2]
  0768A5  04D5: 8b16f423         mov dx, word ptr [0x23f4]
  0768A9  04D9: 8946a4           mov word ptr [bp - 0x5c], ax
  0768AC  04DC: 8956a6           mov word ptr [bp - 0x5a], dx
  0768AF  04DF: 2bc9             sub cx, cx
  0768B1  04E1: 898ee6fe         mov word ptr [bp - 0x11a], cx
  0768B5  04E5: 898ee4fe         mov word ptr [bp - 0x11c], cx
  0768B9  04E9: 52               push dx
  0768BA  04EA: 50               push ax
  0768BB  04EB: 51               push cx
  0768BC  04EC: 6a01             push 1
  0768BE  04EE: 8d861afe         lea ax, [bp - 0x1e6]
  0768C2  04F2: 16               push ss
  0768C3  04F3: 50               push ax
  0768C4  04F4: b80003           mov ax, 0x300
  0768C7  04F7: 99               cdq 
  0768C8  04F8: 9a820e1f1a       lcall 0x1a1f, 0xe82
  0768CD  04FD: 0bd0             or dx, ax
  0768CF  04FF: 7545             jne 0x546
  0768D1  0501: e9a501           jmp 0x6a9
  0768D4  0504: 8d46a8           lea ax, [bp - 0x58]
  0768D7  0507: 50               push ax
  0768D8  0508: ffb620fe         push word ptr [bp - 0x1e0]
  0768DC  050C: 9aa2091d0d       lcall 0xd1d, 0x9a2
  0768E1  0511: 83c404           add sp, 4
  0768E4  0514: 6a00             push 0
  0768E6  0516: 8bbe32fe         mov di, word ptr [bp - 0x1ce]
  0768EA  051A: ff8632fe         inc word ptr [bp - 0x1ce]
  0768EE  051E: 897eac           mov word ptr [bp - 0x54], di
  0768F1  0521: 8bc7             mov ax, di
  0768F3  0523: c1e702           shl di, 2
  0768F6  0526: 03f8             add di, ax
  0768F8  0528: d1e7             shl di, 1
  0768FA  052A: 8b834afe         mov ax, word ptr [bp + di - 0x1b6]
  0768FE  052E: 8b934cfe         mov dx, word ptr [bp + di - 0x1b4]
  076902  0532: 0346a8           add ax, word ptr [bp - 0x58]
  076905  0535: 1356aa           adc dx, word ptr [bp - 0x56]
  076908  0538: 52               push dx
  076909  0539: 50               push ax
  07690A  053A: ffb620fe         push word ptr [bp - 0x1e0]
  07690E  053E: 9a3e0a1d0d       lcall 0xd1d, 0xa3e
  076913  0543: 83c408           add sp, 8
  076916  0546: 8a86ecfe         mov al, byte ptr [bp - 0x114]
  07691A  054A: c45ea0           les bx, ptr [bp - 0x60]
  07691D  054D: 2688472c         mov byte ptr es:[bx + 0x2c], al
  076921  0551: 83beeefe00       cmp word ptr [bp - 0x112], 0
  076926  0556: 740e             je 0x566
  076928  0558: 83bef0fe04       cmp word ptr [bp - 0x110], 4
  07692D  055D: 7d07             jge 0x566
  07692F  055F: 26c7070100       mov word ptr es:[bx], 1
  076934  0564: eb08             jmp 0x56e
  076936  0566: c45ea0           les bx, ptr [bp - 0x60]
  076939  0569: 26c7070000       mov word ptr es:[bx], 0
  07693E  056E: 8b86f0fe         mov ax, word ptr [bp - 0x110]
  076942  0572: c45ea0           les bx, ptr [bp - 0x60]
  076945  0575: 26894702         mov word ptr es:[bx + 2], ax
  076949  0579: 8b8612ff         mov ax, word ptr [bp - 0xee]
  07694D  057D: 26894704         mov word ptr es:[bx + 4], ax
  076951  0581: 8b867cff         mov ax, word ptr [bp - 0x84]
  076955  0585: 26894728         mov word ptr es:[bx + 0x28], ax
  076959  0589: 8b867eff         mov ax, word ptr [bp - 0x82]
  07695D  058D: 2689472a         mov word ptr es:[bx + 0x2a], ax
  076961  0591: 2bf6             sub si, si
  076963  0593: 8e46a2           mov es, word ptr [bp - 0x5e]
  076966  0596: 8bfe             mov di, si
  076968  0598: d1e7             shl di, 1
  07696A  059A: 8b83f2fe         mov ax, word ptr [bp + di - 0x10e]
  07696E  059E: 8b5ea0           mov bx, word ptr [bp - 0x60]
  076971  05A1: 26894108         mov word ptr es:[bx + di + 8], ax
  076975  05A5: 46               inc si
  076976  05A6: 83fe10           cmp si, 0x10
  076979  05A9: 7ceb             jl 0x596
  07697B  05AB: 8b86e8fe         mov ax, word ptr [bp - 0x118]
  07697F  05AF: 0346a0           add ax, word ptr [bp - 0x60]
  076982  05B2: 8b56a2           mov dx, word ptr [bp - 0x5e]
  076985  05B5: 52               push dx
  076986  05B6: 50               push ax
  076987  05B7: 9a780e1f1a       lcall 0x1a1f, 0xe78
  07698C  05BC: 898600fe         mov word ptr [bp - 0x200], ax
  076990  05C0: 899602fe         mov word ptr [bp - 0x1fe], dx
  076994  05C4: 894694           mov word ptr [bp - 0x6c], ax
  076997  05C7: 895696           mov word ptr [bp - 0x6a], dx
  07699A  05CA: 2bf6             sub si, si
  07699C  05CC: eb17             jmp 0x5e5
  07699E  05CE: 8bfe             mov di, si
  0769A0  05D0: d1e7             shl di, 1
  0769A2  05D2: 03fe             add di, si
  0769A4  05D4: c1e702           shl di, 2
  0769A7  05D7: c45ea0           les bx, ptr [bp - 0x60]
  0769AA  05DA: 2bc0             sub ax, ax
  0769AC  05DC: 26894144         mov word ptr es:[bx + di + 0x44], ax
  0769B0  05E0: 26894142         mov word ptr es:[bx + di + 0x42], ax
  0769B4  05E4: 46               inc si
  0769B5  05E5: c45ea0           les bx, ptr [bp - 0x60]
  0769B8  05E8: 26397704         cmp word ptr es:[bx + 4], si
  0769BC  05EC: 7e7e             jle 0x66c
  0769BE  05EE: 8bfe             mov di, si
  0769C0  05F0: c1e704           shl di, 4
  0769C3  05F3: 037e9c           add di, word ptr [bp - 0x64]
  0769C6  05F6: 8e469e           mov es, word ptr [bp - 0x62]
  0769C9  05F9: 268b4508         mov ax, word ptr es:[di + 8]
  0769CD  05FD: 8bde             mov bx, si
  0769CF  05FF: d1e3             shl bx, 1
  0769D1  0601: 03de             add bx, si
  0769D3  0603: c1e302           shl bx, 2
  0769D6  0606: 8cc1             mov cx, es
  0769D8  0608: 035ea0           add bx, word ptr [bp - 0x60]
  0769DB  060B: 8e46a2           mov es, word ptr [bp - 0x5e]
  0769DE  060E: 26894746         mov word ptr es:[bx + 0x46], ax
  0769E2  0612: 8cc0             mov ax, es
  0769E4  0614: 8ec1             mov es, cx
  0769E6  0616: 268b550a         mov dx, word ptr es:[di + 0xa]
  0769EA  061A: 8ec0             mov es, ax
  0769EC  061C: 26895748         mov word ptr es:[bx + 0x48], dx
  0769F0  0620: 8ec1             mov es, cx
  0769F2  0622: 268b550c         mov dx, word ptr es:[di + 0xc]
  0769F6  0626: 8ec0             mov es, ax
  0769F8  0628: 2689574a         mov word ptr es:[bx + 0x4a], dx
  0769FC  062C: 8ec1             mov es, cx
  0769FE  062E: 268b550e         mov dx, word ptr es:[di + 0xe]
  076A02  0632: 8ec0             mov es, ax
  076A04  0634: 2689574c         mov word ptr es:[bx + 0x4c], dx
  076A08  0638: f686f0fd02       test byte ptr [bp - 0x210], 2
  076A0D  063D: 758f             jne 0x5ce
  076A0F  063F: 80beecfe00       cmp byte ptr [bp - 0x114], 0
  076A14  0644: 7588             jne 0x5ce
  076A16  0646: 8b4694           mov ax, word ptr [bp - 0x6c]
  076A19  0649: 8b5696           mov dx, word ptr [bp - 0x6a]
  076A1C  064C: 26894742         mov word ptr es:[bx + 0x42], ax
  076A20  0650: 26895744         mov word ptr es:[bx + 0x44], dx
  076A24  0654: 8ec1             mov es, cx
  076A26  0656: 26034504         add ax, word ptr es:[di + 4]
  076A2A  065A: 52               push dx
  076A2B  065B: 50               push ax
  076A2C  065C: 9a780e1f1a       lcall 0x1a1f, 0xe78
  076A31  0661: 894694           mov word ptr [bp - 0x6c], ax
  076A34  0664: 895696           mov word ptr [bp - 0x6a], dx
  076A37  0667: e97aff           jmp 0x5e4
  076A3A  066A: 90               nop 
  076A3B  066B: 90               nop 
  076A3C  066C: f686f0fd02       test byte ptr [bp - 0x210], 2
  076A41  0671: 7528             jne 0x69b
  076A43  0673: 80beecfe00       cmp byte ptr [bp - 0x114], 0
  076A48  0678: 7521             jne 0x69b
  076A4A  067A: ffb602fe         push word ptr [bp - 0x1fe]
  076A4E  067E: ffb600fe         push word ptr [bp - 0x200]
  076A52  0682: 6a00             push 0
  076A54  0684: 6a01             push 1
  076A56  0686: 8d861afe         lea ax, [bp - 0x1e6]
  076A5A  068A: 16               push ss
  076A5B  068B: 50               push ax
  076A5C  068C: 8b4680           mov ax, word ptr [bp - 0x80]
  076A5F  068F: 8b5682           mov dx, word ptr [bp - 0x7e]
  076A62  0692: 9a820e1f1a       lcall 0x1a1f, 0xe82
  076A67  0697: 0bd0             or dx, ax
  076A69  0699: 740e             je 0x6a9
  076A6B  069B: 8b46a0           mov ax, word ptr [bp - 0x60]
  076A6E  069E: 8b56a2           mov dx, word ptr [bp - 0x5e]
  076A71  06A1: 8986f8fd         mov word ptr [bp - 0x208], ax
  076A75  06A5: 8996fafd         mov word ptr [bp - 0x206], dx
  076A79  06A9: 83be1afe00       cmp word ptr [bp - 0x1e6], 0
  076A7E  06AE: 740b             je 0x6bb
  076A80  06B0: 8d861afe         lea ax, [bp - 0x1e6]
  076A84  06B4: 16               push ss
  076A85  06B5: 50               push ax
  076A86  06B6: 9aac0e1f1a       lcall 0x1a1f, 0xeac
  076A8B  06BB: 8b86e6fe         mov ax, word ptr [bp - 0x11a]
  076A8F  06BF: 0b86e4fe         or ax, word ptr [bp - 0x11c]
  076A93  06C3: 740d             je 0x6d2
  076A95  06C5: ffb6e6fe         push word ptr [bp - 0x11a]
  076A99  06C9: ffb6e4fe         push word ptr [bp - 0x11c]
  076A9D  06CD: 9aa8011f19       lcall 0x191f, 0x1a8
  076AA2  06D2: 8b469e           mov ax, word ptr [bp - 0x62]
  076AA5  06D5: 0b469c           or ax, word ptr [bp - 0x64]
  076AA8  06D8: 740b             je 0x6e5
  076AAA  06DA: ff769e           push word ptr [bp - 0x62]
  076AAD  06DD: ff769c           push word ptr [bp - 0x64]
  076AB0  06E0: 9aa8011f19       lcall 0x191f, 0x1a8
  076AB5  06E5: 8b46a2           mov ax, word ptr [bp - 0x5e]
  076AB8  06E8: 0b46a0           or ax, word ptr [bp - 0x60]
  076ABB  06EB: 7423             je 0x710
  076ABD  06ED: 8b46a0           mov ax, word ptr [bp - 0x60]
  076AC0  06F0: 8b56a2           mov dx, word ptr [bp - 0x5e]
  076AC3  06F3: 3906f623         cmp word ptr [0x23f6], ax
  076AC7  06F7: 7506             jne 0x6ff
  076AC9  06F9: 3916f823         cmp word ptr [0x23f8], dx
  076ACD  06FD: 7411             je 0x710
  076ACF  06FF: 8b8efafd         mov cx, word ptr [bp - 0x206]
  076AD3  0703: 0b8ef8fd         or cx, word ptr [bp - 0x208]
  076AD7  0707: 7507             jne 0x710
  076AD9  0709: 52               push dx
  076ADA  070A: 50               push ax
  076ADB  070B: 9aa8011f19       lcall 0x191f, 0x1a8
  076AE0  0710: 8b86f8fd         mov ax, word ptr [bp - 0x208]
  076AE4  0714: 8b96fafd         mov dx, word ptr [bp - 0x206]
  076AE8  0718: 5e               pop si
  076AE9  0719: 5f               pop di
  076AEA  071A: c9               leave 
  076AEB  071B: cb               retf 

; ---- func_076AEC  size=178  insns=74  prologue=ENTER 0x0126,0  terminal=RETF ----
  076AEC  071C: c8260100         enter 0x126, 0
  076AF0  0720: 57               push di
  076AF1  0721: 56               push si
  076AF2  0722: be0100           mov si, 1
  076AF5  0725: ff7606           push word ptr [bp + 6]
  076AF8  0728: 8d46a4           lea ax, [bp - 0x5c]
  076AFB  072B: 50               push ax
  076AFC  072C: 9ae4071d0d       lcall 0xd1d, 0x7e4
  076B01  0731: 83c404           add sp, 4
  076B04  0734: 8d46a4           lea ax, [bp - 0x5c]
  076B07  0737: 16               push ss
  076B08  0738: 50               push ax
  076B09  0739: 1e               push ds
  076B0A  073A: 68fa23           push 0x23fa
  076B0D  073D: 9a940a1f1a       lcall 0x1a1f, 0xa94
  076B12  0742: 8d86dafe         lea ax, [bp - 0x126]
  076B16  0746: 16               push ss
  076B17  0747: 50               push ax
  076B18  0748: 8d46a4           lea ax, [bp - 0x5c]
  076B1B  074B: 16               push ss
  076B1C  074C: 50               push ax
  076B1D  074D: 8d1efe23         lea bx, [0x23fe]
  076B21  0751: 2bc0             sub ax, ax
  076B23  0753: 9a9e0e1f1a       lcall 0x1a1f, 0xe9e
  076B28  0758: 0bc0             or ax, ax
  076B2A  075A: 756c             jne 0x7c8
  076B2C  075C: 8d46f4           lea ax, [bp - 0xc]
  076B2F  075F: 16               push ss
  076B30  0760: 50               push ax
  076B31  0761: 6a00             push 0
  076B33  0763: 6a01             push 1
  076B35  0765: 8d86dafe         lea ax, [bp - 0x126]
  076B39  0769: 16               push ss
  076B3A  076A: 50               push ax
  076B3B  076B: b80800           mov ax, 8
  076B3E  076E: 99               cdq 
  076B3F  076F: 9a820e1f1a       lcall 0x1a1f, 0xe82
  076B44  0774: 0bd0             or dx, ax
  076B46  0776: 7450             je 0x7c8
  076B48  0778: 8b460c           mov ax, word ptr [bp + 0xc]
  076B4B  077B: 8b560e           mov dx, word ptr [bp + 0xe]
  076B4E  077E: 8bf8             mov di, ax
  076B50  0780: 8956fe           mov word ptr [bp - 2], dx
  076B53  0783: 837e1000         cmp word ptr [bp + 0x10], 0
  076B57  0787: 7415             je 0x79e
  076B59  0789: 8b5608           mov dx, word ptr [bp + 8]
  076B5C  078C: 2b56f4           sub dx, word ptr [bp - 0xc]
  076B5F  078F: 8d5e08           lea bx, [bp + 8]
  076B62  0792: 2bc0             sub ax, ax
  076B64  0794: 9a90021f18       lcall 0x181f, 0x290
  076B69  0799: 8bf8             mov di, ax
  076B6B  079B: 8956fe           mov word ptr [bp - 2], dx
  076B6E  079E: ff76fe           push word ptr [bp - 2]
  076B71  07A1: 57               push di
  076B72  07A2: 6a00             push 0
  076B74  07A4: 6a01             push 1
  076B76  07A6: 8d86dafe         lea ax, [bp - 0x126]
  076B7A  07AA: 16               push ss
  076B7B  07AB: 50               push ax
  076B7C  07AC: 8b46f6           mov ax, word ptr [bp - 0xa]
  076B7F  07AF: f76ef4           imul word ptr [bp - 0xc]
  076B82  07B2: 9a820e1f1a       lcall 0x1a1f, 0xe82
  076B87  07B7: 0bd0             or dx, ax
  076B89  07B9: 740d             je 0x7c8
  076B8B  07BB: 8d86dafe         lea ax, [bp - 0x126]
  076B8F  07BF: 16               push ss
  076B90  07C0: 50               push ax
  076B91  07C1: 9aac0e1f1a       lcall 0x1a1f, 0xeac
  076B96  07C6: 2bf6             sub si, si
  076B98  07C8: 8bc6             mov ax, si
  076B9A  07CA: 5e               pop si
  076B9B  07CB: 5f               pop di
  076B9C  07CC: c9               leave 
  076B9D  07CD: cb               retf 

; ---- func_076B9E  size=210  insns=87  prologue=ENTER 0x0126,0  terminal=RETF ----
  076B9E  07CE: c8260100         enter 0x126, 0
  076BA2  07D2: 57               push di
  076BA3  07D3: 56               push si
  076BA4  07D4: be0100           mov si, 1
  076BA7  07D7: ff7606           push word ptr [bp + 6]
  076BAA  07DA: 8d46a4           lea ax, [bp - 0x5c]
  076BAD  07DD: 50               push ax
  076BAE  07DE: 9ae4071d0d       lcall 0xd1d, 0x7e4
  076BB3  07E3: 83c404           add sp, 4
  076BB6  07E6: 8d46a4           lea ax, [bp - 0x5c]
  076BB9  07E9: 16               push ss
  076BBA  07EA: 50               push ax
  076BBB  07EB: 1e               push ds
  076BBC  07EC: 680224           push 0x2402
  076BBF  07EF: 9a940a1f1a       lcall 0x1a1f, 0xa94
  076BC4  07F4: 8d86dafe         lea ax, [bp - 0x126]
  076BC8  07F8: 16               push ss
  076BC9  07F9: 50               push ax
  076BCA  07FA: 8d46a4           lea ax, [bp - 0x5c]
  076BCD  07FD: 16               push ss
  076BCE  07FE: 50               push ax
  076BCF  07FF: 8d1e0624         lea bx, [0x2406]
  076BD3  0803: 2bc0             sub ax, ax
  076BD5  0805: 9a9e0e1f1a       lcall 0x1a1f, 0xe9e
  076BDA  080A: 0bc0             or ax, ax
  076BDC  080C: 7403             je 0x811
  076BDE  080E: e98900           jmp 0x89a
  076BE1  0811: 8d46f4           lea ax, [bp - 0xc]
  076BE4  0814: 16               push ss
  076BE5  0815: 50               push ax
  076BE6  0816: 6a00             push 0
  076BE8  0818: 6a01             push 1
  076BEA  081A: 8d86dafe         lea ax, [bp - 0x126]
  076BEE  081E: 16               push ss
  076BEF  081F: 50               push ax
  076BF0  0820: b80800           mov ax, 8
  076BF3  0823: 99               cdq 
  076BF4  0824: 9a820e1f1a       lcall 0x1a1f, 0xe82
  076BF9  0829: 0bd0             or dx, ax
  076BFB  082B: 746d             je 0x89a
  076BFD  082D: 8b460c           mov ax, word ptr [bp + 0xc]
  076C00  0830: 8b560e           mov dx, word ptr [bp + 0xe]
  076C03  0833: 8bf8             mov di, ax
  076C05  0835: 8956fe           mov word ptr [bp - 2], dx
  076C08  0838: 837e1000         cmp word ptr [bp + 0x10], 0
  076C0C  083C: 7415             je 0x853
  076C0E  083E: 8b5608           mov dx, word ptr [bp + 8]
  076C11  0841: 2b56f4           sub dx, word ptr [bp - 0xc]
  076C14  0844: 8d5e08           lea bx, [bp + 8]
  076C17  0847: 2bc0             sub ax, ax
  076C19  0849: 9a90021f18       lcall 0x181f, 0x290
  076C1E  084E: 8bf8             mov di, ax
  076C20  0850: 8956fe           mov word ptr [bp - 2], dx
  076C23  0853: ff76fe           push word ptr [bp - 2]
  076C26  0856: 57               push di
  076C27  0857: 6a00             push 0
  076C29  0859: 6a01             push 1
  076C2B  085B: 8d86dafe         lea ax, [bp - 0x126]
  076C2F  085F: 16               push ss
  076C30  0860: 50               push ax
  076C31  0861: 8b46f6           mov ax, word ptr [bp - 0xa]
  076C34  0864: f76ef4           imul word ptr [bp - 0xc]
  076C37  0867: 9a820e1f1a       lcall 0x1a1f, 0xe82
  076C3C  086C: 0bd0             or dx, ax
  076C3E  086E: 742a             je 0x89a
  076C40  0870: ff7614           push word ptr [bp + 0x14]
  076C43  0873: ff7612           push word ptr [bp + 0x12]
  076C46  0876: 6a00             push 0
  076C48  0878: 6a01             push 1
  076C4A  087A: 8d86dafe         lea ax, [bp - 0x126]
  076C4E  087E: 16               push ss
  076C4F  087F: 50               push ax
  076C50  0880: b80003           mov ax, 0x300
  076C53  0883: 99               cdq 
  076C54  0884: 9a820e1f1a       lcall 0x1a1f, 0xe82
  076C59  0889: 0bd0             or dx, ax
  076C5B  088B: 740d             je 0x89a
  076C5D  088D: 8d86dafe         lea ax, [bp - 0x126]
  076C61  0891: 16               push ss
  076C62  0892: 50               push ax
  076C63  0893: 9aac0e1f1a       lcall 0x1a1f, 0xeac
  076C68  0898: 2bf6             sub si, si
  076C6A  089A: 8bc6             mov ax, si
  076C6C  089C: 5e               pop si
  076C6D  089D: 5f               pop di
  076C6E  089E: c9               leave 
  076C6F  089F: cb               retf 

; ---- func_076C70  size=254  insns=99  prologue=ENTER 0x013E,0  terminal=RETF ----
  076C70  08A0: c83e0100         enter 0x13e, 0
  076C74  08A4: 53               push bx
  076C75  08A5: 57               push di
  076C76  08A6: 56               push si
  076C77  08A7: 2bc0             sub ax, ax
  076C79  08A9: 99               cdq 
  076C7A  08AA: 8bf0             mov si, ax
  076C7C  08AC: 8956f6           mov word ptr [bp - 0xa], dx
  076C7F  08AF: 8946f2           mov word ptr [bp - 0xe], ax
  076C82  08B2: 8946f0           mov word ptr [bp - 0x10], ax
  076C85  08B5: c70650260f00     mov word ptr [0x2650], 0xf
  076C8B  08BB: 8986c2fe         mov word ptr [bp - 0x13e], ax
  076C8F  08BF: 53               push bx
  076C90  08C0: 8d468c           lea ax, [bp - 0x74]
  076C93  08C3: 50               push ax
  076C94  08C4: 9ae4071d0d       lcall 0xd1d, 0x7e4
  076C99  08C9: 83c404           add sp, 4
  076C9C  08CC: 6a2e             push 0x2e
  076C9E  08CE: 8d468c           lea ax, [bp - 0x74]
  076CA1  08D1: 50               push ax
  076CA2  08D2: 9a560c1d0d       lcall 0xd1d, 0xc56
  076CA7  08D7: 83c404           add sp, 4
  076CAA  08DA: 0bc0             or ax, ax
  076CAC  08DC: 750f             jne 0x8ed
  076CAE  08DE: 688226           push 0x2682
  076CB1  08E1: 8d468c           lea ax, [bp - 0x74]
  076CB4  08E4: 50               push ax
  076CB5  08E5: 9aa4071d0d       lcall 0xd1d, 0x7a4
  076CBA  08EA: 83c404           add sp, 4
  076CBD  08ED: 8d7e8c           lea di, [bp - 0x74]
  076CC0  08F0: 803d2a           cmp byte ptr [di], 0x2a
  076CC3  08F3: 7503             jne 0x8f8
  076CC5  08F5: 8d7e8d           lea di, [bp - 0x73]
  076CC8  08F8: 6a08             push 8
  076CCA  08FA: 57               push di
  076CCB  08FB: 8d46dc           lea ax, [bp - 0x24]
  076CCE  08FE: 50               push ax
  076CCF  08FF: 9a94081d0d       lcall 0xd1d, 0x894
  076CD4  0904: 83c406           add sp, 6
  076CD7  0907: 8d86c2fe         lea ax, [bp - 0x13e]
  076CDB  090B: 16               push ss
  076CDC  090C: 50               push ax
  076CDD  090D: 8d468c           lea ax, [bp - 0x74]
  076CE0  0910: 16               push ss
  076CE1  0911: 50               push ax
  076CE2  0912: 8d1e8626         lea bx, [0x2686]
  076CE6  0916: b8ffff           mov ax, 0xffff
  076CE9  0919: 9a9e0e1f1a       lcall 0x1a1f, 0xe9e
  076CEE  091E: 0bc0             or ax, ax
  076CF0  0920: 7547             jne 0x969
  076CF2  0922: 8d46dc           lea ax, [bp - 0x24]
  076CF5  0925: 16               push ss
  076CF6  0926: 50               push ax
  076CF7  0927: 8b86eefe         mov ax, word ptr [bp - 0x112]
  076CFB  092B: 8b96f0fe         mov dx, word ptr [bp - 0x110]
  076CFF  092F: 8946f8           mov word ptr [bp - 8], ax
  076D02  0932: 8956fa           mov word ptr [bp - 6], dx
  076D05  0935: 9a900e1f1a       lcall 0x1a1f, 0xe90
  076D0A  093A: 8bf0             mov si, ax
  076D0C  093C: 8956f6           mov word ptr [bp - 0xa], dx
  076D0F  093F: 0bd0             or dx, ax
  076D11  0941: 7426             je 0x969
  076D13  0943: ff76f6           push word ptr [bp - 0xa]
  076D16  0946: 56               push si
  076D17  0947: 6a00             push 0
  076D19  0949: 6a01             push 1
  076D1B  094B: 8d86c2fe         lea ax, [bp - 0x13e]
  076D1F  094F: 16               push ss
  076D20  0950: 50               push ax
  076D21  0951: 8b46f8           mov ax, word ptr [bp - 8]
  076D24  0954: 8b56fa           mov dx, word ptr [bp - 6]
  076D27  0957: 9a820e1f1a       lcall 0x1a1f, 0xe82
  076D2C  095C: 0bd0             or dx, ax
  076D2E  095E: 7409             je 0x969
  076D30  0960: 8b46f6           mov ax, word ptr [bp - 0xa]
  076D33  0963: 8976f0           mov word ptr [bp - 0x10], si
  076D36  0966: 8946f2           mov word ptr [bp - 0xe], ax
  076D39  0969: 8b46f6           mov ax, word ptr [bp - 0xa]
  076D3C  096C: 0bc6             or ax, si
  076D3E  096E: 7412             je 0x982
  076D40  0970: 8b46f2           mov ax, word ptr [bp - 0xe]
  076D43  0973: 0b46f0           or ax, word ptr [bp - 0x10]
  076D46  0976: 750a             jne 0x982
  076D48  0978: 8b46f6           mov ax, word ptr [bp - 0xa]
  076D4B  097B: 50               push ax
  076D4C  097C: 56               push si
  076D4D  097D: 9aa8011f19       lcall 0x191f, 0x1a8
  076D52  0982: 83bec2fe00       cmp word ptr [bp - 0x13e], 0
  076D57  0987: 740b             je 0x994
  076D59  0989: 8d86c2fe         lea ax, [bp - 0x13e]
  076D5D  098D: 16               push ss
  076D5E  098E: 50               push ax
  076D5F  098F: 9aac0e1f1a       lcall 0x1a1f, 0xeac
  076D64  0994: 8b46f0           mov ax, word ptr [bp - 0x10]
  076D67  0997: 8b56f2           mov dx, word ptr [bp - 0xe]
  076D6A  099A: 5e               pop si
  076D6B  099B: 5f               pop di
  076D6C  099C: c9               leave 
  076D6D  099D: cb               retf 
