game =require("game")
l = require("libs.lurker")

function love.load(args)
  --require("mobdebug").start()
  
  game.load()
  
end


function love.update(dt)
  game.update()
  
  
end

function love.draw()
  game.draw()
  
  l.update()
  changed =l.getchanged()
  
  
  for i,file in ipairs(changed) do
   print(i.."  "..file) 
   if file == "game.lua" then
     print("changed...")
      game.load()
   end
   
  end
  
  --print("test")
end


function love.keypressed(k,s,r)
  game.keyHandle(k,s,r)
end
