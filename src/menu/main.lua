local menu = {}

local input, text

local canvas = require('plugins/dCanvas')

function menu:load()

    love.mouse.setVisible(false)

    input = require('plugins/simpleKey')
    input:keyInit({'w', 's', 'up', 'down', 'return'})

    -- All posible text
    text = {
        'START',
        'OPTIONS',
        'EXIT'
    }
    
    -- Draw the canvas for the 1 time
    canvas:init(text)

end

function menu:update(dt)
    
    input:updateInput()

    -- Move the arrow
    if input:isReleased('w') or input:isReleased('up') then 
        canvas.up()
    end
    if input:isReleased('s') or input:isReleased('down') then
        canvas.down()
    end

    -- Exit the state
    if input:isReleased('return') then
        
        if canvas.arrow == 0 then return 'game' end
        if canvas.arrow == 1 then return 'options' end
        if canvas.arrow == 2 then love.event.quit() end
         
    end
    
end

function menu:draw()
    love.graphics.draw(canvas.canvas, canvas.x, canvas.y)
end


return menu