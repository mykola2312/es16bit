#include <stdio.h>
#include <stdlib.h>

int main(int argc,char** argv)
{
	FILE* fbmp;
	FILE* fout;
	int i;
	char b,g,r;
	char* buf;
	
	fbmp = fopen(argv[1],"rb");
	fout = fopen(argv[2],"wb");
	
	fseek(fbmp,0x36,SEEK_SET);
	for(i = 0; i < 256; i++)
	{
		b = fgetc(fbmp) >> 2;
		g = fgetc(fbmp) >> 2;
		r = fgetc(fbmp) >> 2;
		fgetc(fbmp);
		
		fputc(r,fout);
		fputc(g,fout);
		fputc(b,fout);
	}
	
	//fclose(fbmp);
	fclose(fout);
	
	buf = (char*)malloc(320*200);
	fseek(fbmp,0x436,SEEK_SET);
	fread(buf,320*200,1,fbmp);
	fclose(fbmp);
	fout = fopen("summer.bin","wb");
	
	for(i = 0; i < 200; i++)
		fwrite(&buf[320*(200-i-1)],320,1,fout);
	fclose(fout);
	
	free(buf);
	
	return 0;
}