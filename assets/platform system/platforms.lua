platforms = {}
platforms.container = {}
platforms.create = function(x, y, wth, hgt)
  local platform = {}
  
  platform.x = x
  platform.y = y
  platform.wth = wth
  platform.hgt = hgt
  
  table.insert(platforms.container, platform)
end

platforms.moveX = function(moveSpeed)
  for i, v in pairs(platforms.container) do
    v.x = v.x + moveSpeed
    
    if moveSpeed < 0 then
      --Collision coté droit platformes
      if (player.y + player.hgt - 1 > v.y and player.y < v.y + v.hgt) and
      (player.x < v.x and player.x + player.wth > v.x) then
        player.x = v.x - player.wth
      end
    elseif moveSpeed > 0 then
      --Collision coté droit platformes
      if (player.y + player.hgt - 1 > v.y and player.y < v.y + v.hgt) and
      (player.x < v.x + v.wth and player.x + player.wth > v.x + v.wth) then
        player.x = v.x + v.wth
      end
    end
  end
end

platforms.moveY = function(moveSpeed)
  for i, v in pairs(platforms.container) do
    v.y = v.y + moveSpeed
    
    if moveSpeed < 0 then
      --Collisions coté dessous des plateformes
      if (player.y > v.y + v.hgt - player.hgt and player.y < v.y + v.hgt) and
      (player.x < v.x + v.wth and player.x + player.wth > v.x) then
        player.y = v.y + v.hgt
      end
    elseif moveSpeed > 0 then
      --Collisions coté dessus des plateformes
      if (player.y + player.hgt > v.y and player.y < v.y) and
      (player.x < v.x + v.wth and player.x + player.wth > v.x) then
        player.y = v.y - player.hgt
      end
    end
  end
end

platforms.draw = function()
  for i, v in pairs(platforms.container) do
    lg.setColor(255, 0, 0)
    lg.rectangle("fill", v.x, v.y, v.wth, v.hgt)
  end
end