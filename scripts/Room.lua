require 'scripts/Class'

CLASS: Room()

function Room:__init()
    self.areas = {}
end

function Room:update(dt)
    for _, area in ipairs(self.areas) do
        area:update(dt)
    end
end

function Room:draw()
    for _, area in ipairs(self.areas) do
        -- print('Room:draw() %d', _)
        area:draw()
    end
end

function Room:addArea(area)
    table.insert(self.areas, area)
    print 'addArea to Room.'
end