TARGET_EXEC:=smw

SRCS:=$(wildcard smb1/*.c smbll/*.c src/*.c src/snes/*.c) third_party/gl_core/gl_core_3_1.c
OBJS:=$(SRCS:%.c=%.o)

PYTHON:=/usr/bin/env python3
#CFLAGS:=$(if $(CFLAGS),$(CFLAGS),-O2 -fno-strict-aliasing -Werror )
CFLAGS:=${CFLAGS} $(shell pkg-config sdl3 --cflags) -I.

ifeq (${OS},Windows_NT)
    WINDRES:=windres
#    RES:=sm.res
    SDLFLAGS:=-Wl,-Bstatic $(shell pkg-config sdl3 --libs)
else
    SDLFLAGS:=$(shell pkg-config sdl3 --libs) -lm
endif

.PHONY: all clean clean_obj

all: $(TARGET_EXEC) smw_assets.dat
$(TARGET_EXEC): $(OBJS) $(RES)
	$(CC) $^ -o $@ $(LDFLAGS) $(SDLFLAGS)

%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@

#$(RES): src/platform/win32/smw.rc
#	@echo "Generating Windows resources"
#	@$(WINDRES) $< -O coff -o $@

smw_assets.dat:
	@echo "Extracting game resources"
	$(PYTHON) assets/restool.py

clean: clean_obj clean_gen
clean_obj:
	@$(RM) $(OBJS) $(TARGET_EXEC)
clean_gen:
	@$(RM) $(RES) smw_assets.dat
	@rm -rf assets/__pycache__
