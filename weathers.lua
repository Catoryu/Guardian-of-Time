--Paramètre du bruit du vent [temporaire]
src.sound.wind_l:setVolumeLimits(0.1, 0.5)
src.sound.wind_l:setVolume(0)
src.sound.wind_l:setLooping(true)

src.sound.wind_r:setVolumeLimits(0.1, 0.5)
src.sound.wind_r:setVolume(0)
src.sound.wind_r:setLooping(true)

dofile("data/weather.lua")

weathers = {}

--Contient toutes les particules de la météo
weathers.drops = {}

--Définit la force du vent [px/s]
weathers.wind = 0

--Utilisé pour calculer le taux de rafraichissement du vent
weathers.frame = 0

--Définit quel météo est utilisé actuellement
weathers.id = 0

weathers.windRefreshCooldown = 0
weathers.maxWindSpeed = 0
weathers.minThick = 0
weathers.maxThick = 0
weathers.minLenght = 0
weathers.maxLenght = 0
weathers.dropSpeedRatio = 0
weathers.density = 0
weathers.colors = {0, 0, 0}
weathers.soft = false
weathers.softDurationBase = 0
weathers.softDuration = 0
weathers.soundRatio = 500

weathers.load = function()--Initialise la météo
    
    --Enlève la météo
    if weathers.id == 0 then
        --Réinitialise les particules de la météo
        weathers.drops = {}
        return
    end
    
    --Modifie les valeurs selon l'id de la météo
    weathers.windRefreshCooldown = weather[weathers.id].windRefreshCooldown
    weathers.maxWindSpeed = weather[weathers.id].maxWindSpeed
    weathers.minThick = weather[weathers.id].minThick
    weathers.maxThick = weather[weathers.id].maxThick
    weathers.minLenght = weather[weathers.id].minLenght
    weathers.maxLenght = weather[weathers.id].maxLenght
    weathers.dropSpeedRatio = weather[weathers.id].dropSpeedRatio
    weathers.density = weather[weathers.id].density
    weathers.colors = weather[weathers.id].colors
    weathers.windChangeForce = weather[weathers.id].windChangeForce
    
    --Calcul l'endroit de la salle ou il faut rajouter des gouttes
    --(Sinon il se peut que des zones de la salle n'est pas de gouttes à cause du vent)
    weathers.dropResetOffset = wdow.hgt / (weathers.maxLenght * weathers.dropSpeedRatio) * weathers.maxWindSpeed
    
    --Réinitialise les particules de la météo
    weathers.drops = {}
    
    --Trouve un nombre de particules idéale
    dropNumber = weathers.density * (wdow.wth * wdow.hgt) / 100
    
    --Crée toutes les particules
    for i = 1, dropNumber do
        drop = {}
        
        drop.reset = function(self)
            self.thick = math.random(weathers.minThick, weathers.maxThick)
            self.lenght = math.random(weathers.minLenght, weathers.maxLenght)
            self.speed = self.lenght * weathers.dropSpeedRatio
            self.x = math.random(- weathers.dropResetOffset, wdow.wth + weathers.dropResetOffset)
            self.y = - self.lenght
        end
        
        drop.thick = math.random(weathers.minThick, weathers.maxThick)
        drop.lenght = math.random(weathers.minLenght, weathers.maxLenght)
        drop.speed = drop.lenght * weathers.dropSpeedRatio
        drop.x = math.random(- weathers.dropResetOffset, wdow.wth + weathers.dropResetOffset)
        
        --Si le chargement de la météo est doux, les gouttes apparaissent en haut de l'écran
        if weathers.soft then
            drop.y = math.random(- weathers.dropResetOffset - wdow.hgt*(weathers.dropSpeedRatio/10), -drop.lenght)
        else
            drop.y = math.random(- weathers.dropResetOffset, wdow.hgt - drop.lenght)
        end
        
        table.insert(weathers.drops, drop)
    end
    
    weathers.soft = false
end

weathers.update = function(dt)--Actualise la météo
    weathers.updateWind(dt)
    
    --Gère le changement de météo "smooth"
    if weathers.soft then
        if weathers.softDuration > 0 then
            weathers.softDuration = weathers.softDuration - 1000*dt
            
            if weathers.softDuration < 0 then weathers.softDuration = 0 end
        end
        
        --Calcul le pourcentage de chance qu'un goutte disparaisse (avec le changement de météo "smooth")
        disappearChance = 100 - (weathers.softDuration * 100 / weathers.softDurationBase)
    end
    
    weathers.updateDrops(dt)
end

weathers.updateWind = function(dt)
    if time > weathers.frame and weathers.id ~= 0 then
        weathers.frame = weathers.frame + weathers.windRefreshCooldown/1000
        
        --Modifie la valeur du vent
        noise = love.math.noise(time)
        if math.floor(math.random()*10) % 2 == 0 then
            noise = - noise
        end
        weathers.wind = weathers.wind + noise * weathers.windChangeForce
        
        --Limite la vitesse du vent
        if weathers.wind > weathers.maxWindSpeed then
            weathers.wind = weathers.maxWindSpeed
        elseif weathers.wind < -weathers.maxWindSpeed then
            weathers.wind = -weathers.maxWindSpeed
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

weathers.updateDrops = function(dt)
    for i, d in pairs(weathers.drops) do
        --Fait avancer les gouttes d'eau
        d.y = d.y + d.speed*dt
        
        --Applique le vent à la goutte
        d.x = d.x + weathers.wind*dt
        
        --Test si la goutte d'eau sort de la fenêtre
        if d.y > wdow.hgt then
            if weathers.soft and chance(disappearChance) then
                table.remove(weathers.drops, i)
                
                if #weathers.drops == 1 then
                    weathers.load()
                end
            else
                d:reset()
            end
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
    lg.setColor(unpack(weathers.colors))
    
    for i, v in pairs (weathers.drops) do
        lg.rectangle("fill", v.x + wdow.shake.x, v.y + wdow.shake.y, v.thick, v.lenght)
    end
end