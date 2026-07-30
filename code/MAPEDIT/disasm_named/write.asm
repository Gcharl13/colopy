; MAPEDIT.EXE named disasm — module write.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _space_string  file 0x00A0D0..0x00A0E0  seg 0x8AD:0x0  (write.obj) ----
  00A0D0  55               push bp
  00A0D1  8bec             mov bp, sp
  00A0D3  684a06           push 0x64a
  00A0D6  ff7606           push word ptr [bp + 6]
  00A0D9  9ae6058813       lcall 0x1388, 0x5e6
  00A0DE  c9               leave
  00A0DF  cb               retf

; ---- _spacer  file 0x00A0E0..0x00A102  seg 0x8AD:0x10  (write.obj) ----
  00A0E0  c8020000         enter 2, 0
  00A0E4  57               push di
  00A0E5  56               push si
  00A0E6  8b5608           mov dx, word ptr [bp + 8]
  00A0E9  0bd2             or dx, dx
  00A0EB  7e10             jle 0xa0fd
  00A0ED  8bf2             mov si, dx
  00A0EF  8b7e06           mov di, word ptr [bp + 6]
  00A0F2  57               push di
  00A0F3  0e               push cs
  00A0F4  e8d9ff           call 0xa0d0
  00A0F7  83c402           add sp, 2
  00A0FA  4e               dec si
  00A0FB  75f5             jne 0xa0f2
  00A0FD  5e               pop si
  00A0FE  5f               pop di
  00A0FF  c9               leave
  00A100  cb               retf
  00A101  90               nop

; ---- _comma_string  file 0x00A102..0x00A112  seg 0x8AD:0x32  (write.obj) ----
  00A102  55               push bp
  00A103  8bec             mov bp, sp
  00A105  684c06           push 0x64c
  00A108  ff7606           push word ptr [bp + 6]
  00A10B  9ae6058813       lcall 0x1388, 0x5e6
  00A110  c9               leave
  00A111  cb               retf

; ---- _colon_string  file 0x00A112..0x00A122  seg 0x8AD:0x42  (write.obj) ----
  00A112  55               push bp
  00A113  8bec             mov bp, sp
  00A115  684f06           push 0x64f
  00A118  ff7606           push word ptr [bp + 6]
  00A11B  9ae6058813       lcall 0x1388, 0x5e6
  00A120  c9               leave
  00A121  cb               retf

; ---- _period_string  file 0x00A122..0x00A132  seg 0x8AD:0x52  (write.obj) ----
  00A122  55               push bp
  00A123  8bec             mov bp, sp
  00A125  685206           push 0x652
  00A128  ff7606           push word ptr [bp + 6]
  00A12B  9ae6058813       lcall 0x1388, 0x5e6
  00A130  c9               leave
  00A131  cb               retf

; ---- _percent_string  file 0x00A132..0x00A142  seg 0x8AD:0x62  (write.obj) ----
  00A132  55               push bp
  00A133  8bec             mov bp, sp
  00A135  685606           push 0x656
  00A138  ff7606           push word ptr [bp + 6]
  00A13B  9ae6058813       lcall 0x1388, 0x5e6
  00A140  c9               leave
  00A141  cb               retf

; ---- _open_string  file 0x00A142..0x00A152  seg 0x8AD:0x72  (write.obj) ----
  00A142  55               push bp
  00A143  8bec             mov bp, sp
  00A145  685806           push 0x658
  00A148  ff7606           push word ptr [bp + 6]
  00A14B  9ae6058813       lcall 0x1388, 0x5e6
  00A150  c9               leave
  00A151  cb               retf

; ---- _close_string  file 0x00A152..0x00A162  seg 0x8AD:0x82  (write.obj) ----
  00A152  55               push bp
  00A153  8bec             mov bp, sp
  00A155  685a06           push 0x65a
  00A158  ff7606           push word ptr [bp + 6]
  00A15B  9ae6058813       lcall 0x1388, 0x5e6
  00A160  c9               leave
  00A161  cb               retf

; ---- _brace_on  file 0x00A162..0x00A172  seg 0x8AD:0x92  (write.obj) ----
  00A162  55               push bp
  00A163  8bec             mov bp, sp
  00A165  685c06           push 0x65c
  00A168  ff7606           push word ptr [bp + 6]
  00A16B  9ae6058813       lcall 0x1388, 0x5e6
  00A170  c9               leave
  00A171  cb               retf

; ---- _brace_off  file 0x00A172..0x00A182  seg 0x8AD:0xa2  (write.obj) ----
  00A172  55               push bp
  00A173  8bec             mov bp, sp
  00A175  685e06           push 0x65e
  00A178  ff7606           push word ptr [bp + 6]
  00A17B  9ae6058813       lcall 0x1388, 0x5e6
  00A180  c9               leave
  00A181  cb               retf

; ---- _plus_string  file 0x00A182..0x00A192  seg 0x8AD:0xb2  (write.obj) ----
  00A182  55               push bp
  00A183  8bec             mov bp, sp
  00A185  686006           push 0x660
  00A188  ff7606           push word ptr [bp + 6]
  00A18B  9ae6058813       lcall 0x1388, 0x5e6
  00A190  c9               leave
  00A191  cb               retf

; ---- _minus_string  file 0x00A192..0x00A1A2  seg 0x8AD:0xc2  (write.obj) ----
  00A192  55               push bp
  00A193  8bec             mov bp, sp
  00A195  686206           push 0x662
  00A198  ff7606           push word ptr [bp + 6]
  00A19B  9ae6058813       lcall 0x1388, 0x5e6
  00A1A0  c9               leave
  00A1A1  cb               retf

; ---- _times_string  file 0x00A1A2..0x00A1B2  seg 0x8AD:0xd2  (write.obj) ----
  00A1A2  55               push bp
  00A1A3  8bec             mov bp, sp
  00A1A5  686406           push 0x664
  00A1A8  ff7606           push word ptr [bp + 6]
  00A1AB  9ae6058813       lcall 0x1388, 0x5e6
  00A1B0  c9               leave
  00A1B1  cb               retf

; ---- _say_string  file 0x00A1B2..0x00A1CC  seg 0x8AD:0xe2  (write.obj) ----
  00A1B2  55               push bp
  00A1B3  8bec             mov bp, sp
  00A1B5  ff7608           push word ptr [bp + 8]
  00A1B8  9a6c003403       lcall 0x334, 0x6c
  00A1BD  8be5             mov sp, bp
  00A1BF  52               push dx
  00A1C0  50               push ax
  00A1C1  1e               push ds
  00A1C2  ff7606           push word ptr [bp + 6]
  00A1C5  9a220e8813       lcall 0x1388, 0xe22
  00A1CA  c9               leave
  00A1CB  cb               retf

; ---- _say_braced  file 0x00A1CC..0x00A1FE  seg 0x8AD:0xfc  (write.obj) ----
  00A1CC  55               push bp
  00A1CD  8bec             mov bp, sp
  00A1CF  56               push si
  00A1D0  8b7606           mov si, word ptr [bp + 6]
  00A1D3  56               push si
  00A1D4  0e               push cs
  00A1D5  e88aff           call 0xa162
  00A1D8  83c402           add sp, 2
  00A1DB  ff7608           push word ptr [bp + 8]
  00A1DE  9a6c003403       lcall 0x334, 0x6c
  00A1E3  83c402           add sp, 2
  00A1E6  52               push dx
  00A1E7  50               push ax
  00A1E8  1e               push ds
  00A1E9  56               push si
  00A1EA  9a220e8813       lcall 0x1388, 0xe22
  00A1EF  83c408           add sp, 8
  00A1F2  56               push si
  00A1F3  0e               push cs
  00A1F4  e87bff           call 0xa172
  00A1F7  83c402           add sp, 2
  00A1FA  5e               pop si
  00A1FB  c9               leave
  00A1FC  cb               retf
  00A1FD  90               nop

; ---- _say_number  file 0x00A1FE..0x00A226  seg 0x8AD:0x12e  (write.obj) ----
  00A1FE  c8140000         enter 0x14, 0
  00A202  6a0a             push 0xa
  00A204  8d46ec           lea ax, [bp - 0x14]
  00A207  50               push ax
  00A208  ff760a           push word ptr [bp + 0xa]
  00A20B  9a3c078813       lcall 0x1388, 0x73c
  00A210  83c406           add sp, 6
  00A213  8d46ec           lea ax, [bp - 0x14]
  00A216  16               push ss
  00A217  50               push ax
  00A218  ff7608           push word ptr [bp + 8]
  00A21B  ff7606           push word ptr [bp + 6]
  00A21E  9a220e8813       lcall 0x1388, 0xe22
  00A223  c9               leave
  00A224  cb               retf
  00A225  90               nop

; ---- _say_binary  file 0x00A226..0x00A28E  seg 0x8AD:0x156  (write.obj) ----
  00A226  c8180000         enter 0x18, 0
  00A22A  57               push di
  00A22B  56               push si
  00A22C  6a02             push 2
  00A22E  8d46e8           lea ax, [bp - 0x18]
  00A231  50               push ax
  00A232  ff760a           push word ptr [bp + 0xa]
  00A235  9a3c078813       lcall 0x1388, 0x73c
  00A23A  83c406           add sp, 6
  00A23D  c746fc0000       mov word ptr [bp - 4], 0
  00A242  8d46e8           lea ax, [bp - 0x18]
  00A245  50               push ax
  00A246  9a84068813       lcall 0x1388, 0x684
  00A24B  83c402           add sp, 2
  00A24E  8bf8             mov di, ax
  00A250  b80800           mov ax, 8
  00A253  2bc7             sub ax, di
  00A255  0bc0             or ax, ax
  00A257  7e1e             jle 0xa277
  00A259  be0800           mov si, 8
  00A25C  2bf7             sub si, di
  00A25E  897efe           mov word ptr [bp - 2], di
  00A261  8b7e06           mov di, word ptr [bp + 6]
  00A264  1e               push ds
  00A265  686606           push 0x666
  00A268  ff7608           push word ptr [bp + 8]
  00A26B  57               push di
  00A26C  9a220e8813       lcall 0x1388, 0xe22
  00A271  83c408           add sp, 8
  00A274  4e               dec si
  00A275  75ed             jne 0xa264
  00A277  8d46e8           lea ax, [bp - 0x18]
  00A27A  16               push ss
  00A27B  50               push ax
  00A27C  ff7608           push word ptr [bp + 8]
  00A27F  ff7606           push word ptr [bp + 6]
  00A282  9a220e8813       lcall 0x1388, 0xe22
  00A287  83c408           add sp, 8
  00A28A  5e               pop si
  00A28B  5f               pop di
  00A28C  c9               leave
  00A28D  cb               retf

; ---- _say_long  file 0x00A28E..0x00A2B8  seg 0x8AD:0x1be  (write.obj) ----
  00A28E  c8140000         enter 0x14, 0
  00A292  6a0a             push 0xa
  00A294  8d46ec           lea ax, [bp - 0x14]
  00A297  50               push ax
  00A298  ff760c           push word ptr [bp + 0xc]
  00A29B  ff760a           push word ptr [bp + 0xa]
  00A29E  9a58078813       lcall 0x1388, 0x758
  00A2A3  83c408           add sp, 8
  00A2A6  8d46ec           lea ax, [bp - 0x14]
  00A2A9  16               push ss
  00A2AA  50               push ax
  00A2AB  ff7608           push word ptr [bp + 8]
  00A2AE  ff7606           push word ptr [bp + 6]
  00A2B1  9a220e8813       lcall 0x1388, 0xe22
  00A2B6  c9               leave
  00A2B7  cb               retf

; ---- _say_bucks  file 0x00A2B8..0x00A2E6  seg 0x8AD:0x1e8  (write.obj) ----
  00A2B8  55               push bp
  00A2B9  8bec             mov bp, sp
  00A2BB  57               push di
  00A2BC  56               push si
  00A2BD  8b7606           mov si, word ptr [bp + 6]
  00A2C0  ff760c           push word ptr [bp + 0xc]
  00A2C3  ff760a           push word ptr [bp + 0xa]
  00A2C6  8b4608           mov ax, word ptr [bp + 8]
  00A2C9  50               push ax
  00A2CA  56               push si
  00A2CB  8bf8             mov di, ax
  00A2CD  0e               push cs
  00A2CE  e8bdff           call 0xa28e
  00A2D1  83c408           add sp, 8
  00A2D4  1e               push ds
  00A2D5  686806           push 0x668
  00A2D8  57               push di
  00A2D9  56               push si
  00A2DA  9a220e8813       lcall 0x1388, 0xe22
  00A2DF  83c408           add sp, 8
  00A2E2  5e               pop si
  00A2E3  5f               pop di
  00A2E4  c9               leave
  00A2E5  cb               retf

; ---- _string_width  file 0x00A2E6..0x00A302  seg 0x8AD:0x216  (write.obj) ----
  00A2E6  55               push bp
  00A2E7  8bec             mov bp, sp
  00A2E9  ff368200         push word ptr [0x82]
  00A2ED  ff368000         push word ptr [0x80]
  00A2F1  ff7608           push word ptr [bp + 8]
  00A2F4  ff7606           push word ptr [bp + 6]
  00A2F7  2bc0             sub ax, ax
  00A2F9  9a02006c0d       lcall 0xd6c, 2
  00A2FE  48               dec ax
  00A2FF  c9               leave
  00A300  cb               retf
  00A301  90               nop

; ---- _string_width_2  file 0x00A302..0x00A31E  seg 0x8AD:0x232  (write.obj) ----
  00A302  55               push bp
  00A303  8bec             mov bp, sp
  00A305  ff36983a         push word ptr [0x3a98]
  00A309  ff36963a         push word ptr [0x3a96]
  00A30D  ff7608           push word ptr [bp + 8]
  00A310  ff7606           push word ptr [bp + 6]
  00A313  2bc0             sub ax, ax
  00A315  9a02006c0d       lcall 0xd6c, 2
  00A31A  48               dec ax
  00A31B  c9               leave
  00A31C  cb               retf
  00A31D  90               nop

; ---- _write_string  file 0x00A31E..0x00A358  seg 0x8AD:0x24e  (write.obj) ----
  00A31E  55               push bp
  00A31F  8bec             mov bp, sp
  00A321  56               push si
  00A322  8b760a           mov si, word ptr [bp + 0xa]
  00A325  6a00             push 0
  00A327  8a169200         mov dl, byte ptr [0x92]
  00A32B  2af6             sub dh, dh
  00A32D  b8ffff           mov ax, 0xffff
  00A330  2bdb             sub bx, bx
  00A332  9a06006a0d       lcall 0xd6a, 6
  00A337  ff368200         push word ptr [0x82]
  00A33B  ff368000         push word ptr [0x80]
  00A33F  ff7608           push word ptr [bp + 8]
  00A342  ff7606           push word ptr [bp + 6]
  00A345  6a00             push 0
  00A347  8d1ef43a         lea bx, [0x3af4]
  00A34B  8bc6             mov ax, si
  00A34D  8b560c           mov dx, word ptr [bp + 0xc]
  00A350  9a0800530d       lcall 0xd53, 8
  00A355  5e               pop si
  00A356  c9               leave
  00A357  cb               retf

; ---- _write_in_color  file 0x00A358..0x00A392  seg 0x8AD:0x288  (write.obj) ----
  00A358  55               push bp
  00A359  8bec             mov bp, sp
  00A35B  57               push di
  00A35C  56               push si
  00A35D  8b7e0a           mov di, word ptr [bp + 0xa]
  00A360  8b760e           mov si, word ptr [bp + 0xe]
  00A363  56               push si
  00A364  8bd6             mov dx, si
  00A366  8bde             mov bx, si
  00A368  b8ffff           mov ax, 0xffff
  00A36B  9a06006a0d       lcall 0xd6a, 6
  00A370  ff368200         push word ptr [0x82]
  00A374  ff368000         push word ptr [0x80]
  00A378  ff7608           push word ptr [bp + 8]
  00A37B  ff7606           push word ptr [bp + 6]
  00A37E  6a00             push 0
  00A380  8d1ef43a         lea bx, [0x3af4]
  00A384  8bc7             mov ax, di
  00A386  8b560c           mov dx, word ptr [bp + 0xc]
  00A389  9a0800530d       lcall 0xd53, 8
  00A38E  5e               pop si
  00A38F  5f               pop di
  00A390  c9               leave
  00A391  cb               retf

; ---- _write_right  file 0x00A392..0x00A3E8  seg 0x8AD:0x2c2  (write.obj) ----
  00A392  55               push bp
  00A393  8bec             mov bp, sp
  00A395  57               push di
  00A396  56               push si
  00A397  8b7e0e           mov di, word ptr [bp + 0xe]
  00A39A  8b760a           mov si, word ptr [bp + 0xa]
  00A39D  57               push di
  00A39E  8bd7             mov dx, di
  00A3A0  8bdf             mov bx, di
  00A3A2  b8ffff           mov ax, 0xffff
  00A3A5  9a06006a0d       lcall 0xd6a, 6
  00A3AA  ff368200         push word ptr [0x82]
  00A3AE  ff368000         push word ptr [0x80]
  00A3B2  ff7608           push word ptr [bp + 8]
  00A3B5  ff7606           push word ptr [bp + 6]
  00A3B8  2bc0             sub ax, ax
  00A3BA  9a02006c0d       lcall 0xd6c, 2
  00A3BF  2bf0             sub si, ax
  00A3C1  ff368200         push word ptr [0x82]
  00A3C5  ff368000         push word ptr [0x80]
  00A3C9  ff7608           push word ptr [bp + 8]
  00A3CC  ff7606           push word ptr [bp + 6]
  00A3CF  6a00             push 0
  00A3D1  8bc6             mov ax, si
  00A3D3  8d1ef43a         lea bx, [0x3af4]
  00A3D7  8b560c           mov dx, word ptr [bp + 0xc]
  00A3DA  8bf0             mov si, ax
  00A3DC  9a0800530d       lcall 0xd53, 8
  00A3E1  8bc6             mov ax, si
  00A3E3  5e               pop si
  00A3E4  5f               pop di
  00A3E5  c9               leave
  00A3E6  cb               retf
  00A3E7  90               nop

; ---- _write_centered  file 0x00A3E8..0x00A42C  seg 0x8AD:0x318  (write.obj) ----
  00A3E8  55               push bp
  00A3E9  8bec             mov bp, sp
  00A3EB  57               push di
  00A3EC  56               push si
  00A3ED  8b7e06           mov di, word ptr [bp + 6]
  00A3F0  ff7610           push word ptr [bp + 0x10]
  00A3F3  ff760e           push word ptr [bp + 0xe]
  00A3F6  8b4608           mov ax, word ptr [bp + 8]
  00A3F9  50               push ax
  00A3FA  57               push di
  00A3FB  8bf0             mov si, ax
  00A3FD  0e               push cs
  00A3FE  e8e5fe           call 0xa2e6
  00A401  83c404           add sp, 4
  00A404  d1f8             sar ax, 1
  00A406  8b4e0c           mov cx, word ptr [bp + 0xc]
  00A409  d1f9             sar cx, 1
  00A40B  8bd6             mov dx, si
  00A40D  8bf1             mov si, cx
  00A40F  2bf0             sub si, ax
  00A411  03760a           add si, word ptr [bp + 0xa]
  00A414  8bc6             mov ax, si
  00A416  0bc0             or ax, ax
  00A418  7d02             jge 0xa41c
  00A41A  2bc0             sub ax, ax
  00A41C  8bf0             mov si, ax
  00A41E  56               push si
  00A41F  52               push dx
  00A420  57               push di
  00A421  0e               push cs
  00A422  e833ff           call 0xa358
  00A425  83c40a           add sp, 0xa
  00A428  5e               pop si
  00A429  5f               pop di
  00A42A  c9               leave
  00A42B  cb               retf

; ---- _write_big_string  file 0x00A42C..0x00A46A  seg 0x8AD:0x35c  (write.obj) ----
  00A42C  55               push bp
  00A42D  8bec             mov bp, sp
  00A42F  56               push si
  00A430  8b760a           mov si, word ptr [bp + 0xa]
  00A433  6a00             push 0
  00A435  8a169200         mov dl, byte ptr [0x92]
  00A439  2af6             sub dh, dh
  00A43B  8a1e9500         mov bl, byte ptr [0x95]
  00A43F  2aff             sub bh, bh
  00A441  b8ffff           mov ax, 0xffff
  00A444  9a06006a0d       lcall 0xd6a, 6
  00A449  ff36983a         push word ptr [0x3a98]
  00A44D  ff36963a         push word ptr [0x3a96]
  00A451  ff7608           push word ptr [bp + 8]
  00A454  ff7606           push word ptr [bp + 6]
  00A457  6a00             push 0
  00A459  8d1ef43a         lea bx, [0x3af4]
  00A45D  8bc6             mov ax, si
  00A45F  8b560c           mov dx, word ptr [bp + 0xc]
  00A462  9a0800530d       lcall 0xd53, 8
  00A467  5e               pop si
  00A468  c9               leave
  00A469  cb               retf

; ---- _write_big_in_color  file 0x00A46A..0x00A4A2  seg 0x8AD:0x39a  (write.obj) ----
  00A46A  55               push bp
  00A46B  8bec             mov bp, sp
  00A46D  56               push si
  00A46E  8b760a           mov si, word ptr [bp + 0xa]
  00A471  6a00             push 0
  00A473  b8ffff           mov ax, 0xffff
  00A476  8b560e           mov dx, word ptr [bp + 0xe]
  00A479  8b5e10           mov bx, word ptr [bp + 0x10]
  00A47C  9a06006a0d       lcall 0xd6a, 6
  00A481  ff36983a         push word ptr [0x3a98]
  00A485  ff36963a         push word ptr [0x3a96]
  00A489  ff7608           push word ptr [bp + 8]
  00A48C  ff7606           push word ptr [bp + 6]
  00A48F  6a00             push 0
  00A491  8d1ef43a         lea bx, [0x3af4]
  00A495  8bc6             mov ax, si
  00A497  8b560c           mov dx, word ptr [bp + 0xc]
  00A49A  9a0800530d       lcall 0xd53, 8
  00A49F  5e               pop si
  00A4A0  c9               leave
  00A4A1  cb               retf

; ---- _write_big_right  file 0x00A4A2..0x00A500  seg 0x8AD:0x3d2  (write.obj) ----
  00A4A2  c8040000         enter 4, 0
  00A4A6  57               push di
  00A4A7  56               push si
  00A4A8  8b7e06           mov di, word ptr [bp + 6]
  00A4AB  8b760a           mov si, word ptr [bp + 0xa]
  00A4AE  6a00             push 0
  00A4B0  b8ffff           mov ax, 0xffff
  00A4B3  8b560e           mov dx, word ptr [bp + 0xe]
  00A4B6  8b5e10           mov bx, word ptr [bp + 0x10]
  00A4B9  9a06006a0d       lcall 0xd6a, 6
  00A4BE  ff36983a         push word ptr [0x3a98]
  00A4C2  ff36963a         push word ptr [0x3a96]
  00A4C6  8b4608           mov ax, word ptr [bp + 8]
  00A4C9  50               push ax
  00A4CA  57               push di
  00A4CB  897efc           mov word ptr [bp - 4], di
  00A4CE  8946fe           mov word ptr [bp - 2], ax
  00A4D1  2bc0             sub ax, ax
  00A4D3  9a02006c0d       lcall 0xd6c, 2
  00A4D8  2bf0             sub si, ax
  00A4DA  ff36983a         push word ptr [0x3a98]
  00A4DE  ff36963a         push word ptr [0x3a96]
  00A4E2  ff76fe           push word ptr [bp - 2]
  00A4E5  ff76fc           push word ptr [bp - 4]
  00A4E8  6a00             push 0
  00A4EA  8bc6             mov ax, si
  00A4EC  8d1ef43a         lea bx, [0x3af4]
  00A4F0  8b560c           mov dx, word ptr [bp + 0xc]
  00A4F3  8bf0             mov si, ax
  00A4F5  9a0800530d       lcall 0xd53, 8
  00A4FA  8bc6             mov ax, si
  00A4FC  5e               pop si
  00A4FD  5f               pop di
  00A4FE  c9               leave
  00A4FF  cb               retf

; ---- _write_big_centered  file 0x00A500..0x00A548  seg 0x8AD:0x430  (write.obj) ----
  00A500  55               push bp
  00A501  8bec             mov bp, sp
  00A503  57               push di
  00A504  56               push si
  00A505  8b7e06           mov di, word ptr [bp + 6]
  00A508  ff7612           push word ptr [bp + 0x12]
  00A50B  ff7610           push word ptr [bp + 0x10]
  00A50E  ff760e           push word ptr [bp + 0xe]
  00A511  8b4608           mov ax, word ptr [bp + 8]
  00A514  50               push ax
  00A515  57               push di
  00A516  8bf0             mov si, ax
  00A518  0e               push cs
  00A519  e8e6fd           call 0xa302
  00A51C  83c404           add sp, 4
  00A51F  d1f8             sar ax, 1
  00A521  8b4e0c           mov cx, word ptr [bp + 0xc]
  00A524  d1f9             sar cx, 1
  00A526  8bd6             mov dx, si
  00A528  8bf1             mov si, cx
  00A52A  2bf0             sub si, ax
  00A52C  03760a           add si, word ptr [bp + 0xa]
  00A52F  8bc6             mov ax, si
  00A531  0bc0             or ax, ax
  00A533  7d02             jge 0xa537
  00A535  2bc0             sub ax, ax
  00A537  8bf0             mov si, ax
  00A539  56               push si
  00A53A  52               push dx
  00A53B  57               push di
  00A53C  0e               push cs
  00A53D  e82aff           call 0xa46a
  00A540  83c40c           add sp, 0xc
  00A543  5e               pop si
  00A544  5f               pop di
  00A545  c9               leave
  00A546  cb               retf
  00A547  90               nop

; ---- _say_terrain  file 0x00A548..0x00A594  seg 0x8AD:0x478  (write.obj) ----
  00A548  55               push bp
  00A549  8bec             mov bp, sp
  00A54B  57               push di
  00A54C  56               push si
  00A54D  8b7608           mov si, word ptr [bp + 8]
  00A550  0bf6             or si, si
  00A552  7c0e             jl 0xa562
  00A554  8b7e06           mov di, word ptr [bp + 6]
  00A557  8bde             mov bx, si
  00A559  c1e304           shl bx, 4
  00A55C  ffb7e64e         push word ptr [bx + 0x4ee6]
  00A560  eb07             jmp 0xa569
  00A562  8b7e06           mov di, word ptr [bp + 6]
  00A565  ff368a52         push word ptr [0x528a]
  00A569  57               push di
  00A56A  0e               push cs
  00A56B  e844fc           call 0xa1b2
  00A56E  83c404           add sp, 4
  00A571  83fe08           cmp si, 8
  00A574  7c19             jl 0xa58f
  00A576  83fe18           cmp si, 0x18
  00A579  7d14             jge 0xa58f
  00A57B  57               push di
  00A57C  0e               push cs
  00A57D  e850fb           call 0xa0d0
  00A580  83c402           add sp, 2
  00A583  ff365a4b         push word ptr [0x4b5a]
  00A587  57               push di
  00A588  0e               push cs
  00A589  e826fc           call 0xa1b2
  00A58C  83c404           add sp, 4
  00A58F  5e               pop si
  00A590  5f               pop di
  00A591  c9               leave
  00A592  cb               retf
  00A593  90               nop
