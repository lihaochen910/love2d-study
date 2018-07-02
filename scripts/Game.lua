require 'scripts/Class'
local Input = require 'scripts/Input'

--------------------------------------------------------------------
CLASS: Game()
	
--------------------------------------------------------------------
function Game:__init() --INITIALIZATION
	self.initialized          = false
	self.graphicsInitialized  = false
	self.started              = false
	self.focused              = false

	self.prevUpdateTime = 0
	self.prevClock = 0

	self.version = "0.1"
	self.editorMode = false
	self.developerMode = false
	self.layers        = {}
	self.gfx           = { w = 640, h = 480, viewportRect = {0,0,640,480} }
	self.time          = 0
	self.frame 		   = 0

	self.defaultLayer = nil

    self.windowWidth = 800
    self.windowHeight = 600
	self.windowFlags = {
        fullscreen = false,
        fullscreentype = 'desktop',
        vsync = true,
        msaa = 0,
        resizable = false,
        borderless = false,
        centered = true,

        display = 1,

        minwidth = 1,
        minheight = 1,

        highdpi = false,
        x = nil,
        y = nil
    }

    love.window.setTitle('Game')
    love.window.setMode(self.windowWidth, self.windowHeight, self.windowFlags)

    self:init()
end

function Game:init()
    self.input = Input()
    self.input:bind('return', 'left_click')
    self.input:bind('mouse1', function() print('mouse1') end)
end

function Game:onLoad()
    image = love.graphics.newImage('res/image.jpg')
end

function Game:update(dt)
    if self.input:pressed('left_click') then
        print(dt)
    end
end

function Game:draw()
    love.graphics.draw(image, math.random(0, 800), math.random(0, 600))
end
