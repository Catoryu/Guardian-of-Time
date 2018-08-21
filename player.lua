player = {}
player.clothe = 0
player.weapon = 0
player.specie = 0

--Création d'une image de grille ayant la taille de l'écran
player.grid = lg.newCanvas(wdow.wth + blocs.size, wdow.hgt + blocs.size)
lg.setCanvas(player.grid)
    lg.setColor(255, 255, 255)
    
    for i = 0, wdow.wth + blocs.size, blocs.size do
        lg.line(i, 0, i, wdow.hgt + blocs.size)
        for j = 0, wdow.hgt + blocs.size, blocs.size do
            lg.line(0, j, wdow.wth + blocs.size, j)
        end
    end
lg.setCanvas()

player.showGrid = false
player.wth = 42
player.hgt = 86
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
player.direction = true --false = left, true = right

player.animationStage = 1

--[[
1 = Immobile
2 = Marche
3 = Début de saut
4 = Change de coté
5 = En l'air (en allant en haut)
6 = En l'air (en allant en bas)
7 = En l'air (en allant en haut à droite)
8 = En l'air (en allant en bas à droite)
9 = Aterrissage
]]--

player.drawings = {}
for i = 1, 9 do
    player.drawings[i] = animation["player"..i]:new({fps = 10, bind = "player"})
    
    --Défini des animations qui doivent être complétées avant de passer à la suivante
    if i == 3 or i == 4 or i == 9 then
        player.drawings[i].mandatory = true
    else
        player.drawings[i].mandatory = false
        player.drawings[i].isLooping = true
    end
    
    --Alligne l'animation au pieds du joueur
    player.drawings[i].ox = -(player.wth - player.drawings[i].wth)/2
    player.drawings[i].oy = -(player.hgt - player.drawings[i].hgt)
end

player.attacks = {--cc Rui
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

player.getXYWH = function(self)--Récupère la position du joueur et sa taille (raccourci)
    return self.x, self.y, self.wth, self.hgt
end

player.jump = function()--Fait sauter du joueur
    if not player.isJumping then
        
        print("animation : Le joueur saute")
        player.changeAnimation(3)
        
        player.isJumping = true
        player.ySpd = -player.jumpSpd
        player.jumpKeyDown = true
        
        --Affiche effet de poussière
        
        --Joue le son de saut
        
        --Joue l'animation de saut du joueur
    end
end

player.touchGround = function()--Instructions lorsque le joueur touche le sol
    player.ySpd = 0
    player.isJumping = false
    
    --Affiche effet de poussière
    
    --Joue le son d'atterissage
end

player.moveX = function(moveSpeed, isPushed)--Déplacement horizontal du joueur
    
    if not isPushed then
        --Test si il joueur dans une matière qui le ralenti
        for i, e in pairs(room.entities) do
            if e.solidResistance ~= 100 then
                if collision_rectToRect(player.x, player.y, player.wth, player.hgt, e:getXYWH()) then
                    moveSpeed = moveSpeed * (100 -e.solidResistance) / 100
                    player.xSpd = (100 -e.solidResistance) * player.xSpd / 100
                end
            end
        end
    end
    
    if moveSpeed < 0 then
        if player.direction then
            print("animation : Le joueur change de cote (droite a gauche)")
            player.changeAnimation(4)
        end
        
        player.direction = false
        for i, d in pairs(player.drawings) do
            d.isInvertedX = true
        end
        
        local dx = math.huge
        
        --Collision bords de la salle
        if player.x + moveSpeed < room.x then
            if room.cardinality[3] == 0 then
                --Se bloque contre le bord
                if player.x - room.x < dx then
                    dx = player.x - room.x
                end
            else
                --Change de salle
                loadRoom(room.cardinality[3], - room.wth + wdow.wth, room.y)
                player.x = room.x + room.wth - player.wth
                return true
            end
        end
        
        --Collision entités
        for i, e in pairs(room.entities) do
            if collision_rectToRect(player.x + moveSpeed, player.y, player.wth, player.hgt, e:getXYWH()) then
                if e.solidResistance == 100 then
                    if player.x - (e.x + e.wth) < dx then
                        dx = player.x - (e.x + e.wth)
                    end
                end
            end
        end
        
        --Collision blocs
        for i, b in pairs(room.blocs[1]) do
            if b.isSolid and not b.isLiquid then
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                if collision_rectToRect(player.x + moveSpeed, player.y, player.wth, player.hgt, x, y, blocs.size, blocs.size) then
                    b:onTouch(4)
                    if player.x - (x + blocs.size) < dx then
                        dx = player.x - (x + blocs.size)
                    end
                end
            end
            
            if b.isLiquid then
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                --Calcul la hauteur du liquide
                local liquidHeight = b.fillingRate * blocs.size / 100
                
                if collision_rectToRect(player.x + moveSpeed, player.y, player.wth, player.hgt, x, y + (blocs.size - liquidHeight), blocs.size, liquidHeight) then
                    b:onTouch(4)
                    if b.isSolid then
                        if player.x - (x + blocs.size) < dx then
                            dx = player.x - (x + blocs.size)
                        end
                    end
                end
            end
        end
        
        if dx ~= math.huge then
            player.xSpd = 0
            player.x = player.x - dx
            
            return false
        end
        
        player.x = player.x + moveSpeed
        
        return true
    elseif moveSpeed > 0 then
        if not player.direction then
            print("animation : Le joueur change de cote (gauche a droite)")
            player.changeAnimation(4)
        end
        
        player.direction = true
        for i, d in pairs(player.drawings) do
            d.isInvertedX = false
        end
        
        local dx = math.huge
        
        --Collision bords de la salle
        if player.x + moveSpeed + player.wth > room.x + room.wth then
            if room.cardinality[4] == 0 then
                --Se bloque contre le bord
                if (room.x + room.wth) - (player.x + player.wth) < dx then
                    dx = (room.x + room.wth) - (player.x + player.wth)
                end
            else
                --Change de salle
                loadRoom(room.cardinality[4], 0, room.y)
                player.x = 0
                return true
            end
        end
        
        --Collision entités
        for _, e in pairs(room.entities) do
            --Collisions coté gauche des entités
            if collision_rectToRect(player.x + moveSpeed, player.y, player.wth, player.hgt, e:getXYWH()) then
                if e.solidResistance == 100 then
                    if e.x - (player.x + player.wth) < dx then
                        dx = e.x - (player.x + player.wth)
                    end
                end
            end
        end
        
        --Collision blocs
        for i, b in pairs(room.blocs[1]) do
            if b.isSolid and not b.isLiquid then
                
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                if collision_rectToRect(player.x + moveSpeed, player.y, player.wth, player.hgt, x, y, blocs.size, blocs.size) then
                    b:onTouch(3)
                    if x - (player.x + player.wth) < dx then
                        dx = x - (player.x + player.wth)
                    end
                end
            end
            
            if b.isLiquid then
                
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                --Calcul la hauteur du liquide
                local liquidHeight = b.fillingRate * blocs.size / 100
                
                if collision_rectToRect(player.x + moveSpeed, player.y, player.wth, player.hgt, x, y + (blocs.size - liquidHeight), blocs.size, liquidHeight) then
                    b:onTouch(3)
                    if b.isSolid then
                        if x - (player.x + player.wth) < dx then
                            dx = x - (player.x + player.wth)
                        end
                    end
                end
            end
        end
        
        --Déplacement du joueur
        if dx ~= math.huge then
            player.xSpd = 0
            
            player.x = player.x + dx
            
            return false
        end
        
        player.x = player.x + moveSpeed
        
        return true
    end
end

player.moveY = function(moveSpeed, isPushed)--Déplacement vertical du joueur
    
    if not isPushed then
        --Test si il joueur dans une matière qui le ralenti
        for _, e in pairs(room.entities) do
            if e.solidResistance ~= 100 then
                if collision_rectToRect(player.x, player.y, player.wth, player.hgt, e:getXYWH()) then
                    moveSpeed = moveSpeed * (100 -e.solidResistance) / 100
                    player.ySpd = (100 -e.solidResistance) * player.ySpd / 100
                end
            end
        end
    end
    
    local dy = math.huge
    
    if moveSpeed < 0 then
        --Collision bords de la salle
        if player.y + moveSpeed < 0 then
            if room.cardinality[1] == 0 then
                --Se bloque au bord
                if player.y < dy then
                    dy = player.y
                end
            else
                --Change de salle
                loadRoom(room.cardinality[1], room.x, - room.hgt + wdow.hgt)
                player.y = wdow.hgt - player.hgt
                return true
            end
        end
        
        --Collision entités
        for _, e in pairs(room.entities) do
            if collision_rectToRect(player.x, player.y + moveSpeed, player.wth, player.hgt, e:getXYWH()) then
                if e.solidResistance == 100 then
                    if player.y - (e.y + e.hgt) < dy then
                        dy = player.y - (e.y + e.hgt)
                    end
                end
            end
        end
        
        --Collision blocs
        for i, b in pairs(room.blocs[1]) do
            if b.isSolid and not b.isLiquid then
                
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                if collision_rectToRect(player.x, player.y + moveSpeed, player.wth, player.hgt, x, y, blocs.size, blocs.size) then
                    b:onTouch(2)
                    if player.y - (y + blocs.size) < dy then
                        dy = player.y - (y + blocs.size)
                    end
                end
            end
            
            if b.isLiquid then
                
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                --Calcul la hauteur du liquide
                local liquidHeight = b.fillingRate * blocs.size / 100
                
                if collision_rectToRect(player.x, player.y + moveSpeed, player.wth, player.hgt, x, y + (blocs.size - liquidHeight), blocs.size, liquidHeight) then
                    b:onTouch(2)
                    if b.isSolid then
                        if player.y - (y + blocs.size) < dy then
                            dy = player.y - (y + blocs.size)
                        end
                    end
                end
            end
        end
        
        --Déplacement du joueur
        if dy ~= math.huge then
            player.ySpd = 0
            
            player.y = player.y - dy
            
            return false
        end
        
        player.y = player.y + moveSpeed
        
        return true
    elseif moveSpeed > 0 then
        --Collision bords de la salle
        if player.y + moveSpeed + player.hgt > room.y + room.hgt then
            if room.cardinality[2] == 0 then
                --Se bloque au bord
                if room.y + room.hgt - (player.y + player.hgt) < dy then
                    dy = room.y + room.hgt - (player.y + player.hgt)
                end
            else
                --Change de salle
                loadRoom(room.cardinality[2], room.x, 0)
                player.y = 0
            end
        end
        
        --Collision entités
        for _, e in pairs(room.entities) do
            if collision_rectToRect(player.x, player.y + moveSpeed, player.wth, player.hgt, e:getXYWH()) then
                if e.solidResistance == 100 then
                    if e.y - (player.y + player.hgt) < dy then
                        dy = e.y - (player.y + player.hgt)
                    end
                end
            end
        end
        
        --Collision blocs
        for i, b in pairs(room.blocs[1]) do
            if b.isSolid and not b.isLiquid then
                
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                if collision_rectToRect(player.x, player.y + moveSpeed, player.wth, player.hgt, x, y, blocs.size, blocs.size) then
                    b:onTouch(1)
                    if y - (player.y + player.hgt) < dy then
                        dy = y - (player.y + player.hgt)
                    end
                end
            end
            
            if b.isLiquid then
                
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                --Calcul la hauteur du liquide
                local liquidHeight = b.fillingRate * blocs.size / 100
                
                if collision_rectToRect(player.x, player.y + moveSpeed, player.wth, player.hgt, x, y + (blocs.size - liquidHeight), blocs.size, liquidHeight) then
                    b:onTouch(1)
                    if b.isSolid then
                        if (y + (blocs.size - liquidHeight)) - (player.y + player.hgt) < dy then
                            dy = (y + (blocs.size - liquidHeight)) - (player.y + player.hgt)
                        end
                    end
                end
            end
        end
        
        --Déplacement du joueur
        if dy ~= math.huge then
            player.touchGround()
            
            if dy ~= 0 then
                print("animation : le joueur touche le lol")
                
                player.changeAnimation(9)
            end
            
            player.y = player.y + dy
            
            return false
        end
        
        player.y = player.y + moveSpeed
        
        if moveSpeed > 0 then
            --Réinitialise le saut (vu que le joueur est en train de tomber)
            player.isJumping = true
            player.canJumpHigher = false
            
            --Affiche une petite animation de particules qui tombe
        end
        
        return true
    end
end

player.canMoveX = function(moveSpeed, isPushed)
    if not isPushed then
        --Test si il joueur dans une matière qui le ralenti
        for i, e in pairs(room.entities) do
            if e.solidResistance ~= 100 then
                if collision_rectToRect(player.x, player.y, player.wth, player.hgt, e:getXYWH()) then
                    moveSpeed = moveSpeed * (100 -e.solidResistance) / 100
                end
            end
        end
    end
    
    local dx = math.huge
    
    if moveSpeed < 0 then
        --Collision bords de la salle
        if player.x + moveSpeed < room.x then
            if room.cardinality[3] == 0 then
                --Se bloque contre le bord
                if player.x - room.x < dx then
                    dx = player.x - room.x
                end
            end
        end
        
        --Collision entités
        for i, e in pairs(room.entities) do
            if collision_rectToRect(player.x + moveSpeed, player.y + 1, player.wth, player.hgt - 2, e:getXYWH()) then
                if e.solidResistance == 100 then
                    if player.x - (e.x + e.wth) < dx then
                        dx = player.x - (e.x + e.wth)
                    end
                end
            end
        end
        
        --Collision blocs
        for i, b in pairs(room.blocs[1]) do
            if b.isSolid and not b.isLiquid then
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                if collision_rectToRect(player.x + moveSpeed, player.y + 1, player.wth, player.hgt - 2, x, y, blocs.size, blocs.size) then
                    if player.x - (x + blocs.size) < dx then
                        dx = player.x - (x + blocs.size)
                    end
                end
            end
            
            if b.isLiquid then
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                --Calcul la hauteur du liquide
                local liquidHeight = b.fillingRate * blocs.size / 100
                
                if collision_rectToRect(player.x + moveSpeed, player.y + 1, player.wth, player.hgt - 2, x, y + (blocs.size - liquidHeight), blocs.size, liquidHeight) then
                    if b.isSolid then
                        if player.x - (x + blocs.size) < dx then
                            dx = player.x - (x + blocs.size)
                        end
                    end
                end
            end
        end
        
        if dx ~= math.huge then
            return false
        end
        
        return true
        
    elseif moveSpeed > 0 then
        --Collision bords de la salle
        if player.x + moveSpeed + player.wth > room.x + room.wth then
            if room.cardinality[4] == 0 then
                --Se bloque contre le bord
                if (room.x + room.wth) - (player.x + player.wth) < dx then
                    dx = (room.x + room.wth) - (player.x + player.wth)
                end
            end
        end
        
        --Collision entités
        for _, e in pairs(room.entities) do
            --Collisions coté gauche des entités
            if collision_rectToRect(player.x + moveSpeed, player.y + 1, player.wth, player.hgt - 2, e:getXYWH()) then
                if e.solidResistance == 100 then
                    if e.x - (player.x + player.wth) < dx then
                        dx = e.x - (player.x + player.wth)
                    end
                end
            end
        end
        
        --Collision blocs
        for i, b in pairs(room.blocs[1]) do
            if b.isSolid and not b.isLiquid then
                
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                if collision_rectToRect(player.x + moveSpeed, player.y + 1, player.wth, player.hgt - 2, x, y, blocs.size, blocs.size) then
                    if x - (player.x + player.wth) < dx then
                        dx = x - (player.x + player.wth)
                    end
                end
            end
            
            if b.isLiquid then
                
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                --Calcul la hauteur du liquide
                local liquidHeight = b.fillingRate * blocs.size / 100
                
                if collision_rectToRect(player.x + moveSpeed, player.y + 1, player.wth, player.hgt - 2, x, y + (blocs.size - liquidHeight), blocs.size, liquidHeight) then
                    if b.isSolid then
                        if x - (player.x + player.wth) < dx then
                            dx = x - (player.x + player.wth)
                        end
                    end
                end
            end
        end
        
        if dx ~= math.huge then
            return false
        end
        
        return true
    end
end

player.canMoveY = function(moveSpeed, isPushed)
    
    if not isPushed then
        --Test si il joueur dans une matière qui le ralenti
        for _, e in pairs(room.entities) do
            if e.solidResistance ~= 100 then
                if collision_rectToRect(player.x, player.y, player.wth, player.hgt, e:getXYWH()) then
                    moveSpeed = moveSpeed * (100 -e.solidResistance) / 100
                end
            end
        end
    end
    
    local dy = math.huge
    
    if moveSpeed < 0 then
        --Collision bords de la salle
        if player.y + moveSpeed < 0 then
            if room.cardinality[1] == 0 then
                --Se bloque au bord
                if player.y < dy then
                    dy = player.y
                end
            end
        end
        
        --Collision entités
        for _, e in pairs(room.entities) do
            if collision_rectToRect(player.x + 1, player.y + moveSpeed, player.wth - 2, player.hgt, e:getXYWH()) then
                if e.solidResistance == 100 then
                    if player.y - (e.y + e.hgt) < dy then
                        dy = player.y - (e.y + e.hgt)
                    end
                end
            end
        end
        
        --Collision blocs
        for i, b in pairs(room.blocs[1]) do
            if b.isSolid and not b.isLiquid then
                
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                if collision_rectToRect(player.x + 1, player.y + moveSpeed, player.wth - 2, player.hgt, x, y, blocs.size, blocs.size) then
                    if player.y - (y + blocs.size) < dy then
                        dy = player.y - (y + blocs.size)
                    end
                end
            end
            
            if b.isLiquid then
                
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                --Calcul la hauteur du liquide
                local liquidHeight = b.fillingRate * blocs.size / 100
                
                if collision_rectToRect(player.x + 1, player.y + moveSpeed, player.wth - 2, player.hgt, x, y + (blocs.size - liquidHeight), blocs.size, liquidHeight) then
                    if b.isSolid then
                        if player.y - (y + blocs.size) < dy then
                            dy = player.y - (y + blocs.size)
                        end
                    end
                end
            end
        end
        
        if dy ~= math.huge then
            return false
        end
        
        return true
    elseif moveSpeed > 0 then
        --Collision bords de la salle
        if player.y + moveSpeed + player.hgt > room.y + room.hgt then
            if room.cardinality[2] == 0 then
                --Se bloque au bord
                if room.y + room.hgt - (player.y + player.hgt) < dy then
                    dy = room.y + room.hgt - (player.y + player.hgt)
                end
            end
        end
        
        --Collision entités
        for _, e in pairs(room.entities) do
            if collision_rectToRect(player.x + 1, player.y + moveSpeed, player.wth - 2, player.hgt, e:getXYWH()) then
                if e.solidResistance == 100 then
                    if e.y - (player.y + player.hgt) < dy then
                        dy = e.y - (player.y + player.hgt)
                    end
                end
            end
        end
        
        --Collision blocs
        for i, b in pairs(room.blocs[1]) do
            if b.isSolid and not b.isLiquid then
                
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                if collision_rectToRect(player.x + 1, player.y + moveSpeed, player.wth - 2, player.hgt, x, y, blocs.size, blocs.size) then
                    if y - (player.y + player.hgt) < dy then
                        dy = y - (player.y + player.hgt)
                    end
                end
            end
            
            if b.isLiquid then
                
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                --Calcul la hauteur du liquide
                local liquidHeight = b.fillingRate * blocs.size / 100
                
                if collision_rectToRect(player.x + 1, player.y + moveSpeed, player.wth - 2, player.hgt, x, y + (blocs.size - liquidHeight), blocs.size, liquidHeight) then
                    if b.isSolid then
                        if (y + (blocs.size - liquidHeight)) - (player.y + player.hgt) < dy then
                            dy = (y + (blocs.size - liquidHeight)) - (player.y + player.hgt)
                        end
                    end
                end
            end
        end
        
        --Déplacement du joueur
        if dy ~= math.huge then
            return false
        end
        
        return true
    end
end

player.changeAnimation = function(animationStage)
--    print(player.drawings[player.animationStage].frame.."\\"..player.drawings[player.animationStage].frames)
    
    --Vérifie que la nouvelle animation est différente et qu'elle est complétée (si c'est nécessaire)
    if player.animationStage ~= animationStage and
    (not player.drawings[player.animationStage].mandatory or (player.drawings[player.animationStage].mandatory and player.drawings[player.animationStage].frame == player.drawings[player.animationStage].frames - 1)) then
        
        --Reset la nouvelle animation
        player.drawings[animationStage].frame = 0
        player.drawings[animationStage].isPlaying = true
        player.drawings[animationStage].isVisible = true
        
        --Arrête l'actualisation de l'ancienne animation
        player.drawings[player.animationStage].isPlaying = true
        
        --Change l'animation
        player.animationStage = animationStage
        return true
    end
    
    return false
end

player.getDirection = function(oldPlayerX, oldPlayerY)--Test ou le joueur s'est déplacé
    
    if oldPlayerY == player.y then
        if inputs[#inputs] == 3 then
            
            player.changeAnimation(2)
            print("animation : Le joueur va vers la gauche en etant sur le lol")
            
        elseif inputs[#inputs] == 4 then
            
            player.changeAnimation(2)
            print("animation : Le joueur va vers la droite en etant sur le lol")
            
        else
            
            player.changeAnimation(1)
            print("animation : Le joueur est immobile")
            
        end
    elseif player.airTime ~= 0 then
        if oldPlayerX == player.x then
            if oldPlayerY < player.y then
                
                player.changeAnimation(6)
                print("animation : Le joueur descend sans bouger de x")
                
            elseif oldPlayerY > player.y then
                
                player.changeAnimation(5)
                print("animation : Le joueur monte sans bouger de x")
                
            end
        elseif oldPlayerX < player.x then
            if oldPlayerY < player.y then
                
                player.changeAnimation(8)
                print("animation : Le joueur descend en allant a droite")
                
            elseif oldPlayerY > player.y then
                
                player.changeAnimation(7)
                print("animation : Le joueur monte en allant a droite")
                
            end
        elseif oldPlayerX > player.x then
            if oldPlayerY < player.y then
                
                player.changeAnimation(8)
                print("animation : Le joueur descend en allant a gauche")
                
            elseif oldPlayerY > player.y then
                
                player.changeAnimation(7)
                print("animation : Le joueur monte en allant a gauche")
                
            end
        end
    end
end

player.update = function(dt)--Gère les mouvements joueur
    
    --Récupère la position du joueur
    local oldPlayerX, oldPlayerY = player.x, player.y
    
    --Direction du joueur
    if inputs[#inputs] == 2 then
        --Appuie sur "s"
    elseif inputs[#inputs] == 3 then
        --Appuie sur "a"
        player.moveX( - player.moveSpd * dt)
    elseif inputs[#inputs] == 4 then
        --Appuie sur "d"
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

    --Applique le frottement de l'air (pour la vitesse horizontal uniquement)
    player.xSpd = toZero(player.xSpd, airFriction*dt)

    --Annule la gravité si le joueur est en train de sauter
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

    --Test si le joueur est dans un objet où il peut nager [WIP]
--    for i, e in pairs(room.entities) do
--        if e.canSwim and collision_rectToRect(player.x, player.y, player.wth, player.hgt, e.x, e.y, e.wth, e.hgt) then
--            player.isJumping = false
--        end
--    end
    
    if player.isJumping then
        player.airTime = player.airTime + 1000 * dt
    else
        player.airTime = 0
        player.jumpLevel = 1
    end
    
    player.drawings[player.animationStage]:update(dt)
    
    player.getDirection(oldPlayerX, oldPlayerY)
    
    rooms.refreshCamera(player.x + player.wth/2, player.y + player.hgt/2)
end

player.draw = function()--Dessine le joueur
    player.drawings[player.animationStage]:draw()
    
    lg.setColor(255, 255, 255)
    
    if debug.visible then
        lg.rectangle("line", player.x, player.y, player.wth, player.hgt)
    end
    
    if player.showGrid then
        --Calcul la position de la grille
        _, dump = math.modf(room.x/blocs.size)
        _, dump2 = math.modf(room.y/blocs.size)
        
        --Affiche la grille
        lg.draw(player.grid, dump*blocs.size + wdow.shake.x, dump2*blocs.size + wdow.shake.y)
    end
end
