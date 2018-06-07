mouse = {}
mouse.firstX = 0
mouse.firstY = 0
mouse.secondX = 0
mouse.secondY = 0
selectedEntity = 1

function controls(dt)
    if keyDown("escape") then love.event.quit() end
    
    if keyDown("left") then entities.moveX(-50*dt) end
    if keyDown("right") then entities.moveX(50*dt) end
    if keyDown("up") then entities.moveY(-50*dt) end
    if keyDown("down") then entities.moveY(50*dt) end
end

function love.keypressed(key)
    if key == "w" or key == "space" then
        player.jumpKeyDownTime = 0
        player.jumpKeyDown = true
        player.jump()
    end
    if key == "s" then table.insert(inputs, 1) end
    if key == "a" then table.insert(inputs, 2) end
    if key == "d" then table.insert(inputs, 3) end
  
    if key == "escape" then love.event.quit() end
    if key == "tab" then debug.visible = not debug.visible end
    if key == "delete" then table.remove(entities.container, #entities.container)end
end

function love.keyreleased(key)
    if key == "w" or key == "space" then
        player.jumpKeyDown = false
    end
    
    if key == "s" then
        for i, v in pairs(inputs) do
            if v == 1 then
                table.remove(inputs, i)
            end
        end
    end
  
    if key == "a" then
        for i, v in pairs(inputs) do
            if v == 2 then
                table.remove(inputs, i)
            end
        end
    end
  
    if key == "d" or key == "right" then
        for i, v in pairs(inputs) do
            if v == 3 then
                table.remove(inputs, i)
            end
        end
    end
end

function love.mousepressed(_, _, button)
    if button == 1 then
        mouse.firstX, mouse.firstY = love.mouse.getPosition()
    end
end

function love.mousereleased(_, _, button)
    mouse.secondX, mouse.secondY = love.mouse.getPosition()
    
    if button == 1 and mouse.firstX ~= mouse.secondX and mouse.firstY ~= mouse.secondY then
        if mouse.secondX > mouse.firstX and mouse.secondY > mouse.firstY then
            entities.create(mouse.firstX, mouse.firstY, mouse.secondX - mouse.firstX, mouse.secondY - mouse.firstY, selectedEntity)
        elseif mouse.secondX < mouse.firstX and mouse.secondY > mouse.firstY then
            entities.create(mouse.secondX, mouse.firstY, mouse.firstX - mouse.secondX, mouse.secondY - mouse.firstY, selectedEntity)
        elseif mouse.secondX > mouse.firstX and mouse.secondY < mouse.firstY then
            entities.create(mouse.firstX, mouse.secondY, mouse.secondX - mouse.firstX, mouse.firstY - mouse.secondY, selectedEntity)
        else
            entities.create(mouse.secondX, mouse.secondY, mouse.firstX - mouse.secondX, mouse.firstY - mouse.secondY, selectedEntity)
        end
    end
end

function love.wheelmoved(_, y)
    if y > 0 then
        selectedEntity = (selectedEntity + 1 < #entity) and selectedEntity + 1 or selectedEntity
    elseif y < 0 then
        selectedEntity = (selectedEntity - 1 > 0) and selectedEntity - 1 or selectedEntity
    end
end