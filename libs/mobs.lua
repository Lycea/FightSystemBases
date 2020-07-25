
mob={}
function mob:new(x,y)
    local mob_={}
    mob_.x = x
    mob_.y = y
    mob_.live = 200
    mob_.size = 20
    mob_.last_hit = 0
    mob_.got_hit =false

    setmetatable(mob_, self)
    self.__index = self
    

    table.insert(mobs,mob_)
end
function mob:draw()
    --love.graphics.rectangle("fill",self.nx,self.y,32,32)
    if self.got_hit then
        love.graphics.setColor(1,0,0)    
    end
    
    love.graphics.circle("fill",self.x,self.y,self.size)
    love.graphics.print(self.live,self.x,self.y -self.size*3 )
    --love.graphics.print(self.live,self.x,self.y -self.size*3 )
    
    
    love.graphics.setColor(1,1,1)    
    self.got_hit = false
end

function mob:hit(dmg)
    self.got_hit = true
    if self.last_hit+0.1 < love.timer.getTime() then
       self.live = self.live - dmg
       self.last_hit = love.timer.getTime()
       console.log("hit time"..self.last_hit)
    end
end


function mob:update(idx)
    if self.live <=0 then
       table.remove(mobs,idx) 
    end
end
