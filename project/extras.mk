CFLAGS_SHARED_ATTR	+= -DMINTTY_EXPORT
CFLAGS_STATIC_ATTR	+= -DMINTTY_STATIC
CFLAGS_APP_ATTR		+= -DMINTTY_APP

LDFLAGS_COMMON		+= -L$(SYSROOT)/usr/lib/w32api
LDFLAGS_COMMON		+= -mwindows -lcomctl32 -limm32 -lwinmm -lwinspool -lole32 -luuid -lusp10

RES_LOBJS		+= $(RES_SRCS:.rc=.lo)
RES_OBJS		+= $(RES_SRCS:.rc=.o)

APP_OBJS		+= $(RES_OBJS)
COMMON_LOBJS		+= $(RES_LOBJS)

src/res.lo:		$(SOURCE_DIR)/src/res.rc $(ALL_HEADERS) host.tag tree.tag
			$(RC) -o $@ -c 65001 --preprocessor '$(CC) -E -xc -DRC_INVOKED $(CFLAGS)' $<

src/res.o:		$(SOURCE_DIR)/src/res.rc $(ALL_HEADERS) host.tag tree.tag
			$(RC) -o $@ -c 65001 --preprocessor '$(CC) -E -xc -DRC_INVOKED $(CFLAGS)' $<

progress:		src/base64.o  src/minibidi.o  src/sixel_hls.o  src/termline.o
progress:		src/std.o     src/mcwidth.o   src/sixel.o      src/res.o
progress:		src/config.o  src/wintip.o    src/charset.o    src/termmouse.o
progress:		src/ctrls.o   src/textprint.o src/termclip.o   src/child.o
progress:		src/term.o    src/printers.o  src/winsearch.o  src/winimg.o
progress:		              src/wintext.o
