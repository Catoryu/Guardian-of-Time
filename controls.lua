--[[Liste des contrôles
[W][A] Saute
[S][LS vers le bas] Se baisse (pas encore implémenté)
[A][LS vers le bas] Va à gauche
[D][LS vers le bas] Va a droite

[TAB][BACK] Permet d'afficher/cacher les menus
[G][X] Permet d'afficher/cacher la grille
[clic gauche] Permet de créer une entité
[clic droit] Permet de créer un bloc
[molette] Change l'entité créé
[shift + molette] Change le bloc créé
[DELETE][LB] Supprime la dernière entité
[Backspace][RB] Supprime le dernier bloc
[ESC][START] Quitte le programme
]]--

mouse = {}
mouse.x = 0
mouse.y = 0
mouse.firstX = 0
mouse.firstY = 0
mouse.secondX = 0
mouse.secondY = 0
mouse.visible = true
selectedEntity = 3
selectedBloc = 1
selectedLayer = 1
mute = true
inputs = {}

--Définit quel périphérique est utilisé (clavier/souris[0] ou manette[1])
currentInput = 0

--Table contenant toutes les fonctions liés aux contrôles
controls = {}

controls.update = function(dt)--Une touche est enfoncée
    --Clavier souris--
    
    --Permet de bouger toutes les entités [Temporaire]
    if keyDown("left") then
        for _, e in pairs(room.entities) do
            e:moveX(-220*dt)
        end
    end
    if keyDown("right") then
        for _, e in pairs(room.entities) do
            e:moveX(220*dt)
        end
    end
    
    if keyDown("up") then
        for _, e in pairs(room.entities) do
            e:moveY(-220*dt)
        end
    end
    
    if keyDown("down") then
        for _, e in pairs(room.entities) do
            e:moveY(220*dt)
        end
    end
    
    --Manette--
    if gamepad.joystick then
        local x = gamepad.joystick:getGamepadAxis("leftx")
        local y = gamepad.joystick:getGamepadAxis("lefty")
        
        --Se baisse
        if y > gamepad.offset then
            currentInput = 1
            table.insert(inputs, 2)
        else
            for i, input in pairs(inputs) do if input == 2 then table.remove(inputs, i) end end
        end
        
        --Va à gauche
        if x < -gamepad.offset then
            currentInput = 1
            player.moveX( - player.moveSpd * dt)
        end
        
        --Va à droite
        if x > gamepad.offset then
            currentInput = 1
            player.moveX(player.moveSpd * dt)
        end
    end
end

--[[Manette]]--

function love.gamepadpressed(joy, button)
    --Actualise le dernier périphérique utilisé
    currentInput = 1
    
    --Saute
    if button == "a" then
        player.jumpKeyDownTime = 0
        player.jumpKeyDown = true
        player.jump()
    end
    
    --Affiche/cache la grille
    if button == "x" then player.showGrid = not player.showGrid end
    
    --Quitte le programme
    if button == "start" then love.event.quit() end
    
    --Affiche/cache les informations de déboguage
    if button == "back" then debug.visible = not debug.visible end
    
    --Supprime la dernière entité
    if button == "leftshoulder" then table.remove(room.entities, #room.entities)end
    
    --Supprime le dernier bloc et recalcul les cardinalités
    if button == "rightshoulder" and #room.blocs > 0 then
        room.blocs[#room.blocs] = blocs.calculateCardinality(room.blocs[#room.blocs], true)
        blocs.pop(room.blocs[#room.blocs].x, room.blocs[#room.blocs].y)
    end
end

function love.gamepadreleased(joy, button)
    --Actualise le dernier périphérique utilisé
    currentInput = 1
    
    --Saute
    if button == "a" then
        player.jumpKeyDown = false
    end
end

--[[Clavier souris]]--

function love.keypressed(key)--Une touche du clavier viens d'être enfoncée
    --Actualise le dernier périphérique utilisé
    currentInput = 0
    
    --Saute
    if key == "w" or key == "space" then
        player.jumpKeyDownTime = 0
        player.jumpKeyDown = true
        player.jump()
    end
    
    --Se baisse
    if key == "s" then table.insert(inputs, 2) end
    
    --Va à gauche
    if key == "a" then table.insert(inputs, 3) end
    
    --Va à droite
    if key == "d" then table.insert(inputs, 4) end
    
    --Sauvegarde de la salle
    if key == "e" then
        id = 0
        
        --Trouve un nom de fichier libre (numerique)
        for i, item in pairs(love.filesystem.getDirectoryItems("saves")) do
            if string.sub(item, 1, #item - 4) == tostring(id) then id = id + 1 end
        end
        
        --Génère la table pour les blocs
        local dump = "blocs.push(false, "
        for i, b in pairs(room.blocs) do
            dump = dump .. "bloc["..b.id.."]:new({x = "..b.x..", y = "..b.y.."})"
            if i < #room.blocs then
                dump = dump..","
            end
        end
        dump = dump..")"
        
        --Ecrit le script de création de salle dans un fichier
        file = io.open("saves/"..id..".lua", "w")
        io.output(file)
        io.write(dump)
        io.close(file)
        
        --Affiche un message pour informer que la sauvegarde c'est correctement effectuée
        love.window.showMessageBox("Salle sauvegardée", "Vous avez sauvegardé la salle actuelle dans saves/"..id..".lua")
    end

    --Affiche/cache la grille
    if key == "g" then player.showGrid = not player.showGrid end
    
    --Quitte le programme
    if key == "escape" then love.event.quit() end
    
    --Affiche/cache les informations de déboguage
    if key == "tab" then debug.visible = not debug.visible end
    
    --Supprime la dernière entité
    if key == "delete" then table.remove(room.entities, #room.entities)end
    
    --Active/Désactive le son
    if key == "m" then 
        mute = not mute
        if mute == true then
            src.sound.wind_l:pause(); src.sound.wind_r:pause()
        else
            src.sound.wind_l:play(); src.sound.wind_r:play()
        end
    end
    
    --Supprime le dernier bloc et recalcul les cardinalités
    if key == "backspace" and room.blocs[1] ~= nil and #room.blocs[1] > 0 then
        blocs.pop(room.blocs[1][#room.blocs[1]].x, room.blocs[1][#room.blocs[1]].y, 1)
        
        local x, y = blocs.getPos(room.blocs[1][#room.blocs[1]].x, room.blocs[1][#room.blocs[1]].y)
        
        animations.create(animation["explosion"]:new({x = x + blocs.size/2 - animation["explosion"].wth/2, y = y + blocs.size/2 - animation["explosion"].hgt/2, fps = 30}))
    end
end

function love.keyreleased(key)--Une touche du clavier viens d'être relachée
    --Saute
    if key == "w" or key == "space" then
        player.jumpKeyDown = false
    end
  
    --Se baisse
    if key == "s" then 
        for i, input in pairs(inputs) do if input == 2 then table.remove(inputs, i) end end
    end
    
    --Va à gauche
    if key == "a" then 
        for i, input in pairs(inputs) do if input == 3 then table.remove(inputs, i) end end
    end
    
    --Va à droite
    if key == "d" then 
        for i, input in pairs(inputs) do if input == 4 then table.remove(inputs, i) end end
    end
end

function love.mousepressed(x, y, button)--Un bouton de la souris viens d'être enfoncé
    --Actualise le dernier périphérique utilisé
    currentInput = 0
    
    --Clic gauche (créé une entité)
    if button == 1 then
        mouse.firstX, mouse.firstY = love.mouse.getPosition()
    end

    --Clic droit (créé un bloc)
    if button == 2 then
        
        local bx, by = blocs.getCoordPos(x, y)
        
        if not blocs.exists(bx, by, selectedLayer) then
            blocs.create(x, y, selectedBloc, true, selectedLayer)
        else
            print("Vous ne pouvez pas poser de bloc ici car il y en a deja un")
        end
    end
    
    --Clic molette (change la couche du bloc à poser)
    if button == 3 then
        if selectedLayer == 1 then
            selectedLayer = 2
        else
            selectedLayer = 1
        end
    end
end

function love.mousereleased(_, _, button)--Un bouton de la souris viens d'être relaché
    --Actualise le dernier périphérique utilisé
    currentInput = 0
    
    --Création d'une entité lorsqu'on relâche le clic de la souris
    mouse.secondX, mouse.secondY = love.mouse.getPosition()

    --Calcul la position et la taille de l'entité
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

function love.wheelmoved(_, y)--La molette de la souris est bougée
    --Actualise le dernier périphérique utilisé
    currentInput = 0
    
    --Si la touche "shift" est enfoncée
    if keyDown("lshift") or keyDown("rshift") then
        --Selon la direction de la molette, change le bloc séléctionné
        if y > 0 then
            selectedBloc = (selectedBloc < #bloc) and selectedBloc + 1 or selectedBloc
        elseif y < 0 then
            selectedBloc = (selectedBloc - 1 > 0) and selectedBloc - 1 or selectedBloc
        end
    --Si la touche "shift" n'est pas enfoncée
    else
        --Selon la direction de la molette, change l'entité séléctionné
        if y > 0 then
            selectedEntity = (selectedEntity < #entity) and selectedEntity + 1 or selectedEntity
        elseif y < 0 then
            selectedEntity = (selectedEntity - 1 > 0) and selectedEntity - 1 or selectedEntity
        end
    end
end
