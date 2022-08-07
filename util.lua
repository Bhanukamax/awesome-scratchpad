local M = {}
local table_has
local function _1_(tabel, pin)
  local found = false
  for key, c in pairs(__fnl_global__screen_2dclients) do
    if (c == pin) then
      found = true
    else
    end
  end
  return found
end
table_has = _1_
M["table-has"] = table_has
return M
