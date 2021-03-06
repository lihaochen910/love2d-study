require 'scripts/Class'

CLASS: Room()

function Room:__init()
    self.areas = {}
end

function Room:update(dt)
    if self.areas then
        for _, area in ipairs(self.areas) do
            area:update(dt)
        end
    end
end

function Room:draw()
    for _, area in ipairs(self.areas) do
        area:draw()
    end
end

function Room:addArea(area)
    table.insert(self.areas, area)
end