import capstone

EXE = "/home/user/colopy/raw/COLONIZE/VICEROY.EXE"
data = open(EXE, "rb").read()

# resident addr = seg*16+off ; file_off = 0x2400 + resident
def file_off(resident):
    return 0x2400 + resident

md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)

# Disassemble around cb_hide_draw @0xCDAD and blit_setup @0xCDD6
start_res = 0xCDAD
start_fo = file_off(start_res)
chunk = data[start_fo:start_fo+0x40]
print(f"resident 0x{start_res:X} -> file_off 0x{start_fo:X}")
print("raw bytes:", chunk[:0x30].hex())
print()
for insn in md.disasm(chunk, start_res):
    print(f"{insn.address:06x}  {insn.bytes.hex():<14} {insn.mnemonic} {insn.op_str}")
    if insn.address >= 0xCDE0:
        break
