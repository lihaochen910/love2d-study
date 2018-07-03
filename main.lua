local inspect = require 'scripts/inspect'
require 'scripts/Game'

local game

function love.run()
    game = Game()

    if love.math then
	    love.math.setRandomSeed(os.time())
    end

    if love.load then love.load(arg) end

    if game.onLoad then game:onLoad() end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end
    
    local lastframe = 0
    local dt = 0

    if love.update then love.update(dt) end

    -- Main loop time.
    while true do
        
        -- Update dt, as we'll be passing it to update
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta() * game.timescale
            game.dt = dt
            game.accum = game.accum + dt
        end

        while game.accum >= game.rate do
            game.accum = game.accum - game.rate
            
            -- Process events.
            if love.event then
                love.event.pump()
                for name, a,b,c,d,e,f in love.event.poll() do
                    if name == "quit" then
                        if not love.quit or not love.quit() then
                            return a
                        end
                    end
                    love.handlers[name](a,b,c,d,e,f)
                end
            end

            if game.update then game.tick = game.tick + 1 end

            -- Call update and draw
            if love.update then love.update(game.rate) end -- will pass 0 if love.timer is disabled
            if game.update then game:update(game.rate) end
            
        end

        while game.framerate and love.timer.getTime() - lastframe < 1 / game.framerate do
            love.timer.sleep(0.0005)
        end
        
        lastframe = love.timer.getTime()
        if love.graphics and love.graphics.isActive() then
            love.graphics.clear(love.graphics.getBackgroundColor())
            love.graphics.origin()
            if game.frame then game.frame = game.frame + 1 end
            if love.draw then love.draw() end
            if game.draw then game:draw() end
            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end --End main loop
end
