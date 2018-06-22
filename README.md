# clc v0.7

===============================================================================
clc - Command Line Calculator

Copyright (C) 2016-2018  Kari Sigurjonsson

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

===============================================================================

--------------------------------------------------------------------------------

This program uses a small libreadline wrapper implemented in lreadline.c.
In Debian or Ubuntu the package "libreadline-dev" must be installed.

The file "Makefile" builds the Lua wrapper in lreadline.c.

	$ make clean
	$ make
	$ sudo make install

Alternatively just build the wrapper with gcc:

	$ gcc -fPIC -shared -lreadline -llua -o lreadline.so lreadline.c

--------------------------------------------------------------------------------

