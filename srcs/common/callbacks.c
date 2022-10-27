#include "psp/pspkernel.h"
#include "psp/pspdisplay.h"
#include "psp/pspdebug.h"
#include <stdbool.h>

static int exitRequest = false;

int running(void)
{
	return (!exitRequest);
}

int exit_call_back(int arg1, int arg2, void *common)
{
	(void)arg1;
	(void)arg2;
	(void)common;
	exitRequest = 1;
	return (0);
}

int call_back_thread(SceSize args, void *argp)
{
	int cbid;

	(void)args;
	(void)argp;
	cbid = sceKernelCreateCallback(
			"Exit Callback",
			exit_call_back,
			NULL);
	sceKernelRegisterExitCallback(cbid);
	sceKernelSleepThreadCB();
	return (0);
}

int setup_call_backs(void)
{
	int thid = 0;

	thid = sceKernelCreateThread(
			"update_thread",
			call_back_thread,
			0x11,
			0xFA0,
			0,
			0);
	if(thid >= 0)
		sceKernelStartThread(thid, 0, 0);
	return (thid);
}
