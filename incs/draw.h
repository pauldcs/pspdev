#ifndef DRAW_H
# define DRAW_H

typedef struct s_vertex
{
	unsigned long	color;
	short			x;
	short			y;
	short			z;
} t_vertex;

void	draw_start(void *GE_list);
void	draw_end(void);
void	drawline(int x0, int y0, int x1, int y1, int c);

#endif