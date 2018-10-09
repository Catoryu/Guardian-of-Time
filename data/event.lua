--Class des événements
event_class = {
    id = 1,
    x = 0,
    y = 0,
    wth = 0,
    hgt = 0,
    ttl = 0, --Durée de vie de l'event (valeur en ms)
    room = 0,
    isRoomReseted = false, --Définit si l'événement est réinitialisé si on change de salle
    isPlayerIn = false, --Définit si le joueur se situe dans l'événement
    
    --Définit quel fonction sont activé
    ttlReach = false,
    touch = false,
    enter = false,
    leave = false,
    
    onTtlReach = false, --Définit les instructions si l'événement est déclenché par le temps
    onTouch = false, --Définit les instructions si l'événement est déclenché par un contact avec le joueur
    onEnter = false, --Définit les instructions si l'événement est déclenché par l'entrée en contact avec le joueur
    onLeave = false --Définit les instructions si l'événement est déclenché par la sortie du contact avec le joueur
}

newClass(event_class)

event = {
    --Inverse la pluie (normal <---> forte)
    event_class:new({
        id = 1,
        isRoomReseted = true,
        enter = true,
        onEnter = function(self)
            print(("Evenement 1 declenche a %.2f s"):format(time))
            weathers.id = (weathers.id == 1) and 2 or 1
            weathers.load()
            self.enter = false
        end,
    }),

    --Active l'effet "flashbang"
    event_class:new({
        id = 2,
        enter = true,
        onEnter = function(self)
            print(("Evenement 2 declenche a %.2f s"):format(time))
            effects.trigger(1, 1300)
        end,
    }),

    --Active l'effet de brulure
    event_class:new({
        id = 3,
        enter = true,
        onEnter = function(self)
            print(("Evenement 3 declenche a %.2f s"):format(time))
            effects.trigger(2, 3000)
        end,
    }),
    
    --Secoue l'écran
    event_class:new({
        id = 4,
        enter = true,
        onEnter = function(self)
            print(("Evenement 4 declenche a %.2f s"):format(time))
            shakeScreen()
        end,
    }),

    --Alterne toutes les météos en les chargeant de façon "smooth"
    event_class:new({
        id = 5,
        enter = true,
        onEnter = function(self)
            print(("Evenement 5 declenche a %.2f s"):format(time))
            local id = weathers.id + 1
            if id > #weather - 1 then id = 1 end
            weathers.softChange(id)
        end,
    })
}