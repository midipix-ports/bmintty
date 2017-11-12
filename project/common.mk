RES_SRCS = \
	src/res.rc

API_SRCS = \
	src/base64.c \
	src/charset.c \
	src/child.c \
	src/config.c \
	src/ctrls.c \
	src/mcwidth.c \
	src/minibidi.c \
	src/printers.c \
	src/sixel.c \
	src/sixel_hls.c \
	src/std.c \
	src/term.c \
	src/termclip.c \
	src/termline.c \
	src/termmouse.c \
	src/termout.c \
	src/textprint.c \
	src/winclip.c \
	src/winctrls.c \
	src/windialog.c \
	src/winimg.c \
	src/wininput.c \
	src/winmain.c \
	src/winsearch.c \
	src/wintext.c \
	src/wintip.c \

INTERNAL_SRCS = \

APP_SRCS = \

COMMON_SRCS = $(API_SRCS) $(INTERNAL_SRCS) $(FRAMEWORK_SRCS)
