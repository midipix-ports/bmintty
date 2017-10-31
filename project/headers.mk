API_HEADERS = \
	$(SOURCE_DIR)/src/appinfo.h \
	$(SOURCE_DIR)/src/base64.h \
	$(SOURCE_DIR)/src/charset.h \
	$(SOURCE_DIR)/src/child.h \
	$(SOURCE_DIR)/src/config.h \
	$(SOURCE_DIR)/src/ctrls.h \
	$(SOURCE_DIR)/src/minibidi.h \
	$(SOURCE_DIR)/src/print.h \
	$(SOURCE_DIR)/src/res.h \
	$(SOURCE_DIR)/src/sixel.h \
	$(SOURCE_DIR)/src/sixel_hls.h \
	$(SOURCE_DIR)/src/std.h \
	$(SOURCE_DIR)/src/term.h \
	$(SOURCE_DIR)/src/termpriv.h \
	$(SOURCE_DIR)/src/win.h \
	$(SOURCE_DIR)/src/winctrls.h \
	$(SOURCE_DIR)/src/winids.h \
	$(SOURCE_DIR)/src/winimg.h \
	$(SOURCE_DIR)/src/winpriv.h \
	$(SOURCE_DIR)/src/winsearch.h \

INTERNAL_HEADERS = \

ALL_HEADERS = $(API_HEADERS) $(INTERNAL_HEADERS)
