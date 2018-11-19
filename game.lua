--import of basic stuff 
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
local scr_width  = 0 
local scr_height = 0 
 
local gui ={} 
local crops = "" 
local fields ={ 
   
} 
 
local player={ 
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
local key_list ={} 
local bar_slot =1 
 
----------------------------------------------------------- 
-- special data fields for debugging / testing only 
----------------------------------------------------------- 
 
local debug = true 
local field_lines={} 
local slot_preview={} 
 
--TODO: setup callbacks 
local bar_cbs={ 
    [1]=base.tileField, 
    [2]=base.plantField, 
    [3]=base.sleep 
    } 
 
--------------------------------------------------------------------------------------------------- 
--base crop/field classes   
--------------------------------------------------------------------------------------------------- 
local Slot ={} 
 
--normal farm slot that can be tiled .... 
function Slot:new(x,y) 
  local tmp={} 
  tmp.state   = 0 
  tmp.crop    = 0 
  tmp.watered = false 
  tmp.tiled   = false 
   
  tmp.x = x 
  tmp.y = y 
   
  tmp.draw = function(self)  
    love.graphics.setColor(221,143,40) 
    love.graphics.rectangle("fill",self.x,self.y,32,32) 
    love.graphics.setBackgroundColor(0,0,0) 
    end 
  tmp.update = function() end 
   
  setmetatable(tmp, self) 
  self.__index = self 
   
  return tmp 
end 
 
--tiled farm slot  (hoed one) 
--has a wartered state 
local Tiled={} 
function Tiled:new(x,y) 
  local tmp ={} 
  tmp.state   = 0 
  tmp.crop    = 0 
  tmp.watered = false 
  tmp.tiled   = true 
 
  tmp.x = x 
  tmp.y = y 
 
  tmp.draw = function(self) 
    if self.watered == false then 
      love.graphics.setColor(164,100,34) 
      love.graphics.rectangle("fill",self.x,self.y,32,32) 
      --print("drawing...") 
    else 
      love.graphics.setColor(95,57,6) 
      love.graphics.rectangle("fill",self.x,self.y,32,32) 
    end 
  end 
   
  tmp.update = function() end 
   
  setmetatable(tmp, self) 
  self.__index = self 
   
  return tmp 
end 
 
 
 
local Crop={} 
function Crop:new(x,y,crop,water) 
  local tmp ={} 
  tmp.state   = 1 
  tmp.crop    = crop   
  tmp.watered = water or false 
  tmp.days_max =12 
  tmp.tps = math.floor(tmp.days_max/4) 
  tmp.time = 0 
   
  tmp.x = x 
  tmp.y = y 
 
  tmp.draw = function(self) 
    if self.watered == false then 
      draw.tile(crops,self.state,self.crop,x,y) 
    else 
      draw.tile(crops+1,self.state,self.crop,x,y) 
    end 
  end 
   
  tmp.update = function(self)  
      self.time= self.time +1 
      if self.time > self.tps and self.state <4 then 
        tmp.state = tmp.state+1 
        tmp.time = 0 
      end 
  end 
   
  setmetatable(tmp, self) 
  self.__index = self 
   
  return tmp 
end 
 
 
 
 
---------------------------------------------------------------------------- 
--Helper functions 
---------------------------------------------------------------------------- 
 
local function clamp(low, n, high) return math.min(math.max(low, n), high) end 
 
local function CheckPlayerForField() 
     
   field_lines={} 
   slot_preview={} 
    
   --get player vars 
   local mx,my =player.x,player.y 
    
    --right now only check fields and show outline if there :P 
    for idx,field in ipairs(fields) do 
       local x,y = field.x,field.y 
       local w,h = field.w,field.h 
        
        
        
       if mx >= x-20 and mx<= x+w*32 +20 and 
          my >= y-20 and my <= y+w*32 +20 then 
              --print("in field "..idx) 
           local width = w*32 --asuming tile size 32 
           local height = h*32 
           --get relative position 
           local x_r,y_r = player.x- x,player.y-y 
           local grid_x,grid_y = math.ceil(x_r/32),math.ceil(y_r/32) 
            
           --print(grid_x,grid_y) 
           if grid_x <=width and grid_y <= height then 
            table.insert(slot_preview,{id=idx,x=grid_x,y=grid_y}) 
           else 
               print("nopa copa") 
           end 
            
            
           table.insert(field_lines,idx) 
            
            
       end 
        
    end 
end 
 
 
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
local function check_keys2 (dt) 
    if love.keyboard.isDown(last_key) then 
        move[last_key]() 
      --print(dt.. "time") 
      local x,y =love.mouse.getPosition() 
      --update the mouse info,cause it could change its state without moving  
      --because the camera moved 
      game.MouseMoved(x,y) 
      timer_move = 0 
       
      CheckPlayerForField() 
    else 
      timer_move = timer_move +dt 
    end 
end 
 
local function check_keys (dt) 
     
    for key,value in pairs(key_list) do 
        move[key]() 
    end 
     
    local x,y =love.mouse.getPosition() 
    game.MouseMoved(x,y) 
     
       
    CheckPlayerForField() 
     
end 
---------------------------------------------------------------------------- 
--General mechanic functions 
---------------------------------------------------------------------------- 
 
 
-- x,y = start position of the field 
-- w,h = tiles on the field 
local function new_field(x,y,w,h) 
    local tmp ={} 
      
    tmp.pos={} 
    tmp.grid={} 
    tmp.x =x 
    tmp.y =y 
    tmp.w = w 
    tmp.h = h 
     
    for i=1,h do 
      tmp.grid[i]={} 
      for j=1,w do 
        tmp.grid[i][j] = Slot:new((j)*32+x -32,(i)*32+y -32) 
      end 
    end 
     
    return tmp 
end 
 
 
 
--test function to tile all the fields on a field 
--can later be changed to a single one and called when needed 
function base.tileField(field_idx) 
  local bx,by = fields[field_idx].x,fields[field_idx].y 
     
  for y,row in ipairs(fields[field_idx].grid) do 
    for x,spot in ipairs(row) do 
      fields[field_idx].grid[y][x] =Tiled:new(x*32+bx-32,y*32+by-32) 
    end 
  end 
end 
 
--test function for planting all slots in a field at once  
--with a specific seed 
--can later be adapted to only  plant one at once 
 function base.plantField(field_idx,seed_type) 
  local seed = seed_type or 1 
  local bx,by = fields[field_idx].x,fields[field_idx].y 
 
  for y,row in ipairs(fields[field_idx].grid) do 
    for x,spot in ipairs(row) do 
      fields[field_idx].grid[y][x] =Crop:new(x*32+bx-32,y*32+by-32,seed) 
    end 
  end 
end 
 
 
--function that updates all the fields 
--when the user is sleeping 
function base.sleep() 
    for i,field in ipairs(fields) do 
      for y,row in ipairs(field.grid) do 
        for x,spot in ipairs(row) do 
          if spot.state ~=0 then 
            fields[i].grid[y][x]:update() 
          end 
        end 
      end 
    end 
end 
 
local old_clicked=0 
function cb_handle(id,name) 
  if old_clicked+0.3 > love.timer.getTime() then 
    return 
  end 
   
  local id_cb_list={ 
    tileField, 
    plantField, 
    sleep, 
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
   
  crops = loader.loadTiles("assets/crops.png",32,32) 
  fields[1]=new_field(10,50,5,5) 
  fields[2]=new_field(10,10,5,5) 
  fields[3]=new_field(32*8,32*5,10,10) 
   
  bar_cbs={ 
      base.tileField, 
      base.plantField, 
      base.sleep 
      } 
   
  ui.init() 
  ui.AddClickHandle(cb_handle) 
   
  --setup the ui if not there 
  if ui.CountElements()==0 then 
      table:insert(ui.AddButton("tile",300,100,10,10)) 
      table:insert(ui.AddButton("plant",200,100,10,10)) 
      table:insert(ui.AddButton("sleep",400,100,10,10)) 
  else 
      for idx, id in ipairs(table) do 
          ui.SetSpecialCallback(id,cb_handle) 
      end 
  end 
   
  --cam base pos  
  cam:setPosition(player.x -scr_width/2 +32,player.y -scr_height/2+32) 
end 
 
 
function game.update(dt) 
  check_keys(dt) 
  ui.update() 
end 
 
 
 
function game.draw() 
  -------------------- 
  --start normal visu 
  -------------------- 
   
  cam:set() 
  --draw the fields 
  for idx,field in ipairs(fields) do 
    for i,row in ipairs(fields[idx].grid) do 
        for j,spot in ipairs(row) do 
          spot:draw() 
        end 
      end 
   end 
  --reset the color once .. 
  love.graphics.setColor(0xff,0xff,0xff) 
   
  ------------------- 
  --start debug visu (only when turned on) 
  ------------------ 
  if debug == true then 
     for idx, id in ipairs(field_lines) do 
         local x,y,w,h = fields[id].x,fields[id].y,fields[id].w,fields[id].h 
         love.graphics.rectangle("line",x,y,w*32,h*32) 
      end 
       
      for idx,data in ipairs(slot_preview) do 
        --print("Id: "..data.id) 
        --print("x: "..data.x.." y: "..data.y) 
        data.x = clamp(1,data.x,fields[data.id].w) 
        data.y = clamp(1,data.y,fields[data.id].h) 
        local slot = fields[data.id].grid[data.y][data.x] 
        love.graphics.rectangle("line",slot.x,slot.y,32,32) 
      end 
  end 
  cam:unset() 
   
   -- draw player 
  love.graphics.rectangle("fill",scr_width/2-32,scr_height/2-32,32,32) 
   
   
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
   
   
  ui.draw() 
end 
 
 
 
 
local key_lookup={ 
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
    bar_slot= key 
    print(bar_slot) 
  end 
   
end 
 
 
function game.MouseHandle(x,y,btn) 
    print(bar_cbs[bar_slot]) 
    bar_cbs[bar_slot]() 
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