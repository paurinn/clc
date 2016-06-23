# clc v0.6

===============================================================================
clc - Command Line Calculator

Copyright (C) 2016  Kari Sigurjonsson

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

The file "Makefile" can be used to build and install "clc" into "/usr/local/bin"

	$ make clean
	$ make
	$ sudo make install

Alternatively just build the wrapper with gcc:

	$ gcc -fPIC -shared -lreadline -llua -o lreadline.so lreadline.c

--------------------------------------------------------------------------------

This calculator is for Lua programmers but Lua is simple enough
for anyone to learn at http://www.lua.org

This calculator uses Lua as the input language.

For a fully featured programmers calculator with bit shift and integer math
please install Lua-5.3.3 or later.
The first line of "clc.lua" names the Lua interpreter to use, currently "lua" from path.

An initial Lua script is run if it exists under $HOME/.clcinit

Run the clc.lua file and a prompt ">" will appear.
Enter a simple expression:

	> 1 * 4 * 9
	36

The result is stored in a global variable `_` (the underscore).
For example, entering any expression:

	> 344 + 1
	345

`_` is now preloaded with 345 and entering:

	> _ + 34
	379

will add 34 to `_`. Afterwards, entering an empty line
will repeat the last operation, that is,
add 34 to `_` and assign it automatically to `_`.

	>
	413
	>
	447


Creating functions to abstract problems is just plain Lua:

	> area = function(w, h) return w * h end

Calling functions directly prints the return value:

	> area(3, 5)
	15

Create variables by assigning value to them:

	> myvalue = 1
	1

Assign function return value to variable:

	> floorspace = area(100, 100)
	14000

Use the variable and create another one:

	> housevalue = floorspace * 1.4
	14000.0

Entering a variable name only will print out its value:

	> housevalue
	14000.0


All Lua functionality is available such as loading external Lua source:

	> dofile("~/bin/preciousmathfunctions.lua")
	> preciousmath(3.1415)
	5.1413


Executing external processes is available:

	> os.execute("pwd")
	/home/kari


Getting data returned by an external process uses
io.popen() and a wrapper function must be written.

Take note that this is a calculator so any result
from external or internal functions must be numerical.
If a function returns a string then that value must be
convertable to number via tonumber().

Create a wrapper to get return value from external process:

	> exec = function(path) local F = io.popen(path) if (not F) then return "" end local data = F:read("*a"); F:close(); return (data or "") end
	> value = exec("lua -e 'print(3.1415 * 2)'")
	6.283
	> value / 2
	3.1415


A few built-in functions are awailable and they are all prefixed with an underscore:

	_x() - Output hexadecimal.
	_d() - Output decimal.
	_b() - Toggle displaying 32 bit binary prefix "[00000000-00000000-00000000-00000000]".


Input hexadecimal using "0x" prefix:

	>0x45
	69


Quit the program with CTRL-D or if stuck CTRL-C.

