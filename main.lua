game =require("game")
l = require("libs.extern.lurker")

local classes = require("libs.extern.classic")

base_class= classes:extend()

function love.load(args)
  require("mobdebug").start()
  
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
  game.keyHandle(k,s,r,true)
end

function love.keyreleased(k)
    game.keyHandle(k,0,0,false)
end

function love.mousepressed(x,y,btn,t)
  game.MouseHandle(x,y,btn,t,false)
end

function love.mousereleased(x,y,btn)
  game.MouseHandle(x,y,btn,t,true)
end


function love.mousemoved(x,y,dx,dy)
    game.MouseMoved(x,y)
end