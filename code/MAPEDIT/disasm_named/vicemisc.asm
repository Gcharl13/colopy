; MAPEDIT.EXE named disasm — module vicemisc.obj
; symbols: CodeView NB02 publics (data_extracted/mapedit_symbols.json)
; file_offset = seg*16 + off + 0x1600 (image base)

; ---- _construct_main_menu  file 0x00A594..0x00AE76  seg 0x8F9:0x4  (vicemisc.obj) ----
  00A594  c8040000         enter 4, 0
  00A598  57               push di
  00A599  56               push si
  00A59A  be0100           mov si, 1
  00A59D  ff368200         push word ptr [0x82]
  00A5A1  ff368000         push word ptr [0x80]
  00A5A5  68a00f           push 0xfa0
  00A5A8  9afe02d706       lcall 0x6d7, 0x2fe
  00A5AD  83c406           add sp, 6
  00A5B0  a37800           mov word ptr [0x78], ax
  00A5B3  89167a00         mov word ptr [0x7a], dx
  00A5B7  8bc2             mov ax, dx
  00A5B9  0b067800         or ax, word ptr [0x78]
  00A5BD  7503             jne 0xa5c2
  00A5BF  e9d10a           jmp 0xb093
  00A5C2  686a06           push 0x66a
  00A5C5  686f06           push 0x66f
  00A5C8  9a1a004208       lcall 0x842, 0x1a
  00A5CD  83c404           add sp, 4
  00A5D0  0bc0             or ax, ax
  00A5D2  7403             je 0xa5d7
  00A5D4  e9bc0a           jmp 0xb093
  00A5D7  50               push ax
  00A5D8  56               push si
  00A5D9  9a06014208       lcall 0x842, 0x106
  00A5DE  1e               push ds
  00A5DF  50               push ax
  00A5E0  ff367a00         push word ptr [0x7a]
  00A5E4  ff367800         push word ptr [0x78]
  00A5E8  9a4206d706       lcall 0x6d7, 0x642
  00A5ED  83c40c           add sp, 0xc
  00A5F0  56               push si
  00A5F1  9a06014208       lcall 0x842, 0x106
  00A5F6  1e               push ds
  00A5F7  50               push ax
  00A5F8  56               push si
  00A5F9  ff367a00         push word ptr [0x7a]
  00A5FD  ff367800         push word ptr [0x78]
  00A601  9ade07d706       lcall 0x6d7, 0x7de
  00A606  83c40c           add sp, 0xc
  00A609  6a02             push 2
  00A60B  9a06014208       lcall 0x842, 0x106
  00A610  1e               push ds
  00A611  50               push ax
  00A612  56               push si
  00A613  ff367a00         push word ptr [0x7a]
  00A617  ff367800         push word ptr [0x78]
  00A61B  9ade07d706       lcall 0x6d7, 0x7de
  00A620  83c40c           add sp, 0xc
  00A623  6a00             push 0
  00A625  1e               push ds
  00A626  687406           push 0x674
  00A629  56               push si
  00A62A  ff367a00         push word ptr [0x7a]
  00A62E  ff367800         push word ptr [0x78]
  00A632  9ade07d706       lcall 0x6d7, 0x7de
  00A637  83c40c           add sp, 0xc
  00A63A  6a03             push 3
  00A63C  9a06014208       lcall 0x842, 0x106
  00A641  1e               push ds
  00A642  50               push ax
  00A643  56               push si
  00A644  ff367a00         push word ptr [0x7a]
  00A648  ff367800         push word ptr [0x78]
  00A64C  9ade07d706       lcall 0x6d7, 0x7de
  00A651  83c40c           add sp, 0xc
  00A654  6a04             push 4
  00A656  9a06014208       lcall 0x842, 0x106
  00A65B  1e               push ds
  00A65C  50               push ax
  00A65D  56               push si
  00A65E  ff367a00         push word ptr [0x7a]
  00A662  ff367800         push word ptr [0x78]
  00A666  9ade07d706       lcall 0x6d7, 0x7de
  00A66B  83c40c           add sp, 0xc
  00A66E  6a00             push 0
  00A670  1e               push ds
  00A671  687506           push 0x675
  00A674  56               push si
  00A675  ff367a00         push word ptr [0x7a]
  00A679  ff367800         push word ptr [0x78]
  00A67D  9ade07d706       lcall 0x6d7, 0x7de
  00A682  83c40c           add sp, 0xc
  00A685  6a1a             push 0x1a
  00A687  9a06014208       lcall 0x842, 0x106
  00A68C  1e               push ds
  00A68D  50               push ax
  00A68E  56               push si
  00A68F  ff367a00         push word ptr [0x7a]
  00A693  ff367800         push word ptr [0x78]
  00A697  9ade07d706       lcall 0x6d7, 0x7de
  00A69C  83c40c           add sp, 0xc
  00A69F  6a1b             push 0x1b
  00A6A1  9a06014208       lcall 0x842, 0x106
  00A6A6  1e               push ds
  00A6A7  50               push ax
  00A6A8  56               push si
  00A6A9  ff367a00         push word ptr [0x7a]
  00A6AD  ff367800         push word ptr [0x78]
  00A6B1  9ade07d706       lcall 0x6d7, 0x7de
  00A6B6  83c40c           add sp, 0xc
  00A6B9  6a00             push 0
  00A6BB  1e               push ds
  00A6BC  687606           push 0x676
  00A6BF  56               push si
  00A6C0  ff367a00         push word ptr [0x7a]
  00A6C4  ff367800         push word ptr [0x78]
  00A6C8  9ade07d706       lcall 0x6d7, 0x7de
  00A6CD  83c40c           add sp, 0xc
  00A6D0  6a1c             push 0x1c
  00A6D2  9a06014208       lcall 0x842, 0x106
  00A6D7  1e               push ds
  00A6D8  50               push ax
  00A6D9  56               push si
  00A6DA  ff367a00         push word ptr [0x7a]
  00A6DE  ff367800         push word ptr [0x78]
  00A6E2  9ade07d706       lcall 0x6d7, 0x7de
  00A6E7  83c40c           add sp, 0xc
  00A6EA  6a00             push 0
  00A6EC  1e               push ds
  00A6ED  687706           push 0x677
  00A6F0  56               push si
  00A6F1  ff367a00         push word ptr [0x7a]
  00A6F5  ff367800         push word ptr [0x78]
  00A6F9  9ade07d706       lcall 0x6d7, 0x7de
  00A6FE  83c40c           add sp, 0xc
  00A701  6a1e             push 0x1e
  00A703  9a06014208       lcall 0x842, 0x106
  00A708  1e               push ds
  00A709  50               push ax
  00A70A  56               push si
  00A70B  ff367a00         push word ptr [0x7a]
  00A70F  ff367800         push word ptr [0x78]
  00A713  9ade07d706       lcall 0x6d7, 0x7de
  00A718  83c40c           add sp, 0xc
  00A71B  6a1f             push 0x1f
  00A71D  9a06014208       lcall 0x842, 0x106
  00A722  1e               push ds
  00A723  50               push ax
  00A724  56               push si
  00A725  ff367a00         push word ptr [0x7a]
  00A729  ff367800         push word ptr [0x78]
  00A72D  9ade07d706       lcall 0x6d7, 0x7de
  00A732  83c40c           add sp, 0xc
  00A735  687806           push 0x678
  00A738  6a00             push 0
  00A73A  9a1a004208       lcall 0x842, 0x1a
  00A73F  83c404           add sp, 4
  00A742  0bc0             or ax, ax
  00A744  7403             je 0xa749
  00A746  e94a09           jmp 0xb093
  00A749  50               push ax
  00A74A  6a02             push 2
  00A74C  9a06014208       lcall 0x842, 0x106
  00A751  1e               push ds
  00A752  50               push ax
  00A753  ff367a00         push word ptr [0x7a]
  00A757  ff367800         push word ptr [0x78]
  00A75B  9a4206d706       lcall 0x6d7, 0x642
  00A760  83c40c           add sp, 0xc
  00A763  6a20             push 0x20
  00A765  9a06014208       lcall 0x842, 0x106
  00A76A  1e               push ds
  00A76B  50               push ax
  00A76C  6a02             push 2
  00A76E  ff367a00         push word ptr [0x7a]
  00A772  ff367800         push word ptr [0x78]
  00A776  9ade07d706       lcall 0x6d7, 0x7de
  00A77B  83c40c           add sp, 0xc
  00A77E  6a21             push 0x21
  00A780  9a06014208       lcall 0x842, 0x106
  00A785  1e               push ds
  00A786  50               push ax
  00A787  6a02             push 2
  00A789  ff367a00         push word ptr [0x7a]
  00A78D  ff367800         push word ptr [0x78]
  00A791  9ade07d706       lcall 0x6d7, 0x7de
  00A796  83c40c           add sp, 0xc
  00A799  6a22             push 0x22
  00A79B  9a06014208       lcall 0x842, 0x106
  00A7A0  1e               push ds
  00A7A1  50               push ax
  00A7A2  6a02             push 2
  00A7A4  ff367a00         push word ptr [0x7a]
  00A7A8  ff367800         push word ptr [0x78]
  00A7AC  9ade07d706       lcall 0x6d7, 0x7de
  00A7B1  83c40c           add sp, 0xc
  00A7B4  6a00             push 0
  00A7B6  1e               push ds
  00A7B7  687d06           push 0x67d
  00A7BA  6a02             push 2
  00A7BC  ff367a00         push word ptr [0x7a]
  00A7C0  ff367800         push word ptr [0x78]
  00A7C4  9ade07d706       lcall 0x6d7, 0x7de
  00A7C9  83c40c           add sp, 0xc
  00A7CC  6a23             push 0x23
  00A7CE  9a06014208       lcall 0x842, 0x106
  00A7D3  1e               push ds
  00A7D4  50               push ax
  00A7D5  6a02             push 2
  00A7D7  ff367a00         push word ptr [0x7a]
  00A7DB  ff367800         push word ptr [0x78]
  00A7DF  9ade07d706       lcall 0x6d7, 0x7de
  00A7E4  83c40c           add sp, 0xc
  00A7E7  6a00             push 0
  00A7E9  1e               push ds
  00A7EA  687e06           push 0x67e
  00A7ED  6a02             push 2
  00A7EF  ff367a00         push word ptr [0x7a]
  00A7F3  ff367800         push word ptr [0x78]
  00A7F7  9ade07d706       lcall 0x6d7, 0x7de
  00A7FC  83c40c           add sp, 0xc
  00A7FF  6a24             push 0x24
  00A801  9a06014208       lcall 0x842, 0x106
  00A806  1e               push ds
  00A807  50               push ax
  00A808  6a02             push 2
  00A80A  ff367a00         push word ptr [0x7a]
  00A80E  ff367800         push word ptr [0x78]
  00A812  9ade07d706       lcall 0x6d7, 0x7de
  00A817  83c40c           add sp, 0xc
  00A81A  6a25             push 0x25
  00A81C  9a06014208       lcall 0x842, 0x106
  00A821  1e               push ds
  00A822  50               push ax
  00A823  6a02             push 2
  00A825  ff367a00         push word ptr [0x7a]
  00A829  ff367800         push word ptr [0x78]
  00A82D  9ade07d706       lcall 0x6d7, 0x7de
  00A832  83c40c           add sp, 0xc
  00A835  6a00             push 0
  00A837  1e               push ds
  00A838  687f06           push 0x67f
  00A83B  6a02             push 2
  00A83D  ff367a00         push word ptr [0x7a]
  00A841  ff367800         push word ptr [0x78]
  00A845  9ade07d706       lcall 0x6d7, 0x7de
  00A84A  83c40c           add sp, 0xc
  00A84D  6a26             push 0x26
  00A84F  9a06014208       lcall 0x842, 0x106
  00A854  1e               push ds
  00A855  50               push ax
  00A856  6a02             push 2
  00A858  ff367a00         push word ptr [0x7a]
  00A85C  ff367800         push word ptr [0x78]
  00A860  9ade07d706       lcall 0x6d7, 0x7de
  00A865  83c40c           add sp, 0xc
  00A868  6a27             push 0x27
  00A86A  9a06014208       lcall 0x842, 0x106
  00A86F  1e               push ds
  00A870  50               push ax
  00A871  6a02             push 2
  00A873  ff367a00         push word ptr [0x7a]
  00A877  ff367800         push word ptr [0x78]
  00A87B  9ade07d706       lcall 0x6d7, 0x7de
  00A880  83c40c           add sp, 0xc
  00A883  6a28             push 0x28
  00A885  9a06014208       lcall 0x842, 0x106
  00A88A  1e               push ds
  00A88B  50               push ax
  00A88C  6a02             push 2
  00A88E  ff367a00         push word ptr [0x7a]
  00A892  ff367800         push word ptr [0x78]
  00A896  9ade07d706       lcall 0x6d7, 0x7de
  00A89B  83c40c           add sp, 0xc
  00A89E  6a29             push 0x29
  00A8A0  9a06014208       lcall 0x842, 0x106
  00A8A5  1e               push ds
  00A8A6  50               push ax
  00A8A7  6a02             push 2
  00A8A9  ff367a00         push word ptr [0x7a]
  00A8AD  ff367800         push word ptr [0x78]
  00A8B1  9ade07d706       lcall 0x6d7, 0x7de
  00A8B6  83c40c           add sp, 0xc
  00A8B9  6a00             push 0
  00A8BB  1e               push ds
  00A8BC  688006           push 0x680
  00A8BF  6a02             push 2
  00A8C1  ff367a00         push word ptr [0x7a]
  00A8C5  ff367800         push word ptr [0x78]
  00A8C9  9ade07d706       lcall 0x6d7, 0x7de
  00A8CE  83c40c           add sp, 0xc
  00A8D1  6a2a             push 0x2a
  00A8D3  9a06014208       lcall 0x842, 0x106
  00A8D8  1e               push ds
  00A8D9  50               push ax
  00A8DA  6a02             push 2
  00A8DC  ff367a00         push word ptr [0x7a]
  00A8E0  ff367800         push word ptr [0x78]
  00A8E4  9ade07d706       lcall 0x6d7, 0x7de
  00A8E9  83c40c           add sp, 0xc
  00A8EC  6a2b             push 0x2b
  00A8EE  9a06014208       lcall 0x842, 0x106
  00A8F3  1e               push ds
  00A8F4  50               push ax
  00A8F5  6a02             push 2
  00A8F7  ff367a00         push word ptr [0x7a]
  00A8FB  ff367800         push word ptr [0x78]
  00A8FF  9ade07d706       lcall 0x6d7, 0x7de
  00A904  83c40c           add sp, 0xc
  00A907  688106           push 0x681
  00A90A  6a00             push 0
  00A90C  9a1a004208       lcall 0x842, 0x1a
  00A911  83c404           add sp, 4
  00A914  0bc0             or ax, ax
  00A916  7403             je 0xa91b
  00A918  e97807           jmp 0xb093
  00A91B  50               push ax
  00A91C  6a03             push 3
  00A91E  9a06014208       lcall 0x842, 0x106
  00A923  1e               push ds
  00A924  50               push ax
  00A925  ff367a00         push word ptr [0x7a]
  00A929  ff367800         push word ptr [0x78]
  00A92D  9a4206d706       lcall 0x6d7, 0x642
  00A932  83c40c           add sp, 0xc
  00A935  680003           push 0x300
  00A938  9a06014208       lcall 0x842, 0x106
  00A93D  1e               push ds
  00A93E  50               push ax
  00A93F  6a03             push 3
  00A941  ff367a00         push word ptr [0x7a]
  00A945  ff367800         push word ptr [0x78]
  00A949  9ade07d706       lcall 0x6d7, 0x7de
  00A94E  83c40c           add sp, 0xc
  00A951  680103           push 0x301
  00A954  9a06014208       lcall 0x842, 0x106
  00A959  1e               push ds
  00A95A  50               push ax
  00A95B  6a03             push 3
  00A95D  ff367a00         push word ptr [0x7a]
  00A961  ff367800         push word ptr [0x78]
  00A965  9ade07d706       lcall 0x6d7, 0x7de
  00A96A  83c40c           add sp, 0xc
  00A96D  680203           push 0x302
  00A970  9a06014208       lcall 0x842, 0x106
  00A975  1e               push ds
  00A976  50               push ax
  00A977  6a03             push 3
  00A979  ff367a00         push word ptr [0x7a]
  00A97D  ff367800         push word ptr [0x78]
  00A981  9ade07d706       lcall 0x6d7, 0x7de
  00A986  83c40c           add sp, 0xc
  00A989  680303           push 0x303
  00A98C  9a06014208       lcall 0x842, 0x106
  00A991  1e               push ds
  00A992  50               push ax
  00A993  6a03             push 3
  00A995  ff367a00         push word ptr [0x7a]
  00A999  ff367800         push word ptr [0x78]
  00A99D  9ade07d706       lcall 0x6d7, 0x7de
  00A9A2  83c40c           add sp, 0xc
  00A9A5  680403           push 0x304
  00A9A8  9a06014208       lcall 0x842, 0x106
  00A9AD  1e               push ds
  00A9AE  50               push ax
  00A9AF  6a03             push 3
  00A9B1  ff367a00         push word ptr [0x7a]
  00A9B5  ff367800         push word ptr [0x78]
  00A9B9  9ade07d706       lcall 0x6d7, 0x7de
  00A9BE  83c40c           add sp, 0xc
  00A9C1  6a00             push 0
  00A9C3  1e               push ds
  00A9C4  688806           push 0x688
  00A9C7  6a03             push 3
  00A9C9  ff367a00         push word ptr [0x7a]
  00A9CD  ff367800         push word ptr [0x78]
  00A9D1  9ade07d706       lcall 0x6d7, 0x7de
  00A9D6  83c40c           add sp, 0xc
  00A9D9  681003           push 0x310
  00A9DC  9a06014208       lcall 0x842, 0x106
  00A9E1  1e               push ds
  00A9E2  50               push ax
  00A9E3  6a03             push 3
  00A9E5  ff367a00         push word ptr [0x7a]
  00A9E9  ff367800         push word ptr [0x78]
  00A9ED  9ade07d706       lcall 0x6d7, 0x7de
  00A9F2  83c40c           add sp, 0xc
  00A9F5  681103           push 0x311
  00A9F8  9a06014208       lcall 0x842, 0x106
  00A9FD  1e               push ds
  00A9FE  50               push ax
  00A9FF  6a03             push 3
  00AA01  ff367a00         push word ptr [0x7a]
  00AA05  ff367800         push word ptr [0x78]
  00AA09  9ade07d706       lcall 0x6d7, 0x7de
  00AA0E  83c40c           add sp, 0xc
  00AA11  681203           push 0x312
  00AA14  9a06014208       lcall 0x842, 0x106
  00AA19  1e               push ds
  00AA1A  50               push ax
  00AA1B  6a03             push 3
  00AA1D  ff367a00         push word ptr [0x7a]
  00AA21  ff367800         push word ptr [0x78]
  00AA25  9ade07d706       lcall 0x6d7, 0x7de
  00AA2A  83c40c           add sp, 0xc
  00AA2D  681303           push 0x313
  00AA30  9a06014208       lcall 0x842, 0x106
  00AA35  1e               push ds
  00AA36  50               push ax
  00AA37  6a03             push 3
  00AA39  ff367a00         push word ptr [0x7a]
  00AA3D  ff367800         push word ptr [0x78]
  00AA41  9ade07d706       lcall 0x6d7, 0x7de
  00AA46  83c40c           add sp, 0xc
  00AA49  681403           push 0x314
  00AA4C  9a06014208       lcall 0x842, 0x106
  00AA51  1e               push ds
  00AA52  50               push ax
  00AA53  6a03             push 3
  00AA55  ff367a00         push word ptr [0x7a]
  00AA59  ff367800         push word ptr [0x78]
  00AA5D  9ade07d706       lcall 0x6d7, 0x7de
  00AA62  83c40c           add sp, 0xc
  00AA65  681503           push 0x315
  00AA68  9a06014208       lcall 0x842, 0x106
  00AA6D  1e               push ds
  00AA6E  50               push ax
  00AA6F  6a03             push 3
  00AA71  ff367a00         push word ptr [0x7a]
  00AA75  ff367800         push word ptr [0x78]
  00AA79  9ade07d706       lcall 0x6d7, 0x7de
  00AA7E  83c40c           add sp, 0xc
  00AA81  681603           push 0x316
  00AA84  9a06014208       lcall 0x842, 0x106
  00AA89  1e               push ds
  00AA8A  50               push ax
  00AA8B  6a03             push 3
  00AA8D  ff367a00         push word ptr [0x7a]
  00AA91  ff367800         push word ptr [0x78]
  00AA95  9ade07d706       lcall 0x6d7, 0x7de
  00AA9A  83c40c           add sp, 0xc
  00AA9D  681703           push 0x317
  00AAA0  9a06014208       lcall 0x842, 0x106
  00AAA5  1e               push ds
  00AAA6  50               push ax
  00AAA7  6a03             push 3
  00AAA9  ff367a00         push word ptr [0x7a]
  00AAAD  ff367800         push word ptr [0x78]
  00AAB1  9ade07d706       lcall 0x6d7, 0x7de
  00AAB6  83c40c           add sp, 0xc
  00AAB9  68ff00           push 0xff
  00AABC  1e               push ds
  00AABD  688906           push 0x689
  00AAC0  6a03             push 3
  00AAC2  ff367a00         push word ptr [0x7a]
  00AAC6  ff367800         push word ptr [0x78]
  00AACA  9ade07d706       lcall 0x6d7, 0x7de
  00AACF  83c40c           add sp, 0xc
  00AAD2  682003           push 0x320
  00AAD5  9a06014208       lcall 0x842, 0x106
  00AADA  1e               push ds
  00AADB  50               push ax
  00AADC  6a03             push 3
  00AADE  ff367a00         push word ptr [0x7a]
  00AAE2  ff367800         push word ptr [0x78]
  00AAE6  9ade07d706       lcall 0x6d7, 0x7de
  00AAEB  83c40c           add sp, 0xc
  00AAEE  682103           push 0x321
  00AAF1  9a06014208       lcall 0x842, 0x106
  00AAF6  1e               push ds
  00AAF7  50               push ax
  00AAF8  6a03             push 3
  00AAFA  ff367a00         push word ptr [0x7a]
  00AAFE  ff367800         push word ptr [0x78]
  00AB02  9ade07d706       lcall 0x6d7, 0x7de
  00AB07  83c40c           add sp, 0xc
  00AB0A  682203           push 0x322
  00AB0D  9a06014208       lcall 0x842, 0x106
  00AB12  1e               push ds
  00AB13  50               push ax
  00AB14  6a03             push 3
  00AB16  ff367a00         push word ptr [0x7a]
  00AB1A  ff367800         push word ptr [0x78]
  00AB1E  9ade07d706       lcall 0x6d7, 0x7de
  00AB23  83c40c           add sp, 0xc
  00AB26  682303           push 0x323
  00AB29  9a06014208       lcall 0x842, 0x106
  00AB2E  1e               push ds
  00AB2F  50               push ax
  00AB30  6a03             push 3
  00AB32  ff367a00         push word ptr [0x7a]
  00AB36  ff367800         push word ptr [0x78]
  00AB3A  9ade07d706       lcall 0x6d7, 0x7de
  00AB3F  83c40c           add sp, 0xc
  00AB42  680001           push 0x100
  00AB45  1e               push ds
  00AB46  688a06           push 0x68a
  00AB49  6a03             push 3
  00AB4B  ff367a00         push word ptr [0x7a]
  00AB4F  ff367800         push word ptr [0x78]
  00AB53  9ade07d706       lcall 0x6d7, 0x7de
  00AB58  83c40c           add sp, 0xc
  00AB5B  683003           push 0x330
  00AB5E  9a06014208       lcall 0x842, 0x106
  00AB63  1e               push ds
  00AB64  50               push ax
  00AB65  6a03             push 3
  00AB67  ff367a00         push word ptr [0x7a]
  00AB6B  ff367800         push word ptr [0x78]
  00AB6F  9ade07d706       lcall 0x6d7, 0x7de
  00AB74  83c40c           add sp, 0xc
  00AB77  6a00             push 0
  00AB79  1e               push ds
  00AB7A  688b06           push 0x68b
  00AB7D  6a03             push 3
  00AB7F  ff367a00         push word ptr [0x7a]
  00AB83  ff367800         push word ptr [0x78]
  00AB87  9ade07d706       lcall 0x6d7, 0x7de
  00AB8C  83c40c           add sp, 0xc
  00AB8F  683103           push 0x331
  00AB92  9a06014208       lcall 0x842, 0x106
  00AB97  1e               push ds
  00AB98  50               push ax
  00AB99  6a03             push 3
  00AB9B  ff367a00         push word ptr [0x7a]
  00AB9F  ff367800         push word ptr [0x78]
  00ABA3  9ade07d706       lcall 0x6d7, 0x7de
  00ABA8  83c40c           add sp, 0xc
  00ABAB  683203           push 0x332
  00ABAE  9a06014208       lcall 0x842, 0x106
  00ABB3  1e               push ds
  00ABB4  50               push ax
  00ABB5  6a03             push 3
  00ABB7  ff367a00         push word ptr [0x7a]
  00ABBB  ff367800         push word ptr [0x78]
  00ABBF  9ade07d706       lcall 0x6d7, 0x7de
  00ABC4  83c40c           add sp, 0xc
  00ABC7  688c06           push 0x68c
  00ABCA  6a00             push 0
  00ABCC  9a1a004208       lcall 0x842, 0x1a
  00ABD1  83c404           add sp, 4
  00ABD4  0bc0             or ax, ax
  00ABD6  7403             je 0xabdb
  00ABD8  e9b804           jmp 0xb093
  00ABDB  50               push ax
  00ABDC  6a04             push 4
  00ABDE  9a06014208       lcall 0x842, 0x106
  00ABE3  1e               push ds
  00ABE4  50               push ax
  00ABE5  ff367a00         push word ptr [0x7a]
  00ABE9  ff367800         push word ptr [0x78]
  00ABED  9a4206d706       lcall 0x6d7, 0x642
  00ABF2  83c40c           add sp, 0xc
  00ABF5  6a40             push 0x40
  00ABF7  9a06014208       lcall 0x842, 0x106
  00ABFC  1e               push ds
  00ABFD  50               push ax
  00ABFE  6a04             push 4
  00AC00  ff367a00         push word ptr [0x7a]
  00AC04  ff367800         push word ptr [0x78]
  00AC08  9ade07d706       lcall 0x6d7, 0x7de
  00AC0D  83c40c           add sp, 0xc
  00AC10  6a00             push 0
  00AC12  1e               push ds
  00AC13  689406           push 0x694
  00AC16  6a04             push 4
  00AC18  ff367a00         push word ptr [0x7a]
  00AC1C  ff367800         push word ptr [0x78]
  00AC20  9ade07d706       lcall 0x6d7, 0x7de
  00AC25  83c40c           add sp, 0xc
  00AC28  6a41             push 0x41
  00AC2A  9a06014208       lcall 0x842, 0x106
  00AC2F  1e               push ds
  00AC30  50               push ax
  00AC31  6a04             push 4
  00AC33  ff367a00         push word ptr [0x7a]
  00AC37  ff367800         push word ptr [0x78]
  00AC3B  9ade07d706       lcall 0x6d7, 0x7de
  00AC40  83c40c           add sp, 0xc
  00AC43  6a42             push 0x42
  00AC45  9a06014208       lcall 0x842, 0x106
  00AC4A  1e               push ds
  00AC4B  50               push ax
  00AC4C  6a04             push 4
  00AC4E  ff367a00         push word ptr [0x7a]
  00AC52  ff367800         push word ptr [0x78]
  00AC56  9ade07d706       lcall 0x6d7, 0x7de
  00AC5B  83c40c           add sp, 0xc
  00AC5E  6a43             push 0x43
  00AC60  9a06014208       lcall 0x842, 0x106
  00AC65  1e               push ds
  00AC66  50               push ax
  00AC67  6a04             push 4
  00AC69  ff367a00         push word ptr [0x7a]
  00AC6D  ff367800         push word ptr [0x78]
  00AC71  9ade07d706       lcall 0x6d7, 0x7de
  00AC76  83c40c           add sp, 0xc
  00AC79  6a44             push 0x44
  00AC7B  9a06014208       lcall 0x842, 0x106
  00AC80  1e               push ds
  00AC81  50               push ax
  00AC82  6a04             push 4
  00AC84  ff367a00         push word ptr [0x7a]
  00AC88  ff367800         push word ptr [0x78]
  00AC8C  9ade07d706       lcall 0x6d7, 0x7de
  00AC91  83c40c           add sp, 0xc
  00AC94  6a00             push 0
  00AC96  1e               push ds
  00AC97  689506           push 0x695
  00AC9A  6a04             push 4
  00AC9C  ff367a00         push word ptr [0x7a]
  00ACA0  ff367800         push word ptr [0x78]
  00ACA4  9ade07d706       lcall 0x6d7, 0x7de
  00ACA9  83c40c           add sp, 0xc
  00ACAC  6a45             push 0x45
  00ACAE  9a06014208       lcall 0x842, 0x106
  00ACB3  1e               push ds
  00ACB4  50               push ax
  00ACB5  6a04             push 4
  00ACB7  ff367a00         push word ptr [0x7a]
  00ACBB  ff367800         push word ptr [0x78]
  00ACBF  9ade07d706       lcall 0x6d7, 0x7de
  00ACC4  83c40c           add sp, 0xc
  00ACC7  6a46             push 0x46
  00ACC9  9a06014208       lcall 0x842, 0x106
  00ACCE  1e               push ds
  00ACCF  50               push ax
  00ACD0  6a04             push 4
  00ACD2  ff367a00         push word ptr [0x7a]
  00ACD6  ff367800         push word ptr [0x78]
  00ACDA  9ade07d706       lcall 0x6d7, 0x7de
  00ACDF  83c40c           add sp, 0xc
  00ACE2  6a47             push 0x47
  00ACE4  9a06014208       lcall 0x842, 0x106
  00ACE9  1e               push ds
  00ACEA  50               push ax
  00ACEB  6a04             push 4
  00ACED  ff367a00         push word ptr [0x7a]
  00ACF1  ff367800         push word ptr [0x78]
  00ACF5  9ade07d706       lcall 0x6d7, 0x7de
  00ACFA  83c40c           add sp, 0xc
  00ACFD  6a48             push 0x48
  00ACFF  9a06014208       lcall 0x842, 0x106
  00AD04  1e               push ds
  00AD05  50               push ax
  00AD06  6a04             push 4
  00AD08  ff367a00         push word ptr [0x7a]
  00AD0C  ff367800         push word ptr [0x78]
  00AD10  9ade07d706       lcall 0x6d7, 0x7de
  00AD15  83c40c           add sp, 0xc
  00AD18  6a00             push 0
  00AD1A  1e               push ds
  00AD1B  689606           push 0x696
  00AD1E  6a04             push 4
  00AD20  ff367a00         push word ptr [0x7a]
  00AD24  ff367800         push word ptr [0x78]
  00AD28  9ade07d706       lcall 0x6d7, 0x7de
  00AD2D  83c40c           add sp, 0xc
  00AD30  6a49             push 0x49
  00AD32  9a06014208       lcall 0x842, 0x106
  00AD37  1e               push ds
  00AD38  50               push ax
  00AD39  6a04             push 4
  00AD3B  ff367a00         push word ptr [0x7a]
  00AD3F  ff367800         push word ptr [0x78]
  00AD43  9ade07d706       lcall 0x6d7, 0x7de
  00AD48  83c40c           add sp, 0xc
  00AD4B  689706           push 0x697
  00AD4E  6a00             push 0
  00AD50  9a1a004208       lcall 0x842, 0x1a
  00AD55  83c404           add sp, 4
  00AD58  0bc0             or ax, ax
  00AD5A  7403             je 0xad5f
  00AD5C  e93403           jmp 0xb093
  00AD5F  50               push ax
  00AD60  6a05             push 5
  00AD62  9a06014208       lcall 0x842, 0x106
  00AD67  1e               push ds
  00AD68  50               push ax
  00AD69  ff367a00         push word ptr [0x7a]
  00AD6D  ff367800         push word ptr [0x78]
  00AD71  9a4206d706       lcall 0x6d7, 0x642
  00AD76  83c40c           add sp, 0xc
  00AD79  6a50             push 0x50
  00AD7B  9a06014208       lcall 0x842, 0x106
  00AD80  1e               push ds
  00AD81  50               push ax
  00AD82  6a05             push 5
  00AD84  ff367a00         push word ptr [0x7a]
  00AD88  ff367800         push word ptr [0x78]
  00AD8C  9ade07d706       lcall 0x6d7, 0x7de
  00AD91  83c40c           add sp, 0xc
  00AD94  6a51             push 0x51
  00AD96  9a06014208       lcall 0x842, 0x106
  00AD9B  1e               push ds
  00AD9C  50               push ax
  00AD9D  6a05             push 5
  00AD9F  ff367a00         push word ptr [0x7a]
  00ADA3  ff367800         push word ptr [0x78]
  00ADA7  9ade07d706       lcall 0x6d7, 0x7de
  00ADAC  83c40c           add sp, 0xc
  00ADAF  6a52             push 0x52
  00ADB1  9a06014208       lcall 0x842, 0x106
  00ADB6  1e               push ds
  00ADB7  50               push ax
  00ADB8  6a05             push 5
  00ADBA  ff367a00         push word ptr [0x7a]
  00ADBE  ff367800         push word ptr [0x78]
  00ADC2  9ade07d706       lcall 0x6d7, 0x7de
  00ADC7  83c40c           add sp, 0xc
  00ADCA  689d06           push 0x69d
  00ADCD  6a00             push 0
  00ADCF  9a1a004208       lcall 0x842, 0x1a
  00ADD4  83c404           add sp, 4
  00ADD7  0bc0             or ax, ax
  00ADD9  7403             je 0xadde
  00ADDB  e9b502           jmp 0xb093
  00ADDE  50               push ax
  00ADDF  6a06             push 6
  00ADE1  9a06014208       lcall 0x842, 0x106
  00ADE6  1e               push ds
  00ADE7  50               push ax
  00ADE8  ff367a00         push word ptr [0x7a]
  00ADEC  ff367800         push word ptr [0x78]
  00ADF0  9a4206d706       lcall 0x6d7, 0x642
  00ADF5  83c40c           add sp, 0xc
  00ADF8  6a62             push 0x62
  00ADFA  9a06014208       lcall 0x842, 0x106
  00ADFF  1e               push ds
  00AE00  50               push ax
  00AE01  6a06             push 6
  00AE03  ff367a00         push word ptr [0x7a]
  00AE07  ff367800         push word ptr [0x78]
  00AE0B  9ade07d706       lcall 0x6d7, 0x7de
  00AE10  83c40c           add sp, 0xc
  00AE13  6a63             push 0x63
  00AE15  9a06014208       lcall 0x842, 0x106
  00AE1A  1e               push ds
  00AE1B  50               push ax
  00AE1C  6a06             push 6
  00AE1E  ff367a00         push word ptr [0x7a]
  00AE22  ff367800         push word ptr [0x78]
  00AE26  9ade07d706       lcall 0x6d7, 0x7de
  00AE2B  83c40c           add sp, 0xc
  00AE2E  6a00             push 0
  00AE30  1e               push ds
  00AE31  68a106           push 0x6a1
  00AE34  6a06             push 6
  00AE36  ff367a00         push word ptr [0x7a]
  00AE3A  ff367800         push word ptr [0x78]
  00AE3E  9ade07d706       lcall 0x6d7, 0x7de
  00AE43  83c40c           add sp, 0xc
  00AE46  6a65             push 0x65
  00AE48  9a06014208       lcall 0x842, 0x106
  00AE4D  1e               push ds
  00AE4E  50               push ax
  00AE4F  6a06             push 6
  00AE51  ff367a00         push word ptr [0x7a]
  00AE55  ff367800         push word ptr [0x78]
  00AE59  9ade07d706       lcall 0x6d7, 0x7de
  00AE5E  83c40c           add sp, 0xc
  00AE61  6a66             push 0x66
  00AE63  9a06014208       lcall 0x842, 0x106
  00AE68  1e               push ds
  00AE69  50               push ax
  00AE6A  6a06             push 6
  00AE6C  ff367a00         push word ptr [0x7a]
  00AE70  ff367800         push word ptr [0x78]
  00AE74  9a               .byte 0x9a
  00AE75  de               .byte 0xde

; ---- _load_terrain_series  file 0x00B09E..0x00B152  seg 0x8F9:0xb0e  (vicemisc.obj) ----
  00B09E  c8240000         enter 0x24, 0
  00B0A2  57               push di
  00B0A3  56               push si
  00B0A4  2bc0             sub ax, ax
  00B0A6  8946ee           mov word ptr [bp - 0x12], ax
  00B0A9  8946ec           mov word ptr [bp - 0x14], ax
  00B0AC  b80c00           mov ax, 0xc
  00B0AF  8946fa           mov word ptr [bp - 6], ax
  00B0B2  50               push ax
  00B0B3  9a06000b03       lcall 0x30b, 6
  00B0B8  83c402           add sp, 2
  00B0BB  8bf0             mov si, ax
  00B0BD  8956e6           mov word ptr [bp - 0x1a], dx
  00B0C0  0bd0             or dx, ax
  00B0C2  750a             jne 0xb0ce
  00B0C4  c70662002103     mov word ptr [0x62], 0x321
  00B0CA  eb7c             jmp 0xb148
  00B0CC  90               nop
  00B0CD  90               nop
  00B0CE  8b5e06           mov bx, word ptr [bp + 6]
  00B0D1  b80040           mov ax, 0x4000
  00B0D4  9a0800db0d       lcall 0xddb, 8
  00B0D9  8946e8           mov word ptr [bp - 0x18], ax
  00B0DC  8956ea           mov word ptr [bp - 0x16], dx
  00B0DF  0bd0             or dx, ax
  00B0E1  7509             jne 0xb0ec
  00B0E3  c70662002203     mov word ptr [0x62], 0x322
  00B0E9  eb5d             jmp 0xb148
  00B0EB  90               nop
  00B0EC  8976e4           mov word ptr [bp - 0x1c], si
  00B0EF  b81000           mov ax, 0x10
  00B0F2  8946de           mov word ptr [bp - 0x22], ax
  00B0F5  8946dc           mov word ptr [bp - 0x24], ax
  00B0F8  2bf6             sub si, si
  00B0FA  8b4ee4           mov cx, word ptr [bp - 0x1c]
  00B0FD  8b46e6           mov ax, word ptr [bp - 0x1a]
  00B100  8bf9             mov di, cx
  00B102  8946f6           mov word ptr [bp - 0xa], ax
  00B105  8b46f6           mov ax, word ptr [bp - 0xa]
  00B108  897ee0           mov word ptr [bp - 0x20], di
  00B10B  8946e2           mov word ptr [bp - 0x1e], ax
  00B10E  ff76ea           push word ptr [bp - 0x16]
  00B111  ff76e8           push word ptr [bp - 0x18]
  00B114  6a00             push 0
  00B116  8d4401           lea ax, [si + 1]
  00B119  8d5edc           lea bx, [bp - 0x24]
  00B11C  2bd2             sub dx, dx
  00B11E  9a00008f0d       lcall 0xd8f, 0
  00B123  81c70001         add di, 0x100
  00B127  8d4401           lea ax, [si + 1]
  00B12A  8bf0             mov si, ax
  00B12C  83fe0c           cmp si, 0xc
  00B12F  7cd4             jl 0xb105
  00B131  ff76ea           push word ptr [bp - 0x16]
  00B134  ff76e8           push word ptr [bp - 0x18]
  00B137  9a1003c90c       lcall 0xcc9, 0x310
  00B13C  8b46e4           mov ax, word ptr [bp - 0x1c]
  00B13F  8b56e6           mov dx, word ptr [bp - 0x1a]
  00B142  8946ec           mov word ptr [bp - 0x14], ax
  00B145  8956ee           mov word ptr [bp - 0x12], dx
  00B148  8b46ec           mov ax, word ptr [bp - 0x14]
  00B14B  8b56ee           mov dx, word ptr [bp - 0x12]
  00B14E  5e               pop si
  00B14F  5f               pop di
  00B150  c9               leave
  00B151  cb               retf

; ---- _load_terrain_tiles  file 0x00B152..0x00B176  seg 0x8F9:0xbc2  (vicemisc.obj) ----
  00B152  56               push si
  00B153  be0100           mov si, 1
  00B156  68ac06           push 0x6ac
  00B159  0e               push cs
  00B15A  e841ff           call 0xb09e
  00B15D  83c402           add sp, 2
  00B160  a3b804           mov word ptr [0x4b8], ax
  00B163  8916ba04         mov word ptr [0x4ba], dx
  00B167  8bc2             mov ax, dx
  00B169  0b06b804         or ax, word ptr [0x4b8]
  00B16D  7402             je 0xb171
  00B16F  2bf6             sub si, si
  00B171  8bc6             mov ax, si
  00B173  5e               pop si
  00B174  cb               retf
  00B175  90               nop
