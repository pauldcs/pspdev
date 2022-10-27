#include "psp/pspgu.h"
#include "draw.h"

void drawline(int x0, int y0, int x1, int y1, int c)
{
	t_vertex*	v;

	v = sceGuGetMemory(sizeof(t_vertex) * 2);
	v[0].color = c;
	v[0].x = x0;
	v[0].y = y0;
	v[0].z = 0;
	v[1].color = c;
	v[1].x = x1;
	v[1].y = y1;
	v[1].z = 0;
	sceGuDisable(GU_TEXTURE_2D);
	sceGuDrawArray(
		GU_LINES,
		GU_COLOR_8888
			| GU_VERTEX_16BIT
			| GU_TRANSFORM_2D,
			2,
			NULL,
			v);
	sceGuEnable(GU_TEXTURE_2D);
}