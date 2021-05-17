Player1 = Class{}

function Player1:init()
    self.image = love.graphics.newImage('graphics/player01.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 4
    self.y = VIRTUAL_HEIGHT - self.height - 15
end

function Player1:render()
    love.graphics.draw(self.image, self.x, self.y)
end