--Chargement de tous les types de blocs
dofile("data/bloc.lua")

--World/Map creation
room = {}
room.blocSize = 50
room.cols = 40
room.rows = 20
room.wth = room.cols * room.blocSize
room.hgt = room.rows * room.blocSize
room.x = 0
room.y = -room.hgt + wdow.hgt
room.grid = {}
--Table qui contient tous les blocs non vide (Optimise le test des collisions)
room.updateBlocs = {}

room.setBloc = function(...)
    for i, v in pairs({...}) do
        room.grid[v[1]][v[2]] = bloc[v[3]]:new({x = v[1], y = v[2]})
        --Ajout du bloc dans la table contenant tous les blocs non vide
        table.insert(room.updateBlocs, bloc[v[3]]:new({x = v[1], y = v[2]}))
    end
end

room.moveCameraX = function(moveSpeed)
    local deltaX = 0

    --Marge d'erreur de la salle
    if room.x + moveSpeed > 0 then
        deltaX = room.x
        room.x = room.x - deltaX
        for i, v in pairs(entities.container) do
            v.x = v.x - deltaX
        end
        player.x = player.x - deltaX
        return
    elseif room.x + room.wth + moveSpeed < wdow.wth then
        deltaX = room.x + room.wth - wdow.wth
        room.x = room.x - deltaX
        for i, v in pairs(entities.container) do
            v.x = v.x - deltaX
        end
        player.x = player.x - deltaX
        return
    end

    --Bouge les entités
    for i, v in pairs(entities.container) do
        v.x = v.x + moveSpeed
    end

    --Bouge les blocs
    room.x = room.x + moveSpeed
end

room.moveCameraY = function(moveSpeed)
    local deltaY = 0

    --Marge d'erreur mouvement de la salle
    if room.y + moveSpeed > 0 then
        deltaY = room.y
        room.y = room.y - deltaY
        for i, v in pairs(entities.container) do
            v.y = v.y - deltaY
        end
        player.y = player.y - deltaY
        return
    elseif room.y + room.hgt + moveSpeed < wdow.hgt then
        deltaY = room.y + room.hgt - wdow.hgt
        room.y = room.y - deltaY
        for i, v in pairs(entities.container) do
            v.y = v.y - deltaY
        end
        player.y = player.y - deltaY
        return
    end

    --Bouge les entités
    for i, v in pairs(entities.container) do
        v.y = v.y + moveSpeed
    end

    --Bouge les blocs
    room.y = room.y + moveSpeed
end

room.update = function(dt)
    --Cooldown des blocs
    for i, v in pairs(room.grid) do
        for ii, vv in pairs(v) do
            if vv.isTimely then
                vv.ttl = vv.ttl - 1000 * dt
                
                if vv.ttl <= 0 and vv.activeEvent.ttlReach then
                    vv:onTtlReached()
                end
            end
        end
    end
end

room.getCellPosition = function(x, y)
    x = room.x + x * room.blocSize - room.blocSize
    y = room.y + y * room.blocSize - room.blocSize

    return x, y
end

room.draw = function()
    lg.setColor(255, 255, 255)
    lg.draw(room.img.bground, room.x, room.y)
    for i, v in pairs(room.grid) do
        for ii, vv in pairs(v) do
            local x = room.x + i*room.blocSize - room.blocSize
            local y = room.y + ii*room.blocSize - room.blocSize
            
            --Test si la cellule est sur l'écran et qu'elle est visible
            if (x + room.blocSize > 0 and x < wdow.wth) and
            (y + room.blocSize > 0 and y < wdow.hgt) and vv.id ~= 1 then
                lg.setColor(255, 255, 255)
                lg.draw(room.img.blocs[vv.id], x, y)
                
                --[[Debug]]--
                if debug.visible then
                    lg.setColor(unpack(debug.color))
                    lg.print("x"..i.." y"..ii, x, y)
                    lg.print(string.format("%d ms", vv.ttl), x, y + 20)
                end
            end
        end
    end
end


gravity = 4000
chapter = 1
level = {}
level.x = 0
level.y = 0

--Chargement d'un niveau
dofile("data/chapter/1/load.lua")