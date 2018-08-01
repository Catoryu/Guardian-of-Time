--Class des entités
entity_class = {
    name = "",
    isAffectedByGravity = false,
    isMovable = false,
    isDestructible = false,
    canSwim = false,
    colors = {255, 255, 255, 255},
    ttl = nil, --valeur en ms
    solidResistance = 100, --pourcentage de ralentissement lorsqu'on traverse l'entité (100 = solide)
    
    getXYWH = function(self)--Récupère la position du joueur et sa taille (raccourci)
        return self.x, self.y, self.wth, self.hgt
    end,
    
    moveX = function (self, moveSpeed)--Gère le mouvement horizontal des entités
        if self.solidResistance == 100 then
            local dx = math.huge
            
            if moveSpeed < 0 then
                
                --Colision bords de la salle
                if self.x + moveSpeed < room.x then
                    if self.x - room.x < dx then
                        dx = self.x - room.x
                    end
                end
                
                --Collision entités
                for _, e in pairs(room.entities) do
                    --Collisions coté droit des entités
                    if e ~= self and collision_rectToRect(self.x + moveSpeed, self.y, self.wth, self.hgt, e:getXYWH()) then
                        if e.solidResistance == 100 then
                            if self.x - (e.x + e.wth) < dx then
                                dx = self.x - (e.x + e.wth)
                            end
                        end
                    end
                end
                
                --Collision bloc
                for _, b in pairs(room.blocs) do
                    if b.isSolid then
                        if b.isLiquid then
                            --Récupère les coordonnés du bloc
                            local x, y = blocs.getPos(b.x, b.y)
                            
                            --Calcul la hauteur du liquide
                            local liquidHeight = b.fillingRate * blocs.size / 100
                            
                            if collision_rectToRect(self.x + moveSpeed, self.y, self.wth, self.hgt, x, y + (blocs.size - liquidHeight), blocs.size, liquidHeight) then
                                b:onTouch(4)
                                if self.x - (x + blocs.size) < dx then
                                    dx = self.x - (x + blocs.size)
                                end
                            end
                        else
                            --Récupère les coordonnés du bloc
                            local x, y = blocs.getPos(b.x, b.y)
                            
                            if collision_rectToRect(self.x + moveSpeed, self.y, self.wth, self.hgt, x, y, blocs.size, blocs.size) then
                                b:onTouch(4)
                                if self.x - (x + blocs.size) < dx then
                                    dx = self.x - (x + blocs.size)
                                end
                            end
                        end
                    end
                end
                
                --Collision joueur
                if collision_rectToRect(self.x + moveSpeed, self.y, self.wth, self.hgt, player:getXYWH()) then
                    if self.x - (player.x + player.wth) < dx then
                        if not player.moveX(self.x + moveSpeed - (player.x + player.wth)) then
                            dx = self.x - (player.x + player.wth)
                        end
                    end
                end
                
                --Déplace l'entité
                if dx ~= math.huge then
                    self.x = self.x - dx
                    
                    --Test si le joueur est sur l'entité lorsqu'elle se déplace
                    if (player.y + player.hgt == self.y) and (player.x < self.x + dx + self.wth and player.x + player.wth > self.x) then
                        player.moveX(-dx)
                    end
                    
                    return false
                end
                
                self.x = self.x + moveSpeed
                
                --Test si le joueur est sur l'entité lorsqu'elle se déplace
                if (player.y + player.hgt == self.y) and (player.x < self.x - moveSpeed + self.wth and player.x + player.wth > self.x) then
                    player.moveX(moveSpeed)
                end
                
                return true
                
            elseif moveSpeed > 0 then
                
                --Colision bords de la salle
                if self.x + self.wth + moveSpeed > room.x + room.wth then
                    if (room.x + room.wth) - (self.x + self.wth) < dx then
                        dx = (room.x + room.wth) - (self.x + self.wth)
                    end
                end
                
                --Collision entités
                for _, e in pairs(room.entities) do
                    if e ~= self and collision_rectToRect(self.x + moveSpeed, self.y, self.wth, self.hgt, e:getXYWH()) then
                        if e.solidResistance == 100 then
                            if e.x - (self.x + self.wth) < dx then
                                dx = e.x - (self.x + self.wth)
                            end
                        end
                    end
                end
                
                --Collision bloc
                for _, b in pairs(room.blocs) do
                    if b.isSolid then
                        if b.isLiquid then
                            --Récupère les coordonnés du bloc
                            local x, y = blocs.getPos(b.x, b.y)
                            
                            --Calcul la hauteur du liquide
                            local liquidHeight = b.fillingRate * blocs.size / 100
                            
                            if collision_rectToRect(self.x + moveSpeed, self.y, self.wth, self.hgt, x, y + (blocs.size - liquidHeight), blocs.size, liquidHeight) then
                                b:onTouch(3)
                                if b.isSolid then
                                    if x - (self.x + self.wth) < dx then
                                        dx = x - (self.x + self.wth)
                                    end
                                end
                            end
                        else
                            --Récupère les coordonnés du bloc
                            local x, y = blocs.getPos(b.x, b.y)
                            
                            if collision_rectToRect(self.x + moveSpeed, self.y, self.wth, self.hgt, x, y, blocs.size, blocs.size) then
                                b:onTouch(3)
                                if x - (self.x + self.wth) < dx then
                                    dx = x - (self.x + self.wth)
                                end
                            end
                        end
                    end
                end
                
                --Collision joueur
                if collision_rectToRect(self.x + moveSpeed, self.y, self.wth, self.hgt, player:getXYWH()) then
                    if player.x - (self.x + self.wth) < dx then
                        if not player.moveX((self.x + moveSpeed + self.wth) - player.x) then
                            dx = player.x - (self.x + self.wth)
                        end
                    end
                end
                
                --Déplace l'entité
                if dx ~= math.huge then
                    self.x = self.x + dx
                    
                    --Test si le joueur est sur l'entité lorsqu'elle se déplace
                    if (player.y + player.hgt == self.y) and (player.x < self.x - dx + self.wth and player.x + player.wth > self.x) then
                        player.moveX(dx)
                    end
                    
                    return false
                end
                
                self.x = self.x + moveSpeed
                
                --Test si le joueur est sur l'entité lorsqu'elle se déplace
                if (player.y + player.hgt == self.y) and (player.x < self.x - moveSpeed + self.wth and player.x + player.wth > self.x) then
                    player.moveX(moveSpeed)
                end
                
                return true
            end
            
        else
            self.x = self.x + moveSpeed
            
            --Collision joueur
            if collision_rectToRect(player.x, player.y, player.wth, player.hgt, self:getXYWH()) then
                player.moveX(moveSpeed * self.solidResistance / 100, true)
            end
        end
    end,
    
    moveY = function(self, moveSpeed)--Gère le mouvement vertical des entités
        if self.solidResistance == 100 then
            local dy = math.huge
            
            if moveSpeed < 0 then
                
                --Colision bords de la salle
                if self.y + moveSpeed < room.y then
                    if self.y - room.y < dy then
                        dy = self.y - room.y
                    end
                end
                
                --Collision entités
                for _, e in pairs(room.entities) do
                    --Collisions coté droit des entités
                    if e ~= self and collision_rectToRect(self.x, self.y + moveSpeed, self.wth, self.hgt, e:getXYWH()) then
                        if e.solidResistance == 100 then
                            if self.y - (e.y + e.hgt) < dy then
                                dy = self.y - (e.y + e.hgt)
                            end
                        end
                    end
                end
                
                --Collision bloc
                for _, b in pairs(room.blocs) do
                    if b.isSolid then
                        if b.isLiquid then
                            --Récupère les coordonnés du bloc
                            local x, y = blocs.getPos(b.x, b.y)
                            
                            --Calcul la hauteur du liquide
                            local liquidHeight = b.fillingRate * blocs.size / 100
                            
                            if collision_rectToRect(self.x, self.y + moveSpeed, self.wth, self.hgt, x, y + (blocs.size - liquidHeight), blocs.size, liquidHeight) then
                                b:onTouch(4)
                                if self.y - (y + blocs.size) < dy then
                                    dy = self.y - (y + blocs.size)
                                end
                            end
                        else
                            --Récupère les coordonnés du bloc
                            local x, y = blocs.getPos(b.x, b.y)
                            
                            if collision_rectToRect(self.x, self.y + moveSpeed, self.wth, self.hgt, x, y, blocs.size, blocs.size) then
                                b:onTouch(4)
                                if self.y - (y + blocs.size) < dy then
                                    dy = self.y - (y + blocs.size)
                                end
                            end
                        end
                    end
                end
                
                --Collision joueur
                if collision_rectToRect(self.x, self.y + moveSpeed, self.wth, self.hgt, player:getXYWH()) then
                    if self.y - (player.y + player.hgt) < dy then
                        if not player.moveY(self.y + moveSpeed - (player.y + player.hgt)) then
                            dy = self.y - (player.y + player.hgt)
                        end
                    end
                end
                
                --Déplace l'entité
                if dy ~= math.huge then
                    self.y = self.y - dy
                    
                    --Test si le joueur est sur l'entité lorsqu'elle se déplace
                    if (player.y + player.hgt == self.y + dy) and (player.x < self.x + self.wth and player.x + player.wth > self.x) then
                        player.moveY(-dy)
                    end
                    
                    return false
                end
                
                self.y = self.y + moveSpeed
                
                --Test si le joueur est sur l'entité lorsqu'elle se déplace
                if (player.y + player.hgt == self.y - moveSpeed) and (player.x < self.x + self.wth and player.x + player.wth > self.x) then
                    player.moveY(moveSpeed)
                end
                
                return true
                
            elseif moveSpeed > 0 then
                
                --Colision bords de la salle
                if self.y + self.hgt + moveSpeed > room.y + room.hgt then
                    if (room.y + room.hgt) - (self.y + self.hgt) < dy then
                        dy = (room.y + room.hgt) - (self.y + self.hgt)
                    end
                end
                
                --Collision entités
                for _, e in pairs(room.entities) do
                    if e ~= self and collision_rectToRect(self.x, self.y + moveSpeed, self.wth, self.hgt, e:getXYWH()) then
                        if e.solidResistance == 100 then
                            if e.y - (self.y + self.hgt) < dy then
                                dy = e.y - (self.y + self.hgt)
                            end
                        end
                    end
                end
                
                --Collision bloc
                for _, b in pairs(room.blocs) do
                    if b.isSolid then
                        if b.isLiquid then
                            --Récupère les coordonnés du bloc
                            local x, y = blocs.getPos(b.x, b.y)
                            
                            --Calcul la hauteur du liquide
                            local liquidHeight = b.fillingRate * blocs.size / 100
                            
                            --Collisions coté gauche des liquides
                            if collision_rectToRect(self.x, self.y + moveSpeed, self.wth, self.hgt, x, y + (blocs.size - liquidHeight), blocs.size, liquidHeight) then
                                b:onTouch(3)
                                if b.isSolid then
                                    if y + (blocs.size - liquidHeight) - (self.y + self.hgt) < dy then
                                        dy = y + (blocs.size - liquidHeight) - (self.y + self.hgt)
                                    end
                                end
                            end
                        else
                            --Récupère les coordonnés du bloc
                            local x, y = blocs.getPos(b.x, b.y)
                            
                            --Collisions coté gauche des blocs
                            if collision_rectToRect(self.x, self.y + moveSpeed, self.wth, self.hgt, x, y, blocs.size, blocs.size) then
                                b:onTouch(3)
                                if y - (self.y + self.hgt) < dy then
                                    dy = y - (self.y + self.hgt)
                                end
                            end
                        end
                    end
                end
                
                --Collision joueur
                if collision_rectToRect(self.x, self.y + moveSpeed, self.wth, self.hgt, player:getXYWH()) then
                    if player.y - (self.y + self.hgt) < dy then
                        if not player.moveY((self.y + moveSpeed + self.hgt) - player.y) then
                            dy = player.y - (self.y + self.hgt)
                        end
                    end
                end
                
                --Déplace l'entité
                if dy ~= math.huge then
                    self.y = self.y + dy
                    
                    --Test si le joueur est sur l'entité lorsqu'elle se déplace
                    if (player.y + player.hgt == self.y - dy) and (player.x < self.x + self.wth and player.x + player.wth > self.x) then
                        player.moveY(dy)
                    end
                    
                    return false
                end
                
                self.y = self.y + moveSpeed
                
                --Test si le joueur est sur l'entité lorsqu'elle se déplace
                if (player.y + player.hgt == self.y - moveSpeed) and (player.x < self.x + self.wth and player.x + player.wth > self.x) then
                    player.moveY(moveSpeed)
                end
                
                return true
            end
            
        else
            self.y = self.y + moveSpeed
            
            --Collision joueur
            if collision_rectToRect(player.x, player.y, player.wth, player.hgt, self:getXYWH()) then
                player.moveY(moveSpeed * self.solidResistance / 100, true)
            end
        end
    end
}

--Un peu de magie dans ce monde de brutes
setmetatable(entity_class, {__index = entity_class})

--Permet de créer un objet en utilisant une classe
function entity_class:new (t)
    t = t or {} --Crée une table si l'utilisateur n'en passe pas dans la fonction
    setmetatable(t, self)
    self.__index = self
    return t
end

entity = {
    --Je liste déjà tous là, je supprimerais ce qui n'ai pas une entité après

    --Water
    entity_class:new({
        name = "water",
        colors = {87, 170, 242},
        affectedByGravity = true,
        isMovable = true,
        canSwim = true,
        solidResistance = 30,
    }),
    entity_class:new({
        name = "steam",
        colors = {160, 160, 160, 100},
        solidResistance = 5,
    }),
    entity_class:new({
        name = "liquid",
        colors = {20, 20, 255},
        isMovable = true
    }),

    --Fire
    entity_class:new({
        name = "fire",
        TTL = 5000,
        solidResistance = 20,
    }),
    entity_class:new({
        name ="magma",
        canSwim = true,
        affectedByGravity = true,
        solidResistance = 80,
    }),
    entity_class:new({
        name = "heat",
        affectedByGravity = true,
        solidResistance = 10,
    }),

    --Earth
    entity_class:new({
        name = "earth",
        isSolid = true,
        affectedByGravity = true
    }),
    entity_class:new({
        name = "steel",
        isSolid = true,
    }),
    entity_class:new({
        name = "sand",
        isSolid = true,
        affectedByGravity = true,
        colors = {200, 200, 100, 255},
    }),

    --Air
    entity_class:new({
        name = "air",
        affectedByGravity = true,
        solidResistance = 100,
    }),
    entity_class:new({
        name = "cloud",
        isSolid = true,
        affectedByGravity = true
    }),
    entity_class:new({
        name = "vibration",
        affectedByGravity = true,
        solidResistance = 100,
    }),

    --Lightning
    entity_class:new({
        name = "lightning",
        affectedByGravity = true,
        TTL = 100,
        solidResistance = 100,
    }),
    entity_class:new({
        name = "plasma",
        affectedByGravity = true,
        solidResistance = 100,
    }),
    entity_class:new({
        name = "tempest",
        affectedByGravity = true,
        solidResistance = 30,
    }),

    --Ice
    entity_class:new({
        name = "ice",
        isSolid = true,
        affectedByGravity = true
    }),
    entity_class:new({
        name = "cold",
        affectedByGravity = true,
        solidResistance = 10,
    }),
    entity_class:new({
        name = "snow",
        isSolid = true,
        affectedByGravity = true
    }),

    --Darkness
    entity_class:new({
        name = "darkness",
        affectedByGravity = true,
        solidResistance = 30,
    }),
    entity_class:new({
        name = "soul",
        affectedByGravity = true
    }),
    entity_class:new({
        name = "void",
        affectedByGravity = true
    }),

    --Light
    entity_class:new({
        name = "light",
        affectedByGravity = true,
        solidResistance = -30,
    }),
    entity_class:new({
        name = "life",
        affectedByGravity = true
    }),
    entity_class:new({
        name = "creation",
        affectedByGravity = true
    }),
}
