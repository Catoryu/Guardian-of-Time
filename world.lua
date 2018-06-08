--World/Map creation
room = {}
room.blocSize = 50
room.cols = 40
room.rows = 20
room.wth = room.cols * room.blocSize
room.hgt = room.rows * room.blocSize
room.x = 0
room.y = -room.hgt + wdow.hgt
room.image = lg.newImage("data/fond.jpg")--temp
room.grid = {}

--Class des cellule.
cell = createClass({
    --[[ID des blocs
    On en rajoutera plus tard
    0 : Vide
    1 : Solide
    ]]
    id = 0,
    ttl = 0, --Durée de vie de l'élément (valeur en ms)
    isVisible = true, --Indique si la cellule est affichée
    isDestructible = false,
    hp = 0,
    isTimely = false, --Meilleur nom ? : Indique si la cellule est affectée par le temps
    isActive = { --Indique si la cellule à une fonction à jouer à sa mort
        ttlReach = false,
        touch = false,
    },

    --Fonction passée en paramètre par ":setOnTtlReached()"
    rawOnTtlReached = function(self) end,
    rawOnTouch = function(self) end,

    --Fonction à utiliser à la mort de la cellule
    onTtlReached = function(self)
        self:rawOnTtlReached()
    end,

    --Fonction à utiliser losque la cellule est touché (par le joueur)
    onTouch = function(self, direction)
        --[[
        1 : Haut
        2 : Bas
        3 : Gauche
        4 : Droit
        ]]
        self:rawOnTouch(direction)
    end,

    --Ajoute la fonction passée en argument comme trigger et active l'attribut "isActive"
    setOnTtlReached = function(self, func)
        self.rawOnTtlReached = func
        self.isActive.ttlReach = true
    end,

    --Ajoute la fonction passée en argument comme trigger et active l'attribut "isActive"
    setOnTouch = function(self, func)
        self.rawOnTouch = func
        self.isActive.touch = true
    end,

    --Set le ttl de la cellule avec la valeur donnée et active l'attribut "isTimely"
    setTTL = function(self, time)
        self.ttl = time
    end,

    --Reset les propriétés de la cellule mais pas les méthodes
    softReset = function(self)
        self.id = nil
        self.ttl = nil
        self.isVisible = nil
        self.isDestructible = nil
        self.hp = nil
        self.isTimely = nil
        self.isActive = nil
    end,

    --Reset complètement la cellule
    hardReset = function(self)
        for k, _ in pairs(self) do self[k] = nil end
    end
})

room.setBloc = function(...)
    for i, v in pairs({...}) do
       room.grid[v[1]][v[2]] = v[3]
    end
end

room.moveCameraX = function(moveSpeed)
    local deltaX = 0

    --Marge d'erreur de la salle
    if room.x + moveSpeed > 0 then
        deltaX = room.x
        room.x = room.x - deltaX
        for i, v in pairs(entities.container) do
            v.x = v.x - deltaX
        end
        player.x = player.x - deltaX
        return
    elseif room.x + room.wth + moveSpeed < wdow.wth then
        deltaX = room.x + room.wth - wdow.wth
        room.x = room.x - deltaX
        for i, v in pairs(entities.container) do
            v.x = v.x - deltaX
        end
        player.x = player.x - deltaX
        return
    end

    --Bouge les entités
    for i, v in pairs(entities.container) do
        v.x = v.x + moveSpeed
    end

    --Bouge les blocs
    room.x = room.x + moveSpeed
end

room.moveCameraY = function(moveSpeed)
    local deltaY = 0

    --Marge d'erreur mouvement de la salle
    if room.y + moveSpeed > 0 then
        deltaY = room.y
        room.y = room.y - deltaY
        for i, v in pairs(entities.container) do
            v.y = v.y - deltaY
        end
        player.y = player.y - deltaY
        return
    elseif room.y + room.hgt + moveSpeed < wdow.hgt then
        deltaY = room.y + room.hgt - wdow.hgt
        room.y = room.y - deltaY
        for i, v in pairs(entities.container) do
            v.y = v.y - deltaY
        end
        player.y = player.y - deltaY
        return
    end

    --Bouge les entités
    for i, v in pairs(entities.container) do
        v.y = v.y + moveSpeed
    end

    --Bouge les blocs
    room.y = room.y + moveSpeed
end

room.update = function(dt)
    --Cooldown des cellules
    for i, v in pairs(room.grid) do
        for ii, vv in pairs(v) do
            if vv.isTimely then
                vv.ttl = vv.ttl - 1000 * dt
                
                if vv.ttl <= 0 then
                    if vv.isActive then vv:onTtlReached()
                    else vv:hardReset() end
                end
            end
        end
    end
end

room.getCellPosition = function(x, y)
    x = room.x + x * room.blocSize - room.blocSize
    y = room.y + y * room.blocSize - room.blocSize

    return x, y
end

room.draw = function()
    lg.setColor(255, 255, 255)
    lg.draw(room.image, room.x, room.y)
    for i, v in pairs(room.grid) do
        for ii, vv in pairs(v) do
            local x = room.x + i*room.blocSize - room.blocSize
            local y = room.y + ii*room.blocSize - room.blocSize
            
            --Test si la cellule est sur l'écran
            if (x + room.blocSize > 0 and x < wdow.wth) and
            (y + room.blocSize > 0 and y < wdow.hgt) and vv.id == 1 then
                lg.setColor(0, 200, 0)
                lg.rectangle("line", x, y, room.blocSize, room.blocSize)
                lg.print("x"..i.." y"..ii, x, y)
            
                lg.print(vv.ttl, x, y + 20)
            end
        end
    end
end

--Chargement d'un niveau
dofile("data/chapter/1.lua")

gravity = 4000
chapter = 0
level = {}
level.x = 0
level.y = 0
