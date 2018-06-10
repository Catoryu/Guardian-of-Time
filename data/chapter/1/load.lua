--Chargement des images
room.img = {}
room.img.bground = lg.newImage("data/chapter/"..chapter.."/bground.jpg")
room.img.blocs = {false, }

--Charge toutes les images des blocs
for i, v in pairs(love.filesystem.getDirectoryItems("data/chapter/"..chapter.."/blocs")) do
    table.insert(room.img.blocs, lg.newImage("data/chapter/"..chapter.."/blocs/"..v))
end

--Initialisation de la grille avec des cellules
for i = 1, room.cols do
    local col = {}
    for j = 1, room.rows do
        table.insert(col, bloc[1])
    end
    table.insert(room.grid, col)
end

--Modification de certains blocs
room.setBloc({8, 17, 3}, {9, 17, 3}, {10, 17, 2}, {11, 17, 4}, {12, 17, 4}, {13, 17, 4}, {14, 17, 2})