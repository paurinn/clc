#!/usr/bin/env lua
--[[
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
--]]

local _version = [[
clc v0.6
]]

local _warranty = _version .. [[

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
]]

local _greeting = _version .. [[

Copyright (C) 2016  Kari Sigurjonsson
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'.
]]

local _help = _greeting .. [[

Usage clc [options]
  -h  --help      Print short usage information and exit.
  -v  --version   Print program version and exit.
  -w  --warranty  Print warranty information and exit.
  -m  --manual    Print a very short users manual and exit.

--------------------------------------------------------------------------------

This program uses a small libreadline wrapper implemented in lreadline.c.
In Debian or Ubuntu the package "libreadline-dev" must be installed.

Build the wrapper with gcc:

$ gcc -fPIC -shared -lreadline -llua -o lreadline.so lreadline.c

--------------------------------------------------------------------------------

]]

local _builtins = [[

Built-in functions:
	_x() - Output hexadecimal.
	_d() - Output decimal.
	_b() - Toggle displaying 32 bit binary prefix "[00000000-00000000-00000000-00000000]".
]]

local _fullhelp = _warranty .. [[

This calculator is for Lua programmers but Lua is simple enough
for anyone to learn at http://www.lua.org

This calculator uses Lua as the input language.
This is basically a wrapper around load() and pcall().
User enters a single line of Lua source (can be any valid Lua code).
That input is run through load() and pcall() to catch any errors gracefully.


An initial Lua script is run if it exists under $HOME/.clcinit

Run the clc.lua file and a prompt ">" will appear.
Enter a simple expression:

> 1 * 4 * 9
36

The result is stored in a global variable "_".
For example, entering any expression:

> 344 + 1
345

"_" is now preloaded with 345 and entering:

> _ + 34
379

will add 34 to "_". Afterwards, entering an empty line
will repeat the last operation, that is,
add 34 to "_" and assign it to "_".

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


Input hexadecimal using "0x" prefix:

>0x45
69


Quit the program with CTRL-D or if stuck CTRL-C.

]] .. _builtins

_obase = 10
_obin = nil

local _firmware = [[
_x = function() _obase = 16 end
_d = function() _obase = 10 end
_b = function() _obin = not _obin end
]];

--Evaluate (run) the Lua source in input and return whatever the chunk returns.
local eval = function(input)
	if (not input) then return "" end
	local f, err, ok, arg1

	--Find out if assignment or something else.
	--Add the necessary prefix/postfix code to let global variable "_" receive result of evaluation.
	local s, e = input:find("=")
	if (s and e) then
		--Handle assignments
		local lval, rval = input:sub(1, s-1), input:sub(e+1)
		f, err = load(input .. "; _ = tonumber(_ or 0) or 0; _ = " .. lval .. "; return _")
	else
		--Handle everything else
		f, err = load("_ = tonumber(_ or 0) or 0; _ = " .. input .. "; return _")
	end

	--Run the resulting chunk if all is well.
	if (not f) then return (err or "") end
	local ok, ret = pcall(f)

	--Print out the result
	if (ok and ret) then
		local n = tonumber(ret)
		if (not n) then return "" end

		--Print out values binary representation but only first 32 bits.
		if (_obin) then
			local value, out = math.floor(n), ""
			for count = 1, 32 do
				if (value == 0) then break end
				out = out .. (((math.floor(value) & 1) == 1) and "1" or "0")
				value = value >> 1
			end
			local remain = 32 - #out
			for i = 1, remain do
				out = out .. "0"
			end
			local rev = string.reverse(out)
			io.write(" ", rev:sub(1, 8), "-", rev:sub(9, 16), "-", rev:sub(17, 24), "-", rev:sub(25, 32), " = ")
		end

		--Print out value in the set output base.
		if (_obase == 16) then
			--Avoid numbers with not possible integer representation.
			if (n >= math.mininteger and n < math.maxinteger) then
				return string.format("0x%X", math.floor(n))
			else
				return "0x0"
			end
		else
			return tostring(n)
		end
	end

	--Return the result.
	return tostring((ret or ""))
end

local main = function(arg)
	if (#arg >= 1) then
		for i = 1, #arg do
			if (arg[i] == "-w" or arg[i] == "--warranty") then
				print(_warranty)
				os.exit(0)
			elseif (arg[i] == "-h" or arg[i] == "--help") then
				print(_help)
				os.exit(0)
			elseif (arg[i] == "-v" or arg[i] == "--version") then
				print(_greeting)
				os.exit(0)
			elseif (arg[i] == "-m" or arg[i] == "--manual") then
				print(_fullhelp)
				os.exit(0)
			else
				print("Unknown argument: '" .. arg[i] .. "'")
				print(_help)
				os.exit(1)
			end
		end
	end

	print(_greeting)

	--Require the readline library here to be able to print help
	--that contains instructions to build the lreadline.so helper.
	_readline = require("lreadline")


	--Load user init script from users home.
	local e = os.getenv("HOME")
	if (e and e ~= "") then
		local f, ok, err
		local fp = e .. "/.clcinit"
		f, err = loadfile(fp)
		if (f) then
			ok, err = pcall(f)
			if (not ok) then
				print((err or ("Error executing '" .. fp .. "'")))
				os.exit(3)
			end
		else
			print((err or ("Error loading '" .. fp .. "'")))
			os.exit(2)
		end
	end

	--Inject firmware afterwards.
	load(_firmware)()

	local last, line = "", ""

	while (line) do
		line = _readline.readline("> ")
		if (line and line ~= "") then
			if (line == "warranty") then
				print(_warranty)
			elseif (line == "help") then
				print(_builtins)
			elseif (line == "manual") then
				print(_fullhelp)
			else
				lastline = line
				local output = eval(line)
				if (output and output ~= "") then
					print(output)
				end
				_readline.addhistory(line)
			end
		elseif (line == "" and lastline ~= "") then
			local output = eval(lastline)
			if (output and output ~= "") then
				print(output)
			end
			_readline.addhistory(line)
		end
	end

	return 0
end

--The variable "arg" is automatically created by the Lua interpreter
--as an array of the command line arguments.
return main(arg)

