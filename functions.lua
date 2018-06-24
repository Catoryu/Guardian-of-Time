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

--Permet de rapprocher d'amener une valeur à zero
toZero = function(value, step)
    if value > 0 then
        if value - step < 0 then
            value = 0
        else
            value = value - step
        end
    elseif value < 0 then
        if value + step > 0 then
            value = 0
        else
            value = value + step
        end
    end
    
    return value
end

loadSrc = function(dir, srcType)
    --Itère à travers tous les fichiers d'un dossier
    --Ajoute dans un tableau une variable associative qui porte le nom du fichier (sans l'extension)
    --Cette variable a comme valeur l'objet love2d souhaité (srcType)
    --Attention les extensions doivent avoir 3 caractères (.png, .jpg)
    
    value = {}
    
    if srcType == "image" then
        for i, v in pairs(love.filesystem.getDirectoryItems(dir)) do
            value[string.sub(v, 1, #v - 4)] = lg.newImage(dir.."/"..v)
        end
    elseif srcType == "font" then
        for i, v in pairs(love.filesystem.getDirectoryItems(dir)) do
            value[string.sub(v, 1, #v - 4)] = lg.newFont(dir.."/"..v)
        end
    end
    
    return value
end

loadChapter = function(chapterNumber)
    dofile("chapters/"..chapterNumber..".lua")
    
    --Chargement de la première salle
    rooms.load[1]()
end