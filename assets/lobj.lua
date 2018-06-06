--[[
    Version : B.1.0
    Editor : F.Nax_OS
]]

lobj_utilities = {
    getDistance = function(x1, y1, x2, y2) return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2)) end
}

function createClass(...)
    local newClass = {}

    for _, t in ipairs({...}) do
        if type(t) == "table" then for k, v in pairs(t) do newClass[k] = v end
        else error("'createClass' arguments have to be tables.") end
    end

    newClass.__index = newClass

    newClass.new = function(self, args)
        local newChild = {}

        if type(args) == "table" then for k, v in pairs(args) do newChild[k] = v end
    elseif type(args) ~= "nil" then error("The argument to ':new' must be a table.") end

        setmetatable(newChild, self)

        return newChild
    end

    return newClass
end

--This is the master-class.
lobj = createClass({
    --WiP. Only shows values that have been modified, not the metatable's defaults.
    stats = function(self)
        local i = 0

        for k, v in pairs(self) do
            love.graphics.print(k .. " = " .. v, 10, 20 * i + 10)

            i = i + 1
        end
    end,

    --WiP.
    update = {}
})


--Class containing all shape.
lobj_shape = createClass(lobj, {
    x = 0,
    y = 0,

    --Color properties.
    colors = {
        r = 255,
        g = 255,
        b = 255,
        a = 255
    },

    --Get methods.
    getXY = function(self) return self.x, self.y end,
    getRGB = function(self) return self.colors.r, self.colors.g, self.colors.b end,
    getRGBA = function(self) return self.colors.r, self.colors.g, self.colors.b, self.colors.a end,

    --Set methods.
    setXY = function(self, x, y) self.x, self.y = x, y end,
    setRGB = function(self, r, g, b)
        if rawget(self, "colors") == nil then self.colors = {} end
        self.colors.r, self.colors.g, self.colors.b = r, g, b
    end,
    setRGBA = function(self, r, g, b, a)
        if rawget(self, "colors") == nil then self.colors = {} end
        self.colors.r, self.colors.g, self.colors.b, self.colors.a = r, g, b, a
    end,
})

--Rectangle sub-class.
lobj_shape_rectangle = createClass(lobj_shape, {
    width = 0,
    height = 0,
    cx = 0,
    cy = 0,

    drawMode = "fill",

    --Get methods.
    getCXY = function(self) return self.cx, self.cy end,
    getWH = function(self) return self.width, self.height end,
    getXYWH = function(self) return self.x, self.y, self.width, self.height end,

    --Set methods.
    setCXV = function(self, cx, cy) self.cx, self.cy = cx, cy end,
    setWH = function(self, w, h) self.width, self.height = w, h end,
    setXYWH = function(self, x, y, w, h) self.x, self.y, self.width, self.height = x, y, w, h end,

    --L2D methods.
    draw = function(self)
        love.graphics.setColor(self:getRGBA())
        love.graphics.rectangle(self.drawMode, self:getXYWH())
    end
})

--Circle sub-class.
lobj_shape_circle = createClass(lobj_shape, {
    radius = 0,

    drawMode = "fill",

    --Get methods.
    getXYR = function(self) return self.x, self.y, self.radius end,

    --Set methods.
    setXYR = function(self, x, y, radius) self.x, self.y, self.radius = x, y, radius end,

    --Collision check with an other circle.
    circleCol = function(self, x, y, radius)
        if lobj_utilities.getDistance(self.x, self.y, x, y) <= self.radius + radius then return true
        else return false end
    end,

    --Collision check with a rectangle, approximated.
    rectangleCol = function(self, approx, x, y, width, height)
        local cx = x + width / 2
        local cy = y + height / 2

        --If the rectangle is a square, call the function without the height.
        height = height or width

        --Gets center to center distance.
        cdist = lobj_utilities.getDistance(self.x, self.y, cx, cy)

        if cdist > lobj_utilities.getDistance(0, 0, width / 2, height / 2) + self.radius then return false
        elseif cdist < (width < height and width or height) + self.radius then return true
        else return approx end
    end,


    --L2D methods.
    draw = function(self)
        love.graphics.setColor(self:getRGBA())
        love.graphics.circle(self.drawMode, self:getXYR())
    end
})

--Class containing all control types.
lobj_control = createClass(lobj, {
    --Speed properties.
    speed = 0,
    xspdr = 0,
    yspdr = 0,

    --Get methods.
    getSpeeds = function(self) return self.speed, self.xspdr, self.yspdr end,

    --Set methods.
    setSpeeds = function(self, speed, xspdr, yspdr) self.speed, self.xspdr, self.yspdr = speed, xspdr, yspdr end
})

--Sub-class allowing to control an object with certain keys.
lobj_control_keyboard = createClass(lobj_control, {
    keys = {
        up = "",
        down = "",
        left = "",
        right = ""
    },

    --Get methods.
    getKeys = function(self) return self.keys.up, self.keys.down, self.keys.left, self.keys.right end,

    --Set methods.
    setKeys = function(self, up, left, down, right) self.keys.up, self.keys.down, self.keys.left, self.keys.right = up, down, left, right end,

    --/!\ This method requires an x, y and speed value on the invoker.
    move = function(self)
        local dt = love.timer.getDelta()

        if love.keyboard.isDown(self.keys.up) then self.y = self.y - self.speed * dt end
        if love.keyboard.isDown(self.keys.down) then self.y = self.y + self.speed * dt end
        if love.keyboard.isDown(self.keys.left) then self.x = self.x - self.speed * dt end
        if love.keyboard.isDown(self.keys.right) then self.x = self.x + self.speed * dt end
    end
})

--Sub-class allowing to control an object with mouse cursor position.
lobj_control_mouse = createClass(lobj_control, {

})

--Class containing extra content like sounds, animation and images.
lobj_content = createClass(lobj, {

})

lobj_content_animation = createClass(lobj_content, {
    ax = 0,
    ay = 0,
    awidth = 0,
    aheight = 0,
    spriteSheetPath = "",

    atimer = 0,
    aframeTime = 1 / 30,

    init = function(self)
        self.spriteSheet = love.graphics.newImage(self.spriteSheetPath)
        self.quad = love.graphics.newQuad(self.ax, self.ay, self.awidth, self.aheight)
    end,
})
