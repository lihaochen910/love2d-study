inspect = require 'scripts/lib/inspect'
require 'scripts/lib/lovedebug'
require 'scripts/Game'
require 'scripts/Class'
require 'globals'

-- local json = require 'scripts/lib/dkjson'
-- local debuggee = require 'scripts/lib/vscode-debuggee'
-- local startResult, breakerType = debuggee.start(json)
-- print('debuggee start ->', startResult, breakerType)

game = nil

function love.run()
    game = Game()

    if love.math then
	    love.math.setRandomSeed(os.time())
    end

    if game.onLoad then xpcall(game.onLoad, _Debug.handleError) end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local lastframe = 0
    local dt = 0

    if game.update then xpcall(function() game:update(0) end, _Debug.handleError) end

    -- Main loop time.
    while true do

        -- require("scripts/lib/lurker").update()

        -- Update dt, as we'll be passing it to update
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta() * game.timescale
            game.dt = dt
            game.accum = game.accum + dt
            -- Integrate lovedebug
            _Debug.onTopUpdate(dt / game.timescale)
            _Debug.tick = _Debug.tick - dt
            if _Debug.tick <= 0 then
                _Debug.tick = _Debug.tickTime + _Debug.tick
                _Debug.drawTick = not _Debug.drawTick
            end
        end

        while game.accum >= game.rate do
            game.accum = game.accum - game.rate

            -- Process events.
            if love.event then
                love.event.pump()
                for name, a,b,c,d,e,f in love.event.poll() do
                    if name == "quit" then
                        if not love.quit or not love.quit() then return a end
                    end
                    -- lovedebug Integration
                    local skipEvent = false
					if name == "textinput" then --Keypress
						skipEvent = true
						_Debug.handleKey(a)
						if not _Debug.drawOverlay then
							if love.textinput then love.textinput(a) end
						end
					end
					if name == "keypressed" then --Keypress
						skipEvent = true
						
						if string.len(a)>=2 or (love.keyboard.isDown('lctrl') and (a == 'c' or a == 'v')) then _Debug.handleKey(a) end
						if not _Debug.drawOverlay then
							if love.keypressed then love.keypressed(a,b) end
						end
					end
					if name == "keyreleased" then --Keyrelease
						skipEvent = true
						if not _Debug.drawOverlay then
							if love.keyreleased then love.keyreleased(a, b) end
						end
					end
					if name == "mousepressed" and _Debug.drawOverlay then --Mousepress
						skipEvent = true
						_Debug.handleMouse(a, b, c)
                    end
                    if not skipEvent then
						xpcall(function() love.handlers[name](a,b,c,d,e,f) end, _Debug.handleError)
                    end
                end
            end

            if _Debug.drawOverlay then
                for key, d in pairs(_Debug.trackKeys) do
                    if type(key) == 'string' then
                        if love.keyboard.isDown(key) then
                            d.time = d.time + dt
                            if d.time >= _Debug.keyRepeatInterval then
                                d.time = 0
                                _Debug.handleVirtualKey(key)
                            end
                        else
                            _Debug.trackKeys[key] = nil
                        end
                    else
                        if love.keyboard.isDown('v') and love.keyboard.isDown('lctrl') then
                            d.time = d.time + dt
                            if d.time >= _Debug.keyRepeatInterval then
                                d.time = 0
                                _Debug.handleVirtualKey(key)
                            end
                        else
                            _Debug.trackKeys[key] = nil
                        end
                    end
                end

                -- Call love.update() if we are not to halt program execution
                if _DebugSettings.HaltExecution == false then
                    if game.tick then game.tick = game.tick + 1 end
                    -- will pass 0 if love.timer is disabled
                    if game.update then xpcall(function() game:update(game.rate) end, _Debug.handleError) end
                end

                -- Auto scroll the console if AutoScroll == true
                if _DebugSettings.AutoScroll == true then
                    if _Debug.orderOffset < #_Debug.order - _Debug.lastRows + 1 then
                        _Debug.orderOffset = #_Debug.order - _Debug.lastRows + 1
                    end
                end
            end

            if game.tick then game.tick = game.tick + 1 end
            -- will pass 0 if love.timer is disabled
            if game.update then xpcall(function() game:update(game.rate) end, _Debug.handleError) end
        end

        while game.framerate and love.timer.getTime() - lastframe < 1 / game.framerate do
            love.timer.sleep(0.0005)
        end

        lastframe = love.timer.getTime()
        if love.graphics and love.graphics.isActive() then
            love.graphics.clear(love.graphics.getBackgroundColor())
            love.graphics.origin()

            if game.frame then game.frame = game.frame + 1 end
            -- Integrate lovedebug
            if game.draw then
                if _Debug.liveDo then
                    _Debug.hotSwapDraw()
                    _Debug.liveDo = false
                end
                xpcall(function() game:draw() end, _Debug.handleError)
            end
			if _DebugSettings.DrawOnTop then _Debug.onTop() end
            if _Debug.drawOverlay then _Debug.overlay() end

            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end --End main loop
end
