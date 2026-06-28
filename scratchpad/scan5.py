import capstone
with open('/home/user/colopy/raw/COLONIZE/VICEROY.EXE','rb') as f:
    data = f.read()
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)

# Linear sweep from 0x04F1EF (just after first retf) forward; find first ENTER prologue
print("=== sweep from 0x04F1EF, first 6 instrs ===")
for ins in md.disasm(data[0x04F1EF:0x04F250], 0x04F1EF):
    print(f"{ins.address:06X}  {ins.bytes.hex():<12} {ins.mnemonic} {ins.op_str}")
    if ins.mnemonic=='enter': break
