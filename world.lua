--World/Map creation
room = {}
room.blocSize = 50
room.cols = 40
room.rows = 30
room.wth = room.cols * room.blocSize
room.hgt = room.rows * room.blocSize
room.x = 0
room.y = -room.hgt + wdow.hgt
room.grid = {}

--Initialise la grille des blocs
for i = 1, room.cols do
    local col = {}
    for i = 1, room.rows do
        table.insert(col, 0)
    end
    table.insert(room.grid, col)
end

--Permet de créer des blocs dans le jeu
room.createBloc = function(t)
    for i, v in pairs(t) do
       room.grid[v[1]][v[2]] = v[3]
    end
end

room.moveCameraX = function(moveSpeed)
    --Bouge les entités
    for i, v in pairs(entities.container) do
        v.x = v.x + moveSpeed
    end
    
--    --Marge d'erreur mouvement de la salle
--    if room.x + moveSpeed < 0 then
--        room.x = 0
--    elseif room.x + room.wth + moveSpeed > wdow.wth then
--        room.x = wdow.wth - room.wth
--    end
    
    --Bouge les blocs
    room.x = room.x + moveSpeed
end

room.moveCameraY = function(moveSpeed)
    --Bouge les entités
    for i, v in pairs(entities.container) do
        v.y = v.y + moveSpeed
    end
    
    --Bouge les blocs
    room.y = room.y + moveSpeed
end

room.draw = function()
    for i, v in pairs(room.grid) do
        for ii, vv in pairs(v) do
            lg.setColor(0, 200, 0)
            lg.rectangle("line", room.x + i*room.blocSize-room.blocSize, room.y + ii*room.blocSize-room.blocSize, room.blocSize, room.blocSize)
            lg.print("x"..i.." y"..ii, room.x + i*room.blocSize-room.blocSize, room.y + ii*room.blocSize-room.blocSize)
            if vv > 0 then lg.setColor(255, 0, 0) end
            lg.print(vv, room.x + i*room.blocSize-room.blocSize, room.y + ii*room.blocSize-room.blocSize + 20)
        end
    end
end

room.createBloc({{15, 28, 1}})

gravity = 4000
chapter = 0
level = 0