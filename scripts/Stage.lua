require 'scripts/Class'
require 'scripts/Area'

CLASS: Stage(Room)

function Stage:__init()
    self.area = Area(self)
    self.main_canvas = love.graphics.newCanvas()
end

function Stage:update(dt)
    self.area:update(dt)
    -- camera:follow(WINDOW_WIDTH/2, WINDOW_HEIGHT/2)
end

function Stage:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
        camera:attach(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
        love.graphics.circle('line', WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 50)
        self.area:draw()
        camera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end