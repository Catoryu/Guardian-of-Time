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
    blocs.push(bloc[1]:new({x = 10, y = 10}), bloc[1]:new({x = 9, y = 10}), bloc[1]:new({x = 10, y = 9}))
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