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
    
    --Calcul l'endroit de la salle ou il faut rajouter des gouttes
    --(Sinon il se peut que des zones de la salle n'est pas de gouttes à cause du vent)
    weathers.dropResetOffset = wdow.hgt / (weathers.maxLenght * weathers.dropSpeedRatio) * weathers.maxWindSpeed
    
    --Réinitialise les particules de la météo
    weathers.drops = {}
    
    --Trouve un nombre de particules idéale pour la taille de la salle
    dropNumber = weathers.density * (room.wth * room.hgt) / 100
    
    --Crée toutes les particules
    for i = 1, dropNumber do
        drop = {}
        
        drop.reset = function(self)
            self.thick = math.random(1, 2)
            self.lenght = math.random(weathers.minLenght, weathers.maxLenght)
            self.speed = self.lenght * weathers.dropSpeedRatio
            self.x = math.random(- weathers.dropResetOffset, wdow.wth + weathers.dropResetOffset)
            
            self.y = - self.lenght - weathers.dropResetOffset
        end
        
        drop.thick = math.random(weathers.minThick, weathers.maxThick)
        drop.lenght = math.random(weathers.minLenght, weathers.maxLenght)
        drop.speed = drop.lenght * weathers.dropSpeedRatio
        drop.x = math.random(- weathers.dropResetOffset, wdow.wth + weathers.dropResetOffset)
        drop.y = math.random(- weathers.dropResetOffset, wdow.hgt - drop.lenght)
        
        table.insert(weathers.drops, drop)
    end
end

weathers.update = function(dt)--Actualise la météo
    --Actualise le vent
    if time > weathers.frame then
        weathers.frame = weathers.frame + weathers.windRefreshCooldown
        
        --Modifie la valeur du vent
        noise = love.math.noise(time)
        if math.floor(math.random()*10) % 2 == 0 then
            noise = - noise
        end
        weathers.wind = weathers.wind + noise*50
        
        --Limite la vitesse du vent
        if weathers.wind > weathers.maxWindSpeed then
            weathers.wind = weathers.maxWindSpeed
        elseif weathers.wind < -weathers.maxWindSpeed then
            weathers.wind = -weathers.maxWindSpeed
        end
    end
    
    for i, v in pairs (weathers.drops) do
        --Fait avancer les gouttes d'eau
        v.y = v.y + v.speed*dt
        
        --Applique le vent à la goutte
        v.x = v.x + weathers.wind*dt
        
        --Test si la goutte d'eau sort de la fenêtre
        if v.y > wdow.hgt then
            --Réinitialise la goutte
            v:reset()
        end
    end
end

weathers.draw = function()--Dessine la météo
    lg.setColor(unpack(weathers.colors))
    
    for i, v in pairs (weathers.drops) do
        lg.rectangle("fill", v.x, v.y, v.thick, v.lenght)
    end
end