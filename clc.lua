#!/usr/bin/lua5.3

local _version = [[
clc v0.8
]]

local _warranty = _version .. [[

================================================================================
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

================================================================================
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

This is a reverse polish notation calcuator using FORTH as command language.

  Mnemonic  |  Stack Effect         |  Description
------------|-----------------------|-------------------------------------------
 float      | ( - )                 | Floating point mode (default).
 decimal    | ( - )                 | Decimal mode.
 hex        | ( - )                 | Hexadecimal mode.
 .          | (n1 - )               | Pop stack and print.
 emit       | (n1 - )               | Emit ASCII character.
 space      | ( - )                 | Emip ASCII space.
 spaces     | ( - )                 | Emit multip ASCII spaces.
 cr         | ( - )                 | Emit ASCII line feed.
 ."         | ( - )                 | Begin string message to be printed.
 "          | ( - )                 | End string message and print it.
 +          | (n1 n2 - n)           | Pops two values, calculates n1 + n2, pushes result.
 -          | (n1 n2 - n)           | Pops two values, calculates n1 - n2, pushes result.
 *          | (n1 n2 - n)           | Pops two values, calculates n1 * n2, pushes result.
 /          | (n1 n2 - n)           | Pops two values, calculates n1 / n2, pushes result.
 %          | (n1 n2 - n)           | Pops two values, calculates n1 % n2, pushes result.
 1+         | (n1 - n)              | Pops one value, calculates n1 + 1, pushes result.
 1-         | (n1 - n)              | Pops one value, calculates n1 - 1, pushes result.
 2+         | (n1 - n)              | Pops one value, calculates n1 + 2, pushes result.
 2-         | (n1 - n)              | Pops one value, calculates n1 - 2, pushes result.
 2*         | (n1 - n)              | Pops one value, calculates n1 * 2, pushes result.
 2/         | (n1 - n)              | Pops one value, calculates n1 / 2, pushes result.
 */         | (n1 n2 n3 - n)        | Pops three values, calculates (n1 * n2) / n3, pushes result.
 /%         | (n1 n2 - n n)         | Pops two values, calculates (n1 / n2) and (n1 % 2), pushes quotient and remainder.
 */%        | (n1 n2 n3 - n n)      | Pops three values, calculates ((n1 * n2) / n3) and ((n1 * n2) % n3). Pushes quotient and remainder.
 tau        | ( - n)                | Pushes the value of Tau (2 * PI).
 pi         | ( - n)                | Pushes the values Pi (Tau / 2).
 min        | (n1 n2 - n)           | Pops two values, calculates the minimum vaule and pushes it.
 max        | (n1 n2 - n)           | Pops two values, calculates the minimum vaule and pushes it.
 abs        | (n1 - n)              | Pops value, pushes its absolute value.
 neg        | (n1 - n)              | Pops value, pushes its negated value.
 sqrt       | (n1 - n)              | Pops value, pushes the square root of it.
 sin        | (n1 - n)              | Pops value, pushes sin(n1).
 cos        | (n1 - n)              | Pops value, pushes cos(n1).
 tan        | (n1 - n)              | Pops value, pushes tan(n1).
 atan       | (n1 - n)              | Pops value, pushes atan(n1).
 atan2      | (n1 n2 - n)           | Pops two values, pushes atan2(n1, n2).
 pow        | (n1 n2 - n)           | Pops two values, pushes n1 to the power of n2.
 ~          | (n1 - n)              | Pops value, pushes its bitwise negation (all bits flipped).
 \|         | (n1 - n)              | Pops two values, pushes the bitwise OR of the values.
 &          | (n1 n2 - n)           | Pops two values, pushes the bitwise AND of the values.
 ^          | (n1 n2 - n)           | Pops two values, pushes the bitwise exlusive OR of the values.
 1>>        | (n1 - n)              | Pops one value, pushes the bitwise right shift of the value.
 1<<        | (n1 - n)              | Pops one value, pushes the bitwise left shift of the value.
 >>         | (n1 n2 - n)           | Pops two values, pushes the bitwise right shift i.e. (n1 >> n2).
 <<         | (n1 n2 - n)           | Pops two values, pushes the bitwise left shift i.e. (n1 >> n2).
 if         | (f - )                | Pops one value, continues if flag is non-zero.
 else       | ( - )                 | The route taken on IF if the flag is zero.
 then       | ( - )                 | The route taken on IF in either case.
 0=         | (n1 - f)              | Pops one value, pushes -1 if value is zero, else pushes 0.
 0>         | (n1 - f)              | Pops one value, pushes -1 if value is above zero, else pushes 0.
 0<         | (n1 - f)              | Pops one value, pushes -1 if value is below zero, else pushes 0.
 =          | (n1 n2 - f)           | Pops two values, pushes -1 if n1 equals n2, else pushes 0.
 >          | (n1 n2 - f)           | Pops two values, pushes -1 if n1 is smaller than n2.
 <          | (n1 n2 - f)           | Pops two values, pushes -1 if n1 is larger than n2.
 >=         | (n1 n2 - f)           | Pops two values, pushes -1 if n1 is larger than or equal to n2.
 <=         | (n1 n2 - f)           | Pops two values, pushes -1 if n1 is larger than or equal to n2.
 not        | (f1 - f)              | Pops a flag, pushes its negated value i.e. 0 becomes -1 and any other value becomes 0.
 and        | (f1 f2 - f)           | Pops two flags, pushes -1 if both f1 and f2 are TRUE, else pushes 0.
 or         | (f1 f2 - f)           | Pops two flags, pushes -1 if either f1 and f2 is TRUE, else pushes 0.
 xor        | (f1 f2 - f)           | Pops two flags, pushes -1 if either f1 and f2 are TRUE but not both, else pushes 0.
 drop       | (n - )                | Pops the stack.
 dup        | (n1 - n1 n1)          | Duplicates top of stack.
 over       | (n1 n2 - n1 n2 n1)    | Duplicates 2nd stack item from the top.
 swap       | (n1 n2 - n2 n1)       | Swap top two stack elements.
 rot        | (n1 n2 n3 - n2 n3 n1) | Rotates third stack item to the top.
 2drop      | (n1 n2 - )            | Pop stack twice.
 2dup       | (d1 - d1 d1)          | Duplicate the two top-most stack items.
 2over      | (d1 d2 - d1 d2 d1)    | Duplicates second pair from the top.
 2swap      | (d1 d2 - d2 d1)       | Swap the two top-most pairs on stack.
 var        | ( - )                 | Declare variable.
 !          | ( - )                 | Store variable.
 :          | ( - )                 | Begin word compilation.
 `          | ( - )                 | Begin Lua compilation.
 ;          | ( - )                 | End compilation.
 see        | ( - )                 | Print definition of word.
 list       | ( - )                 | Print contents of dictionary.
 forget     | ( - )                 | Remove word from dictionary.
 writestate | ( - )                 | Write dictionary to file state.clc.
 readstate  | ( - )                 | Read dictionary from file state.clc.
 (          | ( - )                 | Start a comment block of all following words  until ')'.
 )          | ( - )                 | Ends a comment block.
 page       | ( - )                 | Clear screen.
 ?stack     | ( - f)                | Pushes -1 if stack is empty, else pushes 0.
 stack      | ( - )                 | Print stack contents.
 reset      | (XXX)                 | Stack is emptied.
 exec       | ( - )                 | Execute file.
 exit       | ( - )                 | Quit program.
 quit       | ( - )                 | Quit program.
 bye        | ( - )                 | Quit program.

]]

--*************************************************************************************************

_lastInput = ""

_prompt = "> "

_D = {}

_stack = {}

_compile = false
_compileLine = ""
_compiledLua = {}

_lastWord = ""

_outFormats = {
	decimal = function(v) return string.format("%u", math.floor(v)) end,
	float = function(v) return string.format("%g", v) end,
	hex = function(v) return string.format( "%0X", math.floor(v)) end
}

_outFormat = _outFormats.float

_if = false
_ifLine = ""

_print = false
_printLine = ""

_see = false

_forget = false

_comment = false

_load = false

--*************************************************************************************************

function _stack:push(value)
	self[#self+1] = value
end

function _stack:pop()
	if (#self <= 0) then
		error(" Underflow", 0)
	end
	return table.remove(self)
end

--*************************************************************************************************

_D["help"] = function()
	print(_help)
end

_D["+"] = function()
	_stack:push(_stack:pop() + _stack:pop())
	ans = _stack[#_stack]
end

_D["-"] = function()
	local a = _stack:pop()
	_stack:push(_stack:pop() - a)
	ans = _stack[#_stack]
end

_D["*"] = function()
	_stack:push(_stack:pop() * _stack:pop())
	ans = _stack[#_stack]
end

_D["/"] = function()
	local a = _stack:pop()
	_stack:push(_stack:pop() / a)
	ans = _stack[#_stack]
end

_D["%"] = function()
	local a = _stack:pop()
	_stack:push(_stack:pop() % a)
	ans = _stack[#_stack]
end

_D["/%"] = function()
	local b, a = _stack:pop(), _stack:pop()
	_stack:push(a % b)
	_stack:push(a / b)
	ans = _stack[#_stack]
end

_D["1+"] = function()
	_stack:push(_stack:pop() + 1)
	ans = _stack[#_stack]
end

_D["1-"] = function()
	_stack:push(_stack:pop() - 1)
	ans = _stack[#_stack]
end

_D["2+"] = function()
	_stack:push(_stack:pop() + 2)
	ans = _stack[#_stack]
end

_D["2-"] = function()
	_stack:push(_stack:pop() - 2)
	ans = _stack[#_stack]
end

_D["2*"] = function()
	_stack:push(_stack:pop() * 2)
	ans = _stack[#_stack]
end

_D["2/"] = function()
	_stack:push(_stack:pop() / 2)
	ans = _stack[#_stack]
end

_D["sqrt"] = function()
	_stack:push(math.sqrt(_stack:pop()))
	ans = _stack[#_stack]
end

_D["sin"] = function()
	_stack:push(math.sin(_stack:pop()))
	ans = _stack[#_stack]
end

_D["cos"] = function()
	_stack:push(math.cos(_stack:pop()))
	ans = _stack[#_stack]
end

_D["tan"] = function()
	_stack:push(math.tan(_stack:pop()))
	ans = _stack[#_stack]
end

_D["atan"] = function()
	_stack:push(math.atan(_stack:pop()))
	ans = _stack[#_stack]
end

_D["atan2"] = function()
	local b, a = _stack:pop(), _stack:pop()
	_stack:push(math.atan2(a, b))
	ans = _stack[#_stack]
end

_D["pow"] = function()
	local b, a = _stack:pop(), _stack:pop()
	_stack:push(math.pow(a, b))
	ans = _stack[#_stack]
end

_D["pi"] = function()
	_stack:push(math.pi)
	ans = _stack[#_stack]
end

_D["tau"] = function()
	_stack:push(math.pi * 2)
	ans = _stack[#_stack]
end

_D["abs"] = function()
	_stack:push(math.abs(_stack:pop()))
	ans = _stack[#_stack]
end

_D["neg"] = function()
	_stack:push(-_stack:pop())
	ans = _stack[#_stack]
end

_D["min"] = function()
	local b, a  = _stack:pop(), _stack:pop()
	_stack:push(math.min(a, b))
	ans = _stack[#_stack]
end

_D["max"] = function()
	local b, a  = _stack:pop(), _stack:pop()
	_stack:push(math.max(a, b))
	ans = _stack[#_stack]
end

_D["*/"] = function()
	local c, b, a  = _stack:pop(), _stack:pop(), _stack:pop()
	_stack:push(a * b / c)
	ans = _stack[#_stack]
end

_D["*/%"] = function()
	local c, b, a  = _stack:pop(), _stack:pop(), _stack:pop()
	_stack:push((a * b) % c)
	_stack:push((a * b) / c)
	ans = _stack[#_stack]
end


_D["~"] = function()
	local a = math.floor(_stack:pop())
	_stack:push(~a) ans = _stack[#_stack]
end

_D["|"] = function()
	local b, a = math.floor(_stack:pop()), math.floor(_stack:pop())
	_stack:push(a | b) ans = _stack[#_stack]
end

_D["&"] = function()
	local b, a = math.floor(_stack:pop()), math.floor(_stack:pop())
	_stack:push(a & b) ans = _stack[#_stack]
end

_D["^"] = function()
	local b, a = math.floor(_stack:pop()), math.floor(_stack:pop())
	_stack:push(a ~ b) ans = _stack[#_stack]
end

_D[">>"] = function()
	local b, a = math.floor(_stack:pop()), math.floor(_stack:pop())
	_stack:push(a >> b) ans = _stack[#_stack]
end

_D["<<"] = function()
	local b, a = math.floor(_stack:pop()), math.floor(_stack:pop())
	_stack:push(a << b) ans = _stack[#_stack]
end

_D["1>>"] = function()
	local a = math.floor(_stack:pop())
	_stack:push(a >> 1) ans = _stack[#_stack]
end

_D["1<<"] = function()
	local a = math.floor(_stack:pop())
	_stack:push(a << 1) ans = _stack[#_stack]
end

_D["."] = function()
	io.write(" ", _outFormat(_stack:pop()))
end

_D["emit"] = function()
	io.write(string.char(math.floor(_stack:pop())))
end

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
			_compiledLua[name] = _compileLine
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

_D["dup"] = function()
	local e = _stack:pop()
	_stack:push(e)
	_stack:push(e)
end

_D["swap"] = function()
	local a, b = _stack:pop(), _stack:pop()
	_stack:push(a)
	_stack:push(b)
end

_D["over"] = function()
	local a, b = _stack:pop(), _stack:pop()
	_stack:push(b)
	_stack:push(a)
	_stack:push(b)
end

_D["rot"] = function()
	local a, b, c = _stack:pop(), _stack:pop(), _stack:pop()
	_stack:push(a)
	_stack:push(b)
	_stack:push(c)
end

_D["drop"] = function()
	_stack:pop()
end

_D["2swap"] = function()
	local d, c, b, a = _stack:pop(), _stack:pop(), _stack:pop(), _stack:pop()
	_stack:push(c)
	_stack:push(d)
	_stack:push(a)
	_stack:push(b)
end

_D["2dup"] = function()
	local a, b = _stack:pop(), _stack:pop()
	_stack:push(b)
	_stack:push(a)
	_stack:push(b)
	_stack:push(a)
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

_D["2drop"] = function()
	_stack:pop()
	_stack:pop()
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

_D["="] = function()
	_stack:push((_stack:pop() == _stack:pop()) and -1 or 0)
	ans = _stack[#_stack]
end

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

_D["<="] = function()
	local b, a = _stack:pop(), _stack:pop()
	_stack:push((a <= b) and -1 or 0)
	ans = _stack[#_stack]
end

_D[">="] = function()
	local b, a = _stack:pop(), _stack:pop()
	_stack:push((a >= b) and -1 or 0)
	ans = _stack[#_stack]
end

_D["0="] = function()
	_stack:push((_stack:pop() == 0) and -1 or 0)
	ans = _stack[#_stack]
end

_D["0<"] = function()
	_stack:push((_stack:pop() < 0) and -1 or 0)
	ans = _stack[#_stack]
end

_D["0>"] = function()
	_stack:push((_stack:pop() > 0) and -1 or 0)
	ans = _stack[#_stack]
end

_D["not"] = function()
	_stack:push((_stack:pop() == 0) and -1 or 0)
	ans = _stack[#_stack]
end

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

_D["?stack"] = function()
	_stack:push((#_stack == 0) and -1 or 0)
	ans = _stack[#_stack]
end

_D["stack"] = function()
	if (#_stack <= 0) then return end
	print("------------")
	for i = 1, #_stack do
		print(" ".._outFormat(_stack[#_stack - (i - 1)]))
	end
	print("------------")
end

_D["page"] = function()
	io.write("\027[2J")
	io.flush()
end

_D["hex"] = function()
	_outFormat = _outFormats.hex
end

_D["float"] = function()
	_outFormat = _outFormats.float
end

_D["decimal"] = function()
	_outFormat = _outFormats.decimal
end

_D["var"] = function()
	_variable = true
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

_D["reset"] = function()
	while #_stack > 0 do
		_stack:pop()
	end
end

_D["bye"] = function()
	_D["writestate"]()
	os.exit(0)
end

_D["exit"] = function()
	_D["writestate"]()
	os.exit(0)
end

_D["quit"] = function()
	_D["writestate"]()
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
		if (type(v) == "string") then
			--Strings are code.
			io.write(string.format(": %s %s ;\n", k, v))
		elseif (type(v) == "number") then
			--Numbers are variables.
			io.write("var ", k, " = ", _outFormat(v), "\n")
		elseif (type(v) == "function" and _compiledLua[k]) then
			--Functions are internals or compiled Lua code.
			if (_compiledLua[k]) then
				io.write("` ", _compiledLua[k], " ;\n")
			end
		end
	end
end

_D["writestate"] = function()
	local fileName = "state.clc"
	local F = io.open(fileName, "w+")
	local vars = {}
	if (F) then
		for k, v in pairs(_D) do
			if (type(v) == "string") then
				--Strings are code.
				F:write(string.format(": %s %s ;\n", k, v))
			elseif (type(v) == "number") then
				--Numbers are variables.
				F:write("var "..k.."\n")
				F:write(_outFormat(v).." "..k.." !\n")
			elseif (type(v) == "function" and _compiledLua[k]) then
				--Functions are internals or compiled Lua code.
				if (_compiledLua[k]) then
					F:write("` ".._compiledLua[k].." ;\n")
				end
			end
		end
		F:close()
	else
		error(" Could not open file '" .. fileName .. "' for reading and writing.")
	end
end

_D["readstate"] = function()
	local fileName = "state.clc"
	local F = io.open(fileName, "r")
	if (F) then
		outer(F)
		F:close()
	end
end

_D["exec"] = function()
	_load = true
end

--*************************************************************************************************

number = function(word)
	local a = tonumber(word)
	if (a) then
		_stack:push(a)
	else
		error(" " .. word .. "\t?", 0)
	end
end

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
		_D[word] = _D[word] or 0
	elseif (_see) then
		_see = nil
		local v = _D[word]
		if (v) then
			if (type(v) ~= "string" or type(v) ~= "number") then
				print(" "..v)
			elseif (type(v) ~= "function") then
				if (_compiledLua[word]) then
					print(" ".._compiledLua[word])
				end
			end
		else
			error(" " .. word .. "\t?", 0)
		end
	elseif (_forget) then
		_forget = false
		local a = _D[word]
		if (a) then
			_D[word] = nil
			_compiledLua[word] = nil
			print(string.format(" Forgot '%s'", word))
		else
			error(" "..word.. "\t?", 0)
		end
	elseif (_load) then
		_load = false
		local F = io.open(word, "r")
		if (not F) then
			error(string.format(" Could not open file '%s' for reading.", word))
		end
		outer(F)
		F:close()
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
			number(word)
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

outer = function(file)
	local errmsg = nil
	local ok = false
	local input

	if (file) then
		input = file:read("*l")
	else
		input = rdl.readline(_prompt)
	end

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
				io.write(" ", _outFormat(ans))
			end
			print(" ok")
		end

		if (file) then
			input = file:read("*l")
		else
			input = rdl.readline(_prompt)
		end
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

	--Fall back on io.read() if readline not available.
	if (not pcall(function() rdl = require("lreadline") end)) then
		print("\nCould not load 'lreadline.so', command line history disabled.\n")
		rdl = {readline = function(p) if (p) then io.write(p) end return io.read("*l") end, tohistory = function() end }
	end

	print("Type 'bye' to quit.")

	_D["readstate"]()
	outer()

	return 0
end

--The variable "arg" is automatically created by the Lua interpreter
--as an array of the command line arguments.
return main(arg)

