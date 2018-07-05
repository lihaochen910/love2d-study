require 'scripts/Class'
local Input = require 'scripts/lib/Input'
Timer = require 'scripts/hump/timer'
require 'scripts/Room'
require 'scripts/Area'
require 'scripts/GameObjectTest'
require 'scripts/Stage'

--------------------------------------------------------------------
CLASS: Game()

local rooms = {}
local currentRoom = false
--------------------------------------------------------------------
function Game:__init() --INITIALIZATION
	self.initialized          = false
	self.graphicsInitialized  = false
	self.started              = false
	self.focused              = false

	self.prevUpdateTime = 0
	self.prevClock     = 0

	self.version       = "0.1"
	self.editorMode    = false
	self.developerMode = false
	self.layers        = {}
	self.gfx           = { w = 640, h = 480, viewportRect = {0,0,640,480} }

    self.rate          = 0.0167 --Limits the number of calls to love.update, The default is 60 ticks per second. 
    self.frame	       = 0      --love.draw call count.
    self.framerate     = -1     --For example, setting framerate to 60 will limit the number of calls to love.draw to 60 per second.
    self.timescale     = 1
    self.sleep         = 0.001
    self.dt            = 0
    self.accum         = 0
    self.tick          = 1      --love.update call count.

	self.defaultLayer  = nil

    -- self.windowWidth = 800
    -- self.windowHeight = 600
	-- self.windowFlags = {
    --     fullscreen = false,
    --     fullscreentype = 'desktop',
    --     vsync = true,
    --     msaa = 0,
    --     resizable = false,
    --     borderless = false,
    --     centered = true,

    --     display = 1,

    --     minwidth = 1,
    --     minheight = 1,

    --     highdpi = false,
    --     x = nil,
    --     y = nil
    -- }

    -- love.window.setTitle('Game')
    -- love.window.setMode(self.windowWidth, self.windowHeight, self.windowFlags)

    self:init()
end

function Game:init()
    input = Input()
    input:bind('left', 'left')
    input:bind('right', 'right')
    Game.timer = Timer()

    input:bind('f3', function() camera:shake(4, 60, 1) end)
    input:bind('f1', function()
        print("Before collection: " .. collectgarbage("count") / 1024)
        collectgarbage()
        print("After collection: " .. collectgarbage("count") / 1024)
        print("Object count: ")
        local counts = type_count()
        for k, v in pairs(counts) do print(k, v) end
        print("-------------------------------------")
    end)
end

function Game:onLoad()
    -- image = love.graphics.newImage('res/image.jpg')
    rooms[0] = Stage()

    currentRoom = rooms[0]

    area_1 = rooms[0].area

    currentRoom:addArea(area_1)

    -- timer:every(0.16, function(f)
    --     local circleObject = Circle(area_1)

    --     local w, h = love.graphics.getDimensions()
    --     circleObject.offw = math.random(0, w)
    --     circleObject.offh = math.random(0, h)

    --     area_1:addGameObject(circleObject)
    -- end)
    
end

function Game:update(dt)
    if currentRoom then currentRoom:update(dt) end
    input:update()
    Game.timer:update(dt)
end

function Game:draw()
    -- love.graphics.draw(image, math.random(0, 800), math.random(0, 600))
    if currentRoom then currentRoom:draw() end
    love.graphics.print(string.format('%.1f', love.timer.getFPS()), WINDOW_WIDTH - 29, 0)
end




function count_all(f)
    local seen = {}
    local count_table
    count_table = function(t)
        if seen[t] then return end
        f(t)
        seen[t] = true
        for k, v in pairs(t) do
            if type(v) == "table" then
                count_table(v)
            elseif type(v) == "userdata" then
                f(v)
            end
        end
    end
    count_table(_G)
end

function type_count()
    local counts = {}
    local enumerate = function(o)
        local t = type_name(o)
        counts[t] = (counts[t] or 0) + 1
    end
    count_all(enumerate)
    return counts
end

global_type_table = nil
function type_name(o)
    if global_type_table == nil then
        global_type_table = {}
        for k, v in pairs(_G) do
            global_type_table[v] = k
        end
        global_type_table[0] = "table"
    end
    return global_type_table[getmetatable(o) or 0] or "Unknown"
end
