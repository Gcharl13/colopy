; VICEROY.EXE Load Image Disassembly - 525 functions


============================================================
func_L000 at file 0x02400, 33 bytes
============================================================
  0x02400: push     bp
  0x02401: mov      bp, sp
  0x02403: push     ds
  0x02404: push     0x2d40
  0x02407: push     word ptr [bp + 8]
  0x0240A: push     word ptr [bp + 6]
  0x0240D: push     ds
  0x0240E: push     0x42
  0x02411: mov      ax, 9
  0x02414: lcall    0x181f, 0x48
  0x02419: mov      word ptr [0x2d52], 0
  0x0241F: leave    
  0x02420: retf     

============================================================
func_L001 at file 0x0242C, 53 bytes
============================================================
  0x0242C: push     bp
  0x0242D: mov      bp, sp
  0x0242F: push     si
  0x02430: mov      si, word ptr [bp + 6]
  0x02433: mov      ax, word ptr [bp + 8]
  0x02436: push     ax
  0x02437: push     si
  0x02438: push     ds
  0x02439: push     0x2d40
  0x0243C: push     ax
  0x0243D: push     si
  0x0243E: lcall    0xd1d, 0x113c
  0x02443: add      sp, 4
  0x02446: inc      ax
  0x02447: cdq      
  0x02448: lcall    0x181f, 0x2c
  0x0244D: push     dx
  0x0244E: push     ax
  0x0244F: lcall    0xd1d, 0x117e
  0x02454: add      sp, 8
  0x02457: mov      ax, word ptr [0x2d52]
  0x0245A: inc      word ptr [0x2d52]
  0x0245E: pop      si
  0x0245F: leave    
  0x02460: retf     

============================================================
func_L002 at file 0x02462, 49 bytes
============================================================
  0x02462: enter    4, 0
  0x02466: push     di
  0x02467: push     si
  0x02468: mov      ax, word ptr [0x2d42]
  0x0246B: mov      dx, word ptr [0x2d44]
  0x0246F: mov      word ptr [bp - 4], ax
  0x02472: mov      word ptr [bp - 2], dx
  0x02475: les      di, ptr [bp - 4]
  0x02478: mov      dx, word ptr [bp + 6]
  0x0247B: or       dx, dx
  0x0247D: je       0x248b
  0x0247F: xor      al, al
  0x02481: mov      cx, 0xffff
  0x02484: repne scasb al, byte ptr es:[di]
  0x02486: jne      0x248b
  0x02488: dec      dx
  0x02489: jne      0x2481
  0x0248B: mov      dx, es
  0x0248D: mov      ax, di
  0x0248F: pop      si
  0x02490: pop      di
  0x02491: leave    
  0x02492: retf     

============================================================
func_L003 at file 0x02494, 50 bytes
============================================================
  0x02494: push     bp
  0x02495: mov      bp, sp
  0x02497: mov      ax, word ptr [bp + 6]
  0x0249A: dec      ax
  0x0249B: je       0x24ac
  0x0249D: dec      ax
  0x0249E: je       0x24ac
  0x024A0: dec      ax
  0x024A1: je       0x24b6
  0x024A3: mov      bx, word ptr [bp + 8]
  0x024A6: mov      word ptr [bx], 0x44
  0x024AA: jmp      0x24bd
  0x024AC: mov      bx, word ptr [bp + 8]
  0x024AF: mov      word ptr [bx], 0x95
  0x024B3: jmp      0x24bd
  0x024B5: nop      
  0x024B6: mov      bx, word ptr [bp + 8]
  0x024B9: mov      word ptr [bx], 0xc
  0x024BD: mov      bx, word ptr [bp + 0xa]
  0x024C0: mov      word ptr [bx], 0x22
  0x024C4: leave    
  0x024C5: retf     

============================================================
func_L004 at file 0x024C6, 126 bytes
============================================================
  0x024C6: enter    8, 0
  0x024CA: cmp      byte ptr [0x4a], 0
  0x024CF: je       0x253d
  0x024D1: cmp      word ptr [0x7ee], 0
  0x024D6: jne      0x253d
  0x024D8: lcall    0xc0c, 6
  0x024DD: mov      word ptr [bp - 4], ax
  0x024E0: mov      word ptr [bp - 2], dx
  0x024E3: add      ax, 0x1e
  0x024E6: adc      dx, 0
  0x024E9: cmp      dx, word ptr [0x2da6]
  0x024ED: jl       0x24fe
  0x024EF: jg       0x24f7
  0x024F1: cmp      ax, word ptr [0x2da4]
  0x024F5: jbe      0x24fe
  0x024F7: mov      dx, word ptr [0x2da6]
  0x024FB: mov      ax, word ptr [0x2da4]
  0x024FE: mov      word ptr [bp - 4], ax
  0x02501: mov      word ptr [bp - 2], dx
  0x02504: lcall    0xae7, 2
  0x02509: or       ax, ax
  0x0250B: jne      0x2526
  0x0250D: lea      ax, [bp - 6]
  0x02510: push     ax
  0x02511: lea      ax, [bp - 8]
  0x02514: push     ax
  0x02515: lcall    0xa58, 0x38b
  0x0251A: add      sp, 4
  0x0251D: or       ax, ax
  0x0251F: jne      0x2526
  0x02521: mov      dx, 1
  0x02524: jmp      0x2528
  0x02526: sub      dx, dx
  0x02528: or       dx, dx
  0x0252A: je       0x253d
  0x0252C: lcall    0xc0c, 6
  0x02531: cmp      dx, word ptr [bp - 2]
  0x02534: jl       0x2504
  0x02536: jg       0x253d
  0x02538: cmp      ax, word ptr [bp - 4]
  0x0253B: jb       0x2504
  0x0253D: lcall    0x262, 0xda
  0x02542: leave    
  0x02543: retf     

============================================================
func_L005 at file 0x02544, 201 bytes
============================================================
  0x02544: enter    4, 0
  0x02548: push     cs
  0x02549: call     0x24c6
  0x0254C: cmp      byte ptr [0x4a], 0
  0x02551: jne      0x2556
  0x02553: jmp      0x25fd
  0x02556: cmp      word ptr [bp + 6], 0
  0x0255A: jne      0x255f
  0x0255C: jmp      0x25fd
  0x0255F: cmp      word ptr [0x14ba], 0
  0x02564: jne      0x258e
  0x02566: push     word ptr [0x2dae]
  0x0256A: push     word ptr [0x2dac]
  0x0256E: push     word ptr [0x2daa]
  0x02572: push     word ptr [0x2da8]  ; map_terrain
  0x02576: push     word ptr [0x2cc8]
  0x0257A: push     0x22
  0x0257C: mov      ax, word ptr [0x2cca]
  0x0257F: mov      dx, word ptr [0x2ccc]
  0x02583: mov      bx, word ptr [0x2cc6]
  0x02587: lcall    0xb9e, 0xa
  0x0258C: jmp      0x25c9
  0x0258E: push     0
  0x02590: push     0
  0x02592: push     word ptr [0x2cc8]
  0x02596: push     word ptr [0x2cc6]
  0x0259A: push     word ptr [0x2ccc]
  0x0259E: push     word ptr [0x2cca]
  0x025A2: mov      bx, word ptr [0x14ba]
  0x025A6: push     word ptr [bx + 6]
  0x025A9: push     word ptr [bx + 4]
  0x025AC: push     word ptr [bx + 2]
  0x025AF: push     word ptr [bx]
  0x025B1: push     word ptr [0x2dae]
  0x025B5: push     word ptr [0x2dac]
  0x025B9: push     word ptr [0x2daa]
  0x025BD: push     word ptr [0x2da8]  ; map_terrain
  0x025C1: lcall    0xbf5, 0
  0x025C6: add      sp, 0x1c
  0x025C9: push     word ptr [0x2ccc]
  0x025CD: push     word ptr [0x2cc6]
  0x025D1: push     word ptr [0x2cc8]
  0x025D5: mov      ax, word ptr [0x2cca]
  0x025D8: mov      dx, word ptr [0x2ccc]
  0x025DC: mov      bx, ax
  0x025DE: lcall    0xb70, 0x3a
  0x025E3: lcall    0xc0c, 6
  0x025E8: mov      word ptr [bp - 4], ax
  0x025EB: mov      word ptr [bp - 2], dx
  0x025EE: lcall    0xc0c, 6
  0x025F3: cmp      ax, word ptr [bp - 4]
  0x025F6: jne      0x25fd
  0x025F8: cmp      dx, word ptr [bp - 2]
  0x025FB: je       0x25ee
  0x025FD: sub      al, al
  0x025FF: mov      byte ptr [0x4a], al
  0x02602: mov      byte ptr [0x4b], al
  0x02605: mov      byte ptr [0x4c], al
  0x02608: mov      byte ptr [0x2d54], al
  0x0260B: leave    
  0x0260C: retf     

============================================================
func_L006 at file 0x0260E, 35 bytes
============================================================
  0x0260E: push     bp
  0x0260F: mov      bp, sp
  0x02611: push     word ptr [bp + 8]
  0x02614: push     word ptr [bp + 6]
  0x02617: push     ds
  0x02618: push     0x2d54
  0x0261B: lcall    0xd1d, 0x11b4
  0x02620: mov      sp, bp
  0x02622: push     ds
  0x02623: push     0x4d
  0x02626: push     ds
  0x02627: push     0x2d54
  0x0262A: lcall    0xd1d, 0x11b4
  0x0262F: leave    
  0x02630: retf     

============================================================
func_L007 at file 0x02632, 21 bytes
============================================================
  0x02632: push     bp
  0x02633: mov      bp, sp
  0x02635: push     word ptr [bp + 6]
  0x02638: lcall    0, 0x62
  0x0263D: mov      sp, bp
  0x0263F: push     dx
  0x02640: push     ax
  0x02641: push     cs
  0x02642: call     0x260e
  0x02645: leave    
  0x02646: retf     

============================================================
func_L008 at file 0x02648, 32 bytes
============================================================
  0x02648: enter    0x14, 0
  0x0264C: push     0xa
  0x0264E: lea      ax, [bp - 0x14]
  0x02651: push     ax
  0x02652: push     word ptr [bp + 6]
  0x02655: lcall    0xd1d, 0x8fa
  0x0265A: add      sp, 6
  0x0265D: lea      ax, [bp - 0x14]
  0x02660: push     ss
  0x02661: push     ax
  0x02662: push     cs
  0x02663: call     0x260e
  0x02666: leave    
  0x02667: retf     

============================================================
func_L009 at file 0x02668, 35 bytes
============================================================
  0x02668: enter    0x14, 0
  0x0266C: push     0xa
  0x0266E: lea      ax, [bp - 0x14]
  0x02671: push     ax
  0x02672: push     word ptr [bp + 8]
  0x02675: push     word ptr [bp + 6]
  0x02678: lcall    0xd1d, 0x916
  0x0267D: add      sp, 8
  0x02680: lea      ax, [bp - 0x14]
  0x02683: push     ss
  0x02684: push     ax
  0x02685: push     cs
  0x02686: call     0x260e
  0x02689: leave    
  0x0268A: retf     

============================================================
func_L010 at file 0x0268C, 38 bytes
============================================================
  0x0268C: enter    0x14, 0
  0x02690: mov      byte ptr [bp - 0x14], 0
  0x02694: push     word ptr [bp + 8]
  0x02697: push     word ptr [bp + 6]
  0x0269A: lea      ax, [bp - 0x14]
  0x0269D: push     ss
  0x0269E: push     ax
  0x0269F: lcall    0x4b, 0x1e8
  0x026A4: add      sp, 8
  0x026A7: lea      ax, [bp - 0x14]
  0x026AA: push     ss
  0x026AB: push     ax
  0x026AC: push     cs
  0x026AD: call     0x260e
  0x026B0: leave    
  0x026B1: retf     

============================================================
func_L011 at file 0x026D4, 44 bytes
============================================================
  0x026D4: push     bp
  0x026D5: mov      bp, sp
  0x026D7: push     cs
  0x026D8: call     0x24c6
  0x026DB: mov      byte ptr [0x4a], 1
  0x026E0: mov      al, byte ptr [0x7ee]
  0x026E3: mov      byte ptr [0x4b], al
  0x026E6: mov      al, byte ptr [bp + 6]
  0x026E9: mov      byte ptr [0x4c], al
  0x026EC: lcall    0xc0c, 6
  0x026F1: add      ax, word ptr [bp + 8]
  0x026F4: adc      dx, word ptr [bp + 0xa]
  0x026F7: mov      word ptr [0x2da4], ax
  0x026FA: mov      word ptr [0x2da6], dx
  0x026FE: leave    
  0x026FF: retf     

============================================================
func_L012 at file 0x0273E, 29 bytes
============================================================
  0x0273E: push     bp
  0x0273F: mov      bp, sp
  0x02741: mov      ax, word ptr [bp + 6]
  0x02744: mov      word ptr [0x2cca], ax
  0x02747: mov      ax, word ptr [bp + 8]
  0x0274A: mov      word ptr [0x2ccc], ax
  0x0274D: mov      ax, word ptr [bp + 0xa]
  0x02750: mov      word ptr [0x2cc6], ax
  0x02753: mov      ax, word ptr [bp + 0xc]
  0x02756: mov      word ptr [0x2cc8], ax
  0x02759: leave    
  0x0275A: retf     

============================================================
func_L013 at file 0x0275C, 310 bytes
============================================================
  0x0275C: enter    0x54, 0
  0x02760: cmp      byte ptr [0x4a], 0
  0x02765: jne      0x2772
  0x02767: mov      ax, word ptr [bp + 0xa]
  0x0276A: or       ax, word ptr [bp + 8]
  0x0276D: jne      0x2772
  0x0276F: jmp      0x2890
  0x02772: push     word ptr [0x2dae]
  0x02776: push     word ptr [0x2dac]
  0x0277A: push     word ptr [0x2daa]
  0x0277E: push     word ptr [0x2da8]  ; map_terrain
  0x02782: mov      ax, word ptr [0x2cc8]
  0x02785: add      ax, word ptr [0x2ccc]
  0x02789: push     ax
  0x0278A: push     0
  0x0278C: mov      ax, word ptr [0x2cca]
  0x0278F: mov      bx, word ptr [0x2cc6]
  0x02793: add      bx, ax
  0x02795: dec      ax
  0x02796: mov      dx, word ptr [0x2ccc]
  0x0279A: dec      dx
  0x0279B: lcall    0xbca, 2
  0x027A0: lea      ax, [bp - 2]
  0x027A3: push     ax
  0x027A4: lea      cx, [bp - 4]
  0x027A7: push     cx
  0x027A8: mov      cl, byte ptr [0x4c]
  0x027AC: sub      ch, ch
  0x027AE: push     cx
  0x027AF: push     cs
  0x027B0: call     0x2494
  0x027B3: add      sp, 6
  0x027B6: cmp      word ptr [bp - 2], 0x22
  0x027BA: jne      0x2800
  0x027BC: cmp      word ptr [0x14ba], 0
  0x027C1: je       0x2800
  0x027C3: push     0
  0x027C5: push     0
  0x027C7: push     word ptr [0x2cc8]
  0x027CB: push     word ptr [0x2cc6]
  0x027CF: push     word ptr [0x2ccc]
  0x027D3: push     word ptr [0x2cca]
  0x027D7: mov      bx, word ptr [0x14ba]
  0x027DB: push     word ptr [bx + 6]
  0x027DE: push     word ptr [bx + 4]
  0x027E1: push     word ptr [bx + 2]
  0x027E4: push     word ptr [bx]
  0x027E6: push     word ptr [0x2dae]
  0x027EA: push     word ptr [0x2dac]
  0x027EE: push     word ptr [0x2daa]
  0x027F2: push     word ptr [0x2da8]  ; map_terrain
  0x027F6: lcall    0xbf5, 0
  0x027FB: add      sp, 0x1c
  0x027FE: jmp      0x2828
  0x02800: push     word ptr [0x2dae]
  0x02804: push     word ptr [0x2dac]
  0x02808: push     word ptr [0x2daa]
  0x0280C: push     word ptr [0x2da8]  ; map_terrain
  0x02810: push     word ptr [0x2cc8]
  0x02814: mov      al, byte ptr [bp - 2]
  0x02817: push     ax
  0x02818: mov      ax, word ptr [0x2cca]
  0x0281B: mov      dx, word ptr [0x2ccc]
  0x0281F: mov      bx, word ptr [0x2cc6]
  0x02823: lcall    0xb9e, 0xa
  0x02828: cmp      byte ptr [0x4a], 0
  0x0282D: je       0x2840
  0x0282F: push     0x2d54
  0x02832: lea      ax, [bp - 0x54]
  0x02835: push     ax
  0x02836: lcall    0xd1d, 0x7e4
  0x0283B: add      sp, 4
  0x0283E: jmp      0x2853
  0x02840: push     word ptr [bp + 0xa]
  0x02843: push     word ptr [bp + 8]
  0x02846: lea      ax, [bp - 0x54]
  0x02849: push     ss
  0x0284A: push     ax
  0x0284B: lcall    0xd1d, 0x117e
  0x02850: add      sp, 8
  0x02853: push     word ptr [bp - 4]
  0x02856: mov      ax, word ptr [0x2ccc]
  0x02859: inc      ax
  0x0285A: push     ax
  0x0285B: push     word ptr [0x2cc6]
  0x0285F: push     word ptr [0x2cca]
  0x02863: lea      ax, [bp - 0x54]
  0x02866: push     ss
  0x02867: push     ax
  0x02868: lcall    0x4b, 0x318
  0x0286D: add      sp, 0xc
  0x02870: cmp      word ptr [bp + 6], 0
  0x02874: je       0x2890
  0x02876: push     word ptr [0x2ccc]
  0x0287A: push     word ptr [0x2cc6]
  0x0287E: push     word ptr [0x2cc8]
  0x02882: mov      ax, word ptr [0x2cca]
  0x02885: mov      dx, word ptr [0x2ccc]
  0x02889: mov      bx, ax
  0x0288B: lcall    0xb70, 0x3a
  0x02890: leave    
  0x02891: retf     

============================================================
func_L014 at file 0x02892, 30 bytes
============================================================
  0x02892: push     bp
  0x02893: mov      bp, sp
  0x02895: push     word ptr [bp + 0xa]
  0x02898: push     word ptr [bp + 8]
  0x0289B: push     word ptr [bp + 6]
  0x0289E: push     cs
  0x0289F: call     0x26d4
  0x028A2: mov      sp, bp
  0x028A4: push     0
  0x028A6: push     0
  0x028A8: push     1
  0x028AA: push     cs
  0x028AB: call     0x275c
  0x028AE: leave    
  0x028AF: retf     

============================================================
func_L015 at file 0x028B0, 16 bytes
============================================================
  0x028B0: push     bp
  0x028B1: mov      bp, sp
  0x028B3: push     0x50
  0x028B6: push     word ptr [bp + 6]
  0x028B9: lcall    0xd1d, 0x7a4
  0x028BE: leave    
  0x028BF: retf     

============================================================
func_L016 at file 0x028C0, 33 bytes
============================================================
  0x028C0: enter    2, 0
  0x028C4: push     di
  0x028C5: push     si
  0x028C6: mov      dx, word ptr [bp + 8]
  0x028C9: or       dx, dx
  0x028CB: jle      0x28dd
  0x028CD: mov      si, dx
  0x028CF: mov      di, word ptr [bp + 6]
  0x028D2: push     di
  0x028D3: push     cs
  0x028D4: call     0x28b0
  0x028D7: add      sp, 2
  0x028DA: dec      si
  0x028DB: jne      0x28d2
  0x028DD: pop      si
  0x028DE: pop      di
  0x028DF: leave    
  0x028E0: retf     

============================================================
func_L017 at file 0x028E2, 16 bytes
============================================================
  0x028E2: push     bp
  0x028E3: mov      bp, sp
  0x028E5: push     0x52
  0x028E8: push     word ptr [bp + 6]
  0x028EB: lcall    0xd1d, 0x7a4
  0x028F0: leave    
  0x028F1: retf     

============================================================
func_L018 at file 0x028F2, 16 bytes
============================================================
  0x028F2: push     bp
  0x028F3: mov      bp, sp
  0x028F5: push     0x55
  0x028F8: push     word ptr [bp + 6]
  0x028FB: lcall    0xd1d, 0x7a4
  0x02900: leave    
  0x02901: retf     

============================================================
func_L019 at file 0x02902, 16 bytes
============================================================
  0x02902: push     bp
  0x02903: mov      bp, sp
  0x02905: push     0x58
  0x02908: push     word ptr [bp + 6]
  0x0290B: lcall    0xd1d, 0x7a4
  0x02910: leave    
  0x02911: retf     

============================================================
func_L020 at file 0x02912, 16 bytes
============================================================
  0x02912: push     bp
  0x02913: mov      bp, sp
  0x02915: push     0x5c
  0x02918: push     word ptr [bp + 6]
  0x0291B: lcall    0xd1d, 0x7a4
  0x02920: leave    
  0x02921: retf     

============================================================
func_L021 at file 0x02922, 16 bytes
============================================================
  0x02922: push     bp
  0x02923: mov      bp, sp
  0x02925: push     0x5e
  0x02928: push     word ptr [bp + 6]
  0x0292B: lcall    0xd1d, 0x7a4
  0x02930: leave    
  0x02931: retf     

============================================================
func_L022 at file 0x02932, 16 bytes
============================================================
  0x02932: push     bp
  0x02933: mov      bp, sp
  0x02935: push     0x60
  0x02938: push     word ptr [bp + 6]
  0x0293B: lcall    0xd1d, 0x7a4
  0x02940: leave    
  0x02941: retf     

============================================================
func_L023 at file 0x02942, 16 bytes
============================================================
  0x02942: push     bp
  0x02943: mov      bp, sp
  0x02945: push     0x62
  0x02948: push     word ptr [bp + 6]
  0x0294B: lcall    0xd1d, 0x7a4
  0x02950: leave    
  0x02951: retf     

============================================================
func_L024 at file 0x02952, 16 bytes
============================================================
  0x02952: push     bp
  0x02953: mov      bp, sp
  0x02955: push     0x64
  0x02958: push     word ptr [bp + 6]
  0x0295B: lcall    0xd1d, 0x7a4
  0x02960: leave    
  0x02961: retf     

============================================================
func_L025 at file 0x02962, 16 bytes
============================================================
  0x02962: push     bp
  0x02963: mov      bp, sp
  0x02965: push     0x66
  0x02968: push     word ptr [bp + 6]
  0x0296B: lcall    0xd1d, 0x7a4
  0x02970: leave    
  0x02971: retf     

============================================================
func_L026 at file 0x02972, 16 bytes
============================================================
  0x02972: push     bp
  0x02973: mov      bp, sp
  0x02975: push     0x68
  0x02978: push     word ptr [bp + 6]
  0x0297B: lcall    0xd1d, 0x7a4
  0x02980: leave    
  0x02981: retf     

============================================================
func_L027 at file 0x02982, 16 bytes
============================================================
  0x02982: push     bp
  0x02983: mov      bp, sp
  0x02985: push     0x6a
  0x02988: push     word ptr [bp + 6]
  0x0298B: lcall    0xd1d, 0x7a4
  0x02990: leave    
  0x02991: retf     

============================================================
func_L028 at file 0x02992, 26 bytes
============================================================
  0x02992: push     bp
  0x02993: mov      bp, sp
  0x02995: push     word ptr [bp + 8]
  0x02998: lcall    0, 0x62
  0x0299D: mov      sp, bp
  0x0299F: push     dx
  0x029A0: push     ax
  0x029A1: push     ds
  0x029A2: push     word ptr [bp + 6]
  0x029A5: lcall    0xd1d, 0x11b4
  0x029AA: leave    
  0x029AB: retf     

============================================================
func_L029 at file 0x029AC, 49 bytes
============================================================
  0x029AC: push     bp
  0x029AD: mov      bp, sp
  0x029AF: push     si
  0x029B0: mov      si, word ptr [bp + 6]
  0x029B3: push     si
  0x029B4: push     cs
  0x029B5: call     0x2942
  0x029B8: add      sp, 2
  0x029BB: push     word ptr [bp + 8]
  0x029BE: lcall    0, 0x62
  0x029C3: add      sp, 2
  0x029C6: push     dx
  0x029C7: push     ax
  0x029C8: push     ds
  0x029C9: push     si
  0x029CA: lcall    0xd1d, 0x11b4
  0x029CF: add      sp, 8
  0x029D2: push     si
  0x029D3: push     cs
  0x029D4: call     0x2952
  0x029D7: add      sp, 2
  0x029DA: pop      si
  0x029DB: leave    
  0x029DC: retf     

============================================================
func_L030 at file 0x029DE, 39 bytes
============================================================
  0x029DE: enter    0x14, 0
  0x029E2: push     0xa
  0x029E4: lea      ax, [bp - 0x14]
  0x029E7: push     ax
  0x029E8: push     word ptr [bp + 0xa]
  0x029EB: lcall    0xd1d, 0x8fa
  0x029F0: add      sp, 6
  0x029F3: lea      ax, [bp - 0x14]
  0x029F6: push     ss
  0x029F7: push     ax
  0x029F8: push     word ptr [bp + 8]
  0x029FB: push     word ptr [bp + 6]
  0x029FE: lcall    0xd1d, 0x11b4
  0x02A03: leave    
  0x02A04: retf     

============================================================
func_L031 at file 0x02A06, 104 bytes
============================================================
  0x02A06: enter    0x18, 0
  0x02A0A: push     di
  0x02A0B: push     si
  0x02A0C: push     2
  0x02A0E: lea      ax, [bp - 0x18]
  0x02A11: push     ax
  0x02A12: push     word ptr [bp + 0xa]
  0x02A15: lcall    0xd1d, 0x8fa
  0x02A1A: add      sp, 6
  0x02A1D: mov      word ptr [bp - 4], 0
  0x02A22: lea      ax, [bp - 0x18]
  0x02A25: push     ax
  0x02A26: lcall    0xd1d, 0x842
  0x02A2B: add      sp, 2
  0x02A2E: mov      di, ax
  0x02A30: mov      ax, 8
  0x02A33: sub      ax, di
  0x02A35: or       ax, ax
  0x02A37: jle      0x2a57
  0x02A39: mov      si, 8
  0x02A3C: sub      si, di
  0x02A3E: mov      word ptr [bp - 2], di
  0x02A41: mov      di, word ptr [bp + 6]
  0x02A44: push     ds
  0x02A45: push     0x6c
  0x02A48: push     word ptr [bp + 8]
  0x02A4B: push     di
  0x02A4C: lcall    0xd1d, 0x11b4
  0x02A51: add      sp, 8
  0x02A54: dec      si
  0x02A55: jne      0x2a44
  0x02A57: lea      ax, [bp - 0x18]
  0x02A5A: push     ss
  0x02A5B: push     ax
  0x02A5C: push     word ptr [bp + 8]
  0x02A5F: push     word ptr [bp + 6]
  0x02A62: lcall    0xd1d, 0x11b4
  0x02A67: add      sp, 8
  0x02A6A: pop      si
  0x02A6B: pop      di
  0x02A6C: leave    
  0x02A6D: retf     

============================================================
func_L032 at file 0x02A6E, 42 bytes
============================================================
  0x02A6E: enter    0x14, 0
  0x02A72: push     0xa
  0x02A74: lea      ax, [bp - 0x14]
  0x02A77: push     ax
  0x02A78: push     word ptr [bp + 0xc]
  0x02A7B: push     word ptr [bp + 0xa]
  0x02A7E: lcall    0xd1d, 0x916
  0x02A83: add      sp, 8
  0x02A86: lea      ax, [bp - 0x14]
  0x02A89: push     ss
  0x02A8A: push     ax
  0x02A8B: push     word ptr [bp + 8]
  0x02A8E: push     word ptr [bp + 6]
  0x02A91: lcall    0xd1d, 0x11b4
  0x02A96: leave    
  0x02A97: retf     

============================================================
func_L033 at file 0x02A98, 46 bytes
============================================================
  0x02A98: push     bp
  0x02A99: mov      bp, sp
  0x02A9B: push     di
  0x02A9C: push     si
  0x02A9D: mov      si, word ptr [bp + 6]
  0x02AA0: push     word ptr [bp + 0xc]
  0x02AA3: push     word ptr [bp + 0xa]
  0x02AA6: mov      ax, word ptr [bp + 8]
  0x02AA9: push     ax
  0x02AAA: push     si
  0x02AAB: mov      di, ax
  0x02AAD: push     cs
  0x02AAE: call     0x2a6e
  0x02AB1: add      sp, 8
  0x02AB4: push     ds
  0x02AB5: push     0x6e
  0x02AB8: push     di
  0x02AB9: push     si
  0x02ABA: lcall    0xd1d, 0x11b4
  0x02ABF: add      sp, 8
  0x02AC2: pop      si
  0x02AC3: pop      di
  0x02AC4: leave    
  0x02AC5: retf     

============================================================
func_L034 at file 0x02AC6, 27 bytes
============================================================
  0x02AC6: push     bp
  0x02AC7: mov      bp, sp
  0x02AC9: push     word ptr [0x8a0]
  0x02ACD: push     word ptr [0x89e]
  0x02AD1: push     word ptr [bp + 8]
  0x02AD4: push     word ptr [bp + 6]
  0x02AD7: sub      ax, ax
  0x02AD9: lcall    0xc2a, 6
  0x02ADE: dec      ax
  0x02ADF: leave    
  0x02AE0: retf     

============================================================
func_L035 at file 0x02AE2, 27 bytes
============================================================
  0x02AE2: push     bp
  0x02AE3: mov      bp, sp
  0x02AE5: push     word ptr [0x268c]
  0x02AE9: push     word ptr [0x268a]
  0x02AED: push     word ptr [bp + 8]
  0x02AF0: push     word ptr [bp + 6]
  0x02AF3: sub      ax, ax
  0x02AF5: lcall    0xc2a, 6
  0x02AFA: dec      ax
  0x02AFB: leave    
  0x02AFC: retf     

============================================================
func_L036 at file 0x02AFE, 58 bytes
============================================================
  0x02AFE: push     bp
  0x02AFF: mov      bp, sp
  0x02B01: push     si
  0x02B02: mov      si, word ptr [bp + 0xa]
  0x02B05: push     0
  0x02B07: mov      dl, byte ptr [0x830]
  0x02B0B: sub      dh, dh
  0x02B0D: mov      ax, 0xffff
  0x02B10: sub      bx, bx
  0x02B12: lcall    0xc28, 0xa
  0x02B17: push     word ptr [0x8a0]
  0x02B1B: push     word ptr [0x89e]
  0x02B1F: push     word ptr [bp + 8]
  0x02B22: push     word ptr [bp + 6]
  0x02B25: push     0
  0x02B27: lea      bx, [0x2da8]  ; map_terrain
  0x02B2B: mov      ax, si
  0x02B2D: mov      dx, word ptr [bp + 0xc]
  0x02B30: lcall    0xc11, 0xc
  0x02B35: pop      si
  0x02B36: leave    
  0x02B37: retf     

============================================================
func_L037 at file 0x02B38, 58 bytes
============================================================
  0x02B38: push     bp
  0x02B39: mov      bp, sp
  0x02B3B: push     di
  0x02B3C: push     si
  0x02B3D: mov      di, word ptr [bp + 0xa]
  0x02B40: mov      si, word ptr [bp + 0xe]
  0x02B43: push     si
  0x02B44: mov      dx, si
  0x02B46: mov      bx, si
  0x02B48: mov      ax, 0xffff
  0x02B4B: lcall    0xc28, 0xa
  0x02B50: push     word ptr [0x8a0]
  0x02B54: push     word ptr [0x89e]
  0x02B58: push     word ptr [bp + 8]
  0x02B5B: push     word ptr [bp + 6]
  0x02B5E: push     0
  0x02B60: lea      bx, [0x2da8]  ; map_terrain
  0x02B64: mov      ax, di
  0x02B66: mov      dx, word ptr [bp + 0xc]
  0x02B69: lcall    0xc11, 0xc
  0x02B6E: pop      si
  0x02B6F: pop      di
  0x02B70: leave    
  0x02B71: retf     

============================================================
func_L038 at file 0x02B72, 85 bytes
============================================================
  0x02B72: push     bp
  0x02B73: mov      bp, sp
  0x02B75: push     di
  0x02B76: push     si
  0x02B77: mov      di, word ptr [bp + 0xe]
  0x02B7A: mov      si, word ptr [bp + 0xa]
  0x02B7D: push     di
  0x02B7E: mov      dx, di
  0x02B80: mov      bx, di
  0x02B82: mov      ax, 0xffff
  0x02B85: lcall    0xc28, 0xa
  0x02B8A: push     word ptr [0x8a0]
  0x02B8E: push     word ptr [0x89e]
  0x02B92: push     word ptr [bp + 8]
  0x02B95: push     word ptr [bp + 6]
  0x02B98: sub      ax, ax
  0x02B9A: lcall    0xc2a, 6
  0x02B9F: sub      si, ax
  0x02BA1: push     word ptr [0x8a0]
  0x02BA5: push     word ptr [0x89e]
  0x02BA9: push     word ptr [bp + 8]
  0x02BAC: push     word ptr [bp + 6]
  0x02BAF: push     0
  0x02BB1: mov      ax, si
  0x02BB3: lea      bx, [0x2da8]  ; map_terrain
  0x02BB7: mov      dx, word ptr [bp + 0xc]
  0x02BBA: mov      si, ax
  0x02BBC: lcall    0xc11, 0xc
  0x02BC1: mov      ax, si
  0x02BC3: pop      si
  0x02BC4: pop      di
  0x02BC5: leave    
  0x02BC6: retf     

============================================================
func_L039 at file 0x02BC8, 68 bytes
============================================================
  0x02BC8: push     bp
  0x02BC9: mov      bp, sp
  0x02BCB: push     di
  0x02BCC: push     si
  0x02BCD: mov      di, word ptr [bp + 6]
  0x02BD0: push     word ptr [bp + 0x10]
  0x02BD3: push     word ptr [bp + 0xe]
  0x02BD6: mov      ax, word ptr [bp + 8]
  0x02BD9: push     ax
  0x02BDA: push     di
  0x02BDB: mov      si, ax
  0x02BDD: push     cs
  0x02BDE: call     0x2ac6
  0x02BE1: add      sp, 4
  0x02BE4: sar      ax, 1
  0x02BE6: mov      cx, word ptr [bp + 0xc]
  0x02BE9: sar      cx, 1
  0x02BEB: mov      dx, si
  0x02BED: mov      si, cx
  0x02BEF: sub      si, ax
  0x02BF1: add      si, word ptr [bp + 0xa]
  0x02BF4: mov      ax, si
  0x02BF6: or       ax, ax
  0x02BF8: jge      0x2bfc
  0x02BFA: sub      ax, ax
  0x02BFC: mov      si, ax
  0x02BFE: push     si
  0x02BFF: push     dx
  0x02C00: push     di
  0x02C01: push     cs
  0x02C02: call     0x2b38
  0x02C05: add      sp, 0xa
  0x02C08: pop      si
  0x02C09: pop      di
  0x02C0A: leave    
  0x02C0B: retf     

============================================================
func_L040 at file 0x02C0C, 62 bytes
============================================================
  0x02C0C: push     bp
  0x02C0D: mov      bp, sp
  0x02C0F: push     si
  0x02C10: mov      si, word ptr [bp + 0xa]
  0x02C13: push     0
  0x02C15: mov      dl, byte ptr [0x830]
  0x02C19: sub      dh, dh
  0x02C1B: mov      bl, byte ptr [0x833]
  0x02C1F: sub      bh, bh
  0x02C21: mov      ax, 0xffff
  0x02C24: lcall    0xc28, 0xa
  0x02C29: push     word ptr [0x268c]
  0x02C2D: push     word ptr [0x268a]
  0x02C31: push     word ptr [bp + 8]
  0x02C34: push     word ptr [bp + 6]
  0x02C37: push     0
  0x02C39: lea      bx, [0x2da8]  ; map_terrain
  0x02C3D: mov      ax, si
  0x02C3F: mov      dx, word ptr [bp + 0xc]
  0x02C42: lcall    0xc11, 0xc
  0x02C47: pop      si
  0x02C48: leave    
  0x02C49: retf     

============================================================
func_L041 at file 0x02C4A, 56 bytes
============================================================
  0x02C4A: push     bp
  0x02C4B: mov      bp, sp
  0x02C4D: push     si
  0x02C4E: mov      si, word ptr [bp + 0xa]
  0x02C51: push     0
  0x02C53: mov      ax, 0xffff
  0x02C56: mov      dx, word ptr [bp + 0xe]
  0x02C59: mov      bx, word ptr [bp + 0x10]
  0x02C5C: lcall    0xc28, 0xa
  0x02C61: push     word ptr [0x268c]
  0x02C65: push     word ptr [0x268a]
  0x02C69: push     word ptr [bp + 8]
  0x02C6C: push     word ptr [bp + 6]
  0x02C6F: push     0
  0x02C71: lea      bx, [0x2da8]  ; map_terrain
  0x02C75: mov      ax, si
  0x02C77: mov      dx, word ptr [bp + 0xc]
  0x02C7A: lcall    0xc11, 0xc
  0x02C7F: pop      si
  0x02C80: leave    
  0x02C81: retf     

============================================================
func_L042 at file 0x02C82, 94 bytes
============================================================
  0x02C82: enter    4, 0
  0x02C86: push     di
  0x02C87: push     si
  0x02C88: mov      di, word ptr [bp + 6]
  0x02C8B: mov      si, word ptr [bp + 0xa]
  0x02C8E: push     0
  0x02C90: mov      ax, 0xffff
  0x02C93: mov      dx, word ptr [bp + 0xe]
  0x02C96: mov      bx, word ptr [bp + 0x10]
  0x02C99: lcall    0xc28, 0xa
  0x02C9E: push     word ptr [0x268c]
  0x02CA2: push     word ptr [0x268a]
  0x02CA6: mov      ax, word ptr [bp + 8]
  0x02CA9: push     ax
  0x02CAA: push     di
  0x02CAB: mov      word ptr [bp - 4], di
  0x02CAE: mov      word ptr [bp - 2], ax
  0x02CB1: sub      ax, ax
  0x02CB3: lcall    0xc2a, 6
  0x02CB8: sub      si, ax
  0x02CBA: push     word ptr [0x268c]
  0x02CBE: push     word ptr [0x268a]
  0x02CC2: push     word ptr [bp - 2]
  0x02CC5: push     word ptr [bp - 4]
  0x02CC8: push     0
  0x02CCA: mov      ax, si
  0x02CCC: lea      bx, [0x2da8]  ; map_terrain
  0x02CD0: mov      dx, word ptr [bp + 0xc]
  0x02CD3: mov      si, ax
  0x02CD5: lcall    0xc11, 0xc
  0x02CDA: mov      ax, si
  0x02CDC: pop      si
  0x02CDD: pop      di
  0x02CDE: leave    
  0x02CDF: retf     

============================================================
func_L043 at file 0x02CE0, 71 bytes
============================================================
  0x02CE0: push     bp
  0x02CE1: mov      bp, sp
  0x02CE3: push     di
  0x02CE4: push     si
  0x02CE5: mov      di, word ptr [bp + 6]
  0x02CE8: push     word ptr [bp + 0x12]
  0x02CEB: push     word ptr [bp + 0x10]
  0x02CEE: push     word ptr [bp + 0xe]
  0x02CF1: mov      ax, word ptr [bp + 8]
  0x02CF4: push     ax
  0x02CF5: push     di
  0x02CF6: mov      si, ax
  0x02CF8: push     cs
  0x02CF9: call     0x2ae2
  0x02CFC: add      sp, 4
  0x02CFF: sar      ax, 1
  0x02D01: mov      cx, word ptr [bp + 0xc]
  0x02D04: sar      cx, 1
  0x02D06: mov      dx, si
  0x02D08: mov      si, cx
  0x02D0A: sub      si, ax
  0x02D0C: add      si, word ptr [bp + 0xa]
  0x02D0F: mov      ax, si
  0x02D11: or       ax, ax
  0x02D13: jge      0x2d17
  0x02D15: sub      ax, ax
  0x02D17: mov      si, ax
  0x02D19: push     si
  0x02D1A: push     dx
  0x02D1B: push     di
  0x02D1C: push     cs
  0x02D1D: call     0x2c4a
  0x02D20: add      sp, 0xc
  0x02D23: pop      si
  0x02D24: pop      di
  0x02D25: leave    
  0x02D26: retf     

============================================================
func_L044 at file 0x02D28, 75 bytes
============================================================
  0x02D28: push     bp
  0x02D29: mov      bp, sp
  0x02D2B: push     di
  0x02D2C: push     si
  0x02D2D: mov      si, word ptr [bp + 8]
  0x02D30: or       si, si
  0x02D32: jl       0x2d42
  0x02D34: mov      di, word ptr [bp + 6]
  0x02D37: mov      bx, si
  0x02D39: shl      bx, 4
  0x02D3C: push     word ptr [bx + 0x2f74]
  0x02D40: jmp      0x2d49
  0x02D42: mov      di, word ptr [bp + 6]
  0x02D45: push     word ptr [0x2e0a]
  0x02D49: push     di
  0x02D4A: push     cs
  0x02D4B: call     0x2992
  0x02D4E: add      sp, 4
  0x02D51: cmp      si, 8
  0x02D54: jl       0x2d6f
  0x02D56: cmp      si, 0x18
  0x02D59: jge      0x2d6f
  0x02D5B: push     di
  0x02D5C: push     cs
  0x02D5D: call     0x28b0
  0x02D60: add      sp, 2
  0x02D63: push     word ptr [0x2db0]
  0x02D67: push     di
  0x02D68: push     cs
  0x02D69: call     0x2992
  0x02D6C: add      sp, 4
  0x02D6F: pop      si
  0x02D70: pop      di
  0x02D71: leave    
  0x02D72: retf     

============================================================
func_L045 at file 0x02D74, 215 bytes
============================================================
  0x02D74: enter    0xc, 0
  0x02D78: push     dx
  0x02D79: push     ax
  0x02D7A: push     si
  0x02D7B: mov      word ptr [bp - 0xa], 0
  0x02D80: or       dx, dx
  0x02D82: jne      0x2d87
  0x02D84: jmp      0x2e46
  0x02D87: or       bx, bx
  0x02D89: jne      0x2d8e
  0x02D8B: jmp      0x2e46
  0x02D8E: mov      bx, word ptr [bp + 8]
  0x02D91: mov      word ptr [bx], 0
  0x02D95: mov      si, word ptr [bp - 0x10]
  0x02D98: mov      ax, si
  0x02D9A: shl      si, 1
  0x02D9C: add      si, ax
  0x02D9E: shl      si, 2
  0x02DA1: les      bx, ptr [0x83e]
  0x02DA5: mov      ax, word ptr es:[bx + si + 0x3e]
  0x02DA9: mov      word ptr [bp - 2], ax
  0x02DAC: test     byte ptr [bp + 6], 2
  0x02DB0: je       0x2db7
  0x02DB2: inc      ax
  0x02DB3: inc      ax
  0x02DB4: mov      word ptr [bp - 2], ax
  0x02DB7: mov      ax, word ptr [bp + 0xe]
  0x02DBA: sub      ax, word ptr [bp - 2]
  0x02DBD: mov      word ptr [bp - 0xc], ax
  0x02DC0: cmp      word ptr [bp - 0xe], 1
  0x02DC4: jle      0x2de4
  0x02DC6: mov      cx, word ptr [bp - 0xe]
  0x02DC9: dec      cx
  0x02DCA: cdq      
  0x02DCB: idiv     cx
  0x02DCD: mov      cx, word ptr [bp - 2]
  0x02DD0: inc      cx
  0x02DD1: cmp      ax, cx
  0x02DD3: jle      0x2dd7
  0x02DD5: mov      ax, cx
  0x02DD7: cmp      ax, 1
  0x02DDA: jge      0x2ddf
  0x02DDC: mov      ax, 1
  0x02DDF: mov      word ptr [bp - 0xa], ax
  0x02DE2: jmp      0x2de9
  0x02DE4: mov      word ptr [bp - 0xa], 1
  0x02DE9: mov      ax, word ptr [bp - 0xe]
  0x02DEC: dec      ax
  0x02DED: imul     word ptr [bp - 0xa]
  0x02DF0: mov      word ptr [bp - 4], ax
  0x02DF3: jmp      0x2dff
  0x02DF5: nop      
  0x02DF6: inc      word ptr [bx]
  0x02DF8: mov      cl, byte ptr [bx]
  0x02DFA: mov      ax, word ptr [bp - 4]
  0x02DFD: sar      ax, cl
  0x02DFF: add      ax, word ptr [bp - 2]
  0x02E02: mov      word ptr [bp - 6], ax
  0x02E05: mov      bx, word ptr [bp + 8]
  0x02E08: mov      cl, byte ptr [bx]
  0x02E0A: mov      ax, word ptr [bp - 4]
  0x02E0D: sar      ax, cl
  0x02E0F: cmp      ax, word ptr [bp - 0xc]
  0x02E12: jg       0x2df6
  0x02E14: mov      ax, word ptr [bp + 0xc]
  0x02E17: dec      ax
  0x02E18: cmp      ax, word ptr [bp - 6]
  0x02E1B: jle      0x2e22
  0x02E1D: mov      ax, word ptr [bp + 0xc]
  0x02E20: jmp      0x2e25
  0x02E22: mov      ax, word ptr [bp + 0xe]
  0x02E25: sub      ax, word ptr [bp - 6]
  0x02E28: mov      word ptr [bp - 8], ax
  0x02E2B: cmp      word ptr [bp + 0xa], 0
  0x02E2F: je       0x2e36
  0x02E31: mov      bx, word ptr [bp + 0xa]
  0x02E34: mov      word ptr [bx], ax
  0x02E36: cmp      word ptr [bp + 0xc], 0
  0x02E3A: je       0x2e46
  0x02E3C: mov      ax, word ptr [bp - 8]
  0x02E3F: sar      ax, 1
  0x02E41: mov      bx, word ptr [bp + 0x12]
  0x02E44: add      word ptr [bx], ax
  0x02E46: mov      ax, word ptr [bp - 0xa]
  0x02E49: pop      si
  0x02E4A: leave    

============================================================
func_L046 at file 0x02E4E, 149 bytes
============================================================
  0x02E4E: enter    0x16, 0
  0x02E52: cmp      word ptr [bp + 6], 0
  0x02E56: jg       0x2e5b
  0x02E58: jmp      0x2ee1
  0x02E5B: add      word ptr [bp + 0xa], 2
  0x02E5F: push     0xa
  0x02E61: lea      ax, [bp - 0x16]
  0x02E64: push     ax
  0x02E65: push     word ptr [bp + 6]
  0x02E68: lcall    0xd1d, 0x8fa
  0x02E6D: add      sp, 6
  0x02E70: push     word ptr [0x8a0]
  0x02E74: push     word ptr [0x89e]
  0x02E78: lea      ax, [bp - 0x16]
  0x02E7B: push     ss
  0x02E7C: push     ax
  0x02E7D: sub      ax, ax
  0x02E7F: lcall    0xc2a, 6
  0x02E84: dec      ax
  0x02E85: mov      word ptr [bp - 2], ax
  0x02E88: cmp      word ptr [bp + 0xe], 0
  0x02E8C: je       0x2eb1
  0x02E8E: push     word ptr [0x2dae]
  0x02E92: push     word ptr [0x2dac]
  0x02E96: push     word ptr [0x2daa]
  0x02E9A: push     word ptr [0x2da8]  ; map_terrain
  0x02E9E: push     7
  0x02EA0: push     0
  0x02EA2: mov      bx, ax
  0x02EA4: inc      bx
  0x02EA5: inc      bx
  0x02EA6: mov      ax, word ptr [bp + 8]
  0x02EA9: mov      dx, word ptr [bp + 0xa]
  0x02EAC: lcall    0xb9e, 0xa
  0x02EB1: push     word ptr [bp + 0xc]
  0x02EB4: mov      ax, 0xffff
  0x02EB7: mov      dx, word ptr [bp + 0xc]
  0x02EBA: mov      bx, dx
  0x02EBC: lcall    0xc28, 0xa
  0x02EC1: push     word ptr [0x8a0]
  0x02EC5: push     word ptr [0x89e]
  0x02EC9: lea      ax, [bp - 0x16]
  0x02ECC: push     ss
  0x02ECD: push     ax
  0x02ECE: push     0
  0x02ED0: mov      ax, word ptr [bp + 8]
  0x02ED3: inc      ax
  0x02ED4: mov      dx, word ptr [bp + 0xa]
  0x02ED7: inc      dx
  0x02ED8: lea      bx, [0x2da8]  ; map_terrain
  0x02EDC: lcall    0xc11, 0xc
  0x02EE1: leave    
  0x02EE2: retf     

============================================================
func_L047 at file 0x02EE4, 355 bytes
============================================================
  0x02EE4: enter    0x1a, 0
  0x02EE8: push     bx
  0x02EE9: push     dx
  0x02EEA: push     ax
  0x02EEB: mov      word ptr [bp - 0x12], 0
  0x02EF0: lea      cx, [bp + 0x10]
  0x02EF3: push     cx
  0x02EF4: push     word ptr [bp + 0xe]
  0x02EF7: push     word ptr [bp + 0xc]
  0x02EFA: push     word ptr [bp + 0xa]
  0x02EFD: lea      cx, [bp - 4]
  0x02F00: push     cx
  0x02F01: lea      cx, [bp - 0x14]
  0x02F04: push     cx
  0x02F05: push     word ptr [bp + 6]
  0x02F08: push     cs
  0x02F09: call     0x2d74
  0x02F0C: mov      word ptr [bp - 0x16], ax
  0x02F0F: or       ax, ax
  0x02F11: jne      0x2f16
  0x02F13: jmp      0x3046
  0x02F16: mov      word ptr [bp - 8], 0
  0x02F1B: mov      ax, word ptr [bp + 8]
  0x02F1E: mov      word ptr [bp - 0xa], ax
  0x02F21: sub      ax, word ptr [bp - 0x1c]
  0x02F24: neg      ax
  0x02F26: mov      word ptr [bp - 0x18], ax
  0x02F29: mov      word ptr [bp - 6], ax
  0x02F2C: mov      cl, byte ptr [bp - 0x14]
  0x02F2F: sar      word ptr [bp + 8], cl
  0x02F32: sar      word ptr [bp - 0x18], cl
  0x02F35: mov      ax, word ptr [bp - 0x1e]
  0x02F38: sar      ax, cl
  0x02F3A: mov      word ptr [bp - 0xc], ax
  0x02F3D: mov      ax, word ptr [bp - 0x1c]
  0x02F40: sar      ax, cl
  0x02F42: mov      word ptr [bp - 0x1a], ax
  0x02F45: cmp      word ptr [bp - 0x14], 0
  0x02F49: je       0x2f58
  0x02F4B: mov      al, byte ptr [bp - 0xa]
  0x02F4E: and      al, byte ptr [bp - 6]
  0x02F51: test     al, 1
  0x02F53: je       0x2f58
  0x02F55: inc      word ptr [bp - 6]
  0x02F58: mov      ax, word ptr [bp + 0x10]
  0x02F5B: mov      word ptr [bp - 0xe], ax
  0x02F5E: mov      word ptr [bp - 0x10], 0
  0x02F63: jmp      0x2fd9
  0x02F65: nop      
  0x02F66: push     word ptr [0x840]
  0x02F6A: push     word ptr [0x83e]
  0x02F6E: mov      ax, word ptr [bp + 0xe]
  0x02F71: inc      ax
  0x02F72: push     ax
  0x02F73: mov      ax, word ptr [bp - 0x20]
  0x02F76: lea      bx, [0x2da8]  ; map_terrain
  0x02F7A: mov      dx, word ptr [bp + 0x10]
  0x02F7D: lcall    0xc36, 0xa
  0x02F82: mov      ax, word ptr [bp - 0x10]
  0x02F85: cmp      word ptr [bp - 0x18], ax
  0x02F88: jne      0x2f90
  0x02F8A: mov      ax, word ptr [bp + 0x10]
  0x02F8D: mov      word ptr [bp - 0x12], ax
  0x02F90: mov      ax, word ptr [bp - 0x10]
  0x02F93: cmp      word ptr [bp - 0x18], ax
  0x02F96: jg       0x2fb4
  0x02F98: push     word ptr [0x840]
  0x02F9C: push     word ptr [0x83e]
  0x02FA0: mov      ax, word ptr [bp + 0xe]
  0x02FA3: inc      ax
  0x02FA4: push     ax
  0x02FA5: mov      ax, 0x38
  0x02FA8: lea      bx, [0x2da8]  ; map_terrain
  0x02FAC: mov      dx, word ptr [bp + 0x10]
  0x02FAF: lcall    0xc36, 0xa
  0x02FB4: mov      ax, word ptr [bp - 0x16]
  0x02FB7: add      word ptr [bp + 0x10], ax
  0x02FBA: test     byte ptr [bp + 6], 1
  0x02FBE: je       0x2fd6
  0x02FC0: mov      ax, word ptr [bp - 4]
  0x02FC3: add      word ptr [bp - 8], ax
  0x02FC6: jmp      0x2fce
  0x02FC8: sub      word ptr [bp - 8], ax
  0x02FCB: inc      word ptr [bp + 0x10]
  0x02FCE: mov      ax, word ptr [bp - 0xc]
  0x02FD1: cmp      word ptr [bp - 8], ax
  0x02FD4: jge      0x2fc8
  0x02FD6: inc      word ptr [bp - 0x10]
  0x02FD9: mov      ax, word ptr [bp - 0x1a]
  0x02FDC: cmp      word ptr [bp - 0x10], ax
  0x02FDF: jge      0x2ffe
  0x02FE1: test     byte ptr [bp + 6], 2
  0x02FE5: jne      0x2fea
  0x02FE7: jmp      0x2f66
  0x02FEA: push     3
  0x02FEC: mov      bx, word ptr [bp + 0xe]
  0x02FEF: inc      bx
  0x02FF0: mov      ax, word ptr [bp - 0x20]
  0x02FF3: mov      dx, word ptr [bp + 0x10]
  0x02FF6: lcall    0x12b, 0x15c
  0x02FFB: jmp      0x2f82
  0x02FFD: nop      
  0x02FFE: mov      ax, word ptr [0x70]
  0x03001: mov      word ptr [bp - 2], ax
  0x03004: cmp      word ptr [bp - 0x16], 1
  0x03008: jne      0x3015
  0x0300A: cmp      word ptr [bp - 0x1c], 1
  0x0300E: jle      0x3015
  0x03010: mov      word ptr [bp - 2], 1
  0x03015: cmp      word ptr [bp - 2], 0
  0x03019: je       0x3046
  0x0301B: push     1
  0x0301D: push     0xf
  0x0301F: push     word ptr [bp + 0xe]
  0x03022: mov      ax, word ptr [bp - 0xe]
  0x03025: inc      ax
  0x03026: inc      ax
  0x03027: push     ax
  0x03028: push     word ptr [bp - 6]
  0x0302B: push     cs
  0x0302C: call     0x2e4e
  0x0302F: add      sp, 0xa
  0x03032: push     1
  0x03034: push     0xc
  0x03036: push     word ptr [bp + 0xe]
  0x03039: mov      ax, word ptr [bp - 0x12]
  0x0303C: inc      ax
  0x0303D: inc      ax
  0x0303E: push     ax
  0x0303F: push     word ptr [bp - 0xa]
  0x03042: push     cs
  0x03043: call     0x2e4e
  0x03046: leave    

============================================================
func_L048 at file 0x0304A, 142 bytes
============================================================
  0x0304A: enter    0xc, 0
  0x0304E: push     bx
  0x0304F: push     dx
  0x03050: push     ax
  0x03051: push     si
  0x03052: mov      word ptr [bp - 0xc], 0xffff
  0x03057: lea      cx, [bp + 0xe]
  0x0305A: push     cx
  0x0305B: push     word ptr [bp + 0xc]
  0x0305E: push     word ptr [bp + 0xa]
  0x03061: push     word ptr [bp + 8]
  0x03064: push     0
  0x03066: lea      cx, [bp - 6]
  0x03069: push     cx
  0x0306A: push     word ptr [bp + 6]
  0x0306D: push     cs
  0x0306E: call     0x2d74
  0x03071: mov      word ptr [bp - 0xa], ax
  0x03074: or       ax, ax
  0x03076: jne      0x307b
  0x03078: jmp      0x30fc
  0x0307B: mov      si, word ptr [bp - 0x12]
  0x0307E: mov      ax, si
  0x03080: shl      si, 1
  0x03082: add      si, ax
  0x03084: shl      si, 2
  0x03087: les      bx, ptr [0x83e]
  0x0308B: mov      ax, word ptr es:[bx + si + 0x3e]
  0x0308F: mov      word ptr [bp - 4], ax
  0x03092: test     byte ptr [bp + 6], 2
  0x03096: je       0x309d
  0x03098: inc      ax
  0x03099: inc      ax
  0x0309A: mov      word ptr [bp - 4], ax
  0x0309D: mov      si, word ptr [bp - 0x12]
  0x030A0: mov      ax, si
  0x030A2: shl      si, 1
  0x030A4: add      si, ax
  0x030A6: shl      si, 2
  0x030A9: mov      ax, word ptr es:[bx + si + 0x40]
  0x030AD: mov      word ptr [bp - 8], ax
  0x030B0: mov      ax, word ptr [bp - 0xe]
  0x030B3: dec      ax
  0x030B4: mov      cx, ax
  0x030B6: imul     word ptr [bp - 0xa]
  0x030B9: add      word ptr [bp + 0xe], ax
  0x030BC: mov      word ptr [bp - 2], cx
  0x030BF: jmp      0x30f6
  0x030C1: nop      
  0x030C2: cmp      word ptr [bp - 2], 0
  0x030C6: jl       0x30fc
  0x030C8: mov      ax, word ptr [bp + 0xc]
  0x030CB: add      ax, word ptr [bp - 8]
  0x030CE: push     ax
  0x030CF: mov      dx, word ptr [bp + 0xc]
  0x030D2: inc      dx
  0x030D3: mov      bx, word ptr [bp + 0xe]
  0x030D6: mov      ax, bx

============================================================
func_L049 at file 0x03104, 143 bytes
============================================================
  0x03104: enter    0x24, 0
  0x03108: push     bx
  0x03109: push     dx
  0x0310A: push     ax
  0x0310B: push     si
  0x0310C: sub      ax, ax
  0x0310E: mov      word ptr [bp - 0x22], ax
  0x03111: mov      word ptr [bp - 0x1c], ax
  0x03114: mov      word ptr [bp - 0x24], ax
  0x03117: mov      word ptr [bp - 0x20], ax
  0x0311A: mov      word ptr [bp - 0xa], ax
  0x0311D: mov      word ptr [bp - 0x16], ax
  0x03120: jmp      0x313c
  0x03122: mov      bx, ax
  0x03124: shl      bx, 1
  0x03126: mov      ax, word ptr [bx + 0x2cce]
  0x0312A: add      word ptr [bp - 0x24], ax
  0x0312D: cmp      ax, 1
  0x03130: jle      0x3139
  0x03132: inc      word ptr [bp - 0x20]
  0x03135: dec      ax
  0x03136: add      word ptr [bp - 0xa], ax
  0x03139: inc      word ptr [bp - 0x16]
  0x0313C: mov      ax, word ptr [bp - 0x16]
  0x0313F: cmp      word ptr [0x2ce0], ax
  0x03143: jg       0x3122
  0x03145: sub      ax, ax
  0x03147: mov      word ptr [bp - 0xc], ax
  0x0314A: mov      word ptr [bp - 0x16], ax
  0x0314D: jmp      0x3173
  0x0314F: nop      
  0x03150: mov      bx, ax
  0x03152: shl      bx, 1
  0x03154: mov      si, word ptr [bx + 0x2cf4]
  0x03158: and      si, 0xfff
  0x0315C: mov      ax, si
  0x0315E: shl      si, 1
  0x03160: add      si, ax
  0x03162: shl      si, 2
  0x03165: les      bx, ptr [0x83e]
  0x03169: mov      ax, word ptr es:[bx + si + 0x3e]
  0x0316D: add      word ptr [bp - 0xc], ax
  0x03170: inc      word ptr [bp - 0x16]
  0x03173: mov      ax, word ptr [bp - 0x16]
  0x03176: cmp      word ptr [0x2ce0], ax
  0x0317A: jg       0x3150
  0x0317C: mov      word ptr [bp - 0xe], 0
  0x03181: mov      ax, word ptr [0x2ce0]
  0x03184: imul     word ptr [bp - 0xe]
  0x03187: sub      ax, word ptr [bp - 0xc]
  0x0318A: neg      ax
  0x0318C: or       ax, ax
  0x0318E: jge      0x3192
  0x03190: sub      ax, ax

============================================================
func_L050 at file 0x03193, 37 bytes
============================================================
  0x03193: enter    0x1b8, 0
  0x03197: sub      ax, word ptr [0x2ce0]
  0x0319B: imul     word ptr [bp + 6]
  0x0319E: sub      ax, cx
  0x031A0: add      ax, word ptr [bp - 0x26]
  0x031A3: mov      word ptr [bp - 4], ax
  0x031A6: cmp      ax, word ptr [bp - 0x20]
  0x031A9: jge      0x31c6
  0x031AB: cmp      word ptr [bp + 6], 0
  0x031AF: jle      0x31b6
  0x031B1: dec      word ptr [bp + 6]
  0x031B4: jmp      0x31c6
  0x031B6: or       cx, cx

============================================================
func_L051 at file 0x033F2, 43 bytes
============================================================
  0x033F2: push     bp
  0x033F3: mov      bp, sp
  0x033F5: push     bx
  0x033F6: push     dx
  0x033F7: or       dx, dx
  0x033F9: jne      0x33ff
  0x033FB: or       bx, bx
  0x033FD: je       0x341b
  0x033FF: mov      bx, word ptr [0x2ce0]
  0x03403: shl      bx, 1
  0x03405: mov      word ptr [bx + 0x2cf4], ax
  0x03409: mov      ax, word ptr [bp - 4]
  0x0340C: mov      word ptr [bx + 0x2cce], ax
  0x03410: mov      ax, word ptr [bp - 2]
  0x03413: mov      word ptr [bx + 0x2ce2], ax
  0x03417: inc      word ptr [0x2ce0]
  0x0341B: leave    
  0x0341C: retf     

============================================================
func_L052 at file 0x0341E, 23 bytes
============================================================
  0x0341E: enter    8, 0
  0x03422: mov      ax, word ptr [bp + 6]
  0x03425: cdq      
  0x03426: mov      dh, dl
  0x03428: mov      dl, ah
  0x0342A: mov      ah, al
  0x0342C: sub      al, al
  0x0342E: lcall    0x181f, 0x29a
  0x03433: leave    
  0x03434: retf     

============================================================
func_L053 at file 0x03436, 25 bytes
============================================================
  0x03436: push     bp
  0x03437: mov      bp, sp
  0x03439: cmp      word ptr [bp + 6], 0x11
  0x0343D: je       0x3445
  0x0343F: cmp      word ptr [bp + 6], 9
  0x03443: jne      0x3450
  0x03445: mov      word ptr [bp + 6], 8
  0x0344A: mov      ax, word ptr [bp + 6]
  0x0344D: leave    
  0x0344E: retf     

============================================================
func_L054 at file 0x03460, 12 bytes
============================================================
  0x03460: enter    0xc, 0
  0x03464: push     di
  0x03465: push     si
  0x03466: push     word ptr [bp + 0xa]
  0x03469: push     cs

============================================================
func_L055 at file 0x034C4, 114 bytes
============================================================
  0x034C4: enter    0xc, 0
  0x034C8: push     di
  0x034C9: push     si
  0x034CA: push     word ptr [bp + 0xa]
  0x034CD: push     cs
  0x034CE: call     0x3436
  0x034D1: add      sp, 2
  0x034D4: mov      word ptr [bp + 0xa], ax
  0x034D7: mov      bx, word ptr [bp + 0xc]
  0x034DA: mov      ax, word ptr [bp + 0xe]
  0x034DD: mov      dx, word ptr [bp + 0x10]
  0x034E0: lcall    0xa4e, 8
  0x034E5: mov      word ptr [bp - 4], ax
  0x034E8: mov      word ptr [bp - 2], dx
  0x034EB: mov      bx, word ptr [bp + 0xc]
  0x034EE: mov      ax, word ptr [bx + 2]
  0x034F1: mov      word ptr [bp - 8], ax
  0x034F4: sub      ax, 0x10
  0x034F7: mov      word ptr [bp - 6], ax
  0x034FA: mov      ah, byte ptr [bp + 0xa]
  0x034FD: sub      al, al
  0x034FF: add      ax, word ptr [bp + 6]
  0x03502: mov      dx, word ptr [bp + 8]
  0x03505: mov      word ptr [bp - 0xc], ax
  0x03508: mov      word ptr [bp - 0xa], dx
  0x0350B: push     ds
  0x0350C: les      di, ptr [bp - 4]
  0x0350F: lds      si, ptr [bp - 0xc]
  0x03512: mov      bx, 0x10
  0x03515: mov      dx, word ptr [bp - 6]
  0x03518: mov      cx, 0x10
  0x0351B: mov      al, byte ptr es:[di]
  0x0351E: or       al, al
  0x03520: jne      0x3528
  0x03522: movsb    byte ptr es:[di], byte ptr [si]
  0x03523: loop     0x351b
  0x03525: jmp      0x352c
  0x03527: nop      
  0x03528: inc      di
  0x03529: inc      si
  0x0352A: loop     0x351b
  0x0352C: add      di, dx
  0x0352E: dec      bx
  0x0352F: jne      0x3518
  0x03531: pop      ds
  0x03532: pop      si
  0x03533: pop      di
  0x03534: leave    
  0x03535: retf     

============================================================
func_L056 at file 0x03536, 182 bytes
============================================================
  0x03536: enter    0x1a, 0
  0x0353A: push     di
  0x0353B: push     si
  0x0353C: push     word ptr [bp + 0xa]
  0x0353F: push     cs
  0x03540: call     0x3436
  0x03543: add      sp, 2
  0x03546: mov      word ptr [bp + 0xa], ax
  0x03549: mov      cl, byte ptr [bp + 0x12]
  0x0354C: mov      ax, 0x10
  0x0354F: sar      ax, cl
  0x03551: mov      word ptr [bp - 0x12], ax
  0x03554: mov      word ptr [bp - 0x14], ax
  0x03557: mov      dx, 1
  0x0355A: shl      dx, cl
  0x0355C: mov      word ptr [bp - 0xa], dx
  0x0355F: mov      bx, ax
  0x03561: dec      ax
  0x03562: neg      ax
  0x03564: add      word ptr [bp + 0x10], ax
  0x03567: mov      ax, dx
  0x03569: mov      dx, bx
  0x0356B: sar      bx, 1
  0x0356D: sub      word ptr [bp + 0xe], bx
  0x03570: mov      si, ax
  0x03572: mov      bx, word ptr [bp + 0xc]
  0x03575: mov      ax, word ptr [bp + 0xe]
  0x03578: mov      di, dx
  0x0357A: mov      dx, word ptr [bp + 0x10]
  0x0357D: lcall    0xa4e, 8
  0x03582: mov      word ptr [bp - 6], ax
  0x03585: mov      word ptr [bp - 4], dx
  0x03588: mov      bx, word ptr [bp + 0xc]
  0x0358B: mov      ax, word ptr [bx + 2]
  0x0358E: mov      word ptr [bp - 0xe], ax
  0x03591: sub      ax, di
  0x03593: mov      word ptr [bp - 0xc], ax
  0x03596: mov      cl, byte ptr [bp + 0x12]
  0x03599: mov      ax, 0x10
  0x0359C: shl      ax, cl
  0x0359E: mov      word ptr [bp - 2], ax
  0x035A1: sar      si, 1
  0x035A3: mov      word ptr [bp - 8], si
  0x035A6: shl      si, 4
  0x035A9: mov      word ptr [bp - 0x16], si
  0x035AC: mov      ah, byte ptr [bp + 0xa]
  0x035AF: sub      al, al
  0x035B1: add      ax, word ptr [bp + 6]
  0x035B4: mov      dx, word ptr [bp + 8]
  0x035B7: mov      word ptr [bp - 0x1a], ax
  0x035BA: mov      word ptr [bp - 0x18], dx
  0x035BD: push     ds
  0x035BE: les      di, ptr [bp - 6]
  0x035C1: lds      si, ptr [bp - 0x1a]
  0x035C4: add      si, word ptr [bp - 8]
  0x035C7: add      si, word ptr [bp - 0x16]
  0x035CA: mov      bx, word ptr [bp - 0x14]
  0x035CD: mov      word ptr [bp - 0x10], si
  0x035D0: mov      cx, word ptr [bp - 0x12]
  0x035D3: mov      al, byte ptr [si]
  0x035D5: stosb    byte ptr es:[di], al
  0x035D6: add      si, word ptr [bp - 0xa]
  0x035D9: loop     0x35d3
  0x035DB: mov      si, word ptr [bp - 0x10]
  0x035DE: add      si, word ptr [bp - 2]
  0x035E1: add      di, word ptr [bp - 0xc]
  0x035E4: dec      bx
  0x035E5: jne      0x35cd
  0x035E7: pop      ds
  0x035E8: pop      si
  0x035E9: pop      di
  0x035EA: leave    
  0x035EB: retf     

============================================================
func_L057 at file 0x035EC, 197 bytes
============================================================
  0x035EC: enter    0x1a, 0
  0x035F0: push     di
  0x035F1: push     si
  0x035F2: push     word ptr [bp + 0xa]
  0x035F5: push     cs
  0x035F6: call     0x3436
  0x035F9: add      sp, 2
  0x035FC: mov      word ptr [bp + 0xa], ax
  0x035FF: mov      cl, byte ptr [bp + 0x12]
  0x03602: mov      ax, 0x10
  0x03605: sar      ax, cl
  0x03607: mov      word ptr [bp - 0x12], ax
  0x0360A: mov      word ptr [bp - 0x14], ax
  0x0360D: mov      dx, 1
  0x03610: shl      dx, cl
  0x03612: mov      word ptr [bp - 0xa], dx
  0x03615: mov      bx, ax
  0x03617: dec      ax
  0x03618: neg      ax
  0x0361A: add      word ptr [bp + 0x10], ax
  0x0361D: mov      ax, dx
  0x0361F: mov      dx, bx
  0x03621: sar      bx, 1
  0x03623: sub      word ptr [bp + 0xe], bx
  0x03626: mov      si, ax
  0x03628: mov      bx, word ptr [bp + 0xc]
  0x0362B: mov      ax, word ptr [bp + 0xe]
  0x0362E: mov      di, dx
  0x03630: mov      dx, word ptr [bp + 0x10]
  0x03633: lcall    0xa4e, 8
  0x03638: mov      word ptr [bp - 6], ax
  0x0363B: mov      word ptr [bp - 4], dx
  0x0363E: mov      bx, word ptr [bp + 0xc]
  0x03641: mov      ax, word ptr [bx + 2]
  0x03644: mov      word ptr [bp - 0xe], ax
  0x03647: sub      ax, di
  0x03649: mov      word ptr [bp - 0xc], ax
  0x0364C: mov      cl, byte ptr [bp + 0x12]
  0x0364F: mov      ax, 0x10
  0x03652: shl      ax, cl
  0x03654: mov      word ptr [bp - 2], ax
  0x03657: sar      si, 1
  0x03659: mov      word ptr [bp - 8], si
  0x0365C: shl      si, 4
  0x0365F: mov      word ptr [bp - 0x16], si
  0x03662: mov      ah, byte ptr [bp + 0xa]
  0x03665: sub      al, al
  0x03667: add      ax, word ptr [bp + 6]
  0x0366A: mov      dx, word ptr [bp + 8]
  0x0366D: mov      word ptr [bp - 0x1a], ax
  0x03670: mov      word ptr [bp - 0x18], dx
  0x03673: push     ds
  0x03674: les      di, ptr [bp - 6]
  0x03677: lds      si, ptr [bp - 0x1a]
  0x0367A: add      si, word ptr [bp - 8]
  0x0367D: add      si, word ptr [bp - 0x16]
  0x03680: mov      bx, word ptr [bp - 0x14]
  0x03683: mov      word ptr [bp - 0x10], si
  0x03686: mov      cx, word ptr [bp - 0x12]
  0x03689: mov      al, byte ptr es:[di]
  0x0368C: or       al, al
  0x0368E: jne      0x369a
  0x03690: mov      al, byte ptr [si]
  0x03692: stosb    byte ptr es:[di], al
  0x03693: add      si, word ptr [bp - 0xa]
  0x03696: loop     0x3689
  0x03698: jmp      0x36a0
  0x0369A: inc      si
  0x0369B: add      si, word ptr [bp - 0xa]
  0x0369E: loop     0x3689
  0x036A0: mov      si, word ptr [bp - 0x10]
  0x036A3: add      si, word ptr [bp - 2]
  0x036A6: add      di, word ptr [bp - 0xc]
  0x036A9: dec      bx
  0x036AA: jne      0x3683
  0x036AC: pop      ds
  0x036AD: pop      si
  0x036AE: pop      di
  0x036AF: leave    
  0x036B0: retf     

============================================================
func_L058 at file 0x036B3, 63 bytes
============================================================
  0x036B3: enter    0x132d, 0
  0x036B7: cmp      ax, 9
  0x036BA: ja       0x36d8
  0x036BC: shl      ax, 1
  0x036BE: xchg     bx, ax
  0x036BF: jmp      word ptr cs:[bx + 0x14]
  0x036C4: xor      byte ptr [bx + si], al
  0x036C6: add      byte ptr ss:[si], bh
  0x036C9: add      byte ptr [bp + si], al
  0x036CC: sub      byte ptr [bx + si], al
  0x036CE: dec      ax
  0x036CF: add      byte ptr [bp], cl
  0x036D2: push     sp
  0x036D3: add      byte ptr [bp + si], bl
  0x036D6: xor      byte ptr [bx + si], al
  0x036D8: mov      dx, cx
  0x036DA: add      dx, 0x52
  0x036DD: jmp      0x370d
  0x036DF: nop      
  0x036E0: mov      dx, 0x65
  0x036E3: jmp      0x370d
  0x036E5: nop      
  0x036E6: mov      dx, 0x3b
  0x036E9: jmp      0x370d
  0x036EB: nop      
  0x036EC: mov      dx, 0x3c
  0x036EF: mov      ax, dx
  0x036F1: retf     

============================================================
func_L059 at file 0x03710, 20 bytes
============================================================
  0x03710: enter    4, 0
  0x03714: push     di
  0x03715: push     si
  0x03716: imul     bx, ax, 0x1c  ; *Unit
  0x03719: mov      word ptr [bp - 4], bx
  0x0371C: mov      bl, byte ptr [bx + 0x3146]
  0x03720: sub      bh, bh
  0x03722: mov      cx, bx

============================================================
func_L060 at file 0x037BE, 78 bytes
============================================================
  0x037BE: enter    2, 0
  0x037C2: push     bx
  0x037C3: push     ax
  0x037C4: push     di
  0x037C5: push     si
  0x037C6: or       dx, dx
  0x037C8: je       0x37fa
  0x037CA: mov      di, 0xffff
  0x037CD: lcall    0x427, 2
  0x037D2: mov      si, ax
  0x037D4: or       si, si
  0x037D6: jl       0x37f6
  0x037D8: imul     bx, si, 0x1c  ; *Unit
  0x037DB: mov      al, byte ptr [bx + 0x3146]
  0x037DF: cmp      al, 0xd
  0x037E1: jb       0x37e9
  0x037E3: cmp      al, 0x12
  0x037E5: ja       0x37e9
  0x037E7: mov      di, si
  0x037E9: mov      ax, si
  0x037EB: lcall    0x427, 0x4a
  0x037F0: mov      si, ax
  0x037F2: or       di, di
  0x037F4: jl       0x37d4
  0x037F6: or       di, di
  0x037F8: jge      0x37fd
  0x037FA: mov      di, word ptr [bp - 6]
  0x037FD: mov      ax, di
  0x037FF: mov      bx, word ptr [bp - 4]
  0x03802: mov      word ptr [bx], ax
  0x03804: push     cs
  0x03805: call     0x3710
  0x03808: pop      si
  0x03809: pop      di
  0x0380A: leave    
  0x0380B: retf     

============================================================
func_L061 at file 0x0380C, 567 bytes
============================================================
  0x0380C: push     bp
  0x0380D: mov      bp, sp
  0x0380F: push     bx
  0x03810: push     ax
  0x03811: push     di
  0x03812: push     si
  0x03813: mov      di, dx
  0x03815: mov      si, word ptr [bp + 6]
  0x03818: test     si, 1
  0x0381C: je       0x3843
  0x0381E: push     word ptr [0x840]
  0x03822: push     word ptr [0x83e]
  0x03826: push     bx
  0x03827: mov      ax, si
  0x03829: and      ax, 4
  0x0382C: cmp      ax, 1
  0x0382F: cmc      
  0x03830: sbb      al, al
  0x03832: and      al, 0x5f
  0x03834: push     ax
  0x03835: mov      ax, word ptr [bp - 4]
  0x03838: lea      bx, [0x2da8]  ; map_terrain
  0x0383C: mov      dx, di
  0x0383E: lcall    0xcd8, 4
  0x03843: mov      ax, si
  0x03845: test     al, 2
  0x03847: je       0x3863
  0x03849: push     word ptr [0x840]
  0x0384D: push     word ptr [0x83e]
  0x03851: push     word ptr [bp - 2]
  0x03854: lea      dx, [di + 2]
  0x03857: mov      ax, word ptr [bp - 4]
  0x0385A: lea      bx, [0x2da8]  ; map_terrain
  0x0385E: lcall    0xc36, 0xa
  0x03863: pop      si
  0x03864: pop      di
  0x03865: leave    
  0x03866: retf     2
  0x03869: nop      
  0x0386A: enter    0x46, 0
  0x0386E: push     bx
  0x0386F: push     dx
  0x03870: push     ax
  0x03871: push     di
  0x03872: push     si
  0x03873: mov      si, ax
  0x03875: mov      word ptr [bp - 0x1e], 0
  0x0387A: and      byte ptr [bp - 0x4a], 0xdf
  0x0387E: mov      dx, word ptr [bp - 0x4a]
  0x03881: and      dx, 0x40
  0x03884: lea      bx, [bp - 0x2a]
  0x03887: push     cs
  0x03888: call     0x37be
  0x0388B: mov      word ptr [bp - 0xc], ax
  0x0388E: test     byte ptr [bp - 0x4a], 0x80
  0x03892: je       0x38ac
  0x03894: mov      ax, si
  0x03896: lcall    0x427, 2
  0x0389B: lcall    0x427, 0x4a
  0x038A0: or       ax, ax
  0x038A2: jl       0x38ac
  0x038A4: mov      word ptr [bp - 0x1c], 1
  0x038A9: jmp      0x38b1
  0x038AB: nop      
  0x038AC: mov      word ptr [bp - 0x1c], 0
  0x038B1: mov      word ptr [bp - 0x12], 0
  0x038B6: imul     bx, word ptr [bp - 0x2a], 0x1c  ; *Unit
  0x038BA: mov      word ptr [bp - 0x40], bx
  0x038BD: mov      al, byte ptr [bx + 0x3146]
  0x038C1: mov      cx, ax
  0x038C3: sub      ah, ah
  0x038C5: mov      si, ax
  0x038C7: cmp      cl, 0xd
  0x038CA: jae      0x38cf
  0x038CC: jmp      0x399e
  0x038CF: cmp      al, 0x12
  0x038D1: jbe      0x38d6
  0x038D3: jmp      0x399e
  0x038D6: cmp      si, 0xf
  0x038D9: jne      0x38de
  0x038DB: jmp      0x3996
  0x038DE: cmp      si, 0x10
  0x038E1: jne      0x38e6
  0x038E3: jmp      0x3996
  0x038E6: cmp      si, 0x11
  0x038E9: jne      0x38ee
  0x038EB: jmp      0x3996
  0x038EE: cmp      si, 0x12
  0x038F1: jne      0x38f6
  0x038F3: jmp      0x3996
  0x038F6: mov      word ptr [bp - 0x12], 3
  0x038FB: mov      bx, word ptr [bp - 0x40]
  0x038FE: mov      al, byte ptr [bx + 0x3147]
  0x03902: and      ax, 0xf  ; 6.25% chance
  0x03905: mov      di, ax
  0x03907: mov      cl, byte ptr [bx + 0x314c]
  0x0390B: sub      ch, ch
  0x0390D: mov      word ptr [bp - 0xa], cx
  0x03910: cmp      ax, 4
  0x03913: jl       0x391a
  0x03915: mov      word ptr [bp - 0xa], 0
  0x0391A: mov      bx, word ptr [bp - 0xa]
  0x0391D: mov      al, byte ptr [bx + 0x54de]
  0x03921: mov      byte ptr [bp - 1], al
  0x03924: mov      bx, word ptr [bp - 0x40]
  0x03927: cmp      byte ptr [bx + 0x3146], 0xd
  0x0392C: jb       0x3959
  0x0392E: cmp      byte ptr [bx + 0x3146], 0x12
  0x03933: ja       0x3959
  0x03935: cmp      word ptr [0x5396], di
  0x03939: je       0x3959
  0x0393B: mov      al, byte ptr [bx + 0x3150]
  0x0393F: add      al, 0x30
  0x03941: mov      byte ptr [bp - 1], al
  0x03944: cmp      si, 0x10
  0x03947: jne      0x3959
  0x03949: cmp      word ptr [0x53a2], 0
  0x0394E: jne      0x3959
  0x03950: mov      word ptr [bp - 0x1e], 1
  0x03955: mov      byte ptr [bp - 1], 0x58
  0x03959: cmp      di, 4
  0x0395C: jge      0x398a
  0x0395E: jge      0x396a
  0x03960: imul     bx, di, 0x34  ; *AI
  0x03963: cmp      byte ptr [bx + 0x543f], 0  ; ai_pers
  0x03968: je       0x398a
  0x0396A: test     byte ptr [0x5383], 0x20
  0x0396F: je       0x398a
  0x03971: test     byte ptr [0x894], 8
  0x03976: je       0x398a
  0x03978: mov      bx, word ptr [bp - 0x40]
  0x0397B: mov      al, byte ptr [bx + 0x314b]
  0x0397F: mov      byte ptr [bp - 1], al
  0x03982: cmp      al, 0x80
  0x03984: jb       0x398a
  0x03986: mov      byte ptr [bp - 1], 0x45
  0x0398A: cmp      di, 4
  0x0398D: jge      0x3a00
  0x0398F: mov      al, byte ptr [di + 0x848]
  0x03993: jmp      0x3a04
  0x03995: nop      
  0x03996: mov      word ptr [bp - 0x12], 1
  0x0399B: jmp      0x38fb
  0x0399E: cmp      si, 0x15
  0x039A1: jne      0x39a6
  0x039A3: jmp      0x38f6
  0x039A6: cmp      si, 0x16
  0x039A9: jne      0x39ae
  0x039AB: jmp      0x38f6
  0x039AE: cmp      si, 5
  0x039B1: jne      0x39b6
  0x039B3: jmp      0x38f6
  0x039B6: cmp      si, 4
  0x039B9: jne      0x39be
  0x039BB: jmp      0x38f6
  0x039BE: cmp      si, 7
  0x039C1: jne      0x39c6
  0x039C3: jmp      0x38f6
  0x039C6: cmp      si, 8
  0x039C9: jne      0x39ce
  0x039CB: jmp      0x38f6
  0x039CE: cmp      si, 0xc
  0x039D1: je       0x39e0
  0x039D3: cmp      si, 0xa
  0x039D6: je       0x39e0
  0x039D8: cmp      si, 0xb
  0x039DB: je       0x39e0
  0x039DD: jmp      0x38fb
  0x039E0: mov      word ptr [bp - 0x12], 2
  0x039E5: cmp      si, 0xb
  0x039E8: je       0x39ed
  0x039EA: jmp      0x38fb
  0x039ED: test     byte ptr [bx + 0x3148], 0x80
  0x039F2: jne      0x39f7
  0x039F4: jmp      0x38fb
  0x039F7: mov      word ptr [bp - 0x12], 4
  0x039FC: jmp      0x38fb
  0x039FF: nop      
  0x03A00: mov      al, byte ptr [di + 0x848]
  0x03A04: mov      byte ptr [bp - 0x1f], al
  0x03A07: mov      word ptr [bp - 0x28], di
  0x03A0A: mov      byte ptr [bp - 0xf], al
  0x03A0D: cmp      word ptr [bp - 0x1e], 0
  0x03A11: je       0x3a17
  0x03A13: mov      byte ptr [bp - 0xf], 0
  0x03A17: mov      bx, word ptr [bp - 0x40]
  0x03A1A: test     byte ptr [bx + 0x3148], 0x80
  0x03A1F: je       0x3a30
  0x03A21: cmp      byte ptr [bx + 0x3146], 0xb
  0x03A26: je       0x3a30
  0x03A28: mov      word ptr [bp - 0x18], 1
  0x03A2D: jmp      0x3a35
  0x03A2F: nop      
  0x03A30: mov      word ptr [bp - 0x18], 0
  0x03A35: cmp      word ptr [bp - 0x18], 0
  0x03A39: je       0x3a8c
  0x03A3B: mov      bl, byte ptr [bx + 0x3146]
  0x03A3F: sub      bh, bh
  0x03A41: mov      ax, bx

============================================================
func_L062 at file 0x03E40, 623 bytes
============================================================
  0x03E40: enter    0x60, 0
  0x03E44: push     bx
  0x03E45: push     dx
  0x03E46: push     ax
  0x03E47: push     di
  0x03E48: push     si
  0x03E49: imul     bx, ax, 0x12  ; *TradeRoute
  0x03E4C: mov      word ptr [bp - 0x60], bx
  0x03E4F: mov      al, byte ptr [bx + 0x54ee]
  0x03E53: sub      ah, ah
  0x03E55: sub      ax, 4
  0x03E58: mov      word ptr [bp - 0xc], ax
  0x03E5B: imul     bx, ax, 0x4e
  0x03E5E: mov      al, byte ptr [bx + 0x5ad8]
  0x03E62: sub      ah, ah
  0x03E64: mov      si, ax
  0x03E66: cmp      word ptr [bp + 6], 0x64
  0x03E6A: jge      0x3e80
  0x03E6C: mov      cl, byte ptr [0x184]
  0x03E70: mov      ax, 2
  0x03E73: sar      ax, cl
  0x03E75: sub      word ptr [bp - 0x64], ax
  0x03E78: mov      ax, word ptr [0x5ad4]
  0x03E7B: mov      word ptr [bp - 0xa], ax
  0x03E7E: jmp      0x3e85
  0x03E80: mov      word ptr [bp - 0xa], 0x10
  0x03E85: mov      ax, word ptr [bp - 0x62]
  0x03E88: add      ax, word ptr [bp - 0xa]
  0x03E8B: dec      ax
  0x03E8C: mov      word ptr [bp - 2], ax
  0x03E8F: push     word ptr [0x840]
  0x03E93: push     word ptr [0x83e]
  0x03E97: push     ax
  0x03E98: push     word ptr [bp + 6]
  0x03E9B: mov      ax, si
  0x03E9D: cmp      ax, 3
  0x03EA0: jle      0x3ea5
  0x03EA2: mov      ax, 3
  0x03EA5: add      ax, 0xb
  0x03EA8: mov      dx, word ptr [bp - 0xa]
  0x03EAB: sar      dx, 1
  0x03EAD: add      dx, word ptr [bp - 0x64]
  0x03EB0: mov      word ptr [bp - 4], dx
  0x03EB3: lea      bx, [bp + 8]
  0x03EB6: lcall    0xc56, 4
  0x03EBB: mov      bx, word ptr [bp - 0xc]
  0x03EBE: mov      al, byte ptr [bx + 0x84c]
  0x03EC2: mov      byte ptr [bp - 8], al
  0x03EC5: cmp      word ptr [bp + 6], 0x64
  0x03EC9: je       0x3ece
  0x03ECB: jmp      0x3f8a
  0x03ECE: or       si, si
  0x03ED0: jne      0x3f3a
  0x03ED2: push     word ptr [bp + 0xe]
  0x03ED5: push     word ptr [bp + 0xc]
  0x03ED8: push     word ptr [bp + 0xa]
  0x03EDB: push     word ptr [bp + 8]
  0x03EDE: push     1
  0x03EE0: push     ax
  0x03EE1: mov      ax, word ptr [bp - 0x64]
  0x03EE4: add      ax, 3
  0x03EE7: mov      dx, word ptr [bp - 0x62]
  0x03EEA: add      dx, 4
  0x03EED: mov      bx, 1
  0x03EF0: mov      si, dx
  0x03EF2: lcall    0xb9e, 0xa
  0x03EF7: push     word ptr [bp + 0xe]
  0x03EFA: push     word ptr [bp + 0xc]
  0x03EFD: push     word ptr [bp + 0xa]
  0x03F00: push     word ptr [bp + 8]
  0x03F03: push     1
  0x03F05: mov      al, byte ptr [bp - 8]
  0x03F08: push     ax
  0x03F09: mov      ax, word ptr [bp - 0x64]
  0x03F0C: add      ax, 0xc
  0x03F0F: mov      dx, si
  0x03F11: mov      bx, 1
  0x03F14: lcall    0xb9e, 0xa
  0x03F19: push     word ptr [bp + 0xe]
  0x03F1C: push     word ptr [bp + 0xc]
  0x03F1F: push     word ptr [bp + 0xa]
  0x03F22: push     word ptr [bp + 8]
  0x03F25: push     1
  0x03F27: mov      al, byte ptr [bp - 8]
  0x03F2A: push     ax
  0x03F2B: mov      ax, word ptr [bp - 0x64]
  0x03F2E: add      ax, 9
  0x03F31: mov      dx, word ptr [bp - 0x62]
  0x03F34: add      dx, 6
  0x03F37: jmp      0x4046
  0x03F3A: dec      si
  0x03F3B: je       0x3f40
  0x03F3D: jmp      0x404e
  0x03F40: push     word ptr [bp + 0xe]
  0x03F43: push     word ptr [bp + 0xc]
  0x03F46: push     word ptr [bp + 0xa]
  0x03F49: push     word ptr [bp + 8]
  0x03F4C: push     1
  0x03F4E: mov      al, byte ptr [bp - 8]
  0x03F51: push     ax
  0x03F52: mov      ax, word ptr [bp - 0x64]
  0x03F55: add      ax, 4
  0x03F58: mov      dx, word ptr [bp - 0x62]
  0x03F5B: add      dx, 9
  0x03F5E: mov      bx, 2
  0x03F61: lcall    0xb9e, 0xa
  0x03F66: push     word ptr [bp + 0xe]
  0x03F69: push     word ptr [bp + 0xc]
  0x03F6C: push     word ptr [bp + 0xa]
  0x03F6F: push     word ptr [bp + 8]
  0x03F72: push     1
  0x03F74: mov      al, byte ptr [bp - 8]
  0x03F77: push     ax
  0x03F78: mov      ax, word ptr [bp - 0x64]
  0x03F7B: add      ax, 9
  0x03F7E: mov      dx, word ptr [bp - 0x62]
  0x03F81: add      dx, 0xb
  0x03F84: mov      bx, 3
  0x03F87: jmp      0x4049
  0x03F8A: cmp      word ptr [bp + 6], 0x32
  0x03F8E: je       0x3f93
  0x03F90: jmp      0x404e
  0x03F93: or       si, si
  0x03F95: jne      0x4000
  0x03F97: push     word ptr [bp + 0xe]
  0x03F9A: push     word ptr [bp + 0xc]
  0x03F9D: push     word ptr [bp + 0xa]
  0x03FA0: push     word ptr [bp + 8]
  0x03FA3: push     1
  0x03FA5: mov      al, byte ptr [bp - 8]
  0x03FA8: push     ax
  0x03FA9: mov      ax, word ptr [bp - 0x64]
  0x03FAC: inc      ax
  0x03FAD: inc      ax
  0x03FAE: mov      dx, word ptr [bp - 0x62]
  0x03FB1: inc      dx
  0x03FB2: inc      dx
  0x03FB3: mov      bx, 1
  0x03FB6: mov      si, dx
  0x03FB8: lcall    0xb9e, 0xa
  0x03FBD: push     word ptr [bp + 0xe]
  0x03FC0: push     word ptr [bp + 0xc]
  0x03FC3: push     word ptr [bp + 0xa]
  0x03FC6: push     word ptr [bp + 8]
  0x03FC9: push     1
  0x03FCB: mov      al, byte ptr [bp - 8]
  0x03FCE: push     ax
  0x03FCF: mov      ax, word ptr [bp - 0x64]
  0x03FD2: add      ax, 6
  0x03FD5: mov      dx, si
  0x03FD7: mov      bx, 1
  0x03FDA: lcall    0xb9e, 0xa
  0x03FDF: push     word ptr [bp + 0xe]
  0x03FE2: push     word ptr [bp + 0xc]
  0x03FE5: push     word ptr [bp + 0xa]
  0x03FE8: push     word ptr [bp + 8]
  0x03FEB: push     1
  0x03FED: mov      al, byte ptr [bp - 8]
  0x03FF0: push     ax
  0x03FF1: mov      ax, word ptr [bp - 0x64]
  0x03FF4: add      ax, 5
  0x03FF7: mov      dx, word ptr [bp - 0x62]
  0x03FFA: add      dx, 3
  0x03FFD: jmp      0x4046
  0x03FFF: nop      
  0x04000: dec      si
  0x04001: jne      0x404e
  0x04003: push     word ptr [bp + 0xe]
  0x04006: push     word ptr [bp + 0xc]
  0x04009: push     word ptr [bp + 0xa]
  0x0400C: push     word ptr [bp + 8]
  0x0400F: push     1
  0x04011: mov      al, byte ptr [bp - 8]
  0x04014: push     ax
  0x04015: mov      ax, word ptr [bp - 0x64]
  0x04018: inc      ax
  0x04019: inc      ax
  0x0401A: mov      dx, word ptr [bp - 0x62]
  0x0401D: add      dx, 4
  0x04020: mov      bx, 1
  0x04023: lcall    0xb9e, 0xa
  0x04028: push     word ptr [bp + 0xe]
  0x0402B: push     word ptr [bp + 0xc]
  0x0402E: push     word ptr [bp + 0xa]
  0x04031: push     word ptr [bp + 8]
  0x04034: push     1
  0x04036: mov      al, byte ptr [bp - 8]
  0x04039: push     ax
  0x0403A: mov      ax, word ptr [bp - 0x64]
  0x0403D: add      ax, 5
  0x04040: mov      dx, word ptr [bp - 0x62]
  0x04043: add      dx, 5
  0x04046: mov      bx, 1
  0x04049: lcall    0xb9e, 0xa
  0x0404E: mov      bx, word ptr [bp - 0x60]
  0x04051: test     byte ptr [bx + 0x54ef], 4
  0x04056: je       0x4074
  0x04058: push     word ptr [0x840]
  0x0405C: push     word ptr [0x83e]
  0x04060: push     word ptr [bp - 2]
  0x04063: push     word ptr [bp + 6]
  0x04066: mov      ax, 0x12
  0x04069: lea      bx, [bp + 8]
  0x0406C: mov      dx, word ptr [bp - 4]
  0x0406F: lcall    0xc56, 4
  0x04074: cmp      word ptr [bp + 6], 0x64
  0x04078: je       0x407d
  0x0407A: jmp      0x42e3
  0x0407D: mov      ax, word ptr [bp - 0x64]
  0x04080: add      ax, 6
  0x04083: mov      word ptr [bp - 2], ax
  0x04086: lea      ax, [bp - 0xe]
  0x04089: push     ax
  0x0408A: push     word ptr [bp - 0x66]
  0x0408D: lcall    0x181f, 0x316
  0x04092: add      sp, 4
  0x04095: mov      si, ax
  0x04097: mov      ax, word ptr [bp - 0xe]
  0x0409A: mov      word ptr [bp - 6], ax
  0x0409D: or       si, si
  0x0409F: jge      0x40a4
  0x040A1: jmp      0x41ad
  0x040A4: cmp      word ptr [0x5396], si
  0x040A8: jne      0x410e
  0x040AA: mov      bx, word ptr [bp - 0x66]
  0x040AD: mov      ax, bx

============================================================
func_L063 at file 0x04314, 157 bytes
============================================================
  0x04314: enter    0x26, 0
  0x04318: push     bx
  0x04319: push     dx
  0x0431A: push     ax
  0x0431B: push     di
  0x0431C: push     si
  0x0431D: imul     bx, ax, 0xca  ; *Colony
  0x04321: mov      word ptr [bp - 0x26], bx
  0x04324: mov      al, byte ptr [bx + 0x5d60]  ; colony_tbl
  0x04328: sub      ah, ah
  0x0432A: mov      word ptr [bp - 4], ax
  0x0432D: mov      al, byte ptr [bx + 0x5d65]
  0x04331: cwde     
  0x04332: mov      word ptr [bp - 6], ax
  0x04335: sub      si, si
  0x04337: push     si
  0x04338: push     word ptr [bp - 0x2c]
  0x0433B: lcall    0x5eb, 0x35e
  0x04340: add      sp, 4
  0x04343: or       ax, ax
  0x04345: je       0x434a
  0x04347: mov      si, 1
  0x0434A: push     1
  0x0434C: push     word ptr [bp - 0x2c]
  0x0434F: lcall    0x5eb, 0x35e
  0x04354: add      sp, 4
  0x04357: or       ax, ax
  0x04359: je       0x435c
  0x0435B: inc      si
  0x0435C: push     2
  0x0435E: push     word ptr [bp - 0x2c]
  0x04361: lcall    0x5eb, 0x35e
  0x04366: add      sp, 4
  0x04369: or       ax, ax
  0x0436B: je       0x436e
  0x0436D: inc      si
  0x0436E: mov      word ptr [bp - 2], si
  0x04371: mov      ax, word ptr [0x5396]
  0x04374: cmp      word ptr [bp - 4], ax
  0x04377: je       0x43ce
  0x04379: cmp      word ptr [0x53a2], 0
  0x0437E: jne      0x43ce
  0x04380: mov      bx, word ptr [bp - 0x26]
  0x04383: add      bx, ax
  0x04385: mov      al, byte ptr [bx + 0x5e04]
  0x04389: sub      ah, ah
  0x0438B: mov      di, ax
  0x0438D: mov      al, byte ptr [bx + 0x5e00]
  0x04391: mov      si, ax
  0x04393: mov      word ptr [bp - 6], si
  0x04396: or       si, si
  0x04398: jne      0x43ab
  0x0439A: mov      word ptr [bp - 6], 1
  0x0439F: mov      si, word ptr [bp - 0x26]
  0x043A2: mov      bx, word ptr [0x5396]
  0x043A6: mov      byte ptr [bx + si + 0x5e00], 1
  0x043AB: mov      si, word ptr [bp + 0xa]
  0x043AE: mov      ax, di

============================================================
func_L064 at file 0x043B1, 434 bytes
============================================================
  0x043B1: enter    0x325, 0
  0x043B5: mov      di, ax
  0x043B7: cmp      si, 0x64
  0x043BA: jge      0x43d2
  0x043BC: mov      cl, byte ptr [0x184]
  0x043C0: mov      ax, 2
  0x043C3: sar      ax, cl
  0x043C5: sub      word ptr [bp - 0x2a], ax
  0x043C8: mov      dx, word ptr [0x5ad4]
  0x043CC: jmp      0x43d5
  0x043CE: mov      di, si
  0x043D0: jmp      0x43ab
  0x043D2: mov      dx, 0x10
  0x043D5: mov      ax, dx
  0x043D7: sar      dx, 1
  0x043D9: add      dx, word ptr [bp - 0x2a]
  0x043DC: mov      word ptr [bp - 0xe], dx
  0x043DF: add      ax, word ptr [bp - 0x28]
  0x043E2: dec      ax
  0x043E3: mov      word ptr [bp - 0x10], ax
  0x043E6: mov      ax, word ptr [bp - 0x2a]
  0x043E9: add      ax, 6
  0x043EC: mov      word ptr [bp - 8], ax
  0x043EF: mov      ax, word ptr [bp - 0x28]
  0x043F2: inc      ax
  0x043F3: mov      word ptr [bp - 0xa], ax
  0x043F6: cmp      si, 0x64
  0x043F9: jne      0x440c
  0x043FB: mov      ax, word ptr [bp - 0x2a]
  0x043FE: add      ax, 6
  0x04401: mov      word ptr [bp - 0xa], ax
  0x04404: mov      ax, word ptr [bp - 0x28]
  0x04407: add      ax, 4
  0x0440A: jmp      0x441a
  0x0440C: mov      ax, word ptr [bp - 0x2a]
  0x0440F: add      ax, 3
  0x04412: mov      word ptr [bp - 0xa], ax
  0x04415: mov      ax, word ptr [bp - 0x28]
  0x04418: inc      ax
  0x04419: inc      ax
  0x0441A: mov      word ptr [bp - 0xc], ax
  0x0441D: push     word ptr [0x840]
  0x04421: push     word ptr [0x83e]
  0x04425: push     word ptr [bp - 0x10]
  0x04428: push     si
  0x04429: lea      ax, [di + 1]
  0x0442C: lea      bx, [bp + 0xc]
  0x0442F: mov      dx, word ptr [bp - 0xe]
  0x04432: lcall    0xc56, 4
  0x04437: mov      ax, word ptr [bp - 4]
  0x0443A: mov      word ptr [bp - 8], ax
  0x0443D: mov      al, byte ptr [0x5382]
  0x04440: and      al, 1
  0x04442: je       0x4452
  0x04444: mov      ax, word ptr [0x53d2]
  0x04447: cmp      word ptr [bp - 4], ax
  0x0444A: jne      0x4452
  0x0444C: mov      ax, word ptr [0x5398]
  0x0444F: mov      word ptr [bp - 8], ax
  0x04452: mov      cx, word ptr [bp - 8]
  0x04455: add      cx, 0x77
  0x04458: mov      al, byte ptr [0x5382]
  0x0445B: and      al, 1
  0x0445D: je       0x446a
  0x0445F: mov      ax, word ptr [0x5398]
  0x04462: cmp      word ptr [bp - 4], ax
  0x04465: jne      0x446a
  0x04467: mov      cx, 0x83
  0x0446A: push     word ptr [0x840]
  0x0446E: push     word ptr [0x83e]
  0x04472: push     word ptr [bp - 0xc]
  0x04475: push     si
  0x04476: mov      ax, cx
  0x04478: lea      bx, [bp + 0xc]
  0x0447B: mov      dx, word ptr [bp - 0xa]
  0x0447E: lcall    0xc56, 4
  0x04483: cmp      si, 0x64
  0x04486: je       0x448b
  0x04488: jmp      0x452e
  0x0448B: mov      byte ptr [bp - 1], 0xf
  0x0448F: mov      bx, word ptr [bp - 0x26]
  0x04492: test     byte ptr [bx + 0x5d62], 4
  0x04497: je       0x44a8
  0x04499: mov      byte ptr [bp - 1], 0xa
  0x0449D: test     byte ptr [bx + 0x5d62], 2
  0x044A2: je       0x44a8
  0x044A4: mov      byte ptr [bp - 1], 0xb
  0x044A8: mov      al, byte ptr [bp - 1]
  0x044AB: sub      ah, ah
  0x044AD: push     ax
  0x044AE: mov      dx, ax
  0x044B0: mov      bx, dx
  0x044B2: mov      ax, 0xffff
  0x044B5: lcall    0xc28, 0xa
  0x044BA: cmp      word ptr [bp + 8], 0
  0x044BE: je       0x44f4
  0x044C0: push     0xa
  0x044C2: lea      ax, [bp - 0x24]
  0x044C5: push     ax
  0x044C6: push     word ptr [bp - 6]
  0x044C9: lcall    0xd1d, 0x8fa
  0x044CE: add      sp, 6
  0x044D1: push     word ptr [0x8a0]
  0x044D5: push     word ptr [0x89e]
  0x044D9: lea      ax, [bp - 0x24]
  0x044DC: push     ss
  0x044DD: push     ax
  0x044DE: push     0
  0x044E0: mov      ax, word ptr [bp - 0x2a]
  0x044E3: add      ax, 7
  0x044E6: mov      dx, word ptr [bp - 0x28]
  0x044E9: add      dx, 7
  0x044EC: lea      bx, [bp + 0xc]
  0x044EF: lcall    0xc11, 0xc
  0x044F4: cmp      word ptr [bp + 6], 0
  0x044F8: je       0x452e
  0x044FA: push     0
  0x044FC: mov      ax, 0xffff
  0x044FF: mov      dx, 0xf
  0x04502: sub      bx, bx
  0x04504: lcall    0xc28, 0xa
  0x04509: push     word ptr [0x268c]
  0x0450D: push     word ptr [0x268a]
  0x04511: mov      ax, word ptr [bp - 0x26]
  0x04514: add      ax, 0x5d48
  0x04517: push     ds
  0x04518: push     ax
  0x04519: push     0
  0x0451B: mov      ax, word ptr [bp - 0x2a]
  0x0451E: inc      ax
  0x0451F: inc      ax
  0x04520: mov      dx, word ptr [bp - 0x28]
  0x04523: add      dx, 0x10
  0x04526: lea      bx, [bp + 0xc]
  0x04529: lcall    0xc11, 0xc
  0x0452E: cmp      si, 0x19
  0x04531: jg       0x4560
  0x04533: push     word ptr [bp + 0x12]
  0x04536: push     word ptr [bp + 0x10]
  0x04539: push     word ptr [bp + 0xe]
  0x0453C: push     word ptr [bp + 0xc]
  0x0453F: push     word ptr [0x8326]
  0x04543: mov      bx, word ptr [bp - 0x26]
  0x04546: mov      bl, byte ptr [bx + 0x5d60]  ; colony_tbl
  0x0454A: sub      bh, bh
  0x0454C: mov      al, byte ptr [bx + 0x848]
  0x04550: push     ax
  0x04551: mov      ax, word ptr [bp - 0x2a]
  0x04554: mov      dx, word ptr [bp - 0x28]
  0x04557: mov      bx, word ptr [0x5ad4]
  0x0455B: lcall    0xb9e, 0xa
  0x04560: pop      si
  0x04561: pop      di
  0x04562: leave    

============================================================
func_L065 at file 0x04566, 870 bytes
============================================================
  0x04566: enter    0x24, 0
  0x0456A: push     di
  0x0456B: push     si
  0x0456C: sub      ax, ax
  0x0456E: mov      word ptr [bp - 0x1e], ax
  0x04571: mov      word ptr [bp - 0x20], ax
  0x04574: push     1
  0x04576: push     word ptr [bp + 0xe]
  0x04579: push     word ptr [bp + 0xc]
  0x0457C: push     word ptr [bp + 0xe]
  0x0457F: push     word ptr [bp + 0xc]
  0x04582: lcall    0x984, 0x2fc
  0x04587: add      sp, 0xa
  0x0458A: mov      ax, word ptr [bp + 0x10]
  0x0458D: cmp      ax, word ptr [bp + 0xc]
  0x04590: jle      0x4595
  0x04592: mov      ax, word ptr [bp + 0xc]
  0x04595: mov      word ptr [bp - 4], ax
  0x04598: mov      ax, word ptr [bp + 0x12]
  0x0459B: cmp      ax, word ptr [bp + 0xe]
  0x0459E: jle      0x45a3
  0x045A0: mov      ax, word ptr [bp + 0xe]
  0x045A3: mov      word ptr [bp - 2], ax
  0x045A6: mov      ax, word ptr [0x5ad4]
  0x045A9: mov      word ptr [bp - 0x16], ax
  0x045AC: mov      si, 1
  0x045AF: mov      ax, word ptr [bp + 0xc]
  0x045B2: cmp      word ptr [bp + 0x10], ax
  0x045B5: je       0x45bd
  0x045B7: shl      word ptr [bp - 0x16], 1
  0x045BA: mov      si, 2
  0x045BD: mov      ax, word ptr [0x8326]
  0x045C0: mov      word ptr [bp - 0x18], ax
  0x045C3: mov      di, 1
  0x045C6: mov      ax, word ptr [bp + 0xe]
  0x045C9: cmp      word ptr [bp + 0x12], ax
  0x045CC: je       0x45d4
  0x045CE: shl      word ptr [bp - 0x18], 1
  0x045D1: mov      di, 2
  0x045D4: mov      cl, byte ptr [0x184]
  0x045D8: mov      ax, 0x10
  0x045DB: sar      ax, cl
  0x045DD: mov      word ptr [bp - 0x10], ax
  0x045E0: push     di
  0x045E1: push     si
  0x045E2: push     word ptr [bp - 2]
  0x045E5: push     word ptr [bp - 4]
  0x045E8: lcall    0x181f, 0x32c
  0x045ED: add      sp, 8
  0x045F0: push     di
  0x045F1: push     si
  0x045F2: push     word ptr [bp - 2]
  0x045F5: push     word ptr [bp - 4]
  0x045F8: lcall    0x181f, 0x344
  0x045FD: add      sp, 8
  0x04600: cmp      word ptr [bp + 0xa], 0
  0x04604: jl       0x465f
  0x04606: imul     bx, word ptr [bp + 0xa], 0x1c  ; *Unit
  0x0460A: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x0460E: sub      ah, ah
  0x04610: mov      word ptr [bp - 0x1e], ax
  0x04613: mov      cl, byte ptr [bx + 0x3145]
  0x04617: sub      ch, ch
  0x04619: mov      word ptr [bp - 0x20], cx
  0x0461C: push     1
  0x0461E: push     1
  0x04620: push     cx
  0x04621: push     ax
  0x04622: lcall    0x181f, 0x32c
  0x04627: add      sp, 8
  0x0462A: mov      ax, word ptr [bp - 0x20]
  0x0462D: sub      ax, word ptr [0x832e]
  0x04631: add      ax, word ptr [0x832c]
  0x04635: imul     word ptr [0x8326]
  0x04639: add      ax, 8
  0x0463C: push     ax
  0x0463D: push     word ptr [0x5ad4]
  0x04641: push     word ptr [0x186]
  0x04645: mov      ax, word ptr [bp - 0x1e]
  0x04648: sub      ax, word ptr [0x8328]
  0x0464C: add      ax, word ptr [0x832a]
  0x04650: imul     word ptr [0x5ad4]
  0x04654: mov      bx, ax
  0x04656: mov      ax, word ptr [bp + 0xa]
  0x04659: sub      dx, dx
  0x0465B: push     cs
  0x0465C: call     0x386a
  0x0465F: mov      ax, word ptr [bp - 2]
  0x04662: sub      ax, word ptr [0x832e]
  0x04666: add      ax, word ptr [0x832c]
  0x0466A: imul     word ptr [0x8326]
  0x0466E: add      ax, 8
  0x04671: mov      word ptr [bp - 0x12], ax
  0x04674: push     word ptr [0x2dae]
  0x04678: push     word ptr [0x2dac]
  0x0467C: push     word ptr [0x2daa]
  0x04680: push     word ptr [0x2da8]  ; map_terrain
  0x04684: push     word ptr [0x8336]
  0x04688: push     word ptr [0x8334]
  0x0468C: push     word ptr [0x8332]
  0x04690: push     word ptr [0x8330]
  0x04694: push     0
  0x04696: push     word ptr [bp - 0x16]
  0x04699: push     word ptr [bp - 0x18]
  0x0469C: mov      dx, ax
  0x0469E: mov      ax, word ptr [0x832a]
  0x046A1: sub      ax, word ptr [0x8328]
  0x046A5: add      ax, word ptr [bp - 4]
  0x046A8: mov      cx, dx
  0x046AA: imul     word ptr [0x5ad4]
  0x046AE: mov      word ptr [bp - 0x14], ax
  0x046B1: mov      dx, cx
  0x046B3: sub      bx, bx
  0x046B5: lcall    0xbaa, 6
  0x046BA: mov      ax, word ptr [bp + 0x10]
  0x046BD: sub      ax, word ptr [bp + 0xc]
  0x046C0: or       ax, ax
  0x046C2: jle      0x46ca
  0x046C4: mov      di, 1
  0x046C7: jmp      0x46d9
  0x046C9: nop      
  0x046CA: mov      ax, word ptr [bp + 0x10]
  0x046CD: sub      ax, word ptr [bp + 0xc]
  0x046D0: js       0x46d6
  0x046D2: sub      di, di
  0x046D4: jmp      0x46d9
  0x046D6: mov      di, 0xffff
  0x046D9: mov      ax, word ptr [bp + 0x12]
  0x046DC: sub      ax, word ptr [bp + 0xe]
  0x046DF: or       ax, ax
  0x046E1: jle      0x46e8
  0x046E3: mov      si, 1
  0x046E6: jmp      0x46f7
  0x046E8: mov      ax, word ptr [bp + 0x12]
  0x046EB: sub      ax, word ptr [bp + 0xe]
  0x046EE: js       0x46f4
  0x046F0: sub      si, si
  0x046F2: jmp      0x46f7
  0x046F4: mov      si, 0xffff
  0x046F7: or       di, di
  0x046F9: jl       0x4700
  0x046FB: sub      ax, ax
  0x046FD: jmp      0x4703
  0x046FF: nop      
  0x04700: mov      ax, word ptr [0x5ad4]
  0x04703: add      ax, word ptr [bp - 0x14]
  0x04706: mov      word ptr [bp - 0x1a], ax
  0x04709: or       si, si
  0x0470B: jl       0x4712
  0x0470D: sub      ax, ax
  0x0470F: jmp      0x4715
  0x04711: nop      
  0x04712: mov      ax, word ptr [0x8326]
  0x04715: add      ax, word ptr [bp - 0x12]
  0x04718: mov      word ptr [bp - 0x1c], ax
  0x0471B: sub      ax, ax
  0x0471D: mov      word ptr [0x833a], ax
  0x04720: mov      word ptr [0x8338], ax
  0x04723: lcall    0xc0c, 0x22
  0x04728: mov      word ptr [bp - 8], ax
  0x0472B: mov      word ptr [bp - 6], dx
  0x0472E: mov      word ptr [bp - 4], ax
  0x04731: mov      word ptr [bp - 2], dx
  0x04734: mov      ah, byte ptr [0x5383]
  0x04738: and      ax, 0x1000
  0x0473B: cmp      ax, 1
  0x0473E: sbb      ax, ax
  0x04740: and      ax, 2
  0x04743: add      ax, 8
  0x04746: mov      cl, byte ptr [0x184]
  0x0474A: shl      ax, cl
  0x0474C: cdq      
  0x0474D: mov      word ptr [bp - 0xc], ax
  0x04750: mov      word ptr [bp - 0xa], dx
  0x04753: mov      word ptr [bp - 0xe], 0
  0x04758: cmp      word ptr [bp - 0x10], 0
  0x0475C: jg       0x4761
  0x0475E: jmp      0x4815
  0x04761: mov      word ptr [bp - 0x22], di
  0x04764: mov      word ptr [bp - 0x24], si
  0x04767: push     word ptr [0x8336]
  0x0476B: push     word ptr [0x8334]
  0x0476F: push     word ptr [0x8332]
  0x04773: push     word ptr [0x8330]
  0x04777: push     word ptr [0x2dae]
  0x0477B: push     word ptr [0x2dac]
  0x0477F: push     word ptr [0x2daa]
  0x04783: push     word ptr [0x2da8]  ; map_terrain
  0x04787: push     word ptr [bp - 0x12]
  0x0478A: push     word ptr [bp - 0x16]
  0x0478D: push     word ptr [bp - 0x18]
  0x04790: sub      ax, ax
  0x04792: cdq      
  0x04793: mov      bx, word ptr [bp - 0x14]
  0x04796: lcall    0xbaa, 6
  0x0479B: push     word ptr [bp - 0x1c]
  0x0479E: push     word ptr [0x5ad4]
  0x047A2: push     word ptr [0x186]
  0x047A6: mov      ax, word ptr [bp + 6]
  0x047A9: mov      dx, word ptr [bp + 8]
  0x047AC: mov      bx, word ptr [bp - 0x1a]
  0x047AF: push     cs
  0x047B0: call     0x386a
  0x047B3: push     word ptr [bp - 0x12]
  0x047B6: push     word ptr [bp - 0x16]
  0x047B9: push     word ptr [bp - 0x18]
  0x047BC: mov      ax, word ptr [bp - 0x14]
  0x047BF: mov      dx, word ptr [bp - 0x12]
  0x047C2: mov      bx, ax
  0x047C4: lcall    0xb70, 0x3a
  0x047C9: mov      ax, word ptr [bp - 0x22]
  0x047CC: add      word ptr [bp - 0x1a], ax
  0x047CF: mov      ax, word ptr [bp - 0x24]
  0x047D2: add      word ptr [bp - 0x1c], ax
  0x047D5: mov      ax, word ptr [bp - 0x10]
  0x047D8: dec      ax
  0x047D9: cmp      ax, word ptr [bp - 0xe]
  0x047DC: jle      0x47fb
  0x047DE: lcall    0xc0c, 0x22
  0x047E3: mov      word ptr [bp - 8], ax
  0x047E6: mov      word ptr [bp - 6], dx
  0x047E9: sub      ax, word ptr [bp - 4]
  0x047EC: sbb      dx, word ptr [bp - 2]
  0x047EF: cmp      dx, word ptr [bp - 0xa]
  0x047F2: jl       0x47de
  0x047F4: jg       0x47fb
  0x047F6: cmp      ax, word ptr [bp - 0xc]
  0x047F9: jb       0x47de
  0x047FB: mov      ax, word ptr [bp - 8]
  0x047FE: mov      dx, word ptr [bp - 6]
  0x04801: mov      word ptr [bp - 4], ax
  0x04804: mov      word ptr [bp - 2], dx
  0x04807: mov      ax, word ptr [bp - 0x10]
  0x0480A: inc      word ptr [bp - 0xe]
  0x0480D: cmp      word ptr [bp - 0xe], ax
  0x04810: jge      0x4815
  0x04812: jmp      0x4767
  0x04815: cmp      word ptr [bp + 0xa], 0
  0x04819: jge      0x481e
  0x0481B: jmp      0x48c8
  0x0481E: push     1
  0x04820: push     1
  0x04822: push     word ptr [bp - 0x20]
  0x04825: push     word ptr [bp - 0x1e]
  0x04828: lcall    0x181f, 0x32c
  0x0482D: add      sp, 8
  0x04830: test     byte ptr [bp + 8], 0x10
  0x04834: je       0x486b
  0x04836: mov      ax, word ptr [bp - 0x20]
  0x04839: sub      ax, word ptr [0x832e]
  0x0483D: add      ax, word ptr [0x832c]
  0x04841: imul     word ptr [0x8326]
  0x04845: add      ax, 8
  0x04848: push     ax
  0x04849: push     word ptr [0x5ad4]
  0x0484D: push     word ptr [0x186]
  0x04851: mov      ax, word ptr [bp - 0x1e]
  0x04854: sub      ax, word ptr [0x8328]
  0x04858: add      ax, word ptr [0x832a]
  0x0485C: imul     word ptr [0x5ad4]
  0x04860: mov      bx, ax
  0x04862: mov      ax, word ptr [bp + 0xa]
  0x04865: sub      dx, dx
  0x04867: push     cs
  0x04868: call     0x386a
  0x0486B: push     1
  0x0486D: push     1
  0x0486F: push     word ptr [bp + 0xe]
  0x04872: push     word ptr [bp + 0xc]
  0x04875: lcall    0x181f, 0x32c
  0x0487A: add      sp, 8
  0x0487D: mov      ax, word ptr [bp + 0xe]
  0x04880: sub      ax, word ptr [0x832e]
  0x04884: add      ax, word ptr [0x832c]
  0x04888: imul     word ptr [0x8326]
  0x0488C: add      ax, 8
  0x0488F: push     ax
  0x04890: push     word ptr [0x5ad4]
  0x04894: push     word ptr [0x186]
  0x04898: mov      ax, word ptr [0x832a]
  0x0489B: sub      ax, word ptr [0x8328]
  0x0489F: add      ax, word ptr [bp + 0xc]
  0x048A2: imul     word ptr [0x5ad4]
  0x048A6: mov      bx, ax
  0x048A8: mov      ax, word ptr [bp + 6]
  0x048AB: mov      dx, word ptr [bp + 8]
  0x048AE: push     cs
  0x048AF: call     0x386a
  0x048B2: push     word ptr [bp - 0x12]
  0x048B5: push     word ptr [bp - 0x16]
  0x048B8: push     word ptr [bp - 0x18]
  0x048BB: mov      ax, word ptr [bp - 0x14]
  0x048BE: mov      dx, word ptr [bp - 0x12]
  0x048C1: mov      bx, ax
  0x048C3: lcall    0xb70, 0x3a
  0x048C8: pop      si
  0x048C9: pop      di
  0x048CA: leave    
  0x048CB: retf     

============================================================
func_L066 at file 0x048CC, 29 bytes
============================================================
  0x048CC: push     bp
  0x048CD: mov      bp, sp
  0x048CF: mov      dx, word ptr [bp + 6]
  0x048D2: mov      ax, word ptr [bp + 8]
  0x048D5: cmp      ax, dx
  0x048D7: jge      0x48db
  0x048D9: mov      ax, dx
  0x048DB: mov      dx, ax
  0x048DD: cmp      ax, word ptr [bp + 0xa]
  0x048E0: jle      0x48e5
  0x048E2: mov      ax, word ptr [bp + 0xa]
  0x048E5: mov      dx, ax
  0x048E7: leave    
  0x048E8: retf     

============================================================
func_L067 at file 0x048EA, 21 bytes
============================================================
  0x048EA: push     bp
  0x048EB: mov      bp, sp
  0x048ED: push     di
  0x048EE: mov      di, word ptr [bp + 6]
  0x048F1: mov      bx, word ptr [bp + 8]
  0x048F4: mov      dx, word ptr [di]
  0x048F6: mov      ax, word ptr [bx]
  0x048F8: mov      word ptr [di], ax
  0x048FA: mov      word ptr [bx], dx
  0x048FC: pop      di
  0x048FD: leave    
  0x048FE: retf     

============================================================
func_L068 at file 0x04900, 27 bytes
============================================================
  0x04900: push     bp
  0x04901: mov      bp, sp
  0x04903: push     di
  0x04904: mov      dx, word ptr [bp + 6]
  0x04907: or       dx, dx
  0x04909: jg       0x4912
  0x0490B: mov      ax, dx
  0x0490D: not      ax
  0x0490F: inc      ax
  0x04910: mov      dx, ax
  0x04912: mov      bx, word ptr [bp + 8]
  0x04915: or       bx, bx
  0x04917: jg       0x4920
  0x04919: mov      ax, bx

============================================================
func_L069 at file 0x0493C, 14 bytes
============================================================
  0x0493C: enter    4, 0
  0x04940: push     di
  0x04941: push     si
  0x04942: mov      bx, word ptr [bp + 6]
  0x04945: mov      dx, word ptr [bp + 0xa]
  0x04948: mov      ax, bx

============================================================
func_L070 at file 0x04984, 12 bytes
============================================================
  0x04984: push     bp
  0x04985: mov      bp, sp
  0x04987: mov      bx, word ptr [bp + 6]
  0x0498A: or       bx, bx
  0x0498C: jg       0x4995
  0x0498E: mov      ax, bx

============================================================
func_L071 at file 0x049B4, 14 bytes
============================================================
  0x049B4: enter    4, 0
  0x049B8: push     di
  0x049B9: push     si
  0x049BA: mov      bx, word ptr [bp + 6]
  0x049BD: mov      dx, word ptr [bp + 0xa]
  0x049C0: mov      ax, bx

============================================================
func_L072 at file 0x049FC, 20 bytes
============================================================
  0x049FC: push     bp
  0x049FD: mov      bp, sp
  0x049FF: mov      cx, word ptr [bp + 8]
  0x04A02: mov      bx, word ptr [bp + 6]
  0x04A05: sub      dx, dx
  0x04A07: mov      al, cl
  0x04A09: inc      al
  0x04A0B: and      ax, 7  ; 12.5% chance
  0x04A0E: cmp      ax, bx

============================================================
func_L073 at file 0x04A5C, 36 bytes
============================================================
  0x04A5C: push     bp
  0x04A5D: mov      bp, sp
  0x04A5F: push     si
  0x04A60: sub      si, si
  0x04A62: lcall    0x29f, 0xf6
  0x04A67: lcall    0xae7, 2
  0x04A6C: or       ax, ax
  0x04A6E: je       0x4a77
  0x04A70: lcall    0xae7, 0x16
  0x04A75: mov      si, ax
  0x04A77: or       si, si
  0x04A79: je       0x4a62
  0x04A7B: mov      ax, si
  0x04A7D: pop      si
  0x04A7E: leave    
  0x04A7F: retf     

============================================================
func_L074 at file 0x04A80, 26 bytes
============================================================
  0x04A80: enter    4, 0
  0x04A84: push     di
  0x04A85: push     si
  0x04A86: mov      si, 1
  0x04A89: sub      di, di
  0x04A8B: lcall    0xc0c, 6
  0x04A90: mov      word ptr [bp - 4], ax
  0x04A93: mov      word ptr [bp - 2], dx

============================================================
func_L075 at file 0x04AFA, 28 bytes
============================================================
  0x04AFA: push     bp
  0x04AFB: mov      bp, sp
  0x04AFD: lcall    0xae7, 2
  0x04B02: or       ax, ax
  0x04B04: je       0x4b14
  0x04B06: lcall    0xae7, 0x16
  0x04B0B: lcall    0xae7, 2
  0x04B10: or       ax, ax
  0x04B12: jne      0x4b06
  0x04B14: leave    
  0x04B15: retf     

============================================================
func_L076 at file 0x04B16, 46 bytes
============================================================
  0x04B16: push     bp
  0x04B17: mov      bp, sp
  0x04B19: mov      bx, word ptr [bp + 6]
  0x04B1C: mov      dx, word ptr [0x7e8]
  0x04B20: cmp      bx, dx
  0x04B22: jg       0x4b44
  0x04B24: add      bx, word ptr [bp + 0xa]
  0x04B27: dec      bx
  0x04B28: cmp      bx, dx
  0x04B2A: jl       0x4b44
  0x04B2C: mov      dx, word ptr [0x7ea]
  0x04B30: mov      bx, word ptr [bp + 8]
  0x04B33: cmp      bx, dx
  0x04B35: jg       0x4b44
  0x04B37: add      bx, word ptr [bp + 0xc]
  0x04B3A: dec      bx
  0x04B3B: cmp      bx, dx
  0x04B3D: jl       0x4b44
  0x04B3F: mov      ax, 1
  0x04B42: leave    
  0x04B43: retf     

============================================================
func_L077 at file 0x04B48, 25 bytes
============================================================
  0x04B48: push     bp
  0x04B49: mov      bp, sp
  0x04B4B: mov      dx, word ptr [bp + 6]
  0x04B4E: or       dx, dx
  0x04B50: jge      0x4b56
  0x04B52: mov      dx, word ptr [bp + 8]
  0x04B55: dec      dx
  0x04B56: cmp      word ptr [bp + 8], dx
  0x04B59: jg       0x4b5d
  0x04B5B: sub      dx, dx
  0x04B5D: mov      ax, dx
  0x04B5F: leave    
  0x04B60: retf     

============================================================
func_L078 at file 0x04B72, 427 bytes
============================================================
  0x04B72: enter    0x350, 0
  0x04B76: push     di
  0x04B77: push     si
  0x04B78: push     0x72
  0x04B7B: lea      ax, [bp - 0x50]
  0x04B7E: push     ax
  0x04B7F: lcall    0xd1d, 0x7e4
  0x04B84: add      sp, 4
  0x04B87: cmp      word ptr [bp + 6], 0xa
  0x04B8B: jge      0x4b9c
  0x04B8D: push     0x79
  0x04B90: lea      ax, [bp - 0x50]
  0x04B93: push     ax
  0x04B94: lcall    0xd1d, 0x7a4
  0x04B99: add      sp, 4
  0x04B9C: push     word ptr [bp + 6]
  0x04B9F: lea      ax, [bp - 0x50]
  0x04BA2: push     ss
  0x04BA3: push     ax
  0x04BA4: lcall    0x4b, 0x12e
  0x04BA9: add      sp, 6
  0x04BAC: cmp      word ptr [bp + 6], 1
  0x04BB0: jne      0x4bb6
  0x04BB2: push     cs
  0x04BB3: call     0x4a32
  0x04BB6: lea      ax, [bp - 0x350]
  0x04BBA: push     ss
  0x04BBB: push     ax
  0x04BBC: push     0
  0x04BBE: push     word ptr [0x2dae]
  0x04BC2: push     word ptr [0x2dac]
  0x04BC6: push     word ptr [0x2daa]
  0x04BCA: push     word ptr [0x2da8]  ; map_terrain
  0x04BCE: lea      ax, [bp - 0x50]
  0x04BD1: push     ax
  0x04BD2: lcall    0x181f, 0x44e
  0x04BD7: add      sp, 0x10
  0x04BDA: or       ax, ax
  0x04BDC: je       0x4be1
  0x04BDE: jmp      0x4d0d
  0x04BE1: push     word ptr [0x2dae]
  0x04BE5: push     word ptr [0x2dac]
  0x04BE9: push     word ptr [0x2daa]
  0x04BED: push     word ptr [0x2da8]  ; map_terrain
  0x04BF1: push     word ptr [0x83a4]
  0x04BF5: push     word ptr [0x83a2]
  0x04BF9: push     word ptr [0x83a0]
  0x04BFD: push     word ptr [0x839e]
  0x04C01: push     0xc8
  0x04C04: cdq      
  0x04C05: mov      bx, 0x140
  0x04C08: lcall    0xb8f, 6
  0x04C0D: mov      ax, word ptr [bp + 6]
  0x04C10: dec      ax
  0x04C11: dec      ax
  0x04C12: je       0x4c1c
  0x04C14: dec      ax
  0x04C15: je       0x4c3e
  0x04C17: dec      ax
  0x04C18: je       0x4c54
  0x04C1A: jmp      0x4c99
  0x04C1C: mov      bl, byte ptr [0x53a6]
  0x04C20: sub      bh, bh
  0x04C22: shl      bx, 1
  0x04C24: push     word ptr [bx - 0x7c6c]
  0x04C28: push     0
  0x04C2A: lcall    0x181f, 0x438
  0x04C2F: add      sp, 4
  0x04C32: imul     ax, word ptr [0x5398], 0x34  ; *AI
  0x04C37: add      ax, 0x540e
  0x04C3A: push     ds
  0x04C3B: push     ax
  0x04C3C: jmp      0x4c8f
  0x04C3E: mov      bx, word ptr [0x5398]
  0x04C42: shl      bx, 1
  0x04C44: push     word ptr [bx - 0x7c74]
  0x04C48: push     0
  0x04C4A: lcall    0x181f, 0x438
  0x04C4F: add      sp, 4
  0x04C52: jmp      0x4c99
  0x04C54: mov      byte ptr [bp - 0x50], 0
  0x04C58: lea      ax, [bp - 0x50]
  0x04C5B: push     ax
  0x04C5C: push     0
  0x04C5E: push     word ptr [0x5398]
  0x04C62: lcall    0x5b3, 0x144
  0x04C67: add      sp, 6
  0x04C6A: lea      ax, [bp - 0x50]
  0x04C6D: push     ss
  0x04C6E: push     ax
  0x04C6F: push     0
  0x04C71: lcall    0x181f, 0x416
  0x04C76: add      sp, 6
  0x04C79: push     word ptr [0x5398]
  0x04C7D: push     0x7b
  0x04C80: push     0x87c
  0x04C83: lcall    0x181f, 0x422
  0x04C88: add      sp, 6
  0x04C8B: push     ds
  0x04C8C: push     0x833c
  0x04C8F: push     1
  0x04C91: lcall    0x181f, 0x416
  0x04C96: add      sp, 6
  0x04C99: lcall    0x181f, 0x40a
  0x04C9E: or       byte ptr [0x1f56], 0x20
  0x04CA3: mov      word ptr [0x1f6a], 1
  0x04CA9: mov      word ptr [0x1f64], 0
  0x04CAF: push     0x84
  0x04CB2: lea      ax, [bp - 0x50]
  0x04CB5: push     ax
  0x04CB6: lcall    0xd1d, 0x7e4
  0x04CBB: add      sp, 4
  0x04CBE: push     word ptr [bp + 6]
  0x04CC1: lea      ax, [bp - 0x50]
  0x04CC4: push     ss
  0x04CC5: push     ax
  0x04CC6: lcall    0x4b, 0x12e
  0x04CCB: add      sp, 6
  0x04CCE: mov      si, word ptr [0x1f4a]
  0x04CD2: mov      di, word ptr [0x1f50]
  0x04CD6: mov      word ptr [0x1f4a], 0xe
  0x04CDC: mov      word ptr [0x1f50], 0x36
  0x04CE2: lea      bx, [bp - 0x50]
  0x04CE5: lcall    0x181f, 0x3fe
  0x04CEA: mov      word ptr [0x1f4a], si
  0x04CEE: mov      word ptr [0x1f50], di
  0x04CF2: cmp      word ptr [bp + 6], 1
  0x04CF6: jne      0x4d03
  0x04CF8: lea      ax, [bp - 0x350]
  0x04CFC: push     ss
  0x04CFD: push     ax
  0x04CFE: lcall    0xade, 4
  0x04D03: push     8
  0x04D05: lcall    0x2d6, 0
  0x04D0A: add      sp, 2
  0x04D0D: mov      word ptr [0x1f6a], 0
  0x04D13: mov      word ptr [0x1f64], 1
  0x04D19: pop      si
  0x04D1A: pop      di
  0x04D1B: leave    
  0x04D1C: retf     

============================================================
func_L079 at file 0x04D1E, 217 bytes
============================================================
  0x04D1E: enter    8, 0
  0x04D22: push     si
  0x04D23: lcall    0xc0c, 6
  0x04D28: mov      word ptr [bp - 4], ax
  0x04D2B: mov      word ptr [bp - 2], dx
  0x04D2E: cmp      word ptr [0x92], 0
  0x04D33: jl       0x4d48
  0x04D35: sub      ax, word ptr [0x90]
  0x04D39: sbb      dx, word ptr [0x92]
  0x04D3D: or       dx, dx
  0x04D3F: jl       0x4d80
  0x04D41: jg       0x4d48
  0x04D43: cmp      ax, 0x23a
  0x04D46: jb       0x4d80
  0x04D48: cmp      word ptr [0x8c], 0xa
  0x04D4D: jl       0x4d64
  0x04D4F: mov      word ptr [0x8a], 1
  0x04D55: mov      ax, word ptr [bp - 4]
  0x04D58: mov      dx, word ptr [bp - 2]
  0x04D5B: mov      word ptr [0x90], ax
  0x04D5E: mov      word ptr [0x92], dx
  0x04D62: jmp      0x4d80
  0x04D64: mov      ax, word ptr [bp - 4]
  0x04D67: mov      dx, word ptr [bp - 2]
  0x04D6A: mov      word ptr [0x90], ax
  0x04D6D: mov      word ptr [0x92], dx
  0x04D71: inc      word ptr [0x8c]
  0x04D75: push     word ptr [0x8c]
  0x04D79: push     cs
  0x04D7A: call     0x4b72
  0x04D7D: add      sp, 2
  0x04D80: lcall    0xae7, 2
  0x04D85: or       ax, ax
  0x04D87: je       0x4dc1
  0x04D89: lcall    0xae7, 0x16
  0x04D8E: mov      si, ax
  0x04D90: push     cs
  0x04D91: call     0x4afa
  0x04D94: mov      word ptr [0x8a], 1
  0x04D9A: cmp      si, 0x12d
  0x04D9E: je       0x4da6
  0x04DA0: cmp      si, 0x110
  0x04DA4: jne      0x4dab
  0x04DA6: mov      byte ptr [0x828], 1
  0x04DAB: cmp      byte ptr [0x828], 0
  0x04DB0: je       0x4dc1
  0x04DB2: lcall    0x181f, 0x3d4
  0x04DB7: push     3
  0x04DB9: lcall    0xd1d, 0x30d
  0x04DBE: add      sp, 2
  0x04DC1: lea      ax, [bp - 6]
  0x04DC4: push     ax
  0x04DC5: lea      ax, [bp - 8]
  0x04DC8: push     ax
  0x04DC9: lcall    0xa58, 0x38b
  0x04DCE: add      sp, 4
  0x04DD1: or       ax, ax
  0x04DD3: je       0x4df1
  0x04DD5: mov      word ptr [0x8a], 1
  0x04DDB: cmp      byte ptr [0x828], 0
  0x04DE0: je       0x4df1
  0x04DE2: lcall    0x181f, 0x3d4
  0x04DE7: push     3
  0x04DE9: lcall    0xd1d, 0x30d
  0x04DEE: add      sp, 2
  0x04DF1: mov      ax, word ptr [0x8a]
  0x04DF4: pop      si
  0x04DF5: leave    
  0x04DF6: retf     

============================================================
func_L080 at file 0x04DF8, 126 bytes
============================================================
  0x04DF8: enter    2, 0
  0x04DFC: mov      word ptr [bp - 2], 0x25
  0x04E01: mov      ax, word ptr [bp + 6]
  0x04E04: jmp      0x4e9e
  0x04E07: nop      
  0x04E08: mov      word ptr [bp - 2], 0x20
  0x04E0D: jmp      0x4ee0
  0x04E10: mov      word ptr [bp - 2], 0x21
  0x04E15: jmp      0x4ee0
  0x04E18: mov      word ptr [bp - 2], 0x22
  0x04E1D: jmp      0x4ee0
  0x04E20: mov      word ptr [bp - 2], 0x23
  0x04E25: jmp      0x4ee0
  0x04E28: mov      word ptr [bp - 2], 0x3a
  0x04E2D: jmp      0x4ee0
  0x04E30: mov      word ptr [bp - 2], 0x3b
  0x04E35: jmp      0x4ee0
  0x04E38: mov      word ptr [bp - 2], 0x38
  0x04E3D: jmp      0x4ee0
  0x04E40: mov      word ptr [bp - 2], 0x24
  0x04E45: jmp      0x4ee0
  0x04E48: mov      word ptr [bp - 2], 0x25
  0x04E4D: jmp      0x4ee0
  0x04E50: mov      word ptr [bp - 2], 0x26
  0x04E55: jmp      0x4ee0
  0x04E58: mov      word ptr [bp - 2], 0x27
  0x04E5D: jmp      0x4ee0
  0x04E60: mov      word ptr [bp - 2], 0x39
  0x04E65: jmp      0x4ee0
  0x04E67: nop      
  0x04E68: mov      ax, word ptr [bp + 6]
  0x04E6B: add      ax, 0x1b
  0x04E6E: mov      word ptr [bp - 2], ax
  0x04E71: mov      ax, word ptr [bp - 2]
  0x04E74: leave    
  0x04E75: retf     

============================================================
func_L081 at file 0x04EE6, 470 bytes
============================================================
  0x04EE6: enter    8, 0
  0x04EEA: cmp      word ptr [0xa2], 0
  0x04EEF: jne      0x4efb
  0x04EF1: cmp      word ptr [0x9e], 0
  0x04EF6: jne      0x4efb
  0x04EF8: jmp      0x50ba
  0x04EFB: push     8
  0x04EFD: lcall    0x1059, 0xa
  0x04F02: add      sp, 2
  0x04F05: or       ax, ax
  0x04F07: je       0x4f0c
  0x04F09: jmp      0x50ba
  0x04F0C: mov      word ptr [0x9e], ax
  0x04F0F: cmp      word ptr [0x94], ax
  0x04F13: jl       0x4f24
  0x04F15: mov      ax, word ptr [0x94]
  0x04F18: mov      word ptr [bp - 8], ax
  0x04F1B: mov      word ptr [0x94], 0xffff
  0x04F21: jmp      0x50af
  0x04F24: push     word ptr [0x83a8]
  0x04F28: lcall    0x9ef, 0x2c
  0x04F2D: add      sp, 2
  0x04F30: test     byte ptr [0x5382], 1
  0x04F35: jne      0x4f5e
  0x04F37: mov      word ptr [bp - 2], 1
  0x04F3C: mov      word ptr [bp - 4], 0xc
  0x04F41: push     8
  0x04F43: push     0
  0x04F45: lcall    0x9ef, 0x32
  0x04F4A: add      sp, 4
  0x04F4D: or       ax, ax
  0x04F4F: jne      0x4f82
  0x04F51: mov      word ptr [bp - 2], 0xd
  0x04F56: mov      word ptr [bp - 4], 0xb
  0x04F5B: jmp      0x4f82
  0x04F5D: nop      
  0x04F5E: mov      word ptr [bp - 2], 0xd
  0x04F63: mov      word ptr [bp - 4], 6
  0x04F68: push     4
  0x04F6A: push     0
  0x04F6C: lcall    0x9ef, 0x32
  0x04F71: add      sp, 4
  0x04F74: or       ax, ax
  0x04F76: jne      0x4f82
  0x04F78: mov      word ptr [bp - 2], 1
  0x04F7D: mov      word ptr [bp - 4], 0xc
  0x04F82: cmp      byte ptr [0x828], 0
  0x04F87: je       0x4f93
  0x04F89: mov      word ptr [bp - 2], 1
  0x04F8E: mov      word ptr [bp - 4], 0x18
  0x04F93: mov      ax, word ptr [0x9a]
  0x04F96: jmp      0x4ffa
  0x04F98: mov      word ptr [bp - 2], 1
  0x04F9D: mov      word ptr [bp - 4], 7
  0x04FA2: jmp      0x5016
  0x04FA4: nop      
  0x04FA5: nop      
  0x04FA6: mov      word ptr [bp - 2], 8
  0x04FAB: mov      word ptr [bp - 4], 5
  0x04FB0: jmp      0x5016
  0x04FB2: mov      word ptr [bp - 2], 0xd
  0x04FB7: mov      word ptr [bp - 4], 6
  0x04FBC: jmp      0x5016
  0x04FBE: mov      word ptr [bp - 2], 0x13
  0x04FC3: mov      word ptr [bp - 4], 4
  0x04FC8: jmp      0x5016
  0x04FCA: cmp      word ptr [0x96], 0x33
  0x04FCF: je       0x5016
  0x04FD1: mov      word ptr [bp - 2], 0x17
  0x04FD6: mov      word ptr [bp - 4], 1
  0x04FDB: jmp      0x5016
  0x04FDD: nop      
  0x04FDE: cmp      word ptr [0x96], 0x35
  0x04FE3: je       0x5016
  0x04FE5: mov      word ptr [bp - 2], 0x19
  0x04FEA: jmp      0x4fd6
  0x04FEC: cmp      word ptr [0x96], 0x36
  0x04FF1: je       0x5016
  0x04FF3: mov      word ptr [bp - 2], 0x1a
  0x04FF8: jmp      0x4fd6
  0x04FFA: dec      ax
  0x04FFB: cmp      ax, 6
  0x04FFE: ja       0x5016
  0x05000: shl      ax, 1
  0x05002: xchg     bx, ax
  0x05003: jmp      word ptr cs:[bx + 0x218]
  0x05008: test     al, 1
  0x0500A: mov      dh, 1
  0x0500C: ret      0xce01
  0x0500F: add      dx, bx
  0x05011: add      si, bp
  0x05013: add      sp, di
  0x05015: add      word ptr [bp + di - 0x3ba], cx
  0x05019: dec      ax
  0x0501A: push     ax
  0x0501B: push     0
  0x0501D: lcall    0x9ef, 0x32
  0x05022: add      sp, 4
  0x05025: add      ax, word ptr [bp - 2]
  0x05028: mov      word ptr [bp - 6], ax
  0x0502B: push     ax
  0x0502C: push     cs
  0x0502D: call     0x4df8
  0x05030: add      sp, 2
  0x05033: mov      word ptr [bp - 8], ax
  0x05036: cmp      word ptr [0x96], ax
  0x0503A: je       0x5016
  0x0503C: push     word ptr [0x83a6]
  0x05040: lcall    0x9ef, 0x2c
  0x05045: add      sp, 2
  0x05048: cmp      word ptr [0x9a], 0
  0x0504D: jne      0x509d
  0x0504F: mov      word ptr [0x9a], 7
  0x05055: cmp      word ptr [bp - 6], 0x19
  0x05059: jg       0x5061
  0x0505B: mov      word ptr [0x9a], 6
  0x05061: cmp      word ptr [bp - 6], 0x18
  0x05065: jg       0x506d
  0x05067: mov      word ptr [0x9a], 5
  0x0506D: cmp      word ptr [bp - 6], 0x16
  0x05071: jg       0x5079
  0x05073: mov      word ptr [0x9a], 4
  0x05079: cmp      word ptr [bp - 6], 0x12
  0x0507D: jg       0x5085
  0x0507F: mov      word ptr [0x9a], 3
  0x05085: cmp      word ptr [bp - 6], 0xc
  0x05089: jg       0x5091
  0x0508B: mov      word ptr [0x9a], 2
  0x05091: cmp      word ptr [bp - 6], 6
  0x05095: jg       0x509d
  0x05097: mov      word ptr [0x9a], 1
  0x0509D: mov      ax, word ptr [0x9a]
  0x050A0: mov      word ptr [0x9c], ax
  0x050A3: mov      ax, word ptr [0x98]
  0x050A6: mov      word ptr [0x9a], ax
  0x050A9: mov      word ptr [0x98], 0
  0x050AF: mov      ax, word ptr [bp - 8]
  0x050B2: mov      word ptr [0x96], ax
  0x050B5: lcall    0x2d8, 0xe
  0x050BA: leave    
  0x050BB: retf     

============================================================
func_L082 at file 0x050BC, 51 bytes
============================================================
  0x050BC: push     bp
  0x050BD: mov      bp, sp
  0x050BF: mov      ax, word ptr [0x96]
  0x050C2: cmp      word ptr [bp + 6], ax
  0x050C5: je       0x50ed
  0x050C7: mov      ax, word ptr [bp + 6]
  0x050CA: mov      word ptr [0x94], ax
  0x050CD: cmp      word ptr [0xa0], 0
  0x050D2: je       0x50e1
  0x050D4: cmp      word ptr [0xa2], 0
  0x050D9: jne      0x50e1
  0x050DB: mov      word ptr [0x9e], 1
  0x050E1: or       ax, ax
  0x050E3: jl       0x50ed
  0x050E5: mov      ax, 1
  0x050E8: lcall    0x2d8, 0xe
  0x050ED: leave    
  0x050EE: retf     

============================================================
func_L083 at file 0x050F0, 11 bytes
============================================================
  0x050F0: push     bp
  0x050F1: mov      bp, sp
  0x050F3: mov      ax, word ptr [bp + 6]
  0x050F6: mov      word ptr [0x9a], ax
  0x050F9: leave    
  0x050FA: retf     

============================================================
func_L084 at file 0x050FC, 11 bytes
============================================================
  0x050FC: push     bp
  0x050FD: mov      bp, sp
  0x050FF: mov      ax, word ptr [bp + 6]
  0x05102: mov      word ptr [0x98], ax
  0x05105: leave    
  0x05106: retf     

============================================================
func_L085 at file 0x05108, 51 bytes
============================================================
  0x05108: push     bp
  0x05109: mov      bp, sp
  0x0510B: push     word ptr [bp + 6]
  0x0510E: push     cs
  0x0510F: call     0x50f0
  0x05112: mov      sp, bp
  0x05114: mov      ax, word ptr [bp + 6]
  0x05117: cmp      word ptr [0x9c], ax
  0x0511B: je       0x5139
  0x0511D: cmp      word ptr [0xa0], 0
  0x05122: je       0x5131
  0x05124: cmp      word ptr [0xa2], 0
  0x05129: jne      0x5131
  0x0512B: mov      word ptr [0x9e], 1
  0x05131: mov      ax, 1
  0x05134: lcall    0x2d8, 0xe
  0x05139: leave    
  0x0513A: retf     

============================================================
func_L086 at file 0x0513C, 26 bytes
============================================================
  0x0513C: push     bp
  0x0513D: mov      bp, sp
  0x0513F: cmp      word ptr [0xa0], 0
  0x05144: je       0x5156
  0x05146: cmp      word ptr [0xa2], 0
  0x0514B: jne      0x5156
  0x0514D: push     word ptr [bp + 6]
  0x05150: push     cs
  0x05151: call     0x5108
  0x05154: leave    
  0x05155: retf     

============================================================
func_L087 at file 0x05160, 45 bytes
============================================================
  0x05160: push     bp
  0x05161: mov      bp, sp
  0x05163: lcall    0xa58, 0x54
  0x05168: push     word ptr [bp + 6]
  0x0516B: push     0xa000
  0x0516E: push     0
  0x05170: push     word ptr [0x2dae]
  0x05174: push     word ptr [0x2dac]
  0x05178: lcall    0xd1d, 0x132
  0x0517D: mov      sp, bp
  0x0517F: cmp      word ptr [0x83ac], 0
  0x05184: je       0x518b
  0x05186: lcall    0xa58, 0xd
  0x0518B: leave    
  0x0518C: retf     

============================================================
func_L088 at file 0x051D2, 62 bytes
============================================================
  0x051D2: push     bp
  0x051D3: mov      bp, sp
  0x051D5: cmp      word ptr [0x82e], 0
  0x051DA: je       0x5210
  0x051DC: push     0
  0x051DE: push     0
  0x051E0: push     word ptr [bp + 0x14]
  0x051E3: push     word ptr [bp + 0x12]
  0x051E6: push     word ptr [bp + 0x10]
  0x051E9: push     word ptr [bp + 0xe]
  0x051EC: mov      bx, word ptr [0x82e]
  0x051F0: push     word ptr [bx + 6]
  0x051F3: push     word ptr [bx + 4]
  0x051F6: push     word ptr [bx + 2]
  0x051F9: push     word ptr [bx]
  0x051FB: push     word ptr [bp + 0xc]
  0x051FE: push     word ptr [bp + 0xa]
  0x05201: push     word ptr [bp + 8]
  0x05204: push     word ptr [bp + 6]
  0x05207: lcall    0xbf5, 0
  0x0520C: mov      sp, bp
  0x0520E: leave    
  0x0520F: retf     

============================================================
func_L089 at file 0x05234, 62 bytes
============================================================
  0x05234: push     bp
  0x05235: mov      bp, sp
  0x05237: cmp      word ptr [0x82c], 0
  0x0523C: je       0x5272
  0x0523E: push     0
  0x05240: push     0
  0x05242: push     word ptr [bp + 0x14]
  0x05245: push     word ptr [bp + 0x12]
  0x05248: push     word ptr [bp + 0x10]
  0x0524B: push     word ptr [bp + 0xe]
  0x0524E: mov      bx, word ptr [0x82c]
  0x05252: push     word ptr [bx + 6]
  0x05255: push     word ptr [bx + 4]
  0x05258: push     word ptr [bx + 2]
  0x0525B: push     word ptr [bx]
  0x0525D: push     word ptr [bp + 0xc]
  0x05260: push     word ptr [bp + 0xa]
  0x05263: push     word ptr [bp + 8]
  0x05266: push     word ptr [bp + 6]
  0x05269: lcall    0xbf5, 0
  0x0526E: mov      sp, bp
  0x05270: leave    
  0x05271: retf     

============================================================
func_L090 at file 0x05296, 134 bytes
============================================================
  0x05296: enter    4, 0
  0x0529A: push     di
  0x0529B: push     si
  0x0529C: mov      byte ptr [bp - 2], 2
  0x052A0: mov      byte ptr [bp - 4], 7
  0x052A4: push     cx
  0x052A5: push     dx
  0x052A6: mov      dx, si
  0x052A8: mov      dh, dl
  0x052AA: mov      cx, di
  0x052AC: mov      ch, cl
  0x052AE: and      dh, 3
  0x052B1: and      ch, 3
  0x052B4: shl      ch, 2
  0x052B7: add      dh, ch
  0x052B9: cmp      al, 0x10
  0x052BB: jb       0x5316
  0x052BD: cmp      al, 0x88
  0x052BF: jae      0x5316
  0x052C1: cmp      al, 0x30
  0x052C3: ja       0x52d0
  0x052C5: mov      byte ptr [bp - 2], 0
  0x052C9: mov      byte ptr [bp - 4], 0x1f
  0x052CD: jmp      0x52dc
  0x052CF: nop      
  0x052D0: cmp      al, 0x40
  0x052D2: ja       0x52dc
  0x052D4: mov      byte ptr [bp - 2], 2
  0x052D8: mov      byte ptr [bp - 4], 0xf
  0x052DC: mov      dl, bl
  0x052DE: add      dl, dh
  0x052E0: and      dl, 0xf
  0x052E3: je       0x5316
  0x052E5: mov      cl, byte ptr [bp - 2]
  0x052E8: cmp      dl, 8
  0x052EB: je       0x5316
  0x052ED: ja       0x52f8
  0x052EF: inc      dl
  0x052F1: shr      dl, cl
  0x052F3: neg      dl
  0x052F5: jmp      0x52fd
  0x052F7: nop      
  0x052F8: sub      dl, 7
  0x052FB: shr      dl, cl
  0x052FD: mov      ch, byte ptr [bp - 4]
  0x05300: mov      cl, al
  0x05302: sub      cl, 0x10
  0x05305: and      cl, ch
  0x05307: add      cl, dl
  0x05309: inc      ch
  0x0530B: cmp      cl, ch
  0x0530D: jae      0x5312
  0x0530F: jmp      0x5314
  0x05311: nop      
  0x05312: neg      dl
  0x05314: add      al, dl
  0x05316: pop      dx
  0x05317: pop      cx
  0x05318: pop      si
  0x05319: pop      di
  0x0531A: leave    
  0x0531B: retf     

============================================================
func_L091 at file 0x0531C, 89 bytes
============================================================
  0x0531C: enter    0x10, 0
  0x05320: push     di
  0x05321: push     si
  0x05322: mov      ax, word ptr [bp + 8]
  0x05325: mov      word ptr [bp - 6], ax
  0x05328: lea      bx, [bp + 6]
  0x0532B: mov      ax, word ptr [bp + 0x16]
  0x0532E: mov      dx, word ptr [bp + 0x18]
  0x05331: lcall    0xa4e, 8
  0x05336: mov      word ptr [bp - 0xa], ax
  0x05339: mov      word ptr [bp - 8], dx
  0x0533C: mov      ax, word ptr [bp + 0x10]
  0x0533F: mov      word ptr [bp - 0xc], ax
  0x05342: lea      bx, [bp + 0xe]
  0x05345: mov      ax, word ptr [bp + 0x1a]
  0x05348: mov      dx, word ptr [bp + 0x1c]
  0x0534B: lcall    0xa4e, 8
  0x05350: mov      word ptr [bp - 0x10], ax
  0x05353: mov      word ptr [bp - 0xe], dx
  0x05356: push     ds
  0x05357: lds      si, ptr [bp - 0xa]
  0x0535A: les      di, ptr [bp - 0x10]
  0x0535D: xor      dx, dx
  0x0535F: xor      ah, ah
  0x05361: mov      bx, 0
  0x05364: mov      cx, word ptr [bp + 0x1e]
  0x05367: mov      word ptr [bp - 4], 0
  0x0536C: mov      al, byte ptr [bp + 0x20]
  0x0536F: test     al, 3
  0x05371: jne      0x537b

============================================================
func_L092 at file 0x053DE, 44 bytes
============================================================
  0x053DE: enter    4, 0
  0x053E2: dec      word ptr [bp + 6]
  0x053E5: mov      ax, word ptr [bp + 6]
  0x053E8: sar      ax, 3
  0x053EB: mov      word ptr [bp - 2], ax
  0x053EE: mov      cl, byte ptr [bp + 6]
  0x053F1: and      cl, 7
  0x053F4: mov      dx, 1
  0x053F7: shl      dx, cl
  0x053F9: mov      word ptr [bp - 4], dx
  0x053FC: cmp      word ptr [bp + 8], 0
  0x05400: je       0x540a
  0x05402: mov      bx, ax
  0x05404: or       byte ptr [bx + 0x540a], dl
  0x05408: leave    
  0x05409: retf     

============================================================
func_L093 at file 0x05418, 36 bytes
============================================================
  0x05418: enter    4, 0
  0x0541C: dec      word ptr [bp + 6]
  0x0541F: mov      ax, word ptr [bp + 6]
  0x05422: sar      ax, 3
  0x05425: mov      cl, byte ptr [bp + 6]
  0x05428: and      cl, 7
  0x0542B: mov      dx, 1
  0x0542E: shl      dx, cl
  0x05430: mov      bx, ax
  0x05432: mov      ax, dx
  0x05434: and      al, byte ptr [bx + 0x540a]
  0x05438: sub      ah, ah
  0x0543A: leave    
  0x0543B: retf     

============================================================
func_L094 at file 0x0543C, 158 bytes
============================================================
  0x0543C: enter    2, 0
  0x05440: mov      word ptr [bp - 2], 1
  0x05445: cmp      word ptr [bp + 6], 0
  0x05449: jle      0x5465
  0x0544B: push     word ptr [bp + 6]
  0x0544E: push     cs
  0x0544F: call     0x5418
  0x05452: add      sp, 2
  0x05455: or       ax, ax
  0x05457: jne      0x54d5
  0x05459: push     1
  0x0545B: push     word ptr [bp + 6]
  0x0545E: push     cs
  0x0545F: call     0x53de
  0x05462: add      sp, 4
  0x05465: mov      ax, word ptr [bp + 6]
  0x05468: jmp      0x54a6
  0x0546A: nop      
  0x0546B: nop      
  0x0546C: cmp      word ptr [0xa0], 0
  0x05471: je       0x54ca
  0x05473: cmp      word ptr [0xa2], 0
  0x05478: jne      0x54ca
  0x0547A: push     2
  0x0547C: lcall    0x29f, 0x318
  0x05481: add      sp, 2
  0x05484: jmp      0x54ca
  0x05486: push     2
  0x05488: lcall    0x29f, 0x34c
  0x0548D: jmp      0x5481
  0x0548F: nop      
  0x05490: push     0x33
  0x05492: lcall    0x29f, 0x2cc
  0x05497: jmp      0x5481
  0x05499: nop      
  0x0549A: push     0x35
  0x0549C: jmp      0x5492
  0x0549E: push     0x36
  0x054A0: jmp      0x5492
  0x054A2: push     0x39
  0x054A4: jmp      0x5492
  0x054A6: cmp      ax, 0xa
  0x054A9: ja       0x54ca
  0x054AB: shl      ax, 1
  0x054AD: xchg     bx, ax
  0x054AE: jmp      word ptr cs:[bx + 0xe4]
  0x054B3: nop      
  0x054B4: pushf    
  0x054B5: add      byte ptr [si - 0x4a00], bl
  0x054B9: add      al, al
  0x054BB: add      dl, cl
  0x054BD: add      dh, cl
  0x054BF: add      dl, dl
  0x054C1: add      dl, bh
  0x054C3: add      dl, bh
  0x054C5: add      byte ptr [bp + si - 0x600], ch
  0x054C9: add      bh, bh
  0x054CB: jbe      0x54d3
  0x054CD: lcall    0x181f, 0x52e
  0x054D2: mov      word ptr [bp - 2], ax
  0x054D5: mov      ax, word ptr [bp - 2]
  0x054D8: leave    
  0x054D9: retf     

============================================================
func_L095 at file 0x054DA, 360 bytes
============================================================
  0x054DA: enter    0x340, 0
  0x054DE: push     di
  0x054DF: push     si
  0x054E0: sub      ax, ax
  0x054E2: mov      word ptr [bp - 2], ax
  0x054E5: mov      word ptr [bp - 0x324], ax
  0x054E9: mov      ax, word ptr [bp + 6]
  0x054EC: mov      word ptr [bp - 0x33c], ax
  0x054F0: jmp      0x556c
  0x054F2: nop      
  0x054F3: nop      
  0x054F4: push     0x20
  0x054F6: push     bx
  0x054F7: lcall    0xd1d, 0xc56
  0x054FC: add      sp, 4
  0x054FF: mov      word ptr [bp - 0x33e], ax
  0x05503: or       ax, ax
  0x05505: je       0x550c
  0x05507: mov      bx, ax
  0x05509: mov      byte ptr [bx], 0
  0x0550C: cmp      word ptr [bp - 2], 0xa
  0x05510: jge      0x5535
  0x05512: push     word ptr [bp - 0x33c]
  0x05516: imul     si, word ptr [bp - 2], 0x50
  0x0551A: lea      ax, [bp + si - 0x322]
  0x0551E: push     ax
  0x0551F: mov      si, ax
  0x05521: lcall    0xd1d, 0x7e4
  0x05526: add      sp, 4
  0x05529: mov      di, word ptr [bp - 2]
  0x0552C: shl      di, 1
  0x0552E: mov      word ptr [bp + di - 0x33a], si
  0x05532: inc      word ptr [bp - 2]
  0x05535: cmp      word ptr [bp - 0x33e], 0
  0x0553A: je       0x554f
  0x0553C: mov      bx, word ptr [bp - 0x33e]
  0x05540: mov      byte ptr [bx], 0x20
  0x05543: jmp      0x554f
  0x05545: nop      
  0x05546: cmp      byte ptr [bx], 0x20
  0x05549: je       0x5558
  0x0554B: inc      word ptr [bp - 0x33c]
  0x0554F: mov      bx, word ptr [bp - 0x33c]
  0x05553: cmp      byte ptr [bx], 0
  0x05556: jne      0x5546
  0x05558: mov      bx, word ptr [bp - 0x33c]
  0x0555C: cmp      byte ptr [bx], 0
  0x0555F: je       0x556c
  0x05561: cmp      byte ptr [bx], 0x20
  0x05564: jne      0x556c
  0x05566: inc      word ptr [bp - 0x33c]
  0x0556A: jmp      0x5558
  0x0556C: mov      bx, word ptr [bp - 0x33c]
  0x05570: cmp      byte ptr [bx], 0
  0x05573: je       0x5578
  0x05575: jmp      0x54f4
  0x05578: mov      si, word ptr [bp - 2]
  0x0557B: shl      si, 1
  0x0557D: mov      word ptr [bp + si - 0x33a], 0
  0x05583: cmp      word ptr [bp - 2], 0
  0x05587: jg       0x558c
  0x05589: jmp      0x563e
  0x0558C: lcall    0x1047, 0x11f
  0x05591: or       ax, ax
  0x05593: je       0x55a5
  0x05595: mov      word ptr [0xa2], 0
  0x0559B: push     1
  0x0559D: lcall    0x1059, 0xa
  0x055A2: add      sp, 2
  0x055A5: mov      word ptr [0x372], 0
  0x055AB: lcall    0x181f, 0x5ec
  0x055B0: push     word ptr [0x2dae]
  0x055B4: push     word ptr [0x2dac]
  0x055B8: push     word ptr [0x2daa]
  0x055BC: push     word ptr [0x2da8]  ; map_terrain
  0x055C0: sub      al, al
  0x055C2: lcall    0xb8d, 4
  0x055C7: push     0
  0x055C9: push     0x140
  0x055CC: push     0xc8
  0x055CF: sub      ax, ax
  0x055D1: cdq      
  0x055D2: sub      bx, bx
  0x055D4: lcall    0xb70, 0x3a
  0x055D9: lcall    0x1047, 0x11f
  0x055DE: or       ax, ax
  0x055E0: je       0x5602
  0x055E2: push     8
  0x055E4: lcall    0x1059, 0xa
  0x055E9: add      sp, 2
  0x055EC: or       ax, ax
  0x055EE: je       0x55fd
  0x055F0: mov      ax, word ptr [bp - 0x324]
  0x055F4: inc      word ptr [bp - 0x324]
  0x055F8: cmp      ax, 0x7530
  0x055FB: jl       0x55e2
  0x055FD: lcall    0x1059, 0x5f
  0x05602: lcall    0xa29, 0x1d1
  0x05607: push     0x13
  0x05609: push     0
  0x0560B: lcall    0xa58, 0x8c
  0x05610: add      sp, 4
  0x05613: lcall    0x175d, 0x6b3
  0x05618: lea      ax, [bp - 0x33a]
  0x0561C: push     ax
  0x0561D: push     word ptr [bp - 0x33a]
  0x05621: lcall    0xd1d, 0xe2c
  0x05626: add      sp, 4
  0x05629: push     0xf4
  0x0562C: lcall    0xd1d, 0x712
  0x05631: add      sp, 2
  0x05634: push     3
  0x05636: lcall    0xd1d, 0x30d
  0x0563B: add      sp, 2
  0x0563E: pop      si
  0x0563F: pop      di
  0x05640: leave    
  0x05641: retf     

============================================================
func_L096 at file 0x0566E, 132 bytes
============================================================
  0x0566E: enter    0x114, 0
  0x05672: push     0x106
  0x05675: lea      ax, [bp - 0x114]
  0x05679: push     ax
  0x0567A: lcall    0xd1d, 0x7e4
  0x0567F: add      sp, 4
  0x05682: push     0x10f
  0x05685: lea      ax, [bp - 0x114]
  0x05689: push     ax
  0x0568A: lcall    0xd1d, 0x7a4
  0x0568F: add      sp, 4
  0x05692: cmp      word ptr [0x2606], 0
  0x05697: je       0x56a9
  0x05699: push     0x112
  0x0569C: lea      ax, [bp - 0x114]
  0x056A0: push     ax
  0x056A1: lcall    0xd1d, 0x7a4
  0x056A6: add      sp, 4
  0x056A9: cmp      byte ptr [0x828], 0
  0x056AE: je       0x56c0
  0x056B0: push     0x114
  0x056B3: lea      ax, [bp - 0x114]
  0x056B7: push     ax
  0x056B8: lcall    0xd1d, 0x7a4
  0x056BD: add      sp, 4
  0x056C0: cmp      word ptr [0x36c], 0
  0x056C5: je       0x56e7
  0x056C7: push     0x116
  0x056CA: lea      ax, [bp - 0x114]
  0x056CE: push     ax
  0x056CF: lcall    0xd1d, 0x7a4
  0x056D4: add      sp, 4
  0x056D7: push     0x84fe
  0x056DA: lea      ax, [bp - 0x114]
  0x056DE: push     ax
  0x056DF: lcall    0xd1d, 0x7a4
  0x056E4: add      sp, 4
  0x056E7: lea      ax, [bp - 0x114]
  0x056EB: push     ax
  0x056EC: push     cs
  0x056ED: call     0x54da
  0x056F0: leave    
  0x056F1: retf     

============================================================
func_L097 at file 0x056F2, 109 bytes
============================================================
  0x056F2: enter    0x114, 0
  0x056F6: push     0x11b
  0x056F9: lea      ax, [bp - 0x114]
  0x056FD: push     ax
  0x056FE: lcall    0xd1d, 0x7e4
  0x05703: add      sp, 4
  0x05706: push     0x124
  0x05709: lea      ax, [bp - 0x114]
  0x0570D: push     ax
  0x0570E: lcall    0xd1d, 0x7a4
  0x05713: add      sp, 4
  0x05716: cmp      word ptr [0x2606], 0
  0x0571B: je       0x572d
  0x0571D: push     0x129
  0x05720: lea      ax, [bp - 0x114]
  0x05724: push     ax
  0x05725: lcall    0xd1d, 0x7a4
  0x0572A: add      sp, 4
  0x0572D: cmp      word ptr [0x36c], 0
  0x05732: je       0x5754
  0x05734: push     0x12b
  0x05737: lea      ax, [bp - 0x114]
  0x0573B: push     ax
  0x0573C: lcall    0xd1d, 0x7a4
  0x05741: add      sp, 4
  0x05744: push     0x84fe
  0x05747: lea      ax, [bp - 0x114]
  0x0574B: push     ax
  0x0574C: lcall    0xd1d, 0x7a4
  0x05751: add      sp, 4
  0x05754: lea      ax, [bp - 0x114]
  0x05758: push     ax
  0x05759: push     cs
  0x0575A: call     0x54da
  0x0575D: leave    
  0x0575E: retf     

============================================================
func_L098 at file 0x05760, 1178 bytes
============================================================
  0x05760: enter    0x16, 0
  0x05764: push     si
  0x05765: mov      word ptr [bp - 2], 0
  0x0576A: lcall    0x181f, 0x5a8
  0x0576F: push     4
  0x05771: lcall    0x984, 0xaa
  0x05776: add      sp, 2
  0x05779: lcall    0x181f, 0x59a
  0x0577E: push     5
  0x05780: lcall    0x984, 0xaa
  0x05785: add      sp, 2
  0x05788: lcall    0x984, 0x4f6
  0x0578D: cmp      byte ptr [0x829], 0
  0x05792: je       0x57de
  0x05794: mov      word ptr [bp - 0x14], 0
  0x05799: jmp      0x57c5
  0x0579B: nop      
  0x0579C: inc      word ptr [bp - 0xe]
  0x0579F: cmp      word ptr [bp - 0xe], 0x10
  0x057A3: jge      0x57c2
  0x057A5: mov      bx, word ptr [0x84fc]
  0x057A9: mov      si, word ptr [bp - 0xe]
  0x057AC: mov      al, byte ptr [bx + si + 0x4c]
  0x057AF: cwde     
  0x057B0: dec      ax
  0x057B1: jns      0x57b5
  0x057B3: sub      ax, ax
  0x057B5: mov      bx, word ptr [bp - 0x14]
  0x057B8: shl      bx, 4
  0x057BB: mov      byte ptr [bx + si - 0x7b44], al
  0x057BF: jmp      0x579c
  0x057C1: nop      
  0x057C2: inc      word ptr [bp - 0x14]
  0x057C5: cmp      word ptr [bp - 0x14], 4
  0x057C9: jge      0x57de
  0x057CB: push     word ptr [bp - 0x14]
  0x057CE: lcall    0x181f, 0x582
  0x057D3: add      sp, 2
  0x057D6: mov      word ptr [bp - 0xe], 0
  0x057DB: jmp      0x579f
  0x057DD: nop      
  0x057DE: cmp      word ptr [0x104], 0
  0x057E3: je       0x5836
  0x057E5: lcall    0x262, 0xda
  0x057EA: push     3
  0x057EC: lcall    0x29f, 0x318
  0x057F1: add      sp, 2
  0x057F4: lcall    0x181f, 0x574
  0x057F9: lcall    0x984, 0x4f6
  0x057FE: mov      word ptr [0x53c2], 0  ; game_flag
  0x05804: mov      word ptr [0x53a2], 1
  0x0580A: lea      bx, [0x130]
  0x0580E: lcall    0x181f, 0x3fe
  0x05813: mov      word ptr [bp - 4], ax
  0x05816: cmp      ax, 2
  0x05819: jne      0x5821
  0x0581B: mov      word ptr [0x53c2], 1  ; game_flag
  0x05821: or       byte ptr [0x5382], 0x10
  0x05826: mov      word ptr [0x104], 0
  0x0582C: cmp      word ptr [0x53c2], 0  ; game_flag
  0x05831: jne      0x5836
  0x05833: jmp      0x5bf7
  0x05836: mov      word ptr [bp - 0x10], 0
  0x0583B: cmp      byte ptr [0x829], 0
  0x05840: jne      0x5848
  0x05842: mov      word ptr [0x53c6], 0
  0x05848: cmp      word ptr [bp - 2], 0
  0x0584C: jne      0x585f
  0x0584E: push     1
  0x05850: push     1
  0x05852: lcall    0x181f, 0x55e
  0x05857: add      sp, 4
  0x0585A: mov      word ptr [bp - 2], 1
  0x0585F: cmp      byte ptr [0x829], 0
  0x05864: jne      0x589e
  0x05866: lcall    0x181f, 0x550
  0x0586B: mov      word ptr [bp - 0x12], 0
  0x05870: jmp      0x587d
  0x05872: imul     bx, ax, 0x1c  ; *Unit
  0x05875: mov      byte ptr [bx + 0x3149], 0
  0x0587A: inc      word ptr [bp - 0x12]
  0x0587D: mov      ax, word ptr [bp - 0x12]
  0x05880: cmp      word ptr [0x539c], ax  ; score
  0x05884: jg       0x5872
  0x05886: mov      ax, word ptr [0x5398]
  0x05889: mov      word ptr [0x5396], ax
  0x0588C: cmp      word ptr [0x53a4], 0
  0x05891: jl       0x5899
  0x05893: mov      ax, word ptr [0x53a4]
  0x05896: mov      word ptr [0x5396], ax
  0x05899: lcall    0x181f, 0x676
  0x0589E: mov      word ptr [bp - 0x14], 0
  0x058A3: jmp      0x58fd
  0x058A5: nop      
  0x058A6: imul     bx, word ptr [bp - 0x14], 0x34  ; *AI
  0x058AA: cmp      byte ptr [bx + 0x543f], 0  ; ai_pers
  0x058AF: jne      0x58ef
  0x058B1: mov      ax, word ptr [bp - 0x14]
  0x058B4: mov      word ptr [0x5396], ax
  0x058B7: cmp      word ptr [0x53a4], 0
  0x058BC: jl       0x58c4
  0x058BE: mov      ax, word ptr [0x53a4]
  0x058C1: mov      word ptr [0x5396], ax
  0x058C4: push     1
  0x058C6: push     1
  0x058C8: lcall    0x181f, 0x55e
  0x058CD: add      sp, 4
  0x058D0: cmp      byte ptr [0x829], 0
  0x058D5: jne      0x58e2
  0x058D7: test     byte ptr [0x5383], 4
  0x058DC: je       0x58e2
  0x058DE: push     cs
  0x058DF: call     0x5642
  0x058E2: lcall    0x181f, 0x668
  0x058E7: lcall    0x181f, 0x62c
  0x058EC: inc      word ptr [bp - 0x10]
  0x058EF: mov      byte ptr [0x829], 0
  0x058F4: mov      word ptr [0x53c6], 0
  0x058FA: inc      word ptr [bp - 0x14]
  0x058FD: cmp      word ptr [0x53c2], 0  ; game_flag
  0x05902: jne      0x5907
  0x05904: jmp      0x5a42
  0x05907: cmp      word ptr [bp - 0x14], 4
  0x0590B: jl       0x5910
  0x0590D: jmp      0x5a42
  0x05910: cmp      byte ptr [0x829], 0
  0x05915: je       0x5920
  0x05917: mov      ax, word ptr [bp - 0x14]
  0x0591A: cmp      word ptr [0x5398], ax
  0x0591E: jg       0x58fa
  0x05920: mov      ax, word ptr [bp - 0x14]
  0x05923: mov      word ptr [0x5394], ax
  0x05926: imul     bx, ax, 0x34  ; *AI
  0x05929: cmp      byte ptr [bx + 0x543f], 0  ; ai_pers
  0x0592E: je       0x5933
  0x05930: jmp      0x59d8
  0x05933: test     byte ptr [0x5381], 0x80
  0x05938: jne      0x593d
  0x0593A: jmp      0x59d8
  0x0593D: push     word ptr [0x2dae]
  0x05941: push     word ptr [0x2dac]
  0x05945: push     word ptr [0x2daa]
  0x05949: push     word ptr [0x2da8]  ; map_terrain
  0x0594D: sub      al, al
  0x0594F: lcall    0xb8d, 4
  0x05954: push     0
  0x05956: push     0x140
  0x05959: push     0xc8
  0x0595C: sub      ax, ax
  0x0595E: cdq      
  0x0595F: sub      bx, bx
  0x05961: lcall    0xb70, 0x3a
  0x05966: push     word ptr [bp - 0x14]
  0x05969: lcall    0x5b3, 0x24e
  0x0596E: add      sp, 2
  0x05971: push     ax
  0x05972: push     0
  0x05974: lcall    0x181f, 0x438
  0x05979: add      sp, 4
  0x0597C: push     2
  0x0597E: push     0x137
  0x05981: lcall    0x181f, 0x652
  0x05986: add      sp, 4
  0x05989: mov      ax, word ptr [bp - 0x14]
  0x0598C: mov      word ptr [0x5396], ax
  0x0598F: cmp      word ptr [0x53a4], 0
  0x05994: jl       0x599c
  0x05996: mov      ax, word ptr [0x53a4]
  0x05999: mov      word ptr [0x5396], ax
  0x0599C: push     -1
  0x0599E: push     word ptr [bp - 0x14]
  0x059A1: mov      ax, word ptr [0x853c]
  0x059A4: sar      ax, 1
  0x059A6: push     ax
  0x059A7: mov      ax, word ptr [0x853a]
  0x059AA: sar      ax, 1
  0x059AC: push     ax
  0x059AD: lcall    0x5eb, 0x142
  0x059B2: add      sp, 8
  0x059B5: mov      word ptr [bp - 0x16], ax
  0x059B8: or       ax, ax
  0x059BA: jl       0x59d3
  0x059BC: mov      bx, word ptr [0x8542]  ; cur_nation
  0x059C0: mov      al, byte ptr [bx]
  0x059C2: sub      ah, ah
  0x059C4: mov      word ptr [0x8540], ax
  0x059C7: mov      word ptr [0x17c], ax
  0x059CA: mov      al, byte ptr [bx + 1]
  0x059CD: mov      word ptr [0x853e], ax
  0x059D0: mov      word ptr [0x17e], ax
  0x059D3: lcall    0x984, 0x4f6
  0x059D8: cmp      byte ptr [0x829], 0
  0x059DD: jne      0x59ef
  0x059DF: imul     bx, word ptr [bp - 0x14], 0x34  ; *AI
  0x059E3: cmp      byte ptr [bx + 0x543f], 2  ; ai_pers
  0x059E8: je       0x59ef
  0x059EA: lcall    0x181f, 0x644
  0x059EF: imul     bx, word ptr [bp - 0x14], 0x34  ; *AI
  0x059F3: cmp      byte ptr [bx + 0x543f], 1  ; ai_pers
  0x059F8: je       0x59fd
  0x059FA: jmp      0x58a6
  0x059FD: mov      ax, word ptr [bp - 0x14]
  0x05A00: cmp      word ptr [0x5396], ax
  0x05A04: je       0x5a0d
  0x05A06: cmp      word ptr [0x53a2], 0
  0x05A0B: je       0x5a19
  0x05A0D: push     1
  0x05A0F: push     1
  0x05A11: lcall    0x181f, 0x55e
  0x05A16: add      sp, 4
  0x05A19: cmp      byte ptr [0x829], 0
  0x05A1E: jne      0x5a34
  0x05A20: mov      ax, word ptr [bp - 0x14]
  0x05A23: cmp      word ptr [0x5398], ax
  0x05A27: jne      0x5a34
  0x05A29: test     byte ptr [0x5383], 4
  0x05A2E: je       0x5a34
  0x05A30: push     cs
  0x05A31: call     0x5642
  0x05A34: push     word ptr [bp - 0x14]
  0x05A37: lcall    0x181f, 0x638
  0x05A3C: add      sp, 2
  0x05A3F: jmp      0x58ef
  0x05A42: cmp      word ptr [0x826], 0
  0x05A47: je       0x5a6a
  0x05A49: cmp      byte ptr [0x828], 0
  0x05A4E: jne      0x5a6a
  0x05A50: lea      ax, [bp - 0xa]
  0x05A53: push     ax
  0x05A54: lea      ax, [bp - 8]
  0x05A57: push     ax
  0x05A58: lcall    0xa58, 0x38b
  0x05A5D: add      sp, 4
  0x05A60: or       ax, ax
  0x05A62: je       0x5a6a
  0x05A64: mov      word ptr [0x826], 0
  0x05A6A: cmp      word ptr [bp - 0x10], 0
  0x05A6E: jne      0x5a96
  0x05A70: cmp      word ptr [0x826], 0
  0x05A75: jne      0x5a96
  0x05A77: cmp      byte ptr [0x828], 0
  0x05A7C: jne      0x5a96
  0x05A7E: mov      ax, word ptr [0x5398]
  0x05A81: mov      word ptr [0x5396], ax
  0x05A84: cmp      word ptr [0x53a4], 0
  0x05A89: jl       0x5a91
  0x05A8B: mov      ax, word ptr [0x53a4]
  0x05A8E: mov      word ptr [0x5396], ax
  0x05A91: lcall    0x181f, 0x62c
  0x05A96: cmp      word ptr [0x53c2], 0  ; game_flag
  0x05A9B: je       0x5ad0
  0x05A9D: inc      word ptr [0x538e]  ; unk_thresh
  0x05AA1: cmp      word ptr [0x538a], 0x640  ; year=1600
  0x05AA7: jl       0x5acc
  0x05AA9: jne      0x5abb
  0x05AAB: cmp      word ptr [0x538c], 0
  0x05AB0: jne      0x5abb
  0x05AB2: lea      bx, [0x141]
  0x05AB6: lcall    0x181f, 0x3fe
  0x05ABB: inc      word ptr [0x538c]
  0x05ABF: cmp      word ptr [0x538c], 1
  0x05AC4: jle      0x5ad0
  0x05AC6: mov      word ptr [0x538c], 0
  0x05ACC: inc      word ptr [0x538a]  ; year
  0x05AD0: cmp      byte ptr [0x828], 0
  0x05AD5: jne      0x5b05
  0x05AD7: cmp      word ptr [0x826], 0
  0x05ADC: jne      0x5b05
  0x05ADE: cmp      word ptr [0x53c2], 0  ; game_flag
  0x05AE3: je       0x5b05
  0x05AE5: lcall    0x181f, 0x61e
  0x05AEA: cmp      word ptr [0x104], 0
  0x05AEF: je       0x5b05
  0x05AF1: push     0xa
  0x05AF3: lcall    0x181f, 0x5b6
  0x05AF8: add      sp, 2
  0x05AFB: mov      word ptr [0x53c2], 0  ; game_flag
  0x05B01: push     cs
  0x05B02: call     0x56f2
  0x05B05: cmp      byte ptr [0x828], 0
  0x05B0A: jne      0x5b0f
  0x05B0C: jmp      0x5bed
  0x05B0F: mov      ax, word ptr [0x538e]  ; unk_thresh
  0x05B12: mov      cx, 4
  0x05B15: cdq      
  0x05B16: idiv     cx
  0x05B18: or       dx, dx
  0x05B1A: je       0x5b1f
  0x05B1C: jmp      0x5bae
  0x05B1F: mov      ax, word ptr [0x538e]  ; unk_thresh
  0x05B22: mov      cx, 3
  0x05B25: cdq      
  0x05B26: idiv     cx
  0x05B28: or       dx, dx
  0x05B2A: jne      0x5b54
  0x05B2C: cmp      word ptr [0x150], 0x19
  0x05B31: jge      0x5bae
  0x05B33: inc      word ptr [0x150]
  0x05B37: push     word ptr [0x150]
  0x05B3B: lcall    0x2fd, 0x6c
  0x05B40: add      sp, 2
  0x05B43: mov      word ptr [bp - 6], ax
  0x05B46: or       ax, ax
  0x05B48: je       0x5bae
  0x05B4A: cmp      word ptr [0x150], 0x19
  0x05B4F: jl       0x5b33
  0x05B51: jmp      0x5bae
  0x05B53: nop      
  0x05B54: mov      ax, word ptr [0x538e]  ; unk_thresh
  0x05B57: cdq      
  0x05B58: idiv     cx
  0x05B5A: dec      dx
  0x05B5B: jne      0x5ba0
  0x05B5D: push     -1
  0x05B5F: push     word ptr [0x5398]
  0x05B63: mov      ax, word ptr [0x853c]
  0x05B66: dec      ax
  0x05B67: dec      ax
  0x05B68: push     ax
  0x05B69: push     2
  0x05B6B: lcall    0x9ef, 0x32
  0x05B70: add      sp, 4
  0x05B73: push     ax
  0x05B74: mov      ax, word ptr [0x853a]
  0x05B77: dec      ax
  0x05B78: dec      ax
  0x05B79: push     ax
  0x05B7A: push     2
  0x05B7C: lcall    0x9ef, 0x32
  0x05B81: add      sp, 4
  0x05B84: push     ax
  0x05B85: lcall    0x5eb, 0x142
  0x05B8A: add      sp, 8
  0x05B8D: mov      word ptr [bp - 0x16], ax
  0x05B90: or       ax, ax
  0x05B92: jl       0x5bae
  0x05B94: push     ax
  0x05B95: lcall    0x181f, 0x608
  0x05B9A: add      sp, 2
  0x05B9D: jmp      0x5bae
  0x05B9F: nop      
  0x05BA0: push     -1
  0x05BA2: push     word ptr [0x5398]
  0x05BA6: lcall    0x181f, 0x5fa
  0x05BAB: add      sp, 4
  0x05BAE: test     byte ptr [0x5382], 1
  0x05BB3: jne      0x5bbd
  0x05BB5: cmp      word ptr [0x538a], 0x6bd  ; year
  0x05BBB: jle      0x5bc2
  0x05BBD: mov      byte ptr [0x82b], 1
  0x05BC2: lcall    0xc0c, 6
  0x05BC7: or       dx, dx
  0x05BC9: jg       0x5bd9
  0x05BCB: jl       0x5bd2
  0x05BCD: cmp      ax, 0x3840
  0x05BD0: jae      0x5bd9
  0x05BD2: cmp      byte ptr [0x82b], 0
  0x05BD7: je       0x5bed
  0x05BD9: push     5
  0x05BDB: lcall    0x181f, 0x5b6
  0x05BE0: add      sp, 2
  0x05BE3: mov      word ptr [0x53c2], 0  ; game_flag
  0x05BE9: push     cs
  0x05BEA: call     0x566e
  0x05BED: cmp      word ptr [0x53c2], 0  ; game_flag
  0x05BF2: je       0x5bf7
  0x05BF4: jmp      0x5836
  0x05BF7: pop      si
  0x05BF8: leave    
  0x05BF9: retf     

============================================================
func_L099 at file 0x05BFA, 49 bytes
============================================================
  0x05BFA: enter    2, 0
  0x05BFE: mov      word ptr [bp - 2], 1
  0x05C03: cmp      word ptr [bp + 6], 1
  0x05C07: jl       0x5c21
  0x05C09: cmp      word ptr [bp + 8], 1
  0x05C0D: jl       0x5c21
  0x05C0F: mov      ax, word ptr [0x853a]
  0x05C12: dec      ax
  0x05C13: cmp      ax, word ptr [bp + 6]
  0x05C16: jle      0x5c21
  0x05C18: mov      ax, word ptr [0x853c]
  0x05C1B: dec      ax
  0x05C1C: cmp      ax, word ptr [bp + 8]
  0x05C1F: jg       0x5c26
  0x05C21: mov      word ptr [bp - 2], 0
  0x05C26: mov      ax, word ptr [bp - 2]
  0x05C29: leave    
  0x05C2A: retf     

============================================================
func_L100 at file 0x05C2C, 132 bytes
============================================================
  0x05C2C: enter    2, 0
  0x05C30: cmp      word ptr [bp + 6], 0
  0x05C34: jg       0x5c3f
  0x05C36: mov      ax, word ptr [bp + 6]
  0x05C39: not      ax
  0x05C3B: inc      ax
  0x05C3C: mov      word ptr [bp + 6], ax
  0x05C3F: cmp      word ptr [bp + 8], 0
  0x05C43: jg       0x5c4e
  0x05C45: mov      ax, word ptr [bp + 8]
  0x05C48: not      ax
  0x05C4A: inc      ax
  0x05C4B: mov      word ptr [bp + 8], ax
  0x05C4E: mov      ax, word ptr [bp + 8]
  0x05C51: add      ax, word ptr [bp + 6]
  0x05C54: cmp      ax, 1
  0x05C57: jg       0x5c5e
  0x05C59: mov      ax, 1
  0x05C5C: jmp      0x5c60
  0x05C5E: sub      ax, ax
  0x05C60: mov      word ptr [bp - 2], ax
  0x05C63: cmp      word ptr [bp + 0xa], 1
  0x05C67: je       0x5cab
  0x05C69: cmp      word ptr [bp + 6], 2
  0x05C6D: jge      0x5c79
  0x05C6F: cmp      word ptr [bp + 8], 2
  0x05C73: jge      0x5c79
  0x05C75: or       byte ptr [bp - 2], 1
  0x05C79: cmp      word ptr [bp + 0xa], 2
  0x05C7D: je       0x5cab
  0x05C7F: mov      ax, word ptr [bp + 8]
  0x05C82: add      ax, word ptr [bp + 6]
  0x05C85: cmp      ax, 2
  0x05C88: jg       0x5c90
  0x05C8A: mov      ax, 1
  0x05C8D: jmp      0x5c92
  0x05C8F: nop      
  0x05C90: sub      ax, ax
  0x05C92: or       word ptr [bp - 2], ax
  0x05C95: cmp      word ptr [bp + 0xa], 3
  0x05C99: je       0x5cab
  0x05C9B: cmp      word ptr [bp + 6], 2
  0x05C9F: jl       0x5ca7
  0x05CA1: cmp      word ptr [bp + 8], 2
  0x05CA5: jge      0x5cab
  0x05CA7: or       byte ptr [bp - 2], 1
  0x05CAB: mov      ax, word ptr [bp - 2]
  0x05CAE: leave    
  0x05CAF: retf     

============================================================
func_L101 at file 0x05CB0, 54 bytes
============================================================
  0x05CB0: enter    2, 0
  0x05CB4: mov      word ptr [bp - 2], 1
  0x05CB9: mov      ax, word ptr [bp + 6]
  0x05CBC: cmp      word ptr [0x8328], ax
  0x05CC0: jg       0x5cc8
  0x05CC2: cmp      word ptr [0x8804], ax
  0x05CC6: jge      0x5ccd
  0x05CC8: mov      word ptr [bp - 2], 0
  0x05CCD: mov      ax, word ptr [bp + 8]
  0x05CD0: cmp      word ptr [0x832e], ax
  0x05CD4: jg       0x5cdc
  0x05CD6: cmp      word ptr [0x8806], ax
  0x05CDA: jge      0x5ce1
  0x05CDC: mov      word ptr [bp - 2], 0
  0x05CE1: mov      ax, word ptr [bp - 2]
  0x05CE4: leave    
  0x05CE5: retf     

============================================================
func_L102 at file 0x05CE6, 24 bytes
============================================================
  0x05CE6: enter    4, 0
  0x05CEA: mov      ax, word ptr [bp + 8]
  0x05CED: imul     word ptr [0x853a]
  0x05CF1: add      ax, word ptr [0x15c]
  0x05CF5: mov      dx, word ptr [0x15e]
  0x05CF9: add      ax, word ptr [bp + 6]
  0x05CFC: leave    
  0x05CFD: retf     

============================================================
func_L103 at file 0x05CFE, 28 bytes
============================================================
  0x05CFE: enter    4, 0
  0x05D02: mov      ax, word ptr [0x853a]
  0x05D05: imul     word ptr [bp + 8]
  0x05D08: mov      bx, ax
  0x05D0A: add      bx, word ptr [0x15c]
  0x05D0E: mov      es, word ptr [0x15e]
  0x05D12: add      bx, word ptr [bp + 6]
  0x05D15: mov      al, byte ptr es:[bx]
  0x05D18: leave    
  0x05D19: retf     

============================================================
func_L104 at file 0x05D1A, 23 bytes
============================================================
  0x05D1A: enter    4, 0
  0x05D1E: mov      ax, word ptr [0x853a]
  0x05D21: imul     word ptr [bp + 8]
  0x05D24: add      ax, word ptr [0x160]
  0x05D28: mov      dx, word ptr [0x162]
  0x05D2C: add      ax, word ptr [bp + 6]
  0x05D2F: leave    
  0x05D30: retf     

============================================================
func_L105 at file 0x05D32, 28 bytes
============================================================
  0x05D32: enter    4, 0
  0x05D36: mov      ax, word ptr [0x853a]
  0x05D39: imul     word ptr [bp + 8]
  0x05D3C: mov      bx, ax
  0x05D3E: add      bx, word ptr [0x160]
  0x05D42: mov      es, word ptr [0x162]
  0x05D46: add      bx, word ptr [bp + 6]
  0x05D49: mov      al, byte ptr es:[bx]
  0x05D4C: leave    
  0x05D4D: retf     

============================================================
func_L106 at file 0x05D4E, 40 bytes
============================================================
  0x05D4E: enter    4, 0
  0x05D52: push     word ptr [bp + 8]
  0x05D55: push     word ptr [bp + 6]
  0x05D58: push     cs
  0x05D59: call     0x5d1a
  0x05D5C: add      sp, 4
  0x05D5F: mov      word ptr [bp - 4], ax
  0x05D62: mov      word ptr [bp - 2], dx
  0x05D65: cmp      word ptr [bp + 0xc], 0
  0x05D69: je       0x5d76
  0x05D6B: mov      al, byte ptr [bp + 0xa]
  0x05D6E: les      bx, ptr [bp - 4]
  0x05D71: or       byte ptr es:[bx], al
  0x05D74: leave    
  0x05D75: retf     

============================================================
func_L107 at file 0x05D84, 23 bytes
============================================================
  0x05D84: enter    4, 0
  0x05D88: mov      ax, word ptr [0x853a]
  0x05D8B: imul     word ptr [bp + 8]
  0x05D8E: add      ax, word ptr [0x164]
  0x05D92: mov      dx, word ptr [0x166]
  0x05D96: add      ax, word ptr [bp + 6]
  0x05D99: leave    
  0x05D9A: retf     

============================================================
func_L108 at file 0x05D9C, 29 bytes
============================================================
  0x05D9C: enter    4, 0
  0x05DA0: mov      ax, word ptr [bp + 8]
  0x05DA3: imul     word ptr [0x853a]
  0x05DA7: mov      bx, ax
  0x05DA9: add      bx, word ptr [0x164]
  0x05DAD: mov      es, word ptr [0x166]
  0x05DB1: add      bx, word ptr [bp + 6]
  0x05DB4: mov      al, byte ptr es:[bx]
  0x05DB7: leave    
  0x05DB8: retf     

============================================================
func_L109 at file 0x05DBA, 17 bytes
============================================================
  0x05DBA: push     bp
  0x05DBB: mov      bp, sp
  0x05DBD: push     word ptr [bp + 8]
  0x05DC0: push     word ptr [bp + 6]
  0x05DC3: push     cs
  0x05DC4: call     0x5d9c
  0x05DC7: and      al, 0xf
  0x05DC9: leave    
  0x05DCA: retf     

============================================================
func_L110 at file 0x05DCC, 36 bytes
============================================================
  0x05DCC: enter    4, 0
  0x05DD0: push     word ptr [bp + 8]
  0x05DD3: push     word ptr [bp + 6]
  0x05DD6: push     cs
  0x05DD7: call     0x5d84
  0x05DDA: mov      word ptr [bp - 4], ax
  0x05DDD: mov      word ptr [bp - 2], dx
  0x05DE0: les      bx, ptr [bp - 4]
  0x05DE3: mov      al, byte ptr es:[bx]
  0x05DE6: xor      al, byte ptr [bp + 0xa]
  0x05DE9: and      al, 0xf
  0x05DEB: xor      byte ptr es:[bx], al
  0x05DEE: leave    
  0x05DEF: retf     

============================================================
func_L111 at file 0x05DF0, 40 bytes
============================================================
  0x05DF0: enter    2, 0
  0x05DF4: push     word ptr [bp + 8]
  0x05DF7: push     word ptr [bp + 6]
  0x05DFA: push     cs
  0x05DFB: call     0x5d9c
  0x05DFE: add      sp, 4
  0x05E01: shr      al, 4
  0x05E04: sub      ah, ah
  0x05E06: mov      word ptr [bp - 2], ax
  0x05E09: cmp      ax, 0xf
  0x05E0C: jne      0x5e13
  0x05E0E: mov      word ptr [bp - 2], 0xffff
  0x05E13: mov      al, byte ptr [bp - 2]
  0x05E16: leave    
  0x05E17: retf     

============================================================
func_L112 at file 0x05E18, 120 bytes
============================================================
  0x05E18: enter    4, 0
  0x05E1C: cmp      word ptr [bp + 0xa], 4
  0x05E20: jge      0x5e6b
  0x05E22: push     word ptr [bp + 8]
  0x05E25: push     word ptr [bp + 6]
  0x05E28: push     cs
  0x05E29: call     0x5f82
  0x05E2C: add      sp, 4
  0x05E2F: or       ax, ax
  0x05E31: jl       0x5e6b
  0x05E33: push     word ptr [bp + 8]
  0x05E36: push     word ptr [bp + 6]
  0x05E39: push     word ptr [bp + 0xa]
  0x05E3C: push     0x1cc
  0x05E3F: lcall    0x181f, 0x77e
  0x05E44: add      sp, 8
  0x05E47: push     5
  0x05E49: lcall    0x181f, 0x5b6
  0x05E4E: add      sp, 2
  0x05E51: mov      ax, word ptr [bp + 6]
  0x05E54: cdq      
  0x05E55: push     dx
  0x05E56: push     ax
  0x05E57: mov      ax, word ptr [bp + 8]
  0x05E5A: cdq      
  0x05E5B: push     dx
  0x05E5C: push     ax
  0x05E5D: mov      ax, 0xffac
  0x05E60: mov      dx, 1
  0x05E63: mov      bx, 0x2d
  0x05E66: lcall    0x181f, 0x772
  0x05E6B: push     word ptr [bp + 8]
  0x05E6E: push     word ptr [bp + 6]
  0x05E71: push     cs
  0x05E72: call     0x5d84
  0x05E75: mov      word ptr [bp - 4], ax
  0x05E78: mov      word ptr [bp - 2], dx
  0x05E7B: les      bx, ptr [bp - 4]
  0x05E7E: mov      al, byte ptr es:[bx]
  0x05E81: and      al, 0xf
  0x05E83: mov      cl, byte ptr [bp + 0xa]
  0x05E86: shl      cl, 4
  0x05E89: or       al, cl
  0x05E8B: mov      byte ptr es:[bx], al
  0x05E8E: leave    
  0x05E8F: retf     

============================================================
func_L113 at file 0x05E90, 64 bytes
============================================================
  0x05E90: enter    2, 0
  0x05E94: mov      word ptr [bp - 2], 0xffff
  0x05E99: push     word ptr [bp + 8]
  0x05E9C: push     word ptr [bp + 6]
  0x05E9F: push     cs
  0x05EA0: call     0x5bfa
  0x05EA3: add      sp, 4
  0x05EA6: or       ax, ax
  0x05EA8: je       0x5ecb
  0x05EAA: push     word ptr [bp + 8]
  0x05EAD: push     word ptr [bp + 6]
  0x05EB0: lcall    0x3e4, 0x74
  0x05EB5: add      sp, 4
  0x05EB8: or       ax, ax
  0x05EBA: jne      0x5ecb
  0x05EBC: push     word ptr [bp + 8]
  0x05EBF: push     word ptr [bp + 6]
  0x05EC2: push     cs
  0x05EC3: call     0x5dba
  0x05EC6: sub      ah, ah
  0x05EC8: mov      word ptr [bp - 2], ax
  0x05ECB: mov      ax, word ptr [bp - 2]
  0x05ECE: leave    
  0x05ECF: retf     

============================================================
func_L114 at file 0x05ED0, 23 bytes
============================================================
  0x05ED0: enter    4, 0
  0x05ED4: mov      ax, word ptr [0x853a]
  0x05ED7: imul     word ptr [bp + 8]
  0x05EDA: add      ax, word ptr [0x168]
  0x05EDE: mov      dx, word ptr [0x16a]
  0x05EE2: add      ax, word ptr [bp + 6]
  0x05EE5: leave    
  0x05EE6: retf     

============================================================
func_L115 at file 0x05EE8, 28 bytes
============================================================
  0x05EE8: enter    4, 0
  0x05EEC: mov      ax, word ptr [0x853a]
  0x05EEF: imul     word ptr [bp + 8]
  0x05EF2: mov      bx, ax
  0x05EF4: add      bx, word ptr [0x168]
  0x05EF8: mov      es, word ptr [0x16a]
  0x05EFC: add      bx, word ptr [bp + 6]
  0x05EFF: mov      al, byte ptr es:[bx]
  0x05F02: leave    
  0x05F03: retf     

============================================================
func_L116 at file 0x05F04, 31 bytes
============================================================
  0x05F04: enter    2, 0
  0x05F08: mov      word ptr [bp - 2], 0xffff
  0x05F0D: push     word ptr [bp + 8]
  0x05F10: push     word ptr [bp + 6]
  0x05F13: push     cs
  0x05F14: call     0x5bfa
  0x05F17: add      sp, 4
  0x05F1A: or       ax, ax
  0x05F1C: jne      0x5f24
  0x05F1E: mov      ax, 0xffff
  0x05F21: leave    
  0x05F22: retf     

============================================================
func_L117 at file 0x05F48, 58 bytes
============================================================
  0x05F48: enter    2, 0
  0x05F4C: mov      word ptr [bp - 2], 0xffff
  0x05F51: push     word ptr [bp + 8]
  0x05F54: push     word ptr [bp + 6]
  0x05F57: push     cs
  0x05F58: call     0x5d32
  0x05F5B: add      sp, 4
  0x05F5E: test     al, 2
  0x05F60: je       0x5f7d
  0x05F62: push     word ptr [bp + 8]
  0x05F65: push     word ptr [bp + 6]
  0x05F68: push     cs
  0x05F69: call     0x5df0
  0x05F6C: add      sp, 4
  0x05F6F: cwde     
  0x05F70: mov      word ptr [bp - 2], ax
  0x05F73: cmp      ax, 4
  0x05F76: jl       0x5f7d
  0x05F78: mov      word ptr [bp - 2], 0xffff
  0x05F7D: mov      ax, word ptr [bp - 2]
  0x05F80: leave    
  0x05F81: retf     

============================================================
func_L118 at file 0x05F82, 31 bytes
============================================================
  0x05F82: enter    2, 0
  0x05F86: mov      word ptr [bp - 2], 0xffff
  0x05F8B: push     word ptr [bp + 8]
  0x05F8E: push     word ptr [bp + 6]
  0x05F91: push     cs
  0x05F92: call     0x5bfa
  0x05F95: add      sp, 4
  0x05F98: or       ax, ax
  0x05F9A: jne      0x5fa2
  0x05F9C: mov      ax, 0xffff
  0x05F9F: leave    
  0x05FA0: retf     

============================================================
func_L119 at file 0x05FD4, 31 bytes
============================================================
  0x05FD4: enter    2, 0
  0x05FD8: mov      word ptr [bp - 2], 0xffff
  0x05FDD: push     word ptr [bp + 8]
  0x05FE0: push     word ptr [bp + 6]
  0x05FE3: push     cs
  0x05FE4: call     0x5bfa
  0x05FE7: add      sp, 4
  0x05FEA: or       ax, ax
  0x05FEC: jne      0x5ff4
  0x05FEE: mov      ax, 0xffff
  0x05FF1: leave    
  0x05FF2: retf     

============================================================
func_L120 at file 0x06018, 33 bytes
============================================================
  0x06018: enter    2, 0
  0x0601C: push     word ptr [bp + 8]
  0x0601F: push     word ptr [bp + 6]
  0x06022: push     cs
  0x06023: call     0x5fd4
  0x06026: add      sp, 4
  0x06029: or       ax, ax
  0x0602B: jge      0x6037
  0x0602D: push     word ptr [bp + 8]
  0x06030: push     word ptr [bp + 6]
  0x06033: push     cs
  0x06034: call     0x5f04
  0x06037: leave    
  0x06038: retf     

============================================================
func_L121 at file 0x0603A, 33 bytes
============================================================
  0x0603A: enter    4, 0
  0x0603E: push     si
  0x0603F: mov      word ptr [bp - 4], 0xffff
  0x06044: push     word ptr [bp + 8]
  0x06047: push     word ptr [bp + 6]
  0x0604A: push     cs
  0x0604B: call     0x5bfa
  0x0604E: add      sp, 4
  0x06051: or       ax, ax
  0x06053: jne      0x605c
  0x06055: mov      ax, 0xffff
  0x06058: pop      si
  0x06059: leave    
  0x0605A: retf     

============================================================
func_L122 at file 0x060A0, 198 bytes
============================================================
  0x060A0: enter    0xa, 0
  0x060A4: mov      word ptr [bp - 6], 0xffff
  0x060A9: cmp      word ptr [0x190], 0
  0x060AE: jne      0x60b3
  0x060B0: jmp      0x6183
  0x060B3: push     word ptr [bp + 8]
  0x060B6: push     word ptr [bp + 6]
  0x060B9: push     cs
  0x060BA: call     0x5f82
  0x060BD: add      sp, 4
  0x060C0: or       ax, ax
  0x060C2: jl       0x60c7
  0x060C4: jmp      0x6183
  0x060C7: push     word ptr [bp + 8]
  0x060CA: push     word ptr [bp + 6]
  0x060CD: push     cs
  0x060CE: call     0x5cfe
  0x060D1: add      sp, 4
  0x060D4: sub      ah, ah
  0x060D6: mov      word ptr [bp - 8], ax
  0x060D9: and      byte ptr [bp - 8], 0x3f
  0x060DD: cmp      word ptr [bp - 8], 8
  0x060E1: jl       0x60e9
  0x060E3: cmp      word ptr [bp - 8], 0x10
  0x060E7: jl       0x60f5
  0x060E9: cmp      word ptr [bp - 8], 0x10
  0x060ED: jl       0x60fc
  0x060EF: cmp      word ptr [bp - 8], 0x18
  0x060F3: jge      0x60fc
  0x060F5: mov      word ptr [bp - 2], 1
  0x060FA: jmp      0x6101
  0x060FC: mov      word ptr [bp - 2], 0
  0x06101: mov      al, byte ptr [bp + 6]
  0x06104: and      ax, 3  ; 25% chance
  0x06107: shl      ax, 2
  0x0610A: mov      cl, byte ptr [bp + 8]
  0x0610D: and      cx, 3
  0x06110: add      ax, cx
  0x06112: mov      cx, word ptr [bp + 8]
  0x06115: sar      cx, 2
  0x06118: mov      dx, cx
  0x0611A: shl      cx, 1
  0x0611C: add      cx, dx
  0x0611E: mov      dx, word ptr [bp + 6]
  0x06121: sar      dx, 2
  0x06124: add      cl, dl
  0x06126: sub      cl, byte ptr [bp - 2]
  0x06129: add      cl, byte ptr [0x190]
  0x0612D: and      cx, 0xf
  0x06130: cmp      cx, ax
  0x06132: je       0x613b
  0x06134: xor      cl, 0xa
  0x06137: cmp      cx, ax
  0x06139: jne      0x6183
  0x0613B: push     word ptr [bp + 8]
  0x0613E: push     word ptr [bp + 6]
  0x06141: lcall    0x3e4, 0x3a
  0x06146: add      sp, 4
  0x06149: mov      bx, ax
  0x0614B: shl      bx, 1
  0x0614D: mov      ax, word ptr [bx + 0x192]
  0x06151: mov      word ptr [bp - 6], ax
  0x06154: or       ax, ax
  0x06156: jne      0x615d
  0x06158: mov      word ptr [bp - 6], 6
  0x0615D: push     word ptr [bp + 8]
  0x06160: push     word ptr [bp + 6]
  0x06163: push     cs

============================================================
func_L123 at file 0x06188, 77 bytes
============================================================
  0x06188: enter    8, 0
  0x0618C: mov      word ptr [bp - 2], 0
  0x06191: cmp      word ptr [0x190], 0
  0x06196: je       0x61ff
  0x06198: push     word ptr [bp + 8]
  0x0619B: push     word ptr [bp + 6]
  0x0619E: lcall    0x3e4, 0x3a
  0x061A3: add      sp, 4
  0x061A6: cmp      ax, 0x19
  0x061A9: je       0x61ff
  0x061AB: cmp      ax, 0x1a
  0x061AE: je       0x61ff
  0x061B0: cmp      ax, 0x18
  0x061B3: je       0x61ff
  0x061B5: push     word ptr [bp + 8]
  0x061B8: push     word ptr [bp + 6]
  0x061BB: push     cs
  0x061BC: call     0x5df0
  0x061BF: add      sp, 4
  0x061C2: cwde     
  0x061C3: or       ax, ax
  0x061C5: jge      0x61ff
  0x061C7: mov      ax, word ptr [bp + 8]
  0x061CA: and      ax, 3  ; 25% chance
  0x061CD: mov      cx, word ptr [bp + 8]
  0x061D0: sar      cx, 2

============================================================
func_L124 at file 0x06204, 46 bytes
============================================================
  0x06204: push     bp
  0x06205: mov      bp, sp
  0x06207: mov      al, byte ptr [bp + 6]
  0x0620A: and      al, 0x1f
  0x0620C: sub      ah, ah
  0x0620E: mov      word ptr [bp + 6], ax
  0x06211: mov      ax, word ptr [0x18e]
  0x06214: jmp      0x6242
  0x06216: cmp      word ptr [bp + 6], 0x18
  0x0621A: jge      0x6249
  0x0621C: cmp      word ptr [bp + 6], 8
  0x06220: jl       0x6249
  0x06222: mov      al, byte ptr [bp + 6]
  0x06225: and      ax, 7  ; 12.5% chance
  0x06228: or       al, 8
  0x0622A: mov      word ptr [bp + 6], ax
  0x0622D: mov      al, byte ptr [bp + 6]
  0x06230: leave    
  0x06231: retf     

============================================================
func_L125 at file 0x0624E, 8 bytes
============================================================
  0x0624E: push     bp
  0x0624F: mov      bp, sp
  0x06251: mov      bx, word ptr [bp + 6]

============================================================
func_L126 at file 0x0627A, 57 bytes
============================================================
  0x0627A: push     bp
  0x0627B: mov      bp, sp
  0x0627D: push     di
  0x0627E: push     si
  0x0627F: mov      di, word ptr [bp + 8]
  0x06282: mov      si, 0x19
  0x06285: push     di
  0x06286: push     word ptr [bp + 6]
  0x06289: lcall    0x37f, 0xa
  0x0628E: add      sp, 4
  0x06291: or       ax, ax
  0x06293: je       0x62ad
  0x06295: push     di
  0x06296: push     word ptr [bp + 6]
  0x06299: lcall    0x37f, 0x10e
  0x0629E: add      sp, 4
  0x062A1: sub      ah, ah
  0x062A3: push     ax
  0x062A4: push     cs
  0x062A5: call     0x624e
  0x062A8: add      sp, 2
  0x062AB: mov      si, ax
  0x062AD: mov      ax, si
  0x062AF: pop      si
  0x062B0: pop      di
  0x062B1: leave    
  0x062B2: retf     

============================================================
func_L127 at file 0x062B4, 39 bytes
============================================================
  0x062B4: push     bp
  0x062B5: mov      bp, sp
  0x062B7: push     si
  0x062B8: push     word ptr [bp + 8]
  0x062BB: push     word ptr [bp + 6]
  0x062BE: lcall    0x37f, 0x10e
  0x062C3: add      sp, 4
  0x062C6: sub      ah, ah
  0x062C8: and      al, 0x1f
  0x062CA: mov      si, ax
  0x062CC: cmp      si, 0x19
  0x062CF: je       0x62dc
  0x062D1: cmp      si, 0x1a
  0x062D4: je       0x62dc
  0x062D6: sub      ax, ax
  0x062D8: pop      si
  0x062D9: leave    
  0x062DA: retf     

============================================================
func_L128 at file 0x062E2, 50 bytes
============================================================
  0x062E2: push     bp
  0x062E3: mov      bp, sp
  0x062E5: push     si
  0x062E6: push     word ptr [bp + 8]
  0x062E9: push     word ptr [bp + 6]
  0x062EC: lcall    0x37f, 0x10e
  0x062F1: add      sp, 4
  0x062F4: sub      ah, ah
  0x062F6: and      al, 0x1f
  0x062F8: mov      si, ax
  0x062FA: cmp      si, 8
  0x062FD: jl       0x6304
  0x062FF: cmp      si, 0x10
  0x06302: jl       0x630e
  0x06304: cmp      si, 0x10
  0x06307: jl       0x6314
  0x06309: cmp      si, 0x18
  0x0630C: jge      0x6314
  0x0630E: mov      ax, 1
  0x06311: pop      si
  0x06312: leave    
  0x06313: retf     

============================================================
func_L129 at file 0x0631A, 153 bytes
============================================================
  0x0631A: enter    2, 0
  0x0631E: push     bx
  0x0631F: push     di
  0x06320: push     si
  0x06321: mov      di, dx
  0x06323: mov      si, ax
  0x06325: push     di
  0x06326: push     si
  0x06327: lcall    0x37f, 0x2e0
  0x0632C: add      sp, 4
  0x0632F: mov      es, dx
  0x06331: mov      bx, ax
  0x06333: mov      cl, byte ptr [bp - 4]
  0x06336: add      cl, 4
  0x06339: mov      al, 1
  0x0633B: shl      al, cl
  0x0633D: or       byte ptr es:[bx], al
  0x06340: push     di
  0x06341: push     si
  0x06342: lcall    0x37f, 0x200
  0x06347: add      sp, 4
  0x0634A: or       al, al
  0x0634C: jge      0x6369
  0x0634E: push     di
  0x0634F: push     si
  0x06350: lcall    0x37f, 0x598
  0x06355: add      sp, 4
  0x06358: or       ax, ax
  0x0635A: jne      0x6369
  0x0635C: push     word ptr [bp - 4]
  0x0635F: push     di
  0x06360: push     si
  0x06361: lcall    0x37f, 0x228
  0x06366: add      sp, 6
  0x06369: mov      ax, si
  0x0636B: mov      dx, di
  0x0636D: lcall    0x427, 0x5c
  0x06372: mov      word ptr [bp - 2], ax
  0x06375: cmp      word ptr [bp + 4], 0
  0x06379: je       0x6388
  0x0637B: imul     bx, ax, 0x1c  ; *Unit
  0x0637E: mov      al, byte ptr [bx + 0x3147]
  0x06382: and      al, 0xf
  0x06384: cmp      al, 4
  0x06386: jae      0x6396
  0x06388: push     word ptr [bp - 4]
  0x0638B: push     word ptr [bp - 2]
  0x0638E: lcall    0x427, 0x9ac
  0x06393: add      sp, 4
  0x06396: push     di
  0x06397: push     si
  0x06398: lcall    0x5eb, 0xa76
  0x0639D: add      sp, 4
  0x063A0: or       ax, ax
  0x063A2: jl       0x63b0
  0x063A4: push     word ptr [bp - 4]
  0x063A7: push     ax
  0x063A8: lcall    0x181f, 0x7c8
  0x063AD: add      sp, 4
  0x063B0: pop      si
  0x063B1: pop      di
  0x063B2: leave    

============================================================
func_L130 at file 0x063B6, 31 bytes
============================================================
  0x063B6: enter    0xa, 0
  0x063BA: push     di
  0x063BB: push     si
  0x063BC: mov      si, word ptr [bp + 6]
  0x063BF: imul     bx, si, 0xca  ; *Colony
  0x063C3: mov      al, byte ptr [bx + 0x5d46]
  0x063C7: sub      ah, ah
  0x063C9: mov      word ptr [bp - 6], ax
  0x063CC: mov      cl, byte ptr [bx + 0x5d47]
  0x063D0: sub      ch, ch
  0x063D2: mov      di, cx

============================================================
func_L131 at file 0x063D5, 145 bytes
============================================================
  0x063D5: enter    0x52d, 0
  0x063D9: mov      word ptr [bp - 2], ax
  0x063DC: add      cx, 5
  0x063DF: cmp      ax, cx
  0x063E1: jg       0x6462
  0x063E3: lea      ax, [di + 5]
  0x063E6: mov      word ptr [bp - 8], ax
  0x063E9: mov      word ptr [bp - 4], di
  0x063EC: mov      si, word ptr [bp - 4]
  0x063EF: sub      si, 5
  0x063F2: cmp      si, word ptr [bp - 8]
  0x063F5: jg       0x6454
  0x063F7: mov      di, word ptr [bp + 8]
  0x063FA: push     si
  0x063FB: push     word ptr [bp - 2]
  0x063FE: lcall    0x37f, 0xa
  0x06403: add      sp, 4
  0x06406: or       ax, ax
  0x06408: je       0x644e
  0x0640A: push     si
  0x0640B: push     word ptr [bp - 2]
  0x0640E: lcall    0x37f, 0x2e0
  0x06413: add      sp, 4
  0x06416: mov      es, dx
  0x06418: mov      bx, ax
  0x0641A: lea      cx, [di + 4]
  0x0641D: mov      al, 1
  0x0641F: shl      al, cl
  0x06421: or       byte ptr es:[bx], al
  0x06424: push     si
  0x06425: push     word ptr [bp - 2]
  0x06428: lcall    0x5eb, 0xa76
  0x0642D: add      sp, 4
  0x06430: mov      word ptr [bp + 6], ax
  0x06433: or       ax, ax
  0x06435: jl       0x644e
  0x06437: imul     bx, ax, 0xca  ; *Colony
  0x0643B: add      bx, di
  0x0643D: cmp      byte ptr [bx + 0x5e00], 0
  0x06442: jne      0x644e
  0x06444: mov      byte ptr [bx + 0x5e00], 1
  0x06449: mov      byte ptr [bx + 0x5e04], 0
  0x0644E: inc      si
  0x0644F: cmp      word ptr [bp - 8], si
  0x06452: jge      0x63fa
  0x06454: mov      ax, word ptr [bp - 6]
  0x06457: add      ax, 5
  0x0645A: inc      word ptr [bp - 2]
  0x0645D: cmp      ax, word ptr [bp - 2]
  0x06460: jge      0x63ec
  0x06462: pop      si
  0x06463: pop      di
  0x06464: leave    
  0x06465: retf     

============================================================
func_L132 at file 0x06468, 79 bytes
============================================================
  0x06468: enter    0xc, 0
  0x0646C: push     bx
  0x0646D: push     dx
  0x0646E: push     ax
  0x0646F: push     di
  0x06470: push     si
  0x06471: mov      si, ax
  0x06473: mov      di, dx
  0x06475: push     di
  0x06476: push     si
  0x06477: lcall    0x37f, 0xa
  0x0647C: add      sp, 4
  0x0647F: or       ax, ax
  0x06481: jne      0x6486
  0x06483: jmp      0x65bd
  0x06486: cmp      word ptr [bp - 0xe], 4
  0x0648A: jl       0x648f
  0x0648C: jmp      0x65bd
  0x0648F: push     di
  0x06490: push     si
  0x06491: lcall    0x37f, 0x2a0
  0x06496: add      sp, 4
  0x06499: mov      word ptr [bp - 0xc], ax
  0x0649C: mov      ax, word ptr [bp + 6]
  0x0649F: neg      ax
  0x064A1: mov      word ptr [bp - 8], ax
  0x064A4: cmp      ax, word ptr [bp + 6]
  0x064A7: jle      0x64ac
  0x064A9: jmp      0x65bd
  0x064AC: mov      word ptr [bp - 0x12], si
  0x064AF: mov      word ptr [bp - 0x10], di
  0x064B2: mov      bx, word ptr [bp + 6]
  0x064B5: mov      ax, bx

============================================================
func_L133 at file 0x065C4, 67 bytes
============================================================
  0x065C4: enter    2, 0
  0x065C8: push     di
  0x065C9: push     si
  0x065CA: mov      si, ax
  0x065CC: imul     bx, si, 0x1c  ; *Unit
  0x065CF: mov      word ptr [bp - 2], bx
  0x065D2: cmp      byte ptr [bx + 0x3146], 0xd
  0x065D7: jb       0x65e6
  0x065D9: cmp      byte ptr [bx + 0x3146], 0x12
  0x065DE: ja       0x65e6
  0x065E0: mov      di, 1
  0x065E3: jmp      0x65e8
  0x065E5: nop      
  0x065E6: sub      di, di
  0x065E8: push     dx
  0x065E9: push     di
  0x065EA: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x065EE: sub      ah, ah
  0x065F0: mov      bl, byte ptr [bx + 0x3147]
  0x065F4: and      bx, 0xf
  0x065F7: mov      si, word ptr [bp - 2]
  0x065FA: mov      dl, byte ptr [si + 0x3145]
  0x065FE: sub      dh, dh
  0x06600: call     0x6468
  0x06603: pop      si
  0x06604: pop      di
  0x06605: leave    
  0x06606: retf     

============================================================
func_L134 at file 0x06608, 106 bytes
============================================================
  0x06608: enter    2, 0
  0x0660C: push     di
  0x0660D: push     si
  0x0660E: mov      si, ax
  0x06610: mov      di, 1
  0x06613: imul     bx, si, 0x1c  ; *Unit
  0x06616: mov      word ptr [bp - 2], bx
  0x06619: cmp      byte ptr [bx + 0x3146], 0xf
  0x0661E: je       0x662e
  0x06620: cmp      byte ptr [bx + 0x3146], 0x10
  0x06625: je       0x662e
  0x06627: cmp      byte ptr [bx + 0x3146], 0x11
  0x0662C: jne      0x6631
  0x0662E: mov      di, 2
  0x06631: push     7
  0x06633: mov      al, byte ptr [bx + 0x3147]
  0x06637: and      ax, 0xf  ; 6.25% chance
  0x0663A: push     ax
  0x0663B: lcall    0x981, 0
  0x06640: add      sp, 4
  0x06643: or       ax, ax
  0x06645: je       0x665b
  0x06647: mov      bx, word ptr [bp - 2]
  0x0664A: cmp      byte ptr [bx + 0x3146], 0xd
  0x0664F: jb       0x6658
  0x06651: cmp      byte ptr [bx + 0x3146], 0x12
  0x06656: jbe      0x665b
  0x06658: mov      di, 2
  0x0665B: mov      bx, word ptr [bp - 2]
  0x0665E: cmp      byte ptr [bx + 0x3146], 5
  0x06663: jne      0x6666
  0x06665: inc      di
  0x06666: mov      ax, si
  0x06668: mov      dx, di
  0x0666A: push     cs
  0x0666B: call     0x65c4
  0x0666E: pop      si
  0x0666F: pop      di
  0x06670: leave    
  0x06671: retf     

============================================================
func_L135 at file 0x066CC, 57 bytes
============================================================
  0x066CC: enter    6, 0
  0x066D0: push     dx
  0x066D1: push     ax
  0x066D2: push     di
  0x066D3: push     si
  0x066D4: mov      di, dx
  0x066D6: mov      si, ax
  0x066D8: mov      word ptr [bp - 4], 0xffff
  0x066DD: push     di
  0x066DE: push     si
  0x066DF: lcall    0x37f, 0xa
  0x066E4: add      sp, 4
  0x066E7: mov      word ptr [bp - 6], ax
  0x066EA: or       ax, ax
  0x066EC: je       0x6706
  0x066EE: push     di
  0x066EF: push     si
  0x066F0: lcall    0x37f, 0x314
  0x066F5: add      sp, 4
  0x066F8: or       ax, ax
  0x066FA: jge      0x6706
  0x066FC: mov      di, word ptr [bp - 4]
  0x066FF: mov      ax, di
  0x06701: pop      si
  0x06702: pop      di
  0x06703: leave    
  0x06704: retf     

============================================================
func_L136 at file 0x0679E, 16 bytes
============================================================
  0x0679E: enter    2, 0
  0x067A2: push     dx
  0x067A3: push     di
  0x067A4: push     si
  0x067A5: mov      di, 0xffff
  0x067A8: mov      word ptr [bp - 2], di
  0x067AB: push     cs

============================================================
func_L137 at file 0x067F0, 44 bytes
============================================================
  0x067F0: enter    4, 0
  0x067F4: push     dx
  0x067F5: push     di
  0x067F6: push     si
  0x067F7: mov      cx, ax
  0x067F9: mov      ax, 0xffff
  0x067FC: mov      word ptr [bp - 2], ax
  0x067FF: mov      word ptr [bp - 4], ax
  0x06802: mov      ax, cx
  0x06804: push     cs
  0x06805: call     0x6672
  0x06808: mov      si, ax
  0x0680A: mov      di, word ptr [bp - 4]
  0x0680D: or       si, si
  0x0680F: jl       0x6846
  0x06811: imul     bx, si, 0x1c  ; *Unit
  0x06814: mov      bl, byte ptr [bx + 0x3146]
  0x06818: sub      bh, bh
  0x0681A: mov      ax, bx

============================================================
func_L138 at file 0x0684C, 39 bytes
============================================================
  0x0684C: push     bp
  0x0684D: mov      bp, sp
  0x0684F: push     di
  0x06850: push     si
  0x06851: mov      si, word ptr [bp + 6]
  0x06854: sub      di, di
  0x06856: mov      ax, si
  0x06858: push     cs
  0x06859: call     0x6672
  0x0685C: mov      si, ax
  0x0685E: or       si, si
  0x06860: jl       0x686d
  0x06862: inc      di
  0x06863: push     cs
  0x06864: call     0x66ba
  0x06867: mov      si, ax
  0x06869: or       si, si
  0x0686B: jge      0x6862
  0x0686D: mov      ax, di
  0x0686F: pop      si
  0x06870: pop      di
  0x06871: leave    
  0x06872: retf     

============================================================
func_L139 at file 0x06874, 53 bytes
============================================================
  0x06874: push     bp
  0x06875: mov      bp, sp
  0x06877: push     di
  0x06878: push     si
  0x06879: mov      si, word ptr [bp + 6]
  0x0687C: sub      di, di
  0x0687E: mov      ax, si
  0x06880: push     cs
  0x06881: call     0x6672
  0x06884: mov      si, ax
  0x06886: or       si, si
  0x06888: jl       0x68a3
  0x0688A: mov      al, byte ptr [bp + 8]
  0x0688D: imul     bx, si, 0x1c  ; *Unit
  0x06890: cmp      byte ptr [bx + 0x3146], al
  0x06894: jne      0x6897
  0x06896: inc      di
  0x06897: mov      ax, si
  0x06899: push     cs
  0x0689A: call     0x66ba
  0x0689D: mov      si, ax
  0x0689F: or       si, si
  0x068A1: jge      0x688a
  0x068A3: mov      ax, di
  0x068A5: pop      si
  0x068A6: pop      di
  0x068A7: leave    
  0x068A8: retf     

============================================================
func_L140 at file 0x068AA, 143 bytes
============================================================
  0x068AA: enter    2, 0
  0x068AE: push     di
  0x068AF: push     si
  0x068B0: mov      si, ax
  0x068B2: sub      bx, bx
  0x068B4: imul     di, si, 0x1c  ; *Unit
  0x068B7: mov      word ptr [bp - 2], di
  0x068BA: cmp      word ptr [di + 0x315c], bx
  0x068BE: jl       0x68d2
  0x068C0: mov      bx, di
  0x068C2: mov      ax, word ptr [bx + 0x315e]
  0x068C6: imul     bx, word ptr [bx + 0x315c], 0x1c  ; *Unit
  0x068CB: mov      word ptr [bx + 0x315e], ax
  0x068CF: mov      bx, 1
  0x068D2: mov      di, word ptr [bp - 2]
  0x068D5: cmp      word ptr [di + 0x315e], 0
  0x068DA: jl       0x68ee
  0x068DC: mov      bx, di
  0x068DE: mov      ax, word ptr [bx + 0x315c]
  0x068E2: imul     bx, word ptr [bx + 0x315e], 0x1c  ; *Unit
  0x068E7: mov      word ptr [bx + 0x315c], ax
  0x068EB: mov      bx, 1
  0x068EE: or       bx, bx
  0x068F0: jne      0x6928
  0x068F2: mov      bx, word ptr [bp - 2]
  0x068F5: mov      al, byte ptr [bx + 0x3145]
  0x068F9: sub      ah, ah
  0x068FB: push     ax
  0x068FC: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x06900: push     ax
  0x06901: lcall    0x37f, 0xa
  0x06906: add      sp, 4
  0x06909: or       ax, ax
  0x0690B: je       0x6928
  0x0690D: push     0
  0x0690F: push     1
  0x06911: mov      bx, word ptr [bp - 2]
  0x06914: mov      al, byte ptr [bx + 0x3145]
  0x06918: sub      ah, ah
  0x0691A: push     ax
  0x0691B: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x0691F: push     ax
  0x06920: lcall    0x37f, 0x15e
  0x06925: add      sp, 8
  0x06928: mov      al, 0xff
  0x0692A: mov      bx, word ptr [bp - 2]
  0x0692D: mov      byte ptr [bx + 0x3144], al  ; unit_table
  0x06931: mov      byte ptr [bx + 0x3145], al
  0x06935: pop      si
  0x06936: pop      di
  0x06937: leave    
  0x06938: retf     

============================================================
func_L141 at file 0x0693A, 68 bytes
============================================================
  0x0693A: enter    2, 0
  0x0693E: push     dx
  0x0693F: push     ax
  0x06940: push     di
  0x06941: push     si
  0x06942: mov      di, bx
  0x06944: mov      ax, dx
  0x06946: mov      dx, di
  0x06948: push     cs
  0x06949: call     0x66cc
  0x0694C: mov      si, ax
  0x0694E: mov      al, byte ptr [bp - 4]
  0x06951: imul     bx, word ptr [bp - 6], 0x1c  ; *Unit
  0x06955: mov      word ptr [bp - 2], bx
  0x06958: mov      byte ptr [bx + 0x3144], al  ; unit_table
  0x0695C: mov      ax, di
  0x0695E: mov      byte ptr [bx + 0x3145], al
  0x06962: mov      word ptr [bx + 0x315c], 0xffff
  0x06968: mov      word ptr [bx + 0x315e], si
  0x0696C: or       si, si
  0x0696E: jl       0x697e
  0x06970: mov      ax, word ptr [bp - 6]
  0x06973: imul     bx, si, 0x1c  ; *Unit
  0x06976: mov      word ptr [bx + 0x315c], ax
  0x0697A: pop      si
  0x0697B: pop      di
  0x0697C: leave    
  0x0697D: retf     

============================================================
func_L142 at file 0x069D2, 12 bytes
============================================================
  0x069D2: push     bp
  0x069D3: mov      bp, sp
  0x069D5: push     si
  0x069D6: mov      si, word ptr [bp + 6]
  0x069D9: mov      ax, si
  0x069DB: push     cs

============================================================
func_L143 at file 0x069EE, 33 bytes
============================================================
  0x069EE: push     bp
  0x069EF: mov      bp, sp
  0x069F1: push     si
  0x069F2: mov      si, word ptr [bp + 6]
  0x069F5: imul     bx, si, 0x1c  ; *Unit
  0x069F8: mov      al, byte ptr [bx + 0x3145]
  0x069FC: sub      ah, ah
  0x069FE: push     ax
  0x069FF: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x06A03: push     ax
  0x06A04: push     si
  0x06A05: push     cs
  0x06A06: call     0x69d2
  0x06A09: add      sp, 6
  0x06A0C: pop      si
  0x06A0D: leave    
  0x06A0E: retf     

============================================================
func_L144 at file 0x06A10, 108 bytes
============================================================
  0x06A10: enter    6, 0
  0x06A14: push     di
  0x06A15: push     si
  0x06A16: mov      si, word ptr [bp + 6]
  0x06A19: imul     bx, si, 0x1c  ; *Unit
  0x06A1C: mov      word ptr [bp - 6], bx
  0x06A1F: cmp      word ptr [bx + 0x315e], 0
  0x06A24: jl       0x6a78
  0x06A26: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x06A2A: sub      ah, ah
  0x06A2C: mov      word ptr [bp - 2], ax
  0x06A2F: mov      al, byte ptr [bx + 0x3145]
  0x06A33: mov      word ptr [bp - 4], ax
  0x06A36: mov      ax, si
  0x06A38: push     cs
  0x06A39: call     0x6672
  0x06A3C: mov      di, ax
  0x06A3E: cmp      di, si
  0x06A40: jne      0x6a4a
  0x06A42: mov      ax, si
  0x06A44: push     cs
  0x06A45: call     0x66ba
  0x06A48: mov      di, ax
  0x06A4A: mov      ax, si
  0x06A4C: push     cs
  0x06A4D: call     0x68aa
  0x06A50: mov      ax, di
  0x06A52: push     cs
  0x06A53: call     0x6696
  0x06A56: imul     bx, ax, 0x1c  ; *Unit
  0x06A59: mov      word ptr [bx + 0x315e], si
  0x06A5D: mov      bx, word ptr [bp - 6]
  0x06A60: mov      word ptr [bx + 0x315c], ax
  0x06A64: mov      word ptr [bx + 0x315e], 0xffff
  0x06A6A: mov      al, byte ptr [bp - 2]
  0x06A6D: mov      byte ptr [bx + 0x3144], al  ; unit_table
  0x06A71: mov      al, byte ptr [bp - 4]
  0x06A74: mov      byte ptr [bx + 0x3145], al
  0x06A78: pop      si
  0x06A79: pop      di
  0x06A7A: leave    
  0x06A7B: retf     

============================================================
func_L145 at file 0x06A7C, 50 bytes
============================================================
  0x06A7C: push     bp
  0x06A7D: mov      bp, sp
  0x06A7F: push     di
  0x06A80: push     si
  0x06A81: mov      ax, word ptr [bp + 6]
  0x06A84: push     cs
  0x06A85: call     0x6672
  0x06A88: mov      si, ax
  0x06A8A: or       si, si
  0x06A8C: jl       0x6aaa
  0x06A8E: mov      ax, si
  0x06A90: push     cs
  0x06A91: call     0x66ba
  0x06A94: mov      di, ax
  0x06A96: push     word ptr [bp + 0xa]
  0x06A99: push     word ptr [bp + 8]
  0x06A9C: push     si
  0x06A9D: push     cs
  0x06A9E: call     0x69d2
  0x06AA1: add      sp, 6
  0x06AA4: mov      si, di
  0x06AA6: or       si, si
  0x06AA8: jge      0x6a8e
  0x06AAA: pop      si
  0x06AAB: pop      di
  0x06AAC: leave    
  0x06AAD: retf     

============================================================
func_L146 at file 0x06AAE, 103 bytes
============================================================
  0x06AAE: enter    2, 0
  0x06AB2: push     si
  0x06AB3: mov      si, word ptr [bp + 8]
  0x06AB6: or       si, si
  0x06AB8: jl       0x6ade
  0x06ABA: cmp      word ptr [bp + 6], si
  0x06ABD: jne      0x6ad2
  0x06ABF: lea      ax, [bp + 8]
  0x06AC2: push     ax
  0x06AC3: lea      ax, [bp + 6]
  0x06AC6: push     ax
  0x06AC7: lcall    0x24c, 0x2a
  0x06ACC: add      sp, 4
  0x06ACF: mov      si, 0xffff
  0x06AD2: mov      ax, si
  0x06AD4: push     cs
  0x06AD5: call     0x66ba
  0x06AD8: mov      si, ax
  0x06ADA: or       si, si
  0x06ADC: jge      0x6aba
  0x06ADE: mov      ax, word ptr [bp + 8]
  0x06AE1: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x06AE5: mov      word ptr [bp - 2], bx
  0x06AE8: cmp      word ptr [bx + 0x315e], ax
  0x06AEC: jne      0x6b16
  0x06AEE: imul     bx, ax, 0x1c  ; *Unit
  0x06AF1: mov      ax, word ptr [bx + 0x315e]
  0x06AF5: mov      si, word ptr [bp - 2]
  0x06AF8: mov      word ptr [si + 0x315e], ax
  0x06AFC: mov      ax, word ptr [si + 0x315c]
  0x06B00: mov      word ptr [bx + 0x315c], ax
  0x06B04: mov      ax, word ptr [bp + 6]
  0x06B07: mov      word ptr [bx + 0x315e], ax
  0x06B0B: mov      ax, word ptr [bp + 8]
  0x06B0E: mov      word ptr [si + 0x315c], ax
  0x06B12: pop      si
  0x06B13: leave    
  0x06B14: retf     

============================================================
func_L147 at file 0x06B46, 71 bytes
============================================================
  0x06B46: enter    0xc, 0
  0x06B4A: push     di
  0x06B4B: push     si
  0x06B4C: mov      si, word ptr [bp + 6]
  0x06B4F: mov      word ptr [bp - 8], 0xffff
  0x06B54: or       si, si
  0x06B56: jge      0x6b5b
  0x06B58: jmp      0x6caf
  0x06B5B: imul     bx, si, 0x1c  ; *Unit
  0x06B5E: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x06B62: sub      ah, ah
  0x06B64: mov      word ptr [bp - 0xc], ax
  0x06B67: mov      al, byte ptr [bx + 0x3145]
  0x06B6B: mov      word ptr [bp - 0xa], ax
  0x06B6E: mov      ax, si
  0x06B70: push     cs
  0x06B71: call     0x6672
  0x06B74: mov      si, ax
  0x06B76: or       si, si
  0x06B78: jl       0x6bb3
  0x06B7A: mov      ax, si
  0x06B7C: push     cs
  0x06B7D: call     0x66ba
  0x06B80: mov      di, ax
  0x06B82: imul     bx, si, 0x1c  ; *Unit
  0x06B85: mov      bl, byte ptr [bx + 0x3146]
  0x06B89: sub      bh, bh
  0x06B8B: mov      ax, bx

============================================================
func_L148 at file 0x06CCA, 13 bytes
============================================================
  0x06CCA: enter    4, 0
  0x06CCE: push     si
  0x06CCF: mov      si, word ptr [bp + 6]
  0x06CD2: imul     bx, si, 0x1c  ; *Unit
  0x06CD5: mov      ax, bx

============================================================
func_L149 at file 0x06D24, 197 bytes
============================================================
  0x06D24: enter    4, 0
  0x06D28: push     di
  0x06D29: push     si
  0x06D2A: mov      di, word ptr [bp + 8]
  0x06D2D: mov      si, 0xffff
  0x06D30: cmp      di, 4
  0x06D33: jge      0x6d3f
  0x06D35: imul     bx, di, 0x34  ; *AI
  0x06D38: cmp      byte ptr [bx + 0x543f], 0  ; ai_pers
  0x06D3D: je       0x6d4a
  0x06D3F: cmp      word ptr [0x539c], 0x124  ; score
  0x06D45: jl       0x6d4a
  0x06D47: jmp      0x6e8e
  0x06D4A: cmp      word ptr [0x539c], 0x12c  ; score
  0x06D50: jl       0x6d55
  0x06D52: jmp      0x6e76
  0x06D55: cmp      di, 4
  0x06D58: jge      0x6d64
  0x06D5A: cmp      byte ptr [di - 0x7304], 0xc8
  0x06D5F: jbe      0x6d64
  0x06D61: jmp      0x6e76
  0x06D64: mov      si, word ptr [0x539c]  ; score
  0x06D68: inc      word ptr [0x539c]  ; score
  0x06D6C: mov      al, byte ptr [bp + 6]
  0x06D6F: imul     bx, si, 0x1c  ; *Unit
  0x06D72: mov      word ptr [bp - 4], bx
  0x06D75: mov      byte ptr [bx + 0x3146], al
  0x06D79: mov      ax, di
  0x06D7B: mov      byte ptr [bx + 0x3147], al
  0x06D7F: mov      byte ptr [bx + 0x3149], 0
  0x06D84: mov      byte ptr [bx + 0x314b], 0x58
  0x06D89: sub      al, al
  0x06D8B: mov      byte ptr [bx + 0x3148], al
  0x06D8F: mov      byte ptr [bx + 0x314c], al
  0x06D93: mov      byte ptr [bx + 0x3150], al
  0x06D97: mov      byte ptr [bx + 0x315a], al
  0x06D9B: mov      byte ptr [bx + 0x3154], al
  0x06D9F: mov      byte ptr [bx + 0x3155], al
  0x06DA3: mov      byte ptr [bx + 0x3156], 0xff
  0x06DA8: cmp      di, 4
  0x06DAB: jl       0x6db7
  0x06DAD: mov      ax, word ptr [0x538e]  ; unk_thresh
  0x06DB0: mov      bx, word ptr [bp - 4]
  0x06DB3: mov      word ptr [bx + 0x3156], ax
  0x06DB7: mov      bx, word ptr [bp - 4]
  0x06DBA: mov      byte ptr [bx + 0x314a], 0xff
  0x06DBF: push     word ptr [bp + 0xc]
  0x06DC2: push     word ptr [bp + 0xa]
  0x06DC5: lcall    0x5eb, 0xa76
  0x06DCA: add      sp, 4
  0x06DCD: mov      word ptr [bp - 2], ax
  0x06DD0: or       ax, ax
  0x06DD2: jl       0x6dde
  0x06DD4: mov      al, byte ptr [bp - 2]
  0x06DD7: mov      bx, word ptr [bp - 4]
  0x06DDA: mov      byte ptr [bx + 0x314a], al
  0x06DDE: mov      bx, word ptr [bp - 4]
  0x06DE1: mov      bl, byte ptr [bx + 0x3146]
  0x06DE5: sub      bh, bh
  0x06DE7: mov      ax, bx

============================================================
func_L150 at file 0x06E94, 141 bytes
============================================================
  0x06E94: enter    8, 0
  0x06E98: push     di
  0x06E99: push     si
  0x06E9A: mov      di, word ptr [bp + 6]
  0x06E9D: or       di, di
  0x06E9F: jge      0x6ea4
  0x06EA1: jmp      0x6f56
  0x06EA4: imul     bx, di, 0x1c  ; *Unit
  0x06EA7: mov      word ptr [bp - 8], bx
  0x06EAA: mov      bl, byte ptr [bx + 0x3147]
  0x06EAE: and      bx, 0xf
  0x06EB1: jl       0x6ec3
  0x06EB3: cmp      bx, 4
  0x06EB6: jge      0x6ec3
  0x06EB8: cmp      byte ptr [bx - 0x7304], 0
  0x06EBD: je       0x6ec3
  0x06EBF: dec      byte ptr [bx - 0x7304]
  0x06EC3: cmp      bx, 4
  0x06EC6: jl       0x6edf
  0x06EC8: mov      bx, word ptr [bp - 8]
  0x06ECB: cmp      byte ptr [bx + 0x314a], 0
  0x06ED0: jl       0x6edf
  0x06ED2: mov      al, byte ptr [bx + 0x314a]
  0x06ED6: cwde     
  0x06ED7: imul     bx, ax, 0x12  ; *TradeRoute
  0x06EDA: or       byte ptr [bx + 0x54ef], 1
  0x06EDF: mov      ax, di
  0x06EE1: push     cs
  0x06EE2: call     0x68aa
  0x06EE5: mov      si, di
  0x06EE7: mov      ax, word ptr [0x539c]  ; score
  0x06EEA: dec      ax
  0x06EEB: cmp      ax, di
  0x06EED: jle      0x6f1f
  0x06EEF: imul     ax, si, 0x1c  ; *Unit
  0x06EF2: add      ax, 0x3144  ; unit_table
  0x06EF5: mov      word ptr [bp - 2], ax
  0x06EF8: mov      ax, word ptr [0x539c]  ; score
  0x06EFB: sub      ax, si
  0x06EFD: dec      ax
  0x06EFE: mov      word ptr [bp - 4], ax
  0x06F01: mov      dx, word ptr [bp - 2]
  0x06F04: mov      bx, dx
  0x06F06: mov      di, dx
  0x06F08: lea      si, [bx + 0x1c]
  0x06F0B: mov      ax, ds
  0x06F0D: mov      es, ax
  0x06F0F: mov      cx, 0xe
  0x06F12: rep movsw word ptr es:[di], word ptr [si]
  0x06F14: add      dx, 0x1c
  0x06F17: dec      word ptr [bp - 4]
  0x06F1A: jne      0x6f04
  0x06F1C: mov      di, word ptr [bp + 6]
  0x06F1F: sub      cx, cx

============================================================
func_L151 at file 0x06F5A, 105 bytes
============================================================
  0x06F5A: enter    2, 0
  0x06F5E: push     di
  0x06F5F: push     si
  0x06F60: mov      si, word ptr [bp + 6]
  0x06F63: or       si, si
  0x06F65: jl       0x6fbb
  0x06F67: imul     bx, si, 0x1c  ; *Unit
  0x06F6A: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x06F6E: sub      ah, ah
  0x06F70: mov      di, ax
  0x06F72: mov      cl, byte ptr [bx + 0x3145]
  0x06F76: sub      ch, ch
  0x06F78: mov      word ptr [bp - 2], cx
  0x06F7B: push     cx
  0x06F7C: push     ax
  0x06F7D: push     si
  0x06F7E: push     cs
  0x06F7F: call     0x69d2
  0x06F82: add      sp, 6
  0x06F85: mov      ax, si
  0x06F87: lcall    0x3f1, 0x2f8
  0x06F8C: push     0
  0x06F8E: push     word ptr [bp - 2]
  0x06F91: push     di
  0x06F92: push     word ptr [bp - 2]
  0x06F95: push     di
  0x06F96: lcall    0x984, 0x2fc
  0x06F9B: add      sp, 0xa
  0x06F9E: or       ax, ax
  0x06FA0: jne      0x6fbb
  0x06FA2: push     1
  0x06FA4: push     7
  0x06FA6: push     7
  0x06FA8: mov      ax, word ptr [bp - 2]
  0x06FAB: sub      ax, 3
  0x06FAE: push     ax
  0x06FAF: lea      ax, [di - 3]
  0x06FB2: push     ax
  0x06FB3: lcall    0x181f, 0x9ba
  0x06FB8: add      sp, 0xa
  0x06FBB: mov      word ptr [0x5392], si
  0x06FBF: pop      si
  0x06FC0: pop      di
  0x06FC1: leave    
  0x06FC2: retf     

============================================================
func_L152 at file 0x06FC4, 20 bytes
============================================================
  0x06FC4: push     bp
  0x06FC5: mov      bp, sp
  0x06FC7: mov      bx, word ptr [bp + 6]
  0x06FCA: or       bx, bx
  0x06FCC: jl       0x6fd6
  0x06FCE: imul     bx, bx, 0x1c  ; *Unit
  0x06FD1: and      byte ptr [bx + 0x3147], 0xf
  0x06FD6: leave    
  0x06FD7: retf     

============================================================
func_L153 at file 0x06FD8, 42 bytes
============================================================
  0x06FD8: push     bp
  0x06FD9: mov      bp, sp
  0x06FDB: push     si
  0x06FDC: mov      si, word ptr [bp + 6]
  0x06FDF: mov      ax, si
  0x06FE1: push     cs
  0x06FE2: call     0x6672
  0x06FE5: mov      si, ax
  0x06FE7: or       si, si
  0x06FE9: jl       0x6fff
  0x06FEB: push     si
  0x06FEC: push     cs
  0x06FED: call     0x6fc4
  0x06FF0: add      sp, 2
  0x06FF3: mov      ax, si
  0x06FF5: push     cs
  0x06FF6: call     0x66ba
  0x06FF9: mov      si, ax
  0x06FFB: or       si, si
  0x06FFD: jge      0x6feb
  0x06FFF: pop      si
  0x07000: leave    
  0x07001: retf     

============================================================
func_L154 at file 0x07002, 26 bytes
============================================================
  0x07002: push     bp
  0x07003: mov      bp, sp
  0x07005: mov      bx, word ptr [bp + 6]
  0x07008: or       bx, bx
  0x0700A: jl       0x701a
  0x0700C: mov      cl, byte ptr [bp + 8]
  0x0700F: mov      al, 0x10
  0x07011: shl      al, cl
  0x07013: imul     bx, bx, 0x1c  ; *Unit
  0x07016: or       byte ptr [bx + 0x3147], al
  0x0701A: leave    
  0x0701B: retf     

============================================================
func_L155 at file 0x0701C, 48 bytes
============================================================
  0x0701C: push     bp
  0x0701D: mov      bp, sp
  0x0701F: push     di
  0x07020: push     si
  0x07021: mov      si, word ptr [bp + 6]
  0x07024: mov      ax, si
  0x07026: push     cs
  0x07027: call     0x6672
  0x0702A: mov      si, ax
  0x0702C: or       si, si
  0x0702E: jl       0x7048
  0x07030: mov      di, word ptr [bp + 8]
  0x07033: push     di
  0x07034: push     si
  0x07035: push     cs
  0x07036: call     0x7002
  0x07039: add      sp, 4
  0x0703C: mov      ax, si
  0x0703E: push     cs
  0x0703F: call     0x66ba
  0x07042: mov      si, ax
  0x07044: or       si, si
  0x07046: jge      0x7033
  0x07048: pop      si
  0x07049: pop      di
  0x0704A: leave    
  0x0704B: retf     

============================================================
func_L156 at file 0x0704C, 205 bytes
============================================================
  0x0704C: enter    0xa, 0
  0x07050: push     di
  0x07051: push     si
  0x07052: mov      si, word ptr [bp + 6]
  0x07055: mov      di, word ptr [bp + 8]
  0x07058: push     di
  0x07059: push     si
  0x0705A: lcall    0x3e4, 0x74
  0x0705F: add      sp, 4
  0x07062: mov      word ptr [bp - 6], ax
  0x07065: push     di
  0x07066: push     si
  0x07067: lcall    0x37f, 0x3e4
  0x0706C: add      sp, 4
  0x0706F: or       ax, ax
  0x07071: jl       0x7078
  0x07073: mov      ax, 1
  0x07076: jmp      0x707a
  0x07078: sub      ax, ax
  0x0707A: mov      word ptr [bp - 8], ax
  0x0707D: mov      word ptr [0x8cfa], 0xffff
  0x07083: mov      word ptr [bp - 4], 0
  0x07088: cmp      word ptr [bp - 4], 8
  0x0708C: jge      0x710b
  0x0708E: mov      bx, word ptr [bp - 4]
  0x07091: mov      al, byte ptr [bx + 0xb4]
  0x07095: cwde     
  0x07096: mov      si, ax
  0x07098: add      si, word ptr [bp + 6]
  0x0709B: mov      al, byte ptr [bx + 0xbe]
  0x0709F: cwde     
  0x070A0: mov      di, ax
  0x070A2: add      di, word ptr [bp + 8]
  0x070A5: cmp      word ptr [bp - 8], 0
  0x070A9: je       0x70b2
  0x070AB: mov      ax, word ptr [bp - 6]
  0x070AE: jmp      0x70bc
  0x070B0: nop      
  0x070B1: nop      
  0x070B2: push     di
  0x070B3: push     si
  0x070B4: lcall    0x3e4, 0x74
  0x070B9: add      sp, 4
  0x070BC: mov      word ptr [bp - 2], ax
  0x070BF: push     di
  0x070C0: push     si
  0x070C1: lcall    0x37f, 0x3e4
  0x070C6: add      sp, 4
  0x070C9: mov      word ptr [bp - 0xa], ax
  0x070CC: or       ax, ax
  0x070CE: jge      0x70e0
  0x070D0: push     di
  0x070D1: push     si
  0x070D2: lcall    0x37f, 0x314
  0x070D7: add      sp, 4
  0x070DA: mov      word ptr [bp - 0xa], ax
  0x070DD: jmp      0x70e6
  0x070DF: nop      
  0x070E0: mov      ax, word ptr [bp - 2]
  0x070E3: mov      word ptr [bp - 6], ax
  0x070E6: mov      dx, word ptr [bp - 0xa]
  0x070E9: or       dx, dx
  0x070EB: jl       0x70fe
  0x070ED: cmp      word ptr [bp + 0xa], dx
  0x070F0: je       0x70fe
  0x070F2: mov      ax, word ptr [bp - 6]
  0x070F5: cmp      word ptr [bp - 2], ax
  0x070F8: jne      0x70fe
  0x070FA: mov      word ptr [0x8cfa], dx
  0x070FE: inc      word ptr [bp - 4]
  0x07101: cmp      word ptr [0x8cfa], 0
  0x07106: jge      0x710b
  0x07108: jmp      0x7088
  0x0710B: cmp      word ptr [0x8cfa], 0
  0x07110: jl       0x711a
  0x07112: mov      ax, 1
  0x07115: pop      si
  0x07116: pop      di
  0x07117: leave    
  0x07118: retf     

============================================================
func_L157 at file 0x07120, 81 bytes
============================================================
  0x07120: push     bp
  0x07121: mov      bp, sp
  0x07123: push     di
  0x07124: push     si
  0x07125: mov      word ptr [0x8cfa], 0xffff
  0x0712B: sub      si, si
  0x0712D: cmp      si, 8
  0x07130: jge      0x7163
  0x07132: mov      al, byte ptr [si + 0xbe]
  0x07136: cwde     
  0x07137: add      ax, word ptr [bp + 8]
  0x0713A: push     ax
  0x0713B: mov      al, byte ptr [si + 0xb4]
  0x0713F: cwde     
  0x07140: add      ax, word ptr [bp + 6]
  0x07143: push     ax
  0x07144: lcall    0x37f, 0x314
  0x07149: add      sp, 4
  0x0714C: mov      di, ax
  0x0714E: or       di, di
  0x07150: jl       0x715b
  0x07152: cmp      word ptr [bp + 0xa], di
  0x07155: je       0x715b
  0x07157: mov      word ptr [0x8cfa], di
  0x0715B: inc      si
  0x0715C: cmp      word ptr [0x8cfa], 0
  0x07161: jl       0x712d
  0x07163: cmp      word ptr [0x8cfa], 0
  0x07168: jl       0x7172
  0x0716A: mov      ax, 1
  0x0716D: pop      si
  0x0716E: pop      di
  0x0716F: leave    
  0x07170: retf     

============================================================
func_L158 at file 0x07178, 192 bytes
============================================================
  0x07178: enter    6, 0
  0x0717C: push     di
  0x0717D: push     si
  0x0717E: mov      word ptr [0x8cfa], 0xffff
  0x07184: push     word ptr [bp + 8]
  0x07187: push     word ptr [bp + 6]
  0x0718A: lcall    0x3e4, 0x74
  0x0718F: add      sp, 4
  0x07192: mov      word ptr [bp - 6], ax
  0x07195: sub      si, si
  0x07197: cmp      word ptr [0x8cfa], si
  0x0719B: jl       0x71a0
  0x0719D: jmp      0x722a
  0x071A0: cmp      si, 8
  0x071A3: jl       0x71a8
  0x071A5: jmp      0x722a
  0x071A8: mov      al, byte ptr [si + 0xbe]
  0x071AC: cwde     
  0x071AD: add      ax, word ptr [bp + 8]
  0x071B0: mov      di, ax
  0x071B2: push     ax
  0x071B3: mov      al, byte ptr [si + 0xb4]
  0x071B7: cwde     
  0x071B8: add      ax, word ptr [bp + 6]
  0x071BB: mov      word ptr [bp - 2], ax
  0x071BE: push     ax
  0x071BF: lcall    0x37f, 0x314
  0x071C4: add      sp, 4
  0x071C7: mov      word ptr [bp - 4], ax
  0x071CA: or       ax, ax
  0x071CC: jl       0x71ed
  0x071CE: mov      ax, word ptr [bp + 0xa]
  0x071D1: cmp      word ptr [bp - 4], ax
  0x071D4: je       0x71ed
  0x071D6: push     di
  0x071D7: push     word ptr [bp - 2]
  0x071DA: lcall    0x3e4, 0x74
  0x071DF: add      sp, 4
  0x071E2: cmp      ax, word ptr [bp - 6]
  0x071E5: jne      0x71ed
  0x071E7: mov      ax, word ptr [bp - 4]
  0x071EA: mov      word ptr [0x8cfa], ax
  0x071ED: push     di
  0x071EE: push     word ptr [bp - 2]
  0x071F1: lcall    0x37f, 0x3e4
  0x071F6: add      sp, 4
  0x071F9: mov      word ptr [bp - 4], ax
  0x071FC: or       ax, ax
  0x071FE: jl       0x721f
  0x07200: mov      ax, word ptr [bp + 0xa]
  0x07203: cmp      word ptr [bp - 4], ax
  0x07206: je       0x721f
  0x07208: push     di
  0x07209: push     word ptr [bp - 2]
  0x0720C: lcall    0x3e4, 0x74
  0x07211: add      sp, 4
  0x07214: cmp      ax, word ptr [bp - 6]
  0x07217: jne      0x721f
  0x07219: mov      ax, word ptr [bp - 4]
  0x0721C: mov      word ptr [0x8cfa], ax
  0x0721F: inc      si
  0x07220: cmp      word ptr [0x8cfa], 0
  0x07225: jge      0x722a
  0x07227: jmp      0x71a0
  0x0722A: cmp      word ptr [0x8cfa], 0
  0x0722F: jl       0x7238
  0x07231: mov      ax, 1
  0x07234: pop      si
  0x07235: pop      di
  0x07236: leave    
  0x07237: retf     

============================================================
func_L159 at file 0x0723E, 48 bytes
============================================================
  0x0723E: push     bp
  0x0723F: mov      bp, sp
  0x07241: push     di
  0x07242: push     si
  0x07243: mov      di, word ptr [bp + 8]
  0x07246: sub      si, si
  0x07248: push     di
  0x07249: push     word ptr [bp + 6]
  0x0724C: lcall    0x37f, 0x3e4
  0x07251: add      sp, 4
  0x07254: or       ax, ax
  0x07256: jge      0x7268
  0x07258: push     word ptr [bp + 0xa]
  0x0725B: push     di
  0x0725C: push     word ptr [bp + 6]
  0x0725F: push     cs
  0x07260: call     0x7178
  0x07263: add      sp, 6
  0x07266: mov      si, ax
  0x07268: mov      ax, si
  0x0726A: pop      si
  0x0726B: pop      di
  0x0726C: leave    
  0x0726D: retf     

============================================================
func_L160 at file 0x0726E, 116 bytes
============================================================
  0x0726E: enter    4, 0
  0x07272: push     di
  0x07273: push     si
  0x07274: sub      di, di
  0x07276: push     word ptr [bp + 8]
  0x07279: push     word ptr [bp + 6]
  0x0727C: lcall    0x37f, 0xa
  0x07281: add      sp, 4
  0x07284: or       ax, ax
  0x07286: je       0x72dc
  0x07288: sub      si, si
  0x0728A: cmp      si, 8
  0x0728D: jge      0x72dc
  0x0728F: mov      al, byte ptr [si + 0xbe]
  0x07293: cwde     
  0x07294: add      ax, word ptr [bp + 8]
  0x07297: mov      word ptr [bp - 2], ax
  0x0729A: push     ax
  0x0729B: mov      al, byte ptr [si + 0xb4]
  0x0729F: cwde     
  0x072A0: add      ax, word ptr [bp + 6]
  0x072A3: mov      word ptr [bp - 4], ax
  0x072A6: push     ax
  0x072A7: lcall    0x37f, 0x314
  0x072AC: add      sp, 4
  0x072AF: cmp      ax, word ptr [bp + 0xa]
  0x072B2: jne      0x72ba
  0x072B4: mov      di, 1
  0x072B7: jmp      0x72bc
  0x072B9: nop      
  0x072BA: sub      di, di
  0x072BC: inc      si
  0x072BD: push     word ptr [bp - 2]
  0x072C0: push     word ptr [bp - 4]
  0x072C3: lcall    0x37f, 0x358
  0x072C8: add      sp, 4
  0x072CB: cmp      ax, word ptr [bp + 0xa]
  0x072CE: jne      0x72d6
  0x072D0: mov      ax, 1
  0x072D3: jmp      0x72d8
  0x072D5: nop      
  0x072D6: sub      ax, ax
  0x072D8: or       di, ax
  0x072DA: je       0x728a
  0x072DC: mov      ax, di
  0x072DE: pop      si
  0x072DF: pop      di
  0x072E0: leave    
  0x072E1: retf     

============================================================
func_L161 at file 0x072E2, 40 bytes
============================================================
  0x072E2: push     bp
  0x072E3: mov      bp, sp
  0x072E5: push     di
  0x072E6: push     si
  0x072E7: mov      si, word ptr [bp + 6]
  0x072EA: or       si, si
  0x072EC: jl       0x7306
  0x072EE: mov      di, word ptr [bp + 8]
  0x072F1: mov      ax, di
  0x072F3: imul     bx, si, 0x1c  ; *Unit
  0x072F6: or       byte ptr [bx + 0x3147], al
  0x072FA: mov      ax, si
  0x072FC: push     cs
  0x072FD: call     0x66ba
  0x07300: mov      si, ax
  0x07302: or       si, si
  0x07304: jge      0x72f1
  0x07306: pop      si
  0x07307: pop      di
  0x07308: leave    
  0x07309: retf     

============================================================
func_L162 at file 0x0730A, 75 bytes
============================================================
  0x0730A: push     bp
  0x0730B: mov      bp, sp
  0x0730D: push     di
  0x0730E: push     si
  0x0730F: sub      di, di
  0x07311: cmp      word ptr [bp + 0xa], 4
  0x07315: jge      0x732c
  0x07317: push     word ptr [bp + 8]
  0x0731A: push     word ptr [bp + 6]
  0x0731D: lcall    0x37f, 0x200
  0x07322: add      sp, 4
  0x07325: mov      cl, al
  0x07327: mov      di, 0x10
  0x0732A: shl      di, cl
  0x0732C: sub      si, si
  0x0732E: push     si
  0x0732F: push     word ptr [bp + 8]
  0x07332: push     word ptr [bp + 6]
  0x07335: push     cs
  0x07336: call     0x726e
  0x07339: add      sp, 6
  0x0733C: or       ax, ax
  0x0733E: je       0x7349
  0x07340: mov      cx, si
  0x07342: mov      ax, 0x10
  0x07345: shl      ax, cl
  0x07347: or       di, ax
  0x07349: inc      si
  0x0734A: cmp      si, 4
  0x0734D: jl       0x732e
  0x0734F: mov      ax, di
  0x07351: pop      si
  0x07352: pop      di
  0x07353: leave    
  0x07354: retf     

============================================================
func_L163 at file 0x07356, 56 bytes
============================================================
  0x07356: push     bp
  0x07357: mov      bp, sp
  0x07359: push     di
  0x0735A: push     si
  0x0735B: mov      di, word ptr [bp + 6]
  0x0735E: sub      si, si
  0x07360: push     si
  0x07361: imul     bx, di, 0x1c  ; *Unit
  0x07364: mov      al, byte ptr [bx + 0x3145]
  0x07368: sub      ah, ah
  0x0736A: push     ax
  0x0736B: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x0736F: push     ax
  0x07370: push     cs
  0x07371: call     0x726e
  0x07374: add      sp, 6
  0x07377: or       ax, ax
  0x07379: je       0x7384
  0x0737B: push     si
  0x0737C: push     di
  0x0737D: push     cs
  0x0737E: call     0x701c
  0x07381: add      sp, 4
  0x07384: inc      si
  0x07385: cmp      si, 4
  0x07388: jl       0x7360
  0x0738A: pop      si
  0x0738B: pop      di
  0x0738C: leave    
  0x0738D: retf     

============================================================
func_L164 at file 0x0738E, 26 bytes
============================================================
  0x0738E: push     bp
  0x0738F: mov      bp, sp
  0x07391: push     si
  0x07392: mov      si, word ptr [bp + 6]
  0x07395: imul     bx, si, 0x1c  ; *Unit
  0x07398: mov      al, byte ptr [bx + 0x3147]
  0x0739C: xor      al, byte ptr [bp + 8]
  0x0739F: and      al, 0xf
  0x073A1: xor      byte ptr [bx + 0x3147], al
  0x073A5: pop      si
  0x073A6: leave    
  0x073A7: retf     

============================================================
func_L165 at file 0x073A8, 99 bytes
============================================================
  0x073A8: enter    6, 0
  0x073AC: push     di
  0x073AD: push     si
  0x073AE: mov      si, word ptr [bp + 6]
  0x073B1: sub      di, di
  0x073B3: mov      ax, si
  0x073B5: push     cs
  0x073B6: call     0x6672
  0x073B9: mov      si, ax
  0x073BB: or       si, si
  0x073BD: jge      0x73c2
  0x073BF: jmp      0x7577
  0x073C2: imul     bx, si, 0x1c  ; *Unit
  0x073C5: mov      word ptr [bp - 6], bx
  0x073C8: mov      al, byte ptr [bx + 0x3146]
  0x073CC: sub      ah, ah
  0x073CE: mov      word ptr [bp - 4], ax
  0x073D1: mov      word ptr [bp - 2], ax
  0x073D4: mov      ax, word ptr [bp + 8]
  0x073D7: cmp      ax, 0xe
  0x073DA: jbe      0x73df
  0x073DC: jmp      0x7568
  0x073DF: shl      ax, 1
  0x073E1: xchg     bx, ax
  0x073E2: jmp      word ptr cs:[bx + 0xd78]
  0x073E7: nop      
  0x073E8: xchg     si, ax
  0x073E9: or       ax, 0xef8
  0x073EC: mov      cx, 0xb00d
  0x073EF: or       ax, 0xdbe
  0x073F2: loopne   0x7401
  0x073F4: out      0xd, al
  0x073F6: clc      
  0x073F7: push     cs
  0x073F8: clc      
  0x073F9: push     cs
  0x073FA: clc      
  0x073FB: push     cs
  0x073FC: push     ss
  0x073FD: push     cs
  0x073FE: inc      si
  0x073FF: push     cs
  0x07400: mov      word ptr [0xe94], cs
  0x07404: mov      sp, 0x8b0e
  0x07407: pop      si
  0x07408: cld      
  0x07409: mov      ax, bx

============================================================
func_L166 at file 0x0757E, 33 bytes
============================================================
  0x0757E: push     bp
  0x0757F: mov      bp, sp
  0x07581: push     si
  0x07582: mov      si, word ptr [bp + 6]
  0x07585: imul     bx, si, 0x1c  ; *Unit
  0x07588: mov      al, byte ptr [bx + 0x3145]
  0x0758C: sub      ah, ah
  0x0758E: push     ax
  0x0758F: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x07593: push     ax
  0x07594: lcall    0x37f, 0x2a0
  0x07599: add      sp, 4
  0x0759C: pop      si
  0x0759D: leave    
  0x0759E: retf     

============================================================
func_L167 at file 0x075A0, 51 bytes
============================================================
  0x075A0: push     bp
  0x075A1: mov      bp, sp
  0x075A3: push     di
  0x075A4: push     si
  0x075A5: mov      di, word ptr [bp + 6]
  0x075A8: mov      ax, di
  0x075AA: push     cs
  0x075AB: call     0x6672
  0x075AE: mov      di, ax
  0x075B0: or       di, di
  0x075B2: jl       0x75cf
  0x075B4: mov      ax, di
  0x075B6: push     cs
  0x075B7: call     0x66ba
  0x075BA: mov      si, ax
  0x075BC: push     di
  0x075BD: push     cs
  0x075BE: call     0x6e94
  0x075C1: add      sp, 2
  0x075C4: cmp      di, si
  0x075C6: jge      0x75c9
  0x075C8: dec      si
  0x075C9: mov      di, si
  0x075CB: or       di, di
  0x075CD: jge      0x75b4
  0x075CF: pop      si
  0x075D0: pop      di
  0x075D1: leave    
  0x075D2: retf     

============================================================
func_L168 at file 0x075D4, 16 bytes
============================================================
  0x075D4: push     bp
  0x075D5: mov      bp, sp
  0x075D7: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x075DB: mov      al, byte ptr [bx + 0x315b]
  0x075DF: and      ax, 0xf  ; 6.25% chance
  0x075E2: leave    
  0x075E3: retf     

============================================================
func_L169 at file 0x075E4, 26 bytes
============================================================
  0x075E4: push     bp
  0x075E5: mov      bp, sp
  0x075E7: push     si
  0x075E8: mov      si, word ptr [bp + 6]
  0x075EB: imul     bx, si, 0x1c  ; *Unit
  0x075EE: mov      al, byte ptr [bx + 0x315b]
  0x075F2: xor      al, byte ptr [bp + 8]
  0x075F5: and      al, 0xf
  0x075F7: xor      byte ptr [bx + 0x315b], al
  0x075FB: pop      si
  0x075FC: leave    
  0x075FD: retf     

============================================================
func_L170 at file 0x075FE, 17 bytes
============================================================
  0x075FE: push     bp
  0x075FF: mov      bp, sp
  0x07601: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x07605: mov      al, byte ptr [bx + 0x315b]
  0x07609: sar      al, 4
  0x0760C: cwde     
  0x0760D: leave    
  0x0760E: retf     

============================================================
func_L171 at file 0x07610, 31 bytes
============================================================
  0x07610: push     bp
  0x07611: mov      bp, sp
  0x07613: push     si
  0x07614: mov      si, word ptr [bp + 6]
  0x07617: imul     bx, si, 0x1c  ; *Unit
  0x0761A: mov      al, byte ptr [bx + 0x315b]
  0x0761E: and      al, 0xf
  0x07620: mov      cl, byte ptr [bp + 8]
  0x07623: shl      cl, 4
  0x07626: or       al, cl
  0x07628: mov      byte ptr [bx + 0x315b], al
  0x0762C: pop      si
  0x0762D: leave    
  0x0762E: retf     

============================================================
func_L172 at file 0x07630, 37 bytes
============================================================
  0x07630: push     bp
  0x07631: mov      bp, sp
  0x07633: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x07637: mov      bl, byte ptr [bx + 0x3146]
  0x0763B: sub      bh, bh
  0x0763D: cmp      bx, 4
  0x07640: je       0x7656
  0x07642: cmp      bx, 5
  0x07645: je       0x7656
  0x07647: cmp      bx, 0x15
  0x0764A: je       0x7656
  0x0764C: cmp      bx, 0x16
  0x0764F: je       0x7656
  0x07651: sub      ax, ax
  0x07653: leave    
  0x07654: retf     

============================================================
func_L173 at file 0x0765C, 42 bytes
============================================================
  0x0765C: push     bp
  0x0765D: mov      bp, sp
  0x0765F: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x07663: mov      bl, byte ptr [bx + 0x3146]
  0x07667: sub      bh, bh
  0x07669: cmp      bx, 1
  0x0766C: je       0x7686
  0x0766E: cmp      bx, 4
  0x07671: je       0x7686
  0x07673: cmp      bx, 0xb
  0x07676: je       0x7686
  0x07678: cmp      bx, 0x14
  0x0767B: je       0x7686
  0x0767D: cmp      bx, 0x16
  0x07680: je       0x7686
  0x07682: sub      ax, ax
  0x07684: leave    
  0x07685: retf     

============================================================
func_L174 at file 0x0768C, 161 bytes
============================================================
  0x0768C: enter    0xc, 0
  0x07690: push     di
  0x07691: push     si
  0x07692: mov      si, word ptr [bp + 6]
  0x07695: mov      word ptr [bp - 0xa], 0xffff
  0x0769A: push     0
  0x0769C: push     si
  0x0769D: push     cs
  0x0769E: call     0x6b46
  0x076A1: add      sp, 4
  0x076A4: mov      ax, si
  0x076A6: push     cs
  0x076A7: call     0x6672
  0x076AA: imul     bx, ax, 0x1c  ; *Unit
  0x076AD: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x076B1: sub      ah, ah
  0x076B3: mov      word ptr [bp - 8], ax
  0x076B6: mov      al, byte ptr [bx + 0x3145]
  0x076BA: mov      word ptr [bp - 6], ax
  0x076BD: mov      word ptr [bp - 4], 0
  0x076C2: mov      ax, word ptr [bp - 8]
  0x076C5: mov      dx, word ptr [bp - 6]
  0x076C8: push     cs
  0x076C9: call     0x66cc
  0x076CC: mov      word ptr [bp - 2], ax
  0x076CF: mov      si, word ptr [bp - 4]
  0x076D2: mov      di, word ptr [bp - 0xa]
  0x076D5: or       ax, ax
  0x076D7: jl       0x7704
  0x076D9: imul     bx, ax, 0x1c  ; *Unit
  0x076DC: mov      al, byte ptr [bx + 0x3146]
  0x076E0: cmp      al, 0xd
  0x076E2: jb       0x76f6
  0x076E4: cmp      al, 0x12
  0x076E6: ja       0x76f6
  0x076E8: mov      di, word ptr [bp - 2]
  0x076EB: push     di
  0x076EC: push     cs
  0x076ED: call     0x772e
  0x076F0: add      sp, 2
  0x076F3: mov      si, 1
  0x076F6: mov      ax, word ptr [bp - 2]
  0x076F9: push     cs
  0x076FA: call     0x66ba
  0x076FD: mov      word ptr [bp - 2], ax
  0x07700: or       si, si
  0x07702: je       0x76d5
  0x07704: mov      word ptr [bp - 0xa], di
  0x07707: or       si, si
  0x07709: jne      0x76bd
  0x0770B: mov      di, word ptr [bp - 8]
  0x0770E: mov      ax, di
  0x07710: mov      dx, word ptr [bp - 6]
  0x07713: push     cs
  0x07714: call     0x66cc
  0x07717: mov      si, ax
  0x07719: push     word ptr [bp - 6]
  0x0771C: push     di
  0x0771D: push     word ptr [bp - 0xa]
  0x07720: push     cs
  0x07721: call     0x6a7c
  0x07724: add      sp, 6
  0x07727: mov      ax, si
  0x07729: pop      si
  0x0772A: pop      di
  0x0772B: leave    
  0x0772C: retf     

============================================================
func_L175 at file 0x0772E, 188 bytes
============================================================
  0x0772E: enter    0xe, 0
  0x07732: push     di
  0x07733: push     si
  0x07734: mov      word ptr [bp - 6], 0
  0x07739: mov      ax, word ptr [0x200]
  0x0773C: mov      word ptr [bp - 0xc], ax
  0x0773F: mov      ax, 1
  0x07742: mov      word ptr [bp - 0xa], ax
  0x07745: mov      word ptr [0x200], ax
  0x07748: mov      si, word ptr [bp + 6]
  0x0774B: cmp      word ptr [bp - 0xc], 0
  0x0774F: je       0x7754
  0x07751: jmp      0x77df
  0x07754: push     0
  0x07756: push     si
  0x07757: push     cs
  0x07758: call     0x6b46
  0x0775B: add      sp, 4
  0x0775E: imul     bx, si, 0x1c  ; *Unit
  0x07761: mov      word ptr [bp - 0xe], bx
  0x07764: cmp      byte ptr [bx + 0x314c], 2
  0x07769: jne      0x77df
  0x0776B: mov      word ptr [bp - 0xa], 0
  0x07770: mov      al, byte ptr [bx + 0x3147]
  0x07774: and      al, 0xf
  0x07776: sub      al, byte ptr [bx + 0x3144]  ; unit_table
  0x0777A: cmp      al, 0x14
  0x0777C: je       0x77df
  0x0777E: mov      al, byte ptr [bx + 0x3145]
  0x07782: sub      ah, ah
  0x07784: push     ax
  0x07785: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x07789: push     ax
  0x0778A: lcall    0x37f, 0x3e4
  0x0778F: add      sp, 4
  0x07792: or       ax, ax
  0x07794: jge      0x77df
  0x07796: mov      bx, word ptr [bp - 0xe]
  0x07799: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x0779D: sub      ah, ah
  0x0779F: mov      di, ax
  0x077A1: mov      al, byte ptr [bx + 0x3145]
  0x077A5: mov      word ptr [bp - 2], ax
  0x077A8: push     -4
  0x077AA: push     -4
  0x077AC: push     si
  0x077AD: push     cs
  0x077AE: call     0x69d2
  0x077B1: add      sp, 6
  0x077B4: mov      ax, di
  0x077B6: mov      dx, word ptr [bp - 2]
  0x077B9: push     cs
  0x077BA: call     0x66cc
  0x077BD: push     ax
  0x077BE: push     cs
  0x077BF: call     0x768c
  0x077C2: add      sp, 2
  0x077C5: mov      word ptr [bp - 8], ax
  0x077C8: push     word ptr [bp - 2]
  0x077CB: push     di
  0x077CC: push     si
  0x077CD: push     cs
  0x077CE: call     0x69d2
  0x077D1: add      sp, 6
  0x077D4: cmp      word ptr [bp - 8], 0
  0x077D8: jl       0x77df
  0x077DA: mov      word ptr [bp - 0xa], 1
  0x077DF: cmp      word ptr [bp - 0xa], 0
  0x077E3: je       0x780f
  0x077E5: imul     bx, si, 0x1c  ; *Unit
  0x077E8: mov      ax, bx

============================================================
func_L176 at file 0x078F4, 66 bytes
============================================================
  0x078F4: enter    2, 0
  0x078F8: push     di
  0x078F9: push     si
  0x078FA: mov      si, word ptr [bp + 6]
  0x078FD: sub      di, di
  0x078FF: mov      ax, si
  0x07901: push     cs
  0x07902: call     0x6672
  0x07905: mov      si, ax
  0x07907: or       si, si
  0x07909: jl       0x7930
  0x0790B: or       di, di
  0x0790D: jne      0x7930
  0x0790F: imul     bx, si, 0x1c  ; *Unit
  0x07912: mov      al, byte ptr [bx + 0x3146]
  0x07916: mov      byte ptr [bp - 2], al
  0x07919: cmp      al, 0xd
  0x0791B: jb       0x7924
  0x0791D: cmp      al, 0x12
  0x0791F: ja       0x7924
  0x07921: mov      di, 1
  0x07924: mov      ax, si
  0x07926: push     cs
  0x07927: call     0x66ba
  0x0792A: mov      si, ax
  0x0792C: or       si, si
  0x0792E: jge      0x790b
  0x07930: mov      ax, di
  0x07932: pop      si
  0x07933: pop      di
  0x07934: leave    
  0x07935: retf     

============================================================
func_L177 at file 0x07936, 48 bytes
============================================================
  0x07936: push     bp
  0x07937: mov      bp, sp
  0x07939: push     di
  0x0793A: push     si
  0x0793B: mov      si, word ptr [bp + 6]
  0x0793E: mov      ax, si
  0x07940: push     cs
  0x07941: call     0x6672
  0x07944: mov      si, ax
  0x07946: or       si, si
  0x07948: jl       0x7962
  0x0794A: mov      di, word ptr [bp + 8]
  0x0794D: mov      ax, di
  0x0794F: imul     bx, si, 0x1c  ; *Unit
  0x07952: mov      byte ptr [bx + 0x314c], al
  0x07956: mov      ax, si
  0x07958: push     cs
  0x07959: call     0x66ba
  0x0795C: mov      si, ax
  0x0795E: or       si, si
  0x07960: jge      0x794d
  0x07962: pop      si
  0x07963: pop      di
  0x07964: leave    
  0x07965: retf     

============================================================
func_L178 at file 0x07966, 41 bytes
============================================================
  0x07966: enter    2, 0
  0x0796A: push     si
  0x0796B: mov      si, word ptr [bp + 6]
  0x0796E: or       si, si
  0x07970: jl       0x799c
  0x07972: imul     bx, si, 0x1c  ; *Unit
  0x07975: mov      al, byte ptr [bx + 0x3146]
  0x07979: mov      byte ptr [bp - 2], al
  0x0797C: cmp      al, 0xd
  0x0797E: jb       0x7990
  0x07980: cmp      al, 0x12
  0x07982: ja       0x7990
  0x07984: push     si
  0x07985: push     cs
  0x07986: call     0x772e
  0x07989: add      sp, 2
  0x0798C: pop      si
  0x0798D: leave    
  0x0798E: retf     

============================================================
func_L179 at file 0x079A0, 119 bytes
============================================================
  0x079A0: enter    2, 0
  0x079A4: push     di
  0x079A5: push     si
  0x079A6: mov      si, ax
  0x079A8: sub      di, di
  0x079AA: or       si, si
  0x079AC: jl       0x7a1a
  0x079AE: cmp      word ptr [0x539c], si  ; score
  0x079B2: jle      0x7a1a
  0x079B4: imul     bx, si, 0x1c  ; *Unit
  0x079B7: mov      word ptr [bp - 2], bx
  0x079BA: mov      al, byte ptr [bx + 0x3145]
  0x079BE: sub      ah, ah
  0x079C0: push     ax
  0x079C1: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x079C5: push     ax
  0x079C6: lcall    0x37f, 0xa
  0x079CB: add      sp, 4
  0x079CE: or       ax, ax
  0x079D0: je       0x7a1a
  0x079D2: mov      bx, word ptr [bp - 2]
  0x079D5: mov      al, byte ptr [bx + 0x3147]
  0x079D9: and      al, 0xf
  0x079DB: cmp      al, byte ptr [0x5394]
  0x079DF: jne      0x7a18
  0x079E1: cmp      byte ptr [bx + 0x314c], 1
  0x079E6: je       0x7a18
  0x079E8: cmp      byte ptr [bx + 0x314c], 6
  0x079ED: je       0x7a18
  0x079EF: test     byte ptr [bx + 0x3148], 0x80
  0x079F4: je       0x79fd
  0x079F6: cmp      byte ptr [bx + 0x3146], 0xb
  0x079FB: jne      0x7a18
  0x079FD: push     si
  0x079FE: push     cs
  0x079FF: call     0x6cca
  0x07A02: add      sp, 2
  0x07A05: mov      bx, word ptr [bp - 2]
  0x07A08: cmp      byte ptr [bx + 0x3149], al
  0x07A0C: jae      0x7a18
  0x07A0E: mov      di, 1
  0x07A11: mov      ax, di
  0x07A13: pop      si
  0x07A14: pop      di
  0x07A15: leave    
  0x07A16: retf     

============================================================
func_L180 at file 0x07A20, 83 bytes
============================================================
  0x07A20: enter    2, 0
  0x07A24: push     di
  0x07A25: push     si
  0x07A26: mov      si, ax
  0x07A28: sub      bx, bx
  0x07A2A: or       si, si
  0x07A2C: jl       0x7a7a
  0x07A2E: cmp      word ptr [0x539c], si  ; score
  0x07A32: jle      0x7a7a
  0x07A34: imul     di, si, 0x1c  ; *Unit
  0x07A37: mov      word ptr [bp - 2], di
  0x07A3A: cmp      byte ptr [di + 0x3144], 0  ; unit_table
  0x07A3F: jl       0x7a7a
  0x07A41: mov      bx, di
  0x07A43: mov      al, byte ptr [bx + 0x3147]
  0x07A47: and      al, 0xf
  0x07A49: cmp      al, byte ptr [0x5394]
  0x07A4D: jne      0x7a78
  0x07A4F: test     byte ptr [bx + 0x3148], 0x80
  0x07A54: je       0x7a5d
  0x07A56: cmp      byte ptr [bx + 0x3146], 0xb
  0x07A5B: jne      0x7a78
  0x07A5D: push     si
  0x07A5E: push     cs
  0x07A5F: call     0x6cca
  0x07A62: add      sp, 2
  0x07A65: mov      bx, word ptr [bp - 2]
  0x07A68: cmp      byte ptr [bx + 0x3149], al
  0x07A6C: jae      0x7a78
  0x07A6E: mov      bx, 1
  0x07A71: mov      ax, bx

============================================================
func_L181 at file 0x07A80, 143 bytes
============================================================
  0x07A80: enter    2, 0
  0x07A84: push     di
  0x07A85: push     si
  0x07A86: mov      si, ax
  0x07A88: sub      di, di
  0x07A8A: or       si, si
  0x07A8C: jl       0x7b09
  0x07A8E: cmp      word ptr [0x539c], si  ; score
  0x07A92: jle      0x7b09
  0x07A94: imul     bx, si, 0x1c  ; *Unit
  0x07A97: mov      word ptr [bp - 2], bx
  0x07A9A: mov      al, byte ptr [bx + 0x3145]
  0x07A9E: sub      ah, ah
  0x07AA0: push     ax
  0x07AA1: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x07AA5: push     ax
  0x07AA6: lcall    0x37f, 0xa
  0x07AAB: add      sp, 4
  0x07AAE: or       ax, ax
  0x07AB0: jne      0x7aca
  0x07AB2: mov      bx, word ptr [bp - 2]
  0x07AB5: cmp      byte ptr [bx + 0x314c], 2
  0x07ABA: jne      0x7b09
  0x07ABC: mov      al, byte ptr [bx + 0x3147]
  0x07AC0: and      al, 0xf
  0x07AC2: sub      al, byte ptr [bx + 0x3144]  ; unit_table
  0x07AC6: cmp      al, 0x14
  0x07AC8: jne      0x7b09
  0x07ACA: mov      bx, word ptr [bp - 2]
  0x07ACD: mov      al, byte ptr [bx + 0x3147]
  0x07AD1: and      al, 0xf
  0x07AD3: cmp      al, byte ptr [0x5394]
  0x07AD7: jne      0x7b09
  0x07AD9: cmp      byte ptr [bx + 0x314c], 1
  0x07ADE: je       0x7b09
  0x07AE0: cmp      byte ptr [bx + 0x314c], 6
  0x07AE5: je       0x7b09
  0x07AE7: test     byte ptr [bx + 0x3148], 0x80
  0x07AEC: je       0x7af5
  0x07AEE: cmp      byte ptr [bx + 0x3146], 0xb
  0x07AF3: jne      0x7b09
  0x07AF5: push     si
  0x07AF6: push     cs
  0x07AF7: call     0x6cca
  0x07AFA: add      sp, 2
  0x07AFD: mov      bx, word ptr [bp - 2]
  0x07B00: cmp      byte ptr [bx + 0x3149], al
  0x07B04: jae      0x7b09
  0x07B06: mov      di, 1
  0x07B09: mov      ax, di
  0x07B0B: pop      si
  0x07B0C: pop      di
  0x07B0D: leave    
  0x07B0E: retf     

============================================================
func_L182 at file 0x07B10, 76 bytes
============================================================
  0x07B10: enter    4, 0
  0x07B14: push     di
  0x07B15: push     si
  0x07B16: cmp      word ptr [0x539c], ax  ; score
  0x07B1A: jle      0x7b24
  0x07B1C: or       ax, ax
  0x07B1E: jl       0x7b24
  0x07B20: mov      dx, ax
  0x07B22: jmp      0x7b33
  0x07B24: mov      ax, 0xffff
  0x07B27: mov      dx, word ptr [0x539c]  ; score
  0x07B2B: dec      dx
  0x07B2C: cmp      word ptr [0x539c], 0  ; score
  0x07B31: je       0x7b5f
  0x07B33: mov      word ptr [bp - 2], dx
  0x07B36: mov      si, ax
  0x07B38: inc      si
  0x07B39: cmp      word ptr [0x539c], si  ; score
  0x07B3D: jg       0x7b41
  0x07B3F: sub      si, si
  0x07B41: mov      ax, si
  0x07B43: push     cs
  0x07B44: call     0x7a80
  0x07B47: mov      di, ax
  0x07B49: or       di, di
  0x07B4B: jne      0x7b52
  0x07B4D: cmp      word ptr [bp - 2], si
  0x07B50: jne      0x7b38
  0x07B52: or       di, di
  0x07B54: je       0x7b5c
  0x07B56: mov      ax, si
  0x07B58: pop      si
  0x07B59: pop      di
  0x07B5A: leave    
  0x07B5B: retf     

============================================================
func_L183 at file 0x07B64, 105 bytes
============================================================
  0x07B64: enter    6, 0
  0x07B68: push     di
  0x07B69: push     si
  0x07B6A: mov      word ptr [bp - 6], 0xffff
  0x07B6F: mov      word ptr [bp - 4], 0x270f
  0x07B74: sub      si, si
  0x07B76: cmp      word ptr [0x539c], si  ; score
  0x07B7A: jle      0x7bc0
  0x07B7C: mov      di, 0x3147
  0x07B7F: mov      al, byte ptr [di]
  0x07B81: and      al, 0xf
  0x07B83: cmp      al, byte ptr [bp + 6]
  0x07B86: jne      0x7bb6
  0x07B88: cmp      word ptr [bp + 8], si
  0x07B8B: je       0x7bb6
  0x07B8D: mov      al, byte ptr [di - 2]
  0x07B90: sub      ah, ah
  0x07B92: sub      ax, word ptr [bp + 0xc]
  0x07B95: neg      ax
  0x07B97: push     ax
  0x07B98: mov      al, byte ptr [di - 3]
  0x07B9B: sub      ah, ah
  0x07B9D: sub      ax, word ptr [bp + 0xa]
  0x07BA0: neg      ax
  0x07BA2: push     ax
  0x07BA3: lcall    0x24c, 0x40
  0x07BA8: add      sp, 4
  0x07BAB: cmp      ax, word ptr [bp - 4]
  0x07BAE: jg       0x7bb6
  0x07BB0: mov      word ptr [bp - 6], si
  0x07BB3: mov      word ptr [bp - 4], ax
  0x07BB6: add      di, 0x1c
  0x07BB9: inc      si
  0x07BBA: cmp      word ptr [0x539c], si  ; score
  0x07BBE: jg       0x7b7f
  0x07BC0: mov      ax, word ptr [bp - 4]
  0x07BC3: mov      word ptr [0x8cf8], ax
  0x07BC6: mov      ax, word ptr [bp - 6]
  0x07BC9: pop      si
  0x07BCA: pop      di
  0x07BCB: leave    
  0x07BCC: retf     

============================================================
func_L184 at file 0x07BCE, 25 bytes
============================================================
  0x07BCE: push     bp
  0x07BCF: mov      bp, sp
  0x07BD1: push     si
  0x07BD2: mov      si, word ptr [bp + 6]
  0x07BD5: push     si
  0x07BD6: push     cs
  0x07BD7: call     0x6cca
  0x07BDA: add      sp, 2
  0x07BDD: imul     bx, si, 0x1c  ; *Unit
  0x07BE0: mov      byte ptr [bx + 0x3149], al
  0x07BE4: pop      si
  0x07BE5: leave    
  0x07BE6: retf     

============================================================
func_L185 at file 0x07BE8, 66 bytes
============================================================
  0x07BE8: enter    2, 0
  0x07BEC: sub      ax, ax
  0x07BEE: mov      word ptr [bp - 2], ax
  0x07BF1: push     ax
  0x07BF2: lcall    0x5eb, 0x38e
  0x07BF7: add      sp, 2
  0x07BFA: or       ax, ax
  0x07BFC: je       0x7c03
  0x07BFE: mov      word ptr [bp - 2], 1
  0x07C03: push     1
  0x07C05: lcall    0x5eb, 0x38e
  0x07C0A: add      sp, 2
  0x07C0D: or       ax, ax
  0x07C0F: je       0x7c14
  0x07C11: inc      word ptr [bp - 2]
  0x07C14: push     2
  0x07C16: lcall    0x5eb, 0x38e
  0x07C1B: add      sp, 2
  0x07C1E: or       ax, ax
  0x07C20: je       0x7c25
  0x07C22: inc      word ptr [bp - 2]
  0x07C25: mov      ax, word ptr [bp - 2]
  0x07C28: leave    
  0x07C29: retf     

============================================================
func_L186 at file 0x07C2A, 46 bytes
============================================================
  0x07C2A: enter    6, 0
  0x07C2E: cmp      word ptr [bp + 8], 1
  0x07C32: sbb      ax, ax
  0x07C34: inc      ax
  0x07C35: cmp      word ptr [bp + 8], 1
  0x07C39: sbb      bx, bx
  0x07C3B: neg      bx
  0x07C3D: mov      word ptr [bp - 4], bx
  0x07C40: shl      bx, 1
  0x07C42: or       word ptr [bx - 0x7300], ax
  0x07C46: cmp      word ptr [bp + 8], 0
  0x07C4A: je       0x7c68
  0x07C4C: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x07C50: mov      bl, byte ptr [bx + 0x3146]
  0x07C54: sub      bh, bh
  0x07C56: mov      ax, bx

============================================================
func_L187 at file 0x07D3E, 502 bytes
============================================================
  0x07D3E: enter    0x18, 0
  0x07D42: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x07D46: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x07D4A: sub      ah, ah
  0x07D4C: mov      word ptr [bp - 0xc], ax
  0x07D4F: mov      al, byte ptr [bx + 0x3145]
  0x07D53: mov      word ptr [bp - 0xe], ax
  0x07D56: imul     bx, word ptr [bp + 8], 0x1c  ; *Unit
  0x07D5A: mov      al, byte ptr [bx + 0x3147]
  0x07D5E: and      ax, 0xf  ; 6.25% chance
  0x07D61: mov      word ptr [bp - 2], ax
  0x07D64: push     0
  0x07D66: push     word ptr [bp + 6]
  0x07D69: push     cs
  0x07D6A: call     0x7c2a
  0x07D6D: add      sp, 4
  0x07D70: mov      word ptr [bp - 0xa], ax
  0x07D73: sub      ax, ax
  0x07D75: mov      word ptr [bp - 0x18], ax
  0x07D78: mov      word ptr [0x8d04], ax
  0x07D7B: push     word ptr [bp - 0xe]
  0x07D7E: push     word ptr [bp - 0xc]
  0x07D81: lcall    0x37f, 0x392
  0x07D86: add      sp, 4
  0x07D89: or       ax, ax
  0x07D8B: jl       0x7de2
  0x07D8D: mov      word ptr [bp - 0x18], 2
  0x07D92: push     word ptr [bp - 0xe]
  0x07D95: push     word ptr [bp - 0xc]
  0x07D98: lcall    0x181f, 0x9f0
  0x07D9D: add      sp, 4
  0x07DA0: mov      word ptr [bp - 0x10], ax
  0x07DA3: mov      word ptr [0x1b04], ax
  0x07DA6: imul     bx, ax, 0x12  ; *TradeRoute
  0x07DA9: mov      al, byte ptr [bx + 0x54ee]
  0x07DAD: sub      ah, ah
  0x07DAF: sub      ax, 4
  0x07DB2: imul     bx, ax, 0x4e
  0x07DB5: cmp      byte ptr [bx + 0x5ad8], 2
  0x07DBA: jb       0x7dc6
  0x07DBC: mov      word ptr [bp - 0x18], 4
  0x07DC1: or       byte ptr [0x8d02], 0x10
  0x07DC6: imul     bx, word ptr [bp - 0x10], 0x12  ; *TradeRoute
  0x07DCA: test     byte ptr [bx + 0x54ef], 4
  0x07DCF: je       0x7dd9
  0x07DD1: shl      word ptr [bp - 0x18], 1
  0x07DD4: or       byte ptr [0x8d02], 0x20
  0x07DD9: or       byte ptr [0x8d02], 8
  0x07DDE: jmp      0x7efe
  0x07DE1: nop      
  0x07DE2: push     word ptr [bp - 0xe]
  0x07DE5: push     word ptr [bp - 0xc]
  0x07DE8: lcall    0x37f, 0x358
  0x07DED: add      sp, 4
  0x07DF0: or       ax, ax
  0x07DF2: jl       0x7e20
  0x07DF4: push     word ptr [bp - 0xe]
  0x07DF7: push     word ptr [bp - 0xc]
  0x07DFA: lcall    0x5eb, 0xa76
  0x07DFF: add      sp, 4
  0x07E02: mov      word ptr [0x1b06], ax
  0x07E05: push     ax
  0x07E06: lcall    0x5eb, 0x2c
  0x07E0B: add      sp, 2
  0x07E0E: push     cs
  0x07E0F: call     0x7be8
  0x07E12: inc      ax
  0x07E13: shl      ax, 1
  0x07E15: add      word ptr [bp - 0x18], ax
  0x07E18: or       byte ptr [0x8d02], 0x40
  0x07E1D: jmp      0x7efe
  0x07E20: push     word ptr [bp - 0xe]
  0x07E23: push     word ptr [bp - 0xc]
  0x07E26: lcall    0x3e4, 0x3a
  0x07E2B: add      sp, 4
  0x07E2E: mov      word ptr [bp - 0x12], ax
  0x07E31: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x07E35: mov      al, byte ptr [bx + 0x3147]
  0x07E39: and      al, 0xf
  0x07E3B: cmp      al, 4
  0x07E3D: jae      0x7e5d
  0x07E3F: cmp      word ptr [bp - 2], 4
  0x07E43: jge      0x7e74
  0x07E45: test     byte ptr [0x5382], 1
  0x07E4A: je       0x7e5d
  0x07E4C: cmp      word ptr [bp - 2], 4
  0x07E50: jge      0x7e5d
  0x07E52: imul     bx, word ptr [bp - 2], 0x34  ; *AI
  0x07E56: cmp      byte ptr [bx + 0x543f], 0  ; ai_pers
  0x07E5B: je       0x7e74
  0x07E5D: mov      bx, word ptr [bp - 0x12]
  0x07E60: shl      bx, 4
  0x07E63: mov      al, byte ptr [bx + 0x2f77]
  0x07E67: sub      ah, ah
  0x07E69: add      word ptr [bp - 0x18], ax
  0x07E6C: or       byte ptr [0x8d02], 0x80
  0x07E71: jmp      0x7efe
  0x07E74: mov      word ptr [bp - 4], 1
  0x07E79: cmp      word ptr [bp - 2], 4
  0x07E7D: jge      0x7ed4
  0x07E7F: imul     bx, word ptr [bp - 2], 0x34  ; *AI
  0x07E83: cmp      byte ptr [bx + 0x543f], 0  ; ai_pers
  0x07E88: jne      0x7ed4
  0x07E8A: push     word ptr [bp - 0xe]
  0x07E8D: push     word ptr [bp - 0xc]
  0x07E90: lcall    0x37f, 0x358
  0x07E95: add      sp, 4
  0x07E98: or       ax, ax
  0x07E9A: jge      0x7eb8
  0x07E9C: imul     bx, word ptr [bp + 8], 0x1c  ; *Unit
  0x07EA0: mov      al, byte ptr [bx + 0x3145]
  0x07EA4: sub      ah, ah
  0x07EA6: push     ax
  0x07EA7: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x07EAB: push     ax
  0x07EAC: lcall    0x37f, 0x358
  0x07EB1: add      sp, 4
  0x07EB4: or       ax, ax
  0x07EB6: jl       0x7ee4
  0x07EB8: mov      word ptr [bp - 4], 0
  0x07EBD: mov      bx, word ptr [bp - 0x12]
  0x07EC0: shl      bx, 4
  0x07EC3: mov      al, byte ptr [bx + 0x2f77]
  0x07EC7: sub      ah, ah
  0x07EC9: add      word ptr [bp - 0x18], ax
  0x07ECC: or       byte ptr [0x8d02], 0x80
  0x07ED1: jmp      0x7ee4
  0x07ED3: nop      
  0x07ED4: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x07ED8: cmp      byte ptr [bx + 0x314c], 6
  0x07EDD: jne      0x7ee4
  0x07EDF: mov      word ptr [bp - 4], 0
  0x07EE4: cmp      word ptr [bp - 4], 0
  0x07EE8: je       0x7efe
  0x07EEA: mov      bx, word ptr [bp - 0x12]
  0x07EED: shl      bx, 4
  0x07EF0: mov      al, byte ptr [bx + 0x2f77]
  0x07EF4: sub      ah, ah
  0x07EF6: mov      word ptr [0x8d04], ax
  0x07EF9: or       byte ptr [0x8d00], 0x80
  0x07EFE: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x07F02: cmp      byte ptr [bx + 0x314c], 6
  0x07F07: jne      0x7f26
  0x07F09: cmp      byte ptr [bx + 0x3146], 0xd
  0x07F0E: jb       0x7f17
  0x07F10: cmp      byte ptr [bx + 0x3146], 0x12
  0x07F15: jbe      0x7f26
  0x07F17: cmp      word ptr [bp - 0x18], 5
  0x07F1B: jge      0x7f26
  0x07F1D: add      word ptr [bp - 0x18], 2
  0x07F21: or       byte ptr [0x8d03], 0x20
  0x07F26: mov      ax, word ptr [bp - 0x18]
  0x07F29: add      ax, 4
  0x07F2C: imul     word ptr [bp - 0xa]
  0x07F2F: sar      ax, 2
  0x07F32: leave    
  0x07F33: retf     

============================================================
func_L188 at file 0x07F34, 27 bytes
============================================================
  0x07F34: enter    2, 0
  0x07F38: push     si
  0x07F39: cmp      word ptr [bp + 6], 4
  0x07F3D: jl       0x7f50
  0x07F3F: imul     si, word ptr [bp + 6], 0x4e
  0x07F43: mov      bx, word ptr [bp + 8]
  0x07F46: mov      al, byte ptr [bx + si + 0x59d8]
  0x07F4A: sub      ah, ah
  0x07F4C: pop      si
  0x07F4D: leave    
  0x07F4E: retf     

============================================================
func_L189 at file 0x07F62, 30 bytes
============================================================
  0x07F62: push     bp
  0x07F63: mov      bp, sp
  0x07F65: push     si
  0x07F66: cmp      word ptr [bp + 6], 4
  0x07F6A: jl       0x7f80
  0x07F6C: mov      al, byte ptr [bp + 0xa]
  0x07F6F: imul     si, word ptr [bp + 6], 0x4e
  0x07F73: mov      bx, word ptr [bp + 8]
  0x07F76: mov      byte ptr [bx + si + 0x59d8], al
  0x07F7A: mov      ax, word ptr [bp + 0xa]
  0x07F7D: pop      si
  0x07F7E: leave    
  0x07F7F: retf     

============================================================
func_L190 at file 0x07F96, 105 bytes
============================================================
  0x07F96: enter    4, 0
  0x07F9A: push     word ptr [bp + 8]
  0x07F9D: push     word ptr [bp + 6]
  0x07FA0: push     cs
  0x07FA1: call     0x7f34
  0x07FA4: add      sp, 4
  0x07FA7: or       ax, word ptr [bp + 0xa]
  0x07FAA: push     ax
  0x07FAB: push     word ptr [bp + 8]
  0x07FAE: push     word ptr [bp + 6]
  0x07FB1: push     cs
  0x07FB2: call     0x7f62
  0x07FB5: add      sp, 6
  0x07FB8: mov      word ptr [bp - 2], ax
  0x07FBB: push     word ptr [bp + 6]
  0x07FBE: push     word ptr [bp + 8]
  0x07FC1: push     cs
  0x07FC2: call     0x7f34
  0x07FC5: add      sp, 4
  0x07FC8: or       ax, word ptr [bp + 0xa]
  0x07FCB: push     ax
  0x07FCC: push     word ptr [bp + 6]
  0x07FCF: push     word ptr [bp + 8]
  0x07FD2: push     cs
  0x07FD3: call     0x7f62
  0x07FD6: add      sp, 6
  0x07FD9: mov      word ptr [bp - 4], ax
  0x07FDC: and      ax, word ptr [bp + 0xa]
  0x07FDF: mov      cx, word ptr [bp + 0xa]
  0x07FE2: and      cx, word ptr [bp - 2]
  0x07FE5: cmp      ax, cx
  0x07FE7: je       0x7ffa
  0x07FE9: push     word ptr [bp + 0xa]
  0x07FEC: push     word ptr [bp - 4]
  0x07FEF: push     word ptr [bp - 2]
  0x07FF2: push     0x202
  0x07FF5: lcall    0x181f, 0x77e
  0x07FFA: mov      ax, word ptr [bp - 2]
  0x07FFD: leave    
  0x07FFE: retf     

============================================================
func_L191 at file 0x08000, 115 bytes
============================================================
  0x08000: enter    4, 0
  0x08004: push     si
  0x08005: push     word ptr [bp + 8]
  0x08008: push     word ptr [bp + 6]
  0x0800B: push     cs
  0x0800C: call     0x7f34
  0x0800F: add      sp, 4
  0x08012: mov      cx, word ptr [bp + 0xa]
  0x08015: not      cx
  0x08017: and      ax, cx
  0x08019: push     ax
  0x0801A: push     word ptr [bp + 8]
  0x0801D: push     word ptr [bp + 6]
  0x08020: mov      si, cx
  0x08022: push     cs
  0x08023: call     0x7f62
  0x08026: add      sp, 6
  0x08029: mov      word ptr [bp - 2], ax
  0x0802C: push     word ptr [bp + 6]
  0x0802F: push     word ptr [bp + 8]
  0x08032: push     cs
  0x08033: call     0x7f34
  0x08036: add      sp, 4
  0x08039: and      si, ax
  0x0803B: push     si
  0x0803C: push     word ptr [bp + 6]
  0x0803F: push     word ptr [bp + 8]
  0x08042: push     cs
  0x08043: call     0x7f62
  0x08046: add      sp, 6
  0x08049: mov      word ptr [bp - 4], ax
  0x0804C: and      ax, word ptr [bp + 0xa]
  0x0804F: mov      cx, word ptr [bp - 2]
  0x08052: and      cx, word ptr [bp + 0xa]
  0x08055: cmp      ax, cx
  0x08057: je       0x806d
  0x08059: push     word ptr [bp + 0xa]
  0x0805C: push     word ptr [bp - 4]
  0x0805F: push     word ptr [bp - 2]
  0x08062: push     0x212
  0x08065: lcall    0x181f, 0x77e
  0x0806A: add      sp, 8
  0x0806D: mov      ax, word ptr [bp - 2]
  0x08070: pop      si
  0x08071: leave    
  0x08072: retf     

============================================================
func_L192 at file 0x08074, 83 bytes
============================================================
  0x08074: push     bp
  0x08075: mov      bp, sp
  0x08077: push     si
  0x08078: cmp      word ptr [bp + 6], 3
  0x0807C: jne      0x80b0
  0x0807E: push     word ptr [0x2e02]
  0x08082: push     word ptr [bp + 0xa]
  0x08085: lcall    0x4b, 0xe2
  0x0808A: add      sp, 4
  0x0808D: push     word ptr [bp + 0xa]
  0x08090: lcall    0x4b, 0
  0x08095: add      sp, 2
  0x08098: cmp      word ptr [bp + 8], 0
  0x0809C: jne      0x80b0
  0x0809E: mov      bx, word ptr [bp + 0xa]
  0x080A1: mov      al, byte ptr [bx]
  0x080A3: cwde     
  0x080A4: mov      si, ax
  0x080A6: test     byte ptr [si + 0x27ed], 1
  0x080AB: je       0x80b0
  0x080AD: add      byte ptr [bx], 0x20
  0x080B0: mov      bx, word ptr [bp + 6]
  0x080B3: shl      bx, 1
  0x080B5: push     word ptr [bx - 0x72be]
  0x080B9: push     word ptr [bp + 0xa]
  0x080BC: lcall    0x4b, 0xe2
  0x080C1: add      sp, 4
  0x080C4: pop      si
  0x080C5: leave    
  0x080C6: retf     

============================================================
func_L193 at file 0x080C8, 14 bytes
============================================================
  0x080C8: push     bp
  0x080C9: mov      bp, sp
  0x080CB: cmp      word ptr [bp + 6], 4
  0x080CF: jl       0x80e2
  0x080D1: mov      bx, word ptr [bp + 6]
  0x080D4: mov      ax, bx

============================================================
func_L194 at file 0x08110, 14 bytes
============================================================
  0x08110: push     bp
  0x08111: mov      bp, sp
  0x08113: cmp      word ptr [bp + 6], 4
  0x08117: jl       0x812a
  0x08119: mov      bx, word ptr [bp + 6]
  0x0811C: mov      ax, bx

============================================================
func_L195 at file 0x08158, 14 bytes
============================================================
  0x08158: push     bp
  0x08159: mov      bp, sp
  0x0815B: cmp      word ptr [bp + 6], 4
  0x0815F: jl       0x8172
  0x08161: mov      bx, word ptr [bp + 6]
  0x08164: mov      ax, bx

============================================================
func_L196 at file 0x0817E, 14 bytes
============================================================
  0x0817E: push     bp
  0x0817F: mov      bp, sp
  0x08181: cmp      word ptr [bp + 6], 4
  0x08185: jl       0x8198
  0x08187: mov      bx, word ptr [bp + 6]
  0x0818A: mov      ax, bx

============================================================
func_L197 at file 0x081A4, 28 bytes
============================================================
  0x081A4: push     bp
  0x081A5: mov      bp, sp
  0x081A7: test     byte ptr [0x5382], 1
  0x081AC: je       0x81c0
  0x081AE: mov      ax, word ptr [0x53d2]
  0x081B1: cmp      word ptr [bp + 6], ax
  0x081B4: jne      0x81c0
  0x081B6: imul     ax, word ptr [0x5398], 0x34  ; *AI
  0x081BB: add      ax, 0x5426
  0x081BE: leave    
  0x081BF: retf     

============================================================
func_L198 at file 0x081C6, 44 bytes
============================================================
  0x081C6: push     bp
  0x081C7: mov      bp, sp
  0x081C9: mov      ax, word ptr [bp + 6]
  0x081CC: mov      word ptr [0x8d52], ax  ; glob_8D52
  0x081CF: or       ax, ax
  0x081D1: jl       0x81d8
  0x081D3: cmp      ax, 8
  0x081D6: jl       0x81dd
  0x081D8: mov      word ptr [bp + 6], 0
  0x081DD: mov      ax, word ptr [bp + 6]
  0x081E0: add      ax, 4
  0x081E3: mov      word ptr [0x8d50], ax
  0x081E6: imul     ax, word ptr [bp + 6], 0x4e
  0x081EA: add      ax, 0x5ad6
  0x081ED: mov      word ptr [0x8d4e], ax
  0x081F0: leave    
  0x081F1: retf     

============================================================
func_L199 at file 0x081F2, 34 bytes
============================================================
  0x081F2: push     bp
  0x081F3: mov      bp, sp
  0x081F5: mov      ax, word ptr [bp + 6]
  0x081F8: mov      word ptr [0x8d4c], ax
  0x081FB: or       ax, ax
  0x081FD: jl       0x8227
  0x081FF: or       ax, ax
  0x08201: jl       0x8209
  0x08203: cmp      word ptr [0x539a], ax
  0x08207: jg       0x820e
  0x08209: mov      word ptr [bp + 6], 0
  0x0820E: imul     bx, word ptr [bp + 6], 0x12  ; *TradeRoute

============================================================
func_L200 at file 0x0822A, 36 bytes
============================================================
  0x0822A: enter    2, 0
  0x0822E: imul     bx, word ptr [bp + 6], 0x4e
  0x08232: mov      al, byte ptr [bx + 0x5ad8]
  0x08236: sub      ah, ah
  0x08238: or       ax, ax
  0x0823A: je       0x8244
  0x0823C: dec      ax
  0x0823D: je       0x8244
  0x0823F: dec      ax
  0x08240: je       0x824e
  0x08242: jmp      0x8258
  0x08244: mov      word ptr [bp - 2], 1
  0x08249: mov      ax, word ptr [bp - 2]
  0x0824C: leave    
  0x0824D: retf     

============================================================
func_L201 at file 0x08262, 20 bytes
============================================================
  0x08262: enter    2, 0
  0x08266: cmp      word ptr [bp + 6], 0x19
  0x0826A: jge      0x8276
  0x0826C: mov      word ptr [bp - 2], 0
  0x08271: mov      ax, word ptr [bp - 2]
  0x08274: leave    
  0x08275: retf     

============================================================
func_L202 at file 0x082A0, 18 bytes
============================================================
  0x082A0: push     bp
  0x082A1: mov      bp, sp
  0x082A3: imul     bx, word ptr [bp + 6], 0x27
  0x082A7: add      bx, word ptr [bp + 8]
  0x082AA: shl      bx, 1
  0x082AC: mov      ax, word ptr [bx + 0x5b1c]
  0x082B0: leave    
  0x082B1: retf     

============================================================
func_L203 at file 0x082B2, 38 bytes
============================================================
  0x082B2: push     bp
  0x082B3: mov      bp, sp
  0x082B5: cmp      word ptr [bp + 6], 0x1c
  0x082B9: je       0x82d8
  0x082BB: cmp      word ptr [bp + 6], 0x13
  0x082BF: je       0x82d8
  0x082C1: cmp      word ptr [bp + 6], 0x19
  0x082C5: je       0x82d8
  0x082C7: cmp      word ptr [bp + 6], 0x1a
  0x082CB: je       0x82d8
  0x082CD: cmp      word ptr [bp + 6], 0x1b
  0x082D1: je       0x82d8
  0x082D3: mov      ax, 1
  0x082D6: leave    
  0x082D7: retf     

============================================================
func_L204 at file 0x082DC, 45 bytes
============================================================
  0x082DC: enter    2, 0
  0x082E0: mov      word ptr [bp - 2], 0
  0x082E5: mov      ax, word ptr [bp + 6]
  0x082E8: mov      word ptr [0x8dc6], ax
  0x082EB: or       ax, ax
  0x082ED: jl       0x82f5
  0x082EF: cmp      ax, word ptr [0x539e]
  0x082F3: jl       0x82ff
  0x082F5: mov      word ptr [bp + 6], 0
  0x082FA: mov      word ptr [bp - 2], 1
  0x082FF: mov      al, byte ptr [0x5396]
  0x08302: imul     bx, word ptr [bp + 6], 0xca  ; *Colony

============================================================
func_L205 at file 0x08352, 159 bytes
============================================================
  0x08352: enter    0xc, 0
  0x08356: mov      word ptr [bp - 8], 0xffff
  0x0835B: sub      ax, ax
  0x0835D: mov      word ptr [bp - 6], ax
  0x08360: mov      word ptr [bp - 0xa], ax
  0x08363: jmp      0x83e3
  0x08365: nop      
  0x08366: mov      bx, word ptr [bp - 0xa]
  0x08369: mov      al, byte ptr [bx + 0xbe]
  0x0836D: cwde     
  0x0836E: add      ax, word ptr [bp + 8]
  0x08371: mov      word ptr [bp - 4], ax
  0x08374: push     ax
  0x08375: mov      al, byte ptr [bx + 0xb4]
  0x08379: cwde     
  0x0837A: add      ax, word ptr [bp + 6]
  0x0837D: mov      word ptr [bp - 2], ax
  0x08380: push     ax
  0x08381: lcall    0x37f, 0xa
  0x08386: add      sp, 4
  0x08389: or       ax, ax
  0x0838B: je       0x83e0
  0x0838D: push     word ptr [bp - 4]
  0x08390: push     word ptr [bp - 2]
  0x08393: lcall    0x3e4, 0x74
  0x08398: add      sp, 4
  0x0839B: or       ax, ax
  0x0839D: je       0x83e0
  0x0839F: mov      word ptr [bp - 6], 1
  0x083A4: push     word ptr [bp - 4]
  0x083A7: push     word ptr [bp - 2]
  0x083AA: lcall    0x37f, 0x1ca
  0x083AF: add      sp, 4
  0x083B2: sub      ah, ah
  0x083B4: mov      word ptr [bp - 0xc], ax
  0x083B7: or       ax, ax
  0x083B9: jne      0x83c0
  0x083BB: mov      word ptr [bp - 0xc], 0x10
  0x083C0: cmp      word ptr [bp - 8], 0
  0x083C4: jl       0x83ce
  0x083C6: mov      ax, word ptr [bp - 8]
  0x083C9: cmp      word ptr [bp - 0xc], ax
  0x083CC: jge      0x83e0
  0x083CE: mov      ax, word ptr [bp - 0xc]
  0x083D1: mov      word ptr [bp - 8], ax
  0x083D4: mov      ax, word ptr [bp - 2]
  0x083D7: mov      word ptr [0x8dba], ax
  0x083DA: mov      ax, word ptr [bp - 4]
  0x083DD: mov      word ptr [0x8dbc], ax
  0x083E0: inc      word ptr [bp - 0xa]
  0x083E3: cmp      word ptr [bp - 0xa], 8
  0x083E7: jge      0x83ec
  0x083E9: jmp      0x8366
  0x083EC: mov      ax, word ptr [bp - 6]
  0x083EF: leave    
  0x083F0: retf     

============================================================
func_L206 at file 0x083F2, 213 bytes
============================================================
  0x083F2: enter    0xc, 0
  0x083F6: mov      word ptr [bp - 0xc], 0xffff
  0x083FB: mov      word ptr [bp - 2], 0x270f
  0x08400: mov      word ptr [bp - 6], 0
  0x08405: cmp      word ptr [bp + 0xc], -2
  0x08409: jne      0x8421
  0x0840B: mov      word ptr [bp - 6], 1
  0x08410: push     word ptr [bp + 8]
  0x08413: push     word ptr [bp + 6]
  0x08416: lcall    0x37f, 0x2a0
  0x0841B: add      sp, 4
  0x0841E: mov      word ptr [bp + 0xc], ax
  0x08421: mov      word ptr [bp - 8], 0
  0x08426: jmp      0x84aa
  0x08429: nop      
  0x0842A: cmp      word ptr [bp + 0xa], 0
  0x0842E: jl       0x843e
  0x08430: mov      al, byte ptr [bp + 0xa]
  0x08433: imul     bx, word ptr [bp - 8], 0xca  ; *Colony
  0x08438: cmp      byte ptr [bx + 0x5d60], al  ; colony_tbl
  0x0843C: jne      0x84a7
  0x0843E: cmp      word ptr [bp + 0xc], 0
  0x08442: jl       0x8462
  0x08444: imul     bx, word ptr [bp - 8], 0xca  ; *Colony
  0x08449: mov      al, byte ptr [bx + 0x5d47]
  0x0844D: sub      ah, ah
  0x0844F: push     ax
  0x08450: mov      al, byte ptr [bx + 0x5d46]
  0x08454: push     ax
  0x08455: lcall    0x37f, 0x2a0
  0x0845A: add      sp, 4
  0x0845D: cmp      ax, word ptr [bp + 0xc]
  0x08460: jne      0x84a7
  0x08462: cmp      word ptr [bp - 6], 0
  0x08466: je       0x8474
  0x08468: imul     bx, word ptr [bp - 8], 0xca  ; *Colony
  0x0846D: test     byte ptr [bx + 0x5d62], 0x40
  0x08472: je       0x84a7
  0x08474: imul     bx, word ptr [bp - 8], 0xca  ; *Colony
  0x08479: mov      al, byte ptr [bx + 0x5d47]
  0x0847D: sub      ah, ah
  0x0847F: sub      ax, word ptr [bp + 8]
  0x08482: neg      ax
  0x08484: push     ax
  0x08485: mov      al, byte ptr [bx + 0x5d46]
  0x08489: sub      ah, ah
  0x0848B: sub      ax, word ptr [bp + 6]
  0x0848E: neg      ax
  0x08490: push     ax
  0x08491: lcall    0x24c, 0x40
  0x08496: add      sp, 4
  0x08499: cmp      ax, word ptr [bp - 2]
  0x0849C: jg       0x84a7
  0x0849E: mov      cx, word ptr [bp - 8]
  0x084A1: mov      word ptr [bp - 0xc], cx
  0x084A4: mov      word ptr [bp - 2], ax
  0x084A7: inc      word ptr [bp - 8]
  0x084AA: mov      ax, word ptr [0x539e]
  0x084AD: cmp      word ptr [bp - 8], ax
  0x084B0: jge      0x84b5
  0x084B2: jmp      0x842a
  0x084B5: mov      ax, word ptr [bp - 2]
  0x084B8: mov      word ptr [0x8db8], ax  ; glob_8DB8
  0x084BB: push     word ptr [bp - 0xc]
  0x084BE: push     cs
  0x084BF: call     0x82dc
  0x084C2: mov      ax, word ptr [bp - 0xc]
  0x084C5: leave    
  0x084C6: retf     

============================================================
func_L207 at file 0x084C8, 19 bytes
============================================================
  0x084C8: push     bp
  0x084C9: mov      bp, sp
  0x084CB: cmp      word ptr [bp + 6], 0x1c
  0x084CF: jne      0x84d6
  0x084D1: mov      word ptr [bp + 6], 0x13
  0x084D6: mov      ax, word ptr [bp + 6]
  0x084D9: leave    
  0x084DA: retf     

============================================================
func_L208 at file 0x084DC, 21 bytes
============================================================
  0x084DC: push     bp
  0x084DD: mov      bp, sp
  0x084DF: push     word ptr [bp + 6]
  0x084E2: push     cs
  0x084E3: call     0x84c8
  0x084E6: mov      bx, ax
  0x084E8: shl      bx, 3
  0x084EB: mov      ax, word ptr [bx - 0x715e]
  0x084EF: leave    
  0x084F0: retf     

============================================================
func_L209 at file 0x084F2, 21 bytes
============================================================
  0x084F2: push     bp
  0x084F3: mov      bp, sp
  0x084F5: push     word ptr [bp + 6]
  0x084F8: push     cs
  0x084F9: call     0x84c8
  0x084FC: mov      bx, ax
  0x084FE: shl      bx, 3
  0x08501: mov      ax, word ptr [bx - 0x715c]
  0x08505: leave    
  0x08506: retf     

============================================================
func_L210 at file 0x08508, 27 bytes
============================================================
  0x08508: push     bp
  0x08509: mov      bp, sp
  0x0850B: imul     bx, word ptr [bp + 6], 0xca  ; *Colony
  0x08510: mov      al, byte ptr [bx + 0x5d47]
  0x08514: sub      ah, ah
  0x08516: push     ax
  0x08517: mov      al, byte ptr [bx + 0x5d46]
  0x0851B: push     ax
  0x0851C: lcall    0x37f, 0x2a0
  0x08521: leave    
  0x08522: retf     

============================================================
func_L211 at file 0x08524, 142 bytes
============================================================
  0x08524: enter    0xa, 0
  0x08528: sub      ax, ax
  0x0852A: mov      word ptr [bp - 0xa], ax
  0x0852D: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08531: mov      ax, word ptr [bx + 0xc2]
  0x08535: mov      dx, word ptr [bx + 0xc4]
  0x08539: cmp      word ptr [bx + 0xc8], 0
  0x0853E: jl       0x8566
  0x08540: jg       0x8549
  0x08542: cmp      word ptr [bx + 0xc6], 0
  0x08547: je       0x8566
  0x08549: push     word ptr [bx + 0xc8]
  0x0854D: push     word ptr [bx + 0xc6]
  0x08551: push     0
  0x08553: push     0x64
  0x08555: push     dx
  0x08556: push     ax
  0x08557: lcall    0xd1d, 0xf60
  0x0855C: push     dx
  0x0855D: push     ax
  0x0855E: lcall    0xd1d, 0xec6
  0x08563: mov      word ptr [bp - 0xa], ax
  0x08566: mov      ax, word ptr [bp - 0xa]
  0x08569: mov      word ptr [bp - 6], ax
  0x0856C: push     0x12
  0x0856E: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08572: mov      cl, byte ptr [bx + 0x1a]
  0x08575: sub      ch, ch
  0x08577: push     cx
  0x08578: lcall    0x981, 0
  0x0857D: add      sp, 4
  0x08580: or       ax, ax
  0x08582: je       0x85a5
  0x08584: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08588: cmp      byte ptr [bx + 0x1a], 4
  0x0858C: jae      0x85a5
  0x0858E: mov      al, byte ptr [bx + 0x1a]
  0x08591: sub      ah, ah
  0x08593: imul     bx, ax, 0x34  ; *AI
  0x08596: cmp      byte ptr [bx + 0x543f], ah  ; ai_pers
  0x0859A: jne      0x85a5
  0x0859C: mov      ax, word ptr [bp - 6]
  0x0859F: add      ax, 0x14
  0x085A2: mov      word ptr [bp - 6], ax
  0x085A5: mov      ax, word ptr [bp - 6]
  0x085A8: cmp      ax, 0x64
  0x085AB: jle      0x85b0
  0x085AD: mov      ax, 0x64
  0x085B0: leave    
  0x085B1: retf     

============================================================
func_L212 at file 0x085B2, 35 bytes
============================================================
  0x085B2: push     bp
  0x085B3: mov      bp, sp
  0x085B5: push     si
  0x085B6: mov      si, word ptr [bp + 6]
  0x085B9: sar      si, 3
  0x085BC: mov      bx, word ptr [0x8542]  ; cur_nation
  0x085C0: mov      al, byte ptr [bx + si + 0x8a]
  0x085C4: cwde     
  0x085C5: mov      cl, byte ptr [bp + 6]
  0x085C8: and      cl, 7
  0x085CB: mov      dx, 1
  0x085CE: shl      dx, cl
  0x085D0: and      ax, dx
  0x085D2: pop      si
  0x085D3: leave    
  0x085D4: retf     

============================================================
func_L213 at file 0x085D6, 44 bytes
============================================================
  0x085D6: enter    6, 0
  0x085DA: mov      cl, byte ptr [bp + 6]
  0x085DD: and      cl, 7
  0x085E0: mov      ax, 1
  0x085E3: shl      ax, cl
  0x085E5: mov      word ptr [bp - 4], ax
  0x085E8: mov      cx, word ptr [bp + 6]
  0x085EB: sar      cx, 3
  0x085EE: add      cx, word ptr [0x8542]  ; cur_nation
  0x085F2: add      cx, 0x8a
  0x085F6: cmp      word ptr [bp + 8], 0
  0x085FA: je       0x8602
  0x085FC: mov      bx, cx
  0x085FE: or       byte ptr [bx], al
  0x08600: leave    
  0x08601: retf     

============================================================
func_L214 at file 0x0860E, 15 bytes
============================================================
  0x0860E: push     bp
  0x0860F: mov      bp, sp
  0x08611: push     si
  0x08612: cmp      word ptr [bp + 8], 0
  0x08616: jge      0x861e
  0x08618: sub      ax, ax
  0x0861A: pop      si
  0x0861B: leave    
  0x0861C: retf     

============================================================
func_L215 at file 0x0863E, 16 bytes
============================================================
  0x0863E: push     bp
  0x0863F: mov      bp, sp
  0x08641: push     word ptr [bp + 6]
  0x08644: push     word ptr [0x8dc6]
  0x08648: push     cs
  0x08649: call     0x860e
  0x0864C: leave    
  0x0864D: retf     

============================================================
func_L216 at file 0x0864E, 31 bytes
============================================================
  0x0864E: enter    2, 0
  0x08652: mov      word ptr [bp - 2], 0
  0x08657: push     word ptr [bp + 6]
  0x0865A: push     cs
  0x0865B: call     0x863e
  0x0865E: add      sp, 2
  0x08661: or       ax, ax
  0x08663: je       0x8668
  0x08665: inc      word ptr [bp - 2]
  0x08668: mov      bx, word ptr [bp + 6]
  0x0866B: mov      ax, bx

============================================================
func_L217 at file 0x08686, 34 bytes
============================================================
  0x08686: enter    2, 0
  0x0868A: mov      word ptr [bp - 2], 0
  0x0868F: push     word ptr [bp + 8]
  0x08692: push     word ptr [bp + 6]
  0x08695: push     cs
  0x08696: call     0x860e
  0x08699: add      sp, 4
  0x0869C: or       ax, ax
  0x0869E: je       0x86a3
  0x086A0: inc      word ptr [bp - 2]
  0x086A3: mov      bx, word ptr [bp + 8]
  0x086A6: mov      ax, bx

============================================================
func_L218 at file 0x086C0, 19 bytes
============================================================
  0x086C0: push     bp
  0x086C1: mov      bp, sp
  0x086C3: jmp      0x86ce
  0x086C5: nop      
  0x086C6: mov      al, byte ptr [bx - 0x707a]
  0x086CA: cwde     
  0x086CB: mov      word ptr [bp + 6], ax
  0x086CE: mov      bx, word ptr [bp + 6]
  0x086D1: mov      ax, bx

============================================================
func_L219 at file 0x086E4, 34 bytes
============================================================
  0x086E4: enter    4, 0
  0x086E8: mov      word ptr [bp - 4], 0xffff
  0x086ED: jmp      0x8715
  0x086EF: nop      
  0x086F0: push     word ptr [bp + 6]
  0x086F3: push     cs
  0x086F4: call     0x863e
  0x086F7: add      sp, 2
  0x086FA: or       ax, ax
  0x086FC: je       0x871b
  0x086FE: mov      bx, word ptr [bp + 6]
  0x08701: mov      word ptr [bp - 4], bx
  0x08704: mov      ax, bx

============================================================
func_L220 at file 0x08734, 30 bytes
============================================================
  0x08734: enter    2, 0
  0x08738: push     cs
  0x08739: call     0x8720
  0x0873C: dec      ax
  0x0873D: je       0x8748
  0x0873F: dec      ax
  0x08740: je       0x8752
  0x08742: dec      ax
  0x08743: je       0x875c
  0x08745: jmp      0x8766
  0x08747: nop      
  0x08748: mov      word ptr [bp - 2], 4
  0x0874D: mov      ax, word ptr [bp - 2]
  0x08750: leave    
  0x08751: retf     

============================================================
func_L221 at file 0x08770, 132 bytes
============================================================
  0x08770: enter    6, 0
  0x08774: push     si
  0x08775: mov      word ptr [bp - 2], 0
  0x0877A: push     word ptr [bp + 8]
  0x0877D: push     word ptr [bp + 6]
  0x08780: lcall    0x37f, 0xa
  0x08785: add      sp, 4
  0x08788: or       ax, ax
  0x0878A: je       0x87ee
  0x0878C: push     cs
  0x0878D: call     0x8720
  0x08790: mov      bx, ax
  0x08792: mov      al, byte ptr [bx + 0x329]
  0x08796: sub      ah, ah
  0x08798: mov      word ptr [bp - 6], ax
  0x0879B: mov      al, byte ptr [bp + 6]
  0x0879E: mov      bx, word ptr [0x8542]  ; cur_nation
  0x087A2: cmp      byte ptr [bx], al
  0x087A4: jne      0x87b3
  0x087A6: mov      al, byte ptr [bp + 8]
  0x087A9: cmp      byte ptr [bx + 1], al
  0x087AC: jne      0x87b3
  0x087AE: mov      word ptr [bp - 2], 1
  0x087B3: mov      word ptr [bp - 4], 0
  0x087B8: jmp      0x87e8
  0x087BA: mov      ax, word ptr [bp - 6]
  0x087BD: cmp      word ptr [bp - 4], ax
  0x087C0: jge      0x87ee
  0x087C2: mov      bx, word ptr [bp - 4]
  0x087C5: mov      al, byte ptr [bx + 0xc8]
  0x087C9: mov      si, word ptr [0x8542]  ; cur_nation
  0x087CD: add      al, byte ptr [si]
  0x087CF: cmp      al, byte ptr [bp + 6]
  0x087D2: jne      0x87e5
  0x087D4: mov      al, byte ptr [bx + 0xde]
  0x087D8: add      al, byte ptr [si + 1]
  0x087DB: cmp      al, byte ptr [bp + 8]
  0x087DE: jne      0x87e5
  0x087E0: mov      word ptr [bp - 2], 1
  0x087E5: inc      word ptr [bp - 4]
  0x087E8: cmp      word ptr [bp - 2], 0
  0x087EC: je       0x87ba
  0x087EE: mov      ax, word ptr [bp - 2]
  0x087F1: pop      si
  0x087F2: leave    
  0x087F3: retf     

============================================================
func_L222 at file 0x087F4, 18 bytes
============================================================
  0x087F4: push     bp
  0x087F5: mov      bp, sp
  0x087F7: imul     bx, word ptr [bp + 6], 0x13c  ; *Power
  0x087FC: mov      ax, word ptr [bx - 0x77ce]
  0x08800: mov      dx, word ptr [bx - 0x77cc]
  0x08804: leave    
  0x08805: retf     

============================================================
func_L223 at file 0x08806, 63 bytes
============================================================
  0x08806: enter    4, 0
  0x0880A: push     word ptr [bp + 6]
  0x0880D: push     cs
  0x0880E: call     0x87f4
  0x08811: add      sp, 2
  0x08814: add      ax, word ptr [bp + 8]
  0x08817: adc      dx, word ptr [bp + 0xa]
  0x0881A: or       dx, dx
  0x0881C: jg       0x8824
  0x0881E: jge      0x8824
  0x08820: sub      dx, dx
  0x08822: sub      ax, ax
  0x08824: cmp      dx, 0xf
  0x08827: jl       0x8836
  0x08829: jg       0x8830
  0x0882B: cmp      ax, 0x423f
  0x0882E: jbe      0x8836
  0x08830: mov      dx, 0xf
  0x08833: mov      ax, 0x423f
  0x08836: imul     bx, word ptr [bp + 6], 0x13c  ; *Power
  0x0883B: mov      word ptr [bx - 0x77ce], ax
  0x0883F: mov      word ptr [bx - 0x77cc], dx
  0x08843: leave    
  0x08844: retf     

============================================================
func_L224 at file 0x08846, 27 bytes
============================================================
  0x08846: push     bp
  0x08847: mov      bp, sp
  0x08849: mov      ax, word ptr [bp + 8]
  0x0884C: mov      dx, word ptr [bp + 0xa]
  0x0884F: neg      ax
  0x08851: adc      dx, 0
  0x08854: neg      dx
  0x08856: push     dx
  0x08857: push     ax
  0x08858: push     word ptr [bp + 6]
  0x0885B: push     cs
  0x0885C: call     0x8806
  0x0885F: leave    
  0x08860: retf     

============================================================
func_L225 at file 0x08862, 25 bytes
============================================================
  0x08862: push     bp
  0x08863: mov      bp, sp
  0x08865: push     word ptr [bp + 6]
  0x08868: push     cs
  0x08869: call     0x87f4
  0x0886C: mov      sp, bp
  0x0886E: push     dx
  0x0886F: push     ax
  0x08870: push     ds
  0x08871: push     word ptr [bp + 8]
  0x08874: lcall    0x4b, 0x1e8
  0x08879: leave    
  0x0887A: retf     

============================================================
func_L226 at file 0x0887C, 21 bytes
============================================================
  0x0887C: push     bp
  0x0887D: mov      bp, sp
  0x0887F: push     word ptr [bp + 6]
  0x08882: push     cs
  0x08883: call     0x87f4
  0x08886: mov      sp, bp
  0x08888: push     dx
  0x08889: push     ax
  0x0888A: lcall    9, 0x1fc
  0x0888F: leave    
  0x08890: retf     

============================================================
func_L227 at file 0x08892, 62 bytes
============================================================
  0x08892: enter    4, 0
  0x08896: mov      word ptr [bp - 2], 0xffff
  0x0889B: sub      word ptr [bp + 6], 2
  0x0889F: sub      word ptr [bp + 8], 2
  0x088A3: mov      word ptr [bp - 4], 0
  0x088A8: jmp      0x88ad
  0x088AA: inc      word ptr [bp - 4]
  0x088AD: cmp      word ptr [bp - 4], 0x14
  0x088B1: jge      0x88cb
  0x088B3: mov      al, byte ptr [bp + 6]
  0x088B6: mov      bx, word ptr [bp - 4]
  0x088B9: cmp      byte ptr [bx + 0xc8], al
  0x088BD: jne      0x88aa
  0x088BF: mov      al, byte ptr [bp + 8]
  0x088C2: cmp      byte ptr [bx + 0xde], al
  0x088C6: jne      0x88aa
  0x088C8: mov      word ptr [bp - 2], bx
  0x088CB: mov      ax, word ptr [bp - 2]
  0x088CE: leave    
  0x088CF: retf     

============================================================
func_L228 at file 0x088D0, 71 bytes
============================================================
  0x088D0: enter    4, 0
  0x088D4: mov      word ptr [bp - 2], 0
  0x088D9: push     word ptr [bp + 8]
  0x088DC: push     word ptr [bp + 6]
  0x088DF: push     cs
  0x088E0: call     0x8892
  0x088E3: add      sp, 4
  0x088E6: or       ax, ax
  0x088E8: jl       0x8912
  0x088EA: mov      bx, word ptr [0x8542]  ; cur_nation
  0x088EE: mov      al, byte ptr [bx + 1]
  0x088F1: sub      ah, ah
  0x088F3: dec      ax
  0x088F4: dec      ax
  0x088F5: add      word ptr [bp + 8], ax
  0x088F8: push     word ptr [bp + 8]
  0x088FB: mov      al, byte ptr [bx]
  0x088FD: sub      ah, ah
  0x088FF: dec      ax
  0x08900: dec      ax
  0x08901: add      word ptr [bp + 6], ax
  0x08904: push     word ptr [bp + 6]
  0x08907: lcall    0x37f, 0x142
  0x0890C: and      ax, 0x10
  0x0890F: mov      word ptr [bp - 2], ax
  0x08912: mov      ax, word ptr [bp - 2]
  0x08915: leave    
  0x08916: retf     

============================================================
func_L229 at file 0x08918, 62 bytes
============================================================
  0x08918: enter    2, 0
  0x0891C: push     word ptr [bp + 8]
  0x0891F: push     word ptr [bp + 6]
  0x08922: push     cs
  0x08923: call     0x8892
  0x08926: add      sp, 4
  0x08929: or       ax, ax
  0x0892B: jl       0x8954
  0x0892D: push     word ptr [bp + 0xa]
  0x08930: push     0x10
  0x08932: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08936: mov      al, byte ptr [bx + 1]
  0x08939: sub      ah, ah
  0x0893B: dec      ax
  0x0893C: dec      ax
  0x0893D: add      word ptr [bp + 8], ax
  0x08940: push     word ptr [bp + 8]
  0x08943: mov      al, byte ptr [bx]
  0x08945: sub      ah, ah
  0x08947: dec      ax
  0x08948: dec      ax
  0x08949: add      word ptr [bp + 6], ax
  0x0894C: push     word ptr [bp + 6]
  0x0894F: lcall    0x37f, 0x15e
  0x08954: leave    
  0x08955: retf     

============================================================
func_L230 at file 0x08956, 44 bytes
============================================================
  0x08956: enter    4, 0
  0x0895A: push     si
  0x0895B: mov      byte ptr [bp - 2], 0xff
  0x0895F: push     word ptr [bp + 8]
  0x08962: push     word ptr [bp + 6]
  0x08965: push     cs
  0x08966: call     0x8892
  0x08969: add      sp, 4
  0x0896C: or       ax, ax
  0x0896E: jl       0x897c
  0x08970: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08974: mov      si, ax
  0x08976: mov      al, byte ptr [bx + si + 0x70]
  0x08979: mov      byte ptr [bp - 2], al
  0x0897C: mov      al, byte ptr [bp - 2]
  0x0897F: pop      si
  0x08980: leave    
  0x08981: retf     

============================================================
func_L231 at file 0x08982, 532 bytes
============================================================
  0x08982: enter    0x14, 0
  0x08986: push     di
  0x08987: push     si
  0x08988: push     word ptr [bp + 8]
  0x0898B: push     word ptr [bp + 6]
  0x0898E: push     cs
  0x0898F: call     0x8892
  0x08992: add      sp, 4
  0x08995: mov      word ptr [bp - 0xc], ax
  0x08998: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0899C: mov      al, byte ptr [bx + 1]
  0x0899F: sub      ah, ah
  0x089A1: push     ax
  0x089A2: mov      al, byte ptr [bx]
  0x089A4: push     ax
  0x089A5: lcall    0x37f, 0x2a0
  0x089AA: add      sp, 4
  0x089AD: mov      word ptr [bp - 6], ax
  0x089B0: cmp      word ptr [bp - 0xc], 0
  0x089B4: jge      0x89b9
  0x089B6: jmp      0x8b92
  0x089B9: mov      al, byte ptr [bp + 0xa]
  0x089BC: mov      bx, word ptr [0x8542]  ; cur_nation
  0x089C0: mov      si, word ptr [bp - 0xc]
  0x089C3: mov      byte ptr [bx + si + 0x70], al
  0x089C6: or       al, al
  0x089C8: jge      0x89cd
  0x089CA: jmp      0x8b92
  0x089CD: cmp      byte ptr [0x34d], 0
  0x089D2: je       0x89d7
  0x089D4: jmp      0x8b92
  0x089D7: mov      al, byte ptr [bx + 1]
  0x089DA: sub      ah, ah
  0x089DC: add      ax, word ptr [bp + 8]
  0x089DF: dec      ax
  0x089E0: dec      ax
  0x089E1: mov      word ptr [bp - 4], ax
  0x089E4: push     ax
  0x089E5: mov      al, byte ptr [bx]
  0x089E7: sub      ah, ah
  0x089E9: add      ax, word ptr [bp + 6]
  0x089EC: dec      ax
  0x089ED: dec      ax
  0x089EE: mov      word ptr [bp - 2], ax
  0x089F1: push     ax
  0x089F2: lcall    0x37f, 0x314
  0x089F7: add      sp, 4
  0x089FA: or       ax, ax
  0x089FC: jge      0x8a28
  0x089FE: push     word ptr [bp - 4]
  0x08A01: push     word ptr [bp - 2]
  0x08A04: lcall    0x37f, 0x3e4
  0x08A09: add      sp, 4
  0x08A0C: or       ax, ax
  0x08A0E: jge      0x8a28
  0x08A10: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08A14: mov      al, byte ptr [bx + 0x1a]
  0x08A17: sub      ah, ah
  0x08A19: push     ax
  0x08A1A: push     word ptr [bp - 4]
  0x08A1D: push     word ptr [bp - 2]
  0x08A20: lcall    0x37f, 0x228
  0x08A25: add      sp, 6
  0x08A28: mov      si, word ptr [bp + 6]
  0x08A2B: mov      ax, si
  0x08A2D: shl      si, 2
  0x08A30: add      si, ax
  0x08A32: mov      bx, word ptr [bp + 8]
  0x08A35: mov      al, byte ptr [bx + si - 0x7262]
  0x08A39: cwde     
  0x08A3A: mov      word ptr [bp - 0x12], ax
  0x08A3D: or       ax, ax
  0x08A3F: jge      0x8a44
  0x08A41: jmp      0x8b83
  0x08A44: push     word ptr [bp - 6]
  0x08A47: push     -1
  0x08A49: push     word ptr [bp - 4]
  0x08A4C: push     word ptr [bp - 2]
  0x08A4F: lcall    0x181f, 0xd84
  0x08A54: add      sp, 8
  0x08A57: mov      word ptr [bp - 8], 0
  0x08A5C: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08A60: cmp      byte ptr [bx + 0x1a], 4
  0x08A64: jae      0x8a74
  0x08A66: mov      al, byte ptr [bx + 0x1a]
  0x08A69: sub      ah, ah
  0x08A6B: imul     bx, ax, 0x34  ; *AI
  0x08A6E: cmp      byte ptr [bx + 0x543f], ah  ; ai_pers
  0x08A72: je       0x8ae3
  0x08A74: push     word ptr [bp - 4]
  0x08A77: push     word ptr [bp - 2]
  0x08A7A: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08A7E: mov      al, byte ptr [bx + 0x1a]
  0x08A81: sub      ah, ah
  0x08A83: push     ax
  0x08A84: push     word ptr [0x8d4c]
  0x08A88: lcall    0x181f, 0xd78
  0x08A8D: add      sp, 8
  0x08A90: mov      word ptr [bp - 8], ax
  0x08A93: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08A97: mov      al, byte ptr [bx + 0x1a]
  0x08A9A: sub      ah, ah
  0x08A9C: push     ax
  0x08A9D: push     cs
  0x08A9E: call     0x87f4
  0x08AA1: add      sp, 2
  0x08AA4: mov      cx, ax
  0x08AA6: mov      ax, word ptr [bp - 8]
  0x08AA9: mov      bx, dx
  0x08AAB: cdq      
  0x08AAC: sub      cx, ax
  0x08AAE: sbb      bx, dx
  0x08AB0: mov      si, ax
  0x08AB2: sar      ax, 1
  0x08AB4: mov      di, dx
  0x08AB6: cdq      
  0x08AB7: cmp      bx, dx
  0x08AB9: jl       0x8ade
  0x08ABB: jg       0x8ac1
  0x08ABD: cmp      cx, ax
  0x08ABF: jb       0x8ade
  0x08AC1: mov      bx, word ptr [0x8d4e]
  0x08AC5: inc      byte ptr [bx + 5]
  0x08AC8: push     di
  0x08AC9: push     si
  0x08ACA: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08ACE: mov      al, byte ptr [bx + 0x1a]
  0x08AD1: sub      ah, ah
  0x08AD3: push     ax
  0x08AD4: push     cs
  0x08AD5: call     0x8846
  0x08AD8: add      sp, 6
  0x08ADB: jmp      0x8ae3
  0x08ADD: nop      
  0x08ADE: mov      word ptr [bp - 8], 0
  0x08AE3: cmp      word ptr [bp - 8], 0
  0x08AE7: je       0x8aec
  0x08AE9: jmp      0x8b71
  0x08AEC: cmp      word ptr [0x5394], 4
  0x08AF1: jge      0x8b0a
  0x08AF3: imul     bx, word ptr [0x5394], 0x34  ; *AI
  0x08AF8: cmp      byte ptr [bx + 0x543f], 0  ; ai_pers
  0x08AFD: jne      0x8b0a
  0x08AFF: mov      al, byte ptr [0x53a6]
  0x08B02: sub      ah, ah
  0x08B04: mov      word ptr [bp - 0x14], ax
  0x08B07: jmp      0x8b0f
  0x08B09: nop      
  0x08B0A: mov      word ptr [bp - 0x14], 0
  0x08B0F: mov      ax, word ptr [bp - 0x14]
  0x08B12: add      ax, 5
  0x08B15: mov      word ptr [bp - 0x10], ax
  0x08B18: mov      word ptr [bp - 0xe], ax
  0x08B1B: cmp      word ptr [0x8db8], 2  ; glob_8DB8
  0x08B20: jg       0x8b27
  0x08B22: shl      ax, 1
  0x08B24: mov      word ptr [bp - 0xe], ax
  0x08B27: cmp      word ptr [0x8db8], 1  ; glob_8DB8
  0x08B2C: jg       0x8b34
  0x08B2E: mov      ax, word ptr [bp - 0x10]
  0x08B31: add      word ptr [bp - 0xe], ax
  0x08B34: mov      ax, word ptr [bp - 0xe]
  0x08B37: mov      word ptr [bp - 0xa], ax
  0x08B3A: push     word ptr [bp - 4]
  0x08B3D: push     word ptr [bp - 2]
  0x08B40: lcall    0x37f, 0x4b0
  0x08B45: add      sp, 4
  0x08B48: inc      ax
  0x08B49: je       0x8b53
  0x08B4B: mov      ax, word ptr [bp - 0xa]
  0x08B4E: shl      ax, 1
  0x08B50: mov      word ptr [bp - 0xa], ax
  0x08B53: push     0
  0x08B55: push     word ptr [bp - 0xa]
  0x08B58: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08B5C: mov      al, byte ptr [bx + 0x1a]
  0x08B5F: sub      ah, ah
  0x08B61: push     ax
  0x08B62: mov      ax, word ptr [bp - 0x12]
  0x08B65: sub      ax, 4
  0x08B68: push     ax
  0x08B69: lcall    0x181f, 0xd6c
  0x08B6E: add      sp, 8
  0x08B71: mov      si, word ptr [bp + 6]
  0x08B74: mov      ax, si
  0x08B76: shl      si, 2
  0x08B79: add      si, ax
  0x08B7B: mov      bx, word ptr [bp + 8]
  0x08B7E: mov      byte ptr [bx + si - 0x7262], 0xff
  0x08B83: push     1
  0x08B85: push     word ptr [bp + 8]
  0x08B88: push     word ptr [bp + 6]
  0x08B8B: push     cs
  0x08B8C: call     0x8918
  0x08B8F: add      sp, 6
  0x08B92: pop      si
  0x08B93: pop      di
  0x08B94: leave    
  0x08B95: retf     

============================================================
func_L232 at file 0x08B96, 24 bytes
============================================================
  0x08B96: push     bp
  0x08B97: mov      bp, sp
  0x08B99: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x08B9D: mov      bl, byte ptr [bx + 0x3146]
  0x08BA1: sub      bh, bh
  0x08BA3: cmp      byte ptr [bx + 0x30e], bh
  0x08BA7: jl       0x8bae
  0x08BA9: mov      ax, 1
  0x08BAC: leave    
  0x08BAD: retf     

============================================================
func_L233 at file 0x08BB2, 20 bytes
============================================================
  0x08BB2: push     bp
  0x08BB3: mov      bp, sp
  0x08BB5: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x08BB9: mov      bl, byte ptr [bx + 0x3146]
  0x08BBD: sub      bh, bh
  0x08BBF: mov      al, byte ptr [bx + 0x30e]
  0x08BC3: cwde     
  0x08BC4: leave    
  0x08BC5: retf     

============================================================
func_L234 at file 0x08BC6, 13 bytes
============================================================
  0x08BC6: push     bp
  0x08BC7: mov      bp, sp
  0x08BC9: mov      bx, word ptr [bp + 6]
  0x08BCC: mov      al, byte ptr [bx + 0x2f5]
  0x08BD0: cwde     
  0x08BD1: leave    
  0x08BD2: retf     

============================================================
func_L235 at file 0x08BD4, 73 bytes
============================================================
  0x08BD4: enter    6, 0
  0x08BD8: mov      ax, 0xffff
  0x08BDB: mov      word ptr [bp - 6], ax
  0x08BDE: mov      word ptr [bp - 4], ax
  0x08BE1: mov      ax, word ptr [0x8d78]
  0x08BE4: jmp      0x8c11
  0x08BE6: cmp      word ptr [bp - 6], 0
  0x08BEA: jge      0x8c18
  0x08BEC: push     ax
  0x08BED: push     cs
  0x08BEE: call     0x8b96
  0x08BF1: add      sp, 2
  0x08BF4: or       ax, ax
  0x08BF6: je       0x8c09
  0x08BF8: mov      ax, word ptr [bp + 6]
  0x08BFB: inc      word ptr [bp - 4]
  0x08BFE: cmp      word ptr [bp - 4], ax
  0x08C01: jne      0x8c09
  0x08C03: mov      ax, word ptr [bp - 2]
  0x08C06: mov      word ptr [bp - 6], ax
  0x08C09: mov      ax, word ptr [bp - 2]
  0x08C0C: lcall    0x427, 0x4a
  0x08C11: mov      word ptr [bp - 2], ax
  0x08C14: or       ax, ax
  0x08C16: jge      0x8be6
  0x08C18: mov      ax, word ptr [bp - 6]
  0x08C1B: leave    
  0x08C1C: retf     

============================================================
func_L236 at file 0x08C1E, 81 bytes
============================================================
  0x08C1E: enter    6, 0
  0x08C22: mov      ax, 0xffff
  0x08C25: mov      word ptr [bp - 6], ax
  0x08C28: mov      word ptr [bp - 4], ax
  0x08C2B: mov      ax, word ptr [0x8d78]
  0x08C2E: jmp      0x8c63
  0x08C30: cmp      word ptr [bp - 6], 0
  0x08C34: jge      0x8c6a
  0x08C36: push     ax
  0x08C37: push     cs
  0x08C38: call     0x8b96
  0x08C3B: add      sp, 2
  0x08C3E: or       ax, ax
  0x08C40: je       0x8c5b
  0x08C42: inc      word ptr [bp - 4]
  0x08C45: mov      ax, word ptr [bp + 6]
  0x08C48: cmp      word ptr [bp - 2], ax
  0x08C4B: jne      0x8c5b
  0x08C4D: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08C51: mov      al, byte ptr [bx + 0x1f]
  0x08C54: cwde     
  0x08C55: add      ax, word ptr [bp - 4]
  0x08C58: mov      word ptr [bp - 6], ax
  0x08C5B: mov      ax, word ptr [bp - 2]
  0x08C5E: lcall    0x427, 0x4a
  0x08C63: mov      word ptr [bp - 2], ax
  0x08C66: or       ax, ax
  0x08C68: jge      0x8c30
  0x08C6A: mov      ax, word ptr [bp - 6]
  0x08C6D: leave    
  0x08C6E: retf     

============================================================
func_L237 at file 0x08C70, 66 bytes
============================================================
  0x08C70: enter    2, 0
  0x08C74: sub      ax, ax
  0x08C76: mov      word ptr [0x8d72], ax
  0x08C79: mov      word ptr [0x8d74], ax
  0x08C7C: mov      word ptr [0x8d76], ax
  0x08C7F: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08C83: mov      al, byte ptr [bx]
  0x08C85: sub      ah, ah
  0x08C87: mov      dl, byte ptr [bx + 1]
  0x08C8A: sub      dh, dh
  0x08C8C: lcall    0x427, 0x5c
  0x08C91: mov      word ptr [0x8d78], ax
  0x08C94: jmp      0x8cd3
  0x08C96: push     ax
  0x08C97: push     cs
  0x08C98: call     0x8b96
  0x08C9B: add      sp, 2
  0x08C9E: or       ax, ax
  0x08CA0: je       0x8ca6
  0x08CA2: inc      word ptr [0x8d72]
  0x08CA6: imul     bx, word ptr [bp - 2], 0x1c  ; *Unit
  0x08CAA: mov      bl, byte ptr [bx + 0x3146]
  0x08CAE: sub      bh, bh
  0x08CB0: mov      ax, bx

============================================================
func_L238 at file 0x08D00, 38 bytes
============================================================
  0x08D00: enter    2, 0
  0x08D04: mov      word ptr [bp - 2], 0x64
  0x08D09: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08D0D: cmp      byte ptr [bx + 0x95], 0
  0x08D12: je       0x8d21
  0x08D14: mov      al, byte ptr [bx + 0x95]
  0x08D18: sub      ah, ah
  0x08D1A: inc      ax
  0x08D1B: imul     ax, ax, 0x64
  0x08D1E: mov      word ptr [bp - 2], ax
  0x08D21: mov      ax, word ptr [bp - 2]
  0x08D24: leave    
  0x08D25: retf     

============================================================
func_L239 at file 0x08D26, 118 bytes
============================================================
  0x08D26: enter    4, 0
  0x08D2A: mov      word ptr [bp - 4], 0xffff
  0x08D2F: push     word ptr [bp + 8]
  0x08D32: push     word ptr [bp + 6]
  0x08D35: lcall    0x37f, 0xa
  0x08D3A: add      sp, 4
  0x08D3D: or       ax, ax
  0x08D3F: je       0x8d97
  0x08D41: push     word ptr [bp + 8]
  0x08D44: push     word ptr [bp + 6]
  0x08D47: lcall    0x37f, 0x358
  0x08D4C: add      sp, 4
  0x08D4F: or       ax, ax
  0x08D51: jl       0x8d97
  0x08D53: mov      word ptr [bp - 2], 0
  0x08D58: jmp      0x8d82
  0x08D5A: mov      ax, word ptr [0x539e]
  0x08D5D: cmp      word ptr [bp - 2], ax
  0x08D60: jge      0x8d88
  0x08D62: mov      al, byte ptr [bp + 6]
  0x08D65: imul     bx, word ptr [bp - 2], 0xca  ; *Colony
  0x08D6A: cmp      byte ptr [bx + 0x5d46], al
  0x08D6E: jne      0x8d7f
  0x08D70: mov      al, byte ptr [bp + 8]
  0x08D73: cmp      byte ptr [bx + 0x5d47], al
  0x08D77: jne      0x8d7f
  0x08D79: mov      ax, word ptr [bp - 2]
  0x08D7C: mov      word ptr [bp - 4], ax
  0x08D7F: inc      word ptr [bp - 2]
  0x08D82: cmp      word ptr [bp - 4], 0
  0x08D86: jl       0x8d5a
  0x08D88: cmp      word ptr [bp - 4], 0
  0x08D8C: jge      0x8d97
  0x08D8E: lea      bx, [0x350]
  0x08D92: lcall    0x181f, 0x3fe
  0x08D97: mov      ax, word ptr [bp - 4]
  0x08D9A: leave    
  0x08D9B: retf     

============================================================
func_L240 at file 0x08D9C, 31 bytes
============================================================
  0x08D9C: enter    2, 0
  0x08DA0: mov      word ptr [bp - 2], 0xffff
  0x08DA5: cmp      word ptr [bp + 6], 0x13
  0x08DA9: jge      0x8db6
  0x08DAB: mov      bx, word ptr [bp + 6]
  0x08DAE: mov      al, byte ptr [bx + 0x2f4]
  0x08DB2: cwde     
  0x08DB3: mov      word ptr [bp - 2], ax
  0x08DB6: mov      ax, word ptr [bp - 2]
  0x08DB9: leave    
  0x08DBA: retf     

============================================================
func_L241 at file 0x08DBC, 69 bytes
============================================================
  0x08DBC: enter    2, 0
  0x08DC0: mov      bx, word ptr [bp + 6]
  0x08DC3: shl      bx, 1
  0x08DC5: mov      ax, word ptr [bx - 0x7238]
  0x08DC9: sub      ax, word ptr [bx - 0x71f6]
  0x08DCD: mov      word ptr [bp - 2], ax
  0x08DD0: mov      bx, word ptr [bp + 6]
  0x08DD3: cmp      byte ptr [bx + 0x2a2], 0
  0x08DD8: jl       0x8dfc
  0x08DDA: mov      al, byte ptr [bx + 0x2a2]
  0x08DDE: cwde     
  0x08DDF: mov      bx, ax
  0x08DE1: shl      bx, 1
  0x08DE3: mov      ax, word ptr [bp - 2]
  0x08DE6: sub      ax, word ptr [bx - 0x71a6]
  0x08DEA: mov      word ptr [bp - 2], ax
  0x08DED: cmp      word ptr [bp + 8], 0
  0x08DF1: je       0x8dfc
  0x08DF3: mov      ax, word ptr [bx - 0x71a6]
  0x08DF7: mov      bx, word ptr [bp + 8]
  0x08DFA: mov      word ptr [bx], ax
  0x08DFC: mov      ax, word ptr [bp - 2]
  0x08DFF: leave    
  0x08E00: retf     

============================================================
func_L242 at file 0x08E02, 68 bytes
============================================================
  0x08E02: push     bp
  0x08E03: mov      bp, sp
  0x08E05: sub      ax, ax
  0x08E07: mov      bx, word ptr [bp + 6]
  0x08E0A: shl      bx, 1
  0x08E0C: mov      word ptr [bx - 0x71ce], ax
  0x08E10: mov      word ptr [bx - 0x71a6], ax
  0x08E14: mov      ax, word ptr [bp + 0xa]
  0x08E17: mov      word ptr [bx - 0x71f6], ax
  0x08E1B: cmp      ax, word ptr [bp + 8]
  0x08E1E: jle      0x8e27
  0x08E20: sub      ax, word ptr [bp + 8]
  0x08E23: mov      word ptr [bx - 0x71ce], ax
  0x08E27: mov      ax, word ptr [bp + 0xc]
  0x08E2A: add      ax, word ptr [bp + 8]
  0x08E2D: cmp      ax, word ptr [bp + 0xa]
  0x08E30: jge      0x8e44
  0x08E32: mov      ax, word ptr [bp + 0xa]
  0x08E35: sub      ax, word ptr [bp + 0xc]
  0x08E38: sub      ax, word ptr [bp + 8]
  0x08E3B: mov      bx, word ptr [bp + 6]
  0x08E3E: shl      bx, 1
  0x08E40: mov      word ptr [bx - 0x71a6], ax
  0x08E44: leave    
  0x08E45: retf     

============================================================
func_L243 at file 0x08E46, 61 bytes
============================================================
  0x08E46: enter    2, 0
  0x08E4A: push     si
  0x08E4B: mov      bx, word ptr [bp + 6]
  0x08E4E: shl      bx, 1
  0x08E50: mov      ax, word ptr [bx - 0x7238]
  0x08E54: cmp      word ptr [bp + 6], 0xe
  0x08E58: jne      0x8e65
  0x08E5A: cmp      word ptr [0x8e66], 0
  0x08E5F: je       0x8e65
  0x08E61: sub      ax, word ptr [0x8e66]
  0x08E65: mov      si, word ptr [bp + 6]
  0x08E68: shl      si, 1
  0x08E6A: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08E6E: push     word ptr [bx + si + 0x9a]
  0x08E72: push     word ptr [bp + 8]
  0x08E75: push     ax
  0x08E76: push     word ptr [bp + 6]
  0x08E79: push     cs
  0x08E7A: call     0x8e02
  0x08E7D: add      sp, 8
  0x08E80: pop      si
  0x08E81: leave    
  0x08E82: retf     

============================================================
func_L244 at file 0x08E84, 126 bytes
============================================================
  0x08E84: enter    6, 0
  0x08E88: mov      bx, word ptr [bp + 8]
  0x08E8B: shl      bx, 1
  0x08E8D: mov      ax, word ptr [bx - 0x7238]
  0x08E91: mov      word ptr [bp - 6], ax
  0x08E94: mov      word ptr [bp - 4], ax
  0x08E97: push     word ptr [bp + 8]
  0x08E9A: push     cs
  0x08E9B: call     0x8d9c
  0x08E9E: add      sp, 2
  0x08EA1: push     ax
  0x08EA2: push     cs
  0x08EA3: call     0x864e
  0x08EA6: add      sp, 2
  0x08EA9: cmp      ax, 2
  0x08EAC: jle      0x8ebc
  0x08EAE: mov      ax, word ptr [bp - 4]
  0x08EB1: shl      ax, 1
  0x08EB3: mov      cx, 3
  0x08EB6: cdq      
  0x08EB7: idiv     cx
  0x08EB9: mov      word ptr [bp - 4], ax
  0x08EBC: push     word ptr [bp - 4]
  0x08EBF: push     word ptr [bp + 6]
  0x08EC2: push     cs
  0x08EC3: call     0x8e46
  0x08EC6: add      sp, 4
  0x08EC9: mov      bx, word ptr [bp + 6]
  0x08ECC: shl      bx, 1
  0x08ECE: cmp      word ptr [bx - 0x71a6], 0
  0x08ED3: je       0x8f00
  0x08ED5: mov      ax, word ptr [bp - 4]
  0x08ED8: cmp      word ptr [bp - 6], ax
  0x08EDB: je       0x8f00
  0x08EDD: cmp      word ptr [bx - 0x71a6], ax
  0x08EE1: jne      0x8ee8
  0x08EE3: mov      ax, word ptr [bp - 6]
  0x08EE6: jmp      0x8efc
  0x08EE8: mov      bx, word ptr [bp + 6]
  0x08EEB: shl      bx, 1
  0x08EED: mov      ax, word ptr [bx - 0x71a6]
  0x08EF1: mov      cx, ax
  0x08EF3: shl      ax, 1
  0x08EF5: add      ax, cx
  0x08EF7: cdq      
  0x08EF8: sub      ax, dx
  0x08EFA: sar      ax, 1
  0x08EFC: mov      word ptr [bx - 0x71a6], ax
  0x08F00: leave    
  0x08F01: retf     

============================================================
func_L245 at file 0x08F02, 33 bytes
============================================================
  0x08F02: push     bp
  0x08F03: mov      bp, sp
  0x08F05: push     si
  0x08F06: mov      si, word ptr [bp + 6]
  0x08F09: shl      si, 1
  0x08F0B: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08F0F: mov      ax, word ptr [bx + si + 0x9a]
  0x08F13: add      ax, word ptr [si - 0x7238]
  0x08F17: cmp      ax, word ptr [si - 0x71f6]
  0x08F1B: jle      0x8f24
  0x08F1D: mov      ax, 1
  0x08F20: pop      si
  0x08F21: leave    
  0x08F22: retf     

============================================================
func_L246 at file 0x08F2A, 53 bytes
============================================================
  0x08F2A: enter    2, 0
  0x08F2E: push     si
  0x08F2F: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08F33: mov      al, byte ptr [bx + 0x1f]
  0x08F36: cwde     
  0x08F37: cmp      ax, word ptr [bp + 6]
  0x08F3A: jle      0x8f60
  0x08F3C: mov      si, word ptr [bp + 6]
  0x08F3F: sar      si, 1
  0x08F41: mov      al, byte ptr [bx + si + 0x60]
  0x08F44: sub      ah, ah
  0x08F46: mov      word ptr [bp - 2], ax
  0x08F49: test     byte ptr [bp + 6], 1
  0x08F4D: je       0x8f55
  0x08F4F: sar      ax, 4
  0x08F52: mov      word ptr [bp - 2], ax
  0x08F55: and      word ptr [bp - 2], 0xf
  0x08F59: mov      ax, word ptr [bp - 2]
  0x08F5C: pop      si
  0x08F5D: leave    
  0x08F5E: retf     

============================================================
func_L247 at file 0x08F6C, 72 bytes
============================================================
  0x08F6C: enter    2, 0
  0x08F70: push     si
  0x08F71: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08F75: mov      al, byte ptr [bx + 0x1f]
  0x08F78: cwde     
  0x08F79: cmp      ax, word ptr [bp + 6]
  0x08F7C: jle      0x8fb1
  0x08F7E: mov      word ptr [bp - 2], 0xf0
  0x08F83: mov      ax, word ptr [bp + 8]
  0x08F86: cmp      ax, 0xf
  0x08F89: jle      0x8f8e
  0x08F8B: mov      ax, 0xf
  0x08F8E: mov      word ptr [bp + 8], ax
  0x08F91: test     byte ptr [bp + 6], 1
  0x08F95: je       0x8fa0
  0x08F97: mov      word ptr [bp - 2], 0xf
  0x08F9C: shl      word ptr [bp + 8], 4
  0x08FA0: mov      al, byte ptr [bp - 2]
  0x08FA3: mov      si, word ptr [bp + 6]
  0x08FA6: sar      si, 1
  0x08FA8: and      byte ptr [bx + si + 0x60], al
  0x08FAB: mov      al, byte ptr [bp + 8]
  0x08FAE: or       byte ptr [bx + si + 0x60], al
  0x08FB1: pop      si
  0x08FB2: leave    
  0x08FB3: retf     

============================================================
func_L248 at file 0x08FB4, 69 bytes
============================================================
  0x08FB4: enter    4, 0
  0x08FB8: push     si
  0x08FB9: mov      ax, word ptr [bp + 6]
  0x08FBC: mov      word ptr [bp - 4], ax
  0x08FBF: jmp      0x8feb
  0x08FC1: nop      
  0x08FC2: add      bx, word ptr [bp - 4]
  0x08FC5: mov      al, byte ptr [bx + 0x21]
  0x08FC8: mov      byte ptr [bx + 0x20], al
  0x08FCB: mov      al, byte ptr [bx + 0x41]
  0x08FCE: mov      byte ptr [bx + 0x40], al
  0x08FD1: mov      ax, word ptr [bp - 4]
  0x08FD4: inc      ax
  0x08FD5: push     ax
  0x08FD6: push     cs
  0x08FD7: call     0x8f2a
  0x08FDA: add      sp, 2
  0x08FDD: push     ax
  0x08FDE: push     word ptr [bp - 4]
  0x08FE1: push     cs
  0x08FE2: call     0x8f6c
  0x08FE5: add      sp, 4
  0x08FE8: inc      word ptr [bp - 4]
  0x08FEB: mov      bx, word ptr [0x8542]  ; cur_nation
  0x08FEF: mov      al, byte ptr [bx + 0x1f]
  0x08FF2: cwde     
  0x08FF3: dec      ax
  0x08FF4: cmp      ax, word ptr [bp - 4]
  0x08FF7: jg       0x8fc2

============================================================
func_L249 at file 0x0903E, 37 bytes
============================================================
  0x0903E: enter    2, 0
  0x09042: push     si
  0x09043: mov      word ptr [bp - 2], 0
  0x09048: mov      ax, word ptr [bp + 8]
  0x0904B: jmp      0x90a6
  0x0904D: nop      
  0x0904E: mov      bx, word ptr [bp - 2]
  0x09051: shl      bx, 1
  0x09053: mov      si, word ptr [bp + 6]
  0x09056: mov      word ptr [bx + si], 0xf
  0x0905A: inc      word ptr [bp - 2]
  0x0905D: mov      ax, word ptr [bp - 2]
  0x09060: pop      si
  0x09061: leave    
  0x09062: retf     

============================================================
func_L250 at file 0x090C8, 29 bytes
============================================================
  0x090C8: enter    2, 0
  0x090CC: push     si
  0x090CD: mov      bx, word ptr [0x8542]  ; cur_nation
  0x090D1: mov      al, byte ptr [bx + 0x1f]
  0x090D4: cwde     
  0x090D5: cmp      ax, word ptr [bp + 6]
  0x090D8: jle      0x90e6
  0x090DA: mov      si, word ptr [bp + 6]
  0x090DD: mov      al, byte ptr [bx + si + 0x20]
  0x090E0: sub      ah, ah
  0x090E2: pop      si
  0x090E3: leave    
  0x090E4: retf     

============================================================
func_L251 at file 0x09102, 29 bytes
============================================================
  0x09102: enter    2, 0
  0x09106: push     si
  0x09107: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0910B: mov      al, byte ptr [bx + 0x1f]
  0x0910E: cwde     
  0x0910F: cmp      ax, word ptr [bp + 6]
  0x09112: jle      0x9120
  0x09114: mov      si, word ptr [bp + 6]
  0x09117: mov      al, byte ptr [bx + si + 0x40]
  0x0911A: sub      ah, ah
  0x0911C: pop      si
  0x0911D: leave    
  0x0911E: retf     

============================================================
func_L252 at file 0x0913C, 41 bytes
============================================================
  0x0913C: enter    2, 0
  0x09140: push     si
  0x09141: cmp      word ptr [bp + 8], 0x17
  0x09145: jne      0x914c
  0x09147: mov      word ptr [bp + 8], 0x15
  0x0914C: mov      bx, word ptr [0x8542]  ; cur_nation
  0x09150: mov      al, byte ptr [bx + 0x1f]
  0x09153: cwde     
  0x09154: cmp      ax, word ptr [bp + 6]
  0x09157: jle      0x9166
  0x09159: mov      al, byte ptr [bp + 8]
  0x0915C: mov      si, word ptr [bp + 6]
  0x0915F: mov      byte ptr [bx + si + 0x40], al
  0x09162: pop      si
  0x09163: leave    
  0x09164: retf     

============================================================
func_L253 at file 0x09184, 29 bytes
============================================================
  0x09184: enter    4, 0
  0x09188: push     word ptr [bp + 6]
  0x0918B: push     cs
  0x0918C: call     0x8f2a
  0x0918F: add      sp, 2
  0x09192: cmp      ax, 0xf
  0x09195: jl       0x91a2
  0x09197: mov      word ptr [bp - 4], 3
  0x0919C: mov      ax, word ptr [bp - 4]
  0x0919F: leave    
  0x091A0: retf     

============================================================
func_L254 at file 0x091CC, 181 bytes
============================================================
  0x091CC: enter    8, 0
  0x091D0: push     word ptr [bp + 6]
  0x091D3: push     cs
  0x091D4: call     0x90c8
  0x091D7: add      sp, 2
  0x091DA: mov      word ptr [bp - 8], ax
  0x091DD: push     word ptr [bp + 6]
  0x091E0: push     cs
  0x091E1: call     0x9102
  0x091E4: add      sp, 2
  0x091E7: mov      word ptr [bp - 6], ax
  0x091EA: cmp      word ptr [bp - 8], 0x13
  0x091EE: jg       0x9206
  0x091F0: cmp      ax, 0x1c
  0x091F3: jne      0x91fa
  0x091F5: mov      word ptr [bp - 6], 0x13
  0x091FA: mov      ax, word ptr [bp - 6]
  0x091FD: lcall    0x12b, 2
  0x09202: jmp      0x9291
  0x09205: nop      
  0x09206: mov      ax, word ptr [bp - 8]
  0x09209: add      ax, 0x52
  0x0920C: mov      word ptr [bp - 4], ax
  0x0920F: mov      ax, word ptr [bp - 8]
  0x09212: cmp      word ptr [bp - 6], ax
  0x09215: jne      0x921c
  0x09217: mov      ax, 1
  0x0921A: jmp      0x921e
  0x0921C: sub      ax, ax
  0x0921E: mov      word ptr [bp - 2], ax
  0x09221: cmp      word ptr [bp - 6], 0x15
  0x09225: jne      0x9232
  0x09227: cmp      word ptr [bp - 8], 0x17
  0x0922B: jne      0x9232
  0x0922D: mov      word ptr [bp - 2], 1
  0x09232: cmp      word ptr [bp - 2], 0
  0x09236: jne      0x9241
  0x09238: mov      ax, word ptr [bp - 8]
  0x0923B: add      ax, 0x36
  0x0923E: mov      word ptr [bp - 4], ax
  0x09241: cmp      word ptr [bp - 8], 0x15
  0x09245: je       0x924d
  0x09247: cmp      word ptr [bp - 8], 0x17
  0x0924B: jne      0x9294
  0x0924D: mov      bx, word ptr [0x8542]  ; cur_nation
  0x09251: mov      al, byte ptr [bx + 0x1f]
  0x09254: cwde     
  0x09255: sub      ax, word ptr [bp + 6]
  0x09258: neg      ax
  0x0925A: push     ax
  0x0925B: push     cs
  0x0925C: call     0x8bd4
  0x0925F: add      sp, 2
  0x09262: mov      word ptr [bp + 6], ax
  0x09265: imul     bx, ax, 0x1c  ; *Unit
  0x09268: cmp      byte ptr [bx + 0x3146], 9
  0x0926D: je       0x9276
  0x0926F: cmp      byte ptr [bx + 0x3146], 7
  0x09274: jne      0x9294
  0x09276: imul     bx, ax, 0x1c  ; *Unit
  0x09279: mov      bl, byte ptr [bx + 0x3146]
  0x0927D: sub      bh, bh
  0x0927F: mov      ax, bx

============================================================
func_L255 at file 0x0929A, 33 bytes
============================================================
  0x0929A: enter    2, 0
  0x0929E: mov      bx, word ptr [0x8542]  ; cur_nation
  0x092A2: mov      al, byte ptr [bx + 0x1f]
  0x092A5: cwde     
  0x092A6: cmp      ax, word ptr [bp + 6]
  0x092A9: jle      0x92c6
  0x092AB: cmp      word ptr [bp + 8], 0x13
  0x092AF: jge      0x92bc
  0x092B1: mov      word ptr [bp - 2], 0
  0x092B6: mov      ax, word ptr [bp - 2]
  0x092B9: leave    
  0x092BA: retf     

============================================================
func_L256 at file 0x092E0, 44 bytes
============================================================
  0x092E0: enter    6, 0
  0x092E4: mov      cl, byte ptr [bp + 6]
  0x092E7: and      cl, 7
  0x092EA: mov      ax, 1
  0x092ED: shl      ax, cl
  0x092EF: mov      word ptr [bp - 4], ax
  0x092F2: mov      cx, word ptr [bp + 6]
  0x092F5: sar      cx, 3
  0x092F8: add      cx, word ptr [0x8542]  ; cur_nation
  0x092FC: add      cx, 0x84
  0x09300: cmp      word ptr [bp + 8], 0
  0x09304: je       0x930c
  0x09306: mov      bx, cx
  0x09308: or       byte ptr [bx], al
  0x0930A: leave    
  0x0930B: retf     

============================================================
func_L257 at file 0x09318, 782 bytes
============================================================
  0x09318: enter    0x2c, 0
  0x0931C: push     si
  0x0931D: mov      word ptr [bp - 0x1c], 0
  0x09322: mov      ax, word ptr [bp + 8]
  0x09325: mov      word ptr [bp - 0x2c], ax
  0x09328: cmp      ax, 0x17
  0x0932B: jne      0x9332
  0x0932D: mov      word ptr [bp - 0x2c], 0x15
  0x09332: push     word ptr [bp + 6]
  0x09335: push     cs
  0x09336: call     0x90c8
  0x09339: add      sp, 2
  0x0933C: mov      word ptr [bp - 0x1e], ax
  0x0933F: push     ax
  0x09340: lea      ax, [bp - 0x28]
  0x09343: push     ax
  0x09344: push     cs
  0x09345: call     0x903e
  0x09348: add      sp, 4
  0x0934B: mov      word ptr [bp - 0x22], ax
  0x0934E: mov      word ptr [bp - 0x20], 0
  0x09353: jmp      0x937b
  0x09355: nop      
  0x09356: imul     bx, word ptr [bp - 0x18], 0x1c  ; *Unit
  0x0935A: mov      al, byte ptr [bx + 0x3159]
  0x0935E: sub      ah, ah
  0x09360: mov      word ptr [bp - 6], ax
  0x09363: mov      ax, word ptr [bp - 6]
  0x09366: mov      si, word ptr [bp - 0x20]
  0x09369: shl      si, 1
  0x0936B: mov      si, word ptr [bp + si - 0x28]
  0x0936E: shl      si, 1
  0x09370: mov      bx, word ptr [0x8542]  ; cur_nation
  0x09374: add      word ptr [bx + si + 0x9a], ax
  0x09378: inc      word ptr [bp - 0x20]
  0x0937B: mov      ax, word ptr [bp - 0x22]
  0x0937E: cmp      word ptr [bp - 0x20], ax
  0x09381: jge      0x93c0
  0x09383: mov      bx, word ptr [0x8542]  ; cur_nation
  0x09387: mov      al, byte ptr [bx + 0x1f]
  0x0938A: cwde     
  0x0938B: sub      ax, word ptr [bp + 6]
  0x0938E: neg      ax
  0x09390: push     ax
  0x09391: push     cs
  0x09392: call     0x8bd4
  0x09395: add      sp, 2
  0x09398: mov      word ptr [bp - 0x18], ax
  0x0939B: mov      si, word ptr [bp - 0x20]
  0x0939E: shl      si, 1
  0x093A0: mov      ax, word ptr [bp + si - 0x28]
  0x093A3: cmp      ax, 0xe
  0x093A6: je       0x9356
  0x093A8: ja       0x93b0
  0x093AA: or       al, al
  0x093AC: je       0x93b8
  0x093AE: sub      al, 8
  0x093B0: mov      word ptr [bp - 6], 0x32
  0x093B5: jmp      0x9363
  0x093B7: nop      
  0x093B8: mov      word ptr [bp - 6], 0
  0x093BD: jmp      0x9363
  0x093BF: nop      
  0x093C0: push     0x10
  0x093C2: push     0
  0x093C4: lea      ax, [bp - 0x16]
  0x093C7: push     ax
  0x093C8: lcall    0xd1d, 0xdae
  0x093CD: add      sp, 6
  0x093D0: mov      bx, word ptr [0x8542]  ; cur_nation
  0x093D4: mov      ax, word ptr [bx + 0xb6]
  0x093D8: mov      cx, 0x14
  0x093DB: cdq      
  0x093DC: idiv     cx
  0x093DE: mov      word ptr [bp - 6], ax
  0x093E1: imul     ax, ax, 0x14
  0x093E4: cmp      ax, 0x64
  0x093E7: jle      0x93ec
  0x093E9: mov      ax, 0x64
  0x093EC: mov      byte ptr [bp - 8], al
  0x093EF: mov      al, 0x32
  0x093F1: mov      byte ptr [bp - 7], al
  0x093F4: mov      byte ptr [bp - 0xe], al
  0x093F7: mov      ax, word ptr [bp - 0x1e]
  0x093FA: cmp      word ptr [bp + 8], ax
  0x093FD: je       0x940b
  0x093FF: push     0
  0x09401: push     word ptr [bp + 6]
  0x09404: push     cs
  0x09405: call     0x8f6c
  0x09408: add      sp, 4
  0x0940B: push     word ptr [bp + 8]
  0x0940E: push     word ptr [bp + 6]
  0x09411: push     cs
  0x09412: call     0x929a
  0x09415: add      sp, 4
  0x09418: mov      word ptr [bp - 4], ax
  0x0941B: or       ax, ax
  0x0941D: jne      0x9422
  0x0941F: jmp      0x94d6
  0x09422: dec      ax
  0x09423: jne      0x9428
  0x09425: jmp      0x9576
  0x09428: dec      ax
  0x09429: jne      0x942e
  0x0942B: jmp      0x9500
  0x0942E: mov      bx, word ptr [0x8542]  ; cur_nation
  0x09432: cmp      byte ptr [bx + 0x1f], 0x20
  0x09436: jl       0x943b
  0x09438: jmp      0x95c2
  0x0943B: mov      al, byte ptr [bx + 0x1f]
  0x0943E: cwde     
  0x0943F: sub      ax, word ptr [bp + 6]
  0x09442: neg      ax
  0x09444: push     ax
  0x09445: push     cs
  0x09446: call     0x8bd4
  0x09449: add      sp, 2
  0x0944C: mov      word ptr [bp - 0x18], ax
  0x0944F: mov      bx, word ptr [0x8542]  ; cur_nation
  0x09453: add      word ptr [bx + 0xc6], 0x64
  0x09458: adc      word ptr [bx + 0xc8], 0
  0x0945D: mov      al, byte ptr [bx + 0x1f]
  0x09460: cwde     
  0x09461: mov      word ptr [bp - 0x1a], ax
  0x09464: inc      byte ptr [bx + 0x1f]
  0x09467: push     word ptr [bp + 8]
  0x0946A: push     word ptr [bp - 0x1a]
  0x0946D: push     cs
  0x0946E: call     0x9318
  0x09471: add      sp, 4
  0x09474: imul     bx, word ptr [bp - 0x18], 0x1c  ; *Unit
  0x09478: mov      al, byte ptr [bx + 0x315b]
  0x0947C: cwde     
  0x0947D: push     ax
  0x0947E: push     word ptr [bp - 0x1a]
  0x09481: push     cs
  0x09482: call     0x913c
  0x09485: add      sp, 4
  0x09488: push     word ptr [bp - 0x18]
  0x0948B: lcall    0x427, 0x824
  0x09490: add      sp, 2
  0x09493: mov      ax, word ptr [bp - 0x1a]
  0x09496: mov      word ptr [bp - 0x2a], ax
  0x09499: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0949D: cmp      byte ptr [bx + 0x1f], 3
  0x094A1: jge      0x94a6
  0x094A3: jmp      0x956e
  0x094A6: cmp      word ptr [0x35c], 0
  0x094AB: je       0x94b0
  0x094AD: jmp      0x956e
  0x094B0: push     9
  0x094B2: mov      al, byte ptr [bx + 0x1a]
  0x094B5: sub      ah, ah
  0x094B7: push     ax
  0x094B8: lcall    0x981, 0
  0x094BD: add      sp, 4
  0x094C0: or       ax, ax
  0x094C2: jne      0x94c7
  0x094C4: jmp      0x956e
  0x094C7: push     1
  0x094C9: push     0
  0x094CB: push     cs
  0x094CC: call     0x92e0
  0x094CF: add      sp, 4
  0x094D2: jmp      0x956e
  0x094D5: nop      
  0x094D6: mov      al, byte ptr [bp + 8]
  0x094D9: mov      bx, word ptr [0x8542]  ; cur_nation
  0x094DD: mov      si, word ptr [bp + 6]
  0x094E0: mov      byte ptr [bx + si + 0x20], al
  0x094E3: mov      word ptr [bp - 0x2a], si
  0x094E6: push     word ptr [bp + 8]
  0x094E9: lea      ax, [bp - 0x28]
  0x094EC: push     ax
  0x094ED: push     cs
  0x094EE: call     0x903e
  0x094F1: add      sp, 4
  0x094F4: mov      word ptr [bp - 0x22], ax
  0x094F7: mov      word ptr [bp - 0x20], 0
  0x094FC: jmp      0x95d1
  0x094FF: nop      
  0x09500: mov      bx, word ptr [0x8542]  ; cur_nation
  0x09504: mov      al, byte ptr [bx + 1]
  0x09507: sub      ah, ah
  0x09509: push     ax
  0x0950A: mov      al, byte ptr [bx]
  0x0950C: push     ax
  0x0950D: mov      al, byte ptr [bx + 0x1a]
  0x09510: push     ax
  0x09511: push     word ptr [bp + 8]
  0x09514: push     cs
  0x09515: call     0x8bc6
  0x09518: add      sp, 2
  0x0951B: push     ax
  0x0951C: lcall    0x427, 0x6b4
  0x09521: add      sp, 8
  0x09524: mov      word ptr [bp - 0x18], ax
  0x09527: or       ax, ax
  0x09529: jl       0x94e6
  0x0952B: push     ax
  0x0952C: lcall    0x427, 0x155e
  0x09531: add      sp, 2
  0x09534: push     word ptr [bp + 6]
  0x09537: push     cs
  0x09538: call     0x9102
  0x0953B: add      sp, 2
  0x0953E: mov      word ptr [bp - 2], ax
  0x09541: mov      al, byte ptr [bp - 2]
  0x09544: imul     bx, word ptr [bp - 0x18], 0x1c  ; *Unit
  0x09548: mov      byte ptr [bx + 0x315b], al
  0x0954C: cmp      word ptr [bp + 8], 0x14
  0x09550: jne      0x9559
  0x09552: mov      al, byte ptr [bp - 8]
  0x09555: mov      byte ptr [bx + 0x3159], al
  0x09559: push     word ptr [bp + 6]
  0x0955C: push     cs
  0x0955D: call     0x8fb4
  0x09560: add      sp, 2
  0x09563: mov      bx, word ptr [0x8542]  ; cur_nation
  0x09567: mov      al, byte ptr [bx + 0x1f]
  0x0956A: cwde     
  0x0956B: mov      word ptr [bp - 0x2a], ax
  0x0956E: push     cs
  0x0956F: call     0x8c70
  0x09572: jmp      0x94e6
  0x09575: nop      
  0x09576: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0957A: mov      al, byte ptr [bx + 0x1f]
  0x0957D: cwde     
  0x0957E: sub      ax, word ptr [bp + 6]
  0x09581: neg      ax
  0x09583: push     ax
  0x09584: push     cs
  0x09585: call     0x8bd4
  0x09588: add      sp, 2
  0x0958B: mov      word ptr [bp - 0x18], ax
  0x0958E: push     word ptr [bp + 8]
  0x09591: push     cs
  0x09592: call     0x8bc6
  0x09595: add      sp, 2
  0x09598: imul     bx, word ptr [bp - 0x18], 0x1c  ; *Unit
  0x0959C: mov      byte ptr [bx + 0x3146], al
  0x095A0: mov      byte ptr [bx + 0x314c], 0
  0x095A5: cmp      word ptr [bp + 8], 0x14
  0x095A9: jne      0x95b2
  0x095AB: mov      al, byte ptr [bp - 8]
  0x095AE: mov      byte ptr [bx + 0x3159], al
  0x095B2: push     word ptr [bp - 0x18]
  0x095B5: lcall    0x427, 0x155e
  0x095BA: add      sp, 2
  0x095BD: mov      ax, word ptr [bp + 6]
  0x095C0: jmp      0x956b
  0x095C2: mov      al, byte ptr [bx + 0x1f]
  0x095C5: cwde     
  0x095C6: dec      ax
  0x095C7: mov      word ptr [bp - 0x1a], ax
  0x095CA: jmp      0x94e6
  0x095CD: nop      
  0x095CE: inc      word ptr [bp - 0x20]
  0x095D1: mov      ax, word ptr [bp - 0x22]
  0x095D4: cmp      word ptr [bp - 0x20], ax
  0x095D7: jge      0x9610
  0x095D9: mov      si, word ptr [bp - 0x20]
  0x095DC: shl      si, 1
  0x095DE: mov      si, word ptr [bp + si - 0x28]
  0x095E1: mov      al, byte ptr [bp + si - 0x16]
  0x095E4: sub      ah, ah
  0x095E6: mov      word ptr [bp - 6], ax
  0x095E9: or       si, si
  0x095EB: jne      0x95f0
  0x095ED: mov      word ptr [bp - 0x1c], si
  0x095F0: mov      si, word ptr [bp - 0x20]
  0x095F3: shl      si, 1
  0x095F5: mov      si, word ptr [bp + si - 0x28]
  0x095F8: shl      si, 1
  0x095FA: mov      bx, word ptr [0x8542]  ; cur_nation
  0x095FE: mov      ax, word ptr [bx + si + 0x9a]
  0x09602: sub      ax, word ptr [bp - 6]
  0x09605: jns      0x9609
  0x09607: sub      ax, ax
  0x09609: mov      word ptr [bx + si + 0x9a], ax
  0x0960D: jmp      0x95ce
  0x0960F: nop      
  0x09610: mov      bx, word ptr [0x8542]  ; cur_nation
  0x09614: cmp      byte ptr [bx + 0x1f], 0
  0x09618: jne      0x9620
  0x0961A: mov      word ptr [0x348], 1
  0x09620: mov      ax, word ptr [bp - 0x2a]
  0x09623: pop      si
  0x09624: leave    
  0x09625: retf     

============================================================
func_L258 at file 0x09626, 53 bytes
============================================================
  0x09626: enter    4, 0
  0x0962A: sub      ax, ax
  0x0962C: mov      word ptr [bp - 2], ax
  0x0962F: mov      word ptr [bp - 4], ax
  0x09632: jmp      0x9649
  0x09634: push     word ptr [bp - 4]
  0x09637: push     cs
  0x09638: call     0x90c8
  0x0963B: add      sp, 2
  0x0963E: cmp      ax, word ptr [bp + 6]
  0x09641: jne      0x9646
  0x09643: inc      word ptr [bp - 2]
  0x09646: inc      word ptr [bp - 4]
  0x09649: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0964D: mov      al, byte ptr [bx + 0x1f]
  0x09650: cwde     
  0x09651: cmp      ax, word ptr [bp - 4]
  0x09654: jg       0x9634
  0x09656: mov      ax, word ptr [bp - 2]
  0x09659: leave    
  0x0965A: retf     

============================================================
func_L259 at file 0x0965C, 53 bytes
============================================================
  0x0965C: enter    4, 0
  0x09660: sub      ax, ax
  0x09662: mov      word ptr [bp - 2], ax
  0x09665: mov      word ptr [bp - 4], ax
  0x09668: jmp      0x967f
  0x0966A: push     word ptr [bp - 4]
  0x0966D: push     cs
  0x0966E: call     0x9102
  0x09671: add      sp, 2
  0x09674: cmp      ax, word ptr [bp + 6]
  0x09677: jne      0x967c
  0x09679: inc      word ptr [bp - 2]
  0x0967C: inc      word ptr [bp - 4]
  0x0967F: mov      bx, word ptr [0x8542]  ; cur_nation
  0x09683: mov      al, byte ptr [bx + 0x1f]
  0x09686: cwde     
  0x09687: cmp      ax, word ptr [bp - 4]
  0x0968A: jg       0x966a
  0x0968C: mov      ax, word ptr [bp - 2]
  0x0968F: leave    
  0x09690: retf     

============================================================
func_L260 at file 0x09692, 67 bytes
============================================================
  0x09692: enter    8, 0
  0x09696: sub      ax, ax
  0x09698: mov      word ptr [bp - 2], ax
  0x0969B: mov      word ptr [bp - 4], ax
  0x0969E: jmp      0x96c8
  0x096A0: push     word ptr [bp - 4]
  0x096A3: push     cs
  0x096A4: call     0x9102
  0x096A7: add      sp, 2
  0x096AA: mov      word ptr [bp - 8], ax
  0x096AD: push     word ptr [bp - 4]
  0x096B0: push     cs
  0x096B1: call     0x90c8
  0x096B4: add      sp, 2
  0x096B7: cmp      word ptr [bp - 8], 0x13
  0x096BB: jge      0x96c5
  0x096BD: cmp      word ptr [bp - 8], ax
  0x096C0: jne      0x96c5
  0x096C2: inc      word ptr [bp - 2]
  0x096C5: inc      word ptr [bp - 4]
  0x096C8: mov      bx, word ptr [0x8542]  ; cur_nation
  0x096CC: mov      al, byte ptr [bx + 0x1f]
  0x096CF: cwde     
  0x096D0: cmp      ax, word ptr [bp - 4]
  0x096D3: jg       0x96a0

============================================================
func_L261 at file 0x096DA, 75 bytes
============================================================
  0x096DA: enter    6, 0
  0x096DE: push     si
  0x096DF: mov      ax, 0xffff
  0x096E2: mov      word ptr [bp - 6], ax
  0x096E5: mov      word ptr [bp - 4], ax
  0x096E8: mov      word ptr [bp - 2], 0
  0x096ED: jmp      0x9719
  0x096EF: nop      
  0x096F0: mov      bx, word ptr [0x8542]  ; cur_nation
  0x096F4: mov      al, byte ptr [bx + 0x1f]
  0x096F7: cwde     
  0x096F8: cmp      ax, word ptr [bp - 2]
  0x096FB: jle      0x971f
  0x096FD: mov      al, byte ptr [bp + 6]
  0x09700: mov      si, word ptr [bp - 2]
  0x09703: cmp      byte ptr [bx + si + 0x20], al
  0x09706: jne      0x9716
  0x09708: mov      ax, word ptr [bp + 8]
  0x0970B: inc      word ptr [bp - 4]
  0x0970E: cmp      word ptr [bp - 4], ax
  0x09711: jne      0x9716
  0x09713: mov      word ptr [bp - 6], si
  0x09716: inc      word ptr [bp - 2]
  0x09719: cmp      word ptr [bp - 6], 0
  0x0971D: jl       0x96f0
  0x0971F: mov      ax, word ptr [bp - 6]
  0x09722: pop      si
  0x09723: leave    
  0x09724: retf     

============================================================
func_L262 at file 0x09726, 52 bytes
============================================================
  0x09726: enter    4, 0
  0x0972A: push     word ptr [0x917a]
  0x0972E: lcall    0x9ef, 0x2c
  0x09733: add      sp, 2
  0x09736: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0973A: mov      ah, byte ptr [bx + 1]
  0x0973D: sub      al, al
  0x0973F: cdq      
  0x09740: mov      cl, byte ptr [bx]
  0x09742: sub      ch, ch
  0x09744: add      ax, cx
  0x09746: adc      dx, 0
  0x09749: add      ax, word ptr [0x8d80]
  0x0974D: adc      dx, word ptr [0x8d82]
  0x09751: push     dx
  0x09752: push     ax
  0x09753: lcall    0x9ef, 0x1a
  0x09758: leave    
  0x09759: retf     

============================================================
func_L263 at file 0x0975A, 25 bytes
============================================================
  0x0975A: push     bp
  0x0975B: mov      bp, sp
  0x0975D: cmp      word ptr [bp + 6], 0
  0x09761: jl       0x9781
  0x09763: jmp      0x976e
  0x09765: nop      
  0x09766: mov      al, byte ptr [bx - 0x707b]
  0x0976A: cwde     
  0x0976B: mov      word ptr [bp + 6], ax
  0x0976E: mov      bx, word ptr [bp + 6]
  0x09771: mov      ax, bx

============================================================
func_L264 at file 0x09786, 14 bytes
============================================================
  0x09786: enter    2, 0
  0x0978A: mov      bx, word ptr [bp + 6]
  0x0978D: mov      al, byte ptr [bx + 0x2ca]
  0x09791: cwde     
  0x09792: leave    
  0x09793: retf     

============================================================
func_L265 at file 0x09794, 39 bytes
============================================================
  0x09794: enter    2, 0
  0x09798: mov      word ptr [bp - 2], 0xffff
  0x0979D: push     word ptr [bp + 6]
  0x097A0: push     cs
  0x097A1: call     0x975a
  0x097A4: add      sp, 2
  0x097A7: mov      word ptr [bp + 6], ax
  0x097AA: push     ax
  0x097AB: push     cs
  0x097AC: call     0x863e
  0x097AF: add      sp, 2
  0x097B2: or       ax, ax
  0x097B4: je       0x97d1
  0x097B6: mov      bx, word ptr [bp + 6]
  0x097B9: mov      ax, bx

============================================================
func_L266 at file 0x097D6, 28 bytes
============================================================
  0x097D6: enter    4, 0
  0x097DA: mov      word ptr [bp - 4], 0xffff
  0x097DF: push     word ptr [bp + 6]
  0x097E2: push     cs
  0x097E3: call     0x863e
  0x097E6: add      sp, 2
  0x097E9: or       ax, ax
  0x097EB: je       0x9813
  0x097ED: mov      bx, word ptr [bp + 6]
  0x097F0: mov      ax, bx

============================================================
func_L267 at file 0x09818, 66 bytes
============================================================
  0x09818: enter    6, 0
  0x0981C: mov      word ptr [bp - 2], 0
  0x09821: push     word ptr [bp + 6]
  0x09824: push     cs
  0x09825: call     0x975a
  0x09828: add      sp, 2
  0x0982B: or       ax, ax
  0x0982D: jne      0x985a
  0x0982F: mov      ax, word ptr [0x8d78]
  0x09832: jmp      0x984b
  0x09834: push     ax
  0x09835: push     cs
  0x09836: call     0x8b96
  0x09839: add      sp, 2
  0x0983C: or       ax, ax
  0x0983E: je       0x9843
  0x09840: inc      word ptr [bp - 2]
  0x09843: mov      ax, word ptr [bp - 6]
  0x09846: lcall    0x427, 0x4a
  0x0984B: mov      word ptr [bp - 6], ax
  0x0984E: or       ax, ax
  0x09850: jge      0x9834
  0x09852: neg      word ptr [bp - 2]
  0x09855: mov      ax, word ptr [bp - 2]
  0x09858: leave    
  0x09859: retf     

============================================================
func_L268 at file 0x09876, 62 bytes
============================================================
  0x09876: enter    4, 0
  0x0987A: mov      word ptr [bp - 4], 0
  0x0987F: cmp      word ptr [bp + 6], 0
  0x09883: jl       0x98af
  0x09885: push     word ptr [bp + 6]
  0x09888: push     cs
  0x09889: call     0x8d9c
  0x0988C: add      sp, 2
  0x0988F: or       ax, ax
  0x09891: jl       0x98af
  0x09893: mov      word ptr [bp - 4], 1
  0x09898: mov      bx, ax
  0x0989A: shl      bx, 1
  0x0989C: add      bx, ax
  0x0989E: shl      bx, 2
  0x098A1: mov      al, byte ptr [bx - 0x707a]
  0x098A5: cwde     
  0x098A6: or       ax, ax
  0x098A8: jl       0x98af
  0x098AA: mov      word ptr [bp - 4], 2
  0x098AF: mov      ax, word ptr [bp - 4]
  0x098B2: leave    
  0x098B3: retf     

============================================================
func_L269 at file 0x098B4, 65 bytes
============================================================
  0x098B4: enter    6, 0
  0x098B8: mov      word ptr [bp - 4], 0x14
  0x098BD: mov      word ptr [bp - 6], 0xc8
  0x098C2: cmp      word ptr [bp + 8], 0
  0x098C6: je       0x98cf
  0x098C8: mov      bx, word ptr [bp + 8]
  0x098CB: mov      word ptr [bx], 0x14
  0x098CF: cmp      word ptr [bp + 6], 0
  0x098D3: je       0x98f0
  0x098D5: les      bx, ptr [0x83e]
  0x098D9: mov      ax, word ptr es:[bx + 0x152]
  0x098DE: inc      ax
  0x098DF: imul     word ptr [bp - 4]
  0x098E2: dec      ax
  0x098E3: cmp      ax, 0x76
  0x098E6: jle      0x98eb
  0x098E8: mov      ax, 0x76
  0x098EB: mov      bx, word ptr [bp + 6]
  0x098EE: mov      word ptr [bx], ax
  0x098F0: mov      ax, word ptr [bp - 6]
  0x098F3: leave    
  0x098F4: retf     

============================================================
func_L270 at file 0x098F6, 85 bytes
============================================================
  0x098F6: enter    6, 0
  0x098FA: sub      ax, ax
  0x098FC: mov      word ptr [bp - 6], ax
  0x098FF: mov      word ptr [bp - 4], ax
  0x09902: jmp      0x9939
  0x09904: inc      word ptr [bp - 2]
  0x09907: cmp      word ptr [bp - 2], 5
  0x0990B: jge      0x9936
  0x0990D: push     word ptr [bp - 4]
  0x09910: push     word ptr [bp - 2]
  0x09913: push     cs
  0x09914: call     0x8956
  0x09917: add      sp, 4
  0x0991A: cmp      al, byte ptr [bp + 6]
  0x0991D: jne      0x9904
  0x0991F: mov      ax, word ptr [bp - 2]
  0x09922: mov      bx, word ptr [bp + 8]
  0x09925: mov      word ptr [bx], ax
  0x09927: mov      ax, word ptr [bp - 4]
  0x0992A: mov      bx, word ptr [bp + 0xa]
  0x0992D: mov      word ptr [bx], ax
  0x0992F: mov      word ptr [bp - 6], 1
  0x09934: jmp      0x9904
  0x09936: inc      word ptr [bp - 4]
  0x09939: cmp      word ptr [bp - 4], 5
  0x0993D: jge      0x9946
  0x0993F: mov      word ptr [bp - 2], 0
  0x09944: jmp      0x9907
  0x09946: mov      ax, word ptr [bp - 6]
  0x09949: leave    
  0x0994A: retf     

============================================================
func_L271 at file 0x0994C, 40 bytes
============================================================
  0x0994C: enter    4, 0
  0x09950: lea      ax, [bp - 4]
  0x09953: push     ax
  0x09954: lea      cx, [bp - 2]
  0x09957: push     cx
  0x09958: push     word ptr [bp + 6]
  0x0995B: push     cs
  0x0995C: call     0x98f6
  0x0995F: add      sp, 6
  0x09962: or       ax, ax
  0x09964: je       0x9972
  0x09966: push     -1
  0x09968: push     word ptr [bp - 4]
  0x0996B: push     word ptr [bp - 2]
  0x0996E: push     cs
  0x0996F: call     0x8982
  0x09972: leave    
  0x09973: retf     

============================================================
func_L272 at file 0x09974, 58 bytes
============================================================
  0x09974: enter    4, 0
  0x09978: mov      word ptr [bp - 2], 0xffff
  0x0997D: push     word ptr [bp + 8]
  0x09980: push     word ptr [bp + 6]
  0x09983: push     cs
  0x09984: call     0x8956
  0x09987: add      sp, 4
  0x0998A: cwde     
  0x0998B: mov      word ptr [bp - 4], ax
  0x0998E: or       ax, ax
  0x09990: jl       0x99a9
  0x09992: push     ax
  0x09993: push     cs
  0x09994: call     0x90c8
  0x09997: add      sp, 2
  0x0999A: mov      word ptr [bp - 2], ax
  0x0999D: push     word ptr [bp - 4]
  0x099A0: push     cs
  0x099A1: call     0x9102
  0x099A4: mov      bx, word ptr [bp + 0xa]
  0x099A7: mov      word ptr [bx], ax
  0x099A9: mov      ax, word ptr [bp - 2]
  0x099AC: leave    
  0x099AD: retf     

============================================================
func_L273 at file 0x099AE, 63 bytes
============================================================
  0x099AE: enter    4, 0
  0x099B2: mov      word ptr [bp - 2], 0
  0x099B7: push     word ptr [bp + 8]
  0x099BA: push     word ptr [bp + 6]
  0x099BD: lcall    0x37f, 0xa
  0x099C2: add      sp, 4
  0x099C5: or       ax, ax
  0x099C7: je       0x99e8
  0x099C9: push     word ptr [bp + 8]
  0x099CC: push     word ptr [bp + 6]
  0x099CF: lcall    0x37f, 0x10e
  0x099D4: add      sp, 4
  0x099D7: and      al, 0x1f
  0x099D9: cmp      al, byte ptr [bp + 0xa]
  0x099DC: jb       0x99e8
  0x099DE: cmp      al, byte ptr [bp + 0xc]
  0x099E1: ja       0x99e8
  0x099E3: mov      word ptr [bp - 2], 1
  0x099E8: mov      ax, word ptr [bp - 2]
  0x099EB: leave    
  0x099EC: retf     

============================================================
func_L274 at file 0x099EE, 67 bytes
============================================================
  0x099EE: enter    4, 0
  0x099F2: sub      ax, ax
  0x099F4: mov      word ptr [bp - 2], ax
  0x099F7: mov      word ptr [bp - 4], ax
  0x099FA: jmp      0x9a26
  0x099FC: mov      al, byte ptr [bp + 0xc]
  0x099FF: push     ax
  0x09A00: mov      al, byte ptr [bp + 0xa]
  0x09A03: push     ax
  0x09A04: mov      bx, word ptr [bp - 4]
  0x09A07: mov      al, byte ptr [bx + 0xbe]
  0x09A0B: cwde     
  0x09A0C: add      ax, word ptr [bp + 8]
  0x09A0F: push     ax
  0x09A10: mov      al, byte ptr [bx + 0xb4]
  0x09A14: cwde     
  0x09A15: add      ax, word ptr [bp + 6]
  0x09A18: push     ax
  0x09A19: push     cs
  0x09A1A: call     0x99ae
  0x09A1D: add      sp, 8
  0x09A20: add      word ptr [bp - 2], ax
  0x09A23: inc      word ptr [bp - 4]
  0x09A26: cmp      word ptr [bp - 4], 8
  0x09A2A: jl       0x99fc
  0x09A2C: mov      ax, word ptr [bp - 2]
  0x09A2F: leave    
  0x09A30: retf     

============================================================
func_L275 at file 0x09A32, 56 bytes
============================================================
  0x09A32: enter    2, 0
  0x09A36: mov      word ptr [bp - 2], 0
  0x09A3B: push     word ptr [bp + 8]
  0x09A3E: push     word ptr [bp + 6]
  0x09A41: lcall    0x37f, 0xa
  0x09A46: add      sp, 4
  0x09A49: or       ax, ax
  0x09A4B: je       0x9a65
  0x09A4D: push     word ptr [bp + 8]
  0x09A50: push     word ptr [bp + 6]
  0x09A53: lcall    0x37f, 0x142
  0x09A58: add      sp, 4
  0x09A5B: test     byte ptr [bp + 0xa], al
  0x09A5E: je       0x9a65
  0x09A60: mov      word ptr [bp - 2], 1
  0x09A65: mov      ax, word ptr [bp - 2]
  0x09A68: leave    
  0x09A69: retf     

============================================================
func_L276 at file 0x09A6A, 63 bytes
============================================================
  0x09A6A: enter    4, 0
  0x09A6E: sub      ax, ax
  0x09A70: mov      word ptr [bp - 2], ax
  0x09A73: mov      word ptr [bp - 4], ax
  0x09A76: jmp      0x9a9e
  0x09A78: mov      al, byte ptr [bp + 0xa]
  0x09A7B: push     ax
  0x09A7C: mov      bx, word ptr [bp - 4]
  0x09A7F: mov      al, byte ptr [bx + 0xbe]
  0x09A83: cwde     
  0x09A84: add      ax, word ptr [bp + 8]
  0x09A87: push     ax
  0x09A88: mov      al, byte ptr [bx + 0xb4]
  0x09A8C: cwde     
  0x09A8D: add      ax, word ptr [bp + 6]
  0x09A90: push     ax
  0x09A91: push     cs
  0x09A92: call     0x9a32
  0x09A95: add      sp, 6
  0x09A98: add      word ptr [bp - 2], ax
  0x09A9B: inc      word ptr [bp - 4]
  0x09A9E: cmp      word ptr [bp - 4], 8
  0x09AA2: jl       0x9a78
  0x09AA4: mov      ax, word ptr [bp - 2]
  0x09AA7: leave    
  0x09AA8: retf     

============================================================
func_L277 at file 0x09AAA, 241 bytes
============================================================
  0x09AAA: enter    2, 0
  0x09AAE: mov      word ptr [bp - 2], 0
  0x09AB3: cmp      word ptr [bp + 6], 9
  0x09AB7: jne      0x9ac4
  0x09AB9: cmp      word ptr [bp + 8], 0
  0x09ABD: jne      0x9ac4
  0x09ABF: mov      word ptr [bp - 2], 2
  0x09AC4: cmp      word ptr [bp + 6], 1
  0x09AC8: jne      0x9ad4
  0x09ACA: cmp      word ptr [bp + 8], 0
  0x09ACE: jne      0x9ad4
  0x09AD0: add      word ptr [bp - 2], 2
  0x09AD4: cmp      word ptr [bp + 6], 2
  0x09AD8: jne      0x9ae4
  0x09ADA: cmp      word ptr [bp + 8], 0
  0x09ADE: jne      0x9ae4
  0x09AE0: add      word ptr [bp - 2], 2
  0x09AE4: cmp      word ptr [bp + 6], 9
  0x09AE8: jne      0x9af4
  0x09AEA: cmp      word ptr [bp + 8], 4
  0x09AEE: jne      0x9af4
  0x09AF0: add      word ptr [bp - 2], 2
  0x09AF4: cmp      word ptr [bp + 6], 8
  0x09AF8: jne      0x9b04
  0x09AFA: cmp      word ptr [bp + 8], 4
  0x09AFE: jne      0x9b04
  0x09B00: add      word ptr [bp - 2], 3
  0x09B04: cmp      word ptr [bp + 6], 3
  0x09B08: jne      0x9b15
  0x09B0A: cmp      word ptr [bp + 8], 3
  0x09B0E: jne      0x9b15
  0x09B10: mov      word ptr [bp - 2], 0xffff
  0x09B15: cmp      word ptr [bp + 6], 4
  0x09B19: jne      0x9b26
  0x09B1B: cmp      word ptr [bp + 8], 2
  0x09B1F: jne      0x9b26
  0x09B21: mov      word ptr [bp - 2], 0xffff
  0x09B26: cmp      word ptr [bp + 6], 5
  0x09B2A: jne      0x9b37
  0x09B2C: cmp      word ptr [bp + 8], 1
  0x09B30: jne      0x9b37
  0x09B32: mov      word ptr [bp - 2], 0xffff
  0x09B37: cmp      word ptr [bp + 6], 0xa
  0x09B3B: jne      0x9b47
  0x09B3D: cmp      word ptr [bp + 8], 5
  0x09B41: jne      0x9b47
  0x09B43: add      word ptr [bp - 2], 2
  0x09B47: cmp      word ptr [bp + 6], 6
  0x09B4B: jne      0x9b57
  0x09B4D: cmp      word ptr [bp + 8], 6
  0x09B51: jne      0x9b57
  0x09B53: add      word ptr [bp - 2], 3
  0x09B57: cmp      word ptr [bp + 6], 0xd
  0x09B5B: jne      0x9b67
  0x09B5D: cmp      word ptr [bp + 8], 6
  0x09B61: jne      0x9b67
  0x09B63: add      word ptr [bp - 2], 2
  0x09B67: cmp      word ptr [bp + 6], 6
  0x09B6B: jne      0x9b76
  0x09B6D: cmp      word ptr [bp + 8], 7
  0x09B71: jne      0x9b76
  0x09B73: inc      word ptr [bp - 2]
  0x09B76: cmp      word ptr [bp + 6], 0xc
  0x09B7A: jne      0x9b86
  0x09B7C: cmp      word ptr [bp + 8], 7
  0x09B80: jne      0x9b86
  0x09B82: add      word ptr [bp - 2], 2
  0x09B86: cmp      word ptr [bp + 6], 7
  0x09B8A: jne      0x9b96
  0x09B8C: cmp      word ptr [bp + 8], 8
  0x09B90: jne      0x9b96
  0x09B92: add      word ptr [bp - 2], 3
  0x09B96: mov      ax, word ptr [bp - 2]
  0x09B99: leave    
  0x09B9A: retf     

============================================================
func_L278 at file 0x09B9C, 580 bytes
============================================================
  0x09B9C: enter    0x2a, 0
  0x09BA0: push     si
  0x09BA1: sub      ax, ax
  0x09BA3: mov      word ptr [bp - 0x24], ax
  0x09BA6: mov      word ptr [bp - 0x14], ax
  0x09BA9: mov      word ptr [bp - 0x28], ax
  0x09BAC: lea      ax, [bp - 0x2a]
  0x09BAF: push     ax
  0x09BB0: push     word ptr [bp + 8]
  0x09BB3: push     word ptr [bp + 6]
  0x09BB6: push     cs
  0x09BB7: call     0x9974
  0x09BBA: add      sp, 6
  0x09BBD: mov      word ptr [bp - 0x12], ax
  0x09BC0: mov      bx, word ptr [bp + 0xa]
  0x09BC3: mov      word ptr [bx], ax
  0x09BC5: or       ax, ax
  0x09BC7: jge      0x9bcc
  0x09BC9: jmp      0x9ff6
  0x09BCC: mov      bx, word ptr [0x8542]  ; cur_nation
  0x09BD0: mov      al, byte ptr [bx + 1]
  0x09BD3: sub      ah, ah
  0x09BD5: add      ax, word ptr [bp + 8]
  0x09BD8: dec      ax
  0x09BD9: dec      ax
  0x09BDA: mov      word ptr [bp - 6], ax
  0x09BDD: push     ax
  0x09BDE: mov      al, byte ptr [bx]
  0x09BE0: sub      ah, ah
  0x09BE2: add      ax, word ptr [bp + 6]
  0x09BE5: dec      ax
  0x09BE6: dec      ax
  0x09BE7: mov      word ptr [bp - 4], ax
  0x09BEA: push     ax
  0x09BEB: lcall    0x37f, 0x10e
  0x09BF0: add      sp, 4
  0x09BF3: mov      byte ptr [bp - 0x26], al
  0x09BF6: sub      ah, ah
  0x09BF8: push     ax
  0x09BF9: lcall    0x3e4, 0xe
  0x09BFE: add      sp, 2
  0x09C01: mov      word ptr [bp - 0x1e], ax
  0x09C04: push     word ptr [bp - 6]
  0x09C07: push     word ptr [bp - 4]
  0x09C0A: lcall    0x37f, 0x4b0
  0x09C0F: add      sp, 4
  0x09C12: mov      word ptr [bp - 0x18], ax
  0x09C15: mov      si, word ptr [bp - 0x1e]
  0x09C18: shl      si, 4
  0x09C1B: mov      bx, word ptr [bp - 0x12]
  0x09C1E: mov      al, byte ptr [bx + si + 0x2f7b]
  0x09C22: sub      ah, ah
  0x09C24: mov      word ptr [bp - 0x24], ax
  0x09C27: or       ax, ax
  0x09C29: jne      0x9c2e
  0x09C2B: jmp      0x9cb4
  0x09C2E: cmp      bx, 8
  0x09C31: jl       0x9c87
  0x09C33: push     0x1a
  0x09C35: push     0x19
  0x09C37: push     word ptr [bp - 6]
  0x09C3A: push     word ptr [bp - 4]
  0x09C3D: push     cs
  0x09C3E: call     0x99ee
  0x09C41: add      sp, 8
  0x09C44: mov      word ptr [bp - 2], ax
  0x09C47: cmp      ax, 8
  0x09C4A: jl       0x9c52
  0x09C4C: sub      word ptr [bp - 0x24], 2
  0x09C50: jmp      0x9c87
  0x09C52: cmp      ax, 6
  0x09C55: jl       0x9c5c
  0x09C57: dec      word ptr [bp - 0x24]
  0x09C5A: jmp      0x9c87
  0x09C5C: cmp      ax, 6
  0x09C5F: jge      0x9c66
  0x09C61: inc      word ptr [bp - 0x24]
  0x09C64: jmp      0x9c87
  0x09C66: cmp      ax, 4
  0x09C69: jge      0x9c72
  0x09C6B: add      word ptr [bp - 0x24], 2
  0x09C6F: jmp      0x9c87
  0x09C71: nop      
  0x09C72: cmp      ax, 3
  0x09C75: jge      0x9c7e
  0x09C77: add      word ptr [bp - 0x24], 3
  0x09C7B: jmp      0x9c87
  0x09C7D: nop      
  0x09C7E: cmp      ax, 1
  0x09C81: jge      0x9c87
  0x09C83: add      word ptr [bp - 0x24], 4
  0x09C87: cmp      word ptr [bp - 0x12], 4
  0x09C8B: jne      0x9cb4
  0x09C8D: push     word ptr [bp - 6]
  0x09C90: push     word ptr [bp - 4]
  0x09C93: lcall    0x37f, 0x142
  0x09C98: add      sp, 4
  0x09C9B: test     al, 0xa
  0x09C9D: je       0x9ca2
  0x09C9F: inc      word ptr [bp - 0x24]
  0x09CA2: test     byte ptr [bp - 0x26], 0x40
  0x09CA6: je       0x9cb4
  0x09CA8: inc      word ptr [bp - 0x24]
  0x09CAB: test     byte ptr [bp - 0x26], 0x80
  0x09CAF: je       0x9cb4
  0x09CB1: inc      word ptr [bp - 0x24]
  0x09CB4: mov      ax, word ptr [bp - 0x24]
  0x09CB7: or       ax, ax
  0x09CB9: jge      0x9cbd
  0x09CBB: sub      ax, ax
  0x09CBD: mov      word ptr [bp - 0x24], ax
  0x09CC0: push     word ptr [bp + 8]
  0x09CC3: push     word ptr [bp + 6]
  0x09CC6: push     cs
  0x09CC7: call     0x8956
  0x09CCA: add      sp, 4
  0x09CCD: cwde     
  0x09CCE: mov      word ptr [bp - 0x22], ax
  0x09CD1: push     ax
  0x09CD2: push     cs
  0x09CD3: call     0x9102
  0x09CD6: add      sp, 2
  0x09CD9: mov      word ptr [bp - 0x20], ax
  0x09CDC: cmp      ax, word ptr [bp - 0x12]
  0x09CDF: jne      0x9ce6
  0x09CE1: mov      ax, 1
  0x09CE4: jmp      0x9ce8
  0x09CE6: sub      ax, ax
  0x09CE8: mov      word ptr [bp - 0x16], ax
  0x09CEB: cmp      word ptr [bp - 0x20], 0x1b
  0x09CEF: jne      0x9cf6
  0x09CF1: mov      ax, 1
  0x09CF4: jmp      0x9cf8
  0x09CF6: sub      ax, ax
  0x09CF8: mov      word ptr [bp - 8], ax
  0x09CFB: cmp      word ptr [bp - 0x12], 0
  0x09CFF: je       0x9d07
  0x09D01: cmp      word ptr [bp - 0x12], 8
  0x09D05: jne      0x9d0e
  0x09D07: mov      word ptr [bp - 0x14], 1
  0x09D0C: jmp      0x9d13
  0x09D0E: mov      word ptr [bp - 0x14], 0
  0x09D13: push     cs
  0x09D14: call     0x8524
  0x09D17: mov      word ptr [bp - 0x1c], ax
  0x09D1A: mov      cx, 0x64
  0x09D1D: sub      cx, ax
  0x09D1F: mov      bx, word ptr [0x8542]  ; cur_nation
  0x09D23: mov      al, byte ptr [bx + 0x1f]
  0x09D26: cwde     
  0x09D27: imul     cx
  0x09D29: add      ax, 0x32
  0x09D2C: mov      cx, 0x64
  0x09D2F: cdq      
  0x09D30: idiv     cx
  0x09D32: mov      word ptr [bp - 0xc], ax
  0x09D35: cmp      byte ptr [bx + 0x1a], 4
  0x09D39: jae      0x9d56
  0x09D3B: mov      al, byte ptr [bx + 0x1a]
  0x09D3E: sub      ah, ah
  0x09D40: imul     bx, ax, 0x34  ; *AI
  0x09D43: cmp      byte ptr [bx + 0x543f], ah  ; ai_pers
  0x09D47: jne      0x9d56
  0x09D49: mov      al, byte ptr [0x53a6]
  0x09D4C: sub      ax, 0xa
  0x09D4F: neg      ax
  0x09D51: mov      word ptr [bp - 0xe], ax
  0x09D54: jmp      0x9d5b
  0x09D56: mov      word ptr [bp - 0xe], 0xa
  0x09D5B: mov      bx, word ptr [0x8542]  ; cur_nation
  0x09D5F: cmp      byte ptr [bx + 0x1a], 4
  0x09D63: jae      0x9d73
  0x09D65: mov      al, byte ptr [bx + 0x1a]
  0x09D68: sub      ah, ah
  0x09D6A: imul     bx, ax, 0x34  ; *AI
  0x09D6D: cmp      byte ptr [bx + 0x543f], ah  ; ai_pers
  0x09D71: je       0x9d78
  0x09D73: mov      word ptr [bp - 0xc], 0
  0x09D78: mov      ax, word ptr [bp - 0xc]
  0x09D7B: cdq      
  0x09D7C: idiv     word ptr [bp - 0xe]
  0x09D7F: neg      ax
  0x09D81: mov      word ptr [bp - 0x1a], ax
  0x09D84: mov      bx, word ptr [0x8542]  ; cur_nation
  0x09D88: test     byte ptr [bx + 0x1c], 4
  0x09D8C: je       0x9d92
  0x09D8E: inc      ax
  0x09D8F: mov      word ptr [bp - 0x1a], ax
  0x09D92: test     byte ptr [bx + 0x1c], 2
  0x09D96: je       0x9d9b
  0x09D98: inc      word ptr [bp - 0x1a]
  0x09D9B: cmp      word ptr [bp - 0x24], 0
  0x09D9F: je       0x9dad
  0x09DA1: cmp      word ptr [bp - 0x1a], 0
  0x09DA5: jle      0x9dad
  0x09DA7: mov      ax, word ptr [bp - 0x1a]
  0x09DAA: add      word ptr [bp - 0x24], ax
  0x09DAD: cmp      word ptr [bp - 0x16], 0
  0x09DB1: je       0x9dd5
  0x09DB3: cmp      word ptr [bp - 0x24], 0
  0x09DB7: je       0x9dd5
  0x09DB9: cmp      word ptr [bp - 0x14], 0
  0x09DBD: je       0x9dd2
  0x09DBF: add      word ptr [bp - 0x24], 2
  0x09DC3: cmp      word ptr [bp - 0x1a], 0
  0x09DC7: jle      0x9dd5
  0x09DC9: mov      ax, word ptr [bp - 0x1a]
  0x09DCC: add      word ptr [bp - 0x24], ax
  0x09DCF: jmp      0x9dd5
  0x09DD1: nop      
  0x09DD2: shl      word ptr [bp - 0x24], 1
  0x09DD5: mov      bx, word ptr [bp + 0xa]
  0x09DD8: push     word ptr [bx]
  0x09DDA: push     word ptr [bp - 0x18]
  0x09DDD: push     cs

============================================================
func_L279 at file 0x09FFC, 550 bytes
============================================================
  0x09FFC: enter    0x1c, 0
  0x0A000: push     word ptr [bp + 6]
  0x0A003: push     cs
  0x0A004: call     0x90c8
  0x0A007: add      sp, 2
  0x0A00A: mov      word ptr [bp - 0x16], ax
  0x0A00D: push     word ptr [bp + 6]
  0x0A010: push     cs
  0x0A011: call     0x9102
  0x0A014: add      sp, 2
  0x0A017: mov      word ptr [bp - 0x14], ax
  0x0A01A: cmp      ax, word ptr [bp - 0x16]
  0x0A01D: jne      0xa024
  0x0A01F: mov      ax, 1
  0x0A022: jmp      0xa026
  0x0A024: sub      ax, ax
  0x0A026: mov      word ptr [bp - 0x1c], ax
  0x0A029: push     cs
  0x0A02A: call     0x8524
  0x0A02D: mov      cx, 0x64
  0x0A030: sub      cx, ax
  0x0A032: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A036: mov      al, byte ptr [bx + 0x1f]
  0x0A039: cwde     
  0x0A03A: imul     cx
  0x0A03C: add      ax, 0x32
  0x0A03F: mov      cx, 0x64
  0x0A042: cdq      
  0x0A043: idiv     cx
  0x0A045: mov      word ptr [bp - 8], ax
  0x0A048: cmp      byte ptr [bx + 0x1a], 4
  0x0A04C: jae      0xa06a
  0x0A04E: mov      al, byte ptr [bx + 0x1a]
  0x0A051: sub      ah, ah
  0x0A053: imul     bx, ax, 0x34  ; *AI
  0x0A056: cmp      byte ptr [bx + 0x543f], ah  ; ai_pers
  0x0A05A: jne      0xa06a
  0x0A05C: mov      al, byte ptr [0x53a6]
  0x0A05F: sub      ax, 0xa
  0x0A062: neg      ax
  0x0A064: mov      word ptr [bp - 0xa], ax
  0x0A067: jmp      0xa06f
  0x0A069: nop      
  0x0A06A: mov      word ptr [bp - 0xa], 0xa
  0x0A06F: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A073: cmp      byte ptr [bx + 0x1a], 4
  0x0A077: jae      0xa087
  0x0A079: mov      al, byte ptr [bx + 0x1a]
  0x0A07C: sub      ah, ah
  0x0A07E: imul     bx, ax, 0x34  ; *AI
  0x0A081: cmp      byte ptr [bx + 0x543f], ah  ; ai_pers
  0x0A085: je       0xa08c
  0x0A087: mov      word ptr [bp - 8], 0
  0x0A08C: mov      ax, word ptr [bp - 8]
  0x0A08F: cdq      
  0x0A090: idiv     word ptr [bp - 0xa]
  0x0A093: neg      ax
  0x0A095: mov      word ptr [bp - 0xe], ax
  0x0A098: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A09C: test     byte ptr [bx + 0x1c], 4
  0x0A0A0: je       0xa0a6
  0x0A0A2: inc      ax
  0x0A0A3: mov      word ptr [bp - 0xe], ax
  0x0A0A6: test     byte ptr [bx + 0x1c], 2
  0x0A0AA: je       0xa0af
  0x0A0AC: inc      word ptr [bp - 0xe]
  0x0A0AF: cmp      word ptr [bp - 0x1c], 1
  0x0A0B3: sbb      ax, ax
  0x0A0B5: and      al, 0xfe
  0x0A0B7: add      ax, 3
  0x0A0BA: mov      word ptr [bp - 6], ax
  0x0A0BD: mov      word ptr [bp - 0x18], 0xffff
  0x0A0C2: push     word ptr [bp - 0x16]
  0x0A0C5: push     cs
  0x0A0C6: call     0x8d9c
  0x0A0C9: add      sp, 2
  0x0A0CC: mov      word ptr [bp - 2], ax
  0x0A0CF: push     ax
  0x0A0D0: push     cs
  0x0A0D1: call     0x86e4
  0x0A0D4: add      sp, 2
  0x0A0D7: mov      ax, word ptr [bp - 0x14]
  0x0A0DA: sub      ax, 0x19
  0x0A0DD: je       0xa0f8
  0x0A0DF: dec      ax
  0x0A0E0: jl       0xa0e5
  0x0A0E2: dec      ax
  0x0A0E3: jle      0xa0ec
  0x0A0E5: mov      word ptr [bp - 0x12], 3
  0x0A0EA: jmp      0xa0f1
  0x0A0EC: mov      word ptr [bp - 0x12], 1
  0x0A0F1: mov      ax, word ptr [bp - 0x16]
  0x0A0F4: jmp      0xa1e4
  0x0A0F7: nop      
  0x0A0F8: mov      word ptr [bp - 0x12], 2
  0x0A0FD: jmp      0xa0f1
  0x0A0FF: nop      
  0x0A100: mov      word ptr [bp - 0x18], 0x10
  0x0A105: cmp      word ptr [bp - 0x1c], 0
  0x0A109: je       0xa110
  0x0A10B: mov      ax, 6
  0x0A10E: jmp      0xa113
  0x0A110: mov      ax, word ptr [bp - 0x12]
  0x0A113: mov      word ptr [bp - 6], ax
  0x0A116: mov      ax, word ptr [bp - 0xe]
  0x0A119: add      word ptr [bp - 6], ax
  0x0A11C: push     0x24
  0x0A11E: push     cs
  0x0A11F: call     0x863e
  0x0A122: add      sp, 2
  0x0A125: or       ax, ax
  0x0A127: jne      0xa12c
  0x0A129: jmp      0xa206
  0x0A12C: shl      word ptr [bp - 6], 1
  0x0A12F: jmp      0xa206
  0x0A132: cmp      word ptr [bp - 0x1c], 0
  0x0A136: je       0xa13e
  0x0A138: mov      ax, 6
  0x0A13B: jmp      0xa141
  0x0A13D: nop      
  0x0A13E: mov      ax, word ptr [bp - 0x12]
  0x0A141: mov      word ptr [bp - 6], ax
  0x0A144: mov      word ptr [bp - 0x18], 0x11
  0x0A149: mov      ax, word ptr [bp - 0xe]
  0x0A14C: add      word ptr [bp - 6], ax
  0x0A14F: push     0x26
  0x0A151: push     cs
  0x0A152: call     0x863e
  0x0A155: add      sp, 2
  0x0A158: or       ax, ax
  0x0A15A: je       0xa15f
  0x0A15C: shl      word ptr [bp - 6], 1
  0x0A15F: push     0x15
  0x0A161: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A165: mov      al, byte ptr [bx + 0x1a]
  0x0A168: sub      ah, ah
  0x0A16A: push     ax
  0x0A16B: lcall    0x981, 0
  0x0A170: add      sp, 4
  0x0A173: or       ax, ax
  0x0A175: jne      0xa17a
  0x0A177: jmp      0xa206
  0x0A17A: mov      ax, word ptr [bp - 6]
  0x0A17D: sar      ax, 1
  0x0A17F: add      word ptr [bp - 6], ax
  0x0A182: jmp      0xa206
  0x0A185: nop      
  0x0A186: nop      
  0x0A187: nop      
  0x0A188: mov      ax, word ptr [bp - 0x16]
  0x0A18B: mov      word ptr [bp - 0x18], ax
  0x0A18E: mov      ax, word ptr [bp - 0x12]
  0x0A191: add      ax, word ptr [bp - 0xe]
  0x0A194: mov      word ptr [bp - 6], ax
  0x0A197: push     word ptr [bp - 2]
  0x0A19A: push     cs
  0x0A19B: call     0x864e
  0x0A19E: add      sp, 2
  0x0A1A1: mov      word ptr [bp - 0xc], ax
  0x0A1A4: cmp      ax, 1
  0x0A1A7: jle      0xa1b2
  0x0A1A9: mov      ax, word ptr [bp - 6]
  0x0A1AC: add      ax, word ptr [bp - 0x12]
  0x0A1AF: mov      word ptr [bp - 6], ax
  0x0A1B2: cmp      word ptr [bp - 0xc], 2
  0x0A1B6: jle      0xa1c0
  0x0A1B8: mov      ax, word ptr [bp - 6]
  0x0A1BB: sar      ax, 1
  0x0A1BD: add      word ptr [bp - 6], ax
  0x0A1C0: cmp      word ptr [bp - 0x1c], 0
  0x0A1C4: jmp      0xa127
  0x0A1C7: nop      
  0x0A1C8: mov      ax, word ptr [bp - 0x12]
  0x0A1CB: add      ax, word ptr [bp - 0xe]
  0x0A1CE: mov      word ptr [bp - 6], ax
  0x0A1D1: mov      word ptr [bp - 0x18], 0x12
  0x0A1D6: cmp      word ptr [bp - 0x1c], 0
  0x0A1DA: je       0xa206
  0x0A1DC: shl      ax, 1
  0x0A1DE: mov      word ptr [bp - 6], ax
  0x0A1E1: jmp      0xa206
  0x0A1E3: nop      
  0x0A1E4: sub      ax, 9
  0x0A1E7: cmp      ax, 8
  0x0A1EA: ja       0xa206
  0x0A1EC: shl      ax, 1
  0x0A1EE: xchg     bx, ax
  0x0A1EF: jmp      word ptr cs:[bx + 0x1f44]
  0x0A1F4: fcomp    dword ptr [0x1ed8]
  0x0A1F8: fcomp    dword ptr [0x1ed8]
  0x0A1FC: push     ax
  0x0A1FD: push     ds
  0x0A1FE: fcomp    dword ptr [0x1ed8]
  0x0A202: sbb      byte ptr [0x1f18], 0x83
  0x0A207: jle      0xa211
  0x0A209: add      byte ptr [si + 8], dh
  0x0A20C: mov      ax, word ptr [bp - 0x18]
  0x0A20F: mov      bx, word ptr [bp + 8]
  0x0A212: mov      word ptr [bx], ax
  0x0A214: mov      ax, word ptr [bp - 6]
  0x0A217: or       ax, ax
  0x0A219: jge      0xa21d
  0x0A21B: sub      ax, ax
  0x0A21D: mov      word ptr [bp - 6], ax
  0x0A220: leave    
  0x0A221: retf     

============================================================
func_L280 at file 0x0A222, 447 bytes
============================================================
  0x0A222: enter    0x2a, 0
  0x0A226: push     si
  0x0A227: sub      al, al
  0x0A229: mov      byte ptr [0xa895], al
  0x0A22C: mov      byte ptr [0xa896], al
  0x0A22F: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A233: mov      al, byte ptr [bx + 1]
  0x0A236: sub      ah, ah
  0x0A238: push     ax
  0x0A239: mov      al, byte ptr [bx]
  0x0A23B: push     ax
  0x0A23C: lcall    0x3e4, 0x3a
  0x0A241: add      sp, 4
  0x0A244: mov      word ptr [bp - 0x24], ax
  0x0A247: cmp      ax, 0x18
  0x0A24A: jne      0xa254
  0x0A24C: mov      byte ptr [0xa891], 0
  0x0A251: jmp      0xa295
  0x0A253: nop      
  0x0A254: cmp      ax, 1
  0x0A257: je       0xa263
  0x0A259: cmp      ax, 0x11
  0x0A25C: je       0xa263
  0x0A25E: cmp      ax, 9
  0x0A261: jne      0xa26a
  0x0A263: mov      byte ptr [0xa891], 1
  0x0A268: jmp      0xa295
  0x0A26A: cmp      ax, 0x1b
  0x0A26D: je       0xa288
  0x0A26F: cmp      ax, 0x1c
  0x0A272: je       0xa288
  0x0A274: cmp      ax, 8
  0x0A277: jl       0xa27e
  0x0A279: cmp      ax, 0x10
  0x0A27C: jl       0xa288
  0x0A27E: cmp      ax, 0x10
  0x0A281: jl       0xa290
  0x0A283: cmp      ax, 0x18
  0x0A286: jge      0xa290
  0x0A288: mov      byte ptr [0xa891], 2
  0x0A28D: jmp      0xa295
  0x0A28F: nop      
  0x0A290: mov      byte ptr [0xa891], 3
  0x0A295: cmp      byte ptr [0x53a6], 0
  0x0A29A: jne      0xa2a1
  0x0A29C: add      byte ptr [0xa891], 2
  0x0A2A1: cmp      byte ptr [0x53a6], 1
  0x0A2A6: jne      0xa2ac
  0x0A2A8: inc      byte ptr [0xa891]
  0x0A2AC: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A2B0: mov      al, byte ptr [bx + 1]
  0x0A2B3: sub      ah, ah
  0x0A2B5: push     ax
  0x0A2B6: mov      al, byte ptr [bx]
  0x0A2B8: push     ax
  0x0A2B9: lcall    0x37f, 0x142
  0x0A2BE: add      sp, 4
  0x0A2C1: test     al, 0x40
  0x0A2C3: je       0xa2c9
  0x0A2C5: inc      byte ptr [0xa891]
  0x0A2C9: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A2CD: mov      al, byte ptr [bx + 1]
  0x0A2D0: sub      ah, ah
  0x0A2D2: push     ax
  0x0A2D3: mov      al, byte ptr [bx]
  0x0A2D5: push     ax
  0x0A2D6: lcall    0x37f, 0x4b0
  0x0A2DB: add      sp, 4
  0x0A2DE: mov      word ptr [bp - 0x14], ax
  0x0A2E1: mov      word ptr [bp - 0x12], 0
  0x0A2E6: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A2EA: mov      al, byte ptr [bx + 1]
  0x0A2ED: sub      ah, ah
  0x0A2EF: push     ax
  0x0A2F0: mov      al, byte ptr [bx]
  0x0A2F2: push     ax
  0x0A2F3: lcall    0x37f, 0x10e
  0x0A2F8: add      sp, 4
  0x0A2FB: sub      ah, ah
  0x0A2FD: mov      word ptr [bp - 2], ax
  0x0A300: test     al, 0x40
  0x0A302: je       0xa314
  0x0A304: mov      word ptr [bp - 0x12], 1
  0x0A309: test     byte ptr [bp - 2], 0x80
  0x0A30D: je       0xa314
  0x0A30F: mov      word ptr [bp - 0x12], 2
  0x0A314: cmp      word ptr [bp - 0x14], 1
  0x0A318: je       0xa326
  0x0A31A: cmp      word ptr [bp - 0x14], 9
  0x0A31E: je       0xa326
  0x0A320: cmp      word ptr [bp - 0x14], 2
  0x0A324: jne      0xa32b
  0x0A326: add      byte ptr [0xa891], 2
  0x0A32B: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A32F: test     byte ptr [bx + 0x1c], 4
  0x0A333: je       0xa339
  0x0A335: inc      byte ptr [0xa891]
  0x0A339: test     byte ptr [bx + 0x1c], 2
  0x0A33D: je       0xa343
  0x0A33F: inc      byte ptr [0xa891]
  0x0A343: mov      byte ptr [0xa893], 0xff
  0x0A348: mov      byte ptr [0xa894], 0
  0x0A34D: mov      word ptr [bp - 0x1c], 1
  0x0A352: jmp      0xa36f
  0x0A354: add      word ptr [bp - 6], ax
  0x0A357: mov      al, byte ptr [0xa894]
  0x0A35A: cwde     
  0x0A35B: cmp      ax, word ptr [bp - 6]
  0x0A35E: jge      0xa36c
  0x0A360: mov      al, byte ptr [bp - 0x1c]
  0x0A363: mov      byte ptr [0xa893], al
  0x0A366: mov      al, byte ptr [bp - 6]
  0x0A369: mov      byte ptr [0xa894], al
  0x0A36C: inc      word ptr [bp - 0x1c]
  0x0A36F: cmp      word ptr [bp - 0x1c], 8
  0x0A373: jge      0xa3a4
  0x0A375: cmp      word ptr [bp - 0x1c], 5
  0x0A379: je       0xa36c
  0x0A37B: mov      si, word ptr [bp - 0x24]
  0x0A37E: shl      si, 4
  0x0A381: mov      bx, word ptr [bp - 0x1c]
  0x0A384: mov      al, byte ptr [bx + si + 0x2f7b]
  0x0A388: sub      ah, ah
  0x0A38A: mov      word ptr [bp - 6], ax
  0x0A38D: push     bx
  0x0A38E: push     word ptr [bp - 0x14]
  0x0A391: push     cs
  0x0A392: call     0x9aaa
  0x0A395: add      sp, 4
  0x0A398: mov      word ptr [bp - 0xe], ax
  0x0A39B: or       ax, ax
  0x0A39D: jge      0xa354
  0x0A39F: shl      word ptr [bp - 6], 1
  0x0A3A2: jmp      0xa357
  0x0A3A4: cmp      byte ptr [0xa893], 0
  0x0A3A9: jl       0xa3d5
  0x0A3AB: cmp      byte ptr [0x53a6], 0
  0x0A3B0: jne      0xa3b6
  0x0A3B2: inc      byte ptr [0xa894]
  0x0A3B6: mov      al, byte ptr [bp - 0x12]
  0x0A3B9: add      byte ptr [0xa894], al
  0x0A3BD: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A3C1: test     byte ptr [bx + 0x1c], 4
  0x0A3C5: je       0xa3cb
  0x0A3C7: inc      byte ptr [0xa894]
  0x0A3CB: test     byte ptr [bx + 0x1c], 2
  0x0A3CF: je       0xa3d5
  0x0A3D1: inc      byte ptr [0xa894]
  0x0A3D5: mov      word ptr [bp - 0x1c], 0
  0x0A3DA: mov      bx, word ptr [bp - 0x1c]
  0x0A3DD: shl      bx, 1

============================================================
func_L281 at file 0x0A3E1, 705 bytes
============================================================
  0x0A3E1: enter    0x8d, 0
  0x0A3E5: inc      word ptr [bp - 0x1c]
  0x0A3E8: cmp      word ptr [bp - 0x1c], 0x14
  0x0A3EC: jl       0xa3da
  0x0A3EE: mov      al, byte ptr [0xa891]
  0x0A3F1: sub      ah, ah
  0x0A3F3: add      word ptr [0x8dc8], ax
  0x0A3F7: cmp      byte ptr [0xa893], ah
  0x0A3FB: jl       0xa40d
  0x0A3FD: mov      al, byte ptr [0xa893]
  0x0A400: cwde     
  0x0A401: mov      bx, ax
  0x0A403: shl      bx, 1
  0x0A405: mov      al, byte ptr [0xa894]
  0x0A408: cwde     
  0x0A409: add      word ptr [bx - 0x7238], ax
  0x0A40D: mov      word ptr [bp - 0x1a], 0
  0x0A412: jmp      0xa46b
  0x0A414: inc      word ptr [bp - 0x18]
  0x0A417: cmp      word ptr [bp - 0x18], 5
  0x0A41B: jge      0xa468
  0x0A41D: push     1
  0x0A41F: lea      ax, [bp - 0x16]
  0x0A422: push     ax
  0x0A423: push     word ptr [bp - 0x1a]
  0x0A426: push     word ptr [bp - 0x18]
  0x0A429: push     cs
  0x0A42A: call     0x9b9c
  0x0A42D: add      sp, 8
  0x0A430: mov      word ptr [bp - 0x10], ax
  0x0A433: cmp      word ptr [bp - 0x16], 0
  0x0A437: jl       0xa414
  0x0A439: push     word ptr [bp - 0x1a]
  0x0A43C: push     word ptr [bp - 0x18]
  0x0A43F: push     cs
  0x0A440: call     0x8956
  0x0A443: add      sp, 4
  0x0A446: cwde     
  0x0A447: mov      si, ax
  0x0A449: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A44D: cmp      byte ptr [bx + si + 0x20], 8
  0x0A451: jne      0xa45a
  0x0A453: mov      al, byte ptr [bp - 0x10]
  0x0A456: add      byte ptr [0xa895], al
  0x0A45A: mov      ax, word ptr [bp - 0x10]
  0x0A45D: mov      bx, word ptr [bp - 0x16]
  0x0A460: shl      bx, 1
  0x0A462: add      word ptr [bx - 0x7238], ax
  0x0A466: jmp      0xa414
  0x0A468: inc      word ptr [bp - 0x1a]
  0x0A46B: cmp      word ptr [bp - 0x1a], 5
  0x0A46F: jge      0xa478
  0x0A471: mov      word ptr [bp - 0x18], 0
  0x0A476: jmp      0xa417
  0x0A478: mov      word ptr [bp - 0x1c], 0
  0x0A47D: jmp      0xa4a3
  0x0A47F: nop      
  0x0A480: lea      ax, [bp - 0x26]
  0x0A483: push     ax
  0x0A484: push     word ptr [bp - 0x1c]
  0x0A487: push     cs
  0x0A488: call     0x9ffc
  0x0A48B: add      sp, 4
  0x0A48E: mov      word ptr [bp - 0xa], ax
  0x0A491: cmp      word ptr [bp - 0x26], 0
  0x0A495: jl       0xa4a0
  0x0A497: mov      bx, word ptr [bp - 0x26]
  0x0A49A: shl      bx, 1
  0x0A49C: add      word ptr [bx - 0x7238], ax
  0x0A4A0: inc      word ptr [bp - 0x1c]
  0x0A4A3: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A4A7: mov      al, byte ptr [bx + 0x1f]
  0x0A4AA: cwde     
  0x0A4AB: cmp      ax, word ptr [bp - 0x1c]
  0x0A4AE: jg       0xa480
  0x0A4B0: inc      word ptr [0x8dea]
  0x0A4B4: push     0x25
  0x0A4B6: push     cs
  0x0A4B7: call     0x863e
  0x0A4BA: add      sp, 2
  0x0A4BD: or       ax, ax
  0x0A4BF: je       0xa4c5
  0x0A4C1: inc      word ptr [0x8dea]
  0x0A4C5: push     0x26
  0x0A4C7: push     cs
  0x0A4C8: call     0x863e
  0x0A4CB: add      sp, 2
  0x0A4CE: or       ax, ax
  0x0A4D0: je       0xa4d6
  0x0A4D2: inc      word ptr [0x8dea]
  0x0A4D6: mov      byte ptr [0xa892], 0
  0x0A4DB: inc      word ptr [0x8dec]
  0x0A4DF: push     0xf
  0x0A4E1: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A4E5: mov      al, byte ptr [bx + 0x1a]
  0x0A4E8: sub      ah, ah
  0x0A4EA: push     ax
  0x0A4EB: lcall    0x981, 0
  0x0A4F0: add      sp, 4
  0x0A4F3: or       ax, ax
  0x0A4F5: je       0xa500
  0x0A4F7: mov      ax, word ptr [0x8dec]
  0x0A4FA: shr      ax, 1
  0x0A4FC: add      word ptr [0x8dec], ax
  0x0A500: push     0x11
  0x0A502: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A506: mov      al, byte ptr [bx + 0x1a]
  0x0A509: sub      ah, ah
  0x0A50B: push     ax
  0x0A50C: lcall    0x981, 0
  0x0A511: add      sp, 4
  0x0A514: or       ax, ax
  0x0A516: je       0xa539
  0x0A518: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A51C: mov      al, byte ptr [bx + 0x1a]
  0x0A51F: sub      ah, ah
  0x0A521: imul     bx, ax, 0x13c  ; *Power
  0x0A525: mov      al, byte ptr [bx - 0x77f7]
  0x0A529: cwde     
  0x0A52A: mul      word ptr [0x8dec]
  0x0A52E: mov      cx, 0x64
  0x0A531: sub      dx, dx
  0x0A533: div      cx
  0x0A535: add      word ptr [0x8dec], ax
  0x0A539: push     0x12
  0x0A53B: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A53F: mov      al, byte ptr [bx + 0x1a]
  0x0A542: sub      ah, ah
  0x0A544: push     ax
  0x0A545: lcall    0x981, 0
  0x0A54A: add      sp, 4
  0x0A54D: or       ax, ax
  0x0A54F: je       0xa57e
  0x0A551: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A555: cmp      byte ptr [bx + 0x1a], 4
  0x0A559: jae      0xa569
  0x0A55B: mov      al, byte ptr [bx + 0x1a]
  0x0A55E: sub      ah, ah
  0x0A560: imul     bx, ax, 0x34  ; *AI
  0x0A563: cmp      byte ptr [bx + 0x543f], ah  ; ai_pers
  0x0A567: je       0xa57e
  0x0A569: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A56D: mov      al, byte ptr [bx + 0x1f]
  0x0A570: cwde     
  0x0A571: add      ax, 3
  0x0A574: mov      cx, 5
  0x0A577: cdq      
  0x0A578: idiv     cx
  0x0A57A: add      word ptr [0x8dec], ax
  0x0A57E: mov      al, byte ptr [0xa892]
  0x0A581: sub      ah, ah
  0x0A583: add      word ptr [0x8dec], ax
  0x0A587: push     0x14
  0x0A589: push     cs
  0x0A58A: call     0x863e
  0x0A58D: add      sp, 2
  0x0A590: or       ax, ax
  0x0A592: je       0xa59a
  0x0A594: shl      word ptr [0x8dec], 1
  0x0A598: jmp      0xa5b0
  0x0A59A: push     0x13
  0x0A59C: push     cs
  0x0A59D: call     0x863e
  0x0A5A0: add      sp, 2
  0x0A5A3: or       ax, ax
  0x0A5A5: je       0xa5b0
  0x0A5A7: mov      ax, word ptr [0x8dec]
  0x0A5AA: shr      ax, 1
  0x0A5AC: add      word ptr [0x8dec], ax
  0x0A5B0: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A5B4: cmp      word ptr [bx + 0xaa], 2
  0x0A5B9: jl       0xa5e6
  0x0A5BB: mov      word ptr [bp - 0x1e], 0x19
  0x0A5C0: push     0x11
  0x0A5C2: push     cs
  0x0A5C3: call     0x863e
  0x0A5C6: add      sp, 2
  0x0A5C9: or       ax, ax
  0x0A5CB: jne      0xa5d2
  0x0A5CD: mov      word ptr [bp - 0x1e], 0x32
  0x0A5D2: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A5D6: mov      ax, word ptr [bx + 0xaa]
  0x0A5DA: add      ax, word ptr [bp - 0x1e]
  0x0A5DD: dec      ax
  0x0A5DE: cdq      
  0x0A5DF: idiv     word ptr [bp - 0x1e]
  0x0A5E2: shl      ax, 1
  0x0A5E4: jmp      0xa5e8
  0x0A5E6: sub      ax, ax
  0x0A5E8: mov      word ptr [bp - 0x22], ax
  0x0A5EB: mov      word ptr [bp - 0xc], ax
  0x0A5EE: mov      al, byte ptr [bx + 0x1f]
  0x0A5F1: cwde     
  0x0A5F2: shl      ax, 1
  0x0A5F4: mov      word ptr [bp - 4], ax
  0x0A5F7: sub      ax, word ptr [0x8dc8]
  0x0A5FB: neg      ax
  0x0A5FD: or       ax, ax
  0x0A5FF: jge      0xa603
  0x0A601: sub      ax, ax
  0x0A603: mov      word ptr [bp - 8], ax
  0x0A606: inc      ax
  0x0A607: sar      ax, 1
  0x0A609: cmp      ax, word ptr [bp - 0xc]
  0x0A60C: jle      0xa611
  0x0A60E: mov      ax, word ptr [bp - 0xc]
  0x0A611: mov      word ptr [bp - 0x22], ax
  0x0A614: push     cs
  0x0A615: call     0x8d00
  0x0A618: mov      word ptr [bp - 0x2a], ax
  0x0A61B: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A61F: sub      ax, word ptr [bx + 0xaa]
  0x0A623: jns      0xa627
  0x0A625: sub      ax, ax
  0x0A627: cmp      ax, word ptr [bp - 0x22]
  0x0A62A: jle      0xa62f
  0x0A62C: mov      ax, word ptr [bp - 0x22]
  0x0A62F: mov      word ptr [bp - 0x20], ax
  0x0A632: mov      cx, word ptr [bp - 0xc]
  0x0A635: add      word ptr [0x8dd8], cx
  0x0A639: sub      cx, ax
  0x0A63B: mov      word ptr [0x8e6a], cx
  0x0A63F: add      word ptr [bp - 4], ax
  0x0A642: push     word ptr [bp - 4]
  0x0A645: push     0
  0x0A647: push     cs
  0x0A648: call     0x8e46
  0x0A64B: add      sp, 4
  0x0A64E: push     word ptr [0x8de8]
  0x0A652: push     5
  0x0A654: push     cs
  0x0A655: call     0x8e46
  0x0A658: add      sp, 4
  0x0A65B: push     0xe
  0x0A65D: push     6
  0x0A65F: push     cs
  0x0A660: call     0x8e84
  0x0A663: add      sp, 4
  0x0A666: push     0xa
  0x0A668: push     2
  0x0A66A: push     cs
  0x0A66B: call     0x8e84
  0x0A66E: add      sp, 4
  0x0A671: push     0xb
  0x0A673: push     3
  0x0A675: push     cs
  0x0A676: call     0x8e84
  0x0A679: add      sp, 4
  0x0A67C: push     0xc
  0x0A67E: push     4
  0x0A680: push     cs
  0x0A681: call     0x8e84
  0x0A684: add      sp, 4
  0x0A687: push     9
  0x0A689: push     1
  0x0A68B: push     cs
  0x0A68C: call     0x8e84
  0x0A68F: add      sp, 4
  0x0A692: push     word ptr [0x8de6]
  0x0A696: push     0xe
  0x0A698: push     cs
  0x0A699: call     0x8e46
  0x0A69C: add      sp, 4
  0x0A69F: pop      si
  0x0A6A0: leave    
  0x0A6A1: retf     

============================================================
func_L282 at file 0x0A6A2, 130 bytes
============================================================
  0x0A6A2: enter    0x1e, 0
  0x0A6A6: push     si
  0x0A6A7: mov      word ptr [bp - 6], 0
  0x0A6AC: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A6B0: mov      al, byte ptr [bx]
  0x0A6B2: sub      ah, ah
  0x0A6B4: add      ax, word ptr [bp + 6]
  0x0A6B7: dec      ax
  0x0A6B8: dec      ax
  0x0A6B9: mov      word ptr [bp - 2], ax
  0x0A6BC: mov      al, byte ptr [bx + 1]
  0x0A6BF: sub      ah, ah
  0x0A6C1: add      ax, word ptr [bp + 8]
  0x0A6C4: dec      ax
  0x0A6C5: dec      ax
  0x0A6C6: mov      word ptr [bp - 4], ax
  0x0A6C9: mov      ax, word ptr [bp + 6]
  0x0A6CC: dec      ax
  0x0A6CD: dec      ax
  0x0A6CE: or       ax, ax
  0x0A6D0: jg       0xa6da
  0x0A6D2: mov      ax, word ptr [bp + 6]
  0x0A6D5: dec      ax
  0x0A6D6: dec      ax
  0x0A6D7: not      ax
  0x0A6D9: inc      ax
  0x0A6DA: mov      word ptr [bp - 0x10], ax
  0x0A6DD: mov      ax, word ptr [bp + 8]
  0x0A6E0: dec      ax
  0x0A6E1: dec      ax
  0x0A6E2: or       ax, ax
  0x0A6E4: jg       0xa6ee
  0x0A6E6: mov      ax, word ptr [bp + 8]
  0x0A6E9: dec      ax
  0x0A6EA: dec      ax
  0x0A6EB: not      ax
  0x0A6ED: inc      ax
  0x0A6EE: mov      word ptr [bp - 0x14], ax
  0x0A6F1: push     word ptr [bp - 4]
  0x0A6F4: push     word ptr [bp - 2]
  0x0A6F7: lcall    0x37f, 0xa
  0x0A6FC: add      sp, 4
  0x0A6FF: or       ax, ax
  0x0A701: je       0xa71a
  0x0A703: push     cs
  0x0A704: call     0x8720
  0x0A707: push     ax
  0x0A708: push     word ptr [bp - 0x14]
  0x0A70B: push     word ptr [bp - 0x10]
  0x0A70E: lcall    0x37f, 0x3c
  0x0A713: add      sp, 6
  0x0A716: or       ax, ax
  0x0A718: jne      0xa724
  0x0A71A: or       byte ptr [bp - 6], 0x10
  0x0A71E: mov      ax, word ptr [bp - 6]
  0x0A721: pop      si
  0x0A722: leave    
  0x0A723: retf     

============================================================
func_L283 at file 0x0A93E, 78 bytes
============================================================
  0x0A93E: enter    4, 0
  0x0A942: push     si
  0x0A943: cmp      byte ptr [0x34c], 0
  0x0A948: jne      0xa98c
  0x0A94A: mov      word ptr [bp - 4], 0
  0x0A94F: jmp      0xa97f
  0x0A951: nop      
  0x0A952: inc      word ptr [bp - 2]
  0x0A955: cmp      word ptr [bp - 2], 5
  0x0A959: jge      0xa97c
  0x0A95B: push     word ptr [bp - 4]
  0x0A95E: push     word ptr [bp - 2]
  0x0A961: push     cs
  0x0A962: call     0xa6a2
  0x0A965: add      sp, 4
  0x0A968: mov      si, word ptr [bp - 2]
  0x0A96B: mov      cx, si
  0x0A96D: shl      si, 2
  0x0A970: add      si, cx
  0x0A972: mov      bx, word ptr [bp - 4]
  0x0A975: mov      byte ptr [bx + si - 0x7210], al
  0x0A979: jmp      0xa952
  0x0A97B: nop      
  0x0A97C: inc      word ptr [bp - 4]
  0x0A97F: cmp      word ptr [bp - 4], 5
  0x0A983: jge      0xa98c
  0x0A985: mov      word ptr [bp - 2], 0
  0x0A98A: jmp      0xa955

============================================================
func_L284 at file 0x0A994, 293 bytes
============================================================
  0x0A994: enter    0x10, 0
  0x0A998: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A99C: mov      al, byte ptr [bx + 1]
  0x0A99F: sub      ah, ah
  0x0A9A1: push     ax
  0x0A9A2: mov      al, byte ptr [bx]
  0x0A9A4: push     ax
  0x0A9A5: lcall    0x37f, 0x2a0
  0x0A9AA: add      sp, 4
  0x0A9AD: mov      word ptr [bp - 8], ax
  0x0A9B0: push     cs
  0x0A9B1: call     0xa93e
  0x0A9B4: mov      word ptr [bp - 0xe], 0
  0x0A9B9: jmp      0xab1d
  0x0A9BC: inc      word ptr [bp - 0xc]
  0x0A9BF: cmp      word ptr [bp - 0xc], 5
  0x0A9C3: jl       0xa9c8
  0x0A9C5: jmp      0xab1a
  0x0A9C8: mov      word ptr [bp - 6], 0xffff
  0x0A9CD: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0A9D1: mov      al, byte ptr [bx]
  0x0A9D3: sub      ah, ah
  0x0A9D5: add      ax, word ptr [bp - 0xc]
  0x0A9D8: dec      ax
  0x0A9D9: dec      ax
  0x0A9DA: mov      word ptr [bp - 2], ax
  0x0A9DD: mov      cl, byte ptr [bx + 1]
  0x0A9E0: sub      ch, ch
  0x0A9E2: add      cx, word ptr [bp - 0xe]
  0x0A9E5: dec      cx
  0x0A9E6: dec      cx
  0x0A9E7: mov      word ptr [bp - 4], cx
  0x0A9EA: push     cx
  0x0A9EB: push     ax
  0x0A9EC: lcall    0x37f, 0xa
  0x0A9F1: add      sp, 4
  0x0A9F4: or       ax, ax
  0x0A9F6: je       0xaa2d
  0x0A9F8: push     word ptr [bp - 8]
  0x0A9FB: push     -1
  0x0A9FD: push     word ptr [bp - 4]
  0x0AA00: push     word ptr [bp - 2]
  0x0AA03: lcall    0x181f, 0xd84
  0x0AA08: add      sp, 8
  0x0AA0B: or       ax, ax
  0x0AA0D: jl       0xaa2d
  0x0AA0F: push     word ptr [0x8d52]  ; glob_8D52
  0x0AA13: lcall    0x5dc, 0x6a
  0x0AA18: add      sp, 2
  0x0AA1B: cmp      word ptr [0x8db8], ax  ; glob_8DB8
  0x0AA1F: jg       0xaa2d
  0x0AA21: mov      bx, word ptr [0x8d4a]  ; glob_8D4A
  0x0AA25: mov      al, byte ptr [bx + 2]
  0x0AA28: sub      ah, ah
  0x0AA2A: mov      word ptr [bp - 6], ax
  0x0AA2D: push     word ptr [bp - 0xe]
  0x0AA30: push     word ptr [bp - 0xc]
  0x0AA33: push     cs
  0x0AA34: call     0x8956
  0x0AA37: add      sp, 4
  0x0AA3A: or       al, al
  0x0AA3C: jl       0xaa43
  0x0AA3E: mov      word ptr [bp - 6], 0xffff
  0x0AA43: push     word ptr [bp - 4]
  0x0AA46: push     word ptr [bp - 2]
  0x0AA49: lcall    0x3e4, 0x74
  0x0AA4E: add      sp, 4
  0x0AA51: or       ax, ax
  0x0AA53: je       0xaa5a
  0x0AA55: mov      word ptr [bp - 6], 0xffff
  0x0AA5A: push     word ptr [bp - 0xe]
  0x0AA5D: push     word ptr [bp - 0xc]
  0x0AA60: push     cs
  0x0AA61: call     0x88d0
  0x0AA64: add      sp, 4
  0x0AA67: or       ax, ax
  0x0AA69: je       0xaa70
  0x0AA6B: mov      word ptr [bp - 6], 0xffff
  0x0AA70: cmp      word ptr [bp - 6], 0
  0x0AA74: jl       0xaa94
  0x0AA76: push     word ptr [bp - 6]
  0x0AA79: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0AA7D: mov      al, byte ptr [bx + 0x1a]
  0x0AA80: sub      ah, ah
  0x0AA82: push     ax
  0x0AA83: lcall    0x5b3, 4
  0x0AA88: add      sp, 4
  0x0AA8B: test     al, 0x20
  0x0AA8D: jne      0xaa94
  0x0AA8F: mov      word ptr [bp - 6], 0xffff
  0x0AA94: push     2
  0x0AA96: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0AA9A: mov      al, byte ptr [bx + 0x1a]
  0x0AA9D: sub      ah, ah
  0x0AA9F: push     ax
  0x0AAA0: lcall    0x981, 0
  0x0AAA5: add      sp, 4
  0x0AAA8: or       ax, ax
  0x0AAAA: je       0xaab1
  0x0AAAC: mov      word ptr [bp - 6], 0xffff
  0x0AAB1: mov      al, byte ptr [bp - 6]
  0x0AAB4: mov      bx, word ptr [bp - 0xc]
  0x0AAB7: mov      cx, bx

============================================================
func_L285 at file 0x0AB2E, 70 bytes
============================================================
  0x0AB2E: enter    0xa, 0
  0x0AB32: push     si
  0x0AB33: mov      word ptr [bp - 8], 0
  0x0AB38: jmp      0xab67
  0x0AB3A: inc      word ptr [bp - 6]
  0x0AB3D: cmp      word ptr [bp - 6], 5
  0x0AB41: jge      0xab64
  0x0AB43: mov      si, word ptr [bp - 6]
  0x0AB46: mov      ax, si
  0x0AB48: shl      si, 2
  0x0AB4B: add      si, ax
  0x0AB4D: mov      bx, word ptr [bp - 8]
  0x0AB50: cmp      byte ptr [bx + si - 0x7210], 0
  0x0AB55: je       0xab3a
  0x0AB57: push     -1
  0x0AB59: push     bx
  0x0AB5A: push     ax
  0x0AB5B: push     cs
  0x0AB5C: call     0x8982
  0x0AB5F: add      sp, 6
  0x0AB62: jmp      0xab3a
  0x0AB64: inc      word ptr [bp - 8]
  0x0AB67: cmp      word ptr [bp - 8], 5
  0x0AB6B: jge      0xab74
  0x0AB6D: mov      word ptr [bp - 6], 0
  0x0AB72: jmp      0xab3d

============================================================
func_L286 at file 0x0AB78, 29 bytes
============================================================
  0x0AB78: enter    0x42, 0
  0x0AB7C: push     si
  0x0AB7D: mov      word ptr [bp - 0xa], 1
  0x0AB82: sub      ax, ax
  0x0AB84: mov      word ptr [bp - 0x12], ax
  0x0AB87: mov      word ptr [bp - 0xc], ax
  0x0AB8A: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0AB8E: mov      al, byte ptr [bx + 0x1a]
  0x0AB91: sub      ah, ah

============================================================
func_L287 at file 0x0AB95, 78 bytes
============================================================
  0x0AB95: enter    0x43d, 0
  0x0AB99: jge      0xabac
  0x0AB9B: imul     bx, ax, 0x34  ; *AI
  0x0AB9E: cmp      byte ptr [bx + 0x543f], ah  ; ai_pers
  0x0ABA2: jne      0xabac
  0x0ABA4: mov      word ptr [bp - 0x26], 1
  0x0ABA9: jmp      0xabb1
  0x0ABAB: nop      
  0x0ABAC: mov      word ptr [bp - 0x26], 0
  0x0ABB1: push     cs
  0x0ABB2: call     0x8d00
  0x0ABB5: mov      word ptr [bp - 4], ax
  0x0ABB8: cmp      word ptr [bp - 0x26], 0
  0x0ABBC: jne      0xac24
  0x0ABBE: mov      ax, word ptr [bp + 6]
  0x0ABC1: mov      word ptr [bp - 0x2e], ax
  0x0ABC4: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0ABC8: mov      al, byte ptr [bx]
  0x0ABCA: sub      ah, ah
  0x0ABCC: mov      dl, byte ptr [bx + 1]
  0x0ABCF: sub      dh, dh
  0x0ABD1: lcall    0x427, 0x5c
  0x0ABD6: jmp      0xabff
  0x0ABD8: imul     bx, ax, 0x1c  ; *Unit
  0x0ABDB: mov      bl, byte ptr [bx + 0x3146]
  0x0ABDF: sub      bh, bh
  0x0ABE1: mov      ax, bx

============================================================
func_L288 at file 0x0B150, 155 bytes
============================================================
  0x0B150: enter    0x24, 0
  0x0B154: push     si
  0x0B155: mov      word ptr [bp - 0x24], 0
  0x0B15A: jmp      0xb166
  0x0B15C: mov      si, word ptr [bp - 0x24]
  0x0B15F: mov      byte ptr [bp + si - 0x22], 0
  0x0B163: inc      word ptr [bp - 0x24]
  0x0B166: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0B16A: mov      al, byte ptr [bx + 0x1f]
  0x0B16D: cwde     
  0x0B16E: cmp      ax, word ptr [bp - 0x24]
  0x0B171: jg       0xb15c
  0x0B173: mov      byte ptr [bp - 2], 0
  0x0B177: mov      al, byte ptr [bp - 2]
  0x0B17A: cwde     
  0x0B17B: mov      si, ax
  0x0B17D: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0B181: cmp      byte ptr [bx + si + 0x70], 0
  0x0B185: jl       0xb191
  0x0B187: mov      al, byte ptr [bx + si + 0x70]
  0x0B18A: cwde     
  0x0B18B: mov      si, ax
  0x0B18D: mov      byte ptr [bp + si - 0x22], 1
  0x0B191: inc      byte ptr [bp - 2]
  0x0B194: cmp      byte ptr [bp - 2], 0x14
  0x0B198: jl       0xb177
  0x0B19A: mov      word ptr [bp - 0x24], 0
  0x0B19F: jmp      0xb1b1
  0x0B1A1: nop      
  0x0B1A2: push     0xd
  0x0B1A4: push     word ptr [bp - 0x24]
  0x0B1A7: push     cs
  0x0B1A8: call     0x9318
  0x0B1AB: add      sp, 4
  0x0B1AE: inc      word ptr [bp - 0x24]
  0x0B1B1: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0B1B5: mov      al, byte ptr [bx + 0x1f]
  0x0B1B8: cwde     
  0x0B1B9: cmp      ax, word ptr [bp - 0x24]
  0x0B1BC: jle      0xb1e8
  0x0B1BE: mov      si, word ptr [bp - 0x24]
  0x0B1C1: cmp      byte ptr [bp + si - 0x22], 0
  0x0B1C5: jne      0xb1ae
  0x0B1C7: push     si
  0x0B1C8: push     cs
  0x0B1C9: call     0x90c8
  0x0B1CC: add      sp, 2
  0x0B1CF: cmp      ax, 9
  0x0B1D2: jge      0xb1ae
  0x0B1D4: push     -1
  0x0B1D6: push     si
  0x0B1D7: push     cs
  0x0B1D8: call     0xab78
  0x0B1DB: add      sp, 4
  0x0B1DE: or       ax, ax
  0x0B1E0: jne      0xb1a2
  0x0B1E2: mov      byte ptr [bp + si - 0x22], 1
  0x0B1E6: jmp      0xb1ae
  0x0B1E8: pop      si
  0x0B1E9: leave    
  0x0B1EA: retf     

============================================================
func_L289 at file 0x0B1EC, 42 bytes
============================================================
  0x0B1EC: enter    4, 0
  0x0B1F0: mov      word ptr [bp - 2], 0
  0x0B1F5: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0B1F9: mov      al, byte ptr [bx]
  0x0B1FB: sub      ah, ah
  0x0B1FD: mov      dl, byte ptr [bx + 1]
  0x0B200: sub      dh, dh
  0x0B202: lcall    0x427, 0x5c
  0x0B207: jmp      0xb232
  0x0B209: nop      
  0x0B20A: imul     bx, word ptr [bp - 4], 0x1c  ; *Unit
  0x0B20E: mov      bl, byte ptr [bx + 0x3146]
  0x0B212: sub      bh, bh
  0x0B214: mov      ax, bx

============================================================
func_L290 at file 0x0B23E, 46 bytes
============================================================
  0x0B23E: enter    6, 0
  0x0B242: mov      ax, 0xffff
  0x0B245: mov      word ptr [bp - 4], ax
  0x0B248: mov      word ptr [bp - 2], ax
  0x0B24B: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0B24F: mov      al, byte ptr [bx]
  0x0B251: sub      ah, ah
  0x0B253: mov      dl, byte ptr [bx + 1]
  0x0B256: sub      dh, dh
  0x0B258: lcall    0x427, 0x5c
  0x0B25D: jmp      0xb296
  0x0B25F: nop      
  0x0B260: imul     bx, word ptr [bp - 6], 0x1c  ; *Unit
  0x0B264: mov      bl, byte ptr [bx + 0x3146]
  0x0B268: sub      bh, bh
  0x0B26A: mov      ax, bx

============================================================
func_L291 at file 0x0B2A2, 31 bytes
============================================================
  0x0B2A2: enter    4, 0
  0x0B2A6: push     si
  0x0B2A7: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x0B2AB: mov      al, byte ptr [bx + 0x3150]
  0x0B2AF: sub      ah, ah
  0x0B2B1: cmp      ax, word ptr [bp + 8]
  0x0B2B4: jg       0xb2c2
  0x0B2B6: mov      word ptr [bp - 4], 0xffff
  0x0B2BB: mov      ax, word ptr [bp - 4]
  0x0B2BE: pop      si
  0x0B2BF: leave    
  0x0B2C0: retf     

============================================================
func_L292 at file 0x0B2F0, 20 bytes
============================================================
  0x0B2F0: push     bp
  0x0B2F1: mov      bp, sp
  0x0B2F3: push     si
  0x0B2F4: imul     si, word ptr [bp + 6], 0x1c  ; *Unit
  0x0B2F8: mov      bx, word ptr [bp + 8]
  0x0B2FB: mov      al, byte ptr [bx + si + 0x3154]
  0x0B2FF: sub      ah, ah
  0x0B301: pop      si
  0x0B302: leave    
  0x0B303: retf     

============================================================
func_L293 at file 0x0B304, 21 bytes
============================================================
  0x0B304: push     bp
  0x0B305: mov      bp, sp
  0x0B307: push     si
  0x0B308: mov      al, byte ptr [bp + 0xa]
  0x0B30B: imul     si, word ptr [bp + 6], 0x1c  ; *Unit
  0x0B30F: mov      bx, word ptr [bp + 8]
  0x0B312: mov      byte ptr [bx + si + 0x3154], al
  0x0B316: pop      si
  0x0B317: leave    
  0x0B318: retf     

============================================================
func_L294 at file 0x0B31A, 77 bytes
============================================================
  0x0B31A: enter    6, 0
  0x0B31E: push     si
  0x0B31F: mov      word ptr [bp - 4], 0xf0
  0x0B324: mov      ax, word ptr [bp + 8]
  0x0B327: sar      ax, 1
  0x0B329: mov      word ptr [bp - 2], ax
  0x0B32C: mov      si, ax
  0x0B32E: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x0B332: mov      al, byte ptr [bx + si + 0x3151]
  0x0B336: sub      ah, ah
  0x0B338: mov      word ptr [bp - 6], ax
  0x0B33B: test     byte ptr [bp + 8], 1
  0x0B33F: je       0xb34a
  0x0B341: mov      word ptr [bp - 4], 0xf
  0x0B346: shl      word ptr [bp + 0xa], 4
  0x0B34A: mov      ax, word ptr [bp - 4]
  0x0B34D: and      ax, word ptr [bp - 6]
  0x0B350: or       ax, word ptr [bp + 0xa]
  0x0B353: mov      word ptr [bp - 6], ax
  0x0B356: imul     si, word ptr [bp + 6], 0x1c  ; *Unit
  0x0B35A: mov      bx, word ptr [bp - 2]
  0x0B35D: mov      byte ptr [bx + si + 0x3151], al
  0x0B361: mov      ax, word ptr [bp - 6]
  0x0B364: pop      si
  0x0B365: leave    
  0x0B366: retf     

============================================================
func_L295 at file 0x0B368, 126 bytes
============================================================
  0x0B368: enter    0xa, 0
  0x0B36C: push     si
  0x0B36D: mov      word ptr [bp - 6], 0
  0x0B372: jmp      0xb3c4
  0x0B374: push     word ptr [bp - 6]
  0x0B377: push     word ptr [bp + 6]
  0x0B37A: push     cs
  0x0B37B: call     0xb2a2
  0x0B37E: add      sp, 4
  0x0B381: cmp      ax, word ptr [bp + 8]
  0x0B384: jne      0xb3c1
  0x0B386: push     word ptr [bp - 6]
  0x0B389: push     word ptr [bp + 6]
  0x0B38C: push     cs
  0x0B38D: call     0xb2f0
  0x0B390: add      sp, 4
  0x0B393: mov      word ptr [bp - 8], ax
  0x0B396: sub      ax, 0x64
  0x0B399: neg      ax
  0x0B39B: or       ax, ax
  0x0B39D: je       0xb3c1
  0x0B39F: cmp      ax, word ptr [bp + 0xa]
  0x0B3A2: jle      0xb3a7
  0x0B3A4: mov      ax, word ptr [bp + 0xa]
  0x0B3A7: mov      word ptr [bp - 4], ax
  0x0B3AA: add      ax, word ptr [bp - 8]
  0x0B3AD: push     ax
  0x0B3AE: push     word ptr [bp - 6]
  0x0B3B1: push     word ptr [bp + 6]
  0x0B3B4: push     cs
  0x0B3B5: call     0xb304
  0x0B3B8: add      sp, 6
  0x0B3BB: mov      ax, word ptr [bp - 4]
  0x0B3BE: sub      word ptr [bp + 0xa], ax
  0x0B3C1: inc      word ptr [bp - 6]
  0x0B3C4: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x0B3C8: mov      al, byte ptr [bx + 0x3150]
  0x0B3CC: sub      ah, ah
  0x0B3CE: cmp      ax, word ptr [bp - 6]
  0x0B3D1: jg       0xb374
  0x0B3D3: cmp      word ptr [bp + 0xa], 0
  0x0B3D7: je       0xb426
  0x0B3D9: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x0B3DD: mov      al, byte ptr [bx + 0x3150]
  0x0B3E1: mov      word ptr [bp - 2], ax
  0x0B3E4: mov      cx, bx

============================================================
func_L296 at file 0x0B42C, 139 bytes
============================================================
  0x0B42C: enter    4, 0
  0x0B430: push     si
  0x0B431: push     word ptr [bp + 8]
  0x0B434: push     word ptr [bp + 6]
  0x0B437: push     cs
  0x0B438: call     0xb2a2
  0x0B43B: add      sp, 4
  0x0B43E: mov      word ptr [bp - 2], ax
  0x0B441: or       ax, ax
  0x0B443: jl       0xb4b1
  0x0B445: push     word ptr [bp + 8]
  0x0B448: push     word ptr [bp + 6]
  0x0B44B: push     cs
  0x0B44C: call     0xb2f0
  0x0B44F: add      sp, 4
  0x0B452: mov      word ptr [0x8dc4], ax
  0x0B455: mov      ax, word ptr [bp + 8]
  0x0B458: mov      word ptr [bp - 4], ax
  0x0B45B: jmp      0xb499
  0x0B45D: nop      
  0x0B45E: mov      ax, word ptr [bp - 4]
  0x0B461: inc      ax
  0x0B462: push     ax
  0x0B463: push     word ptr [bp + 6]
  0x0B466: mov      si, ax
  0x0B468: push     cs
  0x0B469: call     0xb2a2
  0x0B46C: add      sp, 4
  0x0B46F: push     ax
  0x0B470: push     word ptr [bp - 4]
  0x0B473: push     word ptr [bp + 6]
  0x0B476: push     cs
  0x0B477: call     0xb31a
  0x0B47A: add      sp, 6
  0x0B47D: push     si
  0x0B47E: push     word ptr [bp + 6]
  0x0B481: push     cs
  0x0B482: call     0xb2f0
  0x0B485: add      sp, 4
  0x0B488: push     ax
  0x0B489: push     word ptr [bp - 4]
  0x0B48C: push     word ptr [bp + 6]
  0x0B48F: push     cs
  0x0B490: call     0xb304
  0x0B493: add      sp, 6
  0x0B496: inc      word ptr [bp - 4]
  0x0B499: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x0B49D: mov      al, byte ptr [bx + 0x3150]
  0x0B4A1: sub      ah, ah
  0x0B4A3: dec      ax
  0x0B4A4: cmp      ax, word ptr [bp - 4]
  0x0B4A7: jg       0xb45e
  0x0B4A9: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x0B4AD: dec      byte ptr [bx + 0x3150]
  0x0B4B1: mov      ax, word ptr [bp - 2]
  0x0B4B4: pop      si
  0x0B4B5: leave    
  0x0B4B6: retf     

============================================================
func_L297 at file 0x0B4B8, 11 bytes
============================================================
  0x0B4B8: enter    4, 0
  0x0B4BC: push     si
  0x0B4BD: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x0B4C1: mov      ax, bx

============================================================
func_L298 at file 0x0B550, 88 bytes
============================================================
  0x0B550: enter    6, 0
  0x0B554: mov      word ptr [bp - 4], 0xffff
  0x0B559: mov      word ptr [bp - 6], 0
  0x0B55E: jmp      0xb58a
  0x0B560: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x0B564: mov      al, byte ptr [bx + 0x3150]
  0x0B568: sub      ah, ah
  0x0B56A: cmp      ax, word ptr [bp - 6]
  0x0B56D: jle      0xb590
  0x0B56F: push     word ptr [bp - 6]
  0x0B572: push     word ptr [bp + 6]
  0x0B575: push     cs
  0x0B576: call     0xb2a2
  0x0B579: add      sp, 4
  0x0B57C: cmp      ax, word ptr [bp + 8]
  0x0B57F: jne      0xb587
  0x0B581: mov      ax, word ptr [bp - 6]
  0x0B584: mov      word ptr [bp - 4], ax
  0x0B587: inc      word ptr [bp - 6]
  0x0B58A: cmp      word ptr [bp - 4], 0
  0x0B58E: jl       0xb560
  0x0B590: cmp      word ptr [bp - 4], 0
  0x0B594: jl       0xb5a3
  0x0B596: push     word ptr [bp - 4]
  0x0B599: push     word ptr [bp + 6]
  0x0B59C: push     cs
  0x0B59D: call     0xb2f0
  0x0B5A0: mov      word ptr [0x8dc4], ax
  0x0B5A3: mov      ax, word ptr [bp - 4]
  0x0B5A6: leave    
  0x0B5A7: retf     

============================================================
func_L299 at file 0x0B5A8, 82 bytes
============================================================
  0x0B5A8: enter    4, 0
  0x0B5AC: mov      word ptr [bp - 4], 0
  0x0B5B1: cmp      word ptr [bp + 6], 0
  0x0B5B5: jge      0xb5be
  0x0B5B7: sub      ax, ax
  0x0B5B9: mov      word ptr [bp - 4], ax
  0x0B5BC: jmp      0xb5e4
  0x0B5BE: cmp      word ptr [bp + 6], 0x2a
  0x0B5C2: jge      0xb5ce
  0x0B5C4: mov      word ptr [bp - 4], 1
  0x0B5C9: mov      ax, word ptr [bp + 6]
  0x0B5CC: jmp      0xb5e4
  0x0B5CE: mov      ax, word ptr [bp + 6]
  0x0B5D1: sub      ax, 0x2a
  0x0B5D4: mov      word ptr [bp - 2], ax
  0x0B5D7: cmp      ax, 7
  0x0B5DA: jge      0xb5e7
  0x0B5DC: mov      word ptr [bp - 4], 2
  0x0B5E1: add      ax, 0xb
  0x0B5E4: mov      word ptr [bp - 2], ax
  0x0B5E7: cmp      word ptr [bp + 8], 0
  0x0B5EB: je       0xb5f5
  0x0B5ED: mov      ax, word ptr [bp - 2]
  0x0B5F0: mov      bx, word ptr [bp + 8]
  0x0B5F3: mov      word ptr [bx], ax
  0x0B5F5: mov      ax, word ptr [bp - 4]
  0x0B5F8: leave    
  0x0B5F9: retf     

============================================================
func_L300 at file 0x0B5FA, 47 bytes
============================================================
  0x0B5FA: enter    8, 0
  0x0B5FE: sub      ax, ax
  0x0B600: mov      word ptr [bp - 6], ax
  0x0B603: mov      word ptr [bp - 8], ax
  0x0B606: lea      ax, [bp - 4]
  0x0B609: push     ax
  0x0B60A: push     word ptr [bp + 6]
  0x0B60D: push     cs
  0x0B60E: call     0xb5a8
  0x0B611: add      sp, 4
  0x0B614: mov      word ptr [bp - 2], ax
  0x0B617: dec      ax
  0x0B618: je       0xb624
  0x0B61A: dec      ax
  0x0B61B: je       0xb644
  0x0B61D: push     word ptr [0x2dfa]
  0x0B621: jmp      0xb634
  0x0B623: nop      
  0x0B624: mov      bx, word ptr [bp - 4]
  0x0B627: mov      ax, bx

============================================================
func_L301 at file 0x0B65A, 39 bytes
============================================================
  0x0B65A: enter    8, 0
  0x0B65E: mov      word ptr [bp - 8], 0
  0x0B663: lea      ax, [bp - 6]
  0x0B666: push     ax
  0x0B667: push     word ptr [bp + 6]
  0x0B66A: push     cs
  0x0B66B: call     0xb5a8
  0x0B66E: add      sp, 4
  0x0B671: mov      word ptr [bp - 2], ax
  0x0B674: dec      ax
  0x0B675: je       0xb67c
  0x0B677: dec      ax
  0x0B678: je       0xb6a2
  0x0B67A: jmp      0xb6ec
  0x0B67C: mov      bx, word ptr [bp - 6]
  0x0B67F: mov      ax, bx

============================================================
func_L302 at file 0x0B704, 162 bytes
============================================================
  0x0B704: enter    0x14, 0
  0x0B708: push     si
  0x0B709: mov      word ptr [bp - 2], 0xfffe
  0x0B70E: cmp      word ptr [bp + 6], 0x13
  0x0B712: jl       0xb717
  0x0B714: jmp      0xb7a6
  0x0B717: push     word ptr [bp + 6]
  0x0B71A: push     cs
  0x0B71B: call     0x8d9c
  0x0B71E: add      sp, 2
  0x0B721: mov      word ptr [bp - 0x14], ax
  0x0B724: or       ax, ax
  0x0B726: jl       0xb737
  0x0B728: push     ax
  0x0B729: push     cs
  0x0B72A: call     0x863e
  0x0B72D: add      sp, 2
  0x0B730: or       ax, ax
  0x0B732: jne      0xb737
  0x0B734: mov      word ptr [bp - 2], ax
  0x0B737: cmp      word ptr [bp + 6], 0x12
  0x0B73B: je       0xb740
  0x0B73D: jmp      0xb87a
  0x0B740: push     word ptr [0x8d7c]
  0x0B744: push     cs
  0x0B745: call     0x9102
  0x0B748: add      sp, 2
  0x0B74B: mov      word ptr [bp - 0x12], ax
  0x0B74E: cmp      ax, 0x1c
  0x0B751: jne      0xb758
  0x0B753: mov      word ptr [bp - 0x12], 0x19
  0x0B758: mov      bx, word ptr [bp - 0x12]
  0x0B75B: shl      bx, 3
  0x0B75E: mov      ax, word ptr [bx - 0x715a]
  0x0B762: mov      word ptr [bp - 6], ax
  0x0B765: cmp      ax, 4
  0x0B768: jne      0xb76f
  0x0B76A: mov      word ptr [bp - 2], 0
  0x0B76F: cmp      ax, 3
  0x0B772: jne      0xb784
  0x0B774: push     0xe
  0x0B776: push     cs
  0x0B777: call     0x863e
  0x0B77A: add      sp, 2
  0x0B77D: or       ax, ax
  0x0B77F: jne      0xb784
  0x0B781: mov      word ptr [bp - 2], ax
  0x0B784: cmp      word ptr [bp - 6], 2
  0x0B788: je       0xb78d
  0x0B78A: jmp      0xb87a
  0x0B78D: push     0xd
  0x0B78F: push     cs
  0x0B790: call     0x863e
  0x0B793: add      sp, 2
  0x0B796: or       ax, ax
  0x0B798: je       0xb79d
  0x0B79A: jmp      0xb87a
  0x0B79D: mov      word ptr [bp - 2], ax
  0x0B7A0: mov      ax, word ptr [bp - 2]
  0x0B7A3: pop      si
  0x0B7A4: leave    
  0x0B7A5: retf     

============================================================
func_L303 at file 0x0B880, 80 bytes
============================================================
  0x0B880: enter    2, 0
  0x0B884: push     si
  0x0B885: mov      si, word ptr [bp + 8]
  0x0B888: shl      si, 1
  0x0B88A: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0B88E: mov      ax, word ptr [bx + si + 0x9a]
  0x0B892: cmp      ax, 0x64
  0x0B895: jle      0xb89a
  0x0B897: mov      ax, 0x64
  0x0B89A: cmp      ax, word ptr [bp + 0xa]
  0x0B89D: jle      0xb8a2
  0x0B89F: mov      ax, word ptr [bp + 0xa]
  0x0B8A2: mov      word ptr [0x8dc4], ax
  0x0B8A5: sub      word ptr [bx + si + 0x9a], ax
  0x0B8A9: push     word ptr [0x8dc4]
  0x0B8AD: push     word ptr [bp + 8]
  0x0B8B0: push     word ptr [bp + 6]
  0x0B8B3: push     cs
  0x0B8B4: call     0xb368
  0x0B8B7: add      sp, 6
  0x0B8BA: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x0B8BE: cmp      byte ptr [bx + 0x314c], 2
  0x0B8C3: je       0xb8ca
  0x0B8C5: mov      byte ptr [bx + 0x314c], 0
  0x0B8CA: mov      ax, word ptr [bp - 2]
  0x0B8CD: pop      si
  0x0B8CE: leave    
  0x0B8CF: retf     

============================================================
func_L304 at file 0x0B8D0, 47 bytes
============================================================
  0x0B8D0: enter    4, 0
  0x0B8D4: push     si
  0x0B8D5: push     word ptr [bp + 8]
  0x0B8D8: push     word ptr [bp + 6]
  0x0B8DB: push     cs
  0x0B8DC: call     0xb42c
  0x0B8DF: add      sp, 4
  0x0B8E2: mov      word ptr [bp - 4], ax
  0x0B8E5: or       ax, ax
  0x0B8E7: jl       0xb8f9
  0x0B8E9: mov      ax, word ptr [0x8dc4]
  0x0B8EC: mov      si, word ptr [bp - 4]
  0x0B8EF: shl      si, 1
  0x0B8F1: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0B8F5: add      word ptr [bx + si + 0x9a], ax
  0x0B8F9: mov      ax, word ptr [bp - 2]
  0x0B8FC: pop      si
  0x0B8FD: leave    
  0x0B8FE: retf     

============================================================
func_L305 at file 0x0B900, 57 bytes
============================================================
  0x0B900: enter    0x12, 0
  0x0B904: push     si
  0x0B905: mov      word ptr [bp - 0x12], 1
  0x0B90A: lea      ax, [bp - 0xc]
  0x0B90D: push     ax
  0x0B90E: push     word ptr [bp + 6]
  0x0B911: push     cs
  0x0B912: call     0xb5a8
  0x0B915: add      sp, 4
  0x0B918: mov      word ptr [bp - 6], ax
  0x0B91B: or       ax, ax
  0x0B91D: jne      0xb922
  0x0B91F: jmp      0xbb64
  0x0B922: cmp      ax, 1
  0x0B925: je       0xb92a
  0x0B927: jmp      0xbacc
  0x0B92A: mov      word ptr [bp - 0x12], ax
  0x0B92D: mov      bx, word ptr [0x8542]  ; cur_nation
  0x0B931: mov      al, byte ptr [bx + 0x1f]
  0x0B934: mov      bx, word ptr [bp - 0xc]
  0x0B937: mov      cx, bx

============================================================
func_L306 at file 0x0BB6A, 45 bytes
============================================================
  0x0BB6A: enter    4, 0
  0x0BB6E: mov      word ptr [bp - 2], 0
  0x0BB73: mov      word ptr [bp - 4], 0xffff
  0x0BB78: push     word ptr [bp - 4]
  0x0BB7B: push     cs
  0x0BB7C: call     0xb900
  0x0BB7F: add      sp, 2
  0x0BB82: or       ax, ax
  0x0BB84: je       0xbb89
  0x0BB86: inc      word ptr [bp - 2]
  0x0BB89: inc      word ptr [bp - 4]
  0x0BB8C: cmp      word ptr [bp - 4], 0x31
  0x0BB90: jl       0xbb78
  0x0BB92: mov      ax, word ptr [bp - 2]
  0x0BB95: leave    
  0x0BB96: retf     

============================================================
func_L307 at file 0x0BB98, 71 bytes
============================================================
  0x0BB98: enter    6, 0
  0x0BB9C: mov      word ptr [bp - 6], 0xfffe
  0x0BBA1: mov      ax, 0xffff
  0x0BBA4: mov      word ptr [bp - 4], ax
  0x0BBA7: mov      word ptr [bp - 2], ax
  0x0BBAA: jmp      0xbbd4
  0x0BBAC: cmp      word ptr [bp - 2], 0x31
  0x0BBB0: jge      0xbbda
  0x0BBB2: push     word ptr [bp - 2]
  0x0BBB5: push     cs
  0x0BBB6: call     0xb900
  0x0BBB9: add      sp, 2
  0x0BBBC: or       ax, ax
  0x0BBBE: je       0xbbd1
  0x0BBC0: mov      ax, word ptr [bp + 6]
  0x0BBC3: inc      word ptr [bp - 4]
  0x0BBC6: cmp      word ptr [bp - 4], ax
  0x0BBC9: jne      0xbbd1
  0x0BBCB: mov      ax, word ptr [bp - 2]
  0x0BBCE: mov      word ptr [bp - 6], ax
  0x0BBD1: inc      word ptr [bp - 2]
  0x0BBD4: cmp      word ptr [bp - 6], -1
  0x0BBD8: jl       0xbbac
  0x0BBDA: mov      ax, word ptr [bp - 6]
  0x0BBDD: leave    
  0x0BBDE: retf     

============================================================
func_L308 at file 0x0BC10, 16 bytes
============================================================
  0x0BC10: push     bp
  0x0BC11: mov      bp, sp
  0x0BC13: push     si
  0x0BC14: cmp      word ptr [bp + 8], 0
  0x0BC18: jge      0xbc20
  0x0BC1A: mov      ax, 1
  0x0BC1D: pop      si
  0x0BC1E: leave    
  0x0BC1F: retf     

============================================================
func_L309 at file 0x0BC4E, 50 bytes
============================================================
  0x0BC4E: enter    4, 0
  0x0BC52: mov      ax, word ptr [bp + 8]
  0x0BC55: shl      ax, 2
  0x0BC58: push     word ptr [0x366]
  0x0BC5C: push     word ptr [0x364]
  0x0BC60: push     word ptr [0x362]
  0x0BC64: push     word ptr [0x360]
  0x0BC68: push     4
  0x0BC6A: mov      cl, byte ptr [bp + 0xa]
  0x0BC6D: push     cx
  0x0BC6E: mov      dx, ax
  0x0BC70: mov      ax, word ptr [bp + 6]
  0x0BC73: shl      ax, 2
  0x0BC76: mov      bx, 4
  0x0BC79: lcall    0xb9e, 0xa
  0x0BC7E: leave    
  0x0BC7F: retf     

============================================================
func_L310 at file 0x0BC80, 41 bytes
============================================================
  0x0BC80: push     bp
  0x0BC81: mov      bp, sp
  0x0BC83: push     word ptr [0x366]
  0x0BC87: push     word ptr [0x364]
  0x0BC8B: push     word ptr [0x362]
  0x0BC8F: push     word ptr [0x360]
  0x0BC93: push     1
  0x0BC95: mov      al, byte ptr [bp + 0xa]
  0x0BC98: push     ax
  0x0BC99: mov      ax, word ptr [bp + 6]
  0x0BC9C: mov      dx, word ptr [bp + 8]
  0x0BC9F: mov      bx, 1
  0x0BCA2: lcall    0xb9e, 0xa
  0x0BCA7: leave    
  0x0BCA8: retf     

============================================================
func_L311 at file 0x0BCAA, 64 bytes
============================================================
  0x0BCAA: push     bp
  0x0BCAB: mov      bp, sp
  0x0BCAD: push     word ptr [0x2dae]
  0x0BCB1: push     word ptr [0x2dac]
  0x0BCB5: push     word ptr [0x2daa]
  0x0BCB9: push     word ptr [0x2da8]  ; map_terrain
  0x0BCBD: push     3
  0x0BCBF: mov      al, byte ptr [bp + 8]
  0x0BCC2: push     ax
  0x0BCC3: mov      ax, word ptr [bp + 6]
  0x0BCC6: add      ax, 0x13b
  0x0BCC9: mov      dx, 0xc5
  0x0BCCC: mov      bx, 1
  0x0BCCF: lcall    0xb9e, 0xa
  0x0BCD4: push     0xc5
  0x0BCD7: push     5
  0x0BCD9: push     3
  0x0BCDB: mov      ax, 0x13b
  0x0BCDE: mov      dx, 0xc5
  0x0BCE1: mov      bx, ax
  0x0BCE3: lcall    0xb70, 0x3a
  0x0BCE8: leave    
  0x0BCE9: retf     

============================================================
func_L312 at file 0x0BCEA, 61 bytes
============================================================
  0x0BCEA: push     bp
  0x0BCEB: mov      bp, sp
  0x0BCED: push     word ptr [0x2dae]
  0x0BCF1: push     word ptr [0x2dac]
  0x0BCF5: push     word ptr [0x2daa]
  0x0BCF9: push     word ptr [0x2da8]  ; map_terrain
  0x0BCFD: push     3
  0x0BCFF: mov      al, byte ptr [bp + 6]
  0x0BD02: push     ax
  0x0BD03: mov      ax, 0x13b
  0x0BD06: mov      dx, 0xc5
  0x0BD09: mov      bx, 5
  0x0BD0C: lcall    0xb9e, 0xa
  0x0BD11: push     0xc5
  0x0BD14: push     5
  0x0BD16: push     3
  0x0BD18: mov      ax, 0x13b
  0x0BD1B: mov      dx, 0xc5
  0x0BD1E: mov      bx, ax
  0x0BD20: lcall    0xb70, 0x3a
  0x0BD25: leave    
  0x0BD26: retf     

============================================================
func_L313 at file 0x0BD28, 34 bytes
============================================================
  0x0BD28: push     bp
  0x0BD29: mov      bp, sp
  0x0BD2B: push     word ptr [bp + 8]
  0x0BD2E: push     word ptr [bp + 6]
  0x0BD31: lcall    0x37f, 0xa
  0x0BD36: mov      sp, bp
  0x0BD38: or       ax, ax
  0x0BD3A: je       0xbd48
  0x0BD3C: mov      ax, word ptr [bp + 6]
  0x0BD3F: mov      word ptr [0x8540], ax
  0x0BD42: mov      ax, word ptr [bp + 8]
  0x0BD45: mov      word ptr [0x853e], ax
  0x0BD48: leave    
  0x0BD49: retf     

============================================================
func_L314 at file 0x0BD4A, 404 bytes
============================================================
  0x0BD4A: enter    0xe, 0
  0x0BD4E: cmp      word ptr [0x929c], 1
  0x0BD53: sbb      ax, ax
  0x0BD55: neg      ax
  0x0BD57: mov      word ptr [0x929c], ax
  0x0BD5A: cmp      word ptr [0x5390], 0  ; season
  0x0BD5F: jne      0xbd79
  0x0BD61: imul     bx, word ptr [0x5392], 0x1c  ; *Unit
  0x0BD66: mov      al, byte ptr [bx + 0x3145]
  0x0BD6A: sub      ah, ah
  0x0BD6C: push     ax
  0x0BD6D: mov      al, byte ptr [bx + 0x3144]  ; unit_table
  0x0BD71: push     ax
  0x0BD72: push     cs
  0x0BD73: call     0xbd28
  0x0BD76: add      sp, 4
  0x0BD79: cmp      word ptr [0x53c6], 0
  0x0BD7E: je       0xbd8a
  0x0BD80: push     1
  0x0BD82: lcall    0x181f, 0xe46
  0x0BD87: add      sp, 2
  0x0BD8A: push     word ptr [0x853e]
  0x0BD8E: push     word ptr [0x8540]
  0x0BD92: lcall    0x37f, 0xa
  0x0BD97: add      sp, 4
  0x0BD9A: or       ax, ax
  0x0BD9C: je       0xbdc8
  0x0BD9E: push     word ptr [0x929c]
  0x0BDA2: cmp      word ptr [0x53a2], 0
  0x0BDA7: je       0xbdae
  0x0BDA9: mov      ax, 0xffff
  0x0BDAC: jmp      0xbdb1
  0x0BDAE: mov      ax, word ptr [0x5396]
  0x0BDB1: push     ax
  0x0BDB2: push     1
  0x0BDB4: push     1
  0x0BDB6: push     1
  0x0BDB8: push     word ptr [0x853e]
  0x0BDBC: push     word ptr [0x8540]
  0x0BDC0: lcall    0x181f, 0xe38
  0x0BDC5: add      sp, 0xe
  0x0BDC8: mov      ax, word ptr [0x8540]
  0x0BDCB: cmp      word ptr [0x8328], ax
  0x0BDCF: jle      0xbdd4
  0x0BDD1: jmp      0xbedc
  0x0BDD4: mov      ax, word ptr [0x8544]
  0x0BDD7: add      ax, word ptr [0x8328]
  0x0BDDB: cmp      ax, word ptr [0x8540]
  0x0BDDF: jg       0xbde4
  0x0BDE1: jmp      0xbedc
  0x0BDE4: mov      ax, word ptr [0x853e]
  0x0BDE7: cmp      word ptr [0x832e], ax
  0x0BDEB: jle      0xbdf0
  0x0BDED: jmp      0xbedc
  0x0BDF0: mov      ax, word ptr [0x832e]
  0x0BDF3: add      ax, word ptr [0x8546]
  0x0BDF7: cmp      ax, word ptr [0x853e]
  0x0BDFB: jg       0xbe00
  0x0BDFD: jmp      0xbedc
  0x0BE00: mov      ax, word ptr [0x853e]
  0x0BE03: sub      ax, word ptr [0x832e]
  0x0BE07: mov      cx, ax
  0x0BE09: mov      ax, word ptr [0x8540]
  0x0BE0C: sub      ax, word ptr [0x8328]
  0x0BE10: add      ax, word ptr [0x832a]
  0x0BE14: imul     word ptr [0x5ad4]
  0x0BE18: mov      word ptr [bp - 2], ax
  0x0BE1B: mov      dx, ax
  0x0BE1D: mov      ax, cx
  0x0BE1F: add      ax, word ptr [0x832c]
  0x0BE23: mov      cx, dx
  0x0BE25: imul     word ptr [0x8326]
  0x0BE29: mov      word ptr [bp - 6], ax
  0x0BE2C: push     word ptr [0x83a4]
  0x0BE30: push     word ptr [0x83a2]
  0x0BE34: push     word ptr [0x83a0]
  0x0BE38: push     word ptr [0x839e]
  0x0BE3C: push     word ptr [0x2dae]
  0x0BE40: push     word ptr [0x2dac]
  0x0BE44: push     word ptr [0x2daa]
  0x0BE48: push     word ptr [0x2da8]  ; map_terrain
  0x0BE4C: mov      dx, ax
  0x0BE4E: add      ax, 8
  0x0BE51: push     ax
  0x0BE52: push     word ptr [0x5ad4]
  0x0BE56: push     word ptr [0x8326]
  0x0BE5A: mov      ax, cx
  0x0BE5C: mov      bx, cx
  0x0BE5E: lcall    0xbaa, 6
  0x0BE63: cmp      word ptr [0x5390], 0  ; season
  0x0BE68: jne      0xbe7e
  0x0BE6A: cmp      word ptr [0x929c], 1
  0x0BE6F: sbb      ax, ax
  0x0BE71: neg      ax
  0x0BE73: push     ax
  0x0BE74: lcall    0x181f, 0xe2a
  0x0BE79: add      sp, 2
  0x0BE7C: jmp      0xbe92
  0x0BE7E: push     1
  0x0BE80: push     1
  0x0BE82: push     word ptr [0x853e]
  0x0BE86: push     word ptr [0x8540]
  0x0BE8A: lcall    0x181f, 0x344
  0x0BE8F: add      sp, 8
  0x0BE92: cmp      word ptr [0x5390], 0  ; season
  0x0BE97: je       0xbec1
  0x0BE99: cmp      word ptr [0x929c], 0
  0x0BE9E: je       0xbec1
  0x0BEA0: mov      ax, word ptr [bp - 6]
  0x0BEA3: push     word ptr [0x840]
  0x0BEA7: push     word ptr [0x83e]
  0x0BEAB: add      ax, 8
  0x0BEAE: push     ax
  0x0BEAF: mov      ax, word ptr [0x184]
  0x0BEB2: add      ax, 0x13
  0x0BEB5: mov      dx, word ptr [bp - 2]
  0x0BEB8: lea      bx, [0x2da8]  ; map_terrain
  0x0BEBC: lcall    0xc36, 0xa
  0x0BEC1: mov      ax, word ptr [bp - 6]
  0x0BEC4: add      ax, 8
  0x0BEC7: push     ax
  0x0BEC8: push     word ptr [0x5ad4]
  0x0BECC: push     word ptr [0x8326]
  0x0BED0: mov      dx, ax
  0x0BED2: mov      ax, word ptr [bp - 2]
  0x0BED5: mov      bx, ax
  0x0BED7: lcall    0xb70, 0x3a
  0x0BEDC: leave    
  0x0BEDD: retf     

============================================================
func_L315 at file 0x0BEDE, 93 bytes
============================================================
  0x0BEDE: push     bp
  0x0BEDF: mov      bp, sp
  0x0BEE1: push     word ptr [bp + 8]
  0x0BEE4: push     word ptr [bp + 6]
  0x0BEE7: lcall    0x37f, 0xa
  0x0BEEC: mov      sp, bp
  0x0BEEE: or       ax, ax
  0x0BEF0: je       0xbf39
  0x0BEF2: cmp      word ptr [0x5390], 1  ; season
  0x0BEF7: jne      0xbf26
  0x0BEF9: cmp      word ptr [bp + 0xa], 0
  0x0BEFD: je       0xbf0a
  0x0BEFF: cmp      word ptr [0x929c], 0
  0x0BF04: je       0xbf0a
  0x0BF06: push     cs
  0x0BF07: call     0xbd4a
  0x0BF0A: push     word ptr [bp + 8]
  0x0BF0D: push     word ptr [bp + 6]
  0x0BF10: push     cs
  0x0BF11: call     0xbd28
  0x0BF14: mov      sp, bp
  0x0BF16: cmp      word ptr [bp + 0xa], 0
  0x0BF1A: je       0xbf26
  0x0BF1C: mov      word ptr [0x929c], 0
  0x0BF22: push     cs
  0x0BF23: call     0xbd4a
  0x0BF26: mov      ax, word ptr [bp + 6]
  0x0BF29: mov      word ptr [0x17c], ax
  0x0BF2C: mov      ax, word ptr [bp + 8]
  0x0BF2F: mov      word ptr [0x17e], ax
  0x0BF32: push     1
  0x0BF34: lcall    0x181f, 0xe1c
  0x0BF39: leave    
  0x0BF3A: retf     

============================================================
func_L316 at file 0x0BF3C, 182 bytes
============================================================
  0x0BF3C: enter    0xa, 0
  0x0BF40: mov      word ptr [bp - 2], 0
  0x0BF45: mov      ax, word ptr [bp + 0xa]
  0x0BF48: cmp      ax, word ptr [bp + 6]
  0x0BF4B: jle      0xbf50
  0x0BF4D: mov      ax, word ptr [bp + 6]
  0x0BF50: mov      cx, word ptr [bp + 0xa]
  0x0BF53: cmp      cx, word ptr [bp + 6]
  0x0BF56: jge      0xbf5b
  0x0BF58: mov      cx, word ptr [bp + 6]
  0x0BF5B: mov      word ptr [bp - 8], cx
  0x0BF5E: mov      cx, word ptr [bp + 0xc]
  0x0BF61: cmp      cx, word ptr [bp + 8]
  0x0BF64: jle      0xbf69
  0x0BF66: mov      cx, word ptr [bp + 8]
  0x0BF69: mov      word ptr [bp - 6], cx
  0x0BF6C: mov      cx, word ptr [bp + 0xc]
  0x0BF6F: cmp      cx, word ptr [bp + 8]
  0x0BF72: jge      0xbf77
  0x0BF74: mov      cx, word ptr [bp + 8]
  0x0BF77: mov      word ptr [bp - 0xa], cx
  0x0BF7A: mov      cx, word ptr [0x8328]
  0x0BF7E: inc      cx
  0x0BF7F: inc      cx
  0x0BF80: cmp      ax, cx
  0x0BF82: jge      0xbf90
  0x0BF84: cmp      word ptr [0x8328], 1
  0x0BF89: jle      0xbf90
  0x0BF8B: mov      word ptr [bp - 2], 1
  0x0BF90: mov      ax, word ptr [0x832e]
  0x0BF93: inc      ax
  0x0BF94: inc      ax
  0x0BF95: cmp      ax, word ptr [bp - 6]
  0x0BF98: jle      0xbfa6
  0x0BF9A: cmp      word ptr [0x832e], 1
  0x0BF9F: jle      0xbfa6
  0x0BFA1: mov      word ptr [bp - 2], 1
  0x0BFA6: mov      ax, word ptr [0x8804]
  0x0BFA9: dec      ax
  0x0BFAA: dec      ax
  0x0BFAB: cmp      ax, word ptr [bp - 8]
  0x0BFAE: jge      0xbfc0
  0x0BFB0: mov      ax, word ptr [0x853a]
  0x0BFB3: dec      ax
  0x0BFB4: dec      ax
  0x0BFB5: cmp      ax, word ptr [0x8804]
  0x0BFB9: jle      0xbfc0
  0x0BFBB: mov      word ptr [bp - 2], 1
  0x0BFC0: mov      ax, word ptr [0x8806]
  0x0BFC3: dec      ax
  0x0BFC4: dec      ax
  0x0BFC5: cmp      ax, word ptr [bp - 0xa]
  0x0BFC8: jge      0xbfda
  0x0BFCA: mov      ax, word ptr [0x853c]
  0x0BFCD: dec      ax
  0x0BFCE: dec      ax
  0x0BFCF: cmp      ax, word ptr [0x8806]
  0x0BFD3: jle      0xbfda
  0x0BFD5: mov      word ptr [bp - 2], 1
  0x0BFDA: cmp      word ptr [bp - 2], 0
  0x0BFDE: je       0xbfed
  0x0BFE0: push     word ptr [bp + 0xe]
  0x0BFE3: push     word ptr [bp + 8]
  0x0BFE6: push     word ptr [bp + 6]
  0x0BFE9: push     cs
  0x0BFEA: call     0xbede
  0x0BFED: mov      ax, word ptr [bp - 2]
  0x0BFF0: leave    
  0x0BFF1: retf     

============================================================
func_L317 at file 0x0BFF2, 23 bytes
============================================================
  0x0BFF2: push     bp
  0x0BFF3: mov      bp, sp
  0x0BFF5: push     0
  0x0BFF7: push     word ptr [bp + 8]
  0x0BFFA: push     word ptr [bp + 6]
  0x0BFFD: push     word ptr [bp + 8]
  0x0C000: push     word ptr [bp + 6]
  0x0C003: push     cs
  0x0C004: call     0xbf3c
  0x0C007: leave    
  0x0C008: retf     

============================================================
func_L318 at file 0x0C00A, 112 bytes
============================================================
  0x0C00A: enter    0xa, 0
  0x0C00E: mov      word ptr [bp - 2], 1
  0x0C013: mov      ax, word ptr [0x8540]
  0x0C016: mov      word ptr [bp - 4], ax
  0x0C019: mov      cx, word ptr [0x853e]
  0x0C01D: mov      word ptr [bp - 6], cx
  0x0C020: mov      bx, word ptr [bp + 6]
  0x0C023: mov      al, byte ptr [bx + 0xb4]
  0x0C027: cwde     
  0x0C028: add      ax, word ptr [0x8540]
  0x0C02C: mov      word ptr [bp - 8], ax
  0x0C02F: mov      dx, ax
  0x0C031: mov      al, byte ptr [bx + 0xbe]
  0x0C035: cwde     
  0x0C036: add      cx, ax
  0x0C038: mov      word ptr [bp - 0xa], cx
  0x0C03B: push     cx
  0x0C03C: push     dx
  0x0C03D: lcall    0x37f, 0xa
  0x0C042: add      sp, 4
  0x0C045: or       ax, ax
  0x0C047: jne      0xc04c
  0x0C049: mov      word ptr [bp - 2], ax
  0x0C04C: cmp      word ptr [bp - 2], 0
  0x0C050: je       0xc078
  0x0C052: push     1
  0x0C054: push     word ptr [bp - 6]
  0x0C057: push     word ptr [bp - 4]
  0x0C05A: push     word ptr [bp - 6]
  0x0C05D: push     word ptr [bp - 4]
  0x0C060: push     cs
  0x0C061: call     0xbf3c
  0x0C064: add      sp, 0xa
  0x0C067: push     word ptr [bp - 0xa]
  0x0C06A: push     word ptr [bp - 8]
  0x0C06D: push     cs
  0x0C06E: call     0xbd28
  0x0C071: add      sp, 4
  0x0C074: push     cs
  0x0C075: call     0xbd4a
  0x0C078: leave    
  0x0C079: retf     

============================================================
func_L319 at file 0x0C07A, 32 bytes
============================================================
  0x0C07A: push     bp
  0x0C07B: mov      bp, sp
  0x0C07D: push     word ptr [bp + 0xa]
  0x0C080: push     word ptr [bp + 8]
  0x0C083: push     word ptr [bp + 6]
  0x0C086: lcall    9, 0x244
  0x0C08B: mov      sp, bp
  0x0C08D: push     0
  0x0C08F: push     0
  0x0C091: push     1
  0x0C093: lcall    9, 0x2cc
  0x0C098: leave    
  0x0C099: retf     

============================================================
func_L320 at file 0x0C09A, 19 bytes
============================================================
  0x0C09A: push     bp
  0x0C09B: mov      bp, sp
  0x0C09D: mov      bx, word ptr [bp + 6]
  0x0C0A0: shl      bx, 1
  0x0C0A2: push     word ptr [bx + 0x2dba]
  0x0C0A6: lcall    9, 0x1a2
  0x0C0AB: leave    
  0x0C0AC: retf     

============================================================
func_L321 at file 0x0C0AE, 34 bytes
============================================================
  0x0C0AE: push     bp
  0x0C0AF: mov      bp, sp
  0x0C0B1: push     1
  0x0C0B3: lcall    9, 0xb4
  0x0C0B8: mov      sp, bp
  0x0C0BA: push     word ptr [bp + 6]
  0x0C0BD: push     cs
  0x0C0BE: call     0xc09a
  0x0C0C1: mov      sp, bp
  0x0C0C3: push     0
  0x0C0C5: push     0x78
  0x0C0C7: push     word ptr [bp + 8]
  0x0C0CA: push     cs
  0x0C0CB: call     0xc07a
  0x0C0CE: leave    
  0x0C0CF: retf     

============================================================
func_L322 at file 0x0C0D0, 102 bytes
============================================================
  0x0C0D0: push     bp
  0x0C0D1: mov      bp, sp
  0x0C0D3: cmp      byte ptr [0x4a], 0
  0x0C0D8: je       0xc0e8
  0x0C0DA: push     0
  0x0C0DC: push     0
  0x0C0DE: push     0
  0x0C0E0: lcall    9, 0x2cc
  0x0C0E5: jmp      0xc11b
  0x0C0E7: nop      
  0x0C0E8: push     word ptr [0x2dae]
  0x0C0EC: push     word ptr [0x2dac]
  0x0C0F0: push     word ptr [0x2daa]
  0x0C0F4: push     word ptr [0x2da8]  ; map_terrain
  0x0C0F8: push     7
  0x0C0FA: push     0
  0x0C0FC: mov      ax, 0xffff
  0x0C0FF: cdq      
  0x0C100: mov      bx, 0x140
  0x0C103: lcall    0xbca, 2
  0x0C108: push     0
  0x0C10A: push     0
  0x0C10C: push     0
  0x0C10E: push     word ptr [0x898]
  0x0C112: push     word ptr [0x896]
  0x0C116: lcall    0x181f, 0xe52
  0x0C11B: mov      sp, bp
  0x0C11D: cmp      word ptr [bp + 6], 0
  0x0C121: je       0xc134
  0x0C123: push     0
  0x0C125: push     0x140
  0x0C128: push     7
  0x0C12A: sub      ax, ax
  0x0C12C: cdq      
  0x0C12D: sub      bx, bx
  0x0C12F: lcall    0xb70, 0x3a
  0x0C134: leave    
  0x0C135: retf     

============================================================
func_L323 at file 0x0C17A, 20 bytes
============================================================
  0x0C17A: push     bp
  0x0C17B: mov      bp, sp
  0x0C17D: push     si
  0x0C17E: push     1
  0x0C180: lcall    9, 0xb4
  0x0C185: add      sp, 2
  0x0C188: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x0C18C: mov      ax, bx

============================================================
func_L324 at file 0x0C1F8, 20 bytes
============================================================
  0x0C1F8: push     bp
  0x0C1F9: mov      bp, sp
  0x0C1FB: push     si
  0x0C1FC: push     1
  0x0C1FE: lcall    9, 0xb4
  0x0C203: add      sp, 2
  0x0C206: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x0C20A: mov      ax, bx

============================================================
func_L325 at file 0x0C276, 20 bytes
============================================================
  0x0C276: push     bp
  0x0C277: mov      bp, sp
  0x0C279: push     si
  0x0C27A: push     1
  0x0C27C: lcall    9, 0xb4
  0x0C281: add      sp, 2
  0x0C284: imul     bx, word ptr [bp + 6], 0x1c  ; *Unit
  0x0C288: mov      ax, bx

============================================================
func_L326 at file 0x0C30A, 17 bytes
============================================================
  0x0C30A: push     bp
  0x0C30B: mov      bp, sp
  0x0C30D: mov      ax, word ptr [bp + 6]
  0x0C310: and      ah, 0x7f
  0x0C313: push     ax
  0x0C314: lcall    0xd1d, 0xdf2
  0x0C319: leave    
  0x0C31A: retf     

============================================================
func_L327 at file 0x0C322, 63 bytes
============================================================
  0x0C322: enter    4, 0
  0x0C326: lcall    0xd1d, 0xe04
  0x0C32B: mov      cx, ax
  0x0C32D: mov      ax, word ptr [bp + 8]
  0x0C330: sub      ax, word ptr [bp + 6]
  0x0C333: inc      ax
  0x0C334: imul     cx
  0x0C336: mov      al, ah
  0x0C338: mov      ah, dl
  0x0C33A: mov      dl, dh
  0x0C33C: shl      dh, 1
  0x0C33E: sbb      dh, dh
  0x0C340: sar      dx, 1
  0x0C342: rcr      ax, 1
  0x0C344: sar      dx, 1
  0x0C346: rcr      ax, 1
  0x0C348: sar      dx, 1
  0x0C34A: rcr      ax, 1
  0x0C34C: sar      dx, 1
  0x0C34E: rcr      ax, 1
  0x0C350: sar      dx, 1
  0x0C352: rcr      ax, 1
  0x0C354: sar      dx, 1
  0x0C356: rcr      ax, 1
  0x0C358: sar      dx, 1
  0x0C35A: rcr      ax, 1
  0x0C35C: add      ax, word ptr [bp + 6]
  0x0C35F: leave    
  0x0C360: retf     

============================================================
func_L328 at file 0x0C362, 170 bytes
============================================================
  0x0C362: enter    6, 0
  0x0C366: push     dx
  0x0C367: push     ax
  0x0C368: push     di
  0x0C369: push     si
  0x0C36A: mov      di, 1
  0x0C36D: sub      si, si
  0x0C36F: cmp      dx, si
  0x0C371: jle      0xc396
  0x0C373: or       si, si
  0x0C375: jle      0xc37e
  0x0C377: mov      ax, 0xa
  0x0C37A: imul     di
  0x0C37C: mov      di, ax
  0x0C37E: push     ds
  0x0C37F: push     0x368
  0x0C382: push     word ptr [bp + 8]
  0x0C385: push     word ptr [bp + 6]
  0x0C388: lcall    0xd1d, 0x11b4
  0x0C38D: add      sp, 8
  0x0C390: inc      si
  0x0C391: cmp      si, word ptr [bp - 8]
  0x0C394: jl       0xc373
  0x0C396: mov      word ptr [bp - 6], di
  0x0C399: push     word ptr [bp + 8]
  0x0C39C: push     word ptr [bp + 6]
  0x0C39F: lcall    0xd1d, 0x113c
  0x0C3A4: add      sp, 4
  0x0C3A7: mov      si, ax
  0x0C3A9: sub      si, word ptr [bp - 8]
  0x0C3AC: push     word ptr [bp + 8]
  0x0C3AF: push     word ptr [bp + 6]
  0x0C3B2: lcall    0xd1d, 0x113c
  0x0C3B7: add      sp, 4
  0x0C3BA: cmp      ax, si
  0x0C3BC: jbe      0xc403
  0x0C3BE: mov      word ptr [bp - 4], si
  0x0C3C1: mov      si, word ptr [bp - 6]
  0x0C3C4: mov      di, word ptr [bp - 0xa]
  0x0C3C7: cmp      si, di
  0x0C3C9: jg       0xc3e3
  0x0C3CB: mov      ax, di
  0x0C3CD: cdq      
  0x0C3CE: idiv     si
  0x0C3D0: mov      word ptr [bp - 2], ax
  0x0C3D3: imul     si
  0x0C3D5: sub      di, ax
  0x0C3D7: mov      al, byte ptr [bp - 2]
  0x0C3DA: les      bx, ptr [bp + 6]
  0x0C3DD: add      bx, word ptr [bp - 4]
  0x0C3E0: add      byte ptr es:[bx], al
  0x0C3E3: mov      cx, 0xa
  0x0C3E6: mov      ax, si
  0x0C3E8: cdq      
  0x0C3E9: idiv     cx
  0x0C3EB: mov      si, ax
  0x0C3ED: push     word ptr [bp + 8]
  0x0C3F0: push     word ptr [bp + 6]
  0x0C3F3: lcall    0xd1d, 0x113c
  0x0C3F8: add      sp, 4
  0x0C3FB: inc      word ptr [bp - 4]
  0x0C3FE: cmp      ax, word ptr [bp - 4]
  0x0C401: ja       0xc3c7
  0x0C403: mov      ax, word ptr [bp + 6]
  0x0C406: mov      dx, word ptr [bp + 8]
  0x0C409: pop      si
  0x0C40A: pop      di
  0x0C40B: leave    

============================================================
func_L329 at file 0x0C410, 73 bytes
============================================================
  0x0C410: push     bp
  0x0C411: mov      bp, sp
  0x0C413: push     di
  0x0C414: push     si
  0x0C415: mov      si, word ptr [bp + 0xa]
  0x0C418: mov      es, word ptr [bp + 0xc]
  0x0C41B: cmp      byte ptr es:[si], 0x2a
  0x0C41F: jne      0xc424
  0x0C421: inc      si
  0x0C422: mov      ax, es
  0x0C424: cmp      word ptr [0x36c], 0
  0x0C429: jne      0xc43e
  0x0C42B: mov      di, word ptr [bp + 6]
  0x0C42E: push     es
  0x0C42F: push     si
  0x0C430: push     word ptr [bp + 8]
  0x0C433: push     di
  0x0C434: lcall    0xd1d, 0x117e
  0x0C439: add      sp, 8
  0x0C43C: jmp      0xc450
  0x0C43E: mov      di, word ptr [bp + 6]
  0x0C441: push     word ptr [bp + 8]
  0x0C444: push     di
  0x0C445: push     ds
  0x0C446: push     0x84fe
  0x0C449: push     es
  0x0C44A: push     si
  0x0C44B: lcall    0xb4e, 4
  0x0C450: mov      ax, di
  0x0C452: mov      dx, word ptr [bp + 8]
  0x0C455: pop      si
  0x0C456: pop      di
  0x0C457: leave    
  0x0C458: retf     

============================================================
func_L330 at file 0x0C45A, 41 bytes
============================================================
  0x0C45A: enter    0x50, 0
  0x0C45E: push     bx
  0x0C45F: push     si
  0x0C460: mov      si, bx
  0x0C462: push     word ptr [bp + 8]
  0x0C465: push     word ptr [bp + 6]
  0x0C468: lea      ax, [bp - 0x50]
  0x0C46B: push     ss
  0x0C46C: push     ax
  0x0C46D: push     cs
  0x0C46E: call     0xc410
  0x0C471: add      sp, 8
  0x0C474: push     si
  0x0C475: lea      ax, [bp - 0x50]
  0x0C478: push     ax
  0x0C479: lcall    0xd1d, 0x4da
  0x0C47E: add      sp, 4
  0x0C481: pop      si
  0x0C482: leave    

============================================================
func_L331 at file 0x0C498, 11 bytes
============================================================
  0x0C498: push     bp
  0x0C499: mov      bp, sp
  0x0C49B: push     bx
  0x0C49C: lcall    0xb22, 0x22
  0x0C4A1: leave    
  0x0C4A2: retf     

============================================================
func_L332 at file 0x0C4A4, 118 bytes
============================================================
  0x0C4A4: enter    6, 0
  0x0C4A8: lcall    0xc0c, 6
  0x0C4AD: mov      word ptr [bp - 4], ax
  0x0C4B0: mov      word ptr [bp - 2], dx
  0x0C4B3: mov      word ptr [bp - 6], 0
  0x0C4B8: mov      ax, word ptr [bp - 4]
  0x0C4BB: mov      dx, word ptr [bp - 2]
  0x0C4BE: mov      bx, word ptr [bp - 6]
  0x0C4C1: shl      bx, 2
  0x0C4C4: mov      word ptr [bx - 0x6d3c], ax
  0x0C4C8: mov      word ptr [bx - 0x6d3a], dx
  0x0C4CC: inc      word ptr [bp - 6]
  0x0C4CF: cmp      word ptr [bp - 6], 8
  0x0C4D3: jl       0xc4b8
  0x0C4D5: sub      ax, ax
  0x0C4D7: mov      word ptr [0x92c2], ax
  0x0C4DA: mov      word ptr [bp - 6], ax
  0x0C4DD: jmp      0xc4f6
  0x0C4DF: nop      
  0x0C4E0: mov      bx, ax
  0x0C4E2: shl      bx, 2
  0x0C4E5: mov      al, byte ptr [bx - 0x6d60]
  0x0C4E9: sub      ah, ah
  0x0C4EB: add      word ptr [0x92c2], ax
  0x0C4EF: mov      byte ptr [bx - 0x6d5f], ah
  0x0C4F3: inc      word ptr [bp - 6]
  0x0C4F6: mov      ax, word ptr [bp - 6]
  0x0C4F9: cmp      word ptr [0x929e], ax
  0x0C4FD: jg       0xc4e0
  0x0C4FF: mov      word ptr [0x92c0], 3
  0x0C505: cmp      word ptr [0x92c2], 0x10
  0x0C50A: jg       0xc512
  0x0C50C: mov      word ptr [0x92c0], 0
  0x0C512: mov      ax, word ptr [bp + 6]
  0x0C515: mov      word ptr [0x372], ax
  0x0C518: leave    
  0x0C519: retf     

============================================================
func_L333 at file 0x0C51A, 205 bytes
============================================================
  0x0C51A: enter    0xe, 0
  0x0C51E: push     di
  0x0C51F: push     si
  0x0C520: cmp      word ptr [0x372], 0
  0x0C525: jne      0xc52a
  0x0C527: jmp      0xc642
  0x0C52A: mov      ax, word ptr [0x92c0]
  0x0C52D: inc      word ptr [0x374]
  0x0C531: cmp      word ptr [0x374], ax
  0x0C535: jge      0xc53a
  0x0C537: jmp      0xc642
  0x0C53A: cmp      word ptr [0x808], 0
  0x0C53F: je       0xc544
  0x0C541: jmp      0xc642
  0x0C544: lcall    0xc0c, 6
  0x0C549: mov      word ptr [bp - 0xe], ax
  0x0C54C: mov      word ptr [bp - 0xc], dx
  0x0C54F: sub      ax, ax
  0x0C551: mov      word ptr [bp - 2], ax
  0x0C554: mov      word ptr [bp - 8], ax
  0x0C557: jmp      0xc614
  0x0C55A: mov      bx, ax
  0x0C55C: shl      bx, 2
  0x0C55F: mov      al, byte ptr [bx - 0x6d5d]
  0x0C563: sub      ah, ah
  0x0C565: sub      dx, dx
  0x0C567: add      ax, word ptr [bx - 0x6d3c]
  0x0C56B: adc      dx, word ptr [bx - 0x6d3a]
  0x0C56F: cmp      dx, word ptr [bp - 0xc]
  0x0C572: jle      0xc577
  0x0C574: jmp      0xc611
  0x0C577: jl       0xc581
  0x0C579: cmp      ax, word ptr [bp - 0xe]
  0x0C57C: jbe      0xc581
  0x0C57E: jmp      0xc611
  0x0C581: mov      ax, word ptr [bp - 0xe]
  0x0C584: mov      dx, word ptr [bp - 0xc]
  0x0C587: mov      word ptr [bx - 0x6d3c], ax
  0x0C58B: mov      word ptr [bx - 0x6d3a], dx
  0x0C58F: mov      al, byte ptr [bx - 0x6d60]
  0x0C593: sub      ah, ah
  0x0C595: mov      word ptr [bp - 4], ax
  0x0C598: mov      cl, byte ptr [bx - 0x6d5e]
  0x0C59C: sub      ch, ch
  0x0C59E: mov      word ptr [bp - 6], cx
  0x0C5A1: mov      cl, byte ptr [bx - 0x6d5f]
  0x0C5A5: mov      word ptr [bp - 0xa], cx
  0x0C5A8: mov      word ptr [bp - 2], 1
  0x0C5AD: cmp      ax, 1
  0x0C5B0: jle      0xc604
  0x0C5B2: std      
  0x0C5B3: push     ds
  0x0C5B4: push     ds
  0x0C5B5: pop      es
  0x0C5B6: mov      ax, word ptr [bp - 4]
  0x0C5B9: add      ax, word ptr [bp - 6]
  0x0C5BC: shl      ax, 1
  0x0C5BE: add      ax, word ptr [bp - 4]
  0x0C5C1: add      ax, word ptr [bp - 6]
  0x0C5C4: mov      bx, word ptr [bp - 4]
  0x0C5C7: shl      bx, 1
  0x0C5C9: add      bx, word ptr [bp - 4]
  0x0C5CC: mov      di, 0x2d06
  0x0C5CF: add      di, 2
  0x0C5D2: lds      si, ptr [0x36e]
  0x0C5D6: add      si, ax
  0x0C5D8: sub      si, 1
  0x0C5DB: push     di
  0x0C5DC: push     si
  0x0C5DD: mov      cx, 3
  0x0C5E0: rep movsb byte ptr es:[di], byte ptr [si]
  0x0C5E2: pop      di
  0x0C5E3: push     ds
  0x0C5E4: pop      es
  0x0C5E5: mov      cx, bx

============================================================
func_L334 at file 0x0C646, 74 bytes
============================================================
  0x0C646: enter    0xa, 0
  0x0C64A: mov      word ptr [bp - 0xa], 0xff00
  0x0C64F: mov      word ptr [bp - 8], 0xa000
  0x0C654: mov      word ptr [bp - 6], 0xfd50
  0x0C659: mov      word ptr [bp - 4], 0xa000
  0x0C65E: mov      word ptr [bp - 2], 0x60
  0x0C663: cmp      word ptr [bp + 6], 0
  0x0C667: je       0xc67a
  0x0C669: push     0x60
  0x0C66B: push     0xa000
  0x0C66E: push     0xfd50
  0x0C671: push     0xa000
  0x0C674: push     0xff00
  0x0C677: jmp      0xc689
  0x0C679: nop      
  0x0C67A: push     word ptr [bp - 2]
  0x0C67D: push     word ptr [bp - 8]
  0x0C680: push     word ptr [bp - 0xa]
  0x0C683: push     word ptr [bp - 4]
  0x0C686: push     word ptr [bp - 6]
  0x0C689: lcall    0xd1d, 0xfb2
  0x0C68E: leave    
  0x0C68F: retf     

============================================================
func_L335 at file 0x0C7DF, 12 bytes
============================================================
  0x0C7DF: enter    0, 0
  0x0C7E3: mov      ax, word ptr [bp + 6]
  0x0C7E6: mov      byte ptr [0x383], al
  0x0C7E9: leave    
  0x0C7EA: retf     

============================================================
func_L336 at file 0x0C899, 18 bytes
============================================================
  0x0C899: enter    0, 0
  0x0C89D: mov      ax, word ptr [bp + 6]
  0x0C8A0: mov      word ptr [0x92f6], ax
  0x0C8A3: mov      word ptr [0x92f4], 0
  0x0C8A9: leave    
  0x0C8AA: retf     

============================================================
func_L337 at file 0x0C8AB, 48 bytes
============================================================
  0x0C8AB: enter    0, 0
  0x0C8AF: push     es
  0x0C8B0: push     di
  0x0C8B1: les      di, ptr [bp + 6]
  0x0C8B4: mov      ax, es
  0x0C8B6: pushf    
  0x0C8B7: cli      
  0x0C8B8: mov      word ptr [0x92e4], di
  0x0C8BC: mov      word ptr [0x92e6], ax
  0x0C8BF: or       ax, di
  0x0C8C1: mov      word ptr [0x92f2], 0
  0x0C8C7: mov      word ptr [0x92ee], 0
  0x0C8CD: mov      word ptr [0x92ec], 0
  0x0C8D3: mov      word ptr [0x92f0], ax
  0x0C8D6: popf     
  0x0C8D7: pop      di
  0x0C8D8: pop      es
  0x0C8D9: leave    
  0x0C8DA: retf     

============================================================
func_L338 at file 0x0C8FC, 127 bytes
============================================================
  0x0C8FC: enter    4, 0
  0x0C900: push     dx
  0x0C901: push     ax
  0x0C902: push     bx
  0x0C903: push     di
  0x0C904: push     si
  0x0C905: mov      bx, ax
  0x0C907: cmp      word ptr [bx], 0
  0x0C90A: jge      0xc917
  0x0C90C: mov      cx, word ptr [bx]
  0x0C90E: mov      si, word ptr [bp + 8]
  0x0C911: add      word ptr [si], cx
  0x0C913: mov      word ptr [bx], 0
  0x0C917: mov      bx, word ptr [bp - 6]
  0x0C91A: cmp      word ptr [bx], 0
  0x0C91D: jge      0xc92a
  0x0C91F: mov      ax, word ptr [bx]
  0x0C921: mov      si, word ptr [bp + 6]
  0x0C924: add      word ptr [si], ax
  0x0C926: mov      word ptr [bx], 0
  0x0C92A: mov      bx, word ptr [bp + 8]
  0x0C92D: mov      ax, word ptr [bx]
  0x0C92F: mov      si, word ptr [bp - 8]
  0x0C932: add      ax, word ptr [si]
  0x0C934: dec      ax
  0x0C935: mov      di, word ptr [bp - 0xa]
  0x0C938: mov      cx, word ptr [di + 2]
  0x0C93B: dec      cx
  0x0C93C: cmp      ax, cx
  0x0C93E: jle      0xc942
  0x0C940: mov      ax, cx
  0x0C942: mov      bx, word ptr [bp + 6]
  0x0C945: mov      cx, word ptr [bx]
  0x0C947: mov      bx, word ptr [bp - 6]
  0x0C94A: add      cx, word ptr [bx]
  0x0C94C: dec      cx
  0x0C94D: mov      dx, word ptr [di]
  0x0C94F: dec      dx
  0x0C950: cmp      cx, dx
  0x0C952: jle      0xc956
  0x0C954: mov      cx, dx
  0x0C956: mov      word ptr [bp - 4], cx
  0x0C959: sub      ax, word ptr [si]
  0x0C95B: inc      ax
  0x0C95C: mov      si, word ptr [bp + 8]
  0x0C95F: mov      word ptr [si], ax
  0x0C961: mov      ax, word ptr [bp - 4]
  0x0C964: sub      ax, word ptr [bx]
  0x0C966: inc      ax
  0x0C967: mov      bx, word ptr [bp + 6]
  0x0C96A: mov      word ptr [bx], ax
  0x0C96C: cmp      word ptr [si], 0
  0x0C96F: jle      0xc975
  0x0C971: or       ax, ax
  0x0C973: jg       0xc97e
  0x0C975: mov      ax, 1
  0x0C978: pop      si
  0x0C979: pop      di
  0x0C97A: leave    

============================================================
func_L339 at file 0x0CA0C, 74 bytes
============================================================
  0x0CA0C: enter    2, 0
  0x0CA10: push     bx
  0x0CA11: push     cx
  0x0CA12: push     dx
  0x0CA13: push     es
  0x0CA14: push     0
  0x0CA16: push     word ptr [bp + 8]
  0x0CA19: lcall    0xd11, 0
  0x0CA1E: add      sp, 4
  0x0CA21: mov      ax, 0x10
  0x0CA24: mov      word ptr [0x9300], ax
  0x0CA27: mov      word ptr [0x9302], ax
  0x0CA2A: mov      ax, 0x6d4
  0x0CA2D: mov      word ptr [0x9304], ax
  0x0CA30: mov      ax, 0x1b5a
  0x0CA33: mov      word ptr [0x9306], ax
  0x0CA36: mov      ax, word ptr [bp + 8]
  0x0CA39: mov      word ptr [0x9308], ax
  0x0CA3C: mov      word ptr [0x83ac], 0
  0x0CA42: mov      word ptr [0x92f8], 0
  0x0CA48: mov      word ptr [bp - 2], 0
  0x0CA4D: mov      ax, 0x3533
  0x0CA50: int      0x21
  0x0CA52: mov      ax, es
  0x0CA54: or       ax, bx

============================================================
func_L340 at file 0x0CB59, 25 bytes
============================================================
  0x0CB59: enter    0, 0
  0x0CB5D: mov      ax, word ptr [bp + 6]
  0x0CB60: and      ax, 0xf  ; 6.25% chance
  0x0CB63: mov      bx, word ptr [bp + 8]
  0x0CB66: and      bx, 0xf
  0x0CB69: mov      word ptr [0x590], ax
  0x0CB6C: mov      word ptr [0x592], bx
  0x0CB70: leave    
  0x0CB71: retf     

============================================================
func_L341 at file 0x0CC8F, 92 bytes
============================================================
  0x0CC8F: enter    0, 0
  0x0CC93: mov      ax, cx
  0x0CC95: mov      cx, word ptr [bp + 6]
  0x0CC98: shl      cx, 1
  0x0CC9A: mov      dx, word ptr [bp + 8]
  0x0CC9D: push     ax
  0x0CC9E: push     cx
  0x0CC9F: push     dx
  0x0CCA0: cmp      word ptr [0x92f8], 0
  0x0CCA5: jne      0xccaf
  0x0CCA7: lcall    0xa58, 0x54
  0x0CCAC: jmp      0xccb4
  0x0CCAE: nop      
  0x0CCAF: lcall    0xa58, 0x2ce
  0x0CCB4: pop      dx
  0x0CCB5: pop      cx
  0x0CCB6: pop      ax
  0x0CCB7: mov      word ptr [0x92fc], ax
  0x0CCBA: mov      word ptr [0x92fe], dx
  0x0CCBE: cmp      word ptr [0x83ac], 0
  0x0CCC3: je       0xccd5
  0x0CCC5: push     cx
  0x0CCC6: push     dx
  0x0CCC7: mov      ax, 4
  0x0CCCA: int      0x33
  0x0CCCC: pop      dx
  0x0CCCD: pop      cx
  0x0CCCE: cmp      word ptr [0x92f8], 0
  0x0CCD3: jne      0xccdd
  0x0CCD5: lcall    0xa58, 0xd
  0x0CCDA: jmp      0xcce9
  0x0CCDC: nop      
  0x0CCDD: cli      
  0x0CCDE: lcall    0xa58, 0x207
  0x0CCE3: sti      
  0x0CCE4: lcall    0xa58, 0x2e0
  0x0CCE9: leave    
  0x0CCEA: retf     

============================================================
func_L342 at file 0x0CD0B, 67 bytes
============================================================
  0x0CD0B: enter    0, 0
  0x0CD0F: xor      bx, bx
  0x0CD11: cmp      word ptr [0x92f8], 0
  0x0CD16: je       0xcd24
  0x0CD18: mov      cx, word ptr [0x92fc]
  0x0CD1C: mov      dx, word ptr [0x92fe]
  0x0CD20: xor      bx, bx
  0x0CD22: push     cx
  0x0CD23: push     dx
  0x0CD24: cmp      word ptr [0x83ac], 0
  0x0CD29: je       0xcd33
  0x0CD2B: mov      ax, 3
  0x0CD2E: int      0x33
  0x0CD30: call     0xcceb
  0x0CD33: cmp      word ptr [0x92f8], 0
  0x0CD38: je       0xcd3c
  0x0CD3A: pop      dx
  0x0CD3B: pop      cx
  0x0CD3C: push     bx
  0x0CD3D: mov      bx, word ptr [bp + 6]
  0x0CD40: mov      word ptr [bx], cx
  0x0CD42: mov      bx, word ptr [bp + 8]
  0x0CD45: mov      word ptr [bx], dx
  0x0CD47: pop      ax
  0x0CD48: or       ax, word ptr [0x92fa]
  0x0CD4C: leave    
  0x0CD4D: retf     

============================================================
func_L343 at file 0x0CECF, 25 bytes
============================================================
  0x0CECF: enter    0, 0
  0x0CED3: push     es
  0x0CED4: les      ax, ptr [bp + 6]
  0x0CED7: mov      word ptr [0x5ae], ax
  0x0CEDA: mov      ax, es
  0x0CEDC: mov      word ptr [0x5ac], ax
  0x0CEDF: mov      ax, word ptr [bp + 0xa]
  0x0CEE2: mov      word ptr [0x5b0], ax
  0x0CEE5: pop      es
  0x0CEE6: leave    
  0x0CEE7: retf     

============================================================
func_L344 at file 0x0CEE8, 49 bytes
============================================================
  0x0CEE8: enter    0, 0
  0x0CEEC: push     es
  0x0CEED: push     di
  0x0CEEE: mov      cx, word ptr [bp + 6]
  0x0CEF1: mov      word ptr [0x5b2], cx
  0x0CEF5: mov      dx, word ptr [bp + 8]
  0x0CEF8: mov      word ptr [0x5b6], dx
  0x0CEFC: mov      ax, word ptr [bp + 0xa]
  0x0CEFF: mov      word ptr [0x5b4], ax
  0x0CF02: mov      ax, word ptr [bp + 0xc]
  0x0CF05: mov      word ptr [0x5b8], ax
  0x0CF08: lcall    0xd1c, 0
  0x0CF0D: mov      word ptr [0x5c2], di
  0x0CF11: mov      word ptr [0x5c4], cx
  0x0CF15: pop      di
  0x0CF16: pop      es
  0x0CF17: leave    
  0x0CF18: retf     

============================================================
func_L345 at file 0x0CF19, 25 bytes
============================================================
  0x0CF19: enter    0, 0
  0x0CF1D: mov      bx, word ptr [bp + 6]
  0x0CF20: mov      word ptr [0x5ba], bx
  0x0CF24: mov      ax, word ptr [bp + 8]
  0x0CF27: mov      word ptr [0x5bc], ax
  0x0CF2A: mov      dx, word ptr [0x5b0]
  0x0CF2E: mul      dx
  0x0CF30: add      ax, bx

============================================================
func_L346 at file 0x0CF3E, 134 bytes
============================================================
  0x0CF3E: enter    0x12, 0
  0x0CF42: push     es
  0x0CF43: push     di
  0x0CF44: push     si
  0x0CF45: cmp      word ptr [0x92f8], 0
  0x0CF4A: je       0xcfa6
  0x0CF4C: cmp      byte ptr [0xa899], 0
  0x0CF51: jne      0xcfa6
  0x0CF53: mov      si, 0x10
  0x0CF56: sub      si, word ptr [0x5a4]
  0x0CF5A: mov      di, 0x10
  0x0CF5D: sub      di, word ptr [0x5a6]
  0x0CF61: mov      cx, word ptr [0x594]
  0x0CF65: cmp      cx, word ptr [0x5b4]
  0x0CF69: jg       0xcfa6
  0x0CF6B: mov      dx, cx
  0x0CF6D: add      dx, si
  0x0CF6F: dec      dx
  0x0CF70: cmp      dx, word ptr [0x5b2]
  0x0CF74: jl       0xcfa6
  0x0CF76: mov      ax, word ptr [0x596]
  0x0CF79: cmp      ax, word ptr [0x5b8]
  0x0CF7D: jg       0xcfa6
  0x0CF7F: mov      bx, ax
  0x0CF81: add      bx, di
  0x0CF83: dec      bx
  0x0CF84: cmp      bx, word ptr [0x5b6]
  0x0CF88: jl       0xcfa6
  0x0CF8A: sub      ax, word ptr [0x5b6]
  0x0CF8E: jl       0xcfac
  0x0CF90: mov      word ptr [bp - 0xa], ax
  0x0CF93: mov      word ptr [bp - 2], 0
  0x0CF98: sub      bx, word ptr [0x5b8]
  0x0CF9C: jg       0xcfc0
  0x0CF9E: mov      ax, di
  0x0CFA0: mov      byte ptr [bp - 6], al
  0x0CFA3: jmp      0xcfc7
  0x0CFA5: nop      
  0x0CFA6: mov      ax, 0
  0x0CFA9: jmp      0xd078
  0x0CFAC: mov      bx, ax
  0x0CFAE: neg      ax
  0x0CFB0: mov      word ptr [bp - 2], ax
  0x0CFB3: add      bx, di
  0x0CFB5: mov      byte ptr [bp - 6], bl
  0x0CFB8: mov      word ptr [bp - 0xa], 0
  0x0CFBD: jmp      0xcfc7
  0x0CFBF: nop      
  0x0CFC0: mov      ax, di
  0x0CFC2: sub      ax, bx

============================================================
func_L347 at file 0x0D0B6, 80 bytes
============================================================
  0x0D0B6: push     bp
  0x0D0B7: mov      bp, sp
  0x0D0B9: mov      cx, word ptr [0x7e8]
  0x0D0BD: cmp      ax, cx
  0x0D0BF: jg       0xd0da
  0x0D0C1: cmp      bx, cx
  0x0D0C3: jl       0xd0da
  0x0D0C5: mov      bx, word ptr [0x7ea]
  0x0D0C9: cmp      dx, bx
  0x0D0CB: jg       0xd0da
  0x0D0CD: cmp      word ptr [bp + 6], bx
  0x0D0D0: jl       0xd0da
  0x0D0D2: mov      ax, 1
  0x0D0D5: leave    
  0x0D0D6: retf     2
  0x0D0D9: nop      
  0x0D0DA: sub      ax, ax
  0x0D0DC: leave    
  0x0D0DD: retf     2
  0x0D0E0: mov      ax, 0xffff
  0x0D0E3: mov      word ptr [0x7f8], ax
  0x0D0E6: mov      word ptr [0x7fa], ax
  0x0D0E9: push     0x7ea
  0x0D0EC: push     0x7e8
  0x0D0EF: lcall    0xa58, 0x38b
  0x0D0F4: add      sp, 4
  0x0D0F7: mov      word ptr [0x7e6], ax
  0x0D0FA: mov      word ptr [0x7ee], ax
  0x0D0FD: sub      ax, ax
  0x0D0FF: mov      word ptr [0x7f2], ax
  0x0D102: mov      word ptr [0x7ec], ax
  0x0D105: retf     

============================================================
func_L348 at file 0x0D106, 158 bytes
============================================================
  0x0D106: push     bp
  0x0D107: mov      bp, sp
  0x0D109: mov      ax, word ptr [0x7e8]
  0x0D10C: mov      word ptr [0x7f8], ax
  0x0D10F: mov      ax, word ptr [0x7ea]
  0x0D112: mov      word ptr [0x7fa], ax
  0x0D115: push     0x7ea
  0x0D118: push     0x7e8
  0x0D11B: lcall    0xa58, 0x38b
  0x0D120: mov      sp, bp
  0x0D122: mov      word ptr [0x7e6], ax
  0x0D125: lcall    0xc0c, 6
  0x0D12A: mov      word ptr [0x7fc], ax
  0x0D12D: mov      word ptr [0x7fe], dx
  0x0D131: mov      bx, word ptr [0x7e6]
  0x0D135: cmp      word ptr [0x7f2], 0
  0x0D13A: je       0xd148
  0x0D13C: or       bx, bx
  0x0D13E: jne      0xd148
  0x0D140: mov      word ptr [0x7f4], 1
  0x0D146: jmp      0xd14e
  0x0D148: mov      word ptr [0x7f4], 0
  0x0D14E: or       bx, bx
  0x0D150: je       0xd15e
  0x0D152: cmp      word ptr [0x7ee], 0
  0x0D157: jne      0xd15e
  0x0D159: mov      dx, 1
  0x0D15C: jmp      0xd160
  0x0D15E: sub      dx, dx
  0x0D160: mov      word ptr [0x7ee], bx
  0x0D164: or       bx, bx
  0x0D166: jne      0xd16c
  0x0D168: mov      word ptr [0x7f2], bx
  0x0D16C: mov      ax, word ptr [0x7e8]
  0x0D16F: cmp      word ptr [0x7f8], ax
  0x0D173: jne      0xd18e
  0x0D175: mov      ax, word ptr [0x7ea]
  0x0D178: cmp      word ptr [0x7fa], ax
  0x0D17C: jne      0xd18e
  0x0D17E: or       dx, dx
  0x0D180: jne      0xd18e
  0x0D182: cmp      word ptr [0x7f4], dx
  0x0D186: jne      0xd18e
  0x0D188: mov      word ptr [0x7f0], dx
  0x0D18C: jmp      0xd194
  0x0D18E: mov      word ptr [0x7f0], 1
  0x0D194: mov      word ptr [0x7ec], dx
  0x0D198: or       dx, dx
  0x0D19A: je       0xd1b1
  0x0D19C: mov      word ptr [0x7f2], 1
  0x0D1A2: mov      al, bl

============================================================
func_L349 at file 0x0D1CA, 26 bytes
============================================================
  0x0D1CA: push     bp
  0x0D1CB: mov      bp, sp
  0x0D1CD: or       dx, dx
  0x0D1CF: je       0xd1e2
  0x0D1D1: lcall    0xc0c, 6
  0x0D1D6: cmp      ax, word ptr [0x7fc]
  0x0D1DA: jne      0xd1e2
  0x0D1DC: cmp      dx, word ptr [0x7fe]
  0x0D1E0: je       0xd1d1
  0x0D1E2: leave    
  0x0D1E3: retf     

============================================================
func_L350 at file 0x0D1E4, 54 bytes
============================================================
  0x0D1E4: push     bp
  0x0D1E5: mov      bp, sp
  0x0D1E7: push     di
  0x0D1E8: push     si
  0x0D1E9: mov      word ptr [0x808], 1
  0x0D1EF: mov      bx, word ptr [0x806]
  0x0D1F3: mov      bx, 0x300
  0x0D1F6: mov      di, 0x300
  0x0D1F9: push     ds
  0x0D1FA: lds      si, ptr [bp + 6]
  0x0D1FD: mov      dx, 0x3c8
  0x0D200: xor      al, al
  0x0D202: out      dx, al
  0x0D203: inc      dx
  0x0D204: push     dx
  0x0D205: mov      dx, 0x3da
  0x0D208: mov      ah, 8
  0x0D20A: in       al, dx
  0x0D20B: and      al, ah
  0x0D20D: jne      0xd20a
  0x0D20F: in       al, dx
  0x0D210: and      al, ah
  0x0D212: je       0xd20f
  0x0D214: cli      
  0x0D215: pop      dx
  0x0D216: mov      cx, di
  0x0D218: cmp      cx, bx

============================================================
func_L351 at file 0x0D272, 13 bytes
============================================================
  0x0D272: push     bp
  0x0D273: mov      bp, sp
  0x0D275: mov      ah, 1
  0x0D277: int      0x16
  0x0D279: jne      0xd280
  0x0D27B: xor      ax, ax
  0x0D27D: leave    
  0x0D27E: retf     

============================================================
func_L352 at file 0x0D286, 15 bytes
============================================================
  0x0D286: push     bp
  0x0D287: mov      bp, sp
  0x0D289: mov      ah, 0
  0x0D28B: int      0x16
  0x0D28D: or       al, al
  0x0D28F: je       0xd296
  0x0D291: xor      ah, ah
  0x0D293: leave    
  0x0D294: retf     

============================================================
func_L353 at file 0x0D2AC, 243 bytes
============================================================
  0x0D2AC: push     bp
  0x0D2AD: mov      bp, sp
  0x0D2AF: push     ax
  0x0D2B0: mov      dx, ax
  0x0D2B2: sub      ax, 0x110
  0x0D2B5: cmp      ax, 0x22
  0x0D2B8: ja       0xd308
  0x0D2BA: shl      ax, 1
  0x0D2BC: xchg     bx, ax
  0x0D2BD: jmp      word ptr cs:[bx + 0x22]
  0x0D2C2: add      byte ptr [bx + si], 0x86
  0x0D2C5: add      byte ptr [si - 0x6e00], cl
  0x0D2C9: add      byte ptr [bp + si - 0x6000], bl
  0x0D2CD: add      byte ptr [bp - 0x5400], ah
  0x0D2D1: add      byte ptr [bp + si - 0x4800], dh
  0x0D2D5: add      byte ptr [bx + si], ch
  0x0D2D8: push     0x6800
  0x0D2DB: add      byte ptr [bx + si], ch
  0x0D2DE: mov      si, 0xc400
  0x0D2E1: add      dl, cl
  0x0D2E3: add      al, dl
  0x0D2E5: add      dh, dl
  0x0D2E7: add      ah, bl
  0x0D2E9: add      dl, ah
  0x0D2EB: add      al, ch
  0x0D2ED: add      dh, ch
  0x0D2EF: add      byte ptr [bx + si], ch
  0x0D2F2: push     0x6800
  0x0D2F5: add      byte ptr [bx + si], ch
  0x0D2F8: push     0xf400
  0x0D2FB: add      dl, bh
  0x0D2FD: add      byte ptr [bx + si], al
  0x0D2FF: add      word ptr [0xc01], ax
  0x0D303: add      word ptr [bp + si], dx
  0x0D305: add      word ptr [bx + si], bx
  0x0D307: add      word ptr [bp + di + 0x61fa], ax
  0x0D30B: jl       0xd31a
  0x0D30D: cmp      dx, 0x7a
  0x0D310: jg       0xd31a
  0x0D312: mov      ax, dx
  0x0D314: sub      ax, 0x20
  0x0D317: jmp      0xd3bb
  0x0D31A: mov      ax, dx
  0x0D31C: jmp      0xd3bb
  0x0D31F: nop      
  0x0D320: mov      ax, 0x51
  0x0D323: jmp      0xd3bb
  0x0D326: mov      ax, 0x57
  0x0D329: jmp      0xd3bb
  0x0D32C: mov      ax, 0x45
  0x0D32F: jmp      0xd3bb
  0x0D332: mov      ax, 0x52
  0x0D335: jmp      0xd3bb
  0x0D338: nop      
  0x0D339: nop      
  0x0D33A: mov      ax, 0x54
  0x0D33D: jmp      0xd3bb
  0x0D33F: nop      
  0x0D340: mov      ax, 0x59
  0x0D343: jmp      0xd3bb
  0x0D345: nop      
  0x0D346: mov      ax, 0x55
  0x0D349: jmp      0xd3bb
  0x0D34B: nop      
  0x0D34C: mov      ax, 0x49
  0x0D34F: jmp      0xd3bb
  0x0D351: nop      
  0x0D352: mov      ax, 0x4f
  0x0D355: jmp      0xd3bb
  0x0D357: nop      
  0x0D358: mov      ax, 0x50
  0x0D35B: jmp      0xd3bb
  0x0D35D: nop      
  0x0D35E: mov      ax, 0x41
  0x0D361: jmp      0xd3bb
  0x0D363: nop      
  0x0D364: mov      ax, 0x53
  0x0D367: jmp      0xd3bb
  0x0D369: nop      
  0x0D36A: mov      ax, 0x44
  0x0D36D: jmp      0xd3bb
  0x0D36F: nop      
  0x0D370: mov      ax, 0x46
  0x0D373: jmp      0xd3bb
  0x0D375: nop      
  0x0D376: mov      ax, 0x47
  0x0D379: jmp      0xd3bb
  0x0D37B: nop      
  0x0D37C: mov      ax, 0x48
  0x0D37F: jmp      0xd3bb
  0x0D381: nop      
  0x0D382: mov      ax, 0x4a
  0x0D385: jmp      0xd3bb
  0x0D387: nop      
  0x0D388: mov      ax, 0x4b
  0x0D38B: jmp      0xd3bb
  0x0D38D: nop      
  0x0D38E: mov      ax, 0x4c
  0x0D391: jmp      0xd3bb
  0x0D393: nop      
  0x0D394: mov      ax, 0x5a
  0x0D397: jmp      0xd3bb
  0x0D399: nop      
  0x0D39A: mov      ax, 0x58
  0x0D39D: leave    
  0x0D39E: retf     

============================================================
func_L354 at file 0x0D3BE, 42 bytes
============================================================
  0x0D3BE: enter    4, 0
  0x0D3C2: push     si
  0x0D3C3: push     0xa
  0x0D3C5: push     word ptr [bp + 8]
  0x0D3C8: push     word ptr [bp + 6]
  0x0D3CB: lcall    0xd1d, 0x10ea
  0x0D3D0: add      sp, 6
  0x0D3D3: mov      si, ax
  0x0D3D5: mov      word ptr [bp - 2], dx
  0x0D3D8: or       dx, ax
  0x0D3DA: je       0xd3e3
  0x0D3DC: mov      es, word ptr [bp - 2]
  0x0D3DF: mov      byte ptr es:[si], 0
  0x0D3E3: mov      dx, word ptr [bp - 2]
  0x0D3E6: pop      si
  0x0D3E7: leave    

============================================================
func_L355 at file 0x0D3EC, 46 bytes
============================================================
  0x0D3EC: enter    8, 0
  0x0D3F0: push     di
  0x0D3F1: mov      di, word ptr [bp + 6]
  0x0D3F4: mov      ax, word ptr [bp + 8]
  0x0D3F7: push     ax
  0x0D3F8: push     di
  0x0D3F9: mov      word ptr [bp - 8], di
  0x0D3FC: mov      word ptr [bp - 6], ax
  0x0D3FF: lcall    0xd1d, 0x113c
  0x0D404: add      sp, 4
  0x0D407: mov      bx, ax
  0x0D409: add      bx, word ptr [bp - 8]
  0x0D40C: mov      es, word ptr [bp - 6]
  0x0D40F: mov      byte ptr es:[bx], 0xa
  0x0D413: inc      bx
  0x0D414: mov      byte ptr es:[bx], 0
  0x0D418: pop      di
  0x0D419: leave    

============================================================
func_L356 at file 0x0D41E, 138 bytes
============================================================
  0x0D41E: enter    0x10e, 0
  0x0D422: push     bx
  0x0D423: push     dx
  0x0D424: push     ax
  0x0D425: push     di
  0x0D426: push     si
  0x0D427: mov      di, bx
  0x0D429: sub      ax, ax
  0x0D42B: mov      word ptr [bp - 0xa], ax
  0x0D42E: mov      word ptr [bp - 0xc], ax
  0x0D431: mov      word ptr [bp - 6], ax
  0x0D434: mov      word ptr [bp - 8], ax
  0x0D437: mov      ax, dx
  0x0D439: or       ax, word ptr [bp - 0x114]
  0x0D43D: jne      0xd442
  0x0D43F: jmp      0xd61f
  0x0D442: cmp      word ptr [bp + 6], 1
  0x0D446: jne      0xd454
  0x0D448: cmp      word ptr [bp + 8], 0
  0x0D44C: jne      0xd454
  0x0D44E: mov      ax, word ptr [bp - 0x114]
  0x0D452: jmp      0xd464
  0x0D454: push     dx
  0x0D455: push     word ptr [bp - 0x114]
  0x0D459: push     word ptr [bp + 8]
  0x0D45C: push     word ptr [bp + 6]
  0x0D45F: lcall    0xd1d, 0xf60
  0x0D464: mov      word ptr [bp - 4], ax
  0x0D467: mov      word ptr [bp - 2], dx
  0x0D46A: cmp      word ptr [0x2624], 0
  0x0D46F: je       0xd474
  0x0D471: jmp      0xd572
  0x0D474: cmp      word ptr [di + 2], 0
  0x0D478: jle      0xd4c7
  0x0D47A: mov      ax, word ptr [di + 2]
  0x0D47D: cdq      
  0x0D47E: cmp      dx, word ptr [bp - 2]
  0x0D481: jl       0xd48d
  0x0D483: jg       0xd48a
  0x0D485: cmp      ax, word ptr [bp - 4]
  0x0D488: jbe      0xd48d
  0x0D48A: mov      ax, word ptr [bp - 4]
  0x0D48D: mov      si, ax
  0x0D48F: push     si
  0x0D490: push     ds
  0x0D491: push     word ptr [di]
  0x0D493: push     word ptr [bp + 0xc]
  0x0D496: push     word ptr [bp + 0xa]
  0x0D499: lcall    0xd1d, 0xfb2
  0x0D49E: add      sp, 0xa
  0x0D4A1: add      word ptr [di], si
  0x0D4A3: sub      word ptr [di + 2], si
  0x0D4A6: sub      cx, cx

============================================================
func_L357 at file 0x0D642, 129 bytes
============================================================
  0x0D642: enter    0xa4, 0
  0x0D646: mov      ax, ds
  0x0D648: mov      es, ax
  0x0D64A: push     si
  0x0D64B: push     di
  0x0D64C: mov      si, word ptr [bp + 6]
  0x0D64F: lea      di, [bp - 0x53]
  0x0D652: mov      cx, 0x4f
  0x0D655: lodsb    al, byte ptr [si]
  0x0D656: stosb    byte ptr es:[di], al
  0x0D657: or       al, al
  0x0D659: loopne   0xd655
  0x0D65B: pop      di
  0x0D65C: pop      si
  0x0D65D: lea      bx, [bp - 0x53]
  0x0D660: lea      cx, [bp - 0xa4]
  0x0D664: push     ds
  0x0D665: push     bx
  0x0D666: push     ds
  0x0D667: push     cx
  0x0D668: lcall    0x9f6, 0xb0
  0x0D66D: add      sp, 8
  0x0D670: mov      ax, 0x3524
  0x0D673: int      0x21
  0x0D675: mov      ax, es
  0x0D677: mov      word ptr cs:[6], bx
  0x0D67C: mov      word ptr cs:[8], ax
  0x0D680: push     ds
  0x0D681: push     cs
  0x0D682: pop      ds
  0x0D683: mov      dx, 0xc
  0x0D686: mov      ax, 0x2524
  0x0D689: int      0x21
  0x0D68B: pop      ds
  0x0D68C: lea      bx, [bp - 0xa4]
  0x0D690: mov      dx, bx
  0x0D692: mov      ax, 0x3d00
  0x0D695: int      0x21
  0x0D697: jb       0xd6a7
  0x0D699: mov      bx, ax
  0x0D69B: mov      ah, 0x3e
  0x0D69D: int      0x21
  0x0D69F: mov      word ptr [bp - 2], 0xffff
  0x0D6A4: jmp      0xd6ac
  0x0D6A6: nop      
  0x0D6A7: mov      word ptr [bp - 2], 0
  0x0D6AC: push     ds
  0x0D6AD: mov      dx, word ptr cs:[6]
  0x0D6B2: mov      ax, word ptr cs:[8]
  0x0D6B6: mov      ds, ax
  0x0D6B8: mov      ax, 0x2524
  0x0D6BB: int      0x21
  0x0D6BD: pop      ds
  0x0D6BE: mov      ax, word ptr [bp - 2]
  0x0D6C1: leave    
  0x0D6C2: retf     

============================================================
func_L358 at file 0x0D6C4, 41 bytes
============================================================
  0x0D6C4: enter    6, 0
  0x0D6C8: push     bx
  0x0D6C9: push     di
  0x0D6CA: push     si
  0x0D6CB: mov      word ptr [bp - 2], bx
  0x0D6CE: sub      si, si
  0x0D6D0: mov      di, ax
  0x0D6D2: cmp      si, 0x4f
  0x0D6D5: jge      0xd6ef
  0x0D6D7: push     di
  0x0D6D8: lcall    0xd1d, 0x786
  0x0D6DD: add      sp, 2
  0x0D6E0: mov      cx, ax
  0x0D6E2: mov      bx, word ptr [bp - 2]
  0x0D6E5: inc      word ptr [bp - 2]
  0x0D6E8: mov      byte ptr [bx], al
  0x0D6EA: inc      si
  0x0D6EB: or       cx, cx

============================================================
func_L359 at file 0x0D700, 46 bytes
============================================================
  0x0D700: enter    6, 0
  0x0D704: push     di
  0x0D705: push     si
  0x0D706: mov      si, bx
  0x0D708: mov      di, ax
  0x0D70A: push     di
  0x0D70B: lodsb    al, byte ptr [si]
  0x0D70C: cwde     
  0x0D70D: push     ax
  0x0D70E: mov      word ptr [bp - 6], ax
  0x0D711: lcall    0xd1d, 0x758
  0x0D716: add      sp, 4
  0x0D719: cmp      word ptr [bp - 6], 0
  0x0D71D: jne      0xd70a
  0x0D71F: push     di
  0x0D720: push     0x1a
  0x0D722: lcall    0xd1d, 0x758
  0x0D727: add      sp, 4
  0x0D72A: pop      si
  0x0D72B: pop      di
  0x0D72C: leave    
  0x0D72D: retf     

============================================================
func_L360 at file 0x0D72E, 801 bytes
============================================================
  0x0D72E: push     bp
  0x0D72F: mov      bp, sp
  0x0D731: push     si
  0x0D732: mov      si, word ptr [bp + 0xa]
  0x0D735: push     0x2e
  0x0D737: push     word ptr [bp + 0xc]
  0x0D73A: push     si
  0x0D73B: lcall    0xd1d, 0x10ea
  0x0D740: add      sp, 6
  0x0D743: or       dx, ax
  0x0D745: jne      0xd769
  0x0D747: push     ds
  0x0D748: push     0x2626
  0x0D74B: push     word ptr [bp + 0xc]
  0x0D74E: push     si
  0x0D74F: lcall    0xd1d, 0x11b4
  0x0D754: add      sp, 8
  0x0D757: push     word ptr [bp + 8]
  0x0D75A: push     word ptr [bp + 6]
  0x0D75D: push     word ptr [bp + 0xc]
  0x0D760: push     si
  0x0D761: lcall    0xd1d, 0x11b4
  0x0D766: add      sp, 8
  0x0D769: mov      ax, word ptr [bp + 0xc]
  0x0D76C: push     ax
  0x0D76D: push     si
  0x0D76E: lcall    0xd1d, 0x1118
  0x0D773: add      sp, 4
  0x0D776: pop      si
  0x0D777: leave    
  0x0D778: retf     8
  0x0D77B: nop      
  0x0D77C: enter    4, 0
  0x0D780: push     di
  0x0D781: push     si
  0x0D782: mov      cx, word ptr [bp + 0xa]
  0x0D785: mov      si, word ptr [bp + 0xe]
  0x0D788: mov      ax, word ptr [bp + 0xc]
  0x0D78B: mov      dx, word ptr [bp + 0x10]
  0x0D78E: cmp      cx, si
  0x0D790: jne      0xd796
  0x0D792: cmp      ax, dx
  0x0D794: je       0xd7a2
  0x0D796: push     ax
  0x0D797: push     cx
  0x0D798: push     dx
  0x0D799: push     si
  0x0D79A: lcall    0xd1d, 0x117e
  0x0D79F: add      sp, 8
  0x0D7A2: push     0x2e
  0x0D7A4: push     word ptr [bp + 0x10]
  0x0D7A7: push     si
  0x0D7A8: lcall    0xd1d, 0x10ea
  0x0D7AD: add      sp, 6
  0x0D7B0: mov      di, ax
  0x0D7B2: mov      word ptr [bp - 2], dx
  0x0D7B5: or       dx, ax
  0x0D7B7: je       0xd7c0
  0x0D7B9: mov      es, word ptr [bp - 2]
  0x0D7BC: mov      byte ptr es:[di], 0
  0x0D7C0: push     ds
  0x0D7C1: push     0x2628
  0x0D7C4: mov      ax, word ptr [bp + 0x10]
  0x0D7C7: push     ax
  0x0D7C8: push     si
  0x0D7C9: mov      di, ax
  0x0D7CB: lcall    0xd1d, 0x11b4
  0x0D7D0: add      sp, 8
  0x0D7D3: push     word ptr [bp + 8]
  0x0D7D6: push     word ptr [bp + 6]
  0x0D7D9: push     di
  0x0D7DA: push     si
  0x0D7DB: lcall    0xd1d, 0x11b4
  0x0D7E0: add      sp, 8
  0x0D7E3: push     di
  0x0D7E4: push     si
  0x0D7E5: lcall    0xd1d, 0x1118
  0x0D7EA: add      sp, 4
  0x0D7ED: pop      si
  0x0D7EE: pop      di
  0x0D7EF: leave    
  0x0D7F0: retf     0xc
  0x0D7F3: nop      
  0x0D7F4: enter    0x54, 0
  0x0D7F8: push     si
  0x0D7F9: push     word ptr [bp + 8]
  0x0D7FC: push     word ptr [bp + 6]
  0x0D7FF: lea      ax, [bp - 0x54]
  0x0D802: push     ss
  0x0D803: push     ax
  0x0D804: lcall    0xd1d, 0x117e
  0x0D809: add      sp, 8
  0x0D80C: push     0x5c
  0x0D80E: lea      ax, [bp - 0x54]
  0x0D811: push     ss
  0x0D812: push     ax
  0x0D813: lcall    0xd1d, 0x10ea
  0x0D818: add      sp, 6
  0x0D81B: mov      si, ax
  0x0D81D: mov      word ptr [bp - 2], dx
  0x0D820: or       dx, ax
  0x0D822: je       0xd82a
  0x0D824: inc      si
  0x0D825: mov      ax, word ptr [bp - 2]
  0x0D828: jmp      0xd832
  0x0D82A: lea      ax, [bp - 0x54]
  0x0D82D: mov      si, ax
  0x0D82F: mov      word ptr [bp - 2], ss
  0x0D832: push     word ptr [bp - 2]
  0x0D835: push     si
  0x0D836: push     word ptr [bp + 0xc]
  0x0D839: push     word ptr [bp + 0xa]
  0x0D83C: lcall    0xd1d, 0x117e
  0x0D841: add      sp, 8
  0x0D844: push     word ptr [bp + 0xc]
  0x0D847: push     word ptr [bp + 0xa]
  0x0D84A: lcall    0xd1d, 0x1118
  0x0D84F: add      sp, 4
  0x0D852: mov      ax, word ptr [bp + 0xa]
  0x0D855: mov      dx, word ptr [bp + 0xc]
  0x0D858: pop      si
  0x0D859: leave    
  0x0D85A: retf     8
  0x0D85D: nop      
  0x0D85E: enter    0x54, 0
  0x0D862: push     di
  0x0D863: push     word ptr [bp + 8]
  0x0D866: push     word ptr [bp + 6]
  0x0D869: lea      ax, [bp - 0x54]
  0x0D86C: push     ss
  0x0D86D: push     ax
  0x0D86E: lcall    0xd1d, 0x117e
  0x0D873: add      sp, 8
  0x0D876: push     0x5c
  0x0D878: lea      ax, [bp - 0x54]
  0x0D87B: push     ss
  0x0D87C: push     ax
  0x0D87D: lcall    0xd1d, 0x10ea
  0x0D882: add      sp, 6
  0x0D885: mov      di, ax
  0x0D887: mov      word ptr [bp - 2], dx
  0x0D88A: or       dx, ax
  0x0D88C: je       0xd8b8
  0x0D88E: mov      es, word ptr [bp - 2]
  0x0D891: cmp      byte ptr es:[di + 1], 0
  0x0D896: je       0xd89c
  0x0D898: mov      byte ptr es:[di], 0
  0x0D89C: lea      ax, [bp - 0x54]
  0x0D89F: push     ss
  0x0D8A0: push     ax
  0x0D8A1: push     word ptr [bp + 0xc]
  0x0D8A4: push     word ptr [bp + 0xa]
  0x0D8A7: lcall    0xd1d, 0x117e
  0x0D8AC: add      sp, 8
  0x0D8AF: mov      es, word ptr [bp - 2]
  0x0D8B2: mov      byte ptr es:[di], 0x5c
  0x0D8B6: jmp      0xd8cb
  0x0D8B8: lea      ax, [bp - 0x54]
  0x0D8BB: push     ss
  0x0D8BC: push     ax
  0x0D8BD: push     word ptr [bp + 0xc]
  0x0D8C0: push     word ptr [bp + 0xa]
  0x0D8C3: lcall    0xd1d, 0x117e
  0x0D8C8: add      sp, 8
  0x0D8CB: push     word ptr [bp + 0xc]
  0x0D8CE: push     word ptr [bp + 0xa]
  0x0D8D1: lcall    0xd1d, 0x1118
  0x0D8D6: add      sp, 4
  0x0D8D9: mov      ax, word ptr [bp + 0xa]
  0x0D8DC: mov      dx, word ptr [bp + 0xc]
  0x0D8DF: pop      di
  0x0D8E0: leave    
  0x0D8E1: retf     8
  0x0D8E4: enter    0x54, 0
  0x0D8E8: push     si
  0x0D8E9: push     word ptr [bp + 0xc]
  0x0D8EC: push     word ptr [bp + 0xa]
  0x0D8EF: lea      ax, [bp - 0x54]
  0x0D8F2: push     ss
  0x0D8F3: push     ax
  0x0D8F4: lcall    0xd1d, 0x117e
  0x0D8F9: add      sp, 8
  0x0D8FC: lea      ax, [bp - 0x54]
  0x0D8FF: mov      si, ax
  0x0D901: mov      word ptr [bp - 2], ss
  0x0D904: mov      bx, ax
  0x0D906: cmp      byte ptr ss:[bx], 0
  0x0D90A: je       0xd916
  0x0D90C: mov      es, word ptr [bp - 2]
  0x0D90F: inc      si
  0x0D910: cmp      byte ptr es:[si], 0
  0x0D914: jne      0xd90f
  0x0D916: mov      es, word ptr [bp - 2]
  0x0D919: lea      bx, [si - 1]
  0x0D91C: cmp      byte ptr es:[bx], 0x5c
  0x0D920: je       0xd931
  0x0D922: push     0x262a
  0x0D925: lea      ax, [bp - 0x54]
  0x0D928: push     ax
  0x0D929: lcall    0xd1d, 0x7a4
  0x0D92E: add      sp, 4
  0x0D931: lea      ax, [bp - 0x54]
  0x0D934: push     ss
  0x0D935: push     ax
  0x0D936: push     word ptr [bp + 0x10]
  0x0D939: push     word ptr [bp + 0xe]
  0x0D93C: lcall    0xd1d, 0x117e
  0x0D941: add      sp, 8
  0x0D944: push     word ptr [bp + 8]
  0x0D947: push     word ptr [bp + 6]
  0x0D94A: push     word ptr [bp + 0x10]
  0x0D94D: push     word ptr [bp + 0xe]
  0x0D950: lcall    0xd1d, 0x11b4
  0x0D955: add      sp, 8
  0x0D958: push     word ptr [bp + 0x10]
  0x0D95B: push     word ptr [bp + 0xe]
  0x0D95E: lcall    0xd1d, 0x1118
  0x0D963: add      sp, 4
  0x0D966: mov      ax, word ptr [bp + 0xe]
  0x0D969: mov      dx, word ptr [bp + 0x10]
  0x0D96C: pop      si
  0x0D96D: leave    
  0x0D96E: retf     0xc
  0x0D971: nop      
  0x0D972: enter    0x104, 0
  0x0D976: push     di
  0x0D977: push     si
  0x0D978: mov      di, word ptr [bp + 6]
  0x0D97B: push     word ptr [bp + 8]
  0x0D97E: push     di
  0x0D97F: lcall    0x1094, 0xa
  0x0D984: mov      ax, word ptr [bp + 8]
  0x0D987: mov      cx, di
  0x0D989: mov      si, cx
  0x0D98B: mov      word ptr [bp - 2], ax
  0x0D98E: mov      es, ax
  0x0D990: mov      bx, di
  0x0D992: cmp      byte ptr es:[bx], 0
  0x0D996: je       0xd9b4
  0x0D998: mov      ds, ax
  0x0D99A: cmp      byte ptr [si], 0x20
  0x0D99D: je       0xd9ac
  0x0D99F: cmp      byte ptr [si], 9
  0x0D9A2: je       0xd9ac
  0x0D9A4: mov      ax, 0x1b5a
  0x0D9A7: mov      ds, ax
  0x0D9A9: jmp      0xd9b4
  0x0D9AB: nop      
  0x0D9AC: inc      si
  0x0D9AD: cmp      byte ptr [si], 0
  0x0D9B0: jne      0xd99a
  0x0D9B2: jmp      0xd9a4
  0x0D9B4: push     word ptr [bp - 2]
  0x0D9B7: push     si
  0x0D9B8: lea      ax, [bp - 0x104]
  0x0D9BC: push     ss
  0x0D9BD: push     ax
  0x0D9BE: lcall    0xd1d, 0x117e
  0x0D9C3: add      sp, 8
  0x0D9C6: lea      ax, [bp - 0x104]
  0x0D9CA: push     ss
  0x0D9CB: push     ax
  0x0D9CC: mov      ax, word ptr [bp + 8]
  0x0D9CF: push     ax
  0x0D9D0: push     di
  0x0D9D1: lcall    0xd1d, 0x117e
  0x0D9D6: add      sp, 8
  0x0D9D9: pop      si
  0x0D9DA: pop      di
  0x0D9DB: leave    
  0x0D9DC: retf     4
  0x0D9DF: nop      
  0x0D9E0: enter    0x132, 0
  0x0D9E4: push     ax
  0x0D9E5: push     di
  0x0D9E6: push     si
  0x0D9E7: mov      ax, 0x11
  0x0D9EA: mov      word ptr [bp - 0x10], ax
  0x0D9ED: mov      word ptr [bp - 0xe], ax
  0x0D9F0: sub      ax, ax
  0x0D9F2: mov      cx, 4
  0x0D9F5: lea      di, [bp - 0xc]
  0x0D9F8: push     ss
  0x0D9F9: pop      es
  0x0D9FA: rep stosb byte ptr es:[di], al
  0x0D9FC: lea      ax, [bp - 0x132]
  0x0DA00: mov      word ptr [bp - 0xc], ax
  0x0DA03: mov      word ptr [bp - 0xa], ss
  0x0DA06: push     ss
  0x0DA07: push     ax
  0x0DA08: push     word ptr [bp - 0xe]
  0x0DA0B: push     word ptr [bp - 0x10]
  0x0DA0E: mov      al, 0xff
  0x0DA10: lcall    0xb8d, 4
  0x0DA15: push     word ptr [bp + 8]
  0x0DA18: push     word ptr [bp + 6]
  0x0DA1B: push     0
  0x0DA1D: sub      dx, dx
  0x0DA1F: mov      word ptr [bp - 6], dx
  0x0DA22: mov      word ptr [bp - 8], dx
  0x0DA25: mov      ax, word ptr [bp - 0x134]
  0x0DA29: lea      bx, [bp - 0x10]
  0x0DA2C: lcall    0xc36, 0xa
  0x0DA31: mov      word ptr [bp - 2], 0
  0x0DA36: lea      ax, [bp - 0x122]
  0x0DA3A: mov      word ptr [bp - 4], ax
  0x0DA3D: mov      bx, word ptr [bp - 2]
  0x0DA40: mov      di, ax
  0x0DA42: mov      cx, word ptr [bp - 8]
  0x0DA45: mov      dx, word ptr [bp - 6]
  0x0DA48: cmp      byte ptr [di], 0xff
  0x0DA4B: je       0xda4f
  0x0DA4D: mov      cx, bx

============================================================
func_L361 at file 0x0DB3A, 385 bytes
============================================================
  0x0DB3A: push     bp
  0x0DB3B: mov      bp, sp
  0x0DB3D: push     bx
  0x0DB3E: push     ax
  0x0DB3F: push     di
  0x0DB40: push     si
  0x0DB41: mov      di, dx
  0x0DB43: lcall    0xa58, 0x2ce
  0x0DB48: lcall    0xa58, 0x5be
  0x0DB4D: mov      si, ax
  0x0DB4F: push     word ptr [bp + 6]
  0x0DB52: push     word ptr [bp + 8]
  0x0DB55: push     word ptr [bp + 0xa]
  0x0DB58: push     word ptr [bp - 2]
  0x0DB5B: push     di
  0x0DB5C: push     word ptr [bp - 4]
  0x0DB5F: push     ds
  0x0DB60: push     0x2da8  ; map_terrain
  0x0DB63: lcall    0xd11, 0x1c
  0x0DB68: add      sp, 0x10
  0x0DB6B: or       si, si
  0x0DB6D: je       0xdb74
  0x0DB6F: lcall    0xa58, 0x6fd
  0x0DB74: lcall    0xa58, 0x2e0
  0x0DB79: pop      si
  0x0DB7A: pop      di
  0x0DB7B: leave    
  0x0DB7C: retf     6
  0x0DB7F: nop      
  0x0DB80: enter    0x10e, 0
  0x0DB84: push     dx
  0x0DB85: push     ax
  0x0DB86: push     di
  0x0DB87: push     si
  0x0DB88: mov      ax, 0x10
  0x0DB8B: mov      word ptr [bp - 0xe], ax
  0x0DB8E: mov      word ptr [bp - 0xc], ax
  0x0DB91: sub      ax, ax
  0x0DB93: mov      cx, 4
  0x0DB96: lea      di, [bp - 0xa]
  0x0DB99: push     ss
  0x0DB9A: pop      es
  0x0DB9B: rep stosb byte ptr es:[di], al
  0x0DB9D: mov      word ptr [bp - 4], 0
  0x0DBA2: lea      ax, [bp - 0x10e]
  0x0DBA6: mov      word ptr [bp - 0xa], ax
  0x0DBA9: mov      word ptr [bp - 8], ss
  0x0DBAC: push     ss
  0x0DBAD: push     ax
  0x0DBAE: push     word ptr [bp - 0xc]
  0x0DBB1: push     word ptr [bp - 0xe]
  0x0DBB4: mov      al, 0xff
  0x0DBB6: lcall    0xb8d, 4
  0x0DBBB: mov      si, word ptr [bp + 6]
  0x0DBBE: cmp      word ptr [bp - 0x110], 0
  0x0DBC3: je       0xdbe0
  0x0DBC5: push     word ptr [bp + 8]
  0x0DBC8: push     si
  0x0DBC9: push     0
  0x0DBCB: push     0
  0x0DBCD: mov      ax, word ptr [bp - 0x112]
  0x0DBD1: lea      bx, [bp - 0xe]
  0x0DBD4: sub      dx, dx
  0x0DBD6: lcall    0xcd8, 4
  0x0DBDB: mov      word ptr [bp - 4], 2
  0x0DBE0: mov      ax, word ptr [bp + 8]
  0x0DBE3: push     ax
  0x0DBE4: push     si
  0x0DBE5: push     0
  0x0DBE7: mov      di, ax
  0x0DBE9: mov      ax, word ptr [bp - 0x112]
  0x0DBED: lea      bx, [bp - 0xe]
  0x0DBF0: mov      dx, word ptr [bp - 4]
  0x0DBF3: lcall    0xc36, 0xa
  0x0DBF8: mov      ax, word ptr [bp - 0x112]
  0x0DBFC: mov      cx, ax
  0x0DBFE: shl      ax, 1
  0x0DC00: add      ax, cx
  0x0DC02: shl      ax, 2
  0x0DC05: mov      es, di
  0x0DC07: add      si, ax
  0x0DC09: mov      ax, word ptr es:[si + 0x3e]
  0x0DC0D: sar      ax, 1
  0x0DC0F: mov      word ptr [bp - 6], ax
  0x0DC12: mov      cx, word ptr es:[si + 0x40]
  0x0DC16: sar      cx, 1
  0x0DC18: mov      word ptr [bp - 2], cx
  0x0DC1B: cmp      ax, word ptr [0x262c]
  0x0DC1F: jne      0xdc62
  0x0DC21: mov      ax, cx
  0x0DC23: cmp      word ptr [0x262e], ax
  0x0DC27: jne      0xdc62
  0x0DC29: lcall    0xa58, 0x3ce
  0x0DC2E: push     word ptr [bp - 8]
  0x0DC31: push     word ptr [bp - 0xa]
  0x0DC34: push     word ptr [bp - 0xc]
  0x0DC37: push     word ptr [bp - 0xe]
  0x0DC3A: push     word ptr [0x9306]
  0x0DC3E: push     word ptr [0x9304]
  0x0DC42: push     word ptr [0x9302]
  0x0DC46: push     word ptr [0x9300]
  0x0DC4A: push     0x10
  0x0DC4C: sub      ax, ax
  0x0DC4E: cdq      
  0x0DC4F: mov      bx, 0x10
  0x0DC52: lcall    0xb8f, 6
  0x0DC57: lcall    0xa58, 0x3e2
  0x0DC5C: pop      si
  0x0DC5D: pop      di
  0x0DC5E: leave    
  0x0DC5F: retf     4
  0x0DC62: mov      ax, word ptr [bp - 6]
  0x0DC65: mov      word ptr [0x262c], ax
  0x0DC68: mov      word ptr [0x262e], cx
  0x0DC6C: lcall    0xa58, 0x54
  0x0DC71: push     word ptr [bp - 2]
  0x0DC74: push     word ptr [bp - 6]
  0x0DC77: lcall    0xa58, 0x1d9
  0x0DC7C: add      sp, 4
  0x0DC7F: push     word ptr [bp - 8]
  0x0DC82: push     word ptr [bp - 0xa]
  0x0DC85: push     word ptr [bp - 0xc]
  0x0DC88: push     word ptr [bp - 0xe]
  0x0DC8B: push     word ptr [0x9306]
  0x0DC8F: push     word ptr [0x9304]
  0x0DC93: push     word ptr [0x9302]
  0x0DC97: push     word ptr [0x9300]
  0x0DC9B: push     0x10
  0x0DC9D: sub      ax, ax
  0x0DC9F: cdq      
  0x0DCA0: mov      bx, 0x10
  0x0DCA3: lcall    0xb8f, 6
  0x0DCA8: lcall    0xa58, 0xd
  0x0DCAD: pop      si
  0x0DCAE: pop      di
  0x0DCAF: leave    
  0x0DCB0: retf     4
  0x0DCB3: nop      
  0x0DCB4: mov      cx, ax
  0x0DCB6: mov      bx, 0x40
  0x0DCB9: mov      es, bx

============================================================
func_L362 at file 0x0DCD4, 45 bytes
============================================================
  0x0DCD4: push     bp
  0x0DCD5: mov      bp, sp
  0x0DCD7: push     word ptr [bp + 0xc]
  0x0DCDA: push     word ptr [bp + 0xa]
  0x0DCDD: push     word ptr [bp + 8]
  0x0DCE0: push     word ptr [bp + 6]
  0x0DCE3: push     word ptr [bp + 6]
  0x0DCE6: push     ax
  0x0DCE7: sub      ax, ax
  0x0DCE9: cdq      
  0x0DCEA: mov      bx, word ptr [bp + 8]
  0x0DCED: lcall    0xb9e, 0xa
  0x0DCF2: leave    
  0x0DCF3: retf     8
  0x0DCF6: enter    0xe, 0
  0x0DCFA: push     bx
  0x0DCFB: push     dx
  0x0DCFC: push     ax
  0x0DCFD: push     di
  0x0DCFE: push     si
  0x0DCFF: mov      ax, bx

============================================================
func_L363 at file 0x0DDEA, 185 bytes
============================================================
  0x0DDEA: enter    8, 0
  0x0DDEE: push     bx
  0x0DDEF: push     dx
  0x0DDF0: push     ax
  0x0DDF1: push     di
  0x0DDF2: push     si
  0x0DDF3: lea      ax, [bp - 0xa]
  0x0DDF6: push     ax
  0x0DDF7: lea      ax, [bp + 8]
  0x0DDFA: push     ax
  0x0DDFB: lea      bx, [bp + 0xa]
  0x0DDFE: lea      ax, [bp - 0xe]
  0x0DE01: lea      dx, [bp - 0xc]
  0x0DE04: lcall    0xa4e, 0x1c
  0x0DE09: or       ax, ax
  0x0DE0B: je       0xde10
  0x0DE0D: jmp      0xde9d
  0x0DE10: mov      ax, word ptr [bp + 0xc]
  0x0DE13: sub      ax, word ptr [bp - 0xa]
  0x0DE16: mov      word ptr [bp - 2], ax
  0x0DE19: mov      ax, word ptr [bp + 0x10]
  0x0DE1C: or       ax, word ptr [bp + 0xe]
  0x0DE1F: je       0xde26
  0x0DE21: mov      ax, 1
  0x0DE24: jmp      0xde28
  0x0DE26: sub      ax, ax
  0x0DE28: mov      word ptr [bp - 8], ax
  0x0DE2B: or       ax, ax
  0x0DE2D: je       0xde9d
  0x0DE2F: lea      bx, [bp + 0xa]
  0x0DE32: mov      ax, word ptr [bp - 0xe]
  0x0DE35: mov      dx, word ptr [bp - 0xc]
  0x0DE38: lcall    0xa4e, 8
  0x0DE3D: push     dx
  0x0DE3E: push     ax
  0x0DE3F: lcall    0xc05, 4
  0x0DE44: mov      word ptr [bp - 6], ax
  0x0DE47: mov      word ptr [bp - 4], dx
  0x0DE4A: les      di, ptr [bp - 6]
  0x0DE4D: mov      al, byte ptr [bp + 6]
  0x0DE50: mov      si, word ptr [bp + 8]
  0x0DE53: or       si, si
  0x0DE55: jne      0xde5a
  0x0DE57: jmp      0xde9d
  0x0DE59: nop      
  0x0DE5A: mov      dx, word ptr [bp - 0xa]
  0x0DE5D: mov      bx, word ptr [bp - 2]
  0x0DE60: mov      ah, al
  0x0DE62: shr      dx, 1
  0x0DE64: jae      0xde84
  0x0DE66: or       dx, dx
  0x0DE68: je       0xde6e
  0x0DE6A: mov      cx, dx
  0x0DE6C: rep stosw word ptr es:[di], ax
  0x0DE6E: stosb    byte ptr es:[di], al
  0x0DE6F: add      di, bx
  0x0DE71: jns      0xde7f
  0x0DE73: sub      di, 0x8000
  0x0DE77: mov      cx, es
  0x0DE79: add      cx, 0x800
  0x0DE7D: mov      es, cx
  0x0DE7F: dec      si
  0x0DE80: jne      0xde66
  0x0DE82: jmp      0xde9d
  0x0DE84: je       0xde9d
  0x0DE86: mov      cx, dx
  0x0DE88: rep stosw word ptr es:[di], ax
  0x0DE8A: add      di, bx
  0x0DE8C: jns      0xde9a
  0x0DE8E: sub      di, 0x8000
  0x0DE92: mov      cx, es
  0x0DE94: add      cx, 0x800
  0x0DE98: mov      es, cx
  0x0DE9A: dec      si
  0x0DE9B: jne      0xde86
  0x0DE9D: mov      ax, word ptr [bp - 8]
  0x0DEA0: pop      si
  0x0DEA1: pop      di
  0x0DEA2: leave    

============================================================
func_L364 at file 0x0DEA6, 241 bytes
============================================================
  0x0DEA6: enter    0xe, 0
  0x0DEAA: push     bx
  0x0DEAB: push     dx
  0x0DEAC: push     ax
  0x0DEAD: push     di
  0x0DEAE: push     si
  0x0DEAF: mov      ax, word ptr [bp + 0x16]
  0x0DEB2: sub      ax, word ptr [bp + 8]
  0x0DEB5: mov      word ptr [bp - 0xa], ax
  0x0DEB8: mov      ax, word ptr [bp + 0xe]
  0x0DEBB: sub      ax, word ptr [bp + 8]
  0x0DEBE: mov      word ptr [bp - 0xe], ax
  0x0DEC1: mov      ax, word ptr [bp + 0x1a]
  0x0DEC4: or       ax, word ptr [bp + 0x18]
  0x0DEC7: je       0xded8
  0x0DEC9: mov      ax, word ptr [bp + 0x12]
  0x0DECC: or       ax, word ptr [bp + 0x10]
  0x0DECF: je       0xded8
  0x0DED1: mov      word ptr [bp - 0xc], 1
  0x0DED6: jmp      0xdedd
  0x0DED8: mov      word ptr [bp - 0xc], 0
  0x0DEDD: cmp      word ptr [bp - 0xc], 0
  0x0DEE1: jne      0xdee6
  0x0DEE3: jmp      0xdf91
  0x0DEE6: lea      bx, [bp + 0x14]
  0x0DEE9: mov      ax, word ptr [bp - 0x14]
  0x0DEEC: mov      dx, word ptr [bp - 0x12]
  0x0DEEF: lcall    0xa4e, 8
  0x0DEF4: push     dx
  0x0DEF5: push     ax
  0x0DEF6: lcall    0xc05, 4
  0x0DEFB: mov      word ptr [bp - 4], ax
  0x0DEFE: mov      word ptr [bp - 2], dx
  0x0DF01: lea      bx, [bp + 0xc]
  0x0DF04: mov      ax, word ptr [bp - 0x10]
  0x0DF07: mov      dx, word ptr [bp + 0xa]
  0x0DF0A: lcall    0xa4e, 8
  0x0DF0F: push     dx
  0x0DF10: push     ax
  0x0DF11: lcall    0xc05, 4
  0x0DF16: mov      word ptr [bp - 8], ax
  0x0DF19: mov      word ptr [bp - 6], dx
  0x0DF1C: push     ds
  0x0DF1D: les      di, ptr [bp - 8]
  0x0DF20: lds      si, ptr [bp - 4]
  0x0DF23: mov      ax, word ptr [bp + 6]
  0x0DF26: or       ax, ax
  0x0DF28: jne      0xdf2c
  0x0DF2A: jmp      0xdf90
  0x0DF2C: mov      dx, word ptr [bp + 8]
  0x0DF2F: mov      bx, word ptr [bp - 0xa]
  0x0DF32: shr      dx, 1
  0x0DF34: jae      0xdf66
  0x0DF36: or       dx, dx
  0x0DF38: je       0xdf3e
  0x0DF3A: mov      cx, dx
  0x0DF3C: rep movsw word ptr es:[di], word ptr [si]
  0x0DF3E: movsb    byte ptr es:[di], byte ptr [si]
  0x0DF3F: add      si, bx
  0x0DF41: jns      0xdf4f
  0x0DF43: sub      si, 0x8000
  0x0DF47: mov      cx, ds
  0x0DF49: add      cx, 0x800
  0x0DF4D: mov      ds, cx
  0x0DF4F: add      di, word ptr [bp - 0xe]
  0x0DF52: jns      0xdf60
  0x0DF54: sub      di, 0x8000
  0x0DF58: mov      cx, es
  0x0DF5A: add      cx, 0x800
  0x0DF5E: mov      es, cx
  0x0DF60: dec      ax
  0x0DF61: jne      0xdf36
  0x0DF63: jmp      0xdf90
  0x0DF65: nop      
  0x0DF66: je       0xdf90
  0x0DF68: mov      cx, dx
  0x0DF6A: rep movsw word ptr es:[di], word ptr [si]
  0x0DF6C: add      si, bx
  0x0DF6E: jns      0xdf7c
  0x0DF70: sub      si, 0x8000
  0x0DF74: mov      cx, ds
  0x0DF76: add      cx, 0x800
  0x0DF7A: mov      ds, cx
  0x0DF7C: add      di, word ptr [bp - 0xe]
  0x0DF7F: jns      0xdf8d
  0x0DF81: sub      di, 0x8000
  0x0DF85: mov      cx, es
  0x0DF87: add      cx, 0x800
  0x0DF8B: mov      es, cx
  0x0DF8D: dec      ax
  0x0DF8E: jne      0xdf68
  0x0DF90: pop      ds
  0x0DF91: mov      ax, word ptr [bp - 0xc]
  0x0DF94: pop      si
  0x0DF95: pop      di
  0x0DF96: leave    

============================================================
func_L365 at file 0x0DF9A, 28 bytes
============================================================
  0x0DF9A: push     bp
  0x0DF9B: mov      bp, sp
  0x0DF9D: push     di
  0x0DF9E: mov      di, bx
  0x0DFA0: lea      bx, [bp + 6]
  0x0DFA3: lcall    0xa4e, 8
  0x0DFA8: mov      es, dx
  0x0DFAA: mov      bx, ax
  0x0DFAC: mov      ax, di
  0x0DFAE: mov      byte ptr es:[bx], al
  0x0DFB1: pop      di
  0x0DFB2: leave    
  0x0DFB3: retf     8

============================================================
func_L366 at file 0x0DFB6, 165 bytes
============================================================
  0x0DFB6: push     bp
  0x0DFB7: mov      bp, sp
  0x0DFB9: lea      bx, [bp + 6]
  0x0DFBC: lcall    0xa4e, 8
  0x0DFC1: mov      es, dx
  0x0DFC3: mov      bx, ax
  0x0DFC5: mov      al, byte ptr es:[bx]
  0x0DFC8: leave    
  0x0DFC9: retf     8
  0x0DFCC: enter    6, 0
  0x0DFD0: push     bx
  0x0DFD1: push     dx
  0x0DFD2: push     ax
  0x0DFD3: push     di
  0x0DFD4: or       bx, bx
  0x0DFD6: jl       0xe031
  0x0DFD8: mov      ax, word ptr [bp + 8]
  0x0DFDB: cmp      bx, ax
  0x0DFDD: jge      0xe031
  0x0DFDF: mov      ax, word ptr [bp - 0xc]
  0x0DFE2: or       ax, ax
  0x0DFE4: jge      0xdfe8
  0x0DFE6: sub      ax, ax
  0x0DFE8: mov      word ptr [bp - 0xc], ax
  0x0DFEB: mov      ax, word ptr [bp + 0xa]
  0x0DFEE: dec      ax
  0x0DFEF: cmp      ax, dx
  0x0DFF1: jle      0xdff5
  0x0DFF3: mov      ax, dx
  0x0DFF5: mov      word ptr [bp - 0xa], ax
  0x0DFF8: mov      ax, word ptr [bp + 0xe]
  0x0DFFB: mov      word ptr [bp - 6], ax
  0x0DFFE: mov      ax, word ptr [bp + 0xc]
  0x0E001: mov      word ptr [bp - 4], ax
  0x0E004: mov      ax, word ptr [bp + 0xa]
  0x0E007: mov      word ptr [bp - 2], ax
  0x0E00A: push     es
  0x0E00B: mov      ax, word ptr [bp - 6]
  0x0E00E: mov      es, ax
  0x0E010: mov      ax, word ptr [bp - 2]
  0x0E013: mov      bx, word ptr [bp - 8]
  0x0E016: mul      bx
  0x0E018: add      ax, word ptr [bp - 0xc]
  0x0E01B: mov      di, ax
  0x0E01D: add      di, word ptr [bp - 4]
  0x0E020: mov      cx, word ptr [bp - 0xa]
  0x0E023: sub      cx, word ptr [bp - 0xc]
  0x0E026: inc      cx
  0x0E027: mov      al, byte ptr [bp + 6]
  0x0E02A: mov      byte ptr es:[di], al
  0x0E02D: inc      di
  0x0E02E: loopne   0xe02a
  0x0E030: pop      es
  0x0E031: pop      di
  0x0E032: leave    
  0x0E033: retf     0xa
  0x0E036: enter    6, 0
  0x0E03A: push     bx
  0x0E03B: push     dx
  0x0E03C: push     ax
  0x0E03D: push     di
  0x0E03E: or       ax, ax
  0x0E040: jl       0xe09c
  0x0E042: mov      ax, word ptr [bp + 0xa]
  0x0E045: cmp      word ptr [bp - 0xc], ax
  0x0E048: jge      0xe09c
  0x0E04A: mov      ax, dx
  0x0E04C: or       ax, ax
  0x0E04E: jge      0xe052
  0x0E050: sub      ax, ax
  0x0E052: mov      word ptr [bp - 0xa], ax
  0x0E055: mov      ax, word ptr [bp + 8]
  0x0E058: dec      ax
  0x0E059: cmp      ax, bx

============================================================
func_L367 at file 0x0E0A2, 14 bytes
============================================================
  0x0E0A2: push     bp
  0x0E0A3: mov      bp, sp
  0x0E0A5: push     bx
  0x0E0A6: push     dx
  0x0E0A7: push     ax
  0x0E0A8: cmp      bx, ax
  0x0E0AA: jge      0xe0b6
  0x0E0AC: mov      dx, ax
  0x0E0AE: mov      ax, bx

============================================================
func_L368 at file 0x0E146, 136 bytes
============================================================
  0x0E146: enter    0xc, 0
  0x0E14A: push     bx
  0x0E14B: push     dx
  0x0E14C: push     ax
  0x0E14D: push     di
  0x0E14E: push     si
  0x0E14F: sub      bx, word ptr [bp + 0xe]
  0x0E152: neg      bx
  0x0E154: mov      word ptr [bp - 2], bx
  0x0E157: mov      word ptr [bp - 0xa], ax
  0x0E15A: mov      word ptr [bp - 0xc], dx
  0x0E15D: mov      cx, word ptr [bp + 0x12]
  0x0E160: or       cx, word ptr [bp + 0x10]
  0x0E163: je       0xe16a
  0x0E165: mov      ax, 1
  0x0E168: jmp      0xe16c
  0x0E16A: sub      ax, ax
  0x0E16C: mov      word ptr [bp - 8], ax
  0x0E16F: or       ax, ax
  0x0E171: je       0xe1c8
  0x0E173: lea      bx, [bp + 0xc]
  0x0E176: mov      ax, word ptr [bp - 0xa]
  0x0E179: mov      dx, word ptr [bp - 0xc]
  0x0E17C: lcall    0xa4e, 8
  0x0E181: push     dx
  0x0E182: push     ax
  0x0E183: lcall    0xc05, 4
  0x0E188: mov      word ptr [bp - 6], ax
  0x0E18B: mov      word ptr [bp - 4], dx
  0x0E18E: les      di, ptr [bp - 6]
  0x0E191: mov      ah, byte ptr [bp + 8]
  0x0E194: mov      al, byte ptr [bp + 6]
  0x0E197: mov      si, word ptr [bp + 0xa]
  0x0E19A: or       si, si
  0x0E19C: jne      0xe1a0
  0x0E19E: jmp      0xe1c8
  0x0E1A0: mov      dx, word ptr [bp - 0xe]
  0x0E1A3: mov      cx, dx
  0x0E1A5: mov      bl, byte ptr es:[di]
  0x0E1A8: cmp      bl, ah
  0x0E1AA: jne      0xe1af
  0x0E1AC: mov      byte ptr es:[di], al
  0x0E1AF: inc      di
  0x0E1B0: loop     0xe1a5
  0x0E1B2: add      di, word ptr [bp - 2]
  0x0E1B5: jns      0xe1c3
  0x0E1B7: sub      di, 0x8000
  0x0E1BB: mov      cx, es
  0x0E1BD: add      cx, 0x800
  0x0E1C1: mov      es, cx
  0x0E1C3: dec      si
  0x0E1C4: jne      0xe1a3
  0x0E1C6: jmp      0xe1c8
  0x0E1C8: mov      ax, word ptr [bp - 8]
  0x0E1CB: pop      si
  0x0E1CC: pop      di
  0x0E1CD: leave    

============================================================
func_L369 at file 0x0E1D2, 218 bytes
============================================================
  0x0E1D2: enter    0x2c, 0
  0x0E1D6: push     dx
  0x0E1D7: push     ax
  0x0E1D8: push     bx
  0x0E1D9: push     di
  0x0E1DA: push     si
  0x0E1DB: mov      word ptr [bp - 4], 0xffff
  0x0E1E0: mov      word ptr [bp - 2], 0
  0x0E1E5: sub      si, si
  0x0E1E7: mov      di, si
  0x0E1E9: mov      al, byte ptr [0x263c]
  0x0E1EC: sub      ah, ah
  0x0E1EE: inc      ax
  0x0E1EF: mov      cx, 0xa
  0x0E1F2: cdq      
  0x0E1F3: idiv     cx
  0x0E1F5: mov      byte ptr [0x263c], dl
  0x0E1F9: push     0x2634
  0x0E1FC: lea      ax, [bp - 0x2c]
  0x0E1FF: push     ax
  0x0E200: lcall    0xd1d, 0x7e4
  0x0E205: add      sp, 4
  0x0E208: lea      ax, [bp - 0x2c]
  0x0E20B: push     ss
  0x0E20C: push     ax
  0x0E20D: mov      al, byte ptr [0x263c]
  0x0E210: sub      ah, ah
  0x0E212: mov      dx, 1
  0x0E215: lcall    0x9f6, 2
  0x0E21A: mov      bl, byte ptr [0x263c]
  0x0E21E: sub      bh, bh
  0x0E220: cmp      byte ptr [bx + 0x263e], bh
  0x0E224: jne      0xe22c
  0x0E226: mov      si, 0xffff
  0x0E229: jmp      0xe238
  0x0E22B: nop      
  0x0E22C: inc      di
  0x0E22D: cmp      di, 0xa
  0x0E230: jle      0xe238
  0x0E232: mov      di, word ptr [bp - 2]
  0x0E235: jmp      0xe299
  0x0E237: nop      
  0x0E238: or       si, si
  0x0E23A: je       0xe1e9
  0x0E23C: mov      bl, byte ptr [0x263c]
  0x0E240: sub      bh, bh
  0x0E242: mov      byte ptr [bx + 0x263e], 0xff
  0x0E247: push     0x2630
  0x0E24A: lea      ax, [bp - 0x2c]
  0x0E24D: push     ax
  0x0E24E: lcall    0xd1d, 0x4da
  0x0E253: add      sp, 4
  0x0E256: mov      di, ax
  0x0E258: or       di, di
  0x0E25A: je       0xe299
  0x0E25C: sub      si, si
  0x0E25E: cmp      word ptr [bp + 6], si
  0x0E261: jle      0xe291
  0x0E263: mov      word ptr [bp - 2], di
  0x0E266: mov      dx, word ptr [bp - 0x2e]
  0x0E269: add      dx, si
  0x0E26B: mov      bx, word ptr [bp - 0x32]
  0x0E26E: mov      ax, word ptr [bp - 0x30]
  0x0E271: lcall    0xa4e, 8
  0x0E276: push     dx
  0x0E277: push     ax
  0x0E278: push     0
  0x0E27A: push     1
  0x0E27C: mov      ax, word ptr [bp + 8]
  0x0E27F: cdq      
  0x0E280: mov      bx, di
  0x0E282: lcall    0x1a1f, 0xc9c
  0x0E287: or       dx, ax
  0x0E289: je       0xe299
  0x0E28B: inc      si
  0x0E28C: cmp      word ptr [bp + 6], si
  0x0E28F: jg       0xe266
  0x0E291: mov      al, byte ptr [0x263c]
  0x0E294: sub      ah, ah
  0x0E296: mov      word ptr [bp - 4], ax
  0x0E299: or       di, di
  0x0E29B: je       0xe2a6
  0x0E29D: push     di
  0x0E29E: lcall    0xd1d, 0x3f4
  0x0E2A3: add      sp, 2
  0x0E2A6: mov      ax, word ptr [bp - 4]
  0x0E2A9: pop      si
  0x0E2AA: pop      di
  0x0E2AB: leave    

============================================================
func_L370 at file 0x0E2B0, 156 bytes
============================================================
  0x0E2B0: enter    0x2a, 0
  0x0E2B4: push     dx
  0x0E2B5: push     ax
  0x0E2B6: push     bx
  0x0E2B7: push     di
  0x0E2B8: push     si
  0x0E2B9: push     0x2634
  0x0E2BC: lea      ax, [bp - 0x2a]
  0x0E2BF: push     ax
  0x0E2C0: lcall    0xd1d, 0x7e4
  0x0E2C5: add      sp, 4
  0x0E2C8: lea      ax, [bp - 0x2a]
  0x0E2CB: push     ss
  0x0E2CC: push     ax
  0x0E2CD: mov      ax, word ptr [bp - 0x2e]
  0x0E2D0: mov      dx, 1
  0x0E2D3: lcall    0x9f6, 2
  0x0E2D8: push     0x2648
  0x0E2DB: lea      ax, [bp - 0x2a]
  0x0E2DE: push     ax
  0x0E2DF: lcall    0xd1d, 0x4da
  0x0E2E4: add      sp, 4
  0x0E2E7: mov      di, ax
  0x0E2E9: or       di, di
  0x0E2EB: je       0xe322
  0x0E2ED: sub      si, si
  0x0E2EF: cmp      word ptr [bp + 6], si
  0x0E2F2: jle      0xe322
  0x0E2F4: mov      word ptr [bp - 2], di
  0x0E2F7: mov      dx, word ptr [bp + 0xa]
  0x0E2FA: add      dx, si
  0x0E2FC: mov      bx, word ptr [bp - 0x30]
  0x0E2FF: mov      ax, word ptr [bp + 0xc]
  0x0E302: lcall    0xa4e, 8
  0x0E307: push     dx
  0x0E308: push     ax
  0x0E309: push     0
  0x0E30B: push     1
  0x0E30D: mov      ax, word ptr [bp + 8]
  0x0E310: cdq      
  0x0E311: mov      bx, di
  0x0E313: lcall    0xb01, 0xe
  0x0E318: or       dx, ax
  0x0E31A: je       0xe322
  0x0E31C: inc      si
  0x0E31D: cmp      word ptr [bp + 6], si
  0x0E320: jg       0xe2f7
  0x0E322: or       di, di
  0x0E324: je       0xe349
  0x0E326: push     di
  0x0E327: lcall    0xd1d, 0x3f4
  0x0E32C: add      sp, 2
  0x0E32F: cmp      word ptr [bp - 0x2c], 0
  0x0E333: jne      0xe349
  0x0E335: mov      bx, word ptr [bp - 0x2e]
  0x0E338: mov      byte ptr [bx + 0x263e], 0
  0x0E33D: lea      ax, [bp - 0x2a]
  0x0E340: push     ax
  0x0E341: lcall    0xd1d, 0xe4a
  0x0E346: add      sp, 2
  0x0E349: pop      si
  0x0E34A: pop      di
  0x0E34B: leave    

============================================================
func_L371 at file 0x0E350, 66 bytes
============================================================
  0x0E350: enter    0x16, 0
  0x0E354: push     si
  0x0E355: mov      ax, word ptr [bp + 0xe]
  0x0E358: mov      word ptr [bp - 0xe], ax
  0x0E35B: mov      ax, word ptr [bp + 0x10]
  0x0E35E: mov      word ptr [bp - 0x10], ax
  0x0E361: or       ax, ax
  0x0E363: jne      0xe368
  0x0E365: jmp      0xe450
  0x0E368: cmp      word ptr [bp - 0xe], 0
  0x0E36C: jne      0xe371
  0x0E36E: jmp      0xe450
  0x0E371: mov      dx, word ptr [bp + 0x1e]
  0x0E374: mov      ax, word ptr [bp + 0x16]
  0x0E377: sub      ax, dx
  0x0E379: or       ax, ax
  0x0E37B: jg       0xe380
  0x0E37D: not      ax
  0x0E37F: inc      ax
  0x0E380: mov      word ptr [bp - 2], ax
  0x0E383: cdq      
  0x0E384: idiv     word ptr [bp - 0x10]
  0x0E387: mov      word ptr [bp - 0x12], dx
  0x0E38A: mov      bx, word ptr [bp + 0x18]
  0x0E38D: mov      si, word ptr [bp + 0x20]
  0x0E390: mov      ax, bx

============================================================
func_L372 at file 0x0E454, 72 bytes
============================================================
  0x0E454: push     bp
  0x0E455: mov      bp, sp
  0x0E457: mov      ax, word ptr [bp + 6]
  0x0E45A: mov      dx, word ptr [bp + 8]
  0x0E45D: mov      bx, ax
  0x0E45F: shr      bx, 4
  0x0E462: add      dx, bx
  0x0E464: and      ax, 0xf  ; 6.25% chance
  0x0E467: leave    
  0x0E468: retf     4
  0x0E46B: nop      
  0x0E46C: enter    2, 0
  0x0E470: push     si
  0x0E471: mov      si, bx
  0x0E473: cmp      byte ptr [si], 0x30
  0x0E476: jne      0xe4ba
  0x0E478: mov      bl, byte ptr [si + 1]
  0x0E47B: mov      byte ptr [bp - 1], bl
  0x0E47E: sub      bh, bh
  0x0E480: test     byte ptr [bx + 0x27ed], 2
  0x0E485: je       0xe48b
  0x0E487: sub      byte ptr [bp - 1], 0x20
  0x0E48B: cmp      byte ptr [bp - 1], 0x58
  0x0E48F: jne      0xe49c
  0x0E491: lea      bx, [si + 2]
  0x0E494: lcall    0x109a, 0xa
  0x0E499: pop      si
  0x0E49A: leave    
  0x0E49B: retf     

============================================================
func_L373 at file 0x0E508, 20 bytes
============================================================
  0x0E508: push     bp
  0x0E509: mov      bp, sp
  0x0E50B: cli      
  0x0E50C: mov      al, 0x36
  0x0E50E: out      0x43, al
  0x0E510: mov      ax, word ptr [bp + 6]
  0x0E513: out      0x40, al
  0x0E515: mov      al, ah
  0x0E517: out      0x40, al
  0x0E519: sti      
  0x0E51A: leave    
  0x0E51B: retf     

============================================================
func_L374 at file 0x0E51C, 112 bytes
============================================================
  0x0E51C: enter    0x66, 0
  0x0E520: push     dx
  0x0E521: push     ax
  0x0E522: push     bx
  0x0E523: push     di
  0x0E524: push     si
  0x0E525: sub      ax, ax
  0x0E527: mov      word ptr [bp - 0x5c], ax
  0x0E52A: mov      word ptr [bp - 0x5e], ax
  0x0E52D: mov      word ptr [bp - 0x64], ax
  0x0E530: mov      cx, dx
  0x0E532: mov      ax, word ptr [0x269e]
  0x0E535: mov      dx, word ptr [0x26a0]
  0x0E539: mov      word ptr [bp - 6], ax
  0x0E53C: mov      word ptr [bp - 4], dx
  0x0E53F: push     word ptr [bp + 0xa]
  0x0E542: push     word ptr [bp + 8]
  0x0E545: lea      ax, [bp - 0x56]
  0x0E548: push     ss
  0x0E549: push     ax
  0x0E54A: mov      si, cx
  0x0E54C: lcall    0xd1d, 0x117e
  0x0E551: add      sp, 8
  0x0E554: or       si, si
  0x0E556: jge      0xe562
  0x0E558: neg      si
  0x0E55A: mov      word ptr [bp - 0x5c], si
  0x0E55D: mov      word ptr [bp - 0x68], 0
  0x0E562: les      bx, ptr [bp + 0xc]
  0x0E565: mov      al, byte ptr es:[bx]
  0x0E568: sub      ah, ah
  0x0E56A: sub      ax, word ptr [bp - 0x5c]
  0x0E56D: jns      0xe571
  0x0E56F: sub      ax, ax
  0x0E571: mov      byte ptr [bp - 0x5a], al
  0x0E574: cwde     
  0x0E575: mov      cx, ax
  0x0E577: add      ax, word ptr [bp - 0x68]
  0x0E57A: dec      ax
  0x0E57B: mov      word ptr [bp - 0x58], ax
  0x0E57E: mov      bx, word ptr [bp - 0x6c]
  0x0E581: mov      dx, word ptr [bx]
  0x0E583: mov      bx, dx
  0x0E585: dec      dx
  0x0E586: cmp      ax, dx
  0x0E588: jle      0xe59e
  0x0E58A: sub      ax, bx

============================================================
func_L375 at file 0x0E68A, 15 bytes
============================================================
  0x0E68A: push     bp
  0x0E68B: mov      bp, sp
  0x0E68D: mov      cx, ax
  0x0E68F: mov      byte ptr [0x269e], cl
  0x0E693: mov      byte ptr [0x269f], dl
  0x0E697: mov      ax, bx

============================================================
func_L376 at file 0x0E6A6, 41 bytes
============================================================
  0x0E6A6: enter    2, 0
  0x0E6AA: push     ax
  0x0E6AB: push     di
  0x0E6AC: push     si
  0x0E6AD: lds      si, ptr [bp + 6]
  0x0E6B0: mov      word ptr [bp - 2], 0
  0x0E6B5: cmp      byte ptr [si], 0
  0x0E6B8: je       0xe6e0
  0x0E6BA: mov      es, word ptr [bp + 0xc]
  0x0E6BD: mov      al, byte ptr [si]
  0x0E6BF: cwde     
  0x0E6C0: mov      di, ax
  0x0E6C2: dec      di
  0x0E6C3: inc      si
  0x0E6C4: add      di, word ptr [bp + 0xa]
  0x0E6C7: mov      cl, byte ptr es:[di + 2]
  0x0E6CB: sub      ch, ch
  0x0E6CD: or       cx, cx

============================================================
func_L377 at file 0x0E6EE, 20 bytes
============================================================
  0x0E6EE: push     bp
  0x0E6EF: mov      bp, sp
  0x0E6F1: mov      dx, 0x3da
  0x0E6F4: mov      ah, 8
  0x0E6F6: in       al, dx
  0x0E6F7: and      al, ah
  0x0E6F9: jne      0xe6f6
  0x0E6FB: in       al, dx
  0x0E6FC: and      al, ah
  0x0E6FE: je       0xe6fb
  0x0E700: leave    
  0x0E701: retf     

============================================================
func_L378 at file 0x0E702, 76 bytes
============================================================
  0x0E702: enter    4, 0
  0x0E706: push     dx
  0x0E707: push     ax
  0x0E708: push     di
  0x0E709: push     si
  0x0E70A: mov      cx, ax
  0x0E70C: shl      ax, 1
  0x0E70E: add      ax, cx
  0x0E710: mov      word ptr [bp - 2], ax
  0x0E713: mov      ax, dx
  0x0E715: shl      dx, 1
  0x0E717: add      dx, ax
  0x0E719: mov      word ptr [bp - 4], dx
  0x0E71C: mov      word ptr [0x808], 1
  0x0E722: mov      bx, word ptr [0x806]
  0x0E726: mov      di, word ptr [bp - 4]
  0x0E729: push     ds
  0x0E72A: lds      si, ptr [bp + 6]
  0x0E72D: add      si, word ptr [bp - 2]
  0x0E730: mov      dx, 0x3c8
  0x0E733: mov      ax, word ptr [bp - 8]
  0x0E736: out      dx, al
  0x0E737: inc      dx
  0x0E738: push     dx
  0x0E739: mov      dx, 0x3da
  0x0E73C: mov      ah, 8
  0x0E73E: in       al, dx
  0x0E73F: and      al, ah
  0x0E741: jne      0xe73e
  0x0E743: in       al, dx
  0x0E744: and      al, ah
  0x0E746: je       0xe743
  0x0E748: cli      
  0x0E749: pop      dx
  0x0E74A: mov      cx, di
  0x0E74C: cmp      cx, bx

============================================================
func_L379 at file 0x0E76A, 49 bytes
============================================================
  0x0E76A: enter    0x28, 0
  0x0E76E: push     dx
  0x0E76F: push     bx
  0x0E770: push     ax
  0x0E771: push     di
  0x0E772: push     si
  0x0E773: mov      ax, word ptr [bx + 2]
  0x0E776: dec      ax
  0x0E777: mov      word ptr [bp - 0x20], ax
  0x0E77A: mov      ax, word ptr [bx]
  0x0E77C: dec      ax
  0x0E77D: mov      word ptr [bp - 0x26], ax
  0x0E780: mov      dx, 1
  0x0E783: mov      ax, word ptr [bp - 0x2e]
  0x0E786: or       ax, ax
  0x0E788: jns      0xe78d
  0x0E78A: mov      dx, 0xffff
  0x0E78D: mov      word ptr [bp - 0x10], dx
  0x0E790: and      ax, 0x7fff  ; 12.5% chance
  0x0E793: mov      word ptr [bp - 0x2e], ax
  0x0E796: mov      bx, word ptr [bp - 0x2e]
  0x0E799: mov      ax, bx

============================================================
func_L380 at file 0x0E964, 54 bytes
============================================================
  0x0E964: enter    0x16e, 0
  0x0E968: push     dx
  0x0E969: push     bx
  0x0E96A: push     ax
  0x0E96B: push     di
  0x0E96C: push     si
  0x0E96D: mov      ax, word ptr [bx + 2]
  0x0E970: dec      ax
  0x0E971: mov      word ptr [bp - 0x162], ax
  0x0E975: mov      ax, word ptr [bx]
  0x0E977: dec      ax
  0x0E978: mov      word ptr [bp - 0x16c], ax
  0x0E97C: mov      dx, 1
  0x0E97F: mov      ax, word ptr [bp - 0x174]
  0x0E983: or       ax, ax
  0x0E985: jns      0xe98a
  0x0E987: mov      dx, 0xffff
  0x0E98A: mov      word ptr [bp - 0x10], dx
  0x0E98D: and      ax, 0x7fff  ; 12.5% chance
  0x0E990: mov      word ptr [bp - 0x174], ax
  0x0E994: mov      bx, word ptr [bp - 0x174]
  0x0E998: mov      ax, bx

============================================================
func_L381 at file 0x0EC32, 149 bytes
============================================================
  0x0EC32: push     bp
  0x0EC33: mov      bp, sp
  0x0EC35: push     bx
  0x0EC36: push     dx
  0x0EC37: push     di
  0x0EC38: push     si
  0x0EC39: lds      di, ptr [bp + 0xc]
  0x0EC3C: les      bx, ptr [bp + 6]
  0x0EC3F: mov      si, ax
  0x0EC41: shl      si, 1
  0x0EC43: add      si, ax
  0x0EC45: shl      si, 2
  0x0EC48: add      si, di
  0x0EC4A: add      si, 0x36
  0x0EC4D: mov      ax, word ptr [si + 8]
  0x0EC50: mul      word ptr [bp + 0xa]
  0x0EC53: add      ax, 0x32
  0x0EC56: mov      cx, 0x64
  0x0EC59: sub      dx, dx
  0x0EC5B: div      cx
  0x0EC5D: mov      word ptr es:[bx + 8], ax
  0x0EC61: mov      dx, ax
  0x0EC63: mov      ax, word ptr [si + 0xa]
  0x0EC66: mov      si, dx
  0x0EC68: mul      word ptr [bp + 0xa]
  0x0EC6B: add      ax, 0x32
  0x0EC6E: sub      dx, dx
  0x0EC70: div      cx
  0x0EC72: mov      word ptr es:[bx + 0xa], ax
  0x0EC76: shr      si, 1
  0x0EC78: sub      si, word ptr [bp - 4]
  0x0EC7B: neg      si
  0x0EC7D: mov      word ptr es:[bx + 4], si
  0x0EC81: sub      ax, word ptr [bp - 2]
  0x0EC84: neg      ax
  0x0EC86: inc      ax
  0x0EC87: mov      word ptr es:[bx + 6], ax
  0x0EC8B: mov      cx, 0x1b5a
  0x0EC8E: mov      ds, cx
  0x0EC90: pop      si
  0x0EC91: pop      di
  0x0EC92: leave    
  0x0EC93: retf     0xa
  0x0EC96: enter    0x28, 0
  0x0EC9A: push     dx
  0x0EC9B: push     bx
  0x0EC9C: push     ax
  0x0EC9D: push     di
  0x0EC9E: push     si
  0x0EC9F: mov      ax, word ptr [bx + 2]
  0x0ECA2: dec      ax
  0x0ECA3: mov      word ptr [bp - 0x20], ax
  0x0ECA6: mov      ax, word ptr [bx]
  0x0ECA8: dec      ax
  0x0ECA9: mov      word ptr [bp - 0x26], ax
  0x0ECAC: mov      dx, 1
  0x0ECAF: mov      ax, word ptr [bp - 0x2e]
  0x0ECB2: or       ax, ax
  0x0ECB4: jns      0xecb9
  0x0ECB6: mov      dx, 0xffff
  0x0ECB9: mov      word ptr [bp - 0x10], dx
  0x0ECBC: and      ax, 0x7fff  ; 12.5% chance
  0x0ECBF: mov      word ptr [bp - 0x2e], ax
  0x0ECC2: mov      bx, word ptr [bp - 0x2e]
  0x0ECC5: mov      ax, bx

============================================================
func_L382 at file 0x0EEA4, 54 bytes
============================================================
  0x0EEA4: enter    0x16e, 0
  0x0EEA8: push     dx
  0x0EEA9: push     bx
  0x0EEAA: push     ax
  0x0EEAB: push     di
  0x0EEAC: push     si
  0x0EEAD: mov      ax, word ptr [bx + 2]
  0x0EEB0: dec      ax
  0x0EEB1: mov      word ptr [bp - 0x162], ax
  0x0EEB5: mov      ax, word ptr [bx]
  0x0EEB7: dec      ax
  0x0EEB8: mov      word ptr [bp - 0x16c], ax
  0x0EEBC: mov      dx, 1
  0x0EEBF: mov      ax, word ptr [bp - 0x174]
  0x0EEC3: or       ax, ax
  0x0EEC5: jns      0xeeca
  0x0EEC7: mov      dx, 0xffff
  0x0EECA: mov      word ptr [bp - 0x10], dx
  0x0EECD: and      ax, 0x7fff  ; 12.5% chance
  0x0EED0: mov      word ptr [bp - 0x174], ax
  0x0EED4: mov      bx, word ptr [bp - 0x174]
  0x0EED8: mov      ax, bx

============================================================
func_L383 at file 0x0F184, 49 bytes
============================================================
  0x0F184: enter    0x28, 0
  0x0F188: push     dx
  0x0F189: push     bx
  0x0F18A: push     ax
  0x0F18B: push     di
  0x0F18C: push     si
  0x0F18D: mov      ax, word ptr [bx + 2]
  0x0F190: dec      ax
  0x0F191: mov      word ptr [bp - 0x20], ax
  0x0F194: mov      ax, word ptr [bx]
  0x0F196: dec      ax
  0x0F197: mov      word ptr [bp - 0x26], ax
  0x0F19A: mov      dx, 1
  0x0F19D: mov      ax, word ptr [bp - 0x2e]
  0x0F1A0: or       ax, ax
  0x0F1A2: jns      0xf1a7
  0x0F1A4: mov      dx, 0xffff
  0x0F1A7: mov      word ptr [bp - 0x10], dx
  0x0F1AA: and      ax, 0x7fff  ; 12.5% chance
  0x0F1AD: mov      word ptr [bp - 0x2e], ax
  0x0F1B0: mov      bx, word ptr [bp - 0x2e]
  0x0F1B3: mov      ax, bx

============================================================
func_L384 at file 0x0F38A, 46 bytes
============================================================
  0x0F38A: enter    0x10, 0
  0x0F38E: push     ax
  0x0F38F: push     di
  0x0F390: push     si
  0x0F391: mov      word ptr [bp - 0x10], 0
  0x0F396: push     ds
  0x0F397: les      di, ptr [bp + 6]
  0x0F39A: mov      si, word ptr [bp - 0x10]
  0x0F39D: mov      bx, si
  0x0F39F: shl      bx, 1
  0x0F3A1: mov      dx, word ptr [bp - 0x12]
  0x0F3A4: dec      dx
  0x0F3A5: cmp      si, dx
  0x0F3A7: jl       0xf3ac
  0x0F3A9: jmp      0xf448
  0x0F3AC: mov      ax, word ptr es:[bx + di + 2]
  0x0F3B0: cmp      ax, word ptr es:[bx + di]
  0x0F3B3: jb       0xf3be
  0x0F3B5: inc      si

============================================================
func_L385 at file 0x0F450, 44 bytes
============================================================
  0x0F450: enter    0x10, 0
  0x0F454: push     ax
  0x0F455: push     di
  0x0F456: push     si
  0x0F457: mov      word ptr [bp - 0x10], 0
  0x0F45C: push     ds
  0x0F45D: les      di, ptr [bp + 6]
  0x0F460: mov      si, word ptr [bp - 0x10]
  0x0F463: mov      bx, si
  0x0F465: mov      dx, word ptr [bp - 0x12]
  0x0F468: dec      dx
  0x0F469: cmp      si, dx
  0x0F46B: jl       0xf470
  0x0F46D: jmp      0xf508
  0x0F470: mov      al, byte ptr es:[bx + di + 1]
  0x0F474: cmp      al, byte ptr es:[bx + di]
  0x0F477: jb       0xf482
  0x0F479: inc      si

============================================================
func_L386 at file 0x0F510, 28 bytes
============================================================
  0x0F510: enter    0, 0
  0x0F514: mov      ax, word ptr [bp + 6]
  0x0F517: mov      word ptr [0x83aa], ax
  0x0F51A: jmp      0xf51d
  0x0F51C: nop      
  0x0F51D: cmp      word ptr [bp + 8], 0
  0x0F521: je       0xf52a
  0x0F523: mov      ax, word ptr [bp + 6]
  0x0F526: xor      ah, ah
  0x0F528: int      0x10
  0x0F52A: leave    
  0x0F52B: retf     

============================================================
func_L387 at file 0x0F52C, 147 bytes
============================================================
  0x0F52C: enter    4, 0
  0x0F530: push     ds
  0x0F531: push     es
  0x0F532: push     si
  0x0F533: push     di
  0x0F534: les      di, ptr [bp + 6]
  0x0F537: mov      bx, word ptr es:[di + 2]
  0x0F53B: mov      si, word ptr es:[di + 4]
  0x0F53F: mov      cx, word ptr es:[di + 6]
  0x0F543: mov      ax, word ptr [bp + 0xc]
  0x0F546: mul      bx
  0x0F548: shl      dx, 0xc
  0x0F54B: add      cx, dx
  0x0F54D: mov      dx, ax
  0x0F54F: and      dx, 0xfff0
  0x0F552: shr      dx, 4
  0x0F555: add      cx, dx
  0x0F557: and      ax, 0xf  ; 6.25% chance
  0x0F55A: add      si, ax
  0x0F55C: add      si, word ptr [bp + 0xa]
  0x0F55F: mov      ax, 0xa000
  0x0F562: mov      es, ax
  0x0F564: mov      ax, 0x140
  0x0F567: mul      word ptr [bp + 0x10]
  0x0F56A: mov      di, word ptr [bp + 0xe]
  0x0F56D: add      di, ax
  0x0F56F: mov      dx, word ptr [bp + 0x12]
  0x0F572: sub      bx, dx
  0x0F574: mov      ax, word ptr [bp + 0x14]
  0x0F577: push     bp
  0x0F578: mov      bp, 0x140
  0x0F57B: sub      bp, dx
  0x0F57D: mov      ds, cx
  0x0F57F: or       ax, ax
  0x0F581: jne      0xf586
  0x0F583: jmp      0xf5b8
  0x0F585: nop      
  0x0F586: shr      dx, 1
  0x0F588: jae      0xf59d
  0x0F58A: or       dx, dx
  0x0F58C: je       0xf592
  0x0F58E: mov      cx, dx
  0x0F590: rep movsw word ptr es:[di], word ptr [si]
  0x0F592: movsb    byte ptr es:[di], byte ptr [si]
  0x0F593: add      si, bx
  0x0F595: add      di, bp
  0x0F597: dec      ax
  0x0F598: jne      0xf58a
  0x0F59A: jmp      0xf5b8
  0x0F59C: nop      
  0x0F59D: je       0xf5b8
  0x0F59F: mov      cx, dx
  0x0F5A1: rep movsw word ptr es:[di], word ptr [si]
  0x0F5A3: add      si, bx
  0x0F5A5: jns      0xf5b3
  0x0F5A7: sub      si, 0x8000
  0x0F5AB: mov      cx, ds
  0x0F5AD: add      cx, 0x800
  0x0F5B1: mov      ds, cx
  0x0F5B3: add      di, bp
  0x0F5B5: dec      ax
  0x0F5B6: jne      0xf59f
  0x0F5B8: pop      bp
  0x0F5B9: pop      di
  0x0F5BA: pop      si
  0x0F5BB: pop      es
  0x0F5BC: pop      ds
  0x0F5BD: leave    
  0x0F5BE: retf     

============================================================
func_L388 at file 0x0F5E6, 68 bytes
============================================================
  0x0F5E6: push     bp
  0x0F5E7: mov      bp, sp
  0x0F5E9: push     si
  0x0F5EA: push     di
  0x0F5EB: push     ds
  0x0F5EC: xor      ax, ax
  0x0F5EE: mov      es, ax
  0x0F5F0: mov      al, 1
  0x0F5F2: mov      byte ptr es:[0x440], al
  0x0F5F6: cmp      byte ptr es:[0x440], al
  0x0F5FB: je       0xf5f6
  0x0F5FD: mov      ds, word ptr [bp + 8]
  0x0F600: mov      es, word ptr [bp + 0xa]
  0x0F603: cmp      word ptr cs:[0x12], 0
  0x0F609: jne      0xf60e
  0x0F60B: call     0xf69a
  0x0F60E: mov      cx, word ptr [bp + 6]
  0x0F611: jcxz     0xf65c
  0x0F613: mov      ax, 0x2260
  0x0F616: mov      dx, 0
  0x0F619: div      cx
  0x0F61B: mov      bx, ax
  0x0F61D: or       bx, bx
  0x0F61F: jne      0xf624
  0x0F621: mov      bx, 1
  0x0F624: mov      ax, word ptr cs:[0x12]
  0x0F628: sub      ax, bx

============================================================
func_L389 at file 0x0F702, 29 bytes
============================================================
  0x0F702: push     bp
  0x0F703: mov      bp, sp
  0x0F705: push     es
  0x0F706: push     di
  0x0F707: les      di, ptr [bp + 0xa]
  0x0F70A: push     es
  0x0F70B: les      di, ptr [bp + 6]
  0x0F70E: push     es
  0x0F70F: mov      ax, word ptr [bp + 0xe]
  0x0F712: push     ax
  0x0F713: lcall    0xd1d, 0x16
  0x0F718: add      sp, 6
  0x0F71B: pop      di
  0x0F71C: pop      es
  0x0F71D: pop      bp
  0x0F71E: retf     

============================================================
func_L390 at file 0x0F8DD, 7 bytes
============================================================
  0x0F8DD: push     bp
  0x0F8DE: mov      bp, sp
  0x0F8E0: xor      cx, cx
  0x0F8E2: jmp      0xf8fe

============================================================
func_L391 at file 0x0F8E4, 8 bytes
============================================================
  0x0F8E4: push     bp
  0x0F8E5: mov      bp, sp
  0x0F8E7: mov      cx, 1
  0x0F8EA: jmp      0xf8fe

============================================================
func_L392 at file 0x0F8EC, 10 bytes
============================================================
  0x0F8EC: push     bp
  0x0F8ED: mov      bp, sp
  0x0F8EF: push     si
  0x0F8F0: push     di
  0x0F8F1: mov      cx, 0x100
  0x0F8F4: jmp      0xf8fe

============================================================
func_L393 at file 0x0F8F6, 106 bytes
============================================================
  0x0F8F6: push     bp
  0x0F8F7: mov      bp, sp
  0x0F8F9: push     si
  0x0F8FA: push     di
  0x0F8FB: mov      cx, 0x101
  0x0F8FE: push     cx
  0x0F8FF: or       cl, cl
  0x0F901: jne      0xf921
  0x0F903: mov      si, 0x2d38
  0x0F906: mov      di, 0x2d38
  0x0F909: call     0xf98d
  0x0F90C: mov      si, 0x2b32
  0x0F90F: mov      di, 0x2b36
  0x0F912: call     0xf98d
  0x0F915: cmp      word ptr [0x2b16], 0xd6d6
  0x0F91B: jne      0xf921
  0x0F91D: call     word ptr [0x2b1c]
  0x0F921: mov      si, 0x2b36
  0x0F924: mov      di, 0x2b36
  0x0F927: call     0xf98d
  0x0F92A: mov      si, 0x2b36
  0x0F92D: mov      di, 0x2b36
  0x0F930: call     0xf98d
  0x0F933: lcall    0xd1d, 0x126a
  0x0F938: or       ax, ax
  0x0F93A: je       0xf94d
  0x0F93C: pop      ax
  0x0F93D: or       ah, ah
  0x0F93F: push     ax
  0x0F940: jne      0xf94d
  0x0F942: cmp      word ptr [bp + 6], 0
  0x0F946: jne      0xf94d
  0x0F948: mov      word ptr [bp + 6], 0xff
  0x0F94D: call     0xf960
  0x0F950: pop      ax
  0x0F951: or       ah, ah
  0x0F953: jne      0xf95c
  0x0F955: mov      ax, word ptr [bp + 6]
  0x0F958: mov      ah, 0x4c
  0x0F95A: int      0x21
  0x0F95C: pop      di
  0x0F95D: pop      si
  0x0F95E: pop      bp
  0x0F95F: retf     

============================================================
func_L394 at file 0x0F9C4, 186 bytes
============================================================
  0x0F9C4: push     bp
  0x0F9C5: mov      bp, sp
  0x0F9C7: sub      sp, 0xe
  0x0F9CA: push     di
  0x0F9CB: push     si
  0x0F9CC: mov      di, 0xffff
  0x0F9CF: mov      si, word ptr [bp + 6]
  0x0F9D2: test     byte ptr [si + 6], 0x40
  0x0F9D6: je       0xf9db
  0x0F9D8: jmp      0xfa72
  0x0F9DB: test     byte ptr [si + 6], 0x83
  0x0F9DF: jne      0xf9e4
  0x0F9E1: jmp      0xfa72
  0x0F9E4: push     si
  0x0F9E5: lcall    0xd1d, 0x1896
  0x0F9EA: add      sp, 2
  0x0F9ED: mov      di, ax
  0x0F9EF: mov      bx, si
  0x0F9F1: sub      bx, 0x290e
  0x0F9F5: mov      ax, word ptr [bx + 0x29b2]
  0x0F9F9: mov      word ptr [bp - 4], ax
  0x0F9FC: push     si
  0x0F9FD: call     0x10ca0
  0x0FA00: add      sp, 2
  0x0FA03: mov      al, byte ptr [si + 7]
  0x0FA06: sub      ah, ah
  0x0FA08: push     ax
  0x0FA09: lcall    0xd1d, 0x1e7a
  0x0FA0E: add      sp, 2
  0x0FA11: or       ax, ax
  0x0FA13: jl       0xfa6f
  0x0FA15: cmp      word ptr [bp - 4], 0
  0x0FA19: je       0xfa72
  0x0FA1B: mov      ax, 0x27e8
  0x0FA1E: push     ax
  0x0FA1F: lea      ax, [bp - 0xe]
  0x0FA22: push     ax
  0x0FA23: lcall    0xd1d, 0x7e4
  0x0FA28: add      sp, 4
  0x0FA2B: lea      ax, [bp - 0xc]
  0x0FA2E: mov      word ptr [bp - 2], ax
  0x0FA31: cmp      byte ptr [bp - 0xe], 0x5c
  0x0FA35: je       0xfa4a
  0x0FA37: mov      ax, 0x27ea
  0x0FA3A: push     ax
  0x0FA3B: lea      ax, [bp - 0xe]
  0x0FA3E: push     ax
  0x0FA3F: lcall    0xd1d, 0x7a4
  0x0FA44: add      sp, 4
  0x0FA47: jmp      0xfa4d
  0x0FA49: nop      
  0x0FA4A: dec      word ptr [bp - 2]
  0x0FA4D: mov      ax, 0xa
  0x0FA50: push     ax
  0x0FA51: push     word ptr [bp - 2]
  0x0FA54: push     word ptr [bp - 4]
  0x0FA57: lcall    0xd1d, 0x8fa
  0x0FA5C: add      sp, 6
  0x0FA5F: lea      ax, [bp - 0xe]
  0x0FA62: push     ax
  0x0FA63: lcall    0xd1d, 0xe4a
  0x0FA68: add      sp, 2
  0x0FA6B: or       ax, ax
  0x0FA6D: je       0xfa72
  0x0FA6F: mov      di, 0xffff
  0x0FA72: mov      byte ptr [si + 6], 0
  0x0FA76: mov      ax, di
  0x0FA78: pop      si
  0x0FA79: pop      di
  0x0FA7A: mov      sp, bp
  0x0FA7C: pop      bp
  0x0FA7D: retf     

============================================================
func_L395 at file 0x0FA7E, 43 bytes
============================================================
  0x0FA7E: push     bp
  0x0FA7F: mov      bp, sp
  0x0FA81: push     si
  0x0FA82: lcall    0xd1d, 0x1e46
  0x0FA87: mov      si, ax
  0x0FA89: or       si, si
  0x0FA8B: jne      0xfa92
  0x0FA8D: sub      ax, ax
  0x0FA8F: jmp      0xfaa4
  0x0FA91: nop      
  0x0FA92: push     si
  0x0FA93: push     word ptr [bp + 0xa]
  0x0FA96: push     word ptr [bp + 8]
  0x0FA99: push     word ptr [bp + 6]
  0x0FA9C: lcall    0xd1d, 0x16fc
  0x0FAA1: add      sp, 8
  0x0FAA4: pop      si
  0x0FAA5: mov      sp, bp
  0x0FAA7: pop      bp
  0x0FAA8: retf     

============================================================
func_L396 at file 0x0FAAA, 21 bytes
============================================================
  0x0FAAA: push     bp
  0x0FAAB: mov      bp, sp
  0x0FAAD: sub      ax, ax
  0x0FAAF: push     ax
  0x0FAB0: push     word ptr [bp + 8]
  0x0FAB3: push     word ptr [bp + 6]
  0x0FAB6: lcall    0xd1d, 0x4ae
  0x0FABB: mov      sp, bp
  0x0FABD: pop      bp
  0x0FABE: retf     

============================================================
func_L397 at file 0x0FAC0, 56 bytes
============================================================
  0x0FAC0: push     bp
  0x0FAC1: mov      bp, sp
  0x0FAC3: sub      sp, 4
  0x0FAC6: push     di
  0x0FAC7: push     si
  0x0FAC8: mov      si, word ptr [bp + 6]
  0x0FACB: push     si
  0x0FACC: call     0x10db4
  0x0FACF: add      sp, 2
  0x0FAD2: mov      di, ax
  0x0FAD4: lea      ax, [bp + 0xa]
  0x0FAD7: push     ax
  0x0FAD8: push     word ptr [bp + 8]
  0x0FADB: push     si
  0x0FADC: lcall    0xd1d, 0x196e
  0x0FAE1: add      sp, 6
  0x0FAE4: mov      word ptr [bp - 4], ax
  0x0FAE7: push     si
  0x0FAE8: push     di
  0x0FAE9: call     0x10e27
  0x0FAEC: add      sp, 4
  0x0FAEF: mov      ax, word ptr [bp - 4]
  0x0FAF2: pop      si
  0x0FAF3: pop      di
  0x0FAF4: mov      sp, bp
  0x0FAF6: pop      bp
  0x0FAF7: retf     

============================================================
func_L398 at file 0x0FAF8, 227 bytes
============================================================
  0x0FAF8: push     bp
  0x0FAF9: mov      bp, sp
  0x0FAFB: sub      sp, 4
  0x0FAFE: push     si
  0x0FAFF: push     di
  0x0FB00: mov      ax, word ptr [bp + 8]
  0x0FB03: mul      word ptr [bp + 0xa]
  0x0FB06: mov      cx, ax
  0x0FB08: jcxz     0xfb67
  0x0FB0A: mov      word ptr [bp - 2], ax
  0x0FB0D: mov      bx, word ptr [bp + 6]
  0x0FB10: mov      si, word ptr [bp + 0xc]
  0x0FB13: mov      di, 0x29ae
  0x0FB16: mov      ax, si
  0x0FB18: sub      ax, 0x290e
  0x0FB1B: add      di, ax
  0x0FB1D: test     byte ptr [si + 6], 0xc
  0x0FB21: jne      0xfb28
  0x0FB23: test     byte ptr [di], 1
  0x0FB26: je       0xfb2d
  0x0FB28: mov      ax, word ptr [di + 2]
  0x0FB2B: jmp      0xfb30
  0x0FB2D: mov      ax, 0x200
  0x0FB30: mov      word ptr [bp - 4], ax
  0x0FB33: test     byte ptr [si + 6], 0xc
  0x0FB37: jne      0xfb3e
  0x0FB39: test     byte ptr [di], 1
  0x0FB3C: je       0xfb6d
  0x0FB3E: mov      ax, word ptr [si + 2]
  0x0FB41: or       ax, ax
  0x0FB43: je       0xfb6d
  0x0FB45: cmp      ax, cx
  0x0FB47: jbe      0xfb4b
  0x0FB49: mov      ax, cx
  0x0FB4B: push     ax
  0x0FB4C: push     bx
  0x0FB4D: push     cx
  0x0FB4E: push     ax
  0x0FB4F: push     word ptr [si]
  0x0FB51: push     bx
  0x0FB52: push     cs
  0x0FB53: call     0x10352
  0x0FB56: add      sp, 6
  0x0FB59: pop      cx
  0x0FB5A: pop      bx
  0x0FB5B: pop      ax
  0x0FB5C: sub      cx, ax
  0x0FB5E: sub      word ptr [si + 2], ax
  0x0FB61: add      bx, ax
  0x0FB63: add      word ptr [si], ax
  0x0FB65: jmp      0xfb69
  0x0FB67: jmp      0xfbd5
  0x0FB69: jcxz     0xfbc4
  0x0FB6B: jmp      0xfb33
  0x0FB6D: cmp      cx, word ptr [bp - 4]
  0x0FB70: jb       0xfb9f
  0x0FB72: xor      dx, dx
  0x0FB74: mov      ax, cx
  0x0FB76: div      word ptr [bp - 4]
  0x0FB79: mov      ax, cx
  0x0FB7B: sub      ax, dx
  0x0FB7D: push     bx
  0x0FB7E: push     cx
  0x0FB7F: push     ax
  0x0FB80: push     bx
  0x0FB81: xor      ax, ax
  0x0FB83: mov      al, byte ptr [si + 7]
  0x0FB86: push     ax
  0x0FB87: push     cs
  0x0FB88: call     0x114e4
  0x0FB8B: add      sp, 6
  0x0FB8E: pop      cx
  0x0FB8F: pop      bx
  0x0FB90: or       ax, ax
  0x0FB92: je       0xfbba
  0x0FB94: cmp      ax, 0xffff
  0x0FB97: je       0xfbc0
  0x0FB99: sub      cx, ax
  0x0FB9B: add      bx, ax
  0x0FB9D: jmp      0xfb69
  0x0FB9F: push     bx
  0x0FBA0: push     cx
  0x0FBA1: push     si
  0x0FBA2: push     cs
  0x0FBA3: call     0x10b26
  0x0FBA6: pop      cx
  0x0FBA7: pop      cx
  0x0FBA8: pop      bx
  0x0FBA9: cmp      ax, 0xffff
  0x0FBAC: je       0xfbc4
  0x0FBAE: mov      byte ptr [bx], al
  0x0FBB0: inc      bx
  0x0FBB1: dec      cx
  0x0FBB2: mov      ax, word ptr [di + 2]
  0x0FBB5: mov      word ptr [bp - 4], ax
  0x0FBB8: jmp      0xfb69
  0x0FBBA: or       byte ptr [si + 6], 0x10
  0x0FBBE: jmp      0xfbc4
  0x0FBC0: or       byte ptr [si + 6], 0x20
  0x0FBC4: jcxz     0xfbd2
  0x0FBC6: mov      ax, word ptr [bp - 2]
  0x0FBC9: sub      ax, cx
  0x0FBCB: xor      dx, dx
  0x0FBCD: div      word ptr [bp + 8]
  0x0FBD0: jmp      0xfbd5
  0x0FBD2: mov      ax, word ptr [bp + 0xa]
  0x0FBD5: pop      di
  0x0FBD6: pop      si
  0x0FBD7: mov      sp, bp
  0x0FBD9: pop      bp
  0x0FBDA: retf     

============================================================
func_L399 at file 0x0FBDC, 261 bytes
============================================================
  0x0FBDC: push     bp
  0x0FBDD: mov      bp, sp
  0x0FBDF: sub      sp, 4
  0x0FBE2: push     si
  0x0FBE3: push     di
  0x0FBE4: mov      ax, word ptr [bp + 8]
  0x0FBE7: mul      word ptr [bp + 0xa]
  0x0FBEA: mov      cx, ax
  0x0FBEC: jcxz     0xfc4b
  0x0FBEE: mov      word ptr [bp - 2], ax
  0x0FBF1: mov      bx, word ptr [bp + 6]
  0x0FBF4: mov      si, word ptr [bp + 0xc]
  0x0FBF7: mov      di, 0x29ae
  0x0FBFA: mov      ax, si
  0x0FBFC: sub      ax, 0x290e
  0x0FBFF: add      di, ax
  0x0FC01: test     byte ptr [si + 6], 0xc
  0x0FC05: jne      0xfc0c
  0x0FC07: test     byte ptr [di], 1
  0x0FC0A: je       0xfc11
  0x0FC0C: mov      ax, word ptr [di + 2]
  0x0FC0F: jmp      0xfc14
  0x0FC11: mov      ax, 0x200
  0x0FC14: mov      word ptr [bp - 4], ax
  0x0FC17: test     byte ptr [si + 6], 8
  0x0FC1B: jne      0xfc22
  0x0FC1D: test     byte ptr [di], 1
  0x0FC20: je       0xfc54
  0x0FC22: mov      ax, word ptr [si + 2]
  0x0FC25: or       ax, ax
  0x0FC27: je       0xfc54
  0x0FC29: cmp      ax, cx
  0x0FC2B: jbe      0xfc2f
  0x0FC2D: mov      ax, cx
  0x0FC2F: push     ax
  0x0FC30: push     bx
  0x0FC31: push     cx
  0x0FC32: push     ax
  0x0FC33: push     bx
  0x0FC34: push     word ptr [si]
  0x0FC36: push     cs
  0x0FC37: call     0x10352
  0x0FC3A: add      sp, 6
  0x0FC3D: pop      cx
  0x0FC3E: pop      bx
  0x0FC3F: pop      ax
  0x0FC40: sub      cx, ax
  0x0FC42: sub      word ptr [si + 2], ax
  0x0FC45: add      bx, ax
  0x0FC47: add      word ptr [si], ax
  0x0FC49: jmp      0xfc4e
  0x0FC4B: jmp      0xfcdb
  0x0FC4E: or       cx, cx
  0x0FC50: jne      0xfc17
  0x0FC52: jmp      0xfcca
  0x0FC54: cmp      cx, word ptr [bp - 4]
  0x0FC57: jb       0xfca1
  0x0FC59: test     byte ptr [si + 6], 8
  0x0FC5D: jne      0xfc64
  0x0FC5F: test     byte ptr [di], 1
  0x0FC62: je       0xfc72
  0x0FC64: push     bx
  0x0FC65: push     cx
  0x0FC66: push     si
  0x0FC67: push     cs
  0x0FC68: call     0x10e66
  0x0FC6B: pop      dx
  0x0FC6C: pop      cx
  0x0FC6D: pop      bx
  0x0FC6E: or       ax, ax
  0x0FC70: jne      0xfcca
  0x0FC72: xor      dx, dx
  0x0FC74: mov      ax, cx
  0x0FC76: div      word ptr [bp - 4]
  0x0FC79: mov      ax, cx
  0x0FC7B: sub      ax, dx
  0x0FC7D: push     ax
  0x0FC7E: push     bx
  0x0FC7F: push     cx
  0x0FC80: push     ax
  0x0FC81: push     bx
  0x0FC82: xor      ax, ax
  0x0FC84: mov      al, byte ptr [si + 7]
  0x0FC87: push     ax
  0x0FC88: push     cs
  0x0FC89: call     0x115ce
  0x0FC8C: add      sp, 6
  0x0FC8F: pop      cx
  0x0FC90: pop      bx
  0x0FC91: pop      dx
  0x0FC92: cmp      ax, 0xffff
  0x0FC95: je       0xfcc6
  0x0FC97: sub      cx, ax
  0x0FC99: cmp      ax, dx
  0x0FC9B: jne      0xfcc6
  0x0FC9D: add      bx, ax
  0x0FC9F: jmp      0xfc4e
  0x0FCA1: xor      ax, ax
  0x0FCA3: mov      al, byte ptr [bx]
  0x0FCA5: push     bx
  0x0FCA6: push     cx
  0x0FCA7: push     si
  0x0FCA8: push     ax
  0x0FCA9: push     cs
  0x0FCAA: call     0x10bbc
  0x0FCAD: add      sp, 4
  0x0FCB0: pop      cx
  0x0FCB1: pop      bx
  0x0FCB2: cmp      ax, 0xffff
  0x0FCB5: je       0xfcca
  0x0FCB7: inc      bx
  0x0FCB8: dec      cx
  0x0FCB9: mov      ax, word ptr [di + 2]
  0x0FCBC: or       ax, ax
  0x0FCBE: jne      0xfcc1
  0x0FCC0: inc      ax
  0x0FCC1: mov      word ptr [bp - 4], ax
  0x0FCC4: jmp      0xfc4e
  0x0FCC6: or       byte ptr [si + 6], 0x20
  0x0FCCA: jcxz     0xfcd8
  0x0FCCC: mov      ax, word ptr [bp - 2]
  0x0FCCF: sub      ax, cx
  0x0FCD1: xor      dx, dx
  0x0FCD3: div      word ptr [bp + 8]
  0x0FCD6: jmp      0xfcdb
  0x0FCD8: mov      ax, word ptr [bp + 0xa]
  0x0FCDB: pop      di
  0x0FCDC: pop      si
  0x0FCDD: mov      sp, bp
  0x0FCDF: pop      bp
  0x0FCE0: retf     

============================================================
func_L400 at file 0x0FCE2, 14 bytes
============================================================
  0x0FCE2: push     bp
  0x0FCE3: mov      bp, sp
  0x0FCE5: sub      sp, 4
  0x0FCE8: push     di
  0x0FCE9: push     si
  0x0FCEA: mov      si, 0x2916
  0x0FCED: push     si

============================================================
func_L401 at file 0x0FD20, 8 bytes
============================================================
  0x0FD20: push     bp
  0x0FD21: mov      bp, sp
  0x0FD23: mov      bx, 0x2916
  0x0FD26: jmp      0xfd2e

============================================================
func_L402 at file 0x0FD28, 37 bytes
============================================================
  0x0FD28: push     bp
  0x0FD29: mov      bp, sp
  0x0FD2B: mov      bx, word ptr [bp + 8]
  0x0FD2E: dec      word ptr [bx + 2]
  0x0FD31: js       0xfd41
  0x0FD33: inc      word ptr [bx]
  0x0FD35: mov      bx, word ptr [bx]
  0x0FD37: mov      al, byte ptr [bp + 6]
  0x0FD3A: mov      byte ptr [bx - 1], al
  0x0FD3D: xor      ah, ah
  0x0FD3F: jmp      0xfd4b
  0x0FD41: push     bx
  0x0FD42: push     word ptr [bp + 6]
  0x0FD45: push     cs
  0x0FD46: call     0x10bbc
  0x0FD49: pop      bx
  0x0FD4A: pop      bx
  0x0FD4B: pop      bp
  0x0FD4C: retf     

============================================================
func_L403 at file 0x0FD4E, 8 bytes
============================================================
  0x0FD4E: push     bp
  0x0FD4F: mov      bp, sp
  0x0FD51: mov      bx, 0x290e
  0x0FD54: jmp      0xfd5c

============================================================
func_L404 at file 0x0FD56, 30 bytes
============================================================
  0x0FD56: push     bp
  0x0FD57: mov      bp, sp
  0x0FD59: mov      bx, word ptr [bp + 6]
  0x0FD5C: dec      word ptr [bx + 2]
  0x0FD5F: js       0xfd6c
  0x0FD61: inc      word ptr [bx]
  0x0FD63: mov      bx, word ptr [bx]
  0x0FD65: mov      al, byte ptr [bx - 1]
  0x0FD68: xor      ah, ah
  0x0FD6A: jmp      0xfd72
  0x0FD6C: push     bx
  0x0FD6D: push     cs
  0x0FD6E: call     0x10b26
  0x0FD71: pop      bx
  0x0FD72: pop      bp
  0x0FD73: retf     

============================================================
func_L405 at file 0x0FD74, 63 bytes
============================================================
  0x0FD74: push     bp
  0x0FD75: mov      bp, sp
  0x0FD77: mov      dx, di
  0x0FD79: mov      bx, si
  0x0FD7B: mov      ax, ds
  0x0FD7D: mov      es, ax
  0x0FD7F: mov      di, word ptr [bp + 6]
  0x0FD82: xor      ax, ax
  0x0FD84: mov      cx, 0xffff
  0x0FD87: repne scasb al, byte ptr es:[di]
  0x0FD89: lea      si, [di - 1]
  0x0FD8C: mov      di, word ptr [bp + 8]
  0x0FD8F: mov      cx, 0xffff
  0x0FD92: repne scasb al, byte ptr es:[di]
  0x0FD94: not      cx
  0x0FD96: sub      di, cx
  0x0FD98: xchg     si, di
  0x0FD9A: mov      ax, word ptr [bp + 6]
  0x0FD9D: test     si, 1
  0x0FDA1: je       0xfda5
  0x0FDA3: movsb    byte ptr es:[di], byte ptr [si]
  0x0FDA4: dec      cx
  0x0FDA5: shr      cx, 1
  0x0FDA7: rep movsw word ptr es:[di], word ptr [si]
  0x0FDA9: adc      cx, cx
  0x0FDAB: rep movsb byte ptr es:[di], byte ptr [si]
  0x0FDAD: mov      si, bx
  0x0FDAF: mov      di, dx
  0x0FDB1: pop      bp
  0x0FDB2: retf     

============================================================
func_L406 at file 0x0FDB4, 50 bytes
============================================================
  0x0FDB4: push     bp
  0x0FDB5: mov      bp, sp
  0x0FDB7: mov      dx, di
  0x0FDB9: mov      bx, si
  0x0FDBB: mov      si, word ptr [bp + 8]
  0x0FDBE: mov      di, si
  0x0FDC0: mov      ax, ds
  0x0FDC2: mov      es, ax
  0x0FDC4: xor      ax, ax
  0x0FDC6: mov      cx, 0xffff
  0x0FDC9: repne scasb al, byte ptr es:[di]
  0x0FDCB: not      cx
  0x0FDCD: mov      di, word ptr [bp + 6]
  0x0FDD0: mov      ax, di
  0x0FDD2: test     al, 1
  0x0FDD4: je       0xfdd8
  0x0FDD6: movsb    byte ptr es:[di], byte ptr [si]
  0x0FDD7: dec      cx
  0x0FDD8: shr      cx, 1
  0x0FDDA: rep movsw word ptr es:[di], word ptr [si]
  0x0FDDC: adc      cx, cx
  0x0FDDE: rep movsb byte ptr es:[di], byte ptr [si]
  0x0FDE0: mov      si, bx
  0x0FDE2: mov      di, dx
  0x0FDE4: pop      bp
  0x0FDE5: retf     

============================================================
func_L407 at file 0x0FDE6, 43 bytes
============================================================
  0x0FDE6: push     bp
  0x0FDE7: mov      bp, sp
  0x0FDE9: mov      dx, di
  0x0FDEB: mov      bx, si
  0x0FDED: mov      ax, ds
  0x0FDEF: mov      es, ax
  0x0FDF1: mov      si, word ptr [bp + 6]
  0x0FDF4: mov      di, word ptr [bp + 8]
  0x0FDF7: xor      ax, ax
  0x0FDF9: mov      cx, 0xffff
  0x0FDFC: repne scasb al, byte ptr es:[di]
  0x0FDFE: not      cx
  0x0FE00: sub      di, cx
  0x0FE02: repe cmpsb byte ptr [si], byte ptr es:[di]
  0x0FE04: je       0xfe0b
  0x0FE06: sbb      ax, ax
  0x0FE08: sbb      ax, 0xffff
  0x0FE0B: mov      si, bx
  0x0FE0D: mov      di, dx
  0x0FE0F: pop      bp
  0x0FE10: retf     

============================================================
func_L408 at file 0x0FE12, 27 bytes
============================================================
  0x0FE12: push     bp
  0x0FE13: mov      bp, sp
  0x0FE15: mov      dx, di
  0x0FE17: mov      ax, ds
  0x0FE19: mov      es, ax
  0x0FE1B: mov      di, word ptr [bp + 6]
  0x0FE1E: xor      ax, ax
  0x0FE20: mov      cx, 0xffff
  0x0FE23: repne scasb al, byte ptr es:[di]
  0x0FE25: not      cx
  0x0FE27: dec      cx
  0x0FE28: xchg     cx, ax
  0x0FE29: mov      di, dx
  0x0FE2B: pop      bp
  0x0FE2C: retf     

============================================================
func_L409 at file 0x0FE2E, 53 bytes
============================================================
  0x0FE2E: push     bp
  0x0FE2F: mov      bp, sp
  0x0FE31: push     di
  0x0FE32: push     si
  0x0FE33: push     ds
  0x0FE34: pop      es
  0x0FE35: mov      di, word ptr [bp + 6]
  0x0FE38: mov      dx, di
  0x0FE3A: xor      ax, ax
  0x0FE3C: mov      cx, 0xffff
  0x0FE3F: repne scasb al, byte ptr es:[di]
  0x0FE41: dec      di
  0x0FE42: mov      si, di
  0x0FE44: mov      di, word ptr [bp + 8]
  0x0FE47: mov      bx, di
  0x0FE49: mov      cx, word ptr [bp + 0xa]
  0x0FE4C: repne scasb al, byte ptr es:[di]
  0x0FE4E: jne      0xfe51
  0x0FE50: inc      cx
  0x0FE51: sub      cx, word ptr [bp + 0xa]
  0x0FE54: neg      cx
  0x0FE56: mov      di, si
  0x0FE58: mov      si, bx
  0x0FE5A: rep movsb byte ptr es:[di], byte ptr [si]
  0x0FE5C: stosb    byte ptr es:[di], al
  0x0FE5D: mov      ax, dx
  0x0FE5F: pop      si
  0x0FE60: pop      di
  0x0FE61: pop      bp
  0x0FE62: retf     

============================================================
func_L410 at file 0x0FE64, 34 bytes
============================================================
  0x0FE64: push     bp
  0x0FE65: mov      bp, sp
  0x0FE67: push     di
  0x0FE68: push     si
  0x0FE69: push     ds
  0x0FE6A: pop      es
  0x0FE6B: mov      di, word ptr [bp + 6]
  0x0FE6E: mov      si, word ptr [bp + 8]
  0x0FE71: mov      bx, di
  0x0FE73: mov      cx, word ptr [bp + 0xa]
  0x0FE76: jcxz     0xfe84
  0x0FE78: lodsb    al, byte ptr [si]
  0x0FE79: or       al, al
  0x0FE7B: je       0xfe80
  0x0FE7D: stosb    byte ptr es:[di], al
  0x0FE7E: loop     0xfe78
  0x0FE80: xor      al, al
  0x0FE82: rep stosb byte ptr es:[di], al
  0x0FE84: mov      ax, bx

============================================================
func_L411 at file 0x0FE8C, 27 bytes
============================================================
  0x0FE8C: push     bp
  0x0FE8D: mov      bp, sp
  0x0FE8F: push     di
  0x0FE90: push     si
  0x0FE91: push     ds
  0x0FE92: pop      es
  0x0FE93: mov      cx, word ptr [bp + 0xa]
  0x0FE96: jcxz     0xfebe
  0x0FE98: mov      bx, cx
  0x0FE9A: mov      di, word ptr [bp + 6]
  0x0FE9D: mov      si, di
  0x0FE9F: xor      ax, ax
  0x0FEA1: repne scasb al, byte ptr es:[di]
  0x0FEA3: neg      cx
  0x0FEA5: add      cx, bx

============================================================
func_L412 at file 0x0FECA, 28 bytes
============================================================
  0x0FECA: push     bp
  0x0FECB: mov      bp, sp
  0x0FECD: push     si
  0x0FECE: push     di
  0x0FECF: mov      bl, 1
  0x0FED1: mov      cx, word ptr [bp + 0xa]
  0x0FED4: mov      ax, word ptr [bp + 6]
  0x0FED7: xor      dx, dx
  0x0FED9: cmp      cx, 0xa
  0x0FEDC: jne      0xfedf
  0x0FEDE: cdq      
  0x0FEDF: mov      di, word ptr [bp + 8]
  0x0FEE2: jmp      0x11b02

============================================================
func_L413 at file 0x0FEE6, 10 bytes
============================================================
  0x0FEE6: push     bp
  0x0FEE7: mov      bp, sp
  0x0FEE9: push     si
  0x0FEEA: push     di
  0x0FEEB: mov      bl, 1
  0x0FEED: jmp      0x11af6

============================================================
func_L414 at file 0x0FEF0, 11 bytes
============================================================
  0x0FEF0: push     bp
  0x0FEF1: mov      bp, sp
  0x0FEF3: mov      ax, word ptr [bp + 6]
  0x0FEF6: sub      ax, 0x20
  0x0FEF9: pop      bp
  0x0FEFA: retf     

============================================================
func_L415 at file 0x0FEFC, 20 bytes
============================================================
  0x0FEFC: push     bp
  0x0FEFD: mov      bp, sp
  0x0FEFF: mov      bx, word ptr [bp + 6]
  0x0FF02: test     byte ptr [bx + 0x27ed], 2
  0x0FF07: je       0xff0e
  0x0FF09: lea      ax, [bx - 0x20]
  0x0FF0C: jmp      0xff10
  0x0FF0E: mov      ax, bx

============================================================
func_L416 at file 0x0FF12, 87 bytes
============================================================
  0x0FF12: push     bp
  0x0FF13: mov      bp, sp
  0x0FF15: push     di
  0x0FF16: push     si
  0x0FF17: mov      si, word ptr [0x27d3]
  0x0FF1B: or       si, si
  0x0FF1D: je       0xff69
  0x0FF1F: cmp      word ptr [bp + 6], 0
  0x0FF23: je       0xff69
  0x0FF25: push     word ptr [bp + 6]
  0x0FF28: lcall    0xd1d, 0x842
  0x0FF2D: add      sp, 2
  0x0FF30: mov      di, ax
  0x0FF32: jmp      0xff64
  0x0FF34: push     word ptr [si]
  0x0FF36: lcall    0xd1d, 0x842
  0x0FF3B: add      sp, 2
  0x0FF3E: cmp      ax, di
  0x0FF40: jle      0xff62
  0x0FF42: mov      bx, word ptr [si]
  0x0FF44: cmp      byte ptr [bx + di], 0x3d
  0x0FF47: jne      0xff62
  0x0FF49: push     di
  0x0FF4A: push     word ptr [bp + 6]
  0x0FF4D: push     bx
  0x0FF4E: lcall    0xd1d, 0x8bc
  0x0FF53: add      sp, 6
  0x0FF56: or       ax, ax
  0x0FF58: jne      0xff62
  0x0FF5A: mov      ax, word ptr [si]
  0x0FF5C: add      ax, di
  0x0FF5E: inc      ax
  0x0FF5F: jmp      0xff6b
  0x0FF61: nop      
  0x0FF62: inc      si
  0x0FF63: inc      si
  0x0FF64: cmp      word ptr [si], 0
  0x0FF67: jne      0xff34

============================================================
func_L417 at file 0x0FF72, 39 bytes
============================================================
  0x0FF72: push     bp
  0x0FF73: mov      bp, sp
  0x0FF75: push     word ptr [bp + 6]
  0x0FF78: lcall    0xd1d, 0x2290
  0x0FF7D: mov      sp, bp
  0x0FF7F: mov      bx, word ptr [bp + 8]
  0x0FF82: mov      word ptr [bx], ax
  0x0FF84: mov      word ptr [bx + 2], dx
  0x0FF87: cmp      ax, 0xffff
  0x0FF8A: jne      0xff90
  0x0FF8C: cmp      dx, ax
  0x0FF8E: je       0xff94
  0x0FF90: sub      ax, ax
  0x0FF92: jmp      0xff97
  0x0FF94: mov      ax, 0xffff
  0x0FF97: pop      bp
  0x0FF98: retf     

============================================================
func_L418 at file 0x0FF9A, 115 bytes
============================================================
  0x0FF9A: push     bp
  0x0FF9B: mov      bp, sp
  0x0FF9D: push     si
  0x0FF9E: push     di
  0x0FF9F: mov      dx, word ptr [bp + 8]
  0x0FFA2: or       dx, dx
  0x0FFA4: jle      0xfffa
  0x0FFA6: dec      dx
  0x0FFA7: mov      bx, word ptr [bp + 0xa]
  0x0FFAA: push     ds
  0x0FFAB: pop      es
  0x0FFAC: mov      di, word ptr [bp + 6]
  0x0FFAF: or       dx, dx
  0x0FFB1: je       0x10003
  0x0FFB3: mov      cx, word ptr [bx + 2]
  0x0FFB6: jcxz     0xffd6
  0x0FFB8: cmp      cx, dx
  0x0FFBA: jbe      0xffbe
  0x0FFBC: mov      cx, dx
  0x0FFBE: mov      si, word ptr [bx]
  0x0FFC0: mov      ah, 0xa
  0x0FFC2: push     cx
  0x0FFC3: nop      
  0x0FFC4: lodsb    al, byte ptr [si]
  0x0FFC5: stosb    byte ptr es:[di], al
  0x0FFC6: cmp      al, ah
  0x0FFC8: loopne   0xffc4
  0x0FFCA: pop      ax
  0x0FFCB: mov      word ptr [bx], si
  0x0FFCD: je       0xfffe
  0x0FFCF: sub      word ptr [bx + 2], ax
  0x0FFD2: sub      dx, ax
  0x0FFD4: jmp      0xffaf
  0x0FFD6: push     es
  0x0FFD7: push     bx
  0x0FFD8: push     dx
  0x0FFD9: push     bx
  0x0FFDA: push     cs
  0x0FFDB: call     0x10b26
  0x0FFDE: pop      dx
  0x0FFDF: pop      dx
  0x0FFE0: pop      bx
  0x0FFE1: pop      es
  0x0FFE2: cmp      ax, 0xffff
  0x0FFE5: je       0xffef
  0x0FFE7: stosb    byte ptr es:[di], al
  0x0FFE8: cmp      al, 0xa
  0x0FFEA: je       0x10003
  0x0FFEC: dec      dx
  0x0FFED: jmp      0xffaf
  0x0FFEF: cmp      di, word ptr [bp + 6]
  0x0FFF2: je       0xfffa
  0x0FFF4: test     byte ptr [bx + 6], 0x20
  0x0FFF8: je       0x10003
  0x0FFFA: xor      ax, ax
  0x0FFFC: jmp      0x10009
  0x0FFFE: sub      ax, cx
  0x10000: sub      word ptr [bx + 2], ax
  0x10003: xor      ax, ax
  0x10005: stosb    byte ptr es:[di], al
  0x10006: mov      ax, word ptr [bp + 6]
  0x10009: pop      di
  0x1000A: pop      si
  0x1000B: pop      bp
  0x1000C: retf     

============================================================
func_L419 at file 0x1000E, 127 bytes
============================================================
  0x1000E: push     bp
  0x1000F: mov      bp, sp
  0x10011: push     si
  0x10012: mov      si, word ptr [bp + 6]
  0x10015: test     byte ptr [si + 6], 0x83
  0x10019: je       0x10027
  0x1001B: cmp      word ptr [bp + 0xc], 2
  0x1001F: jg       0x10027
  0x10021: cmp      word ptr [bp + 0xc], 0
  0x10025: jge      0x10030
  0x10027: mov      word ptr [0x27ac], 0x16
  0x1002D: jmp      0x10081
  0x1002F: nop      
  0x10030: and      byte ptr [si + 6], 0xef
  0x10034: cmp      word ptr [bp + 0xc], 1
  0x10038: jne      0x1004e
  0x1003A: push     si
  0x1003B: lcall    0xd1d, 0x2290
  0x10040: add      sp, 2
  0x10043: add      word ptr [bp + 8], ax
  0x10046: adc      word ptr [bp + 0xa], dx
  0x10049: mov      word ptr [bp + 0xc], 0
  0x1004E: push     si
  0x1004F: lcall    0xd1d, 0x1896
  0x10054: add      sp, 2
  0x10057: test     byte ptr [si + 6], 0x80
  0x1005B: je       0x10061
  0x1005D: and      byte ptr [si + 6], 0xfc
  0x10061: push     word ptr [bp + 0xc]
  0x10064: push     word ptr [bp + 0xa]
  0x10067: push     word ptr [bp + 8]
  0x1006A: mov      al, byte ptr [si + 7]
  0x1006D: sub      ah, ah
  0x1006F: push     ax
  0x10070: lcall    0xd1d, 0x1e9a
  0x10075: add      sp, 8
  0x10078: cmp      ax, 0xffff
  0x1007B: jne      0x10086
  0x1007D: cmp      dx, ax
  0x1007F: jne      0x10086
  0x10081: mov      ax, 0xffff
  0x10084: jmp      0x10088
  0x10086: sub      ax, ax
  0x10088: pop      si
  0x10089: mov      sp, bp
  0x1008B: pop      bp
  0x1008C: retf     

============================================================
func_L420 at file 0x1008E, 26 bytes
============================================================
  0x1008E: push     bp
  0x1008F: mov      bp, sp
  0x10091: sub      ax, ax
  0x10093: push     ax
  0x10094: mov      bx, word ptr [bp + 8]
  0x10097: push     word ptr [bx + 2]
  0x1009A: push     word ptr [bx]
  0x1009C: push     word ptr [bp + 6]
  0x1009F: lcall    0xd1d, 0xa3e
  0x100A4: mov      sp, bp
  0x100A6: pop      bp
  0x100A7: retf     

============================================================
func_L421 at file 0x100A8, 67 bytes
============================================================
  0x100A8: push     bp
  0x100A9: mov      bp, sp
  0x100AB: push     di
  0x100AC: push     si
  0x100AD: mov      si, word ptr [bp + 6]
  0x100B0: mov      al, byte ptr [si + 7]
  0x100B3: sub      ah, ah
  0x100B5: mov      di, ax
  0x100B7: push     si
  0x100B8: lcall    0xd1d, 0x1896
  0x100BD: add      sp, 2
  0x100C0: and      byte ptr [di + 0x27bb], 0xfd
  0x100C5: and      byte ptr [si + 6], 0xcf
  0x100C9: test     byte ptr [si + 6], 0x80
  0x100CD: je       0x100d7
  0x100CF: mov      al, byte ptr [si + 6]
  0x100D2: and      al, 0xfc
  0x100D4: mov      byte ptr [si + 6], al
  0x100D7: sub      ax, ax
  0x100D9: push     ax
  0x100DA: push     ax
  0x100DB: push     ax
  0x100DC: push     di
  0x100DD: lcall    0xd1d, 0x1e9a
  0x100E2: add      sp, 8
  0x100E5: pop      si
  0x100E6: pop      di
  0x100E7: mov      sp, bp
  0x100E9: pop      bp
  0x100EA: retf     

============================================================
func_L422 at file 0x100EC, 44 bytes
============================================================
  0x100EC: push     bp
  0x100ED: mov      bp, sp
  0x100EF: cmp      word ptr [bp + 8], 0
  0x100F3: jne      0x10102
  0x100F5: sub      ax, ax
  0x100F7: push     ax
  0x100F8: mov      ax, 4
  0x100FB: push     ax
  0x100FC: sub      ax, ax
  0x100FE: push     ax
  0x100FF: jmp      0x1010c
  0x10101: nop      
  0x10102: mov      ax, 0x200
  0x10105: push     ax
  0x10106: sub      ax, ax
  0x10108: push     ax
  0x10109: push     word ptr [bp + 8]
  0x1010C: push     word ptr [bp + 6]
  0x1010F: lcall    0xd1d, 0x2406
  0x10114: mov      sp, bp
  0x10116: pop      bp
  0x10117: retf     

============================================================
func_L423 at file 0x10118, 90 bytes
============================================================
  0x10118: push     bp
  0x10119: mov      bp, sp
  0x1011B: sub      sp, 2
  0x1011E: push     di
  0x1011F: push     si
  0x10120: mov      byte ptr [0x2d36], 0x42
  0x10125: mov      ax, word ptr [bp + 6]
  0x10128: mov      word ptr [0x2d34], ax
  0x1012B: mov      si, 0x2d30
  0x1012E: mov      word ptr [si], ax
  0x10130: mov      word ptr [0x2d32], 0x7fff
  0x10136: lea      ax, [bp + 0xa]
  0x10139: push     ax
  0x1013A: push     word ptr [bp + 8]
  0x1013D: mov      ax, si
  0x1013F: push     ax
  0x10140: lcall    0xd1d, 0x196e
  0x10145: add      sp, 6
  0x10148: mov      di, ax
  0x1014A: dec      word ptr [0x2d32]
  0x1014E: js       0x1015e
  0x10150: mov      bx, word ptr [0x2d30]
  0x10154: inc      word ptr [0x2d30]
  0x10158: mov      byte ptr [bx], 0
  0x1015B: jmp      0x1016a
  0x1015D: nop      
  0x1015E: push     si
  0x1015F: sub      ax, ax
  0x10161: push     ax
  0x10162: lcall    0xd1d, 0x15ec
  0x10167: add      sp, 4
  0x1016A: mov      ax, di
  0x1016C: pop      si
  0x1016D: pop      di
  0x1016E: mov      sp, bp
  0x10170: pop      bp
  0x10171: retf     

============================================================
func_L424 at file 0x10172, 134 bytes
============================================================
  0x10172: push     bp
  0x10173: mov      bp, sp
  0x10175: sub      sp, 8
  0x10178: push     si
  0x10179: mov      si, word ptr [bp + 6]
  0x1017C: or       si, si
  0x1017E: jl       0x10186
  0x10180: cmp      word ptr [0x27b9], si
  0x10184: jg       0x10192
  0x10186: mov      word ptr [0x27ac], 9
  0x1018C: mov      ax, 0xffff
  0x1018F: cdq      
  0x10190: jmp      0x101f3
  0x10192: mov      ax, 1
  0x10195: push     ax
  0x10196: sub      ax, ax
  0x10198: push     ax
  0x10199: push     ax
  0x1019A: push     si
  0x1019B: lcall    0xd1d, 0x1e9a
  0x101A0: add      sp, 8
  0x101A3: mov      word ptr [bp - 8], ax
  0x101A6: mov      word ptr [bp - 6], dx
  0x101A9: cmp      ax, 0xffff
  0x101AC: jne      0x101ba
  0x101AE: cmp      dx, ax
  0x101B0: jne      0x101ba
  0x101B2: mov      word ptr [bp - 4], ax
  0x101B5: mov      word ptr [bp - 2], ax
  0x101B8: jmp      0x101ed
  0x101BA: mov      ax, 2
  0x101BD: push     ax
  0x101BE: sub      ax, ax
  0x101C0: push     ax
  0x101C1: push     ax
  0x101C2: push     si
  0x101C3: lcall    0xd1d, 0x1e9a
  0x101C8: add      sp, 8
  0x101CB: mov      word ptr [bp - 4], ax
  0x101CE: mov      word ptr [bp - 2], dx
  0x101D1: cmp      ax, word ptr [bp - 8]
  0x101D4: jne      0x101db
  0x101D6: cmp      dx, word ptr [bp - 6]
  0x101D9: je       0x101ed
  0x101DB: sub      ax, ax
  0x101DD: push     ax
  0x101DE: push     word ptr [bp - 6]
  0x101E1: push     word ptr [bp - 8]
  0x101E4: push     si
  0x101E5: lcall    0xd1d, 0x1e9a
  0x101EA: add      sp, 8
  0x101ED: mov      ax, word ptr [bp - 4]
  0x101F0: mov      dx, word ptr [bp - 2]
  0x101F3: pop      si
  0x101F4: mov      sp, bp
  0x101F6: pop      bp
  0x101F7: retf     

============================================================
func_L425 at file 0x10226, 42 bytes
============================================================
  0x10226: push     bp
  0x10227: mov      bp, sp
  0x10229: push     di
  0x1022A: mov      di, word ptr [bp + 6]
  0x1022D: push     ds
  0x1022E: pop      es
  0x1022F: mov      bx, di
  0x10231: xor      ax, ax
  0x10233: mov      cx, 0xffff
  0x10236: repne scasb al, byte ptr es:[di]
  0x10238: inc      cx
  0x10239: neg      cx
  0x1023B: mov      al, byte ptr [bp + 8]
  0x1023E: mov      di, bx
  0x10240: repne scasb al, byte ptr es:[di]
  0x10242: dec      di
  0x10243: cmp      byte ptr [di], al
  0x10245: je       0x10249
  0x10247: xor      di, di
  0x10249: mov      ax, di
  0x1024B: pop      di
  0x1024C: mov      sp, bp
  0x1024E: pop      bp
  0x1024F: retf     

============================================================
func_L426 at file 0x10250, 66 bytes
============================================================
  0x10250: push     bp
  0x10251: mov      bp, sp
  0x10253: mov      dx, si
  0x10255: mov      si, word ptr [bp + 8]
  0x10258: mov      bx, word ptr [bp + 6]
  0x1025B: mov      al, 0xff
  0x1025D: or       al, al
  0x1025F: je       0x1028d
  0x10261: lodsb    al, byte ptr [si]
  0x10262: mov      ah, byte ptr [bx]
  0x10264: inc      bx
  0x10265: cmp      ah, al
  0x10267: je       0x1025d
  0x10269: sub      al, 0x41
  0x1026B: cmp      al, 0x1a
  0x1026D: sbb      cl, cl
  0x1026F: and      cl, 0x20
  0x10272: add      al, cl
  0x10274: add      al, 0x41
  0x10276: xchg     al, ah
  0x10278: sub      al, 0x41
  0x1027A: cmp      al, 0x1a
  0x1027C: sbb      cl, cl
  0x1027E: and      cl, 0x20
  0x10281: add      al, cl
  0x10283: add      al, 0x41
  0x10285: cmp      al, ah
  0x10287: je       0x1025d
  0x10289: sbb      al, al
  0x1028B: sbb      al, 0xff
  0x1028D: cwde     
  0x1028E: mov      si, dx
  0x10290: pop      bp
  0x10291: retf     

============================================================
func_L427 at file 0x10292, 54 bytes
============================================================
  0x10292: push     bp
  0x10293: mov      bp, sp
  0x10295: push     di
  0x10296: push     si
  0x10297: mov      si, word ptr [bp + 6]
  0x1029A: mov      di, word ptr [bp + 8]
  0x1029D: push     ds
  0x1029E: pop      es
  0x1029F: mov      cx, word ptr [bp + 0xa]
  0x102A2: jcxz     0x102e1
  0x102A4: mov      bh, 0x41
  0x102A6: mov      bl, 0x5a
  0x102A8: mov      dh, 0x20
  0x102AA: mov      ah, byte ptr [si]
  0x102AC: mov      al, byte ptr [di]
  0x102AE: or       ah, ah
  0x102B0: je       0x102d2
  0x102B2: or       al, al
  0x102B4: je       0x102d2
  0x102B6: inc      si
  0x102B7: inc      di
  0x102B8: cmp      ah, bh
  0x102BA: jb       0x102c2
  0x102BC: cmp      ah, bl
  0x102BE: ja       0x102c2
  0x102C0: add      ah, dh
  0x102C2: cmp      al, bh
  0x102C4: jb       0x102cc
  0x102C6: cmp      al, bl

============================================================
func_L428 at file 0x102EA, 43 bytes
============================================================
  0x102EA: push     bp
  0x102EB: mov      bp, sp
  0x102ED: push     di
  0x102EE: push     ds
  0x102EF: pop      es
  0x102F0: mov      di, word ptr [bp + 6]
  0x102F3: xor      ax, ax
  0x102F5: mov      cx, 0xffff
  0x102F8: repne scasb al, byte ptr es:[di]
  0x102FA: inc      cx
  0x102FB: neg      cx
  0x102FD: dec      di
  0x102FE: mov      al, byte ptr [bp + 8]
  0x10301: std      
  0x10302: repne scasb al, byte ptr es:[di]
  0x10304: inc      di
  0x10305: cmp      byte ptr [di], al
  0x10307: je       0x1030d
  0x10309: xor      ax, ax
  0x1030B: jmp      0x1030f
  0x1030D: mov      ax, di
  0x1030F: cld      
  0x10310: pop      di
  0x10311: mov      sp, bp
  0x10313: pop      bp
  0x10314: retf     

============================================================
func_L429 at file 0x10316, 30 bytes
============================================================
  0x10316: push     bp
  0x10317: mov      bp, sp
  0x10319: mov      bx, word ptr [bp + 6]
  0x1031C: mov      dx, bx
  0x1031E: jmp      0x1032b
  0x10320: sub      al, 0x41
  0x10322: cmp      al, 0x1a
  0x10324: jae      0x1032a
  0x10326: add      al, 0x61
  0x10328: mov      byte ptr [bx], al
  0x1032A: inc      bx
  0x1032B: mov      al, byte ptr [bx]
  0x1032D: or       al, al
  0x1032F: jne      0x10320
  0x10331: xchg     dx, ax
  0x10332: pop      bp
  0x10333: retf     

============================================================
func_L430 at file 0x10334, 30 bytes
============================================================
  0x10334: push     bp
  0x10335: mov      bp, sp
  0x10337: mov      bx, word ptr [bp + 6]
  0x1033A: mov      dx, bx
  0x1033C: jmp      0x10349
  0x1033E: sub      al, 0x61
  0x10340: cmp      al, 0x1a
  0x10342: jae      0x10348
  0x10344: add      al, 0x41
  0x10346: mov      byte ptr [bx], al
  0x10348: inc      bx
  0x10349: mov      al, byte ptr [bx]
  0x1034B: or       al, al
  0x1034D: jne      0x1033e
  0x1034F: xchg     dx, ax
  0x10350: pop      bp
  0x10351: retf     

============================================================
func_L431 at file 0x10352, 44 bytes
============================================================
  0x10352: push     bp
  0x10353: mov      bp, sp
  0x10355: mov      dx, di
  0x10357: mov      bx, si
  0x10359: mov      ax, ds
  0x1035B: mov      es, ax
  0x1035D: mov      si, word ptr [bp + 8]
  0x10360: mov      di, word ptr [bp + 6]
  0x10363: mov      ax, di
  0x10365: mov      cx, word ptr [bp + 0xa]
  0x10368: jcxz     0x10378
  0x1036A: test     al, 1
  0x1036C: je       0x10370
  0x1036E: movsb    byte ptr es:[di], byte ptr [si]
  0x1036F: dec      cx
  0x10370: shr      cx, 1
  0x10372: rep movsw word ptr es:[di], word ptr [si]
  0x10374: adc      cx, cx
  0x10376: rep movsb byte ptr es:[di], byte ptr [si]
  0x10378: mov      si, bx
  0x1037A: mov      di, dx
  0x1037C: pop      bp
  0x1037D: retf     

============================================================
func_L432 at file 0x1037E, 45 bytes
============================================================
  0x1037E: push     bp
  0x1037F: mov      bp, sp
  0x10381: mov      dx, di
  0x10383: mov      ax, ds
  0x10385: mov      es, ax
  0x10387: mov      di, word ptr [bp + 6]
  0x1038A: mov      bx, di
  0x1038C: mov      cx, word ptr [bp + 0xa]
  0x1038F: jcxz     0x103a6
  0x10391: mov      al, byte ptr [bp + 8]
  0x10394: mov      ah, al
  0x10396: test     di, 1
  0x1039A: je       0x1039e
  0x1039C: stosb    byte ptr es:[di], al
  0x1039D: dec      cx
  0x1039E: shr      cx, 1
  0x103A0: rep stosw word ptr es:[di], ax
  0x103A2: adc      cx, cx
  0x103A4: rep stosb byte ptr es:[di], al
  0x103A6: mov      di, dx
  0x103A8: xchg     bx, ax
  0x103A9: pop      bp
  0x103AA: retf     

============================================================
func_L433 at file 0x103AC, 22 bytes
============================================================
  0x103AC: push     bp
  0x103AD: mov      bp, sp
  0x103AF: mov      ax, word ptr [bp + 6]
  0x103B2: mov      dx, word ptr [bp + 8]
  0x103B5: or       dx, dx
  0x103B7: jge      0x103c0
  0x103B9: neg      ax
  0x103BB: adc      dx, 0
  0x103BE: neg      dx
  0x103C0: pop      bp
  0x103C1: retf     

============================================================
func_L434 at file 0x103C2, 17 bytes
============================================================
  0x103C2: push     bp
  0x103C3: mov      bp, sp
  0x103C5: mov      ax, word ptr [bp + 6]
  0x103C8: mov      word ptr [0x28ee], ax
  0x103CB: mov      word ptr [0x28f0], 0
  0x103D1: pop      bp
  0x103D2: retf     

============================================================
func_L435 at file 0x103FC, 29 bytes
============================================================
  0x103FC: push     bp
  0x103FD: mov      bp, sp
  0x103FF: xor      ax, ax
  0x10401: lcall    0xd1d, 0x3d0
  0x10406: push     word ptr [0x27d3]
  0x1040A: push     word ptr [bp + 8]
  0x1040D: push     word ptr [bp + 6]
  0x10410: lcall    0xd1d, 0x2586
  0x10415: mov      sp, bp
  0x10417: pop      bp
  0x10418: retf     

============================================================
func_L436 at file 0x1041A, 14 bytes
============================================================
  0x1041A: push     bp
  0x1041B: mov      bp, sp
  0x1041D: mov      dx, word ptr [bp + 6]
  0x10420: mov      ah, 0x41
  0x10422: int      0x21
  0x10424: jmp      0x10ad0

============================================================
func_L437 at file 0x10428, 11 bytes
============================================================
  0x10428: push     bp
  0x10429: mov      bp, sp
  0x1042B: push     ds
  0x1042C: mov      al, 0x4f
  0x1042E: mov      dx, word ptr [bp + 6]
  0x10431: jmp      0x1043c

============================================================
func_L438 at file 0x10433, 51 bytes
============================================================
  0x10433: push     bp
  0x10434: mov      bp, sp
  0x10436: push     ds
  0x10437: mov      al, 0x4e
  0x10439: mov      dx, word ptr [bp + 0xa]
  0x1043C: mov      ah, 0x2f
  0x1043E: int      0x21
  0x10440: mov      ah, 0x1a
  0x10442: int      0x21
  0x10444: cmp      al, 0x4e
  0x10446: jne      0x1044e
  0x10448: mov      dx, word ptr [bp + 6]
  0x1044B: mov      cx, word ptr [bp + 8]
  0x1044E: mov      ah, al
  0x10450: int      0x21
  0x10452: push     ax
  0x10453: lahf     
  0x10454: push     ax
  0x10455: mov      dx, es
  0x10457: mov      ds, dx
  0x10459: mov      dx, bx
  0x1045B: mov      ah, 0x1a
  0x1045D: int      0x21
  0x1045F: pop      ax
  0x10460: sahf     
  0x10461: pop      ax
  0x10462: pop      ds
  0x10463: jmp      0x10ad8

============================================================
func_L439 at file 0x10466, 7 bytes
============================================================
  0x10466: push     bp
  0x10467: mov      bp, sp
  0x10469: mov      ah, 0x3f
  0x1046B: jmp      0x10472

============================================================
func_L440 at file 0x1046D, 41 bytes
============================================================
  0x1046D: push     bp
  0x1046E: mov      bp, sp
  0x10470: mov      ah, 0x40
  0x10472: mov      bx, word ptr [bp + 6]
  0x10475: mov      cx, word ptr [bp + 0xc]
  0x10478: cmp      word ptr [0x2b16], 0xd6d6
  0x1047E: jne      0x10484
  0x10480: call     word ptr [0x2b18]
  0x10484: push     ds
  0x10485: lds      dx, ptr [bp + 8]
  0x10488: int      0x21
  0x1048A: pop      ds
  0x1048B: jb       0x10492
  0x1048D: mov      bx, word ptr [bp + 0xe]
  0x10490: mov      word ptr [bx], ax
  0x10492: jmp      0x10ad8

============================================================
func_L441 at file 0x10496, 154 bytes
============================================================
  0x10496: push     bp
  0x10497: mov      bp, sp
  0x10499: push     di
  0x1049A: push     si
  0x1049B: push     bx
  0x1049C: xor      di, di
  0x1049E: mov      ax, word ptr [bp + 8]
  0x104A1: or       ax, ax
  0x104A3: jge      0x104b6
  0x104A5: inc      di
  0x104A6: mov      dx, word ptr [bp + 6]
  0x104A9: neg      ax
  0x104AB: neg      dx
  0x104AD: sbb      ax, 0
  0x104B0: mov      word ptr [bp + 8], ax
  0x104B3: mov      word ptr [bp + 6], dx
  0x104B6: mov      ax, word ptr [bp + 0xc]
  0x104B9: or       ax, ax
  0x104BB: jge      0x104ce
  0x104BD: inc      di
  0x104BE: mov      dx, word ptr [bp + 0xa]
  0x104C1: neg      ax
  0x104C3: neg      dx
  0x104C5: sbb      ax, 0
  0x104C8: mov      word ptr [bp + 0xc], ax
  0x104CB: mov      word ptr [bp + 0xa], dx
  0x104CE: or       ax, ax
  0x104D0: jne      0x104e7
  0x104D2: mov      cx, word ptr [bp + 0xa]
  0x104D5: mov      ax, word ptr [bp + 8]
  0x104D8: xor      dx, dx
  0x104DA: div      cx
  0x104DC: mov      bx, ax
  0x104DE: mov      ax, word ptr [bp + 6]
  0x104E1: div      cx
  0x104E3: mov      dx, bx
  0x104E5: jmp      0x1051f
  0x104E7: mov      bx, ax
  0x104E9: mov      cx, word ptr [bp + 0xa]
  0x104EC: mov      dx, word ptr [bp + 8]
  0x104EF: mov      ax, word ptr [bp + 6]
  0x104F2: shr      bx, 1
  0x104F4: rcr      cx, 1
  0x104F6: shr      dx, 1
  0x104F8: rcr      ax, 1
  0x104FA: or       bx, bx
  0x104FC: jne      0x104f2
  0x104FE: div      cx
  0x10500: mov      si, ax
  0x10502: mul      word ptr [bp + 0xc]
  0x10505: xchg     cx, ax
  0x10506: mov      ax, word ptr [bp + 0xa]
  0x10509: mul      si
  0x1050B: add      dx, cx
  0x1050D: jb       0x1051b
  0x1050F: cmp      dx, word ptr [bp + 8]
  0x10512: ja       0x1051b
  0x10514: jb       0x1051c
  0x10516: cmp      ax, word ptr [bp + 6]
  0x10519: jbe      0x1051c
  0x1051B: dec      si
  0x1051C: xor      dx, dx
  0x1051E: xchg     si, ax
  0x1051F: dec      di
  0x10520: jne      0x10529
  0x10522: neg      dx
  0x10524: neg      ax
  0x10526: sbb      dx, 0
  0x10529: pop      bx
  0x1052A: pop      si
  0x1052B: pop      di
  0x1052C: pop      bp
  0x1052D: retf     8

============================================================
func_L442 at file 0x10530, 50 bytes
============================================================
  0x10530: push     bp
  0x10531: mov      bp, sp
  0x10533: mov      ax, word ptr [bp + 8]
  0x10536: mov      cx, word ptr [bp + 0xc]
  0x10539: or       cx, ax
  0x1053B: mov      cx, word ptr [bp + 0xa]
  0x1053E: jne      0x10549
  0x10540: mov      ax, word ptr [bp + 6]
  0x10543: mul      cx
  0x10545: pop      bp
  0x10546: retf     8
  0x10549: push     bx
  0x1054A: mul      cx
  0x1054C: mov      bx, ax
  0x1054E: mov      ax, word ptr [bp + 6]
  0x10551: mul      word ptr [bp + 0xc]
  0x10554: add      bx, ax
  0x10556: mov      ax, word ptr [bp + 6]
  0x10559: mul      cx
  0x1055B: add      dx, bx
  0x1055D: pop      bx
  0x1055E: pop      bp
  0x1055F: retf     8

============================================================
func_L443 at file 0x10562, 32 bytes
============================================================
  0x10562: push     bp
  0x10563: mov      bp, sp
  0x10565: push     bx
  0x10566: mov      bx, word ptr [bp + 6]
  0x10569: push     word ptr [bp + 0xa]
  0x1056C: push     word ptr [bp + 8]
  0x1056F: push     word ptr [bx + 2]
  0x10572: push     word ptr [bx]
  0x10574: push     cs
  0x10575: call     0x10496
  0x10578: mov      word ptr [bx + 2], dx
  0x1057B: mov      word ptr [bx], ax
  0x1057D: pop      bx
  0x1057E: pop      bp
  0x1057F: retf     6

============================================================
func_L444 at file 0x10582, 30 bytes
============================================================
  0x10582: push     bp
  0x10583: mov      bp, sp
  0x10585: mov      cx, word ptr [bp + 0xe]
  0x10588: push     ds
  0x10589: push     di
  0x1058A: push     si
  0x1058B: jcxz     0x105d5
  0x1058D: lds      si, ptr [bp + 0xa]
  0x10590: les      di, ptr [bp + 6]
  0x10593: mov      ax, cx
  0x10595: dec      ax
  0x10596: mov      dx, di
  0x10598: not      dx
  0x1059A: sub      ax, dx
  0x1059C: sbb      bx, bx
  0x1059E: and      ax, bx

============================================================
func_L445 at file 0x105E0, 45 bytes
============================================================
  0x105E0: push     bp
  0x105E1: mov      bp, sp
  0x105E3: push     di
  0x105E4: les      di, ptr [bp + 6]
  0x105E7: mov      bx, di
  0x105E9: xor      ax, ax
  0x105EB: mov      cx, 0xffff
  0x105EE: repne scasb al, byte ptr es:[di]
  0x105F0: inc      cx
  0x105F1: neg      cx
  0x105F3: mov      al, byte ptr [bp + 0xa]
  0x105F6: mov      di, bx
  0x105F8: repne scasb al, byte ptr es:[di]
  0x105FA: dec      di
  0x105FB: cmp      byte ptr es:[di], al
  0x105FE: je       0x10604
  0x10600: xor      di, di
  0x10602: mov      es, di
  0x10604: mov      ax, di
  0x10606: mov      dx, es
  0x10608: pop      di
  0x10609: mov      sp, bp
  0x1060B: pop      bp
  0x1060C: retf     

============================================================
func_L446 at file 0x1060E, 69 bytes
============================================================
  0x1060E: push     bp
  0x1060F: mov      bp, sp
  0x10611: mov      dx, si
  0x10613: push     ds
  0x10614: lds      si, ptr [bp + 0xa]
  0x10617: les      bx, ptr [bp + 6]
  0x1061A: mov      al, 0xff
  0x1061C: or       al, al
  0x1061E: je       0x1064d
  0x10620: lodsb    al, byte ptr [si]
  0x10621: mov      ah, byte ptr es:[bx]
  0x10624: inc      bx
  0x10625: cmp      ah, al
  0x10627: je       0x1061c
  0x10629: sub      al, 0x41
  0x1062B: cmp      al, 0x1a
  0x1062D: sbb      cl, cl
  0x1062F: and      cl, 0x20
  0x10632: add      al, cl
  0x10634: add      al, 0x41
  0x10636: xchg     al, ah
  0x10638: sub      al, 0x41
  0x1063A: cmp      al, 0x1a
  0x1063C: sbb      cl, cl
  0x1063E: and      cl, 0x20
  0x10641: add      al, cl
  0x10643: add      al, 0x41
  0x10645: cmp      al, ah
  0x10647: je       0x1061c
  0x10649: sbb      al, al
  0x1064B: sbb      al, 0xff
  0x1064D: cwde     
  0x1064E: pop      ds
  0x1064F: mov      si, dx
  0x10651: pop      bp
  0x10652: retf     

============================================================
func_L447 at file 0x10654, 26 bytes
============================================================
  0x10654: push     bp
  0x10655: mov      bp, sp
  0x10657: push     di
  0x10658: push     si
  0x10659: push     ds
  0x1065A: mov      cx, word ptr [bp + 0xe]
  0x1065D: jcxz     0x10686
  0x1065F: mov      bx, cx
  0x10661: les      di, ptr [bp + 6]
  0x10664: mov      si, di
  0x10666: xor      ax, ax
  0x10668: repne scasb al, byte ptr es:[di]
  0x1066A: neg      cx
  0x1066C: add      cx, bx

============================================================
func_L448 at file 0x10690, 33 bytes
============================================================
  0x10690: push     bp
  0x10691: mov      bp, sp
  0x10693: push     di
  0x10694: push     si
  0x10695: push     ds
  0x10696: les      di, ptr [bp + 6]
  0x10699: lds      si, ptr [bp + 0xa]
  0x1069C: mov      bx, di
  0x1069E: mov      cx, word ptr [bp + 0xe]
  0x106A1: jcxz     0x106af
  0x106A3: lodsb    al, byte ptr [si]
  0x106A4: or       al, al
  0x106A6: je       0x106ab
  0x106A8: stosb    byte ptr es:[di], al
  0x106A9: loop     0x106a3
  0x106AB: xor      al, al
  0x106AD: rep stosb byte ptr es:[di], al
  0x106AF: mov      ax, bx

============================================================
func_L449 at file 0x106BA, 46 bytes
============================================================
  0x106BA: push     bp
  0x106BB: mov      bp, sp
  0x106BD: push     di
  0x106BE: les      di, ptr [bp + 6]
  0x106C1: xor      ax, ax
  0x106C3: mov      cx, 0xffff
  0x106C6: repne scasb al, byte ptr es:[di]
  0x106C8: inc      cx
  0x106C9: neg      cx
  0x106CB: dec      di
  0x106CC: mov      al, byte ptr [bp + 0xa]
  0x106CF: std      
  0x106D0: repne scasb al, byte ptr es:[di]
  0x106D2: inc      di
  0x106D3: cmp      byte ptr es:[di], al
  0x106D6: je       0x106de
  0x106D8: xor      ax, ax
  0x106DA: mov      dx, ax
  0x106DC: jmp      0x106e2
  0x106DE: mov      ax, di
  0x106E0: mov      dx, es
  0x106E2: cld      
  0x106E3: pop      di
  0x106E4: mov      sp, bp
  0x106E6: pop      bp
  0x106E7: retf     

============================================================
func_L450 at file 0x106E8, 36 bytes
============================================================
  0x106E8: push     bp
  0x106E9: mov      bp, sp
  0x106EB: mov      cx, ds
  0x106ED: lds      bx, ptr [bp + 6]
  0x106F0: mov      dx, bx
  0x106F2: jmp      0x106ff
  0x106F4: sub      al, 0x61
  0x106F6: cmp      al, 0x1a
  0x106F8: jae      0x106fe
  0x106FA: add      al, 0x41
  0x106FC: mov      byte ptr [bx], al
  0x106FE: inc      bx
  0x106FF: mov      al, byte ptr [bx]
  0x10701: or       al, al
  0x10703: jne      0x106f4
  0x10705: xchg     dx, ax
  0x10706: mov      dx, ds
  0x10708: mov      ds, cx
  0x1070A: pop      bp
  0x1070B: retf     

============================================================
func_L451 at file 0x1070C, 23 bytes
============================================================
  0x1070C: push     bp
  0x1070D: mov      bp, sp
  0x1070F: mov      dx, di
  0x10711: les      di, ptr [bp + 6]
  0x10714: xor      ax, ax
  0x10716: mov      cx, 0xffff
  0x10719: repne scasb al, byte ptr es:[di]
  0x1071B: not      cx
  0x1071D: dec      cx
  0x1071E: xchg     cx, ax
  0x1071F: mov      di, dx
  0x10721: pop      bp
  0x10722: retf     

============================================================
func_L452 at file 0x10724, 41 bytes
============================================================
  0x10724: push     bp
  0x10725: mov      bp, sp
  0x10727: mov      dx, di
  0x10729: mov      bx, si
  0x1072B: push     ds
  0x1072C: lds      si, ptr [bp + 6]
  0x1072F: les      di, ptr [bp + 0xa]
  0x10732: xor      ax, ax
  0x10734: mov      cx, 0xffff
  0x10737: repne scasb al, byte ptr es:[di]
  0x10739: not      cx
  0x1073B: sub      di, cx
  0x1073D: repe cmpsb byte ptr [si], byte ptr es:[di]
  0x1073F: je       0x10746
  0x10741: sbb      ax, ax
  0x10743: sbb      ax, 0xffff
  0x10746: pop      ds
  0x10747: mov      si, bx
  0x10749: mov      di, dx
  0x1074B: pop      bp
  0x1074C: retf     

============================================================
func_L453 at file 0x1074E, 54 bytes
============================================================
  0x1074E: push     bp
  0x1074F: mov      bp, sp
  0x10751: mov      dx, di
  0x10753: mov      bx, si
  0x10755: push     ds
  0x10756: lds      si, ptr [bp + 0xa]
  0x10759: mov      di, si
  0x1075B: mov      ax, ds
  0x1075D: mov      es, ax
  0x1075F: xor      ax, ax
  0x10761: mov      cx, 0xffff
  0x10764: repne scasb al, byte ptr es:[di]
  0x10766: not      cx
  0x10768: les      di, ptr [bp + 6]
  0x1076B: mov      ax, di
  0x1076D: test     al, 1
  0x1076F: je       0x10773
  0x10771: movsb    byte ptr es:[di], byte ptr [si]
  0x10772: dec      cx
  0x10773: shr      cx, 1
  0x10775: rep movsw word ptr es:[di], word ptr [si]
  0x10777: adc      cx, cx
  0x10779: rep movsb byte ptr es:[di], byte ptr [si]
  0x1077B: mov      si, bx
  0x1077D: mov      di, dx
  0x1077F: pop      ds
  0x10780: mov      dx, es
  0x10782: pop      bp
  0x10783: retf     

============================================================
func_L454 at file 0x10784, 70 bytes
============================================================
  0x10784: push     bp
  0x10785: mov      bp, sp
  0x10787: mov      dx, di
  0x10789: mov      bx, si
  0x1078B: push     ds
  0x1078C: les      di, ptr [bp + 6]
  0x1078F: xor      ax, ax
  0x10791: mov      cx, 0xffff
  0x10794: repne scasb al, byte ptr es:[di]
  0x10796: lea      si, [di - 1]
  0x10799: les      di, ptr [bp + 0xa]
  0x1079C: mov      cx, 0xffff
  0x1079F: repne scasb al, byte ptr es:[di]
  0x107A1: not      cx
  0x107A3: sub      di, cx
  0x107A5: mov      ax, es
  0x107A7: mov      ds, ax
  0x107A9: mov      es, word ptr [bp + 8]
  0x107AC: xchg     si, di
  0x107AE: mov      ax, word ptr [bp + 6]
  0x107B1: test     si, 1
  0x107B5: je       0x107b9
  0x107B7: movsb    byte ptr es:[di], byte ptr [si]
  0x107B8: dec      cx
  0x107B9: shr      cx, 1
  0x107BB: rep movsw word ptr es:[di], word ptr [si]
  0x107BD: adc      cx, cx
  0x107BF: rep movsb byte ptr es:[di], byte ptr [si]
  0x107C1: mov      si, bx
  0x107C3: mov      di, dx
  0x107C5: pop      ds
  0x107C6: mov      dx, es
  0x107C8: pop      bp
  0x107C9: retf     

============================================================
func_L455 at file 0x107CA, 49 bytes
============================================================
  0x107CA: push     bp
  0x107CB: mov      bp, sp
  0x107CD: mov      cx, word ptr [bp + 0xc]
  0x107D0: jcxz     0x1080a
  0x107D2: push     di
  0x107D3: les      di, ptr [bp + 6]
  0x107D6: mov      dx, di
  0x107D8: neg      dx
  0x107DA: je       0x107e8
  0x107DC: sub      dx, cx
  0x107DE: sbb      bx, bx
  0x107E0: and      dx, bx
  0x107E2: add      dx, cx
  0x107E4: xchg     cx, dx
  0x107E6: sub      dx, cx
  0x107E8: mov      ax, word ptr [bp + 0xa]
  0x107EB: mov      ah, al
  0x107ED: shr      cx, 1
  0x107EF: rep stosw word ptr es:[di], ax
  0x107F1: adc      cx, cx
  0x107F3: rep stosb byte ptr es:[di], al
  0x107F5: xchg     cx, dx
  0x107F7: jcxz     0x10809
  0x107F9: mov      bx, es

============================================================
func_L456 at file 0x10812, 34 bytes
============================================================
  0x10812: push     bp
  0x10813: mov      bp, sp
  0x10815: mov      ax, 0xfc
  0x10818: push     ax
  0x10819: push     cs
  0x1081A: call     0x10a99
  0x1081D: cmp      word ptr [0x28f4], 0
  0x10822: je       0x10828
  0x10824: lcall    [0x28f2]
  0x10828: mov      ax, 0xff
  0x1082B: push     ax
  0x1082C: push     cs
  0x1082D: call     0x10a99
  0x10830: mov      sp, bp
  0x10832: pop      bp
  0x10833: retf     

============================================================
func_L457 at file 0x109F0, 15 bytes
============================================================
  0x109F0: push     bp
  0x109F1: mov      bp, sp
  0x109F3: push     ds
  0x109F4: mov      es, word ptr [0x27b2]
  0x109F8: mov      bx, word ptr es:[0x2c]
  0x109FD: mov      es, bx

============================================================
func_L458 at file 0x10A6E, 43 bytes
============================================================
  0x10A6E: push     bp
  0x10A6F: mov      bp, sp
  0x10A71: push     si
  0x10A72: push     di
  0x10A73: push     ds
  0x10A74: pop      es
  0x10A75: mov      dx, word ptr [bp + 6]
  0x10A78: mov      si, 0x2b42
  0x10A7B: lodsw    ax, word ptr [si]
  0x10A7C: cmp      ax, dx
  0x10A7E: je       0x10a90
  0x10A80: inc      ax
  0x10A81: xchg     si, ax
  0x10A82: je       0x10a90
  0x10A84: xchg     di, ax
  0x10A85: xor      ax, ax
  0x10A87: mov      cx, 0xffff
  0x10A8A: repne scasb al, byte ptr es:[di]
  0x10A8C: mov      si, di
  0x10A8E: jmp      0x10a7b
  0x10A90: xchg     si, ax
  0x10A91: pop      di
  0x10A92: pop      si
  0x10A93: mov      sp, bp
  0x10A95: pop      bp
  0x10A96: retf     2

============================================================
func_L459 at file 0x10A99, 63 bytes
============================================================
  0x10A99: push     bp
  0x10A9A: mov      bp, sp
  0x10A9C: push     di
  0x10A9D: push     word ptr [bp + 6]
  0x10AA0: push     cs
  0x10AA1: call     0x10a6e
  0x10AA4: or       ax, ax
  0x10AA6: je       0x10ac8
  0x10AA8: xchg     dx, ax
  0x10AA9: mov      di, dx
  0x10AAB: xor      ax, ax
  0x10AAD: mov      cx, 0xffff
  0x10AB0: repne scasb al, byte ptr es:[di]
  0x10AB2: not      cx
  0x10AB4: dec      cx
  0x10AB5: mov      bx, 2
  0x10AB8: cmp      word ptr [0x2b16], 0xd6d6
  0x10ABE: jne      0x10ac4
  0x10AC0: call     word ptr [0x2b18]
  0x10AC4: mov      ah, 0x40
  0x10AC6: int      0x21
  0x10AC8: pop      di
  0x10AC9: mov      sp, bp
  0x10ACB: pop      bp
  0x10ACC: retf     2
  0x10ACF: add      byte ptr [bp + si + 0x15], dh
  0x10AD2: xor      ax, ax
  0x10AD4: mov      sp, bp
  0x10AD6: pop      bp
  0x10AD7: retf     

============================================================
func_L460 at file 0x10B26, 149 bytes
============================================================
  0x10B26: push     bp
  0x10B27: mov      bp, sp
  0x10B29: push     si
  0x10B2A: push     di
  0x10B2B: mov      si, word ptr [bp + 6]
  0x10B2E: mov      al, byte ptr [si + 6]
  0x10B31: test     al, 0x83
  0x10B33: je       0x10b8e
  0x10B35: test     al, 0x40
  0x10B37: jne      0x10b8e
  0x10B39: test     al, 2
  0x10B3B: jne      0x10b7f
  0x10B3D: or       al, 1
  0x10B3F: mov      byte ptr [si + 6], al
  0x10B42: mov      di, si
  0x10B44: sub      di, 0x290e
  0x10B48: add      di, 0x29ae
  0x10B4C: test     al, 0xc
  0x10B4E: jne      0x10b5a
  0x10B50: test     byte ptr [di], 1
  0x10B53: jne      0x10b5a
  0x10B55: push     si
  0x10B56: call     0x11cd2
  0x10B59: pop      ax
  0x10B5A: mov      ax, word ptr [si + 4]
  0x10B5D: mov      word ptr [si], ax
  0x10B5F: push     word ptr [di + 2]
  0x10B62: push     ax
  0x10B63: xor      bx, bx
  0x10B65: mov      bl, byte ptr [si + 7]
  0x10B68: push     bx
  0x10B69: push     cs
  0x10B6A: call     0x114e4
  0x10B6D: add      sp, 6
  0x10B70: or       ax, ax
  0x10B72: je       0x10b85
  0x10B74: cmp      ax, 0xffff
  0x10B77: jne      0x10b93
  0x10B79: or       byte ptr [si + 6], 0x20
  0x10B7D: jmp      0x10b89
  0x10B7F: or       byte ptr [si + 6], 0x20
  0x10B83: jmp      0x10b8e
  0x10B85: or       byte ptr [si + 6], 0x10
  0x10B89: mov      word ptr [si + 2], 0
  0x10B8E: mov      ax, 0xffff
  0x10B91: jmp      0x10bb7
  0x10B93: mov      bh, byte ptr [bx + 0x27bb]
  0x10B97: and      bh, 0x82
  0x10B9A: cmp      bh, 0x82
  0x10B9D: jne      0x10baa
  0x10B9F: mov      bh, byte ptr [si + 6]
  0x10BA2: test     bh, 0x82
  0x10BA5: jne      0x10baa
  0x10BA7: or       byte ptr [di], 0x20
  0x10BAA: dec      ax
  0x10BAB: mov      word ptr [si + 2], ax
  0x10BAE: mov      bx, word ptr [si]
  0x10BB0: xor      ax, ax
  0x10BB2: mov      al, byte ptr [bx]
  0x10BB4: inc      bx
  0x10BB5: mov      word ptr [si], bx
  0x10BB7: pop      di
  0x10BB8: pop      si
  0x10BB9: pop      bp
  0x10BBA: retf     

============================================================
func_L461 at file 0x10BBC, 227 bytes
============================================================
  0x10BBC: push     bp
  0x10BBD: mov      bp, sp
  0x10BBF: push     si
  0x10BC0: push     di
  0x10BC1: mov      si, word ptr [bp + 8]
  0x10BC4: mov      al, byte ptr [si + 6]
  0x10BC7: test     al, 0x82
  0x10BC9: je       0x10c34
  0x10BCB: test     al, 0x40
  0x10BCD: jne      0x10c34
  0x10BCF: mov      word ptr [si + 2], 0
  0x10BD4: test     al, 1
  0x10BD6: je       0x10be3
  0x10BD8: test     al, 0x10
  0x10BDA: je       0x10c34
  0x10BDC: mov      cx, word ptr [si + 4]
  0x10BDF: mov      word ptr [si], cx
  0x10BE1: and      al, 0xfe
  0x10BE3: or       al, 2
  0x10BE5: and      al, 0xef
  0x10BE7: mov      byte ptr [si + 6], al
  0x10BEA: mov      di, si
  0x10BEC: sub      di, 0x290e
  0x10BF0: add      di, 0x29ae
  0x10BF4: xor      bx, bx
  0x10BF6: mov      bl, byte ptr [si + 7]
  0x10BF9: test     al, 8
  0x10BFB: jne      0x10c4a
  0x10BFD: test     al, 4
  0x10BFF: jne      0x10c1f
  0x10C01: test     byte ptr [di], 1
  0x10C04: jne      0x10c4a
  0x10C06: cmp      si, 0x2916
  0x10C0A: je       0x10c18
  0x10C0C: cmp      si, 0x291e
  0x10C10: je       0x10c18
  0x10C12: cmp      si, 0x292e
  0x10C16: jne      0x10c3d
  0x10C18: test     byte ptr [bx + 0x27bb], 0x40
  0x10C1D: je       0x10c3d
  0x10C1F: mov      cx, 1
  0x10C22: push     cx
  0x10C23: lea      di, [bp + 6]
  0x10C26: push     di
  0x10C27: push     bx
  0x10C28: push     cs
  0x10C29: call     0x115ce
  0x10C2C: add      sp, 6
  0x10C2F: mov      cx, 1
  0x10C32: jmp      0x10c73
  0x10C34: mov      ax, 0xffff
  0x10C37: or       byte ptr [si + 6], 0x20
  0x10C3B: jmp      0x10c9b
  0x10C3D: push     bx
  0x10C3E: push     si
  0x10C3F: call     0x11cd2
  0x10C42: pop      bx
  0x10C43: pop      bx
  0x10C44: test     byte ptr [si + 6], 8
  0x10C48: je       0x10c1f
  0x10C4A: mov      cx, word ptr [si]
  0x10C4C: mov      dx, word ptr [si + 4]
  0x10C4F: sub      cx, dx
  0x10C51: inc      dx
  0x10C52: mov      word ptr [si], dx
  0x10C54: mov      dx, word ptr [di + 2]
  0x10C57: dec      dx
  0x10C58: mov      word ptr [si + 2], dx
  0x10C5B: jcxz     0x10c7e
  0x10C5D: push     cx
  0x10C5E: push     cx
  0x10C5F: push     word ptr [si + 4]
  0x10C62: push     bx
  0x10C63: push     cs
  0x10C64: call     0x115ce
  0x10C67: add      sp, 6
  0x10C6A: pop      cx
  0x10C6B: mov      di, word ptr [si + 4]
  0x10C6E: mov      dx, word ptr [bp + 6]
  0x10C71: mov      byte ptr [di], dl
  0x10C73: cmp      ax, cx
  0x10C75: jne      0x10c34
  0x10C77: xor      ax, ax
  0x10C79: mov      al, byte ptr [bp + 6]
  0x10C7C: jmp      0x10c9b
  0x10C7E: xor      ax, ax
  0x10C80: test     byte ptr [bx + 0x27bb], 0x20
  0x10C85: je       0x10c6b
  0x10C87: mov      cx, 2
  0x10C8A: push     cx
  0x10C8B: push     ax
  0x10C8C: push     ax
  0x10C8D: push     bx
  0x10C8E: push     cs
  0x10C8F: call     0x1146a
  0x10C92: add      sp, 8
  0x10C95: xor      ax, ax
  0x10C97: mov      cx, ax
  0x10C99: jmp      0x10c6b
  0x10C9B: pop      di
  0x10C9C: pop      si
  0x10C9D: pop      bp
  0x10C9E: retf     

============================================================
func_L462 at file 0x10CA0, 44 bytes
============================================================
  0x10CA0: push     bp
  0x10CA1: mov      bp, sp
  0x10CA3: push     si
  0x10CA4: mov      si, word ptr [bp + 4]
  0x10CA7: mov      al, byte ptr [si + 6]
  0x10CAA: test     al, 0x83
  0x10CAC: je       0x10cc9
  0x10CAE: test     al, 8
  0x10CB0: je       0x10cc9
  0x10CB2: push     word ptr [si + 4]
  0x10CB5: lcall    0xd1d, 0x291c
  0x10CBA: pop      cx
  0x10CBB: and      byte ptr [si + 6], 0xf7
  0x10CBF: xor      ax, ax
  0x10CC1: mov      word ptr [si + 4], ax
  0x10CC4: mov      word ptr [si], ax
  0x10CC6: mov      word ptr [si + 2], ax
  0x10CC9: pop      si
  0x10CCA: pop      bp
  0x10CCB: ret      

============================================================
func_L463 at file 0x10CCC, 232 bytes
============================================================
  0x10CCC: push     bp
  0x10CCD: mov      bp, sp
  0x10CCF: sub      sp, 8
  0x10CD2: push     di
  0x10CD3: push     si
  0x10CD4: mov      bx, word ptr [bp + 8]
  0x10CD7: mov      al, byte ptr [bx]
  0x10CD9: cwde     
  0x10CDA: cmp      ax, 0x77
  0x10CDD: je       0x10d24
  0x10CDF: ja       0x10ce9
  0x10CE1: sub      al, 0x61
  0x10CE3: je       0x10d2e
  0x10CE5: sub      al, 0x11
  0x10CE7: je       0x10cee
  0x10CE9: sub      ax, ax
  0x10CEB: jmp      0x10dae
  0x10CEE: sub      si, si
  0x10CF0: mov      byte ptr [bp - 4], 1
  0x10CF4: mov      word ptr [bp - 2], 1
  0x10CF9: inc      word ptr [bp + 8]
  0x10CFC: mov      bx, word ptr [bp + 8]
  0x10CFF: cmp      byte ptr [bx], 0
  0x10D02: je       0x10d5e
  0x10D04: cmp      word ptr [bp - 2], 0
  0x10D08: je       0x10d5e
  0x10D0A: mov      al, byte ptr [bx]
  0x10D0C: cwde     
  0x10D0D: cmp      ax, 0x74
  0x10D10: je       0x10d46
  0x10D12: ja       0x10d1c
  0x10D14: sub      al, 0x2b
  0x10D16: je       0x10d34
  0x10D18: sub      al, 0x37
  0x10D1A: je       0x10d52
  0x10D1C: mov      word ptr [bp - 2], 0
  0x10D21: jmp      0x10cf9
  0x10D23: nop      
  0x10D24: mov      si, 0x301
  0x10D27: mov      byte ptr [bp - 4], 2
  0x10D2B: jmp      0x10cf4
  0x10D2D: nop      
  0x10D2E: mov      si, 0x109
  0x10D31: jmp      0x10d27
  0x10D33: nop      
  0x10D34: test     si, 2
  0x10D38: jne      0x10d1c
  0x10D3A: or       si, 2
  0x10D3D: and      si, 0xfffe
  0x10D40: mov      byte ptr [bp - 4], 0x80
  0x10D44: jmp      0x10cf9
  0x10D46: test     si, 0xc000
  0x10D4A: jne      0x10d1c
  0x10D4C: or       si, 0x4000
  0x10D50: jmp      0x10cf9
  0x10D52: test     si, 0xc000
  0x10D56: jne      0x10d1c
  0x10D58: or       si, 0x8000
  0x10D5C: jmp      0x10cf9
  0x10D5E: mov      ax, 0x1a4
  0x10D61: push     ax
  0x10D62: push     word ptr [bp + 0xa]
  0x10D65: push     si
  0x10D66: push     word ptr [bp + 6]
  0x10D69: lcall    0xd1d, 0x2746
  0x10D6E: add      sp, 8
  0x10D71: mov      word ptr [bp - 6], ax
  0x10D74: or       ax, ax
  0x10D76: jge      0x10d7b
  0x10D78: jmp      0x10ce9
  0x10D7B: inc      word ptr [0x2ac2]
  0x10D7F: mov      di, word ptr [bp + 0xc]
  0x10D82: mov      ax, di
  0x10D84: sub      ax, 0x290e
  0x10D87: add      ax, 0x29ae
  0x10D8A: mov      word ptr [bp - 8], ax
  0x10D8D: mov      al, byte ptr [bp - 4]
  0x10D90: mov      byte ptr [di + 6], al
  0x10D93: mov      bx, word ptr [bp - 8]
  0x10D96: mov      byte ptr [bx], 0
  0x10D99: sub      ax, ax
  0x10D9B: mov      word ptr [di + 2], ax
  0x10D9E: mov      word ptr [bx + 4], ax
  0x10DA1: mov      word ptr [di], ax
  0x10DA3: mov      word ptr [di + 4], ax
  0x10DA6: mov      al, byte ptr [bp - 6]
  0x10DA9: mov      byte ptr [di + 7], al
  0x10DAC: mov      ax, di
  0x10DAE: pop      si
  0x10DAF: pop      di
  0x10DB0: mov      sp, bp
  0x10DB2: pop      bp
  0x10DB3: retf     

============================================================
func_L464 at file 0x10DB4, 115 bytes
============================================================
  0x10DB4: push     bp
  0x10DB5: mov      bp, sp
  0x10DB7: push     si
  0x10DB8: push     di
  0x10DB9: mov      si, word ptr [bp + 4]
  0x10DBC: mov      bx, 0x2a50
  0x10DBF: cmp      si, 0x2916
  0x10DC3: je       0x10dd7
  0x10DC5: mov      bx, 0x2a52
  0x10DC8: cmp      si, 0x291e
  0x10DCC: je       0x10dd7
  0x10DCE: mov      bx, 0x2a54
  0x10DD1: cmp      si, 0x292e
  0x10DD5: jne      0x10e21
  0x10DD7: mov      di, si
  0x10DD9: sub      di, 0x290e
  0x10DDD: add      di, 0x29ae
  0x10DE1: test     byte ptr [si + 6], 0xc
  0x10DE5: jne      0x10e21
  0x10DE7: test     byte ptr [di], 1
  0x10DEA: jne      0x10e21
  0x10DEC: mov      ax, word ptr [bx]
  0x10DEE: or       ax, ax
  0x10DF0: je       0x10e0d
  0x10DF2: mov      word ptr [si + 4], ax
  0x10DF5: mov      word ptr [si], ax
  0x10DF7: mov      word ptr [si + 2], 0x200
  0x10DFC: mov      word ptr [di + 2], 0x200
  0x10E01: or       byte ptr [si + 6], 2
  0x10E05: mov      byte ptr [di], 0x11
  0x10E08: mov      ax, 1
  0x10E0B: jmp      0x10e23
  0x10E0D: push     bx
  0x10E0E: mov      ax, 0x200
  0x10E11: push     ax
  0x10E12: lcall    0xd1d, 0x2916
  0x10E17: pop      bx
  0x10E18: pop      bx
  0x10E19: or       ax, ax
  0x10E1B: je       0x10e21
  0x10E1D: mov      word ptr [bx], ax
  0x10E1F: jmp      0x10df2
  0x10E21: xor      ax, ax
  0x10E23: pop      di
  0x10E24: pop      si
  0x10E25: pop      bp
  0x10E26: ret      

============================================================
func_L465 at file 0x10E27, 63 bytes
============================================================
  0x10E27: push     bp
  0x10E28: mov      bp, sp
  0x10E2A: push     si
  0x10E2B: push     di
  0x10E2C: mov      si, word ptr [bp + 6]
  0x10E2F: mov      di, si
  0x10E31: sub      di, 0x290e
  0x10E35: add      di, 0x29ae
  0x10E39: test     byte ptr [di], 0x10
  0x10E3C: je       0x10e62
  0x10E3E: xor      bx, bx
  0x10E40: mov      bl, byte ptr [si + 7]
  0x10E43: test     byte ptr [bx + 0x27bb], 0x40
  0x10E48: je       0x10e62
  0x10E4A: push     si
  0x10E4B: push     cs
  0x10E4C: call     0x10e66
  0x10E4F: pop      ax
  0x10E50: cmp      word ptr [bp + 4], 0
  0x10E54: je       0x10e62
  0x10E56: xor      ax, ax
  0x10E58: mov      byte ptr [di], al
  0x10E5A: mov      word ptr [di + 2], ax
  0x10E5D: mov      word ptr [si], ax
  0x10E5F: mov      word ptr [si + 4], ax
  0x10E62: pop      di
  0x10E63: pop      si
  0x10E64: pop      bp
  0x10E65: ret      

============================================================
func_L466 at file 0x10E66, 116 bytes
============================================================
  0x10E66: push     bp
  0x10E67: mov      bp, sp
  0x10E69: sub      sp, 2
  0x10E6C: push     di
  0x10E6D: push     si
  0x10E6E: sub      di, di
  0x10E70: cmp      word ptr [bp + 6], di
  0x10E73: jne      0x10e7e
  0x10E75: sub      ax, ax
  0x10E77: push     ax
  0x10E78: call     0x10ee2
  0x10E7B: jmp      0x10ed4
  0x10E7D: nop      
  0x10E7E: mov      si, word ptr [bp + 6]
  0x10E81: mov      al, byte ptr [si + 6]
  0x10E84: mov      cx, ax
  0x10E86: and      al, 3
  0x10E88: cmp      al, 2
  0x10E8A: jne      0x10ec8
  0x10E8C: test     cl, 8
  0x10E8F: jne      0x10e9e
  0x10E91: mov      bx, si
  0x10E93: sub      bx, 0x290e
  0x10E97: test     byte ptr [bx + 0x29ae], 1
  0x10E9C: je       0x10ec8
  0x10E9E: mov      ax, word ptr [si]
  0x10EA0: sub      ax, word ptr [si + 4]
  0x10EA3: mov      word ptr [bp - 2], ax
  0x10EA6: or       ax, ax
  0x10EA8: jle      0x10ec8
  0x10EAA: push     ax
  0x10EAB: push     word ptr [si + 4]
  0x10EAE: mov      cl, byte ptr [si + 7]
  0x10EB1: sub      ch, ch
  0x10EB3: push     cx
  0x10EB4: lcall    0xd1d, 0x1ffe
  0x10EB9: add      sp, 6
  0x10EBC: cmp      word ptr [bp - 2], ax
  0x10EBF: je       0x10ec8
  0x10EC1: or       byte ptr [si + 6], 0x20
  0x10EC5: mov      di, 0xffff
  0x10EC8: mov      ax, word ptr [si + 4]
  0x10ECB: mov      word ptr [si], ax
  0x10ECD: mov      word ptr [si + 2], 0
  0x10ED2: mov      ax, di
  0x10ED4: pop      si
  0x10ED5: pop      di
  0x10ED6: mov      sp, bp
  0x10ED8: pop      bp
  0x10ED9: retf     

============================================================
func_L467 at file 0x10EE2, 92 bytes
============================================================
  0x10EE2: push     bp
  0x10EE3: mov      bp, sp
  0x10EE5: sub      sp, 2
  0x10EE8: push     di
  0x10EE9: push     si
  0x10EEA: mov      si, 0x290e
  0x10EED: sub      di, di
  0x10EEF: mov      word ptr [bp - 2], di
  0x10EF2: jmp      0x10efc
  0x10EF4: mov      word ptr [bp - 2], 0xffff
  0x10EF9: add      si, 8
  0x10EFC: cmp      word ptr [0x2a4e], si
  0x10F00: jb       0x10f18
  0x10F02: test     byte ptr [si + 6], 0x83
  0x10F06: je       0x10ef9
  0x10F08: push     si
  0x10F09: lcall    0xd1d, 0x1896
  0x10F0E: add      sp, 2
  0x10F11: inc      ax
  0x10F12: je       0x10ef4
  0x10F14: inc      di
  0x10F15: jmp      0x10ef9
  0x10F17: nop      
  0x10F18: cmp      word ptr [bp + 4], 1
  0x10F1C: jne      0x10f22
  0x10F1E: mov      ax, di
  0x10F20: jmp      0x10f25
  0x10F22: mov      ax, word ptr [bp - 2]
  0x10F25: pop      si
  0x10F26: pop      di
  0x10F27: mov      sp, bp
  0x10F29: pop      bp
  0x10F2A: ret      2
  0x10F2D: nop      
  0x10F2E: lds      bx, ptr [bx + di]
  0x10F30: rcr      byte ptr [bx + di], 1
  0x10F32: in       al, 0x19
  0x10F34: sbb      byte ptr [bp + si], bl
  0x10F36: inc      sp
  0x10F37: sbb      cl, byte ptr [si + 0x1a]
  0x10F3A: jne      0x10f56
  0x10F3C: cmpsw    word ptr [si], word ptr es:[di]

============================================================
func_L468 at file 0x10F3E, 1043 bytes
============================================================
  0x10F3E: push     bp
  0x10F3F: mov      bp, sp
  0x10F41: mov      ax, 0x171
  0x10F44: push     cs
  0x10F45: call     0xf9a0
  0x10F48: push     si
  0x10F49: push     di
  0x10F4A: xor      ax, ax
  0x10F4C: mov      word ptr [bp - 8], ax
  0x10F4F: mov      byte ptr [bp - 5], al
  0x10F52: mov      si, word ptr [bp + 8]
  0x10F55: lodsb    al, byte ptr [si]
  0x10F56: mov      word ptr [bp + 8], si
  0x10F59: mov      byte ptr [bp - 2], al
  0x10F5C: or       al, al
  0x10F5E: je       0x10f66
  0x10F60: cmp      word ptr [bp - 8], 0
  0x10F64: jge      0x10f6c
  0x10F66: mov      ax, word ptr [bp - 8]
  0x10F69: jmp      0x1140f
  0x10F6C: mov      bx, 0x2a56
  0x10F6F: sub      al, 0x20
  0x10F71: cmp      al, 0x58
  0x10F73: ja       0x10f7a
  0x10F75: xlatb    
  0x10F76: and      al, 0xf
  0x10F78: jmp      0x10f7c
  0x10F7A: mov      al, 0
  0x10F7C: mov      cl, 3
  0x10F7E: shl      al, cl
  0x10F80: add      al, byte ptr [bp - 5]
  0x10F83: xlatb    
  0x10F84: inc      cl
  0x10F86: shr      al, cl
  0x10F88: mov      byte ptr [bp - 5], al
  0x10F8B: cwde     
  0x10F8C: mov      bx, ax
  0x10F8E: shl      bx, 1
  0x10F90: jmp      word ptr cs:[bx + 0x195e]
  0x10F95: mov      dl, byte ptr [bp - 2]
  0x10F98: mov      cx, 1
  0x10F9B: call     0x113c2
  0x10F9E: jmp      0x10f52
  0x10FA0: xor      ax, ax
  0x10FA2: mov      word ptr [bp - 0x10], ax
  0x10FA5: mov      word ptr [bp - 0xa], ax
  0x10FA8: mov      word ptr [bp - 0x12], ax
  0x10FAB: mov      word ptr [bp - 4], ax
  0x10FAE: dec      ax
  0x10FAF: mov      word ptr [bp - 0xc], ax
  0x10FB2: jmp      0x10f52
  0x10FB4: mov      al, byte ptr [bp - 2]
  0x10FB7: cmp      al, 0x2d
  0x10FB9: jne      0x10fc1
  0x10FBB: or       byte ptr [bp - 4], 4
  0x10FBF: jmp      0x10f52
  0x10FC1: cmp      al, 0x2b
  0x10FC3: jne      0x10fcb
  0x10FC5: or       byte ptr [bp - 4], 1
  0x10FC9: jmp      0x10f52
  0x10FCB: cmp      al, 0x20
  0x10FCD: jne      0x10fd6
  0x10FCF: or       byte ptr [bp - 4], 2
  0x10FD3: jmp      0x10f52
  0x10FD6: cmp      al, 0x23
  0x10FD8: jne      0x10fe1
  0x10FDA: or       byte ptr [bp - 4], 0x80
  0x10FDE: jmp      0x10f52
  0x10FE1: or       byte ptr [bp - 4], 8
  0x10FE5: jmp      0x10f52
  0x10FE8: mov      cl, byte ptr [bp - 2]
  0x10FEB: cmp      cl, 0x2a
  0x10FEE: jne      0x10fff
  0x10FF0: call     0x11349
  0x10FF3: or       ax, ax
  0x10FF5: jns      0x1100e
  0x10FF7: neg      ax
  0x10FF9: or       byte ptr [bp - 4], 4
  0x10FFD: jmp      0x1100e
  0x10FFF: sub      cl, 0x30
  0x11002: xor      ch, ch
  0x11004: mov      ax, word ptr [bp - 0xa]
  0x11007: mov      bx, 0xa
  0x1100A: mul      bx
  0x1100C: add      ax, cx
  0x1100E: mov      word ptr [bp - 0xa], ax
  0x11011: jmp      0x10f52
  0x11014: mov      word ptr [bp - 0xc], 0
  0x11019: jmp      0x10f52
  0x1101C: mov      cl, byte ptr [bp - 2]
  0x1101F: cmp      cl, 0x2a
  0x11022: jne      0x11030
  0x11024: call     0x11349
  0x11027: or       ax, ax
  0x11029: jns      0x1103f
  0x1102B: mov      ax, 0xffff
  0x1102E: jmp      0x1103f
  0x11030: sub      cl, 0x30
  0x11033: xor      ch, ch
  0x11035: mov      ax, word ptr [bp - 0xc]
  0x11038: mov      bx, 0xa
  0x1103B: mul      bx
  0x1103D: add      ax, cx
  0x1103F: mov      word ptr [bp - 0xc], ax
  0x11042: jmp      0x10f52
  0x11045: mov      al, byte ptr [bp - 2]
  0x11048: cmp      al, 0x6c
  0x1104A: jne      0x11052
  0x1104C: or       byte ptr [bp - 4], 0x10
  0x11050: jmp      0x11074
  0x11052: cmp      al, 0x46
  0x11054: jne      0x1105c
  0x11056: or       byte ptr [bp - 4], 0x20
  0x1105A: jmp      0x11074
  0x1105C: cmp      al, 0x4e
  0x1105E: jne      0x11066
  0x11060: or       byte ptr [bp - 3], 0x10
  0x11064: jmp      0x11074
  0x11066: cmp      al, 0x4c
  0x11068: jne      0x11070
  0x1106A: or       byte ptr [bp - 3], 4
  0x1106E: jmp      0x11074
  0x11070: or       byte ptr [bp - 3], 8
  0x11074: jmp      0x10f52
  0x11077: mov      al, byte ptr [bp - 2]
  0x1107A: cmp      al, 0x64
  0x1107C: jne      0x11081
  0x1107E: jmp      0x1120f
  0x11081: cmp      al, 0x69
  0x11083: jne      0x11088
  0x11085: jmp      0x1120f
  0x11088: cmp      al, 0x75
  0x1108A: jne      0x1108f
  0x1108C: jmp      0x11213
  0x1108F: cmp      al, 0x58
  0x11091: jne      0x11096
  0x11093: jmp      0x11219
  0x11096: cmp      al, 0x78
  0x11098: jne      0x1109d
  0x1109A: jmp      0x1121f
  0x1109D: cmp      al, 0x6f
  0x1109F: jne      0x110a4
  0x110A1: jmp      0x11240
  0x110A4: cmp      al, 0x63
  0x110A6: je       0x110c2
  0x110A8: cmp      al, 0x73
  0x110AA: je       0x110d3
  0x110AC: cmp      al, 0x6e
  0x110AE: je       0x11101
  0x110B0: cmp      al, 0x70
  0x110B2: je       0x11114
  0x110B4: cmp      al, 0x45
  0x110B6: je       0x110bf
  0x110B8: cmp      al, 0x47
  0x110BA: je       0x110bf
  0x110BC: jmp      0x1117a
  0x110BF: jmp      0x11177
  0x110C2: call     0x11349
  0x110C5: lea      di, [bp - 0x171]
  0x110C9: push     ss
  0x110CA: pop      es
  0x110CB: stosb    byte ptr es:[di], al
  0x110CC: dec      di
  0x110CD: mov      cx, 1
  0x110D0: jmp      0x112be
  0x110D3: call     0x1135d
  0x110D6: or       di, di
  0x110D8: jne      0x110ec
  0x110DA: mov      ax, es
  0x110DC: or       ax, ax
  0x110DE: jne      0x110ec
  0x110E0: push     ds
  0x110E1: pop      es
  0x110E2: mov      di, 0x2aaf
  0x110E5: mov      cx, word ptr [0x2ab5]
  0x110E9: jmp      0x112be
  0x110EC: push     di
  0x110ED: mov      cx, word ptr [bp - 0xc]
  0x110F0: jcxz     0x110f9
  0x110F2: xor      al, al
  0x110F4: repne scasb al, byte ptr es:[di]
  0x110F6: jne      0x110f9
  0x110F8: dec      di
  0x110F9: pop      cx
  0x110FA: sub      di, cx
  0x110FC: xchg     di, cx
  0x110FE: jmp      0x112be
  0x11101: call     0x1135d
  0x11104: mov      ax, word ptr [bp - 8]
  0x11107: stosw    word ptr es:[di], ax
  0x11108: test     byte ptr [bp - 4], 0x10
  0x1110C: je       0x11111
  0x1110E: xor      ax, ax
  0x11110: stosw    word ptr es:[di], ax
  0x11111: jmp      0x10f52
  0x11114: test     byte ptr [bp - 4], 0x30
  0x11118: jne      0x1111f
  0x1111A: call     0x11349
  0x1111D: jmp      0x11158
  0x1111F: call     0x11351
  0x11122: test     byte ptr [bp - 3], 0x18
  0x11126: jne      0x11158
  0x11128: mov      byte ptr [bp - 1], 7
  0x1112C: mov      cx, 0x10
  0x1112F: push     ss
  0x11130: pop      es
  0x11131: push     dx
  0x11132: xor      dx, dx
  0x11134: lea      di, [bp - 0x169]
  0x11138: mov      si, 4
  0x1113B: call     0x113de
  0x1113E: mov      cx, 0x10
  0x11141: lea      di, [bp - 0x16e]
  0x11145: pop      ax
  0x11146: xor      dx, dx
  0x11148: mov      si, 4
  0x1114B: call     0x113de
  0x1114E: mov      byte ptr [bp - 0x16d], 0x3a
  0x11153: mov      cx, 9
  0x11156: jmp      0x11170
  0x11158: mov      byte ptr [bp - 1], 7
  0x1115C: mov      cx, 0x10
  0x1115F: push     ss
  0x11160: pop      es
  0x11161: xor      dx, dx
  0x11163: lea      di, [bp - 0x16e]
  0x11167: mov      si, 4
  0x1116A: call     0x113de
  0x1116D: mov      cx, 4
  0x11170: lea      di, [bp - 0x171]
  0x11174: jmp      0x112be
  0x11177: inc      word ptr [bp - 0x12]
  0x1117A: or       byte ptr [bp - 4], 0x40
  0x1117E: mov      al, byte ptr [bp - 2]
  0x11181: or       al, 0x20
  0x11183: cwde     
  0x11184: mov      si, ax
  0x11186: cmp      word ptr [bp - 0xc], 0
  0x1118A: jg       0x1119f
  0x1118C: je       0x11195
  0x1118E: mov      word ptr [bp - 0xc], 6
  0x11193: jmp      0x1119f
  0x11195: cmp      ax, 0x67
  0x11198: jne      0x1119f
  0x1119A: mov      word ptr [bp - 0xc], 1
  0x1119F: lea      di, [bp - 0x171]
  0x111A3: push     word ptr [bp - 0x12]
  0x111A6: push     word ptr [bp - 0xc]
  0x111A9: push     si
  0x111AA: push     di
  0x111AB: push     word ptr [bp + 0xa]
  0x111AE: test     byte ptr [bp - 3], 4
  0x111B2: je       0x111be
  0x111B4: lcall    [0x2ad8]
  0x111B8: add      word ptr [bp + 0xa], 0xa
  0x111BC: jmp      0x111c6
  0x111BE: lcall    [0x2ac4]
  0x111C2: add      word ptr [bp + 0xa], 8
  0x111C6: add      sp, 0xa
  0x111C9: test     byte ptr [bp - 4], 0x80
  0x111CD: je       0x111dd
  0x111CF: cmp      word ptr [bp - 0xc], 0
  0x111D3: jne      0x111dd
  0x111D5: push     di
  0x111D6: lcall    [0x2ad0]
  0x111DA: add      sp, 2
  0x111DD: cmp      si, 0x67
  0x111E0: jne      0x111f1
  0x111E2: test     word ptr [bp - 4], 0x80
  0x111E7: jne      0x111f1
  0x111E9: push     di
  0x111EA: lcall    [0x2ac8]
  0x111EE: add      sp, 2
  0x111F1: push     ss
  0x111F2: pop      es
  0x111F3: cmp      byte ptr es:[di], 0x2d
  0x111F7: jne      0x111fe
  0x111F9: inc      di
  0x111FA: or       byte ptr [bp - 3], 1
  0x111FE: mov      cx, 0xffff
  0x11201: push     di
  0x11202: mov      al, 0
  0x11204: repne scasb al, byte ptr es:[di]
  0x11206: dec      di
  0x11207: pop      cx
  0x11208: sub      di, cx
  0x1120A: xchg     di, cx
  0x1120C: jmp      0x112be
  0x1120F: or       byte ptr [bp - 4], 0x40
  0x11213: mov      byte ptr [bp - 6], 0xa
  0x11217: jmp      0x1124e
  0x11219: mov      byte ptr [bp - 1], 7
  0x1121D: jmp      0x11223
  0x1121F: mov      byte ptr [bp - 1], 0x27
  0x11223: test     byte ptr [bp - 4], 0x80
  0x11227: je       0x1123a
  0x11229: mov      word ptr [bp - 0x10], 2
  0x1122E: mov      byte ptr [bp - 0xe], 0x30
  0x11232: mov      dl, 0x51
  0x11234: add      dl, byte ptr [bp - 1]
  0x11237: mov      byte ptr [bp - 0xd], dl
  0x1123A: mov      byte ptr [bp - 6], 0x10
  0x1123E: jmp      0x1124e
  0x11240: test     byte ptr [bp - 4], 0x80
  0x11244: je       0x1124a
  0x11246: or       byte ptr [bp - 3], 2
  0x1124A: mov      byte ptr [bp - 6], 8
  0x1124E: test     byte ptr [bp - 4], 0x10
  0x11252: je       0x11259
  0x11254: call     0x11351
  0x11257: jmp      0x11267
  0x11259: call     0x11349
  0x1125C: test     byte ptr [bp - 4], 0x40
  0x11260: je       0x11265
  0x11262: cdq      
  0x11263: jmp      0x11267
  0x11265: xor      dx, dx
  0x11267: test     byte ptr [bp - 4], 0x40
  0x1126B: je       0x1127c
  0x1126D: or       dx, dx
  0x1126F: jge      0x1127c
  0x11271: or       byte ptr [bp - 3], 1
  0x11275: neg      ax
  0x11277: adc      dx, 0
  0x1127A: neg      dx
  0x1127C: cmp      word ptr [bp - 0xc], 0
  0x11280: jge      0x11289
  0x11282: mov      word ptr [bp - 0xc], 1
  0x11287: jmp      0x1128d
  0x11289: and      byte ptr [bp - 4], 0xf7
  0x1128D: mov      bx, ax
  0x1128F: or       bx, dx
  0x11291: jne      0x11298
  0x11293: mov      word ptr [bp - 0x10], 0
  0x11298: lea      di, [bp - 0x15]
  0x1129B: push     ss
  0x1129C: pop      es
  0x1129D: mov      cl, byte ptr [bp - 6]
  0x112A0: xor      ch, ch
  0x112A2: mov      si, word ptr [bp - 0xc]
  0x112A5: call     0x113de
  0x112A8: test     byte ptr [bp - 3], 2
  0x112AC: je       0x112bc
  0x112AE: jcxz     0x112b6
  0x112B0: cmp      byte ptr es:[di], 0x30
  0x112B4: je       0x112bc
  0x112B6: dec      di
  0x112B7: mov      byte ptr es:[di], 0x30
  0x112BB: inc      cx
  0x112BC: jmp      0x112be
  0x112BE: test     byte ptr [bp - 4], 0x40
  0x112C2: je       0x112f5
  0x112C4: test     byte ptr [bp - 3], 1
  0x112C8: je       0x112d5
  0x112CA: mov      byte ptr [bp - 0xe], 0x2d
  0x112CE: mov      word ptr [bp - 0x10], 1
  0x112D3: jmp      0x112f5
  0x112D5: test     byte ptr [bp - 4], 1
  0x112D9: je       0x112e6
  0x112DB: mov      byte ptr [bp - 0xe], 0x2b
  0x112DF: mov      word ptr [bp - 0x10], 1
  0x112E4: jmp      0x112f5
  0x112E6: test     byte ptr [bp - 4], 2
  0x112EA: je       0x112f5
  0x112EC: mov      byte ptr [bp - 0xe], 0x20
  0x112F0: mov      word ptr [bp - 0x10], 1
  0x112F5: mov      ax, word ptr [bp - 0xa]
  0x112F8: sub      ax, cx
  0x112FA: sub      ax, word ptr [bp - 0x10]
  0x112FD: jge      0x11301
  0x112FF: xor      ax, ax
  0x11301: push     es
  0x11302: push     di
  0x11303: push     cx
  0x11304: test     byte ptr [bp - 4], 0xc
  0x11308: jne      0x11311
  0x1130A: mov      cx, ax
  0x1130C: mov      dl, 0x20
  0x1130E: call     0x113c2
  0x11311: push     ax
  0x11312: push     ss
  0x11313: pop      es
  0x11314: lea      di, [bp - 0xe]
  0x11317: mov      cx, word ptr [bp - 0x10]
  0x1131A: call     0x113a4
  0x1131D: pop      ax
  0x1131E: test     byte ptr [bp - 4], 8
  0x11322: je       0x11331
  0x11324: test     byte ptr [bp - 4], 4
  0x11328: jne      0x11331
  0x1132A: mov      cx, ax
  0x1132C: mov      dl, 0x30
  0x1132E: call     0x113c2
  0x11331: pop      cx
  0x11332: pop      di
  0x11333: pop      es
  0x11334: push     ax
  0x11335: call     0x113a4
  0x11338: pop      ax
  0x11339: test     byte ptr [bp - 4], 4
  0x1133D: je       0x11346
  0x1133F: mov      cx, ax
  0x11341: mov      dl, 0x20
  0x11343: call     0x113c2
  0x11346: jmp      0x10f52
  0x11349: mov      si, word ptr [bp + 0xa]
  0x1134C: lodsw    ax, word ptr [si]
  0x1134D: mov      word ptr [bp + 0xa], si
  0x11350: ret      

============================================================
func_L469 at file 0x1144A, 32 bytes
============================================================
  0x1144A: push     bp
  0x1144B: mov      bp, sp
  0x1144D: mov      bx, word ptr [bp + 6]
  0x11450: cmp      bx, word ptr [0x27b9]
  0x11454: jb       0x1145c
  0x11456: mov      ax, 0x900
  0x11459: stc      
  0x1145A: jmp      0x11467
  0x1145C: mov      ah, 0x3e
  0x1145E: int      0x21
  0x11460: jb       0x11467
  0x11462: mov      byte ptr [bx + 0x27bb], 0
  0x11467: jmp      0x10ad0

============================================================
func_L470 at file 0x1146A, 122 bytes
============================================================
  0x1146A: push     bp
  0x1146B: mov      bp, sp
  0x1146D: sub      sp, 4
  0x11470: mov      bx, word ptr [bp + 6]
  0x11473: cmp      bx, word ptr [0x27b9]
  0x11477: jb       0x1147e
  0x11479: mov      ax, 0x900
  0x1147C: jmp      0x114a8
  0x1147E: test     word ptr [bp + 0xa], 0x8000
  0x11483: je       0x114cd
  0x11485: cmp      word ptr [bp + 0xc], 0
  0x11489: je       0x114a5
  0x1148B: xor      cx, cx
  0x1148D: mov      dx, cx
  0x1148F: mov      ax, 0x4201
  0x11492: int      0x21
  0x11494: jb       0x114e1
  0x11496: test     word ptr [bp + 0xc], 2
  0x1149B: jne      0x114ab
  0x1149D: add      ax, word ptr [bp + 8]
  0x114A0: adc      dx, word ptr [bp + 0xa]
  0x114A3: jns      0x114cd
  0x114A5: mov      ax, 0x1600
  0x114A8: stc      
  0x114A9: jmp      0x114e1
  0x114AB: mov      word ptr [bp - 2], dx
  0x114AE: mov      word ptr [bp - 4], ax
  0x114B1: mov      dx, cx
  0x114B3: mov      ax, 0x4202
  0x114B6: int      0x21
  0x114B8: add      ax, word ptr [bp + 8]
  0x114BB: adc      dx, word ptr [bp + 0xa]
  0x114BE: jns      0x114cd
  0x114C0: mov      cx, word ptr [bp - 2]
  0x114C3: mov      dx, word ptr [bp - 4]
  0x114C6: mov      ax, 0x4200
  0x114C9: int      0x21
  0x114CB: jmp      0x114a5
  0x114CD: mov      dx, word ptr [bp + 8]
  0x114D0: mov      cx, word ptr [bp + 0xa]
  0x114D3: mov      al, byte ptr [bp + 0xc]
  0x114D6: mov      ah, 0x42
  0x114D8: int      0x21
  0x114DA: jb       0x114e1
  0x114DC: and      byte ptr [bx + 0x27bb], 0xfd
  0x114E1: jmp      0x10ae5

============================================================
func_L471 at file 0x114E4, 184 bytes
============================================================
  0x114E4: push     bp
  0x114E5: mov      bp, sp
  0x114E7: sub      sp, 2
  0x114EA: mov      bx, word ptr [bp + 6]
  0x114ED: cmp      bx, word ptr [0x27b9]
  0x114F1: jb       0x114f9
  0x114F3: stc      
  0x114F4: mov      ax, 0x900
  0x114F7: jmp      0x11561
  0x114F9: xor      ax, ax
  0x114FB: mov      cx, word ptr [bp + 0xa]
  0x114FE: jcxz     0x11561
  0x11500: test     byte ptr [bx + 0x27bb], 2
  0x11505: jne      0x11561
  0x11507: cmp      word ptr [0x2b16], 0xd6d6
  0x1150D: jne      0x11513
  0x1150F: call     word ptr [0x2b18]
  0x11513: mov      cx, word ptr [bp + 0xa]
  0x11516: mov      dx, word ptr [bp + 8]
  0x11519: mov      ah, 0x3f
  0x1151B: int      0x21
  0x1151D: jae      0x11523
  0x1151F: mov      ah, 9
  0x11521: jmp      0x11561
  0x11523: test     byte ptr [bx + 0x27bb], 0x80
  0x11528: je       0x11561
  0x1152A: and      byte ptr [bx + 0x27bb], 0xfb
  0x1152F: push     si
  0x11530: push     di
  0x11531: cld      
  0x11532: mov      si, dx
  0x11534: mov      di, dx
  0x11536: mov      cx, ax
  0x11538: jcxz     0x1155f
  0x1153A: mov      ah, 0xd
  0x1153C: cmp      byte ptr [si], 0xa
  0x1153F: jne      0x11546
  0x11541: or       byte ptr [bx + 0x27bb], 4
  0x11546: lodsb    al, byte ptr [si]
  0x11547: cmp      al, ah
  0x11549: je       0x11564
  0x1154B: cmp      al, 0x1a
  0x1154D: jne      0x11556
  0x1154F: or       byte ptr [bx + 0x27bb], 2
  0x11554: jmp      0x1155b
  0x11556: mov      byte ptr [di], al
  0x11558: inc      di
  0x11559: loop     0x11546
  0x1155B: mov      ax, di
  0x1155D: sub      ax, dx
  0x1155F: pop      di
  0x11560: pop      si
  0x11561: jmp      0x10ae5
  0x11564: cmp      cx, 1
  0x11567: je       0x11570
  0x11569: cmp      byte ptr [si], 0xa
  0x1156C: je       0x11559
  0x1156E: jmp      0x11556
  0x11570: test     byte ptr [bx + 0x27bb], 0x40
  0x11575: je       0x1158f
  0x11577: mov      ax, 0x4400
  0x1157A: int      0x21
  0x1157C: test     dx, 0x20
  0x11580: jne      0x1158b
  0x11582: lea      dx, [bp - 1]
  0x11585: mov      ah, 0x3f
  0x11587: int      0x21
  0x11589: jb       0x1155f
  0x1158B: mov      al, 0xa
  0x1158D: jmp      0x115bb
  0x1158F: mov      byte ptr [bp - 1], 0
  0x11593: lea      dx, [bp - 1]
  0x11596: mov      ah, 0x3f
  0x11598: int      0x21
  0x1159A: jb       0x1155f

============================================================
func_L472 at file 0x115CE, 213 bytes
============================================================
  0x115CE: push     bp
  0x115CF: mov      bp, sp
  0x115D1: sub      sp, 8
  0x115D4: mov      bx, word ptr [bp + 6]
  0x115D7: cmp      bx, word ptr [0x27b9]
  0x115DB: jb       0x115e4
  0x115DD: mov      ax, 0x900
  0x115E0: stc      
  0x115E1: jmp      0x10ae5
  0x115E4: cmp      word ptr [0x2b16], 0xd6d6
  0x115EA: jne      0x115f0
  0x115EC: call     word ptr [0x2b18]
  0x115F0: test     byte ptr [bx + 0x27bb], 0x20
  0x115F5: je       0x11602
  0x115F7: mov      ax, 0x4202
  0x115FA: xor      cx, cx
  0x115FC: mov      dx, cx
  0x115FE: int      0x21
  0x11600: jb       0x115e1
  0x11602: test     byte ptr [bx + 0x27bb], 0x80
  0x11607: je       0x11679
  0x11609: mov      dx, word ptr [bp + 8]
  0x1160C: push     ds
  0x1160D: pop      es
  0x1160E: xor      ax, ax
  0x11610: mov      word ptr [bp - 2], ax
  0x11613: mov      word ptr [bp - 4], ax
  0x11616: cld      
  0x11617: push     di
  0x11618: push     si
  0x11619: mov      di, dx
  0x1161B: mov      si, dx
  0x1161D: mov      word ptr [bp - 8], sp
  0x11620: mov      cx, word ptr [bp + 0xa]
  0x11623: jcxz     0x1165f
  0x11625: mov      al, 0xa
  0x11627: repne scasb al, byte ptr es:[di]
  0x11629: jne      0x11677
  0x1162B: lcall    0xd1d, 0x2902
  0x11630: cmp      ax, 0xa8
  0x11633: jbe      0x1167b
  0x11635: sub      sp, 2
  0x11638: mov      bx, sp
  0x1163A: mov      dx, 0x200
  0x1163D: cmp      ax, 0x228
  0x11640: jae      0x11645
  0x11642: mov      dx, 0x80
  0x11645: sub      sp, dx
  0x11647: mov      dx, sp
  0x11649: mov      di, dx
  0x1164B: push     ss
  0x1164C: pop      es
  0x1164D: mov      cx, word ptr [bp + 0xa]
  0x11650: lodsb    al, byte ptr [si]
  0x11651: cmp      al, 0xa
  0x11653: je       0x11661
  0x11655: cmp      di, bx
  0x11657: je       0x11672
  0x11659: stosb    byte ptr es:[di], al
  0x1165A: loop     0x11650
  0x1165C: call     0x11682
  0x1165F: jmp      0x116cc
  0x11661: mov      al, 0xd
  0x11663: cmp      di, bx
  0x11665: jne      0x1166a
  0x11667: call     0x11682
  0x1166A: stosb    byte ptr es:[di], al
  0x1166B: mov      al, 0xa
  0x1166D: inc      word ptr [bp - 4]
  0x11670: jmp      0x11655
  0x11672: call     0x11682
  0x11675: jmp      0x11659
  0x11677: pop      si
  0x11678: pop      di
  0x11679: jmp      0x116da
  0x1167B: mov      ax, 0xfffc
  0x1167E: push     cs
  0x1167F: call     0xf9a0
  0x11682: push     ax
  0x11683: push     bx
  0x11684: push     cx
  0x11685: mov      cx, di
  0x11687: sub      cx, dx
  0x11689: jcxz     0x1169d
  0x1168B: push     cx
  0x1168C: mov      bx, word ptr [bp + 6]
  0x1168F: mov      ah, 0x40
  0x11691: int      0x21
  0x11693: pop      cx
  0x11694: jb       0x116a3
  0x11696: add      word ptr [bp - 2], ax
  0x11699: cmp      cx, ax
  0x1169B: ja       0x116a3
  0x1169D: pop      cx
  0x1169E: pop      bx
  0x1169F: pop      ax
  0x116A0: mov      di, dx
  0x116A2: ret      

============================================================
func_L473 at file 0x1180C, 46 bytes
============================================================
  0x1180C: push     bp
  0x1180D: mov      bp, sp
  0x1180F: push     di
  0x11810: push     si
  0x11811: mov      si, word ptr [bp + 6]
  0x11814: xor      ax, ax
  0x11816: cdq      
  0x11817: xor      bx, bx
  0x11819: lodsb    al, byte ptr [si]
  0x1181A: cmp      al, 0x20
  0x1181C: je       0x11819
  0x1181E: cmp      al, 9
  0x11820: je       0x11819
  0x11822: push     ax
  0x11823: cmp      al, 0x2d
  0x11825: je       0x1182b
  0x11827: cmp      al, 0x2b
  0x11829: jne      0x1182c
  0x1182B: lodsb    al, byte ptr [si]
  0x1182C: cmp      al, 0x39
  0x1182E: ja       0x1184f
  0x11830: sub      al, 0x30
  0x11832: jb       0x1184f
  0x11834: shl      bx, 1
  0x11836: rcl      dx, 1
  0x11838: mov      cx, bx

============================================================
func_L474 at file 0x11860, 172 bytes
============================================================
  0x11860: push     bp
  0x11861: mov      bp, sp
  0x11863: sub      sp, 0xe
  0x11866: push     di
  0x11867: push     si
  0x11868: mov      si, word ptr [bp + 6]
  0x1186B: mov      ax, si
  0x1186D: sub      ax, 0x290e
  0x11870: add      ax, 0x29ae
  0x11873: mov      word ptr [bp - 0xe], ax
  0x11876: mov      al, byte ptr [si + 7]
  0x11879: sub      ah, ah
  0x1187B: mov      word ptr [bp - 0xa], ax
  0x1187E: cmp      word ptr [si + 2], 0
  0x11882: jge      0x11889
  0x11884: mov      word ptr [si + 2], 0
  0x11889: mov      ax, 1
  0x1188C: push     ax
  0x1188D: sub      ax, ax
  0x1188F: push     ax
  0x11890: push     ax
  0x11891: push     word ptr [bp - 0xa]
  0x11894: lcall    0xd1d, 0x1e9a
  0x11899: add      sp, 8
  0x1189C: mov      word ptr [bp - 4], ax
  0x1189F: mov      word ptr [bp - 2], dx
  0x118A2: or       dx, dx
  0x118A4: jge      0x118ae
  0x118A6: mov      ax, 0xffff
  0x118A9: cdq      
  0x118AA: jmp      0x119d0
  0x118AD: nop      
  0x118AE: test     byte ptr [si + 6], 8
  0x118B2: jne      0x118d2
  0x118B4: mov      bx, word ptr [bp - 0xe]
  0x118B7: test     byte ptr [bx], 1
  0x118BA: jne      0x118d2
  0x118BC: mov      ax, word ptr [si + 2]
  0x118BF: cdq      
  0x118C0: mov      cx, ax
  0x118C2: mov      bx, dx
  0x118C4: mov      ax, word ptr [bp - 4]
  0x118C7: mov      dx, word ptr [bp - 2]
  0x118CA: sub      ax, cx
  0x118CC: sbb      dx, bx
  0x118CE: jmp      0x119d0
  0x118D1: nop      
  0x118D2: mov      ax, word ptr [si]
  0x118D4: sub      ax, word ptr [si + 4]
  0x118D7: mov      word ptr [bp - 8], ax
  0x118DA: test     byte ptr [si + 6], 3
  0x118DE: je       0x1190e
  0x118E0: mov      bx, word ptr [bp - 0xa]
  0x118E3: test     byte ptr [bx + 0x27bb], 0x80
  0x118E8: je       0x118fd
  0x118EA: mov      di, word ptr [si + 4]
  0x118ED: jmp      0x118f9
  0x118EF: nop      
  0x118F0: cmp      byte ptr [di], 0xa
  0x118F3: jne      0x118f8
  0x118F5: inc      word ptr [bp - 8]
  0x118F8: inc      di
  0x118F9: cmp      word ptr [si], di
  0x118FB: ja       0x118f0
  0x118FD: mov      ax, word ptr [bp - 2]
  0x11900: or       ax, word ptr [bp - 4]
  0x11903: jne      0x1191c
  0x11905: mov      ax, word ptr [bp - 8]
  0x11908: sub      dx, dx

============================================================
func_L475 at file 0x119D6, 191 bytes
============================================================
  0x119D6: push     bp
  0x119D7: mov      bp, sp
  0x119D9: sub      sp, 2
  0x119DC: push     di
  0x119DD: push     si
  0x119DE: mov      word ptr [bp - 2], 0
  0x119E3: cmp      word ptr [bp + 0xa], 4
  0x119E7: je       0x11a08
  0x119E9: cmp      word ptr [bp + 0xc], 0
  0x119ED: je       0x11a02
  0x119EF: cmp      word ptr [bp + 0xc], 0x7fff
  0x119F4: ja       0x11a02
  0x119F6: cmp      word ptr [bp + 0xa], 0
  0x119FA: je       0x11a08
  0x119FC: cmp      word ptr [bp + 0xa], 0x40
  0x11A00: je       0x11a08
  0x11A02: mov      ax, 0xffff
  0x11A05: jmp      0x11a8f
  0x11A08: mov      si, word ptr [bp + 6]
  0x11A0B: mov      di, si
  0x11A0D: sub      di, 0x290e
  0x11A11: add      di, 0x29ae
  0x11A15: push     si
  0x11A16: lcall    0xd1d, 0x1896
  0x11A1B: add      sp, 2
  0x11A1E: push     si
  0x11A1F: call     0x10ca0
  0x11A22: add      sp, 2
  0x11A25: test     byte ptr [bp + 0xa], 4
  0x11A29: je       0x11a40
  0x11A2B: or       byte ptr [si + 6], 4
  0x11A2F: mov      byte ptr [di], 0
  0x11A32: lea      ax, [di + 1]
  0x11A35: mov      word ptr [bp + 8], ax
  0x11A38: mov      word ptr [bp + 0xc], 1
  0x11A3D: jmp      0x11a79
  0x11A3F: nop      
  0x11A40: cmp      word ptr [bp + 8], 0
  0x11A44: jne      0x11a6e
  0x11A46: push     word ptr [bp + 0xc]
  0x11A49: lcall    0xd1d, 0x2916
  0x11A4E: add      sp, 2
  0x11A51: mov      word ptr [bp + 8], ax
  0x11A54: or       ax, ax
  0x11A56: jne      0x11a60
  0x11A58: mov      word ptr [bp - 2], 0xffff
  0x11A5D: jmp      0x11a8c
  0x11A5F: nop      
  0x11A60: and      byte ptr [si + 6], 0xfb
  0x11A64: or       byte ptr [si + 6], 8
  0x11A68: mov      byte ptr [di], 0
  0x11A6B: jmp      0x11a79
  0x11A6D: nop      
  0x11A6E: inc      word ptr [0x2ac2]
  0x11A72: and      byte ptr [si + 6], 0xf3
  0x11A76: mov      byte ptr [di], 1
  0x11A79: mov      ax, word ptr [bp + 0xc]
  0x11A7C: mov      word ptr [di + 2], ax
  0x11A7F: mov      ax, word ptr [bp + 8]
  0x11A82: mov      word ptr [si + 4], ax
  0x11A85: mov      word ptr [si], ax
  0x11A87: mov      word ptr [si + 2], 0
  0x11A8C: mov      ax, word ptr [bp - 2]
  0x11A8F: pop      si
  0x11A90: pop      di
  0x11A91: mov      sp, bp
  0x11A93: pop      bp
  0x11A94: retf     

============================================================
func_L476 at file 0x11B56, 341 bytes
============================================================
  0x11B56: push     bp
  0x11B57: mov      bp, sp
  0x11B59: sub      sp, 6
  0x11B5C: push     di
  0x11B5D: push     si
  0x11B5E: mov      word ptr [bp - 4], 0
  0x11B63: push     word ptr [bp + 0xa]
  0x11B66: push     word ptr [bp + 8]
  0x11B69: push     word ptr [bp + 6]
  0x11B6C: lcall    0xd1d, 0x2b32
  0x11B71: add      sp, 6
  0x11B74: cmp      word ptr [0x27ac], 2
  0x11B79: je       0x11b7e
  0x11B7B: jmp      0x11c91
  0x11B7E: mov      ax, 0x5c
  0x11B81: push     ax
  0x11B82: push     word ptr [bp + 6]
  0x11B85: lcall    0xd1d, 0xc56
  0x11B8A: add      sp, 4
  0x11B8D: or       ax, ax
  0x11B8F: je       0x11b94
  0x11B91: jmp      0x11c91
  0x11B94: mov      ax, 0x2f
  0x11B97: push     ax
  0x11B98: push     word ptr [bp + 6]
  0x11B9B: lcall    0xd1d, 0xc56
  0x11BA0: add      sp, 4
  0x11BA3: or       ax, ax
  0x11BA5: je       0x11baa
  0x11BA7: jmp      0x11c91
  0x11BAA: mov      bx, word ptr [bp + 6]
  0x11BAD: cmp      byte ptr [bx], 0
  0x11BB0: je       0x11bbb
  0x11BB2: cmp      byte ptr [bx + 1], 0x3a
  0x11BB6: jne      0x11bbb
  0x11BB8: jmp      0x11c91
  0x11BBB: mov      ax, 0x2aba
  0x11BBE: push     ax
  0x11BBF: lcall    0xd1d, 0x942
  0x11BC4: add      sp, 2
  0x11BC7: mov      si, ax
  0x11BC9: or       si, si
  0x11BCB: jne      0x11bd0
  0x11BCD: jmp      0x11c91
  0x11BD0: mov      ax, 0x104
  0x11BD3: push     ax
  0x11BD4: lcall    0xd1d, 0x2916
  0x11BD9: add      sp, 2
  0x11BDC: mov      di, ax
  0x11BDE: mov      word ptr [bp - 4], di
  0x11BE1: or       di, di
  0x11BE3: jne      0x11be8
  0x11BE5: jmp      0x11c91
  0x11BE8: jmp      0x11bff
  0x11BEA: cmp      byte ptr [si], 0x3b
  0x11BED: je       0x11c04
  0x11BEF: mov      ax, word ptr [bp - 4]
  0x11BF2: add      ax, 0x102
  0x11BF5: cmp      ax, di
  0x11BF7: jbe      0x11c04
  0x11BF9: mov      al, byte ptr [si]
  0x11BFB: mov      byte ptr [di], al
  0x11BFD: inc      si
  0x11BFE: inc      di
  0x11BFF: cmp      byte ptr [si], 0
  0x11C02: jne      0x11bea
  0x11C04: mov      byte ptr [di], 0
  0x11C07: dec      di
  0x11C08: mov      word ptr [bp - 2], di
  0x11C0B: mov      di, word ptr [bp - 4]
  0x11C0E: mov      bx, word ptr [bp - 2]
  0x11C11: cmp      byte ptr [bx], 0x5c
  0x11C14: je       0x11c28
  0x11C16: cmp      byte ptr [bx], 0x2f
  0x11C19: je       0x11c28
  0x11C1B: mov      ax, 0x2abf
  0x11C1E: push     ax
  0x11C1F: push     di
  0x11C20: lcall    0xd1d, 0x7a4
  0x11C25: add      sp, 4
  0x11C28: push     di
  0x11C29: lcall    0xd1d, 0x842
  0x11C2E: add      sp, 2
  0x11C31: push     word ptr [bp + 6]
  0x11C34: mov      word ptr [bp - 6], ax
  0x11C37: lcall    0xd1d, 0x842
  0x11C3C: add      sp, 2
  0x11C3F: add      ax, word ptr [bp - 6]
  0x11C42: cmp      ax, 0x104
  0x11C45: jae      0x11c91
  0x11C47: push     word ptr [bp + 6]
  0x11C4A: push     di
  0x11C4B: lcall    0xd1d, 0x7a4
  0x11C50: add      sp, 4
  0x11C53: push     word ptr [bp + 0xa]
  0x11C56: push     word ptr [bp + 8]
  0x11C59: push     di
  0x11C5A: lcall    0xd1d, 0x2b32
  0x11C5F: add      sp, 6
  0x11C62: cmp      word ptr [0x27ac], 2
  0x11C67: je       0x11c7f
  0x11C69: cmp      byte ptr [di], 0x5c
  0x11C6C: je       0x11c73
  0x11C6E: cmp      byte ptr [di], 0x2f
  0x11C71: jne      0x11c91
  0x11C73: cmp      byte ptr [di + 1], 0x5c
  0x11C77: je       0x11c7f
  0x11C79: cmp      byte ptr [di + 1], 0x2f
  0x11C7D: jne      0x11c91
  0x11C7F: cmp      byte ptr [si], 0
  0x11C82: je       0x11c91
  0x11C84: mov      word ptr [bp - 6], si
  0x11C87: inc      si
  0x11C88: cmp      word ptr [bp - 6], 0
  0x11C8C: je       0x11c91
  0x11C8E: jmp      0x11bff
  0x11C91: cmp      word ptr [bp - 4], 0
  0x11C95: je       0x11ca2
  0x11C97: push     word ptr [bp - 4]
  0x11C9A: lcall    0xd1d, 0x291c
  0x11C9F: add      sp, 2
  0x11CA2: mov      ax, 0xffff
  0x11CA5: pop      si
  0x11CA6: pop      di
  0x11CA7: mov      sp, bp
  0x11CA9: pop      bp
  0x11CAA: retf     

============================================================
func_L477 at file 0x11CD2, 25 bytes
============================================================
  0x11CD2: push     bp
  0x11CD3: mov      bp, sp
  0x11CD5: push     si
  0x11CD6: mov      si, word ptr [bp + 4]
  0x11CD9: mov      ax, 0x200
  0x11CDC: push     ax
  0x11CDD: lcall    0xd1d, 0x2916
  0x11CE2: pop      cx
  0x11CE3: mov      bx, si
  0x11CE5: sub      bx, 0x290e

============================================================
func_L478 at file 0x11D16, 26 bytes
============================================================
  0x11D16: push     bp
  0x11D17: mov      bp, sp
  0x11D19: sub      sp, 4
  0x11D1C: xor      bh, bh
  0x11D1E: cmp      byte ptr [0x27b4], 3
  0x11D23: jb       0x11d28
  0x11D25: mov      bh, byte ptr [bp + 0xa]
  0x11D28: mov      ax, word ptr [bp + 0xc]
  0x11D2B: mov      word ptr [bp + 0xa], ax
  0x11D2E: jmp      0x11d38

============================================================
func_L479 at file 0x11D30, 393 bytes
============================================================
  0x11D30: push     bp
  0x11D31: mov      bp, sp
  0x11D33: sub      sp, 4
  0x11D36: xor      bh, bh
  0x11D38: mov      byte ptr [bp - 2], bh
  0x11D3B: mov      ax, word ptr [bp + 8]
  0x11D3E: mov      cx, ax
  0x11D40: mov      byte ptr [bp - 4], 0
  0x11D44: test     ax, 0x8000
  0x11D47: jne      0x11d59
  0x11D49: test     ax, 0x4000
  0x11D4C: jne      0x11d55
  0x11D4E: test     byte ptr [0x2b01], 0x80
  0x11D53: jne      0x11d59
  0x11D55: mov      byte ptr [bp - 4], 0x80
  0x11D59: mov      dx, word ptr [bp + 6]
  0x11D5C: and      al, 3
  0x11D5E: or       al, bh
  0x11D60: mov      ah, 0x3d
  0x11D62: int      0x21
  0x11D64: jae      0x11d78
  0x11D66: cmp      ax, 2
  0x11D69: jne      0x11d74
  0x11D6B: test     cx, 0x100
  0x11D6F: je       0x11d74
  0x11D71: jmp      0x11e13
  0x11D74: stc      
  0x11D75: jmp      0x10ae5
  0x11D78: xchg     bx, ax
  0x11D79: mov      ax, cx
  0x11D7B: and      ax, 0x500
  0x11D7E: cmp      ax, 0x500
  0x11D81: jne      0x11d8c
  0x11D83: mov      ah, 0x3e
  0x11D85: int      0x21
  0x11D87: mov      ax, 0x1100
  0x11D8A: jmp      0x11d74
  0x11D8C: mov      byte ptr [bp - 3], 1
  0x11D90: mov      ax, 0x4400
  0x11D93: int      0x21
  0x11D95: test     dl, 0x80
  0x11D98: je       0x11d9e
  0x11D9A: or       byte ptr [bp - 4], 0x40
  0x11D9E: test     byte ptr [bp - 4], 0x40
  0x11DA2: je       0x11da7
  0x11DA4: jmp      0x11e7a
  0x11DA7: mov      ax, word ptr [bp + 8]
  0x11DAA: test     ax, 0x200
  0x11DAD: je       0x11dcb
  0x11DAF: test     ax, 3
  0x11DB2: je       0x11dbd
  0x11DB4: xor      cx, cx
  0x11DB6: mov      ah, 0x40
  0x11DB8: int      0x21
  0x11DBA: jmp      0x11e7a
  0x11DBD: mov      ah, 0x3e
  0x11DBF: int      0x21
  0x11DC1: mov      dx, word ptr [bp + 6]
  0x11DC4: mov      ax, 0x4300
  0x11DC7: int      0x21
  0x11DC9: jmp      0x11e30
  0x11DCB: test     byte ptr [bp - 4], 0x80
  0x11DCF: jne      0x11dd4
  0x11DD1: jmp      0x11e7a
  0x11DD4: test     ax, 2
  0x11DD7: jne      0x11ddc
  0x11DD9: jmp      0x11e7a
  0x11DDC: mov      cx, 0xffff
  0x11DDF: mov      dx, cx
  0x11DE1: mov      ax, 0x4202
  0x11DE4: int      0x21
  0x11DE6: neg      cx
  0x11DE8: lea      dx, [bp - 1]
  0x11DEB: mov      ah, 0x3f
  0x11DED: int      0x21
  0x11DEF: or       ax, ax
  0x11DF1: je       0x11e08
  0x11DF3: cmp      byte ptr [bp - 1], 0x1a
  0x11DF7: jne      0x11e08
  0x11DF9: neg      cx
  0x11DFB: mov      dx, cx
  0x11DFD: mov      ax, 0x4202
  0x11E00: int      0x21
  0x11E02: xor      cx, cx
  0x11E04: mov      ah, 0x40
  0x11E06: int      0x21
  0x11E08: xor      cx, cx
  0x11E0A: mov      dx, cx
  0x11E0C: mov      ax, 0x4200
  0x11E0F: int      0x21
  0x11E11: jmp      0x11e7a
  0x11E13: mov      byte ptr [bp - 3], 0
  0x11E17: mov      cx, word ptr [bp + 0xa]
  0x11E1A: call     0x11ec1
  0x11E1D: mov      word ptr [bp + 0xa], cx
  0x11E20: test     byte ptr [bp - 2], 0xff
  0x11E24: jne      0x11e2d
  0x11E26: test     word ptr [bp + 8], 2
  0x11E2B: jne      0x11e30
  0x11E2D: and      cl, 0xfe
  0x11E30: mov      dx, word ptr [bp + 6]
  0x11E33: mov      ah, 0x3c
  0x11E35: int      0x21
  0x11E37: jae      0x11e3c
  0x11E39: jmp      0x10ae5
  0x11E3C: xchg     bx, ax
  0x11E3D: test     byte ptr [bp - 2], 0xff
  0x11E41: jne      0x11e4a
  0x11E43: test     word ptr [bp + 8], 2
  0x11E48: jne      0x11e7a
  0x11E4A: mov      ah, 0x3e
  0x11E4C: int      0x21
  0x11E4E: mov      al, byte ptr [bp + 8]
  0x11E51: and      al, 3
  0x11E53: or       al, byte ptr [bp - 2]
  0x11E56: mov      dx, word ptr [bp + 6]
  0x11E59: mov      ah, 0x3d
  0x11E5B: int      0x21
  0x11E5D: jb       0x11e39
  0x11E5F: xchg     bx, ax
  0x11E60: test     byte ptr [bp - 3], 1
  0x11E64: jne      0x11e7a
  0x11E66: test     word ptr [bp + 0xa], 1
  0x11E6B: je       0x11e7a
  0x11E6D: or       cl, 1
  0x11E70: mov      dx, word ptr [bp + 6]
  0x11E73: mov      ax, 0x4301
  0x11E76: int      0x21
  0x11E78: jb       0x11e39
  0x11E7A: test     byte ptr [bp - 4], 0x40
  0x11E7E: jne      0x11ebd
  0x11E80: mov      dx, word ptr [bp + 6]
  0x11E83: mov      ax, 0x4300
  0x11E86: int      0x21
  0x11E88: mov      ax, cx
  0x11E8A: xor      cl, cl
  0x11E8C: and      ax, 1
  0x11E8F: je       0x11e93
  0x11E91: mov      cl, 0x10
  0x11E93: test     word ptr [bp + 8], 8
  0x11E98: je       0x11e9d
  0x11E9A: or       cl, 0x20
  0x11E9D: cmp      bx, word ptr [0x27b9]
  0x11EA1: jb       0x11ead
  0x11EA3: mov      ah, 0x3e
  0x11EA5: int      0x21
  0x11EA7: mov      ax, 0x1800
  0x11EAA: jmp      0x11d74
  0x11EAD: or       cl, byte ptr [bp - 4]
  0x11EB0: or       cl, 1
  0x11EB3: mov      byte ptr [bx + 0x27bb], cl
  0x11EB7: mov      ax, bx

============================================================
func_L480 at file 0x11F6E, 403 bytes
============================================================
  0x11F6E: push     bp
  0x11F6F: mov      bp, sp
  0x11F71: mov      ax, 0xae
  0x11F74: lcall    0xd1d, 0x3d0
  0x11F79: push     si
  0x11F7A: mov      si, word ptr [bp + 6]
  0x11F7D: mov      word ptr [bp - 0x28], 1
  0x11F82: mov      word ptr [bp - 0x2e], 0
  0x11F87: cmp      word ptr [bp + 0xc], 0
  0x11F8B: jne      0x11fd3
  0x11F8D: mov      word ptr [bp - 0x24], si
  0x11F90: mov      ax, 0x2ae2
  0x11F93: push     ax
  0x11F94: lcall    0xd1d, 0x942
  0x11F99: add      sp, 2
  0x11F9C: mov      si, ax
  0x11F9E: or       si, si
  0x11FA0: jne      0x11fae
  0x11FA2: mov      word ptr [0x27ac], 8
  0x11FA8: mov      ax, 0xffff
  0x11FAB: jmp      0x120fc
  0x11FAE: push     word ptr [bp - 0x24]
  0x11FB1: push     si
  0x11FB2: lea      ax, [bp - 0xae]
  0x11FB6: push     ax
  0x11FB7: lea      ax, [bp - 0x20]
  0x11FBA: push     ax
  0x11FBB: lea      ax, [bp - 0x2e]
  0x11FBE: push     ax
  0x11FBF: push     word ptr [bp + 0xa]
  0x11FC2: push     word ptr [bp + 8]
  0x11FC5: lcall    0xd1d, 0x2c8e
  0x11FCA: add      sp, 0xe
  0x11FCD: mov      word ptr [bp - 0x22], ax
  0x11FD0: inc      ax
  0x11FD1: je       0x11fa8
  0x11FD3: mov      ax, 0x20
  0x11FD6: push     ax
  0x11FD7: mov      ax, 0x8000
  0x11FDA: push     ax
  0x11FDB: push     si
  0x11FDC: lcall    0xd1d, 0x2746
  0x11FE1: add      sp, 6
  0x11FE4: mov      word ptr [bp - 0x26], ax
  0x11FE7: inc      ax
  0x11FE8: jne      0x11ffe
  0x11FEA: cmp      word ptr [bp - 0x2e], 0
  0x11FEE: je       0x11fa8
  0x11FF0: push     word ptr [bp - 0x2e]
  0x11FF3: lcall    0xd1d, 0x291c
  0x11FF8: add      sp, 2
  0x11FFB: jmp      0x11fa8
  0x11FFD: nop      
  0x11FFE: mov      ax, 0x18
  0x12001: push     ax
  0x12002: lea      ax, [bp - 0x1e]
  0x12005: push     ax
  0x12006: push     word ptr [bp - 0x26]
  0x12009: lcall    0xd1d, 0x1f14
  0x1200E: add      sp, 6
  0x12011: inc      ax
  0x12012: jne      0x12040
  0x12014: push     word ptr [bp - 0x26]
  0x12017: lcall    0xd1d, 0x1e7a
  0x1201C: add      sp, 2
  0x1201F: cmp      word ptr [bp - 0x2e], 0
  0x12023: je       0x12030
  0x12025: push     word ptr [bp - 0x2e]
  0x12028: lcall    0xd1d, 0x291c
  0x1202D: add      sp, 2
  0x12030: mov      word ptr [0x27ac], 8
  0x12036: mov      word ptr [0x27b7], 0xb
  0x1203C: jmp      0x11fa8
  0x1203F: nop      
  0x12040: mov      ax, 2
  0x12043: push     ax
  0x12044: sub      ax, ax
  0x12046: push     ax
  0x12047: push     ax
  0x12048: push     word ptr [bp - 0x26]
  0x1204B: lcall    0xd1d, 0x1e9a
  0x12050: add      sp, 8
  0x12053: add      ax, 0xf
  0x12056: adc      dx, 0
  0x12059: sar      dx, 1
  0x1205B: rcr      ax, 1
  0x1205D: sar      dx, 1
  0x1205F: rcr      ax, 1
  0x12061: sar      dx, 1
  0x12063: rcr      ax, 1
  0x12065: sar      dx, 1
  0x12067: rcr      ax, 1
  0x12069: mov      word ptr [bp - 0x2c], ax
  0x1206C: mov      word ptr [bp - 0x2a], dx
  0x1206F: push     word ptr [bp - 0x26]
  0x12072: lcall    0xd1d, 0x1e7a
  0x12077: add      sp, 2
  0x1207A: cmp      word ptr [bp - 0x1e], 0x4d5a
  0x1207F: je       0x12088
  0x12081: cmp      word ptr [bp - 0x1e], 0x5a4d
  0x12086: jne      0x1208b
  0x12088: dec      word ptr [bp - 0x28]
  0x1208B: cmp      word ptr [bp + 0xc], 0
  0x1208F: je       0x120b9
  0x12091: sub      ax, ax
  0x12093: push     ax
  0x12094: push     si
  0x12095: lea      ax, [bp - 0xae]
  0x12099: push     ax
  0x1209A: lea      ax, [bp - 0x20]
  0x1209D: push     ax
  0x1209E: lea      ax, [bp - 0x2e]
  0x120A1: push     ax
  0x120A2: push     word ptr [bp + 0xa]
  0x120A5: push     word ptr [bp + 8]
  0x120A8: lcall    0xd1d, 0x2c8e
  0x120AD: add      sp, 0xe
  0x120B0: mov      word ptr [bp - 0x22], ax
  0x120B3: inc      ax
  0x120B4: jne      0x120b9
  0x120B6: jmp      0x11fa8
  0x120B9: push     word ptr [bp - 0x2c]
  0x120BC: push     word ptr [bp - 0xa]
  0x120BF: push     word ptr [bp - 8]
  0x120C2: push     word ptr [bp - 0xe]
  0x120C5: push     word ptr [bp - 0x10]
  0x120C8: mov      ax, word ptr [bp - 0x1a]
  0x120CB: mov      cl, 5
  0x120CD: shl      ax, cl
  0x120CF: sub      ax, word ptr [bp - 0x16]
  0x120D2: add      ax, word ptr [bp - 0x14]
  0x120D5: push     ax
  0x120D6: push     word ptr [bp - 0x22]
  0x120D9: push     word ptr [bp - 0x20]
  0x120DC: lea      ax, [bp - 0xae]
  0x120E0: push     ax
  0x120E1: push     si
  0x120E2: lcall    0xd1d, 0x842
  0x120E7: add      sp, 2
  0x120EA: inc      ax
  0x120EB: push     ax
  0x120EC: push     si
  0x120ED: push     word ptr [bp - 0x28]
  0x120F0: lcall    0xd1d, 0x2f06
  0x120F5: add      sp, 0x18
  0x120F8: jmp      0x11ff0
  0x120FB: nop      
  0x120FC: pop      si
  0x120FD: mov      sp, bp
  0x120FF: pop      bp
  0x12100: retf     

============================================================
func_L481 at file 0x12102, 273 bytes
============================================================
  0x12102: push     bp
  0x12103: mov      bp, sp
  0x12105: mov      ax, 8
  0x12108: lcall    0xd1d, 0x3d0
  0x1210D: push     di
  0x1210E: push     si
  0x1210F: mov      si, word ptr [bp + 6]
  0x12112: mov      ax, 0x5c
  0x12115: push     ax
  0x12116: push     si
  0x12117: lcall    0xd1d, 0xd1a
  0x1211C: add      sp, 4
  0x1211F: mov      di, ax
  0x12121: mov      ax, 0x2f
  0x12124: push     ax
  0x12125: push     si
  0x12126: lcall    0xd1d, 0xd1a
  0x1212B: add      sp, 4
  0x1212E: or       ax, ax
  0x12130: jne      0x1213a
  0x12132: or       di, di
  0x12134: jne      0x12144
  0x12136: mov      di, si
  0x12138: jmp      0x12144
  0x1213A: or       di, di
  0x1213C: je       0x12142
  0x1213E: cmp      ax, di
  0x12140: jbe      0x12144
  0x12142: mov      di, ax
  0x12144: mov      ax, 0x2e
  0x12147: push     ax
  0x12148: push     di
  0x12149: lcall    0xd1d, 0xc56
  0x1214E: add      sp, 4
  0x12151: mov      word ptr [bp - 2], ax
  0x12154: or       ax, ax
  0x12156: je       0x1217c
  0x12158: push     word ptr [0x2afa]
  0x1215C: push     ax
  0x1215D: lcall    0xd1d, 0xc80
  0x12162: add      sp, 4
  0x12165: push     ax
  0x12166: push     word ptr [bp + 0xa]
  0x12169: push     word ptr [bp + 8]
  0x1216C: push     si
  0x1216D: lcall    0xd1d, 0x299e
  0x12172: add      sp, 8
  0x12175: mov      word ptr [bp - 6], ax
  0x12178: jmp      0x1220a
  0x1217B: nop      
  0x1217C: push     si
  0x1217D: lcall    0xd1d, 0x842
  0x12182: add      sp, 2
  0x12185: add      ax, 5
  0x12188: push     ax
  0x12189: lcall    0xd1d, 0x2916
  0x1218E: add      sp, 2
  0x12191: mov      di, ax
  0x12193: or       di, di
  0x12195: jne      0x1219c
  0x12197: mov      ax, 0xffff
  0x1219A: jmp      0x1220d
  0x1219C: push     si
  0x1219D: push     di
  0x1219E: lcall    0xd1d, 0x7e4
  0x121A3: add      sp, 4
  0x121A6: push     si
  0x121A7: lcall    0xd1d, 0x842
  0x121AC: add      sp, 2
  0x121AF: add      ax, di
  0x121B1: mov      word ptr [bp - 2], ax
  0x121B4: mov      word ptr [bp - 6], 0xffff
  0x121B9: mov      word ptr [bp - 8], 2
  0x121BE: jmp      0x121c3
  0x121C0: dec      word ptr [bp - 8]
  0x121C3: cmp      word ptr [bp - 8], 0
  0x121C7: jl       0x12201
  0x121C9: mov      bx, word ptr [bp - 8]
  0x121CC: shl      bx, 1
  0x121CE: push     word ptr [bx + 0x2afa]
  0x121D2: push     word ptr [bp - 2]
  0x121D5: lcall    0xd1d, 0x7e4
  0x121DA: add      sp, 4
  0x121DD: sub      ax, ax
  0x121DF: push     ax
  0x121E0: push     di
  0x121E1: lcall    0xd1d, 0x328a
  0x121E6: add      sp, 4
  0x121E9: inc      ax
  0x121EA: je       0x121c0
  0x121EC: push     word ptr [bp - 8]
  0x121EF: push     word ptr [bp + 0xa]
  0x121F2: push     word ptr [bp + 8]
  0x121F5: push     di
  0x121F6: lcall    0xd1d, 0x299e
  0x121FB: add      sp, 8
  0x121FE: mov      word ptr [bp - 6], ax
  0x12201: push     di
  0x12202: lcall    0xd1d, 0x291c
  0x12207: add      sp, 2
  0x1220A: mov      ax, word ptr [bp - 6]
  0x1220D: pop      si
  0x1220E: pop      di
  0x1220F: mov      sp, bp
  0x12211: pop      bp
  0x12212: retf     

============================================================
func_L482 at file 0x12214, 33 bytes
============================================================
  0x12214: push     bp
  0x12215: mov      bp, sp
  0x12217: push     si
  0x12218: mov      bx, word ptr [bp + 6]
  0x1221B: mov      si, 0x2778
  0x1221E: cmp      word ptr [si + 6], bx
  0x12221: jae      0x12230
  0x12223: dec      bx
  0x12224: dec      bx
  0x12225: or       byte ptr [bx], 1
  0x12228: cmp      word ptr [si + 8], bx
  0x1222B: jbe      0x12230
  0x1222D: mov      word ptr [si + 8], bx
  0x12230: pop      si
  0x12231: mov      sp, bp
  0x12233: pop      bp
  0x12234: retf     

============================================================
func_L483 at file 0x12235, 40 bytes
============================================================
  0x12235: push     bp
  0x12236: mov      bp, sp
  0x12238: push     si
  0x12239: push     di
  0x1223A: mov      cx, word ptr [bp + 6]
  0x1223D: cmp      cx, -0x18
  0x12240: ja       0x12254
  0x12242: mov      bx, 0x2778
  0x12245: call     0x11ef2
  0x12248: jae      0x12259
  0x1224A: call     0x1170e
  0x1224D: jb       0x12254
  0x1224F: call     0x11ef2
  0x12252: jae      0x12259
  0x12254: xor      ax, ax
  0x12256: cdq      
  0x12257: jmp      0x12259
  0x12259: pop      di
  0x1225A: pop      si
  0x1225B: pop      bp
  0x1225C: retf     

============================================================
func_L484 at file 0x1225E, 499 bytes
============================================================
  0x1225E: push     bp
  0x1225F: mov      bp, sp
  0x12261: sub      sp, 0xc
  0x12264: push     di
  0x12265: push     si
  0x12266: sub      si, si
  0x12268: cmp      word ptr [bp + 8], si
  0x1226B: jne      0x12273
  0x1226D: mov      ax, word ptr [0x27d3]
  0x12270: mov      word ptr [bp + 8], ax
  0x12273: cmp      word ptr [bp + 8], si
  0x12276: je       0x1229f
  0x12278: mov      ax, word ptr [bp + 8]
  0x1227B: mov      word ptr [bp - 6], ax
  0x1227E: jmp      0x12291
  0x12280: add      word ptr [bp - 6], 2
  0x12284: push     word ptr [bx]
  0x12286: lcall    0xd1d, 0x842
  0x1228B: add      sp, 2
  0x1228E: inc      ax
  0x1228F: add      si, ax
  0x12291: mov      bx, word ptr [bp - 6]
  0x12294: cmp      word ptr [bx], 0
  0x12297: je       0x1229f
  0x12299: cmp      si, 0x7fff
  0x1229D: jbe      0x12280
  0x1229F: cmp      word ptr [0x2b12], 0
  0x122A4: je       0x122c4
  0x122A6: mov      ax, word ptr [0x27b9]
  0x122A9: mov      word ptr [bp - 2], ax
  0x122AC: jmp      0x122b1
  0x122AE: dec      word ptr [bp - 2]
  0x122B1: cmp      word ptr [bp - 2], 0
  0x122B5: je       0x122c9
  0x122B7: mov      bx, word ptr [bp - 2]
  0x122BA: cmp      byte ptr [bx + 0x27ba], 0
  0x122BF: jne      0x122c9
  0x122C1: jmp      0x122ae
  0x122C3: nop      
  0x122C4: mov      word ptr [bp - 2], 0
  0x122C9: cmp      word ptr [bp - 2], 0
  0x122CD: je       0x122d9
  0x122CF: mov      ax, word ptr [bp - 2]
  0x122D2: add      ax, 7
  0x122D5: shl      ax, 1
  0x122D7: add      si, ax
  0x122D9: cmp      word ptr [bp + 0x10], 0
  0x122DD: je       0x122ef
  0x122DF: push     word ptr [bp + 0x10]
  0x122E2: lcall    0xd1d, 0x842
  0x122E7: add      sp, 2
  0x122EA: add      ax, 3
  0x122ED: add      si, ax
  0x122EF: inc      si
  0x122F0: mov      word ptr [bp - 8], si
  0x122F3: cmp      si, 0x7fff
  0x122F7: jbe      0x1230c
  0x122F9: mov      word ptr [0x27ac], 7
  0x122FF: mov      word ptr [0x27b7], 0xa
  0x12305: mov      ax, 0xffff
  0x12308: jmp      0x124cf
  0x1230B: nop      
  0x1230C: mov      si, word ptr [0x2ab8]
  0x12310: mov      word ptr [0x2ab8], 0x10
  0x12316: mov      ax, word ptr [bp - 8]
  0x12319: add      ax, 0xf
  0x1231C: push     ax
  0x1231D: lcall    0xd1d, 0x2916
  0x12322: add      sp, 2
  0x12325: mov      di, ax
  0x12327: or       di, di
  0x12329: jne      0x1233e
  0x1232B: mov      word ptr [0x27ac], 0xc
  0x12331: mov      word ptr [0x27b7], 8
  0x12337: mov      word ptr [0x2ab8], si
  0x1233B: jmp      0x12305
  0x1233D: nop      
  0x1233E: mov      word ptr [0x2ab8], si
  0x12342: mov      bx, word ptr [bp + 0xa]
  0x12345: mov      word ptr [bx], di
  0x12347: add      ax, 0xf
  0x1234A: and      al, 0xf0
  0x1234C: mov      di, ax
  0x1234E: mov      bx, word ptr [bp + 0xc]
  0x12351: mov      word ptr [bx], di
  0x12353: cmp      word ptr [bp + 8], 0
  0x12357: je       0x12388
  0x12359: mov      ax, word ptr [bp + 8]
  0x1235C: mov      word ptr [bp - 6], ax
  0x1235F: jmp      0x12380
  0x12361: nop      
  0x12362: sub      ax, ax
  0x12364: push     ax
  0x12365: push     word ptr [bx]
  0x12367: push     di
  0x12368: lcall    0xd1d, 0x7e4
  0x1236D: add      sp, 4
  0x12370: push     ax
  0x12371: lcall    0xd1d, 0xc56
  0x12376: add      sp, 4
  0x12379: inc      ax
  0x1237A: mov      di, ax
  0x1237C: add      word ptr [bp - 6], 2
  0x12380: mov      bx, word ptr [bp - 6]
  0x12383: cmp      word ptr [bx], 0
  0x12386: jne      0x12362
  0x12388: cmp      word ptr [bp - 2], 0
  0x1238C: je       0x123d7
  0x1238E: sub      ax, ax
  0x12390: push     ax
  0x12391: mov      ax, 0x2790
  0x12394: push     ax
  0x12395: push     di
  0x12396: lcall    0xd1d, 0x7e4
  0x1239B: add      sp, 4
  0x1239E: push     ax
  0x1239F: lcall    0xd1d, 0xc56
  0x123A4: add      sp, 4
  0x123A7: mov      di, ax
  0x123A9: sub      si, si
  0x123AB: jmp      0x123c9
  0x123AD: nop      
  0x123AE: mov      al, byte ptr [si + 0x27bb]
  0x123B2: mov      cl, 4
  0x123B4: mov      dx, ax
  0x123B6: sar      al, cl
  0x123B8: and      al, 0xf
  0x123BA: add      al, 0x41
  0x123BC: mov      byte ptr [di], al
  0x123BE: inc      di
  0x123BF: and      dl, 0xf
  0x123C2: add      dl, 0x41
  0x123C5: mov      byte ptr [di], dl
  0x123C7: inc      di
  0x123C8: inc      si
  0x123C9: mov      ax, word ptr [bp - 2]
  0x123CC: dec      word ptr [bp - 2]
  0x123CF: or       ax, ax
  0x123D1: jne      0x123ae
  0x123D3: mov      byte ptr [di], 0
  0x123D6: inc      di
  0x123D7: mov      byte ptr [di], 0
  0x123DA: inc      di
  0x123DB: cmp      word ptr [bp + 0x10], 0
  0x123DF: je       0x123f5
  0x123E1: mov      byte ptr [di], 1
  0x123E4: inc      di
  0x123E5: mov      byte ptr [di], 0
  0x123E8: inc      di
  0x123E9: push     word ptr [bp + 0x10]
  0x123EC: push     di
  0x123ED: lcall    0xd1d, 0x7e4
  0x123F2: add      sp, 4
  0x123F5: sub      si, si
  0x123F7: mov      di, word ptr [bp + 0xe]
  0x123FA: inc      di
  0x123FB: cmp      word ptr [bp + 0x12], si
  0x123FE: je       0x1243c
  0x12400: sub      ax, ax
  0x12402: push     ax
  0x12403: push     word ptr [bp + 0x12]
  0x12406: push     ax
  0x12407: mov      ax, 0x2b02
  0x1240A: push     ax
  0x1240B: push     di
  0x1240C: lcall    0xd1d, 0x7e4
  0x12411: add      sp, 4
  0x12414: push     ax
  0x12415: lcall    0xd1d, 0xc56
  0x1241A: add      sp, 4
  0x1241D: mov      di, ax
  0x1241F: push     di
  0x12420: lcall    0xd1d, 0x7e4
  0x12425: add      sp, 4
  0x12428: push     ax
  0x12429: lcall    0xd1d, 0xc56
  0x1242E: add      sp, 4
  0x12431: sub      ax, 4
  0x12434: mov      di, ax
  0x12436: mov      si, ax
  0x12438: sub      si, word ptr [bp + 0xe]
  0x1243B: dec      si
  0x1243C: mov      bx, word ptr [bp + 6]
  0x1243F: cmp      word ptr [bx], 0
  0x12442: je       0x124c2
  0x12444: cmp      word ptr [bx + 2], 0
  0x12448: je       0x1244f
  0x1244A: mov      byte ptr [di], 0x20
  0x1244D: inc      di
  0x1244E: inc      si
  0x1244F: mov      ax, bx

============================================================
func_L485 at file 0x124D6, 43 bytes
============================================================
  0x124D6: push     bp
  0x124D7: mov      bp, sp
  0x124D9: push     si
  0x124DA: push     di
  0x124DB: push     ds
  0x124DC: pop      ds
  0x124DD: mov      bx, 0xffff
  0x124E0: mov      ah, 0x48
  0x124E2: int      0x21
  0x124E4: cmp      al, 7
  0x124E6: je       0x1252a
  0x124E8: mov      bx, word ptr [0x27b2]
  0x124EC: mov      dx, bx
  0x124EE: dec      bx
  0x124EF: xor      cx, cx
  0x124F1: push     ds
  0x124F2: mov      ds, bx
  0x124F4: mov      ax, word ptr [1]
  0x124F7: cmp      ax, dx
  0x124F9: je       0x12501
  0x124FB: or       ax, ax
  0x124FD: jne      0x12513
  0x124FF: mov      cx, bx

============================================================
func_L486 at file 0x1285A, 168 bytes
============================================================
  0x1285A: push     bp
  0x1285B: mov      bp, sp
  0x1285D: mov      dx, word ptr [bp + 6]
  0x12860: mov      ax, 0x4300
  0x12863: int      0x21
  0x12865: jb       0x12876
  0x12867: test     byte ptr [bp + 8], 2
  0x1286B: je       0x12876
  0x1286D: test     cl, 1
  0x12870: je       0x12876
  0x12872: mov      ax, 0xd00
  0x12875: stc      
  0x12876: jmp      0x10ad0
  0x12879: add      al, cl
  0x1287B: add      al, 0
  0x1287D: add      byte ptr [0x561e], al
  0x12881: push     di
  0x12882: xor      ax, ax
  0x12884: mov      word ptr [bp - 4], ax
  0x12887: mov      bx, 0xffff
  0x1288A: mov      ah, 0x48
  0x1288C: int      0x21
  0x1288E: jb       0x12893
  0x12890: jmp      0x12913
  0x12893: sub      bx, 2
  0x12896: mov      word ptr [bp - 2], bx
  0x12899: mov      ah, 0x48
  0x1289B: int      0x21
  0x1289D: jae      0x128a2
  0x1289F: jmp      0x12920
  0x128A1: nop      
  0x128A2: mov      word ptr [bp - 4], ax
  0x128A5: push     ax
  0x128A6: dec      ax
  0x128A7: mov      es, ax
  0x128A9: mov      di, 8
  0x128AC: mov      si, 0x26ab
  0x128AF: mov      cx, 8
  0x128B2: rep movsb byte ptr es:[di], byte ptr [si]
  0x128B4: pop      ax
  0x128B5: push     bp
  0x128B6: mov      cx, ss
  0x128B8: mov      word ptr [0x26a3], cx
  0x128BC: mov      word ptr [0x26a5], sp
  0x128C0: push     ds
  0x128C1: pop      es
  0x128C2: mov      bx, 0x26a7
  0x128C5: mov      word ptr [bx], ax
  0x128C7: mov      word ptr [bx + 2], ax
  0x128CA: lds      dx, ptr [bp + 6]
  0x128CD: mov      al, 3
  0x128CF: mov      ah, 0x4b
  0x128D1: int      0x21
  0x128D3: mov      dx, 0x1b5a
  0x128D6: mov      ds, dx
  0x128D8: mov      dx, word ptr [0x26a3]
  0x128DC: mov      ss, dx
  0x128DE: mov      sp, word ptr [0x26a5]
  0x128E2: pop      bp
  0x128E3: jb       0x12913
  0x128E5: mov      es, word ptr [0x26a7]
  0x128E9: mov      bx, word ptr es:[0x2a]
  0x128EE: mov      ax, word ptr es:[0x2c]
  0x128F2: add      ax, 0xf
  0x128F5: rcr      ax, 1
  0x128F7: shr      ax, 3
  0x128FA: add      bx, ax
  0x128FC: mov      ax, es
  0x128FE: sub      bx, ax

============================================================
func_L487 at file 0x12928, 49 bytes
============================================================
  0x12928: enter    0, 0
  0x1292C: push     es
  0x1292D: push     ds
  0x1292E: push     si
  0x1292F: push     di
  0x12930: mov      byte ptr [0x26a2], 0xff
  0x12935: mov      dx, word ptr [bp + 6]
  0x12938: or       dx, dx
  0x1293A: je       0x12953
  0x1293C: mov      si, 0x32
  0x1293F: mov      di, 0xa654
  0x12942: mov      ax, 0x1b5a
  0x12945: mov      es, ax
  0x12947: mov      cx, 5
  0x1294A: mov      ds, dx
  0x1294C: mov      ax, word ptr [0x28]
  0x1294F: movsw    word ptr es:[di], word ptr [si]
  0x12950: stosw    word ptr es:[di], ax
  0x12951: loop     0x1294f
  0x12953: pop      di
  0x12954: pop      si
  0x12955: pop      ds
  0x12956: pop      es
  0x12957: leave    
  0x12958: retf     

============================================================
func_L488 at file 0x12959, 26 bytes
============================================================
  0x12959: enter    0, 0
  0x1295D: push     es
  0x1295E: mov      ax, word ptr [bp + 6]
  0x12961: or       ax, ax
  0x12963: je       0x12970
  0x12965: mov      es, ax
  0x12967: mov      ah, 0x49
  0x12969: int      0x21
  0x1296B: lcall    0x1047, 0x106
  0x12970: pop      es
  0x12971: leave    
  0x12972: retf     

============================================================
func_L489 at file 0x129B1, 16 bytes
============================================================
  0x129B1: push     bp
  0x129B2: mov      bp, sp
  0x129B4: mov      ax, word ptr [bp + 6]
  0x129B7: mov      word ptr [bx + 0x26b4], ax
  0x129BB: inc      byte ptr [0x26c4]
  0x129BF: pop      bp
  0x129C0: retf     

============================================================
func_L490 at file 0x129FC, 57 bytes
============================================================
  0x129FC: enter    4, 0
  0x12A00: push     di
  0x12A01: push     si
  0x12A02: mov      di, ax
  0x12A04: mov      byte ptr [bp - 1], 0x4e
  0x12A08: sub      dx, dx
  0x12A0A: mov      si, 0x26f0
  0x12A0D: mov      cx, word ptr [bp - 4]
  0x12A10: cmp      si, 0x2770
  0x12A14: jae      0x12a2e
  0x12A16: mov      al, byte ptr [si]
  0x12A18: sub      ah, ah
  0x12A1A: cmp      ax, di
  0x12A1C: jne      0x12a27
  0x12A1E: mov      dx, 0xffff
  0x12A21: mov      al, byte ptr [si + 6]
  0x12A24: mov      byte ptr [bp - 1], al
  0x12A27: add      si, 8
  0x12A2A: or       dx, dx
  0x12A2C: je       0x12a10
  0x12A2E: mov      al, byte ptr [bp - 1]
  0x12A31: pop      si
  0x12A32: pop      di
  0x12A33: leave    
  0x12A34: retf     

============================================================
func_L491 at file 0x12A36, 37 bytes
============================================================
  0x12A36: push     bp
  0x12A37: mov      bp, sp
  0x12A39: push     ax
  0x12A3A: push     di
  0x12A3B: mov      di, 0xffff
  0x12A3E: sub      dx, dx
  0x12A40: mov      cx, dx
  0x12A42: mov      bx, 0x26f0
  0x12A45: cmp      bx, 0x2770
  0x12A49: jae      0x12a61
  0x12A4B: mov      al, byte ptr [bx]
  0x12A4D: sub      ah, ah
  0x12A4F: cmp      ax, word ptr [bp - 2]
  0x12A52: jne      0x12a59
  0x12A54: mov      cx, 0xffff
  0x12A57: mov      di, dx

============================================================
func_L492 at file 0x12A66, 65 bytes
============================================================
  0x12A66: enter    2, 0
  0x12A6A: push     di
  0x12A6B: push     si
  0x12A6C: les      di, ptr [bp + 6]
  0x12A6F: mov      cx, word ptr es:[di]
  0x12A72: mov      ax, word ptr [0xa630]
  0x12A75: mov      dx, word ptr [0xa632]
  0x12A79: cmp      dx, -1
  0x12A7C: je       0x12a9a
  0x12A7E: push     ax
  0x12A7F: or       ax, dx
  0x12A81: pop      ax
  0x12A82: je       0x12aba
  0x12A84: or       dx, dx
  0x12A86: jne      0x12a8e
  0x12A88: cmp      cx, ax
  0x12A8A: jbe      0x12a8e
  0x12A8C: mov      cx, ax
  0x12A8E: sub      ax, cx
  0x12A90: sbb      dx, 0
  0x12A93: mov      word ptr [0xa630], ax
  0x12A96: mov      word ptr [0xa632], dx
  0x12A9A: add      word ptr [0xa634], cx
  0x12A9E: adc      word ptr [0xa636], 0
  0x12AA3: mov      ax, cx
  0x12AA5: or       cx, cx

============================================================
func_L493 at file 0x12ADA, 110 bytes
============================================================
  0x12ADA: push     bp
  0x12ADB: mov      bp, sp
  0x12ADD: push     di
  0x12ADE: push     si
  0x12ADF: les      di, ptr [bp + 6]
  0x12AE2: mov      cx, word ptr es:[di]
  0x12AE5: mov      ax, word ptr [0xa62c]
  0x12AE8: mov      dx, word ptr [0xa62e]
  0x12AEC: cmp      dx, -1
  0x12AEF: je       0x12b0d
  0x12AF1: push     ax
  0x12AF2: or       ax, dx
  0x12AF4: pop      ax
  0x12AF5: je       0x12b2d
  0x12AF7: or       dx, dx
  0x12AF9: jne      0x12b01
  0x12AFB: cmp      cx, ax
  0x12AFD: jbe      0x12b01
  0x12AFF: mov      cx, ax
  0x12B01: sub      ax, cx
  0x12B03: sbb      dx, 0
  0x12B06: mov      word ptr [0xa62c], ax
  0x12B09: mov      word ptr [0xa62e], dx
  0x12B0D: add      word ptr [0xa628], cx
  0x12B11: adc      word ptr [0xa62a], 0
  0x12B16: mov      ax, cx
  0x12B18: or       cx, cx
  0x12B1A: je       0x12b2d
  0x12B1C: push     ds
  0x12B1D: les      di, ptr [0xa63e]
  0x12B21: lds      si, ptr [bp + 0xa]
  0x12B24: rep movsb byte ptr es:[di], byte ptr [si]
  0x12B26: mov      dx, di
  0x12B28: pop      ds
  0x12B29: mov      word ptr [0xa63e], dx
  0x12B2D: push     word ptr [0xa640]
  0x12B31: push     word ptr [0xa63e]
  0x12B35: lcall    0xc05, 4
  0x12B3A: mov      word ptr [0xa63e], ax
  0x12B3D: mov      word ptr [0xa640], dx
  0x12B41: pop      si
  0x12B42: pop      di
  0x12B43: leave    
  0x12B44: retf     8
  0x12B47: nop      

============================================================
func_L494 at file 0x12B48, 324 bytes
============================================================
  0x12B48: push     bp
  0x12B49: mov      bp, sp
  0x12B4B: push     si
  0x12B4C: cmp      word ptr [0xa632], 0
  0x12B51: jl       0x12b74
  0x12B53: les      bx, ptr [bp + 6]
  0x12B56: mov      ax, word ptr es:[bx]
  0x12B59: sub      dx, dx
  0x12B5B: cmp      dx, word ptr [0xa632]
  0x12B5F: jl       0x12b70
  0x12B61: jg       0x12b69
  0x12B63: cmp      ax, word ptr [0xa630]
  0x12B67: jbe      0x12b70
  0x12B69: mov      dx, word ptr [0xa632]
  0x12B6D: mov      ax, word ptr [0xa630]
  0x12B70: mov      si, ax
  0x12B72: jmp      0x12b7a
  0x12B74: les      bx, ptr [bp + 6]
  0x12B77: mov      si, word ptr es:[bx]
  0x12B7A: or       si, si
  0x12B7C: je       0x12bba
  0x12B7E: push     word ptr [bp + 0xc]
  0x12B81: push     word ptr [bp + 0xa]
  0x12B84: push     0
  0x12B86: push     si
  0x12B87: mov      ax, 1
  0x12B8A: cdq      
  0x12B8B: mov      bx, word ptr [0xa642]
  0x12B8F: lcall    0xb01, 0xe
  0x12B94: mov      si, ax
  0x12B96: cmp      word ptr [0xa632], 0
  0x12B9B: jl       0x12bb0
  0x12B9D: jg       0x12ba6
  0x12B9F: cmp      word ptr [0xa630], 0
  0x12BA4: je       0x12bb0
  0x12BA6: sub      ax, ax
  0x12BA8: sub      word ptr [0xa630], si
  0x12BAC: sbb      word ptr [0xa632], ax
  0x12BB0: sub      ax, ax
  0x12BB2: add      word ptr [0xa634], si
  0x12BB6: adc      word ptr [0xa636], ax
  0x12BBA: mov      ax, si
  0x12BBC: pop      si
  0x12BBD: leave    
  0x12BBE: retf     8
  0x12BC1: nop      
  0x12BC2: enter    4, 0
  0x12BC6: push     si
  0x12BC7: cmp      word ptr [0xa62e], 0
  0x12BCC: jl       0x12bf0
  0x12BCE: les      bx, ptr [bp + 6]
  0x12BD1: mov      ax, word ptr es:[bx]
  0x12BD4: sub      dx, dx
  0x12BD6: cmp      dx, word ptr [0xa62e]
  0x12BDA: jl       0x12beb
  0x12BDC: jg       0x12be4
  0x12BDE: cmp      ax, word ptr [0xa62c]
  0x12BE2: jbe      0x12beb
  0x12BE4: mov      dx, word ptr [0xa62e]
  0x12BE8: mov      ax, word ptr [0xa62c]
  0x12BEB: mov      si, ax
  0x12BED: jmp      0x12bf6
  0x12BEF: nop      
  0x12BF0: les      bx, ptr [bp + 6]
  0x12BF3: mov      si, word ptr es:[bx]
  0x12BF6: or       si, si
  0x12BF8: je       0x12c4c
  0x12BFA: push     word ptr [bp + 0xc]
  0x12BFD: push     word ptr [bp + 0xa]
  0x12C00: push     0
  0x12C02: push     1
  0x12C04: mov      ax, si
  0x12C06: sub      dx, dx
  0x12C08: mov      word ptr [bp - 4], ax
  0x12C0B: mov      word ptr [bp - 2], dx
  0x12C0E: mov      bx, word ptr [0xa638]
  0x12C12: lcall    0x1a1f, 0xc9c
  0x12C17: or       dx, ax
  0x12C19: jne      0x12c20
  0x12C1B: sub      si, si
  0x12C1D: jmp      0x12c4c
  0x12C1F: nop      
  0x12C20: cmp      word ptr [0xa62e], 0
  0x12C25: jl       0x12c3e
  0x12C27: jg       0x12c30
  0x12C29: cmp      word ptr [0xa62c], 0
  0x12C2E: je       0x12c3e
  0x12C30: mov      ax, word ptr [bp - 4]
  0x12C33: mov      dx, word ptr [bp - 2]
  0x12C36: sub      word ptr [0xa62c], ax
  0x12C3A: sbb      word ptr [0xa62e], dx
  0x12C3E: mov      ax, word ptr [bp - 4]
  0x12C41: mov      dx, word ptr [bp - 2]
  0x12C44: add      word ptr [0xa628], ax
  0x12C48: adc      word ptr [0xa62a], dx
  0x12C4C: mov      ax, si
  0x12C4E: pop      si
  0x12C4F: leave    
  0x12C50: retf     8
  0x12C53: nop      
  0x12C54: mov      word ptr [0x26ca], 1
  0x12C5A: mov      byte ptr [0x26c9], 0xff
  0x12C5F: sub      ax, ax
  0x12C61: mov      word ptr [0x26d6], ax
  0x12C64: mov      word ptr [0x26d4], ax
  0x12C67: mov      word ptr [0x26d8], 0x14
  0x12C6D: mov      word ptr [0x26da], 0x1b1f
  0x12C73: mov      word ptr [0x26dc], 0xa
  0x12C79: mov      word ptr [0x26de], 0x1b1f
  0x12C7F: mov      word ptr [0x26e0], 0
  0x12C85: mov      word ptr [0x26e2], 0x1b1f
  0x12C8B: retf     

============================================================
func_L495 at file 0x12C8C, 57 bytes
============================================================
  0x12C8C: enter    2, 0
  0x12C90: push     ax
  0x12C91: push     word ptr [bp + 8]
  0x12C94: push     word ptr [bp + 6]
  0x12C97: lcall    0xd1d, 0x113c
  0x12C9C: add      sp, 4
  0x12C9F: mov      word ptr [bp - 2], ax
  0x12CA2: push     ds
  0x12CA3: mov      cx, word ptr [bp - 2]
  0x12CA6: mov      bx, 1
  0x12CA9: lds      dx, ptr [bp + 6]
  0x12CAC: mov      ah, 0x40
  0x12CAE: int      0x21
  0x12CB0: pop      ds
  0x12CB1: mov      ax, word ptr [bp - 4]
  0x12CB4: or       ax, ax
  0x12CB6: je       0x12cc4
  0x12CB8: mov      dl, 0xa
  0x12CBA: mov      ah, 2
  0x12CBC: int      0x21
  0x12CBE: mov      dl, 0xd
  0x12CC0: mov      ah, 2
  0x12CC2: int      0x21
  0x12CC4: leave    

============================================================
func_L496 at file 0x12CC8, 130 bytes
============================================================
  0x12CC8: enter    4, 0
  0x12CCC: mov      word ptr [0x26e4], 0
  0x12CD2: cmp      word ptr [0x26e6], 0
  0x12CD7: jne      0x12d03
  0x12CD9: mov      ax, 0x4300
  0x12CDC: int      0x2f
  0x12CDE: cmp      al, 0x80
  0x12CE0: jne      0x12d03
  0x12CE2: mov      ax, 0x4310
  0x12CE5: int      0x2f
  0x12CE7: mov      word ptr [0x26e8], bx
  0x12CEB: mov      word ptr [0x26ea], es
  0x12CEF: xor      ah, ah
  0x12CF1: lcall    [0x26e8]
  0x12CF5: mov      word ptr [0xa668], ax
  0x12CF8: cmp      ax, 0x200
  0x12CFB: jb       0x12d03
  0x12CFD: mov      word ptr [0x26e4], 0xffff
  0x12D03: mov      word ptr [0x2666], 0xffff
  0x12D09: mov      word ptr [0x2668], 0xffff
  0x12D0F: mov      byte ptr [0x264e], 0
  0x12D14: cmp      word ptr [0x26e4], 0
  0x12D19: je       0x12d45
  0x12D1B: push     0
  0x12D1D: push     1
  0x12D1F: lcall    0x1103, 0xa
  0x12D24: add      sp, 4
  0x12D27: mov      word ptr [bp - 4], ax
  0x12D2A: mov      word ptr [bp - 2], dx
  0x12D2D: or       dx, ax
  0x12D2F: je       0x12d45
  0x12D31: les      ax, ptr [bp - 4]
  0x12D34: mov      ax, es
  0x12D36: dec      ax
  0x12D37: mov      word ptr [0x26ec], ax
  0x12D3A: push     word ptr [bp - 2]
  0x12D3D: push     word ptr [bp - 4]
  0x12D40: lcall    0x1103, 0x4c
  0x12D45: mov      ax, word ptr [0x26e4]
  0x12D48: leave    
  0x12D49: retf     

============================================================
func_L497 at file 0x12D4A, 92 bytes
============================================================
  0x12D4A: enter    4, 0
  0x12D4E: push     di
  0x12D4F: push     si
  0x12D50: push     word ptr [bp + 8]
  0x12D53: push     word ptr [bp + 6]
  0x12D56: lcall    0xd1d, 0x113c
  0x12D5B: add      sp, 4
  0x12D5E: mov      si, 0xffff
  0x12D61: push     word ptr [bp + 8]
  0x12D64: push     word ptr [bp + 6]
  0x12D67: lcall    0xd1d, 0x113c
  0x12D6C: add      sp, 4
  0x12D6F: mov      bx, ax
  0x12D71: add      bx, word ptr [bp + 6]
  0x12D74: mov      es, word ptr [bp + 8]
  0x12D77: dec      bx
  0x12D78: mov      di, bx
  0x12D7A: mov      word ptr [bp - 2], es
  0x12D7D: cmp      byte ptr es:[bx], 0x20
  0x12D81: je       0x12d8e
  0x12D83: cmp      byte ptr es:[di], 9
  0x12D87: je       0x12d8e
  0x12D89: sub      si, si
  0x12D8B: jmp      0x12d95
  0x12D8D: nop      
  0x12D8E: mov      es, word ptr [bp - 2]
  0x12D91: mov      byte ptr es:[di], 0
  0x12D95: lea      ax, [di - 1]
  0x12D98: cmp      ax, word ptr [bp + 6]
  0x12D9B: jae      0x12d9f
  0x12D9D: sub      si, si
  0x12D9F: or       si, si
  0x12DA1: jne      0x12d5e
  0x12DA3: pop      si
  0x12DA4: pop      di
  0x12DA5: leave    

============================================================
func_L498 at file 0x12DAA, 66 bytes
============================================================
  0x12DAA: enter    4, 0
  0x12DAE: push     bx
  0x12DAF: push     di
  0x12DB0: push     si
  0x12DB1: sub      di, di
  0x12DB3: cmp      byte ptr [bx], 0
  0x12DB6: je       0x12e07
  0x12DB8: mov      al, byte ptr [bx]
  0x12DBA: cwde     
  0x12DBB: mov      si, ax
  0x12DBD: inc      word ptr [bp - 6]
  0x12DC0: test     byte ptr [si + 0x27ed], 2
  0x12DC5: je       0x12dca
  0x12DC7: sub      si, 0x20
  0x12DCA: test     byte ptr [si + 0x27ed], 4
  0x12DCF: je       0x12ddc
  0x12DD1: shl      di, 4
  0x12DD4: lea      ax, [si - 0x30]
  0x12DD7: add      di, ax
  0x12DD9: jmp      0x12dff
  0x12DDB: nop      
  0x12DDC: cmp      si, 0x41
  0x12DDF: jl       0x12dee
  0x12DE1: cmp      si, 0x46
  0x12DE4: jg       0x12dee
  0x12DE6: shl      di, 4
  0x12DE9: lea      ax, [si - 0x37]

============================================================
func_L499 at file 0x12E56, 29 bytes
============================================================
  0x12E56: enter    0, 0
  0x12E5A: push     si
  0x12E5B: push     di
  0x12E5C: push     ds
  0x12E5D: les      ax, ptr [bp + 6]
  0x12E60: add      ax, 0xf
  0x12E63: shr      ax, 4
  0x12E66: mov      dx, es
  0x12E68: add      dx, ax
  0x12E6A: jne      0x12e76
  0x12E6C: mov      ax, 0x382c
  0x12E6F: pop      ds
  0x12E70: pop      di
  0x12E71: pop      si
  0x12E72: leave    

============================================================
func_L500 at file 0x12EE0, 60 bytes
============================================================
  0x12EE0: enter    0x5a2, 0
  0x12EE4: mov      cl, ah
  0x12EE6: mov      ax, 1
  0x12EE9: shl      ax, cl
  0x12EEB: mov      word ptr [8], ax
  0x12EEE: sub      cl, 4
  0x12EF1: mov      ax, 1
  0x12EF4: shl      ax, cl
  0x12EF6: mov      word ptr [0xa], ax
  0x12EF9: sub      cl, 4
  0x12EFC: mov      al, 0xff
  0x12EFE: shl      al, cl
  0x12F00: mov      byte ptr [6], al
  0x12F03: cmp      si, 0x81b
  0x12F07: jb       0x12f0c
  0x12F09: call     0x13013
  0x12F0C: lodsw    ax, word ptr [si]
  0x12F0D: mov      bp, ax
  0x12F0F: mov      dx, 0x10
  0x12F12: jmp      0x12f1f
  0x12F14: nop      
  0x12F15: mov      ax, 0x16
  0x12F18: pop      ds
  0x12F19: pop      di
  0x12F1A: pop      si
  0x12F1B: leave    

============================================================
func_L501 at file 0x130A4, 29 bytes
============================================================
  0x130A4: enter    0, 0
  0x130A8: push     si
  0x130A9: push     di
  0x130AA: push     ds
  0x130AB: les      ax, ptr [bp + 6]
  0x130AE: add      ax, 0xf
  0x130B1: shr      ax, 4
  0x130B4: mov      dx, es
  0x130B6: add      dx, ax
  0x130B8: jne      0x130c4
  0x130BA: mov      ax, 0x820
  0x130BD: pop      ds
  0x130BE: pop      di
  0x130BF: pop      si
  0x130C0: leave    

============================================================
func_L502 at file 0x1311B, 60 bytes
============================================================
  0x1311B: enter    0x5a2, 0
  0x1311F: mov      cl, ah
  0x13121: mov      ax, 1
  0x13124: shl      ax, cl
  0x13126: mov      word ptr [8], ax
  0x13129: sub      cl, 4
  0x1312C: mov      ax, 1
  0x1312F: shl      ax, cl
  0x13131: mov      word ptr [0xa], ax
  0x13134: sub      cl, 4
  0x13137: mov      al, 0xff
  0x13139: shl      al, cl
  0x1313B: mov      byte ptr [6], al
  0x1313E: cmp      si, 0x80f
  0x13142: jb       0x13147
  0x13144: call     0x13274
  0x13147: lodsw    ax, word ptr [si]
  0x13148: mov      bp, ax
  0x1314A: mov      dx, 0x10
  0x1314D: jmp      0x1315a
  0x1314F: nop      
  0x13150: mov      ax, 0x16
  0x13153: pop      ds
  0x13154: pop      di
  0x13155: pop      si
  0x13156: leave    

============================================================
func_L503 at file 0x132B0, 23 bytes
============================================================
  0x132B0: enter    0, 0
  0x132B4: push     si
  0x132B5: push     di
  0x132B6: push     ds
  0x132B7: les      di, ptr [bp + 6]
  0x132BA: mov      ax, es
  0x132BC: or       ax, di
  0x132BE: jne      0x132ca
  0x132C0: mov      ax, 4
  0x132C3: pop      ds
  0x132C4: pop      di
  0x132C5: pop      si
  0x132C6: leave    

============================================================
func_L504 at file 0x1340E, 38 bytes
============================================================
  0x1340E: push     bp
  0x1340F: mov      bp, sp
  0x13411: mov      ax, word ptr [0x26e4]
  0x13414: or       ax, ax
  0x13416: je       0x13434
  0x13418: mov      ah, 0x10
  0x1341A: mov      dx, 0xffff
  0x1341D: lcall    [0x26e8]
  0x13421: or       al, al
  0x13423: jne      0x13434
  0x13425: cmp      bl, 0xb0
  0x13428: jne      0x13434
  0x1342A: mov      ax, dx
  0x1342C: shl      ax, 4
  0x1342F: shr      dx, 0xc
  0x13432: leave    
  0x13433: retf     

============================================================
func_L505 at file 0x1343A, 65 bytes
============================================================
  0x1343A: push     bp
  0x1343B: mov      bp, sp
  0x1343D: xor      ax, ax
  0x1343F: xor      dx, dx
  0x13441: mov      bx, word ptr [0x2770]
  0x13445: cmp      bx, 0x10
  0x13448: jge      0x13479
  0x1344A: mov      ax, word ptr [bp + 6]
  0x1344D: dec      ax
  0x1344E: shr      ax, 4
  0x13451: inc      ax
  0x13452: mov      dx, word ptr [bp + 8]
  0x13455: shl      dx, 0xc
  0x13458: add      dx, ax
  0x1345A: mov      ah, 0x10
  0x1345C: lcall    [0x26e8]
  0x13460: xor      dx, dx
  0x13462: or       al, al
  0x13464: je       0x13479
  0x13466: mov      dx, bx
  0x13468: xor      ax, ax
  0x1346A: mov      bx, word ptr [0x2770]
  0x1346E: inc      word ptr [0x2770]
  0x13472: shl      bx, 2
  0x13475: mov      word ptr [bx - 0x5996], dx
  0x13479: leave    
  0x1347A: retf     

============================================================
func_L506 at file 0x1347C, 23 bytes
============================================================
  0x1347C: push     bp
  0x1347D: mov      bp, sp
  0x1347F: mov      dx, word ptr [bp + 8]
  0x13482: mov      bx, 0xa66a
  0x13485: mov      cx, word ptr [0x2770]
  0x13489: jcxz     0x134a9
  0x1348B: mov      ax, word ptr [bx]
  0x1348D: cmp      ax, dx
  0x1348F: je       0x13498

============================================================
func_L507 at file 0x13A10, 32 bytes
============================================================
  0x13A10: enter    -0x167f, 0
  0x13A14: mov      al, byte ptr [0x1972]
  0x13A17: cmp      cx, word ptr cs:[0x4fd7]
  0x13A1C: jb       0x13a30
  0x13A1E: mov      cl, ch
  0x13A20: shr      cl, 1
  0x13A22: shr      cl, 1
  0x13A24: xor      bx, bx
  0x13A26: cmp      cl, 0x10
  0x13A29: jb       0x13a2f
  0x13A2B: inc      bx
  0x13A2C: sub      cl, 8
  0x13A2F: ret      

============================================================
func_L508 at file 0x13B4E, 17 bytes
============================================================
  0x13B4E: push     bp
  0x13B4F: mov      bp, sp
  0x13B51: pushf    
  0x13B52: push     ax
  0x13B53: mov      ax, word ptr cs:[0x5da5]
  0x13B57: sub      ax, word ptr cs:[0x5da7]
  0x13B5C: dec      ax
  0x13B5D: cmp      ax, bx

============================================================
func_L509 at file 0x13B9F, 22 bytes
============================================================
  0x13B9F: push     bp
  0x13BA0: mov      bp, sp
  0x13BA2: push     ax
  0x13BA3: push     bx
  0x13BA4: pushf    
  0x13BA5: pop      ax
  0x13BA6: mov      word ptr [bp + 6], ax
  0x13BA9: mov      ax, word ptr cs:[0x5da5]
  0x13BAD: add      ax, word ptr cs:[0x5da3]
  0x13BB2: inc      ax
  0x13BB3: mov      bx, es

============================================================
func_L510 at file 0x15094, 69 bytes
============================================================
  0x15094: push     bp
  0x15095: mov      bp, sp
  0x15097: cld      
  0x15098: mov      ax, word ptr [bp + 6]
  0x1509B: pop      bp
  0x1509C: test     ax, 0x7fff
  0x1509F: je       0x150d9
  0x150A1: or       ax, ax
  0x150A3: lcall    0x110d, 0x1341
  0x150A8: ljmp     0x110d:0x1bdd
  0x150AD: js       0x150c0
  0x150AF: call     0x15113
  0x150B2: jb       0x150d5
  0x150B4: call     0x189a0
  0x150B7: add      word ptr cs:[0x39b7], ax
  0x150BC: xor      ax, ax
  0x150BE: jmp      0x150d8
  0x150C0: push     ax
  0x150C1: neg      ax
  0x150C3: call     0x1892f
  0x150C6: sub      word ptr cs:[0x39b7], ax
  0x150CB: pop      ax
  0x150CC: jb       0x150d5
  0x150CE: call     0x15113
  0x150D1: xor      ax, ax
  0x150D3: jmp      0x150d8
  0x150D5: mov      ax, 1
  0x150D8: retf     

============================================================
func_L511 at file 0x15131, 20 bytes
============================================================
  0x15131: push     bp
  0x15132: mov      bp, sp
  0x15134: push     ds
  0x15135: push     si
  0x15136: push     ax
  0x15137: lds      si, ptr [bp + 6]
  0x1513A: mov      ax, word ptr cs:[0x3952]
  0x1513E: mov      word ptr [si], ax
  0x15140: pop      ax
  0x15141: pop      si
  0x15142: pop      ds
  0x15143: pop      bp
  0x15144: retf     

============================================================
func_L512 at file 0x15145, 19 bytes
============================================================
  0x15145: push     bp
  0x15146: mov      bp, sp
  0x15148: push     ds
  0x15149: push     si
  0x1514A: push     es
  0x1514B: push     di
  0x1514C: lds      si, ptr [bp + 6]
  0x1514F: call     0x15219
  0x15152: pop      di
  0x15153: pop      es
  0x15154: pop      si
  0x15155: pop      ds
  0x15156: pop      bp
  0x15157: retf     

============================================================
func_L513 at file 0x15166, 75 bytes
============================================================
  0x15166: push     bp
  0x15167: mov      bp, sp
  0x15169: push     si
  0x1516A: push     di
  0x1516B: push     es
  0x1516C: push     ds
  0x1516D: lds      si, ptr cs:[0x3952]
  0x15172: les      di, ptr [bp + 0xa]
  0x15175: mov      word ptr es:[di], si
  0x15178: add      di, 2
  0x1517B: or       si, si
  0x1517D: je       0x1518a
  0x1517F: push     cx
  0x15180: mov      cx, 0xa
  0x15183: sub      si, cx
  0x15185: rep movsb byte ptr es:[di], byte ptr [si]
  0x15187: pop      cx
  0x15188: jmp      0x151d7
  0x1518A: mov      si, word ptr cs:[0x395c]
  0x1518F: mov      word ptr es:[di + 6], si
  0x15193: mov      si, word ptr cs:[0x3958]
  0x15198: mov      word ptr es:[di + 4], si
  0x1519C: jmp      0x151d7
  0x1519E: and      byte ptr cs:[0x39de], 0xfb
  0x151A4: lcall    0x110d, 0x1341
  0x151A9: ljmp     0x110d:0x1cde
  0x151AE: sub      sp, 4

============================================================
func_L514 at file 0x151B1, 65 bytes
============================================================
  0x151B1: push     bp
  0x151B2: mov      bp, sp
  0x151B4: push     si
  0x151B5: push     di
  0x151B6: push     es
  0x151B7: push     ds
  0x151B8: lds      si, ptr [bp + 0xa]
  0x151BB: push     ds
  0x151BC: push     si
  0x151BD: call     0x15219
  0x151C0: pop      si
  0x151C1: pop      ds
  0x151C2: add      si, 2
  0x151C5: les      di, ptr cs:[0x3952]
  0x151CA: or       di, di
  0x151CC: je       0x151f2
  0x151CE: push     cx
  0x151CF: mov      cx, 0xa
  0x151D2: sub      di, cx
  0x151D4: rep movsb byte ptr es:[di], byte ptr [si]
  0x151D6: pop      cx
  0x151D7: mov      si, ss
  0x151D9: mov      ds, si
  0x151DB: mov      es, si
  0x151DD: lea      si, [bp + 0xe]
  0x151E0: lea      di, [bp + 2]
  0x151E3: cld      
  0x151E4: movsw    word ptr es:[di], word ptr [si]
  0x151E5: movsw    word ptr es:[di], word ptr [si]
  0x151E6: add      di, 4
  0x151E9: movsw    word ptr es:[di], word ptr [si]
  0x151EA: movsw    word ptr es:[di], word ptr [si]
  0x151EB: movsw    word ptr es:[di], word ptr [si]
  0x151EC: pop      ds
  0x151ED: pop      es
  0x151EE: pop      di
  0x151EF: pop      si
  0x151F0: pop      bp
  0x151F1: retf     

============================================================
func_L515 at file 0x16073, 19 bytes
============================================================
  0x16073: push     bp
  0x16074: mov      bp, sp
  0x16076: mov      ds, ax
  0x16078: call     0x16127
  0x1607B: test     word ptr es:[0], 6
  0x16082: je       0x16068
  0x16084: mov      bx, es

============================================================
func_L516 at file 0x16475, 18 bytes
============================================================
  0x16475: enter    -0x257d, 0
  0x16479: mov      ax, cx
  0x1647B: or       ax, dx
  0x1647D: jne      0x16444
  0x1647F: pop      ds
  0x16480: pop      dx
  0x16481: pop      cx
  0x16482: pop      bx
  0x16483: pop      ax
  0x16484: pop      di
  0x16485: pop      es
  0x16486: ret      

============================================================
func_L517 at file 0x17CD0, 23 bytes
============================================================
  0x17CD0: enter    -0x3e09, 0
  0x17CD4: cld      
  0x17CD5: jne      0x17cc3
  0x17CD7: or       ax, ax
  0x17CD9: je       0x17cc3
  0x17CDB: mov      cx, word ptr es:[6]
  0x17CE0: mov      dx, word ptr es:[8]
  0x17CE5: or       cx, cx

============================================================
func_L518 at file 0x19C3F, 43 bytes
============================================================
  0x19C3F: enter    0x3fe8, 0
  0x19C43: push     ax
  0x19C44: mov      dl, bl
  0x19C46: shr      dl, 1
  0x19C48: shr      dl, 1
  0x19C4A: and      dl, 3
  0x19C4D: mov      ax, cx
  0x19C4F: call     0x19c82
  0x19C52: sub      ax, cx
  0x19C54: neg      ax
  0x19C56: jns      0x19c5a
  0x19C58: xor      ax, ax
  0x19C5A: cmp      ax, cx
  0x19C5C: jb       0x19c60
  0x19C5E: mov      ax, cx
  0x19C60: pop      cx
  0x19C61: cmp      ax, cx
  0x19C63: jb       0x19c67
  0x19C65: mov      ax, cx
  0x19C67: pop      cx
  0x19C68: pop      dx
  0x19C69: ret      

============================================================
func_L519 at file 0x19E64, 11 bytes
============================================================
  0x19E64: push     bp
  0x19E65: mov      bp, sp
  0x19E67: mov      byte ptr cs:[0x56f], 0
  0x19E6D: mov      bx, cs

============================================================
func_L520 at file 0x1A283, 86 bytes
============================================================
  0x1A283: push     bp
  0x1A284: mov      bp, sp
  0x1A286: mov      es, ax
  0x1A288: mov      cx, word ptr es:[0x2c]
  0x1A28D: jcxz     0x1a2d0
  0x1A28F: mov      es, cx
  0x1A291: xor      di, di
  0x1A293: mov      al, byte ptr es:[di]
  0x1A296: or       al, al
  0x1A298: je       0x1a2d0
  0x1A29A: mov      si, word ptr [bp + 6]
  0x1A29D: lodsb    al, byte ptr [si]
  0x1A29E: or       al, al
  0x1A2A0: jne      0x1a2aa
  0x1A2A2: cmp      byte ptr es:[di], 0x3d
  0x1A2A6: je       0x1a2bb
  0x1A2A8: jmp      0x1a2b2
  0x1A2AA: mov      ah, byte ptr es:[di]
  0x1A2AD: inc      di
  0x1A2AE: cmp      al, ah
  0x1A2B0: je       0x1a29d
  0x1A2B2: xor      al, al
  0x1A2B4: mov      cx, 0xffff
  0x1A2B7: repne scasb al, byte ptr es:[di]
  0x1A2B9: jmp      0x1a293
  0x1A2BB: mov      ax, es
  0x1A2BD: mov      ds, ax
  0x1A2BF: mov      si, di
  0x1A2C1: inc      si
  0x1A2C2: mov      es, word ptr [bp + 2]
  0x1A2C5: mov      di, word ptr [bp + 8]
  0x1A2C8: lodsb    al, byte ptr [si]
  0x1A2C9: stosb    byte ptr es:[di], al
  0x1A2CA: or       al, al
  0x1A2CC: jne      0x1a2c8
  0x1A2CE: jmp      0x1a2d1
  0x1A2D0: stc      
  0x1A2D1: pop      bp
  0x1A2D2: pop      es
  0x1A2D3: pop      ds
  0x1A2D4: pop      si
  0x1A2D5: pop      di
  0x1A2D6: pop      cx
  0x1A2D7: pop      ax
  0x1A2D8: retf     

============================================================
func_L521 at file 0x1A425, 23 bytes
============================================================
  0x1A425: push     bp
  0x1A426: mov      bp, sp
  0x1A428: mov      di, ax
  0x1A42A: mov      ax, 0x3000
  0x1A42D: int      0x21
  0x1A42F: cmp      al, 3
  0x1A431: jae      0x1a43c
  0x1A433: stc      
  0x1A434: pop      bp
  0x1A435: pop      es
  0x1A436: pop      di
  0x1A437: pop      dx
  0x1A438: pop      cx
  0x1A439: pop      bx
  0x1A43A: pop      ax
  0x1A43B: retf     

============================================================
func_L522 at file 0x1A922, 307 bytes
============================================================
  0x1A922: enter    0, 0
  0x1A926: adc      ax, 0x5b00
  0x1A929: add      byte ptr [bp + si + 0xd91], bl
  0x1A92D: or       ax, 0xea11
  0x1A930: push     es
  0x1A931: add      byte ptr [bp + si - 0x65f5], ch
  0x1A935: stosw    word ptr es:[di], ax
  0x1A936: or       ax, 0x110d
  0x1A939: ljmp     0:0x4bc
  0x1A93E: adc      ax, 0x8300
  0x1A941: add      byte ptr [bp + si + 0xd91], bl
  0x1A945: or       ax, 0xea11
  0x1A948: cld      
  0x1A949: add      al, byte ptr [si - 0x65f7]
  0x1A94D: xchg     cx, ax
  0x1A94E: or       ax, 0x110d
  0x1A951: ljmp     0x24c:0xc
  0x1A956: lcall    0x110d, 0xd91
  0x1A95B: ljmp     0x24c:0x2a
  0x1A960: lcall    0x110d, 0xd91
  0x1A965: ljmp     0x24c:0x40
  0x1A96A: lcall    0x110d, 0xd91
  0x1A96F: ljmp     0x24c:0x7c
  0x1A974: lcall    0x110d, 0xd91
  0x1A979: ljmp     0x24c:0x13c
  0x1A97E: lcall    0x110d, 0xd91
  0x1A983: ljmp     0x262:0x128
  0x1A988: lcall    0x110d, 0xd91
  0x1A98D: ljmp     0x262:0x142
  0x1A992: lcall    0x110d, 0xd91
  0x1A997: ljmp     0x262:2
  0x1A99C: lcall    0x110d, 0xd91
  0x1A9A1: ljmp     0x262:0x2fe
  0x1A9A6: lcall    0x110d, 0xd91
  0x1A9AB: ljmp     0x262:0x12
  0x1A9B0: lcall    0x110d, 0xd91
  0x1A9B5: ljmp     0x262:0x60
  0x1A9BA: lcall    0x110d, 0xd91
  0x1A9BF: ljmp     0x262:0xf6
  0x1A9C4: lcall    0x110d, 0xdab
  0x1A9C9: ljmp     0:0x14e
  0x1A9CE: sbb      ax, 0x9a00
  0x1A9D1: xchg     cx, ax
  0x1A9D2: or       ax, 0x110d
  0x1A9D5: ljmp     0xae7:0x16
  0x1A9DA: lcall    0x110d, 0xd91
  0x1A9DF: ljmp     0x2d6:0
  0x1A9E4: lcall    0x110d, 0xd91
  0x1A9E9: ljmp     0xade:4
  0x1A9EE: lcall    0x110d, 0xdab
  0x1A9F3: ljmp     0:0x3744
  0x1A9F8: pop      ss
  0x1A9F9: add      byte ptr [bp + si + 0xdab], bl
  0x1A9FD: or       ax, 0xea11
  0x1AA00: div      byte ptr [bx]
  0x1AA02: add      byte ptr [bx + si], al
  0x1AA04: pop      ss
  0x1AA05: add      byte ptr [bp + si + 0xdab], bl
  0x1AA09: or       ax, 0xea11
  0x1AA0C: rol      byte ptr [bp + di], 1
  0x1AA0E: add      byte ptr [bx + si], al
  0x1AA10: pop      ss
  0x1AA11: add      byte ptr [bp + si + 0xdab], bl
  0x1AA15: or       ax, 0xea11
  0x1AA18: or       byte ptr [bp + si], al
  0x1AA1A: add      byte ptr [bx + si], al
  0x1AA1C: sbb      byte ptr [bx + si], al
  0x1AA1E: lcall    0x110d, 0xd91
  0x1AA23: ljmp     0x5b3:0x144
  0x1AA28: lcall    0x110d, 0xdab
  0x1AA2D: ljmp     0:0x3ec
  0x1AA32: pop      ss
  0x1AA33: add      byte ptr [bp + si + 0xd91], bl
  0x1AA37: or       ax, 0xea11
  0x1AA3A: push     es
  0x1AA3B: add      byte ptr [bx - 0x65f5], cl
  0x1AA3F: stosw    word ptr es:[di], ax
  0x1AA40: or       ax, 0x110d
  0x1AA43: ljmp     0:0xe
  0x1AA48: sbb      ax, word ptr [bx + si]
  0x1AA4A: insb     byte ptr es:[di], dx
  0x1AA4B: add      byte ptr [bp + si + 0xd91], bl
  0x1AA4F: or       ax, 0xea11
  0x1AA52: sbb      al, byte ptr [bx + di]
  0x1AA54: retf     

============================================================
func_L523 at file 0x1C0D6, 4162 bytes
============================================================
  0x1C0D6: enter    0x3d, 0
  0x1C0DA: add      al, 0
  0x1C0DC: add      byte ptr [bx + si], al
  0x1C0DE: lcall    0x110d, 0xdab
  0x1C0E3: ljmp     0:2
  0x1C0E8: or       byte ptr [bx + si], al
  0x1C0EA: cmp      byte ptr [bx + di], al
  0x1C0EC: lcall    0x110d, 0xdab
  0x1C0F1: ljmp     0:0x46d4
  0x1C0F6: add      al, 0
  0x1C0F8: add      byte ptr [bx + si], al
  0x1C0FA: lcall    0x110d, 0xdab
  0x1C0FF: ljmp     0:0x1cf4
  0x1C104: add      al, 0
  0x1C106: add      byte ptr [bx + si], al
  0x1C108: lcall    0x110d, 0xdab
  0x1C10D: ljmp     0:0x199e
  0x1C112: add      al, 0
  0x1C114: add      byte ptr [bx + si], al
  0x1C116: lcall    0x110d, 0xdab
  0x1C11B: ljmp     0:0x718
  0x1C120: add      al, 0
  0x1C122: add      byte ptr [bx + si], al
  0x1C124: lcall    0x110d, 0xdab
  0x1C129: ljmp     0:0x584a
  0x1C12E: add      al, 0
  0x1C130: add      byte ptr [bx + si], al
  0x1C132: lcall    0x110d, 0xdab
  0x1C137: ljmp     0:0x1fa2
  0x1C13C: add      al, 0
  0x1C13E: add      byte ptr [bx + si], al
  0x1C140: lcall    0x110d, 0xdab
  0x1C145: ljmp     0:0x19d8
  0x1C14A: add      al, 0
  0x1C14C: add      byte ptr [bx + si], al
  0x1C14E: lcall    0x110d, 0xdab
  0x1C153: ljmp     0:0xf5e
  0x1C158: add      al, 0
  0x1C15A: add      byte ptr [bx + si], al
  0x1C15C: lcall    0x110d, 0xdab
  0x1C161: ljmp     0:0x6024
  0x1C166: add      al, 0
  0x1C168: add      byte ptr [bx + si], al
  0x1C16A: lcall    0x110d, 0xdab
  0x1C16F: ljmp     0:0x5be8
  0x1C174: add      al, 0
  0x1C176: add      byte ptr [bx + si], al
  0x1C178: lcall    0x110d, 0xdab
  0x1C17D: ljmp     0:0x2a92
  0x1C182: add      al, 0
  0x1C184: add      byte ptr [bx + si], al
  0x1C186: lcall    0x110d, 0xdab
  0x1C18B: ljmp     0:0x19f8
  0x1C190: add      al, 0
  0x1C192: add      byte ptr [bx + si], al
  0x1C194: lcall    0x110d, 0xdab
  0x1C199: ljmp     0:0x3c86
  0x1C19E: add      al, 0
  0x1C1A0: add      byte ptr [bx + si], al
  0x1C1A2: lcall    0x110d, 0xdab
  0x1C1A7: ljmp     0:0x4b50
  0x1C1AC: add      al, 0
  0x1C1AE: add      byte ptr [bx + si], al
  0x1C1B0: lcall    0x110d, 0xdab
  0x1C1B5: ljmp     0:0x1456
  0x1C1BA: add      al, 0
  0x1C1BC: add      byte ptr [bx + si], al
  0x1C1BE: lcall    0x110d, 0xdab
  0x1C1C3: ljmp     0:0x44a4
  0x1C1C8: add      al, 0
  0x1C1CA: add      byte ptr [bx + si], al
  0x1C1CC: lcall    0x110d, 0xdab
  0x1C1D1: ljmp     0:0x1a0c
  0x1C1D6: add      al, 0
  0x1C1D8: add      byte ptr [bx + si], al
  0x1C1DA: lcall    0x110d, 0xdab
  0x1C1DF: ljmp     0:0x7c6
  0x1C1E4: add      al, 0
  0x1C1E6: add      byte ptr [bx + si], al
  0x1C1E8: lcall    0x110d, 0xdab
  0x1C1ED: ljmp     0:0x31c6
  0x1C1F2: add      al, 0
  0x1C1F4: add      byte ptr [bx + si], al
  0x1C1F6: lcall    0x110d, 0xdab
  0x1C1FB: ljmp     0:0x2dfe
  0x1C200: add      al, 0
  0x1C202: add      byte ptr [bx + si], al
  0x1C204: lcall    0x110d, 0xdab
  0x1C209: ljmp     0:0x1d80
  0x1C20E: add      al, 0
  0x1C210: add      byte ptr [bx + si], al
  0x1C212: lcall    0x110d, 0xdab
  0x1C217: ljmp     0:0x1a30
  0x1C21C: add      al, 0
  0x1C21E: add      byte ptr [bx + si], al
  0x1C220: lcall    0x110d, 0xdab
  0x1C225: ljmp     0:0x146c
  0x1C22A: add      al, 0
  0x1C22C: add      byte ptr [bx + si], al
  0x1C22E: lcall    0x110d, 0xdab
  0x1C233: ljmp     0:0x16
  0x1C238: add      al, 0
  0x1C23A: add      byte ptr [bx + si], al
  0x1C23C: lcall    0x110d, 0xdab
  0x1C241: ljmp     0:0x3502
  0x1C246: add      al, 0
  0x1C248: add      byte ptr [bx + si], al
  0x1C24A: lcall    0x110d, 0xdab
  0x1C24F: ljmp     0:0x1aba
  0x1C254: add      al, 0
  0x1C256: add      byte ptr [bx + si], al
  0x1C258: lcall    0x110d, 0xdab
  0x1C25D: ljmp     0:0xd48
  0x1C262: add      al, 0
  0x1C264: add      byte ptr [bx + si], al
  0x1C266: lcall    0x110d, 0xdab
  0x1C26B: ljmp     0:0x81c
  0x1C270: add      al, 0
  0x1C272: add      byte ptr [bx + si], al
  0x1C274: lcall    0x110d, 0xdab
  0x1C279: ljmp     0:0x5930
  0x1C27E: add      al, 0
  0x1C280: add      byte ptr [bx + si], al
  0x1C282: lcall    0x110d, 0xdab
  0x1C287: ljmp     0:0x4590
  0x1C28C: add      al, 0
  0x1C28E: add      byte ptr [bx + si], al
  0x1C290: lcall    0x110d, 0xdab
  0x1C295: ljmp     0:0x4f6e
  0x1C29A: add      al, 0
  0x1C29C: add      byte ptr [bx + si], al
  0x1C29E: lcall    0x110d, 0xdab
  0x1C2A3: ljmp     0:0x2edc
  0x1C2A8: add      al, 0
  0x1C2AA: add      byte ptr [bx + si], al
  0x1C2AC: lcall    0x110d, 0xdab
  0x1C2B1: ljmp     0:0x58
  0x1C2B6: add      al, 0
  0x1C2B8: add      byte ptr [bx + si], al
  0x1C2BA: lcall    0x110d, 0xdab
  0x1C2BF: ljmp     0:0x41ce
  0x1C2C4: add      al, 0
  0x1C2C6: add      byte ptr [bx + si], al
  0x1C2C8: lcall    0x110d, 0xdab
  0x1C2CD: ljmp     0:0x5e8
  0x1C2D2: add      al, 0
  0x1C2D4: add      byte ptr [bx + si], al
  0x1C2D6: lcall    0x110d, 0xdab
  0x1C2DB: ljmp     0:0x836
  0x1C2E0: add      al, 0
  0x1C2E2: add      byte ptr [bx + si], al
  0x1C2E4: lcall    0x110d, 0xdab
  0x1C2E9: ljmp     0:0x3228
  0x1C2EE: add      al, 0
  0x1C2F0: add      byte ptr [bx + si], al
  0x1C2F2: lcall    0x110d, 0xdab
  0x1C2F7: ljmp     0:0x23c4
  0x1C2FC: add      al, 0
  0x1C2FE: add      byte ptr [bx + si], al
  0x1C300: lcall    0x110d, 0xdab
  0x1C305: ljmp     0:0x86c
  0x1C30A: add      al, 0
  0x1C30C: add      byte ptr [bx + si], al
  0x1C30E: lcall    0x110d, 0xdab
  0x1C313: ljmp     0:0x2bfe
  0x1C318: add      al, 0
  0x1C31A: add      byte ptr [bx + si], al
  0x1C31C: lcall    0x110d, 0xdab
  0x1C321: ljmp     0:0x4884
  0x1C326: add      al, 0
  0x1C328: add      byte ptr [bx + si], al
  0x1C32A: lcall    0x110d, 0xdab
  0x1C32F: ljmp     0:0x8a4
  0x1C334: add      al, 0
  0x1C336: add      byte ptr [bx + si], al
  0x1C338: lcall    0x110d, 0xdab
  0x1C33D: ljmp     0:0x4df4
  0x1C342: add      al, 0
  0x1C344: add      byte ptr [bx + si], al
  0x1C346: lcall    0x110d, 0xdab
  0x1C34B: ljmp     0:0x14e2
  0x1C350: add      al, 0
  0x1C352: add      byte ptr [bx + si], al
  0x1C354: lcall    0x110d, 0xdab
  0x1C359: ljmp     0:0x462e
  0x1C35E: add      al, 0
  0x1C360: add      byte ptr [bx + si], al
  0x1C362: lcall    0x110d, 0xdab
  0x1C367: ljmp     0:0x1b9e
  0x1C36C: add      al, 0
  0x1C36E: add      byte ptr [bx + si], al
  0x1C370: lcall    0x110d, 0xdab
  0x1C375: ljmp     0:0x666
  0x1C37A: add      al, 0
  0x1C37C: add      byte ptr [bx + si], al
  0x1C37E: lcall    0x110d, 0xdab
  0x1C383: ljmp     0:0x1ebc
  0x1C388: add      al, 0
  0x1C38A: add      byte ptr [bx + si], al
  0x1C38C: lcall    0x110d, 0xdab
  0x1C391: ljmp     0:0x127c
  0x1C396: add      al, 0
  0x1C398: add      byte ptr [bx + si], al
  0x1C39A: lcall    0x110d, 0xdab
  0x1C39F: ljmp     0:0x3694
  0x1C3A4: add      al, 0
  0x1C3A6: add      byte ptr [bx + si], al
  0x1C3A8: lcall    0x110d, 0xdab
  0x1C3AD: ljmp     0:0x1bd2
  0x1C3B2: add      al, 0
  0x1C3B4: add      byte ptr [bx + si], al
  0x1C3B6: lcall    0x110d, 0xdab
  0x1C3BB: ljmp     0:0x1f0c
  0x1C3C0: add      al, 0
  0x1C3C2: add      byte ptr [bx + si], al
  0x1C3C4: lcall    0x110d, 0xdab
  0x1C3C9: ljmp     0:0x18fc
  0x1C3CE: add      al, 0
  0x1C3D0: add      byte ptr [bx + si], al
  0x1C3D2: lcall    0x110d, 0xdab
  0x1C3D7: ljmp     0:0x15aa
  0x1C3DC: add      al, 0
  0x1C3DE: add      byte ptr [bx + si], al
  0x1C3E0: lcall    0x110d, 0xdab
  0x1C3E5: ljmp     0:0xe16
  0x1C3EA: add      al, 0
  0x1C3EC: add      byte ptr [bx + si], al
  0x1C3EE: lcall    0x110d, 0xdab
  0x1C3F3: ljmp     0:0x1956
  0x1C3F8: add      al, 0
  0x1C3FA: add      byte ptr [bx + si], al
  0x1C3FC: lcall    0x110d, 0xdab
  0x1C401: ljmp     0:0x6c4
  0x1C406: add      al, 0
  0x1C408: add      byte ptr [bx + si], al
  0x1C40A: lcall    0x110d, 0xdab
  0x1C40F: ljmp     0:0x4e78
  0x1C414: add      al, 0
  0x1C416: add      byte ptr [bx + si], al
  0x1C418: lcall    0x110d, 0xdab
  0x1C41D: ljmp     0:0x3746
  0x1C422: add      al, 0
  0x1C424: add      byte ptr [bx + si], al
  0x1C426: lcall    0x110d, 0xdab
  0x1C42B: ljmp     0:0x285c
  0x1C430: add      al, 0
  0x1C432: add      byte ptr [bx + si], al
  0x1C434: lcall    0x110d, 0xdab
  0x1C439: ljmp     0:0x1960
  0x1C43E: add      al, 0
  0x1C440: add      byte ptr [bx + si], al
  0x1C442: lcall    0x110d, 0xdab
  0x1C447: ljmp     0:0x1c64
  0x1C44C: add      al, 0
  0x1C44E: add      byte ptr [bx + si], al
  0x1C450: lcall    0x110d, 0xdab
  0x1C455: ljmp     0:0x4e8e
  0x1C45A: add      al, 0
  0x1C45C: add      byte ptr [bx + si], al
  0x1C45E: lcall    0x110d, 0xdab
  0x1C463: ljmp     0:0x1f66
  0x1C468: add      al, 0
  0x1C46A: add      byte ptr [bx + si], al
  0x1C46C: lcall    0x110d, 0xdab
  0x1C471: ljmp     0:0x1382
  0x1C476: add      al, 0
  0x1C478: add      byte ptr [bx + si], al
  0x1C47A: lcall    0x110d, 0xdab
  0x1C47F: ljmp     0:0x1f7e
  0x1C484: add      al, 0
  0x1C486: add      byte ptr [bx + si], al
  0x1C488: lcall    0x110d, 0xdab
  0x1C48D: ljmp     0:0x30aa
  0x1C492: add      al, 0
  0x1C494: add      byte ptr [bx + si], al
  0x1C496: lcall    0x110d, 0xdab
  0x1C49B: ljmp     0:0x1cac
  0x1C4A0: add      al, 0
  0x1C4A2: add      byte ptr [bx + si], al
  0x1C4A4: lcall    0x110d, 0xdab
  0x1C4A9: ljmp     0:0x1f8e
  0x1C4AE: add      al, 0
  0x1C4B0: add      byte ptr [bx + si], al
  0x1C4B2: lcall    0x110d, 0xdab
  0x1C4B7: ljmp     0:0x346
  0x1C4BC: or       byte ptr [bx + si], al
  0x1C4BE: cmp      byte ptr [bx + di], al
  0x1C4C0: lcall    0x110d, 0xd91
  0x1C4C5: ljmp     0xcf8:0xa
  0x1C4CA: lcall    0x110d, 0xdab
  0x1C4CF: ljmp     0:6
  0x1C4D4: add      al, 0
  0x1C4D6: inc      dx
  0x1C4D7: push     es
  0x1C4D8: lcall    0x110d, 0xdab
  0x1C4DD: ljmp     0:0x8a
  0x1C4E2: add      ax, 0
  0x1C4E5: add      byte ptr [bp + si + 0xdab], bl
  0x1C4E9: or       ax, 0xea11
  0x1C4EC: cmp      byte ptr [si], dl
  0x1C4EE: add      byte ptr [bx + si], al
  0x1C4F0: add      ax, 0
  0x1C4F3: add      byte ptr [bp + si + 0xdab], bl
  0x1C4F7: or       ax, 0xea11
  0x1C4FA: xchg     sp, ax
  0x1C4FB: sbb      ax, word ptr [bx + si]
  0x1C4FD: add      byte ptr [di], al
  0x1C4FF: add      byte ptr [bx + si], al
  0x1C501: add      byte ptr [bp + si + 0xdab], bl
  0x1C505: or       ax, 0xea11
  0x1C508: mov      ah, 0x20
  0x1C50A: add      byte ptr [bx + si], al
  0x1C50C: add      ax, 0
  0x1C50F: add      byte ptr [bp + si + 0xdab], bl
  0x1C513: or       ax, 0xea11
  0x1C516: in       al, dx
  0x1C517: sbb      ax, word ptr [bx + si]
  0x1C519: add      byte ptr [di], al
  0x1C51B: add      byte ptr [bx + si], al
  0x1C51D: add      byte ptr [bp + si + 0xdab], bl
  0x1C521: or       ax, 0xea11
  0x1C524: push     ax
  0x1C525: adc      ax, 0
  0x1C528: add      ax, 0
  0x1C52B: add      byte ptr [bp + si + 0xdab], bl
  0x1C52F: or       ax, 0xea11
  0x1C532: or       ax, 0
  0x1C536: add      ax, 0
  0x1C539: add      byte ptr [bp + si + 0xdab], bl
  0x1C53D: or       ax, 0xea11
  0x1C540: add      byte ptr [bx + si], al
  0x1C542: add      byte ptr [bx + si], al
  0x1C544: add      ax, 0
  0x1C547: add      byte ptr [bp + si + 0xdab], bl
  0x1C54B: or       ax, 0xea11
  0x1C54E: sbb      byte ptr [0], 5
  0x1C553: add      byte ptr [bx + si], al
  0x1C555: add      byte ptr [bp + si + 0xdab], bl
  0x1C559: or       ax, 0xea11
  0x1C55C: or       byte ptr [bx + di], 0
  0x1C55F: add      byte ptr [0], al
  0x1C563: add      byte ptr [bp + si + 0xdab], bl
  0x1C567: or       ax, 0xea11
  0x1C56A: dec      dx
  0x1C56B: add      al, byte ptr [bx + si]
  0x1C56D: add      byte ptr [0], al
  0x1C571: add      byte ptr [bp + si + 0xdab], bl
  0x1C575: or       ax, 0xea11
  0x1C578: rol      byte ptr [bp + si], 1
  0x1C57A: add      byte ptr [bx + si], al
  0x1C57C: or       word ptr [bx + si], ax
  0x1C57E: lcall    0x110d, 0xdab
  0x1C583: ljmp     0:0xf56
  0x1C588: add      ax, 0xb100
  0x1C58B: add      bl, byte ptr [bp + si + 0xdab]
  0x1C58F: or       ax, 0xea11
  0x1C592: jo       0x1c59f
  0x1C594: add      byte ptr [bx + si], al
  0x1C596: add      ax, 0xb100
  0x1C599: add      bl, byte ptr [bp + si + 0xdab]
  0x1C59D: or       ax, 0xea11
  0x1C5A0: push     cs
  0x1C5A1: add      byte ptr [bx + si], al
  0x1C5A3: add      byte ptr [di], al
  0x1C5A5: add      byte ptr [bx + di - 0x65fe], dh
  0x1C5A9: stosw    word ptr es:[di], ax
  0x1C5AA: or       ax, 0x110d
  0x1C5AD: ljmp     0:0
  0x1C5B2: sbb      byte ptr [bx + si], al
  0x1C5B4: lcall    0x110d, 0xdab
  0x1C5B9: ljmp     0:0x15e
  0x1C5BE: sbb      byte ptr [bx + si], al
  0x1C5C0: lcall    0x110d, 0xdab
  0x1C5C5: ljmp     0:0x54
  0x1C5CA: sbb      ax, word ptr [bx + si]
  0x1C5CC: add      byte ptr [bx + si], al
  0x1C5CE: lcall    0x110d, 0xdab
  0x1C5D3: ljmp     0:0
  0x1C5D8: sbb      ax, word ptr [bx + si]
  0x1C5DA: add      byte ptr [bx + si], al
  0x1C5DC: lcall    0x110d, 0xdab
  0x1C5E1: ljmp     0:0x342
  0x1C5E6: push     es
  0x1C5E7: add      byte ptr [bx + si], al
  0x1C5E9: add      byte ptr [bx + si], al
  0x1C5EB: add      byte ptr [bx + si], al
  0x1C5ED: add      byte ptr [bx + si], al
  0x1C5EF: add      byte ptr [bp + si + 0xdab], bl
  0x1C5F3: or       ax, 0xea11
  0x1C5F6: rol      byte ptr [0], cl
  0x1C5FA: push     es
  0x1C5FB: add      byte ptr [bx + si], al
  0x1C5FD: add      byte ptr [bp + si + 0xdab], bl
  0x1C601: or       ax, 0xea11
  0x1C604: add      word ptr es:[bx + si], ax
  0x1C607: add      byte ptr [0], al
  0x1C60B: add      byte ptr [bp + si + 0xdab], bl
  0x1C60F: or       ax, 0xea11
  0x1C612: pop      dx
  0x1C613: add      word ptr [bx + si], ax
  0x1C615: add      byte ptr [0], al
  0x1C619: add      byte ptr [bp + si + 0xdab], bl
  0x1C61D: or       ax, 0xea11
  0x1C620: cmpsb    byte ptr [si], byte ptr es:[di]
  0x1C621: add      word ptr [bx + si], ax
  0x1C623: add      byte ptr [0], al
  0x1C627: add      byte ptr [bp + si + 0xdab], bl
  0x1C62B: or       ax, 0xea11
  0x1C62E: add      byte ptr [bx + si], al
  0x1C630: add      byte ptr [bx + si], al
  0x1C632: push     es
  0x1C633: add      byte ptr [bx + si], al
  0x1C635: add      byte ptr [bp + si + 0xdab], bl
  0x1C639: or       ax, 0xea11
  0x1C63C: pop      dx
  0x1C63D: add      byte ptr [bx + si], al
  0x1C63F: add      byte ptr [0], al
  0x1C643: add      byte ptr [bp + si + 0xdab], bl
  0x1C647: or       ax, 0xea11
  0x1C64A: add      byte ptr [bx + si], 0
  0x1C64D: add      byte ptr [0], al
  0x1C651: add      byte ptr [bp + si + 0xdab], bl
  0x1C655: or       ax, 0xea11
  0x1C658: sub      byte ptr [bx], bl
  0x1C65A: add      byte ptr [bx + si], al
  0x1C65C: push     ss
  0x1C65D: add      byte ptr [bx + si], al
  0x1C65F: add      byte ptr [bp + si + 0xdab], bl
  0x1C663: or       ax, 0xea11
  0x1C666: add      byte ptr [bx + si], 0
  0x1C669: add      byte ptr [0xb200], al
  0x1C66D: add      byte ptr [bp + si + 0xdab], bl
  0x1C671: or       ax, 0xea11
  0x1C674: inc      dx
  0x1C675: sbb      ax, 0
  0x1C678: push     es
  0x1C679: add      byte ptr [bp + si - 0x6600], dh
  0x1C67D: stosw    word ptr es:[di], ax
  0x1C67E: or       ax, 0x110d
  0x1C681: ljmp     0:0x108
  0x1C686: push     es
  0x1C687: add      byte ptr [bp + si - 0x6600], dh
  0x1C68B: stosw    word ptr es:[di], ax
  0x1C68C: or       ax, 0x110d
  0x1C68F: ljmp     0:0x160a
  0x1C694: push     es
  0x1C695: add      byte ptr [bp + si - 0x6600], dh
  0x1C699: stosw    word ptr es:[di], ax
  0x1C69A: or       ax, 0x110d
  0x1C69D: ljmp     0:0x512
  0x1C6A2: push     es
  0x1C6A3: add      byte ptr [bp + si - 0x6600], dh
  0x1C6A7: stosw    word ptr es:[di], ax
  0x1C6A8: or       ax, 0x110d
  0x1C6AB: ljmp     0:0x188
  0x1C6B0: push     es
  0x1C6B1: add      byte ptr [bp + si - 0x6600], dh
  0x1C6B5: stosw    word ptr es:[di], ax
  0x1C6B6: or       ax, 0x110d
  0x1C6B9: ljmp     0:0x1eca
  0x1C6BE: push     es
  0x1C6BF: add      byte ptr [bp + si - 0x6600], dh
  0x1C6C3: stosw    word ptr es:[di], ax
  0x1C6C4: or       ax, 0x110d
  0x1C6C7: ljmp     0:0x5ea
  0x1C6CC: push     es
  0x1C6CD: add      byte ptr [bp + si - 0x6600], dh
  0x1C6D1: stosw    word ptr es:[di], ax
  0x1C6D2: or       ax, 0x110d
  0x1C6D5: ljmp     0:0x5f4
  0x1C6DA: push     es
  0x1C6DB: add      byte ptr [bp + si - 0x6600], dh
  0x1C6DF: stosw    word ptr es:[di], ax
  0x1C6E0: or       ax, 0x110d
  0x1C6E3: ljmp     0:0x60a
  0x1C6E8: push     es
  0x1C6E9: add      byte ptr [bp + si - 0x6600], dh
  0x1C6ED: stosw    word ptr es:[di], ax
  0x1C6EE: or       ax, 0x110d
  0x1C6F1: ljmp     0:0x982
  0x1C6F6: push     es
  0x1C6F7: add      byte ptr [bp + si - 0x6600], dh
  0x1C6FB: stosw    word ptr es:[di], ax
  0x1C6FC: or       ax, 0x110d
  0x1C6FF: ljmp     0:0x10f0
  0x1C704: push     es
  0x1C705: add      byte ptr [bp + si - 0x6600], dh
  0x1C709: stosw    word ptr es:[di], ax
  0x1C70A: or       ax, 0x110d
  0x1C70D: ljmp     0:0x6a6
  0x1C712: push     es
  0x1C713: add      byte ptr [bp + si - 0x6600], dh
  0x1C717: stosw    word ptr es:[di], ax
  0x1C718: or       ax, 0x110d
  0x1C71B: ljmp     0:0x2022
  0x1C720: push     es
  0x1C721: add      byte ptr [bp + si - 0x6600], dh
  0x1C725: stosw    word ptr es:[di], ax
  0x1C726: or       ax, 0x110d
  0x1C729: ljmp     0:4
  0x1C72E: push     es
  0x1C72F: add      byte ptr [bp + si - 0x6600], dh
  0x1C733: stosw    word ptr es:[di], ax
  0x1C734: or       ax, 0x110d
  0x1C737: ljmp     0:0
  0x1C73C: pop      es
  0x1C73D: add      byte ptr [bx + si], al
  0x1C73F: add      byte ptr [bp + si + 0xdab], bl
  0x1C743: or       ax, 0xea11
  0x1C746: push     ds
  0x1C747: or       al, 0
  0x1C749: add      byte ptr [bx], al
  0x1C74B: add      byte ptr [bx + si], al
  0x1C74D: add      byte ptr [bp + si + 0xdab], bl
  0x1C751: or       ax, 0xea11
  0x1C754: bound    ax, dword ptr [0]

============================================================
func_L524 at file 0x1D118, 13642 bytes
============================================================
  0x1D118: enter    1, 0
  0x1D11C: sbb      byte ptr [bx + si], al
  0x1D11E: lcall    0x110d, 0xdab
  0x1D123: ljmp     0:0x1da
  0x1D128: sbb      byte ptr [bx + si], al
  0x1D12A: lcall    0x110d, 0xd91
  0x1D12F: ljmp     0xc06:0xc
  0x1D134: lcall    0x110d, 0xd91
  0x1D139: ljmp     0xb57:2
  0x1D13E: lcall    0x110d, 0xd91
  0x1D143: ljmp     0xafb:0xe
  0x1D148: lcall    0x110d, 0xdab
  0x1D14D: ljmp     0:0xb3e
  0x1D152: sbb      word ptr [bx + si], ax
  0x1D154: add      byte ptr [bx + si], al
  0x1D156: lcall    0x110d, 0xdab
  0x1D15B: ljmp     0:0x790
  0x1D160: sbb      word ptr [bx + si], ax
  0x1D162: add      byte ptr [bx + si], al
  0x1D164: lcall    0x110d, 0xdab
  0x1D169: ljmp     0:0xc2a
  0x1D16E: sbb      word ptr [bx + si], ax
  0x1D170: add      byte ptr [bx + si], al
  0x1D172: lcall    0x110d, 0xdab
  0x1D177: ljmp     0:0
  0x1D17C: sbb      word ptr [bx + si], ax
  0x1D17E: add      byte ptr [bx + si], al
  0x1D180: lcall    0x110d, 0xdab
  0x1D185: ljmp     0:0x4d0
  0x1D18A: sbb      word ptr [bx + si], ax
  0x1D18C: add      byte ptr [bx + si], al
  0x1D18E: lcall    0x110d, 0xdab
  0x1D193: ljmp     0:0x2c
  0x1D198: sbb      word ptr [bx + si], ax
  0x1D19A: add      byte ptr [bx + si], al
  0x1D19C: lcall    0x110d, 0xdab
  0x1D1A1: ljmp     0:0x512
  0x1D1A6: sbb      word ptr [bx + si], ax
  0x1D1A8: add      byte ptr [bx + si], al
  0x1D1AA: lcall    0x110d, 0xdab
  0x1D1AF: ljmp     0:0x1a4
  0x1D1B4: sbb      word ptr [bx + si], ax
  0x1D1B6: add      byte ptr [bx + si], al
  0x1D1B8: lcall    0x110d, 0xdab
  0x1D1BD: ljmp     0:0x992
  0x1D1C2: sbb      word ptr [bx + si], ax
  0x1D1C4: add      byte ptr [bx + si], al
  0x1D1C6: lcall    0x110d, 0xdab
  0x1D1CB: ljmp     0:0x9c6
  0x1D1D0: sbb      word ptr [bx + si], ax
  0x1D1D2: add      byte ptr [bx + si], al
  0x1D1D4: lcall    0x110d, 0xdab
  0x1D1D9: ljmp     0:0x270
  0x1D1DE: sbb      word ptr [bx + si], ax
  0x1D1E0: add      byte ptr [bx + si], al
  0x1D1E2: lcall    0x110d, 0xdab
  0x1D1E7: ljmp     0:0x6a4
  0x1D1EC: sbb      word ptr [bx + si], ax
  0x1D1EE: add      byte ptr [bx + si], al
  0x1D1F0: lcall    0x110d, 0xdab
  0x1D1F5: ljmp     0:0xa
  0x1D1FA: sbb      word ptr [bx + si], ax
  0x1D1FC: out      0, ax
  0x1D1FE: lcall    0x110d, 0xdab
  0x1D203: ljmp     0:0xc
  0x1D208: sbb      word ptr [bx + si], ax
  0x1D20A: out      0, ax
  0x1D20C: lcall    0x110d, 0xdab
  0x1D211: ljmp     0:0x54
  0x1D216: sbb      word ptr [bx + si], ax
  0x1D218: out      0, ax
  0x1D21A: lcall    0x110d, 0xdab
  0x1D21F: ljmp     0:0x188
  0x1D224: sbb      word ptr [bx + si], ax
  0x1D226: out      0, ax
  0x1D228: lcall    0x110d, 0xdab
  0x1D22D: ljmp     0:0x2d46
  0x1D232: sbb      al, byte ptr [bx + si]
  0x1D234: push     ds
  0x1D235: add      word ptr [bp + si + 0xd91], bx
  0x1D239: or       ax, 0xea11
  0x1D23C: add      al, 0
  0x1D23E: test     word ptr [bx + si], dx
  0x1D240: lcall    0x110d, 0xd91
  0x1D245: ljmp     0x105f:0xc
  0x1D24A: lcall    0x110d, 0xd91
  0x1D24F: ljmp     0xb3f:0x6e
  0x1D254: lcall    0x110d, 0xdab
  0x1D259: ljmp     0:0x122
  0x1D25E: sbb      word ptr [bx + si], ax
  0x1D260: sbb      ax, word ptr [bx + di]
  0x1D262: lcall    0x110d, 0xdab
  0x1D267: ljmp     0:0x58
  0x1D26C: sbb      word ptr [bx + si], ax
  0x1D26E: sbb      ax, word ptr [bx + di]
  0x1D270: lcall    0x110d, 0xdab
  0x1D275: ljmp     0:0x434
  0x1D27A: sbb      word ptr [bx + si], ax
  0x1D27C: sbb      ax, word ptr [bx + di]
  0x1D27E: lcall    0x110d, 0xdab
  0x1D283: ljmp     0:0x166
  0x1D288: sbb      word ptr [bx + si], ax
  0x1D28A: sbb      ax, word ptr [bx + di]
  0x1D28C: lcall    0x110d, 0xdab
  0x1D291: ljmp     0:0xc
  0x1D296: sbb      al, 0
  0x1D298: jns      0x1d29a
  0x1D29A: lcall    0x110d, 0xd91
  0x1D29F: ljmp     0xb32:0x5c
  0x1D2A4: lcall    0x110d, 0xd91
  0x1D2A9: ljmp     0xb01:0xe
  0x1D2AE: lcall    0x110d, 0xdab
  0x1D2B3: ljmp     0:0xbbe
  0x1D2B8: sbb      al, byte ptr [bx + si]
  0x1D2BA: add      byte ptr [bx + si], al
  0x1D2BC: lcall    0x110d, 0xdab
  0x1D2C1: ljmp     0:0xb0a
  0x1D2C6: sbb      al, byte ptr [bx + si]
  0x1D2C8: add      byte ptr [bx + si], al
  0x1D2CA: lcall    0x110d, 0xdab
  0x1D2CF: ljmp     0:8
  0x1D2D4: sbb      al, byte ptr [bx + si]
  0x1D2D6: mov      si, 0x9a00
  0x1D2D9: stosw    word ptr es:[di], ax
  0x1D2DA: or       ax, 0x110d
  0x1D2DD: ljmp     0:0x52
  0x1D2E2: sbb      al, byte ptr [bx + si]
  0x1D2E4: mov      si, 0x9a00
  0x1D2E7: stosw    word ptr es:[di], ax
  0x1D2E8: or       ax, 0x110d
  0x1D2EB: ljmp     0:0x288
  0x1D2F0: sbb      al, byte ptr [bx + si]
  0x1D2F2: push     ds
  0x1D2F3: add      word ptr [bp + si + 0xdab], bx
  0x1D2F7: or       ax, 0xea11
  0x1D2FA: inc      ax
  0x1D2FB: or       byte ptr [bx + si], al
  0x1D2FD: add      byte ptr [bp + si], bl
  0x1D2FF: add      byte ptr [0x9a01], bl
  0x1D303: stosw    word ptr es:[di], ax
  0x1D304: or       ax, 0x110d
  0x1D307: ljmp     0:0x940
  0x1D30C: sbb      al, byte ptr [bx + si]
  0x1D30E: push     ds
  0x1D30F: add      word ptr [bp + si + 0xdab], bx
  0x1D313: or       ax, 0xea11
  0x1D316: adc      byte ptr [bp + di], 0
  0x1D319: add      byte ptr [bp + si], bl
  0x1D31B: add      byte ptr [0x9a01], bl
  0x1D31F: stosw    word ptr es:[di], ax
  0x1D320: or       ax, 0x110d
  0x1D323: ljmp     0:0x13dc
  0x1D328: sbb      al, byte ptr [bx + si]
  0x1D32A: push     ds
  0x1D32B: add      word ptr [bp + si + 0xdab], bx
  0x1D32F: or       ax, 0xea11
  0x1D332: scasb    al, byte ptr es:[di]
  0x1D333: adc      byte ptr [bx + si], al
  0x1D335: add      byte ptr [bp + si], bl
  0x1D337: add      byte ptr [0x9a01], bl
  0x1D33B: stosw    word ptr es:[di], ax
  0x1D33C: or       ax, 0x110d
  0x1D33F: ljmp     0:0x1418
  0x1D344: sbb      al, byte ptr [bx + si]
  0x1D346: push     ds
  0x1D347: add      word ptr [bp + si + 0xdab], bx
  0x1D34B: or       ax, 0xea11
  0x1D34E: add      al, 2
  0x1D350: add      byte ptr [bx + si], al
  0x1D352: sbb      al, byte ptr [bx + si]
  0x1D354: push     ds
  0x1D355: add      word ptr [bp + si + 0xdab], bx
  0x1D359: or       ax, 0xea11
  0x1D35C: dec      sp
  0x1D35D: adc      al, 0
  0x1D35F: add      byte ptr [bp + si], bl
  0x1D361: add      byte ptr [0x9a01], bl
  0x1D365: stosw    word ptr es:[di], ax
  0x1D366: or       ax, 0x110d
  0x1D369: ljmp     0:0x24c
  0x1D36E: sbb      al, byte ptr [bx + si]
  0x1D370: push     ds
  0x1D371: add      word ptr [bp + si + 0xdab], bx
  0x1D375: or       ax, 0xea11
  0x1D378: jo       0x1d391
  0x1D37A: add      byte ptr [bx + si], al
  0x1D37C: sbb      al, byte ptr [bx + si]
  0x1D37E: push     ds
  0x1D37F: add      word ptr [bp + si + 0xdab], bx
  0x1D383: or       ax, 0xea11
  0x1D386: pop      ax
  0x1D387: daa      
  0x1D388: add      byte ptr [bx + si], al
  0x1D38A: sbb      al, byte ptr [bx + si]
  0x1D38C: push     ds
  0x1D38D: add      word ptr [bp + si + 0xdab], bx
  0x1D391: or       ax, 0xea11
  0x1D394: outsb    dx, byte ptr [si]
  0x1D395: daa      
  0x1D396: add      byte ptr [bx + si], al
  0x1D398: sbb      al, byte ptr [bx + si]
  0x1D39A: push     ds
  0x1D39B: add      word ptr [bp + si + 0xdab], bx
  0x1D39F: or       ax, 0xea11
  0x1D3A2: js       0x1d3cb
  0x1D3A4: add      byte ptr [bx + si], al
  0x1D3A6: sbb      al, byte ptr [bx + si]
  0x1D3A8: push     ds
  0x1D3A9: add      word ptr [bp + si + 0xdab], bx
  0x1D3AD: or       ax, 0xea11
  0x1D3B0: add      byte ptr [bx + si], al
  0x1D3B2: add      byte ptr [bx + si], al
  0x1D3B4: sbb      al, byte ptr [bx + si]
  0x1D3B6: push     ds
  0x1D3B7: add      word ptr [bp + si + 0xdab], bx
  0x1D3BB: or       ax, 0xea11
  0x1D3BE: and      al, 0x23
  0x1D3C0: add      byte ptr [bx + si], al
  0x1D3C2: sbb      al, byte ptr [bx + si]
  0x1D3C4: push     ds
  0x1D3C5: add      word ptr [bp + si + 0xdab], bx
  0x1D3C9: or       ax, 0xea11
  0x1D3CC: pop      sp
  0x1D3CD: and      ax, word ptr [bx + si]
  0x1D3CF: add      byte ptr [bp + si], bl
  0x1D3D1: add      byte ptr [0x9a01], bl
  0x1D3D5: xchg     cx, ax
  0x1D3D6: or       ax, 0x110d
  0x1D3D9: ljmp     0xb2c:0x40
  0x1D3DE: lcall    0x110d, 0xd91
  0x1D3E3: ljmp     0xb2c:4
  0x1D3E8: lcall    0x110d, 0xd91
  0x1D3ED: ljmp     0xbd4:6
  0x1D3F2: lcall    0x110d, 0xdab
  0x1D3F7: ljmp     0:2
  0x1D3FC: pop      ds
  0x1D3FD: add      byte ptr [0x9a00], dl
  0x1D401: stosw    word ptr es:[di], ax
  0x1D402: or       ax, 0x110d
  0x1D405: ljmp     0:0x22
  0x1D40A: sbb      ax, word ptr [bx + si]
  0x1D40C: add      byte ptr [bx + si], al
  0x1D40E: lcall    0x110d, 0xd91
  0x1D413: ljmp     0xb70:2
  0x1D418: lcall    0x110d, 0xdab
  0x1D41D: ljmp     0:0xe
  0x1D422: push     ds
  0x1D423: add      byte ptr [bx + si], dh
  0x1D425: add      byte ptr [bp + si + 0xd91], bl
  0x1D429: or       ax, 0xea11
  0x1D42C: add      al, 0
  0x1D42E: mov      cx, word ptr [bp + di]
  0x1D430: lcall    0x110d, 0xdab
  0x1D435: ljmp     0:0x6a
  0x1D43A: push     ds
  0x1D43B: add      byte ptr [bx + si], al
  0x1D43D: add      byte ptr [bp + si + 0xdab], bl
  0x1D441: or       ax, 0xea11
  0x1D444: add      al, byte ptr [bx + si]
  0x1D446: add      byte ptr [bx + si], al
  0x1D448: push     ds
  0x1D449: add      byte ptr [di], dl
  0x1D44C: lcall    0x110d, 0xdab
  0x1D451: ljmp     0:4
  0x1D456: push     ds
  0x1D457: add      byte ptr [bx + di], dl
  0x1D45A: lcall    0x110d, 0xdab
  0x1D45F: ljmp     0:0x3a
  0x1D464: push     ds
  0x1D465: add      byte ptr [di], dl
  0x1D468: lcall    0x110d, 0xd91
  0x1D46D: ljmp     0xc05:4
  0x1D472: lcall    0x110d, 0xdab
  0x1D477: ljmp     0:0
  0x1D47C: sbb      al, 0
  0x1D47E: sub      ax, word ptr [bx + si]
  0x1D480: lcall    0x110d, 0xdab
  0x1D485: ljmp     0:0x22
  0x1D48A: pop      ds
  0x1D48B: add      byte ptr [bx + di], ah
  0x1D48D: add      byte ptr [bp + si + 0xdab], bl
  0x1D491: or       ax, 0xea11
  0x1D494: add      byte ptr [bx + si], al
  0x1D496: add      byte ptr [bx + si], al
  0x1D498: sbb      al, 0
  0x1D49A: add      byte ptr [bx + si], al
  0x1D49C: lcall    0x110d, 0xdab
  0x1D4A1: ljmp     0:0x21c
  0x1D4A6: sbb      al, 0
  0x1D4A8: add      byte ptr [bx + si], al
  0x1D4AA: lcall    0x110d, 0xdab
  0x1D4AF: ljmp     0:0x4a
  0x1D4B4: sbb      al, 0
  0x1D4B6: inc      si
  0x1D4B7: add      byte ptr [bp + si + 0xdab], bl
  0x1D4BB: or       ax, 0xea11
  0x1D4BE: adc      al, 0
  0x1D4C0: add      byte ptr [bx + si], al
  0x1D4C2: sbb      al, 0
  0x1D4C4: inc      si
  0x1D4C5: add      byte ptr [bp + si + 0xdab], bl
  0x1D4C9: or       ax, 0xea11
  0x1D4CC: or       al, byte ptr [bx + si]
  0x1D4CE: add      byte ptr [bx + si], al
  0x1D4D0: sbb      al, 0
  0x1D4D2: inc      si
  0x1D4D3: add      byte ptr [bp + si + 0xdab], bl
  0x1D4D7: or       ax, 0xea11
  0x1D4DA: add      byte ptr [bx + si], 0
  0x1D4DD: add      byte ptr [si], bl
  0x1D4DF: add      byte ptr [bp + si - 0x6600], cl
  0x1D4E3: xchg     cx, ax
  0x1D4E4: or       ax, 0x110d
  0x1D4E7: ljmp     0x107c:2
  0x1D4EC: lcall    0x110d, 0xd91
  0x1D4F1: ljmp     0x106d:0xa
  0x1D4F6: lcall    0x110d, 0xd91
  0x1D4FB: ljmp     0x1074:8
  0x1D500: lcall    0x110d, 0xd91
  0x1D505: ljmp     0x1066:6
  0x1D50A: lcall    0x110d, 0xdab
  0x1D50F: ljmp     0:0xa4
  0x1D514: sbb      ax, 0x9a00
  0x1D517: xchg     cx, ax
  0x1D518: or       ax, 0x110d
  0x1D51B: ljmp     0x1088:0xc
  0x1D520: lcall    0x110d, 0xdab
  0x1D525: ljmp     0:0
  0x1D52A: push     ds
  0x1D52B: add      byte ptr [bx + si], al
  0x1D52D: add      byte ptr [bp + si + 0xdab], bl
  0x1D531: or       ax, 0xea11
  0x1D534: add      al, byte ptr [bx + si]
  0x1D536: add      byte ptr [bx + si], al
  0x1D538: push     ds
  0x1D539: add      byte ptr [bx], dh
  0x1D53B: add      byte ptr [bp + si + 0xd91], bl
  0x1D53F: or       ax, 0xea11
  0x1D542: push     es
  0x1D543: add      word ptr [bx + 0x10], ax
  0x1D546: lcall    0x110d, 0xd91
  0x1D54B: ljmp     0x1059:6
  0x1D550: lcall    0x110d, 0xd91
  0x1D555: ljmp     0x1047:0xb8
  0x1D55A: lcall    0x110d, 0xd91
  0x1D55F: ljmp     0x1047:0xa
  0x1D564: lcall    0x110d, 0xd91
  0x1D569: ljmp     0x1047:0xe9
  0x1D56E: lcall    0x110d, 0xdab
  0x1D573: ljmp     0:0xe
  0x1D578: pop      ds
  0x1D579: add      byte ptr [di], bl
  0x1D57B: add      byte ptr [bp + si + 0xd91], bl
  0x1D57F: or       ax, 0xea11
  0x1D582: loopne   0x1d584
  0x1D584: fisttp   qword ptr [bp + di]
  0x1D586: lcall    0x110d, 0xd91
  0x1D58B: ljmp     0xbdd:2
  0x1D590: lcall    0x110d, 0xdab
  0x1D595: ljmp     0:0x3c
  0x1D59A: pop      ds
  0x1D59B: add      byte ptr [0x9a00], dl
  0x1D59F: stosw    word ptr es:[di], ax
  0x1D5A0: or       ax, 0x110d
  0x1D5A3: ljmp     0:6
  0x1D5A8: pop      ds
  0x1D5A9: add      byte ptr [bx + di], ah
  0x1D5AB: add      byte ptr [bp + si + 0xd91], bl
  0x1D5AF: or       ax, 0xea11
  0x1D5B2: push     cs
  0x1D5B3: add      byte ptr [bx + si], al
  0x1D5B5: adc      word ptr [bp + si + 0xdab], bx
  0x1D5B9: or       ax, 0xea11
  0x1D5BC: add      al, byte ptr [bx + si]
  0x1D5BE: add      byte ptr [bx + si], al
  0x1D5C0: pop      ds
  0x1D5C1: add      byte ptr [bp + di], cl
  0x1D5C4: lcall    0x110d, 0xd91
  0x1D5C9: ljmp     0x1103:0x4c
  0x1D5CE: lcall    0x110d, 0xd91
  0x1D5D3: ljmp     0x1103:0xa
  0x1D5D8: lcall    0x110d, 0xdab
  0x1D5DD: ljmp     0:4
  0x1D5E2: sbb      al, 0
  0x1D5E4: mov      al, byte ptr [bx + si]
  0x1D5E6: add      byte ptr [bx + si], al
  0x1D5E8: add      byte ptr [bx + si], al
  0x1D5EA: add      byte ptr [bx + si], al
  0x1D5EC: add      byte ptr [bx + si], al
  0x1D5EE: add      byte ptr [bx + si], al
  0x1D5F0: lcall    0x110d, 0xd91
  0x1D5F5: ljmp     0x10a5:0x460
  0x1D5FA: lcall    0x110d, 0xd91
  0x1D5FF: ljmp     0x10a5:0x254
  0x1D604: lcall    0x110d, 0xd91
  0x1D609: ljmp     0x10a5:6
  0x1D60E: add      byte ptr [bx + si], al
  0x1D610: pop      es
  0x1D611: div      bh
  0x1D613: clc      
  0x1D614: stc      
  0x1D615: cli      
  0x1D616: sti      
  0x1D617: add      byte ptr [bx + si], al
  0x1D619: add      byte ptr [bx + si], al
  0x1D61B: add      byte ptr [bx + si], al
  0x1D61D: add      byte ptr [bx + si], al
  0x1D61F: add      byte ptr [bx + si], al
  0x1D621: add      byte ptr [bx + si], al
  0x1D623: add      byte ptr [bx + si], al
  0x1D625: add      byte ptr [bx + si], al
  0x1D627: add      byte ptr [bx + si], al
  0x1D629: add      byte ptr [bx + si], al
  0x1D62B: add      byte ptr [bx + si], al
  0x1D62D: add      byte ptr [bx + si], al
  0x1D62F: add      byte ptr [bx + si], al
  0x1D631: add      byte ptr [bx + si], al
  0x1D633: add      byte ptr [bx + si], al
  0x1D635: add      byte ptr [bx + si], al
  0x1D637: add      byte ptr [bx + si], al
  0x1D639: add      byte ptr [bx + si], al
  0x1D63B: add      byte ptr [bx + si], al
  0x1D63D: add      byte ptr [bx + si], al
  0x1D63F: add      byte ptr [bx + si], al
  0x1D641: add      byte ptr [bx + si], al
  0x1D643: add      byte ptr [bx + si], al
  0x1D645: add      byte ptr [bx + si], al
  0x1D647: add      byte ptr [bx + si], al
  0x1D649: add      byte ptr [bx + si], al
  0x1D64B: add      byte ptr [bx + si], al
  0x1D64D: add      byte ptr [bx + si], al
  0x1D64F: add      byte ptr [bx + si], al
  0x1D651: add      byte ptr [bx + si], al
  0x1D653: add      byte ptr [bx + si], al
  0x1D655: add      byte ptr [bx + si], al
  0x1D657: add      byte ptr [bx + si], al
  0x1D659: add      byte ptr [bx + si], al
  0x1D65B: add      byte ptr [bx + si], al
  0x1D65D: add      byte ptr [bx + si], al
  0x1D65F: add      byte ptr [bx + si], al
  0x1D661: add      byte ptr [bx + si], al
  0x1D663: add      byte ptr [bx + si], al
  0x1D665: add      byte ptr [bx + si], al
  0x1D667: add      byte ptr [bx + si], al
  0x1D669: add      byte ptr [bx + si], al
  0x1D66B: add      byte ptr [bx + si], al
  0x1D66D: add      byte ptr [bx + si], al
  0x1D66F: add      byte ptr [bx + si], al
  0x1D671: add      byte ptr [bx + si], al
  0x1D673: add      byte ptr [bx + si], al
  0x1D675: add      byte ptr [bx + si], al
  0x1D677: add      byte ptr [bx + si], al
  0x1D679: add      byte ptr [bx + si], al
  0x1D67B: add      byte ptr [bx + si], al
  0x1D67D: add      byte ptr [bx + si], al
  0x1D67F: add      byte ptr [bx + si], al
  0x1D681: add      byte ptr [bx + si], al
  0x1D683: add      byte ptr [bx + si], al
  0x1D685: add      byte ptr [bx + si], al
  0x1D687: add      byte ptr [bx + si], al
  0x1D689: add      byte ptr [bx + si], al
  0x1D68B: add      byte ptr [bx + si], al
  0x1D68D: add      byte ptr [bx + si], al
  0x1D68F: add      byte ptr [bx + si], al
  0x1D691: add      byte ptr [bx + si], al
  0x1D693: add      byte ptr [bx + si], al
  0x1D695: add      byte ptr [bx + si], al
  0x1D697: add      byte ptr [bx + si], al
  0x1D699: add      byte ptr [bx + si], al
  0x1D69B: add      byte ptr [bx + si], al
  0x1D69D: add      byte ptr [bx + si], al
  0x1D69F: add      byte ptr [bx + si], al
  0x1D6A1: add      byte ptr [bx + si], al
  0x1D6A3: add      byte ptr [bx + si], al
  0x1D6A5: add      byte ptr [bx + si], al
  0x1D6A7: add      byte ptr [bx + si], al
  0x1D6A9: add      byte ptr [bx + si], al
  0x1D6AB: add      byte ptr [bx + si], al
  0x1D6AD: add      byte ptr [bx + si], al
  0x1D6AF: add      byte ptr [bx + si], al
  0x1D6B1: add      byte ptr [bx + si], al
  0x1D6B3: add      byte ptr [bx + si], al
  0x1D6B5: add      byte ptr [bx + si], al
  0x1D6B7: add      byte ptr [bx + si], al
  0x1D6B9: add      byte ptr [bx + si], al
  0x1D6BB: add      byte ptr [bx + si], al
  0x1D6BD: add      byte ptr [bx + si], al
  0x1D6BF: add      byte ptr [bx + si], al
  0x1D6C1: add      byte ptr [bx + si], al
  0x1D6C3: add      byte ptr [bx + si], al
  0x1D6C5: add      byte ptr [bx + si], al
  0x1D6C7: add      byte ptr [bx + si], al
  0x1D6C9: add      byte ptr [bx + si], al
  0x1D6CB: add      byte ptr [bx + si], al
  0x1D6CD: add      byte ptr [bx + si], al
  0x1D6CF: add      byte ptr [bx + si], al
  0x1D6D1: add      byte ptr [bx + si], al
  0x1D6D3: add      byte ptr [bx + si], al
  0x1D6D5: add      byte ptr [bx + si], al
  0x1D6D7: add      byte ptr [bx + si], al
  0x1D6D9: add      byte ptr [bx + si], al
  0x1D6DB: add      byte ptr [bx + si], al
  0x1D6DD: add      byte ptr [bx + si], al
  0x1D6DF: add      byte ptr [bx + si], al
  0x1D6E1: add      byte ptr [bx + si], al
  0x1D6E3: add      byte ptr [bx + si], al
  0x1D6E5: add      byte ptr [bx + si], al
  0x1D6E7: add      byte ptr [bx + si], al
  0x1D6E9: add      byte ptr [bx + si], al
  0x1D6EB: add      byte ptr [bx + si], al
  0x1D6ED: add      byte ptr [bx + si], al
  0x1D6EF: add      byte ptr [bx + si], al
  0x1D6F1: add      byte ptr [bx + si], al
  0x1D6F3: add      byte ptr [bx + si], al
  0x1D6F5: add      byte ptr [bx + si], al
  0x1D6F7: add      byte ptr [bx + si], al
  0x1D6F9: add      byte ptr [bx + si], al
  0x1D6FB: add      byte ptr [bx + si], al
  0x1D6FD: add      byte ptr [bx + si], al
  0x1D6FF: add      byte ptr [bx + si], al
  0x1D701: add      byte ptr [bx + si], al
  0x1D703: add      byte ptr [bx + si], al
  0x1D705: add      byte ptr [bx + si], al
  0x1D707: add      byte ptr [bx + si], al
  0x1D709: add      byte ptr [bx + si], al
  0x1D70B: add      byte ptr [bx + si], al
  0x1D70D: add      byte ptr [bx + si], al
  0x1D70F: add      byte ptr [bx + si], al
  0x1D711: add      byte ptr [bx + si], al
  0x1D713: add      byte ptr [bx + si], al
  0x1D715: add      byte ptr [bx + si], al
  0x1D717: add      byte ptr [bx + si], al
  0x1D719: add      byte ptr [bx + si], al
  0x1D71B: add      byte ptr [bx + si], al
  0x1D71D: add      byte ptr [bx + si], al
  0x1D71F: add      byte ptr [bx + si], al
  0x1D721: add      byte ptr [bx + si], al
  0x1D723: add      byte ptr [bx + si], al
  0x1D725: add      byte ptr [bx + si], al
  0x1D727: add      byte ptr [bx + si], al
  0x1D729: add      byte ptr [bx + si], al
  0x1D72B: add      byte ptr [bx + si], al
  0x1D72D: add      byte ptr [bx + si], al
  0x1D72F: add      byte ptr [bx + si], al
  0x1D731: add      byte ptr [bx + si], al
  0x1D733: add      byte ptr [bx + si], al
  0x1D735: add      byte ptr [bx + si], al
  0x1D737: add      byte ptr [bx + si], al
  0x1D739: add      byte ptr [bx + si], al
  0x1D73B: add      byte ptr [bx + si], al
  0x1D73D: add      byte ptr [bx + si], al
  0x1D73F: add      byte ptr [bx + si], al
  0x1D741: add      byte ptr [bx + si], al
  0x1D743: add      byte ptr [bx + si], al
  0x1D745: add      byte ptr [bx + si], al
  0x1D747: add      byte ptr [bx + si], al
  0x1D749: add      byte ptr [bx + si], al
  0x1D74B: add      byte ptr [bx + si], al
  0x1D74D: add      byte ptr [bx + si], al
  0x1D74F: add      byte ptr [bx + si], al
  0x1D751: add      byte ptr [bx + si], al
  0x1D753: add      byte ptr [bx + si], al
  0x1D755: add      byte ptr [bx + si], al
  0x1D757: add      byte ptr [bx + si], al
  0x1D759: add      byte ptr [bx + si], al
  0x1D75B: add      byte ptr [bx + si], al
  0x1D75D: add      byte ptr [bx + si], al
  0x1D75F: add      byte ptr [bx + si], al
  0x1D761: add      byte ptr [bx + si], al
  0x1D763: add      byte ptr [bx + si], al
  0x1D765: add      byte ptr [bx + si], al
  0x1D767: add      byte ptr [bx + si], al
  0x1D769: add      byte ptr [bx + si], al
  0x1D76B: add      byte ptr [bx + si], al
  0x1D76D: add      byte ptr [bx + si], al
  0x1D76F: add      byte ptr [bx + si], al
  0x1D771: add      byte ptr [bx + si], al
  0x1D773: add      byte ptr [bx + si], al
  0x1D775: add      byte ptr [bx + si], al
  0x1D777: add      byte ptr [bx + si], al
  0x1D779: add      byte ptr [bx + si], al
  0x1D77B: add      byte ptr [bx + si], al
  0x1D77D: add      byte ptr [bx + si], al
  0x1D77F: add      byte ptr [bx + si], al
  0x1D781: add      byte ptr [bx + si], al
  0x1D783: add      byte ptr [bx + si], al
  0x1D785: add      byte ptr [bx + si], al
  0x1D787: add      byte ptr [bx + si], al
  0x1D789: add      byte ptr [bx + si], al
  0x1D78B: add      byte ptr [bx + si], al
  0x1D78D: add      byte ptr [bx + si], al
  0x1D78F: add      byte ptr [bx + si], al
  0x1D791: add      byte ptr [bx + si], al
  0x1D793: add      byte ptr [bx + si], al
  0x1D795: add      byte ptr [bx + si], al
  0x1D797: add      byte ptr [bx + si], al
  0x1D799: add      byte ptr [bx + si], al
  0x1D79B: add      byte ptr [bx + si], al
  0x1D79D: add      byte ptr [bx + si], al
  0x1D79F: add      byte ptr [bx + si], al
  0x1D7A1: add      byte ptr [bx + si], al
  0x1D7A3: add      byte ptr [bx + si], al
  0x1D7A5: add      byte ptr [bx + si], al
  0x1D7A7: add      byte ptr [bx + si], al
  0x1D7A9: add      byte ptr [bx + si], al
  0x1D7AB: add      byte ptr [bx + si], al
  0x1D7AD: add      byte ptr [bx + si], al
  0x1D7AF: add      byte ptr [bx + si], al
  0x1D7B1: add      byte ptr [bx + si], al
  0x1D7B3: add      byte ptr [bx + si], al
  0x1D7B5: add      byte ptr [bx + si], al
  0x1D7B7: add      byte ptr [bx + si], al
  0x1D7B9: add      byte ptr [bx + si], al
  0x1D7BB: add      byte ptr [bx + si], al
  0x1D7BD: add      byte ptr [bx + si], al
  0x1D7BF: add      byte ptr [bx + si], al
  0x1D7C1: add      byte ptr [bx + si], al
  0x1D7C3: add      byte ptr [bx + si], al
  0x1D7C5: add      byte ptr [bx + si], al
  0x1D7C7: add      byte ptr [bx + si], al
  0x1D7C9: add      byte ptr [bx + si], al
  0x1D7CB: add      byte ptr [bx + si], al
  0x1D7CD: add      byte ptr [bx + si], al
  0x1D7CF: add      byte ptr [bx + si], al
  0x1D7D1: add      byte ptr [bx + si], al
  0x1D7D3: add      byte ptr [bx + si], al
  0x1D7D5: add      byte ptr [bx + si], al
  0x1D7D7: add      byte ptr [bx + si], al
  0x1D7D9: add      byte ptr [bx + si], al
  0x1D7DB: add      byte ptr [bx + si], al
  0x1D7DD: add      byte ptr [bx + si], al
  0x1D7DF: add      byte ptr [bx + si], al
  0x1D7E1: add      byte ptr [bx + si], al
  0x1D7E3: add      byte ptr [bx + si], al
  0x1D7E5: add      byte ptr [bx + si], al
  0x1D7E7: add      byte ptr [bx + si], al
  0x1D7E9: add      byte ptr [bx + si], al
  0x1D7EB: add      byte ptr [bx + si], al
  0x1D7ED: add      byte ptr [bx + si], al
  0x1D7EF: add      byte ptr [bx + si], al
  0x1D7F1: add      byte ptr [bx + si], al
  0x1D7F3: add      byte ptr [bx + si], al
  0x1D7F5: add      byte ptr [bx + si], al
  0x1D7F7: add      byte ptr [bx + si], al
  0x1D7F9: add      byte ptr [bx + si], al
  0x1D7FB: add      byte ptr [bx + si], al
  0x1D7FD: add      byte ptr [bx + si], al
  0x1D7FF: add      byte ptr [bx + si], al
  0x1D801: add      byte ptr [bx + si], al
  0x1D803: add      byte ptr [bx + si], al
  0x1D805: add      byte ptr [bx + si], al
  0x1D807: add      byte ptr [bx + si], al
  0x1D809: add      byte ptr [bx + si], al
  0x1D80B: add      byte ptr [bx + si], al
  0x1D80D: add      byte ptr [bx + si], al
  0x1D80F: add      byte ptr [bx + si], al
  0x1D811: add      byte ptr [bx + si], al
  0x1D813: add      byte ptr [bx + si], al
  0x1D815: add      byte ptr [bx + si], al
  0x1D817: add      byte ptr [bx + si], al
  0x1D819: add      byte ptr [bx + si], al
  0x1D81B: add      byte ptr [bx + si], al
  0x1D81D: add      byte ptr [bx + si], al
  0x1D81F: add      byte ptr [bx + si], al
  0x1D821: add      byte ptr [bx + si], al
  0x1D823: add      byte ptr [bx + si], al
  0x1D825: add      byte ptr [bx + si], al
  0x1D827: add      byte ptr [bx + si], al
  0x1D829: add      byte ptr [bx + si], al
  0x1D82B: add      byte ptr [bx + si], al
  0x1D82D: add      byte ptr [bx + si], al
  0x1D82F: add      byte ptr [bx + si], al
  0x1D831: add      byte ptr [bx + si], al
  0x1D833: add      byte ptr [bx + si], al
  0x1D835: add      byte ptr [bx + si], al
  0x1D837: add      byte ptr [bx + si], al
  0x1D839: add      byte ptr [bx + si], al
  0x1D83B: add      byte ptr [bx + si], al
  0x1D83D: add      byte ptr [bx + si], al
  0x1D83F: add      byte ptr [bx + si], al
  0x1D841: add      byte ptr [bx + si], al
  0x1D843: add      byte ptr [bx + si], al
  0x1D845: add      byte ptr [bx + si], al
  0x1D847: add      byte ptr [bx + si], al
  0x1D849: add      byte ptr [bx + si], al
  0x1D84B: add      byte ptr [bx + si], al
  0x1D84D: add      byte ptr [bx + si], al
  0x1D84F: add      byte ptr [bx + si], al
  0x1D851: add      byte ptr [bx + si], al
  0x1D853: add      byte ptr [bx + si], al
  0x1D855: add      byte ptr [bx + si], al
  0x1D857: add      byte ptr [bx + si], al
  0x1D859: add      byte ptr [bx + si], al
  0x1D85B: add      byte ptr [bx + si], al
  0x1D85D: add      byte ptr [bx + si], al
  0x1D85F: add      byte ptr [bx + si], al
  0x1D861: add      byte ptr [bx + si], al
  0x1D863: add      byte ptr [bx + si], al
  0x1D865: add      byte ptr [bx + si], al
  0x1D867: add      byte ptr [bx + si], al
  0x1D869: add      byte ptr [bx + si], al
  0x1D86B: add      byte ptr [bx + si], al
  0x1D86D: add      byte ptr [bx + si], al
  0x1D86F: add      byte ptr [bx + si], al
  0x1D871: add      byte ptr [bx + si], al
  0x1D873: add      byte ptr [bx + si], al
  0x1D875: add      byte ptr [bx + si], al
  0x1D877: add      byte ptr [bx + si], al
  0x1D879: add      byte ptr [bx + si], al
  0x1D87B: add      byte ptr [bx + si], al
  0x1D87D: add      byte ptr [bx + si], al
  0x1D87F: add      byte ptr [bx + si], al
  0x1D881: add      byte ptr [bx + si], al
  0x1D883: add      byte ptr [bx + si], al
  0x1D885: add      byte ptr [bx + si], al
  0x1D887: add      byte ptr [bx + si], al
  0x1D889: add      byte ptr [bx + si], al
  0x1D88B: add      byte ptr [bx + si], al
  0x1D88D: add      byte ptr [bx + si], al
  0x1D88F: add      byte ptr [bx + si], al
  0x1D891: add      byte ptr [bx + si], al
  0x1D893: add      byte ptr [bx + si], al
  0x1D895: add      byte ptr [bx + si], al
  0x1D897: add      byte ptr [bx + si], al
  0x1D899: add      byte ptr [bx + si], al
  0x1D89B: add      byte ptr [bx + si], al
  0x1D89D: add      byte ptr [bx + si], al
  0x1D89F: add      byte ptr [bx + si], al
  0x1D8A1: add      byte ptr [bx + si], al
  0x1D8A3: add      byte ptr [bx + si], al
  0x1D8A5: add      byte ptr [bx + si], al
  0x1D8A7: add      byte ptr [bx + si], al
  0x1D8A9: add      byte ptr [bx + si], al
  0x1D8AB: add      byte ptr [bx + si], al
  0x1D8AD: add      byte ptr [bx + si], al
  0x1D8AF: add      byte ptr [bx + si], al
  0x1D8B1: add      byte ptr [bx + si], al
  0x1D8B3: add      byte ptr [bx + si], al
  0x1D8B5: add      byte ptr [bx + si], al
  0x1D8B7: add      byte ptr [bx + si], al
  0x1D8B9: add      byte ptr [bx + si], al
  0x1D8BB: add      byte ptr [bx + si], al
  0x1D8BD: add      byte ptr [bx + si], al
  0x1D8BF: add      byte ptr [bx + si], al
  0x1D8C1: add      byte ptr [bx + si], al
  0x1D8C3: add      byte ptr [bx + si], al
  0x1D8C5: add      byte ptr [bx + si], al
  0x1D8C7: add      byte ptr [bx + si], al
  0x1D8C9: add      byte ptr [bx + si], al
  0x1D8CB: add      byte ptr [bx + si], al
  0x1D8CD: add      byte ptr [bx + si], al
  0x1D8CF: add      byte ptr [bx + si], al
  0x1D8D1: add      byte ptr [bx + si], al
  0x1D8D3: add      byte ptr [bx + si], al
  0x1D8D5: add      byte ptr [bx + si], al
  0x1D8D7: add      byte ptr [bx + si], al
  0x1D8D9: add      byte ptr [bx + si], al
  0x1D8DB: add      byte ptr [bx + si], al
  0x1D8DD: add      byte ptr [bx + si], al
  0x1D8DF: add      byte ptr [bx + si], al
  0x1D8E1: add      byte ptr [bx + si], al
  0x1D8E3: add      byte ptr [bx + si], al
  0x1D8E5: add      byte ptr [bx + si], al
  0x1D8E7: add      byte ptr [bx + si], al
  0x1D8E9: add      byte ptr [bx + si], al
  0x1D8EB: add      byte ptr [bx + si], al
  0x1D8ED: add      byte ptr [bx + si], al
  0x1D8EF: add      byte ptr [bx + si], al
  0x1D8F1: add      byte ptr [bx + si], al
  0x1D8F3: add      byte ptr [bx + si], al
  0x1D8F5: add      byte ptr [bx + si], al
  0x1D8F7: add      byte ptr [bx + si], al
  0x1D8F9: add      byte ptr [bx + si], al
  0x1D8FB: add      byte ptr [bx + si], al
  0x1D8FD: add      byte ptr [bx + si], al
  0x1D8FF: add      byte ptr [bx + si], al
  0x1D901: add      byte ptr [bx + si], al
  0x1D903: add      byte ptr [bx + si], al
  0x1D905: add      byte ptr [bx + si], al
  0x1D907: add      byte ptr [bx + si], al
  0x1D909: add      byte ptr [bx + si], al
  0x1D90B: add      byte ptr [bx + si], al
  0x1D90D: add      byte ptr [bx + si], al
  0x1D90F: add      byte ptr [bx + si], al
  0x1D911: add      byte ptr [bx + si], al
  0x1D913: add      byte ptr [bx + si], al
  0x1D915: add      byte ptr [bx + si], al
  0x1D917: add      byte ptr [bx + si], al
  0x1D919: add      byte ptr [bx + si], al
  0x1D91B: add      byte ptr [bx + si], al
  0x1D91D: add      byte ptr [bx + si], al
  0x1D91F: add      byte ptr [bx + si], al
  0x1D921: add      byte ptr [bx + si], al
  0x1D923: add      byte ptr [bx + si], al
  0x1D925: add      byte ptr [bx + si], al
  0x1D927: add      byte ptr [bx + si], al
  0x1D929: add      byte ptr [bx + si], al
  0x1D92B: add      byte ptr [bx + si], al
  0x1D92D: add      byte ptr [bx + si], al
  0x1D92F: add      byte ptr [bx + si], al
  0x1D931: add      byte ptr [bx + si], al
  0x1D933: add      byte ptr [bx + si], al
  0x1D935: add      byte ptr [bx + si], al
  0x1D937: add      byte ptr [bx + si], al
  0x1D939: add      byte ptr [bx + si], al
  0x1D93B: add      byte ptr [bx + si], al
  0x1D93D: add      byte ptr [bx + si], al
  0x1D93F: add      byte ptr [bx + si], al
  0x1D941: add      byte ptr [bx + si], al
  0x1D943: add      byte ptr [bx + si], al
  0x1D945: add      byte ptr [bx + si], al
  0x1D947: add      byte ptr [bx + si], al
  0x1D949: add      byte ptr [bx + si], al
  0x1D94B: add      byte ptr [bx + si], al
  0x1D94D: add      byte ptr [bx + si], al
  0x1D94F: add      byte ptr [bx + si], al
  0x1D951: add      byte ptr [bx + si], al
  0x1D953: add      byte ptr [bx + si], al
  0x1D955: add      byte ptr [bx + si], al
  0x1D957: add      byte ptr [bx + si], al
  0x1D959: add      byte ptr [bx + si], al
  0x1D95B: add      byte ptr [bx + si], al
  0x1D95D: add      byte ptr [bx + si], al
  0x1D95F: add      byte ptr [bx + si], al
  0x1D961: add      byte ptr [bx + si], al
  0x1D963: add      byte ptr [bx + si], al
  0x1D965: add      byte ptr [bx + si], al
  0x1D967: add      byte ptr [bx + si], al
  0x1D969: add      byte ptr [bx + si], al
  0x1D96B: add      byte ptr [bx + si], al
  0x1D96D: add      byte ptr [bx + si], al
  0x1D96F: add      byte ptr [bx + si], al
  0x1D971: add      byte ptr [bx + si], al
  0x1D973: add      byte ptr [bx + si], al
  0x1D975: add      byte ptr [bx + si], al
  0x1D977: add      byte ptr [bx + si], al
  0x1D979: add      byte ptr [bx + si], al
  0x1D97B: add      byte ptr [bx + si], al
  0x1D97D: add      byte ptr [bx + si], al
  0x1D97F: add      byte ptr [bx + si], al
  0x1D981: add      byte ptr [bx + si], al
  0x1D983: add      byte ptr [bx + si], al
  0x1D985: add      byte ptr [bx + si], al
  0x1D987: add      byte ptr [bx + si], al
  0x1D989: add      byte ptr [bx + si], al
  0x1D98B: add      byte ptr [bx + si], al
  0x1D98D: add      byte ptr [bx + si], al
  0x1D98F: add      byte ptr [bx + si], al
  0x1D991: add      byte ptr [bx + si], al
  0x1D993: add      byte ptr [bx + si], al
  0x1D995: add      byte ptr [bx + si], al
  0x1D997: add      byte ptr [bx + si], al
  0x1D999: add      byte ptr [bx + si], al
  0x1D99B: add      byte ptr [bx + si], al
  0x1D99D: add      byte ptr [bx + si], al
  0x1D99F: add      byte ptr [bx + si], al
  0x1D9A1: add      byte ptr [bx + si], al
  0x1D9A3: add      byte ptr [bx + si], al
  0x1D9A5: add      byte ptr [bx + si], al
  0x1D9A7: add      byte ptr [di + 0x53], cl
  0x1D9AA: and      byte ptr [bp + si + 0x75], dl
  0x1D9AD: outsb    dx, byte ptr [si]
  0x1D9AE: sub      ax, 0x6954
  0x1D9B1: insw     word ptr es:[di], dx
  0x1D9B2: and      byte ptr gs:[si + 0x69], cl
  0x1D9B6: bound    si, dword ptr [bp + si + 0x61]
  0x1D9B9: jb       0x1da34
  0x1D9BB: and      byte ptr [di], ch
  0x1D9BD: and      byte ptr [bp + di + 0x6f], al
  0x1D9C0: jo       0x1da3b
  0x1D9C2: jb       0x1da2d
  0x1D9C4: push     0x2074
  0x1D9C8: sub      byte ptr [bp + di + 0x29], ah
  0x1D9CB: and      byte ptr [bx + di], dh
  0x1D9CD: cmp      word ptr [bx + di], di
  0x1D9CF: xor      byte ptr [si], ch
  0x1D9D1: and      byte ptr [di + 0x69], cl
  0x1D9D4: arpl     word ptr [bp + si + 0x6f], si
  0x1D9D7: jae      0x1da48
  0x1D9D9: je       0x1d9fc
  0x1D9DC: inc      bx
  0x1D9DD: outsw    dx, word ptr [si]
  0x1D9DE: jb       0x1da50
  0x1D9E0: sbb      byte ptr [bx + si], al
  0x1D9E2: and      al, 0x53
  0x1D9E4: push     sp
  0x1D9E5: push     dx
  0x1D9E6: dec      cx
  0x1D9E7: dec      si
  0x1D9E8: inc      di
  0x1D9E9: add      byte ptr [bx + si], al
  0x1D9EB: add      byte ptr [bx + si], al
  0x1D9ED: and      byte ptr [bx + si], al
  0x1D9EF: add      byte ptr [bx + si], ah
  0x1D9F1: add      byte ptr [si], ch
  0x1D9F3: and      byte ptr [bx + si], al
  0x1D9F5: cmp      ah, byte ptr [bx + si]
  0x1D9F7: add      byte ptr [0x2020], ch
  0x1D9FB: add      byte ptr [di], ah
  0x1D9FD: add      byte ptr [bx + si], ch
  0x1D9FF: add      byte ptr [bx + di], ch
  0x1DA01: add      byte ptr [bp + di], bh
  0x1DA04: jge      0x1da06
  0x1DA06: sub      ax, word ptr [bx + si]
  0x1DA08: sub      ax, 0x7800
  0x1DA0B: add      byte ptr [bx + si], dh
  0x1DA0D: add      byte ptr [si], ah
  0x1DA0F: add      byte ptr [bx + si], al
  0x1DA11: add      byte ptr [si + 0x45], cl
  0x1DA14: push     si
  0x1DA15: dec      si
  0x1DA16: xor      byte ptr [bx + si], dh
  0x1DA18: add      byte ptr [bx + si], dh
  0x1DA1A: add      byte ptr [di + 0x59], cl
  0x1DA1D: dec      sp
  0x1DA1E: inc      bp
  0x1DA1F: inc      cx
  0x1DA20: inc      sp
  0x1DA21: inc      bp
  0x1DA22: push     dx
  0x1DA23: add      byte ptr [bp + si + 0x55], al
  0x1DA26: dec      cx
  0x1DA27: dec      sp
  0x1DA28: inc      sp
  0x1DA29: add      byte ptr [bx + si], al
  0x1DA2B: add      byte ptr [bx + si], al
  0x1DA2D: add      byte ptr [bx + si], al
  0x1DA2F: add      bh, bh
