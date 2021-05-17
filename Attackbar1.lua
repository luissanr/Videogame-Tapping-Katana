


Attackbar1 = Class{}

function Attackbar1:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dy = 0 --math.random(2) == 1 and -100 or 100
end

--[[
    Resets bar
]]
function Attackbar1:reset()
    self.x = 20
    self.y = VIRTUAL_HEIGHT / 2 + VIRTUAL_HEIGHT / 16
    self.dy = -BAR_SPEED
end

--[[
    Apply velocity to position, scaled by deltaTime.
]]
function Attackbar1:update(dt)
    self.y = self.y + self.dy * dt
end

function Attackbar1:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end