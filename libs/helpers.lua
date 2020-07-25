local dirs={w=1,s=3,a=4,d=2}
local angles ={[2]=-90,[4]=0,[8]=90,[16]=180,
    [6]=-45,--top_right
    [12] =45,--bottom_right
    [24] =135,--bottom-left
    [18] =-135
}


function dir_to_angle()

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


function pointInCircle(point,circle)
    return math.dist(point.x,point.y,circle.x,circle.y) < circle.r
end

function pointOnLine(x1,y1,x2,y2,px,py)
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