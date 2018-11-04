local loader =require("libs.loader")
local draw =require("libs.drawer")
local ids = require("libs.id_list")

local ui = require("libs.SimpleUI.SimpleUI")

local game ={}



local gui ={}
local crops = ""
local fields ={
  
  }

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
      print("drawing...")
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
      print("drawing...")
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


-- x,y = start position of the field
-- w,h = tiles on the field
local function new_field(x,y,w,h)
    local tmp ={}
     
    tmp.pos={}
    tmp.grid={}
    tmp.x = x
    tmp.y =y
    tmp.w = w
    tmp.h = h
    
    for i=1,h do
      tmp.grid[i]={}
      for j=1,w do
        tmp.grid[i][j] = Slot:new(j*32,i*32)
      end
    end
    
    return tmp
end


local function tileField(field_idx)
  for y,row in ipairs(fields[field_idx].grid) do
    for x,spot in ipairs(row) do
      fields[field_idx].grid[y][x] =Tiled:new(y*32,x*32)
    end
  end
end


local function plantField(field_idx)
  for y,row in ipairs(fields[field_idx].grid) do
    for x,spot in ipairs(row) do
      fields[field_idx].grid[y][x] =Crop:new(y*32,x*32,1)
    end
  end
end


local function sleep()
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
    sleep
  }
  
  
  print(id)
  print(id_cb_list[id])
  id_cb_list[id](1)
  old_clicked =love.timer.getTime()
  
end

function game.load()
  
  crops = loader.loadTiles("assets/crops.png",32,32)
  fields[1]=new_field(100,100,5,5)
  
  ui.init()
  ui.AddClickHandle(cb_handle)
  
  table:insert(ui.AddButton("tile",300,100,10,10))
  table:insert(ui.AddButton("plant",200,100,10,10))
  table:insert(ui.AddButton("sleep",400,100,10,10))
  
end


function game.update()
  --print("test")
  ui.update()
end



function game.draw()
 for i,row in ipairs(fields[1].grid) do
    for j,spot in ipairs(row) do
      spot:draw()
    end
  end
  
  ui.draw()
end


function game.keyHandle(k,s,r)
  
end


game.load()

return game
