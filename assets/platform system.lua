function love.load()
  lg = love.graphics
  keyDown = love.keyboard.isDown
  wdowWth = 600
  wdowHgt = 600
  love.window.setMode(wdowWth, wdowHgt)
  love.window.setTitle("Plateformer")
  math.randomseed(os.time())
  inputs = {}
  gravity = 4000

  mouse = {}
  mouse.firstX = 0
  mouse.firstY = 0
  mouse.secondX = 0
  mouse.secondY = 0

  player = {}
  player.wth = 50
  player.hgt = 100
  player.crouchedHgt = 50
  player.x = wdowWth/2 - player.wth/2
  player.y = wdowHgt - player.hgt
  player.moveSpd = 200
  player.xSpd = 0
  player.ySpd = 0
  player.airTime = 0
  player.isJumping = false
  player.jumpSpd = 400
  player.jumpKeyDown = false
  player.jumpKeyDownTime = 0
  player.jumpLevel = 1
  player.jumpLevels = {100, 200, 250, 300}
  player.jumpSlow = 500
  player.canJumpHigher = false
  player.jump = function()
    if not player.isJumping then
      player.isJumping = true
      player.ySpd = -player.jumpSpd
      player.jumpKeyDown = true
    end
  end
  player.moveX = function(moveSpeed)

    if moveSpeed < 0 then
      --Collision bord de l'écran
      if player.x + moveSpeed < 0 then player.x = 0; return end
      --Collisions coté droit des plateformes
      for i, v in pairs(platforms) do
        if (player.y + player.hgt - 1 > v.y and player.y < v.y + v.hgt) and
        (player.x + moveSpeed < v.x + v.wth and player.x + moveSpeed + player.wth > v.x + v.wth) then
          player.x = player.x - (player.x - (v.x + v.wth))
          return
        end
      end
    else
      --Collision bord de l'écran
      if player.x + moveSpeed + player.wth > wdowHgt then player.x = wdowWth - player.wth; return end
      --Collisions coté gauche des plateformes
      for i, v in pairs(platforms) do
        if (player.y + player.hgt - 1 > v.y and player.y < v.y + v.hgt) and
        (player.x + moveSpeed < v.x and player.x + moveSpeed + player.wth > v.x) then
          player.x = player.x + (v.x - (player.x + player.wth))
          return
        end
      end
    end

    player.x = player.x + moveSpeed

    for i, v in pairs(platforms) do
      if (player.y >= v.y and player.y + player.hgt < v.y) and ((player.x >= v.x + v.wth) or (player.x + player.wth <= v.x)) then
        player.isJumping = true
      end
    end
  end

  player.moveY = function(moveSpeed)
    if moveSpeed > 0 then
      --Collision bord de l'écran
      if player.y + moveSpeed + player.hgt > wdowHgt then player.y = wdowHgt - player.hgt; player.isJumping = false; player.ySpd = 0; return end
      --Collisions coté dessus des plateformes
      for i, v in pairs(platforms) do
        if (player.y + moveSpeed + player.hgt > v.y and player.y + moveSpeed < v.y) and
        (player.x < v.x + v.wth and player.x + player.wth > v.x) then
          player.isJumping = false
          player.ySpd = 0
          player.y = player.y + v.y - (player.y + player.hgt)
          return
        end
      end
    else
      --Collision bord de l'écran
      if player.y + moveSpeed < 0 then player.y = 0; player.ySpd = 0; return end
      --Collisions coté dessous des plateformes
      for i, v in pairs(platforms) do
        if (player.y + moveSpeed > v.y + v.hgt - player.hgt and player.y + moveSpeed < v.y + v.hgt) and
        (player.x < v.x + v.wth and player.x + player.wth > v.x) then
          player.ySpd = 0
          player.y = player.y - (player.y - (v.y + v.hgt))
          return
        end
      end
    end

    player.y = player.y + moveSpeed
  end

  platforms = {}
  function createPlatform(x, y, wth, hgt)
    local platform = {}

    platform.x = x
    platform.y = y
    platform.wth = wth
    platform.hgt = hgt

    table.insert(platforms, platform)
  end
end

function love.keypressed(key)
  if key == "w" or key == "space" then
    player.jumpKeyDownTime = 0
    player.jumpKeyDown = true
    player.jump()
  end
  if key == "s" or key == "down" then table.insert(inputs, 1) end
  if key == "a" or key == "left" then table.insert(inputs, 2) end
  if key == "d" or key == "right" then table.insert(inputs, 3) end

  if key == "escape" then love.event.quit() end
  if key == "delete" then table.remove(platforms, #platforms)end
end

function love.keyreleased(key)
  if key == "w" or key == "space" then
    player.jumpKeyDown = false
  end

  if key == "s" or key == "down" then
    for i, v in pairs(inputs) do
      if v == 1 then
        table.remove(inputs, i)
      end
    end
  end

  if key == "a" or key == "left" then
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

function love.update(dt)
  --Direction du joueur
  if inputs[#inputs] == 1 then
    --Vers le bas
  elseif inputs[#inputs] == 2 then
    player.moveX(- player.moveSpd * dt)
  elseif inputs[#inputs] == 3 then
    player.moveX(player.moveSpd * dt)
  end

  if player.jumpKeyDown then
    player.jumpKeyDownTime = player.jumpKeyDownTime + 1000*dt
  end

  if player.airTime < player.jumpLevels[player.jumpLevel] then
    player.canJumpHigher = true
  else
    if player.jumpKeyDown and player.canJumpHigher and player.airTime < player.jumpLevels[#player.jumpLevels] then
      if player.jumpLevel <= #player.jumpLevels - 1 then
        player.jumpLevel = player.jumpLevel + 1
      end
    else
      player.canJumpHigher = false
    end
  end

  --Applique la gravité
  player.ySpd = player.ySpd + gravity*dt

  --Annule la gravité
  if player.canJumpHigher then
    player.ySpd = player.ySpd - gravity*dt
    player.ySpd = player.ySpd + player.jumpSlow*dt
  end

  player.moveY(player.ySpd * dt)
  player.moveX(player.xSpd * dt)

  if player.ySpd > 0 then player.isJumping = true end

  if player.isJumping then
    player.airTime = player.airTime + 1000 * dt
  else
    player.airTime = 0
    player.jumpLevel = 1
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
      createPlatform(mouse.firstX, mouse.firstY, mouse.secondX - mouse.firstX, mouse.secondY - mouse.firstY)
    elseif mouse.secondX < mouse.firstX and mouse.secondY > mouse.firstY then
      createPlatform(mouse.secondX, mouse.firstY, mouse.firstX - mouse.secondX, mouse.secondY - mouse.firstY)
    elseif mouse.secondX > mouse.firstX and mouse.secondY < mouse.firstY then
      createPlatform(mouse.firstX, mouse.secondY, mouse.secondX - mouse.firstX, mouse.firstY - mouse.secondY)
    else
      createPlatform(mouse.secondX, mouse.secondY, mouse.firstX - mouse.secondX, mouse.firstY - mouse.secondY)
    end
  end
end

function love.draw()
  lg.print("player.x : "..player.x, 10, 10)
  lg.print("player.y : "..player.y, 10, 30)
  lg.print("player.xSpd : "..player.xSpd, 10, 50)
  lg.print("player.ySpd : "..player.ySpd, 10, 70)
  lg.print("player.isJumping : "..tostring(player.isJumping), 10, 90)
  lg.print("player.jumpKeyDownTime : "..player.jumpKeyDownTime, 10, 110)
  lg.print("player.jumpKeyDown : "..tostring(player.jumpKeyDown), 10, 130)
  lg.print("player.jumpLevel : "..player.jumpLevel, 10, 150)
  lg.print("player.jumpLevels : ", 10, 170)
  for i, v in pairs(player.jumpLevels) do
    lg.print(v, 90 + i*40, 170)
  end
  lg.print("player.airTime : "..player.airTime, 10, 190)
  lg.print("player.canJumpHigher : "..tostring(player.canJumpHigher), 10, 210)
  lg.print("#platforms : "..#platforms, 10, 230)
  lg.print("FPS : "..love.timer.getFPS(), 10, 250)

  for i, v in pairs(platforms) do
    lg.setColor(255, 0, 0)
    lg.rectangle("fill", v.x, v.y, v.wth, v.hgt)
  end

  lg.setColor(0, 255, 0)
  lg.rectangle("fill", player.x, player.y, player.wth, player.hgt)
end
