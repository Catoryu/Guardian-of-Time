function love.load()
    lg = love.graphics
    keyDown = love.keyboard.isDown
    love.mouse.setVisible(false)
    math.randomseed(os.time())
    
    dofile("functions.lua")
    dofile("load.lua")
    dofile("conf.lua")
    dofile("assets/lobj.lua")
    dofile("controls.lua")
    dofile("rooms.lua")
    dofile("blocs.lua")
    dofile("player.lua")
    dofile("entities.lua")
    
    --World/Map creation
    gravity = 4000
    airFriction = 100
    chapterNumber = 1
    
    loadChapter(chapterNumber)
end

function love.update(dt)
    --Actualise l'affichage de la souris
    mouse.x, mouse.y = love.mouse.getPosition()
    
    --Fait tourner le jeu uniquement lorsque l'utilisateur ne bouge pas la fenêtre
    if dt < 0.2 then
        player.update(dt)
        rooms.update(dt)
        controls(dt)
    else
        --Permet de ne pas faire avancer le joueur dans le vide après avoir bouger la fenêtre
        inputs.down = false
        inputs.left = false
        inputs.right = false
    end
end

function love.draw()
    rooms.draw()
    player.draw()

    --[[Debug]]--
    if debug.visible then
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
        lg.print("selectedBloc : "..selectedBloc.." ("..bloc[selectedBloc].name..")", 10, 270)
        lg.print("selectedEntity : "..selectedEntity.." ("..entity[selectedEntity].name..")", 10, 290)
        lg.print("FPS : "..love.timer.getFPS(), 10, 310)
    end
    
    --Affichage de la souris
    lg.setColor(255, 255, 255)
    lg.draw(src.img.cursor, mouse.x, mouse.y)
end