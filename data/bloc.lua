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
    timePass = false, --Indique si le bloc est affecté par le temps
    layer = 1, --Permet de définir si le bloque est devant ou derrière
    colors = {255, 255, 255, 255},
    
    --Définit quel fonction sont activé
    ttlReach = false,
    touch = false,
    
    onTtlReach = function(self) end, --Définit les instructions si l'événement est déclenché par le temps
    onTouch = function(self, direction) end, --Définit les instructions si l'événement est déclenché par un contact avec le joueur

    setOnTtlReached = function(self, func)--Défini la fonction utilisé lorsque le temps du bloc est plus petit que 0
        self.rawOnTtlReached = func
        self.activeEvent.ttlReach = true
    end,

    setOnTouch = function(self, func)    --Défini la fonction utilisé lorsque le bloc est touché (par le joueur)
        self.rawOnTouch = func
        self.activeEvent.touch = true
    end,

    reset = function(self)--Reset les valeurs du bloc
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

    setBaseValues = function(self)--Reset le bloc avec ses valeurs de base (Utile lorsqu'on change d'écran)
        for k, _ in pairs(self) do self[k] = nil end
    end,
    
    moveX = function(self, moveSpeed)--Bouge le bloc horizontalement
        local canMove = true
        
        local x, y = blocs.getPos(self.x + moveSpeed, self.y)
        
        --Colision bords de la fenêtre
        if moveSpeed < 0 then
            --Collision haut de la fenêtre
            if self.x + moveSpeed < 1 then
                self.x = 1
                canMove = false
            end
        elseif moveSpeed > 0 then
            --Collision bas de la fenêtre
            if self.x + moveSpeed > room.cols then
                self.x = room.cols
                canMove = false
            end
        end
        
        if self.isSolid and self.layer == 1 then
            
            --Collision joueur
            if self.isLiquid then
                --Calcul la hauteur du liquide
                local liquidHeight = b.fillingRate * blocs.size / 100
                
                if collision_rectToRect(player.x, player.y, player.wth, player.hgt, x, y + (blocs.size - liquidHeight), blocs.size, liquidHeight) then
                    canMove = false
                end
            else
                if collision_rectToRect(player.x, player.y, player.wth, player.hgt, x, y, blocs.size, blocs.size) then
                    canMove = false
                end
            end
            
            --Collision entités
            for _, e in pairs(room.entities) do
                if collision_rectToRect(x, y, blocs.size, blocs.size, e.x, e.y, e.wth, e.hgt) then
                    if e.solidResistance == 100 then
                        canMove = false
                    end
                end
            end
        end
        
        --Collision blocs
        for i, b in pairs(room.blocs[self.layer]) do
            if b ~= self and self.x + moveSpeed == b.x and self.y == b.y then
                if self.density > b.density then
                    b.y = b.y - moveSpeed
                else
                    canMove = false
                end
            end
        end
        
        --Déplacement du bloc
        if canMove then
            blocs.calculateCardinality(self, true)
            self.x = self.x + moveSpeed
            blocs.calculateCardinality(self)
            return true
        else
            return false
        end
    end,
    
    moveY = function(self, moveSpeed)--Bouge le bloc verticalement
        local canMove = true
        
        local x, y = blocs.getPos(self.x, self.y + moveSpeed)
        
        --Colision bords de la fenêtre
        if moveSpeed < 0 then
            --Collision haut de la fenêtre
            if self.y + moveSpeed < 1 then
                self.y = 1
                canMove = false
            end
        elseif moveSpeed > 0 then
            --Collision bas de la fenêtre
            if self.y + moveSpeed > room.rows then
                self.y = room.rows
                canMove = false
            end
        end
        
        if self.isSolid and self.layer == 1 then
            
            --Collision joueur
            if collision_rectToRect(player.x, player.y, player.wth, player.hgt, x, y, blocs.size, blocs.size) then
                canMove = false
            end
            
            --Collision entités
            for _, e in pairs(room.entities) do
                if collision_rectToRect(x, y, blocs.size, blocs.size, e.x, e.y, e.wth, e.hgt) then
                    if e.solidResistance == 100 then
                        canMove = false
                    end
                end
            end
        end
        
        --Collision blocs
        for _, b in pairs(room.blocs[self.layer]) do
            if b ~= self and self.x == b.x and self.y + moveSpeed == b.y then
                if self.density > b.density then
                    b.y = b.y - moveSpeed
                else
                    canMove = false
                end
            end
        end
        
        --Déplacement du bloc
        if canMove then
            blocs.calculateCardinality(self, true)
            self.y = self.y + moveSpeed
            blocs.calculateCardinality(self)
            return true
        else
            return false
        end
    end,
    
    changeFillingRate = function(self, newFillingRate)--Modifie la contenance d'un liquide (en vérifiant les collisions avec le joueur)
        
        --Si le bloc a plus que 100% de remplissage, il repasse à 100%
        if newFillingRate > 100 then newFillingRate = 100 end
        
        --Test si le bloc est bien solide
        if not self.isLiquid then print("On ne peut pas changer la quantité de liquide d'un bloc qui n'est pas liquide"); return end
        
        --Récupère les coordonées du bloc
        local x, y = blocs.getPos(self.x, self.y)
        
        --Calcul la hauteur du liquide
        local liquidHeight = self.fillingRate * blocs.size / 100
        local newLiquidHeight = newFillingRate * blocs.size / 100
        
        --Test si le changement de quantité de liquide va toucher le joueur ou que le joueur est sur le liquide/solide
        if (collision_rectToRect(x, y + (blocs.size - newLiquidHeight), blocs.size, newLiquidHeight, player:getXYWH())
        or ((player.x + player.wth > x and player.x < x + blocs.size) and (player.y + player.hgt == y + (blocs.size - liquidHeight)))) and self.isSolid and self.layer == 1 then
            
            print(self.name)
            
            print("\n\n\nEtat initial :")
            print("player.y + player.hgt : "..player.y + player.hgt)
            print("y + (blocs.size - liquidHeight) : "..y + (blocs.size - liquidHeight))
            
            delta = liquidHeight - newLiquidHeight
            
            if not player.canMoveY(delta) then return end
            
            player.moveY(delta)
            
            print("\nEtat final : ")
            print("player.y + player.hgt : "..player.y + player.hgt)
            print("y + (blocs.size - newLiquidHeight) : "..y + (blocs.size - newLiquidHeight))
            
            --Actualise la contenance du liquide
            self.fillingRate = newFillingRate
        else
            
            --Actualise la contenance du liquide
            self.fillingRate = newFillingRate
        end
    end,
    
    forceflow = function(self)--Fait couler entièrement le liquide du bloc
        --Haut, Bas, Gauche, Droite
        --0 : Bloqué
        --1 : Vide
        --2 : Liquide
        local canFlow = {0, 1, 1, 1}
        
        --Test où est-ce que le liquide peut couler--
        for i, b in pairs(room.blocs[self.layer]) do
            --Test si le bloc peut couler en bas
            if self.x == b.x and self.y + 1 == b.y then
                --Si c'est un liquide
                if b.isLiquid and b.fillingRate ~= 100 and b.density <= self.density then
                    canFlow[2] = 2
                else
                    canFlow[2] = 0
                end
            end
            
            --Test si le bloc peut couler à gauche
            if self.x - 1 == b.x and self.y == b.y then
                --Si c'est un liquide
                if b.isLiquid and b.fillingRate ~= 100 and b.density <= self.density then
                    canFlow[3] = 2
                else
                    canFlow[3] = 0
                end
            end
            
            --Test si le bloc peut couler à droite
            if self.x + 1 == b.x and self.y == b.y then
                --Si c'est un liquide
                if b.isLiquid and b.fillingRate ~= 100 and b.density <= self.density then
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
            for i, b in pairs(room.blocs[self.layer]) do
                if direction == 1 then--Haut
                    
                elseif direction == 2 then--Bas
                    if b.x == self.x and b.y == self.y + 1 then
                        --Si c'est le même liquide
                        if self.id == b.id then
                            
                            dump = quantity
                            
                            if b.fillingRate + quantity > 100 then
                                quantity = b.fillingRate + quantity - 100
                            else
                                quantity = 0
                            end
                            
                            b:changeFillingRate(b.fillingRate + dump)
                            
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
                elseif direction == 3 then--Gauche
                    if b.x == self.x - 1 and b.y == self.y then
                        --Si c'est le même liquide
                        if self.id == b.id then
                            
                            --Si le liquide essaye de se verser dans un bloc qui a plus de liquide, annulle le déversement
                            if not forced and b.fillingRate > self.fillingRate then return quantity end
                            
                            dump = quantity
                            
                            if b.fillingRate + quantity > 100 then
                                quantity = b.fillingRate + quantity - 100
                            else
                                quantity = 0
                            end
                            
                            b:changeFillingRate(b.fillingRate + dump)
                            
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
                                
                                --Crée un bloc liquide à la nouvelle position
                                blocs.push(self.isSolid, bloc[self.id]:new({x = self.x - 1, y = self.y, fillingRate = quantity, layer = self.layer}))
                            end
                        end
                    end
                elseif direction == 4 then--Droit
                    if b.x == self.x + 1 and b.y == self.y then
                        --Si c'est le même liquide
                        if self.id == b.id then
                            
                            --Si le liquide essaye de se verser dans un bloc qui a plus de liquide, annulle le déversement
                            if not forced and b.fillingRate > self.fillingRate then return quantity end
                            
                            dump = quantity
                            
                            if b.fillingRate + quantity > 100 then
                                quantity = b.fillingRate + quantity - 100
                            else
                                quantity = 0
                            end
                            
                            b:changeFillingRate(b.fillingRate + dump)
                            
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
                                
                                --Crée un bloc liquide à la nouvelle position
                                blocs.push(self.isSolid, bloc[self.id]:new({x = self.x + 1, y = self.y, fillingRate = quantity, layer = self.layer}))
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
                if blocs.push(self.isSolid, bloc[self.id]:new({x = self.x - 1, y = self.y, fillingRate = quantity, layer = self.layer})) then
                    quantity = 0
                end
            elseif direction == 4 then--Droit
                if blocs.push(self.isSolid, bloc[self.id]:new({x = self.x + 1, y = self.y, fillingRate = quantity, layer = self.layer})) then
                    quantity = 0
                end
            end
        end
        
        --Retourne la quantité restante qui n'a pas pu être déversé
        return quantity
    end,
    
    flow = function(self)--Fait couler le liquide du bloc
        --Haut, Bas, Gauche, Droite
        --0 : Bloqué
        --1 : Vide
        --2 : Liquide
        local canFlow = {0, 1, 1, 1}
        
        --Collision bord de salle
        if self.y + 1 > room.rows then canFlow[2] = 0 end--En bas
        if self.x - 1 < 1 then canFlow[3] = 0 end--A gauche
        if self.x + 1 > room.cols then canFlow[4] = 0 end--A droite
        
        --Collision blocs
        for i, b in pairs(room.blocs[self.layer]) do
            
            --Test si le bloc peut couler en bas
            if self.x == b.x and self.y + 1 == b.y then
                
                if b.isLiquid and b.fillingRate ~= 100 and b.density <= self.density then
                    canFlow[2] = 2
                else
                    canFlow[2] = 0
                end
            end
            
            --Test si le bloc peut couler à gauche
            if self.x - 1 == b.x and self.y == b.y then
                
                if b.isLiquid and b.fillingRate ~= 100 and b.density <= self.density then
                    canFlow[3] = 2
                else
                    canFlow[3] = 0
                end
            end
            
            --Test si le bloc peut couler à droite
            if self.x + 1 == b.x and self.y == b.y then
                
                if b.isLiquid and b.fillingRate ~= 100 and b.density <= self.density then
                    canFlow[4] = 2
                else
                    canFlow[4] = 0
                end
            end
        end
        
        if self.isSolid and self.layer == 1 then
            
            --Récupère la position du la nouvelle bloc
            local x, y = blocs.getPos(self.x, self.y + 1)
            
            --Collision joueur
            if collision_rectToRect(player.x + 1, player.y, player.wth - 2, player.hgt, x, y, blocs.size, blocs.size) then
                canFlow[2] = 0
            end
            
            --Collision entités
            for _, e in pairs(room.entities) do
                if e.solidResistance == 100 and collision_rectToRect(x + 1, y, blocs.size - 2, blocs.size, e.x, e.y, e.wth, e.hgt) then
                    canFlow[2] = 0
                end
            end
        end
        
        local liquidNotspread = 0
        
        --Coule vers le bas
        if canFlow[2] ~= 0 then
            
            --Calcul du montant à donner
            local fillLoss = self.fillingRate
            
            --Donne du liquide en bas
            liquidNotspread = self:spread(2, canFlow[2] - 1, fillLoss)
            
            --Vide son liquide
            self:changeFillingRate(self.fillingRate - fillLoss + liquidNotspread)
            
        --Coule à gauche et à droite
        elseif canFlow[3] ~= 0 and canFlow[4] ~= 0 then
            
            --Si le bloc a assez de liquide, il le déverse
            if self.fillingRate > self.fillingRateMin then
                
                --Calcul du montant à donner
                local fillLoss = self.viscousRate * self.fillingRate / 100
                
                --Donne du liquide à gauche
                liquidNotspread = liquidNotspread + self:spread(3, canFlow[3] - 1, fillLoss/2)
                
                --Donne du liquide à droite
                liquidNotspread = liquidNotspread + self:spread(4, canFlow[4] - 1, fillLoss/2)
                
                --Vide son liquide
                self:changeFillingRate(self.fillingRate - fillLoss + liquidNotspread)
            end
            
        --Coule à gauche
        elseif canFlow[3] ~= 0 then
            --Si le bloc a assez de liquide, il le déverse
            if self.fillingRate > self.fillingRateMin then
                
                --Calcul du montant à donner
                local fillLoss = self.viscousRate * self.fillingRate / 100
                
                --Donne du liquide à gauche
                liquidNotspread = liquidNotspread + self:spread(3, canFlow[3] - 1, fillLoss)
                
                --Vide son liquide
                self:changeFillingRate(self.fillingRate - fillLoss + liquidNotspread)
            end
            
        --Coule à droite
        elseif canFlow[4] ~= 0 then
            --Si le bloc a assez de liquide, il le déverse
            if self.fillingRate > self.fillingRateMin then
                
                --Calcul du montant à donner
                local fillLoss = self.viscousRate * self.fillingRate / 100
                
                --Donne du liquide à droite
                liquidNotspread = liquidNotspread + self:spread(4, canFlow[4] - 1, fillLoss)
                
                --Vide son liquide
                self:changeFillingRate(self.fillingRate - fillLoss + liquidNotspread)
            end
        end
        
        --Si le bloc a plus que 100% de remplissage, il repasse à 100%
        if self.fillingRate > 100 then self.changeFillingRate(100) end
        
        --Si le bloc n'a plus de liquide, il disparaît
        if self.fillingRate <= 0 then blocs.pop(self.x, self.y, self.layer) end
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
        isSolid = true,
        timePass = false,
        ttlReach = true,
        touch = true,
        ttl = 1000,
        onTtlReach = function(self)
            print("\nRemplacement x :"..self.x.." y :"..self.y)
            blocs.pop(self.x, self.y, self.layer)
            blocs.push(false, bloc[3]:new({x = self.x, y = self.y}))
        end,
        onTouch = function(self, direction) if direction == 1 then self.timePass = true end end,
        density = 100
    }),

    --Bloc qui apparait au bout d'un certain temps
    bloc_class:new({
        id = 3,
        name = "appears with time",
        img = "instable2",
        ttl = 5000,
        timePass = true,
        ttlReach = true,
        onTtlReach = function(self)
            --Test si le bloc n'est pas en collision avec le joueur
            x, y = blocs.getPos(self.x, self.y)
            if not collision_rectToRect(player.x, player.y, player.wth, player.hgt, x, y, blocs.size, blocs.size) then
                blocs.pop(self.x, self.y, self.layer)
                blocs.push(false, bloc[2]:new({x = self.x, y = self.y}))
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
        density = 10,
        layer = 3
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