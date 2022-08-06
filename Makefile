all: scratchpad.lua util.lua

scratchpad.lua: ./scratchpad.fnl
	fennel --compile ./scratchpad.fnl > scratchpad.lua

util.lua: ./util.fnl
	fennel --compile ./util.fnl > util.lua
