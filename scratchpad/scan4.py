import capstone
with open('/home/user/colopy/raw/COLONIZE/VICEROY.EXE','rb') as f:
    data = f.read()
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)

# Count RET / LEAVE+RET (function ends) and ENTER (function starts) that look real
# between 0x04E2D6 and 0x051D56, to see if it's one giant function or many.
print("=== retf/ret (c3/cb/c2/ca) and leave(c9) in 0x04E2D6..0x051D56 ===")
rets=[]
for ins in md.disasm(data[0x04E2D6:0x051D56], 0x04E2D6):
    if ins.mnemonic in ('ret','retf','leave','iret'):
        rets.append((ins.address, ins.mnemonic, ins.op_str))
for a,m,o in rets:
    print(f"{a:06X}  {m} {o}")
print("count rets/leaves:", len(rets))
