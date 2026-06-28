import capstone
EXE = "/home/user/colopy/raw/COLONIZE/VICEROY.EXE"
data = open(EXE, "rb").read()
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)

# Disassemble at FILE offset 0xCDAD (where patterns matched), resident = 0xCDAD-0x2400 = 0xA9AD
fo = 0xCDAD
res = fo - 0x2400
chunk = data[fo:fo+0x40]
print(f"FILE offset 0x{fo:X} (resident 0x{res:X})")
for insn in md.disasm(chunk, res):
    print(f"res:{insn.address:06x}  {insn.bytes.hex():<12} {insn.mnemonic} {insn.op_str}")
    if insn.address - res > 0x35:
        break
