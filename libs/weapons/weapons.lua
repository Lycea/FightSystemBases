weapons={}
ranged={}

weapon_ = 0

local weapon_in_list = false



local dirs={w=1,s=3,a=4,d=2}
local angles ={[2]=-90,[4]=0,[8]=90,[16]=180,
    [6]=-45,--top_right
    [12] =45,--bottom_right
    [24] =135,--bottom-left
    [18] =-135
}



--local type_lookup={"sword"=weapons,"ranged"=""}


-----------------------------------------
----  Helper functions
-----------------------------------------
local function dir_to_angle()
    
    local dir = 0
    local added  = 0
    for k,v in pairs(key_list)do
        
        dir = dir+ math.pow(2,dirs[k])
        added = added +1
    end
    
    if added ~= 0 then
        print(angles[dir])
        dir =angles[dir]
    else 
        dir = nil
    end
    return dir
    
end

--distance between two points
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

--angle between two points
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end


local function pointInCircle(point,circle)
    return math.dist(point.x,point.y,circle.x,circle.y) < circle.r
end

local function pointOnLine(x1,y1,x2,y2,px,py)
    local line_len = math.dist(x1,y1,x2,y2)
    local buff=0.1
    local dist1 =math.dist(px,py,x2,y2)
    local dist2 =math.dist(px,py,x1,y1)
    
    if dist1+dist2 >= line_len-buff and 
       dist1+dist2 <=line_len+buff then
        return true
    else
        return false
    end
end
------------------------------------------------
-- BASE_HOOKS
------------------------------------------------



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
    weapon_in_list = truef
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


weapons.sword_1={
    name="sword_1",
    weapon_type="sword",
    demage = 1,
    speed = 1,
    active = false,
    range = 50,
    angle = 90,
    
   
}

return weapons