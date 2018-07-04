require 'scripts/Class'
local windfield = require 'scripts/lib/windfield/init'

CLASS: Area()

function Area:__init(room)
    self.room = room
    self.game_objects = {}
    -- print('Area init()', self.game_objects)
    -- print(debug.traceback())
end

function Area:update(dt)
    if self.world then self.world:update(dt) end
    for _, game_object in ipairs(self.game_objects) do
        game_object:update(dt)
        if game_object.dead then
            table.remove(self.game_objects, _)
            game_object:onDestroy()
        end
    end
end

function Area:draw()
    if self.world then self.world:draw() end
    for _, game_object in ipairs(self.game_objects) do
        game_object:draw()
    end
end

function Area:addGameObject(game_object_instance)
    assert(game_object_instance ~= nil, 'try to add a nil for Area.')

    table.insert(self.game_objects, game_object_instance)

    return game_object_instance
end

function Area:addPhysicsWorld()
    self.world = windfield.newWorld(0, 0, true)
end