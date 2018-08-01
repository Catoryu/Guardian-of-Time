--Chargement du fichier qui contient tous les types d'entité
dofile("data/entity.lua")

--Table qui contient toutes les fonctions concernant les entités
entities = {}

entities.create = function(x, y, wth, hgt, id)--Création d'une entité
    local en = {}
    
    en = entity[id]:new()
    en.id = id
    en.x = x
    en.y = y
    en.wth = wth
    en.hgt = hgt

    table.insert(room.entities, en)
end

entities.update = function(dt)--Pas encore utilisé
    
end

entities.draw = function()--Dessine les entités
    for i, v in pairs(room.entities) do
        lg.setColor(unpack(v.colors))
        
        lg.rectangle("fill", v.x, v.y, v.wth, v.hgt)
        
        lg.setFont(debug.font)
        lg.setColor(255, 255, 255)
        lg.rectangle("fill", v.x, v.y, debug.font:getWidth(v.id), debug.font:getHeight(v.id))
        lg.setColor(0, 0, 0)
        lg.print(v.id, v.x, v.y)
        lg.print("y : "..v.y, v.x, v.y + 15)
        lg.print("wth : "..v.wth, v.x, v.y + 30)
    end
end
