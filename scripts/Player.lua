CLASS: Player()

function Player:__init(area, x, y, opts)
    self.area = area
    self.x, self.y = x, y
    self.w, self.h = 12, 12

    self.r = -math.pi / 2
    self.v = 0
    self.max_v = 100
    self.a = 100

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)
end

function Player:update(dt)
    if input:down('left') then
        self.r = self.r - self.rv * dt
    end

    if input:down('right') then
        self.r = self.r + self.rv * dt
    end

    self.v = math.min(self.v + self.a * dt, self.max_v)
    self.collider:setLinearVelocity(self.v * math.cos(self.r), self.v * math.sin(self.r))
end

function Player:draw()
    love.graphics.circle('line', self.x, self.y, self.w)
end