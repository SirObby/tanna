CC=gcc -m32 -march=i486

all:
	mkdir -p bin
	${CC} boot/boot.S  -nostdlib -c -o bin/boot.o -I./kernel
	${CC} -c kernel/kernel.c -o bin/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra -I./kernel
	${CC} -c kernel/tty.c -o bin/tty.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra -I./kernel
	${CC} -T linker.ld -o bin/tanna.bin -ffreestanding -O2 -nostdlib bin/boot.o bin/kernel.o bin/tty.o -I./kernel

mkiso:
	mkdir -p isodir/boot/grub
	cp bin/tanna.bin isodir/boot/tanna.bin
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub2-mkrescue -o bin/tanna.iso isodir

run:
	qemu-system-i386 -cdrom bin/tanna.iso
