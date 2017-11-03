ifeq ($(OS),midipix)

build/sys/cygwin.h:
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

src/winsearch.lo:	src/winsearch.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/winsearch.o:	src/winsearch.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_STATIC)

src/winsearch.u16.c:	$(SOURCE_DIR)/src/winsearch.c $(ALL_HEADERS) host.tag tree.tag
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
			rm -f src/winsearch.u16.c

endif
