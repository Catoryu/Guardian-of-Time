function love.load()
  lg = love.graphics
  keyDown = love.keyboard.isDown
  math.randomseed(os.time())

  dofile("conf.lua")
  dofile("assets/lobj.lua")
  dofile("controls.lua")
  dofile("player.lua")
  dofile("entities.lua")
  dofile("world.lua")
  dofile("data.lua")
end

function love.update(dt)
--    dt = dt / 10
    player.update(dt)
    room.update(dt)
    controls(dt)
end

function love.draw()
    lg.setFont(debug.font)
    lg.setColor(0, 200, 0)
    room.draw()
    entities.draw()
    player.draw()

    --[[Debug]]--
    if debug.visible then
        lg.setFont(debug.font)
        lg.setColor(180, 180, 180, 200)
        lg.rectangle("fill", 10, 10, 300, 300)
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
        lg.print("#entities.container : "..#entities.container, 10, 230)
        lg.print("selectedEntity : "..selectedEntity.." ("..entity[selectedEntity].name..")", 10, 250)
        lg.print("FPS : "..love.timer.getFPS(), 10, 270)
    end
end
