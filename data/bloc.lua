--Class des blocs
bloc_class = {
    id = 1,
    x = 0,
    y = 0,
    ttl = 0, --Durée de vie du bloc (valeur en ms)
    isVisible = true,
    isSolid = false,
    isLiquid = false,
    isDestructible = false,
    isGravityAffected = false,
    fillingRate = 0,
    refreshRate = 0.05,
    frame = 0,
    hp = 0,
    img = "",
    imgCardinality = {}, --Permet de définir si le bloc a plusieurs images
    imgLink = false,
    isTimely = false, --Meilleur nom ? : Indique si le bloc est affecté par le temps
    activeEvent = { --Indique les événements actifs du bloc
        ttlReach = false,
        touch = false,
    },
    rawOnTtlReached = function(self) end,
    rawOnTouch = function(self) end,

    --Evénement lorsque son temps est plus petit que 0
    onTtlReached = function(self)
        self:rawOnTtlReached()
    end,

    --Evénement lorsque le bloc est touché (par le joueur)
    onTouch = function(self, direction)
        --[[
        1 : Haut
        2 : Bas
        3 : Gauche
        4 : Droit
        ]]
        self:rawOnTouch(direction)
    end,

    --Défini la fonction utilisé lorsque le temps du bloc est plus petit que 0
    setOnTtlReached = function(self, func)
        self.rawOnTtlReached = func
        self.activeEvent.ttlReach = true
    end,

    --Défini la fonction utilisé lorsque le bloc est touché (par le joueur)
    setOnTouch = function(self, func)
        self.rawOnTouch = func
        self.activeEvent.touch = true
    end,

    destroy = function(self)
        self = nil
    end,

    --reset les valeurs du bloc
    reset = function(self)
        self.ttl = 0
        self.isVisible = true
        self.isSolid = false
        self.isDestructible = false
        self.hp = 0
        self.isTimely = false
        self.activeEvent = {
            ttlReach = false,
            touch = false
        }
        rawOnTtlReached = function(self) end
        rawOnTouch = function(self, direction) end
    end,

    --Reset le bloc avec ses valeurs de base (Utile lorsqu'on change d'écran)
    setBaseValues = function(self)
        for k, _ in pairs(self) do self[k] = nil end
    end,
    
    moveX = function(self, moveSpeed)
        local canMove = false
        
        if self.x + moveSpeed <= room.cols and not blocs.exists(self.x + moveSpeed, self.y) then
            canMove = true
        end
        
        if canMove then
            x, y = blocs.getPos(self.x + moveSpeed, self.y)
            
            --Test si le bloc touche le joueur
            if collision_rectToRect(player.x, player.y, player.wth, player.hgt, x, y, blocs.size, blocs.size) ~= 0 then
                print("Le joueur est ecrase par \""..self.name.."\" , ce bloc se deplacait de "..moveSpeed.." case[s] horizontalement")
                return
            end
            
            --Actualise les cardinalités des blocs autour
            blocs.calculateCardinality(self, true)
            
            --Fait bouger le bloc
            self.x = self.x + moveSpeed
            
            --Actualise les cardinalités du bloc
            self = blocs.calculateCardinality(self)
        end
    end,
    
    moveY = function(self, moveSpeed)
        local canMove = false
        
        if self.y + moveSpeed <= room.rows and not blocs.exists(self.x, self.y + moveSpeed) then
            canMove = true
        end
        
        if canMove then
            x, y = blocs.getPos(self.x, self.y + moveSpeed)
            
            --Test si le bloc touche le joueur
            if collision_rectToRect(player.x, player.y, player.wth, player.hgt, x, y, blocs.size, blocs.size) ~= 0 then
                print("Le joueur est ecrase par \""..self.name.."\" , ce bloc se deplacait de "..moveSpeed.." case[s] verticalement")
                return
            end
            
            --Actualise les cardinalités des blocs autour
            blocs.calculateCardinality(self, true)
            
            --Fait bouger le bloc
            self.y = self.y + moveSpeed
            
            --Actualise les cardinalités du bloc
            self = blocs.calculateCardinality(self)
        end
    end,
    
    flow = function(self)
        local canFlow = {false, true, false, false}
        
        for i, v in pairs(room.blocs) do
            --Vérifie les blocs autour--
            
            --Si il y a un bloc vers le bas ou que l'on touche le bas de la salle
            if (self.x == v.x and self.y + 1 == v.y) or self.y + 1 > room.rows then
                canFlow[2] = false
            end
            
            --Si il n'y a pas de bloc là où le liquide veut couler
            --if self.x + 1 <= room.cols and not blocs.exists(self.x, self.y) then
                
            --end
        end
        
        if canFlow[2] then
            --Coule l'entièreté du liquide vers le bas
            self.y = self.y + 1
        end
    end,
    
    onScreen = function(self)
        local x, y = blocs.getPos(self.x, self.y)
        
        if (x + blocs.size > 0 and x - blocs.size < wdow.wth) and
        (y + blocs.size > 0 and y - blocs.size < wdow.hgt) then
            return true
        else
            return false
        end
    end
}

--Un peu de magie dans ce monde de brutes
setmetatable(bloc_class, {__index = bloc_class})

--Permet de créer un objet en utilisant une classe
function bloc_class:new (t)
    t = t or {} --Crée une table si l'utilisateur n'en passe pas dans la fonction
    setmetatable(t, self)
    self.__index = self
    return t
end

bloc = {
    --Bloc solide classique
    bloc_class:new({
        id = 1,
        name = "solid",
        img = "stone",
        imgLink = true,
        isSolid = true
    }),

    --Bloc qui se détruit au toucher (dessus)
    bloc_class:new({
        id = 2,
        name = "disappears when touched",
        img = "instable",
        activeEvent = {ttlReach = true, onTouch = true},
        isSolid = true,
        ttl = 1000,
        rawOnTtlReached = function(self)
            print("\nRemplacement x :"..self.x.." y :"..self.y)
            room.popBloc(self.x, self.y)
            room.pushBloc(bloc[3]:new({x = self.x, y = self.y}))
        end,
        rawOnTouch = function(self, direction) if direction == 1 then self.isTimely = true end end
    }),

    --Bloc qui apparait au bout d'un certain temps
    bloc_class:new({
        id = 3,
        name = "appears with time",
        img = "instable2",
        ttl = 5000,
        isTimely = true,
        activeEvent = {ttlReach = true, onTouch = false},
        rawOnTtlReached = function(self)
            --Test si le bloc n'est pas en collision avec le joueur
            x, y = blocs.getPos(self.x, self.y)
            if collision_rectToRect(player.x, player.y, player.wth, player.hgt, x, y, room.blocSize, room.blocSize) == 0 then
                room.popBloc(self.x, self.y)
                room.pushBloc(bloc[2]:new({x = self.x, y = self.y}))
            end
        end
    }),

    --WIP
    --Plateforme à sens unique (Uniquement collision du dessus)
    bloc_class:new({
        id = 4,
        name = "platform",
        img = "woodPlatform"
    }),

    bloc_class:new({
        id = 5,
        name = "water",
        colors = {51, 153, 255, 150},
        refreshRate = 1,
        isLiquid = true,
        fillingRate = 100,
    }),

    bloc_class:new({
        id = 6,
        name = "sand",
        colors = {228, 206, 64, 255},
        refreshRate = .2,
        isLiquid = true,
        fillingRate = 100,
    }),

    bloc_class:new({
        id = 7,
        name = "sandBloc",
        img = "sand",
        isGravityAffected = true,
        imgLink = true,
        isSolid = true
    })
}