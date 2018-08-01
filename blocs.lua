--Chargement du fichier qui contient tous les types de blocs
dofile("data/bloc.lua")

--Table qui contient tous les fonctions concernant les blocs
blocs = {}

--Taille des blocs
blocs.size = 50

--Contient tous les blocs qui doivent être supprimé (à la fin de l'update)
blocs.toDelete = {}

--Synchronise l'actualisation des liquides
blocs.liquid = {}
blocs.liquid.water = {frame = 0, refreshRate = 0.01, active = false}
blocs.liquid.sand = {frame = 0, refreshRate = 0.05, active = false}

blocs.exists = function(x, y)--Test si un bloc existe dans une certaine coordonné
    for _, b in pairs(room.blocs) do
        if b.x == x and b.y == y then
            return true
        end
    end
    
    return false
end

blocs.calculateCardinality = function(bloc, destroy)--Calcul les les cardinalités du bloc choisi (Regarde autour du bloc)
    if destroy then
        for _, b in pairs(room.blocs) do
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
        
        for _, b in pairs(room.blocs) do
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

blocs.push = function(isSafe, ...)--Permet de créer un bloc (coordonnés sur la grille)
    for _, b in pairs({...}) do
        
        local x, y = blocs.getPos(b.x, b.y)
        
        --Test de collision avec le joueur lors de la création
        if isSafe then
            if not b.isLiquid then
                if collision_rectToRect(x, y, blocs.size, blocs.size, player:getXYWH()) then
                    return false
                end
            else
                --Récupère les coordonnés du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                --Calcul la hauteur du liquide
                local liquidHeight = b.fillingRate * blocs.size / 100
                
                if collision_rectToRect(x, y + (blocs.size - liquidHeight), blocs.size, liquidHeight, player:getXYWH()) then
                    return false
                end
            end
        end
        
        --Modifie les images si un blocs est a coté
        if b.imgLink then
            b.imgCardinality = {0, 0, 0, 0}
            b = blocs.calculateCardinality(b)
        end
        
        b.frame = time + b.refreshRate
        
        table.insert(room.blocs, b)
    end
    
    return true
end

blocs.flush = function()--Permet de supprimer tous les blocs
    room.blocs = {}
end

blocs.get = function(x, y)--Permet de récupérer un bloc selon ses coordonnés
    for _, b in pairs(room.blocs) do
        if b.x == x and b.y == y then
            return b
        end
    end
    
    return false
end

blocs.pop = function (x, y)--Permet de supprimer un bloc (coordonnés sur la grille)
    for i, b in pairs(room.blocs) do
        if b.x == x and b.y == y then
            table.insert(blocs.toDelete, i)
        end
    end
end

blocs.create = function(x, y, id, safe)--Permet de créer un bloc (coordonnés en pixel)
    local bx, by = blocs.getCoordPos(x, y)

    blocs.push(safe, bloc[id]:new({x = bx, y = by}))
end

blocs.getPos = function(x, y)--Permet de trouver les coordonnés x et y en pixel
    x = room.x + x * blocs.size - blocs.size
    y = room.y + y * blocs.size - blocs.size

    return x, y
end

blocs.getCoordPos = function(x, y)--Permet de trouver des coordonnées via un x et un y en pixel
    local bx = math.floor((-room.x + x) / blocs.size) + 1
    local by = math.floor((-room.y + y) / blocs.size) + 1
    
    return bx, by
end

blocs.update = function(dt)--Vérification des événements des blocs
    --Gère les frames synchronisé des liquides
    for _, b in pairs(blocs.liquid) do
        b.active = false
        
        if time > b.frame then
            b.frame = b.frame + b.refreshRate
            b.active = true
        end
    end
    
    --Itère à travers tous les blocs dans l'ordre décroissant de remplissage
    for _, b in spairs(room.blocs, function(t, a, b) return t[b].fillingRate < t[a].fillingRate end) do
        
        --Si le bloc est déclenché au bout d'un moment
        if b.timePass then
            
            --Diminue la durée avant que l'événement commence
            b.ttl = b.ttl - 1000*dt
            
            --Test si la durée avant que l'événement commence est inférieur ou égale à 0
            if b.ttl <= 0 then
                b:onTtlReach()
            end
        end
        
        if b.isLiquid then
            --Si le lquide en question peut couler
            if blocs.liquid[b.name].active then
                b:flow()
            end
        elseif time > b.frame then
            b.frame = b.frame + b.refreshRate
            
            --Applique la gravité
            if b.isGravityAffected then
                b:moveY(1)
            end
        end
    end
    
    --Trie les blocs à supprimer
    table.sort(blocs.toDelete, function(a,b) return b < a end)
    
    --Itère à travers tous les blocs à supprimer
    for i, index in pairs(blocs.toDelete) do
        --Supprime les blocs qui doivent être supprimé
        table.remove(room.blocs, index)
    end
    
    blocs.toDelete = {}
end


blocs.draw = function()--Dessine les blocs
    for i, b in pairs(room.blocs) do
        --Si le bloc est sur l'écran
        if b:onScreen() then
            
            --Récupère les coordonnées du bloc
            local x, y = blocs.getPos(b.x, b.y)
            
            --Si le bloc est un liquide
            if b.isLiquid then
                lg.setColor(unpack(b.colors))
                
                lg.rectangle("fill", x, y + (100-(b.fillingRate*blocs.size/100) - blocs.size), blocs.size, (b.fillingRate*blocs.size/100))
            
            --Si le bloc n'est pas liquide
            else
                lg.setColor(255, 255, 255, 255)
                
                if b.imgLink then
                    lg.draw(src.img.bloc[b.img], src.img.bloc[b.img.."_"..table.concat(b.imgCardinality)], x, y)
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
                if b.timePass then
                    lg.print(string.format("%d ms", b.ttl), x, y + 20)
                end
                if b.imgLink then
                    lg.print(table.concat(b.imgCardinality), x, y + 30)
                end
                if b.isLiquid then
                    lg.print(string.format("%.2f", b.fillingRate), x, y + 40)
                end
            end
        end
    end
end