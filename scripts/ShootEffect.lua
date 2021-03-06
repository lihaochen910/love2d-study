CLASS: ShootEffect(GameObject)

function ShootEffect:__init()
    self.w = 8
    self.timer:tween(0.1, self, {w = 0}, 'in-out-cubic', function() self.dead = true end)
end

function ShootEffect:draw()
    love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.w/2, self.w, self.w)
end