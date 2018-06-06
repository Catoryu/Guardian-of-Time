function love.load()
    dofile("assets/lobj.lua")
    dofile("conf.lua")
    dofile("world.lua")
    dofile("entities.lua")
 
    lg = love.graphics
    keyDown = love.keyboard.isDown
    math.randomseed(os.time())
    
    ----Settings----
    --Window
    love.window.setTitle(wdow.title)
    love.window.setMode(wdow.wth, wdow.hgt, _)
    love.window.setFullscreen(false)
    --Background
    lg.setBackgroundColor(unpack(bground.color))
end
 
function love.update(dt)
    if keyDown("escape") then love.event.quit() end
end
 
function love.draw()
    lg.setColor(unpack(text.color))
    lg.print(player.weapon[2].name, 10, 10, _, _, _, _, _, _, _)
    player.hitbox:draw()
    
    --[[Debug]]--
    lg.setColor(0, 200, 0)
    lg.print("FPS : "..love.timer.getFPS())
    debug.draw()
end