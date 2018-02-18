 local canvas = {}

 local font, fontHeight, fontWidth

 function canvas:init(text)

    -- Font, font size
    font = love.graphics.newFont(26)
    font:setFilter('nearest', 'nearest')
    love.graphics.setFont(font)
    fontHeight = font:getHeight(' ')
    -- Get the bigest width of all text
    fontWidth = 0
    for i=1, #text do
        if fontWidth < font:getWidth(text[i]) + 18 then
            fontWidth = font:getWidth(text[i]) + 18
        end
    end    

    canvas.arrow = 0
    canvas.canvas = love.graphics.newCanvas(fontWidth, fontHeight * #text)
    function canvas.update()
        love.graphics.setCanvas(canvas.canvas)
            love.graphics.clear()
            love.graphics.setColor(141, 153, 255)
            love.graphics.circle('fill', 8, (fontHeight*canvas.arrow)+(fontHeight/2), 8, 3)
            love.graphics.setColor(255, 255, 255)
            for i=0, #text - 1 do
                love.graphics.print(text[i+1], 18, i * fontHeight)
            end
        love.graphics.setCanvas()
        -- Cordinates to draw the canvas
        canvas.x = getWw()/2 - fontWidth/2
        canvas.y = getWh()/2 - (fontHeight * #text/2)
    end
    function canvas.up()
        if canvas.arrow > 0 then
            canvas.arrow = canvas.arrow - 1
        else
            canvas.arrow = #text - 1
        end
        canvas.update()
    end
    function canvas.down()
        if canvas.arrow < #text - 1 then
            canvas.arrow = canvas.arrow + 1
        else 
            canvas.arrow = 0
        end
        canvas.update()
    end
    canvas.update()

end

return canvas