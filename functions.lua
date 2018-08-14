collision_rectToRect = function (x, y, wth, hgt, x2, y2, wth2, hgt2)--Collision rectange à rectangle
    if (x + wth > x2 and x < x2 + wth2) and
    (y + hgt > y2 and y < y2 + hgt2) then
        return true
    else
        return false
    end

--    local w = 0.5 * (wth + wth2)
--    local h = 0.5 * (hgt + hgt2)
--    local dx = (x + wth/2) - (x2 + wth2/2)
--    local dy = (y + hgt/2) - (y2 + hgt2/2)
    
--    if math.abs(dx) <= w and math.abs(dy) <= h then
--        wy = w * dy
--        hx = h * dx
        
--        if (wy > hx) then
--            if (wy > -hx) then
--                --En bas
--                return 2
--            else
--                --A gauche
--                return 3
--            end
--        else
--            if (wy > -hx) then
--                --A droite
--                return 4
--            else
--                --En haut
--                return 1
--            end
--        end
--    else
--        --Aucune collision
--        return false
--    end
end

collision_rectToCircle = function(rectX, rectY, rectWth, rectHgt, circleX, circleY, circleRad)--Collision rectangle à cercle
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

collision_circleToCircle = function(x, y, rad, x2, y2, rad2)--Collision cercle à cercle
    if math.sqrt(math.pow(x - x2, 2) + math.pow(y - y2, 2)) <= rad + rad2 then return true
    else return false end
end

toZero = function(value, step)--Permet de rapprocher d'amener une valeur à zero
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

loadSrc = function(dir, srcType, option)--Chargement d'une resource
    --Itère à travers tous les fichiers d'un dossier
    --Ajoute dans un tableau une variable associative qui porte le nom du fichier (sans l'extension)
    --Cette variable a comme valeur l'objet love2d souhaité (srcType)
    --Retourne un tableau avec les valeurs chargés
    
    --Attention les extensions doivent avoir 3 caractères (.png, .jpg, .ttf)
    
    --Si le nom de l'image contient un "_" après le nom de l'image, alors c'est une spritesheet
    --Chaque lettre correspond à une info sur la spritesheet (les lettres doivent être dans le bon ordre)
    --f : nombre d'images
    --s : taille de chaque image (en pixel)
    --c : nombre de colonnes
    --r : nombre de lignes
    
    value = {}
    
    if srcType == "image" then
        for i, v in pairs(love.filesystem.getDirectoryItems(dir)) do
            
            --Récupère le nom du fichier sans l'extension
            fileName = string.sub(v, 1, #v - 4)
            
            --Test si c'est une spritesheet
            isSpritesheet = string.find(fileName, "_")
            
            if isSpritesheet then
                --Récupère le nom de la texture (par exemple "stone")
                textureName = string.sub(v, 1, isSpritesheet - 1)
                
                --Récupère la partie des valeurs du spritesheet (par exemple "f6s16c4r2")
                spritesheetValues = string.sub(v ,isSpritesheet + 1, #v)
                
                --Récupère l'emplacement dans la chaine de caractère du nombre de frames, la taille des images, le nombre de colonnes et le nombre de lignes
                local frames = string.find(spritesheetValues, "f")
                local size = string.find(spritesheetValues, "s")
                local cols = string.find(spritesheetValues, "c")
                local rows = string.find(spritesheetValues, "r")
                
                --Récupère le nombre de frames, la taille des images, le nombre de colonnes et le nombre de lignes
                frames = string.sub(spritesheetValues, frames + 1, size - 1)
                size = string.sub(spritesheetValues, size + 1, cols - 1)
                cols = string.sub(spritesheetValues, cols + 1, rows - 1)
                rows = string.sub(spritesheetValues, rows + 1, #spritesheetValues - 4)
                
                --Crée l'image qui contient tous les sprites
                value[textureName] = lg.newImage(dir.."/"..v)
                
                --Itère à travers chaque sprite
                for i = 1, frames do
                    --Trouve la ligne actuel
                    local row = math.floor(i / (cols))
                    
                    --Détecte si la frame actuel est en bout de ligne
                    if i % cols == 0 then row = row - 1 end
                    
                    if row == -1 then row = 0 end
                    
                    --Trouve la colonne actuel
                    local col = (i-1) % cols
                    
                    --Trouve le point x et y de chaque frame par rapport à la colonne et la ligne
                    local frameX = 1 + col * 2 + col * size
                    local frameY = 1 + row * 2 + row * size
                    
                    value[textureName.."_"..table.concat(toBits(i-1, 4))] = lg.newQuad(frameX, frameY, size, size, value[textureName]:getDimensions())
                end
            else
                --Crée une variable qui porte le nom de la texture
                value[fileName] = lg.newImage(dir.."/"..v)
            end
        end
    elseif srcType == "font" then
        for i, v in pairs(love.filesystem.getDirectoryItems(dir)) do
            --Récupère le nom du fichier sans l'extension
            fileName = string.sub(v, 1, #v - 4)
            
            --Crée une variable qui porte le nom de la police d'écriture
            value[fileName] = lg.newFont(dir.."/"..v)
        end
    elseif srcType == "sound" then
        for i, v in pairs(love.filesystem.getDirectoryItems(dir)) do
            --Récupère le nom du fichier sans l'extension
            fileName = string.sub(v, 1, #v - 4)
            
            --Crée une variable qui porte le nom du fichier audio
            if option then
                value[fileName] = love.audio.newSource(dir.."/"..v, "static")
            else
                value[fileName] = love.audio.newSource(dir.."/"..v)
            end
        end
    else
        error("srcType unknown in function : loadSrc")
    end
    
    return value
end

loadChapter = function(chapterNumber)--Charge un chapitre
    dofile("chapters/"..chapterNumber..".lua")
    
    --Chargement de la première salle
    loadRoom(1)
end

loadRoom = function(roomNumber)--Charge un salle
    local start = love.timer.getTime()
    
    --Actualise la variable qui définit la salle actuelle
    chapter.roomNumber = roomNumber
    
    --Chargement de la salle
    chapter.rooms[roomNumber]()
    
    --Chargement de la météo
    weathers.load()
    
    --Réinitialisation des événements
    for i, v in pairs(chapter.events) do
        if v.isRoomReseted and v.room == roomNumber then
            chapter.events[i] = event[v.id]:new({x = v.x, y = v.y, wth = v.wth, hgt = v.hgt, room = v.room})
        end
    end
    
    --Vérifie que la table des blocs en premier plan existe
    if room.blocs[1] == nil then
        room.blocs[1] = {}
    end
    
    print((love.timer.getTime() - start) * 1000 .." ms pour le chargement de la salle")
end

spairs = function(t, order)--Permet de trier les valeurs d'une table
    --https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function toBits(num,bits)--Convertit un nombre en binaire
  -- returns a table of bits, most significant first.
  bits = bits or math.max(1, select(2, math.frexp(num)))
  local t = {} -- will contain the bits        
  for b = bits, 1, -1 do
    t[b] = math.fmod(num, 2)
    num = math.floor((num - t[b]) / 2)
  end
  return t
end

mergeColors = function(color1, color2)--Combine deux couleurs
    color = {0, 0, 0, 0}
    
    --Si une valeur n'est pas défini, passe à 255
    for i = 1, 4 do
        if not color1[i] then color1[i] = 255 end
        if not color2[i] then color2[i] = 255 end
    end
    
    --Rouge, vert, bleu, alpha
    color[1] = (color1[1] + color2[1]) / 2
    color[2] = (color1[2] + color2[2]) / 2
    color[3] = (color1[3] + color2[3]) / 2
    color[4] = (color1[4] + color2[4]) / 2
    
    return color
end

shakeScreen = function(duration, shakeX, shakeY, spd, isPlayerShaken)--Secoue l'écran
    --Définit des valeurs de base pour la secousse de l'écran
    if duration == nil then duration = 500 end
    if shakeX == nil then shakeX = 8 end
    if shakeY == nil then shakeY = 10 end
    if spd == nil then spd = 800 end
    if isPlayerShaken == nil then isPlayerShaken = true end
    
    wdow.shake.duration = duration
    wdow.shake.maxX = shakeX
    wdow.shake.maxY = shakeY
    wdow.shake.spd = spd
    wdow.shake.isPlayerShaken = isPlayerShaken
end

chance = function(val)
    random = math.random(0, 100) + math.random()
    
    if random < val then
        return true
    else
        return false
    end
end