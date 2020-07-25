local BASE = (...)..'.' 
print(BASE)
local i= BASE:find("globals.$")
print (i)
BASE=BASE:sub(1,i-1)



particles={
    base_particle = require(BASE.."particles.base_particle")
    }

weapons = {base_weapon=require(BASE.."weapons.weapons")}
weapons.sword = require(BASE.."weapons.sword")
weapons.ranged = require(BASE.."weapons.ranged")
require(BASE.."mobs")
console = require(BASE.."console")
test_string = "test string test"

power = 0

--list of enteties to update ...
update_list={}
list_idx=1
key_list={}

mobs={}
player={}
----------------------------------------
function test_drawer()
    love.graphics.print(test_string,0,30)
end

function process_list()
    print("---\nto process")
    for k,v in pairs(update_list)do
        list_idx = key
        print(v)
        for ke,ve in pairs(v) do
            print(ke)
            
        end
        print(v.name)
        v.delete_me = v:update() 
        
    end
end

function draw_list()
    
    for k,v in pairs(particle_list)do
        v:check_mobs()
    end
    
    
    for k,v in pairs(update_list)do
        list_idx = key
        print(v)

        
        v:draw()
        v:check_mobs()
        
        if v.delete_me ==true then
           table.remove(update_list,k) 
        end
    end
    
    
    
    
end



------------------------------------------------
stater={}
stater.states ={}

function stater.set(state,data)
    stater.states[state]=data
end

function stater.get(state)
    return stater.states[state] or "n/v"
end

function stater.list()
    return table.concat(stater.stats,"\n")
end




