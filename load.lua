--Chargement des resources
local start = love.timer.getTime()

src = {}
src.font = loadSrc("resource/fonts", "font")
src.sound = loadSrc("resource/sounds", "sound")
src.anim = loadSrc("resource/animations", "animation")
src.img = {}
src.img.misc = loadSrc("resource/images/miscellaneous", "image")
src.img.bloc = loadSrc("resource/images/bloc", "image")
src.img.bground = loadSrc("resource/images/backgrounds", "image")

print((love.timer.getTime() - start) * 1000 .." ms pour le chargement des resources")