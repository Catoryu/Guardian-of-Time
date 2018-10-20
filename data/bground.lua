bgroundLayer_class = {
    x = 0,
    y = 0,
    image = "",
    distanceX = 0,
    distanceY = 0,
    
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
    
    isVisible = true,
    isOnFront = false
}

newClass(bgroundLayer_class)

bground_class = {
    id = 0,
    name = "",
    layers = {},
    
    isVisible = true,
}

newClass(bground_class)

bground = {
    bground_class:new({
        id = 1,
        name = "collines",
        layers = {
            bgroundLayer_class:new({image = "collines1", distanceX = 0, distanceY = 0}),
            bgroundLayer_class:new({image = "collines2", distanceX = 15, distanceY = 5}),
            bgroundLayer_class:new({image = "collines3", distanceX = 25, distanceY = 10}),
            bgroundLayer_class:new({image = "collines4", distanceX = 30, distanceY = 15}),
            bgroundLayer_class:new({image = "collines5", distanceX = 40, distanceY = 20}),
            bgroundLayer_class:new({image = "collines6", isOnFront = true, distanceX = 120, distanceY = 30})
        }
    }),
    
    bground_class:new({
        id = 2,
        name = "midnight",
        layers = {
            bgroundLayer_class:new({image = "midnight1", distanceX = 0, distanceY = 0}),
            bgroundLayer_class:new({image = "midnight2", distanceX = 15, distanceY = 5}),
            bgroundLayer_class:new({image = "midnight3", distanceX = 30, distanceY = 10}),
            bgroundLayer_class:new({image = "midnight4", distanceX = 40, distanceY = 15})
        }
    })
}