#include "psp/pspgu.h"

void draw_end(void)
{
	sceGuFinish();
	sceGuSync(0, 0);
	//sceDisplayWaitVblankStart();
	sceGuSwapBuffers();
}