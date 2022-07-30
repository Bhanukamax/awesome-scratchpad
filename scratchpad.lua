local awful = require("awful")
local naughty = require("naughty")
local inspect = require("inspect")
local screen = awful.screen.focused()
local M = {}
local active_sp_idx = 0
local is_sp_visible = false
local function _1_(tbl)
  return naughty.notify({text = inspect({tbl = tbl})})
end
M.alert = _1_
local function send_to_scratch(c)
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
      c_client.minimized = false
      client.focus = c_client
    else
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
