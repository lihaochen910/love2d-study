CLASS: ExplodeParticle(GameObject)

function ExplodeParticle:__init(area, x, y, opts)
    self.color = opts.color or default_color
    self.r = math.random( 0, 2 * math.pi )
    self.s = opts.s or math.random( 2, 3 )
    self.v = opts.v or math.random( 75, 150 )
    self.line_width = 2
    self.timer:tween(opts.d or math.random(0.3, 0.5), self, {s = 0, r = 0, line_width = 0},
        'linear', function() self:destroy() end)
end

function ExplodeParticle:draw()
    pushRotate(self.x, self.y, self.r)
    love.graphics.setLineWidth(self.line_width)
    love.graphics.setColor(self.color)
    love.graphics.line(self.x - self.s, self.y, self.x + self.s, self.y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
end