--Class des blocs
bloc_class = {
    id = 1,
    coordX = 0,
    coordY = 0,
    
    x = 0,
    y = 0,
    wth = 0,
    hgt = 0,
    
    ttl = 0, --Durée de vie du bloc (valeur en ms)
    isAwake = true,
    isVisible = true,
    isSolid = false,
    isLiquid = false,
    isDestructible = false,
    isGravityAffected = false,
    fillingRate = 0,
    fillingRateMin = 0, --Minimum de % de remplissage pour pouvoir déverser
    refreshRate = 0.05,
    viscousRate = 25,
    density = 100,
    frame = 0,
    hp = 0,
    img = "",
    imgCardinality = {}, --Permet de définir si le bloc a plusieurs images
    cardinality = {},
    imgLink = false,
    timePass = false, --Indique si le bloc est affecté par le temps
    layer = 1, --Permet de définir si le bloc est devant ou derrière
    colors = {255, 255, 255, 255},
    collision = {true, true, true, true}, --Définit quels sont les cotés
    
    --Définit quel fonction sont activé
    ttlReach = false,
    touch = false,
    update = false,
    newFrame = false,
    
    onTtlReach = function(self) end, --Définit les instructions si l'événement est déclenché par le temps
    onTouch = function(self, direction) end, --Définit les instructions si l'événement est déclenché par un contact avec le joueur
    onUpdate = function(self) end,
    onNewFrame = function(self) end,

    setOnTtlReached = function(self, func)--Défini la fonction utilisé lorsque le temps du bloc est plus petit que 0
        self.rawOnTtlReached = func
        self.activeEvent.ttlReach = true
    end,

    setOnTouch = function(self, func)--Défini la fonction utilisé lorsque le bloc est touché (par le joueur)
        self.rawOnTouch = func
        self.activeEvent.touch = true
    end,

    ping = function(self)
        for i, b in pairs(room.blocs[self.layer]) do
            if self.coordX == b.coordX and self.coordY + 1 == b.coordY then
                b:wakeUp()
            end
            --Bloc en dessus de celui qui est détruit
            if self.coordX == b.coordX and self.coordY - 1 == b.coordY then
                b:wakeUp()
            end
            --Bloc à droite de celui qui est détruit
            if self.coordX + 1 == b.coordX and self.coordY == b.coordY then
                b:wakeUp()
            end
            --Bloc à gauche de celui qui est détruit
            if self.coordX - 1 == b.coordX and self.coordY == b.coordY then
                b:wakeUp()
            end
        end
    end,

    wakeUp = function(self)
        self.isAwake = true
    end,
    
    sleep = function(self)
        self.isAwake = false
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

    onScreen = function(self)--Test si le bloc est visible a l'écran
        if (self.x + self.wth > 0 and self.x < wdow.wth) and
        (self.y + self.hgt > 0 and self.y < wdow.hgt) then
            return true
        else
            return false
        end
    end,
    
    setBaseValues = function(self)--Reset le bloc avec ses valeurs de base (Utile lorsqu'on change d'écran)
        for k, _ in pairs(self) do self[k] = nil end
    end,
    
    moveX = function(self, moveSpeed)--Bouge le bloc horizontalement
        local canMove = true
        
        local x, y = blocs.getPos(self.coordX + moveSpeed, self.coordY)
        
        --Colision bords de la fenêtre
        if moveSpeed < 0 then
            --Collision haut de la fenêtre
            if self.coordX + moveSpeed < 1 then
                self.coordX = 1
                canMove = false
            end
        elseif moveSpeed > 0 then
            --Collision bas de la fenêtre
            if self.coordX + moveSpeed > room.cols then
                self.coordX = room.cols
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
            if b ~= self and self.coordX + moveSpeed == b.coordX and self.coordY == b.coordY then
                if self.density > b.density then
                    b.coordY = b.coordY - moveSpeed
                else
                    canMove = false
                end
            end
        end
        
        --Déplacement du bloc
        if canMove then
            blocs.calculateCardinality(self, true)
            self.coordX = self.coordX + moveSpeed
            self = blocs.calculateCardinality(self)
            self:calculateDimension()
            return true
        else
            return false
        end
    end,
    
    moveY = function(self, moveSpeed)--Bouge le bloc verticalement
        local canMove = true
        
        local x, y = blocs.getPos(self.coordX, self.coordY + moveSpeed)
        
        --Colision bords de la fenêtre
        if moveSpeed < 0 then
            --Collision haut de la fenêtre
            if self.coordY + moveSpeed < 1 then
                self.coordY = 1
                canMove = false
                self:sleep()
            end
        elseif moveSpeed > 0 then
            --Collision bas de la fenêtre
            if self.coordY + moveSpeed > room.rows then
                self.coordY = room.rows
                canMove = false
                self:sleep()
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
                        self:sleep()
                    end
                end
            end
        end
        
        --Collision blocs
        for _, b in pairs(room.blocs[self.layer]) do
            if b ~= self and self.coordX == b.coordX and self.coordY + moveSpeed == b.coordY then
                if self.density > b.density then
                    b.coordY = b.coordY - moveSpeed
                else
                    canMove = false
                    self:sleep()
                end
            end
        end
        
        --Déplacement du bloc
        if canMove then
            blocs.calculateCardinality(self, true)
            self.coordY = self.coordY + moveSpeed
            self = blocs.calculateCardinality(self)
            self:calculateDimension()
            return true
        else
            return false
        end
    end,
    
    calculateDimension = function(self)
        self.hgt = self.isLiquid and self.fillingRate * blocs.size / 100 or blocs.size
        self.wth = blocs.size
        self.x = room.x + self.coordX * blocs.size - self.wth
        self.y = room.y + self.coordY * blocs.size - self.hgt
    end,
    
    getXYWH = function(self)
        return self.x, self.y, self.wth, self.hgt
    end,
    
    changeFillingRate = function(self, newFillingRate)--Modifie la contenance d'un liquide (en vérifiant les collisions avec le joueur)
        
        --Test si le bloc est bien solide
        if not self.isLiquid then print("On ne peut pas changer la quantité de liquide d'un bloc qui n'est pas liquide"); return end
        
        self:ping()
        self:wakeUp()
        
        --Si le bloc a plus que 100% de remplissage, il repasse à 100%
        if newFillingRate > 100 then newFillingRate = 100 end
        
        dump = self.fillingRate
        
        if self.layer == 1 and self.isSolid then
            
            --Le liquide diminue
            if newFillingRate < dump and (player.x + player.wth > self.x and player.x < self.x + self.wth) and (player.y + player.hgt == self.y) then
                
                self.fillingRate = newFillingRate
                
                self:calculateDimension()
                
                local delta = player.y + player.hgt - self.y
                
                player.moveY(-delta)
            end
            
            self.fillingRate = newFillingRate
            
            self:calculateDimension()
            
            --Le liquide augmente
            if newFillingRate > dump and collision_rectToRect(self.x, self.y, self.wth, self.hgt, player:getXYWH()) then
                
                local delta = player.y + player.hgt - self.y
                
                if player.canMoveY(-delta) then
                    player.moveY(-delta)
                else
                    --Ne change pas de quantité de liquide
                    self.fillingRate = dump
                    
                    self:calculateDimension()
                    
                    return
                end
            end
        else
            self.fillingRate = newFillingRate
            
            self:calculateDimension()
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
            if self.coordX == b.coordX and self.coordY + 1 == b.coordY then
                --Si c'est un liquide
                if b.isLiquid and (b.fillingRate ~= 100 or b.id == self.id) and b.density <= self.density then
                    canFlow[2] = 2
                else
                    canFlow[2] = 0
                end
            end
            
            --Test si le bloc peut couler à gauche
            if self.coordX - 1 == b.coordX and self.coordY == b.coordY then
                --Si c'est un liquide
                if b.isLiquid and (b.fillingRate ~= 100 or b.id == self.id) and b.density <= self.density then
                    canFlow[3] = 2
                else
                    canFlow[3] = 0
                end
            end
            
            --Test si le bloc peut couler à droite
            if self.coordX + 1 == b.coordX and self.coordY == b.coordY then
                --Si c'est un liquide
                if b.isLiquid and (b.fillingRate ~= 100 or b.id == self.id) and b.density <= self.density then
                    canFlow[4] = 2
                else
                    canFlow[4] = 0
                end
            end
        end
        
        --Collision bord de salle
        if self.coordY + 1 > room.rows then canFlow[2] = 0 end--En bas
        if self.coordX - 1 < 1 then canFlow[3] = 0 end--A gauche
        if self.coordX + 1 > room.cols then canFlow[4] = 0 end--A droite
        
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
        else
            blocs.pop(self.coordX, self.coordY, self.layer)
        end
    end,
    
    spread = function(self, direction, hasAlreadyBloc, quantity, forced)
        --hasAlreadyBloc :
        --0 : no
        --1 : yes
        
        self:wakeUp()
        
        if hasAlreadyBloc == 1 then
            for i, b in pairs(room.blocs[self.layer]) do
                if direction == 1 then--Haut
                    
                elseif direction == 2 then--Bas
                    if b.coordX == self.coordX and b.coordY == self.coordY + 1 then
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
                                b.coordX = -1
                                b.coordY = -1
                                
                                b:sleep()
                                
                                blocs.checkIfLayerExists(self.layer)
                                
                                --Ajoute la position -1 -1 dans la table des blocs à supprimer
                                table.insert(blocs.toDelete[self.layer], i)
                                
                                --Déplace le bloc liquide
                                self.coordY = self.coordY + 1
                            end
                        end
                    end
                elseif direction == 3 then--Gauche
                    if b.coordX == self.coordX - 1 and b.coordY == self.coordY then
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
                                b.coordX = -1
                                b.coordY = -1
                                
                                blocs.checkIfLayerExists(self.layer)
                                
                                --Ajoute la position -1 -1 dans la table des blocs à supprimer
                                table.insert(blocs.toDelete[self.layer], i)
                                
                                --Crée un bloc liquide à la nouvelle position
                                blocs.push(self.isSolid, bloc[self.id]:new({coordX = self.coordX - 1, coordY = self.coordY, fillingRate = quantity, layer = self.layer}))
                            end
                        end
                    end
                elseif direction == 4 then--Droit
                    if b.coordX == self.coordX + 1 and b.coordY == self.coordY then
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
                                b.coordX = -1
                                b.coordY = -1
                                
                                blocs.checkIfLayerExists(self.layer)
                                
                                --Ajoute la position -1 -1 dans la table des blocs à supprimer
                                table.insert(blocs.toDelete[self.layer], i)
                                
                                --Crée un bloc liquide à la nouvelle position
                                blocs.push(self.isSolid, bloc[self.id]:new({coordX = self.coordX + 1, coordY = self.coordY, fillingRate = quantity, layer = self.layer}))
                            end
                        end
                    end
                end
            end
        elseif hasAlreadyBloc == 0 then
            if direction == 1 then--Haut
                
            elseif direction == 2 then--Bas
                self.coordY = self.coordY + 1
                self = blocs.calculateCardinality(self)
            elseif direction == 3 then--Gauche
                if blocs.push(self.isSolid, bloc[self.id]:new({coordX = self.coordX - 1, coordY = self.coordY, fillingRate = quantity, layer = self.layer})) then
                    quantity = 0
                end
            elseif direction == 4 then--Droit
                if blocs.push(self.isSolid, bloc[self.id]:new({coordX = self.coordX + 1, coordY = self.coordY, fillingRate = quantity, layer = self.layer})) then
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
        
        --Collision blocs
        for i, b in pairs(room.blocs[self.layer]) do
            
            --Test si le bloc peut couler en bas
            if self.coordX == b.coordX and self.coordY + 1 == b.coordY then
                
                if b.isLiquid and (b.fillingRate ~= 100 or b.id ~= self.id) and b.density <= self.density then
                    canFlow[2] = 2
                else
                    canFlow[2] = 0
                end
            end
            
            --Test si le bloc peut couler à gauche
            if self.coordX - 1 == b.coordX and self.coordY == b.coordY then
                
                if b.isLiquid and (b.fillingRate ~= 100 or b.id ~= self.id) and b.density <= self.density then
                    canFlow[3] = 2
                else
                    canFlow[3] = 0
                end
            end
            
            --Test si le bloc peut couler à droite
            if self.coordX + 1 == b.coordX and self.coordY == b.coordY then
                
                if b.isLiquid and (b.fillingRate ~= 100 or b.id ~= self.id) and b.density <= self.density then
                    canFlow[4] = 2
                else
                    canFlow[4] = 0
                end
            end
        end
        
        --Collision bord de salle
        if self.coordY + 1 > room.rows then canFlow[2] = 0 end--En bas
        if self.coordX - 1 < 1 then canFlow[3] = 0 end--A gauche
        if self.coordX + 1 > room.cols then canFlow[4] = 0 end--A droite
        
        if self.isSolid and self.layer == 1 then
            
            --Récupère la position du la nouvelle bloc
            local x, y = blocs.getPos(self.coordX, self.coordY + 1)
            
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
            else
                self:sleep()
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
            else
                self:sleep()
            end
            
        --Coule à droite
        elseif canFlow[4] ~= 0 then
            --Si le bloc a assez de liquide, il le déverse
            if self.fillingRate > self.fillingRateMin then
                
                --Calcul du montant à donner
                local fillLoss = self.viscousRate * self.fillingRate / 100
                
                --Donne du liquide à droite
                liquidNotspread = liquidNotspread + self:spread(4, canFlow[4] - 1, fillLoss)
                
                if liquidNotspread < 0 then self:sleep(); return end
                
                --Vide son liquide
                self:changeFillingRate(self.fillingRate - fillLoss + liquidNotspread)
            else
                self:sleep()
            end
        --Coule nul part
        else
            self:sleep()
        end
        
        --Si le bloc n'a plus de liquide, il disparaît
        if self.fillingRate <= 0 then blocs.pop(self.coordX, self.coordY, self.layer); blocs.calculateCardinality(self, true); self.coordX = 1; self.coordY = 1 end
    end,
    
}

newClass(bloc_class)

--Metamethode pour savoir si tous les cotés sont solide
setmetatable(
    bloc_class.collision,
    {
        __index = function (t, k)
            for i, v in pairs(t) do
                if not v then return false end
            end
            return true
        end
    }
)

bloc = {
    bloc_class:new({--Bloc solide classique
        id = 1,
        name = "solid",
        img = "stone",
        imgLink = true,
        isSolid = true
    }),

    bloc_class:new({--Bloc qui se détruit au toucher (dessus)
        id = 2,
        name = "disappears when touched",
        img = "instable",
        isSolid = true,
        timePass = false,
        ttlReach = true,
        touch = true,
        ttl = 1000,
        onTtlReach = function(self)
            print("\nRemplacement coordX :"..self.coordX.." coordY :"..self.coordY)
            blocs.pop(self.coordX, self.coordY, self.layer)
            blocs.push(false, bloc[3]:new({coordX = self.coordX, coordY = self.coordY}))
        end,
        onTouch = function(self, direction) if direction == 1 then self.timePass = true end end
    }),

    bloc_class:new({--Bloc qui apparait au bout d'un certain temps
        id = 3,
        name = "appears with time",
        img = "instable2",
        ttl = 5000,
        timePass = true,
        ttlReach = true,
        onTtlReach = function(self)
            --Test si le bloc n'est pas en collision avec le joueur
            if not collision_rectToRect(player.x, player.y, player.wth, player.hgt, self.x, self.y, blocs.size, blocs.size) then
                blocs.pop(self.coordX, self.coordY, self.layer)
                blocs.push(false, bloc[2]:new({coordX = self.coordX, coordY = self.coordY}))
            end
        end
    }),

    bloc_class:new({--Plateforme à sens unique (Uniquement collision du dessus)
        id = 4,
        name = "platform",
        img = "woodPlatform",
        collision = {true, false, false, false}
    }),

    bloc_class:new({--Bloc liquide d'eau
        id = 5,
        name = "water",
        viscousRate = 10,
        fillingRateMin = 5,
        colors = {51, 153, 255, 150},
        isLiquid = true,
        fillingRate = 100,
        density = 10,
        collision = {false, false, false, false}
    }),

    bloc_class:new({--Bloc liquide de sable
        id = 6,
        name = "sand",
        viscousRate = 10,
        fillingRateMin = 40,
        colors = {228, 206, 64, 255},
        isLiquid = true,
        isSolid = true,
        fillingRate = 100,
        density = 20,
        isGravityAffected = false
    }),

    bloc_class:new({--Bloc solide de sable
        id = 7,
        name = "sandBloc",
        img = "sand",
        isGravityAffected = true,
        imgLink = true,
        isSolid = true,
        density = 30
    }),

    bloc_class:new({--Source d'eau
        id = 8,
        name = "Water source",
        img = "waterSource",
        isGravityAffected = false,
        refreshRate = 1,
        isSolid = false,
        update = true,
        spawnLayer = 1,
        layer = 2,
        newFrame = true,
        onNewFrame = function(self)
            blocs.push(true, bloc[5]:new({coordX = self.coordX, coordY = self.coordY, layer = self.spawnLayer}))
        end
    }),
    --[[
    A faire : 
    -Bloc glissant
    -Bloc rebondissant
    -Bloc visqueux
    -Escalier
    -Echelle
    -Pente
    ]]--
}