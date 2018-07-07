collision_rectToRect = function (x, y, wth, hgt, x2, y2, wth2, hgt2)--Collision rectange à rectangle
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

loadSrc = function(dir, srcType)--Chargement d'une resource
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
                rows = string.sub(spritesheetValues, rows + 1, #spritesheetValues)
                
                value[textureName] = lg.newImage(dir.."/"..v)
                
                --Itère à travers chaque sprite
                for i = 0, frames - 1 do
                    --Trouve la ligne actuel
                    local row = math.floor(i / (cols - 1))
                    
                    --Détecte si la frame actuel est en bout de ligne
                    if i % cols == 0 then row = row - 1 end
                    
                    --Trouve la colonne actuel
                    local col = i % cols
                    
                    --Trouve le point x et y de chaque frame par rapport à la colonne et la ligne
                    local frameX = (size * col) + (1 * col) + 1
                    local frameY = (size * row) + (1 * row) + 1
                    
                    if frameY == -size then frameY = 1 end
                    
                    print(i)
                    print(frameX)
                    print(frameY)
                    print()
                    
                    value[textureName.."_"..table.concat(toBits(i, 4))] = lg.newQuad(frameX + 1, frameY + 1, size, size, value[textureName]:getDimensions())
                end
                
                
                
                
                
                
                
                
                
                --[[
                update = function(self, dt)
                    --Si l'animation est activé
                    if self.event then
                        
                        ---si la frame actuel est la dernière, 
                        --alors elle passe à 0 sinon elle s'incrémente
                        self.frame = (self.frame == self.num_frames - 1) and 0 or self.frame + 1
                        
                        --Trouve la ligne actuel
                        local row = math.floor(self.frame / (self.cols + 1))
                        
                        --Détecte si la frame actuel est sur la première ligne
                        if self.frame == self.cols then row = 0 end
                        
                        --Trouve la colonne actuel
                        local col = self.frame - ((self.cols + 1) * row - 1) - 1
                        
                        --Trouve le point x et y de chaque frame par rapport à la colonne et la ligne
                        self.frameX = (self.frameWth * col) + (self.offset * col) + self.offset
                        self.frameY = (self.frameHgt * row) + (self.offset * row) + self.offset
                        
                        --Définit la frame actuelle
                        self.quad:setViewport(self.frameX, self.frameY, self.frameWth, self.frameHgt)
                    end
                end
                ]]
                
                
                
                
                
                
                
                
                
                print("frames : "..frames)
                print("size : "..size)
                print("cols : "..cols)
                print("rows : "..rows)
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
    end
    
    return value
end

loadChapter = function(chapterNumber)--Charge un chapitre
    dofile("chapters/"..chapterNumber..".lua")
    
    --Chargement de la première salle
    loadRoom(1)
end

loadRoom = function(roomNumber)--Charge un salle
    --Actualise la variable qui définit la salle actuelle
    chapter.roomNumber = roomNumber
    
    --Chargement de la salle
    chapter.rooms[roomNumber]()
    
    --Chargement de la météo
    weathers.load()
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