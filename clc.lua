#!/usr/bin/lua5.3
--[[
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
--]]

local _version = [[
clc v0.7
]]

local _warranty = _version .. [[

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
]]

local _greeting = _version .. [[

Copyright (C) 2016-2018  Kari Sigurjonsson
This is free software with ABSOLUTELY NO WARRANTY.
For details type `warranty'.
]]

local _help = _greeting .. [[

Usage clc [options]
  -h  --help      Print short usage information and exit.
  -v  --version   Print program version and exit.
  -w  --warranty  Print warranty information and exit.

--------------------------------------------------------------------------------

This program uses a small libreadline wrapper implemented in lreadline.c.
In Debian or Ubuntu the package "libreadline-dev" must be installed.

Build the wrapper with gcc:

$ gcc -I/usr/include/lua5.3 -fPIC -shared -lreadline -llua5.3 -o lreadline.so lreadline.c

--------------------------------------------------------------------------------

]]

--*************************************************************************************************

_lastInput = ""

_D = {}

_stack = {}

_compile = false
_compileLine = ""

_lastWord = ""

_outFormats = {
	float = "%g",
	hex = "%0X"
}

_outFormat = _outFormats.float

_if = false
_ifLine = ""

_print = false
_printLine = ""

_see = false

_forget = false

_comment = false

--*************************************************************************************************

function _stack:push(value)
	if (_outFormat ~= _outFormats.float) then
		self[#self+1] = math.floor(value)
	else
		self[#self+1] = value
	end
end

function _stack:pop()
	if (#self <= 0) then
		error(" Underflow", 0)
	end
	return table.remove(self)
end

--*************************************************************************************************

_D["+"] = function() _stack:push(_stack:pop() + _stack:pop()) ans = _stack[#_stack] end
_D["-"] = function() local a = _stack:pop() _stack:push(_stack:pop() - a) ans = _stack[#_stack] end
_D["*"] = function() _stack:push(_stack:pop() * _stack:pop()) ans = _stack[#_stack] end
_D["/"] = function() local a = _stack:pop() _stack:push(_stack:pop() / a) ans = _stack[#_stack] end
_D["%"] = function() local a = _stack:pop() _stack:push(_stack:pop() % a) ans = _stack[#_stack] end

_D["/%"] = function()
	local a, b = _stack:pop(), _stack:pop()
	_stack:push(b % a) _stack:push(b / a) ans = _stack[#_stack]
end

_D["<<"] = function()
	local b, a = _stack:pop(), _stack:pop()
	_stack:push(a << b) ans = _stack[#_stack]
end

_D[">>"] = function()
	local b, a = _stack:pop(), _stack:pop()
	_stack:push(a >> b) ans = _stack[#_stack]
end

_D["1<<"] = function()
	local a = _stack:pop()
	_stack:push(a << 1) ans = _stack[#_stack]
end

_D["1>>"] = function()
	local a = _stack:pop()
	_stack:push(a >> 1) ans = _stack[#_stack]
end

_D["."] = function() io.write(string.format(" ".._outFormat, _stack:pop())) end

_D["emit"] = function() io.write(string.char(math.floor(_stack:pop()))) end

_D["space"] = function()
	io.write(" ")
end

_D["spaces"] = function()
	local a = _stack:pop()
	io.write(string.rep(" ", a))
end

_D["cr"] = function()
	io.write("\n")
end

_D[":"] = function()
	if (_compile) then return end
	_compile = true
	_luaCompile = false
	_compileLine = ""
end

_D["`"] = function()
	if (_compile) then return end
	_compile = true
	_luaCompile = true
	_compileLine = ""
end

_D[";"] = function()
	if (not _compile) then return end

	local name, code = _compileLine:match("%s*([^%s]*)(.*)")
	if (#name > 0) then
		if (_luaCompile) then
			_D[name] = load(code)
		else
			_D[name] = code
		end
	else
		_compile = false
		_luaCompile = false
		error(" Compile failure", 0)
	end

	_compile = false
end

_D["!"] = function()
	_stack:pop()
	if (_D[_lastWord]) then
		_D[_lastWord] = _stack:pop()
	else
		error(" ".._lastWord .. "\t?", 0)
	end
end

_D["forget"] = function()
	_forget = true
end

_D["dup"] = function() local e = _stack:pop() _stack:push(e) _stack:push(e) end
_D["swap"] = function() local a, b = _stack:pop(), _stack:pop() _stack:push(a) _stack:push(b) end
_D["over"] = function() local a, b = _stack:pop(), _stack:pop() _stack:push(b) _stack:push(a) _stack:push(b) end
_D["rot"] = function() local c, b, a = _stack:pop(), _stack:pop(), _stack:pop() _stack:push(b) _stack:push(c) _stack:push(a) end
_D["drop"] = function() _stack:pop() end

_D["2swap"] = function()
	local d, c, b, a = _stack:pop(), _stack:pop(), _stack:pop(), _stack:pop()
	_stack:push(c)
	_stack:push(d)
	_stack:push(a)
	_stack:push(b)
end

_D["2dup"] = function()
	local b, a = _stack:pop(), _stack:pop()
	_stack:push(a)
	_stack:push(b)
	_stack:push(a)
	_stack:push(b)
end

_D["2over"] = function()
	local d, c, b, a = _stack:pop(), _stack:pop(), _stack:pop(), _stack:pop()
	_stack:push(a)
	_stack:push(b)
	_stack:push(c)
	_stack:push(d)
	_stack:push(a)
	_stack:push(b)
end

_D["2drop"] = function() _stack:pop() _stack:pop() end

_D["1+"] = function() _stack:push(_stack:pop() + 1) ans = _stack[#_stack] end
_D["1-"] = function() _stack:push(_stack:pop() - 1) ans = _stack[#_stack] end
_D["2+"] = function() _stack:push(_stack:pop() + 2) ans = _stack[#_stack] end
_D["2-"] = function() _stack:push(_stack:pop() - 2) ans = _stack[#_stack] end
_D["2*"] = function() _stack:push(_stack:pop() * 2) ans = _stack[#_stack] end
_D["2/"] = function() _stack:push(_stack:pop() / 2) ans = _stack[#_stack] end

_D["sqrt"] = function() _stack:push(math.sqrt(_stack:pop())) ans = _stack[#_stack] end
_D["sin"] = function() _stack:push(math.sin(_stack:pop())) ans = _stack[#_stack] end
_D["cos"] = function() _stack:push(math.cos(_stack:pop())) ans = _stack[#_stack] end
_D["tan"] = function() _stack:push(math.tan(_stack:pop())) ans = _stack[#_stack] end

_D["atan"] = function() _stack:push(math.atan(_stack:pop())) ans = _stack[#_stack] end
_D["atan2"] = function() _stack:push(math.atan2(_stack:pop())) ans = _stack[#_stack] end

_D["pi"] = function() _stack:push(math.pi) ans = _stack[#_stack] end
_D["tau"] = function() _stack:push(math.pi * 2) ans = _stack[#_stack] end

_D["abs"] = function() _stack:push(math.abs(_stack:pop())) ans = _stack[#_stack] end
_D["neg"] = function() _stack:push(-_stack:pop()) ans = _stack[#_stack] end

_D["min"] = function()
	local b, a  = _stack:pop(), _stack:pop()
	_stack:push(math.min(a, b)) ans = _stack[#_stack]
end

_D["max"] = function()
	local b, a  = _stack:pop(), _stack:pop()
	_stack:push(math.max(a, b)) ans = _stack[#_stack]
end

_D["*/"] = function()
	local c, b, a  = _stack:pop(), _stack:pop(), _stack:pop()
	_stack:push(a * b / c) ans = _stack[#_stack]
end

_D["*/%"] = function()
	local c, b, a  = _stack:pop(), _stack:pop(), _stack:pop()
	_stack:push((a * b) % c)
	_stack:push((a * b) / c)
	ans = _stack[#_stack]
end

_D["if"] = function()
	_ifLine = ""
	_if = true
end

_D["else"] = function()
	--Does nothing, "then" handles everything.
end

_D["then"] = function()
	_if = false
	local t, f
	if (_ifLine:find("%s*else%s*")) then
		t, f = _ifLine:match("(.*)else(.*)")
	else
		t, f = _ifLine, ""
	end

	local a = _stack:pop()
	if (a ~= 0) then
		if (t) then inner(t) end
	else
		if (f) then inner(f) end
	end
end

_D["="] = function() _stack:push((_stack:pop() == _stack:pop()) and -1 or 0) ans = _stack[#_stack] end

_D["<"] = function()
	local b, a = _stack:pop(), _stack:pop()
	_stack:push((a < b) and -1 or 0)
	ans = _stack[#_stack]
end

_D[">"] = function()
	local b, a = _stack:pop(), _stack:pop()
	_stack:push((a > b) and -1 or 0)
	ans = _stack[#_stack]
end

_D["0="] = function() _stack:push((_stack:pop() == 0) and -1 or 0) ans = _stack[#_stack] end
_D["0<"] = function() _stack:push((_stack:pop() < 0) and -1 or 0) ans = _stack[#_stack] end
_D["0>"] = function() _stack:push((_stack:pop() > 0) and -1 or 0) ans = _stack[#_stack] end

_D["not"] = function() _stack:push((_stack:pop() == 0) and -1 or 0) ans = _stack[#_stack] end

_D["and"] = function()
	local a, b = _stack:pop(), _stack:pop()
	_stack:push((b ~= 0 and b ~= 0) and -1 or 0)
	ans = _stack[#_stack]
end

_D["or"] = function()
	local a, b = _stack:pop(), _stack:pop()
	_stack:push((a ~= 0 or b ~= 0) and -1 or 0)
	ans = _stack[#_stack]
end

_D["xor"] = function()
	local a, b = _stack:pop(), _stack:pop()
	_stack:push(((a ~= 0 or b ~= 0) and not (a ~= 0 and b ~= 0)) and -1 or 0)
	ans = _stack[#_stack]
end

_D["2dup"] = function()
	local a = _stack:pop()
	if (a ~= 0) then
		_stack:push(a)
	end
	_stack:push(a)
end

_D["?stack"] = function() _stack:push((#_stack == 0) and -1 or 0) ans = _stack[#_stack] end

_D["stack"] = function()
	if (#_stack <= 0) then return end
	print("------------")
	for i = 1, #_stack do
		print(string.format(" ".._outFormat, _stack[#_stack - (i - 1)]))
	end
	print("------------")
end

_D["page"] = function() io.write("\027[2J") io.flush() end

_D["hex"] = function() _outFormat = _outFormats.hex end
_D["float"] = function() _outFormat = _outFormats.float end

_D["var"] = function() _variable = true end

_D["number"] = function(word)
	local a = tonumber(word)
	if (a) then
		_stack:push(a)
	else
		error(" " .. word .. "\t?", 0)
	end
end

_D['."'] = function()
	_print = true
	_printLine = ""
end

_D['"'] = function()
	io.write(_printLine)
	_print = false
end

_D["see"] = function()
	_see = true
end

_D["bye"] = function()
	os.exit(0)
end

_D["("] = function()
	_comment = true
end

_D[")"] = function()
	_comment = false
end

_D["list"] = function()
	for k, v in pairs(_D) do
		if (type(v) == "string" or type(v) == "number") then
			print(string.format("_D[%q] = %q", k, v))
		end
	end
end

_D["save"] = function()
	local fileName = "state.lua"
	local F = io.open(fileName, "w+")
	if (F) then
		for k, v in pairs(_D) do
			if (type(v) == "string" or type(v) == "number") then
				F:write(string.format("_D[%q] = %q\n", k, v))
			end
		end
		F:close()
	else
		error(" Could not open file '" .. fileName .. "' for reading and writing.")
	end
end

_D["load"] = function()
	local fileName = "state.lua"
	local F = io.open(fileName, "r")
	if (F) then
		F:close()
		dofile(fileName);
	end
end

--*************************************************************************************************

execute = function(word)
	local errmsg

	if (_comment) then
		if (word == ")") then
			_D[")"]()
		end
	elseif (_compile) then
		if (word == ";") then
			_D[";"]()
		else
			_compileLine = _compileLine .. " " .. word
		end
	elseif (_if) then
		if (word == "then") then
			_D["then"]()
		else
			_ifLine = _ifLine .. " " .. word
		end
	elseif (_print) then
		if (word == '"') then
			_D['"']()
		else
			_printLine = _printLine .. " " .. word
		end
	elseif (_variable) then
		_variable = nil
		_D[word] = 0
	elseif (_see) then
		_see = nil
		if (_D[word] and type(_D[word]) ~= "function") then
			print(" ".._D[word])
		else
			error(" " .. word .. "\t?", 0)
		end
	elseif (_forget) then
		_forget = false
		local a = _D[word]
		if (a) then
			_D[word] = nil
			print(string.format(" Forgot '%s'", word))
		else
			error(" "..word.. "\t?", 0)
		end
	else
		local ok = false
		local f = _D[word]
		if (f) then
			if (type(f) == "function") then
				_D[word]()
			elseif (type(f) == "string") then
				inner(f)
			elseif (type(f) == "number") then
				_stack:push(f)
			else
				error(" Invalid dictionary entry '"..tostring(word).."'", 0)
			end
		else
			_D.number(word)
		end
	end
end

inner = function(line)
	for word in line:gmatch("([^%s]*)") do
		if (#word > 0) then
			execute(word)
			_lastWord = word
		end
	end
end

outer = function()
	local errmsg = nil
	local ok = false

	local input = rdl.readline("")
	while input do
		if (input ~= _lastInput) then
			rdl.tohistory(input)
		end
		ans = nil
		_, errmsg = pcall(inner, input)
		if (errmsg) then
			print(" " .. errmsg)
		else
			if (ans) then
				io.write(string.format(" ".._outFormat, ans))
			end
			print(" ok")
		end
		input = rdl.readline("")
	end
end

--*************************************************************************************************

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
			else
				print("Unknown argument: '" .. arg[i] .. "'")
				print(_greeting)
				os.exit(1)
			end
		end
	end

	print(_greeting)

	--Require the readline library here to be able to print help
	--that contains instructions to build the lreadline.so helper.
	--Fall back on io.read() if readline not available.
	if (not pcall(function() rdl = require("lreadline") end)) then
		print("\nCould not load 'lreadline.so', command line history disabled.\n")
		rdl = {readline = function() return io.read("*l") end, tohistory = function() end }
	end

	print("Type 'bye' to quit.")

	_D["load"]()
	outer()

	return 0
end

--The variable "arg" is automatically created by the Lua interpreter
--as an array of the command line arguments.
return main(arg)

