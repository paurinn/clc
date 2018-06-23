# clc v0.8

	============================================================================
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

	============================================================================

## Introduction

This program is a basic FORTH kernel implementing the following words:

  Mnemonic  |  Stack Effect         |  Description
:-----------|:----------------------|:------------------------------------------
 float      | ( - )                 | Floating point mode (default).
 decimal    | ( - )                 | Decimal mode.
 hex        | ( - )                 | Hexadecimal mode.
 .          | ( - )                 | Pop stack and print.
 emit       | ( - )                 | Emit ASCII character.
 space      | ( - )                 | Emip ASCII space.
 spaces     | ( - )                 | Emit multip ASCII spaces.
 cr         | ( - )                 | Emit ASCII line feed.
 ."         | ( - )                 | Begin string message to be printed.
 "          | ( - )                 | End string message and print it.
 +          | (n1 n2 - n)           | Pops two values, calculates n1 + n2, pushes result.
 -          | (n1 n2 - n)           | Pops two values, calculates n1 - n2, pushes result.
 \*         | (n1 n2 - n)           | Pops two values, calculates n1 \* n2, pushes result.
 /          | (n1 n2 - n)           | Pops two values, calculates n1 / n2, pushes result.
 %          | (n1 n2 - n)           | Pops two values, calculates n1 % n2, pushes result.
 1+         | (n1 - n)              | Pops one value, calculates n1 + 1, pushes result.
 1-         | (n1 - n)              | Pops one value, calculates n1 - 1, pushes result.
 2+         | (n1 - n)              | Pops one value, calculates n1 + 2, pushes result.
 2-         | (n1 - n)              | Pops one value, calculates n1 - 2, pushes result.
 2\*        | (n1 - n)              | Pops one value, calculates n1 \* 2, pushes result.
 2/         | (n1 - n)              | Pops one value, calculates n1 / 2, pushes result.
 \*/        | (n1 n2 n3 - n)        | Pops three values, calculates (n1 \* n2) / n3, pushes result.
 /%         | (n1 n2 - n n)         | Pops two values, calculates (n1 / n2) and (n1 % 2), pushes quotient and remainder.
 \*/%       | (n1 n2 n3 - n n)      | Pops three values, calculates ((n1 \* n2) / n3) and ((n1 \* n2) % n3). Pushes quotient and remainder.
 tau        | ( - n)                | Pushes the value of Tau (2 \* PI).
 pi         | ( - n)                | Pushes the value of Pi (Tau / 2).
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
 \`         | ( - )                 | Begin Lua compilation.
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

## Calculator mode

When the program starts a boiler plate message is displayed and
the user may then enter his words.

Words in FORTH represent operators, subroutines and variables.

Enter some numbers and then an operator and press ENTER:

	> 1 3 +

The result will be printed as:

	 4 ok

The stack can be printed with *stack*.

	> stack
	------------
	 4
	------------

Basic functions are supported such as square root, sine, cosine, arc tangens and atan2:

	> sqrt
	 2 ok

Type *help* to list default word list.

## Compile mode

The word ':' initiates compile mode. All words following until ';' are collected
into subroutine identified by the given word.

For example, define a function to compute ((a\*a) + ab + c). Stack effect (a b c - n):

	> : solve rot dup dup * rot * + + ;

Test it out:

	> 2 3 5 solve
	 15 ok

Define Pythagoras (with comment):

	> : pygo ( a b - c ) dup * swap dup * + sqrt ;

	> 2 3 pygo
	 3.60555 ok

Conversion:

	> : KB 1024 * ;
	> : MB KB 1024 * ;

	> 2 KB
	 2048 ok

	> 27 KB 128 MB +
	 1.34245e+08 ok

To print the definition of a word use *see*:

	> see pygo
	  ( a b - c ) dup * swap dup * + sqrt
	 ok

To list the current dictionary use *list*:

	> list
	: KB  1024 * ;
	: MB  KB 1024 * ;
	: pygo  ( a b - n ) dup * swap dup * + sqrt ;
	: solve rot dup dup * rot * + + ;
	 ok

## Lua compile mode

Straight Lua code can be compiled using '\`', the back tick.

	> ` ls os.execute('ls') ;

Any Lua code is accepted but must not contain any ';' semicolon.
This is acceptable as Lua never needs semicolons.

	> ` time io.write(os.date("%Y-%m-%d")) print(os.date(" %H:%M:%S")) ;

	> time
	2018-06-23 18:44:33
	 ok

	> ls
	clc.lua  LICENSE  lreadline.c  lreadline.so  Makefile  README.html  README.md  state.clc
	 ok

The stack is accessible in Lua through `_stack:push()` and `_stack:pop()`.

	> ` clock _stack:push(os.clock()) ;
	 ok

	> clock
	 ok

	> stack
	------------
	 0.01037
	------------
	 ok

## State

The current state i.e. compiled words and variables can be backed up and restored.

To write current state to disk use the word *writestate*.

The state file is named *state.clc*.

Load it back with *readstate*.

On startup the program will try to load the file if it exists.

On exit the program will call *writestate* automatically.

## External programs

To run external file use the word *exec*.

The file name must not contain spaces.

	> exec somefile.clc
	 ok
	 ok
	 ok
	 ok

Each successful line in the file prints "ok".

## Readline Wrapper

This program uses a small libreadline wrapper implemented in lreadline.c.
In Debian or Ubuntu the package "libreadline-dev" must be installed.

The file "Makefile" builds the Lua wrapper in lreadline.c.

	$ make clean
	$ make

Optionally install the library globally:

	$ sudo make install

Alternatively just build the wrapper with gcc:

	$ gcc -fPIC -shared -lreadline -llua -o lreadline.so lreadline.c

