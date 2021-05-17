


Attackbar2 = Class{}

function Attackbar2:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dy = 0 --math.random(2) == 1 and -100 or 100
end

--[[
    Resets bar
]]
function Attackbar2:reset()
    self.x = VIRTUAL_WIDTH - 32
    self.y = VIRTUAL_HEIGHT / 2 - VIRTUAL_HEIGHT / 16
    self.dy = BAR_SPEED
end

--[[
    Apply velocity to position, scaled by deltaTime.
]]
function Attackbar2:update(dt)
    self.y = self.y + self.dy * dt
end

function Attackbar2:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end