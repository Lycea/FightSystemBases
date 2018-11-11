local drawer ={}

function drawer.map(table)
  
  
end

function drawer.tile(set,idx,idy,x,y)
  --print("row: "..idy)
  --print("frame: "..idx)
  --print(set)
  love.graphics.draw(set.image,set[idy][idx],x,y)
  love.graphics.rectangle("fill",0,0,20,20)
end

return drawer
