#===============================================================================
# clc - Command Line Calculator
#
# Copyright (C) 2016  Kari Sigurjonsson
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#===============================================================================

### Preps

LUAVERSION = $(shell lua -v | lua -e 'print(io.read("*l"):match("^Lua (%d%.%d)") or "5.1")')

#Compiler flags.
CFLAGS = -fPIC -shared -llua -lreadline

#List of source files to build.
SRCS = lreadline.c

#Name of the link output.
OUT = lreadline.so

#Where to copy files on "make install".
INSTALLPREFIX = /usr/local

#Let C and object files be known.
.SUFFIXES : .c .o

#Objects are made of C files from SRCS list.
OBJS = $(SRCS:.c=.o)

#Rule set: build all objects then link.
RULES += $(OBJS) $(OUT)

### Rule set.

#Just do it.
all: $(RULES)

#Compile C source to object.
.c.o:
	gcc $(CFLAGS) -c -o $*.o $<

#Final link, depends on all objects.
$(OUT): $(OBJS)
	gcc $(OBJS) $(CFLAGS) -o $(OUT)

#Remove objects.
clean:
	rm -f $(OBJS)

#Remove objects and output file.
mrproper: clean
	rm -f $(OUT)

install:
	@echo "Using Lua version $(LUAVERSION)"
	mkdir -p $(INSTALLPREFIX)/bin
	mkdir -p $(INSTALLPREFIX)/lib/lua/$(LUAVERSION)
	cp $(OUT) $(INSTALLPREFIX)/lib/lua/$(LUAVERSION)
	cp clc.lua $(INSTALLPREFIX)/bin/clc
	chmod +x $(INSTALLPREFIX)/bin/clc

