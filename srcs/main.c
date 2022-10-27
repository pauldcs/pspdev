#include "pspdev.h"
#include "psp/pspkernel.h"
#include "graphics.h"
#include "common.h"
#include "draw.h"

//https://web.archive.org/web/20080518010919/http://www.psp-programming.com/forums/index.php?board=2.0
//https://web.archive.org/web/20081001002708/http://www.psp-programming.com/forums/index.php?action=globalAnnouncements;id=1

static int __attribute__((aligned(16))) GE_list[262144];

PSP_MODULE_INFO("pspdev", 0, 1, 1);
PSP_MAIN_THREAD_ATTR(THREAD_ATTR_USER | THREAD_ATTR_VFPU);

int main(void)
{
	setup_call_backs();
	graphics_init(GE_list);

	while (running())
	{
		draw_start(GE_list);
		drawbuf_clear(0xff00ff00);
		drawline(30, 0, 30, PSP_SCR_Y, 0xff0000ff);
		draw_end();
	}
	graphics_deinit();
	sceKernelExitGame();
	return (0);
}
