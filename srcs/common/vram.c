#include "common.h"
#include "psp/pspge.h"
#include "psp/pspgu.h"

static unsigned int get_memory_size(unsigned int x, unsigned int y, unsigned int pm)
{
	switch (pm)
	{
		case GU_PSM_T4:		return ((x * y) >> 1);
		case GU_PSM_T8:		return (x * y);
		case GU_PSM_5650:  
		case GU_PSM_5551:	
		case GU_PSM_4444:	
		case GU_PSM_T16:	return (2 * x * y);
		case GU_PSM_8888:	
		case GU_PSM_T32:	return (4 * x * y);
		default:			return (0);
	}
}

void	*get_static_vram_buffer(unsigned int x, unsigned int y, unsigned int pm)
{
	static unsigned int	static_offset = 0;
	unsigned int		mem_size = get_memory_size(x, y, pm);
	void*				result = (void*)static_offset;

	static_offset += mem_size;
	return (result);
}

void	*get_static_vram_texture(unsigned int x, unsigned int y, unsigned int pm)
{
	void*	result = get_static_vram_buffer(x, y, pm);

	return (
		(void*)(((unsigned int)result)
		+ ((unsigned int)sceGeEdramGetAddr()))
	);
}