--Collision rectange à rectangle
collision_rectToRect = function (x, y, wth, hgt, x2, y2, wth2, hgt2)
    local w = 0.5 * (wth + wth2)
    local h = 0.5 * (hgt + hgt2)
    local dx = (x + wth/2) - (x2 + wth2/2)
    local dy = (y + hgt/2) - (y2 + hgt2/2)
    
    if math.abs(dx) <= w and math.abs(dy) <= h then
        wy = w * dy
        hx = h * dx
        
        if (wy > hx) then
            if (wy > -hx) then
                --En bas
                return 2
            else
                --A gauche
                return 3
            end
        else
            if (wy > -hx) then
                --A droite
                return 4
            else
                --En haut
                return 1
            end
        end
    else
        --Aucune collision
        return 0
    end
end

--Collision rectangle à cercle
collision_rectToCircle = function(rectX, rectY, rectWth, rectHgt, circleX, circleY, circleRad)
    local x = rectX + rectWth/2
    local y = rectY + rectHgt/2

    local circleDistanceX = math.abs(circleX - x)
    local circleDistanceY = math.abs(cirlceY - y)

    if (circleDistanceX > (rectWth/2 + circleRad)) then return false end
    if (circleDistanceY > (rectHgt/2 + circleRad)) then return false end

    if (circleDistanceX <= (rectWth/2)) then return true end
    if (circleDistanceY <= (rectHgt/2)) then return true end

    local cornerDistance_sq = (circleDistanceX - rectWth/2)^2 + (circleDistanceY - rectHgt/2)^2

    return (cornerDistance_sq <= (circleRad^2))
end

--Collision cercle à cercle
collision_circleToCircle = function(x, y, rad, x2, y2, rad2)
    if math.sqrt(math.pow(x - x2, 2) + math.pow(y - y2, 2)) <= rad + rad2 then return true
    else return false end
end