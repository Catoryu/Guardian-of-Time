player = {}
player.clothe = 0
player.weapon = 0
player.specie = 0
player.grid = lg.newCanvas(wdow.wth + room.blocSize, wdow.hgt + room.blocSize)
lg.setCanvas(player.grid)
    lg.setColor(255, 255, 255)
    
    for i = 0, wdow.wth + room.blocSize, room.blocSize do
        lg.line(i, 0, i, wdow.hgt + room.blocSize)
        for j = 0, wdow.hgt + room.blocSize, room.blocSize do
            lg.line(0, j, wdow.wth + room.blocSize, j)
        end
    end
lg.setCanvas()
player.showGrid = false
player.wth = 45
player.hgt = 95
player.x = wdow.wth/2 - player.wth/2
player.y = wdow.hgt - player.hgt
player.moveSpd = 200
player.xSpd = 0
player.ySpd = 0
player.spdLimit = 1500
player.airTime = 0
player.isJumping = false
player.jumpSpd = 550
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

player.moveX = function(moveSpeed)

    --Test si il joueur dans une matière qui le ralenti
    for i, v in pairs(entities.container) do
        if v.solidResistance ~= 100 then
            if collision_rectToRect(player.x, player.y, player.wth, player.hgt, v.x, v.y, v.wth, v.hgt) ~= 0 then
                moveSpeed = moveSpeed/100 * (100-v.solidResistance)
                player.xSpd = player.xSpd/100 * (100-v.solidResistance)
            end
        end
    end

    if moveSpeed < 0 then
        local dx = math.huge
        
        --Collision bord gauche de l'écran
        if player.x + moveSpeed < 0 then player.x = 0; return end
        
        --Itère à travers toutes les entités
        for i, v in pairs(entities.container) do
            --Collisions coté droit des entités
            if collision_rectToRect(player.x + moveSpeed, player.y, player.wth, player.hgt - 1, v.x, v.y, v.wth, v.hgt) == 4 then
                if v.solidResistance == 100 then
                    if player.x - (v.x + v.wth) < dx then
                        dx = player.x - (v.x + v.wth)
                    end
                end
            end
        end
        
        --Itère à travers tous les blocs
        for i, b in pairs(room.blocs) do
            --Si le bloc est solide
            if b.isSolid then
                --Récupère les coordonnés du bloc
                local x, y = room.getBlocPos(b.x, b.y)
                
                --Collisions coté droit des blocs
                if collision_rectToRect(player.x + moveSpeed, player.y, player.wth, player.hgt - 1, x, y, room.blocSize, room.blocSize) == 4 then
                    b:onTouch(4)
                    if player.x - (x + room.blocSize) < dx then
                        dx = player.x - (x + room.blocSize)
                    end
                end
            end
        end
        
        if dx ~= math.huge then
            player.x = player.x - dx
            player.xSpd = 0
            return
        end
        
        --Déplacement de la caméra
        if room.x < 0 and player.x + player.wth/2 < wdow.wth/2 then
            room.moveCameraX(-moveSpeed)
        else
            player.x = player.x + moveSpeed
        end
    elseif moveSpeed > 0 then
        local dx = math.huge
        
        --Collision bord droit de l'écran
        if player.x + moveSpeed + player.wth > wdow.wth then player.x = wdow.wth - player.wth; return end
        
        --Itère à travers toutes les entités
        for i, v in pairs(entities.container) do
            --Collisions coté gauche des entités
            if collision_rectToRect(player.x + moveSpeed, player.y, player.wth, player.hgt - 1, v.x, v.y, v.wth, v.hgt) == 3 then
                if v.solidResistance == 100 then
                    if v.x - (player.x + player.wth) < dx then
                        dx = v.x - (player.x + player.wth)
                    end
                end
            end
        end
        
        --Itère à travers tous les blocs
        for i, b in pairs(room.blocs) do
            --Si le bloc est solide
            if b.isSolid then
                --Récupère les coordonnés du bloc
                local x, y = room.getBlocPos(b.x, b.y)
                
                --Collisions coté gauche des blocs
                if collision_rectToRect(player.x + moveSpeed, player.y, player.wth, player.hgt - 1, x, y, room.blocSize, room.blocSize) == 3 then
                    b:onTouch(3)
                    if x - (player.x + player.wth) < dx then
                        dx = x - (player.x + player.wth)
                    end
                end
            end
        end
        
        if dx ~= math.huge then
            player.x = player.x + dx
            player.xSpd = 0
            return
        end
        
        --Déplacement de la caméra
        if room.x + room.wth > wdow.wth and player.x + player.wth/2 > wdow.wth/2 then
            room.moveCameraX(-moveSpeed)
        else
            player.x = player.x + moveSpeed
        end
    end
end

player.moveY = function(moveSpeed)

    --Test si le joueur est dans une matière qui le ralenti
    for i, v in pairs(entities.container) do
        if v.solidResistance ~= 100 then
            if collision_rectToRect(player.x, player.y, player.wth, player.hgt, v.x, v.y, v.wth, v.hgt) ~= 0 then
                moveSpeed = moveSpeed/100 * (100-v.solidResistance)
                player.ySpd = player.ySpd/100 * (100-v.solidResistance)
            end
        end
    end

    if moveSpeed < 0 then
        local dy = math.huge
        
        --Collision bord haut de l'écran
        if player.y + moveSpeed < 0 then player.y = 0; player.ySpd = 0; return end
        
        --Itère à travers toutes les entités
        for i, v in pairs(entities.container) do
            --Collisions dessous des entités
            if collision_rectToRect(player.x, player.y + moveSpeed, player.wth, player.hgt, v.x, v.y, v.wth, v.hgt) == 2 then
                if v.solidResistance == 100 then
                    if player.y - (v.y + v.hgt) < dy then
                        dy = player.y - (v.y + v.hgt)
                    end
                end
            end
        end
        
        --Itère à travers tous les blocs
        for i, b in pairs(room.blocs) do
            --Si le bloc est solide
            if b.isSolid then
                --Récupère les coordonnés du bloc
                local x, y = room.getBlocPos(b.x, b.y)
                
                --Collisions dessous des blocs
                if collision_rectToRect(player.x, player.y + moveSpeed, player.wth, player.hgt, x, y, room.blocSize, room.blocSize) == 2 then
                    b:onTouch(2)
                    if player.y - (y + room.blocSize) < dy then
                        dy = player.y - (y + room.blocSize)
                    end
                end
            end
        end
        
        if dy ~= math.huge then
            player.ySpd = 0
            player.y = player.y - dy
            return
        end
        
        
        --Déplacement de la caméra
        if room.y < 0 and player.y + player.hgt/2 < wdow.hgt/2 then
            room.moveCameraY(-moveSpeed)
        else
            player.y = player.y + moveSpeed
        end
    elseif moveSpeed > 0 then
        local dy = math.huge
        
        --Collision bord bas de l'écran
        if player.y + moveSpeed + player.hgt > wdow.hgt then player.y = wdow.hgt - player.hgt; player.isJumping = false; player.ySpd = 0; return end
        
        --Itère à travers toutes les entités
        for i, v in pairs(entities.container) do
            --Collisions dessus des entités
            if collision_rectToRect(player.x, player.y + moveSpeed, player.wth, player.hgt, v.x, v.y, v.wth, v.hgt) == 1 then
                if v.solidResistance == 100 then
                    if v.y - (player.y + player.hgt) < dy then
                        dy = v.y - (player.y + player.hgt)
                    end
                end
            end
        end
        
        --Itère à travers tous les blocs
        for i, b in pairs(room.blocs) do
            --Si le bloc est solide
            if b.isSolid then
                --Récupère les coordonnés du bloc
                local x, y = room.getBlocPos(b.x, b.y)
                
                --Collisions dessus des blocs
                if collision_rectToRect(player.x, player.y + moveSpeed, player.wth, player.hgt, x, y, room.blocSize, room.blocSize) == 1 then
                    b:onTouch(1)
                    if y - (player.y + player.hgt) < dy then
                        dy = y - (player.y + player.hgt)
                    end
                end
            end
        end
        
        --Déplacement du joueur
        if dy ~= math.huge then
            player.isJumping = false
            player.ySpd = 0
            player.y = player.y + dy
            return
        end
        
        --Déplacement de la caméra
        if room.y + room.hgt > wdow.hgt + 1 and player.y + player.hgt/2 > wdow.hgt/2 then
            room.moveCameraY(-moveSpeed)
        else
            player.y = player.y + moveSpeed
        end
    end
end

player.update = function(dt)
    --Direction du joueur
    if inputs.down then
        --Vers le bas
    elseif inputs.left then
        player.moveX(- player.moveSpd * dt)
    elseif inputs.right then
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

    --Limite la vitesse du joueur
    if player.ySpd > player.spdLimit then player.ySpd = player.spdLimit elseif player.ySpd < -player.spdLimit then player.ySpd = -player.spdLimit end
    if player.xSpd > player.spdLimit then player.xSpd = player.spdLimit elseif player.xSpd < -player.spdLimit then player.xSpd = -player.spdLimit end

    --Fait bouger le joueur
    if player.ySpd ~= 0 then player.moveY(player.ySpd * dt) end
    if player.xSpd ~= 0 then player.moveX(player.xSpd * dt) end
    
    if player.ySpd > 0 then player.isJumping = true; player.canJumpHigher = false end

    --Test si le joueur est dans un objet où il peut nager [WIP]
--    for i, v in pairs(entities.container) do
--        if collision_rectToRect(player.x, player.y, player.wth, player.hgt, v.x, v.y, v.wth, v.hgt) then
--            player.isJumping = false
--            player.canJumpHigher = true
--            player.airTime = 0
--            player.jumpLevel = 1
--        end
--    end

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
    
    if player.showGrid then
        --Calcul la position de la grille
        _, dump = math.modf(room.x/room.blocSize)
        _, dump2 = math.modf(room.y/room.blocSize)
        
        --Affiche la grille
        lg.draw(player.grid, dump*room.blocSize, dump2*room.blocSize)
    end
end
