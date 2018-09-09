animations = {}

--Cette table contiendra toutes les animations qui sont immigrées
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
            
            lg.setColor(a.r, a.g, a.b, a.a)
            
            local x, y = 0
            
            if a.bind == "" then
                x, y = a.x, a.y
            else
                x, y = _G[a.bind].x, _G[a.bind].y
            end
            
            if a.isInvertedX then
                x = x + a.wth
                a.sx = -a.sx
                a.ox = -a.ox
            end
            
            if a.isInvertedY then
                y = y + a.hgt
                a.sy = -a.sy
                a.oy = -a.oy
            end
            
            lg.draw(src.anim[a.file], src.anim[a.file.."_"..a.frame], x + wdow.shake.x, y + wdow.shake.y, a.rotation, a.sx, a.sy, a.ox, a.oy, a.kx, a.ky)
            
            if debug.visible then
                lg.setColor(0, 255, 0)
                
                x = x - a.ox*a.sx
                y = y - a.oy*a.sy
                
                local wth = a.wth*a.sx
                local hgt = a.hgt*a.sy
                
                lg.line(x, y, x + wth, y, x + wth, y + hgt, x, y + hgt, x, y)
            end
            
            if a.isInvertedX then
                x = x - a.wth
                a.sx = -a.sx
                a.ox = -a.ox
            end
            
            if a.isInvertedY then
                y = y - a.hgt
                a.sy = -a.sy
                a.oy = -a¨.oy
            end
        end
    end
end


animation_class = {
    x = 0,
    y = 0,
    file = "",
    frames = 0,
    frame = 0,
    fps = 0,
    
    file = "",
    timer = 0,
    bind = "",
    wth = 0,
    hgt = 0,
    cols = 0,
    rows = 0,
    centerMethod = 0,
    
    isVisible = true,
    isLooping = false,
    isPlaying = true,
    isInvertedX = false,
    isInvertedY = false,
    
    r = 255,
    g = 255,
    b = 255,
    a = 255,
    
    rotation = 0,
    sx = 1,
    sy = 1,
    ox = 0,
    oy = 0,
    kx = 0,
    ky = 0,
    
    update = function(self, dt)
        if self.isPlaying then
            
            self.timer = self.timer - dt
            
            if self.timer <= 0 then
                self.timer = 1 / self.fps
                self.frame = self.frame + 1
                
                
                if self.frame >= self.frames then
                    if self.isLooping then
                        self.frame = 0
                    else
                        self.frame = self.frame - 1
                        self.isPlaying = false
                    end
                end
            end
        end
    end,
    
    draw = function(self)
        if self.isVisible then
            
            lg.setColor(self.r, self.g, self.b, self.a)
            
            local x, y = 0
            
            if self.bind == "" then
                x, y = self.x, self.y
            else
                x, y = _G[self.bind].x, _G[self.bind].y
            end
            
            if self.isInvertedX then
                x = x + self.wth
                self.sx = -self.sx
                self.ox = -self.ox
            end
            
            if self.isInvertedY then
                y = y + self.hgt
                self.sy = -self.sy
                self.oy = -self.oy
            end
            
            lg.draw(src.anim[self.file], src.anim[self.file.."_"..self.frame], x + wdow.shake.x, y + wdow.shake.y, self.rotation, self.sx, self.sy, self.ox, self.oy, self.kx, self.ky)
            
            if debug.visible then
                lg.setColor(0, 255, 0)
                
                x = x - self.ox*self.sx
                y = y - self.oy*self.sy
                
                local wth = self.wth*self.sx
                local hgt = self.hgt*self.sy
                
                lg.line(x, y, x + wth, y, x + wth, y + hgt, x, y + hgt, x, y)
            end
        
            if self.isInvertedX then
                self.sx = -self.sx
                self.ox = -self.ox
            end
            
            if self.isInvertedY then
                self.sy = -self.sy
                self.oy = -self.oy
            end
        end
    end
}


newClass(animation_class)

--Cette table contiendra toutes les animations lors du chargement de celles-ci
animation = {}