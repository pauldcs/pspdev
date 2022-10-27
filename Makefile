OBJS  := \
	srcs/main.o                   \
	srcs/common/callbacks.o       \
	srcs/common/vram.o            \
	srcs/draw/draw_start.o        \
	srcs/draw/draw_end.o          \
	srcs/draw/drawline.o          \
	srcs/graphics/drawbuf_clear.o \
	srcs/graphics/graphics_init.o \
	srcs/graphics/graphics_deinit.o \
	srcs/control/control.o        \
	srcs/debug/debug_init.o       \

PSPSDK           := $(shell psp-config --pspsdk-path)
PSP_EBOOT_TITLE  := pspdev
TARGET           := $(PSP_EBOOT_TITLE)
EXTRA_TARGETS    := EBOOT.PBP
PSP_EBOOT_SFO    := PARAM.SFO
PSP_EBOOT_ICON   := NULL
PSP_EBOOT_ICON1  := NULL
PSP_EBOOT_UNKPNG := NULL
PSP_EBOOT_PIC1   := NULL
PSP_EBOOT_SND0   := NULL
PSP_EBOOT_PSAR   := NULL
PSP_EBOOT        := EBOOT.PBP
CC               := psp-gcc
CXX              := psp-g++
AS               := psp-gcc
LD               := psp-gcc
AR               := psp-gcc-ar
RANLIB           := psp-gcc-ranlib
STRIP            := psp-strip
MKSFO            := mksfo
PACK_PBP         := pack-pbp
FIXUP            := psp-fixup-imports
PSP_FW_VERSION   := 150

INCDIR   := incs . $(PSPDEV)/psp/include $(PSPSDK)/include
LIBDIR   := $(LIBDIR) . $(PSPDEV)/psp/lib $(PSPSDK)/lib
CFLAGS   := $(addprefix -I,$(INCDIR)) -g3 -Wall -Wextra -O3
CXXFLAGS := $(CFLAGS) -fno-exceptions -fno-rtti
ASFLAGS  := $(CFLAGS) $(ASFLAGS)

LDFLAGS  := $(addprefix -L,$(LIBDIR)) -Wl,-zmax-page-size=128

LIBS      := -lm \
			-lstdc++               \
			-lpng                  \
			-ljpeg                 \
			-lz                    \
			-lpsphprm              \
			-lpspsdk               \
			-lpspctrl              \
			-lpspumd               \
			-lpsprtc               \
			-lpsppower             \
			-lpspgu                \
			-lpspgum               \
			-lpspaudiolib          \
			-lpspaudio             \
			-lpsphttp              \
			-lpspssl               \
			-lpspwlan              \
			-lpspnet_adhocmatching \
			-lpspnet_adhoc         \
			-lpspnet_adhocctl      \
			-lpspaudio             \
			-lpspgu                \
			-lpsppower             \
			-lpsphprm              \
			-lpspdebug             \
			-lpspdisplay           \
			-lpspge                \
			-lpspctrl              \
			-lpspnet               \
			-lpspnet_apctl

ifeq ($(PSPSDK),)
$(error $$(PSPSDK) is undefined.  Use "PSPSDK := $$(shell psp-config --pspsdk-path)" in your Makefile)
endif

ifeq ($(BUILD_PRX),1)
ifneq ($(TARGET_LIB),)
$(error TARGET_LIB should not be defined when building a prx)
else
FINAL_TARGET = $(TARGET).prx
endif
else
ifneq ($(TARGET_LIB),)
FINAL_TARGET = $(TARGET_LIB)
else
FINAL_TARGET = $(TARGET).elf
endif
endif

all: $(EXTRA_TARGETS) $(FINAL_TARGET)

kxploit: $(TARGET).elf $(PSP_EBOOT_SFO)
	mkdir -p "$(TARGET)"
	$(STRIP) $(TARGET).elf -o $(TARGET)/$(PSP_EBOOT)
	mkdir -p "$(TARGET)%"
	$(PACK_PBP) "$(TARGET)%/$(PSP_EBOOT)" $(PSP_EBOOT_SFO) $(PSP_EBOOT_ICON)  \
		$(PSP_EBOOT_ICON1) $(PSP_EBOOT_UNKPNG) $(PSP_EBOOT_PIC1)  \
		$(PSP_EBOOT_SND0) NULL $(PSP_EBOOT_PSAR)

SCEkxploit: $(TARGET).elf $(PSP_EBOOT_SFO)
	mkdir -p "__SCE__$(TARGET)"
	$(STRIP) $(TARGET).elf -o __SCE__$(TARGET)/$(PSP_EBOOT)
	mkdir -p "%__SCE__$(TARGET)"
	$(PACK_PBP) "%__SCE__$(TARGET)/$(PSP_EBOOT)" $(PSP_EBOOT_SFO) $(PSP_EBOOT_ICON)  \
		$(PSP_EBOOT_ICON1) $(PSP_EBOOT_UNKPNG) $(PSP_EBOOT_PIC1)  \
		$(PSP_EBOOT_SND0) NULL $(PSP_EBOOT_PSAR)

ifeq ($(NO_FIXUP_IMPORTS), 1)
$(TARGET).elf: $(OBJS) $(EXPORT_OBJ)
	$(LINK.c) $^ $(LIBS) -o $@
else
$(TARGET).elf: $(OBJS) $(EXPORT_OBJ)
	$(LINK.c) $^ $(LIBS) -o $@
	$(FIXUP) $@
endif

$(TARGET_LIB): $(OBJS)
	$(AR) cru $@ $(OBJS)
	$(RANLIB) $@

$(PSP_EBOOT_SFO): 
	$(MKSFO) '$(PSP_EBOOT_TITLE)' $@

ifeq ($(BUILD_PRX),1)
$(PSP_EBOOT): $(TARGET).prx $(PSP_EBOOT_SFO)
	$(PACK_PBP) $(PSP_EBOOT) $(PSP_EBOOT_SFO) $(PSP_EBOOT_ICON)  \
		$(PSP_EBOOT_ICON1) $(PSP_EBOOT_UNKPNG) $(PSP_EBOOT_PIC1)  \
		$(PSP_EBOOT_SND0)  $(TARGET).prx $(PSP_EBOOT_PSAR)
else
$(PSP_EBOOT): $(TARGET).elf $(PSP_EBOOT_SFO)
	$(STRIP) $(TARGET).elf -o $(TARGET)_strip.elf
	$(PACK_PBP) $(PSP_EBOOT) $(PSP_EBOOT_SFO) $(PSP_EBOOT_ICON)  \
		$(PSP_EBOOT_ICON1) $(PSP_EBOOT_UNKPNG) $(PSP_EBOOT_PIC1)  \
		$(PSP_EBOOT_SND0)  $(TARGET)_strip.elf $(PSP_EBOOT_PSAR)
	-rm -f $(TARGET)_strip.elf
endif

%.prx: %.elf
	psp-prxgen $< $@

%.c: %.exp
	psp-build-exports -b $< > $@

clean: 
	-rm -f $(FINAL_TARGET) $(EXTRA_CLEAN) $(OBJS) $(PSP_EBOOT_SFO) $(EXTRA_TARGETS)

fclean:
	-rm -f $(FINAL_TARGET) $(EXTRA_CLEAN) $(OBJS) $(PSP_EBOOT_SFO) $(PSP_EBOOT) $(EXTRA_TARGETS)

re: fclean all


