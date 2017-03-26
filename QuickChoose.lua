-- This enables some fun stuff by pressing alt + scpacebar

require("hs.chooser")
require("hs.window")

local focusedWindow = ""
local choices = {
  { ["text"] = "Screensaver",
    ["subText"] = "Because it never launches automaticaly",
    ["uuid"] = "screensaver"
  },
 { ["text"] = "Lock",
   ["subText"] = "Lock unwanted guests out",
   ["uuid"] = "lock"
 },
 { ["text"] = "Sleep",
   ["subText"] = "Because I will be back soon",
   ["uuid"] = "sleep"
 },
 { ["text"] = "Shutdown",
   ["subText"] = "It's never goodby",
   ["uuid"] = "shutdown"
 },
 { ["text"] = "Toggle Redshift",
   ["subText"] = "White, or red, or white, or red",
   ["uuid"] = "redshiftToggle"
 },
 { ["text"] = "Clear pasteboard",
   ["subText"] = "Somethimes you have to start from a blank page",
   ["uuid"] = "clearPasteboard"
 },
 { ["text"] = "Toggle pasteboard watcher",
   ["subText"] = "Everyone needs some private time",
   ["uuid"] = "togglePasteboard"
 },
 { ["text"] = "Toggle shadows",
   ["subText"] = "Without object, no shadow",
   ["uuid"] = "toggleShadow"
 },
}

function getChoicesSize()
    local count = 0
    for _ in pairs(choices) do count = count + 1 end
    return count
end

function didChoose(choice)
    if not choice then
        -- print("Chooser cancelled")
        focusedWindow:focus()
        return
    end
    -- print("didChooseScreen: "..choice["text"])
    if     choice["uuid"] == "lock" then
        hs.caffeinate.lockScreen()
    elseif choice["uuid"] == "sleep" then
        hs.caffeinate.systemSleep()
    elseif choice["uuid"] == "shutdown" then
        hs.caffeinate.shutdownSystem()
    elseif choice["uuid"] == "screensaver" then
        hs.caffeinate.startScreensaver()
    elseif choice["uuid"] == "redshiftToggle" then
        hs.redshift.toggle()
    elseif choice["uuid"] == "clearPasteboard" then
        clearPasteboard()
    elseif choice["uuid"] == "togglePasteboard" then
        togglePasteboardWatcher()
    elseif choice["uuid"] == "toggleShadow" then
        toggleShadow()
    end
    focusedWindow:focus()
end

function quickChooser()
    -- print("quickChooser")
    -- focusedWindow will lose focus to hs.chooser
    focusedWindow = hs.window.focusedWindow()
    -- start actual chooser
    local chooser = hs.chooser.new(didChoose)
    chooser:choices(choices)
    chooser:rows(getChoicesSize())
    chooser:show()
end

hs.hotkey.bind({"alt"}, "space", function()
  quickChooser()
end)
