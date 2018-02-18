local options = {}

local input, canvas, functions, text

function options:load()

    love.mouse.setVisible(false)

    input = require('plugins/simpleKey')
    input:keyInit({'w', 's', 'a', 'd', 'up', 'down', 'left', 'right', 'return'})

    canvas = require('plugins/dCanvas')

    functions = require('options/functions')

    -- All posible text
    text = {
        'MUSIC ' .. getMusicVolume()*100,
        'SFX ' .. getSfxVolume()*100,
        'FULL SCREEN',
        'EXIT'
    }

    -- Draw the canvas for the 1 time
    canvas:init(text)

    local ww, wh, options = love.window.getMode()
    if options.fullscreen then
        text[3] = 'FULL SCREEN'
    else 
        text[3] = ww .. 'x' .. wh
    end

    canvas.update()

end

function options:update(dt)

    input:updateInput()

    -- Move the arrow
    if input:isReleased('w') or input:isReleased('up') then 
        canvas.up()
    end
    if input:isReleased('s') or input:isReleased('down') then
        canvas.down()
    end

    if input:isReleased('a') or input:isReleased('left') then
        if canvas.arrow == 0 then
            functions:musicDown()
            text[1] = 'MUSIC ' .. getMusicVolume()*100
            canvas.update()
        end
        if canvas.arrow == 1 then
            functions:sfxDown()
            text[2] = 'SFX ' .. getSfxVolume()*100
            canvas.update()
        end
        if canvas.arrow == 2 then
            functions:screenDown()
            local ww, wh, options = love.window.getMode()
            if options.fullscreen then
                text[3] = 'FULL SCREEN'
            else 
                text[3] = ww .. 'x' .. wh
            end
            canvas.update()
        end
    end 

    if input:isReleased('d') or input:isReleased('right') then
        if canvas.arrow == 0 then
            functions:musicUp()
            text[1] = 'MUSIC ' .. getMusicVolume()*100
            canvas.update()
        end
        if canvas.arrow == 1 then
            functions:sfxUp()
            text[2] = 'SFX ' .. getSfxVolume()*100
            canvas.update()
        end
        if canvas.arrow == 2 then
            functions:screenUp()
            local ww, wh, options = love.window.getMode()
            if options.fullscreen then
                text[3] = 'FULL SCREEN'
            else 
                text[3] = ww .. 'x' .. wh
            end
            canvas.update()
        end
    end

    if input:isReleased('return') and canvas.arrow == 3 then
        saveConfiguration()
        return 'menu'
    end

end

function options:draw()
    love.graphics.draw(canvas.canvas, canvas.x, canvas.y)
end

return options