# Awesome scratch pads

Scratch pad implementation similar to i3wm scratchpad for AwesomeWM.


## How to use this?

### First clone this repo to somewhere

```
https://github.com/Bhanukamax/awesome-scratchpad.git
```

### Require it in your `rc.lua` file and add keybindingns

Note: you have to require it form the correct place you cloned it to
(following will work either if you clone it in the same directory as
your `rc.lua` or you home directory `~`

```lua
    -- Require the module
    local scratchpad = require("awesome-scratchpad/scratchpad")

    -- Put these some where you put you keybinding
    -- Send or take back client from scratchpad
    awful.key({ modkey,           }, "-", scratch_pad.toggle_send,
        {description = "Send to scratch pad", group = "Scratchpad"}),
    -- Toggle the last scratchpad on and off
    awful.key({ modkey,           }, "=", scratch_pad.toggle,
        {description = "Toggle Scratch pad", group = "Scratchpad"}),
    -- Cycle through all the avaialable scratchpads
    awful.key({ modkey, "Control" }, "=", scratch_pad.cycle,
        {description = "Cycle Scratch pad", group = "Scratchpad"})


```

## Why build this

Because I was so used to i3wm scratch pad and couldn't find something
similar for AwesomeWM.
