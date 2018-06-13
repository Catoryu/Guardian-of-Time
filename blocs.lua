dofile("data/bloc.lua")

--World/Map creation
gravity = 4000
chapter = 1
level = {}
level.x = 0
level.y = 0

room = {}
room.blocSize = 50
room.cols = 40
room.rows = 20
room.wth = room.cols * room.blocSize
room.hgt = room.rows * room.blocSize
room.x = 0
room.y = -room.hgt + wdow.hgt
room.blocs = {}

function room.calculateCardinality(bloc1, bloc2)
    --Haut
    if bloc1.x == bloc2.x and bloc1.y - 1 == bloc2.y then
        bloc1.imgCardinality[1] = 1
        bloc2.imgCardinality[2] = 1
    end
    --Bas
    if bloc1.x == bloc2.x and bloc1.y + 1 == bloc2.y then
        bloc1.imgCardinality[2] = 1
        bloc2.imgCardinality[1] = 1
    end
    --Gauche
    if bloc1.x - 1 == bloc2.x and bloc1.y == bloc2.y then
        bloc1.imgCardinality[3] = 1
        bloc2.imgCardinality[4] = 1
    end
    --Droite
    if bloc1.x + 1 == bloc2.x and bloc1.y == bloc2.y then
        bloc1.imgCardinality[4] = 1
        bloc2.imgCardinality[3] = 1
    end
    
    return bloc1, bloc2
end

room.pushBloc = function(...)--Permet de créer un bloc (coordonnés sur la grille)
    for _, blocValues in pairs({...}) do
        --Modifie les images si un blocs est a coté
        if blocValues.imgLink then
            blocValues.imgCardinality = {0, 0, 0, 0}
            for i, b in pairs(room.blocs) do
                if b.imgLink then
                    blocValues, b = room.calculateCardinality(blocValues, b)
                end
            end
        end
        table.insert(room.blocs, blocValues)
    end
end

room.flushBlocs = function()--Permet de supprimer tous les blocs
    room.blocs = {}
end

room.popBloc = function (x, y)--Permet de supprimer un bloc (coordonnés sur la grille)
    for i, v in ipairs(room.blocs) do
        if v.x == x and v.y == y then room.blocs[i] = nil end
    end
end

room.createBloc = function(x, y, id)--Permet de créer un bloc (coordonnés en pixel)
    local bx = math.floor((-room.x + x) / room.blocSize) + 1
    local by = math.floor((-room.y + y) / room.blocSize) + 1

    room.pushBloc(bloc[id]:new({x = bx, y = by}))
end

room.getBlocPos = function(x, y)--Permet de trouver les coordonnés x et y en pixel
    x = room.x + x * room.blocSize - room.blocSize
    y = room.y + y * room.blocSize - room.blocSize

    return x, y
end

room.moveCameraX = function(moveSpeed)--Bouge la caméra horizontalement
    local deltaX = 0

    --Marge d'erreur mouvement de la salle
    if room.x + moveSpeed > 0 then
        deltaX = room.x
        room.x = room.x - deltaX
        for i, e in pairs(entities.container) do
            e.x = e.x - deltaX
        end
        player.x = player.x - deltaX
        return
    elseif room.x + room.wth + moveSpeed < wdow.wth then
        deltaX = room.x + room.wth - wdow.wth
        room.x = room.x - deltaX
        for i, e in pairs(entities.container) do
            e.x = e.x - deltaX
        end
        player.x = player.x - deltaX
        return
    end

    --Bouge les entités
    for i, e in pairs(entities.container) do
        e.x = e.x + moveSpeed
    end

    --Bouge les blocs
    room.x = room.x + moveSpeed
end

room.moveCameraY = function(moveSpeed)--Bouge la caméra verticalement
    local deltaY = 0

    --Marge d'erreur mouvement de la salle
    if room.y + moveSpeed > 0 then
        deltaY = room.y
        room.y = room.y - deltaY
        for i, c in pairs(entities.container) do
            c.y = c.y - deltaY
        end
        player.y = player.y - deltaY
        return
    elseif room.y + room.hgt + moveSpeed < wdow.hgt then
        deltaY = room.y + room.hgt - wdow.hgt
        room.y = room.y - deltaY
        for i, c in pairs(entities.container) do
            c.y = c.y - deltaY
        end
        player.y = player.y - deltaY
        return
    end

    --Bouge les entités
    for i, e in pairs(entities.container) do
        e.y = e.y + moveSpeed
    end

    --Bouge les blocs
    room.y = room.y + moveSpeed
end

room.update = function(dt)
    --Itère à travers tous les blocs
    for i, b in pairs(room.blocs) do
        if b.isTimely then
            b.ttl = b.ttl - 1000 * dt

            if b.ttl <= 0 then
                if b.activeEvent.ttlReach then
                    b:onTtlReached()
                end
            end
        end
    end
end


room.draw = function()
    lg.setColor(255, 255, 255)
    lg.draw(room.img.bground, room.x, room.y)

    for i, b in pairs(room.blocs) do
        local x, y = room.getBlocPos(b.x, b.y)

        --Si le bloc est sur l'écran
        if (x + room.blocSize > 0 and x < wdow.wth) and
        (y + room.blocSize > 0 and y < wdow.hgt) then
            lg.setColor(255, 255, 255)
            if b.imgLink then
                lg.draw(src.img.bloc[b.img.."_"..table.concat(b.imgCardinality)], x, y)
            else
                lg.draw(src.img.bloc[b.img], x, y)
            end
            
            --[[Debug]]--
            if debug.visible then
                lg.setColor(unpack(debug.color))
                --lg.rectangle("line", x, y, room.blocSize, room.blocSize)
                lg.print("x" .. b.x .. " y" .. b.y , x, y)
                lg.print("id:"..b.id, x, y + 10)
                if b.isTimely then
                    lg.print(string.format("%d ms", b.ttl), x, y + 20)
                end
                if b.imgLink then
                    lg.print(table.concat(b.imgCardinality), x, y + 30)
                end
            end
        end
    end
end


--Chargement d'un niveau
dofile("data/chapter/1/load.lua")
