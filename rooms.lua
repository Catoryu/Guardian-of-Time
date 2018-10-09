--Table qui contient tous les fonctions concernant les rooms "salles"
rooms = {}

rooms.update = function(dt)--Actualisation de la salle
    blocs.update(dt)
    entities.update(dt)
    events.update(dt)
    weathers.update(dt)
end

rooms.draw = function()--Dessine tous les objets de la salle
    --Affiche l'image de fond
    bgrounds.draw(false)
    
    --Affiche les blocs
    blocs.draw()
    
    --Affiche les entitées
    entities.draw()
    
    --Affiche les événements (Debug)
    events.draw()
    
    --Affiche les animations immigrées
    animations.draw()
    
    --Affiche le joueur
    player.draw()
    
    --Affiche les parties de l'image de fond qui se retrouve devant
    bgrounds.draw(true)
    
    --Affiche la météo
    weathers.draw()
    
    --Affiche un filtre de couleur à la salle
    lg.setColor(unpack(room.colors))
    lg.rectangle("fill", 0, 0, wdow.wth, wdow.hgt)
end

local moveAllX = function(moveSpeed)--Déplace tous les objets de la salle (horizontalement)
    --Bouge la salle (donc les blocs avec)
    room.x = room.x + moveSpeed
    
    --Bouge le fond
    bgrounds.moveX(moveSpeed)
    
    --Bouge le joueur
    player.x = player.x + moveSpeed
    
    --Bouge les entités
    for i, e in pairs(room.entities) do
        e.x = e.x + moveSpeed
    end
    
    --Bouge les événements
    for i, e in pairs(chapter.events) do
        e.x = e.x + moveSpeed
    end
    
    --Bouge les particules de météo
    for i, w in pairs(room.weather.list) do
        if w.container then
            for j, p in pairs(w.container) do
                p.x = p.x + moveSpeed
            end
        end
    end
    
    --Bouge les animations
    for i, a in pairs(animations.container) do
        a.x = a.x + moveSpeed
    end
end

local moveAllY = function(moveSpeed)--Déplace tous les objets de la salle (verticalement)
    --Bouge la salle (donc les blocs avec)
    room.y = room.y + moveSpeed
    
    --Bouge le fond
    bgrounds.moveY(moveSpeed)
    
    --Bouge le joueur
    player.y = player.y + moveSpeed
    
    --Bouge les entités
    for i, e in pairs(room.entities) do
        e.y = e.y + moveSpeed
    end
    
    --Bouge les événements
    for i, e in pairs(chapter.events) do
        e.y = e.y + moveSpeed
    end
    
    --Bouge les particules de météo
    for i, w in pairs(room.weather.list) do
        if w.container then
            for j, p in pairs(w.container) do
                p.y = p.y + moveSpeed
            end
        end
    end
    
    --Bouge les animations
    for i, a in pairs(animations.container) do
        a.y = a.y + moveSpeed
    end
end

rooms.refreshCamera = function(x, y)--Recentre le centre de la fenêtre vers la coordoné donné en paramètre
    --Calcul la différence entre le point choisi et l'ancien
    local dx = wdow.wth/2 - x
    local dy = wdow.hgt/2 - y
    
    --Vérifie si les coordonés sont dans la salle
    if (x < room.x + wdow.wth/2 or x > room.x + room.wth - wdow.wth/2) then
        if x < wdow.wth/2 then
            dx = -room.x
        elseif x > wdow.wth/2 then
            dx = -(room.x + room.wth - wdow.wth)
        end
    end
    
    --Vérifie si les coordonés sont dans la salle
    if (y < room.y + wdow.hgt/2 or y > room.y + room.hgt - wdow.hgt/2) then
        if y < wdow.hgt/2 then
            dy = -room.y
        elseif y > wdow.hgt/2 then
            dy = -(room.y + room.hgt - wdow.hgt)
        end
    end
    
    --Bouge tous les éléments de la salle
    if dx ~= 0 then moveAllX(dx) end
    if dy ~= 0 then moveAllY(dy) end
end