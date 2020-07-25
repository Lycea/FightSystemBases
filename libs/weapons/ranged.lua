
ranged = weapons.base_weapon:extend()

function ranged:new()
    self.active = false
    self.weapon_in_list = false
    self.last_dir = {1,0}
end

function ranged:attack()
    
    local dir = dir_to_move_dir() or self.last_dir
    
    table.insert(particle_list,particles.base_particle(player.x+16,player.y+16,dir))
    self.last_dir = dir
end



function ranged:update()
    
end

function ranged:draw()
    
end


--debug function
function ranged:draw_range()
    
end

return ranged