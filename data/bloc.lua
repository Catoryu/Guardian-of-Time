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
    fillingRateMin = 0, --Minimum de % de remplissage pour pouvoir déverser
    refreshRate = 0.05,
    viscousRate = 25,
    density = 0,
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

    --Reset les valeurs du bloc
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
    
    moveX = function(self, moveSpeed)--Bouge le bloc horizontalement
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
    
    moveY = function(self, moveSpeed)--Bouge le bloc verticalement
        local canMove = true
        
        
        for i, b in pairs(room.blocs) do
            if b.x == self.x and b.y == self.y + moveSpeed then
                if b.density < self.density then
                    b.y = b.y - moveSpeed
                else
                    canMove = false
                end
            end
        end
        
        if canMove and self.y + moveSpeed <= room.rows then
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
    
    forceflow = function(self)
        --Haut, Bas, Gauche, Droite
        --0 : Bloqué
        --1 : Vide
        --2 : Liquide
        local canFlow = {0, 1, 1, 1}
        
        --Test où est-ce que le liquide peut couler--
        for i, v in pairs(room.blocs) do
            --Test si le bloc peut couler en bas
            if self.x == v.x and self.y + 1 == v.y then
                --Si c'est un liquide
                if v.isLiquid and v.fillingRate ~= 100 and v.density <= self.density then
                    canFlow[2] = 2
                else
                    canFlow[2] = 0
                end
            end
            
            --Test si le bloc peut couler à gauche
            if self.x - 1 == v.x and self.y == v.y then
                --Si c'est un liquide
                if v.isLiquid and v.fillingRate ~= 100 and v.density <= self.density then
                    canFlow[3] = 2
                else
                    canFlow[3] = 0
                end
            end
            
            --Test si le bloc peut couler à droite
            if self.x + 1 == v.x and self.y == v.y then
                --Si c'est un liquide
                if v.isLiquid and v.fillingRate ~= 100 and v.density <= self.density then
                    canFlow[4] = 2
                else
                    canFlow[4] = 0
                end
            end
        end
        
        --Vérifie que le liquide ne coule pas dans les bord de la salle
        if self.y + 1 > room.rows then canFlow[2] = 0 end--En bas
        
        if self.x - 1 < 1 then canFlow[3] = 0 end--A gauche
        
        if self.x + 1 > room.cols then canFlow[4] = 0 end--A droite
        
        --Fait couler le liquide--
        
        --Coule vers le bas libre
        if canFlow[2] ~= 0 then
            --Donne du liquide en bas
            self:spread(2, canFlow[2] - 1, self.fillingRate)
            
        elseif canFlow[3] ~= 0 and canFlow[4] ~= 0 then
            --Donne du liquide à gauche
            self:spread(3, canFlow[3] - 1, self.fillingRate/2, true)
            --Donne du liquide à droite
            self:spread(4, canFlow[4] - 1, self.fillingRate/2, true)
            
        --Coule vers la gauche
        elseif canFlow[3] ~= 0 then
            --Donne du liquide à gauche
            self:spread(3, canFlow[3] - 1, self.fillingRate, true)
            
        --Coule vers la droite
        elseif canFlow[4] ~= 0 then
            --Donne du liquide à droite
            self:spread(4, canFlow[4] - 1, self.fillingRate, true)
        end
    end,
    
    spread = function(self, direction, hasAlreadyBloc, quantity, forced)
        --hasAlreadyBloc :
        --0 : no
        --1 : yes
        
        if hasAlreadyBloc == 1 then
            if direction == 1 then--Haut
                
            elseif direction == 2 then--Bas
                for i, b in pairs(room.blocs) do
                    if b.x == self.x and b.y == self.y + 1 then
                        --Si c'est le même liquide
                        if self.id == b.id then
                            b.fillingRate = b.fillingRate + quantity
                            
                            if b.fillingRate > 100 then
                                quantity = b.fillingRate - 100
                                b.fillingRate = 100
                            else
                                quantity = 0
                            end
                            
                        --Sinon détermine le liquide le plus lourd
                        else
                            if self.density > b.density then
                                --Fait couler le liquide avec la plus petite densité
                                b:forceflow()
                                
                                --Déplace le bloc à supprimer dans un endroit invisible
                                b.x = -1
                                b.y = -1
                                
                                --Ajoute la position -1 -1 dans la table des blocs à supprimer
                                table.insert(blocs.toDelete, i)
                                
                                --Déplace le bloc liquide
                                self.y = self.y + 1
                            end
                        end
                    end
                end
            elseif direction == 3 then--Gauche
                for i, b in pairs(room.blocs) do
                    if b.x == self.x - 1 and b.y == self.y then
                        --Si c'est le même liquide
                        if self.id == b.id then
                            
                            --Si le liquide essaye de se verser dans un bloc qui a plus de liquide, annulle le déversement
                            if not forced and b.fillingRate > self.fillingRate then return quantity end
                            
                            b.fillingRate = b.fillingRate + quantity
                            
                            if b.fillingRate > 100 then
                                quantity = b.fillingRate - 100
                                b.fillingRate = 100
                            else
                                quantity = 0
                            end
                            
                        --Sinon détermine le liquide le plus lourd
                        else
                            if self.density > b.density then
                                --Fait couler le liquide avec la plus petite densité
                                b:forceflow()
                                
                                --Déplace le bloc à supprimer dans un endroit invisible
                                b.x = -1
                                b.y = -1
                                
                                --Ajoute la position -1 -1 dans la table des blocs à supprimer
                                table.insert(blocs.toDelete, i)
                                
                                --Crée un bloc liquide à la nou
                                blocs.push(bloc[self.id]:new({x = self.x - 1, y = self.y, fillingRate = quantity}))
                            end
                        end
                    end
                end
            elseif direction == 4 then--Droit
                for i, b in pairs(room.blocs) do
                    if b.x == self.x + 1 and b.y == self.y then
                        --Si c'est le même liquide
                        if self.id == b.id then
                            
                            --Si le liquide essaye de se verser dans un bloc qui a plus de liquide, annulle le déversement
                            if not forced and b.fillingRate > self.fillingRate then return quantity end
                            
                            b.fillingRate = b.fillingRate + quantity
                            
                            if b.fillingRate > 100 then
                                quantity = b.fillingRate - 100
                                b.fillingRate = 100
                            else
                                quantity = 0
                            end
                            
                        --Sinon détermine le liquide le plus lourd
                        else
                            if self.density > b.density then
                                --Fait couler le liquide avec la plus petite densité
                                b:forceflow()
                                
                                --Déplace le bloc à supprimer dans un endroit invisible
                                b.x = -1
                                b.y = -1
                                
                                --Ajoute la position -1 -1 dans la table des blocs à supprimer
                                table.insert(blocs.toDelete, i)
                                
                                --Crée un bloc liquide à la nou
                                blocs.push(bloc[self.id]:new({x = self.x + 1, y = self.y, fillingRate = quantity}))
                            end
                        end
                    end
                end
            end
        elseif hasAlreadyBloc == 0 then
            if direction == 1 then--Haut
                
            elseif direction == 2 then--Bas
                self.y = self.y + 1
            elseif direction == 3 then--Gauche
                --Test si le joueur est en contact
                
                --Crée le liquide
                blocs.push(bloc[self.id]:new({x = self.x - 1, y = self.y, fillingRate = quantity}))
                quantity = 0
            elseif direction == 4 then--Droit
                blocs.push(bloc[self.id]:new({x = self.x + 1, y = self.y, fillingRate = quantity}))
                quantity = 0
            end
        end
        
        --Retourne la quantité restante qui n'a pas pu être déversé
        return quantity
    end,
    
    flow = function(self)--Fait couler les blocs liquide
        --Haut, Bas, Gauche, Droite
        --0 : Bloqué
        --1 : Vide
        --2 : Liquide
        local canFlow = {0, 1, 1, 1}
        
        --Test où est-ce que le liquide peut couler--
        for i, v in pairs(room.blocs) do
            --Test si le bloc peut couler en bas
            if self.x == v.x and self.y + 1 == v.y then
                --Si c'est un liquide
                if v.isLiquid and v.fillingRate ~= 100 and v.density <= self.density then
                    canFlow[2] = 2
                else
                    canFlow[2] = 0
                end
            end
            
            --Test si le bloc peut couler à gauche
            if self.x - 1 == v.x and self.y == v.y then
                --Si c'est un liquide
                if v.isLiquid and v.fillingRate ~= 100 and v.density <= self.density then
                    canFlow[3] = 2
                else
                    canFlow[3] = 0
                end
            end
            
            --Test si le bloc peut couler à droite
            if self.x + 1 == v.x and self.y == v.y then
                --Si c'est un liquide
                if v.isLiquid and v.fillingRate ~= 100 and v.density <= self.density then
                    canFlow[4] = 2
                else
                    canFlow[4] = 0
                end
            end
        end
        
        --Vérifie que le liquide ne coule pas dans les bord de la salle
        if self.y + 1 > room.rows then canFlow[2] = 0 end--En bas
        
        if self.x - 1 < 1 then canFlow[3] = 0 end--A gauche
        
        if self.x + 1 > room.cols then canFlow[4] = 0 end--A droite
        
        --Fait couler le liquide--
        
        --Coule vers le bas libre
        if canFlow[2] ~= 0 then
            
            --Calcul du montant à donner
            local fillLoss = self.fillingRate
            local liquidNotspread = 0
            
            --Donne du liquide en bas
            liquidNotspread = self:spread(2, canFlow[2] - 1, fillLoss)
            
            --Vide son liquide
            self.fillingRate = self.fillingRate - fillLoss + liquidNotspread
            
        elseif canFlow[3] ~= 0 and canFlow[4] ~= 0 then
            
            --Si le bloc a assez de liquide, il le déverse
            if self.fillingRate > self.fillingRateMin then
                
                --Calcul du montant à donner
                local fillLoss = self.viscousRate * self.fillingRate / 100
                local liquidNotspread = 0
                
                --Donne du liquide à gauche
                liquidNotspread = liquidNotspread + self:spread(3, canFlow[3] - 1, fillLoss/2)
                
                --Donne du liquide à droite
                liquidNotspread = liquidNotspread + self:spread(4, canFlow[4] - 1, fillLoss/2)
                
                --Vide son liquide
                self.fillingRate = self.fillingRate - fillLoss + liquidNotspread
            end
            
        --Coule vers la gauche
        elseif canFlow[3] ~= 0 then
            --Si le bloc a assez de liquide, il le déverse
            if self.fillingRate > self.fillingRateMin then
                
                --Calcul du montant à donner
                local fillLoss = self.viscousRate * self.fillingRate / 100
                local liquidNotspread = 0
                
                --Donne du liquide à gauche
                liquidNotspread = liquidNotspread + self:spread(3, canFlow[3] - 1, fillLoss)
                
                --Vide son liquide
                self.fillingRate = self.fillingRate - fillLoss + liquidNotspread
            end
            
        --Coule vers la droite
        elseif canFlow[4] ~= 0 then
            --Si le bloc a assez de liquide, il le déverse
            if self.fillingRate > self.fillingRateMin then
                
                --Calcul du montant à donner
                local fillLoss = self.viscousRate * self.fillingRate / 100
                local liquidNotspread = 0
                
                --Donne du liquide à droite
                liquidNotspread = liquidNotspread + self:spread(4, canFlow[4] - 1, fillLoss)
                
                --Vide son liquide
                self.fillingRate = self.fillingRate - fillLoss + liquidNotspread
            end
        end
        
        --Si le bloc n'a plus de liquide, il disparaît
        if self.fillingRate <= 0 then blocs.pop(self.x, self.y) end
    end,
    
    onScreen = function(self)--Test si le bloc est visible a l'écran
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
        isSolid = true,
        density = 100
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
            blocs.pop(self.x, self.y)
            blocs.push(bloc[3]:new({x = self.x, y = self.y}))
        end,
        rawOnTouch = function(self, direction) if direction == 1 then self.isTimely = true end end,
        density = 100
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
            if collision_rectToRect(player.x, player.y, player.wth, player.hgt, x, y, blocs.size, blocs.size) == 0 then
                blocs.pop(self.x, self.y)
                blocs.push(bloc[2]:new({x = self.x, y = self.y}))
            end
        end,
        density = 100
    }),

    --WIP
    --Plateforme à sens unique (Uniquement collision du dessus)
    bloc_class:new({
        id = 4,
        name = "platform",
        img = "woodPlatform",
        density = 100
    }),

    bloc_class:new({
        id = 5,
        name = "water",
        viscousRate = 10,
        fillingRateMin = 5,
        colors = {51, 153, 255, 150},
        isLiquid = true,
        fillingRate = 100,
        density = 10
    }),

    bloc_class:new({
        id = 6,
        name = "sand",
        viscousRate = 10,
        fillingRateMin = 40,
        colors = {228, 206, 64, 255},
        isLiquid = true,
        isSolid = true,
        fillingRate = 100,
        density = 20
    }),

    bloc_class:new({
        id = 7,
        name = "sandBloc",
        img = "sand",
        isGravityAffected = true,
        imgLink = true,
        isSolid = true,
        density = 30
    })
}