--------------------------------------------------------------------------------
-- CONSTANTS
--------------------------------------------------------------------------------

local cmd_alt = {"cmd", "alt"}
local cmd_alt_ctrl = {"cmd", "alt", "ctrl"}
local main_monitor = "Color LCD"
local second_monitor = ""

--------------------------------------------------------------------------------
-- (re)load
--------------------------------------------------------------------------------

-- reload Hammerspoon config

hs.hotkey.bind(cmd_alt_ctrl, "R", function()
  savePasteboard()
  hs.reload()
end)

-- load seperate config files

require("WiFi")
require("mouse")
require("windows")
require("audio")
require("redshift")
require("pasteboard")
require("Karabiner")
require("QuickChoose")

--------------------------------------------------------------------------------
--Caffeine --# @heptal gist
--------------------------------------------------------------------------------

ampOnIcon = [[ASCII:
.....1a..........AC..........E
..............................
......4.......................
1..........aA..........CE.....
e.2......4.3...........h......
..............................
..............................
.......................h......
e.2......6.3..........t..q....
5..........c..........s.......
......6..................q....
......................s..t....
.....5c.......................
]]

ampOffIcon = [[ASCII:
.....1a.....x....AC.y.......zE
..............................
......4.......................
1..........aA..........CE.....
e.2......4.3...........h......
..............................
..............................
.......................h......
e.2......6.3..........t..q....
5..........c..........s.......
......6..................q....
......................s..t....
...x.5c....y.......z..........
]]

-- caffeine replacement
local caffeine = hs.menubar.new()

function setCaffeineDisplay(state)
    if state then
        caffeine:setIcon(ampOnIcon)
    else
        caffeine:setIcon(ampOffIcon)
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

--------------------------------------------------------------------------------
-- extra timesavers
--------------------------------------------------------------------------------

-- hints
hs.hints.style = "vimperator"
hs.hotkey.bind(cmd_alt_ctrl, "H", function()
    hs.hints.windowHints()
end)

-- weather menubar
local menubar = require "menubar"
menubar.init()

-- confirm config reload
hs.alert.show("Config loaded")
