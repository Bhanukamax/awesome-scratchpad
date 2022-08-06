local function fn_2ffilter(arr, cb)
  local new_arr = {}
  for key, value in pairs(arr) do
    if (cb(value) == true) then
      table.insert(new_arr, value)
    else
    end
  end
  return new_arr
end
local awful = require("awful")
local naughty = require("naughty")
local inspect = require("inspect")
local screen = awful.screen.focused()
local M = {}
local active_sp_idx = 0
local is_sp_visible = false
local util = {}
local table_has
local function _2_(tabel, pin)
  local found = false
  for key, c in pairs(tabel) do
    if (c == pin) then
      found = true
    else
    end
  end
  return found
end
table_has = _2_
util["table-has"] = table_has
local function _4_(tbl)
  return naughty.notify({text = inspect({tbl = tbl})})
end
M.alert = _4_
local buf = {}
local function get_screeen_clietns()
  local screen0 = awful.screen.focused()
  local stag = screen0.selected_tag
  local screen_clients = stag:clients()
  return screen_clients
end
local function get_current_tag()
  local screen0 = awful.screen.focused()
  return screen0.selected_tag()
end
local function send_to_scratch(c)
  local screen0 = awful.screen.focused()
  local stag = screen0.selected_tag
  local screen_clients = stag:clients()
  local to_keep = {}
  for key, cc in pairs(screen_clients) do
    if (client.focus == cc) then
      if (util["table-has"](buf, cc) == false) then
        table.insert(buf, cc)
        M.alert("sent to scrattch")
      else
      end
    else
      if (util["table-has"](buf, cc) == false) then
        table.insert(to_keep, cc)
      else
      end
    end
  end
  stag:clients(to_keep)
  return M.alert({msg = "to-keep", ["to-keep"] = to_keep, sent = buf})
end
local is_visible = false
local last_visible_idx = 0
local visible_scratch_client = {}
local current_scratch_idx = 0
local function set_client_props(c)
  c.ontop = true
  c.floating = true
  c.height = height
  c.width = width
  c.x = x
  c.y = y
  return nil
end
local function show_scratch(c)
  local screen0 = awful.screen.focused()
  local stag = screen0.selected_tag
  local buf_count = #buf
  local sclients = get_screeen_clietns()
  if (buf_count > 0) then
    current_scratch_idx = (1 + ((last_visible_idx + 1) % buf_count))
  else
  end
  M.alert({["curretn-idx"] = current_scratch_idx, msg = "showing", clients = sclients, scratch = buf})
  local cs = buf[current_scratch_idx]
  table.insert(sclients, cs)
  visible_scratch_client = cs
  stag:clients(sclients)
  set_client_props(cs)
  is_visible = true
  last_visible_idx = current_scratch_idx
  return nil
end
local function hide_scratch()
  local screen0 = awful.screen.focused()
  local stag = screen0.selected_tag
  local sclients = get_screeen_clietns()
  local non_scratch_clients
  local function _9_(i)
    return (i ~= visible_scratch_client)
  end
  non_scratch_clients = fn_2ffilter(sclients, _9_)
  stag:clients(non_scratch_clients)
  M.alert("hiding scratchs!!")
  is_visible = false
  return nil
end
local function toggle_scratch(c)
  if (is_visible == false) then
    return show_scratch(c)
  else
    return hide_scratch(c)
  end
end
M.send_to_scratch = send_to_scratch
M.toggle_scratch = toggle_scratch
return M
