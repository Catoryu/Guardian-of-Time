dofile("data/entity.lua")

entities = {}
entities.container = {}
entities.create = function(x, y, wth, hgt, id)
    local en = {}
    
    en = entity[id]:new()
    en.id = id
    en.x = x
    en.y = y
    en.wth = wth
    en.hgt = hgt

    table.insert(entities.container, en)
end

entities.moveX = function(moveSpeed)
    for i, v in pairs(entities.container) do
        v.x = v.x + moveSpeed
        
        if v.solidResistance == 100 then
            if moveSpeed < 0 then
                --Collision coté droit entities
                if (player.y + player.hgt - 1 > v.y and player.y < v.y + v.hgt) and
                (player.x < v.x and player.x + player.wth > v.x) then
                    player.x = v.x - player.wth
                end
            elseif moveSpeed > 0 then
                --Collision coté droit entities
                if (player.y + player.hgt - 1 > v.y and player.y < v.y + v.hgt) and
                (player.x < v.x + v.wth and player.x + player.wth > v.x + v.wth) then
                    player.x = v.x + v.wth
                end
            end
        elseif collision_rectToRect(player.x, player.y, player.wth, player.hgt, v.x, v.y, v.wth, v.hgt) ~= 0 then
            player.moveX(moveSpeed)
        end
    end
end

entities.moveY = function(moveSpeed)
    for i, v in pairs(entities.container) do
        v.y = v.y + moveSpeed
        
        if v.solidResistance == 100 then
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
        elseif collision_rectToRect(player.x, player.y, player.wth, player.hgt, v.x, v.y, v.wth, v.hgt) ~= 0 then
            player.moveY(moveSpeed)
        end
    end
end

entities.draw = function()
    for i, v in pairs(entities.container) do
        lg.setColor(unpack(v.colors))
        lg.rectangle("fill", v.x, v.y, v.wth, v.hgt)
        
        lg.setFont(debug.font)
        lg.setColor(255, 255, 255)
        lg.rectangle("fill", v.x, v.y, debug.font:getWidth(v.id), debug.font:getHeight(v.id))
        lg.setColor(0, 0, 0)
        lg.print(v.id, v.x, v.y)
    end
end
