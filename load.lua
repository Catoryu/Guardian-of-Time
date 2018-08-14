--Chargement des resources
local start = love.timer.getTime()

src = {}
src.font = loadSrc("resource/fonts", "font")
src.sound = loadSrc("resource/sound", "sound")
src.anim = {}
src.img = {}
src.img.cursor = lg.newImage("resource/miscellaneous/cursor 32x32.png")
src.img.bloc = loadSrc("resource/bloc", "image")
src.img.bground = loadSrc("resource/backgrounds", "image")

print((love.timer.getTime() - start) * 1000 .." ms pour le chargement des resources")