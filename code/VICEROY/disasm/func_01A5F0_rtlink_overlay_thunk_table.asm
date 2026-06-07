; ============================================================================
; func_01A5F0_rtlink_overlay_thunk_table
; Region   : load_image
; Bytes    : file 0x01A5F0..0x01D5E6  (12278 bytes)
; Purpose  : RTLink Plus overlay-thunk table — 1,020 thunks bridging load-image code to overlay-resident functions. Each thunk is either a variable-size (10/12/14/16 bytes) `LCALL 110D:0DAB ; LJMP <ovl_seg>:<ovl_off> ; <2/4/6-byte trailer>` (type-A, 658 instances) or a fixed 10-byte `LCALL 110D:0D91 ; LJMP <ovl_seg>:<ovl_off>` (type-B, 362 instances). When the load image far-calls a thunk, the LCALL invokes the RTLink runtime at file 0x14261/0x1427B which loads the requested overlay segment and patches the trailing LJMP's segment word to the runtime address. Catalogued in `code/VICEROY/overlay_thunks.md`. Distinct overlay segments referenced: 82. Top segments by entry count: 0x0000 (661 thunks — main code), 0x05EB (82), 0x0427 (47), 0x004B (25), 0x037F (24). The first thunk (offset 0x01A5F0, type-A, target 0x0000:0x025A) is the entry to _main, called from cstart at 0xF7D8.
; Args     : Each thunk is invoked as a far call from the load image. The thunk's LCALL passes control to the RTLink runtime; on return the LJMP transfers control to the overlay-resident function at the now-patched segment:offset.
; Returns  : Each thunk's RETF returns to the load-image caller after the overlay function completes. Trailer bytes on type-A thunks (only two patterns observed: 1900E700 on the first thunk and 1F004F00 on the rest) carry RTLink metadata whose exact semantics are undecoded.
; Callers  : Every load-image function that calls into overlay code lands here. The first thunk is called from cstart (file 0xF7D8). Other thunks are called from the load-image initialisation chains and runtime helpers.
; Callees  : RTLink loaders at 0x110D:0DAB / 0x110D:0D91; then transfers to 21 distinct overlay segments (full list in overlay_thunks.md).
; Verified : Boundary verified by walking from 0x01A5F0 until the first non-LCALL byte. Total 1,020 thunks, 12,278 bytes (12 KB). Catalogue in code/VICEROY/overlay_thunks.md.
; Source   : Identified by tracing cstart's far-call to _main via 0x181F:0 (file 0x1A5F0).
; ============================================================================

01A5F0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01A5F5  EA 5A 02 00 00        LJMP   0:0x25a                      ; UNKNOWN
01A5FA  19 00                 SBB    word ptr [bx + si], ax ; ARITH
01A5FC  E7 00                 OUT    0, ax ; IO
01A5FE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A603  EA 00 00 00 00        LJMP   0:0                          ; UNKNOWN
01A608  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A60D  EA 2C 00 00 00        LJMP   0:0x2c                       ; UNKNOWN
01A612  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A617  EA 62 00 00 00        LJMP   0:0x62                       ; UNKNOWN
01A61C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01A621  EA 18 01 00 00        LJMP   0:0x118                      ; UNKNOWN
01A626  1F                    POP    ds ; STACK_POP
01A627  00 4F 00              ADD    byte ptr [bx], cl ; ARITH
01A62A  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01A62F  EA 82 01 00 00        LJMP   0:0x182                      ; UNKNOWN
01A634  1F                    POP    ds ; STACK_POP
01A635  00 4F 00              ADD    byte ptr [bx], cl ; ARITH
01A638  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01A63D  EA 0E 00 00 00        LJMP   0:0xe                        ; UNKNOWN
01A642  1F                    POP    ds ; STACK_POP
01A643  00 4F 00              ADD    byte ptr [bx], cl ; ARITH
01A646  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A64B  EA B4 00 09 00        LJMP   9:0xb4                       ; UNKNOWN
01A650  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A655  EA 02 04 09 00        LJMP   9:0x402                      ; UNKNOWN
01A65A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A65F  EA 7E 01 09 00        LJMP   9:0x17e                      ; UNKNOWN
01A664  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A669  EA A2 01 09 00        LJMP   9:0x1a2                      ; UNKNOWN
01A66E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A673  EA B8 01 09 00        LJMP   9:0x1b8                      ; UNKNOWN
01A678  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A67D  EA 22 02 09 00        LJMP   9:0x222                      ; UNKNOWN
01A682  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A687  EA 44 02 09 00        LJMP   9:0x244                      ; UNKNOWN
01A68C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A691  EA 70 02 09 00        LJMP   9:0x270                      ; UNKNOWN
01A696  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A69B  EA AE 02 09 00        LJMP   9:0x2ae                      ; UNKNOWN
01A6A0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A6A5  EA CC 02 09 00        LJMP   9:0x2cc                      ; UNKNOWN
01A6AA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A6AF  EA 0A 00 9E 0B        LJMP   0xb9e:0xa                    ; UNKNOWN
01A6B4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A6B9  EA 00 00 F5 0B        LJMP   0xbf5:0                      ; UNKNOWN
01A6BE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A6C3  EA 02 00 CA 0B        LJMP   0xbca:2                      ; UNKNOWN
01A6C8  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A6CD  EA E8 01 4B 00        LJMP   0x4b:0x1e8                   ; UNKNOWN
01A6D2  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A6D7  EA 3A 00 70 0B        LJMP   0xb70:0x3a                   ; UNKNOWN
01A6DC  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A6E1  EA DA 00 62 02        LJMP   0x262:0xda                   ; UNKNOWN
01A6E6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A6EB  EA 02 00 E7 0A        LJMP   0xae7:2                      ; UNKNOWN
01A6F0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A6F5  EA 18 03 4B 00        LJMP   0x4b:0x318                   ; UNKNOWN
01A6FA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A6FF  EA 62 00 4B 00        LJMP   0x4b:0x62                    ; UNKNOWN
01A704  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A709  EA 16 02 4B 00        LJMP   0x4b:0x216                   ; UNKNOWN
01A70E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A713  EA 72 00 4B 00        LJMP   0x4b:0x72                    ; UNKNOWN
01A718  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A71D  EA 82 00 4B 00        LJMP   0x4b:0x82                    ; UNKNOWN
01A722  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A727  EA 4E 02 4B 00        LJMP   0x4b:0x24e                   ; UNKNOWN
01A72C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A731  EA 88 02 4B 00        LJMP   0x4b:0x288                   ; UNKNOWN
01A736  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A73B  EA B2 00 4B 00        LJMP   0x4b:0xb2                    ; UNKNOWN
01A740  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A745  EA C2 02 4B 00        LJMP   0x4b:0x2c2                   ; UNKNOWN
01A74A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A74F  EA C2 00 4B 00        LJMP   0x4b:0xc2                    ; UNKNOWN
01A754  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A759  EA D2 00 4B 00        LJMP   0x4b:0xd2                    ; UNKNOWN
01A75E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A763  EA E2 00 4B 00        LJMP   0x4b:0xe2                    ; UNKNOWN
01A768  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A76D  EA 00 00 4B 00        LJMP   0x4b:0                       ; UNKNOWN
01A772  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A777  EA 2E 01 4B 00        LJMP   0x4b:0x12e                   ; UNKNOWN
01A77C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A781  EA 9A 03 4B 00        LJMP   0x4b:0x39a                   ; UNKNOWN
01A786  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A78B  EA 10 00 4B 00        LJMP   0x4b:0x10                    ; UNKNOWN
01A790  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A795  EA 56 01 4B 00        LJMP   0x4b:0x156                   ; UNKNOWN
01A79A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A79F  EA D2 03 4B 00        LJMP   0x4b:0x3d2                   ; UNKNOWN
01A7A4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A7A9  EA 32 00 4B 00        LJMP   0x4b:0x32                    ; UNKNOWN
01A7AE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A7B3  EA 42 00 4B 00        LJMP   0x4b:0x42                    ; UNKNOWN
01A7B8  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A7BD  EA 30 04 4B 00        LJMP   0x4b:0x430                   ; UNKNOWN
01A7C2  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A7C7  EA BE 01 4B 00        LJMP   0x4b:0x1be                   ; UNKNOWN
01A7CC  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A7D1  EA 52 00 4B 00        LJMP   0x4b:0x52                    ; UNKNOWN
01A7D6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A7DB  EA 78 04 4B 00        LJMP   0x4b:0x478                   ; UNKNOWN
01A7E0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A7E5  EA 0A 00 28 0C        LJMP   0xc28:0xa                    ; UNKNOWN
01A7EA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A7EF  EA 0C 00 11 0C        LJMP   0xc11:0xc                    ; UNKNOWN
01A7F4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A7F9  EA 06 00 2A 0C        LJMP   0xc2a:6                      ; UNKNOWN
01A7FE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A803  EA DA 02 97 00        LJMP   0x97:0x2da                   ; UNKNOWN
01A808  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A80D  EA 7A 06 97 00        LJMP   0x97:0x67a                   ; UNKNOWN
01A812  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A817  EA 82 06 97 00        LJMP   0x97:0x682                   ; UNKNOWN
01A81C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A821  EA 94 03 97 00        LJMP   0x97:0x394                   ; UNKNOWN
01A826  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A82B  EA 74 01 97 00        LJMP   0x97:0x174                   ; UNKNOWN
01A830  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A835  EA 04 00 97 00        LJMP   0x97:4                       ; UNKNOWN
01A83A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A83F  EA 5C 01 2B 01        LJMP   0x12b:0x15c                  ; UNKNOWN
01A844  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A849  EA 0A 00 36 0C        LJMP   0xc36:0xa                    ; UNKNOWN
01A84E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A853  EA 50 00 01 01        LJMP   0x101:0x50                   ; UNKNOWN
01A858  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A85D  EA B4 00 01 01        LJMP   0x101:0xb4                   ; UNKNOWN
01A862  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A867  EA 26 01 01 01        LJMP   0x101:0x126                  ; UNKNOWN
01A86C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A871  EA 0E 00 01 01        LJMP   0x101:0xe                    ; UNKNOWN
01A876  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A87B  EA DC 01 01 01        LJMP   0x101:0x1dc                  ; UNKNOWN
01A880  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A885  EA 08 00 4E 0A        LJMP   0xa4e:8                      ; UNKNOWN
01A88A  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01A88F  EA A0 01 00 00        LJMP   0:0x1a0                      ; UNKNOWN
01A894  1F                    POP    ds ; STACK_POP
01A895  00 21                 ADD    byte ptr [bx + di], ah ; ARITH
01A897  00 9A 91 0D           ADD    byte ptr [bp + si + 0xd91], bl ; ARITH
01A89B  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01A89E  64 0C 2B              OR     al, 0x2b ; LOGIC
01A8A1  01 9A 91 0D           ADD    word ptr [bp + si + 0xd91], bx ; ARITH
01A8A5  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01A8A8  90                    NOP ; NOP
01A8A9  07                    POP    es ; STACK_POP
01A8AA  2B 01                 SUB    ax, word ptr [bx + di] ; ARITH
01A8AC  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A8B1  EA BA 01 2B 01        LJMP   0x12b:0x1ba                  ; UNKNOWN
01A8B6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A8BB  EA 02 00 2B 01        LJMP   0x12b:2                      ; UNKNOWN
01A8C0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A8C5  EA B6 0E 2B 01        LJMP   0x12b:0xeb6                  ; UNKNOWN
01A8CA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A8CF  EA 60 00 2B 01        LJMP   0x12b:0x60                   ; UNKNOWN
01A8D4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A8D9  EA 4A 00 27 04        LJMP   0x427:0x4a                   ; UNKNOWN
01A8DE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A8E3  EA 02 00 27 04        LJMP   0x427:2                      ; UNKNOWN
01A8E8  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A8ED  EA 04 00 56 0C        LJMP   0xc56:4                      ; UNKNOWN
01A8F2  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A8F7  EA 0A 00 7F 03        LJMP   0x37f:0xa                    ; UNKNOWN
01A8FC  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A901  EA E0 00 DC 05        LJMP   0x5dc:0xe0                   ; UNKNOWN
01A906  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01A90B  EA F8 03 00 00        LJMP   0:0x3f8                      ; UNKNOWN
01A910  0B 00                 OR     ax, word ptr [bx + si] ; LOGIC
01A912  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A917  EA 5E 03 EB 05        LJMP   0x5eb:0x35e                  ; UNKNOWN
01A91C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01A921  EA C8 00 00 00        LJMP   0:0xc8                       ; UNKNOWN
01A926  15 00 5B              ADC    ax, 0x5b00 ; ARITH
01A929  00 9A 91 0D           ADD    byte ptr [bp + si + 0xd91], bl ; ARITH
01A92D  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01A930  06                    PUSH   es ; STACK_PUSH
01A931  00 AA 0B 9A           ADD    byte ptr [bp + si - 0x65f5], ch ; ARITH
01A935  AB                    STOSW  word ptr es:[di], ax ; STR
01A936  0D 0D 11              OR     ax, 0x110d ; LOGIC
01A939  EA BC 04 00 00        LJMP   0:0x4bc                      ; UNKNOWN
01A93E  15 00 83              ADC    ax, 0x8300 ; ARITH
01A941  00 9A 91 0D           ADD    byte ptr [bp + si + 0xd91], bl ; ARITH
01A945  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01A948  FC                    CLD ; FLAG
01A949  02 84 09 9A           ADD    al, byte ptr [si - 0x65f7] ; ARITH
01A94D  91                    XCHG   cx, ax ; MOV
01A94E  0D 0D 11              OR     ax, 0x110d ; LOGIC
01A951  EA 0C 00 4C 02        LJMP   0x24c:0xc                    ; UNKNOWN
01A956  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A95B  EA 2A 00 4C 02        LJMP   0x24c:0x2a                   ; UNKNOWN
01A960  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A965  EA 40 00 4C 02        LJMP   0x24c:0x40                   ; UNKNOWN
01A96A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A96F  EA 7C 00 4C 02        LJMP   0x24c:0x7c                   ; UNKNOWN
01A974  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A979  EA 3C 01 4C 02        LJMP   0x24c:0x13c                  ; UNKNOWN
01A97E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A983  EA 28 01 62 02        LJMP   0x262:0x128                  ; UNKNOWN
01A988  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A98D  EA 42 01 62 02        LJMP   0x262:0x142                  ; UNKNOWN
01A992  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A997  EA 02 00 62 02        LJMP   0x262:2                      ; UNKNOWN
01A99C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A9A1  EA FE 02 62 02        LJMP   0x262:0x2fe                  ; UNKNOWN
01A9A6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A9AB  EA 12 00 62 02        LJMP   0x262:0x12                   ; UNKNOWN
01A9B0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A9B5  EA 60 00 62 02        LJMP   0x262:0x60                   ; UNKNOWN
01A9BA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A9BF  EA F6 00 62 02        LJMP   0x262:0xf6                   ; UNKNOWN
01A9C4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01A9C9  EA 4E 01 00 00        LJMP   0:0x14e                      ; UNKNOWN
01A9CE  1D 00 9A              SBB    ax, 0x9a00 ; ARITH
01A9D1  91                    XCHG   cx, ax ; MOV
01A9D2  0D 0D 11              OR     ax, 0x110d ; LOGIC
01A9D5  EA 16 00 E7 0A        LJMP   0xae7:0x16                   ; UNKNOWN
01A9DA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A9DF  EA 00 00 D6 02        LJMP   0x2d6:0                      ; UNKNOWN
01A9E4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01A9E9  EA 04 00 DE 0A        LJMP   0xade:4                      ; UNKNOWN
01A9EE  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01A9F3  EA 44 37 00 00        LJMP   0:0x3744                     ; UNKNOWN
01A9F8  17                    POP    ss ; STACK_POP
01A9F9  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01A9FD  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AA00  F6 37                 DIV    byte ptr [bx] ; ARITH
01AA02  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01AA04  17                    POP    ss ; STACK_POP
01AA05  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01AA09  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AA0C  D0 03                 ROL    byte ptr [bp + di], 1 ; LOGIC
01AA0E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01AA10  17                    POP    ss ; STACK_POP
01AA11  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01AA15  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AA18  08 02                 OR     byte ptr [bp + si], al ; LOGIC
01AA1A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01AA1C  18 00                 SBB    byte ptr [bx + si], al ; ARITH
01AA1E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AA23  EA 44 01 B3 05        LJMP   0x5b3:0x144                  ; UNKNOWN
01AA28  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01AA2D  EA EC 03 00 00        LJMP   0:0x3ec                      ; UNKNOWN
01AA32  17                    POP    ss ; STACK_POP
01AA33  00 9A 91 0D           ADD    byte ptr [bp + si + 0xd91], bl ; ARITH
01AA37  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AA3A  06                    PUSH   es ; STACK_PUSH
01AA3B  00 8F 0B 9A           ADD    byte ptr [bx - 0x65f5], cl ; ARITH
01AA3F  AB                    STOSW  word ptr es:[di], ax ; STR
01AA40  0D 0D 11              OR     ax, 0x110d ; LOGIC
01AA43  EA 0E 00 00 00        LJMP   0:0xe                        ; UNKNOWN
01AA48  1B 00                 SBB    ax, word ptr [bx + si] ; ARITH
01AA4A  6C                    INSB   byte ptr es:[di], dx ; IO
01AA4B  00 9A 91 0D           ADD    byte ptr [bp + si + 0xd91], bl ; ARITH
01AA4F  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AA52  1A 01                 SBB    al, byte ptr [bx + di] ; ARITH
01AA54  CB                    RETF ; RETURN
01AA55  0A 9A 91 0D           OR     bl, byte ptr [bp + si + 0xd91] ; LOGIC
01AA59  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AA5C  56                    PUSH   si ; STACK_PUSH
01AA5D  00 CB                 ADD    bl, cl ; ARITH
01AA5F  0A 9A 91 0D           OR     bl, byte ptr [bp + si + 0xd91] ; LOGIC
01AA63  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AA66  F6 00 9F              TEST   byte ptr [bx + si], 0x9f ; LOGIC
01AA69  02 9A 91 0D           ADD    bl, byte ptr [bp + si + 0xd91] ; ARITH
01AA6D  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AA70  30 00                 XOR    byte ptr [bx + si], al ; LOGIC
01AA72  CB                    RETF ; RETURN
01AA73  0A 9A 91 0D           OR     bl, byte ptr [bp + si + 0xd91] ; LOGIC
01AA77  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AA7A  04 00                 ADD    al, 0 ; ARITH
01AA7C  8D 0B                 LEA    cx, [bp + di] ; ADDR
01AA7E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AA83  EA CC 02 9F 02        LJMP   0x29f:0x2cc                  ; UNKNOWN
01AA88  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AA8D  EA 00 03 9F 02        LJMP   0x29f:0x300                  ; UNKNOWN
01AA92  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AA97  EA 0C 03 9F 02        LJMP   0x29f:0x30c                  ; UNKNOWN
01AA9C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AAA1  EA 18 03 9F 02        LJMP   0x29f:0x318                  ; UNKNOWN
01AAA6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AAAB  EA 4C 03 9F 02        LJMP   0x29f:0x34c                  ; UNKNOWN
01AAB0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AAB5  EA 0E 00 D8 02        LJMP   0x2d8:0xe                    ; UNKNOWN
01AABA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AABF  EA 2C 00 EF 09        LJMP   0x9ef:0x2c                   ; UNKNOWN
01AAC4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AAC9  EA 32 00 EF 09        LJMP   0x9ef:0x32                   ; UNKNOWN
01AACE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AAD3  EA 0A 00 59 10        LJMP   0x1059:0xa                   ; UNKNOWN
01AAD8  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AADD  EA 0D 00 58 0A        LJMP   0xa58:0xd                    ; UNKNOWN
01AAE2  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AAE7  EA 54 00 58 0A        LJMP   0xa58:0x54                   ; UNKNOWN
01AAEC  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AAF1  EA 02 00 DD 02        LJMP   0x2dd:2                      ; UNKNOWN
01AAF6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AAFB  EA 64 00 DD 02        LJMP   0x2dd:0x64                   ; UNKNOWN
01AB00  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AB05  EA 8C 00 E9 02        LJMP   0x2e9:0x8c                   ; UNKNOWN
01AB0A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AB0F  EA 48 00 FD 02        LJMP   0x2fd:0x48                   ; UNKNOWN
01AB14  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AB19  EA 6C 00 FD 02        LJMP   0x2fd:0x6c                   ; UNKNOWN
01AB1E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01AB23  EA 62 00 00 00        LJMP   0:0x62                       ; UNKNOWN
01AB28  16                    PUSH   ss ; STACK_PUSH
01AB29  00 7E 02              ADD    byte ptr [bp + 2], bh ; ARITH
01AB2C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AB31  EA 9C 01 0D 03        LJMP   0x30d:0x19c                  ; UNKNOWN
01AB36  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AB3B  EA 90 02 0D 03        LJMP   0x30d:0x290                  ; UNKNOWN
01AB40  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01AB45  EA F8 00 00 00        LJMP   0:0xf8                       ; UNKNOWN
01AB4A  0F 00 00              SLDT   word ptr [bx + si]           ; UNKNOWN
01AB4D  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01AB51  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AB54  24 04                 AND    al, 4 ; LOGIC
01AB56  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01AB58  09 00                 OR     word ptr [bx + si], ax ; LOGIC
01AB5A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AB5F  EA F6 04 84 09        LJMP   0x984:0x4f6                  ; UNKNOWN
01AB64  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01AB69  EA A8 14 00 00        LJMP   0:0x14a8                     ; UNKNOWN
01AB6E  05 00 B1              ADD    ax, 0xb100 ; ARITH
01AB71  02 9A AB 0D           ADD    bl, byte ptr [bp + si + 0xdab] ; ARITH
01AB75  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AB78  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01AB7A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01AB7C  04 00                 ADD    al, 0 ; ARITH
01AB7E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01AB80  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AB85  EA AA 00 84 09        LJMP   0x984:0xaa                   ; UNKNOWN
01AB8A  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01AB8F  EA D8 00 00 00        LJMP   0:0xd8                       ; UNKNOWN
01AB94  15 00 00              ADC    ax, 0 ; ARITH
01AB97  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01AB9B  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AB9E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01ABA0  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01ABA2  1A 00                 SBB    al, byte ptr [bx + si] ; ARITH
01ABA4  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01ABA6  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01ABAB  EA 34 00 00 00        LJMP   0:0x34                       ; UNKNOWN
01ABB0  1A 00                 SBB    al, byte ptr [bx + si] ; ARITH
01ABB2  BE 00 9A              MOV    si, 0x9a00 ; CONST_LOAD
01ABB5  91                    XCHG   cx, ax ; MOV
01ABB6  0D 0D 11              OR     ax, 0x110d ; LOGIC
01ABB9  EA 8C 00 58 0A        LJMP   0xa58:0x8c                   ; UNKNOWN
01ABBE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ABC3  EA D1 01 29 0A        LJMP   0xa29:0x1d1                  ; UNKNOWN
01ABC8  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ABCD  EA 5F 00 59 10        LJMP   0x1059:0x5f                  ; UNKNOWN
01ABD2  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ABD7  EA 1F 01 47 10        LJMP   0x1047:0x11f                 ; UNKNOWN
01ABDC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01ABE1  EA 28 2D 00 00        LJMP   0:0x2d28                     ; UNKNOWN
01ABE6  1A 00                 SBB    al, byte ptr [bx + si] ; ARITH
01ABE8  1E                    PUSH   ds ; STACK_PUSH
01ABE9  01 9A AB 0D           ADD    word ptr [bp + si + 0xdab], bx ; ARITH
01ABED  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01ABF0  B6 55                 MOV    dh, 0x55 ; CONST_LOAD
01ABF2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01ABF4  04 00                 ADD    al, 0 ; ARITH
01ABF6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01ABF8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01ABFD  EA D4 6C 00 00        LJMP   0:0x6cd4                     ; UNKNOWN
01AC02  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01AC04  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AC09  EA 42 01 EB 05        LJMP   0x5eb:0x142                  ; UNKNOWN
01AC0E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01AC13  EA 42 04 00 00        LJMP   0:0x442                      ; UNKNOWN
01AC18  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
01AC1A  F9                    STC ; FLAG
01AC1B  01 9A AB 0D           ADD    word ptr [bp + si + 0xdab], bx ; ARITH
01AC1F  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AC22  68 3B 00              PUSH   0x3b ; PUSH_CONST
01AC25  00 01                 ADD    byte ptr [bx + di], al ; ARITH
01AC27  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01AC2B  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AC2E  8E 6D 00              MOV    gs, word ptr [di] ; MOV
01AC31  00 0D                 ADD    byte ptr [di], cl ; ARITH
01AC33  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01AC37  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AC3A  F2 00 00              ADD    byte ptr [bx + si], al ; ARITH
01AC3D  00 03                 ADD    byte ptr [bp + di], al ; ARITH
01AC3F  00 F9                 ADD    cl, bh ; ARITH
01AC41  01 9A AB 0D           ADD    word ptr [bp + si + 0xdab], bx ; ARITH
01AC45  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AC48  A2 37 00              MOV    byte ptr [0x37], al ; GLOBAL_LOAD
01AC4B  00 17                 ADD    byte ptr [bx], dl ; ARITH
01AC4D  00 9A 91 0D           ADD    byte ptr [bp + si + 0xd91], bl ; ARITH
01AC51  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AC54  4E                    DEC    si ; ARITH
01AC55  02 B3 05 9A           ADD    dh, byte ptr [bp + di - 0x65fb] ; ARITH
01AC59  AB                    STOSW  word ptr es:[di], ax ; STR
01AC5A  0D 0D 11              OR     ax, 0x110d ; LOGIC
01AC5D  EA 44 22 00 00        LJMP   0:0x2244                     ; UNKNOWN
01AC62  06                    PUSH   es ; STACK_PUSH
01AC63  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01AC67  AB                    STOSW  word ptr es:[di], ax ; STR
01AC68  0D 0D 11              OR     ax, 0x110d ; LOGIC
01AC6B  EA 3A 1B 00 00        LJMP   0:0x1b3a                     ; UNKNOWN
01AC70  0C 00                 OR     al, 0 ; LOGIC
01AC72  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AC77  EA 14 03 7F 03        LJMP   0x37f:0x314                  ; UNKNOWN
01AC7C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AC81  EA 5E 01 7F 03        LJMP   0x37f:0x15e                  ; UNKNOWN
01AC86  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AC8B  EA 58 03 7F 03        LJMP   0x37f:0x358                  ; UNKNOWN
01AC90  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AC95  EA 94 01 7F 03        LJMP   0x37f:0x194                  ; UNKNOWN
01AC9A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AC9F  EA 14 06 7F 03        LJMP   0x37f:0x614                  ; UNKNOWN
01ACA4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ACA9  EA CA 01 7F 03        LJMP   0x37f:0x1ca                  ; UNKNOWN
01ACAE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ACB3  EA E4 03 7F 03        LJMP   0x37f:0x3e4                  ; UNKNOWN
01ACB8  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ACBD  EA 3C 00 7F 03        LJMP   0x37f:0x3c                   ; UNKNOWN
01ACC2  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ACC7  EA 28 04 7F 03        LJMP   0x37f:0x428                  ; UNKNOWN
01ACCC  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ACD1  EA 00 02 7F 03        LJMP   0x37f:0x200                  ; UNKNOWN
01ACD6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ACDB  EA 4A 04 7F 03        LJMP   0x37f:0x44a                  ; UNKNOWN
01ACE0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ACE5  EA 92 03 7F 03        LJMP   0x37f:0x392                  ; UNKNOWN
01ACEA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ACEF  EA C0 00 7F 03        LJMP   0x37f:0xc0                   ; UNKNOWN
01ACF4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ACF9  EA 28 02 7F 03        LJMP   0x37f:0x228                  ; UNKNOWN
01ACFE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AD03  EA F6 00 7F 03        LJMP   0x37f:0xf6                   ; UNKNOWN
01AD08  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AD0D  EA B0 04 7F 03        LJMP   0x37f:0x4b0                  ; UNKNOWN
01AD12  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AD17  EA A0 02 7F 03        LJMP   0x37f:0x2a0                  ; UNKNOWN
01AD1C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AD21  EA 0E 01 7F 03        LJMP   0x37f:0x10e                  ; UNKNOWN
01AD26  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AD2B  EA E0 02 7F 03        LJMP   0x37f:0x2e0                  ; UNKNOWN
01AD30  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AD35  EA 2A 01 7F 03        LJMP   0x37f:0x12a                  ; UNKNOWN
01AD3A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AD3F  EA F8 02 7F 03        LJMP   0x37f:0x2f8                  ; UNKNOWN
01AD44  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AD49  EA 42 01 7F 03        LJMP   0x37f:0x142                  ; UNKNOWN
01AD4E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AD53  EA 98 05 7F 03        LJMP   0x37f:0x598                  ; UNKNOWN
01AD58  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AD5D  EA 74 00 E4 03        LJMP   0x3e4:0x74                   ; UNKNOWN
01AD62  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01AD67  EA CE 03 00 00        LJMP   0:0x3ce                      ; UNKNOWN
01AD6C  1D 00 9A              SBB    ax, 0x9a00 ; ARITH
01AD6F  AB                    STOSW  word ptr es:[di], ax ; STR
01AD70  0D 0D 11              OR     ax, 0x110d ; LOGIC
01AD73  EA E2 00 00 00        LJMP   0:0xe2                       ; UNKNOWN
01AD78  1E                    PUSH   ds ; STACK_PUSH
01AD79  00 19                 ADD    byte ptr [bx + di], bl ; ARITH
01AD7B  00 9A 91 0D           ADD    byte ptr [bp + si + 0xd91], bl ; ARITH
01AD7F  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AD82  3A 00                 CMP    al, byte ptr [bx + si] ; CMP
01AD84  E4 03                 IN     al, 3 ; IO
01AD86  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AD8B  EA B4 02 F1 03        LJMP   0x3f1:0x2b4                  ; UNKNOWN
01AD90  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AD95  EA F8 02 F1 03        LJMP   0x3f1:0x2f8                  ; UNKNOWN
01AD9A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AD9F  EA A6 00 F1 03        LJMP   0x3f1:0xa6                   ; UNKNOWN
01ADA4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ADA9  EA 00 00 81 09        LJMP   0x981:0                      ; UNKNOWN
01ADAE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ADB3  EA 76 0A EB 05        LJMP   0x5eb:0xa76                  ; UNKNOWN
01ADB8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01ADBD  EA 4C 1B 00 00        LJMP   0:0x1b4c                     ; UNKNOWN
01ADC2  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
01ADC4  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01ADC6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ADCB  EA AC 09 27 04        LJMP   0x427:0x9ac                  ; UNKNOWN
01ADD0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ADD5  EA 5C 00 27 04        LJMP   0x427:0x5c                   ; UNKNOWN
01ADDA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ADDF  EA D6 04 27 04        LJMP   0x427:0x4d6                  ; UNKNOWN
01ADE4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ADE9  EA 10 14 27 04        LJMP   0x427:0x1410                 ; UNKNOWN
01ADEE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ADF3  EA 72 0C 27 04        LJMP   0x427:0xc72                  ; UNKNOWN
01ADF8  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01ADFD  EA 24 08 27 04        LJMP   0x427:0x824                  ; UNKNOWN
01AE02  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE07  EA 3A 02 27 04        LJMP   0x427:0x23a                  ; UNKNOWN
01AE0C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE11  EA 0E 0F 27 04        LJMP   0x427:0xf0e                  ; UNKNOWN
01AE16  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE1B  EA 9A 0C 27 04        LJMP   0x427:0xc9a                  ; UNKNOWN
01AE20  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE25  EA A0 14 27 04        LJMP   0x427:0x14a0                 ; UNKNOWN
01AE2A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE2F  EA 30 0F 27 04        LJMP   0x427:0xf30                  ; UNKNOWN
01AE34  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE39  EA CA 02 27 04        LJMP   0x427:0x2ca                  ; UNKNOWN
01AE3E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE43  EA E6 0C 27 04        LJMP   0x427:0xce6                  ; UNKNOWN
01AE48  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE4D  EA 64 0F 27 04        LJMP   0x427:0xf64                  ; UNKNOWN
01AE52  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE57  EA 74 0F 27 04        LJMP   0x427:0xf74                  ; UNKNOWN
01AE5C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE61  EA EA 08 27 04        LJMP   0x427:0x8ea                  ; UNKNOWN
01AE66  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE6B  EA 8E 0F 27 04        LJMP   0x427:0xf8e                  ; UNKNOWN
01AE70  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE75  EA 62 03 27 04        LJMP   0x427:0x362                  ; UNKNOWN
01AE7A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE7F  EA 84 12 27 04        LJMP   0x427:0x1284                 ; UNKNOWN
01AE84  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE89  EA 1E 0D 27 04        LJMP   0x427:0xd1e                  ; UNKNOWN
01AE8E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE93  EA 7E 03 27 04        LJMP   0x427:0x37e                  ; UNKNOWN
01AE98  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AE9D  EA F4 14 27 04        LJMP   0x427:0x14f4                 ; UNKNOWN
01AEA2  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AEA7  EA A0 0F 27 04        LJMP   0x427:0xfa0                  ; UNKNOWN
01AEAC  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AEB1  EA 38 0D 27 04        LJMP   0x427:0xd38                  ; UNKNOWN
01AEB6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AEBB  EA A0 03 27 04        LJMP   0x427:0x3a0                  ; UNKNOWN
01AEC0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AEC5  EA C0 0F 27 04        LJMP   0x427:0xfc0                  ; UNKNOWN
01AECA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AECF  EA 68 09 27 04        LJMP   0x427:0x968                  ; UNKNOWN
01AED4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AED9  EA 44 06 27 04        LJMP   0x427:0x644                  ; UNKNOWN
01AEDE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AEE3  EA 64 01 27 04        LJMP   0x427:0x164                  ; UNKNOWN
01AEE8  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AEED  EA C6 12 27 04        LJMP   0x427:0x12c6                 ; UNKNOWN
01AEF2  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AEF7  EA EC 0F 27 04        LJMP   0x427:0xfec                  ; UNKNOWN
01AEFC  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AF01  EA 5A 06 27 04        LJMP   0x427:0x65a                  ; UNKNOWN
01AF06  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AF0B  EA F6 12 27 04        LJMP   0x427:0x12f6                 ; UNKNOWN
01AF10  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AF15  EA BE 10 27 04        LJMP   0x427:0x10be                 ; UNKNOWN
01AF1A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AF1F  EA 80 01 27 04        LJMP   0x427:0x180                  ; UNKNOWN
01AF24  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AF29  EA 5E 15 27 04        LJMP   0x427:0x155e                 ; UNKNOWN
01AF2E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AF33  EA 92 09 27 04        LJMP   0x427:0x992                  ; UNKNOWN
01AF38  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AF3D  EA 0C 04 27 04        LJMP   0x427:0x40c                  ; UNKNOWN
01AF42  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AF47  EA CE 0B 27 04        LJMP   0x427:0xbce                  ; UNKNOWN
01AF4C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AF51  EA B4 06 27 04        LJMP   0x427:0x6b4                  ; UNKNOWN
01AF56  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AF5B  EA 30 13 27 04        LJMP   0x427:0x1330                 ; UNKNOWN
01AF60  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AF65  EA FE 0B 27 04        LJMP   0x427:0xbfe                  ; UNKNOWN
01AF6A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AF6F  EA B0 13 27 04        LJMP   0x427:0x13b0                 ; UNKNOWN
01AF74  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AF79  EA DC 09 27 04        LJMP   0x427:0x9dc                  ; UNKNOWN
01AF7E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AF83  EA 26 00 27 04        LJMP   0x427:0x26                   ; UNKNOWN
01AF88  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01AF8D  EA CA 36 00 00        LJMP   0:0x36ca                     ; UNKNOWN
01AF92  17                    POP    ss ; STACK_POP
01AF93  00 9A 91 0D           ADD    byte ptr [bp + si + 0xd91], bl ; ARITH
01AF97  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AF9A  E0 01                 LOOPNE 0x1af9d ; CJUMP
01AF9C  B3 05                 MOV    bl, 5 ; MOV
01AF9E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01AFA3  EA 2C 04 00 00        LJMP   0:0x42c                      ; UNKNOWN
01AFA8  17                    POP    ss ; STACK_POP
01AFA9  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01AFAD  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AFB0  04 00                 ADD    al, 0 ; ARITH
01AFB2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01AFB4  15 00 DF              ADC    ax, 0xdf00 ; ARITH
01AFB7  00 9A 91 0D           ADD    byte ptr [bp + si + 0xd91], bl ; ARITH
01AFBB  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01AFBE  4A                    DEC    dx ; ARITH
01AFBF  00 7E 05              ADD    byte ptr [bp + 5], bh ; ARITH
01AFC2  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AFC7  EA 08 00 7E 05        LJMP   0x57e:8                      ; UNKNOWN
01AFCC  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AFD1  EA 5E 01 7E 05        LJMP   0x57e:0x15e                  ; UNKNOWN
01AFD6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AFDB  EA 2C 00 EB 05        LJMP   0x5eb:0x2c                   ; UNKNOWN
01AFE0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01AFE5  EA 04 03 00 00        LJMP   0:0x304                      ; UNKNOWN
01AFEA  0B 00                 OR     ax, word ptr [bx + si] ; LOGIC
01AFEC  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AFF1  EA 8E 03 EB 05        LJMP   0x5eb:0x38e                  ; UNKNOWN
01AFF6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01AFFB  EA 66 00 B3 05        LJMP   0x5b3:0x66                   ; UNKNOWN
01B000  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B005  EA D0 00 B3 05        LJMP   0x5b3:0xd0                   ; UNKNOWN
01B00A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B00F  EA 98 01 B3 05        LJMP   0x5b3:0x198                  ; UNKNOWN
01B014  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B019  EA 28 02 B3 05        LJMP   0x5b3:0x228                  ; UNKNOWN
01B01E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B023  EA 74 02 B3 05        LJMP   0x5b3:0x274                  ; UNKNOWN
01B028  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B02D  EA 04 00 B3 05        LJMP   0x5b3:4                      ; UNKNOWN
01B032  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B037  EA 06 00 DC 05        LJMP   0x5dc:6                      ; UNKNOWN
01B03C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B041  EA 32 00 DC 05        LJMP   0x5dc:0x32                   ; UNKNOWN
01B046  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B04B  EA 6A 00 DC 05        LJMP   0x5dc:0x6a                   ; UNKNOWN
01B050  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B055  EA A2 00 DC 05        LJMP   0x5dc:0xa2                   ; UNKNOWN
01B05A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B05F  EA FA 17 EB 05        LJMP   0x5eb:0x17fa                 ; UNKNOWN
01B064  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B069  EA 1C 0F EB 05        LJMP   0x5eb:0xf1c                  ; UNKNOWN
01B06E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B073  EA BC 0C EB 05        LJMP   0x5eb:0xcbc                  ; UNKNOWN
01B078  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B07D  EA AA 14 EB 05        LJMP   0x5eb:0x14aa                 ; UNKNOWN
01B082  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B087  EA 44 05 EB 05        LJMP   0x5eb:0x544                  ; UNKNOWN
01B08C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B091  EA 04 0D EB 05        LJMP   0x5eb:0xd04                  ; UNKNOWN
01B096  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B09B  EA 9C 16 EB 05        LJMP   0x5eb:0x169c                 ; UNKNOWN
01B0A0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B0A5  EA 9E 03 EB 05        LJMP   0x5eb:0x39e                  ; UNKNOWN
01B0AA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B0AF  EA 56 05 EB 05        LJMP   0x5eb:0x556                  ; UNKNOWN
01B0B4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B0B9  EA AA 33 EB 05        LJMP   0x5eb:0x33aa                 ; UNKNOWN
01B0BE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B0C3  EA D6 14 EB 05        LJMP   0x5eb:0x14d6                 ; UNKNOWN
01B0C8  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B0CD  EA D0 35 EB 05        LJMP   0x5eb:0x35d0                 ; UNKNOWN
01B0D2  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B0D7  EA BA 38 EB 05        LJMP   0x5eb:0x38ba                 ; UNKNOWN
01B0DC  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B0E1  EA 7C 31 EB 05        LJMP   0x5eb:0x317c                 ; UNKNOWN
01B0E6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B0EB  EA 96 05 EB 05        LJMP   0x5eb:0x596                  ; UNKNOWN
01B0F0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B0F5  EA EC 0A EB 05        LJMP   0x5eb:0xaec                  ; UNKNOWN
01B0FA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B0FF  EA EA 0F EB 05        LJMP   0x5eb:0xfea                  ; UNKNOWN
01B104  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B109  EA D6 03 EB 05        LJMP   0x5eb:0x3d6                  ; UNKNOWN
01B10E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B113  EA B2 05 EB 05        LJMP   0x5eb:0x5b2                  ; UNKNOWN
01B118  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B11D  EA E6 08 EB 05        LJMP   0x5eb:0x8e6                  ; UNKNOWN
01B122  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B127  EA 8E 2F EB 05        LJMP   0x5eb:0x2f8e                 ; UNKNOWN
01B12C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B131  EA EC 18 EB 05        LJMP   0x5eb:0x18ec                 ; UNKNOWN
01B136  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B13B  EA 8E 0D EB 05        LJMP   0x5eb:0xd8e                  ; UNKNOWN
01B140  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B145  EA 0C 0B EB 05        LJMP   0x5eb:0xb0c                  ; UNKNOWN
01B14A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B14F  EA CC 05 EB 05        LJMP   0x5eb:0x5cc                  ; UNKNOWN
01B154  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B159  EA E8 38 EB 05        LJMP   0x5eb:0x38e8                 ; UNKNOWN
01B15E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B163  EA C8 28 EB 05        LJMP   0x5eb:0x28c8                 ; UNKNOWN
01B168  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B16D  EA 02 09 EB 05        LJMP   0x5eb:0x902                  ; UNKNOWN
01B172  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B177  EA 76 13 EB 05        LJMP   0x5eb:0x1376                 ; UNKNOWN
01B17C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B181  EA 50 36 EB 05        LJMP   0x5eb:0x3650                 ; UNKNOWN
01B186  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B18B  EA 08 32 EB 05        LJMP   0x5eb:0x3208                 ; UNKNOWN
01B190  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B195  EA 10 04 EB 05        LJMP   0x5eb:0x410                  ; UNKNOWN
01B19A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B19F  EA 68 15 EB 05        LJMP   0x5eb:0x1568                 ; UNKNOWN
01B1A4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B1A9  EA 54 34 EB 05        LJMP   0x5eb:0x3454                 ; UNKNOWN
01B1AE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B1B3  EA 30 10 EB 05        LJMP   0x5eb:0x1030                 ; UNKNOWN
01B1B8  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B1BD  EA 24 09 EB 05        LJMP   0x5eb:0x924                  ; UNKNOWN
01B1C2  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B1C7  EA 8E 26 EB 05        LJMP   0x5eb:0x268e                 ; UNKNOWN
01B1CC  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B1D1  EA 34 04 EB 05        LJMP   0x5eb:0x434                  ; UNKNOWN
01B1D6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B1DB  EA F2 2F EB 05        LJMP   0x5eb:0x2ff2                 ; UNKNOWN
01B1E0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B1E5  EA AC 13 EB 05        LJMP   0x5eb:0x13ac                 ; UNKNOWN
01B1EA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B1EF  EA 4C 39 EB 05        LJMP   0x5eb:0x394c                 ; UNKNOWN
01B1F4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B1F9  EA 72 1F EB 05        LJMP   0x5eb:0x1f72                 ; UNKNOWN
01B1FE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B203  EA 18 0E EB 05        LJMP   0x5eb:0xe18                  ; UNKNOWN
01B208  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B20D  EA 2C 02 EB 05        LJMP   0x5eb:0x22c                  ; UNKNOWN
01B212  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B217  EA 56 39 EB 05        LJMP   0x5eb:0x3956                 ; UNKNOWN
01B21C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B221  EA A0 32 EB 05        LJMP   0x5eb:0x32a0                 ; UNKNOWN
01B226  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B22B  EA 68 10 EB 05        LJMP   0x5eb:0x1068                 ; UNKNOWN
01B230  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B235  EA 42 02 EB 05        LJMP   0x5eb:0x242                  ; UNKNOWN
01B23A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B23F  EA 6E 09 EB 05        LJMP   0x5eb:0x96e                  ; UNKNOWN
01B244  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B249  EA 52 0E EB 05        LJMP   0x5eb:0xe52                  ; UNKNOWN
01B24E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B253  EA 70 04 EB 05        LJMP   0x5eb:0x470                  ; UNKNOWN
01B258  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B25D  EA 40 30 EB 05        LJMP   0x5eb:0x3040                 ; UNKNOWN
01B262  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B267  EA E4 26 EB 05        LJMP   0x5eb:0x26e4                 ; UNKNOWN
01B26C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B271  EA 84 04 EB 05        LJMP   0x5eb:0x484                  ; UNKNOWN
01B276  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B27B  EA 74 02 EB 05        LJMP   0x5eb:0x274                  ; UNKNOWN
01B280  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B285  EA 68 06 EB 05        LJMP   0x5eb:0x668                  ; UNKNOWN
01B28A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B28F  EA 02 00 EB 05        LJMP   0x5eb:2                      ; UNKNOWN
01B294  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B299  EA 54 30 EB 05        LJMP   0x5eb:0x3054                 ; UNKNOWN
01B29E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B2A3  EA 8C 0E EB 05        LJMP   0x5eb:0xe8c                  ; UNKNOWN
01B2A8  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B2AD  EA 04 16 EB 05        LJMP   0x5eb:0x1604                 ; UNKNOWN
01B2B2  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B2B7  EA F8 32 EB 05        LJMP   0x5eb:0x32f8                 ; UNKNOWN
01B2BC  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B2C1  EA C0 09 EB 05        LJMP   0x5eb:0x9c0                  ; UNKNOWN
01B2C6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B2CB  EA 4C 1D EB 05        LJMP   0x5eb:0x1d4c                 ; UNKNOWN
01B2D0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B2D5  EA A6 06 EB 05        LJMP   0x5eb:0x6a6                  ; UNKNOWN
01B2DA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B2DF  EA 6A 30 EB 05        LJMP   0x5eb:0x306a                 ; UNKNOWN
01B2E4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B2E9  EA 2A 14 EB 05        LJMP   0x5eb:0x142a                 ; UNKNOWN
01B2EE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B2F3  EA 02 03 EB 05        LJMP   0x5eb:0x302                  ; UNKNOWN
01B2F8  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B2FD  EA 52 0C EB 05        LJMP   0x5eb:0xc52                  ; UNKNOWN
01B302  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B307  EA A2 00 EB 05        LJMP   0x5eb:0xa2                   ; UNKNOWN
01B30C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B311  EA 7A 0C EB 05        LJMP   0x5eb:0xc7a                  ; UNKNOWN
01B316  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B31B  EA 26 03 EB 05        LJMP   0x5eb:0x326                  ; UNKNOWN
01B320  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B325  EA 46 16 EB 05        LJMP   0x5eb:0x1646                 ; UNKNOWN
01B32A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B32F  EA 50 0A EB 05        LJMP   0x5eb:0xa50                  ; UNKNOWN
01B334  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B339  EA D2 06 EB 05        LJMP   0x5eb:0x6d2                  ; UNKNOWN
01B33E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B343  EA 4A 33 EB 05        LJMP   0x5eb:0x334a                 ; UNKNOWN
01B348  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B34D  EA B8 30 EB 05        LJMP   0x5eb:0x30b8                 ; UNKNOWN
01B352  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B357  EA 76 14 EB 05        LJMP   0x5eb:0x1476                 ; UNKNOWN
01B35C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B361  EA F2 00 00 00        LJMP   0:0xf2                       ; UNKNOWN
01B366  0B 00                 OR     ax, word ptr [bx + si] ; LOGIC
01B368  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B36D  EA C2 07 00 00        LJMP   0:0x7c2                      ; UNKNOWN
01B372  0B 00                 OR     ax, word ptr [bx + si] ; LOGIC
01B374  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B379  EA 56 03 00 00        LJMP   0:0x356                      ; UNKNOWN
01B37E  0B 00                 OR     ax, word ptr [bx + si] ; LOGIC
01B380  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B385  EA 1A 00 EF 09        LJMP   0x9ef:0x1a                   ; UNKNOWN
01B38A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B38F  EA B2 03 84 09        LJMP   0x984:0x3b2                  ; UNKNOWN
01B394  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B399  EA CA 03 84 09        LJMP   0x984:0x3ca                  ; UNKNOWN
01B39E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B3A3  EA 6A 00 84 09        LJMP   0x984:0x6a                   ; UNKNOWN
01B3A8  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B3AD  EA E8 00 84 09        LJMP   0x984:0xe8                   ; UNKNOWN
01B3B2  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B3B7  EA 3A 04 84 09        LJMP   0x984:0x43a                  ; UNKNOWN
01B3BC  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B3C1  EA 0A 01 84 09        LJMP   0x984:0x10a                  ; UNKNOWN
01B3C6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B3CB  EA 5A 04 84 09        LJMP   0x984:0x45a                  ; UNKNOWN
01B3D0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B3D5  EA 6E 04 84 09        LJMP   0x984:0x46e                  ; UNKNOWN
01B3DA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B3DF  EA 90 04 84 09        LJMP   0x984:0x490                  ; UNKNOWN
01B3E4  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B3E9  EA 3A 05 84 09        LJMP   0x984:0x53a                  ; UNKNOWN
01B3EE  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B3F3  EA B8 05 84 09        LJMP   0x984:0x5b8                  ; UNKNOWN
01B3F8  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B3FD  EA 9E 02 84 09        LJMP   0x984:0x29e                  ; UNKNOWN
01B402  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B407  EA 36 06 84 09        LJMP   0x984:0x636                  ; UNKNOWN
01B40C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B411  EA C0 00 00 00        LJMP   0:0xc0                       ; UNKNOWN
01B416  15 00 DF              ADC    ax, 0xdf00 ; ARITH
01B419  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B41D  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B420  F6 03 00              TEST   byte ptr [bp + di], 0 ; LOGIC
01B423  00 15                 ADD    byte ptr [di], dl ; ARITH
01B425  00 83 00 9A           ADD    byte ptr [bp + di - 0x6600], al ; ARITH
01B429  AB                    STOSW  word ptr es:[di], ax ; STR
01B42A  0D 0D 11              OR     ax, 0x110d ; LOGIC
01B42D  EA 60 03 00 00        LJMP   0:0x360                      ; UNKNOWN
01B432  15 00 00              ADC    ax, 0 ; ARITH
01B435  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B439  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B43C  56                    PUSH   si ; STACK_PUSH
01B43D  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B43F  00 09                 ADD    byte ptr [bx + di], cl ; ARITH
01B441  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B445  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B448  3C 09                 CMP    al, 9 ; CMP
01B44A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B44C  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
01B44E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B453  EA 04 00 EF 09        LJMP   0x9ef:4                      ; UNKNOWN
01B458  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B45D  EA 08 00 EF 09        LJMP   0x9ef:8                      ; UNKNOWN
01B462  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B467  EA 12 00 0C 0C        LJMP   0xc0c:0x12                   ; UNKNOWN
01B46C  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B471  EA B0 00 F6 09        LJMP   0x9f6:0xb0                   ; UNKNOWN
01B476  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B47B  EA FA 00 F6 09        LJMP   0x9f6:0xfa                   ; UNKNOWN
01B480  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B485  EA 38 01 F6 09        LJMP   0x9f6:0x138                  ; UNKNOWN
01B48A  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B48F  EA 02 00 F6 09        LJMP   0x9f6:2                      ; UNKNOWN
01B494  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B499  EA A6 01 0A 0A        LJMP   0xa0a:0x1a6                  ; UNKNOWN
01B49E  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B4A3  EA 04 00 0A 0A        LJMP   0xa0a:4                      ; UNKNOWN
01B4A8  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B4AD  EA 5B 01 29 0A        LJMP   0xa29:0x15b                  ; UNKNOWN
01B4B2  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B4B7  EA 09 02 29 0A        LJMP   0xa29:0x209                  ; UNKNOWN
01B4BC  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B4C1  EA 1C 00 4E 0A        LJMP   0xa4e:0x1c                   ; UNKNOWN
01B4C6  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B4CB  EA 00 00 11 0D        LJMP   0xd11:0                      ; UNKNOWN
01B4D0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B4D5  EA 06 00 E3 0A        LJMP   0xae3:6                      ; UNKNOWN
01B4DA  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01B4DF  EA 21 00 E3 0A        LJMP   0xae3:0x21                   ; UNKNOWN
01B4E4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B4E9  EA 66 1E 00 00        LJMP   0:0x1e66                     ; UNKNOWN
01B4EE  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B4F0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B4F5  EA 06 11 00 00        LJMP   0:0x1106                     ; UNKNOWN
01B4FA  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B4FC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B501  EA 12 11 00 00        LJMP   0:0x1112                     ; UNKNOWN
01B506  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B508  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B50D  EA 8C 26 00 00        LJMP   0:0x268c                     ; UNKNOWN
01B512  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B514  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B519  EA CE 23 00 00        LJMP   0:0x23ce                     ; UNKNOWN
01B51E  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B520  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B525  EA EE 32 00 00        LJMP   0:0x32ee                     ; UNKNOWN
01B52A  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B52C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B531  EA 00 00 00 00        LJMP   0:0                          ; UNKNOWN
01B536  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B538  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B53D  EA 22 07 00 00        LJMP   0:0x722                      ; UNKNOWN
01B542  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B544  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B549  EA 64 24 00 00        LJMP   0:0x2464                     ; UNKNOWN
01B54E  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B550  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B555  EA 36 1F 00 00        LJMP   0:0x1f36                     ; UNKNOWN
01B55A  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B55C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B561  EA 1E 00 00 00        LJMP   0:0x1e                       ; UNKNOWN
01B566  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B568  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B56D  EA F6 26 00 00        LJMP   0:0x26f6                     ; UNKNOWN
01B572  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B574  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B579  EA 08 19 00 00        LJMP   0:0x1908                     ; UNKNOWN
01B57E  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B580  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B585  EA 5A 1B 00 00        LJMP   0:0x1b5a                     ; UNKNOWN
01B58A  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B58C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B591  EA 52 0E 00 00        LJMP   0:0xe52                      ; UNKNOWN
01B596  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B598  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B59D  EA 44 33 00 00        LJMP   0:0x3344                     ; UNKNOWN
01B5A2  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B5A4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B5A9  EA 3E 16 00 00        LJMP   0:0x163e                     ; UNKNOWN
01B5AE  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B5B0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B5B5  EA 7E 07 00 00        LJMP   0:0x77e                      ; UNKNOWN
01B5BA  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B5BC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B5C1  EA E6 36 00 00        LJMP   0:0x36e6                     ; UNKNOWN
01B5C6  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B5C8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B5CD  EA D2 1F 00 00        LJMP   0:0x1fd2                     ; UNKNOWN
01B5D2  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B5D4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B5D9  EA 62 16 00 00        LJMP   0:0x1662                     ; UNKNOWN
01B5DE  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B5E0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B5E5  EA 3C 30 00 00        LJMP   0:0x303c                     ; UNKNOWN
01B5EA  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B5EC  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B5EE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B5F0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B5F5  EA 28 20 00 00        LJMP   0:0x2028                     ; UNKNOWN
01B5FA  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B5FC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B601  EA 3E 12 00 00        LJMP   0:0x123e                     ; UNKNOWN
01B606  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B608  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B60D  EA E6 3A 00 00        LJMP   0:0x3ae6                     ; UNKNOWN
01B612  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B614  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B619  EA CC 08 00 00        LJMP   0:0x8cc                      ; UNKNOWN
01B61E  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B620  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B625  EA 52 37 00 00        LJMP   0:0x3752                     ; UNKNOWN
01B62A  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B62C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B631  EA 52 19 00 00        LJMP   0:0x1952                     ; UNKNOWN
01B636  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B638  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B63D  EA CE 33 00 00        LJMP   0:0x33ce                     ; UNKNOWN
01B642  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B644  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B649  EA 92 0F 00 00        LJMP   0:0xf92                      ; UNKNOWN
01B64E  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B650  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B655  EA DA 0F 00 00        LJMP   0:0xfda                      ; UNKNOWN
01B65A  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B65C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B661  EA 02 09 00 00        LJMP   0:0x902                      ; UNKNOWN
01B666  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B668  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B66D  EA B2 37 00 00        LJMP   0:0x37b2                     ; UNKNOWN
01B672  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B674  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B679  EA 42 34 00 00        LJMP   0:0x3442                     ; UNKNOWN
01B67E  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B680  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B685  EA F6 20 00 00        LJMP   0:0x20f6                     ; UNKNOWN
01B68A  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B68C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B691  EA E4 0F 00 00        LJMP   0:0xfe4                      ; UNKNOWN
01B696  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B698  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B69D  EA 58 34 00 00        LJMP   0:0x3458                     ; UNKNOWN
01B6A2  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B6A4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B6A9  EA FE 0F 00 00        LJMP   0:0xffe                      ; UNKNOWN
01B6AE  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B6B0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B6B5  EA 08 0B 00 00        LJMP   0:0xb08                      ; UNKNOWN
01B6BA  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B6BC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B6C1  EA 62 34 00 00        LJMP   0:0x3462                     ; UNKNOWN
01B6C6  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B6C8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B6CD  EA 9E 19 00 00        LJMP   0:0x199e                     ; UNKNOWN
01B6D2  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B6D4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B6D9  EA 34 0B 00 00        LJMP   0:0xb34                      ; UNKNOWN
01B6DE  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B6E0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B6E5  EA 02 38 00 00        LJMP   0:0x3802                     ; UNKNOWN
01B6EA  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B6EC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B6F1  EA FC 1D 00 00        LJMP   0:0x1dfc                     ; UNKNOWN
01B6F6  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B6F8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B6FD  EA 3A 22 00 00        LJMP   0:0x223a                     ; UNKNOWN
01B702  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B704  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B709  EA 54 14 00 00        LJMP   0:0x1454                     ; UNKNOWN
01B70E  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B710  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B715  EA FC 37 00 00        LJMP   0:0x37fc                     ; UNKNOWN
01B71A  17                    POP    ss ; STACK_POP
01B71B  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B71F  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B722  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01B724  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B726  1E                    PUSH   ds ; STACK_PUSH
01B727  00 19                 ADD    byte ptr [bx + di], bl ; ARITH
01B729  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B72D  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B730  C6 05 00              MOV    byte ptr [di], 0 ; MOV
01B733  00 0A                 ADD    byte ptr [bp + si], cl ; ARITH
01B735  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B739  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B73C  52                    PUSH   dx ; STACK_PUSH
01B73D  05 00 00              ADD    ax, 0 ; ARITH
01B740  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
01B742  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B747  EA F6 05 00 00        LJMP   0:0x5f6                      ; UNKNOWN
01B74C  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
01B74E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B753  EA 82 05 00 00        LJMP   0:0x582                      ; UNKNOWN
01B758  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
01B75A  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B75F  EA 80 25 00 00        LJMP   0:0x2580                     ; UNKNOWN
01B764  17                    POP    ss ; STACK_POP
01B765  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B769  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B76C  00 0A                 ADD    byte ptr [bp + si], cl ; ARITH
01B76E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B770  17                    POP    ss ; STACK_POP
01B771  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B775  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B778  A4                    MOVSB  byte ptr es:[di], byte ptr [si] ; STR
01B779  32 00                 XOR    al, byte ptr [bx + si] ; LOGIC
01B77B  00 17                 ADD    byte ptr [bx], dl ; ARITH
01B77D  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B781  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B784  0C 00                 OR     al, 0 ; LOGIC
01B786  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B788  15 00 02              ADC    ax, 0x200 ; ARITH
01B78B  01 9A AB 0D           ADD    word ptr [bp + si + 0xdab], bx ; ARITH
01B78F  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B792  60                    PUSHAW                              ; UNKNOWN
01B793  37                    AAA ; ARITH
01B794  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B796  17                    POP    ss ; STACK_POP
01B797  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B79B  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B79E  AA                    STOSB  byte ptr es:[di], al ; STR
01B79F  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B7A1  00 1F                 ADD    byte ptr [bx], bl ; ARITH
01B7A3  00 21                 ADD    byte ptr [bx + di], ah ; ARITH
01B7A5  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B7A9  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B7AC  FA                    CLI ; FLAG
01B7AD  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01B7AF  00 17                 ADD    byte ptr [bx], dl ; ARITH
01B7B1  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B7B5  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B7B8  A6                    CMPSB  byte ptr [si], byte ptr es:[di] ; STR
01B7B9  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01B7BB  00 08                 ADD    byte ptr [bx + si], cl ; ARITH
01B7BD  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B7BF  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B7C3  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B7C6  60                    PUSHAW                              ; UNKNOWN
01B7C7  0F 00 00              SLDT   word ptr [bx + si]           ; UNKNOWN
01B7CA  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01B7CC  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B7CE  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B7D3  EA A4 11 00 00        LJMP   0:0x11a4                     ; UNKNOWN
01B7D8  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01B7DA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B7DC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B7E1  EA EC 1A 00 00        LJMP   0:0x1aec                     ; UNKNOWN
01B7E6  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
01B7E8  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B7EA  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B7EF  EA 6E 07 00 00        LJMP   0:0x76e                      ; UNKNOWN
01B7F4  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01B7F6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B7F8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B7FD  EA 7A 00 00 00        LJMP   0:0x7a                       ; UNKNOWN
01B802  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01B804  38 01                 CMP    byte ptr [bx + di], al ; CMP
01B806  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B80B  EA 26 05 00 00        LJMP   0:0x526                      ; UNKNOWN
01B810  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01B812  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B814  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B819  EA 2A 11 00 00        LJMP   0:0x112a                     ; UNKNOWN
01B81E  17                    POP    ss ; STACK_POP
01B81F  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B823  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B826  3C 0F                 CMP    al, 0xf ; CMP
01B828  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B82A  17                    POP    ss ; STACK_POP
01B82B  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B82F  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B832  D0 06 00 00           ROL    byte ptr [0], 1 ; LOGIC
01B836  17                    POP    ss ; STACK_POP
01B837  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B83B  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B83E  E0 00                 LOOPNE 0x1b840 ; CJUMP
01B840  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B842  0C 00                 OR     al, 0 ; LOGIC
01B844  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B849  EA 64 1E 00 00        LJMP   0:0x1e64                     ; UNKNOWN
01B84E  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
01B850  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B852  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B857  EA 04 37 00 00        LJMP   0:0x3704                     ; UNKNOWN
01B85C  17                    POP    ss ; STACK_POP
01B85D  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B861  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B864  FC                    CLD ; FLAG
01B865  36 00 00              ADD    byte ptr ss:[bx + si], al ; ARITH
01B868  17                    POP    ss ; STACK_POP
01B869  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B86D  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B870  1E                    PUSH   ds ; STACK_PUSH
01B871  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B873  00 1F                 ADD    byte ptr [bx], bl ; ARITH
01B875  00 4B 00              ADD    byte ptr [bp + di], cl ; ARITH
01B878  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B87D  EA 68 01 00 00        LJMP   0:0x168                      ; UNKNOWN
01B882  15 00 5B              ADC    ax, 0x5b00 ; ARITH
01B885  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B889  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B88C  32 01                 XOR    al, byte ptr [bx + di] ; LOGIC
01B88E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B890  15 00 5B              ADC    ax, 0x5b00 ; ARITH
01B893  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B897  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B89A  28 10                 SUB    byte ptr [bx + si], dl ; ARITH
01B89C  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B89E  15 00 02              ADC    ax, 0x200 ; ARITH
01B8A1  01 9A AB 0D           ADD    word ptr [bp + si + 0xdab], bx ; ARITH
01B8A5  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B8A8  D0 0B                 ROR    byte ptr [bp + di], 1 ; LOGIC
01B8AA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B8AC  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01B8AE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B8B0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B8B5  EA 0A 09 00 00        LJMP   0:0x90a                      ; UNKNOWN
01B8BA  12 00                 ADC    al, byte ptr [bx + si] ; ARITH
01B8BC  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B8BE  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B8C3  EA 00 00 00 00        LJMP   0:0                          ; UNKNOWN
01B8C8  12 00                 ADC    al, byte ptr [bx + si] ; ARITH
01B8CA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B8CC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B8D1  EA 96 07 00 00        LJMP   0:0x796                      ; UNKNOWN
01B8D6  12 00                 ADC    al, byte ptr [bx + si] ; ARITH
01B8D8  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B8DA  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B8DF  EA 5E 01 00 00        LJMP   0:0x15e                      ; UNKNOWN
01B8E4  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01B8E6  38 01                 CMP    byte ptr [bx + di], al ; CMP
01B8E8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B8ED  EA C6 01 00 00        LJMP   0:0x1c6                      ; UNKNOWN
01B8F2  12 00                 ADC    al, byte ptr [bx + si] ; ARITH
01B8F4  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B8F6  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B8FB  EA 2E 37 00 00        LJMP   0:0x372e                     ; UNKNOWN
01B900  17                    POP    ss ; STACK_POP
01B901  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B905  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B908  64 25 00 00           AND    ax, 0 ; LOGIC
01B90C  06                    PUSH   es ; STACK_PUSH
01B90D  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01B911  AB                    STOSW  word ptr es:[di], ax ; STR
01B912  0D 0D 11              OR     ax, 0x110d ; LOGIC
01B915  EA E8 04 00 00        LJMP   0:0x4e8                      ; UNKNOWN
01B91A  1A 00                 SBB    al, byte ptr [bx + si] ; ARITH
01B91C  BE 00 9A              MOV    si, 0x9a00 ; CONST_LOAD
01B91F  AB                    STOSW  word ptr es:[di], ax ; STR
01B920  0D 0D 11              OR     ax, 0x110d ; LOGIC
01B923  EA 0A 03 00 00        LJMP   0:0x30a                      ; UNKNOWN
01B928  1A 00                 SBB    al, byte ptr [bx + si] ; ARITH
01B92A  BE 00 9A              MOV    si, 0x9a00 ; CONST_LOAD
01B92D  AB                    STOSW  word ptr es:[di], ax ; STR
01B92E  0D 0D 11              OR     ax, 0x110d ; LOGIC
01B931  EA 2A 09 00 00        LJMP   0:0x92a                      ; UNKNOWN
01B936  17                    POP    ss ; STACK_POP
01B937  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B93B  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B93E  28 15                 SUB    byte ptr [di], dl ; ARITH
01B940  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B942  06                    PUSH   es ; STACK_PUSH
01B943  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01B947  AB                    STOSW  word ptr es:[di], ax ; STR
01B948  0D 0D 11              OR     ax, 0x110d ; LOGIC
01B94B  EA 26 1A 00 00        LJMP   0:0x1a26                     ; UNKNOWN
01B950  06                    PUSH   es ; STACK_PUSH
01B951  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01B955  AB                    STOSW  word ptr es:[di], ax ; STR
01B956  0D 0D 11              OR     ax, 0x110d ; LOGIC
01B959  EA 18 02 00 00        LJMP   0:0x218                      ; UNKNOWN
01B95E  06                    PUSH   es ; STACK_PUSH
01B95F  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01B963  AB                    STOSW  word ptr es:[di], ax ; STR
01B964  0D 0D 11              OR     ax, 0x110d ; LOGIC
01B967  EA B8 24 00 00        LJMP   0:0x24b8                     ; UNKNOWN
01B96C  16                    PUSH   ss ; STACK_PUSH
01B96D  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B96F  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B973  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B976  86 14                 XCHG   byte ptr [si], dl ; MOV
01B978  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B97A  12 00                 ADC    al, byte ptr [bx + si] ; ARITH
01B97C  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B97E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B983  EA 5C 11 00 00        LJMP   0:0x115c                     ; UNKNOWN
01B988  12 00                 ADC    al, byte ptr [bx + si] ; ARITH
01B98A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B98C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B991  EA 50 12 00 00        LJMP   0:0x1250                     ; UNKNOWN
01B996  12 00                 ADC    al, byte ptr [bx + si] ; ARITH
01B998  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B99A  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01B99F  EA 92 00 00 00        LJMP   0:0x92                       ; UNKNOWN
01B9A4  05 00 B1              ADD    ax, 0xb100 ; ARITH
01B9A7  02 9A AB 0D           ADD    bl, byte ptr [bp + si + 0xdab] ; ARITH
01B9AB  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B9AE  48                    DEC    ax ; ARITH
01B9AF  25 00 00              AND    ax, 0 ; LOGIC
01B9B2  05 00 00              ADD    ax, 0 ; ARITH
01B9B5  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B9B9  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B9BC  0C 22                 OR     al, 0x22 ; LOGIC
01B9BE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B9C0  05 00 00              ADD    ax, 0 ; ARITH
01B9C3  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B9C7  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B9CA  D8 1E 00 00           FCOMP  dword ptr [0]                ; UNKNOWN
01B9CE  05 00 00              ADD    ax, 0 ; ARITH
01B9D1  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B9D5  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B9D8  10 17                 ADC    byte ptr [bx], dl ; ARITH
01B9DA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B9DC  05 00 00              ADD    ax, 0 ; ARITH
01B9DF  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B9E3  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B9E6  D8 10                 FCOM   dword ptr [bx + si]          ; UNKNOWN
01B9E8  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01B9EA  05 00 00              ADD    ax, 0 ; ARITH
01B9ED  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B9F1  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01B9F4  D0 06 00 00           ROL    byte ptr [0], 1 ; LOGIC
01B9F8  05 00 00              ADD    ax, 0 ; ARITH
01B9FB  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01B9FF  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BA02  18 06 00 00           SBB    byte ptr [0], al ; ARITH
01BA06  05 00 00              ADD    ax, 0 ; ARITH
01BA09  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BA0D  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BA10  0A 01                 OR     al, byte ptr [bx + di] ; LOGIC
01BA12  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BA14  05 00 00              ADD    ax, 0 ; ARITH
01BA17  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BA1B  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BA1E  AC                    LODSB  al, byte ptr [si] ; STR
01BA1F  0E                    PUSH   cs ; STACK_PUSH
01BA20  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BA22  16                    PUSH   ss ; STACK_PUSH
01BA23  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BA25  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BA29  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BA2C  48                    DEC    ax ; ARITH
01BA2D  38 00                 CMP    byte ptr [bx + si], al ; CMP
01BA2F  00 17                 ADD    byte ptr [bx], dl ; ARITH
01BA31  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BA35  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BA38  E2 01                 LOOP   0x1ba3b ; CJUMP
01BA3A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BA3C  0C 00                 OR     al, 0 ; LOGIC
01BA3E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BA43  EA 9E 04 00 00        LJMP   0:0x49e                      ; UNKNOWN
01BA48  07                    POP    es ; STACK_POP
01BA49  00 C5                 ADD    ch, al ; ARITH
01BA4B  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BA4F  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BA52  1A 05                 SBB    al, byte ptr [di] ; ARITH
01BA54  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BA56  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
01BA58  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01BA5D  EA 00 00 5E 0B        LJMP   0xb5e:0                      ; UNKNOWN
01BA62  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BA67  EA 94 0D 00 00        LJMP   0:0xd94                      ; UNKNOWN
01BA6C  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
01BA6E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BA73  EA AC 13 00 00        LJMP   0:0x13ac                     ; UNKNOWN
01BA78  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
01BA7A  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BA7F  EA DE 14 00 00        LJMP   0:0x14de                     ; UNKNOWN
01BA84  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
01BA86  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BA8B  EA 4A 14 00 00        LJMP   0:0x144a                     ; UNKNOWN
01BA90  0A 00                 OR     al, byte ptr [bx + si] ; LOGIC
01BA92  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01BA97  EA 2C 00 E7 0A        LJMP   0xae7:0x2c                   ; UNKNOWN
01BA9C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BAA1  EA 6C 0B 00 00        LJMP   0:0xb6c                      ; UNKNOWN
01BAA6  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01BAA8  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BAAA  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BAAF  EA 72 09 00 00        LJMP   0:0x972                      ; UNKNOWN
01BAB4  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01BAB6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BAB8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BABD  EA 9E 60 00 00        LJMP   0:0x609e                     ; UNKNOWN
01BAC2  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BAC4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BAC9  EA 66 2B 00 00        LJMP   0:0x2b66                     ; UNKNOWN
01BACE  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BAD0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BAD5  EA 1C 17 00 00        LJMP   0:0x171c                     ; UNKNOWN
01BADA  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BADC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BAE1  EA 4C 28 00 00        LJMP   0:0x284c                     ; UNKNOWN
01BAE6  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BAE8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BAED  EA B6 60 00 00        LJMP   0:0x60b6                     ; UNKNOWN
01BAF2  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BAF4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BAF9  EA 22 07 00 00        LJMP   0:0x722                      ; UNKNOWN
01BAFE  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BB00  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BB05  EA B0 05 00 00        LJMP   0:0x5b0                      ; UNKNOWN
01BB0A  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BB0C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BB11  EA 26 2F 00 00        LJMP   0:0x2f26                     ; UNKNOWN
01BB16  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BB18  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BB1D  EA A0 59 00 00        LJMP   0:0x59a0                     ; UNKNOWN
01BB22  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BB24  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BB29  EA A8 0B 00 00        LJMP   0:0xba8                      ; UNKNOWN
01BB2E  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BB30  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BB35  EA 84 42 00 00        LJMP   0:0x4284                     ; UNKNOWN
01BB3A  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BB3C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BB41  EA 3E 2F 00 00        LJMP   0:0x2f3e                     ; UNKNOWN
01BB46  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BB48  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BB4D  EA CE 1C 00 00        LJMP   0:0x1cce                     ; UNKNOWN
01BB52  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BB54  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BB59  EA B2 11 00 00        LJMP   0:0x11b2                     ; UNKNOWN
01BB5E  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BB60  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BB65  EA DC 60 00 00        LJMP   0:0x60dc                     ; UNKNOWN
01BB6A  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BB6C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BB71  EA 54 20 00 00        LJMP   0:0x2054                     ; UNKNOWN
01BB76  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BB78  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BB7D  EA CE 56 00 00        LJMP   0:0x56ce                     ; UNKNOWN
01BB82  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BB84  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BB89  EA A6 4D 00 00        LJMP   0:0x4da6                     ; UNKNOWN
01BB8E  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BB90  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BB95  EA BE 42 00 00        LJMP   0:0x42be                     ; UNKNOWN
01BB9A  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BB9C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BBA1  EA 9E 28 00 00        LJMP   0:0x289e                     ; UNKNOWN
01BBA6  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BBA8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BBAD  EA 84 24 00 00        LJMP   0:0x2484                     ; UNKNOWN
01BBB2  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BBB4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BBB9  EA D0 17 00 00        LJMP   0:0x17d0                     ; UNKNOWN
01BBBE  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BBC0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BBC5  EA 72 63 00 00        LJMP   0:0x6372                     ; UNKNOWN
01BBCA  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BBCC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BBD1  EA 3C 2C 00 00        LJMP   0:0x2c3c                     ; UNKNOWN
01BBD6  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BBD8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BBDD  EA 34 04 00 00        LJMP   0:0x434                      ; UNKNOWN
01BBE2  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BBE4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BBE9  EA F2 42 00 00        LJMP   0:0x42f2                     ; UNKNOWN
01BBEE  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BBF0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BBF5  EA A6 3F 00 00        LJMP   0:0x3fa6                     ; UNKNOWN
01BBFA  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BBFC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BC01  EA B2 24 00 00        LJMP   0:0x24b2                     ; UNKNOWN
01BC06  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BC08  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BC0D  EA 1E 01 00 00        LJMP   0:0x11e                      ; UNKNOWN
01BC12  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BC14  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BC19  EA 1C 4A 00 00        LJMP   0:0x4a1c                     ; UNKNOWN
01BC1E  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BC20  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BC25  EA 42 08 00 00        LJMP   0:0x842                      ; UNKNOWN
01BC2A  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BC2C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BC31  EA 10 43 00 00        LJMP   0:0x4310                     ; UNKNOWN
01BC36  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BC38  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BC3D  EA 92 2C 00 00        LJMP   0:0x2c92                     ; UNKNOWN
01BC42  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BC44  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BC49  EA D6 28 00 00        LJMP   0:0x28d6                     ; UNKNOWN
01BC4E  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BC50  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BC55  EA 8C 20 00 00        LJMP   0:0x208c                     ; UNKNOWN
01BC5A  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BC5C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BC61  EA D4 14 00 00        LJMP   0:0x14d4                     ; UNKNOWN
01BC66  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BC68  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BC6D  EA 44 5E 00 00        LJMP   0:0x5e44                     ; UNKNOWN
01BC72  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BC74  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BC79  EA 0E 2D 00 00        LJMP   0:0x2d0e                     ; UNKNOWN
01BC7E  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BC80  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BC85  EA 68 5A 00 00        LJMP   0:0x5a68                     ; UNKNOWN
01BC8A  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BC8C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BC91  EA 1C 2D 00 00        LJMP   0:0x2d1c                     ; UNKNOWN
01BC96  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BC98  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BC9D  EA 2C 62 00 00        LJMP   0:0x622c                     ; UNKNOWN
01BCA2  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BCA4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BCA9  EA 46 57 00 00        LJMP   0:0x5746                     ; UNKNOWN
01BCAE  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BCB0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BCB5  EA C2 13 00 00        LJMP   0:0x13c2                     ; UNKNOWN
01BCBA  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BCBC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BCC1  EA A0 40 00 00        LJMP   0:0x40a0                     ; UNKNOWN
01BCC6  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BCC8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BCCD  EA 46 1E 00 00        LJMP   0:0x1e46                     ; UNKNOWN
01BCD2  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BCD4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BCD9  EA CC 12 00 00        LJMP   0:0x12cc                     ; UNKNOWN
01BCDE  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BCE0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BCE5  EA 32 03 00 00        LJMP   0:0x332                      ; UNKNOWN
01BCEA  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BCEC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BCF1  EA 74 62 00 00        LJMP   0:0x6274                     ; UNKNOWN
01BCF6  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BCF8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BCFD  EA DA 21 00 00        LJMP   0:0x21da                     ; UNKNOWN
01BD02  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BD04  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BD09  EA 8E 54 00 00        LJMP   0:0x548e                     ; UNKNOWN
01BD0E  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BD10  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BD15  EA EC 4F 00 00        LJMP   0:0x4fec                     ; UNKNOWN
01BD1A  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BD1C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BD21  EA D2 5B 00 00        LJMP   0:0x5bd2                     ; UNKNOWN
01BD26  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BD28  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BD2D  EA 90 2D 00 00        LJMP   0:0x2d90                     ; UNKNOWN
01BD32  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BD34  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BD39  EA 8A 62 00 00        LJMP   0:0x628a                     ; UNKNOWN
01BD3E  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BD40  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BD45  EA 8C 34 00 00        LJMP   0:0x348c                     ; UNKNOWN
01BD4A  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BD4C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BD51  EA 62 22 00 00        LJMP   0:0x2262                     ; UNKNOWN
01BD56  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BD58  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BD5D  EA 24 44 00 00        LJMP   0:0x4424                     ; UNKNOWN
01BD62  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BD64  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BD69  EA B6 05 00 00        LJMP   0:0x5b6                      ; UNKNOWN
01BD6E  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BD70  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BD75  EA C6 5F 00 00        LJMP   0:0x5fc6                     ; UNKNOWN
01BD7A  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BD7C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BD81  EA 2A 2E 00 00        LJMP   0:0x2e2a                     ; UNKNOWN
01BD86  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BD88  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BD8D  EA B6 22 00 00        LJMP   0:0x22b6                     ; UNKNOWN
01BD92  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BD94  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BD99  EA BC 47 00 00        LJMP   0:0x47bc                     ; UNKNOWN
01BD9E  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BDA0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BDA5  EA 92 2E 00 00        LJMP   0:0x2e92                     ; UNKNOWN
01BDAA  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BDAC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BDB1  EA EE 05 00 00        LJMP   0:0x5ee                      ; UNKNOWN
01BDB6  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BDB8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BDBD  EA EC 51 00 00        LJMP   0:0x51ec                     ; UNKNOWN
01BDC2  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BDC4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BDC9  EA B2 2E 00 00        LJMP   0:0x2eb2                     ; UNKNOWN
01BDCE  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BDD0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BDD5  EA C0 41 00 00        LJMP   0:0x41c0                     ; UNKNOWN
01BDDA  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BDDC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BDE1  EA 3E 0A 00 00        LJMP   0:0xa3e                      ; UNKNOWN
01BDE6  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BDE8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BDED  EA 62 4B 00 00        LJMP   0:0x4b62                     ; UNKNOWN
01BDF2  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BDF4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BDF9  EA 74 0A 00 00        LJMP   0:0xa74                      ; UNKNOWN
01BDFE  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BE00  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BE05  EA D4 44 00 00        LJMP   0:0x44d4                     ; UNKNOWN
01BE0A  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BE0C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BE11  EA C6 2E 00 00        LJMP   0:0x2ec6                     ; UNKNOWN
01BE16  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BE18  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BE1D  EA 2C 2B 00 00        LJMP   0:0x2b2c                     ; UNKNOWN
01BE22  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BE24  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BE29  EA F2 16 00 00        LJMP   0:0x16f2                     ; UNKNOWN
01BE2E  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BE30  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BE35  EA CE 0F 00 00        LJMP   0:0xfce                      ; UNKNOWN
01BE3A  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BE3C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BE41  EA 00 00 00 00        LJMP   0:0                          ; UNKNOWN
01BE46  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BE48  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BE4D  EA DA 55 00 00        LJMP   0:0x55da                     ; UNKNOWN
01BE52  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BE54  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BE59  EA EA 2E 00 00        LJMP   0:0x2eea                     ; UNKNOWN
01BE5E  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01BE60  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01BE65  EA 00 00 05 0D        LJMP   0xd05:0                      ; UNKNOWN
01BE6A  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BE6F  EA 0C 00 00 00        LJMP   0:0xc                        ; UNKNOWN
01BE74  1B 00                 SBB    ax, word ptr [bx + si] ; ARITH
01BE76  61                    POPAW                               ; UNKNOWN
01BE77  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BE7B  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BE7E  EA 00 00 00 15        LJMP   0x1500:0                     ; UNKNOWN
01BE83  00 83 00 9A           ADD    byte ptr [bp + di - 0x6600], al ; ARITH
01BE87  AB                    STOSW  word ptr es:[di], ax ; STR
01BE88  0D 0D 11              OR     ax, 0x110d ; LOGIC
01BE8B  EA 48 02 00 00        LJMP   0:0x248                      ; UNKNOWN
01BE90  15 00 83              ADC    ax, 0x8300 ; ARITH
01BE93  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BE97  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BE9A  AE                    SCASB  al, byte ptr es:[di] ; STR
01BE9B  10 00                 ADC    byte ptr [bx + si], al ; ARITH
01BE9D  00 15                 ADD    byte ptr [di], dl ; ARITH
01BE9F  00 02                 ADD    byte ptr [bp + si], al ; ARITH
01BEA1  01 9A 91 0D           ADD    word ptr [bp + si + 0xd91], bx ; ARITH
01BEA5  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BEA8  06                    PUSH   es ; STACK_PUSH
01BEA9  00 C3                 ADD    bl, al ; ARITH
01BEAB  0B 9A 91 0D           OR     bx, word ptr [bp + si + 0xd91] ; LOGIC
01BEAF  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BEB2  0C 00                 OR     al, 0 ; LOGIC
01BEB4  BC 0B 9A              MOV    sp, 0x9a0b ; CONST_LOAD
01BEB7  AB                    STOSW  word ptr es:[di], ax ; STR
01BEB8  0D 0D 11              OR     ax, 0x110d ; LOGIC
01BEBB  EA 32 0C 00 00        LJMP   0:0xc32                      ; UNKNOWN
01BEC0  17                    POP    ss ; STACK_POP
01BEC1  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BEC5  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BEC8  22 0C                 AND    cl, byte ptr [si] ; LOGIC
01BECA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BECC  17                    POP    ss ; STACK_POP
01BECD  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BED1  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BED4  20 18                 AND    byte ptr [bx + si], bl ; LOGIC
01BED6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BED8  16                    PUSH   ss ; STACK_PUSH
01BED9  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BEDB  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BEDF  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BEE2  E2 09                 LOOP   0x1beed ; CJUMP
01BEE4  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BEE6  17                    POP    ss ; STACK_POP
01BEE7  00 9A 91 0D           ADD    byte ptr [bp + si + 0xd91], bl ; ARITH
01BEEB  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BEEE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BEF0  78 0B                 JS     0x1befd ; CJUMP
01BEF2  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BEF7  EA A8 1B 00 00        LJMP   0:0x1ba8                     ; UNKNOWN
01BEFC  16                    PUSH   ss ; STACK_PUSH
01BEFD  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BEFF  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BF03  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BF06  9C                    PUSHF ; STACK_PUSH
01BF07  30 00                 XOR    byte ptr [bx + si], al ; LOGIC
01BF09  00 17                 ADD    byte ptr [bx], dl ; ARITH
01BF0B  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BF0F  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BF12  06                    PUSH   es ; STACK_PUSH
01BF13  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01BF15  00 18                 ADD    byte ptr [bx + si], bl ; ARITH
01BF17  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BF1B  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BF1E  1A 00                 SBB    al, byte ptr [bx + si] ; ARITH
01BF20  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BF22  18 00                 SBB    byte ptr [bx + si], al ; ARITH
01BF24  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BF29  EA CE 05 00 00        LJMP   0:0x5ce                      ; UNKNOWN
01BF2E  16                    PUSH   ss ; STACK_PUSH
01BF2F  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BF31  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BF35  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BF38  E6 07                 OUT    7, al ; IO
01BF3A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BF3C  16                    PUSH   ss ; STACK_PUSH
01BF3D  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BF3F  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BF43  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BF46  88 06 00 00           MOV    byte ptr [0], al ; MOV
01BF4A  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
01BF4C  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BF4E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BF53  EA F6 01 00 00        LJMP   0:0x1f6                      ; UNKNOWN
01BF58  15 00 DF              ADC    ax, 0xdf00 ; ARITH
01BF5B  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BF5F  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BF62  18 02                 SBB    byte ptr [bp + si], al ; ARITH
01BF64  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BF66  15 00 DF              ADC    ax, 0xdf00 ; ARITH
01BF69  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BF6D  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BF70  14 01                 ADC    al, 1 ; ARITH
01BF72  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BF74  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
01BF76  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BF78  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BF7D  EA 3A 03 00 00        LJMP   0:0x33a                      ; UNKNOWN
01BF82  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
01BF84  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BF86  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BF8B  EA 76 1B 00 00        LJMP   0:0x1b76                     ; UNKNOWN
01BF90  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
01BF92  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BF94  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BF99  EA 1A 1B 00 00        LJMP   0:0x1b1a                     ; UNKNOWN
01BF9E  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
01BFA0  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BFA2  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BFA7  EA A8 1B 00 00        LJMP   0:0x1ba8                     ; UNKNOWN
01BFAC  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
01BFAE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BFB0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BFB5  EA 36 06 00 00        LJMP   0:0x636                      ; UNKNOWN
01BFBA  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
01BFBC  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BFBE  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BFC3  EA F6 03 00 00        LJMP   0:0x3f6                      ; UNKNOWN
01BFC8  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
01BFCA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BFCC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BFD1  EA 00 00 00 00        LJMP   0:0                          ; UNKNOWN
01BFD6  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
01BFD8  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BFDA  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BFDF  EA 40 00 00 00        LJMP   0:0x40                       ; UNKNOWN
01BFE4  04 00                 ADD    al, 0 ; ARITH
01BFE6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BFE8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01BFED  EA 22 0A 00 00        LJMP   0:0xa22                      ; UNKNOWN
01BFF2  06                    PUSH   es ; STACK_PUSH
01BFF3  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01BFF5  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01BFF9  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01BFFC  D0 00                 ROL    byte ptr [bx + si], 1 ; LOGIC
01BFFE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C000  07                    POP    es ; STACK_POP
01C001  00 31                 ADD    byte ptr [bx + di], dh ; ARITH
01C003  01 9A AB 0D           ADD    word ptr [bp + si + 0xdab], bx ; ARITH
01C007  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C00A  0E                    PUSH   cs ; STACK_PUSH
01C00B  1B 00                 SBB    ax, word ptr [bx + si] ; ARITH
01C00D  00 10                 ADD    byte ptr [bx + si], dl ; ARITH
01C00F  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C013  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C016  2C 00                 SUB    al, 0 ; ARITH
01C018  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C01A  07                    POP    es ; STACK_POP
01C01B  00 31                 ADD    byte ptr [bx + di], dh ; ARITH
01C01D  01 9A AB 0D           ADD    word ptr [bp + si + 0xdab], bx ; ARITH
01C021  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C024  FA                    CLI ; FLAG
01C025  1D 00 00              SBB    ax, 0 ; ARITH
01C028  04 00                 ADD    al, 0 ; ARITH
01C02A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C02C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C031  EA 0E 06 00 00        LJMP   0:0x60e                      ; UNKNOWN
01C036  12 00                 ADC    al, byte ptr [bx + si] ; ARITH
01C038  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C03A  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C03F  EA 1A 00 00 00        LJMP   0:0x1a                       ; UNKNOWN
01C044  12 00                 ADC    al, byte ptr [bx + si] ; ARITH
01C046  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C048  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C04D  EA 04 00 00 00        LJMP   0:4                          ; UNKNOWN
01C052  03 00                 ADD    ax, word ptr [bx + si] ; ARITH
01C054  F9                    STC ; FLAG
01C055  01 9A AB 0D           ADD    word ptr [bp + si + 0xdab], bx ; ARITH
01C059  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C05C  24 24                 AND    al, 0x24 ; LOGIC
01C05E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C060  06                    PUSH   es ; STACK_PUSH
01C061  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01C065  AB                    STOSW  word ptr es:[di], ax ; STR
01C066  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C069  EA 18 00 00 00        LJMP   0:0x18                       ; UNKNOWN
01C06E  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01C070  C7 01 9A AB           MOV    word ptr [bx + di], 0xab9a ; CONST_LOAD
01C074  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C077  EA BA 06 00 00        LJMP   0:0x6ba                      ; UNKNOWN
01C07C  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01C07E  38 01                 CMP    byte ptr [bx + di], al ; CMP
01C080  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C085  EA 52 5E 00 00        LJMP   0:0x5e52                     ; UNKNOWN
01C08A  04 00                 ADD    al, 0 ; ARITH
01C08C  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C08E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C093  EA 06 06 00 00        LJMP   0:0x606                      ; UNKNOWN
01C098  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01C09A  C7 01 9A AB           MOV    word ptr [bx + di], 0xab9a ; CONST_LOAD
01C09E  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C0A1  EA C4 00 00 00        LJMP   0:0xc4                       ; UNKNOWN
01C0A6  1B 00                 SBB    ax, word ptr [bx + si] ; ARITH
01C0A8  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C0AA  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C0AF  EA E2 20 00 00        LJMP   0:0x20e2                     ; UNKNOWN
01C0B4  1A 00                 SBB    al, byte ptr [bx + si] ; ARITH
01C0B6  1E                    PUSH   ds ; STACK_PUSH
01C0B7  01 9A AB 0D           ADD    word ptr [bp + si + 0xdab], bx ; ARITH
01C0BB  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C0BE  04 04                 ADD    al, 4 ; ARITH
01C0C0  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C0C2  17                    POP    ss ; STACK_POP
01C0C3  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C0C7  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C0CA  8A 37                 MOV    dh, byte ptr [bx] ; MOV
01C0CC  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C0CE  17                    POP    ss ; STACK_POP
01C0CF  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C0D3  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C0D6  C8 3D 00 00           ENTER  0x3d, 0 ; PROLOGUE
01C0DA  04 00                 ADD    al, 0 ; ARITH
01C0DC  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C0DE  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C0E3  EA 02 00 00 00        LJMP   0:2                          ; UNKNOWN
01C0E8  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01C0EA  38 01                 CMP    byte ptr [bx + di], al ; CMP
01C0EC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C0F1  EA D4 46 00 00        LJMP   0:0x46d4                     ; UNKNOWN
01C0F6  04 00                 ADD    al, 0 ; ARITH
01C0F8  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C0FA  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C0FF  EA F4 1C 00 00        LJMP   0:0x1cf4                     ; UNKNOWN
01C104  04 00                 ADD    al, 0 ; ARITH
01C106  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C108  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C10D  EA 9E 19 00 00        LJMP   0:0x199e                     ; UNKNOWN
01C112  04 00                 ADD    al, 0 ; ARITH
01C114  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C116  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C11B  EA 18 07 00 00        LJMP   0:0x718                      ; UNKNOWN
01C120  04 00                 ADD    al, 0 ; ARITH
01C122  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C124  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C129  EA 4A 58 00 00        LJMP   0:0x584a                     ; UNKNOWN
01C12E  04 00                 ADD    al, 0 ; ARITH
01C130  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C132  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C137  EA A2 1F 00 00        LJMP   0:0x1fa2                     ; UNKNOWN
01C13C  04 00                 ADD    al, 0 ; ARITH
01C13E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C140  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C145  EA D8 19 00 00        LJMP   0:0x19d8                     ; UNKNOWN
01C14A  04 00                 ADD    al, 0 ; ARITH
01C14C  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C14E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C153  EA 5E 0F 00 00        LJMP   0:0xf5e                      ; UNKNOWN
01C158  04 00                 ADD    al, 0 ; ARITH
01C15A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C15C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C161  EA 24 60 00 00        LJMP   0:0x6024                     ; UNKNOWN
01C166  04 00                 ADD    al, 0 ; ARITH
01C168  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C16A  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C16F  EA E8 5B 00 00        LJMP   0:0x5be8                     ; UNKNOWN
01C174  04 00                 ADD    al, 0 ; ARITH
01C176  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C178  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C17D  EA 92 2A 00 00        LJMP   0:0x2a92                     ; UNKNOWN
01C182  04 00                 ADD    al, 0 ; ARITH
01C184  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C186  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C18B  EA F8 19 00 00        LJMP   0:0x19f8                     ; UNKNOWN
01C190  04 00                 ADD    al, 0 ; ARITH
01C192  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C194  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C199  EA 86 3C 00 00        LJMP   0:0x3c86                     ; UNKNOWN
01C19E  04 00                 ADD    al, 0 ; ARITH
01C1A0  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C1A2  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C1A7  EA 50 4B 00 00        LJMP   0:0x4b50                     ; UNKNOWN
01C1AC  04 00                 ADD    al, 0 ; ARITH
01C1AE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C1B0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C1B5  EA 56 14 00 00        LJMP   0:0x1456                     ; UNKNOWN
01C1BA  04 00                 ADD    al, 0 ; ARITH
01C1BC  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C1BE  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C1C3  EA A4 44 00 00        LJMP   0:0x44a4                     ; UNKNOWN
01C1C8  04 00                 ADD    al, 0 ; ARITH
01C1CA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C1CC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C1D1  EA 0C 1A 00 00        LJMP   0:0x1a0c                     ; UNKNOWN
01C1D6  04 00                 ADD    al, 0 ; ARITH
01C1D8  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C1DA  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C1DF  EA C6 07 00 00        LJMP   0:0x7c6                      ; UNKNOWN
01C1E4  04 00                 ADD    al, 0 ; ARITH
01C1E6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C1E8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C1ED  EA C6 31 00 00        LJMP   0:0x31c6                     ; UNKNOWN
01C1F2  04 00                 ADD    al, 0 ; ARITH
01C1F4  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C1F6  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C1FB  EA FE 2D 00 00        LJMP   0:0x2dfe                     ; UNKNOWN
01C200  04 00                 ADD    al, 0 ; ARITH
01C202  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C204  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C209  EA 80 1D 00 00        LJMP   0:0x1d80                     ; UNKNOWN
01C20E  04 00                 ADD    al, 0 ; ARITH
01C210  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C212  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C217  EA 30 1A 00 00        LJMP   0:0x1a30                     ; UNKNOWN
01C21C  04 00                 ADD    al, 0 ; ARITH
01C21E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C220  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C225  EA 6C 14 00 00        LJMP   0:0x146c                     ; UNKNOWN
01C22A  04 00                 ADD    al, 0 ; ARITH
01C22C  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C22E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C233  EA 16 00 00 00        LJMP   0:0x16                       ; UNKNOWN
01C238  04 00                 ADD    al, 0 ; ARITH
01C23A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C23C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C241  EA 02 35 00 00        LJMP   0:0x3502                     ; UNKNOWN
01C246  04 00                 ADD    al, 0 ; ARITH
01C248  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C24A  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C24F  EA BA 1A 00 00        LJMP   0:0x1aba                     ; UNKNOWN
01C254  04 00                 ADD    al, 0 ; ARITH
01C256  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C258  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C25D  EA 48 0D 00 00        LJMP   0:0xd48                      ; UNKNOWN
01C262  04 00                 ADD    al, 0 ; ARITH
01C264  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C266  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C26B  EA 1C 08 00 00        LJMP   0:0x81c                      ; UNKNOWN
01C270  04 00                 ADD    al, 0 ; ARITH
01C272  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C274  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C279  EA 30 59 00 00        LJMP   0:0x5930                     ; UNKNOWN
01C27E  04 00                 ADD    al, 0 ; ARITH
01C280  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C282  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C287  EA 90 45 00 00        LJMP   0:0x4590                     ; UNKNOWN
01C28C  04 00                 ADD    al, 0 ; ARITH
01C28E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C290  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C295  EA 6E 4F 00 00        LJMP   0:0x4f6e                     ; UNKNOWN
01C29A  04 00                 ADD    al, 0 ; ARITH
01C29C  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C29E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C2A3  EA DC 2E 00 00        LJMP   0:0x2edc                     ; UNKNOWN
01C2A8  04 00                 ADD    al, 0 ; ARITH
01C2AA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C2AC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C2B1  EA 58 00 00 00        LJMP   0:0x58                       ; UNKNOWN
01C2B6  04 00                 ADD    al, 0 ; ARITH
01C2B8  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C2BA  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C2BF  EA CE 41 00 00        LJMP   0:0x41ce                     ; UNKNOWN
01C2C4  04 00                 ADD    al, 0 ; ARITH
01C2C6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C2C8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C2CD  EA E8 05 00 00        LJMP   0:0x5e8                      ; UNKNOWN
01C2D2  04 00                 ADD    al, 0 ; ARITH
01C2D4  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C2D6  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C2DB  EA 36 08 00 00        LJMP   0:0x836                      ; UNKNOWN
01C2E0  04 00                 ADD    al, 0 ; ARITH
01C2E2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C2E4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C2E9  EA 28 32 00 00        LJMP   0:0x3228                     ; UNKNOWN
01C2EE  04 00                 ADD    al, 0 ; ARITH
01C2F0  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C2F2  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C2F7  EA C4 23 00 00        LJMP   0:0x23c4                     ; UNKNOWN
01C2FC  04 00                 ADD    al, 0 ; ARITH
01C2FE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C300  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C305  EA 6C 08 00 00        LJMP   0:0x86c                      ; UNKNOWN
01C30A  04 00                 ADD    al, 0 ; ARITH
01C30C  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C30E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C313  EA FE 2B 00 00        LJMP   0:0x2bfe                     ; UNKNOWN
01C318  04 00                 ADD    al, 0 ; ARITH
01C31A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C31C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C321  EA 84 48 00 00        LJMP   0:0x4884                     ; UNKNOWN
01C326  04 00                 ADD    al, 0 ; ARITH
01C328  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C32A  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C32F  EA A4 08 00 00        LJMP   0:0x8a4                      ; UNKNOWN
01C334  04 00                 ADD    al, 0 ; ARITH
01C336  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C338  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C33D  EA F4 4D 00 00        LJMP   0:0x4df4                     ; UNKNOWN
01C342  04 00                 ADD    al, 0 ; ARITH
01C344  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C346  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C34B  EA E2 14 00 00        LJMP   0:0x14e2                     ; UNKNOWN
01C350  04 00                 ADD    al, 0 ; ARITH
01C352  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C354  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C359  EA 2E 46 00 00        LJMP   0:0x462e                     ; UNKNOWN
01C35E  04 00                 ADD    al, 0 ; ARITH
01C360  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C362  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C367  EA 9E 1B 00 00        LJMP   0:0x1b9e                     ; UNKNOWN
01C36C  04 00                 ADD    al, 0 ; ARITH
01C36E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C370  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C375  EA 66 06 00 00        LJMP   0:0x666                      ; UNKNOWN
01C37A  04 00                 ADD    al, 0 ; ARITH
01C37C  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C37E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C383  EA BC 1E 00 00        LJMP   0:0x1ebc                     ; UNKNOWN
01C388  04 00                 ADD    al, 0 ; ARITH
01C38A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C38C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C391  EA 7C 12 00 00        LJMP   0:0x127c                     ; UNKNOWN
01C396  04 00                 ADD    al, 0 ; ARITH
01C398  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C39A  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C39F  EA 94 36 00 00        LJMP   0:0x3694                     ; UNKNOWN
01C3A4  04 00                 ADD    al, 0 ; ARITH
01C3A6  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C3A8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C3AD  EA D2 1B 00 00        LJMP   0:0x1bd2                     ; UNKNOWN
01C3B2  04 00                 ADD    al, 0 ; ARITH
01C3B4  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C3B6  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C3BB  EA 0C 1F 00 00        LJMP   0:0x1f0c                     ; UNKNOWN
01C3C0  04 00                 ADD    al, 0 ; ARITH
01C3C2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C3C4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C3C9  EA FC 18 00 00        LJMP   0:0x18fc                     ; UNKNOWN
01C3CE  04 00                 ADD    al, 0 ; ARITH
01C3D0  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C3D2  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C3D7  EA AA 15 00 00        LJMP   0:0x15aa                     ; UNKNOWN
01C3DC  04 00                 ADD    al, 0 ; ARITH
01C3DE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C3E0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C3E5  EA 16 0E 00 00        LJMP   0:0xe16                      ; UNKNOWN
01C3EA  04 00                 ADD    al, 0 ; ARITH
01C3EC  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C3EE  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C3F3  EA 56 19 00 00        LJMP   0:0x1956                     ; UNKNOWN
01C3F8  04 00                 ADD    al, 0 ; ARITH
01C3FA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C3FC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C401  EA C4 06 00 00        LJMP   0:0x6c4                      ; UNKNOWN
01C406  04 00                 ADD    al, 0 ; ARITH
01C408  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C40A  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C40F  EA 78 4E 00 00        LJMP   0:0x4e78                     ; UNKNOWN
01C414  04 00                 ADD    al, 0 ; ARITH
01C416  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C418  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C41D  EA 46 37 00 00        LJMP   0:0x3746                     ; UNKNOWN
01C422  04 00                 ADD    al, 0 ; ARITH
01C424  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C426  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C42B  EA 5C 28 00 00        LJMP   0:0x285c                     ; UNKNOWN
01C430  04 00                 ADD    al, 0 ; ARITH
01C432  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C434  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C439  EA 60 19 00 00        LJMP   0:0x1960                     ; UNKNOWN
01C43E  04 00                 ADD    al, 0 ; ARITH
01C440  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C442  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C447  EA 64 1C 00 00        LJMP   0:0x1c64                     ; UNKNOWN
01C44C  04 00                 ADD    al, 0 ; ARITH
01C44E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C450  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C455  EA 8E 4E 00 00        LJMP   0:0x4e8e                     ; UNKNOWN
01C45A  04 00                 ADD    al, 0 ; ARITH
01C45C  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C45E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C463  EA 66 1F 00 00        LJMP   0:0x1f66                     ; UNKNOWN
01C468  04 00                 ADD    al, 0 ; ARITH
01C46A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C46C  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C471  EA 82 13 00 00        LJMP   0:0x1382                     ; UNKNOWN
01C476  04 00                 ADD    al, 0 ; ARITH
01C478  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C47A  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C47F  EA 7E 1F 00 00        LJMP   0:0x1f7e                     ; UNKNOWN
01C484  04 00                 ADD    al, 0 ; ARITH
01C486  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C488  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C48D  EA AA 30 00 00        LJMP   0:0x30aa                     ; UNKNOWN
01C492  04 00                 ADD    al, 0 ; ARITH
01C494  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C496  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C49B  EA AC 1C 00 00        LJMP   0:0x1cac                     ; UNKNOWN
01C4A0  04 00                 ADD    al, 0 ; ARITH
01C4A2  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C4A4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C4A9  EA 8E 1F 00 00        LJMP   0:0x1f8e                     ; UNKNOWN
01C4AE  04 00                 ADD    al, 0 ; ARITH
01C4B0  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C4B2  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C4B7  EA 46 03 00 00        LJMP   0:0x346                      ; UNKNOWN
01C4BC  08 00                 OR     byte ptr [bx + si], al ; LOGIC
01C4BE  38 01                 CMP    byte ptr [bx + di], al ; CMP
01C4C0  9A 91 0D 0D 11        LCALL  0x110d, 0xd91 ; LCALL
01C4C5  EA 0A 00 F8 0C        LJMP   0xcf8:0xa                    ; UNKNOWN
01C4CA  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C4CF  EA 06 00 00 00        LJMP   0:6                          ; UNKNOWN
01C4D4  04 00                 ADD    al, 0 ; ARITH
01C4D6  42                    INC    dx ; ARITH
01C4D7  06                    PUSH   es ; STACK_PUSH
01C4D8  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C4DD  EA 8A 00 00 00        LJMP   0:0x8a                       ; UNKNOWN
01C4E2  05 00 00              ADD    ax, 0 ; ARITH
01C4E5  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C4E9  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C4EC  38 14                 CMP    byte ptr [si], dl ; CMP
01C4EE  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C4F0  05 00 00              ADD    ax, 0 ; ARITH
01C4F3  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C4F7  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C4FA  94                    XCHG   sp, ax ; MOV
01C4FB  1B 00                 SBB    ax, word ptr [bx + si] ; ARITH
01C4FD  00 05                 ADD    byte ptr [di], al ; ARITH
01C4FF  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C501  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C505  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C508  B4 20                 MOV    ah, 0x20 ; CONST_LOAD
01C50A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C50C  05 00 00              ADD    ax, 0 ; ARITH
01C50F  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C513  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C516  EC                    IN     al, dx ; IO
01C517  1B 00                 SBB    ax, word ptr [bx + si] ; ARITH
01C519  00 05                 ADD    byte ptr [di], al ; ARITH
01C51B  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C51D  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C521  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C524  50                    PUSH   ax ; STACK_PUSH
01C525  15 00 00              ADC    ax, 0 ; ARITH
01C528  05 00 00              ADD    ax, 0 ; ARITH
01C52B  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C52F  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C532  3E 0D 00 00           OR     ax, 0 ; LOGIC
01C536  05 00 00              ADD    ax, 0 ; ARITH
01C539  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C53D  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C540  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C542  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C544  05 00 00              ADD    ax, 0 ; ARITH
01C547  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C54B  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C54E  80 1E 00 00 05        SBB    byte ptr [0], 5 ; ARITH
01C553  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C555  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C559  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C55C  82 09 00              OR     byte ptr [bx + di], 0 ; LOGIC
01C55F  00 06 00 00           ADD    byte ptr [0], al ; ARITH
01C563  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C567  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C56A  4A                    DEC    dx ; ARITH
01C56B  02 00                 ADD    al, byte ptr [bx + si] ; ARITH
01C56D  00 06 00 00           ADD    byte ptr [0], al ; ARITH
01C571  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C575  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C578  D0 02                 ROL    byte ptr [bp + si], 1 ; LOGIC
01C57A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C57C  09 00                 OR     word ptr [bx + si], ax ; LOGIC
01C57E  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C583  EA 56 0F 00 00        LJMP   0:0xf56                      ; UNKNOWN
01C588  05 00 B1              ADD    ax, 0xb100 ; ARITH
01C58B  02 9A AB 0D           ADD    bl, byte ptr [bp + si + 0xdab] ; ARITH
01C58F  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C592  70 0B                 JO     0x1c59f ; CJUMP
01C594  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C596  05 00 B1              ADD    ax, 0xb100 ; ARITH
01C599  02 9A AB 0D           ADD    bl, byte ptr [bp + si + 0xdab] ; ARITH
01C59D  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C5A0  0E                    PUSH   cs ; STACK_PUSH
01C5A1  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C5A3  00 05                 ADD    byte ptr [di], al ; ARITH
01C5A5  00 B1 02 9A           ADD    byte ptr [bx + di - 0x65fe], dh ; ARITH
01C5A9  AB                    STOSW  word ptr es:[di], ax ; STR
01C5AA  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C5AD  EA 00 00 00 00        LJMP   0:0                          ; UNKNOWN
01C5B2  18 00                 SBB    byte ptr [bx + si], al ; ARITH
01C5B4  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C5B9  EA 5E 01 00 00        LJMP   0:0x15e                      ; UNKNOWN
01C5BE  18 00                 SBB    byte ptr [bx + si], al ; ARITH
01C5C0  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C5C5  EA 54 00 00 00        LJMP   0:0x54                       ; UNKNOWN
01C5CA  1B 00                 SBB    ax, word ptr [bx + si] ; ARITH
01C5CC  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C5CE  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C5D3  EA 00 00 00 00        LJMP   0:0                          ; UNKNOWN
01C5D8  1B 00                 SBB    ax, word ptr [bx + si] ; ARITH
01C5DA  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C5DC  9A AB 0D 0D 11        LCALL  0x110d, 0xdab ; LCALL
01C5E1  EA 42 03 00 00        LJMP   0:0x342                      ; UNKNOWN
01C5E6  06                    PUSH   es ; STACK_PUSH
01C5E7  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C5E9  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C5EB  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C5ED  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C5EF  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C5F3  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C5F6  D2 06 00 00           ROL    byte ptr [0], cl ; LOGIC
01C5FA  06                    PUSH   es ; STACK_PUSH
01C5FB  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C5FD  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C601  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C604  26 01 00              ADD    word ptr es:[bx + si], ax ; ARITH
01C607  00 06 00 00           ADD    byte ptr [0], al ; ARITH
01C60B  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C60F  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C612  5A                    POP    dx ; STACK_POP
01C613  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01C615  00 06 00 00           ADD    byte ptr [0], al ; ARITH
01C619  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C61D  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C620  A6                    CMPSB  byte ptr [si], byte ptr es:[di] ; STR
01C621  01 00                 ADD    word ptr [bx + si], ax ; ARITH
01C623  00 06 00 00           ADD    byte ptr [0], al ; ARITH
01C627  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C62B  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C62E  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C630  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C632  06                    PUSH   es ; STACK_PUSH
01C633  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C635  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C639  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C63C  5A                    POP    dx ; STACK_POP
01C63D  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C63F  00 06 00 00           ADD    byte ptr [0], al ; ARITH
01C643  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C647  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C64A  80 00 00              ADD    byte ptr [bx + si], 0 ; ARITH
01C64D  00 06 00 00           ADD    byte ptr [0], al ; ARITH
01C651  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C655  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C658  28 1F                 SUB    byte ptr [bx], bl ; ARITH
01C65A  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C65C  16                    PUSH   ss ; STACK_PUSH
01C65D  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C65F  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C663  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C666  82 00 00              ADD    byte ptr [bx + si], 0 ; ARITH
01C669  00 06 00 B2           ADD    byte ptr [0xb200], al ; ARITH
01C66D  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C671  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C674  42                    INC    dx ; ARITH
01C675  1D 00 00              SBB    ax, 0 ; ARITH
01C678  06                    PUSH   es ; STACK_PUSH
01C679  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01C67D  AB                    STOSW  word ptr es:[di], ax ; STR
01C67E  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C681  EA 08 01 00 00        LJMP   0:0x108                      ; UNKNOWN
01C686  06                    PUSH   es ; STACK_PUSH
01C687  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01C68B  AB                    STOSW  word ptr es:[di], ax ; STR
01C68C  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C68F  EA 0A 16 00 00        LJMP   0:0x160a                     ; UNKNOWN
01C694  06                    PUSH   es ; STACK_PUSH
01C695  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01C699  AB                    STOSW  word ptr es:[di], ax ; STR
01C69A  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C69D  EA 12 05 00 00        LJMP   0:0x512                      ; UNKNOWN
01C6A2  06                    PUSH   es ; STACK_PUSH
01C6A3  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01C6A7  AB                    STOSW  word ptr es:[di], ax ; STR
01C6A8  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C6AB  EA 88 01 00 00        LJMP   0:0x188                      ; UNKNOWN
01C6B0  06                    PUSH   es ; STACK_PUSH
01C6B1  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01C6B5  AB                    STOSW  word ptr es:[di], ax ; STR
01C6B6  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C6B9  EA CA 1E 00 00        LJMP   0:0x1eca                     ; UNKNOWN
01C6BE  06                    PUSH   es ; STACK_PUSH
01C6BF  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01C6C3  AB                    STOSW  word ptr es:[di], ax ; STR
01C6C4  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C6C7  EA EA 05 00 00        LJMP   0:0x5ea                      ; UNKNOWN
01C6CC  06                    PUSH   es ; STACK_PUSH
01C6CD  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01C6D1  AB                    STOSW  word ptr es:[di], ax ; STR
01C6D2  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C6D5  EA F4 05 00 00        LJMP   0:0x5f4                      ; UNKNOWN
01C6DA  06                    PUSH   es ; STACK_PUSH
01C6DB  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01C6DF  AB                    STOSW  word ptr es:[di], ax ; STR
01C6E0  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C6E3  EA 0A 06 00 00        LJMP   0:0x60a                      ; UNKNOWN
01C6E8  06                    PUSH   es ; STACK_PUSH
01C6E9  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01C6ED  AB                    STOSW  word ptr es:[di], ax ; STR
01C6EE  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C6F1  EA 82 09 00 00        LJMP   0:0x982                      ; UNKNOWN
01C6F6  06                    PUSH   es ; STACK_PUSH
01C6F7  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01C6FB  AB                    STOSW  word ptr es:[di], ax ; STR
01C6FC  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C6FF  EA F0 10 00 00        LJMP   0:0x10f0                     ; UNKNOWN
01C704  06                    PUSH   es ; STACK_PUSH
01C705  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01C709  AB                    STOSW  word ptr es:[di], ax ; STR
01C70A  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C70D  EA A6 06 00 00        LJMP   0:0x6a6                      ; UNKNOWN
01C712  06                    PUSH   es ; STACK_PUSH
01C713  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01C717  AB                    STOSW  word ptr es:[di], ax ; STR
01C718  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C71B  EA 22 20 00 00        LJMP   0:0x2022                     ; UNKNOWN
01C720  06                    PUSH   es ; STACK_PUSH
01C721  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01C725  AB                    STOSW  word ptr es:[di], ax ; STR
01C726  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C729  EA 04 00 00 00        LJMP   0:4                          ; UNKNOWN
01C72E  06                    PUSH   es ; STACK_PUSH
01C72F  00 B2 00 9A           ADD    byte ptr [bp + si - 0x6600], dh ; ARITH
01C733  AB                    STOSW  word ptr es:[di], ax ; STR
01C734  0D 0D 11              OR     ax, 0x110d ; LOGIC
01C737  EA 00 00 00 00        LJMP   0:0                          ; UNKNOWN
01C73C  07                    POP    es ; STACK_POP
01C73D  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C73F  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C743  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C746  1E                    PUSH   ds ; STACK_PUSH
01C747  0C 00                 OR     al, 0 ; LOGIC
01C749  00 07                 ADD    byte ptr [bx], al ; ARITH
01C74B  00 00                 ADD    byte ptr [bx + si], al ; ARITH
01C74D  00 9A AB 0D           ADD    byte ptr [bp + si + 0xdab], bl ; ARITH
01C751  0D 11 EA              OR     ax, 0xea11 ; LOGIC
01C754  62 06 00 00           BOUND  ax, dword ptr [0] ; SYS
01C758  0F                    DB     0x0F ; DATA_BYTE
01C759  00                    DB     0x00 ; DATA_BYTE
01C75A  7F                    DB     0x7F ; DATA_BYTE
01C75B  03                    DB     0x03 ; DATA_BYTE
01C75C  9A                    DB     0x9A ; DATA_BYTE
01C75D  AB                    DB     0xAB ; DATA_BYTE
01C75E  0D                    DB     0x0D ; DATA_BYTE
01C75F  0D                    DB     0x0D ; DATA_BYTE
01C760  11                    DB     0x11 ; DATA_BYTE
01C761  EA                    DB     0xEA ; DATA_BYTE
01C762  28                    DB     0x28 ; DATA_BYTE
01C763  45                    DB     0x45 ; DATA_BYTE
01C764  00                    DB     0x00 ; DATA_BYTE
01C765  00                    DB     0x00 ; DATA_BYTE
01C766  0C                    DB     0x0C ; DATA_BYTE
01C767  00                    DB     0x00 ; DATA_BYTE
01C768  9A                    DB     0x9A ; DATA_BYTE
01C769  AB                    DB     0xAB ; DATA_BYTE
01C76A  0D                    DB     0x0D ; DATA_BYTE
01C76B  0D                    DB     0x0D ; DATA_BYTE
01C76C  11                    DB     0x11 ; DATA_BYTE
01C76D  EA                    DB     0xEA ; DATA_BYTE
01C76E  04                    DB     0x04 ; DATA_BYTE
01C76F  00                    DB     0x00 ; DATA_BYTE
01C770  00                    DB     0x00 ; DATA_BYTE
01C771  00                    DB     0x00 ; DATA_BYTE
01C772  12                    DB     0x12 ; DATA_BYTE
01C773  00                    DB     0x00 ; DATA_BYTE
01C774  5F                    DB     0x5F ; DATA_BYTE
01C775  01                    DB     0x01 ; DATA_BYTE
01C776  9A                    DB     0x9A ; DATA_BYTE
01C777  AB                    DB     0xAB ; DATA_BYTE
01C778  0D                    DB     0x0D ; DATA_BYTE
01C779  0D                    DB     0x0D ; DATA_BYTE
01C77A  11                    DB     0x11 ; DATA_BYTE
01C77B  EA                    DB     0xEA ; DATA_BYTE
01C77C  08                    DB     0x08 ; DATA_BYTE
01C77D  19                    DB     0x19 ; DATA_BYTE
01C77E  00                    DB     0x00 ; DATA_BYTE
01C77F  00                    DB     0x00 ; DATA_BYTE
01C780  10                    DB     0x10 ; DATA_BYTE
01C781  00                    DB     0x00 ; DATA_BYTE
01C782  9A                    DB     0x9A ; DATA_BYTE
01C783  AB                    DB     0xAB ; DATA_BYTE
01C784  0D                    DB     0x0D ; DATA_BYTE
01C785  0D                    DB     0x0D ; DATA_BYTE
01C786  11                    DB     0x11 ; DATA_BYTE
01C787  EA                    DB     0xEA ; DATA_BYTE
01C788  80                    DB     0x80 ; DATA_BYTE
01C789  31                    DB     0x31 ; DATA_BYTE
01C78A  00                    DB     0x00 ; DATA_BYTE
01C78B  00                    DB     0x00 ; DATA_BYTE
01C78C  0F                    DB     0x0F ; DATA_BYTE
01C78D  00                    DB     0x00 ; DATA_BYTE
01C78E  00                    DB     0x00 ; DATA_BYTE
01C78F  00                    DB     0x00 ; DATA_BYTE
01C790  9A                    DB     0x9A ; DATA_BYTE
01C791  AB                    DB     0xAB ; DATA_BYTE
01C792  0D                    DB     0x0D ; DATA_BYTE
01C793  0D                    DB     0x0D ; DATA_BYTE
01C794  11                    DB     0x11 ; DATA_BYTE
01C795  EA                    DB     0xEA ; DATA_BYTE
01C796  06                    DB     0x06 ; DATA_BYTE
01C797  00                    DB     0x00 ; DATA_BYTE
01C798  00                    DB     0x00 ; DATA_BYTE
01C799  00                    DB     0x00 ; DATA_BYTE
01C79A  07                    DB     0x07 ; DATA_BYTE
01C79B  00                    DB     0x00 ; DATA_BYTE
01C79C  C5                    DB     0xC5 ; DATA_BYTE
01C79D  00                    DB     0x00 ; DATA_BYTE
01C79E  9A                    DB     0x9A ; DATA_BYTE
01C79F  AB                    DB     0xAB ; DATA_BYTE
01C7A0  0D                    DB     0x0D ; DATA_BYTE
01C7A1  0D                    DB     0x0D ; DATA_BYTE
01C7A2  11                    DB     0x11 ; DATA_BYTE
01C7A3  EA                    DB     0xEA ; DATA_BYTE
01C7A4  5C                    DB     0x5C ; DATA_BYTE
01C7A5  01                    DB     0x01 ; DATA_BYTE
01C7A6  00                    DB     0x00 ; DATA_BYTE
01C7A7  00                    DB     0x00 ; DATA_BYTE
01C7A8  07                    DB     0x07 ; DATA_BYTE
01C7A9  00                    DB     0x00 ; DATA_BYTE
01C7AA  C5                    DB     0xC5 ; DATA_BYTE
01C7AB  00                    DB     0x00 ; DATA_BYTE
01C7AC  9A                    DB     0x9A ; DATA_BYTE
01C7AD  AB                    DB     0xAB ; DATA_BYTE
01C7AE  0D                    DB     0x0D ; DATA_BYTE
01C7AF  0D                    DB     0x0D ; DATA_BYTE
01C7B0  11                    DB     0x11 ; DATA_BYTE
01C7B1  EA                    DB     0xEA ; DATA_BYTE
01C7B2  02                    DB     0x02 ; DATA_BYTE
01C7B3  00                    DB     0x00 ; DATA_BYTE
01C7B4  00                    DB     0x00 ; DATA_BYTE
01C7B5  00                    DB     0x00 ; DATA_BYTE
01C7B6  07                    DB     0x07 ; DATA_BYTE
01C7B7  00                    DB     0x00 ; DATA_BYTE
01C7B8  31                    DB     0x31 ; DATA_BYTE
01C7B9  01                    DB     0x01 ; DATA_BYTE
01C7BA  9A                    DB     0x9A ; DATA_BYTE
01C7BB  AB                    DB     0xAB ; DATA_BYTE
01C7BC  0D                    DB     0x0D ; DATA_BYTE
01C7BD  0D                    DB     0x0D ; DATA_BYTE
01C7BE  11                    DB     0x11 ; DATA_BYTE
01C7BF  EA                    DB     0xEA ; DATA_BYTE
01C7C0  7E                    DB     0x7E ; DATA_BYTE
01C7C1  00                    DB     0x00 ; DATA_BYTE
01C7C2  00                    DB     0x00 ; DATA_BYTE
01C7C3  00                    DB     0x00 ; DATA_BYTE
01C7C4  07                    DB     0x07 ; DATA_BYTE
01C7C5  00                    DB     0x00 ; DATA_BYTE
01C7C6  31                    DB     0x31 ; DATA_BYTE
01C7C7  01                    DB     0x01 ; DATA_BYTE
01C7C8  9A                    DB     0x9A ; DATA_BYTE
01C7C9  AB                    DB     0xAB ; DATA_BYTE
01C7CA  0D                    DB     0x0D ; DATA_BYTE
01C7CB  0D                    DB     0x0D ; DATA_BYTE
01C7CC  11                    DB     0x11 ; DATA_BYTE
01C7CD  EA                    DB     0xEA ; DATA_BYTE
01C7CE  CA                    DB     0xCA ; DATA_BYTE
01C7CF  00                    DB     0x00 ; DATA_BYTE
01C7D0  00                    DB     0x00 ; DATA_BYTE
01C7D1  00                    DB     0x00 ; DATA_BYTE
01C7D2  08                    DB     0x08 ; DATA_BYTE
01C7D3  00                    DB     0x00 ; DATA_BYTE
01C7D4  00                    DB     0x00 ; DATA_BYTE
01C7D5  00                    DB     0x00 ; DATA_BYTE
01C7D6  9A                    DB     0x9A ; DATA_BYTE
01C7D7  AB                    DB     0xAB ; DATA_BYTE
01C7D8  0D                    DB     0x0D ; DATA_BYTE
01C7D9  0D                    DB     0x0D ; DATA_BYTE
01C7DA  11                    DB     0x11 ; DATA_BYTE
01C7DB  EA                    DB     0xEA ; DATA_BYTE
01C7DC  58                    DB     0x58 ; DATA_BYTE
01C7DD  01                    DB     0x01 ; DATA_BYTE
01C7DE  00                    DB     0x00 ; DATA_BYTE
01C7DF  00                    DB     0x00 ; DATA_BYTE
01C7E0  08                    DB     0x08 ; DATA_BYTE
01C7E1  00                    DB     0x00 ; DATA_BYTE
01C7E2  00                    DB     0x00 ; DATA_BYTE
01C7E3  00                    DB     0x00 ; DATA_BYTE
01C7E4  9A                    DB     0x9A ; DATA_BYTE
01C7E5  AB                    DB     0xAB ; DATA_BYTE
01C7E6  0D                    DB     0x0D ; DATA_BYTE
01C7E7  0D                    DB     0x0D ; DATA_BYTE
01C7E8  11                    DB     0x11 ; DATA_BYTE
01C7E9  EA                    DB     0xEA ; DATA_BYTE
01C7EA  00                    DB     0x00 ; DATA_BYTE
01C7EB  00                    DB     0x00 ; DATA_BYTE
01C7EC  00                    DB     0x00 ; DATA_BYTE
01C7ED  00                    DB     0x00 ; DATA_BYTE
01C7EE  08                    DB     0x08 ; DATA_BYTE
01C7EF  00                    DB     0x00 ; DATA_BYTE
01C7F0  00                    DB     0x00 ; DATA_BYTE
01C7F1  00                    DB     0x00 ; DATA_BYTE
01C7F2  9A                    DB     0x9A ; DATA_BYTE
01C7F3  AB                    DB     0xAB ; DATA_BYTE
01C7F4  0D                    DB     0x0D ; DATA_BYTE
01C7F5  0D                    DB     0x0D ; DATA_BYTE
01C7F6  11                    DB     0x11 ; DATA_BYTE
01C7F7  EA                    DB     0xEA ; DATA_BYTE
01C7F8  84                    DB     0x84 ; DATA_BYTE
01C7F9  0B                    DB     0x0B ; DATA_BYTE
01C7FA  00                    DB     0x00 ; DATA_BYTE
01C7FB  00                    DB     0x00 ; DATA_BYTE
01C7FC  08                    DB     0x08 ; DATA_BYTE
01C7FD  00                    DB     0x00 ; DATA_BYTE
01C7FE  00                    DB     0x00 ; DATA_BYTE
01C7FF  00                    DB     0x00 ; DATA_BYTE
01C800  9A                    DB     0x9A ; DATA_BYTE
01C801  AB                    DB     0xAB ; DATA_BYTE
01C802  0D                    DB     0x0D ; DATA_BYTE
01C803  0D                    DB     0x0D ; DATA_BYTE
01C804  11                    DB     0x11 ; DATA_BYTE
01C805  EA                    DB     0xEA ; DATA_BYTE
01C806  74                    DB     0x74 ; DATA_BYTE
01C807  0F                    DB     0x0F ; DATA_BYTE
01C808  00                    DB     0x00 ; DATA_BYTE
01C809  00                    DB     0x00 ; DATA_BYTE
01C80A  13                    DB     0x13 ; DATA_BYTE
01C80B  00                    DB     0x00 ; DATA_BYTE
01C80C  9A                    DB     0x9A ; DATA_BYTE
01C80D  AB                    DB     0xAB ; DATA_BYTE
01C80E  0D                    DB     0x0D ; DATA_BYTE
01C80F  0D                    DB     0x0D ; DATA_BYTE
01C810  11                    DB     0x11 ; DATA_BYTE
01C811  EA                    DB     0xEA ; DATA_BYTE
01C812  7A                    DB     0x7A ; DATA_BYTE
01C813  05                    DB     0x05 ; DATA_BYTE
01C814  00                    DB     0x00 ; DATA_BYTE
01C815  00                    DB     0x00 ; DATA_BYTE
01C816  12                    DB     0x12 ; DATA_BYTE
01C817  00                    DB     0x00 ; DATA_BYTE
01C818  00                    DB     0x00 ; DATA_BYTE
01C819  00                    DB     0x00 ; DATA_BYTE
01C81A  9A                    DB     0x9A ; DATA_BYTE
01C81B  AB                    DB     0xAB ; DATA_BYTE
01C81C  0D                    DB     0x0D ; DATA_BYTE
01C81D  0D                    DB     0x0D ; DATA_BYTE
01C81E  11                    DB     0x11 ; DATA_BYTE
01C81F  EA                    DB     0xEA ; DATA_BYTE
01C820  22                    DB     0x22 ; DATA_BYTE
01C821  05                    DB     0x05 ; DATA_BYTE
01C822  00                    DB     0x00 ; DATA_BYTE
01C823  00                    DB     0x00 ; DATA_BYTE
01C824  12                    DB     0x12 ; DATA_BYTE
01C825  00                    DB     0x00 ; DATA_BYTE
01C826  00                    DB     0x00 ; DATA_BYTE
01C827  00                    DB     0x00 ; DATA_BYTE
01C828  9A                    DB     0x9A ; DATA_BYTE
01C829  AB                    DB     0xAB ; DATA_BYTE
01C82A  0D                    DB     0x0D ; DATA_BYTE
01C82B  0D                    DB     0x0D ; DATA_BYTE
01C82C  11                    DB     0x11 ; DATA_BYTE
01C82D  EA                    DB     0xEA ; DATA_BYTE
01C82E  4E                    DB     0x4E ; DATA_BYTE
01C82F  06                    DB     0x06 ; DATA_BYTE
01C830  00                    DB     0x00 ; DATA_BYTE
01C831  00                    DB     0x00 ; DATA_BYTE
01C832  08                    DB     0x08 ; DATA_BYTE
01C833  00                    DB     0x00 ; DATA_BYTE
01C834  38                    DB     0x38 ; DATA_BYTE
01C835  01                    DB     0x01 ; DATA_BYTE
01C836  9A                    DB     0x9A ; DATA_BYTE
01C837  AB                    DB     0xAB ; DATA_BYTE
01C838  0D                    DB     0x0D ; DATA_BYTE
01C839  0D                    DB     0x0D ; DATA_BYTE
01C83A  11                    DB     0x11 ; DATA_BYTE
01C83B  EA                    DB     0xEA ; DATA_BYTE
01C83C  D0                    DB     0xD0 ; DATA_BYTE
01C83D  03                    DB     0x03 ; DATA_BYTE
01C83E  00                    DB     0x00 ; DATA_BYTE
01C83F  00                    DB     0x00 ; DATA_BYTE
01C840  08                    DB     0x08 ; DATA_BYTE
01C841  00                    DB     0x00 ; DATA_BYTE
01C842  38                    DB     0x38 ; DATA_BYTE
01C843  01                    DB     0x01 ; DATA_BYTE
01C844  9A                    DB     0x9A ; DATA_BYTE
01C845  AB                    DB     0xAB ; DATA_BYTE
01C846  0D                    DB     0x0D ; DATA_BYTE
01C847  0D                    DB     0x0D ; DATA_BYTE
01C848  11                    DB     0x11 ; DATA_BYTE
01C849  EA                    DB     0xEA ; DATA_BYTE
01C84A  34                    DB     0x34 ; DATA_BYTE
01C84B  04                    DB     0x04 ; DATA_BYTE
01C84C  00                    DB     0x00 ; DATA_BYTE
01C84D  00                    DB     0x00 ; DATA_BYTE
01C84E  08                    DB     0x08 ; DATA_BYTE
01C84F  00                    DB     0x00 ; DATA_BYTE
01C850  38                    DB     0x38 ; DATA_BYTE
01C851  01                    DB     0x01 ; DATA_BYTE
01C852  9A                    DB     0x9A ; DATA_BYTE
01C853  AB                    DB     0xAB ; DATA_BYTE
01C854  0D                    DB     0x0D ; DATA_BYTE
01C855  0D                    DB     0x0D ; DATA_BYTE
01C856  11                    DB     0x11 ; DATA_BYTE
01C857  EA                    DB     0xEA ; DATA_BYTE
01C858  8E                    DB     0x8E ; DATA_BYTE
01C859  04                    DB     0x04 ; DATA_BYTE
01C85A  00                    DB     0x00 ; DATA_BYTE
01C85B  00                    DB     0x00 ; DATA_BYTE
01C85C  08                    DB     0x08 ; DATA_BYTE
01C85D  00                    DB     0x00 ; DATA_BYTE
01C85E  38                    DB     0x38 ; DATA_BYTE
01C85F  01                    DB     0x01 ; DATA_BYTE
01C860  9A                    DB     0x9A ; DATA_BYTE
01C861  AB                    DB     0xAB ; DATA_BYTE
01C862  0D                    DB     0x0D ; DATA_BYTE
01C863  0D                    DB     0x0D ; DATA_BYTE
01C864  11                    DB     0x11 ; DATA_BYTE
01C865  EA                    DB     0xEA ; DATA_BYTE
01C866  B6                    DB     0xB6 ; DATA_BYTE
01C867  06                    DB     0x06 ; DATA_BYTE
01C868  00                    DB     0x00 ; DATA_BYTE
01C869  00                    DB     0x00 ; DATA_BYTE
01C86A  08                    DB     0x08 ; DATA_BYTE
01C86B  00                    DB     0x00 ; DATA_BYTE
01C86C  C7                    DB     0xC7 ; DATA_BYTE
01C86D  01                    DB     0x01 ; DATA_BYTE
01C86E  9A                    DB     0x9A ; DATA_BYTE
01C86F  AB                    DB     0xAB ; DATA_BYTE
01C870  0D                    DB     0x0D ; DATA_BYTE
01C871  0D                    DB     0x0D ; DATA_BYTE
01C872  11                    DB     0x11 ; DATA_BYTE
01C873  EA                    DB     0xEA ; DATA_BYTE
01C874  06                    DB     0x06 ; DATA_BYTE
01C875  09                    DB     0x09 ; DATA_BYTE
01C876  00                    DB     0x00 ; DATA_BYTE
01C877  00                    DB     0x00 ; DATA_BYTE
01C878  13                    DB     0x13 ; DATA_BYTE
01C879  00                    DB     0x00 ; DATA_BYTE
01C87A  9A                    DB     0x9A ; DATA_BYTE
01C87B  AB                    DB     0xAB ; DATA_BYTE
01C87C  0D                    DB     0x0D ; DATA_BYTE
01C87D  0D                    DB     0x0D ; DATA_BYTE
01C87E  11                    DB     0x11 ; DATA_BYTE
01C87F  EA                    DB     0xEA ; DATA_BYTE
01C880  AA                    DB     0xAA ; DATA_BYTE
01C881  01                    DB     0x01 ; DATA_BYTE
01C882  00                    DB     0x00 ; DATA_BYTE
01C883  00                    DB     0x00 ; DATA_BYTE
01C884  09                    DB     0x09 ; DATA_BYTE
01C885  00                    DB     0x00 ; DATA_BYTE
01C886  9A                    DB     0x9A ; DATA_BYTE
01C887  AB                    DB     0xAB ; DATA_BYTE
01C888  0D                    DB     0x0D ; DATA_BYTE
01C889  0D                    DB     0x0D ; DATA_BYTE
01C88A  11                    DB     0x11 ; DATA_BYTE
01C88B  EA                    DB     0xEA ; DATA_BYTE
01C88C  00                    DB     0x00 ; DATA_BYTE
01C88D  00                    DB     0x00 ; DATA_BYTE
01C88E  00                    DB     0x00 ; DATA_BYTE
01C88F  00                    DB     0x00 ; DATA_BYTE
01C890  09                    DB     0x09 ; DATA_BYTE
01C891  00                    DB     0x00 ; DATA_BYTE
01C892  9A                    DB     0x9A ; DATA_BYTE
01C893  AB                    DB     0xAB ; DATA_BYTE
01C894  0D                    DB     0x0D ; DATA_BYTE
01C895  0D                    DB     0x0D ; DATA_BYTE
01C896  11                    DB     0x11 ; DATA_BYTE
01C897  EA                    DB     0xEA ; DATA_BYTE
01C898  86                    DB     0x86 ; DATA_BYTE
01C899  03                    DB     0x03 ; DATA_BYTE
01C89A  00                    DB     0x00 ; DATA_BYTE
01C89B  00                    DB     0x00 ; DATA_BYTE
01C89C  09                    DB     0x09 ; DATA_BYTE
01C89D  00                    DB     0x00 ; DATA_BYTE
01C89E  9A                    DB     0x9A ; DATA_BYTE
01C89F  AB                    DB     0xAB ; DATA_BYTE
01C8A0  0D                    DB     0x0D ; DATA_BYTE
01C8A1  0D                    DB     0x0D ; DATA_BYTE
01C8A2  11                    DB     0x11 ; DATA_BYTE
01C8A3  EA                    DB     0xEA ; DATA_BYTE
01C8A4  86                    DB     0x86 ; DATA_BYTE
01C8A5  00                    DB     0x00 ; DATA_BYTE
01C8A6  00                    DB     0x00 ; DATA_BYTE
01C8A7  00                    DB     0x00 ; DATA_BYTE
01C8A8  09                    DB     0x09 ; DATA_BYTE
01C8A9  00                    DB     0x00 ; DATA_BYTE
01C8AA  9A                    DB     0x9A ; DATA_BYTE
01C8AB  AB                    DB     0xAB ; DATA_BYTE
01C8AC  0D                    DB     0x0D ; DATA_BYTE
01C8AD  0D                    DB     0x0D ; DATA_BYTE
01C8AE  11                    DB     0x11 ; DATA_BYTE
01C8AF  EA                    DB     0xEA ; DATA_BYTE
01C8B0  9C                    DB     0x9C ; DATA_BYTE
01C8B1  00                    DB     0x00 ; DATA_BYTE
01C8B2  00                    DB     0x00 ; DATA_BYTE
01C8B3  00                    DB     0x00 ; DATA_BYTE
01C8B4  09                    DB     0x09 ; DATA_BYTE
01C8B5  00                    DB     0x00 ; DATA_BYTE
01C8B6  9A                    DB     0x9A ; DATA_BYTE
01C8B7  AB                    DB     0xAB ; DATA_BYTE
01C8B8  0D                    DB     0x0D ; DATA_BYTE
01C8B9  0D                    DB     0x0D ; DATA_BYTE
01C8BA  11                    DB     0x11 ; DATA_BYTE
01C8BB  EA                    DB     0xEA ; DATA_BYTE
01C8BC  F6                    DB     0xF6 ; DATA_BYTE
01C8BD  00                    DB     0x00 ; DATA_BYTE
01C8BE  00                    DB     0x00 ; DATA_BYTE
01C8BF  00                    DB     0x00 ; DATA_BYTE
01C8C0  09                    DB     0x09 ; DATA_BYTE
01C8C1  00                    DB     0x00 ; DATA_BYTE
01C8C2  9A                    DB     0x9A ; DATA_BYTE
01C8C3  AB                    DB     0xAB ; DATA_BYTE
01C8C4  0D                    DB     0x0D ; DATA_BYTE
01C8C5  0D                    DB     0x0D ; DATA_BYTE
01C8C6  11                    DB     0x11 ; DATA_BYTE
01C8C7  EA                    DB     0xEA ; DATA_BYTE
01C8C8  F6                    DB     0xF6 ; DATA_BYTE
01C8C9  02                    DB     0x02 ; DATA_BYTE
01C8CA  00                    DB     0x00 ; DATA_BYTE
01C8CB  00                    DB     0x00 ; DATA_BYTE
01C8CC  0A                    DB     0x0A ; DATA_BYTE
01C8CD  00                    DB     0x00 ; DATA_BYTE
01C8CE  9A                    DB     0x9A ; DATA_BYTE
01C8CF  AB                    DB     0xAB ; DATA_BYTE
01C8D0  0D                    DB     0x0D ; DATA_BYTE
01C8D1  0D                    DB     0x0D ; DATA_BYTE
01C8D2  11                    DB     0x11 ; DATA_BYTE
01C8D3  EA                    DB     0xEA ; DATA_BYTE
01C8D4  16                    DB     0x16 ; DATA_BYTE
01C8D5  00                    DB     0x00 ; DATA_BYTE
01C8D6  00                    DB     0x00 ; DATA_BYTE
01C8D7  00                    DB     0x00 ; DATA_BYTE
01C8D8  0A                    DB     0x0A ; DATA_BYTE
01C8D9  00                    DB     0x00 ; DATA_BYTE
01C8DA  9A                    DB     0x9A ; DATA_BYTE
01C8DB  AB                    DB     0xAB ; DATA_BYTE
01C8DC  0D                    DB     0x0D ; DATA_BYTE
01C8DD  0D                    DB     0x0D ; DATA_BYTE
01C8DE  11                    DB     0x11 ; DATA_BYTE
01C8DF  EA                    DB     0xEA ; DATA_BYTE
01C8E0  64                    DB     0x64 ; DATA_BYTE
01C8E1  0A                    DB     0x0A ; DATA_BYTE
01C8E2  00                    DB     0x00 ; DATA_BYTE
01C8E3  00                    DB     0x00 ; DATA_BYTE
01C8E4  0A                    DB     0x0A ; DATA_BYTE
01C8E5  00                    DB     0x00 ; DATA_BYTE
01C8E6  9A                    DB     0x9A ; DATA_BYTE
01C8E7  AB                    DB     0xAB ; DATA_BYTE
01C8E8  0D                    DB     0x0D ; DATA_BYTE
01C8E9  0D                    DB     0x0D ; DATA_BYTE
01C8EA  11                    DB     0x11 ; DATA_BYTE
01C8EB  EA                    DB     0xEA ; DATA_BYTE
01C8EC  3E                    DB     0x3E ; DATA_BYTE
01C8ED  04                    DB     0x04 ; DATA_BYTE
01C8EE  00                    DB     0x00 ; DATA_BYTE
01C8EF  00                    DB     0x00 ; DATA_BYTE
01C8F0  0A                    DB     0x0A ; DATA_BYTE
01C8F1  00                    DB     0x00 ; DATA_BYTE
01C8F2  9A                    DB     0x9A ; DATA_BYTE
01C8F3  AB                    DB     0xAB ; DATA_BYTE
01C8F4  0D                    DB     0x0D ; DATA_BYTE
01C8F5  0D                    DB     0x0D ; DATA_BYTE
01C8F6  11                    DB     0x11 ; DATA_BYTE
01C8F7  EA                    DB     0xEA ; DATA_BYTE
01C8F8  84                    DB     0x84 ; DATA_BYTE
01C8F9  04                    DB     0x04 ; DATA_BYTE
01C8FA  00                    DB     0x00 ; DATA_BYTE
01C8FB  00                    DB     0x00 ; DATA_BYTE
01C8FC  0A                    DB     0x0A ; DATA_BYTE
01C8FD  00                    DB     0x00 ; DATA_BYTE
01C8FE  9A                    DB     0x9A ; DATA_BYTE
01C8FF  AB                    DB     0xAB ; DATA_BYTE
01C900  0D                    DB     0x0D ; DATA_BYTE
01C901  0D                    DB     0x0D ; DATA_BYTE
01C902  11                    DB     0x11 ; DATA_BYTE
01C903  EA                    DB     0xEA ; DATA_BYTE
01C904  AE                    DB     0xAE ; DATA_BYTE
01C905  00                    DB     0x00 ; DATA_BYTE
01C906  00                    DB     0x00 ; DATA_BYTE
01C907  00                    DB     0x00 ; DATA_BYTE
01C908  0A                    DB     0x0A ; DATA_BYTE
01C909  00                    DB     0x00 ; DATA_BYTE
01C90A  9A                    DB     0x9A ; DATA_BYTE
01C90B  AB                    DB     0xAB ; DATA_BYTE
01C90C  0D                    DB     0x0D ; DATA_BYTE
01C90D  0D                    DB     0x0D ; DATA_BYTE
01C90E  11                    DB     0x11 ; DATA_BYTE
01C90F  EA                    DB     0xEA ; DATA_BYTE
01C910  3A                    DB     0x3A ; DATA_BYTE
01C911  06                    DB     0x06 ; DATA_BYTE
01C912  00                    DB     0x00 ; DATA_BYTE
01C913  00                    DB     0x00 ; DATA_BYTE
01C914  0A                    DB     0x0A ; DATA_BYTE
01C915  00                    DB     0x00 ; DATA_BYTE
01C916  9A                    DB     0x9A ; DATA_BYTE
01C917  AB                    DB     0xAB ; DATA_BYTE
01C918  0D                    DB     0x0D ; DATA_BYTE
01C919  0D                    DB     0x0D ; DATA_BYTE
01C91A  11                    DB     0x11 ; DATA_BYTE
01C91B  EA                    DB     0xEA ; DATA_BYTE
01C91C  7A                    DB     0x7A ; DATA_BYTE
01C91D  0B                    DB     0x0B ; DATA_BYTE
01C91E  00                    DB     0x00 ; DATA_BYTE
01C91F  00                    DB     0x00 ; DATA_BYTE
01C920  0A                    DB     0x0A ; DATA_BYTE
01C921  00                    DB     0x00 ; DATA_BYTE
01C922  9A                    DB     0x9A ; DATA_BYTE
01C923  AB                    DB     0xAB ; DATA_BYTE
01C924  0D                    DB     0x0D ; DATA_BYTE
01C925  0D                    DB     0x0D ; DATA_BYTE
01C926  11                    DB     0x11 ; DATA_BYTE
01C927  EA                    DB     0xEA ; DATA_BYTE
01C928  04                    DB     0x04 ; DATA_BYTE
01C929  01                    DB     0x01 ; DATA_BYTE
01C92A  00                    DB     0x00 ; DATA_BYTE
01C92B  00                    DB     0x00 ; DATA_BYTE
01C92C  0A                    DB     0x0A ; DATA_BYTE
01C92D  00                    DB     0x00 ; DATA_BYTE
01C92E  9A                    DB     0x9A ; DATA_BYTE
01C92F  AB                    DB     0xAB ; DATA_BYTE
01C930  0D                    DB     0x0D ; DATA_BYTE
01C931  0D                    DB     0x0D ; DATA_BYTE
01C932  11                    DB     0x11 ; DATA_BYTE
01C933  EA                    DB     0xEA ; DATA_BYTE
01C934  D6                    DB     0xD6 ; DATA_BYTE
01C935  07                    DB     0x07 ; DATA_BYTE
01C936  00                    DB     0x00 ; DATA_BYTE
01C937  00                    DB     0x00 ; DATA_BYTE
01C938  0A                    DB     0x0A ; DATA_BYTE
01C939  00                    DB     0x00 ; DATA_BYTE
01C93A  9A                    DB     0x9A ; DATA_BYTE
01C93B  AB                    DB     0xAB ; DATA_BYTE
01C93C  0D                    DB     0x0D ; DATA_BYTE
01C93D  0D                    DB     0x0D ; DATA_BYTE
01C93E  11                    DB     0x11 ; DATA_BYTE
01C93F  EA                    DB     0xEA ; DATA_BYTE
01C940  3E                    DB     0x3E ; DATA_BYTE
01C941  02                    DB     0x02 ; DATA_BYTE
01C942  00                    DB     0x00 ; DATA_BYTE
01C943  00                    DB     0x00 ; DATA_BYTE
01C944  0A                    DB     0x0A ; DATA_BYTE
01C945  00                    DB     0x00 ; DATA_BYTE
01C946  9A                    DB     0x9A ; DATA_BYTE
01C947  AB                    DB     0xAB ; DATA_BYTE
01C948  0D                    DB     0x0D ; DATA_BYTE
01C949  0D                    DB     0x0D ; DATA_BYTE
01C94A  11                    DB     0x11 ; DATA_BYTE
01C94B  EA                    DB     0xEA ; DATA_BYTE
01C94C  9E                    DB     0x9E ; DATA_BYTE
01C94D  00                    DB     0x00 ; DATA_BYTE
01C94E  00                    DB     0x00 ; DATA_BYTE
01C94F  00                    DB     0x00 ; DATA_BYTE
01C950  1F                    DB     0x1F ; DATA_BYTE
01C951  00                    DB     0x00 ; DATA_BYTE
01C952  4F                    DB     0x4F ; DATA_BYTE
01C953  00                    DB     0x00 ; DATA_BYTE
01C954  9A                    DB     0x9A ; DATA_BYTE
01C955  AB                    DB     0xAB ; DATA_BYTE
01C956  0D                    DB     0x0D ; DATA_BYTE
01C957  0D                    DB     0x0D ; DATA_BYTE
01C958  11                    DB     0x11 ; DATA_BYTE
01C959  EA                    DB     0xEA ; DATA_BYTE
01C95A  00                    DB     0x00 ; DATA_BYTE
01C95B  00                    DB     0x00 ; DATA_BYTE
01C95C  00                    DB     0x00 ; DATA_BYTE
01C95D  00                    DB     0x00 ; DATA_BYTE
01C95E  1F                    DB     0x1F ; DATA_BYTE
01C95F  00                    DB     0x00 ; DATA_BYTE
01C960  00                    DB     0x00 ; DATA_BYTE
01C961  00                    DB     0x00 ; DATA_BYTE
01C962  9A                    DB     0x9A ; DATA_BYTE
01C963  AB                    DB     0xAB ; DATA_BYTE
01C964  0D                    DB     0x0D ; DATA_BYTE
01C965  0D                    DB     0x0D ; DATA_BYTE
01C966  11                    DB     0x11 ; DATA_BYTE
01C967  EA                    DB     0xEA ; DATA_BYTE
01C968  02                    DB     0x02 ; DATA_BYTE
01C969  00                    DB     0x00 ; DATA_BYTE
01C96A  00                    DB     0x00 ; DATA_BYTE
01C96B  00                    DB     0x00 ; DATA_BYTE
01C96C  1B                    DB     0x1B ; DATA_BYTE
01C96D  00                    DB     0x00 ; DATA_BYTE
01C96E  17                    DB     0x17 ; DATA_BYTE
01C96F  00                    DB     0x00 ; DATA_BYTE
01C970  9A                    DB     0x9A ; DATA_BYTE
01C971  91                    DB     0x91 ; DATA_BYTE
01C972  0D                    DB     0x0D ; DATA_BYTE
01C973  0D                    DB     0x0D ; DATA_BYTE
01C974  11                    DB     0x11 ; DATA_BYTE
01C975  EA                    DB     0xEA ; DATA_BYTE
01C976  0C                    DB     0x0C ; DATA_BYTE
01C977  00                    DB     0x00 ; DATA_BYTE
01C978  EA                    DB     0xEA ; DATA_BYTE
01C979  0A                    DB     0x0A ; DATA_BYTE
01C97A  9A                    DB     0x9A ; DATA_BYTE
01C97B  AB                    DB     0xAB ; DATA_BYTE
01C97C  0D                    DB     0x0D ; DATA_BYTE
01C97D  0D                    DB     0x0D ; DATA_BYTE
01C97E  11                    DB     0x11 ; DATA_BYTE
01C97F  EA                    DB     0xEA ; DATA_BYTE
01C980  BE                    DB     0xBE ; DATA_BYTE
01C981  00                    DB     0x00 ; DATA_BYTE
01C982  00                    DB     0x00 ; DATA_BYTE
01C983  00                    DB     0x00 ; DATA_BYTE
01C984  1F                    DB     0x1F ; DATA_BYTE
01C985  00                    DB     0x00 ; DATA_BYTE
01C986  00                    DB     0x00 ; DATA_BYTE
01C987  00                    DB     0x00 ; DATA_BYTE
01C988  9A                    DB     0x9A ; DATA_BYTE
01C989  AB                    DB     0xAB ; DATA_BYTE
01C98A  0D                    DB     0x0D ; DATA_BYTE
01C98B  0D                    DB     0x0D ; DATA_BYTE
01C98C  11                    DB     0x11 ; DATA_BYTE
01C98D  EA                    DB     0xEA ; DATA_BYTE
01C98E  00                    DB     0x00 ; DATA_BYTE
01C98F  00                    DB     0x00 ; DATA_BYTE
01C990  00                    DB     0x00 ; DATA_BYTE
01C991  00                    DB     0x00 ; DATA_BYTE
01C992  0B                    DB     0x0B ; DATA_BYTE
01C993  00                    DB     0x00 ; DATA_BYTE
01C994  9A                    DB     0x9A ; DATA_BYTE
01C995  AB                    DB     0xAB ; DATA_BYTE
01C996  0D                    DB     0x0D ; DATA_BYTE
01C997  0D                    DB     0x0D ; DATA_BYTE
01C998  11                    DB     0x11 ; DATA_BYTE
01C999  EA                    DB     0xEA ; DATA_BYTE
01C99A  C4                    DB     0xC4 ; DATA_BYTE
01C99B  1E                    DB     0x1E ; DATA_BYTE
01C99C  00                    DB     0x00 ; DATA_BYTE
01C99D  00                    DB     0x00 ; DATA_BYTE
01C99E  0C                    DB     0x0C ; DATA_BYTE
01C99F  00                    DB     0x00 ; DATA_BYTE
01C9A0  9A                    DB     0x9A ; DATA_BYTE
01C9A1  AB                    DB     0xAB ; DATA_BYTE
01C9A2  0D                    DB     0x0D ; DATA_BYTE
01C9A3  0D                    DB     0x0D ; DATA_BYTE
01C9A4  11                    DB     0x11 ; DATA_BYTE
01C9A5  EA                    DB     0xEA ; DATA_BYTE
01C9A6  16                    DB     0x16 ; DATA_BYTE
01C9A7  18                    DB     0x18 ; DATA_BYTE
01C9A8  00                    DB     0x00 ; DATA_BYTE
01C9A9  00                    DB     0x00 ; DATA_BYTE
01C9AA  0C                    DB     0x0C ; DATA_BYTE
01C9AB  00                    DB     0x00 ; DATA_BYTE
01C9AC  9A                    DB     0x9A ; DATA_BYTE
01C9AD  AB                    DB     0xAB ; DATA_BYTE
01C9AE  0D                    DB     0x0D ; DATA_BYTE
01C9AF  0D                    DB     0x0D ; DATA_BYTE
01C9B0  11                    DB     0x11 ; DATA_BYTE
01C9B1  EA                    DB     0xEA ; DATA_BYTE
01C9B2  FE                    DB     0xFE ; DATA_BYTE
01C9B3  14                    DB     0x14 ; DATA_BYTE
01C9B4  00                    DB     0x00 ; DATA_BYTE
01C9B5  00                    DB     0x00 ; DATA_BYTE
01C9B6  0C                    DB     0x0C ; DATA_BYTE
01C9B7  00                    DB     0x00 ; DATA_BYTE
01C9B8  9A                    DB     0x9A ; DATA_BYTE
01C9B9  AB                    DB     0xAB ; DATA_BYTE
01C9BA  0D                    DB     0x0D ; DATA_BYTE
01C9BB  0D                    DB     0x0D ; DATA_BYTE
01C9BC  11                    DB     0x11 ; DATA_BYTE
01C9BD  EA                    DB     0xEA ; DATA_BYTE
01C9BE  7E                    DB     0x7E ; DATA_BYTE
01C9BF  41                    DB     0x41 ; DATA_BYTE
01C9C0  00                    DB     0x00 ; DATA_BYTE
01C9C1  00                    DB     0x00 ; DATA_BYTE
01C9C2  0C                    DB     0x0C ; DATA_BYTE
01C9C3  00                    DB     0x00 ; DATA_BYTE
01C9C4  9A                    DB     0x9A ; DATA_BYTE
01C9C5  AB                    DB     0xAB ; DATA_BYTE
01C9C6  0D                    DB     0x0D ; DATA_BYTE
01C9C7  0D                    DB     0x0D ; DATA_BYTE
01C9C8  11                    DB     0x11 ; DATA_BYTE
01C9C9  EA                    DB     0xEA ; DATA_BYTE
01C9CA  1A                    DB     0x1A ; DATA_BYTE
01C9CB  02                    DB     0x02 ; DATA_BYTE
01C9CC  00                    DB     0x00 ; DATA_BYTE
01C9CD  00                    DB     0x00 ; DATA_BYTE
01C9CE  0C                    DB     0x0C ; DATA_BYTE
01C9CF  00                    DB     0x00 ; DATA_BYTE
01C9D0  9A                    DB     0x9A ; DATA_BYTE
01C9D1  AB                    DB     0xAB ; DATA_BYTE
01C9D2  0D                    DB     0x0D ; DATA_BYTE
01C9D3  0D                    DB     0x0D ; DATA_BYTE
01C9D4  11                    DB     0x11 ; DATA_BYTE
01C9D5  EA                    DB     0xEA ; DATA_BYTE
01C9D6  2E                    DB     0x2E ; DATA_BYTE
01C9D7  15                    DB     0x15 ; DATA_BYTE
01C9D8  00                    DB     0x00 ; DATA_BYTE
01C9D9  00                    DB     0x00 ; DATA_BYTE
01C9DA  0C                    DB     0x0C ; DATA_BYTE
01C9DB  00                    DB     0x00 ; DATA_BYTE
01C9DC  9A                    DB     0x9A ; DATA_BYTE
01C9DD  AB                    DB     0xAB ; DATA_BYTE
01C9DE  0D                    DB     0x0D ; DATA_BYTE
01C9DF  0D                    DB     0x0D ; DATA_BYTE
01C9E0  11                    DB     0x11 ; DATA_BYTE
01C9E1  EA                    DB     0xEA ; DATA_BYTE
01C9E2  5A                    DB     0x5A ; DATA_BYTE
01C9E3  1C                    DB     0x1C ; DATA_BYTE
01C9E4  00                    DB     0x00 ; DATA_BYTE
01C9E5  00                    DB     0x00 ; DATA_BYTE
01C9E6  0C                    DB     0x0C ; DATA_BYTE
01C9E7  00                    DB     0x00 ; DATA_BYTE
01C9E8  9A                    DB     0x9A ; DATA_BYTE
01C9E9  AB                    DB     0xAB ; DATA_BYTE
01C9EA  0D                    DB     0x0D ; DATA_BYTE
01C9EB  0D                    DB     0x0D ; DATA_BYTE
01C9EC  11                    DB     0x11 ; DATA_BYTE
01C9ED  EA                    DB     0xEA ; DATA_BYTE
01C9EE  9C                    DB     0x9C ; DATA_BYTE
01C9EF  35                    DB     0x35 ; DATA_BYTE
01C9F0  00                    DB     0x00 ; DATA_BYTE
01C9F1  00                    DB     0x00 ; DATA_BYTE
01C9F2  0C                    DB     0x0C ; DATA_BYTE
01C9F3  00                    DB     0x00 ; DATA_BYTE
01C9F4  9A                    DB     0x9A ; DATA_BYTE
01C9F5  AB                    DB     0xAB ; DATA_BYTE
01C9F6  0D                    DB     0x0D ; DATA_BYTE
01C9F7  0D                    DB     0x0D ; DATA_BYTE
01C9F8  11                    DB     0x11 ; DATA_BYTE
01C9F9  EA                    DB     0xEA ; DATA_BYTE
01C9FA  20                    DB     0x20 ; DATA_BYTE
01C9FB  3E                    DB     0x3E ; DATA_BYTE
01C9FC  00                    DB     0x00 ; DATA_BYTE
01C9FD  00                    DB     0x00 ; DATA_BYTE
01C9FE  0C                    DB     0x0C ; DATA_BYTE
01C9FF  00                    DB     0x00 ; DATA_BYTE
01CA00  9A                    DB     0x9A ; DATA_BYTE
01CA01  AB                    DB     0xAB ; DATA_BYTE
01CA02  0D                    DB     0x0D ; DATA_BYTE
01CA03  0D                    DB     0x0D ; DATA_BYTE
01CA04  11                    DB     0x11 ; DATA_BYTE
01CA05  EA                    DB     0xEA ; DATA_BYTE
01CA06  00                    DB     0x00 ; DATA_BYTE
01CA07  00                    DB     0x00 ; DATA_BYTE
01CA08  00                    DB     0x00 ; DATA_BYTE
01CA09  00                    DB     0x00 ; DATA_BYTE
01CA0A  0C                    DB     0x0C ; DATA_BYTE
01CA0B  00                    DB     0x00 ; DATA_BYTE
01CA0C  9A                    DB     0x9A ; DATA_BYTE
01CA0D  AB                    DB     0xAB ; DATA_BYTE
01CA0E  0D                    DB     0x0D ; DATA_BYTE
01CA0F  0D                    DB     0x0D ; DATA_BYTE
01CA10  11                    DB     0x11 ; DATA_BYTE
01CA11  EA                    DB     0xEA ; DATA_BYTE
01CA12  EA                    DB     0xEA ; DATA_BYTE
01CA13  39                    DB     0x39 ; DATA_BYTE
01CA14  00                    DB     0x00 ; DATA_BYTE
01CA15  00                    DB     0x00 ; DATA_BYTE
01CA16  0C                    DB     0x0C ; DATA_BYTE
01CA17  00                    DB     0x00 ; DATA_BYTE
01CA18  9A                    DB     0x9A ; DATA_BYTE
01CA19  AB                    DB     0xAB ; DATA_BYTE
01CA1A  0D                    DB     0x0D ; DATA_BYTE
01CA1B  0D                    DB     0x0D ; DATA_BYTE
01CA1C  11                    DB     0x11 ; DATA_BYTE
01CA1D  EA                    DB     0xEA ; DATA_BYTE
01CA1E  46                    DB     0x46 ; DATA_BYTE
01CA1F  36                    DB     0x36 ; DATA_BYTE
01CA20  00                    DB     0x00 ; DATA_BYTE
01CA21  00                    DB     0x00 ; DATA_BYTE
01CA22  0C                    DB     0x0C ; DATA_BYTE
01CA23  00                    DB     0x00 ; DATA_BYTE
01CA24  9A                    DB     0x9A ; DATA_BYTE
01CA25  AB                    DB     0xAB ; DATA_BYTE
01CA26  0D                    DB     0x0D ; DATA_BYTE
01CA27  0D                    DB     0x0D ; DATA_BYTE
01CA28  11                    DB     0x11 ; DATA_BYTE
01CA29  EA                    DB     0xEA ; DATA_BYTE
01CA2A  54                    DB     0x54 ; DATA_BYTE
01CA2B  21                    DB     0x21 ; DATA_BYTE
01CA2C  00                    DB     0x00 ; DATA_BYTE
01CA2D  00                    DB     0x00 ; DATA_BYTE
01CA2E  0C                    DB     0x0C ; DATA_BYTE
01CA2F  00                    DB     0x00 ; DATA_BYTE
01CA30  9A                    DB     0x9A ; DATA_BYTE
01CA31  AB                    DB     0xAB ; DATA_BYTE
01CA32  0D                    DB     0x0D ; DATA_BYTE
01CA33  0D                    DB     0x0D ; DATA_BYTE
01CA34  11                    DB     0x11 ; DATA_BYTE
01CA35  EA                    DB     0xEA ; DATA_BYTE
01CA36  38                    DB     0x38 ; DATA_BYTE
01CA37  00                    DB     0x00 ; DATA_BYTE
01CA38  00                    DB     0x00 ; DATA_BYTE
01CA39  00                    DB     0x00 ; DATA_BYTE
01CA3A  0C                    DB     0x0C ; DATA_BYTE
01CA3B  00                    DB     0x00 ; DATA_BYTE
01CA3C  9A                    DB     0x9A ; DATA_BYTE
01CA3D  AB                    DB     0xAB ; DATA_BYTE
01CA3E  0D                    DB     0x0D ; DATA_BYTE
01CA3F  0D                    DB     0x0D ; DATA_BYTE
01CA40  11                    DB     0x11 ; DATA_BYTE
01CA41  EA                    DB     0xEA ; DATA_BYTE
01CA42  20                    DB     0x20 ; DATA_BYTE
01CA43  28                    DB     0x28 ; DATA_BYTE
01CA44  00                    DB     0x00 ; DATA_BYTE
01CA45  00                    DB     0x00 ; DATA_BYTE
01CA46  0C                    DB     0x0C ; DATA_BYTE
01CA47  00                    DB     0x00 ; DATA_BYTE
01CA48  9A                    DB     0x9A ; DATA_BYTE
01CA49  AB                    DB     0xAB ; DATA_BYTE
01CA4A  0D                    DB     0x0D ; DATA_BYTE
01CA4B  0D                    DB     0x0D ; DATA_BYTE
01CA4C  11                    DB     0x11 ; DATA_BYTE
01CA4D  EA                    DB     0xEA ; DATA_BYTE
01CA4E  00                    DB     0x00 ; DATA_BYTE
01CA4F  00                    DB     0x00 ; DATA_BYTE
01CA50  00                    DB     0x00 ; DATA_BYTE
01CA51  00                    DB     0x00 ; DATA_BYTE
01CA52  10                    DB     0x10 ; DATA_BYTE
01CA53  00                    DB     0x00 ; DATA_BYTE
01CA54  9A                    DB     0x9A ; DATA_BYTE
01CA55  AB                    DB     0xAB ; DATA_BYTE
01CA56  0D                    DB     0x0D ; DATA_BYTE
01CA57  0D                    DB     0x0D ; DATA_BYTE
01CA58  11                    DB     0x11 ; DATA_BYTE
01CA59  EA                    DB     0xEA ; DATA_BYTE
01CA5A  56                    DB     0x56 ; DATA_BYTE
01CA5B  06                    DB     0x06 ; DATA_BYTE
01CA5C  00                    DB     0x00 ; DATA_BYTE
01CA5D  00                    DB     0x00 ; DATA_BYTE
01CA5E  0D                    DB     0x0D ; DATA_BYTE
01CA5F  00                    DB     0x00 ; DATA_BYTE
01CA60  9A                    DB     0x9A ; DATA_BYTE
01CA61  AB                    DB     0xAB ; DATA_BYTE
01CA62  0D                    DB     0x0D ; DATA_BYTE
01CA63  0D                    DB     0x0D ; DATA_BYTE
01CA64  11                    DB     0x11 ; DATA_BYTE
01CA65  EA                    DB     0xEA ; DATA_BYTE
01CA66  6A                    DB     0x6A ; DATA_BYTE
01CA67  01                    DB     0x01 ; DATA_BYTE
01CA68  00                    DB     0x00 ; DATA_BYTE
01CA69  00                    DB     0x00 ; DATA_BYTE
01CA6A  0D                    DB     0x0D ; DATA_BYTE
01CA6B  00                    DB     0x00 ; DATA_BYTE
01CA6C  9A                    DB     0x9A ; DATA_BYTE
01CA6D  AB                    DB     0xAB ; DATA_BYTE
01CA6E  0D                    DB     0x0D ; DATA_BYTE
01CA6F  0D                    DB     0x0D ; DATA_BYTE
01CA70  11                    DB     0x11 ; DATA_BYTE
01CA71  EA                    DB     0xEA ; DATA_BYTE
01CA72  06                    DB     0x06 ; DATA_BYTE
01CA73  09                    DB     0x09 ; DATA_BYTE
01CA74  00                    DB     0x00 ; DATA_BYTE
01CA75  00                    DB     0x00 ; DATA_BYTE
01CA76  0D                    DB     0x0D ; DATA_BYTE
01CA77  00                    DB     0x00 ; DATA_BYTE
01CA78  9A                    DB     0x9A ; DATA_BYTE
01CA79  AB                    DB     0xAB ; DATA_BYTE
01CA7A  0D                    DB     0x0D ; DATA_BYTE
01CA7B  0D                    DB     0x0D ; DATA_BYTE
01CA7C  11                    DB     0x11 ; DATA_BYTE
01CA7D  EA                    DB     0xEA ; DATA_BYTE
01CA7E  66                    DB     0x66 ; DATA_BYTE
01CA7F  5B                    DB     0x5B ; DATA_BYTE
01CA80  00                    DB     0x00 ; DATA_BYTE
01CA81  00                    DB     0x00 ; DATA_BYTE
01CA82  0D                    DB     0x0D ; DATA_BYTE
01CA83  00                    DB     0x00 ; DATA_BYTE
01CA84  9A                    DB     0x9A ; DATA_BYTE
01CA85  AB                    DB     0xAB ; DATA_BYTE
01CA86  0D                    DB     0x0D ; DATA_BYTE
01CA87  0D                    DB     0x0D ; DATA_BYTE
01CA88  11                    DB     0x11 ; DATA_BYTE
01CA89  EA                    DB     0xEA ; DATA_BYTE
01CA8A  D0                    DB     0xD0 ; DATA_BYTE
01CA8B  03                    DB     0x03 ; DATA_BYTE
01CA8C  00                    DB     0x00 ; DATA_BYTE
01CA8D  00                    DB     0x00 ; DATA_BYTE
01CA8E  0D                    DB     0x0D ; DATA_BYTE
01CA8F  00                    DB     0x00 ; DATA_BYTE
01CA90  9A                    DB     0x9A ; DATA_BYTE
01CA91  AB                    DB     0xAB ; DATA_BYTE
01CA92  0D                    DB     0x0D ; DATA_BYTE
01CA93  0D                    DB     0x0D ; DATA_BYTE
01CA94  11                    DB     0x11 ; DATA_BYTE
01CA95  EA                    DB     0xEA ; DATA_BYTE
01CA96  00                    DB     0x00 ; DATA_BYTE
01CA97  00                    DB     0x00 ; DATA_BYTE
01CA98  00                    DB     0x00 ; DATA_BYTE
01CA99  00                    DB     0x00 ; DATA_BYTE
01CA9A  0D                    DB     0x0D ; DATA_BYTE
01CA9B  00                    DB     0x00 ; DATA_BYTE
01CA9C  9A                    DB     0x9A ; DATA_BYTE
01CA9D  AB                    DB     0xAB ; DATA_BYTE
01CA9E  0D                    DB     0x0D ; DATA_BYTE
01CA9F  0D                    DB     0x0D ; DATA_BYTE
01CAA0  11                    DB     0x11 ; DATA_BYTE
01CAA1  EA                    DB     0xEA ; DATA_BYTE
01CAA2  AE                    DB     0xAE ; DATA_BYTE
01CAA3  06                    DB     0x06 ; DATA_BYTE
01CAA4  00                    DB     0x00 ; DATA_BYTE
01CAA5  00                    DB     0x00 ; DATA_BYTE
01CAA6  0D                    DB     0x0D ; DATA_BYTE
01CAA7  00                    DB     0x00 ; DATA_BYTE
01CAA8  9A                    DB     0x9A ; DATA_BYTE
01CAA9  AB                    DB     0xAB ; DATA_BYTE
01CAAA  0D                    DB     0x0D ; DATA_BYTE
01CAAB  0D                    DB     0x0D ; DATA_BYTE
01CAAC  11                    DB     0x11 ; DATA_BYTE
01CAAD  EA                    DB     0xEA ; DATA_BYTE
01CAAE  1C                    DB     0x1C ; DATA_BYTE
01CAAF  00                    DB     0x00 ; DATA_BYTE
01CAB0  00                    DB     0x00 ; DATA_BYTE
01CAB1  00                    DB     0x00 ; DATA_BYTE
01CAB2  0D                    DB     0x0D ; DATA_BYTE
01CAB3  00                    DB     0x00 ; DATA_BYTE
01CAB4  9A                    DB     0x9A ; DATA_BYTE
01CAB5  AB                    DB     0xAB ; DATA_BYTE
01CAB6  0D                    DB     0x0D ; DATA_BYTE
01CAB7  0D                    DB     0x0D ; DATA_BYTE
01CAB8  11                    DB     0x11 ; DATA_BYTE
01CAB9  EA                    DB     0xEA ; DATA_BYTE
01CABA  14                    DB     0x14 ; DATA_BYTE
01CABB  02                    DB     0x02 ; DATA_BYTE
01CABC  00                    DB     0x00 ; DATA_BYTE
01CABD  00                    DB     0x00 ; DATA_BYTE
01CABE  0D                    DB     0x0D ; DATA_BYTE
01CABF  00                    DB     0x00 ; DATA_BYTE
01CAC0  9A                    DB     0x9A ; DATA_BYTE
01CAC1  AB                    DB     0xAB ; DATA_BYTE
01CAC2  0D                    DB     0x0D ; DATA_BYTE
01CAC3  0D                    DB     0x0D ; DATA_BYTE
01CAC4  11                    DB     0x11 ; DATA_BYTE
01CAC5  EA                    DB     0xEA ; DATA_BYTE
01CAC6  92                    DB     0x92 ; DATA_BYTE
01CAC7  04                    DB     0x04 ; DATA_BYTE
01CAC8  00                    DB     0x00 ; DATA_BYTE
01CAC9  00                    DB     0x00 ; DATA_BYTE
01CACA  0D                    DB     0x0D ; DATA_BYTE
01CACB  00                    DB     0x00 ; DATA_BYTE
01CACC  9A                    DB     0x9A ; DATA_BYTE
01CACD  AB                    DB     0xAB ; DATA_BYTE
01CACE  0D                    DB     0x0D ; DATA_BYTE
01CACF  0D                    DB     0x0D ; DATA_BYTE
01CAD0  11                    DB     0x11 ; DATA_BYTE
01CAD1  EA                    DB     0xEA ; DATA_BYTE
01CAD2  38                    DB     0x38 ; DATA_BYTE
01CAD3  5C                    DB     0x5C ; DATA_BYTE
01CAD4  00                    DB     0x00 ; DATA_BYTE
01CAD5  00                    DB     0x00 ; DATA_BYTE
01CAD6  0D                    DB     0x0D ; DATA_BYTE
01CAD7  00                    DB     0x00 ; DATA_BYTE
01CAD8  9A                    DB     0x9A ; DATA_BYTE
01CAD9  AB                    DB     0xAB ; DATA_BYTE
01CADA  0D                    DB     0x0D ; DATA_BYTE
01CADB  0D                    DB     0x0D ; DATA_BYTE
01CADC  11                    DB     0x11 ; DATA_BYTE
01CADD  EA                    DB     0xEA ; DATA_BYTE
01CADE  72                    DB     0x72 ; DATA_BYTE
01CADF  00                    DB     0x00 ; DATA_BYTE
01CAE0  00                    DB     0x00 ; DATA_BYTE
01CAE1  00                    DB     0x00 ; DATA_BYTE
01CAE2  0D                    DB     0x0D ; DATA_BYTE
01CAE3  00                    DB     0x00 ; DATA_BYTE
01CAE4  9A                    DB     0x9A ; DATA_BYTE
01CAE5  AB                    DB     0xAB ; DATA_BYTE
01CAE6  0D                    DB     0x0D ; DATA_BYTE
01CAE7  0D                    DB     0x0D ; DATA_BYTE
01CAE8  11                    DB     0x11 ; DATA_BYTE
01CAE9  EA                    DB     0xEA ; DATA_BYTE
01CAEA  E6                    DB     0xE6 ; DATA_BYTE
01CAEB  20                    DB     0x20 ; DATA_BYTE
01CAEC  00                    DB     0x00 ; DATA_BYTE
01CAED  00                    DB     0x00 ; DATA_BYTE
01CAEE  0D                    DB     0x0D ; DATA_BYTE
01CAEF  00                    DB     0x00 ; DATA_BYTE
01CAF0  9A                    DB     0x9A ; DATA_BYTE
01CAF1  AB                    DB     0xAB ; DATA_BYTE
01CAF2  0D                    DB     0x0D ; DATA_BYTE
01CAF3  0D                    DB     0x0D ; DATA_BYTE
01CAF4  11                    DB     0x11 ; DATA_BYTE
01CAF5  EA                    DB     0xEA ; DATA_BYTE
01CAF6  3C                    DB     0x3C ; DATA_BYTE
01CAF7  5C                    DB     0x5C ; DATA_BYTE
01CAF8  00                    DB     0x00 ; DATA_BYTE
01CAF9  00                    DB     0x00 ; DATA_BYTE
01CAFA  0D                    DB     0x0D ; DATA_BYTE
01CAFB  00                    DB     0x00 ; DATA_BYTE
01CAFC  9A                    DB     0x9A ; DATA_BYTE
01CAFD  AB                    DB     0xAB ; DATA_BYTE
01CAFE  0D                    DB     0x0D ; DATA_BYTE
01CAFF  0D                    DB     0x0D ; DATA_BYTE
01CB00  11                    DB     0x11 ; DATA_BYTE
01CB01  EA                    DB     0xEA ; DATA_BYTE
01CB02  60                    DB     0x60 ; DATA_BYTE
01CB03  0A                    DB     0x0A ; DATA_BYTE
01CB04  00                    DB     0x00 ; DATA_BYTE
01CB05  00                    DB     0x00 ; DATA_BYTE
01CB06  0D                    DB     0x0D ; DATA_BYTE
01CB07  00                    DB     0x00 ; DATA_BYTE
01CB08  9A                    DB     0x9A ; DATA_BYTE
01CB09  AB                    DB     0xAB ; DATA_BYTE
01CB0A  0D                    DB     0x0D ; DATA_BYTE
01CB0B  0D                    DB     0x0D ; DATA_BYTE
01CB0C  11                    DB     0x11 ; DATA_BYTE
01CB0D  EA                    DB     0xEA ; DATA_BYTE
01CB0E  A8                    DB     0xA8 ; DATA_BYTE
01CB0F  00                    DB     0x00 ; DATA_BYTE
01CB10  00                    DB     0x00 ; DATA_BYTE
01CB11  00                    DB     0x00 ; DATA_BYTE
01CB12  0D                    DB     0x0D ; DATA_BYTE
01CB13  00                    DB     0x00 ; DATA_BYTE
01CB14  9A                    DB     0x9A ; DATA_BYTE
01CB15  AB                    DB     0xAB ; DATA_BYTE
01CB16  0D                    DB     0x0D ; DATA_BYTE
01CB17  0D                    DB     0x0D ; DATA_BYTE
01CB18  11                    DB     0x11 ; DATA_BYTE
01CB19  EA                    DB     0xEA ; DATA_BYTE
01CB1A  BE                    DB     0xBE ; DATA_BYTE
01CB1B  02                    DB     0x02 ; DATA_BYTE
01CB1C  00                    DB     0x00 ; DATA_BYTE
01CB1D  00                    DB     0x00 ; DATA_BYTE
01CB1E  0D                    DB     0x0D ; DATA_BYTE
01CB1F  00                    DB     0x00 ; DATA_BYTE
01CB20  9A                    DB     0x9A ; DATA_BYTE
01CB21  AB                    DB     0xAB ; DATA_BYTE
01CB22  0D                    DB     0x0D ; DATA_BYTE
01CB23  0D                    DB     0x0D ; DATA_BYTE
01CB24  11                    DB     0x11 ; DATA_BYTE
01CB25  EA                    DB     0xEA ; DATA_BYTE
01CB26  F6                    DB     0xF6 ; DATA_BYTE
01CB27  5C                    DB     0x5C ; DATA_BYTE
01CB28  00                    DB     0x00 ; DATA_BYTE
01CB29  00                    DB     0x00 ; DATA_BYTE
01CB2A  0D                    DB     0x0D ; DATA_BYTE
01CB2B  00                    DB     0x00 ; DATA_BYTE
01CB2C  9A                    DB     0x9A ; DATA_BYTE
01CB2D  AB                    DB     0xAB ; DATA_BYTE
01CB2E  0D                    DB     0x0D ; DATA_BYTE
01CB2F  0D                    DB     0x0D ; DATA_BYTE
01CB30  11                    DB     0x11 ; DATA_BYTE
01CB31  EA                    DB     0xEA ; DATA_BYTE
01CB32  2C                    DB     0x2C ; DATA_BYTE
01CB33  05                    DB     0x05 ; DATA_BYTE
01CB34  00                    DB     0x00 ; DATA_BYTE
01CB35  00                    DB     0x00 ; DATA_BYTE
01CB36  0D                    DB     0x0D ; DATA_BYTE
01CB37  00                    DB     0x00 ; DATA_BYTE
01CB38  9A                    DB     0x9A ; DATA_BYTE
01CB39  AB                    DB     0xAB ; DATA_BYTE
01CB3A  0D                    DB     0x0D ; DATA_BYTE
01CB3B  0D                    DB     0x0D ; DATA_BYTE
01CB3C  11                    DB     0x11 ; DATA_BYTE
01CB3D  EA                    DB     0xEA ; DATA_BYTE
01CB3E  DE                    DB     0xDE ; DATA_BYTE
01CB3F  00                    DB     0x00 ; DATA_BYTE
01CB40  00                    DB     0x00 ; DATA_BYTE
01CB41  00                    DB     0x00 ; DATA_BYTE
01CB42  0D                    DB     0x0D ; DATA_BYTE
01CB43  00                    DB     0x00 ; DATA_BYTE
01CB44  9A                    DB     0x9A ; DATA_BYTE
01CB45  AB                    DB     0xAB ; DATA_BYTE
01CB46  0D                    DB     0x0D ; DATA_BYTE
01CB47  0D                    DB     0x0D ; DATA_BYTE
01CB48  11                    DB     0x11 ; DATA_BYTE
01CB49  EA                    DB     0xEA ; DATA_BYTE
01CB4A  04                    DB     0x04 ; DATA_BYTE
01CB4B  5D                    DB     0x5D ; DATA_BYTE
01CB4C  00                    DB     0x00 ; DATA_BYTE
01CB4D  00                    DB     0x00 ; DATA_BYTE
01CB4E  0D                    DB     0x0D ; DATA_BYTE
01CB4F  00                    DB     0x00 ; DATA_BYTE
01CB50  9A                    DB     0x9A ; DATA_BYTE
01CB51  AB                    DB     0xAB ; DATA_BYTE
01CB52  0D                    DB     0x0D ; DATA_BYTE
01CB53  0D                    DB     0x0D ; DATA_BYTE
01CB54  11                    DB     0x11 ; DATA_BYTE
01CB55  EA                    DB     0xEA ; DATA_BYTE
01CB56  1C                    DB     0x1C ; DATA_BYTE
01CB57  03                    DB     0x03 ; DATA_BYTE
01CB58  00                    DB     0x00 ; DATA_BYTE
01CB59  00                    DB     0x00 ; DATA_BYTE
01CB5A  0D                    DB     0x0D ; DATA_BYTE
01CB5B  00                    DB     0x00 ; DATA_BYTE
01CB5C  9A                    DB     0x9A ; DATA_BYTE
01CB5D  AB                    DB     0xAB ; DATA_BYTE
01CB5E  0D                    DB     0x0D ; DATA_BYTE
01CB5F  0D                    DB     0x0D ; DATA_BYTE
01CB60  11                    DB     0x11 ; DATA_BYTE
01CB61  EA                    DB     0xEA ; DATA_BYTE
01CB62  96                    DB     0x96 ; DATA_BYTE
01CB63  08                    DB     0x08 ; DATA_BYTE
01CB64  00                    DB     0x00 ; DATA_BYTE
01CB65  00                    DB     0x00 ; DATA_BYTE
01CB66  0D                    DB     0x0D ; DATA_BYTE
01CB67  00                    DB     0x00 ; DATA_BYTE
01CB68  9A                    DB     0x9A ; DATA_BYTE
01CB69  AB                    DB     0xAB ; DATA_BYTE
01CB6A  0D                    DB     0x0D ; DATA_BYTE
01CB6B  0D                    DB     0x0D ; DATA_BYTE
01CB6C  11                    DB     0x11 ; DATA_BYTE
01CB6D  EA                    DB     0xEA ; DATA_BYTE
01CB6E  42                    DB     0x42 ; DATA_BYTE
01CB6F  03                    DB     0x03 ; DATA_BYTE
01CB70  00                    DB     0x00 ; DATA_BYTE
01CB71  00                    DB     0x00 ; DATA_BYTE
01CB72  0D                    DB     0x0D ; DATA_BYTE
01CB73  00                    DB     0x00 ; DATA_BYTE
01CB74  9A                    DB     0x9A ; DATA_BYTE
01CB75  AB                    DB     0xAB ; DATA_BYTE
01CB76  0D                    DB     0x0D ; DATA_BYTE
01CB77  0D                    DB     0x0D ; DATA_BYTE
01CB78  11                    DB     0x11 ; DATA_BYTE
01CB79  EA                    DB     0xEA ; DATA_BYTE
01CB7A  16                    DB     0x16 ; DATA_BYTE
01CB7B  01                    DB     0x01 ; DATA_BYTE
01CB7C  00                    DB     0x00 ; DATA_BYTE
01CB7D  00                    DB     0x00 ; DATA_BYTE
01CB7E  0D                    DB     0x0D ; DATA_BYTE
01CB7F  00                    DB     0x00 ; DATA_BYTE
01CB80  9A                    DB     0x9A ; DATA_BYTE
01CB81  AB                    DB     0xAB ; DATA_BYTE
01CB82  0D                    DB     0x0D ; DATA_BYTE
01CB83  0D                    DB     0x0D ; DATA_BYTE
01CB84  11                    DB     0x11 ; DATA_BYTE
01CB85  EA                    DB     0xEA ; DATA_BYTE
01CB86  00                    DB     0x00 ; DATA_BYTE
01CB87  06                    DB     0x06 ; DATA_BYTE
01CB88  00                    DB     0x00 ; DATA_BYTE
01CB89  00                    DB     0x00 ; DATA_BYTE
01CB8A  0D                    DB     0x0D ; DATA_BYTE
01CB8B  00                    DB     0x00 ; DATA_BYTE
01CB8C  9A                    DB     0x9A ; DATA_BYTE
01CB8D  AB                    DB     0xAB ; DATA_BYTE
01CB8E  0D                    DB     0x0D ; DATA_BYTE
01CB8F  0D                    DB     0x0D ; DATA_BYTE
01CB90  11                    DB     0x11 ; DATA_BYTE
01CB91  EA                    DB     0xEA ; DATA_BYTE
01CB92  86                    DB     0x86 ; DATA_BYTE
01CB93  00                    DB     0x00 ; DATA_BYTE
01CB94  00                    DB     0x00 ; DATA_BYTE
01CB95  00                    DB     0x00 ; DATA_BYTE
01CB96  13                    DB     0x13 ; DATA_BYTE
01CB97  00                    DB     0x00 ; DATA_BYTE
01CB98  9A                    DB     0x9A ; DATA_BYTE
01CB99  AB                    DB     0xAB ; DATA_BYTE
01CB9A  0D                    DB     0x0D ; DATA_BYTE
01CB9B  0D                    DB     0x0D ; DATA_BYTE
01CB9C  11                    DB     0x11 ; DATA_BYTE
01CB9D  EA                    DB     0xEA ; DATA_BYTE
01CB9E  5E                    DB     0x5E ; DATA_BYTE
01CB9F  03                    DB     0x03 ; DATA_BYTE
01CBA0  00                    DB     0x00 ; DATA_BYTE
01CBA1  00                    DB     0x00 ; DATA_BYTE
01CBA2  0E                    DB     0x0E ; DATA_BYTE
01CBA3  00                    DB     0x00 ; DATA_BYTE
01CBA4  9A                    DB     0x9A ; DATA_BYTE
01CBA5  AB                    DB     0xAB ; DATA_BYTE
01CBA6  0D                    DB     0x0D ; DATA_BYTE
01CBA7  0D                    DB     0x0D ; DATA_BYTE
01CBA8  11                    DB     0x11 ; DATA_BYTE
01CBA9  EA                    DB     0xEA ; DATA_BYTE
01CBAA  14                    DB     0x14 ; DATA_BYTE
01CBAB  02                    DB     0x02 ; DATA_BYTE
01CBAC  00                    DB     0x00 ; DATA_BYTE
01CBAD  00                    DB     0x00 ; DATA_BYTE
01CBAE  0E                    DB     0x0E ; DATA_BYTE
01CBAF  00                    DB     0x00 ; DATA_BYTE
01CBB0  9A                    DB     0x9A ; DATA_BYTE
01CBB1  AB                    DB     0xAB ; DATA_BYTE
01CBB2  0D                    DB     0x0D ; DATA_BYTE
01CBB3  0D                    DB     0x0D ; DATA_BYTE
01CBB4  11                    DB     0x11 ; DATA_BYTE
01CBB5  EA                    DB     0xEA ; DATA_BYTE
01CBB6  80                    DB     0x80 ; DATA_BYTE
01CBB7  02                    DB     0x02 ; DATA_BYTE
01CBB8  00                    DB     0x00 ; DATA_BYTE
01CBB9  00                    DB     0x00 ; DATA_BYTE
01CBBA  0E                    DB     0x0E ; DATA_BYTE
01CBBB  00                    DB     0x00 ; DATA_BYTE
01CBBC  9A                    DB     0x9A ; DATA_BYTE
01CBBD  AB                    DB     0xAB ; DATA_BYTE
01CBBE  0D                    DB     0x0D ; DATA_BYTE
01CBBF  0D                    DB     0x0D ; DATA_BYTE
01CBC0  11                    DB     0x11 ; DATA_BYTE
01CBC1  EA                    DB     0xEA ; DATA_BYTE
01CBC2  F4                    DB     0xF4 ; DATA_BYTE
01CBC3  02                    DB     0x02 ; DATA_BYTE
01CBC4  00                    DB     0x00 ; DATA_BYTE
01CBC5  00                    DB     0x00 ; DATA_BYTE
01CBC6  0E                    DB     0x0E ; DATA_BYTE
01CBC7  00                    DB     0x00 ; DATA_BYTE
01CBC8  9A                    DB     0x9A ; DATA_BYTE
01CBC9  AB                    DB     0xAB ; DATA_BYTE
01CBCA  0D                    DB     0x0D ; DATA_BYTE
01CBCB  0D                    DB     0x0D ; DATA_BYTE
01CBCC  11                    DB     0x11 ; DATA_BYTE
01CBCD  EA                    DB     0xEA ; DATA_BYTE
01CBCE  00                    DB     0x00 ; DATA_BYTE
01CBCF  00                    DB     0x00 ; DATA_BYTE
01CBD0  00                    DB     0x00 ; DATA_BYTE
01CBD1  00                    DB     0x00 ; DATA_BYTE
01CBD2  0E                    DB     0x0E ; DATA_BYTE
01CBD3  00                    DB     0x00 ; DATA_BYTE
01CBD4  9A                    DB     0x9A ; DATA_BYTE
01CBD5  AB                    DB     0xAB ; DATA_BYTE
01CBD6  0D                    DB     0x0D ; DATA_BYTE
01CBD7  0D                    DB     0x0D ; DATA_BYTE
01CBD8  11                    DB     0x11 ; DATA_BYTE
01CBD9  EA                    DB     0xEA ; DATA_BYTE
01CBDA  06                    DB     0x06 ; DATA_BYTE
01CBDB  03                    DB     0x03 ; DATA_BYTE
01CBDC  00                    DB     0x00 ; DATA_BYTE
01CBDD  00                    DB     0x00 ; DATA_BYTE
01CBDE  0E                    DB     0x0E ; DATA_BYTE
01CBDF  00                    DB     0x00 ; DATA_BYTE
01CBE0  9A                    DB     0x9A ; DATA_BYTE
01CBE1  AB                    DB     0xAB ; DATA_BYTE
01CBE2  0D                    DB     0x0D ; DATA_BYTE
01CBE3  0D                    DB     0x0D ; DATA_BYTE
01CBE4  11                    DB     0x11 ; DATA_BYTE
01CBE5  EA                    DB     0xEA ; DATA_BYTE
01CBE6  F2                    DB     0xF2 ; DATA_BYTE
01CBE7  00                    DB     0x00 ; DATA_BYTE
01CBE8  00                    DB     0x00 ; DATA_BYTE
01CBE9  00                    DB     0x00 ; DATA_BYTE
01CBEA  13                    DB     0x13 ; DATA_BYTE
01CBEB  00                    DB     0x00 ; DATA_BYTE
01CBEC  9A                    DB     0x9A ; DATA_BYTE
01CBED  AB                    DB     0xAB ; DATA_BYTE
01CBEE  0D                    DB     0x0D ; DATA_BYTE
01CBEF  0D                    DB     0x0D ; DATA_BYTE
01CBF0  11                    DB     0x11 ; DATA_BYTE
01CBF1  EA                    DB     0xEA ; DATA_BYTE
01CBF2  3E                    DB     0x3E ; DATA_BYTE
01CBF3  15                    DB     0x15 ; DATA_BYTE
01CBF4  00                    DB     0x00 ; DATA_BYTE
01CBF5  00                    DB     0x00 ; DATA_BYTE
01CBF6  0F                    DB     0x0F ; DATA_BYTE
01CBF7  00                    DB     0x00 ; DATA_BYTE
01CBF8  00                    DB     0x00 ; DATA_BYTE
01CBF9  00                    DB     0x00 ; DATA_BYTE
01CBFA  9A                    DB     0x9A ; DATA_BYTE
01CBFB  AB                    DB     0xAB ; DATA_BYTE
01CBFC  0D                    DB     0x0D ; DATA_BYTE
01CBFD  0D                    DB     0x0D ; DATA_BYTE
01CBFE  11                    DB     0x11 ; DATA_BYTE
01CBFF  EA                    DB     0xEA ; DATA_BYTE
01CC00  D0                    DB     0xD0 ; DATA_BYTE
01CC01  12                    DB     0x12 ; DATA_BYTE
01CC02  00                    DB     0x00 ; DATA_BYTE
01CC03  00                    DB     0x00 ; DATA_BYTE
01CC04  0F                    DB     0x0F ; DATA_BYTE
01CC05  00                    DB     0x00 ; DATA_BYTE
01CC06  00                    DB     0x00 ; DATA_BYTE
01CC07  00                    DB     0x00 ; DATA_BYTE
01CC08  9A                    DB     0x9A ; DATA_BYTE
01CC09  AB                    DB     0xAB ; DATA_BYTE
01CC0A  0D                    DB     0x0D ; DATA_BYTE
01CC0B  0D                    DB     0x0D ; DATA_BYTE
01CC0C  11                    DB     0x11 ; DATA_BYTE
01CC0D  EA                    DB     0xEA ; DATA_BYTE
01CC0E  2A                    DB     0x2A ; DATA_BYTE
01CC0F  10                    DB     0x10 ; DATA_BYTE
01CC10  00                    DB     0x00 ; DATA_BYTE
01CC11  00                    DB     0x00 ; DATA_BYTE
01CC12  0F                    DB     0x0F ; DATA_BYTE
01CC13  00                    DB     0x00 ; DATA_BYTE
01CC14  00                    DB     0x00 ; DATA_BYTE
01CC15  00                    DB     0x00 ; DATA_BYTE
01CC16  9A                    DB     0x9A ; DATA_BYTE
01CC17  AB                    DB     0xAB ; DATA_BYTE
01CC18  0D                    DB     0x0D ; DATA_BYTE
01CC19  0D                    DB     0x0D ; DATA_BYTE
01CC1A  11                    DB     0x11 ; DATA_BYTE
01CC1B  EA                    DB     0xEA ; DATA_BYTE
01CC1C  2E                    DB     0x2E ; DATA_BYTE
01CC1D  31                    DB     0x31 ; DATA_BYTE
01CC1E  00                    DB     0x00 ; DATA_BYTE
01CC1F  00                    DB     0x00 ; DATA_BYTE
01CC20  0F                    DB     0x0F ; DATA_BYTE
01CC21  00                    DB     0x00 ; DATA_BYTE
01CC22  00                    DB     0x00 ; DATA_BYTE
01CC23  00                    DB     0x00 ; DATA_BYTE
01CC24  9A                    DB     0x9A ; DATA_BYTE
01CC25  AB                    DB     0xAB ; DATA_BYTE
01CC26  0D                    DB     0x0D ; DATA_BYTE
01CC27  0D                    DB     0x0D ; DATA_BYTE
01CC28  11                    DB     0x11 ; DATA_BYTE
01CC29  EA                    DB     0xEA ; DATA_BYTE
01CC2A  00                    DB     0x00 ; DATA_BYTE
01CC2B  00                    DB     0x00 ; DATA_BYTE
01CC2C  00                    DB     0x00 ; DATA_BYTE
01CC2D  00                    DB     0x00 ; DATA_BYTE
01CC2E  0F                    DB     0x0F ; DATA_BYTE
01CC2F  00                    DB     0x00 ; DATA_BYTE
01CC30  00                    DB     0x00 ; DATA_BYTE
01CC31  00                    DB     0x00 ; DATA_BYTE
01CC32  9A                    DB     0x9A ; DATA_BYTE
01CC33  AB                    DB     0xAB ; DATA_BYTE
01CC34  0D                    DB     0x0D ; DATA_BYTE
01CC35  0D                    DB     0x0D ; DATA_BYTE
01CC36  11                    DB     0x11 ; DATA_BYTE
01CC37  EA                    DB     0xEA ; DATA_BYTE
01CC38  92                    DB     0x92 ; DATA_BYTE
01CC39  10                    DB     0x10 ; DATA_BYTE
01CC3A  00                    DB     0x00 ; DATA_BYTE
01CC3B  00                    DB     0x00 ; DATA_BYTE
01CC3C  0F                    DB     0x0F ; DATA_BYTE
01CC3D  00                    DB     0x00 ; DATA_BYTE
01CC3E  00                    DB     0x00 ; DATA_BYTE
01CC3F  00                    DB     0x00 ; DATA_BYTE
01CC40  9A                    DB     0x9A ; DATA_BYTE
01CC41  AB                    DB     0xAB ; DATA_BYTE
01CC42  0D                    DB     0x0D ; DATA_BYTE
01CC43  0D                    DB     0x0D ; DATA_BYTE
01CC44  11                    DB     0x11 ; DATA_BYTE
01CC45  EA                    DB     0xEA ; DATA_BYTE
01CC46  82                    DB     0x82 ; DATA_BYTE
01CC47  01                    DB     0x01 ; DATA_BYTE
01CC48  00                    DB     0x00 ; DATA_BYTE
01CC49  00                    DB     0x00 ; DATA_BYTE
01CC4A  0F                    DB     0x0F ; DATA_BYTE
01CC4B  00                    DB     0x00 ; DATA_BYTE
01CC4C  00                    DB     0x00 ; DATA_BYTE
01CC4D  00                    DB     0x00 ; DATA_BYTE
01CC4E  9A                    DB     0x9A ; DATA_BYTE
01CC4F  AB                    DB     0xAB ; DATA_BYTE
01CC50  0D                    DB     0x0D ; DATA_BYTE
01CC51  0D                    DB     0x0D ; DATA_BYTE
01CC52  11                    DB     0x11 ; DATA_BYTE
01CC53  EA                    DB     0xEA ; DATA_BYTE
01CC54  B0                    DB     0xB0 ; DATA_BYTE
01CC55  13                    DB     0x13 ; DATA_BYTE
01CC56  00                    DB     0x00 ; DATA_BYTE
01CC57  00                    DB     0x00 ; DATA_BYTE
01CC58  0F                    DB     0x0F ; DATA_BYTE
01CC59  00                    DB     0x00 ; DATA_BYTE
01CC5A  00                    DB     0x00 ; DATA_BYTE
01CC5B  00                    DB     0x00 ; DATA_BYTE
01CC5C  9A                    DB     0x9A ; DATA_BYTE
01CC5D  AB                    DB     0xAB ; DATA_BYTE
01CC5E  0D                    DB     0x0D ; DATA_BYTE
01CC5F  0D                    DB     0x0D ; DATA_BYTE
01CC60  11                    DB     0x11 ; DATA_BYTE
01CC61  EA                    DB     0xEA ; DATA_BYTE
01CC62  2E                    DB     0x2E ; DATA_BYTE
01CC63  02                    DB     0x02 ; DATA_BYTE
01CC64  00                    DB     0x00 ; DATA_BYTE
01CC65  00                    DB     0x00 ; DATA_BYTE
01CC66  0F                    DB     0x0F ; DATA_BYTE
01CC67  00                    DB     0x00 ; DATA_BYTE
01CC68  00                    DB     0x00 ; DATA_BYTE
01CC69  00                    DB     0x00 ; DATA_BYTE
01CC6A  9A                    DB     0x9A ; DATA_BYTE
01CC6B  AB                    DB     0xAB ; DATA_BYTE
01CC6C  0D                    DB     0x0D ; DATA_BYTE
01CC6D  0D                    DB     0x0D ; DATA_BYTE
01CC6E  11                    DB     0x11 ; DATA_BYTE
01CC6F  EA                    DB     0xEA ; DATA_BYTE
01CC70  EC                    DB     0xEC ; DATA_BYTE
01CC71  10                    DB     0x10 ; DATA_BYTE
01CC72  00                    DB     0x00 ; DATA_BYTE
01CC73  00                    DB     0x00 ; DATA_BYTE
01CC74  0F                    DB     0x0F ; DATA_BYTE
01CC75  00                    DB     0x00 ; DATA_BYTE
01CC76  00                    DB     0x00 ; DATA_BYTE
01CC77  00                    DB     0x00 ; DATA_BYTE
01CC78  9A                    DB     0x9A ; DATA_BYTE
01CC79  AB                    DB     0xAB ; DATA_BYTE
01CC7A  0D                    DB     0x0D ; DATA_BYTE
01CC7B  0D                    DB     0x0D ; DATA_BYTE
01CC7C  11                    DB     0x11 ; DATA_BYTE
01CC7D  EA                    DB     0xEA ; DATA_BYTE
01CC7E  CC                    DB     0xCC ; DATA_BYTE
01CC7F  37                    DB     0x37 ; DATA_BYTE
01CC80  00                    DB     0x00 ; DATA_BYTE
01CC81  00                    DB     0x00 ; DATA_BYTE
01CC82  17                    DB     0x17 ; DATA_BYTE
01CC83  00                    DB     0x00 ; DATA_BYTE
01CC84  9A                    DB     0x9A ; DATA_BYTE
01CC85  AB                    DB     0xAB ; DATA_BYTE
01CC86  0D                    DB     0x0D ; DATA_BYTE
01CC87  0D                    DB     0x0D ; DATA_BYTE
01CC88  11                    DB     0x11 ; DATA_BYTE
01CC89  EA                    DB     0xEA ; DATA_BYTE
01CC8A  0E                    DB     0x0E ; DATA_BYTE
01CC8B  02                    DB     0x02 ; DATA_BYTE
01CC8C  00                    DB     0x00 ; DATA_BYTE
01CC8D  00                    DB     0x00 ; DATA_BYTE
01CC8E  0F                    DB     0x0F ; DATA_BYTE
01CC8F  00                    DB     0x00 ; DATA_BYTE
01CC90  7F                    DB     0x7F ; DATA_BYTE
01CC91  03                    DB     0x03 ; DATA_BYTE
01CC92  9A                    DB     0x9A ; DATA_BYTE
01CC93  AB                    DB     0xAB ; DATA_BYTE
01CC94  0D                    DB     0x0D ; DATA_BYTE
01CC95  0D                    DB     0x0D ; DATA_BYTE
01CC96  11                    DB     0x11 ; DATA_BYTE
01CC97  EA                    DB     0xEA ; DATA_BYTE
01CC98  0E                    DB     0x0E ; DATA_BYTE
01CC99  00                    DB     0x00 ; DATA_BYTE
01CC9A  00                    DB     0x00 ; DATA_BYTE
01CC9B  00                    DB     0x00 ; DATA_BYTE
01CC9C  0F                    DB     0x0F ; DATA_BYTE
01CC9D  00                    DB     0x00 ; DATA_BYTE
01CC9E  7F                    DB     0x7F ; DATA_BYTE
01CC9F  03                    DB     0x03 ; DATA_BYTE
01CCA0  9A                    DB     0x9A ; DATA_BYTE
01CCA1  AB                    DB     0xAB ; DATA_BYTE
01CCA2  0D                    DB     0x0D ; DATA_BYTE
01CCA3  0D                    DB     0x0D ; DATA_BYTE
01CCA4  11                    DB     0x11 ; DATA_BYTE
01CCA5  EA                    DB     0xEA ; DATA_BYTE
01CCA6  6C                    DB     0x6C ; DATA_BYTE
01CCA7  01                    DB     0x01 ; DATA_BYTE
01CCA8  00                    DB     0x00 ; DATA_BYTE
01CCA9  00                    DB     0x00 ; DATA_BYTE
01CCAA  10                    DB     0x10 ; DATA_BYTE
01CCAB  00                    DB     0x00 ; DATA_BYTE
01CCAC  9A                    DB     0x9A ; DATA_BYTE
01CCAD  AB                    DB     0xAB ; DATA_BYTE
01CCAE  0D                    DB     0x0D ; DATA_BYTE
01CCAF  0D                    DB     0x0D ; DATA_BYTE
01CCB0  11                    DB     0x11 ; DATA_BYTE
01CCB1  EA                    DB     0xEA ; DATA_BYTE
01CCB2  EA                    DB     0xEA ; DATA_BYTE
01CCB3  16                    DB     0x16 ; DATA_BYTE
01CCB4  00                    DB     0x00 ; DATA_BYTE
01CCB5  00                    DB     0x00 ; DATA_BYTE
01CCB6  10                    DB     0x10 ; DATA_BYTE
01CCB7  00                    DB     0x00 ; DATA_BYTE
01CCB8  9A                    DB     0x9A ; DATA_BYTE
01CCB9  AB                    DB     0xAB ; DATA_BYTE
01CCBA  0D                    DB     0x0D ; DATA_BYTE
01CCBB  0D                    DB     0x0D ; DATA_BYTE
01CCBC  11                    DB     0x11 ; DATA_BYTE
01CCBD  EA                    DB     0xEA ; DATA_BYTE
01CCBE  14                    DB     0x14 ; DATA_BYTE
01CCBF  0F                    DB     0x0F ; DATA_BYTE
01CCC0  00                    DB     0x00 ; DATA_BYTE
01CCC1  00                    DB     0x00 ; DATA_BYTE
01CCC2  10                    DB     0x10 ; DATA_BYTE
01CCC3  00                    DB     0x00 ; DATA_BYTE
01CCC4  9A                    DB     0x9A ; DATA_BYTE
01CCC5  AB                    DB     0xAB ; DATA_BYTE
01CCC6  0D                    DB     0x0D ; DATA_BYTE
01CCC7  0D                    DB     0x0D ; DATA_BYTE
01CCC8  11                    DB     0x11 ; DATA_BYTE
01CCC9  EA                    DB     0xEA ; DATA_BYTE
01CCCA  2C                    DB     0x2C ; DATA_BYTE
01CCCB  17                    DB     0x17 ; DATA_BYTE
01CCCC  00                    DB     0x00 ; DATA_BYTE
01CCCD  00                    DB     0x00 ; DATA_BYTE
01CCCE  10                    DB     0x10 ; DATA_BYTE
01CCCF  00                    DB     0x00 ; DATA_BYTE
01CCD0  9A                    DB     0x9A ; DATA_BYTE
01CCD1  AB                    DB     0xAB ; DATA_BYTE
01CCD2  0D                    DB     0x0D ; DATA_BYTE
01CCD3  0D                    DB     0x0D ; DATA_BYTE
01CCD4  11                    DB     0x11 ; DATA_BYTE
01CCD5  EA                    DB     0xEA ; DATA_BYTE
01CCD6  52                    DB     0x52 ; DATA_BYTE
01CCD7  03                    DB     0x03 ; DATA_BYTE
01CCD8  00                    DB     0x00 ; DATA_BYTE
01CCD9  00                    DB     0x00 ; DATA_BYTE
01CCDA  10                    DB     0x10 ; DATA_BYTE
01CCDB  00                    DB     0x00 ; DATA_BYTE
01CCDC  9A                    DB     0x9A ; DATA_BYTE
01CCDD  AB                    DB     0xAB ; DATA_BYTE
01CCDE  0D                    DB     0x0D ; DATA_BYTE
01CCDF  0D                    DB     0x0D ; DATA_BYTE
01CCE0  11                    DB     0x11 ; DATA_BYTE
01CCE1  EA                    DB     0xEA ; DATA_BYTE
01CCE2  06                    DB     0x06 ; DATA_BYTE
01CCE3  19                    DB     0x19 ; DATA_BYTE
01CCE4  00                    DB     0x00 ; DATA_BYTE
01CCE5  00                    DB     0x00 ; DATA_BYTE
01CCE6  10                    DB     0x10 ; DATA_BYTE
01CCE7  00                    DB     0x00 ; DATA_BYTE
01CCE8  9A                    DB     0x9A ; DATA_BYTE
01CCE9  AB                    DB     0xAB ; DATA_BYTE
01CCEA  0D                    DB     0x0D ; DATA_BYTE
01CCEB  0D                    DB     0x0D ; DATA_BYTE
01CCEC  11                    DB     0x11 ; DATA_BYTE
01CCED  EA                    DB     0xEA ; DATA_BYTE
01CCEE  C0                    DB     0xC0 ; DATA_BYTE
01CCEF  0E                    DB     0x0E ; DATA_BYTE
01CCF0  00                    DB     0x00 ; DATA_BYTE
01CCF1  00                    DB     0x00 ; DATA_BYTE
01CCF2  10                    DB     0x10 ; DATA_BYTE
01CCF3  00                    DB     0x00 ; DATA_BYTE
01CCF4  9A                    DB     0x9A ; DATA_BYTE
01CCF5  AB                    DB     0xAB ; DATA_BYTE
01CCF6  0D                    DB     0x0D ; DATA_BYTE
01CCF7  0D                    DB     0x0D ; DATA_BYTE
01CCF8  11                    DB     0x11 ; DATA_BYTE
01CCF9  EA                    DB     0xEA ; DATA_BYTE
01CCFA  00                    DB     0x00 ; DATA_BYTE
01CCFB  00                    DB     0x00 ; DATA_BYTE
01CCFC  00                    DB     0x00 ; DATA_BYTE
01CCFD  00                    DB     0x00 ; DATA_BYTE
01CCFE  11                    DB     0x11 ; DATA_BYTE
01CCFF  00                    DB     0x00 ; DATA_BYTE
01CD00  9A                    DB     0x9A ; DATA_BYTE
01CD01  AB                    DB     0xAB ; DATA_BYTE
01CD02  0D                    DB     0x0D ; DATA_BYTE
01CD03  0D                    DB     0x0D ; DATA_BYTE
01CD04  11                    DB     0x11 ; DATA_BYTE
01CD05  EA                    DB     0xEA ; DATA_BYTE
01CD06  78                    DB     0x78 ; DATA_BYTE
01CD07  22                    DB     0x22 ; DATA_BYTE
01CD08  00                    DB     0x00 ; DATA_BYTE
01CD09  00                    DB     0x00 ; DATA_BYTE
01CD0A  17                    DB     0x17 ; DATA_BYTE
01CD0B  00                    DB     0x00 ; DATA_BYTE
01CD0C  9A                    DB     0x9A ; DATA_BYTE
01CD0D  AB                    DB     0xAB ; DATA_BYTE
01CD0E  0D                    DB     0x0D ; DATA_BYTE
01CD0F  0D                    DB     0x0D ; DATA_BYTE
01CD10  11                    DB     0x11 ; DATA_BYTE
01CD11  EA                    DB     0xEA ; DATA_BYTE
01CD12  80                    DB     0x80 ; DATA_BYTE
01CD13  0E                    DB     0x0E ; DATA_BYTE
01CD14  00                    DB     0x00 ; DATA_BYTE
01CD15  00                    DB     0x00 ; DATA_BYTE
01CD16  12                    DB     0x12 ; DATA_BYTE
01CD17  00                    DB     0x00 ; DATA_BYTE
01CD18  00                    DB     0x00 ; DATA_BYTE
01CD19  00                    DB     0x00 ; DATA_BYTE
01CD1A  9A                    DB     0x9A ; DATA_BYTE
01CD1B  AB                    DB     0xAB ; DATA_BYTE
01CD1C  0D                    DB     0x0D ; DATA_BYTE
01CD1D  0D                    DB     0x0D ; DATA_BYTE
01CD1E  11                    DB     0x11 ; DATA_BYTE
01CD1F  EA                    DB     0xEA ; DATA_BYTE
01CD20  AA                    DB     0xAA ; DATA_BYTE
01CD21  05                    DB     0x05 ; DATA_BYTE
01CD22  00                    DB     0x00 ; DATA_BYTE
01CD23  00                    DB     0x00 ; DATA_BYTE
01CD24  12                    DB     0x12 ; DATA_BYTE
01CD25  00                    DB     0x00 ; DATA_BYTE
01CD26  00                    DB     0x00 ; DATA_BYTE
01CD27  00                    DB     0x00 ; DATA_BYTE
01CD28  9A                    DB     0x9A ; DATA_BYTE
01CD29  AB                    DB     0xAB ; DATA_BYTE
01CD2A  0D                    DB     0x0D ; DATA_BYTE
01CD2B  0D                    DB     0x0D ; DATA_BYTE
01CD2C  11                    DB     0x11 ; DATA_BYTE
01CD2D  EA                    DB     0xEA ; DATA_BYTE
01CD2E  EC                    DB     0xEC ; DATA_BYTE
01CD2F  05                    DB     0x05 ; DATA_BYTE
01CD30  00                    DB     0x00 ; DATA_BYTE
01CD31  00                    DB     0x00 ; DATA_BYTE
01CD32  12                    DB     0x12 ; DATA_BYTE
01CD33  00                    DB     0x00 ; DATA_BYTE
01CD34  00                    DB     0x00 ; DATA_BYTE
01CD35  00                    DB     0x00 ; DATA_BYTE
01CD36  9A                    DB     0x9A ; DATA_BYTE
01CD37  AB                    DB     0xAB ; DATA_BYTE
01CD38  0D                    DB     0x0D ; DATA_BYTE
01CD39  0D                    DB     0x0D ; DATA_BYTE
01CD3A  11                    DB     0x11 ; DATA_BYTE
01CD3B  EA                    DB     0xEA ; DATA_BYTE
01CD3C  2C                    DB     0x2C ; DATA_BYTE
01CD3D  0F                    DB     0x0F ; DATA_BYTE
01CD3E  00                    DB     0x00 ; DATA_BYTE
01CD3F  00                    DB     0x00 ; DATA_BYTE
01CD40  12                    DB     0x12 ; DATA_BYTE
01CD41  00                    DB     0x00 ; DATA_BYTE
01CD42  00                    DB     0x00 ; DATA_BYTE
01CD43  00                    DB     0x00 ; DATA_BYTE
01CD44  9A                    DB     0x9A ; DATA_BYTE
01CD45  AB                    DB     0xAB ; DATA_BYTE
01CD46  0D                    DB     0x0D ; DATA_BYTE
01CD47  0D                    DB     0x0D ; DATA_BYTE
01CD48  11                    DB     0x11 ; DATA_BYTE
01CD49  EA                    DB     0xEA ; DATA_BYTE
01CD4A  40                    DB     0x40 ; DATA_BYTE
01CD4B  00                    DB     0x00 ; DATA_BYTE
01CD4C  00                    DB     0x00 ; DATA_BYTE
01CD4D  00                    DB     0x00 ; DATA_BYTE
01CD4E  12                    DB     0x12 ; DATA_BYTE
01CD4F  00                    DB     0x00 ; DATA_BYTE
01CD50  00                    DB     0x00 ; DATA_BYTE
01CD51  00                    DB     0x00 ; DATA_BYTE
01CD52  9A                    DB     0x9A ; DATA_BYTE
01CD53  AB                    DB     0xAB ; DATA_BYTE
01CD54  0D                    DB     0x0D ; DATA_BYTE
01CD55  0D                    DB     0x0D ; DATA_BYTE
01CD56  11                    DB     0x11 ; DATA_BYTE
01CD57  EA                    DB     0xEA ; DATA_BYTE
01CD58  94                    DB     0x94 ; DATA_BYTE
01CD59  00                    DB     0x00 ; DATA_BYTE
01CD5A  00                    DB     0x00 ; DATA_BYTE
01CD5B  00                    DB     0x00 ; DATA_BYTE
01CD5C  12                    DB     0x12 ; DATA_BYTE
01CD5D  00                    DB     0x00 ; DATA_BYTE
01CD5E  00                    DB     0x00 ; DATA_BYTE
01CD5F  00                    DB     0x00 ; DATA_BYTE
01CD60  9A                    DB     0x9A ; DATA_BYTE
01CD61  AB                    DB     0xAB ; DATA_BYTE
01CD62  0D                    DB     0x0D ; DATA_BYTE
01CD63  0D                    DB     0x0D ; DATA_BYTE
01CD64  11                    DB     0x11 ; DATA_BYTE
01CD65  EA                    DB     0xEA ; DATA_BYTE
01CD66  DA                    DB     0xDA ; DATA_BYTE
01CD67  09                    DB     0x09 ; DATA_BYTE
01CD68  00                    DB     0x00 ; DATA_BYTE
01CD69  00                    DB     0x00 ; DATA_BYTE
01CD6A  12                    DB     0x12 ; DATA_BYTE
01CD6B  00                    DB     0x00 ; DATA_BYTE
01CD6C  00                    DB     0x00 ; DATA_BYTE
01CD6D  00                    DB     0x00 ; DATA_BYTE
01CD6E  9A                    DB     0x9A ; DATA_BYTE
01CD6F  AB                    DB     0xAB ; DATA_BYTE
01CD70  0D                    DB     0x0D ; DATA_BYTE
01CD71  0D                    DB     0x0D ; DATA_BYTE
01CD72  11                    DB     0x11 ; DATA_BYTE
01CD73  EA                    DB     0xEA ; DATA_BYTE
01CD74  64                    DB     0x64 ; DATA_BYTE
01CD75  10                    DB     0x10 ; DATA_BYTE
01CD76  00                    DB     0x00 ; DATA_BYTE
01CD77  00                    DB     0x00 ; DATA_BYTE
01CD78  12                    DB     0x12 ; DATA_BYTE
01CD79  00                    DB     0x00 ; DATA_BYTE
01CD7A  00                    DB     0x00 ; DATA_BYTE
01CD7B  00                    DB     0x00 ; DATA_BYTE
01CD7C  9A                    DB     0x9A ; DATA_BYTE
01CD7D  AB                    DB     0xAB ; DATA_BYTE
01CD7E  0D                    DB     0x0D ; DATA_BYTE
01CD7F  0D                    DB     0x0D ; DATA_BYTE
01CD80  11                    DB     0x11 ; DATA_BYTE
01CD81  EA                    DB     0xEA ; DATA_BYTE
01CD82  F0                    DB     0xF0 ; DATA_BYTE
01CD83  04                    DB     0x04 ; DATA_BYTE
01CD84  00                    DB     0x00 ; DATA_BYTE
01CD85  00                    DB     0x00 ; DATA_BYTE
01CD86  12                    DB     0x12 ; DATA_BYTE
01CD87  00                    DB     0x00 ; DATA_BYTE
01CD88  00                    DB     0x00 ; DATA_BYTE
01CD89  00                    DB     0x00 ; DATA_BYTE
01CD8A  9A                    DB     0x9A ; DATA_BYTE
01CD8B  AB                    DB     0xAB ; DATA_BYTE
01CD8C  0D                    DB     0x0D ; DATA_BYTE
01CD8D  0D                    DB     0x0D ; DATA_BYTE
01CD8E  11                    DB     0x11 ; DATA_BYTE
01CD8F  EA                    DB     0xEA ; DATA_BYTE
01CD90  D2                    DB     0xD2 ; DATA_BYTE
01CD91  10                    DB     0x10 ; DATA_BYTE
01CD92  00                    DB     0x00 ; DATA_BYTE
01CD93  00                    DB     0x00 ; DATA_BYTE
01CD94  12                    DB     0x12 ; DATA_BYTE
01CD95  00                    DB     0x00 ; DATA_BYTE
01CD96  00                    DB     0x00 ; DATA_BYTE
01CD97  00                    DB     0x00 ; DATA_BYTE
01CD98  9A                    DB     0x9A ; DATA_BYTE
01CD99  AB                    DB     0xAB ; DATA_BYTE
01CD9A  0D                    DB     0x0D ; DATA_BYTE
01CD9B  0D                    DB     0x0D ; DATA_BYTE
01CD9C  11                    DB     0x11 ; DATA_BYTE
01CD9D  EA                    DB     0xEA ; DATA_BYTE
01CD9E  D4                    DB     0xD4 ; DATA_BYTE
01CD9F  0D                    DB     0x0D ; DATA_BYTE
01CDA0  00                    DB     0x00 ; DATA_BYTE
01CDA1  00                    DB     0x00 ; DATA_BYTE
01CDA2  12                    DB     0x12 ; DATA_BYTE
01CDA3  00                    DB     0x00 ; DATA_BYTE
01CDA4  00                    DB     0x00 ; DATA_BYTE
01CDA5  00                    DB     0x00 ; DATA_BYTE
01CDA6  9A                    DB     0x9A ; DATA_BYTE
01CDA7  AB                    DB     0xAB ; DATA_BYTE
01CDA8  0D                    DB     0x0D ; DATA_BYTE
01CDA9  0D                    DB     0x0D ; DATA_BYTE
01CDAA  11                    DB     0x11 ; DATA_BYTE
01CDAB  EA                    DB     0xEA ; DATA_BYTE
01CDAC  48                    DB     0x48 ; DATA_BYTE
01CDAD  05                    DB     0x05 ; DATA_BYTE
01CDAE  00                    DB     0x00 ; DATA_BYTE
01CDAF  00                    DB     0x00 ; DATA_BYTE
01CDB0  12                    DB     0x12 ; DATA_BYTE
01CDB1  00                    DB     0x00 ; DATA_BYTE
01CDB2  00                    DB     0x00 ; DATA_BYTE
01CDB3  00                    DB     0x00 ; DATA_BYTE
01CDB4  9A                    DB     0x9A ; DATA_BYTE
01CDB5  AB                    DB     0xAB ; DATA_BYTE
01CDB6  0D                    DB     0x0D ; DATA_BYTE
01CDB7  0D                    DB     0x0D ; DATA_BYTE
01CDB8  11                    DB     0x11 ; DATA_BYTE
01CDB9  EA                    DB     0xEA ; DATA_BYTE
01CDBA  84                    DB     0x84 ; DATA_BYTE
01CDBB  30                    DB     0x30 ; DATA_BYTE
01CDBC  00                    DB     0x00 ; DATA_BYTE
01CDBD  00                    DB     0x00 ; DATA_BYTE
01CDBE  17                    DB     0x17 ; DATA_BYTE
01CDBF  00                    DB     0x00 ; DATA_BYTE
01CDC0  9A                    DB     0x9A ; DATA_BYTE
01CDC1  AB                    DB     0xAB ; DATA_BYTE
01CDC2  0D                    DB     0x0D ; DATA_BYTE
01CDC3  0D                    DB     0x0D ; DATA_BYTE
01CDC4  11                    DB     0x11 ; DATA_BYTE
01CDC5  EA                    DB     0xEA ; DATA_BYTE
01CDC6  4E                    DB     0x4E ; DATA_BYTE
01CDC7  0B                    DB     0x0B ; DATA_BYTE
01CDC8  00                    DB     0x00 ; DATA_BYTE
01CDC9  00                    DB     0x00 ; DATA_BYTE
01CDCA  13                    DB     0x13 ; DATA_BYTE
01CDCB  00                    DB     0x00 ; DATA_BYTE
01CDCC  9A                    DB     0x9A ; DATA_BYTE
01CDCD  AB                    DB     0xAB ; DATA_BYTE
01CDCE  0D                    DB     0x0D ; DATA_BYTE
01CDCF  0D                    DB     0x0D ; DATA_BYTE
01CDD0  11                    DB     0x11 ; DATA_BYTE
01CDD1  EA                    DB     0xEA ; DATA_BYTE
01CDD2  00                    DB     0x00 ; DATA_BYTE
01CDD3  00                    DB     0x00 ; DATA_BYTE
01CDD4  00                    DB     0x00 ; DATA_BYTE
01CDD5  00                    DB     0x00 ; DATA_BYTE
01CDD6  14                    DB     0x14 ; DATA_BYTE
01CDD7  00                    DB     0x00 ; DATA_BYTE
01CDD8  00                    DB     0x00 ; DATA_BYTE
01CDD9  00                    DB     0x00 ; DATA_BYTE
01CDDA  9A                    DB     0x9A ; DATA_BYTE
01CDDB  AB                    DB     0xAB ; DATA_BYTE
01CDDC  0D                    DB     0x0D ; DATA_BYTE
01CDDD  0D                    DB     0x0D ; DATA_BYTE
01CDDE  11                    DB     0x11 ; DATA_BYTE
01CDDF  EA                    DB     0xEA ; DATA_BYTE
01CDE0  88                    DB     0x88 ; DATA_BYTE
01CDE1  00                    DB     0x00 ; DATA_BYTE
01CDE2  00                    DB     0x00 ; DATA_BYTE
01CDE3  00                    DB     0x00 ; DATA_BYTE
01CDE4  14                    DB     0x14 ; DATA_BYTE
01CDE5  00                    DB     0x00 ; DATA_BYTE
01CDE6  35                    DB     0x35 ; DATA_BYTE
01CDE7  00                    DB     0x00 ; DATA_BYTE
01CDE8  9A                    DB     0x9A ; DATA_BYTE
01CDE9  AB                    DB     0xAB ; DATA_BYTE
01CDEA  0D                    DB     0x0D ; DATA_BYTE
01CDEB  0D                    DB     0x0D ; DATA_BYTE
01CDEC  11                    DB     0x11 ; DATA_BYTE
01CDED  EA                    DB     0xEA ; DATA_BYTE
01CDEE  0C                    DB     0x0C ; DATA_BYTE
01CDEF  00                    DB     0x00 ; DATA_BYTE
01CDF0  00                    DB     0x00 ; DATA_BYTE
01CDF1  00                    DB     0x00 ; DATA_BYTE
01CDF2  14                    DB     0x14 ; DATA_BYTE
01CDF3  00                    DB     0x00 ; DATA_BYTE
01CDF4  6B                    DB     0x6B ; DATA_BYTE
01CDF5  00                    DB     0x00 ; DATA_BYTE
01CDF6  9A                    DB     0x9A ; DATA_BYTE
01CDF7  AB                    DB     0xAB ; DATA_BYTE
01CDF8  0D                    DB     0x0D ; DATA_BYTE
01CDF9  0D                    DB     0x0D ; DATA_BYTE
01CDFA  11                    DB     0x11 ; DATA_BYTE
01CDFB  EA                    DB     0xEA ; DATA_BYTE
01CDFC  16                    DB     0x16 ; DATA_BYTE
01CDFD  01                    DB     0x01 ; DATA_BYTE
01CDFE  00                    DB     0x00 ; DATA_BYTE
01CDFF  00                    DB     0x00 ; DATA_BYTE
01CE00  14                    DB     0x14 ; DATA_BYTE
01CE01  00                    DB     0x00 ; DATA_BYTE
01CE02  8D                    DB     0x8D ; DATA_BYTE
01CE03  00                    DB     0x00 ; DATA_BYTE
01CE04  9A                    DB     0x9A ; DATA_BYTE
01CE05  AB                    DB     0xAB ; DATA_BYTE
01CE06  0D                    DB     0x0D ; DATA_BYTE
01CE07  0D                    DB     0x0D ; DATA_BYTE
01CE08  11                    DB     0x11 ; DATA_BYTE
01CE09  EA                    DB     0xEA ; DATA_BYTE
01CE0A  1C                    DB     0x1C ; DATA_BYTE
01CE0B  02                    DB     0x02 ; DATA_BYTE
01CE0C  00                    DB     0x00 ; DATA_BYTE
01CE0D  00                    DB     0x00 ; DATA_BYTE
01CE0E  14                    DB     0x14 ; DATA_BYTE
01CE0F  00                    DB     0x00 ; DATA_BYTE
01CE10  8D                    DB     0x8D ; DATA_BYTE
01CE11  00                    DB     0x00 ; DATA_BYTE
01CE12  9A                    DB     0x9A ; DATA_BYTE
01CE13  AB                    DB     0xAB ; DATA_BYTE
01CE14  0D                    DB     0x0D ; DATA_BYTE
01CE15  0D                    DB     0x0D ; DATA_BYTE
01CE16  11                    DB     0x11 ; DATA_BYTE
01CE17  EA                    DB     0xEA ; DATA_BYTE
01CE18  A8                    DB     0xA8 ; DATA_BYTE
01CE19  02                    DB     0x02 ; DATA_BYTE
01CE1A  00                    DB     0x00 ; DATA_BYTE
01CE1B  00                    DB     0x00 ; DATA_BYTE
01CE1C  14                    DB     0x14 ; DATA_BYTE
01CE1D  00                    DB     0x00 ; DATA_BYTE
01CE1E  8D                    DB     0x8D ; DATA_BYTE
01CE1F  00                    DB     0x00 ; DATA_BYTE
01CE20  9A                    DB     0x9A ; DATA_BYTE
01CE21  AB                    DB     0xAB ; DATA_BYTE
01CE22  0D                    DB     0x0D ; DATA_BYTE
01CE23  0D                    DB     0x0D ; DATA_BYTE
01CE24  11                    DB     0x11 ; DATA_BYTE
01CE25  EA                    DB     0xEA ; DATA_BYTE
01CE26  E4                    DB     0xE4 ; DATA_BYTE
01CE27  03                    DB     0x03 ; DATA_BYTE
01CE28  00                    DB     0x00 ; DATA_BYTE
01CE29  00                    DB     0x00 ; DATA_BYTE
01CE2A  14                    DB     0x14 ; DATA_BYTE
01CE2B  00                    DB     0x00 ; DATA_BYTE
01CE2C  8D                    DB     0x8D ; DATA_BYTE
01CE2D  00                    DB     0x00 ; DATA_BYTE
01CE2E  9A                    DB     0x9A ; DATA_BYTE
01CE2F  AB                    DB     0xAB ; DATA_BYTE
01CE30  0D                    DB     0x0D ; DATA_BYTE
01CE31  0D                    DB     0x0D ; DATA_BYTE
01CE32  11                    DB     0x11 ; DATA_BYTE
01CE33  EA                    DB     0xEA ; DATA_BYTE
01CE34  C0                    DB     0xC0 ; DATA_BYTE
01CE35  08                    DB     0x08 ; DATA_BYTE
01CE36  00                    DB     0x00 ; DATA_BYTE
01CE37  00                    DB     0x00 ; DATA_BYTE
01CE38  14                    DB     0x14 ; DATA_BYTE
01CE39  00                    DB     0x00 ; DATA_BYTE
01CE3A  8D                    DB     0x8D ; DATA_BYTE
01CE3B  00                    DB     0x00 ; DATA_BYTE
01CE3C  9A                    DB     0x9A ; DATA_BYTE
01CE3D  AB                    DB     0xAB ; DATA_BYTE
01CE3E  0D                    DB     0x0D ; DATA_BYTE
01CE3F  0D                    DB     0x0D ; DATA_BYTE
01CE40  11                    DB     0x11 ; DATA_BYTE
01CE41  EA                    DB     0xEA ; DATA_BYTE
01CE42  A6                    DB     0xA6 ; DATA_BYTE
01CE43  04                    DB     0x04 ; DATA_BYTE
01CE44  00                    DB     0x00 ; DATA_BYTE
01CE45  00                    DB     0x00 ; DATA_BYTE
01CE46  14                    DB     0x14 ; DATA_BYTE
01CE47  00                    DB     0x00 ; DATA_BYTE
01CE48  8D                    DB     0x8D ; DATA_BYTE
01CE49  00                    DB     0x00 ; DATA_BYTE
01CE4A  9A                    DB     0x9A ; DATA_BYTE
01CE4B  AB                    DB     0xAB ; DATA_BYTE
01CE4C  0D                    DB     0x0D ; DATA_BYTE
01CE4D  0D                    DB     0x0D ; DATA_BYTE
01CE4E  11                    DB     0x11 ; DATA_BYTE
01CE4F  EA                    DB     0xEA ; DATA_BYTE
01CE50  9C                    DB     0x9C ; DATA_BYTE
01CE51  00                    DB     0x00 ; DATA_BYTE
01CE52  00                    DB     0x00 ; DATA_BYTE
01CE53  00                    DB     0x00 ; DATA_BYTE
01CE54  14                    DB     0x14 ; DATA_BYTE
01CE55  00                    DB     0x00 ; DATA_BYTE
01CE56  8D                    DB     0x8D ; DATA_BYTE
01CE57  00                    DB     0x00 ; DATA_BYTE
01CE58  9A                    DB     0x9A ; DATA_BYTE
01CE59  91                    DB     0x91 ; DATA_BYTE
01CE5A  0D                    DB     0x0D ; DATA_BYTE
01CE5B  0D                    DB     0x0D ; DATA_BYTE
01CE5C  11                    DB     0x11 ; DATA_BYTE
01CE5D  EA                    DB     0xEA ; DATA_BYTE
01CE5E  06                    DB     0x06 ; DATA_BYTE
01CE5F  00                    DB     0x00 ; DATA_BYTE
01CE60  BB                    DB     0xBB ; DATA_BYTE
01CE61  0B                    DB     0x0B ; DATA_BYTE
01CE62  9A                    DB     0x9A ; DATA_BYTE
01CE63  91                    DB     0x91 ; DATA_BYTE
01CE64  0D                    DB     0x0D ; DATA_BYTE
01CE65  0D                    DB     0x0D ; DATA_BYTE
01CE66  11                    DB     0x11 ; DATA_BYTE
01CE67  EA                    DB     0xEA ; DATA_BYTE
01CE68  0A                    DB     0x0A ; DATA_BYTE
01CE69  00                    DB     0x00 ; DATA_BYTE
01CE6A  B9                    DB     0xB9 ; DATA_BYTE
01CE6B  0B                    DB     0x0B ; DATA_BYTE
01CE6C  9A                    DB     0x9A ; DATA_BYTE
01CE6D  AB                    DB     0xAB ; DATA_BYTE
01CE6E  0D                    DB     0x0D ; DATA_BYTE
01CE6F  0D                    DB     0x0D ; DATA_BYTE
01CE70  11                    DB     0x11 ; DATA_BYTE
01CE71  EA                    DB     0xEA ; DATA_BYTE
01CE72  06                    DB     0x06 ; DATA_BYTE
01CE73  00                    DB     0x00 ; DATA_BYTE
01CE74  00                    DB     0x00 ; DATA_BYTE
01CE75  00                    DB     0x00 ; DATA_BYTE
01CE76  14                    DB     0x14 ; DATA_BYTE
01CE77  00                    DB     0x00 ; DATA_BYTE
01CE78  4A                    DB     0x4A ; DATA_BYTE
01CE79  02                    DB     0x02 ; DATA_BYTE
01CE7A  9A                    DB     0x9A ; DATA_BYTE
01CE7B  AB                    DB     0xAB ; DATA_BYTE
01CE7C  0D                    DB     0x0D ; DATA_BYTE
01CE7D  0D                    DB     0x0D ; DATA_BYTE
01CE7E  11                    DB     0x11 ; DATA_BYTE
01CE7F  EA                    DB     0xEA ; DATA_BYTE
01CE80  98                    DB     0x98 ; DATA_BYTE
01CE81  01                    DB     0x01 ; DATA_BYTE
01CE82  00                    DB     0x00 ; DATA_BYTE
01CE83  00                    DB     0x00 ; DATA_BYTE
01CE84  18                    DB     0x18 ; DATA_BYTE
01CE85  00                    DB     0x00 ; DATA_BYTE
01CE86  9A                    DB     0x9A ; DATA_BYTE
01CE87  AB                    DB     0xAB ; DATA_BYTE
01CE88  0D                    DB     0x0D ; DATA_BYTE
01CE89  0D                    DB     0x0D ; DATA_BYTE
01CE8A  11                    DB     0x11 ; DATA_BYTE
01CE8B  EA                    DB     0xEA ; DATA_BYTE
01CE8C  18                    DB     0x18 ; DATA_BYTE
01CE8D  01                    DB     0x01 ; DATA_BYTE
01CE8E  00                    DB     0x00 ; DATA_BYTE
01CE8F  00                    DB     0x00 ; DATA_BYTE
01CE90  15                    DB     0x15 ; DATA_BYTE
01CE91  00                    DB     0x00 ; DATA_BYTE
01CE92  00                    DB     0x00 ; DATA_BYTE
01CE93  00                    DB     0x00 ; DATA_BYTE
01CE94  9A                    DB     0x9A ; DATA_BYTE
01CE95  AB                    DB     0xAB ; DATA_BYTE
01CE96  0D                    DB     0x0D ; DATA_BYTE
01CE97  0D                    DB     0x0D ; DATA_BYTE
01CE98  11                    DB     0x11 ; DATA_BYTE
01CE99  EA                    DB     0xEA ; DATA_BYTE
01CE9A  86                    DB     0x86 ; DATA_BYTE
01CE9B  04                    DB     0x04 ; DATA_BYTE
01CE9C  00                    DB     0x00 ; DATA_BYTE
01CE9D  00                    DB     0x00 ; DATA_BYTE
01CE9E  15                    DB     0x15 ; DATA_BYTE
01CE9F  00                    DB     0x00 ; DATA_BYTE
01CEA0  00                    DB     0x00 ; DATA_BYTE
01CEA1  00                    DB     0x00 ; DATA_BYTE
01CEA2  9A                    DB     0x9A ; DATA_BYTE
01CEA3  AB                    DB     0xAB ; DATA_BYTE
01CEA4  0D                    DB     0x0D ; DATA_BYTE
01CEA5  0D                    DB     0x0D ; DATA_BYTE
01CEA6  11                    DB     0x11 ; DATA_BYTE
01CEA7  EA                    DB     0xEA ; DATA_BYTE
01CEA8  00                    DB     0x00 ; DATA_BYTE
01CEA9  00                    DB     0x00 ; DATA_BYTE
01CEAA  00                    DB     0x00 ; DATA_BYTE
01CEAB  00                    DB     0x00 ; DATA_BYTE
01CEAC  15                    DB     0x15 ; DATA_BYTE
01CEAD  00                    DB     0x00 ; DATA_BYTE
01CEAE  00                    DB     0x00 ; DATA_BYTE
01CEAF  00                    DB     0x00 ; DATA_BYTE
01CEB0  9A                    DB     0x9A ; DATA_BYTE
01CEB1  AB                    DB     0xAB ; DATA_BYTE
01CEB2  0D                    DB     0x0D ; DATA_BYTE
01CEB3  0D                    DB     0x0D ; DATA_BYTE
01CEB4  11                    DB     0x11 ; DATA_BYTE
01CEB5  EA                    DB     0xEA ; DATA_BYTE
01CEB6  34                    DB     0x34 ; DATA_BYTE
01CEB7  00                    DB     0x00 ; DATA_BYTE
01CEB8  00                    DB     0x00 ; DATA_BYTE
01CEB9  00                    DB     0x00 ; DATA_BYTE
01CEBA  15                    DB     0x15 ; DATA_BYTE
01CEBB  00                    DB     0x00 ; DATA_BYTE
01CEBC  00                    DB     0x00 ; DATA_BYTE
01CEBD  00                    DB     0x00 ; DATA_BYTE
01CEBE  9A                    DB     0x9A ; DATA_BYTE
01CEBF  AB                    DB     0xAB ; DATA_BYTE
01CEC0  0D                    DB     0x0D ; DATA_BYTE
01CEC1  0D                    DB     0x0D ; DATA_BYTE
01CEC2  11                    DB     0x11 ; DATA_BYTE
01CEC3  EA                    DB     0xEA ; DATA_BYTE
01CEC4  46                    DB     0x46 ; DATA_BYTE
01CEC5  03                    DB     0x03 ; DATA_BYTE
01CEC6  00                    DB     0x00 ; DATA_BYTE
01CEC7  00                    DB     0x00 ; DATA_BYTE
01CEC8  15                    DB     0x15 ; DATA_BYTE
01CEC9  00                    DB     0x00 ; DATA_BYTE
01CECA  00                    DB     0x00 ; DATA_BYTE
01CECB  00                    DB     0x00 ; DATA_BYTE
01CECC  9A                    DB     0x9A ; DATA_BYTE
01CECD  AB                    DB     0xAB ; DATA_BYTE
01CECE  0D                    DB     0x0D ; DATA_BYTE
01CECF  0D                    DB     0x0D ; DATA_BYTE
01CED0  11                    DB     0x11 ; DATA_BYTE
01CED1  EA                    DB     0xEA ; DATA_BYTE
01CED2  68                    DB     0x68 ; DATA_BYTE
01CED3  00                    DB     0x00 ; DATA_BYTE
01CED4  00                    DB     0x00 ; DATA_BYTE
01CED5  00                    DB     0x00 ; DATA_BYTE
01CED6  15                    DB     0x15 ; DATA_BYTE
01CED7  00                    DB     0x00 ; DATA_BYTE
01CED8  00                    DB     0x00 ; DATA_BYTE
01CED9  00                    DB     0x00 ; DATA_BYTE
01CEDA  9A                    DB     0x9A ; DATA_BYTE
01CEDB  AB                    DB     0xAB ; DATA_BYTE
01CEDC  0D                    DB     0x0D ; DATA_BYTE
01CEDD  0D                    DB     0x0D ; DATA_BYTE
01CEDE  11                    DB     0x11 ; DATA_BYTE
01CEDF  EA                    DB     0xEA ; DATA_BYTE
01CEE0  24                    DB     0x24 ; DATA_BYTE
01CEE1  02                    DB     0x02 ; DATA_BYTE
01CEE2  00                    DB     0x00 ; DATA_BYTE
01CEE3  00                    DB     0x00 ; DATA_BYTE
01CEE4  15                    DB     0x15 ; DATA_BYTE
01CEE5  00                    DB     0x00 ; DATA_BYTE
01CEE6  5B                    DB     0x5B ; DATA_BYTE
01CEE7  00                    DB     0x00 ; DATA_BYTE
01CEE8  9A                    DB     0x9A ; DATA_BYTE
01CEE9  AB                    DB     0xAB ; DATA_BYTE
01CEEA  0D                    DB     0x0D ; DATA_BYTE
01CEEB  0D                    DB     0x0D ; DATA_BYTE
01CEEC  11                    DB     0x11 ; DATA_BYTE
01CEED  EA                    DB     0xEA ; DATA_BYTE
01CEEE  3C                    DB     0x3C ; DATA_BYTE
01CEEF  02                    DB     0x02 ; DATA_BYTE
01CEF0  00                    DB     0x00 ; DATA_BYTE
01CEF1  00                    DB     0x00 ; DATA_BYTE
01CEF2  15                    DB     0x15 ; DATA_BYTE
01CEF3  00                    DB     0x00 ; DATA_BYTE
01CEF4  5B                    DB     0x5B ; DATA_BYTE
01CEF5  00                    DB     0x00 ; DATA_BYTE
01CEF6  9A                    DB     0x9A ; DATA_BYTE
01CEF7  AB                    DB     0xAB ; DATA_BYTE
01CEF8  0D                    DB     0x0D ; DATA_BYTE
01CEF9  0D                    DB     0x0D ; DATA_BYTE
01CEFA  11                    DB     0x11 ; DATA_BYTE
01CEFB  EA                    DB     0xEA ; DATA_BYTE
01CEFC  0C                    DB     0x0C ; DATA_BYTE
01CEFD  00                    DB     0x00 ; DATA_BYTE
01CEFE  00                    DB     0x00 ; DATA_BYTE
01CEFF  00                    DB     0x00 ; DATA_BYTE
01CF00  15                    DB     0x15 ; DATA_BYTE
01CF01  00                    DB     0x00 ; DATA_BYTE
01CF02  5B                    DB     0x5B ; DATA_BYTE
01CF03  00                    DB     0x00 ; DATA_BYTE
01CF04  9A                    DB     0x9A ; DATA_BYTE
01CF05  AB                    DB     0xAB ; DATA_BYTE
01CF06  0D                    DB     0x0D ; DATA_BYTE
01CF07  0D                    DB     0x0D ; DATA_BYTE
01CF08  11                    DB     0x11 ; DATA_BYTE
01CF09  EA                    DB     0xEA ; DATA_BYTE
01CF0A  52                    DB     0x52 ; DATA_BYTE
01CF0B  00                    DB     0x00 ; DATA_BYTE
01CF0C  00                    DB     0x00 ; DATA_BYTE
01CF0D  00                    DB     0x00 ; DATA_BYTE
01CF0E  15                    DB     0x15 ; DATA_BYTE
01CF0F  00                    DB     0x00 ; DATA_BYTE
01CF10  5B                    DB     0x5B ; DATA_BYTE
01CF11  00                    DB     0x00 ; DATA_BYTE
01CF12  9A                    DB     0x9A ; DATA_BYTE
01CF13  AB                    DB     0xAB ; DATA_BYTE
01CF14  0D                    DB     0x0D ; DATA_BYTE
01CF15  0D                    DB     0x0D ; DATA_BYTE
01CF16  11                    DB     0x11 ; DATA_BYTE
01CF17  EA                    DB     0xEA ; DATA_BYTE
01CF18  02                    DB     0x02 ; DATA_BYTE
01CF19  01                    DB     0x01 ; DATA_BYTE
01CF1A  00                    DB     0x00 ; DATA_BYTE
01CF1B  00                    DB     0x00 ; DATA_BYTE
01CF1C  15                    DB     0x15 ; DATA_BYTE
01CF1D  00                    DB     0x00 ; DATA_BYTE
01CF1E  83                    DB     0x83 ; DATA_BYTE
01CF1F  00                    DB     0x00 ; DATA_BYTE
01CF20  9A                    DB     0x9A ; DATA_BYTE
01CF21  AB                    DB     0xAB ; DATA_BYTE
01CF22  0D                    DB     0x0D ; DATA_BYTE
01CF23  0D                    DB     0x0D ; DATA_BYTE
01CF24  11                    DB     0x11 ; DATA_BYTE
01CF25  EA                    DB     0xEA ; DATA_BYTE
01CF26  28                    DB     0x28 ; DATA_BYTE
01CF27  04                    DB     0x04 ; DATA_BYTE
01CF28  00                    DB     0x00 ; DATA_BYTE
01CF29  00                    DB     0x00 ; DATA_BYTE
01CF2A  15                    DB     0x15 ; DATA_BYTE
01CF2B  00                    DB     0x00 ; DATA_BYTE
01CF2C  83                    DB     0x83 ; DATA_BYTE
01CF2D  00                    DB     0x00 ; DATA_BYTE
01CF2E  9A                    DB     0x9A ; DATA_BYTE
01CF2F  AB                    DB     0xAB ; DATA_BYTE
01CF30  0D                    DB     0x0D ; DATA_BYTE
01CF31  0D                    DB     0x0D ; DATA_BYTE
01CF32  11                    DB     0x11 ; DATA_BYTE
01CF33  EA                    DB     0xEA ; DATA_BYTE
01CF34  8E                    DB     0x8E ; DATA_BYTE
01CF35  05                    DB     0x05 ; DATA_BYTE
01CF36  00                    DB     0x00 ; DATA_BYTE
01CF37  00                    DB     0x00 ; DATA_BYTE
01CF38  15                    DB     0x15 ; DATA_BYTE
01CF39  00                    DB     0x00 ; DATA_BYTE
01CF3A  83                    DB     0x83 ; DATA_BYTE
01CF3B  00                    DB     0x00 ; DATA_BYTE
01CF3C  9A                    DB     0x9A ; DATA_BYTE
01CF3D  AB                    DB     0xAB ; DATA_BYTE
01CF3E  0D                    DB     0x0D ; DATA_BYTE
01CF3F  0D                    DB     0x0D ; DATA_BYTE
01CF40  11                    DB     0x11 ; DATA_BYTE
01CF41  EA                    DB     0xEA ; DATA_BYTE
01CF42  02                    DB     0x02 ; DATA_BYTE
01CF43  00                    DB     0x00 ; DATA_BYTE
01CF44  00                    DB     0x00 ; DATA_BYTE
01CF45  00                    DB     0x00 ; DATA_BYTE
01CF46  15                    DB     0x15 ; DATA_BYTE
01CF47  00                    DB     0x00 ; DATA_BYTE
01CF48  83                    DB     0x83 ; DATA_BYTE
01CF49  00                    DB     0x00 ; DATA_BYTE
01CF4A  9A                    DB     0x9A ; DATA_BYTE
01CF4B  AB                    DB     0xAB ; DATA_BYTE
01CF4C  0D                    DB     0x0D ; DATA_BYTE
01CF4D  0D                    DB     0x0D ; DATA_BYTE
01CF4E  11                    DB     0x11 ; DATA_BYTE
01CF4F  EA                    DB     0xEA ; DATA_BYTE
01CF50  4C                    DB     0x4C ; DATA_BYTE
01CF51  03                    DB     0x03 ; DATA_BYTE
01CF52  00                    DB     0x00 ; DATA_BYTE
01CF53  00                    DB     0x00 ; DATA_BYTE
01CF54  15                    DB     0x15 ; DATA_BYTE
01CF55  00                    DB     0x00 ; DATA_BYTE
01CF56  83                    DB     0x83 ; DATA_BYTE
01CF57  00                    DB     0x00 ; DATA_BYTE
01CF58  9A                    DB     0x9A ; DATA_BYTE
01CF59  AB                    DB     0xAB ; DATA_BYTE
01CF5A  0D                    DB     0x0D ; DATA_BYTE
01CF5B  0D                    DB     0x0D ; DATA_BYTE
01CF5C  11                    DB     0x11 ; DATA_BYTE
01CF5D  EA                    DB     0xEA ; DATA_BYTE
01CF5E  6C                    DB     0x6C ; DATA_BYTE
01CF5F  0D                    DB     0x0D ; DATA_BYTE
01CF60  00                    DB     0x00 ; DATA_BYTE
01CF61  00                    DB     0x00 ; DATA_BYTE
01CF62  15                    DB     0x15 ; DATA_BYTE
01CF63  00                    DB     0x00 ; DATA_BYTE
01CF64  02                    DB     0x02 ; DATA_BYTE
01CF65  01                    DB     0x01 ; DATA_BYTE
01CF66  9A                    DB     0x9A ; DATA_BYTE
01CF67  AB                    DB     0xAB ; DATA_BYTE
01CF68  0D                    DB     0x0D ; DATA_BYTE
01CF69  0D                    DB     0x0D ; DATA_BYTE
01CF6A  11                    DB     0x11 ; DATA_BYTE
01CF6B  EA                    DB     0xEA ; DATA_BYTE
01CF6C  BE                    DB     0xBE ; DATA_BYTE
01CF6D  10                    DB     0x10 ; DATA_BYTE
01CF6E  00                    DB     0x00 ; DATA_BYTE
01CF6F  00                    DB     0x00 ; DATA_BYTE
01CF70  15                    DB     0x15 ; DATA_BYTE
01CF71  00                    DB     0x00 ; DATA_BYTE
01CF72  02                    DB     0x02 ; DATA_BYTE
01CF73  01                    DB     0x01 ; DATA_BYTE
01CF74  9A                    DB     0x9A ; DATA_BYTE
01CF75  91                    DB     0x91 ; DATA_BYTE
01CF76  0D                    DB     0x0D ; DATA_BYTE
01CF77  0D                    DB     0x0D ; DATA_BYTE
01CF78  11                    DB     0x11 ; DATA_BYTE
01CF79  EA                    DB     0xEA ; DATA_BYTE
01CF7A  04                    DB     0x04 ; DATA_BYTE
01CF7B  00                    DB     0x00 ; DATA_BYTE
01CF7C  AA                    DB     0xAA ; DATA_BYTE
01CF7D  0C                    DB     0x0C ; DATA_BYTE
01CF7E  9A                    DB     0x9A ; DATA_BYTE
01CF7F  91                    DB     0x91 ; DATA_BYTE
01CF80  0D                    DB     0x0D ; DATA_BYTE
01CF81  0D                    DB     0x0D ; DATA_BYTE
01CF82  11                    DB     0x11 ; DATA_BYTE
01CF83  EA                    DB     0xEA ; DATA_BYTE
01CF84  06                    DB     0x06 ; DATA_BYTE
01CF85  00                    DB     0x00 ; DATA_BYTE
01CF86  89                    DB     0x89 ; DATA_BYTE
01CF87  0C                    DB     0x0C ; DATA_BYTE
01CF88  9A                    DB     0x9A ; DATA_BYTE
01CF89  AB                    DB     0xAB ; DATA_BYTE
01CF8A  0D                    DB     0x0D ; DATA_BYTE
01CF8B  0D                    DB     0x0D ; DATA_BYTE
01CF8C  11                    DB     0x11 ; DATA_BYTE
01CF8D  EA                    DB     0xEA ; DATA_BYTE
01CF8E  9C                    DB     0x9C ; DATA_BYTE
01CF8F  03                    DB     0x03 ; DATA_BYTE
01CF90  00                    DB     0x00 ; DATA_BYTE
01CF91  00                    DB     0x00 ; DATA_BYTE
01CF92  16                    DB     0x16 ; DATA_BYTE
01CF93  00                    DB     0x00 ; DATA_BYTE
01CF94  00                    DB     0x00 ; DATA_BYTE
01CF95  00                    DB     0x00 ; DATA_BYTE
01CF96  9A                    DB     0x9A ; DATA_BYTE
01CF97  AB                    DB     0xAB ; DATA_BYTE
01CF98  0D                    DB     0x0D ; DATA_BYTE
01CF99  0D                    DB     0x0D ; DATA_BYTE
01CF9A  11                    DB     0x11 ; DATA_BYTE
01CF9B  EA                    DB     0xEA ; DATA_BYTE
01CF9C  C0                    DB     0xC0 ; DATA_BYTE
01CF9D  00                    DB     0x00 ; DATA_BYTE
01CF9E  00                    DB     0x00 ; DATA_BYTE
01CF9F  00                    DB     0x00 ; DATA_BYTE
01CFA0  16                    DB     0x16 ; DATA_BYTE
01CFA1  00                    DB     0x00 ; DATA_BYTE
01CFA2  00                    DB     0x00 ; DATA_BYTE
01CFA3  00                    DB     0x00 ; DATA_BYTE
01CFA4  9A                    DB     0x9A ; DATA_BYTE
01CFA5  AB                    DB     0xAB ; DATA_BYTE
01CFA6  0D                    DB     0x0D ; DATA_BYTE
01CFA7  0D                    DB     0x0D ; DATA_BYTE
01CFA8  11                    DB     0x11 ; DATA_BYTE
01CFA9  EA                    DB     0xEA ; DATA_BYTE
01CFAA  3C                    DB     0x3C ; DATA_BYTE
01CFAB  20                    DB     0x20 ; DATA_BYTE
01CFAC  00                    DB     0x00 ; DATA_BYTE
01CFAD  00                    DB     0x00 ; DATA_BYTE
01CFAE  16                    DB     0x16 ; DATA_BYTE
01CFAF  00                    DB     0x00 ; DATA_BYTE
01CFB0  00                    DB     0x00 ; DATA_BYTE
01CFB1  00                    DB     0x00 ; DATA_BYTE
01CFB2  9A                    DB     0x9A ; DATA_BYTE
01CFB3  AB                    DB     0xAB ; DATA_BYTE
01CFB4  0D                    DB     0x0D ; DATA_BYTE
01CFB5  0D                    DB     0x0D ; DATA_BYTE
01CFB6  11                    DB     0x11 ; DATA_BYTE
01CFB7  EA                    DB     0xEA ; DATA_BYTE
01CFB8  BC                    DB     0xBC ; DATA_BYTE
01CFB9  03                    DB     0x03 ; DATA_BYTE
01CFBA  00                    DB     0x00 ; DATA_BYTE
01CFBB  00                    DB     0x00 ; DATA_BYTE
01CFBC  16                    DB     0x16 ; DATA_BYTE
01CFBD  00                    DB     0x00 ; DATA_BYTE
01CFBE  00                    DB     0x00 ; DATA_BYTE
01CFBF  00                    DB     0x00 ; DATA_BYTE
01CFC0  9A                    DB     0x9A ; DATA_BYTE
01CFC1  AB                    DB     0xAB ; DATA_BYTE
01CFC2  0D                    DB     0x0D ; DATA_BYTE
01CFC3  0D                    DB     0x0D ; DATA_BYTE
01CFC4  11                    DB     0x11 ; DATA_BYTE
01CFC5  EA                    DB     0xEA ; DATA_BYTE
01CFC6  24                    DB     0x24 ; DATA_BYTE
01CFC7  04                    DB     0x04 ; DATA_BYTE
01CFC8  00                    DB     0x00 ; DATA_BYTE
01CFC9  00                    DB     0x00 ; DATA_BYTE
01CFCA  16                    DB     0x16 ; DATA_BYTE
01CFCB  00                    DB     0x00 ; DATA_BYTE
01CFCC  00                    DB     0x00 ; DATA_BYTE
01CFCD  00                    DB     0x00 ; DATA_BYTE
01CFCE  9A                    DB     0x9A ; DATA_BYTE
01CFCF  AB                    DB     0xAB ; DATA_BYTE
01CFD0  0D                    DB     0x0D ; DATA_BYTE
01CFD1  0D                    DB     0x0D ; DATA_BYTE
01CFD2  11                    DB     0x11 ; DATA_BYTE
01CFD3  EA                    DB     0xEA ; DATA_BYTE
01CFD4  78                    DB     0x78 ; DATA_BYTE
01CFD5  01                    DB     0x01 ; DATA_BYTE
01CFD6  00                    DB     0x00 ; DATA_BYTE
01CFD7  00                    DB     0x00 ; DATA_BYTE
01CFD8  16                    DB     0x16 ; DATA_BYTE
01CFD9  00                    DB     0x00 ; DATA_BYTE
01CFDA  00                    DB     0x00 ; DATA_BYTE
01CFDB  00                    DB     0x00 ; DATA_BYTE
01CFDC  9A                    DB     0x9A ; DATA_BYTE
01CFDD  AB                    DB     0xAB ; DATA_BYTE
01CFDE  0D                    DB     0x0D ; DATA_BYTE
01CFDF  0D                    DB     0x0D ; DATA_BYTE
01CFE0  11                    DB     0x11 ; DATA_BYTE
01CFE1  EA                    DB     0xEA ; DATA_BYTE
01CFE2  4A                    DB     0x4A ; DATA_BYTE
01CFE3  21                    DB     0x21 ; DATA_BYTE
01CFE4  00                    DB     0x00 ; DATA_BYTE
01CFE5  00                    DB     0x00 ; DATA_BYTE
01CFE6  16                    DB     0x16 ; DATA_BYTE
01CFE7  00                    DB     0x00 ; DATA_BYTE
01CFE8  00                    DB     0x00 ; DATA_BYTE
01CFE9  00                    DB     0x00 ; DATA_BYTE
01CFEA  9A                    DB     0x9A ; DATA_BYTE
01CFEB  AB                    DB     0xAB ; DATA_BYTE
01CFEC  0D                    DB     0x0D ; DATA_BYTE
01CFED  0D                    DB     0x0D ; DATA_BYTE
01CFEE  11                    DB     0x11 ; DATA_BYTE
01CFEF  EA                    DB     0xEA ; DATA_BYTE
01CFF0  8C                    DB     0x8C ; DATA_BYTE
01CFF1  04                    DB     0x04 ; DATA_BYTE
01CFF2  00                    DB     0x00 ; DATA_BYTE
01CFF3  00                    DB     0x00 ; DATA_BYTE
01CFF4  16                    DB     0x16 ; DATA_BYTE
01CFF5  00                    DB     0x00 ; DATA_BYTE
01CFF6  00                    DB     0x00 ; DATA_BYTE
01CFF7  00                    DB     0x00 ; DATA_BYTE
01CFF8  9A                    DB     0x9A ; DATA_BYTE
01CFF9  AB                    DB     0xAB ; DATA_BYTE
01CFFA  0D                    DB     0x0D ; DATA_BYTE
01CFFB  0D                    DB     0x0D ; DATA_BYTE
01CFFC  11                    DB     0x11 ; DATA_BYTE
01CFFD  EA                    DB     0xEA ; DATA_BYTE
01CFFE  22                    DB     0x22 ; DATA_BYTE
01CFFF  23                    DB     0x23 ; DATA_BYTE
01D000  00                    DB     0x00 ; DATA_BYTE
01D001  00                    DB     0x00 ; DATA_BYTE
01D002  16                    DB     0x16 ; DATA_BYTE
01D003  00                    DB     0x00 ; DATA_BYTE
01D004  00                    DB     0x00 ; DATA_BYTE
01D005  00                    DB     0x00 ; DATA_BYTE
01D006  9A                    DB     0x9A ; DATA_BYTE
01D007  AB                    DB     0xAB ; DATA_BYTE
01D008  0D                    DB     0x0D ; DATA_BYTE
01D009  0D                    DB     0x0D ; DATA_BYTE
01D00A  11                    DB     0x11 ; DATA_BYTE
01D00B  EA                    DB     0xEA ; DATA_BYTE
01D00C  76                    DB     0x76 ; DATA_BYTE
01D00D  02                    DB     0x02 ; DATA_BYTE
01D00E  00                    DB     0x00 ; DATA_BYTE
01D00F  00                    DB     0x00 ; DATA_BYTE
01D010  16                    DB     0x16 ; DATA_BYTE
01D011  00                    DB     0x00 ; DATA_BYTE
01D012  00                    DB     0x00 ; DATA_BYTE
01D013  00                    DB     0x00 ; DATA_BYTE
01D014  9A                    DB     0x9A ; DATA_BYTE
01D015  AB                    DB     0xAB ; DATA_BYTE
01D016  0D                    DB     0x0D ; DATA_BYTE
01D017  0D                    DB     0x0D ; DATA_BYTE
01D018  11                    DB     0x11 ; DATA_BYTE
01D019  EA                    DB     0xEA ; DATA_BYTE
01D01A  C4                    DB     0xC4 ; DATA_BYTE
01D01B  02                    DB     0x02 ; DATA_BYTE
01D01C  00                    DB     0x00 ; DATA_BYTE
01D01D  00                    DB     0x00 ; DATA_BYTE
01D01E  16                    DB     0x16 ; DATA_BYTE
01D01F  00                    DB     0x00 ; DATA_BYTE
01D020  00                    DB     0x00 ; DATA_BYTE
01D021  00                    DB     0x00 ; DATA_BYTE
01D022  9A                    DB     0x9A ; DATA_BYTE
01D023  AB                    DB     0xAB ; DATA_BYTE
01D024  0D                    DB     0x0D ; DATA_BYTE
01D025  0D                    DB     0x0D ; DATA_BYTE
01D026  11                    DB     0x11 ; DATA_BYTE
01D027  EA                    DB     0xEA ; DATA_BYTE
01D028  00                    DB     0x00 ; DATA_BYTE
01D029  00                    DB     0x00 ; DATA_BYTE
01D02A  00                    DB     0x00 ; DATA_BYTE
01D02B  00                    DB     0x00 ; DATA_BYTE
01D02C  16                    DB     0x16 ; DATA_BYTE
01D02D  00                    DB     0x00 ; DATA_BYTE
01D02E  00                    DB     0x00 ; DATA_BYTE
01D02F  00                    DB     0x00 ; DATA_BYTE
01D030  9A                    DB     0x9A ; DATA_BYTE
01D031  AB                    DB     0xAB ; DATA_BYTE
01D032  0D                    DB     0x0D ; DATA_BYTE
01D033  0D                    DB     0x0D ; DATA_BYTE
01D034  11                    DB     0x11 ; DATA_BYTE
01D035  EA                    DB     0xEA ; DATA_BYTE
01D036  58                    DB     0x58 ; DATA_BYTE
01D037  00                    DB     0x00 ; DATA_BYTE
01D038  00                    DB     0x00 ; DATA_BYTE
01D039  00                    DB     0x00 ; DATA_BYTE
01D03A  16                    DB     0x16 ; DATA_BYTE
01D03B  00                    DB     0x00 ; DATA_BYTE
01D03C  00                    DB     0x00 ; DATA_BYTE
01D03D  00                    DB     0x00 ; DATA_BYTE
01D03E  9A                    DB     0x9A ; DATA_BYTE
01D03F  AB                    DB     0xAB ; DATA_BYTE
01D040  0D                    DB     0x0D ; DATA_BYTE
01D041  0D                    DB     0x0D ; DATA_BYTE
01D042  11                    DB     0x11 ; DATA_BYTE
01D043  EA                    DB     0xEA ; DATA_BYTE
01D044  3A                    DB     0x3A ; DATA_BYTE
01D045  03                    DB     0x03 ; DATA_BYTE
01D046  00                    DB     0x00 ; DATA_BYTE
01D047  00                    DB     0x00 ; DATA_BYTE
01D048  16                    DB     0x16 ; DATA_BYTE
01D049  00                    DB     0x00 ; DATA_BYTE
01D04A  00                    DB     0x00 ; DATA_BYTE
01D04B  00                    DB     0x00 ; DATA_BYTE
01D04C  9A                    DB     0x9A ; DATA_BYTE
01D04D  AB                    DB     0xAB ; DATA_BYTE
01D04E  0D                    DB     0x0D ; DATA_BYTE
01D04F  0D                    DB     0x0D ; DATA_BYTE
01D050  11                    DB     0x11 ; DATA_BYTE
01D051  EA                    DB     0xEA ; DATA_BYTE
01D052  04                    DB     0x04 ; DATA_BYTE
01D053  00                    DB     0x00 ; DATA_BYTE
01D054  00                    DB     0x00 ; DATA_BYTE
01D055  00                    DB     0x00 ; DATA_BYTE
01D056  16                    DB     0x16 ; DATA_BYTE
01D057  00                    DB     0x00 ; DATA_BYTE
01D058  7E                    DB     0x7E ; DATA_BYTE
01D059  02                    DB     0x02 ; DATA_BYTE
01D05A  9A                    DB     0x9A ; DATA_BYTE
01D05B  AB                    DB     0xAB ; DATA_BYTE
01D05C  0D                    DB     0x0D ; DATA_BYTE
01D05D  0D                    DB     0x0D ; DATA_BYTE
01D05E  11                    DB     0x11 ; DATA_BYTE
01D05F  EA                    DB     0xEA ; DATA_BYTE
01D060  2A                    DB     0x2A ; DATA_BYTE
01D061  00                    DB     0x00 ; DATA_BYTE
01D062  00                    DB     0x00 ; DATA_BYTE
01D063  00                    DB     0x00 ; DATA_BYTE
01D064  1E                    DB     0x1E ; DATA_BYTE
01D065  00                    DB     0x00 ; DATA_BYTE
01D066  37                    DB     0x37 ; DATA_BYTE
01D067  00                    DB     0x00 ; DATA_BYTE
01D068  9A                    DB     0x9A ; DATA_BYTE
01D069  AB                    DB     0xAB ; DATA_BYTE
01D06A  0D                    DB     0x0D ; DATA_BYTE
01D06B  0D                    DB     0x0D ; DATA_BYTE
01D06C  11                    DB     0x11 ; DATA_BYTE
01D06D  EA                    DB     0xEA ; DATA_BYTE
01D06E  08                    DB     0x08 ; DATA_BYTE
01D06F  00                    DB     0x00 ; DATA_BYTE
01D070  00                    DB     0x00 ; DATA_BYTE
01D071  00                    DB     0x00 ; DATA_BYTE
01D072  1E                    DB     0x1E ; DATA_BYTE
01D073  00                    DB     0x00 ; DATA_BYTE
01D074  67                    DB     0x67 ; DATA_BYTE
01D075  00                    DB     0x00 ; DATA_BYTE
01D076  9A                    DB     0x9A ; DATA_BYTE
01D077  AB                    DB     0xAB ; DATA_BYTE
01D078  0D                    DB     0x0D ; DATA_BYTE
01D079  0D                    DB     0x0D ; DATA_BYTE
01D07A  11                    DB     0x11 ; DATA_BYTE
01D07B  EA                    DB     0xEA ; DATA_BYTE
01D07C  00                    DB     0x00 ; DATA_BYTE
01D07D  00                    DB     0x00 ; DATA_BYTE
01D07E  00                    DB     0x00 ; DATA_BYTE
01D07F  00                    DB     0x00 ; DATA_BYTE
01D080  1B                    DB     0x1B ; DATA_BYTE
01D081  00                    DB     0x00 ; DATA_BYTE
01D082  7A                    DB     0x7A ; DATA_BYTE
01D083  00                    DB     0x00 ; DATA_BYTE
01D084  9A                    DB     0x9A ; DATA_BYTE
01D085  91                    DB     0x91 ; DATA_BYTE
01D086  0D                    DB     0x0D ; DATA_BYTE
01D087  0D                    DB     0x0D ; DATA_BYTE
01D088  11                    DB     0x11 ; DATA_BYTE
01D089  EA                    DB     0xEA ; DATA_BYTE
01D08A  0E                    DB     0x0E ; DATA_BYTE
01D08B  00                    DB     0x00 ; DATA_BYTE
01D08C  32                    DB     0x32 ; DATA_BYTE
01D08D  0B                    DB     0x0B ; DATA_BYTE
01D08E  9A                    DB     0x9A ; DATA_BYTE
01D08F  AB                    DB     0xAB ; DATA_BYTE
01D090  0D                    DB     0x0D ; DATA_BYTE
01D091  0D                    DB     0x0D ; DATA_BYTE
01D092  11                    DB     0x11 ; DATA_BYTE
01D093  EA                    DB     0xEA ; DATA_BYTE
01D094  9A                    DB     0x9A ; DATA_BYTE
01D095  08                    DB     0x08 ; DATA_BYTE
01D096  00                    DB     0x00 ; DATA_BYTE
01D097  00                    DB     0x00 ; DATA_BYTE
01D098  17                    DB     0x17 ; DATA_BYTE
01D099  00                    DB     0x00 ; DATA_BYTE
01D09A  9A                    DB     0x9A ; DATA_BYTE
01D09B  AB                    DB     0xAB ; DATA_BYTE
01D09C  0D                    DB     0x0D ; DATA_BYTE
01D09D  0D                    DB     0x0D ; DATA_BYTE
01D09E  11                    DB     0x11 ; DATA_BYTE
01D09F  EA                    DB     0xEA ; DATA_BYTE
01D0A0  5E                    DB     0x5E ; DATA_BYTE
01D0A1  25                    DB     0x25 ; DATA_BYTE
01D0A2  00                    DB     0x00 ; DATA_BYTE
01D0A3  00                    DB     0x00 ; DATA_BYTE
01D0A4  17                    DB     0x17 ; DATA_BYTE
01D0A5  00                    DB     0x00 ; DATA_BYTE
01D0A6  9A                    DB     0x9A ; DATA_BYTE
01D0A7  AB                    DB     0xAB ; DATA_BYTE
01D0A8  0D                    DB     0x0D ; DATA_BYTE
01D0A9  0D                    DB     0x0D ; DATA_BYTE
01D0AA  11                    DB     0x11 ; DATA_BYTE
01D0AB  EA                    DB     0xEA ; DATA_BYTE
01D0AC  E8                    DB     0xE8 ; DATA_BYTE
01D0AD  1A                    DB     0x1A ; DATA_BYTE
01D0AE  00                    DB     0x00 ; DATA_BYTE
01D0AF  00                    DB     0x00 ; DATA_BYTE
01D0B0  17                    DB     0x17 ; DATA_BYTE
01D0B1  00                    DB     0x00 ; DATA_BYTE
01D0B2  9A                    DB     0x9A ; DATA_BYTE
01D0B3  AB                    DB     0xAB ; DATA_BYTE
01D0B4  0D                    DB     0x0D ; DATA_BYTE
01D0B5  0D                    DB     0x0D ; DATA_BYTE
01D0B6  11                    DB     0x11 ; DATA_BYTE
01D0B7  EA                    DB     0xEA ; DATA_BYTE
01D0B8  8A                    DB     0x8A ; DATA_BYTE
01D0B9  09                    DB     0x09 ; DATA_BYTE
01D0BA  00                    DB     0x00 ; DATA_BYTE
01D0BB  00                    DB     0x00 ; DATA_BYTE
01D0BC  17                    DB     0x17 ; DATA_BYTE
01D0BD  00                    DB     0x00 ; DATA_BYTE
01D0BE  9A                    DB     0x9A ; DATA_BYTE
01D0BF  AB                    DB     0xAB ; DATA_BYTE
01D0C0  0D                    DB     0x0D ; DATA_BYTE
01D0C1  0D                    DB     0x0D ; DATA_BYTE
01D0C2  11                    DB     0x11 ; DATA_BYTE
01D0C3  EA                    DB     0xEA ; DATA_BYTE
01D0C4  44                    DB     0x44 ; DATA_BYTE
01D0C5  0D                    DB     0x0D ; DATA_BYTE
01D0C6  00                    DB     0x00 ; DATA_BYTE
01D0C7  00                    DB     0x00 ; DATA_BYTE
01D0C8  17                    DB     0x17 ; DATA_BYTE
01D0C9  00                    DB     0x00 ; DATA_BYTE
01D0CA  9A                    DB     0x9A ; DATA_BYTE
01D0CB  AB                    DB     0xAB ; DATA_BYTE
01D0CC  0D                    DB     0x0D ; DATA_BYTE
01D0CD  0D                    DB     0x0D ; DATA_BYTE
01D0CE  11                    DB     0x11 ; DATA_BYTE
01D0CF  EA                    DB     0xEA ; DATA_BYTE
01D0D0  BA                    DB     0xBA ; DATA_BYTE
01D0D1  09                    DB     0x09 ; DATA_BYTE
01D0D2  00                    DB     0x00 ; DATA_BYTE
01D0D3  00                    DB     0x00 ; DATA_BYTE
01D0D4  17                    DB     0x17 ; DATA_BYTE
01D0D5  00                    DB     0x00 ; DATA_BYTE
01D0D6  9A                    DB     0x9A ; DATA_BYTE
01D0D7  AB                    DB     0xAB ; DATA_BYTE
01D0D8  0D                    DB     0x0D ; DATA_BYTE
01D0D9  0D                    DB     0x0D ; DATA_BYTE
01D0DA  11                    DB     0x11 ; DATA_BYTE
01D0DB  EA                    DB     0xEA ; DATA_BYTE
01D0DC  46                    DB     0x46 ; DATA_BYTE
01D0DD  04                    DB     0x04 ; DATA_BYTE
01D0DE  00                    DB     0x00 ; DATA_BYTE
01D0DF  00                    DB     0x00 ; DATA_BYTE
01D0E0  17                    DB     0x17 ; DATA_BYTE
01D0E1  00                    DB     0x00 ; DATA_BYTE
01D0E2  9A                    DB     0x9A ; DATA_BYTE
01D0E3  AB                    DB     0xAB ; DATA_BYTE
01D0E4  0D                    DB     0x0D ; DATA_BYTE
01D0E5  0D                    DB     0x0D ; DATA_BYTE
01D0E6  11                    DB     0x11 ; DATA_BYTE
01D0E7  EA                    DB     0xEA ; DATA_BYTE
01D0E8  8E                    DB     0x8E ; DATA_BYTE
01D0E9  24                    DB     0x24 ; DATA_BYTE
01D0EA  00                    DB     0x00 ; DATA_BYTE
01D0EB  00                    DB     0x00 ; DATA_BYTE
01D0EC  17                    DB     0x17 ; DATA_BYTE
01D0ED  00                    DB     0x00 ; DATA_BYTE
01D0EE  9A                    DB     0x9A ; DATA_BYTE
01D0EF  AB                    DB     0xAB ; DATA_BYTE
01D0F0  0D                    DB     0x0D ; DATA_BYTE
01D0F1  0D                    DB     0x0D ; DATA_BYTE
01D0F2  11                    DB     0x11 ; DATA_BYTE
01D0F3  EA                    DB     0xEA ; DATA_BYTE
01D0F4  E8                    DB     0xE8 ; DATA_BYTE
01D0F5  0B                    DB     0x0B ; DATA_BYTE
01D0F6  00                    DB     0x00 ; DATA_BYTE
01D0F7  00                    DB     0x00 ; DATA_BYTE
01D0F8  17                    DB     0x17 ; DATA_BYTE
01D0F9  00                    DB     0x00 ; DATA_BYTE
01D0FA  9A                    DB     0x9A ; DATA_BYTE
01D0FB  AB                    DB     0xAB ; DATA_BYTE
01D0FC  0D                    DB     0x0D ; DATA_BYTE
01D0FD  0D                    DB     0x0D ; DATA_BYTE
01D0FE  11                    DB     0x11 ; DATA_BYTE
01D0FF  EA                    DB     0xEA ; DATA_BYTE
01D100  78                    DB     0x78 ; DATA_BYTE
01D101  1A                    DB     0x1A ; DATA_BYTE
01D102  00                    DB     0x00 ; DATA_BYTE
01D103  00                    DB     0x00 ; DATA_BYTE
01D104  17                    DB     0x17 ; DATA_BYTE
01D105  00                    DB     0x00 ; DATA_BYTE
01D106  9A                    DB     0x9A ; DATA_BYTE
01D107  AB                    DB     0xAB ; DATA_BYTE
01D108  0D                    DB     0x0D ; DATA_BYTE
01D109  0D                    DB     0x0D ; DATA_BYTE
01D10A  11                    DB     0x11 ; DATA_BYTE
01D10B  EA                    DB     0xEA ; DATA_BYTE
01D10C  B6                    DB     0xB6 ; DATA_BYTE
01D10D  01                    DB     0x01 ; DATA_BYTE
01D10E  00                    DB     0x00 ; DATA_BYTE
01D10F  00                    DB     0x00 ; DATA_BYTE
01D110  18                    DB     0x18 ; DATA_BYTE
01D111  00                    DB     0x00 ; DATA_BYTE
01D112  9A                    DB     0x9A ; DATA_BYTE
01D113  AB                    DB     0xAB ; DATA_BYTE
01D114  0D                    DB     0x0D ; DATA_BYTE
01D115  0D                    DB     0x0D ; DATA_BYTE
01D116  11                    DB     0x11 ; DATA_BYTE
01D117  EA                    DB     0xEA ; DATA_BYTE
01D118  C8                    DB     0xC8 ; DATA_BYTE
01D119  01                    DB     0x01 ; DATA_BYTE
01D11A  00                    DB     0x00 ; DATA_BYTE
01D11B  00                    DB     0x00 ; DATA_BYTE
01D11C  18                    DB     0x18 ; DATA_BYTE
01D11D  00                    DB     0x00 ; DATA_BYTE
01D11E  9A                    DB     0x9A ; DATA_BYTE
01D11F  AB                    DB     0xAB ; DATA_BYTE
01D120  0D                    DB     0x0D ; DATA_BYTE
01D121  0D                    DB     0x0D ; DATA_BYTE
01D122  11                    DB     0x11 ; DATA_BYTE
01D123  EA                    DB     0xEA ; DATA_BYTE
01D124  DA                    DB     0xDA ; DATA_BYTE
01D125  01                    DB     0x01 ; DATA_BYTE
01D126  00                    DB     0x00 ; DATA_BYTE
01D127  00                    DB     0x00 ; DATA_BYTE
01D128  18                    DB     0x18 ; DATA_BYTE
01D129  00                    DB     0x00 ; DATA_BYTE
01D12A  9A                    DB     0x9A ; DATA_BYTE
01D12B  91                    DB     0x91 ; DATA_BYTE
01D12C  0D                    DB     0x0D ; DATA_BYTE
01D12D  0D                    DB     0x0D ; DATA_BYTE
01D12E  11                    DB     0x11 ; DATA_BYTE
01D12F  EA                    DB     0xEA ; DATA_BYTE
01D130  0C                    DB     0x0C ; DATA_BYTE
01D131  00                    DB     0x00 ; DATA_BYTE
01D132  06                    DB     0x06 ; DATA_BYTE
01D133  0C                    DB     0x0C ; DATA_BYTE
01D134  9A                    DB     0x9A ; DATA_BYTE
01D135  91                    DB     0x91 ; DATA_BYTE
01D136  0D                    DB     0x0D ; DATA_BYTE
01D137  0D                    DB     0x0D ; DATA_BYTE
01D138  11                    DB     0x11 ; DATA_BYTE
01D139  EA                    DB     0xEA ; DATA_BYTE
01D13A  02                    DB     0x02 ; DATA_BYTE
01D13B  00                    DB     0x00 ; DATA_BYTE
01D13C  57                    DB     0x57 ; DATA_BYTE
01D13D  0B                    DB     0x0B ; DATA_BYTE
01D13E  9A                    DB     0x9A ; DATA_BYTE
01D13F  91                    DB     0x91 ; DATA_BYTE
01D140  0D                    DB     0x0D ; DATA_BYTE
01D141  0D                    DB     0x0D ; DATA_BYTE
01D142  11                    DB     0x11 ; DATA_BYTE
01D143  EA                    DB     0xEA ; DATA_BYTE
01D144  0E                    DB     0x0E ; DATA_BYTE
01D145  00                    DB     0x00 ; DATA_BYTE
01D146  FB                    DB     0xFB ; DATA_BYTE
01D147  0A                    DB     0x0A ; DATA_BYTE
01D148  9A                    DB     0x9A ; DATA_BYTE
01D149  AB                    DB     0xAB ; DATA_BYTE
01D14A  0D                    DB     0x0D ; DATA_BYTE
01D14B  0D                    DB     0x0D ; DATA_BYTE
01D14C  11                    DB     0x11 ; DATA_BYTE
01D14D  EA                    DB     0xEA ; DATA_BYTE
01D14E  3E                    DB     0x3E ; DATA_BYTE
01D14F  0B                    DB     0x0B ; DATA_BYTE
01D150  00                    DB     0x00 ; DATA_BYTE
01D151  00                    DB     0x00 ; DATA_BYTE
01D152  19                    DB     0x19 ; DATA_BYTE
01D153  00                    DB     0x00 ; DATA_BYTE
01D154  00                    DB     0x00 ; DATA_BYTE
01D155  00                    DB     0x00 ; DATA_BYTE
01D156  9A                    DB     0x9A ; DATA_BYTE
01D157  AB                    DB     0xAB ; DATA_BYTE
01D158  0D                    DB     0x0D ; DATA_BYTE
01D159  0D                    DB     0x0D ; DATA_BYTE
01D15A  11                    DB     0x11 ; DATA_BYTE
01D15B  EA                    DB     0xEA ; DATA_BYTE
01D15C  90                    DB     0x90 ; DATA_BYTE
01D15D  07                    DB     0x07 ; DATA_BYTE
01D15E  00                    DB     0x00 ; DATA_BYTE
01D15F  00                    DB     0x00 ; DATA_BYTE
01D160  19                    DB     0x19 ; DATA_BYTE
01D161  00                    DB     0x00 ; DATA_BYTE
01D162  00                    DB     0x00 ; DATA_BYTE
01D163  00                    DB     0x00 ; DATA_BYTE
01D164  9A                    DB     0x9A ; DATA_BYTE
01D165  AB                    DB     0xAB ; DATA_BYTE
01D166  0D                    DB     0x0D ; DATA_BYTE
01D167  0D                    DB     0x0D ; DATA_BYTE
01D168  11                    DB     0x11 ; DATA_BYTE
01D169  EA                    DB     0xEA ; DATA_BYTE
01D16A  2A                    DB     0x2A ; DATA_BYTE
01D16B  0C                    DB     0x0C ; DATA_BYTE
01D16C  00                    DB     0x00 ; DATA_BYTE
01D16D  00                    DB     0x00 ; DATA_BYTE
01D16E  19                    DB     0x19 ; DATA_BYTE
01D16F  00                    DB     0x00 ; DATA_BYTE
01D170  00                    DB     0x00 ; DATA_BYTE
01D171  00                    DB     0x00 ; DATA_BYTE
01D172  9A                    DB     0x9A ; DATA_BYTE
01D173  AB                    DB     0xAB ; DATA_BYTE
01D174  0D                    DB     0x0D ; DATA_BYTE
01D175  0D                    DB     0x0D ; DATA_BYTE
01D176  11                    DB     0x11 ; DATA_BYTE
01D177  EA                    DB     0xEA ; DATA_BYTE
01D178  00                    DB     0x00 ; DATA_BYTE
01D179  00                    DB     0x00 ; DATA_BYTE
01D17A  00                    DB     0x00 ; DATA_BYTE
01D17B  00                    DB     0x00 ; DATA_BYTE
01D17C  19                    DB     0x19 ; DATA_BYTE
01D17D  00                    DB     0x00 ; DATA_BYTE
01D17E  00                    DB     0x00 ; DATA_BYTE
01D17F  00                    DB     0x00 ; DATA_BYTE
01D180  9A                    DB     0x9A ; DATA_BYTE
01D181  AB                    DB     0xAB ; DATA_BYTE
01D182  0D                    DB     0x0D ; DATA_BYTE
01D183  0D                    DB     0x0D ; DATA_BYTE
01D184  11                    DB     0x11 ; DATA_BYTE
01D185  EA                    DB     0xEA ; DATA_BYTE
01D186  D0                    DB     0xD0 ; DATA_BYTE
01D187  04                    DB     0x04 ; DATA_BYTE
01D188  00                    DB     0x00 ; DATA_BYTE
01D189  00                    DB     0x00 ; DATA_BYTE
01D18A  19                    DB     0x19 ; DATA_BYTE
01D18B  00                    DB     0x00 ; DATA_BYTE
01D18C  00                    DB     0x00 ; DATA_BYTE
01D18D  00                    DB     0x00 ; DATA_BYTE
01D18E  9A                    DB     0x9A ; DATA_BYTE
01D18F  AB                    DB     0xAB ; DATA_BYTE
01D190  0D                    DB     0x0D ; DATA_BYTE
01D191  0D                    DB     0x0D ; DATA_BYTE
01D192  11                    DB     0x11 ; DATA_BYTE
01D193  EA                    DB     0xEA ; DATA_BYTE
01D194  2C                    DB     0x2C ; DATA_BYTE
01D195  00                    DB     0x00 ; DATA_BYTE
01D196  00                    DB     0x00 ; DATA_BYTE
01D197  00                    DB     0x00 ; DATA_BYTE
01D198  19                    DB     0x19 ; DATA_BYTE
01D199  00                    DB     0x00 ; DATA_BYTE
01D19A  00                    DB     0x00 ; DATA_BYTE
01D19B  00                    DB     0x00 ; DATA_BYTE
01D19C  9A                    DB     0x9A ; DATA_BYTE
01D19D  AB                    DB     0xAB ; DATA_BYTE
01D19E  0D                    DB     0x0D ; DATA_BYTE
01D19F  0D                    DB     0x0D ; DATA_BYTE
01D1A0  11                    DB     0x11 ; DATA_BYTE
01D1A1  EA                    DB     0xEA ; DATA_BYTE
01D1A2  12                    DB     0x12 ; DATA_BYTE
01D1A3  05                    DB     0x05 ; DATA_BYTE
01D1A4  00                    DB     0x00 ; DATA_BYTE
01D1A5  00                    DB     0x00 ; DATA_BYTE
01D1A6  19                    DB     0x19 ; DATA_BYTE
01D1A7  00                    DB     0x00 ; DATA_BYTE
01D1A8  00                    DB     0x00 ; DATA_BYTE
01D1A9  00                    DB     0x00 ; DATA_BYTE
01D1AA  9A                    DB     0x9A ; DATA_BYTE
01D1AB  AB                    DB     0xAB ; DATA_BYTE
01D1AC  0D                    DB     0x0D ; DATA_BYTE
01D1AD  0D                    DB     0x0D ; DATA_BYTE
01D1AE  11                    DB     0x11 ; DATA_BYTE
01D1AF  EA                    DB     0xEA ; DATA_BYTE
01D1B0  A4                    DB     0xA4 ; DATA_BYTE
01D1B1  01                    DB     0x01 ; DATA_BYTE
01D1B2  00                    DB     0x00 ; DATA_BYTE
01D1B3  00                    DB     0x00 ; DATA_BYTE
01D1B4  19                    DB     0x19 ; DATA_BYTE
01D1B5  00                    DB     0x00 ; DATA_BYTE
01D1B6  00                    DB     0x00 ; DATA_BYTE
01D1B7  00                    DB     0x00 ; DATA_BYTE
01D1B8  9A                    DB     0x9A ; DATA_BYTE
01D1B9  AB                    DB     0xAB ; DATA_BYTE
01D1BA  0D                    DB     0x0D ; DATA_BYTE
01D1BB  0D                    DB     0x0D ; DATA_BYTE
01D1BC  11                    DB     0x11 ; DATA_BYTE
01D1BD  EA                    DB     0xEA ; DATA_BYTE
01D1BE  92                    DB     0x92 ; DATA_BYTE
01D1BF  09                    DB     0x09 ; DATA_BYTE
01D1C0  00                    DB     0x00 ; DATA_BYTE
01D1C1  00                    DB     0x00 ; DATA_BYTE
01D1C2  19                    DB     0x19 ; DATA_BYTE
01D1C3  00                    DB     0x00 ; DATA_BYTE
01D1C4  00                    DB     0x00 ; DATA_BYTE
01D1C5  00                    DB     0x00 ; DATA_BYTE
01D1C6  9A                    DB     0x9A ; DATA_BYTE
01D1C7  AB                    DB     0xAB ; DATA_BYTE
01D1C8  0D                    DB     0x0D ; DATA_BYTE
01D1C9  0D                    DB     0x0D ; DATA_BYTE
01D1CA  11                    DB     0x11 ; DATA_BYTE
01D1CB  EA                    DB     0xEA ; DATA_BYTE
01D1CC  C6                    DB     0xC6 ; DATA_BYTE
01D1CD  09                    DB     0x09 ; DATA_BYTE
01D1CE  00                    DB     0x00 ; DATA_BYTE
01D1CF  00                    DB     0x00 ; DATA_BYTE
01D1D0  19                    DB     0x19 ; DATA_BYTE
01D1D1  00                    DB     0x00 ; DATA_BYTE
01D1D2  00                    DB     0x00 ; DATA_BYTE
01D1D3  00                    DB     0x00 ; DATA_BYTE
01D1D4  9A                    DB     0x9A ; DATA_BYTE
01D1D5  AB                    DB     0xAB ; DATA_BYTE
01D1D6  0D                    DB     0x0D ; DATA_BYTE
01D1D7  0D                    DB     0x0D ; DATA_BYTE
01D1D8  11                    DB     0x11 ; DATA_BYTE
01D1D9  EA                    DB     0xEA ; DATA_BYTE
01D1DA  70                    DB     0x70 ; DATA_BYTE
01D1DB  02                    DB     0x02 ; DATA_BYTE
01D1DC  00                    DB     0x00 ; DATA_BYTE
01D1DD  00                    DB     0x00 ; DATA_BYTE
01D1DE  19                    DB     0x19 ; DATA_BYTE
01D1DF  00                    DB     0x00 ; DATA_BYTE
01D1E0  00                    DB     0x00 ; DATA_BYTE
01D1E1  00                    DB     0x00 ; DATA_BYTE
01D1E2  9A                    DB     0x9A ; DATA_BYTE
01D1E3  AB                    DB     0xAB ; DATA_BYTE
01D1E4  0D                    DB     0x0D ; DATA_BYTE
01D1E5  0D                    DB     0x0D ; DATA_BYTE
01D1E6  11                    DB     0x11 ; DATA_BYTE
01D1E7  EA                    DB     0xEA ; DATA_BYTE
01D1E8  A4                    DB     0xA4 ; DATA_BYTE
01D1E9  06                    DB     0x06 ; DATA_BYTE
01D1EA  00                    DB     0x00 ; DATA_BYTE
01D1EB  00                    DB     0x00 ; DATA_BYTE
01D1EC  19                    DB     0x19 ; DATA_BYTE
01D1ED  00                    DB     0x00 ; DATA_BYTE
01D1EE  00                    DB     0x00 ; DATA_BYTE
01D1EF  00                    DB     0x00 ; DATA_BYTE
01D1F0  9A                    DB     0x9A ; DATA_BYTE
01D1F1  AB                    DB     0xAB ; DATA_BYTE
01D1F2  0D                    DB     0x0D ; DATA_BYTE
01D1F3  0D                    DB     0x0D ; DATA_BYTE
01D1F4  11                    DB     0x11 ; DATA_BYTE
01D1F5  EA                    DB     0xEA ; DATA_BYTE
01D1F6  0A                    DB     0x0A ; DATA_BYTE
01D1F7  00                    DB     0x00 ; DATA_BYTE
01D1F8  00                    DB     0x00 ; DATA_BYTE
01D1F9  00                    DB     0x00 ; DATA_BYTE
01D1FA  19                    DB     0x19 ; DATA_BYTE
01D1FB  00                    DB     0x00 ; DATA_BYTE
01D1FC  E7                    DB     0xE7 ; DATA_BYTE
01D1FD  00                    DB     0x00 ; DATA_BYTE
01D1FE  9A                    DB     0x9A ; DATA_BYTE
01D1FF  AB                    DB     0xAB ; DATA_BYTE
01D200  0D                    DB     0x0D ; DATA_BYTE
01D201  0D                    DB     0x0D ; DATA_BYTE
01D202  11                    DB     0x11 ; DATA_BYTE
01D203  EA                    DB     0xEA ; DATA_BYTE
01D204  0C                    DB     0x0C ; DATA_BYTE
01D205  00                    DB     0x00 ; DATA_BYTE
01D206  00                    DB     0x00 ; DATA_BYTE
01D207  00                    DB     0x00 ; DATA_BYTE
01D208  19                    DB     0x19 ; DATA_BYTE
01D209  00                    DB     0x00 ; DATA_BYTE
01D20A  E7                    DB     0xE7 ; DATA_BYTE
01D20B  00                    DB     0x00 ; DATA_BYTE
01D20C  9A                    DB     0x9A ; DATA_BYTE
01D20D  AB                    DB     0xAB ; DATA_BYTE
01D20E  0D                    DB     0x0D ; DATA_BYTE
01D20F  0D                    DB     0x0D ; DATA_BYTE
01D210  11                    DB     0x11 ; DATA_BYTE
01D211  EA                    DB     0xEA ; DATA_BYTE
01D212  54                    DB     0x54 ; DATA_BYTE
01D213  00                    DB     0x00 ; DATA_BYTE
01D214  00                    DB     0x00 ; DATA_BYTE
01D215  00                    DB     0x00 ; DATA_BYTE
01D216  19                    DB     0x19 ; DATA_BYTE
01D217  00                    DB     0x00 ; DATA_BYTE
01D218  E7                    DB     0xE7 ; DATA_BYTE
01D219  00                    DB     0x00 ; DATA_BYTE
01D21A  9A                    DB     0x9A ; DATA_BYTE
01D21B  AB                    DB     0xAB ; DATA_BYTE
01D21C  0D                    DB     0x0D ; DATA_BYTE
01D21D  0D                    DB     0x0D ; DATA_BYTE
01D21E  11                    DB     0x11 ; DATA_BYTE
01D21F  EA                    DB     0xEA ; DATA_BYTE
01D220  88                    DB     0x88 ; DATA_BYTE
01D221  01                    DB     0x01 ; DATA_BYTE
01D222  00                    DB     0x00 ; DATA_BYTE
01D223  00                    DB     0x00 ; DATA_BYTE
01D224  19                    DB     0x19 ; DATA_BYTE
01D225  00                    DB     0x00 ; DATA_BYTE
01D226  E7                    DB     0xE7 ; DATA_BYTE
01D227  00                    DB     0x00 ; DATA_BYTE
01D228  9A                    DB     0x9A ; DATA_BYTE
01D229  AB                    DB     0xAB ; DATA_BYTE
01D22A  0D                    DB     0x0D ; DATA_BYTE
01D22B  0D                    DB     0x0D ; DATA_BYTE
01D22C  11                    DB     0x11 ; DATA_BYTE
01D22D  EA                    DB     0xEA ; DATA_BYTE
01D22E  46                    DB     0x46 ; DATA_BYTE
01D22F  2D                    DB     0x2D ; DATA_BYTE
01D230  00                    DB     0x00 ; DATA_BYTE
01D231  00                    DB     0x00 ; DATA_BYTE
01D232  1A                    DB     0x1A ; DATA_BYTE
01D233  00                    DB     0x00 ; DATA_BYTE
01D234  1E                    DB     0x1E ; DATA_BYTE
01D235  01                    DB     0x01 ; DATA_BYTE
01D236  9A                    DB     0x9A ; DATA_BYTE
01D237  91                    DB     0x91 ; DATA_BYTE
01D238  0D                    DB     0x0D ; DATA_BYTE
01D239  0D                    DB     0x0D ; DATA_BYTE
01D23A  11                    DB     0x11 ; DATA_BYTE
01D23B  EA                    DB     0xEA ; DATA_BYTE
01D23C  04                    DB     0x04 ; DATA_BYTE
01D23D  00                    DB     0x00 ; DATA_BYTE
01D23E  85                    DB     0x85 ; DATA_BYTE
01D23F  10                    DB     0x10 ; DATA_BYTE
01D240  9A                    DB     0x9A ; DATA_BYTE
01D241  91                    DB     0x91 ; DATA_BYTE
01D242  0D                    DB     0x0D ; DATA_BYTE
01D243  0D                    DB     0x0D ; DATA_BYTE
01D244  11                    DB     0x11 ; DATA_BYTE
01D245  EA                    DB     0xEA ; DATA_BYTE
01D246  0C                    DB     0x0C ; DATA_BYTE
01D247  00                    DB     0x00 ; DATA_BYTE
01D248  5F                    DB     0x5F ; DATA_BYTE
01D249  10                    DB     0x10 ; DATA_BYTE
01D24A  9A                    DB     0x9A ; DATA_BYTE
01D24B  91                    DB     0x91 ; DATA_BYTE
01D24C  0D                    DB     0x0D ; DATA_BYTE
01D24D  0D                    DB     0x0D ; DATA_BYTE
01D24E  11                    DB     0x11 ; DATA_BYTE
01D24F  EA                    DB     0xEA ; DATA_BYTE
01D250  6E                    DB     0x6E ; DATA_BYTE
01D251  00                    DB     0x00 ; DATA_BYTE
01D252  3F                    DB     0x3F ; DATA_BYTE
01D253  0B                    DB     0x0B ; DATA_BYTE
01D254  9A                    DB     0x9A ; DATA_BYTE
01D255  AB                    DB     0xAB ; DATA_BYTE
01D256  0D                    DB     0x0D ; DATA_BYTE
01D257  0D                    DB     0x0D ; DATA_BYTE
01D258  11                    DB     0x11 ; DATA_BYTE
01D259  EA                    DB     0xEA ; DATA_BYTE
01D25A  22                    DB     0x22 ; DATA_BYTE
01D25B  01                    DB     0x01 ; DATA_BYTE
01D25C  00                    DB     0x00 ; DATA_BYTE
01D25D  00                    DB     0x00 ; DATA_BYTE
01D25E  19                    DB     0x19 ; DATA_BYTE
01D25F  00                    DB     0x00 ; DATA_BYTE
01D260  1B                    DB     0x1B ; DATA_BYTE
01D261  01                    DB     0x01 ; DATA_BYTE
01D262  9A                    DB     0x9A ; DATA_BYTE
01D263  AB                    DB     0xAB ; DATA_BYTE
01D264  0D                    DB     0x0D ; DATA_BYTE
01D265  0D                    DB     0x0D ; DATA_BYTE
01D266  11                    DB     0x11 ; DATA_BYTE
01D267  EA                    DB     0xEA ; DATA_BYTE
01D268  58                    DB     0x58 ; DATA_BYTE
01D269  00                    DB     0x00 ; DATA_BYTE
01D26A  00                    DB     0x00 ; DATA_BYTE
01D26B  00                    DB     0x00 ; DATA_BYTE
01D26C  19                    DB     0x19 ; DATA_BYTE
01D26D  00                    DB     0x00 ; DATA_BYTE
01D26E  1B                    DB     0x1B ; DATA_BYTE
01D26F  01                    DB     0x01 ; DATA_BYTE
01D270  9A                    DB     0x9A ; DATA_BYTE
01D271  AB                    DB     0xAB ; DATA_BYTE
01D272  0D                    DB     0x0D ; DATA_BYTE
01D273  0D                    DB     0x0D ; DATA_BYTE
01D274  11                    DB     0x11 ; DATA_BYTE
01D275  EA                    DB     0xEA ; DATA_BYTE
01D276  34                    DB     0x34 ; DATA_BYTE
01D277  04                    DB     0x04 ; DATA_BYTE
01D278  00                    DB     0x00 ; DATA_BYTE
01D279  00                    DB     0x00 ; DATA_BYTE
01D27A  19                    DB     0x19 ; DATA_BYTE
01D27B  00                    DB     0x00 ; DATA_BYTE
01D27C  1B                    DB     0x1B ; DATA_BYTE
01D27D  01                    DB     0x01 ; DATA_BYTE
01D27E  9A                    DB     0x9A ; DATA_BYTE
01D27F  AB                    DB     0xAB ; DATA_BYTE
01D280  0D                    DB     0x0D ; DATA_BYTE
01D281  0D                    DB     0x0D ; DATA_BYTE
01D282  11                    DB     0x11 ; DATA_BYTE
01D283  EA                    DB     0xEA ; DATA_BYTE
01D284  66                    DB     0x66 ; DATA_BYTE
01D285  01                    DB     0x01 ; DATA_BYTE
01D286  00                    DB     0x00 ; DATA_BYTE
01D287  00                    DB     0x00 ; DATA_BYTE
01D288  19                    DB     0x19 ; DATA_BYTE
01D289  00                    DB     0x00 ; DATA_BYTE
01D28A  1B                    DB     0x1B ; DATA_BYTE
01D28B  01                    DB     0x01 ; DATA_BYTE
01D28C  9A                    DB     0x9A ; DATA_BYTE
01D28D  AB                    DB     0xAB ; DATA_BYTE
01D28E  0D                    DB     0x0D ; DATA_BYTE
01D28F  0D                    DB     0x0D ; DATA_BYTE
01D290  11                    DB     0x11 ; DATA_BYTE
01D291  EA                    DB     0xEA ; DATA_BYTE
01D292  0C                    DB     0x0C ; DATA_BYTE
01D293  00                    DB     0x00 ; DATA_BYTE
01D294  00                    DB     0x00 ; DATA_BYTE
01D295  00                    DB     0x00 ; DATA_BYTE
01D296  1C                    DB     0x1C ; DATA_BYTE
01D297  00                    DB     0x00 ; DATA_BYTE
01D298  79                    DB     0x79 ; DATA_BYTE
01D299  00                    DB     0x00 ; DATA_BYTE
01D29A  9A                    DB     0x9A ; DATA_BYTE
01D29B  91                    DB     0x91 ; DATA_BYTE
01D29C  0D                    DB     0x0D ; DATA_BYTE
01D29D  0D                    DB     0x0D ; DATA_BYTE
01D29E  11                    DB     0x11 ; DATA_BYTE
01D29F  EA                    DB     0xEA ; DATA_BYTE
01D2A0  5C                    DB     0x5C ; DATA_BYTE
01D2A1  00                    DB     0x00 ; DATA_BYTE
01D2A2  32                    DB     0x32 ; DATA_BYTE
01D2A3  0B                    DB     0x0B ; DATA_BYTE
01D2A4  9A                    DB     0x9A ; DATA_BYTE
01D2A5  91                    DB     0x91 ; DATA_BYTE
01D2A6  0D                    DB     0x0D ; DATA_BYTE
01D2A7  0D                    DB     0x0D ; DATA_BYTE
01D2A8  11                    DB     0x11 ; DATA_BYTE
01D2A9  EA                    DB     0xEA ; DATA_BYTE
01D2AA  0E                    DB     0x0E ; DATA_BYTE
01D2AB  00                    DB     0x00 ; DATA_BYTE
01D2AC  01                    DB     0x01 ; DATA_BYTE
01D2AD  0B                    DB     0x0B ; DATA_BYTE
01D2AE  9A                    DB     0x9A ; DATA_BYTE
01D2AF  AB                    DB     0xAB ; DATA_BYTE
01D2B0  0D                    DB     0x0D ; DATA_BYTE
01D2B1  0D                    DB     0x0D ; DATA_BYTE
01D2B2  11                    DB     0x11 ; DATA_BYTE
01D2B3  EA                    DB     0xEA ; DATA_BYTE
01D2B4  BE                    DB     0xBE ; DATA_BYTE
01D2B5  0B                    DB     0x0B ; DATA_BYTE
01D2B6  00                    DB     0x00 ; DATA_BYTE
01D2B7  00                    DB     0x00 ; DATA_BYTE
01D2B8  1A                    DB     0x1A ; DATA_BYTE
01D2B9  00                    DB     0x00 ; DATA_BYTE
01D2BA  00                    DB     0x00 ; DATA_BYTE
01D2BB  00                    DB     0x00 ; DATA_BYTE
01D2BC  9A                    DB     0x9A ; DATA_BYTE
01D2BD  AB                    DB     0xAB ; DATA_BYTE
01D2BE  0D                    DB     0x0D ; DATA_BYTE
01D2BF  0D                    DB     0x0D ; DATA_BYTE
01D2C0  11                    DB     0x11 ; DATA_BYTE
01D2C1  EA                    DB     0xEA ; DATA_BYTE
01D2C2  0A                    DB     0x0A ; DATA_BYTE
01D2C3  0B                    DB     0x0B ; DATA_BYTE
01D2C4  00                    DB     0x00 ; DATA_BYTE
01D2C5  00                    DB     0x00 ; DATA_BYTE
01D2C6  1A                    DB     0x1A ; DATA_BYTE
01D2C7  00                    DB     0x00 ; DATA_BYTE
01D2C8  00                    DB     0x00 ; DATA_BYTE
01D2C9  00                    DB     0x00 ; DATA_BYTE
01D2CA  9A                    DB     0x9A ; DATA_BYTE
01D2CB  AB                    DB     0xAB ; DATA_BYTE
01D2CC  0D                    DB     0x0D ; DATA_BYTE
01D2CD  0D                    DB     0x0D ; DATA_BYTE
01D2CE  11                    DB     0x11 ; DATA_BYTE
01D2CF  EA                    DB     0xEA ; DATA_BYTE
01D2D0  08                    DB     0x08 ; DATA_BYTE
01D2D1  00                    DB     0x00 ; DATA_BYTE
01D2D2  00                    DB     0x00 ; DATA_BYTE
01D2D3  00                    DB     0x00 ; DATA_BYTE
01D2D4  1A                    DB     0x1A ; DATA_BYTE
01D2D5  00                    DB     0x00 ; DATA_BYTE
01D2D6  BE                    DB     0xBE ; DATA_BYTE
01D2D7  00                    DB     0x00 ; DATA_BYTE
01D2D8  9A                    DB     0x9A ; DATA_BYTE
01D2D9  AB                    DB     0xAB ; DATA_BYTE
01D2DA  0D                    DB     0x0D ; DATA_BYTE
01D2DB  0D                    DB     0x0D ; DATA_BYTE
01D2DC  11                    DB     0x11 ; DATA_BYTE
01D2DD  EA                    DB     0xEA ; DATA_BYTE
01D2DE  52                    DB     0x52 ; DATA_BYTE
01D2DF  00                    DB     0x00 ; DATA_BYTE
01D2E0  00                    DB     0x00 ; DATA_BYTE
01D2E1  00                    DB     0x00 ; DATA_BYTE
01D2E2  1A                    DB     0x1A ; DATA_BYTE
01D2E3  00                    DB     0x00 ; DATA_BYTE
01D2E4  BE                    DB     0xBE ; DATA_BYTE
01D2E5  00                    DB     0x00 ; DATA_BYTE
01D2E6  9A                    DB     0x9A ; DATA_BYTE
01D2E7  AB                    DB     0xAB ; DATA_BYTE
01D2E8  0D                    DB     0x0D ; DATA_BYTE
01D2E9  0D                    DB     0x0D ; DATA_BYTE
01D2EA  11                    DB     0x11 ; DATA_BYTE
01D2EB  EA                    DB     0xEA ; DATA_BYTE
01D2EC  88                    DB     0x88 ; DATA_BYTE
01D2ED  02                    DB     0x02 ; DATA_BYTE
01D2EE  00                    DB     0x00 ; DATA_BYTE
01D2EF  00                    DB     0x00 ; DATA_BYTE
01D2F0  1A                    DB     0x1A ; DATA_BYTE
01D2F1  00                    DB     0x00 ; DATA_BYTE
01D2F2  1E                    DB     0x1E ; DATA_BYTE
01D2F3  01                    DB     0x01 ; DATA_BYTE
01D2F4  9A                    DB     0x9A ; DATA_BYTE
01D2F5  AB                    DB     0xAB ; DATA_BYTE
01D2F6  0D                    DB     0x0D ; DATA_BYTE
01D2F7  0D                    DB     0x0D ; DATA_BYTE
01D2F8  11                    DB     0x11 ; DATA_BYTE
01D2F9  EA                    DB     0xEA ; DATA_BYTE
01D2FA  40                    DB     0x40 ; DATA_BYTE
01D2FB  08                    DB     0x08 ; DATA_BYTE
01D2FC  00                    DB     0x00 ; DATA_BYTE
01D2FD  00                    DB     0x00 ; DATA_BYTE
01D2FE  1A                    DB     0x1A ; DATA_BYTE
01D2FF  00                    DB     0x00 ; DATA_BYTE
01D300  1E                    DB     0x1E ; DATA_BYTE
01D301  01                    DB     0x01 ; DATA_BYTE
01D302  9A                    DB     0x9A ; DATA_BYTE
01D303  AB                    DB     0xAB ; DATA_BYTE
01D304  0D                    DB     0x0D ; DATA_BYTE
01D305  0D                    DB     0x0D ; DATA_BYTE
01D306  11                    DB     0x11 ; DATA_BYTE
01D307  EA                    DB     0xEA ; DATA_BYTE
01D308  40                    DB     0x40 ; DATA_BYTE
01D309  09                    DB     0x09 ; DATA_BYTE
01D30A  00                    DB     0x00 ; DATA_BYTE
01D30B  00                    DB     0x00 ; DATA_BYTE
01D30C  1A                    DB     0x1A ; DATA_BYTE
01D30D  00                    DB     0x00 ; DATA_BYTE
01D30E  1E                    DB     0x1E ; DATA_BYTE
01D30F  01                    DB     0x01 ; DATA_BYTE
01D310  9A                    DB     0x9A ; DATA_BYTE
01D311  AB                    DB     0xAB ; DATA_BYTE
01D312  0D                    DB     0x0D ; DATA_BYTE
01D313  0D                    DB     0x0D ; DATA_BYTE
01D314  11                    DB     0x11 ; DATA_BYTE
01D315  EA                    DB     0xEA ; DATA_BYTE
01D316  80                    DB     0x80 ; DATA_BYTE
01D317  13                    DB     0x13 ; DATA_BYTE
01D318  00                    DB     0x00 ; DATA_BYTE
01D319  00                    DB     0x00 ; DATA_BYTE
01D31A  1A                    DB     0x1A ; DATA_BYTE
01D31B  00                    DB     0x00 ; DATA_BYTE
01D31C  1E                    DB     0x1E ; DATA_BYTE
01D31D  01                    DB     0x01 ; DATA_BYTE
01D31E  9A                    DB     0x9A ; DATA_BYTE
01D31F  AB                    DB     0xAB ; DATA_BYTE
01D320  0D                    DB     0x0D ; DATA_BYTE
01D321  0D                    DB     0x0D ; DATA_BYTE
01D322  11                    DB     0x11 ; DATA_BYTE
01D323  EA                    DB     0xEA ; DATA_BYTE
01D324  DC                    DB     0xDC ; DATA_BYTE
01D325  13                    DB     0x13 ; DATA_BYTE
01D326  00                    DB     0x00 ; DATA_BYTE
01D327  00                    DB     0x00 ; DATA_BYTE
01D328  1A                    DB     0x1A ; DATA_BYTE
01D329  00                    DB     0x00 ; DATA_BYTE
01D32A  1E                    DB     0x1E ; DATA_BYTE
01D32B  01                    DB     0x01 ; DATA_BYTE
01D32C  9A                    DB     0x9A ; DATA_BYTE
01D32D  AB                    DB     0xAB ; DATA_BYTE
01D32E  0D                    DB     0x0D ; DATA_BYTE
01D32F  0D                    DB     0x0D ; DATA_BYTE
01D330  11                    DB     0x11 ; DATA_BYTE
01D331  EA                    DB     0xEA ; DATA_BYTE
01D332  AE                    DB     0xAE ; DATA_BYTE
01D333  10                    DB     0x10 ; DATA_BYTE
01D334  00                    DB     0x00 ; DATA_BYTE
01D335  00                    DB     0x00 ; DATA_BYTE
01D336  1A                    DB     0x1A ; DATA_BYTE
01D337  00                    DB     0x00 ; DATA_BYTE
01D338  1E                    DB     0x1E ; DATA_BYTE
01D339  01                    DB     0x01 ; DATA_BYTE
01D33A  9A                    DB     0x9A ; DATA_BYTE
01D33B  AB                    DB     0xAB ; DATA_BYTE
01D33C  0D                    DB     0x0D ; DATA_BYTE
01D33D  0D                    DB     0x0D ; DATA_BYTE
01D33E  11                    DB     0x11 ; DATA_BYTE
01D33F  EA                    DB     0xEA ; DATA_BYTE
01D340  18                    DB     0x18 ; DATA_BYTE
01D341  14                    DB     0x14 ; DATA_BYTE
01D342  00                    DB     0x00 ; DATA_BYTE
01D343  00                    DB     0x00 ; DATA_BYTE
01D344  1A                    DB     0x1A ; DATA_BYTE
01D345  00                    DB     0x00 ; DATA_BYTE
01D346  1E                    DB     0x1E ; DATA_BYTE
01D347  01                    DB     0x01 ; DATA_BYTE
01D348  9A                    DB     0x9A ; DATA_BYTE
01D349  AB                    DB     0xAB ; DATA_BYTE
01D34A  0D                    DB     0x0D ; DATA_BYTE
01D34B  0D                    DB     0x0D ; DATA_BYTE
01D34C  11                    DB     0x11 ; DATA_BYTE
01D34D  EA                    DB     0xEA ; DATA_BYTE
01D34E  04                    DB     0x04 ; DATA_BYTE
01D34F  02                    DB     0x02 ; DATA_BYTE
01D350  00                    DB     0x00 ; DATA_BYTE
01D351  00                    DB     0x00 ; DATA_BYTE
01D352  1A                    DB     0x1A ; DATA_BYTE
01D353  00                    DB     0x00 ; DATA_BYTE
01D354  1E                    DB     0x1E ; DATA_BYTE
01D355  01                    DB     0x01 ; DATA_BYTE
01D356  9A                    DB     0x9A ; DATA_BYTE
01D357  AB                    DB     0xAB ; DATA_BYTE
01D358  0D                    DB     0x0D ; DATA_BYTE
01D359  0D                    DB     0x0D ; DATA_BYTE
01D35A  11                    DB     0x11 ; DATA_BYTE
01D35B  EA                    DB     0xEA ; DATA_BYTE
01D35C  4C                    DB     0x4C ; DATA_BYTE
01D35D  14                    DB     0x14 ; DATA_BYTE
01D35E  00                    DB     0x00 ; DATA_BYTE
01D35F  00                    DB     0x00 ; DATA_BYTE
01D360  1A                    DB     0x1A ; DATA_BYTE
01D361  00                    DB     0x00 ; DATA_BYTE
01D362  1E                    DB     0x1E ; DATA_BYTE
01D363  01                    DB     0x01 ; DATA_BYTE
01D364  9A                    DB     0x9A ; DATA_BYTE
01D365  AB                    DB     0xAB ; DATA_BYTE
01D366  0D                    DB     0x0D ; DATA_BYTE
01D367  0D                    DB     0x0D ; DATA_BYTE
01D368  11                    DB     0x11 ; DATA_BYTE
01D369  EA                    DB     0xEA ; DATA_BYTE
01D36A  4C                    DB     0x4C ; DATA_BYTE
01D36B  02                    DB     0x02 ; DATA_BYTE
01D36C  00                    DB     0x00 ; DATA_BYTE
01D36D  00                    DB     0x00 ; DATA_BYTE
01D36E  1A                    DB     0x1A ; DATA_BYTE
01D36F  00                    DB     0x00 ; DATA_BYTE
01D370  1E                    DB     0x1E ; DATA_BYTE
01D371  01                    DB     0x01 ; DATA_BYTE
01D372  9A                    DB     0x9A ; DATA_BYTE
01D373  AB                    DB     0xAB ; DATA_BYTE
01D374  0D                    DB     0x0D ; DATA_BYTE
01D375  0D                    DB     0x0D ; DATA_BYTE
01D376  11                    DB     0x11 ; DATA_BYTE
01D377  EA                    DB     0xEA ; DATA_BYTE
01D378  70                    DB     0x70 ; DATA_BYTE
01D379  17                    DB     0x17 ; DATA_BYTE
01D37A  00                    DB     0x00 ; DATA_BYTE
01D37B  00                    DB     0x00 ; DATA_BYTE
01D37C  1A                    DB     0x1A ; DATA_BYTE
01D37D  00                    DB     0x00 ; DATA_BYTE
01D37E  1E                    DB     0x1E ; DATA_BYTE
01D37F  01                    DB     0x01 ; DATA_BYTE
01D380  9A                    DB     0x9A ; DATA_BYTE
01D381  AB                    DB     0xAB ; DATA_BYTE
01D382  0D                    DB     0x0D ; DATA_BYTE
01D383  0D                    DB     0x0D ; DATA_BYTE
01D384  11                    DB     0x11 ; DATA_BYTE
01D385  EA                    DB     0xEA ; DATA_BYTE
01D386  58                    DB     0x58 ; DATA_BYTE
01D387  27                    DB     0x27 ; DATA_BYTE
01D388  00                    DB     0x00 ; DATA_BYTE
01D389  00                    DB     0x00 ; DATA_BYTE
01D38A  1A                    DB     0x1A ; DATA_BYTE
01D38B  00                    DB     0x00 ; DATA_BYTE
01D38C  1E                    DB     0x1E ; DATA_BYTE
01D38D  01                    DB     0x01 ; DATA_BYTE
01D38E  9A                    DB     0x9A ; DATA_BYTE
01D38F  AB                    DB     0xAB ; DATA_BYTE
01D390  0D                    DB     0x0D ; DATA_BYTE
01D391  0D                    DB     0x0D ; DATA_BYTE
01D392  11                    DB     0x11 ; DATA_BYTE
01D393  EA                    DB     0xEA ; DATA_BYTE
01D394  6E                    DB     0x6E ; DATA_BYTE
01D395  27                    DB     0x27 ; DATA_BYTE
01D396  00                    DB     0x00 ; DATA_BYTE
01D397  00                    DB     0x00 ; DATA_BYTE
01D398  1A                    DB     0x1A ; DATA_BYTE
01D399  00                    DB     0x00 ; DATA_BYTE
01D39A  1E                    DB     0x1E ; DATA_BYTE
01D39B  01                    DB     0x01 ; DATA_BYTE
01D39C  9A                    DB     0x9A ; DATA_BYTE
01D39D  AB                    DB     0xAB ; DATA_BYTE
01D39E  0D                    DB     0x0D ; DATA_BYTE
01D39F  0D                    DB     0x0D ; DATA_BYTE
01D3A0  11                    DB     0x11 ; DATA_BYTE
01D3A1  EA                    DB     0xEA ; DATA_BYTE
01D3A2  78                    DB     0x78 ; DATA_BYTE
01D3A3  27                    DB     0x27 ; DATA_BYTE
01D3A4  00                    DB     0x00 ; DATA_BYTE
01D3A5  00                    DB     0x00 ; DATA_BYTE
01D3A6  1A                    DB     0x1A ; DATA_BYTE
01D3A7  00                    DB     0x00 ; DATA_BYTE
01D3A8  1E                    DB     0x1E ; DATA_BYTE
01D3A9  01                    DB     0x01 ; DATA_BYTE
01D3AA  9A                    DB     0x9A ; DATA_BYTE
01D3AB  AB                    DB     0xAB ; DATA_BYTE
01D3AC  0D                    DB     0x0D ; DATA_BYTE
01D3AD  0D                    DB     0x0D ; DATA_BYTE
01D3AE  11                    DB     0x11 ; DATA_BYTE
01D3AF  EA                    DB     0xEA ; DATA_BYTE
01D3B0  00                    DB     0x00 ; DATA_BYTE
01D3B1  00                    DB     0x00 ; DATA_BYTE
01D3B2  00                    DB     0x00 ; DATA_BYTE
01D3B3  00                    DB     0x00 ; DATA_BYTE
01D3B4  1A                    DB     0x1A ; DATA_BYTE
01D3B5  00                    DB     0x00 ; DATA_BYTE
01D3B6  1E                    DB     0x1E ; DATA_BYTE
01D3B7  01                    DB     0x01 ; DATA_BYTE
01D3B8  9A                    DB     0x9A ; DATA_BYTE
01D3B9  AB                    DB     0xAB ; DATA_BYTE
01D3BA  0D                    DB     0x0D ; DATA_BYTE
01D3BB  0D                    DB     0x0D ; DATA_BYTE
01D3BC  11                    DB     0x11 ; DATA_BYTE
01D3BD  EA                    DB     0xEA ; DATA_BYTE
01D3BE  24                    DB     0x24 ; DATA_BYTE
01D3BF  23                    DB     0x23 ; DATA_BYTE
01D3C0  00                    DB     0x00 ; DATA_BYTE
01D3C1  00                    DB     0x00 ; DATA_BYTE
01D3C2  1A                    DB     0x1A ; DATA_BYTE
01D3C3  00                    DB     0x00 ; DATA_BYTE
01D3C4  1E                    DB     0x1E ; DATA_BYTE
01D3C5  01                    DB     0x01 ; DATA_BYTE
01D3C6  9A                    DB     0x9A ; DATA_BYTE
01D3C7  AB                    DB     0xAB ; DATA_BYTE
01D3C8  0D                    DB     0x0D ; DATA_BYTE
01D3C9  0D                    DB     0x0D ; DATA_BYTE
01D3CA  11                    DB     0x11 ; DATA_BYTE
01D3CB  EA                    DB     0xEA ; DATA_BYTE
01D3CC  5C                    DB     0x5C ; DATA_BYTE
01D3CD  23                    DB     0x23 ; DATA_BYTE
01D3CE  00                    DB     0x00 ; DATA_BYTE
01D3CF  00                    DB     0x00 ; DATA_BYTE
01D3D0  1A                    DB     0x1A ; DATA_BYTE
01D3D1  00                    DB     0x00 ; DATA_BYTE
01D3D2  1E                    DB     0x1E ; DATA_BYTE
01D3D3  01                    DB     0x01 ; DATA_BYTE
01D3D4  9A                    DB     0x9A ; DATA_BYTE
01D3D5  91                    DB     0x91 ; DATA_BYTE
01D3D6  0D                    DB     0x0D ; DATA_BYTE
01D3D7  0D                    DB     0x0D ; DATA_BYTE
01D3D8  11                    DB     0x11 ; DATA_BYTE
01D3D9  EA                    DB     0xEA ; DATA_BYTE
01D3DA  40                    DB     0x40 ; DATA_BYTE
01D3DB  00                    DB     0x00 ; DATA_BYTE
01D3DC  2C                    DB     0x2C ; DATA_BYTE
01D3DD  0B                    DB     0x0B ; DATA_BYTE
01D3DE  9A                    DB     0x9A ; DATA_BYTE
01D3DF  91                    DB     0x91 ; DATA_BYTE
01D3E0  0D                    DB     0x0D ; DATA_BYTE
01D3E1  0D                    DB     0x0D ; DATA_BYTE
01D3E2  11                    DB     0x11 ; DATA_BYTE
01D3E3  EA                    DB     0xEA ; DATA_BYTE
01D3E4  04                    DB     0x04 ; DATA_BYTE
01D3E5  00                    DB     0x00 ; DATA_BYTE
01D3E6  2C                    DB     0x2C ; DATA_BYTE
01D3E7  0B                    DB     0x0B ; DATA_BYTE
01D3E8  9A                    DB     0x9A ; DATA_BYTE
01D3E9  91                    DB     0x91 ; DATA_BYTE
01D3EA  0D                    DB     0x0D ; DATA_BYTE
01D3EB  0D                    DB     0x0D ; DATA_BYTE
01D3EC  11                    DB     0x11 ; DATA_BYTE
01D3ED  EA                    DB     0xEA ; DATA_BYTE
01D3EE  06                    DB     0x06 ; DATA_BYTE
01D3EF  00                    DB     0x00 ; DATA_BYTE
01D3F0  D4                    DB     0xD4 ; DATA_BYTE
01D3F1  0B                    DB     0x0B ; DATA_BYTE
01D3F2  9A                    DB     0x9A ; DATA_BYTE
01D3F3  AB                    DB     0xAB ; DATA_BYTE
01D3F4  0D                    DB     0x0D ; DATA_BYTE
01D3F5  0D                    DB     0x0D ; DATA_BYTE
01D3F6  11                    DB     0x11 ; DATA_BYTE
01D3F7  EA                    DB     0xEA ; DATA_BYTE
01D3F8  02                    DB     0x02 ; DATA_BYTE
01D3F9  00                    DB     0x00 ; DATA_BYTE
01D3FA  00                    DB     0x00 ; DATA_BYTE
01D3FB  00                    DB     0x00 ; DATA_BYTE
01D3FC  1F                    DB     0x1F ; DATA_BYTE
01D3FD  00                    DB     0x00 ; DATA_BYTE
01D3FE  16                    DB     0x16 ; DATA_BYTE
01D3FF  00                    DB     0x00 ; DATA_BYTE
01D400  9A                    DB     0x9A ; DATA_BYTE
01D401  AB                    DB     0xAB ; DATA_BYTE
01D402  0D                    DB     0x0D ; DATA_BYTE
01D403  0D                    DB     0x0D ; DATA_BYTE
01D404  11                    DB     0x11 ; DATA_BYTE
01D405  EA                    DB     0xEA ; DATA_BYTE
01D406  22                    DB     0x22 ; DATA_BYTE
01D407  00                    DB     0x00 ; DATA_BYTE
01D408  00                    DB     0x00 ; DATA_BYTE
01D409  00                    DB     0x00 ; DATA_BYTE
01D40A  1B                    DB     0x1B ; DATA_BYTE
01D40B  00                    DB     0x00 ; DATA_BYTE
01D40C  00                    DB     0x00 ; DATA_BYTE
01D40D  00                    DB     0x00 ; DATA_BYTE
01D40E  9A                    DB     0x9A ; DATA_BYTE
01D40F  91                    DB     0x91 ; DATA_BYTE
01D410  0D                    DB     0x0D ; DATA_BYTE
01D411  0D                    DB     0x0D ; DATA_BYTE
01D412  11                    DB     0x11 ; DATA_BYTE
01D413  EA                    DB     0xEA ; DATA_BYTE
01D414  02                    DB     0x02 ; DATA_BYTE
01D415  00                    DB     0x00 ; DATA_BYTE
01D416  70                    DB     0x70 ; DATA_BYTE
01D417  0B                    DB     0x0B ; DATA_BYTE
01D418  9A                    DB     0x9A ; DATA_BYTE
01D419  AB                    DB     0xAB ; DATA_BYTE
01D41A  0D                    DB     0x0D ; DATA_BYTE
01D41B  0D                    DB     0x0D ; DATA_BYTE
01D41C  11                    DB     0x11 ; DATA_BYTE
01D41D  EA                    DB     0xEA ; DATA_BYTE
01D41E  0E                    DB     0x0E ; DATA_BYTE
01D41F  00                    DB     0x00 ; DATA_BYTE
01D420  00                    DB     0x00 ; DATA_BYTE
01D421  00                    DB     0x00 ; DATA_BYTE
01D422  1E                    DB     0x1E ; DATA_BYTE
01D423  00                    DB     0x00 ; DATA_BYTE
01D424  30                    DB     0x30 ; DATA_BYTE
01D425  00                    DB     0x00 ; DATA_BYTE
01D426  9A                    DB     0x9A ; DATA_BYTE
01D427  91                    DB     0x91 ; DATA_BYTE
01D428  0D                    DB     0x0D ; DATA_BYTE
01D429  0D                    DB     0x0D ; DATA_BYTE
01D42A  11                    DB     0x11 ; DATA_BYTE
01D42B  EA                    DB     0xEA ; DATA_BYTE
01D42C  04                    DB     0x04 ; DATA_BYTE
01D42D  00                    DB     0x00 ; DATA_BYTE
01D42E  8B                    DB     0x8B ; DATA_BYTE
01D42F  0B                    DB     0x0B ; DATA_BYTE
01D430  9A                    DB     0x9A ; DATA_BYTE
01D431  AB                    DB     0xAB ; DATA_BYTE
01D432  0D                    DB     0x0D ; DATA_BYTE
01D433  0D                    DB     0x0D ; DATA_BYTE
01D434  11                    DB     0x11 ; DATA_BYTE
01D435  EA                    DB     0xEA ; DATA_BYTE
01D436  6A                    DB     0x6A ; DATA_BYTE
01D437  00                    DB     0x00 ; DATA_BYTE
01D438  00                    DB     0x00 ; DATA_BYTE
01D439  00                    DB     0x00 ; DATA_BYTE
01D43A  1E                    DB     0x1E ; DATA_BYTE
01D43B  00                    DB     0x00 ; DATA_BYTE
01D43C  00                    DB     0x00 ; DATA_BYTE
01D43D  00                    DB     0x00 ; DATA_BYTE
01D43E  9A                    DB     0x9A ; DATA_BYTE
01D43F  AB                    DB     0xAB ; DATA_BYTE
01D440  0D                    DB     0x0D ; DATA_BYTE
01D441  0D                    DB     0x0D ; DATA_BYTE
01D442  11                    DB     0x11 ; DATA_BYTE
01D443  EA                    DB     0xEA ; DATA_BYTE
01D444  02                    DB     0x02 ; DATA_BYTE
01D445  00                    DB     0x00 ; DATA_BYTE
01D446  00                    DB     0x00 ; DATA_BYTE
01D447  00                    DB     0x00 ; DATA_BYTE
01D448  1E                    DB     0x1E ; DATA_BYTE
01D449  00                    DB     0x00 ; DATA_BYTE
01D44A  55                    DB     0x55 ; DATA_BYTE
01D44B  00                    DB     0x00 ; DATA_BYTE
01D44C  9A                    DB     0x9A ; DATA_BYTE
01D44D  AB                    DB     0xAB ; DATA_BYTE
01D44E  0D                    DB     0x0D ; DATA_BYTE
01D44F  0D                    DB     0x0D ; DATA_BYTE
01D450  11                    DB     0x11 ; DATA_BYTE
01D451  EA                    DB     0xEA ; DATA_BYTE
01D452  04                    DB     0x04 ; DATA_BYTE
01D453  00                    DB     0x00 ; DATA_BYTE
01D454  00                    DB     0x00 ; DATA_BYTE
01D455  00                    DB     0x00 ; DATA_BYTE
01D456  1E                    DB     0x1E ; DATA_BYTE
01D457  00                    DB     0x00 ; DATA_BYTE
01D458  51                    DB     0x51 ; DATA_BYTE
01D459  00                    DB     0x00 ; DATA_BYTE
01D45A  9A                    DB     0x9A ; DATA_BYTE
01D45B  AB                    DB     0xAB ; DATA_BYTE
01D45C  0D                    DB     0x0D ; DATA_BYTE
01D45D  0D                    DB     0x0D ; DATA_BYTE
01D45E  11                    DB     0x11 ; DATA_BYTE
01D45F  EA                    DB     0xEA ; DATA_BYTE
01D460  3A                    DB     0x3A ; DATA_BYTE
01D461  00                    DB     0x00 ; DATA_BYTE
01D462  00                    DB     0x00 ; DATA_BYTE
01D463  00                    DB     0x00 ; DATA_BYTE
01D464  1E                    DB     0x1E ; DATA_BYTE
01D465  00                    DB     0x00 ; DATA_BYTE
01D466  55                    DB     0x55 ; DATA_BYTE
01D467  00                    DB     0x00 ; DATA_BYTE
01D468  9A                    DB     0x9A ; DATA_BYTE
01D469  91                    DB     0x91 ; DATA_BYTE
01D46A  0D                    DB     0x0D ; DATA_BYTE
01D46B  0D                    DB     0x0D ; DATA_BYTE
01D46C  11                    DB     0x11 ; DATA_BYTE
01D46D  EA                    DB     0xEA ; DATA_BYTE
01D46E  04                    DB     0x04 ; DATA_BYTE
01D46F  00                    DB     0x00 ; DATA_BYTE
01D470  05                    DB     0x05 ; DATA_BYTE
01D471  0C                    DB     0x0C ; DATA_BYTE
01D472  9A                    DB     0x9A ; DATA_BYTE
01D473  AB                    DB     0xAB ; DATA_BYTE
01D474  0D                    DB     0x0D ; DATA_BYTE
01D475  0D                    DB     0x0D ; DATA_BYTE
01D476  11                    DB     0x11 ; DATA_BYTE
01D477  EA                    DB     0xEA ; DATA_BYTE
01D478  00                    DB     0x00 ; DATA_BYTE
01D479  00                    DB     0x00 ; DATA_BYTE
01D47A  00                    DB     0x00 ; DATA_BYTE
01D47B  00                    DB     0x00 ; DATA_BYTE
01D47C  1C                    DB     0x1C ; DATA_BYTE
01D47D  00                    DB     0x00 ; DATA_BYTE
01D47E  2B                    DB     0x2B ; DATA_BYTE
01D47F  00                    DB     0x00 ; DATA_BYTE
01D480  9A                    DB     0x9A ; DATA_BYTE
01D481  AB                    DB     0xAB ; DATA_BYTE
01D482  0D                    DB     0x0D ; DATA_BYTE
01D483  0D                    DB     0x0D ; DATA_BYTE
01D484  11                    DB     0x11 ; DATA_BYTE
01D485  EA                    DB     0xEA ; DATA_BYTE
01D486  22                    DB     0x22 ; DATA_BYTE
01D487  00                    DB     0x00 ; DATA_BYTE
01D488  00                    DB     0x00 ; DATA_BYTE
01D489  00                    DB     0x00 ; DATA_BYTE
01D48A  1F                    DB     0x1F ; DATA_BYTE
01D48B  00                    DB     0x00 ; DATA_BYTE
01D48C  21                    DB     0x21 ; DATA_BYTE
01D48D  00                    DB     0x00 ; DATA_BYTE
01D48E  9A                    DB     0x9A ; DATA_BYTE
01D48F  AB                    DB     0xAB ; DATA_BYTE
01D490  0D                    DB     0x0D ; DATA_BYTE
01D491  0D                    DB     0x0D ; DATA_BYTE
01D492  11                    DB     0x11 ; DATA_BYTE
01D493  EA                    DB     0xEA ; DATA_BYTE
01D494  00                    DB     0x00 ; DATA_BYTE
01D495  00                    DB     0x00 ; DATA_BYTE
01D496  00                    DB     0x00 ; DATA_BYTE
01D497  00                    DB     0x00 ; DATA_BYTE
01D498  1C                    DB     0x1C ; DATA_BYTE
01D499  00                    DB     0x00 ; DATA_BYTE
01D49A  00                    DB     0x00 ; DATA_BYTE
01D49B  00                    DB     0x00 ; DATA_BYTE
01D49C  9A                    DB     0x9A ; DATA_BYTE
01D49D  AB                    DB     0xAB ; DATA_BYTE
01D49E  0D                    DB     0x0D ; DATA_BYTE
01D49F  0D                    DB     0x0D ; DATA_BYTE
01D4A0  11                    DB     0x11 ; DATA_BYTE
01D4A1  EA                    DB     0xEA ; DATA_BYTE
01D4A2  1C                    DB     0x1C ; DATA_BYTE
01D4A3  02                    DB     0x02 ; DATA_BYTE
01D4A4  00                    DB     0x00 ; DATA_BYTE
01D4A5  00                    DB     0x00 ; DATA_BYTE
01D4A6  1C                    DB     0x1C ; DATA_BYTE
01D4A7  00                    DB     0x00 ; DATA_BYTE
01D4A8  00                    DB     0x00 ; DATA_BYTE
01D4A9  00                    DB     0x00 ; DATA_BYTE
01D4AA  9A                    DB     0x9A ; DATA_BYTE
01D4AB  AB                    DB     0xAB ; DATA_BYTE
01D4AC  0D                    DB     0x0D ; DATA_BYTE
01D4AD  0D                    DB     0x0D ; DATA_BYTE
01D4AE  11                    DB     0x11 ; DATA_BYTE
01D4AF  EA                    DB     0xEA ; DATA_BYTE
01D4B0  4A                    DB     0x4A ; DATA_BYTE
01D4B1  00                    DB     0x00 ; DATA_BYTE
01D4B2  00                    DB     0x00 ; DATA_BYTE
01D4B3  00                    DB     0x00 ; DATA_BYTE
01D4B4  1C                    DB     0x1C ; DATA_BYTE
01D4B5  00                    DB     0x00 ; DATA_BYTE
01D4B6  46                    DB     0x46 ; DATA_BYTE
01D4B7  00                    DB     0x00 ; DATA_BYTE
01D4B8  9A                    DB     0x9A ; DATA_BYTE
01D4B9  AB                    DB     0xAB ; DATA_BYTE
01D4BA  0D                    DB     0x0D ; DATA_BYTE
01D4BB  0D                    DB     0x0D ; DATA_BYTE
01D4BC  11                    DB     0x11 ; DATA_BYTE
01D4BD  EA                    DB     0xEA ; DATA_BYTE
01D4BE  14                    DB     0x14 ; DATA_BYTE
01D4BF  00                    DB     0x00 ; DATA_BYTE
01D4C0  00                    DB     0x00 ; DATA_BYTE
01D4C1  00                    DB     0x00 ; DATA_BYTE
01D4C2  1C                    DB     0x1C ; DATA_BYTE
01D4C3  00                    DB     0x00 ; DATA_BYTE
01D4C4  46                    DB     0x46 ; DATA_BYTE
01D4C5  00                    DB     0x00 ; DATA_BYTE
01D4C6  9A                    DB     0x9A ; DATA_BYTE
01D4C7  AB                    DB     0xAB ; DATA_BYTE
01D4C8  0D                    DB     0x0D ; DATA_BYTE
01D4C9  0D                    DB     0x0D ; DATA_BYTE
01D4CA  11                    DB     0x11 ; DATA_BYTE
01D4CB  EA                    DB     0xEA ; DATA_BYTE
01D4CC  0A                    DB     0x0A ; DATA_BYTE
01D4CD  00                    DB     0x00 ; DATA_BYTE
01D4CE  00                    DB     0x00 ; DATA_BYTE
01D4CF  00                    DB     0x00 ; DATA_BYTE
01D4D0  1C                    DB     0x1C ; DATA_BYTE
01D4D1  00                    DB     0x00 ; DATA_BYTE
01D4D2  46                    DB     0x46 ; DATA_BYTE
01D4D3  00                    DB     0x00 ; DATA_BYTE
01D4D4  9A                    DB     0x9A ; DATA_BYTE
01D4D5  AB                    DB     0xAB ; DATA_BYTE
01D4D6  0D                    DB     0x0D ; DATA_BYTE
01D4D7  0D                    DB     0x0D ; DATA_BYTE
01D4D8  11                    DB     0x11 ; DATA_BYTE
01D4D9  EA                    DB     0xEA ; DATA_BYTE
01D4DA  82                    DB     0x82 ; DATA_BYTE
01D4DB  00                    DB     0x00 ; DATA_BYTE
01D4DC  00                    DB     0x00 ; DATA_BYTE
01D4DD  00                    DB     0x00 ; DATA_BYTE
01D4DE  1C                    DB     0x1C ; DATA_BYTE
01D4DF  00                    DB     0x00 ; DATA_BYTE
01D4E0  8A                    DB     0x8A ; DATA_BYTE
01D4E1  00                    DB     0x00 ; DATA_BYTE
01D4E2  9A                    DB     0x9A ; DATA_BYTE
01D4E3  91                    DB     0x91 ; DATA_BYTE
01D4E4  0D                    DB     0x0D ; DATA_BYTE
01D4E5  0D                    DB     0x0D ; DATA_BYTE
01D4E6  11                    DB     0x11 ; DATA_BYTE
01D4E7  EA                    DB     0xEA ; DATA_BYTE
01D4E8  02                    DB     0x02 ; DATA_BYTE
01D4E9  00                    DB     0x00 ; DATA_BYTE
01D4EA  7C                    DB     0x7C ; DATA_BYTE
01D4EB  10                    DB     0x10 ; DATA_BYTE
01D4EC  9A                    DB     0x9A ; DATA_BYTE
01D4ED  91                    DB     0x91 ; DATA_BYTE
01D4EE  0D                    DB     0x0D ; DATA_BYTE
01D4EF  0D                    DB     0x0D ; DATA_BYTE
01D4F0  11                    DB     0x11 ; DATA_BYTE
01D4F1  EA                    DB     0xEA ; DATA_BYTE
01D4F2  0A                    DB     0x0A ; DATA_BYTE
01D4F3  00                    DB     0x00 ; DATA_BYTE
01D4F4  6D                    DB     0x6D ; DATA_BYTE
01D4F5  10                    DB     0x10 ; DATA_BYTE
01D4F6  9A                    DB     0x9A ; DATA_BYTE
01D4F7  91                    DB     0x91 ; DATA_BYTE
01D4F8  0D                    DB     0x0D ; DATA_BYTE
01D4F9  0D                    DB     0x0D ; DATA_BYTE
01D4FA  11                    DB     0x11 ; DATA_BYTE
01D4FB  EA                    DB     0xEA ; DATA_BYTE
01D4FC  08                    DB     0x08 ; DATA_BYTE
01D4FD  00                    DB     0x00 ; DATA_BYTE
01D4FE  74                    DB     0x74 ; DATA_BYTE
01D4FF  10                    DB     0x10 ; DATA_BYTE
01D500  9A                    DB     0x9A ; DATA_BYTE
01D501  91                    DB     0x91 ; DATA_BYTE
01D502  0D                    DB     0x0D ; DATA_BYTE
01D503  0D                    DB     0x0D ; DATA_BYTE
01D504  11                    DB     0x11 ; DATA_BYTE
01D505  EA                    DB     0xEA ; DATA_BYTE
01D506  06                    DB     0x06 ; DATA_BYTE
01D507  00                    DB     0x00 ; DATA_BYTE
01D508  66                    DB     0x66 ; DATA_BYTE
01D509  10                    DB     0x10 ; DATA_BYTE
01D50A  9A                    DB     0x9A ; DATA_BYTE
01D50B  AB                    DB     0xAB ; DATA_BYTE
01D50C  0D                    DB     0x0D ; DATA_BYTE
01D50D  0D                    DB     0x0D ; DATA_BYTE
01D50E  11                    DB     0x11 ; DATA_BYTE
01D50F  EA                    DB     0xEA ; DATA_BYTE
01D510  A4                    DB     0xA4 ; DATA_BYTE
01D511  00                    DB     0x00 ; DATA_BYTE
01D512  00                    DB     0x00 ; DATA_BYTE
01D513  00                    DB     0x00 ; DATA_BYTE
01D514  1D                    DB     0x1D ; DATA_BYTE
01D515  00                    DB     0x00 ; DATA_BYTE
01D516  9A                    DB     0x9A ; DATA_BYTE
01D517  91                    DB     0x91 ; DATA_BYTE
01D518  0D                    DB     0x0D ; DATA_BYTE
01D519  0D                    DB     0x0D ; DATA_BYTE
01D51A  11                    DB     0x11 ; DATA_BYTE
01D51B  EA                    DB     0xEA ; DATA_BYTE
01D51C  0C                    DB     0x0C ; DATA_BYTE
01D51D  00                    DB     0x00 ; DATA_BYTE
01D51E  88                    DB     0x88 ; DATA_BYTE
01D51F  10                    DB     0x10 ; DATA_BYTE
01D520  9A                    DB     0x9A ; DATA_BYTE
01D521  AB                    DB     0xAB ; DATA_BYTE
01D522  0D                    DB     0x0D ; DATA_BYTE
01D523  0D                    DB     0x0D ; DATA_BYTE
01D524  11                    DB     0x11 ; DATA_BYTE
01D525  EA                    DB     0xEA ; DATA_BYTE
01D526  00                    DB     0x00 ; DATA_BYTE
01D527  00                    DB     0x00 ; DATA_BYTE
01D528  00                    DB     0x00 ; DATA_BYTE
01D529  00                    DB     0x00 ; DATA_BYTE
01D52A  1E                    DB     0x1E ; DATA_BYTE
01D52B  00                    DB     0x00 ; DATA_BYTE
01D52C  00                    DB     0x00 ; DATA_BYTE
01D52D  00                    DB     0x00 ; DATA_BYTE
01D52E  9A                    DB     0x9A ; DATA_BYTE
01D52F  AB                    DB     0xAB ; DATA_BYTE
01D530  0D                    DB     0x0D ; DATA_BYTE
01D531  0D                    DB     0x0D ; DATA_BYTE
01D532  11                    DB     0x11 ; DATA_BYTE
01D533  EA                    DB     0xEA ; DATA_BYTE
01D534  02                    DB     0x02 ; DATA_BYTE
01D535  00                    DB     0x00 ; DATA_BYTE
01D536  00                    DB     0x00 ; DATA_BYTE
01D537  00                    DB     0x00 ; DATA_BYTE
01D538  1E                    DB     0x1E ; DATA_BYTE
01D539  00                    DB     0x00 ; DATA_BYTE
01D53A  37                    DB     0x37 ; DATA_BYTE
01D53B  00                    DB     0x00 ; DATA_BYTE
01D53C  9A                    DB     0x9A ; DATA_BYTE
01D53D  91                    DB     0x91 ; DATA_BYTE
01D53E  0D                    DB     0x0D ; DATA_BYTE
01D53F  0D                    DB     0x0D ; DATA_BYTE
01D540  11                    DB     0x11 ; DATA_BYTE
01D541  EA                    DB     0xEA ; DATA_BYTE
01D542  06                    DB     0x06 ; DATA_BYTE
01D543  01                    DB     0x01 ; DATA_BYTE
01D544  47                    DB     0x47 ; DATA_BYTE
01D545  10                    DB     0x10 ; DATA_BYTE
01D546  9A                    DB     0x9A ; DATA_BYTE
01D547  91                    DB     0x91 ; DATA_BYTE
01D548  0D                    DB     0x0D ; DATA_BYTE
01D549  0D                    DB     0x0D ; DATA_BYTE
01D54A  11                    DB     0x11 ; DATA_BYTE
01D54B  EA                    DB     0xEA ; DATA_BYTE
01D54C  06                    DB     0x06 ; DATA_BYTE
01D54D  00                    DB     0x00 ; DATA_BYTE
01D54E  59                    DB     0x59 ; DATA_BYTE
01D54F  10                    DB     0x10 ; DATA_BYTE
01D550  9A                    DB     0x9A ; DATA_BYTE
01D551  91                    DB     0x91 ; DATA_BYTE
01D552  0D                    DB     0x0D ; DATA_BYTE
01D553  0D                    DB     0x0D ; DATA_BYTE
01D554  11                    DB     0x11 ; DATA_BYTE
01D555  EA                    DB     0xEA ; DATA_BYTE
01D556  B8                    DB     0xB8 ; DATA_BYTE
01D557  00                    DB     0x00 ; DATA_BYTE
01D558  47                    DB     0x47 ; DATA_BYTE
01D559  10                    DB     0x10 ; DATA_BYTE
01D55A  9A                    DB     0x9A ; DATA_BYTE
01D55B  91                    DB     0x91 ; DATA_BYTE
01D55C  0D                    DB     0x0D ; DATA_BYTE
01D55D  0D                    DB     0x0D ; DATA_BYTE
01D55E  11                    DB     0x11 ; DATA_BYTE
01D55F  EA                    DB     0xEA ; DATA_BYTE
01D560  0A                    DB     0x0A ; DATA_BYTE
01D561  00                    DB     0x00 ; DATA_BYTE
01D562  47                    DB     0x47 ; DATA_BYTE
01D563  10                    DB     0x10 ; DATA_BYTE
01D564  9A                    DB     0x9A ; DATA_BYTE
01D565  91                    DB     0x91 ; DATA_BYTE
01D566  0D                    DB     0x0D ; DATA_BYTE
01D567  0D                    DB     0x0D ; DATA_BYTE
01D568  11                    DB     0x11 ; DATA_BYTE
01D569  EA                    DB     0xEA ; DATA_BYTE
01D56A  E9                    DB     0xE9 ; DATA_BYTE
01D56B  00                    DB     0x00 ; DATA_BYTE
01D56C  47                    DB     0x47 ; DATA_BYTE
01D56D  10                    DB     0x10 ; DATA_BYTE
01D56E  9A                    DB     0x9A ; DATA_BYTE
01D56F  AB                    DB     0xAB ; DATA_BYTE
01D570  0D                    DB     0x0D ; DATA_BYTE
01D571  0D                    DB     0x0D ; DATA_BYTE
01D572  11                    DB     0x11 ; DATA_BYTE
01D573  EA                    DB     0xEA ; DATA_BYTE
01D574  0E                    DB     0x0E ; DATA_BYTE
01D575  00                    DB     0x00 ; DATA_BYTE
01D576  00                    DB     0x00 ; DATA_BYTE
01D577  00                    DB     0x00 ; DATA_BYTE
01D578  1F                    DB     0x1F ; DATA_BYTE
01D579  00                    DB     0x00 ; DATA_BYTE
01D57A  1D                    DB     0x1D ; DATA_BYTE
01D57B  00                    DB     0x00 ; DATA_BYTE
01D57C  9A                    DB     0x9A ; DATA_BYTE
01D57D  91                    DB     0x91 ; DATA_BYTE
01D57E  0D                    DB     0x0D ; DATA_BYTE
01D57F  0D                    DB     0x0D ; DATA_BYTE
01D580  11                    DB     0x11 ; DATA_BYTE
01D581  EA                    DB     0xEA ; DATA_BYTE
01D582  E0                    DB     0xE0 ; DATA_BYTE
01D583  00                    DB     0x00 ; DATA_BYTE
01D584  DD                    DB     0xDD ; DATA_BYTE
01D585  0B                    DB     0x0B ; DATA_BYTE
01D586  9A                    DB     0x9A ; DATA_BYTE
01D587  91                    DB     0x91 ; DATA_BYTE
01D588  0D                    DB     0x0D ; DATA_BYTE
01D589  0D                    DB     0x0D ; DATA_BYTE
01D58A  11                    DB     0x11 ; DATA_BYTE
01D58B  EA                    DB     0xEA ; DATA_BYTE
01D58C  02                    DB     0x02 ; DATA_BYTE
01D58D  00                    DB     0x00 ; DATA_BYTE
01D58E  DD                    DB     0xDD ; DATA_BYTE
01D58F  0B                    DB     0x0B ; DATA_BYTE
01D590  9A                    DB     0x9A ; DATA_BYTE
01D591  AB                    DB     0xAB ; DATA_BYTE
01D592  0D                    DB     0x0D ; DATA_BYTE
01D593  0D                    DB     0x0D ; DATA_BYTE
01D594  11                    DB     0x11 ; DATA_BYTE
01D595  EA                    DB     0xEA ; DATA_BYTE
01D596  3C                    DB     0x3C ; DATA_BYTE
01D597  00                    DB     0x00 ; DATA_BYTE
01D598  00                    DB     0x00 ; DATA_BYTE
01D599  00                    DB     0x00 ; DATA_BYTE
01D59A  1F                    DB     0x1F ; DATA_BYTE
01D59B  00                    DB     0x00 ; DATA_BYTE
01D59C  16                    DB     0x16 ; DATA_BYTE
01D59D  00                    DB     0x00 ; DATA_BYTE
01D59E  9A                    DB     0x9A ; DATA_BYTE
01D59F  AB                    DB     0xAB ; DATA_BYTE
01D5A0  0D                    DB     0x0D ; DATA_BYTE
01D5A1  0D                    DB     0x0D ; DATA_BYTE
01D5A2  11                    DB     0x11 ; DATA_BYTE
01D5A3  EA                    DB     0xEA ; DATA_BYTE
01D5A4  06                    DB     0x06 ; DATA_BYTE
01D5A5  00                    DB     0x00 ; DATA_BYTE
01D5A6  00                    DB     0x00 ; DATA_BYTE
01D5A7  00                    DB     0x00 ; DATA_BYTE
01D5A8  1F                    DB     0x1F ; DATA_BYTE
01D5A9  00                    DB     0x00 ; DATA_BYTE
01D5AA  21                    DB     0x21 ; DATA_BYTE
01D5AB  00                    DB     0x00 ; DATA_BYTE
01D5AC  9A                    DB     0x9A ; DATA_BYTE
01D5AD  91                    DB     0x91 ; DATA_BYTE
01D5AE  0D                    DB     0x0D ; DATA_BYTE
01D5AF  0D                    DB     0x0D ; DATA_BYTE
01D5B0  11                    DB     0x11 ; DATA_BYTE
01D5B1  EA                    DB     0xEA ; DATA_BYTE
01D5B2  0E                    DB     0x0E ; DATA_BYTE
01D5B3  00                    DB     0x00 ; DATA_BYTE
01D5B4  00                    DB     0x00 ; DATA_BYTE
01D5B5  11                    DB     0x11 ; DATA_BYTE
01D5B6  9A                    DB     0x9A ; DATA_BYTE
01D5B7  AB                    DB     0xAB ; DATA_BYTE
01D5B8  0D                    DB     0x0D ; DATA_BYTE
01D5B9  0D                    DB     0x0D ; DATA_BYTE
01D5BA  11                    DB     0x11 ; DATA_BYTE
01D5BB  EA                    DB     0xEA ; DATA_BYTE
01D5BC  02                    DB     0x02 ; DATA_BYTE
01D5BD  00                    DB     0x00 ; DATA_BYTE
01D5BE  00                    DB     0x00 ; DATA_BYTE
01D5BF  00                    DB     0x00 ; DATA_BYTE
01D5C0  1F                    DB     0x1F ; DATA_BYTE
01D5C1  00                    DB     0x00 ; DATA_BYTE
01D5C2  4B                    DB     0x4B ; DATA_BYTE
01D5C3  00                    DB     0x00 ; DATA_BYTE
01D5C4  9A                    DB     0x9A ; DATA_BYTE
01D5C5  91                    DB     0x91 ; DATA_BYTE
01D5C6  0D                    DB     0x0D ; DATA_BYTE
01D5C7  0D                    DB     0x0D ; DATA_BYTE
01D5C8  11                    DB     0x11 ; DATA_BYTE
01D5C9  EA                    DB     0xEA ; DATA_BYTE
01D5CA  4C                    DB     0x4C ; DATA_BYTE
01D5CB  00                    DB     0x00 ; DATA_BYTE
01D5CC  03                    DB     0x03 ; DATA_BYTE
01D5CD  11                    DB     0x11 ; DATA_BYTE
01D5CE  9A                    DB     0x9A ; DATA_BYTE
01D5CF  91                    DB     0x91 ; DATA_BYTE
01D5D0  0D                    DB     0x0D ; DATA_BYTE
01D5D1  0D                    DB     0x0D ; DATA_BYTE
01D5D2  11                    DB     0x11 ; DATA_BYTE
01D5D3  EA                    DB     0xEA ; DATA_BYTE
01D5D4  0A                    DB     0x0A ; DATA_BYTE
01D5D5  00                    DB     0x00 ; DATA_BYTE
01D5D6  03                    DB     0x03 ; DATA_BYTE
01D5D7  11                    DB     0x11 ; DATA_BYTE
01D5D8  9A                    DB     0x9A ; DATA_BYTE
01D5D9  AB                    DB     0xAB ; DATA_BYTE
01D5DA  0D                    DB     0x0D ; DATA_BYTE
01D5DB  0D                    DB     0x0D ; DATA_BYTE
01D5DC  11                    DB     0x11 ; DATA_BYTE
01D5DD  EA                    DB     0xEA ; DATA_BYTE
01D5DE  04                    DB     0x04 ; DATA_BYTE
01D5DF  00                    DB     0x00 ; DATA_BYTE
01D5E0  00                    DB     0x00 ; DATA_BYTE
01D5E1  00                    DB     0x00 ; DATA_BYTE
01D5E2  1C                    DB     0x1C ; DATA_BYTE
01D5E3  00                    DB     0x00 ; DATA_BYTE
01D5E4  8A                    DB     0x8A ; DATA_BYTE
01D5E5  00                    DB     0x00 ; DATA_BYTE
