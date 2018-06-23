/**
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
*/
#include <stdlib.h>
#include <stdio.h>
#include <readline/readline.h>
#include <readline/history.h>
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

/*************************************************************************************************/

static int Lua_readline(lua_State *L) {
	const char *prompt = "";

	if (lua_type(L, 1)) {
		prompt = lua_tostring(L, 1);
	}

	char * zline = readline(prompt);

	if (zline != NULL && zline[0] != '\0') {
		lua_pushstring(L, zline);
	} else {
		lua_pushstring(L, "");
	}

	return 1;
}

static int Lua_tohistory(lua_State *L) {
	if (lua_type(L, 1) != LUA_TSTRING) {
		return 0;
	}

	const char *zstr = lua_tostring(L, 1);
	add_history(zstr);
	return 0;
}

static const struct luaL_Reg lreadline[] = {
	{ "readline", Lua_readline },
	{ "tohistory", Lua_tohistory},
	//--
	{ NULL, NULL }
};


int luaopen_lreadline(lua_State *L) {
	luaL_newlib(L, lreadline);
	return 1;
}

