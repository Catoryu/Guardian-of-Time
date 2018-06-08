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
room.cells = {}
--room.grid = {}

--Class des cellule.
cell = createClass({
    --[[ID des blocs
    On en rajoutera plus tard
    0 : Vide
    1 : Solide
    ]]
    id = 0,
    x = 0,
    y = 0,
    ttl = 0, --Durée de cie de l'élément (caleur en ms)
    isVisible = true, --Indique si la cellule est affichée
    isDestructible = false,
    hp = 0,
    isTimely = false, --Meilleur nom ? : Indique si la cellule est affectée par le temps
    isActice = { --Indique si la cellule à une fonction à jouer à sa mort
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

    --Ajoute la fonction passée en argument comme trigger et actice l'attribut "isActice"
    setOnTtlReached = function(self, func)
        self.rawOnTtlReached = func
        self.isActice.ttlReach = true
    end,

    --Ajoute la fonction passée en argument comme trigger et actice l'attribut "isActice"
    setOnTouch = function(self, func)
        self.rawOnTouch = func
        self.isActice.touch = true
    end,

    --Reset les propriétés de la cellule mais pas les méthodes
    softReset = function(self)
        self.id = nil
        self.ttl = nil
        self.isVisible = nil
        self.isDestructible = nil
        self.hp = nil
        self.isTimely = nil
        self.isActice = nil
    end,

    --Reset complètement la cellule
    hardReset = function(self)
        for k, _ in pairs(self) do self[k] = nil end
    end
})

room.pushCell = function(...)
    for _, cellInitValues in pairs({...}) do
        local c = cell:new(cellInitValues)

        table.insert(room.cells, c)
    end
end

room.moveCameraX = function(moceSpeed)
    local deltaX = 0

    --Marge d'erreur de la salle
    if room.x + moceSpeed > 0 then
        deltaX = room.x
        room.x = room.x - deltaX
        for i, c in pairs(entities.container) do
            c.x = c.x - deltaX
        end
        player.x = player.x - deltaX
        return
    elseif room.x + room.wth + moceSpeed < wdow.wth then
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
        c.x = c.x + moceSpeed
    end

    --Bouge les blocs
    room.x = room.x + moceSpeed
end

room.moceCameraY = function(moceSpeed)
    local deltaY = 0

    --Marge d'erreur moucement de la salle
    if room.y + moceSpeed > 0 then
        deltaY = room.y
        room.y = room.y - deltaY
        for i, c in pairs(entities.container) do
            c.y = c.y - deltaY
        end
        player.y = player.y - deltaY
        return
    elseif room.y + room.hgt + moceSpeed < wdow.hgt then
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
        c.y = c.y + moceSpeed
    end

    --Bouge les blocs
    room.y = room.y + moceSpeed
end

room.update = function(dt)
    --Itère à tracers toutes les cellules
    for i, c in pairs(room.cells) do
        if c.isTimely then
            c.ttl = c.ttl - 1000 * dt

            if c.ttl <= 0 then
                if c.isActice then c:onTtlReached()
                else c:hardReset() end
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

    for i, c in pairs(room.cells) do
        local x, y = room.getCellPosition(c.x, c.y)

        --Test si la cellule est sur l'écran
        if (x + room.blocSize > 0 and x < wdow.wth) and
        (y + room.blocSize > 0 and y < wdow.hgt) and c.id == 1 then
            lg.setColor(0, 200, 0)
            lg.rectangle("line", x, y, room.blocSize, room.blocSize)
            lg.print("x" .. x .. " y" .. x , x, y)

            lg.print(c.ttl, x, y + 20)
        end
    end
end

gravity = 4000
chapter = 0
level = {}
level.x = 0
level.y = 0

room.pushCell({x = 10, y = 10, id = 1})
