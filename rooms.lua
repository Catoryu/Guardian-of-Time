--Table qui contient tous les fonctions concernant les rooms "salles"
rooms = {}

rooms.update = function(dt)--Actualisation de la salle
    blocs.update(dt)
    entities.update(dt)
    events.update(dt)
end

rooms.draw = function()--Dessine tous les objets de la salle
    --Affiche l'image de fond
    lg.setColor(255, 255, 255)
    lg.draw(src.img.bground["c"..chapterNumber.."r"..chapter.roomNumber], room.x, room.y)
    
    --Affiche les blocs
    blocs.draw()
    
    --Affiche les entitées
    entities.draw()
    
    --Affiche les événements (Debug)
    events.draw()
end

rooms.moveCameraX = function(moveSpeed)--Mouvement horizontal de la caméra
    local deltaX = 0

    --Marge d'erreur mouvement de la salle
    if room.x + moveSpeed > 0 then
        deltaX = room.x
        room.x = room.x - deltaX
        for i, e in pairs(room.entities) do
            e.x = e.x - deltaX
        end
        player.x = player.x - deltaX
        return
    elseif room.x + room.wth + moveSpeed < wdow.wth then
        deltaX = room.x + room.wth - wdow.wth
        room.x = room.x - deltaX
        for i, e in pairs(room.entities) do
            e.x = e.x - deltaX
        end
        player.x = player.x - deltaX
        return
    end

    --Bouge les entités
    for i, e in pairs(room.entities) do
        e.x = e.x + moveSpeed
    end
    
    --Bouge les événements
    for i, v in pairs(chapter.events) do
        v.x = v.x + moveSpeed
    end
    
    --Bouge la salle (donc les blocs avec)
    room.x = room.x + moveSpeed
end

rooms.moveCameraY = function(moveSpeed)--Mouvement vertical de la caméra
    local deltaY = 0

    --Marge d'erreur mouvement de la salle
    if room.y + moveSpeed > 0 then
        deltaY = room.y
        room.y = room.y - deltaY
        for i, c in pairs(room.entities) do
            c.y = c.y - deltaY
        end
        player.y = player.y - deltaY
        return
    elseif room.y + room.hgt + moveSpeed < wdow.hgt then
        deltaY = room.y + room.hgt - wdow.hgt
        room.y = room.y - deltaY
        for i, c in pairs(room.entities) do
            c.y = c.y - deltaY
        end
        player.y = player.y - deltaY
        return
    end

    --Bouge les entités
    for i, e in pairs(room.entities) do
        e.y = e.y + moveSpeed
    end
    
    --Bouge les événements
    for i, v in pairs(chapter.events) do
        v.y = v.y + moveSpeed
    end

    --Bouge la salle (donc les blocs avec)
    room.y = room.y + moveSpeed
end