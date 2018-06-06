mouse = {}
mouse.firstX = 0
mouse.firstY = 0
mouse.secondX = 0
mouse.secondY = 0

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
  if key == "delete" then table.remove(platforms.container, #platforms.container)end
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
  if button == 1 then
    mouse.secondX, mouse.secondY = love.mouse.getPosition()
    if mouse.secondX > mouse.firstX and mouse.secondY > mouse.firstY then
      platforms.create(mouse.firstX, mouse.firstY, mouse.secondX - mouse.firstX, mouse.secondY - mouse.firstY)
    elseif mouse.secondX < mouse.firstX and mouse.secondY > mouse.firstY then
      platforms.create(mouse.secondX, mouse.firstY, mouse.firstX - mouse.secondX, mouse.secondY - mouse.firstY)
    elseif mouse.secondX > mouse.firstX and mouse.secondY < mouse.firstY then
      platforms.create(mouse.firstX, mouse.secondY, mouse.secondX - mouse.firstX, mouse.firstY - mouse.secondY)
    else
      platforms.create(mouse.secondX, mouse.secondY, mouse.firstX - mouse.secondX, mouse.firstY - mouse.secondY)
    end
  end
end