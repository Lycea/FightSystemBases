BaseParticle= base_class:extend()


--basic particle which flies in the direction given
function BaseParticle:new(x,y,dir)
    self.super.new(self)
    self.damage =1
    self.pircing = false
    self.speed = 3
    self.size = 2
    self.dir =dir or {0,0}
    self.lifetime = 12
    
    self.weap_dmg = 1
    
    print(x,y)
    self.x=x
    self.y=y
end

function BaseParticle:draw()
    love.graphics.setColor(1,0,0)
    love.graphics.circle("fill",self.x,self.y,self.size)
    
end

function BaseParticle:update()
   self.x=self.x+self.dir[1]*self.speed
   self.y=self.y+self.dir[2]*self.speed
end

function BaseParticle:check_mobs()
    for i,mob in pairs(mobs) do
        --if collides somewhere
        if math.dist(self.x,self.y,mob.x,mob.y)<= self.size+mob.size then
            mob:hit(self.damage+self.weap_dmg)
        end
    end
end



return BaseParticle