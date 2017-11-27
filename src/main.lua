local state
constants = require 'init'
-- Set the random seed
math.randomseed( os.time() )
-- Get a "good" random
math.random()
math.random()
math.random()
math.random()
math.random()

function love.load()
    constants:Init()
    state = love.filesystem.load('menu.lua')
    state = state()
    state:load()
end

function love.update(dt) 
    local switchState
    switchState, extra = state:update(dt)
    if switchState ~= nil then
        state = love.filesystem.load(switchState .. '.lua')
        state = state()
        state:load(extra)
        state:update(dt)
        collectgarbage('collect')
    end
end

function love.draw()
    love.graphics.push()
    love.graphics.scale(scaleX, scaleY)
    state:draw()
    love.graphics.pop()
    constants:Debug()
end