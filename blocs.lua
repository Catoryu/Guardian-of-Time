--Chargement du fichier qui contient tous les types de blocs
dofile("data/bloc.lua")

--Table qui contient tous les fonctions concernant les blocs
blocs = {}

--Taille des blocs
blocs.size = 50

--Contient tous les blocs qui doivent être supprimé (à la fin de l'update)
blocs.toDelete = {}

--Couleur des couches de bloc (la première couche n'as pas de couleur spéciales)
blocs.layerColor = {
    true,
    {0, 0, 0, 255}
}

--Synchronise l'actualisation des liquides
blocs.liquid = {}
blocs.liquid.water = {frame = 0, refreshRate = 0.01, active = false}
blocs.liquid.sand = {frame = 0, refreshRate = 0.05, active = false}

blocs.exists = function(x, y, layer)--Test si un bloc existe dans une certaine coordonné
    blocs.checkIfLayerExists(layer)
    
    for _, b in pairs(room.blocs[layer]) do
        if b.x == x and b.y == y then
            return true
        end
    end
    
    return false
end

blocs.calculateCardinality = function(bloc, destroy)--Calcul les les cardinalités du bloc choisi (Regarde autour du bloc)
    blocs.checkIfLayerExists(bloc.layer)
    
    if destroy then
        for _, b in pairs(room.blocs[bloc.layer]) do
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
        
        for _, b in pairs(room.blocs[bloc.layer]) do
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

blocs.checkIfLayerExists = function(layer)--Crée la couche du bloc si elle n'existe pas
    if room.blocs[layer] == nil then
        for i = 1, layer do
            if room.blocs[i] == nil then
                room.blocs[i] = {}
            end
        end
    end
    
    if blocs.toDelete[layer] == nil then
        for i = 1, layer do
            if blocs.toDelete[i] == nil then
                blocs.toDelete[i] = {}
            end
        end
    end
end

blocs.push = function(isSafe, ...)--Permet de créer un bloc (coordonnés sur la grille)
    for _, b in pairs({...}) do
        
        blocs.checkIfLayerExists(b.layer)
        
        --Crée la couleur des blocs par couche si elle n'existe pas
        if blocs.layerColor[b.layer] == nil then
            for i = 1, b.layer do
                if blocs.layerColor[i] == nil then
                    blocs.layerColor[i] = {0, 0, 0, 255}
                end
            end
        end
        
        local x, y = blocs.getPos(b.x, b.y)
        
        --Test de collision avec le joueur lors de la création
        if isSafe and b.layer == 1 then
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
        
        table.insert(room.blocs[b.layer], b)
    end
    
    return true
end

blocs.flush = function()--Permet de supprimer tous les blocs
    room.blocs = {}
end

blocs.get = function(x, y, layer)--Permet de récupérer un bloc selon ses coordonnés
    blocs.checkIfLayerExists(layer)
    
    for _, b in pairs(room.blocs[layer]) do
        if b.x == x and b.y == y then
            return b
        end
    end
    
    return false
end

blocs.pop = function (x, y, layer)--Permet de supprimer un bloc (coordonnés sur la grille)
    --Crée la couche du bloc si elle n'existe pas
    if blocs.toDelete[layer] == nil then
        for i = 1, layer do
            if blocs.toDelete[i] == nil then
                blocs.toDelete[i] = {}
            end
        end
    end
    
    for i, b in pairs(room.blocs[layer]) do
        if b.x == x and b.y == y then
            table.insert(blocs.toDelete[layer], i)
        end
    end
end

blocs.count = function()--Calcul le nombre total de blocs
    local count = 0
    
    for i = 1, #room.blocs do
        count = count + #room.blocs[i]
    end
    
    return count
end

blocs.create = function(x, y, id, safe, layer)--Permet de créer un bloc (coordonnés en pixel)
    local bx, by = blocs.getCoordPos(x, y)

    blocs.push(safe, bloc[id]:new({x = bx, y = by, layer = layer}))
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
    
    for j = 1, #room.blocs do
        --Itère à travers tous les blocs dans l'ordre décroissant de remplissage
        for _, b in spairs(room.blocs[j], function(t, a, b) return t[b].fillingRate < t[a].fillingRate end) do
            
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
    end
    
    for j = 1, #blocs.toDelete do
        --Trie les blocs à supprimer
        table.sort(blocs.toDelete[j], function(a,b) return b < a end)
        
        --Itère à travers tous les blocs à supprimer
        for i, index in pairs(blocs.toDelete[j]) do
            blocs.calculateCardinality(room.blocs[j][index], true)
            
            --Supprime les blocs qui doivent être supprimé
            table.remove(room.blocs[j], index)
        end
    end
    
    blocs.toDelete = {}
end


blocs.draw = function()--Dessine les blocs
    for j = #room.blocs, 1, -1 do
        for i, b in pairs(room.blocs[j]) do
            --Si le bloc est sur l'écran
            if b:onScreen() then
                
                --Récupère les coordonnées du bloc
                local x, y = blocs.getPos(b.x, b.y)
                
                if j == 1 then
                    lg.setColor(unpack(b.colors))
                else
                    lg.setColor(unpack(mergeColors(b.colors, blocs.layerColor[j])))
                end
                
                --Si le bloc est un liquide
                if b.isLiquid then
                    
                    lg.rectangle("fill", x + wdow.shake.x, y + (100-(b.fillingRate*blocs.size/100) - blocs.size) + wdow.shake.y, blocs.size, (b.fillingRate*blocs.size/100))
                    
                --Si le bloc n'est pas liquide
                else
                    if b.imgLink then
                        lg.draw(src.img.bloc[b.img], src.img.bloc[b.img.."_"..table.concat(b.imgCardinality)], x + wdow.shake.x, y + wdow.shake.y)
                    else
                        lg.draw(src.img.bloc[b.img], x + wdow.shake.x, y + wdow.shake.y)
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
end