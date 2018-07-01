--Chargement du fichier qui contient tous les types de blocs
dofile("data/bloc.lua")

--Table qui contient tous les fonctions concernant les blocs
blocs = {}

--Taille des blocs
blocs.size = 50

blocs.exists = function(x, y)--Test si un bloc existe dans une certaine coordonné
    for i, b in pairs(room.blocs) do
        if b.x == x and b.y == y then
            return true
        end
    end
    
    return false
end

blocs.calculateCardinality = function(bloc, destroy)--Calcul les les cardinalités du bloc choisi (Regarde autour du bloc)
    if destroy then
        for i, b in pairs(room.blocs) do
            if b.imgLink then
                --Bloc en dessous de celui qui est détruit
                if bloc.x == b.x and bloc.y + 1 == b.y then
                    b.imgCardinality[1] = 0
                end
                --Bloc en dessus de celui qui est détruit
                if bloc.x == b.x and bloc.y - 1 == b.y then
                    b.imgCardinality[2] = 0
                end
                --Bloc à droite de celui qui est détruit
                if bloc.x + 1 == b.x and bloc.y == b.y then
                    b.imgCardinality[3] = 0
                end
                --Bloc à gauche de celui qui est détruit
                if bloc.x - 1 == b.x and bloc.y == b.y then
                    b.imgCardinality[4] = 0
                end
            end
        end
    else
        --Réinitialise la cardinality du bloc
        bloc.imgCardinality = {0, 0, 0, 0}
        
        for i, b in pairs(room.blocs) do
            if b.imgLink then
                --Haut
                if bloc.x == b.x and bloc.y - 1 == b.y then
                    bloc.imgCardinality[1] = 1
                    b.imgCardinality[2] = 1
                end
                --Bas
                if bloc.x == b.x and bloc.y + 1 == b.y then
                    bloc.imgCardinality[2] = 1
                    b.imgCardinality[1] = 1
                end
                --Gauche
                if bloc.x - 1 == b.x and bloc.y == b.y then
                    bloc.imgCardinality[3] = 1
                    b.imgCardinality[4] = 1
                end
                --Droite
                if bloc.x + 1 == b.x and bloc.y == b.y then
                    bloc.imgCardinality[4] = 1
                    b.imgCardinality[3] = 1
                end
            end
        end
    end
    
    return bloc
end

blocs.push = function(...)--Permet de créer un bloc (coordonnés sur la grille)
    for _, blocValues in pairs({...}) do
        --Modifie les images si un blocs est a coté
        if blocValues.imgLink then
            blocValues.imgCardinality = {0, 0, 0, 0}
            blocValues = blocs.calculateCardinality(blocValues)
        end
        
        blocValues.frame = time + blocValues.refreshRate
        
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
    --Itère à travers tous les blocs dans l'ordre décroissant de remplissage
    for i, b in spairs(room.blocs, function(t, a, b) return t[b].fillingRate < t[a].fillingRate end) do
        
        if time > b.frame then
            b.frame = b.frame + b.refreshRate
            
            if b.isGravityAffected then
                b:moveY(1)
            end
            
            if b.isLiquid then
                b:flow()
            end
        end
        
        --Si le bloc est déclenché au bout d'un moment
        if b.isTimely then
            
            --Diminue la durée avant que l'événement commence
            b.ttl = b.ttl - 1000*dt
            
            --Test si la durée avant que l'événement commence est inférieur ou égale à 0
            if b.ttl <= 0 then
                if b.activeEvent.ttlReach then
                    --Déclenche l'événement
                    b:onTtlReached()
                end
            end
        end
    end
end


blocs.draw = function()--Dessine les blocs
    lg.setColor(255, 255, 255)

    for i, b in pairs(room.blocs) do
        --Récupère les coordonnées du bloc
        local x, y = blocs.getPos(b.x, b.y)
        
        --Si le bloc est sur l'écran
        if (x + blocs.size > 0 and x < wdow.wth) and
        (y + blocs.size > 0 and y < wdow.hgt) then
            
            --Si le bloc est un liquide
            if b.isLiquid then
                lg.setColor(unpack(b.colors))
                lg.rectangle("fill", x, y + (100-(b.fillingRate*blocs.size/100) - blocs.size), blocs.size, (b.fillingRate*blocs.size/100))
            --Si le bloc n'est pas liquide
            else
                lg.setColor(255, 255, 255)
                if b.imgLink then
                    lg.draw(src.img.bloc[b.img.."_"..table.concat(b.imgCardinality)], x, y)
                else
                    lg.draw(src.img.bloc[b.img], x, y)
                end
            end
            
            --[[Debug]]--
            if debug.visible then
                lg.setColor(unpack(debug.color))
                --lg.rectangle("line", x, y, blocs.size, blocs.size)
                lg.print("x" .. b.x .. " y" .. b.y , x, y)
                lg.print("id:"..b.id, x, y + 10)
--                lg.print(string.format("%d frame/s", b.frame), x, y + 20)
                if b.isTimely then
                    lg.print(string.format("%d ms", b.ttl), x, y + 20)
                end
                if b.imgLink then
                    lg.print(table.concat(b.imgCardinality), x, y + 30)
                end
                if b.isLiquid then
                    lg.print(b.fillingRate, x, y + 40)
                end
            end
        end
    end
end