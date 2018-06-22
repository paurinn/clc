###################################################################################################
#
# clc - Command Line Calculator
#
# Copyright (C) 2016-2018  Kari Sigurjonsson
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
###################################################################################################

OUT = lreadline.so
IN = lreadline.c
INSTALLDIR = /usr/local/lib/lua/5.3/

CFLAGS = -fPIC -shared -I/usr/include/lua5.3 -g -ggdb
LIBS = -llua5.3 -lreadline

.PHONY:install

OUT: $(IN)
	gcc $(CFLAGS) -o $(OUT) $(IN) $(LIBS)

clean:
	rm -f $(OUT)

install: $(OUT)
	cp $(OUT) $(INSTALLDIR)

