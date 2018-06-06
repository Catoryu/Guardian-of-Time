function love.load()
  lg = love.graphics
  keyDown = love.keyboard.isDown
  wdowWth = 600
  wdowHgt = 600
  love.window.setMode(wdowWth, wdowHgt)
  love.window.setTitle("Plateformer")
  math.randomseed(os.time())
  inputs = {}
  gravity = 4000
  
  require "player"
  require "controls"
  require "platforms"
end

function love.update(dt)
  player.update(dt)
  if keyDown("left") then
    platforms.moveX(-50*dt)
  end
  
  if keyDown("right") then
    platforms.moveX(50*dt)
  end
  
  if keyDown("up") then
    platforms.moveY(-50*dt)
  end
  
  if keyDown("down") then
    platforms.moveY(50*dt)
  end
end

function love.draw()
  platforms.draw()
  player.draw()
  
  --[[Debug]]--
  lg.setColor(0, 200, 0)
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
  lg.print("#platforms.container : "..#platforms.container, 10, 230)
  lg.print("FPS : "..love.timer.getFPS(), 10, 250)
end