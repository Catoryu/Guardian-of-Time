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
    for i, v in pairs(platforms.container) do
      if (player.y + player.hgt - 1 > v.y and player.y < v.y + v.hgt) and
      (player.x + moveSpeed < v.x + v.wth and player.x + moveSpeed + player.wth > v.x + v.wth) then
        player.x = player.x - (player.x - (v.x + v.wth))
        player.xSpd = 0
        return
      end
    end
  elseif moveSpeed > 0 then
    --Collision bord de l'écran
    if player.x + moveSpeed + player.wth > wdowHgt then player.x = wdowWth - player.wth; return end
    --Collisions coté gauche des plateformes
    for i, v in pairs(platforms.container) do
      if (player.y + player.hgt - 1 > v.y and player.y < v.y + v.hgt) and
      (player.x + moveSpeed < v.x and player.x + moveSpeed + player.wth > v.x) then
        player.x = player.x + (v.x - (player.x + player.wth))
        player.xSpd = 0
        return
      end
    end
  end

  player.x = player.x + moveSpeed
end

player.moveY = function(moveSpeed)
  if moveSpeed < 0 then
    --Collision bord de l'écran
    if player.y + moveSpeed < 0 then player.y = 0; player.ySpd = 0; return end
    --Collisions coté dessous des plateformes
    for i, v in pairs(platforms.container) do
      if (player.y + moveSpeed > v.y + v.hgt - player.hgt and player.y + moveSpeed < v.y + v.hgt) and
      (player.x < v.x + v.wth and player.x + player.wth > v.x) then
        player.ySpd = 0
        player.y = player.y - (player.y - (v.y + v.hgt))
        return
      end
    end
  elseif moveSpeed > 0 then
    --Collision bord de l'écran
    if player.y + moveSpeed + player.hgt > wdowHgt then player.y = wdowHgt - player.hgt; player.isJumping = false; player.ySpd = 0; return end
    --Collisions coté dessus des plateformes
    for i, v in pairs(platforms.container) do
      if (player.y + moveSpeed + player.hgt > v.y and player.y + moveSpeed < v.y) and
      (player.x < v.x + v.wth and player.x + player.wth > v.x) then
        player.isJumping = false
        player.ySpd = 0
        player.y = player.y + v.y - (player.y + player.hgt)
        return
      end
    end
  end
  
  player.y = player.y + moveSpeed
end
player.update = function(dt)
  --Direction du joueur
  if inputs[#inputs] == 1 then
    --Vers le bas
  elseif inputs[#inputs] == 2 then
    player.moveX(- player.moveSpd * dt)
  elseif inputs[#inputs] == 3 then
    player.moveX(player.moveSpd * dt)
  end
  
  --Compte le temps de pression du bouton de saut
  if player.jumpKeyDown then
    player.jumpKeyDownTime = player.jumpKeyDownTime + 1000*dt
  end

  --Nuancier de saut
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

  --Fait bouger le joueur
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
player.draw = function()
  lg.setColor(255, 255, 255)
  lg.rectangle("fill", player.x, player.y, player.wth, player.hgt)
end