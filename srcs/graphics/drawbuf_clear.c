#include "psp/pspgu.h"

void	drawbuf_clear(int color)
{
	sceGuClearColor(color);
	sceGuClear(GU_COLOR_BUFFER_BIT
		| GU_DEPTH_BUFFER_BIT);
}