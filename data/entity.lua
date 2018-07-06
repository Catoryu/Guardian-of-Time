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
    
    moveX = function (self, moveSpeed)--Gère le mouvement horizontal des entités
        if self.solidResistance == 100 then
            local canMove = false
            
            if moveSpeed < 0 then
                --Collision coté gauche entités
                if collision_rectToRect(player.x, player.y, player.wth, player.hgt - 1, self.x + moveSpeed, self.y, self.wth, self.hgt) == 3 then
                    if player.moveX(self.x + moveSpeed - (player.x + player.wth)) then canMove = true end
                else
                    canMove = true
                end
            elseif moveSpeed > 0 then
                --Collision coté droit entités
                if collision_rectToRect(player.x, player.y, player.wth, player.hgt - 1, self.x + moveSpeed, self.y, self.wth, self.hgt) == 4 then
                    if player.moveX((self.x + moveSpeed + self.wth) - player.x) then canMove = true end
                else
                    canMove = true
                end
            end
            
            if canMove then
                self.x = self.x + moveSpeed
                
                --Test si le joueur est sur l'entité lorsqu'elle se déplace
                if (player.y + player.hgt == self.y) and (player.x < self.x - moveSpeed + self.wth and player.x + player.wth > self.x) then
                    player.moveX(moveSpeed)
                end
            else
                --Affiche un message
                print("Le joueur est ecrase par une entite avec une vitesse de "..moveSpeed.." x !!")
                
                --Replace l'entité
                if self.x > player.x + player.wth then
                    self.x = player.x + player.wth
                elseif self.x + self.wth < player.x then
                    self.x = player.x - self.wth
                end
            end
        else
            self.x = self.x + moveSpeed
            if collision_rectToRect(player.x, player.y, player.wth, player.hgt, self.x, self.y, self.wth, self.hgt) ~= 0 then
                player.moveX(moveSpeed * self.solidResistance / 100, true)
            end
        end
    end,
    
    moveY = function(self, moveSpeed)--Gère le mouvement vertical des entités
        if self.solidResistance == 100 then
            local canMove = false
            
            --L'entité monte
            if moveSpeed < 0 then
                --Collisions coté haut des entités
                if collision_rectToRect(player.x, player.y, player.wth, player.hgt, self.x, self.y + moveSpeed, self.wth, self.hgt) == 1 then
                    if player.moveY(moveSpeed) then canMove = true end
                else
                    canMove = true
                end
                
            --L'entité déscend
            elseif moveSpeed > 0 then
                --Collisions coté bas des entités
                if collision_rectToRect(player.x, player.y, player.wth, player.hgt, self.x, self.y + moveSpeed, self.wth, self.hgt) == 2 then
                    if player.moveY(moveSpeed) then canMove = true end
                else
                    canMove = true
                end
            end
            
            if canMove then
                --Déplace l'entité
                self.y = self.y + moveSpeed
                
                --Test si le joueur est sur l'entité lorsqu'elle se déplace
                if (player.y + player.hgt == self.y - moveSpeed) and (player.x < self.x + self.wth and player.x + player.wth > self.x) then
                    player.moveY(moveSpeed)
                end
            else
                --Affiche un message
                print("Le joueur est ecrase par une entite avec une vitesse de "..moveSpeed.." y !!")
                
                --Replace l'entité
                if self.y > player.y + player.hgt then
                    self.y = player.y + player.hgt
                elseif self.y + self.hgt < player.y then
                    self.y = player.y - self.hgt
                end
            end
            
        else
            self.y = self.y + moveSpeed
            if collision_rectToRect(player.x, player.y, player.wth, player.hgt, self.x, self.y, self.wth, self.hgt) ~= 0 then
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
