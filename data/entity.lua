--Valeur par défaut des entitées
entity_class = {
    name = "",
    isAffectedByGravity = false,
    isMovable = false,
    isDestructible = false,
    canSwim = false,
    colors = {255, 255, 255, 255},
    ttl = nil, --valeur en ms
    solidResistance = 100 --pourcentage de ralentissement lorsqu'on traverse l'entité (100 = solide)
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
