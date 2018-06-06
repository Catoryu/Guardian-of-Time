player = {}
--player.hitbox = lobj_shape_rectangle:new(player_basic_info)
player.clothe = 0
player.weapon = 0
player.specie = 0
player.wth = 50
player.hgt = 100
player.x = wdow.wth/2 - player.wth/2
player.y = wdow.hgt - player.hgt
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

player.attacks = {
    jump = 0,
    dash = 0,
    front_attack = 0,
    back_attack = 0,
    up_attack = 0,
    down_attack = 0,
    air_attack = 0,
    dash_attack = 0,
    special_attack = 0
}

player.jump = function()
    if not player.isJumping then
       player.isJumping = true
        player.ySpd = -player.jumpSpd
        player.jumpKeyDown = true
    end
end

player.overlapCircle = function(x, y, r)
    local rectX = player.x + player.wth/2
    local rectY = player.y + player.hgt/2
    
    local circleDistanceX = math.abs(x - rectX)
    local circleDistanceY = math.abs(y - rectY)
    
    if (circleDistanceX > (player.wth/2 + r)) then return false end
    if (circleDistanceY > (player.hgt/2 + r)) then return false end
    
    if (circleDistanceX <= (player.wth/2)) then return true end
    if (circleDistanceY <= (player.hgt/2)) then return true end
    
    local cornerDistance_sq = (circleDistanceX - player.wth/2)^2 + (circleDistanceY - player.hgt/2)^2
    
    return (cornerDistance_sq <= (r^2))
end

player.overlapRectangle = function(x, y, wth, hgt)
    w = 0.5 * (player.wth + wth)
    h = 0.5 * (player.hgt + hgt)
    dx = (player.x + player.wth/2) - (x + wth/2)
    dy = (player.y + player.hgt/2) - (y + hgt/2)
    
    if math.abs(dx) <= w and math.abs(dy) <= h then
        wy = w * dy
        hx = h * dx
        
        if (wy > hx) then
            if (wy > -hx) then
                --En haut
                return 3
            else
                --A gauche
                return 1
            end
        else
            if (wy > -hx) then
                --A droite
                return 2
            else
                --En bas
                return 4
            end
        end
    else
        --Aucune collision
        return 0
    end
end

player.moveX = function(moveSpeed)
    
    --Test si il joueur dans une matière qui le ralenti
    for i, v in pairs(entities.container) do
        if v.solidResistance ~= 100 then
            if player.overlapRectangle(v.x, v.y, v.wth, v.hgt) ~= 0 then
                moveSpeed = moveSpeed/100 * (100-v.solidResistance)
                player.xSpd = player.xSpd/100 * (100-v.solidResistance)
            end
        end
    end
    
    if moveSpeed < 0 then
        --Collision bord gauche de l'écran
        if player.x + moveSpeed < 0 then player.x = 0; return end
        
        --Passe en revue toutes les entités
        for i, v in pairs(entities.container) do
            --Collisions coté droit des entités
            if (player.y + player.hgt - 1 > v.y and player.y < v.y + v.hgt) and
            (player.x + moveSpeed < v.x + v.wth and player.x + moveSpeed + player.wth > v.x + v.wth) then
                if v.solidResistance == 100 then
                    player.x = player.x - (player.x - (v.x + v.wth))
                    player.xSpd = 0
                    return
                end
            end
        end
    elseif moveSpeed > 0 then
        --Collision bord droit de l'écran
        if player.x + moveSpeed + player.wth > wdow.wth then player.x = wdow.wth - player.wth; return end
        
        --Passe en revue toutes les entités
        for i, v in pairs(entities.container) do
            --Collisions coté gauche des entités
            if (player.y + player.hgt - 1 > v.y and player.y < v.y + v.hgt) and
            (player.x + moveSpeed < v.x and player.x + moveSpeed + player.wth > v.x) then
                if v.solidResistance == 100 then
                    player.x = player.x + (v.x - (player.x + player.wth))
                    player.xSpd = 0
                    return
                end
            end
        end
    end
  
    player.x = player.x + moveSpeed
end

player.moveY = function(moveSpeed)
    
    --Test si le joueur est dans une matière qui le ralenti
    for i, v in pairs(entities.container) do
        if v.solidResistance ~= 100 then
            if player.overlapRectangle(v.x, v.y, v.wth, v.hgt) ~= 0 then
                moveSpeed = moveSpeed/100 * (100-v.solidResistance)
                player.ySpd = player.ySpd/100 * (100-v.solidResistance)
            end
        end
    end
    
    if moveSpeed < 0 then
        --Collision bord haut de l'écran
        if player.y + moveSpeed < 0 then player.y = 0; player.ySpd = 0; return end
        
        --Passe en revue toutes les entités
        for i, v in pairs(entities.container) do
            --Collisions dessous des entités
            if (player.y + moveSpeed > v.y + v.hgt - player.hgt and player.y + moveSpeed < v.y + v.hgt) and
            (player.x < v.x + v.wth and player.x + player.wth > v.x) then
                if v.solidResistance == 100 then
                    player.ySpd = 0
                    player.y = player.y - (player.y - (v.y + v.hgt))
                    return
                end
            end
        end
    elseif moveSpeed > 0 then
        --Collision bord bas de l'écran
        if player.y + moveSpeed + player.hgt > wdow.hgt then player.y = wdow.hgt - player.hgt; player.isJumping = false; player.ySpd = 0; return end
        
        --Passe en revue toutes les entités
        for i, v in pairs(entities.container) do
            --Collisions dessus des entités
            if (player.y + moveSpeed + player.hgt > v.y and player.y + moveSpeed < v.y) and
            (player.x < v.x + v.wth and player.x + player.wth > v.x) then
                if v.solidResistance == 100 then
                    player.isJumping = false
                    player.ySpd = 0
                    player.y = player.y + v.y - (player.y + player.hgt)
                    return
                end
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