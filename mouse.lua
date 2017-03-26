-- Draws a red and green circle around the pointer

local mouseCircle = nil
local mouseCircleGR = nil
local mouseCircleTimer = nil

function mouseHighlight()
    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        mouseCircleGr:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end

    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.getAbsolutePosition()
    -- Prepare a big red circle around the mouse pointer
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(2)
    mouseCircle:show()

    -- Green square
    mouseCircleGr = hs.drawing.rectangle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircleGr:setStrokeColor({["red"]=0,["blue"]=0,["green"]=1,["alpha"]=1})
    mouseCircleGr:setFill(false)
    mouseCircleGr:setStrokeWidth(4)
    mouseCircleGr:show()

    -- Set a timer to delete all after 0.3 seconds
    mouseCircleTimer = hs.timer.doAfter(
      0.3, function() mouseCircleGr:delete() mouseCircle:delete()
    end)
end
hs.hotkey.bind({"cmd", "ctrl", "alt"}, "D", mouseHighlight)
