dofile("data/event.lua")

--Table qui contient tous les fonctions concernant les événements
events = {}

events.update = function(dt)--Vérification du déclenchement des événements
    for i, v in pairs(chapter.events) do
        --Si l'événement est dans la même salle du joueur
        if v.room == chapter.roomNumber then
            
            --Test si le joueur touche l'événement
            if collision_rectToRect(player.x, player.y, player.wth, player.hgt, v.x, v.y, v.wth, v.hgt) ~= 0 then
                
                if not v.isPlayerIn then
                    --Déclenche l'événement correspondant
                    if v.activeEvent.enter then
                        v:onEnter()
                    end
                    
                    v.isPlayerIn = true
                end
                
                --Déclenche l'événement correspondant
                if v.activeEvent.touch then
                    v:onTouch()
                end
            else
                if v.isPlayerIn then
                    --Déclenche l'événement correspondant
                    if v.activeEvent.leave then
                        v:onLeave()
                    end
                    
                    v.isPlayerIn = false
                end
            end
            
            --Si l'événement est déclenché au bout d'un moment
            if v.activeEvent.ttlReach then
                
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
            lg.print(tostring(v.isPlayerIn), v.x, v.y)
        end
    end
end