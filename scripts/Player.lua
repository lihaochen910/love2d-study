require 'scripts/ShootEffect'
require 'scripts/Projectile'
require 'scripts/ExplodeParticle'

CLASS: Player(GameObject)

function Player:__init(area, x, y, opts)
    self.area = area
    self.x, self.y = x, y
    self.w, self.h = 12, 12

    self.r = -math.pi / 2
    self.rv = 1.66 * math.pi
    self.v = 0
    self.max_v = 100
    self.a = 50

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)

    self.timer:every(0.24, function()
        self:shoot()
    end)

    input:bind('f4', function() self:die() end)
end

function Player:update(dt)
    self.timer:update(dt)

    if self.collider then self.x, self.y = self.collider:getPosition() end

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
    love.graphics.print(self.x, WINDOW_WIDTH / 2, 0)
    love.graphics.circle('line', self.x, self.y, self.w)
    love.graphics.line(self.x, self.y, self.x + 2*self.w*math.cos(self.r), self.y + 2*self.w*math.sin(self.r))
end

function Player:shoot()
    local eff = ShootEffect(self.area, self.x + 1.2 * self.w * math.cos(self.r), self.y + 1.2 * self.w * math.sin(self.r))
    local proj = Projectile(self.area, self.x + 1.2 * self.w * math.cos(self.r), self.y + 1.2 * self.w * math.sin(self.r),
        { r = self.r })
    local proj_2 = Projectile(self.area, self.x + 1.2 * self.w * math.cos(self.r + 30), self.y + 1.2 * self.w * math.sin(self.r + 30),
        { r = self.r })
    local proj_3 = Projectile(self.area, self.x + 1.2 * self.w * math.cos(self.r - 30), self.y + 1.2 * self.w * math.sin(self.r - 30),
        { r = self.r })
    self.area:addGameObject(eff)
    self.area:addGameObject(proj)
    self.area:addGameObject(proj_2)
    self.area:addGameObject(proj_3)
end

function Player:die()
    self.timer:clear()
    for i = 1, love.math.random(8, 20) do
        local eff = ExplodeParticle(self.area, self.x, self.y, {})
        self.area:addGameObject(eff)
    end
    slow(0.5, 1)
    self:destroy()
end

function pushRotate(x, y, r)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.translate(-x, -y)
end

function slow(amount, duration)
    game.timescale = amount
    game.timer:tween('slow', duration, game, { timescale =  1 }, ' in-out-cubic ')
end