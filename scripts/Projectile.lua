CLASS: Projectile(GameObject)

function Projectile:__init(area, x, y, opts)
    self.s = opts.s or 2.5
    self.v = opts.v or 200

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
    self.collider:setObject(self)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
end

function Projectile:update(dt)
    self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))

    if self.x < 0 or self.y > 0 or self.x > WINDOW_WIDTH or self.y > WINDOW_HEIGHT then
        self:destroy()
    end
end

function Projectile:draw()
    love.graphics.circle('line', self.x, self.y, self.s)
end