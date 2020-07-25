local weapons={}


weapon_ = 0



weapon = base_class:extend()

local weapon_in_list = false

weapon_list ={}




--local type_lookup={"sword"=weapons,"ranged"=""}


-----------------------------------------
----  Helper functions
-----------------------------------------

------------------------------------------------
-- BASE_HOOKS
------------------------------------------------

function weapon:new()
    self.active = false
    self.weapon_in_list = false
    self.last_dir = 0
end

function weapon:attack()
    
end

function weapon:check_mobs()
    
end

function weapon:update()
    
end

function weapon:draw()
    
end


--debug function
function weapon:draw_range()
    
end
    

------------------------------------------------
-- MELEE
------------------------------------------------


--sword
function weapons.attack(weapon)
    print("test")
    print(weapon)
    
    if weapon_in_list ==false then
    weapon_ = weapon
    weapon.active = true
    weapon.angle_done = weapon.speed
    table.insert(update_list,weapon)
    print("attacking")
    weapon_in_list = true
    end
end




function weapons.check_mobs()
    print(mobs)
    for k,v in pairs(mobs) do
        --local angle =math.deg( math.angle(player.x,player.y,v.x,v.y))
        --print(math.deg(angle))
        
        --love.graphics.line(player.x,player.y,v.x,v.y)
        
        local heading =dir_to_angle()
        if heading == nil and weapon_.active == false then
            return
        end
        console.log("checking_mob")
        heading = (heading or weapon_.last_dir) or 0
        
        local x = weapon_.range*math.sin(math.rad(weapon_.angle_done-heading+weapon_.angle/2))+player.x
        local y = weapon_.range*math.cos(math.rad(weapon_.angle_done-heading+weapon_.angle/2))+player.y
        
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


function weapons.update()
    weapon_.angle_done = weapon_.angle_done+weapon_.speed
    
    --if weapon is done remove from list
    if weapon_.angle_done >= weapon_.angle then
        weapon_.active = false
        weapon_in_list = false
        table.remove(update_list,list_idx)
    end
end




function weapons.draw_range()
    
    local dir = dir_to_angle()
    
    if dir == nil and weapon_.active ==false then
       return 
    end
    
    dir = (dir or weapon_.last_dir) or 0
    print(dir)
    love.graphics.print(dir,0,100)
    local x = weapon_.range*math.sin(math.rad(weapon_.angle_done-dir+weapon_.angle/2))+scr_width/2-16
    local y = weapon_.range*math.cos(math.rad(weapon_.angle_done-dir+weapon_.angle/2))+scr_height/2-16
    
    love.graphics.line(scr_width/2-16,scr_height/2-16,x,y)
    love.graphics.arc( "line", scr_width/2-16, scr_height/2-16, weapon_.range, math.rad(dir-weapon_.angle/2), math.rad(dir+weapon_.angle/2) )
    
    weapon_.last_dir = dir
end



--weapon definitions
-- TODO: Add to own file later on, see sample in rogue
weapon_list.sword_1={
    name="sword_1",
    weapon_type="sword",
    demage = 1,
    speed = 1,
    active = false,
    range = 50,
    angle = 90,
    
   
}

return weapon