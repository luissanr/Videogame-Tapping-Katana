Player2 = Class{}

function Player2:init()
    self.image = love.graphics.newImage('graphics/player02.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4 - self.width
    self.y = VIRTUAL_HEIGHT - self.height - 15
end

function Player2:render()
    love.graphics.draw(self.image, self.x, self.y)
end