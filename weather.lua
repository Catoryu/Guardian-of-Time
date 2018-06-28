--Table contenant toutes les informations concernant la météo
weather = {}

--Table contenant toutes les particules de la météo
weather.drops = {}

--Définit la météo actuelle
weather.id = 0

--Définit la force du vent WIP
weather.wind = 0

--Définit l''emplacement y ou les gouttes réapparaissent
weather.dropResetOffset = -100

--[[
0 : Rien
1 : Pluie
2 : Forte pluie
3 : Neigeux
4 : Brumeux
5 : Orage
]]--

weather.load = function()--Initiliase la météo
    --Réinitialise les particules de la météo
    weather.drops = {}
    
    --Rain
    if weather.id == 1 then
        --Trouve un nombre de gouttes d'eau idéale pour la taille de la salle
        dropNumber = (room.wth + room.hgt) / 10
        
        --Crée toutes les gouttes d'eau
        for i = 1, dropNumber do
            drop = {}
            
            drop.x = math.random(room.x, room.wth)
            drop.y = math.random(room.y, room.hgt)
            drop.wth = math.random(1, 2)
            drop.hgt = math.random(6, 13)
            drop.speed = drop.hgt * 100
            
            table.insert(weather.drops, drop)
        end
    --Heavy rain
    elseif weather.id == 2 then
        
    --Snow
    elseif weather.id == 3 then
        
    --Foggy
    elseif weather.id == 4 then
        
    --Thunder
    elseif weather.id == 5 then
        
    end
end

weather.update = function(dt)--Actualise la météo
    --Actualise le vent WIP
    noise = love.math.noise(time)
    weather.wind = weather.wind + noise*10
    weather.wind = - weather.wind
    
    --Rain
    if weather.id == 1 then
        for i, v in pairs (weather.drops) do
            
            --Fait avancer les gouttes d'eau
            v.y = v.y + v.speed*dt
            
            --Applique le vent à la goutte WIP
            --v.x = v.x + weather.wind
            
            --Test si la goutte d'eau sort de la salle
            if v.y > room.y + room.hgt then
                --Réinitialise la goutte
                v.wth = math.random(1, 2)
                v.hgt = math.random(5, 13)
                v.speed = v.hgt * 80
                v.x = math.random(room.x, room.wth)
                v.y = math.random(weather.dropResetOffset, room.y - v.hgt)
            end
        end
    --Heavy rain
    elseif weather.id == 2 then
        
    --Snow
    elseif weather.id == 3 then
        
    --Foggy
    elseif weather.id == 4 then
        
    --Thunder
    elseif weather.id == 5 then
        
    end
end

weather.draw = function()--Dessine la météo
    --Rain
    if weather.id == 1 then
        lg.setColor(122, 202, 247, 210)
        
        for i, v in pairs (weather.drops) do
            --Affiche la goutte d'eau uniquement si elle est dans le champ de vision du joueur
            if (v.x > 0 and v.x < wdow.wth) and
            (v.y > 0 and v.y < wdow.hgt)then
                lg.rectangle("fill", v.x, v.y, v.wth, v.hgt)
            end
        end
    --Heavy rain
    elseif weather.id == 2 then
        
    --Snow
    elseif weather.id == 3 then
        
    --Foggy
    elseif weather.id == 4 then
        
    --Thunder
    elseif weather.id == 5 then
        
    end
end