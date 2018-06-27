function love.load()--Chargement du jeu
    --[[Raccourcis]]--
    lg = love.graphics
    keyDown = love.keyboard.isDown
    
    --[[Appel des autres fichiers]]--
    dofile("functions.lua")
    dofile("load.lua")
    dofile("conf.lua")
    dofile("assets/lobj.lua")
    dofile("controls.lua")
    dofile("rooms.lua")
    dofile("blocs.lua")
    dofile("player.lua")
    dofile("entities.lua")
    dofile("events.lua")
    
    --[[Variable global]]--
    gravity = 4000
    airFriction = 100
    chapterNumber = 1
    time = 0
    
    --[[Instructions initiales]]--
    
    --Rend la souris invisible
    love.mouse.setVisible(false)
    
    --Réactualiser l'aléatoire
    math.randomseed(os.time())
    
    --Chargement du chapitre
    loadChapter(chapterNumber)
end

function love.update(dt)--Actualisation du jeu
    --Incrémente le temps
    time = time + dt
    
    --Actualise l'affichage de la souris
    mouse.x, mouse.y = love.mouse.getPosition()
    
    --Fait tourner le jeu uniquement lorsque l'utilisateur ne bouge pas la fenêtre
    if dt < 0.2 then
        player.update(dt)
        rooms.update(dt)
        controls(dt)
    else
        --Permet de ne pas faire avancer le joueur dans le vide après avoir bouger la fenêtre
        inputs = {}
    end
end

function love.draw()--Affichage du jeu
    
    --Dessine la salle
    rooms.draw()
    
    --Dessine le joueur
    player.draw()

    --[[Debug]]--
    if debug.visible then
        --love.graphics.setBlendMode("alpha", "premultiplied")
        lg.draw(debug.helpText, 10, 400)
        
        lg.setFont(debug.font)
        lg.setColor(180, 180, 180, 200)
        lg.rectangle("fill", 10, 10, 300, 340)
        lg.setColor(0, 0, 0)
        lg.print("player.x : "..player.x, 10, 10)
        lg.print("player.y : "..player.y, 10, 30)
        lg.print("player.xSpd : "..player.xSpd, 10, 50)
        lg.print("player.ySpd : "..player.ySpd, 10, 70)
        lg.print("player.isJumping : "..tostring(player.isJumping), 10, 90)
        lg.print("player.jumpKeyDownTime : "..player.jumpKeyDownTime, 10, 110)
        lg.print("player.jumpKeyDown : "..tostring(player.jumpKeyDown), 10, 130)
        lg.print("player.jumpLevel : "..player.jumpLevel, 10, 150)
        lg.print("player.jumpLevels : ", 10, 170)
        for i, v in pairs(player.jumpLevels) do
            lg.print(v, 90 + i*40, 170)
        end
        lg.print("player.airTime : "..player.airTime, 10, 190)
        lg.print("player.canJumpHigher : "..tostring(player.canJumpHigher), 10, 210)
        lg.print("#room.entities : "..#room.entities, 10, 230)
        lg.print("#room.blocs : "..#room.blocs, 10, 250)
        lg.print("#chapter.events : "..#chapter.events, 10, 270)
        lg.print("selectedBloc : "..selectedBloc.." ("..bloc[selectedBloc].name..")", 10, 290)
        lg.print("selectedEntity : "..selectedEntity.." ("..entity[selectedEntity].name..")", 10, 310)
        lg.print(string.format("%.2f s", time), 10, 330)
        lg.print("FPS : "..love.timer.getFPS(), 10, 350)
    end
    
    --Affichage de la souris
    lg.setColor(255, 255, 255)
    lg.draw(src.img.cursor, mouse.x, mouse.y)
end