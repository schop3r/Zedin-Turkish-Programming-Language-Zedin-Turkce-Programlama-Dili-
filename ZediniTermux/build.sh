#!/bin/bash

# 1. Eskiyi öldür (VNC bağlantısı kopmaz, sadece ekran kararır/bekler)
pkill -9 qemu-system-i386

# 2. Derleme adımları
nasm -f bin boot.asm -o boot.bin
nasm -f elf32 kernel_entry.asm -o kernel_entry.o
clang -target i386-pc-none-elf -ffreestanding -fno-PIC -fno-stack-protector -c kernel.c -o kernel.o
ld.lld -m elf_i386 -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary --image-base 0x1000

# 3. Birleştir
cat boot.bin kernel.bin > zedini_os.img
truncate -s 32K zedini_os.img

echo "Derlendi!"

