 sword = weapons.base_weapon:extend()

checked_point={0,0}

function sword:new( param_obj)
    sword.super.new(self)
    self.speed      = param_obj.speed or 1
    self.range      = param_obj.range or 10
    self.angle_done = 0
    self.angle      = param_obj.angle or 90
    self.name       = param_obj.name or "no name"
    print("hiiii")
end

--attack is started
function sword:attack()
    if self.weapon_in_list ==false then
        
        self.active = true
        self.angle_done = self.speed
        table.insert(update_list,self)
        print("attacking")
        self.weapon_in_list = true
    end
    
end


function sword:check_mobs()
    for k,v in pairs(mobs) do
        --local angle =math.deg( math.angle(player.x,player.y,v.x,v.y))
        --print(math.deg(angle))
        
        --love.graphics.line(player.x,player.y,v.x,v.y)
        
        local heading =dir_to_angle()
        if heading == nil and self.active == false then
            return
        end
        console.log("checking_mob")
        heading = (heading or self.last_dir) or 0
        
        local x = self.range*math.sin(math.rad(self.angle_done-heading+self.angle/2))+player.x
        local y = self.range*math.cos(math.rad(self.angle_done-heading+self.angle/2))+player.y
        
        
        checked_point={x,y}
        --console.log("Player: "..player.x.." "..player.y)
        --console.log("Weapon: "..x.." "..y)
        
        --local slope = (x-player.x)/(y-player.y)
        --local ydiff = y-slope*x
        --local hits = math.pow(player.x,2)-math.pow(v.x,2)+math.pow(slope*player.x,2)+math.pow(ydiff,2)-math.pow(v.y,2)-math.pow(v.size,2)
        --console.log(hits)
        
        hits = false
        if pointInCircle({x=x,y=y},{x=v.x,y=v.y,r=v.size}) or
           pointInCircle({x=player.x,y=player.y},{x=v.x,y=v.y,r=v.size}) then
            hits = true
        else
            local length_line = math.dist(player.x,player.y,x,y)
            --console.log("length:"..length_line)
            
            local dot =((( v.x-player.x)*(x-player.x))+((v.y-player.y)*(y-player.y)))/math.pow(length_line,2)
            
            local closestx= player.x+(dot*(x-player.x))
            local closesty= player.y+(dot*(y-player.y))
            
            if pointOnLine(x,y,player.x,player.y,closestx,closesty) == true then
                if math.dist(closestx,closesty,v.x,v.y)<= v.size then
                   hits = true 
                end
            end
            
        end
        if hits ==true then
            console.log("Hit!!")
            --v.live = v.live -1
            v:hit(1)
        end
        
        --console.log("Hit mob "..hits.." times")
        --local weap_angle =weapon_.angle_done-heading+weapon_.angle/2.
        --console.log("Weapon angle: "..weap_angle)
        --if weap_angle== angle then.
        --    print("attack") 
        --end
        
        --console.log("Mob angle: "..angle.."\n-----")
        --print(weapon_.angle_done)
    end
end

function sword:update()
     self.angle_done = self.angle_done+self.speed
    
    --if weapon is done remove from list
    if self.angle_done >= self.angle then
        self.active = false
        self.weapon_in_list = false
        
        --if return true it will delete the item after the frame
        return true
        
    end
    
end
    
function sword:draw()
    local dir = dir_to_angle()
    
    if dir == nil and self.active ==false then
       return 
    end
    
    dir = (dir or self.last_dir) or 0
    print(dir)
    love.graphics.print(dir,0,100)
    local x = self.range*math.sin(math.rad(self.angle_done-dir+self.angle/2))+scr_width/2-16
    local y = self.range*math.cos(math.rad(self.angle_done-dir+self.angle/2))+scr_height/2-16
    
    love.graphics.line(scr_width/2-16,scr_height/2-16,x,y)
    love.graphics.arc( "line", scr_width/2-16, scr_height/2-16, self.range, math.rad(dir-self.angle/2), math.rad(dir+self.angle/2) )
    
    self.last_dir = dir
    
    love.graphics.setColor(1,1,1)
    love.graphics.circle("line",  scr_width/2-16 +checked_point[1],scr_height/2 +checked_point[2],2)
end

--debug drawer
function sword:draw_range()
    
end



return sword