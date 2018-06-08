--Initialisation de la grille avec des cellules
for i = 1, room.cols do
    local col = {}
    for j = 1, room.rows do
        table.insert(col, cell:new())
    end
    table.insert(room.grid, col)
end

--Modification de certains blocs
room.grid[15][18].id = 1
room.grid[16][19].id = 1
room.grid[13][17].id = 1
room.grid[14][17].id = 1
room.grid[15][15].id = 1
room.grid[5][18].id = 1
room.grid[5][18].ttl = 1000
room.grid[5][18]:setOnTtlReached(function(self) self.id = 0; self.isTimely = false; self:hardReset() end)
room.grid[5][18]:setOnTouch(function(self, direction) if direction == 1 then self.isTimely = true end end)