--Class des événements
event_class = {
    id = 1,
    x = 0,
    y = 0,
    wth = 0,
    hgt = 0,
    ttl = 0, --Durée de vie de l'event (valeur en ms)
    room = 0,
    ttlReach = false,--Définit si l'événement est déclenché par le temps
    touch = false,--Définit si l'événement est déclenché par le contact avec le joueur
    onTtlReach = false,--Définit les instructions si l'événement est déclenché par le temps
    onTouch = false--Définit les instructions si l'événement est déclenché par un contact avec le joueur
}

--Un peu de magie dans ce monde de brutes
setmetatable(event_class, {__index = event_class})

--Permet de créer un objet en utilisant une classe
function event_class:new (t)
    t = t or {} --Crée une table si l'utilisateur n'en passe pas dans la fonction
    setmetatable(t, self)
    self.__index = self
    return t
end

event = {
    --Active la pluie
    event_class:new({
        id = 1,
        touch = true,
        onTouch = function(self)
            print(string.format("Evenement 1 declenche a %.2f s", time))
            weathers.id = 2
            weathers.load()
            self.touch = false
        end,
    }),

    --Active l'effet "flashbang"
    event_class:new({
        id = 2,
        touch = true,
        onTouch = function(self)
            print(string.format("Evenement 2 declenche a %.2f s", time))
            effects.trigger(1, 1300)
            self.touch = false
        end,
    }),

    --Active l'effet de brulure
    event_class:new({
        id = 3,
        touch = true,
        onTouch = function(self)
            print(string.format("Evenement 3 declenche a %.2f s", time))
            effects.trigger(2, 3000)
            self.touch = false
        end,
    })
}