--Paramètre du bruit du vent [temporaire]
src.sound.wind_l:setVolumeLimits(0.1, 0.5)
src.sound.wind_l:setVolume(0)
src.sound.wind_l:setLooping(true)

src.sound.wind_r:setVolumeLimits(0.1, 0.5)
src.sound.wind_r:setVolume(0)
src.sound.wind_r:setLooping(true)

dofile("data/weather.lua")

weathers = {}

weathers.wind = 0 --Définit la force du vent [px/s]
weathers.frame = 0 --Utilisé pour calculer le taux de rafraichissement du vent
weathers.id = 1 --Définit quel météo est utilisé actuellement
weathers.soft = false --Indique si il y a un changment de météo "smooth" en cours
weathers.softDurationBase = 0
weathers.softDuration = 0
weathers.soundRatio = 500

weathers.load = function()--Initialise la météo
    --Copie le set de météo choisi
    room.weather = table.deepcopy(weatherSet[weathers.id])
    
    --Table contenant toutes les fonctions des météos sélectionnées
    room.weather.list = {}
    
    for i = 1, #room.weather.weathers do
        if room.weather.list[i] == nil then
            for j = 1, i do
                if room.weather.list[j] == nil then
                    room.weather.list[j] = {}
                end
            end
        end
        
        room.weather.list[room.weather.weathers[i]] = table.deepcopy(weather[room.weather.weathers[i]])
        
        room.weather.list[room.weather.weathers[i]]:initialization()
    end
    
    weathers.soft = false
end

weathers.update = function(dt)--Actualise la météo
    weathers.updateWind(dt)
    
    for i, w in pairs(room.weather.list) do
        if w.update then
            w:update(dt)
        end
    end
    
    --Gère le changement de météo "smooth"
    if weathers.soft then
        if weathers.softDuration > 0 then
            weathers.softDuration = weathers.softDuration - 1000*dt
        else
            weathers.load()
        end
    end
end

weathers.updateWind = function(dt)
    if time > weathers.frame and weathers.id ~= 0 then
        weathers.frame = weathers.frame + room.weather.windRefreshCooldown/1000
        
        --Modifie la valeur du vent
        noise = love.math.noise(time)
        if math.floor(math.random()*10) % 2 == 0 then
            noise = - noise
        end
        weathers.wind = weathers.wind + noise * room.weather.windChangeForce
        
        --Limite la vitesse du vent
        if weathers.wind > room.weather.maxWindSpeed then
            weathers.wind = room.weather.maxWindSpeed
        elseif weathers.wind < -room.weather.maxWindSpeed then
            weathers.wind = -room.weather.maxWindSpeed
        end
        
        --Calcul le volume du vent à droite et à gauche
        if not mute then
            local left = weathers.wind / weathers.soundRatio
            local right = -left
            
            if right < 0 then right = 0 end
            if left < 0 then left = 0 end
            
            src.sound.wind_l:setVolume(left)
            src.sound.wind_r:setVolume(right)
        end
    end
end

weathers.softChange = function(id, duration)
    if duration == nil then duration = 10000 end
    
    weathers.soft = true
    weathers.softDuration = duration
    weathers.softDurationBase = duration
    weathers.id = id
end

weathers.draw = function()--Dessine la météo
    for i, w in pairs(room.weather.list) do
        if w.draw then
            w:draw()
        end
    end
end