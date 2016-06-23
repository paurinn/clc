/*
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
*/
/**
@defgroup lreadline Minimal Lua wrapper for GNU libreadline.
@{
*/

#include <stdio.h>
#include <readline/readline.h>
#include <readline/history.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

int l_readline(lua_State *L) {
	const char *prompt = NULL;

	if (lua_isstring(L, 1)) {
		prompt = lua_tostring(L, 1);
	} else {
		prompt = ">";
	}

	char *pz = readline(prompt);
	if (pz != NULL) {
		lua_pushstring(L, pz);
		return 1;
	}
	return 0;
}

int l_addhistory(lua_State *L) {
	if (lua_isstring(L, 1)) {
		add_history(lua_tostring(L, 1));
	}
	return 0;
}


static const struct luaL_Reg lreadline[] = {
	{"readline",   l_readline},
	{"addhistory", l_addhistory},
	//--
	{NULL, NULL}  /* sentinel */
};

int luaopen_lreadline(lua_State *L) {
	lua_newtable(L);
	luaL_setfuncs(L, lreadline, 0);
	return 1;
}

/** @} */

