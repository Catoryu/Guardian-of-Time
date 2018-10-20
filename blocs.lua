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
        if b.coordX == x and b.coordY == y then
            return true
        end
    end
    
    return false
end

blocs.calculateDimensions = function()
    for i, l in pairs(room.blocs) do
        for j, b in pairs(l) do
            b:calculateDimension()
        end
    end
end

blocs.calculateCardinality = function(bloc, destroy)--Calcul les les cardinalités du bloc choisi (Regarde autour du bloc)
    blocs.checkIfLayerExists(bloc.layer)
    
    if destroy then
        for _, b in pairs(room.blocs[bloc.layer]) do
            --Bloc en dessous de celui qui est détruit
            if bloc.coordX == b.coordX and bloc.coordY + 1 == b.coordY then
                b.cardinality[1] = 0
                if bloc.imgLink then b.imgCardinality[1] = 0 end
                b:wakeUp()
            end
            --Bloc en dessus de celui qui est détruit
            if bloc.coordX == b.coordX and bloc.coordY - 1 == b.coordY then
                b.cardinality[2] = 0
                if bloc.imgLink then b.imgCardinality[2] = 0 end
                b:wakeUp()
            end
            --Bloc à droite de celui qui est détruit
            if bloc.coordX + 1 == b.coordX and bloc.coordY == b.coordY then
                b.cardinality[3] = 0
                if bloc.imgLink then b.imgCardinality[3] = 0 end
                b:wakeUp()
            end
            --Bloc à gauche de celui qui est détruit
            if bloc.coordX - 1 == b.coordX and bloc.coordY == b.coordY then
                b.cardinality[4] = 0
                if bloc.imgLink then b.imgCardinality[4] = 0 end
                b:wakeUp()
            end
        end
    else
        --Réinitialise la cardinality du bloc
        bloc.cardinality = {0, 0, 0, 0}
        
        if bloc.imgLink then bloc.imgCardinality = {0, 0, 0, 0} end
        
        for _, b in pairs(room.blocs[bloc.layer]) do
            --Haut
            if bloc.coordX == b.coordX and bloc.coordY - 1 == b.coordY then
                bloc.cardinality[1] = b.id
                b.cardinality[2] = bloc.id
                
                if b.imgLink then bloc.imgCardinality[1] = 1 end
                if bloc.imgLink then b.imgCardinality[2] = 1 end
                
                b:wakeUp()
            end
            --Bas
            if bloc.coordX == b.coordX and bloc.coordY + 1 == b.coordY then
                bloc.cardinality[2] = b.id
                b.cardinality[1] = bloc.id
                
                if b.imgLink then bloc.imgCardinality[2] = 1 end
                if bloc.imgLink then b.imgCardinality[1] = 1 end
                
                b:wakeUp()
            end
            --Gauche
            if bloc.coordX - 1 == b.coordX and bloc.coordY == b.coordY then
                bloc.cardinality[3] = b.id
                b.cardinality[4] = bloc.id
                
                if b.imgLink then bloc.imgCardinality[3] = 1 end
                if bloc.imgLink then b.imgCardinality[4] = 1 end
                
                b:wakeUp()
            end
            --Droite
            if bloc.coordX + 1 == b.coordX and bloc.coordY == b.coordY then
                bloc.cardinality[4] = b.id
                b.cardinality[3] = bloc.id
                
                if b.imgLink then bloc.imgCardinality[4] = 1 end
                if bloc.imgLink then b.imgCardinality[3] = 1 end
                
                b:wakeUp()
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
            if blocs.layerColor[i] == nil then
                blocs.layerColor[i] = {0, 0, 0, 255}
            end
        end
        
        b:calculateDimension()
        
        if isSafe then
            --Test si il y a déjà un bloc à l'endroit du nouveau bloc
            for i, bb in pairs(room.blocs[b.layer]) do
                if bb.coordX == b.coordX and bb.coordY == b.coordY then
                    print("Le bloc ne peut pas etre place car il y a deja un bloc à cette endroit")
                    return false
                end
            end
            
            --Test de collision avec le joueur lors de la création
            if b.layer == 1 then
                if collision_rectToRect(b.x, b.y, b.wth, b.hgt, player:getXYWH()) then
                    print("Le bloc ne peut pas etre place car il touche le joueur")
                    return false
                end
            end
        end
        
        --Modifie les images si un blocs est a coté
        b.imgCardinality = {0, 0, 0, 0}
        b.cardinality = {0, 0, 0, 0}
        b = blocs.calculateCardinality(b)
        
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
        if b.coordX == x and b.coordY == y then
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
        if b.coordX == x and b.coordY == y then
            --Test si le bloc choisi pour être supprimé existe déjà dans les blocs qui vont être supprimés
            for j, index in pairs(blocs.toDelete[layer]) do
                if index == i then return end
            end
            
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

    blocs.push(safe, bloc[id]:new({coordX = bx, coordY = by, layer = layer}))
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
    for _, f in pairs(blocs.liquid) do
        f.active = false
        
        if time > f.frame then
            f.frame = f.frame + f.refreshRate
            f.active = true
        end
    end
    
    local temp = {}
    
    --Trie les blocs dans l'ordre décroissant de remplissage
    for j = 1, #room.blocs do
        table.insert(temp, {})
        for _, b in spairs(room.blocs[j], function(t, a, b) return t[b].fillingRate < t[a].fillingRate end) do
            table.insert(temp[j], b)
        end
    end
    
    room.blocs = temp
    
    --Itère tous les blocs
    for j = 1, #room.blocs do
        for i, b in pairs(room.blocs[j]) do
            
            if b.update then
                b:onUpdate()
            end
            
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
                --Si le liquide en question peut couler
                if blocs.liquid[b.name].active and b.isAwake then
                    b:flow()
                end
            elseif time > b.frame then
                if b.newFrame then
                    b:onNewFrame()
                end
                
                b.frame = b.frame + b.refreshRate
                
                --Applique la gravité
                if b.isGravityAffected then
                    if b.isAwake then
                        b:moveY(1)
                    else
                        b:sleep()
                    end
                else
                    b:sleep()
                end
            end
        end
    end
    
    for j = 1, #blocs.toDelete do
        --Trie les blocs à supprimer
        table.sort(blocs.toDelete[j], function(a,b) return b < a end)
        
        --Itère à travers tous les blocs à supprimer
        for i, index in pairs(blocs.toDelete[j]) do
            --print("#blocs.toDelete[1]"..#blocs.toDelete[1])
            --print("index"..index)
            
            if room.blocs[j][index] ~= nil then
                blocs.calculateCardinality(room.blocs[j][index], true)
                
                --Supprime les blocs qui doivent être supprimé
                table.remove(room.blocs[j], index)
            else
--                print("tu sens des pieds")
            end
        end
    end
    
    blocs.toDelete = {}
end

blocs.draw = function()--Dessine les blocs
    for j = #room.blocs, 1, -1 do
        for i, b in pairs(room.blocs[j]) do
            if b:onScreen() then
                
                --Change de couleur selon la couche
                if j == 1 then
                    lg.setColor(unpack(b.colors))
                else
                    lg.setColor(unpack(mergeColors(b.colors, blocs.layerColor[j])))
                end
                
                --Affichage du bloc
                if b.isLiquid then
                    
                    if b.cardinality[1] ~= 0 then
                        if b.cardinality[1] == b.id then
                            local x, y = blocs.getPos(b.coordX, b.coordY)
                            lg.rectangle("fill", x + wdow.shake.x, y + wdow.shake.y, b.wth, blocs.size)
                        elseif bloc[b.cardinality[1]].isLiquid then
                            
                            lg.rectangle("fill", b.x + wdow.shake.x, b.y + wdow.shake.y, b.wth, b.hgt)
                            
                            if j == 1 then
                                lg.setColor(unpack(bloc[b.cardinality[1]].colors))
                            else
                                lg.setColor(unpack(mergeColors(bloc[b.cardinality[1]].colors, blocs.layerColor[j])))
                            end
                            
                            lg.rectangle("fill", b.x + wdow.shake.x, b.y + wdow.shake.y - (blocs.size - b.hgt), b.wth, blocs.size - b.hgt)
                        else
                            lg.rectangle("fill", b.x + wdow.shake.x, b.y + wdow.shake.y, b.wth, b.hgt)
                        end
                    else
                        lg.rectangle("fill", b.x + wdow.shake.x, b.y + wdow.shake.y, b.wth, b.hgt)
                    end
                else
                    if b.imgLink then
                        lg.draw(src.img.bloc[b.img], src.img.bloc[b.img.."_"..table.concat(b.imgCardinality)], b.x + wdow.shake.x, b.y + wdow.shake.y)
                    else
                        lg.draw(src.img.bloc[b.img], b.x + wdow.shake.x, b.y + wdow.shake.y)
                    end
                end
                
                --[[Debug]]--
                if debug.visible then
                    local x, y = blocs.getPos(b.coordX, b.coordY)
                    
                    if b.isAwake then
                        lg.setColor(255, 0, 0, 80)
                        lg.rectangle("fill", x, y, blocs.size, blocs.size)
                    else
                        lg.setColor(0, 255, 0, 80)
                        lg.rectangle("fill", x, y, blocs.size, blocs.size)
                    end
                    
                    lg.setColor(unpack(debug.color))
                    lg.print("x" .. b.coordX .. " y" .. b.coordY , x, y)
                    lg.print("id:"..b.id, x, y + 10)
                    if b.timePass then
                        lg.print(string.format("%d ms", b.ttl), x, y + 20)
                    end
                    lg.print(table.concat(b.cardinality), x, y + 30)
                    if b.isLiquid then
                        lg.print(string.format("%.2f", b.fillingRate), x, y + 40)
                    end
                end
            end
        end
    end
end