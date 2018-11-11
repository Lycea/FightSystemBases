game =require("game")
l = require("libs.lurker")

function love.load(args)
  --require("mobdebug").start()
  
  game.load()
  
end


function love.update(dt)
  game.update(dt)
  
  
end

function love.draw()
  game.draw()
  
  l.update()

  
  --print("test")
end


function love.keypressed(k,s,r)
  game.keyHandle(k,s,r)
end

function love.keyreleased(k)
    
end

function love.mousepressed(x,y,btn,t)
  game.MouseHandle(x,y,btn,t)
end

function love.mousemoved(x,y,dx,dy)
    game.MouseMoved(x,y)
end

