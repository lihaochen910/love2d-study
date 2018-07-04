require 'scripts/GameObject'

CLASS: Circle(GameObject)

function Circle:__init()
    self.r = 10
    self.offw = 0
    self.offh = 0
    self.x = math.random(0, 100)
    self.y = math.random(0, 100)
    self.timer = Timer()
    -- self.timer:every(0.05, function(f)
    --     self.x = math.random(0, 100) + self.offw
    --     self.y = math.random(0, 100) + self.offh
    -- end)
    self.timer:tween(math.random(1, 5), self, {r = math.random(self.r, 100)}, 'in-out-cubic')
    self.timer:after(5, function(f) self.dead = true end)
end

function Circle:update(dt)
    print('circle update()')
    self.timer:update(dt)
end

function Circle:draw()
    print('circle draw()')
    love.graphics.circle('line', self.x + self.offw, self.y + self.offh, self.r)
end

function Circle:onDestroy()
    print('circle destroy')
end