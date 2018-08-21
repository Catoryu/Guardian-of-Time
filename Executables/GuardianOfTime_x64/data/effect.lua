--Appel de la librairie de filtres
moonshine = require 'assets/moonshine-master'

effect_class = {
    raw = nil,
    fade = nil,
    duration = nil,
    durationBase = nil,
    parameterBase = nil
}

--Un peu de magie dans ce monde de brutes
setmetatable(effect_class, {__index = effect_class})

--Permet de créer un objet en utilisant une classe
function effect_class:new (t)
    t = t or {} --Crée une table si l'utilisateur n'en passe pas dans la fonction
    setmetatable(t, self)
    self.__index = self
    return t
end

effect = {
    --Temps idéale min : 1300 max : 3000
    effect_class:new({--Trowing a flashbang
        raw = moonshine(moonshine.effects.boxblur)
            .chain(moonshine.effects.vignette),
        parameters = {
            boxblur = {radius = {3, 3}},
            vignette = {
                radius = 0,
                softness = 0.1,
                opacity = 1,
                color = {255, 255, 255}
            }
        },
        fade = function(self)
            if self.duration < 800 then
                self.raw.vignette.opacity = 0.9 * self.duration / 800
                self.raw.boxblur.radius = 3 * self.duration / 800
            end
        end
    }),
    
    --Temps idéale min : 1000 max : infinite
    effect_class:new({--CA BRULE
        raw = moonshine(moonshine.effects.vignette)
            .chain(moonshine.effects.colorgradesimple),
        parameters = {
            vignette = {
                radius = 0.8,
                softness = 0.8,
                opacity = 0.5,
                color = {200, 40, 0}
            },
            colorgradesimple = {
                factors = {1.3, 1.2, 0.9}
            }
        },
        fade = function(self)
            if self.duration < 800 then
                self.raw.vignette.opacity = 0.5 * self.duration / 800
                
                self.raw.colorgradesimple.factors = {
                    1 + (1.3 - 1) * self.duration / 800,
                    1 + (1.2 - 1) * self.duration / 800,
                    1 + (0.9 - 1) * self.duration / 800
                }
            else
                self.raw.vignette.opacity = love.math.noise(time)
            end
        end
    }),
}