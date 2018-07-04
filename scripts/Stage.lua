require 'scripts/Class'
require 'scripts/Area'
require 'scripts/Player'
local Camera = require 'scripts/hump/camera'

CLASS: Stage(Room)

function Stage:__init()
    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.main_canvas = love.graphics.newCanvas()
    camera = Camera()
    player = Player(self.area, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
end

function Stage:update(dt)
    self.area:update(dt)
    player:update(dt)
    camera:update(dt)
    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2)
    -- camera:follow(WINDOW_WIDTH/2, WINDOW_HEIGHT/2)
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
        camera:attach(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
        -- love.graphics.circle('line', WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 50)
        self.area:draw()
        camera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end