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
local is_visible = false
local visible_scratch_client = {}
local current_scratch_idx = 0
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
local function _5_()
  local screen = awful.screen.focused()
  local stag = screen.selected_tag
  local screen_clients = stag:clients()
  return screen_clients
end
M["get-screeen-clients"] = _5_
local function _6_(c)
  c.floating = false
  c.ontop = false
  return nil
end
M["remove-scratch-props"] = _6_
local function _7_(c)
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
M["set-client-props"] = _7_
local function _8_(c)
  local screen = awful.screen.focused()
  local stag = screen.selected_tag
  local screen_clients = stag:clients()
  local to_keep = {}
  for key, cc in pairs(screen_clients) do
    if (client.focus == cc) then
      if (util["table-has"](buf, cc) == false) then
        table.insert(buf, cc)
        M["set-client-props"](cc)
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
M["send-to-scratch"] = _8_
local function _12_(c)
  local new_buf
  local function _13_(i)
    return (i ~= c)
  end
  new_buf = fn_2ffilter(buf, _13_)
  buf = new_buf
  M["remove-scratch-props"](c)
  if (#buf > 0) then
    M["show-scratch"]()
    return M["hide-scratch"]()
  else
    return nil
  end
end
M["remove-client-from-scratch"] = _12_
local function _15_(c)
  local buf_has_client = table_has(buf, c)
  if (buf_has_client == true) then
    return M["remove-client-from-scratch"](c)
  else
    return M["send-to-scratch"](c)
  end
end
M["toggle-send"] = _15_
local function _17_(c)
  local screen = awful.screen.focused()
  local w = screen.workarea
  c.ontop = true
  c.focused = true
  c.floating = true
  if ((c.y < w.y) or (c.y > (w.y + w.height)) or ((c.x + c.width) > (w.y + w.width)) or ((c.y + c.height) > (w.y + w.height))) then
    c.height = (w.height / 2)
    c.width = (w.width / 2)
    c.x = ((w.width / 10) + w.x)
    c.y = ((w.height / 10) + w.y)
    return nil
  else
    return nil
  end
end
M["sanitize-client-props"] = _17_
local function _19_()
  local screen = awful.screen.focused()
  local stag = screen.selected_tag
  local buf_count = #buf
  local sclients = M["get-screeen-clients"]()
  local cs = buf[(current_scratch_idx + 1)]
  table.insert(sclients, cs)
  visible_scratch_client = cs
  stag:clients(sclients)
  is_visible = true
  M["sanitize-client-props"](cs)
  client.focus = cs
  return nil
end
M["show-scratch"] = _19_
local function _20_()
  local screen = awful.screen.focused()
  local stag = screen.selected_tag
  local sclients = M["get-screeen-clients"]()
  local non_scratch_clients
  local function _21_(i)
    return (i ~= visible_scratch_client)
  end
  non_scratch_clients = fn_2ffilter(sclients, _21_)
  stag:clients(non_scratch_clients)
  is_visible = false
  return nil
end
M["hide-scratch"] = _20_
local function _22_()
  if (is_visible == false) then
    return M["show-scratch"]()
  else
    M["hide-scratch"]()
    local buf_count = #buf
    local new_idx = ((current_scratch_idx + 1) % buf_count)
    current_scratch_idx = new_idx
    M["show-scratch"]()
    M["sanitize-client-props"](visible_scratch_client)
    return M.alert("show shwo next")
  end
end
M.cycle = _22_
local function _24_()
  if (#buf > 0) then
    if (is_visible == false) then
      return M["show-scratch"]()
    else
      return M["hide-scratch"]()
    end
  else
    return nil
  end
end
M["toggle-scratch"] = _24_
M.send_to_scratch = M["send-to-scratch"]
M.toggle = M["toggle-scratch"]
M.toggle_send = M["toggle-send"]
return M
