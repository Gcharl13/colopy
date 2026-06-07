; ============================================================================
; func_0164A2_rtlink_segment_lookup
; Region   : load_image
; Bytes    : file 0x0164A2..0x0164DD  (59 bytes)
; Purpose  : Dispatcher that, given the saved CS:IP of the LCALL site, walks 6 storage-class helpers to determine where the requested overlay segment lives (in memory, EMS, XMS, or on disk) and patches the LJMP's segment word accordingly. Reads the saved IP from cs:[0x397D], subtracts 5 to back up to the LCALL's address (where the immediately-following LJMP's seg:off operand lives at IP+1..IP+4 of the LJMP), saves at cs:[0x3981]. Loads ES:DI from caller-supplied [bp+0x18]; if ES is already 0x110D the lookup is a self-call to the runtime and returns immediately. Otherwise calls the chain of 6 storage-class helpers (0x164FE, 0x164E8, 0x16564, 0x16516, 0x16837, 0x167F2). Each helper returns CF=1 on a positive match (segment found in that storage class) and CF=0 on miss; the dispatcher returns the first match's status flags up the chain.
; Args     : [bp+0x18] = ES:DI = saved (segment, offset) of the LJMP target. Inferred from globals at cs:[0x397D..0x3981].
; Returns  : CF/ZF flags select the patch path in rtlink_loader_shared. Helpers also write to cs:[0x3995..] tracking which storage class served the load.
; Callers  : rtlink_loader_shared at 0x142C7 (CALL 0x164A2).
; Callees  : 0x164FE, 0x164E8, 0x16564, 0x16516, 0x16837, 0x167F2 (six storage-class helpers — disk / EMS / XMS / cache / etc.). Each tested in turn until one matches.
; Verified : Boundary verified: CS:DS setup at 0x164A2; near-RET at 0x164DC giving size 59 bytes (24 instructions).
; Source   : manually identified by following the CALL from rtlink_loader_shared at 0x142C7.
; ============================================================================

0164A2  8C C8                 MOV    ax, cs                       ; AX = our own CS (the load image's code segment)
0164A4  8E D8                 MOV    ds, ax                       ; DS = CS — for the cs-relative reads/writes that follow
0164A6  A1 7D 39              MOV    ax, word ptr [0x397d]        ; AX = saved IP from the original LCALL (cached by rtlink_loader_shared)
0164A9  83 E8 05              SUB    ax, 5                        ; back up by 5 = sizeof(LCALL ptr16:16) → AX now points at the LCALL itself
0164AC  A3 81 39              MOV    word ptr [0x3981], ax        ; cache the LCALL pointer at cs:[0x3981] for the patch step
0164AF  C4 7E 18              LES    di, ptr [bp + 0x18]          ; ES:DI = saved (segment, offset) of the LJMP-target — supplied by the caller's stack frame at +0x18
0164B2  8C C0                 MOV    ax, es                       ; AX = the LJMP's target SEGMENT (the linker virtual paragraph value)
0164B4  3D 0D 11              CMP    ax, 0x110d                   ; is the target inside the load image's code segment (0x110D)?
0164B7  74 27                 JE     0x164e0                      ; if yes, this is a self-call — branch to the no-patch quick-return
0164B9  E8 42 00              CALL   0x164fe                      ; helper 1 — typically the in-RAM cache (returns CF=1 if found)
0164BC  72 1F                 JB     0x164dd                      ; on hit, jump to the success exit
0164BE  E8 27 00              CALL   0x164e8                      ; helper 2 — possibly hot-segment / fast lookup
0164C1  72 1A                 JB     0x164dd                      ; on hit, exit
0164C3  E8 9E 00              CALL   0x16564                      ; helper 3 — possibly EMS-resident lookup
0164C6  72 15                 JB     0x164dd                      ; on hit, exit
0164C8  E8 4B 00              CALL   0x16516                      ; helper 4 — possibly XMS-resident lookup
0164CB  72 10                 JB     0x164dd                      ; on hit, exit
0164CD  E8 67 03              CALL   0x16837                      ; helper 5 — possibly disk-fault path
0164D0  72 0B                 JB     0x164dd                      ; on hit, exit
0164D2  E8 1D 03              CALL   0x167f2                      ; helper 6 — last-resort allocation/fault
0164D5  72 06                 JB     0x164dd                      ; on hit, exit
0164D7  B9 FF FF              MOV    cx, 0xffff                   ; CX = -1 — sentinel for "no helper matched"
0164DA  0B C9                 OR     cx, cx                       ; sets ZF=0 / CF=0 — failure indication for the caller
0164DC  C3                    RET                                 ; near-return to rtlink_loader_shared at 0x142CA
