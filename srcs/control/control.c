#include "psp/pspctrl.h"

void	read_keys(void)
{
	SceCtrlData	pad;

	sceCtrlSetSamplingCycle(0);
	sceCtrlSetSamplingMode(PSP_CTRL_MODE_ANALOG);
    sceCtrlPeekBufferPositive(&pad, 1);

	if (pad.Buttons & PSP_CTRL_CROSS)
		// pressed cross
		return ;
}
