--import of basic stuff 
require("libs.globals")

local loader =require("libs.loader") 
local draw =require("libs.drawer") 
local ids = require("libs.id_list") 
 
local ui = require("libs.SimpleUI.SimpleUI") 
local cam = require("libs.cam.camera") 

 
local game ={} 
 
 
--------------------------- 
--preinit functions? 
--------------------------- 
 
 
local base={} 
------------------------------------------------------------ 
--Base data fields 
------------------------------------------------------------ 
 
--screen params, needed for some placements (and camera ?) 
 scr_width  = 0 
 scr_height = 0 
 
local gui ={} 
local crops = "" 
local tools = ""
local fields ={ 
   
} 
 
player={ 
    x=200, 
    y=200, 
    speed=3 
} 
 
 
local dir_look ={ 
    left = {-1,0}, 
    right = {1,0}, 
    up = {0,-1}, 
    down = {0,1}, 
    } 
------------------------ 
-- dynamic data 
------------------------ 
 
local last_key="space" 
 key_list ={} 
local bar_slot ="1"
 
----------------------------------------------------------- 
-- special data fields for debugging / testing only 
----------------------------------------------------------- 
 
local debug = true 
local field_lines={} 
local slot_preview={} 
 
--TODO: setup callbacks 
local bar_items = {
    weapons.sword_1
    }
local bar_cbs={ 
    weapons.attack
    } 
 
--------------------------------------------------------------------------------------------------- 
--base crop/field classes   
--------------------------------------------------------------------------------------------------- 

 
 
---------------------------------------------------------------------------- 
--Helper functions 
---------------------------------------------------------------------------- 
 
local function clamp(low, n, high) return math.min(math.max(low, n), high) end 
 

 
 
----------------- 
---key functions 
----------------- 
local move={ 
    left = function() 
        player.x= player.x -player.speed 
        cam:move(-player.speed) 
    end, 
     
    right = function() 
        player.x= player.x +player.speed 
        cam:move(player.speed) 
    end, 
     
    up=function() 
        player.y= player.y -player.speed 
        cam:move(0,-player.speed) 
    end, 
     
    down = function() 
        player.y= player.y +player.speed 
        cam:move(0,player.speed) 
    end 
     
} 
 
local timer_move = 0 

 
local function check_keys (dt) 
     
    for key,value in pairs(key_list) do 
        move[key]() 
    end 
     
    local x,y =love.mouse.getPosition() 
    game.MouseMoved(x,y) 
     
end 
---------------------------------------------------------------------------- 
--General mechanic functions 
---------------------------------------------------------------------------- 

 
local old_clicked=0 
function cb_handle(id,name) 
  if old_clicked+0.3 > love.timer.getTime() then 
    return 
  end 
   
  local id_cb_list={ 
    base.tileField, 
    base.plantField, 
    base.sleep, 
  } 
   
   
  --print(id) 
  --print(id_cb_list[id]) 
  id_cb_list[id](1) 
  old_clicked =love.timer.getTime() 
   
end 
 
 
local ui_elements_list = 3 
 
function game.load() 
   
  scr_width,scr_height = love.graphics.getDimensions() 
  player.x =0 
  player.y =0 
   
 
   
  --cam base pos  
  cam:setPosition(player.x -scr_width/2 +32,player.y -scr_height/2+32) 
  
  mob:new(50,50)
  mob:new(100,100)
  console.setPos(scr_width-250,0)
  console.setSize(250,200)
end 
 
 
function game.update(dt) 
  check_keys(dt) 
  process_list()
  ui.update() 
end 
 
 
 
function game.draw() 
  -------------------- 
  --start normal visu 
  -------------------- 
   
  cam:set() 
  --draw the fields 
  for k,v in pairs(mobs)do
        
        v:draw()
        v:update(k)
  end
  
  
  --reset the color once .. 
  love.graphics.setColor(0xff,0xff,0xff) 
   
  ------------------- 
  --start debug visu (only when turned on) 
  ------------------ 
  if debug == true then 

  end 
  cam:unset() 
   
   -- draw player 
  love.graphics.rectangle("fill",scr_width/2-32,scr_height/2-32,32,32) 
  draw_list()
   
  --TODO: Put item bar in seperate class for handling 
  -- draw "item bar" 
  local tool_bar_w = scr_width -2*50 
  love.graphics.rectangle("line",50,scr_height-64,scr_width-100,60) 
   
  local ppi = math.floor(tool_bar_w/10) 
  for i=1,10 do 
    local line_x =50+ppi*i 
    love.graphics.line(line_x,scr_height-64,line_x,scr_height-4) 
  end 
   
  love.graphics.print(bar_slot,0,0) 
  if bar_slot == "0" then 
      local pos_x = ppi*10-20 
    love.graphics.rectangle("line",pos_x +4,scr_height-60,ppi-8,52) 
  else 
    local pos_x = ppi*bar_slot -20 
     
    love.graphics.rectangle("line",pos_x +4,scr_height-60,ppi-8,52) 
  end 
   
   draw_list()
   
   test_drawer()
  console.draw()
  --ui.draw() 
end 
 
 
 
 
 key_lookup={ 
    left=true, 
    up=true, 
    down=true, 
    right=true 
    } 
 
function game.keyHandle2(key,s,r) 
  if key == "left" or key == "right" or key == "up" or key == "down" then 
    last_key = key 
    return 
  end 
   
  --get the numbers 
   
  if tonumber(key) then  
    bar_slot= key 
    print(bar_slot) 
  end 
   
end 
 
function game.keyHandle(key,s,r,pressed_) 
  if key_lookup[key]==true then 
    if pressed_ == true then 
        last_key = key 
        key_list[key]=true 
    else 
        key_list[key]=nil 
    end 
      for k,v in pairs(key_list) do 
          print(k,v) 
      end 
      print("----") 
      
     return 
  end 
   
  --get the numbers 
  if tonumber(key) then  
    bar_slot= tonumber(key) 
    print(bar_slot) 
    return
  end 
  
  if key == "a" then game.MouseHandle(0,0,1) end
   
end 
 
 local clicked_start=0
function game.MouseHandle(x,y,btn,release) 
    if btn == 1 then
        for key,val in pairs(weapons) do
            print(key,value)
        end
        
        for key,val in pairs(bar_cbs) do
            print(key,value)
        end
        print("----")
        print(bar_slot)
        print(bar_cbs[tonumber(bar_slot)]) 
        print(bar_items[tonumber(bar_slot)].name)
        
        
        print("----")
        bar_cbs[tonumber(bar_slot)](bar_items[tonumber(bar_slot)])
    end
end 
 
function game.MouseMoved(mx,my) 
     
    if run then 
        field_lines={} 
        
        
       mx,my =cam:CoordWithoutCam(mx,my) 
        --right now only check fields and show outline if there :P 
        for idx,field in ipairs(fields) do 
           local x,y = field.x,field.y 
           local w,h = field.w,field.x 
            
           if mx >= x and mx<= x+w*32 and 
              my >= y and my <= y+w*32 then 
                  --print("in field "..idx) 
               table.insert(field_lines,idx) 
           end 
            
        end 
    end 
end 
 
 
game.load() 
return game