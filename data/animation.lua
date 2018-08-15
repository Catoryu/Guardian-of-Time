animation_class = {
    x = 0,
    y = 0,
    isVisible = true,
    file = "",
    frames = 0,
    frame = 0,
    fps = 0,
    colors = {255, 255, 255, 255},
    isLooping = false,
    isPlaying = true,
    file = "",
    timer = 0,
    bind = "",
    width = 0,
    height = 0,
    cols = 0,
    rows = 0,
    centerMethod = 0
    --[[
    Permet de centrer l'animation par rapport à son bind (si il y en a un)
    0 = En haut à gauche
    1 = En haut au milieu
    2 = En haut à droite
    
    3 = Au milieu à gauche
    4 = Au milieu
    5 = Au milieu à droite
    
    6 = En bas à gauche
    7 = En bas au milieu
    8 = En bas à droite
    ]]--
}


--Un peu de magie dans ce monde de brutes
setmetatable(animation_class, {__index = animation_class})

--Permet de créer un objet en utilisant une classe
function animation_class:new (t)
    t = t or {} --Crée une table si l'utilisateur n'en passe pas dans la fonction
    setmetatable(t, self)
    self.__index = self
    return t
end

--Cette table contiendra toutes les animations lors du chargement de celles-ci
animation = {}