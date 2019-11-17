#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void map_file(void* base,int sector,const char* fname)
{
	FILE* in;
	long size;
	char* buf;
	
	in = fopen(fname,"rb");
	fseek(in,0L,SEEK_END);
	size = ftell(in);
	fseek(in,0L,SEEK_SET);
	
	buf = (char*)malloc(size);
	fread(buf,size,1,in);
	fclose(in);
	
	memcpy((char*)base+(sector-1)*512,buf,size);
	free(buf);
}

/*
Sector 1 - boot.bin
Sector 2 - demo.bin part 1
Sector 3 - demo.bin part 2
Sector 4 - palette part 1
Sector 5 - palette part 2
Sector 6 - image part 1
Sector 131 - image part 125
Sector 132 - sound part 1
Sector 694 - sound part 562
*/

int main(int argc,char** argv)
{
	FILE* fout;
	char* image;
	
	image = (char*)malloc(512*2880);
	map_file(image,1,"boot.bin");
	map_file(image,2,"demo.bin");
	map_file(image,4,"palette.bin");
	map_file(image,6,"summer.bin");
	map_file(image,132,"sound.bin");
	
	fout = fopen("demo.img","wb");
	fwrite(image,512*2880,1,fout);
	fclose(fout);
	return 0;
}