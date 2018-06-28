dofile("data/event.lua")

--Table qui contient tous les fonctions concernant les événements
events = {}

events.update = function(dt)--Vérification du déclenchement des événements
    for i, v in pairs(chapter.events) do
        --Si l'événement est dans la même salle du joueur
        if v.room == chapter.roomNumber then
            
            --Si l'événement est déclenché par un contact par le joueur
            if v.touch then
                
                --Test si le joueur touche l'événement
                if collision_rectToRect(player.x, player.y, player.wth, player.hgt, v.x, v.y, v.wth, v.hgt) ~= 0 then
                    --Déclenche l'événement
                    v:onTouch()
                end
            end
            
            --Si l'événement est déclenché au bout d'un moment
            if v.ttlReach then
                
                --Diminue la durée avant que l'événement commence
                v.ttl = v.ttl - dt
                
                --Test si la durée avant que l'événement commence est inférieur ou égale à 0
                if v.ttl <= 0 then
                    --Déclenche l'événement
                    v:onTtlReach()
                end
            end
        end
    end
end

events.draw = function()--Debug, ne sera pas la dans la version finale
    lg.setColor(255, 0, 0)
    
    --Dessine tous les événements (debug)
    for i, v in pairs(chapter.events) do
        if v.room == chapter.roomNumber then
            lg.rectangle("line", v.x, v.y, v.wth, v.hgt)
        end
    end
end