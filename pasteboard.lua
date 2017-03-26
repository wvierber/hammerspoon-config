-- Quick acces to copy history

-- requirements
require("hs.timer")
require("hs.window")
require("hs.pasteboard")
require("hs.settings")
require("hs.chooser")
require("hs.eventtap")

-- variables
local updateInterval = hs.timer.seconds(2)
local focusedWindow = ""
local changeCount = hs.pasteboard.changeCount()
local copyHistory = {}
local new = {}
local watching = false

-- Restore potential stored copyHistory
if hs.settings.get("history") ~= nil then
    copyHistory = hs.settings.get("history")
else
    copyHistory = {
      {
        ["text"] = hs.pasteboard.getContents(),
        ["subText"] = ""
      },
    }
end

-- Check for changes every updateInterval
function updatePasteboard()
    if hs.pasteboard.changeCount() ~= changeCount then
      changeCount = hs.pasteboard.changeCount()
      new = {
        ["text"] = hs.pasteboard.getContents(),
        ["subText"] = ""
      }
      table.insert(copyHistory, 1, new)
      -- print("Pasteboard updated!")
    end
end

-- Call for update every x, when watching
watcher = hs.timer.new(hs.timer.seconds(updateInterval), updatePasteboard)
if watching then
    watcher:start()
    hs.alert.show("Pasteboard watcher started")
end

-- Use a chooser to acces copy history
function choosePaste(choice)
    if not choice then
        -- print("Chooser cancelled")
        focusedWindow:focus()
        return
    end
    -- print("didChooseScreen: "..choice["text"])
    -- refocus window
    focusedWindow:focus()
    -- paste choosen paste
    --hs.eventtap.keyStrokes(choice["text"])
    hs.pasteboard.setContents(choice["text"])
end

function pasteChooser()
    -- print("pasteChooser")
    updatePasteboard()
    -- focusedWindow will lose focus to hs.chooser
    focusedWindow = hs.window.focusedWindow()
    -- start actual chooser
    local chooser = hs.chooser.new(choosePaste)
    chooser:choices(copyHistory)
    chooser:show()
end

function clearPasteboard()
    copyHistory = {}
end

hs.hotkey.bind({"ctrl", "alt"}, "C", function()
    pasteChooser()
end)

-- save copyHistory
function savePasteboard()
    hs.settings.set("history", copyHistory)
end

-- toggle pasteboardwatcher on/off
function togglePasteboardWatcher()
    if watcher:running() == true then
        watcher:stop()
        hs.alert.show("Pasteboard watcher stopped")
    else
        watcher:start()
        hs.alert.show("Pasteboard watcher started")
    end
end
