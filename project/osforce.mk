ifeq ($(OS),midipix)

build/sys/cygwin.h:
			touch build/sys/cygwin.h

host.tag:		build/sys/cygwin.h

src/config.lo:		src/config.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_SHARED)

src/config.o:		src/config.u16.c $(ALL_HEADERS) host.tag tree.tag
			$(CC) -c -o $@ $< $(CFLAGS_STATIC)



src/config.u16.c:	$(SOURCE_DIR)/src/config.c $(ALL_HEADERS) host.tag tree.tag
			$(PROJECT_DIR)/project/literals.sh $< > $@

clean:			clean-gen clean-host

clean-host:
			rm -f build/sys/cygwin.h

clean-gen:
			rm -f src/config.u16.c

endif
