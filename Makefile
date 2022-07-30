all: scratchpad.lua

scratchpad.lua: ./scratchpad.fnl
	fennel --compile ./scratchpad.fnl > scratchpad.lua
