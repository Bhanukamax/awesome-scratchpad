local awful = require("awful")
local naughty = require("naughty")
local inspect = require("inspect")
local screen = awful.screen.focused()
local M = {}
local active_sp_idx = 0
local is_sp_visible = false
local util = {}
local table_has
local function _1_(tabel, pin)
  local found = false
  for key, c in pairs(tabel) do
    if (c == pin) then
      found = true
    else
    end
  end
  return found
end
table_has = _1_
util["table-has"] = table_has
local function _3_(tbl)
  return naughty.notify({text = inspect({tbl = tbl})})
end
M.alert = _3_
local buf = {}
local function get_screeen_clietns()
  local screen0 = awful.screen.focused()
  local stag = screen0.selected_tag
  local screen_clients = stag:clients()
  return nil
end
local function send_to_scratch(c)
  local screen0 = awful.screen.focused()
  local stag = screen0.selected_tag
  local screen_clients = stag:clients()
  local to_keep = {}
  for key, c0 in pairs(screen_clients) do
    if (client.focus == c0) then
      if (util["table-has"](buf, c0) == false) then
        table.insert(buf, c0)
        M.alert("sent to scrattch")
      else
      end
    else
      if (util["table-has"](buf, c0) == false) then
        table.insert(to_keep, c0)
      else
      end
    end
  end
  stag:clients(to_keep)
  return M.alert({msg = "to-keep", ["to-keep"] = to_keep, sent = buf})
end
local is_visible = false
local last_visible_idx = 0
local function show_scratch()
  local buf_count = #buf
  local sclietns = get_screeen_clietns()
  M.alert({msg = "showing", clients = sclietns})
  is_visible = true
  if (buf_count > 0) then
    last_visible_idx = ((last_visible_idx + 1) % buf_count)
    return nil
  else
    return nil
  end
end
local function hide_scratch()
  M.alert("hiding scratchs!!")
  is_visible = false
  return nil
end
local function toggle_scratch(c)
  M.alert("new toggle scratch!!")
  if (is_visible == false) then
    return show_scratch(c)
  else
    return hide_scratch(c)
  end
end
M.send_to_scratch = send_to_scratch
M.toggle_scratch = toggle_scratch
return M
