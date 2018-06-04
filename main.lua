function love.load()

    dofile("lobj.lua")
    dofile("conf.lua")
    dofile("world.lua")
    dofile("entities.lua")

    ----Settings----
    --Window
    love.window.setTitle(window.title)
    love.window.setMode(window.width, window.height, _)
    love.window.setFullscreen(false)
    --Background
    love.graphics.setBackgroundColor(background.color.r, background.color.g, background.color.b, _)
    --Text
    love.graphics.setColor(text.color.r, text.color.g, text.color.b, _)

end

function love.update(dt)

end

function love.draw()

end
