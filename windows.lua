--------------------------------------------------------------------------------
-- CONSTANTS
--------------------------------------------------------------------------------


local cmd_alt = {"cmd", "alt"}
local cmd_ctrl = {"cmd", "ctrl"}
local ctrl_alt = {"alt", "ctrl"}
local mash = {"cmd", "alt", "ctrl"}
local mashshift = {"cmd", "alt", "ctrl", "shift"}
local main_monitor = "Color LCD"
local second_monitor = ""

-- grid settings
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.GRIDHEIGHT = 10
hs.grid.GRIDWIDTH = 10
hs.grid.HINTS = {
		{ "f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "f10" },
		{ "&", "é", '"', "'", "(", "§", "è", "!", "ç", "à" },
		{ "A", "Z", "E", "R", "T", "Y", "U", "I", "O", "P" },
		{ "Q", "S", "D", "F", "G", "H", "J", "K", "L", "M" },
		{ "W", "X", "C", "V", "B", "N", ",", ";", ":", "=" }
	}
hs.grid.ui.textColor = {1,1,0}
hs.grid.ui.cellColor = {0,0,0,0.25}
hs.grid.ui.cellStrokeColor = {0,0,0}
hs.grid.ui.selectedColor = {0.2,0.7,0,0.4}
hs.grid.ui.textSize = 50
hs.grid.ui.fontName = "Helvetica"
hs.grid.ui.showExtraKeys = false

--------------------------------------------------------------------------------
-- WINDOW SETTINGS
--------------------------------------------------------------------------------

if hs.screen.mainScreen():name() == main_monitor then
	hs.screen.mainScreen():setMode(1920, 1200, 1)
end

--------------------------------------------------------------------------------
-- Window management --# Based on settings from @zzamboni, @BrianGilbert
--------------------------------------------------------------------------------
hs.window.animationDuration = 0

-- Defines for window maximize toggler
local frameCache = {}
local logger = hs.logger.new("windows")

-- Resize current window

function winresize(how)
   local win = hs.window.focusedWindow()
   local app = win:application():name()
   local windowLayout
   local newrect

   if how == "left" then
      newrect = hs.layout.left50
   elseif how == "right" then
      newrect = hs.layout.right50
   elseif how == "up" then
      newrect = {0,0,1,0.5}
   elseif how == "down" then
      newrect = {0,0.5,1,0.5}
   elseif how == "max" then
      newrect = hs.layout.maximized
   elseif how == "left_third" or how == "hthird-0" then
      newrect = {0,0,1/3,1}
   elseif how == "middle_third_h" or how == "hthird-1" then
      newrect = {1/3,0,1/3,1}
   elseif how == "right_third" or how == "hthird-2" then
      newrect = {2/3,0,1/3,1}
   elseif how == "top_third" or how == "vthird-0" then
      newrect = {0,0,1,1/3}
   elseif how == "middle_third_v" or how == "vthird-1" then
      newrect = {0,1/3,1,1/3}
   elseif how == "bottom_third" or how == "vthird-2" then
      newrect = {0,2/3,1,1/3}
   end

   win:move(newrect)
end

function winmovescreen(how)
   local win = hs.window.focusedWindow()
   if how == "left" then
      win:moveOneScreenWest()
   elseif how == "right" then
      win:moveOneScreenEast()
   end
end

-- Toggle a window between its normal size, and being maximized
function toggle_window_maximized()
   local win = hs.window.focusedWindow()
   if frameCache[win:id()] then
      win:setFrame(frameCache[win:id()])
      frameCache[win:id()] = nil
   else
      frameCache[win:id()] = win:frame()
      win:maximize()
   end
end

-- Move between thirds of the screen
function get_horizontal_third(win)
   local frame=win:frame()
   local screenframe=win:screen():frame()
   local relframe=hs.geometry(frame.x-screenframe.x, frame.y-screenframe.y, frame.w, frame.h)
   local third = math.floor(3.01*relframe.x/screenframe.w)
   logger.df("Screen frame: %s", screenframe)
   logger.df("Window frame: %s, relframe %s is in horizontal third #%d", frame, relframe, third)
   return third
end

function get_vertical_third(win)
   local frame=win:frame()
   local screenframe=win:screen():frame()
   local relframe=hs.geometry(frame.x-screenframe.x, frame.y-screenframe.y, frame.w, frame.h)
   local third = math.floor(3.01*relframe.y/screenframe.h)
   logger.df("Screen frame: %s", screenframe)
   logger.df("Window frame: %s, relframe %s is in vertical third #%d", frame, relframe, third)
   return third
end

function left_third()
   local win = hs.window.focusedWindow()
   local third = get_horizontal_third(win)
   if third == 0 then
      winresize("hthird-0")
   else
      winresize("hthird-" .. (third-1))
   end
end

function right_third()
   local win = hs.window.focusedWindow()
   local third = get_horizontal_third(win)
   if third == 2 then
      winresize("hthird-2")
   else
      winresize("hthird-" .. (third+1))
   end
end

function up_third()
   local win = hs.window.focusedWindow()
   local third = get_vertical_third(win)
   if third == 0 then
      winresize("vthird-0")
   else
      winresize("vthird-" .. (third-1))
   end
end

function down_third()
   local win = hs.window.focusedWindow()
   local third = get_vertical_third(win)
   if third == 2 then
      winresize("vthird-2")
   else
      winresize("vthird-" .. (third+1))
   end
end

-- left, upper corner

function upLeft()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x / 2
    f.y = max.y / 2
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end

-- Right, lower corner

function downRight()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y + (max.h / 2)
    f.w = max.w /2
    f.h = max.h / 2
    win:setFrame(f)
end

-- Right upper corner

function upRight()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y / 2
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end

-- Left lower corner

function downLeft()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x / 2
    f.y = max.y + (max.h / 2)
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end

-- Center

function center()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x  + (max.w / 3)
    f.y = max.y  + (max.h / 3)
    f.w = max.w / 3
    f.h = max.h / 3
    win:setFrame(f)
end

-- Wide center

function wideCenter()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x  + (max.w / 6)
    f.y = max.y  + (max.h / 6)
    f.w = max.w / (3/2)
    f.h = max.h / (3/2)
    win:setFrame(f)
end

-- Widest center

function widestCenter()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x  + (max.w / 24)
    f.y = max.y  + (max.h / 24)
    f.w = max.w / (10/9)
    f.h = max.h / (10/9)
    win:setFrame(f)
end

-- move_to_center
-- could be written better! Please use window.move!
function move_to_center()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()
	local size = win:size()

	f.x = max.x + (max.w - size.w)/2
	f.y = max.y + (max.h - size.h)/2

	win:setFrame(f)
end

hs.hotkey.bind( cmd_alt , "c" , move_to_center )

-- move_to_center_top
-- could be written better! Please use window.move!
function move_to_center_top()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()
	local size = win:size()

	f.x = max.x + (max.w - size.w)/2
	f.y = max.y

	win:setFrame(f)
end

hs.hotkey.bind( cmd_alt , "v" , move_to_center_top )


-------- Key bindings

-- Halves of the screen
hs.hotkey.bind( cmd_alt , "Left",  hs.fnutils.partial(winresize, "left"))
hs.hotkey.bind( cmd_alt , "Right", hs.fnutils.partial(winresize, "right"))
hs.hotkey.bind( cmd_alt , "Up",    hs.fnutils.partial(winresize, "up"))
hs.hotkey.bind( cmd_alt , "Down",  hs.fnutils.partial(winresize, "down"))

-- Thirds of the screen
hs.hotkey.bind( ctrl_alt , "Left", left_third)
hs.hotkey.bind( ctrl_alt , "Right", right_third)
hs.hotkey.bind( ctrl_alt , "Up",    up_third)
hs.hotkey.bind( ctrl_alt , "Down",  down_third)

-- Corner windows
hs.hotkey.bind( cmd_alt , "T", upLeft )
hs.hotkey.bind( cmd_alt , "Y", upRight )
hs.hotkey.bind( cmd_alt , "G", downLeft )
hs.hotkey.bind( cmd_alt , "H", downRight )

-- Center windows
hs.hotkey.bind( cmd_alt , ",", center )
hs.hotkey.bind( cmd_alt , ";", wideCenter )
hs.hotkey.bind( cmd_alt , ":", widestCenter )

-- Maximized
hs.hotkey.bind( cmd_alt , "F",     hs.fnutils.partial(winresize, "max"))

-- Move between screens
hs.hotkey.bind( mash , "Left",  hs.fnutils.partial(winmovescreen, "left"))
hs.hotkey.bind( mash , "Right", hs.fnutils.partial(winmovescreen, "right"))

-- Alter gridsize
hs.hotkey.bind(mashshift, '=', function() hs.grid.adjustHeight( 1) end)
hs.hotkey.bind(mashshift, '-', function() hs.grid.adjustHeight(-1) end)
hs.hotkey.bind(mash, '=', function() hs.grid.adjustWidth( 1) end)
hs.hotkey.bind(mash, '-', function() hs.grid.adjustWidth(-1) end)

-- Snap windows
hs.hotkey.bind(mash, ';', function() hs.grid.snap(window.focusedWindow()) end)
hs.hotkey.bind(mash, "'", function() hs.fnutils.map(window.visibleWindows(), hs.grid.snap) end)

-- Move windows
hs.hotkey.bind(cmd_alt, 'K', hs.grid.pushWindowDown)
hs.hotkey.bind(cmd_alt, 'I', hs.grid.pushWindowUp)
hs.hotkey.bind(cmd_alt, 'J', hs.grid.pushWindowLeft)
hs.hotkey.bind(cmd_alt, 'L', hs.grid.pushWindowRight)

-- resize windows
hs.hotkey.bind(mashshift, 'UP', hs.grid.resizeWindowShorter)
hs.hotkey.bind(mashshift, 'DOWN', hs.grid.resizeWindowTaller)
hs.hotkey.bind(mashshift, 'RIGHT', hs.grid.resizeWindowWider)
hs.hotkey.bind(mashshift, 'LEFT', hs.grid.resizeWindowThinner)

hs.hotkey.bind(mash, 'N', hs.grid.pushWindowNextScreen)
hs.hotkey.bind(mash, 'P', hs.grid.pushWindowPrevScreen)

-- grid
hs.hotkey.bind(mash, 'G', hs.grid.show)

--------------------------------------------------------------------------------
-- PRESET WINDOWS
--------------------------------------------------------------------------------

-- Opens a new application window in the current space --# from @lukecyca
function bindNewWin(mashKeys, key, appName, menuItemName)
  hs.hotkey.bind(mashKeys, key, function()
    local app = hs.appfinder.appFromName(appName)

    if app ~= nil then
      local currWin = app:mainWindow()
      app:selectMenuItem(menuItemName)

      -- Wait until the window opens
      local tries = 0
      repeat
        os.execute("sleep 0.1")
        tries = tries + 1
      until currWin ~= app:mainWindow() or tries > 5
    end

    hs.application.launchOrFocus(appName)
  end)
end

-- Keybindings
bindNewWin( mash, 	"F", "Finder", "New Finder Window")
bindNewWin( mash, 	"T", "Terminal", "New Window with Settings - Grass")
bindNewWin( mash, 	"S", "Safari", "New Window")
bindNewWin( mashshift, 	"S", "Safari", "New Private Window")
bindNewWin( mash, 	"C", "Google Chrome", "New Window")
bindNewWin( mash, 	"M", "Mail", "")
bindNewWin( cmd_ctrl, 	"C", "Calendar", "")
bindNewWin( cmd_ctrl, 	"K", "keychain Access", "")

--------------------------------------------------------------------------------
-- SHADOWS
--------------------------------------------------------------------------------
local shadow = true

function toggleShadow()
	if shadow then
		hs.window.setShadows(false)
		shadow = false
	else
		hs.window.setShadows(true)
		shadow = true
	end
end
