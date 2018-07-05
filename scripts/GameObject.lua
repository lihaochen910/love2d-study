CLASS: GameObject()

local function UUID()
    local fn = function(x)
        local r = math.random(16) - 1
        r = (x == "x") and (r + 1) or (r % 4) + 9
        return ("0123456789abcdef"):sub(r, r)
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

function GameObject:__init(area, x, y, opts)
    -- Options
    local opts = opts or {}
    if opts then
        for k, v in pairs(opts) do
            self[k] = v
        end
    end

    self.area = area
    self.x, self.y = x or 0, y or 0
    self.id = UUID()
    self.timer = Timer()
    self.dead = false
end

function GameObject:update(dt)
    if self.timer then self.timer:update(dt) end
    if self.collider then self.x, self.y = self.collider:getPosition() end
end

function GameObject:draw() end
function GameObject:destroy()
    self.dead = true
    self:onDestroy()
    self = nil
end
function GameObject:onDestroy() end
