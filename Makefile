
all:
	nasm -f bin boot.asm -o boot.bin
	nasm -f bin demo.asm -o demo.bin
	palette summer.bmp palette.bin
	mapper
	qemu-system-i386 -fda demo.img -soundhw sb16,adlib,pcspk