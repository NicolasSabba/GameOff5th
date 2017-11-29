local game = {}

local input, spriteSheet,player, heart, alien, aliensInfo, batch, posX, posY, playerFirerate
local position, life, aliensFirerateMax, alienSpeed, playerBullets, aliensBullets, lor, especial
local lvl, score

----------------------------------------
------------Helper func-----------------

local function updateBatchAliens()
    batch:clear()
    for x, _ in pairs(aliensInfo) do
        for y, _ in pairs(aliensInfo[x]) do
            batch:setColor(aliensInfo[x][y].color)
            batch:add(alien, 10 + 20 * (aliensInfo[x][y].x - 1) + posX, 10 + 20 * (aliensInfo[x][y].y -1) + posY)
        end
    end
    love.graphics.setColor(255,255,255)
    batch:flush()
end

local function playerShut()
    local bullet = {}
    bullet.x = position + 17
    bullet.y = 375
    table.insert(playerBullets, bullet)
end

local function aliensShut(x, y)
    local bullet = {}
    bullet.x = x + 8
    bullet.y = y
    table.insert(aliensBullets, bullet)
end

local function goodRand()
    local r = 0
    r = math.random(1, math.floor(aliensFirerateMax))
    return r
end

local function newAliens()
    -- aliens colors
    local color = {}
    color[1] = {255,0,0}
    color[2] = {255,255,0}
    color[3] = {0,255,0}
    color[4] = {0,255,255}
    color[5] = {0,0,255}

    -- aliens information
    local aliens = {}
    for x=1, 12 do
        aliens[x] = {}
        for y=1, 5 do
            aliens[x][y] = {}
            aliens[x][y].color = color[y]
            aliens[x][y].firerate = goodRand()
            aliens[x][y].x = x
            aliens[x][y].y = y
        end
    end
    return aliens
end


----------------------------------------
----------------------------------------

local function startgame()

end

local function play(dt)
    input:updateInput()

    playerFirerate = playerFirerate - dt

    -- Update aliens position
    if lor then
        posX = posX + (20 * dt * alienSpeed)
    else
        posX = posX - (20 * dt * alienSpeed)
    end
    if (posX > 100) or (posX < 0) then
        lor = not lor
        posY = posY + 20
        alienSpeed = alienSpeed + 0.01
    end

    local pX = posX * 1
    local pY = posY * 1

    -- Alien shut
    for x, _ in pairs(aliensInfo) do
        for y, _ in pairs(aliensInfo[x]) do
                aliensInfo[x][y].firerate = aliensInfo[x][y].firerate - dt
                if aliensInfo[x][y].firerate < 0 then
                    aliensShut(10 + 20 * (aliensInfo[x][y].x - 1) + pX, 10 + 20 * (aliensInfo[x][y].y -1) + pY)
                    aliensInfo[x][y].firerate = goodRand()
            end
        end
    end

    -- Update aliens bullets
    for key, bullet in pairs(aliensBullets) do
        bullet.y = bullet.y + (200 * dt)
        if bullet.y > 400 then
            table.remove(aliensBullets, key)
        end
    end

    -- Update player
    if input:isDown('a') then
        position = position - (120 * dt)
        if position < 0 then
            position = 0
        end
    end
    if input:isDown('d') then
        position = position + (120 * dt)
        if position > 324 then
            position = 324
        end 
    end
    if input:isDown('space') and (playerFirerate < 0) then
        playerFirerate = 0.5
        playerShut()
    end
    if input:isDown('e') and (playerFirerate < 0) then
        return 'game'
    end

    -- Update player bullet
    for key, bullet in pairs(playerBullets) do
        bullet.y = bullet.y - (200 * dt)
        if bullet.y < -5 then
            table.remove(playerBullets, key)
        else 
            -- Chec colition whit alien
            for x, _ in pairs(aliensInfo) do
                for y, _ in pairs(aliensInfo[x]) do
                    local alienX = 10 + 20 * (aliensInfo[x][y].x - 1) + pX
                    local alienY = 10 + 20 * (aliensInfo[x][y].y - 1) + pY
                        if (bullet.x > alienX)
                           and (bullet.x < (alienX + 16)) 
                           and (bullet.y < (alienY + 16))
                           and (bullet.y > alienY) then
                            score = score + (100 * aliensInfo[x][y].y)
                            aliensFirerateMax = aliensFirerateMax - 0.33333
                            table.remove(playerBullets, key)
                            table.remove(aliensInfo[x], y)
                        end
                    end
                end
            end
        end
    
    -- Update aliens
    updateBatchAliens()
end

local function pause()

end
----------------------------------------
----------------------------------------

function game:load()

    love.mouse.setVisible(false)
    
    input = require('simpleKey')
    input:keyInit({'a', 'd', 'space', 'p', 'e'})

    -- Dificulty
    aliensFirerateMax = 21
    alienSpeed = 1

    -- load img
    spriteSheet = love.graphics.newImage('asset/aliens.png')
    spriteSheet:setFilter('nearest','nearest')

    -- make quads
    player = love.graphics.newQuad(0,  0, 16, 16, spriteSheet:getDimensions())
    heart  = love.graphics.newQuad(32, 0, 16, 16, spriteSheet:getDimensions())
    alien  = love.graphics.newQuad(16, 0, 16, 16, spriteSheet:getDimensions())

    aliensInfo = newAliens()

    -- sprite batch
    batch = love.graphics.newSpriteBatch(spriteSheet, 60)    

    -- variables for title batch control
    posX, posY = 0, 0
    -- left or rigth
    lor = true

    -- Update batch
    updateBatchAliens(posX, posY)

    -- Player variables
    playerFirerate = 0.5
    life = 3
    especial = 3
    position = 164
    score = 0
    lvl = 1

    -- bullets
    playerBullets = {}
    aliensBullets = {}

    -- ui canvas
    uiCanvas = {}
    uiCanvas.canvas = love.graphics.newCanvas(174, 400)
    function uiCanvas.update()
        love.graphics.setCanvas(uiCanvas.canvas)
            love.graphics.setColor(20, 20, 20)
            love.graphics.rectangle('fill', 0, 0, 174, 400)
            love.graphics.setColor(255, 255, 255)
            local level = 'Level: ' .. lvl
            local help = front:getWidth(level) / 2
            love.graphics.print(level , 87-help, 10)
            help = front:getWidth('Score:')/2
            love.graphics.print('Score:' , 87-help, 40)
            for i=1, life do
                love.graphics.draw(spriteSheet, heart, 10 + (26 * (i-1)), 300)
            end
            love.graphics.setColor(255, 0, 253)
            for i=1, especial do
                love.graphics.draw(spriteSheet, player, 26 + (26 * (i-1)), 350, 3.14159)
            end
            love.graphics.setColor(255,255,255)
        love.graphics.setCanvas()
    end
    uiCanvas.update()
    

end

function game:update(dt)

    play(dt)

end

function game:draw()
    
    love.graphics.push()
    love.graphics.scale(1.5,1.5)

    -- player bullet
    for _, bullet in pairs(playerBullets) do
        love.graphics.rectangle('fill', bullet.x, bullet.y, 2, 5)
    end

    -- player
    love.graphics.draw(spriteSheet, player, 10 + position, 375)

    -- alien bullet
    for _, bullet in pairs(aliensBullets) do
        love.graphics.rectangle('fill', bullet.x, bullet.y, 2, 5)
    end

    -- aliens
    love.graphics.draw(batch, 0 ,0)

    -- uiCanvas
    love.graphics.draw(uiCanvas.canvas, 360, 0)
    love.graphics.printf(score, 360, 70, 174, 'center')

    love.graphics.pop()

end

return game