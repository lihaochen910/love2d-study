require 'scripts/Class'

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
    self.dead = false
end

function GameObject:update(dt) end
function GameObject:draw() end
