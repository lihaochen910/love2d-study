require 'scripts/Class'

CLASS: Area()

function Area:__init(room)
    self.room = room
    self.game_objects = {}
end

function Area:update(dt)
    for _, game_object in ipairs(self.game_objects) do
        game_object:update(dt)
        if game_object.dead then
            table.remove(self.game_objects, _)
        end
    end
end

function Area:draw()
    for _, game_object in ipairs(self.game_objects) do
        -- print('Area:draw() %d', _)
        game_object:draw()
    end
end

function Area:addGameObject(game_object_instance)
    assert(game_object_instance ~= nil, 'try to add a nil for Area.')

    table.insert(self.game_objects, game_object_instance)
    -- print 'add go_instance to Area.'
    return game_object_instance
end