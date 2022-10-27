#include "pspdev.h"
#include "psp/pspdisplay.h"
#include "psp/pspgu.h"
#include "common.h"

void graphics_init(void *GE_list)
{
	void	*draw_buf = get_static_vram_buffer(PSP_SCR_BUF_SIZE, PSP_SCR_Y, GU_PSM_8888);
	void	*disp_buf = get_static_vram_buffer(PSP_SCR_BUF_SIZE, PSP_SCR_Y, GU_PSM_8888);
	//void	*depth_buf = get_static_vram_buffer(PSP_SCR_BUF_SIZE, PSP_SCR_Y, GU_PSM_4444);

	sceGuInit();
	sceGuStart(GU_DIRECT, GE_list);
	sceGuDrawBuffer(GU_PSM_8888, draw_buf, PSP_SCR_BUF_SIZE);
	sceGuDispBuffer(PSP_SCR_X, PSP_SCR_Y, disp_buf, PSP_SCR_BUF_SIZE);
	//sceGuDepthBuffer(depth_buf, PSP_SCR_BUF_SIZE);
	sceGuOffset(2048 - (PSP_SCR_X / 2), 2048 - (PSP_SCR_Y / 2));
	sceGuViewport(2048, 2048, PSP_SCR_X, PSP_SCR_Y);
	sceGuDepthRange(65535, 0);
	sceGuEnable(GU_SCISSOR_TEST);
	sceGuScissor(0, 0, PSP_SCR_X, PSP_SCR_Y);
	//sceGuEnable(GU_DEPTH_TEST);
	//sceGuDepthFunc(GU_EQUAL);
	//sceGuFrontFace(GU_CW);
	//sceGuEnable(GU_CULL_FACE);
	//sceGuShadeModel(GU_SMOOTH);
	sceGuEnable(GU_TEXTURE_2D);
	sceGuEnable(GU_CLIP_PLANES);
	sceGuFinish();
	sceGuSync(0, 0);
	//sceDisplayWaitVblankStart();
	sceGuDisplay(GU_TRUE);
}