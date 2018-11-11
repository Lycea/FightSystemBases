local  Bar = {}
 
 
 function Bar:new (o,x,y,w,h,s)
      o = o or {}   -- create object if user does not provide one
      o.name = "ToolBar"
 
      o.x = x
      o.y = y
      o.w = w
      o.h = h
      o.s = s
      o._slots = {}
      o.pps = math.floor(o.w/o.s)
      
      setmetatable(o, self)
      self.__index = self
      
      return o
end

function Bar.setItem(obj,slot_num,img)
    ob.__slots[slot_num] =img
end

function Bar.draw()
    
end
    

function Bar.update(dt)
    
end



return Bar