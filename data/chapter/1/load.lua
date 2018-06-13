--Chargement des images
room.img = {}
room.img.bground = lg.newImage("data/chapter/"..chapter.."/bground.jpg")
room.img.blocs = {}

--Modification de certains blocs
room.pushBloc(bloc[1]:new({x = 10, y = 10}), bloc[1]:new({x = 9, y = 10}), bloc[1]:new({x = 10, y = 9}))
