rooms.load = {}

--[[Room 1]]--
rooms.load[1] = function()
    room = {}
    room.cols = 40
    room.rows = 20
    room.wth = room.cols * blocs.size
    room.hgt = room.rows * blocs.size
    room.x = 0
    room.y = -room.hgt + wdow.hgt
    room.cardinality = {0, 0, 0, 0}
    room.blocs = {}
    room.entities = {}
    room.events = {}
    
    --Blocs
    blocs.push(bloc[1]:new({x = 10, y = 10, room = 1}), bloc[1]:new({x = 9, y = 10, room = 1}), bloc[1]:new({x = 10, y = 9, room = 1}))
end

--[[Room 2]]--
rooms.load[2] = function()

end