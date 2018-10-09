--Liste des intempéries
weather = {
    {--Rien
        id = 1,
        container = {},
        initialization = function(self) end,
        update = function(self, dt) end,
        draw = function(self) end
    },

    {--Pluie
        id = 2,
        container = {},
        minThick = 1,
        maxThick = 2,
        minLenght = 5,
        maxLenght = 13,
        dropSpeedRatio = 100,
        density = 0.01,
        colors = {122, 202, 247, 210},
        disappearChance = 0,
        dropNumber = 70,
        maxFallTime = 0,
        resetOffsetX = 0,
        resetOffsetY = 10000,

        drop_class = {
            x = 0,
            y = 0,
            thick = 0,
            lenght = 0,
            speed = 0,

            reset = function(self, firstInitialization)
                local this = room.weather.list[2]

                if weathers.soft and not firstInitialization then
                    if weathers.softDuration < this.maxFallTime then return end
                end

                self.thick = math.random(this.minThick, this.maxThick)
                self.lenght = math.random(this.minLenght, this.maxLenght)
                self.speed = self.lenght * this.dropSpeedRatio

                if firstInitialization then
                    self.x = math.random(- this.resetOffsetX, wdow.wth + this.resetOffsetX)

                    --Si le chargement de la météo est doux, les gouttes apparaissent en haut de l'écran
                    if weathers.soft then
                        self.y = math.random(- this.resetOffsetY, -self.lenght)
                    else
                        self.y = math.random(0, wdow.hgt - self.lenght)
                    end
                else
                    self.x = math.random(- this.resetOffsetX, wdow.wth + this.resetOffsetX)
                    self.y = math.random(- self.lenght, - this.resetOffsetX)
                end
            end
        },

        initialization = function(self)
            newClass(self.drop_class)

            --Calcul l'endroit de la salle ou il faut rajouter des gouttes
            --(Sinon il se peut que des zones de la salle n'est pas de gouttes à cause du vent)
            self.resetOffsetX = wdow.hgt / (self.maxLenght * self.dropSpeedRatio) * room.weather.maxWindSpeed

            self.maxFallTime = (self.resetOffsetX + wdow.hgt) / (self.minLenght * self.dropSpeedRatio) * 1000

            --Crée toutes les particules
            for i = 1, self.dropNumber do
                local drop = self.drop_class:new()

                drop:reset(true)

                table.insert(self.container, drop)
            end
        end,

        update = function(self, dt)
            for i, d in pairs(self.container) do

                --Fait avancer les gouttes d'eau
                d.y = d.y + d.speed*dt

                --Applique le vent à la goutte
                d.x = d.x + weathers.wind*dt

                --Test si la goutte d'eau sort de la fenêtre
                if d.y > wdow.hgt then
                    if weathers.soft and chance(self.disappearChance) then
                        table.remove(self.container, i)
                    else
                        d:reset()
                    end
                end
            end

            --Calcul le pourcentage de chance qu'un goutte disparaisse (avec le changement de météo "smooth")
            self.disappearChance = 100 - (weathers.softDuration * 100 / weathers.softDurationBase)
        end,

        draw = function(self)
            lg.setColor(unpack(self.colors))

            for i, d in pairs (self.container) do
                lg.rectangle("fill", d.x + wdow.shake.x, d.y + wdow.shake.y, d.thick, d.lenght)
            end
        end
    },


    {--Neige
        id = 3,
        container = {},
        minThick = 4,
        maxThick = 6,
        minLenght = 4,
        maxLenght = 6,
        dropSpeedRatio = 50,
        dropNumber = 200,
        colors = {220, 242, 255, 190},
        disappearChance = 0,
        maxFallTime = 0,
        disappearChance = 0,
        resetOffsetX = 0,
        resetOffsetY = 4000,

        drop_class = {
            x = 0,
            y = 0,
            thick = 0,
            lenght = 0,
            speed = 0,

            reset = function(self, firstInitialization)
                local this = room.weather.list[3]

                if weathers.soft and not firstInitialization then
                    if weathers.softDuration < this.maxFallTime then return end
                end

                self.thick = math.random(this.minThick, this.maxThick)
                self.lenght = math.random(this.minLenght, this.maxLenght)
                self.speed = self.lenght * this.dropSpeedRatio

                if firstInitialization then
                    self.x = math.random(- this.resetOffsetX, wdow.wth + this.resetOffsetX)

                    --Si le chargement de la météo est doux, les gouttes apparaissent en haut de l'écran
                    if weathers.soft then
                        self.y = math.random(- this.resetOffsetY, -self.lenght)
                    else
                        self.y = math.random(0, wdow.hgt - self.lenght)
                    end
                else
                    self.x = math.random(- this.resetOffsetX, wdow.wth + this.resetOffsetX)
                    self.y = math.random(- self.lenght, - this.resetOffsetX)
                end
            end
        },

        initialization = function(self)
            newClass(self.drop_class)

            --Calcul l'endroit de la salle ou il faut rajouter des gouttes
            --(Sinon il se peut que des zones de la salle n'est pas de gouttes à cause du vent)
            self.resetOffsetX = wdow.hgt / (self.maxLenght * self.dropSpeedRatio) * room.weather.maxWindSpeed

            self.maxFallTime = (self.resetOffsetX + wdow.hgt) / (self.minLenght * self.dropSpeedRatio) * 1000

            --Crée toutes les particules
            for i = 1, self.dropNumber do
                local drop = self.drop_class:new()

                drop:reset(true)

                table.insert(self.container, drop)
            end
        end,

        update = function(self, dt)
            for i, d in pairs(self.container) do

                --Fait avancer les gouttes d'eau
                d.y = d.y + d.speed*dt

                --Applique le vent à la goutte
                d.x = d.x + weathers.wind*dt

                --Test si la goutte d'eau sort de la fenêtre
                if d.y > wdow.hgt then
                    if weathers.soft and chance(self.disappearChance) then
                        table.remove(self.container, i)
                    else
                        d:reset()
                    end
                end
            end

            --Calcul le pourcentage de chance qu'un goutte disparaisse (avec le changement de météo "smooth")
            self.disappearChance = 100 - (weathers.softDuration * 100 / weathers.softDurationBase)
        end,

        draw = function(self)
            lg.setColor(unpack(self.colors))

            for i, d in pairs (self.container) do
                lg.rectangle("fill", d.x + wdow.shake.x, d.y + wdow.shake.y, d.thick, d.lenght)
            end
        end
    },
    {--Forte pluie
        id = 4,
        container = {},
        minThick = 1,
        maxThick = 2,
        minLenght = 8,
        maxLenght = 15,
        dropSpeedRatio = 150,
        colors = {72, 152, 197, 210},
        disappearChance = 0,
        dropNumber = 250,
        maxFallTime = 0,
        resetOffsetX = 0,
        resetOffsetY = 30000,

        drop_class = {
            x = 0,
            y = 0,
            thick = 0,
            lenght = 0,
            speed = 0,

            reset = function(self, firstInitialization)
                local this = room.weather.list[4]

                if weathers.soft and not firstInitialization then
                    if weathers.softDuration < this.maxFallTime then return end
                end

                self.thick = math.random(this.minThick, this.maxThick)
                self.lenght = math.random(this.minLenght, this.maxLenght)
                self.speed = self.lenght * this.dropSpeedRatio

                if firstInitialization then
                    self.x = math.random(- this.resetOffsetX, wdow.wth + this.resetOffsetX)

                    --Si le chargement de la météo est doux, les gouttes apparaissent en haut de l'écran
                    if weathers.soft then
                        self.y = math.random(- this.resetOffsetY, -self.lenght)
                    else
                        self.y = math.random(0, wdow.hgt - self.lenght)
                    end
                else
                    self.x = math.random(- this.resetOffsetX, wdow.wth + this.resetOffsetX)
                    self.y = math.random(- self.lenght, - this.resetOffsetX)
                end
            end
        },

        initialization = function(self)
            newClass(self.drop_class)

            --Calcul l'endroit de la salle ou il faut rajouter des gouttes
            --(Sinon il se peut que des zones de la salle n'est pas de gouttes à cause du vent)
            self.resetOffsetX = wdow.hgt / (self.maxLenght * self.dropSpeedRatio) * room.weather.maxWindSpeed

            self.maxFallTime = (self.resetOffsetX + wdow.hgt) / (self.minLenght * self.dropSpeedRatio) * 1000

            --Crée toutes les particules
            for i = 1, self.dropNumber do
                local drop = self.drop_class:new()

                drop:reset(true)

                table.insert(self.container, drop)
            end
        end,

        update = function(self, dt)
            for i, d in pairs(self.container) do

                --Fait avancer les gouttes d'eau
                d.y = d.y + d.speed*dt

                --Applique le vent à la goutte
                d.x = d.x + weathers.wind*dt

                --Test si la goutte d'eau sort de la fenêtre
                if d.y > wdow.hgt then
                    if weathers.soft and chance(self.disappearChance) then
                        table.remove(self.container, i)
                    else
                        d:reset()
                    end
                end
            end

            --Calcul le pourcentage de chance qu'un goutte disparaisse (avec le changement de météo "smooth")
            self.disappearChance = 100 - (weathers.softDuration * 100 / weathers.softDurationBase)
        end,

        draw = function(self)
            lg.setColor(unpack(self.colors))

            for i, d in pairs (self.container) do
                lg.rectangle("fill", d.x + wdow.shake.x, d.y + wdow.shake.y, d.thick, d.lenght)
            end
        end
    },
    {--Brume sur tout l'écran
        id = 5,
        fogDensity = 0.8,
        softOffset = 400,
        container = {},

        fog_class = {
            x = 0,
            y = 0,
            spd = 0,
            image = "",
            sx = 0,
            sy = 0,
            alpha = 0,

            reset = function(self, isSoft, direction)
                local this = room.weather.list[5]

                self.image = "brumeRUI"
                self.sx = math.random(1, 1.5)
                self.sy = 1
                self.wth = src.img.misc[self.image]:getWidth() * self.sx
                self.hgt = src.img.misc[self.image]:getHeight() * self.sy
                self.spd = math.random(10, 30)
                self.alpha = math.random(40, 60)

                if isSoft then
                    if chance(50) then
                        self.x = math.random(-self.wth - this.softOffset, -self.wth)
                    else
                        self.spd = -self.spd
                        self.x = math.random(wdow.wth, wdow.wth + this.softOffset)
                    end
                else
                    self.x = math.random(-self.wth, wdow.wth)
                    if chance(50) then self.spd = -self.spd end
                end

                self.y = math.random(-self.hgt, wdow.hgt)
            end
        },

        initialization = function(self)
            newClass(self.fog_class)

            local fogNumber = self.fogDensity * (wdow.wth * wdow.hgt) / 10000

            for i = 0, fogNumber do
                local fogValues = self.fog_class:new()

                fogValues:reset(weathers.soft)

                table.insert(self.container, fogValues)
            end
        end,

        update = function(self, dt)

            --La météo change de façon douce
            if weathers.softDuration > 0 then
                for i, f in pairs(self.container) do

                    if f.x + f.wth/2 > wdow.wth/2 then
                        local spd = (wdow.wth - f.x) / (weathers.softDuration/1000)

                        f.x = f.x + spd * dt
                    else
                        local spd = (f.x + f.wth) / (weathers.softDuration/1000)

                        f.x = f.x - spd * dt
                    end
                end
            else
                for i, f in pairs(self.container) do
                    --Fait avancer la brume
                    f.x = f.x + f.spd*dt

                    --Fait un peu bouger la brume selon le vent
                    f.x = f.x + weathers.wind/20*dt

                    --Test si la brume sort de l'écran
                    if f.x > wdow.wth or f.x + f.wth < 0 then
                        f:reset(true)
                    elseif f.y + f.hgt < 0 then
                        f.y = wdow.hgt
                    elseif f.y > wdow.hgt then
                        f.y = -f.hgt
                    end
                end
            end
        end,

        draw = function(self)
            for i, f in pairs(self.container) do
                lg.setColor(255, 255, 255, f.alpha)

                lg.draw(src.img.misc[f.image], f.x + wdow.shake.x, f.y + wdow.shake.y, 0, f.sx, f.sy)
            end
        end
    },

    {--Brume sur le bas de la salle
        id = 6,
        fogDensity = 0.5,
        softOffset = 1000,
        fogHeight = 150,
        direction = true, --false = gauche, true = droite
        container = {},

        fog_class = {
            x = 0,
            y = 0,
            spd = 0,
            image = "",
            sx = 0,
            sy = 0,
            alpha = 0,

            moveX = function(self, dt)
                --Fait avancer la brume
                self.x = self.x + self.spd*dt

                --Fait un peu bouger la brume selon le vent
                self.x = self.x + weathers.wind/20*dt
            end,

            reset = function(self, isSoft, firstInitialization)

                local this = room.weather.list[6]

                self.image = "brumeRUI"
                self.sx = math.random(1, 1.5)
                self.sy = 1
                self.wth = src.img.misc[self.image]:getWidth() * self.sx
                self.hgt = src.img.misc[self.image]:getHeight() * self.sy
                self.spd = math.random(20, 30)
                if not this.direction then self.spd = -self.spd end
                self.alpha = math.random(40, 60)

                local min = room.y + room.hgt - this.fogHeight
                local max = room.y + room.hgt + this.fogHeight/2

                local y = math.random(min, max)

                if y > room.y + room.hgt then y = y - (y - (room.y + room.hgt))*2 end

                self.y = y

                if isSoft then
                    if firstInitialization then
                        if this.direction then
                            self.x = math.random(room.x - self.wth - room.wth, room.x - self.wth)
                        else
                            self.x = math.random(room.x + room.wth, room.x + room.wth + room.wth)
                        end
                    else
                        if this.direction then
                            self.x = room.x - self.wth
                        else
                            self.x = room.x + room.wth
                        end
                    end
                else
                    self.x = math.random(room.x - self.wth, room.x + room.wth)
                end
            end
        },

        initialization = function(self)
            newClass(self.fog_class)

            local fogNumber = self.fogDensity * (wdow.wth * wdow.hgt) / 10000

            for i = 0, fogNumber do
                local fogValues = self.fog_class:new()

                fogValues:reset(weathers.soft, true)

                table.insert(self.container, fogValues)
            end
        end,

        update = function(self, dt)

            --La météo change de façon douce
            if weathers.softDuration > 0 then
                --Fait disparaître la brume
                for i, f in pairs(self.container) do
                    f:moveX(dt)

                    local spd = (room.y + room.hgt - f.y) / (weathers.softDuration/1000)

                    f.y = f.y + spd * dt
                end
            else
                for i, f in pairs(self.container) do
                    f:moveX(dt)

                    --Test si la brume sort de l'écran
                    if self.direction then
                        if f.x > room.x + room.wth then f:reset(true) end
                    else
                        if f.x < room.x - f.wth then f:reset(true) end
                    end
                end
            end
        end,

        draw = function(self)
            for i, f in pairs(self.container) do
                lg.setColor(255, 255, 255, f.alpha)

                lg.draw(src.img.misc[f.image], f.x + wdow.shake.x, f.y + wdow.shake.y, 0, f.sx, f.sy)
            end
        end
    },

    {--Eclairs à l'arrache
        id = 7,
        appearChance = 50,
        appearRate = 200,
        image = "lightning",
        container = {},

        initialization = function(self) end,
        update = function(self, dt)

            if room.subWeather.appearRate <= 0 then
                room.subWeather.appearRate = 300
                if chance(room.subWeather.appearChance) then
                    local x, y, rotation = 0

                    x = math.random(-animation[room.subWeather.image].wth, wdow.wth)
                    y = math.random(-animation[room.subWeather.image].hgt, wdow.hgt)
                    rotation = math.rad(math.random(0, 360))

                    animations.create(animation[room.subWeather.image]:new({x = x, y = y, fps = 15, rotation = rotation}))
                end
            else
                room.subWeather.appearRate = room.subWeather.appearRate - 1000*dt
            end
        end,
        draw = function(self) end
    },
    {--Blizzard
        id = 8,
        container = {},
        minThick = 4,
        maxThick = 6,
        minLenght = 4,
        maxLenght = 6,
        dropSpeedRatio = 50,
        dropNumber = 5000,
        direction = true,
        colors = {220, 242, 255, 190},
        --colors = { 220, 192, 0, 190},
        disappearChance = 0,
        maxFallTime = 0,
        disappearChance = 0,
        resetOffsetX = 100,
        resetOffsetY = 4000,

        drop_class = {
            x = 0,
            y = 0,
            thick = 0,
            lenght = 0,
            speed = 0,

            reset = function(self, firstInitialization)
                local this = room.weather.list[8]

                if weathers.soft and not firstInitialization then
                    if weathers.softDuration < this.maxFallTime then return end
                end

                self.thick = math.random(this.minThick, this.maxThick)
                self.lenght = math.random(this.minLenght, this.maxLenght)
                self.speed = self.lenght * this.dropSpeedRatio

                if firstInitialization then
                    self.x = math.random(- this.resetOffsetX, wdow.wth + this.resetOffsetX)

                    --Si le chargement de la météo est doux, les gouttes apparaissent en haut de l'écran
                    if weathers.soft then
                        self.y = math.random(- this.resetOffsetY, -self.lenght)
                    else
                        self.y = math.random(0, wdow.hgt - self.lenght)
                    end
                else
                    self.x = math.random(- this.resetOffsetX, wdow.wth + this.resetOffsetX)
                    self.y = math.random(- self.lenght, wdow.hgt)
                end
            end
        },

        initialization = function(self)
            newClass(self.drop_class)

            --Calcul l'endroit de la salle ou il faut rajouter des gouttes
            --(Sinon il se peut que des zones de la salle n'est pas de gouttes à cause du vent)
            --self.resetOffsetX = wdow.hgt / (self.maxLenght * self.dropSpeedRatio) * room.weather.maxWindSpeed

            --self.maxFallTime = (self.resetOffsetX + wdow.hgt) / (self.minLenght * self.dropSpeedRatio) * 1000

            --Crée toutes les particules
            for i = 1, self.dropNumber do
                local drop = self.drop_class:new()

                drop:reset(true)

                table.insert(self.container, drop)
            end
        end,

        update = function(self, dt)
            for i, d in pairs(self.container) do

                --Fait avancer les gouttes d'eau
                d.y = d.y + d.speed*dt

                --Applique le vent (artificiel) à la goutte
                if direction then
                    d.x = d.x + 1500*dt
                else
                    d.x = d.x - 1500*dt
                end

                --Test si la goutte d'eau sort de la fenêtre
                if d.y > wdow.hgt then
                    if weathers.soft and chance(self.disappearChance) then
                        table.remove(self.container, i)
                    else
                        d:reset()
                    end
                end
            end

            --Calcul le pourcentage de chance qu'un goutte disparaisse (avec le changement de météo "smooth")
            self.disappearChance = 100 - (weathers.softDuration * 100 / weathers.softDurationBase)
        end,

        draw = function(self)
            lg.setColor(unpack(self.colors))

            for i, d in pairs (self.container) do
                lg.rectangle("fill", d.x + wdow.shake.x, d.y + wdow.shake.y, d.thick, d.lenght)
            end
        end
    },
}

--Table contenant toutes les météos
weatherSet = {
    {--Rien
        windRefreshCooldown = 100,
        maxWindSpeed = 300,
        windChangeForce = 15,
        weathers = {1}
    },

    {--Pluie
        windRefreshCooldown = 100,
        maxWindSpeed = 300,
        windChangeForce = 15,
        weathers = {2}
    },

    {--Neige
        windRefreshCooldown = 100,
        maxWindSpeed = 300,
        windChangeForce = 15,
        weathers = {3}
    },

    {--Forte pluie
        windRefreshCooldown = 100,
        maxWindSpeed = 300,
        windChangeForce = 15,
        weathers = {4}
    },

    {--Brume sur tout l'écran + pluie
        windRefreshCooldown = 100,
        maxWindSpeed = 300,
        windChangeForce = 15,
        weathers = {5, 2}
    },
    {--Brume sur le bas de la salle
        windRefreshCooldown = 100,
        maxWindSpeed = 300,
        windChangeForce = 15,
        weathers = {6}
    },
    {--Blizzard
        windRefreshCooldown = 1000,
        maxWindSpeed = 0,
        windChangeForce = 0,
        weathers = {8}
    }
}
