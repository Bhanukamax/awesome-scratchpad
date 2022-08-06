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
local function old_2fsend_to_scratch(c)
  scratchpad.insert(c)
  local screen0 = awful.screen.focused()
  local ctag = (screen0.tags)[9]
  local workarea = screen0.workarea
  local height = (workarea.height / 2)
  local width = (workarea.width / 2)
  local x = (width / 2)
  local y = (height / 2)
  if (client.focus == c) then
    do end (client.focus):move_to_tag(ctag)
    c.ontop = true
    c.floating = true
    c.height = height
    c.width = width
    c.x = x
    c.y = y
    return nil
  else
    return nil
  end
end
local function hide_scratch(c)
  is_sp_visible = false
  return nil
end
local function show_scratch(c)
  is_sp_visible = true
  local screen0 = awful.screen.focused()
  local stag = (screen0.tags)[9]
  local screen_clients = stag:clients()
  local sp_count = #screen_clients
  active_sp_idx = ((active_sp_idx + 1) % sp_count)
  for key, c_client in pairs(screen_clients) do
    if ((active_sp_idx + 1) == key) then
      c_client.ontop = true
      c_client.floating = true
      c_client:raise()
      c_client.skip_taskbar = false
      c_client.minimized = false
      client.focus = c_client
    else
      c_client.skip_taskbar = true
      c_client.minimized = true
    end
  end
  return nil
end
local function toggle_scratch(c)
  local screen0 = awful.screen.focused()
  local stag = (screen0.tags)[9]
  local screen_clients = stag:clients()
  local sp_count = #screen_clients
  if (sp_count > 0) then
    if is_sp_visible then
      hide_scratch(c)
    else
      show_scratch(c)
    end
    return awful.tag.viewtoggle((screen0.tags)[9])
  else
    return nil
  end
end
M.send_to_scratch = send_to_scratch
M.toggle_scratch = toggle_scratch
return M
