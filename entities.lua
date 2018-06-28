--Chargement du fichier qui contient tous les types d'entité
dofile("data/entity.lua")

--Table qui contient tous les fonctons concernant les entités
entities = {}

entities.create = function(x, y, wth, hgt, id)--Création d'une entité
    local en = {}
    
    en = entity[id]:new()
    en.id = id
    en.x = x
    en.y = y
    en.wth = wth
    en.hgt = hgt

    table.insert(room.entities, en)
end

entities.moveX = function(moveSpeed)--Gère le mouvement horizontal des entités
    for i, v in pairs(room.entities) do
        if v.solidResistance == 100 then
            local canMove = false
            
            if moveSpeed < 0 then
                --Collision coté gauche entities
                if collision_rectToRect(player.x, player.y, player.wth, player.hgt - 1, v.x + moveSpeed, v.y, v.wth, v.hgt) == 3 then
                    if player.moveX(v.x + moveSpeed - (player.x + player.wth)) then canMove = true end
                else
                    canMove = true
                end
            elseif moveSpeed > 0 then
                --Collision coté droit entities
                if collision_rectToRect(player.x, player.y, player.wth, player.hgt - 1, v.x + moveSpeed, v.y, v.wth, v.hgt) == 4 then
                    if player.moveX((v.x + moveSpeed + v.wth) - player.x) then canMove = true end
                else
                    canMove = true
                end
            end
            
            if canMove then
                v.x = v.x + moveSpeed
                
                --Test si le joueur est sur l'entité lorsqu'elle se déplace
                if (player.y + player.hgt == v.y) and (player.x < v.x - moveSpeed + v.wth and player.x + player.wth > v.x) then
                    player.moveX(moveSpeed)
                end
            else
                print("Le joueur est ecrase par une entite avec une vitesse de "..moveSpeed.." x !!")
            end
        else
            v.x = v.x + moveSpeed
            if collision_rectToRect(player.x, player.y, player.wth, player.hgt, v.x, v.y, v.wth, v.hgt) ~= 0 then
                player.moveX(moveSpeed * v.solidResistance / 100, true)
            end
        end
    end
end

entities.moveY = function(moveSpeed)--Gère le mouvement vertical des entités
    for i, v in pairs(room.entities) do
        if v.solidResistance == 100 then
            local canMove = false
            
            if moveSpeed < 0 then
                --Collisions coté dessous des plateformes
                if collision_rectToRect(player.x, player.y, player.wth, player.hgt, v.x, v.y + moveSpeed, v.wth, v.hgt) == 1 then
                    if player.moveY(v.y + moveSpeed - (player.y + player.hgt)) then canMove = true end
                else
                    canMove = true
                end
            elseif moveSpeed > 0 then
                --Collisions coté dessus des plateformes
                if collision_rectToRect(player.x, player.y, player.wth, player.hgt, v.x, v.y + moveSpeed, v.wth, v.hgt) == 2 then
                    if player.moveY(player.y - (v.y + v.hgt + moveSpeed)) then canMove = true end
                else
                    canMove = true
                end
            end
            
            if canMove then
                v.y = v.y + moveSpeed
                
                --Test si le joueur est sur l'entité lorsqu'elle se déplace
                if (player.y + player.hgt == v.y - moveSpeed) and (player.x < v.x + v.wth and player.x + player.wth > v.x) then
                    player.moveY(moveSpeed)
                end
            else
                print("Le joueur est ecrase par une entite avec une vitesse de "..moveSpeed.." y !!")
            end
            
        else
            v.y = v.y + moveSpeed
            if collision_rectToRect(player.x, player.y, player.wth, player.hgt, v.x, v.y, v.wth, v.hgt) ~= 0 then
                player.moveY(moveSpeed * v.solidResistance / 100, true)
            end
        end
    end
end

entities.update = function(dt)--Pas encore utilisé
    
end

entities.draw = function()--Dessine les entités
    for i, v in pairs(room.entities) do
        lg.setColor(unpack(v.colors))
        lg.rectangle("fill", v.x, v.y, v.wth, v.hgt)
        
        lg.setFont(debug.font)
        lg.setColor(255, 255, 255)
        lg.rectangle("fill", v.x, v.y, debug.font:getWidth(v.id), debug.font:getHeight(v.id))
        lg.setColor(0, 0, 0)
        lg.print(v.id, v.x, v.y)
    end
end
