; ============================================================
; VICEROY.EXE overlay page 0x19 (record 24) -- RE-SEGMENTED
; file_offset (disk image) = 0x06FB40
; code_offset (first insn) = 0x06FDF0
; code_end (next reloc hdr)= 0x071490  [resident size 362 para -> nominal_end 0x0711E0; on-disk code spills past it]
; reloc_count = 162  flags = 0x0040
; display IP base = page-image-relative (IP = file - 0x06FB40)
; functions in page = 21
; ============================================================

; ---- func_06FDF0  size=44  insns=18  prologue=push bp;mov bp,sp  terminal=RETF ----
  06FDF0  02B0: 55               push bp
  06FDF1  02B1: 8bec             mov bp, sp
  06FDF3  02B3: 6b46064c         imul ax, word ptr [bp + 6], 0x4c
  06FDF7  02B7: 050a00           add ax, 0xa
  06FDFA  02BA: 8b5e0a           mov bx, word ptr [bp + 0xa]
  06FDFD  02BD: 8907             mov word ptr [bx], ax
  06FDFF  02BF: 837e0801         cmp word ptr [bp + 8], 1
  06FE03  02C3: 7e05             jle 0x2ca
  06FE05  02C5: b8ffff           mov ax, 0xffff
  06FE08  02C8: eb02             jmp 0x2cc
  06FE0A  02CA: 2bc0             sub ax, ax
  06FE0C  02CC: 6b4e083c         imul cx, word ptr [bp + 8], 0x3c
  06FE10  02D0: 03c1             add ax, cx
  06FE12  02D2: 051000           add ax, 0x10
  06FE15  02D5: 8b5e0c           mov bx, word ptr [bp + 0xc]
  06FE18  02D8: 8907             mov word ptr [bx], ax
  06FE1A  02DA: c9               leave 
  06FE1B  02DB: cb               retf 

; ---- func_06FE1C  size=376  insns=137  prologue=ENTER 0x0058,0  terminal=RETF ----
  06FE1C  02DC: c8580000         enter 0x58, 0
  06FE20  02E0: 56               push si
  06FE21  02E1: 8d46aa           lea ax, [bp - 0x56]
  06FE24  02E4: 50               push ax
  06FE25  02E5: 8d4eac           lea cx, [bp - 0x54]
  06FE28  02E8: 51               push cx
  06FE29  02E9: ff7608           push word ptr [bp + 8]
  06FE2C  02EC: ff7606           push word ptr [bp + 6]
  06FE2F  02EF: 0e               push cs
  06FE30  02F0: e80e0e           call 0x1101
  06FE33  02F3: 83c408           add sp, 8
  06FE36  02F6: ff36a483         push word ptr [0x83a4]
  06FE3A  02FA: ff36a283         push word ptr [0x83a2]
  06FE3E  02FE: ff36a083         push word ptr [0x83a0]
  06FE42  0302: ff369e83         push word ptr [0x839e]
  06FE46  0306: ff36ae2d         push word ptr [0x2dae]
  06FE4A  030A: ff36ac2d         push word ptr [0x2dac]
  06FE4E  030E: ff36aa2d         push word ptr [0x2daa]
  06FE52  0312: ff36a82d         push word ptr [0x2da8]
  06FE56  0316: 6a30             push 0x30
  06FE58  0318: 8b46ac           mov ax, word ptr [bp - 0x54]
  06FE5B  031B: 8b56aa           mov dx, word ptr [bp - 0x56]
  06FE5E  031E: bb4800           mov bx, 0x48
  06FE61  0321: 9a44041f18       lcall 0x181f, 0x444
  06FE66  0326: c646a80a         mov byte ptr [bp - 0x58], 0xa
  06FE6A  032A: a10aa6           mov ax, word ptr [0xa60a]
  06FE6D  032D: 394606           cmp word ptr [bp + 6], ax
  06FE70  0330: 7504             jne 0x336
  06FE72  0332: c646a80e         mov byte ptr [bp - 0x58], 0xe
  06FE76  0336: 8b4608           mov ax, word ptr [bp + 8]
  06FE79  0339: 8b5e06           mov bx, word ptr [bp + 6]
  06FE7C  033C: d1e3             shl bx, 1
  06FE7E  033E: 39877e1e         cmp word ptr [bx + 0x1e7e], ax
  06FE82  0342: 7403             je 0x347
  06FE84  0344: e9f600           jmp 0x43d
  06FE87  0347: ff36ae2d         push word ptr [0x2dae]
  06FE8B  034B: ff36ac2d         push word ptr [0x2dac]
  06FE8F  034F: ff36aa2d         push word ptr [0x2daa]
  06FE93  0353: ff36a82d         push word ptr [0x2da8]
  06FE97  0357: 8b4eaa           mov cx, word ptr [bp - 0x56]
  06FE9A  035A: 83c12f           add cx, 0x2f
  06FE9D  035D: 51               push cx
  06FE9E  035E: 8a4ea8           mov cl, byte ptr [bp - 0x58]
  06FEA1  0361: 51               push cx
  06FEA2  0362: 8bd3             mov dx, bx
  06FEA4  0364: 8b5eac           mov bx, word ptr [bp - 0x54]
  06FEA7  0367: 8bc3             mov ax, bx
  06FEA9  0369: 83c347           add bx, 0x47
  06FEAC  036C: 8bf2             mov si, dx
  06FEAE  036E: 8b56aa           mov dx, word ptr [bp - 0x56]
  06FEB1  0371: 9ace001f18       lcall 0x181f, 0xce
  06FEB6  0376: c41e9e08         les bx, ptr [0x89e]
  06FEBA  037A: 268a07           mov al, byte ptr es:[bx]
  06FEBD  037D: 2ae4             sub ah, ah
  06FEBF  037F: 2b46aa           sub ax, word ptr [bp - 0x56]
  06FEC2  0382: f7d8             neg ax
  06FEC4  0384: 051700           add ax, 0x17
  06FEC7  0387: 8946ae           mov word ptr [bp - 0x52], ax
  06FECA  038A: c646b000         mov byte ptr [bp - 0x50], 0
  06FECE  038E: ffb4da2e         push word ptr [si + 0x2eda]
  06FED2  0392: 8d46b0           lea ax, [bp - 0x50]
  06FED5  0395: 50               push ax
  06FED6  0396: 9a6e011f18       lcall 0x181f, 0x16e
  06FEDB  039B: 83c404           add sp, 4
  06FEDE  039E: 682020           push 0x2020
  06FEE1  03A1: 8d46b0           lea ax, [bp - 0x50]
  06FEE4  03A4: 50               push ax
  06FEE5  03A5: 9aa4071d0d       lcall 0xd1d, 0x7a4
  06FEEA  03AA: 83c404           add sp, 4
  06FEED  03AD: 6a00             push 0
  06FEEF  03AF: ff76ae           push word ptr [bp - 0x52]
  06FEF2  03B2: 6a48             push 0x48
  06FEF4  03B4: 8b46ac           mov ax, word ptr [bp - 0x54]
  06FEF7  03B7: 40               inc ax
  06FEF8  03B8: 50               push ax
  06FEF9  03B9: 8d46b0           lea ax, [bp - 0x50]
  06FEFC  03BC: 16               push ss
  06FEFD  03BD: 50               push ax
  06FEFE  03BE: 9a00011f18       lcall 0x181f, 0x100
  06FF03  03C3: 83c40c           add sp, 0xc
  06FF06  03C6: 8a46a8           mov al, byte ptr [bp - 0x58]
  06FF09  03C9: 2ae4             sub ah, ah
  06FF0B  03CB: 50               push ax
  06FF0C  03CC: ff76ae           push word ptr [bp - 0x52]
  06FF0F  03CF: 6a48             push 0x48
  06FF11  03D1: ff76ac           push word ptr [bp - 0x54]
  06FF14  03D4: 8d4eb0           lea cx, [bp - 0x50]
  06FF17  03D7: 16               push ss
  06FF18  03D8: 51               push cx
  06FF19  03D9: 8bf0             mov si, ax
  06FF1B  03DB: 9a00011f18       lcall 0x181f, 0x100
  06FF20  03E0: 83c40c           add sp, 0xc
  06FF23  03E3: 8b46aa           mov ax, word ptr [bp - 0x56]
  06FF26  03E6: 051900           add ax, 0x19
  06FF29  03E9: 8946ae           mov word ptr [bp - 0x52], ax
  06FF2C  03EC: c646b000         mov byte ptr [bp - 0x50], 0
  06FF30  03F0: 8b5e06           mov bx, word ptr [bp + 6]
  06FF33  03F3: 8bc3             mov ax, bx
  06FF35  03F5: d1e3             shl bx, 1
  06FF37  03F7: 03d8             add bx, ax
  06FF39  03F9: 035e08           add bx, word ptr [bp + 8]
  06FF3C  03FC: d1e3             shl bx, 1
  06FF3E  03FE: ffb7e22e         push word ptr [bx + 0x2ee2]
  06FF42  0402: 8d46b0           lea ax, [bp - 0x50]
  06FF45  0405: 50               push ax
  06FF46  0406: 9a6e011f18       lcall 0x181f, 0x16e
  06FF4B  040B: 83c404           add sp, 4
  06FF4E  040E: 6a00             push 0
  06FF50  0410: ff76ae           push word ptr [bp - 0x52]
  06FF53  0413: 6a48             push 0x48
  06FF55  0415: 8b46ac           mov ax, word ptr [bp - 0x54]
  06FF58  0418: 40               inc ax
  06FF59  0419: 50               push ax
  06FF5A  041A: 8d46b0           lea ax, [bp - 0x50]
  06FF5D  041D: 16               push ss
  06FF5E  041E: 50               push ax
  06FF5F  041F: 9a00011f18       lcall 0x181f, 0x100
  06FF64  0424: 83c40c           add sp, 0xc
  06FF67  0427: 56               push si
  06FF68  0428: ff76ae           push word ptr [bp - 0x52]
  06FF6B  042B: 6a48             push 0x48
  06FF6D  042D: ff76ac           push word ptr [bp - 0x54]
  06FF70  0430: 8d46b0           lea ax, [bp - 0x50]
  06FF73  0433: 16               push ss
  06FF74  0434: 50               push ax
  06FF75  0435: 9a00011f18       lcall 0x181f, 0x100
  06FF7A  043A: 83c40c           add sp, 0xc
  06FF7D  043D: ff76aa           push word ptr [bp - 0x56]
  06FF80  0440: 6a48             push 0x48
  06FF82  0442: 6a30             push 0x30
  06FF84  0444: 8b46ac           mov ax, word ptr [bp - 0x54]
  06FF87  0447: 8b56aa           mov dx, word ptr [bp - 0x56]
  06FF8A  044A: 8bd8             mov bx, ax
  06FF8C  044C: 9ae2001f18       lcall 0x181f, 0xe2
  06FF91  0451: 5e               pop si
  06FF92  0452: c9               leave 
  06FF93  0453: cb               retf 

; ---- func_06FF94  size=204  insns=72  prologue=ENTER 0x0054,0  terminal=RETF ----
  06FF94  0454: c8540000         enter 0x54, 0
  06FF98  0458: c646b000         mov byte ptr [bp - 0x50], 0
  06FF9C  045C: ff36fa2e         push word ptr [0x2efa]
  06FFA0  0460: 8d46b0           lea ax, [bp - 0x50]
  06FFA3  0463: 50               push ax
  06FFA4  0464: 9a6e011f18       lcall 0x181f, 0x16e
  06FFA9  0469: 83c404           add sp, 4
  06FFAC  046C: 68fd00           push 0xfd
  06FFAF  046F: 68fe00           push 0xfe
  06FFB2  0472: 6a04             push 4
  06FFB4  0474: 684001           push 0x140
  06FFB7  0477: 6a00             push 0
  06FFB9  0479: 8d46b0           lea ax, [bp - 0x50]
  06FFBC  047C: 16               push ss
  06FFBD  047D: 50               push ax
  06FFBE  047E: 9ac8011f18       lcall 0x181f, 0x1c8
  06FFC3  0483: 83c40e           add sp, 0xe
  06FFC6  0486: 6a00             push 0
  06FFC8  0488: 684001           push 0x140
  06FFCB  048B: 6a10             push 0x10
  06FFCD  048D: 2bc0             sub ax, ax
  06FFCF  048F: 99               cdq 
  06FFD0  0490: 2bdb             sub bx, bx
  06FFD2  0492: 9ae2001f18       lcall 0x181f, 0xe2
  06FFD7  0497: c646b000         mov byte ptr [bp - 0x50], 0
  06FFDB  049B: 8d46b0           lea ax, [bp - 0x50]
  06FFDE  049E: 50               push ax
  06FFDF  049F: 9a1e011f18       lcall 0x181f, 0x11e
  06FFE4  04A4: 83c402           add sp, 2
  06FFE7  04A7: ff36fc2e         push word ptr [0x2efc]
  06FFEB  04AB: 8d46b0           lea ax, [bp - 0x50]
  06FFEE  04AE: 50               push ax
  06FFEF  04AF: 9a6e011f18       lcall 0x181f, 0x16e
  06FFF4  04B4: 83c404           add sp, 4
  06FFF7  04B7: 8d46b0           lea ax, [bp - 0x50]
  06FFFA  04BA: 50               push ax
  06FFFB  04BB: 9a28011f18       lcall 0x181f, 0x128
  070000  04C0: 83c402           add sp, 2
  070003  04C3: 68fe00           push 0xfe
  070006  04C6: 68be00           push 0xbe
  070009  04C9: 684001           push 0x140
  07000C  04CC: 6a00             push 0
  07000E  04CE: 8d46b0           lea ax, [bp - 0x50]
  070011  04D1: 16               push ss
  070012  04D2: 50               push ax
  070013  04D3: 9a00011f18       lcall 0x181f, 0x100
  070018  04D8: 83c40c           add sp, 0xc
  07001B  04DB: 68b700           push 0xb7
  07001E  04DE: 684001           push 0x140
  070021  04E1: 6a10             push 0x10
  070023  04E3: 2bc0             sub ax, ax
  070025  04E5: bab700           mov dx, 0xb7
  070028  04E8: 2bdb             sub bx, bx
  07002A  04EA: 9ae2001f18       lcall 0x181f, 0xe2
  07002F  04EF: c746ae0000       mov word ptr [bp - 0x52], 0
  070034  04F4: eb1b             jmp 0x511
  070036  04F6: ff46ac           inc word ptr [bp - 0x54]
  070039  04F9: 837eac03         cmp word ptr [bp - 0x54], 3
  07003D  04FD: 7d0f             jge 0x50e
  07003F  04FF: ff76ac           push word ptr [bp - 0x54]
  070042  0502: ff76ae           push word ptr [bp - 0x52]
  070045  0505: 0e               push cs
  070046  0506: e8020c           call 0x110b
  070049  0509: 83c404           add sp, 4
  07004C  050C: ebe8             jmp 0x4f6
  07004E  050E: ff46ae           inc word ptr [bp - 0x52]
  070051  0511: 837eae04         cmp word ptr [bp - 0x52], 4
  070055  0515: 7d07             jge 0x51e
  070057  0517: c746ac0000       mov word ptr [bp - 0x54], 0
  07005C  051C: ebdb             jmp 0x4f9
  07005E  051E: c9               leave 
  07005F  051F: cb               retf 

; ---- func_070060  size=607  insns=209  prologue=ENTER 0x0312,0  terminal=RETF ----
  070060  0520: c8120300         enter 0x312, 0
  070064  0524: c746fc0100       mov word ptr [bp - 4], 1
  070069  0529: 8d86f0fc         lea ax, [bp - 0x310]
  07006D  052D: 16               push ss
  07006E  052E: 50               push ax
  07006F  052F: 2bc0             sub ax, ax
  070071  0531: a30aa6           mov word ptr [0xa60a], ax
  070074  0534: 50               push ax
  070075  0535: ff36a483         push word ptr [0x83a4]
  070079  0539: ff36a283         push word ptr [0x83a2]
  07007D  053D: ff36a083         push word ptr [0x83a0]
  070081  0541: ff369e83         push word ptr [0x839e]
  070085  0545: 682220           push 0x2022
  070088  0548: 9a4e041f18       lcall 0x181f, 0x44e
  07008D  054D: 83c410           add sp, 0x10
  070090  0550: 0bc0             or ax, ax
  070092  0552: 7403             je 0x557
  070094  0554: e91302           jmp 0x76a
  070097  0557: 9ab6031f18       lcall 0x181f, 0x3b6
  07009C  055C: 8d86f0fc         lea ax, [bp - 0x310]
  0700A0  0560: 16               push ss
  0700A1  0561: 50               push ax
  0700A2  0562: 9af4031f18       lcall 0x181f, 0x3f4
  0700A7  0567: ff36a483         push word ptr [0x83a4]
  0700AB  056B: ff36a283         push word ptr [0x83a2]
  0700AF  056F: ff36a083         push word ptr [0x83a0]
  0700B3  0573: ff369e83         push word ptr [0x839e]
  0700B7  0577: ff36ae2d         push word ptr [0x2dae]
  0700BB  057B: ff36ac2d         push word ptr [0x2dac]
  0700BF  057F: ff36aa2d         push word ptr [0x2daa]
  0700C3  0583: ff36a82d         push word ptr [0x2da8]
  0700C7  0587: 68c800           push 0xc8
  0700CA  058A: 2bc0             sub ax, ax
  0700CC  058C: 99               cdq 
  0700CD  058D: bb4001           mov bx, 0x140
  0700D0  0590: 9a44041f18       lcall 0x181f, 0x444
  0700D5  0595: 6a00             push 0
  0700D7  0597: 684001           push 0x140
  0700DA  059A: 68c800           push 0xc8
  0700DD  059D: 2bc0             sub ax, ax
  0700DF  059F: 99               cdq 
  0700E0  05A0: 2bdb             sub bx, bx
  0700E2  05A2: 9ae2001f18       lcall 0x181f, 0xe2
  0700E7  05A7: 0e               push cs
  0700E8  05A8: e86a0b           call 0x1115
  0700EB  05AB: 9a7a041f18       lcall 0x181f, 0x47a
  0700F0  05B0: c746fa0100       mov word ptr [bp - 6], 1
  0700F5  05B5: 2bc0             sub ax, ax
  0700F7  05B7: 9a66041f18       lcall 0x181f, 0x466
  0700FC  05BC: a10aa6           mov ax, word ptr [0xa60a]
  0700FF  05BF: 8946fe           mov word ptr [bp - 2], ax
  070102  05C2: 9af6001f18       lcall 0x181f, 0xf6
  070107  05C7: 0bc0             or ax, ax
  070109  05C9: 7431             je 0x5fc
  07010B  05CB: 9ae0031f18       lcall 0x181f, 0x3e0
  070110  05D0: 8986eefc         mov word ptr [bp - 0x312], ax
  070114  05D4: 3d2000           cmp ax, 0x20
  070117  05D7: 7503             jne 0x5dc
  070119  05D9: e99e00           jmp 0x67a
  07011C  05DC: 7e03             jle 0x5e1
  07011E  05DE: e9a900           jmp 0x68a
  070121  05E1: 3d1b00           cmp ax, 0x1b
  070124  05E4: 7503             jne 0x5e9
  070126  05E6: e98101           jmp 0x76a
  070129  05E9: 7711             ja 0x5fc
  07012B  05EB: 2c08             sub al, 8
  07012D  05ED: 7429             je 0x618
  07012F  05EF: fec8             dec al
  070131  05F1: 745f             je 0x652
  070133  05F3: 2c04             sub al, 4
  070135  05F5: 7505             jne 0x5fc
  070137  05F7: c746fa0000       mov word ptr [bp - 6], 0
  07013C  05FC: 833ef00700       cmp word ptr [0x7f0], 0
  070141  0601: 7503             jne 0x606
  070143  0603: e94c01           jmp 0x752
  070146  0606: 833ef60700       cmp word ptr [0x7f6], 0
  07014B  060B: 7503             jne 0x610
  07014D  060D: e94201           jmp 0x752
  070150  0610: c746f40000       mov word ptr [bp - 0xc], 0
  070155  0615: e91701           jmp 0x72f
  070158  0618: a10aa6           mov ax, word ptr [0xa60a]
  07015B  061B: 050300           add ax, 3
  07015E  061E: b90400           mov cx, 4
  070161  0621: 99               cdq 
  070162  0622: f7f9             idiv cx
  070164  0624: 89160aa6         mov word ptr [0xa60a], dx
  070168  0628: 8b5efe           mov bx, word ptr [bp - 2]
  07016B  062B: d1e3             shl bx, 1
  07016D  062D: ffb77e1e         push word ptr [bx + 0x1e7e]
  070171  0631: ff76fe           push word ptr [bp - 2]
  070174  0634: 0e               push cs
  070175  0635: e8d30a           call 0x110b
  070178  0638: 83c404           add sp, 4
  07017B  063B: 8b1e0aa6         mov bx, word ptr [0xa60a]
  07017F  063F: d1e3             shl bx, 1
  070181  0641: ffb77e1e         push word ptr [bx + 0x1e7e]
  070185  0645: ff360aa6         push word ptr [0xa60a]
  070189  0649: 0e               push cs
  07018A  064A: e8be0a           call 0x110b
  07018D  064D: 83c404           add sp, 4
  070190  0650: ebaa             jmp 0x5fc
  070192  0652: a10aa6           mov ax, word ptr [0xa60a]
  070195  0655: 40               inc ax
  070196  0656: ebc6             jmp 0x61e
  070198  0658: 8b1e0aa6         mov bx, word ptr [0xa60a]
  07019C  065C: d1e3             shl bx, 1
  07019E  065E: 8b877e1e         mov ax, word ptr [bx + 0x1e7e]
  0701A2  0662: 8946fe           mov word ptr [bp - 2], ax
  0701A5  0665: 40               inc ax
  0701A6  0666: 40               inc ax
  0701A7  0667: b90300           mov cx, 3
  0701AA  066A: 99               cdq 
  0701AB  066B: f7f9             idiv cx
  0701AD  066D: 89977e1e         mov word ptr [bx + 0x1e7e], dx
  0701B1  0671: ff76fe           push word ptr [bp - 2]
  0701B4  0674: ff360aa6         push word ptr [0xa60a]
  0701B8  0678: ebba             jmp 0x634
  0701BA  067A: 8b1e0aa6         mov bx, word ptr [0xa60a]
  0701BE  067E: d1e3             shl bx, 1
  0701C0  0680: 8b877e1e         mov ax, word ptr [bx + 0x1e7e]
  0701C4  0684: 8946fe           mov word ptr [bp - 2], ax
  0701C7  0687: 40               inc ax
  0701C8  0688: ebdd             jmp 0x667
  0701CA  068A: 2d4801           sub ax, 0x148
  0701CD  068D: 74c9             je 0x658
  0701CF  068F: 2d0300           sub ax, 3
  0701D2  0692: 7484             je 0x618
  0701D4  0694: 48               dec ax
  0701D5  0695: 48               dec ax
  0701D6  0696: 74ba             je 0x652
  0701D8  0698: 2d0300           sub ax, 3
  0701DB  069B: 74dd             je 0x67a
  0701DD  069D: e95cff           jmp 0x5fc
  0701E0  06A0: ff46f0           inc word ptr [bp - 0x10]
  0701E3  06A3: 837ef003         cmp word ptr [bp - 0x10], 3
  0701E7  06A7: 7c03             jl 0x6ac
  0701E9  06A9: e98000           jmp 0x72c
  0701EC  06AC: 8d46f2           lea ax, [bp - 0xe]
  0701EF  06AF: 50               push ax
  0701F0  06B0: 8d4ef6           lea cx, [bp - 0xa]
  0701F3  06B3: 51               push cx
  0701F4  06B4: ff76f0           push word ptr [bp - 0x10]
  0701F7  06B7: ff76f4           push word ptr [bp - 0xc]
  0701FA  06BA: 0e               push cs
  0701FB  06BB: e8430a           call 0x1101
  0701FE  06BE: 83c408           add sp, 8
  070201  06C1: 6a30             push 0x30
  070203  06C3: 6a48             push 0x48
  070205  06C5: ff76f2           push word ptr [bp - 0xe]
  070208  06C8: ff76f6           push word ptr [bp - 0xa]
  07020B  06CB: 9aca031f18       lcall 0x181f, 0x3ca
  070210  06D0: 83c408           add sp, 8
  070213  06D3: 0bc0             or ax, ax
  070215  06D5: 74c9             je 0x6a0
  070217  06D7: 8b46f0           mov ax, word ptr [bp - 0x10]
  07021A  06DA: 8b5ef4           mov bx, word ptr [bp - 0xc]
  07021D  06DD: d1e3             shl bx, 1
  07021F  06DF: 39877e1e         cmp word ptr [bx + 0x1e7e], ax
  070223  06E3: 74bb             je 0x6a0
  070225  06E5: 8b8f7e1e         mov cx, word ptr [bx + 0x1e7e]
  070229  06E9: 894efe           mov word ptr [bp - 2], cx
  07022C  06EC: 8b0e0aa6         mov cx, word ptr [0xa60a]
  070230  06F0: 894ef8           mov word ptr [bp - 8], cx
  070233  06F3: 8b4ef4           mov cx, word ptr [bp - 0xc]
  070236  06F6: 890e0aa6         mov word ptr [0xa60a], cx
  07023A  06FA: 89877e1e         mov word ptr [bx + 0x1e7e], ax
  07023E  06FE: ff76fe           push word ptr [bp - 2]
  070241  0701: 51               push cx
  070242  0702: 0e               push cs
  070243  0703: e8050a           call 0x110b
  070246  0706: 83c404           add sp, 4
  070249  0709: 8b5ef8           mov bx, word ptr [bp - 8]
  07024C  070C: d1e3             shl bx, 1
  07024E  070E: ffb77e1e         push word ptr [bx + 0x1e7e]
  070252  0712: ff76f8           push word ptr [bp - 8]
  070255  0715: 0e               push cs
  070256  0716: e8f209           call 0x110b
  070259  0719: 83c404           add sp, 4
  07025C  071C: ff76f0           push word ptr [bp - 0x10]
  07025F  071F: ff76f4           push word ptr [bp - 0xc]
  070262  0722: 0e               push cs
  070263  0723: e8e509           call 0x110b
  070266  0726: 83c404           add sp, 4
  070269  0729: e974ff           jmp 0x6a0
  07026C  072C: ff46f4           inc word ptr [bp - 0xc]
  07026F  072F: 837ef404         cmp word ptr [bp - 0xc], 4
  070273  0733: 7d09             jge 0x73e
  070275  0735: c746f00000       mov word ptr [bp - 0x10], 0
  07027A  073A: e966ff           jmp 0x6a3
  07027D  073D: 90               nop 
  07027E  073E: 833ef40700       cmp word ptr [0x7f4], 0
  070283  0743: 740d             je 0x752
  070285  0745: 813eea07b900     cmp word ptr [0x7ea], 0xb9
  07028B  074B: 7c05             jl 0x752
  07028D  074D: c746fa0000       mov word ptr [bp - 6], 0
  070292  0752: 2bc0             sub ax, ax
  070294  0754: 8b56fa           mov dx, word ptr [bp - 6]
  070297  0757: 9a5c041f18       lcall 0x181f, 0x45c
  07029C  075C: 837efa00         cmp word ptr [bp - 6], 0
  0702A0  0760: 7403             je 0x765
  0702A2  0762: e950fe           jmp 0x5b5
  0702A5  0765: c746fc0000       mov word ptr [bp - 4], 0
  0702AA  076A: 9ab6031f18       lcall 0x181f, 0x3b6
  0702AF  076F: 6800a0           push 0xa000
  0702B2  0772: 6800fc           push 0xfc00
  0702B5  0775: 9af4031f18       lcall 0x181f, 0x3f4
  0702BA  077A: 8b46fc           mov ax, word ptr [bp - 4]
  0702BD  077D: c9               leave 
  0702BE  077E: cb               retf 

; ---- func_0702C0  size=66  insns=31  prologue=ENTER 0x0006,0  terminal=RETF ----
  0702C0  0780: c8060000         enter 6, 0
  0702C4  0784: 56               push si
  0702C5  0785: 8b4606           mov ax, word ptr [bp + 6]
  0702C8  0788: 40               inc ax
  0702C9  0789: b90300           mov cx, 3
  0702CC  078C: 8bd8             mov bx, ax
  0702CE  078E: 99               cdq 
  0702CF  078F: f7f9             idiv cx
  0702D1  0791: 8bd0             mov dx, ax
  0702D3  0793: 8bc3             mov ax, bx
  0702D5  0795: 8bda             mov bx, dx
  0702D7  0797: 99               cdq 
  0702D8  0798: f7f9             idiv cx
  0702DA  079A: 6bc269           imul ax, dx, 0x69
  0702DD  079D: 051700           add ax, 0x17
  0702E0  07A0: 8b7608           mov si, word ptr [bp + 8]
  0702E3  07A3: 8904             mov word ptr [si], ax
  0702E5  07A5: 83fb01           cmp bx, 1
  0702E8  07A8: 7e06             jle 0x7b0
  0702EA  07AA: b8ffff           mov ax, 0xffff
  0702ED  07AD: eb03             jmp 0x7b2
  0702EF  07AF: 90               nop 
  0702F0  07B0: 2bc0             sub ax, ax
  0702F2  07B2: 6bcb60           imul cx, bx, 0x60
  0702F5  07B5: 03c1             add ax, cx
  0702F7  07B7: 050700           add ax, 7
  0702FA  07BA: 8b5e0a           mov bx, word ptr [bp + 0xa]
  0702FD  07BD: 8907             mov word ptr [bx], ax
  0702FF  07BF: 5e               pop si
  070300  07C0: c9               leave 
  070301  07C1: cb               retf 

; ---- func_070302  size=402  insns=150  prologue=ENTER 0x0058,0  terminal=RETF ----
  070302  07C2: c8580000         enter 0x58, 0
  070306  07C6: 57               push di
  070307  07C7: 56               push si
  070308  07C8: 8d46aa           lea ax, [bp - 0x56]
  07030B  07CB: 50               push ax
  07030C  07CC: 8d4eac           lea cx, [bp - 0x54]
  07030F  07CF: 51               push cx
  070310  07D0: ff7606           push word ptr [bp + 6]
  070313  07D3: 0e               push cs
  070314  07D4: e82f09           call 0x1106
  070317  07D7: 83c406           add sp, 6
  07031A  07DA: ff36a483         push word ptr [0x83a4]
  07031E  07DE: ff36a283         push word ptr [0x83a2]
  070322  07E2: ff36a083         push word ptr [0x83a0]
  070326  07E6: ff369e83         push word ptr [0x839e]
  07032A  07EA: ff36ae2d         push word ptr [0x2dae]
  07032E  07EE: ff36ac2d         push word ptr [0x2dac]
  070332  07F2: ff36aa2d         push word ptr [0x2daa]
  070336  07F6: ff36a82d         push word ptr [0x2da8]
  07033A  07FA: 6a5a             push 0x5a
  07033C  07FC: 8b46ac           mov ax, word ptr [bp - 0x54]
  07033F  07FF: 8b56aa           mov dx, word ptr [bp - 0x56]
  070342  0802: bb4400           mov bx, 0x44
  070345  0805: 9a44041f18       lcall 0x181f, 0x444
  07034A  080A: 8b4606           mov ax, word ptr [bp + 6]
  07034D  080D: 0bc0             or ax, ax
  07034F  080F: 740b             je 0x81c
  070351  0811: 48               dec ax
  070352  0812: 740e             je 0x822
  070354  0814: 48               dec ax
  070355  0815: 7411             je 0x828
  070357  0817: 48               dec ax
  070358  0818: 7414             je 0x82e
  07035A  081A: eb18             jmp 0x834
  07035C  081C: c646a80a         mov byte ptr [bp - 0x58], 0xa
  070360  0820: eb16             jmp 0x838
  070362  0822: c646a809         mov byte ptr [bp - 0x58], 9
  070366  0826: eb10             jmp 0x838
  070368  0828: c646a80e         mov byte ptr [bp - 0x58], 0xe
  07036C  082C: eb0a             jmp 0x838
  07036E  082E: c646a80d         mov byte ptr [bp - 0x58], 0xd
  070372  0832: eb04             jmp 0x838
  070374  0834: c646a80c         mov byte ptr [bp - 0x58], 0xc
  070378  0838: a0a653           mov al, byte ptr [0x53a6]
  07037B  083B: 2ae4             sub ah, ah
  07037D  083D: 3b4606           cmp ax, word ptr [bp + 6]
  070380  0840: 7403             je 0x845
  070382  0842: e9f700           jmp 0x93c
  070385  0845: ff36ae2d         push word ptr [0x2dae]
  070389  0849: ff36ac2d         push word ptr [0x2dac]
  07038D  084D: ff36aa2d         push word ptr [0x2daa]
  070391  0851: ff36a82d         push word ptr [0x2da8]
  070395  0855: 8b46aa           mov ax, word ptr [bp - 0x56]
  070398  0858: 055900           add ax, 0x59
  07039B  085B: 50               push ax
  07039C  085C: 8a46a8           mov al, byte ptr [bp - 0x58]
  07039F  085F: 50               push ax
  0703A0  0860: 8b46ac           mov ax, word ptr [bp - 0x54]
  0703A3  0863: 8bd8             mov bx, ax
  0703A5  0865: 83c343           add bx, 0x43
  0703A8  0868: 8b56aa           mov dx, word ptr [bp - 0x56]
  0703AB  086B: 9ace001f18       lcall 0x181f, 0xce
  0703B0  0870: c41e9e08         les bx, ptr [0x89e]
  0703B4  0874: 268a07           mov al, byte ptr es:[bx]
  0703B7  0877: 2ae4             sub ah, ah
  0703B9  0879: 2b46aa           sub ax, word ptr [bp - 0x56]
  0703BC  087C: f7d8             neg ax
  0703BE  087E: 052c00           add ax, 0x2c
  0703C1  0881: 8946ae           mov word ptr [bp - 0x52], ax
  0703C4  0884: c646b000         mov byte ptr [bp - 0x50], 0
  0703C8  0888: 8b5e06           mov bx, word ptr [bp + 6]
  0703CB  088B: d1e3             shl bx, 1
  0703CD  088D: ffb79483         push word ptr [bx - 0x7c6c]
  0703D1  0891: 8d46b0           lea ax, [bp - 0x50]
  0703D4  0894: 50               push ax
  0703D5  0895: 8bf3             mov si, bx
  0703D7  0897: 9a6e011f18       lcall 0x181f, 0x16e
  0703DC  089C: 83c404           add sp, 4
  0703DF  089F: 8d46b0           lea ax, [bp - 0x50]
  0703E2  08A2: 50               push ax
  0703E3  08A3: 9a640d1d0d       lcall 0xd1d, 0xd64
  0703E8  08A8: 83c402           add sp, 2
  0703EB  08AB: 682b20           push 0x202b
  0703EE  08AE: 8d46b0           lea ax, [bp - 0x50]
  0703F1  08B1: 50               push ax
  0703F2  08B2: 9aa4071d0d       lcall 0xd1d, 0x7a4
  0703F7  08B7: 83c404           add sp, 4
  0703FA  08BA: 6a00             push 0
  0703FC  08BC: ff76ae           push word ptr [bp - 0x52]
  0703FF  08BF: 6a44             push 0x44
  070401  08C1: 8b46ac           mov ax, word ptr [bp - 0x54]
  070404  08C4: 40               inc ax
  070405  08C5: 50               push ax
  070406  08C6: 8d46b0           lea ax, [bp - 0x50]
  070409  08C9: 16               push ss
  07040A  08CA: 50               push ax
  07040B  08CB: 9a00011f18       lcall 0x181f, 0x100
  070410  08D0: 83c40c           add sp, 0xc
  070413  08D3: 8a46a8           mov al, byte ptr [bp - 0x58]
  070416  08D6: 2ae4             sub ah, ah
  070418  08D8: 50               push ax
  070419  08D9: ff76ae           push word ptr [bp - 0x52]
  07041C  08DC: 6a44             push 0x44
  07041E  08DE: ff76ac           push word ptr [bp - 0x54]
  070421  08E1: 8d4eb0           lea cx, [bp - 0x50]
  070424  08E4: 16               push ss
  070425  08E5: 51               push cx
  070426  08E6: 8bf8             mov di, ax
  070428  08E8: 9a00011f18       lcall 0x181f, 0x100
  07042D  08ED: 83c40c           add sp, 0xc
  070430  08F0: 8b46aa           mov ax, word ptr [bp - 0x56]
  070433  08F3: 052e00           add ax, 0x2e
  070436  08F6: 8946ae           mov word ptr [bp - 0x52], ax
  070439  08F9: c646b000         mov byte ptr [bp - 0x50], 0
  07043D  08FD: ffb4042f         push word ptr [si + 0x2f04]
  070441  0901: 8d46b0           lea ax, [bp - 0x50]
  070444  0904: 50               push ax
  070445  0905: 9a6e011f18       lcall 0x181f, 0x16e
  07044A  090A: 83c404           add sp, 4
  07044D  090D: 6a00             push 0
  07044F  090F: ff76ae           push word ptr [bp - 0x52]
  070452  0912: 6a44             push 0x44
  070454  0914: 8b46ac           mov ax, word ptr [bp - 0x54]
  070457  0917: 40               inc ax
  070458  0918: 50               push ax
  070459  0919: 8d46b0           lea ax, [bp - 0x50]
  07045C  091C: 16               push ss
  07045D  091D: 50               push ax
  07045E  091E: 9a00011f18       lcall 0x181f, 0x100
  070463  0923: 83c40c           add sp, 0xc
  070466  0926: 57               push di
  070467  0927: ff76ae           push word ptr [bp - 0x52]
  07046A  092A: 6a44             push 0x44
  07046C  092C: ff76ac           push word ptr [bp - 0x54]
  07046F  092F: 8d46b0           lea ax, [bp - 0x50]
  070472  0932: 16               push ss
  070473  0933: 50               push ax
  070474  0934: 9a00011f18       lcall 0x181f, 0x100
  070479  0939: 83c40c           add sp, 0xc
  07047C  093C: ff76aa           push word ptr [bp - 0x56]
  07047F  093F: 6a44             push 0x44
  070481  0941: 6a5a             push 0x5a
  070483  0943: 8b46ac           mov ax, word ptr [bp - 0x54]
  070486  0946: 8b56aa           mov dx, word ptr [bp - 0x56]
  070489  0949: 8bd8             mov bx, ax
  07048B  094B: 9ae2001f18       lcall 0x181f, 0xe2
  070490  0950: 5e               pop si
  070491  0951: 5f               pop di
  070492  0952: c9               leave 
  070493  0953: cb               retf 

; ---- func_070494  size=236  insns=86  prologue=ENTER 0x0062,0  terminal=RETF ----
  070494  0954: c8620000         enter 0x62, 0
  070498  0958: c41e8a26         les bx, ptr [0x268a]
  07049C  095C: 268a07           mov al, byte ptr es:[bx]
  07049F  095F: 8bc8             mov cx, ax
  0704A1  0961: d0e8             shr al, 1
  0704A3  0963: 2ae4             sub ah, ah
  0704A5  0965: 2d1400           sub ax, 0x14
  0704A8  0968: f7d8             neg ax
  0704AA  096A: 8946a6           mov word ptr [bp - 0x5a], ax
  0704AD  096D: 2aed             sub ch, ch
  0704AF  096F: 8bd0             mov dx, ax
  0704B1  0971: 03c1             add ax, cx
  0704B3  0973: 050400           add ax, 4
  0704B6  0976: 8946a2           mov word ptr [bp - 0x5e], ax
  0704B9  0979: 03c8             add cx, ax
  0704BB  097B: 83c104           add cx, 4
  0704BE  097E: 894ea0           mov word ptr [bp - 0x60], cx
  0704C1  0981: c6469efe         mov byte ptr [bp - 0x62], 0xfe
  0704C5  0985: 68fd00           push 0xfd
  0704C8  0988: 68fe00           push 0xfe
  0704CB  098B: 52               push dx
  0704CC  098C: b84400           mov ax, 0x44
  0704CF  098F: 8946fe           mov word ptr [bp - 2], ax
  0704D2  0992: 50               push ax
  0704D3  0993: b81700           mov ax, 0x17
  0704D6  0996: 8946aa           mov word ptr [bp - 0x56], ax
  0704D9  0999: 50               push ax
  0704DA  099A: ff36fe2e         push word ptr [0x2efe]
  0704DE  099E: 9a22001f18       lcall 0x181f, 0x22
  0704E3  09A3: 83c402           add sp, 2
  0704E6  09A6: 52               push dx
  0704E7  09A7: 50               push ax
  0704E8  09A8: 9ac8011f18       lcall 0x181f, 0x1c8
  0704ED  09AD: 83c40e           add sp, 0xe
  0704F0  09B0: 68fd00           push 0xfd
  0704F3  09B3: 68fe00           push 0xfe
  0704F6  09B6: ff76a2           push word ptr [bp - 0x5e]
  0704F9  09B9: 6a44             push 0x44
  0704FB  09BB: 6a17             push 0x17
  0704FD  09BD: ff36002f         push word ptr [0x2f00]
  070501  09C1: 9a22001f18       lcall 0x181f, 0x22
  070506  09C6: 83c402           add sp, 2
  070509  09C9: 52               push dx
  07050A  09CA: 50               push ax
  07050B  09CB: 9ac8011f18       lcall 0x181f, 0x1c8
  070510  09D0: 83c40e           add sp, 0xe
  070513  09D3: c646ae00         mov byte ptr [bp - 0x52], 0
  070517  09D7: 8d46ae           lea ax, [bp - 0x52]
  07051A  09DA: 50               push ax
  07051B  09DB: 9a1e011f18       lcall 0x181f, 0x11e
  070520  09E0: 83c402           add sp, 2
  070523  09E3: ff36fc2e         push word ptr [0x2efc]
  070527  09E7: 8d46ae           lea ax, [bp - 0x52]
  07052A  09EA: 50               push ax
  07052B  09EB: 9a6e011f18       lcall 0x181f, 0x16e
  070530  09F0: 83c404           add sp, 4
  070533  09F3: 8d46ae           lea ax, [bp - 0x52]
  070536  09F6: 50               push ax
  070537  09F7: 9a28011f18       lcall 0x181f, 0x128
  07053C  09FC: 83c402           add sp, 2
  07053F  09FF: 68fe00           push 0xfe
  070542  0A02: 6a51             push 0x51
  070544  0A04: 6a44             push 0x44
  070546  0A06: 6a17             push 0x17
  070548  0A08: 8d46ae           lea ax, [bp - 0x52]
  07054B  0A0B: 16               push ss
  07054C  0A0C: 50               push ax
  07054D  0A0D: 9a00011f18       lcall 0x181f, 0x100
  070552  0A12: 83c40c           add sp, 0xc
  070555  0A15: 6a00             push 0
  070557  0A17: 688000           push 0x80
  07055A  0A1A: 6a67             push 0x67
  07055C  0A1C: 2bc0             sub ax, ax
  07055E  0A1E: 99               cdq 
  07055F  0A1F: 2bdb             sub bx, bx
  070561  0A21: 9ae2001f18       lcall 0x181f, 0xe2
  070566  0A26: c746ac0000       mov word ptr [bp - 0x54], 0
  07056B  0A2B: ff76ac           push word ptr [bp - 0x54]
  07056E  0A2E: 0e               push cs
  07056F  0A2F: e8de06           call 0x1110
  070572  0A32: 83c402           add sp, 2
  070575  0A35: ff46ac           inc word ptr [bp - 0x54]
  070578  0A38: 837eac05         cmp word ptr [bp - 0x54], 5
  07057C  0A3C: 7ced             jl 0xa2b
  07057E  0A3E: c9               leave 
  07057F  0A3F: cb               retf 

; ---- func_070580  size=514  insns=181  prologue=ENTER 0x0312,0  terminal=RETF ----
  070580  0A40: c8120300         enter 0x312, 0
  070584  0A44: c746fa0100       mov word ptr [bp - 6], 1
  070589  0A49: 8d86f0fc         lea ax, [bp - 0x310]
  07058D  0A4D: 16               push ss
  07058E  0A4E: 50               push ax
  07058F  0A4F: 2bc0             sub ax, ax
  070591  0A51: a30aa6           mov word ptr [0xa60a], ax
  070594  0A54: 50               push ax
  070595  0A55: ff36a483         push word ptr [0x83a4]
  070599  0A59: ff36a283         push word ptr [0x83a2]
  07059D  0A5D: ff36a083         push word ptr [0x83a0]
  0705A1  0A61: ff369e83         push word ptr [0x839e]
  0705A5  0A65: 682d20           push 0x202d
  0705A8  0A68: 9a4e041f18       lcall 0x181f, 0x44e
  0705AD  0A6D: 83c410           add sp, 0x10
  0705B0  0A70: 0bc0             or ax, ax
  0705B2  0A72: 7424             je 0xa98
  0705B4  0A74: 8d1e7c08         lea bx, [0x87c]
  0705B8  0A78: 8d063620         lea ax, [0x2036]
  0705BC  0A7C: 2bd2             sub dx, dx
  0705BE  0A7E: 9a98091f18       lcall 0x181f, 0x998
  0705C3  0A83: 8946fe           mov word ptr [bp - 2], ax
  0705C6  0A86: 0bc0             or ax, ax
  0705C8  0A88: 7f03             jg 0xa8d
  0705CA  0A8A: e9a001           jmp 0xc2d
  0705CD  0A8D: 8a46fe           mov al, byte ptr [bp - 2]
  0705D0  0A90: fec8             dec al
  0705D2  0A92: a2a653           mov byte ptr [0x53a6], al
  0705D5  0A95: e99001           jmp 0xc28
  0705D8  0A98: 9ab6031f18       lcall 0x181f, 0x3b6
  0705DD  0A9D: 8d86f0fc         lea ax, [bp - 0x310]
  0705E1  0AA1: 16               push ss
  0705E2  0AA2: 50               push ax
  0705E3  0AA3: 9af4031f18       lcall 0x181f, 0x3f4
  0705E8  0AA8: ff36a483         push word ptr [0x83a4]
  0705EC  0AAC: ff36a283         push word ptr [0x83a2]
  0705F0  0AB0: ff36a083         push word ptr [0x83a0]
  0705F4  0AB4: ff369e83         push word ptr [0x839e]
  0705F8  0AB8: ff36ae2d         push word ptr [0x2dae]
  0705FC  0ABC: ff36ac2d         push word ptr [0x2dac]
  070600  0AC0: ff36aa2d         push word ptr [0x2daa]
  070604  0AC4: ff36a82d         push word ptr [0x2da8]
  070608  0AC8: 68c800           push 0xc8
  07060B  0ACB: 2bc0             sub ax, ax
  07060D  0ACD: 99               cdq 
  07060E  0ACE: bb4001           mov bx, 0x140
  070611  0AD1: 9a44041f18       lcall 0x181f, 0x444
  070616  0AD6: 6a00             push 0
  070618  0AD8: 684001           push 0x140
  07061B  0ADB: 68c800           push 0xc8
  07061E  0ADE: 2bc0             sub ax, ax
  070620  0AE0: 99               cdq 
  070621  0AE1: 2bdb             sub bx, bx
  070623  0AE3: 9ae2001f18       lcall 0x181f, 0xe2
  070628  0AE8: 0e               push cs
  070629  0AE9: e83806           call 0x1124
  07062C  0AEC: 9a7a041f18       lcall 0x181f, 0x47a
  070631  0AF1: c746f80100       mov word ptr [bp - 8], 1
  070636  0AF6: 2bc0             sub ax, ax
  070638  0AF8: 9a66041f18       lcall 0x181f, 0x466
  07063D  0AFD: a10aa6           mov ax, word ptr [0xa60a]
  070640  0B00: 8946fc           mov word ptr [bp - 4], ax
  070643  0B03: 9af6001f18       lcall 0x181f, 0xf6
  070648  0B08: 0bc0             or ax, ax
  07064A  0B0A: 742b             je 0xb37
  07064C  0B0C: 9ae0031f18       lcall 0x181f, 0x3e0
  070651  0B11: 8986eefc         mov word ptr [bp - 0x312], ax
  070655  0B15: 3d2000           cmp ax, 0x20
  070658  0B18: 7466             je 0xb80
  07065A  0B1A: 7f70             jg 0xb8c
  07065C  0B1C: 3d1b00           cmp ax, 0x1b
  07065F  0B1F: 7503             jne 0xb24
  070661  0B21: e90901           jmp 0xc2d
  070664  0B24: 7711             ja 0xb37
  070666  0B26: 2c08             sub al, 8
  070668  0B28: 7428             je 0xb52
  07066A  0B2A: fec8             dec al
  07066C  0B2C: 7452             je 0xb80
  07066E  0B2E: 2c04             sub al, 4
  070670  0B30: 7505             jne 0xb37
  070672  0B32: c746f80000       mov word ptr [bp - 8], 0
  070677  0B37: 833ef00700       cmp word ptr [0x7f0], 0
  07067C  0B3C: 7503             jne 0xb41
  07067E  0B3E: e9d400           jmp 0xc15
  070681  0B41: 833ef60700       cmp word ptr [0x7f6], 0
  070686  0B46: 7503             jne 0xb4b
  070688  0B48: e9ca00           jmp 0xc15
  07068B  0B4B: c746f20000       mov word ptr [bp - 0xe], 0
  070690  0B50: eb53             jmp 0xba5
  070692  0B52: a0a653           mov al, byte ptr [0x53a6]
  070695  0B55: 2ae4             sub ah, ah
  070697  0B57: 8946fc           mov word ptr [bp - 4], ax
  07069A  0B5A: 050400           add ax, 4
  07069D  0B5D: b90500           mov cx, 5
  0706A0  0B60: 99               cdq 
  0706A1  0B61: f7f9             idiv cx
  0706A3  0B63: 8816a653         mov byte ptr [0x53a6], dl
  0706A7  0B67: ff76fc           push word ptr [bp - 4]
  0706AA  0B6A: 0e               push cs
  0706AB  0B6B: e8a205           call 0x1110
  0706AE  0B6E: 83c402           add sp, 2
  0706B1  0B71: a0a653           mov al, byte ptr [0x53a6]
  0706B4  0B74: 2ae4             sub ah, ah
  0706B6  0B76: 50               push ax
  0706B7  0B77: 0e               push cs
  0706B8  0B78: e89505           call 0x1110
  0706BB  0B7B: 83c402           add sp, 2
  0706BE  0B7E: ebb7             jmp 0xb37
  0706C0  0B80: a0a653           mov al, byte ptr [0x53a6]
  0706C3  0B83: 2ae4             sub ah, ah
  0706C5  0B85: 8946fc           mov word ptr [bp - 4], ax
  0706C8  0B88: 40               inc ax
  0706C9  0B89: ebd2             jmp 0xb5d
  0706CB  0B8B: 90               nop 
  0706CC  0B8C: 2d4801           sub ax, 0x148
  0706CF  0B8F: 74c1             je 0xb52
  0706D1  0B91: 2d0300           sub ax, 3
  0706D4  0B94: 74bc             je 0xb52
  0706D6  0B96: 48               dec ax
  0706D7  0B97: 48               dec ax
  0706D8  0B98: 74e6             je 0xb80
  0706DA  0B9A: 2d0300           sub ax, 3
  0706DD  0B9D: 74e1             je 0xb80
  0706DF  0B9F: eb96             jmp 0xb37
  0706E1  0BA1: 90               nop 
  0706E2  0BA2: ff46f2           inc word ptr [bp - 0xe]
  0706E5  0BA5: 837ef205         cmp word ptr [bp - 0xe], 5
  0706E9  0BA9: 7d4f             jge 0xbfa
  0706EB  0BAB: 8d46f0           lea ax, [bp - 0x10]
  0706EE  0BAE: 50               push ax
  0706EF  0BAF: 8d4ef4           lea cx, [bp - 0xc]
  0706F2  0BB2: 51               push cx
  0706F3  0BB3: ff76f2           push word ptr [bp - 0xe]
  0706F6  0BB6: 0e               push cs
  0706F7  0BB7: e84c05           call 0x1106
  0706FA  0BBA: 83c406           add sp, 6
  0706FD  0BBD: 6a5a             push 0x5a
  0706FF  0BBF: 6a44             push 0x44
  070701  0BC1: ff76f0           push word ptr [bp - 0x10]
  070704  0BC4: ff76f4           push word ptr [bp - 0xc]
  070707  0BC7: 9aca031f18       lcall 0x181f, 0x3ca
  07070C  0BCC: 83c408           add sp, 8
  07070F  0BCF: 0bc0             or ax, ax
  070711  0BD1: 74cf             je 0xba2
  070713  0BD3: a0a653           mov al, byte ptr [0x53a6]
  070716  0BD6: 2ae4             sub ah, ah
  070718  0BD8: 8946fc           mov word ptr [bp - 4], ax
  07071B  0BDB: 8a46f2           mov al, byte ptr [bp - 0xe]
  07071E  0BDE: a2a653           mov byte ptr [0x53a6], al
  070721  0BE1: ff76fc           push word ptr [bp - 4]
  070724  0BE4: 0e               push cs
  070725  0BE5: e82805           call 0x1110
  070728  0BE8: 83c402           add sp, 2
  07072B  0BEB: a0a653           mov al, byte ptr [0x53a6]
  07072E  0BEE: 2ae4             sub ah, ah
  070730  0BF0: 50               push ax
  070731  0BF1: 0e               push cs
  070732  0BF2: e81b05           call 0x1110
  070735  0BF5: 83c402           add sp, 2
  070738  0BF8: eba8             jmp 0xba2
  07073A  0BFA: 833ef40700       cmp word ptr [0x7f4], 0
  07073F  0BFF: 7414             je 0xc15
  070741  0C01: 833eea0767       cmp word ptr [0x7ea], 0x67
  070746  0C06: 7d0d             jge 0xc15
  070748  0C08: 813ee8078000     cmp word ptr [0x7e8], 0x80
  07074E  0C0E: 7d05             jge 0xc15
  070750  0C10: c746f80000       mov word ptr [bp - 8], 0
  070755  0C15: 2bc0             sub ax, ax
  070757  0C17: 8b56f8           mov dx, word ptr [bp - 8]
  07075A  0C1A: 9a5c041f18       lcall 0x181f, 0x45c
  07075F  0C1F: 837ef800         cmp word ptr [bp - 8], 0
  070763  0C23: 7403             je 0xc28
  070765  0C25: e9cefe           jmp 0xaf6
  070768  0C28: c746fa0000       mov word ptr [bp - 6], 0
  07076D  0C2D: 9ab6031f18       lcall 0x181f, 0x3b6
  070772  0C32: 6800a0           push 0xa000
  070775  0C35: 6800fc           push 0xfc00
  070778  0C38: 9af4031f18       lcall 0x181f, 0x3f4
  07077D  0C3D: 8b46fa           mov ax, word ptr [bp - 6]
  070780  0C40: c9               leave 
  070781  0C41: cb               retf 

; ---- func_070782  size=51  insns=23  prologue=ENTER 0x0004,0  terminal=RETF ----
  070782  0C42: c8040000         enter 4, 0
  070786  0C46: 56               push si
  070787  0C47: 8b4606           mov ax, word ptr [bp + 6]
  07078A  0C4A: 99               cdq 
  07078B  0C4B: 2bc2             sub ax, dx
  07078D  0C4D: d1f8             sar ax, 1
  07078F  0C4F: b90200           mov cx, 2
  070792  0C52: 8bd0             mov dx, ax
  070794  0C54: 8b4606           mov ax, word ptr [bp + 6]
  070797  0C57: 8bda             mov bx, dx
  070799  0C59: 99               cdq 
  07079A  0C5A: f7f9             idiv cx
  07079C  0C5C: 6bc263           imul ax, dx, 0x63
  07079F  0C5F: 057000           add ax, 0x70
  0707A2  0C62: 8b7608           mov si, word ptr [bp + 8]
  0707A5  0C65: 8904             mov word ptr [si], ax
  0707A7  0C67: 6bc35b           imul ax, bx, 0x5b
  0707AA  0C6A: 050d00           add ax, 0xd
  0707AD  0C6D: 8b5e0a           mov bx, word ptr [bp + 0xa]
  0707B0  0C70: 8907             mov word ptr [bx], ax
  0707B2  0C72: 5e               pop si
  0707B3  0C73: c9               leave 
  0707B4  0C74: cb               retf 

; ---- func_0707B6  size=376  insns=138  prologue=ENTER 0x0058,0  terminal=RETF ----
  0707B6  0C76: c8580000         enter 0x58, 0
  0707BA  0C7A: 57               push di
  0707BB  0C7B: 56               push si
  0707BC  0C7C: 837e0600         cmp word ptr [bp + 6], 0
  0707C0  0C80: 7d03             jge 0xc85
  0707C2  0C82: e96501           jmp 0xdea
  0707C5  0C85: 837e0603         cmp word ptr [bp + 6], 3
  0707C9  0C89: 7e03             jle 0xc8e
  0707CB  0C8B: e95c01           jmp 0xdea
  0707CE  0C8E: 8d46aa           lea ax, [bp - 0x56]
  0707D1  0C91: 50               push ax
  0707D2  0C92: 8d4eac           lea cx, [bp - 0x54]
  0707D5  0C95: 51               push cx
  0707D6  0C96: ff7606           push word ptr [bp + 6]
  0707D9  0C99: 0e               push cs
  0707DA  0C9A: e87d04           call 0x111a
  0707DD  0C9D: 83c406           add sp, 6
  0707E0  0CA0: ff36a483         push word ptr [0x83a4]
  0707E4  0CA4: ff36a283         push word ptr [0x83a2]
  0707E8  0CA8: ff36a083         push word ptr [0x83a0]
  0707EC  0CAC: ff369e83         push word ptr [0x839e]
  0707F0  0CB0: ff36ae2d         push word ptr [0x2dae]
  0707F4  0CB4: ff36ac2d         push word ptr [0x2dac]
  0707F8  0CB8: ff36aa2d         push word ptr [0x2daa]
  0707FC  0CBC: ff36a82d         push word ptr [0x2da8]
  070800  0CC0: 6a52             push 0x52
  070802  0CC2: 8b46ac           mov ax, word ptr [bp - 0x54]
  070805  0CC5: 8b56aa           mov dx, word ptr [bp - 0x56]
  070808  0CC8: bb5800           mov bx, 0x58
  07080B  0CCB: 9a44041f18       lcall 0x181f, 0x444
  070810  0CD0: 8b5e06           mov bx, word ptr [bp + 6]
  070813  0CD3: 8a874808         mov al, byte ptr [bx + 0x848]
  070817  0CD7: 8846a8           mov byte ptr [bp - 0x58], al
  07081A  0CDA: 391e9853         cmp word ptr [0x5398], bx
  07081E  0CDE: 7403             je 0xce3
  070820  0CE0: e9f300           jmp 0xdd6
  070823  0CE3: ff36ae2d         push word ptr [0x2dae]
  070827  0CE7: ff36ac2d         push word ptr [0x2dac]
  07082B  0CEB: ff36aa2d         push word ptr [0x2daa]
  07082F  0CEF: ff36a82d         push word ptr [0x2da8]
  070833  0CF3: 8b4eaa           mov cx, word ptr [bp - 0x56]
  070836  0CF6: 83c151           add cx, 0x51
  070839  0CF9: 51               push cx
  07083A  0CFA: 50               push ax
  07083B  0CFB: 8b46ac           mov ax, word ptr [bp - 0x54]
  07083E  0CFE: 8bd8             mov bx, ax
  070840  0D00: 83c357           add bx, 0x57
  070843  0D03: 8b56aa           mov dx, word ptr [bp - 0x56]
  070846  0D06: 9ace001f18       lcall 0x181f, 0xce
  07084B  0D0B: 8b46aa           mov ax, word ptr [bp - 0x56]
  07084E  0D0E: 40               inc ax
  07084F  0D0F: 40               inc ax
  070850  0D10: 8946ae           mov word ptr [bp - 0x52], ax
  070853  0D13: c646b000         mov byte ptr [bp - 0x50], 0
  070857  0D17: 8b5e06           mov bx, word ptr [bp + 6]
  07085A  0D1A: d1e3             shl bx, 1
  07085C  0D1C: ffb7428d         push word ptr [bx - 0x72be]
  070860  0D20: 8d46b0           lea ax, [bp - 0x50]
  070863  0D23: 50               push ax
  070864  0D24: 8bf3             mov si, bx
  070866  0D26: 9a6e011f18       lcall 0x181f, 0x16e
  07086B  0D2B: 83c404           add sp, 4
  07086E  0D2E: 8d46b0           lea ax, [bp - 0x50]
  070871  0D31: 50               push ax
  070872  0D32: 9a640d1d0d       lcall 0xd1d, 0xd64
  070877  0D37: 83c402           add sp, 2
  07087A  0D3A: 684120           push 0x2041
  07087D  0D3D: 8d46b0           lea ax, [bp - 0x50]
  070880  0D40: 50               push ax
  070881  0D41: 9aa4071d0d       lcall 0xd1d, 0x7a4
  070886  0D46: 83c404           add sp, 4
  070889  0D49: 6a00             push 0
  07088B  0D4B: ff76ae           push word ptr [bp - 0x52]
  07088E  0D4E: 6a58             push 0x58
  070890  0D50: 8b46ac           mov ax, word ptr [bp - 0x54]
  070893  0D53: 40               inc ax
  070894  0D54: 50               push ax
  070895  0D55: 8d46b0           lea ax, [bp - 0x50]
  070898  0D58: 16               push ss
  070899  0D59: 50               push ax
  07089A  0D5A: 9a00011f18       lcall 0x181f, 0x100
  07089F  0D5F: 83c40c           add sp, 0xc
  0708A2  0D62: 8a46a8           mov al, byte ptr [bp - 0x58]
  0708A5  0D65: 2ae4             sub ah, ah
  0708A7  0D67: 50               push ax
  0708A8  0D68: ff76ae           push word ptr [bp - 0x52]
  0708AB  0D6B: 6a58             push 0x58
  0708AD  0D6D: ff76ac           push word ptr [bp - 0x54]
  0708B0  0D70: 8d4eb0           lea cx, [bp - 0x50]
  0708B3  0D73: 16               push ss
  0708B4  0D74: 51               push cx
  0708B5  0D75: 8bf8             mov di, ax
  0708B7  0D77: 9a00011f18       lcall 0x181f, 0x100
  0708BC  0D7C: 83c40c           add sp, 0xc
  0708BF  0D7F: c41e9e08         les bx, ptr [0x89e]
  0708C3  0D83: 268a07           mov al, byte ptr es:[bx]
  0708C6  0D86: 2ae4             sub ah, ah
  0708C8  0D88: 2b46aa           sub ax, word ptr [bp - 0x56]
  0708CB  0D8B: f7d8             neg ax
  0708CD  0D8D: 055000           add ax, 0x50
  0708D0  0D90: 8946ae           mov word ptr [bp - 0x52], ax
  0708D3  0D93: c646b000         mov byte ptr [bp - 0x50], 0
  0708D7  0D97: ffb4142f         push word ptr [si + 0x2f14]
  0708DB  0D9B: 8d46b0           lea ax, [bp - 0x50]
  0708DE  0D9E: 50               push ax
  0708DF  0D9F: 9a6e011f18       lcall 0x181f, 0x16e
  0708E4  0DA4: 83c404           add sp, 4
  0708E7  0DA7: 6a00             push 0
  0708E9  0DA9: ff76ae           push word ptr [bp - 0x52]
  0708EC  0DAC: 6a58             push 0x58
  0708EE  0DAE: 8b46ac           mov ax, word ptr [bp - 0x54]
  0708F1  0DB1: 40               inc ax
  0708F2  0DB2: 50               push ax
  0708F3  0DB3: 8d46b0           lea ax, [bp - 0x50]
  0708F6  0DB6: 16               push ss
  0708F7  0DB7: 50               push ax
  0708F8  0DB8: 9a00011f18       lcall 0x181f, 0x100
  0708FD  0DBD: 83c40c           add sp, 0xc
  070900  0DC0: 57               push di
  070901  0DC1: ff76ae           push word ptr [bp - 0x52]
  070904  0DC4: 6a58             push 0x58
  070906  0DC6: ff76ac           push word ptr [bp - 0x54]
  070909  0DC9: 8d46b0           lea ax, [bp - 0x50]
  07090C  0DCC: 16               push ss
  07090D  0DCD: 50               push ax
  07090E  0DCE: 9a00011f18       lcall 0x181f, 0x100
  070913  0DD3: 83c40c           add sp, 0xc
  070916  0DD6: ff76aa           push word ptr [bp - 0x56]
  070919  0DD9: 6a58             push 0x58
  07091B  0DDB: 6a52             push 0x52
  07091D  0DDD: 8b46ac           mov ax, word ptr [bp - 0x54]
  070920  0DE0: 8b56aa           mov dx, word ptr [bp - 0x56]
  070923  0DE3: 8bd8             mov bx, ax
  070925  0DE5: 9ae2001f18       lcall 0x181f, 0xe2
  07092A  0DEA: 5e               pop si
  07092B  0DEB: 5f               pop di
  07092C  0DEC: c9               leave 
  07092D  0DED: cb               retf 

; ---- func_07092E  size=236  insns=86  prologue=ENTER 0x0062,0  terminal=RETF ----
  07092E  0DEE: c8620000         enter 0x62, 0
  070932  0DF2: c41e8a26         les bx, ptr [0x268a]
  070936  0DF6: 268a07           mov al, byte ptr es:[bx]
  070939  0DF9: 8bc8             mov cx, ax
  07093B  0DFB: d0e8             shr al, 1
  07093D  0DFD: 2ae4             sub ah, ah
  07093F  0DFF: 2d2800           sub ax, 0x28
  070942  0E02: f7d8             neg ax
  070944  0E04: 8946a6           mov word ptr [bp - 0x5a], ax
  070947  0E07: 2aed             sub ch, ch
  070949  0E09: 8bd0             mov dx, ax
  07094B  0E0B: 03c1             add ax, cx
  07094D  0E0D: 050400           add ax, 4
  070950  0E10: 8946a2           mov word ptr [bp - 0x5e], ax
  070953  0E13: 03c8             add cx, ax
  070955  0E15: 83c104           add cx, 4
  070958  0E18: 894ea0           mov word ptr [bp - 0x60], cx
  07095B  0E1B: c6469efe         mov byte ptr [bp - 0x62], 0xfe
  07095F  0E1F: 68fd00           push 0xfd
  070962  0E22: 68fe00           push 0xfe
  070965  0E25: 52               push dx
  070966  0E26: b87000           mov ax, 0x70
  070969  0E29: 8946fe           mov word ptr [bp - 2], ax
  07096C  0E2C: 50               push ax
  07096D  0E2D: 2bc0             sub ax, ax
  07096F  0E2F: 8946aa           mov word ptr [bp - 0x56], ax
  070972  0E32: 50               push ax
  070973  0E33: ff360e2f         push word ptr [0x2f0e]
  070977  0E37: 9a22001f18       lcall 0x181f, 0x22
  07097C  0E3C: 83c402           add sp, 2
  07097F  0E3F: 52               push dx
  070980  0E40: 50               push ax
  070981  0E41: 9ac8011f18       lcall 0x181f, 0x1c8
  070986  0E46: 83c40e           add sp, 0xe
  070989  0E49: 68fd00           push 0xfd
  07098C  0E4C: 68fe00           push 0xfe
  07098F  0E4F: ff76a2           push word ptr [bp - 0x5e]
  070992  0E52: 6a70             push 0x70
  070994  0E54: 6a00             push 0
  070996  0E56: ff36102f         push word ptr [0x2f10]
  07099A  0E5A: 9a22001f18       lcall 0x181f, 0x22
  07099F  0E5F: 83c402           add sp, 2
  0709A2  0E62: 52               push dx
  0709A3  0E63: 50               push ax
  0709A4  0E64: 9ac8011f18       lcall 0x181f, 0x1c8
  0709A9  0E69: 83c40e           add sp, 0xe
  0709AC  0E6C: c646ae00         mov byte ptr [bp - 0x52], 0
  0709B0  0E70: 8d46ae           lea ax, [bp - 0x52]
  0709B3  0E73: 50               push ax
  0709B4  0E74: 9a1e011f18       lcall 0x181f, 0x11e
  0709B9  0E79: 83c402           add sp, 2
  0709BC  0E7C: ff36fc2e         push word ptr [0x2efc]
  0709C0  0E80: 8d46ae           lea ax, [bp - 0x52]
  0709C3  0E83: 50               push ax
  0709C4  0E84: 9a6e011f18       lcall 0x181f, 0x16e
  0709C9  0E89: 83c404           add sp, 4
  0709CC  0E8C: 8d46ae           lea ax, [bp - 0x52]
  0709CF  0E8F: 50               push ax
  0709D0  0E90: 9a28011f18       lcall 0x181f, 0x128
  0709D5  0E95: 83c402           add sp, 2
  0709D8  0E98: 68fe00           push 0xfe
  0709DB  0E9B: 68b600           push 0xb6
  0709DE  0E9E: 6a70             push 0x70
  0709E0  0EA0: 6a00             push 0
  0709E2  0EA2: 8d46ae           lea ax, [bp - 0x52]
  0709E5  0EA5: 16               push ss
  0709E6  0EA6: 50               push ax
  0709E7  0EA7: 9a00011f18       lcall 0x181f, 0x100
  0709EC  0EAC: 83c40c           add sp, 0xc
  0709EF  0EAF: 6a00             push 0
  0709F1  0EB1: 6a70             push 0x70
  0709F3  0EB3: 68c800           push 0xc8
  0709F6  0EB6: 2bc0             sub ax, ax
  0709F8  0EB8: 99               cdq 
  0709F9  0EB9: 2bdb             sub bx, bx
  0709FB  0EBB: 9ae2001f18       lcall 0x181f, 0xe2
  070A00  0EC0: c746ac0000       mov word ptr [bp - 0x54], 0
  070A05  0EC5: ff76ac           push word ptr [bp - 0x54]
  070A08  0EC8: 0e               push cs
  070A09  0EC9: e85302           call 0x111f
  070A0C  0ECC: 83c402           add sp, 2
  070A0F  0ECF: ff46ac           inc word ptr [bp - 0x54]
  070A12  0ED2: 837eac04         cmp word ptr [bp - 0x54], 4
  070A16  0ED6: 7ced             jl 0xec5
  070A18  0ED8: c9               leave 
  070A19  0ED9: cb               retf 

; ---- func_070A1A  size=665  insns=230  prologue=ENTER 0x0314,0  terminal=RETF ----
  070A1A  0EDA: c8140300         enter 0x314, 0
  070A1E  0EDE: c746f80100       mov word ptr [bp - 8], 1
  070A23  0EE3: 8d86eefc         lea ax, [bp - 0x312]
  070A27  0EE7: 16               push ss
  070A28  0EE8: 50               push ax
  070A29  0EE9: 2bc0             sub ax, ax
  070A2B  0EEB: a30aa6           mov word ptr [0xa60a], ax
  070A2E  0EEE: 50               push ax
  070A2F  0EEF: ff36a483         push word ptr [0x83a4]
  070A33  0EF3: ff36a283         push word ptr [0x83a2]
  070A37  0EF7: ff36a083         push word ptr [0x83a0]
  070A3B  0EFB: ff369e83         push word ptr [0x839e]
  070A3F  0EFF: 684320           push 0x2043
  070A42  0F02: 9a4e041f18       lcall 0x181f, 0x44e
  070A47  0F07: 83c410           add sp, 0x10
  070A4A  0F0A: 0bc0             or ax, ax
  070A4C  0F0C: 742c             je 0xf3a
  070A4E  0F0E: c7065c1f0400     mov word ptr [0x1f5c], 4
  070A54  0F14: 8d1e7c08         lea bx, [0x87c]
  070A58  0F18: 8d064b20         lea ax, [0x204b]
  070A5C  0F1C: 2bd2             sub dx, dx
  070A5E  0F1E: 9a98091f18       lcall 0x181f, 0x998
  070A63  0F23: 8946fe           mov word ptr [bp - 2], ax
  070A66  0F26: 0bc0             or ax, ax
  070A68  0F28: 7f03             jg 0xf2d
  070A6A  0F2A: e9ba01           jmp 0x10e7
  070A6D  0F2D: 8a46fe           mov al, byte ptr [bp - 2]
  070A70  0F30: fec8             dec al
  070A72  0F32: 2ae4             sub ah, ah
  070A74  0F34: a39853           mov word ptr [0x5398], ax
  070A77  0F37: e9a801           jmp 0x10e2
  070A7A  0F3A: 9ab6031f18       lcall 0x181f, 0x3b6
  070A7F  0F3F: 8d86eefc         lea ax, [bp - 0x312]
  070A83  0F43: 16               push ss
  070A84  0F44: 50               push ax
  070A85  0F45: 9af4031f18       lcall 0x181f, 0x3f4
  070A8A  0F4A: ff36a483         push word ptr [0x83a4]
  070A8E  0F4E: ff36a283         push word ptr [0x83a2]
  070A92  0F52: ff36a083         push word ptr [0x83a0]
  070A96  0F56: ff369e83         push word ptr [0x839e]
  070A9A  0F5A: ff36ae2d         push word ptr [0x2dae]
  070A9E  0F5E: ff36ac2d         push word ptr [0x2dac]
  070AA2  0F62: ff36aa2d         push word ptr [0x2daa]
  070AA6  0F66: ff36a82d         push word ptr [0x2da8]
  070AAA  0F6A: 68c800           push 0xc8
  070AAD  0F6D: 2bc0             sub ax, ax
  070AAF  0F6F: 99               cdq 
  070AB0  0F70: bb4001           mov bx, 0x140
  070AB3  0F73: 9a44041f18       lcall 0x181f, 0x444
  070AB8  0F78: 6a00             push 0
  070ABA  0F7A: 684001           push 0x140
  070ABD  0F7D: 68c800           push 0xc8
  070AC0  0F80: 2bc0             sub ax, ax
  070AC2  0F82: 99               cdq 
  070AC3  0F83: 2bdb             sub bx, bx
  070AC5  0F85: 9ae2001f18       lcall 0x181f, 0xe2
  070ACA  0F8A: 0e               push cs
  070ACB  0F8B: e86e01           call 0x10fc
  070ACE  0F8E: 9a7a041f18       lcall 0x181f, 0x47a
  070AD3  0F93: c746f60100       mov word ptr [bp - 0xa], 1
  070AD8  0F98: 2bc0             sub ax, ax
  070ADA  0F9A: 9a66041f18       lcall 0x181f, 0x466
  070ADF  0F9F: a10aa6           mov ax, word ptr [0xa60a]
  070AE2  0FA2: 8946fa           mov word ptr [bp - 6], ax
  070AE5  0FA5: 9af6001f18       lcall 0x181f, 0xf6
  070AEA  0FAA: 0bc0             or ax, ax
  070AEC  0FAC: 742e             je 0xfdc
  070AEE  0FAE: 9ae0031f18       lcall 0x181f, 0x3e0
  070AF3  0FB3: 8986ecfc         mov word ptr [bp - 0x314], ax
  070AF7  0FB7: 3d2000           cmp ax, 0x20
  070AFA  0FBA: 7476             je 0x1032
  070AFC  0FBC: 7e03             jle 0xfc1
  070AFE  0FBE: e98500           jmp 0x1046
  070B01  0FC1: 3d1b00           cmp ax, 0x1b
  070B04  0FC4: 7503             jne 0xfc9
  070B06  0FC6: e91e01           jmp 0x10e7
  070B09  0FC9: 7711             ja 0xfdc
  070B0B  0FCB: 2c08             sub al, 8
  070B0D  0FCD: 7429             je 0xff8
  070B0F  0FCF: fec8             dec al
  070B11  0FD1: 745f             je 0x1032
  070B13  0FD3: 2c04             sub al, 4
  070B15  0FD5: 7505             jne 0xfdc
  070B17  0FD7: c746f60000       mov word ptr [bp - 0xa], 0
  070B1C  0FDC: 833ef00700       cmp word ptr [0x7f0], 0
  070B21  0FE1: 7503             jne 0xfe6
  070B23  0FE3: e9e900           jmp 0x10cf
  070B26  0FE6: 833ef60700       cmp word ptr [0x7f6], 0
  070B2B  0FEB: 7503             jne 0xff0
  070B2D  0FED: e9df00           jmp 0x10cf
  070B30  0FF0: c746fc0000       mov word ptr [bp - 4], 0
  070B35  0FF5: eb68             jmp 0x105f
  070B37  0FF7: 90               nop 
  070B38  0FF8: 81beecfc4801     cmp word ptr [bp - 0x314], 0x148
  070B3E  0FFE: 743a             je 0x103a
  070B40  1000: b80300           mov ax, 3
  070B43  1003: 8946f0           mov word ptr [bp - 0x10], ax
  070B46  1006: 8b0e9853         mov cx, word ptr [0x5398]
  070B4A  100A: 894efa           mov word ptr [bp - 6], cx
  070B4D  100D: 03c1             add ax, cx
  070B4F  100F: b90400           mov cx, 4
  070B52  1012: 99               cdq 
  070B53  1013: f7f9             idiv cx
  070B55  1015: 2af6             sub dh, dh
  070B57  1017: 89169853         mov word ptr [0x5398], dx
  070B5B  101B: ff76fa           push word ptr [bp - 6]
  070B5E  101E: 0e               push cs
  070B5F  101F: e8fd00           call 0x111f
  070B62  1022: 83c402           add sp, 2
  070B65  1025: ff369853         push word ptr [0x5398]
  070B69  1029: 0e               push cs
  070B6A  102A: e8f200           call 0x111f
  070B6D  102D: 83c402           add sp, 2
  070B70  1030: ebaa             jmp 0xfdc
  070B72  1032: 81beecfc5001     cmp word ptr [bp - 0x314], 0x150
  070B78  1038: 7506             jne 0x1040
  070B7A  103A: b80200           mov ax, 2
  070B7D  103D: ebc4             jmp 0x1003
  070B7F  103F: 90               nop 
  070B80  1040: b80100           mov ax, 1
  070B83  1043: ebbe             jmp 0x1003
  070B85  1045: 90               nop 
  070B86  1046: 2d4801           sub ax, 0x148
  070B89  1049: 74ad             je 0xff8
  070B8B  104B: 2d0300           sub ax, 3
  070B8E  104E: 74a8             je 0xff8
  070B90  1050: 48               dec ax
  070B91  1051: 48               dec ax
  070B92  1052: 74de             je 0x1032
  070B94  1054: 2d0300           sub ax, 3
  070B97  1057: 74d9             je 0x1032
  070B99  1059: eb81             jmp 0xfdc
  070B9B  105B: 90               nop 
  070B9C  105C: ff46fc           inc word ptr [bp - 4]
  070B9F  105F: 833e1e2001       cmp word ptr [0x201e], 1
  070BA4  1064: 1bc0             sbb ax, ax
  070BA6  1066: 050500           add ax, 5
  070BA9  1069: 3b46fc           cmp ax, word ptr [bp - 4]
  070BAC  106C: 7e4e             jle 0x10bc
  070BAE  106E: 8d46ee           lea ax, [bp - 0x12]
  070BB1  1071: 50               push ax
  070BB2  1072: 8d4ef2           lea cx, [bp - 0xe]
  070BB5  1075: 51               push cx
  070BB6  1076: ff76fc           push word ptr [bp - 4]
  070BB9  1079: 0e               push cs
  070BBA  107A: e89d00           call 0x111a
  070BBD  107D: 83c406           add sp, 6
  070BC0  1080: 6a52             push 0x52
  070BC2  1082: 6a58             push 0x58
  070BC4  1084: ff76ee           push word ptr [bp - 0x12]
  070BC7  1087: ff76f2           push word ptr [bp - 0xe]
  070BCA  108A: 9aca031f18       lcall 0x181f, 0x3ca
  070BCF  108F: 83c408           add sp, 8
  070BD2  1092: 0bc0             or ax, ax
  070BD4  1094: 74c6             je 0x105c
  070BD6  1096: a19853           mov ax, word ptr [0x5398]
  070BD9  1099: 8946fa           mov word ptr [bp - 6], ax
  070BDC  109C: 8a46fc           mov al, byte ptr [bp - 4]
  070BDF  109F: 2ae4             sub ah, ah
  070BE1  10A1: a39853           mov word ptr [0x5398], ax
  070BE4  10A4: ff76fa           push word ptr [bp - 6]
  070BE7  10A7: 0e               push cs
  070BE8  10A8: e87400           call 0x111f
  070BEB  10AB: 83c402           add sp, 2
  070BEE  10AE: ff369853         push word ptr [0x5398]
  070BF2  10B2: 0e               push cs
  070BF3  10B3: e86900           call 0x111f
  070BF6  10B6: 83c402           add sp, 2
  070BF9  10B9: eba1             jmp 0x105c
  070BFB  10BB: 90               nop 
  070BFC  10BC: 833ef40700       cmp word ptr [0x7f4], 0
  070C01  10C1: 740c             je 0x10cf
  070C03  10C3: 833ee80770       cmp word ptr [0x7e8], 0x70
  070C08  10C8: 7d05             jge 0x10cf
  070C0A  10CA: c746f60000       mov word ptr [bp - 0xa], 0
  070C0F  10CF: 2bc0             sub ax, ax
  070C11  10D1: 8b56f6           mov dx, word ptr [bp - 0xa]
  070C14  10D4: 9a5c041f18       lcall 0x181f, 0x45c
  070C19  10D9: 837ef600         cmp word ptr [bp - 0xa], 0
  070C1D  10DD: 7403             je 0x10e2
  070C1F  10DF: e9b6fe           jmp 0xf98
  070C22  10E2: c746f80000       mov word ptr [bp - 8], 0
  070C27  10E7: 9ab6031f18       lcall 0x181f, 0x3b6
  070C2C  10EC: 6800a0           push 0xa000
  070C2F  10EF: 6800fc           push 0xfc00
  070C32  10F2: 9af4031f18       lcall 0x181f, 0x3f4
  070C37  10F7: 8b46f8           mov ax, word ptr [bp - 8]
  070C3A  10FA: c9               leave 
  070C3B  10FB: cb               retf 
  070C3C  10FC: ea580b1f1a       ljmp 0x1a1f:0xb58
  070C41  1101: ea820b1f1a       ljmp 0x1a1f:0xb82
  070C46  1106: ea900b1f1a       ljmp 0x1a1f:0xb90
  070C4B  110B: ea9e0b1f1a       ljmp 0x1a1f:0xb9e
  070C50  1110: eaac0b1f1a       ljmp 0x1a1f:0xbac
  070C55  1115: eaba0b1f1a       ljmp 0x1a1f:0xbba
  070C5A  111A: eac80b1f1a       ljmp 0x1a1f:0xbc8
  070C5F  111F: ead60b1f1a       ljmp 0x1a1f:0xbd6
  070C64  1124: eaf20b1f1a       ljmp 0x1a1f:0xbf2
  070C69  1129: 00cb             add bl, cl
  070C6B  112B: 90               nop 
  070C6C  112C: c8020000         enter 2, 0
  070C70  1130: 50               push ax
  070C71  1131: 53               push bx
  070C72  1132: 56               push si
  070C73  1133: c746fe0000       mov word ptr [bp - 2], 0
  070C78  1138: eb09             jmp 0x1143
  070C7A  113A: 8a46fc           mov al, byte ptr [bp - 4]
  070C7D  113D: 3804             cmp byte ptr [si], al
  070C7F  113F: 740c             je 0x114d
  070C81  1141: ff07             inc word ptr [bx]
  070C83  1143: 8b5efa           mov bx, word ptr [bp - 6]
  070C86  1146: 8b37             mov si, word ptr [bx]
  070C88  1148: 803c00           cmp byte ptr [si], 0
  070C8B  114B: 75ed             jne 0x113a
  070C8D  114D: 807efc00         cmp byte ptr [bp - 4], 0
  070C91  1151: 740e             je 0x1161
  070C93  1153: 8a46fc           mov al, byte ptr [bp - 4]
  070C96  1156: 3804             cmp byte ptr [si], al
  070C98  1158: 7507             jne 0x1161
  070C9A  115A: ff07             inc word ptr [bx]
  070C9C  115C: c746fe0100       mov word ptr [bp - 2], 1
  070CA1  1161: 8b5efa           mov bx, word ptr [bp - 6]
  070CA4  1164: 8b37             mov si, word ptr [bx]
  070CA6  1166: 803c00           cmp byte ptr [si], 0
  070CA9  1169: 7502             jne 0x116d
  070CAB  116B: ff0f             dec word ptr [bx]
  070CAD  116D: 8b46fe           mov ax, word ptr [bp - 2]
  070CB0  1170: 5e               pop si
  070CB1  1171: c9               leave 
  070CB2  1172: cb               retf 

; ---- func_070CB4  size=308  insns=115  prologue=ENTER 0x0004,0  terminal=RETF ----
  070CB4  1174: c8040000         enter 4, 0
  070CB8  1178: 8b5e06           mov bx, word ptr [bp + 6]
  070CBB  117B: 8b1f             mov bx, word ptr [bx]
  070CBD  117D: 8a07             mov al, byte ptr [bx]
  070CBF  117F: 98               cwde 
  070CC0  1180: 8bd8             mov bx, ax
  070CC2  1182: 895efc           mov word ptr [bp - 4], bx
  070CC5  1185: f687ed2702       test byte ptr [bx + 0x27ed], 2
  070CCA  118A: 7406             je 0x1192
  070CCC  118C: 2d2000           sub ax, 0x20
  070CCF  118F: e9d400           jmp 0x1266
  070CD2  1192: 8b5e06           mov bx, word ptr [bp + 6]
  070CD5  1195: 8b1f             mov bx, word ptr [bx]
  070CD7  1197: 8a07             mov al, byte ptr [bx]
  070CD9  1199: 98               cwde 
  070CDA  119A: e9c900           jmp 0x1266
  070CDD  119D: 90               nop 
  070CDE  119E: 8b5e06           mov bx, word ptr [bp + 6]
  070CE1  11A1: b03a             mov al, 0x3a
  070CE3  11A3: 0e               push cs
  070CE4  11A4: e8aa02           call 0x1451
  070CE7  11A7: 0bc0             or ax, ax
  070CE9  11A9: 7503             jne 0x11ae
  070CEB  11AB: e9f800           jmp 0x12a6
  070CEE  11AE: c60608264e       mov byte ptr [0x2608], 0x4e
  070CF3  11B3: 8b5e06           mov bx, word ptr [bp + 6]
  070CF6  11B6: 2ac0             sub al, al
  070CF8  11B8: 0e               push cs
  070CF9  11B9: e89502           call 0x1451
  070CFC  11BC: e9e700           jmp 0x12a6
  070CFF  11BF: 90               nop 
  070D00  11C0: c606280801       mov byte ptr [0x828], 1
  070D05  11C5: c70626080100     mov word ptr [0x826], 1
  070D0B  11CB: e9d800           jmp 0x12a6
  070D0E  11CE: c7061e200100     mov word ptr [0x201e], 1
  070D14  11D4: e9cf00           jmp 0x12a6
  070D17  11D7: 90               nop 
  070D18  11D8: c70606260100     mov word ptr [0x2606], 1
  070D1E  11DE: e9c500           jmp 0x12a6
  070D21  11E1: 90               nop 
  070D22  11E2: 8b5e06           mov bx, word ptr [bp + 6]
  070D25  11E5: b03a             mov al, 0x3a
  070D27  11E7: 0e               push cs
  070D28  11E8: e86602           call 0x1451
  070D2B  11EB: 0bc0             or ax, ax
  070D2D  11ED: 7419             je 0x1208
  070D2F  11EF: 8b5e06           mov bx, word ptr [bp + 6]
  070D32  11F2: ff37             push word ptr [bx]
  070D34  11F4: 685485           push 0x8554
  070D37  11F7: 9ae4071d0d       lcall 0xd1d, 0x7e4
  070D3C  11FC: 83c404           add sp, 4
  070D3F  11FF: 8b5e06           mov bx, word ptr [bp + 6]
  070D42  1202: 2ac0             sub al, al
  070D44  1204: 0e               push cs
  070D45  1205: e84902           call 0x1451
  070D48  1208: c7061e080100     mov word ptr [0x81e], 1
  070D4E  120E: c9               leave 
  070D4F  120F: cb               retf 
  070D50  1210: c6062a0801       mov byte ptr [0x82a], 1
  070D55  1215: c9               leave 
  070D56  1216: cb               retf 
  070D57  1217: 90               nop 
  070D58  1218: 8b5e06           mov bx, word ptr [bp + 6]
  070D5B  121B: b03a             mov al, 0x3a
  070D5D  121D: 0e               push cs
  070D5E  121E: e83002           call 0x1451
  070D61  1221: 0bc0             or ax, ax
  070D63  1223: 741b             je 0x1240
  070D65  1225: 8b5e06           mov bx, word ptr [bp + 6]
  070D68  1228: ff37             push word ptr [bx]
  070D6A  122A: 68fe84           push 0x84fe
  070D6D  122D: 9ae4071d0d       lcall 0xd1d, 0x7e4
  070D72  1232: 83c404           add sp, 4
  070D75  1235: 8b5e06           mov bx, word ptr [bp + 6]
  070D78  1238: 2ac0             sub al, al
  070D7A  123A: 0e               push cs
  070D7B  123B: e81302           call 0x1451
  070D7E  123E: eb0d             jmp 0x124d
  070D80  1240: 1e               push ds
  070D81  1241: 68fe84           push 0x84fe
  070D84  1244: 1e               push ds
  070D85  1245: ff7608           push word ptr [bp + 8]
  070D88  1248: 9a5a0c1f1a       lcall 0x1a1f, 0xc5a
  070D8D  124D: c7066c030100     mov word ptr [0x36c], 1
  070D93  1253: c9               leave 
  070D94  1254: cb               retf 
  070D95  1255: 90               nop 
  070D96  1256: c70604010100     mov word ptr [0x104], 1
  070D9C  125C: c9               leave 
  070D9D  125D: cb               retf 
  070D9E  125E: c6062b0801       mov byte ptr [0x82b], 1
  070DA3  1263: c9               leave 
  070DA4  1264: cb               retf 
  070DA5  1265: 90               nop 
  070DA6  1266: 2d4300           sub ax, 0x43
  070DA9  1269: 3d1700           cmp ax, 0x17
  070DAC  126C: 7738             ja 0x12a6
  070DAE  126E: d1e0             shl ax, 1
  070DB0  1270: 93               xchg bx, ax
  070DB1  1271: 2effa75601       jmp word ptr cs:[bx + 0x156]
  070DB6  1276: 7e00             jle 0x1278
  070DB8  1278: a00086           mov al, byte ptr [0x8600]
  070DBB  127B: 01860186         add word ptr [bp - 0x79ff], ax
  070DBF  127F: 01860186         add word ptr [bp - 0x79ff], ax
  070DC3  1283: 018601ae         add word ptr [bp - 0x51ff], ax
  070DC7  1287: 00b800c2         add byte ptr [bx + si - 0x3e00], bh
  070DCB  128B: 008601f0         add byte ptr [bp - 0xfff], al
  070DCF  128F: 00f8             add al, bh
  070DD1  1291: 00860186         add byte ptr [bp - 0x79ff], al
  070DD5  1295: 01860186         add word ptr [bp - 0x79ff], ax
  070DD9  1299: 01860186         add word ptr [bp - 0x79ff], ax
  070DDD  129D: 01360186         add word ptr [0x8601], si
  070DE1  12A1: 0186013e         add word ptr [bp + 0x3e01], ax
  070DE5  12A5: 01c9             add cx, cx
  070DE7  12A7: cb               retf 

; ---- func_070DE8  size=209  insns=74  prologue=ENTER 0x0002,0  terminal=RETF ----
  070DE8  12A8: c8020000         enter 2, 0
  070DEC  12AC: 685620           push 0x2056
  070DEF  12AF: 685920           push 0x2059
  070DF2  12B2: 9ada041d0d       lcall 0xd1d, 0x4da
  070DF7  12B7: 83c404           add sp, 4
  070DFA  12BA: 8946fe           mov word ptr [bp - 2], ax
  070DFD  12BD: 0bc0             or ax, ax
  070DFF  12BF: 7503             jne 0x12c4
  070E01  12C1: e99700           jmp 0x135b
  070E04  12C4: 50               push ax
  070E05  12C5: 6a01             push 1
  070E07  12C7: 6a02             push 2
  070E09  12C9: 680a26           push 0x260a
  070E0C  12CC: 9a28051d0d       lcall 0xd1d, 0x528
  070E11  12D1: 83c408           add sp, 8
  070E14  12D4: 0bc0             or ax, ax
  070E16  12D6: 7503             jne 0x12db
  070E18  12D8: e98000           jmp 0x135b
  070E1B  12DB: ff76fe           push word ptr [bp - 2]
  070E1E  12DE: 6a01             push 1
  070E20  12E0: 6a02             push 2
  070E22  12E2: 680c26           push 0x260c
  070E25  12E5: 9a28051d0d       lcall 0xd1d, 0x528
  070E2A  12EA: 83c408           add sp, 8
  070E2D  12ED: 0bc0             or ax, ax
  070E2F  12EF: 746a             je 0x135b
  070E31  12F1: ff76fe           push word ptr [bp - 2]
  070E34  12F4: 6a01             push 1
  070E36  12F6: 6a02             push 2
  070E38  12F8: 680e26           push 0x260e
  070E3B  12FB: 9a28051d0d       lcall 0xd1d, 0x528
  070E40  1300: 83c408           add sp, 8
  070E43  1303: 0bc0             or ax, ax
  070E45  1305: 7454             je 0x135b
  070E47  1307: ff76fe           push word ptr [bp - 2]
  070E4A  130A: 6a01             push 1
  070E4C  130C: 6a02             push 2
  070E4E  130E: 681026           push 0x2610
  070E51  1311: 9a28051d0d       lcall 0xd1d, 0x528
  070E56  1316: 83c408           add sp, 8
  070E59  1319: 0bc0             or ax, ax
  070E5B  131B: 743e             je 0x135b
  070E5D  131D: ff76fe           push word ptr [bp - 2]
  070E60  1320: 6a01             push 1
  070E62  1322: 6a02             push 2
  070E64  1324: 681226           push 0x2612
  070E67  1327: 9a28051d0d       lcall 0xd1d, 0x528
  070E6C  132C: 83c408           add sp, 8
  070E6F  132F: 0bc0             or ax, ax
  070E71  1331: 7428             je 0x135b
  070E73  1333: ff76fe           push word ptr [bp - 2]
  070E76  1336: 6a01             push 1
  070E78  1338: 6a02             push 2
  070E7A  133A: 681426           push 0x2614
  070E7D  133D: 9a28051d0d       lcall 0xd1d, 0x528
  070E82  1342: 83c408           add sp, 8
  070E85  1345: 0bc0             or ax, ax
  070E87  1347: 7412             je 0x135b
  070E89  1349: ff76fe           push word ptr [bp - 2]
  070E8C  134C: 6a01             push 1
  070E8E  134E: 6a02             push 2
  070E90  1350: 681626           push 0x2616
  070E93  1353: 9a28051d0d       lcall 0xd1d, 0x528
  070E98  1358: 83c408           add sp, 8
  070E9B  135B: 837efe00         cmp word ptr [bp - 2], 0
  070E9F  135F: 740b             je 0x136c
  070EA1  1361: ff76fe           push word ptr [bp - 2]
  070EA4  1364: 9af4031d0d       lcall 0xd1d, 0x3f4
  070EA9  1369: 83c402           add sp, 2
  070EAC  136C: a10c26           mov ax, word ptr [0x260c]
  070EAF  136F: 9a500c1f1a       lcall 0x1a1f, 0xc50
  070EB4  1374: a20826           mov byte ptr [0x2608], al
  070EB7  1377: c9               leave 
  070EB8  1378: cb               retf 

; ---- func_070EBA  size=317  insns=106  prologue=ENTER 0x0008,0  terminal=RET ----
  070EBA  137A: c8080000         enter 8, 0
  070EBE  137E: 57               push di
  070EBF  137F: 56               push si
  070EC0  1380: c746f80300       mov word ptr [bp - 8], 3
  070EC5  1385: c706e6260100     mov word ptr [0x26e6], 1
  070ECB  138B: 9ae00e1f18       lcall 0x181f, 0xee0
  070ED0  1390: 9a460c1f1a       lcall 0x1a1f, 0xc46
  070ED5  1395: 2bc0             sub ax, ax
  070ED7  1397: 8946fa           mov word ptr [bp - 6], ax
  070EDA  139A: a31c08           mov word ptr [0x81c], ax
  070EDD  139D: 686420           push 0x2064
  070EE0  13A0: 9a42091d0d       lcall 0xd1d, 0x942
  070EE5  13A5: 83c402           add sp, 2
  070EE8  13A8: 8946fe           mov word ptr [bp - 2], ax
  070EEB  13AB: 686d20           push 0x206d
  070EEE  13AE: 50               push ax
  070EEF  13AF: 9a800c1d0d       lcall 0xd1d, 0xc80
  070EF4  13B4: 83c404           add sp, 4
  070EF7  13B7: 0bc0             or ax, ax
  070EF9  13B9: 7506             jne 0x13c1
  070EFB  13BB: c7061e200100     mov word ptr [0x201e], 1
  070F01  13C1: 0e               push cs
  070F02  13C2: e88700           call 0x144c
  070F05  13C5: 0e               push cs
  070F06  13C6: e89200           call 0x145b
  070F09  13C9: c746fc0100       mov word ptr [bp - 4], 1
  070F0E  13CE: eb1e             jmp 0x13ee
  070F10  13D0: 8b5e08           mov bx, word ptr [bp + 8]
  070F13  13D3: ff37             push word ptr [bx]
  070F15  13D5: 8d46fe           lea ax, [bp - 2]
  070F18  13D8: 50               push ax
  070F19  13D9: 0e               push cs
  070F1A  13DA: e87900           call 0x1456
  070F1D  13DD: 83c404           add sp, 4
  070F20  13E0: ff46fe           inc word ptr [bp - 2]
  070F23  13E3: 8b5efe           mov bx, word ptr [bp - 2]
  070F26  13E6: 803f00           cmp byte ptr [bx], 0
  070F29  13E9: 75e5             jne 0x13d0
  070F2B  13EB: ff46fc           inc word ptr [bp - 4]
  070F2E  13EE: 8b4606           mov ax, word ptr [bp + 6]
  070F31  13F1: 3946fc           cmp word ptr [bp - 4], ax
  070F34  13F4: 7d28             jge 0x141e
  070F36  13F6: 8b5efc           mov bx, word ptr [bp - 4]
  070F39  13F9: d1e3             shl bx, 1
  070F3B  13FB: 8b7608           mov si, word ptr [bp + 8]
  070F3E  13FE: 8b38             mov di, word ptr [bx + si]
  070F40  1400: 8a05             mov al, byte ptr [di]
  070F42  1402: 98               cwde 
  070F43  1403: 50               push ax
  070F44  1404: 687320           push 0x2073
  070F47  1407: 8bfb             mov di, bx
  070F49  1409: 9a560c1d0d       lcall 0xd1d, 0xc56
  070F4E  140E: 83c404           add sp, 4
  070F51  1411: 0bc0             or ax, ax
  070F53  1413: 74d6             je 0x13eb
  070F55  1415: 03f7             add si, di
  070F57  1417: 8b04             mov ax, word ptr [si]
  070F59  1419: 8946fe           mov word ptr [bp - 2], ax
  070F5C  141C: ebc5             jmp 0x13e3
  070F5E  141E: 687620           push 0x2076
  070F61  1421: 685485           push 0x8554
  070F64  1424: 9ae4071d0d       lcall 0xd1d, 0x7e4
  070F69  1429: 83c404           add sp, 4
  070F6C  142C: 9a380c1f1a       lcall 0x1a1f, 0xc38
  070F71  1431: 833e220800       cmp word ptr [0x822], 0
  070F76  1436: 740f             je 0x1447
  070F78  1438: ff362208         push word ptr [0x822]
  070F7C  143C: 687e20           push 0x207e
  070F7F  143F: 9a12071d0d       lcall 0xd1d, 0x712
  070F84  1444: 83c404           add sp, 4
  070F87  1447: 5e               pop si
  070F88  1448: 5f               pop di
  070F89  1449: c9               leave 
  070F8A  144A: cb               retf 
  070F8B  144B: 90               nop 
  070F8C  144C: ea000c1f1a       ljmp 0x1a1f:0xc00
  070F91  1451: ea0e0c1f1a       ljmp 0x1a1f:0xc0e
  070F96  1456: ea1c0c1f1a       ljmp 0x1a1f:0xc1c
  070F9B  145B: ea2a0c1f1a       ljmp 0x1a1f:0xc2a
  070FA0  1460: a13a85           mov ax, word ptr [0x853a]
  070FA3  1463: a3c285           mov word ptr [0x85c2], ax
  070FA6  1466: a3ba85           mov word ptr [0x85ba], ax
  070FA9  1469: a3b285           mov word ptr [0x85b2], ax
  070FAC  146C: a3aa85           mov word ptr [0x85aa], ax
  070FAF  146F: a13c85           mov ax, word ptr [0x853c]
  070FB2  1472: a3c085           mov word ptr [0x85c0], ax
  070FB5  1475: a3b885           mov word ptr [0x85b8], ax
  070FB8  1478: a3b085           mov word ptr [0x85b0], ax
  070FBB  147B: a3a885           mov word ptr [0x85a8], ax
  070FBE  147E: a15c01           mov ax, word ptr [0x15c]
  070FC1  1481: 8b165e01         mov dx, word ptr [0x15e]
  070FC5  1485: a3ac85           mov word ptr [0x85ac], ax
  070FC8  1488: 8916ae85         mov word ptr [0x85ae], dx
  070FCC  148C: a16001           mov ax, word ptr [0x160]
  070FCF  148F: 8b166201         mov dx, word ptr [0x162]
  070FD3  1493: a3b485           mov word ptr [0x85b4], ax
  070FD6  1496: 8916b685         mov word ptr [0x85b6], dx
  070FDA  149A: a16401           mov ax, word ptr [0x164]
  070FDD  149D: 8b166601         mov dx, word ptr [0x166]
  070FE1  14A1: a3bc85           mov word ptr [0x85bc], ax
  070FE4  14A4: 8916be85         mov word ptr [0x85be], dx
  070FE8  14A8: a16801           mov ax, word ptr [0x168]
  070FEB  14AB: 8b166a01         mov dx, word ptr [0x16a]
  070FEF  14AF: a3c485           mov word ptr [0x85c4], ax
  070FF2  14B2: 8916c685         mov word ptr [0x85c6], dx
  070FF6  14B6: c3               ret 

; ---- func_070FF8  size=202  insns=59  prologue=ENTER 0x0002,0  terminal=RETF ----
  070FF8  14B8: c8020000         enter 2, 0
  070FFC  14BC: 50               push ax
  070FFD  14BD: c746fe0100       mov word ptr [bp - 2], 1
  071002  14C2: 833e5a0100       cmp word ptr [0x15a], 0
  071007  14C7: 740f             je 0x14d8
  071009  14C9: c7068001b42e     mov word ptr [0x180], 0x2eb4
  07100F  14CF: c70682010000     mov word ptr [0x182], 0
  071015  14D5: eb10             jmp 0x14e7
  071017  14D7: 90               nop 
  071018  14D8: a13c85           mov ax, word ptr [0x853c]
  07101B  14DB: f72e3a85         imul word ptr [0x853a]
  07101F  14DF: 99               cdq 
  071020  14E0: a38001           mov word ptr [0x180], ax
  071023  14E3: 89168201         mov word ptr [0x182], dx
  071027  14E7: 837efc00         cmp word ptr [bp - 4], 0
  07102B  14EB: 740c             je 0x14f9
  07102D  14ED: c7068001e02e     mov word ptr [0x180], 0x2ee0
  071033  14F3: c70682010000     mov word ptr [0x182], 0
  071039  14F9: c7065085f000     mov word ptr [0x8550], 0xf0
  07103F  14FF: c7065285c000     mov word ptr [0x8552], 0xc0
  071045  1505: a18001           mov ax, word ptr [0x180]
  071048  1508: 8b168201         mov dx, word ptr [0x182]
  07104C  150C: 9a9a021f18       lcall 0x181f, 0x29a
  071051  1511: a35c01           mov word ptr [0x15c], ax
  071054  1514: 89165e01         mov word ptr [0x15e], dx
  071058  1518: 8bc2             mov ax, dx
  07105A  151A: 0b065c01         or ax, word ptr [0x15c]
  07105E  151E: 7459             je 0x1579
  071060  1520: a18001           mov ax, word ptr [0x180]
  071063  1523: 8b168201         mov dx, word ptr [0x182]
  071067  1527: 9a9a021f18       lcall 0x181f, 0x29a
  07106C  152C: a36001           mov word ptr [0x160], ax
  07106F  152F: 89166201         mov word ptr [0x162], dx
  071073  1533: 8bc2             mov ax, dx
  071075  1535: 0b066001         or ax, word ptr [0x160]
  071079  1539: 743e             je 0x1579
  07107B  153B: a18001           mov ax, word ptr [0x180]
  07107E  153E: 8b168201         mov dx, word ptr [0x182]
  071082  1542: 9a9a021f18       lcall 0x181f, 0x29a
  071087  1547: a36401           mov word ptr [0x164], ax
  07108A  154A: 89166601         mov word ptr [0x166], dx
  07108E  154E: 8bc2             mov ax, dx
  071090  1550: 0b066401         or ax, word ptr [0x164]
  071094  1554: 7423             je 0x1579
  071096  1556: a18001           mov ax, word ptr [0x180]
  071099  1559: 8b168201         mov dx, word ptr [0x182]
  07109D  155D: 9a9a021f18       lcall 0x181f, 0x29a
  0710A2  1562: a36801           mov word ptr [0x168], ax
  0710A5  1565: 89166a01         mov word ptr [0x16a], dx
  0710A9  1569: 8bc2             mov ax, dx
  0710AB  156B: 0b066801         or ax, word ptr [0x168]
  0710AF  156F: 7408             je 0x1579
  0710B1  1571: e8ecfe           call 0x1460
  0710B4  1574: c746fe0000       mov word ptr [bp - 2], 0
  0710B9  1579: 8b46fe           mov ax, word ptr [bp - 2]
  0710BC  157C: c9               leave 
  0710BD  157D: cb               retf 
  0710BE  157E: b80100           mov ax, 1
  0710C1  1581: cb               retf 

; ---- func_0710C2  size=68  insns=20  prologue=ENTER 0x0002,0  terminal=RETF ----
  0710C2  1582: c8020000         enter 2, 0
  0710C6  1586: c746fe0100       mov word ptr [bp - 2], 1
  0710CB  158B: 833ea68500       cmp word ptr [0x85a6], 0
  0710D0  1590: 7f12             jg 0x15a4
  0710D2  1592: 7c08             jl 0x159c
  0710D4  1594: 813ea485e02e     cmp word ptr [0x85a4], 0x2ee0
  0710DA  159A: 7708             ja 0x15a4
  0710DC  159C: c7065a010000     mov word ptr [0x15a], 0
  0710E2  15A2: eb06             jmp 0x15aa
  0710E4  15A4: c7065a010100     mov word ptr [0x15a], 1
  0710EA  15AA: 833e5a0100       cmp word ptr [0x15a], 0
  0710EF  15AF: 740b             je 0x15bc
  0710F1  15B1: c70658010f27     mov word ptr [0x158], 0x270f
  0710F7  15B7: 8b46fe           mov ax, word ptr [bp - 2]
  0710FA  15BA: c9               leave 
  0710FB  15BB: cb               retf 
  0710FC  15BC: c746fe0000       mov word ptr [bp - 2], 0
  071101  15C1: 8b46fe           mov ax, word ptr [bp - 2]
  071104  15C4: c9               leave 
  071105  15C5: cb               retf 

; ---- func_071106  size=320  insns=110  prologue=ENTER 0x0006,0  terminal=RETF ----
  071106  15C6: c8060000         enter 6, 0
  07110A  15CA: c746fe0100       mov word ptr [bp - 2], 1
  07110F  15CF: 1e               push ds
  071110  15D0: 685485           push 0x8554
  071113  15D3: 1e               push ds
  071114  15D4: 685485           push 0x8554
  071117  15D7: 1e               push ds
  071118  15D8: 685401           push 0x154
  07111B  15DB: 9aaa0c1f1a       lcall 0x1a1f, 0xcaa
  071120  15E0: 1e               push ds
  071121  15E1: 685485           push 0x8554
  071124  15E4: 8d1e8e20         lea bx, [0x208e]
  071128  15E8: 9a860e1f18       lcall 0x181f, 0xe86
  07112D  15ED: 8946fa           mov word ptr [bp - 6], ax
  071130  15F0: 0bc0             or ax, ax
  071132  15F2: 750a             jne 0x15fe
  071134  15F4: c70658010100     mov word ptr [0x158], 1
  07113A  15FA: e9f600           jmp 0x16f3
  07113D  15FD: 90               nop 
  07113E  15FE: 50               push ax
  07113F  15FF: 6a01             push 1
  071141  1601: 6a04             push 4
  071143  1603: 683a85           push 0x853a
  071146  1606: 9a28051d0d       lcall 0xd1d, 0x528
  07114B  160B: 83c408           add sp, 8
  07114E  160E: 0bc0             or ax, ax
  071150  1610: 750a             jne 0x161c
  071152  1612: c70658010200     mov word ptr [0x158], 2
  071158  1618: e9d800           jmp 0x16f3
  07115B  161B: 90               nop 
  07115C  161C: ff76fa           push word ptr [bp - 6]
  07115F  161F: 6a01             push 1
  071161  1621: 6a02             push 2
  071163  1623: 8d46fc           lea ax, [bp - 4]
  071166  1626: 50               push ax
  071167  1627: 9a28051d0d       lcall 0xd1d, 0x528
  07116C  162C: 83c408           add sp, 8
  07116F  162F: 0bc0             or ax, ax
  071171  1631: 74df             je 0x1612
  071173  1633: 837efc04         cmp word ptr [bp - 4], 4
  071177  1637: 7f02             jg 0x163b
  071179  1639: 7d11             jge 0x164c
  07117B  163B: 833e520100       cmp word ptr [0x152], 0
  071180  1640: 7c0a             jl 0x164c
  071182  1642: c70658010300     mov word ptr [0x158], 3
  071188  1648: e9a800           jmp 0x16f3
  07118B  164B: 90               nop 
  07118C  164C: 8b46fc           mov ax, word ptr [bp - 4]
  07118F  164F: a35201           mov word ptr [0x152], ax
  071192  1652: a13c85           mov ax, word ptr [0x853c]
  071195  1655: f72e3a85         imul word ptr [0x853a]
  071199  1659: a3a485           mov word ptr [0x85a4], ax
  07119C  165C: 8916a685         mov word ptr [0x85a6], dx
  0711A0  1660: 0e               push cs
  0711A1  1661: e8d802           call 0x193c
  0711A4  1664: 0bc0             or ax, ax
  0711A6  1666: 7403             je 0x166b
  0711A8  1668: e98800           jmp 0x16f3
  0711AB  166B: 39065a01         cmp word ptr [0x15a], ax
  0711AF  166F: 7577             jne 0x16e8
  0711B1  1671: ff365e01         push word ptr [0x15e]
  0711B5  1675: ff365c01         push word ptr [0x15c]
  0711B9  1679: 50               push ax
  0711BA  167A: 6a01             push 1
  0711BC  167C: a1a485           mov ax, word ptr [0x85a4]
  0711BF  167F: 8b16a685         mov dx, word ptr [0x85a6]
  0711C3  1683: 8b5efa           mov bx, word ptr [bp - 6]
  0711C6  1686: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  0711CB  168B: 0bd0             or dx, ax
  0711CD  168D: 7509             jne 0x1698
  0711CF  168F: c70658010400     mov word ptr [0x158], 4
  0711D5  1695: eb5c             jmp 0x16f3
  0711D7  1697: 90               nop 
  0711D8  1698: ff366201         push word ptr [0x162]
  0711DC  169C: ff366001         push word ptr [0x160]
  0711E0  16A0: 6a00             push 0
  0711E2  16A2: 6a01             push 1
  0711E4  16A4: a1a485           mov ax, word ptr [0x85a4]
  0711E7  16A7: 8b16a685         mov dx, word ptr [0x85a6]
  0711EB  16AB: 8b5efa           mov bx, word ptr [bp - 6]
  0711EE  16AE: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  0711F3  16B3: 0bd0             or dx, ax
  0711F5  16B5: 7509             jne 0x16c0
  0711F7  16B7: c70658010500     mov word ptr [0x158], 5
  0711FD  16BD: eb34             jmp 0x16f3
  0711FF  16BF: 90               nop 
  071200  16C0: ff366601         push word ptr [0x166]
  071204  16C4: ff366401         push word ptr [0x164]
  071208  16C8: 6a00             push 0
  07120A  16CA: 6a01             push 1
  07120C  16CC: a1a485           mov ax, word ptr [0x85a4]
  07120F  16CF: 8b16a685         mov dx, word ptr [0x85a6]
  071213  16D3: 8b5efa           mov bx, word ptr [bp - 6]
  071216  16D6: 9ab40c1f1a       lcall 0x1a1f, 0xcb4
  07121B  16DB: 0bd0             or dx, ax
  07121D  16DD: 7509             jne 0x16e8
  07121F  16DF: c70658010600     mov word ptr [0x158], 6
  071225  16E5: eb0c             jmp 0x16f3
  071227  16E7: 90               nop 
  071228  16E8: 2bc0             sub ax, ax
  07122A  16EA: 8946fe           mov word ptr [bp - 2], ax
  07122D  16ED: a35801           mov word ptr [0x158], ax
  071230  16F0: e86dfd           call 0x1460
  071233  16F3: 837efa00         cmp word ptr [bp - 6], 0
  071237  16F7: 7408             je 0x1701
  071239  16F9: ff76fa           push word ptr [bp - 6]
  07123C  16FC: 9af4031d0d       lcall 0xd1d, 0x3f4
  071241  1701: 8b46fe           mov ax, word ptr [bp - 2]
  071244  1704: c9               leave 
  071245  1705: cb               retf 

; ---- func_071246  size=266  insns=90  prologue=ENTER 0x0006,0  terminal=RETF ----
  071246  1706: c8060000         enter 6, 0
  07124A  170A: c746fe0100       mov word ptr [bp - 2], 1
  07124F  170F: 1e               push ds
  071250  1710: 685485           push 0x8554
  071253  1713: 1e               push ds
  071254  1714: 685485           push 0x8554
  071257  1717: 1e               push ds
  071258  1718: 685401           push 0x154
  07125B  171B: 9aaa0c1f1a       lcall 0x1a1f, 0xcaa
  071260  1720: 1e               push ds
  071261  1721: 685485           push 0x8554
  071264  1724: 8d1e9120         lea bx, [0x2091]
  071268  1728: 9a860e1f18       lcall 0x181f, 0xe86
  07126D  172D: 8946fa           mov word ptr [bp - 6], ax
  071270  1730: 0bc0             or ax, ax
  071272  1732: 750a             jne 0x173e
  071274  1734: c70658010100     mov word ptr [0x158], 1
  07127A  173A: e9c000           jmp 0x17fd
  07127D  173D: 90               nop 
  07127E  173E: 50               push ax
  07127F  173F: 6a01             push 1
  071281  1741: 6a04             push 4
  071283  1743: 683a85           push 0x853a
  071286  1746: 9a0c061d0d       lcall 0xd1d, 0x60c
  07128B  174B: 83c408           add sp, 8
  07128E  174E: 0bc0             or ax, ax
  071290  1750: 750a             jne 0x175c
  071292  1752: c70658010200     mov word ptr [0x158], 2
  071298  1758: e9a200           jmp 0x17fd
  07129B  175B: 90               nop 
  07129C  175C: a15201           mov ax, word ptr [0x152]
  07129F  175F: 8946fc           mov word ptr [bp - 4], ax
  0712A2  1762: ff76fa           push word ptr [bp - 6]
  0712A5  1765: 6a01             push 1
  0712A7  1767: 6a02             push 2
  0712A9  1769: 8d46fc           lea ax, [bp - 4]
  0712AC  176C: 50               push ax
  0712AD  176D: 9a0c061d0d       lcall 0xd1d, 0x60c
  0712B2  1772: 83c408           add sp, 8
  0712B5  1775: 0bc0             or ax, ax
  0712B7  1777: 74d9             je 0x1752
  0712B9  1779: a13c85           mov ax, word ptr [0x853c]
  0712BC  177C: f72e3a85         imul word ptr [0x853a]
  0712C0  1780: a3a485           mov word ptr [0x85a4], ax
  0712C3  1783: 8916a685         mov word ptr [0x85a6], dx
  0712C7  1787: 833e5a0100       cmp word ptr [0x15a], 0
  0712CC  178C: 7567             jne 0x17f5
  0712CE  178E: ff365e01         push word ptr [0x15e]
  0712D2  1792: ff365c01         push word ptr [0x15c]
  0712D6  1796: 6a00             push 0
  0712D8  1798: 6a01             push 1
  0712DA  179A: 8b5efa           mov bx, word ptr [bp - 6]
  0712DD  179D: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  0712E2  17A2: 0bd0             or dx, ax
  0712E4  17A4: 7508             jne 0x17ae
  0712E6  17A6: c70658010400     mov word ptr [0x158], 4
  0712EC  17AC: eb4f             jmp 0x17fd
  0712EE  17AE: ff366201         push word ptr [0x162]
  0712F2  17B2: ff366001         push word ptr [0x160]
  0712F6  17B6: 6a00             push 0
  0712F8  17B8: 6a01             push 1
  0712FA  17BA: a1a485           mov ax, word ptr [0x85a4]
  0712FD  17BD: 8b16a685         mov dx, word ptr [0x85a6]
  071301  17C1: 8b5efa           mov bx, word ptr [bp - 6]
  071304  17C4: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  071309  17C9: 0bd0             or dx, ax
  07130B  17CB: 7509             jne 0x17d6
  07130D  17CD: c70658010500     mov word ptr [0x158], 5
  071313  17D3: eb28             jmp 0x17fd
  071315  17D5: 90               nop 
  071316  17D6: ff366601         push word ptr [0x166]
  07131A  17DA: ff366401         push word ptr [0x164]
  07131E  17DE: 6a00             push 0
  071320  17E0: 6a01             push 1
  071322  17E2: a1a485           mov ax, word ptr [0x85a4]
  071325  17E5: 8b16a685         mov dx, word ptr [0x85a6]
  071329  17E9: 8b5efa           mov bx, word ptr [bp - 6]
  07132C  17EC: 9a9c0c1f1a       lcall 0x1a1f, 0xc9c
  071331  17F1: 0bd0             or dx, ax
  071333  17F3: 74d8             je 0x17cd
  071335  17F5: 2bc0             sub ax, ax
  071337  17F7: 8946fe           mov word ptr [bp - 2], ax
  07133A  17FA: a35801           mov word ptr [0x158], ax
  07133D  17FD: 837efa00         cmp word ptr [bp - 6], 0
  071341  1801: 7408             je 0x180b
  071343  1803: ff76fa           push word ptr [bp - 6]
  071346  1806: 9af4031d0d       lcall 0xd1d, 0x3f4
  07134B  180B: 8b46fe           mov ax, word ptr [bp - 2]
  07134E  180E: c9               leave 
  07134F  180F: cb               retf 

; ---- func_071350  size=131  insns=41  prologue=ENTER 0x0008,0  terminal=RETF ----
  071350  1810: c8080000         enter 8, 0
  071354  1814: c746fe0100       mov word ptr [bp - 2], 1
  071359  1819: 8b4606           mov ax, word ptr [bp + 6]
  07135C  181C: a33a85           mov word ptr [0x853a], ax
  07135F  181F: 8b4e08           mov cx, word ptr [bp + 8]
  071362  1822: 890e3c85         mov word ptr [0x853c], cx
  071366  1826: 8bd8             mov bx, ax
  071368  1828: 8bc1             mov ax, cx
  07136A  182A: f7eb             imul bx
  07136C  182C: a3a485           mov word ptr [0x85a4], ax
  07136F  182F: 8916a685         mov word ptr [0x85a6], dx
  071373  1833: 0e               push cs
  071374  1834: e80501           call 0x193c
  071377  1837: 0bc0             or ax, ax
  071379  1839: 7553             jne 0x188e
  07137B  183B: 39065a01         cmp word ptr [0x15a], ax
  07137F  183F: 753f             jne 0x1880
  071381  1841: ff36a485         push word ptr [0x85a4]
  071385  1845: 6a19             push 0x19
  071387  1847: ff365e01         push word ptr [0x15e]
  07138B  184B: ff365c01         push word ptr [0x15c]
  07138F  184F: 9afa111d0d       lcall 0xd1d, 0x11fa
  071394  1854: 83c408           add sp, 8
  071397  1857: ff36a485         push word ptr [0x85a4]
  07139B  185B: 6a00             push 0
  07139D  185D: ff366201         push word ptr [0x162]
  0713A1  1861: ff366001         push word ptr [0x160]
  0713A5  1865: 9afa111d0d       lcall 0xd1d, 0x11fa
  0713AA  186A: 83c408           add sp, 8
  0713AD  186D: ff36a485         push word ptr [0x85a4]
  0713B1  1871: 6a00             push 0
  0713B3  1873: ff366601         push word ptr [0x166]
  0713B7  1877: ff366401         push word ptr [0x164]
  0713BB  187B: 9afa111d0d       lcall 0xd1d, 0x11fa
  0713C0  1880: 2bc0             sub ax, ax
  0713C2  1882: 8946fe           mov word ptr [bp - 2], ax
  0713C5  1885: a35801           mov word ptr [0x158], ax
  0713C8  1888: c70652010400     mov word ptr [0x152], 4
  0713CE  188E: 8b46fe           mov ax, word ptr [bp - 2]
  0713D1  1891: c9               leave 
  0713D2  1892: cb               retf 

; ---- func_0713D4  size=178  insns=57  prologue=ENTER 0x0004,0  terminal=page-end ----
  0713D4  1894: c8040000         enter 4, 0
  0713D8  1898: 50               push ax
  0713D9  1899: c746fe0100       mov word ptr [bp - 2], 1
  0713DE  189E: c746fc0000       mov word ptr [bp - 4], 0
  0713E3  18A3: 833e8c0100       cmp word ptr [0x18c], 0
  0713E8  18A8: 755f             jne 0x1909
  0713EA  18AA: 1e               push ds
  0713EB  18AB: 685485           push 0x8554
  0713EE  18AE: 1e               push ds
  0713EF  18AF: 685485           push 0x8554
  0713F2  18B2: 1e               push ds
  0713F3  18B3: 685401           push 0x154
  0713F6  18B6: 9aaa0c1f1a       lcall 0x1a1f, 0xcaa
  0713FB  18BB: 1e               push ds
  0713FC  18BC: 685485           push 0x8554
  0713FF  18BF: 8d1e9420         lea bx, [0x2094]
  071403  18C3: 9a860e1f18       lcall 0x181f, 0xe86
  071408  18C8: 8946fc           mov word ptr [bp - 4], ax
  07140B  18CB: c7063a857800     mov word ptr [0x853a], 0x78
  071411  18D1: c7063c854b00     mov word ptr [0x853c], 0x4b
  071417  18D7: c706a4852823     mov word ptr [0x85a4], 0x2328
  07141D  18DD: c706a6850000     mov word ptr [0x85a6], 0
  071423  18E3: 0bc0             or ax, ax
  071425  18E5: 7422             je 0x1909
  071427  18E7: 50               push ax
  071428  18E8: 6a01             push 1
  07142A  18EA: 6a04             push 4
  07142C  18EC: 683a85           push 0x853a
  07142F  18EF: 9a28051d0d       lcall 0xd1d, 0x528
  071434  18F4: 83c408           add sp, 8
  071437  18F7: 0bc0             or ax, ax
  071439  18F9: 740e             je 0x1909
  07143B  18FB: a13c85           mov ax, word ptr [0x853c]
  07143E  18FE: f72e3a85         imul word ptr [0x853a]
  071442  1902: a3a485           mov word ptr [0x85a4], ax
  071445  1905: 8916a685         mov word ptr [0x85a6], dx
  071449  1909: 0e               push cs
  07144A  190A: e82f00           call 0x193c
  07144D  190D: 0bc0             or ax, ax
  07144F  190F: 7518             jne 0x1929
  071451  1911: 8b46fa           mov ax, word ptr [bp - 6]
  071454  1914: 0e               push cs
  071455  1915: e82900           call 0x1941
  071458  1918: 0bc0             or ax, ax
  07145A  191A: 7408             je 0x1924
  07145C  191C: c70658011300     mov word ptr [0x158], 0x13
  071462  1922: eb05             jmp 0x1929
  071464  1924: c746fe0000       mov word ptr [bp - 2], 0
  071469  1929: 837efc00         cmp word ptr [bp - 4], 0
  07146D  192D: 7408             je 0x1937
  07146F  192F: ff76fc           push word ptr [bp - 4]
  071472  1932: 9af4031d0d       lcall 0xd1d, 0x3f4
  071477  1937: 8b46fe           mov ax, word ptr [bp - 2]
  07147A  193A: c9               leave 
  07147B  193B: cb               retf 
  07147C  193C: ea640c1f1a       ljmp 0x1a1f:0xc64
  071481  1941: ea720c1f1a       ljmp 0x1a1f:0xc72
