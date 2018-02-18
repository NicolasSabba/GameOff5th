local functions = {}

function functions:musicUp()
    local music = getMusicVolume() * 100
    if music < 91 then
        music = (music + 10) / 100
        setMusicVolume(music)
    end
end
        
function functions:musicDown()
    local music = getMusicVolume() * 100
    if music > 9 then
        music = (music - 10) / 100
        setMusicVolume(music)
    end
end

function functions:sfxUp()
    local sfx = getSfxVolume() * 100
    if sfx < 91 then
        sfx = (sfx + 10) / 100
        setSfxVolume(sfx)
    end
end

function functions:sfxDown()
    local sfx = getSfxVolume() * 100
    if sfx > 9 then
        sfx = (sfx - 10) / 100
        setSfxVolume(sfx)
    end
end

function functions:screenDown()
    local ww, wh, options = love.window.getMode()
    if not options.fullscreen and ww > 800 then
        resizeWindows(ww - 400, wh - 300, options)
    elseif options.fullscreen then
        options.fullscreen = false
        ww = 1600
        wh = 1200
        resizeWindows(ww, wh, options)
    end
end

function functions:screenUp()
    local ww, wh, options = love.window.getMode()
    if not options.fullscreen and ww < 1600 then
        resizeWindows(ww + 400, wh + 300, options)
    elseif not options.fullscreen and ww == 1600 then
        options.fullscreen = true
        resizeWindows(ww, wh, options)
    end
end

return functions