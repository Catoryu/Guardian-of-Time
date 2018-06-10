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
room.blocs = {}

--Class des blocs.
bloc = createClass({
    --[[ID des blocs
    On en rajoutera plus tard
    0 : Vide
    1 : Solide
    ]]
    id = 0,
    x = 0,
    y = 0,
    ttl = 0, --Durée de vie de l'élément (valeur en ms)
    isVisible = true, --Indique si le bloc est affichée
    isDestructible = false,
    hp = 0,
    isTimely = false, --Meilleur nom ? : Indique si le bloc est affectée par le temps
    isActive = { --Indique si le bloc à une fonction à jouer lors de certain événements
        ttlReach = false,
        touch = false,
    },

    --Fonction passée en paramètre par ":setOnTtlReached()"
    rawOnTtlReached = function(self) end,
    rawOnTouch = function(self) end,

    --Fonction à utiliser à la mort de le bloc
    onTtlReached = function(self)
        self:rawOnTtlReached()
    end,

    --Fonction à utiliser losque le bloc est touché (par le joueur)
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

    --Reset les propriétés de le bloc mais pas les méthodes
    softReset = function(self)
        self.id = nil
        self.ttl = nil
        self.isVisible = nil
        self.isDestructible = nil
        self.hp = nil
        self.isTimely = nil
        self.isActive = nil
    end,

    --Reset complètement le bloc
    hardReset = function(self)
        for k, _ in pairs(self) do self[k] = nil end
    end
})

room.pushBloc = function(...)
    for _, blocInitValues in pairs({...}) do
        local c = bloc:new(blocInitValues)

        table.insert(room.blocs, c)
    end
end

room.flushBlocs = function()
    room.blocs = {}
end

room.popBloc = function (x, y)
    for i, v in ipairs(room.blocs) do
        if v.x == x and v.y == y then room.blocs[i] = nil end
    end
end

room.createBloc = function(x, y)
    local cx = math.floor((-room.x + x) / room.blocSize) + 1
    local cy = math.floor((-room.y + y) / room.blocSize) + 1

    room.pushBloc({x = cx, y = cy, id = 1})
end

room.moveCameraX = function(moveSpeed)
    local deltaX = 0

    --Marge d'erreur mouvement de la salle
    if room.x + moveSpeed > 0 then
        deltaX = room.x
        room.x = room.x - deltaX
        for i, c in pairs(entities.container) do
            c.x = c.x - deltaX
        end
        player.x = player.x - deltaX
        return
    elseif room.x + room.wth + moveSpeed < wdow.wth then
        deltaX = room.x + room.wth - wdow.wth
        room.x = room.x - deltaX
        for i, c in pairs(entities.container) do
            c.x = c.x - deltaX
        end
        player.x = player.x - deltaX
        return
    end

    --Bouge les entités
    for i, c in pairs(entities.container) do
        c.x = c.x + moveSpeed
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
        for i, c in pairs(entities.container) do
            c.y = c.y - deltaY
        end
        player.y = player.y - deltaY
        return
    elseif room.y + room.hgt + moveSpeed < wdow.hgt then
        deltaY = room.y + room.hgt - wdow.hgt
        room.y = room.y - deltaY
        for i, c in pairs(entities.container) do
            c.y = c.y - deltaY
        end
        player.y = player.y - deltaY
        return
    end

    --Bouge les entités
    for i, c in pairs(entities.container) do
        c.y = c.y + moveSpeed
    end

    --Bouge les blocs
    room.y = room.y + moveSpeed
end

room.update = function(dt)
    --Itère à travers tous les blocs
    for i, c in pairs(room.blocs) do
        if c.isTimely then
            c.ttl = c.ttl - 1000 * dt

            if c.ttl <= 0 then
                if c.isActive then c:onTtlReached()
                else c:hardReset() end
            end
        end
    end
end

room.getBlocPos = function(x, y)
    x = room.x + x * room.blocSize - room.blocSize
    y = room.y + y * room.blocSize - room.blocSize

    return x, y
end

room.draw = function()
    lg.setColor(255, 255, 255)
    lg.draw(room.image, room.x, room.y)

    for i, c in pairs(room.blocs) do
        local x, y = room.getBlocPos(c.x, c.y)

        --Test si le bloc est sur l'écran
        if (x + room.blocSize > 0 and x < wdow.wth) and
        (y + room.blocSize > 0 and y < wdow.hgt) and c.id == 1 then
            lg.setColor(0, 200, 0)
            lg.rectangle("line", x, y, room.blocSize, room.blocSize)

            lg.print("x" .. c.x .. " y" .. c.y , x, y)
            lg.print(c.ttl, x, y + 20)
        end
    end
end

gravity = 4000
chapter = 0
level = {}
level.x = 0
level.y = 0

room.pushBloc({x = 10, y = 10, id = 1}, {x = 9, y = 10, id = 1}, {x = 10, y = 9, id = 1})
room.popBloc(10, 10)
