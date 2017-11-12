ifeq ($(OS),midipix)

LDFLAGS_COMMON      += -lu16ports

build/sys/cygwin.h:	tree.tag
			touch build/sys/cygwin.h

host.tag:		tree.tag build/sys/cygwin.h

src/child.lo:		src/child.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/child.o:		src/child.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/child.u16.c:	$(SOURCE_DIR)/src/child.c $(ALL_HEADERS) host.tag tree.tag
			$(PROJECT_DIR)/project/literals.sh $< > $@

src/config.lo:		src/config.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/config.o:		src/config.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/config.u16.c:	$(SOURCE_DIR)/src/config.c $(ALL_HEADERS) host.tag tree.tag
			$(PROJECT_DIR)/project/literals.sh $< > $@

src/printers.lo:	src/printers.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/printers.o:		src/printers.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/printers.u16.c:	$(SOURCE_DIR)/src/printers.c $(ALL_HEADERS) host.tag tree.tag
			$(PROJECT_DIR)/project/literals.sh $< > $@

src/term.lo:		src/term.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/term.o:		src/term.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/term.u16.c:		$(SOURCE_DIR)/src/term.c $(ALL_HEADERS) host.tag tree.tag
			$(PROJECT_DIR)/project/literals.sh $< > $@

src/termclip.lo:	src/termclip.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/termclip.o:		src/termclip.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/termclip.u16.c:	$(SOURCE_DIR)/src/termclip.c $(ALL_HEADERS) host.tag tree.tag
			$(PROJECT_DIR)/project/literals.sh $< > $@

src/termout.lo:		src/termout.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/termout.o:		src/termout.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/termout.u16.c:	$(SOURCE_DIR)/src/termout.c $(ALL_HEADERS) host.tag tree.tag
			$(PROJECT_DIR)/project/literals.sh $< > $@

src/winclip.lo:		src/winclip.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/winclip.o:		src/winclip.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/winclip.u16.c:	$(SOURCE_DIR)/src/winclip.c $(ALL_HEADERS) host.tag tree.tag
			$(PROJECT_DIR)/project/literals.sh $< > $@

src/winctrls.lo:	src/winctrls.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/winctrls.o:		src/winctrls.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/winctrls.u16.c:	$(SOURCE_DIR)/src/winctrls.c $(ALL_HEADERS) host.tag tree.tag
			$(PROJECT_DIR)/project/literals.sh $< > $@

src/windialog.lo:	src/windialog.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/windialog.o:	src/windialog.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/windialog.u16.c:	$(SOURCE_DIR)/src/windialog.c $(ALL_HEADERS) host.tag tree.tag
			$(PROJECT_DIR)/project/literals.sh $< > $@

src/wininput.lo:	src/wininput.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/wininput.o:		src/wininput.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/wininput.u16.c:	$(SOURCE_DIR)/src/wininput.c $(ALL_HEADERS) host.tag tree.tag
			$(PROJECT_DIR)/project/literals.sh $< > $@

src/winmain.lo:		src/winmain.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/winmain.o:		src/winmain.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/winmain.u16.c:	$(SOURCE_DIR)/src/winmain.c $(ALL_HEADERS) host.tag tree.tag
			$(PROJECT_DIR)/project/literals.sh $< > $@

src/winsearch.lo:	src/winsearch.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/winsearch.o:	src/winsearch.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/winsearch.u16.c:	$(SOURCE_DIR)/src/winsearch.c $(ALL_HEADERS) host.tag tree.tag
			$(PROJECT_DIR)/project/literals.sh $< > $@

src/wintext.lo:		src/wintext.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/wintext.o:		src/wintext.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/wintext.u16.c:	$(SOURCE_DIR)/src/wintext.c $(ALL_HEADERS) host.tag tree.tag
			$(PROJECT_DIR)/project/literals.sh $< > $@

clean:			clean-gen clean-host

clean-host:
			rm -f build/sys/cygwin.h

clean-gen:
			rm -f src/child.u16.c
			rm -f src/config.u16.c
			rm -f src/printers.u16.c
			rm -f src/term.u16.c
			rm -f src/termclip.u16.c
			rm -f src/termout.u16.c
			rm -f src/winctrls.u16.c
			rm -f src/winclip.u16.c
			rm -f src/windialog.u16.c
			rm -f src/wininput.u16.c
			rm -f src/winmain.u16.c
			rm -f src/winsearch.u16.c
			rm -f src/wintext.u16.c

endif
