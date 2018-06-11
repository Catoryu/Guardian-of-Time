--Class des cellule.
bloc_class = {
    id = 1,
    x = 0,
    y = 0,
    ttl = 0, --Durée de vie du bloc (valeur en ms)
    isVisible = true,
    isSolid = false,
    isDestructible = false,
    hp = 0,
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
        isSolid = true
    }),

    --Bloc qui se détruit au toucher (dessus)
    bloc_class:new({
        id = 2,
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
        isSolid = false,
        ttl = 5000,
        isTimely = true,
        activeEvent = {ttlReach = true, onTouch = false},
        rawOnTtlReached = function(self)
            --Test si le bloc n'est pas en collision avec le joueur
            x, y = room.getBlocPos(self.x, self.y)
            if collision_rectToRect(player.x, player.y, player.wth, player.hgt, x, y, room.blocSize, room.blocSize) == 0 then
                room.popBloc(self.x, self.y)
                room.pushBloc(bloc[2]:new({x = self.x, y = self.y}))
            end
        end
    }),

    --WIP
    --Plateforme à sens unique (Uniquement collision du dessus)
    bloc_class:new({
        id = 4
    })
}