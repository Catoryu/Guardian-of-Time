--[[Késaco
Chaque chapitre doit avoir ces propriétés de base :
 • Les tables "chapter", "chapter.rooms" et "chapter,events"
 • Le numéro de la salle de départ
 • Un nom de chapitre
 • Des événements en utilisant la fonction events.push, exemple :
    o events.push(
          event[1]:new({x = 600, y = 400, wth = 100, hgt = 100, room = 1}),
          event[2]:new({x = 500, y = 400, wth = 100, hgt = 100, room = 1}),
          blablablabla
      )
 • Des fonctions contenu dans chapter.rooms, exemple :
    o chapter.rooms[1] = function()
          room = {}
          
          (Nombre de blocs de largeur et de hauteur)
          room.cols = 38
          room.rows = 22
          
          (Définit la taille de la salle, ici selon les blocs)
          room.wth = room.cols * blocs.size
          room.hgt = room.rows * blocs.size
          
          (Position initial de la salle, ici en bas à gauche)
          room.x = 0
          room.y = -room.hgt + wdow.hgt
          
          (Définit ou le joueur va aller lorsqu'il touche le bord de la salle
          Haut : Vers la salle numéro 3
          Bas : Bloqué
          Gauche : Bloqué
          Droite : Vers la salle numéro 2
          )
          room.cardinality = {3, 0, 0, 2}
          
          (Permet de rajouter un filtre de couleur à la salle)
          room.colors = {255, 255, 255, 0}
          
          (Contiendra tous les blocs de la salle)
          room.blocs = {}
          
          (Contiendra tous les blocs de fond de la salle)
          room.bgBlocs = {}
          
          (Contiendra toutes les entités de la salle)
          room.entities = {}
          
          (Id de la météo de la salle)
          weathers.id = 0
          
          (Permet de choisir la couleur des bandes autour de l'écran lorsque l'écran est secoué)
          lg.setBackgroundColor(80, 80, 180)
          
          (Ajoute les blocs dans la salle à l'aide de la fonction blocs.push)
          blocs.push(false, bloc[1]:new({x = 21, y = 18}, bloc[1]:new({x = 22, y = 17}), blablabla)
      end
]]--

--[[Chapter configuration]]--
chapter = {}
chapter.roomNumber = 1
chapter.name = "Introduction"
chapter.rooms = {}
chapter.events = {}

--Events
events.push(
    event[1]:new({x = 600, y = 400, wth = 100, hgt = 100, room = 1}),
    event[2]:new({x = 500, y = 400, wth = 100, hgt = 100, room = 1}),
    event[3]:new({x = 700, y = 400, wth = 100, hgt = 100, room = 1}),
    event[4]:new({x = 400, y = 400, wth = 100, hgt = 100, room = 1}),
    event[5]:new({x = 800, y = 400, wth = 100, hgt = 100, room = 1})
)

--[[Room 1]]--
chapter.rooms[1] = function()
    room = {}
    room.cols = 38
    room.rows = 22
    room.wth = room.cols * blocs.size
    room.hgt = room.rows * blocs.size
    room.x = 0
    room.y = -room.hgt + wdow.hgt
    room.cardinality = {3, 0, 0, 2}
    room.colors = {255, 255, 255, 0}
    room.blocs = {}
    room.entities = {}
    weathers.id = 1
    
    lg.setBackgroundColor(80, 80, 180)
    
    --Blocs
    blocs.push(false, bloc[1]:new({x = 21, y = 18}),bloc[1]:new({x = 22, y = 17}),bloc[1]:new({x = 21, y = 16}),bloc[1]:new({x = 23, y = 16}),bloc[1]:new({x = 23, y = 18}),bloc[1]:new({x = 25, y = 17}),bloc[1]:new({x = 26, y = 17}),bloc[1]:new({x = 27, y = 17}),bloc[1]:new({x = 26, y = 16}),bloc[1]:new({x = 26, y = 18}),bloc[1]:new({x = 29, y = 18}),bloc[1]:new({x = 29, y = 17}),bloc[1]:new({x = 29, y = 16}),bloc[1]:new({x = 30, y = 16}),bloc[1]:new({x = 31, y = 16}),bloc[1]:new({x = 31, y = 17}),bloc[1]:new({x = 31, y = 18}),bloc[1]:new({x = 30, y = 18}),bloc[1]:new({x = 33, y = 17}),bloc[1]:new({x = 35, y = 18}),bloc[1]:new({x = 35, y = 17}),bloc[1]:new({x = 35, y = 16}),bloc[1]:new({x = 36, y = 16}),bloc[1]:new({x = 37, y = 16}),bloc[1]:new({x = 37, y = 17}),bloc[1]:new({x = 37, y = 18}),bloc[1]:new({x = 36, y = 18}),bloc[1]:new({x = 36, y = 17}))
end

--[[Room 2]]--
chapter.rooms[2] = function()
    room = {}
    room.cols = 38
    room.rows = 22
    room.wth = room.cols * blocs.size
    room.hgt = room.rows * blocs.size
    room.x = 0
    room.y = -room.hgt + wdow.hgt
    room.cardinality = {4, 0, 1, 0}
    room.colors = {50, 20, 20, 100}
    room.blocs = {}
    room.entities = {}
    weathers.id = 2
    
    lg.setBackgroundColor(180, 80, 80)
end

--[[Room 3]]--
chapter.rooms[3] = function()
    room = {}
    room.cols = 38
    room.rows = 22
    room.wth = room.cols * blocs.size
    room.hgt = room.rows * blocs.size
    room.x = 0
    room.y = -room.hgt + wdow.hgt
    room.cardinality = {0, 1, 0, 4}
    room.colors = {255, 255, 255, 0}
    room.blocs = {}
    room.entities = {}
    room.events = {}
    weathers.id = 0
    
    lg.setBackgroundColor(80, 80, 180)
end

--[[Room 4]]--
chapter.rooms[4] = function()
    room = {}
    room.cols = 38
    room.rows = 22
    room.wth = room.cols * blocs.size
    room.hgt = room.rows * blocs.size
    room.x = 0
    room.y = -room.hgt + wdow.hgt
    room.cardinality = {0, 2, 3, 0}
    room.colors = {255, 255, 255, 0}
    room.blocs = {}
    room.entities = {}
    room.events = {}
    weathers.id = 0
    
    lg.setBackgroundColor(80, 80, 180)
end