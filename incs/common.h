#ifndef COMMON_H
# define COMMON_H

// callbacks
int		running(void);
int		setup_call_backs(void);
// vram
void*	get_static_vram_buffer(unsigned int width, unsigned int height, unsigned int psm);
void*	get_static_vram_texture(unsigned int width, unsigned int height, unsigned int psm);

#endif