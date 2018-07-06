--Table qui contient tous les fonctions concernant les rooms "salles"
rooms = {}

rooms.update = function(dt)--Actualisation de la salle
    blocs.update(dt)
    entities.update(dt)
    events.update(dt)
    weathers.update(dt)
end

rooms.draw = function()--Dessine tous les objets de la salle
    --Affiche le filtre de la salle
    lg.setColor(unpack(room.filter))
    
    --Affiche l'image de fond
    lg.draw(src.img.bground["c"..chapterNumber.."r"..chapter.roomNumber], room.x, room.y)
    
    --Affiche les blocs
    blocs.draw()
    
    --Affiche les entitées
    entities.draw()
    
    --Affiche les événements (Debug)
    events.draw()
end

local moveAllX = function(moveSpeed)--Déplace tous les objets de la salle (horizontalement)
    --Bouge la salle (donc les blocs avec)
    room.x = room.x + moveSpeed
    
    --Bouge le joueur
    player.x = player.x + moveSpeed
    
    --Bouge les entités
    for i, e in pairs(room.entities) do
        e.x = e.x + moveSpeed
    end
    
    --Bouge les événements
    for i, v in pairs(chapter.events) do
        v.x = v.x + moveSpeed
    end
    
    --Bouge les particules de météo
    for i, v in pairs(weathers.drops) do
        v.x = v.x + moveSpeed
    end
end

local moveAllY = function(moveSpeed)--Déplace tous les objets de la salle (verticalement)
    --Bouge la salle (donc les blocs avec)
    room.y = room.y + moveSpeed
    
    --Bouge le joueur
    player.y = player.y + moveSpeed
    
    --Bouge les entités
    for i, e in pairs(room.entities) do
        e.y = e.y + moveSpeed
    end
    
    --Bouge les événements
    for i, v in pairs(chapter.events) do
        v.y = v.y + moveSpeed
    end
    
    --Bouge les particules de météo
    for i, v in pairs(weathers.drops) do
        v.y = v.y + moveSpeed
    end
end

--Recentre le centre de la fenêtre vers la coordoné donné en paramètre
rooms.refreshCamera = function(x, y)
    
    --Calcul la différence entre le point choisi et l'ancien
    local dx = wdow.wth/2 - x
    local dy = wdow.hgt/2 - y
    
    --Vérifie si les coordonés sont dans la salle
    if (x < room.x + wdow.wth/2 or x > room.x + room.wth - wdow.wth/2) then
        dx = 0
    end
    
    --Vérifie si les coordonés sont dans la salle
    if (y < room.y + wdow.hgt/2 or y > room.y + room.hgt - wdow.hgt/2) then
        dy = 0
    end
    
    --Bouge tous les éléments de la salle
    moveAllX(dx)
    moveAllY(dy)
end