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
    event[3]:new({x = 700, y = 400, wth = 100, hgt = 100, room = 1})
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
    
    --Blocs
    blocs.push(bloc[1]:new({x = 21, y = 18}),bloc[1]:new({x = 22, y = 17}),bloc[1]:new({x = 21, y = 16}),bloc[1]:new({x = 23, y = 16}),bloc[1]:new({x = 23, y = 18}),bloc[1]:new({x = 25, y = 17}),bloc[1]:new({x = 26, y = 17}),bloc[1]:new({x = 27, y = 17}),bloc[1]:new({x = 26, y = 16}),bloc[1]:new({x = 26, y = 18}),bloc[1]:new({x = 29, y = 18}),bloc[1]:new({x = 29, y = 17}),bloc[1]:new({x = 29, y = 16}),bloc[1]:new({x = 30, y = 16}),bloc[1]:new({x = 31, y = 16}),bloc[1]:new({x = 31, y = 17}),bloc[1]:new({x = 31, y = 18}),bloc[1]:new({x = 30, y = 18}),bloc[1]:new({x = 33, y = 17}),bloc[1]:new({x = 35, y = 18}),bloc[1]:new({x = 35, y = 17}),bloc[1]:new({x = 35, y = 16}),bloc[1]:new({x = 36, y = 16}),bloc[1]:new({x = 37, y = 16}),bloc[1]:new({x = 37, y = 17}),bloc[1]:new({x = 37, y = 18}),bloc[1]:new({x = 36, y = 18}),bloc[1]:new({x = 36, y = 17}))
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
end