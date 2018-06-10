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

    --Evénement lorsque le temps est plus petit que 0
    onTtlReached = function(self) end,

    --Evénement lorsque le bloc est touché (par le joueur)
    --[[
    1 : Haut
    2 : Bas
    3 : Gauche
    4 : Droit
    ]]
    onTouch = function(self, direction) end,
    
    --Transforme le bloc en bloc de vide
    setVoid = function(self)
        self.id = 1
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
        onTtlReached = function(self) end
        onTouch = function(self, direction) end
        
        --Supression du bloc de la table contenant tous les blocs non vide (car le bloc se transforme en vide)
        for i, v in pairs(room.updateBlocs) do
            if v.x == self.x and v.y == self.y then
                table.remove(room.updateBlocs, i)
            end
        end
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
    --Bloc vide
    bloc_class:new({
        id = 1
    }),

    --Bloc solide classique
    bloc_class:new({
        id = 2,
        isSolid = true
    }),

    --Bloc qui se détruit au toucher (dessus)
    bloc_class:new({
        id = 3,
        activeEvent = {ttlReach = true, onTouch = true},
        isSolid = true,
        ttl = 1000,
        onTtlReached = function(self) self:setVoid() end,
        onTouch = function(self, direction) if direction == 1 then self.isTimely = true end end
    }),
    
    --WIP
    --Plateforme à sens unique (Uniquement collision du dessus)
    bloc_class:new({
        id = 4
    })
}