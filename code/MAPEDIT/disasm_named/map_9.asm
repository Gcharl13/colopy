; MAPEDIT.EXE named disasm — module map_9.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- @allocate_map_memory  file 0x00B5F2..0x00B6B8  seg 0x9F9:0x62  (map_9.obj) ----
  00B5F2  c8020000         enter 2, 0
  00B5F6  50               push ax
  00B5F7  c746fe0100       mov word ptr [bp - 2], 1
  00B5FC  833ea60400       cmp word ptr [0x4a6], 0
  00B601  740f             je 0xb612
  00B603  c706cc04b42e     mov word ptr [0x4cc], 0x2eb4
  00B609  c706ce040000     mov word ptr [0x4ce], 0
  00B60F  eb10             jmp 0xb621
  00B611  90               nop
  00B612  a1144b           mov ax, word ptr [0x4b14]
  00B615  f72e124b         imul word ptr [0x4b12]
  00B619  99               cdq
  00B61A  a3cc04           mov word ptr [0x4cc], ax
  00B61D  8916ce04         mov word ptr [0x4ce], dx
  00B621  837efc00         cmp word ptr [bp - 4], 0
  00B625  740c             je 0xb633
  00B627  c706cc04e02e     mov word ptr [0x4cc], 0x2ee0
  00B62D  c706ce040000     mov word ptr [0x4ce], 0
  00B633  c706ec64f000     mov word ptr [0x64ec], 0xf0
  00B639  c706ee64c000     mov word ptr [0x64ee], 0xc0
  00B63F  a1cc04           mov ax, word ptr [0x4cc]
  00B642  8b16ce04         mov dx, word ptr [0x4ce]
  00B646  9ae202c90c       lcall 0xcc9, 0x2e2
  00B64B  a3a804           mov word ptr [0x4a8], ax
  00B64E  8916aa04         mov word ptr [0x4aa], dx
  00B652  8bc2             mov ax, dx
  00B654  0b06a804         or ax, word ptr [0x4a8]
  00B658  7459             je 0xb6b3
  00B65A  a1cc04           mov ax, word ptr [0x4cc]
  00B65D  8b16ce04         mov dx, word ptr [0x4ce]
  00B661  9ae202c90c       lcall 0xcc9, 0x2e2
  00B666  a3ac04           mov word ptr [0x4ac], ax
  00B669  8916ae04         mov word ptr [0x4ae], dx
  00B66D  8bc2             mov ax, dx
  00B66F  0b06ac04         or ax, word ptr [0x4ac]
  00B673  743e             je 0xb6b3
  00B675  a1cc04           mov ax, word ptr [0x4cc]
  00B678  8b16ce04         mov dx, word ptr [0x4ce]
  00B67C  9ae202c90c       lcall 0xcc9, 0x2e2
  00B681  a3b004           mov word ptr [0x4b0], ax
  00B684  8916b204         mov word ptr [0x4b2], dx
  00B688  8bc2             mov ax, dx
  00B68A  0b06b004         or ax, word ptr [0x4b0]
  00B68E  7423             je 0xb6b3
  00B690  a1cc04           mov ax, word ptr [0x4cc]
  00B693  8b16ce04         mov dx, word ptr [0x4ce]
  00B697  9ae202c90c       lcall 0xcc9, 0x2e2
  00B69C  a3b404           mov word ptr [0x4b4], ax
  00B69F  8916b604         mov word ptr [0x4b6], dx
  00B6A3  8bc2             mov ax, dx
  00B6A5  0b06b404         or ax, word ptr [0x4b4]
  00B6A9  7408             je 0xb6b3
  00B6AB  e8ecfe           call 0xb59a
  00B6AE  c746fe0000       mov word ptr [bp - 2], 0
  00B6B3  8b46fe           mov ax, word ptr [bp - 2]
  00B6B6  c9               leave
  00B6B7  cb               retf

; ---- @initialize_map_memory  file 0x00B6B8..0x00B6BC  seg 0x9F9:0x128  (map_9.obj) ----
  00B6B8  b80100           mov ax, 1
  00B6BB  cb               retf

; ---- @map_check  file 0x00B6BC..0x00B700  seg 0x9F9:0x12c  (map_9.obj) ----
  00B6BC  c8020000         enter 2, 0
  00B6C0  c746fe0100       mov word ptr [bp - 2], 1
  00B6C5  833e9e4e00       cmp word ptr [0x4e9e], 0
  00B6CA  7f12             jg 0xb6de
  00B6CC  7c08             jl 0xb6d6
  00B6CE  813e9c4ee02e     cmp word ptr [0x4e9c], 0x2ee0
  00B6D4  7708             ja 0xb6de
  00B6D6  c706a6040000     mov word ptr [0x4a6], 0
  00B6DC  eb06             jmp 0xb6e4
  00B6DE  c706a6040100     mov word ptr [0x4a6], 1
  00B6E4  833ea60400       cmp word ptr [0x4a6], 0
  00B6E9  740b             je 0xb6f6
  00B6EB  c706a4040f27     mov word ptr [0x4a4], 0x270f
  00B6F1  8b46fe           mov ax, word ptr [bp - 2]
  00B6F4  c9               leave
  00B6F5  cb               retf
  00B6F6  c746fe0000       mov word ptr [bp - 2], 0
  00B6FB  8b46fe           mov ax, word ptr [bp - 2]
  00B6FE  c9               leave
  00B6FF  cb               retf

; ---- _load_map_file  file 0x00B700..0x00B840  seg 0x9F9:0x170  (map_9.obj) ----
  00B700  c8060000         enter 6, 0
  00B704  c746fe0100       mov word ptr [bp - 2], 1
  00B709  1e               push ds
  00B70A  68184a           push 0x4a18
  00B70D  1e               push ds
  00B70E  68184a           push 0x4a18
  00B711  1e               push ds
  00B712  68a004           push 0x4a0
  00B715  9a5c00040c       lcall 0xc04, 0x5c
  00B71A  1e               push ds
  00B71B  68184a           push 0x4a18
  00B71E  8d1e0a07         lea bx, [0x70a]
  00B722  9a04019702       lcall 0x297, 0x104
  00B727  8946fa           mov word ptr [bp - 6], ax
  00B72A  0bc0             or ax, ax
  00B72C  750a             jne 0xb738
  00B72E  c706a4040100     mov word ptr [0x4a4], 1
  00B734  e9f600           jmp 0xb82d
  00B737  90               nop
  00B738  50               push ax
  00B739  6a01             push 1
  00B73B  6a04             push 4
  00B73D  68124b           push 0x4b12
  00B740  9abe038813       lcall 0x1388, 0x3be
  00B745  83c408           add sp, 8
  00B748  0bc0             or ax, ax
  00B74A  750a             jne 0xb756
  00B74C  c706a4040200     mov word ptr [0x4a4], 2
  00B752  e9d800           jmp 0xb82d
  00B755  90               nop
  00B756  ff76fa           push word ptr [bp - 6]
  00B759  6a01             push 1
  00B75B  6a02             push 2
  00B75D  8d46fc           lea ax, [bp - 4]
  00B760  50               push ax
  00B761  9abe038813       lcall 0x1388, 0x3be
  00B766  83c408           add sp, 8
  00B769  0bc0             or ax, ax
  00B76B  74df             je 0xb74c
  00B76D  837efc04         cmp word ptr [bp - 4], 4
  00B771  7f02             jg 0xb775
  00B773  7d11             jge 0xb786
  00B775  833e9e0400       cmp word ptr [0x49e], 0
  00B77A  7c0a             jl 0xb786
  00B77C  c706a4040300     mov word ptr [0x4a4], 3
  00B782  e9a800           jmp 0xb82d
  00B785  90               nop
  00B786  8b46fc           mov ax, word ptr [bp - 4]
  00B789  a39e04           mov word ptr [0x49e], ax
  00B78C  a1144b           mov ax, word ptr [0x4b14]
  00B78F  f72e124b         imul word ptr [0x4b12]
  00B793  a39c4e           mov word ptr [0x4e9c], ax
  00B796  89169e4e         mov word ptr [0x4e9e], dx
  00B79A  0e               push cs
  00B79B  e81eff           call 0xb6bc
  00B79E  0bc0             or ax, ax
  00B7A0  7403             je 0xb7a5
  00B7A2  e98800           jmp 0xb82d
  00B7A5  3906a604         cmp word ptr [0x4a6], ax
  00B7A9  7577             jne 0xb822
  00B7AB  ff36aa04         push word ptr [0x4aa]
  00B7AF  ff36a804         push word ptr [0x4a8]
  00B7B3  50               push ax
  00B7B4  6a01             push 1
  00B7B6  a19c4e           mov ax, word ptr [0x4e9c]
  00B7B9  8b169e4e         mov dx, word ptr [0x4e9e]
  00B7BD  8b5efa           mov bx, word ptr [bp - 6]
  00B7C0  9a0000ca0b       lcall 0xbca, 0
  00B7C5  0bd0             or dx, ax
  00B7C7  7509             jne 0xb7d2
  00B7C9  c706a4040400     mov word ptr [0x4a4], 4
  00B7CF  eb5c             jmp 0xb82d
  00B7D1  90               nop
  00B7D2  ff36ae04         push word ptr [0x4ae]
  00B7D6  ff36ac04         push word ptr [0x4ac]
  00B7DA  6a00             push 0
  00B7DC  6a01             push 1
  00B7DE  a19c4e           mov ax, word ptr [0x4e9c]
  00B7E1  8b169e4e         mov dx, word ptr [0x4e9e]
  00B7E5  8b5efa           mov bx, word ptr [bp - 6]
  00B7E8  9a0000ca0b       lcall 0xbca, 0
  00B7ED  0bd0             or dx, ax
  00B7EF  7509             jne 0xb7fa
  00B7F1  c706a4040500     mov word ptr [0x4a4], 5
  00B7F7  eb34             jmp 0xb82d
  00B7F9  90               nop
  00B7FA  ff36b204         push word ptr [0x4b2]
  00B7FE  ff36b004         push word ptr [0x4b0]
  00B802  6a00             push 0
  00B804  6a01             push 1
  00B806  a19c4e           mov ax, word ptr [0x4e9c]
  00B809  8b169e4e         mov dx, word ptr [0x4e9e]
  00B80D  8b5efa           mov bx, word ptr [bp - 6]
  00B810  9a0000ca0b       lcall 0xbca, 0
  00B815  0bd0             or dx, ax
  00B817  7509             jne 0xb822
  00B819  c706a4040600     mov word ptr [0x4a4], 6
  00B81F  eb0c             jmp 0xb82d
  00B821  90               nop
  00B822  2bc0             sub ax, ax
  00B824  8946fe           mov word ptr [bp - 2], ax
  00B827  a3a404           mov word ptr [0x4a4], ax
  00B82A  e86dfd           call 0xb59a
  00B82D  837efa00         cmp word ptr [bp - 6], 0
  00B831  7408             je 0xb83b
  00B833  ff76fa           push word ptr [bp - 6]
  00B836  9ac2028813       lcall 0x1388, 0x2c2
  00B83B  8b46fe           mov ax, word ptr [bp - 2]
  00B83E  c9               leave
  00B83F  cb               retf

; ---- _write_map_file  file 0x00B840..0x00B94A  seg 0x9F9:0x2b0  (map_9.obj) ----
  00B840  c8060000         enter 6, 0
  00B844  c746fe0100       mov word ptr [bp - 2], 1
  00B849  1e               push ds
  00B84A  68184a           push 0x4a18
  00B84D  1e               push ds
  00B84E  68184a           push 0x4a18
  00B851  1e               push ds
  00B852  68a004           push 0x4a0
  00B855  9a5c00040c       lcall 0xc04, 0x5c
  00B85A  1e               push ds
  00B85B  68184a           push 0x4a18
  00B85E  8d1e0d07         lea bx, [0x70d]
  00B862  9a04019702       lcall 0x297, 0x104
  00B867  8946fa           mov word ptr [bp - 6], ax
  00B86A  0bc0             or ax, ax
  00B86C  750a             jne 0xb878
  00B86E  c706a4040100     mov word ptr [0x4a4], 1
  00B874  e9c000           jmp 0xb937
  00B877  90               nop
  00B878  50               push ax
  00B879  6a01             push 1
  00B87B  6a04             push 4
  00B87D  68124b           push 0x4b12
  00B880  9aa2048813       lcall 0x1388, 0x4a2
  00B885  83c408           add sp, 8
  00B888  0bc0             or ax, ax
  00B88A  750a             jne 0xb896
  00B88C  c706a4040200     mov word ptr [0x4a4], 2
  00B892  e9a200           jmp 0xb937
  00B895  90               nop
  00B896  a19e04           mov ax, word ptr [0x49e]
  00B899  8946fc           mov word ptr [bp - 4], ax
  00B89C  ff76fa           push word ptr [bp - 6]
  00B89F  6a01             push 1
  00B8A1  6a02             push 2
  00B8A3  8d46fc           lea ax, [bp - 4]
  00B8A6  50               push ax
  00B8A7  9aa2048813       lcall 0x1388, 0x4a2
  00B8AC  83c408           add sp, 8
  00B8AF  0bc0             or ax, ax
  00B8B1  74d9             je 0xb88c
  00B8B3  a1144b           mov ax, word ptr [0x4b14]
  00B8B6  f72e124b         imul word ptr [0x4b12]
  00B8BA  a39c4e           mov word ptr [0x4e9c], ax
  00B8BD  89169e4e         mov word ptr [0x4e9e], dx
  00B8C1  833ea60400       cmp word ptr [0x4a6], 0
  00B8C6  7567             jne 0xb92f
  00B8C8  ff36aa04         push word ptr [0x4aa]
  00B8CC  ff36a804         push word ptr [0x4a8]
  00B8D0  6a00             push 0
  00B8D2  6a01             push 1
  00B8D4  8b5efa           mov bx, word ptr [bp - 6]
  00B8D7  9a0800ea0b       lcall 0xbea, 8
  00B8DC  0bd0             or dx, ax
  00B8DE  7508             jne 0xb8e8
  00B8E0  c706a4040400     mov word ptr [0x4a4], 4
  00B8E6  eb4f             jmp 0xb937
  00B8E8  ff36ae04         push word ptr [0x4ae]
  00B8EC  ff36ac04         push word ptr [0x4ac]
  00B8F0  6a00             push 0
  00B8F2  6a01             push 1
  00B8F4  a19c4e           mov ax, word ptr [0x4e9c]
  00B8F7  8b169e4e         mov dx, word ptr [0x4e9e]
  00B8FB  8b5efa           mov bx, word ptr [bp - 6]
  00B8FE  9a0800ea0b       lcall 0xbea, 8
  00B903  0bd0             or dx, ax
  00B905  7509             jne 0xb910
  00B907  c706a4040500     mov word ptr [0x4a4], 5
  00B90D  eb28             jmp 0xb937
  00B90F  90               nop
  00B910  ff36b204         push word ptr [0x4b2]
  00B914  ff36b004         push word ptr [0x4b0]
  00B918  6a00             push 0
  00B91A  6a01             push 1
  00B91C  a19c4e           mov ax, word ptr [0x4e9c]
  00B91F  8b169e4e         mov dx, word ptr [0x4e9e]
  00B923  8b5efa           mov bx, word ptr [bp - 6]
  00B926  9a0800ea0b       lcall 0xbea, 8
  00B92B  0bd0             or dx, ax
  00B92D  74d8             je 0xb907
  00B92F  2bc0             sub ax, ax
  00B931  8946fe           mov word ptr [bp - 2], ax
  00B934  a3a404           mov word ptr [0x4a4], ax
  00B937  837efa00         cmp word ptr [bp - 6], 0
  00B93B  7408             je 0xb945
  00B93D  ff76fa           push word ptr [bp - 6]
  00B940  9ac2028813       lcall 0x1388, 0x2c2
  00B945  8b46fe           mov ax, word ptr [bp - 2]
  00B948  c9               leave
  00B949  cb               retf

; ---- _create_blank_map  file 0x00B94A..0x00B9CE  seg 0x9F9:0x3ba  (map_9.obj) ----
  00B94A  c8080000         enter 8, 0
  00B94E  c746fe0100       mov word ptr [bp - 2], 1
  00B953  8b4606           mov ax, word ptr [bp + 6]
  00B956  a3124b           mov word ptr [0x4b12], ax
  00B959  8b4e08           mov cx, word ptr [bp + 8]
  00B95C  890e144b         mov word ptr [0x4b14], cx
  00B960  8bd8             mov bx, ax
  00B962  8bc1             mov ax, cx
  00B964  f7eb             imul bx
  00B966  a39c4e           mov word ptr [0x4e9c], ax
  00B969  89169e4e         mov word ptr [0x4e9e], dx
  00B96D  0e               push cs
  00B96E  e84bfd           call 0xb6bc
  00B971  0bc0             or ax, ax
  00B973  7553             jne 0xb9c8
  00B975  3906a604         cmp word ptr [0x4a6], ax
  00B979  753f             jne 0xb9ba
  00B97B  ff369c4e         push word ptr [0x4e9c]
  00B97F  6a19             push 0x19
  00B981  ff36aa04         push word ptr [0x4aa]
  00B985  ff36a804         push word ptr [0x4a8]
  00B989  9a680e8813       lcall 0x1388, 0xe68
  00B98E  83c408           add sp, 8
  00B991  ff369c4e         push word ptr [0x4e9c]
  00B995  6a00             push 0
  00B997  ff36ae04         push word ptr [0x4ae]
  00B99B  ff36ac04         push word ptr [0x4ac]
  00B99F  9a680e8813       lcall 0x1388, 0xe68
  00B9A4  83c408           add sp, 8
  00B9A7  ff369c4e         push word ptr [0x4e9c]
  00B9AB  6a00             push 0
  00B9AD  ff36b204         push word ptr [0x4b2]
  00B9B1  ff36b004         push word ptr [0x4b0]
  00B9B5  9a680e8813       lcall 0x1388, 0xe68
  00B9BA  2bc0             sub ax, ax
  00B9BC  8946fe           mov word ptr [bp - 2], ax
  00B9BF  a3a404           mov word ptr [0x4a4], ax
  00B9C2  c7069e040400     mov word ptr [0x49e], 4
  00B9C8  8b46fe           mov ax, word ptr [bp - 2]
  00B9CB  c9               leave
  00B9CC  cb               retf
  00B9CD  90               nop

; ---- @map_startup  file 0x00B9CE..0x00BA76  seg 0x9F9:0x43e  (map_9.obj) ----
  00B9CE  c8040000         enter 4, 0
  00B9D2  50               push ax
  00B9D3  c746fe0100       mov word ptr [bp - 2], 1
  00B9D8  c746fc0000       mov word ptr [bp - 4], 0
  00B9DD  833ed80400       cmp word ptr [0x4d8], 0
  00B9E2  755f             jne 0xba43
  00B9E4  1e               push ds
  00B9E5  68184a           push 0x4a18
  00B9E8  1e               push ds
  00B9E9  68184a           push 0x4a18
  00B9EC  1e               push ds
  00B9ED  68a004           push 0x4a0
  00B9F0  9a5c00040c       lcall 0xc04, 0x5c
  00B9F5  1e               push ds
  00B9F6  68184a           push 0x4a18
  00B9F9  8d1e1007         lea bx, [0x710]
  00B9FD  9a04019702       lcall 0x297, 0x104
  00BA02  8946fc           mov word ptr [bp - 4], ax
  00BA05  c706124b7800     mov word ptr [0x4b12], 0x78
  00BA0B  c706144b4b00     mov word ptr [0x4b14], 0x4b
  00BA11  c7069c4e2823     mov word ptr [0x4e9c], 0x2328
  00BA17  c7069e4e0000     mov word ptr [0x4e9e], 0
  00BA1D  0bc0             or ax, ax
  00BA1F  7422             je 0xba43
  00BA21  50               push ax
  00BA22  6a01             push 1
  00BA24  6a04             push 4
  00BA26  68124b           push 0x4b12
  00BA29  9abe038813       lcall 0x1388, 0x3be
  00BA2E  83c408           add sp, 8
  00BA31  0bc0             or ax, ax
  00BA33  740e             je 0xba43
  00BA35  a1144b           mov ax, word ptr [0x4b14]
  00BA38  f72e124b         imul word ptr [0x4b12]
  00BA3C  a39c4e           mov word ptr [0x4e9c], ax
  00BA3F  89169e4e         mov word ptr [0x4e9e], dx
  00BA43  0e               push cs
  00BA44  e875fc           call 0xb6bc
  00BA47  0bc0             or ax, ax
  00BA49  7518             jne 0xba63
  00BA4B  8b46fa           mov ax, word ptr [bp - 6]
  00BA4E  0e               push cs
  00BA4F  e8a0fb           call 0xb5f2
  00BA52  0bc0             or ax, ax
  00BA54  7408             je 0xba5e
  00BA56  c706a4041300     mov word ptr [0x4a4], 0x13
  00BA5C  eb05             jmp 0xba63
  00BA5E  c746fe0000       mov word ptr [bp - 2], 0
  00BA63  837efc00         cmp word ptr [bp - 4], 0
  00BA67  7408             je 0xba71
  00BA69  ff76fc           push word ptr [bp - 4]
  00BA6C  9ac2028813       lcall 0x1388, 0x2c2
  00BA71  8b46fe           mov ax, word ptr [bp - 2]
  00BA74  c9               leave
  00BA75  cb               retf
