--Chargement des images
room.img = {}
room.img.bground = lg.newImage("data/chapter/"..chapter.."/bground.jpg")
room.img.blocs = {}

--Charge toutes les images des blocs
for i, v in pairs(love.filesystem.getDirectoryItems("data/chapter/"..chapter.."/blocs")) do
    table.insert(room.img.blocs, lg.newImage("data/chapter/"..chapter.."/blocs/"..v))
end

--Modification de certains blocs
room.pushBloc(bloc[1]:new({x = 10, y = 10}), bloc[1]:new({x = 9, y = 10}), bloc[1]:new({x = 10, y = 9}))
