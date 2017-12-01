local leaderboard = {}

local scores, position, canvas, fh, input, keyAll

local function saveleaderboard()

    if not love.filesystem.exists('leaderboardInfo.lua') then
        file = love.filesystem.newFile('leaderboardInfo.lua')
    end
    local data = 'local leaderboard = {}\n'
    for i=1, 10 do
        data = data .. 'leaderboard[' .. i .. '] = {}\n'
        data = data .. 'leaderboard[' .. i .. '].name = \'' .. scores[i].name .. '\'\n'
        data = data .. 'leaderboard[' .. i .. '].score = ' .. scores[i].score .. '\n'
    end
    data = data .. 'return leaderboard\n'
    love.filesystem.write('leaderboardInfo.lua', data)
end

function leaderboard:load(newScore)

    keyAll = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',
    'p','q','r','s','t','u','v','w','x','y','z','1','2','3','4','5','6','7',
    '8','9','0'}

    input = require('simpleKey')
    input:keyInit({'return','backspace'})
    input:keyBind(keyAll)

    newScore = newScore or -1

    if love.filesystem.exists('leaderboardInfo.lua') then
        scores = love.filesystem.load('leaderboardInfo.lua')
        scores = scores()
    else 
        scores = {}
        for i=1, 10 do
            scores[i] = {}
            scores[i].name = '---'
            scores[i].score = 0
        end
    end
    scores[11] = {}
    scores[11].score = newScore
    table.sort(scores, function(a, b) return a.score > b.score end)
    table.remove(scores, 11)

    for i=1, 10 do
        if scores[i].name == nil then
            position = i
            scores[i].name = ''
            i = 10
        end
    end

    if position == nil then position = 11 end

    fh = front:getHeight(' ')
    canvas = love.graphics.newCanvas(800, fh * 10)
    function canvasUpdate()
        love.graphics.setCanvas(canvas)
            love.graphics.clear()
            for i=1, 10 do
                if i == position then
                    love.graphics.setColor(0, 255, 0)
                    love.graphics.printf(i .. ' - ' .. scores[i].name .. ' ' .. scores[i].score, 0, fh * (i -1), 800, 'center')
                    love.graphics.setColor(255, 255, 255)
                else
                    love.graphics.printf(i .. ' - ' .. scores[i].name .. ' ' .. scores[i].score, 0, fh * (i -1), 800, 'center')
                end
            end
        love.graphics.setCanvas()
    end
    canvasUpdate()
end

function leaderboard:update()

    input:updateInput()

    if position ~= 11 then
        local i = position
        for _, key in ipairs(keyAll) do
            if input:isReleased(key) and (#scores[i].name < 3) then
                scores[i].name = scores[i].name .. string.upper(key)
                canvasUpdate()
            end
        end
        if input:isReleased('backspace') then
            -- If backsspace remove last charter 
            scores[i].name = string.sub(scores[i].name, 1, -2)
            canvasUpdate()
        end
    end
    if input:isReleased('return') then
        saveleaderboard()
        return 'menu'
    end
end

function leaderboard:draw()

    love.graphics.draw(canvas, 0, (wh/2) - (fh*5) )
    if position == 11 then
        love.graphics.printf('Better luck next time', 0, 0, 800, 'center')
    else
        love.graphics.printf('Congratulations!!\nEnter your name:', 0, 0, 800, 'center')
    end

end

return leaderboard