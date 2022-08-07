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
local function log(msg, tbl)
  local file = io.open("bmax-sp-log", "w+")
  file:write(inspect({msg = msg, tbl = tbl}))
  return io.close(file)
end
util.log = log
util["table-has"] = table_has
local function _4_(tbl)
  return naughty.notify({text = inspect({tbl = tbl})})
end
M.alert = _4_
local buf = {}
local function get_screeen_clietns()
  local screen = awful.screen.focused()
  local stag = screen.selected_tag
  local screen_clients = stag:clients()
  return screen_clients
end
local function get_current_tag()
  local screen = awful.screen.focused()
  return screen.selected_tag()
end
local function send_to_scratch(c)
  local screen = awful.screen.focused()
  local stag = screen.selected_tag
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
  return stag:clients(to_keep)
end
local is_visible = false
local last_visible_idx = 0
local visible_scratch_client = {}
local current_scratch_idx = 0
local function set_client_props(c)
  local screen = awful.screen.focused()
  local w = screen.workarea
  c.ontop = true
  c.floating = true
  c.height = (w.height / 2)
  c.width = (w.width / 2)
  c.x = ((w.width / 10) + w.x)
  c.y = ((w.height / 10) + w.y)
  return nil
end
local function show_scratch()
  local screen = awful.screen.focused()
  local stag = screen.selected_tag
  local buf_count = #buf
  local sclients = get_screeen_clietns()
  if (buf_count > 0) then
    current_scratch_idx = ((last_visible_idx + 1) % buf_count)
  else
  end
  local cs = buf[(current_scratch_idx + 1)]
  table.insert(sclients, cs)
  visible_scratch_client = cs
  stag:clients(sclients)
  set_client_props(cs)
  is_visible = true
  last_visible_idx = current_scratch_idx
  return nil
end
local function hide_scratch()
  local screen = awful.screen.focused()
  local stag = screen.selected_tag
  local sclients = get_screeen_clietns()
  local non_scratch_clients
  local function _9_(i)
    return (i ~= visible_scratch_client)
  end
  non_scratch_clients = fn_2ffilter(sclients, _9_)
  stag:clients(non_scratch_clients)
  is_visible = false
  return nil
end
local function toggle_scratch()
  log("calling toggle", {})
  local function _10_(s)
    return log("screen", {s = s, attr = s.idx})
  end
  awful.screen.connect_for_each_screen(_10_)
  if (is_visible == false) then
    return show_scratch()
  else
    return hide_scratch()
  end
end
M.send_to_scratch = send_to_scratch
M.toggle_scratch = toggle_scratch
return M
