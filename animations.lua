dofile("data/animation.lua")

animations = {}

animations.container = {}

--Crée un objet de type "animation"
animations.create = function(animationValues)
    table.insert(animations.container, animationValues)
    
    animations.container[#animations.container].timer = animations.container[#animations.container].timer / animations.container[#animations.container].fps
end

animations.update = function(dt)
    for i, a in pairs (animations.container) do
        if a.isPlaying then
            a.timer = a.timer - dt
            if a.timer <= 0 then
                a.timer = 1 / a.fps
                a.frame = a.frame + 1
                if a.frame >= a.frames then
                    if a.isLooping then
                        a.frame = 0
                    else
                        table.remove(animations.container, i)
                    end
                end
            end
        end
    end
end

animations.draw = function()
    for i, a in pairs(animations.container) do
        if a.isVisible then
            lg.setColor(unpack(a.colors))
            
            if a.bind == "" then
                lg.draw(src.anim[a.file], src.anim[a.file.."_"..a.frame], a.x, a.y)
                
                if debug.visible then
                    lg.setColor(0, 255, 0)
                    lg.rectangle("line", a.x, a.y, a.wth, a.hgt)
                    lg.setColor(255, 255, 255)
                end
            else
                local x, y = _G[a.bind].x, _G[a.bind].y
                
                if a.centerMethod == 0 then--En haut à gauche
                    --salut
                elseif a.centerMethod == 1 then--En haut au milieu
                    x = x + (_G[a.bind].wth - a.wth)/2
                elseif a.centerMethod == 2 then--En haut à droite
                    x = x + (_G[a.bind].wth - a.wth)
                elseif a.centerMethod == 3 then--Au milieu à gauche
                    y = y + (_G[a.bind].hgt - a.hgt)/2
                elseif a.centerMethod == 4 then--Au milieu
                    y = y + (_G[a.bind].hgt - a.hgt)/2
                    x = x + (_G[a.bind].wth - a.wth)/2
                elseif a.centerMethod == 5 then--Au milieu à droite
                    y = y + (_G[a.bind].hgt - a.hgt)/2
                    x = x + (_G[a.bind].wth - a.wth)
                elseif a.centerMethod == 6 then--En bas à gauche
                    y = y + (_G[a.bind].hgt - a.hgt)
                elseif a.centerMethod == 7 then--En bas au milieu
                    y = y + (_G[a.bind].hgt - a.hgt)
                    x = x + (_G[a.bind].wth - a.wth)/2
                elseif a.centerMethod == 8 then--En bas à droite
                    y = y + (_G[a.bind].hgt - a.hgt)
                    x = x + (_G[a.bind].wth - a.wth)
                end
                
                lg.draw(src.anim[a.file], src.anim[a.file.."_"..a.frame], x, y)
                
                if debug.visible then
                    lg.setColor(0, 255, 0)
                    lg.rectangle("line", x, y, a.wth, a.hgt)
                    lg.setColor(255, 255, 255)
                end
            end
        end
    end
end