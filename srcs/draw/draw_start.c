#include "psp/pspgu.h"

void draw_start(void *GE_list)
{
	sceGuStart(GU_DIRECT, GE_list);
}