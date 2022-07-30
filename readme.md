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
    awful.key({ modkey,           }, "-",
        scratch_pad.send_to_scratch,
        {description = "Send to scratch pad", group = "Scratchpad"}),
    awful.key({ modkey,           }, "=",
        function (c) scratch_pad.toggle_scratch(c) end,
        {description = "Toggle Scratch pad", group = "Scratchpad"}),

```

## Caveats

Current implementation uses tag 9 as the scratch workspace, So
whatever you push to the tag 9 manually will also toggle on and off
when toggling scratch pad

## Why build this

Because I was so used to i3wm scratch pad and couldn't find something
similar for AwesomeWM.
