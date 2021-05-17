-- [ Press alt + L to run program ]
push = require 'push'
Class = require 'class'

require 'Player1'
require 'Player2'

require 'Attackbar1'
require 'Attackbar2'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Speed of both bars, I tried more speed but is difficult to see the bar
BAR_SPEED = 200

-- Set background and ground
local background = love.graphics.newImage('graphics/background1.png')
local ground = love.graphics.newImage('graphics/ground1.png')

-- Declare player1 and player2 objects
local player1 = Player1()
local player2 = Player2()

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Final_Project')

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('font1.ttf', 24)
    scoreFont = love.graphics.newFont('font1.ttf', 36)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })


    sounds = {
        ['menu_music'] = love.audio.newSource('sounds/mapmusic.wav', 'static'),
        ['sword_hit'] = love.audio.newSource('sounds/sword.mp3', 'static'),
        ['attack_register'] = love.audio.newSource('sounds/keypressed.wav', 'static')
    }

    -- Initialize bar1 and bar2 objects
    BAR1 = Attackbar1(20, VIRTUAL_HEIGHT / 2 + VIRTUAL_HEIGHT / 16, 12, 1)
    BAR2 = Attackbar2(VIRTUAL_WIDTH - 32, VIRTUAL_HEIGHT / 2 - VIRTUAL_HEIGHT / 16, 12, 1)

    -- Initialize both bar's speed and orientation
    BAR1.dy = -BAR_SPEED
    BAR2.dy = BAR_SPEED

    -- Initialize game state and bars state
    gameState = 'start'
    bar1State = 'oscillate'
    bar2State = 'oscillate'

    -- attack_calculator will calculate attack speed based on the sum of all 3 attempts, after 3 attempts, the least number will be faster
    -- attack_counter will count the attempts. Max attempts per round = 3
    -- round_counter will count the rounds. Max rounds = 5
    attack_calculator1 = 0
    attack_counter1 = 0

    attack_calculator2 = 0
    attack_counter2 = 0

    round_counter = 0

    -- Initialize both scores at 0
    player1Score = 0
    player2Score = 0

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)

    if gameState == 'play' then

        if bar1State == 'oscillate' then
            -- Detect upper boundary collision and reverse if collided
            if BAR1.y <= VIRTUAL_HEIGHT / 2 - VIRTUAL_HEIGHT / 8 + 1 then
                BAR1.y = VIRTUAL_HEIGHT / 2 - VIRTUAL_HEIGHT / 8 + 1
                BAR1.dy = -BAR1.dy
            end
            -- Detect lower boundary. -2 to account for the BAR1's size
            if BAR1.y >= VIRTUAL_HEIGHT / 2 + VIRTUAL_HEIGHT / 8 - 2 then
                BAR1.y = VIRTUAL_HEIGHT / 2 + VIRTUAL_HEIGHT / 8 - 2
                BAR1.dy = -BAR1.dy
            end

            if love.keyboard.wasPressed('s') then
                -- Calculate attack speed
                if BAR1.y < VIRTUAL_HEIGHT / 2 then
                    -- When bar is above the center. BAR1.y + 1 to account for BAR1's bottom side
                    attack_calculator1 = attack_calculator1 + (VIRTUAL_HEIGHT / 2 - BAR1.y + 1)
                elseif BAR1.y > VIRTUAL_HEIGHT / 2 + 1 then
                    -- When bar is below the center
                    attack_calculator1 = attack_calculator1 + BAR1.y - (VIRTUAL_HEIGHT / 2 + 1)
                elseif BAR1.y == VIRTUAL_HEIGHT / 2 then
                    -- When bar is at the center
                    attack_calculator1 = attack_calculator1 + 0
                end
                -- Update attack attempts
                attack_counter1 = attack_counter1 + 1

                sounds['attack_register']:play()
            end

            if attack_counter1 == 3 then
                -- Stop bar movement after 3 attempts
                bar1State = 'stop'
                BAR1.dy = 0
            end
        end

        if bar2State == 'oscillate' then
            -- Detect upper boundary collision and reverse if collided
            if BAR2.y <= VIRTUAL_HEIGHT / 2 - VIRTUAL_HEIGHT / 8 + 1 then
                BAR2.y = VIRTUAL_HEIGHT / 2 - VIRTUAL_HEIGHT / 8 + 1
                BAR2.dy = -BAR2.dy
            end
            -- Detect lower boundary. -2 to account for the BAR1's size
            if BAR2.y >= VIRTUAL_HEIGHT / 2 + VIRTUAL_HEIGHT / 8 - 2 then
                BAR2.y = VIRTUAL_HEIGHT / 2 + VIRTUAL_HEIGHT / 8 - 2
                BAR2.dy = -BAR2.dy
            end

            if love.keyboard.wasPressed('k') then
                -- Calculate attack speed
                if BAR2.y < VIRTUAL_HEIGHT / 2 then
                    -- When bar is above the center. BAR2.y + 1 to account for BAR1's bottom side
                    attack_calculator2 = attack_calculator2 + (VIRTUAL_HEIGHT / 2 - BAR2.y + 1)
                elseif BAR2.y > VIRTUAL_HEIGHT / 2 + 1 then
                    -- When bar is below the center
                    attack_calculator2 = attack_calculator2 + BAR2.y - (VIRTUAL_HEIGHT / 2 + 1)
                elseif BAR2.y == VIRTUAL_HEIGHT / 2 then
                    -- When bar is at the center
                    attack_calculator2 = attack_calculator2 + 0
                end
                -- Update attack attempts
                attack_counter2 = attack_counter2 + 1

                sounds['attack_register']:play()
            end

            if attack_counter2 == 3 then
                -- Stop bar movement after 3 attempts
                bar2State = 'stop'
                BAR2.dy = 0
            end
        end

        -- Declare the winner of the current round
        if attack_counter1 == 3 and attack_counter2 == 3 then
            sounds['sword_hit']:play()
            if attack_calculator1 < attack_calculator2 then
                player1Score = player1Score + 1
                round_counter = round_counter + 1
                

                -- If we've reached a score of 3, the game is over; set the
                -- state to done so we can show the victory message
                if player1Score == 3 then
                    winningPlayer = 1
                    gameState = 'done'
                else
                    gameState = 'roundCounter'
                    bar1State = 'oscillate'
                    bar2State = 'oscillate'
                    
                    -- reset attack numbers to 0
                    attack_calculator1 = 0
                    attack_counter1 = 0

                    attack_calculator2 = 0
                    attack_counter2 = 0

                    -- reset bars
                    BAR1:reset()
                    BAR2:reset()
                end

            elseif attack_calculator2 < attack_calculator1 then
                player2Score = player2Score + 1
                round_counter = round_counter + 1
                

                -- If we've reached a score of 3, the game is over; set the
                -- state to done so we can show the victory message
                if player2Score == 3 then
                    winningPlayer = 2
                    gameState = 'done'
                else
                    gameState = 'roundCounter'
                    bar1State = 'oscillate'
                    bar2State = 'oscillate'
                    
                    -- reset attack numbers to 0
                    attack_calculator1 = 0
                    attack_counter1 = 0

                    attack_calculator2 = 0
                    attack_counter2 = 0

                    -- reset bars
                    BAR1:reset()
                    BAR2:reset()
                end

            else
                -- dont do anything (draw)
                gameState = 'roundCounter'
                bar1State = 'oscillate'
                bar2State = 'oscillate'

                -- reset attack numbers to 0
                attack_calculator1 = 0
                attack_counter1 = 0

                attack_calculator2 = 0
                attack_counter2 = 0

                -- reset bars
                BAR1:reset()
                BAR2:reset()
            end
        end
    end

    -- Update bars 1 and 2 movement only on play state
    if gameState == 'play' then
        BAR1:update(dt)
        BAR2:update(dt)
    end

    if gameState == 'start' or gameState == 'instructions' then
        sounds['menu_music']:setLooping(true)
        sounds['menu_music']:play()
    else
        sounds['menu_music']:stop()
    end

    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'instructions'
        elseif gameState == 'instructions' then
            gameState = 'roundCounter'

            round_counter = round_counter + 1
            
        elseif gameState == 'roundCounter' then
            gameState = 'play'
        elseif gameState == 'done' then
            -- game is simply in a restart phase here
            gameState = 'instructions'

            -- reset bars
            BAR1:reset()
            BAR2:reset()

            -- reset scores to 0
            player1Score = 0
            player2Score = 0

            -- reset attack numbers to 0
            attack_calculator1 = 0
            attack_counter1 = 0

            attack_calculator2 = 0
            attack_counter2 = 0

            -- reset round counter
            round_counter = 0

            -- set bars state to oscillate
            bar1State = 'oscillate'
            bar2State = 'oscillate'
        end
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.draw()
    push:start()
    love.graphics.draw(background, 0, 0)

    love.graphics.draw(ground, 0, VIRTUAL_HEIGHT - 16)

    -- Render player 1 and 2 objects
    player1:render()
    player2:render()
    BAR1:render()
    BAR2:render()

    -- Left rectangle
    love.graphics.rectangle('line', 20, VIRTUAL_HEIGHT / 2 - VIRTUAL_HEIGHT / 8, 12, VIRTUAL_HEIGHT / 4)

    -- Right rectangle
    love.graphics.rectangle('line', VIRTUAL_WIDTH - 32, VIRTUAL_HEIGHT / 2 - VIRTUAL_HEIGHT / 8, 12, VIRTUAL_HEIGHT / 4)

    -- Display score only on this states
    if gameState == 'roundCounter' or gameState == 'play' or gameState == 'done' then
        displayScore()
    end

    -- Update UI messages
    if gameState == 'start' then
        love.graphics.setFont(mediumFont)
        love.graphics.printf('TAPPING KATANA!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to start!', 0, 35, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'instructions' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Ready for battle!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('The closer you hit the green bar the fastest your attack will be!', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('There are three chances per round.', 0, 30, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Attack accumulates, so, try to hit the green bar every time to win.', 0, 40, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Player 1 press s to attack', 0, 50, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Player 2 press k to attack', 0, 60, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to start!', 0, 80, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'roundCounter' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Round ' .. tostring(round_counter) .. '!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to start!', 0, 30, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- no UI messages to display in play
    elseif gameState == 'done' then
        -- UI messages
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 35, VIRTUAL_WIDTH, 'center')
    end
    
    love.graphics.setColor(0, 255, 0, 255)
    -- Left target line
    love.graphics.rectangle('fill', 20, VIRTUAL_HEIGHT / 2, 11, 1)
    -- Right target line
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 32, VIRTUAL_HEIGHT / 2, 11, 1)

    push:finish()
end



function displayScore()
    -- draw score on the left and right center of the screen
    -- need to switch font to draw before actually printing
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end