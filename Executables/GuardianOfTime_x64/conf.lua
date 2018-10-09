--Téléchargement de la version 0.10.2 de LÖVE
--https://bitbucket.org/rude/love/downloads/love-0.10.2-win64.exe

function love.conf(t) 
    t.identity = nil                    -- The name of the save directory (string) 
    t.version = "0.10.2"                -- The LÖVE version this game was made for (string) 
    t.console = true                    -- Attach a console (boolean, Windows only) 
    t.accelerometerjoystick = true      -- Enable the accelerometer on iOS and Android by exposing it as a Joystick (boolean) 
    t.externalstorage = false           -- True to save files (and read from the save directory) in external storage on Android (boolean)
    t.gammacorrect = false              -- Enable gamma-correct rendering, when supported by the system (boolean) 

    t.window.title = wdow.title         -- The window title (string)
    t.window.icon = nil                 -- Filepath to an image to use as the window's icon (string)
    t.window.width = wdow.wth           -- The window width (number)
    t.window.height = wdow.hgt          -- The window height (number)
    t.window.borderless = false         -- Remove all border visuals from the window (boolean)
    t.window.resizable = false          -- Let the window be user-resizable (boolean)
    t.window.minwidth = 1               -- Minimum window width if the window is resizable (number)
    t.window.minheight = 1              -- Minimum window height if the window is resizable (number)
    t.window.fullscreen = false         -- Enable fullscreen (boolean)
    t.window.fullscreentype = "desktop" -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
    t.window.vsync = false              -- Enable vertical sync (boolean)
    t.window.msaa = 0                   -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.display = 1                -- Index of the monitor to show the window in (number)
    t.window.highdpi = false            -- Enable high-dpi mode for the window on a Retina display (boolean)
    t.window.x = nil                    -- The x-coordinate of the window's position in the specified display (number) 
    t.window.y = nil                    -- The y-coordinate of the window's position in the specified display (number) 
  
    t.modules.audio = true              -- Enable the audio module (boolean) 
    t.modules.event = true              -- Enable the event module (boolean) 
    t.modules.graphics = true           -- Enable the graphics module (boolean) 
    t.modules.image = true              -- Enable the image module (boolean) 
    t.modules.joystick = true           -- Enable the joystick module (boolean) 
    t.modules.keyboard = true           -- Enable the keyboard module (boolean) 
    t.modules.math = true               -- Enable the math module (boolean) 
    t.modules.mouse = true              -- Enable the mouse module (boolean) 
    t.modules.physics = true            -- Enable the physics module (boolean) 
    t.modules.sound = true              -- Enable the sound module (boolean) 
    t.modules.system = true             -- Enable the system module (boolean) 
    t.modules.timer = true              -- Enable the timer module (boolean), Disabling it will result 0 delta time in love.update 
    t.modules.touch = true              -- Enable the touch module (boolean) 
    t.modules.video = true              -- Enable the video module (boolean) 
    t.modules.window = true             -- Enable the window module (boolean) 
    t.modules.thread = true             -- Enable the thread module (boolean) 
end

--Configuration de la fenêtre
wdow = {}
wdow.mode = false
wdow.wth = 1280
wdow.hgt = 720
wdow.title = "Guardian of Time"
wdow.shake = {}
wdow.shake.x = 0
wdow.shake.y = 0
wdow.shake.directionX = false
wdow.shake.directionY = false
wdow.shake.maxX = 8
wdow.shake.maxY = 10
wdow.shake.spd = 800 --ms, temps pour un tremblement d'aller de maxX à -maxX
wdow.shake.duration = 0 --ms
wdow.update = function(dt)
    --Gère le tremblement de l'écran
    if wdow.shake.duration > 0 then
        wdow.shake.duration = wdow.shake.duration - 1000*dt
        
        if wdow.shake.directionX then
            wdow.shake.x = wdow.shake.x + wdow.shake.spd*dt
            if wdow.shake.x > wdow.shake.maxX then
                wdow.shake.x = wdow.shake.maxX
                wdow.shake.directionX = not wdow.shake.directionX
            end
        else
            wdow.shake.x = wdow.shake.x - wdow.shake.spd*dt
            if wdow.shake.x < -wdow.shake.maxX then
                wdow.shake.x = -wdow.shake.maxX
                wdow.shake.directionX = not wdow.shake.directionX
            end
        end
        
        if wdow.shake.directionY then
            wdow.shake.y = wdow.shake.y + wdow.shake.spd*dt
            if wdow.shake.y > wdow.shake.maxY then
                wdow.shake.y = wdow.shake.maxY
                wdow.shake.directionY = not wdow.shake.directionY
            end
        else
            wdow.shake.y = wdow.shake.y - wdow.shake.spd*dt
            if wdow.shake.y < -wdow.shake.maxY then
                wdow.shake.y = -wdow.shake.maxY
                wdow.shake.directionY = not wdow.shake.directionY
            end
        end
    else
        wdow.shake.x = 0
        wdow.shake.y = 0
    end
end

--Valeur de deboguage
debug = {}
debug.visible = true
debug.font = src.font.consola
debug.color = {0, 200, 0}
debug.mouseHelpText = lg.newCanvas(300, 220)
debug.gamepadHelpText = lg.newCanvas(300, 140)
lg.setCanvas(debug.mouseHelpText)
    love.graphics.clear()
    lg.setFont(debug.font)
    lg.setColor(180, 180, 180, 200)
    lg.rectangle("fill", 0, 0, 300, 220)
    lg.setColor(0, 0, 0)
    lg.print("Controls : ", 10, 10)
    lg.print("[TAB] Permet d'afficher/cacher les menus", 10, 30)
    lg.print("[G] Permet d'afficher/cacher la grille", 10, 50)
    lg.print("[clic gauche] Permet de créer une entité", 10, 70)
    lg.print("[clic droit] Permet de créer un bloc", 10, 90)
    lg.print("[molette] Change l'entité créé", 10, 110)
    lg.print("[shift + molette] Change le bloc créé", 10, 130)
    lg.print("[DELETE] Supprime la dernière entité", 10, 150)
    lg.print("[Backspace] Supprime le dernier bloc", 10, 170)
    lg.print("[ESC] Quitte le programme", 10, 190)
lg.setCanvas()

lg.setCanvas(debug.gamepadHelpText)
    love.graphics.clear()
    lg.setFont(debug.font)
    lg.setColor(180, 180, 180, 200)
    lg.rectangle("fill", 0, 0, 300, 140)
    lg.setColor(0, 0, 0)
    lg.print("Controls : ", 10, 10)
    lg.print("[BACK] Permet d'afficher/cacher les menus", 10, 30)
    lg.print("[X] Permet d'afficher/cacher la grille", 10, 50)
    lg.print("[LB] Supprime la dernière entité", 10, 70)
    lg.print("[RB] Supprime le dernier bloc", 10, 90)
    lg.print("[START] Quitte le programme", 10, 110)
lg.setCanvas()

--Valeurs utile à la manette
gamepad = {}
gamepad.joystick = love.joystick.getJoysticks()[1]
gamepad.offset = 0.4