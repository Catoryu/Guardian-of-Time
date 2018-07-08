dofile("data/effect.lua")

effects = {}

--Effet actif de la salle (le premier effet est sélectionné pour ne pas avoir d'espace vides)
effects.current = {raw = effect[1].raw, fade = effect[1].fade, duration = 0}

effects.list = {"boxblur", "chromasep", "colorgradesimple", "crt", "desaturate", "dmg", "fastgaussianblur", 
"filmgrain", "gaussianblur", "glow", "godsray", "pixelate", "posterize", "scanlines", "sketch", "vignette"}

effects.trigger = function(effectId, duration)--Déclenche un effet pendant une certaine période
    effects.current = effect[effectId]:new({
        duration = duration,
        durationBase = duration
    })
    
    --Initialise l'effet
    effects.initialize(effects.current)
end

effects.initialize = function(effect)
    effect.raw.enable(unpack(effects.list))
    effect.raw.parameters = effect.parameters
end

effects.update = function(dt)
    if effects.current.duration > 0 then
        --Diminue le temps de vie de l'effet
        effects.current.duration = effects.current.duration - 1000*dt
        
        --Gère la disparition de l'effet
        effects.current:fade()
    else
        
        --Désactive tous les effets
        effects.current.raw.disable(unpack(effects.list))
    end
end