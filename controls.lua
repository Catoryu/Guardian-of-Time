mouse = {}
mouse.x = 0
mouse.y = 0
mouse.firstX = 0
mouse.firstY = 0
mouse.secondX = 0
mouse.secondY = 0
selectedEntity = 3
selectedBloc = 1
inputs = {}

function controls(dt)
    if keyDown("escape") then love.event.quit() end

    if keyDown("left") then entities.moveX(-200*dt) end
    if keyDown("right") then entities.moveX(200*dt) end
    if keyDown("up") then entities.moveY(-200*dt) end
    if keyDown("down") then entities.moveY(200*dt) end
end

function love.keypressed(key)
    if key == "w" or key == "space" then
        player.jumpKeyDownTime = 0
        player.jumpKeyDown = true
        player.jump()
    end
    if key == "s" then
        table.insert(inputs, 2)
    end
    if key == "a" then table.insert(inputs, 3) end
    if key == "d" then table.insert(inputs, 4) end
    
    if key == "e" then
        --Sauvegarde de la salle
        id = 0
        
        --Trouve un nom de fichier libre
        for i, v in pairs(love.filesystem.getDirectoryItems("saves")) do
            if string.sub(v, 1, #v - 4) == tostring(id) then id = id + 1 end
        end
        
        --Génère la table pour les blocs
        local dump = "blocs.push("
        for i, v in pairs(room.blocs) do
            dump = dump .. "bloc["..v.id.."]:new({x = "..v.x..", y = "..v.y.."})"
            if i < #room.blocs then
                dump = dump..","
            end
        end
        dump = dump..")"
        
        file = io.open("saves/"..id..".lua", "w")
        io.output(file)
        io.write(dump)
        io.close(file)
        
        love.window.showMessageBox("Salle sauvegardée", "Vous avez sauvegardé la salle actuelle dans saves/"..id..".lua")
    end

    if key == "g" then player.showGrid = not player.showGrid end
    if key == "escape" then love.event.quit() end
    if key == "tab" then debug.visible = not debug.visible end
    if key == "delete" then table.remove(room.entities, #room.entities)end
    if key == "backspace" then
        --Recalcul les cardinalités
        for i, b in pairs(room.blocs) do
            --Haut
            if room.blocs[#room.blocs].x == b.x and room.blocs[#room.blocs].y - 1 == b.y then
                b.imgCardinality[2] = 0
            end
            --Bas
            if room.blocs[#room.blocs].x == b.x and room.blocs[#room.blocs].y + 1 == b.y then
                b.imgCardinality[1] = 0
            end
            --Gauche
            if room.blocs[#room.blocs].x - 1 == b.x and room.blocs[#room.blocs].y == b.y then
                b.imgCardinality[4] = 0
            end
            --Droite
            if room.blocs[#room.blocs].x + 1 == b.x and room.blocs[#room.blocs].y == b.y then
                b.imgCardinality[3] = 0
            end
        end
        table.remove(room.blocs, #room.blocs)
    end
end

function love.keyreleased(key)
    if key == "w" or key == "space" then
        player.jumpKeyDown = false
    end
  
    if key == "s" then 
        for i, v in pairs(inputs) do if v == 2 then table.remove(inputs, i) end end
    end
    
    if key == "a" then 
        for i, v in pairs(inputs) do if v == 3 then table.remove(inputs, i) end end
    end
    
    if key == "d" then 
        for i, v in pairs(inputs) do if v == 4 then table.remove(inputs, i) end end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        mouse.firstX, mouse.firstY = love.mouse.getPosition()
    end

    if button == 2 then blocs.create(x, y, selectedBloc) end
end

function love.mousereleased(_, _, button)
    mouse.secondX, mouse.secondY = love.mouse.getPosition()

    if button == 1 and mouse.firstX ~= mouse.secondX and mouse.firstY ~= mouse.secondY then
        if mouse.secondX > mouse.firstX and mouse.secondY > mouse.firstY then
            entities.create(mouse.firstX, mouse.firstY, mouse.secondX - mouse.firstX, mouse.secondY - mouse.firstY, selectedEntity)
        elseif mouse.secondX < mouse.firstX and mouse.secondY > mouse.firstY then
            entities.create(mouse.secondX, mouse.firstY, mouse.firstX - mouse.secondX, mouse.secondY - mouse.firstY, selectedEntity)
        elseif mouse.secondX > mouse.firstX and mouse.secondY < mouse.firstY then
            entities.create(mouse.firstX, mouse.secondY, mouse.secondX - mouse.firstX, mouse.firstY - mouse.secondY, selectedEntity)
        else
            entities.create(mouse.secondX, mouse.secondY, mouse.firstX - mouse.secondX, mouse.firstY - mouse.secondY, selectedEntity)
        end
    end
end

function love.wheelmoved(_, y)
    if keyDown("lshift") or keyDown("rshift") then
        if y > 0 then
            selectedBloc = (selectedBloc < #bloc) and selectedBloc + 1 or selectedBloc
        elseif y < 0 then
            selectedBloc = (selectedBloc - 1 > 0) and selectedBloc - 1 or selectedBloc
        end
    else
        if y > 0 then
            selectedEntity = (selectedEntity < #entity) and selectedEntity + 1 or selectedEntity
        elseif y < 0 then
            selectedEntity = (selectedEntity - 1 > 0) and selectedEntity - 1 or selectedEntity
        end
    end
end
