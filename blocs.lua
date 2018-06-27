--Chargement du fichier qui contient tous les types de blocs
dofile("data/bloc.lua")

--Table qui contient tous les fonctions concernant les blocs
blocs = {}

--Taille des blocs
blocs.size = 50

blocs.calculateCardinality = function(bloc1, bloc2)--Calcul les les cardinalités  du bloc choisi
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

blocs.push = function(...)--Permet de créer un bloc (coordonnés sur la grille)
    for _, blocValues in pairs({...}) do
        --Modifie les images si un blocs est a coté
        if blocValues.imgLink then
            blocValues.imgCardinality = {0, 0, 0, 0}
            for i, b in pairs(room.blocs) do
                if b.imgLink then
                    blocValues, b = blocs.calculateCardinality(blocValues, b)
                end
            end
        end
        table.insert(room.blocs, blocValues)
    end
end

blocs.flush = function()--Permet de supprimer tous les blocs
    room.blocs = {}
end

blocs.pop = function (x, y)--Permet de supprimer un bloc (coordonnés sur la grille)
    for i, v in ipairs(room.blocs) do
        if v.x == x and v.y == y then room.blocs[i] = nil end
    end
end

blocs.create = function(x, y, id)--Permet de créer un bloc (coordonnés en pixel)
    local bx = math.floor((-room.x + x) / blocs.size) + 1
    local by = math.floor((-room.y + y) / blocs.size) + 1

    blocs.push(bloc[id]:new({x = bx, y = by}))
end

blocs.getPos = function(x, y)--Permet de trouver les coordonnés x et y en pixel
    x = room.x + x * blocs.size - blocs.size
    y = room.y + y * blocs.size - blocs.size

    return x, y
end

blocs.update = function(dt)--Vérification des événements des blocs
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


blocs.draw = function()--Dessine les blocs
    lg.setColor(255, 255, 255)

    for i, b in pairs(room.blocs) do
        local x, y = blocs.getPos(b.x, b.y)
        
        --Si le bloc est sur l'écran
        if (x + blocs.size > 0 and x < wdow.wth) and
        (y + blocs.size > 0 and y < wdow.hgt) then
            lg.setColor(255, 255, 255)
            if b.imgLink then
                lg.draw(src.img.bloc[b.img.."_"..table.concat(b.imgCardinality)], x, y)
            else
                lg.draw(src.img.bloc[b.img], x, y)
            end
            
            --[[Debug]]--
            if debug.visible then
                lg.setColor(unpack(debug.color))
                --lg.rectangle("line", x, y, blocs.size, blocs.size)
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